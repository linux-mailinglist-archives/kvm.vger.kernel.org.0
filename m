Return-Path: <kvm+bounces-33361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B18D39EA3DA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0DB01680AA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6071D8A16;
	Tue, 10 Dec 2024 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SBj/8/g8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C5E70839;
	Tue, 10 Dec 2024 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791714; cv=none; b=N58rCOi1kF3zc5b2sEjIL0SCYw3D/afK0GZCVd/IZ2kUHiYBskqZSNFdkz9MFRSa5CwOWH7W/PHZM3P8n1FNP3pYj8gr1+OwQgrdZtCKTjlhvBeKZqbztRd3mf0HlE4iMvomGEjBXHWZdeGEMvu/3Cro9aw02gK+Rn96TgrGwU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791714; c=relaxed/simple;
	bh=gp8+ZOguOpyMDySL02wo3b9lFOkGzOg9r3xwCJHI8Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRuZ+je+FxzwmzLCIgjKP5t5CfrxR4YcmWpIGXLpDu4+86/qKVvMMPvzG9KUVlYMR/zkMjb7tfrCqrQ5AvKriQIL09EtuTt8+SzX9myec0zKCUND4oj1a4C1rSDq6w078pP/I6VoVftmKxsXjxjhUSoHRmfIs7BGOTi6U1moKcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SBj/8/g8; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791713; x=1765327713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gp8+ZOguOpyMDySL02wo3b9lFOkGzOg9r3xwCJHI8Ng=;
  b=SBj/8/g82fvFAUUAYqTjrvsn5nGbfObGaQLROFQVHlPH82YQe8+3YjiO
   22AblyPfzH+5BXD+qjwQqTaw7vgl8XG78sfQLVLcQjE0DNy8QyJgZmXW9
   SfX3JCHJUp1pZqMdgqrs/o85r1+55muQsUiYEWOaf0k1XpZva/d2N2vG9
   SSgsJDHR+8ip9oHpQkf4CLx7cLbzYs7u8i67WYoH5l2z9L4A6/vvImT1O
   IJ0NBKs/wyHFVF9hfn8raKaVL6MghLyh4Lakvx8PondnpgkIwMgcQxsdG
   cNF6b7F2mH7jfFLDqpSnUW5IiE5ZazG7JlBUXIo0UWovIVwoZPp2mvF0d
   Q==;
X-CSE-ConnectionGUID: TqU+v5OTQvCamg+YDRu7Rg==
X-CSE-MsgGUID: Dfbi9Wd2QyGedAO5iGRG5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793754"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793754"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:32 -0800
X-CSE-ConnectionGUID: IMFRehYkT9KlmoJICb4Yjw==
X-CSE-MsgGUID: 6htOobOoRxqq8fvLW3SD0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033068"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:29 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 12/18] KVM: TDX: Add method to ignore guest instruction emulation
Date: Tue, 10 Dec 2024 08:49:38 +0800
Message-ID: <20241210004946.3718496-13-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Skip instruction emulation and let the TDX guest retry for MMIO emulation
after installing the MMIO SPTE with suppress #VE bit cleared.

TDX protects TDX guest state from VMM, instructions in guest memory cannot
be emulated.  MMIO emulation is the only case that triggers the instruction
emulation code path for TDX guest.

The MMIO emulation handling flow as following:
- The TDX guest issues a vMMIO instruction. (The GPA must be shared and is
  not covered by KVM memory slot.)
- The default SPTE entry for shared-EPT by KVM has suppress #VE bit set. So
  EPT violation causes TD exit to KVM.
- Trigger KVM page fault handler and install a new SPTE with suppress #VE
  bit cleared.
- Skip instruction emulation and return X86EMU_RETRY_INSTR to let the vCPU
  retry.
- TDX guest re-executes the vMMIO instruction.
- TDX guest gets #VE because KVM has cleared #VE suppress bit.
- TDX guest #VE handler converts MMIO into TDG.VP.VMCALL<MMIO>

Return X86EMU_RETRY_INSTR in the callback check_emulate_instruction() for
TDX guests to retry the MMIO instruction.  Also, the instruction emulation
handling will be skipped, so that the callback check_intercept() will never
be called for TDX guest.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Dropped vt_check_intercept().
- Add a comment in vt_check_emulate_instruction().
- Update the changelog.
---
 arch/x86/kvm/vmx/main.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f6b449ae1ef7..c97d0540a385 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -268,6 +268,22 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static int vt_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len)
+{
+	/*
+	 * For TDX, this can only be triggered for MMIO emulation.  Let the
+	 * guest retry after installing the SPTE with suppress #VE bit cleared,
+	 * so that the guest will receive #VE when retry.  The guest is expected
+	 * to call TDG.VP.VMCALL<MMIO> to request VMM to do MMIO emulation on
+	 * #VE.
+	 */
+	if (is_td_vcpu(vcpu))
+		return X86EMUL_RETRY_INSTR;
+
+	return vmx_check_emulate_instruction(vcpu, emul_type, insn, insn_len);
+}
+
 static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -909,7 +925,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.check_emulate_instruction = vmx_check_emulate_instruction,
+	.check_emulate_instruction = vt_check_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.46.0


