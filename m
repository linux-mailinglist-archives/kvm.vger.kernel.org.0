Return-Path: <kvm+bounces-17494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A288C6FA8
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FC62283D50
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BA1443D;
	Thu, 16 May 2024 00:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7ACzrux"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485E1C14;
	Thu, 16 May 2024 00:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715820750; cv=fail; b=niKT0QddDk3aBSuNr+PrvTDH7UMU91q/AVtsqHp6i5L2jkIJFPy0A1FOlONQtjNc72HjaVSzIlPmNF5nZozhzIYSo/VNTMH6+ho1WRyIKR1LiZHa3oga86+QUr0ukGUstSBxmAx8DRQ2Jq1q/RWiCdaYdnNvSG7eFAOodBVG9ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715820750; c=relaxed/simple;
	bh=KnW3+N9Dw+fQtNRDTY4HA7ZoOPWG4j7B+enw+rgoWH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uqQuiokmIkMfK9+cHYmHNa834NyZv/3GEcwKsa32iXxzAv/Z92NjbpqfO49CbVCOGDfgcaI7sUj7mt4KnJY+6i7qZURrwK1DHF5OziHdPyU/rTAJBuh+7PngMAqmC+IW1+/L4smoZBBf1VMvtGvmmXU+HCdRC3MkD8NuYJ8IFFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7ACzrux; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715820749; x=1747356749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KnW3+N9Dw+fQtNRDTY4HA7ZoOPWG4j7B+enw+rgoWH8=;
  b=m7ACzruxFrqJfHnXiyDQjb2OZP5FEhzjYvTCFi4yFyAvNhgKfPz6/yTy
   dyvU19lug8xQL/tHguEFb0UJNX6QhmoxEhXdXIhksE0azFyNVOp6xZkAJ
   5XZheUQOUwMuHKSAj19cAcJ7F8vDegTn1jatiATVNDJpfzrYi/tmJ2MBE
   HRfm3qgCt81TKo6An2i0F0Xvq/CGozM2Oqr2zHZg1sLyjpBANqhBKG06Q
   GvRv5fAJ/1hysA7Co1LVcFC1xJp58YvxCo8tz6mpLZkyoUzXd0K274qHe
   rtvJJ2YnizeoYkJ1cFUUYKPaFPv30TomUQS0ViyLvdhWrUFDh/n3YD5gZ
   Q==;
