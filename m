Return-Path: <kvm+bounces-17463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2DBE8C6D48
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 230C31C22192
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8EC15B0F1;
	Wed, 15 May 2024 20:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bh6W4HoW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281942E851;
	Wed, 15 May 2024 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715805177; cv=fail; b=DOmnlzLBk8TurhtLQ4BJAodXBkdQGnJWjtSbwQ7P1IvKzvtC3DlJ7LWbVWDq+o0X9qBRETLjjFnnB323ic3PuCGxiEFy+N04ygVn/P+IiBem/IliCbiUGsci323/h2ztWaKIK14e1w+Dr9w8AOuxcUygkTTyq81uOwrTWyRZudw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715805177; c=relaxed/simple;
	bh=35yn6qdRUAESvbHOzHAebwyEHVdaLNzYeLT5HneHYwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OjW8VrK38K402p9cGNIcJZZ7cipHOHALvY5CBgPvVGYXtsVDp/e64Ug6y7CTxKpUDExWesW3X9CZmx2zD32GEAM1kZj6cq3fxqIDpaeyPedXZ9B1+t6AxbHeujJPGRfMbbzS39MxU38/S35/rwvI4yYoGMI87rX+AyIgJ8v8MYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bh6W4HoW; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715805175; x=1747341175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=35yn6qdRUAESvbHOzHAebwyEHVdaLNzYeLT5HneHYwc=;
  b=bh6W4HoWJuxl99Cq3MOYQzfJ78WCaFDTFhhuB/BOLQKUtfirtMmA7rPR
   XFKwMNXNaC9QSM3ZTtyFyBSKfTb2OpAQ0WzfU1ejJt68h/NMiiQS8gwqo
   y/RjiaLJsKYpvNPlggZwq3N7B5bvdyFG7RNUHUrhOxLJ9lza/FasTuwGW
   ToOzKY2ct5Z4KTC5zm8RiFeH7kI+nWAa3IejoVO5E3XF1DqJTD2IAsUap
   K4GVK+Qo9QBvEeB03d5grFKsJ763euMUMi3WDB8TGeKslGfvog+tCplTw
   dprPZmOMBBn/IOV9hlJmrE1xdQnBL23DW2zR6wbP9UJmBGaioupKTs0JM
   A==;
X-CSE-ConnectionGUID: vxG71Oy1SL+MWGnnT8i0LQ==
X-CSE-MsgGUID: ippOkYRIQ36lMEILSc8rOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15704438"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15704438"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 13:32:54 -0700
X-CSE-ConnectionGUID: B+eGckcuTt6nE+e3Br3QFg==
X-CSE-MsgGUID: cDd4/L1PSIqTXJhE+MoCrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31758272"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 13:32:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 13:32:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 13:32:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 13:32:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 13:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4/9Ny8o6fNp7txS/ku0ZetbrnjD50F0Y8Rm6LGEt3DdmOmumL4/5szqeQydGXV6JOkON/JfAA/zScQw8NAIyyzKNsPrI97uAQJPrle07fYjpU5JiK53A4NppX3UZC4d7rnnSh8QPOiQj/5qpPo+UNYvO8zXBlxzEhOV4IZd1QVIJ2DMakLNq3kAcbZMMUOrewEF4DQHDQ3BjJghLkc7HQiIZd0Fl2BIn3aBhrND32W9vaO/D+vxYYRwsV9eYJuDfz6YdLUcdcsU84rn9A0LXPMtjRbE6eqodc/iF+l/H8lcF7HoDuVfKXwuQl/l0SEuvcPxRyOVKFxChkIxPW8PNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35yn6qdRUAESvbHOzHAebwyEHVdaLNzYeLT5HneHYwc=;
 b=iNHVsLOvAN374/Vrz2U7YGrPSxmnQPOdLJpLndUYS/c8Z6oPV/7X0JNg2+jThBD7Y3px8OF5SQBEwQCjzgkbOIqd68faKcJlmRPRvFOCBY3XYD0uzfZMDph18taA2KZUDZ9VZ7G1j6s+hdqn3VBjdo1hktdEizfFTHVaNChWTcJfpgP9eTwjZQV+8NqulqHXx2GIepP42CTVwriDnvY3VQXhq+zXdVA47JgJzw9aXtUVucm4b2JS6gje5N/pGkCYbY98GOPkdYakNV0XsOYmGjE7lGcgqiXuJM0dCoL7z9NUvSAidGjpTOYY5udzD6tw7dzpceAeAnQwQa3J6e3OfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 20:32:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 20:32:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAAELYCAAAHkgIAAAZ0AgAAC8ICAACCQgIAAA76AgAAX+gCAAAxrgA==
