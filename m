Return-Path: <kvm+bounces-30559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDF49BB9F1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 17:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACAF6282AC7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 16:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974461C1ABC;
	Mon,  4 Nov 2024 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d3mBLRek"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFFC2AF12;
	Mon,  4 Nov 2024 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730736803; cv=fail; b=KRTX/78RxmNKrPVUarlIfOMzPTxmvPBhYmjwhfOz6kWH04R3cegCxchpmePARYVtLfgkUyZmrqR/weM/SnkYNx3Nv/9MjgI3CxhHYI4vGIu3HgYlOxRmBz+aEwGengGpIPXEADMkHed56IDRgM2vUfDfV7RaoobpckMhvUzoexE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730736803; c=relaxed/simple;
	bh=bL1uA0yWLuAg8xwQ5YEsrPQZM2r2hWVfYr6l9DNV7EA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sndPC++IE23EF3DVJmV7ceQsHiCc/BjAnTRqrwtP8oxpiWEYExxYjM2NqiNWwVQhktRUndSGX/4xIXJ/x1JJtJaAGc0aQFeRA7x34cyqEehpTntpK9LiZrJHWIMuZEdRqovFBuKojkG503ynorroPl6rPTJIrso/yrTSm9KEW5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d3mBLRek; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAgohInlYhfo6c2/K4xI1dlIpbiuYnAsGTJ8Mcr6ZIxaplCUsofiBnC3GrT0IMjHXzbQbTWSgfelFADZNR096tzYU0R+Trg3W2vu1AW94hMhORQbNVun0vQVj9zM1gK1BJhPQTzp2U7mVHQglomFDRBZOvW8kPySBvYe0V6ppKKUrwXmHexJRsN+N9c0MU6aL1+cpaS8pTokrKqmJDdC2Cp+e8/j+8EZwmbhBPr6X3GIE9KcGShERxIwh+zTY5uLNUS7wULQWNyFLL8Lu2OkacMRJncWkuEzk8rGwfyqXa/rFBoRRTZ3U1febr9S77nzxxqXxYwgzAC9GR+H8fvs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bL1uA0yWLuAg8xwQ5YEsrPQZM2r2hWVfYr6l9DNV7EA=;
 b=sXrOD4VNMOltFP1MWw0P+9ywy8d1xeDoWOsGI5wH64+LUQkUVOcPvC89b8pzi+N69Odd80aRrvk0J3xVh/N3i5LSIz11MeA3N9JabPRwLadtk54cklnh5cKvwjB4Ffm8WW8CAAyqRnPuimmqWIoG0mvrUfpRBxce7d4g5mKd6+reCNSmlnM7U/xdZgAdqklrAf3Dp3CR44cYb48filHqEVDhK0Cwi5qlzqeBiwDf4bWYCDdUTbPUUmTzRC90UNJcX8RcPWjxdF8xJI2C/XnptnH6P8o5c6EHKnHboYwPpuX4jo9RCnC/UpfwhzvbiRMJ8LKZWE85jM3//RURM0GFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL1uA0yWLuAg8xwQ5YEsrPQZM2r2hWVfYr6l9DNV7EA=;
 b=d3mBLRekQPCvPfDZmDItGv5gIX5zfkAUCeUUdDGb/o3age68/X1DPMgeUu5gkQHybkS82NG5Hl6+gDt5Pay83Vv0pQ2+x/3NQyNUaCDLmrc2i4MaSF8PlWEBi4zGwjpRlEwVqQLaCdaB8T9nCmiPNUxnsjzEnJrm4HIm9NaTPbM=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Mon, 4 Nov
 2024 16:13:18 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 16:13:18 +0000
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
Thread-Index: AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhfTCAgAVa8wCAAHjUAIAAAJqA
Date: Mon, 4 Nov 2024 16:13:18 +0000
Message-ID: <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
	 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
	 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
