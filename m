Return-Path: <kvm+bounces-31270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8762A9C1DA6
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA0C91C22E66
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4671EB9F5;
	Fri,  8 Nov 2024 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gtfh1brq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E631E909E
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 13:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731071372; cv=fail; b=jvvTuOn5DcKJHW56AfZfs41VxYFtzfvY1VrVeM7x5pP9svxOUdDu320sAuuTUCi1ufr/aQu8uzuMwWgkBd39iBZdSX1ztzQn4nuWI3EnZTFVnzo+FGpapgNI9WYurO6n46Zan9cxZCUPSaCQFGeWxn8LDsq4+0khUd/g1ekytTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731071372; c=relaxed/simple;
	bh=d4Bq+Vc2WlU1C5wv11cONoslP4QxzbcDCTk4YJSxHBw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMn374s+q/h1+CVOgMGCiYCk9ZwmQ5XgRRKuAuIcmDKdEnGKJJjAZYux9Y9xKd7R7epyXKb5tMdlpbAz6L3USN+9M6AbylCrw43kJ6c4D59mwnzjTNLzPgYHxUF6a7o+54ChOH57yT1WG6h0X+ktIB34f3mS7bDdhLIZoN26iF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gtfh1brq; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSl1QpIMyg0j/K3pi3/XgXHZu9kFqiHzYyg8bzQQvPVFvM9Zis0yzEAgVBeG8YMuz62VTloBOFKArNTvjECJmzjb69aT2OqAiOsXVKL29M6HrZGP/7bycfYvBGSNYjpIBsaodpCdwzKOm8Ug3pZs9Nph/a9nAHAN+Aph3Nku0xNLAn99DHOhJP69XpLN7M08egHuK02Z4RrsYOl/+Y4D8zQwe7n/aHdskiSFkoBAfbDq2HV1eCaYC8TO5rVHRhUJSqAn5i4+5MOsjjcBggL77S6uqceG5W0+6pMqq/wTdTe2Vwo5StUSP+0WrIryUwgidVem/ShSZs4crjHpHobL+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ietir5NQ89GqBuUU3MdDZdlob8s6/DbThdQ9K3BJ37c=;
 b=fvE3ceH/S87FwkKcCXZyiClg5n4iXxwlkwFLogZGFBVdPg5Z74QZAlnwW21Kko3CLNq4iRkWxNs5MVXPWC8NFPYNCfl7Us4hhTGQ0YQlxKr6di5x6TbTGooakew0vTNwyLhyE5zFiigIYZ6spbv+iGfAAi+x6A9XX5K4UhmrhSVROdxHE79b6ptO2QdkZ6PFHvtZaNcNtS71D4ykj4AWMnDso40eW6WtgakbS4U00YIyPc4LoeMfCQ5LddqW7GBMniWAmuzFCgqrk+u7cJ8J3qDyIWzmM1Nl9jz8gbsfSTZlqCF8OyRplGj0VSGquTu+e9CwijROg/8Fga/6rfWtAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ietir5NQ89GqBuUU3MdDZdlob8s6/DbThdQ9K3BJ37c=;
 b=gtfh1brqEulI0n2Grm1UjsKoPcO8abzgLNBoGqP+EqLXE9jJS67XHxbbIXlswUoWfntaHvkNAe0u4pgyp4teiIUlZSHrB9wOjwaIYqybzN6dbjWqjk8TYMGH67yHwwk1tE9PLCuaB1izgZ6Wee5noqTvlxfkhwr2S2roj5/TvCg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 13:09:26 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 13:09:26 +0000
