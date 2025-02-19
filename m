Return-Path: <kvm+bounces-38518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC155A3AD30
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA6301896E3D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C9E18E1A;
	Wed, 19 Feb 2025 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="WXz6xreC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DAE2BCF5
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925730; cv=none; b=jrjXAL15CsPDgxSGKqCrMGo9R9XsLetq/y+/hoQuiO5HLoFPzZwqUaOEqoV1v0zDmuZPxLF0++iTi1sM5R5pKkK/mlS2rAHVZpSbYtu69X4DyIkYMLo9aFiJOZ1EF12GoilBllR2uQuqQjC7KCdcPKAjRR5KRNPLTYFxqJyvehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925730; c=relaxed/simple;
	bh=46CI99rCzReTEnzhru2OfD6UjCTSyujzo+w1AwZtWII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZBrgy0LUdiPUU5rSVko7YOglCNt+zyQba88/ZMrlewUsva1niR4HwmOCOsOFHcpcessmsn9hc4Uksj6DYPww33h71Fk9LcP2xIdVo15M1cuUrSjQJa8blYCpbuCR+hZN9oJ2YJyVovqFx6lDAktzJAlyEdAnSK2JyOVH+rMHMo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b=WXz6xreC; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abbda4349e9so2219266b.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1739925727; x=1740530527; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/t1OJmWL68Hazjjcv1qYhLRbsy8q5AC562jDj6trdpI=;
        b=WXz6xreCfUoHYlQJ2KX07vUhC1De4vplnipyQ2ylE+zpNbZO8JqsmTCoeTrIjMaaaC
         AvqEL10B7ywUxOHCPa/6hF5ljaVUkOtwsRzN4U/2b+OKVInFqJ/dj+J0G/ks4Uonp3cG
         pXdzejzIQJXCq9yHOdwS+f8QBhbxmDf8CVY6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739925727; x=1740530527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/t1OJmWL68Hazjjcv1qYhLRbsy8q5AC562jDj6trdpI=;
        b=bXoPncWK6mrnyTutUYXO5DlL6llg4eJ6wDcg57gZrfiTGBJ6x59a6oWIeo9Q69xTur
         c1GK+kEkUqin3jvJhVQ9CaYEL9TJD73h8bS36ej6+i8wcOzbYOEFGBLFiiqg3F8s+A8j
         0CsiP23vY1ixnWmo98igU/k5x3EWaR+rwWJ4Y3Uv2GzgIvYpH2SDvLPYp68Ib5+7xWZC
         XuatU/phtn5nNaDd85amRuB7lgJAr2wAQmjDYl45KpotTDVfti7BEH4u2U3MDI8dP2vK
         Lecn7H/Jk4x2Jxt/T6+v/oIkW3nzLDXHOclph5jIFE7HFJaY6rsVlgaNzteu+FJR9+bk
         e8Pw==
X-Gm-Message-State: AOJu0YwFmf2crXDpXtFF43sizXF0V+bB2HiCDbNnRvfMx+oqaSsvNgBx
	iYla4jMCE95idMbcKOIP0gbZc+GV+2nG8uV8TfsVdKcb7tHKerijhXy63muj9Ex6K3FftC7hwB+
	qBEbYoE6IqC776kmy72JRVoRTkIdo68NF8HU=
X-Gm-Gg: ASbGncsHcF3bjqJmGO6d2G68SyvEPwWXaBDYYs8X99kMKRmcMPNjexoQlUnVHJLNDbv
	NFZev2+4X57TPUilHlB6XgxHE5/dMdsMGMFtGTfkLidCIuYa/ndhUIoz3Cp7/Q61lYeLUz45t
X-Google-Smtp-Source: AGHT+IHcWhOiZFInFOHE85NAoQhoExm8HDazGvi6/4CxlGoKOsjohVy+Y/3iF33pNDezASa+0/4FvZ6y/fROrxSKSfc=
X-Received: by 2002:a17:907:7b83:b0:ab7:eda3:3612 with SMTP id
 a640c23a62f3a-abb70de2909mr1757948466b.50.1739925726695; Tue, 18 Feb 2025
 16:42:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218230936.408429-1-cyrilbur@tenstorrent.com>
In-Reply-To: <20250218230936.408429-1-cyrilbur@tenstorrent.com>
From: Joel Stanley <joel@jms.id.au>
Date: Tue, 18 Feb 2025 16:41:54 -0800
X-Gm-Features: AWEUYZk1B1KXInagAFDUK07o4asqDPaBFURvc3DxvmClTRZF6sxHehiUWz5QWZA
Message-ID: <CACPK8Xe88Bw63eqf-=_FYXvgJLtFtW7DRf3KHDQ6hYWqc6fWfw@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] riscv: Use the count parameter of term_putc in SBI_EXT_DBCN_CONSOLE_WRITE
To: Cyril Bur <cyrilbur@tenstorrent.com>
Cc: kvm@vger.kernel.org, apatel@ventanamicro.com, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Feb 2025 at 15:09, Cyril Bur <cyrilbur@tenstorrent.com> wrote:
>
> Currently each character of a string is term_putc()ed individually. This
> causes a round trip into opensbi for each char. Very inefficient
> especially since the interface term_putc() does accept a count.
>
> This patch passes a count to term_putc() in the
> SBI_EXT_DBCN_CONSOLE_WRITE path.
>
> Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>

Reviewed-by: Joel Stanley <joel@jms.id.au>

I added Will to cc so he can take a look and apply this for you.

> ---
>  riscv/kvm-cpu.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> index 0c171da..84d35f7 100644
> --- a/riscv/kvm-cpu.c
> +++ b/riscv/kvm-cpu.c
> @@ -172,21 +172,23 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
>                         str_start = guest_flat_to_host(vcpu->kvm, addr);
>                         addr += vcpu->kvm_run->riscv_sbi.args[0] - 1;
>                         str_end = guest_flat_to_host(vcpu->kvm, addr);
> -                       if (!str_start || !str_end) {
> +                       if (!str_start || !str_end || str_start > str_end) {
>                                 vcpu->kvm_run->riscv_sbi.ret[0] =
>                                                 SBI_ERR_INVALID_PARAM;
>                                 break;
>                         }
> +                       if (vcpu->kvm_run->riscv_sbi.function_id ==
> +                           SBI_EXT_DBCN_CONSOLE_WRITE) {
> +                               int length = (str_end - str_start) + 1;
> +
> +                               length = term_putc(str_start, length, 0);
> +                               vcpu->kvm_run->riscv_sbi.ret[1] = length;
> +                               break;
> +                       }
> +                       /* This will be SBI_EXT_DBCN_CONSOLE_READ */
>                         vcpu->kvm_run->riscv_sbi.ret[1] = 0;
> -                       while (str_start <= str_end) {
> -                               if (vcpu->kvm_run->riscv_sbi.function_id ==
> -                                   SBI_EXT_DBCN_CONSOLE_WRITE) {
> -                                       term_putc(str_start, 1, 0);
> -                               } else {
> -                                       if (!term_readable(0))
> -                                               break;
> -                                       *str_start = term_getc(vcpu->kvm, 0);
> -                               }
> +                       while (str_start <= str_end && term_readable(0)) {
> +                               *str_start = term_getc(vcpu->kvm, 0);
>                                 vcpu->kvm_run->riscv_sbi.ret[1]++;
>                                 str_start++;
>                         }
> --
> 2.34.1
>