In-Reply-To: <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|LV3PR12MB9213:EE_
x-ms-office365-filtering-correlation-id: 30e76ce1-24eb-4a4b-53c3-08dcfceb988d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V3JrbFZjWnM1THREMlI1a2d3OGFYWUtjeVdEZ01wN3FwS2FsTit2VFU2TG1C?=
 =?utf-8?B?bEZadmZKUEdoNUZuZlYxZFM3T2VQUlJrcVNXellZSDJoY3VhM3NRQWlYY2l4?=
 =?utf-8?B?bURld1hUUkhsUWFLSHgrdHprUzJnWVJ1L2NPUnQzZmFYV0hqd2N2NEwzSmRh?=
 =?utf-8?B?NlNDVkpLcVh5QnNQZHVtNEJxNWJybi8rRU1PL1N0WHZlYVREdmpoUW9OUXdx?=
 =?utf-8?B?QjA5NnloM2FYYnlNQ0hBdmFqTWozOXVwQWhYMUxpeEd3UmJ1NzJ1NW1tTWpO?=
 =?utf-8?B?b2ZQY0hoOUgyYlJqeGMwcG9KUU1ubkl1WDJ2TmFIbXhjWktIWUh1WHR5a2p3?=
 =?utf-8?B?S1lEYlZKeDgrTWgrbDJuNEFVU0NkTzhKaFFwWU9Pa2QydXRuSmwzclhqdTg2?=
 =?utf-8?B?b2R5UTV1KzNjcVdrN29QL0RlQWxQa0tvODdnZy80WVdyQ3hDY0FYbDd0NUZE?=
 =?utf-8?B?cE9rajQrQzlVRHJoUHBQanFudkh0VW13Umw4ck1CVmVnM2gzRmN4ZE1GMSs1?=
 =?utf-8?B?VkUrNkduamNleWZlYkVFNER5YU1Ebm42V3hTYUJhY25PMUZuaU41TVl5RjZZ?=
 =?utf-8?B?SkdvaHlzNk13MkFVKzlSZXY4K3oySkhXTk4vdFRvQXFFeit1N05xdTc2V0Yw?=
 =?utf-8?B?dFgzNUFCRTNNbjRsd083UDhuaXoweFFIWmFneEYveGNNZW1Pb3FneElxUWJD?=
 =?utf-8?B?dmpzS29VYzlvY1QxcGlYOUljWWlVdTlWSjJIVmtYb0ZFc0hxK2FrRmlsZ0xq?=
 =?utf-8?B?T0FsVW41bm9TT0hCL2U1OElFb3hEOWRCTVRvbi9iL3E3M2U5N1o1TUZrblZu?=
 =?utf-8?B?MXZWNDZWWTNiRnByejVsL1ltemtmM0gyRHhIYVFTanRXK3NRbmNpMVFPUDBM?=
 =?utf-8?B?dzRhNWNIUnFRMlRvYzVMWmtYNVNtaWVoZzZ1dzlxb3BJK21WZHBZeVB6K0Jh?=
 =?utf-8?B?U045Y0hvMm1HSWVmMFBBYStDbVJiMlZWY3Z5ZnZVNjZleGZxWmlzMDQwa2do?=
 =?utf-8?B?RWh0cGVIY1RSbk11OVZHYXo2dzhUOVQrYmlwT0NoRUtPdGRXVG1UOFloNklR?=
 =?utf-8?B?TWt4Q3psWFQrRlp5VWNpUGhRRzRIRDF2T3VxQ29kMll6Sm93MlhHQ0x1OTRx?=
 =?utf-8?B?T1JvL3dtb3ZZbThDRW92SGkzdStOWDZFV0RmL0lDRlo2SWJPQTRiK09JK25a?=
 =?utf-8?B?dUlHTC9SeXV4YVlVcW5OWTE5TEd6OCtreVZ5cFVhalkxOTNGcjVSdWpaeHE2?=
 =?utf-8?B?dWJnT3RrQlovdkhZcmU2VEUyaHNCdWVOQ0hEeTZGVW8yeEtCdW94OUYyN2Q0?=
 =?utf-8?B?WUlBT0swSzZjVUR1cEE2bmJkTUR2N05zekcvaGJkZzIzcjFoMU4zWDR4ZXI4?=
 =?utf-8?B?VzNLSlZkTGd5UG9lUHRnWGI0S2oySEpzQW13TWhpazJYTnFjS1RKeGN1R1Zr?=
 =?utf-8?B?K1N3akpVSTJndVVoVTlQSS9WelMwNURES2lnY0tsSzA3bm5HTzFjRm85VmFG?=
 =?utf-8?B?Ky9TdXNickFGdGM1Q1U1N3p2MDdCZlA5WVFpU2VQbWQzb1NSYkQveDhuSTZQ?=
 =?utf-8?B?ZFpxV1NBT2NMU1RVNktUMTcrd3VNYy9yRXk4aHpaZjdkYUN2NXloUDBoYjIy?=
 =?utf-8?B?Q1AybHFjcFBGUmJPNUpzckZseEEzTWRaU2l5dTlFRGtEQTBYekQ4ejlydWY0?=
 =?utf-8?B?b1hvYWxLTC9oRzEzUkRkRWxtNDd4YnZKK01uYUFDckVQZGZlN3hza0pXK3FT?=
 =?utf-8?B?dVZKbC80TWcwS2Fub1d0b250azB1a3FFdEVTVVVpNm5pQU5ac0xVcG81T3Vi?=
 =?utf-8?Q?BTEp1twDjMC1+foIdxFb0EDS+fiLLg+k19OZk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VGlIa1N0M2lzNEtOM0FGT212cGdxZFRGMGprc2VRcXV2Y3dLdFNLbkxXcGgw?=
 =?utf-8?B?RXU4Tmx5WlRlOWFrY0lBYTVtSkNMeG5mUWZwc3JTc3FQYndmN04zcVIzdVFC?=
 =?utf-8?B?YW9MSTZsZWlNQVVTN1k4aUdRdWx0REdhRnhQdkUydGtiQWd6TkNLMFRJeW4y?=
 =?utf-8?B?Qmo0T1VEbGt4RmNWQTdidlU3ZVlMK1NCTVVaZXJDNWNXeTBhMUF4b01LQkxx?=
 =?utf-8?B?c2M2S0U5dkVqL2ZFUy9oK3JSVklhOE81eEp4OERLMGkyenNMTUNPZjFXMGMr?=
 =?utf-8?B?ZTVlUkdPQUh4R0hCRUlXeTZ4VCtGa2dmdXNUNkFFcmkzUmRZVlBhaW5FcGdO?=
 =?utf-8?B?RGxnRWRsOGZoR25hOTdkMmdVWGRVb09SL0M2L0RQSW4rOTVPOFAxUHpxMGhR?=
 =?utf-8?B?cTFtUHdtWnRiM083TzlxN1NkOG1BRGV1aHAxNnd2bHplSElsalgwcnBlQUY0?=
 =?utf-8?B?K0pNL1VvWUlVamlyQXBYMmdYS3BFZ0ZtSDE2RHcycFFiN0YyeWZZeTVoWlYw?=
 =?utf-8?B?czZBcWxPbDY2dHdab255UjBWN3M4cWhLSzBuUjk4SlN5SjYyRUNGODljWjFF?=
 =?utf-8?B?bHFRQldvTkE4VjBMdjZEYU5KMTdWZG8xRGhMeWplQ001emFSckFLVFVKS3VX?=
 =?utf-8?B?RFNTaU00cGZ0NWlpa3dBQXRUaEN3dEd3ZkR5ckRQbUJYUlpmdmZMS0RvQTZF?=
 =?utf-8?B?eTFOeDhJRXVrNnlMT09LWFZlZ2g0cjNGTHR2SXMwNE5pdFFzSFhqZ05GWUhE?=
 =?utf-8?B?NExHcktUdWxWNTV4VE5uQVdVdGZSYWlOcFp5SVc5NGNMYnRBZGhEWnYyVmlh?=
 =?utf-8?B?YjhEdStQQjFvenZGRG5jNHdJZjQ1QTk3L0d2NE5XWjROSkRrR1ZQU2dkbjFx?=
 =?utf-8?B?eGJmZm9FK3p3K2wxeDNvekcxcVAva01ldVpuL2pieU1WcEFYaHh1Rk1WaGNo?=
 =?utf-8?B?d0xuTktLMHNvSXNJYkVUajdzT0hkRHViUTBUbDFJS1BnbjJyN2tFbjhjNUp3?=
 =?utf-8?B?eHRWTktMbGpPQ2Y1SlYrWmNhWkZ3RFc5QWo0NFRLeG1TaFNOc3ZzbzkrQ2sz?=
 =?utf-8?B?L2lVd0E5ZW93TUlKZ0lCenVLa3o1T0tab0xmdG0va1I5U0p0OC9WYnBxdFdV?=
 =?utf-8?B?NklFdWxOWUNCNEFNRVk0ZHZvYnA0VWhCOXRLcnNMMGFOdXRUK0VBZlJmM29T?=
 =?utf-8?B?bnUxUjN6UUJ4NkRlNkN0Uk8zVzNVSmt2Y210YTB0dkNjVWRBYkJGQ3pyWXQ5?=
 =?utf-8?B?K2JWb1UrWmtzWkdjOVgwRW5qVFJ5OEI4eDdpQzhFaUdPazUrVlNaalM4VFpJ?=
 =?utf-8?B?RGtSaUM2Ymk3Ym1WbVQ4d3JwUFpVbFJPQ2pSTmxTSTVJa3RpT2E0dzVjNGFU?=
 =?utf-8?B?SEpadDRjaUVLSVpyRENLK09yeXdXbjBhOEFwYjdIWktFTTdVWEFrcVZnQWdy?=
 =?utf-8?B?VUxLcGsxSzFDNmhxQUFCaVJzMEIvOEgzbmlOanpDV0VXK0xCS05PTGVlcGp4?=
 =?utf-8?B?SFdmaklNUVRkaytNbFhUTEcxVGY0NDR1bHlCWU9MTXhyWHR5RGJkbndYdm5o?=
 =?utf-8?B?WHZNZ1dvKzhKWWt6blhPZE1INERBdFVSeDZzaGRqVVlxamVtOEJYaHZyc1ps?=
 =?utf-8?B?ajJIU3VRbWV3NzkxeWc0U0pPZUZPYjMvNEpaaVJQRzVJZG5tQk1USmg3SUlY?=
 =?utf-8?B?UTVHNXFoWkVnemxoWmVaSCtmVXJLTmlLak1OeXpzYXB1bVRtcUVxYUt1WUFX?=
 =?utf-8?B?NlNDcjFzdlA3cUIzbzQzUUNQaEk3eXIwR2V5cWE4THp5WlE3cjV6SEdJRmw2?=
 =?utf-8?B?L3JrUnl6KzJES1pFREIyb3Faa3NyazIxRC9aOHVhLzh0WWJWeWVJck9jUXE0?=
 =?utf-8?B?bmR4Q3ppV2wrSkUwWGlIUGlPQStDWk16aGVZdFIyaC9wVU1kZ3FBNzlybHN0?=
 =?utf-8?B?Qk5LTWVFMVFWVTNGOXZUcm85WllESmhiMk5kLys4bi9HRDc4K05vT1ZIY1Yz?=
 =?utf-8?B?bkE2TFVwVGtRK1FTVS92WEVIRitLQjBSdHREUzVPWE1MWmRjTlBnY0RzY3RS?=
 =?utf-8?B?MVJiRHdQSnZ6RXd4Z01mR2dKWUpUQjY5SHNGdDQyR1VTbUpYOUJ4eTZYRisw?=
 =?utf-8?Q?lHYY+NXCOIqiDnd1+1vNPhITf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A6F0B90AD72E4449092526CD24AF753@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e76ce1-24eb-4a4b-53c3-08dcfceb988d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 16:13:18.6505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GB4nc7onfIZdWQDDKagltEaRCt+ZUX/3b8jlbVolmAYauukNMDu7LdHoPQOtbADD2G7Pcmnx9RFRp8nyxu5H7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9213

