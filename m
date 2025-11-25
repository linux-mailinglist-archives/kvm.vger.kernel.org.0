Return-Path: <kvm+bounces-64505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DAEC8576C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0EE264E97B4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC9B326934;
	Tue, 25 Nov 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fnTvOD9O"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010066.outbound.protection.outlook.com [52.101.85.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327143019BE;
	Tue, 25 Nov 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764081678; cv=fail; b=Xq10YtVgw2qzB05HGFpa9YH82gIoEYEwGJBJrLC9qZqrhbb45zsKWEoV8ss7b8O4KVbuJ0dT1Vr7TkG8iRVcTWAVxOn7arjgsB+VxEdD5XlJ48+gjh6fJOPSGUyMrf0TvmHDT2wh0H2s+PdeHvGsXm95E0e8n5zJ/sAilE7i+lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764081678; c=relaxed/simple;
	bh=LfC0iWBm9C8S08oIlI3ib+igZQJ9MpUcrnoPe/UGpbw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RYIHPUB/swnaOsXh4tb0CfepQqBkKQeu9F9w6O1LEQA7USjfS5KYRvk3F4AUWyPf47Zp/rWZHVlF2UWHQh//vM8C1yQ/Cnh57hLDL2+3JQy7P/wAodZWUotk1ejlDvcKXyVe5D02nLmZ40vx4Yq4VA08Wa+vwOiploPsX3Ar6vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fnTvOD9O; arc=fail smtp.client-ip=52.101.85.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTFoe58iBw9XgbHeGZByJqvfyBgTQ3fLqwJXnNaB9BvtvkOnvIW6ucngas82mAgleg5AODjpe7XmV3/nKdWS1REVBvaYVo062yeWD9G4/O0khKFvQgsOiAs6Ppn42cyDPi+rM9+kTedT/13fLz63DcO1+725CSB6LowcJ594rEbGQIoCQV5MINjgDT2XOBHj98/Iz5gpCjI8ivT9644Ax7qDg1J8h2CDDknmyOUR5QOcZ2ssITVlMRkrutstqusKj9HVZ7pYBIg8MdGGpbYxoMnBSK5La3Cy9UmZ56TfGSPJkgHRjFrL4gjkGEfB9hNb45qp0v6lRhxz//kutWHR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfC0iWBm9C8S08oIlI3ib+igZQJ9MpUcrnoPe/UGpbw=;
 b=fr0pn9RxPboO2aep4dgizKfmI2zQdvJBEEPuSzRPQTL7zuf7w3TmmeJ0LJxldfDOGOFHd4TrHX2PQQqpZ8+PeyyLSFrOhEEoIl/xVEhOZ/w2ILllqrc451wf1rX3E0FPIO420jj1zSlIe6nLiHbkoCbt+OlLeGbcDUu/B8yeqkxJp7lRDejw73HPOIPrTr2coRMKCPC5a36hi671g9PSpyYDy0KA8En5oOTgXPmRfMLC2S5Sy6IzZPoX5C0pZxLwwDwx3xf2D4bKdds8o6oYY9rkpQPMayOeJeqCPRioSishabmlB4HoGoGGzGUy8LIHSRWsoVjDriAVQJcCkEt1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfC0iWBm9C8S08oIlI3ib+igZQJ9MpUcrnoPe/UGpbw=;
 b=fnTvOD9OodCAeA61NJWYnlRO3nMhL5uMJIRuVZcTauXaCbgzaYaGdHHMQ9Byrx4fJpasJhCs4eHK5dH0cirzTPMhMhVDZA7hY+x9nhQrKjRllgrwaVonltV8pStZDHp4cBPaoQ+uEjmWcOXVW7YFO5ikytvjQC5oq1XRDzTAs0g=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 14:41:13 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 14:41:13 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Topic: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Index: AQHcT8mMnd7JB9P6okicpWg0VkazobT8FAuAgAYHjoCAAAcAAIABcOgA
Date: Tue, 25 Nov 2025 14:41:12 +0000
Message-ID: <718b02d4cfa56a65cb2383a0e57ca988defc036b.camel@amd.com>
References: <20251107093239.67012-1-amit@kernel.org>
	 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
	 <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
	 <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com>
