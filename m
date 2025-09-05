Return-Path: <kvm+bounces-56859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEBAFB44E47
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 08:52:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3773D17E9C6
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 06:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F5C2D1F40;
	Fri,  5 Sep 2025 06:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OlbAFEVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9DC2D0C69
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 06:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055120; cv=none; b=SOUY6gEYfAquYeDyLVQEIZu/d4gekqYGK057+z9JQdZ7dpFpfEtzJOfWDk0SUMvH48mAvrPSaKFQUujgqP8/ZAu16IdKoBW87/wxt7yw2sqSgSA+wVvroG4NIYQfQZvZcZjMWLsxylnED5/qpoUrFJiMdCJxR0B6To/5TG95RsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055120; c=relaxed/simple;
	bh=DaOHBz3Vp86bsV/wqEUhViNPWlyVfnJ/beJ1Xp5QxAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HlmEkWz+o9rif81hb0u+/DMWNZCosxTis84LOIKsRs/YNFMWEoHr+ph2LnZ4lJ7dsE6plPBckM6YUQR3BhO+TjNViGcYeFJ3bbTZNaHNTi8yuWEFgA6WthcyNgt3cRUh9Q8SAOioaSUsv2U3YVbIkLQNheghlYRyBYsY3pXstoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=OlbAFEVm; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3f0fcd81068so13506195ab.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 23:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1757055118; x=1757659918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nDTd5Gv36YNMyq5Qhnn8xJEK9lVHzvftyFkSysDc/4=;
        b=OlbAFEVmU5dnqNJzUnvocJUJH1fIAVCjYx6awQaowJXgrGDDJf1u6/d2qo1qEeSCz/
         PvyL+XrJ50KclY3zPkyaIf61uLvXky9vi7fLwMvDBErRF2NnVO59QnDn1LVSyL8MSTJG
         00l4dYxuYJYuMPa9tI3pOk1b9G+rM2N578imvUt92lTpRVOaAcq0bvfMl+I5NpYktL/B
         3q4gepybSzfip+/ybsJHWyk03qur7JpHK8nNkwZ/fuI1+U6wDEfu3SaI83qgO3XICML3
         JvTVAYWwuCYi0/yBmXZQ0FVLzI0aiT/GVmJk5DJ38N5V6GE9NDuHAg85pUgOz23u/MVx
         c3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757055118; x=1757659918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nDTd5Gv36YNMyq5Qhnn8xJEK9lVHzvftyFkSysDc/4=;
        b=PyuEkg9qupHpk6zf6L6R3L42Gyut7+8MCXFppYVmJ4qHyrdeTNNFGTAbcsL7FfVS5X
         8tgeB57UlykHm79COXIZI1fezPNtY6z2MMdxVl4CpW8kWRgYVT3MiZuiE0O0GpfPRyxR
         5LN+CzaQaDY6XHBG790bbQ6s0AEtpA8HzujhFfCmIx5eDZFIBdPEC4MTGEc4zNuK1VQZ
         mkec+EFbhbdvjPeT9DYxFl2fq3eDLs8hQT5YGpgS6b3COibMbZ7JnLVv4+zrOydXuY0i
         rVYEq2bOEPrrvYqY06UPpj128ajV77GPDjCnQPuxqpD+6PGwxR6GjIcqRfsP6SaBaHRd
         691g==
X-Forwarded-Encrypted: i=1; AJvYcCUhkmgup9HHCEE3+zQxN2RySHILkx+vEj56mjNkO4N4tNF+4R+pGuKVsBZh16mnfBXyg10=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZwCNRPIHQLXBsVXd0JEoVR6LuqzwhK0kCnRjN+xGNpmcs6/V9
	QaENPuHu2jV6t2zRhWIBKfeyj7UWzlvUbpRlR+4LfEZykG7Sse+6taqWUtfTPfc1WpgxLpS3wU4
	UZGHw9yiNmn0cARqIVnTWBPsfZKKSTAotZQyPKcpwVyakHcGhIKiI
X-Gm-Gg: ASbGncuB0kZNygiU3D7i6lCcTAwG8BDMtRFdRY7fCoFpLmmrXeh4CNY1QZCVDxGqq0A
	H6CiD1tuDjChrkuNATWKkcjfIo4PMdqDiYIsyByOLaYYNNEb6g+B7b3T6LOKJsPwKj4j9NxGuKq
	XhrZgTYrup7OLQE6xdVkQ7LzvfI32dGUzSwxzT2froNvlWT8Jos3FloPJkjYcKkoQpig5pKnDj1
	rXX+8E2KhE6vvj8533HVtuwqkQKEtjQNW60uNcPixtwWTQ8OI50uoFPLFMY7g==
X-Google-Smtp-Source: AGHT+IFqhsp8QkbEH2AYxxy6aZR2+3njRKvf1EkNjHXrSfDyXXsLjXgWGyrgUdjW9lEocsZBNm6jnwrKVQArR5mwmho=
X-Received: by 2002:a05:6e02:4616:b0:3f6:554f:f83e with SMTP id
 e9e14a558f8ab-3f6554ff9d2mr206848225ab.18.1757055117887; Thu, 04 Sep 2025
 23:51:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821142542.2472079-1-guoren@kernel.org>
In-Reply-To: <20250821142542.2472079-1-guoren@kernel.org>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 5 Sep 2025 12:21:46 +0530
X-Gm-Features: Ac12FXzs-ev06L7BPaxBsQRN2id94q1V5j-qhNEmATN7a2fxkATv2aO3WzvlWf0
Message-ID: <CAAhSdy35BTE8YwxKb+1YwE3eHDfRytt71fU4014zYjwyXYn5qw@mail.gmail.com>
Subject: Re: [PATCH V4 RESEND 0/3] Fixup & optimize hgatp mode & vmid detect functions
To: guoren@kernel.org
Cc: troy.mitchell@linux.dev, alex@ghiti.fr, aou@eecs.berkeley.edu, 
	atish.patra@linux.dev, fangyu.yu@linux.alibaba.com, guoren@linux.alibaba.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	palmer@dabbelt.com, paul.walmsley@sifive.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 7:56=E2=80=AFPM <guoren@kernel.org> wrote:
>
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
> Here are serval fixup & optmizitions for hgatp detect according
> to the RISC-V Privileged Architecture Spec.
>
> ---
> Changes in v4:
>  - Involve ("RISC-V: KVM: Prevent HGATP_MODE_BARE passed"), which
>    explain why gstage_mode_detect needs reset HGATP to zero.
>  - RESEND for wrong mailing thread.
>
> Changes in v3:
>  - Add "Fixes" tag.
>  - Involve("RISC-V: KVM: Remove unnecessary HGATP csr_read"), which
>    depends on patch 1.
>
> Changes in v2:
>  - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> ---
>
> Fangyu Yu (1):
>   RISC-V: KVM: Write hgatp register with valid mode bits
>
> Guo Ren (Alibaba DAMO Academy) (2):
>   RISC-V: KVM: Remove unnecessary HGATP csr_read
>   RISC-V: KVM: Prevent HGATP_MODE_BARE passed
>
>  arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
>  arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
>  arch/riscv/kvm/vmid.c   |  8 +++-----
>  3 files changed, 44 insertions(+), 26 deletions(-)
>
> --
> 2.40.1
>

Queued this series for Linux-6.18

Regards,
Anup

