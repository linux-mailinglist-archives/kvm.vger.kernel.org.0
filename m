Return-Path: <kvm+bounces-55266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7369BB2F5CB
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 12:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C92BAA2ADC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 10:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4729B309DA4;
	Thu, 21 Aug 2025 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V7D8BXKw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBDA2ED17C;
	Thu, 21 Aug 2025 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755773944; cv=fail; b=nRmt6vxuYKQ+D6zgfJTa7ZcqBQij82TwfF/fcMInNZaQFYFq1UL569z6LZfpRucvQIhFhKz1cmNU7FvqpEzUrMUJ3aYID578Vqqj+N2SXMzLdCRB2l+kzKIUnlxa5NwVWq9qjqpdBpQPdc1hMiDueGH0SfZ05Myd84pM0LlcWnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755773944; c=relaxed/simple;
	bh=DwjH+gFgAKJ3cUrwp/Y37UuQKNWy83IOZmoWXDqQLwA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e5vUOi/g3Jn+ctp1Gazc64K+W0JCuo5qQoNIH2ew8xjPd+X9VrJl9so+1b3BEg1C7jRjm2H6Iy6r62ijjTzcXl8zHB6EIv15tJIPu6a+gamQ9iBeEwxO/9+F9TzISq/gVrjZTISCmaQSInrxMVYyRWX5d2d2C9fO2hIwliqGJhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V7D8BXKw; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xq4txUP2YM4ggAnoTEjFBv/tLdZkbAIFASFw6cbuzgThdlYmWfFka5GE0YYiPVBfQZ9VdeEvQvWzGMdzolp+ghnySVpKYxU5RQXc83bmrBfd7f3bDvJj4tgCLFrfXkDgjr5KIYb9Eef21KKSYfFsvDLfkc7uvewI/UozAgC64oSC+BdtGmL35pzb2u+fK1bnJaxdSPjuQnkk3hkESzO9ZM7eO4JySUGtqUd2gHO71vPG2qGZLNqCQ3Rla3/HRb8uE2WSy9iU+3RxKqQoP4ezu7AfV8r2/Zx/Wvg7Nmwl0up/p3RsdcEHKkTTzuot0dSRWFLGYY8QEfrLegG+TlA+bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLRHRBJhLl7yl60qhINGcd+d4NJPe1glgNabJHahmeY=;
 b=VzgPrSECT/7ryVqsiFXo05MP1wg4bAaaQpURAyMt4JDF2PzQUBVerOyKtLzZQJwUIR55VtKnKTZbfgOKx37lebu0VGQTwSsz0rfr0nCCuhFJbKKaUKL491IqH7PfMuYOL3AK8BOSEh12FvYEd+eVaqfmwpoqYgjJMRiMXyhzPaAxqDwrSYua59imZZpR7kuvh1mQyZ8MAHNPaRcQGOa2bklGy4C71g/Ecw2oXYmyJjHFmlR4DNL5L4N7bePJj87Kd6/TfZY+O95Ibk3tCy7aqm/3GRMmjuqYLLVsJ+dGVAvJgKVaov9ALBWRec2CAyCfoiW3kHmY4z9oCma92UD7LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLRHRBJhLl7yl60qhINGcd+d4NJPe1glgNabJHahmeY=;
 b=V7D8BXKw9+jvBDgJT7CXKG4GJ5wGZvbkAd5GEK+2QXGIAyYI2y5rSSCB5N9ODwaVnoj094N4kiD4kSDqKAYQxwiBT/vSk2WZPbWfUF3PNjR3eBLQwwKfho4cdxAPf/oEluHhbvuIHpzWASVPX8tr4DiY7c/DxFofWxVzap6TP+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Thu, 21 Aug
 2025 10:59:00 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Thu, 21 Aug 2025
 10:58:59 +0000
