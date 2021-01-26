Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560123037C7
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 09:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389866AbhAZIWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 03:22:33 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:25316
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389821AbhAZIVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 03:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNm33xQn4+1Gl/skC+PHJy67fhPiOAUTPMWapRS5leYBzHROgdmvfrkaxbjcpqVoXlx3pnVUifqmhamuBlIPaAPOZzsAzFD6IuD9roE4RWe8pLepgICabAcvjTdwzyHoT3ueJWhfP7I85UbdzaQsc8Pqc5aM0aBo3bxjMwOJi+LEoPriYgdtmuS/x6TtmUl5Z8XZy2sPik33ElhA4xWAW/bI4wxTHWSyvBJND/nvAZX+xLt4reWugcsGhpxa4YsCV+QB0Wv+oLjAgqX7OeVpPZMXeHzdr0KWweqFqtNsVIAtyD/QVt/XdBf+0+o8AMNYLyR8fo90sNgOJc+9k6BPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+EfyfvbBbxfG5O7WsbON2wDUb1GxprlsMrDPCdarHw=;
 b=lMIPwKP4AFXXtqOH0lz6HRoAaPkR5o6iAaZnMkrBw41h40m//IxDcpQje+tVSr6RSEpYdi69YE03RqYQQlZkpgLwFkKV0hoXeZxhSzV0ZiVLuVThlHEmVsjC9Vt2Sf/rFgM0j6n8XoZfdrzFrpcWk9MN7vBnMNDi2hwIBk4pB+Z6WDn1VXu25I1+g6dMie4ogMl1RXjDTQivEsIzhSoEft8dmwsscZg4DbUIxrXBqoE55RRqevTNmsjGcpUFrRnQQFVOdYUPI1qqWf10aZSMuJ42H38n5nQBl7B6aLnxnk61GTava1KylMT3X5rzdVnOb1gg4QImO6I00AqZlpGV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+EfyfvbBbxfG5O7WsbON2wDUb1GxprlsMrDPCdarHw=;
 b=KbZSc0hx+u5+Ag9D4lkddTHhc32rqKsXTwCgcCfef8UpU6jHb6CeMBXDkWqEbJyqS8/TB0LiD0+o8UcVJFJ/z33KiVBcrapB17IfyJDVMs1Qb0jl3RuA9QJgFh2nLpFForvG5aA8VeACANgTd3jHjPezxJq1X1HIdrJgmfikRes=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 26 Jan
 2021 08:20:09 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:20:09 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v3 4/4] KVM: SVM: Support #GP handling for the case of nested on nested
