Return-Path: <kvm+bounces-13382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC71895894
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B603428C16C
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AD91327FE;
	Tue,  2 Apr 2024 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="RlrFQ/As"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F08812BE80
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712072897; cv=none; b=sdiap8dgl+5mmKLf00Sy7aVYD1yBdstZXXxRRuvjRwFZL0BUCdPK0w7fW7ki+OrRLJtib0fP/a+ExMFFRRe+8AfjsPqLdz8zs27Yoan/svrEcSFRp97RnOSnee8j9e7YkZ2QcOr+1VL4VplenCGm9OkLfcp1ds70+rRus02uHjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712072897; c=relaxed/simple;
	bh=DZDlyJOl8reNU/825mHIBH7UH13yjSF26y6/tdEv/zQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UApp2Gddr71B6jsJwHSX+uD6sjQp/fTJjg/4Cxb63rBb1FykeW41mXtzJ3yUTJYVyTZ2u8opAMRMUXBSUdqvTwEyHKXlebjKuK3rJupdhDhOk2yFvl15DnF1TFBK28w8HEPLsKcFgYjArWpUxJNEL0MFx9tMeaI5LD5gKVLUuh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=RlrFQ/As; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-368a97b31d1so22699885ab.0
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 08:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712072894; x=1712677694; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fB9wvfeaRu0tbAm21VpziSooOQ2M5ya0jZi8/+/ocMk=;
        b=RlrFQ/AsRZIBDbf4ofeb1GY7z/3eOzi/uWexvopAX4FRlvdBbiAYOzJuFBPBumjUHg
         VZk5og31JxF+ru7cU+fCG0zxEoQtd789EWE/1e9ZEduAnNFCYYUgI9Htqw4addCsnudK
         XjgSRrSgmMQwYsh+iaB/9OLm3o+R1Q9NVBenEvak1bXwUb2MFli1T9qNuaaaCJLUeBeK
         KgfcThHXUn2onomOEG3V/UONnj4YUU2HWX68JeTX/CB+quTO8Rb7+XFXegYxwSxCvJzZ
         ZzdKaBVc5wUV13qvRS4ujVOnA50GlDZuQXfjLFthrF9s0zUVp6lEE1WyZZvw0kkW8Dur
         R8uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712072894; x=1712677694;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fB9wvfeaRu0tbAm21VpziSooOQ2M5ya0jZi8/+/ocMk=;
        b=BTN2Kvw9yrZJwzrIaH9xY3ElXznBGgFWmSM/eZcqfb3L/+LkcSMTOmPSLSMrjb98O3
         wMRcIHYOI4K5XuRgyHxg6feLUGPPvPYsdeOUsNW9Q8qS+Iw1IPVzfVEM0HAT9QL7QXXs
         koj/jB47IbPjrFed20zC5XFWmHVnBRc7Cr1WawjD4vjq8AYco76M+DmTglhIXMEdJduX
         aX+Y8AjsSnvBBmAhhxcsPX7Op6mKQkEJraNhXkCPDbfJ/kSiWaQpWPuwj/0rZvB9Nbxp
         JNqap1AZWWt062Uvb2oSCnxBg/nclKmRcDybOyjeCq28ND3fYkleOfOO1ivxy4h55qe5
         yNsg==
X-Forwarded-Encrypted: i=1; AJvYcCUoc/+x7mfKYDLPZzyoQBZjAvw7pPZFF2UsvAvVmBdDWw+0o/IUvTQG0WONS1Vp6i1scjFuSU0aFsxLzCtFZLpLadlV
X-Gm-Message-State: AOJu0Ywou09/ZjlpjDxcvAI5O1H+qj5tXaVePSNnBQMugv2wmyw3v4V8
	6loJIIkS1JqFgm22Ri2Y5K7CJzi2snJf3shr/XR307Sz9PZ+4HL8NCuQQ2gZ/J9BLPAWgjdTooG
	6Iw6Y0KNynsTVcCX1jtLN/a+753DfDQGfLGn/qg==
X-Google-Smtp-Source: AGHT+IF/KIeqABbokzZljH+LAgY8kIZSFE7qipbYmjVKY2fkpR4302o3Qfd9r378gssUXTZN81OKQEw3/egpsssqY+I=
X-Received: by 2002:a05:6e02:1a4d:b0:369:95dc:e4da with SMTP id
 u13-20020a056e021a4d00b0036995dce4damr855201ilv.17.1712072894488; Tue, 02 Apr
 2024 08:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Tue, 2 Apr 2024 21:18:03 +0530
Message-ID: <CAAhSdy2e237A_vA022kh3cmy-YJ_t=0iXyRkbQS3NSR=_Z+6HA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.9, take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have four fixes for 6.9. Out of these, two fixes are
related to in-kernel APLIC emulation and remaining
are cosmetic fixes.

Please pull.

Regards,
Anup

The following changes since commit 4cece764965020c22cff7665b18a012006359095:

  Linux 6.9-rc1 (2024-03-24 14:10:05 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.9-1

for you to fetch changes up to 8e936e98718f005c986be0bfa1ee6b355acf96be:

  RISC-V: KVM: Fix APLIC in_clrip[x] read emulation (2024-03-26 09:40:55 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.9, take #1

- Fix spelling mistake in arch_timer selftest
- Remove redundant semicolon in num_isa_ext_regs()
- Fix APLIC setipnum_le/be write emulation
- Fix APLIC in_clrip[x] read emulation

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
      RISC-V: KVM: Fix APLIC in_clrip[x] read emulation

Colin Ian King (2):
      KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
      RISC-V: KVM: Remove second semicolon

 arch/riscv/kvm/aia_aplic.c                       | 37 ++++++++++++++++++++----
 arch/riscv/kvm/vcpu_onereg.c                     |  2 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c |  2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c   |  2 +-
 4 files changed, 34 insertions(+), 9 deletions(-)

