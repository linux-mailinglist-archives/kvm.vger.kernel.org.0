Return-Path: <kvm+bounces-15612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 688CD8ADE6F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FB36284443
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 07:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E67A47A74;
	Tue, 23 Apr 2024 07:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdEGbw5/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05246557
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 07:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713858212; cv=fail; b=Oy7+OgsUgF+x9I/Qm3smAtsKsEhnVPXn7q9H4pv3SeH+aAEcfpF563Ui+xUVJkj2FPfp5FaY7umbPjOa5j6isyD4JshINfGzWMvd1ECT8YpvanhvFXqBTAvH026lxR7R9XvupJ+mv0jJsfXMukEaYmJr57EMnAU75GCBLaX7tkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713858212; c=relaxed/simple;
	bh=QDRyyz8EVWaII5s270w//iTxhmqKgbQqOrmeUgcljEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VN/2D5rX3sicXFnSjWwkrTxYAWTEcNWbN2DQROFrzVEnKtPLtgGIKgFU2Nnr/7xXwyihI5vHsVTUvyv6qanrkYZlFXWt4wb5oqQjkwNAZqsQyScjPoKdFPRG7pCI7V19pCUXOvcIiXhwYwGdU0xS+jP+9HZ1M02fhO1G1Se24P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdEGbw5/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713858211; x=1745394211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QDRyyz8EVWaII5s270w//iTxhmqKgbQqOrmeUgcljEc=;
  b=cdEGbw5/jb2IDfY/KWEDUCORFVFNSKhZk0xtDmu6tg6ejjmoanGo4lvB
   0m+1GiPFcFUVmt3V98ZVjmVBMl+jPrKixQMOOXoI7BcMlWFyws+SMIm6w
   +2D7RRXHqzD9QW184Ya+h/eKrdKZ8CxLX1K/PbOOMGZ47yrN3gTGmc5kI
   l57AqqxO5Sz++6L7nXGy8n8HU+DXNaTgoSdg0LTIXZkDRvL8wQjxCLpBm
   aJ3LRL63K7IfyPTc+0A7DevpW7l38OhpLz9bI5xPn8av5KaUmHeILHj6H
   nL7G0QXFWbPXf4MRaeQ499aUTmGD5sQq5bQmlIle0jxjWgsBdrzyJo2ho
   g==;
