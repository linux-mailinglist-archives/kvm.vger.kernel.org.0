Return-Path: <kvm+bounces-30880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFAE9BE16B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F9DC1F24587
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807731D90DF;
	Wed,  6 Nov 2024 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KxN2KNUR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0882B1D5AC6;
	Wed,  6 Nov 2024 08:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730883377; cv=fail; b=oHc9U8hO6BrQxFFLp/GkleYp1dG0YwRpvT6638M/pyTmvqRn0P+YCK8MiW/ElCQAUTPVDuvywXywZvxOoUHzp+gojkK38R4n0QmKlZRhCvRrSrYah/bo3vyiYCaNE+BoTX1niA/jXT7Nf/g79CBeqNHDEVtWsXu7uKA3FPuk5aU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730883377; c=relaxed/simple;
	bh=JaVQ+8AIlY7tq5CO63FlZIhPl7641lBb/+3QmctHmII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwHpqpBj9fNLzcupNFII4WqdmR1R+ZnH8TYKyMkzkPoNEXQr7McBqnrj1L3tngRuQpOqs+CNY7QFP+5so5BtiEJuc/ZgPc79KPUTLMGmnulXZ0TIM9BBp5GOE6X22SazHQRRjaDtj51uqI6NgszoL+0Pa7ZwT9nxcp23fN5sQZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KxN2KNUR; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730883376; x=1762419376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JaVQ+8AIlY7tq5CO63FlZIhPl7641lBb/+3QmctHmII=;
  b=KxN2KNURKX1XrlZN+gvdBUjISIG1ZzVzOmHTnEwe8XL7e3Vq7zILgAUN
   XO6qAzPh9Cm3bSaNyibpT+O0pRZNjNXzgMv+ZPTAQasiSKBl+SdxdbfHu
   Iv/V0UxoEgaay2tdYJka5PAn63Wa+BjRb4jGk+GeOLry2F8KCDhzNEaK1
   Lun1Bgd8TVzV5yB6etYyQipsZro/NJ8uVVqx6adwca67UmL6NGtWquszG
   poEbQcQ9tyXYTUQSUIcFXpjWDVRICxVj7Ryqp9PlgGZ9JgF0Ohb6ZLquN
   p8aWmQDuKYqc3ttSpeP0CVoo0+fyu6vof0AFWipS8wt5xoObEWDhzAuEh
   Q==;
X-CSE-ConnectionGUID: ZwLOMUttR025Y8+fyaAGlw==
X-CSE-MsgGUID: 6xeZwHZGRiSXa44wLP3boQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30439501"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30439501"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:56:15 -0800
X-CSE-ConnectionGUID: USIxdFIZRJysZEP2lMZu/g==
X-CSE-MsgGUID: H7XR+SxfRUqbpVWfdB6f5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="107753315"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 00:54:30 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 00:54:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 00:54:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 00:54:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cHlNjzfuefbMw6yPStKcR9jxl+SF3blvY08jqZgOewmTbxgTGD//ZTua/sYC1D55+VHUzJLguQtwvC4H3mpqockpv/tXebJ03rOCGJU/KLTAo4LIqkiTdss7nfzISr8InXAtaKtHC2wSXRpqW4YvsaZzuPUmAfW2jEDuPFa4xpoiIstlHpgWZ7ipenje2C7W7rEyXFMGYZ6NoJPzOrKlkGGP/aMizKfypSROgKhlrUhmq2gbELncoUhPg5wZzQ0+XPGivpgRJnfkA7EXpLQLyBJOilefhzZPsKWRSK7yeUThZWgfD4ILU1fn2P+WSmsbflOFeEIN3gDy+i7ca4qPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaVQ+8AIlY7tq5CO63FlZIhPl7641lBb/+3QmctHmII=;
 b=B91IGW+sEnh9mJLtO6+vSygkU/QK/BbJ7Tr9zpPyrounEr+/DGTkCGAqEhJdFR1FMujXaQQy+qXNRPKqkQxxjKPK4sNdhMQxIGu0M9kYNAeQnZFGrSswCPOmfNqXVP2UTKCl6TDqG6hKBZYoc31MRzDLV3fN9kADH/Z/ovR/Auxn8kDppgIHJPS6pE5TmT6lCw2tpcs1tVWdmew6tjcTLXwhwyWfu3KTJgRL8GtWaeG2MNdba4DpMHa9blEf/QnQodKNEiaxmSybucdQigNGx9KR5KJ6+6yFJNN6ho6KBk3PulVxkGvAYHQYb2gY+nnrY5eiEohr1VMSIG8D+IUiGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 08:54:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 08:54:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWAgABdLwCABDPdAIAAEjwAgAEWjQCAAHIYAIABhPKAgAAGFgA=
