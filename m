Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4B91CF6FA
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgELOYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 10:24:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725929AbgELOYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 10:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589293456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rta++qhDfwHbNQPLC3jIQSmkkWYOT6LPIvrsHbdiOLU=;
        b=DUIj8TCnY/GTQs+MxsWA/PAKq7pJoLs9Aru3stSt10RY7gTRSPulHnhBXKHTO+LjitTx0z
        zLHtPuiuGc/CrmOlpmCVRc15ks7R/x0bjXfCDmp/5kWmAddTdEys1NaXaZrtCa6wexA7yH
        xoDsnPeMAt3MZiwYERC9PZp71mOANjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-Mkpv2CQyN9anDTg0c93Sgw-1; Tue, 12 May 2020 10:24:14 -0400
X-MC-Unique: Mkpv2CQyN9anDTg0c93Sgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DAF3107B0EF;
        Tue, 12 May 2020 14:24:12 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA3FA62A28;
        Tue, 12 May 2020 14:24:11 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7B734220C05; Tue, 12 May 2020 10:24:11 -0400 (EDT)
Date:   Tue, 12 May 2020 10:24:11 -0400
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
Subject: Re: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200512142411.GA138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511164752.2158645-5-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 06:47:48PM +0200, Vitaly Kuznetsov wrote:
> Concerns were expressed around APF delivery via synthetic #PF exception as
> in some cases such delivery may collide with real page fault. For type 2
> (page ready) notifications we can easily switch to using an interrupt
> instead. Introduce new MSR_KVM_ASYNC_PF_INT mechanism and deprecate the
> legacy one.
> 
> One notable difference between the two mechanisms is that interrupt may not
> get handled immediately so whenever we would like to deliver next event
> (regardless of its type) we must be sure the guest had read and cleared
> previous event in the slot.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/msr.rst       | 91 +++++++++++++++++---------
>  arch/x86/include/asm/kvm_host.h      |  4 +-
>  arch/x86/include/uapi/asm/kvm_para.h |  6 ++
>  arch/x86/kvm/x86.c                   | 95 ++++++++++++++++++++--------
>  4 files changed, 140 insertions(+), 56 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..f988a36f226a 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -190,35 +190,54 @@ MSR_KVM_ASYNC_PF_EN:
>  	0x4b564d02
>  
>  data:
> -	Bits 63-6 hold 64-byte aligned physical address of a
> -	64 byte memory area which must be in guest RAM and must be
> -	zeroed. Bits 5-3 are reserved and should be zero. Bit 0 is 1
> -	when asynchronous page faults are enabled on the vcpu 0 when
> -	disabled. Bit 1 is 1 if asynchronous page faults can be injected
> -	when vcpu is in cpl == 0. Bit 2 is 1 if asynchronous page faults
> -	are delivered to L1 as #PF vmexits.  Bit 2 can be set only if
> -	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID.
> -
> -	First 4 byte of 64 byte memory location will be written to by
> -	the hypervisor at the time of asynchronous page fault (APF)
> -	injection to indicate type of asynchronous page fault. Value
> -	of 1 means that the page referred to by the page fault is not
> -	present. Value 2 means that the page is now available. Disabling
> -	interrupt inhibits APFs. Guest must not enable interrupt
> -	before the reason is read, or it may be overwritten by another
> -	APF. Since APF uses the same exception vector as regular page
> -	fault guest must reset the reason to 0 before it does
> -	something that can generate normal page fault.  If during page
> -	fault APF reason is 0 it means that this is regular page
> -	fault.
> -
> -	During delivery of type 1 APF cr2 contains a token that will
> -	be used to notify a guest when missing page becomes
> -	available. When page becomes available type 2 APF is sent with
> -	cr2 set to the token associated with the page. There is special
> -	kind of token 0xffffffff which tells vcpu that it should wake
> -	up all processes waiting for APFs and no individual type 2 APFs
> -	will be sent.
> +	Asynchronous page fault (APF) control MSR.
> +
> +	Bits 63-6 hold 64-byte aligned physical address of a 64 byte memory area
> +	which must be in guest RAM and must be zeroed. This memory is expected
> +	to hold a copy of the following structure::
> +
> +	  struct kvm_vcpu_pv_apf_data {
> +		__u32 reason;
> +		__u32 pageready_token;
> +		__u8 pad[56];
> +		__u32 enabled;
> +	  };
> +
> +	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
> +	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
> +	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
> +	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
> +	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
> +	present in CPUID. Bit 3 enables interrupt based delivery of type 2
> +	(page present) events.

