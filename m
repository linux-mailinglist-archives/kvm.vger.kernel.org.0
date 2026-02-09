Return-Path: <kvm+bounces-70645-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFGWBCZMimk6JQAAu9opvQ
	(envelope-from <kvm+bounces-70645-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:05:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79295114B0C
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F0A6302171C
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 21:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E0530C619;
	Mon,  9 Feb 2026 21:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8K85BmY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1C309DDD;
	Mon,  9 Feb 2026 21:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770671129; cv=fail; b=eZ5Gf6TvnCVPsdj/4yzBzQyxQPJpKLTD13uCDvkKMEj88lS4LHhmB7gI1T0TlaauLL6asxYcUXJ+1fZXZVt6+V4p5+MwaKNUgsPI1VTVzvQvCrm+qgxLRc0pgb6FZWa58rN5VvXa11C/FFiGh1aNAMfjkvXUFp4RYrBk1ii81Bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770671129; c=relaxed/simple;
	bh=WTskWNubfYjTj8Pc0ueO4IJSksDZdDolLqGWtQoypEQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kbMRyta9JLJSfGCm8gWgAYsAiQbAnA+HZpLFRLxMWT3AvtHdZJWeJiC05WADmPXA7uBYO0tP6SKcVLyEiyXycyZlcOGjVNWrJCMEdC0orMeG7o0uXfR0PpE69K7G3WiCLSBF8PeJ/u5FDU8VK3MCG7rebejzAMXZstZhL8X27Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8K85BmY; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770671129; x=1802207129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WTskWNubfYjTj8Pc0ueO4IJSksDZdDolLqGWtQoypEQ=;
  b=h8K85BmY/wPNiDGp6xJ2OhQ3ZOWSVJfWJpCdNTBtL6vIrYTKot4mlA8k
   OLGft46VlxdaGkT5okT124uMSOj/PO0hMzoWyJCHWwuONsGcz6m8y0o9f
   bwK+AEfWADJjIwakiX7q2m6jHc5An69bQYRnPfuTMKpOci9qxNgvsjxid
   jXeUEHl87jlmJSBDvtqvGWf76mGixk4wZx2fK0Pfm5ogDuUrq86P58kj+
   DUqMnCte4tR1xGiP5F2eg7OsWykeATrxwUlznakpaeT6c++qjfI+ZZjVV
   y5ADSKUXdUkYFnsIXI76CO3ZQWcfcODRSO6sukhl6LXb9Fx0D8FK8R8ZL
   g==;
X-CSE-ConnectionGUID: D71MluVUTHe3YJANa2/hAw==
X-CSE-MsgGUID: Nbemlj+7RyCUP7ZCbdz3Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="59357853"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="59357853"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 13:05:28 -0800
X-CSE-ConnectionGUID: EhpUzQRWSr+kf/r40Z5/vQ==
X-CSE-MsgGUID: dH8ME7nzT0SGOpFPp8uPYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="211007440"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 13:05:27 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 13:05:27 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 13:05:27 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 13:05:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oAOGMC4r7f+UOW303GcRlcaWTi4KXPcbp+vpK0Vm5EOAGyEk8tdGoqP+SXupYjdp49cZYH/pjwnJNvlgUY0kq8cCsc8OFtShX2BVGouN3apnbpeWv7pGOTVqeit/1qNin2te4YvT9qiSbImzZvIpOQGdQnTldVvuEm/gt1QhQbHCit3KfYWJAXosadkQwAkwaMljv70711ztyyDCK16MONIAuPtAPRHlAtkF0T05h4C3g4GLinpsY3SF3nnuxLOgNih0hD+2zNVEXq+3gtkPq6hAl7eGY3Y9fDsNi6ym0I9sshlYIC+sStTKQnUB8Xq/BX46GmdQR1BTTLo3Cl5JkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTskWNubfYjTj8Pc0ueO4IJSksDZdDolLqGWtQoypEQ=;
 b=KqXBXbtlPVcPwzGrhO0ukS/sX7b1eVgVKJosmiWBOqCjqilNdNbSNZeYc9lXtkpf35+GVTuv9QpabJoFG5EuLGpdkrNJVgR9pIwFDMOg3zcDLO24KqlfL4i3z6mZxvy2jCEY+b/JO2OvJ5l8/h6epcEt6NKkyy/8kxv3MjDyMPL03KGELIU+UbSaaxEXa9mgZNR2hFTASgBaL7ZtR9Oxeb5alQvvexO2stjOFWnZHWKx0NnI2weiJlv5Hc0cDAXcdpmrXqDSde/vbG7Yt4nPBnmGFhOFNe08Ga+xalCPCx5Kb7qomyBkDVFYd9TP8ED/AW8Ul0+lZ/eaGUfkA90Vdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Mon, 9 Feb
 2026 21:05:17 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 21:05:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Topic: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Index: AQHckLzwePp2LsFGnk6KJpD9rHxlFbV1gv0AgABf7oCAADjnAIAAQGCAgAPhSYCAAG6MgIAAQhAA
Date: Mon, 9 Feb 2026 21:05:17 +0000
Message-ID: <fe33a79d0395753607ad90c2d43ee13127790cc1.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
		 <20260129011517.3545883-23-seanjc@google.com>
		 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com>
		 <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
		 <aYZ2qft-akOYwkOk@google.com>
		 <94f041b3aa32169fa2e1125edab7bd8fed3a6e59.camel@intel.com>
	 <ddf6c17664044bf66e7a9a0a58f2b6c1104dfbc4.camel@intel.com>
In-Reply-To: <ddf6c17664044bf66e7a9a0a58f2b6c1104dfbc4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|MW3PR11MB4714:EE_
x-ms-office365-filtering-correlation-id: d114f893-6dae-4a9d-06b4-08de681eed2e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aWRvdzg0aTNUVW53Q1lZWDk0QllZQTdmYVFmVzRUWXBTVGNNZHlsb1lkc2Vt?=
 =?utf-8?B?Y0ptK3ZvM0ZPMWx5RmxnT3pQMEpTNHkxZzV4Z3E0ZHRvYkZCYTYzTlltMVA2?=
 =?utf-8?B?K3puUTRScHllS2NzSXVBUVZTeG54TWJuZ1dtZlJkbU1wQ3BLblNFSnQzOU5G?=
 =?utf-8?B?Q1g5TzV2cGpPUjA3VGNYZ3dSTmFjZVFseERJWmJLR2xzYjRoTTZEVGh0VWxQ?=
 =?utf-8?B?b3lzWjVSZDRJcmtuUkc2WmgvVUM1bGpxSlhRYXFRSGRTeVhMbEJXRmRITGVG?=
 =?utf-8?B?MlZsTVEycUxvSDNZYjRsZkNrUU9RQ0JpMUlJM0ErajFXWUt2emROb005Z3JX?=
 =?utf-8?B?UzJzc3BJb0trSzdPU25WdWppcEN4bFV5OVE0bGxCVzFRUis5WmU3c1Y5U0xx?=
 =?utf-8?B?QTcvR2l3U2lIbGt6QWcyMEJsV3FwQ0JXWUJUbElqYkh0Q0tmYWFCVXhyVFh4?=
 =?utf-8?B?NEFpVWhMUnQ2anRwTW9ERFQ4T3M3Y3MzRlZieTJYYllaQ05XUFZzN2tBbnkr?=
 =?utf-8?B?OFZoN21tS2JWNy8rN1FTN2RBQWs3dS9GY3I5eGE1bkZFY2hvV3dyT3VyNDBB?=
 =?utf-8?B?c2lhem45amJPL3N5UzNVanhCa29LV0R6M3RpNmJWU21TNEVJcHNIYTFmYTYx?=
 =?utf-8?B?Z3Y5WVc0Um1qSkpwUFVPMTUyUWZvZW5HRXpmV2toSDFkc1lYTWFOQ1BzVU5i?=
 =?utf-8?B?cmlFd25vdHBQbWZoMlJYVkthN2xQSlJpc1J3cUFlN0h1ZmpYY2FWdW5qTjlC?=
 =?utf-8?B?bkZSOTZ4NU5UeEtBemUrMHc0czg4MGV6Z1h5eFR1NTBLbTFldXQ4SVNrWXBE?=
 =?utf-8?B?QU5LYkFLZi8vNjl2OUY1Rk9GdDZrVS9RRUFPWkZKQXIvbS9HMDN2QTVBbEIv?=
 =?utf-8?B?T1FPVmJrRlBReEZZS2wrYnlSSFZmVXQ2bXkzdjJqRitxZlpyWmcycit2cG9p?=
 =?utf-8?B?S2JBVEtwRGRzbzd0bm0xcFBSYWdBSEt1NG1ab0c2U2dQekhEV3NuaVFDdEMw?=
 =?utf-8?B?S2xEUDQ1a2RjY0Q5Q2w1MjNKQmlla3RoMDZ3SENWSGFHcVJRbkdiWWJtckl5?=
 =?utf-8?B?M2Y1QndVWTgwODJVU2NYTWJadnNoaDFPS2FpempaTnBoOGFDL0loRDNCS2hm?=
 =?utf-8?B?dWR2dXo2MVVRTmNpaUsvU2pGR1BxdzdwMlJqeThVemVXSTBBbThVWVdPSzNt?=
 =?utf-8?B?K25VRmpBa2RUUjJiRHdYM2Z2UXMxQnMvZzc4bi91QWVUNXNqbzEwMzd6NlpF?=
 =?utf-8?B?WHNVOG13ekVuaUFZQjNBeVl0Rzcray83SzRMSGZkSEx4L1dxSmlWMTlBalFh?=
 =?utf-8?B?VmlFZFlUK0tzRzRwblg1YllnckRkSEJYS016OTFLOU53dUJ3dVR1QzZZMjZ2?=
 =?utf-8?B?YU1UQWduaUh3d3lYdTZ1UUdVU0RmR3E3SFlmV2gxVzErMDRlZWZ2ZThiK3Fa?=
 =?utf-8?B?S2p3UUNJT0k0VklGSWdua2s1Y0o5RkZXbHIwUmxnRDNmNkpSb04rTklta1lB?=
 =?utf-8?B?OHBMT0o3WEtZSDBaUHMvY2JMUEpzejQxUitEU083WFBFYjJBMHdJSkowSFAy?=
 =?utf-8?B?dFE2S3h0YXFIMWxyMGtYK013MWdIVVVGREhVTkxSL2VZZlV3M2pLSURBQitF?=
 =?utf-8?B?RjFwNDFvb1lNb2plb2xhWFJlNFVBelN2b0RYMzloeXRnOTY4d0RuWTRoSWtE?=
 =?utf-8?B?RXJiSUtLb2xwNXZSMVQ5aCs4Qmczc2lJaTBwMjJQUDA2UHM0YzNIejhqOUx2?=
 =?utf-8?B?aW5zbE9GN1krUGJ1R0MzSVlESHBZaW5qN21hV1dDOVpTM0RTWkVrenlDWmdz?=
 =?utf-8?B?WUhOTERSTmFyK0tUWW5JMmwwR3pMNmhyYTBnbUNOU29FNjFoeU9ERUUvZHZY?=
 =?utf-8?B?c3lJTjJtOVQxdXIzdUVEWDNwR0x2Y1lsMytpLzZTaW5ud1FGbEJSbUpoS0Rv?=
 =?utf-8?B?dDNHZ2czZHBRMVZNNkUyMlUzb2k2cGZXN3J6K0ZVM2doMDBzVmVBejlBRU0r?=
 =?utf-8?Q?eU+hSnD9pXU7xaOWepTgUThMQjVs+A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VW5YZHAwQ1BLNXkvZHExanpISVQ0di9TL3hDN2NSTUIxdEZscERyTEc3TDZO?=
 =?utf-8?B?Vy84K3hBWXQvSWxhRjlUWDMxN0ZndFEwLzlUTks1ZHdIQVNwNFMwUTlsTnBz?=
 =?utf-8?B?aGc1VHlMZUFESVc4YmNCM05COU1RcVJ0MzQ3MG5SK1pzQjlqaUF4UkkxbWZy?=
 =?utf-8?B?Uytma3lrcGtvK2taNHVzc0ZtczZTZ0trMGNDd25pcCs1SDMyRXc5VW5KQWhL?=
 =?utf-8?B?UEpDRDlmSHEyK0FxREJ5blBVUTJJK3lkY3k5ZUR2QzlwbTdiMElPZVlGVmpB?=
 =?utf-8?B?ejdsNzVpMGdQQ29VTHlIOUJlRkRmaE13WVgvdllUa0J4NTJQNjUxZEM0VlNZ?=
 =?utf-8?B?cnNtVW5SbDhiOWNhRm9qUENYV0lFVEtGM254NjFqNGtTNjM5bTFORW5sbTJr?=
 =?utf-8?B?aFhqOFJwZWpoRkl2NzVuVVJZSlRleWI3Znp0ZzFOVDBqQjdtVmc2K2Y0Y3gy?=
 =?utf-8?B?RTZYdDNaL1pSRWhCSUh0M2ROWXpzNDE1ODBZcUt0b0haSnQxUEdWOHNTSWNX?=
 =?utf-8?B?NlE3MEZPM3FHa09rbnRWcHZkdTJrTnU0TDFVZy9XMjlZeFBHSndDNDJxK09S?=
 =?utf-8?B?d2RIVUtsdkZxOHFRVWFGbW9UUlVVSm1lL3NDeDdFL3NQZmZ3Y05nNVh6dlJ2?=
 =?utf-8?B?Y3VVNmw5QncvVzdPVDlQeDB0Ui9rZ3NYdGdJYld0YTZwZTNUZm1jVVp3UXZX?=
 =?utf-8?B?c0NhbW1EeDhFRW1FVmEvclhUcDR3bS9XSTkzQlB1TDRkSnE2aHFtYzhGNWpv?=
 =?utf-8?B?N01qcC95NFlaN1oyZVhzZ05DL01uVWlpdmRwa2tRNWdRU2UxWlNKQWJtVll5?=
 =?utf-8?B?andPa2FyT3dUTVFsS1NNYW1YajFNL2R4ZHJ3Qm5IMFk5TUx6cFFTT2NMVGYw?=
 =?utf-8?B?N3FDUGQrd3F4akpCOEtWeEZPUTZzSmplL2VHNXJJVHJINnoyV2lpSGc4Ullk?=
 =?utf-8?B?azA0T1phWGcxZzIxK1VRZUF1UkRIeXBSQlVJNFZkRGZoK2tjK1U3eXZmQTFC?=
 =?utf-8?B?ZFhKeXVMa0EzVjZXSi9RWG9wR3cxYmd2cDZyR3B5Sk0yVGpWNmV1L3VTR0dG?=
 =?utf-8?B?M0FHaTUvc1V6aFRHMGxYYThQaUwrY0diUWFOMThnK0VDRjlibzllYTZqOUJv?=
 =?utf-8?B?ZiszWCthR2lua3hGUjZmaExDSW9zRFJwNTNkYTZuUkhQKzZIbEFTdnNJZUk2?=
 =?utf-8?B?aC9KZmZRUTd0WmcwK05KMVlNYk5LY2VZa0FlYUFnTWNiQ2t2SjBIaExiYzh4?=
 =?utf-8?B?YlA2aHdvNmpJRG5FTHpvVHc3ODVFZlJHNmN0c0tPRm51SmZweTZRZUpqZmQ2?=
 =?utf-8?B?Q2JDODgyWDVtckZ2UlpuZmlDczBzWFBoSGU1UlpXUzJOd2drV0NvOUlxQTZy?=
 =?utf-8?B?UklFbTBKNVJhc21xbFM2YllNZXNhS2VPUEMrNWZ3L09vaG1KcDlKOXplRTJI?=
 =?utf-8?B?ejI3N3Irdy9KZCtNTkRVNTdWeVk4QjBFNHFSQkdaUmN4TmYzZGhvYXhncnBw?=
 =?utf-8?B?Uy9naXpoQmlDUlJjQ21LYThZbFhnQWFTYWFEUmlwd1VORWc1eG1hK2JCMmVY?=
 =?utf-8?B?M0ZHbFI3Z2lOVWJqSy9TeWJGM0wxajc5ZEpiNU5yQzVMUTVjTHpsb3JGVFZW?=
 =?utf-8?B?VUFCdGQrN0dLaUZ4RWdMT0xnekQxbmU1N1k0akRob04rTURMMUhqUVprWnZP?=
 =?utf-8?B?NHM5L3NLRWdBKy9zTEFKaVcvWkdXUy9WU0FJNG1mTEdxcStDV09LVFFhMk9Q?=
 =?utf-8?B?Zjl4STQrWGVkMGU4RUdTd29rc2Mxd21IV1pDNStDVlcrTk1EajZWWWgwV0pD?=
 =?utf-8?B?ZVhsRlpJeTBSUXpVbU55VTRrVUFhT01tMHh5eDE4VlVyKytzMlFOejdzc2hm?=
 =?utf-8?B?OXRjUUg4bC9yZ3Y2NGlLVGplNTlTN0drTk1Eb0dHTStUTDhDKzNyWDlYN0Rv?=
 =?utf-8?B?Sk5qb0Y0RG5Td1RpYXdwWmptZWFxU0lLeUtzS3lpMWhzTE5hMzVmdTNQZDBo?=
 =?utf-8?B?OHQ2MzBENFliZGtha0M1ait6Q0VQUEhLN2JhNEdhaVZzN0pCcmd4RXMwL1d5?=
 =?utf-8?B?T0w2ajZsZE1XUENpMVRGYk5vN0tQUU9tSFV2VmxiVzV5SUV6QzlWS0FaU25T?=
 =?utf-8?B?a3NySkQyWkVTUEVqVzRjZWl2NkFYcnpmWGZYeEJhdzhmM25zL1ZQUCtHa1JQ?=
 =?utf-8?B?c0I1THZVb1lzMjFRTnZYOHVQRmN0NStYUDRQeG1JT25qbFB4ZWFsdlo5R014?=
 =?utf-8?B?elZHZVp6WkFvQjBFUjBubXM5K25XdERZbzR0b2JqOWwrNVRxdmFIaUxvVkxk?=
 =?utf-8?B?QmNUb3JDa2JhVmtiaU5NTEhrbk9jRi9YWkw1dnB6dUpoZ0VkekxJQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E149AE7A5929BE488A8A850890538A34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d114f893-6dae-4a9d-06b4-08de681eed2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 21:05:17.0527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vb6Nzqz74X1GmJCWinj+Za0B9pgUZ0APNSFczx9dRU790wrRb4mEjr08smHTVa6gLtWGywMw4Ers5UA6j1j/eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-70645-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 79295114B0C
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAyLTA5IGF0IDE3OjA4ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gTW9uLCAyMDI2LTAyLTA5IGF0IDEwOjMzICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IEluIHRoZSBmYXVsdCBwYXRoLCB3ZSBhbHJlYWR5IGtub3cgdGhlIFBGTiBhZnRlcg0K
PiA+IGt2bV9tbXVfZmF1bHRpbl9wZm4oKSwgd2hpY2ggaXMgb3V0c2lkZSBvZiBNTVUgbG9jay4N
Cj4gPiANCj4gPiBXaGF0IHdlIHN0aWxsIGRvbid0IGtub3cgaXMgdGhlIGFjdHVhbCBtYXBwaW5n
IGxldmVsLCB3aGljaCBpcw0KPiA+IGN1cnJlbnRseSBkb25lIGluIGt2bV90ZHBfbW11X21hcCgp
IHZpYSBrdm1fbW11X2h1Z2VwYWdlX2FkanVzdCgpLg0KPiA+IA0KPiA+IEhvd2V2ZXIgSSBkb24n
dCBzZWUgd2h5IHdlIGNhbm5vdCBtb3ZlIGt2bV9tbXVfaHVnZXBhZ2VfYWRqdXN0KCkgb3V0DQo+
ID4gb2YgaXQgdG8sIGUuZy4sIHJpZ2h0IGFmdGVyIGt2bV9tbXVfZmF1bHRpbl9wZm4oKT8NCj4g
PiANCj4gPiBJZiB3ZSBjYW4gZG8gdGhpcywgdGhlbiBBRkFJQ1Qgd2UgY2FuIGp1c3QgZG86DQo+
ID4gDQo+ID4gwqAgciA9IGt2bV94ODZfY2FsbChwcmVwYXJlX3BmbikodmNwdSwgZmF1bHQsIHBm
bik7DQo+IA0KPiBXaGF0IGFib3V0IHRoZSBhZGp1c3RtZW50cyBpbiBkaXNhbGxvd2VkX2h1Z2Vw
YWdlX2FkanVzdCgpPw0KDQpBRkFJQ1QgdGhhdCdzIGZvciBwcmV2ZW50aW5nIHJlcGxhY2luZyBl
eGlzdGluZyBzbWFsbCBsZWFmcyB3aXRoIGEgaHVnZQ0KbWFwcGluZywgd2hpY2ggaXMgbm90IHN1
cHBvcnRlZCBieSBURFggaW4gdGhpcyBzZXJpZXMgKFBST01PVEUgaXNuJ3QNCnN1cHBvcnRlZCku
DQoNCkV2ZW4gd2Ugd2FudCB0byBzdXBwb3J0IFBST01PVEUgaW4gdGhlIGZ1dHVyZSwgaXQgZG9l
c24ndCBpbXBhY3QgdGhlIGxvZ2ljDQp0aGF0IHdlIGRvbid0IG5lZWQgdG8gY2FsbCB0ZHhfcGFt
dF9nZXQocGZuKSBpZiB0aGUgZmF1bHQtPmdvYWxfbGV2ZWwgaXMgMk0uDQpXaGVuIEtWTSB0cmll
cyB0byByZXBsYWNlIHRoZSBleGlzdGluZyBzbWFsbCBsZWFmcyB3aXRoIGh1Z2UgU1BURSBmb3Ig
VERYLA0KdGhlIFBST01PVEUgcmV0dXJucyB0aGUgbm93LXVubmVlZGVkIFBBTVQgcGFnZXMgYW5k
IEtWTSBjYW4ganVzdCBmcmVlIHRoYXQuDQoNClRoZXJlJ3Mgbm8gaW1wYWN0IHRvIG5vbi1URFgg
Y2FzZSB0b28sIEkgYmVsaWV2ZSwgYmVjYXVzZSBtb3ZpbmcNCmt2bV9tbXVfaHVnZXBhZ2VfYWRq
dXN0KCkgb3V0IG9mIGt2bV90ZHBfbW11X21hcCgpIG9ubHkgbW92ZXMgaXQgb3V0LCBidXQNCmRv
ZXNuJ3QgY2hhbmdlIHRoZSB3aG9sZSBsb2dpYy4NCg==

