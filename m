Return-Path: <kvm+bounces-29920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B92B49B40EE
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DC78283926
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913A3201024;
	Tue, 29 Oct 2024 03:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVL2PUgz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE71FCF49
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 03:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730171653; cv=none; b=QEhjLwE7ySM1tIt4FgKB93frIj1vNkn/qeosPvsuEwZD96oGyZUsXGNrwe114N48NoWMPg65E6klxW8zQKwOCOYT9GmPGGMs/Ge8B7HTgGvfz/kkUM4FxV+eZtxlZNgmZGgJ54AeVn+I1SH+PBH5HO/xnI0IwCorjiVqX2XvN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730171653; c=relaxed/simple;
	bh=tqbmkd8mTTg4Ohe+h4ysRj5J+X3fXYGg94EKFwme3x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNJTALAcd8nJVHyU54SVwsSTqoF4xQ9tfYOPNDaWHXqAPIpgvVYgYPftsMIoPfUBUdp9NcL3bhnTZHw/b7qEFtYC6nIfjWLOY45dJFrZqbT2rGfkSVZyaIilihRwUriRM+I/hy4RQwsn4G7fgsBXqY32YValM+TEZaCd/Q0FeK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVL2PUgz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20c6f492d2dso55446805ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 20:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730171651; x=1730776451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVQpZWzWU++ZBAiq+Rpe8VAzGXvDXbF0Dur5f1tS66Q=;
        b=MVL2PUgzrAZb2l9THxv02eDMZQS4ULJtu12Rvp3cUPnpTBPLQK8k2k6YB03nCXy87+
         hixwBiQMI/7SdwzAE9kL4ATNvashwMZXKdtKIEmnefzKzXMrQmG7EP5XTnRoZZR2A/fk
         Zjb9K/G3DYvTZoSw+AsQTo5V4xUJhzdfYtBLIgUQs1eqlqVKZWpjPK7YqesgwygyVl4i
         mI2bn05PfIgILqTduZW3oJwr/7yWrhv/xSJIH0FY8hrG7g2D/MIaq5LZWTLpmDty5m1o
         fW9f1lOspdsfOCDWifIJaPvWwtXWjlHSmjvtzY+VABATdMRGJNu6H8WuTplrQfogeJ9Z
         eVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730171651; x=1730776451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVQpZWzWU++ZBAiq+Rpe8VAzGXvDXbF0Dur5f1tS66Q=;
        b=B2kGX4iWnPwclCgPcXi2Rt/9nOROvzyIUc6LNRkx2GDeHB2NR8z6JZrRHZ3z00fKQm
         PCI9qpOUQQtTkxF+HEGXMk/fcP8gPB65HyeXDNld9pJ/kLGsxsRgqtCuxsayIGabKGX5
         lkHc7hbx+QcVotyY/ctIwrCL5Df7MEb3BUmbA5VOA/LW10X4q18wYFLF0XOKfYgU9bBY
         bscEqeG9S2IJQMNgEVnbYYm+A/GugyV1oKRUmgvsgLE26rBFg/fkyq//3kbz2Ogz4e3Q
         MbAhHBL7RN30PtznTx40b+b3jI2eriQN8L/K/jeeFV9h8pc/bTTw/awsUZMTOMUjNdxq
         3zOw==
X-Forwarded-Encrypted: i=1; AJvYcCXB41BKvHiM6Y8r8pUH5bs0Q2aPT+K3KCfBcVfpvLgnoMtmAIMyyVCga9dC3yBsEN/i/cI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEBVjUaYEthEiKr6DT8bt0QLD4XbTkZYyY5f3KCKYm3z3fp6k/
	ecdVKB7WegTXLV6mR+201MaM5P7BiAo336nrz7nIrgRN2QzLeN8T
X-Google-Smtp-Source: AGHT+IEfRBWrPonnSnOiKxO7HP5HrHUiSaKRQeYWFcS/DfZttGjslnq+PVLUe9Jsayt5bs77fuI/ew==
X-Received: by 2002:a17:903:2312:b0:205:8407:6321 with SMTP id d9443c01a7336-210c6879f49mr134003645ad.9.1730171651205;
        Mon, 28 Oct 2024 20:14:11 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf43476sm57300795ad.24.2024.10.28.20.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 20:14:10 -0700 (PDT)
From: Yong He <zhuangel570@gmail.com>
X-Google-Original-From: Yong He <alexyonghe@tencent.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: wanpengli@tencent.com,
	alexyonghe@tencent.com,
	junaids@google.com
Subject: [PATCH 1/2] KVM: x86: expand the LRU cache of previous CR3s
Date: Tue, 29 Oct 2024 11:13:59 +0800
Message-ID: <20241029031400.622854-2-alexyonghe@tencent.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029031400.622854-1-alexyonghe@tencent.com>
References: <20241029031400.622854-1-alexyonghe@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yong He <alexyonghe@tencent.com>

Expand max number of LRU cache of previous CR3s, so that
we could cache more entry when needed, such as KPTI is
enabled inside guest.

Signed-off-by: Yong He <alexyonghe@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a68cb3eb..02528d4a2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -430,11 +430,12 @@ struct kvm_mmu_root_info {
 #define KVM_MMU_ROOT_INFO_INVALID \
 	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE })
 
-#define KVM_MMU_NUM_PREV_ROOTS 3
+#define KVM_MMU_NUM_PREV_ROOTS		3
+#define KVM_MMU_NUM_PREV_ROOTS_MAX	11
 
 #define KVM_MMU_ROOT_CURRENT		BIT(0)
 #define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(BIT(1 + KVM_MMU_NUM_PREV_ROOTS) - 1)
+#define KVM_MMU_ROOTS_ALL		(BIT(1 + KVM_MMU_NUM_PREV_ROOTS_MAX) - 1)
 
 #define KVM_HAVE_MMU_RWLOCK
 
@@ -469,7 +470,7 @@ struct kvm_mmu {
 	*/
 	u32 pkru_mask;
 
-	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
+	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS_MAX];
 
 	/*
 	 * Bitmap; bit set = permission fault
-- 
2.43.5


