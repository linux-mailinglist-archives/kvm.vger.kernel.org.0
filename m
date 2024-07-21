Return-Path: <kvm+bounces-22018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1649383A9
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A10341F213F4
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB1F8801;
	Sun, 21 Jul 2024 07:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ea8m9qBa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B062EC121
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545572; cv=none; b=MAyP2rmD49ePtoe/2+rj3DVdV6PLHFLwXY+O5H7Cc5zqmq2laFDRMo61dWtQVDtaIafCIb9EJlMPFl2piflEk5Ohj/n/oKX7Vo/g/SVv89vZQxgzNPNFmPMl/egU6suw8PGI39a4RgXJzQUVbZFMPgClswZDF6hrjVTb63kebKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545572; c=relaxed/simple;
	bh=FTOh1B1vEMwLOcYWEvvA7QrQ5LM5sBJ1yzRIz/N0PQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSBgGo45iZ/2AwlQ+nb7XyES39cZwb/AID6Yl/pC7M6cCHi3473dcTirQct1NXxz4Ij2wNj4T4JnVwObhUeu+QSLvai7Th4orU6nX1HFSTLdacBQmFErBr7k9sYjaXQJFYmsTX+oJGXUlYpegVELUViqNMWJg8pwjWg//bc0sBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ea8m9qBa; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2cb576db1c5so1596761a91.1
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545569; x=1722150369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5HmkT9wrE6V5OowYrudVmGySa01YLFtM7R7zpFJZMVc=;
        b=ea8m9qBau/mCAmi91F/fjqA87MWVB3E61NeRaaK3yHSYSUYpRNAF2Zzb8XPX5K0klz
         5QwCYsxxzZCIZS2GIzRPCoiCYUd1BF6DcR1GtaQxXJHWnQdSbLOVxvaBwmanhDq+zleg
         EyCSM52XmjTad0TPdA6j7u1XzWpXeWBQAw43t9LOo8xSvjj+nYvdS3enh+fQPE0xuPyM
         D0T3RN5IJzzvJCrEH3ot0sGCizygKT47noFGxT+A4o2BMaICaI7DAKqm8GYTTJpleWrz
         YZBao5mhFe1gPoxqUqRUWk21+/p2f8mNMqo+gE+w3s/qJSsWCPuebLEAjSQtKi19Csdy
         NbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545569; x=1722150369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5HmkT9wrE6V5OowYrudVmGySa01YLFtM7R7zpFJZMVc=;
        b=Bnq/qORe8ai5Fzo9S9Gidhns012tkAhvUNtSrThDFobULWLDqbqseIsSEq1NwU0h6E
         ZrtuUspcDBmK7RfXxd6++WZTxgxk+G7BaORd3V6MYZEuC1b6B884uOYoOUzo4gB9lvPq
         OFRFqSi6gzUbb3yNDgrBeIQI/vlXC9K2ueun83E8uhAax6VOmmYDwV1UpZgxDSKtmEuo
         dJBt+QmZA6x0YuDZhH8fdAZCszejkawN+LiXOMw/VWGI3KKkTm3mQDMWLU7soU3FnWYL
         owtD1O2nIM2mO/WS6C9o3Miu0oe88zn64kzM6Tm4Ufg7FoE6lNztJovXUMgjCSzt1ssz
         lGvA==
X-Gm-Message-State: AOJu0YwdpjDewh0o0vdphRZOYTG8xFKXI7o2uya3v4CaQSu8aW38+woi
	VPvleG/3S8hEdJIC29BLE6nffz7dXu8LWc36mts5G7sr+5m1YuxLmYY8vuna
X-Google-Smtp-Source: AGHT+IF6S1oNRbUSkPiCg4II5096DTedhycW0dkbcWQsSYNTNd0D/8bX3m2o3gxlsdX8YHVWi+UVNw==
X-Received: by 2002:a17:90a:9e4:b0:2c9:aea7:614f with SMTP id 98e67ed59e1d1-2cd27434d26mr1274078a91.24.1721545568962;
        Sun, 21 Jul 2024 00:06:08 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:08 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 0/5] riscv: sbi: Add support to test timer extension
Date: Sun, 21 Jul 2024 15:05:55 +0800
Message-ID: <20240721070601.88639-1-jamestiotio@gmail.com>
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

v4:
- Addressed all of Andrew's comments on v3.

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
 lib/riscv/asm/delay.h     |  16 +++++
 lib/riscv/asm/processor.h |  15 ++++-
 lib/riscv/asm/sbi.h       |   6 ++
 lib/riscv/asm/setup.h     |   1 +
 lib/riscv/asm/timer.h     |  24 +++++++
 lib/riscv/delay.c         |  21 ++++++
 lib/riscv/processor.c     |  27 ++++++--
 lib/riscv/sbi.c           |  13 ++++
 lib/riscv/setup.c         |   4 ++
 lib/riscv/timer.c         |  27 ++++++++
 riscv/sbi.c               | 132 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 304 insertions(+), 5 deletions(-)
 create mode 100644 lib/riscv/asm/delay.h
 create mode 100644 lib/riscv/asm/timer.h
 create mode 100644 lib/riscv/delay.c
 create mode 100644 lib/riscv/timer.c

--
2.43.0


