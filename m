Return-Path: <kvm+bounces-43733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B3FA95908
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA1CF3B121B
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 22:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497BF221287;
	Mon, 21 Apr 2025 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NOlKGTlG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918EB21B18C;
	Mon, 21 Apr 2025 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745273305; cv=fail; b=IAnpWo/EjZ28345fZDp7a8tAzg8Z8EuKMlfQwoXtHJtxmTYIkIPhkWlNZUwMSR/56nyOQ5+4hHPCgT8t3HMahZAyGV5WRGHMxW31woCkacQtuhz12lfXG0Iz88pkRLO1YBReEW5rmg+immd9UlqodS2xWMgXOr5p62YkXkSxmsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745273305; c=relaxed/simple;
	bh=8zO1Rf1jGhzkXTU2pMwxynC29EAS6+1Lgkuttir7zIo=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=aB/Gc+niU5LCAxe1otqC3fF7iE4hz99f78DBmSnD+6GREfeGj6x06fwL+BfbPhbgogu3a62iiD4wYE3ojNL0QRwVenw9psgab1nNlBQuIbEQwnJWMD5Y33N1AVaTKi4HHPjrjr09qUBWEUI3Hizr5AWSXfY03+rrNWoFcI2+MPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NOlKGTlG; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOZjSNFdT3eaTrhvUdH1jE6rt4p2tIrivwWSQTzSLLfG7Xq6PIZrY2VTbGlaK5ludNwL9dkofY0i/4kFKtVVmFb6HZKVQWzlC8u+BjUWfcOtNXiuWl5XAZmjBQnNobQaAkeLhS2CKGKGn78o3e7kZB+Szgyek5hEgP+j4FpHIM5hZtIEBK83/XvSKCTYBKCCM3jp06AsBGPiOxgQrSOSh2t8thhCmDLuqJVnkGMUCTVTeD1e+1o8pygw2q2yvcOYDrt73r9KZUTFCPj/1gURkYJpDtQmYy99dZxwNsxRyTugSQHSKMGz79PlbMK+1W0inUOX91cTMRceniVA35rQKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+UsIqOGhCxOyrPzuHxRR3PTfe6lDHDZ0PQJl8VGA5E=;
 b=JzWOt3N5Uz0XOnotgKt7D8QAo9TuvaCR2nYAwBmaFJ5Z7i8vz5jHocTBhBR6hixePT6esSR3QUMk0FzSRDPdVp4H7MXwB3lv6/JMbRARCjIZsuTLQhYEJhTvPT8aAcoy7O6Z2PfPLJoSIa1sfMlGPVFhg2ZxQ7/xbWIPi+Vil1+6FpHlt9oSysMdejryNO8Yd5aDIwVVzZnvuOSA3ME30B/11NTRmTO0o72LFaWjAz2/1PVeIuyv5BpBeKy6zEu1ZTOsjU2wikKtHTuB32KEL7fCWATjx77MAA8SFa/khyzFxHNR6Odju7PAEgZChfPSu6mH+h1hvxgbNdU07Vo8TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+UsIqOGhCxOyrPzuHxRR3PTfe6lDHDZ0PQJl8VGA5E=;
 b=NOlKGTlGF4+fuDrvjhspil4EE5is57v5yXhK1BSMqnqKKtnVpxoB1H16lcrq/IApIYeuiopiuUe4aIDFbjqmgevqADiy8NcF+NNYZWlJxt6S5Qdnwo+LbxsYYFldO50xsXNT5esY9X7WkWtu6StPn95B0G2912+/wWlSquDtCvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 22:08:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 22:08:19 +0000
