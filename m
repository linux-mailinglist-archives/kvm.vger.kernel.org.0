Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C701CF9D7
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgELPxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:53:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48281 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727847AbgELPxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589298823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=12YTEk/sqwvmTK3Y5qvGAKQ+4UZ0obOPFvJEZJMJP34=;
        b=ej0onNXxsEFbKOSprWI2tLzMz4K3Jz84+Mj1j99oAM8BFLQRPxK12uiAuUH8Sh4dqQC0YG
        o3hEMKNCCUwGO6Y049COn3q3ghfwM5A/bx4UdofgnHfhY/P6tPHiZg93cF2jd9Rm2bDpwB
        lqOPgTrv1dVUFLWsJx1U20KLmc0+CXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-WzQueWbcNdqkDSzcwG8RIg-1; Tue, 12 May 2020 11:53:42 -0400
X-MC-Unique: WzQueWbcNdqkDSzcwG8RIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C038107ACF2;
        Tue, 12 May 2020 15:53:40 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7F885C1B2;
        Tue, 12 May 2020 15:53:39 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 76964220C05; Tue, 12 May 2020 11:53:39 -0400 (EDT)
Date:   Tue, 12 May 2020 11:53:39 -0400
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
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200512155339.GD138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8qtmaat.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 05:40:10PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, May 11, 2020 at 06:47:46PM +0200, Vitaly Kuznetsov wrote:
> >> Currently, APF mechanism relies on the #PF abuse where the token is being
> >> passed through CR2. If we switch to using interrupts to deliver page-ready
> >> notifications we need a different way to pass the data. Extent the existing
> >> 'struct kvm_vcpu_pv_apf_data' with token information for page-ready
> >> notifications.
> >> 
> >> The newly introduced apf_put_user_ready() temporary puts both reason
> >> and token information, this will be changed to put token only when we
> >> switch to interrupt based notifications.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
> >>  arch/x86/kvm/x86.c                   | 17 +++++++++++++----
> >>  2 files changed, 15 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> >> index 2a8e0b6b9805..e3602a1de136 100644
> >> --- a/arch/x86/include/uapi/asm/kvm_para.h
> >> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> >> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
> >>  
> >>  struct kvm_vcpu_pv_apf_data {
> >>  	__u32 reason;
> >> -	__u8 pad[60];
> >> +	__u32 pageready_token;
> >
> > How about naming this just "token". That will allow me to deliver error
> > as well. pageready_token name seems to imply that this will always be
> > successful with page being ready.
> >
> > And reason will tell whether page could successfully be ready or
> > it was an error. And token will help us identify the task which
> > is waiting for the event.
> 
> I added 'pageready_' prefix to make it clear this is not used for 'page
> not present' notifications where we pass token through CR2. (BTW
> 'reason' also becomes a misnomer because we can only see
> 'KVM_PV_REASON_PAGE_NOT_PRESENT' there.)

Sure. I am just trying to keep names in such a way so that we could
deliver more events and not keep it too tightly coupled with only
two events (page not present, page ready).

> 
> I have no strong opinion, can definitely rename this to 'token' and add
> a line to the documentation to re-state that this is not used for type 1
> events.

I don't even know why are we calling "type 1" and "type 2" event. Calling
it KVM_PV_REASON_PAGE_NOT_PRESENT  and KVM_PV_REASON_PAGE_READY event
is much more intuitive. If somebody is confused about how event will
be delivered, that could be part of documentation. And "type1" and "type2"
does not say anything about delivery method anyway.

Also, type of event should not necessarily be tied to delivery method.
For example if we end up introducing say, "KVM_PV_REASON_PAGE_ERROR", then
I would think that event can be injected both using exception (#PF or #VE)
as well as interrupt (depending on state of system).

Thanks
Vivek

