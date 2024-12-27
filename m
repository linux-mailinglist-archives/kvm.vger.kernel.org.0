Return-Path: <kvm+bounces-34394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F189FD302
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 11:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB47A3A0769
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B87D1DE4EA;
	Fri, 27 Dec 2024 10:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o8HowwWp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A115D1DE3DD;
	Fri, 27 Dec 2024 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735295420; cv=fail; b=IUQsD435tfYEUDoCHXS0DiKYVpakjjh0T2cdp8CUfyw9tuh70p+ZZ4PFN+gLtilslkKJ+PZHLQZlRqhw6wabumb2f18OwAU0rg8BrRIjzEMnHyCcRorCbQzz8fVk3ZlyiOmEGHsk4xBJyaKuCi+z8O+5diXFV8Y9U3gFLlEungo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735295420; c=relaxed/simple;
	bh=UPqGYEHmMcifN7fomhe6NyruzzJgTamhFhzJgA9qWqg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JkYGXrItjG4JcN9/EzxkyWQyLqYtiybL/dn+2gljoawu2EeGnHaeNLaWhepw8uT0TL+WVBp+jZ+DbFGTIB2uEkz+IVzhPqzjvLtYnVeN3vlyKkLVS9+z61XlJ1UfamnnKEHjA+WM3NuUnXz8qYBs+01uHBoKFQ1cb25to8Oa0sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o8HowwWp; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2S3bz/w5ldmhsr4ldmdZKNxDAXmBM2qRFoJ0GtUusNlVPOLPZ1cXyOluaLqVdxVhn2R6K+Qq5P6d/VtNiKkk5/r+z8Y6W0JTkiOriX0ao3foobhl9Gf//z4j4SnXyRh9qLU0Yd2WX9P+Qd1arUAftl8iLei+c743fZ+bKAsPAHunYreJ1oXMYTXdklTiqDwDONhbLOsrUjl4WpBBRwHn52+SGuHSrKJ6cUqoc0VAPXQ0IJwIDRY+2h6O83oinEKmcE93dWBzY37fs1LDGHM69VLpoVU6vgMnoUazpo1WAarGrhEbfYtAXrJwn/p/laaru6RY93T0v8camP06bFLzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Me/aw13L8EVauAggUcltALASqG6HUue7s1mqlfz9rQ=;
 b=df7cXfxP/C0R1BaYK8zcvAwMJMhIeuq0+LLa1NzrmGGHjLhyWxbjX01fNn9dK4jx6wvU1Nab3PZIRe9lTlHgD/+NyxezeVj5zf7v9+HlgVrmlLFPavXwFWZWNTcJhpSqnLcCMgskE5zjpvXIZ6d5RgANyoaFaaVSNxWI+1WZvRpMSoK6EEXk8s5K1jEwtkOO/eu0WShDe7CdyOocILibcRAVkrxj+yzSE/JGnTKV3t4gVKKisNk365HhPUabRvXOiBS/oVYuatXCaXc1bmi1kTtVbMtd7RrKD71U1JzyKv9I0lhR3K+pp3IZ55ELRbU7UqhnpOm1sz8Gz3kJrT6ACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Me/aw13L8EVauAggUcltALASqG6HUue7s1mqlfz9rQ=;
 b=o8HowwWpCmzJrNF7+oQHDy8QYdU4PxtFGfYQJ447hNDe+VN4GDKmjeq3G9PAuF8ZIbrpT3S19tw27vYn9NUa1k8G8Y1FmYzaxZ+6RfpkIMYayGbtAOzqe/KvNC44yk9EaOoLZkltcw1lnmK8g8i5zLlDJZyvfTzC6BVE+6aNHvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 10:30:12 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 10:30:12 +0000
