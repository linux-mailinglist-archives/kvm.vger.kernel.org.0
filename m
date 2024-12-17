Return-Path: <kvm+bounces-33896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 200469F3F95
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56855163D09
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A053E49D;
	Tue, 17 Dec 2024 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2OD3+Ryx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C535D27E
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 00:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734396969; cv=none; b=phtVjFAbi4jXW4fBMpxcbR5ouSyYwqCBFgxarjHMo1cwlVhZE6+8d1/SLS9fxTu0rjfWyUU+o+i7Du77umCE3wp5WsaglwKCHXO1BDjhZNepyyogIZ7tXohS+6Q2YbTPfifOkJ9ImAHgdLJu8JGwWUjrrg3pCQhucHFGhlzUuLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734396969; c=relaxed/simple;
	bh=uf4E4ZJTgQPF6jOGDxzd65RkUmi2Y1Z7sZ1ArTxgFO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RRB0R5NpPtSPQQEuBxU1T1NEeBtGPi6ss9Ggc9rm25zV18lebcIidiIvIeTrAlETA5Vt0X3GRAWfFv3J2i32tomQajnTrmNYGpWyQLmivl3h69AaQkqBUi+s8w2cEv2a+vr7aHtV8Fsz4otl0tKO9IoSwTqPdwZdy94brtNLVmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2OD3+Ryx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so4328694a91.3
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 16:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734396963; x=1735001763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnzdvO4O+aRVWsv7vtyrTZtE2PXoqXcmtZNp/Ta2/To=;
        b=2OD3+RyxxnwVTzwiJ/bGElECOXeQiABfyBBjQEtWccpWE6ynUDLs2kq06yxXb1wki/
         nPzo5vpGr7gYFRxp/tBnj/NoRPmMLUdEZvrHW6XuBQ3Bwdb2ioXns03Bwk4+z9CQndHj
         GN7plgJO4qSC16Bu+63Ul8WJccoZmXSoh3whN8jSQY2Jy36x4RdacD+twUYYJ91PwTol
         4hzKDUJkgtX2KBZOAT+a5S4MkWoO7kQQeblL7/8P8j186wMxUD6yvFTUv4VRAvcw/9af
         mS7hQ6ttrEtiNsngPltU23jsVkoatI3STYoAbWXDSllORoOfEkMZqbVEmOzwP91P4oqZ
         hkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734396963; x=1735001763;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MnzdvO4O+aRVWsv7vtyrTZtE2PXoqXcmtZNp/Ta2/To=;
        b=LOyV0RyS7BvAblCf6pAExjpm0zTISOCl2yjUeJaJns5z7Om1agHsQoGRYpqcidyIkC
         jT4LxoXKOibmDoNL/4fXpQdOIGlm9hBhn6r3e48LSBFL+yi+dDzXSKdAVBapAzilja5j
         uY2R2/t6UuPfVGJ0iQnLB9c3axA15JvdCNyCZQcBR3wOfXpkvLqcr+4ipth9F+lw37r4
         wjGF5fkc6H1TVxok1tj4N+Nj6paBmKDoo/5Es4ajGNflugy3wbuq3C/QSv51m8PMTiJG
         rYapGZxNPnuHkJgcfahUKujv30M/VHVD999wA6sVl5F9pismc+vhrY6PKtoFPTszg7nY
         IZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuBV9reE7kyIIBaznJNcc4g8fKLCJLlVUtwi/mp6Gze59oczZErbtMj2eJyOy2mlIMgo4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOCtj3jDqPW16j/y3jt7LoE10EWgYenOIEeXt5jULUE/QGtMcD
	kM4qqx2MoTXbjntFes3i2dI+Q8HRCpr2nWt6bY1nwAmGqgZg/mg2lhGA8vU+uPNhMKmLLeC2a6L
	ViQ==
