Return-Path: <kvm+bounces-69421-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 1dv6NNiPemnU7wEAu9opvQ
	(envelope-from <kvm+bounces-69421-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:38:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72C09A9AA2
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C57A7301B14D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01973344046;
	Wed, 28 Jan 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tjz8JUAH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1227703A
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 22:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639886; cv=none; b=icrFVySgSz+ii1dO437Y93FOcO/JFHByDCx7SgbxiFOMlz/ccRTJWUYgDQEit6W0QN455F2h/2V4EO4GziuykAjByodrxDK1/b0wcTDBzPAxic0ukjp+8bsWJ6sk+cj7r52EE/nFE+sciX7647JYhy7H0VlA1aMeyCwnZlPFkFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639886; c=relaxed/simple;
	bh=VuA/OV4uXBqLtKIM1s4ioGq6mfl0JcINU/SWIWPpEnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pSlT4YP59U3YC3CiIzhBGKMe6C8ZOEuu61M0KS7SDw0IIhhmcskm1otuxNyJIR3rsPFU53PW2/X8SQIeNstyiFLj7jY/aoH9qybM4F+fhbQpMNyNQA1OCddCgpTrqPtTqXZ7qSNCkILwt4OXstHN2XXlN24lpjlsOvCjQMEg6s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tjz8JUAH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7d7b87977so2287395ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 14:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769639884; x=1770244684; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nsIpwwkWhDO8H63wkitefVEaF1rkr0l4uf0sBQ/fFM8=;
        b=tjz8JUAH2xnrVZtIN68QtIfpVVPfC1i9/HqUGmVZKMWFTk+Xyc33Q/KQUbgRcw+4jq
         6aFvlzDM1nDhdcWTWVeansa3M2naI328JfyD0A0YuY9YkYq/bb51Unn0uljgV9RT7rZM
         XoJmpM+yKFpS/ljORDuSZ8rc3vLLabUQw9lzT3vlmKY45432IG4ZkTaXiPeGJ+eKHvbU
         wnQbVu57bRSuSsENyRy4CpuLcIZIw8IjcvN0xywJtq0IEJrDYhLseOhSrDma9DRlN/Bx
         2ABPjgMLJ3e8yJ5HEp35t78W6pdr1sRNzwYI3pyulw/hcFbNLAH/yau+MoWfH7BnRc2Q
         ocyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769639884; x=1770244684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nsIpwwkWhDO8H63wkitefVEaF1rkr0l4uf0sBQ/fFM8=;
        b=jAi3EDqZO0eLiYhFXYoft1/TSHdciselWJ9vQANHNvIzlRr8Rh+Gc78KVTnWaLwz19
         /1Qzo76/Aw+YMXN+2v0b/c/bsCFSSBpOUgUpS6LhFj0eQi56Lac6mlHoG8wonJzqx30C
         iVOb/oIXvQrDgwqt/77pJlE8C7BUHVEalvg1tf7ZNDLOaRshjB24JmNNH8wCt7cClq6z
         T28N/0fcTYc4kFL1+hxwbNNgjpfrPdOlXdnDWy7khXN+TduZ1yYpO8q8jdASnpReL68l
         evwIvO7Ry5WO7SrWmux7Z9bGkmQkRzR5aI79JGjdWHnw4OLyq3aWSNC31MNbW2d8DfYq
         K4Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWyLe3MYySlusXUNU2AkobWlZNhwi//N4SNwVsW129HmwldfzjgeYQpLqly0jf+vK2PR5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzflyjNn0vErZPYuJByOKg/pomYYs8mrXwoe7KFPMddL0ABe4zL
	OOvoKxs18Mw2mNKWhLeOn7jAaDzBFGk3pJmcj11bMGbfbsJrv7FO9d9ePg665Tuy9g1tQmmegZk
	Pt6vttg==
X-Received: from pllo20.prod.google.com ([2002:a17:902:7794:b0:2a8:a03b:32c7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f68c:b0:2a7:682b:50ac
 with SMTP id d9443c01a7336-2a870dc866bmr72342415ad.28.1769639884332; Wed, 28
 Jan 2026 14:38:04 -0800 (PST)
Date: Wed, 28 Jan 2026 14:38:02 -0800
In-Reply-To: <20260106102040.25041-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102040.25041-1-yan.y.zhao@intel.com>
Message-ID: <aXqPym6QSFQTn9Cy@google.com>
Subject: Re: [PATCH v3 07/24] KVM: x86/tdp_mmu: Introduce split_external_spte()
 under write mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69421-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,kernel.org,intel.com,google.com,amd.com,suse.cz,suse.com,gmail.com,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 72C09A9AA2
X-Rspamd-Action: no action

On Tue, Jan 06, 2026, Yan Zhao wrote:
> Introduce a new valid transition case for splitting and document all valid
> transitions of the mirror page table under write mmu_lock in
> tdp_mmu_set_spte().

...

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  4 ++++
>  arch/x86/kvm/mmu/tdp_mmu.c         | 29 +++++++++++++++++++++++++----
>  3 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 58c5c9b082ca..84fa8689b45c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -98,6 +98,7 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
>  KVM_X86_OP_OPTIONAL(set_external_spte)
>  KVM_X86_OP_OPTIONAL(free_external_spt)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
> +KVM_X86_OP_OPTIONAL(split_external_spte)

This is all going in the wrong direction.  Sprinking S-EPT callbacks all over the
TDP MMU leaks *more* TDX details into the MMU, and for all intents and purposes
does nothing in terms of encapsulating MMU details in the MMU.  E.g. the TDX code
has sanity checks all over the place to ensure the "right" API is called.

The bajillion callbacks also make this code extremely difficult to follow and
review.  It requires knowing exactly which TDP MMU paths are used for what
operations, and what paths are (allegedly) unreachable for mirror roots.  Adding
hooks at specific points is also brittle, because an unexpected update/change is
more likely to go unnoticed, at least until the system explodes.

There are really only two novel paths: atomic versus non-atomic writes.  An atomic
set_spte() can fail, and also needs special handling so that the entire operation
is atomic from KVM's point of view.

There's another outlier, removal of a non-leaf S-EPT page, that I think is worth
keeping separate, because I don't see a sane way of containing the TDX-Module's
ordering requirements to the TDX code.  Specifically, the TDX-Module requires that
leaf S-EPT entries be removed before the parent page table can be removed, whereas
KVM prefers to prune the page table and _then_ reap its children.

We _could_ funnel that case into the non-atomic update, but it would either require
propagating the non-leaf removal to TDX after the call_rcu():

	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);

which is all kinds of gross, or it would require moving the call_rcu() invocation,
which obviously bleeds TDX details into the TDP MMU.  So I think it's work keeping
a dedicated hook for that case, but literally everything else can funnel into a
single callback, invoked from two locations: handle_changed_spte() and
__tdp_mmu_set_spte_atomic().

Then the TDX code is (quite simply, IMO):

static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
				     u64 new_spte, enum pg_level level)
{
	if (is_shadow_present_pte(old_spte) && is_shadow_present_pte(new_spte))
		return tdx_sept_split_private_spte(kvm, gfn, old_spte, new_spte, level);
	else if (is_shadow_present_pte(old_spte))
		return tdx_sept_remove_private_spte(kvm, gfn, old_spte, level);

	if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
		return -EIO;

	if (!is_last_spte(new_spte, level))
		return tdx_sept_link_private_spt(kvm, gfn, new_spte, level);

	return tdx_sept_map_leaf_spte(kvm, gfn, new_spte, level);
}

