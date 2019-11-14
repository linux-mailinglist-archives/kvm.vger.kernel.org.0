Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A262FCF7C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKNUQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:01 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727349AbfKNUQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:16:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A02332WxZ7xdkIYjXrRXLjA04BuhkcpIV1UVHGQZoKtt9qFUlFb6GHUz5MPg9MAY+F3gXeCBUznEoru9elkCOsMnNta/ikedLMGXuhDSQ17o62eaA/2GnfEZJiMKWCTeMoGWzPT3gYzbuKe3YPbCaeQ4mgEBC6zjIxxX7upSDDpcAXw6SvHgS50Bc04KQqZlsv8oXMN1J/HcPehA/2w3Cb5O4fhBOVLdR0IlZUuvgVYszz+wrtw492PpadEhtDxPu83dsciQi9C7ZkSgFF8N+ibdlong6RzkoD3FxuzoEwh3i7DQ3qT26xgmtwnPj09axJv/Hr4CUkNQe2wD996T4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJBn2GlcYkJAVIlKzhAlyHeF9X9fLX2uQAz/v0s4czY=;
 b=T/7FzUoAomrKHlgvpk0d6AesjcGkQqFxCM0zD9o3BHydMDrWnewaz5aHJTGX7LMNEaNjkP8WHv9OCElTCzxIjsUgrmMc8wPhePMMtGdAhS3T1P+JcYLKNiH59DXT/NYBB414/S7xFpzLJtmEHX/Y24JHr0cOm3CcEXYMePBQSRLgeLdBTQdar+z0JzzDdMm8GjdfG6fjf+7OpSIt+Nh6+oe29TbYWvh2p9IZuaT1pEgnWPbm9FqaHOW55sDhqzmIx9C7p/xVPlJw7FUrg5yGT+JjfqdrYF3Rdy0zt2LeFtzeGpxRZ7H6I9/CBxqHkJ5xphRNEfle1eQHXZqu+7+8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJBn2GlcYkJAVIlKzhAlyHeF9X9fLX2uQAz/v0s4czY=;
 b=MhEjX6VGdl87mYFpSa5nUKj5D0m3fVqm4pZD84USnadCfI5Fqrs9l50rLT4vAb6R8g1nsVFqp/wP7gOXZVkznDUgvvPX3CsJI7lwgQ83Tt8pFXYlJD3FA2Z0gpuHwfV9mD1y9OMo5k4y8W3oUUtyM4pjeLVBmE6oyls96jYaFDQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:52 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:52 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 16/18] kvm: ioapic: Refactor kvm_ioapic_update_eoi()
Date:   Thu, 14 Nov 2019 14:15:18 -0600
Message-Id: <1573762520-80328-17-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c8a1c566-9ce4-41e1-23ab-08d7693f722e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739C3E50050FEEF112D8542F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GoB1+GQpKW0/ojAIrjFFxZH7zG/pQzphBP7Bh57B2mt1fYNSWFqgT1UgDZx+BLjwKzeWgIt1VEOzyG9XGzuhNHZyWm/2QTUskr+BhLkJvASsfhAIuczmJwSpJtgAOiR8h4BG+NOMihJYLkhVzT7iKoZfGd40AgL/uuyvBNN1kz201KkqoKGZAlpeGfSs2E6P8MGUha8V81qWJ77Sf3R3+jSpTinXSDqrLda221c9KvXreA9nRxX92g3VvF6bNnp+c6E0SOp2H+FBjcfMhRaPRzkLR59Q0ZheZzUKzquEPhRwVe7zRFz/wIf3LJXnvIF74EvWUlU6KOzyfX/Gsvwst7YOFVuwWUJNkG4kiPZPQR/A0EyHqZlph4aiOlnMH/frVV0qey0XkTrRap7slLQTe9amTsOkhFXzJ9oQWn4t5aZPhPKCLChuC5595wbXJ9ME
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a1c566-9ce4-41e1-23ab-08d7693f722e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:51.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO6yBDIPwpaKrpr29d/1Pa5zmo8lFeMEiSeVUZ24pGOHSL5cn8JppeyEvTvvYR1PNAIqPiCFyMAbxnSZUNTToA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor code for handling IOAPIC EOI for subsequent patch.
There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 110 +++++++++++++++++++++++++-------------------------
 1 file changed, 56 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d859ae8..c57b7bb 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -151,10 +151,16 @@ static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic)
 	    __rtc_irq_eoi_tracking_restore_one(vcpu);
 }
 
