Return-Path: <kvm+bounces-23817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0619A94E3EE
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 02:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75C4D1F21C2D
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 00:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51D81843;
	Mon, 12 Aug 2024 00:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TIlfNwR6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062B581E;
	Mon, 12 Aug 2024 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723421386; cv=fail; b=GflNUruWXFT+hqJTMRZ+VE7ZfiiXnhaf04tz3m4+LslDMKR2cU0bCRCAs9dsph1XfCWU/BLnH40gAeSgjeXQZElXLAwdUdxWQHvLnuF1tR3csRyPI5WOOY7/B/uaPth8yFNhYdZWWO2ZW5X+y0ksbY7jr7eyBSkD4QDpsFnPciI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723421386; c=relaxed/simple;
	bh=ByoZQuTjVAneRmAWgN3WlrqaE5rcwXEvuFiGG7UkuNI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bYpsybisjkjDml2MlrYg5PRhuU8++ghRW32IryTxvPYkKsAIChsuw3mreH7+89qRjkUTVJl9wTOlAjAueSiPlLExVMJIpF2C5f8Bb1nWvs6SCDGXaSWicEeodG4o5LYtFK6vpFSJe+IwLL2xizN0dfv/69Lkmcfloyk26FpBzsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TIlfNwR6; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723421384; x=1754957384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ByoZQuTjVAneRmAWgN3WlrqaE5rcwXEvuFiGG7UkuNI=;
  b=TIlfNwR6MIiudY3/u6qpgZ3udAjrbt+EXq4xvcetlfCf9NmUArPbRsbv
   AzsF9I9QdUTm3rpbIQi6yZx6pfENmEvPSWWMdtcUsA/ILC5PzAbEZKXR/
   xshZ/RBuPA/HngzEco7SCoQzLf4GZcyubP8NFyIu5XjqndeegLWzD4aXz
   1QOe5iVqOXPZ6UoaHEGDJ+9QB6TBHbgLoY84CZsqyIknLbMELDm50Z8DI
   ds4O7p2vPWHFhx77b/Xqn78doCLWhneZq2F8n10HPdAs6mHs4Fj7pfE4H
   i5HohqvEv6DlI1kwisgLJvmcgAmcHE4Bnz8s6bDhqfvx1omArPZLzK6tH
   Q==;
