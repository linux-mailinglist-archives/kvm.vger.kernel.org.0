Return-Path: <kvm+bounces-57833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1873EB7C53B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9C23A4E26F1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 09:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269B234A33D;
	Wed, 17 Sep 2025 09:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="hW2r4C7z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC4F34572B
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 09:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101324; cv=none; b=ssG0sRxqdRXdKGryg9lYxFC58NWpSbde8zQvCd0yW+XlNDg87BcfI0yqd+IbDJzImE0OxhSEIvxHhvGCaFedBOg5xBuxYE5L57ni5S7jtiRC5xfr6OPSyJkQr4QAZrxcVsCOcYAMH05gLWHFdMbtwesHVG3ZcvuX4byg9UfSJUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101324; c=relaxed/simple;
	bh=eUrR4NP72EKznEUzfrQ6RmdmdpoU6ltR0MbO4Ojo8Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvTnzIlN6CIbhnnCdKwVPlB54aVb+3uc4hfOybDd+vFSZcXYQdWZ0vLvMJT7COjHjewY3FDaOWCV9VZkMItakO7qmxnfo01xqLF1yUjwD4ZiPGq/OFpGzclyjhE5wluLSP1sewJBUTnUl+kW52+ep9NlkwB/IxuPk3+CpquIekM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=hW2r4C7z; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-267fac63459so9108375ad.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 02:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1758101322; x=1758706122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lSDpgMZajVKYY0uCSDb90s/Pt+KK5ftnBEiQn/IXqA=;
        b=hW2r4C7zbLW/qK1X5VOp71dVhRAQQhnoZbxaCfdFo+cGs+GCEDEskzZmnW4Ba8I4cQ
         CBy4DPFsZj9PzD823R3xGWUo/bStErnWGk1aIXADI5kak3SnypPPZk08jUMH96uXCXx0
         nh5Jc5urQ06r2Ci/wUQH3Lgo/+oClveMdrrUL0IP77bo9bdWTI3WMFH12LFZXVkxj7Bc
         ldVqVobquLYNsR4BXT7jbhQuPtmTDi+1cxCxx8hQCi7ljlGbH5+jpcJpSvMfISde6HEa
         0jIK0m99ZNhykEtnAjjQCug+UaeIBez9hdsPRVptGjtcKAo4AhLuaJmKGJycWjCzcXZT
         qqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101322; x=1758706122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lSDpgMZajVKYY0uCSDb90s/Pt+KK5ftnBEiQn/IXqA=;
        b=ad81VB1UQ3G4WDW07vO/N9Eo3Wso1b8ZLydBBsjBjfCGH6Yz1afSTyNcvHBb0fkx1D
         RgO2HLcfGjcs63IZzxt1ghh5vgTLiVTPlbPHcmyLBuq6hHW4ck5KT6rsZR5no4t1//FD
         U035YZNMCIONjlEi65aIKvwaJut92kfToxFEnVKDIFDro2GGztK7n/hyazuQ2MFH4EcK
         F7CY46RlOAA5m5ursYxBaWf/MolhsJnpjbaGbAhial2TB0r3BnjbWfJeAzJgAtDMOwhU
         BK3+6K/skEzdybg/zMyZYwj7gN97H0m/lunZLFb+KOoadjN0oEGDJ/M1GjivsHld8fdc
         LkoQ==
X-Gm-Message-State: AOJu0Yy0nC4YeSynHxti0d4OkkzWS5C3dsR6KuSWmbqeLnBgeeW+QS8v
	C08KuhaiGJwIke3WNQ2Mvc/exTlIdzpDFVERT6CcpU3ctNBOroMlQIQZRN/mgHfLexc=
X-Gm-Gg: ASbGncvG9dBWbjHC7xyBIcXraU+N5uE1tAPAJcCfAIYGryYyJY5ks7xySKQkVDipAEi
	2IZO37aNd2q4nCbMd7KoChTZoE/qG3seqQa+M/IVN5rj5QGuawcybhs42vzQEEHpbgLjFIwKes1
	2AoQT1enIe/F5Vc7GuPdbAhMlMCgfRqlQ/OT+TZr4h2GoCxcvW++1/giddixdLCCIlhaos8VJkR
	4w5NX79PuJPw4NyF9sTBEv1J4YMiAPJ3970OrHErh22Tv8TuYz9gZdjdoKpTUVNo+aIRZFlQOc4
	5ZJ2w84o2U9mP1UDMfMUmJSS4IA5byh8FDC4fa/lBRqCehmxnP2ADGn/8gAgcqn3zYDzxVh02Vb
	84qg+C4drSCbH6k+p9bqVMeQ/pePDe44ESoppUWADSWrGPFhpj14=
X-Google-Smtp-Source: AGHT+IEjfRijYq0VwSv+OEvYQ2UAxv0++/v+P+9EkS/eMiH1jCSd8Xml7DcvHul7KRrKoeKUOK/rzw==
X-Received: by 2002:a17:903:950:b0:267:b308:c614 with SMTP id d9443c01a7336-26813cedefbmr18895185ad.50.1758101321484;
        Wed, 17 Sep 2025 02:28:41 -0700 (PDT)
Received: from localhost.localdomain ([193.246.161.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25f4935db09sm137047885ad.61.2025.09.17.02.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 02:28:41 -0700 (PDT)
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
Subject: [PATCH RESEND v1 2/3] Revert "x86: kvm: rate-limit global clock updates"
Date: Wed, 17 Sep 2025 17:28:23 +0800
Message-ID: <20250917092824.4070217-3-lei.chen@smartx.com>
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

This reverts commit 7e44e4495a398eb553ce561f29f9148f40a3448f.

Commit 7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
intends to use a kvmclock_update_work to sync ntp corretion
across all vcpus kvmclock, which is based on commit 0061d53daf26f
("KVM: x86: limit difference between kvmclock updates")

Since kvmclock has been switched to mono raw, this commit can be
reverted.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 29 ++++-------------------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41e4fe91f5e..0a1165f40ff1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1435,7 +1435,6 @@ struct kvm_arch {
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
-	struct delayed_work kvmclock_update_work;
 
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_hv hyperv;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 399045a384d4..d526e9e285f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3404,22 +3404,14 @@ uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
  * the others.
  *
  * So in those cases, request a kvmclock update for all vcpus.
- * We need to rate-limit these requests though, as they can
- * considerably slow guests that have a large number of vcpus.
- * The time for a remote vcpu to update its kvmclock is bound
- * by the delay we use to rate-limit the updates.
+ * The worst case for a remote vcpu to update its kvmclock
+ * is then bounded by maximum nohz sleep latency.
  */
-
-#define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
-
-static void kvmclock_update_fn(struct work_struct *work)
+static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 {
 	unsigned long i;
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
-					   kvmclock_update_work);
-	struct kvm *kvm = container_of(ka, struct kvm, arch);
 	struct kvm_vcpu *vcpu;
+	struct kvm *kvm = v->kvm;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -3427,15 +3419,6 @@ static void kvmclock_update_fn(struct work_struct *work)
 	}
 }
 
-static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
-{
-	struct kvm *kvm = v->kvm;
-
-	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
-					KVMCLOCK_UPDATE_DELAY);
-}
-
 /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
 static bool is_mci_control_msr(u32 msr)
 {
@@ -12698,8 +12681,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
-	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
-
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
@@ -12806,8 +12787,6 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
 	 * be stopped before IRQ routing is freed.
 	 */
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
-
 #ifdef CONFIG_KVM_IOAPIC
 	kvm_free_pit(kvm);
 #endif
-- 
2.44.0


