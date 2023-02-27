Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C436A3D8E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjB0I4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjB0Izr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:55:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62924CAB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677487666; x=1709023666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J5qjLMWnAEH++IzEHXNi7VwHmVyDNemr2qezxGGrK/w=;
  b=oIJPDwQB+hj8AEXSZTeDcqMJKvlsgp64J717xhFQcRMfiRMzrwXnmBuv
   qsYYaRKP3vnqJJ533raayoImvBzBkVQPdmScpB3eX9Odr+ExrLqfQI2l3
   5XbTXFkNtiOt+MDOyM8Cp4JNeXTs91OBlf9sIIoy1SKxjE55AFosSTsCQ
   GVtjWH1xqxViMQDF+nSRR+j1lhsqe2GB1YnQ71Br8GQFu6eVEjnonxezd
   E2RaTsKeTWMcUedH6bjflG9AXbHl4Eio95Am7i8nDBliufQ2Xlt3ZN5kG
   wlDxoqt3xBTLzg3VR4HpNWpe+9YD/TQgwKXQ30bXNJgKRIG/A9RpVao8G
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="322057701"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="322057701"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:46:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651127091"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651127091"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 00:46:17 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating data access in 64-bit mode
Date:   Mon, 27 Feb 2023 16:45:46 +0800
Message-Id: <20230227084547.404871-5-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230227084547.404871-1-robert.hu@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate HW LAM masking when doing data access under 64-bit mode.

kvm_lam_untag_addr() implements this: per CR4/CR3 LAM bits configuration,
firstly check the linear addr conforms LAM canonical, i.e. the highest
address bit matches bit 63. Then mask out meta data per LAM configuration.
If failed in above process, emulate #GP to guest.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/emulate.c | 13 ++++++++
 arch/x86/kvm/x86.h     | 70 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5cc3efa0e21c..77bd13f40711 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -700,6 +700,19 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
+		/* LAM applies only on data access */
+		if (!fetch && guest_cpuid_has(ctxt->vcpu, X86_FEATURE_LAM)) {
+			enum lam_type type;
+
+			type = kvm_vcpu_lam_type(la, ctxt->vcpu);
+			if (type == LAM_ILLEGAL) {
+				*linear = la;
+				goto bad;
+			} else {
+				la = kvm_lam_untag_addr(la, type);
+			}
+		}
+
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6b6bfddc84e0..d992e5220602 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -201,6 +201,76 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
 }
 
+enum lam_type {
+	LAM_ILLEGAL = -1,
+	LAM_U57,
+	LAM_U48,
+	LAM_S57,
+	LAM_S48,
+	LAM_NONE
+};
+
+#ifdef CONFIG_X86_64
+/*
+ * LAM Canonical Rule:
+ * LAM_U/S48 -- bit 63 == bit 47
+ * LAM_U/S57 -- bit 63 == bit 56
+ */
+static inline bool lam_canonical(u64 addr, int effect_width)
+{
+	return (addr >> 63) == ((addr >> effect_width) & BIT(0));
+}
+
+static inline enum lam_type kvm_vcpu_lam_type(u64 addr, struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!is_64_bit_mode(vcpu));
+
+	if (addr >> 63 == 0) {
+		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
+			return lam_canonical(addr, 56) ?  LAM_U57 : LAM_ILLEGAL;
+		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48)
+			return lam_canonical(addr, 47) ?  LAM_U48 : LAM_ILLEGAL;
+	} else if (kvm_read_cr4_bits(vcpu, X86_CR4_LAM_SUP)) {
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_LA57))
+			return lam_canonical(addr, 56) ?  LAM_S57 : LAM_ILLEGAL;
+		else
+			return lam_canonical(addr, 47) ?  LAM_S48 : LAM_ILLEGAL;
+	}
+
+	return LAM_NONE;
+}
+
+/* untag addr for guest, according to vCPU's LAM config */
+static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
+{
+	switch (type) {
+	case LAM_U57:
+	case LAM_S57:
+		addr = __canonical_address(addr, 57);
+		break;
+	case LAM_U48:
+	case LAM_S48:
+		addr = __canonical_address(addr, 48);
+		break;
+	case LAM_NONE:
+	default:
+		break;
+	}
+
+	return addr;
+}
+#else
+static inline enum lam_type kvm_vcpu_lam_type(u64 addr, struct kvm_vcpu *vcpu)
+{
+	return LAM_NONE;
+}
+
+static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
+{
+	return addr;
+}
+#endif
+
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-- 
2.31.1

