Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FE32B581
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379612AbhCCHRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:46 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:11329
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245484AbhCBSw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:52:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDubm3tDi2AnVaJOkyaZLApr+AUO1yNP7x18Dn1TVBUMcEyxxjckjc+L/ImtxL6yq6U6vRax8PglGJ50CPtuBEc/3UQcczBO6xJTVrm5+T7vF2DAiezYHueRcXmtBC2N6oL9s81tao3qLFdXsZRwqaEXnH8W9i9Yyq2Gz4p4mDUyRfOrMwIqAPO9vzTaDLmlCKL6C/rx4e6/qs9/Qe0Z5myB9WnfsVC+aOcTr0m29QvYc27hK1OtkWkNgY3c9JhRcfoF5IS080Y6LEXXMGGFWsu/PduYE4/9CUU5V9VCGLWlcadQthdA+8Cx2uy+y8YVRpLBqTvPMT4bzHTB3wSftA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOjMPM6tXA3VSu+oOOd4FkdO8PFbZqKJRQvllqPD9Vw=;
 b=j1G4htnrAff4X5L90zBoWRA6BQCEBOfM50QJFePzHK+Jo/tJL2hixsG/jVyT18GxZ+u9672VAL65plLUmJFoaG6kY0jnVV7BgBIApfHywT7cDcve4UZiLmI4XICf7GeyRKKGfprolVIVMcW6Q2Zf/7xRMXpfFIj1WabTIkWi6ZfO8NC5/2zO+JqsBU1URMmze831PA4c/flRL9EOu5lUqe7zcvKaDAUcJZ/4HyhilI5fDAa2bPegWQZsrL8EfFyWs4DY2DLgWtcRdrBTdUdwRlC+eq51dPY5NIylOgyW1WlvqSDsYAQwK9SH0rgap/uknv+cG+GGBJiZkZYUyJwEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOjMPM6tXA3VSu+oOOd4FkdO8PFbZqKJRQvllqPD9Vw=;
 b=PPv0ZtTSw3Dgku/M7IYKIIAFGiNEwlz5iY+d79G0aMtczC1Lx51fcTodnYoOTKt0LG2KeNs865JAD8Wr8/YJxE2NHLhrR2sm908kXJvgiY+Ptgqg9sZRPqK0dkifDmaKJQvEzyGCWMPC5OUOEnY+fDt8SJv5rgU43zHrIK+Knws=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 18:51:32 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3825.040; Tue, 2 Mar 2021
 18:51:32 +0000
