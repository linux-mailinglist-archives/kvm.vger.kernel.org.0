Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59636458BEB
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 10:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbhKVKBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 05:01:38 -0500
Received: from mail-dm6nam12on2099.outbound.protection.outlook.com ([40.107.243.99]:15136
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238871AbhKVKBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 05:01:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ui+YOdN6jbxFoj1ZzTA+sSC7gzr9cFsy2XHynu5Mi/6xmyGSV1kZKE7XO8mEqDfIPHcB8552CfKQvxPUkfuKZ5vv80iNiT+XqYoZ/sBDZKLKegx6yoPzYbwV+zqgJqa2Yr2kwE8RlICBbMJX9uCw7Xxnf9ACiGBAzFkLU4VcuTHJzf7bDfo0M0kl7b1gD1HTYPXTPM6KWkZu1R6qzg3Io2PUedMg3BG7c6He7K3vqNsNRat3ZwZh7PBldop1genJrsDGLaSDrq/zFYK26g9sTqcep063a0xxBwREKfHAHqO84uDeuZ3u+fBcibz+vJb33/YltkOkqw/n1F1NXcYLAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DJreqAjXHLWdWpJd1RYObTOLVCDMK3Rp3GPJBL2cXk=;
 b=dbObIsVWCdjOMv3Q58iA1gzeKpBW/aAfs5Z6/94yw9dsrJzGjTmMZRcN2Br6zLy6OIP/MYvFEA7uk/7/tpWXQIrxuVhHiyLxcwayxUiOidcNDPTVnNpnOb0m0wsTUjWrhV9FWVshY1uPStYWOd5RZNn/OJFUP4LGeUF8kME/XX4HfVWQICo06N4ZzKwNcfrrsU7FwDTkStb0ONYFcntfX0OEnTNyI4oBwZStHh78hHhqTVM/qzdOvWxtM4tAPS/4n+ldjKCToZg7gF1rAdwUy/PrvL7eN6ztuZ30T2quzHX5ya/4e7tBTpd56NYYuJrztFEP5a1mYz00NmnSayL9uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DJreqAjXHLWdWpJd1RYObTOLVCDMK3Rp3GPJBL2cXk=;
 b=ijd+IeGmcjxHR7/XBTvphYsQnoGRTk29JZ/MxD9n4KVhSouQrHbleYqYbHbDq0VBDYhTBeEgdmcgZY+LAI0FoMmq9ZaOExI9PTcowOhOYVcfqliYyeozzyLx4nBbWY7IEdRpTkT60+EVBoB55EqWXdAzBDHI2PgtxoSGrRAU9jI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4124.prod.exchangelabs.com (2603:10b6:5:1d::23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.24; Mon, 22 Nov 2021 09:58:29 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 09:58:29 +0000
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        d.scott.phillips@amperecomputing.com,
        gankulkarni@os.amperecomputing.com
Subject: [PATCH 2/2] KVM: arm64: nv: fixup! Support multiple nested Stage-2 mmu structures
Date:   Mon, 22 Nov 2021 01:58:03 -0800
Message-Id: <20211122095803.28943-3-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:610:38::33) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from engdev025.amperecomputing.com (4.28.12.214) by CH2PR05CA0056.namprd05.prod.outlook.com (2603:10b6:610:38::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Mon, 22 Nov 2021 09:58:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c13fac82-feca-4e22-0f16-08d9ad9ea2b1
X-MS-TrafficTypeDiagnostic: DM6PR01MB4124:
X-Microsoft-Antispam-PRVS: <DM6PR01MB4124C00ECC692C105EB177F99C9F9@DM6PR01MB4124.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/P9f9ti+LNpX1prLXg7YxW9u8RcvdSlVpgTDZ37NSHfTxejy8NojEh1waTnwow26Z3WM5Hfp5/YB9hwt6idUJOTUcH69DAKbkQG9pj+rg4vyf42B73Ewiz8TXuvzPuhbxhDODz3F7smYK817YIpoROUeFdPEzcJRIcoJnAqGiZt2gliLcXqNgP5ntsqS7asjsEKv3qBCbffoy8wjRjQeL4qF+G3f9fl5jUR+t6emL6ClHJptynjDYHS45og8PUMArhGYI4tlUD4qALjgiEK5k1x7pZq3rjlpZtioUqIw5tpJGxejYCYPQp3b/WX4RmL7obBZdAJ7+1zqX7yIyVwvuknQaVm2ywDmdT6dMOnMA+/Fqc7+e7P2PfHTEvORPDrBqiCW7Jakj6s29B6i7tFKfSCHd+5pNNqbPSQepzQ4TAcdLtE9R7gR4lFTU3LiyqGdCAOluARSoqZA08xlgX+oG4tXvhsJDDR0aOOfgGrNBaygq/24dSB1qnQE1EEfEnGSXXQP7JV7Zf2bo/Qr47Lc3VNqejTTk5k9llIPNShqcxVxIR+TVkgOT11CwxTC3Co0S9/SVLsWTLy1MJYE0kCk0kLGkNH/cTmOd9N95tVb6ZSDl9/k3iMDlwknMpsP1SW3DNHPkEt2b+SICL5VuMpTNbnkWwAyDecmoiYMfJgCA4KUpNuU/hpoQHwpnmVorD7Q1NyiFJZ7zv3kQdCE/03LtMtBf2d4zRx9PTcgoDrLKbtbp8gT93X5MzxQ/KJmExJqJ9k6QM0mkhX20c7gZwjr+mEj1KFgTSg6A9WcgqVw3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6506007)(6512007)(316002)(6486002)(66946007)(1076003)(6916009)(5660300002)(966005)(8936002)(6666004)(2906002)(38350700002)(4326008)(66556008)(66476007)(956004)(2616005)(83380400001)(107886003)(38100700002)(508600001)(26005)(186003)(52116002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6rNEJzUg8iXb7BUThK4U9/GgEXvrHRtD+6avgGJvGruinNVvBjM8Dz0xhuR?=
 =?us-ascii?Q?9JLQ2EuwoKp6AFrUcY/9zd32Nby1tqAhGYzC/Vyo1ZavYnqYbznpAjV3WF9I?=
 =?us-ascii?Q?FTa/t0hlBaMYUp6uoodloWjGjy1d4wPep+yssHomQfqHEGldoxNU+ZOwSmnr?=
 =?us-ascii?Q?HJPcLv+y7MGK+pJy5CQluZ4o1NcMFGPOfp/ZSO2+NlZSD+QHK63eF9LsDR7q?=
 =?us-ascii?Q?Lzr79auCZ7W9obItDq184ONRN74Hs28Bl9liDi9Z842RxFZlkuuC0XQ9w22n?=
 =?us-ascii?Q?BP16KtR5i1aK7nF4YkKG1Hqp/RxwFKh9ezhghBWV/yUxRt1HOjxUQ/iG2IxY?=
 =?us-ascii?Q?6nqGkl9TwzJWH9Anjn7rO8Rgb4yuXy7Hi3G4S28gqOSiphKnls7IIgIf/gto?=
 =?us-ascii?Q?Q3GlSwSneOxlg309s9E0R+5KB2LfkO/jgZ/BojT8CRczrc0O1vZh8imyIXbg?=
 =?us-ascii?Q?8l7pvgABoLgpgQylmJW8hWYpJFSsv12WxpfpnkN4wXfrICWKbd6Fi9emZwEy?=
 =?us-ascii?Q?Wfh89HpUBLjvCgjCd0rcpd9gWgSYEHh2eEB6vCgwMnFza37yt2ab3LFtIqEv?=
 =?us-ascii?Q?uXPXFwpteIeYs8LAREJTD7mktSloK8eAv5Q8bVpq24f+vT9k9I2+MMJnQtjK?=
 =?us-ascii?Q?4xFBnyYu1bBatLmi87hBbey5AjbBnG7+GURr411v1vosYwHT1ckzrgz0t+Cd?=
 =?us-ascii?Q?Be6GQu6rby9NiO4B/YqZ0KeGKTM5oLloDdhYiSFWFTfSzeiFz3CaOB1ZjdSE?=
 =?us-ascii?Q?8oIbEftKBZJg6y36uBF0nSO8Ef1Y43E27Oz9adWPzShE/x04QyUifK5gpMpm?=
 =?us-ascii?Q?QWCuihJj3qjDWnGrvd3gU+s32WEfpPj6u0T8hBbVrAlM7cTuBJYUoVwNfwfC?=
 =?us-ascii?Q?s1WLmc09DA5652tIRoB1QnNdZmD84LEVeCrQYLVfUNciA+2mGV6E7wh+vuXb?=
 =?us-ascii?Q?5GlS170mkkK4HaviPYf5iyiyMepd6JlOWj971p1I4VHbXe8N73ac+JXXYgT3?=
 =?us-ascii?Q?rLWm8YeGhY8rJCOmYptGRbv2ljGlnU1pyWHoPZqPTXcLKGSTRE7Bwx7BWotS?=
 =?us-ascii?Q?/pAULe5d+nwnDUKBUCTtZPuKHCyc2Re1z6bPdTS22e93NvAYY3VOTJtXDRrK?=
 =?us-ascii?Q?aiNb2i9+ksg3yl/PPq0Qpe6NyD6pvK/COY0SLw6e68LiNTTdxbr9/IHqhQaE?=
 =?us-ascii?Q?Kdz6EzIGL638PjR/kk4DK8dfb/v9bCof3Ip0IQHsX9BGz13cj6vn1Ojs6zdA?=
 =?us-ascii?Q?yueHfKwm8SoUdEjPprAFKig61e3dtEbxljUEfpwy120RBMV16/b9Fy3148YG?=
 =?us-ascii?Q?uLafCAS/PMAGxbJtZ9Eo6+5xET686rK1+S67n3PNopYcjTMvslBwuF3nXuhd?=
 =?us-ascii?Q?0lHFk5Tv7yxZJmxNVBYk/oan1l13lcdDLbHhjzwcSV/QxARYdHmjZHPcdcq5?=
 =?us-ascii?Q?9bOBMX5eHdDhGELNNYuew7YU38DZfYFdn54cGFUfM9k8JCRm4OJf5W/qoHYB?=
 =?us-ascii?Q?vaLT4DwZykACnwPmmXKWCduWCzvYRYly0LI6BMmCrnpGj1o0rDNIR1hJX2Bh?=
 =?us-ascii?Q?fPm8s8DczeqJQ7QpxZxz7F3cCZdzBoOcdAOlBjAAtnA3h4gjujkqxBg0+51+?=
 =?us-ascii?Q?JE14Z4CgXfa5bVKrmUuwiStgsrrXWwtBkAUh3LYoZeCkwRbgo1JEnNgLrx48?=
 =?us-ascii?Q?RuDoVcfE1GIaV9blClEpYz0tFJNiWr7Yh+wDS1ShM/978CVJaVbaCk8/QeZr?=
 =?us-ascii?Q?n5B/3e8Jxw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13fac82-feca-4e22-0f16-08d9ad9ea2b1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 09:58:29.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxRXn+9qtOQ8j8YzkwfbNH/ozF1xX5uhbQ9O4LHj+9VxWG9p7Ar10tibzfYXKyuI7yl4pxQoxoxXVja4C4dt4VNS/enh8RodZS6IBI/MOwNNLkeLv1i2TxEJBC7QGcgJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 1776c91346b6 ("KVM: arm64: nv: Support multiple nested Stage-2 mmu
structures")[1] added a function kvm_vcpu_init_nested which expands the
stage-2 mmu structures array when ever a new vCPU is created. The array
is expanded using krealloc() and results in a stale mmu address pointer
in pgt->mmu. Adding a fix to update the pointer with the new address after
successful krealloc.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/
branch kvm-arm64/nv-5.13

Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 arch/arm64/kvm/nested.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4ffbc14d0245..57ad8d8f4ee5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -68,6 +68,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		       num_mmus * sizeof(*kvm->arch.nested_mmus),
 		       GFP_KERNEL | __GFP_ZERO);
 	if (tmp) {
+		int i;
+
 		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
 		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
 			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
@@ -80,6 +82,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		}
 
 		kvm->arch.nested_mmus = tmp;
+
+		/* Fixup pgt->mmu after krealloc */
+		for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+			struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+			mmu->pgt->mmu = mmu;
+		}
 	}
 
 	mutex_unlock(&kvm->lock);
-- 
2.27.0

