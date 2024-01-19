Return-Path: <kvm+bounces-6462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F5B832441
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 06:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D0DF1C22AEB
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 05:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308C84A34;
	Fri, 19 Jan 2024 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="fq25ZT8G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C54A08
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 05:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705642431; cv=none; b=f0vzB8OPnW4WOYeX8BtdkaY+HOOHVNsbXnoFly1HwEmtgsjI+4rMcJq3l0RohbC+aqse8N+2vGCROgYiFbS/BEC4vj5ZyhC/Qzk0iPnWeO25qthgLIcTedGCBv/4WidYfDies6/leCMZMi0WdGVErtpyWO7XxhdoWxTsP1nUrPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705642431; c=relaxed/simple;
	bh=DikTJr+5VkQ80LuVxGa5umASYeUz7U+KqYeHYZBYPDY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Lu5MeP/JQmaezXjatZYVIKg9J+KKQB5mGX+r8PmlcCMTckYF11puhlUXjmOoEr809JEn5ra68KYdPr+iIkuN/hJ055EVAcTSxluhGEsR1LzwdKlms2HiyEJG0IhtpLA905PAofFVmfSN6GvAbnel31xjAXNyiZHtxyBpZv7hzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=fq25ZT8G; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3606ebda57cso1726925ab.2
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 21:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1705642428; x=1706247228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iwQRqZOaq1LSIxFB3WC83FyMSbHTqrDJ+8okySowm+o=;
        b=fq25ZT8GDl59MuXeI33CvephekQLL2vAp5u+wLjIc6Au78ZanODZ5F1AIhW+0yJe9D
         UFPiPA+jrOETNzIb2bWuUzaF/Opiz2zWiM7BtgQ1m1mXfHX0ZLl+EPgukkgCh2zT47Po
         vMEmp/yQ/YjW0NYgQ8iHXKqVRKpz8YMXhhXOG3lfHM5RaWztJjaBjTXjVKdKbjPBQSoc
         WCkjGkV1OH6tAqJNp9WDqjoxfrK00dPOwMU4LLwq5xifBkctqshGcJe2xfepawenr282
         7tRIKmZXftkQW4r+Z+xp9OSvFD5ZOrYhZPwD5EpVbt3et7DuQjce7kyI9zaKHfZ4vX3h
         Twwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705642428; x=1706247228;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iwQRqZOaq1LSIxFB3WC83FyMSbHTqrDJ+8okySowm+o=;
        b=B5XZj9BnRU7s8MSf0V8GRxW8UhwgzikxIkBBUkfQxPhb1i3don5TMXq2SdlOCxOdOQ
         iTY0CeLNljS9+iaZIlmoaXfU7bEIRY6C7iXDgORph7XWvv1J8F4imBcC85/N7C6ikp1u
         KTByhkYtVxWb85Pi3d2ECBVGu/8gzmwI38kZL3JmrjOlJsk+FngmLG2RLSsvU/06zP1/
         DnrnV8SUkX4A+tnoCW42qKRL3bMkHe5kp/r4gUjuNuRUCZn5M76dSowu8Gl4jO7R1QV1
         w9odghGHhBNvkyjZJtfsd/BbW9YuWTrPLjoShX5SqZX99KJzpx3rdx+EhwBLZByckFOX
         vyBA==
X-Gm-Message-State: AOJu0Yz2OtPxzsEkGipzw9WxUSMbmWPqnW2PQldbcTqzRVwpvHoeLPyr
	HAsk8IaA/NOC0qTGZ3Qe9A/gna5bDE0veyl6n8Wxjq04EeuaGhn86S111ueqGieg9sHSVQojNWe
	DDstiqvBjJe0xE/bg9My6htqBX9jTzVVYx8Dqmw==
X-Google-Smtp-Source: AGHT+IEvnRlDhPOzeLXmOCMBHdLrnzLx6ryB2yAGoQtAM0g42obVawHmkFIN+ZFGqrlV5leB0437UZ10vuv3r9lLQ3A=
X-Received: by 2002:a05:6e02:dd3:b0:361:a7b8:80f8 with SMTP id
 l19-20020a056e020dd300b00361a7b880f8mr1179688ilj.25.1705642428441; Thu, 18
 Jan 2024 21:33:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 19 Jan 2024 11:03:37 +0530
Message-ID: <CAAhSdy2rbMeTwwHU_dHwUQi3AQB1qGNf=ByvzG11D99ZOJ3djA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.8 part #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following additional KVM RISC-V changes for 6.8:
1) Zbc extension support for Guest/VM
2) Scalar crypto extensions support for Guest/VM
3) Vector crypto extensions support for Guest/VM
4) Zfh[min] extensions support for Guest/VM
5) Zihintntl extension support for Guest/VM
6) Zvfh[min] extensions support for Guest/VM
7) Zfa extension support for Guest/VM

Please pull.

Regards,
Anup

The following changes since commit 9d1694dc91ce7b80bc96d6d8eaf1a1eca668d847:

  Merge tag 'for-6.8/block-2024-01-18' of git://git.kernel.dk/linux
(2024-01-18 18:22:40 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.8-2

for you to fetch changes up to 4d0e8f9a361b3a1f7b67418c536b258323de734f:

  KVM: riscv: selftests: Add Zfa extension to get-reg-list test
(2024-01-19 09:20:19 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.8 part #2

- Zbc extension support for Guest/VM
- Scalar crypto extensions support for Guest/VM
- Vector crypto extensions support for Guest/VM
- Zfh[min] extensions support for Guest/VM
- Zihintntl extension support for Guest/VM
- Zvfh[min] extensions support for Guest/VM
- Zfa extension support for Guest/VM

----------------------------------------------------------------
Anup Patel (14):
      RISC-V: KVM: Allow Zbc extension for Guest/VM
      KVM: riscv: selftests: Add Zbc extension to get-reg-list test
      RISC-V: KVM: Allow scalar crypto extensions for Guest/VM
      KVM: riscv: selftests: Add scaler crypto extensions to get-reg-list test
      RISC-V: KVM: Allow vector crypto extensions for Guest/VM
      KVM: riscv: selftests: Add vector crypto extensions to get-reg-list test
      RISC-V: KVM: Allow Zfh[min] extensions for Guest/VM
      KVM: riscv: selftests: Add Zfh[min] extensions to get-reg-list test
      RISC-V: KVM: Allow Zihintntl extension for Guest/VM
      KVM: riscv: selftests: Add Zihintntl extension to get-reg-list test
      RISC-V: KVM: Allow Zvfh[min] extensions for Guest/VM
      KVM: riscv: selftests: Add Zvfh[min] extensions to get-reg-list test
      RISC-V: KVM: Allow Zfa extension for Guest/VM
      KVM: riscv: selftests: Add Zfa extension to get-reg-list test

 arch/riscv/include/uapi/asm/kvm.h                |  27 ++++++
 arch/riscv/kvm/vcpu_onereg.c                     |  54 ++++++++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 108 +++++++++++++++++++++++
 3 files changed, 189 insertions(+)

