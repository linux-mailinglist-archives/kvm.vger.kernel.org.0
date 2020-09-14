Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D326962D
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgINUQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:16:54 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbgINUQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgH7ZTaPrlLlByisU/RzOOZQJRf3LaKdgo6/zFAld+Y8HLnRtQYIJE0fkjCZgBv06DGMsQIUkJWhIZYOxRqDvW25iFuIbwxzcQyvUN7dFpTi42A8XYHSs9IcOOrtCERUfCbx6GYV5wkva4y0zRzfrV3PIbYL5aSg0TH0J3FinG4bPHXAO5wqY4BZWfPu0+L8NR0bV5IsaahzuRcCc9ftOJ5mZFjdmoQt3jC2kX5Q29+LpPqJjSCdtHDZUwLQEfG1UspGEtQE3B1yvXOa0X2hP6Zruo4bB4c8eWQVVl6wdss4AV+IRghJ36YxrYAuuNoV2IgqoPduRmoA7w3qmjJjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+nev1brP7xkbgiWggPjnexnEoGQCI4weDEpYkPypOA=;
 b=RzNPqcQgeDUh78m89QW8YdPzyWR39wFSoXndclJ79n36/pSX0aj9f+/8tTrqMiuTO3e1/QQCdnRzo8n17fEEE/xNcxCwLH/kTFRJPX65ftGse4zITL0p7ykBV2FckoDXa12dkCaVoQNYYNNfP4vng1x4j3FpMh6lA7yN10fndM9eHpPqU/c0/zihVzBLw720INJL1V7flwsC1UoiPrIR+ov293T+CSB4ZATNQ+Vc0rb4shjTg+qRSfzgGmF2ulTkwyrRq6bP8Q7gtpMbuQ193Km7xuYhIcqeGfLPsgGMc2E8YbTYpoxfz3MBw21GjUyWLygpv7yj4DDS4InBRvJXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+nev1brP7xkbgiWggPjnexnEoGQCI4weDEpYkPypOA=;
 b=CSCtcizW3obHpZy8nSrujHWPzxMPvaXS7FvpWbKvFID7lqE5iOmUqIXV4jZKIxUDTHF9bhc40b/83Zsp/NZ5q/coRSyQHAf5q0nDJhl+VrRHAxzDY56L1G7wwXirO4ud3Zd6OOCSS6eu3E5S5seg9sDSFg8N04lK6oBxPIFUdBA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 04/35] KVM: SVM: Make GHCB accessor functions available to the hypervisor
