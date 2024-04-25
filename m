Return-Path: <kvm+bounces-15886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6DE8B1821
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 02:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06C71C234FC
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 00:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97384C98;
	Thu, 25 Apr 2024 00:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pnBOa8Hk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1CC816
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 00:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714005923; cv=none; b=JoCt8ZmHUlft6Thz4JP6tX5GBIXSVmz+Grt1Pyjfo4uDsU9v7GQNosEzgBaOH/excyaRx4wI/WsDFbO9lCKjcbe/NYtb9SxDOJigRH91qYJmm6dqiMjNbl1kdjdn3Q6C49XPqOkoisdCAmop3iBSaIZk3O+AHlL1B0A1Z8ndKQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714005923; c=relaxed/simple;
	bh=C9Y7sI7S2lG7PgZ43yy72fujrqM9J0v4uwf6k/xCgvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g6fdThWH0R/JswxEwX/nza5vfGD/nLW5o5kLKS6G8AiQAB+Ngnpw/Rrf+N4D1iUBuRMlICUMWqG08j5EjYa4w7N5HQFlk2Tf79/xWJ0UILPTY8SQvSdeQ06Sd5zB8JvTQoV0D/knJIZfVZXZTRMdZP8SuqYvq5imaptQZyXgMMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pnBOa8Hk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e91766a8c6so4012335ad.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 17:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714005920; x=1714610720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ehGLjycYzRvV+RegBC+30jOD4jldKpLBzIes+g3Te5M=;
        b=pnBOa8HkR7a4mkmP50aCwSfpKIPU+FdpiJJblUV5hwiKAQH4ctrESEHh92BnFNaoSJ
         O0+wmX55wbsLNDJAXaIiV8ZztVmxY7bN5fozNn8IaBKvFHL4RcVnSzWRC+j1yeqHeB+r
         KZ8V2FbxYWDhrZvEoahar9EcCJBe82hXJ/bwQnwjg1hHCFHu6yF0k8WUc14Ur9xCqm0n
         s6j4bWEy3+4paaYgE2gToY1H10YXE6gTkC4v1iq9WR8SjCCmRCCDAo5cO+OXHrAxgX3F
         KmK4/YEtfLanvXuCU0beDPLGdVzKYAEMgs7dEDrdoYNvX/fzZxkN0Rurms5PiXSxoiKv
         bDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714005920; x=1714610720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehGLjycYzRvV+RegBC+30jOD4jldKpLBzIes+g3Te5M=;
        b=pl9yGSlfp8rkrxqMqeZPtJjX6BB5xQlwbuSiMp86c24KjqKNM63ofyVbhBtng0Y5zU
         ZoO9HroDrSQqEwEor+w6/08NEoMCvUgUpKCxBOCikTEXXkQlli4pX2PygfSgLny1UioD
         Swod4Fg5uposCyHd1haOXeTTWjf5ELne+9fSRe/3QIIUWHjnm4V3ve90ZDXRcgiVggWN
         38FNNan6ZlZRl4ekwXcCwjLhoXou8MG/tyyjGkMBtjRFLvhnMeXdlBo6fevubfce0kPw
         +FeekG46+IsJr8k97aSI1orqBRDa+YlxFiZ9wRQllmwVmPwWKT03PIUdULAzlzi3+t7U
         0uyw==
X-Gm-Message-State: AOJu0Ywls0P/3F7DE/mm4piQgiYtJX0nysvXpRJpRimb7RX6RTf3Q1Ke
	mNeOg5WelAQp/l8znK+8PUDCR0Dc1SoI/DSXGpAvImqo6L7E4cmPuHJUtGnLN3Aaq/AiEWcRLMm
	xQg==
X-Google-Smtp-Source: AGHT+IFR9HYBLarlt9ZsOvhUbV8OSiFHhgh7AV7IIXgugq1S0Quy5L1i73/i89wy47ffAjGpD3+fDEtcXsg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244e:b0:1e3:e6cb:a06e with SMTP id
 l14-20020a170903244e00b001e3e6cba06emr344607pls.5.1714005919640; Wed, 24 Apr
 2024 17:45:19 -0700 (PDT)
Date: Wed, 24 Apr 2024 17:45:18 -0700
In-Reply-To: <20240421180122.1650812-17-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-17-michael.roth@amd.com>
Message-ID: <ZimnngU7hn7sKoSc@google.com>
Subject: Re: [PATCH v14 16/22] KVM: x86: Implement gmem hook for determining
 max NPT mapping level
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> ---
>  arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c |  1 +
>  arch/x86/kvm/svm/svm.h |  7 +++++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ff9b8c68ae56..243369e302f4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4528,3 +4528,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>  		cond_resched();
>  	}
>  }
> +
> +/*
> + * Re-check whether an #NPF for a private/gmem page can still be serviced, and
> + * adjust maximum mapping level if needed.
> + */
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,

This is a misleading name.  The primary purpose is not to validate the fault, the
primary purpose is to get the max mapping level.  The fact that this can fail
should not dictate the name.

I also think we should skip the call if the max level is already PG_LEVEL_4K.
Something _could_ race and invalidate the RMP, but that's _exactly_ why KVM
guards the page fault path with mmu_invalidate_seq.

Actually, is returning an error in this case even correct?  Me thinks no.  If
something invalidates the RMP between kvm_gmem_get_pfn() and getting the mapping
level, then KVM should retry, which mmu_invalidate_seq handles.  Returning
-EINVAL and killing the VM is wrong.

And IMO, "gmem" shouldn't be in the name, this is not a hook from guest_memfd,
it's a hook for mapping private memory.  And as someone called out somwhere else,
the "private" parameters is pointless.  And for that matter, so is the gfn.

And even _if_ we want to return an error, we could even overload the return code
to handle this, e.g. in the caller:
	 
	r = static_call(kvm_x86_max_private_mapping_level)(vcpu->kvm, fault->pfn);
	if (r < 0) {
		kvm_release_pfn_clean(fault->pfn);
		return r;
	}

	fault->max_level = min(fault->max_level, r);

but what I think we want is:

---
int sev_snp_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
{
	int level, rc;
	bool assigned;

	if (!sev_snp_guest(kvm))
		return 0;

	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
	if (rc || !assigned)
		return PG_LEVEL_4K;

	return level;
}

static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
					u8 max_level, int gmem_order)
{
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	max_level = min(kvm_max_level_for_order(gmem_order),max_level);
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	return min(max_level,
		   static_call(kvm_x86_private_max_mapping_level)(kvm, pfn);
}

static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
				   struct kvm_page_fault *fault)
{
	struct kvm *kvm = vcpu->kvm;
	int max_order, r;

	if (!kvm_slot_can_be_private(fault->slot)) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return -EFAULT;
	}

	r = kvm_gmem_get_pfn(kvm, fault->slot, fault->gfn, &fault->pfn, &max_order);
	if (r) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return r;
	}

	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
	fault->max_level = kvm_max_private_mapping_level(kvm, fault->pfn,
							 fault->max_level, order);
	return RET_PF_CONTINUE;
}

---

Side topic, the KVM_MEM_READONLY check is unnecessary, KVM doesn't allow RO memslots
to coincide with guest_memfd.  I missed that in commit e563592224e0 ("KVM: Make
KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY").

