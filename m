Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37A7281899
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbgJBRE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:04:57 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388361AbgJBRE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:04:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6CbQqLzo5xeH57KP7lgXyQ5kN4lXNxiPaI214T+IoLc1MvtuQbJZbeGXYwBHCqPz9zznCmYdZU3XFy6/v69DcRgT/b7vb3bPzhpaqU+A3KXUQXp5U/JHo7xEU4sNInKQ5iE+6VA3IWZnPZfQXsnrmd9mbIaaUuG44IppJrBrlMSLdd2MvjtF7lRBu3M5l3hC+Rjg23GuWb7meWD7+q8r3Z5IDdekgSo21mk8wMbCE2WS0w5SIABlec6tOeM22qpBG5J2iYjYesfLg+LI5QcQxuWtgREfwV3Qz18nF4eyw9AkeBVR5gmFTnlOoma9fDK/v9sAUX37JnpJ/NgyXdMJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSBQClhOoCxwzTAL0c1MHiHxOABxKLwfBPlv1P2cCzg=;
 b=aiEAE5qJehAhByxDr2fCQsvbfvZqV4hExHPdGevpO8791ORpfPvU86xXcR8JPBqwQWNfQxHFphGYtCj/IrQjUC26ZIBfHvSYoiopLli2Jzr+C1sLtYhPhyxPOz9lRTekP3pLVsHQWMkvfZd33O5y2fUkaaJ38l6U6KdFFmAmifKPJcVupprDZR9bp8yMuKEFuSldJ8AA8Uh3zF/cYe8GoTlOC/BR4U0oW+7KoxlldKLCXwUMyHEz1IFYZEV8At41cnjKzFJooOb1a3a4ObY2Kr783+bqDNV6S0JjW+AlETbEKOf9ICrwvfhz6Ji0m6w0eU2JauxtRYnXqy2JRBzn3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSBQClhOoCxwzTAL0c1MHiHxOABxKLwfBPlv1P2cCzg=;
 b=OpGnoze6G09CmBv8JJd/xEAO8UXEbEewlWlMH5RAQQny0OJ6t1hs6S3UIjLqSdqmq8aiTnf6x2MJNLoUyeRvCqMcsnlIoYIUlhsj3QkYVGh7zNpve5uU5dy9SZzQJbBEuHosd62M5gIjMhe4MUWgQ46JNvRsUW/nmWgDn0kRrSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:29 +0000
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
Subject: [RFC PATCH v2 09/33] KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
Date:   Fri,  2 Oct 2020 12:02:33 -0500
Message-Id: <b6e38812fc2b3f5ae1a7df28531ab8fb5601289c.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0094.namprd12.prod.outlook.com
 (2603:10b6:802:21::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0094.namprd12.prod.outlook.com (2603:10b6:802:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 17:04:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a26db2dd-80f9-4923-b217-08d866f53987
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17062D09A84C58C00F01AFF1EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBhppwQFH7ZzpqqgzV5EVU03cLE+TldLpWT+41Cf3Kmlys/k2PyQTLS7jxfXEQfVG/o7UBmFbi/kp9rQ4zbm6RtrwZ4YTkfxcgiu/n95hUpi0ec0rIopG1lPkoXEvC7Gla+ssSqnkKMHFvqUv95Hp/O3NKaaGvO0dtpl+JKBbH5JzVfMxnymMyrTd6C688QhJu+PtzOkvSqRd3ZV9NNG1vze3/1cVVpHBakL0Z/zvVHzYCYBvJx8yqjeg3agUmiZ5OJKe3xH2nrrOjp24CKbXNRAvpo4mjzcgjjQ/dkcufkrFuGPIBGP7x3j6FZYUlodkmQnUlIj5kFxLk6k9YvDLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(4744005)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A+wfLFMJNESKeFR9gs9Eqi/JPSMwdx+gELuZiHA9N4orucIgeX04XdiuJDQ973HEjQ88dC6qq4RyHH/SEeAniJwY34x75hpnr5jgvrHIngEbbPxZBrNDyS6+9dQcb38wG5Xy4CM0bQOGv3pu3hdrlWRPiHrgyBVmRnb6Jtjv/Qv4t6Q0+ckTgLGaYnbVe/ew1ki6bEenAGvZLhKeXUFxTLUkcaFU/FG87WoCnIaIV9MCVGU1gGzU3xcHE1+0yLWhjR/p0X9YR6xrHynCJHgdYag1MT4KJ/6BYQCVyWXdHZ/QRKQyBJUj5skEUhfaZPt3vtvZTNUg42re7xaTcT7oHEGSVHRMRVEhcj0HZNEoCcgR9C0vJXAfZhUo3w1beIKzVkFP4OZLS/Sz8k1g9FY/4EI26aZCKZnJOTfl31gHlj+zarlTkxKS9diOJFoeYzNcNkpz695Epj1ZQUygXZoiPw5hayXmqjX2Mv2q5zVIV7Xaw6t3QktAe3PNqCUv8YOy3DUQU/Fhpa5/jKV8kU66NL/3IsQcz2kQlIlZIwP7auAoNdYt9StfNFL+dNDoji5DGc1HfL1ctVknve9Uga9upuReEjgMs+lRW8SCaj6tRWa4WwQXssRlYccvDR4IrXn7stXRZARLDanAY3V/Sppsbw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26db2dd-80f9-4923-b217-08d866f53987
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:29.3788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjwSGLx3+iE75RRIiyqWnQtwMUJ5Iw344xlYK3/pnZHGD/CHdhPptv7MQ69uU468WKXyk6/eQwYixSlNIjVlYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a SHUTDOWN VMEXIT is encountered, normally the VMCB is re-initialized
so that the guest can be re-launched. But when a guest is running as an
SEV-ES guest, the VMSA cannot be re-initialized because it has been
encrypted. For now, just return -EINVAL to prevent a possible attempt at
a guest reset.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 51041eb9758a..5fd77229fefc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2041,6 +2041,13 @@ static int shutdown_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	/*
+	 * The VM save area has already been encrypted so it
+	 * cannot be reinitialized - just terminate.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return -EINVAL;
+
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
-- 
2.28.0

