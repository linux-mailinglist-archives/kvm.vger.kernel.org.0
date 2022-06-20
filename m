Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664385527FD
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345801AbiFTXOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347543AbiFTXNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:13:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF172528E;
        Mon, 20 Jun 2022 16:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCJyXSjOgDLzBW9ce98YoECXCJhbO79D5z2vYlMG0bpFJxMrEoomkejazxfK+d8c8cvSOhb++nnnSVh05u6Rhzt9SojuPMPrchzqJL5Mh3V2VdfEqZdT6FfIRpCQN579MsdBY6+CJkq6YnOJwKZt4J5XJUvJ/rwyr1XJgLGoCJVJeQat3+bzN2WFJaIDf30HF3F4AAW95DO72xpRraL/bhqpf1kyggJME/OA2KRTvs+P2r4do9LD9TZhscGpkEgiHeNTcs+CZ4JrRc7rnHMjI34SaBYg0L4nFaMpuSn5T5HGaNTJcipq91q0slLx97FkLB0F3JoGpqQWSB9q1+97uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZZr/6cf+w0uRjXztYtLjC7+ITTG3OyzXpqWG//NKOk=;
 b=MAfygFFuKCrJXfj9Msp5oB0K8enYuHe6QVTS1fJ0xmFVZ1rY/zFQarADig7qnMX5BLU3nNjJpmTgrouUBFscPf8kjAglW3e5vOUUpUEZorxmj50qQHYhhckv6R5fXoseKtBVe02qIA6cDrXPZhdm2znKe8pmq7o/LXi/+IHw2dooeCjQ4PZdd9hPko4w+CLhOn49isEcsgXb9GD6rh8w1HkWqPVYG1vDxTHPMvTSusnxmrWblagHKySNCqWxRASTpf5JEHd1HmyIdNnv0ANhWJFrIxO/YwxMuXM3wRMZo9klnvGDu3wreQZ5yZm4srU3++elQmgeH50dkkpbVHaHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZZr/6cf+w0uRjXztYtLjC7+ITTG3OyzXpqWG//NKOk=;
 b=mimeQESglRo1yxQgbswV6UY3RHVdVxY/7DpjunlV5Kdzl8Sl0VKcmi03Uf/Xca2pjgAxJpBGbPZXcVXC+9BLPQdy4EIpey3YDdSLVKu6t9H08aas4G0XJDQHHocKsUV/McICf/YSe+uW6TrO2EZg3qMygW9GQrYzONFvhLUT8CA=
Received: from MWHPR17CA0051.namprd17.prod.outlook.com (2603:10b6:300:93::13)
 by BN6PR12MB1634.namprd12.prod.outlook.com (2603:10b6:405:4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:11:24 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::41) by MWHPR17CA0051.outlook.office365.com
 (2603:10b6:300:93::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 23:11:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:11:24 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:11:22 -0500
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
Subject: [PATCH Part2 v6 36/49] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Mon, 20 Jun 2022 23:11:13 +0000
Message-ID: <c2c4d365b4616c83ab2fb91b7c89d13535de8c0a.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f99512c3-85bc-4c86-49c9-08da53123253
X-MS-TrafficTypeDiagnostic: BN6PR12MB1634:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB16344DA04C39BB48036CA56B8EB09@BN6PR12MB1634.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFm+rV4i3gcT0q7ek/RE4mtu6XFzJ6n0iZYk5WVccL7Wpj0F1kaHhGsj8KglbbohZHHJbAX7q6QEZ8qYg5/uqLhT4fq50jKff7uwziZrocxdY0qBc/fTjRQ5nnT8DgTLi0Ml1wKukBAAc75SGo5M8bhTYS2IRd5Z7HV1OzHY0njnjw8lkZKaF9j2t92M21bO9DbYlr3KcdDlP8qzuSqlEHAlDQ8Rv9MKHWJ8E72e7OBxSZIiA0cRbK85+QU7GXGLp0B6SjeN6C35szOpEkhO2pxo6Upv70dswG4gMelaGyENnVvBvnoiKldjSIxtDf+NKIXCpKviNLdr/uLGnHqOHM4ocYEhXbjuUagLSCaxz0FxfH4M6z9j2TIoCcmIKFnXbumIZskqkMaMd/1LulzNaYELM0xxuoquxLtp5YN+6XMF+53rrwWOTzmoIlqhnT/oZsTfTaVbip73cQi0FcjIQIA5TBGq+PHAs7pr0C3M0MUif74nMvFvso6R76mjOZafFCKlvNWGCoPHVl1BOciOf7CU112IUixtDq1VGSJKFk4OGfWBihdfYPhp9nTBZ5GQ1BiH3LAGCdi2jqQ7gScNuJ8ZrnnYyZjR7sI4sJnYcU7kZ72w0WdKrlKE35pPjqQsXxJell8DGkv6wx5JIFtoSEZBx7Y4D54GuL7lG4HP+hD/mIaSh/HKFUgIBBo1vPvlO06PI+XZulldwzWlx+v+dLySkCqMMU/Uv2EbOUwV0D3wq0BzJqqDxSKxDRexBVZdvp0rfcP5n7ZD1xo4swPEyA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(40470700004)(36840700001)(46966006)(82740400003)(356005)(8676002)(4326008)(70206006)(70586007)(36860700001)(82310400005)(40460700003)(36756003)(40480700001)(47076005)(426003)(336012)(186003)(83380400001)(41300700001)(2906002)(478600001)(316002)(7416002)(5660300002)(16526019)(7696005)(8936002)(86362001)(26005)(7406005)(6666004)(2616005)(54906003)(81166007)(110136005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:11:24.4245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f99512c3-85bc-4c86-49c9-08da53123253
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1634
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

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
mismatch is detected then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 539de6b93420..0a9055cdfae2 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c70f3f7e06a8..6de48130e414 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3331,6 +3331,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PREF_GPA_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3381,6 +3402,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm, &exit_code);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c80352c9c0d6..54ff56cb6125 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -206,6 +206,8 @@ struct vcpu_sev_es_state {
 	 */
 	u64 ghcb_sw_exit_info_1;
 	u64 ghcb_sw_exit_info_2;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -334,6 +336,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 	return sev_es_guest(kvm) && sev->snp_active;
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1

