Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F281847E8
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCMNVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:21:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35829 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgCMNVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:21:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id d5so11732140wrc.2;
        Fri, 13 Mar 2020 06:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMFUZbMDJCq/vp1Kza/xjkerBKDqDN1GGhM0y0aJUlg=;
        b=e7ComhcaIBLJI5CtLAu56AOozwAs4EG57TDvTfzHgeoWJ8fyidlsw8C2/1FDUr0KHK
         7BsoN/MFdPcN4xZlszHHO7By8jTPE5NKMdngLBCdZToqq9uMshKyzoT48SWSCYU5EefL
         2GPjkGicI1XJ7ODx7gJRKy4qfYEKRdJHgmtklOMdXiu95g2IsFRlxA6A7Ck05LExQJP6
         aiD7abYeHMzfqt1wf+Rb+iHsjCA0EOeKCd233ekio0ttW604zWPGg7X0FpCtAT49dHsH
         jdjeBf+fEd3S1gn+8xpyalOnrfl0zQdN46eY89mBo8yEW6EKt0AjPdhVUPKF28/U59f+
         3y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMFUZbMDJCq/vp1Kza/xjkerBKDqDN1GGhM0y0aJUlg=;
        b=RcCYgVh8UxKaNqbfktH74sNH76FuJf5ctuwLQW/9SwBo6A+UM0PvAQECHnYTVLKaB2
         kvf9idi7KpfodfHNg3Otz8gY12Mf3W+NzGuvlolbVLhXP2O2mpXg1oWkWP4033ZP68M1
         ZWYJTw9JqVzL7ksc1mgyyZ5P9BvCWQEiioKYgmV6Gst+K0KOsbALrJcHAdM00/WAW1L+
         VhGaQ7W+cMoU3s/zRKwnxWR17AilxiwVeuTqKHNAaM5r9l1A0A1KIxprA4xXR6AtRh/b
         p/WReZ99RIoPyP5M14CsH4yvskvLvf2ufvTlmKSUY9LBGaZVNzXhyByorJ55ulcUrRd2
         ZrVg==
X-Gm-Message-State: ANhLgQ0rDPOOypw7k617azjH+PO0TIIUzCsaV+rDB8y09BHiSBCBkESH
        81xrHDJTzGunAIDaYh164UAAmMJRca4=
X-Google-Smtp-Source: ADFU+vvG5EBmaElhAgevpmE4B08QHs0ezrdjF5QlUw28+Yz/kSro8QUYys991jfSyAJXYdSjSS/PKw==
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr6953649wrw.351.1584105657495;
        Fri, 13 Mar 2020 06:20:57 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id v8sm77112121wrw.2.2020.03.13.06.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:20:57 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Date:   Fri, 13 Mar 2020 15:20:31 +0200
Message-Id: <20200313132034.132315-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313132034.132315-1-arilou@gmail.com>
References: <20200313132034.132315-1-arilou@gmail.com>
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

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
 arch/x86/kvm/hyperv.h              | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
index 757cb578101c..56bc3416b62f 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,28 @@
 
 #include <linux/kvm_host.h>
 
+/* These defines are required by KDNet and they are not part of Hyper-V TLFS */
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