Message-ID: <2b9766eb-9181-4d11-a00f-770cef63bf10@amd.com>
Date: Fri, 8 Nov 2024 18:39:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] target/i386/kvm: support perfmon-v2 for reset
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, babu.moger@amd.com, zhao1.liu@intel.com,
 likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
 groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
 davydov-max@yandex-team.ru
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-7-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20241104094119.4131-7-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MW6PR12MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: cdfe7e40-1230-4fb4-32fd-08dcfff69277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWwzRG5ONS9aMWNBelRueWlPNzhRZlBDanpMc21XcTdVdGdBNTNpMjBLek5Y?=
 =?utf-8?B?TUhXVjY4enZYOEFnaXEvMW5JME9TOWErWFJKdjBIZ1JuMHJOV1d0TEhXd2pO?=
 =?utf-8?B?eW94cVErOGtLTTY2T1Jxd2xhTW5waWJOTDd4c1BaODI5K3Z5R3EvZWN0ck5N?=
 =?utf-8?B?M0F1dWJGMTVOenlpcGxJZTRENUZLaFVyMEtSSlEwbnJxYVdndzdYRmJxd1Z5?=
 =?utf-8?B?S0xjUWl1OGVtYUEyOXZDcjJDTTFIUEVINHY5TDlHU1ZzMjA5VHNMR0FVdTVS?=
 =?utf-8?B?MkJkeUo4NkpUakNuTzY0Qm8reG44L1NxbXFldWRnNU5zZlMvMHZZODVicysz?=
 =?utf-8?B?ZjVkTm8wSnJEODFKL3pvSVI1SmUxT2xRS1BKSXdPcmFKU2JFUEdIakFBeG9H?=
 =?utf-8?B?Y3dXSUVFNVFpSk4rTTVNUGZwSHJNZjRMS1ZFb01ZT2pEVnRTVC9MQlFLYkIy?=
 =?utf-8?B?ejN1TVpPSmpQL2ZUMTlhSUdLMzN3bGNqRy92b0QwcmxWbVJtdDlEbVg3YndB?=
 =?utf-8?B?c0N6MU0xUTI4YlVnS0VTaElOK3Nodlh0dXAybk5YakdTenpJNTJUQ01zem1T?=
 =?utf-8?B?TWR3SXIyVllobkZRZklEWGs0TDlrRzhJTWdOSWxQWnIxTkF2MFkramVVa1N6?=
 =?utf-8?B?L29DaFhFTXQ3RmZWWDVvNUNwWElhUzZsNitxdng4VkJhMldwRGl0SzJsQ001?=
 =?utf-8?B?YWxFemF4aWY4dnpOUEdOejJiMFlQTG14amI1Y0Fwc3Q3bFFrcXI2OTQ1dnd6?=
 =?utf-8?B?bGpFZ3lyUGM5akM1L2VpRVBKVHVCUlRyMzd1d1RmRGc2M0w5N0tZcTRxQnhH?=
 =?utf-8?B?M0NLcFlLSzR4eWxmVkI5bXoxRTJNSHJ6SU5LdE9ObnpBVHVHM3lUVGsxSC8z?=
 =?utf-8?B?VVpYOXpGV0I4UmM4S3E0SFVUTHRnalN4YmcvaGNvL1h0ZWdMazk1QU1WM0VM?=
 =?utf-8?B?S0hqWitZWUVYaitDYnJxWW1qTUQwb2dHcFBITnNFL3hnYzBYZFJMZG42RWEx?=
 =?utf-8?B?cmtURmsrUjJ4MUhhUlVRT0J0K2VSTmZya2pTT3VKei83bVdPWlF4TmNpUVMx?=
 =?utf-8?B?YkNKNURLenNUb0lMbUppeHNzd1VYdldDSkhoMVZzMmJYWWlZMlk5Y2U5cys4?=
 =?utf-8?B?dys4NWVlb1FHeTQxcFp2bEdxdUE3bGJiSGh1R0NaMm9JUmU2WFpDcWZtRk16?=
 =?utf-8?B?d3NweWwyWDhieVVYMjJjK0hENVlkUUozbU82elJSUkEzaDlmb1pCSlZEMFdV?=
 =?utf-8?B?QktMdE53U2JHMHNvTHhoWnROZWZsYjVYUVJ4NjBnczlLSVR0Sy92aGNwc1ZG?=
 =?utf-8?B?dnlON2MwMS9jMGJlUm1JazFvNk01bXAvUTRlMzZHa0tzNmlSY0YxaDR1RWpl?=
 =?utf-8?B?NjUxSGVVbFRPV0VCaklLL2NzMGlzZjQvL3ZjeklyMWFwRjRLZWJFRDAvQTg4?=
 =?utf-8?B?a05DR01wTmRFd1UvU1l2dTJOZk9EOWRZNUxKSWVhSnZxaVp2YWJSWkhkcld6?=
 =?utf-8?B?T09WQUlpMlBrQ2Y2R0hUQ3RaK0NkTWsxR3dhd1hydTkwZ1k4eEpMNUNHNldQ?=
 =?utf-8?B?UW1mV29hRTJmNGJma04yd2Z3NERkZlpJNk90QkJ0NWI4OEtKRnY3SE1XZjRR?=
 =?utf-8?B?OCtkVFh3T2NzdFY1TEEzNWxUZ3JNcDMvSllEQ0dzTUk4aXdzVW9WTnJ0bnp1?=
 =?utf-8?B?R2tYTUw0TnhrdWc0N1Q4R2NoUk14eXBidllCM3F3TTRFSjBSSHRiQUQvaTVu?=
 =?utf-8?Q?loK1QRKNXpijpOh1V4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amlPSUdLOGEySHY5YXNjcFNvY0gyc3ZmVW83TGNYbnVERnhPaW8xZmlsRGQ4?=
 =?utf-8?B?bzh5Z3l0cHV2dm9rZkMyMG1EZEk5aUtMUjlSWnUxaWhsd3dJMDJjL2JzbmJo?=
 =?utf-8?B?ZDJRRUxUdnNCMGlMYVc0UnJJU0NBTzBLKzBYWmRpSHpaa2tubkJqckxubDh1?=
 =?utf-8?B?Y3lyekUyMjJFSWtRVlU4RWErRVg3eGM1eGM2SEpSV2l3S3VKcVhEYjd6d05h?=
 =?utf-8?B?Z3ZSdUljOG9LME5MRThTcmdvTjNBWXdyVlNXcjZRVUt5b1l1L1BobTNOVDE5?=
 =?utf-8?B?dlVmVWcyZkV2UUNLOHNiZG44d1pDd1J1RFNNQjBicjdVNnlPNGdIcDBiYzR3?=
 =?utf-8?B?djcyZ0t3cFA2QUMvWGdkUmZLaldBdTltQWUxNkpITGtjU01iUkl1NUFVR2d0?=
 =?utf-8?B?RkNqdkR5UDhWU1dteXJkZXJTTE5oR2I2M2dpRmtLRUZPN0tXTDBUc0xxY0FU?=
 =?utf-8?B?aXRqSThUb0RxZFZ1QlJFY2MwWTl0TUhjTmV0Vmk1b09qOXl4YmRHNE9DR3di?=
 =?utf-8?B?dWdhTXdVTks3eDI0RDRUQ0w0Z1pyM0N1dm80Tmh3c1RDRk9xeEdXNXcvbWd4?=
 =?utf-8?B?RFRrUCtoeHdEU1p4T21CdXE2QjYvcmVsSElTa24wdnFDZFRRWUpQY2dIV2tn?=
 =?utf-8?B?cjRMS3RHOUlSdlEyOXFPbG1iZ0IzSWYvZ2VQYy9HSEhNd2dkdG5xOG1QcVcw?=
 =?utf-8?B?cFVMSHdsMHg2azRhbWhZTkZUMkVyR1RuRGJvMitsYjFseVRUYjRva0ZDNEt3?=
 =?utf-8?B?d2Z1QmQrVS9HaFdveGtKSmhYdWpZTGFLY1haTXNaRXVqY2xsTWhSRzZtQysv?=
 =?utf-8?B?WWZyK0tUL25NWUNITnRzVi9uNG0rNUttNzNROG5xaEluRW4vaUh5cmFPeExW?=
 =?utf-8?B?WjdOMEZGWkZyV0VQSVloNkhoQUEzVlNicEV1YjNWTTBYUW1FR2dHVXhNcDVE?=
 =?utf-8?B?ZllieFFlWGs5T2ZvNXR3M3RCQWdqa05VR0VmRXk2RGx1Y2J5YWJBbURQc0FS?=
 =?utf-8?B?RDhEUE4zd0JlOXh3cm13cjNlV2MwaUpLbDBQK3RUblNoZVUwV3lOSXVwenNM?=
 =?utf-8?B?ZmR6TzJQN0prdUdpbmNnYVJkdGJpUVA1eVZ6OUptN2RBdWt5NWhFaVg2a2d4?=
 =?utf-8?B?QWVNS28vZlhqZThwWnNkS1Q4NFVRRzJ0TW1XQk1aVzcyeG4wa3lDUFIwNEp0?=
 =?utf-8?B?TEk0eURZMmJ3UkVQZUg0N1N3QzBJZ1JVcjdPVGt1aWV1SVhxcS9LWVJRSWZM?=
 =?utf-8?B?ZjV2RW14N0lKeEVTTnJZRHpDRUZLcE1CT01uRDN0T1VLM3h0RkdqTkY0eldk?=
 =?utf-8?B?TndteTl4ME1ocUVWUHErWHRFajViMXdZVzhmNjBRZGNHMitkZUFqNThpL0ho?=
 =?utf-8?B?QmJqUFQ0a1R2ZzByUmltSDNETjZ4RWJkQzB3bkxqOXFwSWR0U014cDI5cjlv?=
 =?utf-8?B?bno5OGpOWGl1QU9qWHVkQzVtcytJT1J0V2EvYloyYUQ0cTQ4R2ZLWXduQnhS?=
 =?utf-8?B?V0xGM3VsSHc5NytNSlQ0NVBFYkhXZWIrencwcXJaNm1UQW85bmhXeC9zMnc3?=
 =?utf-8?B?MUZ4YTd5UWYrL21xOWNzblFZQVdFdFNKKzBVbDBUbnRpbm5MdElZMUh1Ymwr?=
 =?utf-8?B?MERveEhZTklUZ1lBd0dvOE9xRW8rTGpLV1JwMHg5ZWlZa05icWlGUklmZWE0?=
 =?utf-8?B?ZUFvaVo5b0FneEUrK2NLdm5TRDdyc2lPZ2J2bGlKb1NaUlVUZE1tSE1Pdnl2?=
 =?utf-8?B?RUVHaG81R0hyd2p2c2NmMGNveS9BOFROUzgvVCs2cmE0T3JsbHV6UTgwejFj?=
 =?utf-8?B?dXh1RU9wZ09MQjUzRTlqZ3NENVBsR3VLMGNpNmFhZGNXZzJxcHkxYlA4dGxy?=
 =?utf-8?B?SXVDakpBOGNMQmZ4V3VtZmp4Y1RDWXVyMHRVeTVXRFV0VHFJVklIM3pRKy8w?=
 =?utf-8?B?VnhjdnRLbzJuNkpWeVVDaHYvY3EvbEVRVXhUL1JZc0xFNnlEQkpiZ2t1NXc3?=
 =?utf-8?B?RlNRVGR4YXRzck5PODdWblcyRzNlQlBSQjJwdnBFVENvQXdPUkdzTERWYUNK?=
 =?utf-8?B?ZGNHaXo2NWhZWnNwdk1aTjdTa3h2L2ZQR0RzVm1CUGplUUNRbnVzR1Zka2ZV?=
 =?utf-8?Q?THpSyTQdlOwd8OUp2BSiRRKQx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfe7e40-1230-4fb4-32fd-08dcfff69277
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 13:09:26.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwVlZlhJDjpWMdLzAUDgpaVbg4Ek4k3fC6LzjjY/TlfX5nJ0PWb5iipHELXKhlYt5LwF74t3xoj0K9oUoXEETQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916

