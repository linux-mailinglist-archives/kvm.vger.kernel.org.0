Return-Path: <kvm+bounces-18089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E0F8CDD58
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01B941F2114C
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 23:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E526F12883A;
	Thu, 23 May 2024 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lYz8KZNf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5119F126F27;
	Thu, 23 May 2024 23:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716506054; cv=fail; b=hdw3DIgOdCyXK36dV2WDIyOpYV8BUKWtznvdjOdDtRsu3e4WoKby6XRNxqPCKdBJPeei2BOBOvLOQL8qMi3IrKtNoldyoMut+qzHpld3CH99wKH5w7DUBpssMTdWpPOMUvjq6j1+UFIRJ+BTu/2jyOhWG7n3vYcP4jNJycwTkCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716506054; c=relaxed/simple;
	bh=oOtDVwz9C8JkKhmZNBkhXAnyMpAo80zBOgcv5hhTR3M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y5V4iX+4P/yfjhxDmWaxZ3Hf0zxWZUBiczD5pigSkBgfNSWiJXIv3MofPBmpnDpKeqSfYXkCUkMHRaCA8jWjkRoCH/Xgmf055cYh7GX+9c3AhvOmwhihXPamf9kqBrglgK/wDbvp+vKbtYfuPPw5OgPdGaT14TPD149D35Zuonk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lYz8KZNf; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716506052; x=1748042052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oOtDVwz9C8JkKhmZNBkhXAnyMpAo80zBOgcv5hhTR3M=;
  b=lYz8KZNfutlycJCT+q+x6PgxjchwABLNG+vToERMqdntq9J7fZ/DaD8K
   uQBViAa6ElGbj2jCttnGsKobZnBbplM6tdA8ZAzYQuDok+eQy+Ttqyw3X
   37UNedDElF8OOVFm20UTIvgP3eA2/COe15oX1DlRlhDD3MWgCprjtqSuT
   zrWo87Og6ax8yhXdcbHmsqZXkHZF10aCiLotmcnWJbJjXTX2GWpx/wTJf
   RnJVvuvQAxgVMMtl4vI1dRVaVYAagxrbm9X2JASux6TtUni3AyEIwN/ra
   cCrZU55eiXd2UwJEDE+jVOsroGVhQdCKdWn3JvMmuMlTHwonrOlMSCzi2
   A==;
