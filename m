Return-Path: <kvm+bounces-34470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2015F9FF635
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 06:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5DE6161F6B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 05:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDBC18BBBB;
	Thu,  2 Jan 2025 05:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E0h0IF2P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A2E17548;
	Thu,  2 Jan 2025 05:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735795271; cv=fail; b=AnyTaBLkqQBcur/O8Y9Y9w7itwq1XSkGf8+9M7pXl+ICmbG6QK13mKevPDJWphroH+f+x3bc3SF7pXKFcoEcr+9A6CToOByxMDsUAKLorrcffVTuJrAmBqEtuVHs6Ui4kA8MgQpeiR6YqSIkho0xTkvxMSD66+M2M0ZVYvBhrIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735795271; c=relaxed/simple;
	bh=m/bytb19y5uyBJJd6IWui4CMfn6G7jZJKJC1geGLIpQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PJ3eQIyJkrRhIuVuN8xdKIyHc7ZNhV0ulqLkBkXXWcvBub8AP6PxWeyFYwaqpxUQZbsPNo3p99gvvdz8VSnzDHWRmFEOGxshL+tVU0eSff/d6HsH+M3nmMV/NU6KB+YlHbPRw/u4DReNxsj7yxSvZ8HKLMU+a9oDSQbOEmc3O4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E0h0IF2P; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P0/Y8x6EC7GH+N6OXS4Tbdm3A4yoRcTARe0e53mUrQrhDVBOKhNrzmL6sgknOkPVNzb1i+DhXUmHjU12d59nAwOgealtATnAnOa27L3gKj0M6WGa4UWGEX4BZoMiRHAI/BZKzae4g8aOtU5Go73bP+aSKG1C8SRfhEeJBl8vVNaaia3SC352UfVzNuqmZ3iTMTeKxUvonqtShI+Q288ztarGUFxIjXdvdXUTIHNXUTWpYQOpnauvKe+whpydiOoCEW0RXNXyNGzZP04AxIgqT30WNmTWxgv/M7NDmjlqNdr7mhMh9v5pOlfabGB9KJpjK7uVBCB5sncT1VSvFkP+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQgOHAiqnZSulXlBw5VVKgZ6ZugO6zmnKlcjRmZ9kHg=;
 b=ISXm4W4W+yTatmm1d012jYsOy0+xRObVtDSdzx5swk4ysCH3bKW4p8CMcpf8hFacXlUY/9GBHOPod1sKxIfMLGwKQ0Vo+UIXPpzS6q2DenVeE5lspkQj0XEnzDaa6L1mEk2r86dBBV2Ma646+Q0BAJqVIG5jjW5yF0t5Fxr5fp29udAwfUmGWrFRV56aI24Io71oi8EL6Z+mlzWf3kicGhThWoBZ1EHoCOUjT7xrcwZeSTUuY/diny/QqAf5tCIJkIJ8gcHX6R5KRNct1/mN+RZyv8FEn0u8fzGzomApWBph41cr3cuuF3VNNkMX8hdsVJ87zz4/VyNZ56iXDVH7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQgOHAiqnZSulXlBw5VVKgZ6ZugO6zmnKlcjRmZ9kHg=;
 b=E0h0IF2PAA6LPnoQkUUUioixuiap12QGnG7NLYW1aFDd+fvIk1qHhnT5ajVSHE4ijv6xM2kx+ax6h++QK24sUgqTabeOsURFLrK/pKgrD+ugQD/1RRAWJ1hUTohHIxUCvY/swqTHkoLZssJSJ98srakhlmW9pEAwTf3LjGDbNqk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Thu, 2 Jan
 2025 05:21:03 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 05:21:03 +0000
