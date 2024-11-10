Return-Path: <kvm+bounces-31389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D70DE9C33EF
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 18:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CC27B20E3B
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 17:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4840713775E;
	Sun, 10 Nov 2024 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sm7VujVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186D44B5AE
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731259015; cv=none; b=eBIvkeIdUegsNqL+RIur721COwxNtmmBcw214Fa2vAnZdFjyj7w8UiUqp1SIRshGzFHm6Iwjh0zhjSnYblex6rgdkZF8/Op5dzE+i9XeLLN/NMRmig8I4WlSpxyXTvqmXD1WaxDniE8LE7r1MEbtJQP6qpgp2eMHsjpFcGPzy88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731259015; c=relaxed/simple;
	bh=4uLniEkMEA6mdxodTqV3Eta29qghXq6r6dcp3XphqMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hPdTuizI5rKqqy95jjPPSwr8xcSHCSuOh03Vx+C+G/9vTuLhCXoVlnKFzUWddBe7THnKJStxV0VxzHLvdmuulIDpS7pEboAEzRqbZBwI3eL9kNAHGlgn0xLyrQVv37eGszCphTB+R+17wqpiid8LsKN1ClDQp3ileLprWQ6yvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sm7VujVu; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-720cb6ac25aso3448750b3a.3
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 09:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731259013; x=1731863813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCCoNTQwwcDguEq3XP3suaGgR9K6ba2ktOXnBr/d6YY=;
        b=Sm7VujVu4ezMnB56Shyyq8rUdffdQtxGUke4Pa7Fol3ysPwFSJsR/yQQCiE5qgLbEG
         SjX+rc/AxPjiJnYWcrTkPTMqU6AtYt1kmdXHGnYNlag2sTEbyec3VdMwIXvQbuOMevVQ
         xaxFdbDjA5geS8RDrC6gfnkZiALG57Dx+sjxpFXPzR24nf+K4Q94aT3j9LqDMkJKG4wZ
         rVW69pYIJOBcc+b7Q+nz7lhG6j9djp0MfffY1IM6MheGC5frCmIcCEoGIx0WdM7jof8e
         M99D/mMDqY/l/P8frFSQ/FrzUZj6d1J6Gp8x6ycpjntyxx6kEj3gmNaMmP/DY37/+cAi
         wRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731259013; x=1731863813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZCCoNTQwwcDguEq3XP3suaGgR9K6ba2ktOXnBr/d6YY=;
        b=rrIhRo9tZQZhqDC9DFQSEd5dsNCIY9kBa305zgTz7nWleCaz4kv7c7bq+ej5Wo5ZS7
         0YM3nQpvsuFpti3yjDZgj63LqhtIY4ze3u8XQL4BNosUkyp5SA2B4QC0AJNT/JhFtQCz
         l0cC1jtMt2BaH3nxfC8i2qX5pusMf6cwwVcwNHYj6G5nz2e6kz2CcVveddGoXtA7v1NK
         qloDJkhfvmo9JMAtWp0Kjq0cqMA0CnYq3Zx0bvWD5ch6IxGDub5eAC2CBj5qxsWf+uGb
         7s3bfuElq0PB3mHXQeIBjGECm1LUp8joNtvVNrDht9lFBHpuIibnVTuJyR7wCttgQ09t
         91/Q==
X-Gm-Message-State: AOJu0YwZQCDkRtUxh1CpzsvcuR8YsGV/+4W1yrBftGZ1TOps6M2/jt6f
	1uBuCPUAGErKM/fP/R5NbwLJkEXkJiHkCiSIBXgVPLAX8LJxwzuDESnNjoZU
X-Google-Smtp-Source: AGHT+IEBiVfip7v0mmbZOhJon3GVzGyCgLC+LSM84N9LfeypvBBj6i6P9oA2LSCNerQUJMMKI3twGQ==
X-Received: by 2002:a05:6a00:4f8c:b0:720:2dbf:9f60 with SMTP id d2e1a72fcca58-72413349738mr13531476b3a.16.1731259012961;
        Sun, 10 Nov 2024 09:16:52 -0800 (PST)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078641a2sm7578415b3a.20.2024.11.10.09.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:16:52 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v7 0/2] riscv: sbi: Add support to test HSM extension
Date: Mon, 11 Nov 2024 01:16:31 +0800
Message-ID: <20241110171633.113515-1-jamestiotio@gmail.com>
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
in version 7 of this series fixes the entry point of the HSM tests,
while the second patch adds the actual test for the HSM extension.

Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

v7:
- Addressed all of Andrew's comments.
- Fixed the entry point of the HSM tests to follow the SUSP tests.

v6:
- Rebased on top of the latest commit of the riscv/sbi branch.
- Removed unnecessary cleanup code in the HSM tests after improvements
  to the on-cpus API were made by Andrew.

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

James Raphael Tiovalen (2):
  riscv: sbi: Fix entry point of HSM tests
  riscv: sbi: Add tests for HSM extension

 riscv/sbi-tests.h |  13 +-
 riscv/sbi-asm.S   |  33 +--
 riscv/sbi.c       | 613 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 642 insertions(+), 17 deletions(-)

--
2.43.0


