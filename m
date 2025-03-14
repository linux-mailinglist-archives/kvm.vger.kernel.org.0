Return-Path: <kvm+bounces-41115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5576A61B3C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 20:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E470F420BB5
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321BE204F84;
	Fri, 14 Mar 2025 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VxmTGVUi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A91FDA9C;
	Fri, 14 Mar 2025 19:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741982385; cv=fail; b=EWFFqONV+H9L9/TYYxfOx/3Nk5BUzA6LxDTZAKCowRv1y0jRu/60drYsseNlPVKrEdnc4FLsHaahy7Cvahk0Zl7f+O+E+ZZfzTPNKitvOdyLzhVjSl5jEBTNS01XPgD6/dvFH7i3/gvDDuxmtcJLYb1RRbZTcsQzayqZC3x+p+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741982385; c=relaxed/simple;
	bh=iPtFHs6cutCMYME1GfWlIE7QgL5i/jtzKI4I7E9jUD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vcm8n45A+krN5N3ZKxxwGxo4/5U8nD4yBqk3Qn5DTjrtzkCD4exkurxCsTGmxnk2TIWFHDI5RpZnwNs/pziZ1ruyjatDAc0fnK9Mng9q2wrHkUdkF2W3jEQ6WLnaACv3qISv9WtPUaiLQz2mngg8M4ZbSdAyCfz9MUGGlYNaJ+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VxmTGVUi; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRapYZAEYlovYR93YCqwC+TVvxIbR0mZccALCqDjV353olV17lZTjj6MvvSKPUXqC6QwAhZHZIEs4dG59nwCHkcXpG/DZmvQqyq4V8UOf2SbIqB+M8tzjAsy5rmCIiTp9ysE/81NAnseTUVHWeuldIT329Lgu0b91QWmnBzr1VaKkIsb8ow00PuHerm7A77kSCgYsvK2P9WfrCA3nHLnBsVgPFFsLo5j2LnLw2gLOP2LB49a0glLO1igkGuzcCvpQVSrFUJ88E4DHsy6MJrzFBBH3j5uPtHffvxv48mw8OzCp2LG5whoUmSEaXU0IEM8nhZDL5XBUbj+xlF5XHyFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOiy3Fe5Hwhe7QaUwhBgp7LwT3DvXNItEfxKBPrM6bM=;
 b=kUj7WZTaZnjXik255a4DB6XM/ozT9cUA8ZPuTMPxEEIR9uY2uA/ayWqfNJhw5VCS452QCpC1JyXuOWUfyEt0Y1Zn1C1/uSDQRWQcCeaDd+16/zv/7J7i/Agxa9/ZqVuCbbg57KuQ5OmQtcfiLkV+/b9f9c8zGSfO0sjJ42O0CbmJlwWxgg8RHEHIB/qjOQlcH+a8Zz18EUkvUJeTj2PLgWRvWHDXil5EyY69R4rNyiqy9Oz8aSFgX+WbcMahIBq6IHlbEy+d4MWwycCChHyTMz4xNSZu4TRkilmQqskJxIXn0rMTdVSciXbTJjg9mN64VhQXtOmr8pPza+lw1TiJEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOiy3Fe5Hwhe7QaUwhBgp7LwT3DvXNItEfxKBPrM6bM=;
 b=VxmTGVUi8Sv88SPpTUsDo43Q/vME6yLVI+4N4MZJH/HNJBV9L/WqhXk3bu1X3TFDBOzcdjjGyZYjnna8Rl/RD/Xusy8ci3ZofSOlM1sb/S85GC4U3G74oIl8jYLTjzq82DlaM5IaN46rNjDlAE1FXsj+fHrjzUTR/A1cNJBozUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Fri, 14 Mar
 2025 19:59:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.027; Fri, 14 Mar 2025
 19:59:40 +0000
