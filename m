Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B3E79151B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350045AbjIDJw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjIDJw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:52:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB04610F2;
        Mon,  4 Sep 2023 02:52:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQIuqUT0LTPeITabvQbKZRij7qOxIojPjcQQUUJPEBMp6cIdsfXhDtgmUNQrkj1FPI2J4lCN6ysuIDHDUNmLBZUGMKX0nC/FLytGyfv8A4BExdeCHZiXpbARr9VIUMFIRic4Pb0hmxiFz1ZJdKq1fb0uyZ/7RdZ1nGEGXT5dVQ9Gd8Ziq32vKyGz8nsi0D3yTHZrcNfe6LiBuNeJ7BM6JTQ58NDCbcLJut5JvKDHwoc1XtFcMTXiY/2owKBwoFRXtpJgOjh89a76zM3YNLnPf5OahJ22PEnKOgHeWQ9t00A5i85P3bpUmo4CFo/S416vr6zPOSk+4SGb4qakL56egQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLrTY6zkzPkoCxHMGd1ST/drJbrLZrSgECxrqJzRXv8=;
 b=ja9kslUu+MmgkfFn5rhjRGSY7tutaldmS9y/lBzoYOka/vxzBpzLrPLoI0l3lgChGCHYdrDnwg193nJ7zbKa0BlQ/6BujGAYLDkyOJwNM1j9NFy1JP/IoDgEwPvKdB33c0Y5awcBxXDQf7A5xJ7AniltRy7ucbPJVsCOKKhUN4lyFx4FtnF5JobsoLAk8fWNAie3fYgZKzJE8oM8iAcnknnXejEm2V+DJXIgJ/58oaSFg+8k8kSh9CXuHNFWpYkaQ0bvijvsZ7SmbrB4qAkSoosnf2Rv/yDxS1NpPBcQxVnqYwfecr3hMXvrDATvFD9PpYlgq7z0DFVpxPbDLgV8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLrTY6zkzPkoCxHMGd1ST/drJbrLZrSgECxrqJzRXv8=;
 b=jakdjVEsapAvwSsmYhgL1V6T+0Lw0MGXcmGo4ZRW7jw6JeCOuS/7VUsbWMYEuxXzw+X8UZ+KhIIU4UKmGs7IDdC2o40L6RiifUTrsZER+i/Hgi9/ZlYaWw7D8B1JTgPEfqh9FTim3Zn1NEeF5ClTC6ksa9pLerfovIQiBNDBSSw=
Received: from MW2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:907::16) by
 MN2PR12MB4157.namprd12.prod.outlook.com (2603:10b6:208:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:52:43 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:907:0:cafe::81) by MW2PR16CA0003.outlook.office365.com
 (2603:10b6:907::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:52:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:52:42 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:52:37 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 01/13] KVM: Add KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC for extapic
