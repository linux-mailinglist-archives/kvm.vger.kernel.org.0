Return-Path: <kvm+bounces-26300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160BD973D2B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57DF7B24EBB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE5519E81F;
	Tue, 10 Sep 2024 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZAZNmPoO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bjGHx0BM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE412199FAC
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985470; cv=fail; b=ZdHBERVaujgKgAhptnVwIiZ+AFd48ZGVGfcrP8jQditM77qySUk6F9/NjH5j0AZNrDwjp1fR2FLL13ETN0ZiyLy15JjZ0ARDIAcBJV8agVuUdUzsYjyX3bVzFDZQi03zinQOKhi2CYQFmesBgYF60ds6Q4m1Jvm6Ef/r7Xg8iDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985470; c=relaxed/simple;
	bh=Dh0iYj8BmdRBjAZiFn8hnZeJVfoi5dqmru2WO0eOYbw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZOoRDKbTKMBBa1+v+yXiZZ4yo8jx7dSnrqn9dFiTX0QgnyayYQUI97Abdh2MdOggXk+XY05cW/nhIMYFs75Q7sZTqJDzrv4wB0hEfHe5XEBSCbvudD2IbqIQKUrDr3WLv5S8xZKfL3M7Qc7vRoMSOzonmJG/17oRP+r6/047AeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZAZNmPoO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bjGHx0BM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFtZnj026319;
	Tue, 10 Sep 2024 16:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Gn2sfr+hcvoIKUi6BEs4p6V63gpmhJMcRZiLLQ4J2AE=; b=
	ZAZNmPoOvutKyuA3CcpJV1OzmuHwsUW5gU3gOkllbNFm0ZhIljz4Za/9YaX1xy6n
	hzim+jImS2S7cBJNacZTKY7lRmSHkePP+ud9gkkwA4i5cApxvuiD7A5ygZCXVnPy
	G8Bw5pAyQXgSHL9vf7jMJENMKVMOsCIbqI3ub9npK0tbromwpl8JaOWysbg58dmS
	1eeHtv+hWUg6I8WUSyQZGP/wA4iysLwysA6ojVdDv7u0NzqCJ5Gr0QdED+2dyZde
	EPuMVDzPXMQcl5E+19dnPR+W3FBwIXVxNH53r7hlBAwIjnfa9QU36rS9MJm4xYqe
	x/MEMWQxtPso2I8NXmAkUw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrb6484-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 16:24:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AG9d97040909;
	Tue, 10 Sep 2024 16:24:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9a8tk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 16:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbzs17ypqRB9jh8AZ9K/21pDDqxb7x6f0GYXnhS3/yDB2JlSHCFrXQ3AARs8OC85mjfc4aB9UZQ11ivO+wRrDk6nfDs8/hBlOnm0Ne5Gti5bPs+jFzdyaUpl9UvpIp32groXKddx5zDsgjY0cnNfhsTfOXJqzUkMaCQYydmJSr+TrAtZrMQD0HDz9OcpSIcpwYQNAXbTfm0RboYCIzhIs27pvu8tLgt64eeSGsdwc/L1Caj7GFM0Wdv7HGbe753XGg7MF9nLuyDmM1xSSSiPskfbPoP40f0QuXcsbXSjnGFXv+ZeQr2QyBI0MQTH5z70Uwolqoxb1YD3D8Vn2aNHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gn2sfr+hcvoIKUi6BEs4p6V63gpmhJMcRZiLLQ4J2AE=;
 b=T6ZxH9FM3eDlGTQgc2Jz25HsrNZwb0IM+cZRG2gg7SPY9Ly3r7mdZK0orIZdmboQL8hb+xxN/JTU2mkMcaddUF4vzwp+/+U+cAGeEjwUtlhVVd2SZSpvZfqb1wshrN6sLzqeE/z2nd6fDQ6lUbEV4m+3GgbubWH1VH18AmgL5lC7i5Vq7wNbCtRXwflhUebs4eKtVc12ecARZErtu2qf09iR/Ag96frdWi0bSlO7wd65rktJodzXekAFd1QKFVn5osc1ia9TJ6HZ8TrQk4Kozac2YHNTU18ZIlfDbLkK2OOk16572T9sIvpqsNBNyomyhWW5HoDynfgU1Q+5JtHDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gn2sfr+hcvoIKUi6BEs4p6V63gpmhJMcRZiLLQ4J2AE=;
 b=bjGHx0BM7dk/71UPdXHz4xCrtxtEcMFOsDtb/99o1063bpRPkBCC+KgOHuU1yrB589sXhxzzu03sKYcyA2foy3nn2idOYhOuT9aYF7fpmp0CNLPBBwCaOziNOg/13X6gIDtWv9a8DDZ3EiR6GCH5AeSrj6U54FEXMmn/338wlg8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ2PR10MB7016.namprd10.prod.outlook.com (2603:10b6:a03:4cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.13; Tue, 10 Sep
 2024 16:24:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 16:24:15 +0000
Message-ID: <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
Date: Tue, 10 Sep 2024 18:24:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
To: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com,
        peterx@redhat.com, philmd@linaro.org, marcandre.lureau@redhat.com,
        berrange@redhat.com, thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, joao.m.martins@oracle.com
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
 <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0234.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ2PR10MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: e02d1553-8c8c-4cf3-6afd-08dcd1b5033a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bldMYXFFVHZqT1BzNHNHM2UyNHYzdTVtdk5YeDc1c05tMkplMlQ3RkRrQUp5?=
 =?utf-8?B?VG55L053NjFzSFdFWUF6NElkd2VEbE5pQ3Y1WmIxVUgxYVIzUzZ5VTBVK0xx?=
 =?utf-8?B?Mmg3UnIzM3ZBNG9hc1NZbmdIUkpKVDJXM3BiYnhBdUc1SXgyRkJMS0lkTmsv?=
 =?utf-8?B?dElhYUFza2dISkFFTTdTS2h4Vi9OMTZIMTZCYU44N0tKUXRPWDF5bWRGbEho?=
 =?utf-8?B?a29SNnJycmxNeGsycE9QZUw1WHZ0QTBJTVFyTmU3SnFFcXlVQ0QrMTU4dGdF?=
 =?utf-8?B?SVFUZVQ1d0RoWGRMdVBlY2l6c1RHbFltSW9IWjNodWhuRFBqZkxIbTMreFdm?=
 =?utf-8?B?VU40bjhGeDBCckRlQitaNHdBbExVbGcyd2I5UkN4K1lCb045NHJyY1gvWkw3?=
 =?utf-8?B?QTZBNkZFWWN2ZlNlNmtLdXlUM3FlcDNpOGJpQ2dBc3JWTUdxYkRmMHNMeW1n?=
 =?utf-8?B?Zm1EcFZXaGl2Rk1YWXovbmQrRzlNYXNzK2M0RDhFMmlOMDlDZlh2T1RMZ1RJ?=
 =?utf-8?B?ZGlJaFNvRHNCUmJJd3NZUCtvQnd1V0o4RTJsenpHWm5XWCtDZVoxK3J2eU5L?=
 =?utf-8?B?ZWg4a0dOYjFKWkxTRDBzbWFVSjVkSTkycjZZL3ZvWldVYytnaXlBS0xadGxB?=
 =?utf-8?B?OFFwY2kwRGc0TkJjK2R3VzFoQlZWUUY4ODFpTEQzNThrYUlBaUVERzNKUVM0?=
 =?utf-8?B?Tnd0S241NUJoTEdpMVlvUDdvNG5ML1ViN1c2UG9pRExqaGkxNTZQUktrc052?=
 =?utf-8?B?VW9RcEkzS3c4SVBQR2ZkeGFhRTlMamlJK3pHZ1BOSElLWnpXRmpJUEtjTUhR?=
 =?utf-8?B?M1ZIWCtaUVJIUXhPZDhWamtlT2ZaUmRtK0xxQ1JyWnFEejNnTGJaYXd0OEJT?=
 =?utf-8?B?enVSZnV6U3hJeUhBUHJ4QmR3SmZvVEtHU09JeG1JekI0VGFwZzhWeGQ2Z1Bi?=
 =?utf-8?B?azhyKzhrVndhSHFLZmdzd2lqVVhYalcvZ1UzRjdxMDJmY2h0WmdVSjg2SzFm?=
 =?utf-8?B?NFhsdHFhZFFQd2c0S2FEQ1pwS1Bza0FlTW9SS0M3Z2VZMm1LUkliSkUxTXBX?=
 =?utf-8?B?Y2Q2WVBGL25TSlZpRGlQVThtYVpSbFdSbnlianp0bHErOHRRa1R0VGZkb2Ji?=
 =?utf-8?B?WFMwNDdsR09ONFN1RGFneGtiY1hkY0l0OGc3bDdreEFLcDBFb3VqR3pBMlE3?=
 =?utf-8?B?bnZ0V1RyNFJySXFtbHU1dThralUxbStmbXJ0Ykl2Q0xOY1dzUUtSUjE2amha?=
 =?utf-8?B?R3BzZHhyUFZBbXNOSmhSWTRFYXEyenZDekRocTlZV2R2NHpaRnFWTWdTbVZV?=
 =?utf-8?B?VnNJTldRL0ZiTnYxQU1GMysxUG9KVXFRQXZ4QWZkYXQzZXd0MWdSc0xZSm9N?=
 =?utf-8?B?Nmh3TlJTbStTZHgzWmNoRTFsNzZOMzdqVEV1bDk2SGdCWlJGb3ZsZ3FQeFoy?=
 =?utf-8?B?OXl5dlp0U3JuZWszL3UxQUYvNmhZRS9IelFzdWxldG1oNXdQdERsR0VQT254?=
 =?utf-8?B?UHBKQi82N3VZRGp6OU1aZzlYVEdwa1AweFhGcXdLU3ZXVXc1MGtXMjR0MHJj?=
 =?utf-8?B?Y283akgreGFkd2VxMEt2Z096dnNUcGR1ODJob1h0UnVGTmJCc3JRaThqWi83?=
 =?utf-8?B?bUtoRUNVSWJuZ0VEVVh5R0wvTmsxZ29PWmhpZVQrOG42bTBPWHlxWTRTaUg3?=
 =?utf-8?B?S2dTVm9walpOQnBudURXemRXRjhzSktXa3ZPSkdvNHgxN2dqU2F6M0Fya3dw?=
 =?utf-8?B?UGlBUWNSM1JqTUNyRFpTZGtibkV5MWlvTVhRNXc5Vm1pWVg5d200LzhBTGlH?=
 =?utf-8?B?WEJJa1UxdG9pZTRMbEdlcjlveDNwOFVnRWNSeStKaDVnWndONyttSjlSQ1NX?=
 =?utf-8?Q?KdySxdSbll3Sa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjR5VzgwUVNjUGhVcTZ3dHZQdVlrYkRJcjFqNHFRRitFYlFFZnRRYkNHOTlP?=
 =?utf-8?B?Sk9VMEJwU29zekEwWjNBS09vbTluaUxoUmtjc3p4NlMwYW1HVkxlWHRheXZk?=
 =?utf-8?B?SUczZXR1aGhYTm52YlJFSEpKSHYzYXdweDZsZnJnZHdSZTdHTlk4a0c0WlVx?=
 =?utf-8?B?T29GbENhNHJZNlAycERXNWl0YktXd0d6TFE3emRYeHNJQjc1VHhWUU9JM1Uy?=
 =?utf-8?B?Z3BxTStPT1ZzQ3FzQ0JaKzFrSHZ6cDdkVGtwSElqTEhESTNjY3FDR3ltKzE0?=
 =?utf-8?B?akhQc3NtUXRuTUdKSFVSeDRwL1U2MWRyNFd4UDkxaHBpRVM4YzhIdWhTNTkw?=
 =?utf-8?B?eHlVN0FUQ05Bd3pCcDhsWXNzSkFQOXhHL2w5WGNvTkdwRzlYL3FpSXlYWmtm?=
 =?utf-8?B?QmFYN1BlN2FncENwOEw2LzVSVGJTZzA0OEROUW51YnpmandDUEd5cDRZNmpt?=
 =?utf-8?B?UlhhbnVUZDlzOHU5ckVtRWRNUy9hU0VKOTAzekVtdFRBZmFVaWJuMEgzZUFQ?=
 =?utf-8?B?MUs0KzRBTDRhVDltK2FNdVdqUGswQjlqS3pVc1Y4TDZwNGtvOFA1eHJVUGNO?=
 =?utf-8?B?UE1NUlNqMTJpRWc4ZUZPeTd5VHV3Mkl6aWt2WHd2V0RXVDArNS8wT2trU09E?=
 =?utf-8?B?eUFyWUdOVkpZbHBYRWtOMmhqZWFCbkxJZmxKanc2QnNvanoyb2J5VU51L2FY?=
 =?utf-8?B?MkdUeUJXUkw3QlQxNFVwRm9CbXlLaVNiU1pGVTJBRlBNRzZYQlgzRGQ2L05w?=
 =?utf-8?B?UlduZVRlejFyU2FiOEVYZ0ZuYTRQb1Bvc3AzRWpJWUFFUktUU0tPVy9aVTR1?=
 =?utf-8?B?cjE3bTFJOWk0NDY5M1c5M0tOeXdzcXlzTWtrR0hkbVFhTVczRUVrRkkwSENW?=
 =?utf-8?B?WnpvU2hsQUQ0UkpUQWpkUGQ5WjVOb3VjNGRycjhsek5mWjB3WUhmb0Z1a09i?=
 =?utf-8?B?UFlGL2FMY1ZFUXZrbEFkQ3FSdFdNWXBLY250b0lESFVvWnFpMVBlQXd1a01p?=
 =?utf-8?B?aWxSYXovSXI2bnBQenpPUXNzbGNNWVV2Q24zc0lyMXc5WWp2dXJpVUVDcExG?=
 =?utf-8?B?U01zeUo0U1lObVRyWlFkdzNUakpCZ2JCUXpWQ1kwVzhJOVJMME4rb0gxVitz?=
 =?utf-8?B?U3hEV3ZOU2J0am5xQ2RLSkNiQ2o2L0Z5MnFKZ3o2a1U0YmcvbkpSd3ZVZEpQ?=
 =?utf-8?B?NEVxZmJKb0NNWnZkQU81YkovOTFMQXd2cmxXY3FGeExCUGExaXFkTGcxZGs3?=
 =?utf-8?B?YVRnWTRia1p5aDBoSE1FWW1rdXZFUXQvRzVObC9UNzBlWTFUdEp6dGNVVm53?=
 =?utf-8?B?a0NQSEJsNnVINWhaZ0wyeCtncGVjR1UzVDlDa1B4S1hDZDk2TmJ2MzVrc0Nl?=
 =?utf-8?B?SDdMOVk3MTdIM003RmJVUThnRVNSNWNvN0ptRS9wUllYUGhHdFFNZk5MYUEy?=
 =?utf-8?B?OFZwSFhjLzZOdEVueVF6YUpxdG1qSXV6REFGenpxR1gwazg1UHhkRlZkY2pM?=
 =?utf-8?B?UDNPWUpDelM4b3JFQkRvVUNXdjY1bW5xKzJpQVQ5aDN6UXBYWDlXMlpkYW9o?=
 =?utf-8?B?TDZwRDBkbjQ2enRQcDB2Z2llTTdJTEV4ZlMyZTU4V09OWEdjUG1VV1R3K0RU?=
 =?utf-8?B?aUU4YVlFSVVyQ0VTczBRUERoeXVxUTd2M05WQjBBb29hU0M1NzF0aldTS3Ft?=
 =?utf-8?B?NGxzV1V2WXR5RWZUbEtBc29yZUYwcStSREhnNlorcy9xQjh0VjVCMlh1MDFE?=
 =?utf-8?B?TkE4eHVXLzI4Sk1YeTc1eVJuMU80NjBmcGJESEVhZG9JdjZBSmYxODZWN1Js?=
 =?utf-8?B?YU8zQXNjekF5d2RpNFBBSnoxamU2RGZmVU9OdllEbTJZR3N1STIxaHRtQ1ly?=
 =?utf-8?B?UHBZVG5HTGFnWXZUS1lTdzRhQVE1V25XRkJNck1CVGpTQ2lvMThkSXp1V2RU?=
 =?utf-8?B?SlZaRWFXV0NGdUh6Sk5zK29tSE5KTnpwQlM1SFpwVXpMVzA0Qjc3emR1WC8y?=
 =?utf-8?B?SmVMUmpZU2JVU3JTL1ZKeHMvdXFySzMzSDE1MmlwMWlUbmJheGFzWDRhN1BJ?=
 =?utf-8?B?c0dubzFHckJQR0tKMFg0QWt6b1NEalEwMW9FL1A3YW9BWE9qNGdsTGFpSThl?=
 =?utf-8?B?c2R4dUtwWVFDOUVRZ3Zzb05IQTdBUmk4bXg4S0NhMm5JZlQ0VDR5bVE1QXVO?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q2b3yWE+vk9Qhr9XeOUIehHF+pFkd0mMDEYIXCLPVQlWgYa1YRFDs/CXbkhZfGofQSfYpXeDU8MjtqOb2f4W0oa4EcRK1pUW6DEJo6ezw110lQDBtlft8jIpKfpCV5PsxRIFF22VSNjZ4sNL05dhpfWc0a1sQWiklGycIlYB/iJ/DyNGpNBW5Df8ltzKqvgGfLhvuCDC9ZkYwsW/GGFK3QoVW60kdaBzsiWQ2V7SuXsgiFEf+eQgUZDk1TOIItaLrOnTxVV4JBAlXqdQo3yq6jZ4+y1+RtUKDEbj93fsrJVmONekw7Ene4Ka5D3K0rq9+omq4e/+GC/sl4Hu3lYsZAhPkrADiDMtnvrXTomiZjhO6857EgP+tusuJMD8hU3OimNvR1yOpCpQxywu/zMbluACeh2EnqBLN9whBzg2k2eAyTkF9rotOOPcGcKDl8srzgCqpzUkG0jlj/rSE5d4X0T+NUSz4haNDiCckp+VCntPfbl/ObL2SO+kv/4nZ/qjEqArQfzOT7Q0/d9uHihhGJBNalFDHeFDWaNXBt7/l4Q/lthfBUK/3D2xgBxllL1q0ONIJx6fgIJpdT5j79hgGmWgPSWcdQJF33Gv5Glvdxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02d1553-8c8c-4cf3-6afd-08dcd1b5033a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 16:24:15.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6187U9wRRkxdKPrOC3U2vcXCDb4kk/RWchaRTiFb9Z0oIedkcUHF6VLlITJBx+w/dnSEFWdGddX7+ZG4PUMY+/nRoCaFeZ4nyxYgddu3XH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_04,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100121
X-Proofpoint-ORIG-GUID: kNN9ZdSoLCNhWhx8P19BVlZ_snCXuTKp
X-Proofpoint-GUID: kNN9ZdSoLCNhWhx8P19BVlZ_snCXuTKp

On 9/10/24 13:36, David Hildenbrand wrote:

> On 10.09.24 12:02, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>
> Hi,
>
>>
>> Apologies for the noise; resending as I missed CC'ing the maintainers 
>> of the
>> changed files
>>
>>
>> Hello,
>>
>> This is a Qemu RFC to introduce the possibility to deal with hardware
>> memory errors impacting hugetlbfs memory backed VMs. When using
>> hugetlbfs large pages, any large page location being impacted by an
>> HW memory error results in poisoning the entire page, suddenly making
>> a large chunk of the VM memory unusable.
>>
>> The implemented proposal is simply a memory mapping change when an HW 
>> error
>> is reported to Qemu, to transform a hugetlbfs large page into a set of
>> standard sized pages. The failed large page is unmapped and a set of
>> standard sized pages are mapped in place.
>> This mechanism is triggered when a SIGBUS/MCE_MCEERR_Ax signal is 
>> received
>> by qemu and the reported location corresponds to a large page.
>>
>> This gives the possibility to:
>> - Take advantage of newer hypervisor kernel providing a way to retrieve
>> still valid data on the impacted hugetlbfs poisoned large page.
>> If the backend file is MAP_SHARED, we can copy the valid data into the


Thank you David for this first reaction on this proposal.


> How are you dealing with other consumers of the shared memory,
> such as vhost-user processes,


In the current proposal, I don't deal with this aspect.
In fact, any other process sharing the changed memory will
continue to map the poisoned large page. So any access to
this page will generate a SIGBUS to this other process.

In this situation vhost-user processes should continue to receive
SIGBUS signals (and probably continue to die because of that).

So I do see a real problem if 2 qemu processes are sharing the
same hugetlbfs segment -- in this case, error recovery should not
occur on this piece of the memory. Maybe dealing with this situation
with "ivshmem" options is doable (marking the shared segment
"not eligible" to hugetlbfs recovery, just like not "share=on"
hugetlbfs entries are not eligible)
-- I need to think about this specific case.

Please let me know if there is a better way to deal with this
shared memory aspect and have a better system reaction.


> vm migration whereby RAM is migrated using file content,


Migration doesn't currently work with memory poisoning.
You can give a look at the already integrated following commit:

06152b89db64 migration: prevent migration when VM has poisoned memory

This proposal doesn't change anything on this side.

> vfio that might have these pages pinned?

AFAIK even pinned memory can be impacted by memory error and poisoned
by the kernel. Now as I said in the cover letter, I'd like to know if
we should take extra care for IO memory, vfio configured memory buffers...


> In general, you cannot simply replace pages by private copies
> when somebody else might be relying on these pages to go to
> actual guest RAM.

This is correct, but the current proposal is dealing with a specific
shared memory type: poisoned large pages. So any other process mapping
this type of page can't access it without generating a SIGBUS.


> It sounds very hacky and incomplete at first.

As you can see, RAS features need to be completed.
And if this proposal is incomplete, what other changes should be
done to complete it ?

I do hope we can discuss this RFC to adapt what is incorrect, or
find a better way to address this situation.

Thanks in advance for your feedback,
William.



