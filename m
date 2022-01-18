Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AF0492F03
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348950AbiARUKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:10:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22822 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348932AbiARUKa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 15:10:30 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IK8St4022642;
        Tue, 18 Jan 2022 20:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ruTt7IyJ4Bu3xxmAw/a3dbWcih2mr+cnIKXBGkWwIX8=;
 b=P5d7g0okhrP/2IDQKlmgZMVGNo1LI0jcn0585lI6H9DiLbUy1LNESLGSe1OGqB9HqBTD
 U1KOpgfmuPBLCyvKi4SumFxYi6boyWeIexKJvM+dIYDH7Jx7Fwab/tEGLv3ZUoeLJHtH
 HJnwaYDkGxHOSefO+OLQnnL9i1FRmn/lSZWmARC4hhndxbMG5kII5peclLDVogZHBKZb
 klKd/TOtuBEgCf2qY4Q8aSiwGwhLOYC3h/uZYyHCbejpOV7i8GIq/M9qXzkB8q2Ca2CJ
 MnAfngL86FBDkXQ6DOEqQC69lZHpTNmd1D++TrYKiYEN9l8BEF5oa9CB/nzvWw5t95Gh QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4vk2p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IK0PbW180361;
        Tue, 18 Jan 2022 20:10:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3dkp34rapw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5x7fXLw/tw0XQADbryPEHLs+FVavgQ8IxB4mlJ+YEwFD/Iaj8Z0VverE0KO4/1Fp15A4EHts6CP/3Xl1fzcyarp88YIP9Ay2Sg9gj87FdZ1QLsomLVVYClHqZQkPEiKJrpnVVdRHHqdf5tlzE2JROP66qYuD//UNrtIz6sq/GY2rVNB1vE0yCRjw+icfiBC3qFfATe6Myc6FI7tTEAr1F4jhjGCw4LNTg8Uji3EsPoyRwNN2OWUjCbT2KM0XaSzcHnmCGuPkP6e6SveF+SLGgRxd/K0ZZbGPdshEBSVYpG6VtXBodKbruaeF4URymb9BVw4XSu8LKPyMdUTGWrV5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruTt7IyJ4Bu3xxmAw/a3dbWcih2mr+cnIKXBGkWwIX8=;
 b=CJZmZdWiRBVbJAORfBwgnsXUY+Kyb06kFsLNOVHM+lv1wPchhvvhSkTUdzojcp88yz1WiVf91uKSQdKncxpKCau5vqhNuIzEx4r3uTNMBoFvS5FthZmlA1BSv9pieUTmtrI2YobCiFB24NwCH2IH1/1ILyhZI5ne21JvuhaK0lvOG0Nz4p4l7yeEstvqiWxte9/tbmwBLcx1e+/eEEdyYupP1CVoLdMurzP9IJirbj6ztlB9gdlPVtg7oHIAo1AXhahf92MotDfvV2Giz5+pLOL52FEU85EHgAouOOZv1F3N+jWhXGYHAbyUBRaPd4d8gOyX7g3DrENkQojPiz45LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruTt7IyJ4Bu3xxmAw/a3dbWcih2mr+cnIKXBGkWwIX8=;
 b=oPFhzJkLx0ih5zX0MlnhlNwNRg+0bBuMb7f87idhWFjp6MzPaSZ/AxaipvnMrPyLZmO98APHKHBCtGLBnKuvWmDFP7Si4vWtmfZCcgLduPv1xr3KzHwM+v4iKZI97IKp37TQrkmU3dLnIXoZAnJnQZv0WnGfBnr4WnNx9tZZT14=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by DM5PR1001MB2154.namprd10.prod.outlook.com (2603:10b6:4:2e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 20:10:24 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 20:10:24 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 3/3] nSVM: Test G_PAT fields
