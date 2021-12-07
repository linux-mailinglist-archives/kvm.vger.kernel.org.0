Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6038746B069
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 03:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhLGCGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 21:06:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9084 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233930AbhLGCGh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 21:06:37 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5Hfq012536;
        Tue, 7 Dec 2021 02:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tAksLJNcQYdfQHDrDLRIVn+QKRz8PMyyL2bbp3dmWzM=;
 b=AMCAbeBUvWhxBkhM7Z5iAwU5hF4OSZ6tKNuWj2qfq/qtdTpbsfAvpA/PVy3F3ZApYWSU
 Drl+uSYqOF0vxHgmmQiU+7ErH+n17TMUQGXS1pAfdczZSm+vV0nmhDvDbkVwR58kOZaP
 5AuTy9PMfE9+egcc6Lsla+qKKbic47VKPyZNk22f0udSXdPjbB2VmLCsZ4LbaUMOH0OJ
 vI5aUPEtb1JMGBuz8d1R6k2Aywqckp/453Lm8Y2EpdF81p7HrBOmJvI9bGi24ZxhOsUd
 ThZMmmIXru+xASLY0eYdmW98UlUtHo7BmyIkeTt8yVFInJ9DzHiLj24OQwfj+eHYjOaY XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c17t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B721DR4030313;
        Tue, 7 Dec 2021 02:03:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 3csc4smgg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtQVNx7imH4U9JRh+EMrEPcQZGAe7SoST7Gt2Po3D2tc1HegW2e9CgnMBL2F0/rCwu02+Av4FGEpWOMr9WRGHr6G6tjs4deq2VyWughEKRHl9zMa+UX5u5iyUpS4ROrfrolvCyk66U6JgXbV402b/MZpTn2H59IR4/8bvCWtKY4OQZ2h4TyYV4bRHba9lMss6zDzQs7qUKeBiH5TX2sURHuf28EwOv/6yYeHGbbb4IGhQwpdfQJugBT1ldHEe+DcA3EzBlkN/Gy0P7CuyVl7WdZoR/yTOI8DxJRi0A7wOKhJAqvNTy61DIL+S6NYC6//iTU2RP6ZFSWD7tZVQ4C/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAksLJNcQYdfQHDrDLRIVn+QKRz8PMyyL2bbp3dmWzM=;
 b=a2qbUNp+JCcrMl9E+uP/u4afWVhiDPm6WGRlIY2M/7LCrhyp57sRzVtcMmCKFqCsUaR2q6v0jlYSEnFwh1mPrZhLtutnl6UdMqfXZ0eecFRbduCucrv4qxtWSRtF4lKTBrq16dCQ1klAYpQuV0qBrAyUpqeO7y3/5okd94YfhJF+HdCZrj6brrETc5VQnfxMd8jma7QnBePdfYySIcAY6eUsQDaP9eCiLNtSyeb5pBdMQknJz6oF9+vSA8Z62npnFpD1oRbswUiA+KWiMIvlM//Ze1YP2uX7R5RJK5QzSxRZ9S5riqoA5nEKkYsXrnp+WciwOtUgLtJwFvkZp/6m2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAksLJNcQYdfQHDrDLRIVn+QKRz8PMyyL2bbp3dmWzM=;
 b=EwxGwWBIjLUY2nTuqtUDwk4nshL7wrtDx3xLQ02fcTQTBlNGOLTHIe5y6rcYifln+hqDWq+o9RKhspR0d74/ZFoS5bu6qF1PKhDXmS+bj7ELg/79Etl9bf+kH9RFv2QFe3nUA+pZGeYSBX8COkN5+1OzRSlJ212GbTmczi8+seI=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5709.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 02:03:04 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:03:04 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] nSVM: Test MBZ bits in nested CR3 (nCR3)
