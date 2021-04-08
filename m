Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E9D358A35
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhDHQzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:55:20 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:12705
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232208AbhDHQzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:55:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ghemq6/1IJ3iacwTBWPXiWM4NY6p37q5chmJCan35NQ481YnYTamdWs/ouQdGEbw632PG89b8F34tZfQu53AEKbl3r6wS+a+UKGcpjnbatpEkzklzMXzjyp2qYI7D5/8JIQaR8jsFK2sv2MjiZf7inYz+SUDYzKqDwjZAbo4E3hK5TVAkfl+PkwkSYzdN9iSQa4MkuJe0T/NMEdhmlKMLgv8G8BFgQJkeqnBasqygVd9FMUEusaWi355IUFsctBBNMYKtXOXPRFgNIkU/RNlKK2hloKccV1iK52S3B6Ju3CgQok1c+wzbcCAF+Bc2v7hI/OBoQFEenyq6PgxN/0tXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcD9y3mSt8GqaDF5DNHABldUiHkbRwtpuUJ0gZYYbXk=;
 b=Fd8POOMnAl/rfT5Syaush8HBJyeIRrUfjBC53H4vat8TNC5OrYt+KSOhGaJmrGrB5lMWDN1i5fF7xi4WYm0JRlMBbjzUuqRyBhnaAuLc/2tI91eRvVPIXpjpjF5oa/XkmRYclzEtgFxBefqwhS5P2tHgi71hJPWJis3PkJSB7SiB8m75UoGSv+vb13Cip2NoIREs8NQOvBbx6rBSUb6IN/YAtuNYST/+QaRUxzGg0/pEkYbvUFWL4wbW/n94OK65aMzjUaphhZwdLezrYcPgKOvgRFg1wxa18ObgHhOCgbBQR8etLtKTvv5oCPaANi9xNsK3Vc7RC8vDjTv+y3vN8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcD9y3mSt8GqaDF5DNHABldUiHkbRwtpuUJ0gZYYbXk=;
 b=UWYn0hK2Yn1nCo0RFFke8XB1AsU0XSx9MPGzjXQSnutUBy8xK8sltkQQ9jv0lb8X7yf0Ei5fO2WZcI4tSBBWY0l2thz2wQDcK2OyKcpeKgwpqlLzCpOSS/GDW1k5SB4nDDkCskDcakhhXErEu8OTUSDmkI0/fFbPnvhC0DjWd2A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Thu, 8 Apr 2021 16:55:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 16:55:06 +0000
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
Subject: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
Date:   Thu,  8 Apr 2021 11:54:52 -0500
Message-Id: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:806:d0::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA0PR11CA0058.namprd11.prod.outlook.com (2603:10b6:806:d0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 16:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5d06943-0b72-46fe-64ac-08d8faaf0fc5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4043:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40434A3A13BC1E410A331D7DEC749@DM6PR12MB4043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDwWI860ShzaDNt4O1XyAKTazKAEH0ZcE4oph2LWLK4qRx3YkQxv1lNR95yjGBZya3YS8zl2g82HES1NkjfY/aWt5paavWhnhXmRqIH9mGoHBUEbVW0KqYFihjQhLjXzyk58dC5k8QsbMoVeK4laL6SXiIp9xKlsKGm0/NmTF8SN5QZclDL+Yy9VSts29q5LoOt2XUaFtnTI3MB8Tihpvh0KRFnhp7hLaMu6NXv+Q2a27L6hpqch+Hyb2KsMpk4t6EuKbOTHTDQ8W3OXZXSKO/IvSP8jo48ab42B1dbkbrltINnWOeKJgbgVWuutKTnrGCteZfNwu4dhsru3eka3+0m22rlgNy5uw3Wqv0B5TbSmLLWOBhnnTcEJci/fZ71uToNDeYqudjDI9FJlsC/7EeUZr7u5Oga6YQZ+hoXq3vzkIyDv+zKCNxgbe4s5oJG70P5eakvyYudX3sW230CjWQ7BF51rl70gwc0hMxCtuDp1Id15bGj2dltm05pVyZoo3VO0AXjMx5vGDm5FvlVgaWGOWcknsxolWVCtoYYReQFV1MZNu2M/gEoli/b1q/Jidih2VUUElgHnu2rfafk9g2axNcgTNUHb3j13hXU3+7eZtTUcTEeyOnJ/o+/A/ofl30j7640p93gSGk4MF1eDA9ho7DA718FvgJrGXgQzlRPLyoZ6OphtUo4MFtf00ttG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(8936002)(5660300002)(38350700001)(54906003)(7696005)(4326008)(316002)(8676002)(6666004)(52116002)(83380400001)(26005)(66556008)(66946007)(186003)(66476007)(2616005)(956004)(36756003)(86362001)(2906002)(6486002)(478600001)(38100700001)(16526019)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?be9SlC5SX2+oX8eSDsVxw9lJEbLAHVShv2+xV2CIOT/YL16tZqZ/z1CTG1lC?=
 =?us-ascii?Q?cYTBxMzwxdJN8G/DWvLAdzEJqC2d4C8gtogvzlmObHYsPA1UghPFJZRZH63g?=
 =?us-ascii?Q?B50UsdTiHBakQEaQM91AEMgko/zjkjIQhu16mH+DVvo1n5YabsK57T7Nquvu?=
 =?us-ascii?Q?hKv/biu4QRDJfn9BptuXlee9mdW0Bn52TgLZx9q6g1tL0Q1ixgtzdK/PPXoN?=
 =?us-ascii?Q?sx6ZMokSjenpNksvrt3Wn3a7WWvD1nk6Q/zqH1cCUH/bX/qdfKLr4dkQbac8?=
 =?us-ascii?Q?5jJs8OO42h9eb5IGmgbYn2ZOt5OYN/q5xDN5R77CGHCVgyMxp2z9ltIaPVQ4?=
 =?us-ascii?Q?j3qYecerILELvraK5n+oUyC6iOhqquzd+wg3VBx6DAI0Q55ZZUcKyyqewAPj?=
 =?us-ascii?Q?/BPDZWRZuD+JhTFw+1ztTLCQxRteHNLxdNI86TQtpGGwSGmJyxNUXg8Z5xGU?=
 =?us-ascii?Q?YR30PUO5dnCEfahHnPFIYz0gsdhBnxUjw6nEzy3L0P5VdtGfAb6Mu74M+Kgu?=
 =?us-ascii?Q?XYCGCe1xeFpdIAxXF362+G6KzVyFx5+xlanZ40Ggy70Z2MaoYCT9MuGVczyF?=
 =?us-ascii?Q?Pn8k4VhQG7UPjI0puziCOPEQC2Wz1O0sMHEk00Ljuxw4dCIfucOQz+f4Ahw0?=
 =?us-ascii?Q?SQtMiZx6q3XG1NZTzXGpJQqW2fWWh5USv6M+QB3Bi0++C6HntCf2286Yovd4?=
 =?us-ascii?Q?feQ/US3sQ4KnrBmh0TO2p6h5pFEJv73EXpScA+3czZDhUmSgCoOWJjlc9DVn?=
 =?us-ascii?Q?yZRym09rniw9xhaqJIQYDxaPqr6cTfWmcr5NVaeVB97qKDceQOCqm1lWOasH?=
 =?us-ascii?Q?MXP+HWumxI6zuYIRfBkF1YoeYQWk7UZ4hfvJR1kBgogVYRXKfG1ZUQht8aRw?=
 =?us-ascii?Q?PUeWOFVo1PX2q5cGqxG2az9CItAk1lpw3pBPjl0HFea9Y8H+YjIK1biG3xTO?=
 =?us-ascii?Q?IZdAKhRZCHRF8JnfvgYMEoMMFbUHwKht9Ad+BC9wmjFv2TnPt5S9lVjK+IVa?=
 =?us-ascii?Q?oO3va0axSZJjdIjjYbGv+O/WKY+Xp3jj0RIPF10R8K/tpou5XVTMm21DdGI0?=
 =?us-ascii?Q?U6h8iaWg/OJA3ByFy7giuWGYOGC9SEUab0/HHiBj28YboYOyQ9lxIt5T8KfU?=
 =?us-ascii?Q?B7/vj1P6fH1r+m4AMqVZ7gY1qJRns+cHzCBvs8XUDHRK7xH1EXbc2RdMAX+q?=
 =?us-ascii?Q?G5LLuqGJPSHL3FtQ+sHmb5AUqE34TvQt7JCqYL51KgFhIFWTP+OUtw5kWzOR?=
 =?us-ascii?Q?Hapv/zkgdYcGjYHOWfW+2al23cqqD8bHusYxNsPd0nN2o4bienvBXSZxpHdJ?=
 =?us-ascii?Q?WtSbkN71YO8B24CCxVhjTu+D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d06943-0b72-46fe-64ac-08d8faaf0fc5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 16:55:06.5040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rdC40ijc1N6oiJgogqj5SRrYp+pkOrTuYAhMxyduqj1JDz66CC9p+qi8NfLxBXOooxW3n5I6Y9WAGQdSxfzfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Access to the GHCB is mainly in the VMGEXIT path and it is known that the
GHCB will be mapped. But there are two paths where it is possible the GHCB
might not be mapped.

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB might not be mapped (depending on the previous VMEXIT),
which will result in a NULL pointer dereference.

The svm_complete_emulated_msr() routine will update the GHCB to inform
the caller of a RDMSR/WRMSR operation about any errors. While it is likely
that the GHCB will be mapped in this situation, add a safe guard
in this path to be certain a NULL pointer dereference is not encountered.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes from v1:
- Added the svm_complete_emulated_msr() path as suggested by Sean
  Christopherson
- Add a WARN_ON_ONCE() to the sev_vcpu_deliver_sipi_vector() path
---
 arch/x86/kvm/svm/sev.c | 3 +++
 arch/x86/kvm/svm/svm.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..7ac67615c070 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
+	if (WARN_ON_ONCE(!svm->ghcb))
+		return;
+
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..534e52ba6045 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2759,7 +2759,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(vcpu->kvm) || !err)
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
-- 
2.31.0

