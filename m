Return-Path: <kvm+bounces-37067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 601C8A2480F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF3E5188677F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A4514F9EE;
	Sat,  1 Feb 2025 09:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Esln1uN/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hTO6Q2hP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17614B955
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403874; cv=fail; b=rzkbpN7O7UVqnmux4ByhqHW0f44iIUvPgDC+tv8wnbW0VE338UMGYf+mC8MZA8VDyPJ3I67O/rdTwnHiuktRQLwV1uJ/1fEnXZJBaPiPXEd5og9WPJ9O6K2kh5vvOm2gTuJc7rLK6/DX/rNATzQLUmjEpK1JcyWTWk774gfn/cI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403874; c=relaxed/simple;
	bh=aNpMRJXKk9OOaRmpKqDRJVViqHNAHiMQghk6Jk6Ybh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8JFGE8colH43e1RLQGl84UGOcaiopK1/zfBmCER2MvsZTvbU6ZjXbMx7yXcIZ7yVbU5UCicC7zoswTDjbkqyNA8+D6rc6eyoBn3u0i6zooeIWviN6M5GfeyafVQrYiuh34P0b9IwPGhFwJrOVsaby0rSMBJ0cIRwVgKMYNNpXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Esln1uN/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hTO6Q2hP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5117xBvm013353;
	Sat, 1 Feb 2025 09:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pk7S/ScHV2AT2dYzrlTNrkYTrifwfWjTdDPpGOZrxIw=; b=
	Esln1uN/LnwhEUhbh4I6vHOu7oVZQBKA2L2NMme5BkaDRuzSf4CjJ3/uyoqaQd91
	cicunLfwtfBQ6wLpa9oEiCwISuBTPUVYf+qoPMGcjzvcu3dhoYUXOmGL6FrVwKjz
	2ZzsREZd/pL0YZryNhzNGNoQ2unLj/mFMeLjvE25oDkZIhPJukLu2QQE/ETPNtn6
	xqqrZYz4yQHAzTKA58ISXVBhKsgJAPWiRocAx3mP7rzJz6nTcLPD1o4YnYu+SPoe
	i1fxbltsf9Cjm/yCHBjMudETaQf31vLBmy+0Yvr86Pr8AvTwlZ+K8mOumsBxdnQZ
	nMPikXVBtAe23jSJub7BdA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5119IYWD008868;
	Sat, 1 Feb 2025 09:57:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25fbp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUVbV5l0hMYEzYsgROq3AlUHOVK9el6giPcf9OXp3iAmhh4AAnSgK9ggEdMhszLuotmpxAgscIieqLje3q/pL4/ve9ISP0daIVIzDgBk3+MwDt3BZhF6Knb2TvsD0RXM9bF0vRxNTNZ672rkzZGntz1b8xekgMaAvLUzIeFbY45BQKaNTIMUAbNM/fnTMXDd8rDGkJsWPtceR196wF0Nj+zkZf67xtti38unfXUjEUOfpTsiPWJrMMtXj1767sLRdcvU61FiMuJFcB6XTID8F9GetO4XAuZZzdwkD3DD6t0TlWBJXKhjjIEAs/Dr5xiXlsbv/pVcsVqJa/LOM5I49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pk7S/ScHV2AT2dYzrlTNrkYTrifwfWjTdDPpGOZrxIw=;
 b=g9IFghda+EHs7NsZlyCdlJoGRJYzRBx665wojpT5QsWVX3NEvs3NivaQ6vwQ6sqmrg/rq4wCGvDa9kW0neDSiMQWjzFxYj8Wc4UXV+ZH0TE4YL9Uq6X3/5UVKLKQstYyegUDBSXipV9ywKBZClgFX/Kpl4OzDkXhUvgs1fYaBQrAlPYlpIQ6bUjMbw2kWryBib18yjxwUqDjrB5wPJyfUSuR8jDzNdMhqk/qshym7eBlJyQ0dDMWfZCdIRWpVD1pF47C+SCfwjgLRUh7Vxvnkiqxstq3Ywez3S2ZxwnwqTQn317t+7ri3LCRr1dIweovWi3p7EwaJC666gA8qJZa5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pk7S/ScHV2AT2dYzrlTNrkYTrifwfWjTdDPpGOZrxIw=;
 b=hTO6Q2hPuBcnU4KYV9dStZX24YuxTL6oRl52X/SEML1CfgaFbmG3Z7MuSQIfjVVKQo1BdcmQJFHSeeueFdEhlNlLB+I/kIY0d4InZYXpYOsE7O+PNhJ/Oa4wU9D/GBfsNDkWuB1IrkP7u8aHy9eplCvIaS7tWlyKlEt5vQBhlIg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:36 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 4/6] numa: Introduce and use ram_block_notify_remap()
