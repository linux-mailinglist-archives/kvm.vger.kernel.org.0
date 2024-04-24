Return-Path: <kvm+bounces-15855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D988B11B8
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7DA41C2102D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D16016DEA4;
	Wed, 24 Apr 2024 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxgWcn9Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9948916D9B7;
	Wed, 24 Apr 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982208; cv=fail; b=kQtX0Nv+Y8IbUmsjIXGxZ/tNGmjuBnCOKoo7NaaDdLWTkUSU1tLY57kriZeErSzj0oxEiRltLE2QUACe2RNYkoQa1QWCVB7uAUYfVTJM7DhKKWO8UGl0Xmaj08pg32RXqFAmWvKfMtPkl3GhGTZK/vsZCamc/qjJ9kth8tithjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982208; c=relaxed/simple;
	bh=R7EOrAfy2mAUUDdKIRiBhVBi09UyY9eDO+WtBMSaKpQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C7BNJHrl1YxVHvTVlKtawpmSyiaSnYDyRAkJjAOyuxaSNAADVBYHUdng5Pal3T5dtNYGfiwU8zjMIYLZCAPZ5XqN71mOFWIe3kcF8szSlk+kIgcSDDBsSVeHS53BDRzorxSc78qFln9KMkRUubW44fPeaIclLXLmIAXy5/LcK2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxgWcn9Z; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982206; x=1745518206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R7EOrAfy2mAUUDdKIRiBhVBi09UyY9eDO+WtBMSaKpQ=;
  b=lxgWcn9ZZgF3sa5DFJ9yTPTgrDrpQ33G4tYgs/RTBvwgymJZmWv5lAzv
   y6vMJuml6BbjoOFJo7gF9JUjCPEJdA830dht/vLyQG6qU6gPWmemlq3t1
   DvzBhW4qqTR9qsNd3IAwuuj81MykW4MSb/IxLSFgOe1ESXTK6Y2nS9sr3
   MvfBgaoF1dSIEg44mQft424Ny2i0WN5HCgL6BlJYm/u/eXP2Kn23Zhbql
   IltscBfwJ3zWdbXq8uf/EQVq9QMWBMwrII2Nv0mIuNlzRGSoQ92BPhUkh
   pfPlNzInlms8eEfoFWoYW8dm3V62teCNO69oV8FQ4vZeF2JquuRlwPC5i
   Q==;
