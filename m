Return-Path: <kvm+bounces-25638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D18967D3B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A12D5B210C0
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B7417BD9;
	Mon,  2 Sep 2024 01:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OeP814ya"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4682CA5;
	Mon,  2 Sep 2024 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725239406; cv=fail; b=DsrJApd8CUQevh/rkArAAWmw/b/A9YSXf5PacMuLOlt8jxgbz7elmeJNcakXmOJviAp8lK6XzJmZ259TXyihXS3TiCtfRyaH6OHeIG174T6lPGKC3JJ3GcGDElOCmLAeHCQFyWKqK4GJwvxn0q4gjYGkVmtc7lpIWmGp61+r7jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725239406; c=relaxed/simple;
	bh=W4wSlA3XuzWVCnKDLTZfFBOJ5vC4AhK76wIFZrp3nlY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I/oBXLflOr5j8/Mlf4N0nqbQLfhX5M8kz4Irb3KzQHDJ0XuTN4ZI53sYjOZavE/GllxuuugX2u8kmz2blgfcgbyC6QEn0WDNOSMha+PLwb5wd0G4EUzeyUvRSROBcQdZejbYwLtmp9cTkM6FrRcm8Zn6pm+jYagm+oHcklCZwzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OeP814ya; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhnahcFRJPVhfQr3eZvsQuGuVl45EKVJKNTtWk+ymHIZ5CmQt8Qhm+9D3lZpQO6enqrMWUfnPKhtnn2jfhA4BtSQxh7RIKYpzW70Oildi5EfUS4o2JDmvP7YBKOEJeSkjk+kzMSRvFVbANn1LYm/KWQbaSjSaDrCsvW1U2e8KYFihb3c3Z3GDN0497mOeT53m4ztdg0Y0qU/il8lW7Tt7Yg7GmWs1aJ2WNPEPyGOaZdMH/GOywYwlDb4dAFUM6hswTu3HUYSEtDzb+Vi9Y76EFZcQZWDnlYgSYfxQQFVKyRoPx3gZ0a/2rrOsDWMsMBNrO1954KTVWK9h4pNSZBhyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXViessMbRtl/bHhWOeD7SXR/n035vIXMt6a5zj8RO8=;
 b=vhKH8RIQCGMkKN9Na8OWlbtCNcSsMvjiQJN6vBdBf/Q3j+Hc0xLdxwH2Yxq16nREb9fRsRmM/u9nNOln0zFxq5VBgFEca0kCYeXAcDrD/gX8dum3K0KLhoTXw9sD/OnOFqYZxfikUcvorjrsd4dwqwNPVYlMrn9MZNUMtDQC6tFxVhuTr18F61MBLdpMc1aNgzCM3o/w+ATOpk59dMqPXNEYMIDzhLNyu49m7w3ZFuXFK3GmjofZsu1teInEZ03KHHw3A6hXcFhQnWeCMfGPqTFwVIPwVODH5wVTsspW67k/XdMk5Uh8xEEVqVyhakLH8vNbcWCBo3vwTc6NJQ5fEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXViessMbRtl/bHhWOeD7SXR/n035vIXMt6a5zj8RO8=;
 b=OeP814yadmPmo2wXWVu63dxzaLD97DON2sPb6aPQzhXWmEs33To3Sb+U3k/at9gO2nFMkNIQSsS5AvCvGNZU5nGwZnCoJjZWgtOHS7VFHJz8QnTZXyjGr2Iu2NIsVr+U+S3eq0VzX5ena3W5KA5EgbM+psg/7uQm0d8OQ8kmtmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 01:09:59 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 01:09:59 +0000
