Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9914C40B4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiBYIyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbiBYIy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:27 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2191B22B97C;
        Fri, 25 Feb 2022 00:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779230; x=1677315230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QMLp8NmC2YlCPDw6nrDcudbrHfqDQnsY4QCUiVPXsdQ=;
  b=jxLNK1mqIAusMlApkJx+D5IzvA/x1afkU2BgmN0oIyZYqNcFoVh1o5m9
   vOpXErfhT9I2z027slixYRYTXLvRPJWLs7WFdNRVrmGILMJouD3VK7Qk9
   GC1NJ9Ath6G+4U9E7OJrCr+Jrovd2hcBqiPM+1XeGwtMoK4U9Pz14Cgkb
   t6dMNIlpK/hdh35Hsxi4YwaSV2WyuJdOEuANzfl6YPcvcpsrVwCb4cKPp
   d4AK4wSI0/CW5LzhoWQbS/91Jwo09kt812qIApnj0npsqLaIjQEA4ybNH
   r300gLUDhTLjAVGgtNpPfXPdXCRE26zlgvHmARLUZKmdRVQcTtQ2ZiudX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="232429507"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="232429507"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:42 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186556"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:36 -0800
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID unconditionally
Date:   Fri, 25 Feb 2022 16:22:20 +0800
Message-Id: <20220225082223.18288-7-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

No normal guest has any reason to change physical APIC IDs, and
allowing this introduces bugs into APIC acceleration code.

And Intel recent hardware just ignores writes to APIC_ID in
xAPIC mode. More background can be found at:
https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/

Looks there is no much value to support writable xAPIC ID in
guest except supporting some old and crazy use cases which
probably would fail on real hardware. So, make xAPIC ID
read-only for KVM guests.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/lapic.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e4bcdab1fac0..b38288c8a94f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2044,10 +2044,17 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
-			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+		if (apic_x2apic_mode(apic)) {
 			ret = 1;
+			break;
+		}
+		/* Don't allow changing APIC ID to avoid unexpected issues */
+		if ((val >> 24) != apic->vcpu->vcpu_id) {
+			kvm_vm_bugged(apic->vcpu->kvm);
+			break;
+		}
+
+		kvm_apic_set_xapic_id(apic, val >> 24);
 		break;
 
 	case APIC_TASKPRI:
@@ -2631,11 +2638,15 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s, bool set)
 {
-	if (apic_x2apic_mode(vcpu->arch.apic)) {
-		u32 *id = (u32 *)(s->regs + APIC_ID);
-		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
-		u64 icr;
+	u32 *id = (u32 *)(s->regs + APIC_ID);
+	u32 *ldr = (u32 *)(s->regs + APIC_LDR);
+	u64 icr;
 
+	if (!apic_x2apic_mode(vcpu->arch.apic)) {
+		/* Don't allow changing APIC ID to avoid unexpected issues */
+		if ((*id >> 24) != vcpu->vcpu_id)
+			return -EINVAL;
+	} else {
 		if (vcpu->kvm->arch.x2apic_format) {
 			if (*id != vcpu->vcpu_id)
 				return -EINVAL;
-- 
2.27.0

