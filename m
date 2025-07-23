Return-Path: <kvm+bounces-53273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 163E9B0F7BC
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23AB958449E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A461E5729;
	Wed, 23 Jul 2025 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eg2CsLfj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3328A1D6DB6;
	Wed, 23 Jul 2025 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753286632; cv=fail; b=eI0SrkkJOeS44/qJLcGvC4f5zYNsDx/Qmf4Efp7pv6Mz2fEUlgKkKFwo9o9BLpqj3jDnSGZ777bmq7JmeFgy9XO8pxling1xSGkkxjqCo37KjR3g3PPrYXUtRCY+mxSQxDM1/uvD9D2WGRFkbTr2nMywCxiGMY4e1FXE8bBdP8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753286632; c=relaxed/simple;
	bh=LEWiGzjKIexK/cfxaCUebtgPquQVyEVWqPmHGjvVruI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m39dsZQlcmyjs/aGJycRcrtGVqfG3z7ugYet8b3RkjNqLU8PQxZgbz0wCBRr1ssKxgeMqw9nGOi4ilfPFEXR236t0QFoHmwcZ02giHunHqajfo++CvDYdc06jcD81FGT0pygVIaykQ13qjWIktztQI0g4199eVrjB5zN/wsbpCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eg2CsLfj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753286631; x=1784822631;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LEWiGzjKIexK/cfxaCUebtgPquQVyEVWqPmHGjvVruI=;
  b=eg2CsLfjWE8B4uHG495lNURsk3fw7izjj44M0IxPGDh48K3w8YshHDwB
   jYDHMxB3JEzd/mVZF4FK292eAXW5MwwLeAfMXbn0dQGEThezjDwF5tMs9
   tcPqUS9GjOL92pWEqsDNhYl37KOyF+N05GSnHFA+ir4708oeSZXqkxYk9
   RvULzGtEfhmnUrWzEVF7n6hUXkGnKuo+s3pkDrHyrXMgV7aB/uba828jZ
   PRHiZ1X0CLXew17M731L1MBFV7cejCyESxRE3z/blycmGFI0vzup/MMrm
   GDLYwXL/vII1Hrw+kbNMRB+ascN3E+ZS+JtX/SyGqJzG5DjAWs0UCvJlJ
   g==;
X-CSE-ConnectionGUID: Y7paI5kWQ7qaLb4SJMvydg==
X-CSE-MsgGUID: 7t5hNpjeQmKKCuVHBJqvaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78113962"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="78113962"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:03:48 -0700
X-CSE-ConnectionGUID: A8IgBAqvTXGer88nFRWuQA==
X-CSE-MsgGUID: VMVirEhLQDOw2TPvnostrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="190593857"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:03:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 09:03:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 09:03:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 09:03:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZPGxSjOKsFVM396jswlhuLroNl9kFErxH0NwPuJjrQ/S01ujBOrYT1lWW+bry5YViyZ3kkQqQtXnzaZn9CqPUeb0/hCZ1PPgvIkhu9zRH3eY3kNy99/HDECYqJHYUEApCxUj3IlmvKlpLvoQyGrByRAFDCBcqAgLXJ1C1rIB8YANtXP9q5f+iGfzKL1qQqiawRe0dzHGs3CiEYAxvTc5puj2IvQdO8voA6bpvgio1QLPIEqh/v2c1OCJ6eFf4ZmQQq31MkwsS0elNYrogw9rp4QTXIhgMbgt5+e0qMb4v1o42Nn5sh6x/ytZStRqIHdVSjr9V7iEF27FZkGix29Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEWiGzjKIexK/cfxaCUebtgPquQVyEVWqPmHGjvVruI=;
 b=rkX75jkkVTP3B9IQX2K+td9AbYWQWD9Tix7GnZVzhhfeP48UyAYs0UbA54WliwBWjTqT6WmR6Cdnc4MQFMV3gJ039o8lMcM8n/jzE4dUWCOxT4nyRV+wEC2FQ6zRSi4n1mTnHi7JfZ4i/ld/3qxF0R6DWsoyn7SIgTalp7HxCEo85pHJRO37n9AccFfMcyb1G5mbwfxEA2JQRQIzhoIvo4fcIKOYDQFCjX5oSdSD9XqZcSq979Tju0iaaComTKFwUXKw30Yghzg6vdJ6N0vK16hCe8zWpTO1IuCpvCc4mLoEMYjkhTmb3I0JNICZOZm/uADXUGhiI18LXDeD3x63BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 16:03:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 16:03:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovx0yLPSIy6USdKkSakZSGBrQ/vkCAgAAI0oCAAAHTgIAADQeAgAAAxICAAAJZgIAABfqA
