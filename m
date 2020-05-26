Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE01C2452
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 11:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgEBJZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 05:25:08 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:6070
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726488AbgEBJZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 05:25:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEN65vG+7qnWUOMPMRJtDyDlt+K79CwUUeddvvMRktvQICkdY+6FzTAM1DedpdXpjqf8Bx3vIRn/hcI0rVsHS8PvC4qRU4a0vn5617dprYTC4UWv3IKMwcPD+TcWYf/QFZmilYogL63p58a0uzFBkfjELwuIfVpo1a82EYYgCI+DNi/AFNUZyncbOKZo+nhyZYC/9wU0DZko0JMjpz4g8nVzrfYA9Pf8VxskQ0sTOr+7nieqjknvB+nTtSzGLIz24vH7tO5XSAlwL2V8tKPhJkRNI4X8CYhTNdmmyyTA4fQEE3mV86bl5zRvGaOUo2B2Jv/6hkvm+UZobMeFu5xF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJejiRr8Xs88REwngCdKafHzmG56UtE4ZZYx7Zkph6k=;
 b=T9o7/24akZqH847zu8FFBUA8B94qxpwKnfPfEckfYW+SKNUvyaiHVAEvkOV/mxATpRimikExNCw8tdxNCWbWOxsY9NywIZwgFoZz5xBgpuAeuGkTNd95MkzE9n9iQhU5mrDmOzRZEMpl6kqT7eECyll0OhuAqwMINuSeHscZNoCB56KGyovjrHCRO2uCswfqSDGYjGWRKsj4Ql+3lJkVm3Xz8T/OcRdCPghWbbebM+PEMx7GcXE8C/6HqXakOH7BlfRzrN/37phT8ivUp1/9HighcfEEwxwkuwxLNuc9Xvkv8jrS7FpVddFaLm6LvUgr+yfcrZPr66fIKORgWeduZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJejiRr8Xs88REwngCdKafHzmG56UtE4ZZYx7Zkph6k=;
 b=W17IrbT3peb60RM7G6nOxet8g6mTG3jNyPUbsZBcYcrQArO2s8hRxoHQmqEfmOS15vMfDX6d7PvzKcAN2LHaToCV7zawH1KczQmHIFRmZfI7R/puksUHgYV3dbNPpOnoC0HfwvfA5+kPijfgdAxbEywoAfPn9LEo3b1HzeSlhu8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1625.namprd12.prod.outlook.com (2603:10b6:4:b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Sat, 2 May 2020 09:25:02 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2937.034; Sat, 2 May 2020
 09:25:02 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        jon.grimm@amd.com, borisvk@bstnet.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2] kvm: ioapic: Introduce arch-specific check for lazy update EOI mechanism
