Return-Path: <kvm+bounces-33940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88FAD9F4C4E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EE40189481E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ACA1F428F;
	Tue, 17 Dec 2024 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ex2Se/3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDE01F4295
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734441813; cv=fail; b=WCbsOeeq0yhyNjgNeWlE0uIl+hDHnsuGULqrdJWzfpCFUDFQJpsv1hPgN2VwN7LbDxchnRASHhhNzrxxULp0yZoYP011NkaXIkCQodqqhuQ85qlAifOIkBhtMiRsVL+/iHG1cq+snIAcJSaqqiyonDdj8pdGo07+zjUpeCBXtBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734441813; c=relaxed/simple;
	bh=g47D+Nw7YMo8OPf2kWgLq6tCtE/vdDt4WfZpQcuf6no=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EYrIwOWA1LDptysnBQdblvBzR22EiZcR49bOBgtITa50R8m61Mahj8Dl2pf8SPW2gzOvlcx1gXlBDXTzwa0HgzdcoVz7WHcmieG3bessjhnGtRnnheX5QtIBnPQHeuh/nsswi9RqDADlRcUbHilRRElpyy3rbhYza0cLxIT11cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ex2Se/3U; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734441811; x=1765977811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g47D+Nw7YMo8OPf2kWgLq6tCtE/vdDt4WfZpQcuf6no=;
  b=Ex2Se/3UlbO088DoMDV7ugtYvKUePlaya3TFMwLxORM24Frt3XoW3nkK
   k75s3WTFG9I8JsygCSfHg4u0DHEd5z9oOlBvFJvn1fv9uAmvD8BLfW6Yr
   0zd4zt7WYUKKa70UrQEncSaJiadkfuu5gdS56bIDDGCXEzIpi7JcYNa3b
   7B+YhXINSCKUFHway7x829ARh6MoEE+f0uheOSuCFYB7gv/sO80eTiF4l
   qcvBjbbC46dvEOS2gjBNxO7UQG9vAZ7nqBbCuF7Qlmh95UXVcqRQQ7wu1
   iWMEUjCDJC0x5lPE2nxLJV9VF3PHReFv7iMixAdQN9ajVVhXJtN5AiWRc
   Q==;
X-CSE-ConnectionGUID: Q71vYT7eTfOAtupSPTnqPw==
X-CSE-MsgGUID: UR5kAJQGTFu57wG+7oxT0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="34996950"
X-IronPort-AV: E=Sophos;i="6.12,241,1728975600"; 
   d="scan'208";a="34996950"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 05:23:30 -0800
X-CSE-ConnectionGUID: GEUYqdhAQJ6vi8YaNg/rQw==
X-CSE-MsgGUID: zUP7TvwWSAi8KMFKlP14bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101671029"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 05:23:30 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 05:23:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 05:23:29 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 05:23:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fuj8NVdkr4RkbkdsaLOVQ67TnirOywEGZtKYyZ3ewIJA43toAaAyIAmtoF2X5miKcq4uj38Z0hC839bNIy9mx3sw8/E8yhF0HNQb6Ra9wAaObwLTD13kgo891iA1s/7n/Sd4uVCgBX74vd2Z2SAF7U6QkBJuM2aipUk6sHwgg+Ts04PSIIfI1q6qkRBoggncMotI0hFALfjN0v6orovHdHb7Z/jx5tbsY4qO22duvPsM38PaPhkHXEYQdN4c/lRgjpYj+P8BEPp6GJ1VPcGhP7ceQXhqAuyvp+BkwTjAQqTjGuICtHXi1j9QhL8wnI0i41x4GjNoRJD1rdH5CtPc3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/wwkX2cZMaUqqC8Cq0/PKRKX/4mqoL9+PRB4UoGvBg=;
 b=OBfAg67H6JWRoj04XeTOYIWhpG12LWX1PKw5A3iWkYqwognZs3ImuPvZp+scGd1LbgA3z9cR/XkZ9I8RoBnBP1uSX7ttOD36Y7wUPy2umU10rikJHywrgc31iY9e/ZCMNWO4vaPqCvJQUW4tAhr01DZKYc4AgS19M/hsVbKJ4HSxB9jC6Jh9z1bISWxm6oZFZ1IbfjocslnoNqVEkLdcn8WbEZc2/WwJ8AmTIh0+WY7n0nQT9sW+TMw1wtfn5aiZQg8MVFr0bGWauWDR3lAGPSro30vbE1DEXKUiU1y23tJ8niAzKjPa0TYmMnxtOoPHAMBw24q7fXD29j8wMVheYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Tue, 17 Dec
 2024 13:23:27 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 13:23:27 +0000
