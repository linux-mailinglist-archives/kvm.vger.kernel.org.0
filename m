Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9F7D615D
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 07:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjJYF72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 01:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJYF71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 01:59:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D19AC;
        Tue, 24 Oct 2023 22:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698213565; x=1729749565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zpVz5IHUMxsDVwAwpqXhPcBg+mXIGlfvFTkmBpX+v7I=;
  b=aIW7aXWCNHeeSCuuPsF/tZe4oZzEiE0Wr2EjSX1knQifozR0U8uHj/uZ
   bmDJIU9IHnecvXF0Vg1yvQ1wyzb593DtizUWutKEx849myZFht8kCtibK
   wId5hFicdIBE5XYZWVza4yLH+/02qrvnsuyd9nAcckSw7xnsHjuEfIe21
   XImHiFY2cKWPV6zJlBOfDj1vlfeesKuyTEwh6Ia4VfM4rakt1aT8GI+AB
   wCrFe8OHV7166IhbIydy9Hy6U3KyxOm0o0wObwU06t6HTI5372PSwD0v2
   cFvYt63u3+xmW36Y3oWmtsc8dqAP9MPkuYkhyn38NpzflzGhBB76II5Fj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="473479226"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="473479226"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 22:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="788021758"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="788021758"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga008.jf.intel.com with ESMTP; 24 Oct 2023 22:59:21 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 1/2] x86/kvm/async_pf: Use separate percpu variable to track the enabling of asyncpf
Date:   Wed, 25 Oct 2023 01:59:13 -0400
Message-Id: <20231025055914.1201792-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231025055914.1201792-1-xiaoyao.li@intel.com>
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refer to commit fd10cde9294f ("KVM paravirt: Add async PF initialization
to PV guest") and commit 344d9588a9df ("KVM: Add PV MSR to enable
asynchronous page faults delivery"). It turns out that at the time when
asyncpf was introduced, the purpose was defining the shared PV data 'struct
kvm_vcpu_pv_apf_data' with the size of 64 bytes. However, it made a mistake
and defined the size to 68 bytes, which failed to make fit in a cache line
and made the code inconsistent with the documentation.

Below justification quoted from Sean[*]

  KVM (the host side) has *never* read kvm_vcpu_pv_apf_data.enabled, and
  the documentation clearly states that enabling is based solely on the
  bit in the synthetic MSR.

  So rather than update the documentation, fix the goof by removing the
  enabled filed and use the separate percpu variable instread.
  KVM-as-a-host obviously doesn't enforce anything or consume the size,
  and changing the header will only affect guests that are rebuilt against
  the new header, so there's no chance of ABI breakage between KVM and its
  guests. The only possible breakage is if some other hypervisor is
  emulating KVM's async #PF (LOL) and relies on the guest to set
  kvm_vcpu_pv_apf_data.enabled. But (a) I highly doubt such a hypervisor
  exists, (b) that would arguably be a violation of KVM's "spec", and
  (c) the worst case scenario is that the guest would simply lose async
  #PF functionality.

[*] https://lore.kernel.org/all/ZS7ERnnRqs8Fl0ZF@google.com/T/#u

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/x86/msr.rst   |  1 -
 arch/x86/include/uapi/asm/kvm_para.h |  1 -
 arch/x86/kernel/kvm.c                | 11 ++++++-----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 9315fc385fb0..f6d70f99a1a7 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -204,7 +204,6 @@ data:
 		__u32 token;
 
 		__u8 pad[56];
-		__u32 enabled;
 	  };
 
 	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..605899594ebb 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -142,7 +142,6 @@ struct kvm_vcpu_pv_apf_data {
 	__u32 token;
 
 	__u8 pad[56];
-	__u32 enabled;
 };
 
 #define KVM_PV_EOI_BIT 0
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ab9ee5896c..388a3fdd3cad 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
 
 early_param("no-steal-acc", parse_no_stealacc);
 
+static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
 static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
@@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
 {
 	u32 flags = 0;
 
-	if (__this_cpu_read(apf_reason.enabled)) {
+	if (__this_cpu_read(async_pf_enabled)) {
 		flags = __this_cpu_read(apf_reason.flags);
 		__this_cpu_write(apf_reason.flags, 0);
 	}
@@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 
 	inc_irq_stat(irq_hv_callback_count);
 
-	if (__this_cpu_read(apf_reason.enabled)) {
+	if (__this_cpu_read(async_pf_enabled)) {
 		token = __this_cpu_read(apf_reason.token);
 		kvm_async_pf_task_wake(token);
 		__this_cpu_write(apf_reason.token, 0);
@@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
 		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
-		__this_cpu_write(apf_reason.enabled, 1);
+		__this_cpu_write(async_pf_enabled, 1);
 		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
 	}
 
@@ -383,11 +384,11 @@ static void kvm_guest_cpu_init(void)
 
 static void kvm_pv_disable_apf(void)
 {
-	if (!__this_cpu_read(apf_reason.enabled))
+	if (!__this_cpu_read(async_pf_enabled))
 		return;
 
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
-	__this_cpu_write(apf_reason.enabled, 0);
+	__this_cpu_write(async_pf_enabled, 0);
 
 	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
 }
-- 
2.34.1

