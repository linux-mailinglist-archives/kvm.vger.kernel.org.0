Return-Path: <kvm+bounces-50064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0588AE1AD6
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFA6B3A7ED6
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7952199947;
	Fri, 20 Jun 2025 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="e85L+wvK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA5221557
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 12:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421892; cv=none; b=W3lwxkt531efMBZel8DxFsixQHkEpLsWQ9CIcdFzk3OV5zy3yGHMiyYim/bJT2lTksq1GK/2N19Q1WMGJoNkzgoY2X9HJLRqCOe1j1ckV1l4fB/bF8Df9YZYOQVaZcXlIa0+9d/DQdt+ucfhRIAr6GUehcVVvDiENi6GGySsSi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421892; c=relaxed/simple;
	bh=U35tqQXhV1ZmiBtNlZQ10q7aVIhJBB6vIZfBILdU7Ts=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XX4sOOC2SUsQ0YPgUszHQdi9/+cLPVWQn/JrK4uGdeLYR+M2I05q5bkFWePWhmqubpDPoqFEgNvAvSoWZZFMVgbcF5uCufGdqiaBB59a1c0B7R8eoTqr/Zg+RXki3M3G0tZoIxVxRzbn9PabAhu5Mkk9MCOQEW3bi0N3ndhHDRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=e85L+wvK; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3de18fde9cfso7728035ab.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 05:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1750421890; x=1751026690; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4hugVmrBISDi3akfpzZfvuXIoYg3pJdh83x0txrI/9s=;
        b=e85L+wvKuL+4lK1tm02DeLHxFOZ1KJn0wb3wtZDuiZmRp9Cw3R/6Ziukqqo4eLXFxC
         IXAio5I8fraSHS6i0t1HhwlJ2I34aEVgTW+lJ7tvpl6AbickH5fbgMUTXiSVefWG3rbL
         EM9YM5/JiCtQtZT9j/0JkwUuPZZWYEph3hPvwd5QC2SyTTxP90jJni7N5zn46LJKvLLV
         xS2zUUEOd7gzQEvK56KFVCaAaxd+eP89VFQZw35u6lRkA4SLha49eeysfnTQrEyp4nEQ
         +iccmx63ekLykhUw8NdKv0Py51XcgmUHFYIzCT5obK161VQoTBgp7d83NYvlz5dfBx6Z
         tczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750421890; x=1751026690;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4hugVmrBISDi3akfpzZfvuXIoYg3pJdh83x0txrI/9s=;
        b=eY8tQjdzvBlYQ2qBPqntwvzaOXLgRpmNyfIkEqzFc1ZqfV5Lt7fqJ+leFCNK+ArbPn
         4S+fXl6xgJv4E5Un7he9my0ELnN4eML8jDdE4rZcCGQQ9T7KXiB3WFV6pTGdcJpoCJk8
         xPFsxUMg29YP3ANWRAmtfng5CxnLAIWeJPJJILXCICaWOHrpKGNZxPkxfCQ1rl5CsYPG
         qyhOJWvo249LGn6g/t5WxbWUbyfe6UkdeAmGhJq6mNp8SHhLRjd7GgXjKvjA3QSrR9A7
         2UliFhYWtJi1nfAeJafiOAmizwCh6paG6a7xNizl90+6y0sxCdZTCn6RfINe/seGb0rK
         1ooA==
X-Forwarded-Encrypted: i=1; AJvYcCUbULfTaEsYvzh2nKzqg2R4Ou5N50Wyc/kOM4DWfJxvvZSwXsO6JSSt4Rcj0/kUMpdfnzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX6YTnMYGoRxpJ0Chq/Q0SVde+RChwTfbWxL0nNLvJa66Lvrz2
	Efb8RrNvLdNFnW5OD+FxnXDoXHfnadZf+7XcHGcRAjVXEynZlnQtgmqQI6i9mBy27DifMWH+D0g
	pxXNR1YdzYE6eY+lGgbtbmoC5VbtcSwr9O5HGNnAq/85TErk6cWU2+E4=
X-Gm-Gg: ASbGncuFiML69VQEXOa8RH9waJTdAO9An5aBCv1cGFLS+e9fDDMJIdV/bLxaNMMQiTn
	6k4jLkBG/zpw5vWIRLpsBtUW152wyFB5A+uIlft3i9Cvo9AdhUPddWGStLoNwnS7gJNYJTjEcoJ
	wnVN97QRpVvluH8Bl55O2W0fC579sZg3TfqX46ifmPETY=
X-Google-Smtp-Source: AGHT+IGUKckbOdUcs/PEHFCfX8DaHeChlsAcllC9njuzBBFlcoE/j6rYlhRl0odIphq/zEklEHqkQQcRHcRFp0HVE3A=
X-Received: by 2002:a05:6e02:156e:b0:3dd:d7ea:ae4c with SMTP id
 e9e14a558f8ab-3de38cc75abmr25819005ab.21.1750421890334; Fri, 20 Jun 2025
 05:18:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 20 Jun 2025 17:47:59 +0530
X-Gm-Features: AX0GCFv5QmR6EhpuKEA0i5hObjxmRietKMEidwx9nwYmXTwXtzi8ut3dN43QQcg
Message-ID: <CAAhSdy2ZTWpx82buvGmcTp+0bXJCncQ8TCdmW7tCMC_P69GBeA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.16 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have two SBI related fixes for the 6.16 kernel which focus
on aligning the SBI RFENCE implementation with the SBI spec.

Please pull.

Regards,
Anup

The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.16-1

for you to fetch changes up to 2e7be162996640bbe3b6da694cc064c511b8a5d9:

  RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs (2025-06-17 10:18:40 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.16, take #1

- Fix the size parameter check in SBI SFENCE calls
- Don't treat SBI HFENCE calls as NOPs

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
      RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs

 arch/riscv/kvm/vcpu_sbi_replace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

