Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289F71B6D05
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgDXFIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:08:51 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:15676
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgDXFIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:08:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqzRonsEAzTAqQ7hmAvA4i4lhTKmBedvrC8AwVYZWLHwYmBw0qJzTY7vMYKfVLmrcwwyxg53cbgeBZkjgjGD6OwUUlgYk9invoiXM6CYm10E5UB33eIxNTCE5OPGjeb1VwcxvdQd7RnzvKukfiofN20BaUF+S6WJwNC22cydxa0Ja+0nQNuixb+K5PQMNPodMkf0Bt7iqLSBDZNOtZQK6GD1ppvzIDKkiPXk+fOufxj7LOK4cgg0S4VNQn4Hmok+FuQ867D2WuVwoizugAHbNKvqeZcMTeEleMjH/QnOb8UFbQpl5wcNCEfkAUC8PkcK9t95PcUj2HZl8D0lLQM7FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP2CZ7pzXxK0RMTbJf8T6eEjCMMjTv9AVYwT14Rf+/I=;
 b=acPuUYllbZ/zONZN9M6FMWGA2W2Upb3S/T9vMls3g803GoSn+7McWQpcgSR0Hp55V9CY7bBoA37epL7a0fWOoK1WNaycqA/0RfacpqH+R/WPk2U93NcZ3u4ufw1aIEPhBovHrD5aeWfvxTAGtiz4/uBixCEfsA4v40++4f3hd3CJhsxKNsYBDUBfsj1lv/Fro83hTEuJQlK0oS1ScgtJMjc6M6gqdJFtWHXkM+xhBbxjPng3fwr0+KiHc4P8Kc8jvfSDZ/4h9/9zBZoa0KDrZA57k1g996qPulAGVrctNW8tT7QbS9A+GgoKVTL0EnFe87ZH3k/r3aDQGqKyoGPuyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP2CZ7pzXxK0RMTbJf8T6eEjCMMjTv9AVYwT14Rf+/I=;
 b=lFy/OICpliSgG8ldYAyuC8//sxxOeScu/EzYtzBkyHw8NmCy/XpitxfO+UI+OAw1OBfSBBXzg66XN7a2KaT0hktOADuRmVihvULykAKxFU5THfkBdQ4nSlDEddQ2g5teUAH1chRZcCWylWjw4E0ZQ2Mtf6DRSWoY3XejIr81cpQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB2423.namprd12.prod.outlook.com (2603:10b6:4:b3::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Fri, 24 Apr 2020 05:08:47 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2921.035; Fri, 24 Apr 2020
 05:08:47 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        jon.grimm@amd.com, borisvk@bstnet.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] kvm: ioapic: Introduce arch-specific check for lazy update EOI mechanism
Date:   Fri, 24 Apr 2020 00:08:30 -0500
Message-Id: <1587704910-78437-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:4:ae::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR07CA0104.namprd07.prod.outlook.com (2603:10b6:4:ae::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 05:08:46 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18122522-78fb-4538-0981-08d7e80d9195
X-MS-TrafficTypeDiagnostic: DM5PR12MB2423:|DM5PR12MB2423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24238EB315CD373C607495B6F3D00@DM5PR12MB2423.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(966005)(6486002)(8936002)(8676002)(26005)(81156014)(52116002)(478600001)(7696005)(2906002)(86362001)(186003)(16526019)(6666004)(316002)(5660300002)(44832011)(2616005)(36756003)(956004)(4326008)(66556008)(66946007)(15650500001)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUUxStpv4e7ynDEbCwaNKQ/b1qEylmx20p8uU5c7BeVi3yR4Wt12KwtlGYcuIYR+cQqXlUSCxQ+zVT47Obwr8xQDnz2MhSFfAAIXEq9i2zHXg5LRJtqubr7P2t314NNKt3XJqhbZK4zxlfD5lkxhDg5ob2Zb/Vg+9HSsDri6qQpjQ+aqtpj+xL2j87Dnc90tnhwjthSqat9mN1+KM4LQa0SaKbHCZXxQulJRhiHfMaeaL9ZlSjK10U5rg/hSBhviBl5RZhaKR5Zqsewi4J/F5N7w0gdXIxxAdnF+tPZvOdVbm8hlItznR65lgqu9F5KiuXj93MW9M8qHugnmcmFkA3lMrOmFvxWll/5fo8CWFXMHwVYBRG/l8ClLq4hgE7hEMiCwNDy7HIYl4af+SUJbkuCWRgnYtxLRINM498087y4D8n9MRtomO9nvbkdQGqHBnCSXuRRS8itfeeVX6NaZSCenF/lC/BzNIWyimGZhzVAjgqIUbiNzb/uy4+BgKQWLw4fgmz5hvWuu9RTGPIy//g==
X-MS-Exchange-AntiSpam-MessageData: ZMty4Tj2xP/AN0m7zveIV2BBdz0F3Y/oljBtyTvi2j6V3mQ6fLH3mc1fJq7qPMbIjCFoAxO70LPPoIC+zK+VnQbZe4kX7ae/bVcgP9NxMGJxIecn9SGsV/dVcrLKTISbYr+J8WmSBrpLJKlxSIrG7A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18122522-78fb-4538-0981-08d7e80d9195
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 05:08:47.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nFjPUZ7oiUcwl+oj8iZkAXW7neVtul+gKCLnjBOD2/ee7dREPBl//ubwKQpwcZQZ5q310NJpkpqVepsSgm7hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2423
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
the following regression on Intel VMX APICv.

BUG: stack guard page was hit at 000000008f595917 \
(stack is 00000000bdefe5a4..00000000ae2b06f5)
kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
Call Trace:
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
....

This is due to the logic always force IOAPIC lazy update EOI mechanism
when APICv is activated, which is only needed by AMD SVM AVIC.

Fixes by introducing struct kvm_arch.use_lazy_eoi variable to specify
whether the architecture needs lazy update EOI support.

Reported-by: borisvk@bstnet.org
Link: https://www.spinics.net/lists/kvm/msg213512.html
Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/ioapic.c           | 5 +++--
 arch/x86/kvm/svm/svm.c          | 8 ++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d..eedfb15 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -982,6 +982,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	bool use_lazy_eoi;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 750ff0b..94567c0 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -228,9 +228,10 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 	 * AMD SVM AVIC accelerate EOI write and do not trap,
 	 * in-kernel IOAPIC will not be able to receive the EOI.
 	 * In this case, we do lazy update of the pending EOI when
-	 * trying to set IOAPIC irq.
+	 * trying to set IOAPIC irq if specified by the archtecture.
 	 */
-	if (kvm_apicv_activated(ioapic->kvm))
+	if (kvm_apicv_activated(ioapic->kvm) &&
+	    ioapic->kvm->arch.use_lazy_eoi)
 		ioapic_lazy_update_eoi(ioapic, irq);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379ba..b560319 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3882,8 +3882,16 @@ static int svm_vm_init(struct kvm *kvm)
 {
 	if (avic) {
 		int ret = avic_vm_init(kvm);
+
 		if (ret)
 			return ret;
+		/*
+		 * AMD SVM AVIC accelerate EOI write and do not trap,
+		 * in-kernel IOAPIC will not be able to receive the EOI.
+		 * Therefore, specify lazy update of the pending EOI for IOAPIC.
+		 * (Please see in arch/x86/kvm/ioapic.c: ioapic_set_irq().)
+		 */
+		kvm->arch.use_lazy_eoi = true;
 	}
 
 	kvm_apicv_init(kvm, avic);
-- 
1.8.3.1

