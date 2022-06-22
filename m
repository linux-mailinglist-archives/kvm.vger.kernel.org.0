Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5144553FC9
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355498AbiFVAzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355459AbiFVAzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:55:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6172930F50;
        Tue, 21 Jun 2022 17:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHQhPdXNx0p8ocsFbtSlyyWEmSdzuAA1K1RPKxIUkCF0uUK9A2gsPFg9h37A6lm7dqt2/rqVAmZjHwAbfCwvXy1YQntzlB+88xm+KcLSSXYQVU6wvZUbEMaEhJbtG0KEd96PWKHj52Vz++5cm4HnND8aFQRxjJUCmelMjFOZdXu0BORuLAE10lrnkt/ecc1eM3C8sPq1D9y3blkBGLlmwfmxeG5ZH0KN1y53qGY2+zwb3ya/JzBy+XrW6jm+tsrEQ9oS6m5H+tAzuZBLyPe6Bi6fLOd8xOfBaALDnVIENwV37Ibhsu2wy3uzlHNiN82RsVBkGSKE3GJ1Ch6Q8C2tgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccIl/E+UF+vZ5VwPRBoaMcmya4evfUFZtd4XoHWCXwE=;
 b=Z1J8f8hwlOaRQ068BDUkrMWP8o7VzUIpfgcRJbOp3a13hlEvO3bF2ypbTSU/oOO7kduD9Unb/lGyNfYe76KLjjS22LCuz6BmN6PqqkVsLcA1kgrHsrlJu0hoyd9H0xRiaxYjRGcqwvAtqGhtkwxD4HZvPPTRYP6bPeGAGnfRGrkqTjb7CoP7pI0izFjcld4VKHNfCuciHy638KpBDnyn/rYKL1g1+EP6pD1HhxpNq5d+WPtD6Gs2bJnLwUB3b3e7gFNG1/eqRkFy/lC+XZRAcXrXu27hPgydwGdVYBzrEk3DzPb12j9y0hut+mUtw6OTTH0/yorZuxqP2KgOx2PEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccIl/E+UF+vZ5VwPRBoaMcmya4evfUFZtd4XoHWCXwE=;
 b=HXYbpEZxdEixmax1P3aOEhcWS1SAQh6rJMSkSNMEeC7hxHOb6n9rHeUy/FrCT3XDLjNXqfZfihRWPn17uCAs/NNhL2l4UhgH3nIWv2WE6ETfPzoIDOnmq54B1yM7yg3kXrTdDFqpHV34F9wdVr9qu8U1mMMJj3uTsMMQ2ksGP4UWs6L47SrRw0SDKgRkbeHhaZCiw26kp1kbsmxgl+U4pTZ/t+bFWFxIHBSm7G2c9bf9f1/+zkcm9FBkKPFMXfV5vWeZE25Mch17SApw2u9HGPFxmGKbTcSevlfr88yqoLnwxxaYvCBqJwXEWcRiSJRrWxhEoZEoX+cYDBzxZ24hOQ==
Received: from DS7PR06CA0007.namprd06.prod.outlook.com (2603:10b6:8:2a::25) by
 DM5PR1201MB2554.namprd12.prod.outlook.com (2603:10b6:3:ec::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Wed, 22 Jun 2022 00:54:58 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e7) by DS7PR06CA0007.outlook.office365.com
 (2603:10b6:8:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 22 Jun 2022 00:54:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Wed, 22 Jun 2022 00:54:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:54:57 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:54:56 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 4/7] KVM: x86: Let userspace re-enable previously disabled exits
Date:   Tue, 21 Jun 2022 17:49:21 -0700
Message-ID: <20220622004924.155191-5-kechenl@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: fda30173-7991-4d5b-34a9-08da53e9d477
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2554:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25540AC16E13286CD8988467CAB29@DM5PR1201MB2554.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kn/OA3VH6nNu+Z0gbRL7HpU9YLCHkDCCHNNjKtKt44hhIAk8lNB60okmNVFRzWs61HsED1PAz0bbOfjcL6lcypL6Cx5DSZKf99gR0jTd2Jk8+cZPtyRJjULpQmQWDBvmNUCePLNWKF8RvErJBJH/pyp/MsJo59S/jCHPB5Si10LRogZtyk5gubwYVAMA0otUNgwC48JtmuQvDvyS68WxoeiK79TQnNxIuBkqv2xRWg4q/2xptrMTvHW+mXv0tlD2DeptTJfcJqO+1jax0vdfAs0gis1MPfOD5ExKtUqQEkjxGBQ28afVeaoOqi79SMrKhn1qIeNs1KLVwGxk9m5PHyxueWqnObVPwQ5YjUpBdFFknuc5wGGuudfT62QNFuEXl3Fi8aBquYUwwxHGGaVsz4TAsbL2uCapNEKbp0bVICRHTGoX5RwKAIBhjyxjufV67vpsN2B4Qm31AJNuN57ZNeDpi6f+aZDfyEyd1B+LjtQ8fhF8VPOm22opuk3WMxlNR3tNZ4vYrd2q+PrUyCsBZjNhQ4/1FrHsiLLDuGRHXxembNrBh7G8gs+Jvjox9xFtYylSfJeYkTmgC1i1xfwBESiUrlCOSPzKM6OH6y47pnhFk7I6ZRKXb8+zo60lrzIG2pY+EhtVk3qa7DRPCOh0z342o3ibRr3X19PIm+7rZz3PJ7MQ0esN/SKSnOSDOnXoV0Oyp6D7M9t76/L90L8ES7od+IBAUQFtCK8OSARAuGg+y9nUSh1dLktVc36Chkk6
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(40470700004)(46966006)(110136005)(54906003)(2906002)(478600001)(4326008)(36756003)(26005)(5660300002)(8936002)(70206006)(316002)(2616005)(70586007)(41300700001)(426003)(40460700003)(86362001)(8676002)(83380400001)(1076003)(47076005)(336012)(16526019)(81166007)(7696005)(40480700001)(82310400005)(82740400003)(6666004)(356005)(36860700001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:54:58.2164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fda30173-7991-4d5b-34a9-08da53e9d477
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2554
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
index d0d8749591a8..89e13b6783b5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6941,6 +6941,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -6949,6 +6950,10 @@ physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
 all such vmexits.
 
+By default, this capability only disables exits.  To re-enable an exit, or to
+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
+in which case KVM will enable/disable according to the mask (a '1' == disable).
+
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
 7.14 KVM_CAP_S390_HPAGE_1M
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ec01362a7d8..fe114e319a89 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5263,6 +5263,28 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
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
@@ -6017,14 +6039,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index 5088bd9f1922..f2e76e436be5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -814,10 +814,12 @@ struct kvm_ioeventfd {
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
2.32.0

