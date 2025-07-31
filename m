Return-Path: <kvm+bounces-53813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C5FB1780B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58FD63BB271
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 21:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D3A273D6C;
	Thu, 31 Jul 2025 21:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k2CtJe1n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D78926D4F6
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753996817; cv=none; b=Sk4d+gseN9uyFkpz2kkOGyw8Ux1QawuwGVxqtkzp77lf7vlxsXkEIk47q9u94TmeJTlEH/qF1ltvlXBJPoqnvPezrSBDcm1UVy+i0zbkJj5I3/67LVbo1mfTOsBQX0zbyJvqR7TvaDs8T7fETCtuygDLWyKx5FvrC4xkpTGD4Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753996817; c=relaxed/simple;
	bh=JT3CWRDTYG4cChSrXWCLOhvpTNKdhai2Q1ZpaBmS13M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adBPwjms2hq3ul7WyGbz0eqhUQE+4crRJAB2rJJFRyRw1zyRRQkORJFFf8osvoVup6oX12ImX7IS0WmBMkyNp02R1d59RWAlZ50BOTehuUS1GFuJAVeRr7hQqLbDWEj+hENpFI/G/1tbInd6FZrZn4kTE+RJMK5A7TvoRdlwON4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k2CtJe1n; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76b857c5be7so1376335b3a.3
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753996814; x=1754601614; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTjiUI3VYu0NKZoAdRBhNFbi9ic5y3o11ghK/xobY4I=;
        b=k2CtJe1ne7PxgA0vKSdQnBOO85Sm5rq45wiMZTNpPtqw/3LNpnJL5bLe0m3gQ0miz6
         ErtZhPsLkbHfEoDx2j5MwkS9S/JPlyuu2QZlEPD6UfqpQmuRD++ZGMx7r7DrXjKe/9qF
         f/sdDIzenxIwSdSBM/nti3d9IMa2XRXDCUt2q71SKc42mMq5AhnqXb7n5qVrQuzXS8vW
         w3ErPCIL1RjWJMc5sm22q0MDG6t+uz9UWS5fntqy3BANi/DIBcEFAbf+JR0MEd8H+5au
         udhnusXxhR9LDnNJOgW9tX3QDfivdAA3zF4BeM1nvSN7KHVsisuTf5WTRoMDTYZd5gyh
         d90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996814; x=1754601614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTjiUI3VYu0NKZoAdRBhNFbi9ic5y3o11ghK/xobY4I=;
        b=a2ezMi/3eUD8UNphF231PJ49o3HSUfNjXiQzUkDDF6iy8owp5gofblGQ+goYSxOQOG
         7lE4JErCp7QrbGTagNVkKNxoAAonZnQf2t05WJShIxZTmrCapkZ2ziBFkIOZdCUMQe39
         Qsi+z2YpM8EKFnNO+F2RQEbNrF7aV5ne4ijofRf8NPZy8AONQzQtsYPDRejPw1DVnkIR
         JXEmPaJpr1QGSw1zHuP5H9rpLObxoF/Qpkzo9wDb3Od5H5jhitIi4fr+QHZYrK3aktPR
         C8394AY0A550CpclpY8i0gHKV4pmgvJQC+0fKkgDoWlYhuYsNMejztDJmqkjQBcwNrxY
         94Sg==
X-Forwarded-Encrypted: i=1; AJvYcCX7cxrDT8PleToF81CZSueX+R5+YRujIETUYJcDl6zAOiRftmjxehHQywCnD9ozAizLMTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwevONVJjxe8mvs4tWWqddagC1xX3ApeOGvYJzKkHpIZEZIJLFG
	7OzSpUgfDikw4mDcDEQEWoirnd+CZJlQCiBnsMDz992QrH3j82xuytOMXELdRGZ0yOk6uKbwKfo
	Yj7wceAjTQ1Ni2Q==
