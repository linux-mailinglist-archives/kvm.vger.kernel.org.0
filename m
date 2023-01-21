Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EDB6762E2
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 03:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjAUCIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 21:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjAUCIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 21:08:41 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720247134A;
        Fri, 20 Jan 2023 18:08:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K53lbHyN7jF4zRBRXxgDyosQOrwysNKHDtG/H7xkY4MJKpiz5CrZPhXR/DFm2hxPDSrskdiT6eBHv4VRcz2spJrUpxYHg1GEZg1YN7Jk1QZMdpDYXO0tqUfk9mAX4Y6GfT2ffXZLNhPWe7du06HGUMpBEgk88EgIYNcpillov4gfHid4JijiAwEVOzAP3DuyQknR4nf1hlfbmCx9mSWreQ9PnmIz5x2d7xyoR2gJQB20tM2j1PaLxMppQjzpctraTxrgs7O6zyo7m26SvwCrG6vm/QCDQXbtJ1p6v7bfjWhq4fxLUpPZ1hOrtsGDpn/BzA6sjszXCedSJFZjHUpO7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g34zLAdFZOgBMoMDZabEdu1+HOcuYlb+wiyGw6xI8bI=;
 b=ZFawlHv0pYd4e5TK3IwIzpITAGRFEj068jcdHzrunKhjKc6N3s6AgGxYX1diJmVbGtT61EoWTDXgh47NAPUrcrMsAghERUnTKwnd2m+e45555wA+9YRbmQhGEFOORJ/Wubr6BWI3H03KIQA14a2OTVcTtZS2CB6XOe7f8Tbl8onKtBPDk0Ok73K6tLEQ5Fzzoz7fnt+OnwIa8XqiOm8IVwuCHe890ojhMdhMP+7CXQmdjd+B5m1/biV7hFwuDLBW2+u/sJmcLV4UfrYoq7HUmKVg1ebOHl35Qdui4Ww31qpYXOOa6yT/nQUczp2GTA8ZLLVDTWHRNHzBEj0cKKv3wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g34zLAdFZOgBMoMDZabEdu1+HOcuYlb+wiyGw6xI8bI=;
 b=cLRHh+q48Ah6aqgiozFd1lR2/8OC5sdKZLR8kEgx8fGus9IK5YTsXp5GcPm1hRq/b+B2HuR065PxrOENFwTM+pvSWcAj9r9dXUrTlDd30omMXUHOcS/CcRfmt8EYF9dpVBzLhCdcWzFXkoicVKGJpqul1wNwianpObU95DzhUybISiObRMSbAfJLWrCcakLTIvA5yqVc45B0WTVVWDQq6LKHI0qW1xjhJGxA8oA2yy2gIWQwokbXcUylyIqAMNPLb0DzsGBCLmimhi4N0SZpdK7mQzriai3WqutM7iMT0iqOwhh6I+i7bhSWLZzkGLPurHxNLrS4V2B5uZyjetymvA==
Received: from DM6PR03CA0093.namprd03.prod.outlook.com (2603:10b6:5:333::26)
 by BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sat, 21 Jan
 2023 02:08:24 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::27) by DM6PR03CA0093.outlook.office365.com
 (2603:10b6:5:333::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:16 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:16 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v6 3/6] KVM: x86: Reject disabling of MWAIT interception when not allowed
Date:   Sat, 21 Jan 2023 02:07:35 +0000
Message-ID: <20230121020738.2973-4-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121020738.2973-1-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|BL0PR12MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f28a90-5f0d-40e5-1fd5-08dafb5460bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 018X+hba/Xc91E9lDshUWbZ/fcjy9un10vN4NKDFrrNTX91QRI32sv36Yk4zSJUpJEptMYOPMFHtEDsni6egDi6V4bscs0FwhmF28HNjYFxD1tS/6ZgQZAKuj6lrRT7jP/Uw9oTvug5sOj7CB9y13R4HjlNO9X9oQn9EFNUAS+cAnbjDvpK6auzi/LFaTLJTCRKCEuZe1kkJFNoC9sv9o6QglFE3aWA8blvEF4cxmgwImoMnAUldl2r8cRRuyPbisDW3Ali0EADnkzvJJV2dF/cBqzFAtbMrkdPv54gzA8YpVVSHtTEvBozOYgACXBNsJwjxfst0d9xBRtbeYJyvN2iKY8ZcOwHxkzwj9Zrt7ttSTQTzBNr7iXTQYR3dbEBhUiNpzMmcyBO/OdSPpowD/Zwh/OabDkOCahPdlgjysmvKJzTWkC9QvNuxw7N0CqPfkwgoICN5sMLb04goCqBXsvM/2iuffSH7qmlo2RDBfGCv1nGeo/uEc9bJVs3DbgrDqlUiGWnb9AljM10XLisMiazPrpm5yx0zs5Ax2OD1NFyZRVHmQl0NewPH+Gcs1p68OFcARYiBO1fUtbQJ3nv/B2KEE3TCPXeECwJVgAhXi5igXbzxc08EbINdEjDtWSduKdo3SjhPTprvNbkqNt/0A0Dvf+eF+xta7lH+TanIhxLBtaWd4X7zs62Xf6hTSun66QM8cr4yriK8+/dnjt+LIA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(2616005)(6666004)(7696005)(426003)(70206006)(70586007)(8676002)(4326008)(47076005)(26005)(478600001)(16526019)(186003)(8936002)(5660300002)(2906002)(36860700001)(7636003)(41300700001)(83380400001)(82740400003)(82310400005)(40480700001)(86362001)(356005)(1076003)(110136005)(54906003)(316002)(336012)(40460700003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:24.3746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f28a90-5f0d-40e5-1fd5-08dafb5460bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4995
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a77b55142c6..60caa3fd40e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,6 +4326,16 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
+
+	if (!kvm_can_mwait_in_guest())
+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
+
+	return r;
+}
+
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
 {
@@ -4448,10 +4458,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
@@ -6224,15 +6231,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
2.34.1

