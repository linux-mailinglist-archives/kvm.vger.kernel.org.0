Return-Path: <kvm+bounces-10574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC05886DAB3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 05:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC951F22E1B
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 04:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68904EB3A;
	Fri,  1 Mar 2024 04:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="wOWByyLG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E0A47F6F
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 04:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267581; cv=none; b=IUkfN5aGl4mKVqsVuyKBNqm6gBAZM1HB7l24e9ZxiGMFheCwxVtVi9Spdvdtr4O0GX3DYklHml1TPdU7LIFUQU4Qt3dHOau3PW5AA7tvbIlp6BUZtmlilkB2AGj2gsa5zJqePMr9V5J/4tjo4x8eiiozXgmnXVbzQF098jSe330=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267581; c=relaxed/simple;
	bh=G5VoEehdp+6XyvxEfiXl+wpRMI+/AditsiP9Kpp58Uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wrqx6DjhQauo1f5fiWWY1ahRZKJNeTCnwNvmE179a+QZWx+4/sgvHRq94hF2xFxUqCEqxkwMj1J8Jpgwyl4bI0YI5Oo4lgmsqC6IoF2nQDi5QPPLkQiEreUnDxyTLzw81zwmHMRTDw0v/JULsfEGwSH2LJljYwqUgKa21pK+ssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=wOWByyLG; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-365c80d1114so5739715ab.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 20:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709267579; x=1709872379; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2BWN8nE55vFXdBWwqvUH5khNC7Gp97wwldmFe5jaCE=;
        b=wOWByyLGMKSMrpUCarpXnfDBhDoIbvmOv1yfOwktBOF/71JQJmvs1ptLzrlpBVf2FT
         5C7nVCxUdzoBNvsgM5quk93ZOwmnIgBqNsur35ka/ckTuNN5+AEBxawkHdZVwd+7k1KH
         Y4GcMSVn6DFGoD/5AQPsb0LyMHeG9ehFqRvO9R5oYYWxUuPs3KUckLlgFhqzhWmc29dS
         RMkr6FOrU56RRCqmaVyBgR+nxTGSmCA2eb9Rk826BlmgFhuOXz5NqaHkp5uF6/atUdqC
         vNnRn8ZEnvrYUJoq522SIjgMKJc51y+PMAiyNJ682A8Xe9DeJKEbf+vLENPg5QiT+T/t
         MinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709267579; x=1709872379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+2BWN8nE55vFXdBWwqvUH5khNC7Gp97wwldmFe5jaCE=;
        b=h2uTa+8sYw/xccszcn9kUZr4ajuudEcU5wZfcQl/J2uaWukMQ7RpIlJB5l2lwY4fwT
         IGWgLjFNpmYWDyFotxrhV+T0/59e/smiQVyVFscs1oGlye/dElX6R2rY9F0WHIPB3sLW
         XTH1vWqjIMH4lcLczxNKiw6vayJNZcPYSQfiWW5imo/rHtvAdWYJkVmZpzKQHuAE/x1f
         /TbGkckqH/VdidsVUUfRakx7ygKwjnNsZzY1lKoA3qGh/VIVuSubhQRHcxGxgWjN+dwF
         bRAeZ4vYmTPKCgavUgogiIAJaI15TkU8O4G27aKRi1niaDZyYk0m/XcBe/ngjpI7zeH8
         NKLA==
X-Gm-Message-State: AOJu0Yw/7uCITZHUj5TZmBGRH9tJnxmMnQNJook6RNYcCbzxvsTFOZB1
	6FwEDqzF8neMTeUDZ5jTGxChKwz8OPZiw5gYpsrGljP8L61ASG6gTGcIn2WyzIZy8rFLhyZHWQ6
	H8QPBw+w54lwnWUjKxCjFUa3vWR0K8ZtL9BcDXQ==
X-Google-Smtp-Source: AGHT+IFHRrPHNZTDr+MTukh7kG+l4iPOS5byuwxluAEoa95mA6vVmyvboGA0usm2OrkbSt1D9y53hrWHvfO0S1N5uMY=
X-Received: by 2002:a05:6e02:1ca5:b0:365:b8f9:6a36 with SMTP id
 x5-20020a056e021ca500b00365b8f96a36mr779433ill.32.1709267578846; Thu, 29 Feb
 2024 20:32:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com> <20240301013545.10403-3-duchao@eswincomputing.com>
In-Reply-To: <20240301013545.10403-3-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 10:02:48 +0530
Message-ID: <CAAhSdy1U5z=-bNdWdnCaQzSiF_w5OfYtfsyau0Km3D5gGVPSmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] RISC-V: KVM: Handle breakpoint exits for VCPU
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> Exit to userspace for breakpoint traps. Set the exit_reason as
> KVM_EXIT_DEBUG before exit.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 2415722c01b8..5761f95abb60 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -204,6 +204,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu, run);
>                 break;
> +       case EXC_BREAKPOINT:
> +               run->exit_reason =3D KVM_EXIT_DEBUG;
> +               ret =3D 0;
> +               break;
>         default:
>                 break;
>         }
> --
> 2.17.1
>

