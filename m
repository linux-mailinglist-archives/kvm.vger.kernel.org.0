Return-Path: <kvm+bounces-4582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA4C814E8B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:26:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17DFB286DEA
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685A382EEF;
	Fri, 15 Dec 2023 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="p8psqBNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EAF82EEC
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5c664652339so588878a12.1
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 09:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702660454; x=1703265254; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yLtSsXKTCLILvMN16fQqKt8fNEBsG0IfzY2SlDwuhSk=;
        b=p8psqBNwycEnNShr2A3EEQubP36erNhBxH8ZiniHyPeDmmKSdWyU05v+wEh/pBVABD
         MPhx+M08UwgW4u1dQOPTUboArBILONOeXAY2TvJoGmY1wm6febN/X2P1yebkMQZ16glk
         gC9dkX2Lu7TxKVRQWtAGbZSTVotwLWdtQRNisHbmcDzNmqTfYUsDk6o9IlYHaR/5ZBqK
         2XbckzJEJY0sb5xlnil5CEdWi4z/aVCGLqhSoHAwtpNeUhxQQSrBj/cHf87XTPW1Ugpg
         H3EdEPUIkSqSQYrUURsQVRes+bLICVAg3U3FgJ7FVeVlhhOLYXciRJxKB7DwBLgzT/kt
         3Gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702660454; x=1703265254;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLtSsXKTCLILvMN16fQqKt8fNEBsG0IfzY2SlDwuhSk=;
        b=lku3ngpPkknqvQl5LfPMg1gdU+Hk73Pf6M/zomF9TEOv0lHy8qJcbodI7gKpVPe+3B
         S2lhqaelNbzcMDiMWGuJIzrfciXbhkJIJoMTv2cvHvzKdNGB5krjgAwhpBB6CsvWVb7a
         gLxaPHOJk70xyROLsRfCAn0kR4Sk2hOHM3MZ0Q6lDFEd48JO2z2ya8CTOB7T8ux7/q/B
         kw3RQvaEpai5P86P8krMUQLxRRJ6U80xguF+8BVo4qE7M5aETJ7PGzfEp1cT1XAwIvSS
         BcIf1NKC+UhgRBAIxqoqPq4BsojjzE78vlD+tqDOEyuEuI3gn1wB8t85X3lL8kf9Ikf7
         Q0Wg==
X-Gm-Message-State: AOJu0YzJ0D6/jk4KX788g4cUFffTpMj/yn9/K9pWfsKPBY8HpRuAyONH
	a9s61VdYXSRkuZ1K3xmrjvk5f1hBYb+0zxWvpE74WQ==
X-Google-Smtp-Source: AGHT+IEbyKgx6IyVo+O/thicE6ukN038O+ZCGBqab4jLVgs86diNRbcckBMXey0NIT1euua6+wlRDimBw0fjAcalrPk=
X-Received: by 2002:a05:6a21:8026:b0:18f:97c:825c with SMTP id
 ou38-20020a056a21802600b0018f097c825cmr6008551pzb.102.1702660454232; Fri, 15
 Dec 2023 09:14:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 15 Dec 2023 22:44:02 +0530
Message-ID: <CAAhSdy3Rc+vub65qJ4JNngp5qTgm7YpsJCHZy+ff0=TN_ir03g@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.7, take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have two fixes for 6.7. Out of these, one fix is related to
race condition in updating IMSIC swfile and second fix is
for default prints in get-reg-list sefltest.

Please pull.

Regards,
Anup

The following changes since commit a39b6ac3781d46ba18193c9dbb2110f31e9bffe9:

  Linux 6.7-rc5 (2023-12-10 14:33:40 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.7-1

for you to fetch changes up to 4ad9843e1ea088bd2529290234c6c4c6374836a7:

  RISCV: KVM: update external interrupt atomically for IMSIC swfile
(2023-12-13 11:59:52 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.7, take #1

- Fix a race condition in updating external interrupt for
  trap-n-emulated IMSIC swfile
- Fix print_reg defaults in get-reg-list selftest

----------------------------------------------------------------
Andrew Jones (1):
      KVM: riscv: selftests: Fix get-reg-list print_reg defaults

Yong-Xuan Wang (1):
      RISCV: KVM: update external interrupt atomically for IMSIC swfile

 arch/riscv/kvm/aia_imsic.c                       | 13 +++++++++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 10 ++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

