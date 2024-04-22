Return-Path: <kvm+bounces-15498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A35138ACD5C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3120D1F212EE
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E90514F9E4;
	Mon, 22 Apr 2024 12:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OUSrd6wK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556314EC7D
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713790245; cv=fail; b=rBh+Fbbs/J2k/fPyW5XaimiuDNrVbwPtohZkFSfpcqYPfeq0ua+OtA3qci+c0wzMrMQ/n1ZJKOSvYilZxO7abNBZi/PIO7HcJlXGZAODTfXvQZE8Qlf6IK4chjsDjOyFZea4R2x9OcSWD3EmFO02oOg7j0I8JFfnsHH3oumVCrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713790245; c=relaxed/simple;
	bh=3G+16H4QBizjnqPNxcgmqeuvwwhJFsHtQqv7qKP+i00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kaCcHJwTYGtN48j2iwFuZ3qAGAVNfyh95QFVH/cnaDcwFZFMIcWSjEpDcKGpYWWUdBlTsXe+fAoEeHSFnsGb23Iko/97R5ngNYGd66GhjRYFn5g+BZ1HzOrWs3vaSB3YjA6YQsEzTxHZdu+E5jRWns6ExkwUnWOP4U+Cbr+NO1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OUSrd6wK; arc=fail smtp.client-ip=40.107.95.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwajuL9atc8LmHkOepTos08nmHMQakKVDc2ox9pcLEvxsczJdMqjguWKXE8myJaaxk3Yh4izoMGSqZDA5VrQuf8mExKVBHJbuekdXnrvcvwZnAc4MIgw3kEmdiiIBxWlxyWkIqzw4a+98ZoqrP3UOTTVY9L7188Sqhl9TxruA89u+k6Q0/LR2/PrFpqAmIHuQGD/wKij2Zx0LVgwL9eCrcJx8b5Hl7uSicZbOfkjqp9N0hXORnSIUSd+heRE/fgW4kWefiV9Y09vbykeD8GOmT1KS8ODh9Iv/uqRPe6FqHw7MYjbInQfXdP/vz2NmKzcYG+tuOKX+bw8i5EUbAi2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ww/SedrseNB2K+Dumlt8VK+LeekRZAo95Y6s48xKtA=;
 b=lqim+Ua6OPRULxsrNAp1GxUKW/O9sJB/Nqnxa2zuX8SCuSyEQhbraKVKIEWeJZEAb31BVucW5qfdLssUIEa47T8xSPJQgbEsGAmGrl3Eq4n7leKoVRc+Om30etVPTyVPuZRnPOFh5UCZIhY+9tMOl1iseio34BI8AV2Hwdt+T0cG9EALW5CG1WHS9lkY7G6sNU7K4N7akliffMVh0q7AG7yn642iMHCrudy0PB3a8qiLgwSk2/uJ7lMA7/EuLRuPJhOdwsK4E6CXS1GCEzq5vOogqHHh/4kcBPlzQrk7pZ6i8n7u9/IKuds4bZqA+/Zm9DKTE6ceA1eRUcv/2dEclA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ww/SedrseNB2K+Dumlt8VK+LeekRZAo95Y6s48xKtA=;
 b=OUSrd6wKiXHqYyfgXO0lAxDpOK8Cdor/TJS7jsmfppNK+98BBn2/sn47lY63lDXxS8lDOVVBbW3uiYiAhRJ2iT5nJWwDJU2UA0nbkEY+bhgpsv0mN7TzBgCcnrMHuFaJp5UFL/J4wqFY+/8OXO7NA0TkjsbpvI5bRzleI0ZHTiXrgqS7GTJkIC+o68v/WaoqGq6FzU91L8GGWKYNILC3S+Y5UUusTFP075fzBonZhR5pegeuSOgdvVUgR+KjVGSh4rfgKPkncDQ8nJuRYmTGx6qzKOviqKd/JRJBFVOCai+Cl/kTpi1+hPPUudv2BTOaCBPjCijP4W5oLST4HMA/yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 12:50:40 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 12:50:40 +0000
Date: Mon, 22 Apr 2024 09:50:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Cornelia Huck <cohuck@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
	Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 16/19] iommufd: Add kernel support for testing iommufd
