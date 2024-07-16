Return-Path: <kvm+bounces-21736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FF7933376
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 23:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21F7D1C216F0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 21:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B7513E41A;
	Tue, 16 Jul 2024 21:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NGoAQnCk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F3770E2;
	Tue, 16 Jul 2024 21:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721164458; cv=fail; b=OZV7pvbBDMFFXbBWMSGEeYsjBQ+OnM2vUUvRh3gt4p8xMIXUJVqlJg4FHHnNi/oX7xC0Mj2+asNxlyOgwiJ7zXmC2kBRCwMVdAXP7NkWj2Nj6vshuCq5V1i8FRtl1cJvfklNDWdyK3W5O2TDLsEdGvviU6pgyRRvzVmZxwdtxF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721164458; c=relaxed/simple;
	bh=wD5+XL/qVccIkmi2178i/V6ebiuQBdPJy4HgLihpWks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l6ajclTVT/J0WGoCOLv3Rk2G5r5rmTD/7fKQLvGTngfMRHx2hcuVFqvJd2JfV/rAIpD5xGFXHRFEWttcNidGTJ/pdWgUlubwuaPdgUBDA6WnpP3nNA0kDV9dw8zAqlV5lusa8svk63Entpua7rLpUIDRXmMrM0DnFDw7EJh9gu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NGoAQnCk; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721164456; x=1752700456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wD5+XL/qVccIkmi2178i/V6ebiuQBdPJy4HgLihpWks=;
  b=NGoAQnCkNnD8HIlTRUbHSMVl/D61/jnOyPHAs2rmtJS9ejpn7IV4vY4B
   51aUEtwjyDMIQOUfAK9b2X0qJOF8+/eKIxCJLy6tp/YVVgL9IWtCCVrJP
   h8yrd9y2XC1Al9KaM53Jk2fpK1zXYH/W3QWE44dgFQ62adsLL5aiLjHEV
   WSc/hB7B6PEI8mUTZNLJxdAKSHyKJW9gm5j/kTeCqQsLMr10xWPbenpJM
   fjIppm4RtDCynJ11zSKHTvq3Z/qCmm2FKPBWkffqZ1IO8adG/sMP6ibl5
   /ehtu1SI8RfXmeBpoVDfHO3H/VIgcvG/7YtoR9vdBK6MSL/tOWEdPk8Vh
   Q==;
X-CSE-ConnectionGUID: vq1j/aDKTYqNctuA/Dvz0Q==
X-CSE-MsgGUID: tW3sjxUrT9OsuJyfH+uCHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="36178158"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="36178158"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 14:14:15 -0700
X-CSE-ConnectionGUID: qi9QmcYvR/+q7Qi47Gr6VA==
X-CSE-MsgGUID: 3IYlqNX7RBqI2YgDYM9egg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50739094"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jul 2024 14:14:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 16 Jul 2024 14:14:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 16 Jul 2024 14:14:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 16 Jul 2024 14:14:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 16 Jul 2024 14:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYwAKQxn3tHARm063X1v64+OiQefJbzni340QKo9LxY81acAX0cj2HQFLIfDf4ZEPw6UrNaWXQlCsl1vNfcwQcmaMo3qbPIW7elmtw64CJmC5YTGZN0DznCJxUUMH3K16OiGAY19BW+Wjgga8UkBhHoccAE5elIvkjyJQahuT2au2+7NXUryT4gBxIxU6sOCl+/DPlfvfK5sDMVhCert31O/q+nDe2KIOI6f8vsY2ddfHioVUOLtpFgJBo6UFZ1CvPS81Z5jkGr45XNXCOQrE6Ngj5njdOSL7XAA4gfM+LPA28amViGPCrDLPICXl1g8z727o/z/bpaHf5Xqveyshw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wD5+XL/qVccIkmi2178i/V6ebiuQBdPJy4HgLihpWks=;
 b=ttT0/2EXHXuKGzZiPaacPWkShnOg3mHZEmXGZm53kdg697XRtMifp/g9NC9InBDGl1l6NnCn+BB2NxhW8KPp3gLWokTpUtuRqQ+d2jcHjTCVKMFttt4+ruxJ5ne3dRwRpVNPCO84/zGCLi+yXVcgutdI9Y26Wnsg2uoxk5ACo4855qASVFlhvPcwWcSxY0DreDqg5rVDThbYYXKoxPqwOpAAaIc8j2FcnHGo4k28Jfh2MvJ+pNuuP9wl/Qe+QU+jczwsHk4bHjtLJNhwIIdSwhkBlC0JTU9Yfyrga2mU0HJ5j/ippSIuC29TvQIwHmfzFeCpMXJFGofBD4f8cwRpug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 16 Jul
 2024 21:14:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 21:14:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Topic: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Index: AQHa1x52SQHDcx1NlUy5OEbh4zbwNLH5v2EAgAAcjYA=