X-CSE-ConnectionGUID: w5noFTBRQNm05I+gQfBWPw==
X-CSE-MsgGUID: uzDdCLwiQCO29f32NbZCuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11546725"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11546725"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:52:28 -0700
X-CSE-ConnectionGUID: tWfwAyN4TrOmkBVpqAHHSw==
X-CSE-MsgGUID: pobqt7mITBCjGSM6P9jjew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35804180"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:52:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:52:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:52:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 17:52:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:52:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inxplK8Szqv/K3xDJdi3XGAc8WncxSFFXRMSe9K/0RWsyenM6FY4eYTkXRRNQgm3UarLHYgjm5vq+TonefzVVU1c2lDLtV95kbJyLvGJ3yOpcf7KzwSixFKc5lr3O0dDpOq3xCDM79JzZhcoqLIDMsZynrUW16t3wafDh1A+i1+Eeoa9wlPsVSMx37OscrTmRUmYW4wm3+OUE6I42hGXkijvJKRiXvCfCqdBuJkMirloptPXC+7HryYoPgNYUbxQzMctGnKSIShkhcfs30UNJJWWOQFSTUdsW07/KEcY6XytR/9Xu0YZZoFYw4zLS97L/YKym9T7o3KmiXNK+PGExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnW3+N9Dw+fQtNRDTY4HA7ZoOPWG4j7B+enw+rgoWH8=;
 b=XVlqXir0LS2Ncj0N3pcaSFPbDtifJlCxqrvcbTD71MkZ/wAvVdmyY6HbVGLhFI16j21uhfAeRrzN18cuBb8JLc8L9s9drk7PAp/h/5G7HWhnqW19iPeEc4PfSHALdoW/u/4EZ7kwfQJozSKe3ztfJCfEIS77jCBnEcKBaLxkqTZvNhiOxKHb7uviHcWqVOdSGlse7Wn8jOwj6joc6HIT/YjqT8z55pi7MuFHXBrkz/lxNzUnhUUUdAKVMq7L1qDXUECzTvlEbNfldyfYywE880pOkTbT+EinMzWl/pEb52fEVvSr1BuuhYv+lpQYVorRqurZXGjDHwtoEIWSMU1X/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8693.namprd11.prod.outlook.com (2603:10b6:408:215::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 00:52:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 00:52:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAANbQCAAGM8AIAAIOAAgAAKSAA=
Date: Thu, 16 May 2024 00:52:18 +0000
Message-ID: <d54c7051ef6704db409095349c94b318f3ed65eb.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <20240515162240.GC168153@ls.amr.corp.intel.com>
	 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
	 <20240516001530.GG168153@ls.amr.corp.intel.com>
In-Reply-To: <20240516001530.GG168153@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8693:EE_
x-ms-office365-filtering-correlation-id: c049a5d9-f998-4132-cf22-08dc7542701a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RGNZdVhxUy9yNUYzbXppRkdQRXhrbEp2K3JTQTA1ZjZuYTZaT3VSQzROUzhO?=
 =?utf-8?B?YXc2VHU5STRVeGtMMnNuMGRXa2ZvM3Zxd3RsUFFKYUtiUVBjWWtQWXFzT2tp?=
 =?utf-8?B?VHh1am5abzhIaWpEQnFHcVNlTUFKVWRDcVVCbkErTnQyY1cwOG50Wi9iN2Fy?=
 =?utf-8?B?Z2hsdWdXMXA1bmdzUWtQYWd3R3dtUkxYRm1uaThHeVVIV0ZZZnNGLzNZTEVl?=
 =?utf-8?B?emZ4NVhlWmVFTG93U0pHZjBZODFLU2JOR0RrdjhiQkNndHdudUFONGhCYVV6?=
 =?utf-8?B?aDFjOUYvSDJDY2prdmJZdnp4cWtmTE9TMm9RMXBRbUpYYjI5ZXNKM05aOW1K?=
 =?utf-8?B?a01Od2tWRk9qUnBIN2tjQ1gwek9hb21pU2ZySWJGYkVPdmd1aUVFQjMwSVZT?=
 =?utf-8?B?aEt5MnZTYVpzajJSdnJLNlhLK0xEYi9jb2FYaWhobURTeEJuVjVncytJNlZK?=
 =?utf-8?B?dG14VFFqUEV5VGV4YkpLcDJSV21Ibld6NVpSTGVBWkY4akVvOTFxTG5RUDZ1?=
 =?utf-8?B?aHJJcjcwNnVDeXVnbmoySmUwNGtGZkdCSWF2OWEzQnBwcG1HZWEvU3hkVFNz?=
 =?utf-8?B?TUNOQzA3Z0pPYUhMS1N1OVlzdTBya1QyclVHbXpod25Yb2xxNytVZUYrWUlw?=
 =?utf-8?B?Q0djZ01KVVFrZHRRaGRLRHErUUU0MFB0NDhrYmtXQUNrSXd4ckY4dStaZjNG?=
 =?utf-8?B?dXE0U3NMMm9tK3l2UGRjSllveTZuRGtnbytsdFprZTBtMU9Za3ZiTGhtZnEz?=
 =?utf-8?B?VWNCTXVXTGJudll1ZStlbmlYOUZIcmlkcENuRC9jL3VBWklHaG1vd0U0WU53?=
 =?utf-8?B?VjNkbk85Vkh2bUphOWpWTm9oMGNFd3A5czR4aXBYUnN5YWF3VHVMaU9EWnk0?=
 =?utf-8?B?WExKdnVMdzNrZ1N3aGMxZEZBTFdvVGpFY1c5eWZMU1ZpcFZrNllrQXV1TU00?=
 =?utf-8?B?THBheHMxNGViYVlZQm1LeGYraTREcVcrOTZ6eWErNUhKT2VyYXRsTCtPa0dh?=
 =?utf-8?B?WjAzaURjUHFWSHVNdU5sWU1qMEI3T0hSZmNDTmwvMitJRWVXb1lYaFE5QWZO?=
 =?utf-8?B?MXRSTTFaU3FERVQzeFJkT09vYnlKcHNGWVFLaHQ2d0ZWL2JKOFFhYlpHODBs?=
 =?utf-8?B?QWFXTW1QZ1BEeXl6Q2pvZVZLcHNLZG9aYllCYyt2VDVaMTc4SWxkekdaQ1ZN?=
 =?utf-8?B?citMZndqMkF3eW1MeDdNRDJFZTBnR0xtdjNVYW4vWHRBYjZDN21qUU5DdExt?=
 =?utf-8?B?SDdCOFcwWm1LQkpvMVVkVDNKYnV0TmxObjB0a1o3VUtIbWY2Y2xrY2RzeUZK?=
 =?utf-8?B?dWFUN2pNZURaQkdYNGlMRjEwTlFzUG9yOFFJSjgzMFJtaE5GeWlodjJoc2NU?=
 =?utf-8?B?em9ybFU5djlUMkZZNzFYcGNMTndjZ2p6Q2xtK2JMRng3enVOM2lqckZERUtS?=
 =?utf-8?B?ejk2dG9ER1RhejF3ZWJEdXNEaDZSOHJseWM2SHM4V25pV0pvdjhyc3JIa0ln?=
 =?utf-8?B?WmppWjB5cnZobzFmSnFrbnFxZE5OaHI5ZTJjaVowbDVESGZsZVo3cW9RRUt2?=
 =?utf-8?B?TklZQVFIaU9tRCs5RUZ0eXpnUjBwaUp2YWVjVnA5bTZsalN3czR1YXk1OEpH?=
 =?utf-8?B?UnlOS2E0Rm9lNFJyQ2NQQ204NkRidEoxVWJHcldsWUF1NTJRZ21INmRHK0x4?=
 =?utf-8?B?TEdxU0NsSHFrV0h4QTFPTGNteHMzZXVDYkNxMTVDK1A1RTEzMVBkSDUrMXd5?=
 =?utf-8?B?MEVBUGRXR1lKOHRSOGZuUE5vcDJlZHU1ZVEyT05jSVhMbSt4b1R2UmxmRWRw?=
 =?utf-8?B?cHJRSUkwdUhEMG1OSWRiZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXBDQW0zWnBITmpXTTZIVnMzU2dCMjZSTVU2U2NoUHc2aWFOMEFhcVdqRlNm?=
 =?utf-8?B?Nlp3Ym1XajVOelRWL3BGeHFvdEExcUp5RXVHdmIwL1NlR3BzTnJkNm50U05X?=
 =?utf-8?B?QUI3TitwTkJaMVd1K1ZGaDZHS212TWFVTVNlMm9lWEJVcHVRRjlDRGJhRnZx?=
 =?utf-8?B?aE8waUdnME9uOHhHR3k4MmFTeEErNjNQZzhXY2QxbkMySmsrTGloWlJkK2tW?=
 =?utf-8?B?aE5kNUJOMDNtc0pWYXpUcm5qZGRETU5idUJKWGtCS2VUL1g0dk5GVmhyMklI?=
 =?utf-8?B?aDMycm5XSXhXc3dGQVFtNFJhdExhcno3OExVNkx5R25pWnkwS3ZMWkQzWmJG?=
 =?utf-8?B?SDY3RzRKSzRibUFha2p4T0J2c3FhTWNSZ0xLZzNXaGd5U1M3Z25ic0VqUm9t?=
 =?utf-8?B?czFNZElIc1ordUZObjNGRXMvTDlGMHF6d3VIMUc5MEdrdTVubVRoeXlhd3JF?=
 =?utf-8?B?R2huUXBZQXlUM0kvaTlMb1l4NTcyRGVma2h4Nk05Z0tsK0l0WDN1dDl5ckow?=
 =?utf-8?B?MDF4bXhrM3JHVEtiV0xMVkJGY0RSejRFWHhVaUhjR2ZYWDJOaFp1SFI1Ymc0?=
 =?utf-8?B?RnlBdVVxMUFWSFg5QTBIcGNyaDVDbktMQ1lHMTMxV3FISmxacGcyenFvd0Vk?=
 =?utf-8?B?eHpPZ0MvRTlISTJaQm5ydFY0N1ZVazhveWs1S0tETjVJR1gxQ2RGUnJwSHdY?=
 =?utf-8?B?TTZneXRCUzZac2pVeWRDOEEyK2dvSXlDQUp4OFFMaVlSZ2RHZ24yekxMRjZq?=
 =?utf-8?B?UW0vTG00T21ZYUUzRFRCRHVTZFIyM0Z4Syt2MUpETmNQNFpsR2dvMi9zLzNS?=
 =?utf-8?B?ZzhueXpLTk5qQmc4cml6WVBUSUpwYVNXWTBUcTZzcUZKV1JPazg4bGN6NGFL?=
 =?utf-8?B?UVlxeHFqUk9MTlBMNlZSdTdieVFJVEtPNUlhRlBVNWc2MysrTmtqQ0Q2WGs3?=
 =?utf-8?B?S0ZyYzI2djNHWStra0Rucmo1cThacmhVcWc1THI3enhEdC9UOWZNems3QjFN?=
 =?utf-8?B?dFhUOS9na1V2SER6cUFubFVNUE1oYmcxUncrdHFrUWhMNTJXNHJFdGNYWXlL?=
 =?utf-8?B?WkE1SHBTSk53RDdzR2pPN3BjL0NvZ0xUQ080cXE1a1E4cTdpUmxqcVB3QjY1?=
 =?utf-8?B?YnVpeFRHZ2U3UzYrdnhTZkxOeXFQQk0zVXZtZnhCUGRQYkNwWmh5eGVjcDY4?=
 =?utf-8?B?Q0lBR1hqM2V0MWtDVVRUMW5GV2hKRDVKbzVYVUcrQ1dDeERhL2JGVVRzVFJh?=
 =?utf-8?B?bEgrK3R6bzlqZmcxK0RpTmZqMXFLTU01YkZXVnJOTG9HWENDQmNMT3F4Q0tL?=
 =?utf-8?B?Q2prMXh2TzVrS0lUb1pQd1BvTGRUQjJxS2RPZC81eVJOTkdXWi9PUmowRWxN?=
 =?utf-8?B?SXEzdXBRTlFDR1NUbUhRMU9NckZ4UWxGQmhERXFGTEtZYXRxTDVjUkZUN0J6?=
 =?utf-8?B?ZWhzY1I1TzhmK3o0eWFkb0QrSjNiSUlRQmkwSUw1QW1GMTlrTjZsVjlhWHpF?=
 =?utf-8?B?YjBHZ0lpVm9KSzNYK29rajVOYTdxekxqZWx1WlFmMlhWTCt2Y1FnekU2WGJX?=
 =?utf-8?B?Qkd2SHNBem45cUptTnE5OGt2YWdJa0JTYXdyWjAwVnQweHBIcmkvVXdNMys5?=
 =?utf-8?B?U3JxMGNDM254Z0hOZzAvSmVEVzhHaUgvWk5Ld1J3UVFhNUUxbU05Yng0QWZm?=
 =?utf-8?B?NDgwR0hzNzVQOHNPNm9LL1R1aFZyWU1yMnNmSkhiVUJmNDFyTzFmZnlreGU3?=
 =?utf-8?B?SVRzWFh3WXFNb3N6TkxXWTNGMkNpNjMxa0RzTVJxNTJFWFZUL3lDMFlZMk96?=
 =?utf-8?B?QlFIcGxCT0I5RW42WHdlMlFoR3JOcFRVRWxDQWw4WWNqbnFFZEFNUmd5b09p?=
 =?utf-8?B?aVlHQnhsbGNSTk53YVNVQnA3TGRoWW1vdU41Umo0MEpzTXBjNUNKanN0Y0Ir?=
 =?utf-8?B?OXg0V1Z4VndjVlUrTllZb1hHSDB0MHpSZGI4TGN5eW9TdnRlR0dLczNjN1Bt?=
 =?utf-8?B?L1Z0Sys0bFNIdE1UeGhoWldnaS9CS0FxV2djK2E3T0ZMcVIwZzl5aEh2bVBG?=
 =?utf-8?B?ZUc4MDRFU3JiRjZEdG53WGJ1ejZQUDRaa0l5aXhDSHRPQmhSMm1JRGZoYWs4?=
 =?utf-8?B?TGJKeTkzMTMrY2xVcS8xN3dQTHpSWW9oTk5TMkFlNktSUEZFbyszeWIzZUM3?=
 =?utf-8?Q?Q7RSpP+SRLGI6oPTXzUaJTg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C9B9C3615F41649821DCB3777A56AA3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c049a5d9-f998-4132-cf22-08dc7542701a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 00:52:18.8767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPoGHrpyZWGg/BCX3WOtoYoIP/XRY6jEUnTugUPLGScBc9ZRZg8DHVfO2FwdSKciwhb3bEetXBEpCLlwXHWsM6HJDmsZSvamv45pnDZARXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8693
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDE3OjE1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gDQo+IGt2bV9tbXVfcGFnZV9yb2xlLmlzX3ByaXZhdGUgaXMgbm90IGdvb2QgbmFtZSBub3cu
IFByb2JhYmx5IGlzX21pcnJvcmVkX3B0IG9yDQo+IG5lZWRfY2FsbGJhY2sgb3Igd2hhdGV2ZXIg
bWFrZXMgc2Vuc2UuDQoNCk5hbWUgc2VlbXMgZ29vZCB0byBtZS4gSXQncyBhIGJldHRlciByZWFz
b24gdG8gaGF2ZSBhIHJvbGUgYml0LCBhcyB0aGVyZSBjb3VsZA0KYmUgYSBzaGFyZWRfYml0IHdp
dGhvdXQgbWlycm9yaW5nLg0KDQoNCg==

