Return-Path: <kvm+bounces-57832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41993B7F042
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBA0582243
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 09:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1074934575D;
	Wed, 17 Sep 2025 09:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="x/EcPSuU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF1343D91
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 09:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101320; cv=none; b=iZPFBi0feH9Ct/s7hHYhCzsBOV2flmnGqvkdrXGQwySjspmWEZGkEDIKVDmYWke6iAXyiAVSloV6vj3of9TPL57wv2B3/OqpZdvcTF2nA6GJNp0S/24iFr+RUjkVQpFjjXWguB9t7LEPLVJ8qUcUA3r1gFMaIwC7ThjnTN7iEHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101320; c=relaxed/simple;
	bh=Mapi4qRO18JNApuqaFmvuJzPJiuchg7jIC/0OT7vifs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKqKzqaTGaE1WBN/QL0WsFDUBptRE5rj+JTK9MIyxEanRZqYfZlBtvjrk4RnptnkGfVFQRFkwYA5VzPsRnVx/zB1QBDljjDRqISdK64gNlSbwU2hTo6YmMqlrwc2S7WfA0BHstTUmjQdWg42lltsJHC2rMXCd3QHG68P3vwiKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=x/EcPSuU; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b54c707374fso2341672a12.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 02:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1758101318; x=1758706118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8j1xWi8yHO61hmZJR2yMfuKWLMhG/TRDNgL+UU0ZcBE=;
        b=x/EcPSuU+lAPQL78GTrl1pLUr5KZEhTRcU0MB58zX/PfF3F9bIFaSwLSUUnIOCIJnU
         xnHDihNrJqNp2k+LUuqspEk/lHSjDPIW3BtCa866rY11mUYR2hN4coQpftxS6oTXzcaW
         qSaM3C1bUlOz5HrY/9UX4FCeTYqMK7ciol7n3E2/Pd1j67RAEbqaF3xIZKHay6UY5ebY
         eSvbrMmj5cBJhMcmLKUN4Eta5ESAwyYfGYbfugbUO2yuWfqybVegQhjRQ+aXIinqP7dL
         dLL4cm9akoWhNBJ+6Yx3awmFZEnFXfMisRcwb63fNuCsP4m9PDFYklPab3QFYnP5ZWxx
         jyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101318; x=1758706118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8j1xWi8yHO61hmZJR2yMfuKWLMhG/TRDNgL+UU0ZcBE=;
        b=E+BEE0XEFS5m7DO2q/nOvLtnO1m2ozVOR6qLdqe03dDVdv4ymu4ggr/H2DElh069C0
         2DSsi/n2hYbGXPPsfDdRpck+Yt85pDt2fuu4upLW7xwuNYNKpSYMlr6CkPyV86UzTFZl
         My2hrrGKLTnquT1LYS99ttp1zTPvOEpCFvfZqwp2h77XD7sx48qT2jWJ0Ju1op7iQL4P
         3KRMWddbrTF2b9IvJfaSRxErS4xf0WCRra12ZrUFSKRMjuRyE38IUBiFWzAzZl440E7g
         4ZOIXxXDPiTEzlBYEKofuEBilEF+lsVkze2IAzpVcpGlM0BERlafkj4B38OjtpFblyPT
         KXYw==
X-Gm-Message-State: AOJu0Yy6vDrCks2plocVeldxfMv33ncZtcDrmoEsta8pq9YTtZRPd9u8
	MKD3QPVHPwL05lQvlhQuADI98y3xZtgVdGO0B6S+sip2DuCCQqapFQWqPALd+IsLRJQ=
X-Gm-Gg: ASbGncteU9itgenW374LGrEJgTGNg6Tj3Wt5VwNDnWDFv8OP3enrpK+L3Z1uarsYoFs
	/EGWkm7KcbvVS4B9hdi6Mo309gKdJCWsOQUzuGhxfsTa1616EpA2ZR2qxXN5NM0g8GwiATPwV9E
	cIsU3zvw0bBVQvfU5L0sq5TpXwcU4yq5GCVm93Vv5oIORTPGTA1rBMpeDH2kbGr2K5+d6CoZ9Er
	eY9ELPxqPs64nlQn/Xff6uj5MTBhdWgZBGK9AfnxHZyDdwjxpG95qVtYvI96WqEMcBmGxfKZJp/
	4Xm/L1tzkN+DWfINDiwABpk3h4Y1cFQcU3KjPNnc/dFjqMc005yRG3fUvvkTmcBrad949f7Fepd
	2NesPt83XxBBhnKzxuTpHpUGgbIIjGEgSrtoRJGZ6wtNMfhZzRVw=
X-Google-Smtp-Source: AGHT+IGrUlWL0tzfLtquvrJRbqTi99ooOO3SYsnEAMGANiYtwIWUXXJnYFIYJ1snMKEuZ1H2K+q1RA==
X-Received: by 2002:a17:903:3585:b0:259:5284:f87b with SMTP id d9443c01a7336-26811e87273mr18453755ad.16.1758101317378;
        Wed, 17 Sep 2025 02:28:37 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25f4935db09sm137047885ad.61.2025.09.17.02.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 02:28:37 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v1 1/3] Revert "x86: kvm: introduce periodic global clock updates"
Date: Wed, 17 Sep 2025 17:28:22 +0800
Message-ID: <20250917092824.4070217-2-lei.chen@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20250917092824.4070217-1-lei.chen@smartx.com>
References: <20250917092824.4070217-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 332967a3eac06f6379283cf155c84fe7cd0537c2.

Commit 332967a3eac0 ("x86: kvm: introduce periodic global clock
updates") introduced a 300s interval work to sync ntp corrections
across all vcpus.

Since commit 53fafdbb8b21 ("KVM: x86: switch KVMCLOCK base to
monotonic raw clock"), kvmclock switched to mono raw clock,
we can no longer take ntp into consideration.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 25 -------------------------
 2 files changed, 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..e41e4fe91f5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1436,7 +1436,6 @@ struct kvm_arch {
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
 	struct delayed_work kvmclock_update_work;
-	struct delayed_work kvmclock_sync_work;
 
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_hv hyperv;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..399045a384d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -157,9 +157,6 @@ EXPORT_SYMBOL_GPL(report_ignored_msrs);
 unsigned int min_timer_period_us = 200;
 module_param(min_timer_period_us, uint, 0644);
 
-static bool __read_mostly kvmclock_periodic_sync = true;
-module_param(kvmclock_periodic_sync, bool, 0444);
-
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, 0644);
@@ -3439,20 +3436,6 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 					KVMCLOCK_UPDATE_DELAY);
 }
 
-#define KVMCLOCK_SYNC_PERIOD (300 * HZ)
-
-static void kvmclock_sync_fn(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
-					   kvmclock_sync_work);
-	struct kvm *kvm = container_of(ka, struct kvm, arch);
-
-	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
-	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-					KVMCLOCK_SYNC_PERIOD);
-}
-
 /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
 static bool is_mci_control_msr(u32 msr)
 {
@@ -12327,8 +12310,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
-
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
@@ -12339,10 +12320,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	vcpu->arch.msr_kvm_poll_control = 1;
 
 	mutex_unlock(&vcpu->mutex);
-
-	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
-		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-						KVMCLOCK_SYNC_PERIOD);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -12722,7 +12699,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 #endif
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
-	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
@@ -12830,7 +12806,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
 	 * be stopped before IRQ routing is freed.
 	 */
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 
 #ifdef CONFIG_KVM_IOAPIC
-- 
2.44.0


