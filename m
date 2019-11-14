Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD35AFCF90
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKNUPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:35 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbfKNUPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBxXP0/MTTM6DQZHBQEha6OVL2wI+S2cQwutPk2M6mGkS7RGi7Y6KwWx0aBPmNk7CUNG7Ee59w4iL+qMxsUsqtL5phM5QPYcoe0EIYv4OOhB5lB56S9pCnUuWFT75/Nh95JrXdU2be0WbkSZ222QC0Sd27ateCLZJrsLiEkH1wHftGKolaO/PAkBZWiIT5YZvX5ZoVxvRnZWAkriprAXDnv9hmhonQWH5K7Mi3B5DXpSsE091jCno7sbo3SV45IozXs6amCC17KqfeZYojbzRNrynYpB1rc77O5DsYExL11HtZQMfgd6HeLEejg7KUveOcxt8gcQgV6SVy3tfDANgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDqC351o0js/cAD46FTL4V92yHTqkl9fm/26NeKosas=;
 b=mooOf2YvtCVHRQa1WQ0TMg8fNG6Sjh+yXe8ys+GyuSkxdnTHLoS2oT2bjwpDGEt+31ircb7XAtrrv8YJ97pgAguhZWBjkHnR0cp3qE4pUQnbVoG8AK/6Y5YalvDl2Xnpm+QONlPjg9QEiLUGLREKRxmmxYznbL4p+k1cv4zHGtIym4Mo/jT2yH/UrFdaJQLBXyAvXGq3eyrGFERnodjLobr/8e69SWwE+IDfmTQt5zF9SFky8SrVdKvh/itPEQrvPFUmnXXhtU/9JGSrnGWbJosF6UGynbPbgQ57kXoxYY3mxbPQBoqCEhEOenDfL+nQGD8dIHvn5mYfPa0+qElTTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDqC351o0js/cAD46FTL4V92yHTqkl9fm/26NeKosas=;
 b=29QKVIUhlbfrEoqwsVDFocWanhjxGyy+WYzgdfchNdgSZmtPL4qELWnbrC0EhZ0+uOntANMvxgrPzVHGK8+I6z2Q5QuB/oB33EGOCYME0CyxWXz0lbj9WE/CgoCWTCh3mfPlOBAw9NzbECtetSDJhfnpE1z+kSNjocaOFb8X9Wc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:31 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:30 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 00/18] kvm: x86: Support AMD SVM AVIC w/ in-kernel irqchip mode
Date:   Thu, 14 Nov 2019 14:15:02 -0600
Message-Id: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c83b3ded-d871-48ad-af91-08d7693f65b5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-PUrlCount: 2
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739F0394876D32638C4CE3BF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6306002)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(2870700001)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(52116002)(23676004)(50466002)(6666004)(36756003)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZbTTViH4D/iZRc5tmyfcP+gKVilS0c1lAY54cwwXrUga8YqHyE4Mw3ZU250TYuu4TglVYh/K6J8sQLpFxXofEIidlp2B73vg+WaGU/evKJMhSFSU3zr4WZL+qP3/QtzHi8Xp+JB4YCh65TDgDubjBXUUJTlnGVI3OeV52oOxoE5pf8hlU6GIe1JRIgy9vGF7k1H2Q3iG0pM3ihthWeZFknxQs7AV1+VdM4iJb2yxM7K5os5ffICeYqOZ90Sa2QjcJbc41YKbm0HYwz+OAtUi6Th1H9MfKv0Jod54kwqGCOr61ATj9BUu5mQk8INHks7s1EhdBS0nkz6Veyr+4xjTCmZmMD+EOyfoqXiM/dpfd1tX4/lAzSvALWuGy5oNju3sW68Qd94Z2utofiPYDQbKwEI9GsbY0ZdZXVpRY3ehw2a4dr4s0Z5GZD4vrGQf8eJkE18DjMctVg1+7hO/AvkdKNJxz7bHL4Dn16o1kGizZo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83b3ded-d871-48ad-af91-08d7693f65b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:30.7855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiwEeXsQewKXn503MiyBqIimbGmCW5CPcGfAsSrmSIrLyyiMdjRZt1JdujADO9QdtKkt94WqoiJ6KS2h+nZa3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'commit 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before
enabling AVIC")' was introduced to fix miscellaneous boot-hang issues
when enable AVIC. This is mainly due to AVIC hardware doest not #vmexit
on write to LAPIC EOI register resulting in-kernel PIC and IOAPIC to
wait and do not inject new interrupts (e.g. PIT, RTC).