Date: Tue, 16 Jul 2024 21:14:06 +0000
Message-ID: <2b3e7111f6d7caffe6477a0a7da5edb5050079f7.camel@intel.com>
References: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
	 <ZpbKqG_ZhCWxl-Fc@google.com>
In-Reply-To: <ZpbKqG_ZhCWxl-Fc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5008:EE_
x-ms-office365-filtering-correlation-id: 769c39ea-a848-4512-7b91-08dca5dc3a18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUFkc2N2QXl3MFdSLytEaDE0cmR4aU1hK3A4SE1JRFRobENDbm5hYTA4SUtz?=
 =?utf-8?B?RU5oV0RRZy8xY1RkeGV2WTN1RGw4Rk0weGtrU2VqOERhNkljUFRmcmR5RnNu?=
 =?utf-8?B?a2JCTWdlNnFkZDU0US82ZDNZRUdtWjBDaGFUZEpTYWp5UWo3dEhUb0dLQm1S?=
 =?utf-8?B?M1NnWkEwNjAvNXprZWQwUGRLOXczREI0NU85dXR1N05FZkRySXNVOW5Id3Rt?=
 =?utf-8?B?ZWt5YUNtcThKWDhuTkNLNFc5bEZDaFJtOVVSbkZ5RFBIbitmZU9PWlJrVkZw?=
 =?utf-8?B?dlNDcGRQd2tneXVnS2J1VWNBdVV6akhHYy9lSitkRHZoZmRuYlhIQWh3K3Bo?=
 =?utf-8?B?NW9rVG1veDFyM1pNTWhwRUZmdVAybzNiVWF4b3B5VnBaeDZNSjMxNS9Xc3Iz?=
 =?utf-8?B?VWRkTzEwTlAzQWdvQXRqbmJBVGlhT2xrM1FnUlk2ZnRoVWtqSHowcVpQQ0V0?=
 =?utf-8?B?K1V0NFR1emJBSERQczM1OUpWTVd5bDBLNE5RcVMraFNzbDIyTnFKeEZzWFMw?=
 =?utf-8?B?dzBsZXFlczVNeG5XRTdjakVNWTJEb1lkVU9iQXM2ZmFPbmsyTmRaZXVwSlVm?=
 =?utf-8?B?a0RtZjJjeFdsOU92MEk4T0NsSzQzUE54QmlhYmNua3dZNFF5S3RPcmVQQ0s2?=
 =?utf-8?B?bU5nRU1UMlRYZGFLdzNaVnM5dE1yby9kWjBuNXFFNGRFS2htOHV4czBMRlow?=
 =?utf-8?B?czJaRDNaTEFsbUR1R1VseUc5Njg1Y3JEbU1Ka1dEczVsaXpFdlNaenlKVnQ2?=
 =?utf-8?B?OXREU2huWnNPUFF3cUx4RFdhYzJ2TjRSQmJnV0Z2NkM1ZVdGdE8vRFhmQ0ow?=
 =?utf-8?B?alJkUnlQQlMwc2FmMjVINzBEK0pFcWovNWpUc3R3ek9EcjVtd01YVEFTZUNK?=
 =?utf-8?B?Nll2UnE2TlllSHc2cmlMRGFEd0RHeWNVNlJsOVo0MFBWd0NLd1FtSklBVmZ3?=
 =?utf-8?B?ajc0amhzMGxzcWxSYWtuNWhNeG1SOUFEcFVubDVjWEJUM2pLeC9McXpxN1VV?=
 =?utf-8?B?d3lROEg0bG92bUVka1RrR0VPWStDMG1hL2FoOU1WUHVkV0RyV0JOTFhxcFRV?=
 =?utf-8?B?Um1rcEdzb1QyeW1EZWMxWEVZME9KelZHRUZBeENwcFdzY3hxeTBVWUJOc043?=
 =?utf-8?B?QjhmNFpNNHVmQXQxVDdEc0xHNXYxQWtyNXhzQ0lLQkI4QmVDRVpzMHh3RHlW?=
 =?utf-8?B?bWRXbEtudENOUEVrcE81ZWNtcHZxL3ppa1JpZVVlc2Z4eFFHNkZLY2Z0NWtU?=
 =?utf-8?B?UUNmdTRmVmV2RWgrYUx0ZXVLc2J0TEdXR2xGcTRtWC9mL0FEb1o0Z2hxZm5B?=
 =?utf-8?B?eVFETGVFWjAzcU5YU2s3MmNXQVBEK3JDbEVUWnRnRGRnYkRXSDFHTUkyRlA3?=
 =?utf-8?B?OXM5MUVKWkk0d0pXMDZWM01qSVY4L0Nqdkp2QTkvV2p5ekhjZUF1cWM5U1VW?=
 =?utf-8?B?SGIvMlR3cXJHUXExZkIrZ2Z3bjlQTW9KS0JBemxFMzdBV0VnSUtFVmpTeWxN?=
 =?utf-8?B?ZkZZaExVanJZaWo2Vk5TRDBPV0dmbVFTRkdOSFF3aDNENHpzaTJFWHQwdm83?=
 =?utf-8?B?R3kwbWhud0t5S3Z5RGdPTGt3THF5ZEFsT1ZVUFJEZ2tZSnAwRmJCOTBwVGZ5?=
 =?utf-8?B?ZEJBVWFiU2xlMTBIZ1dYZkNZaDkyaGNMNG9Rck83WHdHRy9CeHBKbDVGOTF5?=
 =?utf-8?B?UmVNRi9HZGVVcFFjWFhlMGt6WDg4Ull0Nmd5dE1WeTFpUE4zMGx6WVh3d0hN?=
 =?utf-8?B?ZURXNDRmNUFOSG41RHhyRE1vYnFUalRuQ3BJbW9SSzdqdTdLOGx3c1NyWUpj?=
 =?utf-8?B?MFVVa1pLaEJoaDljTlkwN2pIeFRJNXE1aEZMZ1V0Q0ZFSE41NVg0Wm5taXFC?=
 =?utf-8?B?bzJMZEowNnJjYVMrV0hhMGRXejJyNlZTWEFhUENTWEFsRWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFM2em9NeXhkbHF3eUZrcW5DdTlHcUExdVU5NU9XYWJIYWdDcDUxK3FsdEpx?=
 =?utf-8?B?UTZ4UkZuREJTT2xTU0RzYWF6RmhPa1lhcXlpTjhPZE04UWdva1FubFR6MWJU?=
 =?utf-8?B?SDY0b1ZpOWJJVlhHa0dGdmU2WFFCUjlhMXQxVFRjZUlwVDRyY2ZIbk1BRjY5?=
 =?utf-8?B?TzEwTUlCejhhM0hGVi9SQlh3bzJwWlNxSmEvaTBYbWloR0doeFdzT2lEZko4?=
 =?utf-8?B?Tm5haThwMGcyczB5c2xwam4xemZvZEplc3Z0T2VueFhnZTJEN0N3MTM0dmJ5?=
 =?utf-8?B?VHJlejlEOG1BdWcvZWRMLy9teFJRLzFReG5jUVhXaDdNZ1h3amNTYjBUM2cv?=
 =?utf-8?B?Nk5Fei9LbnVCcHR3ZGprTGpKdU5oUDZRYW9XSnZGeStPc3ZPVHpmK25maE5P?=
 =?utf-8?B?MEtXenVleExyUmZrUmo4SU9COFhrWDR0RmNuK3d2K3lhblVWQTVJdHNhdGZY?=
 =?utf-8?B?QmFuUjNGQ0Q1NllxUkYyczRYd2FodHI4UVV4S1ZKd0RDU2VMYkhrUGV5MXhU?=
 =?utf-8?B?QTZuRC9SNGR2OHlBYVFwamIyaEN0RHlXdVR4NE9tUzYyTjV5S2MrRHJtRTRm?=
 =?utf-8?B?bHVWQXRoTTJGZjRBS2xoL1RCZTRaWSs1OEJlSlRVMURQTXc3NzNZL1R4M0Nr?=
 =?utf-8?B?ZVhMRGxCWG04NWJ3ZnRnbXA0cFRQdUFJbDlZY0VVTFBWQktUSDgyTEpZc0Zr?=
 =?utf-8?B?VXVYU0U2WktPdXZuNmp4MFBFc05GRUNtalpXcVE4MWZ6RFd6VWEwQXFoL282?=
 =?utf-8?B?NUhxMTN1OE5tMlR3N0pkVnUxQXRieWZ0S0lydFEwL1lMcVozUHB5UTZ0Y25B?=
 =?utf-8?B?b0p2YlRROTh1d3kzbEVvamoyenptYWdJdTNPZmIvdmh2bW9oTHNOMGlZZFR5?=
 =?utf-8?B?dDRUQm9rMUYrck1wS2xQVzNBTUNvRUMzS2ZPTzRrYjF1bzhvc2hMbkxDeWsz?=
 =?utf-8?B?SDJWOVZmVDk0TWgrY1BadmVtNHJWd1BHeitoZWJLSnNtU3dkRnBzakk3MVRK?=
 =?utf-8?B?NnRyVWdrYnpJTXJvRmNQbnM3OWRVWlF3LzhrRTlsVm1WamQ2UzlVZkJGVkpi?=
 =?utf-8?B?aVJxOVp5L1M5YytIMExRZHhPeDZFUWdmNXVkVEpIOTVUTHpwYnNua0l1UEhV?=
 =?utf-8?B?aWptcDg5K2VHODZ1cndqbW9SL3FrZFUrNjRDNmJGMzJCbkduUlZMRXpmMU1z?=
 =?utf-8?B?N1lxZHhqZGhpUXZ6V0hES3k3ZHdPdEYybkw0TmZIalVUOVF4ckIxaFBpUjl0?=
 =?utf-8?B?NVl0ZE9kdWl4OHpKUmZlWWwzcjk5Q0lmLzZhK1BaNTVmNTBrUTlkTFNuTURy?=
 =?utf-8?B?Y3V4MmdDTEJaSkFEb3p5aThlYWdZYU1BVWpmVjdSZU85Sml5OWJLTndSeFdK?=
 =?utf-8?B?aUFPKzNLdzRJeGdCRjluMDZjU2h6R296OUpGdHpNdHFsLzFlMWxoQ1lQZkZV?=
 =?utf-8?B?TDhCNUFyTjJwQi9qQXgveHRsNG1JNTZZblhBMC9kTW9zVWdrbk5GNXBoYlRh?=
 =?utf-8?B?bGx3MVRtY0JrUkd4bTRoTGpwRS9ibGNaaWdKZHFQU0tybTFoVE1qTlpHdFUv?=
 =?utf-8?B?ejVzd2pwWGc0a3VkSVlOcjlQNTlrZXdPaEFDbmZoK2RzQmtkNzBjSjcxMjhw?=
 =?utf-8?B?WmpWcGlnT3FLdnVmTEtDQjVvZy9wK1krMkxmb2dhM3NQUVoydDREYit3ZlZu?=
 =?utf-8?B?VmV1aFBQdTc4YTVGN2VJZVYvY0d3OVJhK2dMYjZrVmFoeGpZWlZjNllPbkhI?=
 =?utf-8?B?ZEFpQVhjUU5JNE5Dd2o0YWU0di9PcTJ2MTZ3azgxeTNkSWJMdzRnb0t3ZXFX?=
 =?utf-8?B?RThCRGVNRGdDZFNEU2Z5d09kc0RWVlIyRndOVjQ1WUhWRjkraHdwTjVJQjhy?=
 =?utf-8?B?T2Z0cytVeWRmOUFGWndXUDVwVjBCRm9SWWFMNHVSVS9uVVpyODhsNXNGd21s?=
 =?utf-8?B?YlBJS2NscVdDVGdpU09xb2xmcE82ZC9NWm4vOG9ZR0NZOWdVaEcwMFY4WmZ0?=
 =?utf-8?B?UjhOcEhkWEdJaXZueUZCN2VISEZvM1NwV1lISWhXb1hMWkN4ODBIYldnZkpY?=
 =?utf-8?B?c2g2cm02TmNYcDkwT084emJVUlYxMFdQSmt2dFJRVzdZMzJhU0lweTRtUWFQ?=
 =?utf-8?B?UVhudWFTUVphRjV5Z3ZjQTJ5eXBQUjhOMUNRTE9WWjU4dERxTThiMUdqRzJx?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <603C03EE8249FE42BBB6BE7D982BF2ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769c39ea-a848-4512-7b91-08dca5dc3a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2024 21:14:06.5607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZ6RLjstZ5X6GBPScP++t8ZbSeRkNbaOQL7ZtxqFtfTnJ2qKXPjxxq9MLrXsu8DHUtZVbvhn5hvrAxDeT5LpcXBBiU1vml+tIKgvJsHOV4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5008
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA3LTE2IGF0IDEyOjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gTm8sIGl0IG1vc3QgZGVmaW5pdGVseSBpcyBub3QgbW9yZSBjb3JyZWN0LsKg
IFRoZXJlIGlzIGFic29sdXRlbHkgbm8gaXNzdWUNCj4gemFwcGluZw0KPiBTUFRFcyB0aGF0IHNo
b3VsZCBuZXZlciBleGlzdC7CoCBJbiBmYWN0LCByZXN0cmljdGluZyB0aGUgemFwcGluZyBwYXRo
IGlzIGZhcg0KPiBtb3JlDQo+IGxpa2VseSB0byAqY2F1c2UqIGNvcnJlY3RuZXNzIGlzc3Vlcywg
ZS5nLiBzZWUgDQo+IA0KPiDCoCA1MjRhMWU0ZTM4MWYgKCJLVk06IHg4Ni9tbXU6IERvbid0IGxl
YWsgbm9uLWxlYWYgU1BURXMgd2hlbiB6YXBwaW5nIGFsbA0KPiBTUFRFcyIpDQo+IMKgIDg2OTMx
ZmY3MjA3YiAoIktWTTogeDg2L21tdTogRG8gbm90IGNyZWF0ZSBTUFRFcyBmb3IgR0ZOcyB0aGF0
IGV4Y2VlZA0KPiBob3N0Lk1BWFBIWUFERFIiKQ0KDQpUaGUgdHlwZSBvZiBjb3JyZWN0bmVzcyB0
aGlzIHdhcyBnb2luZyBmb3Igd2FzIGFyb3VuZCB0aGUgbmV3IHRyZWF0bWVudCBvZiBHRk5zDQpu
b3QgaGF2aW5nIHRoZSBzaGFyZWQvYWxpYXMgYml0LiBBcyB5b3Uga25vdyBpdCBjYW4gZ2V0IGNv
bmZ1c2luZyB3aGljaA0KdmFyaWFibGVzIGhhdmUgdGhlc2UgYml0cyBhbmQgd2hpY2ggaGF2ZSB0
aGVtIHN0cmlwcGVkLiBQYXJ0IG9mIHRoZSByZWNlbnQgTU1VDQp3b3JrIGludm9sdmVkIG1ha2lu
ZyBzdXJlIGF0IGxlYXN0IEdGTidzIGRpZG4ndCBjb250YWluIHRoZSBzaGFyZWQgYml0Lg0KDQpU
aGVuIGluIFREUCBNTVUgd2hlcmUgaXQgaXRlcmF0ZXMgZnJvbSBzdGFydCB0byBlbmQsIGZvciBl
eGFtcGxlOg0Kc3RhdGljIGJvb2wgdGRwX21tdV96YXBfbGVhZnMoc3RydWN0IGt2bSAqa3ZtLCBz
dHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290LA0KCQkJICAgICAgZ2ZuX3Qgc3RhcnQsIGdmbl90IGVu
ZCwgYm9vbCBjYW5feWllbGQsIGJvb2wNCmZsdXNoKQ0Kew0KCXN0cnVjdCB0ZHBfaXRlciBpdGVy
Ow0KDQoJZW5kID0gbWluKGVuZCwgdGRwX21tdV9tYXhfZ2ZuX2V4Y2x1c2l2ZSgpKTsNCg0KCWxv
Y2tkZXBfYXNzZXJ0X2hlbGRfd3JpdGUoJmt2bS0+bW11X2xvY2spOw0KDQoJcmN1X3JlYWRfbG9j
aygpOw0KDQoJZm9yX2VhY2hfdGRwX3B0ZV9taW5fbGV2ZWwoaXRlciwga3ZtLCByb290LCBQR19M
RVZFTF80Sywgc3RhcnQsIGVuZCkgew0KCQlpZiAoY2FuX3lpZWxkICYmDQoJCSAgICB0ZHBfbW11
X2l0ZXJfY29uZF9yZXNjaGVkKGt2bSwgJml0ZXIsIGZsdXNoLCBmYWxzZSkpIHsNCgkJCWZsdXNo
ID0gZmFsc2U7DQoJCQljb250aW51ZTsNCgkJfQ0KLi4uDQoNClRoZSBtYXRoIGdldHMgYSBiaXQg
Y29uZnVzZWQuIEZvciB0aGUgcHJpdmF0ZS9taXJyb3Igcm9vdCwgc3RhcnQgd2lsbCBiZWdpbiBh
dA0KMCwgYW5kIGl0ZXJhdGUgdG8gYSByYW5nZSB0aGF0IGluY2x1ZGVzIHRoZSBzaGFyZWQgYml0
LiBObyBmdW5jdGlvbmFsIHByb2JsZW0NCmJlY2F1c2Ugd2UgYXJlIHphcHBpbmcgdGhpbmdzIHRo
YXQgc2hvdWxkbid0IGJlIHNldC4gQnV0IGl0IG1lYW5zIHRoZSAnZ2ZuJyBoYXMNCnRoZSBiaXQg
cG9zaXRpb24gb2YgdGhlIHNoYXJlZCBiaXQgc2V0LiBBbHRob3VnaCBpdCBpcyBub3QgYWN0aW5n
IGFzIHRoZSBzaGFyZWQNCmJpdCBpbiB0aGlzIGNhc2UsIGp1c3QgYW4gb3V0IG9mIHJhbmdlIGJp
dC4NCg0KRm9yIHRoZSBzaGFyZWQvZGlyZWN0IHJvb3QsIGl0IHdpbGwgaXRlcmF0ZSBmcm9tIChz
aGFyZWRfYml0IHwgMCkgdG8gKHNoYXJlZF9iaXQNCnwgbWF4X2dmbikuIFNvIHdoZXJlIHRoZSBt
aXJyb3Igcm9vdCBpdGVyYXRlcyB0aHJvdWdoIHRoZSB3aG9sZSByYW5nZSwgdGhlDQpzaGFyZWQg
Y2FzZSBza2lwcyBpdCBpbiB0aGUgY3VycmVudCBjb2RlIGFueXdheS4NCg0KQW5kIHRoZW4gdGhl
IGZhY3QgdGhhdCB0aGUgY29kZSBhbHJlYWR5IHRha2VzIGNhcmUgaGVyZSB0byBhdm9pZCB6YXBw
aW5nIG92ZXINCnJhbmdlcyB0aGF0IGV4Y2VlZCB0aGUgbWF4IGdmbi4NCg0KU28gaXQncyBhIGJp
dCBhc3ltbWV0cmljLCBhbmQganVzdCBvdmVyYWxsIHdlaXJkLiBXZSBhcmUgd2VpZ2hpbmcgZnVu
Y3Rpb25hbA0KY29ycmVjdG5lc3MgcmlzayB3aXRoIGtub3duIGNvZGUgd2VpcmRuZXNzLiBNeSBp
bmNsaW5hdGlvbiB3YXMgdG8gdHJ5IHRvIHJlZHVjZQ0KdGhlIHBsYWNlcyB3aGVyZSBURFggTU1V
IG5lZWRzIHBhdGhzIGhhcHBlbiB0byB3b3JrIGZvciBzdWJ0bGUgcmVhc29ucyBmb3IgdGhlDQpj
b3N0IG9mIHRoZSBWTSBmaWVsZC4gSSB0aGluayBJIHN0aWxsIGxlYW4gdGhhdCB3YXksIGJ1dCBu
b3QgYSBzdHJvbmcgb3Bpbmlvbi4NCg0KPiANCj4gQ3JlYXRpbmcgU1BURXMgaXMgYSBkaWZmZXJl
bnQgbWF0dGVyLCBidXQgdW5sZXNzIEknbSBtaXNzaW5nIHNvbWV0aGluZywgdGhlDQo+IG9ubHkN
Cj4gcGF0aCB0aGF0IF9uZWVkc18gdG8gYmUgdXBkYXRlZCBpcyBrdm1fYXJjaF9wcmVwYXJlX21l
bW9yeV9yZWdpb24oKSwgdG8NCj4gZGlzYWxsb3cNCj4gYWxpYXNlZCBtZW1zbG90cy4NCj4gDQo+
IEkgYXNzdW1lIFREWCB3aWxsIHN0cmlwIHRoZSBzaGFyZWQgYml0IGZyb20gZmF1bHQtPmdmbiwg
YW5kIHNob3ZlIGl0IGJhY2sgaW4NCj4gd2hlbg0KPiBjcmVhdGluZyBNTUlPIFNQVEVzIGluIHRo
ZSBzaGFyZWQgRVBUIHBhZ2UgdGFibGVzLg0KPiANCj4gV2h5IGNhbid0IHdlIHNpbXBseSBkbzoN
Cg0KU2VlbXMgb2suIEl0J3Mgbm90IGRpc3NpbWlsYXIgdG8gd2hhdCB0aGlzIHBhdGNoIGRvZXMg
Zm9yIG1lbXNsb3RzLiBGb3IgdGhlDQpmYXVsdCBwYXRoIGNoZWNrLCBpdCBpcyBjYXRjaGluZyBz
b21ldGhpbmcgdGhhdCA4NjkzMWZmNzIwN2IgKCJLVk06IHg4Ni9tbXU6IERvDQpub3QgY3JlYXRl
IFNQVEVzIGZvciBHRk5zIHRoYXQgZXhjZWVkIGhvc3QuTUFYUEhZQUREUiIpIHNheXMgbm90IHRv
IHdvcnJ5IGFib3V0Lg0KQnV0IG1heWJlIHRoYXQgY2FsY3VsdXMgY2hhbmdlcyB3aXRoIHRoZSBU
RFggbW9kdWxlIGluIHRoZSBsb29wLg0KDQpXZSBhbHNvIHNob3VsZCBiZSBvayBmdW5jdGlvbmFs
bHkgd2l0aG91dCBlaXRoZXIuDQo=

