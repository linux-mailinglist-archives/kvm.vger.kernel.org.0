Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ADB1ED6F0
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 21:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFCTf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 15:35:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgFCTf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 15:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591212924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kdPkXIXWB+u8KkGNeY7ldFSPiBFDc8t2oJd3Oo4z+zQ=;
        b=bo/9NYZyWr1QkhghbLRT7lloJppf0+kfSyKzavFDNaafZu6NwI3zsV75eaPILNS2rMSg+w
        5JI8nN50bVyV44dsVvd0XIBspJGY3AOdGIp6B2iQuAmHyiTjqhmwFRTliFDDW5bB0wbsLw
        xhS+kaRnxo87NpDjXLtWC2JhmKcP/7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-FCnJiB9dPhCWcsrWi1vtNA-1; Wed, 03 Jun 2020 15:35:22 -0400
X-MC-Unique: FCnJiB9dPhCWcsrWi1vtNA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360A8800685;
        Wed,  3 Jun 2020 19:35:21 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-173.rdu2.redhat.com [10.10.115.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2F628926B;
        Wed,  3 Jun 2020 19:35:20 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 399F6220C5A; Wed,  3 Jun 2020 15:35:20 -0400 (EDT)
Date:   Wed, 3 Jun 2020 15:35:20 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] KVM: x86: extend struct kvm_vcpu_pv_apf_data
 with token info
Message-ID: <20200603193520.GB48122@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-3-vkuznets@redhat.com>
 <20200526182745.GA114395@redhat.com>
 <875zcg4fi9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zcg4fi9.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 10:42:38AM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, May 25, 2020 at 04:41:17PM +0200, Vitaly Kuznetsov wrote:
> >> 
> >
> > [..]
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 0a6b35353fc7..c195f63c1086 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -767,7 +767,7 @@ struct kvm_vcpu_arch {
> >>  		u64 msr_val;
> >>  		u32 id;
> >>  		bool send_user_only;
> >> -		u32 host_apf_reason;
> >> +		u32 host_apf_flags;
> >
> > Hi Vitaly,
> >
> > What is host_apf_reason used for. Looks like it is somehow used in
> > context of nested guests. I hope by now you have been able to figure
> > it out.
> >
> > Is it somehow the case of that L2 guest takes a page fault exit
> > and then L0 injects this event in L1 using exception. I have been
> > trying to read this code but can't wrap my head around it.
> >
> > I am still concerned about the case of nested kvm. We have discussed
> > apf mechanism but never touched nested part of it. Given we are
> > touching code in nested kvm part, want to make sure it is not broken
> > in new design.
> >
> 
> Sorry I missed this.
> 
> I think we've touched nested topic a bit already:
> https://lore.kernel.org/kvm/87lfluwfi0.fsf@vitty.brq.redhat.com/
> 
> But let me try to explain the whole thing and maybe someone will point
> out what I'm missing.

Hi Vitaly,

Sorry, I got busy in some other things. Got back to it now. Thanks for
the explanation. I think I understand it up to some extent now.

Vivek

> 
> The problem being solved: L2 guest is running and it is hitting a page
> which is not present *in L0* and instead of pausing *L1* vCPU completely
> we want to let L1 know about the problem so it can run something else
> (e.g. another guest or just another application).
> 
> What's different between this and 'normal' APF case. When L2 guest is
> running, the CPU (physical) is in 'guest' mode so we can't inject #PF
> there. Actually, we can but L2 may get confused and we're not even sure
> it's L2's fault, that L2 supported APF and so on. We want to make L1
> deal with the issue.
> 
> How does it work then. We inject #PF and L1 sees it as #PF VMEXIT. It
> needs to know about APF (thus KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT) but
> the handling is exactly the same as do_pagefault(): L1's
> kvm_handle_page_fault() checkes APF area (shared between L0 and L1) and
> either pauses a task or resumes a previously paused one. This can be a
> L2 guest or something else.
> 
> What is 'host_apf_reason'. It is a copy of 'reason' field from 'struct
> kvm_vcpu_pv_apf_data' which we read upon #PF VMEXIT. It indicates that
> the #PF VMEXIT is synthetic.
> 
> How does it work with the patchset: 'page not present' case remains the
> same. 'page ready' case now goes through interrupts so it may not get
> handled immediately. External interrupts will be handled by L0 in host
> mode (when L2 is not running). For the 'page ready' case L1 hypervisor
> doesn't need any special handling, kvm_async_pf_intr() irq handler will
> work correctly.
> 
> I've smoke tested this with VMX and nothing immediately blew up.
> 
> -- 
> Vitaly
> 

