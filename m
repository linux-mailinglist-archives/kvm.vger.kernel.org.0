Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715435E6AC5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiIVSXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiIVSX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF1C10C79B;
        Thu, 22 Sep 2022 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870939; x=1695406939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QeHsRbI/skAm2S/DEhUEl4+spTF4gixFEqyGdTM2YXs=;
  b=fLJleE3rXocP3njQo2mbZzCfiXaEnLrrsd16DIvIrGqcJPVYfJq069b+
   hcnnNBVwWBeQcUB41mherMtwIbLUkwij1TwpVdA5rJUEkTjdUsemO9uXb
   QQ68iCHeWgaUd0v+r6/3i6T4f6oeDssLVRI4+Dn2IG5fdzeIuGTVg3JBJ
   UDTU9oocbYm+4/KOVThCOlvgkwiX6TA3PKEMPjuil+/Zuk5QKa89xaNrT
   ucy+MnCXEKrL+c3bggX9TWOxv5wLeDYRYtY726mph0CY4Cy34sDU5xocW
   hibDnuSofUMYQ1lndA7q1hPxb0WyPBSF4XTx25GsV+WZvVzCycg2tuWPd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712916"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712916"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086819"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:25 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 22/30] KVM: x86: Move TSC fixup logic to KVM arch resume callback
Date:   Thu, 22 Sep 2022 11:20:51 -0700
Message-Id: <d7c49c8b4e7dc00be70d48c1ad125a058b612fc2.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to S4 suspend") made
use of kvm_arch_hardware_enable() callback to detect that TSC goes backward
due to S4 suspend.  It has to check it only when resuming from S4. Not
every time virtualization hardware ennoblement.  Move the logic to
kvm_arch_resume() callback.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b15eb59096b6..d49396bb6c2e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11865,18 +11865,26 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
+{
+	return static_call(kvm_x86_hardware_enable)();
+}
+
+static int __hardware_enable(void);
+
+void kvm_arch_resume(int usage_count)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
-	int ret;
 	u64 local_tsc;
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	ret = static_call(kvm_x86_hardware_enable)();
-	if (ret != 0)
-		return ret;
+	if (!usage_count)
+		return;
+
+	if (__hardware_enable())
+		return;
 
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
@@ -11951,7 +11959,6 @@ int kvm_arch_hardware_enable(void)
 		}
 
 	}
-	return 0;
 }
 
 void kvm_arch_hardware_disable(void)
@@ -12115,12 +12122,6 @@ int kvm_arch_suspend(int usage_count)
 	return 0;
 }
 
-void kvm_arch_resume(int usage_count)
-{
-	if (usage_count)
-		(void)__hardware_enable();
-}
-
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
-- 
2.25.1

