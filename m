Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89B65333E5
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 01:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242641AbiEXX2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 19:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiEXX22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 19:28:28 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4507537A9C
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 16:28:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p8so17732170pfh.8
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 16:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fqBMuhHrx4UOoXhRLSuxGa/UGjLKCHhTuR3mJ3R2ZwY=;
        b=JGmlcBggKq+pEAmQcRltp2+AtkVq5JNjau0NP+jVffAM3WGXEUHP+3H1SNK5Jmc78y
         katXpprmCnQ+1hg+EGcKu5QMcGj5NsDt7ZUfOtWTcc6xZI4tgEZvfAdDElhzrLRY+yK3
         O3WXoqR6fAT7VxGvnX3rede4M/zX1YGGfXEmZON1JLRWrQrwXcg8KMjS0fHWIRgAy4Gw
         V2Z+YjcYI2jPSbI/iRo9lrpDmhm9/oBaFkTb3RELvk/cYtSQ9XWJcTVOIyhELP23Vz95
         OF46uWUW5P2jmbYmuQ3VGaGmi7MFX7N6vJKGkV2kgcwi1Nm027oalVVp0e51dF4LpLlx
         61JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fqBMuhHrx4UOoXhRLSuxGa/UGjLKCHhTuR3mJ3R2ZwY=;
        b=TKWVonZHZV8T1Uo3wUWKNpEwIiVwK50eezcqGN+Vu3DAHs1e8vvaIDCRasCP5eZgO2
         zp4zm14TI/a+zY1SVmguhOd4bNx4Gy03RL4gWv/OGmPGASXPrHWWL9R2Y1tq8ILizj+H
         bq48OFj0bo3aeONK8BwgMkabT5Nb0WYiQtIQcrlsB2cMOXw472gLjypEkDMTGvErYOl9
         pjRW9erEJ4IRuihIOfmk14B4n70r48j2vQV1fE9C9CaR/Ey4W0nra9/dGdEI88e5P9B0
         sZoOTdtDIyeuRByNyAKk7oAu2vCkEPIzicNWRv4d4H6HSvWnCJ8aERIlMU7YkVs2nmY9
         vPEg==
X-Gm-Message-State: AOAM53254OvJOhFaEw1AtwFUca3lPjVPStmcgeY/YoGg2xzidp+vJvfk
        OaWjY5l4fEsB/mWGvy6/H7+apQ==
X-Google-Smtp-Source: ABdhPJwSlQCwnTZZpCmCaeDuJJh3cqRaXuaIMrZ2CsrKOCI91svuNsa7opFbxvUOKVisocymZ6r/VA==
X-Received: by 2002:a63:5fcf:0:b0:3f6:298d:e2ea with SMTP id t198-20020a635fcf000000b003f6298de2eamr26753832pgb.561.1653434906513;
        Tue, 24 May 2022 16:28:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y76-20020a62ce4f000000b004fa743ba3f9sm10020111pfg.2.2022.05.24.16.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 16:28:26 -0700 (PDT)
Date:   Tue, 24 May 2022 23:28:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 6/8] KVM: MMU: Add support for PKS emulation
Message-ID: <Yo1qFh8+0AVvwvd5@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-7-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424101557.134102-7-lei4.wang@intel.com>
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

