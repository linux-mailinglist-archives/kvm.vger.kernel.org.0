Return-Path: <kvm+bounces-42340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF5DA77FEC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 287C33AFC33
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867B62147F6;
	Tue,  1 Apr 2025 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akd/liQU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB449212FBF
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523893; cv=none; b=AN/mhCnCIJ9Vygf+3mrvvjxPkHQxbtRykU3omrpwi1JQMqhTGuAUzPtl9qY3HopH1AsxLf33qlxiInWp30mp4euzWaJWAFpH9TVsETkuZshW5j1PFZB2wvE1oEWyn4RHTPJqXdb4BGDoqD+ELQnzi1rKvhmAF5/tJFW8T/jT/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523893; c=relaxed/simple;
	bh=ZfkfOM480M1YBqKpC2/kM72sR6VmePA1K6dauSV8B3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC9z8ohrKR2hm3FwVCiHlD2bXNAixvsRNdPzyHBDjNE0CV5J6pCC9gMOfEqDhCYz8BwCABN7wCeDg7AkI9wQHITVL/xlBn4//fLlEB6mVggFflUIYJuqp3fdYR10JPg9RA0Z0RacHNnpFAJIf5s4XDHroRXIvfGJ0mlTVc0SgO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akd/liQU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KsKBW7BEHbNNA2EQflKemABN/u2ulObIcmH48WXDJ8s=;
	b=akd/liQUR6vnxyv0Of6erdwoSLBfssYhhckFNORUYPszqJtuwETxh8YSxJNEdsGnvQjjbN
	vptIjSFdpwuVzrTzanr4frNBrAwtnHzc/swdZJgX0i/t2ta88nBf6SJTiM9R/Vougehdvn
	Xm96tfhxA4Tog7qazmRQEm4d8pSrqoA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-_A8MSWlnO06N9vchG2PK5g-1; Tue, 01 Apr 2025 12:11:29 -0400
X-MC-Unique: _A8MSWlnO06N9vchG2PK5g-1
X-Mimecast-MFC-AGG-ID: _A8MSWlnO06N9vchG2PK5g_1743523889
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-438e180821aso26461165e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523888; x=1744128688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KsKBW7BEHbNNA2EQflKemABN/u2ulObIcmH48WXDJ8s=;
        b=ZNnNSKNaV7aDRvJSi8LVDodV9s5ub8tOcKH7+w3tQoQEEwl5PEryqCpPt81zz0lbGM
         F+k+ysWrX2n8rhps+DivPlriH/GUYm+ALoNDMZh9VgcvTkBLAvnNXFUABw1DmOTLdXql
         siwjj1mLW1CIdZyJnfFJrOpXwZNmTE1Y16HIrf0zbWAMNpOkLLrEJc8/z9HEUq4G6+yK
         qr3Fl3Zm1zqVJ2oIS5a7xbHUT/RELtQMF6ZeXg2Z1kRO2wDoXugy/z1olR5dBN40ziu3
         reCW/nuVJvZwyhgWGMsP9jlawt+znCC+knKzHsRzHptnyHnBFgIV5nyAUu2w/aTpeGo2
         VKIw==
X-Forwarded-Encrypted: i=1; AJvYcCWy4ZqzuLOdAki7RboHFG80ckPHV4nwX20ce3hkmeQDlaU+Y1OCF3jq+qBJP0jinzYMon0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCFKlDgR7ha5gLlGgEyCChyoe90IvkfiSrL8R22CRT7IIN/qqc
	VryEi5yWo21vghhB1cZ4mASExzRb0cM5+2J4sHDRqi3xi4mu1K8dDuvE00Dalk9g20DGREsvTBL
	dl1wtkYSoW4tLY6w9qO7wL8w4pEqxDnWfVexG3UT0ndszJ9twzZ5fEBPdWA==
X-Gm-Gg: ASbGncswHHGYJvQvxQhhCXUWYbLKUAdFDDnvV6x6727UlV8xpYe92f0ZmMQ6L+RN5cX
	7Z+Ii/P4oGDfh4OCcVmSQzUQBytPS2L/i3GdtYUpt6UkSH0vVAJy3bOMnqWTu/F1GyKnxT1s6oc
	1d0YIJ3U/6ok2rOiL1PiS4jZnFaJp/PfTPLrnAhci6K34t8a/9g6RQy3yU8oTQ3hRDhVGUECuQz
	c2VrJmoeen8I7C/MjS6vy8U7DuRaKTl5sBSdJIU28eLI4vQPgvlxUGDR4Ui/u0FFo5twwmiAzbI
	uEqM2CKlLTkpP8IWqpVfrQ==
X-Received: by 2002:a05:6000:2410:b0:39c:142a:35f9 with SMTP id ffacd0b85a97d-39c142a35famr11329187f8f.10.1743523887461;
        Tue, 01 Apr 2025 09:11:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUBBONFMxXubuB0rFZnmFR8I8IBPlykXIOGysFwqjq21RAjnf88FJ3fTcF64SWlqgmRjwgcw==