Date: Wed, 15 May 2024 20:32:50 +0000
Message-ID: <72a18e11e09e949e730d01a084ee9f1a94c452ad.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
	 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
	 <ZkTcbPowDSLVgGft@google.com>
	 <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
	 <ZkT4RC_l_F_9Rk-M@google.com>
	 <77ae4629139784e7239ce7c03db2c2db730ab4e9.camel@intel.com>
	 <ZkURaxF57kybgMm0@google.com>
In-Reply-To: <ZkURaxF57kybgMm0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6375:EE_
x-ms-office365-filtering-correlation-id: 0c159dd0-ae72-41bb-06d1-08dc751e30a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MU5oeTVmUGxyd3c5anNoLy9HN001WVRYOVJvM3o0M3VicG9NaDNXMkgwY25O?=
 =?utf-8?B?dEVIeEZyVEhvb3pqSDhlQmVJb3VoNzkxMDlIZUN4bnBuWFN1Q0FyVlhTNXh4?=
 =?utf-8?B?SWNDa0RKbTM4TnArZklnd3RQL0ZwSWtoOHJPbDhUbGhndFY3RFJOUEw3Z1Nx?=
 =?utf-8?B?REk4UXd5OVJ3dGdJSWpMVlNXUm5lekJkWGUreHVMbWw2OFR0TUgvd0tuMFZq?=
 =?utf-8?B?cEVCbGt4UlRnWmppRklDSGUxTmgwS3d1R1RqRmR0VUNaRG9oRm14dHJ3QVRG?=
 =?utf-8?B?NEZVSnpQeU42V2dVdk9GRm5sRE1ZMXpYLzVTYWpQdERUTy9yRXNXcnBwaEd5?=
 =?utf-8?B?VXNoNEZPdmlRRWZMS2s1bWR6VFErV1JuZVJ2d0UwNGxkSGZvNHF6V3A4YTE4?=
 =?utf-8?B?U25ic3p6dzdZbG10blZpZHptN2lCekVzRHFZajhmRWtGbU9Ja1NGYjZ0VVBp?=
 =?utf-8?B?RGxzQ2h1R1Nmcmk1My9JeXptUU1Na05wM0Z3Z0MxVDdtSHNmT2FYdmJiMDdN?=
 =?utf-8?B?TjBDRk12UCthdTdidE0vSExUa3FwamVCczh4QnBpNnRYTlBYOVJWMnlYa1Q1?=
 =?utf-8?B?bGE5R01Rc2JXbTlKSUdYMzYxK0RIYlgyR2tJN0hkNmV6UnNjUUZ0UmhaWmJD?=
 =?utf-8?B?QkRMSXE3Z3E0QVIyRGhKRk5laHA2MmNLY1VGWE9JQXh2SkxUaWdDWk0xcUx4?=
 =?utf-8?B?ZWxGT25qWHNIaElqSEgvYWJ5QS95cW1wYkNPdlpBQU5ITFJhbmxpVDA0WGVm?=
 =?utf-8?B?cnVXM2FzMVluU3JveEdRbDh2aUxQNnpXQXdLUlpUUHlDT2l1K0kveGEvWUVn?=
 =?utf-8?B?OHlWTVk5SzNveHJHZkF2MVM3WTE4LyswWHpLZlUzVFFOa3RrOXVvUGVuenJ5?=
 =?utf-8?B?bGF2Y0R1NG95RzBabDQ5MEdCVzF2b1FCRVBlaVNkT2JxQ0Z6SFEzNExMaWJ6?=
 =?utf-8?B?Z2hGaW5DK3UvOWFyd3A0elpCQW9iMkdYaUdlWGNVT0VmdXNqZkMxK1lkZ3Iz?=
 =?utf-8?B?bUJ2cmNtbzhwdFYxQTd4TGF4UnB0YVZkWEo0YWJEM2ZIRUF2Ujl3QUJ4bTBK?=
 =?utf-8?B?SEZtRDR3TnJWcHNWcjNwYXlDaE8vUXMwM091V2hPT2pRR0ErMzE4WWhvdm9Y?=
 =?utf-8?B?endGU080MWVxbUpsa3RVc3J5MUZHV3RVYXpEUGthWkhWd3BJUTJ0NW9XVS95?=
 =?utf-8?B?SnVpdmhDTnd6Z2lRZmZOL1lRUEFYbGU2aHpldWwyS0JrWnBjY0hVOVViamNX?=
 =?utf-8?B?bnpPb2dBTWs2RmpuOW41YXpVeDVzSTJHK3A4WGFpZjBIQnJTVTQ4bEtGaC9W?=
 =?utf-8?B?R0xOYVZaY3JscHErQTBScnZ4eUVYVzJSWnJiRUk4cHE1QXJkS3dSVFNiUHhR?=
 =?utf-8?B?ZEdndGUxQ2ZCaEJPZEhhRUh5ZTBrTG4wR2Nqb1Q1Wit3K2xHVDJIdVhDTyto?=
 =?utf-8?B?U2IwMjFzMC9QbzZLZTljZnd4dUxBTmNKa2pwbGQ0aUNwc1FZSWxHSHdUeUF2?=
 =?utf-8?B?d0x0UlJTMC9zV3JTSk5XeFUwejRQZno1NkEvSDVvenUxa2tHRzdPVzVsV05I?=
 =?utf-8?B?MlNLNXN2Y0RkRnNnSGZmRHNuWnNISUFHY2VnOE9EVkg0ZTRpSUl0TktBRjBH?=
 =?utf-8?B?Y1RMdmIzTW5ZMnBjbFprVjFHeEdyWVhPQkNoeE91QTV6eHpNT09IMXZtSDVD?=
 =?utf-8?B?bkkycnlhcXV5cFlTWStpUE1rV2EvOUhjdlZDSy9OLzBHRWFVY2Y1TjBWbmZQ?=
 =?utf-8?B?c1NDYUVFOXhHankwcDFzZjFqNGpxblpZV3RENE8wTzR4Wk9wbjllS2NycG00?=
 =?utf-8?B?VEYzUDJEYmdzM3JtdVJ1QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2JJMklqV3FLcGdEaThsTE15VUhiclU1R2JtclFVeGRnQWM2cWVua2lzRDJO?=
 =?utf-8?B?cWluZE1xVnBMa0VzMlAyb2NnejR5YkhGYXdCcW5aMGlzR05ualZLOVdJT1dw?=
 =?utf-8?B?Y0FrbENZN0txNXAxYTRtWUhOSHFwUm9mYm01R0lFcWFZZVU1TGRRNisyOEY0?=
 =?utf-8?B?UFhVM2QwazlkNDR6ZjFDSWNHQXZSdng1dURteTFkTjR5MlA1SHVEdU9xOVBi?=
 =?utf-8?B?VCtLUFBSNjYrbzcwdkFNRTF4cE1pdC9JS2NjWWFmVEJpYk4xU2hjbGpOMENK?=
 =?utf-8?B?VGFvZnNWR3N0SDdIeFpVV1V3ZjVHbzh4WWZJdThvUGhkTWVvQVRFQ0IvQU5M?=
 =?utf-8?B?eUpLVjlrRXFhWDlkWlNHVFhJVXRPSGh2akpJTENBMW0zdHBndHFLWGJWelpI?=
 =?utf-8?B?Uy9hQStodm1sb1FJaUFQSjRlOHNxT2FVZE9YTVdlOW12NVduaXoyU29ySVVO?=
 =?utf-8?B?NTZVMmZLUlZlNzhtRmh2SDNUZWN3R2ZkYVlHRkI4cUlLVXpqNlFMTzIwM3Yx?=
 =?utf-8?B?dythYnFuZFVEWjdyblRWYUV4ejZEeHZSTlJZVzhkMWloKzh0dTRPUHQ3dTJr?=
 =?utf-8?B?N2w3emp5R3F0cDJKTU4rWC8weG9vbDVJejRkRU5VbDFVd1NmcnU2a0RtZmdp?=
 =?utf-8?B?RTFoeTFxeTdsTW5uMG5peHVVUkVWbmZWaGd5RTNDZnV0SmFZRTdIZnV4Vks5?=
 =?utf-8?B?Rmpiaitka0pvUUI1b09RdFVIaW9TMEZMSTZkMFBSTExqRjFndXlGUmxOSjBU?=
 =?utf-8?B?eVBKRTJiYVByZWVoM0hSQzBhQncxU2hHMGx0bmhwU2ZHNmtVSE1BMXJUazRm?=
 =?utf-8?B?VkE0QzBoWjMxaXk2VENKbXMzdGpKbVNOVzdJemMva0UyajcrUDJ3cENVemJ3?=
 =?utf-8?B?UEFJWFdhRlB4Z1pSUjU1b1d5WmlLbVplKzRMRm1rekRwM1pzMTBldU9rSWt5?=
 =?utf-8?B?bVY0TjVaRmJ0Z240LzJ1TENvL05jZkFvRXBPQ2o3UHhWZDFqajUrdVdQK2hW?=
 =?utf-8?B?cnUydkpvME90YVBZcllmVDE0TURWMTk5Q1h5d04xWGVjMjRxOXdsWlpTd2dv?=
 =?utf-8?B?MC9ZVzVxRnU3RjQ4cFFrbG9DOXp4MWFtdCt0aDEvUU16QnljNVJERVhzU25y?=
 =?utf-8?B?OC9hMXpjc3R0a29LUGZQVkpaUE4ydW9aam9mNmxDVDh3WjBLV2tuU2dNVVht?=
 =?utf-8?B?TG1UOExOSFBmN0ZoaHlMUnBIak53TjRUY3hYb3VicEhZT3JBR0o4Z29wTjZK?=
 =?utf-8?B?TnliUmZYam4xaU1qczlrOWpCaVZIMVNtaVhWNkFNV3JVekQzOHp3TnE0MVJh?=
 =?utf-8?B?eVhpYW5GMnRaSVd5YnBMWm5WUE0xWlY4QzJTV3dFMlBHTFY4eXJLS05kQTZD?=
 =?utf-8?B?UCtJUXBoNzFBMis5a3d4NnJHbjAvMXJKYjFTK1JkeVVuS3ZUOHlkNlpDSWZ2?=
 =?utf-8?B?SFp1a2Z1NDBUeEw1NmwvTzNFWEg2cGoxTzA1Y3JkVjBuS3dqdk5RakxxdW1T?=
 =?utf-8?B?R2pDT3k5NHJVcFF1bm9JMHh3NktaTzNoaXhCL3VCQU9kM0tSRnJONEFjdUxm?=
 =?utf-8?B?TFVNbDRnQnBESHNoNTVxM2p6bCs4ZVFSTjdQT2xWRWY3S0xPRDNsL1ZqTzh3?=
 =?utf-8?B?WHM2Z0RYNjFCTDZzWjBxK0RzZkJ5NVBCVW56bTVTSmlOcGU4dWQ2S0tBV2da?=
 =?utf-8?B?RkV2SmZ0NlJHRGM5RnpRWWRXd0htdk1BU3M3YzdLcnE5UFdOQWhZU05ZOWds?=
 =?utf-8?B?TGlUVlpIWGVjTWw0T1Njc2p6V0pJc1hnOGltTFY2NkpNOEJYeUIvZUNxOGYr?=
 =?utf-8?B?VXZwWXZnMEdOT0dSakxCNVp3L3dUUkF6dWRZMEM3RVVDSG9uSDBUZVI4YVRk?=
 =?utf-8?B?WXExNGUvV09JcTlZa1VjWnkvUzBtUFZCa1l6YkFMVzluN2tQcUpnMU5HZ3JU?=
 =?utf-8?B?STY2eUhQQzZvcUJpRE1OVEJRU2x1T0xEU0oxaG42SzZxanlMOUJtMWtLTS9W?=
 =?utf-8?B?cHBOcnJLK0NrVUFyNWFLdG9paXBJZWNYbThOL2dTaVhTcFFxeGhHZGpoWmpj?=
 =?utf-8?B?UXhHSUJIZncvbE42emZmSitSZjVPYXNqTWZjcGtBbXc4bXNJYk9TL2tGTmRr?=
 =?utf-8?B?YWpFVW1ZWmlHQ0VTaTFzNlM3Y3VpeWVsZG5SbmkwL1Y5dUtXSWk2ODlwMXhy?=
 =?utf-8?Q?NfbTSPVOsxUGt7ntXoXGk0Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D110DEDC106D434BBA19F43EF195FE04@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c159dd0-ae72-41bb-06d1-08dc751e30a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 20:32:50.5378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8lQ/lL6wy/2Q/miruh3KZo+X/5m5TZfAcBYSqB6+M5CVg57qeOKqaBG3Q7Yx6/+o58a2caPDMdBLKjHRM2UJomE0siTzdMmWKNUxsfmV1CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6375
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDEyOjQ4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEl0J3MganVzdCBhbm90aGVyIGxpdHRsZSBxdWlyayBpbiBhbiBhbHJlYWR5IGNv
bXBsaWNhdGVkIHNvbHV0aW9uLiBUaGV5DQo+ID4gdGhpcmQNCj4gPiB0aGluZyB3ZSBkaXNjdXNz
ZWQgd2FzIHNvbWVob3cgcmVqZWN0aW5nIG9yIG5vdCBzdXBwb3J0aW5nIG5vbi1jb2hlcmVudCBE
TUEuDQo+ID4gVGhpcyBzZWVtZWQgc2ltcGxlciB0aGFuIHRoYXQuDQo+IA0KPiBBZ2FpbiwgaHVo
P8KgIFRoaXMgaGFzIF9ub3RoaW5nXyB0byBkbyB3aXRoIG5vbi1jb2hlcmVudCBETUEuwqAgRGV2
aWNlcyBjYW4ndA0KPiBETUENCj4gaW50byBURFggcHJpdmF0ZSBtZW1vcnkuDQoNCkhtbS4uLiBJ
J20gY29uZnVzZWQgaG93IHlvdSBhcmUgY29uZnVzZWQuLi4gOikNCg0KRm9yIG5vcm1hbCBWTXMg
KGFmdGVyIHRoYXQgY2hhbmdlIHlvdSBsaW5rZWQpLCBndWVzdHMgd2lsbCBob25vciBndWVzdCBQ
QVQgb24NCm5ld2VyIEhXLiBPbiBvbGRlciBIVyBpdCB3aWxsIG9ubHkgaG9ub3IgZ3Vlc3QgUEFU
IGlmIG5vbi1jb2hlcmVudCBETUEgaXMNCmF0dGFjaGVkLg0KDQpGb3IgVERYIHdlIGNhbid0IGhv
bm9yIGd1ZXN0IFBBVCBmb3IgcHJpdmF0ZSBtZW1vcnkuIFNvIHdlIGNhbiBlaXRoZXIgaGF2ZToN
CjEuIEhhdmUgc2hhcmVkIGhvbm9yIFBBVCBhbmQgcHJpdmF0ZSBub3QuDQoyLiBIYXZlIHByaXZh
dGUgYW5kIHNoYXJlZCBib3RoIG5vdCBob25vciBQQVQgYW5kIGJlIGNvbnNpc3RlbnQuIFVubGVz
cyBub24tDQpjb2hlcmVudCBETUEgaXMgYXR0YWNoZWQuIEluIHRoYXQgY2FzZSBLVk0gY291bGQg
emFwIHNoYXJlZCBvbmx5IGFuZCBzd2l0Y2ggdG8NCjEuDQoNClRoZSBvbmx5IGJlbmVmaXQgb2Yg
MiBpcyB0aGF0IGluIG5vcm1hbCBjb25kaXRpb25zIHRoZSBndWVzdCB3aWxsIGhhdmUNCmNvbnNp
c3RlbnQgY2FjaGUgYmVoYXZpb3IgYmV0d2VlbiBwcml2YXRlIGFuZCBzaGFyZWQuDQoNCkZXSVcs
IHRoZXJlIHdhcyBhdCBvbmUgdGltZSBhIHVzZSBmb3IgcHJpdmF0ZSB1bmNhY2hlYWJsZSBtZW1v
cnkgcHJvcG9zZWQuIEl0DQp3YXMgZm9yIGtlZXBpbmcgbm9uLXBlcmZvcm1hbmNlIHNlbnNpdGl2
ZSBzZWNyZXQgZGF0YSBwcm90ZWN0ZWQgZnJvbSBzcGVjdWxhdGl2ZQ0KYWNjZXNzLiAobm90IGZv
ciBURFgsIGEgZ2VuZXJhbCBrZXJuZWwgdGhpbmcpLiBUaGlzIGlzbid0IGEgcmVhbCB0aGluZyB0
b2RheSwNCmJ1dCBpdCdzIGFuIGV4YW1wbGUgb2YgaG93IHRoZSBwcml2YXRlL3NoYXJlZCBzcGxp
dCBpcyBxdWlya3ksIHdoZW4geW91IGFzayAiZG8NClREcyBzdXBwb3J0IFBBVD8iLg0KDQoxIGlz
IGEgbGl0dGxlIHF1aXJreSwgYnV0IDIgaXMgdG9vIGNvbXBsZXggYW5kIGFsc28gcXVpcmt5LiAx
IGlzIHRoZSBiZXN0DQpvcHRpb24uDQoNCg0KSWYgaXQncyBvYnZpb3VzIHdlIGNhbiB0cmltIGRv
d24gdGhlIGxvZy4gVGhlcmUgd2FzIGEgYml0IG9mIGhhbmQgd3Jpbmdpbmcgb24NCnRoaXMgb25l
LCBzbyBzZWVtZWQgcmVsZXZhbnQgdG8gZGlzY3Vzc2lvbi4gVGhlIG90aGVyIHBvaW50IHdhcyB0
byBkZXNjcmliZSB3aHkNCndlIGRvbid0IG5lZWQgdG8gc3VwcG9ydCBrdm1femFwX2dmbl9yYW5n
ZSgpLiBJIHRoaW5rIHRoYXQgcG9pbnQgaXMgd29ydGgNCnJldmlldy4gVGhlIEtWTV9CVUdfT04o
KSBpcyBub3Qgc3VwZXIgY3JpdGljYWwgc28gd2UgY291bGQgZXZlbiBkcm9wIHRoZSBwYXRjaA0K
aWYgaXRzIGFsbCBzZXR0bGVkLg0KDQo=

