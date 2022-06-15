Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD62054BF28
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiFOBR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbiFOBRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C198240A7;
        Tue, 14 Jun 2022 18:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n04nGeYh/ONLdfQQgaBm3o7gW7mjw4QJBbYbRZfaVJ3iIVLMCPXg1JoYGOmINeP2Nf6WMnNbiPp4wz+doDk5H8VS0+LwPkLzMGd0d9fUjHgOjhe2CWeW+fH/NMrTAmxaDh5M74kmbE9+lji3WxVUdppQsKa92UnVjxSfF9GCnQqYtUJMgqChUA1/ZsTC/zHt/FM+lyuOe7LY5Wf23f20MjR9aOUDe5O4GTBdqch4tLRB0ZOPR9QivdjcluC1nVznCaB6o/Jh3FUYJi3i8+6dgK2+/eaFbslryuMDJs4dW8JFgdip871E4tS5B6uKMBq1hS7xeKp/1RWbwnT2BnLrUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3ykLlqBwjcfCVIKCWYupwhWB0SXpj41mtaBtrJP+CU=;
 b=KSoLxk1+L27ZbLLXqhc6Ip4UIdHGoE2ut/xSdoaWaCsqyawl/Kp8qwJaIuEGB+VK/TRcIAyMUqzYvdvxcE+jVTVOOCEh6BHK56CkqRw5b1fOSJCImYEfakZ6RRM8geUNFlnbviuNNip31kYZYvINhTvGqS7cm6rwYnQAgC1EeOssKaZwYc8HItR22MVCRU/pggKJpQNoRfjBxjIEzmT3U9vi3gcNIpAnZqPgnum9icNbVlvi+AQgQ+dRi+613/SXTPcF6qzgUw+4e4TEOOttSpgpgvajBlVzsNsm7njGRdY9uHUJBae/hSiQBY7PegYQKfnXEgj9GnTigUDtpQjusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3ykLlqBwjcfCVIKCWYupwhWB0SXpj41mtaBtrJP+CU=;
 b=g3ZZnB/ZwqG2eYiGkgDPrMuiWYAu+NDrIAuol38D335eIDRPkKgvpf+f3nNwrhNZ9iC5i2USphcJwLaE00Ja2zjWgiA8o1oZ8qeknGAf7iOuvOXg3sel1Os5lDjalRWClrIEcVYGRDICzZ7E7LkUDM+upY2bMWj/8nevCnkhgDTL53gYdR4pKArUnrxnGN3UMe0HJc3JhoThQWSQd8Fo4DWOSXmR2/HV0MLZzXQ0u3UM0+0byoHtxrz2iW1SMX87Kxgomex9uKlHjAW82UvdwjbthjW6lPiWX7RhQSADCDM3hr9tf21YLzxqeQAHevfnh6CLilg8/q55RlY3h4fjMg==
Received: from DM5PR1101CA0019.namprd11.prod.outlook.com (2603:10b6:4:4c::29)
 by BYAPR12MB3493.namprd12.prod.outlook.com (2603:10b6:a03:dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Wed, 15 Jun
 2022 01:17:19 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::ce) by DM5PR1101CA0019.outlook.office365.com
 (2603:10b6:4:4c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:18 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:17 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 3/7] KVM: x86: Reject disabling of MWAIT interception when not allowed
Date:   Tue, 14 Jun 2022 18:16:18 -0700
Message-ID: <20220615011622.136646-4-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce48a59a-baa9-4821-d211-08da4e6ccae4
X-MS-TrafficTypeDiagnostic: BYAPR12MB3493:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3493E042FFDFD4FC87489BF1CAAD9@BYAPR12MB3493.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rfdvX/vbfIPicNOJwAH7ZKAu9OOidAmU8kfR5FAj7Zaf6mQcG0rqMLgIjrSUkJzNDfX+2VbiJSJutdc+SnheSf/2YTUQo2EZW3KEgNQ0flN9u/hVVMcMXRJIg9o0baaRkI2u90zY+oAAc5VIYYHf2vDbPomnbK2sezZeolIRm/svKaHUhcJweHO0qI1Tic9oJOU/b4ZV2AVtmceU0GnlLJI2mTMOXBcD+qqilVccBVlrY8jtv2GhlnXJ5GVUZ5OK4OVfvUKs/jWTzDx/4RGEZFLzx4782iXhD8Do10Gl0GOQeD8lJXrQhnLBDubCg5Juwh6YgD13LKnbJHC9MqF+i7FqZs6lFa9pkNj59TKZgyPpL9FSnfUq0lW7FD1TkQxV6jLnxUlqdafTpp7WOvTnNlsQr13m+CttHCWwrz5hplkxb221AHG5RfsvvNvENKxibxfFnMa8zwZtXniLBTby+F3poZe84LCyxkVTpLvE8Q2RHcC4Ci36Xy+cAGFmpbhqI4qlNJEzCc/5zutz8roieDJd4E/H/dKG1M9/b7KlWf/Phw4J1fqAnNoXHq1uDXmtKxPfgranLxse28dJXV+ZzKR5cGsBw0BvhbH6lXzkcQI9RjZAZt0NV/AUZDxW7nH6S2RSfJgO1j7JVrxhoXuXPV13/TQKmtOD1ChN7vvVhXkwBEfjW8aPJL4bIY/Run8uVKOm+A+cBYYNbljGh35h8Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(26005)(47076005)(186003)(16526019)(426003)(336012)(81166007)(2616005)(1076003)(7696005)(356005)(40460700003)(86362001)(82310400005)(70586007)(70206006)(110136005)(83380400001)(54906003)(8936002)(36860700001)(508600001)(316002)(5660300002)(4326008)(36756003)(2906002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:19.2524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce48a59a-baa9-4821-d211-08da4e6ccae4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3493
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
not allowed in guest, e.g. because it's not supported or the CPU doesn't
have an aways-running APIC timer.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b419b258ed90..f31ebbb1b94f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4199,6 +4199,17 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
+		KVM_X86_DISABLE_EXITS_CSTATE;
+
+	if(kvm_can_mwait_in_guest())
+		r |= KVM_X86_DISABLE_EXITS_MWAIT;
+
+	return r;
+}
+
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
 {
@@ -4318,10 +4329,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		      KVM_X86_DISABLE_EXITS_CSTATE;
-		if(kvm_can_mwait_in_guest())
-			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		r |= kvm_get_allowed_disable_exits();
 		break;
 	case KVM_CAP_X86_SMM:
 		/* SMBASE is usually relocated above 1M on modern chipsets,
@@ -6003,15 +6011,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
 			break;
 
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			kvm_can_mwait_in_guest())
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
 			kvm->arch.mwait_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
 			kvm->arch.hlt_in_guest = true;
-- 
2.32.0

