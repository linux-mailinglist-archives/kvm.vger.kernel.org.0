Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E88CFCF7D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKNUQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:02 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727376AbfKNUQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:16:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksZMpSzws++mLcxpWUtHg78MliD0uW82c2wK8FF6PxOolkZe8Sv0ycJPkOOE70W5llE1d0RCW/XZQZ2daiGRyDYxhVt51osTH1iFCtFwKQnX5Z9HpzNnwcDPiF5T6rFeA/h98EZk5JYNwCN/7uujniNQZYr4LJ4z6JYxgN0/+rSBZDf3BOEerPHW1JRBkEfHFib87aDaeq40Bjs1+4xnwq/7H1bfh2LMXrsBiGncqSYE5veBl+XuaDuhPJyl7lhK8E6VFRDBmNKDSXs97DXPaF0KEI7AHgIsAYUBpi5WnzftD6bCt+euZ01Yu0ep5NJoPGUP9YgceRHgnnJPdLnU6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in2c2oqomICKmMiDAAChPpgw0LoyJpyyzKCa2WUMrs0=;
 b=RYlbJLRLr7LV6qhqnCCNlAwh0k04jekdgxcFaJ3oWb2I9SeUCKxF4nOccpo5yP/rrHY67bXFxl7KdkdaH7RGS4Q6YFTIdEW4T4c0t4Qwrr3h+T63WFbaTNkLwc5o+2LWoXnIWsJZm6xwAu8GK2t33Z1jkZcFUMNvXOetwcf25BAj12aBdlKgc8HSpWdkZBVFb7sdTxeTdiDGJ++XIpHbSmPdGHRfSJu34p/YkxxINgl5R/TPnKA01jgxyHrbmRe3uG0cXD3JXh8+O2RLjMZgVp9N+l0ytnAuJwJcScjUySA8I+gkqGusL10UiT3R5c6zcpnuyXzsJYg2IE3+PSbUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in2c2oqomICKmMiDAAChPpgw0LoyJpyyzKCa2WUMrs0=;
 b=2jS+2i2rFM8RQclgxpnitiW6hT4pzTmxlt+dimCHOQt7RNrUSke/3HoT8sFHbDubh7RJzGJ9hVNxhidhDKlgPqJgzXLXT7lI3omXQUdh5kHW4fPjMZSvJy0O1YP7uFWEvmlnZ+NtPJUXbfSuLlKJqi4BZsLMlPuUEkfRYXMZUYo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:53 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:53 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 17/18] kvm: ioapic: Lazy update IOAPIC EOI
Date:   Thu, 14 Nov 2019 14:15:19 -0600
Message-Id: <1573762520-80328-18-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65676e57-2584-4393-786f-08d7693f7305
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739105FF8039504560FE102F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(15650500001)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJu0zI85sRTNzOX/eOYiZIa5CDHMAwq2+6DXWXAEwcNq7aEhtBcvERaP6igc61zqA2zXTIPSu7rhPRcT7dnSdvsXx097h1cAYWV6KvKuyR3JSJT8KPQ8tkmqCJ0DgzCtQDpoX/fqk+CIPlvTsihqQLvMXQzFY3X+JgIAb4MDvL0WSNsjwK0kTGL8s3JgoCrb1ftgFdrHCINcjCScICXi/sP2Xj1ieGB3D8T3Fj9fyXd0YJbuJSvDDu4VlH8T7q9ailD664cyrfcz1WnL5igpO0UTIOm5ej+p+DO+xBN1/ty9V0YFwlTjaKFuFe8P4ddC1UwctjJ5VelpE9JjrmDZW5SZKcnFhaXmFpKFcC4kKWZ7BVYeoJLx3+OzrQbKg7YkYQ+u/9NhbQAsHvRue0fXstFfyzhEMVQ6C25cxqU2jf6TaNgS3Pl4/X2wc0+zKs/0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65676e57-2584-4393-786f-08d7693f7305
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:53.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmrDjBzzTdZxxv7mV6wQkfPGgMomAY9jY9eNkkzOjWVY+NqQfeNqEOb1sHdGR/U8fcqiekjyj87E3F3zwECCHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In-kernel IOAPIC does not receive EOI with AMD SVM AVIC
since the processor accelerate write to APIC EOI register and
does not trap if the interrupt is edge-triggered.

Workaround this by lazy check for pending APIC EOI at the time when
setting new IOPIC irq, and update IOAPIC EOI if no pending APIC EOI.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index c57b7bb..6fdd88f 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -48,6 +48,11 @@
 static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
 		bool line_status);
 
+static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
+				      struct kvm_ioapic *ioapic,
+				      int trigger_mode,
+				      int pin);
+
 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 					  unsigned long addr,
 					  unsigned long length)
@@ -174,6 +179,31 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
 	return false;
 }
 
+static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
+
+	kvm_for_each_vcpu(i, vcpu, ioapic->kvm) {
+		if (!kvm_apic_match_dest(vcpu, NULL, KVM_APIC_DEST_NOSHORT,
+					 entry->fields.dest_id,
+					 entry->fields.dest_mode) ||
+		    kvm_apic_pending_eoi(vcpu, entry->fields.vector))
+			continue;
+
+		/*
+		 * If no longer has pending EOI in LAPICs, update
+		 * EOI for this vetor.
+		 */
+		rtc_irq_eoi(ioapic, vcpu, entry->fields.vector);
+		kvm_ioapic_update_eoi_one(vcpu, ioapic,
+					  entry->fields.trig_mode,
+					  irq);
+		break;
+	}
+}
+
 static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 		int irq_level, bool line_status)
 {
@@ -192,6 +222,15 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 	}
 
 	/*
+	 * AMD SVM AVIC accelerate EOI write and do not trap,
+	 * in-kernel IOAPIC will not be able to receive the EOI.
+	 * In this case, we do lazy update of the pending EOI when
+	 * trying to set IOAPIC irq.
+	 */
+	if (kvm_apicv_activated(ioapic->kvm))
+		ioapic_lazy_update_eoi(ioapic, irq);
+
+	/*
 	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
 	 * this only happens if a previous edge has not been delivered due
 	 * do masking.  For level interrupts, the remote_irr field tells
-- 
1.8.3.1

