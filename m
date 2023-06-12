Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA672B6E8
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjFLEvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjFLEvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:51:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC5C1710;
        Sun, 11 Jun 2023 21:50:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr9K7FC9j34n1LlFCJy9piR1fC7/nj9koxs6u3uWx9oKk4+w+U3uBCiClu1tSv3/f8mv1hDyDGgkwlozBKTjkP/kgTdqkU1IYn+FlBrBzhPD4yShw6aumeabJ3qtCEB13n1IqUizVqC1zeQJD3FcjbwFRzgj5kdPpPPBfbCZiAURce8AoNJX0GdPp0d0pfu7GdpJ6uvwWNnqKoxw4iU/hVQ8jIO4hMYDP36o8DydfV80kbAogiznQHxHChRDlnCiTkGM0/wpcMWIZZdKC+kFjCjdcjOCg9Q8PUP/o/hwDtWGNhskmYieTAe7mr0BWN/1eRyMbHAqOEKN/quVCcC+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s218HDiFv2eZBxy4ZcFM21BtWf4J8w71c4nYAY2Bnnc=;
 b=HfFEeFtEQ7p3hTNnj1KWhxvfNIzmoqIxB0egB/sUd5xtuHuCQzmb0NL/RGr7liBuSxUP2ipSzLFuWMWINNYSU9SDlNHvKLIBppBzu9CXDh2cZfAn/4wsCMSbddkf/EKZKGskMg4U4z3ADt/FsHVAZwoXjaktcYL7TAJjTTic2gHxFOLWIrMYQEL0T9Q7Jp5jyIrnYo0x44F9j5cBtRy8ZXd9ZjRCcCJGOyLLW4ASCkIddtF4uNI2/vge9kz4zoiYkVOwuiwAZ4zvxjw5r2qRASaUp+GW6lZyruQK8Y8TU5buctMJ7y1oQvlx5URDXti+fz0hJW8TfBGeAjYRGB7XYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s218HDiFv2eZBxy4ZcFM21BtWf4J8w71c4nYAY2Bnnc=;
 b=UUfF3W1yo8GdhhtHwYnzq4wvAkKs6xROhS4NVgnunYA5lqMw34ZLZeZkIl8cajtZzRhGa6aBLUYTGCdqhqISsv3NdqAhmGkzW4g/Ux5G2osXh1sZ0C+zv/S1WhXEQAImVAZCrUnN0Onz0q8oAIZyiuwyZBQLLaZY3XNqWoOBqpA=
Received: from SA1PR05CA0002.namprd05.prod.outlook.com (2603:10b6:806:2d2::8)
 by DM4PR12MB8475.namprd12.prod.outlook.com (2603:10b6:8:190::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:50:49 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:806:2d2:cafe::86) by SA1PR05CA0002.outlook.office365.com
 (2603:10b6:806:2d2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.22 via Frontend
 Transport; Mon, 12 Jun 2023 04:50:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:50:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:48:05 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 03/51] KVM: x86: Use full 64-bit error code for kvm_mmu_do_page_fault
Date:   Sun, 11 Jun 2023 23:25:11 -0500
Message-ID: <20230612042559.375660-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|DM4PR12MB8475:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e8f260-5b71-4611-a0c9-08db6b009782
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aDTmU/JF0XyDbGUVKUj65tBEtjtLuT5BwMkK4wsD/2Ki/WhY9VFnF6Rq49Y75ezZ7cTxNJ+WZf7sVCbJXTP0HvFMwXNNoTRn1R6m2DX1ig5NleoiLUUBzYLNwkhlqnTcQN2eLxC3FIdE8jCf6MA2X5+W9fBtzcFY5k43YvJpIXuyP1pXsr9VqZIfex4qbTED18c8HVoAIobgk0PYNqq4zKxIF+7cKR/Way2gOI1KOCcXIhbEHXOjv/y5tLVxRa3fbUOTp26MoooeFiv7kChTmEB+PQE1fPU0wXFxHs6vdThFVM3In3HrCpdxfa2qrPL2/JCf6PKXMKmJAiUEAR+jbXUvl+qAVQILrlEYj35BwOme/tCm9QLUVVmPfdPyCtPeEIxNn+V21acxnF1uBg4SNW8LRk4IOiY98tl/GIPTDV4e3UcAXOq9MEMt8JmjccGfjRzhQX755kZMazURioKJkTkaYJvo9iTER/p2irw6pMnoYXDwS4MKaACC//GE1/nWVVu8CiN1aeX5KqTjN6ETW3GcLk54PMT+JhACavujG4KJ3SinBUmZw34DXS9qtzRZX/4cib8DsIxRdG8cxaaw3ow5vEO985Lx7U44XFHNgGjFhca7M1msx2dOgIe/TcRP8oAELulRsjAJg8Wh78+5+uJoPvdBLm/SerfqU0oZiAFLNjVY74lPnK8ZxHnAFemamNFMC2syWhpG6UKgtBWVDHuAApurLbcwtXXzF7QUwS3tocuMXsNxFDeEtCRD4wrv/HAOPYFV8vaxHcYKih5sCA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(356005)(82740400003)(40480700001)(36756003)(86362001)(82310400005)(81166007)(40460700003)(478600001)(54906003)(44832011)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(4326008)(6916009)(41300700001)(316002)(186003)(16526019)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:50:48.8524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e8f260-5b71-4611-a0c9-08db6b009782
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8475
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upper bits will be needed in some cases to distinguish between
nested page faults for private/shared pages, so pass along the full
64-bit value.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c54672ad6cbc..0d3983b9aa7e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5829,8 +5829,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f1786698ae00..780b91e1da9f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -283,11 +283,11 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
-		.error_code = err,
+		.error_code = lower_32_bits(err),
 		.exec = err & PFERR_FETCH_MASK,
 		.write = err & PFERR_WRITE_MASK,
 		.present = err & PFERR_PRESENT_MASK,
-- 
2.25.1

