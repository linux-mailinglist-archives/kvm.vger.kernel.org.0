Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E7276211
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIWU2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:28:09 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:11872
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726199AbgIWU2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:28:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iC6hEjYwES5xsXcfuOU4nDpXDY+uz0laV7XOsf4NIRywLbRxe+P/cYW6n8eL5odKKt9KChOIS+Ejxm41rfdZkKNvJ2GsHkS7ptPsRzfkuaVKyOm4q+5gHsAjLfDq9LsdaHoMuvul3f+280D5e9ZH0YuTNf9PqpuXGjc0c4K1PD8Pxx+YWWw+4Whdq6jP4sDwZzAp7up8ui/8vVpI12f2MN1UKgVGHB0tt+7+iSMV6NYCxnQUzDFUyUMD8hoELsRqIje7ZSNvgxcUCGE8frHzgw3sSu/pTF57ubG1nBa5n3PPiD270WRD93RdY62QH2wq+EQ84vs+laYAyoO9Lcv1pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4loEgnr+Ig69yh+8W4ZGfx8KH/CpACJ+X6rYNjh8s0=;
 b=Jg+oMX9sQ02PI1TehNNZqKI4c8CAQONY7ibi86wQvVbW13iV/4HOw+rVCi/DAVO3YyRsvu/H6inEws4qQFSLXfGaaElALuVm1kXaLf8LMeFVZTIezovOntH/ClLCYzJ1AQp/djBGuiOZLX9+I1Ve2eMUtcyxu2wPam6AS/BPd8LgJ1BYC3FaDjBZNS5P4AXVW91nhVJxgMFCcmRsqzKQuQ1sdl3AAlpYlmunU5f0zIyg8YR5ZH+RdCrVMwzAEHC21iK1OmkeXiSNSH33YrGTQm+Twcg8bH+Lh0r8mUeTp9keUsLofzVjsCtABpsLA7XjKALKLADCHXJjo2n3umN7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4loEgnr+Ig69yh+8W4ZGfx8KH/CpACJ+X6rYNjh8s0=;
 b=BH8WJGLlewOzkM46xgntAYexK2/sv0Pa/I660pBC9rOqX6lStR3fpovyiVDnmOAHu2ZHRypFefaTJuTyqgLxtkZDUkZY1VzejZM2Y50N8A0Pz1flAoRORKiFMhfDxB2TI8AFSlDjQbG62axmasxFHBT+i/DbMquanoztRmr5z1I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1451.namprd12.prod.outlook.com (2603:10b6:4:d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.20; Wed, 23 Sep 2020 20:28:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Wed, 23 Sep 2020
 20:28:05 +0000
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
Subject: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
Date:   Wed, 23 Sep 2020 15:27:39 -0500
Message-Id: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0066.namprd05.prod.outlook.com
 (2603:10b6:803:41::43) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0066.namprd05.prod.outlook.com (2603:10b6:803:41::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.15 via Frontend Transport; Wed, 23 Sep 2020 20:28:03 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9389b83-25b2-407e-4a66-08d85fff2cdd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1451B87A119CFD770A88665AEC380@DM5PR12MB1451.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eja95YJxMunuaKuLdzCc0Gvco/g7cu8YAln0UJWUYIiCtctvjR9XEK0Up717ibg8VK1mJY9nzWcFpHSNHIyVuqnMIRaI3426lXiAKOJbRbu0NxZKOtrxHxG6I1/aSh9izx6CVJF04Z9DwhVn0QKC8PUFD0o1Y506mNb2Wx68jEaHPn/GueChZdXHcQtY8avVKNI15viSn5UDqCnCy+/J1ILowOPQp4DT00U6qIY1wHL/1vo6SzHNB7RmK8N3W6lP6ykSovauiqmtXoukKI23SUNHEReOd8ku5kPuuYJLJMgm78MyJzNVcf01Bt1j+eFvOfYqq52EkpE3OAhrzOqMbUULsf5UevLt5XNXNp6MQesyoXw9E7CXqybmhUL+Kc68
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(16526019)(8676002)(2616005)(956004)(186003)(8936002)(7416002)(36756003)(4326008)(83380400001)(66556008)(6666004)(66946007)(2906002)(316002)(478600001)(5660300002)(66476007)(6486002)(54906003)(26005)(52116002)(7696005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L5MZLM8InWyqFXAOpAIuMfEwYm8n/mXUcRmBHOY5kxU3ii9nDcWO/p+5i96F7+Riu9bBa6z9eV/8ln2s7wI5NX8+z59MlEBZcSbwA11fDjkakTRuV+3vq9Q3M8HyRqtqJC98EYBPXHDzNy/2Tw8qnv1oABojKXlupejYGBSD3T6R2SjTr1NFpDtPJebIl3gBPLR3V9e+StWC/+x46qnopUrbiYZG2KLCUpnMzo1SSSxL2FO+hEjRpfXji53QZYZRfSjCp9ajwvRZi75z5OlRRtYA1vRvrRFqDMrI0hZZ/lOfp9Fpx06yYwZ39vSIjZeF/fWMYpXSo4gFJASywYgKRJZVPAUJlq/WEe6bcyKdOkwPnTrf08ZhxCOGOPTqf2JtTztSouub46XncU7RozqJGzVzIj4nQXhe9m+nT5y5Z1Z/pG7bHOuiuqT5Aei4xtMx2bfmnQDDuzDHZK6WVBJ/T+4gNjX+iNU96OhpEK5Zw6MV/LxJQSEFgwBpAA7n0/iIq+7V1VKdnIqmxdd8kzyTNbIsMUlIN2nG/GjLkE8dLohMP4re8sAFGGdvh2nF8gx1tsErcBovbl7kCCWTL0wCb5/JyhmEEWhxnasU/vG0MLp1Wt5YhNSjKTmNnW9sUBPEW/c5/9fdlJTxiODe6apevQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9389b83-25b2-407e-4a66-08d85fff2cdd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 20:28:04.9483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7l7PYWhxPtmMYcTtn9tIQTstl9c3lRy0GPPLTYg6kT6vomnPAVocjDiCLeCYcaj6mE+TY2XJ0y6miAmefBKww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1451
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The INVD instruction intercept performs emulation. Emulation can't be done
on an SEV guest because the guest memory is encrypted.

Provide a dedicated intercept routine for the INVD intercept. Within this
intercept routine just skip the instruction for an SEV guest, since it is
emulated as a NOP anyway.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c91acabf18d0..332ec4425d89 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2183,6 +2183,17 @@ static int iret_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int invd_interception(struct vcpu_svm *svm)
+{
+	/*
+	 * Can't do emulation on an SEV guest and INVD is emulated
+	 * as a NOP, so just skip the instruction.
+	 */
+	return (sev_guest(svm->vcpu.kvm))
+		? kvm_skip_emulated_instruction(&svm->vcpu)
+		: kvm_emulate_instruction(&svm->vcpu, 0);
+}
+
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
@@ -2774,7 +2785,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
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

