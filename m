Return-Path: <kvm+bounces-46863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 474E1ABA39F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88EF87A701F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B312820AD;
	Fri, 16 May 2025 19:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOT4YVaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C912281374
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 19:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747423203; cv=none; b=u4Kc1uDHOlRwoiqS55CrUPqAp/6P6nUPj2TxqoiKRAuedlSQXhN1T2zSbcedN0gVdIDDAu8sCthuojWdZxVrXF+mVxE5iotV1D7zSX1Yvioo7uQPmixTZCTykyhszT4jzk5tv9FavO5o0F4+KxvyU01JGCAheWcEVcqSsKND5Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747423203; c=relaxed/simple;
	bh=Z+Ymw5KorVqxl1MWcDtTMy/41FachyKB8z3Xc1HhzcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Woi1FT4H7tqkefJz9yZwwxx+ak7k72FY0qKXbZ+RupabAm2udDRf81TQhJ5Ko5bs1+DxQRz/VPFDF9EGProlMzRjBnkZ0nZvpx2EkG/K3D8YzKQT6j0ot5v2jIEW8DWGy9HgY3PcuJI7N5KjhoiQeKZrC/J7TxOuk24kyIHDuxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOT4YVaE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740270e168aso2305913b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747423200; x=1748028000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i+O0+h0SP1zdyUU/AUBngE1nKYK7W0UZEZfvwyilFUE=;
        b=fOT4YVaEe85yMPIq6UbKaGDTj3/KrNF4V3448D7qflMl+JSLnxJufSjNAtQ1huqJj8
         UJKCcQbUb4Q+MRWwZV3EzH2HeriR4XGJAhVozwlykIZX60s9q3j5SCbuZCYa+hGaofKH
         2RMPbjwkGnCcD7/wWXBc48/utGzQDYccVYWjs8pc8zx7SfOyuaeG2wm+rmBD9bqPMlJt
         GJF+8BE0T03MbnljiKYecHZqIGcv586gP1VQlkD+pbnZC6oim5YjVNhCJzoFsRTvpwG5
         z9paIiiYep/nCq7pxCLAkyE8K1FwV22fvYyfPRsIw+P8OzWMpBV0RQpj9X3Z/so/LTMk
         gO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747423200; x=1748028000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i+O0+h0SP1zdyUU/AUBngE1nKYK7W0UZEZfvwyilFUE=;
        b=KfGepRPvfcSa8sNlMdqRwQwwuDgpTcFYf1eqcU9LLcOConOwBScPFNc3Mdzmz9fPU7
         KiTTXlXk5Iu8ODElljkCw5C+tBWDI4b0ZkWUmkYyo/cQTAbbE0f+gaKYtizqbcevsIZP
         dLHkVzGJ49p+OwRlKUokeZBiebM1TGM9uV2AOhtTNnXA2mcwBu7TOWxcVugmHfiZQAw9
         shu7Q6yLvuaFfL20oH8ZqbqpwNBijTQVFgPwE/nYx7knrF/vKH5WsowTQX9RyCXTBSib
         KIgSOyLN68HGvVM7/kivnBaGQj3cAPicybagtujgypPM7kpZKU3dixyJjhuogGYtZaL0
         qP0w==
X-Forwarded-Encrypted: i=1; AJvYcCUIBtaa97MbyVsC5MrTmV697YMB+qF3eXEEwD/xCdA+m65v/SrcBqTDBcjsHWD/UGiNsyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzBIpbwB2rxGW6qobVgX1pbV791oVtrvsRtsR5BVpU/i/yxmgj
	Vfl4sRFjDKcf5vjzKPFKZ50rzGVPuy1FkaAeqFCXNmppcX39wLhdCLYwKvMTY+n06MO7aNWvED9
	M7m4uqEYAGQ==
X-Google-Smtp-Source: AGHT+IG5/VnWZMp1URaxTB5fGhpyao745JN7FMyydoGLfEMB3xGNC9Y03XfePEOK3stFRMn8KrJaxzImVTNi
X-Received: from pfux1.prod.google.com ([2002:a05:6a00:bc1:b0:741:2a97:6ae2])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888e:0:b0:742:a23e:2a68
 with SMTP id d2e1a72fcca58-742a98a2437mr5530195b3a.15.1747423200276; Fri, 16
 May 2025 12:20:00 -0700 (PDT)
Date: Fri, 16 May 2025 19:19:28 +0000
In-Reply-To: <cover.1747368092.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747368092.git.afranji@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <e9de4d2a1d14e28ce829c2e16eeeb8da344297c8.1747368093.git.afranji@google.com>
Subject: [RFC PATCH v2 08/13] KVM: x86: Refactor common code out of sev.c
From: Ryan Afranji <afranji@google.com>
To: afranji@google.com, ackerleytng@google.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	tabba@google.com
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	shuah@kernel.org, andrew.jones@linux.dev, ricarkol@google.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, yu.c.zhang@linux.intel.com, 
	vannapurve@google.com, erdemaktas@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, sagis@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Split sev_lock_two_vms() into kvm_mark_migration_in_progress() and
kvm_lock_two_vms() and refactor sev.c to use these two new functions.

Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 arch/x86/kvm/svm/sev.c | 60 ++++++++++------------------------------
 arch/x86/kvm/x86.c     | 62 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  6 ++++
 3 files changed, 82 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 89c06cfcc200..b3048ec411e2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1836,47 +1836,6 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
 	return false;
 }
 