Message-ID: <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>
Date: Thu, 2 Jan 2025 10:50:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
To: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
 <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 07d1a446-60ea-4ad2-4500-08dd2aed4020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0RZVmRqOTNjczRDTkJUZ1JFbGdBM00rdmQxS29QelcrL2w1MG5Oa3BGNFRY?=
 =?utf-8?B?U2JVWFVwbzZUQnRNVG5ZWEhMdURFNVNaM1pMd1BydkZvZEZtcG82Q2xCNHhD?=
 =?utf-8?B?d3lpV25mMnBMZ1A2VncrSUlyZ2hYVXlUNURIalZBa1I1bWoyQVZ0bzRsWVll?=
 =?utf-8?B?T05TdzJNME5yTDY5VXBxMmRrb2hMeVIwOVhBYTdjQ2ZJTTdGVVBDd2Q1NlU5?=
 =?utf-8?B?bFVaVU41U29zYVZwL0Q1NDNyb1VqMVN0eGdZM3RGRFdDWHV4WHcvdWlHY0tP?=
 =?utf-8?B?bUx2SGZPc1hZdDRGUGlVWmtFQlFrMDk4YUlybG1SV00zeVZtS00wcVhyTm12?=
 =?utf-8?B?QnVROTFGQXB1ZmtnYlUxK1RYRW8xRldmVUFWOHdIa1oxWVNzblFsUWg5RHMw?=
 =?utf-8?B?c1BsenAwTXAySmt2MlpqcEVSMDJyMzRPeml4bmtIa0pDa2htWVJjc2VHL1FU?=
 =?utf-8?B?L2EzcFVLcVlWeHluTmxCSGdmRGY0U0R1aTQrazY0b0lScTZVWk1MZ0RWVjRl?=
 =?utf-8?B?R20ycFdCbkdxY2p3MTJEZHZxaWdKVVRRTkM3ekY1eU9vcHlrTStQeXpTaERw?=
 =?utf-8?B?SDc3MFA0N0Rqa0RVQXZTWG9JTmVDV2xUSVl6UVRKUHluT3ZUVWxJS3N6ckF2?=
 =?utf-8?B?bVdJanpHR1l6WXBBYW5POGtWaUZ3VWFWcUJHZW8zZE1NOEg1L3hhMFBBNHN4?=
 =?utf-8?B?aEZHZ2dVNnlkRkpHQTRWMXZla3pGWE9NelkzcWU4ejlwVVBmb1Y1SUNLQnV5?=
 =?utf-8?B?K0J3Q1FIWFVuNTRIZmd1dlJsU1BqengzSUpacHRTUVhrUHNnRThUQi9nT2g2?=
 =?utf-8?B?UWpWaldjOFU0RkpaTXpCV3NVVnhGckRjN0twSkl6VjNaWFBEbDN5NzEvODVB?=
 =?utf-8?B?anZvUWd1OGFLU2pyK2o0ZFVsYUwrTWMzQ1VNRG9RRTNDVFBaTDBlUDVjT1FM?=
 =?utf-8?B?b2dXVzBnQjcrcm5YSWZZUU4vOG9sMXBSak50Z1Rya1RaMDBWcUw1a1lZTklR?=
 =?utf-8?B?dkZhU2lpclBCMzRKK3h5NjVwU2tFZkpZWHI0S1BkaGlydXRoalR1WW9PdGVo?=
 =?utf-8?B?Ym9vck00eWx2V2V2YWZ3RGkxQzdZc2xxS25pMGgzdVhSakQ1VzJXeDdXcVVD?=
 =?utf-8?B?bm9lVUkrWitUQnE1K1JhWUUvYlR0b09ERk9KVksvM3pPa1FXWU5Na0YxMXM1?=
 =?utf-8?B?OW8zTlZOTHRMUjB6MHpiMVN1SzFGaFQzSGpNajlvK1hWY3hDS3ErWVZKRmUw?=
 =?utf-8?B?TUMva0VJNDY0Wm1UY2NHT2hHMERreTMrdllic2ZoSGlwWGRPRkh1TWI3ZkxJ?=
 =?utf-8?B?THZIemFETm1RWFpLZlVreXBWMGcwWkVyaXBCT01uRlhzaE1aZDFjMHRMYUQv?=
 =?utf-8?B?SU9zT2o5VzBqZjF6TGxpZHlCZUk2eG5pc0xkbVNicXhXNmtUNnhsRFMrYnlT?=
 =?utf-8?B?ajA2bXdOekNDMWdiNDVMMnJxYm15ci9ZdTVielIvS0R1aFp5N25PZjhLeWpY?=
 =?utf-8?B?TzhFbHJBckt1S05rVEkrdHVkcXhZL1M5d2doNWIvUElWZ2dVTmVTRkRuQWd1?=
 =?utf-8?B?SHlMUWRHRFVQb2JxMFByOXJNbkxpTTIySXBtYXFsanpvdG4zNFZuTVc5b2No?=
 =?utf-8?B?QUw0VzdIMk1zNVNjbXFQejl4RnVsZWxyeU10b3BsbGZ5QllnV3JTYi9WOE9i?=
 =?utf-8?B?eGFKMEJaeXplMWRiTDJaZlhqZldCTmFSRVNMOGRoT29sK2pqNHZhcVI2b1Y3?=
 =?utf-8?B?LzRnSnZ2WHhBVjJ0Vy8wNm5ScHp6c0VwK3FkVG5wUkxPTEVjTGhDZ2s3NGRn?=
 =?utf-8?B?aXVUa0hqVllwV3ZwOUpXV21TK2xiSnJ6UTVVNjMwYlJYWXg5Nk12VXREK1J2?=
 =?utf-8?Q?HUHKqjfQWMP5Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L285MVU4Qk1vU3FLeVNZM1hkWEplc0szaUUzNXFIdlZYZjdNRmhkc05nSDZY?=
 =?utf-8?B?UEh4UHloMXpQNXcveWhIQytTSUF4S2VObDlvQjNUckRSYlZsbkJROEE1dmht?=
 =?utf-8?B?UEhVSm8vMlhoSjlQSHRnRmh0NEtMRUtUREJ4WHVycDQ3OVRXV0NSdmQ3ZitL?=
 =?utf-8?B?bVlVbW1oNFFSZldkQlk1QzFDOXZmVmNZblo5WVJqK0tHNFlib2cvVDhvb3F5?=
 =?utf-8?B?MmRYbjBCbGFKQXFiQW5teXhyTFJtUndRdXJWQUFpRDNoeXVnbFJpTVN0c0l1?=
 =?utf-8?B?UDRNMEdzTWtSb0Z1UVB5SVhQWGpHVnVXbzRVWExoN2s1U0YvelFPZzNjRlRx?=
 =?utf-8?B?dGIwUEV3RlVXblRya1Q0MFYrTHMvQmtTZUhhWFYyTG9LZStFUHA2dWpremFl?=
 =?utf-8?B?bWk1cDZLMjNBUkVYN09UZTF1cTlzZm9OQmFPdkMrYWM5TW5QMklRRDBBbGk1?=
 =?utf-8?B?V2xkcnZwUkppejdXOW5YVHpoY3lEY0Y1L2xsMERxdHR5bXFidkEzVThHRmtD?=
 =?utf-8?B?clFZTXhJa005S0pUM0VabCt2Z00xZ1R6NkRGYm1nUXgvK0g1czRjdmQ4Y3l2?=
 =?utf-8?B?cWY1NmQxTkxxcjBRZmxuMW8zYXI0bnFyeExDcmJxbURrODVVYWtjWFRpZXkz?=
 =?utf-8?B?cUc2aStOZmRjRUZqL2ZnRHlnN1FsZzBKUlA4Ky9SNUVMRHgvMzgySTBhTldZ?=
 =?utf-8?B?WHBWZzhLN0ExTHhMUElqRUFNZC9memZaak9FQisrbmV5MERmallzK0UvMm92?=
 =?utf-8?B?b1pSSUFaUE5EcnlZK1BKd1V6WVpsVmQxeUhsazhndm1HS1JPUWhYTy9vTnBw?=
 =?utf-8?B?dEEvTGtqbmZHNHJsazkwY3NyMkdqamEvUFJ4eHRZKzhjNmZLZ1hmYUJSVnZW?=
 =?utf-8?B?S2FISzJ6RmUyZS9XY3JEMU16ZnhMQnhSUjA2WG5obGdWRHV4VDRNdGVNY3lJ?=
 =?utf-8?B?THMrdHRHRHA0YmhmdUVBUFlZa21tOEF5MnJqQnZkRmorN1dINDBrc1MrUEdV?=
 =?utf-8?B?NVgyMmM5cEltWUNZS0xlRUI5ZFlObG9QVFVwUzllYThQOFNyYjNYcEJjdjU1?=
 =?utf-8?B?N1dndHFleUk0MmJSdXpVaXBDd3NJQjlTekxwam96SGxyNmxyempYSGZJRjNB?=
 =?utf-8?B?dUFmcWtUYkNTNCswWmJLOCttbE5Nc1E4aHBxZDR4dm4rUFAxV3Rva0pOWXli?=
 =?utf-8?B?MlpTMGhhb0hIYmpsTi9BSkp1MUJTUFd4eFBPbXJZQ1FOSE81bkVWL05HUWYr?=
 =?utf-8?B?L2wvUjQzWVhjanZYVDMxTXNKZ3RPenE0bGpScTJITnQ1UFJoSHVoN3BWZUlZ?=
 =?utf-8?B?YlF1NE40bzNsOVk1UmJ2VnVndEU2N3ZSd0VHWGZHTXhCL1hMT0lGak1VYmkw?=
 =?utf-8?B?c1piVnhVcUJkZEtDWDJkQWtqVHdQakxuV25BbzR1MzRLWmhPTllpWXZVb2E2?=
 =?utf-8?B?Z1FPdTdBTW9BbXYvKzc5UjJObXBPbGJoMUVWbFZZNzFoZG1MV3NSb3Ruc25R?=
 =?utf-8?B?Vm9UaGhRWXlHYXk1RS9FeUN6S2JGNXhoMXRiTmJweEUrREI4a1A4QTBsZWtn?=
 =?utf-8?B?SGpYNkNlOVNSNGVoZlNuVS96N0dYT1F4ZU95MjhxZmNkUmRRMnN3TCtuYnNE?=
 =?utf-8?B?VDFmOWxZNENDNlBaMFdaWnduMUE2Y2dLb0dQb3lvTnhtSTdPczJFbEZPZWc4?=
 =?utf-8?B?Q01Jd2wwbDJ6RjhUK2UrTHREZUVOWENQTFBQdW9QRmlLQ21XbTJ3eUluM1Bu?=
 =?utf-8?B?MWFFemJGb3pERHJhUDlmd3RFczM2MnYrOFVYaUhtQWN5L2xmalhlblpKelYw?=
 =?utf-8?B?SmpRc2ZwR2ljRDFBaHhVS2E2WUxjZWRJUzkxV1V4a1FhR3pWK2U4SlM2aDRK?=
 =?utf-8?B?TFVqM0p5QithMWhPZWEwMkhtZlA1ZFhTaVhka2wwRENjY0c1dXZNcG54ZkFj?=
 =?utf-8?B?cThHM3MrZ0c3SkVxSDEwbFptUnIxUjV5YUFxbzJ5MmlrYkxnNGxwcjBQMlQ5?=
 =?utf-8?B?Y2lBUml6bDR5cWFWZytPeklxdjNlRnNIRDNCd25Ea2JZLzNSdjhMOElSbnl5?=
 =?utf-8?B?N1ljcUsrUW1XNndkWWNPVjRtNEhVdHVkOHk1Tk9pdi9Sd2R3ZW5ZZGQ4N0wx?=
 =?utf-8?Q?pS9nEhAH6Humr5R/yhJifCbkN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d1a446-60ea-4ad2-4500-08dd2aed4020
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 05:21:03.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olpw2NSkLL4q97FBfjPw0PW7ZOy/ZA+ivTy5niDXVfEPudWWAg/K/zuUKOBZwEUN/ydmVAhsBSZrvNQIC59iJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206



On 12/30/2024 5:06 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:42PM +0530, Nikunj A Dadhania wrote:

> 
>> Upgrade the rating of the early and regular clock source to prefer TSC over
>> other clock sources when TSC is invariant, non-stop and stable.
> 
> I don't think so...


This is what was suggested by tglx: 

"So if you know you want TSC to be selected, then upgrade the rating of
 both the early and the regular TSC clocksource and be done with it."

https://lore.kernel.org/lkml/87setgzvn5.ffs@tglx/

Regards,
Nikunj