Message-ID: <20240422125039.GC45353@nvidia.com>
References: <16-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <6860aa59-3a8b-74ca-3c33-2f3ec936075@linux-m68k.org>
 <20240422115435.GB45353@nvidia.com>
 <CAMuHMdXqH1rGWz9d-t=XpWCF5jqDNhao4mJBPaUhBS8Ab_OirA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXqH1rGWz9d-t=XpWCF5jqDNhao4mJBPaUhBS8Ab_OirA@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0393.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW3PR12MB4409:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b889e8-2d6d-4803-4d9c-08dc62cad0ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTBsaDlmQjRGOFFyOVk5Y2hJNlZ0ZjJ3d1hzc1ZUUm9BQ0RibUN4d2xZSGEz?=
 =?utf-8?B?UW01L21Ob3VhMXRKTkNBNW8vZm9WbnNvTVdPbXNGMWVVRm0zRlY1TjhOQ0lw?=
 =?utf-8?B?MkozUjI5WmFIVHhRczF4WlBlZGlZWkNFLzg0d08zRExkek1aUExJdzZWOU1q?=
 =?utf-8?B?TUFXKzBHanJJMm1kWTF3YSsxVnRiZkRobTA4R0FVbWJkVlpEeUZsWXVGSkdM?=
 =?utf-8?B?a2lVRTNDMXc2UkFiUnlnVTBHME1PRGN4cS9RdHFIN1BNalNEL1JOUWRIaFN6?=
 =?utf-8?B?ZXRYb2RyVURUUWRnOFRoZ2hLbm5TL2FMNFhXMHVmclhlT3dyU3JudURkZXFY?=
 =?utf-8?B?S083RGVTckhyQ0Z3VXhVQjJwd1FReTErUEplU0lLaENsZ1NyWGs4MDRlWlVu?=
 =?utf-8?B?dTR0ZUd6UG1sR28xbzZxRGozNDZ4VTlWQkFmSlpraVBKQnlyVmkwVXZFVmMx?=
 =?utf-8?B?WG13N1JGWVBnd2RUR3lWWW1vRnNMWUhCK3FoUEd3bFZab2JsSk11ZWVNUVhy?=
 =?utf-8?B?TU0xRmxjMW1xc3k2QkV1M2hLZzBlRHc0VkpwSkNlSHUyOFlydVFwNXp2bXNI?=
 =?utf-8?B?TEk4YmRaTDVTVE81d2JxMkpZRHBhMmNHaXNKeGtOV3FLcGxpNUZrR2YwTlB5?=
 =?utf-8?B?a1UyTWIyNmlBcGNiNmQzTVJZckVJNVdRL0h0NHlUZ0tDcjNOb3U2TXdMV1hh?=
 =?utf-8?B?akw3QzNWNWgrVFVocXJjNVpIL2h6TVNxNmdaWjc2Wi9WMGFINHRlaGc1T0tT?=
 =?utf-8?B?am5Yc3RiTE9kVWFla2ZpMVMxM3JRQURlOUxZdmdFYjlxY25tbm92RXhydGdn?=
 =?utf-8?B?RGdLbFAwMC9YN2FWZkRDaGNtY3gwVVBaNFBqQnZBWWU3VDVTWk5STGIrSWE5?=
 =?utf-8?B?TGFRR2VHbUh1ajBNcDJEVUdlb2hOTnROdFpMU0VoZHN2WmhhWjd3UGlsS2VP?=
 =?utf-8?B?bUxZcDd1b1VkaVd5ODByWXpWYVFnR1RiRVA0M3VYVWEyU0hIWllOY1RubUtr?=
 =?utf-8?B?azFhZFpDb3pjSzRTOFUxSFpLenFHY3VDZlliU29IQUVPay9kb0NHdFdOU21m?=
 =?utf-8?B?Tmppd0x3K3huSXBYbjNHeHNDN0h1OWp6M3RaSDNjT0twM25PdVFIdkd6Vnl6?=
 =?utf-8?B?T2ovWGtQNW5BQjRTOFc0ZW1YQU9xNUFVSGRaNUFmK3Z6azN4SmpUc05mN2ho?=
 =?utf-8?B?NkRRN3RJQUFwdEhKUmF0cnhQTnJkRXdJSUI3QkZ3ZEZVcFdtMndiNDZIczY2?=
 =?utf-8?B?Y0h5eHExTFlENGVEOW95dS9pRDlkdTNxZjhwT3c3azhxMUp3M0J3U1FxdHhM?=
 =?utf-8?B?cUxieVhsa2JkbEtJbmtWQS9aQmJlNW1PdlRMWi8weCtxRitUdDRCbWFuN3Q1?=
 =?utf-8?B?NXE4dTYrdjR0cEVIcnhtNG5BZGh3N2RvVW4vWEt6UXBHN2pYczBIc1FDQTJh?=
 =?utf-8?B?Q3VtTllNS0trZENIUW45RXcvSkgyU0p0d0lZdDVHZFgxMjR1bFBIMktSY0d4?=
 =?utf-8?B?QUZjQTdHa1lWTFJuVkc2RGpmQm40aWdMTW5lZlFCMFZVMUVMTUZxOXhFTW91?=
 =?utf-8?B?Mm5vdFhSbG0yNG9uYmRpTEJiUHplK0g4MG1ST1F0NXFmY3lUNkdPa2UzeTI2?=
 =?utf-8?B?Zk5DOFhxclU0UWZSNlJ0TWdjUjlXWHdZUWhyWkxUTTA1cTRCbmZZTkZ5K0N6?=
 =?utf-8?B?bnlqZlN4RTJYV0U5YlJ4cjJKZGhDZHVmNytIcExMSmVaV0xuYkhoUm13PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHNEYU1HMEtFWUROTmxFUWhwcXdLY1JzMVR0d3R0WnU3Tm12bnVBeXdGK2FN?=
 =?utf-8?B?c1ZlbUVaMUdwaGc4YkFVajhUWWxGMDAzNFZ1a3o5Wm1lRTJ3MVgvVG5lZzIr?=
 =?utf-8?B?bHoxeSt0RlZ1a2FGd3NtTFhkdDYrSkhqUk10YUNsVk84NmptZW4renJ0OXV4?=
 =?utf-8?B?YSt4d3VZZ0V3cUdxWmo2ZnhYNGx4SUovRm1XUHVsVERpQzIyZ2x4ck9nYTg5?=
 =?utf-8?B?YnFhM0sxUDBtOWozd2FEaDhvaUFNSkhTbUV0WXdGT2RJSXhWWkJuZjJJZTRy?=
 =?utf-8?B?K3kwT2Z4U21sZGpBQlNEYS9OMGNqZlFoOXYyTlFkQTdzZWtXN1dVZ3lla3Zl?=
 =?utf-8?B?c0xDWHRXeWhhSUQzWGhyWHE2SnRqVkdsYm5VNGNNSWNZQktxZHdTbnZCYlJD?=
 =?utf-8?B?M0pHckdvNkFyVU1tdGJncFIxUjNOcmVKM3JTdnNManZDR2JzSFl2RUJWQU9t?=
 =?utf-8?B?V3NpdkNJYmUzYkttam1IZVhnRXA3TUFRb1I0aGNIbXk2Znd2djNVbW9XaWRC?=
 =?utf-8?B?VmhFQUFRbUtHN0dnbWROZWN4QzNWYm04Y3FuMlpYNmNKMDdJYkJ0elpkOXNQ?=
 =?utf-8?B?NW8wblF1OXdpNWtiZGhHSlhadGZvMWEwVVEzUUpWL3IrNUg1VmRYYmd5OEg1?=
 =?utf-8?B?MnlPdlZLaGVkT0Y3SW5jY2xiQStjU3l4Mnlad3ZIV284Skhra2ZnRVpaUit0?=
 =?utf-8?B?bEJSOUFjdDFZUHhFNHRuWkxiVFN4VExTMG42akJ1VGpYY0trMkhZK2J4VGtD?=
 =?utf-8?B?UjNjLzRBWVQyMWluUUc5cEpaMEpUOWJRc0x5ZlNSczg1MWtlM1pTRkdXWVFS?=
 =?utf-8?B?S3JhV2svYkc1R3NOS2J1ZmQ4VlpMWXJFSHhJUkVzWW9JYVpXOWFkQ0xBM1lt?=
 =?utf-8?B?NGFucWFZOTI3NjloLyt1SkxhaVp4d2htblZoaThpWStlMm5hVUdoTHNUZUN3?=
 =?utf-8?B?TFZzL1kxK0Z2TXZDWkhZaU5MbG1jbW15eXRBZ3Rmb1BVSGszaVNPYjZ3bUpn?=
 =?utf-8?B?NWNGNWdNRUV4SlprdnJKcmtRRzRRUHVaeXlCYTExNkRiWlI0a1pKbGd6eWI5?=
 =?utf-8?B?bkJoYjF6UUhoalBRa2pBcVRTWVphZjB1UlVVVUlNb1JNZmtzaElTRU16MEFh?=
 =?utf-8?B?aWJJSjhhTFVnNXE0bVQ4c2grcGpqZkFSUU5kZVVxTW5LalhQc0UwTFlIZzBw?=
 =?utf-8?B?bGhSR0lPUnE0N09RRklJcDdYYXp5VFBqNEphMEhaS0w2dDRJQlVCVnB3d3U0?=
 =?utf-8?B?em9peUp6OFQ0NlVaTG94Y2VrdzRaQ3RWSnlGcnFiTk9EaDhlVW1tT0UveG5J?=
 =?utf-8?B?OTRrVTdkRlorQ1VWYkFLUEdpUWRXc3Raekg4SHJCNTJwbHBrSjgvd2ZRdjFM?=
 =?utf-8?B?aURBM1U3eTFwVm4vL29tR1dIVTM0bXBTYnFLNTlONE1Fd1hHRU00Q3crVVdZ?=
 =?utf-8?B?YVN1MW9WZmFDUTRVTUEwcWJqR0M0ZWd6V1BMY3g1TmNlVmMxQk5sdzNaN2lz?=
 =?utf-8?B?MWQrVElQQzhKMkJwZHJXUHhzQ3ZHTG1IbEZrS0JoTHhtMFZjYjVPcnNMY1Fp?=
 =?utf-8?B?Z2NRR0ZNSGpPWVY1RHFzUVhKeXNUV3VLYU1EMnE2bUx3cmI4bVEzdlRDY0xR?=
 =?utf-8?B?akpIek5FUU5Ob0pqWjBiTHlpWk15RDAxOEFGa1FVc1BXempQUE1uYTBZWmdZ?=
 =?utf-8?B?cnlCSHRRR0s4a3dNb2dqZndyN3l6MG1yako1REpZYXpXbEhvZkNwMW5UWFVm?=
 =?utf-8?B?UG5BTUYvTDdFTmtKNTlxVUFrc3l3RnJYd21zeUl0N0ZQSHJidVhla2dvdmRL?=
 =?utf-8?B?K1NqU3RVbWEzeWlYNGNRdmxQdzcvMVp4QUx2ZEFFUVpRUUhGMmNlTDhSdHZa?=
 =?utf-8?B?dkhzd3laZ2pSOXlTa0tSVlBYcU9VODBoQU9FRDhtdGlhcXR3Mm9TamcwRjBi?=
 =?utf-8?B?ZmZ3cWZ2RytvWml1L1RTSXl1dUhIM3hyODFlMFpXdDd5SW1DUTIxOUJScjQ3?=
 =?utf-8?B?cE9GTHFrQm50cGlkYVVGc2REMk1KemtML3hSN0tRTW1sZmZvOWVNb2FaVWMv?=
 =?utf-8?B?MnBvczIwSkRXSGZuWmVUb25EdHRGREtGRTN2ZnNEdUZQQ24vd3FseFpMVllh?=
 =?utf-8?Q?P5+g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b889e8-2d6d-4803-4d9c-08dc62cad0ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 12:50:40.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3sqTdXI6RoybwI5FZoKFDv1dpy3G9ZF3RfRBHdBnVtYkgT+0u5Ai33QCV6yYzFP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4409

On Mon, Apr 22, 2024 at 02:48:56PM +0200, Geert Uytterhoeven wrote:
> On Mon, Apr 22, 2024 at 1:54 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > On Mon, Apr 22, 2024 at 09:27:18AM +0200, Geert Uytterhoeven wrote:
> > > > +if IOMMUFD
> > > > +config IOMMUFD_TEST
> > > > +   bool "IOMMU Userspace API Test support"
> > > > +   depends on DEBUG_KERNEL
> > > > +   depends on FAULT_INJECTION
> > > > +   depends on RUNTIME_TESTING_MENU
> > > > +   default n
> > > > +   help
> > > > +     This is dangerous, do not enable unless running
> > > > +     tools/testing/selftests/iommu
> > > > +endif
> > >
> > > How dangerous is this?
> > > I.e. is it now unsafe to run an allyesconfig or allmodconfig kernel?
> >
> > Depends what you mean by unsafe? This is less unsafe than /dev/mem,
> > for instance.. It does nothing unless poked by userspace.
> 
> OK, so the test itself does not cause a crash, or data corruption?

No, it just provides a bunch of ioctls that could be abused by
userspace to do some slightly bad stuff.

Jason

