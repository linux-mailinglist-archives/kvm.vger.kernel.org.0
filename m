Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20268552810
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348540AbiFTXOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346074AbiFTXLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:11:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD200F1D;
        Mon, 20 Jun 2022 16:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqL3EpdA0kYy29uJ0HuFgnXFKYFwc19j5xgajLjNW4+uwQ5t3vIU/CGezY9qjFv6jm8SbvKR02fZnlXcfMXDCwOcgS3n3TRfM0WZEXrGrG6VIMV1EeOysqWjJal06RB4bcp3lEDusSoEClPJ7arsPxJ+sWQ2WKPpgr4fNLLlXHVJBjrlbTOqrxM85kW3FzYxCOdwvWz1X+NTR6+fWZpQ6XTQh6CrjP/DaNkH6bGq31prW49gN+6CAHAIGC4NmHwfVMs/crdc4UDUP37RO0ZjZXgyUt8msDLb00PtIO9vhHfypZ8cNArJFe6Q1bA6w/Jr+4oXRwnK4L9MXNyP0KVOyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efta1cNDJs0WthUX36PuDzopevN1H6s1CA8wvV2cSvo=;
 b=NqBpL2POZwvxUMmQbZHUqn9/RW7rO7TF2uVX4nMZps1K3wpxNNNbWrVoLV3014xyzY29JAw+yIVLnbGOzhTWAwZ50AYhsStkQs4TL0UKDc8UaMEUu7pAezrQ1GL3d1DUraxIOFIvOGz7O68jCSpflX+VwXZ6ySw5W1XLgHi83XrbTLBrvqi0kqk3M5qq7k4dNhBhd66Gwm/ZOlL/KyWMwvBNBaC7NHi7EKe8UZCoHBnGNApu5KdSYmu8C22RJx5tmQui2FtBM/5gnm1s3w2Yon7oG6u3s/BQMoI+8LufsDdjAqufaaG8V8zeuYRlYBdndInKI4IWw+o1/7NZfrvwmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efta1cNDJs0WthUX36PuDzopevN1H6s1CA8wvV2cSvo=;
 b=K0GtHKpTaCdatcTkT11Qf2iLYRTRkjDaYwY8K8z53Vuw+RTtTJUN0i9EtyKh+xco/1t+jQNgRqJeJswupxis4ez8DA9p+I6gESejcNq2FwFjk/ZB8Re8FiPYtnGkUSvYsHCtJeR39tL8kG/cgRtfhEOAoDxFMdSR9Sbnm3pn1bY=
Received: from FR1P15201CA0042.LAMP152.PROD.OUTLOOK.COM (2603:10d6:202:6::28)
 by DM5PR12MB2552.namprd12.prod.outlook.com (2603:10b6:4:b5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Mon, 20 Jun
 2022 23:10:24 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10d6:202:6:cafe::ca) by FR1P15201CA0042.outlook.office365.com
 (2603:10d6:202:6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:10:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:10:23 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:10:20 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 33/49] KVM: x86: Update page-fault trace to log full 64-bit error code
Date:   Mon, 20 Jun 2022 23:10:12 +0000
Message-ID: <a937386611dc7d38981c8a08255c4a71f1295d9a.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f3e937-cb27-4031-958d-08da53120e06
X-MS-TrafficTypeDiagnostic: DM5PR12MB2552:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2552FB19E38895B5F5B1BE6A8EB09@DM5PR12MB2552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QddsYhbpU0iH2igPO8ksmaLcFJDGY61RHUSg9oQ364jWWct0nW+Ol82yeTSl4KK7VUkl92Jj62Rs9dtQf3Sb9Ii7EWbwRSYYC3DPpdAQvCqI2InfSm2tZUMoZNJ3qaXqlYwzmQyWY7riUegV9E/dbf47bfmZP5ZjswRUTnf/hYB3vichM6XwhzLEdyv/C23UnlDZthaQZbXF4DwQkUKFpiT9AIk4PrN3MBGaBJkDahK76UjVRhN0D5MvVJlwZP0x6AFcbcuMQvNsO8V1SGYBXYGKqjgt5CvmjY0hIme0CRlM6Ty4v0xWMmc8p9bQ8N8pag5CTKdJM5Huqy5/83KiE28n2WFWEQO9fcNmNkVujZ0LH0tjcZ/9IDelJ06C7u+OxnCJa+n6cL3qjomdY3RDh/qpu4HDjckUo8e0aP9ldM1oYfAdVEALG3waxrfOCH6rrlbjdKT8tuD/H7TUpAMWj33hx3tuqgp0VR84hoX3netjaIFLAJbPsAxvi+5MiInQ4KEuA6EUJyq9MNVKT2W5bRUZ7CVcWcFGcey5GN8m0kvCN5zjGB5A+TE3tYZmqgU7I3L9uPaIWzw0qmhDV69yadkr02olvEWoGztg94b6B5z6Yw1Uch135fVEe15kS0m+zqj89e5evL0c8m1SZDK4CDEZ17V+qYsdkOuGsxTUcnAbSoiWOwXmJwPkEBEG+lTmPm1r06a7usc6YuoQtUHjVZAaozl84nPhdB6FvsO/jzKAYgAXBhTkOtshDua8R5kyvGXOjBU11VYXq0ULoLyKNA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(40470700004)(26005)(110136005)(41300700001)(316002)(6666004)(54906003)(16526019)(186003)(40460700003)(7696005)(82310400005)(478600001)(40480700001)(2906002)(70206006)(70586007)(4326008)(8676002)(36860700001)(83380400001)(7416002)(36756003)(7406005)(5660300002)(86362001)(356005)(336012)(81166007)(82740400003)(47076005)(426003)(2616005)(8936002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:10:23.5082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f3e937-cb27-4031-958d-08da53120e06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The #NPT error code is a 64-bit value but the trace prints only the
lower 32-bits. Some of the fault error code (e.g PFERR_GUEST_FINAL_MASK)
are available in the upper 32-bits.

Cc: <stable@kernel.org>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e3a24b8f04be..9b9bc5468103 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -383,12 +383,12 @@ TRACE_EVENT(kvm_inj_exception,
  * Tracepoint for page fault.
  */
 TRACE_EVENT(kvm_page_fault,
-	TP_PROTO(unsigned long fault_address, unsigned int error_code),
+	TP_PROTO(unsigned long fault_address, u64 error_code),
 	TP_ARGS(fault_address, error_code),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	fault_address	)
-		__field(	unsigned int,	error_code	)
+		__field(	u64,		error_code	)
 	),
 
 	TP_fast_assign(
@@ -396,7 +396,7 @@ TRACE_EVENT(kvm_page_fault,
 		__entry->error_code	= error_code;
 	),
 
-	TP_printk("address %lx error_code %x",
+	TP_printk("address %lx error_code %llx",
 		  __entry->fault_address, __entry->error_code)
 );
 
-- 
2.25.1

