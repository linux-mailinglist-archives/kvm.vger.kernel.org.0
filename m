Return-Path: <kvm+bounces-18250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 578208D2A14
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7493F1C23B30
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DA115AAD1;
	Wed, 29 May 2024 01:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5ZKMMq7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914473D6B;
	Wed, 29 May 2024 01:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716947415; cv=fail; b=fOSFhHJLgfLtHsOt2Ycgf7WoN01x4DzvvLGkpCUgKjQ84Bq033sPNGYZclCUB8SdgW9rX8Fog+LSCAp7beBBhExA54MjzJt+uOwQFgoNK1hFNSDH11N+y0KHkJExeg/FTE/5naEqZ8IFGGBgfdBXS5aQfgnTaCB83YZP9NmGMlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716947415; c=relaxed/simple;
	bh=mX5kRlPHbHCQI42R67VaC+m++JhmTBvj4FtoE4Rw82I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PJRj3GmP0P4gCuXym5OKUQyNjfNh/i+lWovqK55uChJk1U8L6n2zLZA+PNZPOi+H8uoPfWF0KDyQHpTYs7smxenS1NpI7KE9FZjnXAwmxIdPzDRhJ8+xzHwHnLMO5xCZiNFghhtHbnlC5uLiv2cOvG/n4TaeAOvCZgOuHyOrLaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5ZKMMq7; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716947414; x=1748483414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mX5kRlPHbHCQI42R67VaC+m++JhmTBvj4FtoE4Rw82I=;
  b=T5ZKMMq7xI5fOQWK1sid8FrIXTrBvWPtWmKM6IZtgKFLGBNYqzY6NtIw
   Fpsd3WIF7vaqTL4xJh6y9BCq63X8onBISIwM1aCbVod3VzeUpBs38yE+h
   KEExJauX+kNAPm/wcNYaC5i4LubWb9BBlQ78CwAFizP+G3rQwdz3UfhjN
   3U/HHcRWsX6Aqut7DScMtoe2os9dI7/Wv+YSaSRx/PK7HYSyEP34o3aVb
   fhXERLDof8Dc+9MHesQDbtXWXRMxuang8rtUsxsTLPAUcXoWyjqUu0XUy
   s9lJrcQ4NFQF5+dEUQULgROP9lsNZl16d5Ay9LutkujPB+bF08chSaI7R
   w==;
X-CSE-ConnectionGUID: SwR2lLZOQay4wg97JM1O1A==
X-CSE-MsgGUID: jRnLW8ShQnioyftCRhOYRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13201631"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13201631"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:50:13 -0700
X-CSE-ConnectionGUID: Z6VGDtHSTKes792Qr4CG+Q==
X-CSE-MsgGUID: rggvzcRqQBSxDQt4kIFyjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39783850"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 18:50:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 18:50:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 18:50:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 18:50:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAlDpiXBElBnTEMhajY2vBlcxuDa9mYmhb88J+hiGgMXF5ToRAalrg7rnb9zwOWI1ZH8q9U6Tv9C/Ud0f4fJEre1jyKMVDl2ejTgsaIgF+IQ1q7V/Ev9W1kL1sayGaitmwA0ovfuPzPCqPlbHEICL8HxUE6nXfkwUojwrojNRO9Vo2RRUZP3tGHp7EdE4MhmIyMTOsEEHTEI+ZGzp9+hQb8zAVTSMvbryQjYfmJyLIQUiZ1B7eHMvEGd4BlfIwYl7d9TYiB8hSukCXMhrsXVVIMBj/oWNvAP7dcUYdOpetgLuzjt+X9oWhmUxJr80Qo8+w5JbuoViBSxjFJuC5ya2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mX5kRlPHbHCQI42R67VaC+m++JhmTBvj4FtoE4Rw82I=;
 b=HYcJz8UVycMjVAo4MEI4ZTIPDUPQOmYPuvltlfTICW1CIXO2dtlcBoJ+1HIBAbRv7OaQb+K6V9SBGM5ibm4mU8qo19yBfS8fFQWa107QBrgyvDxPt2VGWtxDpXaQ/uo9dlc49s4oQDZHQIvv1a2lJznwvYJhNuf6IHe1Pp7NMJYRsQkiuH7vwkTBlWv45uVFm7+YCW2qcTWYIsDfu01YVxx8lwBfVkMyplJHR4FhlBLL13Tj1neYXQMgOQ2T61tF69tl9cEx/6VBv2kR15Zo9o6jIeE8r0o+2AVvaR4s7l6PDYRNX3XZHv0qcoLoMOY93d5cJAgmucTr//7Yb4VbYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Wed, 29 May
 2024 01:50:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 01:50:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GlgQuAgACYjACABytBAIAAOfSAgAAJegA=
