Return-Path: <kvm+bounces-72448-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNvBK3YlpmlrLAAAu9opvQ
	(envelope-from <kvm+bounces-72448-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:04:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7226D1E6F6E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 527B930364FC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE6AE573;
	Tue,  3 Mar 2026 00:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jalKBtbk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596924594A
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496236; cv=none; b=qNicgpsKMciBBMD4x65cZnfydU7IoER8qO5/9r50PSp0O60nUFHT5EWJxMkzP1dvn7ElE7F+btwT2gy/k1kRVEjCRJtG8I2c5dGIzbOAiyK4jBoE/gbQhMEnOST+gsku9Zt4NP7l02bP7wIhBlCZ6MdHrIiz5iOmpY7yuwCzSjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496236; c=relaxed/simple;
	bh=k07zV+K5XyJVheOh7QGEyqCgttrb3HuCVf2kH3oRwtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bff+ePCnP2AHqilfueVkQ2RPi/li8hXA3Z58NtjpuINuLCCcZEnVE/MMD98j5Y9u2HqN5MrEVDGUNPSaLUtc5ucxOdh9n7eygzc1I2uRwSJaeIPeVZAmQ4CTBiG21RwLQtu8fP8D4kv1xBrlM6SB53KgKV7YedNZ97ZnannTd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jalKBtbk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33558C4AF09
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496236;
	bh=k07zV+K5XyJVheOh7QGEyqCgttrb3HuCVf2kH3oRwtA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jalKBtbkgPV3QIJIWAHBoLyAsjI3mUxXQAODK77Rl26W7QxDFXEba80AVapqvBH7I
	 +pFgyA4aU5NVps2IClywTcD3mtyO/unOcsMVuitV63j7rid487YOzmnbQ9ccZ+ONGo
	 VYLaxB3HgmCflNojaGo/y9MvWeSWM6la408F0FvJqSNBCMhZ22DimLAiEgdCP3SKnp
	 9gcYIH2U0vEQpU2O0Dv7Tihap4+D4TPrcD8dPMXeOr8nCGgmpYBySzRTAuBcNcq7Xd
	 /4Uh9t0tX/H8UxxhMd6zlMC0arOFPG5fLj4vu1QsSW6ASjJLroNqvo87gVlUjkR0He
	 3QhV9qSRAQXaw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b936b85cc71so598344866b.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:03:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU/0vkj9NSA+RPHovcjZSMOjsesmeWu1/PSiD5PtC2mm//wTT9B7zSS2EeVbarOLff2Q58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybm84OP4jrX6XBVe7ZL8PvQ4Au468Ot1V8bMzThD/8RPH9K0BS
	0DkAK806lGOdtqWZTed8mEVycm2zM3lnkrkLK3cEmT0pkcXWTxkRHPd3yYAXBzOv0UCdu4p4H9f
	FO3secn5dP9ordPltXj0bKXwHxe9BpHE=
X-Received: by 2002:a17:907:2d9e:b0:b83:15cb:d4cf with SMTP id
 a640c23a62f3a-b93764b8715mr1130514866b.29.1772496235020; Mon, 02 Mar 2026
 16:03:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-22-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-22-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:03:43 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPdpzJtGeB25X_F3BK4Azf_scf82F8CySE1Rp917rwVhA@mail.gmail.com>
X-Gm-Features: AaiRm51GROcLAcs9CYOY6wF5v0eUVt29axRUDiNYz_dju3nQLYD0WMCKtVyejGE
Message-ID: <CAO9r8zPdpzJtGeB25X_F3BK4Azf_scf82F8CySE1Rp917rwVhA@mail.gmail.com>
Subject: Re: [PATCH v6 21/31] KVM: nSVM: Add missing consistency check for
 EFER, CR0, CR4, and CS
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7226D1E6F6E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72448-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 2:34=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> According to the APM Volume #2, 15.5, Canonicalization and Consistency
> Checks (24593=E2=80=94Rev. 3.42=E2=80=94March 2024), the following condit=
ion (among
> others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):
>
>   EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
>
> Add the missing consistency check. This is functionally a nop because
> the nested VMRUN results in SVM_EXIT_ERR in HW, which is forwarded to
> L1, but KVM makes all consistency checks before a VMRUN is actually
> attempted.
>
> Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---
>  arch/x86/kvm/svm/nested.c | 7 +++++++
>  arch/x86/kvm/svm/svm.h    | 1 +
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6fffb6ae6b88b..2c852e94a9ad9 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -397,6 +397,11 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *=
vcpu,
>                     CC(!(save->cr0 & X86_CR0_PE)) ||
>                     CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
>                         return false;
> +
> +               if (CC((save->cr4 & X86_CR4_PAE) &&

No need to check X86_CR4_PAE here, as it's checked right above the
context lines.

> +                      (save->cs.attrib & SVM_SELECTOR_L_MASK) &&
> +                      (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
> +                       return false;
>         }
>
>         /* Note, SVM doesn't have any additional restrictions on CR4. */

