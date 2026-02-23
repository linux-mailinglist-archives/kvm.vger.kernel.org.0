Return-Path: <kvm+bounces-71539-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLMDI1nWnGkJLAQAu9opvQ
	(envelope-from <kvm+bounces-71539-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:36:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A78017E6BD
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DF7BD3010902
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6F637B40E;
	Mon, 23 Feb 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zcmTswK8"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4C1C8604;
	Mon, 23 Feb 2026 22:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886157; cv=fail; b=BuOv4XqkL8me/vFV1waN0cuac5HfzSE/+87NBw/xPY5mVrH84UqZK4h+VcAGsODi/EatN6ujt295ZFDrunyNU5BKd+X7gUNoR2fhyxJ2nT3bsjfZ+lLFxrmdtbSJG7KaPPaONBOGedgM360TxhXNAOJDSyHS/BrI9s3IeH9oOUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886157; c=relaxed/simple;
	bh=9uIpeqHFsAitKl0gwSmR/uEdm7fn1Y26JxOZ8GPwl7s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CyoHK/QeNyWNNlaOchGbexE0+L1bslibLb/zK3A8x2112ONzNMdvHEN2f15MOdbGK8d6PBDuXFxVN3kpkggxQN7wiDyi6TIuUbRQr3CE7IuJkTVxE/R7hLLWIzyOFH4i2DcfbUp7MzW5KYMxzu8w7AyOCwDewd1jRvYdohGlOpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zcmTswK8; arc=fail smtp.client-ip=52.101.56.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WljN6MBESaBWDPEhqjnmFiEPoVP47niwJ4tg0mMMC+QFwnBVK82EmfiPT+UYltqPhpQdcgiOBzI3kVmDUQPMHWnQmwvGKqh7K7P5YPQCcyMUnqb1xn1Hsq2OFPiDRFf7aP0Aycfby5D0+euXthEGVoSfVPEuZ8z049Vgm+rL67UB7TMAZR8sdwxyl8Mi2Eef7XbTgHIiAMtUf22BnbwZ/aRxLZpoXQ9sJpaFZg9OOCktzvJATHa1XZYSq9dVTwDDWqr9XE8Uqfb8awWaizCZ6gdNRVejD7fNTNwjszWM67It9LkF+Ce++6rWds0uIY7eACPiU/gYuK55s/mtsA2qxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9q3lbsl+oOvZJ06qjT9fBniGizJ+mSj3JHm6Pnf1He8=;
 b=dXF4QvNEeculgJNM9Ns/YHGM51lmcctqjnoVqZgEZHWautmoZPNhzxkwVzVI7u2Sa9i29gqBqg81SDqDXb4tMkdGzS4rgAZmOyz1lg/sAm8SGJLCMG3A5skSODSu1GVIH09cPHYqvJDpLpU8yFE6uK9+ObThB0hgGkUg4SeQ807vdTUJrjMC6uAX6L9IjTwdw39CnVMVskbexKm+iVnu6ySk7WKhAzkR63GaOHlSaym0N/1UdfGIraAEnSJooVaqUIJYUMSnzQOk0IlcejMPzVAeLgzZmYd9E3rXJLdVAKHi1zPe0TyIlIYIWi+s5BIfFmJxZaCnQ1wmQ9m8sSOhbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9q3lbsl+oOvZJ06qjT9fBniGizJ+mSj3JHm6Pnf1He8=;
 b=zcmTswK8H4xkIIVmkiL3+Ipjg6eSTBzBK3OzSWROIVKc2daQZ3lgV5b/nEbOvOeg33wSBbHzeXPaNdkrMnX+lOMs4XtieTbVC8I+fdAcFhadWbRhO2EFVfF9fCDPQ/mG3o/6w9CeaAQGl8HuVXHH+OSpxcuxu6GXP/Ev8GydrhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CY5PR12MB6430.namprd12.prod.outlook.com
 (2603:10b6:930:3a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 22:35:46 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::e192:692b:abba:8c88]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::e192:692b:abba:8c88%3]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 22:35:46 +0000
Message-ID: <53be07ff-75c6-4bd6-a544-e28454b4f6b3@amd.com>
Date: Mon, 23 Feb 2026 16:35:40 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>,
 "Luck, Tony" <tony.luck@intel.com>, Ben Horgan <ben.horgan@arm.com>,
 "Moger, Babu" <Babu.Moger@amd.com>, "eranian@google.com" <eranian@google.com>
