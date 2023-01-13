Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A2566A59E
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjAMWDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjAMWCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:02:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B927275D33;
        Fri, 13 Jan 2023 14:02:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkiQ9CZmK1Gz0/uYi7v93jlSQyTDLrnQ9jj2J6uLvmpEG4XExy42G5r5ijOHl0Eq96rAqUJQTDZ/HxIY2CYyeimBovrsya0TpBKWARvwsVRPumugfDx8zPcpZYoeKDKpP2y/UJ/hElNu52Q9smP9Z6OA380UUHKalhiybasGZXbQ5sbeFgg02sHLu7MYNGxpykv5VQ+DAp6V1olwRONYRDvLefPPOK/1T2AfhT2V7iElhd3q5DooOv6TDnjyTuiidM5lIa3v7drw2maSelDEYMsJQRa/8MJp5PnJdymoBj8cQ0NRIznz7eFAEMZ9u4tmhpqsrGHCJZDWPsotMQgjYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MO0/hDqKGtucXNnwb5hqeLIqWTtw1nk7baueYJElB5Q=;
 b=B3E/Ui8fkhsMbYUlyonvDqbIYbe7EJ5Ou+JMVhUOJkEHqWF0Ar8VrQd79WVZvztovUOBVSXHTiWDWes+Wlr+0B7KMEIwnwn1SgHVnPK6PllX/Ka7Wgeaw+/icbUmgkkrxRElJXO5AiCMxEXE9wY9WY+1SjnFxhjXLPUGFzg3rd+14CYanNQc9LQUfCe7Rag2iwwQ7+KnfCRuWIqdDo130+VH/glHw/FRi4jrq/sZ53hKC2zCMeHkpDCF0lx/JBtsz7EADbhX3j2oRSHoMLNIoAG+IP12k7FM0a3Lt9X0IY0Jud9EDqnd9F0e9kBDkdaN9lXO41UyAY2ZJNpPjJj6IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MO0/hDqKGtucXNnwb5hqeLIqWTtw1nk7baueYJElB5Q=;
 b=fKJJwq5yeEMgTrBoxKFNkX1KXBle5rmQgYHJFiHc8CLcvfZq/UzB1/QlvOYOuGHN8anVEmNt0VybwLqtbf0i6jdis3tSwjwqLwCkbsxAviPTytv+QoQ6fUUeyde9fncTB7omjyBsM/vwZgw37G68tb+niJNAHxh1cfiR6bLP0D4iqkEBgInmgFqDa/XHYhAQFHa6KLU/mQqLLORov8/PUI1KvjUHIy6sEqAmWUafkhen4aAn22l0OnxeNBlrgBwtLOWKMkPHFt2C1ukAO9t3Rii8x4cnVuC1H+uosE2MYig0j/QZFgRZABc7pBsOOoSeERGo9gL8KXfRBDyBbSUKvA==
Received: from DM6PR02CA0061.namprd02.prod.outlook.com (2603:10b6:5:177::38)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 22:02:18 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::88) by DM6PR02CA0061.outlook.office365.com
 (2603:10b6:5:177::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 22:02:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:02:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:02:02 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:02:01 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 4/6] KVM: x86: Let userspace re-enable previously disabled exits
