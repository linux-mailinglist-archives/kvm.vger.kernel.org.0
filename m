Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D7866A591
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjAMWCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAMWCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:02:09 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5C06DB81;
        Fri, 13 Jan 2023 14:02:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3zqP1p+WPkYtp52y52CLYDAzmiph91f7gM6LHePNLGW7KfrUL3AbXecAI7IO48zZ5oE5IN4iE5FTGmXP5fIbjhW2yLhveUSC/FEp5EJLWC9oTqFg43zMCWnnF1DDOqzLZsp442uuE8pnBJrGJuNuW35n+237KAu0IcKkvt3fUnVL8Nki5uwlIC4Nq00TypMceFViHsLwzd2xURux773HoIXtHT6T56GGztHhMAyWU7kI0/3pMagGwDMlvkGUl5ph/8b/gMoc7ZUfEFKeQlmIsxdqh/Tb4QT2g82JiIQ9QSL5qOxos+17SQFEKdq4FvN7+PDRdMFSZ1u92bz2amLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w56JfpoPTBvKDxhszdWrwSVInQHrFM79VlpDgl47F2s=;
 b=CP5agHwxAi2ZAKNuS2tzlQRIPlTpHXTjT1p7SHHu8Gr+8jnSEvSQuxKOqFMBt3BQux08kfsCjZUVlUP3lBvPTDARRX2pf6YHCoiogPry+rf8kqyfnWe1Dw8skKAWA48PQsUDywEIhiayoRH+L+ssloqPCyQq6lWPGLFiWLpTl0Q3woK+LeRhmU43ZKMzr0ETo9ENa9HWqan/Y5cufi3C4cPpsSnxhd/Iyfcy+O3ZFw7PcqPi7MH9Av2NMMt0pQOlElUH9PNfct6FIxZcafXMLSIvRKd9wqq8LMO6qP2Iptd/1CDPNsEh6GQ+yMrZ8V0EqC8BR9fQ1wmF8FOGoa6h/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w56JfpoPTBvKDxhszdWrwSVInQHrFM79VlpDgl47F2s=;
 b=rRlYmlr8I4AvrDLspS99hpg9c805urTn421BFnA0BSyrNI69wOi7m10cDyy6qbnTq5xrqR9w4dgcy385XD6SIyH6wDTVWUYOPy1V4Gaf4nKU6FZqPIJ2NroFTs6OBtCl+KMT6+1Wv1/0Z4NsDqfP6Jq0nLLMxTHizcW6LKg4LCdXJwqGpFrMAjheX3RQTB0yHuAVG+aHIgqmjy1I7eHBAuucBiGzfs/eqc1ivDfWjQR4MrdLbt7uMvfCM2sZs5ZB1hMUL/VM/dsJWh8+19s1wVNytpjfX8e8k/UjHDRie7lyrLEJ+yeb0t5BCvpVEArjZde4kgXsZdzlm3B3BTGRqA==
Received: from DM6PR12CA0031.namprd12.prod.outlook.com (2603:10b6:5:1c0::44)
 by IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 22:02:06 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::a2) by DM6PR12CA0031.outlook.office365.com
 (2603:10b6:5:1c0::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 22:02:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:02:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:54 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:54 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 3/6] KVM: x86: Reject disabling of MWAIT interception when not allowed
Date:   Fri, 13 Jan 2023 22:01:11 +0000
Message-ID: <20230113220114.2437-4-kechenl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|IA1PR12MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 51207a77-012e-4325-0a39-08daf5b1cfa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRZLwZbsxFRzXefC9pLMV/5JkhPFlvxpCP8PfeGI5qzQovW6z2Q7Zv0zQXh4qjjy/jf9lHyxvxFDr3CekEmcHu3h6d2mfFhk3cDCDmiaWxDLdx6xeDHntC1WXTaiif4+HH7SCZbegjgfIpEUuuELzTZ4B9hRjj6K6sl8i/jlTxyOZG9wc1BD7PaAgCuOYfUd5xHtqx+t5rVPgrJRCmN5JSLQe84xKXfNhxc/eQ+H3y8eMBzX0T1/I/LaoH2G5jhnxEOAQpnyjPJepeW/p9EUmUK24rcdy3eLMwEz9Z8sc7tIV5x9fhob3JbIRPRlzjf/nlLxwPJ2iWCns6pFKiFvm3fQlxB106XJpDGcINQISAHUTZV7mYr7PAoxxRqECYD9BrJ/lY+IEuUEBYNjgQPbGdHGFpHQly0KQaNbTg/EHmo+8Ls5UWS4pV0OMwNkyTW4YwzzFMd+TLKXLkYtkhsNC84po1tZbDC8vuu2FJdZA6MpmAK4PYxglhbbW872JyU2roojbEjMp4sTBcWpwxJ2jXHKT4ixgJgMY4dURrvDgwElzFT1WIkuD0+RefJwTMkHGbljRFgY262OKYBna/VSdRcBiStELYZbsNsfiEzxDNsHmiHyQD9wkDQYzuZ3+9C6kEvSk4S2DL91kb/siFyvZC+NJVilzqp7MSH+cY/3Tv8yAqDXqXXYgNcZ5N7muJ055nxd05Ad4/iiv/Z9uKwXVQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(47076005)(16526019)(40480700001)(6666004)(26005)(336012)(186003)(4326008)(2616005)(7696005)(70206006)(316002)(1076003)(478600001)(54906003)(70586007)(110136005)(356005)(82740400003)(7636003)(86362001)(36860700001)(426003)(83380400001)(40460700003)(82310400005)(41300700001)(8676002)(36756003)(5660300002)(2906002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:02:06.6853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51207a77-012e-4325-0a39-08daf5b1cfa8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8287
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

Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
not allowed in guest, e.g. because it's not supported or the CPU doesn't
have an aways-running APIC timer.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
intercepts")

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