Date:   Mon, 4 Sep 2023 09:53:35 +0000
Message-ID: <20230904095347.14994-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|MN2PR12MB4157:EE_
X-MS-Office365-Filtering-Correlation-Id: 98012142-aa3b-40b3-c966-08dbad2caeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qP1fBHKwV00/GBmHNyA4IO/yyrhOmTzC0RjYqyqDezNlZJN5W+smr4EflRs7yRwwP9Y62KWFZDcwVg0YaXmj75DGtRJLOXySi+rgdc4YCUyWTsGOGLv7TMqxpHWXEwouJakS24/ds1xE7+35jCBWf31I0DzSi2JB1RlkHp7b4YUq0W+CQQLpzAMahtll3kg4TtKhpgjaiA/DJcYqxQR0PhxQkaZioUcRy+fr2yFHI1pPNIRga5MRCsYpTgp97vGBO/iTsmlzdjGL6iooaBhLmQyotk4EMyLj4g9Y5XrCCu4IaGlZh13YK+8iZpQuW9BMKmOe7gyTAS6J7yWvlWeLLyTdVXeGIG5IApGXfBSuB7A29KwmwjO0ODkPC2QuhVexoC/K3epGYjXPdWtZ/JvjhU+lAMAwW0x09mhIiyOkSV85SUBBDd5WZHv6AEgQWsTC6WREMFg4plNh8sk9fV7aYAqv/dVxKI1Sq1QohKbUqjbwPDGu8N6rx+J+5BVWsIJjmOthfitzTyRKY4I8OBHHhtEfomr6UHNrS91PWAz+HIfXNdgETtj85qZN11qLZ6Y/+p3xuM7xFWVLDaTgL1LHQurd+MzGZ2Iw7iT9+mj62FWekxQk8raWhIf7DEbT4C00hCn91P6hLp+RO7JCJuAI2qS7qCT1H5wcUDBxr8OPHWGFhY1Vt71c5xCUinxeBypAzOiWuL41GJL7MIZlJ+Nyx7dmbpK1An6jt5wPmpxn0EsBpUmO2Kwtx7ZbyEd1H6vQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39860400002)(396003)(186009)(1800799009)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(41300700001)(40460700003)(7696005)(356005)(966005)(82740400003)(478600001)(81166007)(83380400001)(2616005)(426003)(26005)(336012)(16526019)(1076003)(36860700001)(47076005)(70206006)(40480700001)(2906002)(110136005)(36756003)(54906003)(316002)(70586007)(86362001)(5660300002)(8936002)(44832011)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:52:42.3137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98012142-aa3b-40b3-c966-08dbad2caeba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4157
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are four additional extended LVT registers available in extended
APIC register space which can be used for additional interrupt sources
like instruction based sampling and many more.

Please refer to AMD programmers's manual Volume 2, Section 16.4.5 for
more details on extapic.
https://bugzilla.kernel.org/attachment.cgi?id=304653

Adds two new vcpu-based IOCTLs to save and restore the local APIC
registers with extended APIC register space for a single vcpu. It
works same as KVM_GET_LAPIC and KVM_SET_LAPIC IOCTLs. The only
differece is the size of APIC page which is copied/restored by kernel.
In case of KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC IOCTLs,
kernel copies/restores the APIC page with extended APIC register space
located at APIC offsets 400h-530h.

KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC IOCTLs are used
when extended APIC is enabled in the guest.

Document KVM_GET_LAPIC_W_EXTAPIC, KVM_SET_LAPIC_W_EXTAPIC ioctls.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 Documentation/virt/kvm/api.rst  | 23 +++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/lapic.c            | 12 +++++++-----
 arch/x86/kvm/lapic.h            |  6 ++++--
 arch/x86/kvm/x86.c              | 24 +++++++++++++-----------
 include/uapi/linux/kvm.h        | 10 ++++++++++
 6 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 73db30cb60fb..7239d4f1ecf3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1961,6 +1961,18 @@ error.
 Reads the Local APIC registers and copies them into the input argument.  The
 data format and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_lapic_state_w_extapic {
+        __u8 regs[KVM_APIC_EXT_REG_SIZE];
+  };
+
+Applications should use KVM_GET_LAPIC_W_EXTAPIC ioctl if extended APIC is
+enabled. KVM_GET_LAPIC_W_EXTAPIC reads Local APIC registers with extended
+APIC register space located at offsets 500h-530h and copies them into input
+argument.
+
 If KVM_X2APIC_API_USE_32BIT_IDS feature of KVM_CAP_X2APIC_API is
 enabled, then the format of APIC_ID register depends on the APIC mode
 (reported by MSR_IA32_APICBASE) of its VCPU.  x2APIC stores APIC ID in
@@ -1992,6 +2004,17 @@ always uses xAPIC format.
 Copies the input argument into the Local APIC registers.  The data format
 and layout are the same as documented in the architecture manual.
 
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x540
+  struct kvm_lapic_state_w_extapic {
+        __u8 regs[KVM_APIC_EXT_REG_SIZE];
+  };
+
+Applications should use KVM_SET_LAPIC_W_EXTAPIC ioctl if extended APIC is enabled.
+KVM_SET_LAPIC_W_EXTAPIC copies input arguments with extended APIC register into
+Local APIC and extended APIC registers.
+
 The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
 regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
 See the note in KVM_GET_LAPIC.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1a6a1f987949..d5bed64fd73d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -123,6 +123,11 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+#define KVM_APIC_EXT_REG_SIZE 0x540
