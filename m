Return-Path: <kvm+bounces-68670-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPOiBEgjcGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68670-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:52:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5124EB8B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CE0C08EF96D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D80259C80;
	Wed, 21 Jan 2026 00:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foEPk1Px"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E2D2C326B
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 00:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956727; cv=none; b=XjjmSmX0nwPqcq87COzs8M5B6YBzCYaq8THjmpmd7DeEUsnidgirKcSuiiDDMV5+izXxkr5S5oLsDgRl2DhIW6Vn3Al4OiNcRJ07qzNK9q47bMU1V0RSdMzGaUgtBRu3/YLGdEwAreaMfR4CAcLl5a1gkTmatVs9et5x8OB67N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956727; c=relaxed/simple;
	bh=EkVcNVO1CNLIf3T/s28sXrF08YLCrCvJ5AM2yKBw9Zg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dg6q5qqVXe7syIcDCcJP+ZUmQiUlkYZLXlfTXkOAihG1s6rrpRunYm1jmTxGZQpXv0GpTmMRNV0TsTrhZWlteSM+pa3tb271vTJkZ+RzIhQJPIn7FM/EANZ0CTUjV5Yo59dH+3ReraR/SOuUf5RUSYI94/rULaHlC3RWKVerelI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foEPk1Px; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a089575ab3so54109835ad.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768956725; x=1769561525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+MdgG0Ul2crpYgoSbV/KPCK+3WNDc/xDp+a+HIFVTx8=;
        b=foEPk1PxlmMmBL/K5FC3+xojidM8Udkpz0XkmLQGlFju2kBm/dmXLwIIspG8CT5rtV
         cl6kzo4URhDm/pke7/1Bdvp9c1tR6CjZ3TnpG3QxmP6x8B1TxH8UqNMcKo3SaPD70mzr
         yxYWxiksno5Z2VaNR2/ifWI9tOIX8Ja/TvEYyZUqVlsgdApSMqh863BIDg1VQy8n0QlS
         wJaZnIPqk3QUBe386fze6KmupD6532cAYLvKH/04sr7PojrbE9Kad31XHAGS9EOFvoZe
         pSPKnRdQAzUfYzeDsclPZaXp93Cg5k/QS8ZTlb2QNhlIjmzgLbOtXqmPEXTY6LYDsQ54
         AeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956725; x=1769561525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MdgG0Ul2crpYgoSbV/KPCK+3WNDc/xDp+a+HIFVTx8=;
        b=PySdZsyMAAORn18M4wZnwhsXuHrn32P2i+kkROaMAA0FOyDHZpQ2uiffxfG4hnYrYC
         fJR5ZBDbgjKgn9MpeMMNAEIjm2hd/DMDmjpR414o7S29VUozmRk30LwZTkYaqttYizcU
         9SyJd8DffH/O+yKlX7Ots5nGl8OtcmnydT6F01jMJLSD0/b/4pKatDlk3M0BLxnaVck9
         GuklTL8oFSv8Y1niw99i8nFV0vWJM/ICkJcEEau9Gizq5lGmzviRiRYRdo9IQCVr1Al3
         pTX4U5tYNhmClyWRR+AFTvyqkHdYHKS+cWkoM9E/4InzCCR7hsWcw13fq3Vc3XeLBSCc
         TaRw==
X-Forwarded-Encrypted: i=1; AJvYcCUKOfHOY36MAsnhGQnzxLs11V9pzg2QZvxpcz58xmxhAnBuXENOZSIKlkxdGN60UhB+46I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NReKxvq0ZtOHZojEi6whelfMk2fu06/poWM2ElBRQrMtkgut
	12vkhKlGPFXWhEoKgJrhYOIRYk5B6NpcAspYBoK++aupDdljLRkgnyKDi844JwYXUE6w2dlbR9E
	VX0IefQ==
X-Received: from plbmt16.prod.google.com ([2002:a17:903:b10:b0:2a0:c208:8799])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db04:b0:2a0:bb05:df55
 with SMTP id d9443c01a7336-2a76951f3a7mr29795775ad.21.1768956725049; Tue, 20
 Jan 2026 16:52:05 -0800 (PST)
Date: Tue, 20 Jan 2026 16:52:03 -0800
In-Reply-To: <20251121005125.417831-13-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com> <20251121005125.417831-13-rick.p.edgecombe@intel.com>
Message-ID: <aXAjMxbeMO0pioNF@google.com>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68670-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: AE5124EB8B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Nov 20, 2025, Rick Edgecombe wrote:
>  static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
>  {
> -	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct tdx_prealloc *prealloc = &to_tdx(vcpu)->prealloc;
> +	int min_fault_cache_size;
>  
> -	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
> +	/* External page tables */
> +	min_fault_cache_size = cnt;
> +	/* Dynamic PAMT pages (if enabled) */
> +	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;

The caller passed in number of pages to be added as @cnt, don't hardcode what
could be conflicting information.  If the caller wants to add 50 pages, then this
code damn well needs to prepare for adding 50 pages, not 5.