Date: Wed, 29 May 2024 01:50:05 +0000
Message-ID: <2b3fec05250a4ec993b17ab8c90403428ca5c957.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
	 <20240524082006.GG212599@ls.amr.corp.intel.com>
	 <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>
	 <20240529011609.GD386318@ls.amr.corp.intel.com>
In-Reply-To: <20240529011609.GD386318@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN6PR11MB8193:EE_
x-ms-office365-filtering-correlation-id: 92b70657-7743-4e29-74df-08dc7f81a9e5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YzdXWWxFTzJpcVQ5VTRKTnZxaDhaQXhDbEE5RnRQcC9LM1JycHh5c0lPbGhk?=
 =?utf-8?B?Tkp5SVJRalRBbSt4TEwxeGNxQ3JiYmcySitlQzhaUURUa1QzTUVoK1VRWXR6?=
 =?utf-8?B?a1c2aFFwdGlJWmovL2F2RlYxL2xXS1VTUGN0cjMyZU9Hd3hTWVFSMi9DY01V?=
 =?utf-8?B?dEk2bmJpVnJycE9ub3BGZGZVN0ZyM0owRmhzN3NycGxSR2E2djZCNFBZUTRV?=
 =?utf-8?B?ZTVONHdPZk44V1RNakJRNmM3TjlPYWpwbll6TzFFcTVtVURRK29nRlhZUFls?=
 =?utf-8?B?TGJ5ZWhaUjNacXVIYXdxKzNNNXowOWNpMmp6ekJEbmJGb2tEKyt5RXNqY2Ft?=
 =?utf-8?B?NXlqOFdTNWxmQVIwWHJPc3hxekNsNVNKbCtrZkpteHJxY2Y1QXFvalhUSmlp?=
 =?utf-8?B?bEl0M0FlM2ttM0NyM3AzNVE2TFJrRkdFU3BHSTQ3VldDMFVtRGt4djVBU0tM?=
 =?utf-8?B?UkJUa0l3TlhvdHN3SnAvOC9BNnV1VDFiUU9KZnY5UVpreHQrMTE3WEtFMy9D?=
 =?utf-8?B?dXU2MzVTb2xNVzExYzRrUllvV0RLaUR0Tm1MeFYvT3k4SllxaXFxVUdjWmlr?=
 =?utf-8?B?ejgvdlM5bzFib0svSDZKMy92U1d4b0R0V2t1Wng1NXlhOWkrTG5yUCthZlpn?=
 =?utf-8?B?cXl6TWxnNUdVU1NuSkNDbExRY2wwV3VlZVBXVXYyYUYrUmt0ZUZpWlhLK0JI?=
 =?utf-8?B?UFF2L2ZsaXNBOVFaUWVKaEI2bytndVpUSDdSRms4NHFEOEdtZURNMmhmeldh?=
 =?utf-8?B?dXVBNVNSNzA0RDVuOXRaZmxhQVhFVzdtNE5LSWJ6TlZLTmV3L280QTQ5VjJN?=
 =?utf-8?B?b2lKS2gwSkQxSFpFVkJTWnVSSHRrWlZveFpiTXpYc1hDSThxYUJmdnlwLzZ6?=
 =?utf-8?B?b05PL2NkQzNpeDRPcnA5Y2ZPOWMyS2UySmRNR2QzNlRuaXIrZ0U2YXZIR0Vi?=
 =?utf-8?B?N1A2cHMvV0t6VWc1ZG5sdW91RktuOVd4aVBHMGtmcWxOOVl6NEI0Z3g2MU9T?=
 =?utf-8?B?SkZhT3BvRnBpV3dQdVRvSEd0QlR5dVl5aVNhWm81TXgvbkl0c0lzMEk5aWhF?=
 =?utf-8?B?N1lncnhWdTF2UlMxeERTdWJva2lUSVRlV2QyaW5wMkYrMnVpaGlaM0szR1VI?=
 =?utf-8?B?UlZYZ0hKOXNwaG83TVdWOEtjNWYwR0lnbmRLZ1lJWUlCYkdsVEdGVUtYN1BN?=
 =?utf-8?B?b3Q2N1M1d2hzUXc5WTFhK0dQaVljY0dVbG10Sjdpb2FWR1FNK2Vrd2hobWxS?=
 =?utf-8?B?dWpOQmIxTEFOMmJhZ1gybjlVYmtqeitwaEJtYWhrZzJ4NjhvalpibXhwVnBx?=
 =?utf-8?B?eXkwM3ZiT1MzZjNLVDlIcXJrTk0xYzliVGM1ZWhsQWd5ZXZKNE1IaVY1U2da?=
 =?utf-8?B?N3FmWitWbnFVQzdYLzBuSnUvbDNyWS93QTAwbEloSFhhR05Ld0UwSjdobjFk?=
 =?utf-8?B?NW94WnVTc29lcW1EcmJhR3BYRkxudzExL1U2c2Z2QjB4UWVZL0tBSG1KUFAx?=
 =?utf-8?B?WElTVExkUXZmRlhvZEg5RnBObzZMZkFZNHNIMVNLMUNvcFU0RmJxOWNNN3FX?=
 =?utf-8?B?SE1pOUpsTk9qbWxhMzhmemZKZllxMGY1bmxXZFJnUDRBbFIxTjFxTmd6aDFB?=
 =?utf-8?B?eEtUMDhxSDllR2pvV3FFUk5ERm1IWGNpa2UrMGNVQ3RTekRpVXdNdFB6U2g4?=
 =?utf-8?B?Rnl2M2JsVnJlSGczdURlbDRjbERNSDJVa3BWVDZGZFB3dHdyR0QxOVAvVVBx?=
 =?utf-8?B?bDdrZnFkSkY5RmxraGJjYmRvNHdwbjBGQ2RiNDdlYmJ4SzZhaHZPSUJxcFls?=
 =?utf-8?B?Q3A2dzRHVkVWampaY3FHUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkNCUzNUWCtmcjA3V095Nktla1dYejNTdWdnZk9IWUVvYU5yZkhhZXU3ZjRh?=
 =?utf-8?B?enZTanRJQUlQcnB0MG8vZEVvcGZKdnUwYk8wV3R5RW05dXQ5SktMUC82OGVl?=
 =?utf-8?B?dGRLNGNsekdnYVgraW5XRWRkSUpwcXYvVFFyS1hWbmc4c2REQ3JGd2tBcith?=
 =?utf-8?B?TWpBNUFUSkpML3RRN0gvdmkzVURUeUNLNVlYZVFXOU45aEhXZTd5bVpRYVJ1?=
 =?utf-8?B?ak9DdG9ELzFkeTVRd3JjKzBBc0hMaUtxMUhicUZCZTFONGRiNDcrcHpmSW44?=
 =?utf-8?B?N3orMVFWekUvUUJzTS9vdk12UDJmMzRaWll2VHQ4UFFyQVRKQmNpaGk0OEFn?=
 =?utf-8?B?QlV5SDVkQSs5VWtqenR5SHBRN1N4TFF6VDdOUkg0a3U3cklSOEU3SHZ2N1BS?=
 =?utf-8?B?Y3BiOS93alBYRlQ4YVJxRHBMN1FVeGorM2I2amdRQ29RUkxUd2dKTHRUSlVj?=
 =?utf-8?B?OHpVRFg4VEM4VXBzS0xBb09VVlJkSjY3cFdXbFBzM3dmRVRuV0dWU3FsYUFx?=
 =?utf-8?B?bHRhYkw3OHk0VGxvTzJRYUJzKzY2OHdFUjZtWlQ1QnErSFlDT0NzTldiajRi?=
 =?utf-8?B?aVA3cXgvZXptU1dVdEdvM08xV2hxeDBZS0xoNUFVUHd2OXdoQ2RYcWlNSlRZ?=
 =?utf-8?B?dk52N01ZN1lYSkFKeVEzSElzTU5TekYvZlllL2ppYzFoY2w4Q3d0V3VVeW9W?=
 =?utf-8?B?MVprNWtPUFVuYVlXbGViUzgyeTA2eWRidGJDOGlDU0haK3hQekJFYUFkdWFU?=
 =?utf-8?B?cVpVZENLaDF4MFp1NXVGMVhzSSsyd0tHSUNwSlQycWZXQzk2dFcwVHBvOURz?=
 =?utf-8?B?VGNYMGorcjNzaGJsejdrSVNod1p2QXQ0cjlOeGVkUExuWW5hSzlGeHVYY2Nn?=
 =?utf-8?B?U1RwLy9UWWJjVFowenJYK0FmYlEwVHNLUXBiTUV1L1VYK2F1ME0yeFhlc0lG?=
 =?utf-8?B?Sk9rQ3YwMHFWcS9HdjlMY1h2RnAxVHcvc0JxbnM1YkpnRGMrcWJETTJhWVFz?=
 =?utf-8?B?SzZVT2pZUitxN3R2endjaWtFdzRraE1vOWl4cnplMS9jclo4YUFMaHJ5dVNR?=
 =?utf-8?B?WmIva1Q0TTYxSlhIckZCU3ZOZmMrVTltSW1pWlB2K1R6TGdiMWlERUozMEZ3?=
 =?utf-8?B?U3B6b21JV2w3dk9mRHhaSjFMYldVWmZBMWdiNFd4N1BUeDFUQ1V3WVZGWStp?=
 =?utf-8?B?UTc0KzJRckxySWxSdUpqVlFMUUNQZkJlUE9ZNk03dFMvWmQ0VlNqcDg4RjRP?=
 =?utf-8?B?ei9abHBCOC8wRDgyTElwOU9Vd0t1QklMRis4MHEyZ0Q4S0l0Vkc3QmxMQzli?=
 =?utf-8?B?OHFMdnl0OFgwM1B6bHFHa3Ywb2t4ci84RjZLMUxUYmtYMStWWC9iUXQ0UVJW?=
 =?utf-8?B?VlJZOFdvRnBkYnYyTkdSNVRCVXRZM0lCY0tzNWU2TCtLM2VBcExvNG5QWkkx?=
 =?utf-8?B?MktCNXpSckxVM3RLRzRQMlRMM3VINmE4K1JQaGVPSjBDaGYwa0tOdEVyaEFB?=
 =?utf-8?B?YTVPVDYralhuVGZtczZFRWJLRDZEMEJ1Q1pRRnJzTVk3UWJtbThtOWphV3FL?=
 =?utf-8?B?N0RIWDhYbGdMRThRNkd1b0FiKzhiU0NCTDBWM0Z3SmxyTjZDZ0Qzb05pYW96?=
 =?utf-8?B?bW40RUMwT1FpUzh3T2x4NEhMaFRmbURUcXNndlkzZENIOG5IUFpITmJTVmZR?=
 =?utf-8?B?YTdKSWtpR3RwM2tZZHh4bnRscHFtUFhaWm1VTFN0aEFKTHRzSVpHZFpIdmx0?=
 =?utf-8?B?U1FiUUxkaGZucFlYenRCaWFsNW1tV2x3WlFKRW8wY0xUcmhaRllvZnJUWWVz?=
 =?utf-8?B?M2pycmlxZHI4RHZ1bWR1clphZ05kcVFSMjdBcGVFOXJTMCtnZThkUEFvamZu?=
 =?utf-8?B?dmtIamNHenAycDBNM3ozTDhEa0lxRkJwY1FRdEcrcmlNMVErT3cwcnRVWEU2?=
 =?utf-8?B?WTIxaE9EMkhMY3QvRkp6L1U5UkhCN25YdDN0cGdRL2tmbUU3dnBONFRzcCs0?=
 =?utf-8?B?NVdLdllYN1BsWUZJeGVYeTE4R1hhQ3dOR0N5a2t1dVpqWHViMmhTbDN0WTNF?=
 =?utf-8?B?WERwQWRUTlhCVUdWVXZ2aXBscnpXdGdlQllGZ1c2aWJOZFkybDBRb2hOaUhY?=
 =?utf-8?B?YVMzcjJWWEJKT051OGNIWmRiVjB4WDdZRFNDSXJjaktTOVlRQVFFb3NCTEZn?=
 =?utf-8?Q?cMgAE8O9+nJOUHcbZeX54TM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FE3F4D591D03F4AAA3733B6530C729A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b70657-7743-4e29-74df-08dc7f81a9e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 01:50:05.6958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jo4bEap+i7+K9MJKQzGgRh//B9BoNV3Hgl92iPqR5qBYbb54oXiPHnsTPy65lCVw2g7G1ZLw2LAPvM+DkIZBiSlej9aoHIZMBInvdhs1vVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE4OjE2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBMb29raW5nIGF0IGhvdyB0byBjcmVhdGUgc29tZSBtb3JlIGV4cGxhaW5hYmxlIGNvZGUg
