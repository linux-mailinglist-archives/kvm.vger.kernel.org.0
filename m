Return-Path: <kvm+bounces-58835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 883BDBA1F65
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972491892EA3
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED4D2ECE9A;
	Thu, 25 Sep 2025 23:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lsr7a0mt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEBC2D24B4;
	Thu, 25 Sep 2025 23:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758842673; cv=fail; b=nnMi6KwPh9KwOzO8l7mwaf66kXPRzYgybDKKGX6RXM2Q+RE8oKohrqF6Vyoqh1mDjH/3SZzwLAOBfW7uRqWaYCAjUj4Q7MOarebK94fkGqj2+ba0h9dxxYNrqM0+8yTgZj1ddfdVp/Lh57U03XqgmUb3B80JzeJZjdOw2c6yuc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758842673; c=relaxed/simple;
	bh=XQA5bSCeqgAPnis3ElC2jsloU3RAWxCJdpWppAF+hmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q5CCvEDlO2sr9AqZlxWXYcN+PTmtafwaSwYgS8lcehQbs0htEWFESEOqY+J8dcvK5kjnxAt4sPGqDgY+ZnKjvReLDy9pQdo9QoGvpjO+kPzxALFs67LijG5eEqo8kuzJ5BgSwOo+jQGfek36+CphjyoTsGdAZalRcgC1T/Iq9/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lsr7a0mt; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758842672; x=1790378672;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XQA5bSCeqgAPnis3ElC2jsloU3RAWxCJdpWppAF+hmA=;
  b=Lsr7a0mtVNLxsF2mpHLd/nMbFZ/GoQZRwf1sK3qsvJZwfi1TSkOPh+6J
   akr2ZHy6L/WHa9VFU3eQ9+RyS4AUb2rKp9/Emk5E/ZvJdZSk8jeLQ3EkK
   mYKTD8K+lX/znrTMirggDXr+TCMsHeixb73hoaOxWYvdb6EoO0a/ApQJn
   yq8zdktHIZpkufJnuN5mJiXLCA8uD2B8LUy6DEARhrCCytd8ihW6bcLQz
   FYDHuIiPVtbCRod5Qni3fkxzFE0SeS8X4CvQr/YEivY1gaAo0h7IxhLeb
   gJ/wvqKt3PTAmh1D4NUXPNExO4lO3ezuv/PtRx0R5Jxq+25uMPxOZyff1
   Q==;
X-CSE-ConnectionGUID: KEocUgh7QpSloZSZWlv2/Q==
X-CSE-MsgGUID: dUnVSAxrRUmk7msvRbAzRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71793782"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="71793782"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:24:31 -0700
X-CSE-ConnectionGUID: GSyyEHs3Rm25maKFM44bGw==
X-CSE-MsgGUID: GZqK3o7TTjmoLKvSQo722w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177395597"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:24:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:24:31 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:24:31 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.12)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:24:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rLb/kCiZWXAxbePRqAfTC6OQFkpjITFwLaffdtvJSW+41jVAHQ7j0QUx+GPiKW15HweZxOosqeAawVJlUcoblGfRmK7tE4g+fZlHjbpc1Ox6T+VVP26ef+unNdgxt49BksPyXtMT6AlAmwYQ7I1aUHnJqW7Y1nI5Bv70Lul/aSHURXHb6o+RcLEpiEfy7cAkbDY3NweE2EXhNqHGb1Tnmp/qnEsBASBBx01tBmEGR+nq+HqXTw9xbBexjKhwrsaHXfhcj3yQdEjQO2P3FSqkkv5mKMvBsoJuuFP/OFADRUxLgw0CZGjPTzOmpoQES9P2hqOGGDjUNSGVN8gO1tMe/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQA5bSCeqgAPnis3ElC2jsloU3RAWxCJdpWppAF+hmA=;
 b=THgkoZb+hI3YTDhryB/TbRVfCs4eOU9OY+EFX9QlkE5kto9vXVJQTkG4NX1Moe60kICnCPddOAnjwCd2XQKTIzZkhE5quz9QfThyxx0Rs1dgyF7WzCz5HjSnbExYbkDJlNOC6boQNBenwhswcMR5aKrj+ppjM26aqGqg7LF+GKvo5QiH8NEGFjABbPxRbO/Nap3tf50tsy38BXkdGicFrtazzgpJyetTfcBmTFZHtmGXV9JipaAuS0/Acj82nf2UlBc3quCP1ltPKRJbe4H5RfSZqOOIyhMyibzDjVTBcRb6o/SEdSAz0bZWxFN4zOlOm9DFIb8k7mOvm6fXlQDbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 23:24:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:24:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcKPM0E+1js7qjUU+dZA1L0QEu+LSgUieAgARDAoA=
