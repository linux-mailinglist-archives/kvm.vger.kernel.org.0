Return-Path: <kvm+bounces-20721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A15391CAB0
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 04:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C70E628371B
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C87D1CAB1;
	Sat, 29 Jun 2024 02:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+qZfY2Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67621802E
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 02:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628891; cv=fail; b=HTRv9IYSBUB1w0K1YFvRSrENJj9o+dyE1SCWAgh7p3s/gBuRHHsv5V92BPYthGsApi95l9XIlIhF3a7QyHWptADAze/LnvwqxKp48dB+F5+bvEr74sHwWQDcIS8gqr3oGej9unvgAzQ6rhN6EM27m8kIQDY+ihW2cYOTnu6iWe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628891; c=relaxed/simple;
	bh=4xNXLsiQ/cBRCRHgqA1fMeAjBDxbZbhscWxnxpamVvY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lZc8wFBkOT6+LSkZvhB4sXsTZEyCc0JMBEtsYg6D2CQhZ+/yY3OpxqqK9GiSG92GXYV/KFrp1zBOdFKKdItRhiyLiSwD8J5WpcAC/OTQBKBaiB7u5SqGZ2ulVqQ4GR7cIQmubc6Jzcva+U18NfCL3HI4gZTAgYVMDB9FffTMeUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+qZfY2Z; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719628890; x=1751164890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4xNXLsiQ/cBRCRHgqA1fMeAjBDxbZbhscWxnxpamVvY=;
  b=F+qZfY2ZXeUHKu4CV2+nlMnUJcjPsG9Z9oqLSCN7Wi0VR1rv69l8hMZB
   gHhv73tbyeua1l4l9Si7kkk7AAEmXfbMSlkFaIRKnokkmMo7LP3dpnq9b
   PYZYfdgXDezC7ozSEVGMUWJHcXpdO+MM3yFuc5OU7wQT0bBGnXv86MXUz
   NXi26rg+CeTFBYvh+3u4idOzba90b/GMMUZuTf2aJgsYA3F3+cbWzA1lk
   UZOVD+3qNY/PmZ59sTVbrzNOgQDrWUeTFSrSorGO3DLZM98XTAsLQ9KVy
   UzR/C55eXMjA98/N5N2gv7mziVbTspWglZIchoC5Q01wJwJO8v9x7QtOP
   Q==;
X-CSE-ConnectionGUID: LIBWNJPLQM+Pm4t1g1IU4Q==
X-CSE-MsgGUID: T0egLsLzQYeDtOzezC2tUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="12311973"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="12311973"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 19:41:29 -0700
X-CSE-ConnectionGUID: Zy34Od1PSWWuI8nPN8N1Wg==
X-CSE-MsgGUID: ru/jWBKiTqKvqbYb63P/Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="49812365"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 19:41:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 19:41:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 19:41:28 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 19:41:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0amzLLxJPSm30R4Fk/g/p6VEweTtbyiur0e9dLLjB3S2JjHhSa8MbiZpD0RD6hxoceRWiZqChCYuM/SmHbXof9MF42by8wzBZt68SArfFzO+vKdDzkJT3oprX3LmrhtgJiSEKWHSSvXmmIUwsqzUqMsKMnKYlTHE9l6VB2IghLcfL9NegKKjd295JvB5nJcI+9eVAVyjmTNOGaV2pIvSojmHGg8LQy9XbLVKbd58SU3UQRnm4VeRxTiosBKe0H4I7e3C9zEtVmyPgz00BTyQ6ot7ENdinzYXED/L2XdGqVFXMV35UaCmX5X6Fkk++qAZ4fYHv1iSUeBK72Qf2D3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xNXLsiQ/cBRCRHgqA1fMeAjBDxbZbhscWxnxpamVvY=;
 b=WwRK2qZMM+Al7HAWB/C0Lkg/ZAXk36S8rsOH8vMTXwlb8acPBTDe6sVk958i/uS2ryjhUINKNhFJlOhSejdDY75MSOpKUnSw0JbgdidDZq9y6JbnadQ5Hm5AMLol2FyXpEEGMVVPHs/myyWu2r8dJ09/KEyxPsse1ECVlzF3702lpcCfH4ncBhXx9Qlulvpg2NrmNzVUp6fOMubyRKhjR0IrxQ9cS0jvJnCnjuxfahfNIQehbykBhxKf+7CDhwFokRMKmc598kQ6pddoRaSP7RWBtePMWaJY1HzSIZ4pXYp9+M7uHbF41mhntS0uxV8kzGbrRJcXrBCIvT3brhWTHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Sat, 29 Jun
 2024 02:41:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7719.028; Sat, 29 Jun 2024
 02:41:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "flyingpenghao@gmail.com"
	<flyingpenghao@gmail.com>, "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "flyingpeng@tencent.com"
	<flyingpeng@tencent.com>
