Return-Path: <kvm+bounces-12570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CB088A2D0
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE5FE2CA77F
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C8012839F;
	Mon, 25 Mar 2024 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Q/c+0jDa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CF286AF7
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356478; cv=none; b=d2SsCNMgCU6kQLe/Rj2wl87XfY328hD3lYmKEbWwLQLhfhGy/zWsWVUxVWi69DQRg9f39XUDEtAt7y1JhjUyhc38H+SH9d5KG+4HXD9MpJQxy/1kg3RoY2PG7HTIq2hKVKO4P40M5mfW+XGIv9SHA5QDfFDDxQn75xeu/ZGTg9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356478; c=relaxed/simple;
	bh=oSJ//K8ol+P+P3Zji9tpLkFEeZi6qEgFOq9Ft7w2m3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PdX8vZayKtMiNtj2XHAObdra+ZcWpnS/FEZsOcpRheuhIuf8CUaXPxOT90078WPK4ssJYvliz4VlvyHNEEFBkUHx7mZvapdTqx9OhTpSjtqZaLNiF3MTQuHGIEJNw9ZyzZk8wEoPqZp49WKtxdRj4k5XBrZR+KjqOnn8FIONMwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Q/c+0jDa; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3689641c9a2so197405ab.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 01:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1711356476; x=1711961276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ms4jkXPSE9adqqhEBzf7IdCmvUVjO/xSfy0M32pByFw=;
        b=Q/c+0jDaGgQYCMEOJaTdZoj++p3BlqBXR11KnFZ0rESNwTqD5gRxO0dnbBMOzKIB+F
         nqTMiUY24noqpvp77sa5QBpo+fzo0ROtsUO6mc7vHwY27+L7PCsLVNgWDgL6ElI5Q87G
         oi2PfBuXcUGRJEzpspjlbTBgjXDeVqqPl5FRiJEDxmUxwSBpzfqAPTi1b6kLDcMBnXon
         kk5aKPiszi6EDTZtaT449yERNirSjYdh3HD8pGgfhIKXRC4SYZdJOF8r4PPfUtUsKpDR
         /UZXbqq3tv0HpoZVaNrfFMuQZ9d78lZ9HP6LRAWR5nhzvhjsclkkr2jSXHxhSjbQ/zru
         cNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711356476; x=1711961276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ms4jkXPSE9adqqhEBzf7IdCmvUVjO/xSfy0M32pByFw=;
        b=O6YIJOeFTZ7/1miHnSBdho3QtaX6vc86X6QVetrXQ0Q2eBdX3uiehqMSjWWGEkw+3I
         orsTgfLfTUtblL8alUbuN0g9oFSeUUO96tEQW5vyd716EKuK1pFpJt04nNO+BmGxhkHf
         d+pyjdavz3GqCgnHQt5Msk2BUnGbozgeDd0A56bY+eMekO0Ph9eujC43KFgoOtbqJFkx
         p94J3qz0QkrlOouBHyIM1/sD5uypL6sYzP0YcoHlSmIWLCG9PxSwemH4ji0iPfL4AtQu
         TCpBV1u/G+ok2/Sf8wxpHvUqmsPCNEsmgv7ixbIP/xdMhj+GoK1kESaMw+Fz5+OLfS/k
         bRHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmBPsnNGiceHzBZMPKPHcJTW6ABKCe0yoqWuUpPkg8vFRIszoQuFULILqjLd4Ngza+zYnw5aGaf+GcW4egfh2NMqjM
X-Gm-Message-State: AOJu0YwWjNCJtVvP3qclnc3gIYqD+hLNwnqGadJfg7H91dPdaJFsyDYq
	9DaV/KRkwOhnqJpIsIACxSQ1/0QvEFvZufVDFKSQDOgJvGEIYZ94PSfyuoS0wnTLZampPjlW4FQ
	LEG8KPUQwetteFtWcfyKnq+fCQ05NQwIp9WVlwA==
X-Google-Smtp-Source: AGHT+IGSCwvEljJGbfYn9wLE/b5/75aeMuRrUiY3C9t/Q3AwACOXzG/3thuOXyzf1ItEA8Vd59vdH4gk5NwdYae+Ems=
X-Received: by 2002:a92:d744:0:b0:366:ab6f:f63 with SMTP id
 e4-20020a92d744000000b00366ab6f0f63mr6709994ilq.3.1711356475818; Mon, 25 Mar
 2024 01:47:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315092914.2431214-1-colin.i.king@gmail.com>
In-Reply-To: <20240315092914.2431214-1-colin.i.king@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 25 Mar 2024 14:17:44 +0530
Message-ID: <CAAhSdy2b1nUO5u0cM2uMcow931UX0Q=o_OY_YLQ5+oK499PX+w@mail.gmail.com>
Subject: Re: [PATCH][next] RISC-V: KVM: Remove second semicolon
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 2:59=E2=80=AFPM Colin Ian King <colin.i.king@gmail.=
com> wrote:
>
> There is a statement with two semicolons. Remove the second one, it
> is redundant.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Queued this patch for Linux-6.9 fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_onereg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f4a6124d25c9..994adc26db4b 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -986,7 +986,7 @@ static int copy_isa_ext_reg_indices(const struct kvm_=
vcpu *vcpu,
>
>  static inline unsigned long num_isa_ext_regs(const struct kvm_vcpu *vcpu=
)
>  {
> -       return copy_isa_ext_reg_indices(vcpu, NULL);;
> +       return copy_isa_ext_reg_indices(vcpu, NULL);
>  }
>
>  static int copy_sbi_ext_reg_indices(struct kvm_vcpu *vcpu, u64 __user *u=
indices)
> --
> 2.39.2
>

