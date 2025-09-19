Return-Path: <kvm+bounces-58196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C60B6B8B459
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B80A97BF924
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D532BEC5E;
	Fri, 19 Sep 2025 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Nh1KrAN"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737BB1D54D8;
	Fri, 19 Sep 2025 21:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315953; cv=fail; b=Q+cSpxZ4kc0+RX3tgRRsuwfDMlrJySCrlLbZXLhfKVhbX9MDjoO+a96O+wUfALE61LltvxrbsWt/1ruG4YeGY3dqsWMY/wBbogTbGEcM9tuvPchwONLDwnHNeJ/9TL1XmvW3u8cVoGJ26VcyKtwnphYVuOFtLgdyy0Xt+gtsQxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315953; c=relaxed/simple;
	bh=afQSqaDujHl//Z+bu31cJ5z12S2YumDgNYzTEhsIJm0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kNPB3SIv2enuijXSf7gPBiRrhf3LikjNHxeAbwNpa45e4nI9oDMdIQH0Qaeg1eA/z2KjAzk4+PeH0HTpxmYsd9ZkkNp2yhJ2usv+1dp8kuIaWe6Srn/60Jmx3Jkdm+Wql5Uv2sor5/817ZkXmwgYAfild6B/uMdxNMAWHOLC1dA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Nh1KrAN; arc=fail smtp.client-ip=52.101.52.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yamAmFupBhZbxYOkzyfUzJK/co/bO7ksa7yDFa/JwK2sn9XXKVIMRJCriJzj62NzrCdT73P2YVdo7lmr4az3Z4XcQXomaWNw8n0vbu2OpV4rAhiXZlPXesFRDwLn9c++Qa9neiL/2hn7gMbxmg56pDwps6VFNuaHqxKXBhL3oO2kgt1uhvnpNAym/uZwTp3Qgbc8wqAXJugpO6ZTrB/RthqxOGxBZC1UhO02eexkqueA7ThgkGUv7qg16BlFEMmi+j6Cohu83Jhj4/GGXSl/nHEiW6sJcs1XTgPW+ZJ4Wl+BgBt/wH9r//0RjvH09vQNWykqII1LFY0/APsAfJUiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8uMS2kxILjRnn0ksvveorukheqJM6rSmgzAYMhg5UM=;
 b=dWcieUsK8W5+XXBp+E6bue3mzFkMOw42kSSM92mfp6ABo1iG/y322vu9bPavdAu1cijupnZ97vMBwfIVLOdplPk8EWVWgK6Ih8VwGJS9zujl/6p13jN/buvNF9BLnXkJaldOwwZIf0lXdtN4hcXVqGNgaumSHUlr8NzDUuJtrePLqgUScbKxlBN3Nf0+1RgAHuuQOFXaM7bDUdz7K/5pjFoawd3LP1wusttYRcXMKQRowW5DwL7BqajgTD5+RXSod00qV3ju7EdD5+Oy2Pg2Rs/9H7mrsEijYeB7G/5lU3io21gRNaPoDrw7ei2XKvtIbB76WEosN02swtwfZ7xoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8uMS2kxILjRnn0ksvveorukheqJM6rSmgzAYMhg5UM=;
 b=4Nh1KrANDhnswShoLuNO1BYxSLV3XahvSEG92/MZcb5RGJPhYC+pDfwjMg7qYzRbtqsqqOuZUeIWmhgFJYzwZmEAGb5XpQBlEUNCKcJPiHjU/ZOBq0/PEYZNOhVdksA0esHzI8g3NVuTG4d2l0T9pxT6AZuDzed2/4E57xjWbGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by LV3PR12MB9096.namprd12.prod.outlook.com
 (2603:10b6:408:198::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 21:05:48 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 21:05:48 +0000
Message-ID: <fe8138c4-e9a0-4df7-988b-f31d75201280@amd.com>
Date: Fri, 19 Sep 2025 16:05:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/10] fs/resctrl: Update bit_usage to reflect io_alloc
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <549a772b83461fb4cb7b6e8dabc60724cbe96ad0.1756851697.git.babu.moger@amd.com>
 <79b2d040-a3e6-40db-b545-bb07d42c8c29@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <79b2d040-a3e6-40db-b545-bb07d42c8c29@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::28) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|LV3PR12MB9096:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de24b84-4ee8-42e2-3822-08ddf7c04eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWlyYzVQb2Y1REVUSU9kRzh4VlJZRDNZbUl6T2p0RHVLaFFvVW5aVUllSEdx?=
 =?utf-8?B?UDdnc2YxTmllay9mbEo4VzhXVXgyS3RmUklUK3dBanpINTVPYTVMWUJPdUlM?=
 =?utf-8?B?UG53Z0dqR2dhVjVvR3QwMDR2TXZpdVlnSkdIZGZhUmZvNUxnMVhCamIxK1dk?=
 =?utf-8?B?NGZETG45bmFnNFNjNHhNU3VjMGEwMkV5QXpXS3JtdGgzbnArTnpBdEdGUE5x?=
 =?utf-8?B?eS80Z3ZnSVFiM1Z0WnMzTmlMKzVmUUh4K1pRSTVlU2Jld2RjMmszcHBxaXFJ?=
 =?utf-8?B?WjZTWWVVNmhoNDloeUxsWU44aFE0N3hEZXpOUFI5dUdrL2hQbzk5Y205OUll?=
 =?utf-8?B?T29QQWtsdWZLK1Zpbm9oeUszU0o2MU51YllpQ0NBakNzaVp4RXZKWTlqdlB5?=
 =?utf-8?B?bFBQc2Z4OGt2NWw5dmNrdVo3aWREOFE2QWwweUttNWNHb2lWSWoxSXJHVGN5?=
 =?utf-8?B?ckJFUGw0KzY2cmNhenluWXRZT0Q0VGwrZkNMOXZhUU9XSmxvdlc3cmY4TlB6?=
 =?utf-8?B?NTlQS0lxSGwrRTdHeXVQdnpVV01EZit1RitNUXNIZHBMWlJMTkdGY0ZOOHor?=
 =?utf-8?B?TlhHVElIbTlQa0lnYVRTTFJnUjc4L2xFeUZ4SGF0UDdCdHE2cHViQ0ZPZDRr?=
 =?utf-8?B?QVFqQUxpeE5hZ1R1d0M4RmIwZU12aDJVcXpHMDBwTEJaZ0kySUh3U29ndTkv?=
 =?utf-8?B?bk10alhqbm9Oa2NMR3RpTFRkVFFncTdvVWRkdGJqMVlNYTVVVXJMamorZ2w5?=
 =?utf-8?B?Z0lXS09EVTdrOHQzeHZsUHVraXd5ZjJsV1VQeTg2UkRUcnpYbXZvcGNZc3kw?=
 =?utf-8?B?ZkpvSXN5SS9LUmhzYTRnM0hCNzJIOVEwaHhTMWpBQ2xUN0ZjLzBNNnJiTHpq?=
 =?utf-8?B?UjIrRjEvNzJjbU1pWWhUUkViV0NRLzl3dzJrUGU3b0I0bkRVYTVmRDZIeitj?=
 =?utf-8?B?YUg5eTN6Vk9mditLSGsvQVluWDhLY2VFTy9nLzlOSmdsMVBCM3VkT3ZTa2pP?=
 =?utf-8?B?MFd6Uk1FUEpab21BVC8zL0tuVWVTWlhrY3VYYUpQYm0reC9QMTBVTmUwU09W?=
 =?utf-8?B?M3orWWEyZzhyazkzU09Pald5UnZiVjRUQ01WQWFMSThpOXZNeHBQUWcrTWNk?=
 =?utf-8?B?KzdzTTJuRjBVRE1aNE9hbHNqdm9sV1VQRDdYL2hTd2RydjY5aXRFU1g1WG00?=
 =?utf-8?B?dllZQWxMVGwvS1hPUnZjOXFSb1JxdEE3RGhqSnBoNjRxSG94cEx5RzZVbitv?=
 =?utf-8?B?L1p5czErRmE4YXU1RS9sQ2NQZHlDVGFPQ1NhVytDd2FaOEJ3dENMTTFxT0lQ?=
 =?utf-8?B?TVJuRmVMQzIyVVBPQmw3cEZSWC9iNU1tVHlyWjFtWHZxTHN2d3ZiUWh4Qktj?=
 =?utf-8?B?Q3hhZ1RaWmdEcS9kcXZicjY0KytCeWwxdDY5OTFyYXUxNXB0eTRMNVZkM1dE?=
 =?utf-8?B?UEx4NXZCVWkwTTlRbVR5bVFDVXhCZTVtNEZPMkVmZE54V3ZJcVJuaWdsRGN6?=
 =?utf-8?B?NlRYVWdtMnVZZXM0dVZCVG0xR0V2cldlaUg5b1ptSndFT2lxNnNac0dXZnhE?=
 =?utf-8?B?TWd2bnp1OEVaVDlkSzNyVThvS2RweHRkcUJ3SEFQdWgvdEQ0OEIwNTFyaERF?=
 =?utf-8?B?V2N4alBXb2l3M3IvYmJuVkVyaHNKYUh2Z1RuMTVVSUhaYjlWdjZLU3dFZWRX?=
 =?utf-8?B?OTZaM3kyam44cGxYMnNMMk9JcnlxYkxUMXYzMTJISkRLS1o5N3lmZXlzT3hD?=
 =?utf-8?B?dlRoK0FJQjBvYzEwK1Q4amcrcVVFQWNkR1ZMb3hMa3Q2dk04elAwQ0NrdmlN?=
 =?utf-8?B?MTlaTFkwOU1laHFsYU5UUmVzSFpEYzF0VnhpWGNINjdCZkZkaFg0bFNUdkcz?=
 =?utf-8?B?M1hUbko3c24wL3lEYW9lenlMTCtOeDMyMHRLV3FlbU9leWtqN2EvMkNSbDVi?=
 =?utf-8?B?eUpVUHVHSnU4SDVlb052SEhwaWJNL0NodFFzSm1taEJleWQ5ZGo3Qk9zS0lj?=
 =?utf-8?B?TEVYSEEydG1BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QS9mZWVjc3R6cXhXWjVxR1k0NnY5NUxsbDNFUG1XRGtCZ3duMzZ3aGJqL2RO?=
 =?utf-8?B?bVRhVy94WmZpMXIrek1IcjhxbFU4WDhKMkJQUFlpSys3NXRCbWw4TXFVRjJ5?=
 =?utf-8?B?bXl3NWg0RTdjeWpKMlZ6NHkrU3dCdWFoc0xVcXhWcmlmUHFDVmdySS9CTkFi?=
 =?utf-8?B?WFMwSkswVUlSWlMyV2gra0djSDlxb2UvR1E2eFIyNDB6TlA0QW1HY2kxYlBa?=
 =?utf-8?B?Z212enlwbWN5bTY4T21kT2l6L0JHa01PZnFQZWRyNnVoUU1OcUxHVEVHaWJG?=
 =?utf-8?B?cGhPRk45Nkk1RVoydlozMysvaENqTHdnenFORmM2NjNMWVg3Z3dIRWp2OHJZ?=
 =?utf-8?B?b1BFTi9LSHg1WCs1djN3blkyUjJORDlCd1ZiU2ZtUWVpRnRndHJZYlRLWm9N?=
 =?utf-8?B?L1lLRzAxYkNKYmFwaTU2Z3h2bVIrbS9NZzFSQUlNNVdXVUlkZVJ2c2VjcElL?=
 =?utf-8?B?ZDRleVdlaTVZTHdyTXRGQ01UY2d3VnFOVkdmU0hCS0xmb09RWHhXRWR4RHpB?=
 =?utf-8?B?NjBnWUw1RDBKaDZ6Tms2L0VHTkFlY3RnWXN1SkxGQ3NXdFBGYVRZRkRQM1lo?=
 =?utf-8?B?a2ZaSFVEd1ZueEFqS05jUzc3SzZOVHVRUEx3cDFlYzdBcWEvYUc4WXlaaFJD?=
 =?utf-8?B?S0Y0Mk5Ea2gzaFI4aFVKSytxb3pZcXcvMXAyYnhxWVF1cUlqKy93K0dIZ3Rn?=
 =?utf-8?B?UU1scHltVmpUNlhoTlByRmFBK1J4Tk1OTUI5VzdVOXNtK1JleVVCYS81N0hJ?=
 =?utf-8?B?OUIzV0JaRE82bi9JUHdCNVM1Z2xJRm5vM2pzeUl2L1NZMGdrV01pSGtoSVJi?=
 =?utf-8?B?ZjN3WHljN3B1ekFjZ2cyNnlEb2xBQWIwWEtsR3FTTFdhYmE4b1BMc3hrendk?=
 =?utf-8?B?LzlVS3V2ZWNWTGZpT2M1RlZ4TkdMb1krWWxJc1BwZlNWK0J6c2xYaUxlRnZO?=
 =?utf-8?B?Q3RjR2JuejBxQmV1dG1VL3lsZFI2SmxyelY1NjhVUFFSdnB4RXNnY1NuNzhU?=
 =?utf-8?B?akQ3aHpVenVqRVd4WS9PMlVORkFKTk5uN09xcVQwTEdjQjRtN0dyMjYxNlVM?=
 =?utf-8?B?QXBLK3hVUGhhZVNmU1B0SWdIVXl2cW9qMFE3d2JOZTNuaDZFbkRacHRLa25V?=
 =?utf-8?B?emcyYUUvOW5Tdnh0MGhDcjVvd3ltYkNZSXR5aU9xelN6bkdmU20vQ1hOS1Vo?=
 =?utf-8?B?TER3RlI0WW5NVE91aTB4Z3VlcnRoUW55TTRtT0VtOWsvUTI0WnZHR0xiRStn?=
 =?utf-8?B?bEswR2RqUmpnNmpYN20yYktsWjkwaGtVcUpvSTdTM0w2REd0RUNqT1Zrc1Zi?=
 =?utf-8?B?ajY2eFpEcldYdVcrcm5qTkE4S0VYeEtLMnZUMVVSVzhKQUl1ZjdYbGV5NDhI?=
 =?utf-8?B?RDNhOUtrZGtOclR3RXpSZVZLdTBBU0d6blhWZ1JSUVd6WGRXK0RSMGdhWmlt?=
 =?utf-8?B?UDhWbnB1NVQ0c1N3bXBKM1dmalB2bktIR1hUbjJudVNrS3Vwc3FzY1lLZk9k?=
 =?utf-8?B?VmxCSkpXd0hSQXQvVzVlV2lxcm0xUi9qbU5TZERIaXNEcFF4cGd4Y1kvVGhI?=
 =?utf-8?B?WjNMVG0ycFh6Q1FKNTFKZHNCVUYwZlR6ekpoL25xUVE0S2FxRExZUmpDQ0ZV?=
 =?utf-8?B?NCtwUGNLNEl5aTl4RmxxSytRd3p1aUJQamZ0WGJVTmljZC9JbDIzdTNNS0Vm?=
 =?utf-8?B?QzZ6SGVoYnBJdEwrVlNnTFpTVUMzK3A3TGRMZjFra1Z4dUFIS2V5ZzFFeXg2?=
 =?utf-8?B?cVZzL0pPb0RKZ0VIcE02M1oxMU9GZDVtQ1kzcjJIMVVQNStsQU1GNmdZV1h3?=
 =?utf-8?B?ZjIrZlJxeFhHeEZ0QkJnamdHNzhBVURjYkgwcGlsYTdtc1hwUnVMMEhOcUZn?=
 =?utf-8?B?YW91Mk9scXhJU2RvWU5zeFIwMW5FZ280M1ZuZ01FNlJXM3YxcWplWEMreTVl?=
 =?utf-8?B?MEpWZHNWUjFwUEppTlF2ZllPOGUxc01zNGlEQUd4TFhrZ2UweGZxUVJFVTRx?=
 =?utf-8?B?aWdjNTI0WkJQd3dtbzBncXZjcWFHanRDSWloekZUOFNOdDF1RU91ODY5OVEz?=
 =?utf-8?B?R3FnQ1lwOEx4TnVVbzRTL2dYTXQzbDlndmIrZW8wdmJEOXEydmhtZmNMNGE3?=
 =?utf-8?Q?o+toAwqL5Qol80CknUs72/RSU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de24b84-4ee8-42e2-3822-08ddf7c04eae
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:05:48.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8Lzew8N/MH0zVoI8ApXWj4LhN2WI5IBFrXNwY4J+hUH2Qn5ogy02qqHj4yTo0Xk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9096

