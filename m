Return-Path: <kvm+bounces-52704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F10B0856C
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7A658400D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FB92192EA;
	Thu, 17 Jul 2025 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="iELNt2Bi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2BD1DE4E5
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752735018; cv=none; b=KTQfS2Msji+tAhxWTTPVjG1g99XaK6ikC9w/HwjWKyRpsPL1VE/rJJ4695Piu1Y6693y2d+hTSuZ2XudzVYiBddCtLGjeQJ4QbdSMJQcjCKfQGwZJJk+qmwGMP+2ytcdatMBJI/s+NauNVttGCnevNb1jzMur1l6pdFV/M6+HWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752735018; c=relaxed/simple;
	bh=Welx8XGSpuRGUGp0SNNFwqELTB4iugyo2NHdWQcA1QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sCvC70kWNKucTasUeKiV1Mz98PXAn7GfOcFWd0K+8LbyeUiSJMblcnUjPunt/NQMH+2km0FirYOMCuSVfAIXukKsbAja3+j+KyJs+INX15fl7zrfhJf4FXXgxHygg2GhJSKCqJ957HomUmzsn4fbvK67mORBrsz80vLfsSoZ9Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=iELNt2Bi; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-879502274cfso20996239f.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 23:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752735016; x=1753339816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRP0QV8PsF634DZbiH7Bzk9P/KhNWvkCg2Ntb8AXlf8=;
        b=iELNt2Bi7b3tUfdHlRSWYiB5jKpjTGAVQDjdTixuYPvz0o+1UNoXcujbQsuk2ej3IR
         QrcVzXPx9K7yKmT5QvhLRuF4ERzJaTCcixq5UK/buZ7oq/Vb9s+Vl/J3TYq/79Ee2ARJ
         7Dxa7mzQcN3WYVd9Ki5ffENCsX/OsE/PiRQ85X995a/jLsYGEzrI6UJreyTFR+0TavFL
         cJZKrlFB+KeNEe3vpCLLJ3znY3psmTWgaCAKRHFFGVvuZ3osxEQEzwGei1Jbh8YAKK9Z
         9arXMqCh+07xbI8cj/DIs9lHDuA3R036kyFznQJZxRBx6M9FH52X3cR/qmQfs0CveMHh
         SvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752735016; x=1753339816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRP0QV8PsF634DZbiH7Bzk9P/KhNWvkCg2Ntb8AXlf8=;
        b=q476PQkZWQsjiLs3dOZoHU1vCFdKZNC61e1zozXPbhb1FcF/KfNZYqVb+j3+19ouZn
         WVTzBALt7pPWWEOfiTk/zp7WNABm7aI7NwkWKs3alu85WPwyI9sM+BrPVE2YKATlEPtv
         34g5NB0kzYmLyk9MnVAYoGoRnvAjYlBBm/xJSdxPoNfgWYnzv46UUAP2vkaX3Av9R/vo
         YkHfwBLb9Hd5HdeSvQGN6zqPRedvK17uvgBaz9oXJbUXG05UdjIIx0ucAQ6pPIPrda1V
         11OBtLM2AfWZ9F/9CCHdp/FSBqBXNB5DXM7JwN3r/Nq+QGB1M1gNCL5hiHgDYYJH5Rya
         +1tA==
X-Forwarded-Encrypted: i=1; AJvYcCWPcXu9/iJHCjtXrtngXxVL/ZBeK578zB+Oqw9nwy4xXBSGyUtjW+0sg6dla3kQT4yQBaU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuh78NSXA06611w+o6CSfwJNnz2AUKTfoYphl+s0GYKFyavhuP
	6MTd0KSwhP7Luh0oiJxsf4N9EEJN/dwXtt+mWQRwcQM+DmPgemvXKXGuTOrFMGaIECQ64XJ6uNb
	7sOY+Ddm+r3rFF8Yjqd8mUzbgqDqAaywwCVYHBxRVJA==
X-Gm-Gg: ASbGncvNa2dnRlZzhkgtzRAiRJBcUAYi0BH7Qd8tlmi2a0OGDDIR+p8jU/0BdXXnMvU
	QDaGD2/t7gQA7suzkpWJ9qNlq1Wmy0aK8GBnWM9AdaT5TPTOTxca7K1QLhiCEdgnt4XZAw5t71+
	PohUZ3FTuQvZp4d9+c95AYM7OLbT1J+Kakx2NViqVZIa4KcsBLy19Po3RPticfFRJXHwy4TSwTp
	VCjTQy1IgIxcqhj
X-Google-Smtp-Source: AGHT+IFZ8nvXjCaZDaRw8/yf5Mquo02OxAogwOkqoPvU2H/adfyL7R+G1wf2juDA3dRWlbOsvfGrx3RO4c7yvPjrEd0=
X-Received: by 2002:a05:6602:b87:b0:873:3691:6fb8 with SMTP id
 ca18e2360f4ac-879c2a9ce57mr522646239f.8.1752735015916; Wed, 16 Jul 2025
 23:50:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <230d6c8c8b8dd83081fcfd8d83a4d17c8245fa2f.1731552790.git.zhouquan@iscas.ac.cn>
In-Reply-To: <230d6c8c8b8dd83081fcfd8d83a4d17c8245fa2f.1731552790.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 12:20:04 +0530
X-Gm-Features: Ac12FXxjsfWvqdAAcziMJWepGgazwPrr9F7mVz3S3QUEnBEAVtT1PWIUTzHtpEM
Message-ID: <CAAhSdy26sV0SKjzKJoWF9vH2gLsBnqRfV1rCrWGokM0E=w0nJg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Use find_vma_intersection() to search for
 intersecting VMAs
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 6:43=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> There is already a helper function find_vma_intersection() in KVM
> for searching intersecting VMAs, use it directly.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b63650f9b966..3452a8b77af3 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -487,10 +487,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>          *     +--------------------------------------------+
>          */
>         do {
> -               struct vm_area_struct *vma =3D find_vma(current->mm, hva)=
;
> +               struct vm_area_struct *vma;
>                 hva_t vm_start, vm_end;
>
> -               if (!vma || vma->vm_start >=3D reg_end)
> +               vma =3D find_vma_intersection(current->mm, hva, reg_end);
> +               if (!vma)
>                         break;
>
>                 /*
> --
> 2.34.1
>

