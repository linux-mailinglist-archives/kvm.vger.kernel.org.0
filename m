Return-Path: <kvm+bounces-4317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D32181110D
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93360B20EF2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D7C28E26;
	Wed, 13 Dec 2023 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="w/BMiEeC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5F121
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:22:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2868605fa4aso4815455a91.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702470151; x=1703074951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBQ6DjtF6aJnNMhcozBBdPGYIOHs9FwMHWOJVKrpI6o=;
        b=w/BMiEeCreufGp9DxOB5F/vycZMrwKQPvxuQP3y6ZDkU+is2eQFirnxx3gmaSvqa//
         w70J8Ni++pjhLZtDDJK4gKf3bBP3xvq/h5FNiAXcrSkJuMF0+Ug2bd2ThfaWBuntmRB0
         agegOFjAUYpsRXVM4P+tjDGdSg1WrNTvL8M2wwiKiEWDs5QRMVTQuVVVabSAS9G45o2f
         bCtewUQEnAO2dXT77hZowhgjJ0STkdGooJUq0k2ZRgVCaPubigV3flFJltxTaHYAQgpG
         uQdr8FBFdLa+u7td2J8EaoGLneTr4116QlZMelOXWOjcKXEYnurC5r0sDkcyNr/j4ZoY
         4rLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470151; x=1703074951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBQ6DjtF6aJnNMhcozBBdPGYIOHs9FwMHWOJVKrpI6o=;
        b=G8ag/QYJ7PwHwbzKqveN0c8LtP1E472S4QYcr9u7Qaxpq3dzK6DWOIOpHF76qUCGx0
         Kfk30EtveLy8Kg+kz6oZ3WlmUMxJzcShhCZzuA3kmstjGrea5Zt5LpfsVVXglRXCQKDp
         WT+/Fhpr/Vmu3r5T/aZ3/VWrtfYLwrzl0O7lQjM6HNMlkMyesTt4lR6m1dMPFgkbFvXg
         /x1vhFrZMbHRPEEWAy4mjmzKEb/Qs9i7O2/ZmVaF2dnpfIG3OUrm6Hwx6Rf7Q6y8FM6o
         QTu1y/21E70Mvr7Uiya6y5oyzZrfXUVd++NA84y+w6G6eDt0Crih2Slv5i7m1xvNZmAR
         JjPg==
X-Gm-Message-State: AOJu0Yyfiv6OtvIA8AUzaYRtJzatEUux37pRUDzUYEJ3O0U4tcOgeqki
	UTxGh09iv7MbA5IQ0VdtIQAKlhVuyWjOewnIb8FV0A==
X-Google-Smtp-Source: AGHT+IFwLyMcfcKUGk6CTyJcWrM3SNpKvu7ioIaVsdymTbcvQD5mWw2+3MIOJj1SW4L/sTVFgdVYxfIcHk0rxce6gx4=
X-Received: by 2002:a17:90a:7d05:b0:286:c0ca:48e with SMTP id
 g5-20020a17090a7d0500b00286c0ca048emr3154153pjl.15.1702470151247; Wed, 13 Dec
 2023 04:22:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231211094014.4041-1-duchao@eswincomputing.com>
In-Reply-To: <20231211094014.4041-1-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 13 Dec 2023 17:52:19 +0530
Message-ID: <CAAhSdy0t01YVX3iBq+w1eiEo+NAPotFR3TD2m_558CgS0=AQzw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: remove a redundant condition in kvm_arch_vcpu_ioctl_run()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	dbarboza@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023 at 3:11=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> The latest ret value is updated by kvm_riscv_vcpu_aia_update(),
> the loop will continue if the ret is less than or equal to zero.
> So the later condition will never hit. Thus remove it.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

Queued this patch for Linux-6.8

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e087c809073c..bf3952d1a621 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -757,8 +757,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 /* Update HVIP CSR for current CPU */
>                 kvm_riscv_update_hvip(vcpu);
>
> -               if (ret <=3D 0 ||
> -                   kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vm=
id) ||
> +               if (kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vm=
id) ||
>                     kvm_request_pending(vcpu) ||
>                     xfer_to_guest_mode_work_pending()) {
>                         vcpu->mode =3D OUTSIDE_GUEST_MODE;
> --
> 2.17.1
>