In-Reply-To: <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com>
Accept-Language: en-US, de-DE, en-DE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|SA0PR12MB7075:EE_
x-ms-office365-filtering-correlation-id: 5f979c12-a732-4857-b6b1-08de2c30ae8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?UFJobmNoaVdjaDlYYVdFM3NjQ0N0dnVWM0EzVGdYdERyZzFwOW83cVptVExy?=
 =?utf-8?B?dkJBRjcrVTl6MmdQNXdDRWJTLzl6bENIa2IyUnR6dkh5dkRuU0hwNkU4YmVH?=
 =?utf-8?B?QS9nWUJsUGZnT2hFRFZDYVZnNHU5SkNoM0xWWDkyc1BYdW42VW0rMTU0aFVv?=
 =?utf-8?B?MFUzKy9NOWtlL3JwNStNZVRZQVU2YjErelh2d201cU5iN1JGbXE3NjN1STlo?=
 =?utf-8?B?emJHTmFXSU9HckZ0cWhZZXlvQTRWWnF4c00zaDFYSyttUlljdXRQaDhLSTY2?=
 =?utf-8?B?L0VMd0hUSnJkV1Fra09wb3NQMGdaM0tWTnkwOWJabDdNWHhJT3J1ZGlTamYr?=
 =?utf-8?B?MmVWNSsxUncwQTAreUx4N3g1bG9Vdis2OU4xZDhXS2xBeFFwc3JpMG5JUGI1?=
 =?utf-8?B?dHQ1OXVTVjlOSjlvSTdabUNDZ0pJdUp1enJOazh1bzFpQ1RHSHArODl4RVNy?=
 =?utf-8?B?bGZwT3l4NXpCYzR6aU4rellDM2p1emhFc2o3Yy9KTm1vaXc4Y0x5QWhuT2My?=
 =?utf-8?B?dTd4U0gwSDhLMENDU3l3dmdXREpxbzdTcEpaZFBrY1dKNUFCTllGaktCZkxl?=
 =?utf-8?B?TzFITFRXWVFXLzJoV0lpcUxGZEpLcWtJeEN5L2hlVittYzh2QUtNeWxFeTJz?=
 =?utf-8?B?L0dEdWpYdWFFWFk1UkNOOEFZU3NMYk02Z0xlM2MwYnpJeHd3SWVzMEpvUkJq?=
 =?utf-8?B?TmtCeWZWVTBuTUZQMk82VXN4RGdERlFFQVRsZVY1QlhhVVQzcHhzYkpwQjdL?=
 =?utf-8?B?T1hlUnVsbmcrakgvNzBsdUQyOFJ1aEhlL0ZJcGw3a1FodFJyUDlwb1IxL2VM?=
 =?utf-8?B?andWVXBDeUNnc09zM1k4SC9lMFFRL0xLSU9iOVNwZnVBOGpSUzBDYTYyTWhG?=
 =?utf-8?B?L2pIclNNVEdtbWM0dlVNTmFVWnJRdEJvKzNUT1JJNUJFOEpqTThKeG5vL2hx?=
 =?utf-8?B?SnFNZnFSWG9iUWRlcUhNcGFLZGNEZnlCSkR1cVB0TGxwNzBvY29zQlpHRGNu?=
 =?utf-8?B?R3pEdzJDdlp2REhUbjVRWkt0ZjhHcm9paS91NlN3VHJoUmhOemR2b1hQejN5?=
 =?utf-8?B?QkFxcytKaThUWXBCTDRueFkzM3MzY01pemdUbTNMMEtSeFlZSVFwc2MxSUtO?=
 =?utf-8?B?dTcvYW1ZUHMybllpU1dGU1E0ZUpMWSszZlJ4SkpRWFozYVRDa0Fia3k3eDND?=
 =?utf-8?B?N3UvMzdtWCtndmVYa09tdXBHL2xmMVNpWlRUNVZIc0xtK3ZkaUdMOVRVYXZ3?=
 =?utf-8?B?UTVRU3VXbXVOV2ozTmJpWXdHbVdLRDNUY29ialJIZVJKdFIrL1ZRZ0R6RFFD?=
 =?utf-8?B?SzFsN3NwWnRvUHgvYTdmM2FvNmJ1dCtETUZqU3pCaXdPWndJbkhUMmlnM0Zw?=
 =?utf-8?B?SkpzUVd6Z2JhOW1uNHExbUJvQ0puQjN6bnJPbVhsTmFJZzJYMlE0eXBrYVZq?=
 =?utf-8?B?V2hEYitLUFZjNGg5MWgvR1FKUmF4eC9uNmJsTEgza0NLMW9pTTlsb1hQZHdD?=
 =?utf-8?B?ZmhXOFUyN29JZ25HUk9hSm1MNUZjTjlKWklrOFlDOE1qclM1S3pqMzFaaVJ6?=
 =?utf-8?B?SW1MaUR0bFVSSUpJLzN6d3Y3aDB5ZFN0ZFlzWWNReHkyZCtDNDdwNDUzYjlz?=
 =?utf-8?B?Y3BPTXUrT3lhbkh3QTFpczdZTHZpVDlUbmpTbTFCdXFTYXRNbDdkUHc2S0V6?=
 =?utf-8?B?YkE5QkNVdkFpYTJFQ0tZTkJzL1pSdXhoU01OdStCelVNMkRhRHcwWFhLcm9N?=
 =?utf-8?B?OU5QR1YraDZFaTJURVFubktMZ1M2SktaT01NM3BtbFIwT3ZuOEhyK1dEZ1RC?=
 =?utf-8?B?N3NtTTg0c0ZnbEx2V3d0Z2ladlRhMTZJanl1cnVxREdqNTd0YXBUN005YU42?=
 =?utf-8?B?Ym42OG1iYWtiZWREaXdPUEhyOXpDa1lyVnF4Mmh0R3phY2pLZ0xqeWd4SDdl?=
 =?utf-8?B?MDN2Vzg1ZzhwVVBvSDhUZTg5bXdMK3JxWUl3QXN6TThuaVhmZTNyejNpT2sx?=
 =?utf-8?B?NVRqZnF2TFBFcEtnanRndFdiUXp6Z05OL3crWkVTR255TXBkQms4M0FnQVhM?=
 =?utf-8?Q?JGlfmQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHpQeGF5SmxDd1dqaUFMUlA0N1M0bDJDVXNpVU04TSswSFF5OG1yTEpLL2hv?=
 =?utf-8?B?a1BqU3JUVElvNU8wTUwvaHpHNzZneXliL3JNOEp5ZWZ6VUtEZDhwaEVmanZs?=
 =?utf-8?B?RFF5U0h4NnNRZXdxZkNKdURWZlIxRTgxZTN4aE1ycUpndjFaMGZQK1k2NUtQ?=
 =?utf-8?B?T3ErVDJ2TnNIU2dKM0Vtb3dXYVprY0FUVFZwV2I5NjIyUkI3Y3B6WDd0b1Ir?=
 =?utf-8?B?V1dNWjVxRU4rM3BVcHB0QVY2UVJVanVqS3NHQy9mclB1dlFXY0ZwRE8wek42?=
 =?utf-8?B?ZGtBeG9ka3BjL3hhY1IwcE1pTG1rY0ZDMFB0MFhkMjBOOFVsUUVJazFQcDhk?=
 =?utf-8?B?OTRoY3IzbjdHQ1E1RXZXSzdLRU1ScmpkQjRBYTY0ZllIUTZCeVhHM3RUU1d5?=
 =?utf-8?B?V3BjU3Zzb3MreEQ5UURoNVdQTUxTcExOOWRzVlhveUJxbVQ5MVJmczJVUUdL?=
 =?utf-8?B?eDQwRkZzVytFSU02ME84NC8vU0hLTGY0aVErQ3REbm55L0pUd2wyZ29wY1lE?=
 =?utf-8?B?c0YvU3NHRFNHNkdIQ0Y4QWJNTTVzMTlScDQzNHJCWDhnRGVHTmtRUTF3OFZG?=
 =?utf-8?B?TVoySFQvT1ZUSTlmenR5TTZJc2R4SXI5T2dWK2lIa3cvUUVvUWFqYVMxdVdF?=
 =?utf-8?B?SHZwSzkxTU0yOHdKS0drdVRrTlo4Rk12eXg0R21YVkMwczhLck9pcDNDT2Nv?=
 =?utf-8?B?RWh0cUg3QU9vVnlFUUhkbXZEN3NTeEN2YjBONmZhZTVrSFFVZ2FDK1AyNzFy?=
 =?utf-8?B?RWxXODljT3Q2UFNrdXl6aFJuN1NZOVk4bUZBaGdWVHNLZkozZE9tdWw0L2lu?=
 =?utf-8?B?ZDgxN2NrMkdSZFBQRmtHV3dTVGZxSFZsZkUyb09LZ0ZHTXVhbUlOenlEdVZ2?=
 =?utf-8?B?L1ZheEdjZG12S2FnWVpDSzBmb0xUdCs0OTlGckNWd0lHelVCeHhLUXpQbzhp?=
 =?utf-8?B?RGVJVElGd0phS3JmQ053ckUrMWY5aGpyVXp5TXdiSUluN3ZNeldpY3pHRDVt?=
 =?utf-8?B?bXk3TGFoU2tVd3JPcFdSMUNXWDBJUU1vVWU1NGw3OXYrU3hKc2Vkb0hMOFda?=
 =?utf-8?B?ZlRmbXVmRXR6Ky9WVDBTZDZhRXo1QVlsMFZETFl0amVKNFVlaFdncE10S01x?=
 =?utf-8?B?OTlLMjVXZStxQUJ6L2QxajVMQkNRYlRZbGhzaWZseFlQa3NsZ2ROUkl3NDNC?=
 =?utf-8?B?ejA1dmwxQzF1YkRHTzQrcFBEOGlCZlFRNFowQ3JtVDR4NXZvaTNjUWdMc0ZN?=
 =?utf-8?B?WFNvcWpZYlFXcEVLeGRLTTRnblpSSldFN3V4NktNVC9pSUx2MVdCblJLWlY3?=
 =?utf-8?B?bXhxQmQ1bTRUSDNQQmVrWG5ZdWRVK2hIbHo0Z1FFWGpSYjdDQ1FNbEo5djk0?=
 =?utf-8?B?MldMVEVRZ0grcmpaR1ArR0JkZW1MVHZDVUJTOWdwc0xxc2hNZGFSd3hDZVpa?=
 =?utf-8?B?dlA5emRZeUt2V1RnQUhVMVZDSTB4UG9rM1RQZHBvOVB6QTlodUdPcmhTQnM2?=
 =?utf-8?B?Q3lzdzRGS1Z5NXF5UWRLck51bkMreUdMZXY3VHlGTWVpcE1aTlQ4MVAwYWtn?=
 =?utf-8?B?RXgrNXhyNUJ1VnkxemRkaUJkS3Fza3pJejJNS3p2c2l2MFFUaDI2eEdueWpw?=
 =?utf-8?B?WEpRa1RPUmVpVzNyU3VUZnJwVWhhbi9QcmtEZEZhVjJoT1dyZnMyVzNRd2dz?=
 =?utf-8?B?U3QyMGY2Ym4xS0s0R21yQm84WHRVVjV5bmF2RGRDbXl4VWcvcW0yaVNUQ0Uw?=
 =?utf-8?B?bXliNjBBWGthNjZZWlIyS1ZRNVNzY01yUVgxTHFJbVhIRGM2VGI1dWpRL2lM?=
 =?utf-8?B?VVVRdVRTMmVXeURwRGZEM0U0Wk1SUXNNT0g5UjVaeE1NclpKSnlVQ3VqY2Fi?=
 =?utf-8?B?MHNydHU4SVVjc09yOWlDZzBsdng1WFJPZG1Wb1U0UllDbG42akx4Um1wWUs0?=
 =?utf-8?B?Y1hva2gxelMxVDdVT2RDenJiUzJQVDFKb3IxUlVOcDJ4eUJvWHdFcklLSmlX?=
 =?utf-8?B?c3ZBMjJUU3VpUUFyUkRlRmpoSVA5YTIwNHN6cmhvRXBpeWlCOGU0cXVRdVE5?=
 =?utf-8?B?RUlLMDkzVlVRWXNFT0x5RmJ6RFd2MVNLeFlSdFVTc2J4Wi9oTUF1THFVQ293?=
 =?utf-8?Q?XFCg9r2FsLhn3KKnKD5L/ej7a?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A707E4B099D9E444B3B8F66DCB414243@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f979c12-a732-4857-b6b1-08de2c30ae8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 14:41:13.1613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVJTchWAtdwSn31vOM+lYckb5PJeSiCxC7Nrr0UilyTFdjFARgFGHnox/0betjRsR/FxiggS1O4ja7S038hdLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE2OjQwICswMDAwLCBBbmRyZXcgQ29vcGVyIHdyb3RlOg0K
