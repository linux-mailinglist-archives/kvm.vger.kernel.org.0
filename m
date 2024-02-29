Return-Path: <kvm+bounces-10551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BE486D627
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB37128B907
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 21:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2B36D527;
	Thu, 29 Feb 2024 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D6+VMekF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AFfNQFVG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABEA16FF5E;
	Thu, 29 Feb 2024 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709242029; cv=fail; b=UehZfvnqWcZpLiN3w/Li1a918fM/JdO0vYtlarc109zmMC78HCSNUyjPxgyWo3cVHviWGthC9jDZDum58YVX271Yn6OL/zZn811H9frc4t9qdb6Fl800MZYhZjX2NnN2X9zfAC7K5ZcC4LV+xasgUs5EwdRUWszX1cMCLkK7qiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709242029; c=relaxed/simple;
	bh=mItibZ9SycnmPJz6smQB8xJlvb2fQeRH4p6BZeyBcfc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NXXk3qaJfnJ6ocbOhkpoiEAEpmfOnCelGnF7+cuPjztR2EOInAnO9xYzgotX7CnDzcTB84irxYETRIsiXQfINlHmP1M+xya+MWjBIetEi7Hvht9uPn16rDM0ODUOTDyE3JHxOKv35bN8xye9f98xtsI+AfFKT1LEMhg/X0np8+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D6+VMekF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AFfNQFVG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41TGEe7A016535;
	Thu, 29 Feb 2024 21:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=qav04GRTTBAY7EvSIOwiv3vqCt3toeX3YU+HO4NmmBg=;
 b=D6+VMekF4Z2JTUu4eK1f5hxjuqrZICwm+2psFsxWCEhyx6sRkrY3+pQnwVBsLagmX3of
 34NMn8RVROlz+Xo1bTJSgpAzfdNYHFm+uq8O8R10TeSVvAew4Mtw7ax3h4/BQBrvBDql
 khSpDGhy60ObtgzSA/pyBIsLQ7qprjdRS6X3opdI4siNrutlZGQxdokGhpL8boldBMDP
 gUjOfbYjnkhMVNA+5c6f5Ng9ynEzOiDd2AsVuoCl4PM6AGoUp1R2UcLGywOgYhUQnGsx
 TP4mtFBuVXpTJoL+Q1pUlqBaqFPSIc1R6XLNeaRfLnmBQv6oWTfR0jryuEAdzbUJ4lto pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722pwv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 21:26:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41TLGoxh022403;
	Thu, 29 Feb 2024 21:26:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6wbkjh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 21:26:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJ9FyOsXuaKD/EkY2sSMOqNv9KfUixmISRpDzsOZprUrZHhhrC3B3feDaKxPg0XVnYEKlNLfB6qwxqicBseJKMkdlYs9YYTbXM5xB+ZVkNwg07loBx8A2xS3Ueqz+RM4C6iCsUcMLzzgHGZZ/j5VggZnSyqTJtcgkWJV2t7ImuosfawFB7OG2ucecMjUNy51dhnCeYyhK/XYyxsy4vtd0kXav7j0dDm5u8H2+KtpbEY9VgP6rJN1ItdbJc158++k0DVTMFarBz3PipUR495kJaqjkZLSvdw4k4nUz+lKBUjgyaMhIjdNMucmVGAslkaFT5lrs64SoD/ZTvDbVMVZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qav04GRTTBAY7EvSIOwiv3vqCt3toeX3YU+HO4NmmBg=;
 b=XMWPLQazk7ZmMA0DkRQn3whHzytEx+Uj0UnLKJ8BzBgGCUb0QPLMQuiqyrcZ8kBnSQC3DL/eY5YaRwAiCloZzT6AKu4zdVFS0L6f3kh5byDEUYInkeOiRbEmJEwcKhKivb5fHpWAScoPHJBwAIQmRW7c45UjibfJN8lUfTh5aInPwNHt8/vnYqEFEI5nngyZj7UUYAGTRFU5hRBQekeccKaBQlyk8Rn80iYHwxJEBbh81SRwXB2vZoJgccWZxN49JGbpMNHscQbG3g4ivKoCp1VsVlz7ZPo2ucL6Jy6XPYc1M41BZjDwRq17/CFrtzYrvIxHdxz6Xn42S8UgahCkYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qav04GRTTBAY7EvSIOwiv3vqCt3toeX3YU+HO4NmmBg=;
 b=AFfNQFVGhfatvPhJ+LPRtuQM3GK59DhSUxNokCaXl+t0YgYbCylyJODXkywUQ3rtHcBk38VxZBmqxka9Y6GEkhBjJ/cm2KeVnsiCwgUNvrY7JoMrTinwn3TMeYaTj5ypCobu+kT+98Qcr/v0l4ShAB17DUpjqcJFqxOqFp3DhIs=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB5780.namprd10.prod.outlook.com (2603:10b6:510:149::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 21:26:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 21:26:55 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] KVM: use KVM_HVA_ERR_BAD to check bad hva
