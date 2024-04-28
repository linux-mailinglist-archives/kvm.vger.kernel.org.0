Return-Path: <kvm+bounces-16120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5CA8B4A1B
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 08:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1515B281E61
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 06:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FE03FBAF;
	Sun, 28 Apr 2024 06:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aE/rFzsO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9103D0AF
	for <kvm@vger.kernel.org>; Sun, 28 Apr 2024 06:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714285177; cv=fail; b=gkdOW0GxXbQTBzQ+bdQj/3BuQrVyGCPGF+VMj/LcEtF7x3DCDETsYIRgudkDYqC8P6Qqzk24CfCsRUSGLvTbrYzUR97VMf+IffdjTDfLnn6kmdxayMZWmXjGqTDxug0L4WDccKOjGFbHa/ww6wYO1k1wBhP5U5COpuY+HLUd8po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714285177; c=relaxed/simple;
	bh=nDso6TLUdOY6wo4yqF10MD3fKaF5t+m8PLFvgTuQXzI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jitkdicm09JlZm8YJ3WGabYkKd7pqpP+ea2d8FC4+2B28kPzPZfuO/y+JZJ6oHbpr3Tr/ASoAHRrB2e0ZOnHxK4KZ0jINS6jbMdV4eTCG3iK0vlKOgDAXzL0Mk8+DJIZTBhC7DqzAEgiIjp5/pViHuihvAkHrLGqfd3pOWaYh7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aE/rFzsO; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714285175; x=1745821175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nDso6TLUdOY6wo4yqF10MD3fKaF5t+m8PLFvgTuQXzI=;
  b=aE/rFzsOQGL/ElLE4ff6EZDvdZIG5EJrznUvDqg53ZmlA6ndk+O0RtbL
   E3VGB5MTiGMAleq1YLa7aFZtZ0E0kZL7WDJl/wlPmIL+7LmGw1ApOzrJH
   gBKso88/YUR8wLzdF/jLCpGukkDtrp4WbwkqNqMSGJSE+21lhGZDUL7H2
   wgYWM/ykjqqGFPI8Bvvtf9uSI0rRsokyGADc0QwS/UD2WchVwKP/7dMYF
   sh8ikhU6uGyJdrfSr9Gzfi6yZGvCeXb2Qj3GyygNUmvobfdXvdU+WnvQk
   uJpK2MB7TNA3Ugsn1mvy0EREnFpeFmq7n9cILvLTpEGNj4Vx/rQQZtwJZ
   A==;
X-CSE-ConnectionGUID: NYSbVKBASdOWuSga5Pnwwg==
X-CSE-MsgGUID: 5QfGlIWqQpy87l++eYaO1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21382777"
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="21382777"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 23:19:35 -0700
X-CSE-ConnectionGUID: BNV4Tv91QMSwLtAQGcLfDg==
X-CSE-MsgGUID: ld58Ym/9SaCfgU3AuygiMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="30627570"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Apr 2024 23:19:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Apr 2024 23:19:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Apr 2024 23:19:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 27 Apr 2024 23:19:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 27 Apr 2024 23:19:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkYtSCfVQUhlwk5rUbjE1T33Rg6ligwkhNoHxQ92sBVBv30PkfJXo3o7/4mHYdzQnzz7plpEIOUSnHkiJwqz1R8MXQSlPnylDm4TuxnBVO/cELAcEOqdIE/Np7NZzTGmoOp/Mk+hyCfE+k1DASm3KlvLjkYXNFry4BJ2KJE7o94rChLjiLBTVKwkN+d6FaK8lITZY7yPuHVDpHUfN4n3x8m07xhcZLvri2yGaiQwPpxhyIWdb993fDCUJDIjPEB/DYLC0/FOtzvms66WWz5AHkct30vh2m7hH+3bJ7JilWSjiL0WGBSHuzOfId5oT44ueEjcX7HuT2T+xFLFnvDOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7bsRMWfN1QTrmJe865IcI0bWFGSO89t55XefX3LDRE=;
 b=FFTPI4GyeQauB1qcF+bpgw3xFqqApvJ1J2q11p1mnQnJyg/acY8K0eLRsmOQh9W0Gn0VVc/51qJOYE7Ds/Bd4S5fje4aWdObqXvdSFKWmW7pDlzasif/vPJfhy9iyM8U6hhWUuzdEd+EYVDDPFF33AMfSMhYDEY7xAfKkmGs/HVXR0YqD3UYDskaWWeu24BEUy3Qk72WmHLljy82M0Oimd8Hz+6YcBNJDXpm2ER1eZb8hod6psl/4CuXHNycD7El7gnbZHq6k2x5qsdKR2k1X7zZuGneh34alMw1rgi9oyB9tBUOY6nuuNOHxJdZCg1JoTv4A/1IcG/t1HyKwzn7eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Sun, 28 Apr
 2024 06:19:30 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%5]) with mapi id 15.20.7519.031; Sun, 28 Apr 2024
 06:19:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?iso-8859-1?Q?C=E9dric_Le_Goater?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgAIv5SA=
