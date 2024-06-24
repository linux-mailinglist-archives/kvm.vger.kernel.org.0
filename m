Return-Path: <kvm+bounces-20346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 626F5913FB6
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915E81C210F0
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6930520E6;
	Mon, 24 Jun 2024 01:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8AO/qkT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCD4637
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 01:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719192027; cv=none; b=XdGZ1Z9qioWmFnuifX0wS8AtWM3PZLD6nNUUrzFF+VvMzB2VuuZBkeVoNtH9Ios2l3ngNoXE5gkT63XzsZ0EDv0kJdgyEg2ojc8jU5tcGLcOyNEpJUgwxdT9HaJ2C5LmAI8a6u07tUp/hqBW9lDfr3PbHN52Byu8Mxr3e/Y3asA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719192027; c=relaxed/simple;
	bh=AqZS12p0pCfFCDcw5IVOYrLxiHSU1h+S4rzr84YCH/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k/n1GTeAZOyoRWmX1pBzttSmoOi5UOHsUBCSAU1Mhe0UGXcJ2FurF+9vndgUoVADf8NYRf+6mNo047lC+uuQueGtB9L3ljP8krVZmYsEb+7dZlrXDQA6t+Xbmg3OCIlr53W6GAsA61BIg+vhu/JUTIh/7uvE6QqQ7qL4zrDszdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T8AO/qkT; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f4a5344ec7so24730515ad.1
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 18:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719192025; x=1719796825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIzj2+D1l7YtaaPrg78cLRqK05CoqzttbdfF++Yg7ak=;
        b=T8AO/qkTJAkO5TyhSQLAcmOBO1+n6TFjeA/HbbeyzaIDe/xeLOnSkm9EOFTHJYMfgu
         VgIF22Z+vBCZazaaGUlPSP9JWXxzb83gu2CkIe6JaiI7IecOsJKN0WetsyKV33Ti/NYs
         zQRZ5gFAxV8HtzoxEFkUeidcu8IhmJS+cCUX1tqNnR+uOH0NvHT9BnwChvzRYzCZ7Cet
         aMuWbE2jOZ/JHJhGLldJOUx4qHJz5y/7pqWQValxahoC4znUPbv/bUGNJDVkEQOhy5/9
         vLOeOQ8j1pVvcjM/QZuhGv5+gswaJKClHozG/kM9PfVoVKMVvi4sxRHNn0lFzVf8NaZw
         wZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719192025; x=1719796825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIzj2+D1l7YtaaPrg78cLRqK05CoqzttbdfF++Yg7ak=;
        b=lsOjlNzBOhBkcDtsfnSySC1XMjcrr4SFQ0SmBSDPZzpodUNkAcSAUDCGiqCBv7174r
         7pYqt7QG8/6ClM/+Aaev5mgrOkofgX9eouKP4MqbVXE004epbqUYv6enNUYdRLnha/hQ
         6OvQVrlSlJ8ilPe7pEdYoEaknDwimgayea3JjEocJViMgxLiv7mFlSsNpO0rYP70WSDO
         VHdsYnF84F9cfSqSxtZ8zRvyq6BvOydD9C42OSODvoRfkwaMm8vE5q86oqHG6vSgnwDh
         eKnpB1iWb5iqbZWLSOxKrk5+It25V7uABNQWtusRWka/PXYlitjyLb4Psq0mBnRwkofF
         c9Dg==
X-Gm-Message-State: AOJu0YxNAjyDsjzweF2SVM7XerZUSLtKg2gvXcnd0kZTbGk21GAh39/+
	70AKApwGiA5tXdURWQh8MJ/s6ANKN5l1A4v5YWxRL1BNqSJp7IqRZlxzJA==
X-Google-Smtp-Source: AGHT+IFmlmc7mEENcuL+rNUjaUm1z4sv7i6wfNXSIExnD63XaCQN9nnY1RkxFtqHRKoBEB+s1kE2fQ==
X-Received: by 2002:a17:902:fc4d:b0:1fa:3856:7625 with SMTP id d9443c01a7336-1fa385683e9mr15021215ad.34.1719192025349;
        Sun, 23 Jun 2024 18:20:25 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9ebbc479fsm50657605ad.291.2024.06.23.18.20.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 23 Jun 2024 18:20:24 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
Date: Mon, 24 Jun 2024 09:20:16 +0800
Message-Id: <20240624012016.46133-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

Some variables allocated in kvm_arch_vcpu_ioctl are released when
the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0763a0f72a06..bfddc04eae40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5880,7 +5880,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!lapic_in_kernel(vcpu))
 			goto out;
 		u.lapic = kzalloc(sizeof(struct kvm_lapic_state),
-				GFP_KERNEL_ACCOUNT);
+				GFP_KERNEL);
 
 		r = -ENOMEM;
 		if (!u.lapic)
@@ -6073,7 +6073,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (vcpu->arch.guest_fpu.uabi_size > sizeof(struct kvm_xsave))
 			break;
 
-		u.xsave = kzalloc(sizeof(struct kvm_xsave), GFP_KERNEL_ACCOUNT);
+		u.xsave = kzalloc(sizeof(struct kvm_xsave), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.xsave)
 			break;
@@ -6104,7 +6104,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_XSAVE2: {
 		int size = vcpu->arch.guest_fpu.uabi_size;
 
-		u.xsave = kzalloc(size, GFP_KERNEL_ACCOUNT);
+		u.xsave = kzalloc(size, GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.xsave)
 			break;
@@ -6122,7 +6122,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 
 	case KVM_GET_XCRS: {
-		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL_ACCOUNT);
+		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.xcrs)
 			break;
-- 
2.27.0


