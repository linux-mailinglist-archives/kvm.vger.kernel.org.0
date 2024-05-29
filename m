Return-Path: <kvm+bounces-18259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2948D2B50
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 05:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF0D21F2568D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A898B15B11E;
	Wed, 29 May 2024 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n5W0XYwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F382515B98B;
	Wed, 29 May 2024 03:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716952283; cv=fail; b=DWTi37Sgzv9nMFh0mjKVmYH0NbgQitUIWihO+YClfyNIK+6k63OzRoJ2YvynAERFPMdHeWVfAV5mSrtysmPLZcyXSpmGuqo6Md1tNizfd989OKe+eWiSo/9Sm5+JDiOhbgqfeCKQIB+OzED0NducCdfuIWj3wr6cOnnhWQtRTyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716952283; c=relaxed/simple;
	bh=n9tbCTeD6QLgpgk42hZGWkgaKJUdjgEUQ9PpvoJULcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ClMVDcgS6qVMLRbkx3mcovLEj/Vc4QJ1mSfHjEGj4wvp5/OqBoKy8Repq9dYola87LuRc5HsP4LBPgFcn6bhP5dlcw3ie5JvQOPbGcUqLwKlvHc63Zb2nyvPojKIL7N0bzEpS1LShBhZovIAT+b7M8om6rGtNvNfkHcV2yRKKdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n5W0XYwJ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716952282; x=1748488282;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n9tbCTeD6QLgpgk42hZGWkgaKJUdjgEUQ9PpvoJULcM=;
  b=n5W0XYwJMcpPFaH4D2rqZgWeDBM53XjGihwQ9/ry1nMmb0kEW0kscCPi
   PwTlaMpn461tYeVsFW9NqRyWNrda5BvnjHInd9EeFsro3r6Fjq2Pz/D+x
   uqusrrI5p2/jTwXW7NaQDI0IjkqVDW6a04x1cRYIWi1dVmla1/dLRriOX
   iUqfGOC28jXlO5I6t3LIxjh5zVQOHO0YP/t1r+d5sJU1peDYEJpnIbxzP
   dVBFdfFVqNNtzMl5Gb2eXYOk4yQjDVkhhhVOlk0OaiWBWQ8DeVNaFVpxW
   RpDcZNJPS0//ZERFR29AZ7HxsdSCrytxJJukMksjcd2tsD/Y8w1/Fzqd5
   w==;
X-CSE-ConnectionGUID: csLQZbmdQfmvCtYKkC9WCg==
X-CSE-MsgGUID: TrGOUWZ+QUeXV5vb9wU24Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13173715"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13173715"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 20:11:13 -0700
X-CSE-ConnectionGUID: L1bSfFnNSzS4KRrHlFRaNA==
X-CSE-MsgGUID: gOahg541Ro2RaNU4WzzscA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39721773"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 20:11:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 20:11:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 20:11:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 20:11:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 20:11:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4DwlX0jW8DMEMULRP2jZ6iq7NlA7bqKMMA402IC7WGGp0vGxHB/m1AaPdwU2pXr++5bmSLreaC2kv0j4GKv1oBHxub25vlU/pvZNI6fZwaJvY6ARJd5kzApZyyT3sHYsksstTu8Ca56pHjKP6e80xUAF8pLxFBgL1Tu6Nf0P3o54/Fznr0XKjTPtiaPaRNzUdlsZcu2Bys5YUmznFv9E8zibePpjsGuRbIObBXyN5pwH2FVJYu9sFsUBrN6IQ8A1F8I5XS7WEme9gTUeofF6I/zsnPmYNuCE1VWT5CRYrNuDj8CRrseOnNDr5YH5Wrnf7vLZzLeLm9CHaCTFneEcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9tbCTeD6QLgpgk42hZGWkgaKJUdjgEUQ9PpvoJULcM=;
 b=DFLy0DWzG0PHhtWWTNdsi2SFHrTht6WvMDR9EdMZR+VU9OD5ZlA9I13SDQv7tF7ZMjiCH8n31ta1wj3uq08lrDevnDJsKGy63w89Xy5223N9gVGKeJr6XYUAS4M43J3tzTTdPsUCKN/CMaAB7757JAMmFW4m6mSCdVdVHnZB4kdy02JP8pEBhgvGASGlOOSRfyl0HCL1H0QQhulDZKk0ZXsy5NoSkPxPuo51O1aFk/mc8P2eDzGpQFVGr89FrXd94rEZHQ3YoayKjrws5Ktf1fKGrSEJWWQUfXZBJ0cMWM3NsHXl2R5VTmlbpqn1z5fL/XbxzXVhEO7pJK1FV1upmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by MN0PR11MB6301.namprd11.prod.outlook.com (2603:10b6:208:3c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Wed, 29 May
 2024 03:11:09 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::9292:61e:1a29:3447]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::9292:61e:1a29:3447%6]) with mapi id 15.20.7611.016; Wed, 29 May 2024
 03:11:09 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Arnd Bergmann <arnd@kernel.org>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Cao, Yahui" <yahui.cao@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Topic: [PATCH] vfio/qat: add PCI_IOV dependency