Hi Reinette,

On 9/18/2025 1:08 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> When the io_alloc feature is enabled, a portion of the cache can be
>> configured for shared use between hardware and software.
> 
> (repetitive)
> 
>>
>> Update bit_usage representation to reflect the io_alloc configuration.
>> Revise the documentation for "shareable_bits" and "bit_usage" to reflect
>> the impact of io_alloc feature.
> 
> Attempt at new version, please feel free to improve:
> 
> 	The "shareable_bits" and "bit_usage" resctrl files associated with cache
> 	resources give insight into how instances of a cache is used.
>                                                                                  
> 	Update the annotated capacity bitmasks displayed by "bit_usage" to include the
> 	cache portions allocated for I/O via the "io_alloc" feature. "shareable_bits" is
> 	a global bitmask of shareable cache with I/O and can thus not present the
> 	per-domain I/O allocations possible with the "io_alloc" feature. Revise the
> 	"shareable_bits" documentation to direct users to "bit_usage" for accurate
> 	cache usage information.
> 

Looks good. Thanks

>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> ...
> 
>> ---
>>   Documentation/filesystems/resctrl.rst | 35 ++++++++++++++++-----------
>>   fs/resctrl/ctrlmondata.c              |  2 +-
>>   fs/resctrl/internal.h                 |  2 ++
>>   fs/resctrl/rdtgroup.c                 | 21 ++++++++++++++--
>>   4 files changed, 43 insertions(+), 17 deletions(-)
>>
>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>> index 7e3eda324de5..72ea6f3f36bc 100644
>> --- a/Documentation/filesystems/resctrl.rst
>> +++ b/Documentation/filesystems/resctrl.rst
>> @@ -90,12 +90,19 @@ related to allocation:
>>   		must be set when writing a mask.
>>   
>>   "shareable_bits":
>> -		Bitmask of shareable resource with other executing
>> -		entities (e.g. I/O). User can use this when
>> -		setting up exclusive cache partitions. Note that
>> -		some platforms support devices that have their
>> -		own settings for cache use which can over-ride
>> -		these bits.
>> +		Bitmask of shareable resource with other executing entities
>> +		(e.g. I/O). Applies to all instances of this resource. User
>> +		can use this when setting up exclusive cache partitions.
>> +		Note that some platforms support devices that have their
>> +		own settings for cache use which can over-ride these bits.
>> +
>> +		When "io_alloc" is enabled, a portion of each cache instance can
>> +		be configured for shared use between hardware and software.
>> +		"bit_usage" should be used to see which portions of each cache
>> +		instance is configured for hardware use via "io_alloc" feature
>> +		because every cache instance can have its "io_alloc" bitmask
>> +		configured independently via io_alloc_cbm.
> 
> io_alloc_cbm -> "io_alloc_cbm" (to consistently place names of resctrl files in quotes)

Sure.

> 
>> +
>>   "bit_usage":
>>   		Annotated capacity bitmasks showing how all
>>   		instances of the resource are used. The legend is:
>> @@ -109,16 +116,16 @@ related to allocation:
>>   			"H":
>>   			      Corresponding region is used by hardware only
>>   			      but available for software use. If a resource
>> -			      has bits set in "shareable_bits" but not all
>> -			      of these bits appear in the resource groups'
>> -			      schematas then the bits appearing in
>> -			      "shareable_bits" but no resource group will
>> -			      be marked as "H".
>> +			      has bits set in "shareable_bits" or "io_alloc_cbm"
>> +			      but not all of these bits appear in the resource
>> +			      groups' schematas then the bits appearing in
> 
> I understand that you are just copying this but "schemata" is plural of "schema". Since you
> are copying this text, could you please fix "schematas" to be "schemata" while doing so?

Sure.

Thanks
Babu