Message-ID: <03e684da-c465-45f8-95df-8d70980a83e8@amd.com>
Date: Fri, 27 Dec 2024 21:29:59 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 9/9] crypto: ccp: Move SEV/SNP Platform initialization
 to KVM
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <f7129ef82e622ce52b194ab017fee9b1881b0cc8.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <f7129ef82e622ce52b194ab017fee9b1881b0cc8.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0018.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee131ec-2326-4f90-1953-08dd266171b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rm11ekEvWUFSWHpRRXhheGhuSFdyaG9ENXR4U1BWdjRhL3JRRDRYT0gxM1Nt?=
 =?utf-8?B?WHJpOWpaYWRvaTFIRDNDWDhKYTFBa25pekFtamhrNFkvNEQ1aGFJS1huVUE5?=
 =?utf-8?B?eWI3SzJzNmVlYkdBTE1zMEhJODM2MHJveUZESWMxU0lvdGVCQkdhc0kybVlM?=
 =?utf-8?B?YitkMmFudnhyenJyQ1hhWmVmSWpqd1JReVdaeGszTHFXb3BUYi9uVjRidDhW?=
 =?utf-8?B?WldIbkdHMmR2ZmNMelAvYjJDamVGRHJ2dnA4V0tKRFh0V29OU1pQb2RrTllw?=
 =?utf-8?B?eVZBZVB3cURtZEc2SUdLQnJpOGx0aU5kS21SNndPTHltUVBXdThFYS9CR0VJ?=
 =?utf-8?B?TTZOTjhsTTdNU21Ta2dFZ3hRVDcrZ0sxSXpKNjZEQmFXT1BISjk3c0ZPVW9O?=
 =?utf-8?B?eHVISTlaSkN4dWlUNkVPcmlGQUZOMXh5MVVGL2Z5d3grbVVTWTY1cnpGNnNw?=
 =?utf-8?B?RDk5ajdPSVlIaWgxUEI2c2grZUZtSWVnUWhFelRiSUVTeDk4SHJIeS91UEd1?=
 =?utf-8?B?SFJVdGxySHNiNzFoNmhqRDlNc3VaVUlmM21KT0lzT1MrckppMmFyZVJkVWtr?=
 =?utf-8?B?TVpKRkV0OXhGZXZTbHVmVG96UjZrM2VzZ2REMkQ4TCtSQmdhYXJXcDA3Y0py?=
 =?utf-8?B?YXlNUmNVREJZZFBHUi8rN2I4U3NVWG9qREkwOC9Cek1ZbmRrbHRuR0lxVnp3?=
 =?utf-8?B?ZHMrUExma3I2OTFaUitxS0JZbVJKN3IzMjFGb3cyVlhsU3BDOE1rcTYvOE9W?=
 =?utf-8?B?UjdwQjBTRFo0ZjBPR0VIeDMxS3A4bDBkdW5ZM2s1blBNWG9qTS9YREo0RkVh?=
 =?utf-8?B?RkYvaHpqdGx2QnVYYzZBRFl3a0JmUkZ5OWVlSVhibFBFM0xEZjI0a1NKU01S?=
 =?utf-8?B?SlcyRzZDbzRYaStMWGRTVm9ZelIwSFliaUJ1dFhmdFRORGFoNFI5NXZaSHBB?=
 =?utf-8?B?TjNFcUY5WUNUWit2Rjh3T1psK3kwSWZlYWJ5RkluRWYvSGhxMkM2V3FnUldZ?=
 =?utf-8?B?SGRQQk5kSWIxZmJ6K3ZITmxiaHZ0SGpWcENMTVdSM2ZnRjVFNVNYWm1oam1U?=
 =?utf-8?B?c1BzbTlabkR3dEJlWm1GU2VrZklTY2Q1TXpxNSt3VW9pMTdqNXBLY3F5VVFT?=
 =?utf-8?B?N0hsSjk4S0pYY1ZDUWszTmxIUUlwaktiRWtxY1RiTHI3M1djZWQvZ2lwZFFD?=
 =?utf-8?B?OWNFdVg0anFWYVJYRzVWMERVZVovU3BLZ2NrRFpUV0xQYi9majlNaGF6eXhz?=
 =?utf-8?B?NUFwOUFWcENZd092dlN4N0hPdWFYMzVKQnRMcmZjMXFKUkZvTUovV2d5UFVz?=
 =?utf-8?B?dGk5RERtaFNYYzNnSnFxQWk5UEVTMkVUa1oxVlBrTXQ5b1plcHVZYUFLNlMv?=
 =?utf-8?B?ckEraFc3Z3NQTkNyZ0tBRDdYMFd3SXZVZ0ZWVWZyVFV6NU9DamJpbHhwN1du?=
 =?utf-8?B?c0NnT1RTaWhEUFVrSWJSdmNEUDNoZ2k3K3pDVE5lTXZMNkUxVXVLaTdyQ2hV?=
 =?utf-8?B?RG1JOEp6b0J6UURmbktRemxBNERrbzB4emtWTW9vMFBvdzlxOWNaSCtKcnZQ?=
 =?utf-8?B?dGJoeWNTZFM2Z0grSFBMYVF4NDdScEJISnoyVld5Q1p2cjlnYTZkS0U2T0k5?=
 =?utf-8?B?c0Q1enVGNnA5akdXazBYT3h1MnhadVRWSTdvTktLa05RL2drQkRIam5EUGc5?=
 =?utf-8?B?eExnTjAySkJINU4xdCtnUCs2THNzaXB2YmUwOVlpYnhBQlN1YVpQYXljenRi?=
 =?utf-8?B?Sm1sKzdkcEpCczM0akdRUUdZRDhiZ0kxYTI3RUlCSi9NOHM0RkxIcGF6MzhG?=
 =?utf-8?B?ZmVBa3ZaNGlRQWlrZisweitSS0JaR3g4ZEp5Y2Vka2lsNi9xc0Uya09HRElG?=
 =?utf-8?B?UlBXd29XSFVDY1UyNVdEczh3UGYrcG1zNkJyMzd5ZU9pQXJFMFIxSWdMdm5x?=
 =?utf-8?Q?4aKknSEx1R0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjZxcXZ2L3hvY0lTZHpDK0ZRYXRSY0hJVzZOL2tJdTBHaXJkSjlKanoxem01?=
 =?utf-8?B?MjgzYjh3M1dMWUdGVmJ1d3Qya1JvK0tPNWY0aDVvdVA4Zm80bVRyZWRZdmNO?=
 =?utf-8?B?dW5nMmhtMVViVkg3b3lUK0lzd0V3b3hkQ3JQZnhuZy85enRVSzNHWHgyY2Z6?=
 =?utf-8?B?SS9XKzl5TlZ2VG41VFBQd2dpZG9oRDFMRi8wdEFwWjd2aGM2K0I5Z21QRXhB?=
 =?utf-8?B?TDlzWXlDZDkwWUxWSDNLYXcwSkx1ck1qTDRYZXNDd2xPd0FpUjV4TGpBY1h4?=
 =?utf-8?B?ZGpaQXFYUmtjZHlBdjlwZm14cFQyQzlUUjdDelBVVzNOOGVDTFVpU2trL1E1?=
 =?utf-8?B?Q1VwVWh3dDJ3d3YvcFZZM2pzQkswaGpFdmVGbTVKdVQrSW51SDFhZS9YMjE1?=
 =?utf-8?B?c3JDTDV3T1VGOFdWVXk2a1Y1UWRRRVR6NStSWEd1OGFRRVBadEMrMVpJdkNK?=
 =?utf-8?B?Q09EY2llTzdsQlJJaG0zTjluK20yOHUycXNQL0pBOUYwNG5iaFhRR0gyOWlk?=
 =?utf-8?B?ejdlYnlheXFwZGUwVFB5d2ZBdUlNaEc3SU1ONWtiRHdXTnQ4SHRXbmdJTlZt?=
 =?utf-8?B?RnpWMXkrazFUZFNtRVJlWkRua2FrK2hUUFgzUVZkS3JEck9EdzlvLy9HaDl0?=
 =?utf-8?B?M0VNNmVLdmoybG9EMklyWHM1azljWUEvR09uckVNYjhnMGQ2UW5Felc0SlZD?=
 =?utf-8?B?RnI3UlpxbGN4a2F4Q3NsOGlOeU9xb0cwMFZ4ZE1Dd2tGZXdFRkR0alBOYlJC?=
 =?utf-8?B?REtYalNlL0pTdDNZVWZ1dWJPeFJoZjFSaDA5QWpOTWcydlJsVnJUY3FZSFkz?=
 =?utf-8?B?bzVnVXFiVHByRWdYQzR2QisyVVdPWUwrS0NSQ2FzdjY0dDJDUnBNNXdOK05G?=
 =?utf-8?B?aVJrWG1tb1hub3FkbkpZRW14cytNQ2VmbUpPR0Z5dDZ2TnRSVU5IOXZVTGpW?=
 =?utf-8?B?bEthQWpKNVZVeU9OTWYwQkxTV2dtUllGbm5PZGdFSzFCY3ZMalBMcnJRcWsy?=
 =?utf-8?B?YlQ5WjdQUTRVU0pjR2dIelE4WElYRHQxYWVOaVFOeHVuSCtDa3BwTHluQnN5?=
 =?utf-8?B?V0dDSFMrSUxsRjZ2RENiYUJacGpWcUVPTlhLVzZuREhRK2k3MVd0MFpuZG9V?=
 =?utf-8?B?dWszWWFDZWprZEYrTFpOcEY0M3BKT2IrclpGc1B6NkJCd3VxV2RxdmhRenU0?=
 =?utf-8?B?T1daOUM2Y0kzc2M0dTZYT25sOGszcVlDMENDRGY1cHY3NjRVLzZXQXFPTkFa?=
 =?utf-8?B?d282aFJZSktKNTI5WUJ0U2p5UUpocWdrQVgwYVgvMHdPajB0STVUQkJjSGgr?=
 =?utf-8?B?aFlWNlBhV1RWNHRCekdoMWFFdmtHQ1FiMDF3M3lycFB4U0ZnU0ZyNXZ0MnBk?=
 =?utf-8?B?VG00QjBSRVVKS0w4blVicFc1WUxmT2tZaVBEL2JBNElRQVpCVi9rcEtMVU44?=
 =?utf-8?B?aWZ1U0NEOTk1dGtOcEtjSVJOMElWZlVyMWFZV3c0YWF2c3lrbHZ4S0pGQkJt?=
 =?utf-8?B?VG1TNlRRVU4xZ1lUWW5Nd0lrajJyb2Y1L3dwSUlVT1Z3eFdhWkx2WlNNT0hC?=
 =?utf-8?B?bkYyRVlWWEpNNHR3M0ZCQmJ5QkkvUGpiWkIrYVZVaEdwU2ZuaEtNTHN2dFlZ?=
 =?utf-8?B?UUNLeFFIemZBdXRoNTYzaFFqbkxHc2ZEWldnaHRIZHozbUpUaUhHL1dwc3Ny?=
 =?utf-8?B?T01kSzNYNXVadmNRY0lzWmZNRlB0RG5JKzgyWG56VStmV2FicGU3SXY5YnlP?=
 =?utf-8?B?RmJiWWlGVml3MTcyMEIxUHF3NzdaQmxLbERkYzIxSElHYmNHK1pzcnVGSGc4?=
 =?utf-8?B?SzdteTdPMFkxNnVqZ1V1NFNLNjlMWUhZWTA1ZmxSZ0thQWplMlhQQWpFZG5S?=
 =?utf-8?B?ZDBBZ0p0UG5zK3pRano3MkZkc3A1OVVxTkpHTVJSMlgwd2g4dTJmU0dMcFhj?=
 =?utf-8?B?cHN5ekRpMkFKN0JjZkt5cWUzbDhYQkJOM09KVDBZM2dFelVDVUdlajhYVFAy?=
 =?utf-8?B?eVh0TlBTWk50TzJCcXVTUFMxeXV4V2tQOW8yM1RHKzFLNzFTcHVBaDA1WThy?=
 =?utf-8?B?Ry9nNmJ4OGxxaHcydEhzazJCbGJOS21Nb2x1UE1sZFJPbEdLZmkvbGZId3Zw?=
 =?utf-8?Q?sZ+L+FN/Q3nnX3kpITEnfDS2D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee131ec-2326-4f90-1953-08dd266171b9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 10:30:12.1218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSvOW9PwU0xL9B2B/coreHIcyA5P4Br3/CZLZfz4jKus3AL7ZOWsv8F97l/u3WwYehcwGlTtEJY5qdfM387RbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246