Message-ID: <24770143-28e8-b4c5-5377-2125bdebe6b2@amd.com>
Date: Fri, 14 Mar 2025 14:59:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Naveen N Rao <naveen@kernel.org>,
 Alexey Kardashevskiy <aik@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20250310201603.1217954-1-kim.phillips@amd.com>
 <20250310201603.1217954-3-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250310201603.1217954-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0121.namprd11.prod.outlook.com
 (2603:10b6:806:131::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1fe031-c3fa-4892-3b4b-08dd6332c19b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SERYL2c2a0JabUFEemE0YUc2L256RExyWWpDaWtXOWZmK0x2K0w5M0p5ZW84?=
 =?utf-8?B?WXF0V2JpanB4bUFZRk52TjlaNVYrRGlJenJaUGk5eVdtNW5zUzU5NkhuSTJp?=
 =?utf-8?B?dlhpeXJVZzFDdnM1V2hxV3h1QXdQYWx2MEdmUE9FcnVKUGFlejRFbFRiVUhK?=
 =?utf-8?B?QkVSYlZnNXR0cEtUYnVaRlh1TmdHZFVBbGhUTTVkdGpFUEtoTmYyN3JGRklh?=
 =?utf-8?B?SXFXZCtPL05BUitLaGNlazEyT3BUelYvbkp4UWdyYjZTdUx2ZDA2aTRjM29m?=
 =?utf-8?B?RkFBM1lsSmg0WFh1Q3o0c1V3aFlEcFJSc1k4cWhKSkdNelJvTWJ5M0ZaVmpW?=
 =?utf-8?B?LzhmVnMyUTFWMm9xNzNkaHQwVy82STRlbmNTbjJ1QnJLTzlNRnlpV04rQi9w?=
 =?utf-8?B?bUdtbHdqTTlVbmRtb3k2ek5NMVk0V2dpbi9hWUdmK2VVa0RyS3NnQ2VQK0Vz?=
 =?utf-8?B?NnRnOXM3ckZxMkhBRitUV0tJL1lBaUJJV0srVm9WYlEwS0U5UGQrLzh4ak1P?=
 =?utf-8?B?bkN4ZVJHQXhwa20wTDdIME5oVk5GbDY4WFh1TnJKZkQ5NGwyNDRWVHV6R1Ay?=
 =?utf-8?B?bE5vNEc0SzNtZVVuY0ZwNkFJbFRqOEhOc0x3T1hkWjRFb0d2WlJoRi83YVEy?=
 =?utf-8?B?VGJMVFgyUS9HZnhHNVJGRDVKQk1hWjhQLzhldmxLaWRhOGV2SUJHYzR5Mld2?=
 =?utf-8?B?VEpXTXhWWm5TVlFudkFMWWRtUVFBR0xGZWNseG5saXo3SjdRbkg0QzJuQnh6?=
 =?utf-8?B?OWZtK1UvMFZPcmJZdXdveVNJeUZMS0RGd1VMamJveWRobXprRkJpYTR1cm9s?=
 =?utf-8?B?UnVJNW5rWDBYNkRNdGxyV2FGMjVaS0UyTE9vS1REdXh0VjFNQXgwM0JZVTlG?=
 =?utf-8?B?Wm02VCtKQ3d5Mkt4WDMwN08vOXp4NVoxbXJqTGZvVlpDUkxEUXd3dmhDRVBk?=
 =?utf-8?B?YzZ0bHpnQkpyMEUvQTdCWklKOHdmelI3YlJRU2dVYm1xSThNQXRGbzNiQ0Ja?=
 =?utf-8?B?OTRvaDlDQTVPQzEvemhheXUzVGZGenhVOFJGU3VoVEF2SytqaHhlYzJCekVD?=
 =?utf-8?B?cktTd08vUjJRc25LWlMrNjl6QVZxdG42WkpxYTRMbUxWN1FDdmtWMGpLd3lG?=
 =?utf-8?B?REV5UGZ3Q0F1YnZmcXY0UHJzL1FmWjVrRnczdXZ0cUhhWnVUbXFWWlRxS1R1?=
 =?utf-8?B?NUM0cmtoVnBjd3VDU0dhd0dBYWJoTjY1RlJQZzNaMTd1dHEwSVlrWlRhbWdW?=
 =?utf-8?B?K3YwYWloSVo1eVB4NWEzUVRRRUE0UGtlNWxaTEZvR3lSNzR5N3B3N3pxQ3Qv?=
 =?utf-8?B?ampWMXNsOXZBNkZ4WDZPSEtnY2xrelplZjdWUkZva1pYT3JaemFIb0xNUEJs?=
 =?utf-8?B?eVh5MGR3K2dOd0QvclEwNTdrSktQY3hKYzhIWHZyRTkxd1Vqd1RCZXF0bDYz?=
 =?utf-8?B?T3lYdktTcWljQ0tvM2hlYVhxN0RpNTBJSGxaTU83UUZQdCs0MFhKQlVDQzRN?=
 =?utf-8?B?bVo2b3czWXZyb244NWdqamI2VEJHYVZhakRwQjhBVjMxZ1prL1JJS25YcTRy?=
 =?utf-8?B?MFJYaTFSUGJzUlZNVlBkWG5RamFYeGRjWEVWeWUxMWxSTm1GUkFsS0IySHFM?=
 =?utf-8?B?VW9kM3dTUzJaZElRK1EvaXpUbk1LYjJHeW4vMG1MYTE4eXd0R3RzTWtXRGYy?=
 =?utf-8?B?cDRadmxVVmE4eVhaYVRtZGJHQUR5NGordG01bkxBdklGZUl0YmpzQzBWQWNX?=
 =?utf-8?B?aFFlR3kzUS9QdHUrTjYwWDN5bmVKdlU2MVlZaGxZaFRVWHVxWWZOYTZMNWdD?=
 =?utf-8?B?OWlSMGd1SDBTc1JqcnlNRW9INGNsSEFDalpWQlZjbW1YOGNJcTFGa28wMHlI?=
 =?utf-8?Q?2ZHhQ58mUAuc6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkhWQWhOYURUZVpXQXRGWWlINC9udkFsV2F5WXltYklaRTA3Y1ZOaFRwMFVV?=
 =?utf-8?B?M3IyYnF0Q0lDZktjV2RWQ0ZTZTN5ZGd3TUJVd3lscnh2OE9xdk1qa2JmM2lK?=
 =?utf-8?B?Y21IMzhzSkNLbFI0MjRGQ0lrK1daWEZzV2pIcFhmdXNEZk1samNyd0NOeEYz?=
 =?utf-8?B?MEVJeWk5L3BHWUtkWnV0TjVncmliU2VBc3hCZmREMkdMUkFBOWpvSkFHUUIx?=
 =?utf-8?B?R2F6eXhBbUZSQXp6U0FBUkI4bG90WnI1ZFZCZzFmZ0xIdXZ4cnhZZ2RnSzFq?=
 =?utf-8?B?SnEvTS8ySXZoSGF2akxNRit4akliNVl3VU0xcjVjNDcxNlZYWmxuMng3bFJr?=
 =?utf-8?B?TEl5OHpOWE9jUjJkRVlPckVTalBpeUdMM2s0SHhrM0ppbm9HdHREdS9mTHN3?=
 =?utf-8?B?QWphZmdaaGRIQ01XNTBMbUNWN2plV1lqSElaVlo5dGJZR2FYTXVDYk5WREE4?=
 =?utf-8?B?Uzc3VWlDUUFadW11ajdBVDRkSTFQZDB6UjFZNEYrMGwreFdHT0V6Vjl5SE5K?=
 =?utf-8?B?L0tqR1NJR2hsd3pIWjlxdWN4SElCTkdnZmtKQi9EeGo0Z09iNVQ2TzJqdFRi?=
 =?utf-8?B?UkJTYkJUWW9zL3VrQUpMUUdOY1ZwUXNJbFRaYUt0Mm9Zd1Rnc3dMRGtIc2w4?=
 =?utf-8?B?NlZQSFdNUU1PODhCQ1lGSzBlcmsvUFhYRytmR3h3WWdiNHRaR0ZMaGhHbHJu?=
 =?utf-8?B?NGN3MjArL1dtU2tTSDdJd2VESHlEd2gyU3hDMWM3RVJNejEvYjBOazUycDdZ?=
 =?utf-8?B?cy96SkFuSEdEQkwrdmY3eHlYNGg0dXpMeXRvUmVzSDZvMGRnUnhJWW5xanBG?=
 =?utf-8?B?T0oyS3Z5L29qeDNiaHZSNTdMRThQbndMa05RZU50WFVDQW92aXl3bkJFQkwz?=
 =?utf-8?B?aHJUOHdzaFZKb0RpWkE4RXAxZ0V6MUsxRjlzZGVBKzVjMW5NeEdObnB4V2NO?=
 =?utf-8?B?ZDE4ZVg4cGFxWE9zVVJlRGVPeTdiVS95b1ZTSldpRlZnbE5NclFSWm9Wb2c4?=
 =?utf-8?B?QTlMRzUzOEtzcCtUUVFoaERGU3RCcUpZYTFVSFpXRnlCcjMvZ1FJTW4weFZ4?=
 =?utf-8?B?Q3hlT00rYUFSQjd3YkRUQnV1Z3VWNE00Z3V3VVhQSjR1dW00WEZkajhTaTRZ?=
 =?utf-8?B?enNqc3ZCQlJhS3ZUNVp6T1o3YmtpSEhSTmFRY3krWWQwSG15MlNOZG8rSXdM?=
 =?utf-8?B?RUhqL1psM3RFRVJraHhsQ0dMZmRYNWJSb1g4S0p6RDF6eTRqQmtmWkRUcFMr?=
 =?utf-8?B?ekduUzBsMHFpb1NHVWwrdlVNcEExUVljYlJoOFhpYjNpQkh0bklpTUh4ZjJJ?=
 =?utf-8?B?RUIzS2JLY0lGTWtwSFdNV1ZnbjNQMzF0cHJkSXc1NUEweHBXV2VwMG1mNXBv?=
 =?utf-8?B?bTNLcUVwNVBvTTg3a2JLUzgwSzhjZ2ZaN3czT1NRMWg4eWhLcUFPN25KeDhh?=
 =?utf-8?B?bUNNNVJxdURuYzlVbUJqeVVqT0xVTXFFQVU0TSt1QldKUkRENjlJUTYxLy9k?=
 =?utf-8?B?OURCMmZvbkRnTGVheUxGRkJ0b2VGRTc1OHpXbGkwS0dtVXNiYWZnR0JPR2RF?=
 =?utf-8?B?bjhRWTNQS1RINW9UZWVDYVM5WFNDZXNYNGlIV0JSZXJIK0dUZnZWYzFHa1Q4?=
 =?utf-8?B?M3Q3ei9qRDMyQ3l6T3FaMWJaM3lMNUw3UFFZV1NPN2M4QkxpYUFWa1k1NVBS?=
 =?utf-8?B?SnV0Q2lkS3JDbGlrUUZsbngzM0lQand2aHY4WWRTMWIzaTlTYTIyWVR2Ylpj?=
 =?utf-8?B?MkxMV0FhSmtvTFRQRDJ3Vi9WNkVlUThnRUFQNWI2WjNNR1Y1ZC9DTUVVYmJa?=
 =?utf-8?B?ekdwcXJVNUxTaXFHUVUrSzJtTll0dXdYaC9OY0U3QjZJRWpLWEtWRVNvakY0?=
 =?utf-8?B?ZGh0dFRiMG0rbVFSeXVsd1BZRmMxNUx6SEpZbHYxT1NXVTFjZEJURzNZQ2N3?=
 =?utf-8?B?dGNSQ2p1cVRtTVJVWmc3dnBRWE1DcXNaelBhR1ppeWtHRFF2dnJXMVVGak1r?=
 =?utf-8?B?UEl1TU1PMHd6Qk1aaDJwV0dUVjJrcWhDenZYdDZlTmRjdXlYMkR4WDhoeHZr?=
 =?utf-8?B?UmhmV1NBckFSU0s5MXE2SXBxS2tqd1lGbzBlbEoybThiWkJveVZUZGlDNVNR?=
 =?utf-8?Q?FbzC6TyClLipMKuf8Ut+pIt1A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1fe031-c3fa-4892-3b4b-08dd6332c19b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 19:59:40.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe76wbVGsNAa+QtiHm15DlA0BoF7fwsGovQh9lsdsZmm3C787eX5d36QLHx6+6OEh3GJuHREMbleVcZNs+jSbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883

On 3/10/25 15:16, Kim Phillips wrote:
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for, or by, a
> guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
> that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> Always enable ALLOWED_SEV_FEATURES.  A VMRUN will fail if any
> non-reserved bits are 1 in SEV_FEATURES but are 0 in
> ALLOWED_SEV_FEATURES.
> 
> Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
> (see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
> i.e. are off-by-default, whereas all other features are effectively
> on-by-default, but still honor ALLOWED_SEV_FEATURES.
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/svm.h | 7 ++++++-
>  arch/x86/kvm/svm/sev.c     | 5 +++++
>  arch/x86/kvm/svm/svm.c     | 2 ++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..b382fd251e5b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 avic_physical_id;	/* Offset 0xf8 */
>  	u8 reserved_7[8];
>  	u64 vmsa_pa;		/* Used for an SEV-ES guest */
> -	u8 reserved_8[720];
> +	u8 reserved_8[40];
> +	u64 allowed_sev_features;	/* Offset 0x138 */
> +	u64 guest_sev_features;		/* Offset 0x140 */
> +	u8 reserved_9[664];
>  	/*
>  	 * Offset 0x3e0, 32 bytes reserved
>  	 * for use by hypervisor/software.
> @@ -291,6 +294,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>  
> +#define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
> +
>  struct vmcb_seg {
>  	u16 selector;
>  	u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..f9ec139901ef 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4449,6 +4449,7 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
>  
>  static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  {
> +	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
> @@ -4464,6 +4465,10 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
>  		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
>  
> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
> +		svm->vmcb->control.allowed_sev_features = sev->vmsa_features |
> +							  VMCB_ALLOWED_SEV_FEATURES_VALID;
> +
>  	/* Can't intercept CR register access, HV can't modify CR registers */
>  	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
>  	svm_clr_intercept(svm, INTERCEPT_CR4_READ);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329..bff6e9c34586 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3435,6 +3435,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
>  	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
>  	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
> +	pr_err("%-20s%016llx\n", "allowed_sev_features:", control->allowed_sev_features);
> +	pr_err("%-20s%016llx\n", "guest_sev_features:", control->guest_sev_features);
>  	pr_err("VMCB State Save Area:\n");
>  	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
>  	       "es:",

