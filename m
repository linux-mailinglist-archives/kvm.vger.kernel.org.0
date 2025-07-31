Return-Path: <kvm+bounces-53806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE30B1778C
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 22:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 341885A5EE8
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 20:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEDA25A33A;
	Thu, 31 Jul 2025 20:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6AzG1kK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01222265288
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 20:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753995541; cv=none; b=ulKEf3zhI2mIJAIyaDTMUvOpP9efuyD2YzwBBgi5PvPrKidxDSAUeXndFXTkAIZu3nPyoOx5NtHD1pkbdWGDApTpTui85pfo9f1N6E6IFK6FMDO/TQcurckzuSlMrqdtFiY/+G4rtTjXrAi0e8CscXfNmUGl7P6lo+gbriEnF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753995541; c=relaxed/simple;
	bh=yoT6DJExb3VRWLBkgFpzEF48Jk7YiXC2lt/RI1WEyLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ch8IOiuvwSTinpCmcwFmCiA9DYt+skjZO49inDPL9px0fZCA3ByGF0JgJfoGaDdacEmM7QRfeefQsSEnZpaIEcba9qmQrmxh2xWoiVrBN1EVMQmfegMOL6I3m5K+8dx6MTVrSPNZlvDJetDXxIileVLHdltqfp4eK1lPh0BGUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6AzG1kK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f74a64da9so1053647a91.2
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753995538; x=1754600338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUXB20g5KTDpVxkdi+cD6LrJ9ZPidMR3ejh7YHbLbWc=;
        b=p6AzG1kK/BGcmyyvXG+z3MJJkWCsBDk1lTRsn+wUwDuSIr4aqI4gupD5DvdV61pape
         n2qZp8HJrJXQz9jcsXJ99tIwN01Qpo6xFL2+UCzet7Tlz1TiiTpde5W2i4daYvAkiGI1
         +FT9Q5CB5uv1DRBeomxM7CPDTtVdBSA8TIOsR6jO45ZckHvkDPigsUUjaUG4lL7n4p9M
         DzUl/guHlab5bvV97XJBUUIK4bBOAtiK53qAeIkoOqonIcYaf2sK9MBTob6DpFqKOdSI
         TsBjJSGbwjFuuTTcElUuE2DQXpfje2kjIkLNQJAAWOdmmfwNTABKLsO/DhxkZly/6bVP
         B0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753995538; x=1754600338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUXB20g5KTDpVxkdi+cD6LrJ9ZPidMR3ejh7YHbLbWc=;
        b=UOPhgnsprdBDuh8rFuWScxhEpzXMVJQRDvdgPcLeUyidEhM/nidtTL0PUAHTsT42Mx
         jStoqGQ6W+ASxvz1nQAOs0yyUrZEoWGBR78/cC1JyOSYPB5Tz6C9Np2gfEEV0XbosHwk
         gje8NgOcDXORZUhPTEOgqQrPO0VuAx+D+LzwkfOb40bBNROVMERQZQdQmJghhHuoLweH
         zAplT7NLotUOyz/56Ywrjlykty2zXtcooawtUVZjutRgJg2tG0dtRE8xog/35uqUaRA1
         EM4gX/KU8MZkK9QNBKW4J/GS2GcgHOTU4vZmw98amScxDVWi2sP6BCqXDsVpXtUPTePk
         INgw==
X-Forwarded-Encrypted: i=1; AJvYcCVrTAwIKUGwR6IvqE7o/WO3E/qXfnoN9wpUF1FQ2WWs8JbzHdsxZY86+4UT9DfqM7MN9p8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuKq7oAO87Y7AtNksanM2bkPECpoygHIOzYcWjxV0eqCE8+8YP
	x1yMNcbRxhkyDSamrJK2Osf8iiiIDftWxn/r6RjLgNA30etuiG/JXYvRbuFvX5AifzGvDMT+15y
	FwesUKHupzrWenQ==
