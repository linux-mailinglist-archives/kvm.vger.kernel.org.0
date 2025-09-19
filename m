Return-Path: <kvm+bounces-58203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D1DB8B632
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CAB27E64CE
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4112D3A77;
	Fri, 19 Sep 2025 21:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gUQbgRu0"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9526B76A
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318280; cv=fail; b=sBdhDBz6lGnsFNIBWGSulssYXXkmty/MwR9VefZnuAluQKzKJ5SAIvt0RC8D8CfFRj95OmsC1zUiuuNdX08d+LLqsohV2RrlWxBsE1Vg76SpHOGcVnKjzbyLbhaCqJBlmSyttyneC2LFZv6YdRIV/QpbVMpBAIqWODhMRgVs+0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318280; c=relaxed/simple;
	bh=+6jxKPlkQ/DBGEoVGP46JodD9txLnHd/gM1rFQENMEE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sdsQ/j5T2UHMnr73VVp1FpwDnNODmoKtDnR6zQiQom5Oc35NKB3C4bf6e/8AouX++Xxe7UVapWp6gKBFSXv8CMWR51szwoqsBX+AP7QiNMnUbmzoWKToSBsG00PMWzVUTTFmfsPXY/NxHcE6vc+08Vjrg42W4g12WaMxoGPAZ0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gUQbgRu0; arc=fail smtp.client-ip=52.101.85.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fEbHRbeNQQNnYr4QHWcKJPH7dgt7t+xAxJnS7cO0Aq5/QcaA97B8H/B+rlxJ3s5mEVTvXrnU98cz2uZp31FOJx01DunEIuzqyVXu5i9uaZ++DtEww8nSJwmamHT/gVjUIPO1/UEONZSm+B2r7iN+FVsuootRfcg4CjngIVoDMxwzzdEIKB3nyFP51YCFAwGHjjcnmqrrs4EuU9zYO9dOdXJIHzEOPQcR8yLQrLKZ6iXfE9MSl3TigwIU+I/J8+yNJPPxeOv7G77r8oFAKy34X7sY5F3kSC+r4ln2zWLjOkKLlzaFKURqg36wqy11GE5JkeEpntMyUb7UsEhl+GbyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oagk9xPm5rUu0Qx74aCd8NOxymk6Mjrf/Pu348Ddd4=;
 b=BBAzSAoC1lEMoaGrnW0MNi6ZM5xJVBSb12NQALOjCELqOKFXwMVVvFb6lQ/bawrpWcwgrxJ0rSHXWsGhJsW0JFSZGH+nUooBbaySyDfxfq5GWFK5L40QpWjA5n3HyrZVhL3JsYHzuuOKZUCvS7SORiHK5C3eVLQXrOrYbGmRBHWjaI/3Zc1VbbrDL9VmBVx1lCPnwE8q8S+as0GaFr0P1o1SBKwF71dMaLI1WKpfx8p8UpG2GgS69WfdmcuGSCXZNV9DUQKg9pzcj2vXvZuCYPmbdgpyQaz2vaz/lpZgkdvcuWfR1NSxcyqMqLb631k+KWbn3KnDV21WHSDqxSbKow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oagk9xPm5rUu0Qx74aCd8NOxymk6Mjrf/Pu348Ddd4=;
 b=gUQbgRu0CaJusrBHb9SaZzaqXbbhh2TmZQ9DPh/DWM9htbRDF0+/v3YjXEPnRkANb9HIsV6mzZpigpyeFbYPxKphQd7DhY1SNdMRIEA+kjRpeMajjYenEhS2oVx2LDo+tKQqDTRuuau1M7dJ3gMu8GGIuvXvkV+Q7+NGvNpdq5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 21:44:36 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 21:44:36 +0000
