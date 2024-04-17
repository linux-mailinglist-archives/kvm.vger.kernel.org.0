Return-Path: <kvm+bounces-14947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D04DA8A7FB3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 674611F21DD2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BC512FF75;
	Wed, 17 Apr 2024 09:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbIy4YlJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C282B6E613
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713346340; cv=fail; b=aO1XTXuq21hFxe3xk9rdywGOGh99tjt0lPfOMR/DtfVMJ/RgXy5UgPW3Ey+U3BlDOmJ74TV53WSYtwPPGRueYLKSlVQVyonsxQjV1oAYKq+Q26ty51p9h5RNCzPhrCkEkuhjpBEKV8ZXZOjYXbouU/6QKmHufP54z6ykLP1mv7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713346340; c=relaxed/simple;
	bh=otDmEqs/kifsn2UslxRF6SA7tIoaDQT7ss66oTfWreY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YGPuDCKFNLn6j+5vgF8uiWMDwv7eUcaNwL9JCtNLXyShl1sXQ8VxeUYLLZtxVTuiq3z7U34qaakTgbfGWsGCgu5Q0ZsvHMiFLwZFHXirHuZhJwSTmpWX3lU6vW545SiJ62QfPXVDK5a0zBwsapfPXT4tq7voNCprhm/Q1l4h5h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbIy4YlJ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713346339; x=1744882339;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=otDmEqs/kifsn2UslxRF6SA7tIoaDQT7ss66oTfWreY=;
  b=MbIy4YlJ6vwypE9YUp2lwj2YkGvkoJI7WnWSfVqzVRstwEhIvuADIMAy
   taM9agdYsNnK5mpb1l7JRSjIX4iquVJWwdepBS2zbIcLvSonajo65+xZZ
   IT2mqLqiYj6sZTITkdw6CDAuWNxd/P5h4o02OTBjt5sEStsiP1eQZIoy/
   /WNgZq1f4E9X8JNxpkdNe7ScOM2n2PZ8c2oEVEaqEBBbiaTHSEwuOOiEI
   INbP50v9+ua3HjUcq3xQeUhSjfKXbHpYyt1LgHjy9k9SCjTXCN/G5cRTs
   SpoZK+rP5axS6BZbDUcFtW8gv5sr0NFL+bA8KLb46LB5eDBsqZTRTf5bv
   Q==;