aGVyZSwgSSdtIGFsc28gd29uZGVyaW5nDQo+ID4gYWJvdXQgdGhlIHRkeF90cmFjaygpIGNhbGwg
aW4gdGR4X3NlcHRfcmVtb3ZlX3ByaXZhdGVfc3B0ZSgpLiBJIGRpZG4ndA0KPiA+IHJlYWxpemUN
Cj4gPiBpdCB3aWxsIHNlbmQgSVBJcyB0byBlYWNoIHZjcHUgZm9yICplYWNoKiBwYWdlIGdldHRp
bmcgemFwcGVkLiBBbm90aGVyIG9uZQ0KPiA+IGluDQo+ID4gdGhlICJ0byBvcHRpbWl6ZSBsYXRl
ciIgYnVja2V0IEkgZ3Vlc3MuIEFuZCBJIGd1ZXNzIGl0IHdvbid0IGhhcHBlbiB2ZXJ5DQo+ID4g
b2Z0ZW4uDQo+IA0KPiBXZSBuZWVkIGl0LiBXaXRob3V0IHRyYWNraW5nIChvciBUTEIgc2hvb3Qg
ZG93biksIHdlJ2xsIGhpdA0KPiBURFhfVExCX1RSQUNLSU5HX05PVF9ET05FLsKgIFRoZSBURFgg
bW9kdWxlIGhhcyB0byBndWFyYW50ZWUgdGhhdCB0aGVyZSBpcyBubw0KPiByZW1haW5pbmcgVExC
IGVudHJpZXMgZm9yIHBhZ2VzIGZyZWVkIGJ5IFRESC5NRU0uUEFHRS5SRU1PVkUoKS4NCg0KSXQg
Y2FuJ3QgYmUgcmVtb3ZlZCB3aXRob3V0IG90aGVyIGNoYW5nZXMsIGJ1dCB0aGUgVERYIG1vZHVs
ZSBkb2Vzbid0IGVuZm9yY2UNCnRoYXQgeW91IGhhdmUgdG8gemFwIGFuZCBzaG9vdGRvd24gYSBw
YWdlIGF0IGF0IHRpbWUsIHJpZ2h0PyBMaWtlIGl0IGNvdWxkIGJlDQpiYXRjaGVkLg0K

