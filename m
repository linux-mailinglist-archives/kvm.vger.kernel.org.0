Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21864D043
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiLNTtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiLNTsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:48:14 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342FF2229D;
        Wed, 14 Dec 2022 11:48:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNYgM4jKtD6mSHe802fG/uBL3josC4nq5IsMjw9gKyIfbCMdfwGp6M/dG07GmgQrgmWWrcmspDkQZ9DfkzG9Hq68eciYtHZY7dACYOYX3a8pFeDn7RW/UgWi3dzKf6d4TJrw1+tDZM9W2IiALPz526nSY+Lq3kHermfw1ypO5ApFu3lBUxPuiMAiRhqqZbfaDmecs7n8jN666sAE03epZCNeUbYInmlZOH7JLq+AKHE5tioiljtyx8eEvEpUNK6mndfgQQI6Aftle7N+iMiyct4QBPX5SQKxv+ewE7HiT0Zc+TBdOqK8i3z4UGw01l3YgzhTQGN4IBNVA7UeoF7kiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvB+CkWgMZwu/G1uEl2VsVd+ebjzmKgx1a7uwFu23Fo=;
 b=U3+SMpquxa/ms2WEmLQ+/28sfaQZVRCxiHz1esLRSHrDPnTtZHQlK75UJ7PWtlHxQKOoWIq8MKWKxMp21RWS8xUgyn3XqbU4jtrM53S6l8UioFruxkmCoMn4C345DW9h2meVtnMdMDntSSWjF+oq1PislNhPUoKLYJ48LQwMM5C411tCLPJ9XHAxDHVJ9IkOr2Yg4oi+OgYgwerMGAxYxS1QYcS2ZJIiWk1nE1J7jE7wYEUqcktipWN/Hsdg/PCgKuHrjpYPK4iFyALqCcdU8bf669Wm1iipltpxm8J9A9/p64wePHTRyNQQvcgAbVKKPKQ6TZm9yiZatKxKxJ+T/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvB+CkWgMZwu/G1uEl2VsVd+ebjzmKgx1a7uwFu23Fo=;
 b=wMCYzGlEkNAmAOfTxWcOgeZ+c6S/yOGUw55OkgyBzWzL+P83maWjcDuA6oMm3/fswc2NNzmxVOJdDrpwANg5CwOsAU84sB03Bm81CQTHU6iWC9mQTGpa2Z9YCu8B0msjbie3LasSAAwTVZiQ3HdnLnsJsOAicwjP7fE+9fYn+x4=
Received: from MN2PR15CA0002.namprd15.prod.outlook.com (2603:10b6:208:1b4::15)
 by DM4PR12MB5868.namprd12.prod.outlook.com (2603:10b6:8:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:48:08 +0000
Received: from BL02EPF0000EE3E.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::16) by MN2PR15CA0002.outlook.office365.com
 (2603:10b6:208:1b4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Wed, 14 Dec 2022 19:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3E.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:48:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:48:07 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 12/64] KVM: SEV: Implement .fault_is_private callback
Date:   Wed, 14 Dec 2022 13:40:04 -0600
Message-ID: <20221214194056.161492-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3E:EE_|DM4PR12MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: 169c56e7-7792-4b86-c9ad-08dade0c1fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0rbxraxPtDOWCByVgnfIbq8jdZLNqlzmDssuqU1uERFzIEah+DD1EZlKHt0YFddi3klzPC8YufYVegkczH0/OoLAovcGGWpX6un7nwaBjQeD+NBh+qAR0Xis9A6HXa/6tcfPdrs4/RtKBAX4qQaoXLzDbhXcTIxS096xBe96WpIKaRc7WqB4tl4gXXtkaNvoA7HsP2V6EULZm5jnbOAnU9iFRpCzr4cHESv3/OwC0PblOTqMQnWHIabEf1qPiqeHubdJAo8bbb4vEQFPDZDHSV/klCI6orxIxPJnrf3O9LpatoRY4lerVZ3U+Lc3Az30Gp+YJPlBQPR2Giz2qg4fJEGme/n4o8MKQwb84dMitq/UlxlY6kxe5WWUhLkmlYoUBQmn788MIKlwB71EaklUkwwBSzWaVAjaHHMjmvvDgRzuU8MnQnTknz6yRU6E6NjZr+2vnga/r3x3jUxqyTz05p9Mo/iNjHhEM1vxlCC/dGVMsTHCN61DPTWjnvLWL1jaQwIVbFwtPzoM+sGC6vThAyAGcrpwsbpMkjTQJ6e5J9y7y7ZfCm0nHhhukxOzzGB+1NdJnZDCudHbznfbb8hDDUGRnta+sbFCmaeUTb6XsGrDWM8dOHFsxPmww5nL+NWRyhLNP/3oBkHvRZ1LA1BzVWiMDV88ejNVNi4nyZI0c6c0lTkIHRbYgJoXybYvfvHqpW014xCKZ/MZIL6lWnJxu4ezLtPhMV3Uv+ZrofeVrY6h251qdCXAEurvSP6aOmu7nFOCxOLh12jrdWUo6QIF6w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(356005)(7406005)(41300700001)(8936002)(6666004)(478600001)(40460700003)(86362001)(82310400005)(81166007)(82740400003)(40480700001)(36860700001)(2616005)(5660300002)(16526019)(44832011)(1076003)(336012)(70206006)(186003)(6916009)(8676002)(426003)(4326008)(70586007)(7416002)(316002)(83380400001)(26005)(2906002)(47076005)(54906003)(142923001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:48:08.1273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 169c56e7-7792-4b86-c9ad-08dade0c1fe1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5868
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM MMU will use this to determine whether an #NPF should be serviced
with restricted memory or not.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ae4920aeb281..6579ed218f6a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3179,3 +3179,26 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
+
+int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	if (!kvm_is_upm_enabled(kvm) || !sev_guest(kvm))
+		goto out_unhandled;
+
+	/*
+	 * For SEV, the hypervisor is not aware of implicit conversions in the
+	 * guest, so it relies purely on explicit conversions via
+	 * KVM_EXIT_HYPERCALL, so the resulting handling by userspace should
+	 * update the backing memory source accordingly. Therefore, the backing
+	 * source is the only indicator of whether the fault should be treated
+	 * as private or not.
+	 */
+	*private_fault = kvm_mem_is_private(kvm, gfn);
+
+	return 1;
+
+out_unhandled:
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f3e4d91c0c6..fc7885869f7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4830,6 +4830,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+
+	.fault_is_private = sev_fault_is_private,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4826e6cc611b..c760ec51a910 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -683,6 +683,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
+int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
+
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
-- 
2.25.1

