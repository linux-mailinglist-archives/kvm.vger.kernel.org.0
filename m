Return-Path: <kvm+bounces-55887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D973B386A9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 17:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2F671630FF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 15:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D332286424;
	Wed, 27 Aug 2025 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KDVR+Z3K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE35281375
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756308486; cv=none; b=qYJDw0KQZzZFkUdPjDpBWnYwgkjs3O+RHZHWZmrApSxYX0NpBWvXFKfYkHSzu0/zScaVfE84kI8DUACwmzOHy/R11YgFi9KNAqKkVjGtrRRzYaQDZeh38ew9wKFDKrrFsfbg6cGJWxNeIjzOgpq38M8Y+eP6qo6GzVfXnRp1nWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756308486; c=relaxed/simple;
	bh=HSDP9rXntbbo/SzNMmXdiyg1N9BxuBhjXVJ/uBQBUrs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mCidK6CRQBka3Mzp+h0kh60o9BgrmAb2orHQa5aYuaB3N2rbk6M9lOyznIhx/21EXFzw4QPL0agv72b7UPUclO9b9eP4Z2NTSms3rbzNOyW5V0Mu3b2NiYsMAG0+oIV19vTDFKYZDzR5VgM3ZKS/9Bq827cPUJoA7nKZzWZluHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KDVR+Z3K; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7720f231151so505191b3a.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 08:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756308484; x=1756913284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HLD5dyrFNqX9W25nsuFMTaYiQlg+FPGuA0/e2agvvXA=;
        b=KDVR+Z3Kqi1a7p3UAmc8wova5FRZgodWGOYGPCA2LDDfAdZ1lmzFgAMVjIsnmvGdep
         nRa3EGwS18wK83sU99GqlFUp2W4ZU7RS8ogt2Cg01wvvY1j/1w9+BYUCq1AuShZIjuUL
         hm/lKrQQUOQ3UliKPhaRZ0xN6mLSstflABfZl0uRn3R+InoN1NPFAEXlg21H/GQh0VxL
         PPqyZkW4oua5+wjmDm55uAMRbSaVYaESIeuOkp51vfC/3YEc6Swlj0rS14/E6hYkiY/c
         azuP13CVYdTGwTaplDT9s68WbF/rqKbruvJ/k8Ic62Copg6dCb6H7zHACzMVHqQKGBAS
         pBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756308484; x=1756913284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HLD5dyrFNqX9W25nsuFMTaYiQlg+FPGuA0/e2agvvXA=;
        b=fRpdGddpC2z1eFuFy5U6jfgPXbAx7qDahoM91nAQR2lcdOEkPOSfsvBK3sIbV2LKKo
         5JdB/lB9omoDOhzqQs+ey+kAzvxx2laFK6bdqXO55UlBkqQpPNj7vMH4WHevl/qWWiU8
         91aZfDVusZyvwNo4Uetr3p2UNfXbe2/AVHbT+j1J4FQX8l7o2cC4dZCwrK63SfPUkZte
         ++UpRzH9JUcNgwalBKCo2JEzJH0gvRltLLTXck8upJkTowVPK6ODc3xIdY6q48hHQRro
         gYzPLzUqkpxQNX4hXwDbnbOQODGv8HnnqfcVXuncAyC8Q8EkfwIVkYYMu0evVhMXwE8X
         +f6A==
X-Gm-Message-State: AOJu0YxX4E2zl0XoQFjY7EZ/cisoDMfzxiG9izFaL5MviOPNYCnQuDrw
	peBqWPUTzT1y/B7x/nGF8HEVkuql15v7CVkua12/NxeCXXp+/tgu8P/TVvDGBxmVV54=
X-Gm-Gg: ASbGncs0I9OcGyniYXfMbMbvnDDXhQ44lr5H+gIDbNXx/HxwsB7i8PSjBUVMrraMxkv
	FCFUmDpFuhIR2RevbHDLrT3ZocEfsMBbzW4m9FIeaYll0X4ZCm2LStKRyBI/Q2r8uiQ70l2FtHo
	rOL4ExYVM8exu+RxkF1FkLg7HZOdP+6MDiofl6Pi3kUULWZMMKYJVCTbS60V3ccmhaFR9M4gxy1
	q7YI9mc89DU3fTug8ctW5ILzefY/goDVNl1lIrO187+GSSxj57TicdU6vys0T8MUOZ6bGYv3vjK
	E1xgf5z7W9/anz5RsA8AD9DDikBYST+GumMW5FB6VklVuaeJeuxDBW6bBrGd8yGTLW3FXgRw3D9
	Yo0op2zE2ZfemL/fTE/WHA/BhvlBXIXbNx2ZU2/OWvN52ocUruiGbJp1aqy330w/c
