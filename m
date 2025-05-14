Return-Path: <kvm+bounces-46530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A5AAB732F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 19:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15099866501
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 17:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA812280CDC;
	Wed, 14 May 2025 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="YMy60hMI"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11022082.outbound.protection.outlook.com [40.93.200.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EBA1581EE;
	Wed, 14 May 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.200.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747244774; cv=fail; b=nL0RdcAdF9fC46iuJaEOKEOOfRkzAhy5rw1KbUk9mFUWBOXiaN34RGWVqLAi/v7b6rg4aiW9N4+x/UjyO5VV6XQoNd/t7LtRW6kNOu9qHa1MDcnnWnh88bsnUOAaOTwrPmrRV4Lxu4Dzvay9BnQRcidtcmVQnZifDBH2EuT9iuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747244774; c=relaxed/simple;
	bh=LZt4s7zWAMd6uuL4B3TyQeWHOgNzsKssAiryfcoOpNQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rEa3awhKHgBoao4jv/vTuMQ5SbOOh+A07chchIl0MYTllF5l8x885SvdfjTpVAQ/zSMmNDEo02CLoLZBUuvAV1sGGC0zRgWE5WarH0Jb864dRHfxM1f7GFeCDRpwo2HP8z0D8+QX9tW/NgOspJGa+yVUvTK4Bwhfpo9JKeUbvgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=YMy60hMI; arc=fail smtp.client-ip=40.93.200.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNXHytLcRu4u5x3ydDbl2KRCVWPcGlZCxgspoPi20qJhS8MP0T76clxDwPGgMNar7sZnxQvEWXuzkinpft/b4jXTyDF3i7J+9b3I+Den1PDMsdGKRhKjuhUpmS40YX378wiIz8oMNmhq8uWgEYqZVTgtVY24+KwD+fbTm0r/Iwpi8UUQ5JfajjWSzPVyc9D+kKiIKfPvmaJUkJPKtaxAgiO+gurINcxpxQNM2IXgBJlKseg+CxyM5uuuZ18W/9Y5DJGJFfkHa9LBnk1TsUgph9T6qsZo9/m5amQL4tLCCjj5905K2FDyRSxv4JkaxpV8iiunVbw01BKlW0R7xMGckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUEk2JEZtleGX1GYKvXXfKhcHj5VL4jTt+AbSXad0aY=;
 b=EpUEVV5Tt5f1E5qf73JPJWUHCrQsIz1FUGGoNtA16HYXGYXJGFjNBvLEkTKYpIBQM51d8FXVVqiobmffl1i5oWbkXprJLbWlwCWOrTma+osaYQUl3d3ck5FtKQb0S/sImv6YyGiTGmLN4gV2D78SepalMcQX2warsDsytQlAr1wZFCVowrhIrsJr5+/qo3j2zxDFj0dfc87Jvp+z+y4ylUJogw6pN421DeUe32tA+btNZCewf4IShvY375yw+RIhlBDHNJ/OIQnglzQbY/BplTWZAyWKxTs9qqMjKTpkPVz9d0TCGw9rM6wX4OMfbdYbXe6wpubeQg57rPp72XTAwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUEk2JEZtleGX1GYKvXXfKhcHj5VL4jTt+AbSXad0aY=;
 b=YMy60hMITu9VI19iSNpW9wcmy9p5RY29WodkvZs7DY2zcZw+l6o6l4i1fYpvHpbJsq55y7TnCtEcZ0RKDnh812WuxUJGHE7zi33GjZdMpUs+QBZTtKNG5pJVkH8dq1JXqUMtWpUZ+ak0qhH+nX/4mHIGJ3eFjng56th0QQOSOsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BN0PR01MB7120.prod.exchangelabs.com (2603:10b6:408:153::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Wed, 14 May 2025 17:46:08 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%6]) with mapi id 15.20.8722.031; Wed, 14 May 2025
 17:46:07 +0000
Message-ID: <ac567448-0dd1-48dd-ad54-d71215629c96@os.amperecomputing.com>
Date: Wed, 14 May 2025 10:46:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
 linux-mm@kvack.org, Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
