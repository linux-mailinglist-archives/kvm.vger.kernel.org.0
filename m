Return-Path: <kvm+bounces-58191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC820B8B3CF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AB2A188728D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E2D2C178E;
	Fri, 19 Sep 2025 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FRTLsb3D"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F2F28314D;
	Fri, 19 Sep 2025 20:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758314993; cv=fail; b=F4QgQBk9WEQmAd1OCv15mzPVdWW7+yNU1NRtn/bZob8zYipWeA4JcHvWvWlGDlYBhR4dbtLhcuI3rqzOBeh2IYgHL8p5KUa/ZIRf3ehFrSc/p3v1LvZ9tQvlD0/InPVq1UGRLbf3a9zwTwuoQpcA9psLxuYtLpLHKt1en9HJ1Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758314993; c=relaxed/simple;
	bh=jrofQ5mN3tOobuyYp9zzZKsi4lxCqzFiCi0a8Aorr/U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VTHnokgkLKssoFwUSPF085tWyrVJwJd4AJwq5BcmG4VA6bAs9JM48RFhYq66C15zh+KPoG3WEa8+5eifKJrcZjduusdxYDEV45rJftVYEwDSspVqdvvYAYxc7Q+faFw4FJC7DyMYpra59P7V/feFCU5k6bstz0QP6yuP/XEOyNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FRTLsb3D; arc=fail smtp.client-ip=52.101.62.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Off2v6bH3ArDTUEEmy/27/KeXjsZlRDdN/1JkEx76JxulR9aLVoeuRDXQcx/YMiHu1n6bBeu5qDCkR/7ekmnMBf0kAM4GXAj6ktAVlDDAMfLBeaup7dsVqGcBn72IJXqfh4P0zV35gZ15Kv1TueVStw3OkpOgcY6qsD405+ngyJuxWbSm9xpoFWkOeYwjyBqnqq7RqC0uHGopHZZ0bXWo39PkR65YAK0Yiem+y7Iki9ib/5GQUNpgElRiPef2cuWJJyj3iTaG50UtxUwNA4k+f92tJu2MGeU+rSW497h2pdNnNP1C6wv4h0zkpKMkVXz/Dkum9AmI3/W2uDu3IEtDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrXTePh3qSRka3TYCsjYf+vcMcJrPomcy9H8XVhErvU=;
 b=chXwVS4xxEEk41NAiKLaZ21WLkS4emkPygOL28YI75YgiUUyPc6mOs9a0jX6SOvLomNJhQgtJRkLvo5bkraIm7GYD+PvJnQJuTm0fgYAljZt6gJRYepyS10VHGyYMBHrTT9dVT1MfYOLb2XFCGmaBGdqGmL3YW9YXmVw+2SkPrJbYQiI20bjTSIN9tt9TR9mqDnHX7mDAHa0tR+WaLYbJG/ab1Ud6fpJ08l8XeHwoIjbXcNKiD4lzXnyn2Dn+YT3m1lvvTRKBNnztifYBf8AlcHZnFTq9E7Kr/3/SfaxAfyaaUzn9AseaLB8/CULxCy+T9mlLm5t/jATpTpSJORcWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrXTePh3qSRka3TYCsjYf+vcMcJrPomcy9H8XVhErvU=;
 b=FRTLsb3D+UDKZiWj17UtwsRy1fk5JKP4He4LJEKJNcCQtOK9SDiOVJmVuEXkfyaF2x8rF74BxH5v0dX30+H+WWIwnDjiTZxHVS1x4X+iwZoIiU/WCvShk15v+bFCke+3AeWYpbPRIkCHScN+SUs2tkTpg03w0IZrm2pG/BTEDG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SJ0PR12MB8166.namprd12.prod.outlook.com
 (2603:10b6:a03:4e2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 20:49:46 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 20:49:46 +0000
Message-ID: <7c6a4f7e-e810-4d81-b01d-b0cbf644472f@amd.com>
Date: Fri, 19 Sep 2025 15:49:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/10] fs/resctrl: Introduce interface to modify
 io_alloc Capacity Bit Masks
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
 <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
 <1cd5f0a7-2478-41b8-97cc-413fa19205dd@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <1cd5f0a7-2478-41b8-97cc-413fa19205dd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0048.namprd14.prod.outlook.com
 (2603:10b6:5:18f::25) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c6d1fb-2545-4056-be16-08ddf7be116b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2ExeFNRMkZxS2JpMlBXYlhuMmdvZTdUQTFVZ0FHSFpvVnQxUUo2Y3VpS1Bp?=
 =?utf-8?B?Q3QzSExoSit2ZVF4SmduUVR4endiNk5CZnppZ3NZNHd3b2gyL3h5ajJqWFRG?=
 =?utf-8?B?L1k4ajBMN21xZTIzT2Fta0hKeWRxWDlibFJsWkVrZGV0cklnK3EyRkpSZ2VQ?=
 =?utf-8?B?aXhwR2NacWo3N3RvM29UN2kvbWtXeVVCS3RUOGhJSk9iK3IwRjdwTnhEdFh3?=
 =?utf-8?B?YUlLZ25TcVBTUTZ5eWxOaTg3bVhUOStvNVJVRlVzVXFIdkVadzZZQVJOdkxv?=
 =?utf-8?B?alNadGNSZ2xNVG9WaGEzRzFuUGRhTXNwY2I3MkFDbXpnWk1VWXJPNm1JM1BJ?=
 =?utf-8?B?MWlybFRWSUFCT1c1R212SXpQMk1JNkRDVERKbFQ1NDJUWXNvcm5uU3NycVFR?=
 =?utf-8?B?UWtWZ2pJTVpHc0lxeWtubEM2aS9WYlhTclpoL2xPZ1Jnc0lNTnowaHRraVJp?=
 =?utf-8?B?dmdYV3dwUnM1YnhJejFDbmI1czltaTZzVzVuMFhGVTJhL2s0cml6a2p2R2Ju?=
 =?utf-8?B?MWdXU2hwZTdOUHcyV3k0NU1oN1lUWHhmaHUwZUszbHhJMVBieitpbk12Qy9i?=
 =?utf-8?B?VVdqZDR2OXNuYS9BcDM5WkpSWmsraVNRREh4NkRtbE1GeTV0Z2Y2c0FTV3RD?=
 =?utf-8?B?MTBkSWNuNXBEUTFMNWNEdnhnKzljYjhYVmhrNmZhZnpJQ3QxU0xPdXozenV2?=
 =?utf-8?B?eTdQYzdkbmE1enNjM0lSamFRdVkwSEMvdjdOdDNPZGxHK0dHcXJHZ3l0UlBv?=
 =?utf-8?B?T1pBWXlFOHZVNDlONjZSeUF2RFlCd2NzNUtHMEJiTzd0QldYNEJKbGhlSXJV?=
 =?utf-8?B?UmViajBIOXlWOUNxNFdIUXJvSE5OcTd3V2NXS0dXL1g4VmxPYmVDdVRkcTdU?=
 =?utf-8?B?Sm1sTXdNZGpIa0tCTjZxZm1DNFJEL0NtWjFBYTJKbWRCd24wdW5VUXdSUFB6?=
 =?utf-8?B?UzlMOW0yRk9KVEJJQ3JlbzEvL0pJWjUyQ2xlaFpta1g1VldzYitrcXc3TVFQ?=
 =?utf-8?B?ZVljd01qZHBkRUJydFR0NzNrd2ppZGU2LzBCRkltc01sUXNINXNNMnN6WTBl?=
 =?utf-8?B?NUI1TDU2Q3NEWVRpSitpUWRMeUZ0WjIrVTNQVzA2Sm4ydTR2RDcvQm4yc0F5?=
 =?utf-8?B?Vk5OamFnVmovY1VrV00wTk82bFVSYk5ZdWxEQXMybE81S1FSL2R4bXdNVUdl?=
 =?utf-8?B?ODZFaVFFZS9Td1h2eVAxcEtEN01XS3VCZ0tDdU12UndJazdNWEhRai9iUzlP?=
 =?utf-8?B?ZHNjUEdFMmVrMmJhSXdKa2RZSzd5dk9FZnJQVk9KOGhJL1RENWJwSGM0WTlH?=
 =?utf-8?B?bnV1WnMrNWpnMDdIVmxkRkNhaG5YVGZJRUJ3YVlpd2laQXBVck1uYjJQWGZR?=
 =?utf-8?B?UlFabVN4SjZlYnBEM25Xc1dyTVErMmIrTk1PLzA0NXplUmROU0dTaEVuWXp5?=
 =?utf-8?B?eTk1NjhkbTIxTDdIbk5HV0U4eFpkdktkSEc1dktmRDhUR0lsU1BZbUpLdjN5?=
 =?utf-8?B?a3ZhOEN5SUlNTmpKa1JVUHNrbDl4ZlROZ0hKWWdnRVcraWJCWjhqZ1gwYmFl?=
 =?utf-8?B?UFNGTjlTakt4NkEvbEM3SG5MczZVdGU0OFpNcnZDcklZRTlFMS81NDE3aXpx?=
 =?utf-8?B?M2xMSEFFQjR3WnkxVzNjSTJuWms5V2NXZERxWnR5ZlpBbTVWbTNHMG9uOE5l?=
 =?utf-8?B?dVNhaldzSDJEbHpsa1hQbVYxckxtbzZUQXpNaGtDS3ordWJ6OE9oYi8zem5J?=
 =?utf-8?B?TFFUdkNPVSs5bXEyU2lNZjFIRnE1VGVhRDFNdm9OWVp1YUxXVWxhTkdqdTNi?=
 =?utf-8?B?bUw2MnZhelFUMXdmdXZ1Y1Z0cTNVTnZnanhyVDZqTVlKQWEwZGNZUC9LQ3My?=
 =?utf-8?B?di92RTBScmNCOGpYUlpKWk0yYnovY3k3dFZGeUtIcllTMEVRUmJSZzJUMndh?=
 =?utf-8?B?SGFHQ3JRMUNTcE8rSHRLYzIzYlNkL0orb09YUTgrWjcxNGRDdmNySUtJSzRl?=
 =?utf-8?B?TG1odHA1UUNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sms3V1hhSmhacnphcVRUYVBsUXY5UUNkeFo1S1ROQnNEajd2alF4VE4yZEFY?=
 =?utf-8?B?TkdoSEYxZGxqUlltK1lTQTlLdDdTQ3Nka0lFY243SjBsdkJjTUlSRVRRNmJh?=
 =?utf-8?B?R293NDVmK3BIUFg0SUVHQm54TEtNcno4YVQ1NnZuVlh2RUY1WklEVGVhVjl2?=
 =?utf-8?B?bjc4N2d5SkNNOHRnczJGODMwbnE5eWJROU4rcHV0dmpkU2dJNk5ycWYwUXlq?=
 =?utf-8?B?SUhNdlNyQ1Ird0l5cVZ2UVRQVzQ5d1ArVTFuVmVSVW5lUXJLbEhTRlA0bXc5?=
 =?utf-8?B?ZUJocTNLYzFwZzZKVzVzeVhuRmtIakFMdGY1OWgybWh2ZWdQZjF3VjZqMDJC?=
 =?utf-8?B?OSt4eGJ1ODQxSnRyZnNOdHkxU3pjZkFrYjUzZFpsY3NZMU5aZ3FuMUJPMS9H?=
 =?utf-8?B?WGhSU05HajVRNjJLWVEvQ05hKzBURFl3bERUd0J5bXRKZjhKY2UybkVHYlhE?=
 =?utf-8?B?ZEhpZE15cjVKME01SUxGbXFicFN0NEMwbHNWd29iajVJTXZUQ2xpMU9JRFJu?=
 =?utf-8?B?ZC9hZ05GTm1aYU1FZlFTNXVPVHRTeHhZdmV3VFlOR2VMS3llbGdYbXRDZ0k1?=
 =?utf-8?B?MDlNNVJCc3NYdGpwVXNRNlM0VnlGbERkUXFNVmg2WmwwRWxXOXRUUkhXTE5p?=
 =?utf-8?B?aTkvY2Vyc2dGME9sMEFQMVI4VHE0K20zVnNLaVd6SzZpRXRsYTc1ZldzLzZi?=
 =?utf-8?B?T0RVZHJVVW5zYW50Tk9aS2FoQlJBRXBaY0dzZGZKMEh1dDFuTERZSStUaXJ3?=
 =?utf-8?B?Q3UyZzJ1THhDeWs2dzBBSnVKNTZGS1NNcndoM09DNkcwRk4rd2NSN1IzVkh4?=
 =?utf-8?B?Qm1GN2pQYkFoYmlRRGg2MUN3b1hzWUNOaGdYV0xpSGJJT01IZHh6TWt5QVlv?=
 =?utf-8?B?NHhZajFFak5YdnZUdmVUNnJ4SzdKNDI2blpZdmdiQ25WcVJmNG1kZHRPWHhK?=
 =?utf-8?B?cWlicWNseGExYmwyeHJhSUJ4aDZZNkZWTWlmVTU1WlVVVlQzQUREYTc2R2VN?=
 =?utf-8?B?amtLTzlETW9zVFVRUEkxays2TGNJMUlYZHREODVWSW54SnZ4Y0dsajZudExs?=
 =?utf-8?B?dmtWK0o2MVh6TWgybTh3OGJubDFzSk9NV1VWOFI3VktSNmxGZUQzWFZqa0xh?=
 =?utf-8?B?WjMvUkQ1a0M4Z0wwT21BSjU3TE9FL1ZuOUMyb3hkN2dvRE1LMlFHRFJLWHcv?=
 =?utf-8?B?QlVoVzl6Wmd6VUI0cUJVYzdySWIvSlY3ejZ2bi9zT1BOVnliWWdWR0h6Q1Ar?=
 =?utf-8?B?ZG4zZXBqVWdnOFY4RXhRb1NjRUIxb0ZJcXNxdnMyZUo1aEF2ZnVFSjhsZjZI?=
 =?utf-8?B?UVZmUEx0dmtqajIrRXI0aXhnZ3FTOTJHTE9ISlNxN0RuclBvQkZLK2Z1Q1h2?=
 =?utf-8?B?eDM0SEpNeG1iUmttQ3VaYTlKY1kwQXQ0UEkwM1RzVDYrZlVoN0F0RkdWWTdM?=
 =?utf-8?B?T2hTeGNVNHl3eHorWmlXSmd0bGdpRSt5eGd2RFpwUXlpdHpGbWJBMm56eVBH?=
 =?utf-8?B?bG04TkZUNUE3ci9wV053WGp0NFRUNk5JSHoydTBhQU5ydVExRW9PQXVMNmFz?=
 =?utf-8?B?MmZXWVI2emoxNldLVzRhdDBoakpEZ1BtT0pGb2dETDUyTU1IeUZwTjAxNFdX?=
 =?utf-8?B?UGZ5Y2lEenQxTXdnVDk0Z3kzT3hCYlY5eGRiUVdoQ3NyWTRHbExIdGJFSW9E?=
 =?utf-8?B?bUdGS3JlVkE2U3J0Vkl0R1J4UjBuYWZ1Qm01WlgwbFNDS1duRDVxMlV2emNN?=
 =?utf-8?B?R0x0TWRlWkxHSHk1NlNUM25UOTJaRllUVzJuVi8zZEJzbFZ2MlFZTlV2S1dy?=
 =?utf-8?B?MmE2ZGZnRXJCQmlVV0UrdXVLWVpCbG9NRm9SVEJUOFNxVWVXR1J3VmZ2Q05j?=
 =?utf-8?B?Ynd0WkdodzJlUUpkNXpDb0pWUTU3KzdZNEcwWVkxaWZOdGhiZkszL1RQdFE5?=
 =?utf-8?B?MFFROVp3VjNjYkVIUCtSMC9JMW9nbXZ4dlF3UGo5VWhJUHVtQ2JFMmdmbmRO?=
 =?utf-8?B?UDhFUTIvc2o1L2w0SWtvRFEwbjNTdFJHSHMwNmVMNXRveTBVK3JwTjVxMmxH?=
 =?utf-8?B?dFJhbjdyU1pzTkJhdXZua0xXN3l6ODduaHlURDJvK2lTWVhmVWNsaXFYdFlp?=
 =?utf-8?Q?4zTA0cD++iZbpFZcSpdyg4YzU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c6d1fb-2545-4056-be16-08ddf7be116b
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:49:46.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4b3ZcTI2nPbdWHhHZjJWs7miZWM1zSS67N9K/dGrVp/V8MiKk7fo3qcGKFVXA/vE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166

