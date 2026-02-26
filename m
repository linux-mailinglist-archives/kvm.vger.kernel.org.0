Return-Path: <kvm+bounces-71924-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMTMNcLmn2kuewQAu9opvQ
	(envelope-from <kvm+bounces-71924-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:22:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A97541A14A5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 43D313012874
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CB938B7C1;
	Thu, 26 Feb 2026 06:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j16XOoS1"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013020.outbound.protection.outlook.com [40.93.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16B512D21B;
	Thu, 26 Feb 2026 06:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772086969; cv=fail; b=AFfuZp9NB1q5SpZX6Jg5oXeFQvCxTLveuMzJIXbl7IK20P36I1nKStIh8QOnQD/kJ+ussd9Rkt5XVIhzjcT3AJlr1pUmJgrOiv456EaUV3dtrHPvff/lHp99NJEpLSB8z1Oe81nxu37oSXFcK238E8QydJHtiPm8N+4WYo02m4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772086969; c=relaxed/simple;
	bh=/wiquBga9akwnzU4FYjapn4Dc4D5jGrFVIiGVvprgew=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sdF1R0Z0p2oXI2X09aQDv7mqQUCHzjhScRARBT+W+AFy2Fk3SvyJImFkqaJ1NJJxJz2OaWvatAdIHp4GH0buhXmAdOktfIZepHURTPcxZ2CYwJNs28AuakfOPPoRoIMkH4/lTQk9zTO0qzWfcL4QIPts9ClkeSIkW5BuGpaMXOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j16XOoS1; arc=fail smtp.client-ip=40.93.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFHSIOdf7bp+0sGPB8cmRphzA6+kJQwPeT1kpNzw8G1DtOQoWWGzU+LvEEqZMU+900UBZmXWf0E1pt7B55iTpKq+IiLYnFbmkpSzY0w23rkmpf8szIXMH63sXgtaRggTYhav8HMA5Zuy0bit30OqW6n4c3rxeESEhjRGJ0n+WFfzMt1lLNa46K8lhEkBV3DRp/tl/WjmSInPyrd2gXnpt8ygb7u97kmmuJDhaF9H8kJ643uK/egUYqvQpGkFow43x/aLwvbg0JMLm6lJmTDsqHvqlT8MlFr9iMiZXXB1c3yc/DqNsWLECXBOe05QreXPhA2yrSEQj2ggi+Hm2OYeDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmfacbjmASGScyej3wQHvBL33lFWyfClZcK01Fgvub0=;
 b=KW2u5I8d8v4XeiCUNpyBeVMI+cfZBpLaH4pACkYnb655BIibQMCIWFNc8U6XEwY7grhOywRX+ydUxfcok4IS3VhuRscVEj5BkBjIbqTnoOiL6yao6hO/pKlOWmr8KR7dQ9VPfxz+kDcMruF/9kFJByNz7kGVAOcFTGO41uRmhDIsDIwhl2pUE0GqtOsPLCL1/5qJF5x4BUfpJZ0RfQEde8TPCPCk9CxTCuWBtRU+wHX+v0M6d9127C2n7Pusw65cIRouHhaRSZOG867aOfG85MneetedRXTEJ0jIWV264Bcqd4MU6g7TRoC9KpsaNF10qwwueYeWf9egzNeDrmrLJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmfacbjmASGScyej3wQHvBL33lFWyfClZcK01Fgvub0=;
 b=j16XOoS1+VweCuMo8rUF/4ZTQjkHpsX3mSQv52r59w2MQo08UAUzQj0alenP3xB9t+0fvJKFVP7YvjIQeoa7XWqsNWSMVQ33C753OykA7GPtA4KdDIhLizMQplOF63VRw0rIvJBzcdu6VHxy3MVSUXGogf3m+hYCYDAd8FZaAmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB8795.namprd12.prod.outlook.com (2603:10b6:510:275::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 06:22:39 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 06:22:39 +0000
Message-ID: <f9665f7d-e222-4843-8db6-faf0d2e6e127@amd.com>
Date: Thu, 26 Feb 2026 17:22:23 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
To: dan.j.williams@intel.com, Robin Murphy <robin.murphy@arm.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <699f6b1ad77cd_1cc51005d@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <699f6b1ad77cd_1cc51005d@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0084.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::22) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB8795:EE_
X-MS-Office365-Filtering-Correlation-Id: c7643c06-448b-4903-9eb9-08de74ff70f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	lITFnReqhpTxD85CRkXr9LfkuGbl5eWyfBCyGSwy1NX9S8l0r20rpxIqUDP7VGB6OlK80mTJn5cEwqqn6GkEwGo3VDwgD5dDuBKtufoqDIlNzxLSO1whvhHMixVROfTDdhgC/wdbal5mqXV1tOjRb4Zb1LmEqD15gVyDg00d1v1nTM6s4Iys7ehgIjOS7v/uHD7Ixc2Z+EvpOZn83UOp4tA9bTyWIwxyXBrrc6S7b3R+sC4dLZV1lLsv0EUNU9HhESPMyLQmm/fY1ZWhA65Kb7lYGLAdP8n34ywLgR+fqfCFkLEouY5oJgHVIHj3eYe61AHfpYXJbHz++6urHzAyXwyYyIOQysZZTjt56uqEoSgzygcwStJ8tkOFi3msgAG0yDH9EC0cCeaLXArtYfGJjtP1kBgqqKwAnzKcpPOh+op9KDik200jkzfCIJkYBf7hO1qCxGMAhMJ8IxmQM4F+bgY3b9Zkm8aNFQrtR99ZhGRjMWYor1rey96lwuQ/WVwMfyu002ftxs5s0mx7V3+FB6i+oDqFFRaf0fxmGbtn2PM55/KcZWHMZ0w71nyuTlDx7tebet7Z9QvIOmvtRRWT1KZTSNXjb+Xmtm6bUuM3W1MaCCNBQZM8w4GB3OHco9F/dHBbKrNnb33f+cQhTJThOf/T/RYMG9y2eFRUyrD9OkHcIeFxF8zvkJ6PsvRDOcubEFbu79NRCofZNC/a9dnSbSdim1s+UAjgV2GMwqFA+2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE5QdFo3VG1LSmc4TCs5bEgrMmFRRlVMQVlNM1VtMkxhOG9UbXhrRkIwTTF2?=
 =?utf-8?B?K0d0WFErb1g2YzN5cFYvU2pMYmNsY2U0RklDWDdKZmJMN1AzMEFCUUZSWFRX?=
 =?utf-8?B?YlBxd1lGUlBDM0hnUWlQZ2ZUWmlCTVpaOHQvbGhYRURmMXhBWXZwU003eUt5?=
 =?utf-8?B?OVJtdyt1MEhYZGdjeEtreXpMNEVCM2ozWitISHlpNFNGSFBBWEwwdkx5YUVI?=
 =?utf-8?B?emJlSGdncWlxV0hIc0hyREFnc0o4QytLeTlZbzJIeGFJM1pCRDRzTTNpTDBl?=
 =?utf-8?B?Zng1VnRhQ0w2bUJDVWlybXEwOXplT1l5b2tBc0NFbm40Y3l0SHJsRll4bThl?=
 =?utf-8?B?K3doeDR0K3Z2OG11Yk9jT095aEFRZUhCVU9SZUhLeVlsdXcwR2hGMkt4V3Rx?=
 =?utf-8?B?ekJHcWZ5dk1vTGFpQjBRZnZLODdOSGZmVFRXaHlSRUtxZVZ6QVNXV3Q1dWJL?=
 =?utf-8?B?T2pkaUZBbURsV1RROWtoQjlQczhWdlc2R1dOT3BMV3JKL2JNYVJXZWUzeVlI?=
 =?utf-8?B?L1dYSU1IZzhhY2pYbXc0cy92RVFMcHlGbmtVZkFrZUxKRHZ3Qm4rblA3b0Fj?=
 =?utf-8?B?UzBkY2dIbkFUVXByTyt2M1J4MVVmWVYzQ1B1cElWVXI3dzYxdkM1SjlMa2NF?=
 =?utf-8?B?TVdUMkM1N0ozY2pSdXRlYmtDV1VHSEdVUHBWRmlJWXBGeDRvTlpieHlidG1s?=
 =?utf-8?B?dHJDckFZakR4d0Z3cUNWU0tSYkxxQmZLRmJxY3Z5SzE2U21OUGQxSmsvREdS?=
 =?utf-8?B?N1YxU3VpU3R3Mkt5bXNrblA0a0NJeWszK1R2b0YwbGpQSU12UmR0NjdzYy9v?=
 =?utf-8?B?ZUM3UXltdDJTUkVpbk5ZVWtsOGJLdnFRcC95REdYR1g1U1NwSzFVSk0rMyt1?=
 =?utf-8?B?KzlyeUVzd0lCSkRjS0QxSUNoTitmWlpqNThqMmRyT2JkdnNCZS8rSEZJenlY?=
 =?utf-8?B?dWo5elozb09tUmZkN1NnMXZWdE9OZkU5eGxlRGhmSXFtdVE3bXVqZGF0cjhQ?=
 =?utf-8?B?cmxEYUk0Q0tEeTVVT3JKZFhTVVlzMy93dEdhTXg4R0NDczg0T0taSU03SXNq?=
 =?utf-8?B?bVpNSElsdy9ndVQyUWJPSnNsL3plYWU1MWFzZnZTM09JeEQ4SUFvMVR3ZEtj?=
 =?utf-8?B?SjArSVJ6U0ttTE4wUmhzTHlhSkdleHQzNXlaNFhzTU91T0locElMY3pzV3I3?=
 =?utf-8?B?cjF4c3o1cUQ3VThMMWZkZlhybXp6aGJTeWU3djBwVkJKS1dtbnZmMmFVN0F5?=
 =?utf-8?B?Z0VtUmdqUklOYVVTdkdBTTV2MVFvS2NpRERzUzhhMnoyem0wOXN4RWdBbm9P?=
 =?utf-8?B?dERlZ1lQVzNkemxaQkNmRkxwcTNIYW9IbFZzbmQ0Wm1yNUYxRk95UkcwYWhR?=
 =?utf-8?B?bTdWQ3FjRXpuOFRPTHBnRkxrV0ZJNkM2bDlPMTBPekxFQVB4OG5WNjNGamlY?=
 =?utf-8?B?WXV4bHp4bVRLY2FiZExjZG1ZZm5XZk9BSEpweFFqS25vNW9NR3RlUTJ5ZHN2?=
 =?utf-8?B?Y3pHcEltZFd4L1RIYlIvU1hRWDA3Z01qeCtUUHRNZVl5dHJGaVZ4Ujh0Q0dl?=
 =?utf-8?B?bUpSTVFGRk1kRlBwam5SRzV0RjF2bExNOTdMRFhWQ2dGSVU4MmRKNDZWbWIv?=
 =?utf-8?B?akJEd2dxMUwwSzJkY01ML3hob0Qwa043VU5oTVdLMFVUUzN1blFXSnZ1dm5l?=
 =?utf-8?B?aGVnVkNURlYxTFVWMFF3Y1dFd1VEY2tBVkhqZGV5VCtxV3M2Rkt5dUEzNUND?=
 =?utf-8?B?aUJFTmNTZDA5YmI2ZDZrVHozUlB1aWJmZm1qMjBsYUpVaTNCajVHK0tqUDli?=
 =?utf-8?B?MXJDSG9udWFlM0I0ZXBLczEvbk1FeHlEODZCWlh1a0RXcHB1WHY0emx3cC93?=
 =?utf-8?B?ZktYQm5oTTVoSWxMNUhOR0hrZVZHOXNDcW93c2xiWUNNTEZITERYTFpJWWF5?=
 =?utf-8?B?VXZ3NTVNUXlWaEJPNG5aTjJCV3F4MDFGS0dMTllxZFg0RFRCMHVVMWJnRHhI?=
 =?utf-8?B?ZTJCY2VERytzWDRHby8vRTZMYVB6Nk1lK2NWQkJpcWJ5QlduN0Vpa0FTYm1O?=
 =?utf-8?B?eG9GTzRHdWVMdDFsS29oT0k1S084M2pjSS83K28zem83RXZHbWwvUUYvbzFU?=
 =?utf-8?B?Q3RISDNwWFJETWVHdFE2TFdrdjlZQm51eENFZzFFYWNUYWJISXgxVUFZYVFF?=
 =?utf-8?B?NkdTTjN4eE9wNkZBbkJaMjVxekRRZTU1b1p1NFBJdWcwaFhEeXQ5alA2M0hW?=
 =?utf-8?B?NGJsVkFyR0RLNmxUYUhLVTFPR3J4WVVxVTdONi9yWHFPSXNHOWppWldGai9K?=
 =?utf-8?B?VnpRUWQ0T0xnOWJTS1JsaHlGZ2hwWWdpZWlqa3RVeFFzV05XUVlUdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7643c06-448b-4903-9eb9-08de74ff70f5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 06:22:39.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1r/zXajqHC8g5fxS+t1b+bhUiILcOFWbu8udlPHhbTmI7FQpvv28edZVm5MXH49BiBFHOoLLa8jtlGMm+JYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8795
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71924-lists,kvm=lfdr.de];
	RCPT_COUNT_GT_50(0.00)[57];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: A97541A14A5