X-Google-Smtp-Source: AGHT+IF1QXijwOQWD0T5NlzCUm0zVt9mghGeJcTe6qz+ZScLi9GJ8O/Ko3Tg/egVccM/wve9R64rv6p3J8U=
X-Received: from pjk8.prod.google.com ([2002:a17:90b:5588:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3502:b0:2ef:1134:e350
 with SMTP id 98e67ed59e1d1-2f2901b8178mr22389838a91.35.1734396962824; Mon, 16
 Dec 2024 16:56:02 -0800 (PST)
Date: Mon, 16 Dec 2024 16:56:01 -0800
In-Reply-To: <20241206221257.7167-3-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241206221257.7167-1-huibo.wang@amd.com> <20241206221257.7167-3-huibo.wang@amd.com>
Message-ID: <Z2DMIWqSP3h0cV-F@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Provide helpers to set the error code
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Dhaval Giani <dhaval.giani@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 06, 2024, Melody Wang wrote:
> @@ -3577,8 +3576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *s=
vm, bool sync, u64 len)
>  	return 0;
> =20
>  e_scratch:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT)=
;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA=
);
> +	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
> =20
>  	return 1;
>  }
> @@ -3671,7 +3669,11 @@ static void snp_complete_psc(struct vcpu_svm *svm,=
 u64 psc_ret)
>  	svm->sev_es.psc_inflight =3D 0;
>  	svm->sev_es.psc_idx =3D 0;
>  	svm->sev_es.psc_2m =3D false;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> +	/*
> +	 * psc_ret contains 0 if all entries have been processed successfully

No, it doesn't.

  =E2=80=A2 SW_EXITINFO2 =3D=3D 0x00000000
    The page state change request was interrupted, retry the request.

> +	 * or a reason code identifying why the request has not completed.

Honestly, even if it were correct, this comment does far more harm than goo=
d.
The literal '0' below has nothing to do with the '0' referenced in the comm=
ent,
and so all the comment does is add more confusion.  Furthermore, this is th=
e
wrong place to document SW_EXITINFO2 return codes.  That's the responsibili=
ty of
the call sites and/or individual PSC-specific macros.

This code should instead document the weirdness with PSC's SW_EXITINFO1:

	/*
	 * Because the GHCB says so, PSC requests always get a "no action"
	 * response, with a PSC-specific return code in SW_EXITINFO2.
	 *
	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, psc_ret);

The readers of _this_ code don't care about the individual return codes, th=
ey
care about knowing the semantics of the return itself.

Alternatively, it might even make sense to add a svm_vmgexit_no_action() he=
lper
(along with svm_vmgexit_success()).  There are at least two VMGEXIT types t=
hat
roll their own error codes with NO_ACTION, and it might be better to have t=
he
initial zeroing in sev_handle_vmgexit() use NO_ACTION, e.g.

	/*
	 * Assume no action is required as the vast majority of VMGEXITs don't
	 * require the guest to take action upon success, and initializing the
	 * GHCB for the happy case avoids the need to do so for exits that are
	 * handled via SVM's common exit handlers.
	 */
	svm_vmgexit_no_action(svm, 0);

> +	 */
> +	svm_vmgexit_set_return_code(svm, 0, psc_ret);
>  }
> =20
>  static void __snp_complete_one_psc(struct vcpu_svm *svm)
> @@ -4067,8 +4069,12 @@ static int snp_handle_guest_req(struct vcpu_svm *s=
vm, gpa_t req_gpa, gpa_t resp_
>  		ret =3D -EIO;
>  		goto out_unlock;
>  	}
> -
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
> +	/*
> +	 * SNP_GUEST_ERR(0, fw_err): Upper 32-bits (63:32) will contain the
> +	 * return code from the hypervisor. Lower 32-bits (31:0) will contain
> +	 * the return code from the firmware call (0 =3D success)

Same thing here.  A comment documenting SNP_GUEST_ERR() belongs above the
definition of SNP_GUEST_ERR.  How the "guest error code" is constructed isn=
't
relevant/unique to this code, what's relevant is that *KVM* isn't requestin=
g an
action.

	/*
	 * No action is requested from KVM, even if the request failed due to a
	 * firmware error.
	 */
	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION,
				    SNP_GUEST_ERR(0, fw_err));


> +	 */
> +	svm_vmgexit_set_return_code(svm, 0, SNP_GUEST_ERR(0, fw_err));
> =20
>  	ret =3D 1; /* resume guest */
> =20

...

> +static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
> +						u64 response, u64 data)
> +{
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
> +}
> +
> +static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8=
 vector)
> +{
> +	u64 data =3D SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;
> +
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
> +}
> +
> +static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suber=
ror)
> +{
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror=
);
> +}
> +
> +static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)

As mentioned in patch 1, please keep svm_vmgexit_success() even if
GHCB_HV_RESP_SUCCESS is renamed to GHCB_HV_RESP_NO_ACTION.

> +{
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_SUCCESS, data);
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
> =20
> --=20
> 2.34.1
>=20

