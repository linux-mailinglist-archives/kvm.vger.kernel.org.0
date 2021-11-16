Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6937B4533C9
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbhKPOOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:14:16 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40764 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbhKPON6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:13:58 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6A06A1FD37;
        Tue, 16 Nov 2021 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637071860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eUzARzMdGIdgZhKMMm7MjS/I2ys+aHQmiheFYNSahmg=;
        b=YMdoxtQ/UmnVX7LVsdDt0A4V1t8OsHiy0lGMBX0bfIpqPZFGWSDz0+j5ISu6Wu+rcSND7z
        ckSQQw2/BcITl6FfGtwclZEhvDBho0PdTVnhoAu7/m5Cq4S8AocdNNWhtfGq2mzjGOgZVQ
        QyrGiPQIkFZgEszDFk3r005h9iDfAYU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 017ED13F75;
        Tue, 16 Nov 2021 14:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qFWaOvO7k2ExEQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 16 Nov 2021 14:10:59 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max number of vcpus per guest
Date:   Tue, 16 Nov 2021 15:10:54 +0100
Message-Id: <20211116141054.17800-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211116141054.17800-1-jgross@suse.com>
References: <20211116141054.17800-1-jgross@suse.com>
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

The default will still be the current setting of 1024. The value 0 has
the special meaning to limit the number of possible vcpus to the
number of possible cpus of the host.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V3:
- rebase
---
 Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
 arch/x86/include/asm/kvm_host.h                 | 5 ++++-
 arch/x86/kvm/x86.c                              | 9 ++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e269c3f66ba4..409a72c2d91b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2445,6 +2445,13 @@
 			feature (tagged TLBs) on capable Intel chips.
 			Default is 1 (enabled)
 
+	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
+			guest. The special value 0 sets the limit to the number
+			of physical cpus possible on the host (including not
+			yet hotplugged cpus). Higher values will result in
+			slightly higher memory consumption per guest.
+			Default: 1024
+
 	kvm.vcpu_id_add_bits=
 			[KVM,X86] The vcpu-ids of guests are sparse, as they
 			are constructed by bit-wise concatenation of the ids of
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8ea03ff01c45..8566e278ca91 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,8 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 1024U
+#define KVM_DEFAULT_MAX_VCPUS 1024U
+#define KVM_MAX_VCPUS max_vcpus
 #define KVM_MAX_HYPERV_VCPUS 1024U
 #define KVM_MAX_VCPU_IDS kvm_max_vcpu_ids()
 /* memory slots that are not exposed to userspace */
@@ -1611,6 +1612,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 /* bus lock detection supported? */
 extern bool kvm_has_bus_lock_exit;
+/* maximum number of vcpus per guest */
+extern unsigned int max_vcpus;
 /* maximum vcpu-id */
 unsigned int kvm_max_vcpu_ids(void);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a388acdc5eb0..3571ea34135b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -190,9 +190,13 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 static int __read_mostly vcpu_id_add_bits = 2;
 module_param(vcpu_id_add_bits, int, S_IRUGO);
 
+unsigned int __read_mostly max_vcpus = KVM_DEFAULT_MAX_VCPUS;
+module_param(max_vcpus, uint, S_IRUGO);
+EXPORT_SYMBOL_GPL(max_vcpus);
+
 unsigned int kvm_max_vcpu_ids(void)
 {
-	int n_bits = fls(KVM_MAX_VCPUS - 1);
+	int n_bits = fls(max_vcpus - 1);
 
 	if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
 		pr_err("Invalid value of vcpu_id_add_bits=%d parameter!\n",
@@ -11251,6 +11255,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	if (max_vcpus == 0)
+		max_vcpus = num_possible_cpus();
+
 	kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
 					    sizeof(unsigned long));
 	if (!kvm_pcpu_vcpu_mask) {
-- 
2.26.2

