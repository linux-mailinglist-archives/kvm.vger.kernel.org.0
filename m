Return-Path: <kvm+bounces-38881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F03A3FD2A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2655707C63
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10B924C67F;
	Fri, 21 Feb 2025 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="TA/exw/C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514020469D
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740157676; cv=none; b=H7A26vK2IkKqWZVnxTLpQ4hzrH0aW0dEaFOm6v0HGE2lupkgUMiSZJc1tkqX5Qoxbn4+bqm+0hHa7uVXlly9oAc4mS/V1pBPcrP7ilXOHkALjd/MgckvPp49RyMBrarKILlda7GqOX2JFF9qF+vxBu6X5R95sYsjoaI1QkjY8MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740157676; c=relaxed/simple;
	bh=lY9CMNbXAHvzVurerM1ZSh2jzfXQVBN+2tpO4GQogA4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gCrwGLrdoJ+mVxl+4uc+2GRfBBajUv6y1SLPov6Jdt4Sdyq0w+8WproxJ1ZFTfUJGLRsOVIRnEWp7Zbq+wO5hGQX2bpI2BUiFRdcB8blzBjKTB2KKCmUPfOcJrKRcs/idWlMUzMFtoa7xfrDoGvPUaWs3A2oHzyLprWHIAwmEeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=TA/exw/C; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-855923e7f53so164727939f.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 09:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1740157673; x=1740762473; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CBn06bjrraG0RKUpLcfzoygq710m6p9nGy5k5/eorm8=;
        b=TA/exw/CmWSs1TY9Lutsy8TsVirlvd8U3M17f7xqgNnJAxsp5DFdbHeTx7HagbR3AP
         z/bWU4Sa8/yPZkeG3DY0ERL5vve0lvB3N91x49RuH+Z9tk2Vl262xwuq/FzKk/M0LGYG
         nuuPwcNg0tjp9NUSaYQwGNFVP4Y6ZCPsG1AoJ3XEUE+XA+vrgbHR/U3yIKQjDXW+H4su
         Ciq7UGMGCRGILJ0gc+LAiQQZhote6h4GRZhZebtfpDOAssd12s3rHOFQBBjKvWu7JJqL
         6fQii+Lca7KJKI5jhooQZflov+5a+BxUIBP7JKyde+QnJmKHDuA6aVOcXX8XkvZNFp7V
         l/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740157673; x=1740762473;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CBn06bjrraG0RKUpLcfzoygq710m6p9nGy5k5/eorm8=;
        b=ikkTCwvXPGTWfb0TL5bcDSlzMep53nMZ5DaF056+Rcq4PR54r6WsX6gARSUQn5vZQB
         63myaVO2uqpshYjPqmWR65OqvjNoT6EDUoon/IdPxfzcYEWtmGr2G1iRuVgug/ORQoR8
         t+w6bcBrvujaooxaXwcUA0FNcysJQvsFGUfvy/f4rZ6Y+4hxjWiOaaYqKil73d7bhI6G
         /fZR/vaKt2xc4JJxKcrVVNLevgbw/xVldfyJgs/wQFiAhbGJWsyJ34LSiP4jk57Ug3GK
         x5QjbY+cSqCEGDfGmcRVGYvF8ZdIZlyRQmIJKV+fdnwcsulm9voZyVhnlcMSBKT4cRD6
         24KQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8+hU9SW09+mRqzAAUwxGEo8qpPtQR+MfOeqjX6dNHXfQYwxNkrPQOdIH27+9eokEcVBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ6SJzw0F2855SUUKhwwqqiLTdDcUJzYv0fCjZYK2zniyON8y2
	qCQjuXRqiywwCxFOh4AZISsbKs+QpUrYIGoCyRrDbOCDmcmmkVzCQqxPYaPN7p8EJolDtEyHxvG
	vh5ygu0MezBJm1GvWn9HIcEt5qpv7l4jBmGyLYw==
X-Gm-Gg: ASbGncv/iBh+5DGzjwKTXsDGBm4bbADosYusdlrNfIhP0mghXkzFEi8O99FNlvxJoV2
	/e5fXzwq5fWNtLiunJ0JXX+eONhhul7YaEuQJtpXZG83b6SbFJV0vs4N3mmw4wQmfb8SaPsvzl7
	nAm0Zq6Uey
X-Google-Smtp-Source: AGHT+IGRxDMuamLyFFZPWt36k9Xy7MsZrVjV0LfEUgQJUkul59kYRBL0tFtgmbSG0/iAJTc+eQ8iAXGUsji68pO/JiE=
X-Received: by 2002:a05:6e02:1a67:b0:3d0:3851:c3cc with SMTP id
 e9e14a558f8ab-3d2caf19e17mr41489945ab.16.1740157673541; Fri, 21 Feb 2025
 09:07:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 21 Feb 2025 22:37:42 +0530
X-Gm-Features: AWEUYZlRnrCyat69poKdznrr9iSVNpvCW9gvd_ViAEmY7eEE9K8GiF7Y3M7YyjA
Message-ID: <CAAhSdy0Wo4hQ=gnhpJGU-khA4g-0VkfkMECDjnAsq4Fg6xfWjw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.14 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have a bunch of SBI related fixes and one fix to remove
a redundant vcpu kick for the 6.14 kernel.

Please pull.

Regards,
Anup

The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b64319:

  Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.14-1

for you to fetch changes up to d252435aca44d647d57b84de5108556f9c97614a:

  riscv: KVM: Remove unnecessary vcpu kick (2025-02-21 17:27:32 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.14, take #1

- Fix hart status check in SBI HSM extension
- Fix hart suspend_type usage in SBI HSM extension
- Fix error returned by SBI IPI and TIME extensions for
  unsupported function IDs
- Fix suspend_type usage in SBI SUSP extension
- Remove unnecessary vcpu kick after injecting interrupt
  via IMSIC guest file

----------------------------------------------------------------
Andrew Jones (5):
      riscv: KVM: Fix hart suspend status check
      riscv: KVM: Fix hart suspend_type use
      riscv: KVM: Fix SBI IPI error generation
      riscv: KVM: Fix SBI TIME error generation
      riscv: KVM: Fix SBI sleep_type use

BillXiang (1):
      riscv: KVM: Remove unnecessary vcpu kick

 arch/riscv/kvm/aia_imsic.c        |  1 -
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 11 ++++++-----
 arch/riscv/kvm/vcpu_sbi_replace.c | 15 ++++++++++++---
 arch/riscv/kvm/vcpu_sbi_system.c  |  3 ++-
 4 files changed, 20 insertions(+), 10 deletions(-)