X-Rspamd-Action: no action



On 26/2/26 08:35, dan.j.williams@intel.com wrote:
> Robin Murphy wrote:
>> On 2026-02-25 5:37 am, Alexey Kardashevskiy wrote:
>>> TDISP devices operate in CoCo VMs only and capable of accessing
>>> encrypted guest memory.
>>>
>>> Currently when SME is on, the DMA subsystem forces the SME mask in
>>> DMA handles in phys_to_dma() which assumes IOMMU pass through
>>> which is never the case with CoCoVM running with a TDISP device.
>>>
>>> Define X86's version of phys_to_dma() to skip leaking SME mask to
>>> the device.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>> ---
>>>
>>> Doing this in the generic version breaks ARM which uses
>>> the SME mask in DMA handles, hence ARCH_HAS_PHYS_TO_DMA.
>>
>> That smells a bit off... In CCA we should be in the same boat, wherein a
>> trusted device can access memory at a DMA address based on its "normal"
>> (private) GPA, rather than having to be redirected to the shared alias
>> (it's really not an "SME mask" in that sense at all).
> 
> Not quite, no, CCA *is* in the same boat as TDX, not SEV-SNP. Only
> SEV-SNP has this concept that the DMA handle for private memory is the
> dma_addr_unencrypted() conversion (C-bit masked) of the CPU physical
> address. For CCA and TDX the typical expectation of dma_addr_encrypted()
> for accepted devices holds. It just so happens that dma_addr_encrypted()
> does not munge the address on  is a nop conversion for CCA and TDX.

OTOH TDX and SNP do not leak SME mask to DMA handles, and ARM does.

Sounds like what, we need sme_dma_me_mask in addition to sme_me_mask? Scary.


-- 
Alexey


