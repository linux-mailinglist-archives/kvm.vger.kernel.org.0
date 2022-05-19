Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539DE52D08B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiESK2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiESK1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:54 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A36A8890;
        Thu, 19 May 2022 03:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQo0e4K6+PBOAN2p9NPJrlEKb2YUf5lZdVG6OprJHT29rUUwGqTztsqDxqUcvjv+0vvP0qLpN016J3vpL026fTsQElX7E6vAgLtBGGVR3M6l/EegcPbcU+2kJ+qkiSbmrx2qaCdlAVF4xl2Hvdaat45OqmSw/XoHmldUWsaWS1VVn9CE6VMY924JtBhMY8I/8+NMPvSDWb/5YcpqBFzV7wzDg0ywfXnsWYHaTvToRmqHNx9OG3POQSpz8zzdiQIjOEhzCBdapgFNcp/ZpLRjVjsSTpPvOkDsZPnilkFjdTYQ2Ysf5uIIw8O1kvkpLX1/zmN6ft6gb+4x0YI5p+E1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPj83bZ8mihTAUF0tvoNhgkl3Cn0mGFmF6SK7lQl6vQ=;
 b=hsbGJUfc+CJX9VVa+2Gh0QW6cKaNseG3oE2ZOTVyn7z03TeicseRnapTjqpC0QhYdmogXR736RQvWpKdgyNVbdDR76B05OfYGFCJtqOw7MuHmqLI2Jm/g/P9e2c0Ff1tL99eqWeB+7GSomGI1iYyiETnMzaRJbSkQXxpuhOl2Iy1T/7ZPyerVKiKaA119xKccmbHx/S4qQ+e5aWWZ8i0Ju93mZy3P3GFFMIYJJdW/e6A3T4w7JIiW2Ew8fw4b7acg8w/4BMq2o4JVo8WqukjQGhuuUpt+olwGEQRqn7E1EA9Lt3/dA9l7JYE6Z18YBdTAnfwznMou6ithrsdFuh1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPj83bZ8mihTAUF0tvoNhgkl3Cn0mGFmF6SK7lQl6vQ=;
 b=kNYDk2DOnMLDsZvoPrtrDBbzl9rT3b9MdkP5VOs8gY0awb/GeAk6SOxGW/5GP/HyTNzszlHPIl2PSWLm8qZ8yg/u+lmWnS6uNAWl/zoy0RzNrAh7t0BPkmZDb/zYOyGf5i0aYUv2Ibl/UIxY/s6gXm7Pt4iijTyCg1tvfkM+tAo=
Received: from DM6PR02CA0126.namprd02.prod.outlook.com (2603:10b6:5:1b4::28)
 by MN2PR12MB4991.namprd12.prod.outlook.com (2603:10b6:208:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 19 May
 2022 10:27:39 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::88) by DM6PR02CA0126.outlook.office365.com
 (2603:10b6:5:1b4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Thu, 19 May 2022 10:27:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:39 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:37 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 17/17] KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception
Date:   Thu, 19 May 2022 05:27:09 -0500
Message-ID: <20220519102709.24125-18-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d89d55d9-bf03-4203-2bb5-08da39823328
X-MS-TrafficTypeDiagnostic: MN2PR12MB4991:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB49912C7D431559D3D9E22253F3D09@MN2PR12MB4991.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIBI5FLuIE+MtvphDJKA4fYZdX3ZRVQMsPCXu7vAVtEiRFLuY0Uo2NspXLo27h8TZUZAz9cEGD3EUk0h9HXf1a1Oh4OFanKfXV2KTNypMjSkmNRxnHmJIWacl/2ZyKl3lKSREbB49uMaWJ8+n0POTFh/HmAqo/fZCcu+d7ka+oUBKZ09/gk9+uTG8QIM0I7JcLZGGy5r5u1HNX/E6VkITSUm5kEPaXtrpbX/aX4zYYDBPKM7T8aPRNlEsXL4LwGWtBAZfnq+illMzkzsCC9Cd4EiQ/HqUsC0o8R2xv6oYIRPwtAbvgOhoLZCPwibds0NfmX/kJ+MnzuJgq9Cg+ujn08A9D+umKSeqikTacDN4eGYQrLP2idFzvdEcPZwCqGsHTr7Qu27G7XD7q5d8/23ZorwrxdT+JOkV/TPOij/hTEAwGRgAEzOy+vQp27ZlgfyQCN/JNvbW6hPtRpCHCj1ldN7gPrxLq1oSyFUKNcv2XaoXXGhKeFbxPhyuvO26lDZZFEruwVMChxNnDbGiGI5dt50vwx7vA5p2KBy9CsOlhWjs+ytSMnkW56qoQ4pGayhoNGVTldHgZZzUJy0lL5GDDy8MW1x72zqnGc04mAWhIzLgRyMp4tdbATsRhyaEMOvMz50iXaBPl0SNNNAYRfP36K7d+DxfOJpa6wjljgRMNT5kUATp3yv04janlkKr1+7vcUhPZ4Pf4slEMy2vG2Eqg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(2906002)(83380400001)(356005)(7696005)(508600001)(6666004)(26005)(47076005)(426003)(336012)(2616005)(16526019)(186003)(1076003)(54906003)(110136005)(40460700003)(316002)(86362001)(4326008)(8676002)(70586007)(44832011)(70206006)(82310400005)(36860700001)(81166007)(5660300002)(36756003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:39.2055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d89d55d9-bf03-4203-2bb5-08da39823328
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4991
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

- Avoid toggling the x2apic msr interception if it is already up to date.

- Avoid touching L0 msr bitmap when AVIC is inhibited on entry to
  the guest mode, because in this case the guest usually uses its
  own msr bitmap.

  Later on VM exit, the 1st optimization will allow KVM to skip
  touching the L0 msr bitmap as well.

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++++
 arch/x86/kvm/svm/svm.c  | 7 +++++++
 arch/x86/kvm/svm/svm.h  | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2a9eb419bdb9..0d7499678cb9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -100,6 +100,14 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
+	/*
+	 * If running nested and the guest uses its own MSR bitmap, there
+	 * is no need to update L0's msr bitmap
+	 */
+	if (is_guest_mode(&svm->vcpu) &&
+	    vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT))
+		return;
+
 	/* Enabling MSR intercept for x2APIC registers */
 	svm_set_x2apic_msr_interception(svm, true);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e04a133b98d0..4165317c0b00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -750,6 +750,9 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 {
 	int i;
 
+	if (intercept == svm->x2avic_msrs_intercepted)
+		return;
+
 	if (avic_mode != AVIC_MODE_X2 ||
 	    !apic_x2apic_mode(svm->vcpu.arch.apic))
 		return;
@@ -763,6 +766,8 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		set_msr_interception(&svm->vcpu, svm->msrpm, index,
 				     !intercept, !intercept);
 	}
+
+	svm->x2avic_msrs_intercepted = intercept;
 }
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
@@ -1333,6 +1338,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		goto error_free_vmsa_page;
 	}
 
+	svm->x2avic_msrs_intercepted = true;
+
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 309445619756..6395b7791f26 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -272,6 +272,8 @@ struct vcpu_svm {
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
+
+	bool x2avic_msrs_intercepted;
 };
 
 struct svm_cpu_data {
-- 
2.25.1

