Return-Path: <kvm+bounces-39558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B2EA47A46
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 11:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5854B1891D16
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B8B224249;
	Thu, 27 Feb 2025 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DoCokJnO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE851E833A;
	Thu, 27 Feb 2025 10:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651940; cv=fail; b=b3eG7xX+Vv16rI9ZPJlQtO99P7Pzx+T5dGg5G0gsMeyCTIAoJ99Bsc1IWNXwHSD6Ql+eSAEl+RyiaHrTyPnBwP2aSvAUKgQvw/DwkO9O6j6CIObUoyL5qUHERpsTX8/xvydsuaXLdl0Io0C36YxWTmhCt6Ohu9SLxJNEMWasRn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651940; c=relaxed/simple;
	bh=XZEMcfAdwqw//Yjbcy2CMBPhCKNzvDnjskhogBGnVUs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NgL5WdYHQ2J7EJmAQo/rbyRpKJ9pJqCgKsPCbYsK+ErBKIgM3xByTAkrcu/DP7qpLvR2zQeI1OlErvtskpfl1YThy4mGQ56qV2gpYEHfu7VrKDLpdG0rMNMH0xQ885PzTGxE4n+omJ0A84nnxqeUqTJYYAUheEJp/76bXxNxnVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DoCokJnO; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hIN3OKvzMniukEyFOMS7xlZtbVgYBy11jeHOMrH6Bd7VNMfFoBFFeM78gv1uJGDLZYWil2l5LvGY/pETImT+G3Y2QsRY6ooCAQ6TDEx3+zs2Q7MRFu9Hc86QzDbn9k8yIGfiAf9OE7B2awfwTpqea78G9k9IefpyrCWW93q6xAZXKxxa0WRvQe/4BR3rtAnIzuUNhAkaXRvcsM0JtKzFNNWr/s1DH5DTsn4nb4SToVdW3wZ+64mOMLaOa8PswDXYUSOeF3EghWixSY/BKHklAQbbvoBeNzcj8a7/IJoxvVXpYZmuFMBTNTy/sy7eK9xmT0s5fwZ7yQIFgQ5NuuiUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUcKX7t4fY70lPY7/5v+W/dHZHvlNzXZarnsAEa0Tao=;
 b=nd2IeedifKkKf5w49Px4aoPWa8L06DzDTHWFVxmw0Z9UIy/7VxIJpzFHRqZ6pvHTsmlqfmPtXXE3CKqwLB3mMR63n2mgAgE+OQQQhneZO9Z8s0Uv9gqeBjGcigNFzTKD5VVWbqTiRiLsCb6B3jgDiknhdgKjTenPg0vZVN560XFfk4Qvx2oMfZo+4IAgTkvg7DF2H42lELueJoYnRdfWX8k3Wk4NdGEao7104Z1k4p2QCJRUKp7kNsDA5r0H0a1nd373DtwqdIypQ8/SD7wjnZC2p6myVp9U/S7kXvxYkWxAd+5L2V83vqpD7qdmDMzI5Gv5Zmlm7bQPpIo/3RNYXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUcKX7t4fY70lPY7/5v+W/dHZHvlNzXZarnsAEa0Tao=;
 b=DoCokJnO70buX2lD/cD3v+Lxob/C6A/y2i2wNI4SiTWgVUgufxDNGgLs5JbhFa0fTYMnZ7an+dnSCqj2/nI+p9HLZFrTj+1WdMvOSw1Ww/SnFGKyS43SUhBZt8xsXcm3Q52ZdQkMNQjjEh4rr2gQvT9zFW+/I22CxZ3VBPUWlSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 10:25:35 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 10:25:35 +0000