On 11/4/2024 3:10 PM, Dongli Zhang wrote:
> Since perfmon-v2, the AMD PMU supports additional registers. This update
> includes get/put functionality for these extra registers.
> 
> Similar to the implementation in KVM:
> 
> - MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
> use env->msr_global_status.
> - MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
> env->msr_global_ctrl.
> - MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
> both use env->msr_global_ovf_ctrl.
> 
> No changes are needed for vmstate_msr_architectural_pmu or
> pmu_enable_needed().
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/cpu.h     |  4 ++++
>  target/i386/kvm/kvm.c | 47 ++++++++++++++++++++++++++++++++++---------
>  2 files changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 0505eb3b08..68ed798808 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -488,6 +488,10 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS       0xc0000300
> +#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL          0xc0000301
> +#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR   0xc0000302
> +
>  #define MSR_K7_EVNTSEL0                 0xc0010000
>  #define MSR_K7_PERFCTR0                 0xc0010004
>  #define MSR_F15H_PERF_CTL0              0xc0010200
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 83ec85a9b9..918dcb61fe 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2074,6 +2074,8 @@ static void kvm_init_pmu_info_intel(CPUX86State *env)
>  
>  static void kvm_init_pmu_info_amd(CPUX86State *env)
>  {
> +    uint32_t eax, ebx;
> +    uint32_t unused;
>      int64_t family;
>  
>      has_pmu_version = 0;
> @@ -2102,6 +2104,13 @@ static void kvm_init_pmu_info_amd(CPUX86State *env)
>      }
>  
>      num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +
> +    cpu_x86_cpuid(env, 0x80000022, 0, &eax, &ebx, &unused, &unused);
> +
> +    if (eax & CPUID_8000_0022_EAX_PERFMON_V2) {
> +        has_pmu_version = 2;
> +        num_pmu_gp_counters = ebx & 0xf;
> +    }
>  }
>  
>  static bool is_same_vendor(CPUX86State *env)
> @@ -4144,13 +4153,14 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              uint32_t step = 1;
>  
>              /*
> -             * When PERFCORE is enabled, AMD PMU uses a separate set of
> -             * addresses for the selector and counter registers.
> -             * Additionally, the address of the next selector or counter
> -             * register is determined by incrementing the address of the
> -             * current register by two.
> +             * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a
> +             * separate set of addresses for the selector and counter
> +             * registers. Additionally, the address of the next selector or
> +             * counter register is determined by incrementing the address
> +             * of the current register by two.
>               */
> -            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
> +                has_pmu_version == 2) {

Future PMU versions are expected to be backwards compatible. So it may be
better to look for has_pmu_version > 1.

>                  sel_base = MSR_F15H_PERF_CTL0;
>                  ctr_base = MSR_F15H_PERF_CTR0;
>                  step = 2;
> @@ -4162,6 +4172,15 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                  kvm_msr_entry_add(cpu, sel_base + i * step,
>                                    env->msr_gp_evtsel[i]);
>              }
> +
> +            if (has_pmu_version == 2) {
> +                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
> +                                  env->msr_global_status);
> +                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
> +                                  env->msr_global_ovf_ctrl);
> +                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
> +                                  env->msr_global_ctrl);
> +            }
>          }
>  
>          /*
> @@ -4637,13 +4656,14 @@ static int kvm_get_msrs(X86CPU *cpu)
>          uint32_t step = 1;
>  
>          /*
> -         * When PERFCORE is enabled, AMD PMU uses a separate set of
> -         * addresses for the selector and counter registers.
> +         * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a separate
> +         * set of addresses for the selector and counter registers.
>           * Additionally, the address of the next selector or counter
>           * register is determined by incrementing the address of the
>           * current register by two.
>           */
> -        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
> +            has_pmu_version == 2) {
>              sel_base = MSR_F15H_PERF_CTL0;
>              ctr_base = MSR_F15H_PERF_CTR0;
>              step = 2;
> @@ -4653,6 +4673,12 @@ static int kvm_get_msrs(X86CPU *cpu)
>              kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
>              kvm_msr_entry_add(cpu, sel_base + i * step, 0);
>          }
> +
> +        if (has_pmu_version == 2) {
> +            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
> +            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
> +            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0);
> +        }
>      }
>  
>      if (env->mcg_cap) {
> @@ -4949,12 +4975,15 @@ static int kvm_get_msrs(X86CPU *cpu)
>              env->msr_fixed_ctr_ctrl = msrs[i].data;
>              break;
>          case MSR_CORE_PERF_GLOBAL_CTRL:
> +        case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
>              env->msr_global_ctrl = msrs[i].data;
>              break;
>          case MSR_CORE_PERF_GLOBAL_STATUS:
> +        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>              env->msr_global_status = msrs[i].data;
>              break;
>          case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
>              env->msr_global_ovf_ctrl = msrs[i].data;
>              break;
>          case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:


