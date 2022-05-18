Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0852C045
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbiERQ2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiERQ10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDBD7CDE7;
        Wed, 18 May 2022 09:27:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyfxNsM1dyheTwegfJidFcKA30hPFKIBR9Bx+diJmqWdF4GjPcooze+QBRXTGvQj5HiGhqGgoK8s6JSPz/qBTOPtDa1ihOZD223I+eXgWDqUODiaRdAM6N7tY84cYDXKgZBo1JFthOxpfG19GKXO8bXPTVqHX84X95QOShQz2o7Gu6YVyKaXwlreuMFb5UiLgZ3a18WbLbvvJdkjAVvhuxiFjPGt7niwabWTrP/XBXIOcGFH/ZhHsFmXHAr/G5wC/Y71OtS62bHzIiIPkPfEP6uhu2jqBPnKElOQZ+3ltSmcFdwbz0lHxvn1BeKbwwOezdTOy/kpa4BG8noqNuTEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/Qm/ohhI1YVz9MCRGs3yk2RGJy4IIf5wX9E5nxQerE=;
 b=VDG1MPQQ6PbUUacLyDEUF7qLub0RAFsXN/+I9oIACQ1pWhSm/Fl0RiyNpuUUDlk6YuoFNqrVjWZf6A0R8G8m72NYqTa5dQUON7dGhn3CkyNXFUDBpmlvIN4bK7A+z4C5oV7xsHTIaq2iPuaCCt7UAfJikLyfMqIYH8sXbldT/cxoD7aU0XpK5JgF25zIelX7KLKLaQgJwgwKUhKRV8edsoIA3H91NxmJYzdwgzMjRxRdbpoWWJcOk8VzUCd8mZVqgL5OOsk3z1UJePVS6Coz+ObWkz0bBHGI20v18UcftoggoSs36rbtLsBa46judfaO+k1GKvxBrzz/nifWxKgKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/Qm/ohhI1YVz9MCRGs3yk2RGJy4IIf5wX9E5nxQerE=;
 b=dPiqZ6UBWGFP2HKnuANTd0jETj0yhadsCCJsskBHebfU8SXqCv1CwW/sQ7pyFjpKYDAOY/Bj3LkGEPr/NFsgcw4FN6PKXV0kVZ60UHP8ZImi1o4SOMwRI74TP4dO04rHbMEY6tB7GCozcJRHj4++VjxknwYJ/adCm45FJNQ0bGU=
Received: from BN7PR02CA0022.namprd02.prod.outlook.com (2603:10b6:408:20::35)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 16:27:20 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::6) by BN7PR02CA0022.outlook.office365.com
 (2603:10b6:408:20::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:20 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:17 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 16/17] KVM: x86: nSVM: always intercept x2apic msrs
Date:   Wed, 18 May 2022 11:26:51 -0500
Message-ID: <20220518162652.100493-17-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: fcf54a5c-5ec0-4806-abf4-08da38eb4809
X-MS-TrafficTypeDiagnostic: BY5PR12MB4051:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4051A0A5763A520E33826D83F3D19@BY5PR12MB4051.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEpS3mqC/LIrg21X9wROhLaL3ieG7+EqPqu0va+K5xWx0aqafBB3KVtKe0ZBwzRBaXKXbnrSc/j/yhVsDKs5Gtr0h7lUIoGGwLAF1ZK1k/vgSFejk+mgFOTYFB2W/G0+DilEVp1hNUO2g1+tmYAzqGA+9ueMiwUMfTLQP25x3CX3hs7bQJv6+XRrqBzDWjkxL7uyAdH5swHbtgL8WtmDvA1d3AFgJV1nwppBAULf0RCnrycDvXSZ+WWiqSG6OdLvH1Td8CFrcjjg7K34Pv/KnFbDJlLfT+EdjBDFCCcuzpWIncSEMtcee+L//fuwFIi3u0ffqx71CJcCFU1R8E0bEp6p7SXHbBxtaRYz2EH/Z57XAgvz/yvkRVS9y3XccTVhgqQHVgfYSbpKcNMezdeH0ducbJlOHospiwVFo8DidY8AsiOG2aPvgbNkU3yYT7q4xg0oJNYU0uAHP7qurI8C+ezZ57elwGNCnrDqYGOpdhLJvhAft8oCZlte82/9IpQ2iz6t/y4j13vavrT9Ph9hBKoNld+KXCi/SRyL2HywWlG8nFmdM1vc5I35myQczOE8Alx+2doxwZM3QVzYZCK+K0+DCIv8p0ncHVE4e+Yvr5KF20xnxC4ncY/cSWIN1LyACLOU0oOGKr+qmc88CGMXUTqOROlN8v9q+vDWS8IjCsDuU+9kW28xz87Ilu3ZjurK/l866NRwuRWvOJwjkuLzwg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(8676002)(36756003)(82310400005)(54906003)(110136005)(70206006)(356005)(4326008)(36860700001)(70586007)(508600001)(6666004)(40460700003)(81166007)(26005)(5660300002)(44832011)(8936002)(2906002)(16526019)(186003)(7696005)(1076003)(426003)(86362001)(336012)(2616005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:20.2628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf54a5c-5ec0-4806-abf4-08da38eb4809
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051
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
index 818817b11f53..309445619756 100644
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

