Return-Path: <kvm+bounces-34679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D237A0428A
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7CC11881922
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 14:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087B81F2384;
	Tue,  7 Jan 2025 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dD9r4NG6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6839319D8A7;
	Tue,  7 Jan 2025 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736260200; cv=fail; b=qkASiFH1Keddfdya07tf9P8ZQ+cPp5S+l2E6GZvqYDPdg/4J7eryUNejTPnH/RV42gI0wkj0DIjnPJl04rgg+R2665933/HF4N1XRZdzOyEoxCLoxWHX8+qDLwA8AS90+BhhtQ5u2Jv0+BDuhf/OI4RhEhEVk3WRgLAn743/+Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736260200; c=relaxed/simple;
	bh=5ZkDB+A8OIHMTyt8eloeTLT/2Dop28cF39C9NnhjZCI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YuV6A9wd3olYThuV3daNACqzkeyxOkkh35xRVYDWfTc2ssX5eWL3UpP7Fuv76fKifTIyIw03qtmpEDWOCkDjYUwv8edfpeE0QyAPdB3dTVmf0TMZv1e0qLkb6VN7zR6nATkhJ5DRh825MsipusFZ+ymDyTnxiMxvBkQ6veuVPc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dD9r4NG6; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU+wP5CnjK7GEuLQUSvw7zN1EaK16JVgnPWDdJUVsv2DWiN/IPuuREBZVAH2KITRyvIjfz51X9s5NOtasJxjadR07ZgbmaReggpKyi8gsSug6P15hsWlrNr40EjwZ+6tJE430S1FNNrABQZG9MybzbOLdyYWO8sNEWXdKEk0V0HAoRuHrhtTfUs5rKiw65fU2+u9fCg+PpK6SBXvn74ZoeQ7wkaM+lOdMM06S+gXew4HKid1CyTYS7CauG+ciBEuab0gplx3KTe790kJdaAp9nN/kNb9jLQj825dGCptg4TeKUVYuSOj73v1Bc6dSsZ8QKkgzI8ETGogBxliwfi5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANJ9+KJWJpiQd7/giNGhDffxocxldvBl2hJxPlkqYEs=;
 b=yy4Dfh+qFxRKNPTdnL7gUqPw1maR1EEPnT9RHrMVrheBuT9tSqzAx0PX/6LJVu4ryYpTeUbmgZM6ryfM6ArrIkdjdJEdqjNBYoGALlMD8x8B3yMg8ojIE2JDlx622iaYbF6/o85HzdmCnhYOIIg/Nmg683r6nnVqgt76/ErhSX0hTS6ANrKFQOgcu32kjPixpcc+GSaQuP15GNzlTW/HFjhrSwvRS0ibQvCA2T4nHt51py/ZcJM/QbW14dCthHIQHHrOfew0fOIB3DF7wljcUpO9CEfXDrRmd7+Lc9TJpGN182T83OUpPld9DS/9uwppVwxwJtT6y+Y9XcTySxEvvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANJ9+KJWJpiQd7/giNGhDffxocxldvBl2hJxPlkqYEs=;
 b=dD9r4NG6yomdabWgGCjY2hoi8NUguEEZGfWxcVajV8ph6KwSs7doV1VjPyb8g+Lb5ir9BzYursvZMUQ27Sz2RPxSKikpEHyOQiSEuvRRFKbQBpw6jHvLX4GfOgm/SjRsLj5h8z/MT0WqhWg1AZBxRXo2eyOLIVhwLUAIP0DS3kY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB9448.namprd12.prod.outlook.com (2603:10b6:8:1bb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 14:29:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 14:29:48 +0000
Message-ID: <47ea6ab2-b802-3953-2e4a-7c90c54b0f46@amd.com>
Date: Tue, 7 Jan 2025 08:29:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP initialization
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0217.namprd04.prod.outlook.com
 (2603:10b6:806:127::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB9448:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c424da-a93f-44af-396f-08dd2f27bd23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVZWSzc0M1FBUWdjbGl4RzY4d25VcWNRZkg0T0NEcEowampxY3ZXZHc5ZCth?=
 =?utf-8?B?djZ2aHlWZ2pEUnU4YVl6ak9ZSWx0cDdQU3ZGU21KZURZaS96OHhQQmxxd3Ji?=
 =?utf-8?B?WnhRdTJPMkU0NjgvMVdEWmxGWVlxVm90bityZkFVQWpxTnh2SHE4V1VYRTFi?=
 =?utf-8?B?K2tTQ2h1TkZqc1pWL1EvQ3Z5NDIzY0EvRGVPOFZyZlRrUERrVFFveDV3SFR5?=
 =?utf-8?B?aGppNVVmNS9YM1FpeDdYdmFZUmVvdnYzSWFTMG1NWHJqcE1MSDQxQUoxWnhp?=
 =?utf-8?B?S1lldkRrb2FuV0Urb3NqQStGV3pMS3FMTmVnQ09OU1hLOUVya3dvM3k4LzJ3?=
 =?utf-8?B?ZFNrS09yUkt0eXdZRWk2bkp6dlBiNkNvcXNPVXZmNng3VGlRQVg4dVpHZjFn?=
 =?utf-8?B?eTZMYXgzYTROUTV0cFFwdi9vUElDQ2cxUUpPUHhvd0VYaDJyT3lqaGFra2tq?=
 =?utf-8?B?SUhGQlp4NHg1N1BoZEwrcWpYK29Cd0piQm5nTEFtQzVScnE3Q1RoMy8wa1lZ?=
 =?utf-8?B?cERpYWliYis2QTkzU3ZZRFZ1YTZBNUlkMGw0VGZWOWltZ1Z5dnM1VER3c1BQ?=
 =?utf-8?B?VDIzVCtscnBtcUlENGkwQnNxVlFEdWtFNFNqN1FqdUx5cXJUc2lhditpTlRu?=
 =?utf-8?B?aFlCOCt2aEd6VWQ2Y21FK1M4RWduSXNpYVZoTWI0TDhnRVpTb3dtVmlPdnBE?=
 =?utf-8?B?YjFzTVMxM0VWcUEvZ1hDUEhoa0JFSXIxQVF0R2JOcHc2QzE4bWpWdU1WU1ZE?=
 =?utf-8?B?d1NKU0FzRENZZyt1NGlQL1ZaRGpOY1dZVFdoV3NheEt3NEg0Tm9KVXpjYnpS?=
 =?utf-8?B?OXZzckd4eWlQbFdVWGt1L3NQM3pNQVRQUTRUcVFLU0J4aEpuVE5OQmdWS3Fz?=
 =?utf-8?B?cHdvOW9MZ0dKNFhiRTUzTmZiVU9mN2pXWWIyVW5zdnlocUhrU0s3bHBqQ1A0?=
 =?utf-8?B?NEsrMVJJZ2xWaW1HdTRQcmovSEp4NzUzRU1qRXVqU3A3cTdMUnZqWStJQ21G?=
 =?utf-8?B?ZjYrZnhzbXB0UU5PUEltYlJmUDk1STVPZThPblUvcnJyV0Y3VE1pVUZzMTho?=
 =?utf-8?B?dWRBeTNoWHIzbVZrSnY3NHQ3THVkUy9rVDhTK01XTWpnRkgwTkJiQzJjMVYr?=
 =?utf-8?B?bGlwdHZyd2gvWkRTQnp5RFRTTW1xK2xkc2JnTWZlZkRwODRzcW1YdjRIV0w2?=
 =?utf-8?B?NjF3WU9QWFhtSDJhZzJwR1pTc0pvR251Y2ZUbmNucHZPOEN4ZEpGUmlEY2VD?=
 =?utf-8?B?VGFZR2RzbTR2YUltYnBiNFNJOGxWWE41Q0QzaDN1NHlZR3I4Z1N0R3IyMFdm?=
 =?utf-8?B?R1l2SWg1UzVzVGVudm5Bb2xYVnVIa2FJSTcwQkFMblFrQnM2ajYrYnY5Q2Zt?=
 =?utf-8?B?Z2VOK3BZNHRlZ3N1M28zVzhVV1Nyc1JuNSt6NFhBLytsbjZxZkFMdXNZZ0s0?=
 =?utf-8?B?SmpodUdOdEdzODViZytOU0ZCNC9nd3lMOVZ4MnVtbmVkNnRJajZ1K0J1ek5K?=
 =?utf-8?B?bTVtdjU5cmp1bys2d2lBbUdnKzdzUkxuRityblVMOHAwaUw5WldaaW1EWENx?=
 =?utf-8?B?Q2pDaWhjM0NkR3QxOUgwc1praENXNEk4bThwamd5aG9iZ2Vuejc0TG5VcW5O?=
 =?utf-8?B?RHhlVEpINEJiNldDaVZqVHV1dDJ2QTZQM2NkSWw2ZFdDM2d3VDRycHdCZDlm?=
 =?utf-8?B?cHIwY0NLMGEzTHBOekFJSmx3QU94VzFFTXpEd1I5Mk5oeTIyd2UwcVA5bHkz?=
 =?utf-8?B?SjNFaWc3WjF2Y2tQc1pCcW05QXdWSUJjU3RXVlFUWDk3KzZUY3BRdXZtQWdx?=
 =?utf-8?B?UWpiaUVUSFlWSkxHeVB6Z2E5ak9lTWNwLzJXMExRdUo2YjlUSTVjYXp5dWVF?=
 =?utf-8?B?bWVoUysxeEl3b0c5MHpsSjNTdHBSdndVNXVFUE5lSFNkd2Y5L3YwTThXdFhH?=
 =?utf-8?Q?2GXJ+EhcHYQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHRkZisySXdUd3JHbzFtT0J6UFZxVXprUDREajFZK0Y3UFZVQVNOZENoYjhv?=
 =?utf-8?B?ZjJJOXkzRkMyNjRQSGREcmxpb0wrZUlOa2hZVDJsRVd2YTFhRE92NWY5VzE3?=
 =?utf-8?B?MnhkRUdBU2J6MlovWHpacVcrRm1UOW85Y1IzVERBbXhZVktyVTBzaUp1Z0ZD?=
 =?utf-8?B?WTN3U3U4a1A3b3lJSVlESVVVYlVqSXBBbm0wU2VvU1FDUmlLUW92REFqTER2?=
 =?utf-8?B?bVRRU05KTXUyYWlrZCswZmdwOFZNRmIrOWduTm52Z3Roa0c4cEJvaTJzTjZq?=
 =?utf-8?B?YVo5L1lJWTZVNTRnamMvNjN0cE5abE9CK2J5SEFLd0VrcmdXL2xmNHlWdW9y?=
 =?utf-8?B?bC9LK2lIc2NoTUhVdS9IUFJHWUdjRFpTcTQxSTNyVkNUSEluV240SE1OZnA3?=
 =?utf-8?B?QlB6aTVtUStyZjVQK01BcUc4Z2tXVGl1L1ZPd0t0ZkU5Sk9ONGJrTFFLRW9R?=
 =?utf-8?B?d0t1S1U4MHhITkU4b2hFaFdGZzlGU1lJWWZhM0FHTGRHV1p5WFR3ai91UDJG?=
 =?utf-8?B?YUQ3bnpaS1NtdG9SbTliRmVTQjFQaXdmblkvVUFRZUFOZUJ0SHV5bTY3bU1O?=
 =?utf-8?B?RWc3WU9jQ0xhT1FXanNBZUtCemdGNW5oV2tTYXloeGpoZFk0WEdrNzNtQVZS?=
 =?utf-8?B?TDl3Vy9KQTUvWjVQL1JRVjNQNWorMUlwTk0yZk1WV2YzK0dJR1ZQNHFFMjdY?=
 =?utf-8?B?b2xpY0pERGI2RVJxcjZmdlhEeVBNZXUzc3J1bTMxb0MycUVsY2w2OVZKWGpF?=
 =?utf-8?B?NmRYTWdaVzZmVGVxRGhZQzc1SzhWYllnb0FaQWI2RE9GVU96cXNXb2dNTEVz?=
 =?utf-8?B?ZGdLdlU1REFkUkVuWUtqVGtGdE04YnV0RmFIWWQ5K2lTZU8ycVNHamc5R0Ez?=
 =?utf-8?B?QlB4SithVGlWN0VGRjdYRVhoYmNxdk1CQ1pzNE4xZWNmMWJOZVg3Ny9COXNW?=
 =?utf-8?B?YXpUSG4ySzNnUHlRTmkrblBxaU00M1hkOWhqeXFHQVJGMjVlOCtmMXVkSEZy?=
 =?utf-8?B?Zm12bTlqalNtUU9SRTV2ZG9RZzE4Q3VFVzRuNVVBdnJMankyaHBXbDZ0bXFk?=
 =?utf-8?B?b2JDcDlzSlI5Qlh1ekV6SUk3OEJrVU9OTVJEYXJQUk5nYnFTa0hqbzFURzV5?=
 =?utf-8?B?cmtmSWlIbkw3bGlUbGhTS3NHSWMxdEdZUDduVCtLVmdVS3BnVENrTGtwMXls?=
 =?utf-8?B?cS9aZ3d2YU9LTWtOMmtFTkI5L1BGUEN3dWkvUWZwYjFOUXFCeG16ZHY3MWE3?=
 =?utf-8?B?YUVEN1ptUnpoWE16d2dac1gyMWwrSVppQW1DZTkwRW9XY0RKRUZyQi9GR3h2?=
 =?utf-8?B?SUJzbEt1VVJzSHdxemQweDVpT3RvK243SlYxNDRKU3FYTEkyb3JiNkFMalow?=
 =?utf-8?B?NFFOdG1Tbms4YkpzdjVYMWFRei9RQ0pVTk9FajVMcnJYZmxBaGxwTW1xdzRU?=
 =?utf-8?B?VVhDRm1OdE9mdGtlSXVHbzE3QzJoeGVKbEdlUlVrbDRnTmNKenNxTnNDdk1v?=
 =?utf-8?B?bU5oZmpUUXZuNExzNkFvY0NzWGtOK2VndzU5clhLNmt5QjR5NzZkeGdWZWE3?=
 =?utf-8?B?bDZlRTRBQi9sdHlCa0U3cEMxZXZwbFl2NkFwRjFxRTBFeGVWa0lRWGZCanA0?=
 =?utf-8?B?TWZCTmd0cGs1MFVvSzNsYlZoaDVHMWRPUUF5R3I3RGsyUk1IRGs1aVdaWmpr?=
 =?utf-8?B?YnovN0RpckZLSWhMbFJpWGpmTE1TcUpFZGRkaEpEN1ZRblJENEpOVVh6YmZ5?=
 =?utf-8?B?YnVYV0I1MkJXR0dVVHZXdjJrMTIvTE15b3gzT2JVSk0vTittK0s1bkpWNHhi?=
 =?utf-8?B?UVpuSVJZT3d5YWpuQTZlbE1odE9JR2JSMHdqanFvcktHanp4eDdWTWRJVW9B?=
 =?utf-8?B?Zm5GNGpYTjQwQURmWWI4dkVqejlkOWxjVnlBTjY1eDJCbW5Ca1czTnJlMit2?=
 =?utf-8?B?Z0tDc2ppQlVramF2RGdUdi81Q2t1V1h6QUFiN2lwV2FSU0Vtd2pocE82d1Ey?=
 =?utf-8?B?VEozNDhGczdVVWdNdlhyU1NBZGRPK2Z6UVhMTmtmWHlzbjJ1enAyUFBTNGxt?=
 =?utf-8?B?QlE1VkljZS85K0RMcnlmekJBbjN5ZWZOUXdXdjh4eFdpYUlJWEM5cEcxL3d1?=
 =?utf-8?Q?Iz1LHMstHF1CnFxFMfsFLCd6D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c424da-a93f-44af-396f-08dd2f27bd23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 14:29:48.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c03OMHswlyqLjg+Jw+xNCrBbQQMrIf4Vfssndo7jUGzSn8IurjWlc/ODeAIOYbG9/0A+BIOG+3t/y6n7pskVsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9448

On 1/3/25 13:59, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Remove dev_info and dev_err messages related to SEV/SNP initialization
> from callers and instead move those inside __sev_platform_init_locked()
> and __sev_snp_init_locked().
> 
> This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
> to call __sev_platform_init_locked() and __sev_snp_init_locked() for
> implicit SEV/SNP initialization and shutdown without additionally
> printing any errors/success messages.

This doesn't take into account Alexey's comment about which command
failed. I agree with him and you shouldn't use a common exit point.

Thanks,
Tom

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index af018afd9cd7..1c1c33d3ed9a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1177,19 +1177,27 @@ static int __sev_snp_init_locked(int *error)
>  
>  	rc = __sev_do_cmd_locked(cmd, arg, error);
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	/* Prepare for first SNP guest launch after INIT. */
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> +	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
> +		 sev->api_minor, sev->build);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
> +	return 0;
> +
> +err:
> +	dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> +		rc, *error);
>  	return rc;
>  }
>  
> @@ -1268,7 +1276,7 @@ static int __sev_platform_init_locked(int *error)
>  
>  	rc = __sev_platform_init_handle_init_ex_path(sev);
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	rc = __sev_do_init_locked(&psp_ret);
>  	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
> @@ -1288,7 +1296,7 @@ static int __sev_platform_init_locked(int *error)
>  		*error = psp_ret;
>  
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	sev->state = SEV_STATE_INIT;
>  
> @@ -1296,7 +1304,7 @@ static int __sev_platform_init_locked(int *error)
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	dev_dbg(sev->dev, "SEV firmware initialized\n");
>  
> @@ -1304,6 +1312,11 @@ static int __sev_platform_init_locked(int *error)
>  		 sev->api_minor, sev->build);
>  
>  	return 0;
> +
> +err:
> +	dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> +		psp_ret, rc);
> +	return rc;
>  }
>  
>  static int _sev_platform_init_locked(struct sev_platform_init_args *args)

