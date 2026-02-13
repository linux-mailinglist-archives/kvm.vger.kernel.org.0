Return-Path: <kvm+bounces-71074-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBJAKoSwj2n0SgEAu9opvQ
	(envelope-from <kvm+bounces-71074-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:15:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF950139F16
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CACC30420A0
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 23:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9369B330333;
	Fri, 13 Feb 2026 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c8/Wrp1R"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608832F764;
	Fri, 13 Feb 2026 23:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771024504; cv=fail; b=XgHOEq/VzkZg5sLs7lZLd+FudjyhmuCKgNU8MkH/IvamcXXL9jmuUy1RNFaRkSFUtvK8m6/oA2KEhMuYCna5FeZ10g3H5U8Ofh6KqzMk3IBChOcgTCGGDwY8Zic8VjbOfhVIrgSnuGoA/+echZhQcWxmP2dS74psv7QZvGpL2dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771024504; c=relaxed/simple;
	bh=Yn40LYBBnS5jBuSqG0FFurqB3p04NjDCf7bwOu+irj4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jp3GL7LyGQLg9DHw/AH2i6OM2jzUeNDDFjXU2vTL0nRF7aHD11NIJHQFsy6ocRhGucyXgaenlMGXtXEVQTr4JKEmI5StH0sw7IEkte4ZgZOcyh6yxjc7n+E/QadgWVGofignOttaLHoBj3T8blk1U6qA7o/QhVTiUsJwYOAR9eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c8/Wrp1R; arc=fail smtp.client-ip=40.93.195.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cE8SxFlDMhQYY4N/dI5ZRcapql3H3/Y7p+X1/BMJSzdVmnGhF1XAABAZXHVd5NweX2EoGTk7CvYv/h4Vgi95Bn13dSyxUFTzkAtL5TkfuYrp7sS2TdESCJhXeuohwiGyIjR8GSEz0X5nH2Zhlu6yKpRGCGxHiJ8DfC9g3QlfQrtECCeWto8H91jq6qPTMFYJvmvFq0VgkYoBjjrq/P7ZKddZdzLsQtXDK61vmFLxXXYv6CwiGQcEygFjuc8lN1DgKLiGt+5zsuxhZvQLfEzcVk35mKIR7vqS83Mu1wYRd9IN0HjPhygenHAxkIF4mL25SyoT/DKeKFDL7QGQOjwhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IecuxMY0fWUh8Qd6tuxhwG2drVc0kBYOkV7qCyP1Vk=;
 b=d9h/2eDsKHN4v3oF1WUBV20LqNDj+tBFh14S/cfgkVy8NQqA71dn3WGXE9DNU7Iu02sN4DcMnwrsuGXk7791j2xtrT7sU+I3ZyOS2BAQ1kBaQSBaKmAKJThg0xD6Vbd2QqQNJ97p8rlHfYkwPP8BnCPywkaH1qcp8qvwYW2YHiQCEdt+83L+z5q50YspV2g2NCs3EvKxqhBXSbdXUx6brdwincewvzn1iqIDTGhmPYIR2gyifVJallIgWs4jdQmnU6qcxmHagagSdUAY0RwTD6TzHuJt+WmxuGgyS1eqbMWWSzptj4BNwpsaTSatkFTE+3cnS4bLRlk/G7paKjvFjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IecuxMY0fWUh8Qd6tuxhwG2drVc0kBYOkV7qCyP1Vk=;
 b=c8/Wrp1RKPW48KvDRXSXmJExBk046MsX9ToBooZkArtrQiLJaeRLZ3696expKG+NlCAw2GQJzG7RElFfXeE1XCg3WN2hWi1u6MvE9VGji/K7xYW00zNAeD5E1D9Nxiw1NpIlD3kfHn5yGrEnDu42CXTppYyPu9xANvHE0zwi3ek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by BY5PR12MB4322.namprd12.prod.outlook.com
 (2603:10b6:a03:20a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 23:14:58 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 23:14:57 +0000
Message-ID: <6e4fc363-7f3f-41fe-aaaa-fc60967baade@amd.com>
Date: Fri, 13 Feb 2026 17:14:52 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
 <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
 <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
 <280af0e2-9cfb-4e08-a058-5b4975dd1d16@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <280af0e2-9cfb-4e08-a058-5b4975dd1d16@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::17) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|BY5PR12MB4322:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f17e72-b80c-4285-2076-08de6b55b445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R25QM05ReDVPRkNtQVRtdUl3a296NnEwektDVEFOMTRLQTI2OE9ESzR1QWtK?=
 =?utf-8?B?YlZ2VzROb0VuOVh0TE1xL2txN0xwNDBCcXVkdFdsZ0lFRWdzN0R6ZEVRTlpH?=
 =?utf-8?B?eFpMM1NlWk9idmcyb2h4QmNqOERxYW1UUTNHK1VHdTc1QzNESzh3VDdSZWhM?=
 =?utf-8?B?WUYvZDQwcVFvSFdCVEwweEJ1cTkwbDNmWlM3aXdueVRZSG9kcitONjlDd2ZP?=
 =?utf-8?B?ZFYybnRhQk5aTHc3NVExWVNvY2lEUHBtUmh2ZWRmRm5Dc0F6Z29uemJIT0E3?=
 =?utf-8?B?MjhzR3VtcDdWSlBjNElwRTZHTDVKU0t1aExlbTJQTjJIWkMxNTR0VEI1WGhQ?=
 =?utf-8?B?SVRoVG5EemtyK3krSWwxbUd3S1JWajZJRHZjbzM0dXdXNE9maCtaWWg1Tm5Z?=
 =?utf-8?B?WFpaMWl0RlRZT1BNbE9BTmRPUzl6WUVkY0g5Z3d6VGgxZDMvdnRtWktMbGdx?=
 =?utf-8?B?cVpNV0FLb1dsK3RRdUwzbmpadFBXeVhWOUwySjBBSlY0S04reFRTTHZtWGds?=
 =?utf-8?B?M2gzY09QWGVOK0xYV1FZSGU2bThQSHVsU3RkYmNCSDFBcFQ3SlVVcUUvbk9N?=
 =?utf-8?B?bWszTGNrTjdqNHpRYUFRdGV4SGRRS2ZvUEVtQTJYRWlXM3hQa0l2VFAxc1cz?=
 =?utf-8?B?TjVMUDB5R1hNcVBlUEZOSFRQWnVoeFp0Vk0xUTdsTnA5NXh5WFJDQ0lkaGlN?=
 =?utf-8?B?VUluVTZSajZEWGgyMDhDSVpraU5SamFMM0x3c1JjSjdOS2twb2p3VjVCMjlj?=
 =?utf-8?B?S1RIQWNjbkYzaGh3T3FrZ25TZysxc3NNazZqQmlxc1NsQ2RzV3lkbTZxMisz?=
 =?utf-8?B?RWZXOGp2d0VmNTBOeVd2aHFBL2FLVGhlai9TSzB3MC8veVZYeDNheDJWUktt?=
 =?utf-8?B?cG8waHk2S0hYeUI3aHJCOGVTcGNOVUhkeXJUQlQ1cVFidTVORUgwaUo4NmxD?=
 =?utf-8?B?bExDb0h3VHI5dWsxNnNRN0tSbnlKdnE0NUt0Qy9FNXc2d3JiRUU4ZlJZNTRV?=
 =?utf-8?B?WUhzbTMxOCtXaVNIbjZGZTBVU0FlcnVFaXRJSXpLTXFvYmhiWnQvc0cvZHRa?=
 =?utf-8?B?RzNkQnNlaWJkekhDUXVuZEtmTitobVV5aXpOWEE2Y1JKRjNZOXdGM0pHUVZj?=
 =?utf-8?B?L0ExTlc5alY0OXRJd0k1NzE4cUppZzRLTDJ6QmZMbDQyenlkeGtkRHBxd05u?=
 =?utf-8?B?dTF4Z09LMm52UkI0RVp4dy9YbkwxZ3locE5ocDlEaUpWbVhidk1zU1lWckVw?=
 =?utf-8?B?T2wxMHJndVA1MHZ2ZFY0VWwvMmdlVlBEbXhrZ3JIdm1WY1NIdHMrY2hXazNl?=
 =?utf-8?B?UGtDclF6dGxsRm5PTm9zb2pvWW91R09IQkFoSVJRKzB3dStsWitLNnN0aUR2?=
 =?utf-8?B?am16UzF0NlRyeC83MFJQRmRYaDNWdnZVUUVpWGNCbUhLQmVNV0E5djVBZlp5?=
 =?utf-8?B?VnVrQUhtTU5tUjg5UG1OSTNCVmJxTmIyTVhtazdpcU1GUGZYZEYvOHA2Q1VP?=
 =?utf-8?B?QkxCMzkxYUVOTW1NTkROSzVKRFRlZ0p6clU2cW9KVmUxUm5UUmFEVGFsZkRV?=
 =?utf-8?B?amVMbzQzbWFPVXF1bVlCT3pkMkNaN2xMMVFRYnlkelRmQ3RyUW1qN1lMN084?=
 =?utf-8?B?eXlhdktmUEVXbU1LV2Y0WDJ5cHBDWkY1Nzl5RmRDbjQ2QUdwOGZ4N3JmWEVT?=
 =?utf-8?B?T1NYcEFNMEdLdzBDZXMyOVIxdUk4MXJNQzBQdEZUb0piMnZnYVlBcjJvak9Y?=
 =?utf-8?B?WUlZaW9EY2U1cEFGRVNPdHVQMHlyTmxma1BrcjRYc2txcW55MHFZRHVGdlIw?=
 =?utf-8?B?QmRlVUpvK0pobnBVVXZtTlpIdXllVlJvSG44aTZjSEZmeWFFQ1dvbUQwNmth?=
 =?utf-8?B?NHdOTENKcTlsSzZLT1RIZmhiR01OVEFyczNRTi9oYTlxeHlsWDJON0xWeVJ6?=
 =?utf-8?B?MEhWZk9LTUxLQ0JTZVcwU3YyU2Faa3dDZ1Nxajgrd04wZ2N1R1EyVWEzeFpV?=
 =?utf-8?B?dFJ1U2s3OVhYTHduNGFTKytyUXd3Tk5QNjJnZVBRVXVVTDFwd1dhNVV2UnNM?=
 =?utf-8?B?UzdlamtYR1BOVUlUSXhRUmRBeDcxNmdEMXAxRVdNU1p6ZE1Gd2Qxc1Rxc0cz?=
 =?utf-8?B?VFFuUWo3R28yUWpVbVFIVC9YR3VtSXc5YWdLbVNmMUx3NjZIK3NRVDI3NWYv?=
 =?utf-8?B?bGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXYyeHhiTWVjTWhBWHAzM0Z1YjQvWHhaVEVFeW1LYWo1QmwxUmYrQTNHMEU4?=
 =?utf-8?B?USs4SC9NdWU4NTFlWXY5d2p4aWV4S0lSekxUUlRnRFV6UkZDRGRuOGZXT1pC?=
 =?utf-8?B?V3FJVGxZa3RQTEhmbW8waWdmS2ZvQlQrVjNGeWRXeUoxaGZWWTRyODFiTHFK?=
 =?utf-8?B?a2dwS0p0UDAwMGVMWHlqR1U3UUVOOTU2R3NpNWRLL0gzV244WGxHNWM3Uy90?=
 =?utf-8?B?a2dXbFB2Q1hhckdraHVxQlN0QU1DdVhGc0xCVUpDeG04aEVMdmFreE1tUWVB?=
 =?utf-8?B?dlg0dnRHSFZCeE5aV2ZyV3RFVXo0K0lzNzJuWTdFRGNMV0ZTTE9wMnovRGZ2?=
 =?utf-8?B?ZkM0dGRiLzVKbUpUV0ZJUHdlNWcvNDd1Q3VYZE96ek10cXA5T00rTndobC9S?=
 =?utf-8?B?N3lLZ3RwbTAxWFIrdm4wSThWUG03R1JROHV4WmcxRUR1WkhtSnpCVnlYQU9G?=
 =?utf-8?B?Unk5ajB4MDhKdnhzNlpnL3pWbXEvZFlUY3FlT1AvNFMzZmJhWGNtbXMwcmJz?=
 =?utf-8?B?bndYbVRaOWRvSmF4am90Zld5ZGxicEhHNEtvL0pVSjV4YjYwZEVvV3A4d0dy?=
 =?utf-8?B?YkhqK1hnNy9ENTdYOGlkc0cwZVRQN2puQW9qVjU3L3J6MmQwUGxxUi93V1cr?=
 =?utf-8?B?d3hvMDNTMGh6ZlVNL1hjT3A5WWhQKzBsRjlkajBLQ0FYR0NHZnhJTEdIZGRo?=
 =?utf-8?B?eTFpSkZOeit4R2JYbHFoNFl6MWp4UFR4bWtnczQrTHdQRWlGSVd3ZlJpbGMx?=
 =?utf-8?B?V2hUMlB2cmo3ZVFZcjRnL0JHWlY3T3Evdm1Edi9sdjJ5OGhzQm9raEREcnl2?=
 =?utf-8?B?NmQ0L3phbGFkZmlVZmE0WTB5bUlGdmYvL3RvZ3lZQUtjS09FTUpEd3M2dkY3?=
 =?utf-8?B?Zkg4Q3BQdjNpeDRoY1FNN3BaQkx0QVVzSGtnanBOSXBoR2JDQzhzZTFYZ01W?=
 =?utf-8?B?SENXSytNaHFyWlpTK2dQVmRMdjBkdkVhbi85MGZvZUlLWlFYckN4NEYvREdn?=
 =?utf-8?B?YUhBODJNMFBTVkhNa3VNWEkxT2tlQ2VsVGRBUnBVTWdkcnJpajRudDJIWm11?=
 =?utf-8?B?R3VTWFpQS2p5aVNtOXhqNHRGNGQwYWI4YWtpYno5VTN0MUQvWXQ1RllJdEgz?=
 =?utf-8?B?Vm5IVUhOZlpxMGQrM1R5T3B2K2FIUzI2R2tzT0tDd003bi9UOWdxU3htVE5L?=
 =?utf-8?B?dEZ3MW1BQWJqbUtLZ2RRdFgxbDVudDdnV2FiVFRyRkFqeHNxd0J4VzRKN05v?=
 =?utf-8?B?VVFrazJXSVFoZVFZK1psTFhxL2oxRXRhWGJDR0ZycXIzWWFrWlFoUzc3a25H?=
 =?utf-8?B?cml5aW1zb29YeVRNNS82QzBISUJFRzF6M2U5ejVKTTEyTDExS2xMNUI5RTVj?=
 =?utf-8?B?Zk5GZEtjMlBiZ2VMK3poUVc1bXVCZHE3SHN5bk1aTldkQ05MUXlEK09yRER4?=
 =?utf-8?B?d2NsR21rVG5iK1pNcFpnbUs2Mk9wNTE3cVMyRklrZXRBYVJNV1d4UzVNVU1v?=
 =?utf-8?B?cXUzaTNDdllYVzdldGRSdDRtdU14UXdIZ21KT1lCK1V4VUxnRHpxbWhaV3FX?=
 =?utf-8?B?Z05qVnMrWDZoR210L2c4YVRlY2FqZ25kbUpjalpwV2dETHkzV3lGaHNycjRp?=
 =?utf-8?B?eHcxVmpTQk15WDBuS3FxTWRuMVRQTHpqd0NqU05rZUY4OWJMTUdvd2JUNHZj?=
 =?utf-8?B?L0U3a01lNVZkSy9ZNUw2dzNQVDJTQ251TE5CYitoczRXSHFwVGNFZkFoUlcz?=
 =?utf-8?B?T1J4clJYaEM1dm9qVUI2aWZWRjI2dkZyMjlaUi9rUEJPY1p0ZzdUaDNJRlRU?=
 =?utf-8?B?RE44Y2dRZXEyMFgyNVVVMXRNK0RTdkpLR3k1YUhUVkg1bW1pWTY4NGNUdGFT?=
 =?utf-8?B?VUtVcUUyMG8xcUk0VlhReGQxWStvNC9qR2krS0JiczlzbkNFVHZ5VGdTczlm?=
 =?utf-8?B?WWhZOTl4NkhPeHJTNVBBRjI4OWFZYmJ3R2ZObDJzblUxdHRJajRJYlNsdUZk?=
 =?utf-8?B?QUtJdVZWN3E2YU51UG1DZzdZbDFHcE5Ha0VWc0N4MURIQit5WVA0UnpPSk9v?=
 =?utf-8?B?OHh4YlB3M1BYTTljb0R1SzBKS0l6dnYzQ3p0ZWV0SmdZaXNkQ3ljcXRsWVpw?=
 =?utf-8?B?MFZzVktGeCtLOGJIY3g1dWgydUJ2dkJvNGhPUG5oRnYwMG9nQXI3SzlmVGIw?=
 =?utf-8?B?ajlwSnYzTXhuM1p0eTkxR2ovQUhCV09xTzRFUTRIZWFhUGZRdHJlSW5mVU5I?=
 =?utf-8?B?NU9DMmN1SjlHUVVSc2ovM3FSYWpLS1NSaDJ2Rm9YbnVLTVBwSTBqR2Y4Nzdz?=
 =?utf-8?Q?9Wen3ViFVx8fYi7Fqj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f17e72-b80c-4285-2076-08de6b55b445
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 23:14:57.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXxp8A6jYLOw/n/w52BqOVrSBWOmmHGPSA68+cyzr6FFyzQgbUtrSIEazlowHAB1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71074-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	URIBL_MULTI_FAIL(0.00)[amd.com:server fail,sea.lore.kernel.org:server fail];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EF950139F16
X-Rspamd-Action: no action

Hi Reinette,


On 2/13/2026 10:17 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 2/12/26 5:51 PM, Moger, Babu wrote:
>> On 2/12/2026 6:05 PM, Reinette Chatre wrote:
>>> On 2/12/26 11:09 AM, Babu Moger wrote:
>>>> On 2/11/26 21:51, Reinette Chatre wrote:
>>>>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>>>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>
>>> ...
>>>
>>>>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>>>>
>>>>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>>>>
>>>>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>>>>> same:
>>>>>>>
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>       MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>
>>>>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>>>>> MB limit:
>>>>>>>          # echo"GMB:0=8;2=8" > schemata
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=8;1=2048;2=8;3=2048
>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>>>> Thank you for confirming.
>>>>>
>>>>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>>>>
>>>>>>>       # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>       MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>
>>>>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>>>>
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>
>>>>>>>       # echo"GMB:0=8;2=8" > schemata
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=8;1=2048;2=8;3=2048
>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>
>>>>>>>       # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>       # cat schemata
>>>>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>       MB:0=8;1=2048;2=8;3=2048
>>>>>>>
>>>>>>> What would be most intuitive way for user to interact with the interfaces?
>>>>>> I see that you are trying to display the effective behaviors above.
>>>>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>>>>> what would be a reasonable expectation from resctrl be during these interactions.
>>>>>
>>>>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>>>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>>>>> settings may cause confusion?
>>>>
>>>> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
>>>>
>>>> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.
>>>
>>> Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
>>> If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
>>> an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
>>> larger than x GB for domain A or domain B would be inaccurate, no?
>>
>> Yea. But, I was thinking not to mess with values written at registers.
> 
> This is not about what is written to the registers but how the combined values
> written to registers control system behavior and how to accurately reflect the
> resulting system behavior to user space.
> 
>>> When considering your example where the MB limit is 10GB.
>>>
>>> Consider an example where there are two domains in this example with a configuration like below.
>>> (I am using a different syntax from schemata file that will hopefully make it easier to exchange
>>> ideas when not having to interpret the different GMB and MB units):
>>>
>>>      MB:0=10GB;1=10GB
>>>
>>> If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
>>> as below and will be accurate:
>>>
>>>      MB:0=10GB;1=10GB
>>>      GMB:0=10GB;1=10GB
>>>
>>> If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
>>> is actually capped by the GMB limit:
>>>
>>>      MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
>>>      GMB:0=2GB;1=2GB
>>>
>>> Would something like below not be more accurate that reflects that the maximum average bandwidth
>>> each domain could achieve is 2GB?
>>>
>>>      MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
>>>      GMB:0=2GB;1=2GB
>>
>> That is reasonable. Will check how we can accommodate that.
> 
> Right, this is not about the values in the L3BE registers but instead how those values
> are impacted by GLBE registers and how to most accurately present the resulting system
> configuration to user space. Thank you for considering.


I responded too quickly earlier—an internal discussion surfaced several 
concerns with this approach.

schemata represents what user space explicitly configured and what the 
hardware registers contain, not a derived “effective” value that depends 
on runtime conditions.
Combining configured limits (MB/GMB) with effective bandwidth—which is 
inherently workload‑dependent—blurs semantics, breaks existing 
assumptions, and makes debugging more difficult.

MB and GMB use different units and encodings, so auto‑deriving values 
can introduce rounding issues and loss of precision.

I’ll revisit this and come back with a refined proposal.


> 
>>
>>>
>>> (*) As a side-note we may have to start being careful with how we use "limits" because of the planned
>>> introduction of a "MAX" as a bandwidth control that is an actual limit as opposed to the
>>> current control that is approximate.
>>>   
>>>>>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
>>>>> Yes, this will require resctrl to maintain more state.
>>>>>
>>>>> Documenting behavior is an option but I think we should first consider if there are things
>>>>> resctrl can do to make the interface intuitive to use.
>>>>>
>>>>>>>>>>     From the description it sounds as though there is a new "memory bandwidth
>>>>>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>>>>>
>>>>>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>>>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>>>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>>>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>>>>>> I hope this clarifies your question.
>>>>>>> No. When enumerating the features the number of CLOSID supported by each is
>>>>>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>>>>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>>>>>> No. There is not such scenario.
>>>>>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>>>>>> scenarios where some resource groups can support global AND per-domain limits while other
>>>>>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>>>>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
>>>>> It is not a concern to have different CLOSIDs between resources that are actually different,
>>>>> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
>>>>> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
>>>>> challenge though. Would it be possible to have a snippet in the spec that explicitly states
>>>>> that MB and GMB will always enumerate with the same number of CLOSIDs?
>>>>
>>>> I have confirmed that is the case always.  All current and planned implementations, MB and GMB will have the same number of CLOSIDs.
>>>
>>> Thank you very much for confirming. Is this something the architects would be willing to
>>> commit to with a snippet in the PQoS spec?
>>
>> I checked on that. Here is the response.
>>
>> "I do not plan to add a statement like that to the spec.  The CPUID enumeration allows for them to have different number of CLOS's supported for each.  However, it is true that for all current and planned implementations, MB and GMB will have the same number of CLOS."
> 
> Thank you for asking. At this time the definition of a resource's "num_closids" is:
> 
> 	"num_closids":
> 		The number of CLOSIDs which are valid for this
> 		resource. The kernel uses the smallest number of
> 		CLOSIDs of all enabled resources as limit.
> 
> Without commitment from architecture we could expand definition of "num_closids" when
> adding multiple controls to indicate that it is the smallest number of CLOSIDs supported
> by all controls.

Yes. Agree.

Thanks
Babu

> 
>>>>> Please see below where I will try to support this request more clearly and you can decide if
>>>>> it is reasonable.
>>>>>    
>>>>>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>>>>>> the various schemata associated with that resource. This currently has a
>>>>>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>>>>>> may be something that we can reconsider?
>>>>>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>>>>>> The new approach is not final so please provide feedback to help improve it so
>>>>>>> that the features you are enabling can be supported well.
>>>>>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
>>>>> It benefits all architectures.
>>>>>
>>>>> There are two parts to the current proposals.
>>>>>
>>>>> Part 1: Generic schema description
>>>>> I believe there is consensus on this approach. This is actually something that is long
>>>>> overdue and something like this would have been a great to have with the initial AMD
>>>>> enabling. With the generic schema description forming part of resctrl the user can learn
>>>>> from resctrl how to interact with the schemata file instead of relying on external information
>>>>> and documentation.
>>>>
>>>> ok.
>>>>
>>>>> For example, on an Intel system that uses percentage based proportional allocation for memory
>>>>> bandwidth the new resctrl files will display:
>>>>> info/MB/resource_schemata/MB/type:scalar linear
>>>>> info/MB/resource_schemata/MB/unit:all
>>>>> info/MB/resource_schemata/MB/scale:1
>>>>> info/MB/resource_schemata/MB/resolution:100
>>>>> info/MB/resource_schemata/MB/tolerance:0
>>>>> info/MB/resource_schemata/MB/max:100
>>>>> info/MB/resource_schemata/MB/min:10
>>>>>
>>>>>
>>>>> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
>>>>> info/MB/resource_schemata/MB/type:scalar linear
>>>>> info/MB/resource_schemata/MB/unit:GBps
>>>>> info/MB/resource_schemata/MB/scale:1
>>>>> info/MB/resource_schemata/MB/resolution:8
>>>>> info/MB/resource_schemata/MB/tolerance:0
>>>>> info/MB/resource_schemata/MB/max:2048
>>>>> info/MB/resource_schemata/MB/min:1
>>>>>
>>>>> Having such interface will be helpful today. Users do not need to first figure out
>>>>> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
>>>>> before interacting with resctrl. resctrl will be the generic interface it intends to be.
>>>>
>>>> Yes. That is a good point.
>>>>
>>>>> Part 2: Supporting multiple controls for a single resource
>>>>> This is a new feature on which there also appears to be consensus that is needed by MPAM and
>>>>> Intel RDT where it is possible to use different controls for the same resource. For example,
>>>>> there can be a minimum and maximum control associated with the memory bandwidth resource.
>>>>>
>>>>> For example,
>>>>> info/
>>>>>     └─ MB/
>>>>>         └─ resource_schemata/
>>>>>             ├─ MB/
>>>>>             ├─ MB_MIN/
>>>>>             ├─ MB_MAX/
>>>>>             ┆
>>>>>
>>>>>
>>>>> Here is where the big question comes in for GLBE - is this actually a new resource
>>>>> for which resctrl needs to add interfaces to manage its allocation, or is it instead
>>>>> an additional control associated with the existing memory bandwith resource?
>>>>
>>>> It is not a new resource. It is new control mechanism to address limitation with memory bandwidth resource.
>>>>
>>>> So, it is a new control for the existing memory bandwidth resource.
>>>
>>> Thank you for confirming.
>>>
>>>>
>>>>> For me things are actually pointing to GLBE not being a new resource but instead being
>>>>> a new control for the existing memory bandwidth resource.
>>>>>
>>>>> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
>>>>> done in this series but when considering it as an actual unique resource does not seem
>>>>> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
>>>>> to find all the resources that it can allocate in info/ - I do not think it is correct
>>>>> to have two separate directories/resources for memory bandwidth here.
>>>>>
>>>>> What if, instead, it looks something like:
>>>>>
>>>>> info/
>>>>> └── MB/
>>>>>        └── resource_schemata/
>>>>>            ├── GMB/
>>>>>            │   ├──max:4096
>>>>>            │   ├──min:1
>>>>>            │   ├──resolution:1
>>>>>            │   ├──scale:1
>>>>>            │   ├──tolerance:0
>>>>>            │   ├──type:scalar linear
>>>>>            │   └──unit:GBps
>>>>>            └── MB/
>>>>>                ├──max:8192
>>>>>                ├──min:1
>>>>>                ├──resolution:8
>>>>>                ├──scale:1
>>>>>                ├──tolerance:0
>>>>>                ├──type:scalar linear
>>>>>                └──unit:GBps
>>>>
>>>> Yes. It definitely looks very clean.
>>>>
>>>>> With an interface like above GMB is just another control/schema used to allocate the
>>>>> existing memory bandwidth resource. With the planned files it is possible to express the
>>>>> different maximums and units used by the MB and GMB schema. Users no longer need to
>>>>> dig for the unit information in the docs, it is available in the interface.
>>>>
>>>>
>>>> Yes. That is reasonable.
>>>>
>>>> Is the plan to just update the resource information in /sys/fs/resctrl/info/<resource_name>  ?
>>>
>>> I do not see any resource information that needs to change. As you confirmed,
>>> MB and GMB have the same number of CLOSIDs and looking at the rest of the
>>> enumeration done in patch #2 all other properties exposed in top level of
>>> /sys/fs/resctrl/info/MB is the same for MB and GMB. Specifically,
>>> thread_throttle_mode, delay_linear, min_bandwidth, and bandwidth_gran have
>>> the same values for MB and GMB. All other content in
>>> /sys/fs/resctrl/info/MB would be new as part of the new "resource_schemata"
>>> sub-directory.
>>>
>>> Even so, I believe we could expect that a user using any new schemata file entry
>>> introduced after the "resource_schemata" directory is introduced is aware of how
>>> the properties are exposed and will not use the top level files in /sys/fs/resctrl/info/MB
>>> (for example min_bandwidth and bandwidth_gran) to understand how to interact with
>>> the new schema.
>>>
>>>
>>>>
>>>> Also, will the display of /sys/fs/resctrl/schemata change ?
>>>
>>> There are no plans to change any of the existing schemata file entries.
>>>
>>>>
>>>> Current display:
>>>
>>> When viewing "current" as what this series does in schemata file ...
>>>
>>>>
>>>>    GMB:0=4096;1=4096;2=4096;3=4096
>>>>     MB:0=8192;1=8192;2=8192;3=8192
>>>
>>> yes, the schemata file should look like this on boot when all is done. All other
>>> user facing changes are to the info/ directory where user space learns about
>>> the new control for the resource and how to interact with the control.
>>>
>>>>> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
>>>>> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
>>>>> of this from AMD architecture then we can do something like this in resctrl.
>>>>
>>>> I don't see this being an issue. I will get consensus on it.
>>>>
>>>> I am wondering about the time frame and who is leading this change. Not sure if that is been discussed already.
>>>> I can definitely help.
>>>
>>> A couple of features depend on the new schema descriptions as well as support for multiple
>>> controls: min/max bandwidth controls on the MPAM side, region aware MBA and MBM on the Intel
>>> side, and GLBE on the AMD side. I am hoping that the folks working on these features can
>>> collaborate on the needed foundation. Since there are no patches for this yet I cannot say
>>> if there is a leader for this work yet, at this time this role appears to be available if you
>>> would like to see this moving forward in order to meet your goals.
>>
>>
>> I joined this feature effort a bit later, so I may not yet have full context on the MPAM and region‑aware requirements. I’m happy to provide all the necessary information for GMB and MB from the AMD side, and I’m also available to help with reviews and testing.
> 
> I understand there is a lot involved. With so many folks dependent on this work I anticipate
> that any effort will get support from the various content experts. Your knowledge of resctrl
> fs will be valuable in this effort.
> 
> Reinette
> 
> 
> 


