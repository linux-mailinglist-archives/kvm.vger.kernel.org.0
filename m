Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945B14B7EC1
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiBPDQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiBPDQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:17 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7CCDCE07;
        Tue, 15 Feb 2022 19:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981367; x=1676517367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bpLgm/nN68Ff7pu3yaDbK15XDjBubHfH/fey+JeZkjo=;
  b=KjDAmG3ObJ7corAKuR4jNOezt5cVn2chDAS3PiANQEHUR/EPDl1DUqun
   iH5y/QLlzBJEitvDabCcWwRB8MlTQE1JZ5D/lGl9srNzM0V/iOOyDhwHp
   34dNrZ+ST52kOBV5bcCMHhUaKdBMdIZ2qZ49YTuhhC0xIMI1C0DWwgE9c
   Ef0vd0H65fOPjwhx8wUrhA2gT3GSoCOsZigOS+6KCTD1T+aED0rMasaM7
   1oaND8QjtUStT+PJWfnP2Rw29GvOoF1qa0t8MxOP08AR2FuniZi8NiskZ
   cddkokqaHr1PLxu3BcoFJsFahSQOHwv2CcR8g/BlXldCRZ9V2OV0r7pVF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="248110842"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="248110842"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798241"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:04 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/6] KVM: Provide more information in kernel log if hardware enabling fails
Date:   Wed, 16 Feb 2022 11:15:18 +0800
Message-Id: <20220216031528.92558-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Provide the name of the calling function to hardware_enable_nolock() and
include it in the error message to provide additional information on
exactly what path failed.

Opportunistically bump the pr_info() to pr_warn(), failure to enable
virtualization support is warn-worthy as _something_ is wrong with the
system.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee47d33d69e1..c7229f5c9f66 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4833,7 +4833,7 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static void hardware_enable_nolock(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -4848,7 +4848,8 @@ static void hardware_enable_nolock(void *junk)
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
 	}
 }
 
@@ -4856,7 +4857,7 @@ static int kvm_starting_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	raw_spin_unlock(&kvm_count_lock);
 	return 0;
 }
@@ -4905,7 +4906,7 @@ static int hardware_enable_all(void)
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
 
 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -5530,7 +5531,7 @@ static void kvm_resume(void)
 #ifdef CONFIG_LOCKDEP
 		WARN_ON(lockdep_is_held(&kvm_count_lock));
 #endif
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	}
 }
 
-- 
2.25.1

