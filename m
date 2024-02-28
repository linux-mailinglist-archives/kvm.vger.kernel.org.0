Return-Path: <kvm+bounces-10204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5284286A7A2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 05:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D33271F25A22
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 04:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB4220DE9;
	Wed, 28 Feb 2024 04:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lNj/4UlD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dfU1Lxxs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A164F1D6AA;
	Wed, 28 Feb 2024 04:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709095045; cv=fail; b=Celgn898B0aSJpIo/lc/pndUa1B+RIISg5PEUqLWuQLCN6HNb3XHAY3MqVVkEdGWoIf2IRW/T9TCzuBfd4QmOdRGXqjHKlQBYuS8vJaEZkV9KJQWp0XwpriK1hYjY7/lvvnmuvBRHYi0DNU80QmZhtb949Dp2VDTcf/yl+m204Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709095045; c=relaxed/simple;
	bh=vprFtCxaVmM5wzTznqQTp77OzAm1gAPNyI8ch9sVdkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lS2jlyoaJn3uHWaRL4e+QhdkWw4siwdhZN108WYjAvArk1+KFSxBD30i4qkwwMbg9jrnGChOYnFXm8tqhNRSwsZ3qfch3gumwDZYk3vMo9ipnY2KIDGNVcgyHzNY86ugTuSiaCtK6CoBjEuLaTFVCH0p8VOrsesz1u+74UCR1g0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lNj/4UlD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dfU1Lxxs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41S3iU0j018781;
	Wed, 28 Feb 2024 04:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=TlJOiruQ0UPO/1xxAKrT+viFXbVnc3eBe7acDiBkY6Q=;
 b=lNj/4UlDdKTqbrNP9xKnwTH6gFA5kfQM/J3/D6zW3VNNbtKa6LzuB/NfFNjwqSFDgiFa
 V0tY8EYrH+32d9nMm4zhykYXhiOn6WFWA571j/N24uY1UPdOqF6nY1iKX+MhD0yJD1Ko
 Q7tJZc5Q6/+1b+zzd4CR9C3+naqMjzLtNGxC+CXUOaPfuAbWmOEMgbjEhIGn47TPAqoK
 19Ri8ho4Iy0FsDvky9uKcaDr4iJCzLRF2FgoDkd+73qc9lMsf3BkdU2XMpmZAbKzlHrw
 0raS+QLNAyf1BAyrxb+rgrnZJI+OrnzP+4oRRX1RfUZNSTyqTqfqYUqaj74YaezKg6rz Eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb945f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 04:36:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41S3G9oS015331;
	Wed, 28 Feb 2024 04:36:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w8ha86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 04:36:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3XUfwHFWoGgcjD4NsJP8KG03UvMDchyapi4jirCz9Cc/i4ps3MDiLcLSfjck1x/k4qGaB/5uWYaX8nlPfg4IAVgGRU2MD/ny94Yynt7UzSqLiqMkQY/nXQBg+O0n4HZlkI0VOxXirNRn8/qIxslQX7VDAYB20/3k7XUZOVSUhMUdAueokS/bjDI1yy9HtOhTaagZXmHd0eXXufoK1CiYgklY/NPK+Ms8U6am3S4RxRlPJv9y5ilNsQNePOUMjQWEGj3lAH2PN0r0UpDwORHI3y4MC9ldkfBZOt69ZDeOW+N2sFSqaIKZbVYShMdUPPr0CmekxU+v5EV0eBey0RK3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlJOiruQ0UPO/1xxAKrT+viFXbVnc3eBe7acDiBkY6Q=;
 b=ePb9OvnZaeNYXBU/BGmUqyv2ytT6YbC5sjS1uZU2QCSgDqbHHUisU8ZISJ3EFRKqZQtmUbrrbIrFmfTypcpUYMPAh0U9g6xVOCmtA5et9vETpj9AGR65WSYeZuyPlgn+gkMluMqXVlE1UE3bhZBz2EorKPs+zCPJsPAVsACv69PvhwEiuLjZWN62UnzzRNh2CpuMIcGakgYGFAxtcNU2Fq520pNFuwws8zbsPquN5WneYqNr+W7rLwAPWYrfDzak4ObDsrC9WVjYudpoH4I4VD4Drhvk0B0s4QS+eg7/RZCjLQf0WvF7ZL6g1C8Hx5BoTbWXKLRBvu/wdUZqh9OHsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlJOiruQ0UPO/1xxAKrT+viFXbVnc3eBe7acDiBkY6Q=;
 b=dfU1LxxsJPgseb9FBMNLeS8IgcxfBHtV/ZznZ1rpGMuet3tcVL1pIFrUjNjjIJgiDoDhVtrFHVnv0d47A+SnNEGW4RjWi1A76LlfDOBWhQLD0DSNLn42Az+F7FAm3dOhZ+CIh9ik74rtH1ReiOhNwEJeFf8noGw2akM0Me2mlaE=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4641.namprd10.prod.outlook.com (2603:10b6:303:6d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Wed, 28 Feb
 2024 04:36:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::2bb1:744:f397:1d4f]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::2bb1:744:f397:1d4f%6]) with mapi id 15.20.7316.035; Wed, 28 Feb 2024
 04:36:21 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: misono.tomohiro@fujitsu.com
