Return-Path: <kvm+bounces-72548-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDT1HY0Tp2ncdQAAu9opvQ
	(envelope-from <kvm+bounces-72548-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:59:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D17EF1F440D
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E490C314802C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 16:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0E2492514;
	Tue,  3 Mar 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SvdAsliU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073051F4CA9
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772556979; cv=none; b=qd2xv690M+xdSRBZMKVNM1MUQ6H4C5uYqNFEC8Q1NQBpzea9/zkf6BHURNLki4y+XakGhK2EXlBjhzRuObPa6IHLUwxrUwQG7bGspHRns1GoECoymPO94FEtLI0PUSYxuUDaXeUBLMcisFcIT3BvkjX6RADhRBYdFpqo9HmHx+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772556979; c=relaxed/simple;
	bh=eWysGtIDtMY7WDGsLwuZ7l3aSoC9YDb5TvHL34ug0ic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fa3+YlLUGP2CLly7t8iM97fsHx7q3i8rUubIz93iVihYeJgfWLN4GgtaUd4PwIOdMf8QXp4pegWxBK+3rNLLiLkzPQGYLINbXEBRTUV0DvQFbP8NIM++bWOteHI8TlY46lzU8sb5eP3pKbG1Ni5E3A/o5XXFZ1pgD1W0h3ZyU0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SvdAsliU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a90510a6d1so41133025ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 08:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772556977; x=1773161777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eEsXhRGfZVnXfS8LLMQGFDrO1HKI5tLULsw5o2HLG48=;
        b=SvdAsliUnCRwnMJ5nmYf4Fs9Y1c835C/snfHub6YJMC/+LnJYglC6ofPhkvaB/vlqG
         dlYTotqGZLuHzr5mRnTdPmpCZ+FLYcvW1+A0CpVgS0VydEEfWgqtpzR2Z5KrJoB4EJHu
         k9ucnte4fHAC2BM2lT20sUXIOzrUvxCwdJkPUECoUqY1Dt/NBjDWHibXFiNXaZV0LYyV
         6YO+85LQEW6QOj6vkpbV7Yq7B8l8NxIBz3k7mLqsB06odBonSROoSEzUuzlJDEpQnwUD
         jdMG0W2RSLXw0NHJJCo1JD37DFk1j4vtdEhL0eL+c6b5XQrRp2v1RXGCR6SxRaM39CYq
         hQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772556977; x=1773161777;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eEsXhRGfZVnXfS8LLMQGFDrO1HKI5tLULsw5o2HLG48=;
        b=AQN9D9kHpmBtyyIF116FBO+uHa7dVnWohOpH3z941R9xIpWCRDWUSuZ4V9vFNWiFnP
         qL+mpQCgLfn9yOjWRDFrNyWQYHEc/Ci9CC6l6+uLep0S5gQQ9EIIBqa1xPMz7C9vENwv
         TGVIUiYncb6HrP3o4H2rwh9O9SCf9uvGOcGttidoybYy9lYLwa7nu6KL1pnf/NNK595L
         CyTys7eYcT+d6MUZ9juhNgwgK1jwfkXztQBMSCUy//6apOqNidjcAZnzirNgiQQIhnn/
         XG9qMRGUZ5m9vjlabmRJqkWzdG0wjjCfTDPKv2sKDtzVWZQmr5XOzUaNNptauMH3fLDf
         S/+A==
X-Forwarded-Encrypted: i=1; AJvYcCUiX7Dpx2NOilIs54Hb5ioL8DjQ/Tb+iqi6vg1CpAF2bjQOZiL+oBg1QA0SkjYk+g0zfFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQHjvM8N0kDsKVO6YBB16fw6dpUXbTIxTqBb8gYXOeFyp6GBp/
	S4BmhOPtnyZm9y53YxjFJdxvPOMybsDS6nXjWIPgjnIvAGWI4xiGiEy/Qb73c/qrKC2/cakJbHl
	cgzALPA==
X-Received: from plsl16.prod.google.com ([2002:a17:903:2450:b0:2ae:4482:4ee0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2446:b0:2a7:5f26:aaf9
 with SMTP id d9443c01a7336-2ae60d54212mr25676705ad.14.1772556977076; Tue, 03
 Mar 2026 08:56:17 -0800 (PST)
Date: Tue, 3 Mar 2026 08:56:15 -0800
In-Reply-To: <20260303003421.2185681-16-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-16-yosry@kernel.org>
Message-ID: <aacSr2LanhJczBs-@google.com>
Subject: Re: [PATCH v7 15/26] KVM: nSVM: Add missing consistency check for
 nCR3 validity
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D17EF1F440D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72548-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,g_pat.pa:url]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026, Yosry Ahmed wrote:
> >From the APM Volume #2, 15.25.4 (24593=E2=80=94Rev. 3.42=E2=80=94March 2=
024):
>=20
> 	When VMRUN is executed with nested paging enabled
> 	(NP_ENABLE =3D 1), the following conditions are considered illegal
> 	state combinations, in addition to those mentioned in
> 	=E2=80=9CCanonicalization and Consistency Checks=E2=80=9D:
> 	=E2=80=A2 Any MBZ bit of nCR3 is set.
> 	=E2=80=A2 Any G_PAT.PA field has an unsupported type encoding or any
> 	reserved field in G_PAT has a nonzero value.
>=20
> Add the consistency check for nCR3 being a legal GPA with no MBZ bits
> set. The G_PAT.PA check was proposed separately [*].
>=20
> [*]https://lore.kernel.org/kvm/20260205214326.1029278-3-jmattson@google.c=
om/
>=20
> Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on V=
MRUN")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---
>  arch/x86/kvm/svm/nested.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 613d5e2e7c3d1..3aaa4f0bb31ab 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -348,6 +348,11 @@ static bool nested_vmcb_check_controls(struct kvm_vc=
pu *vcpu,
>  	if (CC(control->asid =3D=3D 0))
>  		return false;
> =20
> +	if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
> +		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
> +			return false;

Put the full if-statement in CC(), that way the tracepoint will capture the=
 entire
clause, i.e. will help the reader understand than nested_cr3 was checked
specifically because NPT was enabled.

	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
	       !kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
		return false;