X-Google-Smtp-Source: AGHT+IFjVJzj3KAq04af7jyaKVQPUw7/lh0Km2Xbvr3GuzkxjwaVXH1UDcAoO+QMmNUmibC3628sRw==
X-Received: by 2002:a17:903:3b83:b0:248:c96e:f46 with SMTP id d9443c01a7336-248c96e17f8mr4293005ad.60.1756308483845;
        Wed, 27 Aug 2025 08:28:03 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4c1b2f5a3csm7630507a12.4.2025.08.27.08.27.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 27 Aug 2025 08:28:03 -0700 (PDT)
From: Fei Li <lifei.shirley@bytedance.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	liran.alon@oracle.com,
	hpa@zytor.com,
	wanpeng.li@hotmail.com
Cc: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Fei Li <lifei.shirley@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: x86: Latch INITs only in specific CPU states in KVM_SET_VCPU_EVENTS
Date: Wed, 27 Aug 2025 23:27:54 +0800
Message-Id: <20250827152754.12481-1-lifei.shirley@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ff90afa75573 ("KVM: x86: Evaluate latched_init in
KVM_SET_VCPU_EVENTS when vCPU not in SMM") changes KVM_SET_VCPU_EVENTS
handler to set pending LAPIC INIT event regardless of if vCPU is in
SMM mode or not.

However, latch INIT without checking CPU state exists race condition,
which causes the loss of INIT event. This is fatal during the VM
startup process because it will cause some AP to never switch to
non-root mode. Just as commit f4ef19108608 ("KVM: X86: Fix loss of
pending INIT due to race") said:
      BSP                          AP
                     kvm_vcpu_ioctl_x86_get_vcpu_events
                       events->smi.latched_init = 0

                     kvm_vcpu_block
                       kvm_vcpu_check_block
                         schedule

send INIT to AP
                     kvm_vcpu_ioctl_x86_set_vcpu_events
                     (e.g. `info registers -a` when VM starts/reboots)
                       if (events->smi.latched_init == 0)
                         clear INIT in pending_events

                     kvm_apic_accept_events
                       test_bit(KVM_APIC_INIT, &pe) == false
                         vcpu->arch.mp_state maintains UNINITIALIZED

send SIPI to AP
                     kvm_apic_accept_events
                       test_bit(KVM_APIC_SIPI, &pe) == false
                         vcpu->arch.mp_state will never change to RUNNABLE
                         (defy: UNINITIALIZED => INIT_RECEIVED => RUNNABLE)
                           AP will never switch to non-root operation

In such race result, VM hangs. E.g., BSP loops in SeaBIOS's SMPLock and
AP will never be reset, and qemu hmp "info registers -a" shows:
CPU#0
EAX=00000002 EBX=00000002 ECX=00000000 EDX=00020000
ESI=00000000 EDI=00000000 EBP=00000008 ESP=00006c6c
EIP=000ef570 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
......
CPU#1
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00080660
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00009b00
......

Fix this by handling latched INITs only in specific CPU states (SMM,
VMX non-root mode, SVM with GIF=0) in KVM_SET_VCPU_EVENTS.

Cc: stable@vger.kernel.org
Fixes: ff90afa75573 ("KVM: x86: Evaluate latched_init in KVM_SET_VCPU_EVENTS when vCPU not in SMM")
Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c46..7001b2af00ed1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5556,7 +5556,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 #endif
 
-		if (lapic_in_kernel(vcpu)) {
+		if (!kvm_apic_init_sipi_allowed(vcpu) && lapic_in_kernel(vcpu)) {
 			if (events->smi.latched_init)
 				set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
 			else
-- 
2.39.2 (Apple Git-143)