Message-ID: <db253af8-1248-4d68-adec-83e318924cd8@amd.com>
Date: Thu, 21 Aug 2025 05:58:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>, Randy Dunlap
 <rdunlap@infradead.org>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org,
 michael.roth@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
 <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
 <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:806:6f::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM6PR12MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b111e0-f51f-4e2d-8fff-08dde0a1bb76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXJrajMzclZ3Y1I4cFpSQTRJQXVxUFZFTmhreU5aY2ZIcUdvTWp0ZkJZSHNv?=
 =?utf-8?B?WTAvdGZ3NWd5L0owWWxOUjc5aDFTMXlGT2tSUGpIVjN2RDV1QWttblZvQVZQ?=
 =?utf-8?B?eG52QUcwbjdmTjUvbmxuS3RKckhnbFpoUzZzMGJndld2UndoNmp6NVpsajJv?=
 =?utf-8?B?RWRjNDZkRUQzK25DNGpmUG9paTQxUDNyZlNGU1cyNnZWQ1RmZXpxOXhkZWVu?=
 =?utf-8?B?bUJTMkhZVlRjWVhIWEI0WklkTXZCOW1nTHBJV1pmMUlDdnNjQUgrSGd3eVZG?=
 =?utf-8?B?SXZueXpUVnBxWDRJZ2Fvd1UxVXZjM1VuT0ZYTmVRN1VXQkdIcURIZjJqOGdZ?=
 =?utf-8?B?QjltcmFrQlJtbkxLQ3huV2ZVRldJNy9ucE5RVk1WNXRyZHBTSHJBSklzbUlj?=
 =?utf-8?B?NThMTHBJbnZ3S1lDa3NmTU9rWmxNZ1hxamk0M0N4RjJ0b2tPdlhxUWFnaUZo?=
 =?utf-8?B?Y2E4S0FuZXUrVFNuOG8yZzloY05FdHpZbk9QMk5aQncxaTBTVDdGcGQxYlRK?=
 =?utf-8?B?bEw5amZqejRuMkIzeXl4VzM1RURsUHE1NWI0bkxGYmRxc3ZXbkZpTXRIWWlY?=
 =?utf-8?B?aExFcThud05FckNPY1VLektLZU1SMXdXMUNrUDFySzlRN21SQXBRZVRuNXZV?=
 =?utf-8?B?RU80QnNjK1ZjRWh0SDlBY3l3YmFpZVE1bjQ5cHR2OTZuTkRKVWtBR2RMQnJ3?=
 =?utf-8?B?bVcrMUlSUFI2ajZTNVI1QzJqSkpVaHlucmxBck5SanFIeUEvdjVZZENCc0JT?=
 =?utf-8?B?aG9nRVlqRUpHMDZ1OHZNc1NlLzFsUjdnYzcrMWlnRWRPaGQ0LzF4eDZ6NzRG?=
 =?utf-8?B?OVhudmxHTVBORDlkTHMySWpEaW5qQ2dWTXVnOGZ6MnROeGovM1BkWldhYWJM?=
 =?utf-8?B?QWFiOGVBTTdhZ080cmtzbkZXRkJ3cFJCcTFvZUdpSWpjdDNVWU8xV2NwOUIx?=
 =?utf-8?B?MWdWTGMvK2drc3BrakNVaGhzemZYcjlHZXI5a3NRZTJvNGpYS1pabzR5d2VQ?=
 =?utf-8?B?WjV2bFVwcWN5V3Zvd1RoQ3E5UENaUFRKVjkweWxjSEx0cVpXSkhRem1EQWdM?=
 =?utf-8?B?Zy9SM3QvRysrM2gvQlRFQ0xDMXdFSWVJQTFDb0VGUGNaQWxOZ0QzQm5RUVJP?=
 =?utf-8?B?WklFOTQ1NTg2enNtRHNNTGl1S3VHc0s2RUlYMXNGWVBGKzZWeG5TN3Q5b2kw?=
 =?utf-8?B?NGF0Vk9xM2doZm1mZE9sTGRYcVVFRWFBSi8veG5meTBwU1ZJUFpqa1RqSDly?=
 =?utf-8?B?WEVrNWZIaUd6b1JNQk1MZlRyMVUyRytnNEw5Z3kxS1dsM3BPQWRXTXVmTTZq?=
 =?utf-8?B?eDBVT1pZSXBPb1JVWmdlNHgySHl4YndHSlRmUmhrbVROZlJDS2tKM0ZQckJX?=
 =?utf-8?B?c0xCY2tDek1SM2htTi9JWm1qZ3RtN0d2VWpJT25wR250R3dDbmFEemJSd3RD?=
 =?utf-8?B?bGp0VzF0YXFmbUJMUmRQSjRwMzJHSUxVV0xvazZTNElqMFhreis3TEs3ODVr?=
 =?utf-8?B?MFlLZlFsOHpocHZjaC9MZ0NaUzFDRlVLZkZxSlBncE9FY2dRUVV0YStIWVRY?=
 =?utf-8?B?SGN3Uk5mejVuSHB0OTZDZi9WRG0ySGZqM1I0amJwMHBma1RRdXRYY1BqMXhS?=
 =?utf-8?B?L1krVmdtVGgySlgyQlJ6MmZGRTkrbFR2ZTlodGNCSU1pVzhlQ0J0a0pLckZK?=
 =?utf-8?B?NEtyb1hQVzM1dWJJVWc4dHNGSDUyaXYyc3ZvdXBldGFWUmpmNkY3WnNyalVa?=
 =?utf-8?B?OExEVUNWTTBRTTl3MFBUT0VhK2YrbjltNkRaK3Axd3NFWTZXbThuQm5UU05z?=
 =?utf-8?B?RGZKTXRYZFFMMGp2S0hyRE9DZ2J1eEdsNSt0ZFZKTVNZVm5hZVYwQjlNd2NB?=
 =?utf-8?B?aVhxa0o0UHc4ZmMzSDhlREN6Q2EvYitBNUFQY0tyc3JmQUNqVUtMdmxBTndm?=
 =?utf-8?B?dGNwK09menBWL2NySUh0OGQ0djRMVWR1VnpHQ0ducHM3WW5mMHRmV2t2NXNz?=
 =?utf-8?B?UG4vVEpBMkt3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUY5aGk1ZnY3aWpzdVd6Ympad0swMW9VVkNpYzUyVXBpMnVscEVGS05rR3du?=
 =?utf-8?B?OHZCMzh5dUk4b05XNkRsZno2Wkw1K0l6d0E3T3RYTG1ab2ExQlJIekVXbkhL?=
 =?utf-8?B?WW92czdwa2N0VkdtNnhTSGxDS0lNOVBIbzQ2Q3JyckNydVkzYzFVVm92b1Zh?=
 =?utf-8?B?SXJheHB6YWVvVDlmT240c2JFaGdhVURneDFmSHRReHkxVDJ3N2l4ZWFUSDVR?=
 =?utf-8?B?aHRjMmFCb1JmR21DQ0JYSFlVZzMrK1BhL0lGT2ZHRCszTUd6Y0ticm0reHor?=
 =?utf-8?B?aVBiYkNDOVpjT2JnVnY4ZEZORGhiWkFycUNPS3FSTEtLUG5CaUFYYjhvNWEr?=
 =?utf-8?B?aGtaUHpYNnd1bUJjZThXRGVIOFBxemljSWpWQjcvSE14YmhkUlM5WnlJQXBY?=
 =?utf-8?B?dXpMcm9EdlhRQmxvY2NkZVpTQ1F2bEt5ODhSY2FicUhQWGROWU1NQUJhcjhv?=
 =?utf-8?B?Vkd2c1U5elB0bVpNMEZpUkcvM0k5WjhWYVJoV24vVEhYTkxYdmEvemZMRDYx?=
 =?utf-8?B?aTNWY0V3b2hGSmtySXB6d3ZGQ2lOZm5KUTBEdUorbTJNYzZ4S2ZLQUJyTU1Z?=
 =?utf-8?B?M0RFeUVReHJCUW1xYXZJN0x2TTJPVXpMKzNxc3NhVURQVXAxVVFhK1BMUU1W?=
 =?utf-8?B?UlBzOWRBNi9yaktOSlBlMk12NXNNWFozWEdzd2pGa2dkdS9NWVBKWkpJUjh2?=
 =?utf-8?B?eVhrcWRNMEVnV0VoanBrbGhFN0hmcVhwWlhEaThncjh5b2xFaURBa0FPb3pW?=
 =?utf-8?B?Y01IbUpqeEc5MkphUEp3Y2FqbGJqbkVaZ0IxblE4SEx2dmZ0WWxtU1FkQllF?=
 =?utf-8?B?OXUycWZZbU4rRitnZVdsenIzWWFPaUoxQ0t4aDRXZFZKODdrU0JaWkF3S1FE?=
 =?utf-8?B?cTdwOUFlWnlUaGlBblR4WDZvTWxJVVVPQjI2T25GRmRlL0xlYmkrRkY5T3ZR?=
 =?utf-8?B?T3F2eVRyMEduT3p0U2JGOUlNT0dwazBlcEZnRXFFamVZZDhsc05WaWFVNTJ0?=
 =?utf-8?B?YTJSTkREM0VlZXd3R0U1ZnB1VmtKV1ovVjJ3RDQ1ZnEwQlhRUTF5ZGdVdkJk?=
 =?utf-8?B?RzZSTVhNRnRoN3dIUkNneVh1QW40TkpxbDFnNktnUE1MQ3dhMzMzVSs2N1ZX?=
 =?utf-8?B?T3dFUXZkdWxLYVJVZ093ZUIydmpLbDFQZzFKZkFtNnJPY1I4bkJoRUVoTlNw?=
 =?utf-8?B?aCszbDByTUlpTmprOWNFLzM3ODV1SGR3YXJqWDE5SVQvdDkrcTliZlVqVjhJ?=
 =?utf-8?B?d0pGdjEySDQ1T2pzYXBKS1BySUg2ZnUrUklrS1NNQlhDQWREa3dCNmNLUThH?=
 =?utf-8?B?a1BWWjdzSE5JME9CSFBVOVlrcDVsTGNQWk15UlJ5ZTQ1QkdaQTQvQ0pXa1Bs?=
 =?utf-8?B?QUZESWQyeUNnY3J5cFRLMTBybm1hem9lOERsT1dhSHl0TXFBb1dDNXpESFY2?=
 =?utf-8?B?Vjk0QmNFcWhOaVJGeXVteWttVXRybUtkZ2tSaUw4S2drVXhTc2JIZGxOVkZJ?=
 =?utf-8?B?TmJveXFtMFdQQVJZdXVQdlpHU2FmRFFSZEZobjY2VTZPZnE1WU53YUhBOHdq?=
 =?utf-8?B?dEw2QlNiall4a3I4cDhvbFNrZk5kaXB1SUY2NWJheC9zK3p3L0lPbGgwdmE5?=
 =?utf-8?B?dWtSOXBlWXgvNXdKeHMxaERpa1RuM25PZzJ2VllDMUwyQ0xZRHBjd2cxenJn?=
 =?utf-8?B?cHhLUWY0OXZ2aEo5SUdqKzBid3FseXpKRm92S1k3MGxmdjk0N3h5UTdRdG15?=
 =?utf-8?B?WDVNQTIrZTduNHJ1ZVd6UnRsckJMVWNFMFpjZ3dPUVc1NlhIdmZOeUlEN2d3?=
 =?utf-8?B?YUVSa3hqVnhDR256akhKY0Y5dXY1VkxpWFVTbU5ZRTFvWXpFb1daWWpkV2Fz?=
 =?utf-8?B?aUE3N2hkS1o1dEVTVWptVHNmdE1nQU1FVzBlQ1Z4bUtZSmN0ell2UzVnUXRz?=
 =?utf-8?B?N291WE5hSEJsTmxkdEw0aXpCeFdWbjNIcnlaQzdoYjdKQnQveGw3YU9XMCtj?=
 =?utf-8?B?ZGxBdW1PU25iaCt1b3labkF2TTR1L1dxN0tFQU8yNzBrdGMrUG44bExEcG5W?=
 =?utf-8?B?ME9yUXM4cExrYnJoWTJDdHk4Sjhpb3lrRGZnZWZtS2VKbDlNRDdvQVA0MlRF?=
 =?utf-8?Q?/+IJfd7tk/gAevNAnAYOlmGLQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b111e0-f51f-4e2d-8fff-08dde0a1bb76
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 10:58:59.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OhbbBfpFi84usNhF3KWqqFdEb0Z4Cc6C1VUVMCVwVYYpa8i88tvocZr9ILq4RDbWfnTpkFSBqtRLQTI8bRaZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451



