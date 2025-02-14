Return-Path: <kvm+bounces-38151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22182A35CC9
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40DDF16AF8C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B83263C6D;
	Fri, 14 Feb 2025 11:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="uOhGvfFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9F82222AC
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533491; cv=none; b=OQ3uWXDxTNEQZe/6U3/PqCiPzo26x6ttzqDuuVgukS94rwbQBAFEeU6fuTjgRWa9QqJXdWMG7AaCJXcAhuCANIpfezrGSFyYfLAjPr8uoeOdL1iuikDCn0VURx9GoozG4YrqYfThs1GgmZyIOIQygt2Rt+Q3fkYib+0aLuDEAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533491; c=relaxed/simple;
	bh=iY011Vv+S7qjjLBC3d7BwPS5jFw4RQkprIFC8jvsx78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=agbanPnViuQxMWy321Ydi5vENv7HZRXkwFheVO9YFhJUviOqZYmHl3EiApOjPFuzUXitK9sEwxb2bt3TBKdmBiRnW9mrmmD0z0jpt+a9h0IWSigcGJA8smB9x0BGTmpKOdlOkFpv2z9krgE6qGKf84uyJh5k3Cubcz97WuN2vZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=uOhGvfFu; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f441791e40so2834082a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739533487; x=1740138287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kTZ1eswZXwVwVz8vwigYFoyZQAJNHhwum6Jps7FH7Ec=;
        b=uOhGvfFu4dy/SIjAF5G3IcQkQTxfMSeraVtgFOSx5ylefNWePo8vU2VdJw5u1/pgmj
         R8hsjZkW2NJVZ7oCyligMAEqVUVDGlDWNvGBvtnGbbCwwAWrRfy3DH0I9o1nekd4EWqV
         7qOqp60lDddi7hxzf169y/xe2LKkzPfOHEMR6t+B6KaOvpSsyNo6W1GE/X5LToN8s3cC
         Pde43PtSHxwP4cmq1jx+RqAbHua+18q/WEIZ0oAPC5sBiJQ5kNl7kfKH6UK92SLFqBLa
         ACNeKETy0dAeaSSH+MG3gbCjFj+B+R4YlICIR38TOaEy68DFC3Aet1n0ieCeYco6X0oJ
         38Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533487; x=1740138287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kTZ1eswZXwVwVz8vwigYFoyZQAJNHhwum6Jps7FH7Ec=;
        b=H9tg31Zh9uym93GyT5qa98eCzjfqWZc0XjtBrZeI6rf+pvNtYiqKlbEbd9bB24LpV+
         MNJG7chuxGsEF6HjhwGvWKZmAk2+EXrVLz8qJcJDLAq+ZcveokmY7GOUAvZZ2MqmywXx
         CQ9K26KyuB7B3mzuQdKqYvAAcLyLj6ODLendWlWMBA41Ll0CmZDr5TmiuwznlM65OVr1
         jEYqvdw/KzuRmgNrwJMK/0XUAklD2nyAm1Be9jJdrTXRM6HjZFVfHC8EfY/3/fG9Sko9
         Jlc1H/6jy4YDW93c58IBqU7J777Ri7DnuU1izMpAfi/o9mRr73BAdsGkFLK5AhjTwogV
         uyhQ==
X-Gm-Message-State: AOJu0YzuHfkecbZ7azujfOQ1+EWW0KWRXXbY3CE6vdiMy3MeEGv/zD9I
	5lXCK0zxFgTN7tWVvoHFHWIVSuyro62N34vMXTtu9t0GbIeEbNEc6vboXZfPWPDfAjq8p+cuFWk
	eBZ8=
X-Gm-Gg: ASbGncsLnb4EKOkh2yFxi2NQR/HX/cMciLJt0l3/wtJ9Jn9rtWVW49S4gldT6nGCVx3
	M0yfvUrac0dbUPGxymUsA+DM5WQId1REWg9XWMZyAhhsbfYrmK4o2QY2nsnsQeRjppZp2NXQCIt
	FHIPOI8T1kidSGu79e9W7wjcCT7IFk5Jlp8HEQEETU1VC051XYVfFSRQNxEtWIm/3R4yD2qAJ5o
	qeAi0unTuQ3YsN48ubO8/OX49bXN2JCsbD9hI/GFqKbkRPpTOz9u4zd8OMfymn0rMNU6/8kg0Fm
	F9bnq8tlx7eYh0dn