Cc: Drew Fustini <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
 <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
 <37bc4dc5-c908-42cd-83c5-a0476fc9ec82@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <37bc4dc5-c908-42cd-83c5-a0476fc9ec82@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:610:32::33) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e8c41e-0a36-4bc1-67dd-08de732be2b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007|18082099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZW03U2tQRzgyenkyVEZMVnJJczJuWXVLOFJyODkxZGFOa1BDQVRKR2xvOFMv?=
 =?utf-8?B?MHI2cE5ncVc2Vy9jMzdVUmhNTFRQMWZPUmFYT3NKUWlYNzF2Vy9BNUpkZXFS?=
 =?utf-8?B?U2JvTTVHMmptc0QreWxubGxOMEt6NjZhQUVUcG9lcTBHcDR3R3E4cktMbzM1?=
 =?utf-8?B?TUJ1MTJDWFBMbW9QSjQrUkJaUGpoZGRuYjFZZ3ovWU1nNUIyY2swcTZOMllG?=
 =?utf-8?B?VmdCeVE3czNzb3hnc2crZVM5SFVQY01ucXA5T2Vhb2haL2NEUjU4TGVVWGtq?=
 =?utf-8?B?MEJkM1d4VXpDWk5zRjNsQjdhU2pHVFJJcXJYQWNZbEk2RFRWQzRvWGk2RThl?=
 =?utf-8?B?TEFrT1JEc1ovNkJwYVhjcTltb1U2d3NEZTJPaXYyNGt5eDBvdExvRVVZMHZU?=
 =?utf-8?B?TXlpRjJJMVNRNDlZWGJtYnpIRnRyYU9jcW1nck9aK094UHFnMDkxVkROVFFw?=
 =?utf-8?B?aGtQN0UrV3FyZkdwdVpwR05zRUpNV1FzRVBER0NlZFJQSU10dXdpVHNVVUxz?=
 =?utf-8?B?Y2xZcVA5VEVwTDNiMzQ3ZjNXRUJKaVJOQ1lIZW0vY2RFaVpwUnhrV0xmVnVv?=
 =?utf-8?B?STZQN3N2V3Btb1hPTS9qbkRmZGhFOVpLSHVFQ2hNQUczNzNRQ214VXBOZlNO?=
 =?utf-8?B?UkkwZ0llNHhmWGNUSjJFS1hJOC9pRU9TNzJQRWw4b0xHOWJDSXErcnh1SnNr?=
 =?utf-8?B?b252UVNZdDZBNlVvTEdrakZlQ1JDcndJYzZibnJJUUJEcHA4MVdLRDVxT0gw?=
 =?utf-8?B?aHd6UWJrRm9Id24rU3ZrQXlnYUtMYUJlWUw2KzZ6ajV3NEoxODB4REV0ZUNU?=
 =?utf-8?B?OHZJdFdObThHS1lETXhzdHYraE5nRFlsVFFZOHY0WkVNRFZEdGV0c3Y0bVJO?=
 =?utf-8?B?a21LZTV6b0R4VFRvMjBtWmNQckp2K3J2K2dHU1YyR3NrVzFIdWV6VURNOGJx?=
 =?utf-8?B?V0lhdGJmV3M5eE1zTVhqTWRER3ZIUVFXSXpqV3hacWJrRnR2V0FiK0wvRlN4?=
 =?utf-8?B?MlUyNjI3L2pjNm5uS0RvaVN6NHpHMVBRZENpOVpZL2J4MUxRRlg3K1NTQkdw?=
 =?utf-8?B?TXVFcDFzVDVxK0MreTBOZk90R2NiaE4xZnlLSzFXZVdWeURUVC8xREVOUGlH?=
 =?utf-8?B?S0RQMFdEektRN3lGaXdpS1UvdWV4Y245S285dzZzcWlmOWRnY2luT0src013?=
 =?utf-8?B?bkNRZVkrN3RtMk1POWt2QUNOb0R3dWJGMVRLZkVXbW5kS2c1U0ZOVUVyR0tu?=
 =?utf-8?B?bk9sZU5KV0kzOEYzVS9YUTFvS0RJeWtKV2Y1L0VLa08zRFFiNHQ3MjBsMjRY?=
 =?utf-8?B?VnZxZkV5OC9ZUXFGbld3bENYaVJrY1RRcjhTdkkreXU3TEFreFBLVHRyMUdN?=
 =?utf-8?B?MHQ3SUhGWnhCZUE0cGVoajNCck9DOGpFNFZqNHY5cy9TcWVNbDlnZ3VvVVF6?=
 =?utf-8?B?MmluWHA3NDZ4OWwyM25TeEJySDdCNnMrd2QwVWUvbFpid2ZEUFJZUXJ5QmN1?=
 =?utf-8?B?UlJnalBma01hQlhwcVZHUjZYQ08xcUovRjl0OWZTQWJyRENBQldqMHpOUFNQ?=
 =?utf-8?B?eWhHZG1BbmZyY3ZkcnRVY1M1bFlJdWZHL1BrMnRoR29Qa3ZpSGdXQmUxdTZ6?=
 =?utf-8?B?b3NYYmZXOTdUaHpHcTdKR013NE5HbTdmZkpaSW1UNmNVZzZyOStyZDNBWWhT?=
 =?utf-8?B?dFFWYkh4TWk3TkEzSjBLU1Zwa3YvNHVsZ1dGUTJ6UGo1Q2Q1RGtPSjJOWlNH?=
 =?utf-8?B?N1BwZ0xyUjhQTXV3cmMyVnZRSjdpeTIwQlFheWN0OWtnM0lyMlphQlgvaWFy?=
 =?utf-8?B?bnJjbWMzT0svWXlTZkJ6S2xpSFpKRmQyUDltby9hQzFESm1MLy84bXdWYjBX?=
 =?utf-8?B?SFNpaGpCWkZXTC9PbDh3bkVyS3hQbkg5Nm5rMnFuM1VrZkRDdUFDbjlKejhq?=
 =?utf-8?B?TUw1R25SRXNFVUx0WTluclQySG93eGRFdnNmOHEwWmswSUN5RDNkTEwwYjFu?=
 =?utf-8?B?S2pmbHlnNnYzU2x0ZURQazFUaGZzTVIvTFB0ZkVHQXlsM3VKRURVK29ScFph?=
 =?utf-8?B?ZVVKZ2dxSmNFNkF5SnFaRnIwK2Y0VXExV2EwZFN3eWlJb1RTMTVnZmRSNHpI?=
 =?utf-8?Q?79sHE6Wq1nYlDhW7iPksE+56H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007)(18082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkhzOFV2d200TEVxbEUyOVRWekR1ZHFIV3NRNjNxdXY0ZmhvMXkzZ25MSCtr?=
 =?utf-8?B?V3pDaWlZVVhubjBWK2h4QXVFUHVPYlBrUVgwL2g1TVE4UUFGWDhtMW5HT0Yx?=
 =?utf-8?B?V2xBUE1uTmFEOVhTOVA1SFVYdG52UDkvSVV4bVczMFU0Y01CN2RDaWpOSGx2?=
 =?utf-8?B?K2QvcnNjaWd6RjlOTzRXcFhkUlR5QnZKQ1E1REV6QVNxU0ZyYjhvdXduTDFB?=
 =?utf-8?B?TDdISFdlaDl3SllydXRIbEU0bmNja1YrQVYzdDhVV0ZoNEYxcUtiTDgvQk50?=
 =?utf-8?B?YWVLbkJzMVY1WU50MVErQjRvSC9CWmtGY0dDcVRvSlBNWGtzZmVtaGFTU0JS?=
 =?utf-8?B?eFU5SjVIdXlaekNNNnQwK1hQOWdaOHI1QWQ3RVRSaEY3VERubjI1QUhGR1E2?=
 =?utf-8?B?NkM4YkdwUEI3ZGtTMTJqeHZUZjIyWWhaYTdKWGlkbm5yQWFFR1BOVkFrTU5o?=
 =?utf-8?B?NVRwWmVidk81T2xMaldOdmR5OXJPeXBtc2tsQmFrcmErOCtZWitma1pWcGx2?=
 =?utf-8?B?cnFtdUt6QUVIaTBwMW5hQkRHOEY3bzZKQnRaTU1hM3E2dWpRSExWREdRNFNU?=
 =?utf-8?B?QzlLb25IU3RwVjNFWjY4bSs1MWE2ZVlDMVFuczZpY0dvSnNxVjR4cXhKSkJG?=
 =?utf-8?B?aSs0RnY5dEtrMncxSmRmWkk5Tm5uckhHRWoxVnZkbEE5L3ZRS3dSSVNIdUY5?=
 =?utf-8?B?OTU3NzFYbFNUaDlSbUpvb0JjK3lyUTFPem1Gb3VuKzZEblA0R1VJMG9IaUt3?=
 =?utf-8?B?Zk9RbWNwdzFPdUdLNTU0cHIrMEhUbklJZzBwMUtud1BucDlqSFhSQVRnczhD?=
 =?utf-8?B?dVVJaE4wTjJYdlpqNjcxQ1R3OUxzQmkycnZlWnFnNFlWY3pGSWs1T1BkZldL?=
 =?utf-8?B?Qm15ZjJjL3psZi9MYkoxR0dwN1BENE03clZiZ20vNGN0dHhQdEN4MnhjQkZS?=
 =?utf-8?B?OHRMclNJbThVZUdTaXgxbFdOWUp5Y2RzT1FsdXhtQTFoNmE1SVMvZithWG9M?=
 =?utf-8?B?YjBkWEErcFdUT3lTZFlzZlhSRXVkYXRnMDMvN0VNTUJEbWUxVGhMaExIcmMz?=
 =?utf-8?B?dzZ4cHYyZzYySy84YUZQMUo4aEs0YTRwUG5ySUoyVzBEWEh6d1NhWitPNkRD?=
 =?utf-8?B?NUViU1AzRTlQMFdvd2FycXlFMWRsQ0s0WmswdUtvZW5Qcnp2WnJiVis0dVA5?=
 =?utf-8?B?RkZvQzBiMU1uRDNjNjBmTzZzUjl3bjR6Z1lzSlJvTFVid3VrV2JieG50NzFV?=
 =?utf-8?B?R29yZEsrRG1SZGN5UVdnckVrOStGZ0d4TFRlbHVJREd2aFBXbWhVMDRZWndp?=
 =?utf-8?B?dnM0aWZINmZEVm9DV2UrYTdKVFJNNmhlaFJXZ3hJamUvaXNqRm0zQmphdVBw?=
 =?utf-8?B?SVFUaUxxRkdQbUwvNkFGak10RXZmeElJNHFCeU5IakFqbGlESW01VGd0OGJz?=
 =?utf-8?B?d3hZZytqblE2b1RqWmdrOUxoZWRxSnpjU2ErUHlyeERrV0FKV00vckl2MGF2?=
 =?utf-8?B?R3F3eG1odTAyRExEeUw5eVdFRmt5enN6Sk5BMVZjaFppU3NPZ2N0ZHloQkJ3?=
 =?utf-8?B?MHk0OC9Tc2gzYzJ2b283M01KN3dGYjN2a3VEc0RRSHBVK1BrWlBoUWhzcTdE?=
 =?utf-8?B?VjNxREVHTlRNMDhyUEhpQllmWGFXakNNQWM0SW1hR0VVdmJjbUU5dVJDN0Zs?=
 =?utf-8?B?UDVjRkhXUXNUK0t6cHRvZnpIUm5vUERRamFlNEZYS0FmWU51enpPc0lIL1J3?=
 =?utf-8?B?cWd6bjYvV1FTbkNQNXBDOEpDRnU2M0Z1MXd4UTZkWENvbGZvZTlzZjh0Wk0r?=
 =?utf-8?B?SERNdk9ZeHAxeWo1Y252ODYrQ3JQRmd2ZmNRenQvWEsrbEVOWWx6dEhqOWRj?=
 =?utf-8?B?a204SHBKb2xwM042RDZmaEczVTlaN3RVZEZwYnM5YWR4cFZxVHJtTi91NlFL?=
 =?utf-8?B?UFhVY2lQWkc0VERiSVNndmFEM0xSKzNRaFVPekYvdlF0Tzd3Yyt3anZHaWR5?=
 =?utf-8?B?LzU0Q3Z5ZzQ2NDZWU0VFMkR2U0lvbU4wYk1odXBiUkxnS3Z0ZTNZWW5WalZv?=
 =?utf-8?B?ZnJBWVF1YWNvNDRGUG1IdzVuTWhSUEdWNzdVQ3BlelRaeXZqbnNjbjRtZ2o5?=
 =?utf-8?B?YWRESjBuM05nZVVUTW1CVml3YjlGdFNpTFBORXo3Q1ozaEdNanFlcTQ4MHAw?=
 =?utf-8?B?TURZNE9rZUJRMkRqNWp3WG1hRDB4MVkrcGlITS9seHdzWk1MaXdLUjNEQ2F5?=
 =?utf-8?B?OGdTOXdHMlo3cDlKSEkxUnZiVWdWNk51OUhydzBja3ROaElwNzFjaVU0c1Bt?=
 =?utf-8?Q?9xCQcCrV6e+24qbIZy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e8c41e-0a36-4bc1-67dd-08de732be2b5
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 22:35:46.0065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BfW1sajylEW/82aXvstNGuppd4HLnruQnqz37HqLyjcFqE98PQ5gvdtcvznWgQps
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71539-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8A78017E6BD
X-Rspamd-Action: no action

Hi Reinette,

On 2/23/2026 11:12 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 2/20/26 2:44 PM, Moger, Babu wrote:
>> On 2/19/2026 8:53 PM, Reinette Chatre wrote:
> 
>>> Summary of considerations surrounding CLOSID/RMID (PARTID/PMG) assignment for kernel work
>>> =========================================================================================
>>>
>>> - PLZA currently only supports global assignment (only PLZA_EN of
>>>     MSR_IA32_PQR_PLZA_ASSOC may differ on logical processors). Even so, current
>>>     speculation is that RMID_EN=0 implies that user space RMID is used to monitor
>>>     kernel work that could appear to user as "kernel mode" supporting multiple RMIDs.
>>>     https://lore.kernel.org/lkml/abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com/
>>
>> Yes. RMID_EN=0 means dont use separate RMID for plza.
> 
> Thank you very much for confirming.
> 
> ...
> 
>>> How can resctrl support the requirements?
>>> =========================================
>>>
>>> New global resctrl fs files
>>> ===========================
>>> info/kernel_mode (always visible)
>>> info/kernel_mode_assignment (visibility and content depends on active setting in info/kernel_mode)
>>
>> Probably good idea to drop "assign" for this work. We already have mbm_assign mode and related work.
> 
> hmmm ... I think "assign" is generic enough of a word that
> it cannot be claimed by a single feature.
> 
> 
>> info/kernel_mode_assoc or info/kernel_mode_association? Or We can wait later to rename appropriately.
> 
> yes, naming can be settled later.


Sure.

> 
>>
>>>
>>> info/kernel_mode
>>> ================
>>> - Displays the currently active as well as possible features available to user
>>>     space.
>>> - Single place where user can query "kernel mode" behavior and capabilities of the
>>>     system.
>>> - Some possible values:
>>>     - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
>>>        When active, kernel and user space use the same CLOSID/RMID. The current status
>>>        quo for x86.
>>>     - global_assign_ctrl_inherit_mon
>>>        When active, CLOSID/control group can be assigned for *all* (hence, "global")
>>>        kernel work while all kernel work uses same RMID as user space.
>>>        Can only be supported on architecture where CLOSID and RMID are independent.
>>>        An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
>>>        context switch if the RMID is independent and the context switches cost is
>>>        considered "reasonable".
>>>        This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>        for PLZA.
>>>     - global_assign_ctrl_assign_mon
>>>        When active the same resource group (CLOSID and RMID) can be assigned to
>>>        *all* kernel work. This could be any group, including the default group.
>>>        There may not be a use case for this but it could be useful as an intemediate
>>>        step of the mode that follow (more later).
>>>     - per_group_assign_ctrl_assign_mon
>>>        When active every resource group can be associated with another (or the same)
>>>        resource group. This association maps the resource group for user space work
>>>        to resource group for kernel work. This is similar to the "kernel_group" idea
>>>        presented in:
>>>        https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>>        This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>        for MPAM.
>>
>> All these new names and related information will go in global structure.
>>
>> Something like this..
>>
>> Struct kern_mode {
>>         enum assoc_mode;
>>         struct rdtgroup *k_rdtgrp;
>>         ...
>> };
>>
>> Not sure what other information will be required here. Will know once I stared working on it.
>>
>> This structure will be updated based on user echo's in "kernel_mode" and "kernel_mode_assignment".
> 
> This looks to be a good start. I think keeping the rdtgroup association is good since
> it helps to easily display the name to user space while also providing access to the CLOSID
> and RMID that is assigned to the tasks.
> By placing them in their own structure instead of just globals it does make it easier to
> build on when some modes have different requirements wrt rdtgroup management.

I am not clear on this comment. Can you please elaborate little bit?

Thanks
Babu


> You may encounter that certain arrangements work better to support interactions with the
> task structure that are not clear at this time.
> 
> 
>>
>>
>>> - Additional values can be added as new requirements arise, for example "per_task"
>>>     assignment. Connecting visibility of info/kernel_mode_assignment to mode in
>>>     info/kernel_mode enables resctrl to later support additional modes that may require
>>>     different configuration files, potentially per-resource group like the "tasks_kernel"
>>>     (or perhaps rather "kernel_mode_tasks" to have consistent prefix for this feature)
>>>     and "cpus_kernel" ("kernel_mode_cpus"?) discussed in these threads.
>>
>> So, per resource group file "kernel_mode_tasks" and "kernel_mode_cpus" are not required right now. Correct?
> 
> Correct. The way I see it the baseline implementation to support PLZA should be
> straightforward. We'll probably spend a bit extra time on the supporting documentation
> to pave the way for possible additions.
> 
>>>     User can view active and supported modes:
>>>
>>>      # cat info/kernel_mode
>>>      [inherit_ctrl_and_mon]
>>>      global_assign_ctrl_inherit_mon
>>>      global_assign_ctrl_assign_mon
>>>
>>> User can switch modes:
>>>      # echo global_assign_ctrl_inherit_mon > kernel_mode
>>>      # cat kernel_mode
>>>      inherit_ctrl_and_mon
>>>      [global_assign_ctrl_inherit_mon]
>>>      global_assign_ctrl_assign_mon
>>>
>>>
>>> info/kernel_mode_assignment
>>> ===========================
>>> - Visibility depends on active mode in info/kernel_mode.
>>> - Content depends on active mode in info/kernel_mode
>>> - Syntax to identify resource groups can use the syntax created as part of earlier ABMC work
>>>     that supports default group https://lore.kernel.org/lkml/cover.1737577229.git.babu.moger@amd.com/
>>> - Default CTRL_MON group and if relevant, the default MON group, can be the default
>>>     assignment when user just changes the kernel_mode without setting the assignment.
>>>
>>> info/kernel_mode_assignment when mode is global_assign_ctrl_inherit_mon
>>> -----------------------------------------------------------------------
>>> - info/kernel_mode_assignment contains single value that is the name of the control group
>>>     used for all kernel work.
>>> - CLOSID/PARTID used for kernel work is determined from the control group assigned
>>> - default value is default CTRL_MON group
>>> - no monitor group assignment, kernel work inherits user space RMID
>>> - syntax is
>>>       <CTRL_MON group> with "/" meaning default.
>>>
>>> info/kernel_mode_assignment when mode is global_assign_ctrl_assign_mon
>>> -----------------------------------------------------------------------
>>> - info/kernel_mode_assignment contains single value that is the name of the resource group
>>>     used for all kernel work.
>>> - Combined CLOSID/RMID or combined PARTID/PMG is set globally to be associated with all
>>>     kernel work.
>>> - default value is default CTRL_MON group
>>> - syntax is
>>>       <CTRL_MON group>/MON group>/ with "//" meaning default control and default monitoring group.
>>>
>>> info/kernel_mode_assignment when mode is per_group_assign_ctrl_assign_mon
>>> -------------------------------------------------------------------------
>>> - this presents the information proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>>     within a single file for convenience and potential optimization when user space needs to make changes.
>>>     Interface proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/ is also an option
>>>     and as an alternative a per-resource group "kernel_group" can be made visible when user space enables
>>>     this mode.
>>> - info/kernel_mode_assignment contains a mapping of every resource group to another resource group:
>>>     <resource group for user space work>:<resource group for kernel work>
>>> - all resource groups must be present in first field of this file
>>> - Even though this is a "per group" setting expectation is that this will set the
>>>     kernel work CLOSID/RMID for every task. This implies that writing to this file would need
>>>     to access the tasklist_lock that, when taking for too long, may impact other parts of system.
>>>     See https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/
>>
>> This mode is currently not supported in AMD PLZA implementation. But we have to keep the options open for future enhancement for MPAM. I am still learning on MPM requirement.
>>
>>>
>>> Scenarios supported
>>> ===================
>>>
>>> Default
>>> -------
>>> For x86 I understand kernel work and user work to be done with same CLOSID/RMID which
>>> implies that info/kernel_mode can always be visible and at least display:
>>>      # cat info/kernel_mode
>>>      [inherit_ctrl_and_mon]
>>>
>>> info/kernel_mode_assignment is not visible in this mode.
>>>
>>> I understand MPAM may have different defaults here so would like to understand better.
>>>
>>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (PLZA)
>>> ----------------------------------------------------------------------------------------------
>>> Possible scenario with PLZA, not MPAM (see later):
>>> 1. Create group(s) to manage allocations associated with user space work
>>>      and assign tasks/CPUs to these groups.
>>> 2. Create group to manage allocations associated with all kernel work.
>>>      - For example,
>>>      # mkdir /sys/fs/resctrl/unthrottled
>>>      - No constraints from resctrl fs on interactions with files in this group. From resctrl
>>>        fs perspective it is not "dedicated" to kernel work but just another resource group.
>>
>> That is correct. We dont need to handle the group special for kernel_mode while creating the group. However, there will some handling required when kernel_mode group is deleted. We need to move the tasks/cpus back to default group and update the global kernel_mode structure.
> 
> Good point, yes.
> 
> 
> ...
> 
>>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
>>> ----------------------------------------------------------------------------------------------
>>> 1. User space creates resource and monitoring groups for user tasks:
>>>        /sys/fs/resctrl <= User space default allocations
>>>      /sys/fs/resctrl/g1 <= User space allocations g1
>>>      /sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
>>>      /sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
>>>      /sys/fs/resctrl/g2 <= User space allocations g2
>>>      /sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
>>>      /sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
>>>
>>> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
>>>      /sys/fs/resctrl/kernel <= Kernel space allocations
>>>      /sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
>>>      /sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
>>> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
>>>      # echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>>>      - info/kernel_mode_assignment becomes visible and contains
>>>      # cat info/kernel_mode_assignment
>>>      //://
>>>      g1//://
>>>      g1/g1m1/://
>>>      g1/g1m2/://
>>>      g2//://
>>>      g2/g2m1/://
>>>      g2/g2m2/://
>>>      - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>>>        similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>>>        avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>>>        user space to likely change it.
>>> 4. Set groups to be used for kernel work:
>>>      # echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
>>>
>>
>> Currently, this is not supported in AMD's PLZA implimentation. But we need to keep this option open for MPAM.
> 
> Right. I expect PLZA to at least support "global_assign_ctrl_inherit_mon" mode
> since that is the one we know somebody is waiting for. I am not actually sure about
> "global_assign_ctrl_assign_mon" for PLZA. It is the variant intended to be implemented
> by this RFC submission and does not seem difficult to implement but I have not really heard
> any requests around it. Please do correct me if I missed anything here.
> 
>>
>>> The interfaces proposed aim to maintain compatibility with existing user space tools while
>>> adding support for all requirements expressed thus far in an efficient way. For an existing
>>> user space tool there is no change in meaning of any existing file and no existing known
>>> resource group files are made to disappear. There is a global configuration that lets user space
>>> manage allocations without needing to check and configure each control group, even per-resource
>>> group allocations can be managed from user space with a single read/write to support
>>> making changes in most efficient way.
>>>
>>> What do you think?
>>>
>>
>> I will start planning this work. Feel free to add more details.
>> I Will have more questions as I start working on it.
>>
>> I will separate GMBA work from this work.
>>
>> Will send both series separately.
>>
>> Thanks for details and summary.
>>
> 
> Thank you very much.
> 
> Reinette
> 
> 


