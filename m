Return-Path: <kvm+bounces-13418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF378962E8
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 05:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C30731F246AE
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0994122606;
	Wed,  3 Apr 2024 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+WZXrF3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAA71F958
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 03:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712114533; cv=fail; b=kGfLoFeL5/oeb/4afLzeCLq05wpG19vjv7/4TZn1w5zZqAn7HhpIYV8iL1NI/Mte4CZSK8Js3+3WD2+7aJWzYgxK72qqi+EuW1nu49XB3dy8fwZqvwccEuo0HqrL8Egab5BOHpS6Gc7trZX6FyrXoCT6q1g1BQNUZYKrfHQGMzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712114533; c=relaxed/simple;
	bh=ifpYB9ko7e/BqnRB3eJGXaKpIQmhBOBx8XGDYizYwsE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LSEF9ieqsOXSZTg8lqM1AmN89dYTeDtoO4u4TOZ/ME1QWw7lswnRIHks3KxewgIrh+XgJ4QStZQQyzG46ZQsjYicVYgmrY1aqav8Dzu+Co/QuzCrksiMRpT5hnqB7aSqoUe1TFWg3UcM6paSRjYPeBImreayPQlULn+KLkXMLgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+WZXrF3; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712114530; x=1743650530;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ifpYB9ko7e/BqnRB3eJGXaKpIQmhBOBx8XGDYizYwsE=;
  b=Z+WZXrF3tTHLwPZX7KrmsWRjxWEIQ7rl4B2nB0nGagT+1MmNOzxnYOkn
   IakFWrirV7AzzUY7oOkKbqR9aQM99j/tlR/z0s+1eGgyGCaMT6neOcPKX
   0sqDtTKDtfd9TK904lj6tcWYoL/FReICbUu9RiwOnUveVCBEh7UQ/R0f+
   Q8qvXLTAalc4cQn38jROne1E8ba/UXnTe6+LC6m6qjRhqKgpf84My4Mni
   VwvJnuHsdI3KqpmFmHMf+yYJUdZvipy8gP9/jxfk6pL4CvgiswIEQQ/ux
   Ux+c9YaGZkmvf7Qk1+9hnZ5153xxQ5AMYWlhGNu93oAiTwDn4Ql0xLfU4
   Q==;
X-CSE-ConnectionGUID: FzIpfH62R22DokOF9aie8Q==
X-CSE-MsgGUID: ISndVETlTUmRv7eEQzYbUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="18687321"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18687321"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 20:22:10 -0700
X-CSE-ConnectionGUID: 8Qe6X1sqTcy4u0UiQMHeMA==
X-CSE-MsgGUID: j3Bs7C56TDqXAqyBe9eE3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18371755"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 20:22:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 20:22:09 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 20:22:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 20:22:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 20:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLM0dEWjPZO2Jz/ItV3Xfn4BINYJ0qybNygFBC/xsC7kf4JW6uF7u/PLrB5sGPPpgFZIDyVKUWw2nh+M9o7drf4FG47X5K9tB3pc3bTdljGV0+nv7mBxPwX+oViDp1Z6zaXFFTvI1dVhcXqYLw2gWXd5OmGqFOegnxkyWQpJTdrY7Kr6WTEI2BGA5kxCUF8fXGcQmjWRHGQyNsk6qigaKAewhF9cpgbYFdW8TABRS5jZuwqsFMmKVlH5Gr8PcZAPmH+8t7oLfPiwiMN+Rhx/QmjuTbS9ShBodwOWmpsS6Mc1LtRKgK0fV6Sdv3bpo8stzTHz+vRxnMrJaJobREb5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyfPH6KVHhXZ61SloS2o1GO9LzTusgPy9+z7rBq6ou8=;
 b=ZEUOeethlQRNYmoDHkAde2i28w/XU/bP/ZFj1ZLhKjCXrCBnPOT5uXkOLY0jcmmMPH8AVQkeCpt7hYZdnO/msHknzyw57GOLpffID1rLjjhQomfvkmxFO1I//48XBYA84pKylzPOAtzl28dTIbThuLz3al3GA300qC17FqixghswLNtV+YWugV82CQ8yQ5pHlN1XRs9Z1zCnQlOw5MpLs5No5fESow2w013AmaVRuRShWt7WZTVDZz697V81xZItDobMlsOyZbc6NjrHXRfPL3uHIMZmi5nosx55QHAxnrbJBE2Ij1Q+wt+RnvXfc9dN37T1S6KETf681387+tVNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5265.namprd11.prod.outlook.com (2603:10b6:610:e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Wed, 3 Apr
 2024 03:22:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 03:22:05 +0000
