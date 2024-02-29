Return-Path: <kvm+bounces-10556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1D886D6AA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01981F241EA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4756D53E;
	Thu, 29 Feb 2024 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZdwRSuk7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m+Xh673C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6076D53A;
	Thu, 29 Feb 2024 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244840; cv=fail; b=W8eW3tBkIAS7SDD1vuqtqFeZhLJVbznlFZZHtwhXInxpuAm3TCpOBnSpFx0urPLy9v1VoldTNKBHWhNUv7HJ02PR+CPi84UbdxZ6tbz1Hbbt0vglgY6KAa3lPmLunfZJpT03V5O6FTW4DSeGIvPMFFbTtPl8gQ84hOMnOg/RlFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244840; c=relaxed/simple;
	bh=15g/aUCB9wDBIqoQwbubKV9EECgi2Y3BHDFjSsbqfDY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LMuw1JGaBV8enE2LFbAeWP5jG9IzdTwQzh3ke0Hvjra9dm8D95USRPOQu24zMeZkNcZMimWYg7BZLNWhksiy1hh67SxfixCdOt3wqvoyfBuZHQiHvIDQkdBI0W68nH2rrg4n9g7V5opOCZSiowmP6cJo/N9Fayfam8EhUxod3YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZdwRSuk7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m+Xh673C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41TGEWkm009397;
	Thu, 29 Feb 2024 22:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=zDuhspZr5O7nJ20X0/LUorbd+BxFZwDHdxrU5t0kyBQ=;
 b=ZdwRSuk7ZZKnR8+Rtczoj0ey6gqWI+G2g7wcfebY4iO/SGMZL2VuNvzCFvzT7eoc9dnG
 dZloGlRSSqK8k0lx7JxHl/XQ5lkWP6Xoxp0Ae2C6QwAjQoTlxOzVQn0nGX6cDY2iWNrc
 bq/CtmwV3cikjJDU88gAiObk2NJVd0JDiffmasdRE5G9Z+zi6eAz9pucT+BQDEpVBBUQ
 Z8rGXd0aSDZMQegZupWUEQaEVRMndQdxeu+ZeeSu0Qd7bKALpYkfmbTNR9ljxTFCb2B7
 OWBq4O9sG5qTvB5QY8jnZ6S6cie1e+GYtp/yj9zDHAz31F9plZG7wGVPYBhCBgZQY73r pw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccq018-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 22:13:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41TKf6Kq005730;
	Thu, 29 Feb 2024 22:13:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrrb4jyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 22:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=difjPp3HFUqXtNy68z2MIbn4WcCI64A8cb0hczt0jPjzjBfXkAVh7VnC+GcgirIo69GRPEXuhcTNtSyVuaWoqSI2mCtcffWtKSwaduk+DbaoBokVQolBtnlIJxsfHU1B7SJSF6HvzHKy9K/PqII5vWLhNQOFdpH7nMzMwXiRXqOEC44Y5MGNVz1ZKlG40RvOk9MMnUuxP4QBTdYGxgaptA+4nKuh5QbVXUrbg1GBAWD+ALfKA8cj9j1dtjqGurWLY/hwXZrH5Fbk2VeNssMeLAjxJY0RhldCBid7pc+ugcxURKqcjNqkSdvLOTufb9i7sBgzEpchyJEjGzSsE808UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDuhspZr5O7nJ20X0/LUorbd+BxFZwDHdxrU5t0kyBQ=;
 b=UaWg+7u+vJcif4TkvraYyJmJRIVuQM2RNvK5R5BSarxu7TK1CUjXQxNbUZbRBXtdmEhTD3nrYt5nsgiqhun2bW1trLRvHQX9CurGa0i5q5Qonf2P9xkm8z9A6A4+MarlNPWNPvnBKy6uAOcNhRK4Prl06u01Wj478pIu2CBynr+9Y1h/iItqOPHaWhR2FhfcG3uLf4JuYLwSZgGEsHleo0gYLn8vPbpCzI2fV6K9gPSnJyrO17va3l8ItZzP9IQTh7U31cuVz9hDfMYpZ7uh9NbknZGA/Z3jZDeIAgtMVtIogtrpXwIxm98d/ikH54auVCxomABpGnelIW1AXOr6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDuhspZr5O7nJ20X0/LUorbd+BxFZwDHdxrU5t0kyBQ=;
 b=m+Xh673CnpBEGC+JWtzLTgjO0aYPwEofqs03hrJ7GI7KNVhvgjefB+rP2+OzVxI91ZWQIY0UEJ8re/fc+r2fC/i8KWZDl2dAXl3re21CGANAQyX/F3oqOK5aIa70yJwPEPnxlPcgXcRy4/bWH70qSHTlUWqoEYyU0T7VW4koYQQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ1PR10MB6003.namprd10.prod.outlook.com (2603:10b6:a03:45e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 22:13:51 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 22:13:50 +0000
Message-ID: <7fcfc226-0263-0364-bed7-fc95e6c945cb@oracle.com>
Date: Thu, 29 Feb 2024 14:13:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/1] KVM: use KVM_HVA_ERR_BAD to check bad hva
To: "Huang, Kai" <kai.huang@intel.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
References: <20240229212522.34515-1-dongli.zhang@oracle.com>
 <04398f4e-6098-4559-9604-b9810753801e@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <04398f4e-6098-4559-9604-b9810753801e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SJ1PR10MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 47d7ed05-4817-4d5f-47f2-08dc3973b573
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fbJxv6wCPhp1NHIHa7qT/dlE99vSs1KyPY/VPnYNH0PfCLm/7R0ZVwPPlF8U7ejO6mOA5YIerT1qNiHRIaeNgMdnBqXlthatAVGAZeIR/C4WhrsXKrALNYzYrp05DTtHXO0ih/8aFo2jPF+7aqzV9x8BCzjcVUfDiOoiC5dGq5ZJvns1ckyMhMxXR3XZhaIVIHZJkoEnPlDAdBr6bSyMk3vyts/vpxnSnKxfJlrWYyUPzSoHY7oaQfEsgHxKHgHHbD8yfHm9qM2H0zDMODBdASn3Xmr40Yq5YCkC/m0LOkPlAc/ryGEH/w/KIWlxyU6jlQMcASLUdTZLaKw62WTvXkFQoFR3I9PpPUAsvhIasXBCHYKhsNIPkoii78Ab6LgEeBJzBLdkWBRJWU7m+fU3YlyBOxqQahZxIewGP1b6DgYdNrXzr+5yI7xFUJJ3lWA2yVSXQV+XsUAcQx6kxkP6YwrDD9u5HCbTdgU8nleIrXmAFLKtWFmR9SlawJW9tA9MBeS3Pgsk9tIVo4DLKyG5IPi8iQcUYgs/LsGTpZhGK5fGVXD7jJ7zJ3pe9eDXMQWo/jxk16NELpIYxluSRUC9Dmou65nwH4EGLDyXAMOwmAlMV+mq2ad8mS8ddZGxPeiefzAY6eiEaXPC032073QyBQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UTMrZ2xiNjFYMG1HTWJwZjJKNFNCWjdNVXdNcUV3TWJ0ZFhZMGlDdW4xeEJ6?=
 =?utf-8?B?Q2dMK3czcHJqT3Z0Z3FUem5hTys0ZXdZL01YcmVxOEZIQlJxd01Sb3N2WUd4?=
 =?utf-8?B?aFpsWGlXME50RCszaEFlK2tyaXE1NWFDQmtyQlJjbTJRSkFLRmRSY3o4SEhG?=
 =?utf-8?B?WVNoWWx2UnpLZzFhZTNSUElhU1VOdWRKeVVzWXU2dExFeWNGUUs0bDlRQkwv?=
 =?utf-8?B?dFdXSXhLcFgrYXEyc2ZwYlVsZ3F6SHZDa3h2TVJITzdkekg4c0VNc1JtUXVi?=
 =?utf-8?B?clRyTGFEcUZQWFVSU05HQ2gvNGs5OFhrL0lFa2lKRTRReGkxVjFZbzFPdCtP?=
 =?utf-8?B?RlpWYmVLclg5MEJQV3M2Uk42eTJXRGR0dnRFcDNoU29nYS9icmtYUEIwL2Zx?=
 =?utf-8?B?TVR6a0w5cW44K1pBVnE2bFE1WFlRaVZlN1hleHV2SGdvdmdvMTM3b3BMTnlP?=
 =?utf-8?B?dVkyL1lwODFKNGZtcTJzemRPMGlHZUdBQUUrUXpXanhkR2pDdHVGTm1ncG1t?=
 =?utf-8?B?SUVjTDZ3MmJad2RsM1BhcnVRZkxVZ3JmVGZpeWxCS1kwT2lFMnA4YUdpdXRa?=
 =?utf-8?B?OWlBcmdEVG9WZ0pTZHpRWmtTSmZqdGo3ajRuZkJYSEU1aEpLRTV5eWhZczdv?=
 =?utf-8?B?QVJlYTNoTi95YVVpTENMWlE2cFQ0UlU1dC9KOWEya2VLK2wxVXp0eTlld1pp?=
 =?utf-8?B?c3V1NzYzVDBtRzBhb2kwWlZWMDJzNk0rTlBGYU9xQkhiQXBmNVB0UW4xcmVE?=
 =?utf-8?B?QmpWaFpwZXdlUFEyWDlSamFOcjZjRkNLNlJ1YVJyeVY4enBTVlNseEN0dzlF?=
 =?utf-8?B?cVhTc1F2dVVRWE44QkFpME9qZFRVNlZ2b0lEMlJiM0FWeGphbTJxNklMZDJl?=
 =?utf-8?B?d2pYQ2F2cngvdExRa0JFODJJSTRmaWUrQy9jSUJMbG5aSmtxanpVY29LTEJ0?=
 =?utf-8?B?VFVzd2doWElKOWlXUjBaZ0lrUFVYYzFQOXZyblRPNEZHdTBWNmVHRWxWUndV?=
 =?utf-8?B?ZmVzRnBucGQyK1NNQ29DSWFaZ0duSVUzc3E1SjdwaTdqNHVtcGQ3eFRGOG5z?=
 =?utf-8?B?WGl0QUQyUDFOZXhOMGtXVXZDZlNjVjlmM1NGWW1yYTF1NjdqTmUzN0NDT0hl?=
 =?utf-8?B?akJjSzJYdy9taE5jUFNMV1ptV0UrYkZEMExCQTVpRW9kQ1BzZkJqbGFqWmpp?=
 =?utf-8?B?V0hUL2dnL20zd2lnTTZhNys4WGpSbFVRdm1aZVAwY0hPdzA5Y3luMTJZYVFB?=
 =?utf-8?B?UVVBYjU5UjNxTjlrb05XQ1JSK3VXYUxlNlR6c3cwMW0vS1FjbnVSMEM0bDda?=
 =?utf-8?B?Tm9DOVYvNllRMUNvTWNnUzhYckNrSVAvU3d2N20vY01OOUNIcDVpck1jcXJH?=
 =?utf-8?B?UXAzM0pHaHhZZ3VWN2V0LzhZZmxUV2c0WTZFMStIMmZUVFpUNVNOSUJCbWFz?=
 =?utf-8?B?ZU5sOHpJQzlIWXpxREh6MjlnbTFtcUFqSmYrN0YzM1NCeU1oa2w3akNEMC9q?=
 =?utf-8?B?Z0ltSW84RVd1WmMrM0pMVnkxQ3VJVzVtK0gwUjFtUzdiM2ZXOUFENTZRS2Zj?=
 =?utf-8?B?RzZ6a29RSmU1dlpsb3RMa3hTOWx1YitjSFB6eUFvUmh5emMxblFLN2FWWGNy?=
 =?utf-8?B?U242azhSZmdqQk84WU9tdWJBcFNCK1A2eUJOZ1JJMmJVUTBtMDlRdlQ5QlYx?=
 =?utf-8?B?RXVuQzUrL1c1VllGZjlPVFcrSWhoVGpxRm9zSTdXUzNyQURwbXBlSEFFZXA5?=
 =?utf-8?B?bkV0TDdaVUFlRTg2M1RPNkM2MUJ0NnZuU2IybXFqaldhWkt4M2c0N2xETnBa?=
 =?utf-8?B?WFB6MFZNM2dEQWlERUNrdWZkc3g3aUhWZS9pUUlMeWUvNzhCTnZRU05iS2RM?=
 =?utf-8?B?VElKT21WSHl5amJtL1ppWkJ1Mk8zeHUwMTVFTjZtN29mOVZtQkxDQlNyNGRU?=
 =?utf-8?B?ZHJIYkdEUDVvdG85dTg3b0JobTczTy9GUFRHbXVDWTBGUndacHVaWGJFZWgx?=
 =?utf-8?B?NTFrejgxR1NiTmhZR2E5MGVwUmdleitFblQ4Q2llNzV2bkJ6WEFPTGNNS0lN?=
 =?utf-8?B?M001T1VUSmhUYW9sbS90WTRTWnJCV2VncldIbzVQUHk0Ty81QTBDcWI1STFs?=
 =?utf-8?B?Mmh6ZnN0RWdTUnQrZTFPK3AzUGhpNHh5cFNsK0VwVlBFeGhINzhYd1VpaCtz?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lx7k5cx2tLgjOMMyO9NGIokDZh3qdjXxjEawZm7eyQAsbK306RxNLP/ZM9bay4yrJ1Ja3GhzIM6Pg3etQkVvcz59SRH3CqzPvhh9Uc3hy/F4LpMGWxyEXoYiEA3LdKGpJLb7RfmfNdxCV8shBUbzVD/hU/jrigabf9c0XAvXkFQfmpNePTevbZ71VebJgH2HcbTpopkGdgi7MZIPXrOlsgPv40Jim3TicbgEWaTSveLFHv+Cp05NfT01FPgaUaYlNY2avxuge+E6z3LuIuQMxWLJvPnsrmIRZMXU36mntv0oGbK06ZGN8RNCK67g09/tgFGoBhGp47rXxsOJ+WjkKbetbgE7Ttd3D355yDswGFsPXv9+xoV/SCTCuTGrKDnrXWFnJSGaikBFFEJjYVt+rQXRAX1iK1pZnLX5SYhM8bSHFK6t7yznq4dhVgH54jCje16B1Wp4CKcixZHlCOKCdDE15/aQNOr+YY15LMFCAsD1yfhcQITSPVrzTkFY+gA/WnhIImmbs3n0c4VkcK+Csvx+239O1VvpGwtbX9AP+/LLrFE7VKUujGHxWW9IamgZgAeUef+SRztUMtCZcTINkluZxT0pz9EsZDWLi1omBL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d7ed05-4817-4d5f-47f2-08dc3973b573
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:13:50.8950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYanpWMMhKg9HddmtmiQ6enlb06oLB+tHzekJkYh51ecl4/jmHAkii7omX74qPzQfR1I7+aADqRLzlF610wZJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB6003
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_06,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402290174
X-Proofpoint-ORIG-GUID: pi51hwFQAYyS0Y7JP49C7QuyoyD8aXWI
X-Proofpoint-GUID: pi51hwFQAYyS0Y7JP49C7QuyoyD8aXWI