Message-ID: <c450a9d4-4bbe-4305-b4f7-f20396e3d8ac@intel.com>
Date: Tue, 17 Dec 2024 21:28:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z1wrQ+kgV53BsodW@nvidia.com>
 <46b7fc65-491f-4965-9d9b-d77901e41dfc@intel.com>
 <BN9PR11MB52764D0A5AD30E7ECC7F95E18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52764D0A5AD30E7ECC7F95E18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: bb27322b-e50f-4d50-6eab-08dd1e9dfd5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUc4eVdxZjl0TzZ6S3ZLcUlpY01xNWs1d0hjWk1rL0wwZ3hvYWNKaFV4eFRW?=
 =?utf-8?B?ZkJmMXdZTEJvQkk4MUg3Tzl6V2VPN1dvaVBTeGU2WkJTbWlxTCtSTnlTYkE1?=
 =?utf-8?B?dVNDdGlsMGY2ZmIwSEFyM3c1ZEpGbGljaThBVlhxb3NrYUhVb3lXNmVZYU9u?=
 =?utf-8?B?bkJheHdXY295Z3hGdlFXYW5iNU1XRUlPZENab3R3dHkxQ09NWE1hdWo4OVpz?=
 =?utf-8?B?ejNkSVVYSnd3YmlybjRkZVZsOEt5cHJKRUNjREk4MXVDbmZFaW4wZjk1QnFH?=
 =?utf-8?B?Y2Y5STlXTVYza0svSndoZ2tVZGVuditNQUFJU1BiSEgrb2MvUUttTERRZ0lC?=
 =?utf-8?B?U3FMek16VTl2MTlnVy9FTGppcGNwNXFnU1AwdXI5UmMyU2RUQWNhcEpLdkFy?=
 =?utf-8?B?VjJQVldwWDliNmhoMGQ5U2dXeSsrLzlDYXp1TmNjV2pXcFVvNnBicTJSOWo5?=
 =?utf-8?B?RlhINFhqWVZseWpucktESVN1NndRWDdBRWV4VFZJTDcrZTFVUTdEenVydWVT?=
 =?utf-8?B?UEdCZVJ4TG9sT1BNZVd3WERJSFRjL1NXUXlBejBSaWluWElQOVd5MmR3b2lQ?=
 =?utf-8?B?VnAxT3RWVjVUTmVTNHJtdDJCWFY2SE1JN05YMTJjc1hxMERlZFU3M3I5aXVB?=
 =?utf-8?B?UDZqZnM3bFNscHBMQm1GQTFodkNnTjFueWVJUmlQWlN0ZEpLUmZCVFZRSytQ?=
 =?utf-8?B?K3RKNkM3Yyt0Q0RJRXJIY2cybmdnQ3NEMlczTmdKd3NMdzFFcnBNdEJabjhq?=
 =?utf-8?B?SmZjQ2l0eWsrdHJOVG9xbGtBVE00bnM1czBOZHpQYS9iTXRPYzJLeXkwRkY4?=
 =?utf-8?B?K3Z0Y09QeStPeWMzandlbUpncnBjYW5WeUtxbTJYTmxTTTRJL2JQb2IvakZa?=
 =?utf-8?B?TWg5dUlESjV2ZUJ1V245SmloV283SEpocFRFTDl6UUZTZTg3cENGSWJaR1pV?=
 =?utf-8?B?cm9Pa291Q0RJdWVhYXYxNXA1OTFOc2FPWlR4NHlKVy8vSFpOV1NCbHBxUUJ0?=
 =?utf-8?B?bWtxY01BYWI5OEo3NnFHZVRGK1lOTXpudHRyVDBTc1MvbWJJaHhzTmRISndy?=
 =?utf-8?B?cWtFMVAvYzJXbElxRWRYU0RiZ3FON3lpZEJNNFJ0VUw4TEZCTXdXSk0rMEtY?=
 =?utf-8?B?WmVENzhUTXQ1MGRNcFVpRTJURkh5SzR4dWJ3SGNabFpKZ2FvUnRFTUt2UFhI?=
 =?utf-8?B?bjZNNUhSdHZGKzBTSFB2WENrZzJ3akh0dm52TG5Pblc5MGFLMzlEUzZHVkVT?=
 =?utf-8?B?T3NFWFhDNGtHK1l4dFZtSEtXZTlnZTd3NVY0d2k2OUQwTHIreU52RzRsV2RV?=
 =?utf-8?B?eFRsMm9WQjFWT2FHK3hqdGxzaWxYUVFBRFQvMkNaOUpHTEVHVGdnSnRBNVhN?=
 =?utf-8?B?ZWQ1V1Z4dDMzdjhZaitFTGV5NzZVZFJ2Q0tFYWF1MzVEYlFULzdHZHcwSlJL?=
 =?utf-8?B?WVZSMkFaQVg2bGJiZ3pzazM2N3NnazNGNmM0ZzJtemJ0TFZYK0JZb2JDd0tS?=
 =?utf-8?B?S2lqS05pQXZCYkRjZWJNOFk4YS9xRlBxQ25JRi92alF5ejBhRmYwSEUwVWZT?=
 =?utf-8?B?cTBMaTE4ZUZBSEZLY2JnQ2dDN2hUUjVkV0pWZjM5bVZscFEvV2tibG5iUFpJ?=
 =?utf-8?B?MklVVkxHQ2Y2c2laeU5LRE5USEt6NUZndEp2bnpKc0RLZkRrdGVjOC9KSWtI?=
 =?utf-8?B?QnVDYUV1V1dzcXdFY2x2aUhKRktBOXMyQWtiUWhIV0hDNjdtY0JDN0x1WUVn?=
 =?utf-8?B?V0RBMVdzRHBqVi9zcVJ6bUNFUzhZeCtCVDhxdXBlVW5kSzd5THlMa2phdXlS?=
 =?utf-8?B?OGd0YlpnUzkzNlhqZkhMNmZhVFBSdG5rend0d3pLYmZndi9TMG5leUprb2tG?=
 =?utf-8?Q?r17MsUJRqEv9j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFpIOTdwNGR4YkNlcFJ6eTNSWitqMUJLSlh6V3hxdGJKc1Y5blUrUjNVc0Ri?=
 =?utf-8?B?ZnZPWkdPOWdWYVIrRHRkRzdPN3VRaTBCeEZtMldjWGdybVQ1YkpuT3dCTXY5?=
 =?utf-8?B?T3QyeENoVkZNZ0lVRjhsVmp2bG5ZN3NyT0dua1RnV3dJOHBrRUloMk1ZQU00?=
 =?utf-8?B?NkM5K2ZwVjdVaVhFWUovTC9EcExBaURueldTaUI1eDZGNzlJOENBdmVsQ21M?=
 =?utf-8?B?WmcwYVZxcW1lQWx2Y3VVT0dEdERKeWlIU2RFc3dzeUJoQzltY0pCQ1JkaW1Z?=
 =?utf-8?B?ZGtFSFFIekd4SWpsditYK0ttN2hXU3krSWl5VkpvK0JZZmtiWnhPaUo1UjQz?=
 =?utf-8?B?dTVzaG15Q2ZBc1RKRnpnekFzZGFYUHV4SmNXSlFmWElEUEdROEVTaDRDempp?=
 =?utf-8?B?djBraGx5Y2tSazlNN3lteklzWTd4cER3cEl4T0JCVFBSQ0pyd3FHYXdvL0hH?=
 =?utf-8?B?eXo3RFhjS1NvR0Y1MS8xa3EzV1hMS1lSOUE2RzBjV2tSS3NWSVcvRjBjNWVy?=
 =?utf-8?B?NjQxSklXSWhUNVRzWkc0dUIxQnkybmkrU1NTdkpBY3FuTzdERzFpM0RmS3dV?=
 =?utf-8?B?TzJ3WEllVkZsMUxqU3pHTWVud3pUb2RaejdTZXJRZXVVdm92dzBBQmRNaHV0?=
 =?utf-8?B?VmhQOHVUays0a3QrK0lUN3MvM1JaRk83QUlPSEpuZkJxbEFwb1BtcjRXd2dh?=
 =?utf-8?B?VElScHZHZFJsMHZMWFpxQW5OeVJ4S3o2MHltb1NzWjJzclQrUEhlWGdIaEJC?=
 =?utf-8?B?ZHJCVW42bTdzZW5lUWt2akRyVG51Ull4Q2huTlV5enh1cUllSTFKL0tkZU00?=
 =?utf-8?B?SzdwTWJueVNXMlY5eFh6dmhES3N4MnR0NHphc0dYZ24zWENnSHlvakpTamhZ?=
 =?utf-8?B?NEQrbm1YS2dVaktaOE14ZzJtYU93N2x0cS9jeWovdjNWYURtMXNNMUplQmlT?=
 =?utf-8?B?SWpQdC9tWUJpV09jMm5YZE44VFBEL0hjOWY5K0VWU0hINzI2d1hIek5IWkx3?=
 =?utf-8?B?cUlFTHZjTmpEbTUzTWZ2UExVSFBsRk9ZbjM1NjhmOU9KRTRsaXNMWUxNYS8r?=
 =?utf-8?B?V1BuL3dJcGcxUHJGVlNaTHhDLzRscGxOTmhXQW5QVE9Zd2I4OVJmd0tsNk5a?=
 =?utf-8?B?M3BIUy9NT0NJVi81Y1ZWY0tuM0xWTGt0b0owNld2akRSWGtqNkdsby9PNFAz?=
 =?utf-8?B?ZHM2aVU0dllaK0ZYVlg1QTMwQjFuS0V4dDRJdUY1VzErY2U0M1VCK3NzSmpH?=
 =?utf-8?B?Z0NpbkVKVTFCSTFlS0RiZE5nL1RIaDBibkJ3Q1NqVEtpMG9RaGhKSXZRYVY4?=
 =?utf-8?B?TWtLRzlXV055V3N2cU81VmZldDkxWUJMTm9mdnh1RXVYU1ZOcjYreGROczR3?=
 =?utf-8?B?VFh1RktZekQ0bHlFbW9QbUJlNVl2Ty94NVgySmhRNkpWaTlQVXlwbHN4bFha?=
 =?utf-8?B?cjVQdVpKajhPR0p0a2VrQ2RTOU00d1Q1clMwUXdQK1pOcTcvV2dWbWpZNG9P?=
 =?utf-8?B?WmFLU1hLVE5CWkxlRGVMSjFCeFNKanZvVDNCR2p3NU80N2U2ZlFQMGF1TGFK?=
 =?utf-8?B?SkMxdXpGdFc4STN3TFJzL3lpRUpSQmZET2oxYzB5UlBSVFNlR0FUYVhGYWFS?=
 =?utf-8?B?eERaZnpoVHpDa2txbktBNEZPL2xsNXZlbTBaOVUzOVNoQ29yRHVCRUFNVzNR?=
 =?utf-8?B?bXJ3MTZXVmQzUitFcStxaEVDYmhuUHJlM25HRVZMQnovdUZFR0ZRUUIrdXQ0?=
 =?utf-8?B?NFVIVEVra3JPdlVzckthUmRmUXdGdkFER0pHcTlwSjRwU09QclNwSG9lTiti?=
 =?utf-8?B?UUE0VHZES2VuWWhQS2ltZTZ4K01ZcFMvWmJJT0dLYzd5MVF1Y2NyYlNGZHhS?=
 =?utf-8?B?ZjR6Z205eURMT1ZCVHlCQ2lDOUx0dFlmc0hVYXlPZS9aUk82SDZOcm1tbytY?=
 =?utf-8?B?SkVWd1V0RnVuS3p3MzZvSVlhbWpsN3ZTM3FPWDVXNnFaRmZRaERsUGR0eW1t?=
 =?utf-8?B?bVExSVlTQm1Ka1F4Rm5KRC9zNEZZSUFRdEwrZzlQVDdKUGtBNlp4SWZQSTkr?=
 =?utf-8?B?aWQyUThyeUJmOXFqamwvTFFXVDBIQ2xMWkRRSnZ5bTJuemhSM0ErQ2drUzhU?=
 =?utf-8?Q?tLGcM+7Daxy4H0Z+aGQVPDoiQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb27322b-e50f-4d50-6eab-08dd1e9dfd5d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 13:23:26.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQcnavOgmUjYFv8h3mMJCdYM2kKH0utNNCObr9RyaACeMxGVU4lzhLz1gOZwKY2RiQgEC7pwSdCT7QV+77lhGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4921
