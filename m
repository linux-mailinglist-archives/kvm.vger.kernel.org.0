Return-Path: <kvm+bounces-52228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21449B02A6C
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 12:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 363A71C23F1E
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 10:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCF3274B41;
	Sat, 12 Jul 2025 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="DarnXyew"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5C1DACA7
	for <kvm@vger.kernel.org>; Sat, 12 Jul 2025 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752315898; cv=none; b=tsyhy6JR7BeH0C46diXt1ZOQvIgPGjmkb380Q7F63Vjx7Jh+DEiIH58QIP8TNEbOEySKtOR8t/0BH7luGuEc74Vmwkh2Dge6SYhSKsJQ6k2uJBaKXSLHKatmWgAw4qOzqQ+hyfq0MHJH3E8M6B8PfkYLzT1rbQ0o+1kQdVEBXtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752315898; c=relaxed/simple;
	bh=Tk93pFq/VBezd82Gzu464vxOWqCeTbm/6sTYApq5bzg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=epO+gX4NyQE8ps7bZYxMzKys0rNRNZ4iiuG9pghxyRRPpA2Qh21YLw+AZRAQBlGXMgGwE6Lb32vMoE9uCZBPeRpOAWnYJRXPZx2aH3I13nDWbPb2BUDPApVWpJoFuPtXrn3b24fz8trJsK8S45r+6semTRZanY/yeiWnoZapkfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=DarnXyew; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-87640a9e237so240010539f.2
        for <kvm@vger.kernel.org>; Sat, 12 Jul 2025 03:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752315896; x=1752920696; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dCU4bgUbnXvZ82jiG94+o4ASlTjyH7jDB0NCEushSNM=;
        b=DarnXyew3aUJYuw4A/Um4XSOy63OY/Wy7lkTBxOLBgHivyq23stUQdvhiB4Rm81bNj
         Ni3TnOUAeSVcWRQpB4VbOJFFpWJwb9DdHcdqGhpBaagulNu5jF+Wr9vJweOVA5LkV4GV
         6/Cr0VqpPtcLwQE/VhRtPcNTLdnnAEZ+cxkL8rV8Zubs2NP0rURCU+dBtqpF+uOnSA3e
         Janc9q/hZDnu8BBKPI5RxM3M4WjaHQkAG2m36Fier6GkjStD0HbowD4uiiVXu/yWzvzH
         DQo/9WlPjrxrh1SZFMBr/NTHTFvWqc3tz3QIqN58E57EHhQryDEi9dj+MrYY7FkvEgcU
         W9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752315896; x=1752920696;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dCU4bgUbnXvZ82jiG94+o4ASlTjyH7jDB0NCEushSNM=;
        b=TSKLZraizxyT9J27MLJrWJtGWI6OWGi0/TOCEFsBuf3LSe6RPsXkoOFS5W8/zGibrH
         OxxcBe4cHzjzA148cLuTqnTPHivZkv3pgSyW07b5wLwRXO3EdFs7332LS1c5yPU82FaV
         Voyi74aeGMCoUTJkvaE6CWZIpj4Ky4y7tXB6Id5l+6U/U45f1mi1z5MlirkGOP/Msn5T
         F+3ZMpta+lTPoiTivibxLTMe+z/ot7nLLDIV7Y1GL9KpQpKMwZPn2OyIBXa1Ct2ZpiGy
         nPMXCsIFcSUh4KA6XGaTG+v3n427eADW+047Hzr17fzt8qwtHb7padXWqnQb61/Pd1Wv
         60iw==
X-Forwarded-Encrypted: i=1; AJvYcCXRwXCfKuvQg0eEdZvo4Kcc76vEQbYBY1RA9mcPXrkEANhWmKHCNDT693lOW/D7GfnZK1o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/xo46zZamH9ucwa+EboDxht/r0dxJX87qyoSqlTLxk0MqW9Yt
	RI6AOxy/nXssJ+9cp3DB/+HmFjiZTRGFb1mSl3VtKvQbcXjqkyPuQEdkWDKAHC12s3ZTlcrPRdq
	AcyV+WIsyn73wixtdMhVMIqs6VO3nhGGtLSMN0AlN5g==
X-Gm-Gg: ASbGncs8rcKJGWogdmaTDG+cmXtS76bCUyanrOo+Wq/jgpUeR1tUWO/N00KDQx8fXnf
	Hn6kn0dniyYLJ/RDPj9XWduP5QRlQQSBl65dzGBsRIfG3e0qcsoMUeFBEQDNocaLKx3bxelF2ag
	3QTeTPaFTTAV0N7Bt15tTX5C5Ywps5Jm6ciztVnsusKMDVcCjKDi90olpoQp1DOegmt50uGmd9L
	NB2J3EO
X-Google-Smtp-Source: AGHT+IEUvwOlNaKX67zF7XBXGRrrgd/vBWFzhk/JvZxSzB4yGZ48rpHvRk54/YtVPkl0kw3AwxxL6yqbQX3MQBck82w=
X-Received: by 2002:a05:6602:7181:b0:85c:96a5:dc2c with SMTP id
 ca18e2360f4ac-87977fddc7emr700617539f.14.1752315895993; Sat, 12 Jul 2025
 03:24:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 12 Jul 2025 15:54:45 +0530
X-Gm-Features: Ac12FXyD4VQVIOuVbQptVP1NvX--8ikGpI-rs3w8axR1N5KmYegrjMtYEUm3Pag
Message-ID: <CAAhSdy3_OE=R1jhF5-KBiw4mGOqHUXHdkvyeAAR18Qm8dezavQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.16 take #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have two more fixes for the 6.16 kernel. The first one
fixes an issue reported by Canonical [1] which turned-out
to be an issue related to timer cleanup when exiting to
user-space. The second fix addresses a race-condition
in updating HGEIE CSR when IMSIC VS-files are in-use.

Please pull.

Regards,
Anup

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578Signed-off-by

The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.16-2

for you to fetch changes up to 4cec89db80ba81fa4524c6449c0494b8ae08eeb0:

  RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
(2025-07-11 18:33:27 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.16, take #2

- Disable vstimecmp before exiting to user-space
- Move HGEI[E|P] CSR access to IMSIC virtualization

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Disable vstimecmp before exiting to user-space
      RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization

 arch/riscv/include/asm/kvm_aia.h  |  4 ++-
 arch/riscv/include/asm/kvm_host.h |  3 +++
 arch/riscv/kvm/aia.c              | 51 ++++++---------------------------------
 arch/riscv/kvm/aia_imsic.c        | 45 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 10 --------
 arch/riscv/kvm/vcpu_timer.c       | 16 ++++++++++++
 6 files changed, 74 insertions(+), 55 deletions(-)

