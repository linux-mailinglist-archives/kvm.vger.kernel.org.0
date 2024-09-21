Return-Path: <kvm+bounces-27236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FE397DCCA
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 12:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06FD01F21E43
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 10:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1621155753;
	Sat, 21 Sep 2024 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hw165lF8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FB27462
	for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 10:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913314; cv=none; b=iHnCH+eF4o1RpFQjMVtewfvMqvgRra+iwwFRishBygGwJ7mphViVqwfrx0a14D8ku6Lup5CMS+miTzxK4hW6kudCsrihvyNY9rZcwj8aTvOFVUom8tF/h2OmcY69ov5p+7q/CjEzh0jzJDJSFTMbbv4IPIW069AM+fcnDT4zCKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913314; c=relaxed/simple;
	bh=mxuei631pe7B8nmFMueJPo8CAE8VPHrh/P9UxTtUrNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jZ1uFIgxpmYBJo8T7cZPitJvS6M7WmeOHsimymXh6E2jB7csx1FzZf8+SU0Wpc5pkvEDRW1KSFivKCJASJ29ZfQ4XKk0WBuUYSEgA35iPIyEWK1KazDwr/PnCAbU0qvfsRpN2m1M0A5X6XiqD2TonW/pgQRi02FtJSkquVjovLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hw165lF8; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d889207d1aso1919610a91.3
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 03:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726913311; x=1727518111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SKva7RlCqQZ2MXf5pOFSSaF9wJRznzP7DJJaNe+F4+E=;
        b=Hw165lF84ccUxj5gXKtyk5bCG5TjZ4nXclHJbWrLxEiJJLosJSzVZvV8AJ1StMk2s5
         bPRpqOCmgt/TUrLQdadorggkU6vglojD/bHq+wlvuo6STGWPWAyPx+WIUHaXaWg7hXtn
         G/FwqQvn1JSHtKFBtAoJekV1lBFnq87r6xum9qBdiADmE4ByN7b6j3PfZcRelmFElkiz
         DERfTNEtGBHSzVJkGLGGRzTPQ0TGO4fKJJ6ZbVU23GB8DWPgrN2yMQdzfPQ9NUCMdf6+
         rx2kPBXHJ/YPex6DMz7FyFh9VWvvnanWj0cDI+lRx3CE6A2wrQTkHspHSkhBfDhzDH9p
         Lqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726913311; x=1727518111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SKva7RlCqQZ2MXf5pOFSSaF9wJRznzP7DJJaNe+F4+E=;
        b=LcXFVpa38rkMngc6PMio3Sre3JOudKDlPqYJhnnZ6y1cU9XkltuvcZELb571JSljGq
         u38sStRT6Qc55PpAo8vDjSG4WZAXVTHzlbVjGTsq5geAoKfuPYv7C1ysMTA/GGCnyAFj
         T/Vm6jiBUC+yPRpIdPabOOZ2S4Oo1Bi7dZm8lVUiv6Vuy7MhUoGirfM4LpouTwqBBUx8
         96CwTPJUoQd6cBHR3kjAdUAlPW52p5xjYIwXvX/bv44lunYsSJp+oJFRAf32ZUknDkGT
         7trjNja5/ypKNgxnbhbbBzpzdVEtMQwKrF/Bi/iWrkctgJvJjmDkNO9yocfWPrwMFevd
         mePw==
X-Gm-Message-State: AOJu0YzCLCkWY8as3PtbY3FFBdICGGIYbPRSKJkcjqDtq448/DYyED5L
	pidRRi8DUjM+Mh0m0Yfe1AdphZWlP2rLy8Px9+VbkhoT+hifQibaL28G1zUo
X-Google-Smtp-Source: AGHT+IFLCmNZ/zJtryHmu1Hz+SWYXSnggmnPdqwWzoPptjj1iapHdXDj268pF2RXZ83TsZdsMLty4Q==
X-Received: by 2002:a17:90a:7403:b0:2db:89f0:99a3 with SMTP id 98e67ed59e1d1-2dd80dd5d16mr6631943a91.26.1726913311208;
        Sat, 21 Sep 2024 03:08:31 -0700 (PDT)
Received: from JRT-PC.. ([203.116.176.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee7c03fsm5680024a91.11.2024.09.21.03.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 03:08:30 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 0/5] riscv: sbi: Add support to test HSM extension
Date: Sat, 21 Sep 2024 18:08:18 +0800
Message-ID: <20240921100824.151761-1-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for testing all 4 functions of the HSM
extension as defined in the RISC-V SBI specification. The first 4
patches add some helper routines to prepare for the HSM test, while
the last patch adds the actual test for the HSM extension.

v5:
- Addressed all of Andrew's comments.
- Added 2 new patches to clear on_cpu_info[cpu].func and to set the
  cpu_started mask, which are used to perform cleanup after running the
  HSM tests.
- Added some new tests to validate suspension on RV64 with the high
  bits set for suspend_type.
- Picked up the hartid_to_cpu rewrite patch from Andrew's branch.
- Moved the variables declared in riscv/sbi.c in patch 2 to group it
  together with the other HSM test variables declared in patch 5.

v4:
- Addressed all of Andrew's comments.
- Included the 2 patches from Andrew's branch that refactored some
  functions.
- Added timers to all of the waiting activities in the HSM tests.

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

Andrew Jones (1):
  riscv: Rewrite hartid_to_cpu in assembly

James Raphael Tiovalen (4):
  riscv: sbi: Provide entry point for HSM tests
  lib/on-cpus: Add helper method to clear the function from on_cpu_info
  riscv: Add helper method to set cpu started mask
  riscv: sbi: Add tests for HSM extension

 riscv/Makefile          |   3 +-
 lib/riscv/asm/smp.h     |   2 +
 lib/on-cpus.h           |   1 +
 lib/on-cpus.c           |  11 +
 lib/riscv/asm-offsets.c |   5 +
 lib/riscv/setup.c       |  10 -
 lib/riscv/smp.c         |   8 +
 riscv/sbi-tests.h       |  10 +
 riscv/cstart.S          |  24 ++
 riscv/sbi-asm.S         |  71 +++++
 riscv/sbi.c             | 651 ++++++++++++++++++++++++++++++++++++++++
 11 files changed, 785 insertions(+), 11 deletions(-)
 create mode 100644 riscv/sbi-tests.h
 create mode 100644 riscv/sbi-asm.S

--
2.43.0


