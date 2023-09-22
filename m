Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E71C7AB71E
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjIVRVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 13:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjIVRVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 13:21:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3C883
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:21:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d858d1bdf0aso3083517276.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695403295; x=1696008095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M9WhiCaD4LWwh3ZAwOp1M8KzMa/tah1+24eMkBfnrgs=;
        b=EYcwnnMmRwYJtEFMh1M54EKlm0z6BqGp2fBVjDpf1XfhdtQAj9mkTspugfTLjieyhw
         zfcRcNOaQPLnWkZkJxfjWfMhN2Qih7ZLK+5firHB+su0uzRQT78JkpzP+LDDSvMJBmEm
         mvxCyLwYacnLj/8OKIAMH0zNKiAMbIB0LZqM00jWS7PdrMNXuGHa1plEPD0EPtH0F0Cg
         wHt3jeSCwijngIMh0lC3YtfDXriC357VdDMrrC3Q4dS9ho7p0UixjetnTcfg+qDBeCo5
         FLNoyl8gw6Sdn9hIoJcp+XnHgrYTCckShZePV1/9P9WTQRXxTLSo4JTxMFWn7R6ym7MJ
         TuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695403295; x=1696008095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9WhiCaD4LWwh3ZAwOp1M8KzMa/tah1+24eMkBfnrgs=;
        b=RoOtNA9zA0LY0Go8a+dqPfX9hYjZ9mCQxANxqgDUYaiEii3ytRTPANmuW/MdMbsLid
         ALUeJsbHsIMxvVHoyhK0ApVmB2UoqVmiq2atoRzTJrVrLKsHGyz11we35P/EBhr8yRd5
         Co1tn7h3Z7WUoh2RhYL7SF+F79rXXa0Miyv3CM0ZMlJVFfWhO4IlnviXYE+AhMAs1/7+
         LqYmblcOATLyWb2vCEuXUfybPFayRTK/zsSm+nxjQBsskMVxfgd8bqRowJH8fUMQuBrS
         5rD5/vRnBy/hRm6GuVmpXeZxgwEsa0ru6lRjpQfQ2AKhKVQpsw1xRnqdb9D5eq2qKQE4
         dz+g==
X-Gm-Message-State: AOJu0Yx7Yd+ESNu5E3ogXK+4gKMFsMkn63C8wwDt8KQ98us8/6xHWE35
        pKZX2gf+f3/jYqfr1nH17EIfKs9BQYg=
X-Google-Smtp-Source: AGHT+IGIWO/ecB2bbRN4uVNPEpLDBvwPBVXzwoTxQV3GBoDJ6eifEKuaTjPr550nzGEwSRfhwWDTKBfZjSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db10:0:b0:d78:215f:ba5f with SMTP id
 g16-20020a25db10000000b00d78215fba5fmr115039ybf.9.1695403295536; Fri, 22 Sep
 2023 10:21:35 -0700 (PDT)
Date:   Fri, 22 Sep 2023 10:21:34 -0700
In-Reply-To: <20230922164239.2253604-2-jmattson@google.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
Message-ID: <ZQ3NHv9Yok8Uybzo@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, "'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Jim Mattson wrote:
> On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
> set. If it isn't set, they complain:
> 	[Firmware Bug]: TSC doesn't count with P0 frequency!
> 
> Eliminate this complaint by setting the bit on virtual processors for
> which Linux guests expect it to be set.
> 
> Note that this bit is read-only on said processors.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 10 ++++++++++
>  arch/x86/kvm/x86.c   |  7 +++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0544e30b4946..2d7dcd13dcc3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -373,6 +373,16 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
> +	/*
> +	 * HWCR.TscFreqSel[bit 24] has a reset value of 1 on some processors.
> +	 */
> +	if (guest_cpuid_is_amd_or_hygon(vcpu) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_CONSTANT_TSC) &&
> +	    (guest_cpuid_family(vcpu) > 0x10 ||
> +	     (guest_cpuid_family(vcpu) == 0x10 &&
> +	      guest_cpuid_model(vcpu) >= 2)))
> +		vcpu->arch.msr_hwcr |= BIT(24);

Oh hell no.  It's bad enough that KVM _allows_ setting uarch specific bits, but
actively setting bits is a step too far.

IMO, we should delete the offending kernel code.  I don't see how it provides any
value these days.

And *if* we want to change something in KVM so that we stop getting coustomer
complaints about a useless bit, just let userspace stuff the bit.

I think we should also raise the issue with AMD (Borislav maybe?) and ask/demand
that bits in HWCR that KVM allows to be set are architecturally defined.  It's
totally fine if the value of bit 24 is uarch specific, but the behavior needs to
be something that won't change from processor to processor.

>  	kvm_pmu_refresh(vcpu);
>  	vcpu->arch.cr4_guest_rsvd_bits =
>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3421ed7fcee0..cb02a7c2938b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3699,12 +3699,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		data &= ~(u64)0x40;	/* ignore flush filter disable */
>  		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
>  		data &= ~(u64)0x8;	/* ignore TLB cache disable */
> +		data &= ~(u64)0x1000000;/* ignore TscFreqSel */
>  
>  		/* Handle McStatusWrEn */
>  		if (data & ~BIT_ULL(18)) {
>  			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  			return 1;
>  		}
> +
> +		/*
> +		 * When set, TscFreqSel is read-only. Attempts to
> +		 * clear it are ignored.
> +		 */
> +		data |= vcpu->arch.msr_hwcr & BIT_ULL(24);


The bit is read-only from the guest, but KVM needs to let userspace clear the
bit.

>  		vcpu->arch.msr_hwcr = data;
>  		break;
>  	case MSR_FAM10H_MMIO_CONF_BASE:
> -- 
> 2.42.0.515.g380fc7ccd1-goog
> 