Date: Thu, 25 Sep 2025 23:24:26 +0000
Message-ID: <689538b06add31d6377618de7407e388162ec2d8.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
	 <8d861d33-142c-464e-8dc1-14a834eaa08a@linux.intel.com>
In-Reply-To: <8d861d33-142c-464e-8dc1-14a834eaa08a@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6835:EE_
x-ms-office365-filtering-correlation-id: fda91704-d6d5-438b-ea79-08ddfc8aab8c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dFZ5TERWY1M1ZS8zaDhRNUQ2NlFaenFUWVNGTCtIMnc4N3NlcW9QUXJUVG1O?=
 =?utf-8?B?cTZIWlZHMURMSHhxeTZHRkw5U3cwakZma0U5NUdrWEtOSUkyQithaE0yQllx?=
 =?utf-8?B?R2ZWVVo0VUt4NTlzR25sdjN5OWVNRHRaZmNFa0hNa25hS3ZxTVNJVlFMUVUw?=
 =?utf-8?B?NXFlWGsxS1VlU1k4RTlaSTdaZFpDZkl1WWJPaVdCcmowVW9NN2dhMnFiWmxx?=
 =?utf-8?B?aXI5OENjL2t4WXR3amRaZVlsTUlBTzJmbGFzNmovV3V0OGdDMExlaFMwYWpM?=
 =?utf-8?B?TGRTTHRka0lTVzdPVkZmeUx3czUvYmF6Wml5WFlVeUdhNUdNNWk0QjRHVjV5?=
 =?utf-8?B?TVhVTExMSm5xUjZGZnV6ajRmMkVITWpmbXpZQWJxMEMrQlNhdUVxOGNpNDhm?=
 =?utf-8?B?cGFhaVBjRzJ6QUZqWjFtVXRWN3V4clVXc0Z0alptQU50YzlCcWRlTEl0MnhV?=
 =?utf-8?B?alhlS1daQWd2bUlmZlM3aS9Sc2kwQWdiSmJDQjMrY3ZITXN3RzhZaFFuZklW?=
 =?utf-8?B?U2lUVkdFNGwxNnBjVHlCSThUek1YSUhmbi91VXRoL0ZsdnFlQjNiMGRXY1Q1?=
 =?utf-8?B?ZGNGTGV5bU5Rc3ZhNHd2WWlCMnBWY2pKMlVabEFNcDRCY1pUa2N2MkJMR1Bu?=
 =?utf-8?B?Q2Fld3NVYUJzeTFSTDdWWHNBUUN0MW9BNmNlUWphTU04emtkYmVkSkZ4T0dM?=
 =?utf-8?B?aGVXeGErSG5OZVJUUWZKN0REdXIvSGN5TlAvM096Y2ptV2srd3JlTXRCOVZC?=
 =?utf-8?B?UzhPa2F1M3BPZzR3eVRoZWxnbVlJVXZpNkxmbUh3TDR6RDQ2endyeWp6SDhY?=
 =?utf-8?B?L3A2bEJtRi8vUFFQWUdTeUFSSm1JdG9IUkZYR2VmRTcxTFdKSENRbVJWNEtX?=
 =?utf-8?B?ek5DVTVlQ0RoTXREUS9XQS9FWU5nS1JxWm41cmIycC9NZkRLRVhIWldBVUVL?=
 =?utf-8?B?dWNCelA3NkhvVVZ2SGVrZzYyQWhrV21xeXdZTHBiUEovZzNvYUtHZ0NqOUpx?=
 =?utf-8?B?OGRBL2xKbXl2ZHBzVXplYzdkaVBlUVhoZGd0V3Z5SDZsV2hGWFNQSEY5WHlr?=
 =?utf-8?B?UEtVSGdVaW9SSnZQTlpxRWRtMW01T1BmSm55bExDUWtJeGc0NlQ4YWcrbFVz?=
 =?utf-8?B?ZGhRMU51enBOQTk1WWNBcTNUT3V1UjhQZUpIM2tlazRveW1yZG1oZjdHeFM2?=
 =?utf-8?B?VjIvNktmZGQxekRIeFA3RDhmbFQ1U2lsUzlnaURGU1ROZ0sxUnZHRWkrbytS?=
 =?utf-8?B?Qi9VcnQ5Q3FNZTdyVE9PNTNrRlFscGtMcmMxKzBGOCtRME91NHZseERFTlZp?=
 =?utf-8?B?aGVYRW5SWUhQNFkxQklXRWxXSGRtOXhtMnFxRUlkZS84dVMyajhMb3FZMDh1?=
 =?utf-8?B?UHlmakpaK0JIZkl6NGtRazQ2L2dXUTlpdGp2bEtQeDVIODFFQkhMOXpFcE4r?=
 =?utf-8?B?dHpEVjJlZy8xbEd0Z0lmWHJwWG9pK3Z4SThZVTdwU3Zja1NGZU9DcC9Jd21O?=
 =?utf-8?B?bFp4VzFUQUFxYytTcmg5VXZVQm5OZFcrT01rV3dUNTNMUmcrTDNLam43eDJi?=
 =?utf-8?B?MzlObHFNYmx2QXBqUzJEa202N25DWkliaFd4US9xS0JzZW9LOEFHdVRzcXlF?=
 =?utf-8?B?UHhINnVaaUs1OXQ5OWtOS0cxc3dkNjJrRHY5eUtsL2xPUXJUbmdyQ2JtSjgz?=
 =?utf-8?B?UlZxbGZzdVJWT0lNNk1QWm1MUGFYU0ZGY2V3LzJYVU80TWVKSGxpQ3VxODF6?=
 =?utf-8?B?QktPcUpXOFp0TnZFV0hwb1F4MGlsTmFmOWljdlErNG90TFAvbVdJNlQxbEhG?=
 =?utf-8?B?eUsvTERmdldTdUlsVzRzSXEvcGR4eU5zLzloM0VBTTJuelgxUG9LWk9iQjlS?=
 =?utf-8?B?TnExRmlGMHhWdm00WXhOL2dXa0szQ2s4azBpa2NuaUFaak8rUmsvQW1TTHhB?=
 =?utf-8?B?dHpHdjArYld0bW9yNytSRWdPaFhLajFPQTBBczJXV3JKNlRQKzhvVkNOSEtH?=
 =?utf-8?B?SWdoM1ZMb1BXaWJVei9YTXlSVE16eXo4OUFDbWdPWXFzT0ZWaWR3bnZiZXd0?=
 =?utf-8?Q?iJKqy9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1RSNFJRdUR5UDVBcVMzS2hWYkV4QjJEZFFPemliRlQxUkROOWJSaDhkbTNj?=
 =?utf-8?B?TWJlN01YMi9GbzZJQTZDZFpnMU9MNW5DdHp2TXRIM0NJRWlvZ2UwRHByYnZG?=
 =?utf-8?B?VGFmVjBldW5ZVWl6eGtvN2ZUVHIvM2VHY0w2eHhtRGFOcVI3TFo3WVJ5U3pO?=
 =?utf-8?B?Z1NnMHd1d0M1U280eXhrckF6dnAydm9EbVRjQ05XOXVCb2R4MlJlWFJ5RVVY?=
 =?utf-8?B?OE5zYmJ3ZjRTNHZzWGp4b2JFWGxjSmxQMFUvZC9iaTB2Q3VteFhtVU4ya0h5?=
 =?utf-8?B?QUVQZUxuUjdrcWNkMEltR0ljUVZvWmpEVEZQZ3Qrd0ZVbFRTZng4TWRjWkZB?=
 =?utf-8?B?dzFwYkZVUjBUVVZyZ2ZFTTU3S3N1UmpMczUvbm5TQlltT3Zka2VhNVhrUXRq?=
 =?utf-8?B?SEJyejlFdUJ1dmo2eTh0SkhBUEJHTG9FRjBKdGhaU0FLczVBc3RrS2tjR0xm?=
 =?utf-8?B?TXVtOTg1Uzc5d2JGMDZlWW1Rc2JxOWxmT3VBcXg3Um5GNDBCU0JxYkdwUFZs?=
 =?utf-8?B?ZDU3YVNhMlNqcUx0QkhsVUlMYkx0NXBNaldSdkMzYlZsR01OL2dBOHZFZi9r?=
 =?utf-8?B?aTNQWEdCMW9ScEFFREhuaEJ3R3NqL1BPZEtTMmxzdHNkWWRlOHJHRlZWbitL?=
 =?utf-8?B?OFVhYWd3WnpZL2hZRnhkUEYyZm1QeU5BSUZGRjFQOWZMQ3l1a1lsVnNGN3A5?=
 =?utf-8?B?NHBCTDkvMGMrR2IzNjlaZ0xwcS9aMDZBdEt5d3h3V0htY1dkZTZsa2J4ZFpG?=
 =?utf-8?B?NTFqejBWb3l0NnVaVm1UUi95NDNxTUFDU1NSUTl0MG9RL1I5QTJDUEFwNmZj?=
 =?utf-8?B?Q3ovbUNidzFsM0R6MEJPQXhkcUFXNnhLTW9rOS84eDR4QUMzMkJyd1MzSFFX?=
 =?utf-8?B?bjAxNlM4ZDRjRm9CL3lGMjI1SXlxS1B6ZGlNekErVTQ1WmVYMklVRHZkOVp4?=
 =?utf-8?B?OHlTem9GUVlOanhxWDlzZllJbXBRM1lVdUZndlFJUWpJQXBFekhkWlFPNmN6?=
 =?utf-8?B?TGpSaURPSVJ2Q2ZOY2RReXR3dWtTK3NiN2IwVFo5VUNzYkhqNHYxekRGTWdW?=
 =?utf-8?B?TjNGWldJWWdWNVM5dVk1a0pkajZmU3d1azBabjdFSWdWd2U0SGltYUg1cFlP?=
 =?utf-8?B?MkdvN2YxOHZOSTA2bWdxeVhCbGlzUGZHaVQ5OG1lVDUrV0FQQ0EwWm02TnRs?=
 =?utf-8?B?N0pUaDZQYXhLcDZ6SWdSUTcwRzdicUNSekVJUmVWdThNaWIrRDVNTlFudU9o?=
 =?utf-8?B?Vm4wVnFBZ2RoTHY0a0t2SXNBa0NLQkZlRGtvdFpibklVSW0wbmtzN1dicnFK?=
 =?utf-8?B?dVVLYWVlLzdNVWIwWUNsUm9pS2xyelVTcEgrMnI0SnZCN01oNlRtOWpEaHY5?=
 =?utf-8?B?Vy80ZEZlaE1pVzh4dVZRN21tRzNvbFBMOGxhcFpySnN6djYzQys4WnFOQ3U0?=
 =?utf-8?B?RG12UGY4aWpjQ2ZiT09scVZNMUlveVIySjVvc1Bac1dhem4xa21kSU9KRURO?=
 =?utf-8?B?dGtqVCs5b1AvUWJVOVNnRVZXZUtKQS94YjloSEJ5V28vN0llTDhMa0l0SmVk?=
 =?utf-8?B?SC9VczUrOHV1SGtjTm1LOVhCQXFITEJGOFNQMTdKc3A3SUNCc2JpWDB5QXdO?=
 =?utf-8?B?ellYT0xla1ZwWXVVZjV1VjJId2JuaUE5SHZFQ240RkI0azR2WTRkVks4Yi81?=
 =?utf-8?B?STROVU1RWkFoS3RNNGJxTUNrMEJUb3c2T2Z2WG1lN0pGenh5ZFZNeVpKSVVl?=
 =?utf-8?B?ZUdPVGxoVGo3cW95NVFSeXpqczlLd0RyckhsL3hKWW5FelptdG1ML0pTZ21t?=
 =?utf-8?B?UCtTeUs1MVpqejJSbTh3bS9oZXozOUpTamI5R3VNaGtMRW02VWN5NjNLbzFq?=
 =?utf-8?B?N2FYbTRJRWNHeGFOSkgvQzMwS1JOTTRpZVpXbXVQTCtHZG9RSEhIQjFpUWkw?=
 =?utf-8?B?RjBva01ZNnZiMFFrdjFUN0NnV1RjSUhid2RXM3pWdS82ckRLSVFiVDFMRTFw?=
 =?utf-8?B?dDVJMGVsTzVwN0pTZ0l3RFFBUENKU2dJcFd1YUtaMUxYNVM1anlLWnZjZ1d4?=
 =?utf-8?B?UHR1dE12ZFV6bWJxeCs2R0p0amFsM1dQdVM3cWt0NnNWTUJ3aG5yTytUVCsv?=
 =?utf-8?B?N1hNZjBGNE1lTnl2SkpMU0JJN1p4bW0xYnN3bDQxY1h5dU1CUTdMeGlyR0gy?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAD52A3D85BAC54FB34181452462A597@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda91704-d6d5-438b-ea79-08ddfc8aab8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:24:26.9964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Us3CKu09L494EWpnEYP5QNisLc5i/cInqmJA6MBG/6gPz9f4kregGDyWmvVl1HNYdsfBGTJMXVJUl9l09jY0JdEuaOvduTeBZLVpAKf3AUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDE0OjE5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
K3N0YXRpYyBpbmxpbmUgdTY0IFREWF9TVEFUVVModTY0IGVycikNCj4gPiArew0KPiA+ICsJcmV0
dXJuIGVyciAmIFREWF9TVEFUVVNfTUFTSzsNCj4gPiArfQ0KPiANCj4gVERYX1NUQVRVUygpIHdp
bGwgYmUgY2FsbGVkIGluIG5vaW5zdHIgcmFuZ2UuDQo+IEkgc3VwcG9zZSBfX2Fsd2F5c19pbmxp
bmUgaXMgc3RpbGwgbmVlZGVkIGV2ZW4gaWYgaXQncyBhIHNpbmdsZSBzdGF0ZW1lbnQNCj4gZnVu
Y3Rpb24uDQoNCk9oIHllYSwgZ29vZCBjYXRjaC4NCg==

