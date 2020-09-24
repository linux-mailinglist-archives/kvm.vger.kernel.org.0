Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE6277896
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgIXSma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:42:30 -0400
Received: from mail-bn8nam11on2076.outbound.protection.outlook.com ([40.107.236.76]:61492
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728758AbgIXSm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:42:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hd8NWbnWpPJdV/iIRuKdSNdNiVJzbZQh0ktUtICqdlVaUv8N89tjjw9RlgBq4qOqYrs/CX6C0fyht+QKAOxdttFD7vXrncEue0U3ab3EeSV+VUYb4q3RL5ksaqCH58zGla0K05SqhsUBJioB5Gv9V8Sa1rFCZ8n03B5xm8ZT6qkq16k0/6vFaL+8izoO879F+ScNX2Za/hZygj1eYSubj3+rq6XAczHC2Qp1AtVl3BQxQdARbzA/N1h7RATef0qeVBHRUVvXy3h2/QYZ7UYkQLu3F0cfLgXGQoucmBrofI3d4NE3KlVu6EjOGNOCgw0BWxIwokFjL+UCqsUISgT6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wg6pImjmqhbxekmy4Snhg//pL+oxPOo5WsVYxfSczAE=;
 b=k1WesKWyaAY7lphl5LUEwuQ2UIpTcOcxNQ5QEvUu51ZFsBBvivRR0wIRqpfAwPtbYGAwTjYlAqkrp9s/iSpBdD6cWQ1prP2YKuxG0gKTjX+mrGd8KbRu28Fps0hjSolSdcidjhg5styDLC16wnyXRYsT10CKfeV14KKt2HVkfGGzpDslV7tgYejabHnpEtZt37ByOsKXxxdk93N7ODZsSxr/lyJlGi68dGPO5797S0P+qRHO8QVbeZIf+sK6KuG6XNczNXg2ystDlaiYZZWstO8rTLqrM9NFKQDKVCpxSb0+lwYjD3JUHbl/qb3LkfsIMy9W/e14bHca/VBk/+wHzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wg6pImjmqhbxekmy4Snhg//pL+oxPOo5WsVYxfSczAE=;
 b=mMGBGiAlLctiIM6nukepp810LvgqTyQNhTRcz0DSZe1RvFQAn4UPmGQ2+vNEzxT09QcErUw5FSurwDv2pC3J0fkzrhEZrHKnpiGT/u8aoAtL86cGaYyMMjikja6TfbLbJqDfFrLmJFxVewUkIWAaE15RjoQa+wAkLaZ//it+SWM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.23; Thu, 24 Sep 2020 18:42:27 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Thu, 24 Sep 2020
 18:42:27 +0000
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
Subject: [PATCH v2 1/2] KVM: SVM: Add a dedicated INVD intercept routine
Date:   Thu, 24 Sep 2020 13:41:57 -0500
Message-Id: <a0b9a19ffa7fef86a3cc700c7ea01cb2731e04e5.1600972918.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600972918.git.thomas.lendacky@amd.com>
References: <cover.1600972918.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0056.namprd19.prod.outlook.com
 (2603:10b6:3:116::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0056.namprd19.prod.outlook.com (2603:10b6:3:116::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Thu, 24 Sep 2020 18:42:26 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14d98264-5adb-4e5f-479f-08d860b995fb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB308279B67D28EB15A3CE0983EC390@DM6PR12MB3082.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQ0uAnevC01XHzRv+Sp0Xuz7x+7Cd4w0G3ZvwEzdgXZVc2xtuF2z/yvgGW3/egZCSsITEWsutOrVfFusAu+kV+LB6gSGiHTnpnua9mrodoXygbcmYRmpVkxFzv/NKxWClNgNozOpaAoGjrFy5Phk2kk2r8aepl2rM/rv7yFUfnWC7XqS8vV5z3QnC0mnjhGoWby5sPN8Sdvq7+BdaSP50aHx/nXBI9JcSrQFn9gTfBR19xfengrUl1L4qzFPoprSsHcz/w9lGrtAYE4fsp5SB3h3UCUbYVBmRUynOdHC6UhIoZc7OfiYGXzzeOLm6/6r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(7416002)(83380400001)(316002)(36756003)(2906002)(956004)(8676002)(8936002)(66556008)(26005)(66476007)(186003)(16526019)(54906003)(478600001)(52116002)(7696005)(2616005)(6666004)(5660300002)(66946007)(4326008)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IDRPMiyBUT95kJO9prunBqP7HkG5oSMvG7kYLurImWs1dtRZ2YIpX9haPhD8b1k4sUtJHVIekid4quqS0Em0nDqIBkqTrqVRE5f4+zz2ZLtNMYib8nIom0P4hdVzx0Tlzg20UoWfMoQVLPVdAPKtR+PDNnSJ+lsG+Jp73Mo1X0Q0asnY+eo5OHLuzIrzSRnd3BZ8FR0F4gKNFLlF0UQWmdFLjC5g2iHn+bn3kDnLpJ0+MwDiD5M6bpYlE/saLLCMxvcxzFdjWdG6vMgide6oRZehre2h5x1/RwyY7Q8fMBuprBZjnyGLadA0ZExC8ND8JKLnFYh7Zxy5plF139uQpOucSDx0rtmB5JT5c4O1gLpqECmnKdF+rI6PApBC0xk+w4WF3lSKwXPLFvb0oN3MfTDYBlAZz4LspXIvYWw4jWCDZPvDEIqcqSu+9VJJdW2aB1WlQqMDHqOzPQHlpcKvEXlShdmHU2i9i1PXXMKVdFDl+3V4iWLpx2ch6X7xrdHu+sqFEQ3DsNHTkUU6jTJCuYtYjIXg057uYKZIRtKIghggy7cCP7zESRnE9uIsbM4qmrcpVVvrG0eDQ//8MgIZp5sZmSynNodegX2z8OQdelc864cKAK5gVYJy2xwCl5ziUVlc00YXf4y/55vJ4g/EXg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d98264-5adb-4e5f-479f-08d860b995fb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 18:42:27.5893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNT53ouGahqYcYf6Vl56HPIPYHXsAyvmMCG9sJA80Cc/VfN2v55VoRI/sUi/TA6IMcosDidOxfyTS9ePP11OCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The INVD instruction intercept performs emulation. Emulation can't be done
on an SEV guest because the guest memory is encrypted.

Provide a dedicated intercept routine for the INVD intercept. And since
the instruction is emulated as a NOP, just skip it instead.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c91acabf18d0..66d225899781 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2183,6 +2183,12 @@ static int iret_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int invd_interception(struct vcpu_svm *svm)
+{
+	/* Treat an INVD instruction as a NOP and just skip it. */
+	return kvm_skip_emulated_instruction(&svm->vcpu);
+}
+
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
@@ -2774,7 +2780,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPMC]			= rdpmc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
-	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_INVD]                         = invd_interception,
 	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
-- 
2.28.0

