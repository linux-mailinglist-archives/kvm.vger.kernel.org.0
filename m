Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E35273D90
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgIVIlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 04:41:37 -0400
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:30817
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgIVIlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 04:41:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao77Psl9qOXnJSTRP31KKiBGln2SlqqdOPX2Y8PCYW3TSLGjFOQiX/RUjC4vMSqViCqvKEesJ9TcGvrhyw0xh/Jd2E+y/WCQxQ+e/4HJeALaRIrd7JZ4rWE9PDLp1fuPkmJkDn6xwUwXsTlPvie8AN5OhaS88nIe5Mr8wpPHTAEas3F8WqOYBMxXSn0pkqDoLfnrn/RD2CsDE8B5RgqMpwAEGLbov9T8ZisQodI+7jPggMTKXuuFh2iVNwStABotP/un05xAIT400pFyxNurkCsnCJewk+AbxwEEsw/Vgy9KdYaPYRle4mUQcOgYQubsPcFLrVEx1fGxS0mC5XvsZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49tKbKNAIe9+3qh3tvwC+6ucQ5TyssfwUhb9fEpUlf0=;
 b=WGh9qFVYvMg9fmtQklZi47GVvAMy7xnYOai/JE4jFngSx9PAWD8QIpaJ/izXBMIEXONQGDsqY3BAhzzf/M0ct3TD5QQmewOyk/cFBGghJPN9cZZUl/wH7fMtRPmy+GWMHA3eoMzhJEgUDQkLjh8Y8ERD6ZElDjM99Ln50gMRJQVIduqjfgk+zEZWhMj7TAWcmh17N/a30JaO3+Sfgabb0d+vSPUJscjngZ/zgBjwjNKWNDHSHzxsXGsia3YvS9tOo7j/GxNdaTeXHmVA1FLjjY/sovzV166KnRuSUMfddBjJ/gc7YWFQrUv1Odp+kkoZHvCp/q8sP042d+hbA0o3BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49tKbKNAIe9+3qh3tvwC+6ucQ5TyssfwUhb9fEpUlf0=;
 b=p1Onw3yboKdL0cKxgs5vwRt3uZX+49PD9BooIeFXn2xWEN5LFFyPGJQhJnfTzgn4/QR3xEAcaKrcdbthFPrKjZoGunp21ly90xSY+rIUpSVl84HQzq2TcL0OoQ7Xc/HXdkDrU62aBOrC2NafI1RS3scXQ7OX1bk99/t5FrA72dk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.20; Tue, 22 Sep 2020 08:41:35 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3391.026; Tue, 22 Sep 2020
 08:41:34 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Initialize ir_list and ir_list_lock regardless of AVIC enablement
