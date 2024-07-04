Return-Path: <kvm+bounces-20954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E519275BA
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 14:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E659B2174E
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 12:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329631AE0B5;
	Thu,  4 Jul 2024 12:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cSXBitAk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F213D17995;
	Thu,  4 Jul 2024 12:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720095014; cv=none; b=Rdx82D0KZ7TT0O1Bp7y4XETWUtF7REYU3g+mwT5yr1ysVpKb9XMcUriHw5TvE+JSRs9kaAqX6cVpfiGNxW0XGSL/YSXUIEy5v125Pk3yVse3osO485e82i7bfBnLu+uL2n2GWPCUYvuUx5KbfvOUGjpsgNYrHOUTh0pz7mEqsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720095014; c=relaxed/simple;
	bh=QO7Jb1iEQ+V6p6XmkF0p47Xfs1xtuglwyapZXD8gCe4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=aKknIKOWZAZgh4AqmstcSEqKmaCpAPFmBKvqO3Iwn6igQ5D7GEosSyZQi45rOJ22mHPXpVHXUz74hyk1WYugEfJ8MQpLOaz2MV5NgF5Nj4mlC9aO49lOwk+YSWTvzuMHEFfemzmY0WgfUSuFNoIYanYnEpEKNsUPK091Pe+85Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cSXBitAk; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-726d9b3bcf8so446969a12.0;
        Thu, 04 Jul 2024 05:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720095012; x=1720699812; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS8912iTY0xW9afn3Y1NFj6von6GR2I+TxZx9FsjCOo=;
        b=cSXBitAkxTs6QXyp9Tna8aIAiuOhSUn1iTycqhBl7X+K1ZEHx518rZ7xnjmKc07GPn
         IjtHI9AZKmm7wCtOBL7CbLsO3tuoRxIp5lTo10q3gMTvHAAYCUxPy8NbTYt3x1uw1G+o
         IamKfqEFRcHxPdZvyIdfAw8yLCExY1YtXhp2WLJ2YUh196/yy7SMDwa5ggWs3IXCgCeS
         PEpJsHPzLykiNmif5p0zHnmrawdMiSzL2NI+u8wxvT7KdmXs9Tdh3c7VLbLnt9bu5szv
         p/Yxp5J/nIOjim6shWbFrWoSNlI8oKHsRXIiv4X0v/HR0WXjyUZD0lN1ia0Usw6RLXm1
         YIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720095012; x=1720699812;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KS8912iTY0xW9afn3Y1NFj6von6GR2I+TxZx9FsjCOo=;
        b=CQgOTIVtiLyeXfEHMGPmXDu2RvrLFSP1F6v5b9SGSuwHI2LRVwi024pyk9JelXAixe
         bVbyuzkMKya94+AVahoTfld2wCMD56p7bqUbgEq6T8i9iR36+ZdrncNZb0yArpPrXV+F
         Y/UKBOH3N3aYXC43Z/9Tascz+H/GRHrrGYnph3+ryt4O3EEBVJsYRJ5hQizie4rFVShD
         M9qgFRVg0TlvdTILE907NxTsMGadF0YsADaxQzqeaLdLNGgnRgUGjDp1HQPVM76CJcZe
         PA6yiCs+8GnpXa5Me49AhRb84/uShwuUE/dLjHTwzypVg/jlVLSa92hCOzIIbe/szsZs
         D0pw==
X-Forwarded-Encrypted: i=1; AJvYcCXp8d5VSEfRjVvZOjGv3ClTgQyhUI2aX3zvsFpq1naXU5xKHk8efoaTzOAMCj6jqM8/4BWooClug6Zl0fbY+lGr/kitqG2zzt7nnA/OLHRMljPfSEAgntrSMQGrMeE4lrOk
X-Gm-Message-State: AOJu0YwZT9XlzXn0QSixOpMdxHSyTGlRsBkLIlU7nCPHZBkgVNJ+f5Q3
	QuYWckaZFyCtJSuo8LZmZCxSwru/zaAV0antwQYimepiDvGo8QME
X-Google-Smtp-Source: AGHT+IGcWrJqtZ43V+s8BIoH/VOJWFVfMjaAJrAMjYxsFFcshcsaLm5j7uSV+h6i+eHEuIvhwXgutA==
X-Received: by 2002:a05:6a20:6a11:b0:1be:cbe9:f765 with SMTP id adf61e73a8af0-1c0cc73ea5dmr1319914637.18.1720095012149;
        Thu, 04 Jul 2024 05:10:12 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c999e13eedsm758458a91.1.2024.07.04.05.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jul 2024 05:10:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jul 2024 22:10:05 +1000
Message-Id: <D2GQSGNWNGX4.2R8TH3M64POGJ@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] arch/powerpc/kvm: Fix doorbells for nested KVM
 guests on PowerNV
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <naveen.n.rao@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240627180342.110238-1-gautam@linux.ibm.com>
 <20240627180342.110238-3-gautam@linux.ibm.com>
In-Reply-To: <20240627180342.110238-3-gautam@linux.ibm.com>

