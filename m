Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC895527DE
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347005AbiFTXLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346492AbiFTXLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:11:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED75025E8B;
        Mon, 20 Jun 2022 16:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2fv0Xlc8E8r+7pK5qs4/9aGgiYIHArO4/OsbX55Nd+cg8dRa8WPT9AU+pgxC644UGfpZdLzANJmP2z8p47P8ztHxpqeJIyxf3uy5zaFGuHnOvTR073S6aGa1zbLszACd9YuLNrx1yL3GK0/UzQqcDdkif+WWIr+yTm/2137+QCrCWzktMT8gHeZYq4LNGCA7mfV0ycxGuvsmgRNKyNjAWLEqKW3zwnQe9SyEeUuaA5Ics9Im3vdneXl+smapZl0/NSM8JlHGXmNpQLJ1UYD4EVTFScmU8xyEO2WST/qDHeKTCM8lqrnQwtL23fq8kDnn0nFBKChtUUovtPsTb5hIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSKKHMpTuDiL/WXrVm0mP/gYeJ7kX9ggtq/chHAYeuY=;
 b=NpoB2VxXGl/OHKjDlW2H8vzrRB/cHKHWc0cl6oTZGm9bgyk0h3fF7aMi/9oLJarVPHLrpZDt16zTLbNnrQj+kLiZivFaUQG88gPzCWjSbR72yuqIACGLicm63goy5JZLaaofYKvoypvO6DHCWFa6zsM8u7rK8bwaxtQH4YJMaLxxEL34VJon6571oPaUiyvljl4Z4KTxV9BLc2pIctdSx69/R2zTnxk19XzbpI4P2dqj9696Thc5nizLV1LSrgpDjnTHMGeaNzQcadg9yY31E5TZdbVXlS7bzZPbIqDunGxaiy4o+lT59QiuXhyOBNGYpJooefMjCqR9aVMcCQjdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSKKHMpTuDiL/WXrVm0mP/gYeJ7kX9ggtq/chHAYeuY=;
 b=1ATraF84PSlCBB0b+JPSGYDkvIt/z5S930Vb7arncLkluX+BSiv0wat8wQhe7p0DgnOfLHWZgkZeDvhbFdEJO74bhTbgeiTVb2WvYUW+9+MH8D3YzPC9v/wKOCqw/DR9P8LRjMtownoyz3PAbO9VYjbVlHlZh8ykP8YFDJ1i3a0=
Received: from CP0PR80CA0024.lamprd80.prod.outlook.com (2603:10d6:103:14::36)
 by DS7PR12MB6119.namprd12.prod.outlook.com (2603:10b6:8:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Mon, 20 Jun 2022 23:10:10 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10d6:103:14:cafe::f7) by CP0PR80CA0024.outlook.office365.com
 (2603:10d6:103:14::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:10:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:10:08 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:10:05 -0500
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
Subject: [PATCH Part2 v6 32/49] KVM: x86: Define RMP page fault error bits for #NPF
Date:   Mon, 20 Jun 2022 23:09:57 +0000
Message-ID: <0b639f605c1489dc7ccb212d867628988aea4ef6.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1fecebd8-5925-43b5-049a-08da531204f6
X-MS-TrafficTypeDiagnostic: DS7PR12MB6119:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6119F7CD481D0C2D175ED1398EB09@DS7PR12MB6119.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RuRRCPYBnAlKdAgLecYFrQyRkOrKGQIl9ct5NAqr2+IWV51Ad+ckJo7UCEWYK5vX9FbSf8uHqow2wglRj2f/qISPRlw1Rdaas3RzunTIQ7msDYEjDi6WkcO6d50AF8RuygdvRHIPkxZX00TSkpfy0RYh/RD7sEFsX+oB5jlZ2N5Nt0yz77Td8XI7qGJ3oYwmZWrt4CuLn1l8NCOZGrV5kRJEX1nRBihzDaY7Pzv+NPiqwsZBq8Vi5tkvnW0ERGO1Yg2oU/VjfLjqgREzSF9Gio4qrKr01mVXqaPYuGjRJdcY1Wcp+B2euSQMsl5DPw4cdB3/DBTa9z21PWddAsJI72I8XdzMcl6JSq6x3K+FLM+CgtKHqcP0w0Jbh8lBMia7p1EhkRgEgmu4/POj5jczZPaL9f8OkGvVPi8EF/+ISrb5Ch4qLu//se7miP9q9jx8Od3ZfpSrHijy428BiVqCJn1DEZjXQ3QEq8kvTcds9aXJSqOdnGeEeIJagTjW9odm3Mil/I7w+2P/I2u81UflKWABrl11n1AAlpJdQtpZkKQrYpCkla20Tkq8tVVRiETor5Uw8SkxBs4561chS03wxVIHHT1pgVMAnDJSf46eQLyYS7cesLqg+wJD/WQhSRuN3Z3r2B901210xgRMY3f7yiaS3UH6NB7agO/F3hZ/v1SS+Prvb1dDQgX2ld3HvmBeLtt743VvynbawBh7WVNrrgeid2ch1zmgJ2TIfNZSFPF9iOKODqPc3Vsvv1UUx6PJAbM9RmXdv/+cKqwagAEu9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(46966006)(36840700001)(40470700004)(81166007)(82310400005)(356005)(36860700001)(26005)(5660300002)(82740400003)(426003)(110136005)(316002)(47076005)(336012)(7696005)(41300700001)(478600001)(7406005)(7416002)(83380400001)(4326008)(2616005)(40460700003)(16526019)(8676002)(70586007)(86362001)(40480700001)(2906002)(36756003)(54906003)(6666004)(70206006)(186003)(8936002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:10:08.3157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fecebd8-5925-43b5-049a-08da531204f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6119
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

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hypervisor or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2748c69609e3..49b217dc8d7e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -247,9 +247,13 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
@@ -261,6 +265,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS (1ULL << PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1