Subject: Re: [PATCH] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
Thread-Topic: [PATCH] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
Thread-Index: AQHaya5vEyyeDiipHUq+Z2c/yOmH0rHeCEMA
Date: Sat, 29 Jun 2024 02:41:20 +0000
Message-ID: <b999afeb588eb75d990891855bc6d58861968f23.camel@intel.com>
References: <20240624012016.46133-1-flyingpeng@tencent.com>
	 <171961453123.238606.1528286693480959202.b4-ty@google.com>
In-Reply-To: <171961453123.238606.1528286693480959202.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5117:EE_
x-ms-office365-filtering-correlation-id: 7ce01535-6213-48fe-e20b-08dc97e4f532
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WEozSzRpWjhQRlp3TXRHNkVvUzF6UmVLRkJJbGsxVEd2UG9SU1pQTzFONWp1?=
 =?utf-8?B?RkIwMzA0K2V5VnMvR0pkY3BqUDVyZTJGaTNWdFdiYS9ab0wxU2t0MmV1c3lY?=
 =?utf-8?B?eUp2czhrQzJxOVBWNkdob3lzZ1gzZGh5OFVVQ28zMStjc3YwUU5tOC9RakVs?=
 =?utf-8?B?UlJncHJuWUlLcGZrTlYzaVdVR3UxVHN2YzhzNDNndkc3b1ZCaDI1a0k1TjRs?=
 =?utf-8?B?eFVRdEM3ZXFwdGhpM2JrMXlHbnRlWElBbSsvVUtsWFhFbi9KSnl1YVgvRXRI?=
 =?utf-8?B?YjN1Z0RGbDNvRHJFbW1iWUJya2NDZkx1cndDQlVndElFakY2NWZ5M1BlV3Fo?=
 =?utf-8?B?VUxXL2xCQmdCT2djQkFHbUdIQ0FtajVsYkUxdnQ0MzkxZzVUT2ZJenI2N2tY?=
 =?utf-8?B?dnR4SnNGK2tiM2dVREVNeWdzd1ZFakNINHNQKy9RYXozaWNLcTcwUXZEN1Rt?=
 =?utf-8?B?TEpaSkdyTG9ncytMM3RHNFIwZTFTb0FRcWNTbkZmTFJEc0VDU2oxMjcyVENw?=
 =?utf-8?B?WUtCbGhEQ1hMeG1ER09Tckw3MlRURzNJOGIzckxtdUFuK3kxMlVnNWllMHNq?=
 =?utf-8?B?d0ZBa2kvUU5FUm5pekUwS2RGMGZLWWNlQSs4OStvU1V5VXR6bzBQd3J6bzk4?=
 =?utf-8?B?TDNiWXdWYU0vZnNDbWZFYWhCQUlvd0s1bUdDOEdlVng5VnlISjhLRUtSVlVV?=
 =?utf-8?B?eFkvMm1lNUFZV0ZlSVl0S25SM3BmUXVVWmFiSlVaR0gzaVZTc0xrdnJPY3RW?=
 =?utf-8?B?NGtUQm56ZlBkVDZLZEE2Q21RNjRwamRMUDhLMnA1bWl3MEwvUklYb2J1K0ph?=
 =?utf-8?B?NHVhcEZyZ1RTc2VJVnZSWTA3dG5ta1E0VURDQ2RaeUhiWUlRRTNyNkczZDg0?=
 =?utf-8?B?VjV4WGRjSzhZWHRDWk1OendDMFlNK2F4djNjU2F4MWVvNFNuSGdkNU13cmEy?=
 =?utf-8?B?aTluZG5JellCc1lWTGJoaFRIczA1TVZBRlgxYUJsd2o4L1RVemV6eGJhV0RQ?=
 =?utf-8?B?L3dTcjJZaTgzL2ZCZGhZS01UaEtzcnlXY2NyODVTVkxSWEF5VDJqd0FNSlVV?=
 =?utf-8?B?RGtzMnRKRTZrUUF1aUtJYWs2a2lMSmZZZjVXN256VWlON3JlZzJRclp5MTU0?=
 =?utf-8?B?Q3lHUkI3VWxVZ0p0dEo3VVY4dndNM1lsMWFUR25LQmdkVkRhV1laTWtRWmtn?=
 =?utf-8?B?dWZSRWFEV09HM2FoeTBlald2QmVFRGZ4WStNeVI3UVRHeGQ2YWRvb2ZFNzB6?=
 =?utf-8?B?b0RmMHhHZDlMRlNkbFVTTHRPSGovT2ZJRUVFbUhMZ2doWk9hN3NtT3VxREcx?=
 =?utf-8?B?c2JXVWUvRm9KdzBGQVRTUUhSU2hxS1RvNmUwRGZCRC9mc3o3VDNYclZYdGk2?=
 =?utf-8?B?ZUtGQUVMd3hzWGh5azloMnBWVHpGdDJ6aG82MlNKZ0d3VVYwVnpZbkRmVStW?=
 =?utf-8?B?WmhnTnA2OGxqZ1JKRjFiZXVMSWJlL3drbDRlS21ZNldPekIwMnY3M0dwU1gx?=
 =?utf-8?B?VUNyQVhDVW5NOXkyRVgvM1RyRUlwbStpV0EyNWJXZ1BBS0VrTEdoWmNnbXlF?=
 =?utf-8?B?ZEY4MnpmNjJYRVVrTVhwLzFsWjBLWStleXdGOVF5TDdtTWpIODF0aDlRTmtC?=
 =?utf-8?B?NkdaRXdZbjVLT2swc3EyUVVyaytqcHoyS3FMMGY3TWtJaGJOc0ZFMXlpcHUv?=
 =?utf-8?B?M05aZ1hsK3RVaEdveWV5YWtFblplemNSbWozUUhvQmJWdWJqNEQxa2NYOFp2?=
 =?utf-8?B?Q05YQW9SbGRuemFLdHZVdDFzQXdWL2xXa1IwbEw3NFQ0Ti96RjhDd1RQQlAz?=
 =?utf-8?Q?kkpFlszjaqADWheTqRcMugLjQwBVVv1BxMvVE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUc3U2J3SnFOTGhCNC9mVmI4azVvNm9BalBwQ3d3Q1VuRWd5K05jUWZFQll2?=
 =?utf-8?B?LzlIMW9MRlgzTjJDSDZpVVpHUVN1WGc5YTFDdFU0d045YVBMU0tUMXFPQ2RW?=
 =?utf-8?B?OGU4bUZDVW9lVFNYSHRoY2luZWxIRjlzc0EwK2w0aUJLaXN6cWQ2akN0cmZ4?=
 =?utf-8?B?MVN5VDAycndLbWxCcUphRGFKbnRJSE1FeHJ1QjN5K3hGcUZ5amQweDBFa3Jo?=
 =?utf-8?B?enJUd0szcDZkL0FKbjJxUjh6NERpU042WTJtY0VERGovcld4L29zWW9FUnBT?=
 =?utf-8?B?KzF2UUtoakdmamM4eE85emJGR1d5cTVyanVIZXpxT2tWUm1KTVZOcmhBdlRL?=
 =?utf-8?B?eWxHK1prTkxNSFJkSzhZa285Sm5rZU5WODhTeUlJU2twZk1wdWFuOHZtdHNI?=
 =?utf-8?B?SGt3amtGL1E1Tkczd0ZYTUFqZG9SUTdnTjE0bWdRWWJPTmlZRm9KSW5Gb1BV?=
 =?utf-8?B?UE1qRDhTRzlhU2t4MFhIN1RCNVJ0VFNzZkFoLythMGE1KzlZUXoySHlWanpF?=
 =?utf-8?B?RndMaXhtSm5JVUhkUzlUZTFjdi85VFFoQ3B6M2dnZGo2TVFmS213OHpFaXJX?=
 =?utf-8?B?dUFOUlVWMzYyNk15dGo5WDZKNlU1NllLQ2owSzlBbE9OMUJWeHBlMmVJODQ5?=
 =?utf-8?B?c2E3SkgzRk5KSTdsNHoyZ2xjZGhac2lWaGh4QzRFaC9nbUk1NEFkOUhmcjRy?=
 =?utf-8?B?SXNuQVlLenR4K3ZJNExWWnRlSTFHb3V5VytzSHRUZ2ptZVRhT0IyMFJRNVRZ?=
 =?utf-8?B?RS9CdmlwZ2hpWlhJNEdQM3NReXV4QWZIRnJlWkJ1TGpvNjlGQzUrdGlQYVRm?=
 =?utf-8?B?WjdZT1hleUp6MnFsS1VuT2k2S1V4MXVPVjZtWi90ay9STmRnS1YrKy91Z090?=
 =?utf-8?B?dkpLeVhadFdLVjRDTFhrOERPbno0ZVBsZ0ZYSjlXMkpLakJwdVVzaU9JT1pG?=
 =?utf-8?B?bGlrRHNYRXlLbERsbEsxMXFVcjlzc2JFWDFkcGNCeW1EWnRsMmJ3U0c2ZVNJ?=
 =?utf-8?B?Rko0bGFMaEtTQXFLNHZRWDF6bm9ZN0F5T2dGNTlkb2J1SHdKZDBzbWpjeDRn?=
 =?utf-8?B?YnFhdWVYVm1ZR2NLVVBFZlFOZWtFU2RmQUJpa1RiaU9FZzFJY2FpWGsreDd0?=
 =?utf-8?B?OWFQU3l5RVV4UTQ4QnM5QVlsMTVXSS9YNWMrYlpRUVJwVHlNU3dMK09xMXZt?=
 =?utf-8?B?eVVneUkrVE05OFAvTTV3aU5ZSnVTSHQxYmhtZkZmdlcvZUt5K3pNR2t2NnAz?=
 =?utf-8?B?T1pBSDVhZTJNWmhtQVJPWTNQcWdWMTVKS2hjWktsWDFKZktCSHZJeGFzKzhF?=
 =?utf-8?B?WjFRMVdWVXhCTnk1N0FvU000YU0vZWdma3AvZ0xBSkYwMnFtZmt4RGhQeUxs?=
 =?utf-8?B?OG8vditibFhDVUxUUUR6Q3hjWGZVTkJSYldFaW1hck9yemFScWMxelJDRy9R?=
 =?utf-8?B?QmpOaVdpYm1uK3ozQVd0aEpUejFiSXI4MVdDTHIyMHE4M1VKVkF3dXYra2Yv?=
 =?utf-8?B?azNiZXVpZktXcDl3QTNmYXRNWmE0WlAyMXd5OGNZTkw5ZlNkR1J5THlyR0xR?=
 =?utf-8?B?VDVoRCtGSzBhbUN4dHBra1Nja3VjeXZJTjhwaXVHUU1qOUJ3Q09PUGNnVkZa?=
 =?utf-8?B?ZnllY0NBQ05Pa1JzU1paWVhybGNnZDNBSzBpbTIyMTk3UEtuNWw2Q2h0WE10?=
 =?utf-8?B?eVk5aDZmazgzK05yTzFyV0s4QWZLa1IrMTNUa3YrMGRvRStMMUVpZGY2dkZY?=
 =?utf-8?B?aFZlbDR6elhOOVZLWHJNSjFsSW02dy9iSjZBNzFiNHIvOXRPMWVRd1pmZUtx?=
 =?utf-8?B?bWJRclB1elFIWnR2Y3E2TERNL3gwSzZML0lFV1pmclMzVnJvc2pvc0NhUHpK?=
 =?utf-8?B?TndSNmk2d2dtWFFpOUdTVW5RdUYxdXZuQlAwZFBvU3V4cm5Xc082UHU0RnNp?=
 =?utf-8?B?aFM0N0JOTnZkU1hOYkdaaTY1Z1N6em1JbHJVZ09YQWtFNWxCOENLenlvdGdj?=
 =?utf-8?B?QnZzMjlzTSt2V1N6OFBrbi9rbkVKS0RzbVp3TXV2S1J0TXM4dkdJWFJxRGsw?=
 =?utf-8?B?RzdPQ1ZsMUJFRDc5bS9KK3FTNW5iK1BxVlZhZ1FZOGJpM1hFUlJ6NDJQNzBp?=
 =?utf-8?Q?uJa3o7OQvpVKAQHMU7avMotSu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C81337E3A55F8740823F0DB29689E3FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce01535-6213-48fe-e20b-08dc97e4f532
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2024 02:41:20.1485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVNbS1HOLQQpj4yNlK3nyHAVcgR4VtBgHz6SJi+7a9bRBiFeasu/OTh3wAeCoXsaLL0sBMee3upGTFF83FMBhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTI4IGF0IDE1OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIDI0IEp1biAyMDI0IDA5OjIwOjE2ICswODAwLCBmbHlpbmdwZW5naGFv
QGdtYWlsLmNvbSB3cm90ZToNCj4gPiBTb21lIHZhcmlhYmxlcyBhbGxvY2F0ZWQgaW4ga3ZtX2Fy
Y2hfdmNwdV9pb2N0bCBhcmUgcmVsZWFzZWQgd2hlbg0KPiA+IHRoZSBmdW5jdGlvbiBleGl0cywg
c28gdGhlcmUgaXMgbm8gbmVlZCB0byBzZXQgR0ZQX0tFUk5FTF9BQ0NPVU5ULg0KPiANCj4gQXBw
bGllZCB0byBrdm0teDg2IG1pc2MsIHRoYW5rcyENCj4gDQo+IFsxLzFdIEtWTTogWDg2OiBSZW1v
dmUgdW5uZWNlc3NhcnkgR0ZQX0tFUk5FTF9BQ0NPVU5UIGZvciB0ZW1wb3JhcnkgdmFyaWFibGVz
DQo+ICAgICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2xpbnV4L2NvbW1pdC9kZDEwMzQw
N2NhMzENCj4gDQo+IC0tDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2xpbnV4L3RyZWUv
bmV4dA0KPiANCg0KSGkgU2VhbiwNCg0KSSB0aG91Z2h0IHdlIHNob3VsZCB1c2UgX0FDQ09VTlQg
ZXZlbiBmb3IgdGVtcG9yYXJ5IHZhcmlhYmxlcy4NCg0KU2hvdWxkIEkgc2VuZCBhIHBhdGNoIHRv
IGRvIGJlbG93PyA6LSkNCg0KLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9zZ3guYw0KKysrIGIvYXJj
aC94ODYva3ZtL3ZteC9zZ3guYw0KQEAgLTI3NCw3ICsyNzQsNyBAQCBzdGF0aWMgaW50IGhhbmRs
ZV9lbmNsc19lY3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAgICAgICAgICogc2ltdWx0
YW5lb3VzbHkgc2V0IFNHWF9BVFRSX1BST1ZJU0lPTktFWSB0byBieXBhc3MgdGhlIGNoZWNrIHRv
DQogICAgICAgICAqIGVuZm9yY2UgcmVzdHJpY3Rpb24gb2YgYWNjZXNzIHRvIHRoZSBQUk9WSVNJ
T05LRVkuDQogICAgICAgICAqLw0KLSAgICAgICBjb250ZW50cyA9IChzdHJ1Y3Qgc2d4X3NlY3Mg
KilfX2dldF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCisgICAgICAgY29udGVudHMg
PSAoc3RydWN0IHNneF9zZWNzICopX19nZXRfZnJlZV9wYWdlKEdGUF9LRVJORUwpOw0KICAgICAg
ICBpZiAoIWNvbnRlbnRzKQ0KICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KIA0KDQo=

