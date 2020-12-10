Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FFB2D6417
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404090AbgLJRNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:13:14 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404093AbgLJRNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/5Pn8swLfl9LCFLE/klrBtTK4WQWZjw+xDCmEcix4nWMOSg9W3++mUwx41jMRNjxA9/5/DyOeIVcg5RauerWdqFogQjS0q0NuhKhP1sRj8MH54v0fvN07AmZHc1foMO599jbVW2slR/xUepFZV/ug9u2q79bwc2uUQBrtzzYBv7GKlEMsjx3vvsI92pqVmefgzuXVleWAgKF7tCqwIL7vic2nAW+cCJ5XezvcfmhCZD2Oz569rCDWSnJiHjy8LcopmlqsyluhLH0v/B9uyZuqlrK0KrASr5MjCjevzrE7hc+mSdZUk0uYGv7Ccln426yi/bmSMup1btvtDWseCZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYdbnSKGYQP/x7bKIVwcDc+Rq6fPEQuGozEwPif3lFs=;
 b=Z0uOPsW9LtTNkF2n59FYeEBbntGBtqElDWV/dEWVPBwps+WFv1MUehcXIahfBTlL8mQyjtNPHsZYe5xZqmBueAp1XryyRFU8kPjzpJqAfU+uMxxsaHktCu+TqR+8u0FwWwxM1w2YHc4jqzEi0vPkE6h498WAEToh9Qn28QjnqRDN/qnCij4oh3Vps5P+ZSyVlBz4e4nEX3UNWnYvg9CqFkgWrgdIS7vagFoOjsxfHxW2ba9MMxWqBsf3y7TSqL1JEjpGtI0pf1akmMxJj35swVDA0Qj/5y9GWNeyN8O+RWBWwWTQOzy2hZs77bqDBgjKh73O8BRgQ7d9SXZCmhycFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYdbnSKGYQP/x7bKIVwcDc+Rq6fPEQuGozEwPif3lFs=;
 b=V+n11VMfUbVvqIUg//EgcZMHkrDFq5MZl/OT6HpOep2fl0QYlyMUj32ypUZQ1WZCtJlutRq8uRCuPu1xi1JziyesB7c70JzG1K6TUznfswI1nJAmuQOnJApEp3ZbPhQynJ0KAYV3aNrQkLOOhEhQCREZPu3gY8NgZKtq2DtmcPY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:38 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:37 +0000
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
Subject: [PATCH v5 09/34] KVM: SVM: Do not allow instruction emulation under SEV-ES
Date:   Thu, 10 Dec 2020 11:09:44 -0600
Message-Id: <f6355ea3024fda0a3eb5eb99c6b62dca10d792bd.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:610:60::39) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0029.namprd14.prod.outlook.com (2603:10b6:610:60::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3713e4f8-eb10-45db-444e-08d89d2ea7a6
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01496DBDE5A6398C9D87F4C0ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JPanh++fsw6YYe4zob0y7Ql0QXK1/xCE4h7ILMyzzI4Vh+djmb4Ds8wN9T0m2wdKWViEoDzWKqfvGw3Vp52PCPqEoV7AaS3GU9Xw3VM485OZaZ13+VU+e4HIWPnS4SaaOjL8WA4ijVPqfDR32db0YVktweZEiAyMsl24TJotYwyx6Hfhs/VeURLXhda2/bXhYCCf3bDdgHY+xAqFKbH04x34hcDAsRumXWpH7zPmgt0B1LJIhpEzgOwiBQ9cT6V+6HggsKqlPvPxBtC5ktlr9mTMScCuHL3oWSAWTmdHv4B8orhNTl0n87eZ/dup/fS2qZSqGPJHZYdKLZMnroAl4xHwMLAZ6fgTJrkg+HzWwSLkgqvXVanfMjI/PPQWhFp9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(4744005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Hle1YakMHIAX+qfcK74TVqygRdE9n/sP1JqLsIOjNqaYu06KTZs/gVzIdAkE?=
 =?us-ascii?Q?Ijc2SycH1jQBl6IIb9iRnHDt6x8UW7GY40vYqY8HUe8YMht3h30tqp/L+38T?=
 =?us-ascii?Q?JnUcrltGB+kESLbtrrDejlUexcuMvt8zTxlvJ7rxTfhnmz3UmtSiXRnrsIpC?=
 =?us-ascii?Q?+4k/0rfNdJ9cej9vu5ju5ObkR/YWzVDkgc/HX4yLLiJ8QPJ+BFmvltapqEES?=
 =?us-ascii?Q?U/dOEiB68rb1TKOLIhB2EpgtY0817YuIp5kT4FrizpShUXbbm82DOD/mXopU?=
 =?us-ascii?Q?T2O7D3cGFQyKNBjwAjtv3h13rUpa5sDUMpSpDCcP/x0j9nXcIpij98RUlr56?=
 =?us-ascii?Q?3k1YaORZ3Ndn1opI4E5rbwqEZ0aLz0YEzEWE7CSXHcq/k+nuhssAGnjH7qj+?=
 =?us-ascii?Q?cqkqy5opVrzoSj6kAWn6LYLYmJnj1gofbZdj91eMsQ4MuES21c6uINuQc65h?=
 =?us-ascii?Q?ieONJ6fFhpxEobxvQYeQaKjDM+yHC1kmgWGBfzfnG6qK/MgxcShhVLi3KFzw?=
 =?us-ascii?Q?KFWQMsdE1OGSyFsnPAo9s5KqP9SgGHlt7IKrccvmU/KNDvObABWASlLhjYqO?=
 =?us-ascii?Q?bNxPR/yzNXk3EtoF/O3gHc7nxRkJeWnsTgDZerpTzz4k92AAuWGjLk9gxUy+?=
 =?us-ascii?Q?B2MJ8ZsQ5dBZSrAQFeM0ozkp1anai8syN/KAzK7hr6u4BQZuF/eiaRRAc9Bu?=
 =?us-ascii?Q?zuiUzvxq9HvSCrWF9aA+B1yskgbTfKblRKxQeuWxqBrHxbzPSlqbgf/WvH42?=
 =?us-ascii?Q?PX0npMKLZW7NBNzFB8PKswVUxmFfKPSBSXbt3ltyfefeGxyzCqRWtVE30hSs?=
 =?us-ascii?Q?rXelnAGjyYk9c91LmuZzhOfUVgvk2V8x/yS+SD4uJQ/klYJrx3lCGsil8JmO?=
 =?us-ascii?Q?bLL+WDMfFhP98AYTcoW5sFZmqPTxt9jlz610THaa89DKKnF7EJkFHGutQC1o?=
 =?us-ascii?Q?se0oxDsxLljk3xuMxpP7qwAjDKyS7XUA16Jr0BQRujFL0sd6ULAgVitafFfi?=
 =?us-ascii?Q?wxQC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:37.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3713e4f8-eb10-45db-444e-08d89d2ea7a6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyJ04fmKTt2XrzXkNs3XtyGf+Y1Z86oMgVa1cFFQvGEORYv9rrMx8U0fTqOxWmp7K6djoO9H9BvVlpEwhxvGCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running as an SEV-ES guest, it is not possible to emulate
instructions. Add support to prevent instruction emulation.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 513cf667dff4..81572899b7ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4211,6 +4211,12 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/*
+	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return false;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
-- 
2.28.0

