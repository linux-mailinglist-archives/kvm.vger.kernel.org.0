Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D033E1363F9
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgAIXmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:42:35 -0500
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:38073
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728241AbgAIXmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:42:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQGSA46BrxGsUvRJPhYtUVQhmV6MxHCLepVMxjLgkkaqR2vr4vhGPpveCCdr4Bvn3Vmd5eFPQo9vOFE+lW/Ia6ikzCg/1XLz0hnzrrRa9nAalO8Ox0uOSSgxG7FyMxJ2N9i55BHIKc3VQ4k0KC+x281ZLHjL8nkWgAQa5O8dWaIDDExICiiTUh+Zu+8Yz47sdUKUos2Aq9Tzk9u0Ic5jrU/+ZssrdkKBrodl0p5RU1Epy52gKgSIR18Di6f2unIvw+7M1ST0y5tYTbnpek6tR9BlLQukAPrTjCQKG8OT0SBY9yEuNFhmlHhSQmVgWaK/FSvaPQav+6OcW27XjuAjkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Z3/3+BVYq85rJ6I5WQv1t0AeYjwClFb1bFylfI1Ljo=;
 b=MhF+C54QfsLmIOkNbdww4xEy15n2KdQm5VffstWrLozOFYNtK+5LLOIzUEpU08cH8KYf0mwdMwreO0TOr+iv27nauZ37hzL19lsYTLgSWu7l5K+ectXPt6b3bvdVFLfOvWCvLVa1uyISSOLTNfheRrXroP8ip3kiXPj+pAJGIcZsNGg+MijWqPKne7+9zPI3woHfb/HH967wlfOW5488b7i4AFgw+58HH0RzBV9chW+6HPiWxFi691XWTXbdvvZnApeJinHzgf6AtzqdncVWwFITr3NCahsiVlA//1BX0vEBUZHpkGEaofjKTxZyrQLCeBjRs5u75W5BuO3Mt17qMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Z3/3+BVYq85rJ6I5WQv1t0AeYjwClFb1bFylfI1Ljo=;
 b=iGd7gBdlD8cmo8rSTTPidnZLGjwPiAH2Vp7MIFJvC7GltTKpalZoRFnlAp6rp8mq+eVPXNgUSzfd1nhhPJo5PH6x3IrCG2UX3nCrETFfEe1A6muAdkplBdiwWEbHGPp4GGcmVcKj9ubR2OPat3hGTu21j+Vu90QVqNaSFDRsDik=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from BN8PR12MB3154.namprd12.prod.outlook.com (20.179.67.74) by
 BN8PR12MB3028.namprd12.prod.outlook.com (20.178.210.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 23:42:30 +0000
Received: from BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::19c8:ed30:f4ea:a010]) by BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::19c8:ed30:f4ea:a010%3]) with mapi id 15.20.2623.011; Thu, 9 Jan 2020
 23:42:30 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4] KVM: SVM: Override default MMIO mask if memory encryption is enabled
Date:   Thu,  9 Jan 2020 17:42:16 -0600
Message-Id: <4021c4be45a62e5382e81c22cb130dfeea32bc5f.1578613335.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0042.namprd07.prod.outlook.com
 (2603:10b6:803:2d::16) To BN8PR12MB3154.namprd12.prod.outlook.com
 (2603:10b6:408:6d::10)
