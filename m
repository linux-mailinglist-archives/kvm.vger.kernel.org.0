Return-Path: <kvm+bounces-38407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA41A396FB
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A79C13AC914
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0874222FE0A;
	Tue, 18 Feb 2025 09:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G0nu0NFb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D1922FE02
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870369; cv=fail; b=XzCM7yhBb8KlHNUWQv9kJrlKolq83VuuMB1DxRGqLjRtqSPXX022ZEAOZ4hjjvAqBU0+7EoPtfqEZSDnK+q5KAF1fieseDowi1oKtL1AlOqSyEG78BSuWUpX+OzfCohFeCvAIX1Z+qI2QouuaGV+U5EhjLmfBh7WvR+a3JcNsJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870369; c=relaxed/simple;
	bh=8Fkhoy9uoEQFBxvS/q2ODic3M5kqvaTruaAgR7IJna0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jrYe8USXliGR+vSLyUCiDCiT36Yo5ZKEAeAETbHvljpGudmDz3VJl+v+u01XkFMKAx8dl4DYEOk6uxlg5Cm3QYFXg7h9gYo8rMecZIjM7V+JU26jXiDN9R3B/pRjG1PA/v4V51QWEYiMOA0NsulbSL8KmW2l6myrmNKw2JQTrz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G0nu0NFb; arc=fail smtp.client-ip=40.107.96.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2K+4Cm8ms1+Kdaqz5V7MyDw+/Xk70CLUdbEbhiKUeEqxK+Bzn8539ZXoIJhtZbmADwoo3ghk5UPrqL1TcjQ66kOu+Y7ayaGPnj30zKWpnOOKV91F9Qtf1P+KhuH+WZheWkA8QngOiw4uhB+8Tkns2xWxH9a0ltE61Saa20iexdRmnrfeCZ4bP6n4OoAGgl6fwrcg6cDZguwPDqKMj544wGGVyvXU8Xt2cqawTF4eKsWgM8tgJkVzMORCRrTyh1jr5dCPbkh2kgu98DzIoDPC95zMd/kyffPf+y/bnaMd1JVTLpa1j5Fi/fFX0Gkzox67agQ95mSluRtfR+nz6CyDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoTYyGV34oky+okjgz6lVDXYz8anUBJKENOiaAHO1dM=;
 b=WhgTyWKeTmiyowpdUran0Irs9dtkb3NyOeF1NzYOIpxYurPNq+c0LD795VvWjpyPuqxAZTRioOH/LkdR0ILoB4BpwvIV/4NtFGPb309ll3TGbz3CFJtBHkO0BV40fs59gH1maZ64fArkBTuJIy3YNncU+lfzDHydXLYM7U8BE1+MNFRAIsnFnSD+ipDqnFzqtyq+uyAYL9ONY+/DRcNaHBxHoudZ3MrqWM/UchQUFQsEiCZT7+1HPPi0TsbfyRh1ssqbmduWPUgE22ObOOS71OiNyeq9tF+n3YD+9aa53LnteAT4R5+ko2ZKXLqI7umPTZZOEsbGj3TJWD9bCJEXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoTYyGV34oky+okjgz6lVDXYz8anUBJKENOiaAHO1dM=;
 b=G0nu0NFbns7VgCJVktUm+YF+uKlfSyAIJl/E/KkZSMDhKXfVDrwV1AAbyBfe8idLD6fX8RCI2R2dzVxISo4MNh1AcEG25xeyrRhHXGruj3irhHJ93u5OGdtq5WOu6mI041Q4QxrvQdX5xu+0SJIrBjMM7VsUbRe1Dm7O0ZEh+zI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Tue, 18 Feb
 2025 09:19:24 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Tue, 18 Feb 2025
 09:19:24 +0000
