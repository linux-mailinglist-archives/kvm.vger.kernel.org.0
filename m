Return-Path: <kvm+bounces-45420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF795AA97A5
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FD19189AACA
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 15:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A854125E44D;
	Mon,  5 May 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GL9s2c+D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4587E1C1AB4;
	Mon,  5 May 2025 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746459626; cv=fail; b=OT9PrCyHtHdfNTcn04oHY9+39RbMlCmmOFmHVgmjW/3LWYACHbEaLDBiLBMxwKtfWc6nLyU0GIOzN0oFtyCzXXyiY41MtLyALf1WuI+mSlyN8DDlRQSDwEw4M105Opb3QTp/K5FJxfj20iwClkQtn1pxTTji8dolqQKyCDSZBCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746459626; c=relaxed/simple;
	bh=3MAcl7UOzy181vVbF6OmwJXI9XSSzu4FTu4sUpL+Ayo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DhPXrUt9wGKOzLl3rFuVzieR1vz1Ml5+qE3mbWjTRUgU0iKwMBJ74K5DPb0JorL2Yf9UtcaAEPhe38CdwFEIyAHVOtzMq5o4fvq438Jq6eorqDP+OjU/P5PsrEwQp/4b6ccSBBdWXpRyS3f4tgsxCO2J7xXK2iGJvnbT5SFoXtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GL9s2c+D; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5t3ar+597xA9EjXqSD4XqRU1YgaHmZJR1cuFabv+8O+lZrH8V2w0/WFCYggvgg9k9+P3xf0D6AdWZ7a7YFNkOaAhomkA2o1xjqrT/NmTCfsOs6vyCbhkwuDu6YfIb22DJFRNJI5pW5Yt3aQpmHSxjZS/FK7UTmLqlIyJgApZlnahsyJ3Tr5x63LjA44Z2rqtxbyW+XD+30cWoBYTg90hcRt/7QKCslIrCh2mzmTJx7KaH9j7iUTyoycBjVAmaThtNCzdmpbKbk3z1Cp3TbVjGM2mH7k/nLE+Rc8E+vqxZq5v/bHm7OW7gk8BeKA2eSnCdZYLQzCQjNapAoIdBjWlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MAcl7UOzy181vVbF6OmwJXI9XSSzu4FTu4sUpL+Ayo=;
 b=SJA6J99Ah5EKsbELee8SyyNNROK4V/WzicoJVJRcdYwYOmXlj+jkQMgNhwasrZG7Z4rxZF1JwIAij2S+uufVr4kPGr7vc67BLzpvkgwyN70mBnM0KqcHsOXLRDxPpleh9CXAHxaK1DwXBt0fxkd24TLOzXGeO6tar9FjCAYQzJn8AckTkZNJGfqLhmwIGTQ643Ce5hf28C6rQGJo6Sw/hspe3nxJQqMk5H1dzar6B/DjBbBA0sKvIh7m76M9/ey+kmUP+j+MWk6T0406WlDWdfd0RIY0OaHc0Wn+q/CfwTt67l4SvSOfw69oBhnyjP1qi5+IeoSI3TO0AFVPa22Q+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MAcl7UOzy181vVbF6OmwJXI9XSSzu4FTu4sUpL+Ayo=;
 b=GL9s2c+DuOV3PB47AcuiJG25zomqlyU8dYXMXF3hGTYhgKWO5AXuqvh8V8KX1ImGDJqPDZKz9AOq+CHi4xdUjBwvoAynCUqncpMTxAFE7dTVCGvr4PexRwrY28HjszvdFWyHuH7UQCPbWUNJhFeEx7453Xj0ZPH9JjMeiOEtr/A=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by SA1PR12MB5660.namprd12.prod.outlook.com (2603:10b6:806:238::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 15:40:20 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%3]) with mapi id 15.20.8699.024; Mon, 5 May 2025
 15:40:20 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
CC: Yosry Ahmed <yosry.ahmed@linux.dev>, Patrick Bellasi
	<derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf
	<jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>, Michael Larabel
	<Michael@michaellarabel.com>