X-OriginatorOrg: intel.com

On 2024/12/16 16:26, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Saturday, December 14, 2024 5:04 PM
>>
>> On 2024/12/13 20:40, Jason Gunthorpe wrote:
>>> On Fri, Dec 13, 2024 at 07:52:40AM +0000, Tian, Kevin wrote:
>>>
>>>> I'm not sure where that requirement comes from. Does AMD require RID
>>>> and PASID to use the same format when nesting is disabled? If yes, that's
>>>> still a driver burden to handle, not iommufd's...
>>>
>>> Yes, ARM and AMD require this too
>>>
>>> The point of the iommufd enforcement of ALLOC_PAGING is to try to
>>> discourage bad apps - ie apps that only work on Intel. We can check
>>> the rid attach too if it is easy to do
>>
>> I have an easy way to enforce RID attach. It is:
>>
>> If the device is device capable, I would enforce all domains for this
>> device (either RID or PASID) be flagged. The device capable info is static,
>> so no need to add extra lock across the RID and PASID attach paths for the
>> page table format alignment. This has only one drawback. If userspace is
>> not going to use PASID, it still needs to allocated domain with this flag.
>> I think AMD may need to confirm if it is acceptable.
> 
> It's simple but break applications which are not aware of PASID. Ideally
> if the app is not interested in PASID it has no business to query the PASID
> cap and then set the flag accordingly.

