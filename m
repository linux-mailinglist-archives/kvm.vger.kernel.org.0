Return-Path: <kvm+bounces-50915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 981DEAEA98F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C96B3A505B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4D82641D8;
	Thu, 26 Jun 2025 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m27d+Ujq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12322397A4;
	Thu, 26 Jun 2025 22:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976475; cv=fail; b=lprKWQxsqF5xbi4cgxa6Rp8trQCv8oEUomAbbpDGwiiPl2JCOmVlRluG7L9w3HOG3RP8EaviQY+i1OAi7YTIx+FwNw4w2Ioe6B+Z6hveU3Dr72EjUde8xBLcYPG5TiV8MqSTXNItfQrtzpapbEcl814CgIMiYWcduLkE533G1Qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976475; c=relaxed/simple;
	bh=kFm8li7lOmEvi9OoVEn45GQhWfDkrMJw4vQVep01l38=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jvhTP9ynk24rkYIuQo1Zal8EtepdKsqdfwgv3iHe90foljfxuqlCdFppGFb27ZiIlPErAcrvRazd8lOV5seDQPyirdZJtuVh1DiQLrgHuoMauy2mgQSahCJbHd9mJy/STsxuTK7OGBP/UE3XzJ3JuK89xrJCvWzlyxJwDn8Deb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m27d+Ujq; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750976474; x=1782512474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kFm8li7lOmEvi9OoVEn45GQhWfDkrMJw4vQVep01l38=;
  b=m27d+Ujq43ZTKRi8CDsg8ndnaJQQJlo7qqbp7h4Lkgb7yZtpeBuQ4CSe
   cwEdbcyaXfFu3tvFPgF3KtaayO5hdRujUiIBfvU72GlYS5HeIM1YNU4zb
   gg7ksSNrHRDFsMuwLgJWdJjdheoCvcVEdk7GyffmBuqh0QwWLcCqxg9cq
   Yp+uCS7Xdkw6A68Nqy6snoTPvmKhZExDuZhQkSqvkcSn34igurFlJFo90
   M94Fqf74LschFJRwbj4VPcl2fEHCZNG10kXWKzZdu32mGKiidjjxZk4pY
   RVqMv/+rd7gJBMpQV97ix57AyxgWBUCbIr9iwUTGz/9rBKDCVJM0ueztD
   g==;
