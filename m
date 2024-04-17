Return-Path: <kvm+bounces-14924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 306898A7B1B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 05:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9515A1F23B90
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 03:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4606F3BBFB;
	Wed, 17 Apr 2024 03:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRUjS+4w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC305680
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713325491; cv=fail; b=V+jKKiATE6eRXWvZj7biCRUSdi/7FC+Tv8Tom4JuVHFe9318l0tJXOkjmT8aERmp4efEwC5eE/p11xEZHFpHA/au5FwkRk+YO4EZ/PqN6/99BLKwwwIU1T0XWp09gcLu6rUvANtgfkva5GZBSonjmCQLQGljsqE7eSd/U2PAIVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713325491; c=relaxed/simple;
	bh=5mf/1PkvdUWxcQgs1KJ0ev6A2CCzNzLlj7I/+gTTfV0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bG41SBs+rpmUYn3o/b+VsziZX18PsLAfPCawRarr9jLXO9gHazx3tntxP6PElnSaT1sCLEc/hEDZUJtmbgGxdfDv8lSaulszJeoR9gwKG+bT0rPX3Oz/zlKlFfSo7gIzUNfTCDZqIuolgSUnnOWAWxVAwbqUNSWyCBVj1M+kbAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRUjS+4w; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713325490; x=1744861490;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5mf/1PkvdUWxcQgs1KJ0ev6A2CCzNzLlj7I/+gTTfV0=;
  b=DRUjS+4wwgStERy2CVh9QF3JP3LPSN+zBfHFCNNx6oBZdlSB1dN1aDqZ
   UJCE4KCSOIJnwVL4UyLabqIN+mYmip7yoG6guhiKCe+8x4jZosmDW5KoD
   jCMDm/398f7T/LTEG7RKH7LbYQkq+xIbYu/GBLpj/VckJN8osYdpOSQ8T
   a0ny8GymvHhIKlgFaR5Px+IYAmfjJXLivngbTF1H9aSNiRdcz/TbldLA+
   rioKf1EIpYHTCFI44bd23A9/CI3OPKoEEgi51uenY8TRODB9eN2QJPyCT
   /Gi1IIV5wRNNwKmL/cHhfis5ZjMdEwzH2LetpaP+kSIgU3hgCXihc/M5M
   w==;
