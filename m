Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31BB2D635A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404227AbgLJRUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:20:39 -0500
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:7137
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390049AbgLJRUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:20:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyfzCrqWLrelbbDOGGfWEEKVk0H/SPLV0uZc8n1VF6DBovGFP3BaHhvPsIeFaaBSMV6aGwc/uA62ylcY+HzLg/onCuFd4QO5HFcaK7rJGLQYIocsz3Mq1Kh6VeUzmB86U8Pm/2P76uDG5O7tZBhFXP4jQtKl9hW8GBsL/LlPsad0Ps+IDyf5Mbo3/HF4plHpkiiozzEEpNd+8vCit+37jHozygAcQa7MxKzG3fq9DPLSGH5E8QfUnaUaRSbEMO5pv4Wu4qesJd5vvMgE1118So0ygOeobnsKQIaWXL2LnwpPxNHYAfJUBel1j9vtSS1B8fwXU9XV7jU4v475DCErxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=RJ1uZuMNAWyscq2p5H8xbQgAayotyZvo6xLfmECg7B42Up94uSxOmXdH5wt1IUaQgjkaO3Kp+bsKbtFxQxBwGParsfaHJtwzQV5sKhsXi7SQB4ZIYoMPLK+X1f5c6hA5T4dJFrncdJrSl2mYWePf5zTxgSJLJqxu3SxsptCf5X9E68G9ta7DR5pelYa2XEsNwTmIBVWus9Xf86h+i+Hi0T3Y6lcU2Lvm5eIyKlYbbqeNPQ7WSCYtOJp/84Cv51YYETFLSuZyMmy56hSmV1E+64RCoyc17F8sDTSuRuBHvuXLqLrRH7A3KbviqRw9wWviMQoyN87UzQrdD0dwgNJ4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB2y2HvF8jpTgK1wvNB19tkYSym+XgJS9kDwh7ZQ4PI=;
 b=nMYcIxJTK/3sWhDNpiuco31XyLMH+860vpsrFn1tUE0opJNazzuRPTVyynkoP/tHDjmlYB9Mkx6eXlk6jPWN2yxXhEjSrfYPEpn6gbO7PeX6Ff0afaFLQLDVD4RfuG/AnmXGGvYLAFuXYtIO2PUWuyVbEg08gYpfgqcDJaxEMtM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:08:10 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:08:10 +0000
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
Subject: [PATCH v5 04/34] KVM: SVM: Add GHCB accessor functions for retrieving fields
Date:   Thu, 10 Dec 2020 11:06:48 -0600
Message-Id: <664172c53a5fb4959914e1a45d88e805649af0ad.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:610:59::19) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0009.namprd03.prod.outlook.com (2603:10b6:610:59::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:08:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5708ae6b-5a5b-449c-c808-08d89d2e2bb4
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB14938C0F7F57DFAE43FD25B0ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlSb/OF9jzxEqucIGYLTvtboqEQJFS8bcZegE5UVcJ/GXnnlHqaXXKfbZzRjzg1A4YwZSFdN/vJv2UFJ6T8eROHd4hHp+sonPEzpsTceafVNkFkiTy8dr2yExCVL0D8vKiWGjMi9T3kBulilT8abNni9P0VInpXRQzFNMrAhS6bcxn97r/p4FC+ZRnX4v6gfirujPZbFo3jDpg6y2/DO0c1G8uh21aHCONoPW3zN9WaK6LyPbgvEAAqPYqDqVDVORNHbS9ux4GRSxzwZFNQYDKfjn2UwOwqEjo8sH4Yjp8guzfUaIEW1Qfp+vIS9KjTRKM/yGkzt35C+X5geF0Ww9hS9w6L6gRakFuUtfAHl0sTqmtT7fst/P7+RIEWgibeu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(6666004)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(83380400001)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4+FTlxm7xDD1Op2JbCSJVLK6Mx4JR+4csiz5sKthU6wGsqy8jRBtNsmgauNT?=
 =?us-ascii?Q?F/uCOCq4YnU02t7fDgaXfESraoYuZra2NgVWz9DHvuVQD8EyFygbv96D7nYR?=
 =?us-ascii?Q?QEVtTqNagvOe/8PuEH/QYfGyWZnzXo6R4uXDDPjcZ6DX2uxBbRptM38E86vP?=
 =?us-ascii?Q?Y+Lkr/KxTu1CpcoOouKBw7m9vVpx9GuOgJCxBglerlj5qAyY6R9RWH3SN9do?=
 =?us-ascii?Q?Q6A6DpDC1jUTAYQPMVpQKNF1/QVHXeFMFQH0RrCjfi1qANDDhz0wQUoQ1Znn?=
 =?us-ascii?Q?k3g5CyL5bCGTSGjdQkse+tG5UBGJETSlsm2Ctk4YQqwAD63dcUE9kN6hcY0u?=
 =?us-ascii?Q?PhXpjLBT7NgCyBc0Rz/m0lWfrTHdkrkI+sRNkN4B3vuhOd2Hbdm5+cJKBuKW?=
 =?us-ascii?Q?LjR8qg507si4nU3WVvzZ1osuGLwHeWxHVPqOMGCqJN1JfyVSmF01LPEkWmD9?=
 =?us-ascii?Q?HEt4l1M0BcuoQMbc/7gUaNo4a7/AJqkcb+XmZml2UV8vPBB1EMam4+0HYnlc?=
 =?us-ascii?Q?r/l+hX1aGrlX18CPQ7cC+d4tj/JkqcjQyY3ZdLC9B7IBufPOXVTqtdIpQo93?=
 =?us-ascii?Q?fh1aWyUhmIXkFXbLKLpB62l90BQIFqndCp/0GXmvHS+7HPoZg9dnOHve+KMc?=
 =?us-ascii?Q?Pniw19KooADzL34ZIcMxtFfaOUUCYYI28AYEUdwsXAtPj7hzUKWAHyrgCg3u?=
 =?us-ascii?Q?UxPO63nsTx+w3em5oMywgBgC9wFM+pGpJnjQWONWtEQOog/ht6tbsmdtjP3o?=
 =?us-ascii?Q?Yf1kbXQMBF6TVizR8f+d0j4Tp6wFAAsNHc6l5/MlNb97eHbaO6l+JysJdI59?=
 =?us-ascii?Q?Z+ce9jctbFDRJ2XlMPBTyGUgLnZCv+XzO0zg6pw9uANXQ9YOzqactUew/zXa?=
 =?us-ascii?Q?jjFzY1UEjN8izUOTEjqpH/yaRNyCCmcC4STe5D3MTWLlDD89Y8PkpjrQHIR6?=
 =?us-ascii?Q?mWtM2xsfYQ7l5AYX/92PgHO8CDG8dOdAjfIM8WR68iHqnCEZIBwx5ENJ3Muo?=
 =?us-ascii?Q?zarG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:08:09.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 5708ae6b-5a5b-449c-c808-08d89d2e2bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iapxy8Na1X2sdy2xa91O9Vce3uSinB4gXOygKsJ6f+r5/oHVAtBCKNzRS57U+0OIc7oUvTkLPyrc7XT9hRI22w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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

