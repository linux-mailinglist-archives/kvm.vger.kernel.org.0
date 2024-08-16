Return-Path: <kvm+bounces-24347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3FD954105
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 444D9B23094
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AEF7F7F5;
	Fri, 16 Aug 2024 05:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2NOlIqRR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CE9EDE
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 05:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785444; cv=fail; b=prgJwzeokGocjFsuYFXYsMwyK6oPiDhkOu+1Y/6RbP+UNy3zykT6KDjW37TgKOhp4qTUZl/XOAvfu7/KWHVa4bpFQm9Ku5+npW2eZi/InQku+IjmwfjALii4AWHtzS/bjqwMIZcf3QySTdNKCS4wwvr2cALPwmgZjCKPRwz7TkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785444; c=relaxed/simple;
	bh=miorAV8FYV0MdmYrR8cBRPxs53l0WOWfVca75pWBkzA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LZvlx/4lKftaHBw5WV51HIiPR8rQgwRJbOXHC3jou52Xfyzf4jK45hCg5Jz1X4w//r6/WpgYNsi4elFCOIc+gvdy9+LkuqdpJIbIXtIgHh7gLnKVzSC5GHFdbqUNVguYP+1I7sr5c95mWC2CUCwRl0U6ZooK4D+GtlZJHfwuZbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2NOlIqRR; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H13vqJxly69FkUXeMRqxpBhNCAI8fgKjCTJquVlu1G3DahJCGVf3hp87nwzANa5rXyzaHKvKehQl03o+qvvq1n6RTyO/S0xMbz16csCBAAwSA6bm05LqKSeYuUUCE5WL2BZV/FZ4Q075LWGUmWFOBPyQREQnYv3pvuTSZQgjsDmB50FBfdOCydy2ui+GJC/NHHU/4HVuxmCsfWjdMNTLnI3YTG1/FCcUBbnuf2K+037EIRRRzHiAZv4zkwT5/kCnyr3BZs1SplmfD0vfNMie0PNJgdNL5ViJFr+xD4+5amj7jA4JfDJtQJOFENzJwGhYxMTXRqPFKvmfWWKtn0ExhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNyocA8ZU+o1fhaKWHIakQokbKv4l+387GjDRT2tjRg=;
 b=HBbT29qa06UWT5u9UaoWXuKHhrLL/Maff6RMpaH1tFB3Mtaqml0QMCzl1uHAzZfyqQHXypk5abHbUEp+Yk9WM0QSunCm5zSOjbEV5sL6uZolaMgf6EWGprQxFhKw3rnHBwCWklpnc+N8vgNyGnqYr+8J2Keoa+83oJKW+QqCMfp8PFwDHzGBTscFc0OakLbuW06QSmushriepWRJvPv0Hgo2xEoD4WECbnlCthUD01G6zuPHuuYnt3GK+uBAIdU0O/lxy7wF3u56ReKedFjbLNp1gk5GsXY1+PscnksH11v3uC2cX2YKq7McZgSZmV8C0eDj4kZ84JqFQFYvJu5I3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNyocA8ZU+o1fhaKWHIakQokbKv4l+387GjDRT2tjRg=;
 b=2NOlIqRRCfHaCOD84PbHL3JxaL8uGb3XMZ5pHAG9y2IkeF/y/ElrsGiFW+TDsKI65EylhTBygXAyB+JjuLI6Q/Dkjp7b8w96K1BURu+MLm5zBu5iaJ0sUh1LV6OiBGGomNm0VcS9xpBTEuk0oxChWVlAvia43ELxpng4OHp8Lhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.19; Fri, 16 Aug 2024 05:17:20 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 05:17:19 +0000