X-Google-Smtp-Source: AGHT+IHMJlRt+CJQtQ5FBvjSw8s0xL5dZPLJ6OoNwbaMnPzogi0MHb8vLEtn3RtAM95ptkeGqjkq0g==
X-Received: by 2002:a17:90b:2d46:b0:2ee:c6c8:d89f with SMTP id 98e67ed59e1d1-2fbf5c009e7mr19113938a91.14.1739533487435;
        Fri, 14 Feb 2025 03:44:47 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f6965sm4948862a91.29.2025.02.14.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:44:46 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v7 0/6] riscv: add SBI SSE extension tests
Date: Fri, 14 Feb 2025 12:44:13 +0100
Message-ID: <20250214114423.1071621-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds an individual test for SBI SSE extension as well as
needed infrastructure for SSE support. It also adds test specific
asm-offsets generation to use custom OFFSET and DEFINE from the test
directory.

---

V7:
 - Test ids/attributes/attributes count > 32 bits
 - Rename all SSE function to sbi_sse_*
 - Use event_id instead of event/evt
 - Factorize read/write test
 - Use virt_to_phys() for attributes read/write.
 - Extensively use sbiret_report_error()
 - Change check function return values to bool.
 - Added assert for stack size to be below or equal to PAGE_SIZE
 - Use en env variable for the maximum hart ID
 - Check that individual read from attributes matches the multiple
   attributes read.
 - Added multiple attributes write at once
 - Used READ_ONCE/WRITE_ONCE
 - Inject all local event at once rather than looping fopr each core.
 - Split test_arg for local_dispatch test so that all CPUs can run at
   once.
 - Move SSE entry and generic code to lib/riscv for other tests
 - Fix unmask/mask state checking

V6:
 - Add missing $(generated-file) dependencies for "-deps" objects
 - Split SSE entry from sbi-asm.S to sse-asm.S and all SSE core functions
   since it will be useful for other tests as well (dbltrp).

V5:
 - Update event ranges based on latest spec
 - Rename asm-offset-test.c to sbi-asm-offset.c

V4:
 - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
 - Add proper asm-offset generation for tests
 - Move SSE specific file from lib/riscv to riscv/

V3:
 - Add -deps variable for test specific dependencies
 - Fix formatting errors/typo in sbi.h
 - Add missing double trap event
 - Alphabetize sbi-sse.c includes
 - Fix a6 content after unmasking event
 - Add SSE HART_MASK/UNMASK test
 - Use mv instead of move
 - move sbi_check_sse() definition in sbi.c
 - Remove sbi_sse test from unitests.cfg

V2:
 - Rebased on origin/master and integrate it into sbi.c tests

Clément Léger (6):
  kbuild: Allow multiple asm-offsets file to be generated
  riscv: Set .aux.o files as .PRECIOUS
  riscv: Use asm-offsets to generate SBI_EXT_HSM values
  riscv: lib: Add SBI SSE extension definitions
  lib: riscv: Add SBI SSE support
  riscv: sbi: Add SSE extension tests

 scripts/asm-offsets.mak |   22 +-
 riscv/Makefile          |    6 +-
 lib/riscv/asm/csr.h     |    1 +
 lib/riscv/asm/sbi-sse.h |   48 ++
 lib/riscv/asm/sbi.h     |  106 +++-
 lib/riscv/sbi-sse-asm.S |  103 ++++
 lib/riscv/asm-offsets.c |    9 +
 lib/riscv/sbi-sse.c     |   84 ++++
 riscv/sbi-asm.S         |    6 +-
 riscv/sbi-asm-offsets.c |   11 +
 riscv/sbi-sse.c         | 1054 +++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c             |    2 +
 riscv/.gitignore        |    1 +
 13 files changed, 1442 insertions(+), 11 deletions(-)
 create mode 100644 lib/riscv/asm/sbi-sse.h
 create mode 100644 lib/riscv/sbi-sse-asm.S
 create mode 100644 lib/riscv/sbi-sse.c
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/sbi-sse.c
 create mode 100644 riscv/.gitignore

-- 
2.47.2


