Return-Path: <kvm+bounces-21908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE1B937289
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 722971C20E8E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2ECB667;
	Fri, 19 Jul 2024 02:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cf4hOQUq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7FC13B
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356798; cv=none; b=IjjZRSTXbDNxRHqozQTQNL3vXyRaHOJMXS+eMoM313mLSi3EMUlWaeUHLsNC2W8LHWUekkNRlwsthRny/+nWgFbIdn4liJhILfksOnA2whPlHEmFh4D1ZGVpRe+yrfZXoTLwXzexybNOVLTPXb38FGfnAwpJ2Lbc7k8yLTKBMZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356798; c=relaxed/simple;
	bh=FrqunzruvZqfCQ4DbX787556o7hPjSmdvMczfvumNPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HAbxqkV8UyP5nJwz8QpYkZAsRO8ikwh2Nl7mOZR1UqqirZkulppMhDKcffBZNw5KRoILybqY3YZcy6PsSJ6LG/sYljEYbwj8mZ9mg0jgWJHFSbHGSzgX6ILO7n2BXyUHm9KyhZ7AO/USOjmk2WyT4RpGxap8v8O/6kuaZn+0/RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cf4hOQUq; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-38257b4283dso7133005ab.2
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356796; x=1721961596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hmnGkOnWNz6hEvAEoNe9AfIun1EcbTOw7442bXW+lsA=;
        b=Cf4hOQUqrHpIuQdvZDram0lYQaPVs0AmRhkI5Ox2z9bA+pKfVRfrM50PXTOeb9fCF+
         nAS0aPT9TceSIDiJXlATCRezZmcheaj24DVOTWq9g9r1c0lyM/2mn5fbwz8k+fJPlAVc
         9GtPxQQPxcp5nazfFmwKEGN4OlrkADpzZL1oZ3r/MiZCn87t4+RBlgS0u+U7aWfTiHJi
         x9YRGoRKy2AMCtpUlWVC4im9y0PmaKgongJjykHAZQecZFUdUIkrix3GbNMd8hG7BngS
         +NsQyPZsLPtnsVqN9Ym0F2P+yK881nft9ebZBZM/jrtH1LVOulXZ4RRy3Mq6NV1GA2Im
         dCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356796; x=1721961596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmnGkOnWNz6hEvAEoNe9AfIun1EcbTOw7442bXW+lsA=;
        b=iEWB695E6H7quxKZq7opyHbspxjB1CmZdInLjzDCk20T7l/MD692QoI+0rMp6CiWDh
         yB4GPLpBw5985oZt3A3IJryAcDrROyPYfDc7uwv8ITJCI0zLw06st8k2QHP9uBe+/YjK
         Ks1SLZdDUiWpFgKh+DrvJIzK8eCUN9HuKcNqAyQDFccLZhmWlCL+fsOiTyQ+3ieDfRmj
         8Vf2ayTkxYvx2XPq10E7Xy/6mIzLRyYbS8/FcztPOyZISAdyMQ2+BnHfM6gnIUCXHzwN
         GprpJmJpZd/ZdN0W4eS1DSxk+jcTyn9bMlpPmohFBW+Q8/BGM+qb7NBwgtCSno88aaq3
         FisQ==
X-Gm-Message-State: AOJu0Yw7THqmVIUOwQ6rCX9NOoOYFbykhN0PKDPCeYTw6FIZnw4wGgcJ
	be4lOKIVMbM/vc1nsvx9lAZIxud21lQ2BTnRRy/nE4Cxo8MqomPmvYfmS6vw
X-Google-Smtp-Source: AGHT+IHkpraSB2pRQsKp1jnXMkpNygom827ppkHXIyJBu6UGKrY9zD8D4ZD70RWFWWjArZH80/Z8Og==
X-Received: by 2002:a05:6e02:13a9:b0:36c:4688:85aa with SMTP id e9e14a558f8ab-395558006aemr89087275ab.10.1721356796174;
        Thu, 18 Jul 2024 19:39:56 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:39:55 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 0/5] riscv: sbi: Add support to test timer extension
Date: Fri, 19 Jul 2024 10:39:42 +0800
Message-ID: <20240719023947.112609-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing the timer extension as
defined in the RISC-V SBI specification. The first 2 patches add
infrastructural support for handling interrupts, the next 2 patches add
some helper routines that can be used by SBI extension tests, while the
last patch adds the actual test for the timer extension.

v3:
- Addressed all of Andrew's comments on v2.
- Added 2 new patches to add sbi_probe and the delay and timer routines.

v2:
- Addressed all of the previous comments from Andrew.
- Updated the test to get the timer frequency value from the device tree
  and allow the test parameters to be specified in microseconds instead of
  cycles.

Andrew Jones (1):
  riscv: Extend exception handling support for interrupts

James Raphael Tiovalen (4):
  riscv: Update exception cause list
  riscv: Add method to probe for SBI extensions
  riscv: Add some delay and timer routines
  riscv: sbi: Add test for timer extension

 riscv/Makefile            |   2 +
 lib/riscv/asm/csr.h       |  21 ++++++
 lib/riscv/asm/delay.h     |  15 +++++
 lib/riscv/asm/processor.h |  15 ++++-
 lib/riscv/asm/sbi.h       |   6 ++
 lib/riscv/asm/setup.h     |   1 +
 lib/riscv/asm/timer.h     |  24 +++++++
 lib/riscv/delay.c         |  16 +++++
 lib/riscv/processor.c     |  27 ++++++--
 lib/riscv/sbi.c           |  10 +++
 lib/riscv/setup.c         |   4 ++
 lib/riscv/timer.c         |  26 ++++++++
 riscv/sbi.c               | 135 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 297 insertions(+), 5 deletions(-)
 create mode 100644 lib/riscv/asm/delay.h
 create mode 100644 lib/riscv/asm/timer.h
 create mode 100644 lib/riscv/delay.c
 create mode 100644 lib/riscv/timer.c

--
2.43.0


