Return-Path: <kvm+bounces-14753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21EEC8A6766
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 444D21C21322
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B26386244;
	Tue, 16 Apr 2024 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RDvaK6oC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2773A3BBEC
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713260869; cv=fail; b=uv6bqaartC10eW+qLe/22gsjRYumwfKBxUvqjWLuDhKUTZrDuPrqDsBQ0A8ViC787Vd5xskxMFEcvKb5sVPeKc/4hUGDni/N8PwXyzpHdEPi3xJxR8uSPXL5UNpUb3EdCDQ656r3x5dCOFMWMqCZD13ZyW619hSn2ucgKjPeCA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713260869; c=relaxed/simple;
	bh=/+wlKAgxqxHDyNLpkW32tCTH6qfTnBbiNNyLsL73MaA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g2xNWmU4TJlUPQ4dJL2POUxsJ5/3IkbRHaEpZ4pDil0t9qgADuhkTZNLq2F1uSMvTrMMu9jWb+uqKssZo0MdAD7J47ezjwl0wPbp3GMvqW5O+dFrJzwaFyX+lmW1Jtii1gZw65gVIXhydD6i4U90hf8vUSmA46pdrN7mM6dvQ1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RDvaK6oC; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713260868; x=1744796868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/+wlKAgxqxHDyNLpkW32tCTH6qfTnBbiNNyLsL73MaA=;
  b=RDvaK6oCYyNWRZYoH0BCLCF86+cMZciQbjdd6YA5LD7EkBlSsWufepLa
   EABdGXcTAd4BSYrjct1FcmAXYZ4ahI8TCKM9QXLPtxweGnezNUZkStyBV
   JFjZIOQhw+4PDjUllywaZj7ie2bAUikQRX0/DqS3+Es/6uC2QlNy+Fnv8
   ogXyYkqZDU9aZMWRWLi5f66qSRU6po8SMNXJzQMA4ttebK4bXNXKW2b+1
   2jlk5QwJrqkyJ6MrTfJbTobRTWbuE7NqcnszoF1Qq3NC65wXqM6KmiOAc
   a75+VxL8XWYjmOmXBWFifpPslGKSlgZvNlbMKy3pOdH147fLytJpvDN86
   w==;
