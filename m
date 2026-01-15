Return-Path: <kvm+bounces-68152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 087A0D225C4
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 05:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8DF030657B1
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 04:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA0BC2C235E;
	Thu, 15 Jan 2026 04:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjBBA6I8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B297F2BEFE4
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768450316; cv=none; b=ea5Uvp+MbZkPY7wq8yoy1JoCzmx3diI3hniYOk5IpxUO4YSuBD9qlC2Nogb0O12Egbn1zXizCG8Id84EQO6ilMHO7X6GPeXk86hSfXiphw4ghQ5h40dkaZXnDPZtbjpCSC7ohfbRketnRfDii+F9i47Q8g8B/yZ1oiCrfYXWZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768450316; c=relaxed/simple;
	bh=eH05iNFww19kcMZ0contcs3Ur4Aq0Uioewvs0Ol8TEA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t4zFxxgMb/cAhizczu0eziEYJZrQnToI//TCQZNu9wV3GWQNO+QTy6T+Cti9XKTHFOWWrQi5MAXgbi5DOxmuG93HKAsUdauQ1E+IW2xZXdUhukqaoBR/B8PAASFb2pXbTpWrKIn7/5kQ+CET86UpdCE2sKjleul3xzUl44LOca4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NjBBA6I8; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-34c2f335681so222108a91.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 20:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768450314; x=1769055114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bInY6G+fRPU4N4S6clAbFXdycHArb+K858x2QHnaCgU=;
        b=NjBBA6I8zTjR+COaFg4APBqhFb9KxKXmTsf+mmmk029wc0laJtRNRxybaRYW2oeJwU
         EEDTvo/ZzKUloYLMqwLXvGpFDGMPor8ovCmtxWVppkMsEoEsQ/9N+qRnm09k6g1paFko
         XLz4u+PcEav30JWiCrBB9azJm2ktXvDL67a4BP8IyU7+aRfogXPVzZi1pGQ4sK8jk1lI
         iu//9GagC0pDm+FUr4gErOWug8JaQYZAD39sNL9jh2ANJH/7KB8ynKj8mBRyXkCCEVkJ
         eQI4aYYNPuYo2v/DIwalqjG+zEw8GPBu+m9lhQDECfmGqDhIWZOM/dd7U0EpDYdXP6nc
         yLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768450314; x=1769055114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bInY6G+fRPU4N4S6clAbFXdycHArb+K858x2QHnaCgU=;
        b=baQz4fZHXdvgbSlU3P1P8bABk9+H0SpHOyxWbgV2+8aqCdzcl0qAsZRsfMQIRPlU8K
         iFWf+bq3n2U0aHx1XZbSdTMJtrWe/TK9v/zheUAlxq1OHreAREKFcEB2Y+xZPzK6BnOD
         1qOdeya+HUt3U9kd/DG7gu08fH3fZYDYyEiNiHxWEYpmvKN3PI3kN/Kb2uelRN5LccyU
         +mMAEfEQQlZG8tKwEyf+uLpEC7jhbwWARVp7m+YCZVtnbhAQqp5gL0DaHqvF/Jt9bH7y
         so/dlEc3eetIThStGLPZfFLqNdPfkqC4jmQWTNS2Jy8tcY63fmPHw3M7nFLc1JDxai4A
         y1bg==
X-Forwarded-Encrypted: i=1; AJvYcCWz6CxWy/yILztNEHAXzrNzEfumSw4Q+Zhx7ZpO1h5hxF7z6BeoPm29DM0t2AL+vuwJA/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKSBgBK3NsPB8weWLD9raCoR3n9m8SCkzm/W1lBN40XBvlwYkZ
	52D5dBovk/+fbUtzpd4QpVbELfg3BB8aA2k8SXRdaQPZhz+RuRqgprkb
