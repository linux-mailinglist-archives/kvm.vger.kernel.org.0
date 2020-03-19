Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A518AC8C
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 06:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCSF7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 01:59:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33472 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSF7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 01:59:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so1210243wrd.0;
        Wed, 18 Mar 2020 22:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3+1+dijIgsDdRQRSO438ZaqORDXumTy12HEHcvkxO4=;
        b=o9x/UL9w1fDYHIILcFa3uf6aJn216iEFxLANPYEj0KCgjVE0sfK7iXLkR5l4IMezEU
         pypSxDT/IyLFJcD66Le3K518eBKywXI2vB6GeZ14tl4quN6eZm3Ad/QqCrxyDDC5Gx/2
         5nuxHTzBLxpktqmvYxoz7fcHs9WnKHIpXe8gZTe5mJ266gs+OCYFpcBr0D8NFqU3tC3Q
         QqzYmVsiuowPtYgybd/upeC0mwFzFchOPkUxzsiQwURrNl1Zhzp0iA6fqgZoy2QcU/kq
         DhGWP2rRQqV7Sw/6xrNKxqY1VUK2BiT9oonjrLHdkfxY/ll+J3cm8OE7RoDoffWEF7i4
         aAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3+1+dijIgsDdRQRSO438ZaqORDXumTy12HEHcvkxO4=;
        b=frQB7wmtpmtLY5LVAlOibezgHPJOxrqz1QDibpoaUeyiJ0MN5iNvLd2hynJHmxb9Ab
         HT9Y/lxFZSZzs0uzpfqO5hEmR1X8qPzdmbj+UDLSGanTJH8UwPoGo5bZK4Kl5Tx54Q/q
         pxd/Nz1yz706r0s2I9olZNrr8wVVA9Pi7hAq/6CUEd7x/QMBTTt+Vq4P1g4zmAp7UOQ1
         Pfb+wXM3oXMjeR4nu6y4dQclEx29RH1PEvKwNzoAeyHYjRKrPVX9vqivRrXd5jaCypv3
         CBOC+uE5wlfc5iVoESRmC99BTSqhmkBLeTdMzKFqGz8EzTZeA5foKYGJvVUIfRr7H8/y
         7FxA==
X-Gm-Message-State: ANhLgQ1zcRPJ8sGwmnR3xFcd7YbgfuX5sHDWrQi/Zze4HNKBrvNEOv0o
        tg1h4SKwIHczBY6USSx8xHNK2rKhEG8=
X-Google-Smtp-Source: ADFU+vsLposVLHjCC8lWMItUmuIh5NIV6j4I3k82zdQhTS/E0QY6utF4w7JXAha/lHglDeegb188jg==
X-Received: by 2002:adf:fe03:: with SMTP id n3mr434293wrr.266.1584597538952;
        Wed, 18 Mar 2020 22:58:58 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id n2sm1884174wro.25.2020.03.18.22.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:58:58 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v7 2/5] x86/hyper-v: Add synthetic debugger definitions
Date:   Thu, 19 Mar 2020 07:58:39 +0200
Message-Id: <20200319055842.673513-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319055842.673513-1-arilou@gmail.com>
References: <20200319055842.673513-1-arilou@gmail.com>
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

