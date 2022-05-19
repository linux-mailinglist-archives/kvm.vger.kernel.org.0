Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA37152D06F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiESK2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiESK1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA354A7E14;
        Thu, 19 May 2022 03:27:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyJ+fyAfg6LWpt4qKiEQkV5oSNQdpbmZB448v4E1EEOu3pa2Vv2KyQoU5LN6s6OlP8ie4rT74UYulNtu+ZtZ6eAmSRYlziYgsIU4Zy+9yu0NmR8TNzlTNhAOuY89j2ToGC18QLTow6IFbWkEJg5lnp9BtegXwKVCY/KyeG6L2eiXmJAZ0fs3ANFI54hQU5JG6QOHg+xj7xmFy6tVltZWfhK2U1JogbpOHFMPmneutXExY8QjjOsGYnnPzgwDmFAcobC0NfZhsNkfLmK4gAmLX7KUStB2uezxgcRZbWxY3Q++DDeoQxgKnO1rTMMa6vw4KwSYGw0p3PBDljsM/Btaug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODKpWb8InaTb4Bxr96ER51q4LIVlRZd6l2Z6ASaxK5g=;
 b=YHQ6AfCLtLbHuBVeti1zIkr1i3Z2LmYfxr2NdLfpMFkbLqO7HK6dhSXXXtPqyXdPO6tzXIPSZI3L4M+yaeVjxRNa2+JLuHIVqDHjM64QVLDLdd7Td16qVUPvO54RA6T6DJFoZxDyLZxxcd+c29Sv3nRJZ6SvhBG2ZEYus/7Qkusc7Lj3fT62HIbPbEADYxBxroz6BG5a1ED29Mxt9dAQqZii9F/cMMVrO/kkekGDu5kI8ZKK49gwH1BSw6Jdn98wlMIPu3QlkmXFFcb6DIwt8QR2xFmrQ1zQjySYD89eyahC/bf9Weq3Cvry43VzKQsvvGrX7aRb6J82WUS1HeXOmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODKpWb8InaTb4Bxr96ER51q4LIVlRZd6l2Z6ASaxK5g=;
 b=jxNiKcE39IcY0hcqBKYu1s5PYDJvRlvmWh+20v6vEwZe+hV/4DmbJVxRDoTRcsi1+PelkJBmYRmyZwYH4lGaSYjPE+i2wYbibkwtjn38F4Q5Qx/NhLQwZFxaobNRUb2J8F9YHKfFCXOzmfXrmeZZM4+l4ZmGWFJg1COFHCa/z5A=
Received: from DS7PR05CA0060.namprd05.prod.outlook.com (2603:10b6:8:2f::13) by
 BN6PR12MB1763.namprd12.prod.outlook.com (2603:10b6:404:107::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Thu, 19 May 2022 10:27:34 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::4f) by DS7PR05CA0060.outlook.office365.com
 (2603:10b6:8:2f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7 via Frontend
 Transport; Thu, 19 May 2022 10:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:34 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:33 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 10/17] KVM: x86: nSVM: always intercept x2apic msrs
Date:   Thu, 19 May 2022 05:27:02 -0500
Message-ID: <20220519102709.24125-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9819669b-2dcb-4db5-e9aa-08da3982301b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1763:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB17632A3C5D343E1780ACE84AF3D09@BN6PR12MB1763.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQvOKh5g4mt/tVuA8E7DSJeGN6QnJQwH0UnMSKEqDx2TuYcC2Ee16/iYEM3cMGBfK1mlzOv5rCxogPt8W7incNCfTnZrgLYLiJIb3PbN98exNhimBYJZ3vlimKpXMMmpMsvzTraDthXze3q6BaixrmV+YGItAw26cNdKdtAS8ZiMQNXMMyPgGdbpGjzK//sjXqXD8EqzOQK+b6KDXVreTl/qJf/baPO6apShc1kcnpnBbN0+9xxhGg1D8eMUB+jcjqCTzSRor4whtlzRRzEkNuRKZh/XCL03kqDgVj9uDKeucEl/RJVBOXQ1TrIUYvP+iyXPkwl0mDOCi6wsByRswyWXhLkmFk8pSnnYOiKxWZcYAVD30o0cXDuYFV3taWX7DJdfiNEaX62AhXhy4hFF6gG0mouUL4enI5A0mWHUCo0klF8WiiwwlHRl6Np+7pAF8z/R68B3ZGcigwb+RnX5+BaeR4qDPwaXCu/W3OjBmxXNOV1sFbKOPQbF3H+q3bnwZYn7NamVZZqIwdXMihVOcnoTGb/a2CExXurRJWZ2CXFXwiTcFhteLG2/DFEWx+gei2TBPf6PiUD5mxLbXxFlPrSw8qUvOw4DI10guBaRN1cY8gVZeOmXLFAr5c9vDQ/ow467bMfYWJFMAfxA9iZeqlZHXuP/EKzLUbDUKU73vvBIJZyJB5/xEluqboHN2BZzFjeH9vVgn+niSyojbn4xFQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8676002)(81166007)(8936002)(82310400005)(44832011)(4326008)(5660300002)(86362001)(2906002)(356005)(110136005)(186003)(36756003)(1076003)(54906003)(316002)(7696005)(6666004)(508600001)(26005)(2616005)(36860700001)(70586007)(70206006)(40460700003)(426003)(336012)(47076005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:34.1076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9819669b-2dcb-4db5-e9aa-08da3982301b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

As a preparation for x2avic, this patch ensures that x2apic msrs
are always intercepted for the nested guest.

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 arch/x86/kvm/svm/svm.h    | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f209c1ca540c..b61f8939c210 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -230,6 +230,11 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 			break;
 
 		p      = msrpm_offsets[i];
+
+		/* x2apic msrs are intercepted always for the nested guest */
+		if (is_x2apic_msrpm_offset(p))
+			continue;
+
 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
 
 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 16f1d117c98b..7e53474c8834 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -517,6 +517,15 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline bool is_x2apic_msrpm_offset(u32 offset)
+{
+	/* 4 msrs per u8, and 4 u8 in u32 */
+	u32 msr = offset * 16;
+
+	return (msr >= APIC_BASE_MSR) &&
+	       (msr < (APIC_BASE_MSR + 0x100));
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1