Message-ID: <735f81a8-a605-41c0-8252-15715e4d8884@intel.com>
Date: Wed, 3 Apr 2024 11:25:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] iommu: Pass domain to remove_dev_pasid() op
Content-Language: en-US
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <20240328122958.83332-3-yi.l.liu@intel.com>
 <ffa58b7e-aada-4ff7-a645-f946e658785a@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ffa58b7e-aada-4ff7-a645-f946e658785a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5265:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKcTIazvNGpDzU6FaOaGuZU8njujsFf36CO4bVWkKbc4Z6lI+YVmmk6TWSp9qhwL+5uQti6GQBdcDRWQ/JgJ3feuj3VgRCsRpa4BPX9/knOyOqfIMdzKK0tAzmDCwLjhAE3bL3k4+BNSFg13uTGiVGuH7OsqjKX2qy3/M8qUQx9G+MB7Q6S5m+eKfmXXiWTse2PRDlWBEoFrLubrVE2P+mwk7JxF98iGKFqbjvN7XKYfYftFkEhlYlQOQgrESWqK3lauPVNBOZi44hGIOuXpF9p1MN3XiXgGd8R7b/UJ+Y8Z64yoDOU/0SCHkRDo4gYIMFzrP9mkQJJLiU2/jBu/LX7s8EV4fuffuvc9U7Ig+ip5iWJVrq46aJoXYuTob2Qbo1p+xOg03yGZF2XzbQGfHzR2cq4+6tM2seGdXhCiJV3OiEEJayNl4D6XxsNZOFKbsyQXFfALLzxCToamJ/o1NjYw/ixXtBlzCfB7eFrnla7bR+kd61sxhFsJWCNB82frxU3cwB2AwxljUo4H+DNJQtqd/DNUPuLBYUmwIzZ0rNIr+jR1wehriToh2yDyujUoWgnwWfY7b2G3SVJbQXakK2jSeHxpB+NNRSae3W6op2K86eVdItJ6Ct5DTqopekS6P4peVMr6O5IVhmvL9BqwjZX9DQZaGhPmRFetzSDCRbU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVR3ZjRuKzZlMC9jMHhRcHJWMGppc05NdnE1blgxS3o2L0paTHMzN05xY2FI?=
 =?utf-8?B?ZHJNdG02dXRka1RLZzZYUGFLMnJRL2Q4R1hCeUt0TzZmdk82Rk1BdXh2SFk1?=
 =?utf-8?B?YzJFYlF6YVpSNkVwTmJkdFk2Y0x1S0JQR3FuQVlHR0R3Mitmd2dOY3hJd1dz?=
 =?utf-8?B?Zldkem01WnM1Unpsb21DbVl2R3NnOHUvaldFMGdBSnVseXVxY3FCUlN6aXpo?=
 =?utf-8?B?WU5yaWVRNW9aVXlTTDNOSWNMRW05YzMvM08xZXZKazhIT1lVa0xQL0VCT2d5?=
 =?utf-8?B?bkpvSjBKMVlwTWpoRzI5ckpaMXpyL2dKZmFjQ3ZLcGNaZmk3ZTgrbkNwK1dE?=
 =?utf-8?B?Wk12YnlZVkttaTBTTFdJWGs5cVBwQURJOHVQL3ZXQVd3Yk51WWZUTDROQWtZ?=
 =?utf-8?B?Wk16R0grZ2dBWGVtYitVQWltdk5CTVhHeWJUZVBpKzExVmFIRzA4cG5XUXpH?=
 =?utf-8?B?N3RqQmhlQ2tXQUF0NUpoQTNkQUxGN05UY2Z3R045dURBU3VERlY1N0hSdzVY?=
 =?utf-8?B?VkFsZHp0cjUwRnVtVS91Y2g5dnpFampPTkV1S203c2VjY1V2Z3J3MEtTeXox?=
 =?utf-8?B?QmRMaDFGU1JPbTdva0RKQlhMR2lWT08wZDBIWVNaUTRLSVl4NkJXYjA4MUFQ?=
 =?utf-8?B?bkNGcXFneDY0cGhENlNQOTBaUmNyTVZRblIwY201bzQxNVNGeUQzOURxdHVQ?=
 =?utf-8?B?RzlKRnpDZ2p3L2Z5dlgwbkF4a3gwTGJqU0N2aW9wMGp0VVYyTmg2TFBpcm40?=
 =?utf-8?B?WDZYb2tIdEJOK2xzM24zNVhkRUdFS2dUWlBaQ2oyYlV4ajM5UHI2ME5BQzl2?=
 =?utf-8?B?RVZELzJmNExtOCtBM0l2Zm1SMHlPV2hSWWEybHJZeGJxejVENktUQkI4b2Q0?=
 =?utf-8?B?T1kvMTRnUEZsb2dFaklWc2swV3VreUVXZzdoQ0hsdTZjb3FhNGptRm55L0RN?=
 =?utf-8?B?NndCeHRyZEJFZnNPNDB3U2llQVJUakQyNEVqaldnTnowVWhabzlsQVhvelVt?=
 =?utf-8?B?QSt6YWRWNnhjWGEzdWhZeGo2ek1wQ2ZsbDIvS0RvMW1EeHdaZXliWG1mT0VR?=
 =?utf-8?B?bnBER1EyL1llaVRQTDVIdDlkbGxhSWEzdUNKQU42Q1p5ZXZGMko1aUtGWUU5?=
 =?utf-8?B?OHZWTFFhVldVbU55dVlUcHh5dGNKdlhvUjFjWmlURzdNK0FWMU5uVG9WZkww?=
 =?utf-8?B?eGxMV2VmNVZJUnc3WVNpbGtXYTdmUThpNFc0MXZxaXo2ZWNvL1BoMWdMNmxF?=
 =?utf-8?B?VHUrNkNqcVZaMVV2UzFhOTVTVG9MaGJsL1YvQVp3MXlkMUZVWjBzMkR5MGda?=
 =?utf-8?B?VDM4dnJQZ3F2SUFDVlJXVnJqRGpIZjFYTkoxTkRXdTZkaVlVck1CRkw1dXVX?=
 =?utf-8?B?Qk1nMXJERTYrOERGZE52NlVxaG9WVGFyd3BjT1VtM2d1Y3J3M1ZFcTd2Mldj?=
 =?utf-8?B?OStwWmN0dURLR2JLRUowQ3pEczIxY2gva0NOT291eE90MFVPVnlEOHFBOEhX?=
 =?utf-8?B?TTBhU0ljbnE5VzMxcTlCemFjdmtRczhPK3pidkt6NW01ZzhzT3VzMTQxUWRm?=
 =?utf-8?B?NlhLQTc2Tm4vb2d2U0FMR0JKMG9IaTFTbTIyL0xqbnZ5TnZvMkptZXhKNkdC?=
 =?utf-8?B?L3pYRWQrUDF5SFpWZHNQRWFRMnlvTTA5cGJnNFlDRnVTRWh2NjY0Q1FFRkdU?=
 =?utf-8?B?cUVIdlczenNKNUtVUXRGemJsWVhmcHZmR1NUQVlqc3M4TjZ5SVBGMEJISndy?=
 =?utf-8?B?Q1RKeVplV1pHbkplaEZqNTlkR3o5eFhrdm9raUl0NjhtWUx0aXFIZ1NrWmda?=
 =?utf-8?B?dml5YzB2S2h2Nm5TWExYeDlKeDl3cWxRWTd4MzE1eGxNaXRKd1VNcWF6Qzd4?=
 =?utf-8?B?dEUwMVBJQStKZWJWNmVSelJYSTdTVkxpbkNDMitDcEFIZVQyVHJSdURIMG5L?=
 =?utf-8?B?c1llbkhCckdpY0tTV2dqa1cyamhyVVNwV1pVTFgrWHFmbXM2bkc4QTNBQXJG?=
 =?utf-8?B?dWtZZFVYbHNqM1psTGZhQVZ5OUZDKzdZa0ovdVJ3SHlPTEJJUmc3WUk5V2Y0?=
 =?utf-8?B?d21rWHdyMjlTZDR5TXhJMW05RXhnTVZvbG83WHdsR3ZDUG41dGl5UzJMUm4w?=
 =?utf-8?Q?cZgmecwQJ6gVPSEW0PFvBOLmq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bc4a02-b7a7-4cb6-a5f8-08dc538d3c85
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 03:22:05.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCDSJFOTRNvHLwCimF2Wr+sao3hSFbjRxvLhaam3a8OyE2UmSdRyEls71YIGwtJG7klWjP3F+E4Cf5nVGciC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5265
X-OriginatorOrg: intel.com

On 2024/4/3 11:04, Baolu Lu wrote:
> On 3/28/24 8:29 PM, Yi Liu wrote:
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 2e925b5eba53..40dd439307e8 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -578,7 +578,8 @@ struct iommu_ops {
>>                     struct iommu_page_response *msg);
>>       int (*def_domain_type)(struct device *dev);
>> -    void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
>> +    void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
>> +                 struct iommu_domain *domain);
> 
> Previously, this callback said "Hey, remove any domain associated with
> this pasid".
> 
> Now this callback changes to "Hey, please remove *this* domain from the
> pasid". What the driver should do if it doesn't match the previously
> attached domain, or the pasid hasn't been attached to any domain?

I think the caller of this callback should know very well whether
a pasid has been attached to this domain or not. So the problem
you described should not happen at all. Otherwise, it is a bug in
the iommu layer.

Actually, there is similar concern in the iommu_detach_device_pasid().
The input domain may be different with what iommu layer tracks. If
so there is a warn. This means the external callers of this API are
buggy. While, I have more faith on iommu layer. :)

-- 
Regards,
Yi Liu

