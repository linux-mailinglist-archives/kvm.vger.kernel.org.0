Return-Path: <kvm+bounces-29257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D39E59A5E08
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 605821F242A8
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19C71E1C08;
	Mon, 21 Oct 2024 08:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JPqU5rX7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCF51E0DD1
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 08:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729497938; cv=fail; b=gTRVhUlquXCuLYS15c3P/LZYqe/v53y3TzzCnWaKk/y5H1O2QlzMo+HGpbx5wQif/IUh6OUfwb28HAf1IzODPJZGxHuQ5l6utgxpIeGF1JSLUV/9LqV8ucPizdqxpXuW1jrLpTXTSlRXwhWYOYJBcaoXMFEH8n+G9YeSmBHmzg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729497938; c=relaxed/simple;
	bh=dhf+iOvVj4RGJK7ns+iAXQNvohwdDefYL54dfAG87l8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kukUX9cggO5RLpnSt1q9sfxzEESDXTTwScgBKE7B9+iO2V6mDIvpY0U3NfTHaBxubCdZll8j5+Xlx7VXIauklkTo+gZ2kjUbZDoBrs19MAz3h5hsDPirrxDYfoQvfVKuYQpEU/IeqA5uczXWxv5Mk7/7TgtdxwfxMgN/ktPbdtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JPqU5rX7; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iV1ko95P+DV5HC/8aPk/6gDArAk1+7hIAe71Rp77KlBTSUEOpi1gEpS8t1hMPeFcvaItwiPrQcia0bLu9hUYlyBNj36XyqMe0vHQ2sLwFsllagnhouH66wDcv4khZygDbiFJ1G3uQ56rmeoL7Z3b/KI7GViC8apZ/M9JwIzlwei3X1TWXlGaEY3w/ZYyS/M8BBUONnhKjmUIlIXQDrunXgTJT+vSkM5XStGhIshdTAZpiG4c5SfcXHqMh8SR+T5UG1ynVMgvP0Q+ZSVQBBdi1sRA/SDMnE2uQ8hcIjVY06BOgrQ1qBw4CWC3l912/d+nSDKL/CKynYkWjjcB0wmssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+6qej2M/m1sPrb7L8LXrPemDbl2q+bNB8Njk1ncRAE=;
 b=JMR6O3Af2CDPRF+90o+f0R9A56QUFPKkZ+gnHRfvPv0dQFMZiUeYKNzDi0IIRwl+xLja3vxwXkebyIeFtD3cf2FiGDBdkOmU6RiVTQMIRj7RSi5xIR3egtK3gsV7/R655NmHckef/ldwJjD5EfKmJjnXe0GiUG5YfOObyicyRBw+ANWhXF+VARUwaZikOQZPEuZbj055S4vwPflSBCsuzMJRhrFwYTyDhMEsbNt0IpWdS6oC/bwHx0IbLv3nrCR+rw2PzqYUAMWy6XYKJqU9+Cks4/iH2kFGyYUs/+mF1sqcEGnGcw6pGffFiepUin0lGs2hBPGj66WcvYgfMIh62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+6qej2M/m1sPrb7L8LXrPemDbl2q+bNB8Njk1ncRAE=;
 b=JPqU5rX7IIDrqC1D1ktMtdNNChqeSbaaxCugh4lsf4GmG6bOR8PWlmvGPGxMJHQ56+6OR77++lqTujBnikr4JMrhGJwcGfD4g+eTQdA4JNf1fGvJEBs42t00UWJhKzR+HRaavbBYIAI8Pvb9OgUlHTB806eZAnHKg/ZIEZtbfO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB8792.namprd12.prod.outlook.com (2603:10b6:806:341::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 08:05:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:05:31 +0000
Message-ID: <28803b53-1ad9-4167-8df2-407bba310e57@amd.com>
Date: Mon, 21 Oct 2024 03:05:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, linux-coco@lists.linux.dev,
 KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0174.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::15) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB8792:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b9a05e-e9e9-423b-260d-08dcf1a721db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2IvYnRnQVhHY3VyOWUyY0ExKzVGVGs2dmd6Tms2MWlYakpBempidmJpYjVm?=
 =?utf-8?B?Z0E3MTBncndGQ3J0dHowL1djWld6S2ZhaGtqVEtwRlJHQ0VMcW8xYkEvQnMx?=
 =?utf-8?B?akYveTkzREw3MnQxOTZvZjZKK2N4ZnFwOGZRR1E3NERlOVdJSEpiU2ovTE0v?=
 =?utf-8?B?azZ2L2xwd3h4UzF4TEd4OUtJTFh6cDZmak55bVBqd3lJZVJ3Nis0U2VsQzk1?=
 =?utf-8?B?ZDVyRTNvQkFvUys3Rmt6Vk8wUzMwVmdIWkZ5YnFtb0NNcUxZUVdHSjRPQzVJ?=
 =?utf-8?B?ZnB6b1Y4WEIwajJTZ3hkVGRJLzdlWFpZQ3c3MjF4SmNMYnBNYm1FTUJ3Rm4z?=
 =?utf-8?B?MlZUajFUS1Q2R2VBMUhaY2p0YjJ3TWkvWVVPR3U0T2lFWkF3bjl6cHBFaStO?=
 =?utf-8?B?RU96T01HdWZ3Z3NYdlZ6MDhpOGtuaWMvSWRKWEVkU2VSZWgvV01aUVozc0xt?=
 =?utf-8?B?bzQxV3NGWkgrcFhuU092TkhSUkJqa3ZVZ3AzYTd2UmVORHdmUUxyem9NZmI0?=
 =?utf-8?B?SkM3WjQ0ZVprV0NqZ3Y4cEdHYXp3TWd5TkxiSWpwZ3cvVEk0VzhtZXRJcFJO?=
 =?utf-8?B?Q3FHUXRUTE9YM2l5TWVJRHdTWUFKUE5UN0hoRVFmcHN3MmF2cnYySzUyTzdt?=
 =?utf-8?B?UU5jYjFMb1FHcHlrQWszOGgrbXp0QmNHbm02S2xPdVhtRXd1UHB4QmNpMVV5?=
 =?utf-8?B?cFRMWTU2ZXNUWm1od0RRMk5va1JtMTNMUkdURG1jcWdnRm1LcUJUZGpoWk1W?=
 =?utf-8?B?bENNVlRKYUZKSFE2c0hMUUh5cjlFYTR0VG4vTWszNmtmZW50Q1dadU16UGdm?=
 =?utf-8?B?T2hmRElNMU9DMmJWM1FyaFB6WkthaHpEYUw5ZUthK2VwTGlsWGFSWXhJY0Ux?=
 =?utf-8?B?MThVcHJCOXJJV2E2TVRnZ3Izc09xOERTMVp3cmgvOE5rMzZiem9HUXBjUnAr?=
 =?utf-8?B?WFVEeHVpQWtuLy9VZzl6VDZCclN5dFM3ZlM2TnFUQ1NwOEl1OU5sWUxGZE5Q?=
 =?utf-8?B?ZlM5MmhxdWw4VWptUERCUTllMzhRa2ZOZ0NZRXJtNFRLMUhTeFpoNzk4Q1JE?=
 =?utf-8?B?aU4wMC9yWnk3QWVwbGRuNDg3NS9yY0lwVFlxZmNQSzB5TStTN0dKMzdYUzgw?=
 =?utf-8?B?UUdJRUx4VjJtcnIwM2tJMW9QZnVHaTRYUVlHdUUzWVBXYTRMVFAyWnNwejY4?=
 =?utf-8?B?aDRQRDVaazRneXF1M2lvOG9BQVh5UlRGelVkd3RYSHVxTExYeEMxRk5FcmtM?=
 =?utf-8?B?ai8rakVKOW9rQmhNUFdKMFR0VUJNWDRwRCtzTTBTamRlTFBpdFlvSm55bmxx?=
 =?utf-8?B?YXpmM3g1ZW1RMFBuU2t0bmtnb0lySjJSbmJvU09BYW5MbWE0TXlkNXJ6Ujli?=
 =?utf-8?B?NkpyZmthbDhOTTcyWllNZjF2KzZXSXhIeTcyV296VlBMVjNWL2Q1M0R4Yk9u?=
 =?utf-8?B?UlZaQ1lpUVJYNE9VcTZXVWFSWXhmMm01VlZ2TWZuNnJHaTBwR2ZxUGVvZlRV?=
 =?utf-8?B?ckJaYjY4N29taGM1VmFqc3dmM0xjN0lJM21iYThOVTQ0bmlPYjFDTUdiVFNT?=
 =?utf-8?B?LzBOcDBZSkp4SEI3dXA4Nm43VitabUVBZzAvd1BZeXQvYzJBandva3JvTEt5?=
 =?utf-8?B?WGkzcDlnY25tQVJFdFZDNUlEZURjcjAvS3YwTXhNaXJqdk9mWnNLYUZMRGFS?=
 =?utf-8?B?c0g2MCt3UFN1OUQ1b2dkNU5DdHVZb0UxRWpJQW9tdnhzK20zVHdtcUltZWZw?=
 =?utf-8?B?NTZyNHB1bzJjcCtrb1IrMmdhQ0t6YnMxYUJ6cDJSQW1pNU9hbGlNdTJST3Yv?=
 =?utf-8?Q?Y7ntYQ6urqbejJfRba/1QuFs2K0hubbhRZA0U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0Q2OThGV05VUkpvQWFvd014aDcyR1NpNnJCVkNrc0JxbkZJVlkwSmdFMUJS?=
 =?utf-8?B?aHlTck44VEQ5cVdOWkRGdjlVV1M2dllUSnlJWkllYUxnbEora3gxNkViYTJG?=
 =?utf-8?B?OHA2OURxb0ZUNnl5UXgvL2ZGcnd0NytvT3lib1NjTWd2K2ppaTJKdTlSeFZN?=
 =?utf-8?B?RWxQbWtYU2xuV3JPMDN1NkVDV3B5amh1V1VUY0lQUklVUXZKdXIzdG51b1A3?=
 =?utf-8?B?UUtFdFJ2VGlIYXE2dU4rVzFNR1VVWDJGZmN1QWFNV3cxMm53UXloaUlhMTdN?=
 =?utf-8?B?OVBLcVV3ZzAzaldwNzdPK2o2dEdJVFVML1Vxbjg2RzdLWDRrRTE4Z1Z3QWF4?=
 =?utf-8?B?WGZOOTNCK2pOd29wQ1VMLzFmVzcxdkQ5MUQ3eGlKMnFha1Awb29PMHVLQXhD?=
 =?utf-8?B?OGZxM3NaWVJJY0lkMmhvd1Nqck4yM2I1bjRBOXBheGdxZU91U3pRNGp3U0g2?=
 =?utf-8?B?eGFuaGI0N3J6eUNTZ2lCS25Bek5mak53b2NleENaT1NFTDRKM2NiaS93SzMr?=
 =?utf-8?B?TjNFYkkyMXg0K3JWSDIramVGaisvcWFiS2hHcngyT05WZXgwM1VsUDc3eDZo?=
 =?utf-8?B?MlJMcnBxcHNRVWtocjYweVZGRUhWVDQzeUFXQmFibjl3bS9FSXJYV1h0MjBQ?=
 =?utf-8?B?Qk9tZTAvQXFSSjVFZ0RNdVdEZVRrVkczMzR2UDI3RGM3MEdkOFVZaDJYN2Fl?=
 =?utf-8?B?cTBQM2pPMDI5RFBzRnNjS1Q2RXBLeElPRVlXNWV5cFExd1VEb0czL2pQSjJJ?=
 =?utf-8?B?dUgzQkNkeTVoT1hsQVBYcGgwdzZ5Qjh0OHFINmE0NFU4TnZSQ2plYWlwZCtk?=
 =?utf-8?B?bTZ3RFlocFkxVlRQSGlwWWFFeDZnUmdESTIvMFRrc3RKU0oyYlVBMzVGTVgx?=
 =?utf-8?B?ZUhwTkExSDFIMnVXRFppZzhSb0JFTDJ3aHhzMjRvUkY1N2oxaTc4MWVQY1M1?=
 =?utf-8?B?TFFQOFB4by9GVG9IWkc3Z0lKK0xNVkJxQ0FjVGdQSUxpZFdnaXYwczZ3UzYx?=
 =?utf-8?B?MHJqNkdLSUpFZjRrWmRET0FTWEtYZzFLTEFUc0xsZXAwKzd2RnhSSE5FR1RZ?=
 =?utf-8?B?NHlOakowS0VQMmZnd0U3bWp3RmYrZUpOeGdNK1JaT3gvYVQySWFPaE9DVm1M?=
 =?utf-8?B?dFFIU29abXVIek5NbnM4RWxNVnNBNXk0bk9jMythN29GamNSdHplMzVQcG1o?=
 =?utf-8?B?R0hBQXFMRTlPVjFVMUl4UjVZcE04dTE1RGk2NDh3MC8rRVZSTk5kZnBjUEsx?=
 =?utf-8?B?SUdBbUpObGVhaVh1ekN4L09aU3dTVEFYV2dLbFZaa3V3MkdwZDJwanJqUW5Q?=
 =?utf-8?B?ZUwvaUJBMU1ieWlGOEJkdXJQaElZV3dHQ0lxZmZ6MG8vQzU5RFAzUThxRXp1?=
 =?utf-8?B?Q0pVazZnSC9KcVR5RlMyNktjajVmcFhibGNhcm9EU1dBZ1RpWWRSWmIveVI3?=
 =?utf-8?B?TzB5a0JqTWplV2hsbUJZYlZjcjloTXNVZ2NOd3ByeVlONmlhb2VBSVRjc0Yx?=
 =?utf-8?B?dWo0bmI5QjgrSndpNmdIT1g4TCs4MkJYWVR3a2RwcmhKaVNzZVVWQitLbWdG?=
 =?utf-8?B?Y2NTZnd5L1VGak9DRFI5WXZXcExmZHRIYko2aC80b25FK3BES0IzVVhwYzZX?=
 =?utf-8?B?Z2tlK3R5SEIxNmZpWFJQS0NrOVRSTDdTRU9jUExlREF1QVo1aE9pYWoyZmRU?=
 =?utf-8?B?cWRGbS9NdUlHUiswYmNBOTBOOEZNaEZnR0NnQnFhdmdHdmE3cG5mMHgrdGg5?=
 =?utf-8?B?dEVSZno0YWxCdVB1U1gyaWxsaEdpYUIwVG9rYlliOU9LczRsYy9JbHJMNU9j?=
 =?utf-8?B?dWp1OURYLzFubURNaEFZdFEzMk13VDBIN1BFMnZXUWxQTCt0WnQ2d1dhK054?=
 =?utf-8?B?enFrTkVmWllja2N5dFQvZnZmblhaVWFUUzNCYmJDK0FqWm9BSHBvcWNRTjgy?=
 =?utf-8?B?aXRURFFIUjBKaEszaHZMeFJOWC9ON0NseVZLVGd0SC9XSTZiYkhZMVM2VGhs?=
 =?utf-8?B?a01ERkU2REpWTklWRHFCZ0VTM3g4R0EvQnBlM0ZuakF0M1lmNlpUY3BBd05a?=
 =?utf-8?B?eE5qL0Y3L25hVDF0UmdlSktHU1lpYkhzUm9VeGJib3QwRXV4YkQzVHhkTkxW?=
 =?utf-8?Q?Y6vhgm9WKPcaxuG3olusQmIaA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b9a05e-e9e9-423b-260d-08dcf1a721db
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 08:05:31.2699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8c5GHr7m8LiRywaH9dhlS8Xr75pN2Df2nWXCEmm1yMQWp2w2DiY7+skVYHgxUsYKGZLQijl5LeM1JEAgJ/GWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8792


On 10/10/2024 8:39 AM, David Hildenbrand wrote:
> Ahoihoi,
> 
> while talking to a bunch of folks at LPC about guest_memfd, it was raised that there isn't really a place for people to discuss the development of guest_memfd on a regular basis.
> 
> There is a KVM upstream call, but guest_memfd is on its way of not being guest_memfd specific ("library") and there is the bi-weekly MM alignment call, but we're not going to hijack that meeting completely + a lot of guest_memfd stuff doesn't need all the MM experts ;)
> 
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing development of guest_memfd, in particular:
> 
> (1) Organize development: (do we need 3 different implementation
>     of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
> 
> Topic-wise it's relatively clear: guest_memfd extensions were one of the hot topics at LPC ;)
> 
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), starting Thursday next week (2024-10-17).
> 
> We would be using Google Meet.
> 
> 
> Thoughts?
> 

Thanks for setting this up. Want to join as well.

Thanks, Ashish

