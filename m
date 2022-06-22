Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7FE553FC0
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355474AbiFVAzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355415AbiFVAzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:55:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E40A30F76;
        Tue, 21 Jun 2022 17:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyjkMT56npsTofwLCjkARDqkTEp45TeEe5hPYqWmIiz8a1NpUBskxIU8ROReDESlGw1f379hArV+ZyLZfbqG/dLcgSxt7KKKCl902DIt+8UC6ENRYYh6Yxta09lwuEc1gLZpZXRiHpbqkFifpvWaGHyd34kD5dC3B2TUres2xCLn30jssal49NDk9uu/LZmhAmMxPE7lYLrZ3pCVqyw4b4oXLrKqTclIZyu7PLP9TqTSdlx32oOPG9Tuv7GqqJ2dR3np+OVM7DZv/hf8DK3IZK1Y4ze67n01HUN21MGEu6DqZ8ZS9soztMIhQEuubJV1Y5mldawVI/Qu0Ko8JFxTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTS+1CW2lTYu3a6LqmawL+VUdNwdn77A1oLP1tdn0OQ=;
 b=Rau/rAreVrQmef24JtIt+Ou8jW30GaSksNAhXlmrjmTucy6oTB9Hwz2bjeDeqDtaOUqVyEgO9J7IjCr9Rf4xCT14gpwy0+qSwwznAqAjHybrDjticWhNXh7qPtlwCmQIjf8CTQSj7YTwO6PzOrHTFOFFNknMyFPb1L+YHSNZUHk9H7EnJsBiaaZTerbiGwk+zcbS2uvv4ZlqkxWzz/n8I6e0U0EAPLAJeAqbYUidURvdB1YX6A8c6uBVRu2RWZLc7DIvGqhu2CEReYaz2m1Qo+xAHTGGIy5JpgLopP+mFbCAiXNl5LxfvtvXy4R3lGmLP85m7346XksQ1ksvCSme+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTS+1CW2lTYu3a6LqmawL+VUdNwdn77A1oLP1tdn0OQ=;
 b=CNc3wPyGyjgVLhEx/GpxljYcnatJvq1BRv68o4jgBNJaJPA0Z9AO95fHedzkcIlq6IrPKjir5fp26MDPxTDvIRkT/Yz/ik5lLrrg7i6SFBlE9pGHZRMNOySojpuRVnjp7G3NpicFOn2RZhgh03NuGGLW3mzvgwF9MAaAXZW2Cv0l+awhJf8BFygYx3ZPZ3QahZU5OkyGFTdiyXd00dapRcUa5+xdeMVgnqtlPHJIpj8aT8l8eAvBJv3tsGunguUfsQVgl64ZDyEGFKEY1suwpaiv7BlJVxdbup4SfOAmiBKBmePNYIgdLUgEFi5pTkCfesEo7z4vlG/HTa8o1iI30g==
Received: from BN0PR04CA0073.namprd04.prod.outlook.com (2603:10b6:408:ea::18)
 by MN2PR12MB3439.namprd12.prod.outlook.com (2603:10b6:208:cf::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Wed, 22 Jun
 2022 00:54:56 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::84) by BN0PR04CA0073.outlook.office365.com
 (2603:10b6:408:ea::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Wed, 22 Jun 2022 00:54:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 00:54:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:54:55 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:54:54 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 3/7] KVM: x86: Reject disabling of MWAIT interception when not allowed
Date:   Tue, 21 Jun 2022 17:49:20 -0700
Message-ID: <20220622004924.155191-4-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622004924.155191-1-kechenl@nvidia.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2243881d-fa03-4f8f-98f3-08da53e9d356
X-MS-TrafficTypeDiagnostic: MN2PR12MB3439:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3439446E03A2691D17017A02CAB29@MN2PR12MB3439.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eClEytRk8hWxlsJcHP8KOIFzk07kjdnMfNE2Ti0fvSN5AXArrpwzrKQDTZ1DJN2CxFSuHUnfNI0up137PBHkRkez8IklWAjOHD/QlYncfMdDRNZpLxXhdg8nvqOyqkMCF/C8jpr/DTxthLShtdg2br+aa6yr1mB1enkq2G77gO7l9vR/Su1VJeXVo3msdTYYL8ePFz1uoMoQfppHcAVELY/ME/DJzzWffOAzFkUx7FTdo+8nwn1Hn7z6Keib0vg7jeJP8BakrLcAapXMm7ZodNoEAmDmNDVCNvezS8hHFytvXXQLdJcm6HwMINZYiHjnvacfc1Ac6t2HKBkmLpEW8jaJ5bCWLsS2reS8te4tFLE4JIq5QcF/73OsXx56elh+fywslnY5p7ZnNY+Fo1ixCYSUuCOvj1QaSpQfQQoPKu3QMHp07hJRIWSgWsmd/P97x+/eeIID70Kx1Vq1uGys+zXFAo1b6jnQoIY76OxR09iw0WqtCMatpDlki440dQj0maslqbo9tgwHLRZ/0G17nB0/flJiT6O8vxuwOaN79dUYJaQEozrS3pN4h/ArpFxNAMehdSncBVIUDnvomxOyOStJ7TyegvfKmnvGfNILrIvlAl9bcOyzasRCXldUPdt19/tpbc5PbyqWFAuYqpn7xqI01qWE1VpmC3/oXRpL3F2KrfPOIY/7WhovQfAwwfpyO0CLS7wO1R+Rr5yraQs4y7EAwDqv/YYOO6B4/hNAXWXnqt92nOP4Qdo4Rsr2JVuV
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(40470700004)(46966006)(36840700001)(2906002)(478600001)(26005)(40480700001)(426003)(41300700001)(47076005)(8936002)(81166007)(7696005)(5660300002)(110136005)(16526019)(2616005)(186003)(82310400005)(82740400003)(70586007)(54906003)(1076003)(36860700001)(86362001)(70206006)(36756003)(83380400001)(356005)(6666004)(4326008)(8676002)(40460700003)(316002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:54:56.2781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2243881d-fa03-4f8f-98f3-08da53e9d356
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3439
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Co-developed-by: Kechen Lu <kechenl@nvidia.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b419b258ed90..6ec01362a7d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4199,6 +4199,16 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
+
+	if(!kvm_can_mwait_in_guest())
+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
+
+	return r;
+}
+
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
 {
@@ -4318,10 +4328,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -6003,15 +6010,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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

