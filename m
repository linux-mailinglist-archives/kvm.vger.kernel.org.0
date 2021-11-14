Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFB944F8A1
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKNPA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:00:58 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:21030 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235295AbhKNPAz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:00:55 -0500
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AE61cgs001895;
        Sun, 14 Nov 2021 06:58:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=h8f+j5oRz8nfBotukn+5wnJGEBjr2k7JGxLsTV5X4W4=;
 b=G2CfsB6E4W1eI6un9fezf895AASyc+UufsDEY48tK/6EjEABObw6B6Jfq8uK+74uSVH9
 1on7qokXtxVAPVn4EDVk0MvdrM9JIpb24Tp58zGQd+28Txk/O17CAdh+5W238S+Kl8dt
 aaslAwbhyzkEWB4FfKBvlmk5039mZMNdAawjvGYE71TsnOLFV2a2YPUju8Naqc37jxls
 8mQj/hKhTpKaK8wEKwDlt749UN9Enhc6bnEsJkSkIpz2HhTdHuyFrAVJAmBQ5WW6RDRu
 0xXsn/Jr9WA5BztDUObsV0UvGWliR6SaT2us0Thk0vPzOk6/vldbTZy+hSXde2dpisID Qg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3caa5d1u4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:57:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3wgUbuLWXhLsNQTS/jq/eGY8bM6OXnmzPZXzoK97BFnF0putuSm2ko3Hqhi7g533zljAkIaje/4hktR7Cx1VJQ3mNe3SaCE//tgbMBMSWO05IvC6BxHjLu9nNuvr+g8UjKiNA5nXzbyJyU6l4MxDcB0iZC6uVPpIcxNitCtKhL0CCb5JNOsEE6R1w8VfaaGFjkrAhGSLFRuVSgSXHrBhNFY419168oqMQFhdFD6kLzLWc8s/jL5q5Ilka25Y5LErINeKtGnqXYKrcm26rAGpxjR/1C74Kf/Px5yniWcuFsI1jOkSy70/8e3amkJIVGJ9WZ6sXY8JPt0Knw9tllkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8f+j5oRz8nfBotukn+5wnJGEBjr2k7JGxLsTV5X4W4=;
 b=fFDyzgIM5juGe/tfCVahdvZMRSfKsVjlyp9PXUfVq2O5w56ah1C0DQwAHRkj7+tEwq9d5IO6pbrOeo19FOTrR9QFqoTdBK8oRrR4p9oie++1cwC9WNdykk1SsNM/KFO6EeN2ub7p00Mt2iFg7P2tvDNBwsFuBhN45hJCbO+IpyV31gHQ8VBf5m8cHrKZqnWC3Z6qaM8WFp1pEJWf5CYjJp2bvtNkcryD4XEa55eXH5GhzWjX5m0M7Z6ftgQ0iYPX8UXan57mdZV8t3vmv4bS2t8cshdzphAB1DVNkBEW9YzXOD0WdMbhZ2omYuODSSQKGUXeBEcOqHWKDOjuXNOpMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2528.namprd02.prod.outlook.com (2603:10b6:300:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sun, 14 Nov
 2021 14:57:58 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:57:58 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 4/6] Increment dirty counter for vmexit due to page write fault.