Date: Sun, 28 Apr 2024 06:19:29 +0000
Message-ID: <BL1PR11MB527133859BC129E2F65A61718C142@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
In-Reply-To: <20240426141354.1f003b5f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SJ0PR11MB4989:EE_
x-ms-office365-filtering-correlation-id: 4ea590db-c2f8-4a59-4f14-08dc674b298b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?P/jeNkxtdPCiZu5iyHk3hyj8Tt4kwRUbzdDIZ5bkyaz6bTAmPSfWMoRFBG?=
 =?iso-8859-1?Q?BR+jlFcMw1JvSs0hMi5y46Jyse8ZGRKrox067Y5ZGWdv7O/cSwn+ykaLOK?=
 =?iso-8859-1?Q?q9QHkEetHVeQaDdBDrroSxcfYtKOPunBt9j3ApSaXh7wtG4POd7q/vuC2V?=
 =?iso-8859-1?Q?90i2AsVCHtcUOS1mxOcDRaOyYXSro+AIVTDmMIgu4rfKQMx2ehdkBuIudA?=
 =?iso-8859-1?Q?AdmdFYKP1Th3oFO/f65FRTgcwlItBQekZYzKD2qnGQAVTqXg18X5+6H65w?=
 =?iso-8859-1?Q?+eT8QN4D2xavcR4kvTxq1l50hRhZBJqWOLz8wRSqGJ/5BGSS+jXmCYcx/i?=
 =?iso-8859-1?Q?oynSPxJCFtcR9q48XhnsONa21U9Gb/vX3R9EelQMueU0tUiuBSRVA3p90+?=
 =?iso-8859-1?Q?XyZMSVXZualjQptuwash33yqhcewGmFbv/z0qqNS52+xfBDNn5IUHodgeu?=
 =?iso-8859-1?Q?mziMS6UV/xX30ptfJtJL+koXpUSGJvnIZvAng0DJNRzOj6JtnuD4duVrlT?=
 =?iso-8859-1?Q?0VSQcKqUIDfaP781QCfLHARVfRANNy+EpzIomgZ4lckaXW0XzZqlCqjHVp?=
 =?iso-8859-1?Q?4Z4RoPZdRbe/cErX87SMiaUsazfmN63NenzKNaIkhg9S2qBHDe+pZyg6Sf?=
 =?iso-8859-1?Q?1Gxk6mMZP/VBGHt55L8/OUmZdBq2jiNHWsNd2o4C43OL1lYcTMmN4SZ3t7?=
 =?iso-8859-1?Q?9gF9IV3K4JgQGhKjKNP3nRDHFbvNiK2/Jy2lQ2j+mC/wVVaTmgmOTsn2WP?=
 =?iso-8859-1?Q?wVnCudazEozzH/TRzXIebwC/oVOC6d0Hy7YcjVG9I9cKt3nG87eIXcaj7h?=
 =?iso-8859-1?Q?BzaaCXJr81p4LDeHh1n04FddXWX1NvyCmvBJshsGuHW0//Hm0H+QMvQ5zf?=
 =?iso-8859-1?Q?qa1kNcVpndaZTIeR2xC6OpKX6Kss3twBJN19DvUCNAufwXTACV8HeOKQxP?=
 =?iso-8859-1?Q?jW//uRsIA4lZMeW76fLMKPkdY+qp8l8xK3XPDfVXVJF9sj4pjueentiEbU?=
 =?iso-8859-1?Q?uJNAM3kl1g9KJL35DV3um66tdM6oBqsbR6Zr98IJdFRfFpmmAa6ybNMpN6?=
 =?iso-8859-1?Q?IBQ5Lbb863Y7LVNBXA6F3pXJRxv725g4z5kTRTTPl2vfQKHc6RDLnUTVPg?=
 =?iso-8859-1?Q?T3egsOBjlb8Cs/C/t+ukDLxhhjXAxOnHED3nvgRBCWxA+gIasGIxHnz/c2?=
 =?iso-8859-1?Q?Cf6pkoErhPg01GyznmEsabc2KY9nwxUzRatDzYxBgp9RSapmP48rDKXXma?=
 =?iso-8859-1?Q?rZ4+vwq3RpKpWmiTSKNFE3rpTSKISatVBkpxv2MQcw7qqJQMxEf5WpPKgU?=
 =?iso-8859-1?Q?1iSXCdtZASEGxsFOQcWleQE1+ixrAOyZ3NErQ9Vx2r8dd/tN6wS+HFf7IJ?=
 =?iso-8859-1?Q?bIL5i9moTyP1O23AzKIGqbh3FtiFntsQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?dMgDrDDAfYVLlRzkET4cWXftGYy+hzMAMDANxOvBR42j3e9Pd6avQMCqQP?=
 =?iso-8859-1?Q?iYLcPGfdNvhLU//i/uwvg7sp0Qblj3IOjCU3eVIxuivAEpilz2s2gixFcr?=
 =?iso-8859-1?Q?iZmKaySa289t08xXFGczKWMIcQcAt6/sQqDLBp8dG0/ocFSPBONESPE71t?=
 =?iso-8859-1?Q?V71V7tMlHPjam9vx+KiJ0XZq9SS3wDd5RDj8PNoL4BLn13LNTIZddgMwTW?=
 =?iso-8859-1?Q?VBxJyh6XsufFzl/hUCAQf2NhMJYC84bXd3A9Vk8sGtVmq7yVr49ZtHphDD?=
 =?iso-8859-1?Q?A6ENmeOUNGyNZzYnl3BoL5FOTNQ0i5i+bSLA8WXSPMnw9gSnz+DV8v+J+X?=
 =?iso-8859-1?Q?HyJyRxyApt6cHT6lzN5hFjZhJZpscmcCL+uGoQ3DAlLoTO/vBLRWaXceni?=
 =?iso-8859-1?Q?+FhtQRyxLbs5ScTWksd9KQRKVDlh97eJWMYr1qXDXEfJlnR1dEImi6XSUv?=
 =?iso-8859-1?Q?fwybTkyf6rBFT21j3wJsSab2D6Exd7acEPQluQ0/9Id0m6ZiJjH2JeNkOd?=
 =?iso-8859-1?Q?XNat5mH8Dfg1RaY4n9zXrO4Di+CQkW7oYG5dU3gIfSVPgw1K5YJBsTTjm5?=
 =?iso-8859-1?Q?ymVYGdMBDltsCl4MSXIJ1Csyq7cM1CVEB0FW5xj14NdpEwVVTYcY41nAb9?=
 =?iso-8859-1?Q?kHiQaGIhz79+nV3ApUhdIWiNvVzgqSdBjFO+mXdRAIf0I5msyguyHtL+Se?=
 =?iso-8859-1?Q?PGyjTYarZh6pRUmJ/9R8VtXm0wG7/rZDsfJUbRQkccgDHlxnQ7ejsCD51Y?=
 =?iso-8859-1?Q?PSVSNN0VPSc5Ttsl9wsIEvaI2oPeU+SNVsO3lDxfXiAy6tnsBQTBErw92L?=
 =?iso-8859-1?Q?iSXFSHyrUKuKXJxLco/8zUYFbfDWXX99XVjWfjnW372BZoRF5yI9y6zqX4?=
 =?iso-8859-1?Q?ai+Xm93C0wUJijXON6AlXWeWQnPsNqa2r08puStGpsJwK9Hs3mQMZLdufW?=
 =?iso-8859-1?Q?Vr/C6cv3VFG/hdxp+2rCPe7d+AgecdOwDCOrnAynCA0jy1/qPIGwgC3jb1?=
 =?iso-8859-1?Q?lufVYd5/t2BkUxqbYQniRAZ2frhGfxnrrssMqTfE7v+VzeYj/WmYrbomLi?=
 =?iso-8859-1?Q?6GmQ1G6a4PYp4GrsnYTi/04n8mkf9BzzKg/M8eyDrRRYOQChM8uOBwm6tO?=
 =?iso-8859-1?Q?BL/ABoRluLKIyNOkcayAWMTKhGek+hQpXJtC/0J47ki38Fl9qJ97eifHBP?=
 =?iso-8859-1?Q?CW2sf3gbhuHahrEvCEeE4y8bS53J6WMkAXXl06gLjur+r0vD1th4kKteGx?=
 =?iso-8859-1?Q?MdHFbb8O6vGsL8mLEmLDknVkX1keCoZ+8YPxiHlIb4CrCuNXNdVWKd8fzl?=
 =?iso-8859-1?Q?TVWWtQVT4OoPXiXrix12p3eY8ElB+/PDDO440TjLhePClKn8OQDCLSn9v0?=
 =?iso-8859-1?Q?0Tdx8YXZCwisSKRIS/plPR7HJBTt9ny4CwRgfNgiPlN1JfuxpdiZ0VQ6Tb?=
 =?iso-8859-1?Q?m56Xxc5k3AwN2C2S90ox8i44VZ+Xu965rH4BzIn4ac9bdDgXC3ejSuPlS2?=
 =?iso-8859-1?Q?xJK+rmCJHHCX+uWBR9DvyvY5YTnoOq0/NwTRb6vRPEeeUIcAqd+bE++g8Y?=
 =?iso-8859-1?Q?R+vKBo96O+NHtTKFDQadFfXAUML8EVCn3dn3Rra8j+N8A4qa4oaG0Xo6mP?=
 =?iso-8859-1?Q?gTsiSCKdOYA1cZY2OqS/eT1dWZmXSaBLyv?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea590db-c2f8-4a59-4f14-08dc674b298b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2024 06:19:29.6429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEgAdv+g/2OslJZDcZ9yohhwhC0OuRRX/NZtsCdYtJwOEGq90PvARF2tb3v6CeigrlM/vxSJSIqlM5dXwXZzVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4989
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 27, 2024 4:14 AM
>=20
> On Fri, 26 Apr 2024 11:11:17 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
> >
> > > This is kind of an absurd example to portray as a ubiquitous problem.
> > > Typically the config space layout is a reflection of hardware whether
> > > the device supports migration or not.
> >
> > Er, all our HW has FW constructed config space. It changes with FW
> > upgrades. We change it during the life of the product. This has to be
> > considered..
>=20
> So as I understand it, the concern is that you have firmware that
> supports migration, but it also openly hostile to the fundamental
> aspects of exposing a stable device ABI in support of migration.
>=20
> > > If a driver were to insert a
> > > virtual capability, then yes it would want to be consistent about it =
if
> > > it also cares about migration.  If the driver needs to change the
> > > location of a virtual capability, problems will arise, but that's als=
o
> > > not something that every driver needs to do.
> >
> > Well, mlx5 has to cope with this. It supports so many devices with so
> > many config space layouts :( I don't know if we can just hard wire an
> > offset to stick in a PASID cap and expect that to work...

Are those config space layout differences usually also coming with
mmio-side interface change? If yes there are more to handle for
running V1 instance on V2 device and it'd make sense to manage
everything about compatibility in one place.

If we pursue the direction deciding the vconfig layout in VMM, does
it imply that anything related to mmio layout would also be put in
VMM too?

e.g. it's not unusual to see a device mmio layout as:

	REG_BASE:  base addr of a register block in a BAR
	REG_FEAT1_OFF: feature1 regs offset in the register block
	REG_FEAT2_OFF: feature2 regs offset in the register block
	...

Driver accesses registers according to those read-only offsets.

A FW upgrade may lead to change of offsets but functions stay the
same. An instance created on an old version can be migrated to=20
the new version as long as accesses to old offsets are trapped
and routed to the new offsets.

Do we envision things like above in the variant driver or in VMM?

> > >
> > > What are you actually proposing?
> >
> > Okay, what I'm thinking about is a text file that describes the vPCI
> > function configuration space to create. The community will standardize
> > this and VMMs will have to implement to get PASID/etc. Maybe the
> > community will provide a BSD licensed library to do this job.
> >
> > The text file allows the operator to specify exactly the configuration
> > space the VFIO function should have. It would not be derived
> > automatically from physical. AFAIK qemu does not have this capability
> > currently.
> >
> > This reflects my observation and discussions around the live migration
> > standardization. I belive we are fast reaching a point where this is
> > required.
> >
> > Consider standards based migration between wildly different
> > devices. The devices will not standardize their physical config space,
> > but an operator could generate a consistent vPCI config space that
> > works with all the devices in their fleet.

It's hard to believe that 'wildly different' devices only have difference
in the layout of vPCI config space.=20

> >
> > Consider the usual working model of the large operators - they define
> > instance types with some regularity. But an instance type is fixed in
> > concrete once it is specified, things like the vPCI config space are
> > fixed.
> >
> > Running Instance A on newer hardware with a changed physical config
> > space should continue to present Instance A's vPCI config layout
> > regardless. Ie Instance A might not support PASID but Instance B can
> > run on newer HW that does. The config space layout depends on the
> > requested Instance Type, not the physical layout.
> >
> > The auto-configuration of the config layout from physical is a nice
> > feature and is excellent for development/small scale, but it shouldn't
> > be the only way to work.
> >
> > So - if we accept that text file configuration should be something the
> > VMM supports then let's reconsider how to solve the PASID problem.
> >
> > I'd say the way to solve it should be via a text file specifying a
> > full config space layout that includes the PASID cap. From the VMM
> > perspective this works fine, and it ports to every VMM directly via
> > processing the text file.
> >
> > The autoconfiguration use case can be done by making a tool build the
> > text file by deriving it from physical, much like today. The single
> > instance of that tool could have device specific knowledge to avoid
> > quirks. This way the smarts can still be shared by all the VMMs
> > without going into the kernel. Special devices with hidden config
> > space could get special quirks or special reference text files into
> > the tool repo.
> >
> > Serious operators doing production SRIOV/etc would negotiate the text
> > file with the HW vendors when they define their Instance Type. Ideally
> > these reference text files would be contributed to the tool repo
> > above. I think there would be some nice idea to define fully open
> > source Instance Types that include VFIO devices too.
>=20
> Regarding "if we accept that text file configuration should be
> something the VMM supports", I'm not on board with this yet, so
> applying it to PASID discussion seems premature.
>=20
> We've developed variant drivers specifically to host the device specific
> aspects of migration support.  The requirement of a consistent config
> space layout is a problem that only exists relative to migration.  This
> is an issue that I would have considered the responsibility of the
> variant driver, which would likely expect a consistent interface from
> the hardware/firmware.  Why does hostile firmware suddenly make it the
> VMM's problem to provide a consistent ABI to the config space of the
> device rather than the variant driver?
>=20
> Obviously config maps are something that a VMM could do, but it also
> seems to impose a non-trivial burden that every VMM requires an
> implementation of a config space map and integration for each device
> rather than simply expecting the exposed config space of the device to
> be part of the migration ABI.  Also this solution specifically only
> addresses config space compatibility without considering the more
> generic issue that a variant driver can expose different device
> personas.  A versioned persona and config space virtualization in the
> variant driver is a much more flexible solution.  Thanks,
>=20

and looks this community lacks of a clear criteria on what burden
should be put in the kernel vs. in the VMM.

e.g. in earlier nvgrace-gpu discussion a major open was whether
the PCI bar emulation should be done by the variant driver or
by the VMM (with variant driver providing a device feature).

It ends up to be in the variant driver with one major argument
that doing so avoids the burden in various VMMs.

But now seems the 'text-file' proposal heads the opposite direction?

btw while this discussion may continue some time, I wonder whether
this vPASID reporting open can be handled separately from the
pasid attach/detach series so we can move the ball and merge
something already in agreement. anyway it's just a read-only cap so
won't affect how VFIO/IOMMUFD handles the pasid related requests.

Thanks
Kevin


