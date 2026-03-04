Return-Path: <kvm+bounces-72660-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPltDUHVp2nEkAAAu9opvQ
	(envelope-from <kvm+bounces-72660-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 07:46:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C11291FB4B4
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 07:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A5BE3023041
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 06:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8CF37F743;
	Wed,  4 Mar 2026 06:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QlBBPR7o"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010022.outbound.protection.outlook.com [52.101.193.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACEF17C220;
	Wed,  4 Mar 2026 06:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772606766; cv=fail; b=C/PCppcbet7H4J/t/qaTmU5WcWovd0PH63vKPle9/25hp/SF7rTcwL93NUr/KrYW+OHoT3l4g4CjqsxeVw8eaCuT3hO+gkhdXVpt60LUKihxHURyV4rBWZ4gUzf4LzfGSTJ6g9rJsCl2Ei1FNVQlpvkhYjrYqahbo/ucZk5mRAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772606766; c=relaxed/simple;
	bh=8U8lj9pZm8d9svi+WUjf5T0B10YVNQglyDSszfMMBEA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K3yYouc2KJ4nYm+uLMqiFY/tRhiyM1ir95rcafdxilQNmH3mF+buGAuZOcfM9QurWd/QYRNB8uyYjyJbFb3OQ5ohkC+tXy6D0LnKhh5RHS7y67QKfEtqIHyp8E/P0IlFV7ozBkFVW5sM1t4UlNwQNqcaWzFO1ZONljsGcHawdXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QlBBPR7o; arc=fail smtp.client-ip=52.101.193.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAQlNy8vQpS8PDWU7XslnspxwA8xlFo2VPqdp5/hxk3dpYQ72An430EgaztYpFPJF1Lnz+mFugO6XGJvM0RO45eNrqV92DI21BnR9SCgiONfRM4wxJHYBpyVxCMpKpiKkgck4WI+bQjT1IkWBLITsRARKU2/aaH9JSHZpwVTWn/HMxS0wKSS419JEnYXXg8pzOlx/UXI45+eUakyOH+hYbZCPCr2Mo1Lesx87of7Qk5sh3jVXfw+pvG7EphiOxEsPANzmLnzhd1owVqCcZnYxoy4j6cQE0zT8c+Aem+Hoxa9NANRVLLKTPRjL7RsrFrMc6whXkXjwFsbteqA2z9Cqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSuuLBxjsT0Z5Q9/iRFMYZPCB1aEbrRflARsAZfEOvE=;
 b=YeaadGd5EP7ut9zMe6oA1Ttur7QTNdzZ00sXv+JMXtyjUPmjIoF5Zt7dX6fRvG8NIepvGHdrmOutgKpRlrnIIrfFjAnF9/PRroYGHaTgnmmYOUa4Wh5VJj8WabTA3lx8rl0bNf77rmmm+c33NQyoHWntRwzC+R5SFm7/BDA8qFFFc2HDsHuTBoZZYGo6/aZdz077SL3ABdp9fKwC9oV0JO0KMqAa2AXN/fVK6X7OiSla0P5XOInYTbmplR7cIJ6rd1fpK3sxPpfP0p/mzGuHmWoSRMbsQPghnR66AEKAnRTXMenfUXGIyFrG2T8Xd1N8iCHFik0gH7V+5UxY2IXRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSuuLBxjsT0Z5Q9/iRFMYZPCB1aEbrRflARsAZfEOvE=;
 b=QlBBPR7o5XAj1JEIeAKEA0toXXgQcNdIxU/8vJkv4JfQvUIRk+GEbnqL+THOlidkWmXlaLnzD0hgopkHOdKkBrPC+p43Xur/rRTVfjdua0fh2899FSoeuDd0iZ7nd9dsAFospQ3AbLKMyzoT05eBpRWE46//gxgZJ61MZdXF7HM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 06:46:00 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 06:46:00 +0000
Message-ID: <5d669086-a5c8-4e55-8108-a9fff41cf094@amd.com>
Date: Wed, 4 Mar 2026 17:45:31 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
To: Jason Gunthorpe <jgg@nvidia.com>, dan.j.williams@intel.com
Cc: Robin Murphy <robin.murphy@arm.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
 <20260228002808.GO44359@ziepe.ca>
 <69a622e92cccf_6423c10092@dwillia2-mobl4.notmuch>
 <20260303001911.GA964116@ziepe.ca> <20260303124306.GA1002356@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260303124306.GA1002356@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0079.ausprd01.prod.outlook.com
 (2603:10c6:10:110::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b1eb29-628c-43c0-583b-08de79b9b251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	iC9Um92X9OMS3ByL87folJgo54gcRHeT00Cn+F30/bEsUOvS7gadQotjKUua99C9rlfEwwAt0a7lipwyXRpQxEyYJSbLgei8LQPEaQyccej4I+qWBZOsvUuaDxh/4ZzgOqpj5tdkov/s9f31CLahJ6Q1KUk2+j6enOVs3Mx1gK27Hb7GN5kFDDODV0yi+SpJ/gb7FQF/jALo4H+O1CkpKCZIjy/7GcqaIIIJ/YzOzVcaGdZkYTAu9CRsJ3b18bRNxYgQm5rek9HeNmh3SvWJLjHStXy1iBuNji1UcsjzzcluOoGn5M4KTuzOQ4VXbu8irQAWFBMe7W64dc6F3lOhVXrpjrC544AqbRJPoPPT8P30FI6u7MSqMKsalz7YP1rgkt2TMiuLAtAOenvuEHdpKlypJfvilmAtcOlaSEbqiU1srWr+PapiBjdhVy44e1NcM/oXxQ2PHwddFcr+8bVxEeFc45SLLAcGC3YJ0deIBt8px38kuhpP7iXIVN9pSksI0krUUcK3x+Bf3FqrRM13GPstUksJJtVfgvTrn8Xs56pWGnYVmrUdB1lz4oZwWmmnnAA3xy9vE4OLHNeX08m1ZleN6L7ibdBm0ppwH/R5dEY56iDuYQtl5a/4P4HiHx6gXcXpA0kAvre7w25kcfjmOL3gQSmV5PTO6g0u06a4EiUBDUnWV3bVn6Ki+oJLucO4v0seH8/o/kzKji1JlXb8zL8oDRxEzDaMe3ieo+wjmJk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG54d3lKT24zdnR3emxMbGc5V05kNmhiY0E5WW1UblgzOE9UMVhlb0xybjJl?=
 =?utf-8?B?RU5pL1l2OHNnb3RXcFE4bTQ1ZXNCczVCMWtOY1M5WVdQY05TMlAwa0F6WTh0?=
 =?utf-8?B?bWpNSllrQm9CNlRQZVdPeXJ6OWViVWl4ZDRoWHM4dVltcDFSVk5sTXh5VHNT?=
 =?utf-8?B?dm1yUHNacHBVaVFHUStMZkE2bXdDT2pINVFXM2dTT1RGU1BDek5uSDF5MUEx?=
 =?utf-8?B?QjZaWXJrQ3FYdXBTbVBUdEpjUVpRVmV6OTlhN2pLR1hBYmtTaGlMMWpjR0VP?=
 =?utf-8?B?MlhHWEhBRHlyelpuaXlWZjV5NTFSQkxmSHVJbXVZTzFBTHBvaUZ4amROdXdk?=
 =?utf-8?B?WjJsL3VYeHNpRXNXay9ZQlpmWFkzZEJQcitNMm95VXNqcytDUmVFWE9JN0Fy?=
 =?utf-8?B?UnQxZ3gxSVJ4UnNQeTBlMUt0TnhvbVJjREtvTUlIWEN2WHA4a0V3d2oxdzd3?=
 =?utf-8?B?enNuUUlLYjc5bGtFS1lNbkxGcDQ2NGhva04wVmRvVTJrZnNTUkZnQ01PY05x?=
 =?utf-8?B?dEowQjBEMFdVN0xGZjdJUlJpZEpYWnlwWUE5MThraXRUbDNSeWw1bWMrS0p0?=
 =?utf-8?B?c3ltQmErM1RKMFJYVkNQTmV4dnJFRkRvM1AvN0RmTWo4Z0t1d3N0NURGR3A3?=
 =?utf-8?B?OWFqTGVINGZjOWE3ZTN5ektYOHFldDNTeHAzVzRRSzBtaFBNL1FrcDl2U0Vu?=
 =?utf-8?B?eWY2eHNvK3JmenB3MEpxQkVlR2FocGVhU3huUXRMYmRkVjlBdVl0ekVVcEtp?=
 =?utf-8?B?WjZVaEVaby85ZHhveEZhYzRJYk9oQlFac3lpSnJBZllySE5QZTNWZlNKTktk?=
 =?utf-8?B?R1djOXZOdHQzdnJNQ1JZWmxhVmo0b3F1NzNZelFNNG9QcnoxVFd3ejkwMEx3?=
 =?utf-8?B?eUVlVjZHallYMG9vRVhPWkEwT2pqa1ZmWkdOV1VyVXYrT0FOS1FVTk1qcmo2?=
 =?utf-8?B?NHV3RFVzbTFmWVpCdkJtU0tiZkMyL3VqQWgwbnp3WGVPdmtiWkx5cmhwbkNT?=
 =?utf-8?B?ZHpoemJMcFZjcjJBODRmN0RtRVRsYjEwck5zOTR2aXRqVEpOTFBxWWRNejhx?=
 =?utf-8?B?eHFYcnZ2NDNuSlkyVHI4VStnaDhsM1V2QkJRSXNCWTVPLzdMUWhVM3VCdzUx?=
 =?utf-8?B?M3loUUdRWklnVFF4MXgrWmJEaGJoN3ZUZzNIemM1dTBKUG5Xb0Y3R3Qvb1l3?=
 =?utf-8?B?TlE2Z2xtQnZVamJsb0h5RlZJRjFXY000YnpFTUFRMkJBYTN2YU9WMUxqVzJY?=
 =?utf-8?B?QkZkUStlOUIvR2puaWZBM3J6QjRZWUZnSEdFL3RWdDNXUFh6ZlJuM2p4TE1r?=
 =?utf-8?B?YzZaZ3BweWsvUnMrV3BEQkdPUHVwekE2eFh6K09senVXL2MwekF1ZFZWVU5y?=
 =?utf-8?B?MVVnY2dDVzM3RjA1dFJBSjZDa2ZsWjI0NHFQdWVDTi81N0ZKdFdYLzROc2Fm?=
 =?utf-8?B?OThVS1pMME13S1pGOUUzVzVIRis3MW9ranNIcGVySFVRTGllcGp5d1JlVk9G?=
 =?utf-8?B?N1FTSWg0NjRJZ2tIVm9HcGljVng5ajFQSzNQWjg2ZHR3RVcxK1BEWEJTNFYx?=
 =?utf-8?B?aTloeFM5bGN2SEVSSGVtdzJSVlBwc05QSEQ3Ky9yL2xYMHdEMit0TmZuR2Jw?=
 =?utf-8?B?d0RZYzJYUGJNNlRLVCtWbmJaT016alB3bHZaMndUNlVoR3Jxc29HYms4QmVQ?=
 =?utf-8?B?Y0ZkMndza1RNRXdBazViamd5YWFVRUo5TG1xK0JYWlY3eE13aHFqYmQxbDVY?=
 =?utf-8?B?eGVIeFBLU1NMbUlQTVpoOXRqb2FpWXg4ZzRMbGJwamF4TDBvYlQvclV2WFBu?=
 =?utf-8?B?NmwyblpaNUd6SkljWFlMUjlaTDhiWU4zUjFwT2VpVnM1Z1pVSDlFdCthMzRr?=
 =?utf-8?B?aFVmbXJIbUl5bHRGdGttQTJpZE5yejRmYkVOdC9ZM3VjL0c2K2FZdkpQT2Zj?=
 =?utf-8?B?NVpVMnpINFlzckZJNExnQm9sd21QaHR3U3FzY3NhUFFWQnJZQWFmbnVNMjlm?=
 =?utf-8?B?WmI3U0Y3citzbDk0NjBWSU5YZDU3RTRsYXU2eExmSnEyakVVWjU5cmlYcU9o?=
 =?utf-8?B?S1pkazM5NTg1emp4NFRYUTlaYk1abEkvdEIrOXRGRVpvcEFzYVQrOHJvNU9J?=
 =?utf-8?B?VnFidmpZc0xnS0grTzRwUTFLNTFxM1A0bVdwV1UvQ3d4NUlHZ295VlFEeDFx?=
 =?utf-8?B?UGltNDJoTzQxUXJMeTNWK2hWQ1FRaGRxM1U5SkZua2N2TVhZMzk1Wk9XL1Fi?=
 =?utf-8?B?ei9ZbFBudW0vNlB6emZENGF3M1pRV3NBT1VCdjZtdndmK01ZVFZDcjU4Sk1K?=
 =?utf-8?Q?gnb73cznlAasFOURZp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b1eb29-628c-43c0-583b-08de79b9b251
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 06:46:00.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yh5Dmo6efADwwbNDbajuL8IHMbZ+cXa5yhxdZ+5A5QgZAP2r4FLlDxY54I2hlwlF/lipkoo8JOaRTy3JFP6NDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079
X-Rspamd-Queue-Id: C11291FB4B4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72660-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 3/3/26 23:43, Jason Gunthorpe wrote:
> On Mon, Mar 02, 2026 at 08:19:11PM -0400, Jason Gunthorpe wrote:
>>> Oh, I thought SEV-TIO had trouble with this, if this is indeed the case,
>>> great, ignore my first comment.
>>
>> Alexey?
>>
>> I think it is really important that shared mappings continue to be
>> reachable by TDISP device.
> 
> I think Alexey has clarified this in the other thread, and probably
> AMD has some work to do here.
> 
> The issue is AMD does not have seperate address spaces for
> shared/private like ARM does, instead it relies on a C bit in the *PTE*
> to determine shared/private.
> 
> The S2 IOMMU page table *does* have the full mapping of all shared &
> private pages but the HW requires a matching C bit to permit access.
> 
> If there is a S1 IOMMU then the IOPTEs of the VM can provide the C
> bit, so no problem.
> 
> If there is no S1 then the sDTE of the hypervisor controls the C bit,

sDTE is controlled by the FW (not the HV) on the VM behalf - the VM chooses whether to enable sDTE and therefore vTOM.

> and it sounds like currently AMD sets this globally which effectively
> locks TDISP RUN devices to *only* access private memory.

Right. The assumption is that if the guest wants finer control - there is secure vIOMMU (in the works).

> I suspect AMD needs to use their vTOM feature to allow shared memory
> to remain available to TDISP RUN with a high/low address split.
I could probably do something about it bit I wonder what is the real live use case which requires leaking SME mask, have a live example which I could try recreating?

> Alexey, did I capture this properly?

Yes, with the correction about sDTE above. Thanks,


> 
> Jason

-- 
Alexey


