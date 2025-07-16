Return-Path: <kvm+bounces-52656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067A5B07C07
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54A207B7285
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C242F6F83;
	Wed, 16 Jul 2025 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uwl0O+8P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C8262FF0;
	Wed, 16 Jul 2025 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752686965; cv=none; b=Bk+ifki/OuEqWkTffiy0PKF9aVmVt4Fu7BX9DZFHZVYBObuWxYVhYUu4WsZsU3by80yG9iWwus/KSJCXvfAAymvz/7+Aai0Nw90WOSzueDzsHBDd1PRkDlr1J7m6xcbSRboe/SdiuVaCP6mOEsOGZRqZF1ZogTRksiEAx4CWRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752686965; c=relaxed/simple;
	bh=/CRxn40u4I7Y3Igo8F7RLHEk9wLiNnQv+7XGP+TdYDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lArrFvjkfAnu6RhT/AnmzEZpH1yX4MRObqLpGQGOxec4xHqYNCm4HoehV5Y+b/EUSEZPLFalDSBIUUEzuxabqqVrVO3FA4pH74ZVeoEih7wQBM47eH1IUbpCz5eFjGpoBIQbw54Uok9hk45OgMxcMwnvZd5SS0A2PrtnT1ynYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uwl0O+8P; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-234d3261631so568345ad.1;
        Wed, 16 Jul 2025 10:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752686963; x=1753291763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EeNLgPU1RuJx4DVnlAIwci5Aq29THoN9KPCiSfsR7Ek=;
        b=Uwl0O+8PTuGxtmurFJNVw3vjvtqDDNdkuSfsO2fT6RcEzlB/Gw7H9qC7YL0X8YAhJs
         RuzgINL0wphT9AW0iRFIbzhB5bRNbwWEz562q7Q05wIDftJa5lGHa5eiE+dPqR5oVtVD
         OVu6UuqfQRGmDBHF01F0xKPZRkiJf4VTBqVPj4ErDYuSnZsiHdtbglCxNc7/S/SOwyTR
         gNKB4DNi67VXM4lELv/XNMM4F71CNh53nmrpsKFofK0ud6F7lQ6Dz+5je6l52YG1uyix
         lmGm26RaBAP+318ox5oblmRjJqX2AWjxn2lFPilzJkvxx1fnrfGj7af+Web8oVcRNqFX
         rfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752686963; x=1753291763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EeNLgPU1RuJx4DVnlAIwci5Aq29THoN9KPCiSfsR7Ek=;
        b=cqCorNpTIdiu+qJ/OYsWmVs3W8n8c5LLdDmkrKbU5HWgIdHRGiFT1AO5tRzlX9BTZe
         TbSYw2ezl3G/QVAj1VLdmLB4bLOT9w0ko2rhDyiEouWOiH7DYuUbBCdh47iY9xnfZsB2
         e+Aj6nbJrEUNXYsQDtxWUT8CzChPCKYrfb6C7LbViGENwaBywJglWsf1pZy7GrLgqjmN
         g/l/61APTDeXms/YYGLh5yQKT1ylsax8JPk1wUWy+udI0fIJU/XIIR4kmXR33NPzSb3T
         fP9QOg68sPSaZXIay2TYM0DcIUe9+VDjN2NBqLTOjAR/561WhIq6cQKzJu+fMrG4zayE
         xxCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpDHMpHoppTYNwUbFdegtinUh3XfpW6c/GaIlK3c20jruF1+RtsR6/4Stux0x9sBWPJYo=@vger.kernel.org, AJvYcCUvvadx7wSByJXa8BcGdKt2RuUKn67V3BO3zMgFG57fHQrcOVcwIvP5WFdm1kijUymbOi3vcf3TFkhhZA==@vger.kernel.org, AJvYcCXSrlx0b39z/07vfSz6Miz98wSI24YFVf9ZSlcD2G8H79ijNOTEB+DBhFMQ3d52vfxebbc8d2G3Xa3xB9z0@vger.kernel.org
X-Gm-Message-State: AOJu0YyX5Xz79StCa2b9P6cBhgDM7CrRccfwLYVT5cKdCAAr+IQFnI3P
	BjFwest/lezc2jH6nDjOCyIdlLYNAsVKurfop+AIAtBXpaUSQujQ68ir
X-Gm-Gg: ASbGnct9u1fj2UF+yVmV8L3ymdWaxH1vTKWdtq3iYrdQwArreV2lDF/olBIaVG0Y5DP
	JkbyXh+hXL8caSfCLVKmrFMEAa3AUbTKdZ78mCFSm6Clt1KPvGOfPYSLRa2p5wIZkl8Nn/0AL9D
	Yp2LFkEd7Ghw7Ef1OhGr1OzUtoOIiG50xnACxMc4iqDhPlzVJG+a2Of7OLgoABxuJO2Nd+Jop2r
	DV7z/7V6Os7U8JmyJV1RHgErBAsbLP+eg1HQadzmJwj50i7UDEWcUQu+gh04IN6Eo4Nf1PEXa+q
	9c5V0pdawzppmuW9Qsr81dc51VMLFpVCJN145sVsiTY+JaeqSoYGFCQMl8kBgmmw3rs2afzKF87
	k8duR3NX6woiLOYQ7q2Db5g==
X-Google-Smtp-Source: AGHT+IFrla4A/7rNoDTY22sMyvGzQlh9NwucP/BhuoqqwEBTVe8gcRHnNT5E8Q/CYhCQFDV2lZpm2w==
X-Received: by 2002:a17:903:2a88:b0:235:655:11aa with SMTP id d9443c01a7336-23e24f522dbmr46832995ad.39.1752686962871;
        Wed, 16 Jul 2025 10:29:22 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4359b2dsm130406275ad.206.2025.07.16.10.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 10:29:22 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] mips: kvm: simplify kvm_mips_deliver_interrupts()
Date: Wed, 16 Jul 2025 13:29:17 -0400
Message-ID: <20250716172918.26468-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function opencodes for_each_set_bit() macro, which makes it bulky.
Using the proper API makes all the housekeeping code go away.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/mips/kvm/interrupt.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/mips/kvm/interrupt.c b/arch/mips/kvm/interrupt.c
index 0277942279ea..895a6f1781fd 100644
--- a/arch/mips/kvm/interrupt.c
+++ b/arch/mips/kvm/interrupt.c
@@ -27,27 +27,11 @@ void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause)
 	unsigned long *pending_clr = &vcpu->arch.pending_exceptions_clr;
 	unsigned int priority;
 
-	if (!(*pending) && !(*pending_clr))
-		return;
-
-	priority = __ffs(*pending_clr);
-	while (priority <= MIPS_EXC_MAX) {
+	for_each_set_bit(priority, pending_clr, MIPS_EXC_MAX + 1)
 		kvm_mips_callbacks->irq_clear(vcpu, priority, cause);
 
-		priority = find_next_bit(pending_clr,
-					 BITS_PER_BYTE * sizeof(*pending_clr),
-					 priority + 1);
-	}
-
-	priority = __ffs(*pending);
-	while (priority <= MIPS_EXC_MAX) {
+	for_each_set_bit(priority, pending, MIPS_EXC_MAX + 1)
 		kvm_mips_callbacks->irq_deliver(vcpu, priority, cause);
-
-		priority = find_next_bit(pending,
-					 BITS_PER_BYTE * sizeof(*pending),
-					 priority + 1);
-	}
-
 }
 
 int kvm_mips_pending_timer(struct kvm_vcpu *vcpu)
-- 
2.43.0


