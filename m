Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4295552834
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347730AbiFTXVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347368AbiFTXVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:21:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46FF29830;
        Mon, 20 Jun 2022 16:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To1xJBCDg0Rc8rNz+rbN4qzd6yEQYiHpW2ULBzjwRS3kNBrGp2qlG+zhLBmdYd2bd1+JCsu0UUO3EnLKJpUbVC+DE6+pzfY+aBKAdB0uEBbeEJY8As2Qrs5eMqAGWn9ruWk0mmKy0Cq3ax+sdFN+AyLCZBBiMiaabUn6sjAZyblzn3cnsdml5RKdWfERj6Jsj7RMJutY7ktrKTSSu133fXhcPi7Qnjc0Yl7nRIT8ho3Rvn2TbdTVr0d6QbXu6puwjrdbd67EhWT4X9Gs7nfNtJzBS36UKDuMhomcvJQWCOQxVplajstUOLP6cmftItg20o0OND5s87y98umYlQ9I9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EgfhYuxDyHCe6IiqKxVFkRy2SnJCwK4q9IjERMmJbg=;
 b=HEN5PXH7xlZxOEDMRUO1vIyAJpuwZIFOxoNIOSt416ngvewg7hNnWHdmPwbteoBAqM9uiilRW7+0SNzeLUJGWE3KbT8e9B10r8acLYEtJ5zaxTFWbniNkuM0eIRZ4MJF8nr3nhkjI8TC1oWt+g8dbzEqeU41Y6z/w91mPo5ot63GzCDx/P7Sb6x77A8lfFiqF9/KBmbiiUlZSsggcQ9QZa0TwWwsrMqNYfmgbFOoC6Vcs7hJnX+AwAFj6T98VpfCNKTiiy9o42wtZ6Lz2kbV7qeQY5uRQJ00OLyyp8EQbYomIbw42npE+xgD85F+C+LAJee3KTUuWEv40AXrmwQmHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EgfhYuxDyHCe6IiqKxVFkRy2SnJCwK4q9IjERMmJbg=;
 b=c3HHz8SJR2ICFe7JbpKR/mA4nNzIrtya56USuusExlBd1Hlm6Om9DG04oeddrOX5Zp+ds/81lLx/FHDmBPlQVubRooR3taN9hCQHvsWSSE8NZpzekfNAa4afVEZL5MMWOuw0YmJsXDB8KP9s9Sn0aGkUC8WWtHgjoNckthUVi0k=
Received: from DM5PR1401CA0010.namprd14.prod.outlook.com (2603:10b6:4:4a::20)
 by DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:390::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:15:54 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::86) by DM5PR1401CA0010.outlook.office365.com
 (2603:10b6:4:4a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:15:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:15:54 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:15:51 -0500
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
Subject: [PATCH Part2 v6 49/49] KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb
Date:   Mon, 20 Jun 2022 23:15:42 +0000
Message-ID: <65fc68fd20199994c0a61864fd826f1a461d40c2.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 51880043-d745-4190-6c37-08da5312d31b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5309:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5309566C144B69AEC9330F658EB09@DM4PR12MB5309.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lgwtG3juvmHjcZoLOCYLBK6pkmaSdSt52vt0PeEHdEs49VdmslxVaLahLusOuBcU9b6/32pv3ljJ3/GRvqSnbygYqVDkVo98VkqXaneQL7EWjT1Jr06qG270e+SYPrRtmpdaF09koQbEmou3DCozaCxRzedIcwZ6Uq9hkX1rKE7+uD32z/Ovm3MXONs5JZSDoynbYsLMzS09NOJ06rxpA7hyb2POzqFKrxxiS6EITxpYM7/cL7SCSTI2EyoZFwJYUeXnGzWwRliaLYTaFGf/KBXX7CIMd3/PD5cAoQQMgZMwBPvw6kC8mA6WRYvTd78xb3B964IVw8+yPgFrTMfYyK3E46M1HNCaKoLb/sw+ujOElc5NU8Jqx5wtAWMcDKo3n5Cf2/HSzF7ul9R80sFMmJCXStFRA+DtZchjJ+MQ+orLjoNaP/fIzbfdakHzfG0+5a9YL9VgYqVk7b4Zih9Od5YJKoXydiUCfHhTD4wCdBBGvMP33qSuqkKRzygCOLUB6pzcYRBF7pdjq4tZhqsdVdZNfEq1FPa7IOvdLM20gLiWUOF9Ony3wfVang1r6UCovF6sfjRkcAEyif4u+5b/1irMbrML9X1IivMVnAB8sav16pViKJSKpCOuRUxWMvfXWi3LJR1/R9Yo7g4IlHc+qhDZuAeGFxqwG3QX3AlGYJIUXDb4HRXsrZ6g4qokqIbT/D7yRfSJkCAIF3CvBRjQFZFOxFQRTQVOAGApoCOvV2Kf431Z2XPUI9NO+hy4Kbvo3mr1DQIKBM2CC4UZdXx43w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966006)(36840700001)(40470700004)(8676002)(81166007)(4326008)(478600001)(356005)(2906002)(110136005)(54906003)(82740400003)(83380400001)(70586007)(336012)(47076005)(426003)(70206006)(186003)(16526019)(36860700001)(2616005)(316002)(40460700003)(41300700001)(6666004)(7696005)(5660300002)(7416002)(7406005)(36756003)(8936002)(26005)(40480700001)(82310400005)(86362001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:15:54.1559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51880043-d745-4190-6c37-08da5312d31b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Using kvm_write_guest() to sync the GHCB scratch buffer can fail
due to host mapping being 2M, but RMP being 4K. The page fault handling
in do_user_addr_fault() fails to split the 2M page to handle RMP fault due
to it being called here in a non-preemptible context. Instead use
the already kernel mapped ghcb to sync the scratch buffer when the
scratch buffer is contained within the GHCB.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 29 +++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2c88215a111f..e1dd67e12774 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2944,6 +2944,24 @@ static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, svm->sev_es.ghcb_sw_exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, svm->sev_es.ghcb_sw_exit_info_2);
 