Date:   Sun, 14 Nov 2021 14:57:19 +0000
Message-Id: <20211114145721.209219-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:57:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd6b9078-d749-423a-d0af-08d9a77f25bc
X-MS-TrafficTypeDiagnostic: MWHPR02MB2528:
X-Microsoft-Antispam-PRVS: <MWHPR02MB2528470915B2B93D23F02514B3979@MWHPR02MB2528.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNPtjPP5OYbBp2/c+Wi34oJrtKlgfaCFtpCLvLyNSYr9c2kMRM/VP86biwraWg3z/ochki7rFwDVHg01DawqU185AoPxfOeoaQTV92iNiNybUAThiypRp4My2QgNB7ro8utD3/OtAyFKu5Q/UekFvk8Dp5LZ+Mk1CH4hsmZdJ6NPWXP8tWLRSgQXb6dleGbwHFpnk8JdbZUDw1413p9iSrSWuYpi78C21D5Qrp5D65F5lHJ7udSMgvFZvpSaJuw3De7zqTj6GJLOYRWfuNp1R4fxPmJkaB37+16lw94235Fp52c2J++MjzW2eqTROuohnhDdEsC5Y6UhtXAcSUKJDFDzBPosTivDdn5D8f9qrnSYas6YwwaN0iSN9tWQyF/1McAPSRU8ADsC9/uzlZUNCegsJFLf0OEG4/akce5gZF+ji4P6KmWoZb9MIuuYh2tnmPPCBbDuqPNG8Avr7I54kaosJ9fBr4oH8w90k7cAgLhkXhP2tPUlZmk7MlWQBbOQ5hbHMTWs+rsTeonlRgiPyskaTM6sOZortkaLU9RvH+KhF+AmrQZY1H2/n/XR4m3IcED0EcBsLmUpw9P6a37b5yU53Fb+vKB6n2O6D+/iJhQVQ/WAxEovZLObLbPTo5sra0W6kiMqh5NzWVHMTqa678TBLdQmQdZArz7stIRy9eKHpeEUWS4M6fkgYC2KTrreoS1hJptFUyqZMqccqpUpCN1iBI/U/kG48qKvg4DLFTg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66946007)(6666004)(6486002)(316002)(26005)(38100700002)(107886003)(1076003)(186003)(6916009)(83380400001)(956004)(36756003)(66476007)(38350700002)(508600001)(86362001)(2616005)(8676002)(8936002)(5660300002)(7696005)(52116002)(66556008)(54906003)(4326008)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t1di9qPmc0HLwjYijK/8fADyKz3K4hoKBFVfcqDuZvrOnQ6AnMQcKKVJpndQ?=
 =?us-ascii?Q?AlZgXKt5+uQ1BcZD+ktB/OP/5z++ppuHRZsQLjM6PadlWMIMs9aXfvpXlpmr?=
 =?us-ascii?Q?bTjwVh7UEjFx7G/EFtyjD2VlEdr2MJo5BJr7/tAmZSV2y6ZTR/p1khaElP6D?=
 =?us-ascii?Q?DqOykJKEfSZ7yw3y6lVz2HCBRAqG+mD+6unIHFxC/6H3al5MNpxTlWhmYEZ+?=
 =?us-ascii?Q?vnJlLKRjtGVINIr1U/q/CXmogIXahRGO+5DVXAHaR/Z0kVlLmnf1piZM1vUo?=
 =?us-ascii?Q?3/5/9jwfIJTP+v/2LpVLHTwFEr6ZDjKkLmA7rZJPlQToasoTaa40NwIJ/AaJ?=
 =?us-ascii?Q?qaAyf1FLvIKsUFGdnsvjXC9glOn8lyOwkR3vREVi1oRrfmOkjXNmZygjwg0x?=
 =?us-ascii?Q?VXN+NWZFsdnvMMGJLrNniiDoDsifsN7h+dEpTM49/LEdieX/FIMcggAHSkW4?=
 =?us-ascii?Q?uXGJH6SOZEY4cPvHykjF+GBVeqo5rmiJvt9do/2GCDGguXjRrEnZw9x0mpSq?=
 =?us-ascii?Q?mrYGwSXcYV4vc2Ge/ns1PPy7NqsM1vBa/lSK5qvfshd9AqDij45/9yrA63pn?=
 =?us-ascii?Q?XRdxS6PSU//xadIODC9k+AtkfnzUt7s4AUPIJIoHof3CLlEn2Q1yT8LrevxE?=
 =?us-ascii?Q?HHpEo23b2vXFJCPNIqIGUUmpYXUXs/bXxYL7u7giI3oPtW1nIQEcSvJqLn0A?=
 =?us-ascii?Q?clLiZw+DRhmNerd0Ilqxv5AIBHKNkg9ZA+CkDfyutLi87TAklPIlOYG/fsoz?=
 =?us-ascii?Q?3OLToxDdOdp0KTD3aZ91Vx+tiuuomUzBGaP6rEUneDVsIyZedgicxexNpyc/?=
 =?us-ascii?Q?WQ9l+jBKFaAZ/jMicprLCSL/6NdhExonrET3MvKHbZcRNkNBhQpL9ghT8zeO?=
 =?us-ascii?Q?VheiPHhRvmeRvQt1bFhIy6a7VMsGBja9qLkXgETlM5CFzQn5BKBtP7bn8DsN?=
 =?us-ascii?Q?pZhZ7Bt9TXL+7mUYAAPcnKwJ8gLdaGGOfa82SYDp53n0iTMgMZ0v6FEbg3CK?=
 =?us-ascii?Q?UcnDiwl4YoI6N9hnuOImGSBN0Y6Q2mVaiFIo8xGD75Hzxl5SMwfuzEX726ls?=
 =?us-ascii?Q?Qa/Y8I26sLswVYPd/p9ZEuVFGVamjIMyplyYU8mJYIKhQJdK+mpU9ucd7RFz?=
 =?us-ascii?Q?OgirJpUo2if9sJZ+ZcARBfcO3mitIJ4/gW257Uh89rYjw0sPEoo/ggsV/a4n?=
 =?us-ascii?Q?CdFbYWxcTjBmjJuQk4zdagsuFqm8J0xKR6RZtKxy20Mu5Gn8nnV1rxOB4Zgc?=
 =?us-ascii?Q?YE3XouoPLBUPU+VKl1+VTc0FumkOsGQbCjJahPo5o6gUC1KTyfZbu0NfGwQL?=
 =?us-ascii?Q?RduNjc7nWooDowIl/N4mZg4SlDGgCo/6RAae18A5D+pMkLB4T4V0mTCSTJ2R?=
 =?us-ascii?Q?X762F2s0xCQg2zAAlmIGIQG/Xxt5ED+dbyQdYcK6rPgDU0SedheBVOvcMCvi?=
 =?us-ascii?Q?GBMzVfluEhFfwy3CavMuPjTdP5pFrIbL9+mhpA5Tx4oURvQkr4kh47OfOcex?=
 =?us-ascii?Q?0vgiiwN5nIUIiqnJwzvu22KrA3T7hQEkkvQs//vc7YFjlidCCh0epD15s0pE?=
 =?us-ascii?Q?nskMIRvYSB0x9L94+IgD3UH3TBu6gQiKIOfkYe539pf/87gOfVaxqm3XO3lW?=
 =?us-ascii?Q?3neWBKDqf9nczLKihzXDNMxuM8aoRtoiv+fsG4/sodAAVH5kGDLkHdokBwvP?=
 =?us-ascii?Q?S5Kf7ZnJ+ZXOHq4XQZDwSUeUrRA=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6b9078-d749-423a-d0af-08d9a77f25bc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:57:58.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94YPlNvQHeXqJcmzrdnOO28zFQjFMZI0U4b3DPPOAznB+mSRjDf1bnyKWEk0XWLAvuvwDeFa23lhAmsS9kMOLjJxHzGsvfwPci4+rCQACO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2528
X-Proofpoint-ORIG-GUID: QbmF9swSIyn62_aSgf7NrQbZpzyn4Pw0
X-Proofpoint-GUID: QbmF9swSIyn62_aSgf7NrQbZpzyn4Pw0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For a page write fault or "page dirty", the dirty counter of the
corresponding vCPU is incremented.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 virt/kvm/kvm_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1564d3a3f608..55bf92cf9f4f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3091,8 +3091,15 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		if (kvm->dirty_ring_size)
 			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
 					    slot, rel_gfn);
-		else
+		else {
+			struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+			if (vcpu && vcpu->kvm->dirty_quota_migration_enabled &&
+					vcpu->vCPUdqctx)
+				vcpu->vCPUdqctx->dirty_counter++;
+
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.22.3

