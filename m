Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4B52BFF1
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiERQ1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ABAA30BE;
        Wed, 18 May 2022 09:27:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVWGv3ZsrdG6YnDxSOj/ltfCga0WYCBbmflaSGypeBeW1awKPbxMAFKTLPSHywO8BehBUHt+1CsYM17k4xB3R9gofUqDz6Nf1fdkErSpqEv4DnbKkUpmfZrrsP1zyJt/E0CBFEStlzE5ae7IQ8yWNSVGERR8/orYdagx8CJtMfIutdOqJRcRjDhgr0J+414IP/ncDa+5wopYUVYmo/BubQNtN76aEfWABMVOy5JKYQ+F+m9uQB3wKOm2/dVwQTd1z57E/771Z2ogs8jbAE9EdndIVpntj+p43oSleEjSQ+SSxwYSUHfaneD6lrTLrlcIa4oPyyd/7zdOaqrWALkgIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/Bie8oDP8RAYNrsWPeGRtId0tjZaZQocZJiTWghtFg=;
 b=ZE1EEr1SVcVusk6rASq3UegmumAs4kvBXLQxLuwpUKohuLnwYuo6lfTOs5bWR+GWUjtj6SgFafkhfviVMCNgoCLd71A1RZV9PC4t9o/MPHUIF6JqHz8CAAxGpTsMIJn6X3Jy0xnwQ7x6WwvwdO1KDngjBSkqVnwNtR+2u1bBHaWqQd8SMe/yrUcvhBSEbyGCB1b0TSBqUbPocVofMdvhIcpdwISXR4at8peSvEQKFVnNjmQHQfAeDl2BxjHvENtvLF42dgWqf0B+PA+3LA3sTtODF6p7muu4ERM/Hu68NhJxs8UTXcwtQhd8gtFTX90wt4ppTNkKN5f0ENSBUC0oZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/Bie8oDP8RAYNrsWPeGRtId0tjZaZQocZJiTWghtFg=;
 b=piTUddLQ62AOUW/UYMxqpT8IYVidDSPoujvBArG+3FGcabDfiEXsj7DUTqXb5YRgNAqgMbqS+LUmEBEbEd+jOsKjUbgH229UHt78FuIT2xrddT6Ae6z/c7w3XAPqWURCOphMiM7BFWPxBnRxQEXvLnv5o6a1RcwfBhgnebICtzU=
Received: from BN0PR04CA0177.namprd04.prod.outlook.com (2603:10b6:408:eb::32)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 16:27:17 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::a4) by BN0PR04CA0177.outlook.office365.com
 (2603:10b6:408:eb::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:17 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:13 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v5 11/17] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Wed, 18 May 2022 11:26:46 -0500
Message-ID: <20220518162652.100493-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85a3f32d-6d7a-4164-6ab5-08da38eb461d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4246:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB424667AF1906C85D1B8F280AF3D19@CH2PR12MB4246.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnxUqS36+As9I26bQSGHgd2RQXEBDid9kNWD0us3PmaYCuysamAiKSQGC+krfviHJS06V9cwvp81oLTeeYVH4kXHPyoE3gK9aeIZgD8vPnPpnGeFezXDE91xx9GqmgjZUyMTuwRCaD1g5Eqi3x4WMBRKChx1TPf6UdoniR3RAxZtM+mqvb5x4ra/dSixReCu4lSlwKA+zhvNnrLge7xRYqoCHaszUwmkrpjXFhxX/a+UOOIg5VIbRC6VbT+tE7QV6lQWXt7+UDUVUgDTKXpfYcyue8zZgd4SEH7tCIwaJSqVog5odmcjkXyFEKVVNGpQE4Lettk7ENsid+d1/vcpmHAtCc8fgrDtucsdUlJfk5dODtUWqAGyAUSgigrMTlK1gYo3AGK1XQdng+WD8/ouqlm0JGWt9u6eFTjXEzS7MhTrj/LNjT75XmMiVwJ5t//AanTPJDprcd+IWiHkIACV/8UJdNKZPeYB8h/9iL3m/xjINjSETLBPwO7Ei0Ft0CicqgkrQdmxt1ligpb7xd/zXTQOiak7xASqnImnpyXcwLyXQ8vyQG5ArW1+/cYpJD5RcR6GGznJGzdz8FqX1XA2YMEjNSleJ7v5P6tHEbJWp0syp3Xl3EBhOUlOlDqnhiRn/3Xz5hIg1CjjZ0aNf2ExWpe2wKYsrTj0mlrXzE6dh3waXSk185Km4mTTpHEDs26t/6Tr1fe8pS5aB/eVPTzx4g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(83380400001)(2616005)(44832011)(508600001)(70586007)(8936002)(82310400005)(40460700003)(5660300002)(2906002)(356005)(4326008)(36860700001)(26005)(8676002)(336012)(70206006)(426003)(186003)(54906003)(47076005)(6666004)(316002)(81166007)(36756003)(16526019)(86362001)(110136005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:17.0524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a3f32d-6d7a-4164-6ab5-08da38eb461d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originalliy, this WARN_ON is designed to detect when calling
avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
is_running bit is set).

However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
running state, in which the avic_vcpu_load() will be called from
svm_refresh_apicv_exec_ctrl().

Therefore, remove this warning since it is no longer appropriate.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d40170082716..2d9455338b1f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1038,7 +1038,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