Hi Reinette,

On 9/18/2025 1:03 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> The io_alloc feature in resctrl enables system software to configure the
>> portion of the cache allocated for I/O traffic. When supported, the
>> io_alloc_cbm file in resctrl provides access to Capacity Bit Masks (CBMs)
>> reserved for I/O devices.
> 
> reserved -> allocated?

Sure.

> 
> The cache portions represented by CBMs are not reserved for I/O devices - these
> portions are available for sharing and can still be used by CPU cache allocation.
> 
>>
>> Enable users to modify io_alloc CBMs (Capacity Bit Masks) via the
> 
> Can drop "(Capacity Bit Masks)" since acronym was spelled out in first paragraph.

sure.

> 
>> io_alloc_cbm resctrl file when io_alloc is enabled.
>>
>> To ensure consistent cache allocation when CDP is enabled, the CBMs
> 
> This is not about "consistent cache allocation" but instead a consistent user
> interface. How about "To present consistent I/O allocation information to user
> space when CDP is enabled, the CBMs ..."
> 
>> written to either L3CODE or L3DATA are mirrored to the other, keeping both
>> resource types synchronized.
> 
> (needs imperative)

Here is the updated full changelog.

fs/resctrl: Introduce interface to modify io_alloc Capacity Bit Masks

The io_alloc feature in resctrl enables system software to configure the
portion of the cache allocated for I/O traffic. When supported, the
io_alloc_cbm file in resctrl provides access to Capacity Bit Masks 
(CBMs) allocated for I/O devices.

