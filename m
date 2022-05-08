Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5451EAFC
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447020AbiEHCoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387404AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD011156;
        Sat,  7 May 2022 19:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlQpq1/V/zSHMwofsPB16UQ4rT9806j9TWfVY0lHKkFEG0ROikCYcDtI2Iw7Tqd/RUd2NsVeO7SQYOYxmdsBeOxJQh2gugV67SyPyWe9CBaHHsIK1OqK1gKyyxcgVppZKo40H9PBzwJnkHaWtGAUtSubcjhv/CF1oOv3pVTM9b4FzxrfHyLzP5GPNx6LnyXSqFwzdIAftjfCP0OxR/lMqyZq1s4+1HxEHGISqWcoXMZ4qPdgD4jKZXsV8JpCEdx9q3Cm61KT+8EvvL1YQWel3HMiJbD0OZU0ip7yOz63/bWXza/HdXkYTGb0gWbtXA+w1DGm83CroiYjaL15i1gNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1OST1EyS/9U6biNqO1iU8FfjtR7QDLpP1DuZcjxl0I=;
 b=OmUQot5WH+5y2oUjSgmZ7Z3LXMeFvx5RkloaorId9HetoHM8eUnbe5DSkIO43h1hIGvPqXqcsYh4uR/Z2i7WyCPjHfsw8TxYPhsHDGfLeZGr4qvZ167oV/fFx1WGsuFfdLGpac4JbSSmXPSi1YAv3E9LnoM1w6XLXe/7vtGpWHVPWxcYWDpCOV35T7w46wogjM6c6xHr6koGRCmy1grr8KoZe5YVgjPdvSQ8lup9Jy2vlTl6ero3R9qLQXsO/aHTTlE3t9dmxU+PHsuqHQPwwiw1wV6d6zoiRZ0AXywc90EDqh3NJi24K0KCJkUPsO73ZY4hAGRpFEP4p09+sjWogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1OST1EyS/9U6biNqO1iU8FfjtR7QDLpP1DuZcjxl0I=;
 b=eA+ULqxl+cfM+mTE5wmK6uwDgKI9QSfsPK4rOGV/fUBRYxd2sbeIpgTg6TrKpUCOhkMt2ScuehtEVxGFOKC4CPzcdNepubnBlC/WrYNKx14QNciJXeNJxCapNQ47I8svorcYWkjUqGtJwzBYweY1tdxM6b6CNlMmiIQ+NAfXmc8=
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 02:39:56 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::a6) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 02:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:55 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:52 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 08/15] KVM: x86: Deactivate APICv on vCPU with APIC disabled
Date:   Sat, 7 May 2022 21:39:23 -0500
Message-ID: <20220508023930.12881-9-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2603f46b-e2a3-447d-e7c1-08da309c0989
X-MS-TrafficTypeDiagnostic: BY5PR12MB4051:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB405166E0DA41449B2ABBDFBDF3C79@BY5PR12MB4051.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThB5TKwk+JuuyrgqLcoOp0S1fHAQcpltJEeVa1XMTJfAIybem/mo2t5JfcBm8PZ5rg70fXhY5Z0WWgMtEhhUUTT2TFaiKxfNdLtW8/bdln3ylIIfEUaYtGME83XaO1U8KuDjG+rL3r8QAZYQziXRrOfS0nPbJnJHwFdfz73Xqv7TncMUmvJ1IIICl3pYEo46gjy8NcPz8OLwTlDvd4uNAwKMT6hTs847aIcCBm/zlO4/Ec1kNTnoTHakhCn+CuyQ3fN7lPd872bmFjHE853Noch2VCaQ9Dzn9CQSzpIsVGYzy5WIwSYZN57NXt1B9psYCVOAfJpZEo9b9S80prLA86bl1M6tFyHnKbL2V2zBUXP4d2+uPpWBRBlXnvrn/VoLzIQmiru1h+R9ocSsM4F9KqirILyAGVy1pxgmMtsMxIvuCACyMVU4drs1C7/pAXoBTBFMKz6ywdPdYQ0ektLL14jPOAw4ccO8SZkGjXWpp1PWBUy71y/vXhoJz3IFolGNtyf5xebfoVK7MQYHbdIgTKcWldSxn5b4gdi76FxEL5eWYlDdRkY8xudeNqTbgsK/gJRCHiYbmExiA/agHBMcAIlq4BtYcDhJAek9nFQIo+CHBtwcU0zlMA3yiYD7y7q6KPV1ITWO1RBKrsDIlLi21NNjhTC6km/eqov3pwVU0sNq+uaSVF5wbk7aMDmm/Vm2NYpbEa7Ji2vsdXxWI2IRtg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(426003)(47076005)(336012)(8676002)(316002)(86362001)(83380400001)(4326008)(70586007)(7696005)(70206006)(8936002)(508600001)(5660300002)(2616005)(44832011)(26005)(186003)(2906002)(16526019)(6666004)(40460700003)(1076003)(36756003)(82310400005)(36860700001)(81166007)(54906003)(356005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:55.7535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2603f46b-e2a3-447d-e7c1-08da309c0989
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICv should be deactivated on vCPU that has APIC disabled.
Therefore, call kvm_vcpu_update_apicv() when changing
APIC mode, and add additional check for APIC disable mode
when determine APICV activation,

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 arch/x86/kvm/x86.c   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8b8c4a905976..680824d7aa0d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2346,8 +2346,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
-	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
+	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
+		kvm_vcpu_update_apicv(vcpu);
 		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
+	}
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa762..77e49892dea1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9836,7 +9836,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
-	activate = kvm_vcpu_apicv_activated(vcpu);
+	/* Do not activate APICV when APIC is disabled */
+	activate = kvm_vcpu_apicv_activated(vcpu) &&
+		   (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
 
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
-- 
2.25.1

