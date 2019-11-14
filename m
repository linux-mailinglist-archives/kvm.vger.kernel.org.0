Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FF4FCF8E
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKNUQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:50 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbfKNUPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7QrABf+pefIas/MdGMfxs1E1C+VTlQrK4KQgeIp+zZz7RvVcJbNNya2YvBThAa3sbeSAp18DPlMc7onkBGfodlQBcusAAkHwwK3YNGGiOF5lzcL2NlT08Fao+H1WWN7yMI86Bg8PuWnMU2RyS2j/SjU26FnBbIVw4wDGv9isymmzd26pm5Sl812lXpbBvzFZ9WCxN9AgnUo393KzzycOYvBYK+D+c/FBP91XbWK3MndaTSGrWVOPuguhBaaZF1QaID/9teKsa302UJBt9qviLgGLimz96ZxNzY7JmOqn+784YfxG189KECI8bNKo7FZ36KBh/ffKONQ54kwcCwE8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuqmR7REphcdfmlCgLMe+WTCv2hNUzoFWypm5p1MHY=;
 b=PJ88By36zlmrcvl0MpgPrjOtJobu6bo2hN70aQ2kgFqkVmO2tc/yGLPHz/rScujXocq2nlHO7nR+M5pYd1irMHPFM+3JjjGZS6YC7lO6h49cTthfzUvATeBst6q5y2HTpkVJPUogtSrYvKaDXTytBuHAzE+qsTf9aNIACvDSZmG2UwB7IUQNA4AmL0qYxVJW2Bu4ZUJXDP+h6hKcSS1LZ9grAvRJ4PB1GdYUIYBjZEM0MLzaXW6ZtBdzi1FgK4lOHHYsaK5xIzwu1BlOqeiIutRjR5XUCGPzr1Id+1kQIcWlFJv79JMHGYH4dL1EV/AdUdAd40Xh3MF/7whpEN5K+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuqmR7REphcdfmlCgLMe+WTCv2hNUzoFWypm5p1MHY=;
 b=vd7dmuaGHMZcq8Yexe81xypdJEuMxqor4opoLBNgvZK6vb/61zHKz3lWvrWfr9+5zGM/ohkbV8K8fh6A43IGu4ZIezyyGnXL92iDuZahMVxf83uLGKlW9PHiNc71i7CAsBnLWil66okPJuSl6RUHdoPZZgBG8taoZsMriSwdjsE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:37 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:37 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 05/18] kvm: x86: Add APICv (de)activate request trace points
Date:   Thu, 14 Nov 2019 14:15:07 -0600
Message-Id: <1573762520-80328-6-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: d490e39c-7727-4048-2fca-08d7693f69b6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37397148D72EDDCD341E449DF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eeo1EEhzoF/lKLUsK75ONdhd7bJC3fvyjuJi6m1gdb+m+uv2X/KybHnDg+J7aBNoEfE0BxOrFljW8VvJdnOUqQKNATsErE0dZUNp0yHET0yg18rpxbEo50XAsbVFqbETSG6S6aJv3HlORe0/ZWaI8DV78DpYTP1ibHPMzTHDJj+IGy8iWbmXuTnrBOw35zlfvIkysac9aROTVx1hJw/I9ObbaKYP0uxiFWGExtnblZomN4EOjn385fF9HlCHiqja59fURj0P6NHdzJOsS4/njJr644aihtenENlGJ/OvVY6n51sRrKO6ZgvyrdTuiDDGbI2Fk6yq6xHoJxb2DsRtjh3WA38xOC6+RqxTgfRm2Py7XdvKlyoKWmFZjMJMzMRx+SgjOMzlf6OL0aGHyLVaxJ5C/Q81szTv297epD6JH40tkd/EdoxQ5Zmw6rcogNAu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d490e39c-7727-4048-2fca-08d7693f69b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:37.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ap6a+7QL5EHbSJFu1zOEVybkFTC4FHndb0MkJUmI7IeyHLNXL71uMJXDU9S2an610nK/5BvIvEJBRtvol+9fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add trace points when sending request to (de)activate APICv.

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/trace.h | 19 +++++++++++++++++++
 arch/x86/kvm/x86.c   |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7c741a0..f194dd0 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1291,6 +1291,25 @@
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
+TRACE_EVENT(kvm_apicv_update_request,
+	    TP_PROTO(bool activate, unsigned long bit),
+	    TP_ARGS(activate, bit),
+
+	TP_STRUCT__entry(
+		__field(bool, activate)
+		__field(unsigned long, bit)
+	),
+
+	TP_fast_assign(
+		__entry->activate = activate;
+		__entry->bit = bit;
+	),
+
+	TP_printk("%s bit=%lu",
+		  __entry->activate ? "activate" : "deactivate",
+		  __entry->bit)
+);
+
 /*
  * Tracepoint for AMD AVIC
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03318a2..044c628 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7892,6 +7892,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 			return;
 	}
 
+	trace_kvm_apicv_update_request(activate, bit);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
@@ -10282,3 +10283,4 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
-- 
1.8.3.1

