Return-Path: <kvm+bounces-48457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01486ACE76B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 02:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4E9C7A7274
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 00:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1CB2CA9;
	Thu,  5 Jun 2025 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CIviIwfA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF4F46BF;
	Thu,  5 Jun 2025 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082493; cv=fail; b=DO7mChEHWdctdovWvTrb/VEbkI0eh4N3WmCx2WMEa8ANFQbTNqMkxv5alscEojo1GFKzP5y7ZCP1+ENWqwlJ8KmvIDDzMIep4r4ife+r1Jq6XnSYlIkzxlub2p/qifPMsEzbz+Ckc+Y7YbqfeAHTaxhlGH2ScX2p+MccsVc724U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082493; c=relaxed/simple;
	bh=X6/aBg5RPf38oAF4Z4GdabSFMmj+BNTbJZjLQDvMy8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WcvJddUqj0TChBzgi4ALW/HpOfa5QSjbCF0zq9fxy4FEBrq3QUNrxcm+TmEMdi03YqDOx1AXTVEsudO3FWCXJ1CjkGzGvRB4+5oDcNO4n8+ea0azROJzl9yJnzjlbxp0E7nJg82rKPQIet8Wjn3GdoT5RwOwhFY4sUDoM3OWHes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CIviIwfA; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749082491; x=1780618491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X6/aBg5RPf38oAF4Z4GdabSFMmj+BNTbJZjLQDvMy8U=;
  b=CIviIwfA8ZaJkxN9gZdMcSxzVfYe4YXobhZqVbRD1fBDuwN4w8W8gswf
   tDU++wkrQlMRpVkU2emzI+yIrilgsK+NVsq6CLotay4E5icZJs2MGV5V2
   HYfWK77nEqbqPFyJ+KgqyKjrZ8CT1nJXxXvSf6LqcrlUusx45fVeUU7gV
   pFbPtUG4DM3vl1PEt+HjexE6bKsO8DsZ4BJ/kV9M0am+h+hhiH69lkO+p
   su/slXnho5l2b8jLhtesq3rempZrMLETSUbc1MRCxE0/g2SIK4dOl3/3E
   QTTV7Dg/0TN5JHw0WlXX4NNt1m11FAgceEa/Q24XAt+zR1HIOQjVPV8ma
   Q==;
X-CSE-ConnectionGUID: SHJAqSAfQIq2h3fp9nXD+Q==
X-CSE-MsgGUID: 2N3IAqd/RD6dIuOuwgbZ+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51103633"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="51103633"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 17:14:50 -0700
X-CSE-ConnectionGUID: L+cbb7CPTX+w30S/aQX8SQ==
X-CSE-MsgGUID: YX8xFPIlS8e1R6ClzLDJCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="168511502"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 17:14:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 17:14:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 17:14:49 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.60)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 17:14:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9Pk9lQPyQ+4IzpcD80YONioNbwvU4kHlWjPB7RbvzKM/pQVJRiobK5Nqmecuc6UwbGh9N0kfZT88oaS4JlSXfeAUyBP7eOra7mT4woXS/y01uGB85O3axW7+Foa2Cn7SbK2ZNq9OzaaGetLO153SBlTpJxCJqOi/J6Uk2zqPzAph7DJnpMlxVx4mcVg2kN+06FBpDt33n79D3E83xMQ20hAC5u+TvK1gEhsJ/k+8Au/iKjgILDaLT7JIvrtinJrhvsQ/8osJmX/4f6CF+sLQIqZTMl/OtD+8J5UHbVnceCVlDgHXtJpnzHVoP59zdGuLn0f9lyZtwL2+NUpRRakkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6/aBg5RPf38oAF4Z4GdabSFMmj+BNTbJZjLQDvMy8U=;
 b=l8ny5ABkKundbEfbSomOqTbHQ6bynbtuV0hC56zaxXuk1q+iGoM0puBJOs1Oh2QiebiENEbGuCo245a10yqw/R0SZs9UMc/fwblAb9pcqlM7VBOAR4wBX3/DWxLDoMbSn1fRd9Vt6e0iojdxniANFEQPy/dWirqdCwWWhSnH6vN/RIl7LnkzQbdDOz7TQUeoWIXeWZmt/OWLx0Q/bB2TEziHpHohhLwQLN4T1EHy6SqTNdbsq2uo61JHwoleHaIs9/7BtbjuT+kjGdWKSWvlRewhYmUlRKd7f70BAo9TVOicVqeeWR6YQ+alseq5TyJCfkCIjLLDzO2fpttbCgdrsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7507.namprd11.prod.outlook.com (2603:10b6:8:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Thu, 5 Jun
 2025 00:14:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 00:14:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 02/20] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Thread-Topic: [RFC PATCH 02/20] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Thread-Index: AQHby8iK5F9fOtaWc0+3IQP4NuCnfrPy/vcAgAAOjgCAALiTgA==