Date: Wed, 23 Jul 2025 16:03:16 +0000
Message-ID: <f200b7dc72a5ca2d0e14b1a597d1757e21c80f36.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
	 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
	 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
	 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
	 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
	 <6d91fc951cd39110db8f9b5565e88dba39eecfcc.camel@intel.com>
	 <d51c28a3-bbaa-470f-a07a-5706cb5a4b90@intel.com>
In-Reply-To: <d51c28a3-bbaa-470f-a07a-5706cb5a4b90@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8210:EE_
x-ms-office365-filtering-correlation-id: 63567e40-03f9-4a71-b52e-08ddca026f49
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHhPblM4MkRITGlCaUtGWXZUOXg1ajJIeWVzT0huWUZ6RXdGZUNMSjVmWHlB?=
 =?utf-8?B?Tms1S0R6dG85OE1yeCt2TU0rUEZjU1ZKemFkMmhkclRuSHptNFAvVkRkMHNs?=
 =?utf-8?B?MTVxMkFJK1B1K2lkbFgvN1czeUdNMGlIVGhWbzlRUXE1VlhHWi9sM2lza2ZT?=
 =?utf-8?B?K011UE1oWUVaZHNVUjRRN29MM3FoTjhNQnBXMlZQMzVuelFaK2YrcmRTV1hq?=
 =?utf-8?B?OGhtdUZNRlV5Ukl0TUJNbDlmWVlwdFd0RnhPTkNZVHRscUlxbjBKTlJwZTI5?=
 =?utf-8?B?NmtPYWFVY3JrWTdoUE9kZVhjZnZDTURJaWJIdklyWVpEQ2VtV01tQXM0aXpZ?=
 =?utf-8?B?bUZaWVNtYWJNZ0lSVEdxSEw3bVJrUmNnU2gzaC9nbmF3S2R1ZEFwM1g0RlFL?=
 =?utf-8?B?NmFYZ1RhWWZFZEdad0tWSlpsTFNNWCs1WFhpY2UySFI3NWVrd0xhK3N4QU9s?=
 =?utf-8?B?cG5FamdSbUhPbGxqYVN0QSsvaU5OUnVlM2k2TzBJTFpHOFhCN2J2VExGdUpt?=
 =?utf-8?B?YlVHTXYvZFB1bHp4SW52cW5KZDJQcnBraEs2YkJDVzNHNFA5OEpBSUxCbUJk?=
 =?utf-8?B?bTJiNkR3UDdoWUEzUUZ6UllCNnRlMm82aE1vSHowM3R4aWo4MTZ6RDl6UDM1?=
 =?utf-8?B?Qk4vSkxESFJBNzVMNjlCT0lyWDlVWUNreW5WRW95ZTE4VG9rL3R4SUpidjV4?=
 =?utf-8?B?ck1DNDE3V2lTbnVGYm9oQlp2RGJuNnRoMUhtK3J2TXQ5NmNuYnE1eEtQWDJV?=
 =?utf-8?B?Q0R4OHlNaHJpbWc0ZytqVFdrMEd5bnZyNVFTVDhUaHJPb3FJUVU2ZnAzNm1m?=
 =?utf-8?B?K2tRR2plWXZOcmlFaGIzQ3VhVjFjNXl3REtQQjRtOTg5ak9kb2ZOOVJPWk9k?=
 =?utf-8?B?bE9CNzVuNnZIaUoyaVdscEFtSk5kZTZvc0lDdGhkdjI1c24ydGFkWVRERTM3?=
 =?utf-8?B?VzBlWVJidDFIK0NQbFp1ZTNwQm9DMEp0YnZjd0RjOEdDV2dZejF3TlU3RWEx?=
 =?utf-8?B?dGk2MXRlc21HWE5vWG93R0lZaVowN25FdjNjOVJTU3d3b3ZhUFJCT2xnVUNr?=
 =?utf-8?B?R1Y3TzNEWmRWSVhKVC95ZFZiT1ZUY3JnQmsyUkE2MytCdlUzOEcvZ3lmbGp0?=
 =?utf-8?B?cXUwWm1sZlVLRmUrR0wyUFlBUUFUOU9sbU1vUXQ4aSt2WnlCOEZuMWZ3MEhV?=
 =?utf-8?B?eGNvekl5QXJCaDUraThaeXJVTHFwSGVkR3hmMnlRektnVk9GUHNRTjBTKzFi?=
 =?utf-8?B?VUxZWUtXQXFyd0NHcTlMMlh3dCt1NDdydDFaeWRlNUZ1R0g1YmpLcEJWeElU?=
 =?utf-8?B?d25hUVJIQU1UaGZLdUV0NDdWa21aV2R0dDkyRE4zUlc5YU5Kd21aRDV6OEdI?=
 =?utf-8?B?dHdCdDFxMk54M09maHRBUUZ6dlQzVlErTmlXai9KdXdmblExTU9DKzVOMVNG?=
 =?utf-8?B?WDBFSkRQaUJDNjhsWVVYT2xXWGN5djQ2R3lpaDVvVVVaNUM2eldEZ2FwZGN6?=
 =?utf-8?B?cGMxMzFHbFpraWQ4UkY0Ti9XUEJmdWthM2JveTdXWk5NakJPS1N1eERERUVj?=
 =?utf-8?B?ZVFHS0NjWWNPQmFEM255RC9vaFNQNUd2V2toNGNqRm5yTUpqN0hMRlNja0RU?=
 =?utf-8?B?MksxOXA0cGNDa2N0OHkxWDNLcll0L205b2NHVVcyZEVwamNFSFg3S0Q0bDY2?=
 =?utf-8?B?bnVmZm5BRE1rUkhJNkRkSGZKZnZtN2tpRlJHM3VVREFVVVg4bTJsZ0g2a0VK?=
 =?utf-8?B?RDhRaGFnTUUxTmtzZkxJZ0VOMk1CbHZ1NU1YcFhDNUxHZ0gzQ1E4TmpudmU3?=
 =?utf-8?B?bHQzUHFhYjFzUEJ2RE16NlhISXRjakEzYkZYQURNcHBZdFl3a2xmMkYxUzRk?=
 =?utf-8?B?SVIvZ0FYMDFXbSsyRFVsVFdacndEQ1VTLzl1MW1aQlhvUlV5OFZPSTIyVmYw?=
 =?utf-8?B?bUoyeVpqM0hndnhVUGt1Wmt6WEMwNHFkQUVEQXMvdnRRS3FkRGt3UFpSNEl1?=
 =?utf-8?Q?KJmzUJq7VJdyjqaEQOE9f0laF84eRI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVgxL3VyN1B0bzgvWldFUUt2NVFqZUhJVmNHTjV0TWttWXNFanFvaHc4WUR5?=
 =?utf-8?B?akhVZE1SeFAxa3YrajNiVkJlUVBuQVdLc1RGTTRsVmtYeWVJOXhLaGZkemEz?=
 =?utf-8?B?WXJSc3UxUkdKUUhsUzZUVEc5MkhnS1lVRnk5K3JPcmhYd05mUm14MjVINnMx?=
 =?utf-8?B?NEM1MjlSTnpIaDY4SnVMVzgxelFGaGVENzBIbHlCdWZubEZrUU1qU2NDbEI2?=
 =?utf-8?B?TTIwS0NxUlYva20zakNDNE5CekJZWDduU00vL3U4eVdEK1ZsWVRSNktsZ3Ba?=
 =?utf-8?B?YVB1eDZQQjNySGJNTEFBdjBMZFA1YzVzdDVoTmFNdzNoaDR2WENUNlRhdld0?=
 =?utf-8?B?N2QrMGtUZ3B5RHF0L2hkRlkyNEt6T3ZqV05ETjBPeTJ3blkzRFFRZjg0ZGhE?=
 =?utf-8?B?cWo3VUgwcm5NSmxyZWpma2JMcFNDSWJ0K2N3S1dlNVV6Wm1lYXFHTDRQejVU?=
 =?utf-8?B?ZFBvTDNzdUtIRHlxTnVWdUFoajZmbVAxaHZGYVczY045aGxSUjJqMENnWHBV?=
 =?utf-8?B?VisrWjEzS1MrMzZzVVIrbkppTVNZSkUxNklCaGROeEFzeThzN0UyaHdpSlpq?=
 =?utf-8?B?dStXYi84NWJUR0FUSms4RUxVMXBJTVMvVEY0ekM0NnRZVjNBVnl5TnhVRlBt?=
 =?utf-8?B?cmdrNUEwR2x4R3ZPZll3OXllYWJRbGtRSHJxR2JoSDYwaGFuVnQrYjZRYUNS?=
 =?utf-8?B?SXFzUmdpN2xMeGhQN29OeXB6QmVDVHExNFlxUWJLVFRidHpvVGtGcGd5TmxW?=
 =?utf-8?B?SG1TNmpTMVVWa3I0bHJ5eWw1TnFSelpWc0VDZGpQUGpxTlFpTmh6NFF2R0U4?=
 =?utf-8?B?MGJBcmdSUWlNb3hQK0ZKMjJQQkZtUmRaTUdJSkIvYVRXbW9XTG9wQU1yR2pw?=
 =?utf-8?B?enh5NzBob0NjcnVsVWVlcVBkZ0NURkJrc3I2b2ZPVVBSWnRMbGZ0blI0SlF0?=
 =?utf-8?B?VUdEMTg5bnI2cXdQcjhqSTNrVS9GaGx1cDl6VENSWVZPYzBraTNNQjNva083?=
 =?utf-8?B?eEtnSm1PWFJ3aXhmdnFHeFQ4Y0pxWnJoeWtMUDVmS2RuMldvTnZMaDFDS0Za?=
 =?utf-8?B?K3hWcjAwakFjdGI4QWhLNmMvUnh4ZmN0MlJWSnlmSkpCSUhKRFpSU0s5bWdk?=
 =?utf-8?B?cEdmKzVXRE5aTXRKRG5aS0VveGY5KzhhQ2owcUs5cVU1SDRZU0F4UEtVY3dE?=
 =?utf-8?B?TFlSN3hyMlkxZDZlRUpPZGF3NzZkWnV2T2pLam5abkd0Nmx2V2RRblRFZm4x?=
 =?utf-8?B?NUxTZFdNNXBRQ2xkUWtRRjNlVHVEei9ZdGhtMW5makNQNGhuZEhZd1FjNHc0?=
 =?utf-8?B?UjRHc1hhNTZPVEM0Skw2bnpnOTZLSHdMc2RxOGtlODBob3pYc2hxLzZtaEhM?=
 =?utf-8?B?c0syWVpLdG1LeGFiaysvdGNyN3BHQktXaVE2czNiQlZnZkwwWFBHZ21LbzZx?=
 =?utf-8?B?V1hjaXNpVStvU2dtMHgwSytQWEFCelpNdHdkOGsvYTBPQ05YVUYxcjB0ZkFE?=
 =?utf-8?B?Y0JEcHl1cW5CRWZZc2VDbDB1K2g3R3JmeFBxd2tFSkJMRTVybVpFNmZSZ1ZT?=
 =?utf-8?B?RFNaWlhuMHFzeFdVaEtuZitZZkpoOVliQ1hUdkRmVGtFakFrNnFlaTJMdm1E?=
 =?utf-8?B?RDZKeUZpai9LUFVCZWFDY0djNlpHOXJzK0REL2N2WVNsNHlZTUVCL3BpaVRT?=
 =?utf-8?B?Z1hpS2Vkdy92N1hESFF0WHVidkRsbCsvcHJNWXVxZkJqMjNxK2orTUZxT0d0?=
 =?utf-8?B?WG9EaFpjcmJVck5maStNUGVsR2lwOTAyOVQyL2xqcDhBZklaL2JURWRUWko3?=
 =?utf-8?B?cm9EVmdFZUtmT2NMZTcrQ0h2WTdYVHk3bExUeDhzYTBiTlhOS2pIWHNXNUUy?=
 =?utf-8?B?VVJlVDFkNHNOMEw4M2o3ZUZPVGlmSzN1ZmRxSnR0WnVoSFlxZDhwMEN3T1NY?=
 =?utf-8?B?Mk5LNjZzWjI0OVpVOGU4SC80cytaVzZtTVdxVXd1VDFmL2MwbUpGdkh5MUYw?=
 =?utf-8?B?MWRxNlZiL2hteDFBdS9ENWRDcXQxdzU2eG1VWWQwL0tva3VwcjFuR29MZDRy?=
 =?utf-8?B?MjhZVVlTb1doU1k2STdmTlNrS1NFRmNzL0Fkano5b2JwSjVINzNMTVJiZDlv?=
 =?utf-8?B?US9pL25EYi9Uc1BHdHNGSVM3QUlkWmZtdXZ0alE4engxNmZpY1huUDJDTmhw?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <403BF1F6C9658146B1DF559C77EF7DB4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63567e40-03f9-4a71-b52e-08ddca026f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 16:03:16.1702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OGtJQ1p1SxFgwYOdtfeF27+OMJS7sq8ya4/eDSpcGM0Ty7J04tMj4NyZwTXmauoec0jJXb9LZSxXaK3VQ/VA5Gscz91Pl5J9Q5pzotqtI0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDE4OjQxICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiAyMy8wNy8yMDI1IDE4OjMzLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBPbiBX
