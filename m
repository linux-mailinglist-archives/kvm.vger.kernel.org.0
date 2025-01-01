Return-Path: <kvm+bounces-34456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A99D59FF37C
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 09:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702BD161BBD
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC305674E;
	Wed,  1 Jan 2025 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RyAWm1qa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F28D3B7A8;
	Wed,  1 Jan 2025 08:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735721781; cv=fail; b=i2TGdU2DpT8DvOf1dvxFNUPsxZwD7uV2AuWG262VemFePhWupKTYhvBWoRsd6SRaflABGEGt47Vk3htaJ/CiGhEuAnxILpDyE3cqZk4EQEURc6B5TtNJASDVqG+WGWxJm7LsudjRE6E3PsSp8wG5FWams89zjnqQI/fg1z0uK90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735721781; c=relaxed/simple;
	bh=lrr61MJXafYdmPkSefElmdNFPt5KTx90hsePzBmEnbk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bvdlU11gigGMEBsbaN2qP47XGscaxgaRKUiy2n1kPeQ/Tf97lmTnrlHFl7jxSXfTuuVliZjCFatCJqW1DopoxfF9A4J0AAkM/NoEuwLYlNR1RZm94f1WIBCck7U3xlu94MO0iFIxwtl82jCB0THMzh4dpnaMPt0cxdwUNyrXy4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RyAWm1qa; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e3lM3Gto5XwurWOZMli24mfumqLr+T64dOH2ZdXVMVrQbrTOAy4tDEi3sVKmjx3+AT0U4escvVRczAdAVyn/0MNu3Reu2Cl/DFFehZz4aFTfgmnmykA3I0yc/f6xcM0c6tbq18yySEH/DGTBaMKsMqdvA6oxnnIBPMnZwe5IqZLPFUlU/oDqsNFyuXCnDHLTprYwePpFUMQDnMYjTDxZ48TMeIF6TTEoKZB/8ZzOy9/eMgS/86YC9iNHvDDtx0T7AwY2j04YuzbVCE3CcFqIunOpyi8JLG1TERNzaz7p6pvkz5ouY1G80MwD2LMTHf/F8NhgIxQJXIqfNdyGOM0kww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIBMOdbBgNQqG7yXg1BjjdQbwbTjPlHQAI+BJgAMqRs=;
 b=SJPKC0wHShkpJ0nHWog7usNaMYu+B8seGVxuH+IEmS0UWRE0cl79LXjwJhgXWGtxn8SM8Z1G79DVXPutwcA4gp5FsmdBgKBP9v8IxQcp5E13k6mrMdiNTTe2gqyk2QbGlkt0XbTZUbOJNXqLgDsZoBfIDE+OfdMeS02Ih9JgdEPBL9TWDrPKHy65DYZRaPfQNab0gOeJlD7Q+fiajY5qIB7Q7Xw2HWz8O2VQjDZbUiqtn3r3SwQ6hKk1WnA5kQDY24Eitseohf70kKjTuU43a8xOlBmuZIuWPNTo+wNPpsIus+wvlbwf9N2vMoiWmWPtfKGIDG4aMLLVovMf4mn29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIBMOdbBgNQqG7yXg1BjjdQbwbTjPlHQAI+BJgAMqRs=;
 b=RyAWm1qaxeneh/nHtRaKPtIHCXMMQ/9y4WGji6RuyS8x6xj6aVy9IsCIepeMpxYSfH4xb8WW0Vy4Nv4QlLyuvD5QL3q0uP7/292WkBeJwpkLjDmQcexWLRgOCgsWZu4y0qRySsMcdYidzjd2nYXSCQxSTfTop03+vY77jax9X0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.19; Wed, 1 Jan 2025 08:56:13 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8293.000; Wed, 1 Jan 2025
 08:56:13 +0000