Message-ID: <b1a93cb8-18c8-47b2-91b8-c97209e0599d@amd.com>
Date: Fri, 16 Aug 2024 10:47:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Baolu Lu <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
 joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: alex.williamson@redhat.com, robin.murphy@arm.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 iommu@lists.linux.dev
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
 <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
 <e15b1162-dcdc-4bcf-ab61-79400dba87c3@linux.intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <e15b1162-dcdc-4bcf-ab61-79400dba87c3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::19) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 8304aeb8-06a8-42ea-ae09-08dcbdb2b368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sm11eDljWC9ZdW4zOUtITCtBdUx5MmxQTnYycHhWS3VEY1ZCeGc3VlI4R2Z3?=
 =?utf-8?B?Uk90ZTJjWHF5QWVUYVpIWEhEYkNuU2J3bXBRN2JEVW5KWUdHTFY0RGJvTUVx?=
 =?utf-8?B?bmcraFBRQTJhc1dWcm5ZZEU0OUlaa2syeUErZWF1QTJhcm5jNlhwTUNHRFFm?=
 =?utf-8?B?QVFvd3dmYUdoWmgrK1FmNzNUZWxSMStJQ0tqYjRuaHhZZ3RmSkFxWHJUWGM4?=
 =?utf-8?B?SHVIZVJsUTlSQmwvVXZxZ2hSbHVvSXNlejJzY25YQUpXVE1pMktnWC9UMDls?=
 =?utf-8?B?TGFEWVI5K0RoMUo2QyttcVhkQ3FpeStHZUdzeXlwTTRSRjIyWWxqYVdpMFNH?=
 =?utf-8?B?aTlQeUVEM21SV3lNeWtZOVhhdnNzQVdBdEFjZHBrRnZVemN2YWtKNVVidDAx?=
 =?utf-8?B?VlZldlYyZXBmWG5TYmQzd3hKL1hzTWNacWdOcjEyTld2Z05VY2piMW5xSzBw?=
 =?utf-8?B?TjRYaHorcitLdVBZWEFhMkFIQkxsVHZ5ODR3cVdKRWFoaUkwOWkybEo4SXUx?=
 =?utf-8?B?ZS9RMFczdU92VFFkVzhLbUdaWlZVM291NkFZMkYxUlZMaDllTHNDRnEzcTd4?=
 =?utf-8?B?eGxYc0ZyZjBTaW1ROUFETCt6Z3czZjZKTTdobGp5c3ZkaUUxNXVNOHZDUnhi?=
 =?utf-8?B?bFpnenp1Smpyd1I1ZERld2xPZFdGS2tYcTV3cU0xTTNEY3YwUUdlYkI3cEx0?=
 =?utf-8?B?Y2VSTnRwQWJVd0pQSEkyekdPL0IwTmFPdFZra2tBbkJZL2ZqNG16WlNNYnBH?=
 =?utf-8?B?R2orL29lTFA3ZTczbVJ1eFdOYWpadk15K201b1pUd2lXZFBOM3ppNTlGOVN5?=
 =?utf-8?B?Y0xqMU03b0dBNzRyL3NCak40Y2hXZGFrYjhKVkpQbDFjcVBzcDRvOTJINGQ4?=
 =?utf-8?B?SXVSRDY2aEpTS2Q5emw5Q1BxbDM4aS9jTlNrdmpuWkp1MmhmMVhLNm9LeXox?=
 =?utf-8?B?WTBLWEpodHVXbVdsQW15WVE0UThaQ1NPZDFmMFA3bXdDeUdlOXY3MVZjakRG?=
 =?utf-8?B?RFhvR0hHaGEyZnFoaUc5MUUyamlQT0plbW5wbUMybmRaWGRVWkM3L1Y3bDJD?=
 =?utf-8?B?UDhtSnlobVd5REdIM0tQczVnaEludmw4aTRrYzdEd1dUMVJvVDlYMnB4Umw0?=
 =?utf-8?B?ZWF5OW02N0JVcDIvZ1ZZallDZ0VVTmdueVRObU9hYVRiUTdQdnd1c0ltRmZC?=
 =?utf-8?B?UHhmSndobS8ya2tQTXlZNjh3Vi9lRlJQU1JtR3U1OG9xZGMvNkFpZ0pjQVBt?=
 =?utf-8?B?QVloVDFVOW5id3ZiNTB4ajhtWW05aGRueVh0VFFWN3lGZWlGb2plYkNFVUZY?=
 =?utf-8?B?c2YvZHd0b2VvRUFIUllMVkxvOWlMZWZEOFVack9WdE9NcGs3bjFkM1VyUUFv?=
 =?utf-8?B?MUo2czM4eWpSZnBteitLWkd3NkRSQjVkb3g3VjZSRmlUSzhiaE9BbCtxcVdK?=
 =?utf-8?B?S0svZjVTM3dycnZWcmNIVmsyMDV3amJXRXZMRUZ4M29ha1JPQTVDWTFHY3BT?=
 =?utf-8?B?U0lPemJscVJ6Q0haT041N3BFUkEwTzhkd3dFQWJKVHVBVUgwVm5abit5RUlG?=
 =?utf-8?B?dUMyb0FCL1Fwd3hMUWk3MWNYRVhKRTNLTTRTYXRYV1FIeDZvZmxQSXNvOVhC?=
 =?utf-8?B?Z25MQURIQmxHMjQvbGc4dm5sUCt1bGxBSVNVVlp5Q3I0T1RGK0lVcGZzbWEr?=
 =?utf-8?B?cDI4SWh3ZXZxblBMekVTUWZZODdEYXZCMzFmV1gxL3dkQnZvZDhUM0JhbVRS?=
 =?utf-8?B?a3luNFI2eEJZN3EydVVEeERXaDJ1eEVyWjlFenZhZmdTeG9yNUZVQVJaZEFl?=
 =?utf-8?B?NjZybi9WT1UrWmtLVjFrdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0ovQVRhaC9KR3IyZnNQN2hycHJuRmppdk9kZEtsNjFxbFVUTTk2Rlc3aE5x?=
 =?utf-8?B?U2g0U3VWRXVLY0gzSnJEMDVoeWw1czRkQVBqYktHZklWUVYzdVZvcG9UYmRY?=
 =?utf-8?B?LzUwbVloSlhtQk5DVi9lUzNmVVBNUmo5REFFOEhjWmhQU0xGVHB2NHVGUTZL?=
 =?utf-8?B?TlNrL2VobUpSbFJqZWg3YVFtN0pvUG1Kb21uUXAvTHhEbnpuQjhhU1N5R1RE?=
 =?utf-8?B?eURmK2VYNU12Nk5sb2krSGI1cjdlWVl5K25jTVIrcUs4dWYwZHlhU0NEK3Ru?=
 =?utf-8?B?bzVqVklKam9lTVNVdEZ2UkZJTnltUGJtL2ZDajV6cFRBaTBQSC9rMi9Gb2Fr?=
 =?utf-8?B?UXAydGVidTI3UTBFbDJ4ekFsR0I3eExmeWcwS1Z2NHowR1g4dWlrZUdhNkp2?=
 =?utf-8?B?WUx6R1ZmY0taWFlNZmFUc0tRWnBjTGNYMysxVGhtVGR5WjBuekc4MkM2SjJZ?=
 =?utf-8?B?UGY0YkRaaEphNjdSZnhVVk5PZlJqdkpTNmd1eG5RZ1hZYWZ5QndJTWVDNXh5?=
 =?utf-8?B?K2JsV1ZrUWJ3MkhCTlpyRmc4ZVI5RzM0UC9VQ3BKN253TzZ6RTRqeTdvVUR1?=
 =?utf-8?B?VHY3dkVxS0xaUFBZd28zcUJEUXh5K09xaE9BRzRSeFNDaEhoKzUvWkZsVzRv?=
 =?utf-8?B?cTJBZkNqYVJoVVpjdm1GWGxYdzI0TlIrVEN3ZkRFRVpxbnoxTEZEbCtwT0tC?=
 =?utf-8?B?aEYvOTFRYklGWlJFbk8zQ3B0SndxS3JSandJcU42b0l5T3BWbHhJUDZ4VGkx?=
 =?utf-8?B?RHlUa0swN1BOOWtsS2JwMEhNSnBPbnhtZUNNRy9LWk9ySWY5T0d3TWdzYlY1?=
 =?utf-8?B?Y3d1RG5KWm5oaDE5TjAzT2svYkdFY2JqTlBXTUFxeUhvNUNPaE9mYnpDVHEw?=
 =?utf-8?B?RUNFdk4vR2RrTU0rODlVeVIySVRaOStWbWVrRkYxSFBXVnJnYmlURFBUOHAw?=
 =?utf-8?B?TU0rU1F5cGZZK3JieDE1SDdqcVpvZlpEUm4zOVBwZnhaUXNZVzR3cEpQbHRF?=
 =?utf-8?B?UHJKa05yZnhDQ0RtQ3hhR25WREZ4Vms4RWJiMk5mOWtIV3NNTEk0RklvaGhj?=
 =?utf-8?B?K3pqOFViUU1zRTJPbmw2WXUxclZTQkNwcUtueDk5eUY1Mkp2VE42WWtINjVP?=
 =?utf-8?B?V28rWkVpWFNwQ3grVDl0cEsvOGM4NTdOS2FsSGRYVjBhZSt2aVVqNGhUanBs?=
 =?utf-8?B?ekhPYlNMb244MUg1YkdzQjJOV2plVGZuREd4cnhIMW1aNnRqcm91Q0thWjc3?=
 =?utf-8?B?WTBpQXYyN2cxZEZ1MWllRmhnaWtnT1RaMWYySTB4cHZETzc3R1A4QTFhdVpK?=
 =?utf-8?B?K2daclF6QmVnbXphS2xiZFlhOE5CM3hEMW92ZUwyc3hnSng3NEhQaUM2VTd6?=
 =?utf-8?B?bVAxc1JCckxWR28wSGVQdkhVWGtHUFp1UDh3UTF2dktTZGtIeVRYYzBmRGxE?=
 =?utf-8?B?U3RtSEFFRjBmQWVxUEkyUi9xYkh2OHZicEhhUFNFVG5HT0FPcU01dVkwSk54?=
 =?utf-8?B?ZyswRzk1RkJCcjEvRW9PS3gxQW9rZTZCekRyMnZGdnJ5ZnJoNU1scXVZV0Rw?=
 =?utf-8?B?MERHa3h4QVFHY0szTFNETjdHTnltdXRZMk5SS2NMQzQ3VmpISWJ5TjJ6WTZT?=
 =?utf-8?B?dEJvN0JLekdCRFp6WmN3U1UxQnVnOWtuL1J1ano0Q0g0NDlhTmF1QnBGdFNT?=
 =?utf-8?B?STdmZHBKaU9NOWlLc2tDclc4eUptR1Rxb1R3OWhLUE4zQUp2OHZRN1AvZWJM?=
 =?utf-8?B?eFFrY0l5bm9uMjNIbkkyNStGY3BBYWtYb2V1Qm15S0wwZzIwcXhqc09tQzY2?=
 =?utf-8?B?dmJGWVFRR1BPL2hmYU5CTnNwTVloV3BBS3NUYzFEeWVjcm4yNzM1S2lzWHpD?=
 =?utf-8?B?Mzc4S3pKWnZDQXYwK1hjRklGRHJxNDdkRjdmQ3kzS3Z0NXVjRGd0T09paUpT?=
 =?utf-8?B?Q28vRjEwem1aWVRublJZMmtGTnRUaXNvYXh6a3BycCtTSUQ2RUt0VURsU1R2?=
 =?utf-8?B?TGF2TnhCK0VJUDQ2ck1Fa0laK1dDNDM0LzVFVmowcTV1cUNmcGJqbzZJaWw4?=
 =?utf-8?B?U3NpZGFHMmdXbFhFeEE5elpBLzlyS1VmZ3l5b0krcUlqcmRiaWxLYkNWTjUv?=
 =?utf-8?Q?7Efui10p/zrPqVYSRQxLNlFv4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8304aeb8-06a8-42ea-ae09-08dcbdb2b368
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 05:17:19.4937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+zR/garsPi/FP8FsepoAwkxxkCnIawDo+LyRDoIcou6ZdOXGkF+OXe9m/0bm1lSv4Jieqaq/7lo3FInLVcmKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413