Enable users to modify io_alloc CBMs via io_alloc_cbm resctrl file when 
the feature is enabled.

Mirror the CBMs between CDP_CODE and CDP_DATA when CDP is enabled to 
present consistent I/O allocation information to user space and keep 
both resource types synchronized.

Signed-off-by: Babu Moger <babu.moger@amd.com>


> 
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> ...
> 
>> ---
>>   Documentation/filesystems/resctrl.rst | 11 ++++
>>   fs/resctrl/ctrlmondata.c              | 93 +++++++++++++++++++++++++++
>>   fs/resctrl/internal.h                 |  3 +
>>   fs/resctrl/rdtgroup.c                 |  3 +-
>>   4 files changed, 109 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>> index 15e3a4abf90e..7e3eda324de5 100644
>> --- a/Documentation/filesystems/resctrl.rst
>> +++ b/Documentation/filesystems/resctrl.rst
>> @@ -188,6 +188,17 @@ related to allocation:
>>   			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
>>   			0=ffff;1=ffff
>>   
>> +		CBMs can be configured by writing to the interface.
>> +
>> +		Example::
>> +
>> +			# echo 1=ff > /sys/fs/resctrl/info/L3/io_alloc_cbm
>> +			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
>> +			0=ffff;1=00ff
>> +			# echo 0=ff;1=f > /sys/fs/resctrl/info/L3/io_alloc_cbm
> 
> To accommodate how a shell may interpret above this should perhaps be (see schemata examples):