X-CSE-ConnectionGUID: d51IYoCkScyML18ICO5srg==
X-CSE-MsgGUID: s7kYOeyuSQKIkk2mvwxUIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8660541"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8660541"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 20:44:49 -0700
X-CSE-ConnectionGUID: 6ei20DU0R7WieUrR33LolA==
X-CSE-MsgGUID: o9jUbrR/RA+ejUxUlZaooA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22568765"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 20:44:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 20:44:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 20:44:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 20:44:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 20:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnuRttZvLXUV3OxMFGmGC8pQNIykKualfbN+gRdhWmvehOV4ngaySq4CraGCG5RbCMKxS9biht+9GZxvzk6Pa1Xm0/9LkfcvBWl3XiH11EvAa+g9lhv455oxOYgYfAubixqKhXd8TE9pqaYsHn6/qCiH/ZgNDIXS17LiR+QB4HqY7am0tUT56Fph4GMLsktdnUbUm6EnJuxqS55WNyHwQxrFC7EFSuqIQDPars+fzqxucn9LZHTK0NbdbmwmvAmxL9dDhPYJEmW2bh0Vp6/3eIKYWLJ0E2Kje6eG6Kbhpb0+/JzgY9+rCFQ0RJ296mPhgBG9OX1QtTTh1xsPvQDmQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BICXAmQzGrxYsGO8eVRqpnlOaGv2mLnKJzYTtvDSb3o=;
 b=Hkl37J44DO6qpYcbTHvFzcKs+iZ4kQECeXojKmr4UXSo6B5/UqifUqHIUig0E3KjvIgAxESaBiIRNA4eBkWy2i8ZWKnko4M2V+auR5CODD1DThpYjxlNnkHupgWb+x4LopucYBaGUBPaSPlJnnEsJAUQ7O/Ffw2YXCCqxpLpapciAbfRTROqN75xn0uamvck3NL1qsfvro+1HR+smVHNc4pCKuHWPSnaWCFDQ20sFD0SnYQ5iVhBSab1nVh/N3jz4Zl8Q2v3JIVuuLGPEmvfys2NC/NauE3BCIdtlnW0ILQ0viFTSXJneDjnvLf4eag8XlaYExBYBjQeH1AUO15rNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB4798.namprd11.prod.outlook.com (2603:10b6:a03:2d5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 17 Apr
 2024 03:44:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Wed, 17 Apr 2024
 03:44:46 +0000
Message-ID: <1619eb87-3879-42c2-a2f0-6351dd504410@intel.com>
Date: Wed, 17 Apr 2024 11:48:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
 <ed73dfc1-a6a2-4a19-b716-7c1f245db75b@linux.intel.com>
 <373e52b4-e663-4b2d-9a6b-feaf3a93892b@intel.com>
 <a0543205-18a8-4878-8b24-3d87bee24645@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <a0543205-18a8-4878-8b24-3d87bee24645@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB4798:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a7ddf5-3638-4f5a-2927-08dc5e90b9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RowpWKU52L353Lp3axUpwGG7+IVDNq9F4nY5GauuXiG+25ObrFxyDhaKtUbumbRoikYGbO+RPD0EBR5AVEXt/kazrIG37fWR5SAeA+O/VR8w0UKLdNsk48mKV9xHtZeDETkxEb4qb8ebKpNBMhCGajWqN5UxEADK+QYdEDTOnUaIed1hf5s1HR2nTztX7U10ia/RlFJOEodGse5XJOReRUc7DyNFQeglIOsovjlxB2sg1OfxHBD6YzEpZn6acQq3Q6nYY643ZsN5eH/+CxZukrfv2QObpof/EWgK/UVVUp1Igz8nAczitVMWjhTXJMsuDpdITdZP3KQNtUXa+1BCxDFslHz7+qhSODp58bLMB8xilRoM9w9e00pNWvjzzAQkb7V2ix41IEU7OCBzXL5XcBuFlgBvo0NgdDxspBEb8mydpSHqRhpTGPJqnVSKI9JuQmNJfIg2B0w0Y4kQaqMARfiKZ8WWPqNFRGBgBafI+ZFQztmLZi6SNQRPqSrxzYsap8KX+Qf+llbDhN1cD/KvDYtfgSGOs1To4orC638wBj+V2s293SiHy6B3u3zTnI/991aSE3srW8y58d45OpvlYTPUCEjOSP8eEgrB06f22mym8BihkJJoHmQOtfdWil/3c0BUkvqoZehd6FcoP7S5RUWHqYxmaMeSnBUDD2OlIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDk4NFVRU2dmdjdNN3MxOXBRWDNYUGF1anEyb2d0WkF6aG9wTlIva1hLcjd4?=
 =?utf-8?B?dUJsc2ExTFZlRTY5ajBVRmdpSlpDUGtwV210NGV6VWtqVVZCTHJBQXRoZE56?=
 =?utf-8?B?ZDdGbmtreEVkcHFUZkc4Z2pxc1J0MzY2YWh6RVdrNmU3ZUdBN1RuQ3lVdTZz?=
 =?utf-8?B?S3gvMkdyRWdqMkhaRFpUU00weVRxTWV2YXA5MU5nMkN3cjEwbEIyZmtoTWRi?=
 =?utf-8?B?YlFuNnBZWUtpWXZNd29rZndlMCs0YzRaYy9VQmJaMmUxdWFUWGU2aG92Wm9j?=
 =?utf-8?B?ZVJJQXlGNW14aHcvZFl4Q0RxK3V3NTRtS3hOVkQ5QTFJNWU2UkIyMDd5L2Rv?=
 =?utf-8?B?YVBsNWRzeWVMaUtheGJ2L0FtbDVjZi81OSt2MkNKS2FQZ3Zqb2dkaFVRZ0tK?=
 =?utf-8?B?NnRkWjQydEcxaXUxbnpkWVBjSGhTdStLOG1Ma21UeVhKOWVWVVVPWnZwcTB5?=
 =?utf-8?B?c0w3S0RtZVA4YnkrWTZ6UmlRaEhLN29iVWN2Rlpnemx2SyszcmFUaFZ2NGRp?=
 =?utf-8?B?cDdGRE1CTXZLL0o4aFlsWEllQlhBNmJ1VWtvci9zNXB3Z0I2dGtvYzNKL3Fr?=
 =?utf-8?B?VzNKRnRRejkwS0RlMjNKV05rblY4Vzc1TnZ6UUU0QjlYTTJ1T3NRTWljTll1?=
 =?utf-8?B?NS9GQkVRV2N0NE52bjRtMGkzKzlPbHlzYWd5Q3U5VHZFNXRSQTNMUXpNdjhx?=
 =?utf-8?B?a2xvTTVpOGxpZGNjRFlKeFkrKzNxY0RNR2RqZWVqWUNDNzJ3QTJsSkNzdGxj?=
 =?utf-8?B?S0duRzRYNkdSZlJPekZkdmdKQjRZaWNQdDgxMERjQVhXU0NtSmtQMVlPOXhV?=
 =?utf-8?B?cW45aHFqalVHSXc1SEZZN3lJUERNdk1ML2xYS2NEcU9kUThNdFFabXNTcjYw?=
 =?utf-8?B?b3B2eEEyblduRWR4WHhFWG1rNmpCaHVVYmVuT01aSmdZSThnWEZNeUtqaE5w?=
 =?utf-8?B?a2tvTkgwcmRDNWxtUUFNbjQxUWh4ZkN0UVhCMERZclBBenBKWjZsK05KRVJR?=
 =?utf-8?B?c3I3OHlYcnNGdUMzblBwcDNmaTVhM0l1ZDhJY1RDYmdXTFh2VC9lMkpVNmVB?=
 =?utf-8?B?WWw2dEZWOHBhcURkM0ZuWERiK0Y2ZjFpbFVzTFl1Q0Q4RWQyZGxuUzF2dDlP?=
 =?utf-8?B?WXR4dTFlSllDRmI0aHkxaG9jOW0rK0JVQk1pSEhST3pkQXRYM0lQM1k4K1dt?=
 =?utf-8?B?UDlyakRSKzRUK2xuK01xNU9NK05JdVpvRzY1OFpjS1J1ODhNVTFGSnlMM3Z3?=
 =?utf-8?B?NGVCNVE0enI2SHVGWEJnRSsxMCtCeXZaZFFpYWZiV0lodFI4OTE4WHdmOWlH?=
 =?utf-8?B?dXZhbjVRdHNkNlFWSG5MWFhGVWpjL1l3RTFsVkhLL3U0a3dIMktCWVB3WDQ5?=
 =?utf-8?B?OGswd3loMDRLL0lkb0RoNzA1WUVKMXdvb3krWUl4VkVrd1UxVlZuU1h1Qktt?=
 =?utf-8?B?TG1UTXdHVXVlbWplb21FdURjVlBURm9XMk1BMm1kSWtSdS9WOTYwbGdZUTNu?=
 =?utf-8?B?RUc3bFQ4WWhQNGd5NWtyRGU1OTRteE5jWDlTTVQ0dDlXK1lXRmFSYWpqQlhF?=
 =?utf-8?B?RzlKcER0a09IdHcxQU42YUphZGR0czVjdXdGRTRWQURkVFNId09FTzJLM0Ez?=
 =?utf-8?B?VE0vdUs3dDJUZE5oa2xYMXZoQWMwanRIeWMvL0NXYm5tNnpPSVZMektlVXRR?=
 =?utf-8?B?aXlHQzVqdDFoeG1XNUNCeEgyR2NSd3VhM1lQbjdjUHFkaldlVVh5UVowcXNw?=
 =?utf-8?B?RUg1ZUt1amd6elZ1MjI2MklVSUlkcDNjQXRkaHVyeVJzdXBGbjFRa2ptTGxy?=
 =?utf-8?B?NU9VQUkzTGZMb2UxZlNHdGxjWDF1dWhLQlVMMWNvbWRnaGVXam0zbFk3Zmx2?=
 =?utf-8?B?QzFvcDNqV2xrWGtlQ0orNzJkRTBnZGQ0ZlRIUkFDUHpsd2w1b1V5cWFRc2VP?=
 =?utf-8?B?UUM5UGYraGNNNlo0N045Vm4wZVpIczBmNG42eC82cTFIK3kxQ2Fobm9Bd3lC?=
 =?utf-8?B?b2ord3cwVGdaSnk0YzdCTkZ1cll4ZTRuWXE2VkUzM1Jnc3RsMWtIWEN5ZHA0?=
 =?utf-8?B?OXNtaGF0c2oxc2huUW5WcFFDOGNSL0lid3UxWTVGZ3BtSHVqdGFub2dQdEx3?=
 =?utf-8?Q?xXDHyJD7yoiDKyQpE8wV6srPc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a7ddf5-3638-4f5a-2927-08dc5e90b9a4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 03:44:46.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+QTOdy2zqg/MDfjgOycO20bN5pNlXSsM8dGEu1XqNuyOLzOwbWhOjNFSn2ZHVp4+4StnWCYxYXzA85Q4agU3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4798
X-OriginatorOrg: intel.com

On 2024/4/17 10:30, Baolu Lu wrote:
> On 4/16/24 5:21 PM, Yi Liu wrote:
>>
>> n 2024/4/15 14:04, Baolu Lu wrote:
>>> On 4/12/24 4:15 PM, Yi Liu wrote:
>>>> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
>>>> is fine, but no need to go further as nothing to be cleanup and also it
>>>> may hit unknown issue.
>>>
>>> If "... it should be a problem of caller ...", then the check and WARN()
>>> should be added in the caller instead of individual drivers.
>>>
>>>>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>> ---
>>>>   drivers/iommu/intel/iommu.c | 3 ++-
>>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>>>> index df49aed3df5e..fff7dea012a7 100644
>>>> --- a/drivers/iommu/intel/iommu.c
>>>> +++ b/drivers/iommu/intel/iommu.c
>>>> @@ -4614,8 +4614,9 @@ static void intel_iommu_remove_dev_pasid(struct 
>>>> device *dev, ioasid_t pasid,
>>>>               break;
>>>>           }
>>>>       }
>>>> -    WARN_ON_ONCE(!dev_pasid);
>>>>       spin_unlock_irqrestore(&dmar_domain->lock, flags);
>>>> +    if (WARN_ON_ONCE(!dev_pasid))
>>>> +        return;
>>>
>>> The iommu core calls remove_dev_pasid op to tear down the translation on
>>> a pasid and park it in a BLOCKED state. Since this is a must-be-
>>> successful callback, it makes no sense to return before tearing down the
>>> pasid table entry.
>>
>> but if no dev_pasid is found, does it mean there is no pasid table entry
>> to be destroyed? That's why I think it deserves a warn, but no need to
>> continue.
> 
> The pasid table is allocated in the iommu probe path, hence the entry is
> *always* there. Teardown a pasid translation just means zeroing out all
> fields of the entry.

aha, I didn't make it clear. It should be no present pasid entry if no
dev_pasid. Anyhow, I noticed intel_pasid_tear_down_entry() checks present
first before going ahead. So keep going is ok to me now.

>>
>>>
>>>  From the Intel iommu driver's perspective, the pasid devices have
>>> already been tracked in the core, hence the dev_pasid is a duplicate and
>>> will be removed later, so don't use it for other purposes.
>>
>>
>> good to know it. But for the current code, if we continue, it would hit
>> call trace in the end in the intel_iommu_debugfs_remove_dev_pasid().
> 
> The debugfs interface should be designed to be self-contained. That
> means, even if one passes a NULL pointer to
> intel_iommu_debugfs_remove_dev_pasid(), it should handle it gracefully.

TBH. I don't know if it is necessary to make every internal helpers
self-contained. It looks to be more readable to avoid unnecessary
function calls in the caller side. :)

-- 
Regards,
Yi Liu

