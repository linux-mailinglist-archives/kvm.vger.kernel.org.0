Return-Path: <kvm+bounces-31679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F37FC9C63FF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82E151F21632
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B195E21A6EE;
	Tue, 12 Nov 2024 22:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tqpx8d0J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE88D53C;
	Tue, 12 Nov 2024 22:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449186; cv=fail; b=LO8+iwtrz2kApRYiDR/+VErpz8eAXpx5I/Alq6d+CS69WpqbJAPcRHSZYyhPCX5iRXW9CL9ttT2RAmLUpGcYtT5jqi070g47HJhxVZW2+x9BfwV0i0K8wG5mImt11WxICm5K5GZ5LvKiECMSI6o1wSUGVzsaIruLnhqHdEP9h/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449186; c=relaxed/simple;
	bh=ljfDGF3OcZ7lPJ/8F/41h+BJz5r5EbymUrJZo9hbutU=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=iy/tzD92s1s0CDMxqXyWAVQTM+c0o77mG2U2rM+R3sbi6TsKD4OFGjN9m0NDYpp3fPdru03K5re4pDB0703rJg9f33IkI2HgozJsoR+cb0NRy5DYr8AYxMvLIyjEoggr1ksc3p+vOim4Wm3Lxp15tHYaTB/y+MF4ycDdZ6VwKSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Tqpx8d0J; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuhjyQ8CCrGKyH5dxPsDkIXAddXYTeJikpYUE0fZgwKYe17fgSaF7SEfrRK2uZUN+mtuFsI56YNKXc+v5pkmG5I8sLDsYF99bTsTvC/32WbB3itHQ1NhobpddwnrmD7PusSrYu0kGnzzfIcTnJ/ibipGczSLD6sFDDPUnuR24r0pTwwL3yx6MvqtyB2NY8oVrb79RGHY1dT2UML1Qo5z7tuH4lHZVlZtj7E3RWubvKkLrGHDf8xViFe17odTL224zOv47Gi2wNG82YDiQlaGHlr8OAXR0C3oDhGrfaudQEKi2+Icso+KXWEOhCAAr4Z8ooR5hXylZAZEs30kqIHd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QR4lxtAT7AR4OxZtEbGiqw1sYSPO//rUZy3bwbwX5/c=;
 b=aQMuRKmn+49PKd0FLBgm+fKmfMPR3zoGmi/Z34B5hFaVbmlGEalufp4vWCNUM12tFf8LJxrTsnI82qi0Axxt27lmGTV1ptvhpISP+kgNnmlMVA+EN0PJB3wAXkjOsJMk5D1dgWYf5+Q7dHeinT4QL7Qn1riYKmGN/2PFoASkQKbq0Lhkyyv8y1dzZAtGSpySyw7+/WhxxyZr8tao/+B+JWi+zdXG024gTNvjw9wVqCzXPADkCk58uoSoIDkntj+NkGfQbHkb25IZe5Yxg2D+QY40ALqvgvT5kXBZQKvjI9tJP02CSaPTJjQIorym6oVlOKjPE+Inb8aSc/U4/aisyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR4lxtAT7AR4OxZtEbGiqw1sYSPO//rUZy3bwbwX5/c=;
 b=Tqpx8d0JvrX0SIhH0zFzHtTDlofKBQNaUP1MSe/chZsc9wSb2kvlFTk9pFTQG0GKibT7EpUgMBXb/yXfyVGYXetx6srQ8mgdEG7SxOVgmSSXu6JbzFCr/2SAHFKCTDXtiNcL+boUOmdhxIZyQ0KsdbZonzXrFPQ4IP0LzULUclE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8586.namprd12.prod.outlook.com (2603:10b6:208:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 22:06:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 22:06:21 +0000
Message-ID: <a5116da7-12c7-2174-814b-f6ae76ce61c0@amd.com>
Date: Tue, 12 Nov 2024 16:06:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-coco@lists.linux.dev,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-9-dionnaglaze@google.com>
 <d49430ec-8701-72c1-36ab-4d9e612ac443@amd.com>
 <CAAH4kHaQ0hh03aSPQ1N6t4zYwFMi6f0QOOa8sQoJqnobZhSD2w@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 08/10] KVM: SVM: move sev_issue_cmd_external_user to
 new API
