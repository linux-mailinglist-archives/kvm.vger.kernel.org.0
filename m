Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7D2277898
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgIXSmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:42:38 -0400
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:34912
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728772AbgIXSmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:42:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byWKSZ3+CybCuoQcgiFcbib4s3511t68yhoBujoXfVZPxair6BO0isCQ0wgQt8TzvooP3bGzO5VUeKdCwCzq92d7FohQGgspNHPIF+czhtCTGz/nzCyyMEClBBjchHH6K0o1Kk16VsxD4ea69nnqWQc5qpDtzqd4FTsneoz5ObXf5Is40UpbqClfVpWdJPYGVpna+SLsalIOSQVtFNVnT3/CRY08J1IXwDNQ59JdJFw9mf5keq6hQQd3q071sYh7cuIi8Y4IhvnfmokrHjhx3+j0CRx02kX4JiiIL9VlkuAXgFLQ85qpDmg9jmBayjAuBysCGo9zEJ15KP0BInge0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPHaHjIWGY2XNCbX010dUhazedC16Tvhi628J9+s9jU=;
 b=SKz2IBnboRzdHQPXA+/CPoVI5YQmSS1sFdRqRHO1xuvx0I2yLaWojnByQQEFzlHH/QItK41Li6qT/h851VQEyfpDM4SAAi/REwJkWkRZciEqWleKSnMzxjAc1XmV/Hne7rCMoRrvAMloE+fRGZxYPeMHlJqE0I7FxVbzz6q/uP13tS6zsu/mUE8MMa7IlwK9lJSY+HeCvf8PJuKJxZ01e8/Z4XU2bHhLGGqp3z9an1f3YGuSWzTLmrulU++bIJ9cXr1OffNogxnSJYdEaTXo6NgfnmRlEbnXRrtIIAiUcaXeNuzvePiGaZx4yHx3eelHkidkiLHYC/p4ku8lQlvb6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPHaHjIWGY2XNCbX010dUhazedC16Tvhi628J9+s9jU=;
 b=Q/LrgE8yiRBQgts1ePHXV2CtQE81r/jQt0c/0mFTyinmvY3eLcT/72ZiJmwu3F9z9qLF1qNmheb+AZi6oIYz5de9hzJSjlvW8k/ms4aK8rAxjY2YYbS85qbcs8OQaVR4KPj/WTN7lCvN69ArzZDq1GLjnDAJ/l18UBbTtSEWu+o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.23; Thu, 24 Sep 2020 18:42:35 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Thu, 24 Sep 2020
 18:42:35 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/2] KVM: VMX: Do not perform emulation for INVD intercept
Date:   Thu, 24 Sep 2020 13:41:58 -0500
Message-Id: <addd41be2fbf50f5f4059e990a2a0cff182d2136.1600972918.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600972918.git.thomas.lendacky@amd.com>
References: <cover.1600972918.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0071.namprd18.prod.outlook.com
 (2603:10b6:3:22::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR18CA0071.namprd18.prod.outlook.com (2603:10b6:3:22::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Thu, 24 Sep 2020 18:42:34 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ac4a418-f3f0-4c43-ed6c-08d860b99a99
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3082838258A0D977C70F6927EC390@DM6PR12MB3082.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3n1YYEIkKta2YIMUlUuvORGYFHqvE8ucUzdjg5K55gmRBPs6ZxTGmnGv1XshNTygDPY+wl2rYtxjfTRIqsrFM6nZwhD5s9p+eW+yfP4he00zH89rDhgeDnTQ65+VgJ/ic/WShwg9k/9MqqK43ZIYLUlZb/4fPRgMVRays7RgUJNpTULtiuSEOGPT5DQ1kvxRBSTh9yapWPGJI3qvkHjow2/BzeQDvaXcab3brgrOf4gPdIlnuPXhT83u6/SOj15wZxwDX7QJVApiRIJy3sRPPuTGvutZNE4/SGJ0iuYa1v1qmNl82MDoab/+cQ+cR50Ahlh7kjVUqy0EHszkSRmFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(7416002)(83380400001)(316002)(36756003)(2906002)(956004)(8676002)(8936002)(66556008)(26005)(66476007)(186003)(16526019)(54906003)(478600001)(52116002)(7696005)(2616005)(4744005)(6666004)(5660300002)(66946007)(4326008)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vMnwa+pP8YEMwZGSEW+OHBfYhYJjOCcrI4EuYJn5AutU9zGh/FaHMbjbmERn+Za1CQQWb8BIUeHfRd9g0ERyHo2WOtdqaR4yhGgqY4AdnZEo09InSDcVsEa0+xp8K0RmMUW9f2ZqD6AL5mpSWgq0Jh62gxdBDcPp2GJ18VVkdc/gLaL3RvHFj/Pj/N0tMfcJA1o1MQ2KA/dmEpyyuU7LwycK8MK3cjXg2pfxVkQrjgra+9bwfZRw4C+8hhdeO7lVvgRq8PMTM8dnToCB5QUT1fX+agr3efmAMzqeE0D7cXkj1VCyxiDzMR6vJGC+JyLIppEcZju1UQixTW6yyvyV59KbKYmIILgJNJI2gNuneu4wzsXKiymLeA5bJIhB+uPG5uMzdLLTcAtvLzm8qgO1k7gSF1n7ErSzHEwFNaSUvj5hM8nV2lrocz6nXpV4KBOPA/LYG1PZJfANohcQaFnub6O8seKqxfkE0v9Gg8XHDzwQJ+CN21J7BeiqfakEmdw2mi64K17XX3BLB/p2aaP1xraii0Rre2C7Nnowg0yr+T+IztZ7IQqzBdwmK1uahYA35tNP3z3H/XrAz+o0sIKlR8pPt9unZpi7dNCkkeA05CtYDBXj2uxBM6ovV4d0r0HTg75FMW3rfwrUnQigvoxlAQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac4a418-f3f0-4c43-ed6c-08d860b99a99
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 18:42:35.3729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd0p4hcb3zpEO7/K3CqTqgG1cMck4lWjcqDEmcp4ZIO8nc8980wdZ/KKuWnTMo5E4vfytBCeI2lZcskAiAc3YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The INVD instruction is emulated as a NOP, just skip the instruction
instead.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8646a797b7a8..f8075d3acf9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5148,7 +5148,8 @@ static int handle_vmcall(struct kvm_vcpu *vcpu)
 
 static int handle_invd(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_instruction(vcpu, 0);
+	/* Treat an INVD instruction as a NOP and just skip it. */
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
 static int handle_invlpg(struct kvm_vcpu *vcpu)
-- 
2.28.0

