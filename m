Return-Path: <kvm+bounces-72329-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMddCsbTpGnHsgUAu9opvQ
	(envelope-from <kvm+bounces-72329-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:03:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F531D2043
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 01:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 761963029ADB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 00:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70B3199EAD;
	Mon,  2 Mar 2026 00:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lGLY9ZHd"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B801A9F90;
	Mon,  2 Mar 2026 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772409709; cv=fail; b=NswKtDfyeC0qJRBml8DiOTjL8zBvvQ/KOJgOiSGAZl8QqE7GApKH0uvqVCKJODF6k0t6looi8bvL+Xv+93BDgZUAuuGvIfUAJ22nPThesPlVGOG2DECqnilPZhPj1ntezGuCwb1cwDnDFzcsVc2rBQmMpE1lhWI/U4w5ZQYdXdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772409709; c=relaxed/simple;
	bh=jdzxwSm7ai8ePebrDSsNmEaPLrqyXmoa2Vq6Avz5D1M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=biYGv/2AxrodbwkUZpb8ZIWMY6voIr0pi/2h18/q3o/0wPlAHmJxIIdGeWfpVhwv8C47rcQ+0e2ZZV0i0yNxvGc6xYPERPF+MfJcj88GBCUsVudWKtPaeolJMwdLo38USmRZzj4Zu67zs/K8BSYCUjar4fXadfcbqxPBQQDykRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lGLY9ZHd; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAfvXYdgI8ezC+kFt8MCMPiozWkNgwWvfCAQWyE2x2w2x2MhfiygRyMVWeKf5M1yQmmqikh2hUc1Srw/hIOSEFQg1ULZjcRMdbVg7FWDUrri5X20rKeO9YzAB9lEr+Nre/QSbXosxR3R2fe2LFwshvUWd92LKh5LKY9bUhZXIEzsZZASQRX0SRqzrM6uL4fi01Q6pFFLaxv96JaNV3EarzgUNO5j4faCB3hM/m8j3t24ZMl3J9z6aXFd4coBoG94XfmSKpcPEGrGna3Mv8kLzXRhpDZ3ZVYcvlLWx1eEqtEDKngVn6pXxUPMoqKmsIClNtMqPE3elbyZue/cKf6STA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6G+K6cCwnv7M5AQHuUxt4whVOVF2uupdnefYegrI1I=;
 b=iDa2wGCxRKJCcRbDRdR02exC9HVTPbCv7O3OTW+sBnbY9+u74km6SVRWAugcjy+2kOoumNLZcFqvZy9Vk6l8rH/GbYZ2Au/9fZpvis3CVD5byTRN94+uG85ZzFGQTR/0mVMeUa7Si+/pJNvVdmzalHqAeGsNTDyLp0GZnQumCUKqlb3QQ2dUX+OfUcpuyLsQxvd2uXLLllTwO2CvaAsbH7UeSW4l309ZpddY8pYebiB+gQzpJgNcogx1DqKdDy8Y8QJcCL8Qq2H+l9id2/dxoB98YRcFNphfjPzGpxPR3WvKE2CwPwR6QqAHM2V52qoam0FwCxawPeINaHpJ2KCfVA==
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
 15.20.9654.18; Mon, 2 Mar 2026 00:01:44 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Mon, 2 Mar 2026
 00:01:43 +0000
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
X-ClientProxiedBy: SY5P282CA0169.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 5da06fa8-4dca-4e13-5246-08de77eee396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	C4lRfZlfTqTbf8FKNex05gWkG5RAV9yM2G0vGudnzJbfmzSZffJWeyg7PsSMAz2wfb9E89DGiTBVj/03VSt/RFAEjJhnu/PvZAPsYYwI3L4C26IdKG3lfZ/h3C5syoWCjRCXyRtczdHP6xoIWWjc6mkqJZPBDaCXdpcbhjMG/wixe0ahzefaDTpesIwvCMZpHWC1VU4rK21xIm4UCSuuku9tYB3mpYZ+JdZRUY0lsFBWkRZmrIvtCiYp40sOH1nC08v8AmRpHk/hBuR/IPyIbm/rPyPQHwniYGO0l+lD8RJGjlaZwkNnaIdmQ3mLYZcFaMEVAZGByiBQRngdoSxpAqcfTbuR9wuWClbJ43BHHGcbsuJXE/ViqCotb20doytNPAS0FjXNHhwps8Tha3L9Oll6/yfKABHO7VkhaLc1UqLwJo3hoPQNWUEY/EIG9cev3hsmmEvRa1cutQuvyx/OcO6NFSkIPI3RyevjQ0qg8mZRtaRKFirDuHMEMfxpVyl0sGLohkJbvce5IKDqhfOWCfSrJHnl/dBLc1O4K72Iz/XVnObfqXLWGZ3o1fljK2zcR35KAOun2mFcv3L2sPVHIh/wcll1AUX1urKAnf4btMt6dLcjMSULGQBdMwd/5uTq/jnwz99+gtQBUtdTfuw/+q74vkP9xuS9p2nt7wc4Dvc/TPQwH6pFYTH0N0l/F6qaCltfzWf6PFKWCZk2xzZLZIsIJHhslW1sKsHuNcybEtA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFY2UDV5OUxIQ1BpSzJQM0dCc3FMS1YwbnFuaTY1QTBxOW04MUp4SXBPazND?=
 =?utf-8?B?WVNrRzh0MlNWclNENmVsVGNJV2dLbmhmVG1qMHlxSlYrUXU3ZGhFZ3FiM0VU?=
 =?utf-8?B?Ymx5L1VyajZqbWNaYmhlcDdvSFhLMkZKNW02ZC9YSXk0Y2hteGZ4NXdzV0NW?=
 =?utf-8?B?UzNwTTlrNVJMVUhFempuZWJCcjJFMjk2U0l3eDVXZGdnNHluaDRYRmVrMmRI?=
 =?utf-8?B?RTh3dFowTko0TTczTjlpUWlPNXFxZHpjSHBsb1I3OXdjRTRBMDhDT0c0Wko3?=
 =?utf-8?B?djZBQUQ1OSt1WFRxakZQOXNDd0VhMmNmb0R6Z2luNFFJZEJRc2IvY0w1NHRC?=
 =?utf-8?B?Mko5MWhvVWtIUDlLZ0NJL3NQUTVQQzU3L3pIN3dIUy9LSm9YWTZIV2VBR2JR?=
 =?utf-8?B?eEdyQndxR2FFbTF0RGQyRTJGTkpjL0ZmNy9mY25hVHpWcnA2Y1pzT1dXSVhY?=
 =?utf-8?B?VEhIalJMVHM4QSs3SkUwM0tJM1BOL3AzYVVBWk9RM05GTlh4cUl1TExJMWpR?=
 =?utf-8?B?WFNSZUxEbXRwUEZaQzc5Z0dPYUlSYlRrNERYRE5vekJmR2tqaWU0TXZJTmph?=
 =?utf-8?B?T1hOTWRtNmJhQzk2K21va3ZCbUFDTWVwSGJsNk85ME5aV2EyOGVVQzI1MDFn?=
 =?utf-8?B?d05iTGI1VDJMTU1PWWVIVXBVUXhtbUQ5YWY1TTNJbUxFamhqS0N6b0ZScDlp?=
 =?utf-8?B?WkMwYUxuanQyYTNkT28xR1JBR2lSVkw2ZU5wTUd4eVdzelg2Q21JMWJBZWhL?=
 =?utf-8?B?bFBiU0JxQ3VQNzNnQ25rR3J5V3FBRlczTHFTbVhBaVJoNjEvZ0FjcHk2NnNk?=
 =?utf-8?B?UkJadnZ6WWpmcXlKdG1lcS85bTlWYXZyZ1BaVnZZcWovLzRnd24xNEhVbGo1?=
 =?utf-8?B?ZFpxMk82R2hPckpJamhWV1BwSWhHWWx4ZmN0UXZHTHZVdFNvaHBtTk1nRE9K?=
 =?utf-8?B?eHEwMmtMYTczcGVyaFBsSzkyeFY0TkVPNE5KTWRlUzQ3WEV0NDdma3kxaWpn?=
 =?utf-8?B?dURORnRFejRUS29CZDhZMG9TUW5kamFkUE9yZGkwUFBrT0Q3Ny8xT1BXVURT?=
 =?utf-8?B?SzRhYVR6Y3djTmtLbkg2M1RYMGU3VmduVFphSEhZSXRpVFlsQjNjOEdGSWdB?=
 =?utf-8?B?dTYxemFQZGUwZlRVQStGQmtjaVd5R2ovWmwrcE9HRitTWnQzUnRFZTBKMm8v?=
 =?utf-8?B?Skp0c0lOSTl0YWIvLzlSMEVLZ2tiUjhuQm03SVVkRlJSaTJlM0dzVk1Tcmp3?=
 =?utf-8?B?M3RIa3RVa1ZKMThUYzlzekZlTkViaGRFdzFaMzU3ZVluNEw0SXhFckczM2dG?=
 =?utf-8?B?T1MzMGR2dktsZVlQWmx6a3ZuTWxPQlpQSWFadlI0dll0bC9jaTZZbDhYSHFS?=
 =?utf-8?B?cTVEU252K2VjNlBpS1NabmpGM3pxdXJNVHhIeGJNWVhSWTJOb2RjQys3ZUc4?=
 =?utf-8?B?cndkdDZMaGRLNVZmVkorR3pYc0NVU2dMaDQ5MHlvcUJrS3hzbkt1Z3V1cTZX?=
 =?utf-8?B?U2NkTnVYQ0pMZEpLNnZWS1F2aHYwWGZYYTRSdHN0UzRGQlRGdzRKdjVtNTVx?=
 =?utf-8?B?ZktLTlRFSGlGZzB1ck1UTm9ncVBjTGhNenYwZWJnNW10MU14MTJHTUlsRGt4?=
 =?utf-8?B?QVdVOWs0cUdrclN2UVIyTHFmSVlUbmFUTjlyQTltR2duSGlJT0RabVNwOEJ2?=
 =?utf-8?B?TDRaSzdIa3Y3VExRbzlQOTl2dHRTdzNrVUxYQTJzY2NaTGtDc2xnQXMzNVFB?=
 =?utf-8?B?VXAycjd0ODlqc2U1c0dQQVpsOFp1VGZ2NzhJdlZ3RHppUDY5SEZ6OWJOeXFB?=
 =?utf-8?B?TTlpNHFxREl1cXVXU1NXQ0h6eENhMVhENDlVRUFrcUFwdnlUa3NUMy9hQTJZ?=
 =?utf-8?B?Ukx0RkZNY2xpaDBuZjVrQldoK1hmUldtQkt2TGszalYyVWlMYVlWdG95am1z?=
 =?utf-8?B?ZTF3bWkrWUg5UklZRGFBUTFodjV4R3ZDR0k1OGZyWFdkcVhFeDZ6NlVOajZ0?=
 =?utf-8?B?Q3pBNEF4dkN5SXJvRFJ1dUdiSWt6RVM5MWVVcHVjZnFFQW53YjJyT3RvZyti?=
 =?utf-8?B?dkR3Z2toM0M5K1NXMFZYckxIWW9EODNzRGdxaEJyQlpDVjhxd1FBQWQ3dldh?=
 =?utf-8?B?d1dVYkNFdWNrWnZiOENtbURKRjI3SzN2d0xLRWF2M0g0WjNuS0Z0RkFOdUFk?=
 =?utf-8?B?MnBNQmdmRk5hU3J5YzlSak5RVVVmcm1mQk9xRlZUVVIwTmloMWE0YmdVaXgv?=
 =?utf-8?B?TEJ4ZnZFRndaVDVrRzdoQk1sZU9tOGJDcTlXYUVsalQ5dFBEQ3J3OHBzZUh5?=
 =?utf-8?Q?Wv1qKtqpCEX8tecgE8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da06fa8-4dca-4e13-5246-08de77eee396
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 00:01:43.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8ohIOrEC1ZDy+FX7b3RDgX21Uj+nhkqU9SivrjyIU52+M0ADoCYqfLFDUvn1q2+3G+yo8zIh7+MxP2q6GeOHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72329-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 84F531D2043
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