Date: Wed, 6 Nov 2024 08:54:22 +0000
Message-ID: <e2c19b20b11c307cc6b4ae47cd7f891e690b419b.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
	 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
	 <ZyLWMGcgj76YizSw@google.com>
	 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
	 <ZyUEMLoy6U3L4E8v@google.com>
	 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
	 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
	 <ZymDgtd3VquVwsn_@google.com>
	 <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
	 <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
In-Reply-To: <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5276:EE_
x-ms-office365-filtering-correlation-id: ec4471c7-3c98-4746-1500-08dcfe409c0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T3FoR2FNNXd2SU5pL2dTKzZVT1U2a0xjeHNiemFVMnF2NVlxQTRvNWVzbWlX?=
 =?utf-8?B?RHFGOERnR2dVNjRVTmVNQ05wd0txYnNWV0Z2QUFBamRsYi8vdy9jWGNZbG1m?=
 =?utf-8?B?eUw1SGI1TlVkZVBCZ3R0azRwbWNUTklVUTY1SEFwQW9ZczBvaFBXQklVWjRS?=
 =?utf-8?B?VkY3NzUzRDlhVytpdlJWSHVSK2RwVWlmUGlveDdSekRCNWdWWGlPUlJOSDFC?=
 =?utf-8?B?Rk1SN25EQVJkN2Y0eHQ4MndEOWhuQzUvTVJSSWM1VEJESzZnOW5MZVlBeXk2?=
 =?utf-8?B?Qk4zMEZxYVZ5S0dPNzQxc1gxY2RjZjc0UmozdmJQUWlUQmd3SXpoVkEzS21y?=
 =?utf-8?B?eGl0Tld2UWpQMHc2MnBjZ2p2MjI3ZTFwekRoZG5DM2VyN1BxWGVGeHZNTkRT?=
 =?utf-8?B?WE55bktHM0dzRmh5K1lBNjR0czF2WjhWbEFBa1hkanVMTndMUE02cXpaUCtl?=
 =?utf-8?B?NThzV25wd0VweVJWdTFHMG1OSW5XenQ0cm5hZHBUcGV6a1M0K1pPa1lydk5X?=
 =?utf-8?B?eW53ZGtkcmdCUitnSmZaUEhoS2VsSG9vY0pRaXQ1dGs2cGZ1YVpIWHVEQUhW?=
 =?utf-8?B?TlkwU2pybldjc1lzdmpKRXR3bTRwRmo3VlM1aVhsd3JsL0xrckthL05EWFBY?=
 =?utf-8?B?RHpjd0Z4WTY1T3FWSUJQcloxdGh2ZFZHWVJ6TFI4QXpVWW5pOXkrN0hoUStT?=
 =?utf-8?B?NlZ5ZFhHOTBVdHBZb0RlemZtY0ZDdGRXbUVkMEJQYVZUV2tsVkgzRjkwSlF6?=
 =?utf-8?B?Vmkxc1FBOXhVMWNaVVVoYnVYeXFqQ1FQMWRPemRER05JZmNNVEJLNUVYWTNS?=
 =?utf-8?B?dDZCS01ac0xRVGtBZXF3ME90VWh1VW5QeGl2OVI2SFI4dXBPY0ZFT3AwT2Y5?=
 =?utf-8?B?WlkvQVFaL0JTUFpLSTdqZCtlMlRJanZpUDRoVzJjSFZ3ZVVSOUxMY1YvY01q?=
 =?utf-8?B?YzQvZmFZZm5ZSkVRQkNVaklFZWorMTk0U2VYVldLaDdRaC9zZUphYU1qb1dH?=
 =?utf-8?B?Tk55SE9DVlRwOHlxZXJEWnd5Tk1MY292c2Q4VzJaTis4S2ovTFZVN0xzTndR?=
 =?utf-8?B?UTgybG1hSjFZekVIYU83cFE0U2M5UmRQcVNjd2NnLytDb0hDM2xTQlM1Vmo1?=
 =?utf-8?B?NS8yQzArS3hFS1ducmNPd00zWis3N3YvK0Z1MmE0QjQ3WWk5cSszYzZZOEFF?=
 =?utf-8?B?WFN4cFMyWkdRZnd1OGs0TklEVEFzLzMrd2JzVFV2SUFjaktIbG4vU3ZjRS9L?=
 =?utf-8?B?YXQydlBIRGF1d2hsQzRhSzQzNlBSSWlQQjhseithMVZSMmpRK0diRjFBMzlY?=
 =?utf-8?B?OEMwOFJ5U1p0VjFuR3BZN2Npd2JKZ2VPV1hhUUNkcTNsM3lNSXNKS2ZlMGVt?=
 =?utf-8?B?azN1NjhzOUpvQVNzN2VvQ0ViampKdGduM0tOVFp0M3BUaWVJUklqK3I4akEy?=
 =?utf-8?B?NVVnUVhveFVJbmxIS1U3cjJqRXJyc1dzbU1ZanlOaHBudVN0SkFYa1pVcG1D?=
 =?utf-8?B?TTBUR0ZWaTlJMGtxU3ZnbkY2dmc4K0NJTlUzTVlmWVA0MGRpOWZEeE9XSkxK?=
 =?utf-8?B?NGFXT3dtdEhnWUpxNGxDS0t2ZDBuNDl3R1FZNU9ZaVVrZitTcTdLWnlaRDJ4?=
 =?utf-8?B?OElSMnpBWUE4VWc4ejZNVjRXZDdGTHc4WXVlVDlVakRFTGM5Unc3MEpJZzVv?=
 =?utf-8?B?aGlRMVRzT0lmM05hcFUyeFlLR21ra1pKa3dwUTlMSFRLR2psZ2tuZkRtOGNm?=
 =?utf-8?B?YWZrS3d2Vm9jZEFjUzhjaWx6NFRDZG1qTXZRMlVDSDRQdmgrNk1xS2VKTTNJ?=
 =?utf-8?Q?h+2hLStqJIxyh7YowUcXwp70NoQ5dP5L5+UWo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWlCakNWVytMZmNVWFNrdXFMUnpOQTZlWmczWXE2bm5TVlR5eG1VQzVZRGJH?=
 =?utf-8?B?SE9pdjkvTWtnai9tQWdVbExrNWVDQWVpTzdaZHM4MTY1M05UZ0hSUWMwYy9G?=
 =?utf-8?B?VG5xTVJzY0dGMzZEL21mY0VtZWszMVZsUFl2bTVZZCt0QXRCWkFHV1V2V29Y?=
 =?utf-8?B?NkhVLzRtUVlqWlVITWRhb2FHKzVzYXIxaEpjT296OWs5U3BGdm0vS2lYcjkx?=
 =?utf-8?B?RWp6MVJhQ3lTMzdjczVRbFRFcWxlQVd2MXFGb3pQOXptQ1lnUnE2M3Uxc3Ja?=
 =?utf-8?B?NXhKY00zaGFOWFJIaUxPRnQvMjJvZ2hGelBWcEVvclpvRWxMUlZyL1lISmdw?=
 =?utf-8?B?ZldRV0xnTGdlWDdYM0dsdHA2VWIzdE01YVl2MXJGbEI0TC9ndjNMd1ZiWWF3?=
 =?utf-8?B?K2hOcHlEUk5USGJJOWtEYzc1YlpBWElGT252RnYzTmVwNlBqWEZOZjNnNGZZ?=
 =?utf-8?B?aHNHcVliR2JxNFh2RGY2MjkyZk9PT0xyQkdoL00xSkVBVDN6eVZxOGNXb3Qx?=
 =?utf-8?B?VUpKbk01S1lSeW1BcVAycU9SM00wSlRzc05DbTBxSEVrdDRtSXZLTC9HTS9u?=
 =?utf-8?B?T3FLOG5vN3VTM2ZkWmRLZnFJN1NhOUVnS0dtWDNFT2FhanIvSm9Vb1R1T2pK?=
 =?utf-8?B?dVlVWkFGbmtxKzMzNFJtbzBObG5zTkJ6OHRMdXBoNk5pcWVTcHZtZTNzTitw?=
 =?utf-8?B?c25mVVpaZ0Jua1BBQlREWVQ2dXhJaVltZis0Z1U5MWppUU5jdGNoc2lRWXA4?=
 =?utf-8?B?VTRDaGZPRlFOMzk2WnQrYWlZVW5JZ0FvZWVJSDZtamhFRmJHalVQbHZjTXpj?=
 =?utf-8?B?V1l5S21yd0dKRWVRR2JBWlJVZ0srN1FCcGNzcGJZcGRBT0pXRW5NdHhEZ0pF?=
 =?utf-8?B?MzVWWVdWdmlsaWttWk5MQTNvT2NHQ2NrL29WR1FrcTdOL1gwWXM3UW9iem5u?=
 =?utf-8?B?MkRqR2NqQkJMMGRUVkNpdlFLdkdoMm1tNi9nSy9BN2ZkUEZGMVEwZEtsU3Fr?=
 =?utf-8?B?QXc0aTZ6QmhiNEkxcW5EclR1NmVsVzdwRkNLbDdxWmpoRDkzSGYyakh3Y0Nn?=
 =?utf-8?B?MGw2dEd5WUR0RlNqQzNaZ09DMlhWbFFMRXg2RXJDSFpaSWd3ZVlNTWNiRDY5?=
 =?utf-8?B?NGtTZXFBUG9RS3QrWVFMQWhhTHN1RDVkTVBhdUZ5YndkYnhkRHFtSjJNZGNv?=
 =?utf-8?B?VGFYWWdZdDZwU2diMXRjYWFGZkZJWWJPRTUrM1J5a1dEOXpjRElVc0NPL2Nm?=
 =?utf-8?B?NzRtdkdLU3YzaTZsTU1LVVNoUTFreUJTanl0VUVjV2dBUTZpWkp3Ui80R1Ji?=
 =?utf-8?B?ZXhVNWkyWHp0NWdHaEJjQmZHaXIvZ3RHQnZFS1dDVnpQYTU4RWdFN1cydFhE?=
 =?utf-8?B?SkR2VlNrSEd3U2NadHVIOEYvTlZPMVhIZ083ZzREeTlFSUlLR1RIZWRoYXZv?=
 =?utf-8?B?dkJ4ak41NklCZXRJdjIrajdQQ0FVQTVyRnlxanRJdW1WMmlkaDZ3UXpVSGdX?=
 =?utf-8?B?QXpwVGQvZFRhcEoweDIxdGdrd3FSWWh2VTBrVVlxOVNPY29FK1NoeG1TTFkv?=
 =?utf-8?B?ZjBKRys3TVFjOWkrYmFiN0NRQjJveFA2aDVRVjZQT0JuWmRXSDA3b3hxdkNl?=
 =?utf-8?B?NTdRbzFDQXhyZjFGMEMydUdwN0V4SUMzRUlRSWdtVjdzTHZ2TTM2aXNlQ1Bo?=
 =?utf-8?B?QTRuUzcwRnV1OURXRVJTby9IYXBOemZSNmEyZjdGRzI0ZGFoNjY0akFhcjhV?=
 =?utf-8?B?c3k3a3kzUUUrL0s5WktxR25YRno0dWF1d2Nabmxwc0FQaHFRZ0ZPd2lsdjB1?=
 =?utf-8?B?US90bkNCekNqZXpkZDF0WUJGYklsMDZwV2NPZGFtMlBSMFFPWktiOXVhRmZi?=
 =?utf-8?B?ZEJad1YzYXUxZkp1SVVNcm9tdXo5SC9nejJoWDA4eUNDc1ZwNlF1UVEza1gr?=
 =?utf-8?B?UldkYS9ZMUh1dW9KYllXVUhpRTJicnQ1Y1kxNHpUZnBGZHlQRFMwbHBpTVRZ?=
 =?utf-8?B?M0dqNTJRbWo2bXplbVkzbzliaENHVjJydzZMN3Y3OUI5djBYWkJvWUUrYkVG?=
 =?utf-8?B?VDZJdjI4RXhNZlVsaW55bHprU21ZR0VYOGZOQk5rRElLenQ0Tmc3MW04d0xl?=
 =?utf-8?Q?Q9j3/uXUJP1EhVRoq78Qi6XFO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE4DBD1F518A314DB15244C37E88800A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4471c7-3c98-4746-1500-08dcfe409c0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 08:54:22.8538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ot5Pl3sMwdcwZs6mp0Qq8ODqK3VyBpXPCPaci9GO9ZYoDM919r/Y+4Tb+Vn0X6nXiNHw4D7h+cTATfATzd6hFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5276
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTA2IGF0IDE2OjMyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
c3RhdGljIHZvaWQga3ZtX2NvbXBsZXRlX2h5cGVyY2FsbF9leGl0KHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgaW50IHJldF9yZWcsDQo+ID4gwqAJCQkJwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9u
ZyByZXQsIGJvb2wgb3BfNjRfYml0KQ0KPiA+IHsNCj4gPiDCoAlpZiAoIW9wXzY0X2JpdCkNCj4g
PiDCoAkJcmV0ID0gKHUzMilyZXQ7DQo+ID4gwqAJa3ZtX3JlZ2lzdGVyX3dyaXRlX3Jhdyh2Y3B1
LCByZXRfcmVnLCByZXQpOw0KPiA+IMKgCSsrdmNwdS0+c3RhdC5oeXBlcmNhbGxzOw0KPiA+IH0N
Cj4gSWYgdGhpcyBpcyBnb2luZyB0byBiZSB0aGUgZmluYWwgdmVyc2lvbiwgaXQgd291bGQgYmUg
YmV0dGVyIHRvIG1ha2UgaXQNCj4gcHVibGljLCBhbmQgZXhwb3J0IHRoZSBzeW1ib2wsIHNvIHRo
YXQgVERYIGNvZGUgY2FuIHJldXNlIGl0Lg0KDQpEb2VzIG1ha2luZyBpdCAnc3RhdGljIGlubGlu
ZScgYW5kIG1vdmluZyB0byBrdm1faG9zdC5oIHdvcms/DQoNCmt2bV9yZWdpc3Rlcl93cml0ZV9y
YXcoKSwgYW5kIGt2bV9yZWdpc3Rlcl9tYXJrX2RpcnR5KCkgd2hpY2ggaXMgY2FsbGVkIGJ5DQpr
dm1fcmVnaXN0ZXJfd3JpdGVfcmF3KCkpLCBhcmUgYm90aCAnc3RhdGljIGlubGluZScuICBTZWVt
cyB3ZSBjYW4gZ2V0IHJpZCBvZg0KZXhwb3J0IGJ5IG1ha2luZyBpdCAnc3RhdGljIGlubGluZScu
DQo=