Date: Thu, 29 Feb 2024 13:25:22 -0800
Message-Id: <20240229212522.34515-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB5780:EE_
X-MS-Office365-Filtering-Correlation-Id: a36ee3b5-a49d-4e9e-778e-08dc396d2771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nVjgtccpH4KOykuWTz6Xbrm3s3zLyLncBP81m9ko/Gk3+6Sm1zkB46Y79dicr6Mz4rwslIB7k6OBSua9BzV5QQ2ytsQ7Z6D9M8j2aaUmwvG/hu/+Z3hmw+/QXM/LRwydO5idIVp4estXqtqe/a+e5uNKR3woB0nfRMSlymQChyVcNOqHlPzk6MgOQNuSRLe3SkIMTI4+Lwn+w3YBnOuKJMP+1R+DtsS9aN2T9LkZx79AHGv7WfcAUjkSbYePtxEIM6m3KHKIflIEAZDNmCTHuAKP3Z7ntN75pq16A91iiURNvYzaLx5l1aonxAOckx/XUKMQIepYa3iNOnagAT4rH8PjmPjniqKVkW7hKRr2aaei0GzcmOGYV2RU6JOOSvK2QNYo7WfkRBWt7sW9DHLJd4w3iRjSwum8HfLXoXhURSQ90ky+jJq1bSP1+Jp6weBb6BDVEgcJCuYT5HqQdl92HcT1ysrNjBbtV1MXFt1C5gJN2M2HAXwWCukOnT+kjkCe2JnDBL4Ae3zLEy6YXQmvkxLLeKcBWPlpxZqejsH2L/dZNGbLiThOwWQbtL4Y3+9+UtOCequzU8LY+74CrBq06K/+DTOXLR0l59cuqt8Lw6zSN4mJJXaE2AzaFRFeXeIRGLBVPIqo+xyWaZ1O4gA5SQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JhfawYs82+rPd+ZLqcKX7jtVOp1hrv0CHuEmH32mSGP2qClD2hb5DkBh5N+f?=
 =?us-ascii?Q?teY03Yz1QeSDvBRgdHtdAP/BxO2pFVFcg0tZkr79qqtNXre+BmjhvahfUrwR?=
 =?us-ascii?Q?jDFKt037kX9Fth8xUz8v1o5oQoNMLfOWDJLmHIOvKJYKi4NZZCN+1eP5WZ31?=
 =?us-ascii?Q?rcdlY0tK8eRysLpEiW95aQWQ6vqjxPt9C5VYs21hvR51QzVBpvKxJpriJLSa?=
 =?us-ascii?Q?jmVSEGWnEPBcJC7mHY45h2uqqbLUP2UI0d2u66C3lP9lB2Jp4VXQmMAO5MId?=
 =?us-ascii?Q?ppMXANS7+HCrTsQnqMMab9Kpj9waRDdduWP1RzimAg2g8N6fJxSnt3MBWL+B?=
 =?us-ascii?Q?G15Q0xjXU4cCKwlQDVRiyysS2sWc3ZHb0tQ9ennIbHNFBZSGy4RFLRSngz3Z?=
 =?us-ascii?Q?N80hTEVDij8NYMC5UytevphaAuePlmDDGqKUqU5doP+M2e6RvjyTb3PHjaG8?=
 =?us-ascii?Q?VnOlExhy6PL2seuElRm8oEhs3W2nsuJ401AU4svrM43/+4Bpc7WE8H8boPJu?=
 =?us-ascii?Q?PF0bi/NJFNEV5iHA5oM2QGoFyeRUXRLsEhw8miiGR171ER31TjCc5JeO+vDu?=
 =?us-ascii?Q?VBZjKkrPeIwhgNGbWJDX4L37mFFM79+M4MPod1l5CV9TokI3DI8Pq1PD/FvF?=
 =?us-ascii?Q?di7Ur8kjXHIRFKc3AVnKUpSb45x16WxCnQ0TUscExlV7/ufqB37zenxRAXNM?=
 =?us-ascii?Q?oWwVGruAsWeZE6jmp2pCTZ5/kzo/oNHSuKCMR/VPOYTgkFmlV4tD0g4NklLG?=
 =?us-ascii?Q?O60f3/UlxiEjfGEAzjKvxMF2DetrSUT+uLhMCbGQuaiQpB7qycr1CMXNZQNY?=
 =?us-ascii?Q?aDiTA6xDU56Ixez6SpwowL2SQzY7VCg3qUlo38xk7h1Bb5BcpY9RkN+GdgkW?=
 =?us-ascii?Q?gUePTQpDlWmHj2PtaYKdRc+CrvtljceSG7i10mIn3iC9RJlzGH0ooERr1DZJ?=
 =?us-ascii?Q?ove3cl093WevsHYMtxePl/P13pCSKodcWSpCiMEGmgQ1rov0Ux7gQznyk5iO?=
 =?us-ascii?Q?OEKgxwUhU8+xeXG29QswHCQSZPxTfdRAkhIMZM8WS25bKCvQu0eAH0fWoGok?=
 =?us-ascii?Q?sQs+Ie5u4e4jkLfNzH80/YNWaQnj6PoskVq8HwdMXPfaRfZrRccvpynZjVQr?=
 =?us-ascii?Q?PPPlY07PfnR2fGTgsj/WcuBhHgdBLNP/qDQlq8pD5ZO7DSgAB93Nyf6om0bM?=
 =?us-ascii?Q?OyhhvzbKgs5kFdvrSHwD+VGfQIrDPhp4buRzdvZAZ3d8AnIx+pYC6u9/VAhk?=
 =?us-ascii?Q?HO9SLPGYmszmSgzufZH9zPjMZS0jnNDrfmJNCCkUQk/BgviTmoKDIT3pYvKw?=
 =?us-ascii?Q?JO6S8qOLVOZDqplumKcOwHGegu4NEYC1apyIxc65eNlu7w9To47K4FQR8qXx?=
 =?us-ascii?Q?osBe1hYMLMQuqwtothtZ2+eVuSLzuMH6wDBCIKCc9YQkkKNa3kGTniB2SBvs?=
 =?us-ascii?Q?ZPoqFnQT2AeHNG/OiY3R+r68872/jrfrFmYetxe4/sEMtyH0VHsunqrdaCkC?=
 =?us-ascii?Q?VQNFdsajsS65FefkDyVjQhC4ethd9B4/inuDNEFn5BlAvpida0q6oNgrR6RO?=
 =?us-ascii?Q?JBE1bwDxrLxG5mXpfg50RUGhWwnYIoPgrzAHcnpg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IxnRObSBJgILAVJpRuU1+zehmzug8CG4zEo3U4wXScMnqLrixUq1pZAv4h+zMPAgcfmtvoAyoQ8E7OFA+2+6i9O67aq8cBREDr1taH5Snm7Ie3nk9zlxo7CcVzAbq7PradK/b5FTYyWmkewwJtIsOVmz7eAePFp1AZOxDfabCq6gDp63l2cvr8KCT8ywB4UQjHGtdVp5mBJO3iNYjW1uNfJd0xxaFhqmykgHLi9Zjwlisc+dOHQohNTMaRgoUiET1iW4wDBPr9tj7gsEM2zR9qALIvRAVESLboMK14VChTdzJJK7kGj3ViG4k+4zaT1PgiaJILIGK4KxhyaLwfivmxChfcCMrJVMjLEjFP9NrBcik2x/9Z40qdt+cM1cDkKnGvjxVeyhnJWWsu2M2Q5IpbR5B2Xn6vs4cnXZ2rtTesq+TAtwKT9GJ3M0nKmHOtDdsQja5qmbwHjL88j3XqVV/Qkq4Cw1KoY5+I+1imVdIBysm/5f4gBvfAIZCpPWgU7rnnGyvMeXP8ONaxJ5YUU4GJCSVqt3KP7NTWGz2xh/aH37vU72uRQ/dbReq3EE0wFnNMu0bF34c2Vx2k3MPcnZxTSQMOAx389g7t7EEN0aDEk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a36ee3b5-a49d-4e9e-778e-08dc396d2771
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 21:26:55.6935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16bSV4aV3IrkH4Rpb+PsOX5RgIdhzGKqu20dYiWWieGI1sbi5C/KM71SvdNZNaJUuSa2h0PquQcxLOUQUdwFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_06,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402290167
X-Proofpoint-ORIG-GUID: twz0L8ZavW30sRfHmuyHXuv1x5hX3LOd
X-Proofpoint-GUID: twz0L8ZavW30sRfHmuyHXuv1x5hX3LOd

Replace PAGE_OFFSET with KVM_HVA_ERR_BAD, to facilitate the cscope when
looking for where KVM_HVA_ERR_BAD is used.

Every time I use cscope to query the functions that are impacted by the
return value (KVM_HVA_ERR_BAD) of __gfn_to_hva_many(), I may miss
kvm_is_error_hva().

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..4dc0300e7766 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -143,7 +143,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 
 static inline bool kvm_is_error_hva(unsigned long addr)
 {
-	return addr >= PAGE_OFFSET;
+	return addr >= KVM_HVA_ERR_BAD;
 }
 
 #endif
-- 
2.34.1