Date:   Fri, 13 Jan 2023 22:01:12 +0000
Message-ID: <20230113220114.2437-5-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113220114.2437-1-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|BN9PR12MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: b27e4642-03cb-4d8f-cdc6-08daf5b1d5bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzWGL0tiMrsW55Cew9unYpdBT5LdxMnWrEcuSjXL1MCZurrr3I4nFtz5M2rrWejgiX9YNa3XyGtHorQbSRKSC06/2vCjmk90UphoUCeqa9RMqsst0JWm6BIfkTLvKKgcM2e7M/UIp/f+CmA05aa1lkiUFP8yZZOLVmYb6rkgi4IkMKoCjbK5wMmjyg7cL1J91kcz3TRwnrSssFe3rcH1jRLOj1xre1B+uJy+IoxFdoc+ID1+ZlGaJDcN2PofS9IoyHdsujKBAZg01yptKtM0SmNcpFuy/4h9sRpuadZV6n5zOFSj5LsK9ENU3SAXCiJcQGpia1DRRBZHVccRHPwIgX2pd/anLijjuDa2wThzHANCFB+uY1mCrTyeaDMKx1OMEszmw0hcPYJtpp99378LdQnu9F4Y2VreYIJngywVqQQU5vwnffAk/NY2DyhLX15YaXETm/EEJPsXdV+WXiJIq7xUys1zfKpIh2sgsbdbUB/vuD43mth2gqS2FCvyxmEipUFhuhLVfaoSfEwtgfBN1xMgW+ZRHKHNayPgQykjbAz1MKd82XKbb4qeVp/Fz1dht+Ah8TnXXt6b87VlS7FdWWALrgnD/CRMdCUrQQ9RT54KZ0scgTkVMmul2gN/pbiiBnN8tzK8gZm1cDrzkjpc8y6PI0ngYDYDb/z6uBLMYTsV1p0dkYJCGoG46mFP1KJkxkuP1x3WPllRBGmkri0QDw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(426003)(478600001)(82740400003)(7636003)(41300700001)(356005)(47076005)(1076003)(316002)(54906003)(110136005)(40460700003)(2616005)(86362001)(16526019)(26005)(336012)(70586007)(40480700001)(186003)(7696005)(70206006)(82310400005)(5660300002)(36860700001)(36756003)(2906002)(6666004)(83380400001)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:02:16.8917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b27e4642-03cb-4d8f-cdc6-08daf5b1d5bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
re-enable exits and/or override previous settings.  There's no real use
case for the the per-VM ioctl, but a future per-vCPU variant wants to let
userspace toggle interception while the vCPU is running; add the OVERRIDE
functionality now to provide consistent between between the per-VM and
per-vCPU variants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  5 +++++
 arch/x86/kvm/x86.c             | 32 ++++++++++++++++++++++++--------
 include/uapi/linux/kvm.h       |  4 +++-
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fb0fcc566d5a..3850202942d0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7095,6 +7095,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -7103,6 +7104,10 @@ physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
 all such vmexits.
 
+By default, this capability only disables exits.  To re-enable an exit, or to
+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
+in which case KVM will enable/disable according to the mask (a '1' == disable).
+
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
 7.14 KVM_CAP_S390_HPAGE_1M
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60caa3fd40e5..3ea5f12536a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5484,6 +5484,28 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+
+#define kvm_ioctl_disable_exits(a, mask)				     \
+({									     \
+	if (!kvm_can_mwait_in_guest())                                       \
+		(mask) &= KVM_X86_DISABLE_EXITS_MWAIT;                       \
+	if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {			     \
+		(a).mwait_in_guest = (mask) & KVM_X86_DISABLE_EXITS_MWAIT;   \
+		(a).hlt_in_guest = (mask) & KVM_X86_DISABLE_EXITS_HLT;	     \
+		(a).pause_in_guest = (mask) & KVM_X86_DISABLE_EXITS_PAUSE;   \
+		(a).cstate_in_guest = (mask) & KVM_X86_DISABLE_EXITS_CSTATE; \
+	} else {							     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_MWAIT)		     \
+			(a).mwait_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_HLT)			     \
+			(a).hlt_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_PAUSE)		     \
+			(a).pause_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_CSTATE)		     \
+			(a).cstate_in_guest = true;			     \
+	}								     \
+})
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -6238,14 +6260,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
+
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..12ea7dd80471 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -823,10 +823,12 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_OVERRIDE	     (1ull << 63)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
                                               KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
+                                              KVM_X86_DISABLE_EXITS_CSTATE | \
+					      KVM_X86_DISABLE_EXITS_OVERRIDE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.34.1

