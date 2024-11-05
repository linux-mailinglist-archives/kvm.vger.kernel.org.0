Return-Path: <kvm+bounces-30750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 129159BD245
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9729F1F2311C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E03F1D9677;
	Tue,  5 Nov 2024 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ebeBpK7v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD5762D2;
	Tue,  5 Nov 2024 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823913; cv=fail; b=gvoCKYnyFsuf+4BlRaF2kREl69gRByIsFWn6ivCzOHCu+w97ka9dY5z7eW1iZvSi528YaD12sHAIXKZBopcRF4feHmkDTkBp6OY2cnnRLf9gp1OIA0JG+wg+AgA12ZCsTQwUqhmzIq9/sVkwfuk/gSqnLZdum2QDcryPOwnz7pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823913; c=relaxed/simple;
	bh=Zs+yfx2SSjVmWng0MD0rz1GJxpfcbz3CjAy8sOZYeuw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T9ccQ8X21VDsQZT4XTWOkva+gEjUKCtpCf7Fssb4LqMBFAoxkBYH4rn0FFRE4DiavKNxfQoiKL9oOUzQb5o/O2HiNmsceMYL6HlBJXEuPv7qmH9bszkVrMQn52l/yYHkiap5KTMeuRu9ArMOC9/kbfnEC4/PDeVzI4dQZBy7SHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ebeBpK7v; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LiU79+etX6ZYz8M/40XFEgrEy7vNmEpcN5mH+ZFqJ4M4nFhBNUw8RawLGtlKveuT3Nfkl5f3mhzRayW+8UZeIkzWtMtluxoudeY5PFfT7neC5aR/JQdKM2RApENSlqO6cTAAJCxIPuUoJaxAAnF6MEsm0Pd3kvSCflcO2G8CDYreMoacsJmYVGRb9goVQKH50Pi6QZ1DyjXU/qvX65w98NinPHe68E29x6aVsBat/8MnWjYZ86eksoXp8IS52jJ6V3YlFEogSWNgpolkTJNB0Yx+w0WsUqq7rT7ZeuCEYCVihklrStkpt851MFO3KjkMoQL/VU02u74P4WqYJ4s37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zs+yfx2SSjVmWng0MD0rz1GJxpfcbz3CjAy8sOZYeuw=;
 b=Tpm9SX3IxQ3Z3ZPuLs2WfvZZqsrSkqDZX2vAM2N8QtFRfHYzTnlnfjODqy4IHDgRyxtnNyW+d0mjQHbF5IRPWWHU8ue6Au+DcIxujZ5KtFEMCWHTJXD9QCjkEdiblykxFgI/IILzLUKUnBeA3usZP2eg+1r03HQxWqMQRYGRD6Q+8et9O4IU+mdsUrZ1kL24g0tGULT+6sULpVsimX+zfaSgIx1y1ldQYuG5GUUD0b2+43gBOLo6KIU1nvTL7LSxcM8qZaxWOyTCLMpSM9D29sbgw8oTkYItG8RXpbE1s87RoFhJ66trW7xQMxeWB0gDrxLat33N8fFat3T/dK4ocQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs+yfx2SSjVmWng0MD0rz1GJxpfcbz3CjAy8sOZYeuw=;
 b=ebeBpK7vNw5CHlJ0rlrRcl5NiEnVPfJk3aiVUqoCN4QwTsz9RAkD+ajW8geWJH8bMEvFphWL+Ypdtk7gzaBzKpkMHJSgF37FwSdpx3NCmO5Ay7jlk1b9q3BVI+SjgRx8+1lT1wZQqasFWtKgeMxfbr8mM4fAdJEVS5ff9NWCjlA=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by DS7PR12MB6333.namprd12.prod.outlook.com (2603:10b6:8:96::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 16:25:07 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 16:25:07 +0000
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
 AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhfTCAgAVa8wCAAHjUAIAAAJqAgAADwgCAAA9+gIAABmUAgAEbeYCAAF71gIAAAY8A
Date: Tue, 5 Nov 2024 16:25:07 +0000
Message-ID: <97f499912538a81f06936ff02e8236bb01a82ae8.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
	 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
	 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
	 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
	 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
	 <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
	 <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
	 <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
	 <a296a079-fec6-42d7-82fe-b1b7e9004230@intel.com>
In-Reply-To: <a296a079-fec6-42d7-82fe-b1b7e9004230@intel.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|DS7PR12MB6333:EE_
x-ms-office365-filtering-correlation-id: 373eb63c-6427-43db-3581-08dcfdb66953
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bmpjd0ZLRnNzdlRzYzEybzRvWXlWSGQwR3l3R0lzZFRUVGhjOTJpZWZ1SGhE?=
 =?utf-8?B?aXgyQVk4bmgyeTlZSU9iREVIRkJZZ0tIMURLREhZbDI2czdlZG1hV3B6bno2?=
 =?utf-8?B?UEh6R1Y5ejFjQ3ZmckxTZkpuUnE4N0VhR2kzV3FFd1pNYnpqVlI4d28xdjZx?=
 =?utf-8?B?SUhiSkFSUVJpb0lhUU5MM2txQ2d4KzQrREI4d3g3RFErVk1qZVkwWVBGUGp4?=
 =?utf-8?B?L2FYMU0wUk1ERW9zaThlVGZ6cnlTdWUrY1lqcVRHMVBtbE9nakhDckFrT3hQ?=
 =?utf-8?B?dEtpQ3liTkxOeGtpUFlWREU2N2RITi9pZC9wdU9OZE04WFlNaXFqMGxiMlV0?=
 =?utf-8?B?RTVsVEN2OEEzODlJa3V4b2Q0UXc4bjNPdG0rZ01tYjJEYi9NdEVyR0E0aDZh?=
 =?utf-8?B?YW1DUndxcXJVQXJhUGlWYU8wVnR4bEQ1NWIxUlBUMmNkOWhIaTZrbGVrOVlI?=
 =?utf-8?B?RUxRSmQrTGhjSmkxOXJ5cUtCamxzSTFWSjBRQ3ZVTk94YVl3ZkxENy9xdGo4?=
 =?utf-8?B?Z1NsNkZVV2tPR05XZmpneG93czRIS2t1YUdUSldVZUc5M0N3Z1krL0M5akFV?=
 =?utf-8?B?K0xWa2hQVm9GYXdOV09zMW9ydElPeVRuSVV1STJTa0xUbnA3T0xaR0Vna2ha?=
 =?utf-8?B?K0pxQ3l3ZUhhM2NDUTJxem5TajJiSU4yQTJsR3Q3L0RKVHlXNnBFK1RuY3BQ?=
 =?utf-8?B?UlBFenliKzRrWTJLQ3FFTmJZNkE3Nkdad3VUSDVHOXZxelBhcVRyclkzSTR3?=
 =?utf-8?B?aUNFUUJMdHZObHZDMGJnSk5RTGVtV3FQUG9BQXI5SGJkOElvTFFRTGlwaENp?=
 =?utf-8?B?azlTTFM2cnJhem1LWGNzWG9pR29yR01JSVR4aWFNVGV3eVdVUGJwNmRxRGND?=
 =?utf-8?B?QmltVFN3eWhUT0p2U0lScERSSEIrdDA0QTlwOWVBUWtTcnQ3UFBKY3hQMUcw?=
 =?utf-8?B?UEZQYXUvSUgxMUJxaENzNFBSSzQ1LzRMSmEyQUdLMjd3aDM5NU0xOEhZWmVJ?=
 =?utf-8?B?aCtTd1VVTmlPbm1NSExET2lGa014cmVZNWZtamhxeUMvUC9Ocm1FdDBMM3BI?=
 =?utf-8?B?MmVPdWxwQXdESFJrK2hXQXBIMWZOMjd2dUxpQkhIdG10eUpjb3htenhGMy9Y?=
 =?utf-8?B?Q2xZaXF6WFkrMjhOYnhmNjh5NlovOHdMQm1lNS9DSnNmRVRMczJFY2JsQWJT?=
 =?utf-8?B?VXFaVEtENGJFcnVHZVRFWk0rQ1RxeUpudTZVYUx0a01UMVhNUGh6c3phdVFT?=
 =?utf-8?B?ekFxbHJkTjRwaGR2d0JxQWpudTBpNGdZZGF3dlNSNkRjY0MyN05NZ25YQUtl?=
 =?utf-8?B?MlY1VlJBN3B4U0FjcGhPTEdKdmF4Zm1mSm5mbWtSNEdKWmtNNyt5OWt4bkY2?=
 =?utf-8?B?T0QrREJoSEhoWExGcEp1Zi9UVmpURkVyR0JlZHlIWVVmRUVQYTZSU2Nxd1lU?=
 =?utf-8?B?YjZqWkVqbjVXQktPTWU5Vk93UStFV1hyQ3ZZdkxnOGp4a1RLQVNnb1k2OVAw?=
 =?utf-8?B?cERDdWlRWEl3amgwMnExZEpSODRjRlhwM1U0cGVobk9vVVJUM2ozZVgweXpW?=
 =?utf-8?B?UTJXc2ZuaVRIVjdWRGs3YmkyM1E0UVpuY1ltNTJhSEt3dFhKUHNrZ1BnUlc5?=
 =?utf-8?B?UWRMSlFaemdNZktNYlMrQzBKTUZzQmEzZWRJVW13cGdZZ21HYm1wK1JhZmlD?=
 =?utf-8?B?a0hKZ1dKQldlZko3MlhHVnZONG5BUlVob2dZTFNrVXIzd0pNMFA5QStpdHha?=
 =?utf-8?Q?c4yOPkbrXKwsOFsVhhEyOTCroTX5EBxLOtmkzVQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2RvajdRanlSMzlRL3RITzdReEIxOUx1L0ZvekcwUjRwdzRaNGl1VXIzd2dQ?=
 =?utf-8?B?dllkQnpZY25iVG03UnRTRHI0WDdZSGRWK0l6K1BmSDNEN0thdDN4bmxNSzhp?=
 =?utf-8?B?K1BTWEFwUy9QaUh0S2NiZnN0ZmJkeDFUVmhFZ0NRZndhTmIweDl5cDU3ZFJE?=
 =?utf-8?B?UWZCZ21OVS9vKy9wd3N0N25NTXIrOGxYWVhqMU1jMkxOdXhxL1pIZ3E0cWNF?=
 =?utf-8?B?Q3duTjVqQ01jQ1lCNVREVXZtZW9sbWtEYWJVWlErMktNTExFL3JsWHIvcGJY?=
 =?utf-8?B?WEZLL0JvaGxXZ2h6V2s0d0lUMGxWbk1ZZnNERTF2aEVjNjZYa3dNcnRJa2pB?=
 =?utf-8?B?OEVEc0NReHVxVEppZFBaQUJiY29HLzIxd0sxN2lOeXlJdEdmNU1YRGw4MWN0?=
 =?utf-8?B?SWRLMTlKUzZhTHZvVm1UWVRES2lmQXlsWFozL1JYUEREYVh2bU8zVGgxU2dx?=
 =?utf-8?B?eWY3bmFjMnZLMVZNalBCNmFkdFlCZ05EYVlRR3ZMM2NaOXVwdmpQY3pVWFg3?=
 =?utf-8?B?R1ZZckFTTnlrVm5xclpobjMya2JPL0FQbHBzTGYxekpBenJIWnBJT0Y2b0JF?=
 =?utf-8?B?MjBQSG1FT2dZN2w4aVFzdHhwTEZlamFhb0JrRmpoa1MwNHYwMG42YWxiMlFC?=
 =?utf-8?B?WEJ2clFmVE5NdTVTYjVPckhxUjlKb0dsRVFYeWt3Z2p1WWtsRThiemtzU0d4?=
 =?utf-8?B?MkowaEJnbGlEYW12YmlvaW1Bck81d0hObGRjYXpIV08rVEVwdWVNc3FmOE9P?=
 =?utf-8?B?K0pJQzNWSlQxanFHS2FpM1EvdU5hRnlIT2REdXM2U1czUWpyNkxkbnQxS0FH?=
 =?utf-8?B?eGRSeFh1cVFGaTAzWlN0alZhTU1KNHpWQ0Rqd3lNcEVWa2ZpNFI1ZDJKWExx?=
 =?utf-8?B?VmlXWVN5MnZrdTlJaUFmcklQR09ncENFUkkvSzg0OGpiNlhzNGtzRUlNZXda?=
 =?utf-8?B?dld3emJwQVFQMDFsb0xUajBIeC9QMjlXcEhOSzFBckgyZ2FZZjBha2JIdDNL?=
 =?utf-8?B?MWtWR05ES2Q1S0NiNXNlVUdJTXNSbU5RVllleGhzdjFGYzRicTJUSVdFNWt6?=
 =?utf-8?B?Nnh1TTNMdWFJbTB6S2ZKYnFjZDhGeWU1c1EwVU9EK0hnL055ajh3cEZxM0Rh?=
 =?utf-8?B?UTIwak1EWjBjOXY5SXRFN0tpaTV0R2FtK0V0cXBHZStOTTVFRXI0cjNTMFBo?=
 =?utf-8?B?N29SOWRmOHV4dEJ5OUk3R2RFczhJcTJFcEdjKzFaaHR4Yjdnc01IaDBUeU1j?=
 =?utf-8?B?dFNGQ1N2cGRZdzhWWEthalloVklLR1I4YnZaZzlldmlBUlpPU0Q2cExXNW9Z?=
 =?utf-8?B?V1Zndnp4T29oZ29uNnVOdWgwYngxRlhIZkJoRHlEY1RhbTNvb2hlSE10RGRJ?=
 =?utf-8?B?c1gxSWF3RVFuVDM5Q3VDSHNLUkJxOWZvVVZ4VXk0cms3V3J3elJyQjdGNVNR?=
 =?utf-8?B?bWlDU2ljR3NKNUtvQ0FIK3NaVDRMWnV6Vk5lUEpOMVdEZmtXOGFiNU5jQTNG?=
 =?utf-8?B?VXlpMTlCNW01aTc4Tm4rTXkxUHRrdkI4RUFINUZFeitzUUprT3hGc2l3V3Jt?=
 =?utf-8?B?Z01JVDk1THZpczlmWWorQURoT1hnSkV2a2gwVWVFSnFIRG91aXBlczVIQkNv?=
 =?utf-8?B?OFVzUFdUSUh0bTB3TWlnSVJnVnF5Rzk3Um1udVFjTWM2ajU3S3NsYVd6cGNW?=
 =?utf-8?B?OVpReXVmNTZNMWtTQ3lzZ0RUQXlXOHVZSmxzbjdXRVYzNXdXWnFjYXJEZzhJ?=
 =?utf-8?B?dXFSd1N3QktnVGV0dFZXZVhSQ3B0ZmRTdUpkSmEwNFhHTlpEdlExOWVweCtp?=
 =?utf-8?B?ZVE5dDQ0Qk9lSmt6aVdjQnBkQ1BWRm5lREhEZ1QyRXdnSU9QWVpoZmFzUGRa?=
 =?utf-8?B?MDltOCtnQnRVNE95bE9wVDZxYi9nU0czNERLZmlnQ2k3UU5pc1QrdEtONlZ4?=
 =?utf-8?B?K3pOSDRVYzhyZ2VtVmJ5K0kySzUwOVhaNmNEenMwbU5pSVlVS3Zkdm5LUE1v?=
 =?utf-8?B?ZkJjZnhRRHMyenN1Wi96NC82LzZQSzQ1ay9KUFNNSUVpdjVjY2RnNTRHbDg4?=
 =?utf-8?B?VS83MjNucEdLc3hYRzdPc3hYa0tuNFphSXd6NzZXV1JsQW1RN1VWaUVOd0dm?=
 =?utf-8?Q?d4R3qAipPgBKZ/j4VkLtTakS5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF149BA0A867A34CBA7B9E5021C2568E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 373eb63c-6427-43db-3581-08dcfdb66953
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 16:25:07.2165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9tj7d5PaTvC03vG5G/xHHF2Yh8N8xhmYLShopTZ4E5U6gcZesRw9FlfxUii+E/HFEQaNkf2LfKJwmKp7PiDchQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6333

T24gVHVlLCAyMDI0LTExLTA1IGF0IDA4OjE5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvNS8yNCAwMjozOSwgU2hhaCwgQW1pdCB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjQtMTEt
MDQgYXQgMDk6NDUgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+IEknbSBleHBlY3Rpbmcg
dGhlIEFQTSB1cGRhdGUgY29tZSBvdXQgc29vbiwgYnV0IEkgaGF2ZSBwdXQgdG9nZXRoZXINCj4g
PiANCj4gPiBodHRwczovL2FtaXRzaGFoLm5ldC8yMDI0LzExL2VyYXBzLXJlZHVjZXMtc29mdHdh
cmUtdGF4LWZvci1oYXJkd2FyZS1idWdzLw0KPiA+IA0KPiA+IGJhc2VkIG9uIGluZm9ybWF0aW9u
IEkgaGF2ZS7CoCBJIHRoaW5rIGl0J3MgbW9zdGx5IGNvbnNpc3RlbnQgd2l0aA0KPiA+IHdoYXQN
Cj4gPiBJJ3ZlIHNhaWQgc28gZmFyIC0gd2l0aCB0aGUgZXhjZXB0aW9uIG9mIHRoZSBtb3YtQ1Iz
IGZsdXNoIG9ubHkNCj4gPiBjb25maXJtZWQgeWVzdGVyZGF5Lg0KPiANCj4gVGhhdCdzIGJldHRl
ci7CoCBCdXQgeW91ciBvcmlnaW5hbCBjb3ZlciBsZXR0ZXIgZGlkIHNheToNCj4gDQo+IAlGZWF0
dXJlIGRvY3VtZW50ZWQgaW4gQU1EIFBQUiA1NzIzOC4NCj4gDQo+IHdoaWNoIGlzIHRlY2huaWNh
bGx5IHRydWUgYmVjYXVzZSB0aGUgX2JpdF8gaXMgZGVmaW5lZC7CoCBCdXQgaXQncw0KPiBmYXIs
DQo+IGZhciBmcm9tIGJlaW5nIHN1ZmZpY2llbnRseSBkb2N1bWVudGVkIGZvciBMaW51eCB0byBh
Y3R1YWxseSB1c2UgaXQuDQoNClllYTsgYXBvbG9naWVzLg0KDQo+IENvdWxkIHdlIHBsZWFzZSBi
ZSBtb3JlIGNhcmVmdWwgYWJvdXQgdGhlc2UgaW4gdGhlIGZ1dHVyZT8NCj4gDQo+ID4gPiBTbywg
SSdsbCBmbGlwIHRoaXMgYmFjayBhcm91bmQuwqAgVG9kYXksIFg4Nl9GRUFUVVJFX1JTQl9DVFhT
Vw0KPiA+ID4gemFwcw0KPiA+ID4gdGhlDQo+ID4gPiBSU0Igd2hlbmV2ZXIgUlNQIGlzIHVwZGF0
ZWQgdG8gYSBuZXcgdGFzayBzdGFjay7CoCBQbGVhc2UgY29udmluY2UNCj4gPiA+IG1lDQo+ID4g
PiB0aGF0IEVSQVBTIHByb3ZpZGVzIHN1cGVyaW9yIGNvdmVyYWdlIG9yIGlzIHVubmVjZXNzYXJ5
IGluIGFsbA0KPiA+ID4gdGhlDQo+ID4gPiBwb3NzaWJsZSBjb21iaW5hdGlvbnMgc3dpdGNoaW5n
IGJldHdlZW46DQo+ID4gPiANCj4gPiA+IAlkaWZmZXJlbnQgdGhyZWFkLCBzYW1lIG1tDQo+ID4g
DQo+ID4gVGhpcyBjYXNlIGlzIHRoZSBzYW1lIHVzZXJzcGFjZSBwcm9jZXNzIHdpdGggdmFsaWQg
YWRkcmVzc2VzIGluIHRoZQ0KPiA+IFJTQg0KPiA+IGZvciB0aGF0IHByb2Nlc3MuwqAgQW4gaW52
YWxpZCBzcGVjdWxhdGlvbiBpc24ndCBzZWN1cml0eSBzZW5zaXRpdmUsDQo+ID4ganVzdCBhIG1p
c3ByZWRpY3Rpb24gdGhhdCB3b24ndCBiZSByZXRpcmVkLsKgIFNvIHdlIGFyZSBnb29kIGhlcmUu
DQo+IA0KPiBEb2VzIHRoYXQgbWF0Y2ggd2hhdCB0aGUgX19zd2l0Y2hfdG9fYXNtIGNvbW1lbnQg
c2F5cywgdGhvdWdoPw0KPiANCj4gPiDCoMKgwqDCoMKgwqDCoCAvKg0KPiA+IMKgwqDCoMKgwqDC
oMKgwqAgKiBXaGVuIHN3aXRjaGluZyBmcm9tIGEgc2hhbGxvd2VyIHRvIGEgZGVlcGVyIGNhbGwg
c3RhY2sNCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogdGhlIFJTQiBtYXkgZWl0aGVyIHVuZGVyZmxv
dyBvciB1c2UgZW50cmllcyBwb3B1bGF0ZWQNCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogd2l0aCB1
c2Vyc3BhY2UgYWRkcmVzc2VzLiBPbiBDUFVzIHdoZXJlIHRob3NlIGNvbmNlcm5zDQo+ID4gwqDC
oMKgwqDCoMKgwqDCoCAqIGV4aXN0LCBvdmVyd3JpdGUgdGhlIFJTQiB3aXRoIGVudHJpZXMgd2hp
Y2ggY2FwdHVyZQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBzcGVjdWxhdGl2ZSBleGVjdXRpb24g
dG8gcHJldmVudCBhdHRhY2suDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLw0KPiANCj4gSXQgaXMg
YWxzbyB0YWxraW5nIGp1c3QgYWJvdXQgY2FsbCBkZXB0aCwgbm90IGFib3V0IHNhbWUtYWRkcmVz
cy0NCj4gc3BhY2UNCj4gUlNCIGVudHJpZXMgYmVpbmcgaGFybWxlc3MuwqAgVGhhdCdzIGJlY2F1
c2UgdGhpcyBpcyBhbHNvIHRyeWluZyB0bw0KPiBhdm9pZA0KPiBoYXZpbmcgdGhlIGtlcm5lbCBj
b25zdW1lIGFueSB1c2VyLXBsYWNlZCBSU0IgZW50cmllcywgcmVnYXJkbGVzcyBvZg0KPiB3aGV0
aGVyIHRoZXkncmUgZnJvbSB0aGUgc2FtZSBtbSBvciBub3QuDQo+IA0KPiA+ID4gCXVzZXI9Pmtl
cm5lbCwgc2FtZSBtbQ0KPiA+ID4gCWtlcm5lbD0+dXNlciwgc2FtZSBtbQ0KPiA+IA0KPiA+IHVz
ZXIta2VybmVsIGlzIHByb3RlY3RlZCB3aXRoIFNNRVAuwqAgQWxzbywgd2UgZG9uJ3QgY2FsbA0K
PiA+IEZJTExfUkVUVVJOX0JVRkZFUiBmb3IgdGhlc2Ugc3dpdGNoZXM/DQo+IA0KPiBBbWl0LCBJ
J20gYmVnaW5uaW5nIHRvIGZlYXIgdGhhdCB5b3UgaGF2ZW4ndCBnb25lIGFuZCBsb29rZWQgYXQg
dGhlDQo+IHJlbGV2YW50IGNvZGUgaGVyZS7CoCBQbGVhc2UgZ28gbG9vayBhdA0KPiBTWU1fRlVO
Q19TVEFSVChfX3N3aXRjaF90b19hc20pDQo+IGluIGFyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlMu
wqAgSSBiZWxpZXZlIHRoaXMgY29kZSBpcyBjYWxsZWQgZm9yIGFsbA0KPiB0YXNrIHN3aXRjaGVz
LCBpbmNsdWRpbmcgc3dpdGNoaW5nIGZyb20gYSB1c2VyIHRhc2sgdG8gYSBrZXJuZWwNCj4gdGFz
ay7CoCBJDQo+IGFsc28gYmVsaWV2ZSB0aGF0IEZJTExfUkVUVVJOX0JVRkZFUiBpcyB1c2VkIHVu
Y29uZGl0aW9uYWxseSBmb3INCj4gZXZlcnkNCj4gX19zd2l0Y2hfdG9fYXNtIGNhbGwgKHdoZW4g
WDg2X0ZFQVRVUkVfUlNCX0NUWFNXIGlzIG9uIG9mIGNvdXJzZSkuDQo+IA0KPiBDb3VsZCB3ZSBw
bGVhc2Ugc3RhcnQgb3ZlciBvbiB0aGlzIHBhdGNoPw0KPiANCj4gTGV0J3MgZ2V0IHRoZSBFUkFQ
UytUTEItZmx1c2ggbm9uc2Vuc2Ugb3V0IG9mIHRoZSBrZXJuZWwgYW5kIGdldCB0aGUNCj4gY29t
bWl0IG1lc3NhZ2UgcmlnaHQuDQo+IA0KPiBUaGVuIGxldCdzIGdvIGZyb20gdGhlcmUuDQoNCkFs
cmlnaHQgLSB5b3UndmUgYmVlbiByZWFsbHkgcGF0aWVudCwgc28gdGhhbmtzIGZvciB0aGF0LiAg
SSBhZ3JlZSBJJ2xsDQpwb3N0IGEgdjIgd2l0aCB1cGRhdGVkIGNvbW1pdCBtZXNzYWdlcywgYW5k
IHRoZW4gY29udGludWUgdGhpcw0KZGlzY3Vzc2lvbiBvbiB1c2VyL2tlcm5lbCB0YXNrIHN3aXRj
aC4gIEFuZCBJJ2xsIGFsc28gYWRkIGFuIFJGQyB0YWcgdG8NCml0IHRvIGVuc3VyZSBpdCBkb2Vz
bid0IGdldCBwaWNrZWQgdXAuDQoNCgkJQW1pdA0K

