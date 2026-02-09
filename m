Return-Path: <kvm+bounces-70674-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCGVDGFzimknKgAAu9opvQ
	(envelope-from <kvm+bounces-70674-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:53:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E93211579C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 996B1300845E
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 23:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F367F32B990;
	Mon,  9 Feb 2026 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tCGYiBgw"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDE11FCFFC;
	Mon,  9 Feb 2026 23:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770681178; cv=fail; b=DeQsxGiCkaMDtzxjlqv0xTjb62BuVpwS7lbgS83MMVsaxfGAl5MDpFGODbLKRrkBIDU0RcC66urtp0oIDtpEw2duUNFqEio0TiOD0tv0pKEFhV15s5r2xUk6IIY4bJR5N5Vj7XlSEzyCeeeBNI1jijmQIYUFB0hXJ2iYgNErv3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770681178; c=relaxed/simple;
	bh=zDhCQ3DwMrtt0jaJ/Ll8RpXe+ZSNFwI94P+WLQgboqA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LbPF162ogvwXbTk8uLHFLBRxnZddPoS7RsVqW8Iagj7HcNsU/oVyzmED/S28a9GUKhrAWEapQo3wDCI/XXIx1u3LhntGLSPB8LxvOpJpdEiFWnUlH2NWSp1JQo3gojPh4L7N5798sTg3MgLj+fe+hEUbHn35gA5fizunL1B6OIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tCGYiBgw; arc=fail smtp.client-ip=52.101.56.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnh0PwhAxkaLofwpl3yster1Aeamhe9lEpuVbCNjNOeMkowumVQWC0Gxvqn8eemSuAiGx6QTf1LlM2JVD9Q0TdoxQ9fEnjyr1rtjmra88sp72erg5YeBPpg76zM/LUqGOn/Ck0gp2LGuR6OgFZi7MBtW1AHLpi1dWBcvrTAwFIz6oX/jkr8OvMRrp4GH0DBtsi24SCRDOXj+LYHS5YMNRvj1aGb/IbqI35nR4t30QhoHw0DLHAMlyjb0zd/OHaZVteSfL+hiuRpMrmZZRzgIPvt+glZo9duGFT1wkjHJSfzDHnMz4VOU8gQ3MZ3vmz4Y83UrnPA2WhbHA7t8MWjTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Te9XhFXrBT/pFl8ye4AIqcO7ROTtzYg/fbNhBHZVMDQ=;
 b=M49wRsXflKDgnNYKyOV+FNbuUKcuC+aQMXB3f4cjO1DfBic/DLbP+ADM/T23zt8sWTbqV0sYZbKBds8TzTNQX5LEj9g4oUhd3a1d2CoKmOrsssM2nZynBjGz8WRjJ6XJ6uPwpcGSIC89N5Ccz8QodYlF13ed/krMT7lmlx/fh77M2lSkBUbNBNFjodSevu8vOX8xlliAaoKbqkgQfmlda7vVAnR2fV+8Iwm848ZDWLCX6G1AnWZeO5sZQfLwfzdjL5h0iydVQ8KInyMum5IHWM8kPCDXXAO+hSnBjlYT88tqH9+GKc21Wf2vjBvXdH87Iy9lOt9O57mSU8dT10qxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Te9XhFXrBT/pFl8ye4AIqcO7ROTtzYg/fbNhBHZVMDQ=;
 b=tCGYiBgw1oCO78j8yYeKiObcf+pQtAQ6VYoW3Il6ryRGujF+fB9F2i2b7CBSa3+u3JqeDwzY5cWhe1Tz45Qo0NIF1+UOL35PJdg4TqFFrCTPA5YCpMzks8RKyEZdy9RSLxllbWJL4fVjSFNXjPXQGI8XsnlwUvq0xNEHp8Y/wbw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH8PR12MB7254.namprd12.prod.outlook.com
 (2603:10b6:510:225::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 23:52:51 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9587.010; Mon, 9 Feb 2026
 23:52:50 +0000
Message-ID: <aa594520-b21a-4c45-95b3-59d3f79de603@amd.com>
Date: Mon, 9 Feb 2026 17:52:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/19] fs/resctrl: Add new interface max_bandwidth
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
 <a4ca7d43100132b79adba85a4674c7b46b05bb8c.1769029977.git.babu.moger@amd.com>
 <b7f04a29-0693-4df9-b0dd-c7c047c1f9fe@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <b7f04a29-0693-4df9-b0dd-c7c047c1f9fe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:610:cd::35) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: e74f23ea-b181-4a30-e214-08de68365543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHM3aVI0ZG9oZitqRzlNNUNqNzZ0TjFoQnBpbHNoeDFrRXhlOHRpYjJCV0Fr?=
 =?utf-8?B?ZnNuKzQxMzB4K0VmNUtZRmRiMEpqZkhVZ1hUZXhaNTl3TFdRV1RBRlk0d3U4?=
 =?utf-8?B?MWRndXN5eWdBTytNRmZkQ21jRHMrTkFWVkdsQmNtL3pueVRDRkppWTFrdUJQ?=
 =?utf-8?B?ekZHaW02Wk5IOFAxRzZzZ1M4enJwUktuL1VteW5vQnR4ZG5abk5tSjViWDJ6?=
 =?utf-8?B?eXM4VVdkNjk4Y0xSWk8zYUFENFFtejBzRXhVVzcwVjJuUVlKcjdxeHR2dGNH?=
 =?utf-8?B?SXhUSUgwcWZBN0NkU0pBc0xBMW9Tdms0ZTJST2ZsNnFYQjdqa0V5MU82MUNt?=
 =?utf-8?B?TnZYT0taNFdWZXk4MGowSklWMUN6SzF0NElBLzY2M3QxQVRvUGJHQlNJcUxX?=
 =?utf-8?B?a2xMNXJ5T0tjUXFqeGpadmNqeDZtbGhUNklod0ZVWngxWjNkdkNUQkVDQkxS?=
 =?utf-8?B?M2RhNGRwd0JIa3N4RzFmazlPNk8rOVhuVmNmVDYzOFRXRzRiVnVnMjUxQVBo?=
 =?utf-8?B?NlIvV2xKV1Qza2lDb0k1bTBTZDBrSXBjVW1hWmhrTWdoakpwSHN5cWg2ak5J?=
 =?utf-8?B?N29HUEtYdWplQmJCVml4WVBlY3FWL0Vibm1ZT2JpMFhDS2Z1T3Irc2JCTlhN?=
 =?utf-8?B?YVRkd3hSaWhxTGxzQTE1Wm15bEpjNW5jWEd3Z090bk44VEtyQ1RjbngyVnZq?=
 =?utf-8?B?L3E3a3p6M20yWTVOSUNtQ3lIdW5YRjFjTUo1N3dzc3RucmdTSmdaVVc4dXhm?=
 =?utf-8?B?eEdBZlROcEVzdWFBZ3o0SEVVeUwxeWx2Wkh0czBseWowVkY5bGl2WElFZGQ3?=
 =?utf-8?B?NVFzbCtpUm5wZE5qMUgrRGJublJ0b0F3am5WTHNhVWdKYlQ2STlOQjNjYWds?=
 =?utf-8?B?VnhteFkxaHJ0QTVZRmdIbDlJRlI1OCsxSTh6RnowWEJ6cjkrUzRMOENTZHMr?=
 =?utf-8?B?U0JNZ282ZzViYzJvci9sSnh5WlliTXo2NHlvOUpTL2E5SnBCN0dCNnhJRldV?=
 =?utf-8?B?bCtBSWVnRjQ4QVdVK21oOGV1M1lSZmpzb1ZObUM3Qm5ycnQ1K3Q0NEM4NXhs?=
 =?utf-8?B?d2ZhVWppWHB2R3AycjdWakszWElDTEZuSXNMMDRPUDVyV3NONmIrR093RGFq?=
 =?utf-8?B?UEl6NFgySkU5a3dUZjBpMWFtMG12WEFKQTlmMU9PWHF4em5BY20vbVZBSnhN?=
 =?utf-8?B?VkFRU00wT0orQURHNTJyZW9HNld6TmxRTTFXWkpXbTlTNmNTUnBjS2hGWlYv?=
 =?utf-8?B?WGFJTi8yVlNtRUEwY1BpZnQ2VWN4OHNtSVlaKzlORlZEem9GbS8yT3lxN0NM?=
 =?utf-8?B?dnRVNVlLVkhYMzZjK2dXalNLYlR3MldyaGFGZzNKRGh5MmNzUW5BWTFvWHJP?=
 =?utf-8?B?TzZ0djlMLzJDZGdDWndDVDJvNkg4d1E0N0RFcGVNd2xyUk1qSi9uZXV6cUZa?=
 =?utf-8?B?bkZMWGh4SGw1SHE2VmwzMm1YVmZ5bzNCVTQ3ejF1L2NuWnV1VUhEZ1ptUDJ5?=
 =?utf-8?B?ZDRYbWJRSy9vUHFqc0MzVXN3NzdaSnBBc1lkRW9qTzBCamZ6K0prTlVPUU9S?=
 =?utf-8?B?MkhFSHZFMWlFb2h0TmMraW9GOEtwK2lnU3RFQVR3RDRLcGEyMDNqQVZZc0Q3?=
 =?utf-8?B?UTRhNTVFRkdXYWNjSWY2REx1Vk1QUWc0ekkvWVlNcmgzcHA0Z1F6YitIaFdH?=
 =?utf-8?B?NkdUd2xNcktDMXVBZ0ZJOTcvbjFPaHRnSnhUS0puTXNYT3VjSndpL3RxbDdk?=
 =?utf-8?B?U0pNaHhsbExqekI5TmpsdmNqczVnWm9Sc0tNZlJxR0p4MmpYRlFEclUvbFZP?=
 =?utf-8?B?QWZnQldTN1lYOXo5Ni9YY0tiSFBRRVN1ZWUxL1FyVTdQdFh4Z1ZsNTE3M3Zt?=
 =?utf-8?B?QXMvdjdIQkt2K3pCc2V6aldLdXR2NHhmcXduZ1VGL1hsYjBneVFKY0ZYWG05?=
 =?utf-8?B?QURvU0RHRWhDb0hmYVUydmxLb01JbWZTT0p4cmhOd2xTTkVTYTBGL0xLMk1I?=
 =?utf-8?B?emJySHh2K2pEcDVySENESGVEY2UyaklnbGJwdjh5SVJRREEwdmhnTm44ei8r?=
 =?utf-8?B?N2NkVWVndDRqZWkvQVpOalNuaC9pKzVRTkE4NGFZVEtSME0zOC91b1Y5YXE4?=
 =?utf-8?Q?cweg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm1vTWgyUkpRZFVBWlFFTGJydVgvL3B5aTNDaHcxem5Say9JY2h1ZGFVaVZJ?=
 =?utf-8?B?Z1NHTDdPN0tyRDlXYWRwY3BtUzJXMDBhZStUTVQzZ01Nc2VPcGhDL0dnWXNW?=
 =?utf-8?B?NVgzbEtKM081RkZyYWRjdmc4RG9rYjdyaTVCaEtFdU1BNVNNWHIwWGcrN0Fu?=
 =?utf-8?B?YVF0QXVUN1F2MnpLN1RMdmptZWtNNGc2cGJEM0VHTXhCeWt0WS9xZ3QwOUpU?=
 =?utf-8?B?RHhZRXRvcWRwTm9BbnlNTXM5UUNIQjRjaFRBU1A4aW5QdTA0ZVdscEpSYTl4?=
 =?utf-8?B?RlNwMkxnNHlLekpEVDBpaWhIa0xjTEpkUERjTURSZHUxR1V4WjhiWTgwNFln?=
 =?utf-8?B?QXpEd0lZVjI5SWN5Qmd1Y2JDRlEzajZFMG12WG1KdXh3MEIvYy9obVVTSWVw?=
 =?utf-8?B?UzJXYi82YUJwMVJQNkNBSnJHTVNrdmx5ZUZFTUFXb3VVenZBOUl3Y3ZxVURT?=
 =?utf-8?B?blBvcDVhMFRuaFVtdXhoNDhmNCt2NmF1ajZldmd0RVF6Yno4OWpHN0dZOU0z?=
 =?utf-8?B?OXJycnZQcmZhTzFJNi9aZFBDbWVqUzhFdHVGOEVyN0FWNUZhWHdxblJISzhm?=
 =?utf-8?B?MC9yYTZ1REZ0YkpQQUdIVGhpeW5ER0ZhbFNRU2E0RFBvNGJYVm4rNFBrUDhK?=
 =?utf-8?B?RnlTdlhnWWtJblNJN1EwdE10ZVdicWFYME5FUVYzcks2Y0ZLRlRzMm5ya05U?=
 =?utf-8?B?TGhseFlnV0VETDNGKzN1RzE1aFJEM3FmRithVzR4WVFaWWNUR2N6T2QwVGFX?=
 =?utf-8?B?Wkh1cVp2UUkvNy92TVIzbVFYN2JaeGx5di9aTWJ0SUNJeUJGK3oyalkxajVq?=
 =?utf-8?B?WkRZR2VkUDJTYnRUeVJNaWxQZ05nSm1BdjFyNll4NzQ5SUw0ZXpMUXhxd2lm?=
 =?utf-8?B?bm1seTFBYXFjQjJVTWJRNzV2ODBxNDkvOXlac21qdlJjUmRKbys5UFQrM0FK?=
 =?utf-8?B?VERDOEJOQmxFMDByMFo2KzNGRG9NQU5hcHI3a3VqWFUxSFNQREsyUDE0clZC?=
 =?utf-8?B?NGVudE9TUWFnOG5TZzZkTFFHQWN2eWF5NXo1K1dUVVJRSVVrZ1Bpcm5jMm81?=
 =?utf-8?B?WC9jbGhDaGduS1RhZ3ZsZmZuQ0theTF3RlEvdFFhanZMcWpYRWNyUHRHWGxl?=
 =?utf-8?B?VERoUUlTcmtFWWpUcFhWS1puRmNVRGloYU1OUEJueGJkSU9pYjBSdlRKOG54?=
 =?utf-8?B?U0F3empDTmd5SUhLMWxRYnp4ZWxQaVBtclB1dVZzeFpiakc1SElndEJvWjd1?=
 =?utf-8?B?WDBpQTIzbjRBV3B0UXNodmZySHZ4VXpCRHovaElWQUdFQzFZZzg1NE5wRVlm?=
 =?utf-8?B?dzdweHhyQ2h5UjFHN2pxYXhKVDYrSVZMYnhiY2w4YlNZaWxUK2o2ZTNRRHdH?=
 =?utf-8?B?TzYrc3JPWmxmNHpJakJ4SFJnMm4xSTh4ZWpGdFZFRkFRcVh4UW5uUjFJNXlw?=
 =?utf-8?B?eG5VN0NQeE0zTEt5eVM0YU12amYxV1dzcG1GbEU0QkFIcERuVWdoSys0ZVBt?=
 =?utf-8?B?eCs5QmFRV3ZBWnBOelp0bDh4UlRhNnIxUkNJampsZWJXWkRPUitaMHpGR0JN?=
 =?utf-8?B?N0tUZ09BdGdQZjNlcVQzRGsrZHJMQkdJK3VHdktTYndERS9TRmZER0U1c2M1?=
 =?utf-8?B?b3V4NHUvQWpmeFVRaDJzelc0TkFzN2dCaDkxNlFwVGNPTVZiQlhOc0hxUXc2?=
 =?utf-8?B?L0lDVjBFenpBSXluVzg0ZmNDSTRpQ050WHBpd0UxcUltTnNhaDh2UUczR3FB?=
 =?utf-8?B?VWg2TGFHN2VoUlJPTEFvdVhCS3lUaEpmY25LSDhQYW1xb3FCRFRQbFRISFNN?=
 =?utf-8?B?WlVlMmhTZzVhZEdFakVUWndEa1NPVWJpa2RuaU01eENBTUxkdG5GWXp1eEdE?=
 =?utf-8?B?cHlBUFdzc25VM2FUekt6ejFOaVhMU3djWlhaSGN6anprSk9rUFF0cGNRaU1C?=
 =?utf-8?B?dUZMdjRsd3lteE9SS1VTTzRIUStsSWxMSmlybS9tUGhDSHFQR1VjMFJ2V2VT?=
 =?utf-8?B?M1hEbEtPNkZILzdnUjZnMkNmSmZCOWdFUEdmTTQ3ZVAxS0lzWDdhQmRmWTZU?=
 =?utf-8?B?b1BVNjFuMVAxVlMreURiS2RIMlhKZk0vRzZHR2l3T1gra05Od084OVl6UHYw?=
 =?utf-8?B?TDZlNmtXQW5vTGJqMTFadUFsSU1YLzBSR0xDMDZ1Nk5HemJ1QWJxcmRqTENU?=
 =?utf-8?B?NGszSnRQK1EyVHd0VTBJekE3R3dGakFJUGdlZWFXNkxNTVpTVmcwSHF1MUxR?=
 =?utf-8?B?THRkNXhQQnJhR2ZXUGEzdm1jRndXeFRrQ3NIbWpyRGtEaUFISjQzVHoybGJU?=
 =?utf-8?Q?akZVBtdIp8JDFxclYR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74f23ea-b181-4a30-e214-08de68365543
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 23:52:50.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6gIFrYK8Gm+225FzCr6t+6/T7zdYVFnUqjNUkwZDSxnPZEUJiFObzwYLgP85y3p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email,lpc.events:url];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70674-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 4E93211579C
X-Rspamd-Action: no action

Hi Reinette,

Thanks for the comments. Will try to respond one by one.

On 2/6/2026 5:58 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 1/21/26 1:12 PM, Babu Moger wrote:
>> While min_bandwidth is exposed for each resource under
>> /sys/fs/resctrl, the maximum supported bandwidth is not currently shown.
>>
>> Add max_bandwidth to report the maximum bandwidth permitted for a resource.
>> This helps users understand the limits of the associated resource control
>> group.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> With resctrl fs being used by several architectures we should take care that
> interface changes take all planned usages into account.
> 
> As shared at LPC [1] and email [2] we are already trying to create an interface
> that works for everybody and it already contains a way to expose the maximum
> bandwidth to user space. You attended that LPC session and [2] directed to you
> received no response. This submission with a different interface is unexpected.

Thanks for pointing this out. Yes. I missed that thread.

> Reinette
> 
> [1] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
> [2] https://lore.kernel.org/lkml/fb1e2686-237b-4536-acd6-15159abafcba@intel.com/

I need to look into this much closely. Our current plan is to support MB 
and GMBA with L3 scope. So, with that in mind, I am not seeing a use 
case in that context for now. I can remove exposing max_bandwidth until 
we have a unified approach.

Thanks
Babu



