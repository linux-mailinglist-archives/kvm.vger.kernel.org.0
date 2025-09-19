Return-Path: <kvm+bounces-58165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F91BB8A992
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00DFB3AA10C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0877F2737FB;
	Fri, 19 Sep 2025 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UWvyX1W0"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E19A481B1;
	Fri, 19 Sep 2025 16:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758300019; cv=fail; b=Zin9qa3Lmethu9ycY9Kkf6yOGyo+Upq+ZcpdjSMTYXGHCdH3cEyukftUZzsmPTr7n9qDa/eU1PmfuWtnjJN8SC3k1qyEMVKdlmxNgDj77NwXCA8tygdTPbtHFMWbrR4DNOGbtq5S7CVoHpdDBguLbrgeaiCwscZeOy4xeUcDpNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758300019; c=relaxed/simple;
	bh=Ow9tQT5QFoqgV8TNf+wnn9OrPitqUiLC8+Ek0UVOF8o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tq1SXrbpTYHndhMMi7jCHao4xG12LoWbNRKDaermdRgK84uaBrj3IceMmsEztLqVpZUEwt/gD0h/DUX9yxe4Tf9k4TpohNsn4JIQJCoJbspDnxlOmOxv9fL0toFpUSoAUA3lM+pqrQZGlaSKs0DQDv8SVzzgNe/smi75bE35Wvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UWvyX1W0; arc=fail smtp.client-ip=52.101.53.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p5dENSy4fuoTKGr0/4zHzWG4/fLSSWZ5WGyPtd4ZxJOiEwV4/Ul50z41p3oxgsNvZiR/QfD59IDoa091rag0GYtPTWlmSGJJpYo4J6LpP6zjBpLBWKD/s+iN/x6Z3QRDQBj3z7Rt7SXcvujqcyj8pjAeB/kCKT6LlpUd9JRlc/TO6xK0b2cpqPpn+yP+9TqG1ir/LVAVZbkL9qm+HQ45ITUIVxMjsQROZtJETMMo5gwDi4WKpLtVow4Ef/l/SWw+cSjpY2ls9f1L8+S71fCqKfb5RcR3WJ/pdLMiIupzaLKvFuVQswTVLzsUEtH1THbMmUs7sxohJffjEaBbDbAzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpAByIdvVL6ma82/KsGgvDdvCyJq5ZjzSPvGGmU3yW8=;
 b=r6aKpd+fr7yW3vU2axGm2gwgS+qodpb2KgjxdDXRENekDyLqKLQM3BTjjwFHdHhZM28fPBFFgsyD/pi8SHNuB1448BaABjIbnaU9msi/gpwJRIUnF5KGqMS0+YkwhRSBr6HaNK/d5YKelrc6zV3vQ+FhOl/0DLHBVWUEkG5u8PxyVepXAnvRVdBym6uVUV9iX08ibzxfz22oTITAa95SkV8Cz8SZuIUufw/L1XkYeqdE5gx2kA5E5EWILQGbB3geiDNCk6ILCJeDKAo6bWo+zQwdgu8DGIQ7GZNJqnJP1tjDBCcWpHAg9qcqqaW8hDvBpNq8uVopee2WH3549NZmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpAByIdvVL6ma82/KsGgvDdvCyJq5ZjzSPvGGmU3yW8=;
 b=UWvyX1W0F4YG5goDndExSqzclRfkjzT++Kf64pVeXT4ha26/IL2NjdDnB+U+gFCfN73n2jwfsOHKp+vV1I72wk+mEd4vkiNbLX6Otfxrr7a8l6mg9rsP9O+8XbnzkOdugo98WH1kSV4PtC1VlKUKSYlvxx0/GIrQlj8rj/fXfUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB8073.namprd12.prod.outlook.com
 (2603:10b6:610:126::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Fri, 19 Sep
 2025 16:40:11 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 16:40:11 +0000
Message-ID: <15cec601-4bbb-4878-98ce-45f0b448c281@amd.com>
Date: Fri, 19 Sep 2025 11:40:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/10] x86/resctrl: Add SDCIAE feature in the command
 line options
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
 <f3aae4014bb65145dcbc0064214324133fe568b0.1756851697.git.babu.moger@amd.com>
 <0a995233-21d2-4adb-a7d1-f651cf3a6ef4@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <0a995233-21d2-4adb-a7d1-f651cf3a6ef4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:806:27::25) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: c3536fe5-1f9a-4564-80f1-08ddf79b333b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEZsT2JDVnhBcmZVamxuSWpvcEFrUmNVYnNwaFBKR01LQm50aStEbEZLWThK?=
 =?utf-8?B?MGpTVzdCRHJRYjlTSG5YUEJOY2RnTnRaMlNhVFAvbnVWTFpIWVpNNTI0NU5Q?=
 =?utf-8?B?ZmJjcnN0WVBSblNSVnZsTC9CdkVOUStrM3NDeFV2TTdPZENBV3RaZExkV1hF?=
 =?utf-8?B?bkZqRHp6eEwxekpya0pMSkVyMlYwSldZQ3NyTmlIYXZXUFZKMVBja0FCVjRH?=
 =?utf-8?B?U0YzYys2Z0pkNkpTejhvQXRoZ3hzNnZSZTMwdEVCdS9iZmpNbnEwRXhBd215?=
 =?utf-8?B?bGVvSVpZajJlaWd3Q2hxUWhrR2o3RFNoMGRWYisrUXNtenN3OVhYc1NGWXlO?=
 =?utf-8?B?QWpwSWduajVPZHZDQVJIcjNMYkRvbGFRcVRXNDVoRGZoTXFxVDlxd28zd2Rl?=
 =?utf-8?B?MzBadHdLWjMvWDFWTDJNZTNqUU9PSTRsSThGUnBOcUk0eGk3cVhVYmJXSnFI?=
 =?utf-8?B?TDJNNEdJanNFTCtJWHNTTVlCMm5RZVlveWVhbDRQSUFzZGFhNnMrbnFVNjJq?=
 =?utf-8?B?K1I0N0JBMVBMQlpZSDdhUlRpeFVQNDR5ampVOXlUenN3TVUyRXh2dWR1bTA2?=
 =?utf-8?B?S0ZJM3JsekJRRWhGVm5qRmd2cXFFOUZQUlpWQ280TXg5QkFvck9heUVaSVhT?=
 =?utf-8?B?UzE5ZHNiamR6SGQwWk92OEdzZ1Q0QW8rZXlSWjhQbFBqaXorc2pvRU4zais5?=
 =?utf-8?B?ME5GejZtaHZpZVc1cHRVa1N0am5NZEpvVnBKOWlkUDRvY0srTWdPYms4UGh3?=
 =?utf-8?B?aDI3ZFJaa0M0MStQNTRvUjFScXo5RlRoRzdnS2pUYnFmOG4zVDMwVDlaTEEw?=
 =?utf-8?B?dXpxd3VVN2RqLzM2T2RNU1RtRGtRTWVRV0pGdGZMb0xKSDgyZFpmZkR0ZURS?=
 =?utf-8?B?TWdoN01WWjhRWWN5dUdCUUJSRWdXR1VzQXhMeWRORlU2SEQyT2Q4ejhjSEtL?=
 =?utf-8?B?bHhBekt0T2dUUXVGRGkrZE40WTV6ckNJbVp0STZSd0JVNnAzeGZiM0ZBTWs2?=
 =?utf-8?B?b0tlUGlDN2phQnppQ3lRQW1jRGVTdXYrY0MyTmFGSDAwRjhJQktjdXpYd2p0?=
 =?utf-8?B?b1VLZEVleHBFcnFvb0x2YSt2Q3hBdk44bUk1MjRTN3dDb21ad25nNDFhd3U5?=
 =?utf-8?B?Rm1MNjBrN05abmZUTHhiTG96M2VPV3N5dzJkKzFJLy8rTmpRTUozT2J6MlJq?=
 =?utf-8?B?RTBwRWdpK2RlL0pYYmNDaFRoaTVxQ08yVlRrVUUwQ0l1REVVWFE5K2dxVElS?=
 =?utf-8?B?R1BKR0lZcHNaUWg3N0RJREVCTmlCUEtnb2xlakFabkExdzZjdDlnQjhBSi93?=
 =?utf-8?B?TkN5cUpHRGxZWFJRakpVRU5aSzFjWmlDWWZpUWNETlJMSjFUNW01d2lOT05D?=
 =?utf-8?B?MG1kRGI1ZUp2dlY0cFc0WklKaDJNai84cTBiYzM5YW0xR1dXU2JmUUtRQmZq?=
 =?utf-8?B?cVRkRmVJa1lsTDNZRVZtWE8vNFBLaVp6NHA2cUNqR2VyZVRhRFZEUExyMW5m?=
 =?utf-8?B?L01BV1BPREpRN1pETEZVNWNPN0RjM0dWb2w2ZExVc2crWHkzZi9QVnJBaWZD?=
 =?utf-8?B?QzFuZ0EycHFmWUhFV0Z1Mmh0b3VOck1odEEwMXRDSDVxODVEK1FiQmZMN2ps?=
 =?utf-8?B?VENqTnhDMEtCbnhQdEtXMmVWTmczOWx1RVJXemZUczJwT2ZBTi9qMzBXRk0r?=
 =?utf-8?B?YW90VGZuZ2NLMTRDWWxLZFVKWTJoSWZsNE96TW1SaG1LWnlyaUpFUHV0KzdE?=
 =?utf-8?B?MkJnbWlYNWxDbmFDUE9aQXE0Ym5YcjJtSlBsMVBxd09YZXBkSE50MHMrcCtW?=
 =?utf-8?B?SCtDZTZtTDNwMktUTEt3cGVmL29WdWZGeEF2UzFka2JNa01PMkw0dHVXNXRS?=
 =?utf-8?B?ZE5OTGpVb0xEZ0R0TXhzWXlDcWdSeUZ1MDIzelIvVXVLeERQR2hBOXVvc1NZ?=
 =?utf-8?B?c0VkZEorTkMwK3RhTG1Td1pnSzJtNEdleXBkL0Q5dXJoZ2R4Zm5TcXFwTUNH?=
 =?utf-8?B?Y2t2cFJtdmtnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzMwcG0wQXpYWDc0cS90Y2RzTGM1T2V6YmVSN204Q0NnMVdlT2Y0allRNWIz?=
 =?utf-8?B?d0s2VHZnYkN6dDVCbHprR2JtV2xsT2JOcWZ4MUxMS3JZK3lZY09hKzBxNnBr?=
 =?utf-8?B?TERlZEtMMW03cVZ1MXhaYVN4a1lvVVN5T1YwYlBEZVY1SGJDdXY4dUczNHlk?=
 =?utf-8?B?TTNaYjN4ckx4ZUJZRUFOeDRneW8xcHVoV2tDTDEvanNGTVpJNDh6L1BZcmhv?=
 =?utf-8?B?TkdPWWlGY2pyODdVZUg4TWZWaUcwdVNPZ3F1Um5rUXdKeUtPZVk2QW9tZVhK?=
 =?utf-8?B?OTdIN1ZUKytsb3RYTElMQURZWWF3MFVIaVlLaUVWS1dXeUV0dGIrbnZVOG5O?=
 =?utf-8?B?RWxNcXdrdWFqMjlJckJ6WEVrYjg0VEFsaGxYWjZZQXMwbnFySDlxRU9aSTI0?=
 =?utf-8?B?S1RjdUc1RUl3bWJYVWsrNjlVZUdFUThsWEJZeGVEYlJsYzlTODJGV0huN2du?=
 =?utf-8?B?dFMxRW1MeDkvNUQremsxbTJNbUh5YmJ0eVh5VUZHSDk0NU95WmFVOVVhTXhE?=
 =?utf-8?B?TjJvK1R3V2NIMXh0WUFvVHBpR2psbGxXQ096bWUzNy9JeXozOURLbXpoU3Yw?=
 =?utf-8?B?ZGpWejMxWmNqU2FVWUZvMktrMjBDSHU3VXlIOFlCM2hjajVaaXlIS0IyczRu?=
 =?utf-8?B?NWxXUmgxUlJPM1ZQVHdmb2NVNDI0dERWc2VLaDU4VEQwd3ZkdUhqNzcyRHZt?=
 =?utf-8?B?TVBCalJRM1dBMmU0d1ZxNFVBQlhCTUQ5VFp5NFplQnFhd0dyNkU3ekIrblgz?=
 =?utf-8?B?WWNCMFdMNncrRjJiMHRvcVhPMUY5c0IwQXBvSTZBK2VVSExwaFZxaW5YaGU0?=
 =?utf-8?B?MlhvYzJvL0UzaTBTWVBlS1VkUzRpVXZvZlE1Ny9NeHhBbjU0aWprengzdjkv?=
 =?utf-8?B?WWZBL2dGemYrdkU5a3loaExlcGdpUU9nRHhHTUNYRzh4N0kveG56OUhCMk10?=
 =?utf-8?B?Q2NaQjdObjdQbkNITWs3WGZaLzJhZ040LzF6UUMybVBrM3lHMmZRdHhqZG9M?=
 =?utf-8?B?TmZpaHdjNTl4ZDE5WGV3bS82NUMxSFNCb3U2N2NqZjV4U3NHWXU5eXY4V21n?=
 =?utf-8?B?VjJxb3pvMlJ1ZnZvWnZHMGkwVXNqNHpwTW9XelpOTm43TUErcU9ERTZUL25H?=
 =?utf-8?B?Mmd6NjVOUHAzdCs4RGtYRS85YjZLeFhXbHljRnMrS1NRVEJLNWJVZVUxUURW?=
 =?utf-8?B?eGk5MWdyVlR3QjJkZHhTaHpMOXZneTBobGFqK3FMOFF6SjU0VUpuSzVzTEpm?=
 =?utf-8?B?QW1lWWdvOEZtYjFOaWlLUDVLODhBNExUbERtVEdIa2tHNkJSVi9BYkVla3VP?=
 =?utf-8?B?YThOZ3pDbTd3SlVTM2RYTjAzME1HZkJYR3IyRWxWd2drWUVDbFBRdDYzQURU?=
 =?utf-8?B?Q0x3RXNtUEVyemZvSEZQM2lDMzVVMytaazNBUi9mMkZ0bjZYSzhrWjc2WEhD?=
 =?utf-8?B?RlJxODdLMzBaU1VZdDlTOUtBUUFYdm1qYWZRRzMwMHM1Q0I4K2dpWjlwUGUy?=
 =?utf-8?B?S2krdXhlY3Jvem53T29PNUdmWjNCdDg4aEZOK0dTTURHZERsSFR4VGJiT0tP?=
 =?utf-8?B?UWNPQkRGaGVPKzVrSVBpSXR6YWNtSFRvb1VxMTZlaEdoNTdSbWFkQ0x2ZWtU?=
 =?utf-8?B?aUd5alRzd1JEeDBwakllZjZQNVlkNit6SDdrMURBNDd2NFJ3SktIREZsZVBI?=
 =?utf-8?B?anh2M1pWak1hTzYvVmMxdGUzOEtxUlBEaWlRVlk0NTBKcG82Nit6V2sxRlVU?=
 =?utf-8?B?WCtSb3hMT2ZFQUt5N0U1blhtMkNyM1J3ZHlLWGR3TUsxb2h3SitrbEMvVTFX?=
 =?utf-8?B?RmZZZTV2THVySDNMTDIxVEJRYnlFWmdFMXNOWHYxUkZKOHhaWEt1Y0JCYUhR?=
 =?utf-8?B?WUhLOE1RZkdEWGoxd1lmaHVvbS9SbUdjMlpFY3pjUmVDTnJtYjMzb1U3QUN0?=
 =?utf-8?B?UW1nMExBaFFZS1JpTmZLOFlWWmhYdEtvSUdxQXZxeUlkWUtxWUV1eFdHODZJ?=
 =?utf-8?B?OVV4cXFldHJMNER4ajJvTHBkeFJ0VExmbVhxVEdlejBGT1RPeXJOTm93S09L?=
 =?utf-8?B?T0NjYkNIREFOenhzMHlJMWVNQ2VCWnpLbVNvMmxRaXlkakovS1N1QWkvL0JF?=
 =?utf-8?Q?aDv5gHNNrNqTCwCun+FVmugsH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3536fe5-1f9a-4564-80f1-08ddf79b333b
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 16:40:11.0289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5z25FTSqiCxd6Glph4NjxQg25BpkkubtkPwkYPzeX7Isghls18rDNSUWfm92HDv9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073

Hi Reinette,

On 9/18/2025 12:09 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> Add the command line option to enable or disable the new resctrl feature
>> L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE).
> 
> Since SDCIAE is the architecture specific feature while the generic resctrl feature
> is "io_alloc" I think it will be more accurate to say something similar to the
> ABMC changelog:
> 	Add a kernel command-line parameter to enable or disable the exposure of
> 	the L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE) hardware
> 	feature to resctrl.
> 

Sure.

>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> With changelog change:
> 
> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> 

Thanks
Babu

