Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE3535D83
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 11:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350642AbiE0Jkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 05:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbiE0Jkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 05:40:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9FAD6816;
        Fri, 27 May 2022 02:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653644440; x=1685180440;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tWPzRvOUKjGgFHKp9mu/98U2zEw43yO+zUyFIBYSvYc=;
  b=SolDmKKNoyYzJ9n8asKxlHXPVkeqpGGhD4BPmO3cE56i/f4LmuaAbPQD
   /k6MvUdKhhcbWqHaRYL4jFA9An52cMnI6dUYgPLBu9B6Um1t20Ruool7+
   Hyf98n3xv6ocnMLwAE4fKp1WZDTshgLf1txTzHCFjT798RxE3mjYfu67e
   87BqofzSqTbrtPdiszfc5srsoKNFMfr0YVz67CEdTZr3WufQjbBcmD2XY
   cNucPZEZyqzXvFJzN/1OZwF4WZMJxcQd1KgVupC8nv36gcQrYVtmdJGez
   oedEmRubbekmNFtiBNvtzcF4IMk7URDHhVDdmRp7xInisCRYHWl7SvEp+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="256506938"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="256506938"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:40:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705044707"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:40:37 -0700
Message-ID: <20fbbfa8-3d92-c497-f577-fbc28899082c@intel.com>
Date:   Fri, 27 May 2022 17:40:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 6/8] KVM: MMU: Add support for PKS emulation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-7-lei4.wang@intel.com> <Yo1qFh8+0AVvwvd5@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yo1qFh8+0AVvwvd5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2022 7:28 AM, Sean Christopherson wrote:
> On Sun, Apr 24, 2022, Lei Wang wrote:
>> @@ -454,10 +455,11 @@ struct kvm_mmu {
>>   	u8 permissions[16];
>>   
>>   	/*
>> -	* The pkru_mask indicates if protection key checks are needed.  It
>> -	* consists of 16 domains indexed by page fault error code bits [4:1],
>> -	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
>> -	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
>> +	* The pkr_mask indicates if protection key checks are needed.
>> +	* It consists of 16 domains indexed by page fault error code
>> +	* bits[4:1] with PFEC.RSVD replaced by ACC_USER_MASK from the
>> +	* page tables. Each domain has 2 bits which are ANDed with AD
>> +	* and WD from PKRU/PKRS.
> Same comments, align and wrap closer to 80 please.
Will do it.
>>   	*/
>>   	u32 pkr_mask;
>>   
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index cea03053a153..6963c641e6ce 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -45,7 +45,8 @@
>>   #define PT32E_ROOT_LEVEL 3
>>   
>>   #define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PSE | X86_CR4_PAE | X86_CR4_LA57 | \
>> -			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
>> +			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE | \
>> +			       X86_CR4_PKS)
>>   
>>   #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
>>   #define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6d3276986102..a6cbc22d3312 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -209,6 +209,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
>>   BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
>>   BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
>>   BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
>> +BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pks, X86_CR4_PKS);
>>   BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
>>   BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
>>   
>> @@ -231,6 +232,7 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
>>   BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
>>   BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
>>   BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
>> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pks);
>>   BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
>>   
>>   static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>> @@ -4608,37 +4610,58 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
>>   }
>>   
>>   /*
> ...
>
>> + * Protection Key Rights (PKR) is an additional mechanism by which data accesses
>> + * with 4-level or 5-level paging (EFER.LMA=1) may be disabled based on the
>> + * Protection Key Rights Userspace (PRKU) or Protection Key Rights Supervisor
>> + * (PKRS) registers.  The Protection Key (PK) used for an access is a 4-bit
>> + * value specified in bits 62:59 of the leaf PTE used to translate the address.
>> + *
>> + * PKRU and PKRS are 32-bit registers, with 16 2-bit entries consisting of an
>> + * access-disable (AD) and write-disable (WD) bit.  The PK from the leaf PTE is
>> + * used to index the approriate PKR (see below), e.g. PK=1 would consume bits
> s/approriate/appropriate
Will correct it.
>> + * 3:2 (bit 3 == write-disable, bit 2 == access-disable).
>> + *
>> + * The PK register (PKRU vs. PKRS) indexed by the PK depends on the type of
>> + * _address_ (not access type!).  For a user-mode address, PKRU is used; for a
>> + * supervisor-mode address, PKRS is used.  An address is supervisor-mode if the
>> + * U/S flag (bit 2) is 0 in at least one of the paging-structure entries, i.e.
>> + * an address is user-mode if the U/S flag is 1 in _all_ entries.  Again, this
>> + * is the address type, not the the access type, e.g. a supervisor-mode _access_
> Double "the the" can be a single "the".
Will remove it.
>> + * will consume PKRU if the _address_ is a user-mode address.
>> + *
>> + * As alluded to above, PKR checks are only performed for data accesses; code
>> + * fetches are not subject to PKR checks.  Terminal page faults (!PRESENT or
>> + * PFEC.RSVD=1) are also not subject to PKR checks.
>> + *
>> + * PKR write-disable checks for superivsor-mode _accesses_ are performed if and
>> + * only if CR0.WP=1 (though access-disable checks still apply).
>> + *
>> + * In summary, PKR checks are based on (a) EFER.LMA, (b) CR4.PKE or CR4.PKS,
>> + * (c) CR0.WP, (d) the PK in the leaf PTE, (e) two bits from the corresponding
>> + * PKR{S,U} entry, (f) the access type (derived from the other PFEC bits), and
>> + * (g) the address type (retrieved from the paging-structure entries).
>> + *
>> + * To avoid conditional branches in permission_fault(), the PKR bitmask caches
>> + * the above inputs, except for (e) the PKR{S,U} entry.  The FETCH, USER, and
>> + * WRITE bits of the PFEC and the effective value of the paging-structures' U/S
>> + * bit (slotted into the PFEC.RSVD position, bit 3) are used to index into the
>> + * PKR bitmask (similar to the 4-bit Protection Key itself).  The two bits of
>> + * the PKR bitmask "entry" are then extracted and ANDed with the two bits of
>> + * the PKR{S,U} register corresponding to the address type and protection key.
>> + *
>> + * E.g. for all values where PFEC.FETCH=1, the corresponding pkr_bitmask bits
>> + * will be 00b, thus masking away the AD and WD bits from the PKR{S,U} register
>> + * to suppress PKR checks on code fetches.
>> + */
>>   static void update_pkr_bitmask(struct kvm_mmu *mmu)
>>   {
>>   	unsigned bit;
>>   	bool wp;
>> -
> Please keep this newline, i.e. after the declaration of the cr4 booleans.  That
> helps isolate the clearing of mmu->pkr_mask, which makes the functional affect of
> the earlier return more obvious.
>
> Ah, and use reverse fir tree for the variable declarations, i.e.
>
> 	bool cr4_pke = is_cr4_pke(mmu);
> 	bool cr4_pks = is_cr4_pks(mmu);
> 	unsigned bit;
> 	bool wp;
>
> 	mmu->pkr_mask = 0;
>
> 	if (!cr4_pke && !cr4_pks)
> 		return;

Very nice of you, will use reverse fir tree for the declaration.

>> +	bool cr4_pke = is_cr4_pke(mmu);
>> +	bool cr4_pks = is_cr4_pks(mmu);
>>   	mmu->pkr_mask = 0;
>>   
>> -	if (!is_cr4_pke(mmu))
>> +	if (!cr4_pke && !cr4_pks)
>>   		return;
>>   
>>   	wp = is_cr0_wp(mmu);
>    
>
>    ...
>
>> @@ -6482,14 +6509,22 @@ u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>   		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec)
>>   {
>>   	u32 pkr_bits, offset;
>> +	u32 pkr;
>>   
>>   	/*
>> -	* PKRU defines 32 bits, there are 16 domains and 2
>> -	* attribute bits per domain in pkru.  pte_pkey is the
>> -	* index of the protection domain, so pte_pkey * 2 is
>> -	* is the index of the first bit for the domain.
>> +	* PKRU and PKRS both define 32 bits. There are 16 domains
>> +	* and 2 attribute bits per domain in them. pte_key is the
>> +	* index of the protection domain, so pte_pkey * 2 is the
>> +	* index of the first bit for the domain. The use of PKRU
>> +	* versus PKRS is selected by the address type, as determined
>> +	* by the U/S bit in the paging-structure entries.
>
> Align and wrap closer to 80 please.
Will do it.