Date:   Tue, 18 Jan 2022 14:14:49 -0500
Message-Id: <20220118191449.38852-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
References: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 709e7cde-c900-4460-918b-08d9dabe8fa2
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2154:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB215423B44BB011B32EC2721281589@DM5PR1001MB2154.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eRPdUQmViA0m6+AZFBQp0WsmjgidWz/77B/ZI0qAMrVUAFkCNmX3FBhPP+BxbBqXi2uTyiQr0uNpfEA13LdvlHzj7/nkWLmUB2B13sUfkRqrkQE7EzoHKscDcKLXDNLCvOR1vXZK0SO49LQ/vptiauaC0ogQzhhzqQ/Sn3UeMcJSQAV/cBQeUYXvcuodMD0RCflw0J5ytGkk6A4X0i0ewcAe86GolAfz+VsmlHx3cffhh6SLgqf5BF773YVvSlUocHUdkRNdxChuBwOy0zyrNDpicjI9zmxfE1DdXU2uO8yNiwhLvCmfZ+Bij8QzVjjVStMA82FcBMBc9H3Z/hI/SYbxxhb+Qad7GjNNNOKKZTpgZP2Ml4R7ODU35rU5fcU0c0bd6UsnB80CK761T+kjeWGoDHGwfdj78/gLs47e47SLUY3DnY+SSFJtA3tsvztpX50Di1JyxgtqaQYCcHV+13ZuPbHQqrUHFd/CEr43BncDwlOF/r6wV8O+Jz/r2RDML0+tbmAglCoM0QS7uSuuCBXnbr5phYX+QMuPD+J9wuGthr8lQc4mhlluIkrGe0k47rbfYUnge2CxZE3GxWTRXwERriGUfSpkhmRR5k9iCvMN81njxV5nzKLO7WKmyyhIz6cWSLrAN6rCPKbS0CdaTu63eNHwLqQ1N924gNzghttL+ZijvM/OuiW7/eTX1Gk1iKT6Vt+4/HhXH2hOP9Ni9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(38100700002)(38350700002)(4326008)(5660300002)(66556008)(8936002)(8676002)(6512007)(86362001)(66476007)(66946007)(6486002)(316002)(2906002)(186003)(26005)(6666004)(44832011)(36756003)(508600001)(2616005)(1076003)(6916009)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNsM14+yRSdvtKKYbW9B1kunAXlHv60/C8LuieHMDMfF1PL6/3AGtyz0NneA?=
 =?us-ascii?Q?yY4AwbzCfHXNJZ30vGYTkIXiC/0I0iOgKSibZWcF3HqMSoVcwvAa2+yaqIN/?=
 =?us-ascii?Q?8D6kRcPlVMtTthFvOCaLoLQ7KEN1I7FFY27gVsIyQks0vWlFvsQG6CUXuHoR?=
 =?us-ascii?Q?PMoTHtJfkCOAJw02KB40YqGkM4mefgjyFModfQ1kyeZ50rjqWyyVNwlTLreu?=
 =?us-ascii?Q?S4eJoiqCosqvBASkscTMd3/whgDoe2NTi9UEReSdAb0IBnBv9YttJ/MmXKUE?=
 =?us-ascii?Q?l4JV9EYHtx6JoFvfMPRg1VZv/xqK5tZorRKtFvwuOlG2a+09LPfIMz1NFUJ5?=
 =?us-ascii?Q?nzSYtbqzQGKbkmXq3XlKvGK0+dIoDu4RV+pZRQqjBLS9hRuwG+fryL91Ett6?=
 =?us-ascii?Q?25NU6bQwNxTajeZvbPHCC+UMuWXnNogz5hFcD893VSbODtmFh4VEYX3EScj9?=
 =?us-ascii?Q?Ribz1k1e/VBJqnoG9kJlwXsLGW1UXpW1vqXfROEengWmA5ACHOHpju+ujRzR?=
 =?us-ascii?Q?bZd28iqmBLgT6hvKrZTyI9rmYmEoU7zWfS01Cue/zpIBAECkq+M18/GQSAVv?=
 =?us-ascii?Q?0UQgBV9O5MPsPuHM+rq12i6KrGvso9XlZRQ+l6AHSZsUHgIc4GvAV1/bfvrX?=
 =?us-ascii?Q?DXhrHhiFDSVIYBxOKm5YmG9rxI9esN0j6PnqQsNqS6mPGSJbiUF3FvN3zkbP?=
 =?us-ascii?Q?XgsfFJ/9fJC843yjuFIOKtFI4ypaSVw4Iuto2gZB8crLE/ERGJ91RQYwgE80?=
 =?us-ascii?Q?SazimEI4wv8K+RK+fTUd0J6dvdTqJsASPbssay2upJqfczylj2NgVeHxYPF9?=
 =?us-ascii?Q?7gcrwg5cUUVX+mBqSSRJNGSGO8kxLC3a4EhgfF1dJpTAycyi5rrOvwH+e8q1?=
 =?us-ascii?Q?C0VCAnsYEBwvgPMVq5qjemCKrVi9Ef5sMRvCWaWuOyQttewr8jq2zzHFiOh2?=
 =?us-ascii?Q?qbdOd3WXiiUAX4ReHCyU7PFtUuFCr2UiFJ1fmED3xDjcKwIL+yG5mTG0wbvr?=
 =?us-ascii?Q?Z/khlCuknDYXBd2qLxmkIT98lf/BmZ8LzXRAWKZOK6ED2ZXwgrdBYLDohCdx?=
 =?us-ascii?Q?S4yg3Wok/wzhcXpTrO5TE3eOVxu/l07/3rE7a38uCHFGn5AYBssw8vPyK/Z2?=
 =?us-ascii?Q?y8AXWzunCgE0BwvA6FJZmiul9cD0YwskebOKvnbGaXkQQcm4/sLrk0jsGGGu?=
 =?us-ascii?Q?3z1si4QxZS1JB4uh5/W7+hRiK3ojnDYCrBfaXwwyI/o1eRTjfb0egz7m/Clk?=
 =?us-ascii?Q?McZFV1cp+WsVoju0IsfrdzXd6AiomFEXeu6UZhLMUveLklBSYvg5qH51AdJa?=
 =?us-ascii?Q?imSugatcVJu+TmJuVt+63mWZNony7L4KIOjgCuxrUdf8M58R7qOJAz8X/Rly?=
 =?us-ascii?Q?zpHYfABFABkjOB03Gxw2BW83QKrK8qdQaizrPw32mv/4BtGsZZUNFsNmNcyR?=
 =?us-ascii?Q?C2QUa34hxML/anLTtLP5Quk64Um5yAONRqM87eVbnFQIcGsLLObFsjD0djds?=
 =?us-ascii?Q?TxikXLNsQuVsAfR2jflt4tagq+UpBNyGwoAX7fu8Z7802+KIfCB9y+w1m94K?=
 =?us-ascii?Q?0/46mcRGphYwMK06RRye3wYGAAmxNSkuUjgh5YayNkswpz1uqNNhhorUYeJQ?=
 =?us-ascii?Q?1PBwhTKVivANEVH7hpeH6Okngj6Lz4vETZTS+8d7sx7X6WGdjyWxO64jDmah?=
 =?us-ascii?Q?eCttoQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709e7cde-c900-4460-918b-08d9dabe8fa2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:10:24.0104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j15ohivZX8k548rZcYNnF1T+LCy/uJGyMrV7bLkQcdE3ErMJxp19ivMgkeMkuQWJ/U+BC2PTlPuYworV8mb8o4e/HtHYdh/rgbfIbBEGjUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2154
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180119
X-Proofpoint-GUID: uCaJAirYPKwxfg_zsqMFxqPcaJsQVkSd
X-Proofpoint-ORIG-GUID: uCaJAirYPKwxfg_zsqMFxqPcaJsQVkSd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:

    "Any G_PAT.PA field has an unsupported type encoding or any
     reserved field in G_PAT has a nonzero value."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/asm/page.h | 11 ++++++++
 x86/svm.c          |  8 ++++++
 x86/svm.h          |  1 +
 x86/svm_tests.c    | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index fc14160..9ff9329 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -57,5 +57,16 @@ typedef unsigned long pgd_t;
 #define PGDIR_BITS(lvl)        (((lvl) - 1) * PGDIR_WIDTH + PAGE_SHIFT)
 #define PGDIR_OFFSET(va, lvl)  (((va) >> PGDIR_BITS(lvl)) & PGDIR_MASK)
 