-static void rtc_irq_eoi(struct kvm_ioapic *ioapic, struct kvm_vcpu *vcpu)
+static void rtc_irq_eoi(struct kvm_ioapic *ioapic, struct kvm_vcpu *vcpu,
+			int vector)
 {
-	if (test_and_clear_bit(vcpu->vcpu_id,
-			       ioapic->rtc_status.dest_map.map)) {
+	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
+
+	/* RTC special handling */
+	if (test_bit(vcpu->vcpu_id, dest_map->map) &&
+	    (vector == dest_map->vectors[vcpu->vcpu_id]) &&
+	    (test_and_clear_bit(vcpu->vcpu_id,
+				ioapic->rtc_status.dest_map.map))) {
 		--ioapic->rtc_status.pending_eoi;
 		rtc_status_pending_eoi_check_valid(ioapic);
 	}
@@ -415,72 +421,68 @@ static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
 }
 
 #define IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT 10000
-
-static void __kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu,
-			struct kvm_ioapic *ioapic, int vector, int trigger_mode)
+static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
+				      struct kvm_ioapic *ioapic,
+				      int trigger_mode,
+				      int pin)
 {
-	struct dest_map *dest_map = &ioapic->rtc_status.dest_map;
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	int i;
-
-	/* RTC special handling */
-	if (test_bit(vcpu->vcpu_id, dest_map->map) &&
-	    vector == dest_map->vectors[vcpu->vcpu_id])
-		rtc_irq_eoi(ioapic, vcpu);
-
-	for (i = 0; i < IOAPIC_NUM_PINS; i++) {
-		union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
-
-		if (ent->fields.vector != vector)
-			continue;
+	union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[pin];
 
-		/*
-		 * We are dropping lock while calling ack notifiers because ack
-		 * notifier callbacks for assigned devices call into IOAPIC
-		 * recursively. Since remote_irr is cleared only after call
-		 * to notifiers if the same vector will be delivered while lock
-		 * is dropped it will be put into irr and will be delivered
-		 * after ack notifier returns.
-		 */
-		spin_unlock(&ioapic->lock);
-		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, i);
-		spin_lock(&ioapic->lock);
+	/*
+	 * We are dropping lock while calling ack notifiers because ack
+	 * notifier callbacks for assigned devices call into IOAPIC
+	 * recursively. Since remote_irr is cleared only after call
+	 * to notifiers if the same vector will be delivered while lock
+	 * is dropped it will be put into irr and will be delivered
+	 * after ack notifier returns.
+	 */
+	spin_unlock(&ioapic->lock);
+	kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
+	spin_lock(&ioapic->lock);
 
-		if (trigger_mode != IOAPIC_LEVEL_TRIG ||
-		    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
-			continue;
+	if (trigger_mode != IOAPIC_LEVEL_TRIG ||
+	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+		return;
 
-		ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
-		ent->fields.remote_irr = 0;
-		if (!ent->fields.mask && (ioapic->irr & (1 << i))) {
-			++ioapic->irq_eoi[i];
-			if (ioapic->irq_eoi[i] == IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT) {
-				/*
-				 * Real hardware does not deliver the interrupt
-				 * immediately during eoi broadcast, and this
-				 * lets a buggy guest make slow progress
-				 * even if it does not correctly handle a
-				 * level-triggered interrupt.  Emulate this
-				 * behavior if we detect an interrupt storm.
-				 */
-				schedule_delayed_work(&ioapic->eoi_inject, HZ / 100);
-				ioapic->irq_eoi[i] = 0;
-				trace_kvm_ioapic_delayed_eoi_inj(ent->bits);
-			} else {
-				ioapic_service(ioapic, i, false);
-			}
+	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
+	ent->fields.remote_irr = 0;
+	if (!ent->fields.mask && (ioapic->irr & (1 << pin))) {
+		++ioapic->irq_eoi[pin];
+		if (ioapic->irq_eoi[pin] == IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT) {
+			/*
+			 * Real hardware does not deliver the interrupt
+			 * immediately during eoi broadcast, and this
+			 * lets a buggy guest make slow progress
+			 * even if it does not correctly handle a
+			 * level-triggered interrupt.  Emulate this
+			 * behavior if we detect an interrupt storm.
+			 */
+			schedule_delayed_work(&ioapic->eoi_inject, HZ / 100);
+			ioapic->irq_eoi[pin] = 0;
+			trace_kvm_ioapic_delayed_eoi_inj(ent->bits);
 		} else {
-			ioapic->irq_eoi[i] = 0;
+			ioapic_service(ioapic, pin, false);
 		}
+	} else {
+		ioapic->irq_eoi[pin] = 0;
 	}
 }
 
 void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector, int trigger_mode)
 {
+	int i;
 	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
 
 	spin_lock(&ioapic->lock);
-	__kvm_ioapic_update_eoi(vcpu, ioapic, vector, trigger_mode);
+	rtc_irq_eoi(ioapic, vcpu, vector);
+	for (i = 0; i < IOAPIC_NUM_PINS; i++) {
+		union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
+
+		if (ent->fields.vector != vector)
+			continue;
+		kvm_ioapic_update_eoi_one(vcpu, ioapic, trigger_mode, i);
+	}
 	spin_unlock(&ioapic->lock);
 }
 
-- 
1.8.3.1

