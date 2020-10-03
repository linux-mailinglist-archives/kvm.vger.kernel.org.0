Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D132F28275E
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 01:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgJCXXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 19:23:24 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:15009
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgJCXXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 19:23:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVbEtIgDvMpzgz+pGu7uwZ6gJHR1E9oPyYpSE+qN6TDTHA5cyoiWFo+Ifn3uOb24/A+HpF2U/WHRKtd9/DUTvk8T63cqg6BJUwRvaLsuSZM66gXSa/Md3nelavcIDgY/2yMeFIpWudevjghu13zRYqMHSg5noKJj6Pd1fmvYr52wdNhngkCiKtL8w568Y21ioNbXxbEJxy45n/7Fo5kgXmLnBLSnEy0nB/2msUdCv+j8iYbAxNjM8n/VXpasb3xmyUpjuonmX+EdcVVr6+SL9GwdBqJZ7n8uhxPnX6WZQ1vE5ubhUcEqNR8/Q9NQFKoVeWoXwBLPQftCJpRGZt27iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mL1Fj0rAt2qvrjO+Gsi9SkW1HrZcZzq4rzEBp6dJdY=;
 b=UEnAGFAnBzEcjyPvqa7Evoo7O0BROhNKLKUIVbcokpviXZXGqrWD6mqTdKhtLbf8814ZRgkFmr4HPKNdP5TQJVmH6ma1Yr1tP7s4gqOij6Lr0prZAbkJUL7lYv0ja5HVZIQbD9EXiHzjDU1Xs6IbX/NJ4j9iVZJn10JTYrThk3DrauJXht/BDUVaXH3bR7+HzEGvAxzCXmG/2TkQSSoc0AOMISB4Aa001b0n1XH0sB5lWDIAXn8OP16DZ+dNRIXKrfZoXxiKRETu+JB39FZWoTW2tspPrBVmZ8LRqEyPLR2mzBFLWaISi1EvMUkU05XvTrsU8PGWUKelBHgvr+bRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mL1Fj0rAt2qvrjO+Gsi9SkW1HrZcZzq4rzEBp6dJdY=;
 b=HTU28bfLCcDp2oBuio1TABWhmJFwbk57uk0r46gtem3y9/hS7Be+DzfZ1xq/mqKFllab4SPUl1zNgc6orbHkya3KhfAe7jJimaCAXIBc+ozj/1Gml0SiLQTJw5dcwDmA+c1DCYv/sGZmbjOyWLYV9GRRheHYpQOOdyb1DuEdVjU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.36; Sat, 3 Oct 2020 23:23:19 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3433.042; Sat, 3 Oct 2020
 23:23:18 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Initialize prev_ga_tag before use
Date:   Sat,  3 Oct 2020 23:27:07 +0000
Message-Id: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: DM6PR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:5:174::16) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ethanolx5673host.amd.com (165.204.78.2) by DM6PR21CA0006.namprd21.prod.outlook.com (2603:10b6:5:174::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.10 via Frontend Transport; Sat, 3 Oct 2020 23:23:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 479774fe-45aa-4229-a025-08d867f34f93
X-MS-TrafficTypeDiagnostic: DM6PR12MB4219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4219708600E0B3AD56E046A6F30E0@DM6PR12MB4219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vDmW0j7DqiarKwTMOgd/OR4hYMbLvwu/4X68u88RhsTK//onVIILhuhdvmULsoa/csBBQep69QTwgUS64/kdftMgUlGYXyRV5mwnB4Pw9I5sOS24sh/PvIyMCyK1ulY4+wuHnHUu0C+pgMoPwT/m90ZCJ+iyMlyHuyiBmH6VI0H5lJEq3hXUcl6hy1TmYCeRPplLxseY1F6JkHNKgc2U9M4soL1FXVG/CneKfPqMnTq5/DaGvEzaiWbL1ZT7QFKIUexAdz/bAOI806yIcTP14N5VPhWFZz0QefPc7bgJqLwgpC4PriWwSQlNKUZNP77
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(376002)(39850400004)(6486002)(8676002)(5660300002)(36756003)(478600001)(8936002)(44832011)(6666004)(1076003)(83380400001)(7696005)(52116002)(16526019)(2616005)(956004)(66946007)(186003)(66476007)(4326008)(2906002)(66556008)(26005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I/UFu/TdwrDGlTmBjh/r8x88mUUX2QAu8zGhVYUeX7fdJvUac5WomDINm9Io8G10VEqXfoEBXFgzZ3ML8dz3JrPKEi7weqZQR2jIRFHAELUgrWpOn7ibzIEj9b0r0+z6Bij4dGqA+c2mPkZ5CbYQMr+vcT6mc0Rhlo74kalHgp2LM3MVepqID6UKqacdjI1tl93IPecT5v21JuCo9d2xhzZj47jX3Bd6ucIOccKqP8zcqSUtHQ/arBHYiuEX5hqToEjLmdvAcBCi9K75NQ1eECN7a/xQebCoiaHFJJ9LbFOBunbB09ZQy4FGOJ7gB2iNYK1zQlN31mKXNJa4JNkMhEdZini+6DcTuO5vOqzipYoyqn5muFTc8zysv0v03tj6CrhVAC1TYuHmWTD+H8atzXUG7i8RWTaqmA12g6k696frbFLMdKb98hFX9d2z2RnK7x8IcLjLk8fxyBEq06zAWfqS8ZoJ0PnAP2cX6xMa9xS6UQckNklqLg50SF4vd5G/9JqdMZnyxFa25a2tgPlbhZEDpAUOsGKCkBhhoVKVboRc01HeCik+Gz6g3Awy0HP70yXOLCJmoPanBXL2cRgEFcy+xB5t7HdzDZ32rw5w6ifBUIvxrKn307hjm4ouiTs7hqvhznypriAlt/TT0St17w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479774fe-45aa-4229-a025-08d867f34f93
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 23:23:18.6672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHWp494HFZESrQKZNkd9o2GQxc0/0Na3J7G/bx8pgsDmm+334sreA0PJqfGmDJpqtXn4hsCMf1TA9UOgN2R0XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function amd_ir_set_vcpu_affinity makes use of the parameter struct
amd_iommu_pi_data.prev_ga_tag to determine if it should delete struct
amd_iommu_pi_data from a list when not running in AVIC mode.

However, prev_ga_tag is initialized only when AVIC is enabled. The non-zero
uninitialized value can cause unintended code path, which ends up making
use of the struct vcpu_svm.ir_list and ir_list_lock without being
initialized (since they are intended only for the AVIC case).

This triggers NULL pointer dereference bug in the function vm_ir_list_del
with the following call trace:

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

Therefore, initialize prev_ga_tag to zero before use. This should be safe
because ga_tag value 0 is invalid (see function avic_vm_init).

Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ac830cd50830..381d22daa4ac 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -868,6 +868,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 			 * - Tell IOMMU to use legacy mode for this interrupt.
 			 * - Retrieve ga_tag of prior interrupt remapping data.
 			 */
+			pi.prev_ga_tag = 0;
 			pi.is_guest_mode = false;
 			ret = irq_set_vcpu_affinity(host_irq, &pi);
 
-- 
2.17.1

