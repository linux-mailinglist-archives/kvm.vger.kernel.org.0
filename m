Return-Path: <kvm+bounces-72328-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BATB3HTpGnHsgUAu9opvQ
	(envelope-from <kvm+bounces-72328-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:01:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 097D41D2016
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0CD18300720D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 00:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6484A14B977;
	Mon,  2 Mar 2026 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lGLY9ZHd"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50891AD24;
	Mon,  2 Mar 2026 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772409706; cv=fail; b=faXALROwknizLAfEYY89NfCxU+l4znv1b5VP2m85t3iKTGreHPXVtqC3YY5xRTlsT8Iv4OmyXmeIepsAaHUDvOxhYYgPcBGjNc6WPHORIWkOoLhrt33FRtJxHSpBHSn8vQTdmiyAl0qhsqIpysZwdvJUiVHFUH5Z/Ivl9md3y1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772409706; c=relaxed/simple;
	bh=jdzxwSm7ai8ePebrDSsNmEaPLrqyXmoa2Vq6Avz5D1M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kT4vKz1K56d/u36S+OfwhoyUbUiwqQy81x8pyPee8MyUQvr9c0YNLMahVLRFdhU7W7rZcHASy1gT770UgUYCLan5roe9ITb16iUcc5v1cicWnFco8VXi7R6rkTl6e0yhXAcvm14HhvsWWYoNfO9EAwX7dnA3Pu5qhyz0hFlB/+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lGLY9ZHd; arc=fail smtp.client-ip=40.93.196.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZDR12V9Q9/yMZCvS08OZHuXJ6SRMRdkUm5ey9FDHdssuxwHlFvXam4P0K/8jvQPffbvhbMoNBkM2COo4rvt7gFVzv7y8zW4qn4d/fjfl0kfmoFfybLVEaBbAbSyCsTW6tJ6GBXavT1zeCITb/h1p/XLNJTWWgl4bD8dVKPsIrWYor7h0ei02LRoYwny7wSIWeM3WxQ5jQxnI1UlpsOqmnFxmSthMxefbaTVnFHrOKMwYCj7TzJBjIJeoQB0SoZbajrQiywv4VQZAvH4LPswUCCbvBdl2eeD2r2nF/kbC3ZUWfCTCUPb7PWzVJGgGA00U5fst+q8mBrlxbmyScbRuWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6G+K6cCwnv7M5AQHuUxt4whVOVF2uupdnefYegrI1I=;
 b=kAlD/mgHlzT3/sh4KDssWVXPdlW/VngVZOfKXjB3bostkLRef6slP+HL6R3LvwYnZ9ojc7V6wMFwKyi6hEJCCeahkG29pOZYtV0G5fB6//yAfwAl9Y0zdbhkGsye10cPimmRB2QOm4P1RHMlVebBlCdGit+xbXfsFEK4JCQudIdKi24afRke1nj/B3jB4vk2HNdkOxADkFB97kcjkLWKH0KwnJPr98Y/7SY/mdwdBFxMPAfeuM9auy84XXLy75+OH6Sn/+qbF9qY/PjPJ5APAJTRPbn+wL6XXlqaSAx1qYEQBGa9H/6V3cxZySjmOM2sLE2YdhGMKiB96EfFm9jpmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6G+K6cCwnv7M5AQHuUxt4whVOVF2uupdnefYegrI1I=;
 b=lGLY9ZHdqe7pk/WCtJy3/82tUO4FMLo4kiWYojUxex7rtEuIUeueF7TzhSlQd3gURYeCLud0GVg+rcqwIpKrIkVMd5k2IB0R+GBdPtfX3TN0I14u631oCZBfNjJ2mmC99JUrBjtReozWn1gTV23geSce4IQMjpSvwAHJNrOhrSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.18; Mon, 2 Mar 2026 00:01:41 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Mon, 2 Mar 2026
 00:01:41 +0000
Message-ID: <2a5b2d8c-7359-42bd-9e8e-2c3efacee747@amd.com>
Date: Mon, 2 Mar 2026 11:01:24 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
To: Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <20260228000630.GN44359@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260228000630.GN44359@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0151.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 76c66932-964c-47c9-8ff0-08de77eee1db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	l1QGT5xyWzrH/kOtM0L6A5UgWO14Ksr6I0mVUbGl6A6UGS8CQ9hK7KfyGIw0HQtFVMBVqSAJU/TCPRASLxkDinJG8egHaU8H5G/9UrBCdvRaDeN8IlWA/LlMB0yrVsrWnFRSBWj07LddHAAnvSCO9Z9B2cQxoEj+JLFLKXSAosdB2ce3KizR6tqhOST2sqLn8R4sZwJO5cA0WqEaZQ5DJUC7jqLA+xxCpE5AlNcIyOeJSCAHdHmIO+KLy5nkUgrfZcwMO+pave0OB9mvjyDnspdzSAg1+3c4SgwT9OgKfqkDWQUfjJV6lZT11uH46g9kcUYyUMZpyIzF/dFkLH6BYocer/gGgcD9rMPLeqOaeanTfRPBLgY2QgU3U8niWX2JUqFrr9LAfhP1mqeUeqHRiKGNKW4GHVIT+bn+gwCJMzatl6TeYQoQ6Nu52egTHtmsm0YuUAA+LJauihIEefp8JfLBxiwG73hrYcgiEq2VD+BfbUX4Eershtz8DSt8EwaKSPkLd03EWKV0R7ZGutqvupI1d/eaDfFO6WLFEBlcnZSf+cWPm5v1Guf9RwZpJWdKXRBNsOxrzMXVQH9CVDoHlmK8OmqBWomHQ19gAUcR/+GGcyxEwlwG0MPBPaTTzJ7dJxKnF5KZf3dahEcnt0iwpzJioTcVdE2qd1aTl4NCLpGchzK81UCtPgOtmFtACbJZVaRijDZTlOv0UIuHj9f3yqoShsc1DcR68x5rHfcDwhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlFSVytuQk5INmlhOUVzOS84YkZnUmMzVTUrNk5MY25yTXh3ZUxCUEFjMWxV?=
 =?utf-8?B?SFcvUXlUN25YdHNGMSs0NFlDdDZWL2w1K2c3RE1rYmJNM01saWdFd3ExWThS?=
 =?utf-8?B?TFUvdVcreWMrK0p0a09TakxhZzgvaEUwU1dCTFlpY2NOaEQ1dzhJcDZqSlkv?=
 =?utf-8?B?V3JqVlNTVjRNRmVicW8yMkErR1NYdjFLUVVXWjFpeHhQenlkWlBXWHJycGFG?=
 =?utf-8?B?VVpRNkJjUVRrdy9XY2ZFVW1PMmZKVXZrT0dwQ0QzR2Evb0Q2NHNBVWFOWDBk?=
 =?utf-8?B?SDFLZ1NHZEN5UTg5VG9VUk1sSWZZNjJyWnZQMkFKSmlPMjQ3YnczcXdJZzFs?=
 =?utf-8?B?NkNwbWRDU1pWeEdtLzFYSE1hNXRIMTlXcnpoVVhkNENiTTRnb2JJY1l1MGIx?=
 =?utf-8?B?Ymcvc0tJcGkvNThlcWhReS9MS1dhcVNObytmWXBRb3NtUGFxVUkvV3VjT1dN?=
 =?utf-8?B?SDRGZ3A3QlBKTHZJQ1h6NmFmTy90NTR6azhpRHdLbjJraExNOTJXWEhmTmNo?=
 =?utf-8?B?QnhsTURXRWxSTlRtREhZL0laK1QwYmdheG9ESTNWbEpkbG1DZ29Ia0FpU1lY?=
 =?utf-8?B?NWM4N2V4SytiL1NUcDFUeTAvTm5ldTFNRnNwaTJaSHdxcmh4S2FNTFl2YUFD?=
 =?utf-8?B?b0ZTa3VRRmMvQ3pCMHF2dHVCY256Yi9aa1lMVnFYWElZdGJMcVBpU0UyQy9W?=
 =?utf-8?B?SDV6NDRqNldmMFJPSmFGSVY1KzVhYk45WkF1VVQ0clBMQXZOLzlLeSs3K1pp?=
 =?utf-8?B?dmZtQnFMK2JKcjZ4UUwrdG9tcVRNaWhYRHNwV3NETnd2cDJuY0lndVo0SXNC?=
 =?utf-8?B?VFJiNXVUVzIvK0hQbWdtclJveXRlS2h1SVJibUo1UTVESnVpdVhEckwrczBK?=
 =?utf-8?B?bWZrL01uVk0va0lXdGZZcFlzbDQ0cmgxWUZWa2owemlhZHhSbVRMZDU0RFgz?=
 =?utf-8?B?VjBZZmJjdnc5U2lvR0xJcVV5bXB4S0V6UmtnQlpUQ052bWUrOUkrL3FkT1p6?=
 =?utf-8?B?V3lGNWZzbG9YT2F5bm9PUWhEY3o5KzFrYnpSTzhmYkltUlZiS2kzRytBZXQy?=
 =?utf-8?B?TkI5bTBWZldTblZkbXNHc2pkYnZCclZWdzZTalg4dW1adzBHVTZkMUxibjVN?=
 =?utf-8?B?eEVQZWVjRmt2ck9mcUVVdXpZeENCd3NVcGsxdldyRS9jWDBCeE0xNHoyTnpP?=
 =?utf-8?B?QWZpbDVObDd1QldEMkRoMEw3QmFIejE3SUEwSTVzS29GaTdHem9RYkJ6ci9F?=
 =?utf-8?B?bVJIZW8wKy9PTlNIM2cyV1g1bXdsajZuWjBqR3QzRFhWZEhZTVVIa2srcjl1?=
 =?utf-8?B?ZWVBUFlIbUxKYlNHNlE0RTdMbURGZjFhRWlxVHZTM0dsSk9YZm01a1FHOWk3?=
 =?utf-8?B?K0tDbzN6dmFmWWQyc3JxMWhhc0c2N0tCbSs4eG03WXk5NzQyTVd4ZHd2VWky?=
 =?utf-8?B?b2pSaFVSYWw1bXVCYU1ya2JXTjR4RGRlYnhsM1liZkpYZmZKSnB0YXNDZ2hT?=
 =?utf-8?B?ZDNybW50TVBJL2htUmxEWU0yUk5JRnV0QlVkR2lBdDZhU2lOZFY3ZTlkR3I5?=
 =?utf-8?B?d1pHTEZGU3RLTGp1VjhLQlA4dlVhY1NyaHJPTk1VYjB5MTFnSW1pclFmVXpZ?=
 =?utf-8?B?V3NxaXBiVDhodHVMbE1yU2wxVFNQTHdsd3NzYVBTaktpN2hqZzFDc3dRYlB2?=
 =?utf-8?B?UUpvdUdQcURmbktkWlFCOG03ZjRMVU1NeU9lMVNKNkhtZWJ3M3NBTjVBRGc3?=
 =?utf-8?B?Z3lNdWs2UzFTSUZnOEUzclB4OUJJb0ttWW9TUWxtQ2c1ME1QcWNRdFk4UHlz?=
 =?utf-8?B?Rml2Nm9aSjgzS29NTlliWDliM0JPenF0TS9oM3ZjZ3J5UW9qTWpnU0RoaTlN?=
 =?utf-8?B?eFhtYk1sN2lUbjd1QTUyb1JSOVNPeVM5VmNmR2ZtTVFlNHR0SUxEcm9EYlJi?=
 =?utf-8?B?Zk1iSG1oVGV4bE81eloxVDE5ZElLZXpmdTVxYWxlUC96WGFBR2pGNGcrNDJa?=
 =?utf-8?B?Q29sMFVMc3Z2SVJYMGxteHRhWEkxczNmOTYraGsrbjZBT3BJOG9IV3FVWlBW?=
 =?utf-8?B?VkQyL1NhZFJoQlk4UVRTdytqV1VNTTR0UnhZalBrZWJaS2l1enBLdHVWZXNp?=
 =?utf-8?B?dWZmR05LOHo5REZFUFArdnlyWnFlMG9PbDd1d0hHc3BnWnlHYlRCOWg5T0FW?=
 =?utf-8?B?aWFjL1VoZDYyQ01zWUlrdUdlNnQvZS9ncEZETW0wRHNyR2F3bjcwMTQ4RTg0?=
 =?utf-8?B?ZHZNWnFiTVRNaUZ5WnpyWHg4clluNWo5MW14Z1cvT3poZWp3d0dZN0oyUUpR?=
 =?utf-8?B?M0tRQmNzUi9uT0YxaFZUUlhEWlRXL29qMC9BbnJwWUdqU1BFQkNXdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c66932-964c-47c9-8ff0-08de77eee1db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 00:01:41.0174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlMfyNw9t2Kh4QJVurvjQDM7cgazvcB5e8k15Fv0UC6w3BnQ0KJyTG7ABR/pn/eKao6rZsu2Bc2Uev6liv4vIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72328-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 097D41D2016
X-Rspamd-Action: no action



On 28/2/26 11:06, Jason Gunthorpe wrote:
> On Wed, Feb 25, 2026 at 05:08:37PM +0000, Robin Murphy wrote:
> 
>> I guess this comes back to the point I just raised on the previous patch -
>> the current assumption is that devices cannot access private memory at all,
>> and thus phys_to_dma() is implicitly only dealing with the mechanics of how
>> the given device accesses shared memory. Once that no longer holds, I don't
>> see how we can find the right answer without also consulting the relevant
>> state of paddr itself, and that really *should* be able to be commonly
>> abstracted across CoCo environments.
> 
> Definately, I think building on this is a good place to start
> 
> https://lore.kernel.org/all/20260223095136.225277-2-jiri@resnulli.us/

cool, thanks for the pointer.

> Probably this series needs to take DMA_ATTR_CC_DECRYPTED and push it
> down into the phys_to_dma() and make the swiotlb shared allocation
> code force set it.
> 
> But what value is stored in the phys_addr_t for shared pages on the
> three arches? Does ARM and Intel set the high GPA/IPA bit in the
> phys_addr or do they set it through the pgprot? What does AMD do?
> ie can we test a bit in the phys_addr_t to reliably determine if it is
> shared or private?

Without secure vIOMMU, no Cbit in the S2 table (==host) for any VM. SDTE (==IOMMU) decides on shared/private for the device, i.e. (device_cc_accepted()?private:shared).

With secure vIOMMU, PTEs in VM will or won't have the SME mask.

>>> pci_device_add() enforces the FFFF_FFFF coherent DMA mask so
>>> dma_alloc_coherent() fails when SME=on, this is how I ended up fixing
>>> phys_to_dma() and not quite sure it is the right fix.
> 
> Does AMD have the shared/private GPA split like ARM and Intel do? Ie
> shared is always at a high GPA? What is the SME mask?

sorry but I do not follow this entirely.

In general, GPA != DMA handle. Cbit (bit51) is not an address bit in a GPA but it is a DMA handle so I mask it there.

With one exception - 1) host 2) mem_encrypt=on 3) iommu=pt, but we default to IOMMU in the case of host+mem_encrypt=on and don't have Cbit in host's DMA handles.

For CoCoVM, I could map everything again at the 1<<51 offset in the same S2 table to leak Cbit to the bus (useless though).

There is vTOM in SDTE which is "every phys_addr_t above vTOM is no Cbit, below - with Cbit" (and there is the same thing for the CPU side in SEV) but this not it, right?

AMD's SME mask for shared is 0, for private - 1<<51.

Thanks,


-- 
Alexey