Date: Sat,  1 Feb 2025 09:57:24 +0000
Message-ID: <20250201095726.3768796-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b309e2-9b31-4a17-09f4-08dd42a6db2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vl66heHXIuaBP6dmMTJceTl7AVjS+FOhkAMPIv3vfcXw0fO9h3xpI4HSDM07?=
 =?us-ascii?Q?B0lts4UfakUSIZtICjvgbCTX3BPeuUfD3ZgF1GOHyFJkirOcdsCX1usI6fCa?=
 =?us-ascii?Q?LatDKUD2NKH1CG5zGpqpfjfuIAAYcNT6n9WLmNjf53LbQAngwXSg6JuoIv+/?=
 =?us-ascii?Q?5M7kUW1WUAoNCwFaxidwXneRW0KjoMr+JhEIL1Jx1XklB0xk+069C2SWrf6o?=
 =?us-ascii?Q?9Pg22eqbHBdq2YVoDadRROUwlY3dYMkEi3XdaFwUGl4FlWiWsxYnK+wrpo1b?=
 =?us-ascii?Q?d+bSgnvgGLetlVqmQhOT89UmAR9ctoZQVArgHNoLYNAmzp9lu7mu+AVG+/B9?=
 =?us-ascii?Q?iJDD8v2iB+0o2MCU+NzO64StgnmOTqO9eUDtLIfmI8U2ggWN7f4+MZY7Gwd8?=
 =?us-ascii?Q?qjVd/35Q8mN47feYxI4jE2F1hHRTchzjfLYR8xhOib02ubclmaYsAgbow3qq?=
 =?us-ascii?Q?5z6zgEDMhnHQw9CMc5NEdqB3XuVU+iyIMlJpC+1EBkb/J8ifSAYqdeNQ4Edy?=
 =?us-ascii?Q?+oucHOsM1YtaFgCaQ/dGDc1JlvEO765JRJyHByo89MFFA27qkkulDWqgxwU0?=
 =?us-ascii?Q?aMGIG5i+Bc1suhxIgTOupBa598NGZi2kIz3nZkVCE+Ewlrjf5yuzNcmmNMxy?=
 =?us-ascii?Q?uZMk/W6nViYNUTn2bmraG/n12d4BbX/2uyLiXFIdzp6wM8b4xhAh4hFA39kJ?=
 =?us-ascii?Q?IERQ1UdBL6mZ6meZpDFE9mpyEyzSCsxPFYKOmSvKeW8QpJJhIhGlUYaVtDD6?=
 =?us-ascii?Q?BT1e+9w9zP2Gx9d+6FdvWRs1adP/EWcVKHwkGuAWmurcuEWmOV7OpQj76KJH?=
 =?us-ascii?Q?A4MRJ93kby/+ZD7raGz/ajE501Mpkxr21P3wLJCCbYcbF2+ymqx1W/uG4aVQ?=
 =?us-ascii?Q?n/emuFPI5757J80eKa+/y5+P/0UbPTPx7UhPeIL28zOVDdWuO4GCS0Ftl0mE?=
 =?us-ascii?Q?Q5YRV0Z+U/ppDKK6CTwvXq2ruNDIZt+B4OQO6p2R4sX9owNNnr4onjfin3+w?=
 =?us-ascii?Q?3B0fhxh+QhTULgq4dM59iG9p7LklIvhb6BPgDl8k2v+P7/jUom0LLXPbZ4JV?=
 =?us-ascii?Q?1zl0YTHVy73J+FfM7iBtrw+6CvvDl+zkyRYyyoeTBDRbiHSs1d9bKon0rlHt?=
 =?us-ascii?Q?CjM3+L3/iftEQ4dFB2SMsGzfrCMZDoj2a88mwzeb6W+X79cTYqIMflQjjYv0?=
 =?us-ascii?Q?Hec53cJijuExHpWvaPwOJRsaPN94QKAO0mMCg1Lu9weHaDlYg9DyZ2i+9KaA?=
 =?us-ascii?Q?SA3nWItKNaZXb1/POrrsCxoyiyxTckSR+E7SP+Ww/+ILRMbL50ByDtCSzHf0?=
 =?us-ascii?Q?0pZuRGNL5lydspOxPdcnH6VXAR5/wsL5YQ5zESWOB1uwME5yMqynxUcYtpRa?=
 =?us-ascii?Q?yPdQxeRhWuocbWxM0BtjFsrsXM4P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RKL64lHm2jMG+o4EutE6jTrCZU59HVlbZFtAtNodQO1wcwvodo94uWnFV4IU?=
 =?us-ascii?Q?rHRJIN/NKLE4UV0kdpp2S0k3KisyYVE6NxmaxahBS1yBcxidr2F6A9Cwzo1T?=
 =?us-ascii?Q?F1zYoNGcuZL0OIdAYB24RPa0r0b39JrNA+SPsb7BADd1h5HQFVUBRFYAwreF?=
 =?us-ascii?Q?XDjzsCsGsLcYJZFiMRmgr6QYVJMo4oHAJr7NSZs/cTK+ZmBePxkKFG13JWDD?=
 =?us-ascii?Q?8lJyVzOUeaG3RlXq/eMatUrK4A7shSHF7y17r35SZOfbwdIf0ryp/8xRfmZ0?=
 =?us-ascii?Q?JEDQjga7gIgQEpIdNbt9yLGKlY7AOD9aZYqGHJ/p3B+B4/Si6/tpEIQWHkzj?=
 =?us-ascii?Q?WGykaKDDaOAXpgYZEZJgAtOKUisM+7jQejF8rMgVtEYRwQHNS3w+78vCBjbZ?=
 =?us-ascii?Q?dfcVm+kplm6pgIUQoqHFyZ48K/kRrt9iFAz/iNNS8JrtJdJfa18/mzMpqTZQ?=
 =?us-ascii?Q?ZVrpJLorRvTCT0dYSXQCoTM0cYLv5ud8+LRfjWhNsf8IhOglvEhpoRswoScE?=
 =?us-ascii?Q?Xj1wG43c8twnRagjgMX8rymWw3S5NaGPV9IZyPHw2/P3iEI6hq4Hl8nqmxZd?=
 =?us-ascii?Q?wUYFCUkYrNEOBTRAWUfoLyQNx5BSPUFwijN0NwIGbdQFmc++Z/adMV+0l5zX?=
 =?us-ascii?Q?UHpIxej1vw0hBZ3ZWE2MYQH7U5YEzhQxQ3MShgl3WvQdz+Y9qu49b3toeqEU?=
 =?us-ascii?Q?6hEeR0punlKWWusAOkSAX4GyCTNh+z/nHb+z/gsMPUjtZyKU6xSLbK4S58+3?=
 =?us-ascii?Q?dofOVLrgZjWeDjqXjQXv3Cfcs9rDQB5SqQw6ei+N5UC88cU5jc2veYpwjgXb?=
 =?us-ascii?Q?k3yXKldRJ4QKJeIOuSxt3IKo5YLqnP0BHAS+nCQ3zG7MDFlGQfufU144Ym1p?=
 =?us-ascii?Q?y2ZJ+KYo/t+bUWCgTLl4/Ct+G7fqs1PctC3IdmnLtmMr1OiGbakBE6hzHkYM?=
 =?us-ascii?Q?A/SWhMsAfFkCW5+rQ43p1mypYgC54qAQtcm17paWHAlBBtbcak4cbR+AebVO?=
 =?us-ascii?Q?3z6ixotaxMlrJeFxd0du3+GxDvYr2RaNX6WJL4n9O93GRzwf0+WN3SX2gn+2?=
 =?us-ascii?Q?UghT0O5tzqtNcxjc779rM0PklinRYRkD833fwOQtePCzZibezfaGRSWSoIID?=
 =?us-ascii?Q?UgD/z/7vutAv612xeprcBF1jxA74wI+h61FEvQHqLEed3LqDCpfin5OQyunM?=
 =?us-ascii?Q?RSzd4A+636jRLGfbGtzqnpOCUe6sGmNq5VD4k3Mdk+IUPPxLhnEle9vrctzD?=
 =?us-ascii?Q?s8Gz4Uit1Z6nq6mtKZlFL0PofjEhVbv7M8guadBq7m0UtDMHctFpg3Zz68hv?=
 =?us-ascii?Q?gxIKaMzUxDAptM4SpTt6tYMX6sCoQLOL31/6r571oaMIOWQn67zTVPgkvN/B?=
 =?us-ascii?Q?Fohk2J5x9zW44nFd++vtRoigzP08rWtc1mGWU/xeAi2gfoLMPD9oiL2xj0dn?=
 =?us-ascii?Q?y10v4PpSQDArLtiFSdiEBJwMuX957YPujj8VFUT/Jpr0+z1UdPUDd9IOa7RB?=
 =?us-ascii?Q?GruV89sVlW1btrCLw0e1JBtgh6+isI8a+chd8+dn9OGM9UKuApZQdG1TWvW7?=
 =?us-ascii?Q?okMk2yePNmH1ceY/Kz+aOiKsZag9KrnYAJdR8sdFxv6DaD1/zg4YAdtmjluA?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sw46fpPt9T1cV5LnghT4OvivnLqaT248Jt24hFB5IiW33fHRzXHHoyIwLXyklr8L15NS00kYvhUSVLmd1kKJAzd9b++jpvSInPecYivcQYpesZZj/UXR8NIHD35uXxHU4V5mIg+u9omEtXBOD1n8DYCejbfuSBQfYbFrhpUW5Y2d6iA48CL2RFWGdY5qQP0bAqo29WPpKHWb0GBZMnffV1o/+Iia174SKotTE/uO0xUKDYg4lNd0DV7OZaIEIKzLsC/dcVGQZ2iie5bz+AormYNpWyjbHc3KaetloDAP1/YqZl/JYrXmNcope8P+ga/q9/5bgc0AlS2k5ATQDh9iQF93a/I0eFj31bhNaFiK/ojyw5Ng31UxHG6hwZ1Xhd47h7Zn8L31esv5DS2SYh9BcpYg+20dE6ZoqjNWOGhpHD3yG0Qn7EdWvBvL5v/ByZpCy36AMdkMDg2cWBOLexBpvn2bT7lBS7QJ6xXL0WqYNnnl8o3R9fPXn+zQqkJeCbeqFY0NFN7R6p9/TyUhmVTMojXjNlV8cHLL1aIGjsDZNZ7AC4xutLLcFfb2fdmhI5GXY20SGsix4nFhGQoxiSmuowxgsZDTLoLOO9Ry04V+Bq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b309e2-9b31-4a17-09f4-08dd42a6db2f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:36.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9R2162I92m9uwu6BPM0ZVgYxksTgVMWw7q9rkiqMrRt62o7H0nWrIc8tAV2OhQ9uU0mj7Pc6VMYmKeJEbzmLJe8/tcz6nxrem/4qj/XCM2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502010085