Message-ID: <7abbe790-7d8e-4ef6-a828-51d8b9c84f33@amd.com>
Date: Mon, 2 Sep 2024 11:09:49 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "david.kaplan@amd.com" <david.kaplan@amd.com>,
 "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
 "david@redhat.com" <david@redhat.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
 <20240830123541.GN3773488@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240830123541.GN3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0103.ausprd01.prod.outlook.com
 (2603:10c6:10:111::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CYYPR12MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: f936e52e-59e6-4ecf-1be1-08dccaebf73c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWF6cnNkOWFyUW1tdkJaVklvUTBvNVg4QUI5bUNPMk1hbW45QVN3bUpBTE5I?=
 =?utf-8?B?bU5wWDJZbzVUaUtGdmNmNE41V2ZGeWRwMUZ5M3RHdGVrNmlVR3JSZmdXS1ZU?=
 =?utf-8?B?UVhGRVRtbXhQM3ZLeEhnYUdrNDdHUSswRitZT0l3WmpIWi9TYzUyWFdndE01?=
 =?utf-8?B?VWs2NEQrY0hNL3JLOGVDRVU5S3h1Mk9MVU83ZnZlMU1iZEpnUFpYNDJHeitN?=
 =?utf-8?B?K2ZZQnBlK2hUYnlGV2c3VTdnbWFlNFI5Ui9Ia0l2MVE0aGc3TWdYOEZwMmtj?=
 =?utf-8?B?c3JGeitlcnkzbDlDTlVTeE9MeDdiQ3BaS3VCVmRNQnNxUk9yZXNSQUdPc1hT?=
 =?utf-8?B?MHhvVzZsUXBvNVRvZnZoREJWTFA2T3lYaVIvSlgrRElUaXFlY3d6N1Bva0Vj?=
 =?utf-8?B?TFBXK29vY0tPaDJRQ1BjZmVsUloybEtGcUNZSjhiWVU2UFZRQlRaSXdSZERq?=
 =?utf-8?B?TmxKWjFEWGZjRTh4aWZqd29aclZmb2JDcGFZU3YxdmhObUVZejUwdjkxWXli?=
 =?utf-8?B?UXpCTGZYMFdsWS8xRjdOdFN6a2tISStueHBGc3RFMmduRWE5Szhod1p1OW9E?=
 =?utf-8?B?VXhNUVFZMEp0Z1lWRlNMdlVsY0ZCdHRMb0g2aGh5WExQOVQ5amRleE10b2NH?=
 =?utf-8?B?NXBxVjJoclU1ZGhhWnVxelovTTRMbVVvdU1STUlrTy9KUG5aZkRkMkdZa3Bs?=
 =?utf-8?B?V3ZWejVWaHBTSEZTYjE4RVk4ZTBsNWg0bmlMZnYzNkJXcTZCNVJaWm5XbkJ3?=
 =?utf-8?B?b3FmYkQrZDM1OEV3QVlGMkhhWjhKN1c5TWVIeFgxeUVYOUoxakpzRHMvSWVx?=
 =?utf-8?B?L3dCSEZsRVJKeThTTS96ZXYzaE9HOXVZZ09rNU5FM3owY0VUZnFNVXBBeW5R?=
 =?utf-8?B?VXRhT3VUdlpoRUhYS1pPQTZHUlhQd3AydXVLZFlrUXdFa3Z3UEh5VmhleGJY?=
 =?utf-8?B?QzJSN05BQTVwdUdLTVN0Ny90Q0JJYnVMV2U3a3hmbUtya3FLc2RoNGVjNmRE?=
 =?utf-8?B?NGVmSUJXWnU4dTlwWmEwU2V6OS9ITERyNnlDek01N3VuQWV6TVQ2Wlc4ZUw1?=
 =?utf-8?B?TGpiS1hlT21RR3o1K0Rvc3JxeCtmN1lrTElBTEFYYzNkOGk5UERZTEFCcVow?=
 =?utf-8?B?OWxXVUlJUGNMQS9ha3ArYzl4VjlLL1dsTnhnbGp6VHUxOW5sdG1XZUQzNkdX?=
 =?utf-8?B?NTV6TjEwYTJqdFg0aHFyRlluaFdQSVBucFhLYXZ5V2NhWWpJeVZyNlRmRHEw?=
 =?utf-8?B?aE1kYml3LzJlbmpIeC8xeGpMaGR5Y3YxUDZUZUVObjNVZzJyaWUvckIxdWVk?=
 =?utf-8?B?TEhER201OWRMZERJU0IzdVBla1RIcE5CWGlDbmtYWnY1b3NIVFBydmdJaXpz?=
 =?utf-8?B?NGtCMGt5VDAzUDFqT1RGZHc1OVlqYVhmVWFFUGpqNFdoczRaU0pGNkpyT005?=
 =?utf-8?B?SVJ0Z1k0a2dYUTRwNktZS3VWa2lLaCszK3I0Vk9uSVBDUkhpUENsaUhZRi9D?=
 =?utf-8?B?NkVXWTN5dHcvb0ZQMnYvdmVMUmJYWVNxL1N2ZlZQWGhPVTdKc0hRUUdNcXBa?=
 =?utf-8?B?ZUhsa05yTkNpbDNMc1VOcHlUa1pqTVpqWGJOc0NiNm83d25rWndEQ25vK1E0?=
 =?utf-8?B?UVRneExNVmFVSFVka0crUEFFMkZxZ1pwaGRyNzk0cDROcTZtRGlUVVloc2x6?=
 =?utf-8?B?TWtHM2dtSzZxbUFqS04xT3JPam9rODZXUk0xRnhnakI4d2hQYTVINExHVWdt?=
 =?utf-8?B?TkNpRTNqWFNOR2ppcGgvWUt0N2VVbkxIV2duU2o4dHBOTjFLMFJRL2tpR3VS?=
 =?utf-8?B?SE9TQTNSWnFzcHZZOElQdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVlMb21hMTFhbzBhZ0g1UnBURXQ1emJLTGpPSXdwNzNrRUFmRHFmMzZjSi9M?=
 =?utf-8?B?Q0Mrb3hMTHgvNE5BZTM0N1NxQTBndFBJTStSZStLdWlDY0YwdVBZWUJtd0Qz?=
 =?utf-8?B?eHkvaytiYmtQQ2lUYytvSnJtZTBYRUZCRDcwenQ2UHJMNzNIeG9SQkVTWm5h?=
 =?utf-8?B?eWdDM3NyQ2s5WnZ1WWpXTzdvNDU5bkRJSXM1Mzd2cTdQa09NRjBnd0lLczls?=
 =?utf-8?B?VVd3dzdDMjZmcldjR0UrLzJwd0hzbnlPMjhDR2wwL0padTdCMFpDNjZTVkFs?=
 =?utf-8?B?L2lnVWpEbmNnRUhYTVBxb2FxbXhYMEpTRmFBR0t1YkRHeGFscEphTnFrTWJG?=
 =?utf-8?B?VkEzbnZpeWVHQjlpZ09yRW9JOU5lc1J0d25JYTJsbTZGKzY0T284bW5pRHVr?=
 =?utf-8?B?d3Y2a2pNeU1lSkRRR21MNDlBdlF3blNBMnV5TC8zQm9kVXJpMDgwZG43aHhV?=
 =?utf-8?B?cG5CS3hJaU94cmoyMHg3NkdGY1NHRk1SUG1uOTcrUzFkVC9KRVNDbzVGSEF3?=
 =?utf-8?B?WFppK21kZDJtS3crMFhMRk9jZzA2VWh5b2x2Rnpwa3Jmb203dmhwbVVKR01U?=
 =?utf-8?B?NG5TTWFZOXQ2UDdLVkVUTDQ4WjBqQmduMHhkVEw1T21DUVNiVGJYeG4raVNI?=
 =?utf-8?B?Z2Rmd2RIME1Sdko3OFpoenJyZ0wyNDVmbXBFakNJVzk0OU92S0F1MXNiQmNw?=
 =?utf-8?B?bEViRVRMa0tYVU9WZTNPbEI2Z3ZMakg4WEE3UVNMdHVtckMySzVyL0FvcEhK?=
 =?utf-8?B?d1BhQ1p5ZnJkVWRQdjNDbEtFR21zUFlGeHZTL25Na3FKL1R4VzJtdjBUQ0d6?=
 =?utf-8?B?SE5pNzdwc2xGS1pKWU5WbUdQMld2b1hxZTFURGdZR1cvY3FocFdic2JWQk5I?=
 =?utf-8?B?WTIxZU9QYzFnQmhoWnhHdkNyOVVyTCtGdDJ1V05SbGFYZkM1U0NCSUFYSDlp?=
 =?utf-8?B?aDl4L3F2ZnNvVmVVb3VxS0xwZk01bVBROHBXZTVWOEt6MnRIZTdhZG54d2VF?=
 =?utf-8?B?UG1UZVh3NmZWNGRZTlNCa1NhZmpFbXZFYkhUTHIvOSsxaUdMV0tHWGY4OUVT?=
 =?utf-8?B?WHF0UDF0TWF4eWJuK1ZRY1AxYVFlVUtWdXJ6dWNRQW1lcVpwRlI1WDV4Vm1s?=
 =?utf-8?B?dlAzKzNiWUF0SWtWNnhXTFB3SUhndjFONUtqdys3TmhqY3JxQUx1dVE5T1Jx?=
 =?utf-8?B?M1pOVEc4RGphQUpWazhtcWtoWCt2RjYzajN5dm1UcW1JZEppWUkyRmVrTXFi?=
 =?utf-8?B?c2hzR3A1Y3V5K1N6T0EyMkpyYkZjR0NUdUJxMzM2d1p6alZvK1J3dCtDRXNu?=
 =?utf-8?B?MWlkYzAzQ3ViMG4wajhLVGcxMEdtNEkyOUZkVjJTeWQyQ1V2aG55ZjFxVGdI?=
 =?utf-8?B?MjNNdEJUWWg1M0daOElRRjBjMXArWWZYSWEwTkF5bnR4RkhZOGVEZG50SkN3?=
 =?utf-8?B?UjZtQVNYQWZvRW1oR0t3SytJSTVoQnl4blBmMzVSRktBUjRxTUdFc1pYOXYw?=
 =?utf-8?B?V25FTU4ra3dDN2ZwU0U3RzNyQTlUcENhM2tsRUIvaHNQMXBrb3hSNERmNW5j?=
 =?utf-8?B?Z2RzSWRzclhYS3ZlMEN5dDNzMHQxQ0dRSlpHYWdpV3g3Ti9hTFVtY09sRE1H?=
 =?utf-8?B?SklHcld6MGgzYThNSnVLRHI4N1haTjFTQkN0YUh3dkVXNlZFdzl6NU5TOUhl?=
 =?utf-8?B?bG1mY0tTczVyU0l3L1ZsN0JIMW85U1RZUUlpYXhGOW5UbXlpTDdOVWdmVTF0?=
 =?utf-8?B?R0tROFlhQjJsRlRmd09oSGtYWmJEZktrM2dFcXpQV0trZHJOeGdpTjJCSm51?=
 =?utf-8?B?bk8zMjJ4Ny9Lcm96YnlkSjlpbnFIcWQwcU5zcFZmYmI0M2U1aDBIT2ZvRTZo?=
 =?utf-8?B?bk5Rc093cEhFL3R0cGh0aFZtVXNPQjByM1JoWGlBS3p4OU5SUWVrc0dLRzQ4?=
 =?utf-8?B?OGNCeGh0UnFlTkgvVDJWWGpRK3Bjc2RqVlJxaWVBZnU4aHVDNE56ajhQWXRL?=
 =?utf-8?B?cHFpbkxVSmExeFZNTjQ4dEdKdEdJRlF6OUV5cVdxbHd3ZWJuOW1ReVJXZzBO?=
 =?utf-8?B?NnpENGk1TkpnVEdrdHhUZXVWVEE3cndudlpRdUxuVytnZXhZZzdsSVkzK2Yv?=
 =?utf-8?Q?rUz2PqF5w1i/OVhbXYq/lKZyr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f936e52e-59e6-4ecf-1be1-08dccaebf73c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 01:09:59.6805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5ltR05xG1P2mgCZyN+F+YGEvJ0+SDRCcXnp3X72llYf9769Hd32nBZcXgQ+LTyQYB6e+Zvmtx/+XOpt8iwyDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731



On 30/8/24 22:35, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 01:47:40PM +1000, Alexey Kardashevskiy wrote:
>>>>> Yes, we want a DMA MAP from memfd sort of API in general. So it should
>>>>> go directly to guest memfd with no kvm entanglement.
>>>>
>>>> A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
>>>> takes control of the IOMMU mapping in the unsecure world.
>>>
>>> Yes, such is how it seems to work.
>>>
>>> It doesn't actually have much control, it has to build a mapping that
>>> matches the RMP table exactly but still has to build it..
>>
>> Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to host
>> physical, if we skip IOMMU, then how RMP (maps host pfns to guest pfns) will
>> help to map IOVA (in fact, guest pfn) to host pfn? Thanks,
> 
> It is the explanation for why this is safe.
> 
> For CC the translation of IOVA to physical must not be controlled by
> the hypervisor, for security. This can result in translation based
> attacks.
> 
> AMD is weird because it puts the IOMMU page table in untrusted
> hypervisor memory, everyone else seems to put it in the trusted
> world's memory.
> 
> This works for AMD because they have two copies of this translation,
> in two different formats, one in the RMP which is in trusted memory
> and one in the IO page table which is not trusted. Yes you can't use
> the RMP to do an IOVA lookup, but it does encode exactly the same
> information.

It is exactly the same because today VFIO does 1:1 IOVA->guest mapping 
on x86 (and some/most other architectures) but it is not for when guests 
get hardware-assisted vIOMMU support. Thanks,

> Both must agree on the IOVA to physical mapping otherwise the HW
> rejects it. Meaning the IOMMU configuration must perfectly match the
> RMP configuration.

-- 
Alexey