Thread-Index: AQHasPdo/jZhUrqaQEW6s3F8Pfqkk7GtfQOAgAACY5A=
Date: Wed, 29 May 2024 03:11:09 +0000
Message-ID: <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|MN0PR11MB6301:EE_
x-ms-office365-filtering-correlation-id: 73cef331-1ba9-4af6-13c3-08dc7f8cfcb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Y3puSEN2Qm5LMWhZZEQrYmhIT0RIQ3V3MnYxL2pGUDFZSW5YQXdlV0xpUFQ4?=
 =?utf-8?B?cXlNWFZMblZPTEVTYWxNdFdpQ3g5MTdObG03aFIzcjh6TDdrMGN4UlcvYXN4?=
 =?utf-8?B?cm96YUVUZEhmRFdqRmNuRlZUeEU1c2dORFo2SU9tWWlwNHJTalorOWpxUnZn?=
 =?utf-8?B?YmpkOE5pSmRkOWMxbEUvSlY4Vk1mNXNYK0pKL08vcUVhNnNjZXpRUWVYcDJN?=
 =?utf-8?B?MTM0aXVZNGRrUEFDZzlqbUkwUWpSeHRqRjRkQ08wTjZMTHdKaWxsWm5wVHJZ?=
 =?utf-8?B?MEJla2lacmxjRVpaSzhQSGt0RGxRc1RnYlZxRjZsWGNmVUFGdUZzSjU1d09U?=
 =?utf-8?B?ZmV1VlhSNEovSXNvbjU3d0dxREtMVkc5NFQvbnFGaWJVMFNKaEs3OU1FUnNm?=
 =?utf-8?B?bHZsZ2JmMnRqTkxudDhvM28wYncrUFNVZ2J5SzhlTGJXL09za2E5OFprRDFo?=
 =?utf-8?B?dGZxa0pyVXAzaWgvcXgyd1hyVkJTYlBDa1NFb2IxS05STUlmZTB1TW9QeDgy?=
 =?utf-8?B?RzQ5VjNObGdzZWh4RmcxajE0dkZqcTg1SDBldFR6aDNYeFVIU0haWldWK1Br?=
 =?utf-8?B?Sm50K1FudXkwSWVoTVJHcEVSbEdadDYvSFBHbjA2Z2RCS0R4WTJJUTk2Um01?=
 =?utf-8?B?cW1LaHZrRGIxcERqdWtsT1FtMmtpRitlMXFhaUE1RkIwZWttQXBpeTRpZ2hK?=
 =?utf-8?B?eXg2MzU4OHludjIrNGpLNm5HbzVVNDFuWjNXTFBHSzl6VnZzbHo1SFcxVlkz?=
 =?utf-8?B?QXZ5MUQ5bUltNGJaNjFQYUhkdVEyV2ZvdThUZzRKcEJ2T09pTXhndWdRMU1K?=
 =?utf-8?B?T1N0QW9tbXRCOVNlaDhqNlNXQlpIbHZUVUtEaGNzTVozMjkvWVAydUdVQTcy?=
 =?utf-8?B?amNMallWYmRsdlBveVd2cjYxdlZYbVI2bFZTM3Zza0ZQdXR3MUJQd3VVbFZD?=
 =?utf-8?B?MHZ6MFpiSUtjV3V2OWZCWktPVml1VHR4UEEzY3dUQXJGeVZaWVRTM3BDME5a?=
 =?utf-8?B?Q2xPYVkweFBPc1ZiUzdpTldFcGIvVkJucW1qSDFTbHJGZFpjaHFXdHZQWHdw?=
 =?utf-8?B?Y2ZRKzV1d0xSZG1RMkdGUnBUYzk4WnNBZjhESWlYUkxxa2FhQVVCcUgyVFJr?=
 =?utf-8?B?NExSR3hZZDlSa0g0MHBJK1N1RTBCMkUzbGpyTWNiUExWcTBjdE5TemExZVl0?=
 =?utf-8?B?WjdNTVgrc0tJczNFNlBNZWhKRURKRHVSMHpVL0pJVHhhLzRVQTU3YTc4TVQz?=
 =?utf-8?B?TmNOdFloMkdjNzZ5Tnhsc1hzUDBKRnJ6UlhWNmNtQXNVTitUWXhkbzFPdzd6?=
 =?utf-8?B?amRwYlpuaVdULzJzakZPbDc5MlFjV2hIOXZVN1dJdmRhd0hUY2E2WElyeDlX?=
 =?utf-8?B?VUt4TjhqelNXL2lWU21qdjdablV4WGNtWDZpSkI5ZEhGODd4eHNUYkJpRFBr?=
 =?utf-8?B?WThGZDVnTDVQOWVUTlBNa0d4V0tINjZWckFKZHA0WDdzWG5GSlVjNzgzY2V5?=
 =?utf-8?B?VVpRVTNpVG5LOHpXZXlyeUFNNTFMSCs1eFluRjhwQURIZ2FRS3NEZU8zMCs1?=
 =?utf-8?B?L2ZmK214REpMMmd1MUh1b0VUQUlmUFg4cDlyVzdjR2FUanRSaU1YVW1Id1dY?=
 =?utf-8?B?TnFKYldabGRCQStHK0doYWtMZ1kvQ1NqV1pUeU1ZcXUzUzZqTXdBSno2QTB2?=
 =?utf-8?B?TnYwdURYM0psbFhIZDhXR2JTcjVzbko0OFdGbGxaZXdrbUlGS3lsZExEN29E?=
 =?utf-8?B?UkpoZnpiV3libEovdmYwaUZ6ZkVPamQ5dHA1OFM1dVI4WmJpbHhvRjk3VGxX?=
 =?utf-8?B?SVJUQzgxL3pablo4U1BOQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk1UY3lPbTU2OHAzam1oQmp6T3RIN2lSUGROdXQ1cW03VllUTlVZZWFRemM0?=
 =?utf-8?B?cTNuODdGK0k3R0E3MWpZMTN2aVo4b0Vhc3F3NEdrSzNxcUlmS1ZkUzdvY0pP?=
 =?utf-8?B?bHFiSFFpSEtQSW1Ebm9vMjFsbzNEYnhYQWhkMXlZajhzWFdsRUQ4Vjk4dGVo?=
 =?utf-8?B?elF6WmtJSXV0YmdGUk9qVHdYc0JmelFUcFdxV2RVY2RTODNvdjFZWVYzM1FH?=
 =?utf-8?B?cEhPejdKOVQwcVM5STM0cEhRL3lMQmc5SlVSZ2pIWWIvV3A2WDRMQUo5U1Jn?=
 =?utf-8?B?Z1NPNFR0VVFBalBtdXN5SkZ4OEJBb2UvZi9HS3ZSajNIU3lCSlJhcVFkc1k2?=
 =?utf-8?B?S1UyQ1lkVnU0Sno5MXJSajFmVVl6QXBBZW53MHRlTjhXaDdnUnRHSnNmWVBL?=
 =?utf-8?B?QkZQenQyL01vRXNIejRnNEtiWC9jd1Z2czArbnlMdTlrNnRYa0JYWkpEanBt?=
 =?utf-8?B?bmVjRGhaWnFZQ0pTaGRyMGo0Mi82NUlQUG5QSFVSNWloZVErU0o0TnRUak5m?=
 =?utf-8?B?ZTdJSmpmT0VaMkcvMnBDNDRPODMyNEt4bkRkcjNGNVlJblJpc1NFQlNGQzJi?=
 =?utf-8?B?N1NNTGhIMTRHaDVLVk0reUx5YUN5MTdvUzE0cFduOExiVU5KYVFnOXlDU3hZ?=
 =?utf-8?B?S21hNGIvQXN2OUY4ZDhlRG5RVFI5bFdtTWlZVVBSM1I2WjExOWpldlhiTGhE?=
 =?utf-8?B?TzI0SXNiOVZzY1hGUzJ2WXhtSnlyejBnamRPekhlbCt5QnptL1NWT0tkQVls?=
 =?utf-8?B?VE5nUS82MUhzb2tITHRKaWRwbEhCOHpTaXB2eXlQbCtOaWVEa3M5cnRkai85?=
 =?utf-8?B?RUM5OStvcElTRDNEbjJJZG83aDdyWEJnUHN0NGRDMzd2OHhEcjJHRkY2VUlS?=
 =?utf-8?B?TkV0cVgxbWJNdGFMcGZUK3R4LzdzS0ZybGY5SEtsU0pmRzlIQkVGc1dmbnRt?=
 =?utf-8?B?eEFMVm1yQjdPaUJ5a0d2b0R4VzRNOHVHWkxYaUpWcFp1Ulpqc3U3anBSa3J5?=
 =?utf-8?B?Q2MzRHVicHVwbEVsbEVaa1RxczNXbXBwWnB2aVMzOHFrdUROZmtvczVPcCth?=
 =?utf-8?B?MW9oejBXb1pWeTRPUjRtQzNGMkNuRWhUSTB6dlZBSkozNzhIUjRuNjRIM0U1?=
 =?utf-8?B?L00ySW5DN0Frb21yNzlOMzhYVlNHeVI1akxGbVl0T04raSszR2Z4alJrSytU?=
 =?utf-8?B?OGZCM0paYUVwbTM3SkVwNldkUW4rQ1NSUHpmUlBsZndoRkU3cGJTdURHVnVa?=
 =?utf-8?B?VVhhYmpkSFJ0NTJFL2hsQlpZNU5JUXVYcmxhK2w3U3VTTXR0cWlvTWwyLzBV?=
 =?utf-8?B?Lzhva1J4NFdrVzlTaE5vd2FVOUdHUXl4Q3dxOGJXNzFvNXBoTCs5SkZpMjQy?=
 =?utf-8?B?cm5KZk80VDVXR05pR2VPTzZmTWNyenYrb0FyL3FMYXZUaERwdmhGSkhUWk93?=
 =?utf-8?B?RkNuQjlpZVNTQjVRNTZhL25kNFZlME1FTFlFSVdzdHVFT1hNZ3ozbHhRclV4?=
 =?utf-8?B?STBwQ1J4RDVVdk0zNVRtTGgrUWNEbE9Yc0UzeStlN3ovMjBvc1gzTUgwSW9D?=
 =?utf-8?B?ZFhza3JJK0xKVENSUjdTMTBUTEcwZWlmOW5EYmpoUGxDM3B6Yk5XdXFRdXlh?=
 =?utf-8?B?SVNsSTlTdjJmblp5Wmo0WHpzVExGYUZuTzZQRDlkYlNWemcrRWNrYkxRY1RR?=
 =?utf-8?B?c1VydDZPaWtWTDkxcVpTTnVGUklJKzlwQnhHVnJnWmUwenBGMTBDYzJjMURS?=
 =?utf-8?B?ZHRLeWttUEFDUDRXcklsVjVPMzJVNzlFV0c3Y1NwczVmMU5kQ1Y1VFFOTjk4?=
 =?utf-8?B?emRQSG5jWC9IRGNPMUJoeFFFU2poeW5QenpvamRTQkE2N1VGdytBNFRyMlRw?=
 =?utf-8?B?VnNNeFRLSFhTTDZXd3kydlJNUjhHN2dnekNnbDVWdngvSkhLZmVzbEFGcFdI?=
 =?utf-8?B?Q1ZmamVqRFBMdG95Sk5uT0wyUmtDRVF4cVQyTHd5NzJ6UEl5cnZFeDA4ekNp?=
 =?utf-8?B?MWNxZ2grM2hSWXhXQkRTNnc4SXNGNGx2aXMzZy8vVUxZa2xFdkdGVjZwWnBC?=
 =?utf-8?B?T3o5UlRCWkhjT2d1L1E4RW5BZnk4NkdzMnRXUnFJSEZzaWFnTTRkQzFPTk1z?=
 =?utf-8?Q?u1CQaoGHobAvYQr+jSGb+Lcvn?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 73cef331-1ba9-4af6-13c3-08dc7f8cfcb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 03:11:09.1793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1BHrjDQCzefXIl0kIq2smBXWUlI2BWLkxLUIevkrglfWGvOfPAWghelvfeol0P4Zc3aP+LQvOjEkJMkcmdm97A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6301
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBNYXkgMjksIDIwMjQgMTA6MjUgQU0sIFRpYW4sIEtldmluIDxrZXZpbi50
aWFuQGludGVsLmNvbT4NCj4gVG86IEFybmQgQmVyZ21hbm4gPGFybmRAa2VybmVsLm9yZz47IFpl
bmcsIFhpbiA8eGluLnplbmdAaW50ZWwuY29tPjsNCj4gQ2FiaWRkdSwgR2lvdmFubmkgPGdpb3Zh
bm5pLmNhYmlkZHVAaW50ZWwuY29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT47IENhbywgWWFodWkgPHlhaHVpLmNhb0BpbnRlbC5jb20+DQo+IENjOiBB
cm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUu
Y2E+Ow0KPiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT47IFNoYW1lZXIgS29sb3Ro
dW0NCj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47IGt2bUB2Z2VyLmtl
cm5lbC5vcmc7IHFhdC0NCj4gbGludXggPHFhdC1saW51eEBpbnRlbC5jb20+OyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0hdIHZmaW8vcWF0OiBhZGQg
UENJX0lPViBkZXBlbmRlbmN5DQo+IA0KPiA+IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAa2Vy
bmVsLm9yZz4NCj4gPiBTZW50OiBUdWVzZGF5LCBNYXkgMjgsIDIwMjQgODowNSBQTQ0KPiA+DQo+
ID4gRnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPg0KPiA+IFRoZSBuZXds
eSBhZGRlZCBkcml2ZXIgZGVwZW5kcyBvbiB0aGUgY3J5cHRvIGRyaXZlciwgYnV0IGl0IHVzZXMg
ZXhwb3J0ZWQNCj4gPiBzeW1ib2xzIHRoYXQgYXJlIG9ubHkgYXZhaWxhYmxlIHdoZW4gSU9WIGlz
IGFsc28gdHVybmVkIG9uOg0KPiA+DQo+ID4geDg2XzY0LWxpbnV4LWxkOiBkcml2ZXJzL3ZmaW8v
cGNpL3FhdC9tYWluLm86IGluIGZ1bmN0aW9uDQo+ID4gYHFhdF92Zl9wY2lfb3Blbl9kZXZpY2Un
Og0KPiA+IG1haW4uYzooLnRleHQrMHhkNyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYHFhdF92
Zm1pZ19vcGVuJw0KPiA+IHg4Nl82NC1saW51eC1sZDogZHJpdmVycy92ZmlvL3BjaS9xYXQvbWFp
bi5vOiBpbiBmdW5jdGlvbg0KPiA+IGBxYXRfdmZfcGNpX3JlbGVhc2VfZGV2JzoNCj4gPiBtYWlu
LmM6KC50ZXh0KzB4MTIyKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcWF0X3ZmbWlnX2NsZWFu
dXAnDQo+ID4geDg2XzY0LWxpbnV4LWxkOiBtYWluLmM6KC50ZXh0KzB4MTJkKTogdW5kZWZpbmVk
IHJlZmVyZW5jZSB0bw0KPiA+IGBxYXRfdmZtaWdfZGVzdHJveScNCj4gPiB4ODZfNjQtbGludXgt
bGQ6IGRyaXZlcnMvdmZpby9wY2kvcWF0L21haW4ubzogaW4gZnVuY3Rpb24NCj4gPiBgcWF0X3Zm
X3Jlc3VtZV93cml0ZSc6DQo+ID4gbWFpbi5jOigudGV4dCsweDMwOCk6IHVuZGVmaW5lZCByZWZl
cmVuY2UgdG8gYHFhdF92Zm1pZ19sb2FkX3NldHVwJw0KPiA+IHg4Nl82NC1saW51eC1sZDogZHJp
dmVycy92ZmlvL3BjaS9xYXQvbWFpbi5vOiBpbiBmdW5jdGlvbg0KPiA+IGBxYXRfdmZfc2F2ZV9k
ZXZpY2VfZGF0YSc6DQo+ID4gbWFpbi5jOigudGV4dCsweDY0Yyk6IHVuZGVmaW5lZCByZWZlcmVu
Y2UgdG8gYHFhdF92Zm1pZ19zYXZlX3N0YXRlJw0KPiA+IHg4Nl82NC1saW51eC1sZDogbWFpbi5j
OigudGV4dCsweDY3Nyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gPiBgcWF0X3ZmbWlnX3Nh
dmVfc2V0dXAnDQo+ID4geDg2XzY0LWxpbnV4LWxkOiBkcml2ZXJzL3ZmaW8vcGNpL3FhdC9tYWlu
Lm86IGluIGZ1bmN0aW9uDQo+ID4gYHFhdF92Zl9wY2lfYWVyX3Jlc2V0X2RvbmUnOg0KPiA+IG1h
aW4uYzooLnRleHQrMHg4MmQpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBxYXRfdmZtaWdfcmVz
ZXQnDQo+ID4geDg2XzY0LWxpbnV4LWxkOiBkcml2ZXJzL3ZmaW8vcGNpL3FhdC9tYWluLm86IGlu
IGZ1bmN0aW9uDQo+ID4gYHFhdF92Zl9wY2lfY2xvc2VfZGV2aWNlJzoNCj4gPiBtYWluLmM6KC50
ZXh0KzB4ODYyKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcWF0X3ZmbWlnX2Nsb3NlJw0KPiA+
IHg4Nl82NC1saW51eC1sZDogZHJpdmVycy92ZmlvL3BjaS9xYXQvbWFpbi5vOiBpbiBmdW5jdGlv
bg0KPiA+IGBxYXRfdmZfcGNpX3NldF9kZXZpY2Vfc3RhdGUnOg0KPiA+IG1haW4uYzooLnRleHQr
MHg5YWYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBxYXRfdmZtaWdfc3VzcGVuZCcNCj4gPiB4
ODZfNjQtbGludXgtbGQ6IG1haW4uYzooLnRleHQrMHhhMTQpOiB1bmRlZmluZWQgcmVmZXJlbmNl
IHRvDQo+ID4gYHFhdF92Zm1pZ19zYXZlX3N0YXRlJw0KPiA+IHg4Nl82NC1saW51eC1sZDogbWFp
bi5jOigudGV4dCsweGIzNyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gPiBgcWF0X3ZmbWln
X3Jlc3VtZScNCj4gPiB4ODZfNjQtbGludXgtbGQ6IG1haW4uYzooLnRleHQrMHhiYzcpOiB1bmRl
ZmluZWQgcmVmZXJlbmNlIHRvDQo+ID4gYHFhdF92Zm1pZ19sb2FkX3N0YXRlJw0KPiANCj4gYXQg
YSBnbGFuY2UgdGhvc2UgdW5kZWZpbmVkIHN5bWJvbHMgZG9uJ3QgdXNlIGFueSBzeW1ib2wgdW5k
ZXINCj4gSU9WLiBUaGV5IGFyZSBqdXN0IHdyYXBwZXJzIHRvIGNlcnRhaW4gY2FsbGJhY2tzIHJl
Z2lzdGVyZWQgYnkNCj4gYnkgcmVzcGVjdGl2ZSBxYXQgZHJpdmVycyB3aGljaCBzdXBwb3J0IG1p
Z3JhdGlvbi4NCj4gDQo+IFByb2JhYmx5IHRoZXknZCBiZXR0ZXIgYmUgbW92ZWQgb3V0IG9mIENP
TkZJR19QQ0lfSU9WIGluDQo+ICJkcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9N
YWtlZmlsZSIgdG8gcmVtb3ZlDQo+IHRoaXMgZGVwZW5kZW5jeSBpbiB2ZmlvIHZhcmlhbnQgZHJp
dmVyLg0KPiANCg0KVGhhbmtzLCBLZXZpbiA6LSkuIFRoaXMgZGVwZW5kZW5jeSBpcyBsaWtlIHRo
ZSByZWxhdGlvbnNoaXAgYmV0d2VlbiB0aGUgUUFUIHZmaW8NCnZhcmlhbnQgZHJpdmVyIGFuZCBt
YWNybyBDUllQVE9fREVWX1FBVF80WFhYLiBUaGUgdmFyaWFudCBkcml2ZXIgZG9lc24ndA0KZGly
ZWN0bHkgcmVmZXJlbmNlIHRoZSBzeW1ib2xzIGV4cG9ydGVkIGJ5IG1vZHVsZSBxYXRfNHh4eCB3
aGljaCBpcyBwcm90ZWN0ZWQNCmJ5IENSWVBUT19ERVZfUUFUXzRYWFgsIGJ1dCByZXF1aXJlcyB0
aGUgbW9kdWxlIHFhdF80eHh4IGF0IHJ1bnRpbWUgc28gZmFyLg0KQWxleCBzdWdnZXN0ZWQgdG8g
cHV0IENSWVBUT19ERVZfUUFUXzRYWFggYXMgdGhlIGRlcGVuZGVuY3kgb2YgdGhpcyB2YXJpYW50
DQpkcml2ZXIuDQpGb3IgQ09ORklHX1BDSV9JT1YsIGlmIGl0IGlzIGRpc2FibGVkLCB0aGlzIHZh
cmlhbnQgZHJpdmVyIGRvZXNuJ3Qgc2VydmUgdGhlIHVzZXIgYXMNCndlbGwgc2luY2Ugbm8gVkZz
IHdpbGwgYmUgY3JlYXRlZCBieSBRQVQgUEYgZHJpdmVyLiBUbyBrZWVwIHRoZSBjb25zaXN0ZW5j
eSwgaXQgbWlnaHQNCmJlIHJpZ2h0IHRvIG1ha2UgaXQgYXMgdGhlIGRlcGVuZGVuY3kgb2YgdGhp
cyB2YXJpYW50IGRyaXZlciBhcyBBcm5kIHBvaW50ZWQgb3V0Lg0KV2hhdCBkbyB5b3UgdGhpbms/
DQoNClRoYW5rcywNClhpbg0KDQo+ID4NCj4gPiBBZGQgdGhpcyBhcyBhIHNlY29uZCBkZXBlbmRl
bmN5Lg0KPiA+DQo+ID4gRml4ZXM6IGJiMjA4ODEwYjFhYiAoInZmaW8vcWF0OiBBZGQgdmZpb19w
Y2kgZHJpdmVyIGZvciBJbnRlbCBRQVQgU1ItSU9WIFZGDQo+ID4gZGV2aWNlcyIpDQo+ID4gU2ln
bmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy92ZmlvL3BjaS9xYXQvS2NvbmZpZyB8IDMgKystDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3ZmaW8vcGNpL3FhdC9LY29uZmlnIGIvZHJpdmVycy92ZmlvL3BjaS9xYXQvS2NvbmZp
Zw0KPiA+IGluZGV4IGJmNTJjZmE0YjU5NS4uZmFlOWQ2Y2I4Y2NiIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvdmZpby9wY2kvcWF0L0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNp
L3FhdC9LY29uZmlnDQo+ID4gQEAgLTEsOCArMSw5IEBADQo+ID4gICMgU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPiA+ICBjb25maWcgUUFUX1ZGSU9fUENJDQo+ID4gIAl0
cmlzdGF0ZSAiVkZJTyBzdXBwb3J0IGZvciBRQVQgVkYgUENJIGRldmljZXMiDQo+ID4gLQlzZWxl
Y3QgVkZJT19QQ0lfQ09SRQ0KPiA+ICAJZGVwZW5kcyBvbiBDUllQVE9fREVWX1FBVF80WFhYDQo+
ID4gKwlkZXBlbmRzIG9uIFBDSV9JT1YNCj4gPiArCXNlbGVjdCBWRklPX1BDSV9DT1JFDQo+ID4g
IAloZWxwDQo+ID4gIAkgIFRoaXMgcHJvdmlkZXMgbWlncmF0aW9uIHN1cHBvcnQgZm9yIEludGVs
KFIpIFFBVCBWaXJ0dWFsIEZ1bmN0aW9uDQo+ID4gIAkgIHVzaW5nIHRoZSBWRklPIGZyYW1ld29y
ay4NCj4gPiAtLQ0KPiA+IDIuMzkuMg0KDQo=

