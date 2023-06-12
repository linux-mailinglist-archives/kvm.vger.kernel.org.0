Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CD772B6CF
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjFLEqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbjFLEpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:45:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17067A9;
        Sun, 11 Jun 2023 21:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niBCB9g78SHtte+VkwNKWSL37ouWuBmblcvgIbkfv9/G3trub3uqMGsp3vsClds4puZocPUxnT2Vkr04kcvnL+qVsTIT4sKk4JO0V/LymMnajmbvGNdAQwsGPktSnCQebKRaxRy0vmojaQc/dP5xVQPUHt56ZB1Wf08zfvpb+cjPuKuy6BdgZWtUcfUxtUrifhoBBVeEfkLwIkZTAQF5vY1nxTdpLxI1AkGgLq+Ss1qR1JMOn8kjZ5zre+63tGW7dYorXXHupk44CcUVVa6SpiMOWGVrrg9eSvHrmkxSPrLwzGkb1Pr5z6WPES9vpcfRjXmmpsS3osB7yzXtmXWOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPne3TgHOrPCdZDAp0qle3bNYwKkBJf0eNd3G8dRABg=;
 b=UmodQYZB5mERboIo6UtKCjIV0ECrNI2JLFH6HL3NcdvjxOywBBv53wLk7xpdEE9q35AlFJlpnHWLcOTIJqUWpzp8ExnTjXCVoyiS+VG5t63nMLs2su90KbLB/8anIWoOsipFVn5lcetulPR9HHi0Jz4O4E+hQ0n1GrBfFw34hoIaXdJ3BqfMn7wFeO3oNs+KCVzAelZr/PVWk9GC1dLTMebjRhrCQwcP4cGmKI0dI+X3vtYPx/BLHM/zQleXgtHFTENjw2aDkWAdbBVvA3nG0kZhWpYOWh6fNCiJ1lUfw7wg0SnJBCX+QxzE2wIfrA+PDiQLBxA3VO/V68cWK5NLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPne3TgHOrPCdZDAp0qle3bNYwKkBJf0eNd3G8dRABg=;
 b=3MbAzWy++c82qom2Jh3QOB3Re0H8ipMe2eDzugUQST5pamcC85Vc14iiD9XL1MwQSJVdTKV2cNK/bLWpDvwUbGztsYPMRQlLwki4+iR6D8IgXyxTJV9lbsGlNcCKQ9spXch3uhJtjOwohumUe70PiS3EO7TioNS+7Daf+ls/RAQ=
Received: from BYAPR05CA0068.namprd05.prod.outlook.com (2603:10b6:a03:74::45)
 by LV2PR12MB5725.namprd12.prod.outlook.com (2603:10b6:408:14c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:45:46 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:74:cafe::d7) by BYAPR05CA0068.outlook.office365.com
 (2603:10b6:a03:74::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:45:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:45:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:45:16 -0500
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
Subject: [PATCH RFC v9 38/51] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Sun, 11 Jun 2023 23:25:46 -0500
Message-ID: <20230612042559.375660-39-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT040:EE_|LV2PR12MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: f1efeb91-f5a8-485b-f3df-08db6affe24f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpywAS+W9P7Vgt28bgPCLwxkXiYKi9rqssu9d6pI/XwesOEAayHV+SNu6XdSKYI8m6p6Qexq44Jqydiw+xwNpKPaZz4duLBp5RllvCIXIj5fVcvx/8/vKcywST3xUF6IiREux46MIQP1nA+PfWJ7ALLiVnXHZ8XruN5/4VKvTt29R+Eva23aaJLUctt5Ck0zGmiErguiE90unoWG8fT36rRewDMSOHQ4SUNe1sUpQyFMSVo+mhyOkmWnd7vNi6x3EhkwxabFL1g9vzqwSDD8Omovm1vo3glcrPn1/zklG7lAPLK3FY0Ommrcf7z1tfcIkSYyK+x/F/l1Wcxo6j0HRyhtHxgNpmmRC1x/pCfiqnXwEjZvOg5QeHcAb8lFn6Mu5XE7vH0JmrpxG39EWO24QNGFPHwDgnoqEwaIYJx2HqGjxls5UP6Y3/ugSA7zrJhkpSQd6KYHkViRpbqPplR53tb1favlBJlyMFQK3mCi9eD8ZmAW+nFSbJc+QmipsOVqSdCaUbVDkDptpiWAfpanlImPPj1hP/0FIOAnKw0p++xuRVBx9Lu0p3Vzqd1AAs7Jwi3almnA+37YorZXDdiTyAZjdX15QBk+VfHm5RTzaPvyHf3nGdEIUN281JuwmiOKE13Dde+zlTbuF4zsNrfutGf7KFMYH7w5rdMYLNmLc3T4smQxarExc4oFeLRH3+cDfHxMb8TQitaxPvY2TqbZgiPr2mPQ0VPJNGhMmxm9NxKq0GiqoExFH+W+FI9opvLXEKA91Sh7dC54WcuX+DkrzA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(6666004)(36860700001)(36756003)(47076005)(426003)(336012)(83380400001)(2616005)(82310400005)(86362001)(82740400003)(81166007)(1076003)(26005)(356005)(40480700001)(186003)(16526019)(2906002)(5660300002)(54906003)(44832011)(8676002)(7416002)(8936002)(316002)(7406005)(41300700001)(6916009)(4326008)(70206006)(70586007)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:45:44.8371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1efeb91-f5a8-485b-f3df-08db6affe24f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5725
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

While resolving the RMP page fault, there may be cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, zap the gfn range after
splitting the pages in the RMP entry. The zap should force the TDP to
gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8d2bb3ff66a2..026bfc4446ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1851,6 +1851,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..963c734642f6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -235,8 +235,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d3983b9aa7e..dff0eb018b27 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6732,6 +6732,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1

