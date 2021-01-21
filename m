Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410942FF149
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbhAURCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387662AbhAURCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHUBImslCfwg00guChsEavbd7sCyVGiqiWBeO3xrKQQ=;
        b=JWRW94A4vmq1G8MqQuImEQR8N3qyKavAw9eHjeZINNu21w2QPbmqK2NlHj0Ngcb/CRZamb
        Oa6eASt9SyP8fEUft3QCdYb28jGAgwbnqYVNKV1ZjYXt26WJThonxmB+2GdajXDZ/IIFTd
        mWZH7y4Q0U7ETOKaLsHULk+hCI6zqFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-_NQY7GI2N5SYMSTnmwzfEQ-1; Thu, 21 Jan 2021 12:00:52 -0500
X-MC-Unique: _NQY7GI2N5SYMSTnmwzfEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A19C8066E7;
        Thu, 21 Jan 2021 17:00:50 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B949F648A8;
        Thu, 21 Jan 2021 17:00:46 +0000 (UTC)
Message-ID: <073961282a8dad53bd5923bec2bf3df0b8b9975e.camel@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume
 tracepoint
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jan 2021 19:00:45 +0200
In-Reply-To: <YAHDIJMACMBnboIZ@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
         <20210114205449.8715-3-mlevitsk@redhat.com> <YADeT8+fssKw3SSi@google.com>
         <18c386f2-a588-6324-fcde-d13b66f66d4f@redhat.com>
         <YAHDIJMACMBnboIZ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-01-15 at 08:30 -0800, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Paolo Bonzini wrote:
> > On 15/01/21 01:14, Sean Christopherson wrote:
> > > > +	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),
> > > Hmm, won't this RIP be wrong for the migration case?  I.e. it'll be L2, not L1
> > > as is the case for the "true" nested VM-Enter path.
> > 
> > It will be the previous RIP---might as well be 0xfffffff0 depending on what
> > userspace does.  I don't think you can do much better than that, using
> > vmcs12->host_rip would be confusing in the SMM case.
> > 
> > > > +					 vmx->nested.current_vmptr,
> > > > +					 vmcs12->guest_rip,
> > > > +					 vmcs12->vm_entry_intr_info_field);
> > > The placement is a bit funky.  I assume you put it here so that calls from
> > > vmx_set_nested_state() also get traced.  But, that also means
> > > vmx_pre_leave_smm() will get traced, and it also creates some weirdness where
> > > some nested VM-Enters that VM-Fail will get traced, but others will not.
> > > 
> > > Tracing vmx_pre_leave_smm() isn't necessarily bad, but it could be confusing,
> > > especially if the debugger looks up the RIP and sees RSM.  Ditto for the
> > > migration case.
> > 
> > Actually tracing vmx_pre_leave_smm() is good, and pointing to RSM makes
> > sense so I'm not worried about that.
> 
> Ideally there would something in the tracepoint to differentiate the various
> cases.  Not that the RSM/migration cases will pop up often, but I think it's an
> easily solved problem that could avoid confusion.
> 
> What if we captured vmx->nested.smm.guest_mode and from_vmentry, and explicitly
> record what triggered the entry?
> 
> 	TP_printk("from: %s rip: 0x%016llx vmcs: 0x%016llx nrip: 0x%016llx intr_info: 0x%08x",
> 		  __entry->vmenter ? "VM-Enter" : __entry->smm ? "RSM" : "SET_STATE",
> 		  __entry->rip, __entry->vmcs, __entry->nested_rip,
> 		  __entry->entry_intr_info

I think that this is a good idea, but should be done in a separate patch.

> 
> Side topic, can we have an "official" ruling on whether KVM tracepoints should
> use colons and/or commas? And probably same question for whether or not to
> prepend zeros.  E.g. kvm_entry has "vcpu %u, rip 0x%lx" versus "rip: 0x%016llx
> vmcs: 0x%016llx".  It bugs me that we're so inconsistent.
> 

As I said the kvm tracing has a lot of things that can be imporoved, 
and as it is often the only way to figure out complex bugs as these I had to deal with recently,
I will do more improvements in this area as time permits.

Best regards,
	Maxim Levitsky