X-Proofpoint-GUID: 7NhOsCMUCihelqK-xg0J1ZmkvMMkjnNh
X-Proofpoint-ORIG-GUID: 7NhOsCMUCihelqK-xg0J1ZmkvMMkjnNh

From: David Hildenbrand <david@redhat.com>

Notify registered listeners about the remap at the end of
qemu_ram_remap() so e.g., a memory backend can re-apply its
settings correctly.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 hw/core/numa.c         | 11 +++++++++++
 include/exec/ramlist.h |  3 +++
 system/physmem.c       |  1 +
 3 files changed, 15 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 218576f745..003bcd8a66 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -895,3 +895,14 @@ void ram_block_notify_resize(void *host, size_t old_size, size_t new_size)
         }
     }
 }
+
+void ram_block_notify_remap(void *host, size_t offset, size_t size)
+{
+    RAMBlockNotifier *notifier;
+
+    QLIST_FOREACH(notifier, &ram_list.ramblock_notifiers, next) {
+        if (notifier->ram_block_remapped) {
+            notifier->ram_block_remapped(notifier, host, offset, size);
+        }
+    }
+}
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index d9cfe530be..c1dc785a57 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -72,6 +72,8 @@ struct RAMBlockNotifier {
                               size_t max_size);
     void (*ram_block_resized)(RAMBlockNotifier *n, void *host, size_t old_size,
                               size_t new_size);
+    void (*ram_block_remapped)(RAMBlockNotifier *n, void *host, size_t offset,
+                               size_t size);
     QLIST_ENTRY(RAMBlockNotifier) next;
 };
 
@@ -80,6 +82,7 @@ void ram_block_notifier_remove(RAMBlockNotifier *n);
 void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
+void ram_block_notify_remap(void *host, size_t offset, size_t size);
 
 GString *ram_block_format(void);
 
diff --git a/system/physmem.c b/system/physmem.c
index 686f569270..561b2c38c0 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2259,6 +2259,7 @@ void qemu_ram_remap(ram_addr_t addr)
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
+                ram_block_notify_remap(block->host, offset, page_size);
             }
 
             break;
-- 
2.43.5