Message-ID: <729bd284-f1df-d384-8db1-37b448b0c1da@amd.com>
Date: Mon, 21 Apr 2025 17:08:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-14-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 13/29] KVM: implement vCPU creation for extra planes
In-Reply-To: <20250401161106.790710-14-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0196.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: e84f6c85-fb45-4c7a-4612-08dd8121062f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFR5WDhhSzhOTHNBa0liWTJJNGgzMmdndVNzb0tva0JQMjUwbXc4bUZ2M0N4?=
 =?utf-8?B?Tktla1NIVHdDd0VPdGtwcG9RdEZyWFF0Zm5iRXZrQXgvZGUvQnZGdjk4cGZU?=
 =?utf-8?B?eml5dW9VZXQzVHA2Q1pUNU5qODk1SUwzYXQvN0RlbWpCVSt1VVFUT3JrRDdm?=
 =?utf-8?B?UjlJemNacDg3dVNoYzhwS2hJYzQ0RXVadmZXVWk3LzZFcTlkY05pUldhWElU?=
 =?utf-8?B?UXVUdnA3ZlFKZmhPS0JwSXBpWlNaWkhQeDEwQUlucGxmWkd2QnZaV2RPM3lm?=
 =?utf-8?B?QytQL2ZJTExHU1BxV2g0NU9VVjJmaTFaNVZNOHlTSTAzcHNmN3FWRlcrb0RB?=
 =?utf-8?B?SUptY1lGanJXNjJGL2VIbVdtWnZSb1pLYnZQcmhVcG14bFIvVHdOd2N2VHhB?=
 =?utf-8?B?dUI0aE9SdVBGdnlIeFRzeDh3NnVqRGU2TE1UaTFlaFpnWFlEVGhnT0xxQUh1?=
 =?utf-8?B?Y1BlTlRTbWFnZFZpT0d6TkZkV3dHVXY4MkdSM20vOXpaM1RQZ2lib3g3eWhu?=
 =?utf-8?B?ZTAxR25jREJHbCtPSStBNEpHTGs1MTlrN1VqWEpsU0R4aDF1RldSVDdZQmg5?=
 =?utf-8?B?anZCenlTajJQcUlaSXh5OVpka2hpRnI0VTV3VFp1REY5TmZTTTIvOHA0Q25T?=
 =?utf-8?B?MVdHaWtUalRrazVZNHprWnc2V25wRUVxVVE5cUVnMzlnOHdCdlJVbWsyNkZH?=
 =?utf-8?B?Nm9YdXBKYUV0bERLYVBmckwxdlpkdHdISUtOdFVGNG43aWF2SE55Y2hiQTZh?=
 =?utf-8?B?SU03Q3FIM0NsUjRkQXRrN2lJZW9CbG9rNzR0MEMyS084K0VSRW5uSUZLRHpR?=
 =?utf-8?B?bFNQd2ZPYXlKSC90NTZvYkVwK2ljYVpvdndyWVFLeFdqOGx3a2Q1RnhQWE1J?=
 =?utf-8?B?dWVKQnd4c0gzYWNxWlNvamxsREIvbGxGZzNCN0grenZLcUZqTnFtYmZkVHZ3?=
 =?utf-8?B?SjZyVEVwVWZ4cmM0VmJreUdGSkFMZUdoTUdrQnBCcXNGZ1pZakgxZGhJbnZR?=
 =?utf-8?B?SW9XWWtLdnZFdjBjMXQ4U3JZMzdId3dxRW1PNHpWYklZeWNTb0o1U253OVdl?=
 =?utf-8?B?YldCTlNuZFVGUDZWa0pOVjlGbTd4bEpvcjZiWlhGTng0Mjlqa3YydWlHalli?=
 =?utf-8?B?ckU1dkxYM085MGNLMXFJcVpFeXViVGprRkV5ZmRCTGdMTDAxRGNKZXBPSjJt?=
 =?utf-8?B?YWhMRERTUVRkck51Y0Q4S003T3crblV4RkJaemVEMlRlOEx3dlMvVnRpZUJ5?=
 =?utf-8?B?dktwSzZXU2o0M21CMDI5M0sxZFJrVm1kSGRRaFlCZTBQOG9WZ1FFQit1TVdz?=
 =?utf-8?B?R0lWeC9BKzZtMW85SmFvTjFYVWxPVTVaNlBBL2xNRzM2YlZsb0J0NE1DUDEr?=
 =?utf-8?B?TStMWDY3S25oSTVDQjQ4eWh1UjhUeE9aUlYvSnRlejdBTEM4V0c3SU9JR1Fa?=
 =?utf-8?B?a2dkbytzMGZCSS9ZNXlQVUhjYlI5bGh1WFJvRXdBK3J4NGV4WGVnUlNVMGJB?=
 =?utf-8?B?bXdabnVXdTZjSUtMdVNSWitna0tvSHZ6R3ZIN3BxbWdJUmc3dC8rMWphcDI3?=
 =?utf-8?B?SGtCbDF2ckxJcE9WTkllaGdHcWZsNU9VVmE4aHhVK0k0QjNNRFg0dlQrZkdY?=
 =?utf-8?B?Mm44S25xQXhxbGNWZDRFQ3BVajh0UVNmTnAyc3VYeEc3akxiV2pLSmhlcytW?=
 =?utf-8?B?Rlhub202WkZkR2grZTkyN1lNS0FSL1BnbEJaWGx5c0NYTkdlNjMwV283K0Vp?=
 =?utf-8?B?QkloT1RwbEdVbU1SZ1kyM3lxdHN4eUNkZnArT2JXeVl5N3pNVlBJUGdoTnlZ?=
 =?utf-8?B?d0Z5bDJuTzFZNGpGb0RtdW5wd2FqNnlheHg3U3F0NjYrcndCR3piSmVCSGJL?=
 =?utf-8?B?MjdDTXYzRnRWU0k3aUtaMmRSRlFxYXR2UW9yZUJqSWhtc3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2pvUHl3REJmbkpTOXlLSDM3MTJJSDd1M2lPaWwrL3J3eDk0YTQ1UmwrbWhv?=
 =?utf-8?B?ZWo3TktHcDZ1SW1oQkh3M2VhTk0yd2MrMGdXRENQcWp5Q3ZRTjVKRk5Oazhv?=
 =?utf-8?B?QzdmVHRuNE5kbXlobk1yaTJ3TDZyMmRNc29Gd2VmSHBGVXptMnBsM2o5T3NJ?=
 =?utf-8?B?a2VyajFHc1N3RzkwWDg2N0xGRGtRdXNqMUoxV3REUlpsK1l4Y3BWUEpDZzNJ?=
 =?utf-8?B?N2cyanlYZU9DZ2xiMVhwKzRNWWhFdXM1Ri9RSjdOMlNSb3ByMGYvbmtoaUl3?=
 =?utf-8?B?bVNrUXhPWDNDWU02cUJpMlRLOWt5UmFOYThBVUFFYWhxVE5UWmtGeVNOaGwv?=
 =?utf-8?B?VjJmckpiOEEvRStSdFdFVE9WZUVpeWtQVWtLZk1pRWQ3YW1Fdzdvbm5yWUFa?=
 =?utf-8?B?UHR1ZWhQOWxxS09YVDljQlNoNGhBSk1sZVM5YmFFYWQraGZ3RDVpc1dIbktk?=
 =?utf-8?B?cThlMDlQV1BCRHFaTzRpSHIzVURGaThHcEhwSHhWRDVnQmNjQkxuS0QxNnZL?=
 =?utf-8?B?SUxTUThqMEo5TXYvM3dOaThGbFMyVVQ0MVJ6bEZtTzVQd1pFcU5wd2kzdVhR?=
 =?utf-8?B?eUxmWkNIM1dGZkdPcDd6SjZ0ZXFGaXZGVEpVbzZkcWtGTEM0UmNhbTZUZWww?=
 =?utf-8?B?WGNHTStOdzgwbm1iT2tGVXpweTVwUDRZOWdyaEZOc2FFZEhpc2F6bjlMd1V6?=
 =?utf-8?B?NWg0VEtRc01ZNkV3a3BMZ2M0VS9KNFNEbkZzWlU2dDFFc0N4UUtKSjFFRWtj?=
 =?utf-8?B?YmgvMzhQNHhPRVZSQVVKNWJzL2QvSDZrRmhEd1ZJZDcvV213SkVjd291TDJp?=
 =?utf-8?B?dWpuUjlYeU9mQVZpNkZDcGpMR2tuS3kzSmNrNy81VE02c3BOVXJCZklGcUZN?=
 =?utf-8?B?cThZS0Zxdkc2dENGeWRtaEt1K2NxTUdaQ1JWYmd5QnlxWVIwOE9WT0FZdTZi?=
 =?utf-8?B?WHNWY3lMTzZyNUxXMjVINGZPRjlGbEdSUEdNSmNwVTA0UERDUEh5ekQrWGZF?=
 =?utf-8?B?VDFLSVA2bTZMdk5RajNHTTdUMksvV1Y1dWVSdHRTMis3SllBbERkY3pIdzN4?=
 =?utf-8?B?bi96L1NreXdOK3hvT2dQYzBvQ1djb3drZmMyYVdpeTJnZXYrNUJaQmF6U0xx?=
 =?utf-8?B?eFhhYUpYazNWaEtvMTd6UmpvSmpib21qU3QrODhlTHUvLzhpRnVMZG1ZQU5X?=
 =?utf-8?B?L25tTkhlZXRJV2V6ZEdnc3dINmdSc3FScG5qOTUzWEM0UHYvMG9WKzljNEIv?=
 =?utf-8?B?RTdLblVnQnpUeEo1bEFDaDQwVXdPai82dmRHZy9VdU0vOGZ1Z01abWRzbGJB?=
 =?utf-8?B?UjQ3Zjlucmw3cDhWMkxyMnhOZ3FtM2pvYS81MjZPWlBHSUtHVlZ1T1lHbnQz?=
 =?utf-8?B?YUp3ZHIxb3IxSUtRSmdteTZqVVgrSXM2YUlHbnFsY3U2ay9pdTI3UXByN3g3?=
 =?utf-8?B?WmI0aVZ3Z01ZOFpUa0F6NXgxYjdWQ25sbXc5UTQyOU9vNVNYdFNidU1JQTh5?=
 =?utf-8?B?akZlanMrb09ZQU42bTBDWUhTMUF5TUhzQ1JMU1loamMxMDF0ZlNxNko1aUdS?=
 =?utf-8?B?SjAxc3ZmT24rYkRtU0F2V2JGajVOdDUwdE1nQUtPWU8yeVJ4L2Jsd0Z1aVll?=
 =?utf-8?B?OFMrOFBQMEk1MnU3N2tIelVHN0ptUVdjaUdxVGFWVGFzdnJ6UlREcVRDN2Ur?=
 =?utf-8?B?MlVqSWJETkhndHMrY0k4d0JLNTU4a0RWeGZudDNYYjc2cVgrZWRXN0FQVnhB?=
 =?utf-8?B?OGFMYWZpaURCb3BXM1c1d2c5em1LK2xoSEwyZWtzQkRTUmp2ak9HeGExOWlX?=
 =?utf-8?B?NC9SVXJqb0NOa2l0SVdxVEdjeHRMaCttSlFVbkxveWx1cVYxcEgvaEFjTWov?=
 =?utf-8?B?QVgrcVFyRVRlbkc2c3c4eUdFOHdDNWY2c2ZGeXNZalRIZUJ4UEp4M2FMU2lH?=
 =?utf-8?B?d2NselVJMWl2a3NXcVdKOEkrbUo3eWZsUmJHR3VKWlFxMzVvVmxBVXYvU0dl?=
 =?utf-8?B?d1QyVjR5MzZnWDZsb25TYlVBLzJTQS85VmdweUtHb3NCQVFNTmF3NE5vMjZY?=
 =?utf-8?B?bm1wV0tZdjBnekJ2aFFzK2x1aEt3c1JaQUM4MWVzUytPOURVaC9OWGdKM3Vl?=
 =?utf-8?Q?/y/72KizT0UeB5x/kGJLnewLR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84f6c85-fb45-4c7a-4612-08dd8121062f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 22:08:19.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+kkaZBnuRDCHpQi/9b+RO0e45fre0OAkFn1g5ukrGQcr78C+WXaeP83JkKxBj9OIPdT9eqhmTTOxKgTHmwHRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387

