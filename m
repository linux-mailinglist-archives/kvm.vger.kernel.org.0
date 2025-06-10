Return-Path: <kvm+bounces-48916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE3EAD4664
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5938F174801
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C706E2D5405;
	Tue, 10 Jun 2025 22:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gEjK2GZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F202D2FDF
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596317; cv=none; b=ZxOk2+L7FP5yFACUjlXcp4Ca5kYSrphAWp7vknhryXWfSZcqQ5+agv+zQYdD2Lg3a99YHad24qqjAdM7/G2ad3Ny2rdfXaFZYQGcYw0q2rv1pbkXVpsD6W3uwtqH85rP6haLDYTdOBaHFkFN/8yKL0KRTwIMGyxErWhDJpKP7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596317; c=relaxed/simple;
	bh=DWYkexeKvSu7I+q/pf14+u2gmgqyLF3ul0cydoTKzVc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nct2hw4twGYQKTFtWwVR3Qd8tsktZ+tM0u6ameekMlWjiI9QYIkCATSyjb/nQ/q9hp76WMFJxLYPxeewBDrPmrzXnacZEGfa1sFqr6ZltBEdMUHzyzuS4zHyI7xTRW3pDFKZfHFDwtcVuPpBiA5GJYWZUhAbeac7u9zL70xXZyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gEjK2GZ7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d70d67so53658935ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596315; x=1750201115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3MRV7X/T/wn0+SAUz4kSzbvtBEQulMMmWQ/PWJl9FfE=;
        b=gEjK2GZ7FBCVu4Z4r3wGgZgBvV67vph5bp9yZvmxwKIPHHr5fNKROr13ZOKsyL3XYO
         OUiUHurP604rAfTmviJIvJGvfWZvzkUXugngaS3q1qKdZeKEPvx584pdqyZwy7FZyzeR
         BhDZCH9eB6V0oll/lUL2fybq59IwHJkReMMldWVBK6F6hbZ4noFGIhRUw10bA5eAwddJ
         8YXNuEGmCfG5jxiPxTPJbV5XydZ7J1hl3F2zjfEqkazSQ1TPHGJSbiH4RQRQGpi+RHip
         gl6ylBQcrwdJsY+wXw4XMtdS1eSeA/dU6adwF1KppkHLovsqgIN24XSvtaBu/DCuXF87
         3i3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596315; x=1750201115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3MRV7X/T/wn0+SAUz4kSzbvtBEQulMMmWQ/PWJl9FfE=;
        b=UJAGlPSWk8gVRza30S4rO1orfmRYKKOYPUZezeL7ed/8gsYpPUGdoweJNwTvqRXlW7
         KOx0O/4Butfqaq73IkNsxLOdoNUeYtn8ViNmca0s0LoAzqXIRulofm5Tc5APOZPC4r2c
         E8qYHRvQqlNej2Itschwh2WtASdc1W07qptzIA/bmd2XSBSIMtxWwf2ZIKlMbxgkS2Nz
         rOV0aVtsLAaX3ka7vw8Jg0nft+qC8+gW4PES4MXgzSNrHnQbU+9acYuxC+u1uAbcG6Uw
         urlq25RL+orEyPq27/ni3DP5PWenmEPiIt2QBI0kNX4aQMGhmrBd9uoWE+3gCt3rbxBY
         iZDg==
X-Gm-Message-State: AOJu0Yx3i1vA2MZ4Xt7uWr67pHd/W1jvfIZckEEuv7jlwNp3yqADHzb+
	IsZb6UZKJLePHuuJy9uCUWeWkX7GjGJ5jWfGGwo7MFOqQgBzqahq1jJdtK5D7FnXwE7TkBP/r5w
	jDmngGg==
X-Google-Smtp-Source: AGHT+IGiTLrz803hh++30xy8fSjN6gixKMJv7/AiyKAlh/XmQx+ffUbEPds8P01hoGQ+qsG4Qote79BJ1DE=
X-Received: from pldg6.prod.google.com ([2002:a17:903:3a86:b0:235:6d5:688b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc1:b0:234:ed31:fc98
 with SMTP id d9443c01a7336-23641b14d61mr11802615ad.37.1749596315046; Tue, 10
 Jun 2025 15:58:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:37 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-33-seanjc@google.com>
Subject: [PATCH v2 32/32] KVM: selftests: Verify KVM disable interception (for
 userspace) on filter change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Re-read MSR_{FS,GS}_BASE after restoring the "allow everything" userspace
MSR filter to verify that KVM stops forwarding exits to userspace.  This
can also be used in conjunction with manual verification (e.g. printk) to
ensure KVM is correctly updating the MSR bitmaps consumed by hardware.

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Manali Shukla <Manali.Shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
index 32b2794b78fe..8463a9956410 100644
--- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
@@ -343,6 +343,12 @@ static void guest_code_permission_bitmap(void)
 	data = test_rdmsr(MSR_GS_BASE);
 	GUEST_ASSERT(data == MSR_GS_BASE);
 
+	/* Access the MSRs again to ensure KVM has disabled interception.*/
+	data = test_rdmsr(MSR_FS_BASE);
+	GUEST_ASSERT(data != MSR_FS_BASE);
+	data = test_rdmsr(MSR_GS_BASE);
+	GUEST_ASSERT(data != MSR_GS_BASE);
+
 	GUEST_DONE();
 }
 
@@ -682,6 +688,8 @@ KVM_ONE_VCPU_TEST(user_msr, msr_permission_bitmap, guest_code_permission_bitmap)
 		    "Expected ucall state to be UCALL_SYNC.");
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
 	run_guest_then_process_rdmsr(vcpu, MSR_GS_BASE);
+
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
 	run_guest_then_process_ucall_done(vcpu);
 }
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