Date: Thu, 5 Jun 2025 00:14:46 +0000
Message-ID: <2969928a501a26c79e0b233e533a3ef5874da824.camel@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
	 <20250523095322.88774-3-chao.gao@intel.com>
	 <95c57c6d14b495f92af6bd12651b8b5ae03be80a.camel@intel.com>
	 <aEBGnC6g6D2tmBR5@intel.com>
In-Reply-To: <aEBGnC6g6D2tmBR5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7507:EE_
x-ms-office365-filtering-correlation-id: 24b44e93-0ffe-479c-1f55-08dda3c5fa77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b3lOOXJUV1BtOE5qN1RGOTZ3WGUzQzBPUUJnOVBHVmIwMU5DVEkrUGxuQkdV?=
 =?utf-8?B?bGdHY0YvZGNhdkh3cU9HY1lJZUIzN0F3NGp5eUluUzViMk4rMG5zb3FEeGJM?=
 =?utf-8?B?TWtrS2JVVVMxZmxNZ1kwZXdLQnU0WUxCTyt3d2xVTWx2dEFRRUNOWFJBUGlN?=
 =?utf-8?B?ZWhDVzJLMTZwKzhOcmhsQ0tZUFdvWWhuQWQrS21WTkJ4OUJQZHBFdXhvR1lO?=
 =?utf-8?B?RVF6UDZFYUcrNEMvOExUS3V1akJMTExGaWI5YnBwbTczd0NWZEZncThHMlZB?=
 =?utf-8?B?bmZtdkpNUFEram5oSm9nZzJubkp5UDZLQUtSK1dkWURQci9VODZWMUUxcGl6?=
 =?utf-8?B?ZHpBbnBBQjVabGRJeWFHcmZ2Z1FVQm1xV3paZTIrbXdFRkQ4SFEraWVLNElx?=
 =?utf-8?B?RVdpVDdQTUZZV2VsS3RHTCtNbkFTbkNXVWxqUkZ4RzhXWUQ0YjQ5WGlGdUlN?=
 =?utf-8?B?MURYT2krOXpnRE52My9QWm9NbmhvYk00aDJ0NnUzZndlLzR6TmN0RnB2bHZ5?=
 =?utf-8?B?TG5UbmlOSjhyeGVmNnBHWlFGNmVBNk1YQXQ2OXlUWlJwRjNiYjNhUFhDZGVY?=
 =?utf-8?B?Mk9Pa0ZMeTRDR0ovZjdlMWdnMWQycituTW9XZS82ME00YU0xcDBIcUxxdENZ?=
 =?utf-8?B?cWx1MHFWdi9hSnNXR04weU10ZEtkdTVWb2FsQVZpUVVLaHZHWlFoV1lDdWJJ?=
 =?utf-8?B?ODlxWnhqYmJ5QXZUOFpqOWhvSzZTVkFxWmRTSzJjNW1nSWZYRnlsalh2c3pF?=
 =?utf-8?B?RGdvcmlVdHhRNEN6OUY4eGtRb3hjeWthUDhTRnlFZUFlWXJPaWhOMkY1UGZY?=
 =?utf-8?B?bVRUa3N6bEFyZ2loQjd2WWhtekFQYkp5Z1lSdlYzRDhtMlpmNWR5MzlFREpm?=
 =?utf-8?B?Wi9wQzRIY055NHpTVGhGWjkxYkcwOGwvOW01WmgvbTBEVkRaQ0UxSy92dCtX?=
 =?utf-8?B?RmFjOVo5VXFHNzIrOGN5SEZqRG1BOHMxZUk1b3U0U2FCSUREd3FyTjlkT1F6?=
 =?utf-8?B?Nkd3dDg1U0pzY2Z5RHNCV3hEMVA0WVdYSUZTYUpQbVg5dkxMM1FpN1ZuckFF?=
 =?utf-8?B?aytsUEkxK0pJSVhtb0lSYTFBZUZsZDlPQktubDU0ajNqRlgrOXdQOGVSUU9M?=
 =?utf-8?B?M29sYnhNZjNRakFWNkFITzJlL3QvL0s4TXlpUzVzaVdSdk5uOGhtcHZpWWly?=
 =?utf-8?B?dGI4M0RrWG9CT1pISmdDaDRyV0E4Q3RwMzNKTUQ2S0ROYzI3N2lZQk0yUjVo?=
 =?utf-8?B?WSthS2FBNVFKUEVvQlFIeFBWb2dvVFpHQ2pqcmNXVnRFQ1lUNGVtVHNiakx3?=
 =?utf-8?B?M2hoZml6L3p3N0k0amlqYy8rVlkzNWkvdkpKbDFFMytGT1ZNbEEzZU9vUW95?=
 =?utf-8?B?MWppelVFQTdGQmFjZmx2UFAzQnp3UnhlckxUdkZSak5XUTdGa241eWVkNFc5?=
 =?utf-8?B?emV6YlpMQWlEN2R1aGRyQ2NwZFFIM21kVEZoYjNjWS92bUp2ZFdqMDRDVXhH?=
 =?utf-8?B?N0V4M0E4OFcveUhXTVAzck5Ra2JxcUpEUGp0RXRaQ1BaLzFIZ2l6OWFFZ01Z?=
 =?utf-8?B?VkRabUEvK09PVjVYS0tZd1hXS1FuSWpMdWlram1pNTkybGJkRWJERWRnUVVM?=
 =?utf-8?B?ZStDbFhBcHRhcU9BS0lzMnJGZVhsbXhYMFNqOGR3VUNlU0J5aFlyMDkvTndo?=
 =?utf-8?B?dFo3Q0I1aUVjbzhxOVBKU3lyVTd6QmF2ZE1JZ1pVY0pjcWVSSmZGem1JRytD?=
 =?utf-8?B?WXJ6MGxvVTNkT1dVcWk3Ym1yeW9JNGFpZkVYN3JwRzZDUStLaUhEeks0QWVH?=
 =?utf-8?B?VEdpVzBFSlZmQ09tZnJTellCUkpZMzhlVzhPVTRYZ3BaK1g0Vmh0c3hFc3Fy?=
 =?utf-8?B?SXRzM2J2czc0WUZ1bFppVWpSYkQxdFdIZXVHRGxxTHJYL20xVXh2QTFib3Jp?=
 =?utf-8?B?d3NjS0lXcWR3VHFFaUpEb3Z5NFIraUxDUVVJazdxRElJZ09BRlU5MDFQZWxw?=
 =?utf-8?Q?fxZg8VqMDm1pluBvpvLcca9qVr056s=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVQ2d3g3dm5DbVBSemZERG5QUEQwRi9pQ2xZbUhlSzAxYjZzYmZ2OVlDbk1m?=
 =?utf-8?B?dnZ3Mm10TFIxV1FWT2ErOTA3SnRhcHI4THptbmdCcThyRHI5VnBBSDFFcVJK?=
 =?utf-8?B?UVJJNzR3dUNlVHFlYUFkNlVJQjlXYkg2UmlVUy9JR2xGWjV3dlNCUTZTbnVh?=
 =?utf-8?B?UWVxbExXa2FGM0sxOUpmUE1BZXYzSHVkN1pxNmROQzhHRE82aVVsbkp3S3Ev?=
 =?utf-8?B?WDdJZFM2dmlSb1hvQVRacVpONnRpNFdPQm0vN053L08wSGVrVi9SOGp4VHJq?=
 =?utf-8?B?K0tObzZhMGJmdkJqMDRXUmEydm9yU1J1ckhmVEk3VjgweW0yL0xZbmYzM3NX?=
 =?utf-8?B?MjJ3b0xjOUFnTkRMYWRhTjh0SWI5bkZyWXp0a2dNOU1ESlpxYWtoemJoK3ZE?=
 =?utf-8?B?cWVPck1YU3NmcTh4Y1pCMDhrOUNHQWNvSnZYTitrWjVmd204c0l4bTVycHJs?=
 =?utf-8?B?aWk4QnMxY0xmdUpuOEFTSGhJSStVTUZ2aUJUaXZOYzlNTitIMkZXcmxldjBq?=
 =?utf-8?B?ZUZDVGt3WE5QWkIwbXdEOExkdXpMK1kxYnB3SVRTSVF5THpyVkxKMkFpQWZG?=
 =?utf-8?B?N0dIMkJuRlUrYTdMTjgzSlBQVzJuQlZYckRTWDRrMGhZeUtvZ2NHbFlLSGd3?=
 =?utf-8?B?ZDF6R0Z2OCtBNlhTRTA1T2grTDkveUs1VDdLSDNiYmZZbFQ5UlVsdWljbFB2?=
 =?utf-8?B?RU1ocnJ3ZFAwOUxDUzdTTFhNVnBwaXJIVk5CMzNVc1RQeGpmK2lCRmxpd3VZ?=
 =?utf-8?B?UytqYStiTkNHaGdlZmZLa3pwazRTMnEydm5aUGNwamU0UmJaeXNlSk5nU2tV?=
 =?utf-8?B?UUlMbDdsb2l2NGdoSktXTHppSFV1enlNU1VNanpuZFRPbi9TY3F2NGJtb1ZC?=
 =?utf-8?B?RW5DWnBxSUlBQkhudFh5bEFqdGZ1bnZKTmFrSWpRSDlhN0RSQ2I1Q1JrQTdD?=
 =?utf-8?B?bTI5bjdsc2wxWDlvclFxYW1hMzFHUzlXZk0reXh6eUVaQ3hzWnBWdzNDT1d1?=
 =?utf-8?B?eCtpU1BQUnRtd2x2K1RGNk92bnZZT0ZGSExFMUQyNFZydHM5Zi9MUy96MVVM?=
 =?utf-8?B?K0VML01rL0lLYWZiOG5uMUV4TDlIdVkzUlZqUGpoaTUyWXRFZ0tDd1hEc1BB?=
 =?utf-8?B?Uk9aZTZvNktWVklMakJYMUJhL0x1R3BCQjBQd0RiakZJLzVSNE5xRlVlOHBp?=
 =?utf-8?B?VDhtZUJ0ZGYyMXlDWEN6UVdWOTR4d293QmZwZS9NTUVuRXJoUWRMdENvN3V6?=
 =?utf-8?B?cWpHWDdpL2hPTDZBWkNUbUpYdmJtVXpuWmRqT3RBZndFTEFBK2YvemI5d1RL?=
 =?utf-8?B?NFpIY0NDejFhL1JaSW4xaGtpWkU2V2FsQitPQjN5S1JkcU1qYTlTUStXNkor?=
 =?utf-8?B?VmI5NVZWOFJHQ1V3bDQ1WVpIRWdhMHppOUVsU0w5WkNPS3JTTXIzeDR6OXha?=
 =?utf-8?B?YzZsUFVET1JYbVlNMTdEYnRxbEZ1NjJPRFlRWElLNGxTdWpmSUNCNDRLZUpk?=
 =?utf-8?B?ZWo3Q3VyZW9wRmhKYStMTnZVSmFrVHYyWWJnZU8rd1VNZ0wzaERWcHVIYVFT?=
 =?utf-8?B?VEc3SjcvL1JmaWF1bERJbFJtelZXQmhGQzg3UVRNa0FmRFFSZXk0NEJWd3Zp?=
 =?utf-8?B?aW82cmhkSXNNa2dUSEF6cWxXaXc0U3hzVmR4ZWNwSG8rbVNvcWRDK21ESHlD?=
 =?utf-8?B?S0Z1L01TRVpjeTlLVWY5TU5qN1VZWGZqRjFucHRlMlFkdU9MSGJaRUhZaEp0?=
 =?utf-8?B?NG5SeHB0Yzg5QmlYN0J2K0gybjhLWUNHbE9uUy9tTWVHRDV4bkdJWjg3SHcw?=
 =?utf-8?B?aEdySGhzTFAzaTBmc2VXc2hGSHR0SlgyQU80Tmd5dWdRem54VGZBOGJaTUZ3?=
 =?utf-8?B?aitlOERRSXVPc015TDRqMWxZblUvMSt6a21ZM2Nxa2tOZ1VzOUd1Tk95WXFK?=
 =?utf-8?B?U3JMbkNyK29mK1BVN2lJOCs1dU52VUdocWpWMlpLcDBocG5PKzRIM0JPb25E?=
 =?utf-8?B?NGZISXRZZkN4K3BrY2Jrc3VUYVhzZjZ3ZVlVd2VVbFcwZXQ0bUpzSVkzNktT?=
 =?utf-8?B?eDRZV3Z1VWFHRTViSmM3dmpYaTJVT0Y5d0ZkdTdXZktLQndHMDRBWEhEWFFO?=
 =?utf-8?Q?7klhoaAyN7KxnmEx4fJ+j5WVw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E6CD47C0ABDBC4E9B3FD1320686390B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b44e93-0ffe-479c-1f55-08dda3c5fa77
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 00:14:46.2304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypwkdu/oHUy9Fwp395FIbDliamNIfQ9EthuJ/aQbKXvfVA/dHHevh7DZTUSK3uyDW1Oo5XF954jH+344Pt8qew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7507
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTA0IGF0IDIxOjE0ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+ID4g
R2l2ZW4gdGhlcmUgd2lsbCBiZSBhIGRlZGljYXRlZCBzZWFtbGRyLmMsIEkgZG9uJ3QgcXVpdGUg
bGlrZSBoYXZpbmcNCj4gPiBzZWFtbGRyX3ByZXJyKCkgaW4gInRkeC5oIiBhbmQgdGR4LmMuDQo+
ID4gDQo+ID4gTm93IGZvciBhbGwgU0VBTUNBTExzIHVzZWQgYnkgS1ZNLCB3ZSBoYXZlIGEgZGVk
aWNhdGVkIHdyYXBwZXIgaW1wbGVtZW50ZWQNCj4gPiBpbiB0ZHguYyBhbmQgZXhwb3J0ZWQgZm9y
IEtWTSB0byB1c2UuICBJIHRoaW5rIHdlIGNhbiBtb3ZlIHNlYW1jYWxsKigpIG91dA0KPiA+IG9m
IDxhc20vdGR4Lmg+IHRvIFREWCBob3N0IGxvY2FsIHNpbmNlIG5vIG90aGVyIGtlcm5lbCBjb2Rl
IGV4Y2VwdCB0aGUgVERYDQo+ID4gaG9zdCBjb3JlIGlzIHN1cHBvc2VkIHRvIHVzZSBzZWFtY2Fs
bCooKS4NCj4gPiANCj4gPiBUaGlzIGFsc28gY2xlYW5zIHVwIDxhc20vdGR4Lmg+IGEgbGl0dGxl
IGJpdCwgd2hpY2ggaW4gZ2VuZXJhbCBtYWtlcyBjb2RlDQo+ID4gY2xlYW5lciBJTUhPLg0KPiA+
IA0KPiA+IEUuZy4sIGhvdyBhYm91dCB3ZSBkbyBiZWxvdyBwYXRjaCwgYW5kIHRoZW4geW91IGNh
biBkbyBjaGFuZ2VzIHRvIHN1cHBvcnQNCj4gPiBQLVNFQU1MRFIgb24gdG9wIG9mIGl0Pw0KPiAN
Cj4gbG9va3MgZ29vZCB0byBtZS4gSSdkIGxpa2UgdG8gaW5jb3Jwb3JhdGUgdGhpcyBwYXRjaCBp
bnRvIG15IHNlcmllcyBpZg0KPiBLaXJpbGwgYW5kIERhdmUgaGF2ZSBubyBvYmplY3Rpb25zIHRv
IHRoaXMgY2xlYW51cC4gSSBhc3N1bWUNCj4gc2VhbWxkcl9wcmVycigpIGNhbiBiZSBhZGRlZCB0
byB0aGUgbmV3IHNlYW1jYWxsLmgNCj4gDQo+IFRoYW5rcyBmb3IgdGhpcyBzdWdnZXN0aW9uLg0K
DQpTZWVtcyB3ZSBib3RoIHRoaW5rIHRoaXMgaXMgYSBnb29kIGNsZWFudXAuICBNeSBURFggaG9z
dCBrZXhlYyBzZXJpZXMgYWxzbw0KY29uZmxpY3RzIHdpdGggdGhpcyBzbyBJIHRoaW5rIEkgY2Fu
IHNlbmQgdGhpcyBwYXRjaCBvdXQgZmlyc3QgdG8gc2VlIGhvdw0KdGhpbmdzIHdpbGwgZ28uICBB
dCB0aGUgbWVhbnRpbWUsIHllYWggcGxlYXNlIGNhcnJ5IGl0IGluIHlvdXIgc2VyaWVzLg0KDQo+
IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvc2VhbWNhbGwuaCBiL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC9zZWFtY2FsbC5oDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjU0OTIyZjdiZGEzYQ0KPiA+IC0tLSAvZGV2L251bGwN
Cj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvc2VhbWNhbGwuaA0KPiA+IEBAIC0wLDAg
KzEsNzEgQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4g
PiArLyogQ29weXJpZ2h0IChDKSAyMDI1IEludGVsIENvcnBvcmF0aW9uICovDQo+ID4gKyNpbmNs
dWRlIDxhc20vdGR4Lmg+DQo+IA0KPiBJZiBzZWFtY2FsbC5oIGlzIGludGVuZGVkIHRvIHByb3Zp
ZGUgbG93LWxldmVsIGhlbHBlcnMsIGluY2x1ZGluZw0KPiA8YXNtL3RkeC5oPiwgd2hpY2ggaXMg
bWVhbnQgdG8gb2ZmZXIgaGlnaC1sZXZlbCBBUElzIGZvciBvdGhlciBjb21wb25lbnRzDQo+IHN1
Y2ggYXMgS1ZNLCBzZWVtcyBhIGJpdCBvZGQgdG8gbWUuIEJ1dCBJIHN1cHBvc2Ugd2UgY2FuIGxp
dmUgd2l0aCB0aGlzLg0KDQpLaW5kYSBhZ3JlZSwgSSBjYW4gcmVtb3ZlIGl0IGFuZCBkbzoNCg0K
c3RydWN0IHRkeF9tb2R1bGVfYXJnczsNCg0KZXhwbGljaXRseS4NCg0KQnV0IHdlIGFsc28gbmVl
ZCB0byBpbmNsdWRlIDxhc20vYXJjaHJhbmRvbS5oPiBldGMsIHNvIEkgdGhpbmsgSSB3aWxsIGp1
c3QNCmxlYXZlIGl0IGFzLWlzIHVudGlsIG90aGVyIHBlb3BsZSBjb21pbmcgb3V0IHRvIGNvbXBs
YWluLg0K

