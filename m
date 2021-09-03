Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D410C40003A
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349484AbhICNJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:09:37 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36612 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhICNJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:09:31 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3A10B226F1;
        Fri,  3 Sep 2021 13:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E73i+UrNiGWRgWzraEJJ6skevArYczszujnDK6ICk10=;
        b=TC+LhRb7uaEX1xfu13xKlPCUo7Wqy+EApLlw2Qyf4u5pYMonleq4l7rpwn016nTwT5DXfn
        A/niLbXknwcr+BANhL5D3YcNF+vanQH+mHAgkLBmxbgpIJsP/a2G1QdHVsG/ZKHlAVtvQy
        y8r9J43hRtOvtaqJoREYfSxGnGUBjb0=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AD3B7137D4;
        Fri,  3 Sep 2021 13:08:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id aPbmKE0eMmHYOAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:29 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Juergen Gross <jgross@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 6/6] x86/kvm: add boot parameter for setting max number of vcpus per guest
Date:   Fri,  3 Sep 2021 15:08:07 +0200
Message-Id: <20210903130808.30142-7-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
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
 Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
 arch/x86/include/asm/kvm_host.h                 | 5 ++++-
 arch/x86/kvm/x86.c                              | 9 ++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 37e194299311..b9641c9989ef 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2435,6 +2435,13 @@
 			feature (tagged TLBs) on capable Intel chips.
 			Default is 1 (enabled)
 
+	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
+			guest. The special value 0 sets the limit to the number
+			of physical cpus possible on the host (including not
+			yet hotplugged cpus). Higher values will result in
+			slightly higher memory consumption per guest.
+			Default: 288
+
 	kvm.vcpu_id_add_bits=
 			[KVM,X86] The vcpu-ids of guests are sparse, as they
 			are constructed by bit-wise concatenation of the ids of
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c28d0800208..a4ab387b0e1c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,8 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 288
+#define KVM_DEFAULT_MAX_VCPUS 288
+#define KVM_MAX_VCPUS max_vcpus
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
 /* memory slots that are not exposed to userspace */
@@ -1588,6 +1589,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 /* bus lock detection supported? */
 extern bool kvm_has_bus_lock_exit;
+/* maximum number of vcpus per guest */
+extern unsigned int max_vcpus;
 /* maximum vcpu-id */
 unsigned int kvm_max_vcpu_id(void);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff142b6dd00c..49c3d91c559e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -188,9 +188,13 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 static int __read_mostly vcpu_id_add_bits = -1;
 module_param(vcpu_id_add_bits, int, S_IRUGO);
 
+unsigned int __read_mostly max_vcpus = KVM_DEFAULT_MAX_VCPUS;
+module_param(max_vcpus, uint, S_IRUGO);
+EXPORT_SYMBOL_GPL(max_vcpus);
+
 unsigned int kvm_max_vcpu_id(void)
 {
-	int n_bits = fls(KVM_MAX_VCPUS - 1);
+	int n_bits = fls(max_vcpus - 1);
 
 	if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
 		pr_err("Invalid value of vcpu_id_add_bits=%d parameter!\n",
@@ -11033,6 +11037,9 @@ int kvm_arch_hardware_setup(void *opaque)
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