T24gTW9uLCAyMDI0LTExLTA0IGF0IDA4OjExIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvNC8yNCAwMDo1OCwgU2hhaCwgQW1pdCB3cm90ZToNCj4gPiBSaWdodCAtIHRoYW5rcywg
SSdsbCBoYXZlIHRvIHJld29yZCB0aGF0IHRvIHNheSB0aGUgUlNCIGlzIGZsdXNoZWQNCj4gPiBh
bG9uZyB3aXRoIHRoZSBUTEIgLSBzbyBhbnkgYWN0aW9uIHRoYXQgY2F1c2VzIHRoZSBUTEIgdG8g
YmUNCj4gPiBmbHVzaGVkDQo+ID4gd2lsbCBhbHNvIGNhdXNlIHRoZSBSU0IgdG8gYmUgZmx1c2hl
ZC4NCj4gDQo+IEhvbGQgb24gdGhvdWdoLg0KPiANCj4gSXMgdGhlcmUgYSBuZWVkIGZvciB0aGUg
UlNCIHRvIGJlIGZsdXNoZWQgYXQgY29udGV4dCBzd2l0Y2g/wqAgWW91DQo+IHRhbGtlZA0KPiBh
Ym91dCBpdCBsaWtlIHRoZXJlIHdhcyBhIG5lZWQ6DQo+IA0KPiA+IGFueSBoYXJkd2FyZSBUTEIg
Zmx1c2ggcmVzdWx0cyBpbiBmbHVzaGluZyBvZiB0aGUgUlNCIChha2EgUkFQIGluDQo+ID4gQU1E
IHNwZWMpLiBUaGlzIGd1YXJhbnRlZXMgYW4gUlNCIGZsdXNoIGFjcm9zcyBjb250ZXh0IHN3aXRj
aGVzLg0KDQpJIHdhbnQgdG8ganVzdGlmeSB0aGF0IG5vdCBzZXR0aW5nIFg4Nl9GRUFUVVJFX1JT
Ql9DVFhTVyBpcyBzdGlsbCBkb2luZw0KdGhlIHJpZ2h0IHRoaW5nLCBhbGJlaXQgaW4gaGFyZHdh
cmUuDQo=

