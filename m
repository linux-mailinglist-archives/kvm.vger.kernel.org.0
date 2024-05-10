Return-Path: <kvm+bounces-17201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5098C2916
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58C7A281522
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4377E17C6B;
	Fri, 10 May 2024 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZSVY8eX6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C63D15E86
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715360958; cv=none; b=i2KKaPdVtrmrXy/etHIWvAJABLQzNE89pa3fI85QpWeNHE/lWIJWEq8zQB8u1u6PA4aOMqR4kLNNE3/rGKKr7RorijHL+8dTsJ/n75ib4zrded34B4GWDQdneZhk5/Ip3XuJSTlLwMrcB7vU869PLRPkL7pXLz3Gtkcj5PT3TG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715360958; c=relaxed/simple;
	bh=o3HzQiNDCwGit4QggZnMuI+ScqHocZvAJc6fOILdelI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjRgbV2jjA2e4xg2BaeCXCNR366/hXCnaLTATzs4oqqkxb1G18BnIPwqGNn8h+vlCnAiJMaXk0kJBmBBVieDmjCIroqxeag4N4kSjK80Q0a8DTGDh55DLhJiksh5MKyL/xMJisIlnIG7u/8vfrwTPay58PfrMcSFKz8s30HzzVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZSVY8eX6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715360955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7p3PXm6krOSd+K8cPm+lYpKDJuTh76+T2MFZsxS42kQ=;
	b=ZSVY8eX63hCu6O68NKr4Q/vMl5y+8xob8mpLIXUtB6z5R2fQjQyS5JzUiUQ1G8V+zfLpR0
	JmOAx5umfDiSW01z+YsFeZGiLj4z93hojBH/6SnY4X0DGFrRRY7NTq589xdoDsYnjaGt1B
	JiqrexFWMmYbT9JVDuRdptdPfmxsi9U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-LjL1OgS1NqygO6N2JFucNA-1; Fri, 10 May 2024 13:09:13 -0400
X-MC-Unique: LjL1OgS1NqygO6N2JFucNA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a59eea00cafso156980666b.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 10:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715360952; x=1715965752;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7p3PXm6krOSd+K8cPm+lYpKDJuTh76+T2MFZsxS42kQ=;
        b=Vh2elRU+AAZ/vG0mD8dPJYrHSowih1h5uMWdzMBFbOw/8Z73agu3ZYMEgfreyuV5Cm
         5Hm7v6wmt4JamRWOcDpZufnGdH5sxZ8bm+Py+bMqiChSM8q5nqcvAklWFvo6BXP1wOMj
         FiT1s+3HOwB7957sMccRJ46YeXaD4gBAxrfRF+/4o+u79Kcvy3iIgYRY/hUukt60OZIf
         jfyFSF8I+RxwnvGvjF/Gx1iq/pisg/7CWs7Ny+O6rWzcojQ61ZicYCgAEIv8LNRMb/Jk
         3GyKKr7uabdaig5kBdvJgaVGIt3MHdWuJQHE3IxvjutLjS3dDgpER+aoKY2UM6ADSXoD
         2NeA==
X-Forwarded-Encrypted: i=1; AJvYcCVJFD6cU7sS+v6z4K5nV1A0mKslSW7bz1y4gHRJ2VV6AGpHLoLRh3PPxT23fKZex2zP9Lr+7x8dWDaP0qKwZyPTg+TB
X-Gm-Message-State: AOJu0Yy77MN/BA9J80/6/PG6aE5TPA+7byUWQwR/4gZL71wQvW4COX6X
	eycSJKIpXdbX3RYuiPaUQnHDUtrjWds9VvaEJhtRs5x5XfYxfb6OC6CaxomotYvhbE5ZCGlEHRb
	8+XstcmyFrIHJZGtOp6x9wAHg34FhS7CyMx5jucxaYbadBaPnDA==
X-Received: by 2002:a17:906:dd7:b0:a59:d5e4:1487 with SMTP id a640c23a62f3a-a5a2d5cb6ffmr296460266b.42.1715360952388;
        Fri, 10 May 2024 10:09:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEM811MEkD14aLnO6nvhAkFbQgZ7sUPC3JmgKjoPSF+RTljS81r9GeaHQExLPjzmjW5n7F/Og==
X-Received: by 2002:a17:906:dd7:b0:a59:d5e4:1487 with SMTP id a640c23a62f3a-a5a2d5cb6ffmr296457566b.42.1715360951811;
        Fri, 10 May 2024 10:09:11 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a5a1781cf70sm204202566b.30.2024.05.10.10.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 May 2024 10:09:10 -0700 (PDT)
