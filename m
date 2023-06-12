Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5872B6ED
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbjFLEtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbjFLEsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:48:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BC4E5E;
        Sun, 11 Jun 2023 21:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkmBUcULQoz6g5oqyaqFulU/sfr/HbKIBqsafxdviY0z8H7gFDcDzyeXv1gYPKnaxAjPx+BrzHBUc4TVQhSUrK8G78YgaVhDvkKOAjW/ZUQrEK5jdrmUwibxnrzMfbFWwzeURRDMr+hm3AmXu5g+5DY/EJ7Iz8IDv0tp3ZVG3WC/S13VlXi2/7zUpr+0uUHEpFmgfbY1qAviACWAq4yxMBmVvd3O+aPOD5/bfGE0t1/AtKGCQ+SnLzBzYiczWxQnq8KmXVDrwF0/vYIVnA1JUgcxw0ymHmi0DMEK/I1fgZUfYdjV7iNPIxm5EFnuTgRJWJSJWH/X4VFhj26tBrGhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rx8POHMeEO6GjBi6mYzRZT5bILI2FMQUM3oFJFtiCLY=;
 b=lnl5Momd+9jObD0Md5oeQVp7JZWml0r1TO5mm71ArD9MF0rwyW1c/GQ0b4AueL7KJyd9YGaP6eM4rWTqw4XmE0gdIDWyFWpEGu0fhToSltViNTK3DpU6aMabimmoEu3RMP3KURsnxK0z0ZtzcDu5pNdRO+UfSHxQw+Zip3ZWMFIQ5wk1ABjDO4lSfnriU/cqbdNQKycIUv+/2GlM49m7fEtLMme2honU3wJULg/kyATXVzYYMlNzGH7H/Zo0/oPzs1R2EbAZAKrOH0EKvIZguaCxXEBPLtL7DYWu284YQA5cPBvqbniSpChU9l8R9lrqKlrKH3+fGgFAPvCy/KvNmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx8POHMeEO6GjBi6mYzRZT5bILI2FMQUM3oFJFtiCLY=;
 b=eU2LCqFbd/NtkXBNhn4oNsZ9LCJbN6tASAK603dcXmOhiS0sSGHGumB+5hFj3vhXkPFLpIM7zE52J/7xXV15h/mn2j0XaNFSGf0vtRkID4AvRhYBZ1rbSyQzGFmNIwoBKiWmqd+U237q/XlHEHhP5Kxha6rAekgCx6qMyYbGSrE=
Received: from DM6PR02CA0058.namprd02.prod.outlook.com (2603:10b6:5:177::35)
 by CH3PR12MB8259.namprd12.prod.outlook.com (2603:10b6:610:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:46:53 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::34) by DM6PR02CA0058.outlook.office365.com
 (2603:10b6:5:177::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:46:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:46:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:45:51 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 39/51] KVM: x86: Define RMP page fault error bits for #NPF
Date:   Sun, 11 Jun 2023 23:25:47 -0500
Message-ID: <20230612042559.375660-40-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|CH3PR12MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: e177e363-8050-4100-9f42-08db6b000b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWhc41FjYkcwFVb61dw840GlOpjTFgiF60jbUN7hLBmhNskATgqiFMFDybAuLAARZpdBy8OlBTlI6K1RetT+k1+g0Sb7ROIQrDPeVMMnPPaiAFCdndLBGZl8dfH0uAKV35PB7wSBVylNVYoJRgeB4+v6hKmk6q5KlOY7u9GS39cCX1cKgo6690vOgYrkOr95wuZHQw/sIKiCFfIgMZCLyhCYoyc26rqHIrmSLpTy9LvhH7J/vplItX5KSF1ECvQD6pnWB2pHfLPxa/Q9XXZIH0Xz8MBOOL1QI4YAExO0w48QziWZ68xARaNrkeVNLTSFCkME5CrRWQQ1ix3tnaQB5+UzdlhRocKSLHvoWBkqg3nP1ik7LVczWlJHcFmsCai2abVb/4myEHroPTfNW2rVM7hDw30wTn1vY459chdgP6LZ/xNbFeoPYUciEBtkk/XBkLGqjL843atIoJBZcoJA4HAiGi/DH3oE18/lhGG11NdOAmVm9lY/BgGSrLeJljNDjOGJ5/0uYnJHe9u1BhxPo+gB7MriGNUgoPZfo5LCRaY56wbUEeHZ8fYfF9M6sG9jFTte1LeULIcN6t5cYoO2a2LBdGnHDPtT9kskVlgDlKlOTbF+ne2dprVw0EywgPmO/jeZJJlJELauI+J4//4EX5bXXHSJppt05n2IEYTK/I2R8kS/nqjMf0teG8kTtkRsemwMeKPBjdwFCUS3tDB2OHvAb+7Vi6REnyzoScLxg7zdF5pYkYjAk52rpExrhciGIn9uTGvGpUOd2CGeVJx45A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(44832011)(8936002)(8676002)(70586007)(70206006)(2906002)(4326008)(6916009)(7406005)(7416002)(5660300002)(316002)(54906003)(478600001)(6666004)(1076003)(26005)(16526019)(186003)(41300700001)(36860700001)(356005)(82740400003)(426003)(336012)(47076005)(83380400001)(2616005)(40460700003)(40480700001)(36756003)(82310400005)(86362001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:46:53.1103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e177e363-8050-4100-9f42-08db6b000b01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 026bfc4446ee..2fcd309fd9fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -253,9 +253,13 @@ enum x86_intercept_stage;
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
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
@@ -267,6 +271,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1

