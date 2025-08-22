Return-Path: <kvm+bounces-55498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0DDB31634
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 13:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D78907A289A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 11:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68C42F6563;
	Fri, 22 Aug 2025 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1OjGNOk9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BABC393DE1
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755861635; cv=none; b=oj8JxvgWxe/rRYjbObuf1ZhE8bjQFTXyTHzJnmZ+EPI/hWtspr0KIlI8quNbbyx/HAFGZDyBumiXNYy1t3uZoGkM/bHaMX3b7eK322+nBRSQzxVaUKYM1tZwHZ1Ys9GdpDLO0D59w/sPXELc2eOiaJS7DPlsYca+SeDzqBAGlyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755861635; c=relaxed/simple;
	bh=c8WaWLL/LfS1u8VhVZZkyvB1L6L5PRqd9nkHdeBWsHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BAy1PLLNJ77utIguK2QVcVA16QNFJhWSRXlkJFQvdT9Zv7OYjiuf+GXDkWG41c7DdqLP6nfMQKoWPemXdmrQ+uAU8bjGs+/uFlGKA8IqwZYiviLvpiUYaE3JnplQUkYkOL2g9xDYVwYcl4JePrHbLbpm0/grzRczR/irdvAAukE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1OjGNOk9; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-88432cbf3fbso168573039f.0
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 04:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1755861634; x=1756466434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/vfvb14CGNszwxeStpY4dH+U6nsuyg9PGBngcSjux8=;
        b=1OjGNOk9jmpZdudtkoKhp3kk8hEOZ/UpjB/WLMIY5ZC3YK5sJlNhs6LEtxb4iapKoO
         4ZdV7ihufMHtlydJTCFlFi7mRbBb1+SXMmOzSVpF+IN0mBPGDf1+Gke+IBKqYArVuR5P
         LcJ3LHuEmIATM+v+SSMDzQcuxYZl/+Xp4nGYM/bIqyh12BktM3hXGEBjcO5bujcNLIwF
         oazHMZHF2J/Rsps0jDpiXyKF49V6uD2GfLKZuwSiULuctfLzVv87xeQ2PgxrrkdNswbz
         EtX0C35GD6aBWnzHLNVaCRZis8YdVIwhhRsMwnORWemxbgHmXzMRUEZbO5yjx3AXPIAz
         hGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755861634; x=1756466434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/vfvb14CGNszwxeStpY4dH+U6nsuyg9PGBngcSjux8=;
        b=Ki3vuSYdvou4KQgLL4lxhLfPUD7BBHB8+xsP6HzKWuv4QL914MJZHKYPzjn28uclj8
         hxs7Ar6lMNuGa8NtlkDI+A8wXJGdWq48hhkKPB2OxhRCIafU/KMwNQvHe9zK7tOvDXWg
         2MmkgtPnE34fKdwxgamNyrdKEsog1hQ+MaCVtzP4FjRGF8+vHl2OJPNvWAbRo27x1WHq
         YtseMEsO+mxgflHGLtJXZ3R9Ege0yGLxmmT8pihXcl8csgjefkcbvrGvCbTKl28U9nge
         xUvKAXcURWAZwpWzCth2OUfLKKHAx5Nci5c8onVeaqeqTo0U5sRnvNPlNQGei9GNlzzF
         /jvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGa2s5ncOfrEwhDlCOL8Ngvzg7QfLlD2SUspnH5mwoiSf4DSw//Y1dqpjxSRhIyzqpYqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGXRxDbbG6lzveMIB3KUXhNKgg99IF5mhkwwguNBOeheR+VPJY
	R9GU0iwLTZhoOIHHwiCMuo3tlfCJyY+oItihqeJDkCjM4/GLCtJWmOgavAEQkrJcktkECVfYhNL
	FeR0lVzueo+NrwqFQuUPdlwGsDFq1/b/MlfDktnkpYA==
X-Gm-Gg: ASbGnctq8QWAQvfgNhX7l1dRFHuW3Ib4XMz55kbjSzJarmDTF5iKa/7g6SwMLf5Emyo
	idHB3KNLT+cD7nc1xO3an/vLAH+hIYC/WZGgq/a3U09nYxlpdacn0t3p6fJt/foUFKuImyYOdrE
	no+34NAVG+oQvU2JRi4ZobxPDUYaVqahii5gTV2tOw/jvML9L9wBxp7TSBcgbVPrCfSLj9AdYl4
	jIU+OMV
X-Google-Smtp-Source: AGHT+IH6sSUh2jwMrj6GuWBxvwwTPiTBYkovYilK1h5/YeKQYLbFNsHzLiFIEtHdGgUpX3elX/k9WeCcNC+wsnPHQ84=
X-Received: by 2002:a05:6e02:1885:b0:3e6:6a43:1890 with SMTP id
 e9e14a558f8ab-3e91fc26d9amr43027185ab.4.1755861633631; Fri, 22 Aug 2025
 04:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1754646071.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 22 Aug 2025 16:50:21 +0530
X-Gm-Features: Ac12FXybuZh7H_EDZYZxjvBDpOJ1Lg5p3N7w9IhOsJAO1wqpnDrt-kCUdBS50To
Message-ID: <CAAhSdy1n+R5q3F4Fw4npz3gOGEWueYd0tDuPyzjE1stPATMdfQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] RISC-V: KVM: Allow zicbop/bfloat16 exts for guests
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 8, 2025 at 4:00=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Advertise zicbop/bfloat16 extensions to KVM guest when underlying
> host supports it, and add them to get-reg-list test.
>
> ---
> Change since v1:
> - update zicbom/zicboz/zicbop block size registers to depend on the host =
isa.
> - update the reg list filtering in copy_config_reg_indices() to use the h=
ost isa.
> - add reg list filtering for zicbop.
> v1: https://lore.kernel.org/all/cover.1750164414.git.zhouquan@iscas.ac.cn=
/
>
> Quan Zhou (6):
>   RISC-V: KVM: Change zicbom/zicboz block size to depend on the host isa
>   RISC-V: KVM: Provide UAPI for Zicbop block size
>   RISC-V: KVM: Allow Zicbop extension for Guest/VM
>   RISC-V: KVM: Allow bfloat16 extension for Guest/VM
>   KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
>   KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test

Queued this series for Linux-6.18

Thanks,
Anup

>
>  arch/riscv/include/uapi/asm/kvm.h             |  5 +++
>  arch/riscv/kvm/vcpu_onereg.c                  | 34 +++++++++++++++----
>  .../selftests/kvm/riscv/get-reg-list.c        | 25 ++++++++++++++
>  3 files changed, 58 insertions(+), 6 deletions(-)
>
> --
> 2.34.1
>

