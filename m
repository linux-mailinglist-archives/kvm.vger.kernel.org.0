Return-Path: <kvm+bounces-26113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC6D971A20
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D1A2B248DF
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AB01B9B45;
	Mon,  9 Sep 2024 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrHHjXpS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58FC1B9B38
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886523; cv=fail; b=W9NG6eABt67YgTIaWTR/gjhfFf0g+JtNYZb3V9P22NaWuK/TI3Bt6+nwFG+Bl7qbGLOM07cHpPTKkUmL32Z9Edv2Ei0iw3r8ez5EerG7h1aTWFmMkFeEy3xWQeG5zRTWA4yApiUh2h8xD/kdWchVfcMyIeIxOXvLzN1fXZixJ70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886523; c=relaxed/simple;
	bh=ZTtWw3tiIfq94DTLadg2MoIXCTLliUsyVHUGdBcilOw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lj55pvsYAQ6wEa6fp3O5PGde2aT/+lg8SLmYpmVWBY/LYcHszthK84TbVBjg09p5Gff+GJRIamqYMClTZ7emsyUCYk/4C5E5WNr6iI8pDxzv3BjDU/mS+CcemTWXPr1eqiqoQCkJOwcaeW5dgOOai8XvV7lRKKWCcB1rWzZBj9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JrHHjXpS; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725886522; x=1757422522;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZTtWw3tiIfq94DTLadg2MoIXCTLliUsyVHUGdBcilOw=;
  b=JrHHjXpS933nfPyuVVktfUz6OLKDj1RA2u4RLC4PZwaY/I/Mn1WlmCsh
   n+YSr+KIg2vZy/gnI94UgP5yfF9uL6/nYzq8EU044ImOA/6a50CktTClB
   QXsTrxVQ0Q/Eu2AMCYq8gMD+14g2KnGX0Fiqny/6UieZZSBqtqVkdJy60
   bo4S8qshhf7Uh69sv+HknFZWijNOFGDeG2QCSykxipUXG/Fh9g0TrzqRv
   40GR9pl1v38OKCkjdf55VSRVhSpL5OXuwL97N3zqA7f90YXdKWAoV/PFZ
   eWzjJ6Vf4Ov1MErX+4FEwr0P73XRreQ4UKn3K0IH8NDviMj6V/NMwmXVT
   g==;