X-CSE-ConnectionGUID: Wr5AITziSNqz06l58r55aA==
X-CSE-MsgGUID: thuMFoDSQme2+xz9USKQcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="55909562"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="55909562"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:21:13 -0700
X-CSE-ConnectionGUID: TuFXMBjxQOeQYDV3CR6wpg==
X-CSE-MsgGUID: MG667vTFRqWqyk2tYrLqLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153141024"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:21:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 15:21:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 15:21:12 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.83) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 15:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOyUgorcngO/b+nk+x8a+0y3sKqfib2Z7l3vEFpWwDCBx6JvEpyc8Gr34RDaPgE+7ZjYc43CkmgCzZt/1Mahso3gwdh+9xXS0FsCzinq2tLlEfufiUH/quxkbkxQoAU5P0UK9KwOrJCfykar2RJt6fKEFTJkneu78eCPmo9xhGDV6RTJW9uEfkPt3zWYn0K9S07kuG+9jTtm9d/eTrrU4e59tkEUXgWvkJnDcY83hFJRIL7voPJwwHzZPO42SEWp/qdxu4vIeEIeVuQJLdycn2/J4mx8UxKmBtEAOh3KF7ptsTe2u95/vfzo/qf7NGINLgqkERbZIP++HBlkqL1TQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFm8li7lOmEvi9OoVEn45GQhWfDkrMJw4vQVep01l38=;
 b=p9Gh0JPKnlRgevrbT8K43uVZf3oz8PLhps9mqkDda83z1RYLPBwtizSpH1hTspRN547B1cZoh6u4IH8OnCWuQqYWgbHqPp0SEZ2eTKp1tRjfgGl5yGrMCcHv9GOjnrz/6Zv4Z7Jqtp3Nf1Hc62/oz6XB+mvvZzBiec+81Aj+fJDftZONq5U43bOsdUUzu0CduUvM8iKsy0QPGaKl05BwD3uSSl/5ixy+N3tKC/2oaPQpGkDA00cIiUczH+EFi+3ovGjaRawcRVDtzNz2qlh5bmDc/npmiiAOkc/6mqEphGvJYSm4hEycFHI8a4QWoLnnhGUbbXSbSBtLIPyR5Y5GXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8536.namprd11.prod.outlook.com (2603:10b6:408:1ec::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Thu, 26 Jun
 2025 22:20:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 22:20:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDpX31F9fykECcZZx9vdaxeLQJAkSAgAr5c4CAAB9IgIAAZo+AgAABkICAAC0ggIAA7dQAgAByfAA=
Date: Thu, 26 Jun 2025 22:20:53 +0000
Message-ID: <f51e62543aa765da3b4f4ed19aa13340881fbc89.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
		 <20250618120806.113884-3-adrian.hunter@intel.com>
		 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
		 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
		 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
		 <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
		 <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
	 <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
	 <DS7PR11MB6077ED08B85A000014BDAE00FC7AA@DS7PR11MB6077.namprd11.prod.outlook.com>
In-Reply-To: <DS7PR11MB6077ED08B85A000014BDAE00FC7AA@DS7PR11MB6077.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8536:EE_
x-ms-office365-filtering-correlation-id: 390dfac9-bffc-47a6-6dab-08ddb4ffb703
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cWRHaWVrL1dEZTF6dVh4ZStBazRPckNBSFNkRDIzRmY3NGxrTXZTbDgzc1pZ?=
 =?utf-8?B?WlVqbkFLMGtPVVQyRndRTk5CZTA2K3ZKN1Nrc0gyRVVJWnpSaFM5NTBnQmcv?=
 =?utf-8?B?T0o3TTVGcDdGNTBZV0YzQjBzeEQzOThEY3RhdWphOUo2aFFrWkl5YTdYR2F6?=
 =?utf-8?B?eVErVlltSDVyTEQvay9UbDNmWlVLRkJHQVVMZlRjL0M1RU5xYXpSNmZiVk1U?=
 =?utf-8?B?V3FJRzc0ZUFMbUdQOVBzSFJHMTA0bnIyTEQrUi9jR2JpOHBUT3pxMnR6K3h3?=
 =?utf-8?B?ZnRNTkp3eGluSFV3dkx1UWI5YTB1TTQvN1lxWi92Z2pVdkhBNFZxb09YVElG?=
 =?utf-8?B?ZVA2YldHUVZ2dVpPYW1VbGFValNjWVJONjQ1RzJkdVpNUGxUNVQwcGhBVlY2?=
 =?utf-8?B?NmMwK3phZUo5ZFFEdE0rZ05NWDN3bVpuTHZWL0h3RHkrUEQ1ajNMYTFsVGli?=
 =?utf-8?B?MG1FN0ppZkVJbW9rMUJYN1NjU3BQeWlzVWxQbnVGcXo1YmNEUWpWck5MUldk?=
 =?utf-8?B?ZlZkZnZhdmZqU1pTck9GMkNnT2d1VzE1TjhZeXk1TU5uS1BrVkFRaUJCK1RT?=
 =?utf-8?B?aXZOSXRkOHg3eDNqQU5SR3hHYi9ac1c3Q1VMZlllM2MwQ1ZRQUlZbE0ra2J5?=
 =?utf-8?B?REQxWE92SU1PTzFycVhxUEU2RVBkQTF3emhYMHplMkZ5UGhiaTd2QVRhQ29p?=
 =?utf-8?B?SG1jU2xZTDV3MmcxWXc1K25VMUJWYzArSmI3Y2J2U3h3TEdDOG1tTldxR2R2?=
 =?utf-8?B?V3JoQlJuZ2hja29uaEcyaWl3dXdWR0VhTEdUdWNsNDBmSzM5U1k4QzR6ZUdN?=
 =?utf-8?B?WDk4S2JscENtTnpOYjByczlMVnZmaERaSGMwbW0rd1RJYnBPUlVzdk01dEY3?=
 =?utf-8?B?Qk9FVkdOUjZlSUFhNkhpa1RzTm9Ud2RPZlJuWmJqSGU3Z1JxbllsY3B5d210?=
 =?utf-8?B?di94WlUzc2ZFYjI5YXZobnRlZmJDN3E3eUFkbVRGQllrbkU2aHlubXVyU2Jp?=
 =?utf-8?B?TWh3NDdrcm82ZVlrd0xEMzY3UDlNZnp6VTBKdTBnOEtwa3liUjd3WTE2N3hC?=
 =?utf-8?B?VHhTOUtXTWp6UXRWUlI5Z1NHYTAvVVZUS2tTSWNQY3lVRmdrcmtUd0h3OWVW?=
 =?utf-8?B?ajd0YWlCMVE0dTQvT0NqR0NNZTFublNnQTByZjJXajZKa2U4dzE4UW9waGtY?=
 =?utf-8?B?bjBHdUdWODluM295R2RySnhsZjMyWHdRakRKc09KSmNBQUFpVFZUdURrMGd4?=
 =?utf-8?B?cjJ6a0k0b3ZrbE1BbXN5anJ5TkE1RHNZYmRKcU9jU2NaaFJmUDNLM0piSUFI?=
 =?utf-8?B?L2FycGhaVDhOTmtBYXhrTEFFanIzS0p4Mnp0eU1uZWhkMnpCRzJQY3NlOGRw?=
 =?utf-8?B?cmNhVXczMGpSSVZRdXRIbklQVjRsODNMWXVHZGsxejlTamU2V0EwK0NoUWg5?=
 =?utf-8?B?dnB4dzdzZG9RdXVFYVlNbXNnNFMrZFBNaitQMDZld241alo0dE83em9UTnZ5?=
 =?utf-8?B?RklFeEYraXV3NE9sMDNleC9FYVFsSUlCV1N0VXNQa3YvcFF1YldoZTVlV2wz?=
 =?utf-8?B?ZVl2Zk02Vk5DZDdWZFl3ank0OVEyM1ovZDg1RXJIYUZmSmdsVVRQU2RvRkFR?=
 =?utf-8?B?Y3U5V2FkL00xNzdHNWw2WkkwT2llK0VOTm8yankzQjltcDg0Q2p6dGVONVZ0?=
 =?utf-8?B?ZjR1SHhDcExieXZNdTBPZS9aZmRsNXNFUEtrRHRmWG5KMjJiYmJYQ3VzUG5p?=
 =?utf-8?B?K0x1c1BGeHdJWi9MSUVPTlZNL2NSbzBzRXVnYnBnQjRCaGhkY3NUZlRjVmFE?=
 =?utf-8?B?RWdWWUZXbU4yRUg5TXdzVVhkTGxPd1JwU3h6MytTaWRCa09wNExIZHh0Y0g2?=
 =?utf-8?B?UTdNcnN3Ni9tUGxCWENFYzlCdDVhRkVMRlNwTHgyWUZuVzF4TU9nWldYb0Jk?=
 =?utf-8?B?NlBxQjc4V01OSHRETjhyTitYenFVWUJTRWhxU2tGZ0NwSldtWlUwaFF2dlZl?=
 =?utf-8?B?UEtUa2RGd3pBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2ZuNTU4RlFVVWVJcDRlcE90Vm9pUXFnWnZ4NTJOdit6V21MeDVNS3FBWW5L?=
 =?utf-8?B?bXQwblJPUEtydWJ2YjNVem5kQzJhaFFhZ25Gck40dmtoampxRmdmc3VyRXJo?=
 =?utf-8?B?Y0F2b3R5a0x3V1dTTnhybndVWkdLYm41NDFNN0dkSEdDOE1kZnd2N2RvYkZM?=
 =?utf-8?B?R1BSajB4NE04WllOUkNxUUdEdkVzb2o0WGpFZjgvNzRRSDNUcEphSENUR2wx?=
 =?utf-8?B?M1BUYkx1UCtpRGVnNy9xUFJQR0VIN0JZQmltVWRUWVJhQ25Mck4vYjJxamxm?=
 =?utf-8?B?R2dDWjFXNnk4TkkydUtmR2dFSUMvOVhqanBZOFJEM0Fja2Y1clRzaGFtYVcw?=
 =?utf-8?B?RTJqbWlWbkxzTTJzU2hLWGV3RGgvMytnL1RwUGFwVlBLdGNudzZOcEJudElh?=
 =?utf-8?B?OU14bFpZVTFBeS85RlBPNk5LN3V4aktLOVN2UzZVWmtLVzFCQ2pQNVR4cmc4?=
 =?utf-8?B?RUZGNVVaelA4RVd2dnl2UnV6bGV1azRaV1hBYVlDcGZqTHFXV3RiTU8zckg2?=
 =?utf-8?B?ZTA1bDBqaWUveGRnV3BjVzBHcVI5ajhnSVVSWWlvRG5BWkUxU082UnlxVWlU?=
 =?utf-8?B?alVVWWxyTWxRMnNzVmg2MEEyUFhzU21iNldzYTdtamVRdzM5dVB6cmNMMXRR?=
 =?utf-8?B?bXhZUWo2dkU4c0tzU21UQnhlSklxVkFGNEc1ekFvY0xuQlNwYlBVb29uQmQz?=
 =?utf-8?B?a2xyU0djL0pKS2NTbDBnSUdLMGZ3d1crTWxDajA4V2F0SWcyVXc0ME9pRHow?=
 =?utf-8?B?MTkwc3VtYU8vY1RpOUdOWUtLcC9CMnAvQzB4R0NyR1VvZzFXRW5FSUJqNEJ6?=
 =?utf-8?B?TElqeWFRdWFQMG9nZWkzUjk3Q3ZrVkVqSkRhT1FWb3dYc2pSOFZSR1F6d0sz?=
 =?utf-8?B?WnlReE12Y0tjZGd4THNSWTU1WHZ4QTUyQjZZVmVZdXlWemdHdWQ5NzZsTUQ2?=
 =?utf-8?B?cjlvKzBWWkRBTk9XNDlwZjZXbnFQcTZsT0VKajkwQnNMVG5HRTZRNFJwNFdD?=
 =?utf-8?B?UnJYNmlZbndQcjRnN3hQV0QwSnV4SHM2OG9XWmc1NmZweVBKNUt2S0xiVXlu?=
 =?utf-8?B?aTNIMzFPVkliMVYrdURoT3JKU1NQSVR2Y1FzZndzeGpSNWwyWVBxUVI2dXYw?=
 =?utf-8?B?L1Z2aitySG9xM0hyZWp4RFVjcE9XR3ozd09Kamd1Z0liODM0Z0Q4Ymt5N3BG?=
 =?utf-8?B?RXM0NkVSYTdBVVI2dzFqNGhPZmwzNXk2a1hBSXQwYXcrblFGS3prVUYyM1NT?=
 =?utf-8?B?clNDb0tqMmJ5R294ZHRQNkF3YTJuZFo5TEV3djhXWUxZcGZoRmNlL2swazNV?=
 =?utf-8?B?TEU1THA4QzV0bFVhanRLenQvTmx1am5DbTZlRTZLSy9zR1BOWUN5SE1Zc3BF?=
 =?utf-8?B?K3B1MUpXbkh0c0lnaEFlNmhuaTVFQStKM0MrRVJhSm5WMGdvNkZobHhXd09n?=
 =?utf-8?B?Ry8rUVBtTEphL2FrdGlZa0JEUFpqc0N4cTBQNklwcnhVeGk4a0NOL3J1NDVO?=
 =?utf-8?B?RWllb2sybDJZVkFFd0wzRThoQmdqV01qUkhDVkpQN0s3Y1VMR2pPTTE0Yk40?=
 =?utf-8?B?QXFvU1RBQWJwTU1HYVlHdHNzM1NINWdlanBrWU5XSk92b2VBTWI0OTJKbDFs?=
 =?utf-8?B?S2xQSzVub2lkckRIQTJ1MDFpZHh6ZEZkR01JTXIwSW0wTFZBVlJpWDBxRjB6?=
 =?utf-8?B?aFRLL010aTVjMVZid1lUa1c2bHdPS0UvMFlwR3ZBTVp6aUVCSWtkZkF5dU0y?=
 =?utf-8?B?UVhnN05mNU5BRU1TNFg0RjlWeTQ1a256RmVHdUxHWlFkUmhrc1djUnJ0SU1H?=
 =?utf-8?B?V2VmWENkcTE5b1U0L09GWFNGRHM1VUZqbGxpV0NsTlhWSTE4ZkdlNGF4UmhY?=
 =?utf-8?B?RENqa3E4OFFoeWNDWEQvdGdYQnN1QXlHNkZ2NjQ0RUYrV3hNbUgzc0ZVL0hr?=
 =?utf-8?B?MUNHU1J2SWNsWlhLR0ZqRWlBVUpBVkkxTnFlUXY4VGZkbmtidDhsL3FBOWdJ?=
 =?utf-8?B?ZTd2bHZSaFFodXd6dVpzUW1xSzZTU21PMlQ2UXB3TE9XdEtlVzVvQURjUFNp?=
 =?utf-8?B?cUQ2dnlZSEhQekVyMytBVVNUbXU5aEdUc2w0ME5TRUJHNDNIWEUyQXp1N2xi?=
 =?utf-8?Q?KXlq05LZCMOqGCuGL7lQ9F1Ui?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A04444D44D3DFD4FBDD962D5B478363B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390dfac9-bffc-47a6-6dab-08ddb4ffb703
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 22:20:53.6033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j/coUYxsWqlwBdXjKFwtmjI9YX87OE/PX3YWa1aJgNJUqxCkSqgTxUncOgVWNDB76/R06gbkNJajrKH6285MAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8536
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDE1OjMxICswMDAwLCBMdWNrLCBUb255IHdyb3RlOg0KPiA+
IEhvd2V2ZXIgaWYgdGhlIGtlcm5lbCB0b3VjaCB0aGUgcGFnZSBhZ2FpbiB1c2luZyBNT1ZESVI2
NEIsIHRoZSBmdXJ0aGVyICNNQw0KPiA+IHdvbid0IGhhdmUgTUNHX1NUQVRVU19TRUFNX05SIGJp
dCBzZXQgKGJlY2F1c2UgaXQgZG9lc24ndCBoYXBwZW4gaW4gU0VBTQ0KPiA+IG5vbi1yb290KSwg
dGhlcmVmb3JlIGl0IHdpbGwgYmUgdHJlYXRlZCBhcyBhIG5vcm1hbCBrZXJuZWwgI01DIHdoaWNo
IHdpbGwNCj4gPiByZXN1bHQgaW4ga2VybmVsIHBhbmljLg0KPiANCj4gSW50ZWwgQ1BVcyBzaWdu
YWwgI01DIHdoZW4gYW4gaW5zdHJ1Y3Rpb24gdGhhdCBpcyB0cnlpbmcgdG8gY29uc3VtZSBwb2lz
b24gZGF0YQ0KPiBpcyBhYm91dCB0byByZXRpcmUuDQo+IA0KPiBTdG9yZXMgdG8gbWVtb3J5IGRv
IG5vdCBjb25zdW1lIHBvaXNvbiwgc28gd2lsbCBub3Qgc2lnbmFsIGEgI01DLg0KPiANCj4gSW4g
dGhlIE1PVkRJUjY0QiBjYXNlIGFuIGVudGlyZSBjYWNoZSBsaW5lIGlzIHN0b3JlZCBpbiBhIHNp
bmdsZSBhdG9taWMNCj4gd3JpdGUuIFRoaXMgd2lsbCBjbGVhciB0aGUgcG9pc29uIHN0YXRlIG9m
IHRoZSBjYWNoZWxpbmUgKGFzc3VtaW5nIHRoYXQgdGhlDQo+IHBvaXNvbiB3YXMgZHVlIHRvIGFu
IGludGVncml0eSBlcnJvciwgbWVtb3J5IGVycm9yIGluamVjdGlvbiwgSS9PIGVycm9yIGV0Yy4N
Cj4gSWYgdGhlIERJTU0gaXMgYmFkIGFuZCBoYXMgc3R1Y2sgYml0cywgdGhlbiB0aGUgbWVtb3J5
IG1heSBzdGlsbCBmYWlsIEVDQw0KPiBjaGVjayBvbiB0aGUgbmV4dCByZWFkLikNCj4gDQo+IFVz
aW5nIHNtYWxsZXIgc3RvcmVzIHRvIG92ZXJ3cml0ZSB0aGUgY2FjaGUgbGluZSB3aWxsIG5vdCBj
bGVhciBwb2lzb24uIFRoZQ0KPiBjYWNoZWxpbmUgaXMgcmVhZCBmcm9tIG1lbW9yeSB0byBzb21l
IGNhY2hlIGxldmVsLCB0aGUgc21hbGwgc3RvcmUgdXBkYXRlcw0KPiBzb21lIGJ5dGVzIGluIHRo
ZSBsaW5lLCBidXQgdGhlIHBvaXNvbiBmbGFnIHJlbWFpbnMuIE5vdGUgdGhhdCB0aGlzIGRvZXNu
J3QNCj4gdHJpZ2dlciAjTUMgYmVjYXVzZSB0aGUgcG9pc29uIGRhdGEgaXMgbm90IGJlaW5nIGNv
bnN1bWVkLCBpdCBzdGlsbCBpc24ndA0KPiBhcmNoaXRlY3R1cmFsbHkgdmlzaWJsZSBpbiBzb21l
IHJlZ2lzdGVyLCBtZW1vcnksIG9yIEkvTyBkZXZpY2UuDQo+IA0KPiBZb3UgbWF5IHN0aWxsIHNl
ZSBhIFVDTkEgc2lnbmF0dXJlIHNpZ25hbGVkIHdpdGggQ01DSSBmcm9tIHRoZSBtZW1vcnkNCj4g
Y29udHJvbGxlciBpZiBlaXRoZXIgY2FzZSByZXN1bHRlZCBpbiBhIHNwZWN1bGF0aXZlIHByZWZl
dGNoIG9mIHRoZSBwb2lzb25lZA0KPiBjYWNoZSBsaW5lLg0KPiANCj4gLVRvbnkNCg0KVGhhbmtz
IGZvciB0aGUgaW5mby4gIDotKQ0KDQpTbyBpdCBzZWVtcyBNT1ZESVI2NEIgdG8gYSBiYWQgbWVt
b3J5IHdvbid0IG5lY2Vzc2FyaWx5IHRyaWdnZXIgI01DIHdoZW4gdGhlDQp3cml0dGVuIGlzIHBl
cmZvcm1lZC4NCg0KQnV0IElNSE8gd2UgbWF5IHNob3VsZCBqdXN0IGhhdmUgYSBzaW1wbGUgcG9s
aWN5IHRoYXQgd2hlbiBhIHBhZ2UgaXMgbWFya2VkDQphcyBwb2lzb25lZCwgaXQgc2hvdWxkIG5l
dmVyIGJlIHRvdWNoZWQgYWdhaW4uICBJdCdzIG9ubHkgb25lIHBhZ2UgYW55d2F5DQooZm9yIG9u
ZSBURCkgc28gbG9zaW5nIHRoYXQgZG9lc24ndCBzZWVtIGJhZCB0byBtZS4gIElmIHdlIHdhbnQg
dG8gY2xlYXIgdGhlDQpwb2lzb25lZCBwYWdlLCB0aGVuIHBlcmhhcHMgd2Ugc2hvdWxkIG1hcmsg
dGhhdCBwYWdlIHRvIGJlIG5vdC1wb2lzb25lZA0KYWdhaW4uDQo=