X-CSE-ConnectionGUID: YzfzfTuDTUeRgE/4ueHMBQ==
X-CSE-MsgGUID: E28jzYncR6SmWCnHxb9EqA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="26290297"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="26290297"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:32:19 -0700
X-CSE-ConnectionGUID: NXxrbfJ4TWK4gASQZqrdow==
X-CSE-MsgGUID: ti7kBrI1QcSgrsXM9GJTDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27353633"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 02:32:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:32:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:32:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 02:32:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 02:32:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CohQpTokthMOsf3Lfefi104up16ox1JPqw/FoHFzo5QizvWz9AJ2bLXXtZFIt1oKMt3G4pPciKMuo+JVIuz9m5AY2s8LbQ4uKQ6mCBjNQo3a+saJxJ3oFwjkEUPJY9omMsnnSTv5NXWgttUckP3iZd9KnCwWn72bBsWY2GDt3pFS33f6qXoddo2EoazM7mbHktBmmq1FGc0OTlqEFlJeOcK5D9POmRTwIxCkk5vWWi398Rq+aLzWKWS7d0ZynWxPBgcyqUlZ6PxzQNupgWQLqVDZNw02i6rreJfIXM7KbrSDwNVHk8/mxMEzTfMtJKphAj3NEqNP+q8KBmnsGGaCXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO/769t2/pZkC/mQAgw16DU+5KIUNBfJTfsxSKKfnFM=;
 b=B5pSn68goUFynp7JZRavICyMBXQySxCDwUO72DzJlWbWoKySbRa3lll6vuVANpHLVdTN7qyPWzEgGrgAug1n4KOVBH/qrt+Eo6c11xCgB4APJqNbms/Sr17LrlaUI1datBwBIjJ9xlwhvUv57SETxim0fgQa8IPh1/YnC+y2xnx9FevQ9wKxTV6DIst2gM1C4wAnupc83Rh/U0PbfAAhjwpSon645oR7T/FZwKJlSRtIHfwlVn/QZi7/lvFk5f3kjvEEh8dSA0QGN/KdvTOqS4/8ZlwHmy1SyXk8dpm8y9KYM8/x+PUdfj5tYHmAbby7CVIXsu6xJMUZzUoNL3sbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7768.namprd11.prod.outlook.com (2603:10b6:8:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.25; Wed, 17 Apr
 2024 09:32:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Wed, 17 Apr 2024
 09:32:15 +0000
Message-ID: <52e38f2f-0e45-49ab-a426-53ad57c20b0c@intel.com>
Date: Wed, 17 Apr 2024 17:35:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-12-yi.l.liu@intel.com>
 <BN9PR11MB52768C98314A95AFCD2FA6478C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52768C98314A95AFCD2FA6478C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bffee5c-7233-4116-2a16-08dc5ec144b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFi6wWgPgxNS1WXfCandCHQ/ZHD6voUMQMP3k1qSXk2pGmTRtsTJJMoY/ooiByif86hPILxrDuqIzvuhcSQfodfJPu48tNr8g/5AZs2wTYxtaGyrt17mKp7mAO09NoqRj3pXW7YI52ULnf8wCLHqF2HrsL2I9lDdydRD5g1r0HKOwgv3LI1m/SQdcC8sA1UoKMkykRmXatIkhxqY2gEabsefeIp8a3ZAPtgzu8Sno9NeimkaIGWdhhK/1JS8l/vTApaViNYtiKBC2b99T7tM7+7qXgsFIhhlNHYOtPl4F6aEa1jNkrQifSMTx+iqxdKDBktSVKdH6yqs4hfo0CngzRDkYFoPr4LcYchGm2CBWVU/ZHkpt6Cg0VlE8p1TEw/rlFnvQah/zF5MuCJyJs9+B8V9dS2ojK5s0tufeAn9awjA0beEB/D++8IM6viUBD55+e83bATk6Pm/gyD6EOs9Nz3d0B15JLvRn4EyQvPneFBtBeRKnOcHlwh7vKVxXI084JqkfpRkORRt5q/iiPPFU7HUBpOORyVSNLc9x3s7ioKI7pxavj9LYVHQMQr9JaJRc4DLKXjO3dFX4A5Kp0yMrwyDY+YDI/J+MUxWr2AOh7X8hdjk0vXImGt/WkySpAfc468RilmzJwTn4XFGcPQXVC7kyvxLGu5sTFDa6fRjaaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVZ2UG4vdGIvTFVLN2NLak9uQlRGMFdHR0NnQXlLZWozaDdOTE5RZUtsc2Nj?=
 =?utf-8?B?L21MTDkwSnhVdjN0eVloRnZiZmQwOGxvbXdxbEFxYjU3OEpUTGw3Q28yRUlw?=
 =?utf-8?B?M3JQQnZWZnN0blhldUlNYXhOOXoyM28zRXh1QlNzdHAxYlhDcWFGK0hmdmUr?=
 =?utf-8?B?QzF3VW5JeHoxbGc3QUdYS2l2NE45eWZPeThBYnJHU053R3J1U3NqVHJINUpN?=
 =?utf-8?B?RW84MFpzZVBiRkFRRnU4alVoTVJIRzBuZ1pDOWIvUmc2ZXRwdXdUeWtkcFVK?=
 =?utf-8?B?VEFwS2RLWjBEbEtnV0w5UVpjM3JCK0NSenJHMjI5cTBQTEwzaWtuOXBmV0xz?=
 =?utf-8?B?VVpLbENRMDdkYzBEWUp3NnVSd2xPY0ViUmRoV1B0cmdkVnY2SzJFc1RaaC9a?=
 =?utf-8?B?TlVaSG9SckJIdXNVbVFSako1M1poVFk3cHBlOXEvN1pHaUlMNTFLdkJ5T3pP?=
 =?utf-8?B?alFORW5jSVNyaHUxUTRBaVAzQVp3L2dlMnY1K3JSbHBqOU8wZ0VvbkUwdFU4?=
 =?utf-8?B?Rm9zNFNBOGtWd2hBWWlpZlpRWEZMbFQ1ZWxNdUIzWFBBMVVsTm9XaFU0a1R5?=
 =?utf-8?B?K1VIMEdmN1pXMUExa0wrVTFjSzlaRUJtUEcxQm1wRS9oMGVZLzg3RDBkUS80?=
 =?utf-8?B?WCtuemVMaGNkSHlpd1Z4MERQVFFaQ2tUSEJDdHFzMDhSSGlTQXdVdHU0R0lV?=
 =?utf-8?B?V0swczhBMWJiUFgwRk9KK05LY2dxT2JkcGRoWmpYQXU4R0E3alFDWG1Gek1R?=
 =?utf-8?B?b2ZLcGFrL0xodWhwaWhxVHdrcUhxWkpzQXhFVVZCVURJSm0xSDZsVUkyQXV2?=
 =?utf-8?B?RUhxOWZETjczZVB6YzlONnNtRSt2akVQdVhRUXFLb1B5REsrbUZIdVFHa05w?=
 =?utf-8?B?dnJJclBLaCsvNW54SXh6Z2ZuSkVBS0xldWpQVFoybmJwUXBuWFRyUHVMYks4?=
 =?utf-8?B?M0pjS2dwaUJnNlZMT1Q1cThTeUEvNlY0K3AvVWdtNEVJaXAyU0VVeVdkaXNP?=
 =?utf-8?B?d3V4eHJxUkRLTXgvS1pZMWd4R0cxc2FTaGJpRVV5akVpRWplc1gzZGxCV0JW?=
 =?utf-8?B?L3ZnbjNSMkUrMjFFN3lOVXJGQXBIc3FWdFZJZXFZcDRYZFdSWWJaWnpVcHlX?=
 =?utf-8?B?bXIxY3U5OU9iVUhBZElSM1F5My82VjRwdkxrMjBNdTRaN0FDNUVudGpsbU1w?=
 =?utf-8?B?b2NqVXdDdEd0ZVlHSXZBMkhTRGFTRVJSS3pMVk5vU2MwUFdwNDR0NTJHQm04?=
 =?utf-8?B?blBhTXdoL3BNY0hFaytIN0psMTJsTUZRck1YR3FKOGtiR1pGV3h5aU5Lb3I4?=
 =?utf-8?B?dlhQSURBeXppcE11bGZaVndOcEgxQ2lIVE5aVXk5eUx4a2lHUlMvN2FWbDZp?=
 =?utf-8?B?M2VJS1p4L29BZ204QmtRMmw5SXJsTEJTQjkzVWJQa0VvRUxqR3ZIVG4wWWlY?=
 =?utf-8?B?dXBCNVJBUTRzRkJBTGlNUE1nN3pEeDR6SU1nRHBORzR0YUZMbmZSZnpBU0U3?=
 =?utf-8?B?azlvL1FHeGVpaWNYNElHeTArR0crZ3cvMlJxTzVPMmJLc3ZKSjBIK01oRlJz?=
 =?utf-8?B?V2ZKdnoweWNQVnJzcmxCK3Z0TGNkN3lVMTdiQUN5UGdFakZxdlZ0VkJlcGFl?=
 =?utf-8?B?Z3VFZW4zd29JMmRVaW0zQ3ZxK1JwczNpUXF2VzdISndaQzA1QW1UZkYvWldB?=
 =?utf-8?B?OUQ2bmZXUmJTRGhpOVc2NEo0UUFHUWNERHh1aXltdTMrVEltSnBSeklCbG5L?=
 =?utf-8?B?T1QzeUpLNzB1ZmwycU4yVmVjM3E5THhGK3ZLU2lqdWZSU2FCZlEwV2hiT3Fo?=
 =?utf-8?B?dTUzTFJKWFZDajU3T1kwc21xaG9BWmVxY2wvaUVseFVVYWs2N2JsMXNRRCt4?=
 =?utf-8?B?K0dwUVhEMVRwRHNPMmlDVTljenV3R21mczdWVDNYMmVyOWRTYnRRMjlDUk5G?=
 =?utf-8?B?NXZMUkhXcjdXT3BXeWluQ3FoM2VzZmtIaHR0ZVo3RStjbHoxekhGOFRlOXRu?=
 =?utf-8?B?czdtU1FzQlFoV2toUmwyNDhTdUorR1JlQWxHYTVZYnI4UmtaSEpMRk03UUly?=
 =?utf-8?B?elVlTG5jTGozMHdMaXRCQ2I1L1dObnVpMWU3QXJCdGZlMmt6SWRzU1N5V05V?=
 =?utf-8?Q?gevMCmRVO41fPhr+0NGR0z8Nl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bffee5c-7233-4116-2a16-08dc5ec144b1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 09:32:15.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFGpc+Uu+CJowhVZLqFFNtSIjiA9ypWd3baWrtVtMEwqfnicPHXUo/Tk81r+ilZzuqNhtN+gpxeNIEnWMKPVSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7768
X-OriginatorOrg: intel.com

On 2024/4/17 17:19, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 12, 2024 4:15 PM
>>
>> @@ -4646,6 +4646,10 @@ static int intel_iommu_set_dev_pasid(struct
>> iommu_domain *domain,
>>   	if (context_copied(iommu, info->bus, info->devfn))
>>   		return -EBUSY;
>>
>> +	/* Block old translation */
>> +	if (old)
>> +		intel_iommu_remove_dev_pasid(dev, pasid, old);
>> +
> 
> let's talk about one scenario.
> 
> pasid#100 is currently attached to domain#1
> 
> the user requests to replace pasid#100 to domain#2, which enables
> dirty tracking.
> 
> this function will return error before blocking the old translation:
> 
> 	if (domain->dirty_ops)
> 		return -EINVAL;

yep. From what I learned from Joao, this check was added due to no actual
usage before SIOV. If only considering vSVM, the domain attached to pasids
won't have the dirty_ops. So I was planning to remove this check when
coming to SIOV series. But let me know if it's already the time to remove
it.

> 
> pasid#100 is still attached to domain#1.
> 
> then the error unwinding in iommu core tries to attach pasid#100
> back to domain#1:
> 
> 		/*
> 		 * Rollback the devices/pasid that have attached to the new
> 		 * domain. And it is a driver bug to fail attaching with a
> 		 * previously good domain.
> 		 */
> 		if (device == last_gdev) {
> 			WARN_ON(old->ops->set_dev_pasid(old, device->dev,
> 							pasid, NULL));
>   			break;
> 		}
> 
> but intel iommu driver doesn't expect duplicated attaches e.g.
> domain_attach_iommu() will increase the refcnt of the existing
> DID but later the user will only call detach once.

good catch!!! This is a problem...Even if the domain->dirty_ops check is
removed, the set_dev_pasid() callback can fail for other reasons.

> do we want to force iommu driver to block translation upon
> any error in @set_dev_pasid (then rely on the core to recover
> it correctly) or tolerate duplicated attaches?

The second one seems better? The first option looks a too heavy especially
considering the atomic requirement in certain scenarios.

-- 
Regards,
Yi Liu

