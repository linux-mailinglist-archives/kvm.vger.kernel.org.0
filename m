Return-Path: <kvm+bounces-71875-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGqKGxZMn2l+ZwQAu9opvQ
	(envelope-from <kvm+bounces-71875-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:23:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 188D319CB1E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4C5933008995
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D59C3EDAD6;
	Wed, 25 Feb 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KO0P3/kD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC9D3D668E
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772047378; cv=none; b=iVskjoMjl30QaXeOUhEFWtm+VKb5ATsEWraX/pLt0+sQK98teifDjKgVQFmnVHzGGkcSXlUKwP+MP+L95omoMAWMba3qMYi/a8E0c7kRVMuukKR/V+tKNv9sqTYaHw2bDed2eXIE3YOeNBeZjQXNros0EgC3TcMgXcYDE2GxxRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772047378; c=relaxed/simple;
	bh=hdbt2gJkdJI1X/bk9bWaKI1byIhBqpu3nOa+BwPD3Qs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gzsWzunm/xV3ikiotnjhIiOzH3XwPrTaUs3WJ+kP39lEiMHYo0ktOPi4kOYL+EmxbM1uoaDMGkDymJfFPUdIcs9dhK9IKIE87bhcOP7qN8QW2yJa5gFsHWfQiWaZsZ+Y6sR56Iah0XkQ6tEBmq1vcjiot+XTC6dYRfGuUXqTMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KO0P3/kD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso9356007a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 11:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772047377; x=1772652177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RkgOtQvbHz735PaP9GU0CKR7oczRQkq04nK8VZg21mE=;
        b=KO0P3/kD9X7krcPC/kCoUWTYacXB2CpKDZu57Kwm/CILOsQ+qmdXNKhfYVcFqPCQg6
         nakOlpf6xkr9qHPwKSufBm1qYwhkXu58jXZ+qMgNm9sm8WRRC+VcVFWxFGLA8LciKlRp
         setdIa67fXT8PH1rLueHCCBj6xsBcJVpUu/TM7LjaLHN4mySdOYFxbuAQDenqojife9B
         GseyytXD776osuMgO8tGwMHXGx/mnU5aZr/deqjQB8GxvDgoINOOwbOAn6xadHnqqszZ
         IlTpH/1Rzk/6W8GNfNXHFrOUpaPJmaEWYx3M6go6s8y7QuxzGGZgF+xvuF7hsCJb37Zs
         PnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772047377; x=1772652177;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RkgOtQvbHz735PaP9GU0CKR7oczRQkq04nK8VZg21mE=;
        b=wZbHH8lpSlEWhM1y+PomOQkd8iocLp6tjHA6qvDZNudf0gXzfgTb6hwK/ySVzPbbzQ
         8croKcsGaUBlevPzQJbNTtdSrIKjveYcQeWN2BYljSHYsiC/JtN3VJ8n2lSxxhT6tgdJ
         A4fhDZj+QzBmH+lmr5DxVbrlVnyppSPrN9ucbxy8K63eYnVO1qt9g4G70tgG/Ypens1g
         PIxTfn0eH4kl5Rv7B8Z87T/rnucU8j3few9taW5gZwJrBhsAHN5Il61U3ZK7u3Qw2Qag
         LjKIKgEuWN4ck5wRzuzlDRp1e3U3MaUDpzuHjiWKTnFzzVsJeOBWWa4WKxhJgaRbYsLM
         mbow==
X-Forwarded-Encrypted: i=1; AJvYcCUMaT6dgDbya6N2tBfiyiMj/RSaNuVsk2o4Dd5eEx7HhXOUmfH2/m2mje6WtSYzU5BBp5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/9KaNLqjYXuwa2BWcz3veqcPEXEBox1E4tXU7EGquNLssiThJ
	PXQRnbPZ+ut9mRfmgZ1bVvCtKRBcbPhSIhp5K6sJlm+rCWu4slJN09Z6Rwy0WeAX7HJ1Q0RLZUD
	rWRHCiw==
X-Received: from pjzs1.prod.google.com ([2002:a17:90b:701:b0:356:3104:ed7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:250f:b0:358:ee5f:9c04
 with SMTP id 98e67ed59e1d1-358ee5f9f15mr3687808a91.30.1772047376873; Wed, 25
 Feb 2026 11:22:56 -0800 (PST)
Date: Wed, 25 Feb 2026 11:22:55 -0800
In-Reply-To: <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com> <20260225012049.920665-15-seanjc@google.com>
 <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
Message-ID: <aZ9MDxJ1iEhIbJJ6@google.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, 
	"x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com" <zhangjiaji1@huawei.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71875-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 188D319CB1E
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Rick P Edgecombe wrote:
> On Tue, 2026-02-24 at 17:20 -0800, Sean Christopherson wrote:
> > +static inline void __kvm_prepare_emulated_mmio_exit(struct kvm_vcpu *v=
cpu,
> > +						=C2=A0=C2=A0=C2=A0 gpa_t gpa, unsigned int len,
> > +						=C2=A0=C2=A0=C2=A0 const void *data,
> > +						=C2=A0=C2=A0=C2=A0 bool is_write)
> > +{
> > +	struct kvm_run *run =3D vcpu->run;
> > +
> > +	run->mmio.len =3D min(8u, len);
>=20
> I would think to extract this to a local var so it can be used twice.

Ya, either way works for me.  The copy+paste is a little gross, but it's al=
so
unlikely that anyone is going to modify this code (or if they did, that any=
 goofs
wouldn't be immediately disastrous).

> > +	run->mmio.is_write =3D is_write;
> > +	run->exit_reason =3D KVM_EXIT_MMIO;
> > +	run->mmio.phys_addr =3D gpa;
> > +	if (is_write)
> > +		memcpy(run->mmio.data, data, min(8u, len));
> > +}
> > +
>=20