X-CSE-ConnectionGUID: myfRHWfrT06UR0bHYRfvkg==
X-CSE-MsgGUID: t5cXO23ATbi9JHHu5NJ8rA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8798789"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8798789"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:47:48 -0700
X-CSE-ConnectionGUID: AWah6toWS9aQ5uJtk0yYVg==
X-CSE-MsgGUID: ZIR3wChwRv2pbQvIaAdbNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22278517"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:47:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:47:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:47:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:47:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbKaNH7s2LImVOYCPG9sImEbc0la75iL6wtyLrHtzVNuz20rfSnu34F4zpSo1zkM8j+t763Bo8+toMiS8vPtV7HasLoVG7dODJmKHj6ZTX7TqQZc4c9pOXkAxO3LMHpbSPoZiFrhk15nQAvbFK9a6dgAezX08MK3FDLsJCj+FDrqS4unr7vNePEmsbd39ZM+1mfLZl7w+gpXaijz/g78WT43esz/awGu1zpFD715oYMgCNtn3988MZwP/mHRMXoRlSxdgkYxH9w2ylBY4mbhSvIeqXV+Q5j5dPBEGvCBmsFDmnzGL27OW8WN+9d3YWrc/MB9UGdVGfNNNzFUNRg+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+wlKAgxqxHDyNLpkW32tCTH6qfTnBbiNNyLsL73MaA=;
 b=PSWxkCtmqaKekddwqibUaO0teEjnubwD8h+qSg0AU0ZBmv9qktjJBp7QdXZnB4WraBCBH3kLGd47GYv8HFPqg9vlPdsUOgWiuSpAs+XmdfnlTyERyAVHnq6F4cYnKChB6N5iNieOnMeI/SH5VI0G1831bZhzc/ufxfTv0YQv/hv7vow09ScvCWyCCHesmQ5+i4lNo1o+mHp+Rt0W8y+t+88NmqV71j4z+QEpsObcSjMvBKon1ObjY+pq9g4tvnswgqRwYoRR/yrHIYlcaNx4QmgEgYs5ZlOSd4M3q1JRr9eKQ6l1i7AAZSd108MxiC7ZJm7II1iMbJkPbOsq53qmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7839.namprd11.prod.outlook.com (2603:10b6:208:408::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 09:47:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 09:47:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
Subject: RE: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Topic: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Index: AQHajLJvqbi+3itwa0qGlqKjcLbCc7FqnojwgAAH5gCAAAVU0A==
Date: Tue, 16 Apr 2024 09:47:44 +0000
Message-ID: <BN9PR11MB5276D407CC14E0C9D8AE17998C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
 <BN9PR11MB527623D4BA89D35C61A1D7D08C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d0dc889b-003c-44cd-9f8a-a14d6b7009bc@intel.com>
In-Reply-To: <d0dc889b-003c-44cd-9f8a-a14d6b7009bc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7839:EE_
x-ms-office365-filtering-correlation-id: 45cceb9a-1fcc-403d-f93f-08dc5dfa4442
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?WmhTMVA1SFVwMThFakJ4NFdubjhGbEx3bnpmV0FIdy9nV2MxV0RjRGw4eXU5?=
 =?utf-8?B?UmVqSmdzY1l0SEVqb3U3c2ZlVy9GK1pzZlZ5YlBTTmNNbUJValoydDlSSnRV?=
 =?utf-8?B?WmVHS05vUXh3ZkNyR2Z0ZTZHVlF3UGxKT0pVa1U2K2h2NWg2OE5ZL2JsemRB?=
 =?utf-8?B?RXg5REZNKytscGZhcXRKbk0rUUVrdWpFYUo2NVJwa1UrYk5ISmFlNTVvMmxD?=
 =?utf-8?B?NVVKMjd4Rm56TkpUTTVtYVA5NjJ4MGwxd0E2NWVsNVpRYW8rb1dHdzdsWXpC?=
 =?utf-8?B?TmZ6TWVVRnNoREhhcHNFUG0xS2VOa1BpamRYa0FEMDA0VCtSVTNmbDYyWFpO?=
 =?utf-8?B?eEJVVjJDVmQ0dkoyL2loUzl2emNJbTBLR1Q3Tk9uK2d3SG9EV2xIeWFXbEJR?=
 =?utf-8?B?YW1VWjZjQnQ0akNMQlVKbm90VTZWeDh6NHBoUzlUMFJnZnZMUWczREJtNEpt?=
 =?utf-8?B?S2N4MU1CY052Mis4V00wa3hodUR3cU1wNFdjeUNiTFI1WEY3QlZtT1QxdDBL?=
 =?utf-8?B?dWN5RTBDcVErYmJ3a2I2ZXFLUGZ5UVdLZ05yNHh2R3h0cDR0QngyUnJ6eWtQ?=
 =?utf-8?B?elZjRlFXUkt3OUdNaVhpWUJabjJYUTRhM2ZTZmV5TmF2NjdYdTVuR3JsWmxQ?=
 =?utf-8?B?WDRZbHZBT3NrR3VLSkZjNlFFdmNEbnRXVmdFQnU4VVJuRjdYYkljRWJFeGZT?=
 =?utf-8?B?cFQxQ2FndnIrYm5zUm5uWUhoNUFNQVYzUHI4THVWQXhrYkxqY2c5R24xVDVn?=
 =?utf-8?B?NEFyZmhmY3krQkFrWUIvektqams5V1laQ2QzUUtjclc2dzNJcXFBbWxkelhk?=
 =?utf-8?B?bDBlSGJ0WEFNcmFQeGx3ZHhQK1dEaFFmbllQSXdLdGk5N3RRamg2YTN4cXBm?=
 =?utf-8?B?RllZM3FUa3FaSGhuY2J4b3dNWUx3V0JZaERYVlR1UWxIMi90RFByOWlOZEtq?=
 =?utf-8?B?NTJkdmZ6akZtWStPWFFEdGlaN3F5NEpsUlNjVFdUazNuVUlrQkVUVmUzbUJy?=
 =?utf-8?B?THlVQ3JhTS9qZUVzS2tCbERRQ2dOcEVQQTZVZVVIR1g0RzdKNUpPSDNKWkUv?=
 =?utf-8?B?SkJsa0V2TnFJMmJ4VldUK3ZKTFY0QTRuNnJWazRNQ0drODhqUTgxWnlXaTdK?=
 =?utf-8?B?RWZFS2ZYVEtEaFI4Y2N1Tmo5MFdlNkdmaG01Qi9RWXlZaXpBY0sraXd2Tm9U?=
 =?utf-8?B?WnBzTWZ6Z21GdEU3SjcxbllTS0xrWmttQWYycVEwSmJqc1lGUWlCMmxqbExv?=
 =?utf-8?B?TDJLbWZkZmg3aTlQYWg1RUYwZ3MwOVd2UU1aMDY3OUt2UGlWNnoyU1dUK05Y?=
 =?utf-8?B?MW5zREZUaWxZU2ZoZUZERjZqWnl0MWVNNEo1d1Bja1ZiTWEzL1ArbUNWaWxV?=
 =?utf-8?B?ZGRHT1Y4YWptR3dMczhYczBxN2RzeUdrdlprNUJlVUJ4cS9EcVRUN1orUzJQ?=
 =?utf-8?B?a2ZFYnJWdUpFWUJja2IrR0p2VTA3UGtGeGc0MEUxU09DUjc3VWJpOTl1cGNk?=
 =?utf-8?B?VWFuMWxwSHNMUU9sMVVKRzIyZTE0MkpWSU14UEVzbGlUTzJlejBBck9OaDhF?=
 =?utf-8?B?VHQzM2ZWdzQ4UWsweG56TEtWZmxuTG5KQllzc0pxQk8rSEZDZnZVbUMzZmNM?=
 =?utf-8?B?TUorNzJsWkhHT1lqRlJHaUZkeVhQbVVtUml3cUVTSDVFbXE5bytJdEdEVFRI?=
 =?utf-8?B?UVJpQTg1ZXRBM0w4ZlVaMkZ4aUhkb2pDVjZsRlp4cS9lVUFlNHFtamVwT0RM?=
 =?utf-8?B?ZVMvY2RMaEU4T05pb3JUQmpGdlh3RVNHMk80cC9pL2xkS1pOUzNwbWJUWHNN?=
 =?utf-8?B?TFpXcmVGcE1FUkZwd0w1QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QS95dktwTjFlTEF3OTJ6TmZoUVFscndCWUlqOExSMEZ6ZHQxWStyWVFnZ0hm?=
 =?utf-8?B?dkx4ZWJkTTAyUTZuVE5VWUtNL0Fob2ppQWF0a3JIMlkxczEwQXBySUZUN1VZ?=
 =?utf-8?B?OFJBL2pxQzdMaDdJeHAwS3lYWCsyaElkMGlsdWhaT2NNN2RaeDc1NWgyVXl3?=
 =?utf-8?B?Wmk3dVo4SFp3U0Mydm5CM1BHK3J1bkhYZWFmUlFHdXQvSUhGZTVlM1dNRFNT?=
 =?utf-8?B?bWVQZ3M5cTVBcTUydU5maWI0WENWL2JxN01VeTBkNUE0emlla1pubjNCMWx2?=
 =?utf-8?B?aWtaMlFDZWo2L3pXeHRwbkZhNDNIT1JwS3B1bGxDYWpicG5zQUFLSGN5Wm1S?=
 =?utf-8?B?TmtvOVJGTHFEQis5R0U0cnU0MXZ2TzJ0WUhQTkp4YjlPc0tBMHJZODlrZG9p?=
 =?utf-8?B?QW1SdDRHS2lvb3R0TWJjbExzWFU4ZGR1b3lHdk10TE9ZVnoyNlVHdzg4Vjk0?=
 =?utf-8?B?UmhoeURzSGYyYWI5eE1pTjkraFVBR2N0ZXQ4WGR5bzFJS01TL1hUZFo2VHYx?=
 =?utf-8?B?R0ZmY1U4em1GU0U1Mk1LWXJ0ZWpySkpMZzlyeXRiZVBpOVFwY2l1WXFDSnZv?=
 =?utf-8?B?dDBVcFIxc0U2MTI2VHhVTHlxQzlzNHdkaHNZRXRHUE54czRvSnc5YStOc3V0?=
 =?utf-8?B?UkFmemV3akQzeUJ3RG1zZzFmQ0l1STFpWHA4c0RuZDJSVHpvVDBFT1lPcm9U?=
 =?utf-8?B?aGw0RmN0VWpJMitCdjU5M3V1T3pYblA2RDhUeklNZndGWmtrVkxiR1FRNUtE?=
 =?utf-8?B?SHZoN08yNXFKTWVkYStxdU0xRzkvb0EreVlsOWR0L0VoY3RTZDY0Q0E4UzVZ?=
 =?utf-8?B?b2ZiQXVNTFcrUGg4cVN2WWFyRE1vSHVnY2twTGE0ZnA0d0pjQlNobUVhUzF6?=
 =?utf-8?B?L3EyRFpnaWFVZFVPS2tOUjNSQTJscXdyK3FZeDFDaFUrVVpMNnZPR0xSZ3Z4?=
 =?utf-8?B?VVEwNXFvbzY4U003TE9CSXg0SWUxOEdRS3JCZVlGeDZRZjdaclRxZFRMKzh6?=
 =?utf-8?B?WlhXcjNJU1lRL1diVVpTeFgzYkxDK0UxNlJ5R01HMGkrNUNsZkt2YmFmbURs?=
 =?utf-8?B?YTJFeFIwdFdnd1hwZFh2ZlpjY1lZbUpPVWNybWJqdVB2amFwdUkzQThFL25B?=
 =?utf-8?B?VVhiUGl4MTR6UEpuWm9ONmhpeDJ3Y1UzWnZJR2swQlAwT1JFZXFVM2V4NUdq?=
 =?utf-8?B?WHR1VWx3NGxBaDZ5T3EyNENFblJlUDBNeVZENXZLVmdFemZMNXgrZStScy9E?=
 =?utf-8?B?a3dnNE9zTkVnUlFOTW1TeTd5U0pDbkpvNGo3a2ZsQUZZandiV3Z3a1RZMng5?=
 =?utf-8?B?ZkhueFRjcjFCOFdtUDV0TjFVTWo3RzhScXpmNEwwWXUwYU5pd1JjVUxXYk16?=
 =?utf-8?B?VlNVd2JHRmNrYjNZVHE5TGwzdERpVHBqaVg0ZDNwb3AzWCtYRnc0MVZ0bE5v?=
 =?utf-8?B?bWU3K2ZIRWZVZUc4SHhUR1k2SW9vejhPM05lbi9qQXpuTG5ldXhaL1cxZmgx?=
 =?utf-8?B?bXNKVHQ0d0lMeUR6d0IxSmlzaHl1bHByTENXTCs0U1VzTEVMKzhWakhwUXdS?=
 =?utf-8?B?MndxZW5UajlvcjJpdGZHQ3NGK01rOTl4RGYxTDUzZmdHM2l6QlpIUG0ySWVE?=
 =?utf-8?B?TkloYUdsRktTb1dqYW1UaG5iSlFubllrNkgybW8zLzYwM1BZdjgxNHNEekdB?=
 =?utf-8?B?MFJjVmZzR0Yyb3daZm9uT3hhTmkyejRWak0zMHd1ekFNZWJFcXBNTHVwaUJB?=
 =?utf-8?B?VmFVNVdhWmtDb1pQOUZBUXV5MnRWUXdBZnhuc1pEd1NYQ0RFNDZxTGFmWlpY?=
 =?utf-8?B?N0p1VytveE9ubWNZd1VObmZ3cTFyQUpjSGRBZTlUNGdCeVlPWld4M2dXREIv?=
 =?utf-8?B?M203dnBzK1FUR3o2MDN3YzBVNENTWGs0VkYybE9EcUg2V2Y3N0NIbFBhVG5W?=
 =?utf-8?B?MVlhMVJjdGVLZkNuMWZ3aFFjUlRBbjBvTmZEVGUweEdkd0JXSHpMaDJtV1Uz?=
 =?utf-8?B?R2tCNC9HU2didmdxd3IxMU9oY1JjcHNsNk5YeEJ5dGlrdTdORmxHZG8wTGJV?=
 =?utf-8?B?U3N4VzRQc3MySHN6Qy9JY2ZCOVZhSDAzOGFxanJkSGM0OTRidk1Kc2FWR0tC?=
 =?utf-8?Q?D5nBbxRCmGXwJFmQRGHueNq6p?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 45cceb9a-1fcc-403d-f93f-08dc5dfa4442
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 09:47:44.8165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V95AisWsAnI2E2ecVZjz8nJnZNBm/PXI5t9Re3C4O+SznQsklzKFlEqBixkzAhIktco9/ZeFeX1mHeHzh4Xy9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7839
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
QXByaWwgMTYsIDIwMjQgNToyNSBQTQ0KPiANCj4gT24gMjAyNC80LzE2IDE3OjAxLCBUaWFuLCBL
ZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+
ID4+IFNlbnQ6IEZyaWRheSwgQXByaWwgMTIsIDIwMjQgNDoyMSBQTQ0KPiA+Pg0KPiA+PiArDQo+
ID4+ICsJcmMgPSBpZGFfZ2V0X2xvd2VzdCgmdmRldi0+cGFzaWRzLCBwYXNpZCwgcGFzaWQpOw0K
PiA+PiArCWlmIChyYyA9PSBwYXNpZCkNCj4gPj4gKwkJcmV0dXJuIGlvbW11ZmRfZGV2aWNlX3Bh
c2lkX3JlcGxhY2UodmRldi0NCj4gPj4+IGlvbW11ZmRfZGV2aWNlLA0KPiA+PiArCQkJCQkJICAg
IHBhc2lkLCBwdF9pZCk7DQo+ID4+ICsNCj4gPj4gKwlyYyA9IGlvbW11ZmRfZGV2aWNlX3Bhc2lk
X2F0dGFjaCh2ZGV2LT5pb21tdWZkX2RldmljZSwgcGFzaWQsDQo+ID4+IHB0X2lkKTsNCj4gPj4g
KwlpZiAocmMpDQo+ID4+ICsJCXJldHVybiByYzsNCj4gPj4gKw0KPiA+PiArCXJjID0gaWRhX2Fs
bG9jX3JhbmdlKCZ2ZGV2LT5wYXNpZHMsIHBhc2lkLCBwYXNpZCwgR0ZQX0tFUk5FTCk7DQo+ID4+
ICsJaWYgKHJjIDwgMCkgew0KPiA+PiArCQlpb21tdWZkX2RldmljZV9wYXNpZF9kZXRhY2godmRl
di0+aW9tbXVmZF9kZXZpY2UsDQo+ID4+IHBhc2lkKTsNCj4gPj4gKwkJcmV0dXJuIHJjOw0KPiA+
PiArCX0NCj4gPg0KPiA+IEknZCBkbyBzaW1wbGUgb3BlcmF0aW9uIChpZGFfYWxsb2NfcmFuZ2Uo
KSkgZmlyc3QgYmVmb3JlIGRvaW5nIGF0dGFjaC4NCj4gPg0KPiANCj4gQnV0IHRoYXQgbWVhbnMg
d2UgcmVseSBvbiB0aGUgaWRhX2FsbG9jX3JhbmdlKCkgdG8gcmV0dXJuIC1FTk9TUEMgdG8NCj4g
aW5kaWNhdGUgdGhlIHBhc2lkIGlzIGFsbG9jYXRlZCwgaGVuY2UgdGhpcyBhdHRhY2ggaXMgYWN0
dWFsbHkgYQ0KPiByZXBsYWNlbWVudC4gVGhpcyBpcyBlYXN5IHRvIGJlIGJyb2tlbiBpZiBpZGFf
YWxsb2NfcmFuZ2UoKSByZXR1cm5zDQo+IC1FTk9TUEMgZm9yIG90aGVyIHJlYXNvbnMgaW4gZnV0
dXJlLg0KPiANCg0KaWRhX2FsbG9jX3JhbmdlKCkgY291bGQgZmFpbCBmb3Igb3RoZXIgcmVhc29u
cyBlLmcuIC1FTk9NRU0uDQoNCmluIGNhc2UgSSBkaWRuJ3QgbWFrZSBpdCBjbGVhciBJIGp1c3Qg
bWVhbnQgdG8gc3dhcCB0aGUgb3JkZXINCmJldHdlZW4gaW9tbXVmZF9kZXZpY2VfcGFzaWRfYXR0
YWNoKCkgYW5kIGlkYV9hbGxvY19yYW5nZSgpLg0KDQpyZXBsYWNlbWVudCBpcyBzdGlsbCBjaGVj
a2VkIGFnYWluc3QgaWRhX2dldF9sb3dlc3QoKS4NCg==