X-Google-Smtp-Source: AGHT+IHpN+KMEdudZzx9R+o2+YGbSRX7Sb8ugKl+/4e/Osfparz535RYvSTWw1nMv5ihMLOYXj3j/6PFJN9K4g==
X-Received: from pjtq5.prod.google.com ([2002:a17:90a:c105:b0:31c:2fe4:33bc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b46:b0:315:9cae:bd8 with SMTP id 98e67ed59e1d1-31f5de3f47dmr11403605a91.23.1753995538407;
 Thu, 31 Jul 2025 13:58:58 -0700 (PDT)
Date: Thu, 31 Jul 2025 20:58:44 +0000
In-Reply-To: <20250731205844.1346839-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250731205844.1346839-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731205844.1346839-4-jiaqiyan@google.com>
Subject: [PATCH v3 3/3] Documentation: kvm: new UAPI for handling SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Document the new userspace-visible features and APIs for handling
synchronous external abort (SEA)
- KVM_CAP_ARM_SEA_TO_USER: How userspace enables the new feature.
- KVM_EXIT_ARM_SEA: exit userspace gets when it needs to handle SEA
  and what userspace gets while taking the SEA.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 53e0179d52949..b61bca10a3a10 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7231,6 +7231,55 @@ exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
 it will enter with output fields already valid; in the common case, the
 ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED``.
 Userspace need not do anything if it does not wish to support a TDVMCALL.
+
+::
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+			__u64 esr;
+			#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID   (1ULL << 0)
+			__u64 flags;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
+
+Used on arm64 systems. When the VM capability KVM_CAP_ARM_SEA_TO_USER is
+enabled, a VM exit is generated if guest causes a synchronous external abort
+(SEA) and the host APEI fails to handle the SEA.
+
+Historically KVM handles SEA by first delegating the SEA to host APEI as there
+is high chance that the SEA is caused by consuming uncorrected memory error.
+However, not all platforms support SEA handling in APEI, and KVM's fallback
+handling is to inject an async SError into the guest, which usually panics
+guest kernel unpleasantly. As an alternative, userspace can participate in
+the SEA handling by enabling KVM_CAP_ARM_SEA_TO_USER at VM creation, after
+querying the capability. Once enabled, when KVM has to handle the guest
+caused SEA, it returns to userspace with KVM_EXIT_ARM_SEA, with details
+about the SEA available in 'arm_sea'.
+
+The 'esr' field holds the value of the exception syndrome register (ESR) while
+KVM taking the SEA, which tells userspace the character of the current SEA,
+such as its Exception Class, Synchronous Error Type, Fault Specific Code and
+so on. For more details on ESR, check the Arm Architecture Registers
+documentation.
+
+The following values are defined for the 'flags' field
+
+  - KVM_EXIT_ARM_SEA_FLAG_GPA_VALID -- the faulting guest physical address
+    is valid and userspace can get its value in the 'gpa' field.
+
+Note userspace can tell whether the faulting guest virtual address is valid
+from the FnV bit in 'esr' field. If FnV bit in 'esr' field is not set, the
+'gva' field holds the valid faulting guest virtual address.
+
+Userspace needs to take actions to handle guest SEA synchronously, namely in
+the same thread that runs KVM_RUN and receives KVM_EXIT_ARM_SEA. One of the
+encouraged approach is to utilize the KVM_SET_VCPU_EVENTS to inject the SEA
+to the faulting VCPU. This way, the guest has the opportunity to keep running
+and limit the blast radius of the SEA to the particular guest application that
+caused the SEA. Userspace may also emulate the SEA to VM by itself using the
+KVM_SET_ONE_REG API. In this case, it can use the valid values from 'gva' and
+'gpa' fields to manipulate VCPU's registers (e.g. FAR_EL1, HPFAR_EL1).
+
 ::
 
 		/* Fix the size of the union. */
@@ -8625,6 +8674,18 @@ This capability indicate to the userspace whether a PFNMAP memory region
 can be safely mapped as cacheable. This relies on the presence of
 force write back (FWB) feature support on the hardware.
 
+7.45 KVM_CAP_ARM_SEA_TO_USER
+----------------------------
+
+:Architecture: arm64
+:Target: VM
+:Parameters: none
+:Returns: 0 on success, -EINVAL if unsupported.
+
+This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
+that KVM has an implementation that allows userspace to participate in handling
+synchronous external abort caused by VM, by an exit of KVM_EXIT_ARM_SEA.
+
 8. Other capabilities.
 ======================
 
-- 
2.50.1.565.gc32cd1483b-goog


