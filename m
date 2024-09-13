Return-Path: <kvm+bounces-26838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A72497864D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEBC51C22469
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D24823C8;
	Fri, 13 Sep 2024 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xvkW71PA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8757A15A;
	Fri, 13 Sep 2024 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246764; cv=fail; b=RtcceWGHKD1ijuLaK0HV29NAsQxjx8k/EwJC/Ome/EO/U27o8Ogb4e2txf53FsyJhfBnaaj/tLndtuZR5wRnd4OzbcdOiUvBryWCZM4VxIGG5d5uFB3HeSzICFFBjImZ33M3BFedZDvwec4x045DUcDYOBqoB7SYXooOVGRRAZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246764; c=relaxed/simple;
	bh=46jY6p0Akt/mWLeglomtmpAsjE4sgP7oECovXIx4fLI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e+YoQf2Gzm7vufFmGWKF0W5IUhuD2h81A9lw+9d/P0NleP2kzFWX428z7D1NENUCJpCxSxe8BZMb4Ik+GiLdyxCpnRBQvbYmp4+fguz+XWUPd/hCzYlxUx2SScOenXW7nb5uusaWXt9a2fwuoT1a4JeSuA2gvB6EDu4i835dals=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xvkW71PA; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4afDoUSM2+z858LnBftNuoXyt1U/G1aWdUjTifiTsaOoI9bvEjs0i5THQ49BYluleOf72U6I3bpAcAhddhzI03SmofuuBhBfX+5P9FoJcG2DscBl9/ckB/xLYJehjkUsdITg94nbU2nyl4odAt6e+Xt+ystec4VXu0F20xOKqmX9zvmnfEg6KalXQP5iqQ03LKSY8B26IYgPA+lE8a3AzH+P/tKbvlLeuaeW9d+Cwr3ievlQQ50V3JFfsM4FyjTbmF33P9dnqRlMCccsbdk8mAJ3589jh4g3QYUuLBf8mF4hCrMRtlo3J2w8jGDCykoCsaMgozKoU/H8I72jxkDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+aOPa3plXhuZvw25Xh2Sc2hGjEyi3vlPpt3GmcZe/w=;
 b=xgYOwbIjNc98p2/9zkzjqsAR0x+PgWte2f2EzuO92/kaq6H278BgOyQF0TdfilOQkCUoQY8cmHU+0JoLDW5pP78MVwirEFY8R8FYVwaDYJcfMheVapzJoyxLJ/HgHzYVdGumvAYtz/5Gu7v8xuLA4FNcqa/lKd4nPN+N36ypZj+rCtlFR51yhbtVTA0E3kifyX/ubgac0oKiBvKpkN8QMBYwXfo8iPkB/aHu3clv4qCi6AYAbbdeFUy8sv5ddLJLgj2pKwlvr/Eu/ljLYMPavFMTfurrljXl9uhStnOT5+GRTrvcp2Ug6IqYcZreaGrRfCV1t1ObNFH+4vo80uvEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+aOPa3plXhuZvw25Xh2Sc2hGjEyi3vlPpt3GmcZe/w=;
 b=xvkW71PA08DYLS3idQK7SVA7ng0gP+GJuTt3/4v9Dwm6nUt1pl9OgjmSd2ZgYvmad9Te/5qbco9EjXR33Be43C9tCVcRqoC+kztdEF+OGReoza8707NyHlK8l9ShiXXizzh5gKj9T6XR+DXS49n2i6bfa9JWFPuFMWGb/fdQRyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8240.namprd12.prod.outlook.com (2603:10b6:208:3f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 16:59:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 16:59:18 +0000
Message-ID: <55705fb4-65ed-5fea-8fec-36309ef0d523@amd.com>
Date: Fri, 13 Sep 2024 11:59:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 18/20] x86/sev: Mark Secure TSC as reliable
 clocksource
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-19-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-19-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea71f09-e3c0-4d15-418d-08dcd41567aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDRZUThOV0lzZGxyUjIwRjhqT01Sejc0NTI1clNwUEdITGtBWDdpZitBWllr?=
 =?utf-8?B?TnJoRzBra2h4RG1XNURqQlkxalI1V25PY0JPTW1yOEdqTjA4YXZBOTVKZG9x?=
 =?utf-8?B?WTRJdFZQV1M5TDJhLzNVWDVTK2NYZ2ZRVDhFbWxuQmU1YjZvMG5KMzVDWkNZ?=
 =?utf-8?B?aWZXaFZaRDQxbHBxZWFJbmIxMHMxWk9ZM0tVZVY5aGF6Ny9DMXZFZHdUL2Nk?=
 =?utf-8?B?VDlzMXg2NVF1cU5zR3R1STRrc3RrejUwYzFuOWJoM3VVaG5uVzltenFmc3Yz?=
 =?utf-8?B?M1VsMS9ETHlBWjZKZjFFVm4zWGpTT2dxdzlkY3dnRXVjUDZQeXcyVVRkT0cr?=
 =?utf-8?B?VHp5ZG9EcTZLdWUwdmZkUHB1czJMd3o0Yy8yWjRmcDNyVElnbzNLdFBkOUJY?=
 =?utf-8?B?bDNrV1dqVGlaMlR5K3hMNTZCNFQwb2FvSVUrNXNQYzNPTVBKbW5mZ2ZSSWZy?=
 =?utf-8?B?ekRHL0xwN204dThIM09vSGtxM2FJUUFGSTVDRTBsL3IvK2NlUi9qS0hXMGlO?=
 =?utf-8?B?N3FRUVRKaDIrVDFhd3pST2FmV3hMKy9BNTI3ZEtoTHVNWTlxNmpQM0VsR3hH?=
 =?utf-8?B?ci9rVDlTM0JkclNmSmdFVGl1VVkydlVad0VZTnFtd2xVYS9nTVRFUzd4N1RG?=
 =?utf-8?B?TEZnQjdNS1pZckEvUzc2N0NDWVlyQkpvaUNVQ0dpQ00yUFE0NVVGVmZxdGU5?=
 =?utf-8?B?Rm5mNXFLOVBET2dmemVydU50M2pyeW1zc1RPaXdMTjNKQ0pMMXB0YVhacWUr?=
 =?utf-8?B?MzY5SGtDUUFFdURzNUpQNWt3bDhHY0xncklRdjlsbi9RRUtORlE3VU9EYzNw?=
 =?utf-8?B?aEpQREJ1d3ljNld2THhXUVJ3dG5YUXhtREFTMHQ5UEZFMTRXbVFPemlXaXZC?=
 =?utf-8?B?MnkxY2huVTRCOHNYZFl6SVA1bnFibFRaT0hYTDZhM0ZnK1ppYmMza3UzMkcx?=
 =?utf-8?B?UFVUeUxFYzA4d0QxdWxsTTNPNElma1pLUGZ1YUV5ZjJzZFNDcUtqTW5lME1z?=
 =?utf-8?B?TERMQzZ4OFRtMkRlWlVFaFp2ZG5pcjhQU0FvU0xMU1BmS3hObit0TmpicDMx?=
 =?utf-8?B?bTI5dW40MjFQMjJkRGw4MGJ5NDZZYTk3QUgxMm1UNGFtRWcvWVVNczJOSFZl?=
 =?utf-8?B?WW9yaHk2ejlqajNDcnY0eUkzSFdUeFFWTFBTSEYxSVdkRlE5eXpuMlNXZ1Bl?=
 =?utf-8?B?NE1weFVrdldGMXBvVEh4TDhuWXNyMGpsSFF4RFlDZDRUbmliNjM4VXRhMjNy?=
 =?utf-8?B?Uk9MbGF0WWNOVjY2Vy9mOEFhT05jQklUMkRrZ3FSeWhXRTZPa1NEcmZZRmNN?=
 =?utf-8?B?Vzd2Rlg1UTJ5RzFYc1NrY1p5cjV3eTFNdXBoam9LaWRidDFKeTdNakxva1pJ?=
 =?utf-8?B?dWNFcnMvazZqTWVGQmRkZStvK1lMRmltVHhBUW9RS0VYSjRUSkQ1dVZrZzFi?=
 =?utf-8?B?ZUF5eHNBU1JTaFY3bnJXSStERlJVbFZzZDU1RWhFNW4rZHNWbTVoTXJCdTJQ?=
 =?utf-8?B?a3owa3laR1pCR2EwK2Z5cGdOaVhsUnI1bFBWSTJuMTdHOUFaZWdhSjBnenNk?=
 =?utf-8?B?ci9LNWRraW9PUE9IV2lGc0JHb3Ywd0REdXdsWThiK0MwWEJ3cmg0QmZzZk55?=
 =?utf-8?B?ZWpEd3JoVUFtU3p5Vy9JQnRqa1dMNVdoMlBWb2tGd1gzd2wrUlFjdGpZT05E?=
 =?utf-8?B?Tjk1T3c0SjVPOVRYeU9LSzM1SjN6S0VURGk4RXlRTWhQV2tkeFh4Qk9jZW9s?=
 =?utf-8?B?UE9VMnh2aXRWaStMTjloelYrRnN3Rk82K0c4RWlIemF2cmxsZStUYm1EYkNq?=
 =?utf-8?B?RmN5NjFQN2hPY0lPWUlWZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmJTZWJjbjNWZjE2d1JGVFFXNFlWMG04bElnbHI5eHlab3FKSVhDaytmbHBu?=
 =?utf-8?B?ZjJOMGxscFhpTkY4U3VuanQybGY5Rklkc1hjMkxMUVJpVUlyYlNnZHlDVzRK?=
 =?utf-8?B?VzhhYndMMWZoR3FPRUpsZ3dpcno3aysyMDBLeDNkUFlQL1hiRmxGOFVQVWU4?=
 =?utf-8?B?ODVxUVRzeWRHKzdUYnp5N0tUcFRidEtrR3owTi9pSTVnZXpFeVRKQWxDbVRJ?=
 =?utf-8?B?VzB2RkpUdzJxOWpmSzNESnRHRjF5NUhqQWVpcDhZYndrcEw2VjAra2F0c1lw?=
 =?utf-8?B?UnphVGtHNS9NOXUwM0ZlQnNXUXhMNGVWdk1qVGZRTTJxOUJpd0xWbWRlK1RY?=
 =?utf-8?B?a2FkZFBxL0NvVi85VWRMQ0Y3SkpZaXZqbTlYZ1luaTFibUJJSzIyb084NFdR?=
 =?utf-8?B?c3lIdmpKSTQ3ZExENEJQSU5hZnhwNnJVTFAwRzU1NXNsa2ZBREZhQjFLVXM4?=
 =?utf-8?B?WVBucGpuSERsK1V2YTBKVHBjVSs5OVQvYklQMW90VjFWMGNtZi9maFlHcUd1?=
 =?utf-8?B?MWFTMkNSYzEzOTRTdWhFakpsQVVXVHU4cCs4WG4rMEFWNVBMeGJiYW1sQzA3?=
 =?utf-8?B?b2NTMURxWDZOZGdkbmV2eGZmTk9QVFA0ZjBrYk1qWVp4TVNmVTJCYlVhQW1O?=
 =?utf-8?B?U2hST2FVN05UUGNTT0ZoVzhPWU9aYVlOdzF6QWRDNjZTRWhXd2p3aUJPc096?=
 =?utf-8?B?TEkzbXlqK0FGdks2dGNORmxzaUtMWm5RWGRicGxiRCtUUjF2eDhsQXpGOVdP?=
 =?utf-8?B?V3ZSUGpYb0haV0RlbGt5WFI4UEtlNStlRDRIdWU5cGVtRHM0bjliajVUd3Jk?=
 =?utf-8?B?cXMwelZKdS9BVGh4QmRNckVxQm83RzRBVWR6SmpxTEt6b21yYjhET1hhbWwr?=
 =?utf-8?B?UjdpMXhVL1dKYnhOMlRUdjhYbEY2d0s5RjBnblRyWThMQmh1TC9ScmkvU25n?=
 =?utf-8?B?UUIyeEJOQlk5TmlvUjBlemhYQll5YlFlK01mZTJOaU82UElHUG9taXUzdjA2?=
 =?utf-8?B?anVrZjlqdTVHV0RIbFlpSzk2MXlrNk94VzlCSVdLODNjaDdGRmRXbXUxenNz?=
 =?utf-8?B?NGpxQ29vaUpZUlNHd3o2RnVBZmwxbGJOMUc0bDlYMG5kYVNRdTY5QjNpN1NM?=
 =?utf-8?B?V3RlZnd4M282TGRQRGUyc0FrM1NJZUtGQ24vcUNtRWNkRGdtdnNQQ2kvbzJ0?=
 =?utf-8?B?MFpaeVgwazZ3TUc4cGMwcFc1S1Nab0c0WlUvMlo0Q2VNaHI1Mzh5YysvUU5Y?=
 =?utf-8?B?TWdZS053MVh3cStwSVdMOFlLOGtNSjh4OHdhdnFnZlJjZlJrRUJEUnZpeTVM?=
 =?utf-8?B?SVBHYlhyQytRQUdFWit0c0doajJlcTdlSmFsdkoyMXZwSE9OTnlOa0dBbVd0?=
 =?utf-8?B?blZuNk9ycDEwYnJ6YUJ0MnphMHpWQXRONGdOUWQrcGRXUm9DRitaRzhEdlls?=
 =?utf-8?B?N3J2enJ5eGdXY3dycVoyYUxaVXdTR2pCSkw4WExuVUlEYXVTRGNkZW1odUtQ?=
 =?utf-8?B?QkpJOXhJUjBON283VDl5SlRpaitHS1B6RTVPZmlWRkxTYmtUNTcyMXY0dE1Y?=
 =?utf-8?B?YzhUMEIwVGs2VVg2bVRxUXJIalRld2dNYWVHbTRQUnRtQU9kRHlvK1Bwejl3?=
 =?utf-8?B?Ym9ZbHJmWGJzc2Z6ZVo4RlhnUTd0ang5NjJxek5qMm9KbGo3czRHcnEwVkxn?=
 =?utf-8?B?TEdPVDhmK3pGVDRhR2orQSt3M05EeUFvandHeGExUjg2VVRld2tTMEx3QkVp?=
 =?utf-8?B?KzBTUVJMakxLR1k4Zm0zUmZpdXliVWhwcXN0aElHak9SNzNieEprbFk0bHA5?=
 =?utf-8?B?cmVrUW1GZ3FEYXZPRnpwTkJuTm5OaGx4MVdPQjNGZHVhYjZTTmdQWlZSY1JY?=
 =?utf-8?B?UXVzYjJvQncwS1d2QkE3cGxFTTZqZUVwbDR5cHlJN1ZFT1VNbmlxUEtzdW56?=
 =?utf-8?B?UHh6OEVBU2QvWmNJTDE3OVJGeXBUWmxyeDdnVFFWWTJTY2NvbmJ5Z2lFMjNL?=
 =?utf-8?B?dGtDYVp6Sy9rdko5V29PWGFKTGZMdmFjV0JuamZjbE5QUlpwUnZKdkZKYUJE?=
 =?utf-8?B?S3RDd0Y2Smk4bTAxeHZKckVNTDJuZW9oYzM0OE9scWpqWFdFRDUrSHo0QzZN?=
 =?utf-8?Q?RFbRhVnPyk1wW1lZcVCVnjsOh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea71f09-e3c0-4d15-418d-08dcd41567aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 16:59:18.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbCEgJeLXSU2HICoprQRRgfocdMPyJo6jp0JppSlkYf7vBTdwGjRTOf5xe4M56Yr8s+6l+L5fyBehX4RGt6I7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8240

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> In SNP guest environment with Secure TSC enabled, unlike other clock
> sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
> handled without causing a VM exit, resulting in minimal overhead and
> jitters. Hence, mark Secure TSC as the only reliable clock source,
> bypassing unstable calibration.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/mm/mem_encrypt_amd.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 86a476a426c2..e9fb5f24703a 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -516,6 +516,10 @@ void __init sme_early_init(void)
>  	 * kernel mapped.
>  	 */
>  	snp_update_svsm_ca();
> +
> +	/* Mark the TSC as reliable when Secure TSC is enabled */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  }
>  
>  void __init mem_encrypt_free_decrypted_mem(void)