Cc: akpm@linux-foundation.org, ankur.a.arora@oracle.com, arnd@arndb.de,
        bp@alien8.de, catalin.marinas@arm.com, daniel.lezcano@linaro.org,
        dianders@chromium.org, hpa@zytor.com, joao.m.martins@oracle.com,
        juerg.haefliger@canonical.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, mic@digikod.net, mihai.carabas@oracle.com,
        mingo@redhat.com, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, pmladek@suse.com, rafael@kernel.org,
        rick.p.edgecombe@intel.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Subject: RE: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
Date: Tue, 27 Feb 2024 20:36:45 -0800
Message-Id: <20240228043645.2716589-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <TY2PR01MB4330F7FF122BBF12EC0ADE06E55A2@TY2PR01MB4330.jpnprd01.prod.outlook.com>
References: <TY2PR01MB4330F7FF122BBF12EC0ADE06E55A2@TY2PR01MB4330.jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0292.namprd04.prod.outlook.com
 (2603:10b6:303:89::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CO1PR10MB4641:EE_
X-MS-Office365-Filtering-Correlation-Id: b092f383-d6a4-4cd9-111a-08dc3816cfaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7DElE2XuA+MdcherhEGL1gH4ryM6UwY4sLYbeU060a1TwQ+q4tGBQY9jZo5VpQlHgwKqYMtRMwnvUzHRroaFFluBe0/4oiat7M/QMpq0GJBXIRcRJs0zniSIZRm7JjvPUonGL3VVDIvCtO3iIXeu4S8C5vgBUDfb3WQCVL8TOmIXSnmr04GwFoThCZnLHczkB5L4zJjPjUVfQjwCTsaseiRs4vorCk1+WupvmxAvUl4ZxztRF6RdS3RnR7RMyZZHd3WRmXCDqwQSb7j58ei+0uFwUVDs7PKQrfrDV+0TdIDrPvwJVzhCIHNV3/3m7k5UEACtXcNPWMKkI69EOSICNRIEIlvSPyWbNhcG9FQ0syhUxMpG88QdBBVZqQXYHh3DaT9E7ykeLjQRU5oZ6vODPg1pfKQlLUaAoABvzsbt6bjXzVg5oGLtVd0dHfM4tGuuNzruRmSTc1kNCmaiyH6R2Cyw5MiSFK9FHpKyBRWkbqm/PqdariKY6L2w+QNcyaIaKZYvEvjZq7Hd0/XUqwl09YEK5ce9885l3eGeAHakWVBAq3Aeys1I9hmAZBQl2bKTAhIDxxk9ZtwarmIkhQS7mQfkXhxLq33bUs+F/dW1L0omsYpaF1maa914R/0K+J6+LPUqwaaojgG6lN0vvfY2jw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?yCNTkn4vcyFscRh6vqv2/9Ejcj2PRr/Zfu5I99V/ASPK6/AKqUQljfH3zfr6?=
 =?us-ascii?Q?dPMjkqmeWK4SYXxDLIbpvgfmKlOQfw1uDeXYPncWt9vVcxiI8JQL1g8kxjB1?=
 =?us-ascii?Q?cveXHHBeWz3s2YvJTPa3OxE2UnSiBdttr74XOClNNb3nwuRrkGSDjtrA1SsV?=
 =?us-ascii?Q?2rARpK692n+w0gU/DvQw6rfbUyhez1VQCTK4JDvLuYkyzQ/gI1ZGpjp8RJBg?=
 =?us-ascii?Q?yl1m3jZfn3KgENGf0RlJ9bVX1sitLiPibnK4XigIO8rVCw6WM6whS9gocIKy?=
 =?us-ascii?Q?Q+uhQyRnY3fH3WeWpDVOcuvkzCJsM7sOrLnhbRBaLugCaFk2LEUXcbdsD2L0?=
 =?us-ascii?Q?nlHOWufheqSIc5kYdfPCfdRzdFI4Gw7ta0hNtzJsTzRpT5/xyQRu2YZ7IZYW?=
 =?us-ascii?Q?FnvfCShjgqbd3P7r67bUxImlIvd+1vvO2+ApRO0mVzdTFgal/XIapChZEEIl?=
 =?us-ascii?Q?nlylXFFX89KfqZgZjNz36gWZ/i9OzvSeaO4bTTDaQKBmNm42z34Mh7kmBbvj?=
 =?us-ascii?Q?qLwjbM0c9K2PZ86gPTVkc+SY0J74DKXr0D8bar8rMYF8nfrRmFUMsTiX8D3g?=
 =?us-ascii?Q?bCIHWFn7YdI1BnHHYH2iUSr5/ypa3ILVeOGXsf3fWN0bQ8QT8dSYMzVTJn/y?=
 =?us-ascii?Q?F99Pdgs3RNMnQFCh9STS1WAIlqBhuW0i3oIWo8p8H/Px0bvyqrhDrpxE+CfZ?=
 =?us-ascii?Q?muqzykTqKj9u06a+oLp91wusHlutP2NiUFjV8M2YsZV0qf/KozITOhIBBzjq?=
 =?us-ascii?Q?i10cVzxZpvZTEsDAjfPUKxaVSGQKpj8v3S16zfCz9y1QB47PgW9rOp92Y+TO?=
 =?us-ascii?Q?l80tF4cPtpG2NdgdhAXHaLqTQ1llr2usPMRSFgRj3SZJbSX5L8YtvQBTTg6M?=
 =?us-ascii?Q?RozWbhAMe7NDeGNEXnLf+BdXKSZ8o5U3Wjh/I0gEa+jiMkLppjbzl7JlR+hA?=
 =?us-ascii?Q?eysgGzWFLOjOPwT5lyp4muCxR+XwBCG1sJYe9H/KFksW5C0ZfggRri6t3Wff?=
 =?us-ascii?Q?w23uoNIOTu414MMif1F2PtQyftTZ6qPhEFv5jefHCDi3sErnSXm7tB6E/OGU?=
 =?us-ascii?Q?DuWL8TE9ZALd1bFa1CjgOwP4ja7/+jeOVmgQbEzs3l6dMesO//+xIuni4PQl?=
 =?us-ascii?Q?hLv8k0435ZFu+kkyzptojh26BJS37hQfITvxVGgeTimHyxjPTPwE8EjgLJFd?=
 =?us-ascii?Q?GcEpSb8OHr2lL7KWTC0Zq4WbgBote0eQ+/5kUwgqieoIdp+/3k5qRyC4RN78?=
 =?us-ascii?Q?oN7Ey9l1BeTNtMpKXfFREuB4/EmKUkQ/6YU2KaV4ym2BeNSlsYju02YxpsWj?=
 =?us-ascii?Q?ojuTKcq0kMsnBH4dxl+e4Ge7NP0UC8adskY415MfN2fIc8rnqz4dYy7Hcr7B?=
 =?us-ascii?Q?tt6Xv5nSejhdMyF+LTZZpF2ElAVJ2AmnKxfPTOe8oopOuRR4PBE2YgwcNVRH?=
 =?us-ascii?Q?BRvTHqCttk/m0q08t746WeCYavc2cN1dm1W+gcMJ92OyJcr+TTJDMtSN4CNQ?=
 =?us-ascii?Q?2Vpp6seuJ3MWlol/uVoHSBLbWZLTHj5+aMnj5ioxXnKVbzlXWEzZ6RGxswA9?=
 =?us-ascii?Q?ii2VhaZvBhMrwGLv3Anyfhu6U6XA8zxxtt43b+RQqr63th/0hBF+cqX2DqTa?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QkmbLVH6V9x/sc1OOlU1szMxf2xjyiwLbnQRxn52pi7UfdQTACZa8bzj2yO7tVjJ2B0N/TS5haC00u5xUoZM8bNrVvGJtd0ga/+6y9vZXWLm13kcn/a6zAgl1LG41Z+Qx+jQz5xH8S/L5v2hT75CMXp28DufX4yX3evANIS0UiZAIgQthnZIzJJmoxeWK0nhG6oEcNq85lenkLu2ABcE+lSNlqQT9pner1LnWCEG0ct/ZdIGGpqk1deN0dGZKaztECgZ5HfFq7OJzBgmmuJKAmH7rKREN5ubkpQ/lsgip2ACXJhFrAyvYj1Ft124I4v5AFLkrbO9kwK6V30AHU/LiEAl4ldB/Z1hAz4UL3LGNGR8j6sZPJUmUHYwH6S1THqu2qRt/TuJobJFGzezfH153QRqeBlFnDYa703c8iHd40LUbJ3EopTHpDnL9yEWRnI1IdUz+0QmNtS4V7fWwAT6tJtr3oRKHXwbvZ3JmOwBU6H9kiV/rPHelyR8UqCi53UnKw2ordSpTLHQNxxSb9oWRRuN3H9nQJ7xTZW7xTsRCvddFxGJ8Z1/Qo5Jj+nHczfWCzlhg7H2DTzAmknJ63thxURvgMYOagtWUSG0EXNlOsE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b092f383-d6a4-4cd9-111a-08dc3816cfaf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 04:36:20.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sx2py2I/nXqytGmTJp5WYDHvKliFC2kTEqr3nE2udMzJUtDAKCEZZre+qmVJ6gPen5Fnl2vZcpYUC2uCsMjGt6POPqcnWI0EBEJ0EodkIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-28_03,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402280033
X-Proofpoint-GUID: 83m5_lT98BSbXZjKGAV72-ioJRvqV1Ph
X-Proofpoint-ORIG-GUID: 83m5_lT98BSbXZjKGAV72-ioJRvqV1Ph

Tomohiro Misono (Fujitsu) <misono.tomohiro@fujitsu.com> writes:

> Hi,
> > Subject: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
> > 
> > cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> > smp_cond_load_relaxed which basically does a "wfe".
> >
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> > ---
> >  drivers/cpuidle/poll_state.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> > index 9b6d90a72601..1e45be906e72 100644
> > --- a/drivers/cpuidle/poll_state.c
> > +++ b/drivers/cpuidle/poll_state.c
> > @@ -13,6 +13,7 @@
> >  static int __cpuidle poll_idle(struct cpuidle_device *dev,
> >                              struct cpuidle_driver *drv, int index)
> >  {
> > +     unsigned long ret;
> >       u64 time_start;
> >
> >       time_start = local_clock_noinstr();
> > @@ -26,12 +27,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
> >
> >               limit = cpuidle_poll_time(drv, dev);
> >
> > -             while (!need_resched()) {
> > -                     cpu_relax();
> > -                     if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> > -                             continue;
> > -
> > +             for (;;) {
> >                       loop_count = 0;
> > +
> > +                     ret = smp_cond_load_relaxed(&current_thread_info()->flags,
> > +                                                 VAL & _TIF_NEED_RESCHED ||
> > +                                                 loop_count++ >= POLL_IDLE_RELAX_COUNT);
> > +
> > +                     if (!(ret & _TIF_NEED_RESCHED))
> > +                             break;
> 
> Should this be "if (ret & _TIF_NEED_RESCHED) since we want to break here
> if the flag is set, or am I misunderstood?

Yeah, you are right. The check is inverted.

I'll be re-spinning this series. Will fix. Though, it probably makes sense
to just keep the original "while (!need_resched())" check.

Thanks for the review.

--
ankur