References: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:5:334::20) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BN0PR01MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fd7b23-c824-4c90-3f0a-08dd930f34cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1R0WGhuNWE2dkhxM3g0N3A2UWlhenVaUEpjeXRnZitROTliL25GR0NEWEN1?=
 =?utf-8?B?ckFFZzZDVkh3WnVNR3IwUytwMi9uc2lOcm1oQmVkT25sSzh3azJXRzREZm1a?=
 =?utf-8?B?VWs0WmxIbWlIRkhLZTdTUEovQlNPNnRpTW5tMllvWHlUYk10MzVXcWIwbk50?=
 =?utf-8?B?TG5XblBYaUlRMkJTOUhBSEswRFN0VVExcXdHaHdRMTlYNTlJMzZlUzF5cmJ4?=
 =?utf-8?B?MTN2Y0lQQXlzZENHVTQrVzBCVWtsajdtVXh6aExEeXlGaUhpOW4zM2Z1LzlQ?=
 =?utf-8?B?QXl5bmNvUVJkZUFYRFVOU2N3akhpbkhmd2RyTUtMRWNpZHMvbWcxTWlFdWZH?=
 =?utf-8?B?WVpQWjM4RnJ1OGtmRWhlMW9QbXRORjlMdk42WC9wR285UWV6d2U1V1p3Q3F1?=
 =?utf-8?B?ZFBqNHROLzFLWGNweVJJVXozUmpHTFFJdW8wazl1U2x6Qy9UWHJkNWwvVTdu?=
 =?utf-8?B?V2hHWnd4YjFzRHpubkpoM0NXT3drR1NPNDViMjNGZlRrakp6VHdNamoxUnFi?=
 =?utf-8?B?dWZlSGozWVZLZ0hHaGdUdGI0aWNTeHdJSFZFUFVWeHVZalhmdHo5ODZNUWt4?=
 =?utf-8?B?eGFmTlA3OU5OV29hT2s5Z0dXOUl0OThBQitvWjFUU0Q0L1d3cy9SdzFidmRh?=
 =?utf-8?B?emgzTzdqQUY4OVZnMG9OVWhzb1oxdE1EU3EvdWJ6cENkNjllcmR5UDFVM1NE?=
 =?utf-8?B?eFhEWHJ4NzJMMDFzdzJXcnpiTW15eDFqZTgyZC9GeDFtckFDWDdPOWM4VGxK?=
 =?utf-8?B?Ym9OTnFLR3g1UllxZFBhaHYzUU81bVRIUzBWRUZqTVNoNW1LTTlGQ3RzbGxU?=
 =?utf-8?B?bFczdGQxSGZycnZJamIyTFJZZGdtekd2djdmQThZQkRzcExsNUMwVzhhMHJI?=
 =?utf-8?B?bFV0dEtvU1plYXBFVVJ6NTE4TkloSXhjOHNzMDBaaHN5cC9SaXZKNmpIeEJG?=
 =?utf-8?B?T3crazFkR09VaWJwZ1dtbG4zR1BqQVVzMlRFSURWSWZOeGVIQjIxYVJHa2Mr?=
 =?utf-8?B?djBvYit2Y3JsTDgwNTVNSzFMaVlnZVpDeHBZVGNmdHdXOGtRMUNBbkhVNzE1?=
 =?utf-8?B?YnBzL0liKzRVMGVTZWZFamlyS0IzY2RGNU5pMHA2b3QrWnJ1UEFHS1prSnZN?=
 =?utf-8?B?Q01ucWtpMlFqV2RXVER1dHdWLytNejZldWpkVlNMbTRyaWk1elFYbUgwd0FM?=
 =?utf-8?B?cU8yU2FTU0NxOElidWZ6YzV5anB2R2NtODl5ZE1lUlZPZzBDRHVDeFhRbGdZ?=
 =?utf-8?B?Z3pEVjJTaGtUVk4xU3cyTFEya3VUZjJtL1Q5QWdoWExDNm5YUmo3ZVJCa1FZ?=
 =?utf-8?B?REtZMTM4SnFYekdjZmo3azc3dE5aVmwyWTU3UDF1ajVnMU1NekVJNEJ0TDVh?=
 =?utf-8?B?QVMzUW9YWjFFZGFFZFoyY05Jb1g1SUlGVmpiV1ZLa0l1eGtuMlpEb1V5TEJV?=
 =?utf-8?B?ZnFnZ25DWmFIeXA3c3NxaTY0ZHo0S01Ha0NzMU1xZlNiK2ZEUGluN1N6NHFT?=
 =?utf-8?B?akRla3BJWWQxai9BTTdIZEVWVG1Pem54QzF3dExkbXZhdzB1K25yT1JjaUYr?=
 =?utf-8?B?Sks0NHZjZXZmME11ckphMXdvV2ZlTGRDd3hNTmVnMnRSZmluYnNXd2pWRzBy?=
 =?utf-8?B?TUorVnA2VXU1ZG9FS204WlZOVHRDS00rcndvK3FaOWtKbmF2WGdiK0tlMFJx?=
 =?utf-8?B?cjMzVlhXSDFtRzY0ZEN1ZWg1S3hodlJqbXNyTkwwazVnNlUvVjA1bXJLU2pD?=
 =?utf-8?B?dmN6dVo2OTN0UW9LdDdLR3JwTkhiL3l2VkFnTXFrRE0xN0JGSmcrMlZnTmZM?=
 =?utf-8?Q?FIyV1/D6Qmq9A8DJGNEX2GcsiuR/Mjyl7g3dA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTdCdFg1U1lQL29nSTBPRG1PNnorWm4zVzZVUk5tRFh3ZnoybHlJZzlidWxV?=
 =?utf-8?B?U0RPQ015cHZSeU5NdEh6MmQ0QS9kZ1NQcEFVWDV4UEFLNVV5SkxEMkd6Y3lG?=
 =?utf-8?B?VmtNM2ZzbE5XSzRwNzdCdERDRzVYVnVOZFhrcTJCVEdqc2JSY3lPM2Rjbnhx?=
 =?utf-8?B?S0lTbUxJOGpzNmtnSXlPUm84YmV3MVpHdnA4NUR5dkdYQUNIcUluckNIaHls?=
 =?utf-8?B?Q2dwclRQREcrUUc3eHN1TWhHck0yUUlRb20yV08zTVljN3lOVTRUME84NytX?=
 =?utf-8?B?dGpXeUdJNVZybmtDUExlYWxXVUU4dTlUbkp6YWpTT1U2ZFRncEZ0TWVseWs5?=
 =?utf-8?B?Sk5tVS96bXN2QmVhUndtSFBSMFRENElMUFdqeVBrRk9EVHZoa2N3V1RmK3ZB?=
 =?utf-8?B?Qm1Jcjk1UFdERXJPUEtZR0x3R1IrRTlEbXdnbGc0dXhLRjltMXp5TjhaaEFt?=
 =?utf-8?B?eTA1aFBYMTFrV1oxMWgzcFY5T2RRbFdHSllFaFhyQlN6aUNRYVFJTkJJWnB4?=
 =?utf-8?B?U1ZKVkplWFBNUEgwWmpCR0xSNXlSOW9kYllnQ2ZMYlBVbmVndVd1U2FZOUJv?=
 =?utf-8?B?NnpTWGtoaWFBdjViOWdlaU5SZDFLOXFZSGI0MnVsMWVkSnN3UDZ0ODdnVUtj?=
 =?utf-8?B?cWxUVTlxeElBdjI4QlhWUGc1bURqMkdsc1RyRFBiZVVFd3ZLUU5CWkw3Kzd6?=
 =?utf-8?B?dkNBMDB6enNHNVJCTTZkNWQ5LzE4TDJpc2dsL2VDcDdCbXBBKzd6OGtCVFFR?=
 =?utf-8?B?K0FtWVN4NFdxUDBFK2QxT01CeDc5WEtWRWwyRnlyaDZwWFhRQ0VhVUloOVA3?=
 =?utf-8?B?WEc5VW14S3YxOUVjUXRDMHExaFR1a0lPM0xsanJYZ0pKTm9GZXAvdk1aMkJr?=
 =?utf-8?B?QXdXMGxodzhtVUZ5eGF5UWp3QzdId0h3aitFQlNwKy85MlE2cGR1TVFkYlNy?=
 =?utf-8?B?eXl0eG42VUtPd0tHTXRBay95K0ZCYk9XbHBpMGtWcG9Fazg0d3VuOG5tRHp3?=
 =?utf-8?B?YWwzcVpQMmR6eUxiNWpkeG8yNEpjenZtZnNCVnU5eFp2TDFKVytJeXcyNDVK?=
 =?utf-8?B?QWJtb0F4N0dVQ3JZaG5CbmZ1TGxaMEhxL1pXM0xOTkUvcE9qRzZURDVQMGsv?=
 =?utf-8?B?NXBMWW9wZGI5enBlVjd2RE16UVo2QTdaTWowN2ZEbDQvZUZqWS95aDR6RlVE?=
 =?utf-8?B?MXhyL2x1TG9EbXhxVGZHa05rVTgrVzlGUHl3WFVrbUd6QlltNWZFbG8rSXlk?=
 =?utf-8?B?cGdralZHT2VpNXZxSjVSVGtSTnBDVlgzVGMwaC9VUXVZeWw2QUR6cXBTUm1o?=
 =?utf-8?B?aytIckUvblpNSVNpd0ZyelJOSDlaUHZoNzY5VitEZmNydUxweTQvTG93Nmly?=
 =?utf-8?B?SUhJWlNVQ1I0MjVadUR2dVh0cWF4VUpyaExudWk3Zm5hQ0FrbDdqTlpIUnlR?=
 =?utf-8?B?UDdCQ2dqVHBoTVRVeUpyeGRDTlBSekxWbHZVQlZUUnJmcnd4MEZvMWhucXBO?=
 =?utf-8?B?QUNUMTljZEY2NXltazkydUl3WEd5YnBodEtIMUhualhJYUV4QXhOdWFUQ2hS?=
 =?utf-8?B?SW1yK0tNSll5VlhnTzVHK1hoOHNlYllnRTIySU9VUVo4TTZ6V3YweVY5RzlL?=
 =?utf-8?B?eFVZK1luMUttdTFBelJHVVVZSk9CYkI3cXF6cmVPMDJNNmhNc0w0WVN5SGc4?=
 =?utf-8?B?djNiQ2Y2dmdtR1hNYUlVanNWNVpjUWtVdlVCdGR6RkpUZTZWOE5TOUw5emlL?=
 =?utf-8?B?aEpKY3c3S3Jva1NpNUpWVEtQYWg4bDMxUitvOWUyV1RnblBIcy9WcW5xMkFF?=
 =?utf-8?B?TllnOFRwUjdJSkpCNnViYUV2b2hQOGpRN1dHZFlFQ1lrOWdoTjJaWGszNGov?=
 =?utf-8?B?TXlmaXZ0TjBzbXZuMEsrRVY2TzNBRExBMFhwYytickJvMEtnbGY2Q3ozUklk?=
 =?utf-8?B?QkZEVlNwbDB0WHI5cEV5Zkw2Q1crWWpibG1aMmFOWmE4RHVWaXV5RERaeU5r?=
 =?utf-8?B?Vm4xR3NMb1Z5Slo1aTFPY1RYamFSa3B3SnhMSG42djhhYTZDZG1XRUdjUDhj?=
 =?utf-8?B?OTQwY2piUThOYmluVDJjWFkrSWN5RlBPU3ZxTy9TbVZHN1pzRHNRVWlrL3c2?=
 =?utf-8?B?WU5XSUJKMHdhV1lUTjhkdjNuQ3lTb01XU1NLNXZOQWVCTFk5TE5GT0NSTjFz?=
 =?utf-8?Q?R3z+GSpXe5wPtmCDda4kUHs=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fd7b23-c824-4c90-3f0a-08dd930f34cf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 17:46:07.8269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTLzbau/egBI5aRY/hXBhTzidvkmYH6qetRAuLyxSeioHMEuyoV23zDXAEs1gu9tOH/3tJ9QcTCiNKcRzbxCrdr7kBx0S6Z7MJyhJrIQVxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB7120



