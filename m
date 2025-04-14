Return-Path: <kvm+bounces-43209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D71BEA8778D
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 07:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DDF216F8A5
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 05:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3A51A257D;
	Mon, 14 Apr 2025 05:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YbDSuQuu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5937E9
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 05:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609868; cv=fail; b=DdvReyAT1Iu1zEYxPDN3xAAtHkYYuc1dup8USlOmc8o1T8Hmw+012G2uh2qUtKg9fUMfu6R4UhKA0bZWAlGDQQAGmE6hhwqFM2kl3C+4iihjQMbPlqgqxikElxAdfflif4m+Xm/MP2DUB3193cchIAvybVW5VWERxBNVGo0bL+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609868; c=relaxed/simple;
	bh=nwMYZl4ruVUQlf6x8uMlZfrJQ9DKBdNi1Ymv3VfJ43I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=raJJDA5ayVNgCf99nlb6Qy8r9xsaC0rdMZJc520p4E0vPwpJ6ZT2UsNGpRvmHqfX0po67T9uYbV5PyOK4Fi2qtgJ9RbgAEUhWlVo0ub/Cx8pqgKLxoZpbpTmKFm4n2IH8vwelA9Bt1ADTDx4a4zpmGqfcsqXdrDo3MYrWv0oexc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YbDSuQuu; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1QvoYG0/Q/RPT+hZo6kbNue5kewiK9l3m2jmrevzvkBAmUE6b6LV6Nw+N0sm8pej9mMJXzkju7U7UtO6MiwWV5ABkp+1l/vphAI7seN7oBuAeq1FOLeFCia/eDPtWZurgV1+hLQTpKDilFjMmPcqEUnJpR7GlQ+Jls2yHcM43CS/CZ+XIFa2uOFfUu2nOKqKASeKauWiMj+xw2rvONyE+vk9gYg0ycWVNAUqyfsOuMt+uzjGYQc+x8CRTH3zyuD5/scNBjTeRCR+oiVl79nRfXAiOvYZcuEFhD9jqz98XkD2xxhOyVXLDor10W3yjW8sJHVIH+2HnrhLMZPMo6VbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5053qIQ7KuHm5ouuPhR/Ex0I76Ype764im1ZHWCxJzs=;
 b=iBQA015Dk15/3NnK3SneOYW6HjITA8HCfaKBLFDvKQDbq+4l9oV+GTPRdl56p0lxB/4JuW8dnko5xfAnor3L2BLaq4k9du3r08WaoKToQh469tobSJ7hvSO8L/R5enSgL/ZCjs2f8hfVeBVSUz2jBciAiUkIR6xkvlKvqyLSJAC4LvGSAE8ADHXPywX7NHnOJ6vze4wgOqG2GMerqs41BtarLLVNeRuQjHf2qVYyoWKRQK0P7pYbtsFT5EccT2tr5u2gfAkE/K0TXXnv5q9Qn1B/D+gaCMg7aT0/YPZB1EVeKy8UvU25+h7h02Db3G00939Av/KjyOqw9kw7JiwL6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5053qIQ7KuHm5ouuPhR/Ex0I76Ype764im1ZHWCxJzs=;
 b=YbDSuQuuHuKdR+eiCVW4UWrdKitvPXCSfcgvExHgEgX8YyBLDf3Y5Z9mp99pkR+V8ZsPBMmnE+gsdIdgGTfZnrOL8fQAN0mT3Qx++L+hndbZvQwIX3iTndQqiKQq/ogk1ldMp0n5waQQf3Qd/2W7Z1GOxAx8r/NBAISH2zteb1M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by PH7PR12MB6491.namprd12.prod.outlook.com (2603:10b6:510:1f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Mon, 14 Apr
 2025 05:51:00 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 05:51:00 +0000
Message-ID: <7dd702a3-e9c3-4213-b0b6-799976d4736a@amd.com>
Date: Mon, 14 Apr 2025 11:20:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::11) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|PH7PR12MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: ba0a896d-c22e-44a1-9c28-08dd7b185533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVJJRmVVZ2VPMFhBVXkvelVLWmRYbHo5eEVRUVFaSXpsRjJpSUdvS0JidWdj?=
 =?utf-8?B?bG1pSkVnU293b3BuUStBMkVNc2hMb0xURFo5eUJoMnRWcWo4NWhRUGVPcThx?=
 =?utf-8?B?RVU0U3JmRi94NVBjbUpXZCtKbGV0NkIvMTEweFRFN2s4bmNzWTU1eTRyR2M5?=
 =?utf-8?B?UzUvKzRWTTRZLy9xWUtSK2oxdVYvU0dwcWc0U2wvaTg0VGIwSGdBZEQ5aUt6?=
 =?utf-8?B?TklMazB2NUw0QWZiZDFFQTUwZ0IzaEpaYnZTRTdaQ0UvMmFuN0poRWdKTCsr?=
 =?utf-8?B?cis5NkJ3Tkxzc0tDcnNtaHhQODZ6Q293RUVRRDN6M0YxQkE3MTdUWVNRREda?=
 =?utf-8?B?akF6ZFBlU0JBZGtxYnBjUzRYc3ExTlpoL09neDk0TkZTZWNkUDIvSjZGYkNV?=
 =?utf-8?B?TmdtMEt0UmMrZ1BMWFRDYTNSTStLbC9aeGtXaldIb2pqS0MxNjJra0pTa2JB?=
 =?utf-8?B?aVN4NnhoY3hmb0VGbDh2OVRnSWpxZmg0SzJWa1JPT09xZDFiODlhMzNJMmJV?=
 =?utf-8?B?dzVtdFcvQXRFSGFFUXVoMG95TEZKRG9reDVVRjgra0tTV0pPVjZjNWdRVWVw?=
 =?utf-8?B?VnJiaUoveUFjY0Z1QTIvQTV3QVpIMDNraE1ONHJxVC9lMURjeHhnTHU2WWJl?=
 =?utf-8?B?K0xhbVpVSzIwTVNHdTM2OEkzeUpFS1JWYWRhaENwV0h5OHpEZnpuajlTcjJF?=
 =?utf-8?B?dnVqWUNGMUhUM3JLTkJ0VUNvdm9xcjU1TDQxZ3pMdSszUVpiV2w1ZmxveTZv?=
 =?utf-8?B?Vi8vMVdNNmpWbE5HM1NQWjlrWnJ1b1crSEh1T3RzbXBnQXVPQ2NtOHpZMS9U?=
 =?utf-8?B?YlM4dEIyelkyQWE0dzRLaVo5VjkzRXdvQ0E1WXM1ZVRmZFVHWFZNNG5BeG1N?=
 =?utf-8?B?WE4rdGQ0YktuWlFVSFZNMjY5N0x6U3FRSm8zOGNCbEJBY0lDTU9vaDdvb2lU?=
 =?utf-8?B?elFiQ250U3RvZ2ZpWTRUanBFQzNNMVhlRk5Vc3dnRkhjNENlUit4bEVSdHpH?=
 =?utf-8?B?b3VaZHMxTDdENm1WUHNqWWFjRVlwdTlmS29HSmc2c3JMeHlXVkdKU3lEUmFS?=
 =?utf-8?B?QUlEejk0S2hPVzRjMld5enVqRlpZNm44Y0EvbkJoOEdTYjJCR2FKalBFZDcr?=
 =?utf-8?B?aDFDam1YcWpOSG56TFpTbXZBNGNQNjFLWWJOeVVHa0VLYTVBT29XcnhkcXdi?=
 =?utf-8?B?Z3lLTFBadHB4QmROSFdUeE1kazR0aTFqZDJGdzZqdkg1aUlNRzdRWXp6ZXhl?=
 =?utf-8?B?WEJ0MEY4bHArWDBpWTBZSnkwaEMvby9ZQlVmWkRBb01ZWW9IUnR0L1dOVTg4?=
 =?utf-8?B?ZHgrUWlPRFE1b216NlNmR25qd2d6TDgwQnV5VVdOMXJiOHVieXg2Q01jZHBH?=
 =?utf-8?B?MEpkMHpuZmk0bEFmdSs3QlhzZXBMR2t0d2tkcU1IcmlRSnk5ZFdFOE14UThu?=
 =?utf-8?B?NjRLODE2VFhLMHEzaTZGL2ZUYlpwS3VFMzJpQ0pTRnBRbGdBNVc5d1hrOTVo?=
 =?utf-8?B?N21iRTNEUXl5K1p4ZkFkZ2RiVjAvWStVN2J2VkpOY3p6VkJoRUVMd0h2YTFH?=
 =?utf-8?B?TEE2dG85TFd2Vjc5a1k2T1ozVVRQK1lwZFVFRXhEK2VweGsxTFNVNm9Ub2RY?=
 =?utf-8?B?K2E3TkwvRGFNcU5MMjMwWitnZ3N6T0RpeW1vd3QyenRUUkhrN1luazUyZzY2?=
 =?utf-8?B?NUViWkNRMXIrWEM4SElvZUxxREFuNkYwQXlxV3F5UTlHQWhUM2UzMmtWQ3Yx?=
 =?utf-8?B?SCtwaFMxZUR4VHJzYnd0NE8yTW1Hd3FvY1d3VUIrRUVJQzZ4WVlseXhIYXQy?=
 =?utf-8?B?bUVPVGZ2ekJNZ001LzlJTCsxaFhJZWpWRUIvM09wOHlRbkNtZmdSYlNkOCtk?=
 =?utf-8?B?UlYyMVlIS0NBYm5DV2x2bTh3ZE9qcFJIaUpVd09mWW03dTNjUVNZTnJDVkpC?=
 =?utf-8?Q?cjGgLADqedY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0U5SktHRTRlL0RLWmxlakRTbFQ0dzZNLy9GRUtXcnJ4RTd2R1FLM1ZCYmtI?=
 =?utf-8?B?OWJqdVQxRmdiYmlscncyWjdsQkIrTTVFcFIvV2ZVUzJmZTBPVVpMWllwUER5?=
 =?utf-8?B?MUx2QTNSd2FUWExqZDFjM25tdmV5QmVyVVhrYndYd202amtIYm0yZHZIVzVJ?=
 =?utf-8?B?UFpEbm1QcldUMXpjVVZLclVHQWYxTkFBaDg3a0Qxa3Y2YkZkVkNzWGFtSVE2?=
 =?utf-8?B?TjY1VFFLRVdJUVFvMExFcXUrZTJzbUZnTFFwTG8zMU8vd043MlAyMm42cXZl?=
 =?utf-8?B?YnZON3E0b2ZVMEVla3dBS0VzNDNjRzFVRHhYSTBqVlE1TWdGQ3hxQ1hPZGpU?=
 =?utf-8?B?a1ZtWUFqczVBczdSejRPanJxWXdGT3YyS1BqMVJJazNSclBxcEJldXFUeU4y?=
 =?utf-8?B?VEkvY0JiTGFvY1o4SjQ5d1ZUeUEwRjROME1tZjZMRERyVWJaT2xMZHVaNFVC?=
 =?utf-8?B?dGRYRkNkZHo2QlZzcmhKeUZsc1Z4QmpVN000Zy8wTGR3VGl3ZllvbDh3dHV5?=
 =?utf-8?B?cmt4VERZWnlmb3lZRzRrNHhuMXNQcmNzaGNNVS9WY1FiM0ROQVNRT1JHWkRt?=
 =?utf-8?B?R3ZaSWdsUHJGSkpWemVsZnFCLzRsQTJNalgxakFzVFM1NGRjaUhzUzVkUVYy?=
 =?utf-8?B?VGErVk9yaXlRR0w2NzZlUkJ3dzU2eDBHZnZ2WWJWOUMxejFjNU5uMzR6ZjZ3?=
 =?utf-8?B?TmRrcFBRQnJNeUxKQ0p3NDJCWDZmNHhHbnhxRmZXYVJhK3c4eVNNWlZENDBv?=
 =?utf-8?B?N05rSHd6L2hIMVFVSXVGaFlyT2NQK0FtN1VlRXVkZTVDMUhOQm44d3pGU0hY?=
 =?utf-8?B?MXBXL1RibW1rMy9hVnJoVHdqU1FZVyt0Si9keCtUMVJBSFVPT3pyOUQwRity?=
 =?utf-8?B?Zm0xZHF4SG5RRzQ5NHBXQngwK2FMOTN3dlo5bjk1d09NTHNCMUIzWjhpb1Jp?=
 =?utf-8?B?SUNqek1ReTVlM1kzWUptT2k5dlN0cEpJTG1LRDZyY25Mcy9UMG1Id3U5VHYv?=
 =?utf-8?B?RWZTNnVqcm55TkdiekRwUitIVUJ2S1BzRlB2dzcvYnpaalgvYy9iSVBBWW5W?=
 =?utf-8?B?ZUJnNDl2aUwrTHRpL3VRQmVxc1dOY1hmdnZsdWE0SmRtOXdZcnJNY1lQQVVG?=
 =?utf-8?B?eHREZlZjUHIxdEY5SFZ6WUNncXF5R01sMThERW1OT2lMVGN3OFp4WExjV2JB?=
 =?utf-8?B?THJRRjdOTThMazB5aVdhMnFUTyt0aGVVVy9RblBMZkdHeDR2ZWEvczI0UzFo?=
 =?utf-8?B?cDVDS3dvYUlua1VQRkRmbnBKQVRKb2Q5MTFvYURvSmM0QkpKTFg0dzdqRmx4?=
 =?utf-8?B?VVkzT2lRaU8ydWhvS2RBcGd4bi9vN3Y3emE4ME80MEtYU0lRU0R5eDdBVXZC?=
 =?utf-8?B?aTFRcFZua1llWGZya0JXUEh5aGRBcnNtV0FWMnNiOHJnclJ0ODhEajlLemRU?=
 =?utf-8?B?Rzd4b3VjZUxEb2RhVFcwZVdGclRONXg3cS9sQlZ3aHMvVW9ORTdIUzRVSjFP?=
 =?utf-8?B?c0ZkU3VrK3B4Zi81Z1E4dk9KanpuR2xaNFZlc1RmemtyV0dKaVN5aS9kOGVN?=
 =?utf-8?B?UUNBdE5jeE1MeUhHM3d0RHFoYkZsSGxwSWJlc0Z6cE15T3hnMVpObENpTUlQ?=
 =?utf-8?B?UkJNcWdKN3J1OW9sNHRxdUV5TnNaa3VRclBoR0lFeHBha0l2Ym43cHAxQVNR?=
 =?utf-8?B?aEt1U3BMcDlSemJaWGVJRENyNWorZlpDU1RvMEhnbVpUUklHbmlGN2tPUTF4?=
 =?utf-8?B?WXVzRTQyRjlUTWE5eEhTWTBERDFDT0JoZmFlZzN2K2d6YXNJU0kyWkpveit4?=
 =?utf-8?B?Y0Q0OGIvRkh4OXZZV1ZkRG5lQ2o4ODNycy9TSmZHNE9zM3NwTFlMbXQrdDh5?=
 =?utf-8?B?YWQwL1NmeWRUNXZrZGVLUkRqNEhrTjhETXg1UU1sL2JFb1dpQWpsZVZhYU5w?=
 =?utf-8?B?UzltUGdNenFkSVR6NXRidVV0T3pGemY1bUkxNURZWHBwaTZVZGIwaGF0TURv?=
 =?utf-8?B?RkJPcGJBcGpZWlFzV2grM1RsZEpWRHdtRkxBYzJtQTM0VDM5SnkyNHV4azZD?=
 =?utf-8?B?N0Njam9SVXlXNnRkNmtPWGpwSWJXVEdpYm1ZZzZiSTVXR0dKK0hiQTZDYXp0?=
 =?utf-8?Q?tKwZ7Y/sU0tsMVK+1FAqLnB+a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0a896d-c22e-44a1-9c28-08dd7b185533
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 05:51:00.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VB0MClW09rTAaZEi1ox2tnZ9McvYmYEUKtCPkdkczjODX2Z6SxWAOk96IXfbOLD8mll8mXphukP6pm+r03KIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6491

On 4/8/2025 3:02 PM, Nikunj A Dadhania wrote:
> The hypervisor controls TSC value calculations for the guest. A malicious
> hypervisor can prevent the guest from progressing. The Secure TSC feature for
> SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
> ensures the guest has a consistent view of time and prevents a malicious
> hypervisor from manipulating time, such as making it appear to move backward or
> advance too quickly. For more details, refer to the "Secure Nested Paging
> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
> 
> This patch set is also available at:
> 
>   https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
> 
> and is based on kvm/master
> 
> Testing Secure TSC
> -----------------
> 
> Secure TSC guest patches are available as part of v6.14-rc1.
> 
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
> 
> QEMU command line SEV-SNP with Secure TSC:
> 
>   qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>     -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>     ...
> 
> Changelog:
> ----------
> v6:
> * Rebased on top of kvm/master
> * Collected Reviewed-by/Tested-by
> * s/svm->vcpu/vcpu/ in snp_launch_update_vmsa() as vcpu pointer is already available (Tom)
> * Simplify assignment of guest_protected_tsc (Tom)

A gentle reminder, any other suggestions/improvement ?

Regards
Nikunj