X-CSE-ConnectionGUID: 6OuorwNzRwieOE+bVWKnaQ==
X-CSE-MsgGUID: fgOHengRSBC84AnRx8pajQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="35155605"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="35155605"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 05:55:21 -0700
X-CSE-ConnectionGUID: swcwiVhlRgegBG6YuB+bIg==
X-CSE-MsgGUID: NSylIHAJRgOjZS5SkCQbMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="66295096"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 05:55:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 05:55:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 05:55:20 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 05:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xh9FUlm5URE2jw6L+onfoVVY/PZbfBlZq5p5BcydsCoia3PQJ2qw1fDUBpHe+CIKzuyG7VgDIdOxogVljth5hgeHAq5Ddb7ECE90tyPml1t+tTYmbtN0bFT2DajDwxQKBQgZXjr8572NJYImRBlqsCrRAZxg0J17QjPXMebq+VMQm5NXowHhz3KnuCHqrkqdplua9F/aiZZDt7RBIVwNBL7Jh2fQNYFubJJEAiYutDfnLUKSRhQWsNvk3iyEYqeMXzeeuSgFDRaY4I1Oerzk1iXfMoEDCRz3VP/q02xa5TZDlwSi/uXPJrEG690cx9M3tF36eRH3ZJL+HwZI4j0KRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEwgbpClOctP8Eq4Bw9ELnRMAnpIOrRcjLRAXEF8utY=;
 b=wLbwmTGgNiETGCPoshE+rk2bjOLwvEmzRi/vWfySpv/mrLjetGmOW6InUScQXXjxp86VnDYWDJ/bhzpzbYXa/FmBqDJj1Ow1YMHBTYP99URrrxzf5zDrLerGu3KfEiJGtLipDysuTC9C88bBZIriofNZ82rTMMT3XB5zl1qno8QIayw8utP7HUPO/3CLe4fdObJBN+XmLj+dY9ayAyyxpAuhPJ+3BQYyjI8crVl0fDWPXLdwzw1IBXOMQjlOOZy/z9uV0pemXTLSty0Lo9zmsxABy9JcJom0D4FX9czHjGlnGK+Uu9TDDTbXI0XpO1QeHiC9sAbNkAFl5tWrUcH2MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6524.namprd11.prod.outlook.com (2603:10b6:510:210::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 9 Sep
 2024 12:55:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 12:55:18 +0000
Message-ID: <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
Date: Mon, 9 Sep 2024 20:59:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::23)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: 034e1069-964e-48b0-aacc-08dcd0cea7e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VG5FaTFBRURNQ0dVajd2czNGWFowNXJKMHgwUFRqNDI3cmt3YlYzdjZqa21B?=
 =?utf-8?B?Tzhnck9sK0pnb3U2VTdjREZMUFlpZkhWUG1UdHZaajRGZ0pQdmhwRUNESlBM?=
 =?utf-8?B?Q0Q4WHU4VFVNN2VLYlovaGtQK2Q4KzhDYzE5M3YxMWVna0hVUEhucnl3MEpR?=
 =?utf-8?B?SWN4WXp2RkdINC9EYUsrWkk0OVY2ZVFGN0JqVTBvTW51K3JxRWhhQWcyaXZW?=
 =?utf-8?B?Rkh1dTE2VGo1d1E3ZEM3bzdVa0VLQXlUZzIrcUd2YTU1LzFMMm9LQWxCblI5?=
 =?utf-8?B?azh3Zk5FR0Rxa2o1WHczdEVHektBOUNFdzBlZDZ2YUtRaUhlc05qaGJHd3NY?=
 =?utf-8?B?R0w2Q0p6SCs2aERoVXN2KzNyKzh0dGMzYWpiMG04ZVVxeHJyWC9NcHU2bEJz?=
 =?utf-8?B?eUdhYWdkOFJiUVBwOFIyNTYrU2g1TStMNmI2THYvL3N1Z0k5SmZxYlFGaEZa?=
 =?utf-8?B?UzMvSUV3dDN3dW1tcjN0UmtRcjZTVWMxTlhPNGs2bFFnQ0QvSVgrbGk2bklB?=
 =?utf-8?B?MmpTVE1QbGdocG1oekFUVjIwVEpva3JtZVJnNHozWk0xa3dsN1dkRU5qNjZ6?=
 =?utf-8?B?VWI3RnVCUEpQNEkyMnBYbCswZjFHTXNvWlVBdTRWbnlpSjd0SkJJQjM1RDkx?=
 =?utf-8?B?TGZIaVZQdXA2NEhNYTI2M2FwdDlVdlJ3VThoRkxBODZISFhVaGpIUnRJWm1w?=
 =?utf-8?B?YjhCTytQWlFjWFdlMFltb0VRSjRITVZqUDBxaHNJTWZ4RmM5K2NjODBhTXFy?=
 =?utf-8?B?Tm1GMHNIZllmUElHNzBFZWhWdzlpdWs3aWdyYkd4SndCL2c3TjJKU0VYOVNY?=
 =?utf-8?B?YUFoQmRrOFdUWktsODZTc1JEVFhnczNlV3BQOEFoQmdWUGpIS2lIMVhaaFlS?=
 =?utf-8?B?ZDJKRHdiZGhYMUc0dGc1VklwTUk2K3BBeXpRbndLM1c2WlpuTkx5Si9Zclkx?=
 =?utf-8?B?cEVTRFJGNkUrK2hzcUs5ekFabVJaM3JZbDdhSjZOTmh1TXpiUldpTEhtcTE2?=
 =?utf-8?B?NlA1alAzS1RXcnlvcjdLUzZmdm9YNXVjN0Y0U1h2MXBmRTZ6V2dKa2ZLUm9F?=
 =?utf-8?B?ckRQbFNDRUxTc2Z4YzlLR2gxVFZDSTU5YWluUEVtQzRvR1BvY0gxdkJnUWMv?=
 =?utf-8?B?UzZydW1rR1l6amV4WGE4bDhpR2NTT010ZmRiWWlBWjc0NTV1dEIwbUw4Z3dJ?=
 =?utf-8?B?c0NxM0dhSXFYNU5IU0hXVEZSRnM3M0NwS3NKaEY3L1BoK3pVVTFKQWNkWXJL?=
 =?utf-8?B?TFJnUUJXUkgwU3ZWYXZNMUVjSmNEdDlnbWVPeSsvanllc2Q4Z0dhazRVditW?=
 =?utf-8?B?S2pWZWhsRlNybzVhalNtcjZQOWNMWTd2R1Q2VDBDWk1xL05wejJTZm5sRkhI?=
 =?utf-8?B?T3JwMVpjQ1YyVkFwNHVOYjdsQWU3UDgvSTMxbmxJSUdRV0VyV3Zvd2ZwaDA4?=
 =?utf-8?B?Z3ZidU82T3cwcExaaGppU01Lb2NuZE1MMzVDa0c0MkZQa1ZVdGd2ekJSbFg1?=
 =?utf-8?B?dHlHN1F5TEErS2xLN05BemxCQkJJL2pIelg4VjdITGVDRFdiVUxiQkdZblZi?=
 =?utf-8?B?WUQ5eERPY082cmdvM3dLSnUxOWthd1VzMmhaVW93WERMWlVyVjJBYXI4eDlt?=
 =?utf-8?B?ZFRYdU53SDBmaXdKRG5BcjdzdlFvMkppRENWOUVaKzlGSkE3WDluZzdTU1h5?=
 =?utf-8?B?YUNJZWIwck52VkgxK2pEZWNoVXVYUlZtNFRzMDBFS0JCME51eGMwdk41UUZK?=
 =?utf-8?B?ZTd4K1FPY1BaNkJXWWd1d1lwSGF4c21mQkF3clRkU0JiczU2Y0E5MGdWR1Uw?=
 =?utf-8?B?alo1TTlCSUQyVVo4SzBjUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3U0NTM2aGNWaVp4QnVLeG4wbzhaWmN2dFpLVkdyT1VNZHlRL0lwRitLOUtJ?=
 =?utf-8?B?Vld6YWdjMERaMTcwT3RtdW9SSkxGcG12NDgvdWVXQVdtQnV1a2kvUWtQN3Ay?=
 =?utf-8?B?cHJ1T0w1K2RGWm9EQ2JxZzRCOWc2bzBQMlE3VG5NS0gzSzhaelpGNTIvYndN?=
 =?utf-8?B?MTdySEJwWFBQa1A1T3gvWExMZks4NktBcFVqK1FGdHlxTmFUMGxGMTYveWcy?=
 =?utf-8?B?alJkeVIveHRCRkZ0K0ErTUFmdVNBaGE3dEFobnFka3VWTzNHYmpFcWgrdnM2?=
 =?utf-8?B?dzZJK3dYa2czZE1HMW1EK2gveHRKUW9LalBteVlDdFJ2MUpxOHFyaDJReEdY?=
 =?utf-8?B?OXlUNFlqUU5vdGF3L1BCcmRIVFB6NmxnbHdiK0tSQURYZXB1NTVkcUd6MFRL?=
 =?utf-8?B?MFBKVkRCanZwUDRsOTFEdTM4TlRZT3lJWmVZQUlGdzRJcmNzOWxFNWMzdlJI?=
 =?utf-8?B?MGEyU0RFQ1djbFFVcHB4RW8wT3AzUHh0alVOTVREK01JZjI2YWgvbFFwL21R?=
 =?utf-8?B?bTVhNUp1NTBBU2lPVUNVQStlZnRCRzlURFRvc1o4ZXlFeW4zVkJOTGd6cmo5?=
 =?utf-8?B?QnJOY2VSUWhPUlZUTklXYUZMM1NFNDdUcWVoUkZ5WWQzbTc3L25Od1FYYko5?=
 =?utf-8?B?RGNEK1JsMjY2dWs5M0VSUStMYzlZYk1ENWU2RWhsYitnNEkzWFpRSHFoUGJ3?=
 =?utf-8?B?RDErNlpEbmdkUDNmZ3ZERG5JaVd3a3RhV3BTL2twdkJ3Ymk5RVJwME5wejNV?=
 =?utf-8?B?S0ZHcnMxY0JrQ1pTNnpWdlRSZTNvTmlVcGRsbnBaRGlUTGRIekxwb2RWaUpv?=
 =?utf-8?B?ZENYaS9tMUg4di9heTBZNCtQL252VE1UNzFTK1liT2R6R2loSVNjckFjeDI4?=
 =?utf-8?B?WHJMRmNyL0RKUHNHQUs2T3lhbWEyUXE5czJhL3VFdFpXUVJCYXlvNjFTemhm?=
 =?utf-8?B?ay9TU2xQKy93SytqcGVva04yMklWOStyYlpETUIyV3d2MzZMSTZwODNrMWNN?=
 =?utf-8?B?OWo5Nk91aC9uWGpqT1NYOXNPNnNPaFNsdlQ2c3hiMDdxdEZhcGdYWFZoK2Fw?=
 =?utf-8?B?WjVLK24vbTBzSkNiQ1FkeENBQmFYLy9QZThJeHZtb0pnZXRDVk1ZdTdPZEt6?=
 =?utf-8?B?aVMySFdsK0pBSUUydWd3dE1MY0N1cHlJT3lROUEyV2RTMnVkenEwMGQ1YWZt?=
 =?utf-8?B?bExkalp5MHk0UjVkNkswdEhyM3B5cFFYdlZJdFRyTDJmRXZFMnhaNWVoRUtT?=
 =?utf-8?B?QjE3U2NEQ1NxZ2taMG51bVQwZmtDVW9TYlNVdjFZV0R2d3lEZ0pPTHFXd3VX?=
 =?utf-8?B?dVdGZ1ZuKy8xaEZicVFBQnEyYU9IQkhxajRya2FiUWFhbmkvakh2QmhhQ0p4?=
 =?utf-8?B?ZVIreHpONVI2YVdMMFlpRG5rcHlERktrajd0UkRFOVR2SXVCSDJObkNBck82?=
 =?utf-8?B?VEJrK2M4RWo1ZUFLcGQ1T05UR1Q1N1B3RmpObzdwTEVpWmRHK2Y2QkhncjZj?=
 =?utf-8?B?aDhrMnZSY1lONXVmd2VWclk5aGo1SXhJSXg2T2RmQkdCb3JkdEJqQVBmc3N4?=
 =?utf-8?B?SEd0VVc0NU9aemdJalBYY2JVS0dyWTNiOHI0bGtkelhJYXM5bnlXZXRwejlP?=
 =?utf-8?B?amlSbzlMMFhnMnNyUHJCVHQwbDZPWmpvaGJPTjR6SldSblUzT3VzTm5kVmJr?=
 =?utf-8?B?SnlYWDhCdmo3eUJBR3JkSWNWMHZzdHhxaktId2NISXRRbHpOeXNnNUZla0FY?=
 =?utf-8?B?Um9LRjlkUTNxRHBEcnRHQjNZY0lzUWF6dVZGRmZZck0zdTYxNFo1MjhHMTFw?=
 =?utf-8?B?SkMvRkFUVnZVUjhUTDNNclU3UW1XN214eDJWTEptU0J2TksvTTh1WDVXZ2VU?=
 =?utf-8?B?VkVMN2FxQU5UTzREcitWcm5wL1FBSFdHczdSOU15cE9ZK2tGU0s4REZ1Y2ta?=
 =?utf-8?B?dTNFN01odEk0ZHo4YzNCa282QzZVOVdQa3VRcnJtU3JRM2h5UGI4VnFWaHJq?=
 =?utf-8?B?Qjg3Ny9VOG90NlJPR1MvTHVzWndWdGJ6Uy9SellrQzBXT1pqTUVYOENESVRF?=
 =?utf-8?B?K3JyWW03SWFNUTVqUEQxaU9XcDlMTWdNWXM0MnpKb09BZDhFZXpWa05aaU50?=
 =?utf-8?Q?9NHIJuN18pw5YyepHFeWaaHnW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 034e1069-964e-48b0-aacc-08dcd0cea7e4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 12:55:18.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwumZMNBCISMi4l/dXK4gyfpNGZPsAYrQ3UMHXbJ/+1wIUUpRIOMGShUXPmke3pFL20xg7rMfXx5st3CPQU3Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6524