MIME-Version: 1.0
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0701CA0042.namprd07.prod.outlook.com (2603:10b6:803:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend Transport; Thu, 9 Jan 2020 23:42:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33ebf1b2-5398-4b3e-b25e-08d7955d9737
X-MS-TrafficTypeDiagnostic: BN8PR12MB3028:|BN8PR12MB3028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB30280F52F4915D4C78E8F0CBEC390@BN8PR12MB3028.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39850400004)(346002)(136003)(199004)(189003)(956004)(186003)(6486002)(81156014)(52116002)(66476007)(66556008)(7696005)(16526019)(54906003)(316002)(26005)(2906002)(2616005)(36756003)(8936002)(66946007)(4326008)(81166006)(5660300002)(8676002)(478600001)(86362001)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3028;H:BN8PR12MB3154.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqC0bf5tLdyjsOr+gHJUPXiK91Zc0Ufxo8NksrB6inyXY2Mxa9BkLz/b7EuRAU4wTEai8lJ6GmYFGaZYHUJuXuzxjkayuiR0ouoVDUWmpBAQUjy8vXb/zYRnao0WNaa0MWMtKSpUjYk4YnP9Sg0OjpFYuQcJVtapHZenERc7K4YBIPSA8GdEvxoMmDAP+KruKmgySbX9KOpM/PHWAfo4VGETzl5kTIIGnwZ5Ec1U/lTDtiDg+EoHFw5bMIzZ0oLFlL/JP3P8Moa2JQhEJxuJKCC1NZuLbsV1vjV+c7vhFWNdsLCfCewemPUioFmwtoQKXzxioJtYyVkN11Lmvo482oSRimmRP+sn543urFbEGt44vxi0Hg9xYMul9+DcID3y0wgcVM69zLu/rZDVxh1Sx45H98V7xQ8PvZH2UKH10rZkf0ZxEo52RGgY/eh5BQr1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ebf1b2-5398-4b3e-b25e-08d7955d9737
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 23:42:29.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqpxh5OQfEu1sEQYxerbJMdMwIaQ3QYAevRxihve+8Z9jA02a5FvkDfQxyj4gDmg0LYAJR6UY2w43tKIcatwEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3028
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
faults when a guest performs MMIO. The AMD memory encryption support uses
a CPUID function to define the encryption bit position. Given this, it is
possible that these bits can conflict.

Use svm_hardware_setup() to override the MMIO mask if memory encryption
support is enabled. Various checks are performed to ensure that the mask
is properly defined and rsvd_bits() is used to generate the new mask (as
was done prior to the change that necessitated this patch).

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes in v4:
- Use an MMIO mask of all zeroes if no reserved bits are available.
- Use the PT_PRESENT_MASK define instead of hardcoding the bit
  position.

Changes in v3:
- Add additional checks to ensure there are no conflicts between the
  encryption bit position and physical address setting.
- Use rsvd_bits() generated mask (as was previously used) instead of
  setting a single bit.

Changes in v2:
- Use of svm_hardware_setup() to override MMIO mask rather than adding an
  override callback routine.
---
 arch/x86/kvm/svm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..9612364267fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1307,6 +1307,47 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * The default MMIO mask is a single bit (excluding the present bit),
+ * which could conflict with the memory encryption bit. Check for
+ * memory encryption support and override the default MMIO mask if
+ * memory encryption is enabled.
+ */
+static __init void svm_adjust_mmio_mask(void)
+{
+	unsigned int enc_bit, mask_bit;
+	u64 msr, mask;
+
+	/* If there is no memory encryption support, use existing mask */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return;
+
+	/* If memory encryption is not enabled, use existing mask */
+	rdmsrl(MSR_K8_SYSCFG, msr);
+	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		return;
+
+	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	mask_bit = boot_cpu_data.x86_phys_bits;
+
+	/* Increment the mask bit if it is the same as the encryption bit */
+	if (enc_bit == mask_bit)
+		mask_bit++;
+
+	/*
+	 * If the mask bit location is below 52, then some bits above the
+	 * physical addressing limit will always be reserved, so use the
+	 * rsvd_bits() function to generate the mask. This mask, along with
+	 * the present bit, will be used to generate a page fault with
+	 * PFER.RSV = 1.
+	 *
+	 * If the mask bit location is 52 (or above), then clear the mask.
+	 */
+	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
+
+	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1361,6 +1402,8 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
+	svm_adjust_mmio_mask();
+
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
2.17.1

