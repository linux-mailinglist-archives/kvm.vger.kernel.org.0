Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DA5173260
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 09:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1IBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 03:01:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgB1IBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 03:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582876875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueyhvlxrNpEdCiXywzV8lAgxSMlEvR4KHrhckvM0+qk=;
        b=fX7Ya1M2yCEMWyAPaVvmpXC/b0y0Zv2rSYMxIARgsWPx2J1BSnA7cYYwHf+k/gzzoavrCx
        uEndC91EpIGWloThFZRpz5SkrQCAIRT0qBCqrmCtEGM6mgslI4gYhthngAKDmx/T7i861A
        grTktEgllyT7AL9GrEOUVNi2InVd6Lw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-DIj7nl6cODOFacjeZUu9NA-1; Fri, 28 Feb 2020 03:01:13 -0500
X-MC-Unique: DIj7nl6cODOFacjeZUu9NA-1
Received: by mail-wr1-f69.google.com with SMTP id n23so977705wra.20
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 00:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ueyhvlxrNpEdCiXywzV8lAgxSMlEvR4KHrhckvM0+qk=;
        b=lusCdVPodcc8GlRjLUM7Bt4OEDqDBUqBjd2KxERb+JBQ+3WUl6WxDdaxP/ykueiA5L
         f+TZ+o6yObfrIbje4V3NGL2vuJdVCQ6BOmy1BWnqSRMzBTSi/+qWM8OhCh3hcwnlM2xR
         lcPiqo8Fa1deBcn2YI1orOAyBIQPoK6mDYUoFMeCw+X36S/60gslPxDGQmpEQIdGN3QS
         WTdj5iriM9/8GW1gmWZzZuKtmcEbtRjTDuf1t/BArTS/hA6qOVRr/HKzcGW8hzxyRGAt
         FlxORJPaMBtwlbCBUOuWpiLnK75TfdKy8sQiIakMsGHjiPpJ6W1q6MsSsL5Xcaq4gmzm
         VNSQ==
X-Gm-Message-State: APjAAAULA9Fylav/1sja7S26OfgHX8SDn0qRYtrpRMrnSZMDu0BlRZW0
        W/EdvcxiP2VFwuolgpgjenQWRySCgIhsGk72uSUtGRfSnYtuWVbXJLEL5RIw8XV2Px0gSjROoDA
        rWK1z7jwyu20J
X-Received: by 2002:a1c:a789:: with SMTP id q131mr3576438wme.127.1582876872684;
        Fri, 28 Feb 2020 00:01:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAZyelDAC6188L+zqGaVezTwZ+gYT2niIEr5QNr4h1+3JyrvSjpSviHd6Reee3XYjQu4QP7A==
X-Received: by 2002:a1c:a789:: with SMTP id q131mr3576407wme.127.1582876872411;
        Fri, 28 Feb 2020 00:01:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:30cb:d037:e500:2b47? ([2001:b07:6468:f312:30cb:d037:e500:2b47])
        by smtp.gmail.com with ESMTPSA id d13sm11531765wrc.64.2020.02.28.00.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 00:01:11 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Inhibit APIC virtualization for X2APIC guest
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20200228003523.114071-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bde391f9-1f87-dfc9-c0d6-ccd80d537e7d@redhat.com>
Date:   Fri, 28 Feb 2020 09:01:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228003523.114071-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 01:35, Oliver Upton wrote:
> The AVIC does not support guest use of the x2APIC interface. Currently,
> KVM simply chooses to squash the x2APIC feature in the guest's CPUID
> If the AVIC is enabled. Doing so prevents KVM from running a guest
> with greater than 255 vCPUs, as such a guest necessitates the use
> of the x2APIC interface.
> 
> Instead, inhibit AVIC enablement on a per-VM basis whenever the x2APIC
> feature is set in the guest's CPUID. Since this changes the behavior of
> KVM as seen by userspace, add a module parameter, avic_per_vm, to opt-in
> for the new behavior. If this parameter is set, report x2APIC as
> available on KVM_GET_SUPPORTED_CPUID. Without opt-in, continue to
> suppress x2APIC from the guest's CPUID.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Since AVIC is not enabled by default, let's do this always and flip the
default to avic=1 in 5.7.  People using avic=1 will have to disable
x2apic manually instead but the default will be the same in practice
(AVIC not enabled).  And then we can figure out:

- how to do emulation of x2apic when avic is enabled (so it will cause
vmexits but still use the AVIC for e.g. assigned devices)

- a PV CPUID leaf to tell <=255 vCPUs on AMD virtualization _not_ to use
x2apic.

Paolo

> ---
> 
>  Parent commit: a93236fcbe1d ("KVM: s390: rstify new ioctls in api.rst")
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              | 19 ++++++++++++++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 98959e8cd448..9d40132a3ae2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -890,6 +890,7 @@ enum kvm_irqchip_mode {
>  #define APICV_INHIBIT_REASON_NESTED     2
>  #define APICV_INHIBIT_REASON_IRQWIN     3
>  #define APICV_INHIBIT_REASON_PIT_REINJ  4
> +#define APICV_INHIBIT_REASON_X2APIC	5
>  
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ad3f5b178a03..95c03c75f51a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -382,6 +382,10 @@ module_param(sev, int, 0444);
>  static bool __read_mostly dump_invalid_vmcb = 0;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> +/* enable/disable opportunistic use of the AVIC on a per-VM basis */
> +static bool __read_mostly avic_per_vm;
> +module_param(avic_per_vm, bool, 0444);
> +
>  static u8 rsm_ins_bytes[] = "\x0f\xaa";
>  
>  static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> @@ -6027,7 +6031,15 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> -	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
> +	/*
> +	 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
> +	 * is exposed to the guest, disable AVIC.
> +	 */
> +	if (avic_per_vm && guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> +		kvm_request_apicv_update(vcpu->kvm, false,
> +					 APICV_INHIBIT_REASON_X2APIC);
> +	else
> +		guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
>  
>  	/*
>  	 * Currently, AVIC does not work with nested virtualization.
> @@ -6044,7 +6056,7 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
>  {
>  	switch (func) {
>  	case 0x1:
> -		if (avic)
> +		if (avic && !avic_per_vm)
>  			entry->ecx &= ~F(X2APIC);
>  		break;
>  	case 0x80000001:
> @@ -7370,7 +7382,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
>  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>  			  BIT(APICV_INHIBIT_REASON_NESTED) |
>  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> -			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
> +			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> +			  BIT(APICV_INHIBIT_REASON_X2APIC);
>  
>  	return supported & BIT(bit);
>  }
> 

