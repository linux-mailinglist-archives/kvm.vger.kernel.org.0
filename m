Return-Path: <kvm+bounces-71446-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCFCKojem2mu8gMAu9opvQ
	(envelope-from <kvm+bounces-71446-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 05:58:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 287A8171D51
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 05:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 959B13031CC2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 04:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 147DD3446D3;
	Mon, 23 Feb 2026 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cvY3Q2Fg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B61F3446C2;
	Mon, 23 Feb 2026 04:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771822699; cv=fail; b=eWeCNiUNjXmnqj40olUdS9K3gaNiHInLgvwzKAqgVfdOEPVPn5VJU5T4A6Yxz7u62HQY/8DkVXNWZSP6jZq8Feh1bDrp8hhGWT4oTrpR0PKig9FFlHwu232JCtclLRLJy83HeRG4GQtrC4NqfOEsrUmhyWCsESKk/aGZH7RNBKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771822699; c=relaxed/simple;
	bh=wino00SBnz2+hY4gfcSxrsSjo8lrvIWUnMeU+aL9B1c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nzxiOF4JmFby1ZKiMjn4kvndo+lWbbmOlmFB/fQBy9imZoCNqzglcDxJ/cqUCtqQAHEe5cP5YX/77+uXR43tm4Y6iEjgA7WGAnX0BSyOKvFMaSydwTfO6miHhA14upcsTPr1NRslcVQo2cnZTk+zodhIvHC9ZernUnUDpAlIN/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cvY3Q2Fg; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771822696; x=1803358696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wino00SBnz2+hY4gfcSxrsSjo8lrvIWUnMeU+aL9B1c=;
  b=cvY3Q2FgGOLyHuOcF1FY6EHHPokZDccs1QCv6Di2vOAI8xAxgp8c9ryw
   ZUmfrxn9ni/7AmD4Bp7JItI1OjRn1jFelMNgCuJcF4wEyvMxlCvIOI3PI
   bdCST6TWpJE9GZuU5Riuvy8ngM1YEUmBD2nU2Vzt2tms0p87NFUAGmh5D
   dMK3uFgyLNsLmiFPYs9meZqWLHIbdU2umgoXOIJ4ErU/oDR/1rT7TpVzT
   SPIanCxBfn83+fiR8DwQi7whjSha7ZjPLN7ppnHE0HCB8xxMh66AxNqPH
   O8XRClOkG3uKkJUHLXe1cFUjx+UsDtjt/FEqUxKFBWIKUg1iKt5zm/W6i
   A==;
X-CSE-ConnectionGUID: KYbqSQtDRaKhVBiQNO56OA==
X-CSE-MsgGUID: lz8q+DmWT+GkfIdSMBhHyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11709"; a="90219864"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="90219864"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 20:58:16 -0800
X-CSE-ConnectionGUID: XHI9TYmCT7uPzZTBr8LMAw==
X-CSE-MsgGUID: 4UN+NbT2SqKfm2J3WeDrSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="243660483"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 20:58:15 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 22 Feb 2026 20:58:14 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 22 Feb 2026 20:58:14 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 22 Feb 2026 20:58:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkR9EJbUN7SysmaqlItJrfHxhTqIino8An4uEWilpBdWrM8hvS0DFQ2+W9IWSeOTcRL1nSKlN4RPQVpP4ZikEgTd9ZXHTgUGXwS3a7Zi/EdMpN+n2TjBHOHRGk7/o5DRb4uqXv5qLHUOe5W4YDUzOaoRoInj3MUdqKXPq/CsM0MTK+wOlprDycBpun5efMLX7vIQPMPy54RpL0Wy3but58/76necBhCJIqy8ZG52vMcknsFaTEs3ENPbbzdVre8WWbWb5SPMDl9GknmFFsW3bLPjOJKQB9m8rQ8CgdLPF1H8VQ00q6XWRgFy3U36eqwe5qu/z6OgsJu32Ko/plo5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wino00SBnz2+hY4gfcSxrsSjo8lrvIWUnMeU+aL9B1c=;
 b=l+EILWIf0RVNAMwfMlXW4k5j3gr7MFcyuIouk9jo5VW9O08rMKPWOmGphNUiX7F0AZWmstaLoYuV4rpCTXZKCxtVp3jo87FMf8/RR+P9JkcaW/FsaJ2iqlkxGJmEpijM3/uUIKI83htcrciAOlE6YOtEwYJOJ64cXDGoGBucsahIfOcYlJwQM9Swi1Y9woU8FJg3GVbMHh3KIgrUrIPWv4kHVWPwTXdUtUq/FHtXUM+D//nb/vqw1XOkj4JDGTiSN/S3VHCRL3l9Zz9DMQ7w3CovCMv1RMc/0pTwdi+gzltbW7llrJK8kmA3H9RpVXgdsKLkS2HaRteomDEPx8pMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 04:58:11 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 04:58:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Thread-Topic: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Thread-Index: AQHcnC0AzpzeR0AdQEeAK1kD2Wd5OLWPyZyA
Date: Mon, 23 Feb 2026 04:58:09 +0000
Message-ID: <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-22-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-22-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|BN9PR11MB5242:EE_
x-ms-office365-filtering-correlation-id: 990ccc4b-0180-4eea-9078-08de7298245c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S3hJcE9qWVo3OTlxUWQzdERvRU0wTnZ5RFhLeXZsVnR1RlJSSDk4MlRWcmw5?=
 =?utf-8?B?U2NrM3NYQmg5OE1zeTJGdXhQUnJMeG51ZVdpU2Zvdy9qM2JaenJMQkhRbWl4?=
 =?utf-8?B?TlU0TmxRUGsvbTd6YzJCM3ZDSzhUMy9pLzdIMkNXM0NxdXdjaWt0S0tVVWdF?=
 =?utf-8?B?UTRLRmJvSGJ5V0xEKzR0YXVUQytjc1YySmlVeit2TkZHMmtFWjBJODdhaEV5?=
 =?utf-8?B?elV6aHYyanJCU21pTXNiR2FTekc2a0dvVWNNYWJqS1ZhSmxCb1NDVWU3bWNw?=
 =?utf-8?B?VWRGWVJYUFJqeEkrMHhHQ1pKWGVmN3VuZkZlSzlMTzUreUszVm1zV1dtd3NU?=
 =?utf-8?B?b01tOU9KY1VRdzdpK2pmZDUvTkJZdmpGRHNyeTU1VmpFakFyNXJqamJhQjA2?=
 =?utf-8?B?N2hZZjZuZy91KzBPbXlCU3BvQTRJYXQ4V1pwekpGcVI1SE9uYVphTTF2elYy?=
 =?utf-8?B?UEFOaEpXamNQVU44L2ZmMk83TUpTalZBeVRYQmVrVFgzcHZoWDVya0p3cThz?=
 =?utf-8?B?U0pOSWpIbVNWSWlZbERvZFd2K01oQno1SHZ2MnNWVlRrdzlXcnRxYlY2ZWxx?=
 =?utf-8?B?ZnZtcDJtU29RRW41eUhRamNTWEZpVFFmVHJxWm1tRi9Rdk5uN3ZiZ3BINytp?=
 =?utf-8?B?c25yTTNGS1lvM1hoMklNbWU4ditKUjBYK1J0Sk92QWM2V3hHWm1PeWpSVzhE?=
 =?utf-8?B?V2FVQ2JwNXZJNnc5M1RleVh0cFlQRnhEWnVPN0J3K0QxUzNNWVpMRlBtMHkv?=
 =?utf-8?B?cENjUVg3YzI5WHJkNVlJdzhyTi96Rmx0ZDMwRk5pcHoySnUvN0pjNTI5S2xa?=
 =?utf-8?B?ZTl0UHh0OURsLzR6cmlLOElQMVluRU9uekMvam8wSURyalVHYnpxMHFSMFNN?=
 =?utf-8?B?SmY3WG80VVpZU0l4VVJDNlp3bUc5V01MeFZBd1BKbCtvNWswQXJwNXpzY0tX?=
 =?utf-8?B?TFhLcXc1ZGRTdEpqcDZ3R3BjQUNPSWI1MUpGV2dpSE9ST01zc1JmOXA2S1d0?=
 =?utf-8?B?aHM5UStIUFNLMTc0R3FpVURDOTFadVh2RFRPOGpCaGdaeDdNckVNNlZVVTRs?=
 =?utf-8?B?aGJWcnRGYmdsaWtxeXRKZk1sc2wraHJYREN0L1VoYlJneGFsb1REWlJGTVFL?=
 =?utf-8?B?b1p0NmpGNFdRdjFiZGNOd005TkZjSThiQXBTckdKQ1JpcHBsSnE5cFZLWHZH?=
 =?utf-8?B?MGNsSXJ2T3A4VkV6bEV0MUdIdlNZcmUzNjJSVlo0bHJUcjdHVU5YRHBWalZh?=
 =?utf-8?B?a1FOZXArWkRkaUhtNVdnOGpmdjNJZ3A3eHVHZEtndjBPdUJJVWdKc1RSNzVG?=
 =?utf-8?B?bVNzbHVRU1V2RFhZYUcwVzdWdVAwNFZoTmlyYVRxMHBTR0FIS3RQTmdjN1RD?=
 =?utf-8?B?OFk3MlZmanNzc2FRMjMvMGtZODhDUjAyak94Rkw2ZGZyUkg5UmYwby9oVGpY?=
 =?utf-8?B?UmNlNnZWVnM2cnhyK1JnbDI2clIrRThPMWVXTDUvZVVtMEVXZXBWRXNTSGZT?=
 =?utf-8?B?SkFqVGtrQzE0SUQ2eGZ2ODNCejl4RGRmMStxMlJkVXhjckRsMHc4enlMSVhm?=
 =?utf-8?B?VGpkOVRGbk05b2JMaVNsT1hsUmZiVGhXQ1ZwN25kTk1GYXJTYndtWExlWXJS?=
 =?utf-8?B?NEFvL21VVHkwd1hnaEoyNEpMOUNxOGQxY2x3Z2o3WGZ4SnJ2VDhtTm5KaVht?=
 =?utf-8?B?cWh2b0haRXhCVE80aW1hV0Q3eS9GWjlrc1U4RFFYQ0grWS95L3RiQk0xWTdh?=
 =?utf-8?B?Lys0OE9LK21RbW5jSDg2UUk4dGlHVzNFUGNncGlKUlNlNU1YblQyaGZtOHpL?=
 =?utf-8?B?STZmb2QzR2RpVzRVR3hzM0hscitZMWtnWU9ZWjN4dW1FTVFuRUxlb1dXSEVy?=
 =?utf-8?B?TVVGNGFJVDU1K29XWFFqSC9iSDVQTU1zVWRsdjMwUHdXaTkyaHFsbVJDdE5z?=
 =?utf-8?B?RTJsb2JXOUtyNUJMU3poUTVtVlozT1BzOWlmNk5uRGZpY3ZuL3JpYXJhcmNi?=
 =?utf-8?B?L3UrSk81a1h1cE5KVUllQzI5Q3c4dTlJYUJSMS84elRwbE8xSVZ3b0ppeFQ4?=
 =?utf-8?B?dGV1aUdkNWlUbnNNZlFscDBIQ0htcTdEckswakxpN3FmQ3gxUHNNTjVFWldY?=
 =?utf-8?B?V2YxNHZqSGpvWWlSMTVab2ZFRFBVQm5GMWFzaG4vNWhRQnhEWk9RRzJzdVFz?=
 =?utf-8?Q?iebYDT/cPXsA527Zrk7QsRQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXFvL3U1aS90NEo4OW5maHZmK1pWTDJ1K09vbzFWVmlmeStiNEhaUm4rRXhF?=
 =?utf-8?B?REl2Tmk5WkJTNlEzVy9wSVp1UmxKVmpsek5BKzBrb0FCakV0UnlHRzdJeGpQ?=
 =?utf-8?B?S1htMWdXbUZlcnNmU2tneS9MS2d1ckgwM3g0Y3VOVnBublJzVEs3RnBHZFNR?=
 =?utf-8?B?THJOTnQrYjhmQ1ZDRlVhY2pLSytDMWRIUEFNaE0zeFlCWWFzWENzSHBrSzlG?=
 =?utf-8?B?SHdDTS9pajFsR1lxWlEyR0VPZ3Z5bUhGd0Rvb0JJVklrVmx3cWh0NWRzS25X?=
 =?utf-8?B?MEZIM1dtRWUwVlAxSE5iNGlBREtQOFBRalNDaEhWTEZ0MkZuZi9oNTRCU1Nq?=
 =?utf-8?B?Z01lY3JKOHhRTDZRY3phckxuRDdqa1JOTWltZEE3QUZMc1FLaEw0WktjSmZz?=
 =?utf-8?B?bDdkUDdlS1gyWGRPT0tnU0VqK015QXlnYzJJOTJLNEVkdlFCZHdQeGRhcFlh?=
 =?utf-8?B?V0M0SktQUFJWcTRGRTYwYUpKcllvQmUzTjUwMkVWVE0xZ0dLVVV1NzJJOW9E?=
 =?utf-8?B?SWxvL2ZwNVJtNXUxSWxkQTl0TkFjSzBZOFpsekxTZE5OR3J5KzRndXN2ajF0?=
 =?utf-8?B?QmdYRnZJRkxnaUozSXpHUXR1TEhoVlAzUjhzUERoV08zWEtzSVpWNjJIK0Np?=
 =?utf-8?B?NWQ1bTh0VGx0QlowVCtPeFY0cUNzSGZuTlpZYlZVbUZhaXhWbit6N0RJazcz?=
 =?utf-8?B?eEVjbG5aM294ZGhsZDVTczQ5RWZ5TEkwWlc2YXoxRTJ5ZTZ5cnIyVWRsWnNl?=
 =?utf-8?B?MnJaY0NLNVFiODBrS0pzUWEyYUVpaFF5TXlJRFBIS2dUL3VGZUFUV0ZqbnFU?=
 =?utf-8?B?QXArcE41ZW9NNmxkV1crZzhaNk9tbW95SnNCSG5GRmJyN3JwMlFyUUVFdmUz?=
 =?utf-8?B?ZTBqWEhpdmtzYU5UKzBJRTY0aTlRU3h5Skt0eGZ3bEovZTgyMno1dWJtZVY5?=
 =?utf-8?B?YXRhSDBLdVkxUkpaUFpXRnl2WHozN0RCM1pBNXFxV2NOODVjalRUN2l2WGRZ?=
 =?utf-8?B?M1Z2VUpJSWxjMHVodDZJWmlwL1hNZUJUMVFiNmlqL29NeG9oQ1IvL1BuSkNN?=
 =?utf-8?B?MTlNMHFDNmY3VGtZM0k5SGdqYUFyYksrMkVnMUZOc2FrNm8vUGw1VjZRTVg5?=
 =?utf-8?B?ZHc3VnNMTHpJMTQyL0FrcDFDQTFuZ1ZXVEc0V0haZmI2dnVWckIwR2trWXl5?=
 =?utf-8?B?anFXKzU2cC9pM2pHQnVzVi9TendrSlhHVlYybVkrL21sUVYxdmxsWWdneUZ4?=
 =?utf-8?B?VzNwZmJBeVA5Yms0ZG5QOHlNUjU5NFNWcUhVTEpGSVpBSW9MSGFsdXd0bENk?=
 =?utf-8?B?emtTNkt5UlBDM1JyeXUwVjVkVEpSMWMwRFFCWWJPck9xOEpaMVZYSlB1cWxm?=
 =?utf-8?B?UHNSQVM4UmJZNmc4VStiazVkTUd2SWlPMDhtS3VnS1prWktibFZObFJEcXdI?=
 =?utf-8?B?aVU4eGo3S0VRRU1uR3pFU3pyZFBqNzI5ODh6K20vZkJBdXFGZVZhbmkxZjZD?=
 =?utf-8?B?Tzg5eS83RmJYaVV5cnJ5djAxNkdadWR6STJuWlhDakZMWVhHZWROeTZiYjVI?=
 =?utf-8?B?dHBCK0kwN2J1ZFZtMWgrYmJRSy8vUUNOYzRaRE8vU3FSOUZ4dEdxYjROUUhv?=
 =?utf-8?B?OCtaWnN4djVSVkpiTG5hVU52MjBaWDZHQmdjc3IxaHVLbk9nanRNNTB1SDFy?=
 =?utf-8?B?bDZoeWNJVG9VTHZPdWFwM3YvdjFBRnVtb2hkUXZTQS84cG1hV1daWkZyaVJX?=
 =?utf-8?B?aHFPM1NSZS9zVGJrZ0RrNjh2eUFEaHdMQTN1ai84bVY0ZE9Td2ErYnZudjFi?=
 =?utf-8?B?NGpNK2ZOWUNGcGtJNGxpU0FHRGxrT1Nrdi93MWU4R2VUbmxXRlA4WktYS2Uv?=
 =?utf-8?B?Tnd5TkpHOWdtL2pRaWRZSDNrWjV1Z2dDcXQ5TzVDYWx5VWNISzFMWjdHdmVY?=
 =?utf-8?B?T09ZZzhDU3hyV2ZpbGJHY1p6VmZDTHlkUEJkMGZUcTN2OTM2STNIOGRaR0FN?=
 =?utf-8?B?aGV3WG95bS9RNnJId25jQ3FkN2o5dzM0VkJsT09oQVU5L042MmpTcVB4aWp3?=
 =?utf-8?B?ZjZkc1hOdHlkYWNDVm8vWFdRUkd0MlBLblhzT1RVVTRDT2o4VWsrL0NNbTkz?=
 =?utf-8?B?M3JsYXd5eEpTa25LUE4wdjJIWW9xQWdPVmZFZkJnbW9MMC9aMnljeUVTVDlV?=
 =?utf-8?B?M3JXeU5aRTErak5CTitZbzM2VXVVaU1MMmVDSE1BUVozcm1pOG5JOWJHOFZ2?=
 =?utf-8?B?ZTZUcHhNdVppNGNzRG5MYXlpaHRlajVxVUh6dVp2VE9kcENTMERBZTJ0QitO?=
 =?utf-8?B?cTR0Z21JQWhJV3FyWXd0dUhDNUNpT1B0akxWdW5uVGNYdXkvSnlkUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D38E05E131CD824A9FB7D8BDECC80596@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990ccc4b-0180-4eea-9078-08de7298245c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 04:58:10.3440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Br4gUxUqbyIAvs7LwPURwPTnPLGkLUtvCyZReK6MXawM4uWsQUJS1Fi2jYLVlmFdqy7EOeZOtLAgxW0ZBritrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71446-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
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
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 287A8171D51
X-Rspamd-Action: no action

PiANCj4gVGhlIFREWCBNb2R1bGUgb2ZmZXJzIHR3byBzb2x1dGlvbnM6DQo+IA0KPiAxLiBBdm9p
ZCB1cGRhdGVzIGR1cmluZyB1cGRhdGUtc2Vuc2l0aXZlIHRpbWVzDQo+IA0KPiAgICBUaGUgaG9z
dCBWTU0gY2FuIGluc3RydWN0IFRESC5TWVMuU0hVVERPV04gdG8gZmFpbCBpZiBhbnkgb2YgdGhl
IFREcw0KPiAgICBhcmUgY3VycmVudGx5IGluIGFueSB1cGRhdGUtc2Vuc2l0aXZlIGNhc2VzLg0K
PiANCj4gMi4gRGV0ZWN0IGluY29tcGF0aWJpbGl0eSBhZnRlciB1cGRhdGVzDQo+IA0KPiAgICBP
biBUREguU1lTLlVQREFURSwgdGhlIGhvc3QgVk1NIGNhbiBjb25maWd1cmUgdGhlIFREWCBNb2R1
bGUgdG8gZGV0ZWN0DQo+ICAgIGFjdHVhbCBpbmNvbXBhdGliaWxpdHkgY2FzZXMuIFRoZSBURFgg
TW9kdWxlIHdpbGwgdGhlbiByZXR1cm4gYSBzcGVjaWFsDQo+ICAgIGVycm9yIHRvIHNpZ25hbCB0
aGUgaW5jb21wYXRpYmlsaXR5LCBhbGxvd2luZyB0aGUgaG9zdCBWTU0gdG8gcmVzdGFydA0KPiAg
ICB0aGUgdXBkYXRlLXNlbnNpdGl2ZSBvcGVyYXRpb25zLg0KPiANCj4gSW1wbGVtZW50IG9wdGlv
biAjMSB0byBmYWlsIHVwZGF0ZXMgaWYgdGhlIGZlYXR1cmUgaXMgYXZhaWxhYmxlLiBBbHNvLA0K
PiBkaXN0aW5ndWlzaCB0aGlzIHVwZGF0ZSBmYWlsdXJlIGZyb20gb3RoZXIgZmFpbHVyZXMgYnkg
cmV0dXJuaW5nIC1FQlVTWSwNCj4gd2hpY2ggd2lsbCBiZSBjb252ZXJ0ZWQgdG8gYSBmaXJtd2Fy
ZSB1cGRhdGUgZXJyb3IgY29kZSBpbmRpY2F0aW5nIHRoYXQgdGhlDQo+IGZpcm13YXJlIGlzIGJ1
c3kuDQo+IA0KPiBPcHRpb25zIGxpa2UgImRvIG5vdGhpbmciIG9yIG9wdGlvbiAjMiBhcmUgbm90
IHZpYWJsZSBbMV0gYmVjYXVzZSB0aGUNCj4gZm9ybWVyIGFsbG93cyBkYW1hZ2UgdG8gcHJvcGFn
YXRlIHRvIG11bHRpcGxlLCBwb3RlbnRpYWxseSB1bmtub3duDQo+IGNvbXBvbmVudHMgKGFkZGlu
ZyBzaWduaWZpY2FudCBjb21wbGV4aXR5IHRvIHRoZSB3aG9sZSBlY29zeXN0ZW0pLCB3aGlsZQ0K
PiB0aGUgbGF0dGVyIG1heSBtYWtlIGV4aXN0aW5nIEtWTSBpb2N0bHMgdW5zdGFibGUuDQo+IA0K
DQpbLi4uXQ0KDQo+ICANCj4gKyNkZWZpbmUgVERYX1NZU19TSFVURE9XTl9BVk9JRF9DT01QQVRf
U0VOU0lUSVZFIEJJVCgxNikNCj4gKw0KPiAgaW50IHRkeF9tb2R1bGVfc2h1dGRvd24odm9pZCkN
Cj4gIHsNCj4gIAlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7fTsNCj4gLQlpbnQgcmV0
LCBjcHU7DQo+ICsJdTY0IHJldDsNCj4gKwlpbnQgY3B1Ow0KPiAgDQo+ICAJLyoNCj4gIAkgKiBT
aHV0IGRvd24gdGhlIFREWCBNb2R1bGUgYW5kIHByZXBhcmUgaGFuZG9mZiBkYXRhIGZvciB0aGUg
bmV4dA0KPiBAQCAtMTE4OSw5ICsxMTkyLDIxIEBAIGludCB0ZHhfbW9kdWxlX3NodXRkb3duKHZv
aWQpDQo+ICAJICogbW9kdWxlcyBhcyBuZXcgbW9kdWxlcyBsaWtlbHkgaGF2ZSBoaWdoZXIgaGFu
ZG9mZiB2ZXJzaW9uLg0KPiAgCSAqLw0KPiAgCWFyZ3MucmN4ID0gdGR4X3N5c2luZm8uaGFuZG9m
Zi5tb2R1bGVfaHY7DQo+IC0JcmV0ID0gc2VhbWNhbGxfcHJlcnIoVERIX1NZU19TSFVURE9XTiwg
JmFyZ3MpOw0KPiAtCWlmIChyZXQpDQo+IC0JCXJldHVybiByZXQ7DQo+ICsNCj4gKwlpZiAodGR4
X3N1cHBvcnRzX3VwZGF0ZV9jb21wYXRpYmlsaXR5KCZ0ZHhfc3lzaW5mbykpDQo+ICsJCWFyZ3Mu
cmN4IHw9IFREWF9TWVNfU0hVVERPV05fQVZPSURfQ09NUEFUX1NFTlNJVElWRTsNCj4gKw0KPiAr
CXJldCA9IHNlYW1jYWxsKFRESF9TWVNfU0hVVERPV04sICZhcmdzKTsNCj4gKw0KPiArCS8qDQo+
ICsJICogUmV0dXJuIC1FQlVTWSB0byBzaWduYWwgdGhhdCB0aGVyZSBpcyBvbmUgb3IgbW9yZSBv
bmdvaW5nIGZsb3dzDQo+ICsJICogd2hpY2ggbWF5IG5vdCBiZSBjb21wYXRpYmxlIHdpdGggYW4g
dXBkYXRlZCBURFggbW9kdWxlLCBzbyB0aGF0DQo+ICsJICogdXNlcnNwYWNlIGNhbiByZXRyeSBv
biB0aGlzIGVycm9yLg0KPiArCSAqLw0KPiArCWlmICgocmV0ICYgVERYX1NFQU1DQUxMX1NUQVRV
U19NQVNLKSA9PSBURFhfVVBEQVRFX0NPTVBBVF9TRU5TSVRJVkUpDQo+ICsJCXJldHVybiAtRUJV
U1k7DQo+ICsJZWxzZSBpZiAocmV0KQ0KPiArCQlyZXR1cm4gLUVJTzsNCj4gDQoNClRoZSBjaGFu
Z2Vsb2cgc2F5cyAiZG9pbmcgbm90aGluZyIgaXNuJ3QgYW4gb3B0aW9uLCBhbmQgd2UgbmVlZCB0
byBkZXBlbmQgb24NClRESC5TWVMuU0hVVERPV04gdG8gY2F0Y2ggc3VjaCBpbmNvbXBhdGliaWxp
dGllcy4NCg0KVG8gbWUgdGhpcyBtZWFucyB3ZSBjYW5ub3Qgc3VwcG9ydCBtb2R1bGUgdXBkYXRl
IGlmIFRESC5TWVMuU0hVVERPV04gZG9lc24ndA0Kc3VwcG9ydCB0aGlzICJBVk9JRF9DT01QQVRf
U0VOU0lUSVZFIiBmZWF0dXJlLCBiZWNhdXNlIHcvbyBpdCB3ZSBjYW5ub3QgdGVsbA0Kd2hldGhl
ciB0aGUgdXBkYXRlIGlzIGhhcHBlbmluZyBkdXJpbmcgYW55IHNlbnNpdGl2ZSBvcGVyYXRpb24u
DQoNCkJ1dCB0aGUgY29kZSBhYm92ZSBwcm9jZWVkcyB0byBUREguU1lTLlNIVVRET1dOIGFueXdh
eSB3aGVuIHRoaXMgZmVhdHVyZQ0KaXNuJ3Qgc3VwcG9ydGVkLiAgSSBkb24ndCB0aGluayB3ZSBz
aG91bGQgZG8gdGhhdD8NCg==

