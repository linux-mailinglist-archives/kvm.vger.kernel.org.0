Return-Path: <kvm+bounces-17419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7BF8C6285
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 10:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415D21F2244C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 08:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0E14A9B0;
	Wed, 15 May 2024 08:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUzcQz+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644EB4EB4C
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 08:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715760432; cv=none; b=kqXQrh5+Bgt3eUVHqqypOHS3ebCazM0u0avhRxuGNAKyapYbIVJi0mzukPdliAgGWfeiNZfWVNSxzm9uEcRvMkhoSnYiISHLeJy5ZRwa/VBWosTpypDWiMlKgC2ewGndARe5kyJw0SeDmZM0qBiNjdb1LEG07OoXOsu2hq35aRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715760432; c=relaxed/simple;
	bh=Z9tFXsYl9x9HzTnDqZzJLaQdmzLJqw3lfq4M/QRacPs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KPGDa0QWcQXUIzGBf3zGGItMVlqoFQ9TuuVs5gpm9bsUp8UREGR8FbqZWm5aqsTogoNzvrE1QYLQmMghNMK+7gAam9XgvgbiLNMRo8VRxVjnR2/iUuyZaPnRantenLNFNG557yWrkfu/8mUkfY0/j23CprBzJ9ULbjKT57ifjcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUzcQz+s; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f4603237e0so4573541b3a.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 01:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715760431; x=1716365231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DVr7QoITwo9cCTu+98bi6Ib9tCwdYLgx4jSR1TSEw8g=;
        b=JUzcQz+slaOAikjUVeQZMR/wJwuKUWMIobZXO7Dc6ofYWtg2g/uAVtgPPNu6o+HaAd
         /oy/epCU7QZBFlGXr9ZAv2d+lqC/Ss4xjJ3VscyVdOuWe7sgQFkALBhTKA2eObQNNriz
         Qi4J7B5FRYltuq+n2JmRX6hG+L3tSCuc+S4fTED4q1ltHVbXfFGShUBSIK5byAYPyY5Q
         glCNaInbsDZAP6Ug/FC7uDia7OPbqe1hnOnz9bo+5bJTNFoHT7jRgjNPBy+XIw8ABTMy
         KRJjZ+tyRS/HKEXs/jRjrR5XZ+95/NWRmprkLAcp1t0P/2PFP3vC1gqVF34UOBw3cxkw
         CTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715760431; x=1716365231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DVr7QoITwo9cCTu+98bi6Ib9tCwdYLgx4jSR1TSEw8g=;
        b=bZSTsjMySe/NO2LME7Xw6l5eS7bR2642tpGUHDoQA5LbCiasUeDJgiDaNTUit3c702
         8KLKDi4gemEHqJN2RzsRIbvXazG4HHQkbB9o9nLoHyokekJtx1sGZYt9ivOow4vvxIwF
         RBnIimG2HQeBQQRwQnbWmuaCN0OBkJisZJdIHW+oQgS2JcRKjjxb07VOIn9WdKvHaYRc
         z2giDUlm0Gb0eGhZbyfElAKhgZSRd0ObNoYDbUHr6L8CV9CE1HZkVrzKWTxSkGe2lO1D
         UOujQCUh39bqmQv0WSEq/GLShJYFPd3kYArHpZKnEBFc3/JKMP26GCM8ko8J88YRFVD4
         Xbrg==
X-Gm-Message-State: AOJu0YzwSD036GLdsjNsCUD71H2vzZPmajbmcXRQ+CjYlPNsJ6r7kNc2
	YWfS6AlVuEBR34TSj480esuIu1ECFUNUzZTRmi9dMGh55XAQIqu1
X-Google-Smtp-Source: AGHT+IEna9VwG4hc4wTHdO3Y8q2iIAIB56chriAXmST0U0anzjUhP9IEaOWgbjT3IktvYgf/LbLocg==
X-Received: by 2002:a05:6a00:61c2:b0:6f6:76c8:122c with SMTP id d2e1a72fcca58-6f676c814c0mr972124b3a.16.1715760430686;
        Wed, 15 May 2024 01:07:10 -0700 (PDT)
Received: from localhost.localdomain ([154.30.132.4])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-634024a3eb4sm10954328a12.0.2024.05.15.01.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 01:07:09 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	liangchen.linux@gmail.com,
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
Subject: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers via ioctl
Date: Wed, 15 May 2024 16:06:07 +0800
Message-Id: <20240515080607.919497-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a nested VM environment, a vCPU can run either an L1 or L2 VM. If the
L0 VMM tries to configure L1 VM registers via the KVM_SET_REGS ioctl while
the vCPU is running an L2 VM, it may inadvertently modify the L2 VM's
registers, corrupting the L2 VM. To avoid this error, registers should be
treated as read-only when the vCPU is actively running an L2 VM.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reported-by: syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000007a9acb06151e1670@google.com
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91478b769af0..30f63a7dd120 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11527,6 +11527,12 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	/*
+	 * Prevent L0 VMM from inadvertently modifying L2 VM registers directly.
+	 */
+	if (is_guest_mode(vcpu))
+		return -EACCES;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
-- 
2.40.1


