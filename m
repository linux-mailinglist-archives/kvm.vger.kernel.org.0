Return-Path: <kvm+bounces-24582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 426E29580B0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98B80B22C8C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 08:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0F218A6A9;
	Tue, 20 Aug 2024 08:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNx6JTDI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7C189B83
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 08:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724141890; cv=fail; b=vA6xhvATU+S7oc+NF9+J213RS6MuLgt0OWkJVjwcjGrTwfN9NpqWS4Az06HZd/Jai4LZfHP3NWLEzol2UWlGt2Ee88Q/wge0EH9VRWSvl+WTDf1SpwutTCK2UJfvcVSOfTY1zeDTeC0mQwpBI9fK/HfdYLUI7J9K7qQ2XJNxEDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724141890; c=relaxed/simple;
	bh=8rhyyuEDIGZE6IvBuXtCW5JWWOd1wVq5Gn78tUGhjaw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rA16TnNdBlC0qCVitn7A/yyoZ69uL5a7qHw1AB8kVD2JgT8ehWgt1tlYH24AGUBmLlNy7zYr2WVxUCDmhngGn8+N23zGOx6F0LrDE9Hmh5bW9LXy1JjBlReKs6Mt2ZccInKL+E3EXP3Hp/RBv7wR2wC5HVM/nf6klpsRGhCSCAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNx6JTDI; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724141889; x=1755677889;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8rhyyuEDIGZE6IvBuXtCW5JWWOd1wVq5Gn78tUGhjaw=;
  b=JNx6JTDI8LwpSL5d9LIT/xIccjQHsm5ZN2gsxCEMUrhrlB53RvAuHKLS
   hhSmMt8xFDeIA1lqj71GvKqhX4U0Jn4FDuee3/i54ftxjQQkp2YK9Rl7a
   k3XP4XCEuqqteXYpih3AxOcnoz3IpWLcJI0PJtbG8DdoE4QO1WXB/KEXI
   +ovUEzZsJKChj+SplAPXTALKjckU3g0YO8oCCe6h9XLD2me3eyybZrATT
   i34Jb9kVDKyvZr+RYoM/qU5uWcShluz9S75kd6+4oX0LuREb5i+uIfyRx
   OZztzq2dmYvJjOhW6Mtq/7WwW3EcpleszB96sHXFCA526XgSdNOBH50L2
   Q==;
