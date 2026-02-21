Return-Path: <kvm+bounces-71437-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBDBFI74mGlyOgMAu9opvQ
	(envelope-from <kvm+bounces-71437-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:13:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A375E16B864
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63B4F3039CA9
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1A98460;
	Sat, 21 Feb 2026 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YiC2WVDO"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D993FEF;
	Sat, 21 Feb 2026 00:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632771; cv=fail; b=ouYuuCpG7oqelNrsQjASBdtvenlvaEVmrTm4zpLBV+nvT2aPJcxARn6qrJDBoD+Vg63i8jYHFO370nbJGfYxMBCMGPEWFvVsCluBHgxxUtKzxwCuL3fMVKisUK6qty2Rr3ig8xDdmNyiRagj/bjO230uKhrYPI6D6RN7Am9EHKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632771; c=relaxed/simple;
	bh=Zpi9zCvqH5HMT8QBb29AnnG8hOkvdjgAv8ARPe2T69E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r7iBODc3rgsaQdsHvqCC2Jm8jrZ49RIVg8iWTCXrnaNw46muWvmVy3PACBo9d/5dl6oI6OKBA6AwYdyDFNDXCNoK6kS4yHqahpRxDul1VE8epkRlZdgkB/Z5FC/ThSHvjtK12mqRcLGltYObGeZ0dj6PFg/kOvliAgjexcgU2pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YiC2WVDO; arc=fail smtp.client-ip=52.101.85.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4f9IP/7Pkm61E1UOYGJEoSaEEPlmBg9AijSrwT7fyya4QQWFfZ3cMO6uYKRyzKjiwg0azk6NXFBQ2du8iQH6Wh0XW2UeDBVL+ohJcjKQYFZVsjEpiwu3zkfB5NNnbCgZFVA6VI/vZzPsXhnn23XwkYU/A7nG3EWITRg+VfxIYqb5W/iSTL1+48hv1QNP5Ik9j6zwsBFcRnULCKsgo7ive+yjCI25knX9+DgkqPxmSB5w1arb4szcPZaqGCopAdVtgWkGsqanFYvtu2RK7jqNt0aIzEYXRcJ+T1qM+VnE40BDZRXgHzmBJFJ5dt7bCCt8EzSMSPNoZRfRlN1eURJiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb1b4qynbU5R5hgzeVHSnZnU6yrOB06REHIxWOMbHt0=;
 b=Q8u6ehtKBxwPtAio/Nny0pxU2/qk0FQed7+fumZoicEw71gzTGkBBMh2DTmsdoeBdMYxKTM+OC3hJHgjrc9eD6CDPfR9FblQxOoXZn1YtCszCx4UtPO7sGpMJk1zsSy0PVL2CxZBRWiR53qN3vteYKpHyf+KgZQX0UXC8JPkQGQoUOoadwtQStmpysHCpm+lpR+CicHoBFqEk4zyr4PUX/wnk4uWEqHv/TLW4DGM5SiDdUBcG6nQCY4XwE/uHKuMNeF+5X3k1W4W6eqqRbXPbIe15AL+Ww6RvaajHXhoxLVa5uszrEs3yL68j047qRibIDiYnjYLJATCUtIhA94LfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb1b4qynbU5R5hgzeVHSnZnU6yrOB06REHIxWOMbHt0=;
 b=YiC2WVDOUoYnEtva5Er0UUP3CmFsRcAAwxVENaR11EP9w7MH3t0hYFtbdlXPHXuiwXofXFhZZ+/2sjyFWVJGeZvyPnfatDZJbcAsPLLJpZtVBJWL2X7dtUrq6eY+85NzuKdPXTiO7yTOCSs5X74DYc1+FammPOP1otVyJ0Ir6PM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by LV8PR12MB9231.namprd12.prod.outlook.com
 (2603:10b6:408:192::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Sat, 21 Feb
 2026 00:12:43 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Sat, 21 Feb 2026
 00:12:43 +0000
Message-ID: <ad19a2f2-0eca-4581-ae34-94c160d6cf6b@amd.com>
Date: Fri, 20 Feb 2026 18:12:37 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Ben Horgan <ben.horgan@arm.com>,
 Reinette Chatre <reinette.chatre@intel.com>, Babu Moger
 <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
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
 <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0209.namprd03.prod.outlook.com
 (2603:10b6:610:e4::34) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|LV8PR12MB9231:EE_
X-MS-Office365-Filtering-Correlation-Id: 4398d535-6365-4db8-5dfa-08de70ddeee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0NxNTlrV1lhazBtN2ZiR2NsZWdLUFNKZHpYcFkwYTlRVTg1bjZObk05cS8y?=
 =?utf-8?B?cjRYUFF1YnlJQVZCdkdSL2VBMXMxTTI1N3IzL2RaRHFXaEU2MVpxZUh4eXhk?=
 =?utf-8?B?SkJxaXpXRzlnNkRReTFTdEJhdGhBK2l3ZE8yeDIxWWN3dFBmS1RkZC9nSm1q?=
 =?utf-8?B?TDhwV0tPNzhnRm9uK3VKWXVOYzgyanJjdksyd1IxdG10alBDcURMakl4TVUr?=
 =?utf-8?B?ZUdSelRKaWNwSlVSRzExSG5xRXo0MTVOYjhsVWJJanhhZm9UN043Y0F1Sk96?=
 =?utf-8?B?NUkrdEtUOCthdVVVT2tJYkNuSGhWSW1QYnArZ3pyOWg5T2g5Wk5nRkZtc1Rp?=
 =?utf-8?B?eGVqN0FQbXdrd3ZDNG9lNGxhRWJ0dlJwRGtRd2Y2RzFuZlRJekFnQmtSWFRI?=
 =?utf-8?B?WlIxeWZLbFBzYmsrSkhIMG5TR0RhUVlkUlBTM3hoVk8wRi92YkF1ZWJFc1VW?=
 =?utf-8?B?VW5KRjlkOVdCNzU1ZHVrcjY1VVdRK0dPSGZOWEdQcGFEL3MrTkU3WnJoWTlI?=
 =?utf-8?B?a2ZMSlUzaHNyeUo0WmhPeEp2OWtaUEsyRXlBbUZYSElDT0VCOTQ4cVFhMUFO?=
 =?utf-8?B?U2tRM0hQYjBsOWZnN0RjV1dYZ2Q1MDhHOUkydFpEUEc1MWUvaW85NGc0ZEVY?=
 =?utf-8?B?NFZMT0tzODA5dGtFd0RvOG9jRzdjV1pXY0U1N3I1ZGtwcDk5cjF6Ymg2ejlK?=
 =?utf-8?B?QlF2cWdaVVB3OXlOdjJVZXF4RmNDamEzQWJwU1ZCUVo3MjRqVkNXSWVUODI1?=
 =?utf-8?B?d2FwZHNkTENYNy9idTM2WU5jdWtjM2xtQ2VEUnkxWEloQ3FrRDJxbU1lN0NH?=
 =?utf-8?B?RzZNVktFRWV4VFlQL2c1dkh2cXg4RHBPQlp3ZS9iOHpuUEhvdnI0K0hCZzRL?=
 =?utf-8?B?eERZTW1HWlJKVXVTcEo3eDdPa1FaNGZpQS9HY21zeTZVOUlkMWphUVEzVmdO?=
 =?utf-8?B?eHJiZVFCZTBaVG9YblYyUVBzWFNxYjcwc1BKSEpEWHhmbGNnRkU4amNvTXZl?=
 =?utf-8?B?UDlLaHBhNXh6akZUcjJKdm50eXBqT3hJTTM4S29EbE5nQ0svZEFSZzhPVmdJ?=
 =?utf-8?B?QU11Zm1kT3E4WUhWQUlnVFpUMXNaZWd0aXB4M2trdmgvbm9PeEdINFJ1Vm5D?=
 =?utf-8?B?QisrS1h5cWNRc1dwQi9lRnFDMENubzRteDNCemJBdzF1Vm9PT1lZVFhEQ2dU?=
 =?utf-8?B?b1BtaGdtN3RBTktNbU1XUUdkd1VkMlByZVZ6eUxwTURvSm1VZWZpKzhNNnR3?=
 =?utf-8?B?NUEvR0lhd3Voa2FPWXBxZGZxT0lHSVRZK3FHTWZXL3o3SC9nTzcyRCtPcTRj?=
 =?utf-8?B?dEZYUWk2YVQ0Skg3a1dueWF1VEc4VllNYW9yaHhwYmpzcm41YnpPbnhHTDEw?=
 =?utf-8?B?ZWh0VHRsUkx3KzBzcG1Dd1hvYlEzS2g2djFYTkc5K281MEZ6VVdmTjVlS2FU?=
 =?utf-8?B?TEphbGVrK3NhS2tRZ3Z1N1VIZm5FaC9vbndHT1BweWxWdEkrVTlUTlFHcDZq?=
 =?utf-8?B?N1JMWGdrTVo1dk9YZ2VRT05HMi81V1ZCb2lRTWl1K1JGVUh3aTFTYTZObzEz?=
 =?utf-8?B?bWszUjF5cUZXdDdGT215WjVOY1pMOE5aYmRZVkpwSDBtcUVrUTYvV0JRV1V0?=
 =?utf-8?B?eWNOUm03dHM2eUlKa2NRQngralRndmRBUUM3L0c5VHQwaEMvb1BEdkc0c3Ns?=
 =?utf-8?B?N3JjeEtSSTJjclRVdlRXUTVUUjYvdW1EYmFzL2VDVmZTS2FyMEg4UG0yQ0RR?=
 =?utf-8?B?bzNVUkszYnoyR1VJYzFXQm9SQ0ZQSktBUUY5TEsvZ1FXdVlFRWZkbkJXTjFn?=
 =?utf-8?B?WlVuTCtQMC84OUoxcDVwek9rc2k0Z3NxNWpWdzQwOWlBRDlCcnBxL0l2OFI2?=
 =?utf-8?B?S2JGendJRVZXazZrVzE3ZDVJUkxURC83YitLTFhrdUJrNHorYjErT3Vma3hF?=
 =?utf-8?B?Qmdwa05EOGJKdktqNGVwRjgxc0ZsZDllS0RhUlNsZndhNytUNi9ZTmJpWmpY?=
 =?utf-8?B?b0hFcmhTZHJQQ3VaSDQ0dkViUE02UjNOREpsNHd5NFpOKzV2ZDY3TE1iTkZV?=
 =?utf-8?B?cVFNemlMQmRPeURmd2dyNTdTZHRwUDd2ZmZOeW1VL0hPdGNBNFRKanBmc3ZB?=
 =?utf-8?B?N2t5akhSSm1uM20yaE1HamFmelZhN3RGTmpXenAyRGdCVGpQdzIwcjlnd1lw?=
 =?utf-8?Q?T/eGryaQYw0WZuNeZ8JnS80=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3RkUlVBTC9OeVNBWUJVQURZRzZ3TXBvbGNyYnVBNmJyNkpsSzhCaWx3WU5U?=
 =?utf-8?B?bEVNRDBKbzNydXJMenpVeU1Kb2FRMGkvN1E1WWFidU9ieEZyMzhnQW9kc2dk?=
 =?utf-8?B?c0dNbXA4ODJVQkVEcisrNHplK0E4aGI5WXR2R0UwVVVvRGE2WXM4SFR2Z1Bi?=
 =?utf-8?B?S0FSMTFWa3BuSXp1bnZlWGUrUGhCZ2tZVzE1Slc3cGoraWEvaTA5Q2xESldC?=
 =?utf-8?B?c3p5MDV6NE92UzZZTGhrV3VmZ0ZYSGlIZWlhZ21hOWhnRFRveXhsN3dyWTZL?=
 =?utf-8?B?ZlNLeFJpenlKUDJZMDVhM0o5NkVVM3pSTWR1eC9aRmtuREdYcVNnbktmQURt?=
 =?utf-8?B?WjlHeGtVV1BLbkJ3dGMyK0VGTGpuc0VoWUVJVlg1dEVReU96eGtaVmlqNG12?=
 =?utf-8?B?N2dySDRqSERIL3lsY1hUdk9wNHNHeEJPUU95ZlJHL3BibldNK3VFYlFNZVZU?=
 =?utf-8?B?c2pBUjIrbTF6OVdxSWMxR3MrN3o4Qnhvc0lPdkRmUHd4eUVXSFlSVE81Y0Uy?=
 =?utf-8?B?RXFlQ2dwRWFmdmRxZERLNEpBUklFRnFDQnZYYUVmRmk1S2F2WGhrTER4Z0RL?=
 =?utf-8?B?MVQ0MVRjY3RSeklDRno4NCs2TUJVVm5WNkdWM2p5S0JPQWJmT0ljbzBPTEFP?=
 =?utf-8?B?OHhneE11bzhkajFQTDV4cWF6YTRLVExhU0x5RWNKME1sazJwMFBqWE1xOUNt?=
 =?utf-8?B?eC9Lbnp5K2UvcVkyZnM2OHNleDAwczliaTgvWnhRZVBON3I0b3A2d3lPMXlY?=
 =?utf-8?B?MWo1cmdDbk95emZCcVZHck0ySVJFanVvQlhsbDNyVE1tV1ZIQ1B1SG5LQ1d2?=
 =?utf-8?B?dXRob3NOQi9GNHlsM2twaUc2OFlsUW15U2IyV1hqVUpaUDUxZWJUUG1vZVd5?=
 =?utf-8?B?bmhTbllIblBsalZFdGRyb2FJRzlFYk9USkZyZzNTakxtZHYrUEhmTG1XY0xj?=
 =?utf-8?B?dUk3NCtmek9vY0R5bkNvVWpDUE5sN3U4NTQrMk1sNmlFQUpvcmF5RFRKTW10?=
 =?utf-8?B?UnhxQ1FHd3NGWUlXTjM3OXU2dENSa0RpTUxpM0k0aTREZThCdmw5N0lmT3NF?=
 =?utf-8?B?YW5nM2s1NjRPbEpkdEpaTVlCRS96SVBNeCtJeWswa0x4VE1za1Zmc0p0NGRL?=
 =?utf-8?B?endzMDJmakFIOXhaL3hnR3hJTXFObjcweHRTeDJoQ3FYVjdpNURKNkNYcTU0?=
 =?utf-8?B?K0tvSkpPMVlVVHNxYXBSTWdIb0FKZ2VuWjNUSnlDWEZiZVRPNlYrbEF4Q3Q3?=
 =?utf-8?B?eVhtOTdjVDdoNG1yWXV2cWFKYk9Vb0dIT2kvY1F1UkIxd2k0QXBjOUwvM1Jr?=
 =?utf-8?B?REFTVkVVQlRIdXV3NklsTTBuaHp3cTg1VzBLMTd4UlFQYUlIL3VmQUMrVEh3?=
 =?utf-8?B?bEVoanRSY0F2Q0o0V3JZa0hxODFYZElvY3dTSEwxNElxeWh6T1VuRzFMU0hT?=
 =?utf-8?B?b2QzUDYzd1VNelFrTGd5WnhHS0s4NDdvd25iNHlZZ3pRQ3JRRTZtallSRVFP?=
 =?utf-8?B?ZFFqYzlBSkdZcktxOHBTbHYwMzlUaTBJZkJ6d3ZNeHlmek9vOHFINFNiTUxv?=
 =?utf-8?B?KzFCV2lNd0toekNadllTTzlpVWtyNEV0UUF5bmdrM3NYS1hFNmYrZ2FDK01V?=
 =?utf-8?B?UW9oaGRTbjM1Mk9MQWFkU25FVXZIRE1qK05NVTVHdWZHc0JmbkZ3NWJjc1Q1?=
 =?utf-8?B?Mk5ycmFqZUJUOGVqbFZkeVlxMHUxMTNsNCt3YVF6WXpyVmpybFlQZy8zOEhG?=
 =?utf-8?B?Vi8veC82OEduaTRIeHlYbFN4a2pQTkpacFBsSU5mcDR6RlIzZDRtcm5kZ1Nt?=
 =?utf-8?B?eVhVajhyMlRHamxsOUdwaEhibkl4a2JDODFscm05ZFRFQVpXeXdFVXY1a3Jz?=
 =?utf-8?B?MnNMbGdMYklkMHB4TkMvdlgvc1FSSU05VUtrUzFhb1M1ZVNxQW03VktxWUcr?=
 =?utf-8?B?MVNMNSt6YXdPYklLczM4ekF5TUYvY0tyUFQrRDEzbDF1NTBPWTZXL1FLa3pU?=
 =?utf-8?B?Q1oxR1BjcXM4UHVrQ1p6cWhoRkZnSXpxUGQvRzFkQklla2x4VG5GOWlRQlEx?=
 =?utf-8?B?cmtDMUt6NU1NQVVvcW41M1JFUGo4NHU2MWg2Ukp5cjlxUTFrUzR4Q1lWbEVM?=
 =?utf-8?B?REwrTEwraFRGYWh2bWdZVFo4SUdTelFyUEhMRXdiK0RRTDk0ejVkR0MzM0lP?=
 =?utf-8?B?dTlkSlMwODVZYjNGb25YYnZDRlRPWmhLTWJ5SzlnZW9uSVptTFRsWWdJVlNq?=
 =?utf-8?B?RExwcXdyK21kVE40TC9BYXVnZkZyWU5pM09aUDZGb0ZhY1dTNm9hVmxySmQ2?=
 =?utf-8?Q?TH/itEFa0dEbKo7G8V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4398d535-6365-4db8-5dfa-08de70ddeee4
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2026 00:12:43.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRN2t+d95QVLiSd+dS9enKMpMMsp7PQGo+mE4ZMVFsRP07RIUDZzfhwkOFGQxZjm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9231
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71437-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A375E16B864
X-Rspamd-Action: no action

Hi Ben,

On 2/20/2026 4:07 AM, Ben Horgan wrote:
> Hi Reinette, Babu,
> 
> On 2/12/26 03:51, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>>>>>> limit for each QOS domain. However, multiple QOS domains share system
>>>>>>> memory bandwidth as a resource. In order to ensure that system memory
>>>>>>> bandwidth is not over-utilized, user must statically partition the
>>>>>>> available system bandwidth between the active QOS domains. This typically
>>>>>> How do you define "active" QoS Domain?
>>>>> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.
>>>> To confirm, is this then specific to assigning CPUs to resource groups via
>>>> the cpus/cpus_list files? This refers to how a user needs to partition
>>>> available bandwidth so I am still trying to understand the message here since
>>>> users still need to do this even when CPUs are not assigned to resource
>>>> groups.
>>>>
>>> It is not specific to CPU assignment. It applies to task assignment also.
>>>   
>>> For example:  We have 4 domains;
>>>
>>> # cat schemata
>>>    MB:0=8192;1=8192;2=8192;3=8192
>>>
>>> If this group has the CPUs assigned to only first two domains. Then the group has only two active domains. Then we will only update the first two domains. The MB values in other domains does not matter.
>>
>> I see, thank you. As I understand an "active QoS domain" is something only user
>> space can designate. It may be possible for resctrl to get a sense of which QoS domains
>> are "active" when only CPUs are assigned to a resource group but when it comes to task
>> assignment it is user space that controls where tasks belonging to a group can be
>> scheduled and thus which QoS domains are "active" or not.
>>
>>>
>>> #echo "MB:0=8;1=8" > schemata
>>>
>>> # cat schemata
>>>    MB:0=8;1=8;2=8192;3=8192
>>>
>>> The combined bandwidth can go up to 16(8+8) units. Each unit is 1/8 GB.
>>>
>>> With GMBA, we can set the combined limit higher level and total bandwidth will not exceed GMBA limit.
>>
>> Thank you for the confirmation.
>>
>>>
>>>>>>> results in system memory being under-utilized since not all QOS domains are
>>>>>>> using their full bandwidth Allocation.
>>>>>>>
>>>>>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>>>>>> for software to specify bandwidth limits for groups of threads that span
>>>>>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>>>>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>>>>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>>>>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>>>>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>>>>>> system has two domains (A and B) that user space separately sets MBA
>>>>>> allocations for while also placing both domains within a "GLBE control domain"
>>>>>> with a different allocation, does the individual MBA allocations still matter?
>>>>> Yes. Both ceilings are enforced at their respective levels.
>>>>> The MBA ceiling is applied at the QoS domain level.
>>>>> The GLBE ceiling is applied at the GLBE control  domain level.
>>>>> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.
>>>> It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
>>>> the limits but in examples in this series they have different limits. For example,
>>>> in the documentation patch [1] there is this:
>>>>
>>>>    # cat schemata
>>>>       GMB:0=2048;1=2048;2=2048;3=2048
>>>>       MB:0=4096;1=4096;2=4096;3=4096
>>>>       L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>>
>>>> followed up with what it will look like in new generation [2]:
>>>>
>>>>      GMB:0=4096;1=4096;2=4096;3=4096
>>>>       MB:0=8192;1=8192;2=8192;3=8192
>>>>        L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>>
>>>> In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
>>>> above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
>>>> the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
>>>> MB ceiling can never be higher than GMB ceiling as shown in the examples?
>>>
>>> That is correct.  There is one more information here.   The MB unit is in 1/8 GB and GMB unit is 1GB.  I have added that in documentation in patch 4.
>>
>> ah - right. I did not take the different units into account.
>>
>>>
>>> The GMB limit defaults to max value 4096 (bit 12 set) when the new group is created.  Meaning GMB limit does not apply by default.
>>>
>>> When setting the limits, it should be set to same value in all the domains in GMB control domain.  Having different value in each domain results in unexpected behavior.
>>>
>>>>
>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>
>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>
>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>> same:
>>>>
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>>
>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>> MB limit:
>>>>        # echo "GMB:0=8;2=8" > schemata
>>>>     # cat schemata
>>>>     GMB:0=8;1=2048;2=8;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>
>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>
>> Thank you for confirming.
>>
>>>
>>>
>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>
>>>>     # echo "GMB:0=2048;2=2048" > schemata
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>>
>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>>     # echo "GMB:0=8;2=8" > schemata
>>>>     # cat schemata
>>>>     GMB:0=8;1=2048;2=8;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>>     # echo "GMB:0=2048;2=2048" > schemata
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>> What would be most intuitive way for user to interact with the interfaces?
>>>
>>> I see that you are trying to display the effective behaviors above.
>>
>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>> what would be a reasonable expectation from resctrl be during these interactions.
>>
>>>
>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>
>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>> settings may cause confusion?
>>
>>>
>>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
>>
>> Yes, this will require resctrl to maintain more state.
>>
>> Documenting behavior is an option but I think we should first consider if there are things
>> resctrl can do to make the interface intuitive to use.
>>
>>>>>>>   From the description it sounds as though there is a new "memory bandwidth
>>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>>
>>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>>> I hope this clarifies your question.
>>>> No. When enumerating the features the number of CLOSID supported by each is
>>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>>> No. There is not such scenario.
>>>>
>>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>>> scenarios where some resource groups can support global AND per-domain limits while other
>>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>>
>>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
>>
>> It is not a concern to have different CLOSIDs between resources that are actually different,
>> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
>> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
>> challenge though. Would it be possible to have a snippet in the spec that explicitly states
>> that MB and GMB will always enumerate with the same number of CLOSIDs?
>>
>> Please see below where I will try to support this request more clearly and you can decide if
>> it is reasonable.
>>    
>>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>>> the various schemata associated with that resource. This currently has a
>>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>>> may be something that we can reconsider?
>>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>>> The new approach is not final so please provide feedback to help improve it so
>>>> that the features you are enabling can be supported well.
>>>
>>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
>>
>> It benefits all architectures.
>>
>> There are two parts to the current proposals.
>>
>> Part 1: Generic schema description
>> I believe there is consensus on this approach. This is actually something that is long
>> overdue and something like this would have been a great to have with the initial AMD
>> enabling. With the generic schema description forming part of resctrl the user can learn
>> from resctrl how to interact with the schemata file instead of relying on external information
>> and documentation.
>>
>> For example, on an Intel system that uses percentage based proportional allocation for memory
>> bandwidth the new resctrl files will display:
>> info/MB/resource_schemata/MB/type:scalar linear
>> info/MB/resource_schemata/MB/unit:all
>> info/MB/resource_schemata/MB/scale:1
>> info/MB/resource_schemata/MB/resolution:100
>> info/MB/resource_schemata/MB/tolerance:0
>> info/MB/resource_schemata/MB/max:100
>> info/MB/resource_schemata/MB/min:10
>>
>>
>> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
>> info/MB/resource_schemata/MB/type:scalar linear
>> info/MB/resource_schemata/MB/unit:GBps
>> info/MB/resource_schemata/MB/scale:1
>> info/MB/resource_schemata/MB/resolution:8
>> info/MB/resource_schemata/MB/tolerance:0
>> info/MB/resource_schemata/MB/max:2048
>> info/MB/resource_schemata/MB/min:1
>>
>> Having such interface will be helpful today. Users do not need to first figure out
>> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
>> before interacting with resctrl. resctrl will be the generic interface it intends to be.
>>
>> Part 2: Supporting multiple controls for a single resource
>> This is a new feature on which there also appears to be consensus that is needed by MPAM and
>> Intel RDT where it is possible to use different controls for the same resource. For example,
>> there can be a minimum and maximum control associated with the memory bandwidth resource.
>>
>> For example,
>> info/
>>   └─ MB/
>>       └─ resource_schemata/
>>           ├─ MB/
>>           ├─ MB_MIN/
>>           ├─ MB_MAX/
>>           ┆
>>
>>
>> Here is where the big question comes in for GLBE - is this actually a new resource
>> for which resctrl needs to add interfaces to manage its allocation, or is it instead
>> an additional control associated with the existing memory bandwith resource?
>>
>> For me things are actually pointing to GLBE not being a new resource but instead being
>> a new control for the existing memory bandwidth resource.
>>
>> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
>> done in this series but when considering it as an actual unique resource does not seem
>> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
>> to find all the resources that it can allocate in info/ - I do not think it is correct
>> to have two separate directories/resources for memory bandwidth here.
>>
>> What if, instead, it looks something like:
>>
>> info/
>> └── MB/
>>      └── resource_schemata/
>>          ├── GMB/
>>          │   ├── max:4096
>>          │   ├── min:1
>>          │   ├── resolution:1
>>          │   ├── scale:1
>>          │   ├── tolerance:0
>>          │   ├── type:scalar linear
>>          │   └── unit:GBps
>>          └── MB/
>>              ├── max:8192
>>              ├── min:1
>>              ├── resolution:8
>>              ├── scale:1
>>              ├── tolerance:0
>>              ├── type:scalar linear
>>              └── unit:GBps
>>
>> With an interface like above GMB is just another control/schema used to allocate the
>> existing memory bandwidth resource. With the planned files it is possible to express the
>> different maximums and units used by the MB and GMB schema. Users no longer need to
>> dig for the unit information in the docs, it is available in the interface.
>>
>> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
>> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
>> of this from AMD architecture then we can do something like this in resctrl.
> 
> I haven't fully understood what GLBE is but in MPAM we have an optional
> feature in MSC (MPAM devices) called partid narrowing. For some MSC
> there are limited controls and the incoming partid is mapped to an
> effective partid using a mapping. This mapping is software controllable.
> Dave (with Shaopeng and Zeng) has a proposal to use this to use partid
> bits as pmg bits, [1]. This usage would have to be opt-in as it changes
> the number of closid/rmid that MPAM presents to resctrl. If however, the
> user doesn't use that scheme then the controls could be presented as
> controls for groups of closid in resctrl. Is this similar/usable with
> the same interface as GLBE or have I misunderstood?

GLBE is only specific to AMD to address the limitation with memory 
bandwidth (MB) allocation.

I didn't see any similarities with these features.


thanks
Babu
> 
> [1]
> https://lore.kernel.org/linux-arm-kernel/20241212154000.330467-1-Dave.Martin@arm.com/
> 
>>
>> There is a "part 3" to the proposals that attempts to address the new requirement where
>> some of the controls allocate at a different scope while also requiring monitoring at
>> that new scope. After learning more about GLBE this does not seem relevant to GLBE but is
>> something to return to for the "MPAM CPU-less" work. We could already prepare for this
>> by adding the new "scope" schema property though.
>>
>>
>> Reinette
>>
>>>
>>> Thanks
>>>
>>> Babu
>>>
>>>
>>>>
>>>> Reinette
>>>>
>>>> [1] https://lore.kernel.org/lkml/d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com/
>>>> [2] https://lore.kernel.org/lkml/e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com/
>>>>
>>
>>
> 
> 
> Thanks,
> 
> Ben
> 
> 