On 2/29/24 13:53, Huang, Kai wrote:
> 
> 
> On 1/03/2024 10:25 am, Dongli Zhang wrote:
>> Replace PAGE_OFFSET with KVM_HVA_ERR_BAD, to facilitate the cscope when
>> looking for where KVM_HVA_ERR_BAD is used.
>>
>> Every time I use cscope to query the functions that are impacted by the
>> return value (KVM_HVA_ERR_BAD) of __gfn_to_hva_many(), I may miss
>> kvm_is_error_hva().
> 
> I am not sure "to facilitate cscope" could be a justification to do some code
> change in the kernel.
> 
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>   include/linux/kvm_host.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 7e7fd25b09b3..4dc0300e7766 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -143,7 +143,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
>>     static inline bool kvm_is_error_hva(unsigned long addr)
>>   {
>> -    return addr >= PAGE_OFFSET;
>> +    return addr >= KVM_HVA_ERR_BAD;
>>   }
>>     #endif
> 
> 
> Also, IIUC the KVM_HVA_ERR_BAD _theoretically_ can be any random value that can
> make kvm_is_error_hva() return false, while kvm_is_error_hva() must catch all
> error HVAs.
> 
> E.g., if we ever change KVM_HVA_ERR_BAD to use any other value (although I don't
> see why this could ever happen), then using KVM_HVA_ERR_BAD in
> kvm_is_error_hva() would be broken.
> 
> In other words, it seems to me we should just use PAGE_OFFSET in
> kvm_is_error_hva().
> 


At least so far PAGE_OFFSET is the same value as KVM_HVA_ERR_BAD (except
mips/s390), as line 141. Therefore, this is "No functional change".

It indicates the userspace VMM can never have hva in the range of kernel space.

 139 #ifndef KVM_HVA_ERR_BAD
 140
 141 #define KVM_HVA_ERR_BAD         (PAGE_OFFSET)
 142 #define KVM_HVA_ERR_RO_BAD      (PAGE_OFFSET + PAGE_SIZE)
 143
 144 static inline bool kvm_is_error_hva(unsigned long addr)
 145 {
 146         return addr >= PAGE_OFFSET;
 147 }
 148
 149 #endif


Regarding to "facilitate cscope", this happened since long time ago when I read
about ept_violation/mmio path.

1. The __gfn_to_hva_many() may return KVM_HVA_ERR_BAD for mmio.
2. Then I used cscope to find the location of KVM_HVA_ERR_BAD.
3. The kvm_is_error_hva() is not in the results.
4. It took me a while to figure out that the 'KVM_HVA_ERR_BAD' is indirectly
used by kvm_is_error_hva().

This is just based on my own experience when reading mmio code path. Thank you
very much!

Dongli Zhang

