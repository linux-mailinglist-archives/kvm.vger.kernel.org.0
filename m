Return-Path: <kvm+bounces-38363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B109A3807A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:44:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F69E188C840
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A70217663;
	Mon, 17 Feb 2025 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LmYVUA+T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57160216E1B
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739789058; cv=none; b=orqG8RwZh3qOJTwWj3BHhmpvPLA3aLdlzkDqU+OgV7nqizoy/Zg65jR0f8HgciXreiVPmth0/64gaqyXKuH2/Nb2ARWLj7fwmuEvBnvo+Vr7ymba1seuSf1pCKmHcxjP43OIdjJmWvw9Q+JimmWhZwqNZdO9NCFWBjvRnPjR7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739789058; c=relaxed/simple;
	bh=D0MOkPWP2WN17C0xDRNnf0+yyPZKfDZ1qJT410554nU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrJhSIYXq1TeO8rBhjJLVs0t9/tEI7GyvsgUUp09oUzMo1Ry5RwEcPqA1KNhsnWJSCqEsX0o+9RIK9KNMJKHjafKsWFhPg5FOY3S/jaNsOXGm1WP6qS9DPYPUGSDXkbWXjHw9oxctnu0KspcUeF2Vxxj/2nuHxiw7xgOYOR+jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LmYVUA+T; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cfeff44d94so13527895ab.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1739789056; x=1740393856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEC9IKTHffK3WvFzTVA0qo6PFNnuHBV9vhhQNHZZ8nE=;
        b=LmYVUA+Tj+NDjrdPhsGWPrj1g+2HJVDT/CgTmxfUZJizho8FlBR8GSgYYeVu0djQx7
         pRIwm6LPtZ6X1/mRfBjErYmPm+Xvg35pPNnYTkviQ6ByyGd/nbOoby/HzGfu5ScFWJzs
         CYVU4gpFWw1UKKC68onDKmT5JajZCLeV0Wy/957bXZ0FW4GN5i1K6e2CHxNDqzKqi9pZ
         uvojgxQ/XVhzF4EEnqrJfs/QsdUAqjTLJi4Nk7hAweIYLXHldxmEZKwi1dtJmXJRQHwZ
         NiLuMplnOBCnhilquvJdWxqeWTOAFoOhdZYrbOF4n0U5BsF+910STC0X9XTW8xOM12kZ
         aFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739789056; x=1740393856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEC9IKTHffK3WvFzTVA0qo6PFNnuHBV9vhhQNHZZ8nE=;
        b=ugvcebtJeoDVrhsePWa8vzpdKDug2OPVBS/DC5w8TVCLmH7FfonfobvTGitZMseDLW
         grY0Zdx9AOkPGdJJJzJVVgHXeH+5mQyke8rGrmZLxg8PqB/6WlnhIPUFK8n0ANnSyNYp
         F4P72rpz6WSEScvoW2MMe7TnvFF3iZhe6GeCtoaWyNl310oW2Aee3C/LVRM8quOTMQBz
         FD2U+T5GqqMtPwPoaBhhftzxljzwPCz61p4LVIdiYvGmBiAM2iKGrTWK84isKVbLOBRi
         +bZyNQaaYcUf8OOnAdqg5swWcGyuOTleRaU9qXqHnKKbog1wLHZH/FMImJ6O9SCxFgLT
         lvzg==
X-Gm-Message-State: AOJu0Yw8RakrCa60EkmuKN7fuRC4NSCatC/mU6k+jsVX3Q2wwJ7XhZvR
	3dxW29KB1HELOvBvjeAFuoFSVpX9W/5BGZuxiTzpUrWL8rTACAU3lQSvAp2yse6q8gVmD6+cZ0o
	3991F+krseD7mBeM2ZGB1HLT+BU3l04tNezJG2A==
X-Gm-Gg: ASbGnctxbx/92gsVw6m3681pVw+4OBUKIb8sWC49zVXyz2LvwOTVZLoPGWdlsf6LjgX
	iBiBe9uRAHPvXRONRvANbj9pQO9bQAoBATAU5G1ZaYEKvAjUggAN0VYjnR3URfq6PMscyYbwi2w
	==
X-Google-Smtp-Source: AGHT+IEx965Kes7J9PFe/fEC2qu7c1lQXF8r1O+rb4FsIYIqeAylTS8U1CDqrpwteAP6QAUGVznUvUBjnd38LJ5N3iE=
X-Received: by 2002:a05:6e02:2181:b0:3d1:4b97:4f2d with SMTP id
 e9e14a558f8ab-3d280763f51mr58551715ab.5.1739789056483; Mon, 17 Feb 2025
 02:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com> <20250217084506.18763-11-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-11-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Feb 2025 16:14:05 +0530
X-Gm-Features: AWEUYZkbD0BHzIgdISlWzpxxTEzeWANGopBZGPKVtWrdTFLAAwqfFFUQyuGlYn8
Message-ID: <CAAhSdy2y-hsdNLQf3YVGkC-v7ZdK1NpR6TDnJRoce+qD+7m3Wg@mail.gmail.com>
Subject: Re: [PATCH 4/5] riscv: KVM: Fix SBI TIME error generation
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> When an invalid function ID of an SBI extension is used we should
> return not-supported, not invalid-param.
>
> Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions de=
fined in v0.2")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_replace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_=
replace.c
> index 74e3a38c6a29..5fbf3f94f1e8 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -21,7 +21,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>         u64 next_cycle;
>
>         if (cp->a6 !=3D SBI_EXT_TIME_SET_TIMER) {
> -               retdata->err_val =3D SBI_ERR_INVALID_PARAM;
> +               retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>                 return 0;
>         }
>
> --
> 2.48.1
>