Message-ID: <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
Date: Tue, 18 Feb 2025 20:19:15 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 3/6] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-4-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250217081833.21568-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0034.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20b::24) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d96f3f5-e3b0-4b40-3319-08dd4ffd5611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mml2VVJJK1RxU0g0K3pRQ1BqUllTMHJXOTlkYjZodzM2a2ovd1dFRnhFYk1M?=
 =?utf-8?B?MGI0RUNkOG8yNlo4Z20yYWVkOU90OWROOUorT3BsdFhLemNrYlRxTXFKNkhu?=
 =?utf-8?B?YzBZVWJ6WUM4SzFEc1pzNmFxazJLaGMvWkNSYk5QS1h2OWFDZEpEenVkL1Yv?=
 =?utf-8?B?QnAvbzhVanowdTFYa28vNVR1OTJwcjVnMVRIa1dUemJsa21PVkdaNlJtVVhh?=
 =?utf-8?B?UThSdjFweCs0SzVqL0x1SjRWVzB2em03NW0vYjFQLzF3M0JINlRyVWM2cVBq?=
 =?utf-8?B?R0ZxUDdZTU1YMlZycmJST0JMR3MrR1FXMDNaWVFNa1I1REFDM1lCelhORWxL?=
 =?utf-8?B?RlY5Sis3cG1VdjRicWtwOXRZbUI1eUl2eVZaaFdDekE1Tmp5ejUrVHIvU3Er?=
 =?utf-8?B?WUZ2MWIvQ1B2QU5sVlU1ZkU3eGdWR1lURWcwMXV1NDk4QWs3YmtZdE5sNzVi?=
 =?utf-8?B?SzdhejRpenlDZWg2dXlHRFJyU01iQWF2WE01blpybTBHK1lndWZhcjJUVEJF?=
 =?utf-8?B?bWFoUmpHMklUR0RPVkxPdkxjeEZxS295K2NSSzlSeWdmcUlXWmNVcVBPOU9H?=
 =?utf-8?B?UWxMNGgvSW1COFZGNXVLU1A1a3BXaHVOeWgyT0NUV2wzMnhoUDlMTEpkYmlm?=
 =?utf-8?B?WWVyYUNPS0JQNnBINDRoOHpUMVJ3c1lnTXdkclNOT2huUzZva3hEbWpFd25Y?=
 =?utf-8?B?WlVCU3E2ZVRHVTdsUjUyaWpQYXJVZnNEOTZMaXJOcXZCSDR4MFhheEJMYnRv?=
 =?utf-8?B?aGU1R1d2UEQxYkNYV1R4WXRrKzlSaFdUZUE5dE9FWUxoSDZCa21hVmRadjdB?=
 =?utf-8?B?amZheG9LMGxXOUdlUHVaMDZvOVVQYm5GQkZHN3JJM3Y3OXhRS2N1WHVhdllC?=
 =?utf-8?B?cG1Wa1gzTXhKNmVlOS9GTXYrZi85SHhscnR0SkNRL0p4bG1RazlCL2c1RGM0?=
 =?utf-8?B?blNOTlBtRFVjZzhzSFR5TTN0Z3c1WjdXY2lHUDIzVWk1MS9BbEd6bTFQZTNL?=
 =?utf-8?B?L2ZIWmQzQ0l4YTh6YjQ1TWVtUVBCWXUraldQSGVXZDN4dGczVHpYUG01U3dS?=
 =?utf-8?B?SGFhMWpKbmFZN3BNdmRWNnN6YytxeFQzTlhhYVozeFAwVGZsdURlZmFQeWVP?=
 =?utf-8?B?VnJid0wxN0QvMzM1NXFwdU44UGJMMUcwYkZZRWUxU28vMHhXZmZhMm84SEdV?=
 =?utf-8?B?alpuKzA1dE5JWW5XL3EyMTVYaXZIOE5PVDhJdVdKbGVNZTJkOTRUbmFLR21H?=
 =?utf-8?B?Zy9zY2RtSUY4SXlmRGt1MmRueW5xYlIwM014d052b0tZOFIzZEgwWkp2ZWNG?=
 =?utf-8?B?N3FWcFBTY1dwcUhsbmo2TS9KRjk0d3lSS0FFWGdPVldvcWIvU1pzSDNSUGc1?=
 =?utf-8?B?ZWNGYTVxUVoyZXZ5ODRpaER5c3Z3cjRJUFRuV3JWZHVzd01hSFBtWE1Rajk1?=
 =?utf-8?B?UTJTQ3U3M1hvZmgrM3A5VEN3OUxzWXZXUzNSUWc1R2JvQXljd0tZazRISkR0?=
 =?utf-8?B?Zk4rTkM2dW41UmxDTkdRclNaeGE2aFJYa2NCQmRCRzlHaU1uQVgzSXhNOVND?=
 =?utf-8?B?M0pVVjBmTThDVXJiVjBMOU8zVEYrYXYyTTZSeUJneFJwdlNScnVvZE95SjVH?=
 =?utf-8?B?b3dNOWR0UnovRFNNZWJwWVp0L1FYaHNsWjFyVEszcnFmRTR5ZmtHT1NOUVM3?=
 =?utf-8?B?YXh2QXdsN3RWdHhvbDJvcXA4M1JGNzhYQmYyR25tOVNOdmM3M1NtVURMOTBs?=
 =?utf-8?B?YzdndDN5VitKQVBjckF0eC8vcHNIY0Z6ZEZ3OGpucFVwQVJQSWhOLy9BaTVB?=
 =?utf-8?B?SFdvNnNZbkJtb0hnVTQ3OGJlZGJvWGhCTmVndlEzejVnejJvV3NLZzl1ZXhT?=
 =?utf-8?Q?JlJs81oTLqJaC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1VDbjRyYVVvQmRuaXo0b2RBRDk1MHVHQnY2UVV2Mm9xakxKUFdDd2pTNmJr?=
 =?utf-8?B?NjgrM0RDZXh1andpc2pRTldlMWpyY3RLbHp5MzZwZEtDTnJ0OXVpVnhoM01t?=
 =?utf-8?B?VkdYVU9pdXUwQ2tWWG9BcXU0NCs3a29zekpEY1RFc0JmU2JXM1pjQTNQUEFx?=
 =?utf-8?B?R29KQXM2REd0b0hZaWFRaVI5dU56WEthZXhWTSthOXFkOXdsdTJzeSt3QnRJ?=
 =?utf-8?B?c2lVMTZlTFhwU25PQXlBS0J2aktJK3V6Mkk2VkV4dmk0VFVZSG1ielREWW9K?=
 =?utf-8?B?S2hXYmVTb0lLaTNTNmJRMTNFYXUwaEVBRTJ2MERCUC9CNjJLT1AvN3JXd3U1?=
 =?utf-8?B?M0dYTk1PQW8zUHVDUjBSMGZoRExzUnhWYTY3UjhRK3NON0d3aGJvSVZnVy82?=
 =?utf-8?B?MUpTeWhTYjBzMEc0aXMrQ2l5U0hYQThISXhjVGtzWG1yTHkwT1IwS1d3VmFp?=
 =?utf-8?B?SlppQm9FbTg4SjFOc3lHVGhjVTM1T0lqcXptZzBFRnZUWHpNS2xQaVlHOFY5?=
 =?utf-8?B?aGsxVzRiOFBhWjM2Q3daYmllU1lKRmhKdytKY1B2SVVRSkFGQnFXY0Y4Q3NR?=
 =?utf-8?B?RXlTVE5JUVhyU20vNGdGRS9tOEpqci8rVUVXY0xUSURyY3dtR0FFYzFGbWg2?=
 =?utf-8?B?MTc1MUpzd1I0UWlnNW1Od1F4dzlHV3BhYkEyb2ZlMER3S1lxL1lyMDk5emor?=
 =?utf-8?B?MmdRK1B5b2ZKOFUvVGxpTFF3b1NjMGRnKzlGclBoaUo4SDQxSVZoNjNicjkv?=
 =?utf-8?B?cHR4ZHE2cTB5VmhDY3FWVmluYkZGSEtxUUc5aWlqME1XTWw0RjlFNnROeEcy?=
 =?utf-8?B?UzBjR3EvSC9LNkxCZkN0Tm45ZVMxQ3VwNHovOHhWS3Y0c2U3aGpReFUycEYy?=
 =?utf-8?B?eEwrQVBKZWlBQVhVenQrelNmS2RzNWdvczV6M1loaWFjTjlvcmdYeHlLNlNw?=
 =?utf-8?B?NXhoWU1GWmxwNktHWVloc2NOak1KUEpHeURoNVRVZXN3a2VyN3FBd1dQYS9x?=
 =?utf-8?B?amZiN0ttNGsvUGdjUVV5ZjFaUVJxbG82TXhTT0VnU3p1a2pBTURQVUVjekJF?=
 =?utf-8?B?L0hHUVRscjFUeUJEWjZINW4rRHI1blZBd2ovcFBNU2JUcnBMTWRySXAzbU1X?=
 =?utf-8?B?VDFKR01GUFBVcWZRUlJjWHA1bnh0QkI4WUROMHcvVGdDVkZUamRRRzFYL1gw?=
 =?utf-8?B?LzhKT0ltbThlaHZOVWMvV2RINzZpejVmSWxBNjM4YStKcE5CUml1OVNJdlNy?=
 =?utf-8?B?ZmI4S1ZpQ2lkZWsvbmZHdG1adVkrcjF0bGZhb2l1Z0Foc2ZiYWwvUFNYa3cy?=
 =?utf-8?B?bHlxUmJlVVdwOW82VEpLWWh6WTJPZHUrN0w0SlFZK28wMjVGYTBGbGp2Qk5o?=
 =?utf-8?B?cDAvMEZrMFhhQkJRODVmVHlNVDVkSnlHdFIyZFBNVldGbHNobVY1dWZIWGRm?=
 =?utf-8?B?WEVyVmpuWklUbEc5cWZhakZsYVpvR1QrWStJdThQbVY4SWk4S0FBVi81cnhK?=
 =?utf-8?B?bjFqUks5MGk3Qm1pNTRjVFc1dDB2MFR2N3JKckVuR0pTczBqRmJlU1NKVDRL?=
 =?utf-8?B?UHAzT3hqN3p1VWw0aVUzdXR1WS95b0paMmxMNUpDVVdIckNTc2lyb0NGUzcz?=
 =?utf-8?B?SUEwNHRmdmVyUVU2YkorcVM2TytwTFpKd1FWOXpxM3F3VHo5RW1kVG9UZ3BN?=
 =?utf-8?B?OEFTR0FYNXEyNGpBOEx1dHlSRXVJNFFkZmVPQXViVUd2MHgra2Y4dkRuTTRq?=
 =?utf-8?B?Y1M4QUhuV0oyb1FFbDJ3TXczV291N1J3SXhmdnB1QjVlL3A5S3VDUXh1K1hw?=
 =?utf-8?B?ZDZzNHRXdmZJcFNPaXptNU43NnNHVVlTd1E3cjNsRzdGOTBWVjJ2Z09iSGoz?=
 =?utf-8?B?SnhkVVcwK3g4WklXL2hqV1M2MEhjZmM0MStrRGV5YUxuZ011d1lYYUxVc2RL?=
 =?utf-8?B?dXArUEVCcjg2WWhCTFU1VkorbzQ1a0FDUW1PZUo2eldXM2N6eTRMOGl3ckkv?=
 =?utf-8?B?ckJ5c0gzOEQwM2Jadnp0NUF3ZzVMRDBPSm4veUZDTVQ0NnFxZDdmUlpLK2Zz?=
 =?utf-8?B?ZytobjlFcEtqS1M3WGVRMVZnZjBxZWhTdnp2WlNWRWoyekFROGxPU0JuZ2c3?=
 =?utf-8?Q?4ET9EmB/S3fAisREHAmYM1Rly?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d96f3f5-e3b0-4b40-3319-08dd4ffd5611
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:19:24.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nA/YUfohL+rJ2s4yKZN8mphgZEG7fEkgJ2UBts+AKQN5LddIAKVpYq0oLL9LlckoVGJfOHqiO77wIbkGyzTCWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115