Message-ID: <fe5cc86b-43e0-4685-99e7-998e61db333f@redhat.com>
Date: Fri, 10 May 2024 19:09:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 23/23] KVM: SEV: Fix PSC handling for SMASH/UNSMASH
 and partial update ops
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 papaluri@amd.com
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-3-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240510015822.503071-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/24 03:58, Michael Roth wrote:
> There are a few edge-cases that the current processing for GHCB PSC
> requests doesn't handle properly:
> 
>   - KVM properly ignores SMASH/UNSMASH ops when they are embedded in a
>     PSC request buffer which contains other PSC operations, but
>     inadvertantly forwards them to userspace as private->shared PSC
>     requests if they appear at the end of the buffer. Make sure these are
>     ignored instead, just like cases where they are not at the end of the
>     request buffer.
> 
>   - Current code handles non-zero 'cur_page' fields when they are at the
>     beginning of a new GPA range, but it is not handling properly when
>     iterating through subsequent entries which are otherwise part of a
>     contiguous range. Fix up the handling so that these entries are not
>     combined into a larger contiguous range that include unintended GPA
>     ranges and are instead processed later as the start of a new
>     contiguous range.
> 
>   - The page size variable used to track 2M entries in KVM for inflight PSCs
>     might be artifically set to a different value, which can lead to
>     unexpected values in the entry's final 'cur_page' update. Use the
>     entry's 'pagesize' field instead to determine what the value of
>     'cur_page' should be upon completion of processing.
> 
> While here, also add a small helper for clearing in-flight PSCs
> variables and fix up comments for better readability.
> 
> Fixes: 266205d810d2 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
> Signed-off-by: Michael Roth <michael.roth@amd.com>

There are some more improvements that can be made to the readability of
the code... this one is already better than the patch is fixing up, but I
don't like the code that is in the loop even though it is unconditionally
followed by "break".

Here's my attempt at replacing this patch, which is really more of a
rewrite of the whole function...  Untested beyond compilation.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 35f0bd91f92e..6e612789c35f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3555,23 +3555,25 @@ struct psc_buffer {
  
  static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
  
-static int snp_complete_psc(struct kvm_vcpu *vcpu)
+static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
+{
+	svm->sev_es.psc_inflight = 0;
+	svm->sev_es.psc_idx = 0;
+	svm->sev_es.psc_2m = 0;
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+}
+
+static void __snp_complete_one_psc(struct vcpu_svm *svm)
  {
-	struct vcpu_svm *svm = to_svm(vcpu);
  	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
  	struct psc_entry *entries = psc->entries;
  	struct psc_hdr *hdr = &psc->hdr;
-	__u64 psc_ret;
  	__u16 idx;
  
-	if (vcpu->run->hypercall.ret) {
-		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
-		goto out_resume;
-	}
-
  	/*
  	 * Everything in-flight has been processed successfully. Update the
-	 * corresponding entries in the guest's PSC buffer.
+	 * corresponding entries in the guest's PSC buffer and zero out the
+	 * count of in-flight PSC entries.
  	 */
  	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
  	     svm->sev_es.psc_inflight--, idx++) {
@@ -3581,17 +3583,22 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
  	}
  
  	hdr->cur_entry = idx;
+}
+
+static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
+
+	if (vcpu->run->hypercall.ret) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1; /* resume guest */
+	}
+
+	__snp_complete_one_psc(svm);
  
  	/* Handle the next range (if any). */
  	return snp_begin_psc(svm, psc);
-
-out_resume:
-	svm->sev_es.psc_idx = 0;
-	svm->sev_es.psc_inflight = 0;
-	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
-
-	return 1; /* resume guest */
  }
  
  static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
@@ -3601,18 +3608,20 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
  	struct psc_hdr *hdr = &psc->hdr;
  	struct psc_entry entry_start;
  	u16 idx, idx_start, idx_end;
-	__u64 psc_ret, gpa;
+	u64 gfn;
  	int npages;
-
-	/* There should be no other PSCs in-flight at this point. */
-	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
-		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
-		goto out_resume;
-	}
+	bool huge;
  
  	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
-		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
-		goto out_resume;
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1;
+	}
+
+next_range:
+	/* There should be no other PSCs in-flight at this point. */
+	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1;
  	}
  
  	/*
@@ -3624,97 +3633,99 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
  	idx_end = hdr->end_entry;
  
  	if (idx_end >= VMGEXIT_PSC_MAX_COUNT) {
-		psc_ret = VMGEXIT_PSC_ERROR_INVALID_HDR;
-		goto out_resume;
-	}
-
-	/* Nothing more to process. */
-	if (idx_start > idx_end) {
-		psc_ret = 0;
-		goto out_resume;
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
+		return 1;
  	}
  
  	/* Find the start of the next range which needs processing. */
  	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
-		__u16 cur_page;
-		gfn_t gfn;
-		bool huge;
-
  		entry_start = entries[idx];
-
-		/* Only private/shared conversions are currently supported. */
-		if (entry_start.operation != VMGEXIT_PSC_OP_PRIVATE &&
-		    entry_start.operation != VMGEXIT_PSC_OP_SHARED)
-			continue;
-
  		gfn = entry_start.gfn;
