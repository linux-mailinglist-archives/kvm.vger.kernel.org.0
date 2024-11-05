Return-Path: <kvm+bounces-30718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E10349BCAA5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1150A1C22517
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471991D2B0F;
	Tue,  5 Nov 2024 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BlAmyKBh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D31D2B02;
	Tue,  5 Nov 2024 10:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803187; cv=fail; b=O9WJen6ZicHbODzXTO8X6Al7qwasg9cV/sDaYR5xvq96zyGMzZU0Ixn9AutJpJP1DXZWnwrQ0icTyKbVp6nyU5P/Fotly1eB6GunVeTU/6R+0nXRQqJcAA6jXKguigzcWA4IX03Ze2rLqoiQpZRPauzc30FXNwWODeLCzBavK84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803187; c=relaxed/simple;
	bh=ssG426X4TBDoIfHjylhrpFFzPQzgUIjv+dMTVeupuSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QSW3qdDU04xu5JYXgImmj7JatXTyqgGwz/eaviie8XgvHODfsTtGzAc0wAMo0pJZtoTXDav9SfPGhKjSUXUqwEg+teCa9H/100/3cHVEvgf1IyT93j815D84jn0luuvTMycZVD0WPHehjo4KPqRg0V7B+ho4oF1cU6vX4nfclZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BlAmyKBh; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BL/5kkoTSECAGOdhDxMZLbdiuungsqDVECuOA2q3SQUmyYmzhSfAbChSvs3e5ztjaoiBuHTmveuYKH8+ds5rrHirR6OF+qqZXHEhLsgm5RyNoO7Qn5TAzO4gNv7V3jfQYAAXCsN1Wmt6fEm69CFSeRq03+I5mRMnibKXRNZO+rFmPxk3ylwAIiwCQJNrFK4CK3WFM3f4VcyWEh3SMq6puNzui1oWjhvtRZJO5CnfjYdFeBU6b04ZIQUx1gHKRFrqqxmMsbKbyF81DGtHCwTbEBjRECcofX+j5mrEOhA4T4C8f81og06iHnyWCvNGCnsEqs5ugWV/7IuMFK3S1g1BEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssG426X4TBDoIfHjylhrpFFzPQzgUIjv+dMTVeupuSQ=;
 b=Eih9wQA4L63H3OtQ/RZ9Z38qM3X9ATUlG8qXsX8xgcgEfkIMJn6BMOElq+kbO4UAqJgDUQgCZBiS8X6lQNAYwkqaT+r0xJZcwM1efaJU++UFgled+tSpffspWGB8enLeNc/yAOAkHMli8hfOeyWb1Xt3e3E7f8e54pG5AXxlFtOGYubixmLHK1ZOjCSnyNkKbz882hIDLGxu98Uabgp5L9wgNkZ6uq119Gb5gc2enh4Sit+HJ8yyzetrW8+IM28xqbNNS5U2agML9g/4dV/jLN+uQwQRdEigKEmhMq3pMcNLBGuFjiXWWB7NCMWvfrS6+LChqF+S6x92hNxPBWuTPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssG426X4TBDoIfHjylhrpFFzPQzgUIjv+dMTVeupuSQ=;
 b=BlAmyKBhyfYLtcf4TfwBgNiNrrukC51MY+Sfc9MrnHoyJMqcR1oVP2K3dM9H0A8I8o9hHZopc0VH9RK2IIaZtJgCbFVUbD2z+Q2uTMn4JT5tKnGdco75+tdnNmnR5io6YzaP6chhmMWWuY6UqrdOYmWX5DsvgTjFbAEL+NtHjL8=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MN0PR12MB6175.namprd12.prod.outlook.com (2603:10b6:208:3c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 10:39:41 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 10:39:41 +0000
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
 AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhfTCAgAVa8wCAAHjUAIAAAJqAgAADwgCAAA9+gIAABmUAgAEbeYA=
Date: Tue, 5 Nov 2024 10:39:41 +0000
Message-ID: <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
	 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
	 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
	 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
	 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
	 <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
	 <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
In-Reply-To: <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MN0PR12MB6175:EE_
x-ms-office365-filtering-correlation-id: c27d34f0-30f8-4edf-7b68-08dcfd862788
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cGhFY2FIMWtJTkdYZjloZExDVU1JcUE4dklaOWxSZ0tsTkZJNlJra3lSc2tX?=
 =?utf-8?B?Tmk2ZStSUHJ3bVhUNTE1MXVqT0JGNk8yMUVtWUZzeUlGR0VBcFRXdFQ0YlJ5?=
 =?utf-8?B?Q3VkYnNRaW8yZC9TVkhWTm9pZHVOTXUvZjBaS0RKc1oraTF6Uk5JNmx4ZWdv?=
 =?utf-8?B?OUw3K1VqeHNHL2RLU1B0TG9wSGszSDYyelRHZ0RoY0s0TkZubTd3anVVdHJO?=
 =?utf-8?B?dW95MWFiS3NweXdlbkJUYnM3bk9RVTFGUFBRVzVPZXVOZU1SKzA4MDFIM1Ru?=
 =?utf-8?B?a1duY1BETGloMjZyVkpyNjdUOE1ENlloZlIwMjBIVnBTUmx1SnZVSGRBY0Jz?=
 =?utf-8?B?L21UWXpBUGpLempHckNDdjVFS3lWUjBLRmd0UzJqWDNSZGdMN0JyY2NVak51?=
 =?utf-8?B?NXZQU1NZekxvQnF6NFFyK0cyUldIWnJ5dzlpNGZlWWh4ZGM0L1IrNFBLVGJM?=
 =?utf-8?B?UG5DdWoxSDF3Z0RsaUxiRktKc0lyd2RteU41ZXdxOWpYVmIwK1NTSGdBSEtU?=
 =?utf-8?B?QW1jbWtaVmljd0Q5Nld3em1YUllPUWJmZjVFRFhZdUU2WXBiVDZYS1AzcTl2?=
 =?utf-8?B?R3ZHRlpnYlUyMHRlY1ZPb0w3NmVyZ0k2VUY0NHZnTHFSQWlFN3pycFdCMWY4?=
 =?utf-8?B?Q2Rrc2M0NWFoTWZaLzNuNXVJUXhoYU1RM1pxZElLZjlZSVJUajJpeGtMK3p5?=
 =?utf-8?B?TXowLzVlTXBTaG15K1oxaERCemZYVEdSai9BRjR6ang1eFN6bkxFOG5sNngy?=
 =?utf-8?B?TE1kUjBuM3RqN2hNaFBpYWFJKzlFOU52VFJzZDFqQ1ZZMEFIMUJFR00wLzFM?=
 =?utf-8?B?bmtXTHNPbFYxZnFrWVdCaFZaYlE4QWhOMHZqSkc3NlNVOFpmY3BNaTNZcGlE?=
 =?utf-8?B?NWFTQkw5L2RjNzR0M2RsaVdEcjZVNVZRTEsvTW9vNlI0Z3Exc0QzS0QvTUVi?=
 =?utf-8?B?WHFxb3Q5YVJ4QnNTaitVTUVhTFBHRTd3TGhYaW0wazNUdU9BMzhDYyt1RUdm?=
 =?utf-8?B?NFcycHg3ZUlrM0YrS2luazFBOFlJVUsxazRvbGpKRWo1ZTU2eC9WcGtza2VH?=
 =?utf-8?B?VFd6bUdaSDVPMGhVNlNremhIQ0tyZktDUzdBLzFmc0hSdnU3MVRaK3dlM0FG?=
 =?utf-8?B?UzVHb3gybEl6UlRvLzBoRGxZVlhmdkttMVlJWktwUVplUnlCZ2VEUmpCNVlS?=
 =?utf-8?B?bkhUTm02ZGdUZ2VDRG1rNHdHV3VmdXUzUDVDQjVoTzRYcXlBNFFDUlVtdlNO?=
 =?utf-8?B?RkNLRm9pSGJ2ZERHSElrVUg5QWo1TlVLUDlrWG1zWHRxUzRjWVFlc1U3amlu?=
 =?utf-8?B?NnRhcDZUS045NjBJL0l6S2JoM0t0S1gwVk5ZREtIWlo3N1JhMFN2RWp6eG8v?=
 =?utf-8?B?RzJIU0pvRUhSUDltelBDU3B4cVNvRnNCcXBaWUdGYWlJR1MvMmpVSUMweFF2?=
 =?utf-8?B?cDBZZGdTczA3MUNqL2VpcGVzZFlOaFk4RFB2TFNUMWRNNW1rVXRGWHZUQUs1?=
 =?utf-8?B?dTVmYmxYazdwNWJ4d1RoZmFDWFc1eUZYYkR5ZnpTTlAzU3JPeHlxcEU3amU4?=
 =?utf-8?B?VnR1NkRFUlFWVUxMcEJDMHR3cnZRcEFXRExscDdDSHoxWnVOUnlXZm93anlW?=
 =?utf-8?B?d1F2SVhzbGdhWFZtYzZWYmd2dUpLZForU0xvSm9PbFo1OG5EYjhoRFhGRG9m?=
 =?utf-8?B?YzYwL3Rsc3o4cmNMb2FjVnc3WG1OSlpCbEgwTkthbTR4NVJGOUc5Z2pja3Rk?=
 =?utf-8?Q?ZM+mR8uNM9ri5xYGrX6JSEVpNTzirlpnogmoBEf?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dzE5dCtxSWRCMmtxVzVsVzZxbTNGOHcxdlRDdEZjemhPRU9pa21kclY0QWlD?=
 =?utf-8?B?SGlBcEVVc1RuYktqdUFweERxT0VKNkowT2hRN1VHOUtTc0tXU2p1UW42aHp5?=
 =?utf-8?B?ZzhJVXBNdlZsRnpRelVEelVtZSt0MGxRM0lMdWFTZ3hpQUVJdUg1VlhuUFc3?=
 =?utf-8?B?RzZYL0FycURHTmJwdGxJU0ZVUi9ZZVdUSnZrMVI3MmJjdjQ3KytBb0RMcHkr?=
 =?utf-8?B?Z2lTdXRQZXRNL1RNUnJLU25TNWtKa2oxZWhYdjQ3Zzg3MUNnVlh0eS9hMFRL?=
 =?utf-8?B?SFBtbm90VjlZQ2VzbXpqWDFiS21iOS9jSEdTaThnb28zeit4UTl6OS9HSFNo?=
 =?utf-8?B?VlZnNWtzQ3JBTWRxWVpYbmNJTHU5M3ZtdFd5OGV2SkVxeWNuTnZUYXJhMVIv?=
 =?utf-8?B?SXVzaS9Rb2lFQ1FMdmJkZUt0MWFVbGJZTnJZd0VDZXAvL2d3TzFaQTBxY0JU?=
 =?utf-8?B?eUM1L0Z5UUUyQnBrU1VrN01Bbm5JZnFVWEpzaElGa2RoeGhGUitDTHE2UlE5?=
 =?utf-8?B?VjBGaGdRZ2RMYWowY2ZZdGxZZVY2WWJsU0ttV3BCbVVQaFVjR2YyT2tmeDF4?=
 =?utf-8?B?S1hQeXRjZ3d2Z1Jna0hoMk5OUGVEMkprYVA1alVoT2s3aWpyenNWa0pZMWlk?=
 =?utf-8?B?NFpTR2E0MmpJTE54YTIzNG95M1NrSnRjTEdFVVdsUFlUUDgyL0xESUQ3dUF0?=
 =?utf-8?B?R1JpOXJoYjJyRmNYSEFSWVlwelcrYVhub3JLcWhjOGJFUnVGYlloRmUyVkZa?=
 =?utf-8?B?ei9BTzY1WUhCdWgyRUExNVdyVEJTL21pOGwzYmRpeGJDbnVZY2tZc3RST1Rq?=
 =?utf-8?B?TXV0K1hERkpLL2R0SzJkOTNTRkg2RUpYZzlIY0tnTTU5ZS9xUDNoWmIvMnJx?=
 =?utf-8?B?K2YvQllRT2QyR3BJNUFPQ0tNNEdZV0xtQnpPRFJibTVXblJOTk9GZ3c5azB1?=
 =?utf-8?B?aTRKclozYnZXWURyUmxNblN3dUdFdDZDTG1hNDlqOWVDN2RRUDZmUUVPK3FH?=
 =?utf-8?B?dUdHSlVGZGlhQzFUelhaWWpPQVBuQnhPalJEZ0hhZXJPOGpaNm53Sis1RGZ4?=
 =?utf-8?B?L1JRRGZJeWc3ekk1Z0E4Z0RUQkRKa21mZDFqWXArYTBwZ2lpS0hjbXRLZ25R?=
 =?utf-8?B?U3lqL2EzYTlDRjVET1haYkJUd0NHSEt2OVdtNW5TbGJmclVxUG8xUXRrUEpi?=
 =?utf-8?B?YTN4TmZKbWRGSGtMRlRNcTB4UFZGUU00c2ZkbjVTNXVTRFpCNjA5ZGF3aFJt?=
 =?utf-8?B?QWVsQmV0SnpyYklRWm5kZUp4R3hvcTVxNSthNnM5UDdkRVFFaWV5M2VUSUVT?=
 =?utf-8?B?L1V3MHlDWldDT05qdm80WXBjUjIvcEhIb2tNblRhNTFuR1J2QkFFZGZYZFZJ?=
 =?utf-8?B?Z2lDMmhTWHpHa3VxNmZnMlB2TnlCcTFITnhadDlPTzdualZoTXd3eXNkWm5u?=
 =?utf-8?B?UDJycmUzckYzSGo5bVZyZk9IY1QyZFc2UnpxTmlFdy85eGZPd2hxV1JVbnRI?=
 =?utf-8?B?cjNHRXBiOHVqMXhwWG1PeWR1NlZiaE5SaEJmTzNlWUU2OERqWFhmNHN0SUhW?=
 =?utf-8?B?MXV0OEZETG9FWk56azhFUGY0NHRzL0dINVpLTnlCUkFhSUlSYXppU01nNWJ5?=
 =?utf-8?B?VjY0VmkzZzFFakdpbWlWVEZwZXBaRGduMkNGMXhLNk0rdWJLczhsVlZHQkI1?=
 =?utf-8?B?UERLYWo4RjBjUGJNS2ZHNWtNYVVCR0hwNzZTUWhlaXVhWko3ZFU0MjNQNzhk?=
 =?utf-8?B?L3JYUy9LalorbzQ0T0QzR2l1R2wzdVFDQXdvdmo5N2ozbEFLZnhXS0tQOFZI?=
 =?utf-8?B?MFhJczBwRGZCYm5oajlQZWtnQVk4KytDRnliUUd1N21zZFV3amtrVjl3dUVz?=
 =?utf-8?B?dzZkSmxDTXgvdVlQVEhwNUw2SzU2MXY5T1o4emZ1YlBqMTRzbktyR0M3bnph?=
 =?utf-8?B?RDBqVzhOTWRvZHdMQ2poRlpFSE1DYm8xZHNoaW5oTW9DaWhhM2k0aEV5a3Ux?=
 =?utf-8?B?QzdKOS9uR2R5SlNNcUtqbGttQTdkT3lLMFJBeUhnbXpQK3BxV0E2dkxzMFVQ?=
 =?utf-8?B?RE9KTDZkMDFmbFJEU1o0dnliZjd6QklGbHZIR2x3VDNtcU5kL2trMnd1M09y?=
 =?utf-8?Q?2SV4AAUbVxVwROKzJV1H2eFnt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E540255C856FBA47BB80DA9151C447B2@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c27d34f0-30f8-4edf-7b68-08dcfd862788
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 10:39:41.0155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LCMe+WSIkcAd0OZybNjPzmmj3c7pNp8KydhejVAg5aL1n1F/4rtJEd3vEPjMYSgueUmn89qcJFSL6boVHQCxmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6175

T24gTW9uLCAyMDI0LTExLTA0IGF0IDA5OjQ1IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvNC8yNCAwOToyMiwgU2hhaCwgQW1pdCB3cm90ZToNCj4gPiA+IEkgdGhpbmsgeW91J3Jl
IHdyb25nLsKgIFdlIGNhbid0IGRlcGVuZCBvbiBFUkFQUyBmb3IgdGhpcy7CoCBMaW51eCANCj4g
PiA+IGRvZXNuJ3QgZmx1c2ggdGhlIFRMQiBvbiBjb250ZXh0IHN3aXRjaGVzIHdoZW4gUENJRHMg
YXJlIGluIHBsYXkuDQo+ID4gPiBUaHVzLCBFUkFQUyB3b24ndCBmbHVzaCB0aGUgUlNCIGFuZCB3
aWxsIGxlYXZlIGJhZCBzdGF0ZSBpbiB0aGVyZQ0KPiA+ID4gYW5kIHdpbGwgbGVhdmUgdGhlIHN5
c3RlbSB2dWxuZXJhYmxlLg0KPiA+ID4gDQo+ID4gPiBPciB3aGF0IGFtIEkgbWlzc2luZz8NCj4g
PiBJIGp1c3QgcmVjZWl2ZWQgY29uZmlybWF0aW9uIGZyb20gb3VyIGhhcmR3YXJlIGVuZ2luZWVy
cyBvbiB0aGlzDQo+ID4gdG9vOg0KPiA+IA0KPiA+IDEuIHRoZSBSU0IgaXMgZmx1c2hlZCB3aGVu
IENSMyBpcyB1cGRhdGVkDQo+ID4gMi4gdGhlIFJTQiBpcyBmbHVzaGVkIHdoZW4gSU5WUENJRCBp
cyBpc3N1ZWQgKGV4Y2VwdCB0eXBlIDAgLQ0KPiA+IHNpbmdsZQ0KPiA+IGFkZHJlc3MpLg0KPiA+
IA0KPiA+IEkgZGlkbid0IG1lbnRpb24gMS4gc28gZmFyLCB3aGljaCBsZWQgdG8geW91ciBxdWVz
dGlvbiwgcmlnaHQ/wqAgDQo+IA0KPiBOb3Qgb25seSBkaWQgeW91IG5vdCBtZW50aW9uIGl0LCB5
b3Ugc2FpZCBzb21ldGhpbmcgX2NvbXBsZXRlbHlfDQo+IGRpZmZlcmVudC7CoCBTbywgd2hlcmUg
dGhlIGRvY3VtZW50YXRpb24gZm9yIHRoaXMgdGhpbmc/wqAgSSBkdWcNCj4gdGhyb3VnaA0KPiB0
aGUgNTcyMzAgLnppcCBmaWxlIGFuZCBJIHNlZSB0aGUgQ1BVSUQgYml0Og0KPiANCj4gCTI0IEVS
QVBTLiBSZWFkLW9ubHkuIFJlc2V0OiAxLiBJbmRpY2F0ZXMgc3VwcG9ydCBmb3INCj4gZW5oYW5j
ZWQNCj4gCQnCoCByZXR1cm4gYWRkcmVzcyBwcmVkaWN0b3Igc2VjdXJpdHkuDQo+IA0KPiBidXQg
bm90aGluZyB0ZWxsaW5nIHVzIGhvdyBpdCB3b3Jrcy4NCg0KSSdtIGV4cGVjdGluZyB0aGUgQVBN
IHVwZGF0ZSBjb21lIG91dCBzb29uLCBidXQgSSBoYXZlIHB1dCB0b2dldGhlcg0KDQpodHRwczov
L2FtaXRzaGFoLm5ldC8yMDI0LzExL2VyYXBzLXJlZHVjZXMtc29mdHdhcmUtdGF4LWZvci1oYXJk
d2FyZS1idWdzLw0KDQpiYXNlZCBvbiBpbmZvcm1hdGlvbiBJIGhhdmUuICBJIHRoaW5rIGl0J3Mg
bW9zdGx5IGNvbnNpc3RlbnQgd2l0aCB3aGF0DQpJJ3ZlIHNhaWQgc28gZmFyIC0gd2l0aCB0aGUg
ZXhjZXB0aW9uIG9mIHRoZSBtb3YtQ1IzIGZsdXNoIG9ubHkNCmNvbmZpcm1lZCB5ZXN0ZXJkYXku
DQoNCj4gPiBEb2VzIHRoaXMgbm93IGNvdmVyIGFsbCB0aGUgY2FzZXM/DQo+IA0KPiBOb3BlLCBp
dCdzIHdvcnNlIHRoYW4gSSB0aG91Z2h0LsKgIExvb2sgYXQ6DQo+IA0KPiA+IFNZTV9GVU5DX1NU
QVJUKF9fc3dpdGNoX3RvX2FzbSkNCj4gLi4uDQo+ID4gwqDCoMKgwqDCoMKgwqAgRklMTF9SRVRV
Uk5fQlVGRkVSICVyMTIsIFJTQl9DTEVBUl9MT09QUywNCj4gPiBYODZfRkVBVFVSRV9SU0JfQ1RY
U1cNCj4gDQo+IHdoaWNoIGRvZXMgdGhlIFJTQiBmaWxsIGF0IHRoZSBzYW1lIHRpbWUgaXQgc3dp
dGNoZXMgUlNQLg0KPiANCj4gU28gd2UgZmVlbCB0aGUgbmVlZCB0byBmbHVzaCB0aGUgUlNCIG9u
ICpBTEwqIHRhc2sgc3dpdGNoZXMuwqAgVGhhdA0KPiBpbmNsdWRlcyBzd2l0Y2hlcyBiZXR3ZWVu
IHRocmVhZHMgaW4gYSBwcm9jZXNzICpBTkQqIHN3aXRjaGVzIG92ZXIgdG8NCj4ga2VybmVsIHRo
cmVhZHMgZnJvbSB1c2VyIG9uZXMuDQoNCihzaW5jZSB0aGVzZSBjYXNlcyBhcmUgdGhlIHNhbWUg
YXMgdGhvc2UgbGlzdGVkIGJlbG93LCBJJ2xsIG9ubHkgcmVwbHkNCmluIG9uZSBwbGFjZSkNCg0K
PiBTbywgSSdsbCBmbGlwIHRoaXMgYmFjayBhcm91bmQuwqAgVG9kYXksIFg4Nl9GRUFUVVJFX1JT
Ql9DVFhTVyB6YXBzDQo+IHRoZQ0KPiBSU0Igd2hlbmV2ZXIgUlNQIGlzIHVwZGF0ZWQgdG8gYSBu
ZXcgdGFzayBzdGFjay7CoCBQbGVhc2UgY29udmluY2UgbWUNCj4gdGhhdCBFUkFQUyBwcm92aWRl
cyBzdXBlcmlvciBjb3ZlcmFnZSBvciBpcyB1bm5lY2Vzc2FyeSBpbiBhbGwgdGhlDQo+IHBvc3Np
YmxlIGNvbWJpbmF0aW9ucyBzd2l0Y2hpbmcgYmV0d2VlbjoNCj4gDQo+IAlkaWZmZXJlbnQgdGhy
ZWFkLCBzYW1lIG1tDQoNClRoaXMgY2FzZSBpcyB0aGUgc2FtZSB1c2Vyc3BhY2UgcHJvY2VzcyB3
aXRoIHZhbGlkIGFkZHJlc3NlcyBpbiB0aGUgUlNCDQpmb3IgdGhhdCBwcm9jZXNzLiAgQW4gaW52
YWxpZCBzcGVjdWxhdGlvbiBpc24ndCBzZWN1cml0eSBzZW5zaXRpdmUsDQpqdXN0IGEgbWlzcHJl
ZGljdGlvbiB0aGF0IHdvbid0IGJlIHJldGlyZWQuICBTbyB3ZSBhcmUgZ29vZCBoZXJlLg0KDQo+
CXVzZXI9Pmtlcm5lbCwgc2FtZSBtbQ0KPglrZXJuZWw9PnVzZXIsIHNhbWUgbW0NCg0KdXNlci1r
ZXJuZWwgaXMgcHJvdGVjdGVkIHdpdGggU01FUC4gIEFsc28sIHdlIGRvbid0IGNhbGwNCkZJTExf
UkVUVVJOX0JVRkZFUiBmb3IgdGhlc2Ugc3dpdGNoZXM/DQoNCj4gCWRpZmZlcmVudCBtbSAod2Ug
YWxyZWFkeSBjb3ZlcmVkIHRoaXMpDQo+IA0KPiBCZWNhdXNlIHNldmVyYWwgb2YgdGhvc2Ugc3dp
dGNoZXMgY2FuIGhhcHBlbiB3aXRob3V0IGEgQ1IzIHdyaXRlIG9yDQo+IElOVlBDSUQuDQoNCg0K
KHRoYXQgY292ZXJzIGFsbCBvZiB0aGVtIElJUkMpDQoNCgkJQW1pdA0K