On 4/1/25 11:10, Paolo Bonzini wrote:
> For userspace to have fun with planes it is probably useful to let them
> create vCPUs on the non-zero planes as well.  Since such vCPUs are backed
> by the same struct kvm_vcpu, these are regular vCPU file descriptors except
> that they only allow a small subset of ioctls (mostly get/set) and they
> share some of the backing resources, notably vcpu->run.
> 
> TODO: prefault might be useful on non-default planes as well?
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/locking.rst |   3 +
>  include/linux/kvm_host.h           |   4 +-
>  include/uapi/linux/kvm.h           |   1 +
>  virt/kvm/kvm_main.c                | 167 +++++++++++++++++++++++------
>  4 files changed, 142 insertions(+), 33 deletions(-)
> 

> @@ -4200,8 +4223,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
>  	 */
>  	vcpu->plane = -1;
> -	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> -	r = xa_insert(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
> +	if (plane->plane)
> +		vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> +	else
> +		vcpu->vcpu_idx = plane0_vcpu->vcpu_idx;

Don't you want the atomic_read() for the plane0 vCPU and use the plane0
vcpu->idx value for non-zero plane vCPUs?

> +
> +	r = xa_insert(&plane->vcpu_array, vcpu->vcpu_idx,
> +		      vcpu, GFP_KERNEL_ACCOUNT);
>  	WARN_ON_ONCE(r == -EBUSY);
>  	if (r)
>  		goto unlock_vcpu_destroy;
> @@ -4220,13 +4248,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	if (r < 0)
>  		goto kvm_put_xa_erase;
>  
> -	atomic_inc(&kvm->online_vcpus);
> +	if (!plane0_vcpu)

It looks like plane0_vcpu will always have value, either from input or
assigned in an else path earlier in the code. Should this be
"!plane->plane" ?

Thanks,
Tom

> +		atomic_inc(&kvm->online_vcpus);

