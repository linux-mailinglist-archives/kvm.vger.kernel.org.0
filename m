Return-Path: <kvm+bounces-66869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CD22FCEAC09
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 961FB302E874
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A654B2E0418;
	Tue, 30 Dec 2025 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JhWCyteI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDAD2C028F
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 22:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767132147; cv=none; b=dFz0zycLhG350wHLRrbzXmSugsZSvqR0mp7M7TxZZoTBJBU821XBERSjqWjUfnXtUq64u2l6XpbDbLrxUxWLi3nFeJkk1R3cVdzHxpmgUJ/l6fkt8PBKJAupzH5hD7BT54BLmDEUIjQRG7lTdwOH2pUv8OPGNG002gE2YmH3q0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767132147; c=relaxed/simple;
	bh=Ol8Q1P2DspwmDzNsce460hRFuWrj2m2NNQOvDXhcsas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i4oQw9yoY5pk0VPOx11BCF9n8K3Ymn/T+ImRZFy5cijtNfS1cG5LN763ojBKmF4sE+4H0sKvliQfzWEc0smnztX6xS3s4MWyM6UMILqimvoRjgNLtAnFyXtjh4QXHLjuF6zTQNtoKq/usXUlE2n+MM9QS7p9NYQaFSGF2VJQzS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JhWCyteI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34abec8855aso22077724a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 14:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767132145; x=1767736945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jNWfhcrdkoHWZkKVPidQfqfKWfFIUQ2ZGPzX3rKucVM=;
        b=JhWCyteIIoQ+DfsEJ6vAIGUvQGh67+OJapqgPeHyLzUHHqJr9f1XJaa24GRMA1SUV0
         U24JBBdbYPQIYadJMlzGv7Odct+162y0cBz3Jy0J1WNPZlrMC3e2sNSKe8QMxh3s1TzE
         KY9WJi7fW9R6q4nXm2Ezld4Pxk59j19kGuJtFsmup/kTcHYA5r+MYfci2ITMTR0KfDGM
         oIeHsC9pF4GDvwIVaPNhrikC1hzkiQa6r/0li9EdVBxdT/F7+mNMlwccW9V1VTJ7cRpu
         wqdtCPQ7yFJh+VSI4me3RQqoj6BJS+zIUrxE0ZE2lKrZl+m/+fzrYPlL01fdh68Q9Uei
         T0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767132145; x=1767736945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNWfhcrdkoHWZkKVPidQfqfKWfFIUQ2ZGPzX3rKucVM=;
        b=QbcMYRE4MPXTxSFbox49X4r76VtrmzbMcoukAG9iQN2w/Dr5UMOtpwhZE92PU1c9mb
         G6DS9mTX0cnCeaTB5ggfwzlw8u3qPkAVZJn6YO0OogN0ovORIvVrJzZSQkJ5tjhcWYf9
         rD3U1q0rbI7uvPFpWErLHDI9hM6yRDhvzPww1p3pn7WfSh8OOKd/+HhJYTDiEQX1Q6WK
         /EE9J587adPNG4o2MXRv6zTDFyHUoHXuLO6uxANQeG+WItRx2xKxylf2N4tK2oxabqhB
         lK4zRdmlH/PCRy/0tR2m9cpULhqZAj0IeO2iRDXjJnjBwLQqrMFAwkemv6VZvdL2bJqw
         V4Pw==
X-Gm-Message-State: AOJu0Yw+Ux4KJKh2pdqupp64duUQT0o6M6/MstW9dHr87CMnZpygMb6p
	4sc4ywjqqxPkbIpwc1SWdC3Dn0e0bLcvYPzbx3i+F1Ce6DcHR1wohhM+QkHaFTEIeze6BvK/hI4
	PCahAPg==
X-Google-Smtp-Source: AGHT+IHN1J89n4cMOgQCEej01IxvUanktN/Lpxev8oNAKJoKAIUKOTfCKourZVIb+utPYAPKKtYErWGIBRc=
X-Received: from pjj16.prod.google.com ([2002:a17:90b:5550:b0:34c:37db:8f1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e42:b0:341:6164:c27d
 with SMTP id 98e67ed59e1d1-34e92137f6fmr27146295a91.3.1767132145556; Tue, 30
 Dec 2025 14:02:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 14:02:20 -0800
In-Reply-To: <20251230220220.4122282-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230220220.4122282-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230220220.4122282-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Chao Gao <chao.gao@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
vmcs12 fields if the field isn't supported by hardware.

Note, there is technically a small functional change here, as the vmcs12
filtering only requires support for Virtual Interrupt Delivery, whereas
the shadow VMCS code being removed required "full" APICv support, i.e.
required Virtual Interrupt Delivery *and* APIC Register Virtualizaton *and*
Posted Interrupt support.

Opportunistically tweak the comment to more precisely explain why the
PML and VMX preemption timer fields need to be explicitly checked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9d8f84e3f2da..f50d21a6a2d7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -112,9 +112,10 @@ static void init_vmcs_shadow_fields(void)
 			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
 		/*
-		 * PML and the preemption timer can be emulated, but the
-		 * processor cannot vmwrite to fields that don't exist
-		 * on bare metal.
+		 * KVM emulates PML and the VMX preemption timer irrespective
+		 * of hardware support, but shadowing their related VMCS fields
+		 * requires hardware support as the CPU will reject VMWRITEs to
+		 * fields that don't exist.
 		 */
 		switch (field) {
 		case GUEST_PML_INDEX:
@@ -125,10 +126,6 @@ static void init_vmcs_shadow_fields(void)
 			if (!cpu_has_vmx_preemption_timer())
 				continue;
 			break;
-		case GUEST_INTR_STATUS:
-			if (!cpu_has_vmx_apicv())
-				continue;
-			break;
 		default:
 			break;
 		}
-- 
2.52.0.351.gbe84eed79e-goog


