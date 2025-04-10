Return-Path: <kvm+bounces-43072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00480A83B68
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0E941887110
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85762204687;
	Thu, 10 Apr 2025 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DbjahkWd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14881DF74F;
	Thu, 10 Apr 2025 07:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270714; cv=fail; b=H0+wM654JxCYFqsmLnUoUYF6jk9sE37d9+fDk00e7yXcD07nETrPH/2XW4jry+to6aksdiM/KoNY/2J9EWVObP3sn3MIVnA43Uljm2pSxH90djKvExKHsPzgYiumXDaRouKytfNuuh7DH47EqrYs0LRKobKlCUxmfYolN4q9EsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270714; c=relaxed/simple;
	bh=VpFURGFl/EZSZ3y3kofsYqLq+zhZmBCi6xVEtULZCcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G4abfpAj83MHhJz6R/c853EIaepXZnhbGV9wn6yONJW+sh5mVd1cuaPa/XT9XheubVBkU+UYbK4YKVgY2AXOyi4Q4wuWusT7luImqNEZzhaKeWuNgUeBR/9CNeEJ6pBqs40hjkR0Z2eFZuRZ5S0HeKVM1/8PrQzjXhH5se3T3PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DbjahkWd; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270713; x=1775806713;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VpFURGFl/EZSZ3y3kofsYqLq+zhZmBCi6xVEtULZCcM=;
  b=DbjahkWdnKHEeuPu+0vsm6wGJtbGYPkI8zihK9C5a46vnw8aZnBhiJS7
   oSJ4KHaWIggE51lc8NIE9kkPnK3AaHEEnzuRtV3adWebdMH4iEyP+wuHV
   tsoo5yTQnIjM8FXhr0eSoUhZrMWywtaV2z/CiUGplavuXcMBF1bQJTBCA
   uExGkY8TzVWJ0dzFzT+Rp1Z6pyOhdIfAePpM/MTZdy03Kdmm1/srHsxgY
   sfcUWKDulKewiFtQ8DoTF0WrpOmJANMNlcMCJx1thRI5ysf+ZUX8Vxe2v
   y4Zctm/MxQcukYS8JBVls7QL+2xelUcOC3GbBFy1u5J4u4mh0AWhV0ASw
   w==;
X-CSE-ConnectionGUID: yxJfHbQ+TiWV3TBindfbmQ==
X-CSE-MsgGUID: ttNrrGBrR+ql3UWlh7kU5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="57144139"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="57144139"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:38:33 -0700
X-CSE-ConnectionGUID: zK0DHdznQK+u/+epkhY0dg==
X-CSE-MsgGUID: mbutEvhFTpeNgeB1wD6VTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128737522"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:38:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:38:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:38:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:38:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TAB5Hul1yiSae7F/cJI3/U/wuzDOJZFmPULhsbvjWSmH6egQyf+bIEJCpnj2fNAtgvdiDcd5ZoejmKXr4/qN2XnYLNVOFUsInrGPMp9Q3GVDNaBlf4fUWZ0E92ElXMkwSALL+NlUN81UZCXqM3zoUEkglbXEOR3G6ELjgAqkhuChrDAnxIP95mHAEyQmec6FKSxXCypUsUx9xG0dhRp8Z1nT4umjFM6CAUvYx9EDe44fbwAnBhsuToLunfz2YLg8o+8FL7oraTBsj6CZRink+6M8APiBF7BInsOBoHNMkcLAkJjel9XWtXqPRmOG9PuhpcJuGsvawrlwym+2cDnuuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpFURGFl/EZSZ3y3kofsYqLq+zhZmBCi6xVEtULZCcM=;
 b=W1vNHpfuSZG7wFFb82+6k4BD+DueycNIVc+JkTLEShCELKv/55v2PYl5TSyiENyt4BwZqk4mQ09V+dm1ZYtzV7HuxT+lRp7/gMFFntEjaT7C1JPHlp7Rzlb9ecoAJ+d9usSmwz0hNuDz9h3tjJtnNV9L0SGgfBetuDDgYdsIfBofQuKkhktvVHJWX5hRGSycC7yBqrdQRBxKXn9pCUStJ3C2jHYvqKHC15vIVf/RfvgDY1g3w+ahNba92IYbPs7VM8N4sS4/wqjd17l2wRrHVDMG7bAkaO0Ud+mTVZ/3LlL0pxiZAEnhMlk5md9q1jfRlZprzHYfS0nTUIzlpIGIFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB8585.namprd11.prod.outlook.com (2603:10b6:a03:56b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Thu, 10 Apr
 2025 07:38:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:38:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 7/7] irqbypass: Use xarray to track producers and
 consumers
