Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CBC6A39E5
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjB0D5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjB0D5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:57:21 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA401E5FC;
        Sun, 26 Feb 2023 19:56:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkGJWwzurKLlbID7eL3KesMpVBmOPwDsxwPo8ytC2MOZW/3CkvcsQ2zpJMF3orkQScisfUvCLKseVeCPuenxCIgj0JJMmExu9+cjsx3ttfq75B6Hlnd3QN55VNlr0frT1Ps8IRasd9y9daxONnQVV6wX5O2CZ+BO98EO4zaYYBOfo5FedA9RnKInT/IF+J/unCvMqSUvZx/jaNkD+sTfkKT0SZyzbfMYh8Hu65MLZso9+mMjoi4J4c5k2/uG3pSzdGacQcfPSyl+jW956wGwsHZ0FHGCvMRIfXfab0R7H7vWL7huECy0HbKpPu3kGnggIhRdzhN8gW2HvQ/47zfH7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OomX125WHtEtfsV+1qUccQcIwk0c/ySbmyUbcxEXG54=;
 b=e37FbMYJdfTRiNttv1kI/aSsnZUexiN8df6BAZM+in9SCTBEnaVLgF3r0txO2/VOAmq6nDQnMw4+ymcw3J0XrLNk5ajEKFeA0UbneYk46X24u/jV1ezVMDMmeRLJfugOMGTK/AH2FG+A7/ZoASiiU/96Tvnp5BYf8yeT3f4rAMglVxsZGODQvZunQyGTyloq1LkNi9WGs1QTaUhoCGwGT1FcqH6HAodc1yQ0nUuyC47/ALS566i/ctpJZZ9jYOW7mp0ce/T1Kau3hE427ORkqIC6T62sN1yAGihQgzGoOSCa3dCr9RqZXlmVu3T7scn/bM5GxFfHsbiIu8D+Ztrm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OomX125WHtEtfsV+1qUccQcIwk0c/ySbmyUbcxEXG54=;
 b=QoAxpyslnLKCZrzb61gL2f5v1/XD5ZCvqnoBsHZXYA1jREydWEo2n/afzurbQmshk81uD/0nkWJzOob+NA+fVUo2CUoJTAjHLRCx6LZf220sRAvbVOPzzvpQoifFcqdqJjvABDjnKQcuGxy3vd0+NofPNo/zYemm8obsJlXrtG0=
Received: from DM6PR18CA0026.namprd18.prod.outlook.com (2603:10b6:5:15b::39)
 by DS0PR12MB7510.namprd12.prod.outlook.com (2603:10b6:8:132::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 03:56:48 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::eb) by DM6PR18CA0026.outlook.office365.com
 (2603:10b6:5:15b::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 03:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:56:48 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:56:32 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 08/10] KVM: SVM: Add VNMI bit definition
Date:   Mon, 27 Feb 2023 09:23:58 +0530
Message-ID: <20230227035400.1498-9-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
References: <20230227035400.1498-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT065:EE_|DS0PR12MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 3deacc2a-e009-47cc-da98-08db1876a689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/5wp0imEEvhA8DoHm38NTa13Bhv2y1GBeasVW+7h9Top0g3UnhV6OKwLmPUpRKyLE5WMA6M9V9IkCQ9J3UOZLVjrbJOoHShVoyJpIer8zV2DHB/ghdrV+pmbG94iUqhg8lnFd1Hhz5hzXx7JaSJ+8MA50ssSNGDsLXvkx9hmlEkZ58gUHP0HNSJzYhXU7KAHZaFdfThSaWEHwNWk/ovjqeZbHAbMjiuo0GCNQscLMh48+UL02DtfLyD92rBHwhMrN5XXo3ONsp/3Sms8mgV+d5jujpqPGyyqsWpk1C6cwR9YH6w/C7OyJB50HK4Hczxa3B87fMAYMGGpc56l6/32vIFFcPWJZzm3QK10Fsm7a1KGkP4yhpvY7GFMze9x+dKW51BlXrPePqkq2I3xI9GTzMh2olPrF3YLw14zSOuYuE+kBhKbRsnxMDoX3j6HOyxIIva3w5K9qWsycz3NRJ2sDUuDqJNAtXQUXCe32qP5nP+1eFqNIQx2qcm9fJOxvnr9TXKGPZJQQEBa00mJ99pe6WC1644EWa9l6rRovedvxZZVV/wAPxukL9atAPzrVUs+XaaQ3kDhg30VEvbZT92QSjyEeO1PZvuFl9hMgNbfUo2xY5nXwXXvHznwj7pkImSDylivbbFvJlM76Les0m4Q/kUc6DsIhUgA5OLjiOsneWGr+kMb4jV7SZ+X1oUD7sFSf21QIcG+fXxjQK3tzYDyCl8zKoUKe2vUPGcb3q7cdc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(478600001)(110136005)(7696005)(82310400005)(70206006)(356005)(8676002)(41300700001)(4326008)(70586007)(8936002)(40460700003)(36756003)(86362001)(40480700001)(26005)(186003)(6666004)(16526019)(966005)(426003)(82740400003)(47076005)(81166007)(336012)(1076003)(2616005)(2906002)(44832011)(316002)(5660300002)(54906003)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:56:48.1535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3deacc2a-e009-47cc-da98-08db1876a689
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7510
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

