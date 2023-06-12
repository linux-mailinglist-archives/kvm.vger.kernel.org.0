Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A372B699
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbjFLEh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbjFLEg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:36:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E7F1FC6;
        Sun, 11 Jun 2023 21:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aahd68F4z6eqQpVYMaVh/MPQMKXnZj26w881Lwf7SaB75uRx10IY8xu3WA5/FEGSw9ZujGD4lexTM3YT6Ojjo/XSpcLXPTNPMFJporWCTM9jHtNg7/IjCs27kcja0/hHokN0XwjoOvRXeNYldl9L0s/zRpv8857Zw52rDaBevtXqiuh3spAbxHMhIctdjwKbAWQaOMl7Sc7Bmm0keKsM9hX8/k84QgiweANvAJlp3SY9vfIVbeuCrPFm3Qlrz8Pdk5P8kfc7dcjlrPzQPvi1uXu7xG/zDVR3Ov6andOEnMGIU2Ol/vA0Hyub9m/yvktqYVNI/5vVpxlxTlJ0HDoyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zzsL1kp415Jf3ZR08yu8zyJesz2ZChIlRl31hCycZw=;
 b=a/lPMdcbBRzc4VqfQFS20DGcFuOLpP0uSeDSb1fMhhgprQqbTc28iCpq4CBbas98UmbachZCh67xu9V8IKbrUqO1/vhfl/fslswGCr2XDOri5+TP+BK0gDPB/g6bQBXa7ijEa2Lp2hsKYcsVjuCTixTpxoIY4KawGs72E2FBsilKTxmFxS0eUwLSoXjyGe9hMgb3qWunMpjys7dpx6cZ9NYLdeeaoocaDQUsnwHf2EjzUbivsDVxNhLuIyZU4LQ9umnU0wAEFsSL6VpbaVpHcvo/9r8aMY0gIl5k27FYakIBGc/hH5+/oR1G6HgkpXn9Y06X3bTHWEijmO1IhXiGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zzsL1kp415Jf3ZR08yu8zyJesz2ZChIlRl31hCycZw=;
 b=CCLbG9z3lgeW6i036KK2b+Gr/4qgTdYKCS/3bTcpPclaYrO+KVyAzusr2saz/EMG+PX0z5wfCUzKMU27fG72t9NtvLcyC1ozo7gVJ53Dbi8wGYbN1AK+/qL7ZUfKscgQP7MRWjdYpluIENvxp9p0qETLleywb4QY4EakS72cH1Q=
Received: from DM6PR06CA0031.namprd06.prod.outlook.com (2603:10b6:5:120::44)
 by SJ2PR12MB8012.namprd12.prod.outlook.com (2603:10b6:a03:4c7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 12 Jun
 2023 04:36:21 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::3f) by DM6PR06CA0031.outlook.office365.com
 (2603:10b6:5:120::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:36:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.33 via Frontend Transport; Mon, 12 Jun 2023 04:36:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:36:19 -0500
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
Subject: [PATCH RFC v9 25/51] KVM: SVM: Add GHCB handling for Hypervisor Feature Support requests
Date:   Sun, 11 Jun 2023 23:25:33 -0500
Message-ID: <20230612042559.375660-26-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|SJ2PR12MB8012:EE_
X-MS-Office365-Filtering-Correlation-Id: 39aef988-d67f-4a0e-fab2-08db6afe9227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBTBvJS9Nb8tlWWoAQnxaDXixIBqez+9IO+HO5ryNUfCBF2WURY5vMhy9JgbF/23bcMk0AfTwEW88A5S5sbysRN4IovXi4gO2GdM15lvoIwI1mbNeA24a728lUOyXzsV+hHotS2g4nJiY1UO/f/0JLabwzp1VmBipz59JA/aoWqJadTdEwoLuriBsrEtq1ZvDNMs+nRAduPQOKS1URtwaqAJiE3ejswPf/D+jPEpsxiDSwNL6uqaPuZNQcJgN9rBgc4nuEwmu1fuAOuyjWTmHL4vSzHlWRkhom56pfQV6QNtahHAqrxb6clq0lXwipp1JPVhPccMw6WrNH1Rx5CQCNjEzxRG80m6cugGj3ayzFTe3nPAXZil3+LmPuYJoxF1aQSWWQ+MdsSp8BskFfOSpLhYp5dOqdO9xqgkFbS2eXt1xzToWFta3hV9A3E+oVhsOyAhThk2iJhBrBVtjILQZ2uX0vvlVU/bq734/b7QKSkxh6kJ0bQ01Up2iDEfI6r0KtrICrgKKWLlhFc+rUzoy91X+pw+gfMc18nqL5gTnDQus3toKW+DXjcFPTS3CVAmCcu4duTUINzchqkxDLuNhh5zHlQomp8d4/RjswOnDbn3jVc4RFmVOOs7Vdi2qjjCSCsMirKNCjW42ABpNrgScgB4oaBEjYFCoroDgPB2Byvh5uLL1mVrpfq0ZEQkmJfxLmBV9DQDrzNjiDo3hhdGB58GW+kZF1F2JreCIQtuc3ITPvIXLzLR9uCrWaKHZbBHVhwoF5Gg/XK/E1vABfvmBg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(46966006)(36840700001)(316002)(40480700001)(54906003)(36860700001)(40460700003)(82740400003)(356005)(478600001)(81166007)(70586007)(41300700001)(8676002)(8936002)(70206006)(2616005)(4326008)(16526019)(426003)(186003)(336012)(47076005)(6666004)(26005)(83380400001)(1076003)(82310400005)(7406005)(86362001)(7416002)(5660300002)(44832011)(2906002)(6916009)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:36:20.8606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39aef988-d67f-4a0e-fab2-08db6afe9227
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8012
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

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index a4fb53fd15d7..aaea4afcda98 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b88295aa7124..2bceb0060880 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2538,6 +2538,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2804,6 +2805,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2928,6 +2936,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 50be41fa16a0..1ab117daebd9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -711,9 +711,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