Sure.

> 
> 			# echo "0=ff;1=f" > /sys/fs/resctrl/info/L3/io_alloc_cbm
> 
>> +			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
>> +			0=00ff;1=000f
>> +
>>   		When CDP is enabled "io_alloc_cbm" associated with the DATA and CODE
>>   		resources may reflect the same values. For example, values read from and
>>   		written to /sys/fs/resctrl/info/L3DATA/io_alloc_cbm may be reflected by
>> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
>> index a4e861733a95..791ecb559b50 100644
>> --- a/fs/resctrl/ctrlmondata.c
>> +++ b/fs/resctrl/ctrlmondata.c
>> @@ -848,3 +848,96 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
>>   	cpus_read_unlock();
>>   	return ret;
>>   }
>> +
>> +static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
>> +				       struct resctrl_schema *s, u32 closid)
>> +{
>> +	enum resctrl_conf_type peer_type;
>> +	struct rdt_parse_data data;
>> +	struct rdt_ctrl_domain *d;
>> +	char *dom = NULL, *id;
>> +	unsigned long dom_id;
>> +
>> +next:
>> +	if (!line || line[0] == '\0')
>> +		return 0;
>> +
>> +	dom = strsep(&line, ";");
>> +	id = strsep(&dom, "=");
>> +	if (!dom || kstrtoul(id, 10, &dom_id)) {
>> +		rdt_last_cmd_puts("Missing '=' or non-numeric domain\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dom = strim(dom);
>> +	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
>> +		if (d->hdr.id == dom_id) {
>> +			data.buf = dom;
>> +			data.mode = RDT_MODE_SHAREABLE;
>> +			data.closid = closid;
>> +			if (parse_cbm(&data, s, d))
>> +				return -EINVAL;
>> +			/*
>> +			 * When CDP is enabled, update the schema for both CDP_DATA
>> +			 * and CDP_CODE.
> 
> The comment just describes what can be seen from the code. How about something like
> "Keep io_alloc CLOSID's CBM of CDP_CODE and CDP_DATA in sync."?

Sure.

> 
> Of note is that these comments are generic while earlier comments related to CDP are L3
> specific ("L3CODE" and "L3DATA"). Having resource specific names in generic code is not ideal,
> even if first implementation is only for L3. I think this was done in many places though,
> even in a couple of the changelogs I created and I now realize the impact after seeing
> this comment. Could you please take a look to make the name generic when it is used in
> generic changelog and comments?

Sure.

> 
>> +			 */
>> +			if (resctrl_arch_get_cdp_enabled(r->rid)) {
>> +				peer_type = resctrl_peer_type(s->conf_type);
>> +				memcpy(&d->staged_config[peer_type],
>> +				       &d->staged_config[s->conf_type],
>> +				       sizeof(d->staged_config[0]));
>> +			}
>> +			goto next;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
>> +				   size_t nbytes, loff_t off)
>> +{
>> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
>> +	struct rdt_resource *r = s->res;
>> +	u32 io_alloc_closid;
>> +	int ret = 0;
>> +
>> +	/* Valid input requires a trailing newline */
>> +	if (nbytes == 0 || buf[nbytes - 1] != '\n')
>> +		return -EINVAL;
>> +
>> +	buf[nbytes - 1] = '\0';
>> +
>> +	cpus_read_lock();
>> +	mutex_lock(&rdtgroup_mutex);
>> +	rdt_last_cmd_clear();
>> +
>> +	if (!r->cache.io_alloc_capable) {
>> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
>> +		ret = -ENODEV;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!resctrl_arch_get_io_alloc_enabled(r)) {
>> +		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
>> +		ret = -ENODEV;
> 
> Compare to comment in patch #7 where the same error of io_alloc not being enabled results
> in different error code (EINVAL). Please keep these consistent.

Yes. Changed it to -EINVAL.

thanks
Babu


> 
> 