On Sun, Apr 24, 2022, Lei Wang wrote:
> @@ -454,10 +455,11 @@ struct kvm_mmu {
>  	u8 permissions[16];
>  
>  	/*
> -	* The pkru_mask indicates if protection key checks are needed.  It
> -	* consists of 16 domains indexed by page fault error code bits [4:1],
> -	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
> -	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
> +	* The pkr_mask indicates if protection key checks are needed.
> +	* It consists of 16 domains indexed by page fault error code
> +	* bits[4:1] with PFEC.RSVD replaced by ACC_USER_MASK from the
> +	* page tables. Each domain has 2 bits which are ANDed with AD
> +	* and WD from PKRU/PKRS.

Same comments, align and wrap closer to 80 please.

>  	*/
>  	u32 pkr_mask;
>  
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index cea03053a153..6963c641e6ce 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -45,7 +45,8 @@
>  #define PT32E_ROOT_LEVEL 3
>  
>  #define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PSE | X86_CR4_PAE | X86_CR4_LA57 | \
> -			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
> +			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE | \
> +			       X86_CR4_PKS)
>  
>  #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
>  #define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d3276986102..a6cbc22d3312 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -209,6 +209,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
>  BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
>  BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
>  BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
> +BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pks, X86_CR4_PKS);
>  BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
>  BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
>  
> @@ -231,6 +232,7 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
>  BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
>  BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
>  BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pks);
>  BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
>  
>  static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
> @@ -4608,37 +4610,58 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
>  }
>  
>  /*

...

> + * Protection Key Rights (PKR) is an additional mechanism by which data accesses
> + * with 4-level or 5-level paging (EFER.LMA=1) may be disabled based on the
> + * Protection Key Rights Userspace (PRKU) or Protection Key Rights Supervisor
> + * (PKRS) registers.  The Protection Key (PK) used for an access is a 4-bit
> + * value specified in bits 62:59 of the leaf PTE used to translate the address.
> + *
> + * PKRU and PKRS are 32-bit registers, with 16 2-bit entries consisting of an
> + * access-disable (AD) and write-disable (WD) bit.  The PK from the leaf PTE is
> + * used to index the approriate PKR (see below), e.g. PK=1 would consume bits

s/approriate/appropriate

> + * 3:2 (bit 3 == write-disable, bit 2 == access-disable).
> + *
> + * The PK register (PKRU vs. PKRS) indexed by the PK depends on the type of
> + * _address_ (not access type!).  For a user-mode address, PKRU is used; for a
> + * supervisor-mode address, PKRS is used.  An address is supervisor-mode if the
> + * U/S flag (bit 2) is 0 in at least one of the paging-structure entries, i.e.
> + * an address is user-mode if the U/S flag is 1 in _all_ entries.  Again, this
> + * is the address type, not the the access type, e.g. a supervisor-mode _access_

Double "the the" can be a single "the".

> + * will consume PKRU if the _address_ is a user-mode address.
> + *
> + * As alluded to above, PKR checks are only performed for data accesses; code
> + * fetches are not subject to PKR checks.  Terminal page faults (!PRESENT or
> + * PFEC.RSVD=1) are also not subject to PKR checks.
> + *
> + * PKR write-disable checks for superivsor-mode _accesses_ are performed if and
> + * only if CR0.WP=1 (though access-disable checks still apply).
> + *
> + * In summary, PKR checks are based on (a) EFER.LMA, (b) CR4.PKE or CR4.PKS,
> + * (c) CR0.WP, (d) the PK in the leaf PTE, (e) two bits from the corresponding
> + * PKR{S,U} entry, (f) the access type (derived from the other PFEC bits), and
> + * (g) the address type (retrieved from the paging-structure entries).
> + *
> + * To avoid conditional branches in permission_fault(), the PKR bitmask caches
> + * the above inputs, except for (e) the PKR{S,U} entry.  The FETCH, USER, and
> + * WRITE bits of the PFEC and the effective value of the paging-structures' U/S
> + * bit (slotted into the PFEC.RSVD position, bit 3) are used to index into the
> + * PKR bitmask (similar to the 4-bit Protection Key itself).  The two bits of
> + * the PKR bitmask "entry" are then extracted and ANDed with the two bits of
> + * the PKR{S,U} register corresponding to the address type and protection key.
> + *
> + * E.g. for all values where PFEC.FETCH=1, the corresponding pkr_bitmask bits
> + * will be 00b, thus masking away the AD and WD bits from the PKR{S,U} register
> + * to suppress PKR checks on code fetches.
> + */
>  static void update_pkr_bitmask(struct kvm_mmu *mmu)
>  {
>  	unsigned bit;
>  	bool wp;
> -

Please keep this newline, i.e. after the declaration of the cr4 booleans.  That
helps isolate the clearing of mmu->pkr_mask, which makes the functional affect of
the earlier return more obvious.

Ah, and use reverse fir tree for the variable declarations, i.e.

	bool cr4_pke = is_cr4_pke(mmu);
	bool cr4_pks = is_cr4_pks(mmu);
	unsigned bit;
	bool wp;

	mmu->pkr_mask = 0;

	if (!cr4_pke && !cr4_pks)
		return;

> +	bool cr4_pke = is_cr4_pke(mmu);
> +	bool cr4_pks = is_cr4_pks(mmu);
>  	mmu->pkr_mask = 0;
>  
> -	if (!is_cr4_pke(mmu))
> +	if (!cr4_pke && !cr4_pks)
>  		return;
>  
>  	wp = is_cr0_wp(mmu);
  

  ...

> @@ -6482,14 +6509,22 @@ u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec)
>  {
>  	u32 pkr_bits, offset;
> +	u32 pkr;
>  
>  	/*
> -	* PKRU defines 32 bits, there are 16 domains and 2
> -	* attribute bits per domain in pkru.  pte_pkey is the
> -	* index of the protection domain, so pte_pkey * 2 is
> -	* is the index of the first bit for the domain.
> +	* PKRU and PKRS both define 32 bits. There are 16 domains
> +	* and 2 attribute bits per domain in them. pte_key is the
> +	* index of the protection domain, so pte_pkey * 2 is the
> +	* index of the first bit for the domain. The use of PKRU
> +	* versus PKRS is selected by the address type, as determined
> +	* by the U/S bit in the paging-structure entries.


Align and wrap closer to 80 please.

>  	*/
> -	pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +	if (pte_access & PT_USER_MASK)
> +		pkr = is_cr4_pke(mmu) ? vcpu->arch.pkru : 0;
> +	else
> +		pkr = is_cr4_pks(mmu) ? kvm_read_pkrs(vcpu) : 0;
> +
> +	pkr_bits = (pkr >> pte_pkey * 2) & 3;
>  
>  	/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
>  	offset = (pfec & ~1) + ((pte_access & PT_USER_MASK)
> -- 
> 2.25.1
> 
