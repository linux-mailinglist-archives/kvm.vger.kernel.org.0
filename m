Return-Path: <kvm+bounces-53282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A70B0F9A3
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 793521CC08FD
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C59224B07;
	Wed, 23 Jul 2025 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="gG3vQoKN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50787C2E0;
	Wed, 23 Jul 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293257; cv=none; b=B6zGKagJZVw5jBcnr5DlC7Z5n3DI8nb2Sras7nB4XY7as8lGgUIt0yW8zFwgGOCc3GjQMF235lfRP50HQEhxenk6M7oR6Z1vY8e0K/GfGHGI3sJO58/nDYlFOinsR6eYm0iFYj+u6lGN2PNIkVVfCC7T0M3uhqRfmEMVwSP93Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293257; c=relaxed/simple;
	bh=bN6iMZJxULyWw8fM0bBE7z0gcBIpEuKUfw8wO8UJldY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbzHaFRtQI8AILzV2xLlGqohXCbsdEkaFhDh9PcYZzr+S47IxNiFQQ11GpGrocQY9l8WVDK61LB7qceZwnohWYkG4GNjNDb9dX/XSCm69fHj8lriQinWONUxzmVx2VUbv4+JwZL3fn0SWoN0gnWMgo9sjxoZO45HqISIYc4r3lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=gG3vQoKN; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxw1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxw1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293233;
	bh=DKIu6ocFBDeeS216dlD/91z8SZPrsdeaVqLdFbg9kFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gG3vQoKNXNW+sikXSNjgLOXOmPsiJVr2hOKuBgnfmuQDHB0jMx1LHze4QvL6W2Gi0
	 7uuwExpSHTPCP4NfTa9qp7zw4+/vkWHiBIGSi9pIz4WCg+suGQFb+TFbMA6p2sCoaP
	 9qIA8j8JyNICPY1A4946Ct0Lz7WsvSq8KUDDgH7U/BPxiKkUWt+oqLzQVaqa291+jF
	 qJ04V6lIqsqw81msQ2m1LGyajeLY10fEvxxdY9NcDwl1RASTeKKz65UOrfpbQD5GQt
	 TsrjfI7LEaG0cPjDSEiBR9ZdSB13NSTAeBnOmsHu6GY8Q4IHjeRsqSv8MESEw7W3la
	 0nYvV39u7StMg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 08/23] KVM: VMX: Save/restore guest FRED RSP0
Date: Wed, 23 Jul 2025 10:53:26 -0700
Message-ID: <20250723175341.1284463-9-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
through to the guest, thus is volatile/unknown.

Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
regardless of whether it is modified in KVM.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Remove the cpu_feature_enabled() check when set/get guest
  MSR_IA32_FRED_RSP0, as guest_cpu_cap_has() should suffice (Sean).
* Add a comment when synchronizing current MSR_IA32_FRED_RSP0 MSR to
  the kernel's local cache, because its handling is different from
  the MSR_KERNEL_GS_BASE handling (Sean).
* Add TB from Xuelian Guo.

Changes in v3:
* KVM only needs to save/restore guest FRED RSP0 now as host FRED RSP0
  is restored in arch_exit_to_user_mode_prepare() (Sean Christopherson).

Changes in v2:
* Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
  which are called from IRQ-disabled context (Chao Gao).
* Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cdc2a0c1465..1e58d61dc021 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1293,6 +1293,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
+
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1337,6 +1341,16 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
+
+	if (guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED)) {
+		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+		/*
+		 * Synchronize the current value in hardware to the kernel's
+		 * local cache.  The desired host RSP0 will be set when the
+		 * CPU exits to userspace (RSP0 is a per-task value).
+		 */
+		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);
+	}
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->vt.guest_state_loaded = false;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 32829f98af2f..617cbec5c9b3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -224,6 +224,7 @@ struct vcpu_vmx {
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_guest_kernel_gs_base;
+	u64		      msr_guest_fred_rsp0;
 #endif
 
 	u64		      spec_ctrl;
-- 
2.50.1