On 17/2/25 19:18, Chenyi Qiang wrote:
> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> uncoordinated discard") highlighted, some subsystems like VFIO may
> disable ram block discard. However, guest_memfd relies on the discard
> operation to perform page conversion between private and shared memory.
> This can lead to stale IOMMU mapping issue when assigning a hardware
> device to a confidential VM via shared memory. To address this, it is
> crucial to ensure systems like VFIO refresh its IOMMU mappings.
> 
> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
> VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other. Therefore, similar actions are required for page
> conversion events. Introduce the RamDiscardManager to guest_memfd to
> facilitate this process.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> RamDiscardManager interface. One potential attempt is to implement it in
> HostMemoryBackend. This is not appropriate because guest_memfd is per
> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
> particular, the ones like virtual BIOS calling
> memory_region_init_ram_guest_memfd() do not.
> 
> To manage the RAMBlocks with guest_memfd, define a new object named
> MemoryAttributeManager to implement the RamDiscardManager interface. The
> object stores guest_memfd information such as shared_bitmap, and handles
> page conversion notification. Using the name of MemoryAttributeManager is
> aimed to make it more generic. The term "Memory" emcompasses not only RAM
> but also private MMIO in TEE I/O, which might rely on this
> object/interface to handle page conversion events in the future. The
> term "Attribute" allows for the management of various attributes beyond
> shared and private. For instance, it could support scenarios where
> discard vs. populated and shared vs. private states co-exists, such as
> supporting virtio-mem or something similar in the future.
> 
> In the current context, MemoryAttributeManager signifies discarded state
> as private and populated state as shared. Memory state is tracked at the
> host page size granularity, as the minimum memory conversion size can be one
> page per request. Additionally, VFIO expects the DMA mapping for a
> specific iova to be mapped and unmapped with the same granularity.
> Confidential VMs may perform  partial conversions, e.g. conversion
> happens on a small region within a large region. To prevent such invalid
> cases and until cut_mapping operation support is introduced, all
> operations are performed with 4K granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v2:
>      - Rename the object name to MemoryAttributeManager
>      - Rename the bitmap to shared_bitmap to make it more clear.
>      - Remove block_size field and get it from a helper. In future, we
>        can get the page_size from RAMBlock if necessary.
>      - Remove the unncessary "struct" before GuestMemfdReplayData
>      - Remove the unncessary g_free() for the bitmap
>      - Add some error report when the callback failure for
>        populated/discarded section.
>      - Move the realize()/unrealize() definition to this patch.
> ---
>   include/system/memory-attribute-manager.h |  42 ++++
>   system/memory-attribute-manager.c         | 292 ++++++++++++++++++++++
>   system/meson.build                        |   1 +
>   3 files changed, 335 insertions(+)
>   create mode 100644 include/system/memory-attribute-manager.h
>   create mode 100644 system/memory-attribute-manager.c
> 
> diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
> new file mode 100644
> index 0000000000..72adc0028e
> --- /dev/null
> +++ b/include/system/memory-attribute-manager.h
> @@ -0,0 +1,42 @@
> +/*
> + * QEMU memory attribute manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
> +
> +#include "system/hostmem.h"
> +
> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
> +
> +OBJECT_DECLARE_TYPE(MemoryAttributeManager, MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
> +
> +struct MemoryAttributeManager {
> +    Object parent;
> +
> +    MemoryRegion *mr;
> +
> +    /* 1-setting of the bit represents the memory is populated (shared) */
> +    int32_t bitmap_size;