Message-ID: <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
Date: Wed, 1 Jan 2025 14:26:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0237.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ca8341-5454-4264-28cd-08dd2a422505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDhpVmIxQ3pXNDhwaDUyM0pGeGRmTXlKVG9XVDdmdDNyYVpQSmJvLzh1UU84?=
 =?utf-8?B?SkQ0L2dodFZra1FIOHFxMzVlSldqaEl0ZU1QaDFVTUFWazNsZVA0SGpnUXRk?=
 =?utf-8?B?UGx2UTdJc0VnUDQyVFFFRytNaTJIbFR4cTdhUnJGdU9JQzhZUTE1ZFhEMTVG?=
 =?utf-8?B?ckFSWk5qREoydXJlMis2ZWJpY3lHclFudHdTQXFIbGRXOHQ3aCt5Tk10azNo?=
 =?utf-8?B?Z2xnbnNSYkNTbWM3a3FNcDl5RnRBK1laV0NiSFNPcEVUQmdnU1pUQVNFdmN0?=
 =?utf-8?B?L3pCSTZENkovYnpoZSt6eS9wOFdxbktSVGNFOG1PaitHV25mTU9VMEFRMFkw?=
 =?utf-8?B?RSsybk5NU0RSbzY2SEcrM1FDNTJmYTRjOWFPSEU1VFZxTVBFL0NkR1F0bFlJ?=
 =?utf-8?B?MHVBWklLTUU2U3czMHQ2UUdjd1I4Ujdrbld3Sm02MW1NMEtzTHRlOWY1b3ov?=
 =?utf-8?B?WGFqUktvNmhLRU5kbnNDekJvS1JybzRRaWh1VnY2dzV1eW5LQkpxNE1WZytI?=
 =?utf-8?B?dmNsT29SL0JqbHRyc3BJQkErcEQzZDkyWFlhKzlGY3hHSjBUekc3c0N5QUps?=
 =?utf-8?B?aEhuZjhsNG1idmVHdzFtVi9xSWlyOHFlS240ZzNLeS8zY3pFTG1DSGgwcWtF?=
 =?utf-8?B?STdNUGt1c0ljdGM3bXl3WVZBTW40R00rMW5KbE1Yd1N3QUJVZ1F5NlloV2tU?=
 =?utf-8?B?Z1ZpWlJ0My9ldEdUcVVoNUVmcjJKc2JXdm5sWHN6cnZQd2ppc0lwb0J5QzVC?=
 =?utf-8?B?ZkhlclN1VzRIRlJ4akUzdFNyS0ZSNG9vKzNzMnR6dkhYdEVSblNMMno2STFj?=
 =?utf-8?B?blBVQUVaSzJ0TlFOK3dQYmZTTUcvNWlHU2c3ZTUrZG1FVnF6azFiY1VqUi9L?=
 =?utf-8?B?Y0tpTDI4NW40SFpTdFRzV2F4V1AzS3Nod2RENkJXQlBpQWdjdEp3TFZrTzIv?=
 =?utf-8?B?NkRrMjdxWG5BRWtPd2RtTTMvMkJ2MysvQ25uRGFuNkxubUttWlIwTXZmYVFJ?=
 =?utf-8?B?bUo0ZGlpRzZ3ellPNGdKTDF2QnAvaDI5TU1CdTY5QVdNR1puVndweFFpY0Za?=
 =?utf-8?B?KzdsSFo4THUyalpldy9sYjIybHpod2wrbmxTSXdrZkQwbkdobFY2emlTcUJp?=
 =?utf-8?B?YzRIZlZCUGw0SW5nYVVWRnJIbDN1ZGt0SzR1b2UzMU1vVTFkamtFRlJjL2Ex?=
 =?utf-8?B?V05zY0pGWU40MDBxQURuTHY0aDc3ZkZwQVJ6eXJkNGZIVHI3cWRQU2M2RGpX?=
 =?utf-8?B?Tk1jSVFSY3hDTUJFT1dxd0xTbXVnTXhDTDYreHF1bGc3OWFxSVZYV21EQUIv?=
 =?utf-8?B?d3hiVDNET3ZWUnBoR1JBTmJ2TXczZXFHbzRPKzg4Y1BqSTEweTlOWGJWdmtp?=
 =?utf-8?B?S0U3Z2crUHZsVUxxK3dHTzcrMHNMbW1tQ3F4V1RHT3BrOTNPZFFPR0FiQm5P?=
 =?utf-8?B?UVA1Z2VJS25xa1hza2FNRzVrdVlWZG9NU1VaTEY3OWFOZER5LzExOXJBVldW?=
 =?utf-8?B?aWtmR1p5SFNmZUgya1lyYmd5c25kTFBQVitmL003R2VrSGowRTRrV1g3RmFZ?=
 =?utf-8?B?dWxZUGRTYjBoYWd5a0NhcW95bit2cEoyUHlBSXRiRWxzcmo5aG5OTW5mZFFw?=
 =?utf-8?B?czltbmE4UmowK2hKbVl4aUtpS1liTUdsWk1ETUdHSUEwcWYreUptQWh2OER2?=
 =?utf-8?B?NHdWb3BhMWtGQ2lsbHphc3V0S2l5RThKZnFTNm9EZTk2QmJiWnBHQzZEWHZk?=
 =?utf-8?B?RWVJM0tVUHVkSTRqWHVrNVVyWVdHTGdya3JvUm9HcFk3N1o4NTByWEJFZWts?=
 =?utf-8?B?R2VOMnVZQTV1NTdtZVRZZW96MjFwTzJxUnBBWERvM1lCMnM0TnF5MWJCYnNW?=
 =?utf-8?Q?sAc+dUF0fFi04?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEpTY3ppSElrYUJtanZDTWlaMTdZeXI0OHVTZTRmaXNSYzAycFJ4L29jeVVX?=
 =?utf-8?B?QURya2g4YmJWdUlNWGp1UVVpUGs1SEk4VXVVb3Y1cnl0bmNSQWxMM0hkVk5y?=
 =?utf-8?B?K09DU3I2V3l3bUdCSmkxN3JiSDFOT0g1cTVCWmxMQkVrdmxEZk9mOFp2RmQ0?=
 =?utf-8?B?a2lhaHF6Y2NSY2ZndkVxK1RRRUVidkcwUWRUV3ZDcTJZbU5vakdPZDM5Y2ZN?=
 =?utf-8?B?MFpOTFNBOG1xbnBZb3ZXT1B5MXdvUTdEUjI4M3JpYytnZktLMEFLcEg1a3pS?=
 =?utf-8?B?OVYwLzlmNFFsMU9ERi9zdEhGUVdaWWVkSDVSdkxwLzZvQ010MlBNTWlSOG11?=
 =?utf-8?B?NHptekVnQnFxbHoybGxySVdYbS8waEduT0Y1YUVDd1lJWXVsUGpFUHdIQ29r?=
 =?utf-8?B?S1l1RHNCcHFXeUtxQW55MWJVajFWUXZTK2lJMDcxRkYrc0U2cEM2MDBCN25y?=
 =?utf-8?B?SElQVVMvcVhtMzRlaHhQeEhoaS8wSG4zb1BzdHhNRGt6cm53QjduMGo1elJQ?=
 =?utf-8?B?eE9ITFk5dW1xR0tQV3luT0VMV1BRSW52RWRVMG1QNXl3Wk9Lbk9KZTJvUDJI?=
 =?utf-8?B?SkdmbUpDc0NGVlM0YUVkR25RSUVBbzZJZEVZdnBlQUM3SlhWcUluRDA0a2Y0?=
 =?utf-8?B?bzBGK21ST0ZmVjBZNlB5NTNsYWxROFdkclY4T3Evb3JBcVV4UFJnSHgwUXZK?=
 =?utf-8?B?RmM5ZkNjWTU1RlVzc1V0RXcwT3AwV01RQmNjcnE2bkZDZjk0SHZqMGlEaHlo?=
 =?utf-8?B?aFpQY1dZUkR3R1JBdlNjSlArRFZRdnVhVVRNN1dXN1ViWUZqaGk3ZWhnNFUx?=
 =?utf-8?B?UUtjaWxYd0xJYXNPQXFGTFlETytCN21yL0lMUlVNVTFmQUlmZTZOM3NwQjhm?=
 =?utf-8?B?RE1PRXMzaE5maTBPVmlVOG9hSDNDTTEzZ05iVm12M3haeFlIUTVWbVBiRlFD?=
 =?utf-8?B?a1lrTzZ6SUJWUHRSN1JLV0RIcmFQSW9saWZIREVPeVVkMlU4WFA3MWFmMlpQ?=
 =?utf-8?B?U3lVZ1FnMEo3U1ZmOFROMUZmQXc5b3RTOCs2UDE3L2RlTlM2NXU2UjZOT01I?=
 =?utf-8?B?aWdVaHk2QkJVVGc3bHBKSnl0dVcyTUZqZjFTeDBkdmJDTlBxS2wzcnU5Y1dR?=
 =?utf-8?B?NjRGTjZ4MStPZ2tqWFVENDR5WDBhSVVjbGxobDdJNTY1NVVvU0dPL1VKWks4?=
 =?utf-8?B?VGlZd0k5TGlLYnJ2dVphWjVaSTZnVkE3K3ZoejRudnNBNnJmSS9vK21nakpk?=
 =?utf-8?B?WnZYOHQwdGFOSE9ZYk8wNWI3bVlNeUFFT2NNUTBnZDFuemRodDNWUFVEQjR5?=
 =?utf-8?B?NVRNa3pIeHJmaUJwVks1TVAvSHYxSGVaL0orbkI3UG1ndUpIc2xGMktHQmtt?=
 =?utf-8?B?a1FHS3piZ1l2WWRtMTQ4UTIwdnhiNXhxUG1WWDRZYndVN3FPdXpwRml6VHlP?=
 =?utf-8?B?UVh0ZnRVTGllSS9mY2gyRzZRS2NKSkZ4ZnIxaHoyQ0lqUUdHVTVUQ2NIQ2hF?=
 =?utf-8?B?WW1BY3hEay80Ukh3d1hSNW1YR0J5c2NQR2ZMdWJFT21NMkIwRlN5RXpTWHJt?=
 =?utf-8?B?ZUdoS3lEN01CbDF4aE1FckxDaUZhNVorTkhZQktIRUlMaVZhZHhwc09qRmJu?=
 =?utf-8?B?VU1vZFN4MFpicWNPN1MxQk1Gd0QvTzhsOTNackhsanJFQmZRVXJqeGhpSm1X?=
 =?utf-8?B?eXJmclRHb2g1cXBzd3FQb1VtM3RRYzVON2x1RCtnTUZCbldKVVJYZ3lobS93?=
 =?utf-8?B?NFlkVW1sRGt4MzRrT3k3VXNQT3BhUFE1UTFuQjV5eTdPY1JLUkhpZkVJQ3pH?=
 =?utf-8?B?VUNNUGpDSGJNaUNWQnJOK2cwc0MrMUNsTVNwK1VydGJyVTVNUUc2UVNzU1gv?=
 =?utf-8?B?RDN2S2tOZlVrb2hyaXZyY3l2cStGY0xOQ2h2YTBENUtZajNPbE5Eb0dBd1oz?=
 =?utf-8?B?NEVPN29aVnBpSEZFd3NUT01laG84endEcjBQcytkWkZWaFNDNG1WcFk3UkM0?=
 =?utf-8?B?NmFYdCs5S3lrVWlIWG9oN1NWdU1zb2dIYnQzNlcvWnRKdXZsTWZiL0dCaEV6?=
 =?utf-8?B?WTMrbHBaL1QyODVrbzNIbnArckZKY3FqQ3pmUnN3MGRjSjhCSVVsdU84bUxk?=
 =?utf-8?Q?AAzGKh0B8FN0wuAq/gCJUtAdD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ca8341-5454-4264-28cd-08dd2a422505
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2025 08:56:13.7053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UHvKvkt6DMEKY7DCmD+n3eS4vtcRHrpZQpawx1LQGAGbDBqPO+TzzrDPjaVpd9jtSG+eDUcX/Y8EN3GX1s3HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7558