Subject: [PATCH] KVM: SVM: Clear the CR4 register on reset
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        babu.moger@amd.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        vkuznets@redhat.com, tglx@linutronix.de, jmattson@google.com
Date:   Tue, 02 Mar 2021 12:51:31 -0600
Message-ID: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0073.namprd12.prod.outlook.com
 (2603:10b6:802:20::44) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN1PR12CA0073.namprd12.prod.outlook.com (2603:10b6:802:20::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 18:51:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 352e9d45-b077-4e66-3285-08d8ddac3227
X-MS-TrafficTypeDiagnostic: SN1PR12MB2528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2528C7CFDA0ACE4BD96671FE95999@SN1PR12MB2528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m0PROWnXnxO1bDhDIGpnsyvfXz9PEx7f1sc/GxYcOORk8rvjdIC7b/9Gaq/ZLbMMbLAs4ynEtEh//eTJxTRv7mfKe6om3y8/K8BJnnk9073d/Z9olezq66XCUxEWF7ZrT5EB+Xk9tbwZaMxyg00ckjcxJ9oh2oGsKU4Ry5NkDups67yxgYTUFDI8ALpNV+lqGTUOvIIFq9Yi1gIb/MxrDqMFk1G4LAFEukE+U0nkHVTsVgeZOlvZoHddpjRJ0Z+vS+fGfKlmW32YghYot5xg88v0JAJ92I8F4hPQ/ogsBVSbFGjKxqru8nRBfZWkJA5njc5TX9wZUDdsx5ZG+kL4r/HXQXYRT7JAUpBY08G7V3/gK/vETZBwgR9EvTUT0XBc0SHGKEcnd86fo+1FaemAOGhTcdQjKcYXRAhcwOSOLtph2Q366UjP5N7JYUHd2RqCVO9TrggKvJzFh90LpzvKLJYYSW47BM0Z2OgZr4EHryWmQBDzZ2c1W8VL3ab8nxAtQH7g7AgBhQ5Im9g7cEk6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(83380400001)(44832011)(33716001)(66946007)(9686003)(4326008)(103116003)(66556008)(66476007)(6916009)(26005)(7416002)(8676002)(86362001)(6486002)(52116002)(16576012)(16526019)(186003)(5660300002)(8936002)(478600001)(316002)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzNMaWNiUDBrd0U1TU9xczVMNUwrU29MMExNbHJvS0xiWUZJeVJkWkVDYnE4?=
 =?utf-8?B?VHpydDAwZHJTeWZLY3hLQ1owOVZ1VzYvNTJobWx5ak1FK1pKT3JTM2tHWWZi?=
 =?utf-8?B?Q0Nqc3p2aGdDc2gyN0VBeEN3L2JTQWxaZ0Z6bnphSzkrMU5lMTNsY0dTQUZN?=
 =?utf-8?B?SnJwZk9SeHNnUEpHS05OWDJVRGxWRW16TGtBOVhxZmlWekZMU3NodFNzT3Rm?=
 =?utf-8?B?S3RnMEdzNDBXUURBdjNIR1paVzJxcVlGcS9SUWVhUnFISmZYNWJaOWo1ZGxO?=
 =?utf-8?B?RTUyanFMc3VXTWw2c1Rvc0w1Wjh1ZHRCaDdFbVlPaGs0d1ZXZmZ1ZDV0ODlW?=
 =?utf-8?B?QUZMbjM0SzdEVzRYZHNiaU9CckorRjNoVXJ6N1luek5EZkJ1aWlBQzV0QlRI?=
 =?utf-8?B?SFhwMkhaSUpRaytWWEJQbkJ2TXVNSUVlRmpQN3l3emsvWUYxSzZZSk1jN05h?=
 =?utf-8?B?RmpSeSt6WjZ6V3oxanpsaDdqUzhtL3FZdFlzZm5oL3VNNFlIVXl0blRtcEp6?=
 =?utf-8?B?K0FnOHJvVnc5NzJTN0NqaklWa0FLMUorYVIrNWZTcTBpbzdvNnlvczdPTGVw?=
 =?utf-8?B?WDVQQzV5RlhlRE5ZQnp3U1V3NnVlSjl2cWxaU056NTNEY2cxaG4vVFlFZ3JT?=
 =?utf-8?B?TWxVWnplMFh6ZTloK1pkYUdCL1B4TGpoWStSNGpISXVNU0pMeGNZallzOVo1?=
 =?utf-8?B?U2pqaERYMS8rdTY1aUowekZwdXY0M0ZzSlpER2JlYjBndkw1WEkzc0x4WDhv?=
 =?utf-8?B?REZBYWFlYW5KbnoreWl1TGNvK01IaG1ZS3hUR1MyOUxiTUoxVEhCQW4wYlU1?=
 =?utf-8?B?bmZ3Mk9UOFQ3c2lobzZ6ZnBFRlc0L08yYk9GNW1QdDRWdjZ2ZVFmRnc2YkhP?=
 =?utf-8?B?WlJ2WFRtTnpUWHpnZk9OdjErU2FMTlNvblJTc2w0bUQrN2czUmtOTXVJb1d2?=
 =?utf-8?B?dnZ5dklJeHhqVnUyd0cvRnBGcVZCS0tpUTZtYWZSWDRjaWJtWmZ1eHYrQ21K?=
 =?utf-8?B?cWpSVnJNV3FBU3ZhTEZSQkZZMEtBN1J5R2Y1aUN4ckxKRGg0NXdLSVROa05B?=
 =?utf-8?B?YU5pNWVMbGpkemdzYVVGM3VLVXFhQzMrV1Y2QmVVVTZ6a0p6VlFhbGlENitL?=
 =?utf-8?B?V0EySXVMelAwNEFOcDhEekVrZjgxWDhYR2I4ME5mb0ZxRDNqMTd4L2IyTWxZ?=
 =?utf-8?B?Tm9GaXdWYUpzUE5nQnFKMlBRYjh1U1B3a2NTMThPMjBPWUNHaXpueHJNb0Fy?=
 =?utf-8?B?Rk1zS1QrM1NsNWJlQi9hVmQ5WjZTNUNFRUc0OGNIOVk2bjh3QitYSWoxODlR?=
 =?utf-8?B?NjkwK1BRQ2VvalNYZ0VNd25MVEQwZ2pobFZDdUtMeUxydWdDcHk3Y3NSWitO?=
 =?utf-8?B?RDU2SkhjZmFZMFRXVXJRNnljMEhFTFdXdkM5RWJwUXJYSEF2dWtQeFpnazY4?=
 =?utf-8?B?MWFBWUlsVVVsbzA2eFFPdENhQmUweExreDVWQ2pNVE9pNzNuRjlSM2NVZUlN?=
 =?utf-8?B?VXN0WEpvQ1FWZ3dpaWU3REJBbEt3TWE0dHZyTDRjT1ppKys3UG5iUVpES01T?=
 =?utf-8?B?MUF0bk9SckRtVUhwVm1XOFlZTGFlQm9aaUw5emEvcDhrU0x0c292MmlFQ204?=
 =?utf-8?B?ZGFyZTNJVUFMR3RRUDJvL01GbXlUei9OQWJlRlVVT0ZXYkg4NDJyeVNPUGxv?=
 =?utf-8?B?N3hsOXpJMU5EcDdXT01FZnpiaVhjUEN0OXBjbzA1SlJ4TmpvTU1LRkhZdkt3?=
 =?utf-8?Q?h+SRtLD3J7ThwGuTxevfxUcYiRoTqKOBCCDYhJQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 352e9d45-b077-4e66-3285-08d8ddac3227
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 18:51:32.4544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkj97748aJKiJVEfZEtKmgm4sWjWlAyw9pipTsdPQ08VvBJH1hXN/dUZdoYnAJXO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This problem was reported on a SVM guest while executing kexec.
Kexec fails to load the new kernel when the PCID feature is enabled.

When kexec starts loading the new kernel, it starts the process by
resetting the vCPU's and then bringing each vCPU online one by one.
The vCPU reset is supposed to reset all the register states before the
vCPUs are brought online. However, the CR4 register is not reset during
this process. If this register is already setup during the last boot,
all the flags can remain intact. The X86_CR4_PCIDE bit can only be
enabled in long mode. So, it must be enabled much later in SMP
initialization.  Having the X86_CR4_PCIDE bit set during SMP boot can
cause a boot failures.

Fix the issue by resetting the CR4 register in init_vmcb().

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c636021b066b..baee91c1e936 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1200,6 +1200,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
+	svm_set_cr4(&svm->vcpu, 0);
 	svm_set_efer(&svm->vcpu, 0);
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(&svm->vcpu, X86_EFLAGS_FIXED);