X-CSE-ConnectionGUID: jxgxwbtvSh+rqkMfd0ZNZw==
X-CSE-MsgGUID: uJvqMmhPSjaw6lM1Dd4KZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="12362012"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="12362012"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 00:43:30 -0700
X-CSE-ConnectionGUID: wJFXCMKlQvOxlmAQbajy9A==
X-CSE-MsgGUID: bOy6pIeATm+jFutX41ahVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="28735861"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 00:43:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 00:43:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 00:43:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 00:43:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS0o+cBgbTe+iTNCcJStMJ7fX87e2Ws2KKdVcnU0FJmwJ6xSsE0HReUhI2k7dgnzos9Ukmfx3p0xNZju1rTcpp1H/PbqGJiKYeHwuu2Dr5+FM0BRFrWFtjqLgycg7+Fa95/fOYUpiiDEMUNCiFYFepIeTcmO2VNVRjcXmiXgkZFHRQbF/2PK2LdPt87L70W+Q4MfSxo8b8lOuCKRt6d9A9u1mVWd5ZbOifF1/2JhWHwMzQhdqYPKoB11FvpwNDuqMuHHrti4zvQKDgVPe+Jo5+5z5bEvtKFPfrhYSzuRT6Wbir1GmNeDVgIXyvgcaNRqsKlM4H3c0lICw6xgmFVqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDRyyz8EVWaII5s270w//iTxhmqKgbQqOrmeUgcljEc=;
 b=jvOhaLZ8EqZhdrQIb2+S8jfHPd20b4r5knBuQjprR7ONMQkjEC0BllW36pbODj76JW1GH/VNg+EiWdCIJv8fxIQxot4Y8rFrIZcY2y6WV+PWh0EmeN6CvloFwo0qAwH/1AifTrtPCCvOtDojiD9e0aHLOw7lBD6Ab85Z2Hct0ZHOwmj8/fij7NNXJN0Kl0VT+ECpkGFh4JQe85RLNgxScDwOJQ40SuHCeG9pK2P+q+pvs+kGOKT76Pk0EeN2SEKI8lLCyV1tviFmII43leq5E9uEn4s22ppuxaL+OkFu6+xwE369xsEoL+z+GK8BwxSCUyce2O8cjcpCCnI5n9XJdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7065.namprd11.prod.outlook.com (2603:10b6:806:298::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.19; Tue, 23 Apr
 2024 07:43:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 07:43:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eA=
Date: Tue, 23 Apr 2024 07:43:27 +0000
Message-ID: <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
	<20240417170216.1db4334a.alex.williamson@redhat.com>
	<BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
	<20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
In-Reply-To: <20240419103550.71b6a616.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7065:EE_
x-ms-office365-filtering-correlation-id: a14f045e-6abd-42d8-a2d3-08dc6369105c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WVFYUTJxeDcvMmRuQ1RlclZsTGR0YUJ1VUQ3dkpEaEdFMFk0cHpkSUlpZE5r?=
 =?utf-8?B?SDJsZWpJMG53RHNQdlY1TFlZakt6K2RRSmdDSDNvM2NnR0ZmT00wUTZkTy9V?=
 =?utf-8?B?c0JrVEoxeVpRRFdpNEhXQUgrMnp2SHVlYlpCdE5QeWluVnR1NzhHQkMvQVUy?=
 =?utf-8?B?VWw5Z0lsd1kxWlhZUzUzNFhZMVpUMWtySXVRaWh0aGlvc1ZzNDl3RitBVmha?=
 =?utf-8?B?UzlOUC9sWXJvN0tvVHE3ems3L09YMWx4NWk4cWIwRCtVaGdhV1Zpd2dSZEhx?=
 =?utf-8?B?UEpxOXZGcjNaeTYwNE13bngyS0pKWTVjZm9TcHgyMllzMkNZdzBpQzhLbG95?=
 =?utf-8?B?cVhZN09rZHo0WmdvdTZWOE9nY2RlSnE2L1dhTUo5OHdER1NLd1lSdHdWMWh4?=
 =?utf-8?B?VjhyZEpkV292bjJQTFRUU1lwVC9xREF1TzdZWS8vL3NrSjBtM0JSSi9FVDRi?=
 =?utf-8?B?azZEcU5FQ0NQcmtmTTdHVi83YTVwSW9hdzVRK3Y0VXdSNXFtYVhuRUZyTG1Y?=
 =?utf-8?B?M2htSWZBU0pldVpHcGFyZ01VNXRyRE50bk1USVNydDU2MENETFM2YzRjNCtE?=
 =?utf-8?B?WTZEejE4eDNSVWEvOE1LT1ZBdW03aTd1eXNpOHlOSGtwN2xNSFlGNXkrcXpy?=
 =?utf-8?B?Z3dlMHRGd0JVVElqNEpZWGw3c3VSNHhFL3I4T3JNMkJBUUtUelFBSVdIVWpM?=
 =?utf-8?B?NUJYMi9lMGdHZ3ROZStXSzBVeGtEZk1Tb09SeFZNd2NrTXFyLzE1VDUxOUlW?=
 =?utf-8?B?bGk4aFNZSzFGbkNnQ0NVVHk4UGtDU1B2SmFHT1QxWHh5MnlNZmw0Nm1MKzFl?=
 =?utf-8?B?azFGWmYrd1pFK0E5MlBwNm9qUmNWMy9HRU1sNi91Y3V6cjhGNG9scW04UHpH?=
 =?utf-8?B?RVA4VlBrVFh2d0w1cCtRS01POWFzL0V6Z05CblJUbC9OWnlaSXAyQ3NkanRl?=
 =?utf-8?B?Y2FVU2U4R3BNYWdSa1N0bVZIS3lPdEVFTzZBQ2RNZ2xqNHovcEorTWtaa3pK?=
 =?utf-8?B?MU9weURlTXFmU0xVYTU4T2JVYTNRY1d0MkFrNUxJdDErc3p1R0ZITnhxUVUw?=
 =?utf-8?B?c2FaSGY0cVFQZkhXRk1WWTlmalFxd3o1dVB2aStVQWx2cVA0VTBOZ3RXUGE0?=
 =?utf-8?B?aFlBK2JrRVhIeWwzUDlwQUd1U0VXSnFHanFGOHhQeFJqREZxbW4raEVjQS90?=
 =?utf-8?B?VWV1RWpqTDZOcGQ4Q0JSVStLcjJCb0RibHVEYzhndG1GWGlHS05JQkxqVnh5?=
 =?utf-8?B?U0w5UVdYVWx0NFYrVEtadlNncFg1L3BWY2cyM1dmR2hpZ3pKdWlaSUtmWUhk?=
 =?utf-8?B?VWZvRDdjcS9iRzlyMjZ4N1gvOXlDV08veUdzb2J2UTlLckxvNittZG43Z2N5?=
 =?utf-8?B?Q2xnbEc0NjVtUEFsRVlZcFpUNVE3QzdrNEdRU1p4VTJSL3F2d2JBU0pLbG9z?=
 =?utf-8?B?V29kNGlHY1djVTR6OW1lSUpGVSsyWnZRZ01Wbk5IRU9NM1hubTN2V29IQ2RX?=
 =?utf-8?B?Z3dxZFh6RldxdVpvVndDc1l0Z0xoZHFjbHB3S2ZPT2FOQUFZWjlQL1gzckFQ?=
 =?utf-8?B?KzNPaEVDeVJPQ1ZqQ3hMUTJXT0M0SHVaZDZPZXFDRjF2Ykx6MlhHYjRlQ2Rt?=
 =?utf-8?B?WFY0WGt3SUpLQ3BYOW9JMkZmblB5TmNMZXdyLzFzS25mSHI1YkJtSnRWeVVG?=
 =?utf-8?B?ZGFUVk9iSDlRZ3o0SDlVV2FZa09FM3VzejZzczZTTjNBc2VOV0VmcGJET2Nr?=
 =?utf-8?B?bVZGU3RjaWo4dW1DL2w5K1VuMnFEMzdaU0RTQXdteWlreU9peVFQdjgwSjdw?=
 =?utf-8?B?M2k3RTc4K0tvNDNhTGZqdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVhYSUFyYVpSelVoUFYvR1owYjdtQUpucXJ4TEtvbExmaUlBZTlrN0Nrbkxn?=
 =?utf-8?B?emhOdTU2ZzJYdTl3SzQwUkxpQlBEZUNGWkY5VGtiU0puQk5OOTdKQ3dhb2Jt?=
 =?utf-8?B?QmF5eDVWWnRpTTY3MlBtcnRjZnlhZVFjWXppL21BZzh1MEdPUG95UG91NGNj?=
 =?utf-8?B?cHBhRGt0bW5hRjRMSGRHcWhmMmNCK0xCdkEzVnJRWnE2WWhkdXYzc256cDRn?=
 =?utf-8?B?Z3dVbG1HMUQyK2R3NWZXejVwRHdqV2hIYXNQZmNKakEvTitTOVVWRThOY1NX?=
 =?utf-8?B?Zkt4WVJXaDhCSkxLMEl2dUdKSTRSR2w4bGYvRDltVDk4MnNlbG1VT245SGZS?=
 =?utf-8?B?YTVuOWFnSDFlSk04UHhvQWRLTmhwdzdDYVBHUWFqSWNnWGdmNUNWV0VIb2tS?=
 =?utf-8?B?K2dObUxGamw1MGlHbzlibHdSYlRVTWFFVzlUMDRyNms3MHNNVnR5NEs2V01R?=
 =?utf-8?B?N2Jydko4R053cS8zZk0yNTBEU0tGeHVjWlcwbjVEYmhWV0xIVU9idTRGZVVJ?=
 =?utf-8?B?ek13QzdRTTE1dldGSWpuUnJEamVqeEFmSUpkRHBnczNIekhvMk0wR0JNMjg2?=
 =?utf-8?B?ajVCQWIwcE45M3UySGJsVTlCRGtaV1UrcmZtSVo4d09MVzl0dVhMcnByMVhs?=
 =?utf-8?B?ZG56RkFYRFVIQUtrU2l4cUtpdDRuZ2g0MFpNaGt4Rjg1QnJwdmZPb3FiUDcy?=
 =?utf-8?B?am55anpLd0wzWEQ2anlIVWI1eEF3aGxreFQzS1RzWlRNUDRyWlJHN1VUSDJF?=
 =?utf-8?B?RldSanljOWd4NGxnazlSVC84RGQ3Uy9ieldsaXJIU3RzVlJGQzBVT1pZT1gx?=
 =?utf-8?B?U1dDY21URnNrZk5MenVmK1NId0dscmFIWVZNL1psMGExRlhnR3pLN1J3R3Bp?=
 =?utf-8?B?MHZJU2hDcWF4RkhMenhORVJ2MXh0d0hwb3BIYXBQWmZpWTF4WW15T2s3U084?=
 =?utf-8?B?VVRlbVVFNHA4UENrS2d5MXZYZGpub1ZXTVRzeXBvL1RwSThVcmE3OFpUanlN?=
 =?utf-8?B?R01OU0JnbjZvY1RRS09hVmt5cFZJeWlTT2xmQm50b3FaNGR2VWRnSjZnVW03?=
 =?utf-8?B?ZS9mS1hLVVBHNnl4ZldCQVdPbGVIaTBQY1JxSzFDZ2FLMGVJOWlNT2ZXVWE3?=
 =?utf-8?B?K21oVWlWWENSNDVMd0hnK0k2UzFYOThZbG9RbVdzcHlqaExvSTFvcTF1OGVn?=
 =?utf-8?B?amlRMEV1dlcyR3JjVmtpTUtvMmpKblF4SjJJb05Hd2VSck1aU01VbFVoWER2?=
 =?utf-8?B?aUtyNGVvdENBbzBhQ3NNMHRQRk1ZV0dGbGM5VjdkbEdOUlRDYU41UkpZMWox?=
 =?utf-8?B?R1BWL3NFVXlIL3VSS0g0RzNuZU1HbTNmRUdFWU1UNVFjS0o3cXJuUERNVndS?=
 =?utf-8?B?eDVEQTU5cUZaVXYwczF5VkhXZVV3TTBEaGdJaWpZUDVwSkw0ZFZmZnRvQnI4?=
 =?utf-8?B?Z1hhc3FxWXVNYmNDZ0NnY3JhYVdYY01kcUhDMmQ4bWhHNWs2bzBqSCsxMWJq?=
 =?utf-8?B?VDB0N2hFcHRpdk0vYzNmMjZqODVoM1BBWEJJYmFETUhyNHJFdnczdk4rdE5W?=
 =?utf-8?B?U2xQYzNNYzBlajNHRURBdE8wcXFNSHllZ1BySkd2YkorbEdTaXExTlJLTmFS?=
 =?utf-8?B?QnpLSWFmWCtzVU4ydVNiV3NLcnFQeTIxN2V5c0U1NzlGRVdxMnRaWUphVHI4?=
 =?utf-8?B?cTVIV29DTkpld3lMOGxMbi9DK2VYcGNQMjBVbWlnNUltYnozaVVqdy9Ca3Fj?=
 =?utf-8?B?RlVJOW9FcUN1d2ZlK3B1bk0wdlJqWm5FcUhEOFVCM0dtbXQyMm1NSXUxY2Qx?=
 =?utf-8?B?YWVaL3NqV1FLdm1tanB5Q3g5L1VpSDJ2TGdLZjkwTTJ3SW1vK0FBZCtvcGJo?=
 =?utf-8?B?WWc2S1BFdThyN0pHWW1Ba1I5QU0vMjJvL0w0Lzh6Y2RwM0xhcUNRQ2hQNUFw?=
 =?utf-8?B?OWFvTmhhaW9mWWRIQ2pxNjFkSm9aZFhnZlM2RkVkYmxDOFFISUUzeWJHaU5p?=
 =?utf-8?B?QWUzQ0RTcjhrNkFqWnN0T0ZTbE5LSk5OUDVVUnRNSHN3akRnVGFxeEVNSzNL?=
 =?utf-8?B?U2l4MUxpYTFMaUhxQk9YbWF1cVJCTlpNZzJaM1lIcS9DTU1BUVAxVzdmb21C?=
 =?utf-8?Q?x0NG5nRvCNCEiUikzSRRzgpog?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a14f045e-6abd-42d8-a2d3-08dc6369105c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 07:43:27.6573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2SCQtp92DJDr303qmOGl56XGSEUCfDUEFjkKIDCWcFgFo80KulsWpXmdJoJHdJ7uFHwW3+xVk+RQGMnfbLCuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7065
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgQXByaWwgMjAsIDIwMjQgMTI6MzYgQU0NCj4gDQo+IE9uIEZyaSwgMTkg
QXByIDIwMjQgMDU6NTI6MDEgKzAwMDANCj4gIlRpYW4sIEtldmluIiA8a2V2aW4udGlhbkBpbnRl
bC5jb20+IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxs
aWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIEFwcmlsIDE5LCAyMDI0IDQ6
MzggQU0NCj4gPiA+DQo+ID4gPiBPbiBUaHUsIDE4IEFwciAyMDI0IDE3OjAzOjE1ICswODAwDQo+
ID4gPiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gPiBP
biAyMDI0LzQvMTggMDg6MDYsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gPiA+PiBGcm9tOiBB
bGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+ID4gPiA+PiBT
ZW50OiBUaHVyc2RheSwgQXByaWwgMTgsIDIwMjQgNzowMiBBTQ0KPiA+ID4gPiA+Pg0KPiA+ID4g
PiA+PiBCdXQgd2UgZG9uJ3QgYWN0dWFsbHkgZXhwb3NlIHRoZSBQQVNJRCBjYXBhYmlsaXR5IG9u
IHRoZSBQRiBhbmQgYXMNCj4gPiA+ID4gPj4gYXJndWVkIGluIHBhdGggNC8gd2UgY2FuJ3QgYmVj
YXVzZSBpdCB3b3VsZCBicmVhayBleGlzdGluZyB1c2Vyc3BhY2UuDQo+ID4gPiA+ID4gPiBDb21l
IGJhY2sgdG8gdGhpcyBzdGF0ZW1lbnQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBEb2VzICdicmVh
aycgbWVhbnMgdGhhdCBsZWdhY3kgUWVtdSB3aWxsIGNyYXNoIGR1ZSB0byBhIGd1ZXN0IHdyaXRl
DQo+ID4gPiA+ID4gdG8gdGhlIHJlYWQtb25seSBQQVNJRCBjYXBhYmlsaXR5LCBvciBqdXN0IGEg
Y29uY2VwdHVhbGx5IGZ1bmN0aW9uYWwNCj4gPiA+ID4gPiBicmVhayBpLmUuIG5vbi1mYWl0aGZ1
bCBlbXVsYXRpb24gZHVlIHRvIHdyaXRlcyBiZWluZyBkcm9wcGVkPw0KPiA+ID4NCj4gPiA+IEkg
ZXhwZWN0IG1vcmUgdGhlIGxhdHRlci4NCj4gPiA+DQo+ID4gPiA+ID4gSWYgdGhlIGxhdHRlciBp
dCdzIHByb2JhYmx5IG5vdCBhIGJhZCBpZGVhIHRvIGFsbG93IGV4cG9zaW5nIHRoZSBQQVNJRA0K
PiA+ID4gPiA+IGNhcGFiaWxpdHkgb24gdGhlIFBGIGFzIGEgc2FuZSBndWVzdCBzaG91bGRuJ3Qg
ZW5hYmxlIHRoZSBQQVNJRA0KPiA+ID4gPiA+IGNhcGFiaWxpdHkgdy9vIHNlZWluZyB2SU9NTVUg
c3VwcG9ydGluZyBQQVNJRC4gQW5kIHRoZXJlIGlzIG5vDQo+ID4gPiA+ID4gc3RhdHVzIGJpdCBk
ZWZpbmVkIGluIHRoZSBQQVNJRCBjYXBhYmlsaXR5IHRvIGNoZWNrIGJhY2sgc28gZXZlbg0KPiA+
ID4gPiA+IGlmIGFuIGluc2FuZSBndWVzdCB3YW50cyB0byBibGluZGx5IGVuYWJsZSBQQVNJRCBp
dCB3aWxsIG5hdHVyYWxseQ0KPiA+ID4gPiA+IHdyaXRlIGFuZCBkb25lLiBUaGUgb25seSBuaWNo
ZSBjYXNlIGlzIHRoYXQgdGhlIGVuYWJsZSBiaXRzIGFyZQ0KPiA+ID4gPiA+IGRlZmluZWQgYXMg
Ulcgc28gaWRlYWxseSByZWFkaW5nIGJhY2sgdGhvc2UgYml0cyBzaG91bGQgZ2V0IHRoZQ0KPiA+
ID4gPiA+IGxhdGVzdCB3cml0dGVuIHZhbHVlLiBCdXQgcHJvYmFibHkgdGhpcyBjYW4gYmUgdG9s
ZXJhdGVkPw0KPiA+ID4NCj4gPiA+IFNvbWUgZGVncmVlIG9mIGluY29uc2lzdGVuY3kgaXMgbGlr
ZWx5IHRvbGVyYXRlZCwgdGhlIGd1ZXN0IGlzIHVubGlrZWx5DQo+ID4gPiB0byBjaGVjayB0aGF0
IGEgUlcgYml0IHdhcyBzZXQgb3IgY2xlYXJlZC4gIEhvdyB3b3VsZCB3ZSB2aXJ0dWFsaXplIHRo
ZQ0KPiA+ID4gY29udHJvbCByZWdpc3RlcnMgZm9yIGEgVkYgYW5kIGFyZSB0aGV5IHNpbWlsYXJs
eSB2aXJ0dWFsaXplZCBmb3IgYSBQRg0KPiA+ID4gb3Igd291bGQgd2UgYWxsb3cgdGhlIGd1ZXN0
IHRvIG1hbmlwdWxhdGUgdGhlIHBoeXNpY2FsIFBBU0lEIGNvbnRyb2wNCj4gPiA+IHJlZ2lzdGVy
cz8NCj4gPg0KPiA+IGl0J3Mgc2hhcmVkIHNvIHRoZSBndWVzdCBzaG91bGRuJ3QgYmUgYWxsb3dl
ZCB0byB0b3VjaCB0aGUgcGh5c2ljYWwNCj4gPiByZWdpc3Rlci4NCj4gPg0KPiA+IEV2ZW4gZm9y
IFBGIHRoaXMgaXMgdmlydHVhbGl6ZWQgYXMgdGhlIHBoeXNpY2FsIGNvbnRyb2wgaXMgdG9nZ2xl
ZCBieQ0KPiA+IHRoZSBpb21tdSBkcml2ZXIgdG9kYXkuIFdlIGRpc2N1c3NlZCBiZWZvcmUgd2hl
dGhlciB0aGVyZSBpcyBhDQo+ID4gdmFsdWUgbW92aW5nIHRoZSBjb250cm9sIHRvIGRldmljZSBk
cml2ZXIgYnV0IHRoZSBjb25jbHVzaW9uIGlzIG5vLg0KPiANCj4gU28gaW4gYm90aCBjYXNlcyB3
ZSB2aXJ0dWFsaXplIHRoZSBQQVNJRCBiaXRzIGluIHRoZSB2ZmlvIHZhcmlhbnQNCj4gZHJpdmVy
IGluIG9yZGVyIHRvIG1haW50YWluIHNwZWMgY29tcGxpYW50IGJlaGF2aW9yIG9mIHRoZSByZWdp
c3Rlcg0KPiAoaWUuIHRoZSBjb250cm9sIGJpdHMgYXJlIFJXIHdpdGggbm8gdW5kZXJseWluZyBo
YXJkd2FyZSBlZmZlY3QgYW5kDQo+IGNhcGFiaWxpdHkgYml0cyBvbmx5IHJlZmxlY3QgdGhlIGZl
YXR1cmVzIGVuYWJsZWQgYnkgdGhlIGhvc3QgaW4gdGhlDQo+IGNvbnRyb2wgcmVnaXN0ZXIpPw0K
DQp5ZXMNCg0KPiANCj4gPiA+ID4gNCkgVXNlcnNwYWNlIGFzc2VtYmxlcyBhIHBhc2lkIGNhcCBh
bmQgaW5zZXJ0cyBpdCB0byB0aGUgdmNvbmZpZyBzcGFjZS4NCj4gPiA+ID4NCj4gPiA+ID4gRm9y
IFBGLCBzdGVwIDEpIGlzIGVub3VnaC4gRm9yIFZGLCBpdCBuZWVkcyB0byBnbyB0aHJvdWdoIGFs
bCB0aGUgNCBzdGVwcy4NCj4gPiA+ID4gVGhpcyBpcyBhIGJpdCBkaWZmZXJlbnQgZnJvbSB3aGF0
IHdlIHBsYW5uZWQgYXQgdGhlIGJlZ2lubmluZy4gQnV0DQo+IHNvdW5kcw0KPiA+ID4gPiBkb2Fi
bGUgaWYgd2Ugd2FudCB0byBwdXJzdWUgdGhlIHN0YWdpbmcgZGlyZWN0aW9uLg0KPiA+ID4NCj4g
PiA+IFNlZW1zIGxpa2UgaWYgd2UgZGVjaWRlIHRoYXQgd2UgY2FuIGp1c3QgZXhwb3NlIHRoZSBQ
QVNJRCBjYXBhYmlsaXR5DQo+ID4gPiBmb3IgYSBQRiB0aGVuIHdlIHNob3VsZCBqdXN0IGhhdmUg
YW55IFZGIHZhcmlhbnQgZHJpdmVycyBhbHNvIGltcGxlbWVudA0KPiA+ID4gYSB2aXJ0dWFsIFBB
U0lEIGNhcGFiaWxpdHkuICBJbiB0aGlzIGNhc2UgRFZTRUMgd291bGQgb25seSBiZSB1c2VkIHRv
DQo+ID4NCj4gPiBJJ20gbGVhbmluZyB0b3dhcmQgdGhpcyBkaXJlY3Rpb24gbm93Lg0KPiA+DQo+
ID4gPiBwcm92aWRlIGluZm9ybWF0aW9uIGZvciBhIHB1cmVseSB1c2Vyc3BhY2UgZW11bGF0aW9u
IG9mIFBBU0lEIChpbiB3aGljaA0KPiA+ID4gY2FzZSBpdCBhbHNvIHdvdWxkbid0IG5lY2Vzc2Fy
aWx5IG5lZWQgdGhlIHZmaW8gZmVhdHVyZSBiZWNhdXNlIGl0DQo+ID4gPiBtaWdodCBpbXBsaWNp
dGx5IGtub3cgdGhlIFBBU0lEIGNhcGFiaWxpdGllcyBvZiB0aGUgZGV2aWNlKS4gIFRoYW5rcywN
Cj4gPiA+DQo+ID4NCj4gPiB0aGF0J3MgYSBnb29kIHBvaW50LiBUaGVuIG5vIG5ldyBjb250cmFj
dCBpcyByZXF1aXJlZC4NCj4gPg0KPiA+IGFuZCBhbGxvd2luZyB2YXJpYW50IGRyaXZlciB0byBp
bXBsZW1lbnQgYSB2aXJ0dWFsIFBBU0lEIGNhcGFiaWxpdHkNCj4gPiBzZWVtcyBhbHNvIG1ha2Ug
YSByb29tIGZvciBtYWtpbmcgYSBzaGFyZWQgdmFyaWFudCBkcml2ZXIgdG8gaG9zdA0KPiA+IGEg
dGFibGUgb2YgdmlydHVhbCBjYXBhYmlsaXRpZXMgKGJvdGggb2Zmc2V0IGFuZCBjb250ZW50KSBm
b3IgVkZzLCBqdXN0DQo+ID4gYXMgZGlzY3Vzc2VkIGluIHBhdGNoNCBoYXZpbmcgYSBzaGFyZWQg
ZHJpdmVyIHRvIGhvc3QgYSB0YWJsZSBmb3IgRFZTRUM/DQo+IA0KPiBZZXMsIHZmaW8tcGNpLWNv
cmUgd291bGQgc3VwcG9ydCB2aXJ0dWFsaXppbmcgdGhlIFBGIFBBU0lEIGNhcGFiaWxpdHkNCj4g
bWFwcGVkIDE6MSBhdCB0aGUgcGh5c2ljYWwgUEFTSUQgbG9jYXRpb24uICBXZSBzaG91bGQgYXJj
aGl0ZWN0IHRoYXQNCj4gc3VwcG9ydCB0byBiZSBlYXNpbHkgcmV1c2VkIGZvciBhIGRyaXZlciBw
cm92aWRlZCBvZmZzZXQgZm9yIHRoZSBWRiB1c2UNCj4gY2FzZSBhbmQgdGhlbiB3ZSdkIG5lZWQg
dG8gZGVjaWRlIGlmIGEgbG9va3VwIHRhYmxlIHRvIGFzc29jaWF0ZSBhbg0KPiBvZmZzZXQgdG8g
YSBWRiB2ZW5kb3I6ZGV2aWNlIHdhcnJhbnRzIGEgdmFyaWFudCBkcml2ZXIgKHdoaWNoIGNvdWxk
IGJlDQo+IHNoYXJlZCBieSBtdWx0aXBsZSBkZXZpY2VzKSBvciBpZiB3ZSdkIGFjY2VwdCB0aGF0
IGludG8gdmZpby1wY2ktY29yZS4NCg0KeWVzDQoNCj4gDQo+ID4gQWxvbmcgdGhpcyByb3V0ZSBw
cm9iYWJseSBtb3N0IHZlbmRvcnMgd2lsbCBqdXN0IGV4dGVuZCB0aGUgdGFibGUgaW4NCj4gPiB0
aGUgc2hhcmVkIGRyaXZlciwgbGVhZGluZyB0byBkZWNyZWFzZWQgdmFsdWUgb24gRFZTRUMgYW5k
IHF1ZXN0aW9uDQo+ID4gb24gaXRzIG5lY2Vzc2l0eS4uLg0KPiA+DQo+ID4gdGhlbiBpdCdzIGJh
Y2sgdG8gdGhlIHF1aXJrLWluLWtlcm5lbCBhcHByb2FjaC4uLiBidXQgaWYgc2ltcGxlIGVub3Vn
aA0KPiA+IHByb2JhYmx5IG5vdCBhIGJhZCBpZGVhIHRvIHB1cnN1ZT8g8J+Yig0KPiANCj4gQSBE
VlNFQyB0byBleHByZXNzIHVudXNlZCBjb25maWcgc3BhY2UgY291bGQgc3RpbGwgc3VwcG9ydCBh
IGdlbmVyaWMNCj4gdmZpby1wY2ktY29yZSBvciB2YXJpYW50IGRyaXZlciBpbXBsZW1lbnRhdGlv
biBvZiBQQVNJRCB2aXJ0dWFsaXphdGlvbi4NCj4gVGhlIHRhYmxlIGxvb2t1cCB3b3VsZCBwcm92
aWRlIGEgZGV2aWNlLXNwZWNpZmljIHF1aXJrIHRvIGEgYmFzZQ0KPiBpbXBsZW1lbnRhdGlvbiBv
ZiBjYXJ2aW5nIGl0IGZyb20gRFZTRUMgcmVwb3J0ZWQgZnJlZSBzcGFjZS4NCj4gDQo+IFRoZSBx
dWVzdGlvbiBvZiB3aGV0aGVyIGl0IHNob3VsZCBiZSBpbiBrZXJuZWwgb3IgdXNlcnNwYWNlIGlz
DQo+IGRpZmZpY3VsdC4gIFRoZXJlIGFyZSBjZXJ0YWlubHkgb3RoZXIgY2FwYWJpbGl0aWVzIHdo
ZXJlIHZmaW8tcGNpDQo+IGV4cG9zZXMgUlcgcmVnaXN0ZXJzIGFzIHJlYWQtb25seSBhbmQgd2Ug
cmVseSBvbiB0aGUgdXNlcnNwYWNlIFZNTSB0bw0KPiBlbXVsYXRlIHRoZW0uICBXZSBjb3VsZCBj
b25zaWRlciB0aGlzIG9uZSBvZiB0aG9zZSBjYXNlcyBzbyBsb25nIGFzIHRoZQ0KPiBjaGFuZ2Ug
b2YgZXhwb3NpbmcgUEFTSUQgYXMgYSByZWFkLW9ubHkgY2FwYWJpbGl0eSBpcyB0b2xlcmF0ZWQg
Zm9yIG9sZA0KPiBRRU1VLCBuZXcga2VybmVsLg0KDQpvbGQgUUVNVS9uZXcga2VybmVsIHNlZW1z
IE9LIGFjY29yZGluZyB0byBkaXNjdXNzaW9ucyBpbiB0aGlzIHRocmVhZC4NCg0KPiANCj4gVGhl
biBjb21lIFZGcy4gIEFGQUlLLCBpdCB3b3VsZCBub3QgYmUgcG9zc2libGUgZm9yIGFuIHVucHJp
dmlsZWdlZA0KPiBRRU1VIHRvIGluc3BlY3QgdGhlIFBBU0lEIHN0YXRlIGZvciB0aGUgUEYuICBU
aGVyZWZvcmUgSSB0aGluayB2ZmlvDQo+IG5lZWRzIHRvIHByb3ZpZGUgdGhhdCBpbmZvcm1hdGlv
biBlaXRoZXIgaW4tYmFuZCAoaWUuIGVtdWxhdGVkIFBBU0lEKSBvcg0KPiBvdXQtb2YtYmFuZCAo
ZGV2aWNlIGZlYXR1cmUpLiAgQXQgdGhhdCBwb2ludCwgdGhlcmUncyBzb21lIGtlcm5lbCBjb2Rl
DQo+IHJlZ2FyZGxlc3MsIHdoaWNoIGxlYW5zIG1lIHRvd2FyZHMgdmlydHVhbGl6aW5nIGluIHRo
ZSBrZXJuZWwuICBJJ2QNCj4gd2VsY29tZSBhIGNvbXBsZXRlLCBjb2hlcmVudCBwcm9wb3NhbCB0
aGF0IGNvdWxkIGJlIGRvbmUgaW4gdXNlcnNwYWNlDQo+IHRob3VnaC4gIFRoYW5rcywNCj4gDQoN
CkknbSBub3Qgc3VyZSBob3cgdXNlcnNwYWNlIGNhbiBmdWxseSBoYW5kbGUgdGhpcyB3L28gY2Vy
dGFpbiBhc3Npc3RhbmNlDQpmcm9tIHRoZSBrZXJuZWwuDQoNClNvIEkga2luZCBvZiBhZ3JlZSB0
aGF0IGVtdWxhdGVkIFBBU0lEIGNhcGFiaWxpdHkgaXMgcHJvYmFibHkgdGhlIG9ubHkNCmNvbnRy
YWN0IHdoaWNoIHRoZSBrZXJuZWwgc2hvdWxkIHByb3ZpZGU6DQogIC0gbWFwcGVkIDE6MSBhdCB0
aGUgcGh5c2ljYWwgbG9jYXRpb24sIG9yDQogIC0gY29uc3RydWN0ZWQgYXQgYW4gb2Zmc2V0IGFj
Y29yZGluZyB0byBEVlNFQywgb3INCiAgLSBjb25zdHJ1Y3RlZCBhdCBhbiBvZmZzZXQgYWNjb3Jk
aW5nIHRvIGEgbG9vay11cCB0YWJsZQ0KDQpUaGUgVk1NIGFsd2F5cyBzY2FucyB0aGUgdmZpbyBw
Y2kgY29uZmlnIHNwYWNlIHRvIGV4cG9zZSB2UEFTSUQuDQoNClRoZW4gdGhlIHJlbWFpbmluZyBv
cGVuIGlzIHdoYXQgVk1NIGNvdWxkIGRvIHdoZW4gYSBWRiBzdXBwb3J0cw0KUEFTSUQgYnV0IHVu
Zm9ydHVuYXRlbHkgaXQncyBub3QgcmVwb3J0ZWQgYnkgdmZpby4gVy9vIHRoZSBjYXBhYmlsaXR5
DQpvZiBpbnNwZWN0aW5nIHRoZSBQQVNJRCBzdGF0ZSBvZiBQRiwgcHJvYmFibHkgdGhlIG9ubHkg
ZmVhc2libGUgb3B0aW9uDQppcyB0byBtYWludGFpbiBhIGxvb2stdXAgdGFibGUgaW4gVk1NIGl0
c2VsZiBhbmQgYXNzdW1lcyB0aGUga2VybmVsDQphbHdheXMgZW5hYmxlcyB0aGUgUEFTSUQgY2Fw
IG9uIFBGLg0KDQpUaGFua3MNCktldmluDQo=

