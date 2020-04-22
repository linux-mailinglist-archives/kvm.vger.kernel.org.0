Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959A71B4DDB
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgDVT6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 15:58:55 -0400
Received: from mail-dm6nam11on2123.outbound.protection.outlook.com ([40.107.223.123]:64928
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbgDVT6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 15:58:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWTHfqFaBIfpBLaleRJYwXNWaANyWqX4CF/yeqX+q0BnqxCqQFrTW6M8gaFmhk3dDYg4SYd+XZW7OdTAZ7FrK5ZyNibfj2WtC+aFV6ImtukplUfPiL8UbFuH41GwDb85BqlQn+eW2S+piHzcjDiHlvK84CJyXSCVZfOz2wPrg3gKEiq0Ej/x2kxnlcT5bjhq4r45K5GmMp+Z7/RPFwqurgza51goJJI6JSNB8wMiIaIpBQFINo0LoOABHBmpg21avR6E8gP9+rHNceuR/XZnXJZlg5KgAGuCJGhF6vu48+TQXBd0kBbpOkUTAFJK1xNtXUz11gO6roBlMjG2l8CY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUlJw9P/OOM2qz0EBHFoCmBbRJGN+J/GvcOvVZOShqs=;
 b=YDgO7lz1vErBxnLtEV63KvDns0pNJ591iCQgxXQ6r/WYt5QBXlFk3ZV0jQGX8hmwdOsdaXIbIWNYq9vtv9AXK7tKyITXGcos/aUsM8S2dhGLQQsbEtMePQqkoKpFcmM3HT11x1xnzgKfbyD40/jWkeAiOF4M6u8nGFVJA6BBrvR2nqW5CjikvHE+GG3WHijh6wUSeMTiPSHIMResi0YoTCS8/J4wYWpm1idDL8KJpbZDGK6jn1FSIqLh4El9bwYbXfj641VY4kieCsZKTgo6FqQqJNRBKrHlkCbYrpFZPi2CykdAZlLppyFQSF4zMQ8zWjoEEt3wrorK/M56pDonxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUlJw9P/OOM2qz0EBHFoCmBbRJGN+J/GvcOvVZOShqs=;
 b=Ga+QguCx9qVPK2sc1jzgAVCX/CmCcwHQtjZc7HSkDkW1PI+7o4y7POAWwKDroZdEXoEd487SFSDAPwldWE9nJ6Dch+ckreLf+lvymRoPrSXrgUQtHAVkFKMrrFiq5Jc5qco/NqHfsjpAmsYn8astSjfQLyF4CoKSFyzVbfVStd0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0148.namprd21.prod.outlook.com (2603:10b6:404:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Wed, 22 Apr
 2020 19:58:43 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Wed, 22 Apr
 2020 19:58:43 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH v2 4/4] asm-generic/hyperv: Add definitions for Get/SetVpRegister hypercalls
Date:   Wed, 22 Apr 2020 12:57:37 -0700
Message-Id: <20200422195737.10223-5-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200422195737.10223-1-mikelley@microsoft.com>
References: <20200422195737.10223-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0078.namprd19.prod.outlook.com
 (2603:10b6:320:1f::16) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (167.220.2.108) by MWHPR19CA0078.namprd19.prod.outlook.com (2603:10b6:320:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 19:58:41 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [167.220.2.108]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ab8775a-53e2-40ab-8445-08d7e6f78f2f
X-MS-TrafficTypeDiagnostic: BN6PR21MB0148:|BN6PR21MB0148:|BN6PR21MB0148:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB0148B53B3AF1C4AFB34BFEE5D7D20@BN6PR21MB0148.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(81156014)(82960400001)(8936002)(10290500003)(4326008)(26005)(82950400001)(5660300002)(107886003)(956004)(2616005)(478600001)(66556008)(66946007)(66476007)(6486002)(1076003)(86362001)(6666004)(316002)(8676002)(2906002)(16526019)(186003)(36756003)(52116002)(7696005)(7416002)(41533002)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rHlbaHYreG2jG5H3cuq98HvXQ/k2NH6xXYuV9tXkncKTzJdkLknQVtSkVcySeLhg10WUE0mMN0zEKb3wY71iwPUq6g1LiN3hAax7n0QfgGN0Ah0ZzaARu6Mwhi17431Nj62kNg4Cvzq/fuGmrAU5QK4tH7doXzKbalMtVshwit2WwQgBsx4zzMs5W2/2LIMAlnN1D5RvOnm/SYrsEEnGVX80y6l/h4xw7KoxJ14Nu6viyltBjTRMdJmB7YTsRcJ9a5QzXapErJPB5/WXnpF462ZNGRP6g4vUwLLfj5uqIETXfB13jBTd2RsEbB5k9Pc9RqXSCWn1aN/sRkjdOVzAwsbAZ8G9E1hEc7vP5x+9DNFS7mzQq3ouMX5are19bUC5H8eIatFjMZZjqlPP1js65U4Ovg8mHJ/UeHGFyjl3JIelA7JQzQ3UVJ8WmoGC5vHNX0S6Xss6WkctFhO4hFg1OTyRVV1PHI6ouWXmimqJHljQkU1pOtepOIXYTTzWjTC
X-MS-Exchange-AntiSpam-MessageData: W7prDTzONe2iL1D9DGRJGOtjLU9Nq2IMIzqw+OcVheMW/IEKf+fg2cHj+7Wi8k/0fH2g0Po5OMm8SajljmCLlgMga7RCb6wERWBH85Qwy+rPKscQn/h4eqvW2Lc962u8fKnaJHLWm1MM7+yGkYpPXsoCedk2cZuPr+2AxrQAODeqQrk0pNCMyl2a8lu0CiGRmugVKQZLm7vVzG7JfZx6Znp0NvxjVAz5FAZOSQDSMqcnQNyxE6HbTqM5f/ZAoNwlKc/E0C8QHl1cncdxNtj+c8HYxoaaEpEST51fZ1o0HS6nq0y9cnfN+hzSGHSrSSiSNLPoH/cEgfjDT/IUlbpSgku0zpQfj1LL/PqBQOmVbAs3ByRjJ9TIOKdfjjB17NpsG7yO49jYLdDn7gEzLx0YmgLMCjz67bvAITbiofwJMXipnK4w+4CIaVNWQCaKDGEpkBqle6zji2xkguZ2ezIqjsMuHizuiWnXN8k8GCCcFyMZDSZ/R4RDkdWMAbxQoplA1SpHNNyrWjzJXF2z81SVZr1oD1BQuQtI0AH7b7n+JeGWixKHmFrzhX17BD96SqDBdjScvb9KNOwieCBjlO0NBDDYUnGchlL5rWNIKesFwu7ltCTRMoHS5fJ2YY4OCemnu6qXSr7U+6iaGQGZwTQdzlIyw4yoMT5NNFB+0QcjW8VF++z3fTmW025moE2Y5JVl2dv80Q7GJ0F45w+zw76L4ZuqT7Gvuyno6Iccl5jl8+aBU8BwhTqpOgONohH3GhB6UXEGr9fupS7U29P/V9z7hmadqfBtnLCKgq+Rj97k5V8=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab8775a-53e2-40ab-8445-08d7e6f78f2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 19:58:43.1160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGDnM3RTtbSSi5JAT1gJPbXaw5yEcEwahUOX0adgSf/stgWkJ39DCVz/UwpA63YtGvW+wW6HfuNTmdlDXw+4pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add definitions for GetVpRegister and SetVpRegister hypercalls, which
are implemented for both x86 and ARM64.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 include/asm-generic/hyperv-tlfs.h | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 1f92ef92eb56..262fae9526b1 100644
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
@@ -439,4 +441,53 @@ struct hv_retarget_device_interrupt {
 	struct hv_device_interrupt_target int_target;
 } __packed __aligned(8);
 
+
+/* HvGetVpRegisters hypercall input with variable size reg name list*/
+struct hv_get_vp_registers_input {
+	struct {
+		u64 partitionid;
+		u32 vpindex;
+		u8  inputvtl;
+		u8  padding[3];
+	} header;
+	struct input {
+		u32 name0;
+		u32 name1;
+	} element[];
+} __packed;
+
+
+/* HvGetVpRegisters returns an array of these output elements */
+struct hv_get_vp_registers_output {
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
+/* HvSetVpRegisters hypercall with variable size reg name/value list*/
+struct hv_set_vp_registers_input {
+	struct {
+		u64 partitionid;
+		u32 vpindex;
+		u8  inputvtl;
+		u8  padding[3];
+	} header;
+	struct {
+		u32 name;
+		u32 padding1;
+		u64 padding2;
+		u64 valuelow;
+		u64 valuehigh;
+	} element[];
+} __packed;
+
 #endif
-- 
2.18.2

