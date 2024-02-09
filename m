Return-Path: <kvm+bounces-8429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6E584F4E0
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 12:57:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4867B23021
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 11:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4CC33CDF;
	Fri,  9 Feb 2024 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="z8K5kK6Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C55A328DB
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 11:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707479849; cv=none; b=HglJTcGu7YX/n2JpDgi0zaeOgYBXdxMcZeOpv45/6CfvlKADrPMi1GmX/GwjJWHhJs+J4RunS9OuFN+Faa99BPN8UBCtptOiySkbDRyypJcvOTVXFWAB2y5OeqmvNzkrBYfI3EzqhYi7AqQTTWRCdQcfj0DgfdUSJjnQRw6bwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707479849; c=relaxed/simple;
	bh=nMvBVDC8SrB1hNna4QDqqFjYCYkCX/Nvr5HSLhwcW6U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Qkr400PrhCvAmpP288Sj55Y1UajnuAlVdyiL27V0ARkx6brh7RNb+Nkq3404KisDIGasrMd/sePe7cqcctiOT3l4JnFzqesTZG/gI+UqTPKKasHw0Y6Zwbn8F4d2vRvPW3a1NHW2b66mtZ2PxY9vFwwE8bf1RMqTEAWYv9GpEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=z8K5kK6Y; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-363d953a6c5so1588285ab.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 03:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1707479847; x=1708084647; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gVdsIIV1a3ztn0kr929T9f3wstK7N0r++7XA7d2BHl4=;
        b=z8K5kK6YtbVZV1+QC+9CCidrL0QfDRgb7H7w77HUVjmx9uu2hAQIC6EEWE04lrYBik
         yGUFe/9sKfg5P9cETYR6JkEv1K4SO2CVN93IQX+S2z3FvCuE/zhbBxh6KRvQYOaBm+Js
         HD2CGvFgewWuY1FJY/YuCOcOW58xRKWRaqrVs9OB9Hc8SZemXCpr5sofevt9UlCADMlG
         ZPiRwZ5ks/fjgrN8ZcMs8mviaHbMUNg21k5yR+TJ9U6L2bJp53rOwtAXrSav5F9XnKS8
         lEVISqk7gIb+9iSeK20Hj/WHB7lnZU+/xyYJvxL5mFj5yrgeWaC4qnb389ZqnWdiI8u+
         PDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707479847; x=1708084647;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVdsIIV1a3ztn0kr929T9f3wstK7N0r++7XA7d2BHl4=;
        b=PgBuI/DNMuXghj2hFLOImGOIDeGotBgifNjnkpFU7FKoCe3oyeCAAGifnedwiPa0z5
         Q/9cuz/OikUGqFNHUIa8bHZ6AqPyqwDMb3UVnon4V8JhTBQjeiIwiunmg1BIrdu4zYiy
         kVhtxsdYF3y0Bf/KwOUDiyonGDRSo9zwNQ2cxAfoJ14qudXjinGvp0TI0rglpFJx4oKv
         HOQeb6m0ymxbBfXHc535Xk9+6HpA3BaLdzr8oIuNKq479DSduWZjNVcpNrrvRUPiyOad
         MQn2gemts1hIFEa++pJ2B0YOZdjsKBSiuNVRQWWL2wF/1ek1FUs2BkdZzyucvqYu0XTm
         FDPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQx/ogLq6/HTEV8x5LCWqmo0WSxiEdPPp5Uvq45swbfPCnGYzYHoeAck4LQJq3SYCn2/U0IVAqTVkPcbl/QhSpuJEM
X-Gm-Message-State: AOJu0Yz6QJyZC+Ckqzq5K4MkSNApEmYB1liUYfj5i7g7F26Fg7oo7dZK
	8zNMIvTIXFefN0ICi+nUXJ9IN48TyvATccEVPHMe47V9WgnegRezrlIL558eNcVLYLvIvxBFh5I
	95jbhER1Ht0Y0augrRWSEXEWIiku4Rz+FJYtQOQ==
X-Google-Smtp-Source: AGHT+IFE3jg6zoMptRZ8RVoisfoQ1OhVxu768sN+ZFhRFxMAZuv+feJajD0vHZyqJjX2rl+KlMdDjsODtC67lQmJ2j8=
X-Received: by 2002:a92:d305:0:b0:363:972d:a25b with SMTP id
 x5-20020a92d305000000b00363972da25bmr1400442ila.20.1707479847287; Fri, 09 Feb
 2024 03:57:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 9 Feb 2024 17:27:15 +0530
Message-ID: <CAAhSdy3TXDCnA+hqJyNq3CiJD9LTtL_OOqX0N=GqScL1VU8FeQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.8, take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have three fixes for 6.8 which address steal-time
related sparse warnings.

Please pull.

Regards,
Anup

The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.8-1

for you to fetch changes up to f072b272aa27d57cf7fe6fdedb30fb50f391974e:

  RISC-V: KVM: Use correct restricted types (2024-02-09 11:53:13 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.8, take #1

- Fix steal-time related sparse warnings

----------------------------------------------------------------
Andrew Jones (3):
      RISC-V: paravirt: steal_time should be static
      RISC-V: paravirt: Use correct restricted types
      RISC-V: KVM: Use correct restricted types

 arch/riscv/kernel/paravirt.c  |  6 +++---
 arch/riscv/kvm/vcpu_sbi_sta.c | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

