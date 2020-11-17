Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2531B2B6B23
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKQRI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:26 -0500
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:28257
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgKQRIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ikf14yj13scfpLikvWtaUUndAczl9zTZQiGLSlm66/v2otEArNaJqZFd50wFDL0s+B4ugK31KaS/HwdxLcCCU2Ov6IT00f0yfr2e3PSJgxz1P6eNu6bj4arugARNAm/Om0gyXRCqksk5GscPFxteAUg2joPAj3RrNQhYvZThzd+Ez87fqJxwro0eye4C5Me2vvldjuFJK7CxGWV8nuU76VNcSfh+0vuQU5yDeka8KpMyIg4AAXCyeO3IaSMW+Eky2/xK0IxPyI04eRg1CuT+4CHxcm+rbSmVMopKbmRW/YWv9Js4iszfBMkQKxnXO8LAynC3eFiDXeR17gjI85LGPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=O/X8Mdtj/2jboZGvF2CiEt/zuo7JwRHJFv8TnWk2pAMw1Qdpvu3JromtgljNyjJJ55HfImOnEq9kKroJW8yua+wNBSZ4GLJFGOmMPoXBuYMfwZMKnsjeH0hDiJums7C5FXyGHkuzW4bJh0AQS2Sj0ZciKNd6lkwxjtNtZ2VTMJxR0ql879/cJFMDYzBg3VOtKP0BTo96sRwsAl6zVCRGrbVgCy0aa6TbmspQ2Io8gct/k/J83/JLke3mMFcHm/B2Wqu+EG5LFOUsT39QYJSdBB/OFnXAXjqSWYtFMp4s5Hw23wUJbbg1uVGUBXaWj6Z0gF0dy820UpwuCRKtXD0+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=FBS8NBPi8zGpQO6+IjJ6qbW/K6mebyexXQKD0DrdFM91Lzd2kOD+6ukmZz9PitKVqfOOIaDyVGjiMsrGDHSVKXy8XMa6kV22a7p7frWNRt6y2cfo++06og0LUqJhkCVRSaFyCrGBTzLfkRgaYydztzrFXjn8z4EJls/1E52YESQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:20 +0000
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
Subject: [PATCH v4 04/34] KVM: SVM: Add GHCB accessor functions for retrieving fields
Date:   Tue, 17 Nov 2020 11:07:07 -0600
Message-Id: <6d2750b2be616619297324ac857824a64ca824b0.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR07CA0062.namprd07.prod.outlook.com
 (2603:10b6:5:74::39) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR07CA0062.namprd07.prod.outlook.com (2603:10b6:5:74::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Tue, 17 Nov 2020 17:08:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6d91edf-4cc7-47e4-e110-08d88b1b626b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772172B24124EDA02F853F8ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gM0Mlkvn2T3EZaIL6iCpfCD50Qfvi4AB3I1/1g3KXR/M4vZBx3w02CNXNfV1JRcVlHXhuUx93Z2XbXYj5Dv4cpFhyNUopPbtjCVq9v2TNPJyUdyxkuIwf6A5OmB/YR+LnU2XPmYiysuO9BCtmspJ9plFCUSOmPUPJXBZPcI1XAJbuCdM0/vScLuxw+/l+6eu0U5Ha6I7yY526Ks4eMjr3/TeeJbPpPQfUziqUo3v7SmdYOTDMT7oIeKN2FL/92VA7k8c6V8Ia1/3/8uykAGYKAu3O2631sumrpw7HljZdN17icNqZj62+er4mZaXca29SuLvwzlIuRXxwrJ7WT0VwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oT4Y4a8aHv4Ax7PTrXPCCR8GE1Zf2TOiuYuIKQIaUqD0HBBiEB9Bj8eavbKNTKiVKpYFHUrdsaWnZVejHHBIZ1Ob8ncQzQwEhIjg8PhcQZoJCcWlBVX2Hq1L5xm7/0/2/ELCuVM/MJ7Qa4sXIJosTaUNVVVKMov2zU2AOK3IWskCg82CDHBnWXSe4HGEr33mKJVbzLljsDvWOmpDOag/TZQTQn700JzExXFu8rTNKgpPFjpJ4EzRQS/VIX3AP3oycrGVUSldrhuF48LVE/17QJrRyvNSmGQOyByKpBMCV0Gt1PazlqChPCQoNs8CakWYmWBGapYXkzMoxttt46GUFgaHJiVk6UtWjHxBpdVcsb9WZIKDWKZK1/OJJbNLBB/CXJmw+vxGP5gQ3xvIBmLOTZclZsEjUAHvce580LWrLFVURhItgOHTqJRDAOqjoO5YS5zcxbP5b/OMjTTvxHJjUdY8jUfSx9TNBBpg05yfP4C2GarYRzzHJLe+bBUUEHfQKCLJFZUYGCzSe8Gj6uuIbv9y5Q9QLFxS8j3UGTySJnXfFrDSLzh6628llZO5b5CxjMaehKRppcncUPzEcqg07pnics12xzr0tgN5DpTZ7wn5MEwVqj3dVMoEhDym23drSa6vZvI9CzXuaxGGi/GA+A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d91edf-4cc7-47e4-e110-08d88b1b626b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:20.6279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wl4x/oAkg7TyedZYAXb8gF0UTzm+/RsblmrJsL1NzlnhSLeZItt+dzMkf66rAMHuAaYjljqUMIVSzRRbV+FKLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the GHCB accessor functions to add functions for retrieve GHCB
fields by name. Update existing code to use the new accessor functions.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h   | 10 ++++++++++
 arch/x86/kernel/cpu/vmware.c | 12 ++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 71d630bb5e08..1edf24f51b53 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -379,6 +379,16 @@ struct vmcb {
 				(unsigned long *)&ghcb->save.valid_bitmap);	\
 	}									\
 										\
+	static inline u64 ghcb_get_##field(struct ghcb *ghcb)			\
+	{									\
+		return ghcb->save.field;					\
+	}									\
+										\
+	static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)	\
+	{									\
+		return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;	\
+	}									\
+										\
 	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
 	{									\
 		__set_bit(GHCB_BITMAP_IDX(field),				\
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