On 8/21/2025 5:30 AM, Kim Phillips wrote:
> On 8/20/25 6:23 PM, Kalra, Ashish wrote:
>> On 8/20/2025 5:45 PM, Randy Dunlap wrote:
>>> On 8/20/25 1:50 PM, Ashish Kalra wrote:
>>>> @@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
>>>>   out:
>>>>       if (sev_enabled) {
>>>>           init_args.probe = true;
>>>> +
>>>> +        if (sev_is_snp_ciphertext_hiding_supported())
>>>> +            init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
>>>> +                             min_sev_asid - 1);
>>>> +
>>>>           if (sev_platform_init(&init_args))
>>>>               sev_supported = sev_es_supported = sev_snp_supported = false;
>>>>           else if (sev_snp_supported)
>>>>               sev_snp_supported = is_sev_snp_initialized();
>>>> +
>>>> +        if (sev_snp_supported)
>>>> +            nr_ciphertext_hiding_asids = init_args.max_snp_asid;
>>>> +
>>>> +        /*
>>>> +         * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
>>>> +         * ASID range is partitioned into separate SEV-ES and SEV-SNP
>>>> +         * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
>>>> +         * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
>>>                                       [max_snp_asid + 1..max_sev_es_asid]
>>> ?
>> Yes.
> 
> So why wouldn't you have left Sean's original "(max_snp_asid..max_sev_es_asid]" as-is?
> 
> Kim
> 

Because that i believe is a typo and the correct SEV-ES range is [max_snp_asid + 1..max_sev_es_asid].

Ashish

