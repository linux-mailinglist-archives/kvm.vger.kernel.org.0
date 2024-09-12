Return-Path: <kvm+bounces-26726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AB2976C61
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F4EB1C23629
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7ADC1B5808;
	Thu, 12 Sep 2024 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuR2yMtf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EFF1AD276;
	Thu, 12 Sep 2024 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152255; cv=fail; b=iIRq/WWOMPolvD8OiCjsUGp4ai5yx3hhfcQ7j6ABtdyhYPIhXBqO8o7qoAkIQnht0celxA4bXkaCVbSdsZTrEtERuYD82NBzxx/ZIjHlxD7/fTRMLctliSUQ4oq3ibgKkMEWf0kUYsg7b7XZYX5yaig+otGZCxLxBcX45r6kbT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152255; c=relaxed/simple;
	bh=KiB13/Ed//r4uVxnLd/ZCw38/4nu0W5hk/GT2qwLdnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IhAjEleMm23YwoRBBEPuaYd8aV1tnN+i3xw8keewfAqHtLRK6DazcW/X7KU12UW5n4u4eOevT1fhmmIPLpvG2e6QHthiQLaRzk2RhaeRev/HM7ZfMamVqTHFd2FTvfrM0yRP1BkPpvB0GNPWcJbMglLiAVKjA8xhqczkD+FUme8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuR2yMtf; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726152253; x=1757688253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KiB13/Ed//r4uVxnLd/ZCw38/4nu0W5hk/GT2qwLdnY=;
  b=JuR2yMtfTWngWao0Flf+60124VbvTV0+Ez6m1vDfiLMvaiSNGo0Q/Mzd
   9Da/SIMJdBWl8dsISEZTjiSdFm8flFuis49GxwbO+1QIbmrXPqeR4WETO
   9U6iE/wLTLihT7IXSQDTiUUFI/K3IlJrhSDJFERvQI2nl7y+sC1WNDxzT
   NJhdvGQVyMgUQQHgUzd8WKbyY3rEJMPck9rbuuICPcIAlhWoPC14YmrI+
   gQ/wRfm3ce9Gsf66D/JhrsX9Yxkj/xMwSpwEoOB38DDF4r1BF+NQvN7p1
   Q+yG25b/sGezX6ccK5LPI41XLD1drR7UmLrEyI6lHKp+K/URtvocDRxJb
   w==;
X-CSE-ConnectionGUID: 6Km06A8QRMmc2kotiOoF5g==
X-CSE-MsgGUID: w7e7HqXsTxK+gKU04oXbbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="25138465"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="25138465"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 07:44:12 -0700
X-CSE-ConnectionGUID: 96QlyxyjRsiNieQCS0L+Qw==
X-CSE-MsgGUID: DlI3hggNTXOKN7+yyDwj7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="90973388"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 07:44:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 07:44:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 07:44:11 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 07:44:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLsAD2ZUPi0DLI7YgZZ1qUbyz7k2G6tFTgQeJnUq93dCk5ADTm3mdScgUxTwgdYG55kIKeXdXacPMWgefishUM9B2MxwryUg4r8OgVmD+Dba3Pan/Qof+v5yflFUgnpKBRoD5iyhICquFeZ9PORgBdydK363Ro9B1gpLPyR58N0gL48PrbCFNMa3b0DnrLBiWljSrA/WJubQG4Y9p40jvwvwER0QUrU+3l/Vwr/eBPj76ZqxSevzZ6vWCzVuZ6sl67zCuLKO4XDI2tWhbGUCAQyNC4KUQ9+Doba+mtCl9U1vLd2kGx0Wf/8WvPddJWl4z3hY9AXQz7YXfBS9Ertq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiB13/Ed//r4uVxnLd/ZCw38/4nu0W5hk/GT2qwLdnY=;
 b=AFh+RA2k4quCHD6+sLP4fnN3ZKu1ltnKN9ExRC35wAjGjIrOKvA1s1cxpv9XWa5WqFDvUfPFDH/dFtaLSsm5jnQeGXZgDfcixHxh7rNWSCl0R2dOhdcfeGTHcDBM8Uksp42hByOUfSy3DnA+gSAifTZ9IF0e+5SeWKRz2iLne5YWiFMywEOjQXeM/6Z+yoir+EGw7bggHFQASXJrKe6WaUNTFHOBQo0K+M4JDWI5E2P1qig53L7gjqLJbuY1OiKUGRmqxq1fsrrKgeGgzi2Xew8ww83UfbvPPV58zf4lFYksSN2aegBfir8VZAdq1NDjX+FIndq1nko4dx7XwSJQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 12 Sep
 2024 14:44:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 14:44:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Topic: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Index: AQHa/neyFCUwVv/2uUaPte14j/ISrrJSKfkAgAC5EYCAAL/KgIAApKkA