Date:   Mon,  6 Dec 2021 20:08:01 -0500
Message-Id: <20211207010801.79955-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
References: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR07CA0024.namprd07.prod.outlook.com (2603:10b6:a02:bc::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 02:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 808928c0-3aa2-476c-f32a-08d9b925b42f
X-MS-TrafficTypeDiagnostic: SA1PR10MB5709:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5709D1370E4F1B10F5CE015A816E9@SA1PR10MB5709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKQvizsDhh5mmRzi/OXtK1FsXs9DhXV4oiYkOBUOCTZk+0XZBRaaOcpW/fF+YxDQ8Yr3yumIpNu6d7sfgeRz9De92uKMN3teIMdocZOFDCt2sIqVShZBbbxH5xxia7uka7QTkzkzBAKg9uOk5vhXodmgwH82o54K37NZAQEo294R48omjtlSbCVdERzTlWXBCea8+PEU8CA5ThBrdo6jDMTkse6M+ng4+ln+vXB9H5LOaNgqh+1F194qH4yvYI67MagiehQIPz3t6u3eLNtmdAe857Pu2wGBOjK5KcNJMcP/LoxMpYq5rv+sGjkCqL3Y6zVAEN3TSntR276m0jiFHUngVbPX6aITG4NagvQM40tap9aTEqda61k21pC9QI9ZMcmRG3Km72uctzVbLnXnBYDb1hKDEPHb15G68dqcpguGq+ta3Uy4dLIi1hQz3GaPwlJc+WiPhap9Lxq+6o0GCT1NWBL1CYO2WMfYex9VN6Ag49n9bAsKyG5SfY3CUdkd8AR1k3635ws+toJ1XIeLE3nMOTSrcvgiApZkXQl3v4rmVjQFRJ5taXpA1G7REcBqngMXb4kzUGuqWmzB26eNHyCAnx/ewJ+VMyRF018PW+69JlnQd/xO4YeaGL3gDwoqSldZUP70z5VvN2Rh/udkKqP7cvpQ+k06KRZj7T13TjPkuyQWvS0971PCRPzbjKCSDQMP5viuoaJQesRuqAQ21Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(8936002)(5660300002)(86362001)(66556008)(186003)(4326008)(6486002)(8676002)(38100700002)(1076003)(38350700002)(26005)(508600001)(66946007)(316002)(52116002)(2906002)(6916009)(7696005)(83380400001)(44832011)(2616005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sz51YCjZgguARHQDGh+BWwRhde2XvJOP/dOD/OPTV7JBrm/1Xxxxfnq315f7?=
 =?us-ascii?Q?jcu0+oqc2ez0uqDjoi4nhf+R60ZL6W+NXSyBRRMtyqxDmBf05TF9MxnoeFWI?=
 =?us-ascii?Q?+3fzaLr+RYr1PiJVlw2pk8gIpObI+73Rt5+h+yP6px2HcCPiG0q/4d4tHvYa?=
 =?us-ascii?Q?r/6OpshbgEW2kQc7XLdhyJUhE76aoKiyYhTNMFi+Qv4rBoA3Kyfh6GozjxEA?=
 =?us-ascii?Q?qFT0mAj3NKa+jtP1SP+UUweSqoEgHvH/1vAG2O3dCHh0SFejzHcq6UX/fFuy?=
 =?us-ascii?Q?S5VYoPG9hdr4H/Et8VVQUbFuEkKLGHgXF3GaK8PzfDZgtNZlXFtraY/iIbX7?=
 =?us-ascii?Q?HccYXitfbV1pumrJW4ooD4jHrBVgbcYA4dw/bqdoX7D0PGeSHVVDA3dg25Do?=
 =?us-ascii?Q?85zE2V7cg0esJd7ahcElp+ltdDZM0pevk8jqhGCBvgXCWq+uvrFaWk1qVNS7?=
 =?us-ascii?Q?7fkGbA+QmtFJbN03VRYaCGy+ewUvLuFPV/Ghd/OdYiI7tga/XY6VZ4hZFO9x?=
 =?us-ascii?Q?hTI/Rm/Wfw4sb04PMnsY4HrxFl0Pm7W/VsKN1TTNtLUIALO/1yCLv86T2gYM?=
 =?us-ascii?Q?j/21P5s9jGiPKUVyrVlYAMHTW+c5+5ufqhuGD/sBb7bz3+pbYON+hojBTiiB?=
 =?us-ascii?Q?W7t0uJqjE3wlbIfPZxITFHi/J0Jj6wyFuyd//cieO6oEjC8yNzRY0Me+T8fq?=
 =?us-ascii?Q?GXwj+AIuYTox6oW01Ke2YiNSsl7Iy4a23/SOp4xX3NIth/31EpDsFmDqAbvu?=
 =?us-ascii?Q?58Uxvjp5UwS8c1owhwpoIHCv08j0fMuKcbySeWkwKk0IFjBAV9WnTKrJDmL9?=
 =?us-ascii?Q?OLWlAGOd/DnHp7WS2e+6x2Vsf6aYvOMVcDQXHxiqvijMH775IdFx2guNo5is?=
 =?us-ascii?Q?TIuTGWbMrCBK46Q9wLWPPl8cYh5RjMByWt2p87liiSJJXNFv/7EHg0K106DW?=
 =?us-ascii?Q?Syc71RqpyjEIi21iLGI6VH/f5MNuewRuePfQFOyq3A/Zv92qj7vBGvO2Veaz?=
 =?us-ascii?Q?P47kOVqm3XrStQgNIQJmc2tChLM+UZWZCTF3DIckCj0RpbNLuB5TSQswVfAt?=
 =?us-ascii?Q?eqyAHW0+Lqa0qh/wYAuVMawKE5eK1Qw5QOXCpxHSrBCg2oNDUJi7i4auKmkK?=
 =?us-ascii?Q?5qYqzcqBqiZCHO8U7rE889qoWThfasylDCVupBg6+aanO4ulhnc4/cLfevoR?=
 =?us-ascii?Q?BsOkoIPahm1+T/a2HjvkUz4dNn/K/2uLcWua4rOvdN83MTaZYICFn7PoGEkP?=
 =?us-ascii?Q?K4PZ5oh2adYLrBX3hllSGg7X1a5TZUNeGvrLCOE+3adwasUCxgNEtp2juDVZ?=
 =?us-ascii?Q?LirfUi+pbswQuj/pwcb54rdx6O0C0nQTh+h45lAlJ1K/6VusYG4FtUxCjsQ4?=
 =?us-ascii?Q?wS1LHP7YgtNrcIDMEbqGVFRj651KXGhBcHqizAn06/qiqV4MNbxtxUpGGicL?=
 =?us-ascii?Q?uCIsPal3VibrMrb1qK6hGG2L4CUJJUic8Ro4ugrrmQGs/3Wg6town99bat4e?=
 =?us-ascii?Q?5whGjSgUcGDTb5FSs4REpYlag5ejaEUv0Rk5d79Td891vrOi5cLyBwVeHaQC?=
 =?us-ascii?Q?y+FXJLTvqZIyHUjTMgeSc4l0WlaWN4NMF8KFPKQLBOroFyCOvBOBduWPTZ7Q?=
 =?us-ascii?Q?+TsI6GNvlPSAaFCpFbJ+1RpE584Bsz+vchVCu+H5DbhKgqAxTb8bNfArFpCq?=
 =?us-ascii?Q?Rtn+rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808928c0-3aa2-476c-f32a-08d9b925b42f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:03:03.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkUp02ECOFoHpVvinfGM49QjgifbqwXw7IMI3hNlvRpgxAvcSnMYGtsqBZRVixfzWXrBtgxQQnFyrVM+pEUMH5/tUBYzBYFJx8hrzTwBHSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5709
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070012
X-Proofpoint-ORIG-GUID: ruIpZBu23ibxXjFG6YLrPbFJ_c2760a9
X-Proofpoint-GUID: ruIpZBu23ibxXjFG6YLrPbFJ_c2760a9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:

            "Any MBZ bit of nCR3 is set"

Signed-off-by: Krish Sadhukhan <krish.sadhkhan@oracle.com>
---
 x86/svm_tests.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8ad6122..ecfb5cb 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2183,7 +2183,10 @@ static void basic_guest_main(struct svm_test *test)
 			vmcb->save.cr0 = tmp;				\
 			break;						\
 		case 3:							\
-			vmcb->save.cr3 = tmp;				\
+			if (strcmp(test_name, "nested ") == 0)		\
+				vmcb->control.nested_cr3 = tmp;		\
+			else						\
+				vmcb->save.cr3 = tmp;			\
 			break;						\
 		case 4:							\
 			vmcb->save.cr4 = tmp;				\
@@ -2547,6 +2550,41 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
 	r->rflags &= ~X86_EFLAGS_TF;
 }
 
+static void test_ncr3(void)
+{
+	u64 ncr3_saved = vmcb->control.nested_cr3;
+	u64 nested_ctl_saved = vmcb->control.nested_ctl;
+	u32 ret;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	vmcb->control.nested_ctl = 0;
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, ncr3_saved,
+	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_VMMCALL, "nested ");
+
+	vmcb->control.nested_cr3 = ncr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
+	ret = svm_vmrun();
+	report (ret == SVM_EXIT_VMMCALL, "Test CR3 nested 63:0: %lx, wanted "
+	    "exit 0x%x, got 0x%x", ncr3_saved & ~SVM_CR3_LONG_MBZ_MASK,
+	    SVM_EXIT_VMMCALL, ret);
+
+	vmcb->control.nested_ctl = 1;
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, ncr3_saved,
+	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "nested ");
+
+	vmcb->control.nested_cr3 = ncr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
+	ret = svm_vmrun();
+	report (ret == SVM_EXIT_VMMCALL, "Test CR3 nested 63:0: %lx, wanted "
+	    "exit 0x%x, got 0x%x", ncr3_saved & ~SVM_CR3_LONG_MBZ_MASK,
+	    SVM_EXIT_VMMCALL, ret);
+
+	vmcb->control.nested_cr3 = ncr3_saved;
+	vmcb->control.nested_ctl = nested_ctl_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2557,6 +2595,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_canonicalization();
+	test_ncr3();
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
-- 
2.27.0

