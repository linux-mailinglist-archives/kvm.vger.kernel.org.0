Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6862636F9E3
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhD3MRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:54 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232141AbhD3MRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUnpm5sck6/jOg743OyBlIMm1gcH3A9gdj8NXe+ui/IRHWGfB7MxV56O7eTdpt6zks4kX3Lf943nP6XtP0wNzjwryQPUKdhMekLscid5RPa75O048HkwUWc/wUPd6pcN5nOZxbPve+EuMo6HUBSXqYsKlz+cycC2HMXHvuNayprZAhCMP66UA1pFUMuaG2EbAzxk5lfoOdAxSn0txE4uQ1bXoMlONnCUw+gh5IFnkPcsXFUtjXlC3+pWoDuQRW10yEwfftBomWHjjE1HjjIidXNoy77rPXdWmSx4tM0rH+i+EtA5NXNx8Vut1gU3ZUjMCykzUtOalusVjQ+6FMg5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hb80lXVxe3WcFs9UKnvmP2LSK+BHwPu4y1P48oZIlV4=;
 b=E7DdiJ3Hp7EyhN4BPgpmjIjRIW0qOfNPxht5u/L7g7trv7me8K+4DN8L4Y6PoQVTrUPUX2ReyYLHIpVnehhTHXNMLyzc/yDmEwzBeHG/MZlGwSAUDX/pe2r7DPvJhcKIxr4pH/1nYLV2eQdFYVZDi7KgKKKYmvDvUbdE0O5OKcOKYgdQ4QOsUK1AQtiQu65ICVAVx1BXqterE/LbjGOti3W0O3s6HrXu0noLZZRCWfpW4Ud3p3vVMN/5DCyttcAczh++x+Ci6h0CejNxEuXO5BMDoUCHLM4xXaRIRRIYVEjp0R/3bwfsovqQWbUURTdA0Qynkw7WCi7131RSovb1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hb80lXVxe3WcFs9UKnvmP2LSK+BHwPu4y1P48oZIlV4=;
 b=lth1a0srSDLWS1NU/lPkcLKEry0gzZuhRZGbSbDiaDdWw2gE169/XakMd0MTJQmhZAJf28vWOElFLrjFrYMMNh5YWBv2TrIQAPcpuGR8FUwFStx4nxCS7Kc0O5Rsfk8w73EcVO9Fzgrqra9lu0reABWnt06NHUxFu4qUFfu9Y4I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:54 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 06/20] x86/sev: Define SNP guest request NAE events