-		cur_page = entry_start.cur_page;
  		huge = entry_start.pagesize;
+		npages = huge ? 512 : 1;
  
-		if ((huge && (cur_page > 512 || !IS_ALIGNED(gfn, 512))) ||
-		    (!huge && cur_page > 1)) {
-			psc_ret = VMGEXIT_PSC_ERROR_INVALID_ENTRY;
-			goto out_resume;
+		if (entry_start.cur_page > npages || !IS_ALIGNED(gfn, npages)) {
+			snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_ENTRY);
+			return 1;
  		}
  
+		if (entry_start.cur_page) {
+			/*
+			 * If this is a partially-completed 2M range, force 4K
+			 * handling for the remaining pages since they're effectively
+			 * split at this point. Subsequent code should ensure this
+			 * doesn't get combined with adjacent PSC entries where 2M
+			 * handling is still possible.
+			 */
+			npages -= entry_start.cur_page;
+			gfn += entry_start.cur_page;
+			huge = false;
+		}
+		if (npages)
+			break;
+
  		/* All sub-pages already processed. */
-		if ((huge && cur_page == 512) || (!huge && cur_page == 1))
-			continue;
-
-		/*
-		 * If this is a partially-completed 2M range, force 4K handling
-		 * for the remaining pages since they're effectively split at
-		 * this point. Subsequent code should ensure this doesn't get
-		 * combined with adjacent PSC entries where 2M handling is still
-		 * possible.
-		 */
-		svm->sev_es.psc_2m = cur_page ? false : huge;
-		svm->sev_es.psc_idx = idx;
-		svm->sev_es.psc_inflight = 1;
-
-		gpa = gfn_to_gpa(gfn + cur_page);
-		npages = huge ? 512 - cur_page : 1;
-		break;
  	}
  
+	if (idx > idx_end) {
+		/* Nothing more to process. */
+		snp_complete_psc(svm, 0);
+		return 1;
+	}
+
+	svm->sev_es.psc_2m = huge;
+	svm->sev_es.psc_idx = idx;
+	svm->sev_es.psc_inflight = 1;
+
  	/*
  	 * Find all subsequent PSC entries that contain adjacent GPA
  	 * ranges/operations and can be combined into a single
  	 * KVM_HC_MAP_GPA_RANGE exit.
  	 */
-	for (idx = svm->sev_es.psc_idx + 1; idx <= idx_end; idx++) {
+	while (++idx <= idx_end) {
  		struct psc_entry entry = entries[idx];
  
  		if (entry.operation != entry_start.operation ||
-		    entry.gfn != entry_start.gfn + npages ||
-		    !!entry.pagesize != svm->sev_es.psc_2m)
+		    entry.gfn != gfn + npages ||
+		    entry.cur_page ||
+		    !!entry.pagesize != huge)
  			break;
  
  		svm->sev_es.psc_inflight++;
-		npages += entry_start.pagesize ? 512 : 1;
+		npages += huge ? 512 : 1;
  	}
  
-	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
-	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
-	vcpu->run->hypercall.args[0] = gpa;
-	vcpu->run->hypercall.args[1] = npages;
-	vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
-				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
-				       : KVM_MAP_GPA_RANGE_DECRYPTED;
-	vcpu->run->hypercall.args[2] |= entry_start.pagesize
-					? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
-					: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
-	vcpu->arch.complete_userspace_io = snp_complete_psc;
+	switch (entry_start.operation) {
+	case VMGEXIT_PSC_OP_PRIVATE:
+	case VMGEXIT_PSC_OP_SHARED:
+		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
+		vcpu->run->hypercall.args[1] = npages;
+		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
+			? KVM_MAP_GPA_RANGE_ENCRYPTED
+			: KVM_MAP_GPA_RANGE_DECRYPTED;
+		vcpu->run->hypercall.args[2] |= huge
+			? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
+			: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+		vcpu->arch.complete_userspace_io = snp_complete_one_psc;
  
-	return 0; /* forward request to userspace */
+		return 0; /* forward request to userspace */
  
-out_resume:
-	svm->sev_es.psc_idx = 0;
-	svm->sev_es.psc_inflight = 0;
-	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+	default:
+		/*
+		 * Only shared/private PSC operations are currently supported, so if the
+		 * entire range consists of unsupported operations (e.g. SMASH/UNSMASH),
+		 * then consider the entire range completed and avoid exiting to
+		 * userspace. In theory snp_complete_psc() can be called directly
+		 * at this point to complete the current range and start the next one,
+		 * but that could lead to unexpected levels of recursion.
+		 */
+		__snp_complete_one_psc(svm);
+		goto next_range;
+	}
  
-	return 1; /* resume guest */
+	unreachable();
  }
  
  static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)