X-Google-Smtp-Source: AGHT+IFhVSv5g3S5dWH4OHRA2GJ8bC5E6G/7J0FiOp5/CduJgl6OwVsVKsUaRoPixkC/rA/rTNfaZg5FrktJgg==
X-Received: from pguc17.prod.google.com ([2002:a65:6751:0:b0:b42:2527:fdbe])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:939f:b0:233:b51a:8597 with SMTP id adf61e73a8af0-23dc0ea7837mr14728409637.35.1753996813871;
 Thu, 31 Jul 2025 14:20:13 -0700 (PDT)
Date: Thu, 31 Jul 2025 21:20:04 +0000
In-Reply-To: <20250731212004.1437336-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250731212004.1437336-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731212004.1437336-5-jiaqiyan@google.com>
Subject: [PATCH v1 4/4] Documentation: kvm: update UAPI for injecting SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rananta@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

- KVM_CAP_ARM_INJECT_EXT_IABT: userspace can inject external
  instruction abort to guest.
- ext_abt_has_esr and ext_abt_esr: userspace can supplement ISS
  fields while injecting SEA, for both data and instruction aborts.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 48 +++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 53e0179d52949..8190ffb145c37 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1236,9 +1236,11 @@ directly to the virtual CPU).
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[4];
 		__u64 serror_esr;
+		__u64 ext_abt_esr;
 	} exception;
 	__u32 reserved[12];
   };
@@ -1292,20 +1294,42 @@ ARM64:
 
 User space may need to inject several types of events to the guest.
 
+Inject SError
+~~~~~~~~~~~~~
+
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
-If the guest performed an access to I/O memory which could not be handled by
-userspace, for example because of missing instruction syndrome decode
-information or because there is no device mapped at the accessed IPA, then
-userspace can ask the kernel to inject an external abort using the address
-from the exiting fault on the VCPU. It is a programming error to set
-ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
-KVM_EXIT_ARM_NISV. This feature is only available if the system supports
-KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
-how userspace reports accesses for the above cases to guests, across different
-userspace implementations. Nevertheless, userspace can still emulate all Arm
-exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+Inject SEA (synchronous external abort)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- If the guest performed an access to I/O memory which could not be handled by
+  userspace, for example because of missing instruction syndrome decode
+  information or because there is no device mapped at the accessed IPA.
+
+- If the guest consumed an uncorrectable memory error on guest owned memory,
+  and RAS in the Trusted Firmware chooses to notify PE with SEA, KVM has to
+  handle it when host APEI is unable to claim the SEA. If userspace has enabled
+  KVM_CAP_ARM_SEA_TO_USER, KVM returns to userspace with KVM_EXIT_ARM_SEA.
+
+For the cases above, userspace can ask the kernel to replay either an external
+data abort (by setting ext_dabt_pending) or an external instruction abort
+(by setting ext_iabt_pending) into the faulting VCPU. Userspace can provide
+Instruction Specific Syndrome (ISS) in the ext_abt_esr field to supplement
+the ESR register value being injected into the faulting VCPU. KVM will use the
+address from the existing fault on the VCPU. Setting both ext_dabt_pending and
+ext_iabt_pending at the same time will return -EINVAL. Setting anything not
+being part of the ISS (bits [24:0] of ext_abt_esr) will return -EINVAL.
+
+It is a programming error to set ext_dabt_pending or ext_iabt_pending after an
+exit which was not KVM_EXIT_MMIO, KVM_EXIT_ARM_NISV or KVM_EXIT_ARM_SEA.
+Injecting SEA for data and instruction abort is only available if KVM supports
+KVM_CAP_ARM_INJECT_EXT_DABT and KVM_CAP_ARM_INJECT_EXT_IABT respectively.
+
+This is a helper which provides commonality in how userspace reports accesses
+for the above cases to guests, across different userspace implementations.
+Nevertheless, userspace can still emulate all Arm exceptions by manipulating
+individual registers using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
-- 
2.50.1.565.gc32cd1483b-goog