Date:   Tue, 22 Sep 2020 08:44:46 +0000
Message-Id: <20200922084446.7218-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:806:a7::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ethanolx5673host.amd.com (165.204.78.2) by SA9PR10CA0028.namprd10.prod.outlook.com (2603:10b6:806:a7::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 22 Sep 2020 08:41:34 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17382fb0-992c-43af-6fa8-08d85ed34fea
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB433753394393DE890FFF7E0AF33B0@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOiISf4ksfpVHmg5p+2PS7TVZrS5Rs5oJNzGn8B/E+jIsc3fZRYsheO5OMVuqP1nJF/vrX9L/WDJe2zqIF5nvut4Zu8VunViF2U+E+AooOPDsGVikJ7IXyHUJMjEXeM69xWos16Ex66aQV9Dogl+slQZOSbx9e9TU1ASE3C7OHlqe/SUi3yKznYbpSE8pOxMaGaDwlHH1TgGLD7NaU2EXe9ebjUTlqjW/LbkLaiJCUknoSiXif92Nok0Vxb0aUyYmDf4nGpEQtQlTSJR0k/YM99iK39wZSvequNLuQMzEuy0qXtiIrejRKkA/7OcDWldg2boKkAt451iTrJ7MfpU2AEhnH8OLgCqsRKzdiXZE2IE/ONAP3CtUFyQCQgPKjnv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(66946007)(66476007)(52116002)(7696005)(8676002)(66556008)(478600001)(4326008)(6486002)(83380400001)(1076003)(36756003)(6666004)(26005)(2616005)(956004)(44832011)(2906002)(186003)(316002)(86362001)(5660300002)(16526019)(8936002)(26953001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2vIXUfZtWH5RBdtqXczYsbiBf9WUy651QWgbylcXiDmpqfGt4QvMB8CUMtzoTBb3yLGX6m/rSEDQSojtCq0BT4PG6ssEJ+aQCwSpJysGLtaT3L9fou80ALbR3bGEXDwlxGggUHJ6uOatv4DbgFmRB5WUGdXof95esBNCVTQg9FCK5FO6fNIXYFID7Z+Jj+3Z5BnZ2dmixAoqHFyxEoNm6SlfelNwjLIdbj0OkG7FMSrEDlAoJq9qQTgNfTH6Cr573faP5ufDVWFAPyuLfBWtDvNyuOYKinKwTpWjHzIKeaw+uK4/SIfaaKl75Gaxp+iGDPefp8hShlYTUbqyTBRDIMY5Z9dLRXrOw2ZF6kz2nf5awhQxRluZGZ2/M8PMQ+fgKTFDH4P9R/Vi5LCwasBTzpoN3LjHcSk66KB/Tr/DS4JVMR1LzKnNXHZQpPTR4CIGVjgsukaWA1YWr3LXUjFDZWfSi3+so2G28I/Z2KC2UQqjcSCG0u6+YOH5e2t8JoNGCSEWnlotbRbvkqjKcrMHgPCsg6t+FeD2yUGF6y+SyUpD6t2PJlQ3JOx/KB+G+08xfqcZPrjrCcvuHFPR8LjPWBVVt/jC8onpjCWfBlXSCg4PPY576RKZakEkhUASeDvlToe6n0lI9yRQyqD39dwbLg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17382fb0-992c-43af-6fa8-08d85ed34fea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 08:41:34.8218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ulK1U2f9pZyaQ6JfSORleKiwvybqNANJTzH5n+X7ePRVsfmFITtU/j8FGp6eTBCJmIXbNhqskOcRNxu+RuziQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The struct vcpu_svm.ir_list and ir_list_lock are being accessed even when
AVIC is not enabled, while current code only initialize the list and
the lock only when AVIC is enabled. This ended up trigger NULL pointer
dereference bug in the function vm_ir_list_del with the following
call trace:

    svm_update_pi_irte+0x3c2/0x550 [kvm_amd]
    ? proc_create_single_data+0x41/0x50
    kvm_arch_irq_bypass_add_producer+0x40/0x60 [kvm]
    __connect+0x5f/0xb0 [irqbypass]
    irq_bypass_register_producer+0xf8/0x120 [irqbypass]
    vfio_msi_set_vector_signal+0x1de/0x2d0 [vfio_pci]
    vfio_msi_set_block+0x77/0xe0 [vfio_pci]
    vfio_pci_set_msi_trigger+0x25c/0x2f0 [vfio_pci]
    vfio_pci_set_irqs_ioctl+0x88/0xb0 [vfio_pci]
    vfio_pci_ioctl+0x2ea/0xed0 [vfio_pci]
    ? alloc_file_pseudo+0xa5/0x100
    vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
    ? vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
    __x64_sys_ioctl+0x96/0xd0
    do_syscall_64+0x37/0x80
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Therefore, move the initialziation code before checking for AVIC enabled
so that it is always excuted.

Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 2 --
 arch/x86/kvm/svm/svm.c  | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ac830cd50830..1ccf13783785 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -572,8 +572,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	if (ret)
 		return ret;
 
-	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
 	svm->dfr_reg = APIC_DFR_FLAT;
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c44f3e9140d5..714d791fe5a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1225,6 +1225,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
+	INIT_LIST_HEAD(&svm->ir_list);
+	spin_lock_init(&svm->ir_list_lock);
+
 	return 0;
 
 free_page4:
-- 
2.17.1

