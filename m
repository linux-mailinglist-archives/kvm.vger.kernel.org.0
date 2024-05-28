Return-Path: <kvm+bounces-18241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F848D2743
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 23:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 691D71C25C01
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 21:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E76B73474;
	Tue, 28 May 2024 21:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FcV1UE2+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F101DA23;
	Tue, 28 May 2024 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716932933; cv=fail; b=Lmqh02n8c3F57Xczjqs+snDV3GCawEhUjqGWrOVtsZ4R2xLrjRDesCXKgi4iaevHLybNqcFtNDwDLfx7zvJFaci1Djj77Vss16tr6Uiz9uQwGzPW8TOR77A0p+MGhhSdYZl25jf2pCxLk1m3sVywf4PN8nAEpzCbL/2V7m5Avwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716932933; c=relaxed/simple;
	bh=IKKsX65JCx6f00EnGlAR0bBOILn8AYR7KHRjtV89qPk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sj+vVdG7Ut3Mhkn7hdsIPD7op7v/cRheu9efwDnxepFllTIXeL3O/dE+AYp1CB4dYdaT70pXt4LMbN+Rrj7Ii3JFMuMggrMxHAd4OFVuvv8QkL2WYIl3X8wzTbq++IFEUul86ph0It8ppNDkjMu6DIzJId2cUw4xYO2iLsECQzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FcV1UE2+; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716932932; x=1748468932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IKKsX65JCx6f00EnGlAR0bBOILn8AYR7KHRjtV89qPk=;
  b=FcV1UE2+rnf4l58XuDMGFXxaWNqSwgmQ1f2R056vu9B0h3Ehqjg6jjyr
   72YdiNi1nVFAi5SjI9TlZ2xx1bOD0L5sqaK09W+CDQPGsOe+S4FWt86lY
   /hYPWM4pr5oLd8cPXe+wCpqO1BKR2KdNNXhRONTcbS3sgfntPJqwzSflo
   9mazdZJUc/oQe4xNjq3cTfjFByg1feEdeAxdVKz/fa1dRVaXQjAj4m6Q7
   Mv2CwiNGB8dAuNNIVtgmHQ3viP7jPqy0lGgLzm7OxJunmZJTCqsDKPdLy
   xkQdJYumfu23ZBgW5ub5WZ/sqbrIB2JcznfHny4FqQhL/Ykm+aGx7Zd85
   Q==;