Thread-Topic: [PATCH 7/7] irqbypass: Use xarray to track producers and
 consumers
Thread-Index: AQHbpacJ2ovkFo48akOGu44GvutTVbOcirKA
Date: Thu, 10 Apr 2025 07:38:15 +0000
Message-ID: <BN9PR11MB52769DDEE406798D028BC17D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-8-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB8585:EE_
x-ms-office365-filtering-correlation-id: 61bf4e92-0fe2-4287-e35b-08dd7802a7a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SjFDd2pIVlZwNGQ5QjhSWStaVWYwMmF5Qmlha0xCTHdUNzBpejVjRFV5WjlE?=
 =?utf-8?B?blhudjV5VFZ1UTNhQUdvZURzOEdLNW5nL0gvZ1plY0tVZ2NzSHgxbUJBY3FP?=
 =?utf-8?B?TysxWmJORUNIME5lQ3dRbnlnWjlMa3J1RFR1ZEJOUVJIZEJPdVg0bzdRcENi?=
 =?utf-8?B?NnVKQ3F2dktqSlg5VUlwb2ltSEg3NWZ0aXFoZEp2ekFxRmtKS1o1dk9tNmNX?=
 =?utf-8?B?TjdsbUhQR0FqbTlQTGI3Y3YvUnordm1sdUMzUGNiSGd2VzlDYTFTRlcvaDNS?=
 =?utf-8?B?cXQzOE1wV0tQYXNyTFU1eEhxSmlEYlNXanNDcFhTc0ZIRGtRcHp5ZnYyeUpI?=
 =?utf-8?B?bFFUMThmTnVkVWYzMnRaRnpmZ0FrM2ZRa0I4T3NkSWVqVEdHQnJiRGQwQkd6?=
 =?utf-8?B?ckdvSm5HRkp0YWdaQmNkOHozSHF0RHNSdm5NSGVSSWpjQWJNbldvN0dSUS9B?=
 =?utf-8?B?MWU1dUJlOWs3bHJrZ1RFOFUwcTVGSXJBUEt3dVh6bnQzT1MzUU9OTnUxN2VC?=
 =?utf-8?B?NTJyS0pDUjEza3Q4WFpGclo2bW92Y0F2K043VXhOOEZpOCtob0lPRUZCb09Z?=
 =?utf-8?B?WDhBUm8yZ3RYUm1RQkVOOXRlK1J1MXpPc3FUclFmWlZlMDFDbit5bzROU21v?=
 =?utf-8?B?ZHpGVldCNms0bWFocThBRk5uVGRpQ2RGQndRRlhVSE9GUjJNckNDZzdIR1BX?=
 =?utf-8?B?QWxnTWNjS245aVpvS05La01UOGRVQzFrTzFjMStvSHBIUTJzR3JMdmZ5MkJt?=
 =?utf-8?B?bEhzeGFGVjRQVUhHODk2Vlc2VEJmdXJDS0xXTEFNWS9reXV4TGl2VGVVQVk4?=
 =?utf-8?B?aGxJbThVcS91aGlpWlVVdWkzaXpGR2FaaTNXWnl4VmpkSTVEdjJYeitLM1ho?=
 =?utf-8?B?MUN0L1pHVWtHU3U2SlNOZHphWUIwNU9hU25jTFk1b3ZiVGxwTis4eWFJNW1D?=
 =?utf-8?B?UHVDZjBsVnVCQ1FSQVN2OTREWXp3SEJGaDVVSXg3WngzS2ErSENVUFR5OGJt?=
 =?utf-8?B?WHNXRTZ1SzFVeEF2YjVadFFpenFOb3NRV0sybWNVVTV5SmVVVTdsTlZVRXZU?=
 =?utf-8?B?RmVtSmtiNjYrNEVxc0UzV2FITEEzTnBxYnViSGhmMGJlVnhCWjNHeDc0V1Jj?=
 =?utf-8?B?d1psdDlkZENldU9YUUlQRXNIWjBlWENCbkZrMnhSSnYrVlVKUVFsMkZZNnA3?=
 =?utf-8?B?VUd2Z2ZmMnRaLzc4blB3R2NBTWRwcEFoRVFnNEV2SW1qczg4SGVKdGNETDZw?=
 =?utf-8?B?c3ZmUWRjU09ZVzhDNkNXU3hVVkRQNk81NUhqL1F0MUNCaEZKbXp0cW1LVmth?=
 =?utf-8?B?eE9OdTdjREN5ZkFkeDc5anl5cG1WU3dVT2ovMmVtNHdTcjl2bnZ2dmpNVk5Y?=
 =?utf-8?B?UXdKN0FvOE8yRTNsOEVCQ2ZwZFVnRm44S3lURFNJOXFNcnN4b1JsMXlodlNs?=
 =?utf-8?B?cTZPSGVaa01oRmFOSzZYMkFiNWovblhBRFU2NzZkTWUwZXpXNlVwdWJWajVU?=
 =?utf-8?B?aEI3WmdEcHFFSkFCSXo5K1c2SHFIeUl3aDB2QmZ2RDdqM0QzdkpUSTlWMWQy?=
 =?utf-8?B?YncrK3hFcm9aZlg2S29QQVhYcTJoejVnYkRQbXB2QzZLa1FXZU1NK0dHZU83?=
 =?utf-8?B?YXA5WWVZMmN4QWd0NG5UUG1JdkprcE96ZG1MNnllMy8rM096OXEzQklVTFI3?=
 =?utf-8?B?TmhjbDh6Z2pDajhlQnUyTnlOby8zVW5oeHRXS3crUlhNeXplMWl3bDk3ejJm?=
 =?utf-8?B?NG1hR25helZMcWlKczZHZCt1b3dQdm5VMnVMaDkrTzl1Z0NmV2R1V2prLytj?=
 =?utf-8?B?Ym11V2VGVVMrTGRXRmV1ZDBQY0xEWFpYOUc3M3JxakdiS1ZSVTNJdGhiVmc5?=
 =?utf-8?B?alNheUVQN3VzaEQvTEd3aHozbGUyUFZQY2ZXL0lPeTIvcWJUZFZWemtFUk9n?=
 =?utf-8?B?QlVkMkw4eHhxN1MvcXBCbjZaU3Y1NEM1VGw2bXdCOWszcWNGYVYxTGRiK3dQ?=
 =?utf-8?B?a1I5KzJEdDFBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3VFS0UxYURPOGdmRUkvaEowVEQ0c1hqRUlRQjVBaEc4cEkwSXBCRlBjeXN1?=
 =?utf-8?B?c1Awd01rQkRsNGFJY2xwNHhaQ2RTby9Qbm8ydGNHRHQ2MVJkVWt5alprK2tN?=
 =?utf-8?B?NHlRdDhmNlBsZUJVQmJHQitrWThsL2tMWmdLeWJ2T3RndHhUd2lxdzROY1ZI?=
 =?utf-8?B?c0FIUDc1bkV0Qjg2OEhBcDg0VGpFTitUZXh5TGVKWHRVMThuL0YvWk5zNCtW?=
 =?utf-8?B?MExLMWRYRHVzR0pWdmtQTU80d2pJT1paaXd1aUFkTWVxQnN2RDNlVXZ0UEY4?=
 =?utf-8?B?QjBWQXNxc24vQnZlTEdJT0s5YmR3cDBJN1VVYUVDdDNJMXM1R3NXbElrQUFQ?=
 =?utf-8?B?ekdTNUNBY0JtdFBDNXVaUGhtSWViNERPMDVYYTFhMjlYVnNraUc5RzkvV0Qy?=
 =?utf-8?B?YnFCZXVYcERIVFRpb0JBOWtidkg4bDVkazlKL0x6N3ltekFNbmZGQjVjeTZN?=
 =?utf-8?B?elVYL1NudnA3M2czdUtvd2NQbVgxaVpFSldJL2hwSkJ3R3k4czQ1QkhwdE8z?=
 =?utf-8?B?Ny9iSUdTTzRZV1Q0ZkU2OWxlSTdjVEdjVkZoM0tCSythdGtad1dsSFRQWS9r?=
 =?utf-8?B?SG9VNWxacHJMalpsaTQ0QlVWQXM3Yk14RG9kRXVQODByMFBIT21TUlduWEVz?=
 =?utf-8?B?bGYzV1ZkSmlicGQrb0pRempHNE42aTY4enprK0wvQ2JGU01YalM3OFFCUElY?=
 =?utf-8?B?ckpjNkhGS3ZzZlBpa1JBbFZUNjdNSmVlK1hkcHZLWkNKYzd1ZlVEMGtPOGpE?=
 =?utf-8?B?SnJRMy9ZYVpFT0ZSOXYwVHVqZ3kvbHVqSUdaUHk2RStSMVJzdVdZczl5T29m?=
 =?utf-8?B?SzRQUW1wQ3p2S1psdi9hbkVVRnI0S2pkWWlUQzlEZFo2UWkraTJZb1NXc1V4?=
 =?utf-8?B?Ly9sZW9PckNhWTMzSlhPUDUra0hBMFU0RHE3OUpWQjlYUmdQRzlaZnB4SXN1?=
 =?utf-8?B?c1ovU09NNzhML1JweHVETzNHMjN0Y1Z2UEZFdWh4cm1KQ0ZQTlFxSytQOFVk?=
 =?utf-8?B?LzE1c1ZCY2ROSHhGcFpRcEY4RDlzYjl5NHFldjJiUndXNGVnQkl5ZmxCQTdJ?=
 =?utf-8?B?R09zMHpqcS9ZQ0lMMytOM0xCQUEvaFVMMDZpWWg4TEUybHZQQm9xamlOUEZx?=
 =?utf-8?B?M1gzTXU2VkNvcDdqN1BPNDRZT0J4N0dCRzZ4S0Nab1ZURXRnYWI0ZWxFNlJ4?=
 =?utf-8?B?ajJVOGJkVnBKVXcxd2RMZ2hvdHFEbjNYYmtQR2h1Y0VqUXhsd0ZWN1g1N215?=
 =?utf-8?B?STl2NXNBMFpySXppZ1pjZlhWaTAzWUFOZlRGemNscjV2cW5kb1BBV2lCS2NO?=
 =?utf-8?B?SWVxZllSaXJlSFJzbnBRZVpxRzJVYXBsZXFCVXRUYytHY3VMTTNBUVdYLzli?=
 =?utf-8?B?YmExWFlZeWRPa0lJdXNXT3hBbWZZQlV6WGZYY3J5elZVcnkwR052c2RWYTNi?=
 =?utf-8?B?b3ZJcHYrOEJ6c1FvZDNPWFMzZngvVXBoMHc4MGxmZCtTZTRWRWt0eE5ReUVa?=
 =?utf-8?B?ZktrVk9oaGt5SlR6MlZDOEZMSTFqNURTclVQUXhTQldkYm9CeitKWThGeUlT?=
 =?utf-8?B?SHVtNXpDaGRzM0UrTVdNbXFFeW5xNjY0REVLYVdaaVZDUXl3NUhnaTVXU1RJ?=
 =?utf-8?B?V21VK0VDMmRkckxhTllYZjZ4UHdESkR5RUZKMnRhUDJUOXZkeVBGMUlwUm12?=
 =?utf-8?B?SnBzMVdjN2djZ3BodFFHZmNLODhwWWVDQzhqTXlCYnNnREwyWWFBTEZHN0hM?=
 =?utf-8?B?amZocHpobHhuaW1TWlFlTHYrQnNMUFc5d01IVUJsS3Y5OFlhWS8xOEdaMy92?=
 =?utf-8?B?Yldwem1YVlBldjQ1aldSM25YdVZUUXZmWlFVaEVDWGd1N2NmaTBxQ0UwTERh?=
 =?utf-8?B?SFJRT0pIZlcvRnZvSnR5UFh5eXBld1FFZ2gxd2pQQWFueXJRRTdieGtQcXN0?=
 =?utf-8?B?VUlzdXFxY28rV0EvQzFYTjZNa1N0c2dkUTgvS2FDRjdJb1NpZGZoZ3dzWWJv?=
 =?utf-8?B?L05sUmxkbTBsZERKVExJL2EzV0pOeTZhaFNCbUV5MysvNCszS2ZBeTAxRG5P?=
 =?utf-8?B?ZnFmbTdCZnA4RXhlVDFJb3J1OGdSWmdaVzB4SkRjU0FHT2ZzTDkySHdhTkRP?=
 =?utf-8?Q?dzhW6PlX8at7X9l3OL/z2XoOn?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bf4e92-0fe2-4287-e35b-08dd7802a7a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:38:15.3969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXPNOw13KsXOoLWnOkkh9rh3CUD/3zF1Hpi1bpCyqLrGTop5kULUwyuB4mutuedT13xDVwfRQafMHu3wC/jFbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8585
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gVHJhY2sgSVJRIGJ5cGFzcyBw
cm9kdXNlcnMgYW5kIGNvbnN1bWVycyB1c2luZyBhbiB4YXJyYXkgdG8gYXZvaWQgdGhlDQo+IE8o
Mm4pDQo+IGluc2VydGlvbiB0aW1lIGFzc29jaWF0ZWQgd2l0aCB3YWxraW5nIGEgbGlzdCB0byBj
aGVjayBmb3IgZHVwbGljYXRlDQo+IGVudHJpZXMsIGFuZCB0byBzZWFyY2ggZm9yIGFuIHBhcnRu
ZXIuDQo+IA0KPiBBdCBsb3cgKHRlbnMgb3IgZmV3IGh1bmRyZWRzKSB0b3RhbCBwcm9kdWNlci9j
b25zdW1lciBjb3VudHMsIHVzaW5nIGEgbGlzdA0KPiBpcyBmYXN0ZXIgZHVlIHRvIHRoZSBuZWVk
IHRvIGFsbG9jYXRlIGJhY2tpbmcgc3RvcmFnZSBmb3IgeGFycmF5LiAgQnV0IGFzDQo+IGNvdW50
IGNyZWVwcyBpbnRvIHRoZSB0aG91c2FuZHMsIHhhcnJheSB3aW5zIGVhc2lseSwgYW5kIGNhbiBw
cm92aWRlDQo+IHNldmVyYWwgb3JkZXJzIG9mIG1hZ25pdHVkZSBiZXR0ZXIgbGF0ZW5jeSBhdCBo
aWdoIGNvdW50cy4gIEUuZy4gaHVuZHJlZHMNCj4gb2YgbmFub3NlY29uZHMgdnMuIGh1bmRyZWRz
IG9mIG1pbGxpc2Vjb25kcy4NCg0KYWRkIGEgbGluayB0byB0aGUgb3JpZ2luYWwgZGF0YSBjb2xs
ZWN0ZWQgYnkgTGlrZS4NCg0KPiANCj4gQ2M6IE9saXZlciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxp
bnV4LmRldj4NCj4gQ2M6IERhdmlkIE1hdGxhY2sgPGRtYXRsYWNrQGdvb2dsZS5jb20+DQo+IENj
OiBMaWtlIFh1IDxsaWtlLnh1LmxpbnV4QGdtYWlsLmNvbT4NCj4gUmVwb3J0ZWQtYnk6IFlvbmcg
SGUgPGFsZXh5b25naGVAdGVuY2VudC5jb20+DQo+IENsb3NlczogaHR0cHM6Ly9idWd6aWxsYS5r
ZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTczNzkNCj4gTGluazogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjMwODAxMTE1NjQ2LjMzOTkwLTEtDQo+IGxpa2V4dUB0ZW5jZW50LmNv
bQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNv
bT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0K