X-Gm-Gg: AY/fxX6cGlIFSK7IeB6TOUFqn7/sXFQKjieYvKG4Z8AjYGtcl2F8KT33vpKjiZ8ucjx
	5DTkLsbztyU4ioHHnYYlXRkn4tetRRM5R+VLdszoUoTjYOaLZeSRo6xH2wodMawZYtxNheICce8
	SzNJIvWije83zIrGRIZ8rNrn5GchZNWlhjI/p486jdzTpNYeZNQdLQV2deKvKqHtqhMqYWRtVbT
	XFmnGGP/pEL9RJ7BR+AjQV1wsD+BO/aIP3FKDQ9TqLzZn6m1RKkPmLTC7GGbKwuKP1IwcWAecjH
	JZY2S52rXLAveumw1qTRJSAxxtZGUZcqL1QMJcAR3n/4km2nNrqYFBDlTJPBKK0MLPlGCyYPoNI
	Ghd06rbX6p+KG/2H21QxwqkqLW2kCmTABdz1rD9U9dFUiZJqPDpLz/GVFD+897dZLTMevwrp0rf
	AJL/ioKwIwYJKSTy4PVPDPqxEaZmFkxr64vGl8Ed7OAe5PrdWQ
X-Received: by 2002:a17:90b:3806:b0:34c:635f:f855 with SMTP id 98e67ed59e1d1-351090bde3cmr5297541a91.7.1768450313919;
        Wed, 14 Jan 2026 20:11:53 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-351099e2fbesm1626399a91.3.2026.01.14.20.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 20:11:53 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <jiakaiPeanut@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH] RISC-V: KVM: Document scounteren and senvcfg in CSRs
Date: Thu, 15 Jan 2026 04:11:46 +0000
Message-Id: <20260115041146.807967-1-jiakaiPeanut@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiakai Xu <xujiakai2025@iscas.ac.cn>

Extend the documentation of guest supervisor-mode CSRs to include
scounteren and senvcfg.

These registers are part of the RISC-V supervisor CSR set but were
previously missing from the documented encoding table. Also adjust
the table formatting to keep column alignment consistent.

Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
---
 Documentation/virt/kvm/api.rst | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..6dab20637c7b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2837,19 +2837,21 @@ of a Guest VCPU and it has the following id bit patterns::
 
 Following are the RISC-V csr registers:
 
-======================= ========= =============================================
-    Encoding            Register  Description
-======================= ========= =============================================
-  0x80x0 0000 0300 0000 sstatus   Supervisor status
-  0x80x0 0000 0300 0001 sie       Supervisor interrupt enable
-  0x80x0 0000 0300 0002 stvec     Supervisor trap vector base
-  0x80x0 0000 0300 0003 sscratch  Supervisor scratch register
-  0x80x0 0000 0300 0004 sepc      Supervisor exception program counter
-  0x80x0 0000 0300 0005 scause    Supervisor trap cause
-  0x80x0 0000 0300 0006 stval     Supervisor bad address or instruction
-  0x80x0 0000 0300 0007 sip       Supervisor interrupt pending
-  0x80x0 0000 0300 0008 satp      Supervisor address translation and protection
-======================= ========= =============================================
+======================= ========== =============================================
+    Encoding            Register   Description
+======================= ========== =============================================
+  0x80x0 0000 0300 0000 sstatus    Supervisor status
+  0x80x0 0000 0300 0001 sie        Supervisor interrupt enable
+  0x80x0 0000 0300 0002 stvec      Supervisor trap vector base
+  0x80x0 0000 0300 0003 sscratch   Supervisor scratch register
+  0x80x0 0000 0300 0004 sepc       Supervisor exception program counter
+  0x80x0 0000 0300 0005 scause     Supervisor trap cause
+  0x80x0 0000 0300 0006 stval      Supervisor bad address or instruction
+  0x80x0 0000 0300 0007 sip        Supervisor interrupt pending
+  0x80x0 0000 0300 0008 satp       Supervisor address translation and protection
+  0x80x0 0000 0300 0009 scounteren Supervisor counter-enable
+  0x80x0 0000 0300 000a senvcfg    Supervisor environment configuration
+======================= ========== =============================================
 
 RISC-V timer registers represent the timer state of a Guest VCPU and it has
 the following id bit patterns::
-- 
2.34.1


