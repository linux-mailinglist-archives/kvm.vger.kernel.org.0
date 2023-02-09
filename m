Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D668FD3E
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjBICmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjBIClX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:23 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA54529408
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910480; x=1707446480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y4g4DkmY67iazEVGnFIlRo7vr48IQF2YzOSCV8YKp3E=;
  b=idunWDX0MBVeQTP3AxKhoqXlFsuCDiKGB1lxl44mnlnISolqb4EHQAHB
   PgwKtQfoC3MAdID737FCvKCSAkYN3zuy71a///7wvBnbNBxn2x5gmQikk
   kWH7MCcrVELcysTgilYwytpyJtxRT1OHYA1Sd0y9whYKuadbTIqt2VqJu
   zn5QzwovM3cyA8AcU66VzcVlOuqpumiVYyKkHbHjSQE3RtMlUjZUL63hy
   7L06BiT9jpvy5JVbfh5f+9sfwZgnXBhTRgvCwTjAcO1JW7LnBnEyOsVZy
   x7D0rm6E+q7GH/sXYBBob3xWaOujml1m5e8XTKW6YxrlJmuMbhDCAI0xX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586682"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094467"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094467"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:17 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 8/9] KVM: x86: emulation: Apply LAM when emulating data access
Date:   Thu,  9 Feb 2023 10:40:21 +0800
Message-Id: <20230209024022.3371768-9-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When in KVM emulation, calculated a LA for data access, apply LAM if
guest is at that moment LAM active, so that the following canonical check
can pass.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/emulate.c |  6 ++++++
 arch/x86/kvm/x86.h     | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5cc3efa0e21c..d52037151133 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -700,6 +700,12 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
+		/*
+		 * LAM applies only on data access
+		 */
+		if (!fetch && is_lam_active(ctxt->vcpu))
+			la = kvm_untagged_addr(la, ctxt->vcpu);
+
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7228895d4a6f..9397e9f4e061 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -135,6 +135,19 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static inline bool is_lam_active(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57) ||
+	       kvm_read_cr4_bits(vcpu, X86_CR4_LAM_SUP);
+}
+#else
+static inline bool is_lam_active(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif
+
 static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 {
 	int cs_db, cs_l;
-- 
2.31.1