Date:   Tue, 26 Jan 2021 03:18:31 -0500
Message-Id: <20210126081831.570253-5-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126081831.570253-1-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by AM3PR07CA0103.eurprd07.prod.outlook.com (2603:10a6:207:7::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Tue, 26 Jan 2021 08:20:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94d8a1dc-8700-486f-141e-08d8c1d331db
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0214900B016AA27422269819CFBC0@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swZVtBPytWuUnFcn/hyQz2SnnWmVhJGtkWknPnZiKlwgkeg7nfgq6pSsx5UI8iaV57pbsyNxgXp1ou5JL7f0/8cpmoFeBYyRjc7Rg8Xi1Wvszuq6vLs9kzamI7IpNrzACMNzMpjw7Hojfupo+c+tOKPkBPqIk17vT9vQEYWzqD7DpoBin0g9g8k4d+NNDOCjhzz3pCeR8Tjgn7i99DWZ7XznylaHVkIIQyGK4icw5fHbhMzuQW9c8h9iWZPIhw1fvqkYr+WeJHThWVodfMIdebSdE7LNDIzbO9Ab5IPjrZdg+yFltrLiVyGopOrdiuE0T4+28eo7weY3g9Aw8z7UBaTnttzo6tVw6SSUTH85a84bijTVoGIK2FFFZB4XMWfkYCytobwsgi9ajk3zGUo2vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(36756003)(66556008)(6486002)(8676002)(66476007)(66946007)(52116002)(86362001)(5660300002)(6512007)(2906002)(956004)(186003)(26005)(16526019)(478600001)(6666004)(83380400001)(8936002)(4326008)(6916009)(316002)(6506007)(7416002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IZOTI3kJ9g80AbBeF5NGtwyPkoAtxc5e7id5gezxvl9KtPyMaCIhJhX3njO1?=
 =?us-ascii?Q?u3dQh2IA1X4OE5Ij59k1t8fyxdL2QgwIMatir7/4AuOuYpF7am2HzyQ4NsgB?=
 =?us-ascii?Q?snpiBrccjozUIpUx2qVtHc0dNb63tnit2INJf6rzyKVrA1JTIoTOfyW01vSt?=
 =?us-ascii?Q?++Kc2niF6fOjtU7PeKSi1HSfWqXJlu4WrSVtHHF1QvTQJLKFSvDn1APKiSnF?=
 =?us-ascii?Q?uv/8d7xDm1K7X7Rg2t96Jh0tpY45pY3/AWiBYrYTHBXYXdRrjHsvv692bwOo?=
 =?us-ascii?Q?ByMGMkYI4yY4xFxw0bAH3d/heMGk5EwdjfQW1tirY2QRmh6ifVP2ljUNhPRu?=
 =?us-ascii?Q?NQAbQC7bl35FAes6oRIlm1oYkW/Lv+m5AS2RABe5ANZa2LnZr/rc+A2umt9V?=
 =?us-ascii?Q?B9GXfGDdqEx+Hyg/36qVGXDdeM3D0DHeSIkRDo/rqGTxJpnaF+KYqg2aMbuO?=
 =?us-ascii?Q?l0dZym71KAZCIz9hWeOIDguC4Hje8MYQOSVzsx4fQXYLG3srgh6uHhNdJYGz?=
 =?us-ascii?Q?lo/tjq++IQEb5NiqkT5DPxF5Bt2aUk11yfTXpolLUR7tlmHMf6kGeaST/JSa?=
 =?us-ascii?Q?7oONS/VwGCpBlO/qR9FX39fnygbDwxwrSQUd+7EHiUlZLYTXblBUylwSdOo9?=
 =?us-ascii?Q?1CehKZ0Jw1ZGM+w6uzFVgPcMWTAShMirdX371s8DocpE4M7+Y8TnwR0HD3WB?=
 =?us-ascii?Q?2Tz2LYqjnSDiLjN0ijLaeFZzY46JXaHmAszw9IogHAwj4LTBjnWbPRvrv/V3?=
 =?us-ascii?Q?TbACYSr0h561KGUPmL2ROtiilNnWwjCURjb/XkGz8NBElp2FskPd6qLa49Dw?=
 =?us-ascii?Q?uH+BE6nPcahnVvbds7gK+1rcjY47jKzYQ9N4G+T3oJN8K6TStEJ9ErVWIW1M?=
 =?us-ascii?Q?er2vFA1GD0IKMW8TMNM3jZ24qbqnCMlgoR6zhBv6jxsDFNsWPMs9qeTnkcLV?=
 =?us-ascii?Q?DwGsdpNpzfICKYD0Kz8WRhDfdyvrjBhIxJu1+AV8GXfMtBDTMEqUvhKIWOyJ?=
 =?us-ascii?Q?2s8/vwbnerTbhGTPydcH26XxOTi2jBCnEnVvX5Y/HYRUkgcuBpnPJIWUIjva?=
 =?us-ascii?Q?UiX9u1u2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d8a1dc-8700-486f-141e-08d8c1d331db
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:20:09.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xq9xUEKYuotiS4rF/dfEv3jJbCNi/ocejCwuv+8vlhb+ybKVkaswXXyrxq5w4OjU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under the case of nested on nested (L0->L1->L2->L3), #GP triggered by
SVM instructions can be hided from L1. Instead the hypervisor can
inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
can avoid invoking the #GP workaround. For this reason we turns on
guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
receive the notification and change behavior.

Similarly we check if vcpu is under guest mode before emulating the
vmware-backdoor instructions. For the case of nested on nested, we
let the guest handle it.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f9233c79265b..83c401d2709f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -929,6 +929,9 @@ static __init void svm_set_cpu_caps(void)
 
 		if (npt_enabled)
 			kvm_cpu_cap_set(X86_FEATURE_NPT);
+
+		/* Nested VM can receive #VMEXIT instead of triggering #GP */
+		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
 	}
 
 	/* CPUID 0x80000008 */
@@ -2198,6 +2201,11 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
 
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
@@ -2205,7 +2213,14 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
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
@@ -2239,7 +2254,8 @@ static int gp_interception(struct vcpu_svm *svm)
 		 * VMware backdoor emulation on #GP interception only handles
 		 * IN{S}, OUT{S}, and RDPMC.
 		 */
-		return kvm_emulate_instruction(vcpu,
+		if (!is_guest_mode(vcpu))
+			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
 	} else
 		return emulate_svm_instr(vcpu, opcode);
-- 
2.27.0