Message-ID: <a0f7bc73-aec3-4e05-b35e-b3095badf534@amd.com>
Date: Thu, 27 Feb 2025 11:25:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] KVM: SVM: Don't change target vCPU state on AP
 Creation VMGEXIT error
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-5-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250227012541.3234589-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::19) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d05e652-7524-4772-09cd-08dd57191264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTlUWGVpOXc0Zjh3ZlY3NGhBNlBkUDhUaDRxSi95NlhCRG1DS3ExbmFPRjI3?=
 =?utf-8?B?UlBTa3BSd3JMOW9ZU1dDWWFuaXYvSnFDb2tjMUhQcnZaR0lkZWpkM3o4YWtl?=
 =?utf-8?B?S0ZZK0RlRW14bnZVKzFkTWpEMVB0Q0cyRzd3eEFReFY2Q2k2WklhcndHcWlp?=
 =?utf-8?B?SHdPS0dIbGFTeDQ3TGJuQ3dUd0pFVVhFY3IvbWZnS0l3TXJzWXhGMEZLSldO?=
 =?utf-8?B?N3pwaE1TeXJPQ1hvTENKKzFhY1NQOTlXN3huczIrV1V2bkdTYUxWQmFxMEVX?=
 =?utf-8?B?cDJSdW4yVlNXQUVPZTVyd0FTaGd2b29BRXpRRjQrRzRNa00rTTd2OE9sbExq?=
 =?utf-8?B?cko5amJxQ2MvWEpsYVJSWVVlUXAzQU1yNk1TUnp5MUNtZStrY29aZk81cHpO?=
 =?utf-8?B?aHBaN2RHRnZqYUxlWGFMYlVmL1p2T1M4K0RNcjRjeS9HV09LeGw1eHNjMW4v?=
 =?utf-8?B?RzR1K3NTOFVHelZjN2M0dUc2RWFGYmdsb0tOakpCTlBPUHdNZmUzZGN6MXhS?=
 =?utf-8?B?dVlpdXpuVnhtb1ZiUGtsR1BjNEpUc2FmMktYVTAzMitLRjBaOVRPNFFyY2Za?=
 =?utf-8?B?ZDdFNzZzUWZZS2Z4V3cxWnFmc3NTUENDKzNmTmhKdE1UdG1GMi9QVDhCL1B2?=
 =?utf-8?B?Q1lEMmZlUmgwMjU5ZVBSdTgrYzBEb21nZTU5dlp2VTRtSERSTDJkOGJpdzgx?=
 =?utf-8?B?SENBc2UzbGxTVC9HN0NaZ2JKWEVRb0ErbUNveXlQUXE0S2tHcXNIZFM0SmFs?=
 =?utf-8?B?QUgwa2lWSlNlM25kVytTRnA0clZQWERmVXhIZjZrdVhEZGhOSXBIcHppU0hz?=
 =?utf-8?B?MnVHTUc4UVdOVXV1UmJEUzV6RUFxc2I2cXVzWStnTkJqZ2h2YURlYkJBelRo?=
 =?utf-8?B?STN2WTBMRE9FeTViYmJLWkMrVGdKT1RRQ1ZXOGpSMXMwbUJJdEM2Vm9lQ1Ji?=
 =?utf-8?B?b2M4ZjBKb3lkZyt2VGNtcVQ2RURrL2xqTUJMYnF0SHVrN0hGcmF0NnlXeXdw?=
 =?utf-8?B?ZmRsR0VDRWxhOEl2aitOMzlZLzQvUjYvd3FsR3Z1VDVzanNiV3pxOXFDK09G?=
 =?utf-8?B?Tk0wT01wbHVmaGtXT0dmSXc3ZVZvYzFxRC8xZXN5U1VYR0JaempTVVRZYzJq?=
 =?utf-8?B?Y210Uk04eHZScnV0bFd0VHhpd09VRXJobmZGOXlmOW5ZaDVKQ3BxbmE5VzNJ?=
 =?utf-8?B?YitkNFlXdURsczhHS09rTGo1K2N2YWlBQmZwSTZCdTBiR1RPM1Z6SDh2bmdp?=
 =?utf-8?B?V21IbGJIV1lxOXBzMGtRUW4rRlYzUm9vMGk5Q1h5ZzJHY3dOdDZtamo1L3BV?=
 =?utf-8?B?UzM2QjFWZitLQTRuVkNxNnZrT0U2akpySk5penFSa0w0OGJZNWpmNk96bWVs?=
 =?utf-8?B?QSsxZ1FzOVN0bVE5c1Y5TVRiL3F2bVVVKzdUSU5NVkVEeXQ1dExhNnYxVDkv?=
 =?utf-8?B?QjFQNENDUWVKRnRKTFhVaW5kZC84T0tzVExUcko4QSttc0tmRTZtKzczT0NM?=
 =?utf-8?B?VUFMWTAzVmpPeUJKV01UelNiL3VhVitMaDF2c3Y5d3RCNm4yakluZ3VCVmh0?=
 =?utf-8?B?UGJicFRvbHBKcnZ6Mi92MG5YS3puYUZLdnBobk1lb01kcmZmb1FBc2FXWFla?=
 =?utf-8?B?UlRwM2t4VzExYnJMT3FHTTB1dmRDVmlxSVQzcmowTW1jSG9aOXRSaW55dFhU?=
 =?utf-8?B?WThXMDcxZHQvMlBEUkxCczhBUGttUm1Xcm1pYkF6V2FtYnBveCtkcjhvTmNS?=
 =?utf-8?B?aHpvb00rZHRLekFTaVM5ZjVLaGFBTWVzS1Q5YWtRVjFMcmZQbXdpZEdGaEdM?=
 =?utf-8?B?SHgwdlgwMzJKY3pBT1NmWUVQZDFCeHlVZFA2UmtNTVplR0FKVFhsTk52UHRV?=
 =?utf-8?Q?Py5Yp2qmghjVz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eC9WWmtwYmhKNGl3YkxKZXJwMGxXZEVubTZRbWF6YnlTQXl3b3FyZ0hCUEIz?=
 =?utf-8?B?YlNqSXRsUFNvZ0tDYVk3MXVXZW1SZDhYWHp2UmNCU09IbWJVczVpelZUR01l?=
 =?utf-8?B?SFRqSnU5bDd3VlEwbWx0MllLSjJtRHlwRkZlS1BIbW5HcUgzbVVjd3NQRkRx?=
 =?utf-8?B?NEFUd1BlNStWVTdtUWtHS0paTnlyS1BUMVpQM2syaXNWeTdFSWxKdlNRdG8z?=
 =?utf-8?B?RkxqNjFlQWx6aVdoUUgvQ0hqNjlkMVNVaUxGbUx0RUZHMTl5M3U2ZFNuQlpL?=
 =?utf-8?B?MVZlZ2dzSko3NjQrU1UyM2ZCMmtmbm0remtZY3lYcWdyckd4WGZIempzeHVP?=
 =?utf-8?B?bjRIRmhVMWtiNDgrV3crOXVYOVZFZ3l3MjRBUlNZcmw2VERkMFlpOVJrNEZz?=
 =?utf-8?B?Qms5ZlNOV29RRVZSUWFRWmxaQmNqT01KajhKQnQ0NzFKVVdpVGUveTJTSGdR?=
 =?utf-8?B?RVlKWEJrOUl1clBhR29MU1NJTHA1Q1ExMWFQNWNMVUIyc2xDTHNFS1dEc2RM?=
 =?utf-8?B?ay9kMVNwUWYzMkpscXpXRER0c05TRXRKdkRTTWdLblFZQ0FGbW53a2JWOGc1?=
 =?utf-8?B?M3lJVWdjczVoUXRPbjhjT3A4QnAzOWRGelM0WmV5SWd2c3hGWFFDUGJpUzlG?=
 =?utf-8?B?enlPTUsyTERQdVhmbDlzYnpaSGhIdmtHQzE0MGtKMFR1cjUzSEgzeS9SWlN6?=
 =?utf-8?B?TFpzNm1wdy85eFpLTmlqZ3NUZTU0ckVKN1FDUm9sU3JSaEdzeVZQZU9HNytS?=
 =?utf-8?B?K1loMjFmaThLbmg5YkpqazlLTUd0Qmg0MkU5bGREakhlSkFRNklRRTZNMFg3?=
 =?utf-8?B?NCtMYWprWHF3Rml1SmxmSDhodk0vblp2dkQ5U2ZINmp5SHc3UHRnK0lja3Jr?=
 =?utf-8?B?MGtwYnJ3U1U4bmVVcDkrMStGdlFBVlFGbi9VM1JBS3gvSnREWExTd3F6UjQz?=
 =?utf-8?B?RUJVQTAyWk01a0V6eE9sQzdzemp2em0wZ1NKM3NGREszRTFSb1o2VmJBaDhZ?=
 =?utf-8?B?U1V6RkYxRzBGaVF0QitlVXVvbWlzSDNBSllRYWtNZGROaUpXa0p1OE8wQ0Zv?=
 =?utf-8?B?RUdUbEVLSFdaUVZNT1EyTkU4VHl5WmY2TUZuVzNST1ZCVy9qWVFmVVlwNE5v?=
 =?utf-8?B?MWJ5UFM3d0tFa0hJTmN2NHM2NnNZeGhkSXRvaXNMNWdFdzZ1bi9rQWNPRnox?=
 =?utf-8?B?NUR0QWd0OXp2OGkyOXBIREVLd0wwQmd0c0JndFZmVXRFYnVoajIrQytxTWVV?=
 =?utf-8?B?TXM0NWhnVjU4N2N2YVFWWU9rcTZJbkZIUjU2M3RicHUrN2xFMXhoZk1INnBC?=
 =?utf-8?B?T1luVnRPVFQ2UzVtMjVOVWgvUHlQRS8rNDZ0UHlJa2hpQnZLYXZ5dGJKYW1k?=
 =?utf-8?B?bGRRKzV3c3gzeCthampkRFFjZno3aGZVRERvWDkvWm1DU2hsVXFQSGo3MXpt?=
 =?utf-8?B?UUpxVXFieGFMdHlWbm53TEFzUmh1OS9hbFc2bndUMlNZRmt3bjFuSHZzVE01?=
 =?utf-8?B?R25rTzZxbXpON1V4VFV2WDk2WHExNnNPRXVSc2hraTQvd2haVUtYMGVyOFlG?=
 =?utf-8?B?c2pyOHpZeWFVdDY0YTg3Q1l2ZzBkWDdQVEFYdHI5ZnZ6eTMwM1V4WFFCRmFM?=
 =?utf-8?B?SEk3UkFFeEorV0g3RElSeldWc3FFMFdJdFNpaUdSWVpNcmNDVUY2a3VwWTh4?=
 =?utf-8?B?WE1wTEJGY1ZaRzRYVWRKWjVSRTZvWkNadW9RYVllZ1pqVDZXYWx5MUl6cUFU?=
 =?utf-8?B?WmcwVXc2aHRNMjh1Y2IxN3d2dDdmNHVyL2RVM1VqRnV0bzQ2ZHBpSXNqaXF3?=
 =?utf-8?B?UnN1VUtqTzZxcnVHL25mdk5MUHNIVWtvRXhDNzR0SjhlaHV2eUNyUk5xeDJ0?=
 =?utf-8?B?U0pBZzVVS0JVRGFGZ3J3UTUzVlVOZ1ZTcUhranNPV0ZhU1BNbmdZUnI5OTdh?=
 =?utf-8?B?RE8xNjlUYk5OVVk2Sks5YTQ3U3ZFNFZnMWQwd0tiV3hsTTY5NW5PZFc5S0Zp?=
 =?utf-8?B?UmVQeWs2akQ0S2xtd0o0MGNNRmFqNHh0NkdOak9MNEFxbUluTTVqbVJZRFFr?=
 =?utf-8?B?UjR6OHFCWC9OYVhibVJyMXlGTnJQSm9Oc1dzWHR4cDFrWW5XQ3pRT2s3RXZy?=
 =?utf-8?Q?admcu6iNXNncS+HK9tk46bs8e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d05e652-7524-4772-09cd-08dd57191264
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 10:25:35.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovzBGrNwDLEVRdZvhAkqCaG+LyOlJcRC6b15w+ZUIZifxkdUg1Df/veAiD4YFDGT5YlLd7XxH801ejk5J5dySQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329

