Return-Path: <kvm+bounces-69634-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kEMpCBDee2kdJAIAu9opvQ
	(envelope-from <kvm+bounces-69634-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:24:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B656B5461
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F39653033F9D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A0836AB72;
	Thu, 29 Jan 2026 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfwWZ9Aw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707236AB46
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725406; cv=none; b=sO64QG/doOHOvP4jG8wfzxpG0dJc45VWJ5w7TK5KpteIhkbs3usIisxDeRgOIOvhlZpoWJ4Ftn5vAD27XKo84DFzw2CIqYv03iyLLcr2aATzgA+YiEcDgcxtL9SaR8kLkTGOnG+jVEWIj5ahVRHB30qg3N90ssgDB9y3oMEuoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725406; c=relaxed/simple;
	bh=XId/psBz2B6CRgPkYn1/L0PMl47eroAR8b7KTrFAN38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sGzLaz9g6u6R9w4tzsSWgFrIQjGW/WHqJXd5TPU8Ez1oKwPIrj81aYdWxK52cjhUkqQJWVY4iWUqbL+gk+96cXsz6FNumMMC6Znjcl3t87dkTuhzn9U5dU+Fnl3wo936iv0GkMdi8PIHjlv6VEvbaGC5vRD1Ydt6tLlwHrEOYAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfwWZ9Aw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ea5074935so1263654a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769725404; x=1770330204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CjpoE/7MkU533iWOJXX/9jSCPi0JjIxUjWp+cR10TGk=;
        b=bfwWZ9AwhlrBj0Z61xrzMScoMjraIUfNpMG3VfxRuEKBBofb+Pzn/ZWKZ2P3Ch2p+Y
         xF15o8tocd9q9aYiNtcEvOVY27DxnwM/7on+At+vAzj8xAJ20+PBoc4ZoaJntnZj/3AH
         6NDiVwOlYr9kYaK2W6HB2ByTMqaObMeXJh4X0bOBNZo+TIMOVdM5C7luW32vKwe9a7cr
         ah+hFUrduqDW9YeM1HuzeZcxxOmb6TMFETQkhAR5ZbZYbOiYANKyt5JdZ6DmKIarz9SJ
         ife/4514An3XPNlAAjbj5i2QdqogR5TyBVwJZ4l6ItEvlfYmSu7a2o3bOu+fegVY6QF6
         vvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769725404; x=1770330204;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CjpoE/7MkU533iWOJXX/9jSCPi0JjIxUjWp+cR10TGk=;
        b=J3A8FUHraGD87Ou4zTyILNivs4BIvY3zzL7KlUZCNoFkWC4mAbLQS39mBihO7/Jf6I
         kF+zuWxxjLxQ4uLpHVXT667W/+qQzH5N8EzBCUHjoaHnu+IS6g7vTKVLtO4e8EheQu7p
         935kIIXhIle5Qiu28lTUCJDiqH7a1C4Te4sd8E9AtrV38WkaO2FePZhS78n3PQWxmKGH
         XuNiEIgqSIq7hZMwFPt8vAD/4rA7gPAYqSr3cJJ9UkArpFSeOQV7coVCwe7DIbyeI5sV
         1zHB7+IjsO1t5SQw9YcG8UFni8f+yrFK0xOAZsjqQTNvBIt56uzca35bcuVKAuA6ceYo
         wZVw==
X-Forwarded-Encrypted: i=1; AJvYcCXu7CXUwdcdFtxobnxeXoD/f7D/uu9NbnwyXSN2BXuZ1EGvo8rkEp0sJYuELqGFj+hjsL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL0NZ44ti9ITG26nWDVvKRsYvHiepxRlRjzxYwU5deedMamI2I
	RwcA3u8zZsWmnRDPVEw/WziPq80Z0p+nf0e9Kjd0semWp7Opy/ZIPsZ4jcupXU3LMqMSXSDT1hY
	XwpmcMg==
X-Received: from pjd11.prod.google.com ([2002:a17:90b:54cb:b0:353:28b4:c297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d445:b0:340:e8e9:cc76
 with SMTP id 98e67ed59e1d1-3543b309885mr823538a91.11.1769725404404; Thu, 29
 Jan 2026 14:23:24 -0800 (PST)
Date: Thu, 29 Jan 2026 14:23:23 -0800
In-Reply-To: <fbaeb0d2f4658efd4c7bb61ac0ba2919c8226a36.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-3-seanjc@google.com>
 <fbaeb0d2f4658efd4c7bb61ac0ba2919c8226a36.camel@intel.com>
Message-ID: <aXvd2z8HmLFd50io@google.com>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69634-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B656B5461
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Rick P Edgecombe wrote:
> On Wed, 2026-01-28 at 17:14 -0800, Sean Christopherson wrote:
> > Pass a pointer to iter->old_spte, not simply its value, when setting an
> > external SPTE in __tdp_mmu_set_spte_atomic(), so that the iterator's va=
lue
> > will be updated if the cmpxchg64 to freeze the mirror SPTE fails.
> >=20
>=20
> Might be being dense here, but is the bug that if cmpxchg64 *succeeds* an=
d
> set_external_spte() fails? Then old_spte is not updated and the local ret=
ry will
> expect the wrong old_spte.

No, the bug is if the cmpxchg64 fails.  On failure, the current mismatching=
 value
is stored in the "old" param.  KVM relies on the iter->old_spte holding the
current value when restarting an operation without re-reading the SPTE from=
 memory.

E.g. in __tdp_mmu_zap_root(), if tdp_mmu_set_spte_atomic() fails, iter->old=
_spte
*must* hold the current in-memroy value, otherwise the loop will hang becau=
se it
will re-attempt cmpxchg64 using the stale iter->old_spte.

static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
			       bool shared, int zap_level)
{
	struct tdp_iter iter;

	for_each_tdp_pte_min_level_all(iter, root, zap_level) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
			continue;

		if (!is_shadow_present_pte(iter.old_spte))
			continue;

		if (iter.level > zap_level)
			continue;

		if (!shared)
			tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
			goto retry;
	}
}

> > =C2=A0 The bug
> > is currently benign as TDX is mutualy exclusive with all paths that do
> > "local" retry", e.g. clear_dirty_gfn_range() and wrprot_gfn_range().
>=20
>=20

