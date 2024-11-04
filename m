Return-Path: <kvm+bounces-30563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A74AE9BBBCF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 18:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 088F7B22E26
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 17:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA97B1C8787;
	Mon,  4 Nov 2024 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ctyoHBam"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354FC1C8781;
	Mon,  4 Nov 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740941; cv=fail; b=a6ZvV7uHVhOcArz43U9s1nLCHzX4qv6ObimXJSZy2YICyWvkiSzV7ZujmERh9wa9+sQXuCONn7HvRB5MgYtjSRQ93muaoVA6GNofFTGjnE8bJ7c/XItJdcIJAtYazRRda5VQMpcWMKFpmrNMI5YdVwxRHhfPR0yWU7P9iWnTw9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740941; c=relaxed/simple;
	bh=OcLjRcUdc95rMllpNyASu28MXeyYEMIb+LM0nLK3vuU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RX1vqPafvDduuu0XeSHO8PuRjPQ580ZYixlN36g3PHvK9LFBUw9axXXWiU3eRPLfq5Ae9+mSIKtYa1kdMtwLnm+YlRBwOsSAPTjrmAijF/DGuGp1LR1rTyqw14v9jUSFFZ2uQxVDMIsz4zQNnSBxm75Zdm3lozBtshXqVf93LUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ctyoHBam; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULcapQVVLv7q78FSZjddI/he06ifsR+z6tZA+C+rQC8CUVdcX7LmTkqsAGtWlnCETkU3z6xIxRRybezRI0x5+P6w0uDmW1t8v8DtfhI/V8oRkBK8QNNrcyGmP0STc8BcNn48SlQ5NabvDFShu5G66GCaneUcy5KEVc3ahVFwxS5dc/o47/l8ibIqG5BxY2e5QbPdLDJFruUKvSYImf4TbAv0oV0peEUdaagIqtroZZT0GMajAYyMOiWHFZOdYoQ4CCUYtuvaHjIZ67U89pqrsrRFek0HVT8PaPOrHeomL6HlJcMEQdtsfdAo00Ia1Yen0ss+xGYjH4LGFPGXeRrhCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcLjRcUdc95rMllpNyASu28MXeyYEMIb+LM0nLK3vuU=;
 b=b4mcdTgfp3D/8dhWDHDixaCv1m1/mKkIWqokeqyv4lnL61F9tp0atiFqn650ban5i5eeeGNPVhX4po0dhN8mOSa06xj7UqSTkXcliaEgYw5PbK2SfICWKIiXho2BRZFPdVMzVjcBkp4ozVwo+eSIfkBMBr3MXTaZ6YhRqWm+7JagyiyGwCWVGh0hbmQK8cSduXp+w0CmslLQvJhTrRGawqURACRqVa28MTp0MQ4VXwOKPBtDc0mNyA3Rsms7rnDmGemsQ6+q8/NlJ8C++iV29JFdZbC/p7Hae1bX9HqXOeE1btMJR/9MFmF1YxJBRWp1dIOd44NIu2ZanfeR4eQdkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcLjRcUdc95rMllpNyASu28MXeyYEMIb+LM0nLK3vuU=;
 b=ctyoHBamc7ghwGhTmBZXMj5x/ykO6WI0nZqnhBQlqICjidtvLwWqHUnI2s6RnPte36J4+8EKK1wMZPVRmFIvmDgUeLQthswnSUrINT7eyYouM5X/+KN5BPZdBcv3qQppv5ZjtAZuvIUmxw+lyJ1WxLg18dM4h4RKYe5gY3kH+1o=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by DM4PR12MB5938.namprd12.prod.outlook.com (2603:10b6:8:69::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.30; Mon, 4 Nov 2024 17:22:12 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 17:22:12 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@intel.com"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Topic: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Index:
 AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhfTCAgAVa8wCAAHjUAIAAAJqAgAADwgCAAA9+gA==
Date: Mon, 4 Nov 2024 17:22:12 +0000
Message-ID: <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
	 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
	 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
	 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
	 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
In-Reply-To: <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|DM4PR12MB5938:EE_
x-ms-office365-filtering-correlation-id: fdef7393-3cb5-4f6d-ea34-08dcfcf538b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SHlwdGRqL2pkNFozdDZyeFM1QXZBWGRmK05XcVRST0tMVjdLdWdOemxJUzJV?=
 =?utf-8?B?RUdhb1FSNm54ZWpvVEg0elhGd3p0djJ3bWRJaVdtVjBKNW5UKy8zWHIyZjND?=
 =?utf-8?B?L1Voa0tHZ2pzemhyL1FwUGxybHB3RXVGemNKZldhTlAzNDErN3paanQ3SmNt?=
 =?utf-8?B?SXBFTmJKWlNFYjFqMHJrWWdtSTF4R1VJSlpPdk9LczIyNjFrU1NVSmdMcTYy?=
 =?utf-8?B?WTlqOExFM0c2UldJcElaR1ZmcUVSM0lEbnh6WE5pOGJVN1p6cWVWYmNhYUgz?=
 =?utf-8?B?dzRHbmRlRFpaZzc3cmZpcVBPcVRaa0V2TTR0NmxURTNiUkxiQ3QyV1daVnNl?=
 =?utf-8?B?K1dFQXhSbnZzZlBsSWlEZWZsd0MzOGZHNFBEa2RpekFpUEl3WFZqMDd3Q1B2?=
 =?utf-8?B?RkphM1VnV09yaVQ2dEREMjI1Yzd1UUIveWYzUXF5eDRJaXRKdGlQbWU1M3Bi?=
 =?utf-8?B?VG5TSWNBUGxSdmJYTXcvdFIrdkt1Y2Q5NzNwb0dGVmVQK2R1UXF2R0toY01j?=
 =?utf-8?B?TXhZV2VHd2dVRmJ2bGVWa1Z4dUFZQjVVaFZtRmZBcTRSaSswWGZQUlpMMEY0?=
 =?utf-8?B?R0FTenVwZkFCcUFzdHFIeDZ5Z0ZCVFdXb0hvUXlhWk5mTDgzcXRwREF2a1lh?=
 =?utf-8?B?cFBBaVl0N0tyQTkwR1lPL25EWFl0NVliN1c0dXBMZEUrZHhxRHZRRVlzNTBv?=
 =?utf-8?B?TzdkaUlaK1had3J2QmZDZ2krVXE3SXhqUGVqOWt6ckt6MFhXVzNuVkx0OVB0?=
 =?utf-8?B?NUU5Q291TXh3OHR3QWhYQ25zYVJyRTk4ZkFYbkl1M2NZNGlFUFZIVi9ScHB6?=
 =?utf-8?B?d09WMXRZemd5Y1ZSUWdKcFhvRFoxSElZWnBzbzk2RnhZTk9jYTJXTlp3NnhX?=
 =?utf-8?B?cmZyNi9QVEMxOEYyRnUwRFBVWG5qWmdGRWs0aWUvMDJacUZlNFgrOXpZQUox?=
 =?utf-8?B?cEN3ZWJtaVBMcEtkSnh4RWNxclhyZnF6ZUxaSHJWVDRVb3BITTNhOHNqVFMy?=
 =?utf-8?B?TjFGREF4TVBHL3BxYlNvMVdxeTk0enZkOFFkU1E5QWd6Ym9FVzJaQXY0aTBs?=
 =?utf-8?B?NkY3S0VJRmdFczV1dkZiZ2YxZnNXS2lsajd2c2tRQVI2VVFXZ09wZXFlbjRR?=
 =?utf-8?B?U1hhQVBSY0ZZeTFnWkFrWnBUVFJya1czbXczOWZXazl3ZDZ4Ly9YbzRzQlZX?=
 =?utf-8?B?SlY3SXBGZ01vRWRnc0dMdUN0QVczNGVLNFZlS1I0aGVhazY0SzR4eFp4V1hP?=
 =?utf-8?B?Q2M2eklIMEk4bkVHZXVRcVN3aDRLZTk0dVBIK2syY1BpeHpEa00vbDlBQjZI?=
 =?utf-8?B?czNUVlhzNzZsSG9XYUVBN29RbDdKLzcwaTA3blRaN1QrTERCYWxGbGV6R3hx?=
 =?utf-8?B?TFNJYU9wUExTc0prKyswWWxLczZXcXoyT2pTSWZoWmxkTmRoR244ZmdEbXJF?=
 =?utf-8?B?VzVZdHVraVZzYW5CYU5QTGR5VWlUeTJzcTA0Smd3ZEs4Umw3a1FpUTRtcW44?=
 =?utf-8?B?UWRqWlFEY2hrMVMyMGQyd3lWNGU4YS9qVXBaN294czJMbGJuUE5hWm5DVEE0?=
 =?utf-8?B?YUFwbld2T1NZWVR0WXh2eUdpQTNINlQwQzhUOHg0bWc0bThqbTlybklvNzBy?=
 =?utf-8?B?UUdxTyszYm5jb0d1cFZyaFBkWU5iTHZjVWpZRFBNZ3lveWdRZlZMejBXZVV1?=
 =?utf-8?B?NXpXb2pBRDRqbnFUR1prVGZzWi8wQ3N5S2ZhTHRPTGhaSnNqYmxNbmFpSDRz?=
 =?utf-8?B?M2F4YW1RMXJSK3NtSVUrTUtDeHd2RzZsUTlWL3BTbVdDNVQyOXZicHl3MEhi?=
 =?utf-8?Q?zidujId4ogWvMpPKFs8DOsS8kngEegysMkUGk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U3c3aGZoSDNENUkrdEE2cnZRMUlJSUliVzcxVGsxMTJqZkpNemJqN2tUOGlm?=
 =?utf-8?B?U3IyZkNRaE1YdkduNzdaRjJQaWFhb0dGdDNqb2svQ3lVYXVBRUhNUGNFT2xS?=
 =?utf-8?B?L0hneHhBWWsvWm1RL0x1Z0FVZHIvaDZJeTlkcXU5K2N2aVhicjhiR3dTUHB6?=
 =?utf-8?B?OFEzRnRrN0VVZ0FMN3NYdHNKU1RoVGRTdnRDV0x6K1FCUEsvMmVvaDAwVEdQ?=
 =?utf-8?B?M29LVG4zUkN4bUwrTVVsTERyR2pJWjFLbG1WODZnMWhOV3pmK0pmcy8yaXQr?=
 =?utf-8?B?dWE0ZmVCY3QxYUFEYU9Za2hSbXp5MWVHcXBmYngxWkswSjRGK2pTTHplUE53?=
 =?utf-8?B?QnB5RDBVa0pzTnFqNGh0R1RhR3pha1NGUXJjOU9RRVJKWVhPV0Y2cUZXNHVw?=
 =?utf-8?B?L0xGSlRaYUxTeWFQU3BRcStjamxuZ3lhRVY0dW0vcE16Mkg5aHFESGdYQ05V?=
 =?utf-8?B?U0tqTzdmNzdxNDVNL254Z042emx2UmdPZDlMUVNjQmdsUGFRcjdXeXpJbEky?=
 =?utf-8?B?YVJFTWdhWVMxR201a25oWVNDTjVnWEE0akhUbm1hZmxOb2t2dnM3Vm1wUkV6?=
 =?utf-8?B?REJVOVZsNXNDQzFBMTRMMmNzb3ZPMXQrYVlmSDI1M2VWdE5Yak5IdGxSZ0Qx?=
 =?utf-8?B?VittbDl1b1B2d0IrOGg5TGhzWnBtdXA4TVFXM3lBK245VTk1Wm1PUk9Zckxx?=
 =?utf-8?B?d0tVZkJ3enNuc0hUMjdHMUJqWERIaytjTllaNmk1aUJwdHJHL3crRHdQb0hB?=
 =?utf-8?B?d29jV2NIOHM1a3B5TDNUR0lZQjI0ZFVGU0VLcVY4ODIvNDM5UUVOVXhBa0pK?=
 =?utf-8?B?UDZLRWh2cUNKL0NTbXY3eXlZWDJjWlJqTWRhODdkeEdHbkZKblIyNEdLaDMr?=
 =?utf-8?B?MjBkVy85SE1iZWtCK2lnYWIyMlNDM05jQ2NtUFRZTU1oOXd1R2tkbytQeGdv?=
 =?utf-8?B?ck5lL0RjSmFXbDFFQmlOd09MRUxwN2pzNnZZcUozaUdueHZhczBVK25yalN0?=
 =?utf-8?B?QmYwejg1UkREYU1saGZhd1hKYWhJSzVNTENpQmF6R1ZVYjJlcUVGajlXekM3?=
 =?utf-8?B?dlF2bFBJZXFpNytEcEQ4Q3dFTGc4RWpJVFJwU0xSaVBQbjZkcSs4OWlBU0dI?=
 =?utf-8?B?YXFVS2pad3JSdzNrTGt6aHdmS1hJL21HWVBzaXkvVytYSllsY1FUb2ttRW5M?=
 =?utf-8?B?ZENoaWk5emp3dk43UmprOGMwYnFyWEJONENwd0grMHBBUkRoNmZlcTM5bTQz?=
 =?utf-8?B?alg3TEE2b2ZORUVuQlQrZ2dmbG9OUzV5ejFLM1dyZkkveWVZUHI3Y2dSQTd0?=
 =?utf-8?B?cTNlTjB3V0pIMGhKb3FEbWQrUlNHdDd5SEdiTUh1UkpjTVRybmNYbHYwbmEv?=
 =?utf-8?B?QVZRKzNSTVNBSHJuRmlOWC96cHhTMnpuMWF3WFgzZitSem9aMzRZcGtyT0Ry?=
 =?utf-8?B?Rm5TU3ZMQU9vcU5seG4rQlcwU21JQ3BPTDRWdUl2QU9MejduWFBTUmliMVFp?=
 =?utf-8?B?MjA4a3h3ZVd0WmdodjUrVEFnMGoxaGRnK3NyWEVzS2gyR3JCQ1Y2ZzNCMGJR?=
 =?utf-8?B?ekh5cHl6RnpRZHM3V1M5OWFhdk41UDRHbVdSZk5Qd1cxRkZBS0RmTDZyZDIr?=
 =?utf-8?B?amdrTUhvdTZDMDRjSUlzVmdRbjZaaWVKU3BSeU5KVnRIUTQ0OVlISEtsY3dZ?=
 =?utf-8?B?K096cTN2d1pza0FJdnBSZmkrSi9pWVN1UEZmckNhc3BiaGJhRHYwVC9tRmo2?=
 =?utf-8?B?cW1wZ0RYNENqMENKNzkzNk10NVZkZmJnSTFnbWFLVUIwYVRFQmR5RHNJckpN?=
 =?utf-8?B?Um13NTVrUkF5azlXcWdWR2x5ZVl0U0tHNTlnWk52eUxTRjc4Yng5YVBCY2tl?=
 =?utf-8?B?bHgveXpLQTVOV0luYXl3QTlsMFZ2aVJURWMzVzNpVGk4VUlPU3dDK0kwbzJ5?=
 =?utf-8?B?dm01KzdQYzJValhxSzM4bEt0cmNUWVBNM1VmMG1WbGVrZGpPcHdiT1pGSnQr?=
 =?utf-8?B?TFZEM2EraE5aWUo0amR5NDV2ODkyMzhRVlpxL2RJV3k5TEZDUlhMZG4vQ2FC?=
 =?utf-8?B?aWk5aFo1eGJtS3NEUkNib20vS0Zad2hrRXoxWWVtQU1YdjZ0Z1JxYmdBNHg0?=
 =?utf-8?Q?kvzYASF8ezjM0wCMgp66y0jDf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7887B7C0EC2D9F44B66276B4EC0787FB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdef7393-3cb5-4f6d-ea34-08dcfcf538b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 17:22:12.7832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qu42EAJ5TZeE5l0Ky86k/lWIDpm7esMtCCk6CFpbS9luRGt3wCSDy5lnjyiyhkKm7lng90zkzT0LB9leuZ55Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5938

T24gTW9uLCAyMDI0LTExLTA0IGF0IDA4OjI2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvNC8yNCAwODoxMywgU2hhaCwgQW1pdCB3cm90ZToNCj4gPiBJIHdhbnQgdG8ganVzdGlm
eSB0aGF0IG5vdCBzZXR0aW5nIFg4Nl9GRUFUVVJFX1JTQl9DVFhTVyBpcyBzdGlsbA0KPiA+IGRv
aW5nDQo+ID4gdGhlIHJpZ2h0IHRoaW5nLCBhbGJlaXQgaW4gaGFyZHdhcmUuDQo+IA0KPiBMZXQn
cyBiYWNrIHVwIGEgYml0Lg0KPiANCj4gSW4gdGhlIGtlcm5lbCwgd2UgaGF2ZSBzZWN1cml0eSBj
b25jZXJucyBpZiBSU0IgY29udGVudHMgcmVtYWluDQo+IGFjcm9zcw0KPiBjb250ZXh0IHN3aXRj
aGVzLsKgIElmIHByb2Nlc3MgQSdzIFJTQiBlbnRyaWVzIGFyZSBsZWZ0IGFuZCB0aGVuDQo+IHBy
b2Nlc3MNCj4gQiB1c2VzIHRoZW0sIHRoZXJlJ3MgYSBwcm9ibGVtLg0KPiANCj4gVG9kYXksIHdl
IG1pdGlnYXRlIHRoYXQgaXNzdWUgd2l0aCBtYW51YWwga2VybmVsIFJTQiBzdGF0ZSB6YXBwaW5n
IG9uDQo+IGNvbnRleHQgc3dpdGNoZXMgKFg4Nl9GRUFUVVJFX1JTQl9DVFhTVykuDQo+IA0KPiBZ
b3UncmUgc2F5aW5nIHRoYXQgdGhpcyBmYW5jeSBuZXcgRVJBUFMgZmVhdHVyZSBpbmNsdWRlcyBh
IG5ldw0KPiBtZWNoYW5pc20NCj4gdG8gemFwIFJTQiBzdGF0ZS7CoCBCdXQgdGhhdCBvbmx5IHRy
aWdnZXJzICJlYWNoIHRpbWUgYSBUTEIgZmx1c2gNCj4gaGFwcGVucyIuDQo+IA0KPiBTbyB3aGF0
IHlvdSdyZSBzYXlpbmcgYWJvdmUgaXMgdGhhdCB5b3UgYXJlIGNvbmNlcm5lZCBhYm91dCBSU0IN
Cj4gY29udGVudHMNCj4gc3RpY2tpbmcgYXJvdW5kIGFjcm9zcyBjb250ZXh0IHN3aXRjaGVzLsKg
IEJ1dCBpbnN0ZWFkIG9mIHVzaW5nDQo+IFg4Nl9GRUFUVVJFX1JTQl9DVFhTVywgeW91IGJlbGll
dmUgdGhhdCB0aGUgbmV3IFRMQi1mbHVzaC10cmlnZ2VyZWQNCj4gRVJBUFMgZmx1c2ggY2FuIGJl
IHVzZWQgaW5zdGVhZC4NCj4gDQo+IEFyZSB3ZSBhbGwgb24gdGhlIHNhbWUgcGFnZSBzbyBmYXI/
DQoNCkFsbCBnb29kIHNvIGZhci4NCg0KPiBJIHRoaW5rIHlvdSdyZSB3cm9uZy7CoCBXZSBjYW4n
dCBkZXBlbmQgb24gRVJBUFMgZm9yIHRoaXMuwqAgTGludXgNCj4gZG9lc24ndA0KPiBmbHVzaCB0
aGUgVExCIG9uIGNvbnRleHQgc3dpdGNoZXMgd2hlbiBQQ0lEcyBhcmUgaW4gcGxheS7CoCBUaHVz
LA0KPiBFUkFQUw0KPiB3b24ndCBmbHVzaCB0aGUgUlNCIGFuZCB3aWxsIGxlYXZlIGJhZCBzdGF0
ZSBpbiB0aGVyZSBhbmQgd2lsbCBsZWF2ZQ0KPiB0aGUNCj4gc3lzdGVtIHZ1bG5lcmFibGUuDQo+
IA0KPiBPciB3aGF0IGFtIEkgbWlzc2luZz8NCg0KSSBqdXN0IHJlY2VpdmVkIGNvbmZpcm1hdGlv
biBmcm9tIG91ciBoYXJkd2FyZSBlbmdpbmVlcnMgb24gdGhpcyB0b286DQoNCjEuIHRoZSBSU0Ig
aXMgZmx1c2hlZCB3aGVuIENSMyBpcyB1cGRhdGVkDQoyLiB0aGUgUlNCIGlzIGZsdXNoZWQgd2hl
biBJTlZQQ0lEIGlzIGlzc3VlZCAoZXhjZXB0IHR5cGUgMCAtIHNpbmdsZQ0KYWRkcmVzcykuDQoN
CkkgZGlkbid0IG1lbnRpb24gMS4gc28gZmFyLCB3aGljaCBsZWQgdG8geW91ciBxdWVzdGlvbiwg
cmlnaHQ/ICBEb2VzDQp0aGlzIG5vdyBjb3ZlciBhbGwgdGhlIGNhc2VzPw0KDQoJCUFtaXQNCg==

