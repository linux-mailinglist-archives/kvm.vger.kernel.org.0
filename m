Return-Path: <kvm+bounces-71063-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kG32OE5Ij2k/PQEAu9opvQ
	(envelope-from <kvm+bounces-71063-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:50:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F02137B5C
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5539E301079B
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E95233CEAC;
	Fri, 13 Feb 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FfWM6iip"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123423183B;
	Fri, 13 Feb 2026 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997830; cv=fail; b=sZ3pGR/ctuv8RN3CFITLBKtPtjLf3cBR3/maNOkB8mL1IbFTmCZkCG/YwMR1nF+9rq2BEsPtEhT+whERj4OzmMg3yCSxl3sthNUVjLEBAvQnC4ycLnpebquYczYTTR1yEpq5GLFNdYTm+Oghafkpzwh4E+SP70LHS1U8kPebwIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997830; c=relaxed/simple;
	bh=DKdcaEBXOzYKdj4eUVg9DbPzwfgze8w2aZwrj6Jz9T4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PZKoragnAwvbFSFaww4jvPQl90YcgSZ/SM3TrAdmL+I3phpDyMLsplldqOw7yw7NdEysK5m/sNi5dN6OF5FCTb3Kirwvfn4EitpxD29cky9J7MA3vuarEzF/KiqpWJpbiHR6ZThHMOPW6NgmKefY8MbDWboPLDNtV6MZMwfF4sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FfWM6iip; arc=fail smtp.client-ip=40.93.195.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umu3peFw1ImU53RiP4x2p9+D+2EG+RC3t+i3MWSQU2a1S9mvGbpxDQaLP9nWf0HkPuoqsOIa/MLl+aTdpcvW0xOOm4s9/3v/BJs4BWsHa+FPvC4YHmfuJeRywOZ6+dYmPzby6CMgMY38cTvc31AdhKeqvDC/nN4g4Kto87wdZ9qOrIGTN/Dc0CD42uiKcwnJBabutP9A77tBWM84am0Viu+xILJwZsY0jyFJNrj30ZMiskLyxbJZCvA3XUM6l6ZdBA0AMYcVneIQBWzjSfThkCOUF3eSKvzlB59gLD2qBtHGJgBuxJP1n3mwDFllLoIG/aUoPBjVucMeZKf+9w0k0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uc5MeD5FEvhwhO7tUArqJ8pKFUZ9iOpzk7WpmK9JhY=;
 b=txE+LCgWYZvtQd1LKiNYeJ1WYm/uplaflKerOmk1iYg9s+UIPLDQvcA/3jPof/7zIYxw07h2IkPLZ0RyjSjVDK7IavdQO6qLbZ5tVNY6TjntQarEut3LtKvtxtmYalvp9IgbJZuMTH8OvQ1vSP/bA4ZCdaUl+kI/zzgUangnriKJYuLi6tHMfwhH2zBRQ42lDSzQavJnXP0qmTVLmY1op/eCNFXu/jWqjmVqHZGfO9ZgWyDRIz/cL3NspLuokJaWF9a/j+HdzLg4o5VN5iVjNE2nzrrq26L+eKx1avuUL8uDLLvrcOq4QsdvRIe9OtnnRtPdVYl+Ezadzsbix5GhPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uc5MeD5FEvhwhO7tUArqJ8pKFUZ9iOpzk7WpmK9JhY=;
 b=FfWM6iipvpGn4In/oP8dg7Y2lSZdvD0gz2FqiWWdBkCxumivvmT1GOGWrB17j+QQffWknBBQf9wIbHlMiV7bQ0SExTkXE41AXUv8vPhWXCcwS7FvCEefSDuzl71rT3WEupF6WWdIo6noxaV3jOC/F8vXdgqrVdCUmw0F6Zh0caU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by IA0PR12MB8255.namprd12.prod.outlook.com
 (2603:10b6:208:404::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.14; Fri, 13 Feb
 2026 15:50:25 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 15:50:24 +0000
Message-ID: <608955dd-5d21-49b0-aafa-e74b83eb49ec@amd.com>
Date: Fri, 13 Feb 2026 09:50:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/19] x86/resctrl: Add plza_capable in rdt_resource
 data structure
To: Ben Horgan <ben.horgan@arm.com>, Babu Moger <babu.moger@amd.com>,
 corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
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
 <7b7507eac245988473e7b769a559bd193321e046.1769029977.git.babu.moger@amd.com>
 <a212711a-7af1-4daa-86e7-124ae15a9521@arm.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <a212711a-7af1-4daa-86e7-124ae15a9521@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:610:4d::16) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|IA0PR12MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 483c6264-05a8-4539-94ef-08de6b179a08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1cwKzFrMXJGYWN6VzF2M2MvZFJIaFhBeWk3VmN0OVNIQmNUTjI2ZzQzcGU1?=
 =?utf-8?B?SEFBZDNmNGtwQVJ1NzVVSll2a3dqbWFra0ZlcXZqZC9pWVBMYVlFSUdrYUo4?=
 =?utf-8?B?bllCZVBpOWxBS2hxMi9uKy8vZ2pEdm5SVmUzakp4b1JRYjV3N1ZQNE5IRWtY?=
 =?utf-8?B?UnNQVDEyZTNHSjNjWnhqUFJKSmdPRVcvV3krbVJlSHdNS3J3cGtyUmFFWmdy?=
 =?utf-8?B?c2V2UklNbC9WNVliK25sa3RVUWxtREJ2alRKZG9nN2l0NjdWTi8zL0JUVS9t?=
 =?utf-8?B?TVNOM2JoTzNISWZTQjFtOHcvQVk4TzkyOUxsOU9PRXA0dnlsazBSN3l3VEVp?=
 =?utf-8?B?R1lEaWcwOVFEQmV5T1lJUkc4QkFKY0xWOGFhdnpzZ3lFdGZFVmdHajdlaXAz?=
 =?utf-8?B?TVRBaTRtSFpTZWVRR3J1TDEvR0ZLVCtmTFFTL0R3QXNFTnhNVDBBK2tlVXRt?=
 =?utf-8?B?THMxbXpBZ2dsY296Wmw5L0pvdkVhWFVsK25tSXlZM3g4YUkzUy8zemlUK3B6?=
 =?utf-8?B?NE9JNnRiaUNHM0J0SzErbEMwMy84eVRqTFBnWjRtTzlRaW5FV2Vpd2JkV2xI?=
 =?utf-8?B?MnJxSVpXQ2prVG5zYVRZaXFkMG5CMjQ2L3g4MWd0TFZKc1p1c29PYjBxMDBy?=
 =?utf-8?B?Y3hEWTI4dkNFOWtNbURRajh3aVlkNzZKNENpN1FMaUp5S01raTdjalZVR2xR?=
 =?utf-8?B?YlhTM3JmdHBnVzdsY0F5dmhMVlJ1b0VCdWtEUjZmQm5Sd1VJaktHOFp6bmRt?=
 =?utf-8?B?MDhUQUp3WHpiaWlHY2k5cHM5UHgzY05LMjhjTHlsOTIxaHZ6bitQU1JXQS9p?=
 =?utf-8?B?Tmx0NEFSUTY3OFB3dFNwY3NBelVVNG9ER2w4ckYvVDBuYU04RUN1eERQeGM0?=
 =?utf-8?B?NlFlbzRRODBaNHl5OFZYbHA5VUVjT0c4OHlvREk5RUlkR2tabW9NUFhTc2Yz?=
 =?utf-8?B?NWNPejJVaDdOaFBVNUREQTc1TlNjY2pWMUFpZklZbTZ2R3FpUXdqZHZrOUZT?=
 =?utf-8?B?Z0VySExrSDNNOVkybkRoeEg1bUpHSG1LelRIY01BYzFYRTd0MStjRVVQQkNT?=
 =?utf-8?B?dmhrVGRwTHN3WjRXMS9tK1pkTmZvSmN3NG9zRmdydzI0eHA0NHlXTHlEcXU5?=
 =?utf-8?B?aGF0VFlnVVR1ZGZsOW15ZEx0TENudWJpN21tSS9uVTJDbkl0bG1CeUQrRkRQ?=
 =?utf-8?B?Z2JYWkc2T2prbXIzUWxlRWh2NU5MQkdOQnFkMnlDOGtFeEx1cUk3RURicVJu?=
 =?utf-8?B?NE1XOHl5dnRSZFFFSVBXZ0ZZdmJGYjJJaUNzZkp5bCt3U2JwSWprN1dWdER0?=
 =?utf-8?B?bmFvTW9FT1BRUkUwQXlmQUl6d1JxYktCSktSc3lOVzhrUFVHN3FsaUsvSmlv?=
 =?utf-8?B?U2pTUC9tai82RWxrcXlNbVdJSEh4YmNsYmRranVLUU16K2RiUDNLR3Y4MlFK?=
 =?utf-8?B?NGs4L0FzQmdZWE1QNGlibTJLMFQvQm9iTi9DcEIvWVZUaGg1N21nV1praWp3?=
 =?utf-8?B?VFYwdDJBZXAvWi9XSFVjYW1pYStSM0pBUlFoWHZnTENuTG5RYlBzOG0vMUpS?=
 =?utf-8?B?b05weVkydnZRdU50cU5LcHI5TFZtc0czM24waEFhYm8zaHppQjJQaWhPTUhR?=
 =?utf-8?B?djExRXFDdVhaNXZGRkE4NEpXdjhqajVVVUQyVDhWVFVGdVBWZkttcUZkUDNZ?=
 =?utf-8?B?Nm56VTlSWGpXYVh0VUdORldnTkNVM0U5Z2oxdXJvZEx0ZFNYWWVSK2RLYkph?=
 =?utf-8?B?Z0orazA3aHNBUUZYVkdIQi9yOVo4Y2dVTmJxd0hOcm1QNEZ4WHRVNW5ySWxP?=
 =?utf-8?B?RWl1aWVxZ1pOaGxlVGRUd2VZY1c0Z25nS2QxeFk3Qk1uU3VGNGlNczhNN2pu?=
 =?utf-8?B?dVhLNTVmRXI2NVhYbXpnQTZKUVpCS1huZERCTFh5eVp0MjJVY29zRUtqbjdh?=
 =?utf-8?B?b084MzRVUCtoVWpjejkrZWl3SU1HNlBaTlEva3F2NVUrUlR4d2dpV00xYzha?=
 =?utf-8?B?NkpCZmt0dDljanJsamxsTVA0QkMyVFdrenNZbGdtUE5XSUJvaW8xN3BqZ0ZO?=
 =?utf-8?B?WjUvT21hTFV1VGFEZzVnSFlXdzV6K2ZnZkxkTmtPV3F1UkNGTnluTHp5a2Z4?=
 =?utf-8?B?MHJCRkxpM3RDVHF5TXlqeWVYWjZZQ2NCQmtkajlaTDRhZ3ZnT0RpZUxFVTUr?=
 =?utf-8?B?WEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHlqbGRSa0NSYUh3QWtFYklIeXlDU1JaQjA4bkpuak5qNTBIT2phd0dmejdk?=
 =?utf-8?B?c3BMc1lQMWttQk1wN0pjZmdOWjZTaUFOMEJqZXBQQk5NVU96eGVUT2ExQnEx?=
 =?utf-8?B?eXdpUzdTQ2tzQWoyZWZDaEoxdWJZZktzMC9jRXhxT1o4REVUcDNjenovUzB2?=
 =?utf-8?B?QWJ4YkxSYjhjOUliKzBRY2h1dnBUZDB0TWtycG1Xb0hGeVNGSzVnNGF6TDR4?=
 =?utf-8?B?NkdQQVdMRTZKWU5mYlA1R05KM0l0ZnAxbE9qSE5iSENmcmJsZWZodFlUQ2c5?=
 =?utf-8?B?TGlkOTlVdDdpK2JpVzluQzdBWUd0dURjNmc5ZG1ONzBLNzN0R2hudFY3Z013?=
 =?utf-8?B?Q1d5Q2xWQ2xaTlRhZGNNS1ZNbFQxNlNDaFZEcU1QRkY5Yk9GQUZVemg0Q1kx?=
 =?utf-8?B?cTJsanMram9heGFHSGFMYXA4TStnSGIyTzgxRFpGNnd6MmlVSm1IM1Y5TjJx?=
 =?utf-8?B?WWs4RTFzTzhXWjRhRWpPRHcrYjRsV1V6YUc2YnNPRXhidmlpd2xqa1Y3eURk?=
 =?utf-8?B?cmJmZUhXdDF5RVNUdm55R2NwaXhoK3ZrRnVweGp5NVF4Ly9DSW1aV0pmeVFj?=
 =?utf-8?B?MHRXTmt1Uk9KWW9oUlNQaVZIcmhJSUh0SityU0dMM1hTUktuREVLZC9jMlNy?=
 =?utf-8?B?VlBYQU1GQVlPcmlmclhNcXp3b1lTYmR5WW4xZkU2K2wvb1h4YnphY2w3UUIv?=
 =?utf-8?B?OXE0ZEFPU3ZyUXZWVnVyR1FhQVRHdXk2aFYxcG5RbGRkNWNzQ2NmRUh6enQ4?=
 =?utf-8?B?ZEVFWnJEakxhdXlTVXptcmdlOGQyQStTcWZVWHk0cHB6OTFVMnU1QWpjaHpt?=
 =?utf-8?B?c1VQdkJqb0tFZi94eFdWaGhTaVJ0R3pXMDBDS2Y3dlZHWklFZm9VbGp3TEx0?=
 =?utf-8?B?WWJNejd6QkF4YkZUYXJMVWZtbkIvQ3lHSnlYeDNCRWRnNys3c2ZXUEZlSFJC?=
 =?utf-8?B?WHNGcjRPbm93MWlBN2U2MlQrSHpsRW1ieEVENlhQL2dFQ2VlRGhlM1FJUitX?=
 =?utf-8?B?TUY0OE4vdGFuSDFBajQ5K1RSWkpSYklRVmdEMzJXK0R2VU1pT2hFQWoxeXYw?=
 =?utf-8?B?TUNpREE1OE9mNUhlNnBOTWZiZDg2djhJeDNjNXQ0QldoYlBQR3YzMGlTUis4?=
 =?utf-8?B?S0gwd25WbzU1UU5wdEVWMEZ3Y0x6eVViTTBRcUlROUNxQjR5YnVXT2xyaHhy?=
 =?utf-8?B?THdSUWxBODhGNC9TSXVvZHFlTW94TU83UU9DcU1Ha1I1aVlydjk5WEtPU2gx?=
 =?utf-8?B?TGU5blRVNTM1dVlIUjk5c0IvcGhJMElaTnVFak1wSlY5Q0lwSDJ3b2ZLS1hN?=
 =?utf-8?B?dzV1bm9XWVhlMlNaWkZENzJDWklPVzNWVG9xQmwvN3dmdW50ZG5RQ0pKS3li?=
 =?utf-8?B?UTd4S2VPdllkcEN0YlNmNnlHbkVJS2g3VU8vd3FMTTJwZGI1NVNXUjI5dHBa?=
 =?utf-8?B?SWlJay8xL2MxUk9mZ3hDL0tPa2pvazgvdVJyVkVDazVnbkNONVVqUytDeTlP?=
 =?utf-8?B?dFczQ2JQVmVLalRmd3Y1ajd0ckF5Zm10M2dNWWF5UU9zU3pQVkxhaEFhdzR1?=
 =?utf-8?B?OWZYSjFpUlZvamd3eDVtb1cxNlJZZXpGL0ZNZjgvblZtNWg5aUY0NGVBVnM3?=
 =?utf-8?B?UVZBOEdwVlNWY3ZKWC9CcVJFWFp1a0M3T25UY01PSTJWMkY0YVg0UGtCbUxS?=
 =?utf-8?B?cEl1ZkNRL1Rab0VGZ3VCZ3gxeDNyeWNnOUpleldXZ2didVRqOUZRc1VSS3A3?=
 =?utf-8?B?YnE4QWF1b0p3TUZ3dFp6a0FsVFFGUkxRNGcrNmdRYURMWXJsMUt4Ym4xZEhF?=
 =?utf-8?B?SGhIVDhYN0x4enlrUzhWaEI2R01zdnppOG9RM2U5aEVDR2RKRVpYTFVWYXRP?=
 =?utf-8?B?ZURVU1ZhOVZGWTNnZXJ2V0ZTdEdaQWlmSGxNMzN0UEdwWkQwR3BFcHVseHFn?=
 =?utf-8?B?K3B0K1ZLOTBmSElKMGYrQUtTLzl3Snp4dldEV0J6RFdHRVdmQldJSXl6RFR5?=
 =?utf-8?B?WS9HeDJjbnA3SG1zZGtkdEM1eEgrTnc5Uk5vU1BqUjRvYU1BcDhKYzk2Q00x?=
 =?utf-8?B?OUVmYW5vUVhqbjVPdWZJNWdqQlRGOHMwQUhLcW9UUm5QWU1xaFNjS20zbnNQ?=
 =?utf-8?B?WFFqTlZWdzY5cTcwY3Q0TEU4TVFDdWo3NEpNT2dRL0Q4ZDlsRURuaHRTWDRJ?=
 =?utf-8?B?VXE2bmpJT2RSMHhrK0dNNUFNVDl1ZjFud25mT3M4cWJPWHlNdkJVaXNITHVq?=
 =?utf-8?B?UFcxRlVOQnFXNjgvcGcxRFRJVk5NQ2VTZ3R1OStuRnZPOGF4QlEyeXRJelZi?=
 =?utf-8?Q?FUXmD3+jAoNrQk4o+b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483c6264-05a8-4539-94ef-08de6b179a08
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 15:50:24.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16Fy4TPtCBa8+pDWAYhhjB8STPDyOomXLpZmjwz6hcn1/qzM2vMWreDRM9vlI66B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8255
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71063-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 90F02137B5C
X-Rspamd-Action: no action

