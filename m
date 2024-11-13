Return-Path: <kvm+bounces-31766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E8A9C74C0
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD4C282059
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE417083F;
	Wed, 13 Nov 2024 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=philjordan-eu.20230601.gappssmtp.com header.i=@philjordan-eu.20230601.gappssmtp.com header.b="ltIG9G/0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC85B23A0
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731509399; cv=none; b=ft7QObZwFh0jK2Cfd0dYzgn6nxkijdn4waHzfE0gufvELvT+hXy9LdOOXcnO4eWJ7bS9m7wIJ7obHV11a4IsXNgHZKml8dC9tea80tXiKAoHnY3Fpl5mkLnmgZr+hrS5pDTQv8XJYNRE1vu51AMZYZCaPUWdGIV8rwmHn+ihJ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731509399; c=relaxed/simple;
	bh=XXM5AEWs6sZEjWVQ26Gc19fRTwEaDpboIZbosG1zFAA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VGtF+/s7Kv4IjAFwE0w2W+S9cogDDpiGj5+kkMoVo4SedksEARc+0mv5iREnIMY0Mc5+9sjhMX7zXmvm+QIrYWAORjGCs5Ej6T/QTbd1F/KrTKh6GpQ7Dy5QJ4o5MNyy/266UjS7eUVd27Piq7IMEzi4u0CLKXBTyUW3y7N6L4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philjordan.eu; spf=fail smtp.mailfrom=philjordan.eu; dkim=pass (2048-bit key) header.d=philjordan-eu.20230601.gappssmtp.com header.i=@philjordan-eu.20230601.gappssmtp.com header.b=ltIG9G/0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philjordan.eu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=philjordan.eu
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a99e3b3a411so151210266b.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1731509396; x=1732114196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o9i8rVTiyYcoZex4Ipmw+6Bs18ZPMVTcpLGMM43twc0=;
        b=ltIG9G/0kfbnRkClae3Bp1qlPI6iMi7Olmc6MGLk8OgEYccrG5jEje3/XAZ0onKwg+
         6FXVBgOhw6OQ9Ydud2wHj84KJKVmnoICn5mJfEy99tHHV+uOFaRPPUQjCWqBS8j0jfSF
         9w68ftmLdDqMwDemafIBJCsW4mrueUxxbBM74d5x7+CF0hBnSF2aSic9hHB2nzqTQYyM
         7/1UlJuedCoODQHGUG+9stbGfPgeL/5mScvChdNT1Q/ed9kp0k7YSu46orPEZJuj7b6y
         s9spYemDsIoWBXptfpDtLu40DegB7Tkkb6twLFyMnkFQsRffkpdNIsAcoEGo+M0U39/6
         ImrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731509396; x=1732114196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9i8rVTiyYcoZex4Ipmw+6Bs18ZPMVTcpLGMM43twc0=;
        b=pf3P09sunChdT3qY6m6JYaM+h51P7KHqmRboxiSxl50/vi+mjPcqMca04wAWZ1HjXR
         5za4ER1Xv0Q1oue1cuXjlbtsd35xggcv9QizpBnTTa904sd/HKjJ43XChfkQIb1nGlte
         gCv9qKfZ9QsuqI3NjpV7a8Pf1osrlp51v96kHJAIwweh2hoIA2NtYf2oAq6HZknPKqWK
         WK5NokeOjXZw9WysB/I60F92bP18QmMDHiwKSraM3kmWLe3Ed+sc8BrPikHRMVpvZfQw
         ANjG4siEtR7N1EBkk+Y9Oe0vQ78JheXenYC6awcl5/8lw8G49/DGtTtndnidVw+YfHCc
         yKTg==
X-Forwarded-Encrypted: i=1; AJvYcCX8Vk36dBMmIIWDSb3OvssGsm+i3vNN7cvL/eX3UFovFBBZkzcU+5uz1+2f8kD4K6cTG4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOLkXyZL3bBpVZz1Fz1ZjAQtBWeVwJHNuG/iAx34Yya+heKbHm
	6xAdMV2Fra7FDJws95lnTZSCO7FjqS9i6tS+v80nZEy+DrvD6rQMZj+XAhvrHw==
X-Google-Smtp-Source: AGHT+IEzPUha6PvG5sjDVmqyHZOgw15Y7y/W4eMrlt2+jPubPDU2xoa5rZ5pp/2iadz7sgiUm0BA9w==
X-Received: by 2002:a17:907:3e16:b0:a9a:cf0:8fd4 with SMTP id a640c23a62f3a-a9eefee9b66mr1769121366b.18.1731509396215;
        Wed, 13 Nov 2024 06:49:56 -0800 (PST)
Received: from localhost.localdomain (h082218084190.host.wavenet.at. [82.218.84.190])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc578bsm885753166b.104.2024.11.13.06.49.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Nov 2024 06:49:55 -0800 (PST)
From: Phil Dennis-Jordan <phil@philjordan.eu>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	mtosatti@redhat.com,
	pbonzini@redhat.com
Cc: santosh.shukla@amd.com,
	suravee.suthikulpanit@amd.com,
	Phil Dennis-Jordan <phil@philjordan.eu>
Subject: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM builds
Date: Wed, 13 Nov 2024 15:49:23 +0100
Message-Id: <20241113144923.41225-1-phil@philjordan.eu>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It appears that existing call sites for the kvm_enable_x2apic()
function rely on the compiler eliding the calls during optimisation
when building with KVM disabled, or on platforms other than Linux,
where that function is declared but not defined.

This fragile reliance recently broke down when commit b12cb38 added
a new call site which apparently failed to be optimised away when
building QEMU on macOS with clang, resulting in a link error.

This change moves the function declaration into the existing
#if CONFIG_KVM
block in the same header file, while the corresponding
#else
block now #defines the symbol as 0, same as for various other
KVM-specific query functions.

Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
---
 target/i386/kvm/kvm_i386.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 9de9c0d3038..7ce47388d90 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -21,17 +21,18 @@
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
+bool kvm_enable_x2apic(void);
 
 #else
 
 #define kvm_pit_in_kernel()      0
 #define kvm_pic_in_kernel()      0
 #define kvm_ioapic_in_kernel()   0
+#define kvm_enable_x2apic()      0
 
 #endif  /* CONFIG_KVM */
 
 bool kvm_has_smm(void);
-bool kvm_enable_x2apic(void);
 bool kvm_hv_vpindex_settable(void);
 bool kvm_enable_hypercall(uint64_t enable_mask);
 
-- 
2.39.3 (Apple Git-145)