Date: Thu, 12 Sep 2024 14:44:05 +0000
Message-ID: <2d1c861ac7696050a2d93a21a5dd3f86b3215dca.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
	 <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
	 <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>
	 <ZuJ0E1JeRQrIboBp@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZuJ0E1JeRQrIboBp@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6732:EE_
x-ms-office365-filtering-correlation-id: 7865e314-427a-4a46-9277-08dcd33959c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SEczRXlmbVhzRkhiYTRlUkMxbk0rMWNOMlFpWDlrT2l0SWZJc0taR0FEVFZx?=
 =?utf-8?B?VXhJbnlrbXhSQldCYUp3QWVVRzJwT1JEQ2I5cjJva2ZJRkV2N2JyVnZPR05D?=
 =?utf-8?B?TlE1MXZKdUNKN2NuampVLzg1TitMY2dLVXpTS2NkOTk5WUN0U0U4KzE4L2Zy?=
 =?utf-8?B?RHNyV3BkNzZpR1I1SFZHV1cxWXN4T3NvQ1h4WjVqbXJ1b25TS3Z4cWNJWlFt?=
 =?utf-8?B?RU4yV3o4SkE3U09BSllHSWY3WE9XODRGYUI1dk52aithZUpQUGxjQnczVUlu?=
 =?utf-8?B?THhiWUtVQklXU0VDOUQwd2lTNzh6c3NGbEJ1ZGZheW9vNHJnM2dWT2xKTlVq?=
 =?utf-8?B?bVEzZTVsdEcrRkgwWkkxN2hIU3c3SHN5NXMvaW9TVUpXV0VOUG1VSzdCME5I?=
 =?utf-8?B?b1k3ajg3clRYNTJXcS9YNm5RQ0FKVmUrWEx0cUV6ZTFzTURBaG9zekl3MklE?=
 =?utf-8?B?VEtaVmVEOTJVQWhja0tWc3o4WEdDN2FRWE41SHdBWHFvbyswd2xaa2xwUm5P?=
 =?utf-8?B?YllwSHV3Kys0TlRmTTFhVFpNMlFEeVBPTkxRamJxRWZsWkZhUlRRRjJEOWxa?=
 =?utf-8?B?ZFJSVEdiZUFwWVozRHRkMCtqeVl6cml0aTF0WHU3ejJLQlQrNmNlTWZFRGFE?=
 =?utf-8?B?Q0ZxRjdDUVRIOWZRaU1KZkk2Z2xYdWhTajVERFBEM21hYXFoRlV2ME0xaEZo?=
 =?utf-8?B?T05GYXJCenpMSkdSM2daZ0FUVWJCcVRPM3A5MldySXE2MFNnTHR5eTRuSjA0?=
 =?utf-8?B?ZUVkVUZ4dXNIcldHNGNPVS81UVZSRUEwSHB6SVZVODI2MzlNcHFpYXVGREtD?=
 =?utf-8?B?bEZVZjF5VkFPVDIyQmI0SzNWVC9kNmtpSDNvclBZZVM2ZXg3M080cVkzbG5y?=
 =?utf-8?B?L09jZ3hFOGtMVWdaNWdMdE9HK0FPQ3dVSitHeEt0UCtmUE5OOWxCY0FzOFR1?=
 =?utf-8?B?bGRrdVczdXVnVDF5b3VWYnJSWDNsYUNrV2s1Q2RtUFJKSGZ5d2ttZ21HSXUy?=
 =?utf-8?B?cm1oUERvVUpXK0g0cXF5cjA2K1Jtd1ZjOCtjMEZEaGtOZ0hvUzBnZmQ4aGNZ?=
 =?utf-8?B?amk4RVBGZi9VOHJTYllpT0k3OVJJTCs3REhzTmczUUNCU0ZoSHhJODViVnpR?=
 =?utf-8?B?My9QNmJMcTZyUG1kSzFxSjNrTXBsWm5sZmlqQVdTQmVyMVIzdWpYYnNkSjFy?=
 =?utf-8?B?Y3FsdWdVZ282c1RDN1FCeUFnNkJVeVJab3RBTVBuZURKMmNoWkhzWVVieWlZ?=
 =?utf-8?B?ZFE5NGp5MSttczdVcUtCNit6VGYrOXo4aEdvejVjcGQwVXFOdGVvYit5ZVVN?=
 =?utf-8?B?WWh6aDJWdmp4MVBDZUhBSjF5Y1hCSlhLNXBvVXlkNXMwcXYxRmR5ejM5L0lw?=
 =?utf-8?B?bWkyMFAxczBqNmg3bFVSaUtXV3FFT2tmeE1Nc3QxeS9MWWgyT3lVeTRVRnhj?=
 =?utf-8?B?b091L0Q5M2pwSlVLcVVIMGs4em5aRW5lUGRJQ2NRWndtbjRFWW12MUZUYk5q?=
 =?utf-8?B?TStoK1JMazdKUTZNZndGd0lnNENPS3k4VUgwN1BHS3VKd0ZOUkNIRHFaMnN3?=
 =?utf-8?B?bjc2eTErSkp6c2doQmxndHJWUlYrdW5DdHdVQmVxV3A1OHZaMmRjWE1ra3Zq?=
 =?utf-8?B?eTIwc25ZVHEyeGUvdHhsazZDNVNjYmRNdEZMS3haV3pob2w1ajE2L0lNUWIz?=
 =?utf-8?B?YStPQzQ5N3pDVDRBMFNSU1ZJQUtqRWFuNVAwYldlK2x4OUpaNkdRQmM3bXlu?=
 =?utf-8?B?bGw3WXhtRmZFdHYwbDIyOHN2TjhhaC9NUXljNG8zSWVFbkxEeW05V0hRQU5K?=
 =?utf-8?B?RnlBa0hpVGllYU5hc0pqT0NDdGxBQWdFa0lsWGFVOXFsM0dSRy9RclVmQVJG?=
 =?utf-8?B?bGpOVnMvZS9vZmoxQnVxODBEOFFRY3MyMnRmdEtqaFZPM1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z014a2dOVkhIZ3ZiTG10UlgyUHhLRWZFT29hOTlmRWZqYW1Oa2ZvSkxHUlQ0?=
 =?utf-8?B?Q011VFRKQW9BOGxuTStzRitVUjQ5dUkzMzQ5L1I1NHUzTERYNUt4WW9maVVW?=
 =?utf-8?B?blNLTS9iTlVNQWhSNnh1WFBtbUo3eG1BS1Fia1lvbm0xdTRZYi9hWFNtVzJT?=
 =?utf-8?B?TGRCak0wSnFwaWVWVlM4V3czdWFGV2RMVFpkWWwzcCtBTlRUQmJSeTEwbHMy?=
 =?utf-8?B?bmxReXl1eklzbnJjWHlma2g3T2tpV05BaHZTODkzbDFTa1paeXhBZjFNZTZo?=
 =?utf-8?B?YmxQdmhlZWg2QlZnTWVpVUc2emh5RnNXb1lXTDk4YURJUC93bE93czBmS1U0?=
 =?utf-8?B?Um5wendLdi9zTk1CaEJ4YXhnSkF4V3JGcVpJdW9hSGpGNEc5dUxRcFcrbXlQ?=
 =?utf-8?B?ZTQ5SURjLzA5eHRTY29JMjM1SkFqcUR0dzRNM2JqUk11Z2cxalpBWThFRWZ4?=
 =?utf-8?B?ZVdwL2xVZVdjMzZacEVjTFhVYTB3L3p0VjhMNGlTMWRJQkJCRkg1Nzkra0s1?=
 =?utf-8?B?RTQ3QmhabTdvMHFxR0cwWi9uRHBEMlZQUTVrMnhHUDI5bG50T1dXUnY5SFgw?=
 =?utf-8?B?Y3NjUWRYQ3QvRGRMSGkvaVRCUHpxUkVYUklKaVM2bTVsbXROWTNBZ3cyRmQ0?=
 =?utf-8?B?MytQTno4ZVNYUWxDQXBVR2xGZHVaWW9NaWxjOXNDR3NONGJmYnFRNGtFanNn?=
 =?utf-8?B?TzlqZkVjbW9qSnRVcDB0ZWltSWdhZEwvQyt4QWV1UHlkR2VNZU9ZV1o4UWw4?=
 =?utf-8?B?RzhvbnJ3WlA1ZzBBaE8vYlUvRGVhUWh1MVR3bUhUUWNWSnVwUzEzZm1rbEpQ?=
 =?utf-8?B?ejhBUVdaV05kUFlpRzRWak11cWtsRWFEN1JVQnUwT0t5ZEF2NG03YU0xNEsw?=
 =?utf-8?B?a2pSOWg3elNQZ1pSbC9VZi93dkFKN1pxa3dWZ2tLRHVJZU8vNEVVdmFMUW82?=
 =?utf-8?B?ODZkTkhCYzFFRVJVdmNLN1YwbUFYUGlWMHRVZU5kZStoeXduelQ0YTZpZ3l3?=
 =?utf-8?B?ZS8xcFA1a3d0WFFueVNMVnhCaEFSL2dXVjAyY2lIdVY5cTEvQ3lraGRZSHFs?=
 =?utf-8?B?blV2NUJxNkFIeWFqNE1aeDluZ1pSMjJ5NkdKWWlYQ2hGQWNHWTFzT3gxb0xU?=
 =?utf-8?B?MGtrWEIxM2pWcUc5eENWMnZCTVRDMDl6NG1BMUt5NU1FN3JMZHNHSEh2STk4?=
 =?utf-8?B?a1JxSnJ0VXlReFgwOHB5dGgyc292WlFYUkFhWlhjNkN0SnNTR2t4T3Y5THFo?=
 =?utf-8?B?Y2c2aGJLSTRWVzVKTEV4SVJQQ28yeWtsUjgxY1hidHpaOGN3VE1uZ1lnMERI?=
 =?utf-8?B?STdqTjFSV3QyN2RLSm9nV0MyQVN6c3JFNkJ5ZnhDZGFkSzg5N3FtSnQ1WlNs?=
 =?utf-8?B?Wm45eHZGNEFiYk5DK0JUZDVUWXNOSXVwK3ZZNTJRcWF1MU9FeHdKUFZiMG5m?=
 =?utf-8?B?b2oxdzE2OXIwT3NQWFJoNkxCWVpaeUprU0NFckdwNVJXWEorYVZzeVBGc3Fp?=
 =?utf-8?B?S2ZtVm1KaXJHT0hKTUVUZHdhYW83ZjQvSnNsb1diOGRiRjNxVG5CSWltMk1S?=
 =?utf-8?B?VnczTjBkYnIyYTVieXVoWWVtT1BCcmo4aW1xMFZ6ZytkTHFzSzNhb1BnTVh0?=
 =?utf-8?B?dkVQSnZNSjRQcFBEVWpzemtiRXRPL2YwQllxYjArTnRVM3lBMUt5MTJ5UkRE?=
 =?utf-8?B?L2JqUkU5THBFQm91L1pwbWVJVHFsa1FwWmpBSjNTMUJUU1lJVHRCTHUrRU1F?=
 =?utf-8?B?clVNM0lFY212QUo3QjJqbWdGbnRsTVVJRDArUmE5SXQ2VDRDRWN2bm5RMk1x?=
 =?utf-8?B?OU1BWlA4dWlOdWhyRi9ORmo2N215ZjVyeHZJUjhMUmo3R3hlRDNncDg5cHBl?=
 =?utf-8?B?RDZHZzNyYlAxL1d1ang1LzlJc29RWGxJUEpzVkRBUkdQTVFGV3N5RHlvN0FS?=
 =?utf-8?B?V1F1MDR6ODdHeWVoVzFacnBXQkIwMU9ESndlYU9vWVQwL3BXVGxkSS9DWExW?=
 =?utf-8?B?MytzMkNDY0FqNytUcFJPRTNsUGpmT2hiWHEwZ0xxR2FkdGx5YTMwRFdOT242?=
 =?utf-8?B?Nm82cGhuUElPa254Rkl3Y3lqanZWL1gzaWNGZjBKUG9peVUzY3RiNUFzK3VL?=
 =?utf-8?B?UVYxTVZ2V1FYdEp1M1EzYXMxYmFrNStndjRBSlBPR1M0NEpOYmVtRE5PTElG?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAC93E25B8C68347830E7465C1CAF4B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7865e314-427a-4a46-9277-08dcd33959c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 14:44:05.2393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2gXh7OymZfPEKImoHI9tPFlC4uXt8qYXzfjiyzJ9ehk8liybqP8Ua1iOPxX1B0BbQo+jPRKOxqPupr7V1tOKFdtg6hBUeWUf8ZRZxU4Om3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDEyOjU0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gIlRE
