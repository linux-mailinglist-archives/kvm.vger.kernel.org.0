Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEB046F827
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhLJAwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:52:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65128 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234930AbhLJAwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 19:52:17 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0cXUX025244;
        Fri, 10 Dec 2021 00:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=226riLu/l926u77ypfEBeOS8GN2KCwjsSNaHJWk9DiI=;
 b=RBfKWWuQHiMspXnMtj+KmPcCLAk3xwXQrHVSteSK3/F+hPm+CpOvaut5CpUlBgNIMWdg
 BJVPzhDncNvj0ynX1S6OJ5BsxCVlNGsS66y5pNnIaLiMR3q+5rDBxIzVd6nxKB9hyZBD
 cSGOTN7N40dTw7KCFSWkFPuZdknd+7LU8gA58hdcqYwnAAmepq/YXrh182jKUTLtRzYx
 3k8eE/H35Kg1yhN6+XviSyDCDH/yTT4/4zAynePWkinK5sp7Cu/58JLam8AAS4dJUM5K
 OSTa/82pSwM74WGFMXPD0o0BzWnQPzrogjRD01IlyJo/TeGxTHbi8z4ar9FZG1T9McbN xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctua7mh57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0jI5Y133642;
        Fri, 10 Dec 2021 00:48:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 3cqwf34j01-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeynQS3c7XgrZMv15HG4BPtCRdcC8BJnCnuDq1mOkK5dVTrs2mviQ3no4jS3bNNS9Qw78tVrzxDqRP6iw7xgNsd9D1eUjJKskYPhzsOIOtfvzFGveqh3DeOUSq8LKU5q54MOzpgYYaMX1GRaqmG2KXlKB1ivk8MmWRefYV1LLM78VeFCiqaTiQmmPia5ovtsxLfbmv2EAoGBSe1OsVmvKzuKO0BgaxXNSLTH+QGGoNLqesgYkunVsv6GzL5jZwUz8aIHHF87A/1lQ3v5PlHBPmDmkvVChdZDidK8oBNsnyb1ritPV2n0PnkT/cLwSXQ0D0YkmbLkdSiVU0kNTOTZEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=226riLu/l926u77ypfEBeOS8GN2KCwjsSNaHJWk9DiI=;
 b=nLE5IrlOSMlft1dSy6IyPelNBpeUF0fppEUip4QxU0OTMmnAXspDFiYZc7DXRR7wLu+dBOAp5AXLqmy+BVx4VH09O9srb7ns+DakD2Ru6nE+Gbx8f5qKZ+S8C0LHdei7H2AmbQ5hN4U/Vg01hjBnck0RJOxRXXnn1LJGjkyH6oNF7y+toOQdLtHdkR7ZQ0zouVhYOck54n0+3VrZvWoDE0tTO0PXtyqrQ8mPgj7wJSkYo/FzVuPOzTuH3GlDjF9lRc6AEL1BKgUZWZgsOGSM8bvF86PJKdYhfnSE9TDKsvqnnHFiD7USwPz3j0cyDBeR5UqoQ6ddD/nZI/jFKzoo6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=226riLu/l926u77ypfEBeOS8GN2KCwjsSNaHJWk9DiI=;
 b=QzfdCvcsU9QUnDdn4J0ZF4GzusIr+fRN9fq79DyWx+wNAPiTYkOJv5iatl7FdAw7E0EqmXQ+1tgY2Oe2MeN1E1TnOkMtMcSvVto7rHzuKuKO7VydgfHsElvDKncWAiNLN73QbKTQ6T3L1pUWufKrChBMJq+lB/axeNmDENCwrfs=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 00:48:36 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 00:48:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/3 v2] nSVM: Check MBZ bits in nested CR3 (nCR3) on VMRUN of nested guests
