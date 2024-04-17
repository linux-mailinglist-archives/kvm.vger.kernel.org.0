Return-Path: <kvm+bounces-14935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DC18A7CD3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FEB01F2224F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE666A346;
	Wed, 17 Apr 2024 07:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7NP19Zw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5525E6A332
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 07:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713337797; cv=fail; b=ZhIEjV1ibQEWf9lssIgPPONvD4ReCrkbXEj9+MgO8uuDWW3a92V2M/o3PqJwEdicrpDgN6n18lfhKLDQ+FmhhXr5sIHTomSOhh7QYVQrjUqvBAAlb+vjrNLzY8kkg/2qfSALbJm2vO2jW61ze0ck4MLV4TyEzmoFDC9wf20E81o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713337797; c=relaxed/simple;
	bh=sUk4Zht55EiRBJ+dr+7JNaaDU+op0wSb6BstssVuWMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=as/oChFk5Gn2EQaVQbPWCtsN1HjIsn1Qrmas1KmzA0TXZGFox60GTZw9MSTi9TQrZlSeW04fLiJfhCm8JtgJ0HsnfM9WDYXhKWxZoYuXDA8PdUXTIaxGZ+AqgPi2DVY7wnVblnBob1UtHJrbnptrzEaRCjJN2Z0Xk2FWQUXbZts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7NP19Zw; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713337796; x=1744873796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUk4Zht55EiRBJ+dr+7JNaaDU+op0wSb6BstssVuWMI=;
  b=B7NP19ZwEDL6ecgKLLaQBfKrQeqMkvbFeECyOiEMFZ/IxC1p42AEATfY
   gGMwtQjrUZ59SUOjsi9J7rTd1ZZ+E8GQNcSK6cbSk5pgTjTcJuhFq85v3
   hZu03lmFSHVrtI2N/tiJtV3MCRTE2YgNemhA2jkevqX471YYnk9gVd1FL
   i93zXwXlMF2Zw1OkC1B0k8+w7mgZrOQPr8LW3QZIqxwYxmAfkCSzvXZ3v
   4XlEpih+pZRsoIEpssFRNjIVJdPgN2Tc6CfM+tFogHE5Hye7pK+N0s+UY
   ay5JMmQV2ywJqCK4PvE6/C1wi5to5rfqIgA8ClZSgLx7gbd5WnGQCTpYP
   w==;
X-CSE-ConnectionGUID: VaRl7jTSR/2sbaeZ28IXtQ==
X-CSE-MsgGUID: nTjmboCPQb+X1qwIbmsO/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8673853"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8673853"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:09:55 -0700
X-CSE-ConnectionGUID: ML8NexxeT16d4fjvDXXpdQ==
X-CSE-MsgGUID: TQmb2Ds/Q02Y/PihaXADrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22599444"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 00:09:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:09:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:09:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 00:09:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 00:09:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ygg+fOKHn6PqKgSgLBArUyFpvz7B/kW5F6OiBsMn4xzjD+/XiNTtnYAfSzdUxmZyNwIzdksTOyxX2Q7N8h7q8/+i98DAFUGI86RCVKjlW6ew++eZNfse+m2IWXxwTPiw9Nxal6OJHYh1CvP7rf2eJ6ft5MRf0hP+e126IRWD/xDnf+qjtQnBN/tyCaBmyob09przkVqn22wm9aOf4Wr+srqfrPu5EdcmdO3ySlQn+XtxoiQhZselhsNQ1auK71qYaGkR6FYhoZxBwik0++LNv8sPzUIWiYeZxNeux5bRd2ZdgdI6ZwZElUsRtnTE+c1gyuv6SptGh0Hndr76z9JXQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUk4Zht55EiRBJ+dr+7JNaaDU+op0wSb6BstssVuWMI=;
 b=lf+4obtmGLik32YlV65v7uC5gnexagWoqJ/BDw/JYoh+10vKUcWYqxbM+j7XQIBVAHkojfpeKqO3G/gOmCmOIReMgJknBK9ivi5LH9Ad46R6xFU/j5fBLbDnTn2F9bi7q2swYw40t4YT6DTNH+VrCAUpHJh5Cez6su805Kvv/fgQa+kibhpRq8tjvHZnaablCUalXpFRzZz/xRca1tKh5c6gQ5MurQ/cqVyVCUXKuDIdAqQGj+oFglfeyzDOb7hrMImFh5q8kUQgkBCvam86vW6wfmWG5weHQPG5UFg+sK46hr2aJ0S3ZJktOmhk01+D/4aNLmEdJU1+RjjmLT5hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.25; Wed, 17 Apr
 2024 07:09:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 07:09:52 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Topic: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Index: AQHajLJzYiLjOoAxokK40c4Rfn6iJLFrNasAgADa8xA=