Hi Vitaly,

"Bit 3 enables interrupt based delivery of type 2 events". So one has to
opt in to enable it. If this bit is 0, we will continue to deliver
page ready events using #PF? This probably will be needed to ensure
backward compatibility also.

> +
> +	First 4 byte of 64 byte memory location ('reason') will be written to
> +	by the hypervisor at the time APF type 1 (page not present) injection.
> +	The only possible values are '0' and '1'.

What do "reason" values "0" and "1" signify?

Previously this value could be 1 for PAGE_NOT_PRESENT and 2 for
PAGE_READY. So looks like we took away reason "PAGE_READY" because it will
be delivered using interrupts.

But that seems like an opt in. If that's the case, then we should still
retain PAGE_READY reason. If we are getting rid of page_ready using
#PF, then interrupt based deliver should not be optional. What am I
missing.

Also previous text had following line.

"Guest must not enable interrupt before the reason is read, or it may be
 overwritten by another APF".

So this is not a requirement anymore?

> Type 1 events are currently
> +	always delivered as synthetic #PF exception. During delivery of type 1
> +	APF CR2 register contains a token that will be used to notify the guest
> +	when missing page becomes available. Guest is supposed to write '0' to
> +	the location when it is done handling type 1 event so the next one can
> +	be delivered.
> +
> +	Note, since APF type 1 uses the same exception vector as regular page
> +	fault, guest must reset the reason to '0' before it does something that
> +	can generate normal page fault. If during a page fault APF reason is '0'
> +	it means that this is regular page fault.
> +
> +	Bytes 5-7 of 64 byte memory location ('pageready_token') will be written
> +	to by the hypervisor at the time of type 2 (page ready) event injection.
> +	The content of these bytes is a token which was previously delivered as
> +	type 1 event. The event indicates the page in now available. Guest is
> +	supposed to write '0' to the location when it is done handling type 2
> +	event so the next one can be delivered. MSR_KVM_ASYNC_PF_INT MSR
> +	specifying the interrupt vector for type 2 APF delivery needs to be
> +	written to before enabling APF mechanism in MSR_KVM_ASYNC_PF_EN.

What is supposed to be value of "reason" field for type2 events. I
had liked previous values "KVM_PV_REASON_PAGE_READY" and
"KVM_PV_REASON_PAGE_NOT_PRESENT". Name itself made it plenty clear, what
it means. Also it allowed for easy extension where this protocol could
be extended to deliver other "reasons", like error.

So if we are using a common structure "kvm_vcpu_pv_apf_data" to deliver
type1 and type2 events, to me it makes sense to retain existing
KVM_PV_REASON_PAGE_READY and KVM_PV_REASON_PAGE_NOT_PRESENT. Just that
in new scheme of things, KVM_PV_REASON_PAGE_NOT_PRESENT will be delivered
using #PF (and later possibly using #VE) and KVM_PV_REASON_PAGE_READY
will be delivered using interrupt.

> +
> +	Note, previously, type 2 (page present) events were delivered via the
> +	same #PF exception as type 1 (page not present) events but this is
> +	now deprecated.

> If bit 3 (interrupt based delivery) is not set APF events are not delivered.

So all the old guests which were getting async pf will suddenly find
that async pf does not work anymore (after hypervisor update). And
some of them might report it as performance issue (if there were any
performance benefits to be had with async pf).

[..]
>  
>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> +	if (!kvm_pv_async_pf_enabled(vcpu))
>  		return true;

What does above mean. If async pf is not enabled, then it returns true,
implying one can inject async page present. But if async pf is not
enabled, there is no need to inject these events.

Thanks
Vivek

