Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC783B9431
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhGAPnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33460 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhGAPnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:43 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5115C1FF9F;
        Thu,  1 Jul 2021 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G69zxKbsxOLrDAWJJ9Z7GaK6BkQv1ecXGrGE66wDZY4=;
        b=k7diIjgxgp519Bws0M2apgmMZPQgcbkXdwQN0TZznNqdv7u0OBYRhwd01KU7/d0cHYZqvN
        Raw++g2sMPDaMefuQdXLRLj4Frw/LkHiTFHwERBRZFJSCcbJjbg1aPfhqGLeEOfvDO3P9l
        fiUMpmBUOxjHRVzt8Iu/eYUHt+n5uu8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id DE10511CD6;
        Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G69zxKbsxOLrDAWJJ9Z7GaK6BkQv1ecXGrGE66wDZY4=;
        b=k7diIjgxgp519Bws0M2apgmMZPQgcbkXdwQN0TZznNqdv7u0OBYRhwd01KU7/d0cHYZqvN
        Raw++g2sMPDaMefuQdXLRLj4Frw/LkHiTFHwERBRZFJSCcbJjbg1aPfhqGLeEOfvDO3P9l
        fiUMpmBUOxjHRVzt8Iu/eYUHt+n5uu8=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id QPcVNRbi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:10 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/6] x86/kvm: add boot parameter for setting max number of vcpus per guest
Date:   Thu,  1 Jul 2021 17:41:05 +0200
Message-Id: <20210701154105.23215-7-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today the maximum number of vcpus of a kvm guest is set via a #define
in a header file.

In order to support higher vcpu numbers for guests without generally
increasing the memory consumption of guests on the host especially on
very large systems add a boot parameter for specifying the number of
allowed vcpus for guests.

The default will still be the current setting of 288. The value 0 has
the special meaning to limit the number of possible vcpus to the
number of possible cpus of the host.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h                 |  5 ++++-
 arch/x86/kvm/x86.c                              |  7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 99bfa53a2bbd..8eb856396ffa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2373,6 +2373,16 @@
 			guest can't have more vcpus than the set value + 1.
 			Default: 1023
 
+	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
+			guest. The special value 0 sets the limit to the number
+			of physical cpus possible on the host (including not
+			yet hotplugged cpus). Higher values will result in
+			slightly higher memory consumption per guest. Depending
+			on the value and the virtual topology the maximum
+			allowed vcpu-id might need to be raised, too (see
+			kvm.max_vcpu_id parameter).
+			Default: 288
+
 	l1tf=           [X86] Control mitigation of the L1TF vulnerability on
 			      affected CPUs
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39cbc4b6bffb..65ae82a5d444 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,7 +37,8 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 288
+#define KVM_DEFAULT_MAX_VCPUS 288
+#define KVM_MAX_VCPUS max_vcpus
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_DEFAULT_MAX_VCPU_ID 1023
 #define KVM_MAX_VCPU_ID max_vcpu_id
@@ -1509,6 +1510,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 /* bus lock detection supported? */
 extern bool kvm_has_bus_lock_exit;
+/* maximum number of vcpus per guest */
+extern unsigned int max_vcpus;
 /* maximum vcpu-id */
 extern unsigned int max_vcpu_id;
 /* per cpu vcpu bitmasks (disable preemption during usage) */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9b0bb2221ea..888c4507504d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -177,6 +177,10 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+unsigned int __read_mostly max_vcpus = KVM_DEFAULT_MAX_VCPUS;
+module_param(max_vcpus, uint, S_IRUGO);
+EXPORT_SYMBOL_GPL(max_vcpus);
+
 unsigned int __read_mostly max_vcpu_id = KVM_DEFAULT_MAX_VCPU_ID;
 module_param(max_vcpu_id, uint, S_IRUGO);
 
@@ -10648,6 +10652,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	if (max_vcpus == 0)
+		max_vcpus = num_possible_cpus();
+
 	kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
 					    sizeof(unsigned long));
 	kvm_hv_vp_bitmap = __alloc_percpu(KVM_HV_VPMAP_SZ, sizeof(u64));
-- 
2.26.2