Date: Wed, 17 Apr 2024 07:09:52 +0000
Message-ID: <BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-5-yi.l.liu@intel.com>
 <20240416115722.78d4509f.alex.williamson@redhat.com>
In-Reply-To: <20240416115722.78d4509f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN6PR11MB8243:EE_
x-ms-office365-filtering-correlation-id: 66c94732-8862-4f23-79ff-08dc5ead60fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Dwelpz3+ILr63xGdCWkdpKNKhETXRYFgddGOgnNCHYRIzjbjV0MW+5g4+VSRqqKL36O4ThOOt1pgOa2vpxRZF61whyOivJtok8QcttjDuGgrqoBzPABITH3WpWWAO+0kWgE1IB2PGkA+TmgpxmsRqIsGuZi95XFzpZLjWp4XYqIfZwm2+/Xqitg+fyK21Rlv9Mc7f3DD5oEX1tJsC5KEtM6p1PZoFD3xRCCGKzim7M+Qw7TD5T6IqcBSRIEnaLsIpoNrIHQfeV3Z+7M0BwyYdoUWnjt0vujpSvNUCSRhpFwtLCcLPH+RnZqWbi3t/eqLNAEgKFNXdLB8VbCcKXHSV61Hxon08McBB3btP1SyZCT/J6PmjybgVB5F2dyTVdQnpNKXtZXCGW0eIdfWXp6CpdlAIQizNraY7mbVV+7QfEOMoIILfucz24U4jQilVTcBKP9pyn0klanggH4a4RyN4mGYBcfRwuDHb3Noe3WvJc0zodfNCiXveLtN+MYfTOiOiQcxZH9AtpTobMBeuQOWyszcRTQbK1zeJSZJ9fwxmiBEOMkXnQ5Lv81ohhT2fVZfGMibvu8MU9cdJui7D8rp00UCbgSdR/bdCcSsKFUSTZlpo08MHzswrIj21ZqtJuzJxipZbMKfNVXkoN5J7Kh9wOrjfR4/8IA0H2EoH4CS6v3Iykfyo+zQxS1MI+BYkWYJevN+bf4LafwcNXEbfLazQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2xUWmJPQ2hzdjcxQmg3MlZlQTh3N3Y1NXpDbHlSOGJnR3RyYzk0WEh1M3VP?=
 =?utf-8?B?R3Y4YVNUakNBNVlWa3JKY1BYTERBN0h6TjFXdlhUcDQrWVdZNHlZWEFaWFNW?=
 =?utf-8?B?d1Mybkt0SHB5N3FnZGIxU1pYSWQ5MGJia3lNYTU3SmpCR1dCYjM3NE9NQWI5?=
 =?utf-8?B?eE5WaXRmMkFuRWZubXdDMWhEaVFJV0h1UnNGdWJjbVdpN2NZY1BJT2xMcGNQ?=
 =?utf-8?B?ZFFMMkxRK0grL3lrNmxNSTZUS2RWTldJd2RYd1N2UHpnNjhzNGRHcFRLTFBs?=
 =?utf-8?B?R2F2SGlvNmJCNFBTSHJ4QmNKdndEbGFFWWJTc2NtY0FUNElzZitYd3RXQ3Rs?=
 =?utf-8?B?emp5bzVnTGZ1WE5tSTRlYXMvczZHajlvK1Bnb3hHVjg0SWlHZ0ZwWVg5dGZU?=
 =?utf-8?B?R2dqZzJVYlZXcUtKbFNoWXViWGVJMDB5b0Q3RWUxbC81aXFnVDdGbGpjUURF?=
 =?utf-8?B?dUNldUhhU0xJUWdNREJDTTRSQXVIck12WWtiQVNRZDZONm5oMi81eTJTbmRU?=
 =?utf-8?B?Yi9ERHJwL1diSHRnc2FOUmFUeGpGNzZ3SWR2dVNGQWtSTlZVa1IrUlljYmFo?=
 =?utf-8?B?RnBHZXk1TXE2TUtuZE1CTHNZOFRPTk5MSVdrcWcwSW1MZzdKUzRhRHVkVFNH?=
 =?utf-8?B?eFNUdmVieWhYeXhieDlBY3NhTW9PUFVXcFZFeHZDU3BDNEMzSlpDR3FIRGVm?=
 =?utf-8?B?QmlPR1BDVVJjYnMzaXpLalczN1ZTUUswcnVLbkg2aDlWOTdNK0llY1VVcFVa?=
 =?utf-8?B?eE5SSVZwRW5ZWWdFOXhJRVVsTXVpMllmVC84UFh3UldiNWFJZjI5Y2ZVUlIx?=
 =?utf-8?B?UzJLTFVRVmVOOURVMUpiM0c3Yzc1ZzhKYjJ6eUFmbU0zVlJWYVpnUG1pR2I3?=
 =?utf-8?B?M1RTTHJLaUpjbHcyVk9SUVVQd3Zrczh6bXprejRhZWhSdDk3ZUZuN1pCMEZN?=
 =?utf-8?B?MjQ5dDNmSktwTFB1TFovWWNHbVUxckI0ZGtQWEFKTHFYL1IreGVvSHJIdTZK?=
 =?utf-8?B?Nm95WU5KQi9UUlNYVTB5YUpMUzF1MzJHekozaGNCcnN4enNuQWUzM0hBend0?=
 =?utf-8?B?bzhQSkRwNVdtaWVyWERtYjZMNjRNQW9SSnRJRHdGZ2xIbmxyVk5YQVJ1RVZW?=
 =?utf-8?B?NWVCUy9PMHhJRTJmaCs2U3J4OGtIR0VtR2I1dFZsaklMeXBYS0ZHNFBOamc2?=
 =?utf-8?B?MWtlNG45QWVpTWZXaWhYQjNFNG9QMDZlWjBybkQ0UHQwMVloYW40K0prZHBY?=
 =?utf-8?B?V0orM2U3SGJITThuUGUvc2dwanlydHJLbVNXbVk4K2hyVkVNN2JFS3dLeE9t?=
 =?utf-8?B?dzdpNU5pdE9FZ1lEUDFwOUlNSDZOMDh2RGhYVXVZQTVuM0t0cDZSTHQ2dWMx?=
 =?utf-8?B?WlZpT3QrRWlSZ0JBMUM5Vm1aRDBSQjBKUWhnUXEwVEhOVmFsRjA3dnJTZWQ4?=
 =?utf-8?B?RjZRbHlCRTlZQWx0UG9WRTR1dzdIaDBXTFRpQURhaTFITThWRnk1Qyt4VEc0?=
 =?utf-8?B?NytYUis1VE9NWUlsMTREeEdxczkwOXN2UDY0UmhyOWt0clUyNkROdTFVNklN?=
 =?utf-8?B?MHl5MWdiOGFSZXcrYVpVUTR6RzlSTWpPczhEU3AwNytJc2Q2WmRpTkxIMHJL?=
 =?utf-8?B?ZzVLeS84b1BJTU5iS1RreFcydnI2OGxuY2NtWENnQi9SN2syb292ejVEbFpT?=
 =?utf-8?B?aW9VWlFkY0xVTExNQ2lHVGJZOEFGd0FZekQ3U0dqTU9lVU5yckNyMWhLWURy?=
 =?utf-8?B?YTVJU3hESkpkZ2FaM2h5OHRKUVRSWC9Ub3VrQTZIU01Yd3h6REdWQVdpTW5I?=
 =?utf-8?B?NDlsdlY5UExIOUNjMXRsM3ZFMlNGVkNiN1M4SnRPTFVaQ0ttUW9GRjdxRmQv?=
 =?utf-8?B?SU1vMjdjMkhjUzc1MVVWU25ib1diSnREV2t2L0pPVzJpdVM0eERmQzRYcDVH?=
 =?utf-8?B?bE4zbkh0YnVnRGlWS2ZMUzFDbWkyQkhBdzBPOFNnNVFVWUVMVFpQWkF0dllS?=
 =?utf-8?B?MEtvZ3lFKzRvTGpGM3paOXRHNEE5b3pINU1CS3BjNkpWMU1pSndHUjlFMDNa?=
 =?utf-8?B?Q1BWL09LMGU2TlRHQkhiY1RCSmVyZFlLbEVkWXZCbHhFRlVtK2tJVzdkRXdr?=
 =?utf-8?Q?BGtmGmYyhAps9qhFg2O8aqYOQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c94732-8862-4f23-79ff-08dc5ead60fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 07:09:52.8988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5tdFksNaHNcJErHoxov4TFMvb0wrIxC1qE84w4/ky6ZDkHsN6d20GffdJPHvi8bjtVvCJbELU5JvgI4VlKjp4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEFwcmlsIDE3LCAyMDI0IDE6NTcgQU0NCj4gDQo+IE9uIEZyaSwgMTIg
