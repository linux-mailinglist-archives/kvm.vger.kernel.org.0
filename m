Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C21523BB7
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 19:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345684AbiEKRiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 13:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiEKRiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 13:38:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B7F69B40
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:38:20 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 7so2379140pga.12
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H5WDuUU2rZuX6Y+5jzF39w8je6fZvqx9YdBjdfE1NMc=;
        b=MJyMX/RCuPJXu3xGE4Y52KWacXmCHKyAtQLqFO9MA4ldb+Um/K/OVAiqo0S/aftlxf
         mlqn7n2sNH0aBijthioZP8yCv1so3YiO7jV2QXiUsqzDbW4F8TWr/jTehFq4dWbOKBCu
         oi1RZPNPnEtlk2yFgZ6xqyihDRz+jHMlDnmbKt1gjcjGYLkcxhIU/TmeY+QwkPh9SME9
         FWUz5y2gAeWeYtXX2b3kT08DRlOpc/3WjDXVwnE8CmwXAQPRGpDOj8vMOyRYyi9IUbJ5
         fqhQk4gQ4cS/DKpVH25PJ7Fd9JWR7Cpog8YYObqWli+JnmA7avPPusCCBqKr2L5V0gdQ
         i6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H5WDuUU2rZuX6Y+5jzF39w8je6fZvqx9YdBjdfE1NMc=;
        b=UJevWOCtS2cRN0PQc/vrwy0dC8aYkeat670BI/KE9Wjb7VrmkNoGMZKUJ5NU+7Mlld
         QmDimKLlaB9X9p94p4zI1rva1nDFd+bnXcJqLpI0wO6z4K+GOWuBouATUpTRSsyXPxCY
         Bb+FI2ov0bF2bgHezQQ/KOJTf3dhv6PMSHtKpu9MnNsTHcJzkmzuj5wXE2qDrG+LaPVk
         4kHLgl3zRRAUbKeB0Oz4Dj5ixbsiVtR7g5gdSVWfRygM8MDtEMYEmF3B8GWpy8oc04Xs
         hZP6D334GgUSajSfH7nEENeTGCWlwXiuTkIzlQHUjjLJHqgVlhvAyP7fgtia2idDStGl
         Y1fg==
X-Gm-Message-State: AOAM532DXfA/5esFQplaMy/Zm0n+Hbo/bZuUkmKGCXZPxyz1gaOd2x5y
        jMZcMzGP9zbbL0isIV073St2GLjn7YEdFg==
X-Google-Smtp-Source: ABdhPJyywtyAW/VE7NrGsBhbeEnjuWfGmFpxBIitVzxMFkVN3xuB1MPtg1sPp7MXACppBVgWErPXZw==
X-Received: by 2002:a05:6a00:248d:b0:510:5d7d:18ab with SMTP id c13-20020a056a00248d00b005105d7d18abmr25622093pfv.51.1652290699785;
        Wed, 11 May 2022 10:38:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f12-20020a65590c000000b003c5e836eddasm116118pgu.94.2022.05.11.10.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 10:38:19 -0700 (PDT)
Date:   Wed, 11 May 2022 17:38:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: x86: Clean up KVM APIC LVT logic.
Message-ID: <Ynv0h9r8F+oRQ76y@google.com>
References: <20220412223134.1736547-1-juew@google.com>
 <20220412223134.1736547-2-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412223134.1736547-2-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> This is in preparation to add APIC_LVTCMCI support.

There is not nearly enough information in this changelog.  Same goes for all other
patches in the series.  And when you start writing changelogs to explain what is
being done and why, I suspect you'll find that this should be further broken up
into multiple patches.

 1. Make APIC_VERSION capture only the magic 0x14UL
 2. Fill apic_lvt_mask with enums / explicit entries.
 3. Add APIC_LVTx() macro

And proper upstream etiquette would be to add

  Suggested-by: Sean Christopherson <seanjc@google.com>

for #2 and #3.  I don't care much about the attribution (though that's nice too),
but more importantly it provides a bit of context for others that get involved
later in the series (sometimes unwillingly).  E.g. if someone encounters a bug
with a patch, the Suggested-by gives them one more person to loop into the
discussion.  Ditto for other reviewers, e.g. if someone starts reviewing the
series at v3 or whatever, it provides some background on how the series got to
v3 without them having to actually look at v1 or v2.

> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 33 +++++++++++++++++++--------------
>  arch/x86/kvm/lapic.h | 19 ++++++++++++++++++-
>  2 files changed, 37 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..2c770e4c0e6c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,7 +54,7 @@
>  #define PRIo64 "o"
>  
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
> -#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> +#define APIC_VERSION			0x14UL
>  #define LAPIC_MMIO_LENGTH		(1 << 12)
>  /* followed define is not in apicdef.h */
>  #define MAX_APIC_VECTOR			256
> @@ -364,10 +364,15 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>  	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
>  }
>  
> +static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
> +{
> +	return KVM_APIC_MAX_NR_LVT_ENTRIES;
> +}

I think it makes sense to introduce this helper with the CMCI patch.  Until then,
requiring @vcpu to get the max number of entries is misleading and unnecessary.

Case in point, this patch is broken in that the APIC_SPIV path in kvm_lapic_reg_write()
uses the #define directly, which necessitates fixup in the CMCI patch to use this
helper.

> +
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 v = APIC_VERSION;
> +	u32 v = APIC_VERSION | ((kvm_apic_get_nr_lvt_entries(vcpu) - 1) << 16);
>  
>  	if (!lapic_in_kernel(vcpu))
>  		return;
> @@ -385,12 +390,13 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  	kvm_lapic_set_reg(apic, APIC_LVR, v);
>  }
>  
> -static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
> -	LVT_MASK ,      /* part LVTT mask, timer mode mask added at runtime */
> -	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
> -	LVT_MASK | APIC_MODE_MASK,	/* LVTPC */
> -	LINT_MASK, LINT_MASK,	/* LVT0-1 */
> -	LVT_MASK		/* LVTERR */
> +static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
> +	[LVT_TIMER] = LVT_MASK,      /* timer mode mask added at runtime */
> +	[LVT_THERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,
> +	[LVT_PERFORMANCE_COUNTER] = LVT_MASK | APIC_MODE_MASK,
> +	[LVT_LINT0] = LINT_MASK,
> +	[LVT_LINT1] = LINT_MASK,
> +	[LVT_ERROR] = LVT_MASK
>  };
>  
>  static int find_highest_vector(void *bitmap)
> @@ -2039,10 +2045,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  			int i;
>  			u32 lvt_val;
>  
> -			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
> -				lvt_val = kvm_lapic_get_reg(apic,
> -						       APIC_LVTT + 0x10 * i);
> -				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
> +			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
> +				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
> +				kvm_lapic_set_reg(apic, APIC_LVTx(i),
>  					     lvt_val | APIC_LVT_MASKED);
>  			}
>  			apic_update_lvtt(apic);
> @@ -2341,8 +2346,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
>  	kvm_apic_set_version(apic->vcpu);
>  
> -	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
> -		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
> +	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
> +		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
>  	apic_update_lvtt(apic);
>  	if (kvm_vcpu_is_reset_bsp(vcpu) &&
>  	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 2b44e533fc8d..5666441d5d1b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -10,7 +10,6 @@
>  
>  #define KVM_APIC_INIT		0
>  #define KVM_APIC_SIPI		1
> -#define KVM_APIC_LVT_NUM	6
>  
>  #define APIC_SHORT_MASK			0xc0000
>  #define APIC_DEST_NOSHORT		0x0
> @@ -29,6 +28,24 @@ enum lapic_mode {
>  	LAPIC_MODE_X2APIC = MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE,
>  };
>  
> +enum lapic_lvt_entry {
> +	LVT_TIMER,
> +	LVT_THERMAL_MONITOR,
> +	LVT_PERFORMANCE_COUNTER,
> +	LVT_LINT0,
> +	LVT_LINT1,
> +	LVT_ERROR,
> +
> +	KVM_APIC_MAX_NR_LVT_ENTRIES,
> +};
> +
> +
> +#define APIC_LVTx(x)                                                    \
> +({                                                                      \
> +	int __apic_reg = APIC_LVTT + 0x10 * (x);                        \

An intermediate variable is completely unnecessary.  This should do just fine.

  #define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))

Yes, the macro _may_ eventually becomes a multi-line beast with a variable when
CMCI support is added, but again that belongs in the CMCI patch.  That way this
patch doesn't need to change if we decide that even the CMCI-aware version can
just be:

  #define APIC_LVTx(x) ((x) == LVT_CMCI ? APIC_LVTCMCI : APIC_LVTT + 0x10 * (x))


> +	__apic_reg;                                                     \
> +})
> +
>  struct kvm_timer {
>  	struct hrtimer timer;
>  	s64 period; 				/* unit: ns */
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
