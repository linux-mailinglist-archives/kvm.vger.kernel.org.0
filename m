Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7BA2FE451
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 08:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhAUHsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 02:48:04 -0500
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:49574
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726532AbhAUG7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 01:59:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X17WqyuVhdF4opAaYT1QnHJVgb2bodBU86uvRYPv0nD6yc841OYPI97w8UrQGXj4LQ2zb5AKbmMv5cON6SBcbH4BIwze88vxawMe+2yWDiGfkTbXRLrn06Hr3KtkVn/ATe9rlNciCuY2A+AfYRaDsVrYcmpixhjdvBs4X1eFUqQP6l4caw3uE7bYChz+HGE47mjxGM+Qsh9i6Tjp3Kd5N6hgdfHc48o1g/MZmcHpOLvgeN40f2j4Lk8FsBMo3RLgGP9guIf7/oqxmfLoncMCW+KU6Aoow9ySLdrLv8XOF/GSMAXIjRHR+i7i48ip7CfTwbbUbVmVd9NwEduyEHwe0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpZJbAn5nhbRVpSW2zl+vZ8xxubU+Zyp7mbDXO2XOHk=;
 b=gbVGkfJ4a/WiWI1e2E1GLCxfLMIN+oa0K+O4ftHhSY/QDnC1TYMGFDYbP6CfszZmsp7EiAO7ZhpB7KhMOVCJmsa0rHHzVSd+6vFVgKWFXd+becGs3GrIXfCxhEzqEYt5MPmt/mlTJG+V4JvgU31S4s8aEewIdqVPUKH6fL566f+8yCVEMTq/Wl3vwoM87MnI3g2LvzgBFms7MHqEy+xW3mFIHSPn36UKTTheb4kMJ4ez8p9ThGEViHs/nT2gYp4iv5TXCR9TG5ofdNbLGR1SSW5wmdAxBI92l+DTwnyJudUVsIfRXXdC8TMKh2wtptvLTFbLcsBuWIOb271HfyGiNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpZJbAn5nhbRVpSW2zl+vZ8xxubU+Zyp7mbDXO2XOHk=;
 b=O3JDjtxqJhrai8IZM2+2STqtCmUh6UutF8KqvD/ICVHG9bVoV10mTB9XeLySV+4C+eWhG4bZPfvBVKSMIpbwSBqr0PQyKWT0vL3FD2SmK2luuc4mA4ZqDaFRZ3iEsawgJ67vCt2mWcDGk7SSnezM/SJga4F28HyIilTxoSAxKeY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 06:57:39 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460%10]) with mapi id 15.20.3784.013; Thu, 21 Jan
 2021 06:57:39 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v2 4/4] KVM: SVM: Support #GP handling for the case of nested on nested
