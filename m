Return-Path: <kvm+bounces-26275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8882A973B3D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22E58286713
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766991925B4;
	Tue, 10 Sep 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBSvgYY4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620286F307
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981344; cv=none; b=XEWZVf6KxHR8+5eB24vHQtmWNF4u1IT0Kp7rpTLGliNeNdZs/y4efAxIkryblXiiK3TUg89jETuel9SAcHqCzlJYxSiAEhtJFj5gxS2MwSQhx884I6jV3wXpvHpoVo9k5ore0KsdK0DidCgNDD/ldngMQP3xOWoPyaki7Gn97rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981344; c=relaxed/simple;
	bh=FCihb4v/TW7qmUfCVUu5HUXdnVK/m3z6kcsjKXjmsMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suxvfLIWR1y/MUTv7iTT2g+Ne0ZwUxOOIwdSSu9zK+I8JC1raqcLO4R7UzV4LJkk96GhtiXfLpwf4pd3fNJtRsNH23N+82bMN/1MWc6Czt+aKxJpK0os2vcKm6FvbmjWqQFh8siewISXOTp1/T8NZOEokb+loFFZL0ny0p4UZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBSvgYY4; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71798a15ce5so3661514b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725981342; x=1726586142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6llRd5YGnpRMBaOFuvyytQmgOE0R2cQ5TnKEEesWoM4=;
        b=UBSvgYY4hbTGby5hmUXTRk59DZaa+ppPc+k1tzdAjkDUgt+01UdAp55RTGBFXMuAlu
         hTK3VNt6diN4BKykgR6kaaLpta3X6GLypiC4vSFlk+8J0hULK46HBv+3c00gWU2NLmkX
         R1UO+gBJlaLc+2OCwXT5Iag+QYIzxhPvGx4lwBCF9NnCB/AZ8ZYRqtqjwV0RjFJI3Q7H
         rsrWvATB9nGQ6zFRzWmXSKwhyT9F37I5PVKFa9xQBbQ1ePp0C7K+6uCp6HbX2sVZJvep
         CbKlLiD14KHAIxurz9U27/LaIZRTvPCe5+ZIrbFtIeKWqHdMFaq3B7joWEO8Skl1PuCC
         bzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725981342; x=1726586142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6llRd5YGnpRMBaOFuvyytQmgOE0R2cQ5TnKEEesWoM4=;
        b=e5Hosw6R0xyyYJat3Bgputaw5q7wWPmsZZS8wNqgxH0WZL6cv6r64WsO0I/fc3XYwI
         Ngt7YTWhy0UI0+FUjbnrQAFZOYVG70pLnJVHV83WwcWEgY4FiFq1WszrreEZvoP9rG+R
         9hHEVqTp51lVXtsiqwqkQhJvSqapgaRy9Is1z5MVa+ZCfcFSNWs5I/JOyDj2Qz85wXaS
         ilfQRK+r8/XxXAKYU0XvaPHBbpZivsh1mvLR0s1cefqFoBLswywldHXHtM8vz1cIO40p
         aj2sC4kSXR1nw182+rJ3PaECiVj3sYXwE3RByrwlBT8WtPCefhfAhSfLl/zaSZAdhrQ7
         zm1A==
X-Gm-Message-State: AOJu0YxFhfV1OxhLJOaG7veM3LwKFK0DzXVopKZPdDZ03GjJ99+4mFyu
	Ul6RFKKWCVcSFIbsWKxWU5V7PeXUKfyZYectA9o+cvQBFBi8KkR6+9Nusibd
X-Google-Smtp-Source: AGHT+IGYMBkHX3pl1Zig4WGgM/uel1hx9WEuqkg9jefzzi0yLjy0F4HgkPfp3NSobNwoX0Kmm+YRLw==
X-Received: by 2002:a05:6a21:398d:b0:1cf:3816:d104 with SMTP id adf61e73a8af0-1cf5e3cf5d6mr2072912637.3.1725981341942;
        Tue, 10 Sep 2024 08:15:41 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823cf3d58sm4939414a12.20.2024.09.10.08.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:15:41 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 0/2] riscv: sbi: Add support to test HSM extension
Date: Tue, 10 Sep 2024 23:15:34 +0800
Message-ID: <20240910151536.163830-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The first patch
adds some helper routines to prepare for the HSM test, while the
second patch adds the actual test for the HSM extension.

v3:
- Addressed all of Andrew's comments.
- Split the report_prefix_pop patch into its own series.
- Added a new environment variable to specify the maximum number of
  CPUs supported by the SBI implementation.

v2:
- Addressed all of Andrew's comments.
- Added a new patch to add helper routines to clear multiple prefixes.
- Reworked the approach to test the HSM extension by using cpumask and
  on-cpus.

James Raphael Tiovalen (2):
  riscv: sbi: Add HSM extension functions
  riscv: sbi: Add tests for HSM extension

 riscv/Makefile      |   3 +-
 lib/riscv/asm/sbi.h |  17 +++
 lib/riscv/sbi.c     |  10 ++
 riscv/sbi.h         |  10 ++
 riscv/sbi-asm.S     |  47 ++++++
 riscv/sbi.c         | 357 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi.h
 create mode 100644 riscv/sbi-asm.S

--
2.43.0


