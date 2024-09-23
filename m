Return-Path: <kvm+bounces-27324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31312983A82
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 01:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B23DE1F2372B
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 23:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14CF13213A;
	Mon, 23 Sep 2024 23:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hq04zQDB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F25127B56;
	Mon, 23 Sep 2024 23:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727135548; cv=fail; b=BfdWvX6qOoBzyvI02XPHCnlcKr/uEkAX5X2fXMJosdSLnJMLIofZGiRQmMigKduJsOOB9dD5uku30ZY2TLnfG4FvHUfq6OJrxYKrrsJYlNEnxoeEMkyAcYB70QBA/Sk3kiPSXMUrpT0fIik3YgXrsWo04fF8J61XOuWhKASwbU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727135548; c=relaxed/simple;
	bh=6oBKRQYgShF+FtwBFk8CaSV/5FI6zTcaJfymmET7hPg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SzJJG28BZkskTuMEDdUsmwTf5Nejt0zsAEpWqdzVBgfOpohmioIPb0RlgrrnNgi4rVTQilnoIzIZgcDfMAMX0a/IHv+vq+cBXVN7gj0afzKgQdE+1Y7/3Q1mCjKlVnnDjMWL5ewXoz8kVkyvrsEV/17H7Me0aPrkt+vTOmV5BC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hq04zQDB; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727135547; x=1758671547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6oBKRQYgShF+FtwBFk8CaSV/5FI6zTcaJfymmET7hPg=;
  b=hq04zQDBqmBJFZvctiTAq7RJ2CnozhSJOZw6fEPN8Xp+P2DhvGJNDvdM
   lzkoDUNuxYIdFe2c5RssQCz+EPJAcXPvu3XR2Bo20pQ35BwIs1Lfzo6bg
   VFbAv8CY60UuNMjikX7nXusvcvh32Fm5jHxLkufULcEl4GqCdc82a42D9
   CgynMUPzN8XI8FCpurQ1XcQNXC6XcJNgS/OfkHedFJ7ds4iI9jAHyUuuV
   ZhMk5iW1P3p3y2pSu4t25ecCWF8uRNYn+yc/nlwVktf9uP5qYVjOL3KWa
   ujQFl8LShhMdvhwFsGNGFB4D/Tsog0jxQZcJyTBs7wrp1LpjYe6VSlRp5
   Q==;
X-CSE-ConnectionGUID: 9w1zyDe2TeyMJvKVuhaRsA==
X-CSE-MsgGUID: iOid2AdTSI2hyZ8X5GI7Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="48638155"
X-IronPort-AV: E=Sophos;i="6.10,252,1719903600"; 
   d="scan'208";a="48638155"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 16:52:26 -0700
