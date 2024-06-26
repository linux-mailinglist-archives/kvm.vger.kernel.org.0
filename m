Return-Path: <kvm+bounces-20556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB4791837F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 15:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6F62842A8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4671849F0;
	Wed, 26 Jun 2024 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YcmkPYvb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B111836F7
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719410293; cv=none; b=W97nDQZe9IcdMlolcy+1cwrUq9HDRPmlqDEF8eHpoC+B9mLWQscWcROSBSji8u7VVaLyyUrkiAaAl0uTiy3Xlml2pBgJYXj6Yn5Kx0lo5wGhDDvTuhnVRt78MB7j1PI+M6jmn/Zk+LXCeyf3j5CrWxPylufMc/UinYciir7DXMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719410293; c=relaxed/simple;
	bh=3YxsMFFGaNZcDTtzTrv5d7Iz9eHx7NSyqXKCM81GTSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVAPmufR8qCMe2FbuxlOrjjcOC2BQifkfx+5fmkkrUuM9K/0VlPe+0Bu9wXDwx5ZotDm5NlvdJstodTEGFzFzxSaw2bv7ryoKvCSrLbcUZ04rGZnQaZmMP6reUdG9M0yTWdxZkg8Pfa+LoypjFP3Q2NdpHvGY3CvbyMUsRMSR/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YcmkPYvb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-706692c0695so5913608b3a.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719410291; x=1720015091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bZITLWmhjXXeBaBmuACBK8fBjqn+1NW0CaRg2CPhFg=;
        b=YcmkPYvbLmPAIsJ+IrTtmJMN/HRyGsN7wTgqNbe6YV2lW8YzLJgLic/FCgK5w2F3T2
         mS05GaZ82YkrNYmvIigrNciccVVrX+aOPGeH7s+J9Td7gNRGkgQpQLiosuSFvljub+Gt
         AFX2sPgkufhPIZ+ROWXJC+Zx+3Tl8wguYWJ7LL37hip/1M5961cshoNrOIKkhgGNBzZ5
         1DfQ5reQ6pjH/mJKMvmCf30qCJHevN6yXiZVkO3dkswcZ6bCfSRG3/B4ppWR68SwKAjt
         DXIfqD/8URV9x/UkpMrZiyMq14tFsN8MpbWFio1QmlxiIwFlrQYZ/O911CWf2O6qRIoh
         yUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719410291; x=1720015091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bZITLWmhjXXeBaBmuACBK8fBjqn+1NW0CaRg2CPhFg=;
        b=ismhNUIPNFSg/dolNtz57t6NPGPulpArKh4GTk0PVTVGnsUnFlxixPwrWTsBZurTcP
         yFxA0HTDG6z8Msa01HuPfSp8UNTDPqoFgOJLcs+NRe4H85xAKJI8egLo2msrIgITs0Wk
         jDeqiBs4pdvWQ9cE2vPLxn3yewrHDhgNl2AbHIvxbkUf3Y1xA3F/PTHiVFiAcuinKMSi
         BJwlnAOWYV0qxaoZxMFxrP8WIVIkaONpHXCdLbnLQIrK6HiQhIzOzLO7i0wZKxDNmBj6
         h16v3zrOtHt0Uc23pPy5O3vM2UfG3E0eNT+bj/EB2x2W4hNZzFgsRNRxvKDEw7d/GExU
         r3pg==
X-Gm-Message-State: AOJu0YxCbmd5mLN0JkRIIRYrrTQDfCCUtT3md+eYsBG105D80Kx8euDq
	UEW4v5J+9cEfWt5+VBqkRH9GZ4C3oA4TiK5ADendREIfaELDoS+26qWvPxTEw4XsxMmAKZYuxxN
	Cjg==
X-Google-Smtp-Source: AGHT+IEbYwuCL85PGQWnmHJ5cqr5/FxAlcfb36G02CNdKGlmVJ3+RFvDkerDQA9Du3lr0/Rn7228PGUyug4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3023:b0:705:d750:83f5 with SMTP id
 d2e1a72fcca58-7066e6c6338mr149595b3a.3.1719410290721; Wed, 26 Jun 2024
 06:58:10 -0700 (PDT)
Date: Wed, 26 Jun 2024 06:58:09 -0700
In-Reply-To: <20240621134041.3170480-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com> <20240621134041.3170480-2-michael.roth@amd.com>
Message-ID: <ZnwecZ5SZ8MrTRRT@google.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, pgonda@google.com, 
	ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Brijesh Singh <brijesh.singh@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 21, 2024, Michael Roth wrote:
> @@ -3939,6 +3944,67 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  	return ret;
>  }
>  
> +static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request data = {0};
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	kvm_pfn_t req_pfn, resp_pfn;
> +	sev_ret_code fw_err = 0;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
> +		return -EINVAL;
> +
> +	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));

This is going to sound odd, but I think we should use gfn_to_page(), i.e. require
that the page be a refcounted page so that it can be pinned.  Long story short,
one of my learnings from the whole non-refcounted pages saga is that doing DMA
to unpinned pages outside of mmu_lock is wildly unsafe, and for all intents and
purposes the ASP is a device doing DMA.  I'm also pretty sure KVM should actually
*pin* pages, as in FOLL_PIN, but I'm ok tackling that later.

For now, using gfn_to_pages() would avoid creating ABI (DMA to VM_PFNMAP and/or
VM_MIXEDMAP memory) that KVM probably doesn't want to support in the long term.

[*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com

> +	if (is_error_noslot_pfn(req_pfn))
> +		return -EINVAL;
> +
> +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> +	if (is_error_noslot_pfn(resp_pfn)) {
> +		ret = EINVAL;
> +		goto release_req;
> +	}
> +
> +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> +		ret = -EINVAL;
> +		kvm_release_pfn_clean(resp_pfn);
> +		goto release_req;
> +	}

I don't see how this is safe.  KVM holds no locks, i.e. can't guarantee that the
resp_pfn stays private for the duration of the operation.  And on the opposite
side, KVM can't guarantee that resp_pfn isn't being actively used by something
in the kernel, e.g. KVM might induce an unexpected #PF(RMP).

Why can't KVM require that the response/destination page already be private?  I'm
also somewhat confused by the reclaim below.  If KVM converts the response page
back to shared, doesn't that clobber the data?  If so, how does the guest actually
get the response?  I feel like I'm missing something.

Regardless of whether or not I'm missing something, this needs comments, and the
changelog needs to be rewritten with --verbose to explain what's going on.  

> +	data.gctx_paddr = __psp_pa(to_kvm_sev_info(kvm)->snp_context);
> +	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> +	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
> +	if (ret)
> +		return ret;

This leaks both req_pfn and resp_pfn.

> +
> +	/*
> +	 * If reclaim fails then there's a good chance the guest will no longer
> +	 * be runnable so just let userspace terminate the guest.
> +	 */
> +	if (snp_page_reclaim(kvm, resp_pfn)) {
> +		return -EIO;
> +		goto release_req;
> +	}
> +
> +	/*
> +	 * As per GHCB spec, firmware failures should be communicated back to
> +	 * the guest via SW_EXITINFO2 rather than be treated as immediately
> +	 * fatal.
> +	 */
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +				SNP_GUEST_ERR(ret ? SNP_GUEST_VMM_ERR_GENERIC : 0,
> +					      fw_err));
> +
> +	ret = 1; /* resume guest */
> +	kvm_release_pfn_dirty(resp_pfn);
> +
> +release_req:
> +	kvm_release_pfn_clean(req_pfn);
> +	return ret;
> +}