Message-ID: <f97f66c5-d6f8-4a6e-91f1-4d3dac3c0816@amd.com>
Date: Fri, 19 Sep 2025 16:44:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] target/i386: SEV: Enable use of KVM_SEV_INIT2 for
 SEV-ES guests
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <4d14083f34e3196a1ef179a958e30e800b5263fe.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <4d14083f34e3196a1ef179a958e30e800b5263fe.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:1ca::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 08343d57-9eab-42d5-3e4e-08ddf7c5ba2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzJha0hGMzZxQnNKd1JmZUxEUXRHYzFmS3ZGV0tuSzVwOW9Hd25Fc0psdGZP?=
 =?utf-8?B?MjI5dVVzSGM1U0s3dnExWk4yYUpDcVB4SWY3RFJQREFkTEs1eFhHTDhnR3FC?=
 =?utf-8?B?eGY0ZkdzVUFBUytuUGdNODZmTEMwbjd5dzBuU3VKbzNwSEZCbnlveE5tdzZ4?=
 =?utf-8?B?cTRKVE4xYjNJaE0rVm8vSmhwRlp5aHB6MjZVMnZURUtNSGpDdEQ2Z1FCNjA5?=
 =?utf-8?B?aDB5aEg1ak1vNmt2NFBIeHh6eGJxaEtxMlUwbFVCa3NZeDNuaFRoYWxRalpF?=
 =?utf-8?B?L3NmbU5zbjQ1WWNkZ0xIRHhFaG5wSmFRNkxyczVYVkZEaHBFRXBRQndLQml6?=
 =?utf-8?B?S2RhNnpqeFJXd29iY3dxQWdIeElLTHBnZVFIR2Z5U1lTZzJSbmx4WlhTS0ho?=
 =?utf-8?B?T1FxcUdlbDloYWxKT3k0NjJuNGJqMksxMy82K24zTnJSZGExcENlS3RnUGF1?=
 =?utf-8?B?R0RsTkZhSHZQWkUyU21ORGE3S0g0RytqVjNBZmpwcVUrUVJQR01UOE5DSmpx?=
 =?utf-8?B?VFJVZTFZZThFVHJLdDkyeldtWnR6aVQ2YTNwaVdOenc0WWdYQjhNQ3hCYk9G?=
 =?utf-8?B?azNpaUs5cnBsN1ZVMWF0bFdVRlBDRFkwTzY2UDdoWVdvVkFyc2lDUDRUNW9Y?=
 =?utf-8?B?QWZhb3VOdUxKU3prTWJMUWNPV0xhZHV3S2JXdzhHLzdJWkRuOEsvVS8yRXRI?=
 =?utf-8?B?OW9FUWJUSFJxU0l4SVZqbzFlTzdDdjFEZ0xqMzhEU25Ua3h1c1krUllyei9s?=
 =?utf-8?B?aUZTUHowU3Z0bzdsZ256WFA5ZzhKZUN2dGhXdXAwY1dVKzI3SHkyNXZZVllH?=
 =?utf-8?B?Y3lQenMyaGU5ODh5RWR3Smc5SEE5a1F4enZQZERjTUxuOFJkRmNkK0lGS1Vn?=
 =?utf-8?B?UnNEeTVTaWhtQlFiQVNQL1R5UmF5UHExM1EwbWJQVURGSkRrM2t6U0xhUUFT?=
 =?utf-8?B?QWdLeTN0TkIyK0gvZkFlcFduOUJzYXpERjRaL3dCR1lnbG03Q2MzaDJMY2Nk?=
 =?utf-8?B?cnJ4cGVaVW5WMHpBcnpLOWR0ZFhabUpBQ05hZmdZR0RUZGdHS3JkQjFqUi9m?=
 =?utf-8?B?dklFMVdzK21tWjJZQzlQdDNDQWlKZDl6eVoyZVpJSldpOTczTVg1aldOeDRK?=
 =?utf-8?B?QlFtNDluS05BeGNNdnFUNG1udU1DZDVlY2dLaDBXVnhibjRNUHNXT2VLWlYw?=
 =?utf-8?B?NDNJTngzbFRpb3IwckxBcnp1WmRuN3ZxUGVkYm1FamlRQ29FbEJSaTNsR1or?=
 =?utf-8?B?UTUvbnBzMnBDdERvcjB4RVdiaFR1SC9xNDY5eWREdkNZYjNSbGVkdFk3RGNB?=
 =?utf-8?B?ZVFnY2laV016QnNnbUs4dlhRT3FHUzRlL29udzZSYzdVQlFzSE40d0FqYWtU?=
 =?utf-8?B?VWJHRFZ4Q0Q2RG5HaHBVUVRCVFNSQlhYRVFmdWREZjFTeGNsT2lWZ0R4VHBK?=
 =?utf-8?B?N21mZHhiT0UyOHZ3ckx3S0dOZDRubUc0OXM1MUxIRFZ0NU9ERWhGdW05WitF?=
 =?utf-8?B?TXVsSklmVytQVHNsTzBzbGJYZGVrRnE1VG5iaXMwM2t6TlFTcTYxQm9meHpq?=
 =?utf-8?B?R1RkNlhKOUJMbEMydmp6Mk1NTzdmekprd2JaNCsrR09CZGMvcGxxaU5lY1M0?=
 =?utf-8?B?VGtiVDMrZHVlT2RqQ2FFOGpVQ1hzaThiVGxwRnhYK09iTDloOGRyQ2FhN2cw?=
 =?utf-8?B?VTUxcVZSekZxQnI2NFRCZFJCM0IyMzIvZ3NNSnZyY1RJK005bkF1bVJHcE5v?=
 =?utf-8?B?RERxUUNGWXdKbTBiVmhHVGZBTEdXcXNlblBscnkxUk0vbW93Y3BzWnZaSStS?=
 =?utf-8?B?dkFubEpRVnpHN3Z1ZENaTFJSR0p4R1lzZHRrYS9TajRRODJzTFh2YTdjWTNG?=
 =?utf-8?B?a1VwS1lhSUVVVU5RV1dpRy8xdjY2YU1aV1FXUHJ1ZGpLUm5DNm4rT0RxWU84?=
 =?utf-8?Q?dP2CTDICY2o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVpXMGJwcHI5T1BLNjhUdlVpQitOcm1tTzZuaEFUTWt5cjltemZsTFpyejg2?=
 =?utf-8?B?Vi9FZVI5Tys4Y2hhMU5LUjlmZmo5N0ZRNml1cXFsdW93eGtFMGM1R1dnTmgy?=
 =?utf-8?B?M1lFdGVnSklsZk1EbDl3TVNFcVBqMGp0b2dNd042OUdZL0MyYVNZRmd4RnM2?=
 =?utf-8?B?dEJuajk3NWdCc1FQOEh3cEJMcUNNdFRldUtmK1BLM0Nmb1VsbFFiTmVWcm9q?=
 =?utf-8?B?elhISGZKdGtRcXNjNUR1VFRCMWc1NTlRUzl1TFdhWm1ZYkJpOWhZS2tuM043?=
 =?utf-8?B?MWt2dS9wTlRXZHBEcjFSeElHcWpIRFM3RlQrVGNWNUNiZ0o5STdJazFxa0tF?=
 =?utf-8?B?NFI4dXA3d3ArcVAybXZ6NjYzbmNlM2lDeEs5cVZROEw3UjZxcEVqaW5IV1FG?=
 =?utf-8?B?NDFnRjRWNWZxcFpicEdXQ21kWHFEOWV3elNoUXRzWklZUld6TzN6NzNjNUFB?=
 =?utf-8?B?ZTFQK2JnWkFZWWRTRm5Rd0Z6UTRkbFc0MldKQXp4bVRZOGdacmpGdmdlT2VT?=
 =?utf-8?B?Y2tvNWhnSlpxTG53T1BtVzhPelJLUXd6SHMvbWdWN2d2UldEWFI0MnRRWEdX?=
 =?utf-8?B?RFhiVU1pdWhlNGNxMjNETzlobkJDblIxa01FVDIzcXZqd1prOHNqYjIwNzJ6?=
 =?utf-8?B?TjVVVmgzTG1tR2hVQmdjYTRVa05MVXNPWUNvUW9kMHFmK3REYUpHV2tPL2tC?=
 =?utf-8?B?Q1FpSll3TmRmandDaFg2NGVhS0JHOW14ci9jTFZrRFpTR25iaTRPeUZtOU54?=
 =?utf-8?B?Z3NtcktINEVQTFpkakwyeFo1SGJkbGthZWhCTFllcFZEQzUwaHVwbTZmeURO?=
 =?utf-8?B?akZRRTVIeVhrdXMxQXRSODArQU1tZUdNT1lPQkd3ek5BMGJYQnI5eGR4Wkow?=
 =?utf-8?B?UmNzVFIrTWYyYlhUSzNZczRFcDRBTWxoMGs4LzFZam9rcGkvUjRtSDAxRkw3?=
 =?utf-8?B?L0o0WUNaeEFSLzZiWTJWd0Q2R1dDRW5seWxQakd0WEJueithTkhoZU5PcVlW?=
 =?utf-8?B?QmV4OUlVVUhTdzkvV25hR1JSV0cxVFFqa0Evd3VxNis1bEVrTFNBMjV0OXhQ?=
 =?utf-8?B?ZXNVQVUyVkNVb2ZPeWdNL3dpVGY1YmdjcnpLYTNDSEd1UEk1bFA3dzRDbnRu?=
 =?utf-8?B?cHNkTTE1dlBpN2pNRTN0TWtQdVF6eDVnSDA0Y0NlbkZ4UDBSRksyR2hrbG9i?=
 =?utf-8?B?a1pISmw1Tlg5VjQ2TTVkc0dDTFhGelZDdDhsZzZTMGMwV1J3alZIUlpkVUNk?=
 =?utf-8?B?LzhGdmNFVzltT3QyOXpsYkhkdTcvMWdpblJvdENwcjdqa3M4YkJ2YlZRNEp6?=
 =?utf-8?B?ZUlFY3FCbzlySkpEM1FjY1Rwak92dzBEMVdub0lidXJ3eTZqZmVTZTd2enNu?=
 =?utf-8?B?eGliV1dqYXgyMDhLTFFVVjNyOEFjZGIvRFpTU051ZzhIWnA5d1RpMDNmY0dM?=
 =?utf-8?B?NDJoRGI0KzBaNkhNYWluZ0FyMHhwM1I4VU5FbkpQVFNRQXp5MFJSSlR5MExN?=
 =?utf-8?B?LzUxNGF1MTFOcEFpVUh6akN3Rmc1N2VLM0xhWE9IcmdYZUFmMzIwa0RjL1B0?=
 =?utf-8?B?TUpoU2VoOTN4MzBMVURoYlY4cXpxQ2hyWGNxdjJtV2hYUUh6NXBLOXNHcnd4?=
 =?utf-8?B?dVJLL2ZBcGticFZRWDRVWEcwQ0FuaFl6Vk9JdGRDVTMrZTlOTU5WMStKcDFU?=
 =?utf-8?B?ZmxlVUVWc05ZYmN6Nit4R0hBcnBBQVZNdlowRjZUdUhLRnlEQm42OXkwcnBm?=
 =?utf-8?B?a1hqK3JEVVJmWTE0eENjZ3N3ZzlPa09aVXNxSDF6eUJERkJLdFpUTFYyTFU2?=
 =?utf-8?B?bUtCVzBnR3YyZkF5c1lGd3QrQ0FicWNaWWJYSGJyOVFEa1hCdi9kbVdZTmV0?=
 =?utf-8?B?Nm5hOFo5Q2l3REcxRjB4YTl4NitJQXJ2dVNVb0JqUzFyc0xQeFNkcE91eUVt?=
 =?utf-8?B?dVFTd3NzRFlIRk9CVkdXYjI2L3hBZmY1UHB3aUduNHAreDBIMjFadzBIWEdT?=
 =?utf-8?B?QTBqajY4b1BvbGRkUFpjcWYwL3M3Q1ZwSk8xZnBqZzJKTDZZa3NtVWlhU2Rj?=
 =?utf-8?B?Y2VPZmZMNDBlZEdjL3FrbitpV1RsL0VUdFJCTXRQNWtKVmk1NnNsUG51SW9o?=
 =?utf-8?Q?uH5Yu41s+sLbj/sxonUBhcym9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08343d57-9eab-42d5-3e4e-08ddf7c5ba2c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:44:36.1964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6PZ9Z8MxtQQywEtoMMyHoKlREudkCq6wb5rGaEg6CjHLBXTRr1trA3Ipo3U2F7UygzQAGjGQxuCY46nHojt5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Now that users can enable VMSA SEV features, update sev_init2_required()
> to return true if any SEV features are requested. This enables qemu to
> use KVM_SEV_INIT2 for SEV-ES guests when necessary.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-guest,id=sev0,policy=0x5,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> 

Should this patch go before patch #5 from a bisect point of view? Because
won't patch #5 fail because you still aren't using init2?

> Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 4f1b0bf6ccc8..6b11359f06dd 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1704,8 +1704,7 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>   */
>  static bool sev_init2_required(SevGuestState *sev_guest)
>  {
> -    /* Currently no KVM_SEV_INIT2-specific options are exposed via QEMU */
> -    return false;
> +    return !!SEV_COMMON(sev_guest)->sev_features;
>  }
>  
>  static int sev_kvm_type(X86ConfidentialGuest *cg)