+#ifdef __x86_64__
+enum {
+	PAT_UC = 0,             /* uncached */
+	PAT_WC = 1,             /* Write combining */
+	PAT_WT = 4,             /* Write Through */
+	PAT_WP = 5,             /* Write Protected */
+	PAT_WB = 6,             /* Write Back (default) */
+	PAT_UC_MINUS = 7,       /* UC, but can be overridden by MTRR */
+};
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif
diff --git a/x86/svm.c b/x86/svm.c
index d03f011..c949003 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -94,6 +94,14 @@ bool pat_supported(void)
 	return this_cpu_has(X86_FEATURE_PAT);
 }
 
+bool pat_valid(u64 data)
+{
+	if (data & 0xF8F8F8F8F8F8F8F8ull)
+		return false;
+	/* 0, 1, 4, 5, 6, 7 are valid values.  */
+	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
+}
+
 int get_test_stage(struct svm_test *test)
 {
 	barrier();
diff --git a/x86/svm.h b/x86/svm.h
index d4db4c1..d4c6e1c 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -410,6 +410,7 @@ void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
 bool npt_supported(void);
 bool pat_supported(void);
+bool pat_valid(u64 data);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8ad6122..4536362 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2547,6 +2547,71 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
 	r->rflags &= ~X86_EFLAGS_TF;
 }
 
