Return-Path: <kvm+bounces-55816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA35B376AD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 03:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB2A61B66604
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26927260F;
	Wed, 27 Aug 2025 01:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m5mucb1w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF6C10A1E
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 01:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756257458; cv=none; b=hBthmJJBdF+vYDMryeIeyfmoUTOhMVkg79uh7aF99fC0pG4751F/yLoxEdnJlslFFjt5up+i7IFzPE1umzDNbAXynoHwfhspWDLTkvglet2GfJBMgzC/URaNuWiEH3p7kcJUsL1GmnLmpJZTCrFu54Pt7H81we9laB4Ycgq6J/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756257458; c=relaxed/simple;
	bh=z39zX8jKiXSJcli3pYHtO1pzGvP+CCP92tyfL+hwwZQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GvGDPfF0P2TfSzCNUkWKpELvLhCFtSZL89gRtZ21eB+cXumQB5TUQPjdDOtKO6jwozNzW1PkRttlZzQkwFwhonym0F30UJUMih+SOQ+n90f+bJ9XkdGBCAVvwfqaGU2PuMm2rlpgw7raIkt4ofLDOGN/HvMOG9LKK00sTpqiz+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m5mucb1w; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47253319b8so4657260a12.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 18:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756257456; x=1756862256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hDESIOJq8GHv5dleoVDtYkEZhqiLbfLFs2YCzs5D4Ss=;
        b=m5mucb1w/VrUDgJRSv1mt1Y6wCMnuTa3DtWy/73itnL6zZJPsxTr9Aw1SJi3GcrIkJ
         hCXTnaY6fV57wuDmMh5b1tdCB3JEN9w52gVeJXQpU7L8Vmqv3XIUKj47seG03LyJSzfH
         S5fDhl5K8H81CljHetFnycjSUgF3Umc5ny4perQAhnNVG9EGt0GUwYHVz8b10QNhmU66
         9AigaqBjuoFUgcvVYntyIarSVvrYZrFV4JLC4lmb9fOr9IYFugqwwncga6J0rRrhLM+P
         Ui82+HX06veApzA3tOmdxUoBYWblLHc3LXZ9OuhTHSaLrSKYWYAL9IEx1IXPpiDovMLf
         a8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756257456; x=1756862256;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hDESIOJq8GHv5dleoVDtYkEZhqiLbfLFs2YCzs5D4Ss=;
        b=Td5eFD5RA0YYoFfTX9uKxZuZjUsPdXNuNkbwea6UNgpwyx5CuY46IPjq8tlf6KTz0J
         d2kRDjx1KgcQElAmkEIvbRnbYcWT92XBD/hamy8S160fP3ibgpK5pG/alJdOcfxhPdM7
         N8qPEv5PvP7PJOvvt6AVDBTiFn4XCwG5+hZX5pQqWwY1bTf5KD3j99sPgriu5FvjU1y8
         AcYS5DiIGac4QRQgbxxTNIdHBZyBGTcNEGcdF5DqPKFIxdWjEFv7aAwWHMwlUKYsdPDI
         Mz2B1Zxy9DvLAdBIlwLvSS46tXtAE9hU5WfejzE8DViRV/Qz+T5wmqaJd+6TckSXkeAj
         5K0g==
X-Forwarded-Encrypted: i=1; AJvYcCUt0qF0blXkAGM8ifGHj4xqC0XcT08alHOpgUtAH5hIgfGb7dRVZXEl4rHfaiHB4iEgvn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkAdoZHeTEuopeR1kolpg4m1p+7UX+L+229TwBaAFhev4xMmoJ
	ZKGr1/cxC8eZUjHiJQpf3cxm3HZcHEL7lU9Lpg38Ou4ltU5JzW269yHmFpyKSm6D1a2Ve2WNaSV
	hog==
X-Google-Smtp-Source: AGHT+IFjtzHGaTxpxi30GJGaLGFgv4pvH06ELVsepE1h5HQgDVvsYE0JxfNlj1RO3Kkx4BD58wttxPGckg==
X-Received: from pfbbe16.prod.google.com ([2002:a05:6a00:1f10:b0:76e:313a:6f90])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999d:b0:243:78a:828c
 with SMTP id adf61e73a8af0-24340def5edmr25359829637.51.1756257455928; Tue, 26
 Aug 2025 18:17:35 -0700 (PDT)
Date: Tue, 26 Aug 2025 18:17:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827011726.2451115-1-sagis@google.com>
Subject: [PATCH v2] KVM: TDX: Force split irqchip for TDX at irqchip creation time
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"

TDX module protects the EOI-bitmap which prevents the use of in-kernel
I/O APIC. See more details in the original patch [1]

The current implementation already enforces the use of split irqchip for
TDX but it does so at the vCPU creation time which is generally to late
to fallback to split irqchip.

This patch follows Sean's recomendation from [2] and move the check if
I/O APIC is supported for the VM at irqchip creation time.

[1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
[2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/tdx.c          | 6 ++++++
 arch/x86/kvm/x86.c              | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..6a4019d3a184 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1357,6 +1357,7 @@ struct kvm_arch {
 	u8 vm_type;
 	bool has_private_mem;
 	bool has_protected_state;
+	bool has_protected_eoi;
 	bool pre_fault_allowed;
 	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..9637d9da1af1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -658,6 +658,12 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
 
+	/*
+	 * TDX Module doesn't allow the hypervisor to modify the EOI-bitmap,
+	 * i.e. all EOIs are accelerated and never trigger exits.
+	 */
+	kvm->arch.has_protected_eoi = true;
+
 	kvm_tdx->state = TD_STATE_UNINITIALIZED;
 
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..57b4d5ba2568 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6966,6 +6966,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		if (irqchip_in_kernel(kvm))
 			goto create_irqchip_unlock;
 
+		/*
+		 * Disallow an in-kernel I/O APIC if the VM has protected EOIs,
+		 * i.e. if KVM can't intercept EOIs and thus can't properly
+		 * emulate level-triggered interrupts.
+		 */
+		r = -ENOTTY;
+		if (kvm->arch.has_protected_eoi)
+			goto create_irqchip_unlock;
+
 		r = -EINVAL;
 		if (kvm->created_vcpus)
 			goto create_irqchip_unlock;
-- 
2.51.0.261.g7ce5a0a67e-goog