On 2/27/2025 2:25 AM, Sean Christopherson wrote:
> If KVM rejects an AP Creation event, leave the target vCPU state as-is.
> Nothing in the GHCB suggests the hypervisor is *allowed* to muck with vCPU
> state on failure, let alone required to do so.  Furthermore, kicking only
> in the !ON_INIT case leads to divergent behavior, and even the "kick" case
> is non-deterministic.
> 
> E.g. if an ON_INIT request fails, the guest can successfully retry if the
> fixed AP Creation request is made prior to sending INIT.  And if a !ON_INIT
> fails, the guest can successfully retry if the fixed AP Creation request is
> handled before the target vCPU processes KVM's
> KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Cc: stable@vger.kernel.org
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 218738a360ba..9aad0dae3a80 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3957,16 +3957,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   
>   	/*
>   	 * The target vCPU is valid, so the vCPU will be kicked unless the
> -	 * request is for CREATE_ON_INIT. For any errors at this stage, the
> -	 * kick will place the vCPU in an non-runnable state.
> +	 * request is for CREATE_ON_INIT.
>   	 */
>   	kick = true;
>   
>   	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>   
> -	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> -	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> -
>   	/* Interrupt injection mode shouldn't change for AP creation */
>   	if (request < SVM_VMGEXIT_AP_DESTROY) {
>   		u64 sev_features;
> @@ -4012,20 +4008,23 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
>   		break;
>   	case SVM_VMGEXIT_AP_DESTROY:
> +		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
>   		break;
>   	default:
>   		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
>   			    request);
>   		ret = -EINVAL;
> -		break;
> +		goto out;
>   	}
>   
> -out:
> +	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> +
>   	if (kick) {
>   		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
>   		kvm_vcpu_kick(target_vcpu);
>   	}
>   
> +out:
>   	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
>   
>   	return ret;