On 12/30/2024 4:59 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:41PM +0530, Nikunj A Dadhania wrote:
>> Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for...
> 
> The tip tree preferred format for patch subject prefixes is
> 'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
> 'genirq/core:'. Please do not use file names or complete file paths as
> prefix. 'git log path/to/file' should give you a reasonable hint in most
> cases.
> 
> Audit your whole set pls.
> 

Sure, will update

>> +void __init snp_secure_tsc_init(void)
>> +{
>> +	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>> +	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
> 
> The fact that you assign the same function to two different function ptrs
> already hints at some sort of improper functionality split.

As kvm-clock would have set the callbacks, I need to point them to securetsc_get_tsc_khz().

arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_tsc = kvm_get_tsc_khz;
arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_cpu = kvm_get_tsc_khz;

For virtualized environments, I see that all of them are assigning the same functions to different function ptrs.

arch/x86/kernel/cpu/mshyperv.c:         x86_platform.calibrate_tsc = hv_get_tsc_khz;
arch/x86/kernel/cpu/mshyperv.c:         x86_platform.calibrate_cpu = hv_get_tsc_khz;
arch/x86/kernel/cpu/vmware.c:           x86_platform.calibrate_tsc = vmware_get_tsc_khz;
arch/x86/kernel/cpu/vmware.c:           x86_platform.calibrate_cpu = vmware_get_tsc_khz;
arch/x86/kernel/jailhouse.c:    x86_platform.calibrate_cpu              = jailhouse_get_tsc;
arch/x86/kernel/jailhouse.c:    x86_platform.calibrate_tsc              = jailhouse_get_tsc;

> 
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index 67aeaba4ba9c..c0eef924b84e 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -30,6 +30,7 @@
>>  #include <asm/i8259.h>
>>  #include <asm/topology.h>
>>  #include <asm/uv/uv.h>
>> +#include <asm/sev.h>
>>  
>>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>>  EXPORT_SYMBOL(cpu_khz);
>> @@ -1515,6 +1516,10 @@ void __init tsc_early_init(void)
>>  	/* Don't change UV TSC multi-chassis synchronization */
>>  	if (is_early_uv_system())
>>  		return;
>> +
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +		snp_secure_tsc_init();
> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index aac066d798ef..24e7c6cf3e29 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3287,6 +3287,9 @@ static unsigned long securetsc_get_tsc_khz(void)
>  
>  void __init snp_secure_tsc_init(void)
>  {
> +	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		return;
> +
>  	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>  	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
>  }
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index c0eef924b84e..0864b314c26a 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1517,8 +1517,7 @@ void __init tsc_early_init(void)
>  	if (is_early_uv_system())
>  		return;
>  
> -	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> -		snp_secure_tsc_init();
> +	snp_secure_tsc_init();
>  
>  	if (!determine_cpu_tsc_frequencies(true))
>  		return;
> 

Sure will update.

Regards,
Nikunj

