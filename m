Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA64304C62
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbhAZWkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:40:45 -0500
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:29864
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392949AbhAZRkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:40:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyO7g6AuOfzx60F4myI/dNpPsx58eSAoJdUvEUNE06xBKa1tD2MAz6IFxi9JAv7w32aftRkTrItPmjvFzNarKknj/GPV+8WXa7xHb2bdKlbyVUp9/KfaurkTBWDcKn5+ku0gh5Y3+22DyyeX1xLKrnVk3/j7hrd+N0ch6Fr80/AnYw13WIWke6hCS1zp5H5bgoOlzUwlOanOKCpTBNrkPYgRq+Dsp594CQth7UmihJr04uIZ2BcjIEK4NF59gS3ATYTo4D/fudzfDAbN6kV+4RBCfmWdPlMXUg8T8vOEUugdzkSqwsUY/WPgM7q3/bsdAYvhMn9NhaNutFbP2GKhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR4/S7ATo2WmVto3ZLWqLM2d/h/9jnloCS7eA9/vH1Q=;
 b=SnqQ/3+vt27xJWQC+Mvf+WdNlMs1n1ittorc1+cYsd/tXGqCBPTWFN3jNsVY23OqKbeKiU6sdeaBp63uYlILZkQ8zhQsW8RQi3uThgKwY6VFzDQUs07lJOv4sZohR0zG6CqT9CV1m2nE88NSqp4uCWxboVmqpqeG9yhA68pdXjZoM5uyL+yP9YkERkdli96JaPQOOcmeYaDvebl2+/4/F2Rq9HzkrQlgZ5hCGuAU8KBOD5w6AUp+1EDM7YVsv8BB+5xvcSyIeIBsSVPE64pfWWhvgERexIoDenBo5FnlXA2T/y6vAL+J+kqZMdIyOE78yopSd8uQLXgLZuSWlzlHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR4/S7ATo2WmVto3ZLWqLM2d/h/9jnloCS7eA9/vH1Q=;
 b=VfvVpS9m9K108GYu0E9fEgszASr2gaoGQ7cyzKDiSTz6z/gJ5Lp6m3aIYemuFZQ5ABxZC0qFSwwBpXDUSffjiGAroQcLzMGIiH+1VM9ibchERp1zzLEly9AEBieUET6KrMO0cmzyspRVAmVDAWB4rCDrPnALiFDyOzD82kt6jyc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:39:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:39:06 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v6 5/6] kvm/i386: Use a per-VM check for SMM capability
