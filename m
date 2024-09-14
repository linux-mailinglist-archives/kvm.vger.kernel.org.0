Return-Path: <kvm+bounces-26916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C935F978EF7
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83DE4285EE9
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C81713B7A3;
	Sat, 14 Sep 2024 07:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="DLUHpjti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC7E10E9
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 07:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726300047; cv=none; b=jqF77bdTPCq8bhu43rBfcx0BE3PB6hsSOghijaaFg9aXtmE6nxhtS8Fz0A3lbTr8zdN1/XrVJewuX6KjWiOqCZ7xmm6HHUcSLuNQcRCAl0Y+PhPFhuBBLBs3v+MJCsSVwoN30kz/yz/N6VWLR4U2tTgBTvv/3k6KIVO5zPlCeKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726300047; c=relaxed/simple;
	bh=HN4KlbogxIn9kipt/+5DY3MCRNpduAin5rQLumuXjLg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ur5GkbOk/dn3M2g4wsM1AgYIpk0RBVl6ejD9dcA3EEtzjZMaZ2j0pOAVoUwopAESEaVFJ2/eWEpzhkgtS+KujN0q32ZnCY44ztijUSDog4XsZRpZxM5vZB8Xp+yLbRWyBA3oBx4i43QjBB3uexch6AGo4n0cxJ6fAv6k9staacE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=DLUHpjti; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a08489f757so8885395ab.0
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 00:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1726300044; x=1726904844; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xCXWx1AARdSEy+aE8rrZQ09YhMgt7Bc9EsokRlJmT98=;
        b=DLUHpjtidCzRgSpewVYnMwLpdEpUYHNPKUC4gK9xyQgIdqavXEimHw8Y0kP+etqAh6
         WhJkTOtlEi8gSSCq1TVuWCE1YDjvK9I2z5yhy9wl0z5nmKg6fcYNx6kCwkhOboUMoVAN
         bniIL7WMg+zfrKzQ0owQfDyYvcUm2sT+ZqCdKATkrwimmlgJfWYnpnvjUfLZ33AsQ6qq
         Wk0gMd/r8L4Dpn2rKPeuRPFfpBDKDQ57+vRhRp0eSVj4qXQUSIoHWqJeETzYBAo0P/fE
         /7h1H7Bw/Sd0O/V8dn0wwYVutn/aPE0lwUua403lR/jL/D4NJ0FY3tjIbf7AXUpe7YqO
         digQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726300044; x=1726904844;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCXWx1AARdSEy+aE8rrZQ09YhMgt7Bc9EsokRlJmT98=;
        b=L5yQPuegbAmqIe0ycJc+3i9+3OzFKvI+krYmCjdGfUVu0GoEKHS25otBfyGBVh8q9q
         y7M3Ck3w4tB8xTnuaZhv+Bf+m4Kd6gOy9GZ+Wax6MIaczwUOynIpBMxh6Ua5jW7xtbBS
         i/JT5xrb56YnMkz7J4fNBTk8M+LbXx9smK4XaFJ7fk6Kd39x+Xq7oHf0cQmSjbvsBs0l
         X5Xx5uKxU/Q8XVFgvWTdxpdXvV8vXZHqldL6comdkgHvIP+qsqoN6XHDhYYLTCzlSjMi
         8WGj43Ccf95ur7tk5PXlom+2+0vGUXZfr31Y3TXtzHUzVCmfAWG/Ex+yW+D/HGWPPL3m
         vTFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkwBHQWwJDX6MgNG1g1EGfFA5zVAMM4XQzJzBnDMcN+8Y7EBdNkndmqvp4WGV5kN71CvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU0pmZNlz4wQcIkmZytkp8IdRfbIHrgJ6LcXJ1qlS28QJsyunQ
	mCD1L9Pk2h3tMjjDPxTCG6K370eh521WFOOTGlL2cpiiuGhk+RIU51BJdnDjiHKZ5CjSkUrLmFV
	9yy+qyXeoKtvmskrMepQN5SBeEhWIQ7g8eNO51Q==
X-Google-Smtp-Source: AGHT+IE1+YolBGHlPsnYebHEoJOTB+fxO3iuwnRSWzmivhke4/IK2SM0tqoudxlnPJ1GndHJ+aH11X+h3T8BBsrdWoQ=
X-Received: by 2002:a05:6e02:2147:b0:398:a9b3:d6b1 with SMTP id
 e9e14a558f8ab-3a08464e152mr82842365ab.12.1726300044565; Sat, 14 Sep 2024
 00:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 14 Sep 2024 13:17:13 +0530
Message-ID: <CAAhSdy0fHNoSx9KAG9nL=sc9=L+zeComyJjctD7kYOhuMNxLdg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.12
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have only 4 KVM RISC-V fixes for 6.12. There
are quite a few in-flight patches waiting for more
reviews and these will be included in 6.13.

Please pull.

Regards,
Anup

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.12-1

for you to fetch changes up to 5aa09297a3dcc798d038bd7436f8c90f664045a6:

  RISC-V: KVM: Fix to allow hpmcounter31 from the guest (2024-08-19
08:58:21 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.12

- Fix sbiret init before forwarding to userspace
- Don't zero-out PMU snapshot area before freeing data
- Allow legacy PMU access from guest
- Fix to allow hpmcounter31 from the guest

----------------------------------------------------------------
Andrew Jones (1):
      RISC-V: KVM: Fix sbiret init before forwarding to userspace

Anup Patel (1):
      RISC-V: KVM: Don't zero-out PMU snapshot area before freeing data

Atish Patra (2):
      RISC-V: KVM: Allow legacy PMU access from guest
      RISC-V: KVM: Fix to allow hpmcounter31 from the guest

 arch/riscv/include/asm/kvm_vcpu_pmu.h | 21 +++++++++++++++++----
 arch/riscv/kvm/vcpu_pmu.c             | 14 ++------------
 arch/riscv/kvm/vcpu_sbi.c             |  4 ++--
 3 files changed, 21 insertions(+), 18 deletions(-)