Baolu,


On 8/16/2024 8:19 AM, Baolu Lu wrote:
> On 8/16/24 9:19 AM, Yi Liu wrote:
>> On 2024/8/16 01:49, Vasant Hegde wrote:
>>> Hi All,
>>>
>>> On 6/28/2024 2:25 PM, Yi Liu wrote:
>>>> This splits the preparation works of the iommu and the Intel iommu driver
>>>> out from the iommufd pasid attach/replace series. [1]
>>>>
>>>> To support domain replacement, the definition of the set_dev_pasid op
>>>> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
>>>> should be extended as well to suit the new definition.
>>>
>>> IIUC this will remove PASID from old SVA domain and attaches to new SVA domain.
>>> (basically attaching same dev/PASID to different process). Is that the correct?
>>
>> In brief, yes. But it's not only for SVA domain. Remember that SIOVr1
>> extends the usage of PASID. At least on Intel side, a PASID may be
>> attached to paging domains.
> 
> You are correct.

Thanks.

> 
> The idxd driver attaches a paging domain to a non-zero PASID for kernel
> DMA with PASID. From an architectural perspective, other architectures,
> like ARM, AMD, and RISC-V, also support this. Therefore, attaching a
> paging domain to a PASID is not Intel-specific but a generic feature.

Right. We can enhance AMD driver to support attaching PASID to paging/UNMANAGED
domains. It needs some more rework/cleanup before we do that.

-Vasant