QXByIDIwMjQgMDE6MjE6MjEgLTA3MDANCj4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdy
b3RlOg0KPiANCj4gPiArICovDQo+ID4gK3N0cnVjdCB2ZmlvX2RldmljZV9mZWF0dXJlX3Bhc2lk
IHsNCj4gPiArCV9fdTE2IGNhcGFiaWxpdGllczsNCj4gPiArI2RlZmluZSBWRklPX0RFVklDRV9Q
QVNJRF9DQVBfRVhFQwkoMSA8PCAwKQ0KPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX1BBU0lEX0NB
UF9QUklWCSgxIDw8IDEpDQo+ID4gKwlfX3U4IHdpZHRoOw0KPiA+ICsJX191OCBfX3Jlc2VydmVk
Ow0KPiA+ICt9Ow0KPiANCj4gQnVpbGRpbmcgb24gS2V2aW4ncyBjb21tZW50IG9uIHRoZSBjb3Zl
ciBsZXR0ZXIsIGlmIHdlIGNvdWxkIGRlc2NyaWJlDQo+IGFuIG9mZnNldCBmb3IgZW11bGF0aW5n
IGEgUEFTSUQgY2FwYWJpbGl0eSwgdGhpcyBzZWVtcyBsaWtlIHRoZSBwbGFjZQ0KPiB3ZSdkIGRv
IGl0LiAgSSB0aGluayB3ZSdyZSBub3QgZG9pbmcgdGhhdCBiZWNhdXNlIHdlJ2QgbGlrZSBhbiBp
bi1iYW5kDQo+IG1lY2hhbmlzbSBmb3IgYSBkZXZpY2UgdG8gcmVwb3J0IHVudXNlZCBjb25maWcg
c3BhY2UsIHN1Y2ggYXMgYSBEVlNFQw0KPiBjYXBhYmlsaXR5LCBzbyB0aGF0IGl0IGNhbiBiZSBp
bXBsZW1lbnRlZCBvbiBhIHBoeXNpY2FsIGRldmljZS4gIEFzDQo+IG5vdGVkIGluIHRoZSBjb21t
aXQgbG9nIGhlcmUsIHdlJ2QgYWxzbyBwcmVmZXIgbm90IHRvIGJsb2F0IHRoZSBrZXJuZWwNCj4g
d2l0aCBtb3JlIGRldmljZSBxdWlya3MuDQo+IA0KPiBJbiBhbiBpZGVhbCB3b3JsZCB3ZSBtaWdo
dCBiZSBhYmxlIHRvIGp1bXAgc3RhcnQgc3VwcG9ydCBvZiB0aGF0IERWU0VDDQo+IG9wdGlvbiBi
eSBlbXVsYXRpbmcgdGhlIERWU0VDIGNhcGFiaWxpdHkgb24gdG9wIG9mIHRoZSBQQVNJRCBjYXBh
YmlsaXR5DQo+IGZvciBQRnMsIGJ1dCB1bmZvcnR1bmF0ZWx5IHRoZSBQQVNJRCBjYXBhYmlsaXR5
IGlzIDggYnl0ZXMgd2hpbGUgdGhlDQo+IERWU0VDIGNhcGFiaWxpdHkgaXMgYXQgbGVhc3QgMTIg
Ynl0ZXMsIHNvIHdlIGNhbid0IGltcGxlbWVudCB0aGF0DQo+IGdlbmVyaWNhbGx5IGVpdGhlci4N
Cg0KWWVhaCwgdGhhdCdzIGEgcHJvYmxlbS4NCg0KPiANCj4gSSBkb24ndCBrbm93IHRoZXJlJ3Mg
YW55IGdvb2Qgc29sdXRpb24gaGVyZSBvciB3aGV0aGVyIHRoZXJlJ3MgYWN0dWFsbHkNCj4gYW55
IHZhbHVlIHRvIHRoZSBQQVNJRCBjYXBhYmlsaXR5IG9uIGEgUEYsIGJ1dCBkbyB3ZSBuZWVkIHRv
IGNvbnNpZGVyDQo+IGxlYXZpbmcgYSBmaWVsZCtmbGFnIGhlcmUgdG8gZGVzY3JpYmUgdGhlIG9m
ZnNldCBmb3IgdGhhdCBzY2VuYXJpbz8NCg0KWWVzLCBJIHByZWZlciB0byB0aGlzIHdheS4NCg0K
PiBXb3VsZCB3ZSB0aGVuIGFsbG93IHZhcmlhbnQgZHJpdmVycyB0byB0YWtlIGFkdmFudGFnZSBv
ZiBpdD8gIERvZXMgdGhpcw0KPiB0aGVuIHR1cm4gaW50byB0aGUgcXVpcmsgdGhhdCB3ZSdyZSB0
cnlpbmcgdG8gYXZvaWQgaW4gdGhlIGtlcm5lbA0KPiByYXRoZXIgdGhhbiB1c2Vyc3BhY2UgYW5k
IGlzIHRoYXQgYSBwcm9ibGVtPyAgVGhhbmtzLA0KPiANCg0KV2UgZG9uJ3Qgd2FudCB0byBwcm9h
Y3RpdmVseSBwdXJzdWUgcXVpcmtzIGluIHRoZSBrZXJuZWwuDQoNCkJ1dCBpZiBhIHZhcmlhbnQg
ZHJpdmVyIGV4aXN0cyBmb3Igb3RoZXIgcmVhc29ucywgSSBkb24ndCBzZWUgd2h5IGl0IA0Kc2hv
dWxkIGJlIHByb2hpYml0ZWQgZnJvbSBkZWNpZGluZyBhbiBvZmZzZXQgdG8gZWFzZSB0aGUNCnVz
ZXJzcGFjZS4g8J+Yig0K