Date:   Thu, 21 Jan 2021 01:55:08 -0500
Message-Id: <20210121065508.1169585-5-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210121065508.1169585-1-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To MWHPR12MB1502.namprd12.prod.outlook.com
 (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 06:57:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44cafa43-dd60-4acd-78f6-08d8bdd9d783
X-MS-TrafficTypeDiagnostic: MW3PR12MB4441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB444157DB16B40FA78F934C7ACFA19@MW3PR12MB4441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KA5M6/MjHh1DYfe3y/oc+A4xhfYXaFl2PYKXc+C3X1Hp6UHCzQaVmTzT8yqptMRXsf2i/QQoBCY+rbK5sTKJnxGRkxZSR37ov+D7gpT9yhdgm4yDo2dtUDT1Sx3UJhQ9Ac1rpXMtnyPskQmCQ7+Mlx+Id0PPBcuqPin1YFh2tfIOrxbRyMwsailPup2kRkrZNNmCJ35EPPhnRmX524oNooqYBv2QeJVnXEr2OqpQmjMs84FZfcytVLgu5cWExyrwm8aesCB+JPC5zBjRBzS8GTBDxyuDx9Xel6GbqP0DCCdb+uwAfTghqH3D70/I51d2fU4ccDZtZzypeEm2DPbIXEHbMqyonyg4PJmvRwVg3RxwjvUjtBpnt+g7dvLu3U52n5L9GSNe4JhVt83MNTX7Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(83380400001)(52116002)(8936002)(86362001)(6506007)(66476007)(6512007)(6916009)(2906002)(186003)(478600001)(4326008)(6486002)(16526019)(956004)(26005)(2616005)(36756003)(8676002)(1076003)(316002)(6666004)(7416002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JfcuitQJ6lACGOLfBwQUNvQX6uWpFbdn5iZqnckYp8FZdrZRHl6REJFo+4bO?=
 =?us-ascii?Q?hmZbcImR77RBuCT9ru1sSWPcF1hTPJpchsB3oWOKeWPKAj2I3rxM63ffT29b?=
 =?us-ascii?Q?z4fwuEBaXiyIDPBV+ZR6GKwMZGTrVRDiyZHnLThWAu+Wsz7zmCZN6lLvbuBO?=
 =?us-ascii?Q?hHSsUIyIo9GUkiklBsedY5OU5V3P7bKUXaxSLUy/eAiJunVLnJ4Tr/TesW6p?=
 =?us-ascii?Q?ruNllONqbdaH47ruu0rGoWxm68xLVtf6P4xtEUQfnElhe+F/aumEJ7EtJWiB?=
 =?us-ascii?Q?MXnJKXk16r2613NfMUcaBZQZSPf1ohRWkMUThk2qAiMOI64BGMnGAXnuGnUU?=
 =?us-ascii?Q?OEavXiBwg/eknKnJxpHOBo9h1Fs/UHW4msTVHb4cWXTvpmFPUzPXRKiOtA98?=
 =?us-ascii?Q?b7J/qLgb6T9OrHUY9yu/0FLB/reCf8dYqFy0WDoKAukrdigE7c9BXIPYonBT?=
 =?us-ascii?Q?CTI5NEqGzrxz7AhiJNVBEFyPRf/5OH/ICGcnnUDouLx9S44H4wIcvRITFBCr?=
 =?us-ascii?Q?sq8bcEfbqRDB09eIe4sp4RUQw1peBalmSMk6OQQvdH2ajYKKPjzbYSEYkB43?=
 =?us-ascii?Q?ZIjLwcyiROEIEuYwdwEFLyFcR1gqVfk6/QMOTo9b2Tn1risH9ADjW+qI07QJ?=
 =?us-ascii?Q?QOHGrwM1G4ksZ1sIuwdKwGBdN3Hy+h+bb1zQ7M0sGVlgTlmoyI+8BgKMCKcI?=
 =?us-ascii?Q?0jpTU89L2vGch99rXKX2P+hNEZYS1zL4FJNkS4U2XhFdNT7/PktdtHBQxWWo?=
 =?us-ascii?Q?bvg9VZUAr6TIVlN5k6p3nhDWfxcV12wQlqkK8VR8jAgQ6wZq9pjvLaznYJOa?=
 =?us-ascii?Q?8ku3EVcs1C/LOlsPoEkFDg9g8+Q6yGAewmOdZ8YBosY0U6croh31sZ+1J750?=
 =?us-ascii?Q?Zo1DATfdVUEfewsiW2vCFliI3XINjRfqKaf/olXHqX8lMS3jZmJAXFn4ntwY?=
 =?us-ascii?Q?d/bftRqlokPQiowJSptCfud5P8Wowp3+6bn7boUJ9+lOnTqO1nvHt1jWqSy8?=
 =?us-ascii?Q?x8ay?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cafa43-dd60-4acd-78f6-08d8bdd9d783
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 06:57:39.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdhByhlkOavzS8/NM4AtR4kTfGwbdNCENBpCUvLRYF+OJLTUp3pwMMOtJsKSxCSi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under the case of nested on nested (e.g. L0->L1->L2->L3), #GP triggered
by SVM instructions can be hided from L1. Instead the hypervisor can
inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
can avoid invoking the #GP workaround. For this reason we turns on
guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
receive the notification and change behavior.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/kvm/svm/svm.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2a12870ac71a..89512c0e7663 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2196,6 +2196,11 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
 
 static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 {
+	const int guest_mode_exit_codes[] = {
+		[SVM_INSTR_VMRUN] = SVM_EXIT_VMRUN,
+		[SVM_INSTR_VMLOAD] = SVM_EXIT_VMLOAD,
+		[SVM_INSTR_VMSAVE] = SVM_EXIT_VMSAVE,
+	};
 	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
 		[SVM_INSTR_VMRUN] = vmrun_interception,
 		[SVM_INSTR_VMLOAD] = vmload_interception,
@@ -2203,7 +2208,14 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 	};
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	return svm_instr_handlers[opcode](svm);
+	if (is_guest_mode(vcpu)) {
+		svm->vmcb->control.exit_code = guest_mode_exit_codes[opcode];
+		svm->vmcb->control.exit_info_1 = 0;
+		svm->vmcb->control.exit_info_2 = 0;
+
+		return nested_svm_vmexit(svm);
+	} else
+		return svm_instr_handlers[opcode](svm);
 }
 
 /*
@@ -4034,6 +4046,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Check again if INVPCID interception if required */
 	svm_check_invpcid(svm);
 
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM)) {
+		best = kvm_find_cpuid_entry(vcpu, 0x8000000A, 0);
+		best->edx |= (1 << 28);
+	}
+
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
 	if (sev_guest(vcpu->kvm)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
-- 
2.27.0