In-Reply-To: <CAAH4kHaQ0hh03aSPQ1N6t4zYwFMi6f0QOOa8sQoJqnobZhSD2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:806:23::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e8ae1a-cfe7-4df4-a6cf-08dd03663d95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTZIb0dDMHZKWkF4YllMS1F6aUJZbFlTS0ltMEdUdUhYdVk5SlNLb0drNTJ0?=
 =?utf-8?B?V2tkeEdYcDhtSmR6Tms2V1FRcVNhNTE3T0xXS3Q3Vy8xQ0o4emo0M3lpRjR4?=
 =?utf-8?B?N05VNExYZTdiRTlqek1RSTJIYTcxT3MyOWhCenFyOWQ0aXUyWE8zY3FNUTlS?=
 =?utf-8?B?WnRpVnBVS0w1WmVid2ZPVTFVSWFLRXBoQzJXN2VnSVdtSVNIa09STFNrb2Ux?=
 =?utf-8?B?TzdvL0s1SUdpR3NHbkdEUjdIaVBCNDQxbnQ5NW9UWUlYS1hHdkVxZjNoVlA2?=
 =?utf-8?B?VkJ6RGpCUTFaVldWVXVQZEtmai9MclovcVFkYUFzV3B2VTRBdGRDYWdqNE43?=
 =?utf-8?B?S1BqMlpuRXg5T1c5dXRBMk9CMUpSeVc1R0IySEhJeW40T096Q21CcWVkcDR0?=
 =?utf-8?B?clA5aUpXTUlWOGVGMmd4UnZOdlpzVmVwcU8yYXQzTHZXNzhhQW1IUG1pZWtm?=
 =?utf-8?B?Qk40UXM5M3Irc0I0Y0Q1bTRxUlJJQ1hKNXJUaGtaaWJCRzQvQXhRTWlZNzRF?=
 =?utf-8?B?YlFvV09nbStKYnNXUmdMR1NaS0sxN041K21Hd0t3aDdsUUhueTJGdlZkQTZU?=
 =?utf-8?B?QlgzczQzNXV0S0plN1lXSHdQYWRqNEpGbnNKWUNMMy9seU9ZaTlSa0ZlTUND?=
 =?utf-8?B?eUJvakkrTlE4UWZXTEdVN01DUHJ3cDJwSW1SbFBpeXczSmhtdFBkZXVXb2I3?=
 =?utf-8?B?cXdUeXVNRjBDYytIMTJTSFJKaVB1cEZ0UThJOGpjS2pPenZUUWFOMGY2QURy?=
 =?utf-8?B?RnJHM1JtVStJeFkrNDBHd25xT1FxcHJNWWt6ZFJScDF4YVV4Ty9YRklwQVRE?=
 =?utf-8?B?ZE1tczV3MGlwWmNoQStNcnpLb2g5MWtOWFM0RDlGeGhsM2orL2NVYms0ZzR3?=
 =?utf-8?B?TWMwTnA0ZG5BMjRaT241TWFxb0dqYXd0NktSZWhuN0xXWFNHNG55amJadVJz?=
 =?utf-8?B?OGZwSFJCV09WZW91K2V5bHF3VDkxUGppd0hMaC9yMm81QUdhQmt0S2ZUT25a?=
 =?utf-8?B?S1VTRC9iUHpyR2Q3S0Y3VXJWM0d3VEMzWEtrVWZjc0tsQ0dzWnpkSjFvKzhZ?=
 =?utf-8?B?WVRveUw3WVpqUEJieWk5eUlJL1lLRFU0ZHJTQ1o0ZGxyWGw1WnFtaG8rSlUy?=
 =?utf-8?B?WGkySldURzdTWVhLKytEU1dNcjF0NmdEcXh2dVhYSmJvS1pHZ25wLzNYdDdx?=
 =?utf-8?B?ZHhVampnS042RHJ2aVc2YXhqSmk3M2ZGZTIrWnZIR2E4bDA3dms1bTVUTnh2?=
 =?utf-8?B?Q3BRY0pDZGsvcmZaVzdrNE1ENlBoOUM5bzNkNkwyZThmVnh5SlE2Vm9zZlFt?=
 =?utf-8?B?bzhwMWI3ZDJzbDNDK1NrYTBZUW52NEc2eEtzTXIyd2xadkpWczFrTjZ5czU5?=
 =?utf-8?B?UW96VCtnUlE1dXU3RzdnWnp4RWFDZlF4ZjNDa2I2ZkJuZDlDVEFUZG9zaUNQ?=
 =?utf-8?B?Ylk4RHVxV2ZxdWdyVFZ2a3J3eW9Ib0haTEViMWFKOHIwM0pVOEh6cjFjL3hz?=
 =?utf-8?B?bHlaNk80ZWd2dUtqcWlhelBORy9vZ2R5RmdabWV6YXBJTDBtNVIwYldRalhl?=
 =?utf-8?B?d1ZkMjFoMDh3cmdEYVlmZkRQOXNRWWxwTEVkVTJ6c3hsM2pnV1JLT3k2enUv?=
 =?utf-8?B?SzdERktHdldaNzVsTGgvaXhwdWpkdkY2eHVPYnEwbHNqQ2pjNzRIajFERTJs?=
 =?utf-8?B?ZWpYd2piSHVwbGNwcU5EdjEyZUhwNDNCYmVvQjBBclZqNWNHRDlZSjZFZ0lm?=
 =?utf-8?Q?9oESSG63Pb4i37LTusnN70xyubNVEsX7vjGtJoA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0JGaVoyUlJDdmpnbFpBTy9ZSldQOXhpQXlNR3BUeCtSZG9EUm84bjduVkIx?=
 =?utf-8?B?NXpsa3FUTlkxQmZ2M1JjRWpycWozQjJTWFdjZzRYVGFEc2E0UzRzNUp1emhh?=
 =?utf-8?B?MnhGam90ZmUyUEhydnYwUmg5cGI0eGErMkJldzlMVk13MWxKZ0JJZUorUFBu?=
 =?utf-8?B?R1F0VVlITWhON0NYSWpPcFdZUmEvOTMwcWpDWnJ2K3lpYW42elo0cFRQVU9k?=
 =?utf-8?B?NHNCU2hEbCtpNk4zNjJjS2Q4QkJYd200ZGQ4ZzJyUnNubGZCS3hzaGhZSWdh?=
 =?utf-8?B?REV4REN5ekhDVTF6NU1IUUtMdkVpMjNQSWxHd25ZN1ZsaVFsYmVtU256aGRy?=
 =?utf-8?B?bUNEenEvdzA4VWRYbW5DZnRkZy8yVDQ2VUpQY2NUMDVBR2gyYi9nL3FyWVJu?=
 =?utf-8?B?MCtFaC9uVlREeWFldER1Y0ZPbm1iTFVRWkNldGtnVCt4czk1eFlSMFljeVJP?=
 =?utf-8?B?ZWFCZ09DaEVOeDYxMGVsM1l2bk9WZVAyRWlvNG5Td1JsVHRocjBCV21nT0NQ?=
 =?utf-8?B?SzdxcVNIQ1kyeUlRT3o1K1lVNHl2MUY0SWpMTmw5Rk5iMFpZRWsxUGdnZGwv?=
 =?utf-8?B?S0ViZGVxSmZRKzhzNnNSajBPdW8zbTVUNWdBaXRzOEN4c0RkYU11L00zSnpi?=
 =?utf-8?B?Z083MjViMC81MzhiZjRSOCtUNXJHSlFqUWZLWGVCOHBXWHp0WDhrMzlyNGxV?=
 =?utf-8?B?Rnc5aE1Fc1lpOEF1aXRKMFpTWVFqbzJCb2cwbkovWmt2NFJvaFVpUi9UcWwz?=
 =?utf-8?B?bXczbnUrcVk4aU9vMUNlcXY0dkg0OTVZRG9yTFI1cjczQ0hRRXFqNFZHeDhw?=
 =?utf-8?B?MkY2R0RPZkp6bjFIazM0dEVGNFBTbStQQXpMbGw3eTNhbXpPb05TcnJWN2s1?=
 =?utf-8?B?eHJCRXpjRVJJbXZ6REVVbGNFemFsb09DYTJ3TDFJTmlMa3U5SHovcmkzc1lR?=
 =?utf-8?B?aXRUT1JuVzZWekZORFBNN012NHFocGdKcVJ1YVZRN1M1R1AvZFRjbEhOZkdr?=
 =?utf-8?B?djNyRjFjV0ZPek5Kc0x6Ukt4cUdHNkMrQzZhME16MEN4WEE4K2FHNkxZSlgx?=
 =?utf-8?B?RE9EalBIam1uZUVlUXRWWDV2SDM0OUYrc3J5Um5NTjVrcEJHM3hXVEpQMHBF?=
 =?utf-8?B?WWFXUVVhNmI3MGR5WWZ1czY1SXlQMTI0RUt0SXZQYnNFYTYvQjVnR2V1bU1t?=
 =?utf-8?B?eS9NazZ3NEd4RktwU3F0SFlRU1hMQUxyOXNERDY3V3dTQzFtTjdjN2VWS3dq?=
 =?utf-8?B?VjZ3Y2drS2tnaHVrYXBYcTlIZThhczZuNjdZTmFuTDU4UkNsTHVpUXRJczBO?=
 =?utf-8?B?bHQ2SVNid0pkaHkvOVBhb3NjeEdNRk45T1Zwc0ZuZEpONkZhdlV4MHVsbG96?=
 =?utf-8?B?M2dKVGVtbWVGQVpMWVBoamswWWZXY0MrTWMva3VuSEFhODNmNGM4MGlTQ1hI?=
 =?utf-8?B?c0VVYjFaSGRBaHoxMnV5VktRVlV2UE9VdmJreGlqRkpQL3FBRitkRWZaVmVO?=
 =?utf-8?B?N0x5QmRDSFJlaXI1UG9aSzJWcER6YXRabjAxSHhUZUFEV2poYXlqaTNWTWUz?=
 =?utf-8?B?a1Zqa0wxbGZWU1ZhMXAramNJazcxR29KeFlsdFZCN24xdTBHUDE5akltd214?=
 =?utf-8?B?b0xpazlGaFAxRFdnU1lzVW9JQllNYWZmY0JRYnBXRTdJTFIxOWZua1l6N01L?=
 =?utf-8?B?QndBekdSRGFUQm1ydElGTTB2K0UrZXZTNGM2eUhheU9UMzQ0Vkc4cnZXT2JI?=
 =?utf-8?B?NUxOMmtEa2plNFVRQTluOGU1WHpTZHN0UVE4K2tlRURhLy9YU0xqVXpxYjJL?=
 =?utf-8?B?UUVrMTlVWE9IM1hqVDUyL2FzR253ekl2RTQxeDVRTERlRWlsWGRyMVpUbzhp?=
 =?utf-8?B?Y1pRWHA2NmRPWVRObXphMkIxQzgrRUNiWXI3THBvaVNJYVVDeUNiMHlQS2NN?=
 =?utf-8?B?UjBVWWFoRGVFQWpZWjZnaHBGdHVVZHppRWY3elFPL0xhZDF1WStvQ1FtbFRF?=
 =?utf-8?B?R1FkQ21EY0hXaXF3NWpLS1hPUzNoZFVBcVVibG15ZmdWcTdpWXBVL09RVmlw?=
 =?utf-8?B?eUhjWHJmNEJJVWdhMlVmY2VuK2RDeGpJQnBKa3ZSUEtNcFp3YzlqdmpYemtr?=
 =?utf-8?Q?E31Gi3pEq8SBD6QEeSnH8N/C8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e8ae1a-cfe7-4df4-a6cf-08dd03663d95
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:06:21.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+jdLfFN7aJcvR6hv2mD6JmMrDuf9kjpm2dXNBW+e+AinmDJJ5xmMgt6B1hnMN9SN00q224EQxcpoJbWrJ7ttA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8586

