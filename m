Return-Path: <kvm+bounces-56343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97722B3BF69
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23973188A34E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA8C3375D8;
	Fri, 29 Aug 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bWcGNT/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10D0321F26;
	Fri, 29 Aug 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481592; cv=none; b=TkRgHu5VeOOcQ6WkisLolGsw7k/dq0PMGIo5RpnoJbzRJgyJl9LPfVLXmC8NktVDWmrBakhjZibvSyw4I/ADlXECTObhTs1yIOsgebZTkk0OBpsPI+6Z0ij0G8AkptL5mCY0Xby0t03A9jUqvnXPvrhazE3q33kw9WWD5KqJktA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481592; c=relaxed/simple;
	bh=B+m/8qllmHVTlj/AM37AJiiUWBYT48rw46oDultWBPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx7a0rxda9VUWI2HHi48tQpeBf/eZS1utkYGyvhmz/WPfU/994i6PVe54qTPl6qYzRk3qinlaxZ0J9xDfEsKE9bDPV430wzHI0qleJZCKXsq1g1MipxxL9FUmF9dUhoG+IcjLTneL8bF7e2Uk0vN5GIDsJC4+UK93vmWWAZ7y/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bWcGNT/Z; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4E2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4E2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481540;
	bh=bvBHvjul1GobdicSx2txFw5fgQ8wUMiarsYtlt6XWY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWcGNT/ZCkVvaDiyN0n7t4aRTwIleF7m6yMZ52/htAc/ffzypnMVINfmqiyYHTbxP
	 Pa/GxNTnt3HYNsy5ujNp5op9TqQLd+UJNa671y9ZvOEuXH+lMZO5ld8XpKz3DENu+i
	 lUkMpBwh2hq/iOvW+9/KK4+Sxan4yPyz1atRerF8EE1MeYA3FGn4UQr3+RsI42Gztz
	 qiyMRVuiCtGAIJ0GxTwyK/e5MFLVg4FLBGmaKZbVk9Bg8jfjm9ddBOCfTcRgbmGNbp
	 B2Q7Bgjonr1WaNhXtZa+0X9GPFav4/94Ud5/AiEBYVzA8BsF5//TVAYFzlZ5pygcYf
	 9OlMRbPmrf4Eg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 08/21] KVM: VMX: Save/restore guest FRED RSP0
Date: Fri, 29 Aug 2025 08:31:36 -0700
Message-ID: <20250829153149.2871901-9-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 368f1799394c..5f639fb3b44d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1293,6 +1293,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1337,6 +1340,16 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
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
index e577af1003d8..733fa2ef4bea 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -227,6 +227,7 @@ struct vcpu_vmx {
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_guest_kernel_gs_base;
+	u64		      msr_guest_fred_rsp0;
 #endif
 
 	u64		      spec_ctrl;
-- 
2.51.0