Subject: RE: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Topic: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Index: AQHbuQpLRWo4+2NoWUeyEAzbBBOhObO83m2AgACS9QCAAJCSAIAGL9mAgAADC3A=
Date: Mon, 5 May 2025 15:40:20 +0000
Message-ID:
 <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local> <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com>
 <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
In-Reply-To: <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=865c605b-7b41-4a2d-bb5e-aefa95fbc5d4;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-05-05T15:36:26Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|SA1PR12MB5660:EE_
x-ms-office365-filtering-correlation-id: cd253f88-1848-4f7a-e881-08dd8beb24a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UjN2ZUZBNWJ4cDg4Zjd1NWpCTWJNU1hhcmkzRThQNnlNdGJUaDFNcENvRDlp?=
 =?utf-8?B?TityWXViUTBKWEw5N254L0xYelhJVWJ3RlIzcEFNNHIxQTlhcXVOd2tlbEU3?=
 =?utf-8?B?bCt5cTUvQlBENDBuV3dXUkFzMnk4UHplZ2JUZ1pINzhyclRxR0VxczN3OXFF?=
 =?utf-8?B?bE1NV1FsVHRtNmV3ZHJGUUpHd2RGM2pRMGNjSWdkMEhSUlRZTmhOdGwyVnB5?=
 =?utf-8?B?bXNleEFxWUcyWFVPdkFLNlNoUnRHbkFzZ2dJYlJET2s3UnN6aVM0MjRLV2Ur?=
 =?utf-8?B?b3FMSW9BN0w3NTNIenpCWHpmMnlPS29RdWIrSk1JV1pTc2ZhK21PcDZLUTY0?=
 =?utf-8?B?azJVTjY4V0F4NWo5aHZUOTlQcUhiUnZKdzdTT20rZXh1VTNpUWlZV2VEazRI?=
 =?utf-8?B?Z282NWpkZ2R2SmZhS0xiRW4yN1RnN0trTHg4TXA2cSszcE1Cdjl4RzFYZDlt?=
 =?utf-8?B?NFFEMjJiT3RmT0MxR1NWQm9FWWxmV2wzMTFVYmRuclV6SjVqY25UUUM4L1dh?=
 =?utf-8?B?ajF3Sjd0enBKa08vVllRUWc3ODc1L1gvalJpM0FHM0M0eERrVjJlUHpXaGYz?=
 =?utf-8?B?S0EyR0JVYS9jbkR6V2dRem1JK1RCTGc1eDc4UWRMZXpMVHdMTit2OWdZU05X?=
 =?utf-8?B?WmtwNmswY09jYlJYTldXSmNOUDZ4Sm1HendYSzFOKzhlNkFYdkhodlpGempT?=
 =?utf-8?B?Y082Qm9tTzVuK3c3Q3RMRlVFQm1OUVArRWVSV3pZRGxoU05Qc003bTlVZ0FM?=
 =?utf-8?B?NEgydWpXc3VxbUJPelpNOFpobytIUWhURXpST2toeUcvSjAyMDkwczRpSlNU?=
 =?utf-8?B?cEcrMUZlNGpscGVaR3JWYjV0L0ZiWUw5aXBXM1NRcmc3S2NoMGlqTXc2U0Rt?=
 =?utf-8?B?cFc1amtPbXBITmZ6L3NkTHo2NXUzMENpNEtIUFRyUkd3MUczaFN3aGNHeVJo?=
 =?utf-8?B?eTE2MjE3Lzd2aGozbHBZbnNxUlNjTWgxc0pMK3gvSVYzQ2xia255cjEzMi9o?=
 =?utf-8?B?OFJtM0hManZHMTVVL3Zudkg5bFZZSmxNWFN0QTEwQlQzT2RkRGE1RWFjbzNs?=
 =?utf-8?B?K3I2RXZSellVMy9iNDZway9semg0bG5kMEhGWXZaREkyQ2hKYnV1NE5JQms4?=
 =?utf-8?B?K3YzSFE4Ly95VXczUWN1ZDJjVUZsY3ZYdmhDejRFdEU0S3pTdG1KYm5QWmhB?=
 =?utf-8?B?eWxaNjIzS1d6UWVteUo4aXZlT1JaeHBDRVI5dklmYzUyMy8vWGo4a0NCL0Ro?=
 =?utf-8?B?aGtORFFaVVJsSDNUczhkcmlJQlI3c3NGSUJwUmRKenNsdS9KR1l2VC9wM2Qv?=
 =?utf-8?B?SlFuODRnOGRTUFIvVlAwNTVyOVdJK25pbjJoYzM5b29xTlc0b012TkVVRndr?=
 =?utf-8?B?aTMxTkZTWVE2YlJmZi9jNTcvUWpLeFVkVE84azYzUkNyS055K0FCMmNaVFgx?=
 =?utf-8?B?djlMR3NQMXBUK05uaGlqaTEvNElVQlc3am4vTkx4dDByMDNiSUl4aWpWWFdq?=
 =?utf-8?B?RmlYak5uRGxnbCtDMlJTYVc1bCs5S1VRQ0psUGlCNEt6L2EzTEFFaEVNanVW?=
 =?utf-8?B?dFZTK0dsaTFxbE5lVmhuWW5jWGdVd2NHQmw2ZzN5d3hOd3hZVjh6cFd6Y1F6?=
 =?utf-8?B?dkNoK2l2eThEL09DaTl6TkxCU3B0RytKaGtHSjlUSSsrNjNlM2tMWURDYXBa?=
 =?utf-8?B?cEdWNTRKU2I4NDFjamNYNnViK3RwVEE1QnVCSkE3NkZueWl4b1RUSDNWSUFw?=
 =?utf-8?B?M21JbDZndjFHaVpScHgvMEVTcm0vdmQ0d2pxcVR0cUVBcml2bVErSG1OMEo0?=
 =?utf-8?B?Q1dHcGpWcE5jclFGb2ZQSTFGQVdZLzNyVFhjaGpyVGdsaFA1VlJERHdjNXVU?=
 =?utf-8?B?S2V1VnZCeGIvSDJCRS9aZzRBUTFNS05vN0xsRGlCTkR1MXM0U0FZSlY5RzRD?=
 =?utf-8?B?WWFyc0lZTnN3ZWdEWWlEMDdmYk9aZ21SeGdMVWV1WmxKejN1d2V6MDUxeXRj?=
 =?utf-8?Q?yOISy8UjFyyTu4EySU5I/vwzcr0f0Q=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WW5FS2Q1cStDUUZnV3lHU1J6RnptRnh2cUsxNzFtOXVHWER2UVZ6V2cxZWNC?=
 =?utf-8?B?VGJSRVg1SG5qSmUxQnJyeWIzMW5LSmFiOHd5UVFHVEgveWNjTEQwWmxLVHFz?=
 =?utf-8?B?TjJKcStKa01sZ2Q4blRsdUdYYXRpam5QUHF1eEo0KzBuVlRpdDY4Q3JtSnlm?=
 =?utf-8?B?Q2o0bXVOZ1lBK1lsQjIzdC9RN1BUNGNoYmNpRUZNUmMzQjRScTcySG1sdnd3?=
 =?utf-8?B?ZGpsSnFlTjFTZ2RZYVErVG9McDhDcEpHN3d0YUd4TlJrSXFUdHpiNEpELzhu?=
 =?utf-8?B?ZW4xOHMzb1ZKTEk1cys4VFlGSUp1WFovdUlndzJnNVJxZE93My9WQ0J5ODFH?=
 =?utf-8?B?cWxuS1dPS2FNQ3FQeXNsUnYxcE9Gb3ZDSU1yTERSWHlwaXpkQXJGNDNQNUta?=
 =?utf-8?B?dWd0dE12NkxtVU40cEtvYlR0YTA1cVZydWI4RW5wZlZsM2Zqck4wWnJpb2ln?=
 =?utf-8?B?cU5XYXRmdy8vMDlBdzJjc21GNnRwb0wrNnM0YjJ5bGxNRDJyZUl2VXExZ2h2?=
 =?utf-8?B?MndiTERGS1o2ZWJyM0NWSU1Wdk5xTGJDUkZLTXFMQXFZUktqbXNESTBFWkRB?=
 =?utf-8?B?RnZQckJJZGJsdk9pQXdXSDhIQ3JRUWZyYlZ0emFRK3ZqMjUzZFJLa1JkVG9V?=
 =?utf-8?B?ekFlSjBEVHdrQXk0aHN5QnBUMU5UbWFYc29IUjRnNmxBalYyc1hpZ1dobGpM?=
 =?utf-8?B?Q1JFa09xR3UzbGdNOFphZE1jRDZWYWNuNlhvVmdieFo4aFBWbHdndjYwTHhZ?=
 =?utf-8?B?c3RBT2VTYjJ3MVlEMkZQa3Z4K1BKaXBQUWh0b2hjRUlaNDRRQ2lGN2drTlFH?=
 =?utf-8?B?NmI2THFGaGdoYVlSY215dnNvbCtLWXJjeHFoZW1sYWs4bmNVa2NHN1g0UCtQ?=
 =?utf-8?B?SmVIRHA4djBxY1ppRkowNXdMVHR4Mk9qUFc1YzRrcmhqQmlucU4xZGlRdmVw?=
 =?utf-8?B?dFNjU2ZqMUd2NjZMaFUyYUVaR29RTHFjUVM4ZHFZS2tJNEMxMG1tK3pSY2hr?=
 =?utf-8?B?WFRVSnFWL1BVMENIWjM3TVk5b1J6MCtSY1dOSC9xeEVIMld4U2VxcTZnME5W?=
 =?utf-8?B?NnpiOXNUanZESmN4ZURFaG9nVzZEL2U2QzBMV1IwMnZyZkhTcUFwZlplTUxj?=
 =?utf-8?B?eDBLaVRWcFcwUEdjOVVIT3A1VjZOT2VEMVk4UFdVOERJdGhCME5VZmc5Smgw?=
 =?utf-8?B?eGh5bW9oK3FPMEVwODVxc1Fuano5TzJKbkdLMXFRQ1gyUzBIeWg5RjNSWXp5?=
 =?utf-8?B?dGk0YjVoR2VuTGlDU1pGM2haYkpUa3M5Mk0rYkQ1NXQwWktYaXVtVDVmZ2Ns?=
 =?utf-8?B?VVlmclBzcmYyVVNNM1NvWGFBNkluWkxKT3Z3a0pvblpxZlJzNncxeTlTWVpz?=
 =?utf-8?B?T09oblkvVzV3bC96b3hkZHhUS2JIZ1hWbVF0LzZRd1JaT2FzTmRwTjZUb3lQ?=
 =?utf-8?B?amtiVmZZWnp4ZmE3bnZDRms4UmxqMjNicEd0MDJ1aXpvZEltanZiN2tUU1B0?=
 =?utf-8?B?YzUrSmxhTHo1MFlPODA4YXovWFpCZm9sdHRuSm9WY0xpSy9iS2VNb2p2aURz?=
 =?utf-8?B?NTViRUdFWTc5aGlGWTQrMFdWNCtUclRjRUdFZHRSSWdBRnRTU1NpREhqamtX?=
 =?utf-8?B?K2hWSDlkL3hPcVp6aXNnUzQ2UmN4Z1craHhkV21iNnlweWlBaXdRY2dvTTBF?=
 =?utf-8?B?Y3FlbFlRdXJDUkk4L1JHMkIxQ2pWaWVrclhoVzFCemFrQlk5eURuN0pkcEtx?=
 =?utf-8?B?S1hPLzdMQkladURoUHFkU2RpN0paR3BoWmNtdFMvSnc5QmJ5WWFpa0UwWW12?=
 =?utf-8?B?M2p6ZzRsSWR2elJjTDZndHhoNUh0eWtVUnd4MkNZVHV0bm16Z1RhUGpSc2dJ?=
 =?utf-8?B?RTBlMmx1OStlWFRxVFIrc2xLR01rd0dVSVIrNnhSandBSnRTcCtvanhKY3NZ?=
 =?utf-8?B?NmtRa3pna1Z3dVJVY0J0cWQ5ZDBDM1dhUUI1Rjl5ZTNjdkJZeVA4N24wd2xO?=
 =?utf-8?B?dWlMK3B4Njh5TndCNEh5dFZvSWd4MWU1Zi9oaENnOEZPeFZIckowRjY2d0hT?=
 =?utf-8?B?SUpCeGg3U0J2OGRtdTMxbDF0Ui93YjNMS3VDTEwzMXFMUHNxMkJ2UzNwVjlr?=
 =?utf-8?Q?K/r0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd253f88-1848-4f7a-e881-08dd8beb24a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 15:40:20.4566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Khg6ZSs5m8ZZlLwTmWZl2X43m0pcqhoClZkyOQr1yXXXutpSt2me7ouCOXlDjZn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5660

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3Yg
PGJwQGFsaWVuOC5kZT4NCj4gU2VudDogTW9uZGF5LCBNYXkgNSwgMjAyNSAxMDoyNiBBTQ0KPiBU
bzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IENjOiBZb3NyeSBB
aG1lZCA8eW9zcnkuYWhtZWRAbGludXguZGV2PjsgUGF0cmljayBCZWxsYXNpDQo+IDxkZXJrbGlu
Z0Bnb29nbGUuY29tPjsgUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47IEpvc2gg
UG9pbWJvZXVmDQo+IDxqcG9pbWJvZUByZWRoYXQuY29tPjsgUGF3YW4gR3VwdGEgPHBhd2FuLmt1
bWFyLmd1cHRhQGxpbnV4LmludGVsLmNvbT47DQo+IHg4NkBrZXJuZWwub3JnOyBrdm1Admdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBQYXRyaWNrIEJlbGxhc2kN
Cj4gPGRlcmtsaW5nQG1hdGJ1Zy5uZXQ+OyBCcmVuZGFuIEphY2ttYW4gPGphY2ttYW5iQGdvb2ds
ZS5jb20+OyBLYXBsYW4sDQo+IERhdmlkIDxEYXZpZC5LYXBsYW5AYW1kLmNvbT47IE1pY2hhZWwg
TGFyYWJlbCA8TWljaGFlbEBtaWNoYWVsbGFyYWJlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiB4ODYv
YnVnczogS1ZNOiBBZGQgc3VwcG9ydCBmb3IgU1JTT19NU1JfRklYLCBiYWNrIGZvciBtb2FyDQo+
DQo+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZyb20gYW4gRXh0ZXJuYWwgU291
cmNlLiBVc2UgcHJvcGVyIGNhdXRpb24NCj4gd2hlbiBvcGVuaW5nIGF0dGFjaG1lbnRzLCBjbGlj
a2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4NCj4NCj4gT24gVGh1LCBNYXkgMDEsIDIwMjUg
YXQgMDk6NTY6NDRBTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBIZWgs
IEkgY29uc2lkZXJlZCB0aGF0LCBhbmQgZXZlbiB0cmllZCBpdCB0aGlzIG1vcm5pbmcgYmVjYXVz
ZSBJDQo+ID4gdGhvdWdodCBpdCB3b3VsZG4ndCBiZSBhcyB0cmlja3kgYXMgSSBmaXJzdCB0aG91
Z2h0LCBidXQgdHVybnMgb3V0LA0KPiA+IHllYWgsIGl0J3MgdHJpY2t5LiAgVGhlIGNvbXBsaWNh
dGlvbiBpcyB0aGF0IEtWTSBuZWVkcyB0byBlbnN1cmUNCj4gQlBfU1BFQ19SRURVQ0U9MSBvbiBh
bGwgQ1BVcyBiZWZvcmUgYW55IFZNIGlzIGNyZWF0ZWQuDQo+ID4NCj4gPiBJIHRob3VnaHQgaXQg
d291bGRuJ3QgYmUgX3RoYXRfIHRyaWNreSBvbmNlIEkgcmVhbGl6ZWQgdGhlIDE9PjAgY2FzZQ0K
PiA+IGRvZXNuJ3QgcmVxdWlyZSBvcmRlcmluZywgZS5nLiBydW5uaW5nIGhvc3QgY29kZSB3aGls
ZSBvdGhlciBDUFVzIGhhdmUNCj4gPiBCUF9TUEVDX1JFRFVDRT0xIGlzIHRvdGFsbHkgZmluZSwg
S1ZNIGp1c3QgbmVlZHMgdG8gZW5zdXJlIG5vIGd1ZXN0IGNvZGUgaXMNCj4gZXhlY3V0ZWQgd2l0
aCBCUF9TUEVDX1JFRFVDRT0wLg0KPiA+IEJ1dCBndWFyZGluZyBhZ2FpbnN0IGFsbCB0aGUgcG9z
c2libGUgZWRnZSBjYXNlcyBpcyBjb21pY2FsbHkgZGlmZmljdWx0Lg0KPiA+DQo+ID4gRm9yIGdp
Z2dsZXMsIEkgZGlkIGdldCBpdCB3b3JraW5nLCBidXQgaXQncyBhIHJhdGhlciBhYnN1cmQgYW1v
dW50IG9mDQo+ID4gY29tcGxleGl0eQ0KPg0KPiBUaGFua3MgZm9yIHRha2luZyB0aGUgdGltZSB0
byBleHBsYWluIC0gdGhhdCdzLCB3ZWxsLCBmdW5reS4gOi1cDQo+DQo+IEJ0dywgaW4gdGFsa2lu
ZyBhYm91dCB0aGlzLCBEYXZpZCBoYWQgdGhpcyBvdGhlciBpZGVhIHdoaWNoIHNvdW5kcw0KPiBp
bnRlcmVzdGluZzoNCj4NCj4gSG93IGFib3V0IHdlIGRvIGEgcGVyLUNQVSB2YXIgd2hpY2ggaG9s
ZHMgZG93biB3aGV0aGVyIEJQX1NQRUNfUkVEVUNFIGlzDQo+IGVuYWJsZWQgb24gdGhlIENQVT8N
Cj4NCj4gSXQnbGwgdG9nZ2xlIHRoZSBNU1IgYml0IGJlZm9yZSBWTVJVTiBvbiB0aGUgQ1BVIHdo
ZW4gbnVtIFZNcyBnb2VzIDA9PjEuIFRoaXMNCj4gd2F5IHlvdSBhdm9pZCB0aGUgSVBJcyBhbmQg
eW91IHNldCB0aGUgYml0IG9uIHRpbWUuDQoNCkFsbW9zdC4gIE15IHRob3VnaHQgd2FzIHRoYXQg
a3ZtX3J1biBjb3VsZCBkbyBzb21ldGhpbmcgbGlrZToNCg0KSWYgKCF0aGlzX2NwdV9yZWFkKGJw
X3NwZWNfcmVkdWNlX2lzX3NldCkpIHsNCiAgIHdybXNybCB0byBzZXQgQlBfU0VDX1JFRFVDRQ0K
ICAgdGhpc19jcHVfd3JpdGUoYnBfc3BlY19yZWR1Y2VfaXNfc2V0LCAxKQ0KfQ0KDQpUaGF0IGVu
c3VyZXMgdGhlIGJpdCBpcyBzZXQgZm9yIHlvdXIgY29yZSBiZWZvcmUgVk1SVU4uICBBbmQgYXMg
bm90ZWQgYmVsb3csIHlvdSBjYW4gY2xlYXIgdGhlIGJpdCB3aGVuIHRoZSBjb3VudCBkcm9wcyB0
byAwIGJ1dCB0aGF0IG9uZSBpcyBzYWZlIGZyb20gcmFjZSBjb25kaXRpb25zLg0KDQo+DQo+IFlv
dSdkIHN0aWxsIG5lZWQgdG8gZG8gYW4gSVBJIG9uIFZNRVhJVCB3aGVuIFZNIGNvdW50IGRvZXMg
MT0+MCBidXQgdGhhdCdzIGVhc3kuDQo+DQo+IER1bm5vLCB0aGVyZSBwcm9iYWJseSBhbHJlYWR5
IGlzIGEgcGVyLUNQVSBzZXR0aW5nIGluIEtWTSBzbyB5b3UgY291bGQgYWRkIHRoYXQgdG8NCj4g
aXQuLi4NCj4NCj4gQW55d2F5LCBzb21ldGhpbmcgYWxvbmcgdGhvc2UgbGluZXMuLi4NCj4NCj4g
VGh4Lg0KPg0KPiAtLQ0KPiBSZWdhcmRzL0dydXNzLA0KPiAgICAgQm9yaXMuDQo+DQo+IGh0dHBz
Oi8vcGVvcGxlLmtlcm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQo=

