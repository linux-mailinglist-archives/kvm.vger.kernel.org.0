Return-Path: <kvm+bounces-18465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A848D58C3
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89ED11F25A06
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 02:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD1A78C71;
	Fri, 31 May 2024 02:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H5qhGIZt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827F37140;
	Fri, 31 May 2024 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717124179; cv=fail; b=Cfkj1g3sXjGQIvntm0HWw11+Fyynjk9R53zTmnbRxUcZeOSegQvt12bWntWi11Ecq36pNTU5WUFv3cqOX0sn12OIna7WpKaPNvFacvod4Q1tNm2CvOAhTr+cJzF5xeoFdgz+xWs9rCaS343N6eRpykk1yktfcYkeZ0Q4oX5odvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717124179; c=relaxed/simple;
	bh=eP6pmgacdlVZKkGnlu1RxkLRKwzlORHVmhQXZhg7Xx0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FiHlyB/Z15Icm/g8oKfWU/sSRJPktK7K0BNachKtXh2uKieXCd75Nla13eIduMHuOvss078k9MehgRuovdyxd73n16HhDpiuLAUsWN6gFPFl5fASjobiReXn8+qXQAhOSg18TLbEE5GBnWWA9EOB+n20Q9wfMHhqrv9GqF321F8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H5qhGIZt; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717124177; x=1748660177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eP6pmgacdlVZKkGnlu1RxkLRKwzlORHVmhQXZhg7Xx0=;
  b=H5qhGIZt1/0DSQ85OjeLzxhvgDTY0r65nKfddFjC0OCQm2EcCzhiUU6R
   B1Q5kgIJripgJhJFI86aM0he+T9RdrjHs0CZIL/2qFfh4UsvPk7+XbTRP
   +KzGPOUOrvIVA+9EDGCwLDBQaLzUwHHWQmtZORlID5siJBrWbCdKpWDO2
   76aZWy6s5uvDebDsxQRuBHoEoQ56jxl27spSP6GrkYyYGBf4hlLP3W4oR
   dZHTyaRVKJaRT1MkFQwocqOFMWvncNCnfyJxUQCSF7VUQwUvLW5DIGcHu
   0zLkQy65VZuc85CkzqnO9QJV9Yk4PfWqfEkIDq/OwdcleqXQMh3F5IxPO
   w==;
X-CSE-ConnectionGUID: T2XF+uA5SBmutG8cHD9jBw==
X-CSE-MsgGUID: cnrhIm5VT1S07qD2hXk5Ig==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13877975"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="13877975"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 19:56:17 -0700
X-CSE-ConnectionGUID: UvQriPokToqmD9pjazfLUw==
X-CSE-MsgGUID: 7hYEKyimRtW2cXXFcs75bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="59213416"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 19:56:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 19:56:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 19:56:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 19:56:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nj7w7f/l+abCn1CboLt4V+rQi1e9m9t9cF67hbrrJ2bBnyd7KCccMgB8aeWIoZi2emmrbZcfBFQ+O0pqedWNPG2jS05H6vMjQ7rg9AFrWc3SuQNEPok5fBJ8ldYDEPfAI1I1vwQJ4YtdvWFk7OUi7+gImD7BwJvwa1EjhgsbwX+OcXu9Tk28v379OR4g0k32UReuay7XzjyWOWbk0V6FxSUosqD5x6DPBT3sFfcPskqQuv6kFsF6lxA63PkbRFXpVW/IXitxO+D5Zy/20f14YOA5GL+pQJrxrR1gjCmrVU+rUNLT/S1WLk/2GSzc7RWNHjOrIP0CIUEmXlt/j2nPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eP6pmgacdlVZKkGnlu1RxkLRKwzlORHVmhQXZhg7Xx0=;
 b=c04La4b/KhP2HsKAzh1BIXbfYRhpZrlZ3w2K9BgAJil7uuWd5qy6E20rNSek/lybqwwR375hUITX1bBI/hazvQrO14eE+5I4X2bniOjxP03H/4De5VFAIRphWMaLkw7REJPS37mua9W6/cVMY6csardACgcA7EZJNppni7RKfpwH1tj5eOEB0Yd8DIciSP43VFmS7G46mG3lC/4PuSdL5f3LH2HoVApDhaTAlGQZco51BWLmEuZGQBOcX6Dl5FxtmTn0b8PNR42F5q9Lhh0eeIsq0jGB2oDaDlgPgVZloRx4VTf9sFbC/kBNGyzPF85g6maCrc7g0wVZ2TSN6oroFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 02:56:09 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::9292:61e:1a29:3447]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::9292:61e:1a29:3447%6]) with mapi id 15.20.7611.016; Fri, 31 May 2024
 02:56:09 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Cao, Yahui" <yahui.cao@intel.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Topic: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Index: AQHasPdo/jZhUrqaQEW6s3F8Pfqkk7GtfQOAgAACY5CAADLHAIAC41fA