X-CSE-ConnectionGUID: GYAnUiylQyOeYt4fMlT+rw==
X-CSE-MsgGUID: ul0b85gCReGen1yPExmlYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21645349"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21645349"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2024 17:09:44 -0700
X-CSE-ConnectionGUID: eQE1UWRISLumfeIaXLAUlg==
X-CSE-MsgGUID: VPrLHtv7RmWjEeKmzzr3ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58656841"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Aug 2024 17:09:43 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 11 Aug 2024 17:09:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 11 Aug 2024 17:09:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 11 Aug 2024 17:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iymBNsQ5bjy0OG7K5pqasN5saxezCgYUHFaVSiLy+sxyk0h6Te1NAw5LG8x9OJti7Jk+Pcb9Vmqg9le1rPIXUJeNwyh6FNjhY55yf0Vv7q83SZ4eyFRWLUgc+rI9APYo4WU1yvKuhNKa8Is1PK/YixI8diLIt4dQ9LZpGQn9PyE5eP3+2KJtG+Ss78P1Yn48DgGzGDcO3uHMLvsTTUdnQCPS7a/wQMPH2ahzTLRwJ2UcAOV2TBFA6qbGLhFe2p9iziuaPV1KV2+8EpBHHq3M6dYksWq/3KMuIH5U4mspoMY3G8O1AkJUO/RMRMknsBjlA5AqFio9MwTp8eXW5yB+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByoZQuTjVAneRmAWgN3WlrqaE5rcwXEvuFiGG7UkuNI=;
 b=w1UuMiG76DeJuGTmeMeH7o9W3n3aZmHHyGoHii+ZpRHiW1EGCUglDq1eeI321a9qV+hpusZ4eXbSPZeXgg0Deix2C0yjW4SZKgi6TDCn+9ElGWbSOyriQoqz788SeifNqxxoEaL1K/cCSlrEDxKsN0IJqyI81Sp0CvHcBZ51eXYt0BjpW3hfTOXSaNZWFIIcqjRbUXudnK0fM1ZYYRCWjyF9k84VVfjJHM3irBaeuNSRSnNJIhV4ns0TRZqwrVKN2P8oCFR5ahJIwh2l59iI8uPFzjJfCjsgLpGrdxm/xraCeK6sKvsVwrOn1Nn/dFXlYXzpCUEApN+UUlHMVcETSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6492.namprd11.prod.outlook.com (2603:10b6:208:3a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 12 Aug
 2024 00:09:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.031; Mon, 12 Aug 2024
 00:09:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon
	<will@kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Thread-Topic: [PATCH] iommu: Allow ATS to work on VFs when the PF uses
 IDENTITY
Thread-Index: AQHa6PZmMIHnBjt+Fk633+Z4DoVWPrIeNWKggAC4z4CAA9X0AA==
Date: Mon, 12 Aug 2024 00:09:40 +0000
Message-ID: <BN9PR11MB527662685D909F4560035A438C852@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240809132845.GG8378@nvidia.com>
In-Reply-To: <20240809132845.GG8378@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6492:EE_
x-ms-office365-filtering-correlation-id: f8cfa339-6ec1-46c4-afdd-08dcba630f63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QlUwVGdEZXlVdExJcXBLcDBHMmJPU0Rzc2taQVpVcU85bEpTbjNLbTgxOVcw?=
 =?utf-8?B?Y3FDRDJRbDY0d3pGVTVrVjUvQWJqZHdBTENwdnRaVWxDckprUm1qWFY0bHMz?=
 =?utf-8?B?amthUmVLb2Z3VFM4M243L2g3K1ArZVpTNzhkeWE0ZVAzNUpwQnpQZG9xL1Rl?=
 =?utf-8?B?enMrdkE4VkcraVVEU1NzaTlWaVVQbEdwbUFGMExPRG5peFRQWUs0bjkza0xU?=
 =?utf-8?B?RDJaTStrRmFUM2pzVWtuM0xpMzdJVThWOUlLcWlocFhvZGRxQTVabkhrZy9k?=
 =?utf-8?B?ZTZCczk2SnEwbEkyTHk3aXh6M084Q1dOU0RzTm1kTVVxRk4xbjBxaTV5amh3?=
 =?utf-8?B?RUd3U2VXTXhMWllTN2FGUlVrNUo1N1BUUSsrQUJMZzRYY3NhN1JjakNEdnFX?=
 =?utf-8?B?RVZJL2YyOHFnRjR6TlJWa0g0R2krbUhQYS9FK2hQNUloS2Jpc0ttM3c4aTY4?=
 =?utf-8?B?RHlCR2YrYmp2ZUI4T1NabFFMZVVtNUdDWGlBcnhnY1pISmhyRExNcFZ2MzM2?=
 =?utf-8?B?UGVIU0Z3cko5eUZLcWlWN2xNZXVZZzVZb0g2eE02aExkb0ZES3Z2dnp5b083?=
 =?utf-8?B?cTlESWluanNQK2ViRXNvK3FOZ1dCdEZhQmVCSXVqNmZNYlJrMVVhNVVwR3Zn?=
 =?utf-8?B?YWlqWEJERmZIQU9IOTFWMWVXSExSL2kvcnlWSHBPYmtFdHV4UWNoVVlOMWN1?=
 =?utf-8?B?T05SYzVUR2VBenNmTFhZczVpTldlWXQwZ1UwaGFoM1pKc1haYkY2N2F4Tmhw?=
 =?utf-8?B?VWpZTm1GdUlYOCtJcytrbjBuRStyVkVjYndvTlE0U2FCTFNQSTczbVdlLzNK?=
 =?utf-8?B?dXV3RWxMSVRDcUNONnVrZjJucERmWjRvMUthTEUyaEZub09MYjM3elBLOTlt?=
 =?utf-8?B?cmx3b3hqZDMwV2VKd0JqYzVPL2hHNTV4cDdaTHRWeitVUWNxVHBLdkt1VElT?=
 =?utf-8?B?RmNicExjUEVteVdKZkVOU2ZTdkNhVDlrbTdhWXFnVC9peUFQQzlkd3VKZnJP?=
 =?utf-8?B?UXE4Wlk4QVpSNDJYNi9oa3lGVUhXd0h6bkZ0d3g2Zmp0bkRQRjdKdk5ycFBm?=
 =?utf-8?B?dWNaa3NXMWhWMWZwYlN3SzlGbHozb0tzNHcxRUp4NzhFdVROaFBDV0E5OFpm?=
 =?utf-8?B?OFB1UVhXWU9lazlyVVhpZ29MUksvUWRsODl0eE5ZdzM1ZllsTmh3b0MwZUVT?=
 =?utf-8?B?NGJidWlNNDIydkEyT29MdUFlaXRrVlFwamZsOW0rZFdMaFcraXJlYThwMmFD?=
 =?utf-8?B?a1FWMXhhMWVBZUJwcEU3L2owQWF2YUV3SGJUb2V2NVNZNk84Y21Dc0t6SEt3?=
 =?utf-8?B?V1dXRE1ua3dVeGdWY0hQV3ZZa1U0YStxaEJVbzNuRWlEU2FLRzVKaE5pdU5Z?=
 =?utf-8?B?QUd3RFdQTisySG1oV0VNN0FxeW5SOGRCTnM2SmcwVnd4M000bWlkVlZtcGxK?=
 =?utf-8?B?NW51ZytPWXVNU2t1NFBTaW9BamY2b3ZQU3lESDVQZkhwRG1OTlN0dVVRMldw?=
 =?utf-8?B?akloenJvaktuVFBwVHRiQ0lFcTdPdFlvTXJnQ2FNRXpHWE1mS2lUZHlmVWwx?=
 =?utf-8?B?U09DUzczalRaMmF2UkN0Sk5raFN4MURQTm83WTgya0pYMjl5NFBqbmpYS1FB?=
 =?utf-8?B?azNxclFVQktqZXYxdzZ5QS9ZOFRadUVtTVhxc2dxMytZTHY0N3NCbHdlMDZk?=
 =?utf-8?B?ZEYxc3V3eTdFaHlzM3dMYU1SNTRFMFVOZE9ISzFoaGJ2WDNYSHBpVElzU0p5?=
 =?utf-8?B?ZFFuTGFxTWllcDlmZXkvb29GUWZENG5IN2orMnVkZnBnbjNkaWIyam1hYlZx?=
 =?utf-8?B?bTBoMFhDVkdkSkRKT1dzQUE2NWFLVEl3UmFhK3ZmZE9xRWlZbnZ6eEtrYlFW?=
 =?utf-8?B?MWl3WlhPeDNkL29CVjlkKy9uLzZEeDJ1Wk1VNXB0LzhhWEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTNOY2ViYlE1T3JNRTUvU2p4VGZDYWNRRHU2U1B1ZkM4YUYwRXVrVVR1TUVz?=
 =?utf-8?B?ZythN0JJck5ocUNmMXlXOE9zVnpDcEwwaS9tU3J2a0lqUHpXZk41LzhhZzll?=
 =?utf-8?B?S3YyajJVb3dBZGFxMXBJZTRQRUUwQnlVdEZFN3pmZlFzQlI1aGtNb0lxenZP?=
 =?utf-8?B?QktTOGJ2RnNHN3VhOUY0ZXl3NWZ3TS9HZFpGU1hZNXlscU5DTGp5OVA4czZ6?=
 =?utf-8?B?dUQ0RCt3WExtcEp6TzZ1MjdYYTVKeVArbE1SZ0twQUVXVVkxMFQ3QlZyclNJ?=
 =?utf-8?B?ZWhVTHRBN25Bd0p2dDFsMUVoWnNXTkVqTHRUSG1Cd0JJdmFpTkMzbzdpNCtX?=
 =?utf-8?B?S1JYWUxBeTBObE10aHhvVmt4U1hmKzMwZGRJd0JybnRkWUlLZmhvWHQ1TGxD?=
 =?utf-8?B?L01sMldTbEg3emVHNXo3ZzdibjZIanNnRjZVdmJvb3pObUthU1BKbEMxRGI3?=
 =?utf-8?B?YWUweGx5MWRUUm50em1VWmxrck9iZzV3UjUwRStMRmZERnRlMGpvVEJmOGNJ?=
 =?utf-8?B?d3laTmU3MXJZQTZ6bXVnR1pzV09rTEo2UjVWU255TjlDS3ppQUM3NkpiUFVi?=
 =?utf-8?B?MFBHZVo0K05ySVR0ay9Oc2FhWVp2eHhHN28rcWF6ZXNxUEdCWnpESVFFSGhL?=
 =?utf-8?B?OVBIUWJSbzRuZzNiQ3I3SEk3Qmw2RklrV3FDckI4K0NOYUROb0xrT0Z5YVUv?=
 =?utf-8?B?c29TNm1hckhiNGFEanIxMFVCbjd4RnNQSUJBd2pWaDZWZkg4Sjc2djA1RzMx?=
 =?utf-8?B?ZHJLWkVoL2J0MUo4Vjkvc0tJYUdNN3dKaWdPUEtvaThLRldEQlBRMGdyV2cz?=
 =?utf-8?B?bjRVNHNOUE5CVWdMNlY4aWc1c3ZybzBydVFiWTI5TkFsQXczaDBjRlhMRDh2?=
 =?utf-8?B?MHY4ZFlYUWNaN2JKM2N3ZTBRRE1NRUlETFdpY0JkM0E4ZE5WMkN5N0RFcFVF?=
 =?utf-8?B?emNUd1hqSkFnUE1WcXhlbHZQTmQ2TUJFdnRXaU9QWTRJY3hCZDNJN21XQ0lV?=
 =?utf-8?B?NDUyMzFLbGd0Q2VRN2tDNENlNHdHZ1Z2V1RNd29vUXBFZzBSY1JXWUxTU29r?=
 =?utf-8?B?Y0lXWmxhUlNyKzh0NjlEajIrd2sreGx0bDlnbjdXRmhMNUhmaTc2VHFzSGcw?=
 =?utf-8?B?bXpNV1M1bk1wTTVUbHBVdjNUN2ovWnl4MkhVd2xEcjgrbGZjdUJRS3lWN2hs?=
 =?utf-8?B?MmdheU1oTDNmNmRnc2hpQkRzbjYwSHdKNXpncDJRM2E5dTE0Y1ZNeENVcDMv?=
 =?utf-8?B?akd1QjZ3bVZjS3A1VzR1QVVjQnpiRkdLSWxBMGNkcUVsZlZiL0YyRDZlbGNF?=
 =?utf-8?B?eEhHWng0d3dZeHdya2VmRlB5Qm03dkZMejdhcDNlejFscXVwRjM1OWt2L0xn?=
 =?utf-8?B?QkpVTGl5RTFvYkpuaFlWajdUd1ZuejhBT2tlcVNHem82ZmNQYXo5M2RiRTNI?=
 =?utf-8?B?eW9JQ0JucnMvR1JPeUNTSXpZSHg5anA2cXBROEJPdnUxTmpLcFZndEl0MFh4?=
 =?utf-8?B?ajdPTzdMdEF3RzU4ejU3bFF4US9paEhpVGowRHRseWJadTlBcGFOSndzQWUr?=
 =?utf-8?B?RWVJV21MN0V5T3MrZ0d4VktJSnhUeEtQQ2x2QVJjT0hmWGoyYUI3Ty8xTy9i?=
 =?utf-8?B?c1BNM2p3d0laSUJqQXlxZHppejlRMXAyeGcyb25OUHk1RVpydkptMUhNNTdG?=
 =?utf-8?B?WUZveHdLZGpXQUp5SXA2YlNvR1FLN01iQ1B6WXpuZ1RNOWtuVGw0R085U25C?=
 =?utf-8?B?Ull0UzBFUkdxMkxZd2RGOWQ0OEEwd0h5enJNQUJJZE4vSHB6SXhUK0ZmS1Qz?=
 =?utf-8?B?ZExKcHFLOGhkTkxuTkRDRkh5Rzl0VXVrdzFNM0Y5VHFEOHM3RkQwR0ZBNEN4?=
 =?utf-8?B?Zm1ubE9vSjBOcGtUUHlERU8xTG5VSkR6bUVNcWZIOHlucGR0ajUyYVRQcys3?=
 =?utf-8?B?cXpiSkV0NzdpQzNJektRbjRKU05KTkM4aUJiWW83ZzNRMUZWTUo5OFJxOTQx?=
 =?utf-8?B?K2xYNVVhQUxIb3Z0QjVlRW1JcytHSHY4OWNqQjVzMUY3WHJXa1NMOWJ3NWk4?=
 =?utf-8?B?V0pua0oxTVU4QkdYRjRHK0JpT0gwM2U0b096TGdNMmxybkM4ZWlvbnVZanpO?=
 =?utf-8?Q?vfITHVhhTlsgfHLnIFJZYnGsy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f8cfa339-6ec1-46c4-afdd-08dcba630f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2024 00:09:40.2455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 25O8nW+HoV1NVjovm8ZVjHn7MZxVWZPAcjJ3UUfPGx5xcyqZmYkRCqSo/NBeD6m+xrjXTl8K/rZLFa7wCxZUcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6492
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEF1Z3VzdCA5LCAyMDI0IDk6MjkgUE0NCj4gDQo+IE9uIEZyaSwgQXVnIDA5LCAyMDI0IGF0IDAy
OjM2OjE0QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFzb24gR3Vu
dGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgOCwg
MjAyNCAyOjE5IEFNDQo+ID4gPg0KPiA+ID4gUENJIEFUUyBoYXMgYSBnbG9iYWwgU21hbGxlc3Qg
VHJhbnNsYXRpb24gVW5pdCBmaWVsZCB0aGF0IGlzIGxvY2F0ZWQgaW4NCj4gPiA+IHRoZSBQRiBi
dXQgc2hhcmVkIGJ5IGFsbCBvZiB0aGUgVkZzLg0KPiA+ID4NCj4gPiA+IFRoZSBleHBlY3RhdGlv
biBpcyB0aGF0IHRoZSBTVFUgd2lsbCBiZSBzZXQgdG8gdGhlIHJvb3QgcG9ydCdzIGdsb2JhbCBT
VFUNCj4gPiA+IGNhcGFiaWxpdHkgd2hpY2ggaXMgZHJpdmVuIGJ5IHRoZSBJTyBwYWdlIHRhYmxl
IGNvbmZpZ3VyYXRpb24gb2YgdGhlIGlvbW11DQo+ID4gPiBIVy4gVG9kYXkgaXQgYmVjb21lcyBz
ZXQgd2hlbiB0aGUgaW9tbXUgZHJpdmVyIGZpcnN0IGVuYWJsZXMgQVRTLg0KPiA+ID4NCj4gPiA+
IFRodXMsIHRvIGVuYWJsZSBBVFMgb24gdGhlIFZGLCB0aGUgUEYgbXVzdCBoYXZlIGFscmVhZHkg
aGFkIHRoZSBjb3JyZWN0DQo+ID4gPiBTVFUgcHJvZ3JhbW1lZCwgZXZlbiBpZiBBVFMgaXMgb2Zm
IG9uIHRoZSBQRi4NCj4gPiA+DQo+ID4gPiBVbmZvcnR1bmF0ZWx5IHRoZSBQRiBvbmx5IHByb2dy
YW1zIHRoZSBTVFUgd2hlbiB0aGUgUEYgZW5hYmxlcyBBVFMuDQo+IFRoZQ0KPiA+ID4gaW9tbXUg
ZHJpdmVycyB0ZW5kIHRvIGxlYXZlIEFUUyBkaXNhYmxlZCB3aGVuIElERU5USVRZIHRyYW5zbGF0
aW9uIGlzDQo+ID4gPiBiZWluZyB1c2VkLg0KPiA+DQo+ID4gSXMgdGhlcmUgbW9yZSBjb250ZXh0
IG9uIHRoaXM/DQo+IA0KPiBIb3cgZG8geW91IG1lYW4/DQo+IA0KPiA+IExvb2tpbmcgYXQgaW50
ZWwtaW9tbXUgZHJpdmVyIEFUUyBpcyBkaXNhYmxlZCBmb3IgSURFTkVUSVRZIHdoZW4NCj4gPiB0
aGUgaW9tbXUgaXMgaW4gbGVnYWN5IG1vZGU6DQo+ID4NCj4gPiBkbWFyX2RvbWFpbl9hdHRhY2hf
ZGV2aWNlKCkNCj4gPiB7DQo+ID4gCS4uLg0KPiA+IAlpZiAoc21fc3VwcG9ydGVkKGluZm8tPmlv
bW11KSB8fCAhZG9tYWluX3R5cGVfaXNfc2koaW5mby0NCj4gPmRvbWFpbikpDQo+ID4gCQlpb21t
dV9lbmFibGVfcGNpX2NhcHMoaW5mbyk7DQo+ID4gCS4uLg0KPiA+IH0NCj4gPg0KPiA+IEJ1dCB0
aGlzIGZvbGxvd3Mgd2hhdCBWVC1kIHNwZWMgc2F5cyAoc2VjdGlvbiA5LjMpOg0KPiA+DQo+ID4g
VFQ6IFRyYW5zbGF0ZSBUeXBlDQo+ID4gMTBiOiBVbnRyYW5zbGF0ZWQgcmVxdWVzdHMgYXJlIHBy
b2Nlc3NlZCBhcyBwYXNzLXRocm91Z2guIFRoZSBTU1BUUFRSDQo+ID4gZmllbGQgaXMgaWdub3Jl
ZCBieSBoYXJkd2FyZS4gVHJhbnNsYXRlZCBhbmQgVHJhbnNsYXRpb24gUmVxdWVzdHMgYXJlDQo+
ID4gYmxvY2tlZC4NCj4gDQo+IFllcywgSFcgbGlrZSB0aGlzIGlzIGV4YWN0bHkgdGhlIHByb2Js
ZW0sIGl0IGVuZHMgdXAgbm90IGVuYWJsaW5nIEFUUw0KPiBvbiB0aGUgUEYgYW5kIHRoZW4gd2Ug
ZG9uJ3QgaGF2ZSB0aGUgU1RVIHByb2dyYW1tZWQgc28gdGhlIFZGIGlzDQo+IGVmZmVjdGl2ZWx5
IGRpc2FibGVkIHRvby4NCj4gDQo+IElkZWFsbHkgaW9tbXVzIHdvdWxkIGNvbnRpbnVlIHRvIHdv
cmsgd2l0aCB0cmFuc2xhdGVkIHJlcXVlc3RzIHdoZW4NCj4gQVRTIGlzIGVuYWJsZWQuIE5vdCBz
dXBwb3J0aW5nIHRoaXMgY29uZmlndXJhdGlvbiBjcmVhdGVzIGEgbmFzdHkNCj4gcHJvYmxlbSBm
b3IgZGV2aWNlcyB0aGF0IGFyZSB1c2luZyBQQVNJRC4NCj4gDQo+IFRoZSBQQVNJRCBtYXkgcmVx
dWlyZSBBVFMgdG8gYmUgZW5hYmxlZCAoaWUgU1ZBKSwgYnV0IHRoZSBSSUQgbWF5IGJlDQo+IElE
RU5USVRZIGZvciBwZXJmb3JtYW5jZS4gVGhlIHBvb3IgZGV2aWNlIGhhcyBubyBpZGVhIGl0IGlz
IG5vdA0KPiBhbGxvd2VkIHRvIHVzZSBBVFMgb24gdGhlIFJJRCBzaWRlIDooDQoNCk9rYXksIEkg
c2VlIHRoZSBwcm9ibGVtIG5vdy4g8J+Yig0KDQo+IA0KPiA+ID4gKy8qKg0KPiA+ID4gKyAqIHBj
aV9wcmVwYXJlX2F0cyAtIFNldHVwIHRoZSBQUyBmb3IgQVRTDQo+ID4gPiArICogQGRldjogdGhl
IFBDSSBkZXZpY2UNCj4gPiA+ICsgKiBAcHM6IHRoZSBJT01NVSBwYWdlIHNoaWZ0DQo+ID4gPiAr
ICoNCj4gPiA+ICsgKiBUaGlzIG11c3QgYmUgZG9uZSBieSB0aGUgSU9NTVUgZHJpdmVyIG9uIHRo
ZSBQRiBiZWZvcmUgYW55IFZGcyBhcmUNCj4gPiA+IGNyZWF0ZWQgdG8NCj4gPiA+ICsgKiBlbnN1
cmUgdGhhdCB0aGUgVkYgY2FuIGhhdmUgQVRTIGVuYWJsZWQuDQo+ID4gPiArICoNCj4gPiA+ICsg
KiBSZXR1cm5zIDAgb24gc3VjY2Vzcywgb3IgbmVnYXRpdmUgb24gZmFpbHVyZS4NCj4gPiA+ICsg
Ki8NCj4gPiA+ICtpbnQgcGNpX3ByZXBhcmVfYXRzKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGludCBw
cykNCj4gPiA+ICt7DQo+ID4gPiArCXUxNiBjdHJsOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoIXBj
aV9hdHNfc3VwcG9ydGVkKGRldikpDQo+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsN
Cj4gPiA+ICsJaWYgKFdBUk5fT04oZGV2LT5hdHNfZW5hYmxlZCkpDQo+ID4gPiArCQlyZXR1cm4g
LUVCVVNZOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAocHMgPCBQQ0lfQVRTX01JTl9TVFUpDQo+ID4g
PiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKGRldi0+aXNfdmlydGZu
KQ0KPiA+ID4gKwkJcmV0dXJuIDA7DQo+ID4NCj4gPiBtaXNzZWQgYSBjaGVjayB0aGF0ICdwcycg
bWF0Y2hlcyBwZidzIGF0c19zdHUuDQo+IA0KPiBEZWxpYmVyYXRlLCB0aGF0IGNoZWNrIGlzIGRv
bmUgd2hlbiBlbmFibGluZyBhdHM6DQo+IA0KPiA+ID4gKw0KPiA+ID4gKwlkZXYtPmF0c19zdHUg
PSBwczsNCj4gPiA+ICsJY3RybCA9IFBDSV9BVFNfQ1RSTF9TVFUoZGV2LT5hdHNfc3R1IC0gUENJ
X0FUU19NSU5fU1RVKTsNCj4gPiA+ICsJcGNpX3dyaXRlX2NvbmZpZ193b3JkKGRldiwgZGV2LT5h
dHNfY2FwICsgUENJX0FUU19DVFJMLCBjdHJsKTsNCj4gPiA+ICsJcmV0dXJuIDA7DQo+ID4gPiAr
fQ0KPiA+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKHBjaV9wcmVwYXJlX2F0cyk7DQo+ID4gPiArDQo+
ID4NCj4gPiBUaGVuIHRoZXJlIGlzIG5vIG5lZWQgdG8ga2VlcCB0aGUgJ3BzJyBwYXJhbWV0ZXIg
aW4gcGNpX2VuYWJsZV9hdHMoKS4NCj4gDQo+IFdoaWNoIGlzIHdoeSBJIGxlZnQgaXQgaGVyZS4N
Cj4gDQoNCk15IGluaXRpYWwgdGhvdWdodCB3YXMgdG8gc2F2ZSAncHMnIHRvIGRldi0+YXRzX3N0
dSBmb3IgYm90aCBwZi92Zg0KaW4gcGNpX3ByZXBhcmVfYXRzKCkgdGhlbiBwY2lfZW5hYmxlX2F0
cygpIGNhbiBzaW1wbHkgY2hlY2sNCmRldi0+YXRzX3N0dSBhbmQgZGV2LT5hdHNfZW5hYmxlZCB0
byBhdm9pZCBvdGhlciB0d28gZHVwbGljYXRlZA0KY2hlY2tzIGFuZCByZW1vdmUgdGhlICdwcycg
cGFyYW1ldGVyLg0KDQpCdXQgdGhhdCBjb21tZW50IGlzIG1pbm9yIGFuZCBpZiB5b3Ugc3RpbGwg
bGlrZSB0aGUgY3VycmVudCB3YXk6DQoNClJldmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50
aWFuQGludGVsLmNvbT4NCg==