On 11/12/24 13:30, Dionna Amalie Glaze wrote:
> On Tue, Nov 12, 2024 at 7:52 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 11/7/24 17:24, Dionna Glaze wrote:
>>> ccp now prefers all calls from external drivers to dominate all calls
>>> into the driver on behalf of a user with a successful
>>> sev_check_external_user call.
>>
>> Would it be simpler to have the new APIs take an fd for an argument,
>> instead of doing this rework?
> 
> Simpler but I think worse?
> The choice of using sev_do_cmd versus __sev_issue_cmd in kvm's
> implementation is the matter of dominance of access checking.
> There's no need to check the fd in the activate function or
> decommission function. It's not needed to be checked in a loop for
> snp_launch_update.

Very true.

> I can either complete the removal of __sev_issue_cmd in this patch or
> move to make the context creation function take an fd. What do you
> think is better?

The re-work you're looking at doing is probably a patch series on its
own. I don't think you need to do all that work for this series. You
just need to be sure that each command invocation that requires the fd
check doesn't lose that in an ioctl() path for now.

Thanks,
Tom

> 
> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> CC: Sean Christopherson <seanjc@google.com>
>>> CC: Paolo Bonzini <pbonzini@redhat.com>
>>> CC: Thomas Gleixner <tglx@linutronix.de>
>>> CC: Ingo Molnar <mingo@redhat.com>
>>> CC: Borislav Petkov <bp@alien8.de>
>>> CC: Dave Hansen <dave.hansen@linux.intel.com>
>>> CC: Ashish Kalra <ashish.kalra@amd.com>
>>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>>> CC: John Allen <john.allen@amd.com>
>>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>>> CC: "David S. Miller" <davem@davemloft.net>
>>> CC: Michael Roth <michael.roth@amd.com>
>>> CC: Luis Chamberlain <mcgrof@kernel.org>
>>> CC: Russ Weight <russ.weight@linux.dev>
>>> CC: Danilo Krummrich <dakr@redhat.com>
>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> CC: "Rafael J. Wysocki" <rafael@kernel.org>
>>> CC: Tianfei zhang <tianfei.zhang@intel.com>
>>> CC: Alexey Kardashevskiy <aik@amd.com>
>>>
>>> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
>>> ---
>>>  arch/x86/kvm/svm/sev.c       | 18 +++++++++++++++---
>>>  drivers/crypto/ccp/sev-dev.c | 12 ------------
>>>  include/linux/psp-sev.h      | 27 ---------------------------
>>>  3 files changed, 15 insertions(+), 42 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index d0e0152aefb32..cea41b8cdabe4 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -528,21 +528,33 @@ static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>>>       return ret;
>>>  }
>>>
>>> -static int __sev_issue_cmd(int fd, int id, void *data, int *error)
>>> +static int sev_check_external_user(int fd)
>>>  {
>>>       struct fd f;
>>> -     int ret;
>>> +     int ret = 0;
>>>
>>>       f = fdget(fd);
>>>       if (!fd_file(f))
>>>               return -EBADF;
>>>
>>> -     ret = sev_issue_cmd_external_user(fd_file(f), id, data, error);
>>> +     if (!file_is_sev(fd_file(f)))
>>> +             ret = -EBADF;
>>>
>>>       fdput(f);
>>>       return ret;
>>>  }
>>>
>>> +static int __sev_issue_cmd(int fd, int id, void *data, int *error)
>>> +{
>>> +     int ret;
>>> +
>>> +     ret = sev_check_external_user(fd);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     return sev_do_cmd(id, data, error);
>>> +}
>>> +
>>>  static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>>>  {
>>>       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index f92e6a222da8a..67f6425b7ed07 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -2493,18 +2493,6 @@ bool file_is_sev(struct file *p)
>>>  }
>>>  EXPORT_SYMBOL_GPL(file_is_sev);
>>>
>>> -int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>> -                             void *data, int *error)
>>> -{
>>> -     int rc = file_is_sev(filep) ? 0 : -EBADF;
>>> -
>>> -     if (rc)
>>> -             return rc;
>>> -
>>> -     return sev_do_cmd(cmd, data, error);
>>> -}
>>> -EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>> -
>>>  void sev_pci_init(void)
>>>  {
>>>       struct sev_device *sev = psp_master->sev_data;
>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>> index ed85c0cfcfcbe..b4164d3600702 100644
>>> --- a/include/linux/psp-sev.h
>>> +++ b/include/linux/psp-sev.h
>>> @@ -860,30 +860,6 @@ int sev_platform_init(struct sev_platform_init_args *args);
>>>   */
>>>  int sev_platform_status(struct sev_user_data_status *status, int *error);
>>>
>>> -/**
>>> - * sev_issue_cmd_external_user - issue SEV command by other driver with a file
>>> - * handle.
>>> - *
>>> - * This function can be used by other drivers to issue a SEV command on
>>> - * behalf of userspace. The caller must pass a valid SEV file descriptor
>>> - * so that we know that it has access to SEV device.
>>> - *
>>> - * @filep - SEV device file pointer
>>> - * @cmd - command to issue
>>> - * @data - command buffer
>>> - * @error: SEV command return code
>>> - *
>>> - * Returns:
>>> - * 0 if the SEV successfully processed the command
>>> - * -%ENODEV    if the SEV device is not available
>>> - * -%ENOTSUPP  if the SEV does not support SEV
>>> - * -%ETIMEDOUT if the SEV command timed out
>>> - * -%EIO       if the SEV returned a non-zero return code
>>> - * -%EBADF     if the file pointer is bad or does not grant access
>>> - */
>>> -int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
>>> -                             void *data, int *error);
>>> -
>>>  /**
>>>   * file_is_sev - returns whether a file pointer is for the SEV device
>>>   *
>>> @@ -1043,9 +1019,6 @@ sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV;
>>>
>>>  static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
>>>
>>> -static inline int
>>> -sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int *error) { return -ENODEV; }
>>> -
>>>  static inline bool file_is_sev(struct file *filep) { return false; }
>>>
>>>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
> 
> 
> 
> --
> -Dionna Glaze, PhD, CISSP, CCSP (she/her)