Date: Fri, 31 May 2024 02:56:09 +0000
Message-ID: <DM4PR11MB5502763ABCC526E7F277363888FC2@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SA2PR11MB5196:EE_
x-ms-office365-filtering-correlation-id: 40df3374-b5b5-46cd-d7ae-08dc811d3927
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MjJyMElRb2E2QVNvcDY3TTB3MHBnSjdtUVo1UGgrVHltcmM3TW5pN2ZCUnRi?=
 =?utf-8?B?VkpidW1uSzRqdU5qZWVNc0VNSmZTQXdSYVZDUmlBVmltaG5nQ3ppbTNiNjFJ?=
 =?utf-8?B?NGExL0dSU3R5RXhoNTRxUWtmZHNuWmxWWm5WVENsMm84WnY5VnZIMW5aWms1?=
 =?utf-8?B?RXFkcjVGWUFrcjEzOUdRUGliMU1Dak5Wa1NVa0JsUXpKTm9RclVyaTBHRzYz?=
 =?utf-8?B?T3IzZG5KdGF3U2pkei9XRndkeEZLQU9ZcnIwa2xDRE9jc0M3R05CWlVHYUtn?=
 =?utf-8?B?NzlEWHBERjBTbkxDS0JqOWVCZ2ZMSEFtQXhTRk9mNlJzeWZ6M09sNWw1NG1H?=
 =?utf-8?B?Z29rODRMWmxmZmdIVUYyTTBLSHVDdThXc0FIWE55RmN3TXJBQ3hiVGloRkVM?=
 =?utf-8?B?MnRaQWkxZ0YvTS9TZ0xuQUFSNmtqQ0xxMUNzL0lkRjZPb0ZmbmhkTE5ML2xC?=
 =?utf-8?B?cXVmbGpoS2RPRHBUZWFXcnRxbGFuKzhNaDRjMWFweGhVVzZPaDd2RWZUNmds?=
 =?utf-8?B?YUpzem9BdGxndWxsV0JtMnJzWWg4RDZ0aUdVYW1tVUQ3Rm5pNFI3bFQ3bm9M?=
 =?utf-8?B?Q2FuVU1MQ1VHZWRMaUoyWFlyWEdiQS91VUorSXBLc0RRdmtaVU1kSG9zeTdZ?=
 =?utf-8?B?VDVoZmhFVDRYdEUycGNyV2NOZmsra080Ync0RUZ2MjArOCtNSC9sS2U5WEs1?=
 =?utf-8?B?RHNsZlJObDhoMTA4RzgzWWVhT2h6Mkk3Smk1MjRXMktTS1lLdHczWDI5Tmp3?=
 =?utf-8?B?YUJna3hBdGNUODNCVEpjNnlocTJXckVIM2dGVGxQckNQNEZyZUdRa3BLTzND?=
 =?utf-8?B?MExqL1RrYTFURjhGVHdkK2RzdEUrN2tPZFhDaGJ1eHRwc0hjN0lTRDA3TW1M?=
 =?utf-8?B?OG0wZUZLUXg3b1BwRXNaUXVheDQxSHFIdHRPbTNFNnVBaGdzT3A0QUQyM0RP?=
 =?utf-8?B?OEpxTWFPemVHanozWS92TmFtMkJuREljR1AvaE0xdTZETHlNREJsekQwWmFW?=
 =?utf-8?B?Vi9Xd3FDbWpSKzlTMkNBUm9xRDlubjZ0L0FPT0hpd3BsZlJreFVFMUNBZ295?=
 =?utf-8?B?dnMvV2ptb3NQOWtsa0dvSHFYcHNvQWxHbHRGdkJvTW9wUXZ4REl0dDRvSTZB?=
 =?utf-8?B?UmM2WVJ2OHE3SmVWL29SZjBqN0NKdm43eFpxb0ZXb01id0xhenFicmVIc2lW?=
 =?utf-8?B?Y1l3WHN3WGFvcTBsbVYySU0za0tCdjNQaFVFbEVoYWV6U2l1THdsSXcrTUE0?=
 =?utf-8?B?QnROeXNDRjM0Ty9CQ2dobTkvZGk4NDdnSStaRDJZZm5DVlNhY0s3ckxZVzZQ?=
 =?utf-8?B?TldFMVFwS2dndjZDY3Y1ZkNDNkFhcSsrNk1pa3JHNDA3QXhOV04rc2RTUFZo?=
 =?utf-8?B?UEx1RmRyMndNdGhsc3VIOExLQ2JodzlkVVRXWnIrcTMrc0VhTEFzS3pnL3lo?=
 =?utf-8?B?RWZlMWJ4VEh6aEx6TkRVWm9vajNFeEdKVHRGRWRLbmIxaTFicUE1RHlpK3U3?=
 =?utf-8?B?cHh0dGcxRVpGdEhjd0FUOWRYd0gxWlA3ajB3OGpLS2tkbkZTOHg2UnM4aDNG?=
 =?utf-8?B?TlpqZ093d2xSR2Z2TE82ZG9keEFBTFBFTFJ6L2Z3d1lQYkpGWG00S0xSQzNT?=
 =?utf-8?B?dnk5Nk1HZTloUE1BbEtUT0FDWi9URURWODBzb3VBMDhtdG5VRVNjZ2crVUVk?=
 =?utf-8?B?QkVSc0lwRk1GYm9rUGhnaEVtZTVJaDIzbUVib0dWTXp6SWN2WGdWNWVXQVY3?=
 =?utf-8?B?VjQ0azF1bUEwNGdSZVVPcmVudzF0ZmNTM0VoOEFPOU9ZeHhlNmZsSlZMVktl?=
 =?utf-8?B?M21mSkJ3ZDRnQ21CS0cydz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXVYY2RLdU1jd0VrZlcvZWRaeldaenR5Q1B4WkluSXZ4dWQ5Qi9XVkIrTlpG?=
 =?utf-8?B?ZUFDekVWYVJSQ0g3emMwSElWOTFWM0E1L1RwU3lrdzE3cm1QSGVxUmNJQ2FM?=
 =?utf-8?B?TzdkN2J2S1dQL0ZkbUlBM2RGZHlWaHhGbEtRVnMzVjZXaEc2M3FhcENNQXBq?=
 =?utf-8?B?by83dEtab3hXN0hkSC9QbHI0THIvb1lhMFhJYTczWEY1OU5oa2pEd0JXUUM3?=
 =?utf-8?B?c3Q5cDlmY0RLdDBjR2FrZ3BlY1ppR0VkNmhnLzI1Qm1yWlI0aGsxRnlWaEU3?=
 =?utf-8?B?SHVZbnpFNmlCdDlVS1lJaGtSOGR1S2d6aFRIR3dCczBXMTZ3bmNwRHdTMW5l?=
 =?utf-8?B?bFBURGJ6bVlhblBWTC9Wdm5zd3FuR0tsWWF1SWpxRU1SYzhvQ1p5Vy9SMS9j?=
 =?utf-8?B?SktQanVYZzhsOFVhM1QvWnBRdkUxTFYxUXZjcmV1OTd2TTF5N1RRV1diaUxH?=
 =?utf-8?B?bHVXUEU0bjlIc0piNytaUmNWTXFpSDJrR2tDSVgxM3dGNHo3YUo1enZNNXkz?=
 =?utf-8?B?UUd2ZXQ3NUNrWTBrSzkzbU90MGF2Qnc4OVR0NlRSSXRVNk9TRHhaaC8zNmc3?=
 =?utf-8?B?SjhnWUo4bFBZRkRpRElYM0dMbjRDbmJYZWoyNEg5NHpqbDBGVHdsc252MVpT?=
 =?utf-8?B?d1hnWU5wa1EvOUFqazBGeS9UTUFvTHpGSHo1WTd6dmpmRnQ2UFN4VVAvTjB6?=
 =?utf-8?B?aWE1WExwVFAvNkxTTTNBOER6c1JJTFVsNUtXVDY4aXlpTUNKakJDOXRSbGYv?=
 =?utf-8?B?RHJBaUlyWnVhNlI4T0R5WVVGTXNZZHh6K2ZhVlhaV2dWQnN6czRrUzVYOUJF?=
 =?utf-8?B?TGgxeGxWRHNPZDhmYUkzTjBkUTZlTGhJdkNSYzlLZCtNOFRGcTB3UlFzUkRI?=
 =?utf-8?B?akc5K2VteGRaTFhNMml2YjdDUEdtSCs2UitDRHFHUDd3OERGN2hrNlJocXdi?=
 =?utf-8?B?UzRiOWdYN04zTVJyNldTTzZWd0dNT0ljN1hNdENhWEg2L1p1eERDdkdpeGxs?=
 =?utf-8?B?Qzk0OEtwMUg5WHBQRERySGhZemVuOStuRDJVeEtlZndtb1djUnZadG1TcXJm?=
 =?utf-8?B?R1VNOVdXc0Z0QVFMQjZYaUN4Nmg5d2p3RHBlaTBMTW1tanJ3eG1ob3FyZDQ2?=
 =?utf-8?B?dUZieGJDSXNZWVIyRUlzclgwWkQvalVHQkROSENJK3NOSkJpS3lvQVRrOFk4?=
 =?utf-8?B?STNoaVpEeU9TelRlQVR5aVNLcXF0VTMwbGU2MW4vTWlYY1BXL2JudG9OeG5E?=
 =?utf-8?B?cGxWRm8xT0hpenBlRzltT0J4REU3N0JPeUdjTE03SzJiQjFaclpKQlFYbnA3?=
 =?utf-8?B?YzFmSjdGZkVJaWZYb1lRcVJWTlNrZ01XTEdEL2MxUGQ5RjZWalNvV25PNWp0?=
 =?utf-8?B?UWNSemwxOW5WQVI1RzZQRVVjZ3NDRHhTSUNnLzVDUDArNXdreXhrQ1AvNERR?=
 =?utf-8?B?cE51UnFJdDl2T2dVNk02ejdyU2s4eUp6Nmt4NkxZYVRXRlVrN3NhbFJpYjlx?=
 =?utf-8?B?dDBCVWkwR0prYTRRZTYvWk03UjliOE5nTkhXcytqSlVpUUZueG1UZnJaZHpP?=
 =?utf-8?B?cVpZNVM1TTJzTWtSNzkzU2o1bVJJdVNtZTc4cHI5S2lvUlc5WFFyREdPNEEr?=
 =?utf-8?B?aW1SeU9jMzlEa2lDRjZsODFXL292dEN3Qmc2MU1rY28ybFlIMlVWeVZBOS9X?=
 =?utf-8?B?SVRQbEtDWDdtdVgvb1Y5QUE4UWhudStDYlA2d3h4RkdqWVFqcXRaZi9mWHk1?=
 =?utf-8?B?SEFWZDVScTV1aHlsRVU1eEloSU1Ob1NNOTYrblFRVFpJY0tJUUpYSnlEeVg5?=
 =?utf-8?B?UzNYOEZnaEZackxhcUttbmRUTnFTdDRVUWZpS3o2Y0ZjSjlSbHNpclRLTFJu?=
 =?utf-8?B?cDJsMFFhRVdaV1FGaEVkSndHM3hRVXRGZVhOQWFYeFZlQlNoZlZpK1ozUkZV?=
 =?utf-8?B?RU04aVd5OFB5OEZZVDE1UWoveW1FeWxPYzVSQlF0Mmphb1Z0MDh2T3lQdTdj?=
 =?utf-8?B?M29iY1hVWHd0TnhkUGtMaW5JOVFEUUdjWmFGengrbkl6ekRETmxSa2hHbFRj?=
 =?utf-8?B?dm1BbTN2K0MxWlVrQVJ3aEEzaVJVSHVFTUpabEhOU0JhU3JHYW81cTY5S25x?=
 =?utf-8?Q?Q7Jxd5mnBuBmT7FMTgZwgypt5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40df3374-b5b5-46cd-d7ae-08dc811d3927
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 02:56:09.2320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mqxOtay152YpD8zzmHclGFebctMxGIDy7O5m2b6gkKdjvtlKH5msNXnQvN4XLc5L1sO4XevYMaIeUwnQbWdDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBNYXkgMjksIDIwMjQgMTozNiBQTSwgVGlhbiwgS2V2aW4gPGtldmluLnRp
YW5AaW50ZWwuY29tPiB3cm90ZToNCj4gVG86IFplbmcsIFhpbiA8eGluLnplbmdAaW50ZWwuY29t
PjsgQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3JnPjsNCj4gQ2FiaWRkdSwgR2lvdmFubmkg
PGdpb3Zhbm5pLmNhYmlkZHVAaW50ZWwuY29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4Lndp
bGxpYW1zb25AcmVkaGF0LmNvbT47IENhbywgWWFodWkgPHlhaHVpLmNhb0BpbnRlbC5jb20+DQo+
IENjOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgSmFzb24gR3VudGhvcnBlIDxqZ2dA
emllcGUuY2E+Ow0KPiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT47IFNoYW1lZXIg
S29sb3RodW0NCj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47IGt2bUB2
Z2VyLmtlcm5lbC5vcmc7IHFhdC0NCj4gbGludXggPHFhdC1saW51eEBpbnRlbC5jb20+OyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0hdIHZmaW8vcWF0
OiBhZGQgUENJX0lPViBkZXBlbmRlbmN5DQo+IA0KPiA+IEZyb206IFplbmcsIFhpbiA8eGluLnpl
bmdAaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDI5LCAyMDI0IDExOjExIEFN
DQo+ID4NCj4gPiBPbiBXZWRuZXNkYXksIE1heSAyOSwgMjAyNCAxMDoyNSBBTSwgVGlhbiwgS2V2
aW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+ID4gVG86IEFybmQgQmVyZ21hbm4gPGFybmRA
a2VybmVsLm9yZz47IFplbmcsIFhpbiA8eGluLnplbmdAaW50ZWwuY29tPjsNCj4gPiA+IENhYmlk
ZHUsIEdpb3Zhbm5pIDxnaW92YW5uaS5jYWJpZGR1QGludGVsLmNvbT47IEFsZXggV2lsbGlhbXNv
bg0KPiA+ID4gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsgQ2FvLCBZYWh1aSA8eWFodWku
Y2FvQGludGVsLmNvbT4NCj4gPiA+IENjOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsg
SmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+Ow0KPiA+ID4gWWlzaGFpIEhhZGFzIDx5aXNo
YWloQG52aWRpYS5jb20+OyBTaGFtZWVyIEtvbG90aHVtDQo+ID4gPiA8c2hhbWVlcmFsaS5rb2xv
dGh1bS50aG9kaUBodWF3ZWkuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsgcWF0LQ0KPiA+ID4g
bGludXggPHFhdC1saW51eEBpbnRlbC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQo+ID4gPiBTdWJqZWN0OiBSRTogW1BBVENIXSB2ZmlvL3FhdDogYWRkIFBDSV9JT1YgZGVwZW5k
ZW5jeQ0KPiA+ID4NCj4gPiA+ID4gRnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3Jn
Pg0KPiA+ID4gPiBTZW50OiBUdWVzZGF5LCBNYXkgMjgsIDIwMjQgODowNSBQTQ0KPiA+ID4gPg0K
PiA+ID4gPiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+ID4gPg0KPiA+
ID4gPiBUaGUgbmV3bHkgYWRkZWQgZHJpdmVyIGRlcGVuZHMgb24gdGhlIGNyeXB0byBkcml2ZXIs
IGJ1dCBpdCB1c2VzDQo+ID4gZXhwb3J0ZWQNCj4gPiA+ID4gc3ltYm9scyB0aGF0IGFyZSBvbmx5
IGF2YWlsYWJsZSB3aGVuIElPViBpcyBhbHNvIHR1cm5lZCBvbjoNCj4gPiA+DQo+ID4gPiBhdCBh
IGdsYW5jZSB0aG9zZSB1bmRlZmluZWQgc3ltYm9scyBkb24ndCB1c2UgYW55IHN5bWJvbCB1bmRl
cg0KPiA+ID4gSU9WLiBUaGV5IGFyZSBqdXN0IHdyYXBwZXJzIHRvIGNlcnRhaW4gY2FsbGJhY2tz
IHJlZ2lzdGVyZWQgYnkNCj4gPiA+IGJ5IHJlc3BlY3RpdmUgcWF0IGRyaXZlcnMgd2hpY2ggc3Vw
cG9ydCBtaWdyYXRpb24uDQo+ID4gPg0KPiA+ID4gUHJvYmFibHkgdGhleSdkIGJldHRlciBiZSBt
b3ZlZCBvdXQgb2YgQ09ORklHX1BDSV9JT1YgaW4NCj4gPiA+ICJkcml2ZXJzL2NyeXB0by9pbnRl
bC9xYXQvcWF0X2NvbW1vbi9NYWtlZmlsZSIgdG8gcmVtb3ZlDQo+ID4gPiB0aGlzIGRlcGVuZGVu
Y3kgaW4gdmZpbyB2YXJpYW50IGRyaXZlci4NCj4gPiA+DQo+ID4NCj4gPiBUaGFua3MsIEtldmlu
IDotKS4gVGhpcyBkZXBlbmRlbmN5IGlzIGxpa2UgdGhlIHJlbGF0aW9uc2hpcCBiZXR3ZWVuIHRo
ZSBRQVQNCj4gPiB2ZmlvDQo+ID4gdmFyaWFudCBkcml2ZXIgYW5kIG1hY3JvIENSWVBUT19ERVZf
UUFUXzRYWFguIFRoZSB2YXJpYW50IGRyaXZlcg0KPiBkb2Vzbid0DQo+ID4gZGlyZWN0bHkgcmVm
ZXJlbmNlIHRoZSBzeW1ib2xzIGV4cG9ydGVkIGJ5IG1vZHVsZSBxYXRfNHh4eCB3aGljaCBpcw0K
PiA+IHByb3RlY3RlZA0KPiA+IGJ5IENSWVBUT19ERVZfUUFUXzRYWFgsIGJ1dCByZXF1aXJlcyB0
aGUgbW9kdWxlIHFhdF80eHh4IGF0IHJ1bnRpbWUNCj4gc28NCj4gPiBmYXIuDQo+ID4gQWxleCBz
dWdnZXN0ZWQgdG8gcHV0IENSWVBUT19ERVZfUUFUXzRYWFggYXMgdGhlIGRlcGVuZGVuY3kgb2Yg
dGhpcw0KPiA+IHZhcmlhbnQNCj4gPiBkcml2ZXIuDQo+ID4gRm9yIENPTkZJR19QQ0lfSU9WLCBp
ZiBpdCBpcyBkaXNhYmxlZCwgdGhpcyB2YXJpYW50IGRyaXZlciBkb2Vzbid0IHNlcnZlIHRoZQ0K
PiA+IHVzZXIgYXMNCj4gPiB3ZWxsIHNpbmNlIG5vIFZGcyB3aWxsIGJlIGNyZWF0ZWQgYnkgUUFU
IFBGIGRyaXZlci4gVG8ga2VlcCB0aGUgY29uc2lzdGVuY3ksDQo+IGl0DQo+ID4gbWlnaHQNCj4g
PiBiZSByaWdodCB0byBtYWtlIGl0IGFzIHRoZSBkZXBlbmRlbmN5IG9mIHRoaXMgdmFyaWFudCBk
cml2ZXIgYXMgQXJuZCBwb2ludGVkDQo+ID4gb3V0Lg0KPiA+IFdoYXQgZG8geW91IHRoaW5rPw0K
PiA+DQo+IA0KPiBGb2xsb3dpbmcgdGhpcyByYXRpb25hbGUgdGhlbiB3ZSBuZWVkIGFsc28gbWFr
ZSBQQ0lfSU9WIGEgZGVwZW5kZW5jeQ0KPiBmb3IgbWx4NSBhbmQgaGlzaWxpY29uIGdpdmVuIHRo
ZXkgYXJlIGZvciBWRiBtaWdyYXRpb24gdG9vPw0KDQpBZnRlciBtb3JlIHRob3VnaHRzIGFib3V0
IHRoaXMsIEkgd291bGQgYWdyZWUgd2l0aCB5b3VyIGZpcnN0IHBvaW50IHRoYXQNClBDSV9JT1Yg
c2hvdWxkIG5vdCBiZSB0aGUgZGVwZW5kZW5jeSBvZiB0aGUgdmFyaWFudCBkcml2ZXIgaWYgd2Ug
Y29uc2lkZXINCnBhc3N0aHJvdWdoIFZGcyBpbiBhIG5lc3RlZCB2aXJ0dWFsaXplZCBlbnZpcm9u
bWVudC4gDQpTbyBkZWNvdXBsaW5nIFBDSV9JT1YgZnJvbSBtaWdyYXRpb24gaGVscGVycyBpbiBR
QVQgUEYgZHJpdmVyIHNvdW5kcyBhDQpiZXR0ZXIgb3B0aW9uLiANCg0KVGhhbmtzLA0KWGluDQoN
Cg==

