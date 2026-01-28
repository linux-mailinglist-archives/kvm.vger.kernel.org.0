Return-Path: <kvm+bounces-69349-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEX0MOYzeml+4gEAu9opvQ
	(envelope-from <kvm+bounces-69349-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:05:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A64C4A5110
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 871BD303B95C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FE630C626;
	Wed, 28 Jan 2026 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LAgVKRVo"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1DF81AA8;
	Wed, 28 Jan 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616109; cv=fail; b=aRFP6nyR2hnG60y5mBAmqEVzRcUyvgSAMcVe7bpYIQQ+F5aRNQFucnuPySsLpgKnP/KhXXk6GCYFQ4tQSGMFw+qBwxCDn8xpLh48AbCPqn8C/UVAv/Lzl5e0l/4Moc5lsbuclhB7kEfvfnG1U2mnxZ5G6G1iNw47sKD9EkT5GOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616109; c=relaxed/simple;
	bh=tNSm6H2X+YaKFqYgXruWfCmB5SuwFBOIjAJd1bWrsH0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GmPngQizL34H6bLBn93dr4ovUJUqlwkMRh3JR2KWwoGsgEwKWDeE1DLU455GSqF8BFo0OArpRwr4I22T0PFEiR4Xw8sAWPRqjKSKuuvSNqIRjFfE+pxBVLsIfvp0irAb8xKkdpz9szKgkrnC7b1prKLCGSinP8rm863xebmniBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LAgVKRVo; arc=fail smtp.client-ip=40.93.196.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytgorYv/088j95XkJk5UsALWlnZG8yDD/Oh5UzhjaS81gLLwfacXxAV7nJvJzKBEq19X4ECI7Em42eqlSz85aK2Fvi7sRvpa0DZHvj3HpV3ybuEhtzjeDJvZx+X57voyG9XlkhaVivZ0+s8Pc28SsRdJYkFhdChhaGY9+QRHnF6Gqgj30JYsXjMIsRjhPmz+C+gXWBMCkara9R5I/clf4TcTciyunoJt/t1L6alpeVZA6VNPgoSJGelN0lnqIq/xYqidPXRR7Ekxtq7jF3ED8eAc0qFlDXeStAPHVzDCQARyc6NOclqJcKL259PlJ4nTX7fbef3+x0SNwZYGzI+zXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjPzDDFDmhhwNaj+YmAn8nx0rf6tZuSve5TKrkbPvyQ=;
 b=rqy1wAeDdFJQIBZGtHjd1O83Uj52CW5vuWpcsB7jDUaJ9XnXPuqNi8dVDXtXukeM3TKbMxRgoQdrAhLFOzRO0aCTYtyo1WcqLCHc0TfgOTwPjvJcMSt/pfTcT1l7ezx5r0IyTp6huI5k0dOEri+BEoS6KKTTCZzpybYd6qkaWpHlHWFF1hpzeRxWLj/ze8P/I5cfR7CCNd+yXSK5GszBAr7let4JVMjgGYlkD6B4tUQOySCOHiFEwHO5JhqGtmkNiCWZW7Iris94Rg7YxZFxACKPEz7jNHSyekqsn2wNXyU2XVXMaPC4B2OrKs8zp8eiDMLQoB79K62dF6fiqEzgUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjPzDDFDmhhwNaj+YmAn8nx0rf6tZuSve5TKrkbPvyQ=;
 b=LAgVKRVoFTmcH9AAGhexVVXAR/qjDYaNebmx7Fy24A7x67OJ2yQ5G6UjTzN0C9p3tTAoWeXo6SgmSBUWXOT61AT/05KEmUf5/RXzcsCk6wFFKPVFB+ZYmDw8QC9TNjLPPJHjZWhfZJQJhYE2IdWleoBrs9xNqgrGC59KZabYK2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by IA1PR12MB8261.namprd12.prod.outlook.com
 (2603:10b6:208:3f7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 16:01:45 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 16:01:45 +0000
Message-ID: <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
Date: Wed, 28 Jan 2026 10:01:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
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
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <aXk8hRtv6ATEjW8A@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:806:f2::27) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 9111f5a3-f072-4fd0-5a23-08de5e8688e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHpheHFCR2hUYnRjYXlWbVlTdE9RNkdoN2pJUGxvejVCVE00d0VUcVdpTnEw?=
 =?utf-8?B?cHFmR2s3dGhrUHhQcllVSjgvcUFnWDlremJoUDFlRDJaeWZUSnNCWkh1dlNF?=
 =?utf-8?B?bXdkejYydm9wU2VKa2s0cFFRcGN5dmtNbGRHeHMyYnY4VTRwTFBUY3F6MEtt?=
 =?utf-8?B?YWtaUFc2b1NVZ0FnTTR3d2FReDlxV3Vrb3p5K2xNZXMxTDg4Y1FJaFdqNXN5?=
 =?utf-8?B?TkVQQXd0R0hNeTVtclNSbWQ4N3dhK0lTU0ZvR1JWeXRQSXViYTR1STZhZlcv?=
 =?utf-8?B?b3RFd1JJaHovYXVETFNCaWxiZ1c4TzZtQVk4Q3NibStyelhULzlSblYxQWo2?=
 =?utf-8?B?bjl6TmZFN2pnQVBkdlAyZjE1Qit2TUkwQ0JYbjJxelgyL21vWVlJR3o2bnRS?=
 =?utf-8?B?N2llWUd3UlJ5NWRPdGZSNUxNTk1ZdWN3TUs1c1F4RFB5dFNWVERpa2IrdEJ3?=
 =?utf-8?B?WjNxVGdjVTNHamRhRVlLSVNWYzdhK0JZMGw2cURadkRYWElOQm1oVnBJWEd4?=
 =?utf-8?B?ZDZ0ZTA0UGNKMzdKdW5TS0xQdFRkMVhYVVdxL2FQcXJ1UVBBUjI2d1NQUzE1?=
 =?utf-8?B?THZWSWFrN0VLbnlVU3VER2pPQnJkdFNPeU9rRFhBNEluM3BTUHk5aWVlRTBI?=
 =?utf-8?B?eFl6aFVlNzQ5cU1ET1NZU3p1dTF3WmIrcHNqY3FFTnpJQWNEWXduNjhYV2E3?=
 =?utf-8?B?UmRvcXk3UmFwZUFLd0hPQkRIckFsOWptbS9ncVBod2U4ZWtZZFR6SDBtTm84?=
 =?utf-8?B?ZU9hbUtsVmtNaVNHdmZyUXRKd2JOc0lMQm5tbG5LaXhkVTBJVWpRQUpSMUFE?=
 =?utf-8?B?cTJxS2N3SHRYblp2U1VNeFM1bXNMbFN0VUEvWVE2ZDdYeXQ0UjJ0RUFVekZw?=
 =?utf-8?B?T21EMmFja1B6QjkvQmlJUGVnc0ZGaUxsYldNSVJUUE14K01Ja3JLdCs5U1VP?=
 =?utf-8?B?OHNxdmwvVkpjQkMyTVgyZ0VmeldmQ3VqbmxoTXg1bi9iaDdQUjJmMHBZT3B1?=
 =?utf-8?B?UTJzYUJqTnl5VlV3RTgxcUdsU3hDNXZQQituOVp5c0hQYU9LcGJmTHVrdW16?=
 =?utf-8?B?NkJqcCtjRGd4OStMalR5OGl1TWFwdkdWNDc3a3Ywckp6M2dPOFM5UFBzdm9N?=
 =?utf-8?B?QnB0YnlIMHNsMnJ0Zk9YN0NIRGQ4TWxNT0NJSzVKVGFnUVBwRUIxV2YrdDVN?=
 =?utf-8?B?VXgydWd3Rm9raWczdE9BT0MxR0pGWGJQUXk3MSt4WUpzMjdxTTgxUlVFMDh5?=
 =?utf-8?B?aWoxMi9FdmJZM3F2MWtLTi9ORnBqWTBOUE1IOGZ6akcwSXJXTGtZVkUzRVor?=
 =?utf-8?B?SlNYWTk3bzcyaXVHd2thWSt2TldTVUhRRWZTa0Nhek5IK0FaVU9LSTEya2w4?=
 =?utf-8?B?UEx5MHBBNnNxcUNheWw5bXFsTTZJcFFGRW1hSmRMSnV4V0sySk1RcUpObWFP?=
 =?utf-8?B?Q0crZmg3MG5ZOFo5elhRakdoaytVSG9nSDVIYmJaUmN6a053WjRKTHhnd0ph?=
 =?utf-8?B?VnhCeEMzalFVbnZveWI4WGdTY2FVZHlIZGNqVzYrRE45OW5URDNaa21SdTAv?=
 =?utf-8?B?NXdDVTV4TGE1OEFSNDVsd0k5MkkxWDZkcjlqNVlzemZSL1lRa1BYM2lmc3hC?=
 =?utf-8?B?dVRSdjdPQ3htKy9EazVIc3Rld3ZNZkZwTVAyWTkzSGsrLzVTWmhXUGpWMFBK?=
 =?utf-8?B?U1pEWWFtdjd3TGRwQXVTdjhjeWg3NlYwMGI1TDdBWHRpZjhkQVd6Sm4xamlN?=
 =?utf-8?B?Y1pDTEs0R1ArM2JJekJWWVUrNWFHQkptYjlSZ0pianhpdmY1am1wTld1MFZz?=
 =?utf-8?B?REpBYXRvdmZZNmEyU1JrSGxMdVdTcS9SS0RTYisxbDZkbkRKSHZ0dWNrMXdo?=
 =?utf-8?B?eE1UMnpsY3ZBSlo2ckxoZEk3TmFhc01vWFhUNnhIeXBOcEhuUy9ZblhaZ3Vn?=
 =?utf-8?B?dmV3WHZOaUlSL1J4ZUZEM3hBRC9vZXpWNUJGS2Q3anFnangvamhjTkRoK29h?=
 =?utf-8?B?WGIwNU4xMWg0S3EvMmNySXN6eTdLL2JscCszSDdBWXQ3NnNYZGpndnBaNWJv?=
 =?utf-8?B?bzkzZGYrMDBCcWU5N1V6VC96ckVNU2JWSWt0cnZhclZES09hVXV2aTlyNVFJ?=
 =?utf-8?Q?vU9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDFKV1Fvc1lQR2YzeUNmbHlacUx4L2RrMyt4TU9XY3pKQnBheDBwc2o1d2R6?=
 =?utf-8?B?ZU1VTzlqeXF5ekdpYnlWMWhUVDBYOWpvVTJQSmtGWmgwdXZyVk5wdk4xTEpR?=
 =?utf-8?B?ajVTL2h1RE1Wa2plTzJiWVh3dXFoMjZudEI2U25QVHdsa1RpSDVEejFOSWN4?=
 =?utf-8?B?SnFHNzZSbHg5TTUvc0trQlFzakpFVlo2eUZkMjU0TWhkQWhmN29PQ3ZNK2VP?=
 =?utf-8?B?ZjM2RVBRN0I5SE1ra1k5cEVtc1VRZ1VzZUNIVUVhY3BqZzFudU9ZV21iMzY1?=
 =?utf-8?B?Q1F5VkJqZ2xvS1gwU2NDVmFlVS9Ja3JVK3pwbUlPQ3RNRGdhNGZyd0VGcG4v?=
 =?utf-8?B?OVZQZzNibngwaEFySHU2SkZERVpMaTFOejF2UVloZDJ1ZUpyRDlLWDl1YnpH?=
 =?utf-8?B?Snh4cFYwY2VtSDI1Y3J1eXZDUlREODhsbWlTUk05ZEx0ZCtDRWtBa0l5VGxD?=
 =?utf-8?B?TnpUQXpKTkF1Nkg0K1NVNzVib1ZNMkI2WVQrSGhkZTZ5clVTUGhCYTlNWnl2?=
 =?utf-8?B?RkZDQ1o3bzJzSzlWNW1TVEo1YUc4SUxjQlk5YWovcG5qKzVha3g0QW8zaTVF?=
 =?utf-8?B?SDc0R0NPbUZvWmxSSUsxeE81R1E4RGZrNW5laDFTS050VGZtUFhFK3FvV0xG?=
 =?utf-8?B?V0VKUWFGaUtXcERiTVlxV2dWWHY5cElrajZVUWNUMjVybGxHd1A3MGZGa3Jn?=
 =?utf-8?B?R3krSjU5Ukc1WStLejZ1NUJXWmJRdUQ5Z1Zpd3ErYUlGSURFVDNpcDYyOFBG?=
 =?utf-8?B?TEIrakZGZHdjN2VjaGtzazNQRVlvenVjOGpIYmpPeEFsQWxOSlliYWFiQy9r?=
 =?utf-8?B?Tm1yc3RRUXIzM0lXVGEydElzZ1V4VC9PMktpUVp2cHZ3VVpCSXlCQXFzczg0?=
 =?utf-8?B?MnlUNUJJYy9hSnNtTWtZWVRwWU9Fb3lBZjVzR2NOcFFxeEJMamQzOFVnb1ps?=
 =?utf-8?B?a3dCRG5Zd05yaWdSWWdJc20rVEFIdVVaVXZKZlpZZ251SmF3YjJweDhTRVVa?=
 =?utf-8?B?dDJhZUhnSjltU2dnMUtCZEorajFYc3FnTUVSb1VNTVNneXFXY0Zxbjd5dnJC?=
 =?utf-8?B?OGMxcGxFNlk4VVN6Si9JeGVyMkZ5cHM0QkhtSGpPMlF0VUpBOVE0Ris3d1Yw?=
 =?utf-8?B?bWtFKzhmS1VNaUwwS2pwcXUrcEhuaVNTN2JIODVHMEs5VUJJR3lONUN1TzAz?=
 =?utf-8?B?OU1sUDhMZ2lhUkkwQVNac2RIeEtWSWgxcmI5QmJrRGhCYzVQZmE4OUUyVkZ0?=
 =?utf-8?B?enVmTFUwUXJKcjNtQVdMbGpjNndQeXJ0YXNwRFFNV2FIaVZSWGtSMXFnL2ZN?=
 =?utf-8?B?NlBzbSswYkQwOUlDZ2ZZQ0FlYnFHaGI1ZUNDcXdpT1FjSVc4OG5OLzFKemF1?=
 =?utf-8?B?R1pRT2lOM3BwcU43UDhxc0IyOU9TcW9NQTVsTjRBY1VMdURHSlBpcUNyV1BG?=
 =?utf-8?B?L1ZrL2NvU0hrNEp3WnpoL0ZnbGQ0Nm5hN1hKN3orT294ZDZKeFJxNmROSFlQ?=
 =?utf-8?B?MmlubmpTT2RNSncyYVRjRFNGN24vUkRrUnFtN0llaGdjbFMyRXJ1MDZBZjhH?=
 =?utf-8?B?c05wam1MNkdyNGh5WDRPRW1OZndsb0dYbDIxaFk5ejkvUzU1Y0ZkTEU1MVN1?=
 =?utf-8?B?Z0k0RTdOM2N1ZnVqQ3Q4ZEQ3TlhaUnJ2TzlHRjRNOUVJSUVkaHBMbWQ1dXBS?=
 =?utf-8?B?Zmxyd1NLQ2xRU3loSEtUdEMyY3hGUHhqWmVQN0czOWN3Q1d0cWgyeFdQM1dO?=
 =?utf-8?B?bFZSTSt1SlZyeFUwOTlNdk5sY0RZdW5Jb1JZQVZZc1BxVjJyOGM4aWxJRlpY?=
 =?utf-8?B?bUoxUHh2SkFrZWJRM1l4L1JuWno0S2Q0V1IvZC91cHVkNDZOdTBqYzNHV3h6?=
 =?utf-8?B?OHoyOFhGVkVyVWh1aFVVSTU2cDR2QmlTaExKQXE4RnEvMWtESzh6SGhWWTNx?=
 =?utf-8?B?SUlkUGJYUjNtQzlSQlF3NjdWaFVaWk5va0RSSWNzbTBEVEVmcExZQlpXR1g4?=
 =?utf-8?B?OSt6NXJJdGJlVzBCY2pmQTBFNmp3ZDJFOElDekJnZUtCWkVCT1VUcFREbzhj?=
 =?utf-8?B?Z2V6ZmtWYkdYWCtYKzQwcWdjNEEwZWpXRTc2Y20vOUVSV3VSV25QRWdFNnYz?=
 =?utf-8?B?T0tIQytHVm8vR3hRNUc3Q2dmbU4zSnJmeno1Z09vUlc1c1pGSkhxVHFiZzY3?=
 =?utf-8?B?UG02aVVIYTlzRDl5VVpGWXhRcGJlSzViQ2haTGNDKzlsMExYQ0JxbHRPRUJm?=
 =?utf-8?B?QnZnSUtmRWVTYTNpT1pYVWkxZVZsdUVBRnd4RDlmVldMY1FFTkUwdmRrQWlv?=
 =?utf-8?Q?2B9sIoAE5U8MCrY4Z0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9111f5a3-f072-4fd0-5a23-08de5e8688e7
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 16:01:44.9912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gh3eJfEVBPCmkdOq6j2t8KaWPRMxsLvBmDjBmtAU9Zw4kYcSFtr9qjmdsiiUjW9Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69349-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: A64C4A5110
X-Rspamd-Action: no action

Hi Tony,

Thanks for the comment.

On 1/27/2026 4:30 PM, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
>> @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
>>   		state->cur_rmid = rmid;
>>   		wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
>>   	}
>> +
>> +	if (static_branch_likely(&rdt_plza_enable_key)) {
>> +		tmp = READ_ONCE(tsk->plza);
>> +		if (tmp)
>> +			plza = tmp;
>> +
>> +		if (plza != state->cur_plza) {
>> +			state->cur_plza = plza;
>> +			wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
>> +			      RMID_EN | state->plza_rmid,
>> +			      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);
>> +		}
>> +	}
>> +
> 
> Babu,
> 
> This addition to the context switch code surprised me. After your talk
> at LPC I had imagined that PLZA would be a single global setting so that
> every syscall/page-fault/interrupt would run with a different CLOSID
> (presumably one configured with more cache and memory bandwidth).
> 
> But this patch series looks like things are more flexible with the
> ability to set different values (of RMID as well as CLOSID) per group.

Yes. this similar what we have with MSR_IA32_PQR_ASSOC. The association 
can be done either thru CPUs (just one MSR write) or task based 
association(more MSR write as task moves around).
> 
> It looks like it is possible to have some resctrl group with very
> limited resources just bump up a bit when in ring0, while other
> groups may get some different amount.
> 
> The additions for plza to the Documentation aren't helping me
> understand how users will apply this.
> 
> Do you have some more examples?

Group creation is similar to what we have currently.

1. create a regular group and setup the limits.
    # mkdir /sys/fs/resctrl/group

2. Assign tasks or CPUs.
    # echo 1234 > /sys/fs/resctrl/group/tasks

    This is a regular group.

3. Now you figured that you need to change things in CPL0 for this task.

4. Now create a PLZA group now and tweek the limits,

    # mkdir /sys/fs/resctrl/group1

    # echo 1 > /sys/fs/resctrl/group1/plza

    # echo "MB:0=100" > /sys/fs/resctrl/group1/schemata

5. Assign the same task to the plza group.

    # echo 1234 > /sys/fs/resctrl/group1/tasks


Now the task 1234 will be using the limits from group1 when running in 
CPL0.

I will add few more details in my next revision.

Thanks
Babu

