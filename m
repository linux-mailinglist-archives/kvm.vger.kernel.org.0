Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D11B1351
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgDTRjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:39:54 -0400
Received: from mail-mw2nam12on2124.outbound.protection.outlook.com ([40.107.244.124]:36000
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbgDTRjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 13:39:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWC4IffF44BuFkQLL8Z1l6GeySNNyGkHjz1FlmYgVsy0Ej8QA0V7arIflUpOGNUbdO5xD0ieYi6RMp+pXpk4JYX4OdjrOzN0QSEUfcV8N6BnMC5ZYZ3Nufa6V0/0Kv+tUMGwFcJ1u745JKqZUbO1u55/U/xOlEk7aSRpvvxmEdyRnJphC5/yxLEjt2SthFbdXOjAutUiJ+3yUH7j7DKVi9kpV7WbC1ubqkNMwX7cSK/gQ199PUIo539bagxYrnQFX73cpPDk5eo96lCembYUBKqhUKR0DwDRQGrPgM2vF76UfU9znEPAW042nGAzw4rYsfA1pI5flR9FN4IHMMLYlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+pt8VAX0jgFaHjFciCb78lwoa6krrI0QI6TTtw3A1k=;
 b=bRyHhGlo3XOyslLQu2+OD1q8Dfjvdxs4RsSHGSiPrmkBuU5EQVkeJucutUTIuHNpqpgBGWLaAN2zD/MQM0kgVtPhvsviOQgNAd3j6BD9txcwBiLIXUh8RUXOBTdUk5Ri9PCiyW/3nYsjC5c3e6CdJMwRFROmZVdwuM4QXz5R17BWoZSAHLpgDvL1lVULWV0HP1wU45lX49o/KGwtklNkYycjSJFM2YqMZCfKVuQgvWzE1WznymBaZWUxGylZnKOwbtvsmZ3CMYQyptJe0g1zBNZhyqWAXUoyjug99Pi2L6kDd8eV/9MDvyg5qoR+/8ObPKVT51vkAwr3z7a1JoBzPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+pt8VAX0jgFaHjFciCb78lwoa6krrI0QI6TTtw3A1k=;
 b=Vl4TIWfp00qhZmdeNp2Dx6D4b2cldtW9O82V2ctpd0vl3w0e64MWitJKvwJJk0/qrQaRzn3DfUO5jvJWyDi+HRCHT+SOCKhr5S+mQ7v5at9ajVCRvbLKbOh19VCjwVkpA8EtbznGRCLB5kxf/CLVuEDRbJB8fjfLq/Woymn7i3M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0691.namprd21.prod.outlook.com (2603:10b6:404:11b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Mon, 20 Apr
 2020 17:39:34 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Mon, 20 Apr
 2020 17:39:34 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH 4/4] asm-generic/hyperv: Add definitions for Get/SetVpRegister hypercalls
Date:   Mon, 20 Apr 2020 10:38:38 -0700
Message-Id: <20200420173838.24672-5-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200420173838.24672-1-mikelley@microsoft.com>
References: <20200420173838.24672-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (131.107.160.236) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 17:39:32 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [131.107.160.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82796493-5300-44ea-65dc-08d7e551c9e1
X-MS-TrafficTypeDiagnostic: BN6PR21MB0691:|BN6PR21MB0691:|BN6PR21MB0691:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB0691D99D37D82C2351D1B3C9D7D40@BN6PR21MB0691.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:335;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(7416002)(66556008)(66946007)(66476007)(6486002)(16526019)(36756003)(1076003)(186003)(7696005)(52116002)(86362001)(26005)(5660300002)(4326008)(2616005)(10290500003)(8676002)(956004)(316002)(478600001)(2906002)(82960400001)(82950400001)(81156014)(8936002)(107886003)(41533002)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMYgV7NEX4Vtvw7wZakJeoMMVWZn/Z84lp4cCqDabq4LHxTn4QKvNfROJB1mNH7dFzSFSMiP17jn63YaeIesNHbt1lk2LQQObAUbR9laUz/fcFZd271lkCXzL5JK04fQfTdVWvzsq7fyLCA+dy4E9ufD/DJsM5NuuxCJQn+/m1xwGTBlkuI0FtcFS3UwZ04EcLbDGFQDa37HeyPqUo/MY4EPSQcb93msuCIxdWdhRNacANA43+Px7WmWVQH2JPOfdfiu94sDKovfXPi1kFeDg9axOJjTdTqZs28K0LoC1Q4w2PN0EKOIu9ZwVZiRRccAYIgBv1HtzxzqCbrNhNODA+y/x538yGeMUnT2Rx3dOEsKyJAnEW/5/e8MtzXUkntX51CDTKQoPcQOGfdQ3oyQZe+VTiF5gofTBus1D70CINfWksTIFXfbgsdenR0NADgnHWR49N/7mRNKusQ6d/IAp+Ahjgp8Ix9QKppWv6zJbr+I0/aoR5uXLsEajP1lQw4v
X-MS-Exchange-AntiSpam-MessageData: aOjqyUygsSc2EpDE1uqwnfagRddA8hK6c0tVGRDy3KrFcAWgc1y4kcgPK5QA58sN0fkrtkz2cyucvI80xmO35LkGGYVr8VxawwzbdVnWSNlnyOm47SFQxBbyrgCAslFPd8ODmPD+Qw49mQyIhIG8jD42XXTT7Z/RJ6zau7sN4Nonqu58nPaLwKbFYqjF32JRPH8QpdtSmXtWBfRIllYCl3+Y+EEYrqSEzHPRSZV4jrd2857XTeczJk3pPi9QYgUAfq33ZfS/tkK61MM/dmb05lTYqkHKcZAUUnxeegiyDeirCxveDWL+biow3w2jqTKazuVl2h5jCb2aBs7jyQeNBI9IJoMJeMZ8ftns3aGCdWxnbD403vFyiymKCouhwTuQkeawGkXsl70NW6ETE0nBvvrnRjRxi23jrytkTPA0d3FWa1vH+MNDmLkgu+mRMn9j3s12WmaQUzBU8yo36g3C245/vDnc7OLiY/BOXsxKjubZeb74wrntP1N9hjM2Eo6VME4yo4vG1APiQ5AAu+ZgSSAQrd22DugdkCt6dsUMbiZkVoTQB83nC/m5vrGwRzCV3134fApGAgl3Ge+C8FmIYNlHrBq0MRCQ8GjKj7wMG0g1+vT1Yw/Si78OSFtmiCctbWUtRXWWF5750zn6sLTEKsrBwLU4ldrf8e+eXVHQFeyE9thZlfbxG3flQABm/YQTdB7j4E9TGQdKoTajv8g85M8Vdozq7HAxIQOi/IuJBHsqax3WjDAKDYb1T7Rnq9cqgAp8/aCV+lgHWE4IOai5GyhTkc+gyOndiMEUeoNaSuZbMqxaiUV1M8Qv85kX+udF
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82796493-5300-44ea-65dc-08d7e551c9e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 17:39:33.9987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8tKkIHq+AVRBM9/HKBP4tVsf/tOluh5qp0JpBru1CQ4e96ZxIiWOif25tGDuVqkiNf6Qu1Sq6kd7ZUzocy/JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0691
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add definitions for GetVpRegister and SetVpRegister hypercalls, which
are implemented for both x86 and ARM64.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 include/asm-generic/hyperv-tlfs.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 1f92ef92eb56..29b60f5b6323 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -141,6 +141,8 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
 #define HVCALL_SEND_IPI_EX			0x0015
+#define HVCALL_GET_VP_REGISTERS			0x0050
+#define HVCALL_SET_VP_REGISTERS			0x0051
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
 #define HVCALL_RETARGET_INTERRUPT		0x007e
@@ -439,4 +441,30 @@ struct hv_retarget_device_interrupt {
 	struct hv_device_interrupt_target int_target;
 } __packed __aligned(8);
 
+
+/* HvGetVPRegister hypercall */
+struct hv_get_vp_register_input {
+	u64 partitionid;
+	u32 vpindex;
+	u8  inputvtl;
+	u8  padding[3];
+	u32 name0;
+	u32 name1;
+} __packed;
+
+struct hv_get_vp_register_output {
+	union {
+		struct {
+			u32 a;
+			u32 b;
+			u32 c;
+			u32 d;
+		} as32 __packed;
+		struct {
+			u64 low;
+			u64 high;
+		} as64 __packed;
+	};
+};
+
 #endif
-- 
2.18.2