Date:   Mon, 14 Sep 2020 15:15:18 -0500
Message-Id: <9776d4e2d20dd3580cfe070b60977ebf0707b5f4.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR2201CA0015.namprd22.prod.outlook.com
 (2603:10b6:4:14::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR2201CA0015.namprd22.prod.outlook.com (2603:10b6:4:14::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:30 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 106f6e15-f3b3-466b-91f0-08d858eb11c5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116328F85866C6EEB6D3115BEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ez9/OgMXuO3g4/D0wM+PTnQIRbuwIs7TzDgB264A7xixruVrTA2j9vaIaZJqzQojeEQpL4NDrqB1/I9yeUT5XezMrGnj9wFHxC8k5KQ1Ml1DbR44jc+s8frHFS7vgu+gVQYPjfDVBwqQDtVw6inwbPG5OQGJ+DU8sdav8TNSXy/3QLSVlF4D3nI7l0ZbBpWG1nth515DYeEb1MnVCMuJNWg65i2eAM8x1oartWKo1okdgJpI1uvGysoLoohe6KZylyPUrq/126UkfgDhZVVQbEIJT1zlfW1IzNqkCpyBKTiz5dbpGasG03C/0+p03P0MZyAiox/nIpaKTXw6PKeRwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GBSwUkQSF7G+XkOrbj0ZbcY7GDPpsT9m5sboph6fY+i6Y5oso0C68EC46UpJS1lxF5eMi32hXawtQ3QfH6SuZLUuf8rGYrGHAj8UzYFBxTuvvR+3GRTcRTAYXwP1bCNsphR/aXE2vPE/kRIkoB4+AVkzzQU1JOE5FUMC8F4yGaT8jJ92CpyUkEFxhj5DHdsIYXuMsmbMofRitYwzMn5KMLccfFr+TAOrPJWqpqICxW5Rzs7c2i9hzpZaZC6jdUc8ocNTl3VAS5TKWrZcuQN5hWGwdZRWA3RJcPCGYTRGKfZO0uUfLysw+rWRk3LyZjQlTOIfmKigXk1qIfWrwTcr63J7/6E9C8+sb/g6M9wB0pIsXgu9snz/aNJp2JBmgZHvk9uTQu2IhitOaqZv3RA0GzZie6SJCcv1N4QofGatcRB5D/kKKq8jWFA8ZZSCnleXAxJaodwzO7Ve/jjk/iNhwfSKM8rTa5xLNrSr/XbhLfrY+tgSk8IwvBt34HH699SuDdDj+9/EDvcG/k3nCYeGdDQP1RLA5meZZDVoNXNrfZL/un+ZiwmNEE1AppOkFze2I9jTmUSlxetw4UfW6zsmtIab0ebFCqfQkLmpSa/g+cD36fZ7dylgR+YSKaOZxd1aV+854oMwsmn0JhPqrEAm7Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106f6e15-f3b3-466b-91f0-08d858eb11c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:31.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJofSMPA+DbPPV3m/jjcAse3a4g3RPxULTRy2rbpU3GfaK8MPoGm3N5IQNS8iwz5g8uBx+Y1lEOkLmENPStNrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the GHCB accessor functions so that some of the macros can be used
by KVM when accessing the GHCB via the VMSA accessors. This will avoid
duplicating code and make access to the GHCB somewhat transparent.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h   | 15 +++++++++++++--
 arch/x86/kernel/cpu/vmware.c | 12 ++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index da38eb195355..c112207c201b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -349,15 +349,26 @@ struct vmcb {
 #define DEFINE_GHCB_ACCESSORS(field)						\
 	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
 	{									\
+		const struct vmcb_save_area *vmsa = &ghcb->save;		\
+										\
 		return test_bit(GHCB_BITMAP_IDX(field),				\
-				(unsigned long *)&ghcb->save.valid_bitmap);	\
+				(unsigned long *)vmsa->valid_bitmap);		\
+	}									\
+										\
+	static inline u64 ghcb_get_##field(struct ghcb *ghcb)			\
+	{									\
+		const struct vmcb_save_area *vmsa = &ghcb->save;		\
+										\
+		return vmsa->field;						\
 	}									\
 										\
 	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
 	{									\
+		struct vmcb_save_area *vmsa = &ghcb->save;			\
+										\
 		__set_bit(GHCB_BITMAP_IDX(field),				\
 			  (unsigned long *)&ghcb->save.valid_bitmap);		\
-		ghcb->save.field = value;					\
+		vmsa->field = value;						\
 	}
 
 DEFINE_GHCB_ACCESSORS(cpl)
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 924571fe5864..c6ede3b3d302 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -501,12 +501,12 @@ static bool vmware_sev_es_hcall_finish(struct ghcb *ghcb, struct pt_regs *regs)
 	      ghcb_rbp_is_valid(ghcb)))
 		return false;
 
-	regs->bx = ghcb->save.rbx;
-	regs->cx = ghcb->save.rcx;
-	regs->dx = ghcb->save.rdx;
-	regs->si = ghcb->save.rsi;
-	regs->di = ghcb->save.rdi;
-	regs->bp = ghcb->save.rbp;
+	regs->bx = ghcb_get_rbx(ghcb);
+	regs->cx = ghcb_get_rcx(ghcb);
+	regs->dx = ghcb_get_rdx(ghcb);
+	regs->si = ghcb_get_rsi(ghcb);
+	regs->di = ghcb_get_rdi(ghcb);
+	regs->bp = ghcb_get_rbp(ghcb);
 
 	return true;
 }
-- 
2.28.0