X-Received: by 2002:a05:6000:2410:b0:39c:142a:35f9 with SMTP id ffacd0b85a97d-39c142a35famr11329136f8f.10.1743523887070;
        Tue, 01 Apr 2025 09:11:27 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66a9d2sm14476457f8f.43.2025.04.01.09.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:25 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 07/29] KVM: do not use online_vcpus to test vCPU validity
Date: Tue,  1 Apr 2025 18:10:44 +0200
Message-ID: <20250401161106.790710-8-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Different planes can initialize their vCPUs separately, therefore there is
no single online_vcpus value that can be used to test that a vCPU has
indeed been fully initialized.

Use the shiny new plane field instead, initializing it to an invalid value
(-1) while the vCPU is visible in the xarray but may still disappear if
the creation fails.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/i8254.c     |  3 ++-
 include/linux/kvm_host.h | 23 ++++++-----------------
 virt/kvm/kvm_main.c      | 20 +++++++++++++-------
 3 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index d7ab8780ab9e..e3a3e7b90c26 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -260,9 +260,10 @@ static void pit_do_work(struct kthread_work *work)
 	 * VCPUs and only when LVT0 is in NMI mode.  The interrupt can
 	 * also be simultaneously delivered through PIC and IOAPIC.
 	 */
-	if (atomic_read(&kvm->arch.vapics_in_nmi_mode) > 0)
+	if (atomic_read(&kvm->arch.vapics_in_nmi_mode) > 0) {
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			kvm_apic_nmi_wd_deliver(vcpu);
+	}
 }
 
 static enum hrtimer_restart pit_timer_fn(struct hrtimer *data)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d408d1d5ccc..0db27814294f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -992,27 +992,16 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 
 static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 {
-	int num_vcpus = atomic_read(&kvm->online_vcpus);
-
-	/*
-	 * Explicitly verify the target vCPU is online, as the anti-speculation
-	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
-	 * index, clamping the index to 0 would return vCPU0, not NULL.
-	 */
-	if (i >= num_vcpus)
+	struct kvm_vcpu *vcpu = xa_load(&kvm->vcpu_array, i);
+	if (vcpu && unlikely(vcpu->plane == -1))
 		return NULL;
 
-	i = array_index_nospec(i, num_vcpus);
-
-	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
-	smp_rmb();
-	return xa_load(&kvm->vcpu_array, i);
+	return vcpu;
 }
 
-#define kvm_for_each_vcpu(idx, vcpup, kvm)				\
-	if (atomic_read(&kvm->online_vcpus))				\
-		xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0,	\
-				  (atomic_read(&kvm->online_vcpus) - 1))
+#define kvm_for_each_vcpu(idx, vcpup, kvm)			\
+	xa_for_each(&kvm->vcpu_array, idx, vcpup)		\
+		if ((vcpup)->plane == -1) ; else		\
 
 static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e343905e46d8..eba02cb7cc57 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4186,6 +4186,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 		goto unlock_vcpu_destroy;
 	}
 
+	/*
+	 * Store an invalid plane number until fully initialized.  xa_insert() has
+	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
+	 */
+	vcpu->plane = -1;
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
 	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
 	WARN_ON_ONCE(r == -EBUSY);
@@ -4195,7 +4200,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	/*
 	 * Now it's all set up, let userspace reach it.  Grab the vCPU's mutex
 	 * so that userspace can't invoke vCPU ioctl()s until the vCPU is fully
-	 * visible (per online_vcpus), e.g. so that KVM doesn't get tricked
+	 * visible (valid vcpu->plane), e.g. so that KVM doesn't get tricked
 	 * into a NULL-pointer dereference because KVM thinks the _current_
 	 * vCPU doesn't exist.  As a bonus, taking vcpu->mutex ensures lockdep
 	 * knows it's taken *inside* kvm->lock.
@@ -4206,12 +4211,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	if (r < 0)
 		goto kvm_put_xa_erase;
 
-	/*
-	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
-	 * pointer before kvm->online_vcpu's incremented value.
-	 */
-	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
+
+	/*
+	 * Pairs with xa_load() in kvm_get_vcpu, ensuring that online_vcpus
+	 * is updated before vcpu->plane.
+	 */
+	smp_store_release(&vcpu->plane, 0);
 	mutex_unlock(&vcpu->mutex);
 
 	mutex_unlock(&kvm->lock);
@@ -4355,7 +4361,7 @@ static int kvm_wait_for_vcpu_online(struct kvm_vcpu *vcpu)
 	 * In practice, this happy path will always be taken, as a well-behaved
 	 * VMM will never invoke a vCPU ioctl() before KVM_CREATE_VCPU returns.
 	 */
-	if (likely(vcpu->vcpu_idx < atomic_read(&kvm->online_vcpus)))
+	if (likely(vcpu->plane != -1))
 		return 0;
 
 	/*
-- 
2.49.0


