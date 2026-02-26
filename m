Return-Path: <kvm+bounces-71918-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBF5A/nCn2nkdgQAu9opvQ
	(envelope-from <kvm+bounces-71918-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:50:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B771A0AF9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAD97305C8C1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 03:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6F338945F;
	Thu, 26 Feb 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xNdB5Rxc"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64623BD05;
	Thu, 26 Feb 2026 03:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077796; cv=fail; b=FHoafanqY5YnETig7mCtRTAb2mNYBUbEgCW5ZW8l63siHUewv83HCQ4Q3p4CMqAwq+HwLlziztaaDgaJRHMmupg2vLHLgVR4fhTpREef8+dUjRkynRLHiJb7pEgK8wTFtxi0OVcncoqtmJ5nuOqQaVIsluztdXAE5MxNjKR9LgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077796; c=relaxed/simple;
	bh=szxyNBq73682TqrjQn9pXccFZTWZUL3iWuSWrg/kvWA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N27P9fQfgEnCdpUbNgHwilyj4txXeNTP2GdZZihmUpyzLNtvAOjeH61BPyO/HxmNFEyVrdj16K1soXBBOnLVGbY22uJGagcseIHYsz7NmV2GUZvvYRDnVAMWK6IVUHjXtbhxM6XAktHn0Kh4nNuC2zjqPonoKCq2NAS61BVDcMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xNdB5Rxc; arc=fail smtp.client-ip=52.101.46.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v672N+cT402kBaKBVsIPPJ9M7VL0hbmnSlBt43cSd5HQE8YzFhE/lsTsIwFupaXQNWdLcJFeO+gAAXyt56t6Rv8WBhFER/AkoxdCyertprdwWBIwFZ/NOPUE262Tt2pkb7mvPbFXto6kTSbR/w3W1ti/XLiJMsbBCd6knlv9Z1mAHC1JhTBYkgFutEyO6bIYOgibsKVzbHC1bAjwwPpOWwm4sC2uiRMWwVZn8ILy1CK/zC5GQTFoQff9ZdZKGI/HufDBRwfAhhosEh7895ZWmBJkNAV60DPMvBqKia/5vAZ4XdCcZIugASVmWy+u3aYnqw+hn/Mk7b8dbZThtYrVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=au+yFH7CuZ6zde8T4PL3Cev+WbYOzWUndk0xdteYb8I=;
 b=cRbOXXaIv2KEZ1eomLN4Vu1sTtf4DyDbOZtICaTkK64GoYmSW1gnW6CyzAMGHRKehyq8cxCfaSN5wgnWj7j8qSlv+zlFcSNflNh01P96MHNT9iTRn9ZlOe1ywvkgTNbIBT5pzU5WzRV+er+RxxOwTXDm0kHC2Te+D5cKXJ5zmIExsMOBS0mOl+DSPfIPK7All2CZS332akZiYQapAHjgOoqu2vjM3dQX8SpkKxLQk8cNO7E0/FdfD6RHH+xP7sV2EQ+vxDCm5SK0TE0wF/+6Y6HMQjNfJ9fw6NZf3WEIub/rYhfjD1PbOG8nq9+eFYUQThZM4JRteafO0Df0A7vFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=au+yFH7CuZ6zde8T4PL3Cev+WbYOzWUndk0xdteYb8I=;
 b=xNdB5RxcfoUbmnSxzCuA5lDiEFRLYsm4C8w+DOvfybaZ5vxPcHeAOYMlTKRYT7MjKD4q9Rqfx8U0z2M+D8izqdcBU8cvrV8fyaTIh8ZLod28NTvd03B9m0Ql9tCMXLxu8IHRopj6/OMelBcpl1An2o1O75ySxZCWl935GC+Y/eQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by LV0PR12MB999093.namprd12.prod.outlook.com (2603:10b6:408:32e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 03:49:53 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 03:49:53 +0000
Message-ID: <06aa8d10-766f-45d4-8205-0ffc2f26bfb4@amd.com>
Date: Thu, 26 Feb 2026 14:49:33 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to
 parse it
To: dan.j.williams@intel.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
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
 <20260225053806.3311234-2-aik@amd.com>
 <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
 <d8fd6e0e-a814-4883-9e58-f1aa501e0d8c@amd.com>
 <699fb11e94082_2f4a1007d@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <699fb11e94082_2f4a1007d@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYYP282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::23) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|LV0PR12MB999093:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1f3e46-979d-4b10-5478-08de74ea192e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|7142099003;
X-Microsoft-Antispam-Message-Info:
	MQGJb7ufzSpLRqVzB1clO3zm+Phv6tVxmHY58Od2CsSpshD3co6FJxDeCfChqYuCmCrzrMizDyz9Ay1RWUbRfk1VE3DzyeHz/VQ3j/HL1bE7qdZXBrZl73FTkzI219//pyUpSlsaPMlgNqDiCJW8DcU2IoTAaaKbBKITEWVvcbErPcES7E8Tm7rkNV2uH1Yj3BP7oRDDEQQeSderGSKAZP+JTaWcUY/YnNfZvYAH5QsbKI+ChKdOLcDknUwSzdEBJmVSKF5BLetZ9VYCOP9X4uR6hWRVnIRXbu/OxBP2vd2xqq+sHqTjlpQ0TFDDEAYaG2rQh5JZKFIhilT7tGBP1322yu3xP97fFmUEBmUaMv23mJMUQ5Ubk01CXm5hMSVALIknAp+ioafiayVCgPEJD121a0rDH9XDrqH6w1ce1GzUbmdgGX3lny4OwRy5K6c6cZbyBFw4qG5EjCO02E6HEq4kHjPNJdWq1EdaUXK4vm78hwFu3n/ttU9YY6FqlAQcFZeW99J1hEQiBEoFXzCDnZ4QOzKvzGv2pE6PCGujEsaeNnWrF8OcKd3Zfpss5quWiwt9+YDRf5j6DS2j/MdCO2X923OW7UpkQpN90bwGjst7h1bEo6d64XP5b7O99oR3mpbqiIMG7qG2kU1cl2o6ac5AGZ6etUK45KHGEketRoiZcZnHxmlvqE8QTwD2pjU+MuEk1UO5mau15AfutoPcwX4n8Z7LIEtJOA+G2tO5eHI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2FJSjBzV21EeUpWRk9LK3FtdFpubkpZUW10TXNtN3pkbFMvRXRtZDM5WDdH?=
 =?utf-8?B?T0kyVVBOcE9TaTRUSnp3NmRnckhQNzBkZmVYVmJNSXRqbklZVjRvK1pBMG4v?=
 =?utf-8?B?T0NMY1JsRkxvaEpnZWdCSHpBNTdTYjlIZ2pib3NzNjU1TFpJWG9tMDRxMW5U?=
 =?utf-8?B?MnJPZWlEN2FwbTYxUTB0VGdMM243QVF6dC9KQTczeEFhVFdGdWdMWFhKRDZY?=
 =?utf-8?B?NzFTWU5taGtTa1dkR2Y1bnhmWWZjY0MxdkVCQWhwanU1VTd2Wm8vVytldUxL?=
 =?utf-8?B?UnVPVTJTNVdDRmhjcjFDM2tYREtBMVE0c0tHRVlpRHVFcEpWYld4OGlQTEZY?=
 =?utf-8?B?TjZ0MWdSVnlIc1Yrci94RVRTdUtqcjUrbHFrbVppR2d1cjJCelRsekVUZnh4?=
 =?utf-8?B?TFZPZ1owOEJkZ25hN09takYySG9BSWpUSUJzMlhGSjJ3VjR0d2hGNmE0MytN?=
 =?utf-8?B?ai9ENmdCN1FHSkRMWXpsRlFabTdMSU9GOXRBQURkNDFwSEE3ZTJYS0J6b0Zp?=
 =?utf-8?B?R2kyN0NUYm9LVStBSWd3YkNRVGhMaXp6dDlUYTY4QmllZEVOVUlpUG1DOUVu?=
 =?utf-8?B?ZWI2ZVZvNm1GRUk0M2FRZ3IwVEcvV2VTSEFOY1VVRU8yY3UxNjFrdnM3UDI3?=
 =?utf-8?B?Qk1Ra2dBQUN5SFZ1N04rblpCRGo0aUYrZVFJaFJOdHI1M01FYlBLS1c4bjNh?=
 =?utf-8?B?VytJUVhtV0Qzb0Y1L1I3UWRiVGkwdmczTnVoN0dxUlVleVRwNGRrdllraHg5?=
 =?utf-8?B?bHNDU2owRWttSzZ6UFJiWTlUUExIZEkrWlduQllaNWpXVXl2Rkp3NzRJVXhm?=
 =?utf-8?B?T2duVTBiSzFGQzF1WjFEME8rUXlDMTlFNm5neEdJZWdleTdpMERLR25yb2dS?=
 =?utf-8?B?T2sxRUhlNzNPOVJIVHNZQktUNDJNTnA3OTB3eDBmeGpOdVpwY3o2M0ZHd0dj?=
 =?utf-8?B?K2tLQWZBZFZoMlpqbTdUaWdsS3ZxRVV4emdPdUhiOFFYK0wzTHpWYVhTRnlw?=
 =?utf-8?B?RGM0aVduODlOaW9lSGJMM090WHRpVlhQYlFMRlduR2ZwSWo0VkhDRE9ENWhE?=
 =?utf-8?B?U2pyTDlxbHAvNnl3S3IrRnBMRVhkaHdIQlU4YlViVkNQOFpNWUFteTk1Z3c3?=
 =?utf-8?B?L0VkbmkyY0grWGVzeFU0TExDQ1VicFI1VlhvLzhOdnlGb3FaUi9pZWN1M1N4?=
 =?utf-8?B?SmNTNzdQRUtRYU1seENPeTE0czAxZ3Y2V0ZIaDkvWEhoWjRNSE5QcllEMGRp?=
 =?utf-8?B?QzhXVW0zb0tQU1hkMEFIc0Q4TUtsV2NYcHFGNExDRjVGTkV2MGNrL1Z4a2x5?=
 =?utf-8?B?Q3JQSktjdFFKSWRxRzlBVGREeFBMS0x2YW1HN3Bad3ZUek1LWUowYzVZZVhP?=
 =?utf-8?B?ckpVL2RUQ2lYYW43WHhrcmNuTFhUSG1oSm44S2ZOSUEwYml3UllvQTNFeHp5?=
 =?utf-8?B?c2J4dVYvQnpvWENnOG1WUFd5S0c2UldtSFZraE1Gd3VCampDQXI0SEt2R2Nq?=
 =?utf-8?B?N1pHeFJ1UGpmNlZVTlBJM2d6SDhzM1JmWTM0Mnhmc01MYms4VjNFSndIdzZv?=
 =?utf-8?B?VWMvM2cxdlFBZmVHaHQ5MmF1MWRkNGZoK0RWZ2xqYnpjNHpUTXN5RGtKMk1k?=
 =?utf-8?B?Qlp0ZVVQbTdkYkw1bVZvei9HcEU5QVdabW9TTG9DMG9CQVoyUzhWSUdZMHBi?=
 =?utf-8?B?UlEwV3FKS00weHZBQm9YTndrNjdUUlMvWDFSREJ5S0NIM25jaXpOdzhtcnU5?=
 =?utf-8?B?L1lNTWdMZWhlUHJTRTRlRWdaN1oybjZxVWZueDZSRmpodFlHN1h4eWVBNC92?=
 =?utf-8?B?dXY5TDJEcU9mblQ2Wmt4alY4WDFEcFg2MzVNRjBwcm1ab21yU21UalRTcDN1?=
 =?utf-8?B?VkN1VVJLV1lsNWs5d003TXY4WWV1T1h2cDFYQXJuM29qRlVWN0x4bWJhblYz?=
 =?utf-8?B?cjc0ZmNSMUVtajdUKzRtSlJha0dwa2V2ZzE5SzRVVWlrd0t5NXY4MThsRzZz?=
 =?utf-8?B?eG15ZE9mUmpPVkxOa3FObHh0MmxDWHBKd2krdVJLNDBac1g4UVZ2SDkzT0lV?=
 =?utf-8?B?ZkxPelh0bGFpbU9lOERyUERRcnVLK25wdk45UjdVT1hLTjBrd2E2QmQ1U1A4?=
 =?utf-8?B?bFZROVpxUXFmenNUaisyNDhIODZZRnQxbEZBYnZwODBBZlFLWEZ4K1VDdkpH?=
 =?utf-8?B?cHhSbDBlbkZyKyt4azFjdHgwTXlNa0VJVUJNRi9wRkMyMUZ2bm05aVdST3d0?=
 =?utf-8?B?RWNMb3FBMmgra2M4SkZNd3FJUGVYZUM4cUxoZENGYUpNNExBb1o0Wm5DVi8r?=
 =?utf-8?B?ZndvWHFNM2RzMkQzRzBLdU5yWitZeDMyU1FOby9iRGRVK2FBWSs5QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1f3e46-979d-4b10-5478-08de74ea192e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 03:49:52.9992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lr0JHQPH76BFPcvVkr9TGVnwj0NXyvoAGwD7WNoRyZkkROMHIfE3T0phbOKbn7Zjd0aV0IotdamGixCFb7e/+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB999093
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71918-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 62B771A0AF9
X-Rspamd-Action: no action



On 26/2/26 13:34, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
> [..]
>> I cannot easily see from these what the sizes are. And how many of each.
> 
> Same as any other offset+bitmask code, the size is encoded in the accessor.
> 
> Arnd caught that I misspoke when I said offset+bitfield.
>>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
>>> #define  PCI_TSM_DEVIF_REPORT_MMIO_SIZE (16)
>>> #define PCI_TSM_DEVIF_REPORT_BASE_SIZE(nr_mmio) (16 + nr_mmio * PCI_TSM_DEVIF_REPORT_MMIO_SIZE)
>>>
>>> Any strong feelings one way or the other? I have a mild preference for
>>> this offset+bitfields approach.
>>
>>
>> My variant is just like this (may be need to put it in the comment):
>>
>> tdi_report_header
>> tdi_report_mmio_range[]
>> tdi_report_footer
> 
> Does the kernel have any use for the footer besides conveying it to
> userspace?

PCIe says:

Example of such device specific information include:
• A network device may include receive-side scaling (RSS) related information such as the RSS hash and
mappings to the virtual station interface (VSI) queues, etc.
• A NVMe device may include information about the associated name spaces, mapping of name space to
command queue-pair mappings, etc.
• Accelerators may report capabilities such as algorithms supported, queue depths, etc


Sounds to me like something the device driver would be interested in.

> 
>> imho easier on eyes. I can live with either if the majority votes for it. Thanks.
> 
> Aneesh also already has 'structs+bitmask', I will switch to that.

oh I just found it, more or less my version :) I can add pci_tdisp_ prefixes, should I? Thanks,


-- 
Alexey


