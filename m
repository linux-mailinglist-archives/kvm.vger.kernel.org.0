Return-Path: <kvm+bounces-32861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A70EC9E0F81
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B2CD282FF1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 00:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8E8A59;
	Tue,  3 Dec 2024 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CRSqb8Fz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA0173
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 00:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733184689; cv=none; b=hw9+436YCGCUftpnZmIQmxxTMlTHvVT8pyWGp4TAfyib3tMxPrc/FwYO10sHYaJsRZcmRJtUKIho7+5V26eJmeUmBjDI49Eun+POMDKyep53pzPkgps6TGnkP+/lnrevf+TKnr9VG0YEVHfC8jsD81Uu8ugKN4ITIA/zg5ET0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733184689; c=relaxed/simple;
	bh=sXKboPJVhvZm9MRFI/36V/Dw28GUy47CEwhIWBjLPbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLKvoAtpbA+6mZTwFvughmUiQZzagM/9DMuasMZODbUtf7IlP9tpcSFtCaTV509rkMnO2oPM5+ybDk71CZfb5+1wveQ8glsu2ZkfF3DR1fxv1fKqajfWPOIHoY4hRc9UYhAVil6lvpWVoHiUq1lhGn525nWKO7bBTQbXb2RjFmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CRSqb8Fz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee3c572485so5674955a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 16:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733184686; x=1733789486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HyRCW53Khz052+aBjVdJTpIV/tic2eaOScb3I7IW9MA=;
        b=CRSqb8FzrmuAWOdscMP3vIQJMM4Rj7LdFaopny6c7dxfliIUhoUbLZE9UcgF9uOcvn
         Z7RiReBQgMrQIZ8HrXRWt4joLEAtFjeJ+YA+XXHQPb7oRg98ftrNHJVsNUixqBRlmqhb
         mExBYQg3VKIanfuuankQ2nPKclXuaLWrOc8tlVSVzePKazABlw8VgTIkE3JNpeNifN0+
         nQLDrQIpkedwMiEpRNxqCtqVzwHLBtY3UQfZaGzV2Q0P11hfAaLW1hazBkueCCEn4QjA
         Z34l05U0ztwUqkPgC2rHA3RiNAV5U/FIFegWyyUP56f8Ug0NzOInH1AOo5s6TBA3Ps+g
         dyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733184686; x=1733789486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HyRCW53Khz052+aBjVdJTpIV/tic2eaOScb3I7IW9MA=;
        b=J4YBqe3vdygaMBorTNE87DRu8RfmwYG+8RZIgnmGg/cjuoev09ebKbW1Ol5aqYBr52
         C+tUGrb/5DVvY1pbHrFKdYTEFKp00X17pu+Oi1YHCCtxBu29xlLGqTTAiqD0kpG6Oa0S
         dZaOtUMApLYgG4wm2TEoqE+1XZqv1VTVnqV4E0fabpNim35/2YPNZhP7TgfAzuTgAQoO
         9zzCaUgaLcrfPJriuJCtzRXUayfVSXocSxgCb3SnFBKSrkLJkaygZWjymJZ8DkGSr3KQ
         OyklzbzReGHtTLaa/8VHlRl7DLyiu611vymzPgCk6FA2slrbgVEjQOwQkJ8WbFggU1Cb
         N+TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAPe8ivxEEcKNIp4AwCeL60UHcIe0S6zA2eLNkjz7d963SnntlzDyOsAiYvDmQgtlIGCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZReAm6y9fqgKaAKqCFh2O0UWlXkHqWF9rsxnF3golw5V0Z8AL
	VC6K1SHq6igfYIrAx0SfMASiaPUcGjxLgcAy4MFYqhN4MRPe/kFK0jGwdVb9XvCERoPPuEyOX+8
	QZQ==
X-Google-Smtp-Source: AGHT+IE0tU8DEKdjyyKwq8TT/+CTYk5YYD3SCO3wVYP2c5+AmdEw/3xZ/gG660l3MPLAuKDqsSbFdwWOb9Q=
X-Received: from pjbsz16.prod.google.com ([2002:a17:90b:2d50:b0:2e2:44f2:9175])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380c:b0:2ee:ab29:1482
 with SMTP id 98e67ed59e1d1-2ef011ff673mr894137a91.16.1733184686643; Mon, 02
 Dec 2024 16:11:26 -0800 (PST)
Date: Mon, 2 Dec 2024 16:11:25 -0800
In-Reply-To: <20241202214032.350109-1-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202214032.350109-1-huibo.wang@amd.com>
Message-ID: <Z05MrWbtZQXOY2qk@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Convert plain error code numbers to defines
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, KVM <kvm@vger.kernel.org>, 
	Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 02, 2024, Melody Wang wrote:
> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
> 
> No functionality changed.
> 
> Signed-off-by: Melody Wang <huibo.wang@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>  arch/x86/kvm/svm/svm.c            |  2 +-
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 98726c2b04f8..01d4744e880a 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -209,6 +209,14 @@ struct snp_psc_desc {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/*
> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
> + * communicated back to the guest
> + */
> +#define GHCB_HV_RESP_SUCCESS		0
> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> +
>  /*
>   * Error codes related to GHCB input that can be communicated back to the guest
>   * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 72674b8825c4..e7db7a5703b7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3433,7 +3433,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		dump_ghcb(svm);
>  	}
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);

Hmm, IMO, open coding literals in multiple locations is a symptom of not providing
helpers.  From a certain (slightly warped) perspective, setting exit_info_1 vs.
exit_info_2 is just weird version of an open coded literal.

Rather than provide macros (or probably in addition to), what if we provide helpers
to set the error code and the payload?  That would also ensure KVM sets both '1'
and '2' fields.  E.g. in sev_handle_vmgexit()'s SVM_VMGEXIT_AP_JUMP_TABLE path,
setting '2' but not '1' is mildly confusing at first glance, because it takes some
staring to understand that's it's NOT a failure path.  Ditto for
sev_vcpu_deliver_sipi_vector().

And IMO, not having to parse input parameters to understand success vs. failure
usually makes code easier to read.

E.g. something like this?  Definitely feel free to suggest better names.

static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
					       u64 response, u64 data)
{
	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
}

static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8 vector)
{
	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;

	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
}

static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suberror)
{
	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror);
}

static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)
{
	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_SUCCESS, data);
}

