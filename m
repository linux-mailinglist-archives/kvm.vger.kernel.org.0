Return-Path: <kvm+bounces-20376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5335C91440F
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E58328173D
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EAE49625;
	Mon, 24 Jun 2024 07:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m39zAjLS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041744C9B;
	Mon, 24 Jun 2024 07:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719215961; cv=none; b=ObonzwCe94kHM2xu9CVnblVDw5/mbQQElUYYE7JfkWe7eJGbE0W2WTizVKeirjC4MieKSz6wsguYUYH1lYFZ0KukvJ5KVMii1/0/7qL4y7ltkX5fk6YYhFBFaqEokWoX7QnB3/ArnI2cZaed1tF9GsljMvBl4LOq2nIGeh0plnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719215961; c=relaxed/simple;
	bh=QntOMA/EaWu3YyHYV9Nv3W9AgkqJjlizJ596FnHTCNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=alOLewGd9iGRrnqDc2VSgXxM0JNRuEAehhllrWWUExLl5gWgHOII1pdf2O3ZxvOshtnBT2W51ttwrGQ93rsR2eTBMn1XTfD6z2DyBFU+QJ5c2YBlMlge9rQk7+aMUxgvz98zkuKqYTrO9nB4EZWrA8U4sABGOWb/Lhy4b/w7xFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m39zAjLS; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70673c32118so780467b3a.3;
        Mon, 24 Jun 2024 00:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719215959; x=1719820759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kzXc1XEvc7I6+EQc2welv6znEDHAmFhzo0VrZbtQ65k=;
        b=m39zAjLS8D6WYT6MVTSOoBFVdnzR5W7Mnri9yb5zqP2XSS1ezsS5j3vh2cdKDcowrC
         1lcuDIOF0dh1exg0mbjTk/ctBhQcvBbD3VAAUd+llZGAcSwYsvTs2o32XdMUDlZ1E7Cx
         uCLq2TByFc7qZ8vx7A4tkVa7wixZliWV1/nY/etOWs55hojJ4PwJibWwZpjyOqIrjWrd
         iPkpRjBNlj6E8GBXXHuaOwO9ImNkmuU1Q4QBoi54IRQyqfAJmHh9Hu/kQe2pMQa5ng85
         kAZNDB4kprP7x6wXjGfsb5nFeAsmkGVeMcR0G9OHAfQB3tRqu921u/jA8iWAizJiz6CU
         MfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719215959; x=1719820759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kzXc1XEvc7I6+EQc2welv6znEDHAmFhzo0VrZbtQ65k=;
        b=ryq1L9iYv46zErFEWDROMSzvjaeVihCya5nnMCZsCK3Hj/sY2MkvH7Z1iMPnuoAc4s
         dcXPRFfEofZXJI0W85dC4D4eAYMTLvmRlL5WYTBb3kr0GVqUlH1P24OjDKT8pDgwiXKP
         WIdlgbTePIQu2eaxLkIZ+ozZQwp9CA0dwYW44gTSlVMtXILVjm14uHfCqTM1DryPRzBx
         f5sjWHPTtLjMlicvcwc1ewbKSn7EndU/pQgpPbMW26aAEJhwsYtBCaRjHb4+T9mMtHGO
         6//MRbYDG3wwNGv7G6q9TimKE76rE/tgDjq6EvDQP98uZNceX1+Ud8P9LznjGvi/R1b+
         tteQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE4+ezwwNMrjIZ3+I/CGTaufrFphRBtGa5Zjhhwdg3euRS6mE8HCobHC5vlpjqRYrxHWCNDD01Vz4YFKRV3ddi46bt5425DNhJZxIGk5wVMSIP2RGkPQn27sjbsG5r1JLt
X-Gm-Message-State: AOJu0YwJz1eaBUULaKmjVY4uyxTLnGgxqws4iquDohn7aF23YUh9g7Zu
	guW5IJXzlDab7R5FGOKt+gvMmu+GxGBvJ7lRr+15fOrfeqTBg0NgXK/gyA==
X-Google-Smtp-Source: AGHT+IEir6yYTOYhpeuMaCrSh2h0bZVTgDMe4yTSTENkJ44ehqWjRYb9y7g9NK8KazdPzT3tww1Dsg==
X-Received: by 2002:a05:6a00:2389:b0:705:972a:53f with SMTP id d2e1a72fcca58-706745bbd68mr4264360b3a.18.1719215958847;
        Mon, 24 Jun 2024 00:59:18 -0700 (PDT)
Received: from localhost.localdomain ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065107c446sm5588834b3a.37.2024.06.24.00.59.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 24 Jun 2024 00:59:18 -0700 (PDT)
From: yskelg@gmail.com
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: MichelleJin <shjy180909@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <yskelg@gmail.com>
Subject: [PATCH] tools/kvm_stat: update exit reasons for userspace
Date: Mon, 24 Jun 2024 16:58:21 +0900
Message-ID: <20240624075820.71583-2-yskelg@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yunseong Kim <yskelg@gmail.com>

Update EXIT_REASONS from source, including 2 USERSPACE_EXIT_REASONS:
'KVM_EXIT_LOONGARCH_IOCSR' and 'KVM_EXIT_MEMORY_FAULT'.

Link: https://lore.kernel.org/all/20231121225650.390246-3-namhyung@kernel.org/
Link: https://lore.kernel.org/lkml/ZbVLbkngp4oq13qN@kernel.org/
Signed-off-by: Yunseong Kim <yskelg@gmail.com>
---
 tools/kvm/kvm_stat/kvm_stat | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 15bf00e79e3f..eec6c00e3ff9 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -288,6 +288,8 @@ USERSPACE_EXIT_REASONS = {
     'RISCV_SBI':        35,
     'RISCV_CSR':        36,
     'NOTIFY':           37,
+    'LOONGARCH_IOCSR':  38,
+    'MEMORY_FAULT':     39
 }
 
 IOCTL_NUMBERS = {
-- 
2.45.2


