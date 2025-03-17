Return-Path: <kvm+bounces-41261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76808A6597B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 805617AF5C4
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC74519F424;
	Mon, 17 Mar 2025 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4BHyd7lH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C287F1598F4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230914; cv=fail; b=rRj6GCnMd9p42KEDwePDLg4+ACHlazim2SIxutjQ9rAjfrPLq206/rgZnvGlILKFAeXy8JxVyIGV00eSbmMiyEllpW3m0KVeat08pUnt3jnYGYqYtydRAQ+D6/XpHpPGBNw+Q9sAtPfsEipfIhuw7gxBceHe14rWj8hBJaSjg8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230914; c=relaxed/simple;
	bh=GxreDqr3xDxKN/KK0O1i4LSbJntxh6ATz1vb4LBMtDo=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pSLa2j1ax4WtltcDNo33CN3zIPMq6n4ravpNeIzTfW2cyIsmBkjFzTlY8/+cAES81zpOolTjP+RQEZbjlyBZVox6HV2Jzn7ArMN3Dfn6XLmRvBTY9eeyUyunooS4Jfo9rZGJPc1ShRWVPsnMohsPUmOEzhMXbWm+bbNqBLk9Yqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4BHyd7lH; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tx5N0h6X8epcSJ6Gc+gn5hAXADEzGu/YF1qYWjlX6V5voj5Zd/H/A1u12HhFEuKx6NRx8D5sT5NV8vG9o5lkH4FBLwr7cK/eNelI0M0eTJW3MWn+noWXy5sbWQqt7fJ/J60Yv4RCUCiBFfKiu7vvhjYIUyQrRJUglLCfR27ooZdnf3tCsFu4Vwh5wOEYZAv+Y32fi0LbbomApZP3q54x+dn4+yHiEXTAlFvnaEzjj8f7xB1MtM6PCbUE78krPqOyOQzBXmr0dYJXnJg3Mifih5IckHsm/xBZvHvVhs8J/pMw05LtL24Gbx/YV5o0UlRwcICQH3eMdA2LAwzjm8WxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+b+D92JPH50OrgTbhxbraa7OHkgy2NoU4txxudTiH0c=;
 b=qOw9A0ABlIqnvTwqkOb8N3XCwVDeP3ZDOp2A/1Jbolh62oqY23lsSC3lZ9n9YuQzXNSybYIKJ43X5i7SWi2hRMwBifQFk5Bfpx9pweQ48XcHqxOCCJkg2JJtB7uHQGiFNCsHL3EZ31SHXcIpJfR3scCe8Z181kpifrvRs7cBjkUhcSEvsjY3qz/iAxb+K/CxO8vxJtr6bxdz+Z6wcCrjPlcFbPznyw+LhlmBeKhsd9LoR3u0cDo6yg8govcYp0mU03gDv10BqSUnJfRK/JZzlgSvQsh7CjN+GDT4nvXaISsw1WOd4WXUFnosuvBFtsCFacDB9T49X5IX7yw/C/k0UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b+D92JPH50OrgTbhxbraa7OHkgy2NoU4txxudTiH0c=;
 b=4BHyd7lHujJBgvGDc/XjeHaSOzNfZczPdwsqZKKOAjAiHz9Q/md8utpuLaQXU+WolXhPmrmRcmHg20NrYFJoxojwnQij4PHNdkbkP86FvPEYDJ4qsCUVA4NgBoHgKtcaTK3WjGzzb6bPwcup3IsUR21sMxQ9mloXYdXnFThs4cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SA1PR12MB9004.namprd12.prod.outlook.com (2603:10b6:806:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 17:01:50 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 17:01:50 +0000
Message-ID: <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
Date: Mon, 17 Mar 2025 18:01:45 +0100
User-Agent: Mozilla Thunderbird
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: David Hildenbrand <david@redhat.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
Content-Language: en-US
In-Reply-To: <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::19) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SA1PR12MB9004:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c255d4-4888-429f-1332-08dd65756893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TCsrNUxTWjRsT2tKOSt5bHY0bUdjdWxHYjVEczNoQ3UrUlFIQjgwL2lsU1BH?=
 =?utf-8?B?bDRFR3dFNjhCOUdQUVJhNGoxL05ESkl1R1EvU2I0dEFWL3k2TTFQK3lVeFVj?=
 =?utf-8?B?WTh1Qk41TWlHZmVzbFN6djJSc1IvZFBTZWhBVDhuR0c4cnF4cEpmMTBsSStX?=
 =?utf-8?B?NGkxa1B3c0lHeHNnWjY0QzJ5bzFOUVZ0V0JhMytoK1pTT016NThBQ0s0M1ZI?=
 =?utf-8?B?ZnZzZUQybHpYVEw2YkJ1ekJHdUt0SE03dHJuM1MwWDNWdFNQUUxqa2ZWRUVy?=
 =?utf-8?B?czM1dHZQV240S2dwb0thQ25GOTlLRStheUh1RGNNaW1hcnBOY0FJeDBUWXVC?=
 =?utf-8?B?TjB4dml6Mlg5dlZiSmlWaEh0bWFSankvYld6QURSSlBjODJYRGFCcWpIWU9K?=
 =?utf-8?B?Ukc4ZS9tVWd0bFJocEdaSTVySkQxTWp4a2FqeGVSOThDK2dvYmp5L0NRQnNz?=
 =?utf-8?B?NDFsMzRlc2hLd0R5NW8zOWtrUjhGcDlKUlo4U0pKK2JjemxUZzVtWEM4eGI2?=
 =?utf-8?B?ODIxVjRWSnF4Z2NpRys5NTliVVF5dXpNNjFQRFFzMDBvWGNhVThaU2F2K1Np?=
 =?utf-8?B?K2pJTWFwdUJjYTRETHFzK3RPbkRpYzBGTmF6SFlJc1I2a3hqOXRuWTBJUldw?=
 =?utf-8?B?WEhTdmhMbnZRUXRDbGQyZnBYZFN2YTYrdWZnaFNJL0UzUDB3OGs0eENOQkRp?=
 =?utf-8?B?OWtzZjlnbXRJS3A0VmtGRXZBS0ExV2VBOUJqcmxsZGN1NC85RlpBQUJ4UEtp?=
 =?utf-8?B?eUdIYmpaT2VjUWJsSHJqYWp2Z2xJbG85cUtocTU4YTcxTWJKK1hTYjl2Sld1?=
 =?utf-8?B?WndaV0NQR2ZYYkplcmx4aU1oMWkxSndxb0xYNUtmZ2U5blZjNHZXVUM2SDh1?=
 =?utf-8?B?VzVxQnhNblVHNTczTFZVK1ZLakl0NE9LcEVBRXA4UTJzOEFGS1dFWUFHdUJu?=
 =?utf-8?B?R0JlRzgzZ0VEWkducFYxdlViOHBjdjNySHFsdUVVTFpsTW9jRzIrd2RmZjZa?=
 =?utf-8?B?bWp1ZlVCYUlGSUR2bHJBQlZtQ1VvYnU5a3Q1RUNZRHNUeGJRMmYyREh5aW9O?=
 =?utf-8?B?dnk5L09UMmJYelh1UzVZcy9XTkhpV3JrMGs3UnN3NFZpSVdMWmhyT0xQT1h1?=
 =?utf-8?B?K09RZytpekdHUFFaNmNsRnVMTzZWMStSNXdTRS9Qa2FVaWFGMVlBUHhlYmpY?=
 =?utf-8?B?NmxPTXlrY0tFVEl1Rk1Xa3h2RGxHeURZYTFteG54blBmRjg0OXN3dFk1MjZ1?=
 =?utf-8?B?NE4xRk5QZWZuYWZSWnovTFdwR1dTdmZIc1JsbEVJd1ZCaVdEYTkzcWlnSzI1?=
 =?utf-8?B?OVlLbmZVUkVXOTJVYkhPWlFJTHdFQnUyVWNTT1FQK2RNcFcwdGpIRjRjR3hn?=
 =?utf-8?B?YnZzWVBzYnpjeXNHMnNqWTFsaVpNU0p1SFhtRlNXd2JNdnBJNFZHY2gweXNM?=
 =?utf-8?B?bk1Yb3ZiSXZNL2dWVHFEV2lHSnp1VWlvUy85VVcvWjNPeC9jOVBFdnVUeSs0?=
 =?utf-8?B?UU0xcXFiZUlqNnRMRkJEUEVpNkdHRGRPZjZRbFNsUTdlREdpelpkM2RwVkdn?=
 =?utf-8?B?L1M4YndWeGludERwQlB0bHdpdyt2Z0VDK0ZrZ3BxcjB0Z3JWTHNSa1N0TEJZ?=
 =?utf-8?B?MEVRaTBxUWVDeTBqdDZ4M3JiZW1pd2xnRWhrY3hEQlZDbVJSNzVCTnhrL01Z?=
 =?utf-8?B?ZWVaOVR4UDM0eGYzYlFHdE95NkJxLzBiSUNPM3lRY2VUbmxLRnhZZU5GWTVs?=
 =?utf-8?B?aEVESU5jc1U5Q2pyWUcyQVBkZk5EZnZIeU9abUFVeDdnRGtERlBOOFVVNHM0?=
 =?utf-8?B?SjRocUtmWi9DUkFrN3FNWGh1WGpraXpMenU5bDc0U3IxM0MvTWVuWWNPNDJW?=
 =?utf-8?Q?uh8c5GQukHbiq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWFFSWpBb3BhTytxM2ZEV3YvU0s2Ri9yTnlQaVNNZ3R2ekZidk1WV3IwZ3ph?=
 =?utf-8?B?Y1BaVld4ZE5BTEZIMDNWMjBwOFVLZkEyL3B4U25BNGVVYTU4YmZMUGFGNTlR?=
 =?utf-8?B?WkJtcWdDMGpTRmdvZkJuV3BFcTZNdjdoMU8xTll0c1U0MWJadCtVUS91dnZK?=
 =?utf-8?B?Z2pkQ2RFVmR0M04vY0pBMjh3NVlDVzdSSksvZFRIalFobkhSQXZhRU1hQ3Vo?=
 =?utf-8?B?dG5uMnlEK3RxbFREczBzVVg2T0pJZWFrQWN6Yy94OGNobFNsUUVkZjE4N0hV?=
 =?utf-8?B?RHhHSlNEOWU2MjZCSmhIVzBldFgyN2xtNzBub1VjdUx5YzdZak1MQ3ZWOW9i?=
 =?utf-8?B?YmlkRWl1WXV4MWZYMFlKL1I5NVlNWGNqajNiNGVpdTdTUFc2eHZUR1FiVEVX?=
 =?utf-8?B?Ylh4TC81VTN0Ums3S0huVzZrMklkdDZoZTdhbDY2cm5EZW8wemRZVnllL2pu?=
 =?utf-8?B?SWNOeW5XVEFtdmErZWx4S2hlMHd0M2h6MlRqY095Z1QvSElRTWcySmlvS2Fj?=
 =?utf-8?B?dkZrcUY0ZnBHRHNJS0dtTE1OeGQ5WkhrSkpVaTZpUTZVc3F3M2hDVzQyRW5k?=
 =?utf-8?B?TUxQVTFBcmJ4N0RjdnJ2dGFKcUd2REZMSlVIT3VvL3VTTU45clZHMXhGbkU2?=
 =?utf-8?B?c1BiaU4rakNNZkk2dnRXL01KT0pja2U2eUFyTmZVOXRDWFIvOWJwR3E1VEJ3?=
 =?utf-8?B?c1JTVmw5OVB0R2w1N0g1U3ZxaW1RUWZqakY2MTk1ZldiWkU4NjM3c29VZ0VN?=
 =?utf-8?B?TUxtcXdDSEU0UGJuZHcyVmRtbUUwNFJLUUorMDQwN29XUXBhMHBZK2JEZkZh?=
 =?utf-8?B?WFRKdGYwd0E0aVdDbHJFdGZzMzEwT1MxMXF6bHU4ZVozNFZPM2l4RHJZNG1p?=
 =?utf-8?B?WVdCOTRiY0ZmY2hSTldNU1k1NkZVbW5iSEN0ZVdsVDNPbEZxU0c3bTNRcEN5?=
 =?utf-8?B?c2tjMXVmaENpYkFnYkVyOHZQZjJWTmJsVEVDV3MyRTVLakZxN1RXaUVvcVh1?=
 =?utf-8?B?YXBQYlFrbVRibXVWOTZBZlpWaVhiMzZSMUV5REJ6VDVCSjhpNGpEaWN6NWYr?=
 =?utf-8?B?cG5rbEU2eHBlek81Q25zU1pwbTJmek43M3J2Qkltb2FGUUJRMU5xQ2VUa3Ez?=
 =?utf-8?B?VC9wbFpFdUVGZkJxaVN4Q0RkR1pSMEdueG9IZVFRR2NJOFcxc2JyVW81ZWJG?=
 =?utf-8?B?Z0NiK00yTVJSaUZJRFpBUEVZcjB3VDBsc0g5WHM5bGVNdld1b003N3dSL1Bu?=
 =?utf-8?B?V2QvTnlIcnlWc1VWSnRGSkgzSjB5cm5WeFEyMDVnYitmMkRUdU9sZkxTMTJn?=
 =?utf-8?B?WXk5bXl4bmUwVGZ0RjZZVUQ1L2lhS0dZS1k2cC9lWHVnNTc5dDM2bDhEa2Iw?=
 =?utf-8?B?ZUVWVmlKbVFsRnN4cGQwbnA4b2JQOU5zbnBqWW9OK3hubjk0TlVTaWYvSldS?=
 =?utf-8?B?UlNhV28zQkkxMWRiSDlXZXFkaVRzdjc4Q0NTbkhZcWFJaStqMXdGTnUyTEpE?=
 =?utf-8?B?NXNGQTJYZndCakN0ZjdiSzA5N2RzUnlOek1BYkdVcmhqYW9lT1dQQUlyYTZr?=
 =?utf-8?B?bnB6diszRVlPZzExek1PcWpWbzd1TGdyV1FmdE1JVWVJUDZoK1J5SFF2S1dT?=
 =?utf-8?B?NmcwajVRQzBKdlVsUHFOYlJmc1pVcE96RnNVY01iRy8wcVhlL3ErbzV4eW1z?=
 =?utf-8?B?UTlDVzJKZTdvN2RydmdOTlY2UVoxRitBNUtFNm9PYWlXT0NGM2NwSTJjdG1B?=
 =?utf-8?B?QVFYN2l0WHNCdytQZkUrRGdnNzJOOFJYQUs5Y21oaFFMOVZDVkkwbkk4aDNS?=
 =?utf-8?B?UTZGL3VIM0dWRkFwWEdUZllSeEdhZk42VUZWV3lCelNvYnFjbDdwVUVldkc1?=
 =?utf-8?B?eEtUZzhwdTcrbVp6U2cwTG5QWWM2ZHdjZTFlRG1jZG01dStNTnA5N3ExbUMx?=
 =?utf-8?B?Y3VhbHRIRmZucjllQjl0bUJkK0ZIdmpRODQvUHFjejNURTZDOFozcHFzUFFn?=
 =?utf-8?B?cWhqSlVGWjdLbkV1d1A0ZFU0eDhQV2gxaFA0dHlVN3krN0dLc1NEQjFZdS8r?=
 =?utf-8?B?SGwrTXdGejdQa1Q2V1VOY1JNWDBqbjc5MmN5ckQvWHlaOVVuNjg2M0N2ZFVN?=
 =?utf-8?Q?FvaO4h8/Ad4w6NyHR2kVesiWq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c255d4-4888-429f-1332-08dd65756893
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 17:01:49.9391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcjrYLI8z3eWit5C0y/nMHeom7lB+uweQQVUPauf+OxDwkgfLt6sEBoKs9SkFJO+3SWn8hPb2HAr0rd+ivaINA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9004

