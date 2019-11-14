Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202C8FCF8F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKNUPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:38 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbfKNUPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJhG23193ZlLqJCDcsAteIeRS3LOtKqyvOpcJlTQtyG3NbKyDMNf7eFFVUKkSBTHd7X0SqMAryn0fGYossHJLj0r7uyLKejwJLdv1Nn2am7pptFhqK1H4eEE/rv/NR947LRN2xJQQsGHRAOSZwhjszzeN/S0KDQ8AZykakp/Ku8J+U7C03rI5cv4Ae0iVp8n4TlMLElSj8Iqet/cwE7TMfRCjmrP8nXY3nzaKZOS/pRVsUT1Vzp2XljWhzWx5XCaSM9kyz5DP+aAEdmevgCtPdSlWguE9etzLkQZ5M2kF/Aw6gdBCPSn1DDr06Ix5kg3KFJwcY1tWbeMMEgDKakifA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg920Gohn7KIa3QC8yQPSrZFeCzre1Rvt+qAFz9l+8o=;
 b=R/XqQ1eP9wLyxW2wvpB7y1zRYIM/TNuXNnHh/6VXrTwBqN40egUpKqO3agSsu9Q6jeNo4cKv3afLjkosiDrv9xSZI9cNK0nVDfFWuTgE9r0pyOInsGT+GUzZCzgCm5rEhIjG9NGeLHq25VOCfkJb4ZqrbbHODQ4gcv8Ongc1zU13QPpTuDrr21IKwtzcs9MB8zaqrxTdPUSW3IRH9QpYTURY2iOMIfhmkE6U6wQkR0bFg0GOvbj0hcc1H+FlKw+pNNke4Bq/m6Qp7aH1/Ce+KbjzjlRUW+sDd+E+cOOpRZ5jc15iawtuEmXWmeVy449NrfnjcYx0x2cYlFe5XiI2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg920Gohn7KIa3QC8yQPSrZFeCzre1Rvt+qAFz9l+8o=;
 b=cL/TGxN6fc7PNjZHcWMhnaItd8a6vP26wH4bHAcpvcN31FL49P45u/38Qyt3gx/NSlfrgNw8iHLLCPLS2rtp6/rF44a+udm1vJJG/EPJrsUBHbMlCwPb7RgQ+3UxB4MIBRRVx9pH3ER3Ux9JU90nN8avu4NrGC2yj/8tSVaM/Is=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:33 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:33 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 02/18] kvm: lapic: Introduce APICv update helper function
Date:   Thu, 14 Nov 2019 14:15:04 -0600
Message-Id: <1573762520-80328-3-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f47d7049-026f-4480-3db0-08d7693f6779
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739DAC34C515660EEDD8E6BF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(15650500001)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaCmkFXatXBzR1e8r/NpSItsmrSFYxTX2ATGz96rEf1T0R7JMeQHcG0sLYNP2zTrNZSQyJwKHUDiUBrz6iw72jvOSTwzbtStDVeqmru0xqcVjW9UWVHhoqvFUK2V36RSA1Li/gj2iQR4PA69QkJ2i/AccFZW1Q47PxXvPRM/Jb58e8dATQVnNUqcam923g759xeaZq6GR2VziMoIo7Z6Pl6ZV63/eehx+BcMcfYwuNqLOYlADF/GsLJUc6bYv6mSrH4LvVr3hJMfKcu6E+G3huWL+BuEuj0dm38yTIyO7BwkjbwfhTjGW3VAezCcqKVx7d1fUuCdDCcwOulrO+lAd1S1tWQlXZTiGGNPd+IYqN8YOKBnVD5LB8GYw+YZ/fJ9ujCEmntiQ2WbfODLfDqqlMSkagO5my69wxHjjzmxpTIKefof5t1aT9RRYhfW8yUQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47d7049-026f-4480-3db0-08d7693f6779
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:33.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWAuCvkG+qOHV9kQAkIeIdkrgH06yMS0Fu4icGAQnDztUcKe6vfu+nayT78cMagBvTF7RRxj3p99qTB1XbafsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-factor code into a helper function for setting lapic parameters when
activate/deactivate APICv, and export the function for subsequent usage.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++++-----
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b29d00b..7678f32 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2148,6 +2148,21 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		pr_warn_once("APIC base relocation is unsupported by KVM");
 }
 
+void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (vcpu->arch.apicv_active) {
+		/* irr_pending is always true when apicv is activated. */
+		apic->irr_pending = true;
+		apic->isr_count = 1;
+	} else {
+		apic->irr_pending = (apic_search_irr(apic) != -1);
+		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2190,8 +2205,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
-	apic->irr_pending = vcpu->arch.apicv_active;
-	apic->isr_count = vcpu->arch.apicv_active ? 1 : 0;
+	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
@@ -2449,9 +2463,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
 	start_apic_timer(apic);
-	apic->irr_pending = true;
-	apic->isr_count = vcpu->arch.apicv_active ?
-				1 : count_vectors(apic->regs + APIC_ISR);
+	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
 		kvm_x86_ops->apicv_post_state_restore(vcpu);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1f501485..f6ef1ce 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -90,6 +90,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
+void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
-- 
1.8.3.1

