Return-Path: <kvm+bounces-48350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9591ACD06C
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 01:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69AE3174653
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D221222D9EB;
	Tue,  3 Jun 2025 23:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yTSEki4p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D22221297
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 23:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748994878; cv=none; b=HXYkDXlcOPXsq/JsWKcbQJmodOc6OLpL6XskYl1Ub4yYVMJZ/79ogTPYxtBmknd2kOKkB39CMYH3rXRmXgmJJpkhii+nx38fIogX3OJs0FBiUZCBI0HNQGU1ikASI6IklZOmAsskhH1yxKCs5qH/awlsDaJJtWXbCzXqmduEFjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748994878; c=relaxed/simple;
	bh=9ASD9ycMPtkM9dPjvSfFxsRy05y+Mn+r07/r9WPocGs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XadA8h09RGo6SF9FQDOCcsICAkkVWB8Gc3C3u5yJx+X3YVJw4pw6IzjJ8norgit3mngD1ER151gVyrLNhQLRhKS/DALC7eRmFvvbFCnLoSrz//pzvpkhzYEF3IR1PdBmW9/udOinUbEcdOf82WfCy7Br9RkEuNgT9ukrdauZLF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yTSEki4p; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso276427a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 16:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748994876; x=1749599676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYCdI51CtfR2i0jvG6CEJfAT09sbYVQ9XSZtoW3oF8E=;
        b=yTSEki4pMBaJZagN+8jnvBbJR2a7LoEI+lqAkLhk4/sJOAQtGbKHCcHutxNxlPdRI+
         8Opv98bwaD8egjRNpyx17CneaHQFkH98FLdS0aVERWiBFe22ePGMPQ4xzUlKFhZGM+bX
         /jW0xxdYMLOkEqg40LTJwfHHGQU+T/5MUMUiSkheZ9QnLR0x1SpkhXToXDNwdFkw5RiX
         G3F5lMofYfJ2ClxDQXuxQx7Y+91aast5Nm/IpcUFGYs2qYf9ba+RguUYQzsEMv1RCRBH
         BeBsGOUKAy+BeNP9JoE8YRjjiMWJ/CpZXU7rqUPObiwTrmtFJy2Rzn566RXNq4i0nm7x
         fLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748994876; x=1749599676;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GYCdI51CtfR2i0jvG6CEJfAT09sbYVQ9XSZtoW3oF8E=;
        b=X1uaksXdJufkDCc9pIOEyXkvTXjnPQBqQRFbB6KVQ5hPP+z8L1AgcV0L5pZsJnBaEM
         kkT8TZpMFMzoU/Q/09t9VRuejVLotpM6sIMfisgodou4aKmt6jKbldVX8yKuNwmtJ9VV
         Z8Qzm2Yj/4U5viHfLEEnZ2VR2sGli9kyAIsO0dXybfvAdMVRukAMad/oBZqbRUy29yUK
         xRhT2WUz2E8ZxC9Hd3MG+ADbSsACC6rbYjqQVAAP/VSWPLLLbqYATSqDYeralzlQzcgA
         KsIjs/fR7G/pDXL6a1udC2pvQAft8yyVkq+pTuglC+Zm5Xr8dQj/1IrFYNVXiFHyfvFw
         WQvQ==
X-Gm-Message-State: AOJu0YwLNH9CW54iQzo7oGSJ2UMik6L7foGox+Jj2XdTmTP/HMppyNlz
	/UJq7pKvtOITlJyORcFg9Q8XGZpSOT2u2lGj0kITPe4djst/1XTd4NVF0DYHLWnxo2B2vgsV0Qr
	A7mJrcg==
X-Google-Smtp-Source: AGHT+IGsQLK1x2EFJUGPw42FipFSPOoL+mzM5c3UeNmGPI/n/Mf+O93eg6pWHcFnp76IB1jvxn2D+uev9xk=
X-Received: from pjbdy4.prod.google.com ([2002:a17:90b:6c4:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2688:b0:311:9cdf:a8a4
 with SMTP id 98e67ed59e1d1-3130db4976amr1306951a91.8.1748994875855; Tue, 03
 Jun 2025 16:54:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Jun 2025 16:54:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250603235433.196211-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Disable PIT re-injection for all tests to
 play nice with (x2)AVIC
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Naveen N Rao <naveen@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable PIT re-injection via "-global kvm-pit.lost_tick_policy=discard"
for all x86 tests, as KVM inhibits (x2)AVIC when the PIT is in re-injection
mode (AVIC doesn't allow KVM to intercept EOIs to do re-injection).  Drop
the various unittests.cfg hacks which disable the PIT entirely to effect
the same outcome.

Disable re-injection instead of killing off the PIT entirely as the
realmode test uses the PIT (but doesn't rely on re-injection).

Cc: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/run           |  7 ++++++-
 x86/unittests.cfg | 10 +++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/x86/run b/x86/run
index a3d3e7db..dc4759b4 100755
--- a/x86/run
+++ b/x86/run
@@ -36,7 +36,12 @@ else
 	pc_testdev="-device testdev,chardev=testlog -chardev file,id=testlog,path=msr.out"
 fi
 
-command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
+# Discard lost ticks from the Programmable Interval Timer (PIT, a.k.a 8254), as
+# enabling KVM's re-injection mode inhibits (x2)AVIC, i.e. prevents validating
+# (x2)AVIC.  Note, the realmode test relies on the PIT, but not re-injection.
+pit="-global kvm-pit.lost_tick_policy=discard"
+
+command="${qemu} --no-reboot -nodefaults $pit $pc_testdev -vnc none -serial stdio $pci_testdev"
 command+=" -machine accel=$ACCEL$ACCEL_PROPS"
 if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6e69c50b..6b33a643 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -28,12 +28,11 @@ arch = x86_64
 timeout = 30
 groups = apic
 
-# Hide x2APIC and don't create a Programmable Interval Timer (PIT, a.k.a 8254)
-# to allow testing SVM's AVIC, which is disabled if either is exposed to the guest.
+# Hide x2APIC to allow testing AVIC on non-x2AVIC systems
 [xapic]
 file = apic.flat
 smp = 2
-extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
+extra_params = -cpu qemu64,-x2apic,+tsc-deadline
 arch = x86_64
 timeout = 60
 groups = apic
@@ -81,13 +80,10 @@ file = vmexit.flat
 extra_params = -append 'inl_from_pmtimer'
 groups = vmexit
 
-# To allow IPIs to be accelerated by SVM AVIC when the feature is available and
-# enabled, do not create a Programmable Interval Timer (PIT, a.k.a 8254), since
-# such device will disable/inhibit AVIC if exposed to the guest.
 [vmexit_ipi]
 file = vmexit.flat
 smp = 2
-extra_params = -machine pit=off -append 'ipi'
+extra_params = -append 'ipi'
 groups = vmexit
 
 [vmexit_ipi_halt]

base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


