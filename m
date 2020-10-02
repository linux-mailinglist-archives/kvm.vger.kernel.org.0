Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944DE28188A
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgJBRDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:42 -0400
Received: from mail-eopbgr760079.outbound.protection.outlook.com ([40.107.76.79]:32231
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387929AbgJBRDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOdb+eCCe+UfCpfZNttLY1Zs1skOtCyak+R5EH7MTzB0MrJyoHihuuT3qgKkOf3xc17/vEwPX4dJrIVRFf5qdKjT63ByDiKwt6gV/5VA/IVfpKCIvv6CsjTIp6xV/FTE2rNVDszE4D4KJ9eGMneWrR4l8xPzwcp6Dsq8wrPGThdNg+Ef1ufT0JzicYJIJPPCjKQmJnvEb07XrsdBiIx1OpwER4s1ervD3ZbwGwq5RDD1H8X6/2aRL4RSHrFkITEEacpSZQFF1lIlQNXoFjqV9/tEqbeyGb4BXVXyMXDgZ4k8Ru0ogwreoIYbZLQewn0b8PvipJHu9Ip4Pi4LpXdlWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=NF1iNKCToWqFxXCoV1ydM41h4OfHKFVLr3eUK0rOU6ZjGSD5SGMHPRET5GQTmn0cr7AlWNMHPZCUmb0bG+sca9S7u5LdM9PxmEUp6K1VDFLQCRqSgzDbyc9MATesfjWAkMWOZZIo5CX9sawureEPTiljfjaxQxLM6cLixfox7HFG0vgJ8LM0YJWhjHXQROkbXe1H/yibozLKrzfl87PWyQkIEaZXU0XvOi256kYWNi3CYEM+vkDeb+6tTMIaREmBOhtZbbfBCBHq3JbQTcnzrMvK7/++ymaT2fzfXaTrgq22JHWvB+rssu5StT5wvgc7Y+0I22lMhY3ZmzaXDdSAIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=puOT+PcHB7bsJUUK9WxcTGWJc0+2iQwawKRp6qMjRaAu6TwT8qVfr/fN2ITXcFFPlO1vEMgZUmC0ODa6o3XjgFIrsjN5Jljo+qh9lxE7Uys9Dq3g8Qxx4oGxAz9L7/fhZH/y78B+Uh1zjyp9rfSiy8RmSqQESkqVec9l85DNAEw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:03:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:39 +0000
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
Subject: [RFC PATCH v2 03/33] KVM: SVM: Add GHCB accessor functions for retrieving fields
Date:   Fri,  2 Oct 2020 12:02:27 -0500
Message-Id: <77ee8b88deb39ee96d475b38f58dbb7d8f5ec670.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:806:20::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0024.namprd03.prod.outlook.com (2603:10b6:806:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Fri, 2 Oct 2020 17:03:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f15a3521-3402-40af-ff68-08d866f51ba0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706E0F1E0ADD5051D27047FEC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYhcEOBeU+msW/RdcYCA7cejZPS6cdjBaP/EZvtdhtG5PZbrzItts9fre1ot9aXzLmomemBgDsxxLkrfTv7f5BHFsxMy28a67xgbWkGDgPEom6h3AnwgS+VLwYRTDv3tkBP59F9E/f/7b7g9Hq/hqsBQAs0ALX+K3ngqCKUAxdqfcArzMcKLowvb8OK263xR46Kw04Yj1LJexFO4Gh7EQjJdiuyUKIz0MSlrz/cKCfSwGd/oA9cVmlY6IgajL1Soclz+UqYn3tNsU4K6fkcuV0KZnoNrTDAijPIUhU/BdzyAIqhWIBkzTHwh6515NtShN6h0PL/UTGRZaLCRhaD+0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bo5377C4Fh5zJjicoIajvjMc2otNAnUZfBtCLTpv089hJspqb61yYcQTBeNBxLDc0gyvY4ldkEPy36PNG4IpCz3IrW+nY0dKPLwBlAS4iKCjzPXux6ASqFzIT3o/ukAVCVCr7I0zg3eHM044OWx+QBAIrSsF/5ghrtsdy3ID/aDiE9NTzJgKtWH9O9EeALGv6BwG++IVlJFx2x4BJrDIANP3Pmr1mxP44gs1G3BiLxqROKDk59plxO8DYH3ZCDVubt7sOTI+QXENCiWeMuoUjpdSDGF1j1QNxh7c5aZbEuMNbbG/0q3fxmP3UeJ9igCsVJfOEelfKvUBCdNGxE8scIdmfayt4t2yjeTk8GJF1HMNahGEJsY1Qc0DWWHLS8ZQyiUKfc/+jn5eaOga7+F4E28f3u3vM0tgjwn7JVM1jIqC1VRwjIWE8lLve+zaUqGLVY+MkiY9kbr3FsQwkYZDwINkBh+hjgsxoNHBytI1MTuNbs3VOTLRgDsPtFDJLhvFKv6uCsou8bqVM3SmoqM+KboHW48EqMuSnBq0NIAMqzra2C3nAIRpu5brVqmcnZzfHnbrRjK/F4WnfYqaj2IKA+zeC6UO+WcDRh6iNJo6l24/DyHTBKCa0qG+PiZggSdpmMu0MJUWJkkI1HkOnpH6og==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15a3521-3402-40af-ff68-08d866f51ba0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:39.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fww4rKEuPeP+p5a9t/mwlXLXdhqiG2XEA8JzGTBe0e6MtTkZPj/rhjvurwN6SSdw/+WNdXzCIG5UpTgJl9/Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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