ZWQsIDIwMjUtMDctMjMgYXQgMTg6MzAgKzAzMDAsIEFkcmlhbiBIdW50ZXIgd3JvdGU6DQo+ID4g
PiA+IFRoZSBsb2cgc2hvdWxkIGV4cGxhaW4gd2h5IGl0J3Mgb2sgdG8gY2hhbmdlIG5vdywgd2l0
aCByZXNwZWN0IHRvIHRoZQ0KPiA+ID4gPiByZWFzb25pbmcNCj4gPiA+ID4gaW4gdGhlIGNvbW1l
bnQgdGhhdCBpcyBiZWluZyByZW1vdmVkLg0KPiA+ID4gDQo+ID4gPiBJdCBtYWtlcyBtb3JlIHNl
bnNlIGFmdGVyd2FyZHMgYmVjYXVzZSB0aGVuIGl0IGNhbiByZWZlciB0byB0aGUNCj4gPiA+IGZ1
bmN0aW9uYWwgY2hhbmdlOg0KPiA+IA0KPiA+IENsZWFudXBzIGZpcnN0IGlzIHRoZSBub3JtLiBU
aGlzIGRvZXNuJ3Qgc2VlbSBsaWtlIGEgc3BlY2lhbCBzaXR1YXRpb24uIERpZCB5b3UNCj4gPiB0
cnkgdG8gcmUtYXJyYW5nZSBpdD8NCj4gDQo+IFBhdGNoIDEgb25seSBpbnRyb2R1Y2VkICJxdWly
ayIgdGVybWlub2xvZ3kgdG8gc2F2ZSB0b3VjaGluZyB0aGUNCj4gc2FtZSBsaW5lcyBvZiBjb2Rl
IGluIHBhdGNoIDIgYW5kIGRpc3RyYWN0aW5nIGZyb20gaXRzIG1haW4gcHVycG9zZSwNCj4gYnV0
IHRoZSBxdWlyayBmdW5jdGlvbmFsaXR5IGlzIG5vdCBhZGRlZCB1bnRpbCBwYXRjaCAyLCBzbyB0
aGUNCj4gdGlkeS11cCBvbmx5IHJlYWxseSBtYWtlcyBzZW5zZSBhZnRlcndhcmRzLg0KDQpOby4g
SXQgY291bGQgYmUgZWFzaWx5IGRvbmUgdXBmcm9udC4gSnVzdCByZW5hbWUgZXZlcnl0aGluZyBh
bmQgcmVtb3ZlIHRoZQ0KY29tbWVudCBpZiB5b3Ugd2FudCB0byBnbyB3aXRoIHRoZSByZW5hbWUg
b3B0aW9uLiBKdXN0aWZpY2F0aW9uOiBNYWtlIGNvZGUNCnJlYWRhYmxlIGluc3RlYWQgb2YgaGF2
aW5nIGNvbW1lbnRzIHRvIGV4cGxhaW4gY29uZnVzaW5nIGNvZGUuIFRoZW4gcHV0IGEgbGl0dGxl
DQpiaXQgc2F5aW5nIHRoYXQgZnV0dXJlIGNoYW5nZXMgd2lsbCBtYWtlIGl0IG9wdGlvbmFsIHNv
IGl0J3MgbmljZSB0byBoYXZlIHRoZQ0KbmFtZS4NCg0K