X-CSE-ConnectionGUID: l7gzdbdBSveMvfubR3ie0w==
X-CSE-MsgGUID: Yb1t0G9VSTSiqAOW2HkVMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9755305"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9755305"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:10:06 -0700
X-CSE-ConnectionGUID: yePXg5pbRtmNY+F3fNZ1MQ==
X-CSE-MsgGUID: /4xr5zYUQruSvXj7tV0kfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24750558"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 11:10:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 11:10:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 11:10:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 11:10:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 11:10:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCEQ35rX8TVvse7NAtB7YoL5KIHj3VhUZMVKAMF/6x8vYBE7/QiPRxgb6jvsFov5Rc/uKC6qY7czOhJXM2n/C8FgWZkdmVnsQm9124RGzoE6GbA271ekP/NtEsRra4zas5gMiLPZYG1IlOR3UPIOge5niT2KGLG+/UhrVJvn7qRq2aAMNbmEyidkNJxNFginlyqMt+sszBBC9n8Iexds2NJFnk5m62uIX3y3jz3rPompCztWKD/io+n/A2SOf0YronGXNDB6thPvyX5kdZ/F1ufguFxOIPm/wP2BJbksYAxPEl0dDlBu05X6wB9JDdZLmeeFmRfdvii0FympQCX6NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7EOrAfy2mAUUDdKIRiBhVBi09UyY9eDO+WtBMSaKpQ=;
 b=IvzNOrvUZIgOj1AcRBDUJAwexJMJl40Y9NzK3Q70ARP3GeXop2AegZ7MJg7Ygk89PwU11zBoRrnRDPKUfxObGEXw02d1QBplSBM36BZQi17HH8UyHzYNB+b3wVxbK5bVsM6BfuYCF6V5CHJST50hBS6o1GEj2QyW6LPec3/fyeaGkwosu4f372GSkDQhbk4uc5B1NvpvgRTK2/Kad9WF9qNjNoOcjOi/2Ct+nXpFI4ZPAWPxrhRRu+JWnDu0VKGWGgyehWNrdLOKtKhV6dnVCPl6KeYnoYwEJP49ctbV/Zf/E2N/keA96jf6nedZGqyR/DFESa0scgSbaYnJsRl6yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8695.namprd11.prod.outlook.com (2603:10b6:408:211::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 18:10:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Wed, 24 Apr 2024
 18:10:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
Thread-Topic: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC
 timer configurable
Thread-Index: AQHae64tVrLEvOd2BUmbFm4CAYtKL7FrSkSAgAyDDACAAAcbAIAADHgAgAANAQA=
Date: Wed, 24 Apr 2024 18:10:02 +0000
Message-ID: <6f476d85cdb9dfdc0893e9eb762dca08f0f5f19b.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
	 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
	 <Ziku9m_1hQhJgm_m@google.com>
	 <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
	 <ZilAEhUS-mmgjBK8@google.com>
In-Reply-To: <ZilAEhUS-mmgjBK8@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8695:EE_
x-ms-office365-filtering-correlation-id: 1ef7a46f-8bdf-4010-a95d-08dc6489c359
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eVE3Uk11MGMrUzYycEp0WEU5RkhKMmlxSVF6MW4yZE5nVllFMGJFWjJGaE9R?=
 =?utf-8?B?STYwVFkyM2xoWjhLbG1jTkhnTE94VWJKZEFDVU5BV0xWVEpERzR4d2ExMzZw?=
 =?utf-8?B?Q1VHajlza2MrWHByeVd3dlJxZUlZbEhITWZRM2czUEg5S2tnaHkyTTlYdTRh?=
 =?utf-8?B?RUo0ZFFLbnVObzgxV1YyckpISlo2TUdRUXJobGlrNHN1d2VYbFRwTlQ0aEx3?=
 =?utf-8?B?bm9Na05LSURGU0FuWHgvd3dwREZDVnhIQldReHk5cisyVFhLT3dlOEFUQ0t6?=
 =?utf-8?B?cENBNTdRQ1FZYXlQNFZYMG1jdjlsY2VJTDVxVWIvaVMxaVNxZnh5TW5tT2JV?=
 =?utf-8?B?ZTU0QzJHVkxWa1BVcWJVQVdrL3lUcnZMQnRKZUlZSzJUUVVtQWxGWEhPS2l6?=
 =?utf-8?B?WWlyVkNSTjErQ1cwa0oxdXlEczVvZDVESGhIc010WHJYMmJvTVBMQ0ZBbUhk?=
 =?utf-8?B?bzl4ZVFsSXU3MzBzTFF3SzFmcHNzVEE4dXBaVmNOU0FYTGFaMEMyaXcrYmhM?=
 =?utf-8?B?VVFxU2pWZWhiclc3RE9uT053QTBDU2FFREJHM1JSVzhJK0V2ZjhQSUc3ejVm?=
 =?utf-8?B?VFpJWnE0SDZIQ2gvb3RBYW1YVU16Q0hKQzhpQWZqL0pxZmNJcjJ4MHNqaldE?=
 =?utf-8?B?aVE3U3J3N1NSL2RzVXhyc2xyVFpxbW9aMVZZa3NEREVoZlFScm9aV3ZnbFI3?=
 =?utf-8?B?aHNHaitYaWJzVzhsUHk1YTBxNzhpdjhsNVVXaXlhTGxjTzlEMVhiTVdaV2Z4?=
 =?utf-8?B?aE5yK29ZbnNGL29OcDladEFpSkQ3RUFGUXFTaGNGTDBQMC9HNG1PUGtUNlZ3?=
 =?utf-8?B?R21MdGsrbTJuT29wRDFDTFRvS09FRHZFS3dlNUtESXVjSWhKcHNxdlpqOU9m?=
 =?utf-8?B?NS90T0RFZm9jQVNGUGlqeHU1Uk4zL2tGYUg4TU5uZFFhZEZKbTNWemo0VmFR?=
 =?utf-8?B?a083akRsZjZaQ01RdE9uVVdXWWFWdWtXT0k5NldzNkR5bE5JdzlPYm5NZm1O?=
 =?utf-8?B?Q0U5SXhXbFlSSDMvcWFQMWpkbnRmeUJWckJOZmppQWd4bmNhZWp6a3J4bzNW?=
 =?utf-8?B?QzhKVEkrcUVReUgvSkNGT1ZTWUtybEVZNUJ3eEV5SXFpVnl4bFFJRkxCR1o1?=
 =?utf-8?B?Ny8zaDNlTEhJT3FsbUJqVDViYnYvNEprWkVtRkhMZ1NreWdSVnlRa0ZwUVZG?=
 =?utf-8?B?QjVDeldaVUtiWWtCOUZUNVR1aHJCaVU0NEYrQ2taeVFYYmYrTklVdnNGR1BW?=
 =?utf-8?B?V256SnNpblp0UGRGNGRRWWRybmZ2dVp4NzdtbVNGRlVkMTN2U3cwLzlESmRn?=
 =?utf-8?B?aVFpOWQwQ2kvTUxvZ3loQkFhMkhUNDh2MldkdkV0TEFISlEyenNFZDZvL0tn?=
 =?utf-8?B?WTJab0M0aThkNUM4UE1LNUVKQWlZd3hUcVd0aGw1R1NZeVVCWERzbE10N1cy?=
 =?utf-8?B?MjBubWtKNHdpZ1pSM1NaRUlpditMUmNrcXdVUU1iWC9GQ2wvY04rcDJaVFF0?=
 =?utf-8?B?WXRsS1hBUzFGUWY5TGQxVkxVZ3RscG41Y0swN2NzWXpjck1jc05iVVFSVU1i?=
 =?utf-8?B?cnkzUmtNM0wyaFp2aVhCaFcwakk0eElqaFAxNE9sWlNtVUlMei9UWXphSWhS?=
 =?utf-8?B?Z1RoMzVuaGpMOVJoZ2dkMHZnYnJrQlpJYlZrSG1CVXFvVWxJaGVKaE1tU0Jz?=
 =?utf-8?B?dmJKSXhJQmtFOGt0WUdxc05rdU52RDJBY1lzc0k2cXFEVTA4Z0huU2RRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3Q1OFBsQVpEVk5YMXB2L0Y4dDNjTlpaUENHZ0s3Q1ltejVZRjhOZUczUnUw?=
 =?utf-8?B?bldmUWNxUGxFd1VQcXdsczloeWd4Mi92Nm9sZnowZFJoZmJ0OGRIUG1jeWdI?=
 =?utf-8?B?Zm01ai9rTDFqbnVjYWgwLytsTjRlN3F1eWpxeEN5UFpITXBnSnEzRFF5QkJj?=
 =?utf-8?B?eDY5OVBXUXRkckprU3NYMDAvUkFocEFUOURMQ3p4RjlxSEpPVE1qNENsRE42?=
 =?utf-8?B?a0hWL2xTeVF4RjZKTWF6NjkzN0I4WDhaL0hOUmwyV2g4R2FFdUxqbGs2cnNu?=
 =?utf-8?B?T1ZYN0lmZXJ2OTlPWHg4KzY2VzNIaXYxRjlhYzhST0xjNU15dWxEUGpkMzR5?=
 =?utf-8?B?N3cwS2RleThydDhGa3daTVJ5S1l3Q3JFYUFzRlF0cWJZTlZTanlkWEFlQmVm?=
 =?utf-8?B?Nzc0aG5Sb3VUYmU5aE5UUGZrREY5cUgwVTRXWVlpTTREVjZibEJseDNlalJ4?=
 =?utf-8?B?MDYzamxvcWw1V3J5eTJiRGJVMGdXK2p0SUkxWklQc2hnU3JmWFY1ZmdBREUx?=
 =?utf-8?B?OFIrR0hqN2lnWFQxaFZJMUJyQzhFdlU2cnlOVzVVMkQza2crTTR1S0FhUkR4?=
 =?utf-8?B?cU1LeCtFTkJySS80NVF3aTczYlRqTzY0OXpRYVVsdzhIVnQwcDg0RERCVTVk?=
 =?utf-8?B?eFBzV2NZVUJRcmIzRnN0aStVRWJncnpqK3U3dlIvUzFoNW1udVo1UG1kRFpG?=
 =?utf-8?B?U2Zyc2ttUkcwcjZBMGtkSjF5V1J4bTN1SkxUa09ZTlJsZm1wT2ZvOGhPZkJS?=
 =?utf-8?B?ajQwenlvWmRQZ2ZmTndzSisvWGhua0pZaU1rVTU1RTl2RGpIYnZaRmVBQUho?=
 =?utf-8?B?Zy82TURndG9zUjYvQ3FyUHNBalFXMU10TmRaNWdoQnFSSWYvWjE4bVp5OFZa?=
 =?utf-8?B?TW9sY2t2QUM1L2JJUG05akt3ckFuL1NjWEpJbnJZSTM4ajM4MHFJNkF5RWQy?=
 =?utf-8?B?YithSmx5TW8rUC91V3FLeGtCVHBnaDkwWENoTTMrVnFTVWhsMVlnSGxUbXFK?=
 =?utf-8?B?TFRUMllkRDM5eXJzcnd1c0oxMS90Z29FdHFsK0xxdi9CdTUvNWNTQjV1aSs2?=
 =?utf-8?B?bE9pOEFpR2ErZ2ZaNmduQVFXN0p2VGpXODFmYnhOZkI3eEJ2dHlFcjBoUW9Y?=
 =?utf-8?B?bUpTY3JXdXNpcVl5YzltaTZCT2dqeFpab2ZMUjNkMnRsZk01MlE1amRpRnF1?=
 =?utf-8?B?YnNMVll3M0F1M0oyWkZyY1EzaG5BcXdtYnpBV1Bab1gwLzZSQUtwVUxDd3lK?=
 =?utf-8?B?OWhudlA1VUYvRENrY1RYRWtrVlhyOXJSTExRazg4Y3N0aTV0RThLUjFoZmps?=
 =?utf-8?B?M2FIOXR5UkJCTnV5RXE5eXFXaFo4STdoS3IrL0VQcE02blUxT2RBTmVJUmlU?=
 =?utf-8?B?dExPZ0lQQXJsZDIwamVuVW8wanA1MXJCQStrZDBVSVZnRU15bkp0ck1wemJV?=
 =?utf-8?B?a0gxbldQZ1JyTVRuckxWTW43QzJycDlXeEZXTVVNRWFmUXVTd1U3V2htTXFQ?=
 =?utf-8?B?VnlDa2hEbDhWR3ZjeFVWK0xlNUlkU1A2RlZGLzVmVDc5WXBYZzh2Z0h2ZDV0?=
 =?utf-8?B?WWxLQlhGVWxITDl2N1pHY0x5dTEySmI5YnZ1SVBtWUJZaVpMUEw0MVl3NDMz?=
 =?utf-8?B?R3BCR1NsZ01pd1NEWWVTek5hRDV0Z2ZXY1NmZG9uUURZcHhMT1NjWVFJT29G?=
 =?utf-8?B?YkF2QTJVTkNEeEYvek1FS3FKdWtPWDlaUnJvUTV5N255dUpYNXZQNE1aTHJS?=
 =?utf-8?B?UlFyNllSMC94RERtTkZSV0ZrUmhSWmYxSlRyOHBtRVpSRXBVY0pRNTByL2t6?=
 =?utf-8?B?dzVra001clJZMGNYci9MVlM5c3prYSs4TDE1SnRrL3l2RXNrb1FBWGFGQ3ZC?=
 =?utf-8?B?NFhQYnFBeTJ1Q1JmQml0bGtwc3RFYUlKS0R6NGphTHlXNkhhZ0JaNzJ0eEdO?=
 =?utf-8?B?YzRELzBwVkxxMnZyVVV3T1FDR0psS1ByeW51bTBwaGNDNUU3eDlaU3piWnRN?=
 =?utf-8?B?S1lzTGs5MEdVQXdKdzZrdnF5ZE1Ud3RUL1hBTnJYVnEzT21FUm5oTXJIc2FF?=
 =?utf-8?B?ZkhhT2Qxc0gwT2dTSzRrYTV1VlA1UXVxZ0FFUXI1cGtPcVJqSGlIUDZXb3l4?=
 =?utf-8?B?TjNMd1BTNmg3Y3pxajAwbzVmT1VFQTJ4V01nUHBWNzk0WllaVGMwYlQ1WVlO?=
 =?utf-8?Q?Ll59ebSVyGpyzLUC1/+SSN8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2F2A4865746AE489BB01D09B6037EBE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef7a46f-8bdf-4010-a95d-08dc6489c359
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 18:10:03.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wSuDMVP/LRZHbaBCLZ3l2dnOR558PK6QNTwfcBhb/skgO9EW0lC+W/ptklPIj65s7X2YanSSXcvxu++PbOXc6cu+4mp+FwVBiHci/ddGb+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8695
X-OriginatorOrg: intel.com

K1Zpc2hhbA0KDQpPbiBXZWQsIDIwMjQtMDQtMjQgYXQgMTA6MjMgLTA3MDAsIFNlYW4gQ2hyaXN0
b3BoZXJzb24gd3JvdGU6DQo+IEkgaGF2ZSBubyBwcm9ibGVtIHBvc3RpbmcgImVhcmx5IiwgYnV0
IERvY3VtZW50YXRpb24vcHJvY2Vzcy9tYWludGFpbmVyLWt2bS0NCj4geDg2LnJzdA0KPiBjbGVh
cmx5IHN0YXRlcyB1bmRlciBUZXN0aW5nIHRoYXQ6DQo+IA0KPiDCoCBJZiB5b3UgY2FuJ3QgZnVs
bHkgdGVzdCBhIGNoYW5nZSwgZS5nLiBkdWUgdG8gbGFjayBvZiBoYXJkd2FyZSwgY2xlYXJseQ0K
PiBzdGF0ZQ0KPiDCoCB3aGF0IGxldmVsIG9mIHRlc3RpbmcgeW91IHdlcmUgYWJsZSB0byBkbywg
ZS5nLiBpbiB0aGUgY292ZXIgbGV0dGVyLg0KPiANCj4gSSB3YXMgYXNzdW1pbmcgdGhhdCB0aGlz
IHdhcyBhY3R1YWxseSAqZnVsbHkqIHRlc3RlZCwgYmVjYXVzZSBub3RoaW5nIHN1Z2dlc3RzDQo+
IG90aGVyd2lzZS7CoCBBbmQgX3RoYXRfIGlzIGEgcHJvYmxlbSwgZS5nLiBJIHdhcyBwbGFubmlu
ZyBvbiBhcHBseWluZyB0aGlzDQo+IHNlcmllcw0KPiBmb3IgNi4xMCwgd2hpY2ggd291bGQgaGF2
ZSBtYWRlIGZvciBxdWl0ZSB0aGUgbWVzcyBpZiBpdCB0dXJucyBvdXQgdGhhdCB0aGlzDQo+IGRv
ZXNuJ3QgYWN0dWFsbHkgc29sdmUgdGhlIFREWCBwcm9ibGVtLg0KDQpPaywgc29ycnkuIFdpbGwg
ZGVmaW5pdGVseSBiZSBjbGVhciBhYm91dCB0aGlzIGluIHRoZSBmdXR1cmUuIFRoZXJlIGlzIGEg
bGl0dGxlDQpiaXQgb2YgY2hhb3Mgb24gb3VyIGVuZCByaWdodCBub3cgYXMgbmV3IHBlb3BsZSBz
cGluIHVwIGFuZCB3ZSBhZGp1c3Qgb3VyDQp3b3JraW5nIG1vZGVsIHRvIGJlIG1vcmUgdXBzdHJl
YW0gZm9jdXNlZC4gVGhhbmtzIGZvciBiZWluZyBjbGVhci4NCg0KWWVzLCBwbGVhc2UgZG9uJ3Qg
YXBwbHkgdW50aWwgd2UgaGF2ZSB0aGUgZnVsbCB0ZXN0aW5nIGRvbmUuIEl0IG1heSBub3QgYmUg
ZmFyDQphd2F5IHRob3VnaCwgcGVyIFJlaW5ldHRlLg0KDQo+IA0KPiA+IFRoZXJlIHdhcyBhdCBs
ZWFzdCBzb21lIGxldmVsIG9mIFREWCBpbnRlZ3JhdGlvbiBpbiB0aGUgcGFzdC4gSSdtIG5vdCBz
dXJlDQo+ID4gd2hhdA0KPiA+IGV4YWN0bHkgd2FzIHRlc3RlZCwgYnV0IHdlIGFyZSBnb2luZyB0
byByZS12ZXJpZnkgaXQgd2l0aCB0aGUgbGF0ZXN0DQo+ID4gZXZlcnl0aGluZy4NCj4gDQo+IEhv
bmVzdCBxdWVzdGlvbiwgaXMgaXQgYSBiaWcgbGlmdCB0byByZS10ZXN0IHRoZSBRRU1VK0tWTSBU
RFggY2hhbmdlcywgZS5nLiB0bw0KPiB2ZXJpZnkgdGhpcyBuZXcgY2FwYWJpbGl0eSBhY3R1YWxs
eSBkb2VzIHdoYXQgd2UgaG9wZSBpdCBkb2VzP8KgIElmIHRlc3RpbmcgaXMNCj4gYQ0KPiBiaWcg
bGlmdCwgd2hhdCBhcmUgdGhlIHBhaW4gcG9pbnRzP8KgIE9yIHBlcmhhcHMgYSBiZXR0ZXIgcXVl
c3Rpb24gaXMsIGlzIHRoZXJlDQo+IGFueXRoaW5nIHdlIChib3RoIHVwc3RyZWFtIHBlb3BsZSwg
YW5kIGVuZCB1c2VycyBsaWtlIEdvb2dsZSkgY2FuIGRvIHRvIG1ha2UNCj4gcmUtdGVzdGluZyBs
ZXNzIGF3ZnVsPw0KDQpJIHdvdWxkbid0IHNheSBhIGJpZyBsaWZ0LCBidXQgcHJvYmFibHkgbW9y
ZSB0aGFuIHVzdWFsLiBNb3N0IG9mIHRoZSB0ZXN0aW5nDQpjaGFsbGVuZ2VzIGNvbWUgZnJvbSB1
cGRhdGluZyBhbmQgbWF0Y2hpbmcgc3BlY2lmaWMsIG9mdGVuIG91dCBvZiB0cmVlDQpjb21wb25l
bnRzLiBXZSBuZWVkIHRvIGhhdmUgc3BlY2lmaWMgT1ZNRiwgVERYIG1vZHVsZSwgUUVNVSwgS1ZN
IGNvcmUgcGF0Y2hlcywNCktWTSBicmVha291dCBzZXJpZXMsIGFuZCB0ZXN0cyB2ZXJzaW9ucyB0
aGF0IGFsbCBtYXRjaC4NCg0KVG8gd3JhbmdsZSBpdCwgYXV0b21hdGVkIHRlc3RpbmcgaXMgc29t
ZXRoaW5nIHdlIGFyZSB3b3JraW5nIG9uIGludGVybmFsbHkgcmlnaHQNCm5vdy4gSSBjYW4ndCB0
aGluayBvZiBhbnl0aGluZyB0byBhc2sgb2YgdXBzdHJlYW0gc3BlY2lmaWNhbGx5LiBCdXQgVmlz
aGFsDQptaWdodC4NCg0KQXMgZm9yIEdvb2dsZSwgdGhlIFREWCBzZWxmdGVzdHMgYXJlIHVzZWZ1
bC4gV2UgbmVlZCB0byB1cGRhdGUgdGhlbSBvdXJzZWx2ZXMgdG8NCmtlZXAgdXAgd2l0aCB1QVBJ
IGNoYW5nZXMuIFdlIGNvdWxkIGRvIGEgbGl0dGxlIG1vcmUgY28tZGV2ZWxvcG1lbnQgb24gdGhv
c2U/IEFzDQppbiwgbm90IHdhaXQgdW50aWwgd2UgcG9zdCBuZXcgdmVyc2lvbnMgdG8gZ2V0IHVw
ZGF0ZXMgZnJvbSBHb29nbGUncyBzaWRlLiBKdXN0DQphbiBpZGVhIG9mZiB0aGUgdG9wIG9mIG15
IGhlYWQuDQoNCkFzIGZvciB0aGUgVERYIGt2bSB1bml0IHRlc3RzIHVwZGF0ZXMgWzBdLiBUaGV5
IGhhdmUgbm90IGhhZCBtdWNoIHJldmlldy4gSQ0KdGhpbmsgd2UgbWF5YmUgaGF2ZSBlbm91Z2gg
VERYIHBhdGNoZXMgdG8gZm9jdXMgb24gYWxyZWFkeSB0aG91Z2guDQoNCkxvbmcgdGVybSB0aG91
Z2gsIEkgaGF2ZSBiZWVuIHdvbmRlcmluZyBhYm91dCBob3cgdG8gcHJldmVudCBURFggcmVncmVz
c2lvbnMNCmVzcGVjaWFsbHkgb24gdGhlIE1NVSBwaWVjZXMuIEl0IGlzIG9uZSB0aGluZyB0byBo
YXZlIHRoZSBURFggc2V0dXBzIGF2YWlsYWJsZQ0KZm9yIG1haW50YWluZXJzLCBidXQgbW9zdCBu
b3JtYWwgZGV2ZWxvcGVycyB3aWxsIGxpa2VseSBub3QgaGF2ZSBhY2Nlc3MgdG8gVERYDQpIVyBm
b3IgYSBiaXQuIEp1c3QgYSBwcm9ibGVtIHdpdGhvdXQgYSBzb2x1dGlvbi4NCg0KWzBdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIzMTIxODA3MjI0Ny4yNTczNTE2LTEtcWlhbi53ZW5A
aW50ZWwuY29tLyN0DQo=