unsigned.

Also, do either s/bitmap_size/shared_bitmap_size/ or
s/shared_bitmap/bitmap/



> +    unsigned long *shared_bitmap;
> +
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +struct MemoryAttributeManagerClass {
> +    ObjectClass parent_class;
> +};
> +
> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
> +
> +#endif
> diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
> new file mode 100644
> index 0000000000..ed97e43dd0
> --- /dev/null
> +++ b/system/memory-attribute-manager.c
> @@ -0,0 +1,292 @@
> +/*
> + * QEMU memory attribute manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "system/memory-attribute-manager.h"
> +
> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
> +                                   memory_attribute_manager,
> +                                   MEMORY_ATTRIBUTE_MANAGER,
> +                                   OBJECT,
> +                                   { TYPE_RAM_DISCARD_MANAGER },
> +                                   { })
> +
> +static int memory_attribute_manager_get_block_size(const MemoryAttributeManager *mgr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
> +     * Use the host page size as the granularity to track the memory attribute.
> +     * TODO: if necessary, switch to get the page_size from RAMBlock.
> +     * i.e. mgr->mr->ram_block->page_size.

I'd assume it is rather necessary already.

> +     */
> +    return qemu_real_host_page_size();
> +}
> +
> +
> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager *rdm,
> +                                              const MemoryRegionSection *section)
> +{
> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    uint64_t first_bit = section->offset_within_region / block_size;
> +    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
> +    unsigned long first_discard_bit;
> +
> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
> +    return first_discard_bit > last_bit;
> +}
> +
> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s, void *arg);
> +
> +static int memory_attribute_notify_populate_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    return rdl->notify_populate(rdl, section);
> +}
> +
> +static int memory_attribute_notify_discard_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    rdl->notify_discard(rdl, section);
> +
> +    return 0;
> +}
> +
> +static int memory_attribute_for_each_populated_section(const MemoryAttributeManager *mgr,
> +                                                       MemoryRegionSection *section,
> +                                                       void *arg,
> +                                                       memory_attribute_section_cb cb)
> +{
> +    unsigned long first_one_bit, last_one_bit;
> +    uint64_t offset, size;
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret = 0;
> +
> +    first_one_bit = section->offset_within_region / block_size;
> +    first_one_bit = find_next_bit(mgr->shared_bitmap, mgr->bitmap_size, first_one_bit);
> +
> +    while (first_one_bit < mgr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_one_bit * block_size;
> +        last_one_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->bitmap_size,
> +                                          first_one_bit + 1) - 1;
> +        size = (last_one_bit - first_one_bit + 1) * block_size;


What all this math is for if we stuck with VFIO doing 1 page at the 
time? (I think I commented on this)

> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_one_bit = find_next_bit(mgr->shared_bitmap, mgr->bitmap_size,
> +                                      last_one_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int memory_attribute_for_each_discarded_section(const MemoryAttributeManager *mgr,
> +                                                       MemoryRegionSection *section,
> +                                                       void *arg,
> +                                                       memory_attribute_section_cb cb)
> +{
> +    unsigned long first_zero_bit, last_zero_bit;
> +    uint64_t offset, size;
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret = 0;
> +
> +    first_zero_bit = section->offset_within_region / block_size;
> +    first_zero_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->bitmap_size,
> +                                        first_zero_bit);
> +
> +    while (first_zero_bit < mgr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_zero_bit * block_size;
> +        last_zero_bit = find_next_bit(mgr->shared_bitmap, mgr->bitmap_size,
> +                                      first_zero_bit + 1) - 1;
> +        size = (last_zero_bit - first_zero_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_zero_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->bitmap_size,
> +                                            last_zero_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t memory_attribute_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +                                                         const MemoryRegion *mr)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +
> +    g_assert(mr == mgr->mr);
> +    return memory_attribute_manager_get_block_size(mgr);
> +}
> +
> +static void memory_attribute_rdm_register_listener(RamDiscardManager *rdm,
> +                                                   RamDiscardListener *rdl,
> +                                                   MemoryRegionSection *section)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(section->mr == mgr->mr);
> +    rdl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&mgr->rdl_list, rdl, next);
> +
> +    ret = memory_attribute_for_each_populated_section(mgr, section, rdl,
> +                                                      memory_attribute_notify_populate_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +}
> +
> +static void memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
> +                                                     RamDiscardListener *rdl)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(rdl->section);
> +    g_assert(rdl->section->mr == mgr->mr);
> +
> +    ret = memory_attribute_for_each_populated_section(mgr, rdl->section, rdl,
> +                                                      memory_attribute_notify_discard_cb);
> +    if (ret) {
> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +
> +    memory_region_section_free_copy(rdl->section);
> +    rdl->section = NULL;
> +    QLIST_REMOVE(rdl, next);
> +
> +}
> +
> +typedef struct MemoryAttributeReplayData {
> +    void *fn;

ReplayRamDiscard *fn, not void*.

> +    void *opaque;
> +} MemoryAttributeReplayData;
> +
> +static int memory_attribute_rdm_replay_populated_cb(MemoryRegionSection *section, void *arg)
> +{
> +    MemoryAttributeReplayData *data = arg;
> +
> +    return ((ReplayRamPopulate)data->fn)(section, data->opaque);
> +}
> +
> +static int memory_attribute_rdm_replay_populated(const RamDiscardManager *rdm,
> +                                                 MemoryRegionSection *section,
> +                                                 ReplayRamPopulate replay_fn,
> +                                                 void *opaque)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == mgr->mr);
> +    return memory_attribute_for_each_populated_section(mgr, section, &data,
> +                                                       memory_attribute_rdm_replay_populated_cb);
> +}
> +
> +static int memory_attribute_rdm_replay_discarded_cb(MemoryRegionSection *section, void *arg)
> +{
> +    MemoryAttributeReplayData *data = arg;
> +
> +    ((ReplayRamDiscard)data->fn)(section, data->opaque);
> +    return 0;
> +}
> +
> +static void memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                                  MemoryRegionSection *section,
> +                                                  ReplayRamDiscard replay_fn,
> +                                                  void *opaque)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == mgr->mr);
> +    memory_attribute_for_each_discarded_section(mgr, section, &data,
> +                                                memory_attribute_rdm_replay_discarded_cb);
> +}
> +
> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
> +{
> +    uint64_t bitmap_size;
> +    int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret;
> +
> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +
> +    mgr->mr = mr;
> +    mgr->bitmap_size = bitmap_size;
> +    mgr->shared_bitmap = bitmap_new(bitmap_size);
> +
> +    ret = memory_region_set_ram_discard_manager(mgr->mr, RAM_DISCARD_MANAGER(mgr));

Move it 3 lines up and avoid stale data in 
mgr->mr/bitmap_size/shared_bitmap and avoid g_free below?

> +    if (ret) {
> +        g_free(mgr->shared_bitmap);
> +    }
> +
> +    return ret;
> +}
> +
> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
> +{
> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
> +
> +    g_free(mgr->shared_bitmap);
> +}
> +
> +static void memory_attribute_manager_init(Object *obj)

Not used.

> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
> +
> +    QLIST_INIT(&mgr->rdl_list);
> +} > +
> +static void memory_attribute_manager_finalize(Object *obj)

Not used either. Thanks,

> +{
> +}
> +
> +static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
> +{
> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
> +
> +    rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
> +    rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;
> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
> +}
> diff --git a/system/meson.build b/system/meson.build
> index 4952f4b2c7..ab07ff1442 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -15,6 +15,7 @@ system_ss.add(files(
>     'dirtylimit.c',
>     'dma-helpers.c',
>     'globals.c',
> +  'memory-attribute-manager.c',
>     'memory_mapping.c',
>     'qdev-monitor.c',
>     'qtest.c',

-- 
Alexey


