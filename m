Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23D82D6461
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392027AbgLJSCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:02:51 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392599AbgLJRM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:12:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIpI1OYG2EtQO21gosN8vVeGrdG3/t5ZEI3V5+5PdLMzYvkIl0tCrI1NF2+Ajd5UGgjONG4PpUtzVEpLjvxERNHYLlA9m2kzkHS8rgY6fQvIvUuj+EOGqs4Q9CN6Cxs5wASTCThpbxHQVCEYVKXQwC7t6bqYsAFFwPTAQg0+qcEk2jieaWpKxTXxCfHupEmvOfx87oI7TqdkQRBQT29XcmKw6J6qursE75s4RFQe/Jsl0LTxUo6BgrXxKnPRGTGbLvKDLD0b1sJOoUdvFJMZiUuEGkqTaJks8Djp+iGiTNgDbvDOEsdl3XY0ODtI0vw98pG6Ko7abswEUoeyjdVdCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=FH12PZMUG2VPWqkJqTYBDFlZfmraX/jMgZ1/4M/YhQCb+U8qPatIfxcV7l+CxEHZ1HvPjEieuRw5e0r2ttTR5lnoNd4nOThHCRmO/t0Q3IMZWELM2s9SK1hbvu55TTdk1FLy/Xf2U1/3Zqe4QQWVf24EQ1+ZUlwAmAn3yrhAur9lrN8Bqt0QkPT0lK+TBA16vtiaBwlOyDMXIjeTJTuHd3d+Z69Nf7KA/tq0qV9ocswiLMlrSdSJQAgqs0xbm8beJQ5PWfXJh8i8cUA8sv+7V6UZTHWT1xlJj4eQLJ/4dSGSU+N88vR6Pum0o7yXifJNblq+9o1ihTsfLeFp5dIxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=f2fhhALmykCP7fMbSAyFxfxRQ/4E5cPQKpeLjYYDL9p98ULVFCYf2EfmDoexxiowVDIdnlOj96ztT3CSZzOWdjiqyob3+gT+HYGja/0nuoSIIC/RaF7lBp/gpepcYy9klz97yK/ZXogpRgQ8LXUp4+TBTwn9zgNJsvqruYl5yvc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:10:53 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:10:53 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 04/34] KVM: SVM: Add GHCB accessor functions for retrieving fields
Date:   Thu, 10 Dec 2020 11:09:39 -0600
Message-Id: <664172c53a5fb4959914e1a45d88e805649af0ad.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:610:4c::25) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0015.namprd10.prod.outlook.com (2603:10b6:610:4c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:10:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef07ad33-fe3a-48f5-46ff-08d89d2e8cfb
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168A03AE7C2C1527104C84AECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHP+LP3JXHB0bI7oY8gKLQtXkwRPPpWfHylIvAekvERarTeBhLQbyvHWOiOsG0x1Aq7okq+mmx6a4CBwE9nRMCiCW13FLfNe1Yt+xYAS0N2mOhk6xYqNhcL8iCwrk6t1Fnz97LNoBIDDRGzk12nzbsSvas9EmpD9z8CM4cY9qA8GKxjPRngmDhp8nv22EvRZtkUxIItWur+ElOKidCW/XCPBDetrf2EMw5fSOsHthEtR/XFyf4fLprQmrhYMr7GRejbmFxV4+QvwL7C8hHnCxV+5tNxgqDd8/Oqmgl/7sxBD3lAwfTAXcz2lPXTPSbYSNrnPgnM4byh0qLM0z4/LpGMO8Mecky8lR6Xn3jSkSDA/5KNrIS4bzbsqZwXk9z7h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H17cp8XOIn4Vr+BrB2eTlcWt3FDSfs36QP4PVZgZ5yDQkQ83ZwNrfBkNngn2?=
 =?us-ascii?Q?UJyddZ5Be82r/d5JpAXJHkgBfm2O7dxpftp7O6QEEFYVI+NWK9RuKKwBsi7M?=
 =?us-ascii?Q?OhGyMsREO/mGbccZnbYjCruAzpG60S4sPUObXeQ0gYTb3d7kom2VEy1CoK9n?=
 =?us-ascii?Q?TxMFBcsWtKVqsn2/pLLXlpGmbEGr59gfKkibLvvM6++iQTmVDDrnNw834g2+?=
 =?us-ascii?Q?0odRIK1a8aR8C6rh9CRijON1o6qBvRWEicPPVceHS7BP0lwhd2p9v7PLDkLq?=
 =?us-ascii?Q?IEoLhz9Fm91csvD8/ZjvwUIk55OD5XyEk7xCUGVOYHqwcdTo+kl76feanP8c?=
 =?us-ascii?Q?n5mK/ZGMBSH5gNMO8v5ktkSiLhTajx+iEI5rrXecrXbSZMs/xBa6NvX2b1zz?=
 =?us-ascii?Q?snLfMWKh0342gdBevHK/XN2Z06AKbq4SQH7EmNBFjWbOaTX9tREzp8OmxGVH?=
 =?us-ascii?Q?elYoNiOljjmOon5tkH+/rxANwFzOsTT9pdSaryq6eqYzA1s2biqrtP6W1HfW?=
 =?us-ascii?Q?T0N3YTbG2gOg55vkCqq69Li8GBDPzu7RUekZWU2ECr2K0mxiRYWr9XlSkPQZ?=
 =?us-ascii?Q?ChcYcOqbRL/GE5dYfxfGst0Aunun9bABcFxaq8kbQxCbmED4UT3yEidN7Oiy?=
 =?us-ascii?Q?YlzSzl54PfvPQn2T3doWV2B98aHCUIAT/1Joh6znh9znowBDsBK6q84TEFGw?=
 =?us-ascii?Q?S4aJxHGWyTOCMYk2Ma/EG7ztwM7uzVffV8cXKlX2KwNE8d0WHOeaLRrgriSP?=
 =?us-ascii?Q?LoASUpeJmg1XeqlNFmMrFGfkCPmooXuAw6JVbYx+7PUGPpVjP2qnbT+SYy8F?=
 =?us-ascii?Q?PqHT2Uqmu+KTRvP8XSm8FEYRPV3fxuVwAkKUdfP3RTmVlxlV4s+rVpbJiNSx?=
 =?us-ascii?Q?WBr8EYsUzhlPLZMR8Gb6Grs2lXyGEHazrHfZCNv8JvvzaJZJF2WmA+jm7R1f?=
 =?us-ascii?Q?QoxT0E5kD62Y3/5FBAPzADO7uNu1iuKaQhPxVzZPioanQ9QLNBw0I/XDt1/a?=
 =?us-ascii?Q?j0C2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:10:53.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: ef07ad33-fe3a-48f5-46ff-08d89d2e8cfb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aSj3HicD42QEvf+07FdPcc062dKJZNz+OXZ8SDPNTxxhwYSHanbLKds/AOdWxkrA5TjRrgAV9LzAgJSt7TlXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
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