Hi Ben,


On 2/11/2026 9:19 AM, Ben Horgan wrote:
> Hi Babu,
> 
> On 1/21/26 21:12, Babu Moger wrote:
>> Add plza_capable field to the rdt_resource structure to indicate whether
>> Privilege Level Zero Association (PLZA) is supported for that resource
>> type.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>   arch/x86/kernel/cpu/resctrl/core.c     | 6 ++++++
>>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 5 +++++
>>   include/linux/resctrl.h                | 3 +++
>>   3 files changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>> index 2de3140dd6d1..e41fe5fa3f30 100644
>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>> @@ -295,6 +295,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>>   
>>   	r->alloc_capable = true;
>>   
>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>> +		r->plza_capable = true;
>> +
>>   	return true;
>>   }
>>   
>> @@ -314,6 +317,9 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
>>   	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
>>   		r->cache.arch_has_sparse_bitmasks = ecx.split.noncont;
>>   	r->alloc_capable = true;
>> +
>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>> +		r->plza_capable = true;
>>   }
>>   
>>   static void rdt_get_cdp_config(int level)
>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> index 885026468440..540e1e719d7f 100644
>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> @@ -229,6 +229,11 @@ bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>>   	return rdt_resources_all[l].cdp_enabled;
>>   }
>>   
>> +bool resctrl_arch_get_plza_capable(enum resctrl_res_level l)
>> +{
>> +	return rdt_resources_all[l].r_resctrl.plza_capable;
>> +}
>> +
>>   void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
>>   {
>>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>> index 63d74c0dbb8f..ae252a0e6d92 100644
>> --- a/include/linux/resctrl.h
>> +++ b/include/linux/resctrl.h
>> @@ -319,6 +319,7 @@ struct resctrl_mon {
>>    * @name:		Name to use in "schemata" file.
>>    * @schema_fmt:		Which format string and parser is used for this schema.
>>    * @cdp_capable:	Is the CDP feature available on this resource
>> + * @plza_capable:	Is Privilege Level Zero Association capable?
>>    */
>>   struct rdt_resource {
>>   	int			rid;
>> @@ -334,6 +335,7 @@ struct rdt_resource {
>>   	char			*name;
>>   	enum resctrl_schema_fmt	schema_fmt;
>>   	bool			cdp_capable;
>> +	bool			plza_capable;
> 
> Why are you making plza a resource property? Certainly for MPAM we'd
> want this to be global across resources and I see above that you are
> just checking a cpu property rather then anything per resource.

Yes. I agree. This does not have to be resource property.

Will make it as global property where it can be set from arch.

Thanks

Babu

