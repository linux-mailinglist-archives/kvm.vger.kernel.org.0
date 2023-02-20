Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A128069D377
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjBTS4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjBTS4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:56:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D800C13DDE;
        Mon, 20 Feb 2023 10:55:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMjdDOy7d+TGYiSCPoRPo35y/JJ2qyZxQe0obeJnNphm+bHKC+9noC1dy+TNw/u7ZNPLMcrTrcqPvgnR7wJztZwkTOcYuqtuZYYvh9KuIHLEhITFHFwjORWc+8ZTto1vuxphZfDgsJwq/rB7m5EDy3uf4oVvlAfTRk10DZAuXSszI9O13r3BnZNNXC8lynH4DYCAHFooUOERu9KQa3VFE3sML9b+KRyJirjU+23ZBQBGRdHDlpzNsRRpW3lrgn+bAbWG8bIgUZRdqgxq/7If84WawhE2Sut4ukbeCVqakpTJs5dv0ZDy1U/0/6IjI16dp5Nai6cqCVtzQXjyhLJU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfbbeYCbDjRFikAqVByP3v8vGvoyVHSwAy9gWugZHqw=;
 b=mmYnq/OVDJkalwxZeYfAN3IjTsVqEHDhs5T9DD010YZMVelQ2WXK18Z57gJJESHAHcn7cuwEvpGBAgDGWq4H3UI4mMuBH+ZgVdsc0tLfpjLuuyjOvNXuogS2V1u1vdMA9EB8On1I/Rkfl/BO13ijigVWs+wJV+aTzvMBE4EUBY4ILfqiNkx+K3q6/aP/YzU0IjSmAmvos410dcBcjnqQSkjskywtc/J/eqawqKoQHmpyjfliI0qnnqbsqV7cByjgKIGh1IT6K2tXvHZ2b7Fm0RUUVtPpQNuH9MViwQq980GyT2cApoeim31FFbEgtQfTed+trZ3cpL3hRT8n4C4Gqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfbbeYCbDjRFikAqVByP3v8vGvoyVHSwAy9gWugZHqw=;
 b=Qy73IVK5J+rW4qYNtPBVxqNDSFQxh6fHM/zyJYzPElvAMJhM63QkTCYQijBSY36UQZgVUdf75cRnQKrwQL275VSEY4U1VF1yBAdIwst+ttU/mh4zwh2CzuYh5+TZ6vkd7rRC890S1Epn0a7GFEhpnOGk4S6rwWhHs4JeBPiSoiY=
Received: from DM6PR07CA0041.namprd07.prod.outlook.com (2603:10b6:5:74::18) by
 DS7PR12MB8252.namprd12.prod.outlook.com (2603:10b6:8:ee::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:54:44 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::84) by DM6PR07CA0041.outlook.office365.com
 (2603:10b6:5:74::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:54:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:54:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:54:43 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 39/56] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Mon, 20 Feb 2023 12:38:30 -0600
Message-ID: <20230220183847.59159-40-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|DS7PR12MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: 7221e5be-bcf1-4593-4950-08db1373ee1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpE3iW1to2rfFR02Hs7J3oU3JFQMw/vvjU8mpcQIwsY2g2HIU+zZrpJvzR9uLiqsQW/oIQkaosDhtXurnhZ4hYNnTW3ytPeQ1OdQFhjUzuO02X5vPp9sjITZKYe541rwy73t7vUX/PTeuAccj5UZVZy2DMCcj2CMdVBqbaZa/OMFoJvc5MkUE1kQ4DuanP06t2DRQyUSgQeNYWrRRddgGITg55zTmIcS3MFNGbwUiTHwItYmtQZP3GXSGkuerp6b6x9lSVbzBPgiG4iAxZrfSz1p4rnzketUmHp19ft/teFVs5VpyDo7/wzelCtkltwjbco1HsW0wTZrBbMI6Pwd/qq0Z3eUQdhzc2uSmBlhFVrfv6yvu8i1IWtL7xL70M0IcbhfKGYArYObpVtOv5pNwDLpXeRqhOkBCQBm244YS7WGlemSEeSKmsDzBRvPEx7WZBFQZck3623OwYTobVf2X17cZaO5wnE8VXIz+Cd6saVNiOd+t+ea/u/wSJ1FNswHOTHL7EXVCVUK+f6J/qHv8CDeFDuILgR0vUJrG88JcdPhc46MjYqgqZ3no0gFe+2d6R4faZxEwnb4MFVauAImZfrt2t4bbsD9ytwlrGUt7Fg3rvKdokCmq+E10ZQoe2yKXIXi7/8YDm/iN3T4BZE9hPYCqDMxUOubVa7MJfUPW4giKkzRGC5sqL1EYzSQeh3QVIS4yzbnGrUHlVmx3Yo0Ov9dOUyHPQurnponB5D6xdg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(41300700001)(70586007)(70206006)(83380400001)(7406005)(5660300002)(7416002)(8676002)(54906003)(1076003)(2616005)(6916009)(6666004)(8936002)(316002)(4326008)(186003)(478600001)(426003)(26005)(47076005)(16526019)(356005)(82310400005)(36756003)(40480700001)(336012)(2906002)(82740400003)(86362001)(36860700001)(44832011)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:54:43.9273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7221e5be-bcf1-4593-4950-08db1373ee1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8252
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
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
index e8740c35be39..2613311f4fcc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3424,6 +3424,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3490,6 +3511,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cbd4594f1cca..0c655a4d32d5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -204,6 +204,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -336,6 +338,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
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