+struct kvm_lapic_state_w_extapic {
+	__u8 regs[KVM_APIC_EXT_REG_SIZE];
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dcd60b39e794..7c1bd8594f1b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2921,7 +2921,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
-		struct kvm_lapic_state *s, bool set)
+		struct kvm_lapic_state_w_extapic *s, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
 		u32 *id = (u32 *)(s->regs + APIC_ID);
@@ -2958,9 +2958,10 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size)
 {
-	memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
+	memcpy(s->regs, vcpu->arch.apic->regs, size);
 
 	/*
 	 * Get calculated timer current count for remaining timer period (if
@@ -2972,7 +2973,8 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
 
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
@@ -2986,7 +2988,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 		kvm_recalculate_apic_map(vcpu->kvm);
 		return r;
 	}
-	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
+	memcpy(vcpu->arch.apic->regs, s->regs, size);
 
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..ad6c48938733 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -121,8 +121,10 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size);
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
+		       unsigned int size);
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddab7d0bb52b..e80a6d598753 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4925,19 +4925,19 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
 {
 	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
-	return kvm_apic_get_state(vcpu, s);
+	return kvm_apic_get_state(vcpu, s, size);
 }
 
 static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
 {
 	int r;
 
-	r = kvm_apic_set_state(vcpu, s);
+	r = kvm_apic_set_state(vcpu, s, size);
 	if (r)
 		return r;
 	update_cr8_intercept(vcpu);
@@ -5636,7 +5636,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	int r;
 	union {
 		struct kvm_sregs2 *sregs2;
-		struct kvm_lapic_state *lapic;
+		struct kvm_lapic_state_w_extapic *lapic;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
 		void *buffer;
@@ -5646,36 +5646,38 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 	u.buffer = NULL;
 	switch (ioctl) {
+	case KVM_GET_LAPIC_W_EXTAPIC:
 	case KVM_GET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = kzalloc(sizeof(struct kvm_lapic_state),
-				GFP_KERNEL_ACCOUNT);
+		u.lapic = kzalloc(_IOC_SIZE(ioctl), GFP_KERNEL_ACCOUNT);
 
 		r = -ENOMEM;
 		if (!u.lapic)
 			goto out;
-		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic);
+		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic, _IOC_SIZE(ioctl));
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(argp, u.lapic, sizeof(struct kvm_lapic_state)))
+		if (copy_to_user(argp, u.lapic, _IOC_SIZE(ioctl)))
 			goto out;
 		r = 0;
 		break;
 	}
+	case KVM_SET_LAPIC_W_EXTAPIC:
 	case KVM_SET_LAPIC: {
 		r = -EINVAL;
 		if (!lapic_in_kernel(vcpu))
 			goto out;
-		u.lapic = memdup_user(argp, sizeof(*u.lapic));
+		u.lapic = memdup_user(argp, _IOC_SIZE(ioctl));
+
 		if (IS_ERR(u.lapic)) {
 			r = PTR_ERR(u.lapic);
 			goto out_nofree;
 		}
 
-		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic);
+		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic, _IOC_SIZE(ioctl));
 		break;
 	}
 	case KVM_INTERRUPT: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..e1dc04e0bf44 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1591,6 +1591,16 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
+/*
+ * Added to save/restore local APIC registers with extended APIC (extapic)
+ * register space.
+ *
+ * Qemu emulates extapic logic only when KVM enables extapic functionality via
+ * KVM capability. In the condition where Qemu sets extapic registers, but KVM doesn't
+ * set extapic capability, Qemu ends up using KVM_GET_LAPIC and KVM_SET_LAPIC.
+ */
+#define KVM_GET_LAPIC_W_EXTAPIC   _IOR(KVMIO,  0x8e, struct kvm_lapic_state_w_extapic)
+#define KVM_SET_LAPIC_W_EXTAPIC   _IOW(KVMIO,  0x8f, struct kvm_lapic_state_w_extapic)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-- 
2.34.1