+#define G_PAT_VMRUN(nested_ctl, val, i, field_val)		\
+{								\
+	u32 ret, xret;						\
+								\
+	if (nested_ctl) {					\
+		if (pat_valid(val))				\
+			xret = SVM_EXIT_VMMCALL;		\
+		else						\
+			xret = SVM_EXIT_ERR;			\
+	} else {						\
+		xret = SVM_EXIT_VMMCALL;			\
+	}							\
+	vmcb->save.g_pat = val;					\
+	ret = svm_vmrun();					\
+	report (ret == xret, "Test G_PAT[%d]: %lx, wanted "	\
+           "exit 0x%x, got 0x%x", i, field_val, xret, ret);	\
+}
+
+#define TEST_G_PAT(g_pat_saved, nested_ctl)			\
+{								\
+	int i, field_shift;					\
+	u64 g_pat_mask, field_val, val, j;			\
+								\
+	for (i = 0; i < 8; i++) {				\
+		/*						\
+		 * Test each PAT field's encodings and		\
+		 * reserved values				\
+		 */						\
+		field_shift = i * 8;				\
+		g_pat_mask = ~(0x7ul << field_shift) &		\
+				g_pat_saved;			\
+		for (j = PAT_UC; j <= PAT_UC_MINUS; j++) {	\
+			val = g_pat_mask | j << field_shift;	\
+			G_PAT_VMRUN(nested_ctl, val, i, j);	\
+		}						\
+		field_shift = i * 8 + 3;			\
+		g_pat_mask = ~(0x1ful << field_shift) &		\
+				g_pat_saved;			\
+		for (j = 0; j < 5; j++) {			\
+			field_val = 1ul << j;			\
+			val = g_pat_mask |			\
+			      field_val << field_shift;		\
+			G_PAT_VMRUN(nested_ctl, val, i,		\
+				    field_val);			\
+		}						\
+	}							\
+}
+
+static void test_g_pat(void)
+{
+	u64 g_pat_saved = vmcb->save.g_pat;
+	u64 nested_ctl_saved = vmcb->control.nested_ctl;
+
+	if (!npt_supported() || !pat_supported()) {
+		report_skip("NPT or PAT or both not supported");
+		return;
+	}
+
+	TEST_G_PAT(g_pat_saved, (vmcb->control.nested_ctl = 0));
+	TEST_G_PAT(g_pat_saved, (vmcb->control.nested_ctl = 1));
+
+	vmcb->control.nested_ctl = nested_ctl_saved;
+	vmcb->save.g_pat = g_pat_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2557,6 +2622,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_canonicalization();
+	test_g_pat();
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
-- 
2.27.0

