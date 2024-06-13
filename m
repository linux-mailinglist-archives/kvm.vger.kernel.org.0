Return-Path: <kvm+bounces-19535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 479379061AB
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 04:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE20D1F223A3
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 02:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36373BBF2;
	Thu, 13 Jun 2024 02:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByhECM69"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FED273FE
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 02:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718245172; cv=none; b=qJ0uVT4Z2faU119TfMlYG1MObPqKuRDxfLb4eXOjeForWbfiDrKO0krPB69fncceFvdQihANmzDD54zTRRvtwuarrTKL6KlloexYybKK6/iqQ8pwqZOo6ICfogSzurAv+K4PBxiGFqfrTBLBcpFTFqqMFNjhNqjM2DCCOpovTR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718245172; c=relaxed/simple;
	bh=Kzkz7pApI0GRq7MO7knaheaQFtLsC9P/V62xL9lt9QU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YkBxGZQn9MFx4Meuf+9J2RKNhxD0m8kDeGjgfdjoZxaOf8Xv/vaT2/HUlWW0FTrYR/TkvLjA3K+h6qB2DyzmwM8UyUXNQW6hYkdt3oJVzr/+3yCv24C1VUOez73ZsQnKhJ1BJOiccLKXYR81oWwY2GlhqpgYAgjzgJz+UAvNKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByhECM69; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-6818e31e5baso421999a12.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718245170; x=1718849970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YX0vNpr3em/rv49kKd8/Smcm++Isabu2iyiBzkTHd2A=;
        b=ByhECM699kkCSyq5rdH2ToPiyLvrscDD1RMS0k5+Nlkfc9BI4iLoMdkpMtXBa2TlsY
         5OG+sxYnvUrG6iFMBeN031c2YI+NqZAY1Vz2ir1qi+SABk3QXz6dwxZtCnPfqT2SWspO
         v/jJcSUhf1FoUJ9Pqa69w/Bf1avIsfkK6s9rUGtmTONu2NrvPJVNPVsU+oPwz5qzRwm7
         T3mUIMEhStGScBSvvEEIexD5G+sm1ACbya8su1JIuYGZ424Lfn25NjgIm0d4FB2hYd4m
         z0vqxFLktjjQrJkd/lI91zhdfyHqPypf3VHg7DPMeT0FqdziVkujiHUvmuKxGhla2lfv
         4ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718245170; x=1718849970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YX0vNpr3em/rv49kKd8/Smcm++Isabu2iyiBzkTHd2A=;
        b=LQnqfKyOCbAK4nx4LpY6EN7U/Km1zyuqO/1+NEa38cC285qFGC5DKU7bSsCCsJXLPl
         D5rmqH0FPWfiUJ/2Nvbl3v4sBT8dOksIlnwx8chyXQWmKMw5sqJkM9KB2AWCCue3VShJ
         WAf6iT0SMO/wffoqFfj0CBsW02/KvJ+zWw1LRgwXow/Dhf6jNcyxRw29xH9/r7eVGvv8
         OSTIB/5bU1/wat3tz4NgAhaPJjDP7/HJwo3r6GmFLi9L17A0J/yB5JULH8SlIeDdIl8Q
         ehSFRGMKd5cpVg9elejYC0u6mcO44KldvLFpUgjF0Mn/YpTWU2qKeqy1zIcPmtbjuIEN
         Jb4w==
X-Gm-Message-State: AOJu0YxF3KtrArolBCWwCGtP/Mu+PCmNYwSV6xyNboSGg2W9Thtj7Hg7
	3+9m/1K1dIOXZc0ZCoI5Qkl9xXwnd9EoqmlRJuONgQYtiFFfxmPXQAqebA==
X-Google-Smtp-Source: AGHT+IH74oCbIVyYCrYJQAL3G35Y4mHqE8+kqKgon8hQZPlfh2iwgY5Uj9l1Ha6wLaeqQ6Q9LkMB+A==
X-Received: by 2002:a05:6a21:920e:b0:1b2:2ed2:b80a with SMTP id adf61e73a8af0-1b8a9c82308mr3585389637.61.1718245169928;
        Wed, 12 Jun 2024 19:19:29 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75eea33sm2637940a91.24.2024.06.12.19.19.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Jun 2024 19:19:29 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  KVM/x86: increase frame warning limit in emulate when using KASAN or KCSAN
Date: Thu, 13 Jun 2024 10:19:20 +0800
Message-Id: <20240613021920.46508-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

 When building kernel with clang, which will typically
 have sanitizers enabled, there is a warning about a large stack frame.

arch/x86/kvm/emulate.c:3022:5: error: stack frame size (2520) exceeds limit (2048)
in 'emulator_task_switch' [-Werror,-Wframe-larger-than]
int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
    ^
599/2520 (23.77%) spills, 1921/2520 (76.23%) variables

so increase the limit for configurations that have KASAN or KCSAN enabled for not
breaking the majority of builds.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index addc44fc7187..2165262c1497 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -5,6 +5,12 @@ ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
+ifneq ($(CONFIG_FRAME_WARN),0)
+ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+CFLAGS_emulate.o = -Wframe-larger-than=2520
+endif
+endif
+
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   debugfs.o mmu/mmu.o mmu/page_track.o \
-- 
2.27.0