X-CSE-ConnectionGUID: 4WBwxFITRdaEeS6M1+szfg==
X-CSE-MsgGUID: TzRM1H2bQHiGRCBi877l6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="33846611"
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="33846611"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 01:18:08 -0700
X-CSE-ConnectionGUID: o50S7HdwR6OYnZQga8CbEw==
X-CSE-MsgGUID: AvGk6t62TI2A5nhU/1a8gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="61208899"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 01:18:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 01:18:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 01:18:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 01:18:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U45Po1mpA++1GIp0EjfRRv9vDqKWm5gYuC14RAyOGHZCXLyGufBN5faZoAo5EZt570Rud17prxTRRPLqnAzgCTIxOXC6lNLaRv/tmkFWnnn90iTMtS//RZbHDPm/zQFKZsAXDzxQRAlJP2GH2ksCtShVYelSgQcWdCh5PCNQPNmISguxmQxFq2Ju206McR11aa2AIXoVKyn/TUlCkauRKVcwZ+U9JT1EbB+Ag8K4Gw8la/KHO2VklIxaee7ADfKLXT5TewvOTGdibfjZtgvHjVPwJ2pEPe/nmLRBvE/2GCLVvb4ckEzM/1DnCPXIJezCNV321iVfBqUiKpvMmiQFTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKlj02ZTJtwqXFTqdMzYwp3sU6nxJgCQlHKL6AD2Mx8=;
 b=rfxwXmQK5eiVbIzoK0WKuYWom1tWlenPK9lEvQ7xPzafut10Kx6oXoCCun2It5fVE+ThCep9LCIjhDVKxWydCHTlKKKGkyVdHYF/I+MEHrpiBAD0EiyBhQPROrDmTuz9aEq5jtRM5A/rzzAB+WVIPUeek96I250epweGfDEfjoEZPQWnQLwXs/qiMuDM2RlDx1P4SsMgAKuTAX7LZIOp/o5rV94+oWEMTi0gFdpZisObEwxXvoVnFaCMnoUl28OVoO5/B6ERJo+xWD+0GFtD/tlvoBVlSPp77D+9WR7BdSxfOdX1yoO3WMgymLe1bQB1wmT3vRUI5liBBa1B0k/SNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY5PR11MB6138.namprd11.prod.outlook.com (2603:10b6:930:2a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 08:18:05 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 08:18:04 +0000
Message-ID: <35cd0f5d-fe21-41ef-926c-c53baee26b6d@intel.com>
Date: Tue, 20 Aug 2024 16:22:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page table
 format
To: Jason Gunthorpe <jgg@nvidia.com>, "Zhang, Tina" <tina.zhang@intel.com>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>, "Christoph
 Hellwig" <hch@lst.de>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Joao
 Martins" <joao.m.martins@oracle.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Peter Xu
	<peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson
	<seanjc@google.com>
References: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <16-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <MW5PR11MB588168AE58B215896793E83C898C2@MW5PR11MB5881.namprd11.prod.outlook.com>
 <20240819155310.GB3094258@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240819155310.GB3094258@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY5PR11MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 8beaaace-de21-4502-231e-08dcc0f09d5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cGRBbmhuaFJKMDlpamU3Z1ZwVVdmZ3V2eEh0MFlRN3RtVGVDOThzL2FxNTk1?=
 =?utf-8?B?eXNWUWVuMktxYlU3dlZCbWVuRFB5cU02T3JPL2pzdWpMTjFKNVFvK3ZJR1VE?=
 =?utf-8?B?aEFjS0g1akFFOTVxQUd5bmpONkNnaWYwSWtlbGVnRy9jM2ZWV20xa1p1Mm1t?=
 =?utf-8?B?dm5TSDRoMlZ5MXkvRUlPQ2hnL0IxQzF1ZnZ3MDBqOEgwVkFRRThETFZweVZ0?=
 =?utf-8?B?emFkVkVxa2IzbDVrRUkvTW15enZ1SXV3V1VLdEx6cDRPeXh0cUg1eG91WVYx?=
 =?utf-8?B?UnAvMk1BenpiYm5CUFpkQ1FLZ2hnRU9BOVlGdmR0ZXJVMGhUcWM2S2F5Rm9k?=
 =?utf-8?B?bVhuSnI1bEFtU1g3SndDVDdXNWt3S3lyRWtVdEczRklOdzdLR3BwdVp0QlY4?=
 =?utf-8?B?MXBHbFVMUXBqb3loR0FqbUFUMGZ3T29KbUR3NjY0c01KemNPQlFiMVBZZ1hp?=
 =?utf-8?B?cDltSzhTa1ArNXRrTFlDbUhoeDNWTTVJcEhOcmI5WWE2OFZrSStISWgxY2tF?=
 =?utf-8?B?VHh5aXRaditBeUxWN1l6RGV6bkdMVFA3NjRWSnV5N3NHWVRBd2xscnBRNjlq?=
 =?utf-8?B?WVZ3VW8yNjQ1bVJXSmtMYWFHa1NWTVZsYWt0L3doYWJqOE5EQTJydS9KTnNk?=
 =?utf-8?B?Tkt5TU9BbGg5c0daL2s0RTdOdWNZT0FlUjlKZFNLL2RWQ1JwTTFHeUZLaWlm?=
 =?utf-8?B?NEVyZGlXWCtrVUwyY1N0OTM0VkNZZGZQNnJrMUxRaDhocXA2MVFJb1V0STNY?=
 =?utf-8?B?ZkFIbzRienZUWHUvc3MwUndQdDZqaE01QjdvVGYxanphRDJnSy9pM1VSRk9m?=
 =?utf-8?B?Q0hQUUFVTDVCU013S0RXR0ttYWROT0VsUSs2aVpFdEt2TmtTTzI3Tk1aK2FS?=
 =?utf-8?B?U2Z1Szcwc1JUNDA4YXpBc3F0ZlNSd01YZ2dCV3hBN1lvTzF0NnRaeWlucFhC?=
 =?utf-8?B?Ti9pWTlPTFh1VEtGeFFYSE9KQkxKejVzbjlsNnhJa1UyeWw3K1I0YkFaNEdB?=
 =?utf-8?B?RjBsV1cxWWpjYXljaUE2ZVQ5OFdqY3VTeVRsVS9XUTRrK1FHdkNPVVFmdDRC?=
 =?utf-8?B?eHNZVk5xSmR2RndUTjFVK0tiZFNSekp0ZFl0ZnNqNVBwSFZaSEhrMS95YURD?=
 =?utf-8?B?QURiNUIvN09tUURaSkNaTWVlMlYrZVFQYjBVY1RsNWhOVXEwYmtqMDhISTZH?=
 =?utf-8?B?V0lPckkxRUdBMEo2bmxkcGp1MnlSbGNPMUx4R1EwZUtGbngxc0pHK0h5RTk1?=
 =?utf-8?B?VjVZM1JqemZqMlAzSy9nY0V4TC9UVUFScEIzWEp5N29hVE9OT3haK0tEZEVE?=
 =?utf-8?B?WHNmTC9YZ21uZmczVWFBdHd6eW1NeGZqb2pLQzd1bHliSU5OTUd2NmxBMTBj?=
 =?utf-8?B?Y0pwb1ozQXNDbFIva1RmRWE2akRuM3N3bTQ0cldWeXNvVkt4T2xCSlgzTXhM?=
 =?utf-8?B?VDRDVExPbjE5dXdFUld3K1dyK2dnZk5uQ29lcDh3ZzhDZ1NCbldjbU9HZjB6?=
 =?utf-8?B?ekNTWDZLOFl2TEM0Q3FGQmpxVkhGR0dwZE1lWXI5Rk5FSnRUZng0aDMwQ29i?=
 =?utf-8?B?cFlCbWJuOTVCRk10cmVkTXZoL0RJSEFZT010cnZnY3pMRUhSVUlaWDBZdTZ5?=
 =?utf-8?B?RmpFZkwyemZKQUhlTkZSc1ZNdmN4clNPQUtBeFJTL3haWllmZ3JxUXNUNWVY?=
 =?utf-8?B?cUhOMFFVMURpaGdjd0N2THBCYldBRW1qQnNHaXkyNE92ME9VTXBwaCtuUjc0?=
 =?utf-8?B?U3lCVEFrVy9TQnkrYVRhdHBDc1pNcXVnRng1YWZJd3pEcGdBdXNYWEpJemF1?=
 =?utf-8?B?WFAzZWcyaGVIUEJHdzN1UT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RURRd1Vhdkg2Q2x3bXViaVJRRU5xdzZWMHh6VklWTmhvMlowYmo0cWQ1Yklr?=
 =?utf-8?B?eTBxUGw2VnRqUEJVTnE4TVMyNkpza1B2NUN1SHhINGxaYi8xc244QVBwQ0Z1?=
 =?utf-8?B?REpHZlJBRXVndDdncDJKREd5WFk2NjFZdTl4VTgzOFZTVWZkZCtnRG9JTWxm?=
 =?utf-8?B?Y2Z5VGM4aWhRN2FjR0VtZkJBZ2pUZ2JuVGEzNkpWSGd1WWsvRTFzWHJzbVVn?=
 =?utf-8?B?MWlxRkExVGduQ3FoOFM1amtyc1JlNlJYYkxOSHFCcTZMWHQwQmVPdHJVQWJW?=
 =?utf-8?B?TjRVUTJJZnJFOXorR0FmTzBxdU9qVnVhcWFGdmt4QVljUHBrZDM0MEVNenFR?=
 =?utf-8?B?L0VKVG1YeXV5OVh0aWgrNTlsN0ZUY0JRMTgvVXpNbGVFcHVVcWxNWWpLWnRy?=
 =?utf-8?B?MCs5WXVzdGZIZHhOSDFMbkZVWjRTeUR1WTlucW13RkRLUjBvRnZvdFl4WkdL?=
 =?utf-8?B?WnM3OUdhRk1ldTl0bmE4LzBLd3dEYXFMQmRHQTB2K0ZQaWRGaVhXclcvTHhi?=
 =?utf-8?B?SnhNdXVpcHRoM2FOSU8yK0Y1L3Q5NytGWWU1WFJMdzc5NFZ3dlJPQm1wTGVL?=
 =?utf-8?B?cEFEU0krbjd6TnV2cUhhNm90WjZRVHFPbXd0MXkyM2Z0YjlTeGlHYlBiUHRq?=
 =?utf-8?B?UFFRKzl2ZzMvMmIzMGFMamgyVjRjS1BXYy93eHcrYkhaODl3S0NEcUNrZk5F?=
 =?utf-8?B?QlFPcHpTVjFPbUxNYXhOK3IxYTc0SHc1OUs2WnYxN2Q0b294NUo2ZDlyRmRU?=
 =?utf-8?B?aWRUUmZsV3lGeUNWb1pVWHhvVExIRVBFeUdVWGRQTS9iWHQ4bjc4cXBQczg2?=
 =?utf-8?B?TDF1Z0dLd3BLS3lmazRQenR1RWUyTjB3N25nTkZtRFdTTWk0NTdEekVVZGp6?=
 =?utf-8?B?RndTTWpJUjdpaG9zZTYzOXduV2gzSUZGSlYvUkFBcTVYYlAwbHJubEQxc2Y3?=
 =?utf-8?B?UHJvdEFqSytZOGIvT2U4eDRIUE5hQ3QrNy9HQUJ3UjdoY0tlVEorSXIrSDVm?=
 =?utf-8?B?cjBScThFOFBhUkJFWWVRcHlUR252d2JTOFlZb25mVGU1SFJuVU5YZTIyRU1l?=
 =?utf-8?B?UTlsaG9kNFhFekpkYlo4NUtONGdJaFAvTHR2R1k2cEgzeUNCaUhXMWRDWEhI?=
 =?utf-8?B?M2lETEh5b1IxL2t6UXR0OGd4WmZFVVBaMjNHYmtJa0tYVWpndVlObHZwNjlw?=
 =?utf-8?B?WUZpbHRpVVczaXFEdForbldwYjdkeU5hUTl3N29QcFdSV2ZscndpZ3IxL3dp?=
 =?utf-8?B?WGIyWXFqc1RYNnRQSFdYUm5RTHdjU01ldjEzUWErODNURE02NytsTkhsMWRP?=
 =?utf-8?B?TGg0T2UrS3Erc25DSEZqRFJlU2hzUFZXemJScG1UaTYvKy9RQWc5enEyTHh4?=
 =?utf-8?B?UXdzQjVDZ0lKbzBPSjhtd3ppOWhMQm4zeXB5aStlNTBjREtQU0lKUk81Ylhx?=
 =?utf-8?B?Y05zS3VOSTNXNDlnMUdudFFPQlZmRE1EVXJRSDdiK3NBV2FYMVJGT09KeUVs?=
 =?utf-8?B?QXY3a3FrWktabkE5aFdZYmNoK3g3WHE5Q2FRRStmMVN0V2l0eU9ZeUxqWmlW?=
 =?utf-8?B?QTB3cXllT2J3NmdXNit3RXlrSWdaaVFOT3E0L1VYMHVPRmRvcXpaVHFVYmlE?=
 =?utf-8?B?VlRpek4yM1YvcjNTbENvYzZzSXg5eXhCV1pvK1dxL1BHdFBaazdLclQ2Z3h1?=
 =?utf-8?B?a093eExyd2pCbHlXaTVXejRXZXRLbWJlRmhUd1ppeTVsOWkyY3lJclBKN09O?=
 =?utf-8?B?OGFWdFpFZTNadDFLazF6ZmUvODNaS3NiUUtoMWROeS81RzJiTHZ4NFlnTEor?=
 =?utf-8?B?Rmg0aXZjTlp6akg1TlF1UVdZK3NCeE1WQmhWMmk0czdteHR0em5xbXFtQTIz?=
 =?utf-8?B?a2VrVUpsdXd6bm5waFFpVy9OSXFwenBhb091MXBRS20xZ25nbndYNzBvYXA5?=
 =?utf-8?B?aEsrQlNjYkxYZHgzaEtIMHFmaUhIK3lla3pyZUI0Nm95YTVwQytyRVh2WXJy?=
 =?utf-8?B?V3VEdHl0TkhpbU8xUk1sQzZIbGdhdWIzamFaazlqZDBUWVQvbnh1NGNRMVd6?=
 =?utf-8?B?ZGFkR25yL3JqRVUrV1NXVWxwMDVvcE9wMlU2QVhTQlM0RC9XUTlDWnZMN0U2?=
 =?utf-8?Q?kZ/UIT39QxFPwFPxnoT5LgWqk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8beaaace-de21-4502-231e-08dcc0f09d5b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 08:18:04.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lxbq/4vuE4UGuKMi0LcMLwsIhYHKcrOHVYEnRqInNgVsF7Y+IajB1zCmighFQYZTAfPi9ZDzkXhRMzjWSE3AjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6138
X-OriginatorOrg: intel.com

On 2024/8/19 23:53, Jason Gunthorpe wrote:
> On Mon, Aug 19, 2024 at 02:51:11AM +0000, Zhang, Tina wrote:
> 
>>> +/* Shared descriptor bits */
>>> +enum {
>>> +	VTDSS_FMT_R = BIT(0),
>>> +	VTDSS_FMT_W = BIT(1),
>>> +	VTDSS_FMT_X = BIT(2),
>>
>> VT-d Spec doesn't have this BIT(2) defined.
> 
> It does:
> 
>   Figure 9-8. Format for Second-Stage Paging Entries
> 
>   Bit 2 = X^1
> 
>   1. X field is ignored by hardware if Execute Request Support (ERS) is
>   reported as Clear in the Extended Capability Register or if SSEE=0 in
>   the scalable-mode PASID-table entry referencing the second-stage
>   paging entries.

it was deprecated. :( Refer to the latest spec (after 4.1). And the ERS
bit is going to be deprecated as well.

11.4.3 Extended Capability Register

"This field is planned for deprecation. Implementations must
report this field as Clear to indicate that the remapping unit does
not support requests-with-PASID that have a value of 1 in the
Execute-Requested (ER) field."

-- 
Regards,
Yi Liu