This limits AVIC to only work with kernel_irqchip=split mode, which is
not currently enabled by default, and also required user-space to
support split irqchip model, which might not be the case.

The goal of this series is to enable AVIC to work in both irqchip modes,
by allowing AVIC to be deactivated temporarily during runtime, and fallback
to legacy interrupt injection mode (w/ vINTR and interrupt windows)
when needed, and then re-enabled subsequently (a.k.a Dynamic APICv).

Similar approach is also used to handle Hyper-V SynIC in the
'commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")',
where APICv is permanently disabled at runtime (currently broken for
AVIC, and fixed by this series). 

This series contains several parts:
  * Part 1: patch 1,2
    Code clean up, refactor, and introduce helper functions

  * Part 2: patch 3 
    Introduce APICv deactivate bits to keep track of APICv state 
    for each vm.
 
  * Part 3: patch 4-10
    Add support for activate/deactivate APICv at runtime

  * Part 4: patch 11-14:
    Add support for various cases where APICv needs to
    be deactivated

  * Part 5: patch 15-17:
    Introduce in-kernel IOAPIC workaround for AVIC EOI

  * Part 6: path 18
    Allow enable AVIC w/ kernel_irqchip=on

Pre-requisite Patch:
  * commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
    (https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/
     ?h=next&id=b9c6ff94e43a0ee053e0c1d983fba1ac4953b762)

This series has been tested against v5.3 as following:
  * Booting Linux, FreeBSD, and Windows Server 2019 VMs upto 240 vcpus
    w/ qemu option "kernel-irqchip=on" and "-no-hpet".
  * Pass-through Intel 10GbE NIC and run netperf in the VM.

Changes from V4: (https://lkml.org/lkml/2019/11/1/764)
  * Rename APICV_DEACT_BIT_xxx to APICV_INHIBIT_REASON_xxxx
  * Introduce kvm_x86_ops.check_apicv_inhibit_reasons hook
    to allow vendors to specify which APICv inhibit reason bits
    to support (patch 08/18).
  * Update comment on kvm_request_apicv_update() no-lock requirement.
    (patch 04/18)

Suravee Suthikulpanit (18):
  kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm
    parameter
  kvm: lapic: Introduce APICv update helper function
  kvm: x86: Introduce APICv inhibit reason bits
  kvm: x86: Add support for dynamic APICv
  kvm: x86: Add APICv (de)activate request trace points
  kvm: x86: svm: Add support to (de)activate posted interrupts
  svm: Add support for setup/destroy virutal APIC backing page for AVIC
  kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
  kvm: x86: Introduce x86 ops hook for pre-update APICv
  svm: Add support for dynamic APICv
  kvm: x86: hyperv: Use APICv update request interface
  svm: Deactivate AVIC when launching guest with nested SVM support
  svm: Temporary deactivate AVIC during ExtINT handling
  kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection
    mode.
  kvm: lapic: Clean up APIC predefined macros
  kvm: ioapic: Refactor kvm_ioapic_update_eoi()
  kvm: ioapic: Lazy update IOAPIC EOI
  svm: Allow AVIC with in-kernel irqchip mode

 arch/x86/include/asm/kvm_host.h |  19 ++++-
 arch/x86/kvm/hyperv.c           |   5 +-
 arch/x86/kvm/i8254.c            |  12 +++
 arch/x86/kvm/ioapic.c           | 149 +++++++++++++++++++++++-------------
 arch/x86/kvm/lapic.c            |  35 +++++----
 arch/x86/kvm/lapic.h            |   2 +
 arch/x86/kvm/svm.c              | 164 +++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/trace.h            |  19 +++++
 arch/x86/kvm/vmx/vmx.c          |  12 ++-
 arch/x86/kvm/x86.c              |  71 ++++++++++++++---
 10 files changed, 385 insertions(+), 103 deletions(-)

-- 
1.8.3.1

