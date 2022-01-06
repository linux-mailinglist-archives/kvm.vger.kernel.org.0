Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93382486B13
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243719AbiAFU1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiAFU1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:27:43 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEEC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:27:42 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 200so3583776pgg.3
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BYc7ZZy2/ffam90o5nlWm5kBWTB0bkxo4MGzrb3aFHk=;
        b=TAH9D1ICVAn1zD914bXRl2Y0pdRucTodnwiw1DxmvooRWQ1P0LaWiS8fAjPD8CptVn
         6WXg0LFIyURcAlGHghbn6gFgB+MXE6+6dmpeQkgKtHmhCReKtIEGKZ9uHpltDUTdJK4z
         HqwEe2stGDzmiNV5bKhjvLqLQ00eTgFlGV99ipEhUw6x9dOqaSx+Vd7SZYhDD34MWl/8
         K3k486VR1tt5oOifcRf6H31lMJHIqXhqUFinnf5Wm68zEFW9WR1fdCG/klH14l70VaBV
         jX55vDxyTo0n2oxpVoIWTqeKAg+Soii/4SBJmJJqHfkzW69JY/ULsE4Ci7/ySn8FPcm3
         yDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BYc7ZZy2/ffam90o5nlWm5kBWTB0bkxo4MGzrb3aFHk=;
        b=nEwlYH6bod08I1vm/EWThcZm6XjNCmzLMDEXYdjUTcmmcGeKALV6huIXahQU7CnvxJ
         EUxltVNF8nVhKGY+ayGpQmwwRzTFlfWa+8eM1gwM9lcg75rc/4THVyOUkXVOpxrxgwrZ
         smTOGD9TX3W9miXNA/NmQLIcGQA2FsDJkzTtAOdCdPtdmrYS+hNKPCYY1Lu0m0lSNfPD
         geR8A2jh6xp8PQGLZZsjsTp/ytPEO9baK2GAkGmC2m8SNg64DMhMdsbWEezQi2MNlgyq
         b+9PfpgJfXnFVh0jj8ZpSBDqZYM5novTb/syddXBXFOqKAGqKBSa57cBN459ajP9gGS7
         zWlw==
X-Gm-Message-State: AOAM530FI28Segou4lL3ikthinQKv1V+HxEb1vkhtI5K+awP+nnb2bQd
        QVvUyPgjeQvFhh8lEZgO7KXMgw==
X-Google-Smtp-Source: ABdhPJzYdZUgX/CFo2uWmc9SAUrI+QctfQFtlHcSIiku7vAGQi6ZRhuxf1bnuyz215pMThpLDLuABA==
X-Received: by 2002:a63:af5d:: with SMTP id s29mr53784911pgo.365.1641500862314;
        Thu, 06 Jan 2022 12:27:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3sm3019541pjp.55.2022.01.06.12.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:27:41 -0800 (PST)
Date:   Thu, 6 Jan 2022 20:27:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to
 spte.c
Message-ID: <YddQutP4wnCylJwn@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-6-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> restore_acc_track_spte is purely an SPTE manipulation, making it a good
> fit for spte.c. It is also needed in spte.c in a follow-up commit so we
> can construct child SPTEs during large page splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  | 18 ------------------
>  arch/x86/kvm/mmu/spte.c | 18 ++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h |  1 +
>  3 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8b702f2b6a70..3c2cb4dd1f11 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -646,24 +646,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
>  	return __get_spte_lockless(sptep);
>  }
>  
> -/* Restore an acc-track PTE back to a regular PTE */
> -static u64 restore_acc_track_spte(u64 spte)
> -{
> -	u64 new_spte = spte;
> -	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> -			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
> -
> -	WARN_ON_ONCE(spte_ad_enabled(spte));
> -	WARN_ON_ONCE(!is_access_track_spte(spte));
> -
> -	new_spte &= ~shadow_acc_track_mask;
> -	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> -		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> -	new_spte |= saved_bits;
> -
> -	return new_spte;
> -}
> -
>  /* Returns the Accessed status of the PTE and resets it at the same time. */
>  static bool mmu_spte_age(u64 *sptep)
>  {
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 8a7b03207762..fd34ae5d6940 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -268,6 +268,24 @@ u64 mark_spte_for_access_track(u64 spte)
>  	return spte;
>  }
>  
> +/* Restore an acc-track PTE back to a regular PTE */
> +u64 restore_acc_track_spte(u64 spte)
> +{
> +	u64 new_spte = spte;
> +	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> +			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;

Obviously not your code, but this could be:

	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) &
			 SHADOW_ACC_TRACK_SAVED_BITS_MASK;

	WARN_ON_ONCE(spte_ad_enabled(spte));
	WARN_ON_ONCE(!is_access_track_spte(spte));

	spte &= ~shadow_acc_track_mask;
	spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
		  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
	spte |= saved_bits;

	return spte;

which is really just an excuse to move the ampersand up a line :-)

And looking at the two callers, the WARNs are rather silly.  The spte_ad_enabled()
WARN is especially pointless because that's also checked by is_access_track_spte().
I like paranoid WARNs as much as anyone, but I don't see why this code warrants
extra checking relative to the other SPTE helpers that have more subtle requirements.

At that point, make make this an inline helper?

  static inline u64 restore_acc_track_spte(u64 spte)
  {
	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) &
			 SHADOW_ACC_TRACK_SAVED_BITS_MASK;

	spte &= ~shadow_acc_track_mask;
	spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
		  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
	spte |= saved_bits;

	return spte;
  }

> +	WARN_ON_ONCE(spte_ad_enabled(spte));
> +	WARN_ON_ONCE(!is_access_track_spte(spte));
> +
> +	new_spte &= ~shadow_acc_track_mask;
> +	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> +		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> +	new_spte |= saved_bits;
> +
> +	return new_spte;
> +}
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  {
>  	BUG_ON((u64)(unsigned)access_mask != access_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index a4af2a42695c..9b0c7b27f23f 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -337,6 +337,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> +u64 restore_acc_track_spte(u64 spte);
>  u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
>  
>  void kvm_mmu_reset_all_pte_masks(void);
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
