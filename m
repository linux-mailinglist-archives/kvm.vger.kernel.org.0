Return-Path: <kvm+bounces-19051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AF98FFC74
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C482A28DF83
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 06:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED56515357A;
	Fri,  7 Jun 2024 06:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="QHYp2+ku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EACF3B782
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 06:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717743009; cv=none; b=Gop0/1Lf6ikGgV/vpqmyvtmFVocVonk2s5gQYv4k4AXDF+1Dr4yvL19MVNjGI8OfBUQhPkxCqV+goXTuyrD2yKjgx0LNxyMa2k1+slaQsOrTevflcIindRK3NEyyxuO0k+j1XlZFkS1FebkE/3sCnTw0TDLS0jbkoEyU0RC+efg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717743009; c=relaxed/simple;
	bh=ZzQrCgusGnG63tQAEOepIjxmoR0Qcxj2HIAwQdXZ/Ew=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=REBcBJX6hj/FiMmzHL/ipC5Fm6D4GpchFuutqL0Se00IpipfPoEmQCrFLLEEhSgQloRFm+Ke+TiLa6/5pTy/3CCahKUOhF6nSKJbSE7bh7BQqjsR9xdJ2k316vG//Lz079/lvFs8pB12aodZKjDV5nGw+r+xQgPz1KcaOOAUvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=QHYp2+ku; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-374ac2fb50cso7111465ab.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 23:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717743006; x=1718347806; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tMPl8897CpQSN9DJ/kDtQliKlOJSf3E1YJrCy5LiBYw=;
        b=QHYp2+kuBckIoMBlBTgfJ/2DyKxJceo8Kp1+taWvdcLnvmObJx8mDR5EthjNtlNUPe
         j4jJscuGBKc0ezPTjbxIFTDJHCxr0XsXafBGLS80BNwxk2X4cE3f9PUYiqYnZQjxECGh
         LzJDEohjW3AkSiY+8S71V30bDkvYVw0qtxz0JU5ptZGgKpZSph++ebugvWLYYGXCSYZy
         Jm5Mc/baL/f+fv7s9doF4J68QH54aJVouV0p78juWPV3Y3rkYIe/LhlIdm2xVrtnuGJa
         8pLgaY9QwWOeiimA4/QUsEAtHnOgS7dBH6a5DMyqEP/vO+4P5I4HQpDnwNBWGRxGLjjd
         HsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717743006; x=1718347806;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tMPl8897CpQSN9DJ/kDtQliKlOJSf3E1YJrCy5LiBYw=;
        b=MvEHFg7uklEhVWn3OQdmUvBq0qq39s/Cn5SsaWgu30bOAA4eXiiJzgQ/oXaFXn/Xo9
         k4qTqa/NFiqxoBirl6e1t7w82w+HEY0+vGFR0TEihnNPCR22gAoAKpLt3f8y2A+X4xuO
         JLFZ6oRjv5fJr3YxEQz6CYGo4AjI8ujJ3FMyeK4dd/o92W8BM1+gwdooAgQo9LLDI997
         e60cY447DfGf+LRucCOGly67gllBP2woMiZ8IBBDTept4EgHgDVhJgRr7vsDI9zLdzWT
         UFKj3L7i3mENQ3KwikX0emUtukzDbhC8WhmN+MISNQgEgYDi/zOq2eY5OjhHQAo+yZGJ
         tPxw==
X-Forwarded-Encrypted: i=1; AJvYcCUnpn7rls3TbD44rI+KAIb2Gb1pQvS4PxzOFW1XBAsm+eXMl9HWb9PB29dz0CX4LuACdN0VAoBB1MpHyw/s/Jr87Vg1
X-Gm-Message-State: AOJu0Yx0SBtblNYScfqabsjuHXZm7dc9cWDY/fyoQ02uNvfaEox3Jq0R
	Up7x3Q47K07WwIma7SnMYLy6tsxBkEwkC9FhDiMjfZMzoeW+geFRQj8L5LnW8SyWNyhs4WofE8u
	A/WMzAGInzTynA8WLSxQIf+kfZzTDLG9eqNfhnw==
X-Google-Smtp-Source: AGHT+IHOma9DkzEVCoXDhOEvw6bmcDS3u2Igp3nxn7YwC4sw4D1kHojmDWd7YU6Na89+glhPtzPdIpk8nv8N94+V80U=
X-Received: by 2002:a05:6e02:12c2:b0:374:9c67:1df6 with SMTP id
 e9e14a558f8ab-3758035fd9emr20660145ab.22.1717743006285; Thu, 06 Jun 2024
 23:50:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 7 Jun 2024 12:19:55 +0530
Message-ID: <CAAhSdy0wc=e5LW92Y7YdK6Bi0cxk6C1EhSyv5vMo1FxKMu_CpA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.10 take #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have one additional fix for 6.10 to take care of
the compilation issue in KVM selftests.

Please pull.

Regards,
Anup

The following changes since commit c66f3b40b17d3dfc4b6abb5efde8e71c46971821:

  RISC-V: KVM: Fix incorrect reg_subtype labels in
kvm_riscv_vcpu_set_reg_isa_ext function (2024-05-31 10:40:39 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.10-2

for you to fetch changes up to 0fc670d07d5de36a54f061f457743c9cde1d8b46:

  KVM: selftests: Fix RISC-V compilation (2024-06-06 15:53:16 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.10, take #2

- Fix compilation for KVM selftests

----------------------------------------------------------------
Andrew Jones (1):
      KVM: selftests: Fix RISC-V compilation

 tools/testing/selftests/kvm/lib/riscv/ucall.c    | 1 +
 tools/testing/selftests/kvm/riscv/ebreak_test.c  | 1 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 1 +
 3 files changed, 3 insertions(+)

