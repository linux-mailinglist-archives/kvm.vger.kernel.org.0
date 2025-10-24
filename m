Return-Path: <kvm+bounces-61015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 06210C06040
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 13:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 843F958419E
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D24314B76;
	Fri, 24 Oct 2025 11:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Ev0u13IB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732D314A97
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761304166; cv=none; b=IJroXVplD4VBj4cMNgsrm16HT4ih+c04iQSgaLmgD+ZJwUp8qHxTAWOaBX4ogzMaWEgzgQmS+tNbv8Z7zzekhS0KO8AAmAqftW7yuX95dt/knBUmVqy0K5g39xMUvzkGvyJozhlAaubRKPR3ecQAYFfmqlJve0lhLxJPCSqbcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761304166; c=relaxed/simple;
	bh=LZzaJXwy6MQC0Vp78nRcW0bToTYRUESvrs1xhTE+hAE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=J5s9jO3WJhdX58w69DqH0J8nDbgLFgpTji10XcLBv1ka3aGLzUudzmSp3fWSDKKCpFPE9RLRpr7bU3HvVUF5tNjgnasjXkIYvtBjVk3h/PIInVz5fCiyodj5hs/aBNXhvPNGH14IMwl7VxDFj5qf0NfsOid0LkrJlwq/79LXDrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Ev0u13IB; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-941073ba029so62074239f.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 04:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761304163; x=1761908963; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LcPf1xe975KkTwQym1prsVH0fr9QNq0CHIXhk6XtEBw=;
        b=Ev0u13IBI/P1r4oK0oYVSedJZkRYdKbwFonfnBxKB1FKU7u/2SQFyn4vEaY5KKp3SA
         8WNSQ50YwWZv37jWddLVDQY9aOLUS55f92NUfdLrdUcEzjK/R9aem8+XLqqHW67cebNd
         o6FD+4jgHA7XX8AAUGOTmf3GuiansZNd88jB2GW1Iydqqt6TwVznom4W0kSrZzuZelf3
         Ng+gTWQITp9FKK7ljIB6oXkPJHl5alLsxAv6urnS69wBSN65mp5zjRZExinKnApwBdB4
         O5PJEtVQaP9ZCEQycTjPJnbd8MJqZAujuiZpD5oykD8pC7SZihbB+bGPIlgnDadKZd6c
         nVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761304163; x=1761908963;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LcPf1xe975KkTwQym1prsVH0fr9QNq0CHIXhk6XtEBw=;
        b=KFkuZ6Py4zdenxVVc5AHic5qc8yjuuNa8txlCdLkCx0Glp+L8vpg1y4pUxEYcF7UI9
         F7zTC1kPEEbxOMSuGsEi8db64/0iewgRLj9E2djeBMTuz5I/TWt42H2Wru41yB4P1SPX
         RBbVuw9gAZ4DcZuqu/AmltKIUhRv6ZN8m7AQdT3sLc0EZ+onqXHyX3vBb4mo4tCX+L6Y
         vxyNMqq7XZ4IRcWeJTDbkMcTz0W8WTsNlByooUFhZCF+taYMhRpMSyG9h58m43rcwv5e
         65GfzXT2R6WyMcaFBPvn/YGriM4hfUWGzmdYmMlTnQYbHod/NnziIP+qniiOL4ES2SiA
         Q8lA==
X-Forwarded-Encrypted: i=1; AJvYcCXzm/Sxfacvfw+EM+1FeZSZH97YfGqxTML3LdVQJhNGBhD8oAboDSQr7FT0oH6IO0lTBY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZpNSJ3z4XReJnndChpFx583/w+WMIm7St+3j0g0PTBoTAoE2F
	ywxZm+cYxgSkJ2vNVAtlcfPVTpw4ZkD7IR/cA4m4Irp+axz9OCaW2oz954Fgoi7KVgiuyK/3Qn4
	yw4aa/p7cLh8kDBWB8pUXbdorSTHXtPhwZBxmZRZc6m9RNjyzLL+VCyE=
X-Gm-Gg: ASbGnctDDMIi3AVJEsRmybC5w/wDN6fl7/7MSSMVB2cjvYKWTwR7j3XnAurWHV/Z8if
	Xozavsyz3Dhz3xOc4V2Kx965w+ko7B21bOV5cflzIh4bAYTgziJhipOFFGCXy4F6e8pKsFU+qTD
	qkCV5YTdmRrSFAHrdt4E7u4AyXMqj9CfzuZXvUcHWxIQYEQv+YBsfg/bAqTTmNEu+P23BVyTM8C
	bUeAhgXmTQ0sf7+S98f7ZSDmzVWU53qfmwfqqN57K2IM1pp/C7fwCuox/tkJyNNIfmS1l6iU771
	+kVjeg8ssBD7MfqFMw==
X-Google-Smtp-Source: AGHT+IE9S5s0UiJpjlUqegYQjQVn8lw/UsvwYK6Cd4wO8TsufKol08Z/vDHJsXqyR1XkLmvB6hHPaBeL1CFs/wB1LTg=
X-Received: by 2002:a05:6e02:1fc6:b0:42e:2c30:285f with SMTP id
 e9e14a558f8ab-430c527dc63mr338209275ab.19.1761304163600; Fri, 24 Oct 2025
 04:09:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 24 Oct 2025 16:39:12 +0530
X-Gm-Features: AWmQ_bkOUC__8vbi7NySkF06VvUJXJfrGXIX8BYfIo-fPKn0s_ko2eOoKSV5lY4
Message-ID: <CAAhSdy0h=PuKTG=aWou_8y8qb7kSHS46TLXoXrjrTXN1xv-uQg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.18 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have three fixes for the 6.18 kernel. Two of these
are related to checking pending interrupts whereas
the third one removes automatic I/O mapping from
kvm_arch_prepare_memory_region().

Please pull.

Regards,
Anup

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.18-1

for you to fetch changes up to be01d4d5c30114e9df37fca9efbb2c5cb0ad36f6:

  RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP (2025-10-24
11:00:48 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.18, take #1

- Fix check for local interrupts on riscv32
- Read HGEIP CSR on the correct cpu when checking for IMSIC interrupts
- Remove automatic I/O mapping from kvm_arch_prepare_memory_region()

----------------------------------------------------------------
Fangyu Yu (2):
      RISC-V: KVM: Read HGEIP CSR on the correct cpu
      RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP

Samuel Holland (1):
      RISC-V: KVM: Fix check for local interrupts on riscv32

 arch/riscv/kvm/aia_imsic.c | 16 ++++++++++++++--
 arch/riscv/kvm/mmu.c       | 20 +-------------------
 arch/riscv/kvm/vcpu.c      |  2 +-
 3 files changed, 16 insertions(+), 22 deletions(-)