X-CSE-ConnectionGUID: TN/yI+ViSca3NjLaMIf9gw==
X-CSE-MsgGUID: IBIiBdI3Q+uwwQXgn4pEYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="15804377"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="15804377"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 16:14:11 -0700
X-CSE-ConnectionGUID: Zg7wtjP9R8KZL2msafhKEQ==
X-CSE-MsgGUID: 461PlWTOSKqtoEH3gchUfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="33704824"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 16:14:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:14:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 16:14:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 16:14:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+4gT50la6iAw09Do4uXBMLgI+TqVsgmbo5toZMGinofzvpZnP/M/LcYOiaS5DFtSDW9Bn5dgzbLNrMCAHmOR1vIvhefDoTqnpk1r+s0gg5sRMyR31j3fe+qxfl/8wSAp6N27KaR6z5sZpt0X8nwV9tEiznSvcDNGZNLfIUjLN/t33R4Bdyh9GSNTFHBxthW8ATG8ZaKVK71f4mXUgU0r2PKQazYxEMzWMhmupWkru6dxHHrzEnpbjaz1ID7LIBI9Wcl9oAARrgQ4LOY053LjS32whxZ0RkNKGuDd8+dPTGljQqQ3VNAU8KqsT68wWA+ddtyiakBhLjTvJHVIT9muw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOtDVwz9C8JkKhmZNBkhXAnyMpAo80zBOgcv5hhTR3M=;
 b=obt3AdqxwGh71doPncc2+47I1L/KyRG39o9vAkKm0yV2vt2iuxzjJB1LoM0lPkc2XchSFTaKdSwb3gb3TQ4irVLYTv1y1yQ1+8jnjk4C01a1HjCuCQyNHVKGcQosAFpl8cvL8z1VIV2DGVE3AskAAng7CnKrwcIz8xNTw5dk/NZTLdOsEMDDFWse+86H6cJDyVVuuvMsVMPGGKfWvXsnaMC458ygVMqQNoG9b2/yPJQ5/7ggfKo6wUjbzQ7bGnoRGm2bBt6e23f3t8E6bJFtuD85omzvU7n+1ghF8zGcmyrEJbqK7MKajQM4/keRnkDBq5HBmGRc2W228Z9l9Exb2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4642.namprd11.prod.outlook.com (2603:10b6:5:2a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 23:14:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 23:14:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GlgQuA
Date: Thu, 23 May 2024 23:14:07 +0000
Message-ID: <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4642:EE_
x-ms-office365-filtering-correlation-id: af727a11-2eb2-40d1-26eb-08dc7b7e0c2b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bWJIaFBVRUs1aDc5U3hzcGl3YXNKdjlQYVBFWm9lYTlrOEFOa3lxUGFtWWlP?=
 =?utf-8?B?V0c3YUcyQ2NyM3QrUzhpSzJxblJZVXVUdk9ENkVBZU9ESjJiS2JwRVhpaUVt?=
 =?utf-8?B?enRpaVk1UzRkNTE1dkZOMVc2dE5Edm1SMUR5b3B5cTRPajR5MnpRMUhWNUc1?=
 =?utf-8?B?V1V6V2Q0TXFLSG1jVWx1R015em4waXl6b3loZGtKQ1FqZHcxVk1lNkhiY0VN?=
 =?utf-8?B?S2IrMzVYUXpFUmJpcFV5SUpQZjdhMmMraHF4eUZjMUU4ejJRbWliQyswZjM2?=
 =?utf-8?B?NFUyeWVoU2o2azJ1bmtxRU9DQWNoVUlOV1JCUUdDOHY3Z0doWUw5eE8xMWVp?=
 =?utf-8?B?TWNUYVE3aUZ5WFZkRFlYeHhaTU1GTlVLaWpDWW9MSWt6VTllUVR3NUw3eFN5?=
 =?utf-8?B?bm9PN2I1MTVIb2lwNnV3ZFQxV1lUbmZPYkVFSnNRWklGZ2pTcnFsUlB0ak5G?=
 =?utf-8?B?TzlaVUthZW52R2M2UCtOcjBUeUQwKzIyWFo1VkUxZENUSktmekxaWEtnemNM?=
 =?utf-8?B?Z2FWQ05HdENlNS9JL0FFa1lDcjdIbVZaRHkreWlwZ3N5TFdnR3hlcWg3R0hp?=
 =?utf-8?B?UDQ2NFpIUnJ4a1ZXMEJrTk9TeGEycHM4NmtLZ3BlV2F0QUhjK3lCMFFXZElE?=
 =?utf-8?B?OWY2dUliNVdFSmRZTFRyeTRrN1J5bm5OekpNN3M3QkxKczNaYUtadnZBbDRF?=
 =?utf-8?B?YzFZRzcrT1ZXOXdFUzY3ek9DY3F4dGVmSWxVbEhZcGNLQUV6RXJGNGVKNmdY?=
 =?utf-8?B?SHpnZ0xGc1JkTm5VYjUrZjI3elRiQ1Rzb0N4bXg4bTJieHBzZlJaSVFqVG1N?=
 =?utf-8?B?QXh1NVdHZlkvd0ZhSW1VNzQvZ1VYbUl5dG11NXBRUzV0LytRQlpKUzlUVGdN?=
 =?utf-8?B?MHRNYTRJeHRHYVF0dXpnMGl0ZkZYQ2ZDNDlSUEFvYjBKT2ZrWHpOWjhwNkt2?=
 =?utf-8?B?WUlpNVROYkJyTXFvQ3ZkamYvMUNPS09pWnFiNDdRcUlodFV2M0EzQnJVR1ph?=
 =?utf-8?B?WVVnMno2S2FjS3BUUDFtSnRQSW5QZ3kvOGg2Sk5aSFV3ekExaHFPZWRsZWNQ?=
 =?utf-8?B?ZXpOcE5xY3hCdTFkd2NJZzJXUHE4OWd4Vm55K055bFphNUdONE5LRGFQWSth?=
 =?utf-8?B?V1dyRGd4Y1I5dTh1R0g4aHJuSmJNZWZjRnRVdW10SVNSRDZLRGVyVzdpcC9y?=
 =?utf-8?B?QllCVXRVZTQ1VitnbjQ3dkZsalAxb1RwVWdSakZQR0p3ekhZcTFXc1JsQ2Zq?=
 =?utf-8?B?R2t4aTZOUVl4TkltbFpGbHBIdUl6UjgxSVlYWHhFRFJFVXE3ZC9tMzN2Vnk2?=
 =?utf-8?B?YkJpOTBEbFRzTGNLTXBsV3UzcVhxM2c0bGxleGQxREh2SFdublRDOHB1cTF4?=
 =?utf-8?B?a2tzOGZHalhIWkRPOHRRUTNWZk5YTmxXWWliMmF4MEpub21RWTBrVnd1OXNU?=
 =?utf-8?B?Yk1mejk1cXVLRnp2TVQvMDNsdisyVGdTU0lZdFpWZU1NZGwwZlgrcDhmQ2l5?=
 =?utf-8?B?K1p2ZjQ5bkloOU0zOUcyMmVKWXlEQ1BoMCt3WmF3SmpLZS9Cc3NUbmpEeVpI?=
 =?utf-8?B?WlFjWE1NbTFhbXpoZ0RzWnZqZHdqcEhYWVEvdkNveE4wS1hDdVA0RUN6K2xa?=
 =?utf-8?B?b0R2WU40cUpCOHdCdkxkeUdReHVKdU1EOVJNQWVZMlBlOTJSeUtMQnVLWnpT?=
 =?utf-8?B?cmxrRXlmQzdQM0ZTWWVZcjUzWXBpS20vZGl2c1hOaFZzc0grRWMwcGhTMWRZ?=
 =?utf-8?B?Z3d3cXdsYXZHVkc1RUtBOXdya0ZKNzUxdDVIdk96VEJrTERqWEFrdTFhQVNT?=
 =?utf-8?B?Qlo4ZUh0UFF5elRiamU5QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTBxeHRwZHZHQWEwTkhlT3NjM3VobjlyNWtHUm5ZQXFtVzZWN3NJbndsSUtC?=
 =?utf-8?B?YytnaEJQRFFLckxIZ0kwOStPVmI1cVhjZERDbnlVZi9KWjE1SDgwd2N3bTRC?=
 =?utf-8?B?bUdkMjV1b0EwSUNtRWoxeGJUd3F0UElIUUxYaWlySW4rMWxkaUpqNTFZZVJ0?=
 =?utf-8?B?L3NZZzFXZXZzUTg0em9sNThHOHJ3ZkRnbEErTXdEMVNXOHhkRnk4V2tWNGpS?=
 =?utf-8?B?SDA3RXNPTG4rL2tpRlBLaGt6bnRqQnpGZFQwZUZTSEVvTFczM1Q4OTc5VWdu?=
 =?utf-8?B?dVIzWHVIamlJVGdxcTVveUpPZmo0RjlaS0pWZEhyczY5UHhxMm83STlSVERs?=
 =?utf-8?B?bTJIUXo3UlFHUG5OZ1V2WjIvWnNtUVF3cVNzWERlYTVBSlg5S0g3ZW04YTdl?=
 =?utf-8?B?dGNseTlpZW1XTEVKUDNOdHlOQ01uRVFjeVcwRDAvcUQyUnNsVEJpZkFYN1ZY?=
 =?utf-8?B?VzRpeE5FR095ZFQyeUgyTHpHTzVuaUJqZnBJRktZWlg3T1FxV2NrdjlqS1lO?=
 =?utf-8?B?ZFZJV2d3K3RGakxHZUlkV0RNRHpQZHdHdmV5QTZFeS96SmVldnBZK0M1bTRF?=
 =?utf-8?B?VUtiUUlNWm80N2YyYURxN1Qrdk1hUU5wMG92cVZ1TkpKbFlQdVh4bzh1REhZ?=
 =?utf-8?B?cXdtQ2tvSkllUWorTGh5dC9TL2o2MGR5ZEhGUTBUOVUvdnpuaVJjaTlxd0w0?=
 =?utf-8?B?RXR4M0Z3RHlnYUFxVFhqQmhhYVZhMmh0S0tVWGkxMVd3VGpQcmtra0Y3YWNv?=
 =?utf-8?B?aFJ1djZsMDhPRFVVQnVSRThVb29vNWlMclVLWmRQRDczOGpMcGY1ai9RdGVW?=
 =?utf-8?B?NUh6TG85NE9CVjJGL3pCUzJEZm90ZmMwZ0o2bG0yZDFFRVl4UW1HaWVOZ1By?=
 =?utf-8?B?dVIyeWZwU2dTUGljMlJhS01DbVJaQ2c1MzhmRnBmNENlNExjajh3V2UzRjdp?=
 =?utf-8?B?NXB3RTBSMXpqV1Z1WEdhU0hVNWxERlBtdkNYQVdjbWUrQzNvK1JGMmFGQVFZ?=
 =?utf-8?B?SEN2SitqVW9FLzhKcHcvbTljL3h4YnJENGZoNk9LM0pqZGRxQno4YjVuWk5j?=
 =?utf-8?B?MUJaT3plaU5LRk9KL0cvcFNPZm5RbTIxVDcxMUN2OXZQQkFwWjdrNDlKeDUz?=
 =?utf-8?B?SjIrVHgrekpUVjZ0UG9sOW5UOVZJOTE5WWgrcDdYVk8zeUFlMXdZb01nNUVK?=
 =?utf-8?B?b1VhQ0M5VDVDeCt5RE82TDROYndMTVVqNndoN0hOWW53QWxvdVVINXJiUDZj?=
 =?utf-8?B?NUdWeGgrdTI4M00rN2QzQWg0Wm5DdXRJYys0dGNSNkJLSUxQVE9ZU2R4bXV4?=
 =?utf-8?B?UWZOZUl2Nk1vSjRkMXRyaEZzTlVWc1VDeENjSndMVVJzWjdDeDNCdlE0QnN2?=
 =?utf-8?B?MnJ6QlNjVGxOdkVKei9YK3pqYktWM2ZUWHloaGx4VkJoSmJuWkZZR0VuSjNY?=
 =?utf-8?B?SnhBUjBkYUtRK29NUUkzNTdPcXFwaGJxSFRTY2U5QnVjME4zaW1iUkNGSnRv?=
 =?utf-8?B?cUljYk55dW5ubXRzNW1jbEYrbGo5b2ptVHBXbkpTV0lJSUhWekl5SXpGK2I2?=
 =?utf-8?B?d1Y3U0QwUEhBTU0xVGE4empTcC9EcURUZ2YrQUJ2dk52b0JibVFVRVFiYTc0?=
 =?utf-8?B?SC82Znlma3dPSDBvbWtMQW9uREI5VHgvYzcxa05nMkZyRFhUZlhSMUtNdVVO?=
 =?utf-8?B?Vmt6bktUdHd2aWtTRmJjbjJUaktzencwUERyOFJ5L0xveGs2SHc1RHdRQUIv?=
 =?utf-8?B?eXZxVktDNnd4Ykl6OFNhcXNNZkdJcE1aNkN1VnFRdnJlMnFwRWROaUQyelFp?=
 =?utf-8?B?Nlc1c1YwNjZZd1FnL1RDK2M2bXJHTGo3VkZxMkxMVkEzNlBHTFNyTEdnaWNp?=
 =?utf-8?B?MnhvTVdxVlBGU3R1aUpaYTEzZTVhLzVRc2VGZEo3T0Jwc3h5aGYwTFYzVUdj?=
 =?utf-8?B?MXFuNU9sMHVPU2NnUUJRVzV1OUUzUTQ0R2l5SVNNS0lDa2MwNGgrbzE2VUwx?=
 =?utf-8?B?MTNUTzEycVdHcVRMRGRVeWZpLzBCSkJLaDcrc1RybGVmbHNaWFRpTXdSaGZN?=
 =?utf-8?B?RFltM3lnemdZbm1vRjJuL1dtOHNjeFVoNzlEVnp2QVRYbzVDemNWTHV1b01J?=
 =?utf-8?B?eHpoNVE4cTFmWjhPYUUyTWRqU3dMK2hqbzBjeS9hbFJ2ZG9sMFRCTVdJU3BB?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AC345B6258FE7498864CB846D3E6AC4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af727a11-2eb2-40d1-26eb-08dc7b7e0c2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 23:14:07.9660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P9u5lbsPdfC3z/a2b4AJZHm/ZvBPo/wRCsV0KMepPvNCqmqvkxTm0ZeKs+vsetiNjzm6qbg2wP9S2laOEowh5j460/gu7s6vvano1AVrjjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4642
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToK
PiArc3RhdGljIHZvaWQgaGFuZGxlX3JlbW92ZWRfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2
bSwgZ2ZuX3QgZ2ZuLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1NjQgb2xkX3NwdGUsIHU2NCBu
ZXdfc3B0ZSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW50IGxldmVsKQo+ICt7Cj4gK8KgwqDC
oMKgwqDCoMKgYm9vbCB3YXNfcHJlc2VudCA9IGlzX3NoYWRvd19wcmVzZW50X3B0ZShvbGRfc3B0
ZSk7Cj4gK8KgwqDCoMKgwqDCoMKgYm9vbCB3YXNfbGVhZiA9IHdhc19wcmVzZW50ICYmIGlzX2xh
c3Rfc3B0ZShvbGRfc3B0ZSwgbGV2ZWwpOwo+ICvCoMKgwqDCoMKgwqDCoGt2bV9wZm5fdCBvbGRf
cGZuID0gc3B0ZV90b19wZm4ob2xkX3NwdGUpOwo+ICvCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgICogQWxsb3cgb25seSBsZWFm
IHBhZ2UgdG8gYmUgemFwcGVkLiBSZWNsYWltIG5vbi1sZWFmIHBhZ2UgdGFibGVzCj4gcGFnZQo+
ICvCoMKgwqDCoMKgwqDCoCAqIGF0IGRlc3Ryb3lpbmcgVk0uCj4gK8KgwqDCoMKgwqDCoMKgICov
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCF3YXNfbGVhZikKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAvKiBaYXBwaW5nIGxlYWYgc3B0
ZSBpcyBhbGxvd2VkIG9ubHkgd2hlbiB3cml0ZSBsb2NrIGlzIGhlbGQuICovCj4gK8KgwqDCoMKg
wqDCoMKgbG9ja2RlcF9hc3NlcnRfaGVsZF93cml0ZSgma3ZtLT5tbXVfbG9jayk7Cj4gK8KgwqDC
oMKgwqDCoMKgcmV0ID0gc3RhdGljX2NhbGwoa3ZtX3g4Nl96YXBfcHJpdmF0ZV9zcHRlKShrdm0s
IGdmbiwgbGV2ZWwpOwo+ICvCoMKgwqDCoMKgwqDCoC8qIEJlY2F1c2Ugd3JpdGUgbG9jayBpcyBo
ZWxkLCBvcGVyYXRpb24gc2hvdWxkIHN1Y2Nlc3MuICovCj4gK8KgwqDCoMKgwqDCoMKgaWYgKEtW
TV9CVUdfT04ocmV0LCBrdm0pKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm47Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldCA9IHN0YXRpY19jYWxsKGt2bV94ODZfcmVtb3Zl
X3ByaXZhdGVfc3B0ZSkoa3ZtLCBnZm4sIGxldmVsLAo+IG9sZF9wZm4pOwoKSSBkb24ndCBzZWUg
d2h5IHRoZXNlICh6YXBfcHJpdmF0ZV9zcHRlIGFuZCByZW1vdmVfcHJpdmF0ZV9zcHRlKSBjYW4n
dCBiZSBhCnNpbmdsZSBvcC4gV2FzIGl0IHRvIHByZXBhcmUgZm9yIGh1Z2UgcGFnZXMgc3VwcG9y
dCBvciBzb21ldGhpbmc/IEluIHRoZSBiYXNlCnNlcmllcyB0aGV5IGFyZSBib3RoIG9ubHkgY2Fs
bGVkIG9uY2UuCgo+ICvCoMKgwqDCoMKgwqDCoEtWTV9CVUdfT04ocmV0LCBrdm0pOwo+ICt9Cj4g
KwoK