Date:   Sat,  2 May 2020 04:24:55 -0500
Message-Id: <1588411495-202521-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0025.namprd07.prod.outlook.com
 (2603:10b6:803:2d::22) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by SN4PR0701CA0025.namprd07.prod.outlook.com (2603:10b6:803:2d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Sat, 2 May 2020 09:25:01 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58d32d48-8f49-4bae-8c43-08d7ee7ab124
X-MS-TrafficTypeDiagnostic: DM5PR12MB1625:|DM5PR12MB1625:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16257633ADBF4A27A223B709F3A80@DM5PR12MB1625.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-Forefront-PRVS: 039178EF4A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(8936002)(66946007)(16526019)(2906002)(15650500001)(66556008)(2616005)(66476007)(36756003)(186003)(316002)(6486002)(8676002)(44832011)(956004)(26005)(86362001)(52116002)(7696005)(5660300002)(6666004)(4326008)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20ZUizVh01Q2X94KXX1NyitCGEJ/rrj8MAOHYe0bLyP01hQ22mQ1W5qmWcvEaxDrAG7TrQ5HBNR5UUOjdUpuNLhcmYtnE9GUBwQhaXv0AmDxHnUQI93DSgpfQNjYnz8lXnxtgxg+tm/rz1xwbP8Tf5Kpmw66QLzSsyxDiVPrGtbXugsozQ6xMTEjpy00fFh7+NzrwRXm9CVdWrSe1ZKnRQTWvK+VduSo4nRaG4P3pBsWa6Z+L43kEY8qowqe3H7UxEDphy+I8ePzvqMlf6Cab7xG99t/O5sT6LTmUjD5Avr3qvkLTUkktXbNe6W0oNLN0droK3TJ1YPcBp8TzuUYCRx9p+L/DqNj/w6cGeN0ZFqa8thB3UGczvFcqjsPDGpPp+c3C0AZnvQ4Vh2ey3ChB8gktmfHqcWhxhRmFbOECiEZ7BEZ7cvuiPWNa1/RpZS/SuPLPHM9niYpwiHyuxF9z/n4HjtHNx9VMWx8uyyvDy6rXgKPm3iVEL2Pv73FPx0pVDHMg/ixEEOsivAloymxQg==
X-MS-Exchange-AntiSpam-MessageData: WZlTGTa6wnLwsuUD+ApuL3ZugizXE9LYors5MfDr+Z6lr76qr+IQnMVz/QdUitA6OBQIgZid/uY+CzaXxUZweZj+LDMlMTGvThEc64XQDkiO/SCBTc6cDrPKjZmGB0tFN33/2whgPNqY1Y4FgHx2WLv8TIN9f1iD1zBn2k5ZQM2UdKcqf9awrnS/eKCQRI9dK/+OREX+Cp3s9iVBqv3UohLLnZGmC1cYxODTSR0aTHhbE3h8CK0humlu92Mf9Ex2B4e/lOGadlXqnr6TXbfHMCVMab2jYnrHibqEKv4WKzgdck8hZDuWMISdQi1LaTL8IovvjbPb+3n2DQeq3BMvq4DeOpOOA/FXGLRkexXBG9p4vx+im/B+jSRUtQwsSJntLVYo/1AsrUtxPTwTlbIDfhw8Y+aqY53B6pUsgQ0GdxxC9l6FLbufjnUomkXfXj0/GR8Rrb7zBMM5TpjJ2C8w3SO07YKJTQfRtGgASEhGcK6zz5WfXOw2+vsyjEwwI+ptCVmOsg+pmb1vUtKEhmAb1mu9bd6RAlKhVRnjM78q+MHylocEKUpHn2DEpXrp/GXY1Iux3mhJ5uLei+46UqBFKtAvoMwFaH5lY3NdIX5MzJKu6W9VN3SEQ1VS3OehT8YK/xtdXtJoABdQ20hpDfVN8siN5j7YqkX3HUcgRDUIZCoQx3NEjwWKKM2zXNvwW4p6u8jwmJ+JcGWyJz+CgdzATi1jFJ6qja6sc+ca2nB+0cPGwaa/gmao9ZoWhX8VPyKjsTCaPFvv5Xsy5mkjyBnf1xM2OphtKx19FA0posVXKLw=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d32d48-8f49-4bae-8c43-08d7ee7ab124
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2020 09:25:02.4356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2f5NXZupxPDVZ2/6tq6gOVPQP9S3VRV0ndT/klLQ1f2IUgKLLkZZIeTdsbUs2tkGEcvXm9XlLF5+vObn/9aEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1625
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
the following regression.

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

This is due to re-entrancy of the lazy update EOI logic
when enable APICv with VFIO pass-through device, which
sets up kvm_irqfd() w/ KVM_IRQFD_FLAG_RESAMPLE.

Fixes by adding re-entrancy check logic.

Reported-by: borisvk@bstnet.org
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://www.spinics.net/lists/kvm/msg213512.html
Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207489
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 11 +++++++++++
 arch/x86/kvm/ioapic.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 750ff0b..a68f624 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -188,6 +188,14 @@ static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
 	struct kvm_vcpu *vcpu;
 	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
 
+	/*
+	 * Re-entrancy check due to KVM_IRQFD_FLAG_RESAMPLE can cause
+	 * stack overflow where irqfd_resampler_ack() repeatedly calls
+	 * ioapic_set_irq().
+	 */
+	if (atomic_cmpxchg(&ioapic->in_lazy_update_eoi, 0, 1))
+		return;
+
 	kvm_for_each_vcpu(i, vcpu, ioapic->kvm) {
 		if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
 					 entry->fields.dest_id,
@@ -205,6 +213,8 @@ static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
 					  irq);
 		break;
 	}
+
+	atomic_set(&ioapic->in_lazy_update_eoi, 0);
 }
 
 static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
@@ -707,6 +717,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 		kvm->arch.vioapic = NULL;
 		kfree(ioapic);
 	}
+	atomic_set(&ioapic->in_lazy_update_eoi, 0);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 2fb2e3c..898a967 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -91,6 +91,7 @@ struct kvm_ioapic {
 	struct delayed_work eoi_inject;
 	u32 irq_eoi[IOAPIC_NUM_PINS];
 	u32 irr_delivered;
+	atomic_t in_lazy_update_eoi;
 };
 
 #ifdef DEBUG
-- 
1.8.3.1