+	/* Sync the scratch buffer area. */
+	if (svm->sev_es.ghcb_sa_sync) {
+		if (svm->sev_es.ghcb_sa_contained) {
+			memcpy(ghcb->shared_buffer + svm->sev_es.ghcb_sa_offset,
+			       svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+		} else {
+			int ret;
+
+			ret = kvm_write_guest(svm->vcpu.kvm,
+					      svm->sev_es.ghcb_sa_gpa,
+					      svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+			if (ret)
+				pr_warn_ratelimited("unmap_ghcb: kvm_write_guest failed while syncing scratch area, gpa: %llx, ret: %d\n",
+						    svm->sev_es.ghcb_sa_gpa, ret);
+		}
+		svm->sev_es.ghcb_sa_sync = false;
+	}
+
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
 
 	svm_unmap_ghcb(svm, &map);
@@ -3156,14 +3174,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	if (!svm->sev_es.ghcb_in_use)
 		return;
 
-	 /* Sync the scratch buffer area. */
-	if (svm->sev_es.ghcb_sa_sync) {
-		kvm_write_guest(svm->vcpu.kvm,
-				svm->sev_es.ghcb_sa_gpa,
-				svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
-		svm->sev_es.ghcb_sa_sync = false;
-	}
-
 	sev_es_sync_to_ghcb(svm);
 
 	svm->sev_es.ghcb_in_use = false;
@@ -3229,6 +3239,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       scratch_gpa_beg, scratch_gpa_end);
 			goto e_scratch;
 		}
+		svm->sev_es.ghcb_sa_contained = true;
+		svm->sev_es.ghcb_sa_offset = scratch_gpa_beg - ghcb_scratch_beg;
 	} else {
 		/*
 		 * The guest memory must be read into a kernel buffer, so
@@ -3239,6 +3251,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			goto e_scratch;
 		}
+		svm->sev_es.ghcb_sa_contained = false;
 	}
 
 	if (svm->sev_es.ghcb_sa_alloc_len < len) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7b14b5ef1f8c..2cdfc79bf2cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -210,6 +210,8 @@ struct vcpu_sev_es_state {
 	u64 ghcb_sa_gpa;
 	u32 ghcb_sa_alloc_len;
 	bool ghcb_sa_sync;
+	bool ghcb_sa_contained;
+	u32 ghcb_sa_offset;
 
 	/*
 	 * SEV-ES support to hold the sw_exit_info return values to be
-- 
2.25.1