Date:   Thu,  9 Dec 2021 18:53:32 -0500
Message-Id: <20211209235334.85166-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
References: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0010.namprd08.prod.outlook.com
 (2603:10b6:803:29::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0801CA0010.namprd08.prod.outlook.com (2603:10b6:803:29::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 10 Dec 2021 00:48:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1454b94a-6a4f-4e7d-0c54-08d9bb76cc88
X-MS-TrafficTypeDiagnostic: SA2PR10MB4459:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44592061972C2C39EF2098F181719@SA2PR10MB4459.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lDhlO/cFQT09YI9AKyn495xwa4ojHpjjWPCV1RaECCxhxMw5LkVp+evzT0DGliQ0s6y0SP1A6/B/VNyvlpUgjArk13QywLA2/tBvWEkudrRozaLLs/Ce7YJecIuL4zzOvhU7YPyUGkS4IZ/S/lsZvgkhpbm4gXsndNqgqB7qVHS00aUFHKQQ66WQvJemdETNIR7NsyMrtSSJLX569OUJgWcGkddwQViUzWm5rw80fxTrfnfg/RaTaGHdEZbWZyGaQR6pDQ1fNCqzo/pB2O3NmqKmecBsWhtJwGfwftDCAjGyb5hgftPklGvTFQ2owSQ8UB5qMDs3l1JO/zQfPKPvoW/gGbgZzPWgKOKP20qDqFIMhE/teaubZR7JknnM/KUbITzSoF25KBw2p4yPCJu/dPgRRIUK/6regGl8uhDPyf2OnobtPoQfHT/N/KezRY/osyIZfI8kDsS7Sl6Nf1LC8GOqK4XN/C3OkYpDL7fK2TTDYV7mLhjzKO/yBzqLACYZcN5aQDAQD+Paf8FsM4OMDBVkotXykfBRAd/CwvbVQKDNk8wLdT+mpK6Ao0dFGZ7K6ZcCm5vfqTWkomalSSbXXUA3R9fhjFV+n3nSM/DgmCfjRnj65G10mqSe7GxUEGHV/XpfIHl+ZsBAFzfgaIfnPfbVozm71H7n4xh4nyX7cVBAd7ma200hg0uJZriE0+8nzgskN2N+4gjBp5ZGlYe0bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(8936002)(7696005)(66556008)(52116002)(86362001)(38100700002)(66946007)(6666004)(38350700002)(8676002)(316002)(186003)(2906002)(4326008)(1076003)(66476007)(508600001)(6916009)(956004)(36756003)(26005)(5660300002)(44832011)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HaV/MTZRZR6iTmm95/Pz4EuzFEsYX2O7mD2ep3q4OKjYz8MvFRlynbMXyOQA?=
 =?us-ascii?Q?HN+dLHlla8hMPFMNn8ic1tp3aNHETslPICzo3IW4E21QSlDHhFCP/virfeFO?=
 =?us-ascii?Q?MIXkEL3cCRpeW3B4WWQlxa215U4VH4f8VVQYuCXTpdAj4+HC0yo6b6Baxt+0?=
 =?us-ascii?Q?NcLH7yDXUPw+iU2prdF2ja0l/ZGGAOKdL/9XFQuPrXfDIWwY9V9yTNH6Chyb?=
 =?us-ascii?Q?gteix6GmFaZWvz8KhIY6Akx8/5mSDJ+qk0giGt6wIHoIgWmykC5T+t/1XmUl?=
 =?us-ascii?Q?efu2VroQTZr3wT+KA4JdNcaqYVTbyD81591fhvzdpI0Me97v5KnI9HOxIxwv?=
 =?us-ascii?Q?zU8kDVh/Jw529My0SxRXeSmXtzMIjAuwfSW51jEgE/QHTg5AdCpd4pSeUQ98?=
 =?us-ascii?Q?OCA/xIloywU6rnbkIZvvVCNQYmNaUJ0JA8p9A2np1xmRxUXMC5X1FWWOj9HC?=
 =?us-ascii?Q?VXorL9eMvJt1rnpUVW5rn6qORVGKoUfFg//fuSNMYCdL4M9B0XhBJNfuQRpW?=
 =?us-ascii?Q?kZI+nZx0cGKn429k5Iuy4iD7yoXp17ryQUhDINSuJ7Qwjd0Lw2r0PefQvN0+?=
 =?us-ascii?Q?/7VQ+TT7urpB5R7vUBuvII8/e7+0yv+J0/nZkXmCdw1/fC2YK2q8HCfZqZy8?=
 =?us-ascii?Q?lcv51sbEGhQWHiNsyeOTKtz9pb56Nm715/gKrsRjZHTK7w4hpE7O9b4TZdsp?=
 =?us-ascii?Q?kWpipr8dYV7FwppqOmk2KepId4ZScK6w1qepM9HWzL9zoihDebq1T5K9l2oL?=
 =?us-ascii?Q?XjX+a18sMdQITbKH8axrqxbm3UwYb26iZNEOtsrZgvY6s5SP4qJdi23VnRlz?=
 =?us-ascii?Q?os2hl+Y83VglQH5ZiIreE/KpW5yYNxmWmaGem0AdugtO0XAd8iNMoxQzaWzy?=
 =?us-ascii?Q?x/oNngHUO/YviPw13Xzlg/EBfduHPRT7P2VFYKgDs6zV9n1vmoldet2HFI+U?=
 =?us-ascii?Q?rsckPQJT3pqK7wWzazaLcsODjiellQ2uIfYfoV/M82UD0Oc6rf8WIrwfi0xz?=
 =?us-ascii?Q?hX3qq+m53g2RYJQoZ9RGjstpwuPvMpbuq9ryp9Ilwu/hI6tlHeCN20HAKG8v?=
 =?us-ascii?Q?9sqdw/UIw7QHz9rxVNqwVBwcCIAg91FxBoMnd620WOCqlQpNywx241N7yH9k?=
 =?us-ascii?Q?cUMJVHVOACmG+RECmpwxMPwFhiEw4zB3Mpg0Kpp9TqbT0AzqWnfy5ezHT4jB?=
 =?us-ascii?Q?LY+Y3AiNnAfNjl/ieBQyi1CkYghEzGuzBHY8GpfDea60o+xB8WVvGlCexV6I?=
 =?us-ascii?Q?7DOz7rodpMUzzlVk9HNFwfGrwem5ssWsdeh+Z968KH98slpgeSYO8H5hoWqa?=
 =?us-ascii?Q?BthWQoARSVIVw2+TM2kc66mnlf9BeP8ZHax5EVBzjJ5Hpr4rm/HoZBcQlpFg?=
 =?us-ascii?Q?dJeRDzdbktmDyfN7V4yN7fTx3UkNBLy/KXm5l9eWBvn+IK/yjob0MfoILUiU?=
 =?us-ascii?Q?p4l4S4v3Tpo3ix1cC0CUkSdyA6CcEEZ5AUzapg45+RXdl9gpxSWbOowXGLYS?=
 =?us-ascii?Q?UQot23CKXtKAh3k7gc2DGFBBfzWKJJhQJt+DzQHCIL3JFgeX49LtRlr+Jtd9?=
 =?us-ascii?Q?pgwcqo0PmjmZ3p+bbTd11x6DZ+gBliruIIcLgQi9J7jzMdrebaplSGFqbKrW?=
 =?us-ascii?Q?MVedqS+zjFfYYrmM0dmLujivhgp6beEYBnAgCoZl2mfEtxk5RvcL89fwrssc?=
 =?us-ascii?Q?SnLlJg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1454b94a-6a4f-4e7d-0c54-08d9bb76cc88
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 00:48:36.5232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KN2RPARrSrs3Y40x70igFkMy3VnzLnkyO7MLaJ7GILsl0CPZyqsfLtqdVxN8RcmBcC4hPHQL97rY386Dr1T3FnEzOZXsq8ZixD7cjMO+gAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=892 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100002
X-Proofpoint-ORIG-GUID: OHic8yajmfQlPHv6duU8V9kEbrvxDQjb
X-Proofpoint-GUID: OHic8yajmfQlPHv6duU8V9kEbrvxDQjb
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:

	"Any MBZ bit of nCR3 is set"

According to section "System-Control Registers" in APM vol 2,

        "All CR3 bits are writable, except for unimplemented physical
        address bits, which must be cleared to 0."

Therefore, if any bit in nCR3 is set beyond VCPU's implemented physical bit
width, return VMEXIT_INVALID.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 510b833cbd39..3b1d2da8820d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,7 +247,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
-	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
+	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && (!npt_enabled
+	    || control->nested_cr3 & rsvd_bits(vcpu->arch.maxphyaddr, 63))))
 		return false;
 
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
-- 
2.27.0

