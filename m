Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944D342AE0F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 22:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhJLUox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 16:44:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49086 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232986AbhJLUow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 16:44:52 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CHn6qC020798;
        Tue, 12 Oct 2021 18:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OSYEp1w534j7A5kYVYgCTWu9i6ON9uiyQAhmeW13+Jc=;
 b=TDmrKqr2MOocyZH7QPrgrp6KfKd8fInLxoqgYw/BS/KU9T0oglggqGvMNA+C08+xsyOp
 egPFpQM8WAGI9Mwn+aeMFcpmQMmjEokwQhCFTVfNCk4GKLZFx2UyKUHT6Dm9NZ60WyeL
 vP636LMK9JKTMyUaGSBvFyNvyTQkCnEzgMEF1wOK7jE/nrm2R26d1aXXIP+ALGBnpCZJ
 I8TcHHxqzAfbi890kIDrLfO9SkSb8Qv3B0k3RblY1ybuEAbxWp+Mabk1hCzIwiaf6/je
 w1hSPx5+5ZNv7PWI1ikdK3U0Snu0yuz9u7+9ORugxs3/sFITfVEiSlB4OUxT7fzqQizA Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq29tubx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 18:34:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CIYjbQ087693;
        Tue, 12 Oct 2021 18:34:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by aserp3020.oracle.com with ESMTP id 3bmadyggq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 18:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnLFllwmfS0bfNSrdQoQlY7mI230QWGj3gcLAt2c1HDznkQasY2MPxZf4X//EJFm7dbQKtJH543DpBmVDb9l3ZLdLnfmbk05DGh/24PuusuW0rySNIpIngF9G8j2rJJ9ehlOkFVhxhm1/pAWoRYxfBuD6eGxC8fk0D9Usdu7gYUAZMwwBqQzfzi+3iF2VCwE4hynvTL9IEgNS0TyvB9I9XQsgAcJpdAFxNDpEoRM/dk4ZjCUdWixwr+250+R9n/5iuQ8SZd+7HZM20y6OaWT/46dP85umyaFWDPszZLelztwrjkcaGFSaoDxGHXzQI6w5RRyXUCa5ZxAGuwQSkJ+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSYEp1w534j7A5kYVYgCTWu9i6ON9uiyQAhmeW13+Jc=;
 b=l3KweXN2R9U3aNMltsRcS52Af6lzomgqm1Pqm0lQOQmuGxpQFuFZEFokQXoMTPFBcaxDLoeGpnnnZWslkdBHlZYNE92kqpuBEM83Fg2i9fUauDBM1hFKaH++rQlnu9HyN5wbcZkP3eAxk9UxLK2ojhzep5orADEMwVqMilKrUjVYsmuhzD7yXzfyv09xme4Npajx96G4qwJZQGNeO/dFmONIBovO4K16ZBCnURzfMfhxfkFh7gYzuCyqOcP/mlC9vTAHCsFbzjCurjP4C5YLNd9jwwWDqyRIKhSQlAeZWd+bdYNcPt4/+0Pj0BajkVIt5giyn8asCcY0iSCmJb8P2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSYEp1w534j7A5kYVYgCTWu9i6ON9uiyQAhmeW13+Jc=;
 b=PxOgJ8t1VpKJxm8FOB5AES8KJm+bd+Sk8CUCwnWZTHov6Br6ruby5vFlIR9xFJxRZ5zYDszFukxL5NVOrnARtttWAYEzKbsM1oP0ohQsgdtiEtoaJ+gbGvhNFRbH9kTvQjiJdEyFSshIft4ynHwvrSCiDKbIwv2fQ7lfi1d6Rek=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4604.namprd10.prod.outlook.com (2603:10b6:806:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 18:34:48 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:34:48 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] KVM: selftests: Rename vm_open() to __vm_create()