X-CSE-ConnectionGUID: +bytD/WxREuzoZLLd8fYZA==
X-CSE-MsgGUID: ide1uqHLQ0um0iOfjw9QaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,252,1719903600"; 
   d="scan'208";a="70824991"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 16:52:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 16:52:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 16:52:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 16:52:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 16:52:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgSG/1ZFfsqIGChbm0azAAdAcHRPDh3RYLGgiLRiytVqwWQtBYoTYZUtqfbu5QzxExI5bVon/AQKkfJa36DeBC1mEhBXhDoDRdeZfu83AfBcyLSz3F5DgbK6NDDU8hClCoveKVarHTGUAQYZjMEQ1yVug18KaCMaCeZqVMUvPHpBCMAHwBFlE49G7McjsfI/VhwG8sHrX63zVVGRgeimpsL+lpm+yI4QGgr+TL0CDgK17FHCkkna/BB1/3GnRt2+HYEhGfIE2yxxweAoQpkXP+CrELe4y5z2/+0QD2mhG/RqfcXxnrTNCS+ab/7EzSSTSz6MsG1ubyZVlKYx1BgU8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oBKRQYgShF+FtwBFk8CaSV/5FI6zTcaJfymmET7hPg=;
 b=DKgh+9uwWY2o55jrCZZpoiL6P1CjooYf2qZSwostxqmVnTd1S8SDoic50psXCgp344Cpfco24mmmmfhWR16D56kqpaYD8XLBmGX59uZwvm/O7MtZ735bUfXpvYrAxnqPdKAdOYNSr/tbADUxxHXu0MDlPkd7CiqXum6D4wicVGmHuikcVQyMeL6xTvrwXdZ+Alr7joFrrvayJLEkFvR5SqJ31QaAorH5ZW2Gqf/0vcJP/jPRUpn3Wj+JLoIlEP9BtdI/u0c9v8aCUqXZXlxhwYvZXo1zL6hU9LCuii0XI7wwqMj8tYQpnq2+eVcPKYMJuzqH+1BNFEbASkm4dtJMhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5821.namprd11.prod.outlook.com (2603:10b6:303:184::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 23:52:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 23:52:19 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, Alexey Kardashevskiy
	<aik@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bJZe9sAgAfcbgCAA67AEIAAE16AgAAbiYCAAINVgIAAgmzw
Date: Mon, 23 Sep 2024 23:52:19 +0000
Message-ID: <BN9PR11MB527605EA6D4DB0C8A4D4AFD78C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com> <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
 <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240923160239.GD9417@nvidia.com>
In-Reply-To: <20240923160239.GD9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5821:EE_
x-ms-office365-filtering-correlation-id: 9697bad0-9f4e-406a-8701-08dcdc2ac2bc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TU94QWZybHFaUnlZdjI0aTVzdTJ6OWtJaTRNSXBUc1VXM21SdURVUWIzcE5q?=
 =?utf-8?B?N1JsNEp6cnRRYm81NGFESjk3YWZQbFFtUFVDQmFxRjBVRGJKdU1qdk5TcmNx?=
 =?utf-8?B?clVuWmpCQm4xVk9TODQvYmhpTFlSN09FM0JmMTdpQ1J4VWt6QTRWZnR3b040?=
 =?utf-8?B?eTNTdStEQTJKT0Fhd1JGTHRQRnVUMEpqTThRdHh5ZGhXM0pZb2lRODFFTVkz?=
 =?utf-8?B?M2I5ZXdWSXdibW0rcDB6SlNRV3ZuWHJjTFFCMEE1K0FDSkROR2s1TDBiTFd5?=
 =?utf-8?B?Y2tQWmtxTTRLL1Q0YTBiczQ3ZnlFODFrZlkwL3hyeHhWMWhvMHk0UDdMaEVX?=
 =?utf-8?B?N0l4QXdpOFZMRVFwa01BOE1JZlc0cU5RNlVmMDA0NSthSVNVTjJFT1hyZU1W?=
 =?utf-8?B?RVN3cXdZTVpibVVvQmpEZVhrTXNUVkhGYWVQYzJyWlZLMHl5YlYvcGl2WWt2?=
 =?utf-8?B?RE8wWklSN1huYUxjcmNsVVFrUlo0Qkh2SWtoV2NQbVhQT2x5TXBvSmRHVXMv?=
 =?utf-8?B?eERCT09LT3d5SlV0ZWRIQ0hKcTRFc25FSjhNR3VuejIzalRKNEpWNSt5Nm5i?=
 =?utf-8?B?dndvZTNTNm01VVBYVXZsWDJuSG9OQzRiMldQaHJHbGpycmE4MzRjczNsTGlQ?=
 =?utf-8?B?WUJSbXBLWnZvU0YwS1czY21sN043ZzlKcXlvNTVUVCtIcFdlY3JpbGp1K0hq?=
 =?utf-8?B?cXo4d2RaVWpKVGN5dXNrWGtGQ2pBeVh3VGgvVmlCdEFpK2tvdEVKNkh4Qi9J?=
 =?utf-8?B?SjNmWG1LQXhOQ29FTWtjb2FTQzl4ZUxKbDVQeDN2S094VXRBOTZQVzhOZG9s?=
 =?utf-8?B?cTBlLzNLbnVwV2hKeVI1K3l0bUg2SUVvWUU5VnBKdVNDcjcrYUY0YXRYOEYy?=
 =?utf-8?B?L2l1UmRoeCtTNXByZWRiU3ZMSzloREZ3ZzdDQ2FCOFJIdDU3Wm5TTzlvSCtW?=
 =?utf-8?B?NHprY2ZoT2JudmkrSFB0Q2tNS2gzRmRROUdVVU1hNXFxU0RWUHU4YVFCWDdW?=
 =?utf-8?B?RVFMdTh0YTFNTTc1UkJuU09xdFRKWVN6bWNhTzIrWFVQY04zeWhHanI0dXMy?=
 =?utf-8?B?UGlrNHJvUXFDV2owTnN5TytXelNCY0VKNUVmaldOZGZlVWdkbjNvTHd1Uk9O?=
 =?utf-8?B?b0FITFpvWmZnZ3UraGpkMmdvaHliazJNRzhnN084N0RNcXI5TG1XbTNyR1hY?=
 =?utf-8?B?ZVdkcElNT1VHQlliQnU5YWdSNENvMXVFc1N4bUNhOWp1UXdvRW9RRVAxaTlI?=
 =?utf-8?B?cmtEekZOWUx6WUt0dk9QMk9JYWluTHFJODB2REdQUWh0MEVpckxGNDI1QkVS?=
 =?utf-8?B?N0QzdmxKemtBZTQ4M0loYzBNeWpFS2F3OFNwVGxra1Vpd1A5ZkZSWFVCM1dC?=
 =?utf-8?B?SExOekNyVW9XRUNkQ0pyWFZaMUdaZklSUkNmZ2ZUQ3dnanFBQWVpRUMvVkR5?=
 =?utf-8?B?ZFhuZGZEeVRoU3RORVJIZGhLYzhiMmQzeis1eTN4eElONXllREgvd1hXUUFi?=
 =?utf-8?B?T2ZPMWkzbDlKTzZUQU9nci96Q2xCK2M5L1RmT0lpWFc3d3FUbUg0cklJbXgw?=
 =?utf-8?B?a2dEdk4wZUZ2U1ZXSTZ1VkswdWZxWHFuU09nOVFDQ2xxdmtvL0xoYXUwcG1E?=
 =?utf-8?B?ekZQVktpSU9jTFh3T1B4RmlsRzZ3eTdtK3VqSEJrbW5EWVdxTXFSUHRGTWYz?=
 =?utf-8?B?eDh0NDlLMitnUVFnOTM0VUxZc1JydjZDUlIvanJKalFObGNVK2Z1VUhkSCtC?=
 =?utf-8?Q?yRJ5gbkXd9pV+6kt68=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjgvVklXYzB5VVhVelJRMk96T2Fadk92YnBYQWIxajZsTzBiNXNTRVRQS1ZZ?=
 =?utf-8?B?T1N3aUpoQWRRbm55a3N2UThuVzJGK2VkaGlobU1wOGNxYmVJc3hCUUxWcHkx?=
 =?utf-8?B?WjBDWGkrRXI4bVlDUU1zTnlqeCs1SFVxdFJmZEswSDBRVE93VDQrQ1NQaGdv?=
 =?utf-8?B?ZitCT0NsYThNUU9SNkdwa0p2YWNPK3R0UXkzYVB4enNyWHN6UmNXYXM3Nmpv?=
 =?utf-8?B?enNWK1hXWFc0czZuaks2WXdMVHNna3B5OStaNnNnb1J4bjNpdHVxZVJYc0xC?=
 =?utf-8?B?ano3SVpFUXp4RmFTRUJyaW5rcTNUWFJiTWlJSS9ZMElBLy84Y1NaVzdTQXBV?=
 =?utf-8?B?SFlZZU5SUy9KbmdDVElKUDgyOVdUYVBUQ2g5OG1yaU5UdmVQaGxONGNLQVJD?=
 =?utf-8?B?MVFvbU9IcGNKTmtNeWQvRGNWdFBpYXpVUXFYK3cwREdTOVJ4aVNOcnVhb2Ft?=
 =?utf-8?B?SGptLytYb2JDdmcvN0laLzZTanRWdzdLUDVFVy9scW0ySEphcjJuMi9JN3B0?=
 =?utf-8?B?ek0wMXBBb2NIVGE0SnFTaEpjSU9GZkVXZ2VaVEoyOEppK2taV2x0RE5BOFpW?=
 =?utf-8?B?dGNYUk5laFN4cTF1bWY5S2pJekxOSGJmZjNJek1XUE9ZdGhtTmNLTmQweSsw?=
 =?utf-8?B?aFJXbXk3eGRMUVJHV0hrK2Q3M3o4K3ZmMVZnMUM1RU1jZDJuL1hlQkhBbEJU?=
 =?utf-8?B?NWRtWSt2eGpzMmVDRTFiVFV0cDU5OTNmR0EyMFlqUWlaSUp5UnJXTGZOSUpH?=
 =?utf-8?B?NjJ6NldXTjRXZ0t5RjNpTmFHc0l3VEFKT2hDdmtLdjJYeXE5ODJJOW0zWmYv?=
 =?utf-8?B?bVY3Wmg2SlJ3K216eUtvYlNKSkhMTTlBd1pWak9RREx0bU11Qi9PUlkrSUQ1?=
 =?utf-8?B?aWtSYkpCMnR3T3gwbWw0em8wMXFaNFhJb2dibC9XRGwwOTJMb3FJNnNDWmxz?=
 =?utf-8?B?UHlXTFRYTUQyb2FWR2lnT1dsMVMxcXJ5OFAzdC9SZEh0U2RwU29wdU5oRjMz?=
 =?utf-8?B?bnlxWlBsWWc1SG5UREVzZ2tJdmpybXRXL2YzQUdTT3Z4MlZRTDMycXlNUTUx?=
 =?utf-8?B?ejFoZ3JGZTBaSENqYmc0VmRkUXlrckxUaUIzSkZabktZUFFRWllGZ3NpckIz?=
 =?utf-8?B?d25ySFRJazNGR2ZQaXg4STBWVjg5Q2tlUWlDYXJqcXRvL1JqVzBIWi9tWElV?=
 =?utf-8?B?bE1VYTRGZE1xd2d5WU5yOU1KbHkyeWJ4UHE5OWc4RkxlUlUwUlhrT2Q1cVlG?=
 =?utf-8?B?TGFYZmQ2blF4c0poRnkyS1ZjYUViREpPREEzcnJjemRoMXgvaWNFSThRWFFt?=
 =?utf-8?B?YjRpcGdrTmhacDA2NElFcXlQbjI3UGRBb0pTcWc4b3VJZFNxY24vM0wzcCsv?=
 =?utf-8?B?bGJpcGsvdU9ZS25VdmhQSzRFTmM5eVdva1ByUjc2NWNvSENaUzAvWVdnV2NN?=
 =?utf-8?B?Q1B3Qmh6SE9KVzRjT1pzMHZwcFhBenNKVU5IQXl3T1Vocjdmb2h5cEtKTXNw?=
 =?utf-8?B?ZzQwMmUzSklROTF4Nk1BZVRLTTFVUkVGNFFOZkZ3c0dub2ZTTFBLK2k2R3g5?=
 =?utf-8?B?T25EeUt2b1d2Q0JLT3J1bEt5Mm9kSzJhZ3h2elkyVm92TGtmczVNRkFXK0xR?=
 =?utf-8?B?RU5MbjZNUUZDZ3hpeWRVbDdOeDFoSThIdFpQUHF0cnRsU2hYWXcwVFdRR1Z6?=
 =?utf-8?B?K1diZkFxMnV2ai9Vb3hkS0ZPd0d3QWRiZXRjc1RiSGw1cWNKZGw0WHVydHlP?=
 =?utf-8?B?OHY5VEhqSVhxcVR3d29JMlNwckpWdWtZbjgvWVRxYVQ1SWwyVlh0Wm1DeEhq?=
 =?utf-8?B?YnJlekVJaHJDQlYxdkpFMzg3K1hXaEJReTBYUVMvVzlTU2I0T0IyWWdWdldh?=
 =?utf-8?B?cWJZTXRJTERGNDhTZWl1N3B4a3RNUnNYeTJDYnpPT3E5M2lsRFA3YmdqTjBk?=
 =?utf-8?B?dVJlZ3Y5K1BuVG4wUi9JRTh5WUU1b0NpZDU1TEdVRUh4UHl2S1pmc01BZGQ0?=
 =?utf-8?B?bXU4RFA3YnJGb0I2YzEwSTVzczNKVjFiN0Jici9ZSHRNbjVxdUt6TVhGTTBD?=
 =?utf-8?B?QysvdW9iUy92c2NDQm5mbGhDWkkvYWtFaUVZdC94Ty83UUd0MjRFczIzazBL?=
 =?utf-8?Q?seDZfIlIHZKzPSiKJ4vF0aE90?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9697bad0-9f4e-406a-8701-08dcdc2ac2bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 23:52:19.3560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPu+SNvMNMH/tqc6wnuSSl3+BTCkmI5hx3le6HDc6Oi3JdNxogtoTwdS7JYkxyceWMRHG0HLCLEHwr/MZHw+Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5821
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBTZXB0ZW1iZXIgMjQsIDIwMjQgMTI6MDMgQU0NCj4gDQo+IE9uIE1vbiwgU2VwIDIzLCAyMDI0
IGF0IDA4OjI0OjQwQU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogVmlz
aGFsIEFubmFwdXJ2ZSA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPg0KPiA+ID4gU2VudDogTW9uZGF5
LCBTZXB0ZW1iZXIgMjMsIDIwMjQgMjozNCBQTQ0KPiA+ID4NCj4gPiA+IE9uIE1vbiwgU2VwIDIz
LCAyMDI0IGF0IDc6MzbigK9BTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+
IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IFZpc2hhbCBBbm5hcHVydmUgPHZhbm5h
cHVydmVAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gPiBTZW50OiBTYXR1cmRheSwgU2VwdGVtYmVyIDIx
LCAyMDI0IDU6MTEgQU0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE9uIFN1biwgU2VwIDE1LCAyMDI0
IGF0IDExOjA44oCvUE0gSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+IHdy
b3RlOg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IE9uIEZyaSwgQXVnIDIzLCAyMDI0IGF0IDEx
OjIxOjI2UE0gKzEwMDAsIEFsZXhleSBLYXJkYXNoZXZza2l5DQo+IHdyb3RlOg0KPiA+ID4gPiA+
ID4gPiBJT01NVUZEIGNhbGxzIGdldF91c2VyX3BhZ2VzKCkgZm9yIGV2ZXJ5IG1hcHBpbmcgd2hp
Y2ggd2lsbA0KPiA+ID4gYWxsb2NhdGUNCj4gPiA+ID4gPiA+ID4gc2hhcmVkIG1lbW9yeSBpbnN0
ZWFkIG9mIHVzaW5nIHByaXZhdGUgbWVtb3J5IG1hbmFnZWQgYnkgdGhlDQo+ID4gPiBLVk0NCj4g
PiA+ID4gPiBhbmQNCj4gPiA+ID4gPiA+ID4gTUVNRkQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gUGxlYXNlIGNoZWNrIHRoaXMgc2VyaWVzLCBpdCBpcyBtdWNoIG1vcmUgaG93IEkgd291bGQg
ZXhwZWN0IHRoaXMgdG8NCj4gPiA+ID4gPiA+IHdvcmsuIFVzZSB0aGUgZ3Vlc3QgbWVtZmQgZGly
ZWN0bHkgYW5kIGZvcmdldCBhYm91dCBrdm0gaW4gdGhlDQo+ID4gPiBpb21tdWZkDQo+ID4gPiA+
ID4gY29kZToNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9yLzE3MjYzMTkxNTgtMjgzMDc0LTEtZ2l0LXNlbmQtZW1haWwtDQo+ID4gPiA+ID4gc3RldmVu
LnNpc3RhcmVAb3JhY2xlLmNvbQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEkgd291bGQgaW1h
Z2luZSB5b3UnZCBkZXRlY3QgdGhlIGd1ZXN0IG1lbWZkIHdoZW4gYWNjZXB0aW5nIHRoZQ0KPiBG
RA0KPiA+ID4gYW5kDQo+ID4gPiA+ID4gPiB0aGVuIGhhdmluZyBzb21lIGRpZmZlcmVudCBwYXRo
IGluIHRoZSBwaW5uaW5nIGxvZ2ljIHRvIHBpbiBhbmQgZ2V0DQo+ID4gPiA+ID4gPiB0aGUgcGh5
c2ljYWwgcmFuZ2VzIG91dC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEFjY29yZGluZyB0byB0aGUg
ZGlzY3Vzc2lvbiBhdCBLVk0gbWljcm9jb25mZXJlbmNlIGFyb3VuZA0KPiBodWdlcGFnZQ0KPiA+
ID4gPiA+IHN1cHBvcnQgZm9yIGd1ZXN0X21lbWZkIFsxXSwgaXQncyBpbXBlcmF0aXZlIHRoYXQg
Z3Vlc3QgcHJpdmF0ZQ0KPiBtZW1vcnkNCj4gPiA+ID4gPiBpcyBub3QgbG9uZyB0ZXJtIHBpbm5l
ZC4gSWRlYWwgd2F5IHRvIGltcGxlbWVudCB0aGlzIGludGVncmF0aW9uDQo+IHdvdWxkDQo+ID4g
PiA+ID4gYmUgdG8gc3VwcG9ydCBhIG5vdGlmaWVyIHRoYXQgY2FuIGJlIGludm9rZWQgYnkgZ3Vl
c3RfbWVtZmQgd2hlbg0KPiA+ID4gPiA+IG1lbW9yeSByYW5nZXMgZ2V0IHRydW5jYXRlZCBzbyB0
aGF0IElPTU1VIGNhbiB1bm1hcCB0aGUNCj4gPiA+IGNvcnJlc3BvbmRpbmcNCj4gPiA+ID4gPiBy
YW5nZXMuIFN1Y2ggYSBub3RpZmllciBzaG91bGQgYWxzbyBnZXQgY2FsbGVkIGR1cmluZyBtZW1v
cnkNCj4gPiA+ID4gPiBjb252ZXJzaW9uLCBpdCB3b3VsZCBiZSBpbnRlcmVzdGluZyB0byBkaXNj
dXNzIGhvdyBjb252ZXJzaW9uIGZsb3cNCj4gPiA+ID4gPiB3b3VsZCB3b3JrIGluIHRoaXMgY2Fz
ZS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFsxXSBodHRwczovL2xwYy5ldmVudHMvZXZlbnQvMTgv
Y29udHJpYnV0aW9ucy8xNzY0LyAoY2hlY2tvdXQgdGhlDQo+ID4gPiA+ID4gc2xpZGUgMTIgZnJv
bSBhdHRhY2hlZCBwcmVzZW50YXRpb24pDQo+ID4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gTW9z
dCBkZXZpY2VzIGRvbid0IHN1cHBvcnQgSS9PIHBhZ2UgZmF1bHQgaGVuY2UgY2FuIG9ubHkgRE1B
IHRvIGxvbmcNCj4gPiA+ID4gdGVybSBwaW5uZWQgYnVmZmVycy4gVGhlIG5vdGlmaWVyIG1pZ2h0
IGJlIGhlbHBmdWwgZm9yIGluLWtlcm5lbA0KPiBjb252ZXJzaW9uDQo+ID4gPiA+IGJ1dCBhcyBh
IGJhc2ljIHJlcXVpcmVtZW50IHRoZXJlIG5lZWRzIGEgd2F5IGZvciBJT01NVUZEIHRvIGNhbGwg
aW50bw0KPiA+ID4gPiBndWVzdCBtZW1mZCB0byByZXF1ZXN0IGxvbmcgdGVybSBwaW5uaW5nIGZv
ciBhIGdpdmVuIHJhbmdlLiBUaGF0IGlzDQo+ID4gPiA+IGhvdyBJIGludGVycHJldGVkICJkaWZm
ZXJlbnQgcGF0aCIgaW4gSmFzb24ncyBjb21tZW50Lg0KPiA+ID4NCj4gPiA+IFBvbGljeSB0aGF0
IGlzIGJlaW5nIGFpbWVkIGhlcmU6DQo+ID4gPiAxKSBndWVzdF9tZW1mZCB3aWxsIHBpbiB0aGUg
cGFnZXMgYmFja2luZyBndWVzdCBtZW1vcnkgZm9yIGFsbCB1c2Vycy4NCj4gPiA+IDIpIGt2bV9n
bWVtX2dldF9wZm4gdXNlcnMgd2lsbCBnZXQgYSBsb2NrZWQgZm9saW8gd2l0aCBlbGV2YXRlZA0K
PiA+ID4gcmVmY291bnQgd2hlbiBhc2tpbmcgZm9yIHRoZSBwZm4vcGFnZSBmcm9tIGd1ZXN0X21l
bWZkLiBVc2VycyB3aWxsDQo+ID4gPiBkcm9wIHRoZSByZWZjb3VudCBhbmQgcmVsZWFzZSB0aGUg
Zm9saW8gbG9jayB3aGVuIHRoZXkgYXJlIGRvbmUNCj4gPiA+IHVzaW5nL2luc3RhbGxpbmcgKGUu
Zy4gaW4gS1ZNIEVQVC9JT01NVSBQVCBlbnRyaWVzKSBpdC4gVGhpcyBmb2xpbw0KPiA+ID4gbG9j
ayBpcyBzdXBwb3NlZCB0byBiZSBoZWxkIGZvciBzaG9ydCBkdXJhdGlvbnMuDQo+ID4gPiAzKSBV
c2VycyBjYW4gYXNzdW1lIHRoZSBwZm4gaXMgYXJvdW5kIHVudGlsIHRoZXkgYXJlIG5vdGlmaWVk
IGJ5DQo+ID4gPiBndWVzdF9tZW1mZCBvbiB0cnVuY2F0aW9uIG9yIG1lbW9yeSBjb252ZXJzaW9u
Lg0KPiA+ID4NCj4gPiA+IFN0ZXAgMyBhYm92ZSBpcyBhbHJlYWR5IGZvbGxvd2VkIGJ5IEtWTSBF
UFQgc2V0dXAgbG9naWMgZm9yIENvQ28gVk1zLg0KPiA+ID4gVERYIFZNcyBlc3BlY2lhbGx5IG5l
ZWQgdG8gaGF2ZSBzZWN1cmUgRVBUIGVudHJpZXMgYWx3YXlzIG1hcHBlZA0KPiAob25jZQ0KPiA+
ID4gZmF1bHRlZC1pbikgd2hpbGUgdGhlIGd1ZXN0IG1lbW9yeSByYW5nZXMgYXJlIHByaXZhdGUu
DQo+ID4NCj4gPiAnZmF1bHRlZC1pbicgZG9lc24ndCB3b3JrIGZvciBkZXZpY2UgRE1BcyAody9v
IElPUEYpLg0KPiA+DQo+ID4gYW5kIGFib3ZlIGlzIGJhc2VkIG9uIHRoZSBhc3N1bXB0aW9uIHRo
YXQgQ29DbyBWTSB3aWxsIGFsd2F5cw0KPiA+IG1hcC9waW4gdGhlIHByaXZhdGUgbWVtb3J5IHBh
Z2VzIHVudGlsIGEgY29udmVyc2lvbiBoYXBwZW5zLg0KPiA+DQo+ID4gQ29udmVyc2lvbiBpcyBp
bml0aWF0ZWQgYnkgdGhlIGd1ZXN0IHNvIGlkZWFsbHkgdGhlIGd1ZXN0IGlzIHJlc3BvbnNpYmxl
DQo+ID4gZm9yIG5vdCBsZWF2aW5nIGFueSBpbi1mbHkgRE1BcyB0byB0aGUgcGFnZSB3aGljaCBp
cyBiZWluZyBjb252ZXJ0ZWQuDQo+ID4gRnJvbSB0aGlzIGFuZ2xlIGl0IGlzIGZpbmUgZm9yIElP
TU1VRkQgdG8gcmVjZWl2ZSBhIG5vdGlmaWNhdGlvbiBmcm9tDQo+ID4gZ3Vlc3QgbWVtZmQgd2hl
biBzdWNoIGEgY29udmVyc2lvbiBoYXBwZW5zLg0KPiANCj4gUmlnaHQsIEkgdGhpbmsgdGhlIGV4
cGVjdGF0aW9uIGlzIGlmIGEgZ3Vlc3QgaGFzIGFjdGl2ZSBETUEgb24gYSBwYWdlDQo+IGl0IGlz
IGNoYW5naW5nIGJldHdlZW4gc2hhcmVkL3ByaXZhdGUgdGhlcmUgaXMgbm8gZXhwZWN0YXRpb24g
dGhhdCB0aGUNCj4gRE1BIHdpbGwgc3VjY2VlZC4gU28gd2UgZG9uJ3QgbmVlZCBwYWdlIGZhdWx0
LCB3ZSBqdXN0IG5lZWQgdG8gYWxsb3cNCj4gaXQgdG8gc2FmZWx5IGZhaWwuDQo+IA0KPiBJTUhP
IHdlIHNob3VsZCB0cnkgdG8gZG8gYXMgYmVzdCB3ZSBjYW4gaGVyZSwgYW5kIHRoZSBpZGVhbCBp
bnRlcmZhY2UNCj4gd291bGQgYmUgYSBub3RpZmllciB0byBzd2l0Y2ggdGhlIHNoYXJlZC9wcml2
YXRlIHBhZ2VzIGluIHNvbWUgcG9ydGlvbg0KPiBvZiB0aGUgZ3Vlc3RtZW1mZC4gV2l0aCB0aGUg
aWRlYSB0aGF0IGlvbW11ZmQgY291bGQgcGVyaGFwcyBkbyBpdA0KPiBhdG9taWNhbGx5Lg0KPiAN
Cg0KeWVzIGF0b21pYyByZXBsYWNlbWVudCBpcyBuZWNlc3NhcnkgaGVyZSwgYXMgdGhlcmUgbWln
aHQgYmUgaW4tZmx5DQpETUFzIHRvIHBhZ2VzIGFkamFjZW50IHRvIHRoZSBvbmUgYmVpbmcgY29u
dmVydGVkIGluIHRoZSBzYW1lDQoxRyBodW5rLiBVbm1hcC9yZW1hcCBjb3VsZCBwb3RlbnRpYWxs
eSBicmVhayBpdC4NCg==

