Return-Path: <kvm+bounces-72592-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FhACSg6p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72592-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:44:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCBD1F6483
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44B4B30247DD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11817372687;
	Tue,  3 Mar 2026 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rrf3kS9R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9644E37C90B
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567057; cv=none; b=DzPjfFFrygzWdhBdQaL/FHnOTY9zLloW/r+bmIHRp3N/UALNzlg0ocEiksJp/RRscMD6W/8b2EKOgEVNcbyC1ypLqch5lo0OI76B1J2IASmN/I7W4J23hdpn7NW/PTBL/05G5EzD0RjGLN1nax5jjyfHmsmeg9xLfAdadDxsNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567057; c=relaxed/simple;
	bh=4pso3iO729dZpcd/ENmTltLyuClEQkS5sXGDOONqMh4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BpkGJuOI3ldtvVIbhk7yIZMAcsxZmISj7KjZbQCxiq2MLc+FUXWOzNtAab2nfWCebKS09qdGn55QTjQHQOtu+HmzQb0bN63IauTg6XFYji8fzZkBBmaOlUTegwwNH4swB9OfSXnLASnskKBpA5xqn8P0tCP1Zwpw0rHWIqT0FDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rrf3kS9R; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4a6bb316so29197155ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772567055; x=1773171855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7H8zcNkOosHL5Qyyqu/2sQSqxUPrIKJPaqmDB4tPT+k=;
        b=Rrf3kS9RC0h+6Zwd6eUNe0f7J6eEG1Fdf1FjqIhBc1h+HYbvJbVkzm+YUpvCHCpr+w
         DqDvWVJ0Lss/uW3WEmxB2J+9FCl3yy0p/7f5+A/ivFgzHDt+WAoznbunLW9ShmP9uLMs
         3ruO4mMvtZWihXCZys3A/z9wqpNcJVBHUvrO+voIR8o4LGsMG7y2O2b4cIK+2Uyalu8e
         FTycUq2+ufG3S3JxAbyKdkvwx9dYX8+2BhabUGD0Dt/VwyFY1eQQ07KnhIgWBf/qSXpz
         c8FFe/oqOq+jLB6gm8JqUdGHz40TwkRsQYEv1A5R77dGPJv0tZVA1G6+W+2GF+4BN1mL
         HFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567055; x=1773171855;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7H8zcNkOosHL5Qyyqu/2sQSqxUPrIKJPaqmDB4tPT+k=;
        b=s2p0apwM0ksdIE58zS3++TaxofUuylU1KMSMgm8k9xsuZGUV07qy4VuqhRTKSSEbWb
         7OENt2wI+9UONDFJhm5yoLmLSfoNHLpKPxiXJ6uwQzr9061AHSg92JyNRR1H44rTlwHB
         1Zue/ZZylXzzQKHRNovaSGq/4EsG9Dcx5CgGfQotbln6L7jJ1+Qe0HeuEi0G5bma2ZSM
         zhiG7FR+07HKPXXNCWHaP+KFzRQmxwunbvSqii7UYGilsEPeHG3RAi5SgvtmdDm7b84s
         dDSwg/z+2O7zuLqw2/rT7OcoSr09jJxq/CrwWVYqX/kpqJgpqIBfFhW94GnJKp6E2t3S
         svwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4ola2YfgSTPHVIS2QmjZO+sjohgtCpcnryqcVeRblT33ky65b017N9KTsQh3DSyMrrd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4D+3FgT38HHNZzfGIQH3Y6vmYAnjlagQH7NYUl/TTpaFSCgRt
	S9ZigLTTErc3R6mTOFwfadyhn+ckILz/LKW/n40diABi8y2mVii4BbQNaBdj77+7XseqzoeMD06
	uzCUIAg==
X-Received: from pjbrs8.prod.google.com ([2002:a17:90b:2b88:b0:34a:c430:bd91])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2b06:b0:2ae:4996:430b
 with SMTP id d9443c01a7336-2ae499644cfmr108344665ad.26.1772567054562; Tue, 03
 Mar 2026 11:44:14 -0800 (PST)
Date: Tue, 3 Mar 2026 11:44:12 -0800
In-Reply-To: <4574be9a29d75d565e553579ef6ce915ef33b19b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com> <20260225012049.920665-15-seanjc@google.com>
 <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
 <aZ9MDxJ1iEhIbJJ6@google.com> <aaZGTY3CzhaCb1lc@google.com> <4574be9a29d75d565e553579ef6ce915ef33b19b.camel@intel.com>
Message-ID: <aac6DGISvMX4krhb@google.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com" <zhangjiaji1@huawei.com>, 
	"kas@kernel.org" <kas@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7DCBD1F6483
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72592-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026, Rick P Edgecombe wrote:
> On Mon, 2026-03-02 at 18:24 -0800, Sean Christopherson wrote:
> > Ooh, better idea.=C2=A0 Since TDX is the only direct user of
> > __kvm_prepare_emulated_mmio_exit() and it only supports lenths of 1, 2,=
 4, and 8,
> > kvm_prepare_emulated_mmio_exit() is the only path that actually needs t=
o cap the
> > length.=C2=A0 Then the inner helper can assert a valid length.=C2=A0 Do=
esn't change anything
> > in practice, but I like the idea of making the caller be aware of the l=
imitation
> > (even if that caller is itself a helper).
>=20
> Seems ok and an improvement over the patch. But looking at the other call=
ers,
> there is quite a bit of min(8u, len) logic spread around. Might be worth =
a wider
> cleanup someday.

LOL, "might".  :-)

Definitely a project for the future though, especially given how subtle and=
 brittle
this all is.