yes.

>>
>> @Kevin, I'd like to echo the prior suggestion for nested domain. It looks
>> hard to apply the pasid enforcement on it. So I'd like to limit the
>> ALLOC_PASID flag to paging domains. Also, I doubt if the uapi needs to
>> mandate the RID part to use this flag. It appears to me it can be done
>> iommu drivers. If so, no need to mandate it in uapi. So I'm considering
>> to do below changes to IOMMU_HWPT_ALLOC_PASID. The new definition
>> does not
>> mandate the RID part of devices, and leaves it to vendors. Hence, the
>> iommufd only needs to ensure the paging domains used by PASID should be
>> flagged. e.g. Intel won't fail PASID attach even its RID is using a domain
>> that is not flagged (e.g. nested domain, under the new definition, nested
>> domain does not use this flag). While, AMD would fail it if the RID domain
>> is not using this flag. This has one more benefit, it leaves the
>> flexibility of using pasid or not to user.
>>
>> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
>> index 0e27557fb86b..a1a11041d941 100644
>> --- a/include/uapi/linux/iommufd.h
>> +++ b/include/uapi/linux/iommufd.h
>> @@ -387,19 +387,20 @@ struct iommu_vfio_ioas {
>>     *                                   enforced on device attachment
>>     * @IOMMU_HWPT_FAULT_ID_VALID: The fault_id field of hwpt allocation
>> data is
>>     *                             valid.
>> - * @IOMMU_HWPT_ALLOC_PASID: Requests a domain that can be used
>> with PASID. The
>> - *                          domain can be attached to any PASID on the device.
>> - *                          Any domain attached to the non-PASID part of the
>> - *                          device must also be flagged, otherwise attaching a
>> - *                          PASID will blocked.
>> - *                          If IOMMU does not support PASID it will return
>> - *                          error (-EOPNOTSUPP).
>> + * @IOMMU_HWPT_ALLOC_PAGING_PASID: Requests a paging domain that
>> can be used
>> + *                                 with PASID. The domain can be attached to
>> + *                                 any PASID on the device. Vendors may
>> require
>> + *                                 the non-PASID part of the device use this
>> + *                                 flag as well. If yes, attaching a PASID
>> will
>> + *                                 blocked if non-PASID part is not using it.
>> + *                                 If IOMMU does not support PASID it will
>> + *                                 return error (-EOPNOTSUPP).
>>     */
>>    enum iommufd_hwpt_alloc_flags {
>>    	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
>>    	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
>>    	IOMMU_HWPT_FAULT_ID_VALID = 1 << 2,
>> -	IOMMU_HWPT_ALLOC_PASID = 1 << 3,
>> +	IOMMU_HWPT_ALLOC_PAGING_PASID = 1 << 3,
>>    };
>>
> 
> I'm afraid that doing so adds more confusion as one could easily
> ask why such enforcement is only applied to the paging domain.
> 
> Please note the end result of nesting domain can still meet the
> restriction.
> 
> For ARM/AMD the nesting domain attached to RID cannot set
> ALLOC_PASID so it cannot be attached to PASID later.
> 
> For Intel a nesting domain attached to RID can have the flag
> set or cleared. If the domain is intended to be attached to
> a PASID later, then it must have the ALLOC_PASID set.
> 
> So I don't see a need of exempting the nesting domain here.
> 
> btw what about requiring to acquire &idev->igroup->lock
> in the pasid path? It's not a performance critical path, and
> by holding that lock in both RID/PASID attach, we can check
> idev->pasid_hwpts to decide whether a domain attached to
> RID must have the flag set and vice versa when doing pasid
> attach whether idev->igroup->hwpt already has the flag set.

seems workable although igroup->lock is supposed to protect the attach
of multi-device groups. Here we need to extend it to protect the
idev->pasid_hwpts as well. With this, I think we can apply the enforcement
to nested domains.

-- 
Regards,
Yi Liu