X-OriginatorOrg: intel.com

On 2024/8/14 15:38, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, August 14, 2024 2:39 PM
>>
>> On 2024/8/6 22:20, Jason Gunthorpe wrote:
>>> On Mon, Aug 05, 2024 at 05:35:17AM +0000, Tian, Kevin wrote:
>>>
>>>> Okay. With that I edited my earlier reply a bit by removing the note
>>>> of cmdline option, adding DVSEC possibility, and making it clear that
>>>> the PASID option is in vIOMMU:
>>>>
>>>> "
>>>> Overall this sounds a feasible path to move forward - starting with
>>>> the VMM to find the gap automatically if PASID is opted in vIOMMU.
>>>> Devices with hidden registers may fail. Devices with volatile
>>>> config space due to FW upgrade or cross vendors may fail to migrate.
>>>> Then evolving it to the file-based scheme, and there is time to discuss
>>>> any intermediate improvement (fixed quirks, DVSEC, etc.) in between.
>>>> "
>>>>
>>>> Jason, your thoughts?
>>>
>>> This thread is big and I've read it quickly, but I could support the
>>> above summary.
>>>
>>
>> thanks for the ideas. I think we still need a uapi to report if the device
>> supports PASID or not. Do we have agreement on where should this uapi be
>> defined? vfio or iommufd.
> 
> IOMMUFD_CMD_GET_HW_INFO.

Hi Kevin, Jason,

In order to synthesize the vPASID cap, the VMM should get to know the
capabilities like Privilege mode, Execute permission from the physical
device's config space. We have two choices as well. vfio or iommufd.

It appears to be better reporting the capabilities via vfio uapi (e.g.
VFIO_DEVICE_FEATURE). If we want to go through iommufd, then we need to
add a pair of data_uptr/data_size fields in the GET_HW_INFO to report the
PASID capabilities to userspace. Please let me know your preference. :)

-- 
Regards,
Yi Liu

