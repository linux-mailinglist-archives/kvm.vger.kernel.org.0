Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F69052BFFA
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbiERQ1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbiERQ1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDE64715;
        Wed, 18 May 2022 09:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luMPoPXV2cPkqHHWfbKT1uUd9MMTvVP0uEfgfarLumMFVwYC5VggEtPP3dpbft2Za96dcil85BB5sNA6Q0q24WeuEtqWIWW4p8++pykVkXV6wvlI+R8YC0fZI2cHobTN2xGreKSK+7XJFi1DjX/54yLCCKdaEXgqu2lqyFIIGYO+f4Z57pfQxGtIV76mmOlWqWOUPttdoosd74K2ZiIkHDM+BrYVxtoUGKR9vHl/UCAHoHKB6fA8VXh158CVYWw/v7kT0ScJLtnFH6Voa/4KXEi9uwqxlANyk580x3iBKvTULOks+yd0kX8hzY4K87nkUsk+mOLVcUKKjgB73BiXOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnglCy/xPXrLNOnm93nCreZT2JM/mgwXu4AHQzkO224=;
 b=QJKhAohbbke3G+AW4c5boGqr0VCzTAox/7AnQWeEodjrxY46nAtZFzVhqGgQF0bt0eLMMU72kC9L8tUbsj7KHbcG8B45BLZnHISbOicjrHbTc7951FqhEcDAdYhNBFCWYJChU3IxBbXS26okrRH9FofJdfyggGH7E+lCMQFBX9Vl6aPbGQhSbmvRobX0cNUsI0EdAw8cUp/lHybsHcRVbmmBHSu4QS64LGWcIT8f3tNxmQBJnK5uVon71aGfvrZFbeJ2GCmqoiVwybuE0uhXiu3PaHsgzVPd+Bifi39JmcLBcTJC3KfvadnLYKGjQRBFarDB9UelxrF5d+Z2vEI7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnglCy/xPXrLNOnm93nCreZT2JM/mgwXu4AHQzkO224=;
 b=wianEMnF0f1Ied7l0GlNtpa/qYZIz7hGuHFTRH+xNUI2NCoep6S0zHTj+P8GxQ4LcHeAJSR6LJZc09ROZrfpWWgdlNN8FXvZSAiaWswMAy6upDLJWfZ4nktvFwLJu/jciYDG7/9rTzUco6NH1uaKZFpnsGd4Wz74IbjQvliNu8E=
Received: from BN0PR04CA0162.namprd04.prod.outlook.com (2603:10b6:408:eb::17)
 by BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 18 May
 2022 16:27:08 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::dc) by BN0PR04CA0162.outlook.office365.com
 (2603:10b6:408:eb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 16:27:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:08 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:07 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v5 02/17] KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Date:   Wed, 18 May 2022 11:26:37 -0500
Message-ID: <20220518162652.100493-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01067bd2-3d54-4dca-0c7d-08da38eb4116
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3876322CE5E4649140C9677AF3D19@BY5PR12MB3876.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hefHawLgVKjHLNmWejYNzTgNePiP3mMBuBkOCzvARiN1JNhQW9bkrW3GSQ2oQbj/Tg7m8XZC7YuEj/d+//Rpt7bIGpLEPeWr98qc8DW222gkB/1AiN/o4BKhC2C+QKSHIFs4Fh1h03Ifx5fGvnmCU0m6uZpGhCKHF7lpq0/HEGSqPRF7Y4EFAnTj6Ih/PdaiYfQBqthThK4yEVXR11CpS/cSY/3LHArZ42f/uc/dRoIQHcra1PMqva3QwhLA4W3tyvAgCLKBJIQ+Z4D5NarWluU0CL5Hw1NYiM27efrD32RFURlXRrByIvp44Pu4t8SizkanFmC6/eM1boDA0TCycLtHHxrLVTlIqp6L1gJQpBPGCSa1VEWps36MCzd/jv6gsxFX77XOgWeQqzwbfIt4lknaA1ZGIYhYRditTpdt6I2lFgnV9pC+MfB8AffGIEIvV/oB52OB/6GAAg7HJd1ipcoa/F8jDCwIcO358Xq0qvjq5P7CVMxbPa6FO4iNwQOZ4HI0kIzYZTZcv576VNzscqnVy7TXR24UIY+gJVtd5KJLPgriszR9S+1XIWSBhw/RmkVaLUbGAukvFwq4cxbHNnbDOnNGCOMgH7q/+Go9wazrWt7LPihW2ufVl/+t1/GkZjWONDKS1f2e450S5NpiuyJtONyXioxOS7g6GrG9WV6ZjpL9BHpmfXQ71ybr2aTr3oV/jTujki9jT5tvVfJdcQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(70586007)(70206006)(2906002)(82310400005)(4326008)(8676002)(36860700001)(316002)(356005)(508600001)(1076003)(7696005)(2616005)(26005)(86362001)(426003)(54906003)(47076005)(186003)(336012)(40460700003)(44832011)(5660300002)(110136005)(83380400001)(36756003)(16526019)(6666004)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:08.6155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01067bd2-3d54-4dca-0c7d-08da38eb4116
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3876
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To signify that the macros only support 8-bit xAPIC destination ID.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/hyperv/hv_apic.c      | 2 +-
 arch/x86/include/asm/apicdef.h | 4 ++--
 arch/x86/kernel/apic/apic.c    | 2 +-
 arch/x86/kernel/apic/ipi.c     | 2 +-
 arch/x86/kvm/lapic.c           | 2 +-
 arch/x86/kvm/svm/avic.c        | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index db2d92fb44da..fb8b2c088681 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
 {
 	u64 reg_val;
 
-	reg_val = SET_APIC_DEST_FIELD(id);
+	reg_val = SET_XAPIC_DEST_FIELD(id);
 	reg_val = reg_val << 32;
 	reg_val |= low;
 
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 5716f22f81ac..863c2cad5872 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -89,8 +89,8 @@
 #define		APIC_DM_EXTINT		0x00700
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
-#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
-#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
+#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
 #define	APIC_LVTT	0x320
 #define	APIC_LVTTHMR	0x330
 #define	APIC_LVTPC	0x340
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..e6b754e43ed7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index d1fb874fbe64..2a6509e8c840 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 
 static inline int __prepare_ICR2(unsigned int mask)
 {
-	return SET_APIC_DEST_FIELD(mask);
+	return SET_XAPIC_DEST_FIELD(mask);
 }
 
 static inline void __xapic_wait_icr_idle(void)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 137c3a2f5180..8b8c4a905976 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1326,7 +1326,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
-		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
+		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 54fe03714f8a..a8f514212b87 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -328,7 +328,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 	if (apic_x2apic_mode(vcpu->arch.apic))
 		dest = icrh;
 	else
-		dest = GET_APIC_DEST_FIELD(icrh);
+		dest = GET_XAPIC_DEST_FIELD(icrh);
 
 	/*
 	 * Try matching the destination APIC ID with the vCPU.
@@ -364,7 +364,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_APIC_DEST_FIELD(icrh),
+					GET_XAPIC_DEST_FIELD(icrh),
 					icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
-- 
2.25.1