On Fri Jun 28, 2024 at 4:03 AM AEST, Gautam Menghani wrote:
> commit 6398326b9ba1("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
> introduced an optimization to use only vcpu->doorbell_request for SMT
> emulation for Power9 and above guests, but the code for nested guests=20
> still relies on the old way of handling doorbells, due to which an L2
> guest cannot be booted with XICS with SMT>1. The command to repro
> this issue is:
>
> qemu-system-ppc64 \
> 	-drive file=3Drhel.qcow2,format=3Dqcow2 \
> 	-m 20G \
> 	-smp 8,cores=3D1,threads=3D8 \
> 	-cpu  host \
> 	-nographic \
> 	-machine pseries,ic-mode=3Dxics -accel kvm
>
> Fix the plumbing to utilize vcpu->doorbell_request instead of vcore->dpde=
s=20
> on P9 and above.
>
> Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c        |  9 ++++++++-
>  arch/powerpc/kvm/book3s_hv_nested.c | 20 ++++++++++++++++----
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index cea28ac05923..0586fa636707 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4178,6 +4178,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vc=
pu *vcpu, u64 time_limit, uns
>  	}
>  	hvregs.hdec_expiry =3D time_limit;
> =20
> +	// clear doorbell bit as hvregs already has the info
> +	vcpu->arch.doorbell_request =3D 0;
> +
>  	/*
>  	 * When setting DEC, we must always deal with irq_work_raise
>  	 * via NMI vs setting DEC. The problem occurs right as we
> @@ -4694,6 +4697,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
>  	struct kvm_nested_guest *nested =3D vcpu->arch.nested;
>  	unsigned long flags;
>  	u64 tb;
> +	bool doorbell_pending;
> =20
>  	trace_kvmppc_run_vcpu_enter(vcpu);
> =20
> @@ -4752,6 +4756,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
>  	 */
>  	smp_mb();
> =20
> +	doorbell_pending =3D !cpu_has_feature(CPU_FTR_ARCH_300) &&
> +				vcpu->arch.doorbell_request;

Hmm... is the feature test flipped here?

> +
>  	if (!nested) {
>  		kvmppc_core_prepare_to_enter(vcpu);
>  		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
> @@ -4769,7 +4776,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
>  				lpcr |=3D LPCR_MER;
>  		}
>  	} else if (vcpu->arch.pending_exceptions ||
> -		   vcpu->arch.doorbell_request ||
> +		   doorbell_pending ||
>  		   xive_interrupt_pending(vcpu)) {
>  		vcpu->arch.ret =3D RESUME_HOST;
>  		goto out;
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 05f5220960c6..b34eefa6b268 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -32,7 +32,10 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct =
hv_guest_state *hr)
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
>  	hr->pcr =3D vc->pcr | PCR_MASK;
> -	hr->dpdes =3D vc->dpdes;
> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> +		hr->dpdes =3D vcpu->arch.doorbell_request;
> +	else
> +		hr->dpdes =3D vc->dpdes;
>  	hr->hfscr =3D vcpu->arch.hfscr;
>  	hr->tb_offset =3D vc->tb_offset;
>  	hr->dawr0 =3D vcpu->arch.dawr0;

Great find.

Nested is all POWER9 and later only, so I think you can just
change to using doorbell_request always.

And probably don't have to do anything for book3s_hv.c unless
I'm mistaken about the feature test.

Thanks,
Nick

> @@ -105,7 +108,10 @@ static void save_hv_return_state(struct kvm_vcpu *vc=
pu,
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
> -	hr->dpdes =3D vc->dpdes;
> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> +		hr->dpdes =3D vcpu->arch.doorbell_request;
> +	else
> +		hr->dpdes =3D vc->dpdes;
>  	hr->purr =3D vcpu->arch.purr;
>  	hr->spurr =3D vcpu->arch.spurr;
>  	hr->ic =3D vcpu->arch.ic;
> @@ -143,7 +149,10 @@ static void restore_hv_regs(struct kvm_vcpu *vcpu, c=
onst struct hv_guest_state *
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
>  	vc->pcr =3D hr->pcr | PCR_MASK;
> -	vc->dpdes =3D hr->dpdes;
> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> +		vcpu->arch.doorbell_request =3D hr->dpdes;
> +	else
> +		vc->dpdes =3D hr->dpdes;
>  	vcpu->arch.hfscr =3D hr->hfscr;
>  	vcpu->arch.dawr0 =3D hr->dawr0;
>  	vcpu->arch.dawrx0 =3D hr->dawrx0;
> @@ -170,7 +179,10 @@ void kvmhv_restore_hv_return_state(struct kvm_vcpu *=
vcpu,
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
> -	vc->dpdes =3D hr->dpdes;
> +	if (cpu_has_feature(CPU_FTR_ARCH_300) && !vcpu->arch.doorbell_request)
> +		vcpu->arch.doorbell_request =3D hr->dpdes;
> +	else
> +		vc->dpdes =3D hr->dpdes;
>  	vcpu->arch.hfscr =3D hr->hfscr;
>  	vcpu->arch.purr =3D hr->purr;
>  	vcpu->arch.spurr =3D hr->spurr;