On 3/17/2025 11:36 AM, David Hildenbrand wrote:
> On 17.03.25 03:54, Chenyi Qiang wrote:
>>
>>
>> On 3/14/2025 8:11 PM, Gupta, Pankaj wrote:
>>> On 3/10/2025 9:18 AM, Chenyi Qiang wrote:
>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>> operation to perform page conversion between private and shared memory.
>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>> device to a confidential VM via shared memory. To address this, it is
>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other. Therefore, similar actions are required for page
>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>> facilitate this process.
>>>>
>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>> RamDiscardManager interface. One potential attempt is to implement 
>>>> it in
>>>> HostMemoryBackend. This is not appropriate because guest_memfd is per
>>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>>> particular, the ones like virtual BIOS calling
>>>> memory_region_init_ram_guest_memfd() do not.
>>>>
>>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>>> MemoryAttributeManager to implement the RamDiscardManager interface. 
>>>> The
>>>
>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>> should be an interface and RamDiscardManager a type of it, an
>>> implementation?
>>
>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>> implement the RamDiscardManager interface callbacks because RAMBlock is
>> not an object. It includes some metadata of guest_memfd like
>> shared_bitmap at the same time.
>>
>> I can't get it that make 'MemoryAttributeManager' an interface and
>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>> think at least we need someone to implement the RamDiscardManager 
>> interface.
> 
> shared <-> private is translated (abstracted) to "populated <-> 
> discarded", which makes sense. The other way around would be wrong.
> 
> It's going to be interesting once we have more logical states, for 
> example supporting virtio-mem for confidential VMs.
> 
> Then we'd have "shared+populated, private+populated, shared+discard, 
> private+discarded". Not sure if this could simply be achieved by 
> allowing multiple RamDiscardManager that are effectively chained, or if 
> we'd want a different interface.

Exactly! In any case generic manager (parent class) would make more 
sense that can work on different operations/states implemented in child 
classes (can be chained as well).

Best regards,
Pankaj
> 


