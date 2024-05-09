Return-Path: <kvm+bounces-17102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C38378C0C2C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EBAEB2137B
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54EF149E13;
	Thu,  9 May 2024 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JwsfaD/l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27673149C57;
	Thu,  9 May 2024 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715241306; cv=none; b=IF338GXerhfYRTYtNY9L3eRzku3szJ/Ie8/bJAVn9GGfYD6lT9gSsqvHSjqDKvXEhJ9WjseJDN8eh1s8Cab7OEfYiz6GRprwhPT3GpuobHHVLmT1ybZ4+eBSaxc6FrJt5BszGQUGTLsp2Bik0G4gUYmeWWFSO8DsnjqPJIlmfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715241306; c=relaxed/simple;
	bh=h4H3AtpMz9WPnsicHUMxE6jo8aseXELd2qgCjjZMN78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNFSfMpx938yXwAd3Dm+BUrS60tQXGVG38SgFi5N18JMDi2oUGPp0p/7fqyJoJPyC7E38wJlL9XVllJX37IEiTvOThYgBD+Eems6NVp+pMONRonlQsq6vIdVd8z/cZ3yId5ABh1FHu/daDhdcKzQQ6wagXctbLD2leE3Us6KZ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JwsfaD/l; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715241305; x=1746777305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h4H3AtpMz9WPnsicHUMxE6jo8aseXELd2qgCjjZMN78=;
  b=JwsfaD/l3UwABalxCYHqTIHFicRQxiUJJhTz/OlWe/Ad9NMvItXoqVIb
   4uBi3KG0jlnTHwoZ4i0RB2X0SxF8wpAJxd/Bkf92ZH9hCBHasn6bfSKE3
   k79MnAIxvVn27hRIFYjPVWawHo7nhket87lkS6WcP1o0fxh1iIqAVy9E9
   5HBMohYhuTL1gR3uKdyKK2KKD56dkkdsUG4Vx9bO2kQs0kO0OvXyXBjHJ
   y8ALC5BuaiLoC1XVQ/Jcb+2vMnbIUSgRs28+kpgvLRK7zKu4E8uGmsZNC
   w/Ekmja4bAE3Lun1FQu3OtAGTsK/yk37dWmY2tcF891eYYN9DU5iSSdO0
   g==;
X-CSE-ConnectionGUID: xpxvqZduSo6yAfzS788etg==
X-CSE-MsgGUID: kQfCRb+8Rc6B5opKuhGAvw==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="28658409"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="28658409"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:55:02 -0700
X-CSE-ConnectionGUID: sko8dQaKSA2vWHqsfgWe/A==
X-CSE-MsgGUID: aEqM31FzSjeX5jJvX8yaMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="29268233"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:55:02 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 2/2] KVM: x86: Enable guest SSP read/write interface with new uAPIs
Date: Thu,  9 May 2024 00:54:23 -0700
Message-ID: <20240509075423.156858-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240509075423.156858-1-weijiang.yang@intel.com>
References: <20240509075423.156858-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
CET guest SSP is HW register which has corresponding VMCS field to save
/restore guest values when VM-{Exit,Entry} happens. KVM handles SSP as
a synthetic MSR for userspace access.

Use a translation helper to set up mapping for SSP synthetic index and
KVM-internal MSR index so that userspace doesn't need to take care of
KVM's management for synthetic MSRs and avoid conflicts.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              |  7 +++++++
 arch/x86/kvm/x86.h              | 10 ++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ca2a47a85fa1..81c8d9ea2e58 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -420,6 +420,9 @@ struct kvm_x86_reg_id {
 	__u16 rsvd16;
 };
 
+/* KVM synthetic MSR index staring from 0 */
+#define MSR_KVM_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0054c52f24b..a970bd26ce2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5886,6 +5886,13 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 static int kvm_translate_synthetic_msr(u32 *index)
 {
+	switch (*index) {
+	case MSR_KVM_GUEST_SSP:
+		*index = MSR_KVM_INTERNAL_GUEST_SSP;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8b71803777b..6ac86a75aedc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -57,6 +57,16 @@ void kvm_spurious_fault(void);
 #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
 #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
 
+/*
+ * KVM's internal, non-ABI indices for synthetic MSRs. The values themselves
+ * are arbitrary and have no meaning, the only requirement is that they don't
+ * conflict with "real" MSRs that KVM supports. Use values at the uppper end
+ * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
+ * will be usable until KVM exhausts its supply of paravirtual MSR indices.
+ */
+
+#define MSR_KVM_INTERNAL_GUEST_SSP	0x4b564dff
+
 static inline unsigned int __grow_ple_window(unsigned int val,
 		unsigned int base, unsigned int modifier, unsigned int max)
 {
-- 
2.43.0