WCBjYWxscyB0ZHhfdHJhY2soKSBpbiB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKCkgdG8g
ZW5zdXJlDQo+IHByaXZhdGUgRVBUIHdpbGwgYmUgZmx1c2hlZCBvbiB0aGUgbmV4dCBURCBlbnRl
ci4NCj4gTm8gbmVlZCB0byBjYWxsIHRkeF90cmFjaygpIGhlcmUgYWdhaW4gZXZlbiB3aGVuIHRo
aXMgY2FsbGJhY2sgaXMNCj4gYXMgYSByZXN1bHQgb2YgemFwcGluZyBwcml2YXRlIEVQVC4NCj4g
DQo+IER1ZSB0byB0aGUgbGFjayBvZiBjb250ZXh0IHdpdGhpbiB0aGlzIGNhbGxiYWNrIGZ1bmN0
aW9uLCBpdCBjYW5ub3QNCj4gZGV0ZXJtaW5lIHdoaWNoIEVQVCBoYXMgYmVlbiBhZmZlY3RlZCBi
eSB6YXBwaW5nLg0KPiBKdXN0IGludm9rZSBpbnZlcHQoKSBkaXJlY3RseSBoZXJlIHRvIHdvcmsg
Zm9yIGJvdGggc2hhcmVkIEVQVCBhbmQNCj4gcHJpdmF0ZSBFUFQgZm9yIHNpbXBsaWNpdHkuIg0K
DQpZZXMsIEkgdGhpbmsgYWdyZWUgdGhpcyBpcyBiZXR0ZXIuDQo=

