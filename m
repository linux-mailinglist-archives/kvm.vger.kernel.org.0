Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53086A3D78
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjB0Ixe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjB0IxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:53:04 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AFF211FB;
        Mon, 27 Feb 2023 00:45:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz+MXSDoe2oujSPOi94HVmDgaxRuMXiDnxet6cCojqytDWDV/uQRwM5FXoC5W0val4wo5/PbPGftOKpX/LuSoKOu7Nlul6a/6ifISyNO5SCqcdW5aKKBLZqoWMbyKA0/yHArHrZhQh9UfvxtmqjEeZXj27xJh2mzts1N6Tstju0fEZ7O47pGVAj8R6nrdmph26kQF2zdWjmLJX7ikeCPX5ctJHQqARRqVOrA6wxI4PRJZjfQtABkzQre5QX82mp0pJjLKyLsaJ4YHqCDS6Aq+5JEljkxmLJ4rqX3n8Wk+HubJKVEgGbVq5jwpBG4kEC2tEJlwwpwK1tKf1h3s0tIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OomX125WHtEtfsV+1qUccQcIwk0c/ySbmyUbcxEXG54=;
 b=AkPb0rRl3fVRoKoisMSCwg1rrmXZrSo+N2BDPGTqFywcRVpsbrifWeDZ3t05Z2cI09EEx0w/4TNTZM7JrZLhSyYIRiJvPLDdycsu+EUtqYkEA8oHyBdZY3g3ynPvqRvHu47aAvigtJ7Stec5xPpJfEqYgw7edf8RoXbEeKR0aRCGTsDDF1IL82onPCqjy2f7WOsZLuEbyQaP7GZ1F6pjMXXnk46kvf7BvTHfnVPwrtfBOuGHRlirip59diVKo8M2vyI50SvHxfGkF9gECg/dmLt0Dk9ToxW0BAFTYVj1OCJHzijoC3yeNNYjWdqipnnLUxrLA5k0vLf3fXNUs0KkXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OomX125WHtEtfsV+1qUccQcIwk0c/ySbmyUbcxEXG54=;
 b=ARtGMiuf85BkIPjCskzIrT5mTNBH4CigycbN6AjRVvJdG6qjGF0mozHk8+tIBU+URkx294oIkDVLJ//mzCDCTU2VXanHTqMcn+nZ1nIl9EaEeEF/Gz47S4WkIIADbgC0Bil9dO1FVXQL7CvHgyYuiaX5X49Rziyu+TFOcIqtu2o=
Received: from BN9PR03CA0504.namprd03.prod.outlook.com (2603:10b6:408:130::29)
 by CY8PR12MB7753.namprd12.prod.outlook.com (2603:10b6:930:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 08:44:17 +0000
Received: from BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::cb) by BN9PR03CA0504.outlook.office365.com
 (2603:10b6:408:130::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 08:44:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT092.mail.protection.outlook.com (10.13.176.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:44:16 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:44:12 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 09/11] KVM: SVM: Add VNMI bit definition
Date:   Mon, 27 Feb 2023 14:10:14 +0530
Message-ID: <20230227084016.3368-10-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT092:EE_|CY8PR12MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: ffaabbe0-0f78-4190-8d6c-08db189ecf8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjkIPTM+LJUeYtmdB1dV/S4/0Eln0FwUuNeknoRvRqBXAj+CsGvxSJAPITf5l6WDUcmyvg2AdYfJlZMKqod/j2iAD3vG9iMs0sycJz5RedzGZXAinDO894JmRzDeNHVfbtD8gCFw2wAeLztjAhfI2Q6BGsiwpRMpcqY3vhYMnqdTVxPp48cYs+17U2yWxNOgAAA2oHp3w/hUVcajwwZbBIIoHo6B8e90lwzqKOxikMfEvPfZonZkPQkO6HEtNjPr435HRqP74i7isFuXcC2OPd2XeNjvEs19H7IKuVwn24/NlcM7IPM0WKzUIg+d3aiAd3O5q1caI2QI2jIHQVmVLNG2OTGPHhgmrSxb7OhbU6v2EQNmv+nmcIxloNSaPrS/vmaYEwK/1HvfcTWdqMaNTEY9bkQEG7ifFtJ0bvif+tlLztNN3T4caZ9s6bJZczGcQCvl4PGQLPWXHQK8WDY9chHRxhn5fUcRvAUStSUOdP0p0fRJtaT/f+37VJh62CFk2iqSZYFPXAgQPVx02SrZfgri1YpqrqT8OYwanugpc2llqpCcR7xUW7aqM6RULpCUcYmaIRGh+4h/NJaoO8MK+JkbLfcOozIErNlEriDlzJrCQXa+OAxxIUxRSL+K5UGDUmN+gyiPkf5xRpGenIw7C++5x9jgUq9yS4G1qVKEijFsBH8CFaptQTOsA8Wv7FCkmJBme9UVaWNNV5OZeE/O6Hb2u3PQpvb/zOEYUMKASoU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(54906003)(16526019)(81166007)(26005)(336012)(36756003)(186003)(316002)(1076003)(356005)(478600001)(40460700003)(7696005)(966005)(44832011)(2906002)(40480700001)(86362001)(2616005)(110136005)(5660300002)(82740400003)(82310400005)(47076005)(426003)(83380400001)(70206006)(70586007)(8676002)(41300700001)(36860700001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:44:16.8713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffaabbe0-0f78-4190-8d6c-08db189ecf8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
virtualize NMI and NMI_MASK, Those capability bits are part of
VMCB::intr_ctrl -
V_NMI_PENDING_MASK(11) - Indicates whether a virtual NMI is pending in the
guest.
V_NMI_BLOCKING_MASK(12) - Indicates whether virtual NMI is masked in the
guest.
V_NMI_ENABLE_MASK(26) - Enables the NMI virtualization feature for the
guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction Or if
VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE_MASK bit 1.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3:
- Renamed V_NMI bits per Sean's v2 comment for
  better readability.
https://lore.kernel.org/all/66f93354-22b1-a2aa-f64c-6e70b9b8063c@amd.com/

 arch/x86/include/asm/svm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cb1ee53ad3b1..9691081d9231 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -183,6 +183,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_GIF_SHIFT 9
 #define V_GIF_MASK (1 << V_GIF_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING_MASK (1 << V_NMI_PENDING_SHIFT)
+
+#define V_NMI_BLOCKING_SHIFT 12
+#define V_NMI_BLOCKING_MASK (1 << V_NMI_BLOCKING_SHIFT)
+
 #define V_INTR_PRIO_SHIFT 16
 #define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
 
@@ -197,6 +203,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_GIF_ENABLE_SHIFT 25
 #define V_GIF_ENABLE_MASK (1 << V_GIF_ENABLE_SHIFT)
 
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE_MASK (1 << V_NMI_ENABLE_SHIFT)
+
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
-- 
2.25.1

