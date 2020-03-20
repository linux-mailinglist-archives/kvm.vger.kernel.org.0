Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3662F18D5C7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCTR2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:28:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52070 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCTR2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:28:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id c187so7414264wme.1;
        Fri, 20 Mar 2020 10:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3+1+dijIgsDdRQRSO438ZaqORDXumTy12HEHcvkxO4=;
        b=JGKt4pQ46gQdOe6Umc8hcJbbrlURDLbLFG7pz1+bBdM9NSo9NHTsVXd0E95wfXdy0k
         Vjl/mdFRGhIetQSfZmBXkSpD+QmSW4W30tAutCVrAFfBZKFxfgnPwS4GN15SmfLinUe4
         RuxiPp4/iIlLbStssN7rDXA/I1qTmPhpxecPwYUlqzumFQEawcnrYGBIdfMBXBOMOVLl
         n5U82LaTILsvC8USS0+umd+wwcFVD9ffoGN5U/hSm9JPtqGy7ru0GZLYW3RkeYq9+7U6
         4AZe9Hoxx9/VFKaHNLMfYb0olpejisU2Cc/lezZ1Vmb1fdrCsQUYuXtQt7avBHEyKZrc
         21Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3+1+dijIgsDdRQRSO438ZaqORDXumTy12HEHcvkxO4=;
        b=XRehWXl0JF0sKINNtWvIo10DULz/v1rAAqPuC8ORYMhf9EKREcZ0yNOgc0QjxJn9Ds
         kMTy6GH1e+qm8sp9dyVgSALPr06gqtwNaF50Lz/VDypwGdISldzV+BiXWzeMbb/9Ejsa
         sopIyq1G2GYbxXXxHhS7r4KcYA4+UdJ7B8z6fEIb8GudHRcWPxyWHJoyYqFO+hxgWqmZ
         TqfpLXl13hzvDINxlvXMeLP0sBA4rfm2/IAbI67MoI7SuKqp3Z3WUov9IggQTMx64C3s
         N2XBdBQqAnmVI64a2bIFc4YjG21zTcwhLpM9ww/4nRV0HChDnCu86aZqVii4VKHmLo5t
         9kWw==
X-Gm-Message-State: ANhLgQ2xiFXPLZXnxWa/gKknYFefYbMb6PEz199omORAi5rXrX6rjGz0
        dwqzMjpeAXfeIvNvIMzz96JKj+QZAhM=
X-Google-Smtp-Source: ADFU+vvGlc6t3uMSiDoQ7l+WSYEqq9PiT/6TGsyn5rEyMslVGcowKKIRunNkpO4nninB6mGrMiK/Bg==
X-Received: by 2002:a1c:56d5:: with SMTP id k204mr12051300wmb.13.1584725331323;
        Fri, 20 Mar 2020 10:28:51 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q4sm11028333wmj.1.2020.03.20.10.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 10:28:50 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v9 3/6] x86/hyper-v: Add synthetic debugger definitions
Date:   Fri, 20 Mar 2020 19:28:36 +0200
Message-Id: <20200320172839.1144395-4-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320172839.1144395-1-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V synthetic debugger has two modes, one that uses MSRs and
the other that use Hypercalls.

Add all the required definitions to both types of synthetic debugger
interface.

Some of the required new CPUIDs and MSRs are not documented in the TLFS
so they are in hyperv.h instead.

The reason they are not documented is because they are subjected to be
removed in future versions of Windows.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
 arch/x86/kvm/hyperv.h              | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 92abc1e42bfc..671ce2a39d4b 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -131,6 +131,8 @@
 #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
 /* Crash MSR available */
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
+/* Support for debug MSRs available */
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
@@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
 #define HVCALL_SEND_IPI_EX			0x0015
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 
@@ -419,6 +424,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
 #define HV_STATUS_INVALID_CONNECTION_ID		18
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 757cb578101c..5e4780bf6dd7 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,33 @@
 
 #include <linux/kvm_host.h>
 
+/*
+ * The #defines related to the synthetic debugger are required by KDNet, but
+ * they are not documented in the Hyper-V TLFS because the synthetic debugger
+ * functionality has been deprecated and is subject to removal in future versions
+ * of Windows.
+ */
+#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
+#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
+#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
+
+/*
+ * Hyper-V synthetic debugger platform capabilities
+ * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
+ */
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+
+/* Hyper-V Synthetic debug options MSR */
+#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
+
+/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
+#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
+
 static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.hyperv;
-- 
2.24.1

