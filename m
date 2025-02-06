Return-Path: <kvm+bounces-37426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD2BA29FB5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 05:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D8FA1618C3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 04:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82307165F09;
	Thu,  6 Feb 2025 04:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGD/3vqi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDFE5B211;
	Thu,  6 Feb 2025 04:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738816416; cv=none; b=u6A9rRCRlUkU17aeOzLi9JG+Z2yPJ3sCkh3wZGxJ9neHY3VXbfnVwQTyB0XLfrAnme0GcUM2B2g2RjXzGdTVUjDvr7iq94CRcFl2sJgw3XXIBrMNHa4kAulqfuOXEMxjY+x53wkB5Yg3ef8SdkE8/vuq1dYtgDPkGK0plF5/vvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738816416; c=relaxed/simple;
	bh=4F2vE5gZXQ1R9viY2NLtHPxaPmsZDZ7NBG0hKYFwBCE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mhIjsIqpmmvC/jWthvxYlx/r7kiU6IknSGVpt7DODcs8kwKO2pvcYuHMSD+UVGg7JeCQKOBoUbfO/2TT2gbcOEFCTr7aR2iyA61LRPeecVSKwQXiP1abdyUk3Z+F3P7H2j95AT4iMzgWmyfgMHHDHqIwUNTfezqB0it6wEjtY0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGD/3vqi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C0C4CEDD;
	Thu,  6 Feb 2025 04:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738816416;
	bh=4F2vE5gZXQ1R9viY2NLtHPxaPmsZDZ7NBG0hKYFwBCE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AGD/3vqi10PbGGO6q8Q1hjwNUeY9KxYOBiDmSdGKaSSVof+gp80epr4BeMT00PKNs
	 32zpNG5sTPyqywLObYnaT76LudTJ/bygPlPFj0/XjsnjCK9CG/DgVIObZ12yuESM90
	 yb2KhsTdU7MXWsSlAqZrmSAl8ClEHIm1QgZNOzAAOWxzyaEvSPSqjl0SBXGMxUKgoh
	 7CwJmXJLEp7m826F2gw2AN8NgSSntof5V1gTJaZV5e7SrZ5LJ71BoDVHoo+dXIe37a
	 0rExcoMtzU0q+h+MOSb7+QQcvokJKXW4swM6WgCDLBwFjBeHozQRuha6BedG0kNDiI
	 cQHIEqsHaZjrg==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v6 20/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <3f0caace-ee05-4ddf-ae75-2157e77aa57c@redhat.com>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-21-steven.price@arm.com>
 <3f0caace-ee05-4ddf-ae75-2157e77aa57c@redhat.com>
Date: Thu, 06 Feb 2025 10:03:25 +0530
Message-ID: <yq5a34grsne2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gavin Shan <gshan@redhat.com> writes:

> On 12/13/24 1:55 AM, Steven Price wrote:
 
....

>> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
>> +				 phys_addr_t fault_ipa,
>> +				 struct kvm_memory_slot *memslot)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
>> +	gfn_t gfn = gpa >> PAGE_SHIFT;
>> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
>> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +	struct page *page;
>> +	kvm_pfn_t pfn;
>> +	int ret;
>> +	/*
>> +	 * For Realms, the shared address is an alias of the private GPA with
>> +	 * the top bit set. Thus is the fault address matches the GPA then it
>> +	 * is the private alias.
>> +	 */
>> +	bool is_priv_gfn = (gpa == fault_ipa);
>> +
>
> We may rename 'priv_exists' to 'was_priv_gfn', which is consistent to 'is_priv_gfn'.
> Alternatively, we may use 'was_private' and 'is_private'.
>
>> +	if (priv_exists != is_priv_gfn) {
>> +		kvm_prepare_memory_fault_exit(vcpu,
>> +					      gpa,
>> +					      PAGE_SIZE,
>> +					      kvm_is_write_fault(vcpu),
>> +					      false, is_priv_gfn);
>> +
>> +		return -EFAULT;
>> +	}
>> +
>> +	if (!is_priv_gfn) {
>> +		/* Not a private mapping, handling normally */
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = kvm_mmu_topup_memory_cache(memcache,
>> +					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
>> +	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
>> +			    memcache);
>> +	if (!ret)
>> +		return 1; /* Handled */
>> +
>> +	put_page(page);
>> +	return ret;
>> +}

I also found the names confusing. Can we do

modified   arch/arm64/kvm/mmu.c
@@ -1487,7 +1487,7 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
 	struct kvm *kvm = vcpu->kvm;
 	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
 	gfn_t gfn = gpa >> PAGE_SHIFT;
-	bool priv_exists = kvm_mem_is_private(kvm, gfn);
+	bool is_priv_gfn = kvm_mem_is_private(kvm, gfn);
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct page *page;
 	kvm_pfn_t pfn;
@@ -1497,19 +1497,19 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
 	 * the top bit set. Thus is the fault address matches the GPA then it
 	 * is the private alias.
 	 */
-	bool is_priv_gfn = (gpa == fault_ipa);
+	bool is_priv_fault = (gpa == fault_ipa);
 
-	if (priv_exists != is_priv_gfn) {
+	if (is_priv_gfn != is_priv_fault) {
 		kvm_prepare_memory_fault_exit(vcpu,
 					      gpa,
 					      PAGE_SIZE,
 					      kvm_is_write_fault(vcpu),
-					      false, is_priv_gfn);
+					      false, is_priv_fault);
 
 		return 0;
 	}
 
-	if (!is_priv_gfn) {
+	if (!is_priv_fault) {
 		/* Not a private mapping, handling normally */
 		return -EINVAL;
 	}