Date:   Fri, 30 Apr 2021 07:16:02 -0500
Message-Id: <20210430121616.2295-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 801b1e68-2f09-4389-dcaf-08d90bd1d613
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44310B8E4FD1879D1B1783A7E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1USE1rHdPbe68llBEyiW7VNl/9jI4OJeZT/1mcMsAK14HU83ttIkijht0hOU6DV+lD5fZuMKtPAblrcC/lEIfbrWd/45Wt/5jj4QE6IvKf2Bs6AVgAy+puZQl0wu7CMmG+UgKqaPWOSRgID2p/qKvHjidHVpOFCTrRlBeGvf0Qd8vHJdkuR4H6Cfj0TRKBP1xywSayRoNVtSVtVmDZ0yVnsGzPH2fkKQUZ/I1Re5eoCbln9ROQm2irI5yzROozQ6fFpskW40Wb385lNdxzHwnWDYgSZUFibrUuDuPD9spUao1VdeLVLJe3zeJ5MBamIycaUev3blBpjmZvN6XCVKAcV9yVpFx3nbd16Ebn39evB21GcxkJ+BKCLAgpJMocgSKhdgQ5ykLlLyyrfsqAWvU0J5u4ROUUq5WiTD/qQ+s+bjC5KrmWNYEHwvsnC0iVM5C0OsCj4K8A8Yjovuyqcq2jmkV/OhADmN+7nQYILX5CXkOE3pYA2ttOUKpKD7P/eb53L1Zq97+FFw1JNY5xAUj3vhhRReb2ogruAe9nGB41tGtFf3N76AwULc4Z7MT71Q4sz+jbB5Ezwt1akij1YgcW0GqEA9jrx960YdsX4yMDX3GmTf39KNDMTPV8PbG7TpIz8SPcQ8W9rALpqoKJfwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZSJtKHi4Ck22XBMDfEwXDaxW1iT0pUPa2U7ry7eanKneeojQQn8HxCbER9yA?=
 =?us-ascii?Q?yXpJckxvYc/sT/mwxdv+POejz4tDiBfIIDCNq2jp9EVHpU8TyieFCat3TLB6?=
 =?us-ascii?Q?vF1TP9wzOp/9FIhTel0ZR1dir6bJs+3RU7p9VPO66RW3jCo5YhMaA1rqH88D?=
 =?us-ascii?Q?lRKefVpQoIrchdwH8YKaaj+3JeOToS2h67zxj7a8SkmRMyKrn8b44rsDzQtv?=
 =?us-ascii?Q?X1Al/AmDfqu0w+eiMCqY1IiMxtatAvHhOR/qzZHhIGPILUIkPLz8+osq1p1o?=
 =?us-ascii?Q?OghiAU1RiCGQ1zpjm7g4IlXD6KTnRyf69UwGljpQqDgzfbRhA9uajNMcSiu6?=
 =?us-ascii?Q?WzUX88MHWjVea5XLd+6Wp6f9GA7NNpMxTphRJWg4K+wCTU1rkfAUrsyOZJOq?=
 =?us-ascii?Q?z4PBXcr5sDZU6EP78yVr6RG38VPrTBZDq74y8hjSsirhP0LOHwQNX8gehEla?=
 =?us-ascii?Q?ENIw05xTqpoh1e2laT0B3nV4JtnLKJeShVAO0LEtXMLWtQ6oclnZY/NiRkhB?=
 =?us-ascii?Q?AyNAtVgBQz1G+ggHSGcGMqxnlUsY183DFmAF9mjTb7IEDCV6507U1exiUYw0?=
 =?us-ascii?Q?cTbkcgZ+ik+cz1KhvMEQF+mbLU7c3gdsBQRzEpoaC1QhI3IFptERnptXmDxB?=
 =?us-ascii?Q?Lz8UJYzgVhrfx18Hpvur29ZtnJNuMpfj4I3bYiTA0NGFyF9x/R7jdnZcZB3n?=
 =?us-ascii?Q?DC8/kvaKh/x3yxVtFkiDLtaRbt3aw90a4x9dzwxuEX01ndaR5pYzxHMlAAq1?=
 =?us-ascii?Q?zHYtUGQMqRZkVt4Y6MXLMufjnme73Kavc7K+YL1yFTwZYtwhWy5W5dhwWe9h?=
 =?us-ascii?Q?eJ1tKjhDjB/FHMw4vNsaurkPNxpfE/I7MVrxjDzf5FKdd2MhnC9gHT7jM2C2?=
 =?us-ascii?Q?9hCiXdm5mwVKUnBRq/0gx114yV9T+uheY5CnfLUXU1nG8A+0RDVC0bWU+HtK?=
 =?us-ascii?Q?cxBz9GdcdEAUTAgtpVsxV+KbqDbX1xtPZE7nGR4meWFk/Po3A6/BGhwcaRV6?=
 =?us-ascii?Q?Zq7LIYXwlCyA1fPc6W8UR4u/8uqtLtLIyTuudmK0/Ye7EY0YntKS5qUqkoMP?=
 =?us-ascii?Q?HewiAzImSroPokNi1UqAiXHZ2d8zvOUUWMGr8cJrr7QxNbOE8Swz5Yns2F8M?=
 =?us-ascii?Q?N6qxTu/v8KblZJQeE4JyoNTcFS/zLRBvCGJImvGakT4BMaScvYuGuAJ6KnHf?=
 =?us-ascii?Q?7X3De/bEXqR5yiigKTlK2VWpAYq+fqGkqevVklYR9BO5js57J9AXwJARo6jV?=
 =?us-ascii?Q?5uLgp1Cp2pqJ779f8/sCVhqX2jTJIcoDf/gahgjeGfjZR7L6sPiMYishGlM3?=
 =?us-ascii?Q?iOJWA0rrVSuwUwHotWH8zXb1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 801b1e68-2f09-4389-dcaf-08d90bd1d613
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:51.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aubCTkmPiTBV/9llcnyzSsKkfZGVUU9Iz9Mzf60xSBwlaF3eMPideXvt9JNPSZVQ4AujIANNL+TeLZOOsUAIxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification added the support for SNP guest
request NAE events. The SEV-SNP guests will use this event to request
the attestation report. See the GHCB specification for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/uapi/asm/svm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f7bf12cad58c..7a45aa284530 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -109,6 +109,8 @@
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
 #define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010
+#define SVM_VMGEXIT_SNP_GUEST_REQUEST		0x80000011
+#define SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST	0x80000012
 #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
@@ -218,6 +220,8 @@
 	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
 	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
 	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \
+	{ SVM_VMGEXIT_SNP_GUEST_REQUEST,	"vmgexit_snp_guest_request" }, \
+	{ SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST,	"vmgexit_snp_extended_guest_request" }, \
 	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
-- 
2.17.1