Date:   Tue, 12 Oct 2021 13:40:26 -0400
Message-Id: <20211012174026.147040-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48)
 To SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 18:34:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ada50fd-8c9c-4f19-5e7f-08d98daef8b4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4604:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4604EE32B877A91CF025CEC481B69@SA2PR10MB4604.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WZ31nPcaatLbylPhFBq0rYI1EJ2hZN+mzX0eWjzy+SCb2iVtDknoEe6DluYE7X3EieyXE6NwJsRVQGJuYqQdnDa5Tw2tdGLRNvdhjXOjhriI5wEOeb3+zFuvw9Zu0287N+Asprz6XmpguBPRWSYdqXgXN6AUrsxVYDd+IOwJPxcn2h5DoAPAHXaR7DBAT9AxFnUQYj1kEo1kYhWK2HaTf9dVsM9w45PegHoKVF8hxmpJwIveL5azaC670eT24XjoEnFn6Rk3IFrH7mh1NHh91RPux+3cdaYr0poH1taeViqEqQLz7N/jPMzN6qrSalwIFMjxLwyG4U5eocO9cd262qkG3Z8VYijqASMVe+/uDpU9QwWvSbnC9kMII3XcM5SZB/BW/buZSlsa83hGW6DM5Quc/zLgfFG9Hr9BiqGhSt8oxhokTGg6q5pn0Is31IYpbkPWLJx0DT+5ixUeikfncboTfqCdPlOcKQbXBzwJiZZUR0zMQQEMUvrkxI5bBubNGrZRKSvx6egvuKNFHS4zHT8PD40F/ZkFNZzjkjkNRLXJD1eJ8QYkuBLsGjwZUHbNfLalouYnld+ugSKoPi/HfrqTCSX5n7OA08S3d2Jd6fcOeaOpcS2svpxgcj9w06Dw6RZFMR6DmneY39Z3qTGBzK9/cjvqz3dtYIvImkvJ1YETr62rxffyGKvfzKZkkuE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(6916009)(8936002)(38350700002)(956004)(316002)(4326008)(5660300002)(1076003)(38100700002)(6486002)(52116002)(66556008)(66946007)(44832011)(8676002)(6666004)(83380400001)(2906002)(86362001)(2616005)(26005)(66476007)(186003)(36756003)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A0djc8bVR2SfJu4vNMd/4lvV/rlxCchiO5YW1TQCHPcSJQwYSQxAxzPrVphj?=
 =?us-ascii?Q?7oKOgapQn/lh02sjeeYheEn3g8jdFKE9dTzGGo+wHAMhqZH8ngjxJXaORNaW?=
 =?us-ascii?Q?ANk/GU9LYRB6Q2lxaWoJkE8f0Lf9z8Brts2Mor6ZzB/CWAtAGrDibNb8IPVj?=
 =?us-ascii?Q?NgkEIG87WhtzXv/+/ZWbUi8xrxuv00u/U16WX8bFVbTweCK8xb0u2iB5HHPj?=
 =?us-ascii?Q?aGxYrQjOgW8EVpkPkZrEfvJKpOStHGj1h+686prEglrdeoF4XaX000oVygKs?=
 =?us-ascii?Q?2jweqASF4NGcYiSAasXqgXUjHEtXiPQBHS6Qo2en60glk4aQNM9T6dshHDxl?=
 =?us-ascii?Q?u41sCeK9/FwokPHwkmkEpTT6Gi6+svlqPt9y5TDXeQzUCQ3hA8g2FDLlytnV?=
 =?us-ascii?Q?+O5ODDLqKm86sVAdmlbWunFMmJej5jWaF8PhU80bXfWyz9NWBXRnY7N/hgrn?=
 =?us-ascii?Q?eBY3TudtSlBj5/ROtuWL9+pPhUNrmnnhRo3NZ6lkGPC22U/VrQ72pg4t21yF?=
 =?us-ascii?Q?c8ApGp+nslyjt9wgDBoQ1mckzXgY2trzpDSLpKy4tng+qPAL+mb1Lth2KYH5?=
 =?us-ascii?Q?e+rgt+fjd0w+wO+3WpyRgt4qZkBNPpjd0aROIWzbmc+qmvF3qaZy4P+DBRxv?=
 =?us-ascii?Q?xnCOuowdzqNP2PopZsvM3RARffFSgnMPBjXjARzI8y8jt3jpAkZcmqDMqNJ0?=
 =?us-ascii?Q?COU4y1/OiG/XHdjl16BmYZfwb9TQB3rCVhwaqFm8Wqcj+R5+EsbAFCGHCoOf?=
 =?us-ascii?Q?L3kGqBwMQy4xFawfhaSXBiVP7ljtMecs5bLxw2FFyfKHhjGkmTniPkY5Fftq?=
 =?us-ascii?Q?T686gB9KKfDA6S/4V1uCpe0txF+2IcFHjRQFCo3wW/aKqNr7bm6PNXpgS7KM?=
 =?us-ascii?Q?zieABBk3WoL2UJ2nLBBITZMaVEhI/t/qeqMfe19gZfDVIAXQyPs4dMdHjRYz?=
 =?us-ascii?Q?939W4BNA2GvuIIigQsQ4Czd3ByJMzRG22zUSV+T7/zBMCqBzAcOJzDX4sYAt?=
 =?us-ascii?Q?JHEbkqBjqSSKp+T1rExf82EXinVHqpXFINkz4LCEsyYQIZtnhPN4VtKqieX7?=
 =?us-ascii?Q?tgef8/0jkM582Chll4JtcGf3IFK6kbmAQ/2KlMtWEtZiPc4X123JaG4lVV0k?=
 =?us-ascii?Q?FS0QWKtrzaWc6cy+vWj7tSOUIxUgsa+7fWyMEdEYVwIdbsfP7WF83ZeWXjMD?=
 =?us-ascii?Q?xxMi/EdjpgcNuEvf4TrT/DPY7ukVzSDbheXtmkoycVaaS4wuMvEtkmNdXfhp?=
 =?us-ascii?Q?IcefYR8DKG9DWXFS2wyOwVPgaRhKcVoDIsRz1leqRPsHB5gVJTLNFvv9X487?=
 =?us-ascii?Q?9gFjXM4Z0t2d4FicyiXfECeU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ada50fd-8c9c-4f19-5e7f-08d98daef8b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 18:34:48.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xziWPmR2h7mkaQV4mb5nOjaHMXzm8nXNmXShmK4c9iVcsbFLwcCuUXZyFnGL6F4RAdsay1qPeOMDV8XhhEwLEJxn6sE4GDqYn8EatFZOieg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4604
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120099
X-Proofpoint-ORIG-GUID: sVJFUWDYJfIJk8S_5k3vv1SKt5CH6Yk4
X-Proofpoint-GUID: sVJFUWDYJfIJk8S_5k3vv1SKt5CH6Yk4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_open() actually creates the VM by opening the KVM device and calling
KVM_CREATE_VM ioctl, so it is semantically more correct to call it
__vm_create().

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..91603c9b8078 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -151,7 +151,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 	vm->dirty_ring_size = ring_size;
 }
 
-static void vm_open(struct kvm_vm *vm, int perm)
+static void __vm_create(struct kvm_vm *vm, int perm)
 {
 	vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
 
@@ -296,7 +296,7 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif
 
-	vm_open(vm, perm);
+	__vm_create(vm, perm);
 
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
@@ -418,7 +418,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 	int ctr;
 	struct userspace_mem_region *region;
 
-	vm_open(vmp, perm);
+	__vm_create(vmp, perm);
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
-- 
2.25.4

