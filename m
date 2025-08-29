Return-Path: <kvm+bounces-56286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA36FB3BAB9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03CE67BD080
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06DB313544;
	Fri, 29 Aug 2025 12:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1cU5OEAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CFF1E285A
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756468993; cv=none; b=JLfcYYUn/z9aYKTzpvbikzJD7P3sP0s8DzguI7ifNLJV902FK3HlcHz4aQYt9s1VwHJE1WkZDzA2kqvkAis4vRGBkADuxOZkS7uxHBVj3KrkclO4U2/+d1P8vCDgOhfbh65Nr+iSYYmd4BbCjD3nPBZ6FVBMv9OJHd7vxfRyGsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756468993; c=relaxed/simple;
	bh=nb6yrE0Hl4oECRDUs/vSFADkqTj6nAkPpXo38m9+oCc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=q1xRTyr7QiNH+B13mNJ+lEaOHP262KRaaJWfiOGUujoF4fQG6M4VEgsRJLQYJo6OQlHjhLM4no/J4gxic1SxkP/nlz2/pzcpM7VDNxvOEjp1FuZ7kzCwgGkhTC6U2O4OLsrD1tWPNitqdchDTDNnTlUuBAJUsWR3obNda3Zbj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1cU5OEAg; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3e854d14bdaso20278645ab.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 05:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1756468991; x=1757073791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jYNFutfh++jtwXbKK5NcgiM2+AZs+kWzua2N3lwLnEY=;
        b=1cU5OEAgWY2xjqnhjl7WtTnbfs9VO1wko/1+wCQ+gVpgbKyDp3EEIiHDwx9YRl1yw3
         NtDq5fIl22a8lCkISEwRaqGUW4gls2ARRkq2+oOoa/RpAh17g3yimD90bpzhIFDOr9uY
         o2guftcaEzLEolZPjFl8PAuXkWTMoEPwpXH6DgOovawCnWLEYxlI+GzVxQ8RRkCyq1/z
         LMUj3nRzgMPesmf9xIJCzHbqjJt18d0wRr27oDp/vFY5eDyHiDR3QIqo377ILOY+Snp7
         LW+z2OGxURTAOPZNOb6Jz6APRHtroFm99ZxYONTcR6iKdt0Y0syopC6jMbk/eOrYu8nZ
         ZEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756468991; x=1757073791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jYNFutfh++jtwXbKK5NcgiM2+AZs+kWzua2N3lwLnEY=;
        b=ExU0wOueqYxcOnEtejgDv1Rkv+FJE9jjIueMJLmZP8AtqouGnMwk3D+rwfzIpnicyN
         9v+81PGnvSUXdKkg3vPdudErBLoGXXau2oXjILjvxKoh6thy3Rdqcb7btEJG2buLOdEv
         5n3jqLndHdBv/mXvoWO36ZxmaAS+5GBCH+Qxr6jxsO8of94JDHM65z2L62y/pAr3YR3O
         BaRrXoLjz9r3JGBeW7ugmQBbLBX5ZPQOy4IibYppyUPdK5HRigOqvDC9NXY4iQqOh45N
         CF9mTnDhMzD4aC2Y5L+wX8WaW1596K4/Gh2D/89IshP8sOvDJo6rN8RjTvNHW1VhuJQG
         2Otw==
X-Forwarded-Encrypted: i=1; AJvYcCUO+zTgShiY49ycY1onYsvZbyEI3apj2Tt4y/5ve2/jk9E9dqOZpuvy0vyXmZeKdYrIfoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoW26z4KLOX7jwlWtqIpS5ITB4khmx3DdMxqIfbaEoyvg4yDsZ
	Jg1pmJxIG1PbE7toBIoJ11GllsoG5xeygJVuEH7FEKennlBqHEjM/xb07pd3aHfchmM1WBpcxSv
	oEXZP3l2JV2QGISTwchKsRXLEcRl7PZRjnuK9KvVYDg==
X-Gm-Gg: ASbGncs82j2Vghzs2RPnsoXsNA0pIDGEa9Hq6atI8EFrK0/c/LMXECqzKUlxxVwYWwi
	1ZapHVfBuvdetLoZWBSrIfIXHj5D/5SQ6eGgBmVnJjYN5o0+6HxClWCZIsmtZOns7UN5uC+u7z0
	EMz8xBotFJURarhYgn5FTQ1qBRhlN6AbZF3dymjCHKlkNuj4dCsLwbbzKdSMUWUEiE3Hk5f02pL
	V9fuNJJp5jVhxiVQNJa8IApeyANIu2IxHzJvawdrFR2zjL4r18=
X-Google-Smtp-Source: AGHT+IFXsAoUNLkdTWWs+sGF85vxiFHbYT3ArWNVeedfUfoSfqzjbXKy27En0OAYFF2XHtzCHU8/JEzYpKZ8RSq7cV4=
X-Received: by 2002:a05:6e02:3781:b0:3f2:3b7d:58fd with SMTP id
 e9e14a558f8ab-3f23b7d5caamr71228615ab.2.1756468991131; Fri, 29 Aug 2025
 05:03:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 29 Aug 2025 17:32:58 +0530
X-Gm-Features: Ac12FXy9Q2PA7eHhvU1GhQ7yjn4SuUQfNFmkh0YnStroRXWqxGkWkkjID8r9Y5I
Message-ID: <CAAhSdy0c5tScwHk8iLoF39dxFUSLg1RzST9=4EQ3C8KogvbM6w@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.17 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have three fixes for the 6.17 kernel. Two of these are
critical fixes in kvm_riscv_gstage_ioremap() and setting
vlenb via ONE_REG whereas the third one is a trivial fix
in comments of kvm_riscv_check_vcpu_requests().

Please pull.

Regards,
Anup

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00=
:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.17-1

for you to fetch changes up to 799766208f09f95677a9ab111b93872d414fbad7:

  RISC-V: KVM: fix stack overrun when loading vlenb (2025-08-25 10:26:20 +0=
530)

----------------------------------------------------------------
KVM/riscv fixes for 6.17, take #1

- Fix pte settings within kvm_riscv_gstage_ioremap()
- Fix comments in kvm_riscv_check_vcpu_requests()
- Fix stack overrun when setting vlenb via ONE_REG

----------------------------------------------------------------
Fangyu Yu (1):
      RISC-V: KVM: Fix pte settings within kvm_riscv_gstage_ioremap()

Quan Zhou (1):
      RISC-V: KVM: Correct kvm_riscv_check_vcpu_requests() comment

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      RISC-V: KVM: fix stack overrun when loading vlenb

 arch/riscv/kvm/mmu.c         | 5 ++++-
 arch/riscv/kvm/vcpu.c        | 2 +-
 arch/riscv/kvm/vcpu_vector.c | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