On 17/12/24 11:00, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> SNP initialization is forced during PSP driver probe purely because SNP
> can't be initialized if VMs are running.  But the only in-tree user of
> SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
> Forcing SEV/SNP initialization because a hypervisor could be running
> legacy non-confidential VMs make no sense.
> 
> This patch removes SEV/SNP initialization from the PSP driver probe
> time and moves the requirement to initialize SEV/SNP functionality
> to KVM if it wants to use SEV/SNP.
> 
> Remove the psp_init_on_probe parameter as it not used anymore.
> Remove the probe field from struct sev_platform_init_args as it is
> not used anymore.
> Remove _sev_platform_init_locked() as it not used anymore and to
> support separate SNP and SEV initialization sev_platform_init() is
> now modified to do only SEV initialization and call
> __sev_platform_init_locked() directly.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 55 +-----------------------------------
>   include/linux/psp-sev.h      |  4 ---
>   2 files changed, 1 insertion(+), 58 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 53c438b2b712..fbae688e4b7d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -69,10 +69,6 @@ static char *init_ex_path;
>   module_param(init_ex_path, charp, 0444);
>   MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
>   
> -static bool psp_init_on_probe = true;
> -module_param(psp_init_on_probe, bool, 0444);
> -MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
> -
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -1329,46 +1325,12 @@ static int __sev_platform_init_locked(int *error)
>   	return rc;
>   }
>   
> -static int _sev_platform_init_locked(struct sev_platform_init_args *args)
> -{
> -	struct sev_device *sev;
> -	int rc;
> -
> -	if (!psp_master || !psp_master->sev_data)
> -		return -ENODEV;
> -
> -	sev = psp_master->sev_data;
> -
> -	if (sev->state == SEV_STATE_INIT)
> -		return 0;
> -
> -	/*
> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> -	 * so perform SEV-SNP initialization at probe time.
> -	 */
> -	rc = __sev_snp_init_locked(&args->error);
> -	if (rc && rc != -ENODEV) {
> -		/*
> -		 * Don't abort the probe if SNP INIT failed,
> -		 * continue to initialize the legacy SEV firmware.
> -		 */
> -		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> -			rc, args->error);
> -	}
> -
> -	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> -	if (args->probe && !psp_init_on_probe)
> -		return 0;
> -
> -	return __sev_platform_init_locked(&args->error);
> -}
> -
>   int sev_platform_init(struct sev_platform_init_args *args)
>   {
>   	int rc;
>   
>   	mutex_lock(&sev_cmd_mutex);
> -	rc = _sev_platform_init_locked(args);
> +	rc = __sev_platform_init_locked(&args->error);
>   	mutex_unlock(&sev_cmd_mutex);
>   
>   	return rc;
> @@ -2556,9 +2518,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>   void sev_pci_init(void)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> -	struct sev_platform_init_args args = {0};
>   	u8 api_major, api_minor, build;
> -	int rc;
>   
>   	if (!sev)
>   		return;
> @@ -2581,16 +2541,6 @@ void sev_pci_init(void)
>   			 api_major, api_minor, build,
>   			 sev->api_major, sev->api_minor, sev->build);
>   
> -	/* Initialize the platform */
> -	args.probe = true;
> -	rc = sev_platform_init(&args);
> -	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			args.error, rc);
> -
> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
> -
>   	return;
>   
>   err:
> @@ -2605,7 +2555,4 @@ void sev_pci_exit(void)
>   
>   	if (!sev)
>   		return;

Can remove the above 4 lines too. Otherwise

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> -
> -	sev_firmware_shutdown(sev);
> -
>   }
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index e50643aef8a9..dec89fc0b356 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -794,13 +794,9 @@ struct sev_data_snp_shutdown_ex {
>    * struct sev_platform_init_args
>    *
>    * @error: SEV firmware error code
> - * @probe: True if this is being called as part of CCP module probe, which
> - *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
> - *  unless psp_init_on_probe module param is set
>    */
>   struct sev_platform_init_args {
>   	int error;
> -	bool probe;
>   };
>   
>   /**

-- 
Alexey