On 5/14/25 9:35 AM, Lorenzo Stoakes wrote:
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
>
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
>
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
>
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> ---
>
> Andrew - sorry to be a pain - this needs to land before
> https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
>
> I can resend this as a series with it if that makes it easier for you? Let
> me know if there's anything I can do to make it easier to get the ordering right here.
>
> Thanks!
>
>   arch/s390/kvm/gaccess.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Yang Shi <yang@os.amperecomputing.com>

>
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633a..4e5654ad1604 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -318,7 +318,7 @@ enum prot_type {
>   	PROT_TYPE_DAT  = 3,
>   	PROT_TYPE_IEP  = 4,
>   	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> -	PROT_NONE,
> +	PROT_TYPE_DUMMY,
>   };
>
>   static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>   	switch (code) {
>   	case PGM_PROTECTION:
>   		switch (prot) {
> -		case PROT_NONE:
> +		case PROT_TYPE_DUMMY:
>   			/* We should never get here, acts like termination */
>   			WARN_ON_ONCE(1);
>   			break;
> @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   			gpa = kvm_s390_real_to_abs(vcpu, ga);
>   			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
>   				rc = PGM_ADDRESSING;
> -				prot = PROT_NONE;
> +				prot = PROT_TYPE_DUMMY;
>   			}
>   		}
>   		if (rc)
> @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   		if (rc == PGM_PROTECTION)
>   			prot = PROT_TYPE_KEYC;
>   		else
> -			prot = PROT_NONE;
> +			prot = PROT_TYPE_DUMMY;
>   		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>   	}
>   out_unlock:
> --
> 2.49.0


