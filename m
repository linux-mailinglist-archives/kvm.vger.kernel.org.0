Return-Path: <kvm+bounces-21069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3479B92975F
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 12:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65A601C20B3A
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 10:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C9117C8B;
	Sun,  7 Jul 2024 10:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etLCclMI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB412B95
	for <kvm@vger.kernel.org>; Sun,  7 Jul 2024 10:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720347090; cv=none; b=MW34z0u32nir6jY/JEUl0H4YvGNDTpVrDO9GVGefNrvC7xfA6R/1tBilF4fAKe/KqyrAOmyvrchQI6XFpnVxVDA8Gq7ZFKErueL8SiqygeLjxFdOd+dBdwOdkQxwSQdIhxwKp6zQLd+bvCCp+iJkMQ5a2NcTuapt9DrNTGJN97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720347090; c=relaxed/simple;
	bh=6sZg0gvSuY2HV8yEbBQESnX9ai0NgQnsugoxwx4bGbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BmvpdBJUnmvWn2J3SQ9NUZMpos6BlkC7SpAVXJXeH14HnSQhSqI7NpkJ+VWtJyXgoDyq9XBF2bjoKQ+eM11rixMJLdGy39nxRy8bBofX4MDHLUlcJESK/pXs2mu5WXXMjqh+nnRleJ50Cn/pyFxc6T4bHhLoewopbxu+xrrQIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etLCclMI; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-70df213542bso1398032a12.3
        for <kvm@vger.kernel.org>; Sun, 07 Jul 2024 03:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720347088; x=1720951888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oxx0GPXArqHJsrfLWt/db20HCHRFAxKstk9cmz0CLpU=;
        b=etLCclMIvIXpI5BbTq82OAra9cf9hsy0FSCKsGKBou9/uLqXUhBFb9c9SxKFqmU0eC
         R1GnypnYOhFDUxKtPaLWGURuRAaF/KchBwnhQRF9aaRuhIdRqbrKatBPlParYUvUCEUf
         AnG63OtYsla3VUshPtc7l5fPEJwA8JAPfK73e1aTGkk6dgkrpKpClwtpUlkMjhD3NcVv
         wghjTwiIjYxWRDP2CbSttjcmSC1d67JMFGqMT+N+tGC9Jjgh8WeficeBmC4uX5sA/K9y
         2+RFqDvV6sftn8YKh/lapkYWrUb8zUXgDrFiz5Jre7lf9pCC8FadW0kcvBaQI5qpJ0Hg
         Okog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720347088; x=1720951888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oxx0GPXArqHJsrfLWt/db20HCHRFAxKstk9cmz0CLpU=;
        b=YSTGriGjWcoqALs0X/iHz+ZB1CV8V88SNRinyt3ViQ4OiVOUo27hN3cmJHRTUiqgCp
         vMlI2wjo9E8dswQp0H1f56vTBhYEbyjA6WPLzQZySSOZlb3dDB0WRtLFLGnP4w3/7bdO
         YM5hYi7nUJ7+faWnLAVWTpIvJlw3w3JQj+zR+ZeDSEnUH5RjvjskXpsJc7+Gw8KMODfj
         KYOq8RW2kRWztQGAw4kHC/evHmBZD+ktOWdpJuE3Mh0oBqC0Md4USPFLE3abSeUw51X5
         A+HBd3qfLKv2/ZdWyDWyUcMwHmlUAV9LOmiUtZy6sl96NnAhRntJ00SkIphFuI+Qv1PW
         6P6Q==
X-Gm-Message-State: AOJu0YzYRMLxQKRaGfl9GixdsbIDBN7kQuCZOGde8uivBr1DP8VvxE1o
	Pr0nr7rdBP5HGQnBtO1SjuDMwCaBm0qtd78n0zYZAXJHlGMnlFgeCjdNF+G4
X-Google-Smtp-Source: AGHT+IHWp98hJbkaJaoPDYh4YC1m9EO3WcsJ8b6HWsXlBCJFVjcjQVGaIVAEN6srhgAfR1NPlGuDag==
X-Received: by 2002:a17:902:e947:b0:1fb:5574:7554 with SMTP id d9443c01a7336-1fb55747accmr36331345ad.28.1720347087824;
        Sun, 07 Jul 2024 03:11:27 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1596818sm166648085ad.270.2024.07.07.03.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 03:11:27 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 0/3] riscv: sbi: Add support to test timer extension
Date: Sun,  7 Jul 2024 18:10:49 +0800
Message-ID: <20240707101053.74386-1-jamestiotio@gmail.com>
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
infrastructural support for handling interrupts, while the last patch
adds the actual test for the timer extension.

v2:
- Addressed all of the previous comments from Andrew.
- Updated the test to get the timer frequency value from the device tree
  and allow the test parameters to be specified in microseconds instead of
  cycles.

Andrew Jones (1):
  riscv: Extend exception handling support for interrupts

James Raphael Tiovalen (2):
  riscv: Update exception cause list
  riscv: sbi: Add test for timer extension

 lib/riscv/asm/csr.h       |  23 +++++++++
 lib/riscv/asm/processor.h |  15 +++++-
 lib/riscv/asm/sbi.h       |   5 ++
 lib/riscv/asm/setup.h     |   1 +
 lib/riscv/asm/timer.h     |  30 +++++++++++
 lib/riscv/processor.c     |  32 ++++++++++--
 lib/riscv/setup.c         |  24 +++++++++
 riscv/sbi.c               | 106 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 231 insertions(+), 5 deletions(-)
 create mode 100644 lib/riscv/asm/timer.h

--
2.43.0