-static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
-{
-	int r = -EBUSY;
-
-	if (dst_kvm == src_kvm)
-		return -EINVAL;
-
-	/*
-	 * Bail if these VMs are already involved in a migration to avoid
-	 * deadlock between two VMs trying to migrate to/from each other.
-	 */
-	if (atomic_cmpxchg_acquire(&dst_kvm->migration_in_progress, 0, 1))
-		return -EBUSY;
-
-	if (atomic_cmpxchg_acquire(&src_kvm->migration_in_progress, 0, 1))
-		goto release_dst;
-
-	r = -EINTR;
-	if (mutex_lock_killable(&dst_kvm->lock))
-		goto release_src;
-	if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTING))
-		goto unlock_dst;
-	return 0;
-
-unlock_dst:
-	mutex_unlock(&dst_kvm->lock);
-release_src:
-	atomic_set_release(&src_kvm->migration_in_progress, 0);
-release_dst:
-	atomic_set_release(&dst_kvm->migration_in_progress, 0);
-	return r;
-}
-
-static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
-{
-	mutex_unlock(&dst_kvm->lock);
-	mutex_unlock(&src_kvm->lock);
-	atomic_set_release(&dst_kvm->migration_in_progress, 0);
-	atomic_set_release(&src_kvm->migration_in_progress, 0);
-}
-
 /* vCPU mutex subclasses.  */
 enum sev_migration_role {
 	SEV_MIGRATION_SOURCE = 0,
@@ -2057,9 +2016,12 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		return -EBADF;
 
 	source_kvm = fd_file(f)->private_data;
-	ret = sev_lock_two_vms(kvm, source_kvm);
+	ret = kvm_mark_migration_in_progress(kvm, source_kvm);
 	if (ret)
 		return ret;
+	ret = kvm_lock_two_vms(kvm, source_kvm);
+	if (ret)
+		goto out_mark_migration_done;
 
 	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
 	    sev_guest(kvm) || !sev_guest(source_kvm)) {
@@ -2105,7 +2067,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	put_misc_cg(cg_cleanup_sev->misc_cg);
 	cg_cleanup_sev->misc_cg = NULL;
 out_unlock:
-	sev_unlock_two_vms(kvm, source_kvm);
+	kvm_unlock_two_vms(kvm, source_kvm);
+out_mark_migration_done:
+	kvm_mark_migration_done(kvm, source_kvm);
 	return ret;
 }
 
@@ -2779,9 +2743,12 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		return -EBADF;
 
 	source_kvm = fd_file(f)->private_data;
-	ret = sev_lock_two_vms(kvm, source_kvm);
+	ret = kvm_mark_migration_in_progress(kvm, source_kvm);
 	if (ret)
 		return ret;
+	ret = kvm_lock_two_vms(kvm, source_kvm);
+	if (ret)
+		goto e_mark_migration_done;
 
 	/*
 	 * Mirrors of mirrors should work, but let's not get silly.  Also
@@ -2821,9 +2788,10 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	 * KVM contexts as the original, and they may have different
 	 * memory-views.
 	 */
-
 e_unlock:
-	sev_unlock_two_vms(kvm, source_kvm);
+	kvm_unlock_two_vms(kvm, source_kvm);
+e_mark_migration_done:
+	kvm_mark_migration_done(kvm, source_kvm);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6ce044b090a..422c66a033d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4502,6 +4502,68 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+int kvm_mark_migration_in_progress(struct kvm *dst_kvm, struct kvm *src_kvm)
+{
+	int r;
+
+	if (dst_kvm == src_kvm)
+		return -EINVAL;
+
+	/*
+	 * Bail if these VMs are already involved in a migration to avoid
+	 * deadlock between two VMs trying to migrate to/from each other.
+	 */
+	r = -EBUSY;
+	if (atomic_cmpxchg_acquire(&dst_kvm->migration_in_progress, 0, 1))
+		return r;
+
+	if (atomic_cmpxchg_acquire(&src_kvm->migration_in_progress, 0, 1))
+		goto release_dst;
+
+	return 0;
+
+release_dst:
+	atomic_set_release(&dst_kvm->migration_in_progress, 0);
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_mark_migration_in_progress);
+
+void kvm_mark_migration_done(struct kvm *dst_kvm, struct kvm *src_kvm)
+{
+	atomic_set_release(&dst_kvm->migration_in_progress, 0);
+	atomic_set_release(&src_kvm->migration_in_progress, 0);
+}
+EXPORT_SYMBOL_GPL(kvm_mark_migration_done);
+
+int kvm_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
+{
+	int r;
+
+	if (dst_kvm == src_kvm)
+		return -EINVAL;
+
+	r = -EINTR;
+	if (mutex_lock_killable(&dst_kvm->lock))
+		return r;
+
+	if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTING))
+		goto unlock_dst;
+
+	return 0;
+
+unlock_dst:
+	mutex_unlock(&dst_kvm->lock);
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_lock_two_vms);
+
+void kvm_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
+{
+	mutex_unlock(&dst_kvm->lock);
+	mutex_unlock(&src_kvm->lock);
+}
+EXPORT_SYMBOL_GPL(kvm_unlock_two_vms);
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 88a9475899c8..508f9509546c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -649,4 +649,10 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
+int kvm_mark_migration_in_progress(struct kvm *dst_kvm, struct kvm *src_kvm);
+void kvm_mark_migration_done(struct kvm *dst_kvm, struct kvm *src_kvm);
+
+int kvm_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm);
+void kvm_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm);
+
 #endif
-- 
2.49.0.1101.gccaa498523-goog


