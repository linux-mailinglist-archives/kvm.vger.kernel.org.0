Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55056762E8
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 03:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAUCI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 21:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjAUCIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 21:08:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D761071349;
        Fri, 20 Jan 2023 18:08:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtbrfULDmjgjhJHhfC855Wb7EKLE/SstKVr4mlfxUB2+EH8fZavYxxjhThsCKNsGeQMS8RPEsUmb6IXze2NYP2VSuBG8XRCDx4Gu9xlOcbWkGG+5JBsMpYEm7drJdmZ04rzofKqvVIeVkoiIvotz3Q5EZOf0nnGKb3pFedxDhBNX6b4EobapNf8m3xnQw4RpI/KJElVJ00WyG8keltt88NWp8QTNns8owJiPn4C3D0GyWyZyOUbJVxYJHw1lVd8/KLro1dRS1KorLaB8o/qHFXGN0/S2EwY5dGynTVJqy4y+CIHF5vFos3RW8Qz6nBg7u6o3fm8VZjENFIKTxDSbBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dInFWlQmlWges/kGbbRSqY3B4h+WSZxBeas3OVZFK6Q=;
 b=f5Pe0x17dt+wNZAJEVxQ6vORone3a0r0BXV8VdvBSVNeClDq4q25GbG73SNoMW80PvAYyfYZ16aAVUryyCgksvr5Hf0xGlp8sTcdem29xYGyd7j/Y7ZAMvBs3FERgTmiIlEp/yYr/M0E/j3b0v1hnrNXI3AswxFIcKMWVxx4j5sgi+26O/7OYpy0nGOnOpyIkArLQJT/lx18/YC/bbCCBYacpBpncfqaAwcwFJ5AYZ2wC3NVgezod/fTvQwu90DPY7/N8z1tAJT9t8LeDKhrbEyMDRYxwPGuoOSl1AwOV6PIyd7A3zMHlK09i2MeHmFCk5aEmmAWxCbp/FurYNI8xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dInFWlQmlWges/kGbbRSqY3B4h+WSZxBeas3OVZFK6Q=;
 b=Hhj0WJzIWilwnBXAGZMrfRnue38DmdFVC++0ilImDmFIMDIZbPFSkqQSQQ6CkPbzXTpqqVnU+T5D2459RBIY+Go9hZZJSUEut+wX5qCjlpwyexlWO/IKm6lE8Nu5u7Xgu2UnhaEpgGNnbfxDaugHWFpeVR6AxjY72VjG2DJOYhztDXvS7aAR7trruJ5RdDlTeYgF/6UU12gKEOnk+KpDW9mopqIKmbVz0zzAj252MPbFwYOhgsxNkQwqr4hnbP7L2yqNjeT73Malq2hfuA5MufE55QtW/QUFw8154LNqzeRCzqTKw+U6DSCtpNjrVk100OGQodpVXChQrmZ6Hg7lnA==
Received: from BN9P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::32)
 by SN7PR12MB6932.namprd12.prod.outlook.com (2603:10b6:806:260::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Sat, 21 Jan
 2023 02:08:27 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::50) by BN9P222CA0027.outlook.office365.com
 (2603:10b6:408:10c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:17 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:17 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v6 4/6] KVM: x86: Let userspace re-enable previously disabled exits
Date:   Sat, 21 Jan 2023 02:07:36 +0000
Message-ID: <20230121020738.2973-5-kechenl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|SN7PR12MB6932:EE_
X-MS-Office365-Filtering-Correlation-Id: da8e5f79-fe46-4ab3-738f-08dafb5462a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrbRwLE34ijLTJ257miHRyX+C4GqtQ1LTiCmr7cCYrZvCutmxas74ekU4T4DOEAFcWWnc5DoNXJ8nOHOijyFFOlGE6aHwHgFt7OQ6vVJcQrlwr/KdyAeFcXVkI0ETsZ9u0E5fKKH1Otc8oEnub7qcaj2FX8/iotWpLR3SbPEZypalfNIZ6v2Ykf+Ttf1Eez4oRv0KPC4kaAqLXH3entc0bct4/rekK0G/9vbnc6rXKlvuSjsX/VtDyOVoPYLxPS+b656Qe0/fjNCvfij1MMTd5dN6zkrb8MhAREo4syUvcCM7qAnw/PfmoizpbyPif7sNTk5f66PwI8ncvclrFoYMgbD7hujXHCuPvujC6M2tN8SRokTZhn0ikuCButpnV54eTnSWHhRx5e5eNq//N0g8ssZMfeliHGO21WwFMeW+ypusTAElfFog7YNl/yToey8i8zEKkE+9//LLes9N6VWAT7ZjtczOrBH0TgJp5ol+wGDRSFtba6EFnf6DEoAmrc+p0US3sgaUjHoePa6zyDX2vB7x0uLK7zQXHBwHOQjcN/vzN2pbRKrpQqqzv6jTzTnKyp5jrgdp6BKsK+Az763fSTbEUwPHaI4+lyOJWi5QCCMG3YFBpPl6cet45r7hSZ3hPid0ckajXdW4AHJJIiU+GH9gAHz86v8B4SGsLHy05W333hRHRvnejlW2HBL/j3X5TjonrgweOKoJBf3odNR+g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(41300700001)(7636003)(8676002)(70206006)(356005)(86362001)(70586007)(5660300002)(82740400003)(36860700001)(8936002)(82310400005)(4326008)(40460700003)(1076003)(186003)(54906003)(2616005)(336012)(110136005)(7696005)(316002)(83380400001)(2906002)(26005)(16526019)(478600001)(36756003)(6666004)(47076005)(40480700001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:27.4968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da8e5f79-fe46-4ab3-738f-08dafb5462a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6932
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

Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
re-enable exits and/or override previous settings.  There's no real use
case for the per-VM ioctl, but a future per-vCPU variant wants to let
userspace toggle interception while the vCPU is running; add the OVERRIDE
functionality now to provide consistent between the per-VM and
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
index 55155e262646..876dcccbfff2 100644
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
+					      KVM_X86_DISABLE_EXITS_CSTATE | \
+					      KVM_X86_DISABLE_EXITS_OVERRIDE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.34.1