Date:   Tue, 26 Jan 2021 11:36:48 -0600
Message-Id: <f851903809e9d4e6a22d5dfd738dac8da991e28d.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:806:21::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR13CA0014.namprd13.prod.outlook.com (2603:10b6:806:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Tue, 26 Jan 2021 17:39:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 825499ae-2a78-47f9-5e60-08d8c2214756
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153644E1D8DFE857BA0AA22ECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZd3QygK4iXsLpxrUm9u0mOWbk2s38gHNtuSMIEzou/bLnnIri0KNEFm991ZJK0dH9aVmkbvLSZYIWCDU2/vZ6+aG2n0l+97lZdHHovq9JSgibbEqd8QCwZ2PUgq+im5p1UK5M16EYdQuZ4p5pa1l9mFCMJRBrLamAg71e1rHhuE4j9xdz9jEB4ZpXgNg94qkZHomJuMLrhfHUEifvohW2NBG/uldFWxeRLoA7ZyJ/8F/+9MLPf92LohV1Y7t7FFFCnFZ6kJlDBU0oCvH6XW8wAsjWNgld4ur/1mqZyG8CTedIwzhi/XmDQcvt41TF21dI1vZ5cSyBV4ClGIlq9jzwYTSFtsdZqsOitWDZm2N81p0pxKwP0NyCE6yjznZ2Jn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(4744005)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wZk2ilCrcRTKsOA4/XjJvTLN51eDfeS7XDIa+lsWC7Xszq3sei+Y+UthpOk+?=
 =?us-ascii?Q?jicOStTpF3BNwWUxlfWVY50SHzYNusaPAqaRLmgro4BkB4/tj8bW5T+DZBRS?=
 =?us-ascii?Q?DdojrnIHs5NC3b3h57zZ7om3vcTqzX20V2WeEr/TuKaGTCBJ4D/G/20+/e8M?=
 =?us-ascii?Q?/s64IsQupBUukye4GxLxpTS27qjwebtIb2xWb0KAxuwS9WtvNCTuBjKxsVQx?=
 =?us-ascii?Q?SO0XaAEfWxJBNEeYSYNsNqWFlRPjDn1ypHof5ANknn4eiFbBG6RUOpIR1eYA?=
 =?us-ascii?Q?YibYhf3NS7od9NyIHgUohOS1DpEmFg+bDxFPey5als72bOOdIQJRMCn2VmX3?=
 =?us-ascii?Q?Y7DiMCg7xVZUT+jzBGYf3QV4lTTlpH3xwXvaKwThpfO0RdqmZDLTw1LmbY5/?=
 =?us-ascii?Q?EAKpfikWisFcdmIxda/hu/o62aa/JCK4KXba3RlcdMdz7JpZFuF/yoDC0s8t?=
 =?us-ascii?Q?CVDKZ3YthfowUjrRBP6nCPqUKMzQ4aDixc0rxtae8Rym4jpOF6ri4Q1e/BGU?=
 =?us-ascii?Q?Vv0hra8/D12xDfR6RMnF3aMohFVp1J86ZWGjo+WE0+GKvoPDrXJef9jC5iVH?=
 =?us-ascii?Q?iCMpTWrIWw9vjzmYO/FQFGru370b8BaxO9LXDgFY76kQlw+ryEMPFK1sSw86?=
 =?us-ascii?Q?X3Ljzsf63NhIZWxMnsvAnYTesOEUpPckkOroc9Ke/aP6b0OTxw8rL3D4pZBr?=
 =?us-ascii?Q?JBfFciMtDeLaG6gO7jtrq7jedjEEfyQdCF/yIAVe1aDF5KlAcaAhTkef7GB6?=
 =?us-ascii?Q?y4+qb/SYbkFQFhr5T6nr/nIuZtww8FaVdaZcD9avaskq5wf/lBLi86PUD9xn?=
 =?us-ascii?Q?qkSmeCagvtPlOzm0NZCDF7Xv7gFAJu5q7SF4WrcOMPd+fF8qxvrquHGG/H9G?=
 =?us-ascii?Q?1sWBXSDVGGml1da0c2yBq5AxyJNl25/u1PEai9oEY1NLmkUVNx8emZRgPl9G?=
 =?us-ascii?Q?K3wQ2t+P7sm0oh29GmF9ZSwoIRG4dcaYec6MEiS4xY4jf1wRZA7q+5CFYjmq?=
 =?us-ascii?Q?08qn0TnwsYzAfS3+Xq6YnuU546OhbJd3+IodDYs5v2tNvVJ+e10xvscj9mED?=
 =?us-ascii?Q?B0wTecqf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825499ae-2a78-47f9-5e60-08d8c2214756
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:39:06.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iMu9RsTyVbaZRAgCitJ5kHELpxkfXO/xGdwuZPVqLm+mEBq4b0ahkVeUeRzT8fQ6v+XlI8VLoSD0z2aj6CpaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SMM is not currently supported for an SEV-ES guest by KVM. Change the SMM
capability check from a KVM-wide check to a per-VM check in order to have
a finer-grained SMM capability check.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index bb6bfc19de..37fca43cd9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -135,7 +135,7 @@ int kvm_has_pit_state2(void)
 
 bool kvm_has_smm(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
+    return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
 }
 
 bool kvm_has_adjust_clock_stable(void)
-- 
2.30.0