PiBPbiAyNC8xMS8yMDI1IDQ6MTUgcG0sIFNoYWgsIEFtaXQgd3JvdGU6DQo+ID4gT24gVGh1LCAy
MDI1LTExLTIwIGF0IDEyOjExIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+
ID4gPiAyLiBIb3N0cyB0aGF0IGRpc2FibGUgTlBUOiB0aGUgRVJBUFMgZmVhdHVyZSBmbHVzaGVz
IHRoZSBSU0INCj4gPiA+ID4gZW50cmllcyBvbg0KPiA+ID4gPiDCoMKgIHNldmVyYWwgY29uZGl0
aW9ucywgaW5jbHVkaW5nIENSMyB1cGRhdGVzLsKgIEVtdWxhdGluZw0KPiA+ID4gPiBoYXJkd2Fy
ZQ0KPiA+ID4gPiDCoMKgIGJlaGF2aW91ciBvbiBSU0IgZmx1c2hlcyBpcyBub3Qgd29ydGggdGhl
IGVmZm9ydCBmb3IgTlBUPW9mZg0KPiA+ID4gPiBjYXNlLA0KPiA+ID4gPiDCoMKgIG5vciBpcyBp
dCB3b3J0aHdoaWxlIHRvIGVudW1lcmF0ZSBhbmQgZW11bGF0ZSBldmVyeSB0cmlnZ2VyDQo+ID4g
PiA+IHRoZQ0KPiA+ID4gPiDCoMKgIGhhcmR3YXJlIHVzZXMgdG8gZmx1c2ggUlNCIGVudHJpZXMu
wqAgSW5zdGVhZCBvZiBpZGVudGlmeWluZw0KPiA+ID4gPiBhbmQNCj4gPiA+ID4gwqDCoCByZXBs
aWNhdGluZyBSU0IgZmx1c2hlcyB0aGF0IGhhcmR3YXJlIHdvdWxkIGhhdmUgcGVyZm9ybWVkDQo+
ID4gPiA+IGhhZA0KPiA+ID4gPiBOUFQNCj4gPiA+ID4gwqDCoCBiZWVuIE9OLCBkbyBub3QgbGV0
IE5QVD1vZmYgVk1zIHVzZSB0aGUgRVJBUFMgZmVhdHVyZXMuDQo+ID4gPiBUaGUgZW11bGF0aW9u
IHJlcXVpcmVtZW50cyBhcmUgbm90IGxpbWl0ZWQgdG8gc2hhZG93IHBhZ2luZy7CoA0KPiA+ID4g
RnJvbQ0KPiA+ID4gdGhlIEFQTToNCj4gPiA+IA0KPiA+ID4gwqAgVGhlIEVSQVBTIGZlYXR1cmUg
ZWxpbWluYXRlcyB0aGUgbmVlZCB0byBleGVjdXRlIENBTEwNCj4gPiA+IGluc3RydWN0aW9ucw0K
PiA+ID4gdG8gY2xlYXINCj4gPiA+IMKgIHRoZSByZXR1cm4gYWRkcmVzcyBwcmVkaWN0b3IgaW4g
bW9zdCBjYXNlcy4gT24gcHJvY2Vzc29ycyB0aGF0DQo+ID4gPiBzdXBwb3J0IEVSQVBTLA0KPiA+
ID4gwqAgcmV0dXJuIGFkZHJlc3NlcyBmcm9tIENBTEwgaW5zdHJ1Y3Rpb25zIGV4ZWN1dGVkIGlu
IGhvc3QgbW9kZQ0KPiA+ID4gYXJlDQo+ID4gPiBub3QgdXNlZCBpbg0KPiA+ID4gwqAgZ3Vlc3Qg
bW9kZSwgYW5kIHZpY2UgdmVyc2EuIEFkZGl0aW9uYWxseSwgdGhlIHJldHVybiBhZGRyZXNzDQo+
ID4gPiBwcmVkaWN0b3IgaXMNCj4gPiA+IMKgIGNsZWFyZWQgaW4gYWxsIGNhc2VzIHdoZW4gdGhl
IFRMQiBpcyBpbXBsaWNpdGx5IGludmFsaWRhdGVkDQo+ID4gPiAoc2VlDQo+ID4gPiBTZWN0aW9u
IDUuNS4zIOKAnFRMQg0KPiA+ID4gwqAgXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4NCj4gPiA+IMKgIE1hbmFnZW1lbnQs4oCdIG9uIHBh
Z2UgMTU5KSBhbmQgaW4gdGhlIGZvbGxvd2luZyBjYXNlczoNCj4gPiA+IA0KPiA+ID4gwqAg4oCi
IE1PViBDUjMgaW5zdHJ1Y3Rpb24NCj4gPiA+IMKgIOKAoiBJTlZQQ0lEIG90aGVyIHRoYW4gc2lu
Z2xlIGFkZHJlc3MgaW52YWxpZGF0aW9uIChvcGVyYXRpb24NCj4gPiA+IHR5cGUgMCkNCj4gPiA+
IA0KPiA+ID4gWWVzLCBLVk0gb25seSBpbnRlcmNlcHRzIE1PViBDUjMgYW5kIElOVlBDSUQgd2hl
biBOUFQgaXMgZGlzYWJsZWQNCj4gPiA+IChvcg0KPiA+ID4gSU5WUENJRCBpcw0KPiA+ID4gdW5z
dXBwb3J0ZWQgcGVyIGd1ZXN0IENQVUlEKSwgYnV0IHRoYXQgaXMgYW4gaW1wbGVtZW50YXRpb24N
Cj4gPiA+IGRldGFpbCwNCj4gPiA+IHRoZSBpbnN0cnVjdGlvbnMNCj4gPiA+IGFyZSBzdGlsbCBy
ZWFjaGFibGUgdmlhIGVtdWxhdG9yLCBhbmQgS1ZNIG5lZWRzIHRvIGVtdWxhdGUNCj4gPiA+IGlt
cGxpY2l0DQo+ID4gPiBUTEIgZmx1c2gNCj4gPiA+IGJlaGF2aW9yLg0KPiA+ID4gDQo+ID4gPiBT
byBwdW50aW5nIG9uIGVtdWxhdGluZyBSQVAgY2xlYXJpbmcgYmVjYXVzZSBpdCdzIHRvbyBoYXJk
IGlzIG5vdA0KPiA+ID4gYW4NCj4gPiA+IG9wdGlvbi7CoCBBbmQNCj4gPiA+IEFGQUlDVCwgaXQn
cyBub3QgZXZlbiB0aGF0IGhhcmQuDQo+ID4gSSBkaWRuJ3QgbWVhbiBvbiBwdW50aW5nIGl0IGlu
IHRoZSAiaXQncyB0b28gaGFyZCIgc2Vuc2UsIGJ1dCBpbg0KPiA+IHRoZQ0KPiA+IHNlbnNlIHRo
YXQgd2UgZG9uJ3Qga25vdyBhbGwgdGhlIGRldGFpbHMgb2Ygd2hlbiBoYXJkd2FyZSBkZWNpZGVz
DQo+ID4gdG8gZG8NCj4gPiBhIGZsdXNoOyBhbmQgZXZlbiBpZiB0cmlnZ2VycyBhcmUgbWVudGlv
bmVkIGluIHRoaXMgQVBNIHRvZGF5LA0KPiA+IGZ1dHVyZQ0KPiA+IGNoYW5nZXMgdG8gbWljcm9j
b2RlIG9yIEFQTSBkb2NzIG1pZ2h0IHJldmVhbCBtb3JlIHRyaWdnZXJzIHRoYXQgd2UNCj4gPiBu
ZWVkIHRvIGVtdWxhdGUgYW5kIGFjY291bnQgZm9yLsKgIFRoZXJlJ3Mgbm8gd2F5IHRvIHRyYWNr
IHN1Y2gNCj4gPiBjaGFuZ2VzLA0KPiA+IHNvIG15IHRoaW5raW5nIGlzIHRoYXQgd2Ugc2hvdWxk
IGJlIGNvbnNlcnZhdGl2ZSBhbmQgbm90IGFzc3VtZQ0KPiA+IGFueXRoaW5nLg0KPiANCj4gQnV0
IHRoaXMgKmlzKiB0aGUgcHJvYmxlbS7CoCBUaGUgQVBNIHNheXMgdGhhdCBPU2VzIGNhbiBkZXBl
bmQgb24gdGhpcw0KPiBwcm9wZXJ0eSBmb3Igc2FmZXR5LCBhbmQgZG9lcyBub3QgcHJvdmlkZSBl
bm91Z2ggaW5mb3JtYXRpb24gZm9yDQo+IEh5cGVydmlzb3JzIHRvIG1ha2UgaXQgc2FmZS4NCg0K
VGhhdCdzIGNlcnRhaW5seSB0cnVlIC0gdGhhdCdzIGRyaXZpbmcgbXkgcmVsdWN0YW5jZSB0byBw
ZXJmb3JtIHRoZQ0KZW11bGF0aW9uIG9yIGluIGVuYWJsaW5nIGl0IGZvciBjYXNlcyB0aGF0IGFy
ZW4ndCBjb21wbGV0ZWx5IGNsZWFyLg0KDQo+IEVSQVBTIGlzIGEgYmFkIHNwZWMuwqAgSXQgc2hv
dWxkIG5vdCBoYXZlIGdvdHRlbiBvdXQgb2YgdGhlIGRvb3IuDQo+IA0KPiBBIGJldHRlciBzcGVj
IHdvdWxkIHNheSAiY2xlYXJzIHRoZSBSQVAgb24gYW55IE1PViB0byBDUjMiIGFuZA0KPiBub3Ro
aW5nIGVsc2UuDQo+IA0KPiBUaGUgZmFjdCB0aGF0IGl0IG1pZ2h0IGhhcHBlbiBtaWNyb2FyY2hp
dGVjdHVyYWxseSBpbiBvdGhlciBjYXNlcw0KPiBkb2Vzbid0IG1hdHRlcjsgd2hhdCBtYXR0ZXJz
IGlzIHdoYXQgT1NlcyBjYW4gYXJjaGl0ZWN0dXJhbGx5IGRlcGVuZA0KPiBvbiwNCj4gYW5kIHJp
Z2h0IG5vdyB0aGF0IHRoYXQgZXhwbGljaXRseSBpbmNsdWRlcyAidW5zcGVjaWZpZWQgY2FzZXMg
aW4gTkRBDQo+IGRvY3VtZW50cyIuDQoNClRvIGJlIGhvbmVzdCwgSSBoYXZlbid0IHNlZW4gdGhl
IG1lbnRpb24gb2YgdGhvc2UgdW5zcGVjaWZpZWQgY2FzZXMgb3INCk5EQSBkb2N1bWVudHMuDQoN
Ckhvd2V2ZXIsIGF0IGxlYXN0IGZvciB0aGUgY2FzZSBvZiBhbiBOUFQgZ3Vlc3QsIHRoZSBoeXBl
cnZpc29yIGRvZXMgbm90DQpuZWVkIHRvIGRvIGFueXRoaW5nIHNwZWNpYWwgKG90aGVyIHRoYW4g
aGFuZGxlIG5lc3RlZCBndWVzdHMgYXMgdGhpcw0KcGF0Y2ggZG9lcykuDQoNCgkJQW1pdA0K