X-CSE-ConnectionGUID: ZcBoOrjxTXyRjbTDAt7/Rg==
X-CSE-MsgGUID: lstJBVPyQdWHrn2mCTj/QQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24436197"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="24436197"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 14:48:51 -0700
X-CSE-ConnectionGUID: XICFB211QpKxGAAd9ErLXg==
X-CSE-MsgGUID: wwhpQSo1Rdy+koo4rqhEDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="39728627"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 14:48:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 14:48:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 14:48:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 14:48:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 14:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcHajO9npWlu+QoHJLksvpw3lRRh/J3380Wy0OmAl7PjsLHoDDtJbtHCB7rklT6VMcOU5JbBBdTjm5DGX5zCAkuv/vxcBCVzlAjeL5TE/klLENRJM93drCzPrj7tb/p1X75YNaRYx2f7sVjJ0RfsYj6Q6393QTVc9BYI0S36U9gLzJvOgX/Kldp60yckJLLNLqCLpjt3QLihqn2t4X1msivyw3erVbdWBmPJbgFcV+QkXdP+2qNiyT9MSEGePqR5ZE+bGiTEt8h81fa02bFTu+Gior651QrcwWw9vq4t/gp5aPUDgoHpTRiSOmep8VFMCjzKQSvyhl+q6jPNIdVqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKKsX65JCx6f00EnGlAR0bBOILn8AYR7KHRjtV89qPk=;
 b=RU/YTRCvebTUl6yr2PoQAPGDxDXI5BNdAp0RISraox3qDRCRnuW7c7M7IimMiDoJO2JAIzq25ab1ZC3r2vfpIMi/BhTgHwJv70nTHZK7Xo03bAoSyG6vO1IhcxJyyZNIcdglOQ8dYfQx05nseOqQeR0m12shQ7oP3d2y+vR7XDuk7r9U53heZXyQsxLM5oUWAkusftZnRJyWGkptuEHakebdEKG1xM2fYuwMZIlZbYUDWx5ZBDP43rmsaxACRvFVSUtYutEGlloENQZBYbfDuhCTjmhPkALv9oyGe1tsWE32fOe7M5vfNeoq2JH4bqr4oCZ28AUkiFRisx4tQboScg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8136.namprd11.prod.outlook.com (2603:10b6:8:159::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Tue, 28 May
 2024 21:48:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 21:48:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GlgQuAgACYjACABytBAA==
Date: Tue, 28 May 2024 21:48:45 +0000
Message-ID: <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
	 <20240524082006.GG212599@ls.amr.corp.intel.com>
In-Reply-To: <20240524082006.GG212599@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8136:EE_
x-ms-office365-filtering-correlation-id: 4f503bb6-07bf-46be-aaca-08dc7f5ff2e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Y1d4LzJUTnltY2JRZmk2TXZ1aFBiZTVOWDhQZmpSdHZDWWRxNnlnbjR3T2pO?=
 =?utf-8?B?Mm9SU3ZoK0gxd3NDem5oMmdGK0VaL3JLSFVmb3pOU0plU01iTURPQ1Y0OHlj?=
 =?utf-8?B?MjhJbmE3aEdidU9SdzJGczZiZURuK2FSMXhNMWk4eGZZWHdlTTA3RndVSUNl?=
 =?utf-8?B?NmlNZnlZMU1PY0Vrd2ZNUDVsdW5vYUpxNS9mTWJvOGlzMW5SMkc5bmxIdDFT?=
 =?utf-8?B?SCtFbGczazVlVklzWnI5dGJ6aGh5NU9aMXcyejl2MXM4K1hPbytZT3JIOTFO?=
 =?utf-8?B?Z3I2N1VFUXlCR0FSUzFreVZTVTkyR0JtQjRlaG9xWnN0Rzg1OWJqRUhWd1Nt?=
 =?utf-8?B?RHBlUFhBNnE0V2tnMnFZcWQzTURhaytqUDBQWXBqdmVrRGs1UDZ0NkJHcEF3?=
 =?utf-8?B?NFJ4S0c1REcwcFc2MllhNHlqS2IrcE0xQkllV3l2d0Q0V1d2ejVmL1hyU2hJ?=
 =?utf-8?B?YkJOTVM1VlcwS3VRQXdiVEp2aHRFRlBVcDBXd3JDYkVCTktkSEM2M3BBZm5k?=
 =?utf-8?B?RDZzMmlGNTFBMUdBUnR4K1RpRzRpdUYvSlVGdzZ5aG5XSUNlbE1aYVUzRXBG?=
 =?utf-8?B?SGh4VEd5N3VqNkpJeHBFeFNqRDhEL3FoekFtRDlONGsvYlg0MjI4aVYwTUFT?=
 =?utf-8?B?SVY0RUFFb3NySEZ3OU5reEZKOEJEdTBRT2ZOSUkxQVo5WUZ1aXVtcW5vc2Q2?=
 =?utf-8?B?OG9EVUpwNVJyOG1pUkhOdmVzZFYxdm9LZnVpMStwVWdmN1BIeldMTmQzMEVH?=
 =?utf-8?B?UER0WWViSjBaNGtFRTMrME8wZkpFVUZjeW82UnRsRGQranZDeTFGME5uTHNF?=
 =?utf-8?B?OHVJTVRVVDIrT3Bxb3dTa2gxUURnNGlOUXhqMHBqUnhxeHMwUXI2ZXRicitI?=
 =?utf-8?B?QmhCUW1IZ1RGSDNZeTd2aVlZOWNOSHdrQ056RmEraURRb2E0ZDVWYkZYb0pM?=
 =?utf-8?B?YytEYkE1UVdQTHVHZTkrYUtIek9aOE51M244bjR0VzVvbWFXNWVrVk9nYnNV?=
 =?utf-8?B?U2U3eXA5dGU1cFFpNTRRZHcxV3hGTW5BM0duRmRXbUFzSnhSMW9hbDVEZFc5?=
 =?utf-8?B?amNGZHJtVWRMWWpVc0F3dmp4UkdzSTc0QXNuSHNaUGkwRGdTeldnOHB3THdV?=
 =?utf-8?B?VnUxT0FjWmxOY0VLc1dRT2QzNlo1b2VBcU1jTnBGQjZraGVlUGUxWUJKMlI0?=
 =?utf-8?B?bXBZWXFzQ2FHY1lmV1RHY0dKVTZXQjUwZDY4cU5SV0M4WlRPOHBtcjR0clFD?=
 =?utf-8?B?bVRiUWpmWEIxSk1EQjZ1TmFtNVNHZ2VGa013dTZBNEg3NjJnZ21jZDFxbWlw?=
 =?utf-8?B?dmMwSU5NNVRqL1NId001ZitGdWRYZitQdDJXeWY0RXpPbW5CK1RkVW5BVnI3?=
 =?utf-8?B?U29XNUMwdWd0c1NpY3ZRYlpjc1V3dWlLNFhxMTFXZEVncktOeG5Mam9FRVpa?=
 =?utf-8?B?ZVVoWXo4bXU4RGkrWkFha01GR1V3NW5qTmhhSWZyeVh6bGQ4ak5RRlBaRi9q?=
 =?utf-8?B?TThXaHZkbWpQSTU3YTZSVWcvVmpweVdINlNSc25pL1dDYm9wSzdZb0ZnVVUy?=
 =?utf-8?B?TTVXYVpjVEZWMzZyMkJhL09EeHdSK0RuTGlEUWl4Z0tJSEROSkMrSkxqMzJT?=
 =?utf-8?B?cGNUZmhZQ29HdDdpWnB2ZEwxYWsxY3JxZjhWUDFvblVHY0llR0NYVjBSMWM3?=
 =?utf-8?B?TmRndUNtUHprMnhQNGIrWEpKZXRPVDVaVitpNFdiL0VBRlUvL2VSNlU3SDdS?=
 =?utf-8?B?REpqRGJLMTN6dzNuNFZhT1lWZjFyYXRNY2Y0K0xaOFpqQ3ROYk9ha3loMm1k?=
 =?utf-8?B?Y1o0RTV3dlVLSnM0VTRvdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2ROL0pkTTA4YTFhK1RVUEY1bU9QUE5GS0RWQ3puTmJBT21aTWJ1SVpZcGpD?=
 =?utf-8?B?aGRwSS9USnBxeStSb3JDSG9CV0YrcUJBaDZqQ2s4V3FDTlcwV1hTWC9TRXZL?=
 =?utf-8?B?LzBjU0owVWM5K3lkZW4yY1hzVjNQNm82aS8yQXZ3dER6MEtINktYQkhid3Rv?=
 =?utf-8?B?ZDBGMHlXTU1GeFpxaERQRTB5dE16QVR3UDhFaVRqaVVYRTdDM1VCRUJsa2lX?=
 =?utf-8?B?OGt6R1hZRDByNEZQNXpESTdkbVhZeHBVRDhROEZSTEszZE5LMmxCUzh2QTlm?=
 =?utf-8?B?cGRXS25tVkZCVjliMkJyUnJ2dC82YWhoNDVwcmZ3NFJqTjJBYnNWRUN4a0hK?=
 =?utf-8?B?N3d6L2ExQjdKbnd3bGxod0lzS0R5UENIYzhjcEw5MEcrVm9tOWZOSldld1Zn?=
 =?utf-8?B?RDRLdS95K2VjSlg1N0Y2KytMODRNL1pTZmhMUjhzcGhsaTI2c2xiT1ZmcEFJ?=
 =?utf-8?B?eDE2QXhVWEpTLzZGSWZmRHh2TzNRSjRHM3NiUS84YlNyMXVtcXptS3NGc2F6?=
 =?utf-8?B?cE54R2FxdWdQbnB4eEpmYWt2YXJ3MW55eExRVFk4WlErRERybXdzTDZzMko3?=
 =?utf-8?B?MHRmTDdOTzhiT2VWSlA0THNES2ZVbHlITkh1SWhZNXlnM2JacVcwUy9la2lp?=
 =?utf-8?B?ZHdlcllVd3FldXcyYkZGakRpVzgxZ2dTQUN0djlhVlZzdUZNajRuM2o4R0dz?=
 =?utf-8?B?TkY1dnV2STVCam1ZVUtCS0Zya0Y3UU56QlVBanphZHRoWHBwbkF6cmNOdXhQ?=
 =?utf-8?B?bnc4cm1kMi8zeTdoazF5c2V6SGQwemVyeWJ3UFNpTXdMbTI4OEt4SUhTMkxQ?=
 =?utf-8?B?YWxXcUdUanpIOGptc1pZSVdtU2piMS9xSkt4dU9hRjBKZVVLS1grLzlWemIz?=
 =?utf-8?B?ZnhXZk5MeUVEZWxPK3lTb3JlKzBNYjl6LzlIQ3dRWjlZTVlLNzVFSWxNSjZU?=
 =?utf-8?B?VVdDRmUvc0Z0T3B6L1JjNTZGcmdaU1JlS2lGTFc2ejQwVDRYaFdpUS9zYjFC?=
 =?utf-8?B?cUNSNTY4TEFzM3owaTV3RnMvMDlibUU4SUFndjJaelNBemZMN0RBNUFWVEw2?=
 =?utf-8?B?T282UHA5bDVSY0pLT2JHeE5XaWNIeXh1K1pBdWY3c3R4Z0JEWEFxY1h1MjZX?=
 =?utf-8?B?bEk4MWJ1YjVzVHlUc0lzcmQwaWJHNjdrUHZSSUJ3WlI0MDVsSWhqRnlKY285?=
 =?utf-8?B?bXdWZU5ZTEQzT2xmZ2NYdHpKa29Wb0Z6ZlExWm1MSDRVTmpiRXhIMWhqWXph?=
 =?utf-8?B?RU1qWXc5UDhzMjV5U3k2VmFPYi9sNnhRWHNPTjJTZU9sS1h6Z0U4OEp3WWVn?=
 =?utf-8?B?QnNsdmgvRmhyMkd2MXh4R21Hdzg2c3RJR2IvMTFFdUQvU0htWGRRZm83WEEy?=
 =?utf-8?B?c3BQNS8rSllVUVZacU5iVS81N1Z2SmdUYklHR3BOcWd3RVJ2NEoxemczc0N5?=
 =?utf-8?B?bXlCVmdhTW1GcGdTcGNPSlBnS1BuVDBuOENLdGZDcmNrc2Fib0pQWmt2eHBr?=
 =?utf-8?B?TE1YOFhaQnF6TmZ4Y1hOZkhyUCtZNTJPa3RmOTdWWEtoaXVnQlBkQjNHMnAw?=
 =?utf-8?B?amoyYzFTL2JGbDBjMDhLUHREaXpUQTdpUTNQRnRadm0vNDhhRElLTWcwVWxi?=
 =?utf-8?B?dXYxd3BtU2YwWFQyY1BFK2xJcTYxQ2ExeVhNTFhZSmEyRyszOFZIOGh2R2Ex?=
 =?utf-8?B?UTFVU3hZKytVUFlOM1NoS21zTnN4M0I2ZFNzc3BWRGVSbHBXbU12L2ZSZ3pG?=
 =?utf-8?B?Q29mZ3dHYWpmTW5RYkxFWlZTb0FYK3BMRnZBK1E1UEhuaFU0TDV5aTEzVm5D?=
 =?utf-8?B?L0tHZXJhQWZaeGljMjN2NEk5UmtvVkJhM1dmK2tEQWR6KzVlM09uOFNZQmJm?=
 =?utf-8?B?VnJjS2h6M3BRL1UzSy92UkQxWkpkWEszOExFL3ExRzBRbVVDRE5nUE9CNVMz?=
 =?utf-8?B?Y1dOK0NqZFozYW42VXJtMklSWE1mbGkrMnd3dTJ6Smhkckpxb1h2cTg1VXo4?=
 =?utf-8?B?NEZFWm01NlZtYm1ud1MzNmJOdG8xSzdtL3c1R3hPTmJUTHdyOW1sRTcwdGNL?=
 =?utf-8?B?QzV2N3MvZUFQdENUT1NUOGFkT3RZSXJvTVBEZ0U5Sjc5a1d1UVV0Z2ZaZTZJ?=
 =?utf-8?B?QjZyODRoQWZRS2MvbWRzckJhT0E5Y2RTT0hiU3Y2R0w0eDU0TkpUNWRhSDI3?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A13C8DD0F8CEFB429E94C7457E2FEF41@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f503bb6-07bf-46be-aaca-08dc7f5ff2e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 21:48:45.2903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAnu4INqDNag1VCJ6QK8PqzkqFiLZVaUDxWI4VEhNDYAYr87rommxETvIgnWrd8381MlgoOsl3NSra4Qj1DyVLPXKHis1QbBsSxz8cS7nZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8136
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTI0IGF0IDAxOjIwIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiANCj4gPiBJIGRvbid0IHNlZSB3aHkgdGhlc2UgKHphcF9wcml2YXRlX3NwdGUgYW5kIHJl
bW92ZV9wcml2YXRlX3NwdGUpIGNhbid0IGJlIGENCj4gPiBzaW5nbGUgb3AuIFdhcyBpdCB0byBw
cmVwYXJlIGZvciBodWdlIHBhZ2VzIHN1cHBvcnQgb3Igc29tZXRoaW5nPyBJbiB0aGUNCj4gPiBi
YXNlDQo+ID4gc2VyaWVzIHRoZXkgYXJlIGJvdGggb25seSBjYWxsZWQgb25jZS4NCj4gDQo+IFRo
YXQgaXMgZm9yIGxhcmdlIHBhZ2Ugc3VwcG9ydC4gVGhlIHN0ZXAgdG8gbWVyZ2Ugb3Igc3BsaXQg
bGFyZ2UgcGFnZSBpcw0KPiAxLiB6YXBfcHJpdmF0ZV9zcHRlKCkNCj4gMi4gdGxiIHNob290IGRv
d24NCj4gMy4gbWVyZ2Uvc3BsaXRfcHJpdmF0ZV9zcHRlKCkNCg0KSSB0aGluayB3ZSBjYW4gc2lt
cGxpZnkgaXQgZm9yIG5vdy4gT3RoZXJ3aXNlIHdlIGNhbid0IGp1c3RpZnkgaXQgd2l0aG91dA0K
Z2V0dGluZyBpbnRvIHRoZSBodWdlIHBhZ2Ugc3VwcG9ydC4NCg0KTG9va2luZyBhdCBob3cgdG8g
Y3JlYXRlIHNvbWUgbW9yZSBleHBsYWluYWJsZSBjb2RlIGhlcmUsIEknbSBhbHNvIHdvbmRlcmlu
Zw0KYWJvdXQgdGhlIHRkeF90cmFjaygpIGNhbGwgaW4gdGR4X3NlcHRfcmVtb3ZlX3ByaXZhdGVf
c3B0ZSgpLiBJIGRpZG4ndCByZWFsaXplDQppdCB3aWxsIHNlbmQgSVBJcyB0byBlYWNoIHZjcHUg
Zm9yICplYWNoKiBwYWdlIGdldHRpbmcgemFwcGVkLiBBbm90aGVyIG9uZSBpbg0KdGhlICJ0byBv
cHRpbWl6ZSBsYXRlciIgYnVja2V0IEkgZ3Vlc3MuIEFuZCBJIGd1ZXNzIGl0IHdvbid0IGhhcHBl
biB2ZXJ5IG9mdGVuLg0K

