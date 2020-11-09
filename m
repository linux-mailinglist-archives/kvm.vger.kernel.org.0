Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2480E2AC85B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgKIW0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:26:51 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:64608
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731438AbgKIW0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:26:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kcvr3BeWV76fE1VdJ/LUopFDUWeQlxd5PX++fzR2iWN9CCBfBt55g90ecmxkeJIBOP7KFiKTJF4bhIPKhPuew+Cdpsz+2Xaqtm2egUqRjLLgbAE5Vz911kpYIl5M4biE5jpNmVdn4P77ShxpoFyd1BdvYKGL55VRJrFuo18ICvogdGofvy4OINNev7lqOJXr6c6YOXgC/ikJQBTx6p6mdz0ijUsSQ3nINx0giwdyXH/NhVdyfknqhdvlYEMZ1E/rZWRlBWuKwL24bya4TO1A9UOfQQTRPuHF5BWZ7vHhcD7ppUpT5c8UPzCdXN9JJv7Nlek4S/K0rJMLNM4cSDeSBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=TP7IXqQhUms4jgUz7ci5+eNR2RFMLL5nivgmKGSbKKFEmyoJ4hs3wOZnMlFfQZY7rAffjKkFVAAuvCgT221fog0JJEjGkqAQwkHclInGmwu2/BT5l024jaWeR+GwXyEvdvdbDdGiM/qXyE1ImXnWXLmFyBRLvRzcbgLOqx2veHRZPhkab5Cyl5oQHcYKnWmltj35BTWp3gTHXZjCNl9oXyMI+Xzk75o6/4Acj6JZFO006P5/bc/M/t+eSqZV7j5EsVR+kvXWW92PJpj3WcXBopaZ2g6EdFy/VjaW850VEsZPGOuj+U5bgElLBVGE9f+GYgnBLGYFYlve/sOQnBPccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=OCMsTWwzJ8HJSZoVhQjs1hrybyEe6IykjJPUkdi4QunfGOQv1oKqRrjhM+t3JLGw/ciGvZjZDyDwdL0O42pGaF5hdmj6WYFSWzd2rd0u8kU3LG7gWRv1q8z7EksPeU7P41IsWIXMBYoOQIxMojwrHSY9Re4A5BbunoEOM8QtcWE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:48 +0000
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
Subject: [PATCH v3 04/34] KVM: SVM: Add GHCB accessor functions for retrieving fields
Date:   Mon,  9 Nov 2020 16:25:30 -0600
Message-Id: <95ce7fe2b0fec426aa936f0510073847542db75a.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0018.prod.exchangelabs.com (2603:10b6:804:2::28)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0018.prod.exchangelabs.com (2603:10b6:804:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7986e100-229a-4aa0-1024-08d884fe8c0f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40587996984181406540A5ECECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raCcmw3L9L2d20ADuhsgbs87G4oBbCts2T84xn00lRzf1zwuY95yvVu8qRP//4evmcsdw3LGijEA1oLTcVFOsmPk90lb20Ije/5wJFhQ5fj3+8oa63DNAWlhdCPGj4e1vNZQuklY2HF0YUDYslguKjw2S1Jk6nBlddN1iSQa9i9m7Qz0hZRU5eqwMfWPHVcUm/60YhvHh5kjAA71B3EkAevKqfjtQiUPW7XzDC/PeqX74p1czVNMgkRQuuobleEydT6axzKZsXouqbeu9tfLi/4L/Y4EVvssMLhLu43Wm0lNcR6ggPHe6bPq0AGE6ZBSYMLu1UYsD0c223dFqO8gSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CQRrK6G26GL7OxfOJadGf3jilcdJz30qtDqOI5Vz7mkHDCdbPKVk1zbFS/8LXccIarO7dJIwBZCe0QII8dKbnh+8E9AexOoQ2+35J62VtCQmSpXUZeufQPgYiwRfVCnKXX9UPAgm7rSaVhjALOqul0Ik9YUxMGDFLLQw+0ydNPwFxfPd9799TWAvoDyI8wdYaVnvONb0Hu4x+B7R/1A162ydhFUINe1lqF8tgd9p+b7A5JY8c49rfjP/DJHTrZkED745/6Jo1AphbXQOWTqiz+VqOsAHGAr8AlesL3dxt3S1fwlVfZeuaIYcvguTipAG8ejCtHm2Q+YUckTU9w4VgiRLIZglPIXTWeoydjCb7qGw/qV3F3s4iqTpwqcDCv75VHboeg6TZ6kuCMbtL1VumnoBWDu5VHs2y7ovtUSNEJPzUamBoSKO7lN1dw1pzatUzApX1K8rDaVGbgeaMYVZUDNsbdtqKrpqR0psM2FtqovZzyh0+OwPsxjW5efL/r/q3qJ0CygOWIbxprwl2/0tAaDLBEz3tMiIq8STfmn+YeLsnAEN+DAPQssYZ5xlQEWeR8GxMCM/FIju5JlSzIYkYOi7awYfvXFvCEC1mDP33Sjd/ppwSIfs9/bcd1exhNwfOh/SWm/W3kW8hjIk5+Ht0w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7986e100-229a-4aa0-1024-08d884fe8c0f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:48.0751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKSUlKL8561eNJYC49BFayXzw1m+JbhQQezd6kPZGacEJmTmddXNPp6BO0ABEOghhwIe/LVv0cH25y43pV295w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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

