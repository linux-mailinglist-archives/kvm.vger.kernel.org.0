Return-Path: <kvm+bounces-30106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B159B9B6DF5
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F5341F221B2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF92721767C;
	Wed, 30 Oct 2024 20:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JaUavop+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C5A1D12ED;
	Wed, 30 Oct 2024 20:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730320845; cv=fail; b=GLe2meJhfNTENcRyhlCj207CUQV2nGJ7WK+WGr5eAaRA39T4hjshInELeOszVntfuq2sdM9OYQpLvdupihjUrlFfJ6+yvNoTYqD4uEfFU5sT+JhLKkJHoHuJ7zangI/WtCq8EVKLoWjsZ6aMlfYmL0Rts7Iyt+0M7FT/6pGj75s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730320845; c=relaxed/simple;
	bh=jWfxvp9eQoeLstDgLsKOvMLj+dSyjgqwTERlVFAOflY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GLA+CkoRLHclP/8fLotDZsZ6dqudqRzBok8yv/FzFfFcIQ6TEw1Ol0EK3L6gjS/gZvdkhbd9brFBTczZSQ30xqlu2oqMfIPngqHHR97King1+DFNfpcqDlrXMOZtaCPmDNvqMTXo4eHm4SsNyRwtAbkA6ubfc9GOiD37VhzPnb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JaUavop+; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730320844; x=1761856844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jWfxvp9eQoeLstDgLsKOvMLj+dSyjgqwTERlVFAOflY=;
  b=JaUavop+4bUSsiLQYV9dnELjkA42meg3e0+LB9+h97GHSr7CEPpj/lM1
   2BQAIK+Saf5MBCMvyCzCsqu72Azht45/iEfoJaPanD1DG3tdM0yTNfy7I
   3WadnBvJ7PcC4AaI0xH0tg9NN6IVPvAp+b7hCcVX7fetSk0hrQfXocA/D
   3u2K3KE677DxJ5YDA7tia6cBr9l+VWMsGILh8KXCIcSxMKXm68NbPtYoS
   RYw3jlvhJVjMe2YbuCpFXc/4jVhALvOPp3KlkSkcPmoVUDLuYn1Zrp94n
   93TkmCSQBoDZyUz7aOsWeNVBe7Du7qIid6Jto2ttzv6Wda520qRtDGYqE
   g==;
X-CSE-ConnectionGUID: 4onecZ0qQUSWTmSr716hhQ==
X-CSE-MsgGUID: hFHZySOgRO2thBgDiNr19w==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="30149617"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="30149617"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 13:40:43 -0700
X-CSE-ConnectionGUID: cW7V5TMbQBWgIcFHS8KzZQ==
X-CSE-MsgGUID: quVHRTwsQWSM91iHYD/jTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="113282678"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 13:40:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 13:40:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 13:40:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 13:40:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDdtdOODa6KFXqXJWtct2hoGm3M/NnydcPY1skCxdC88c4Qi+6xrdYD/9dpu/WKdQvJfQiPDs8itfp592ddgxGb7hQQipiHOnQImPIPbOpycV4Lj4/sR9Eilvpa3dvxfFH+PpfoUkvEHFHDTIVw9oZI7enif8fvXmBIA1l+z9z5xyHLQ8Ye1yGLyan4kT6arpiFkuetLasdbNKSjrgJU81mu8ktgMW25IeL/4MFpC2/6MdF04Lry+ZhJRRqGtF4hhNJ0Rgx9jDphMsw5uGgY1Mrce54a8uJ5K+l421j2cd7KoKZm912VpGrK9n3WJBl4woNUO4JQOnUtS3Gi02ujGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWfxvp9eQoeLstDgLsKOvMLj+dSyjgqwTERlVFAOflY=;
 b=ugEfwlS5CfZn0KcOjWwsdeDlPdDLcqPFjVHPHsxRWr4nTAdN/4+uPdmr6IG9eoucLiBr2Vljm+0JIctxJbM5XpX/gdjrWvvaYLtt6Iz8oaPSNa58d751vsFzdChL6iPiGL799GBePqVOhPb4eHYV18YPplyquiY04tjPa9PL6VL8KXkuZI106/lN/0PdlkPoazMqkNOouM/6dxkt0LRHzR2fuPnI/pAvJvpGsJRxkhuhucvHV8IWoAixdQUNf5eN6WLPmoidV+d5yykC02oosi7UL0y5q37Opz8LEdB72uIg/vG7B5bbEavna45Dquhn5MkstHriupPOUtdnt5SHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6671.namprd11.prod.outlook.com (2603:10b6:a03:44b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 20:40:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 20:40:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kkiwi@redhat.com" <kkiwi@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHbKTUf1dSb4jQnekqD1cQ4TcWMP7KcfeAAgAAzjwCAAC3TgIACg8sAgABiegA=
Date: Wed, 30 Oct 2024 20:40:39 +0000
Message-ID: <38358a7ae5c63ab8dde35fd289df00819709eca8.camel@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
	 <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
	 <08c6bb42-c068-4dc1-8b97-0c53fb896a58@intel.com>
	 <6c8bff1a-876f-47b7-a80c-3f3a825ddbc0@intel.com>
	 <CABgObfZWjGc0FT2My_oEd6V8ZxYHD-RejndbU_FipuADgJkFbw@mail.gmail.com>
In-Reply-To: <CABgObfZWjGc0FT2My_oEd6V8ZxYHD-RejndbU_FipuADgJkFbw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6671:EE_
x-ms-office365-filtering-correlation-id: cafb919a-ed12-45ab-accd-08dcf9231d57
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWNRSXVKb2dUUGhoYXNzYU9MOEdkaTZMdzd2MGM4ODhpS1hFS3VjMEs3THkx?=
 =?utf-8?B?Z0ZUaHNNamZZOEVZVWpnOE9WSFZlU0hWaDFoeU45cUZjaFdsWGtYVCt4R2FN?=
 =?utf-8?B?MTU4MXpSWERBd1h5YitvQUlTUnNMeFFMdkFjcHd5Vk4wb0VNeWN1dXE3K2hL?=
 =?utf-8?B?SzlNL0JvbVBiRGMrd3dMRWZsTi9uc3pKSEJQY3RreGxYRk9TRGNvZWo0eWtW?=
 =?utf-8?B?YWptTXhoUHJPTG1ybTlMWldBSTdnaEJ0d2luSEJMU3ZLdXRkcFJoL0ZNbzN3?=
 =?utf-8?B?UGRyUW1Vb01ZdlNDcWdUYkJTTDRNSDdQa2N5dmJaSUdmaTk0a28yVjZkQ0FF?=
 =?utf-8?B?Vm5vTjAwNDRYU0RqRlRkaXBqYUQzSU9EVWdaU1NSK2FQWXcwU1I3ZVVONGw0?=
 =?utf-8?B?c3VVSnZ1dGxkeis3TytlaFBlaTJhS2VRWUtuWnM1VFpObUVXTjI0S2dlckdH?=
 =?utf-8?B?bWxodGVUZ1lHY0Jnb2VCVWZCMG0zMDJyTmU4MjByb20zVVYzMlR0cml2Smtp?=
 =?utf-8?B?VnVUY0dnbW5SV0FXM1pqcWlieU1BZCtaelBzYU5kWGM3WDJZL1Rjek5JTkVu?=
 =?utf-8?B?MmNuYnMyMlFjUnpQbXJoZVpVNm5zS3FjU3BvajFXYmtONGhVM3pWMlRocS8z?=
 =?utf-8?B?MGE3QjlRcGgrZFZjc1QxYU5hQkpuZGtWVHV4QThBRStQS0xYaGZUaXIweVVL?=
 =?utf-8?B?UGFjeFZScnFQSkNGSitNTWthaEpTQnp5YlBSbE5weGQ1cC9PRmJ2c1Nwc0dB?=
 =?utf-8?B?VElucWdycHBIeXc4ckxDZk1YekhPSzJuM3ZYRDdUSUw4UlJ5cXVjenhZTVhX?=
 =?utf-8?B?OFgxdVdZcW1RQUQzOGl1MkNibUpkZFpRQzlPVzFZbEg1Y0I5cElzTjdxNm1k?=
 =?utf-8?B?b1dRVjN4ZUI4Y2lGVXRmNXBhS3VqT1gzSktrUUxPbzg3b2tGSnZjVEFFK3gy?=
 =?utf-8?B?RkFFbGptckQ3UjZXaWJXcGRxNjlhZmhHem41TW5qOTdWQ0Zndy9NTmwyMDdK?=
 =?utf-8?B?SGM4dVE1TTR2eGc1b0dZdVVUVG9YSDZQSXBKUzVsU3U4MHNqaitNaEhXaHFQ?=
 =?utf-8?B?SGNJQkI4V3BYZ2VYcnQ1ckFPamFJbTlIMC95bm5qS2cxTlFZY1pHdzVZY0Nx?=
 =?utf-8?B?dUtFMVc0WTd5KzlkVEM1ZkVEbGZXMkZQZENCVEVyRGR0b2R0Q3NYbkVwV1Jz?=
 =?utf-8?B?Tm5tWWJnQ0p4dmtrOTljUEZUZ1dSYlVVcFc4aFhWSlYraGtYREhUMWphQ2R2?=
 =?utf-8?B?RGFRM2VwNG8vc0ZieS9sd2hIUlVYRXlMNXNtcEpCcW02TmJ3aXExWDZIeUgy?=
 =?utf-8?B?QkQ1YnJqYUFCQWdsdXRzQmUyKzVlbm5rNTRQNUhZb09BRHdMd2U0WFRwSVFy?=
 =?utf-8?B?ckZ0MFpBaFJuM2JHem02SmxGUS9mM1pHbGRZVHAxaXpheUdYbnlpSmpHKzRz?=
 =?utf-8?B?VW9sK2VPbksxc2dzTm1TMGk3M2ozTHljZVZLSE9JVmw3bnFCV2Y2Njlzc3dQ?=
 =?utf-8?B?RHg3Wi9XVXBjQ29qYjVQL0JydjUwTHhhVGEzbU0rcnZLc0RaNjBMb3ZFclM5?=
 =?utf-8?B?VHQ1VTIrN2JrNW96WGxmYmxXa29MZWZsNDVOTTNzTWdrS2NkL0lpaHBiU2ZK?=
 =?utf-8?B?Q1dJS1V0RG9LL1hLbFcxVEtKUGdEYnJlbFpwbEtPQlkzNWdmRnN6dXRrbjJJ?=
 =?utf-8?B?Mjk5RmpkZUVtc3lMOTB6dHB2c1Z3aDIyZXVHUFBCc2xoWUVoNWg1RXhuT0VY?=
 =?utf-8?B?R0E3U3hRamJTLzQ1QXo0ZGwwNG1KK1VMV2VMR0FJdTZ2WFBrb3ZncThVakM2?=
 =?utf-8?Q?xAeFppJ79IRAeel52bd0z6tIySaUbyjS48drQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHNJdFhLSjExc3FsdkY5QXh4SG5CbmpCY2ZHYXg0cTJIczVEelB3WXBtMll2?=
 =?utf-8?B?aEZCRU9ReVBtd1lQNEF3QlRDakRPTXRvaTh5WEZBeEtKei83a09PL0l2bmhO?=
 =?utf-8?B?Z1JRSzdXUnYxYjQ0cWNsME4vSmg1emxISlEzUmdVQ1ZKb1djRkNJaHBaOC8x?=
 =?utf-8?B?RXkzV2JEQUVrSFhqTTdCcVBkYW9uT0lBM3RHM2dnMU12MXFZMVl2dTBwMW1m?=
 =?utf-8?B?TWs4QnNMQU1IeE9aWWIwdUtoZFd0UDkvRDlKZWZOVUswOGJHdThpZFF0eXpH?=
 =?utf-8?B?dnBNaloxanpUUkRhK0tKQzRwSGlSczJ6SktZN0VubDJQVldnQ2ptUEpucG1n?=
 =?utf-8?B?Tno0eUJIanVnVWx0Tk9RTjI3RHJ4Yi9HTzMzSXh2blA0Z1VmQUE5cWJaaFN2?=
 =?utf-8?B?cFowa3gwZG9pR1o1U0lpV3ZLSW8yT3BaMHYxbm56dVNBd2V5eXFodWJiWE5F?=
 =?utf-8?B?QUViRWszYnlvNkZVa1pzRjFqNWMxQTlqUDFiVXFvWmwwN0I5QmJEcVQ1eEdz?=
 =?utf-8?B?YVZ1NEY4THpHK0hDcUJmVkxWZkhleDV6bDZORmVVdUJTbUZlWmFMaE9YL3ZQ?=
 =?utf-8?B?aWhodkJwdEZBYjg1cDkxYk9BdVlHMkQ5WXg3ZzVzeEsySGJ5SWd5S2pMdFpo?=
 =?utf-8?B?MUV0WFFjWFNlN2ZENWhxT3RRU3B5TW93elJjQXg5U0srQWtjRzBrVjNhRWVm?=
 =?utf-8?B?RlBQL1hoeWJlR2M0QjBvcG82a29vTFhtKzBMZjdqM3dTSnkvZkhuZFZRVG5D?=
 =?utf-8?B?KzJjWnd4SkZmUEhYZGNpVzV2Vks1L2tlV2RqVCtnNEMrNVNSWGVsQU13YlNQ?=
 =?utf-8?B?Sy9aeUdIQjVDejB4YmI3UDl3UXZvdENLWXhUcm9wMVFxbW1GRGUydFBpdERs?=
 =?utf-8?B?MFJUMFlvM2lRbFZnZlFWUzhiN0tGMEZIQzJOQzFxMUxidEJ1bTloTGY4Mld4?=
 =?utf-8?B?Z29selJCL3ZpbXlDMFhMa0d6YmxqOURFS0VVMWJOWkJIOTUxUzlFRW83b3E3?=
 =?utf-8?B?alV0UEVoWkI2K3hJa1J5bkU1eU5NSHNYSGxsNFFyb0NyQStJTGdxTkpEV25N?=
 =?utf-8?B?N21KTDJYUVEyckFlaDQrWnFzK0JkZTlwZVlwR3grNXNyZGQ3V1dQNTFoZjBZ?=
 =?utf-8?B?cjl4d1BwNUtLM092VUdpdER1dUY5UjlzNW1mMkR1Rm42YTVWWWx1S3ozbXpL?=
 =?utf-8?B?MHJ4S1JSdG0zejlwaWFhUXJXL0UvMEZhWFpEaG1nWjliNDg2VVFqbnNPd2NM?=
 =?utf-8?B?aVF1NXlFcmNQQitHK1hldjR5S2hXUHVrUVZrVlY4em9mM2NRbWFiSldwNEVS?=
 =?utf-8?B?bXRuUDkvWEpkRnp1ejJYTVRzMW1MbUhNQkZtMGtVYXFRRlEzUnREeDVIN3Bk?=
 =?utf-8?B?OXRyV3JHQXViNWVNOEM3K3BGN1ZrR1FBMmJtSFlGSVA4UDVrRkM2OHhTMWor?=
 =?utf-8?B?amVjNzlzczlpQXRNYWgwMlZLNUVtYVhUZVNiT08zZ0VDekhveVlwU2NpcElv?=
 =?utf-8?B?eTk0aUcvT1ZWOEpQSUl5c0ZYb0xuNVFsYlRKYTJ5bVQwb0dGeERKWjhUYmxU?=
 =?utf-8?B?SHRnMmY5OE9sTkRQd1pGSTJqV2lLUWUxWEw5Tzk5enRyQUVRSE8wMis2dGVG?=
 =?utf-8?B?S1pIemdZUmlod2h6OStubjJudUtZVWtHK0JpbUUydmhEd1QzNElxWU9nTFpz?=
 =?utf-8?B?VERhaHRQWWc1VjczNzFmUXJ3NEdEdEpVay90ZElJUE1WanhMaDF5b0I2SEFp?=
 =?utf-8?B?MEZjMGNqQ3RpejBrNldVN0JMOXliNjMramZ6TFduRmxiVEtabzFJdkVpQjl6?=
 =?utf-8?B?YjdFc3hvSC9KL0l5ekIwemV5SnpqWnd2THM0alN2Yks1L3UzT0dEZUtMdVUy?=
 =?utf-8?B?RVlIZ1R4NXJLNXByZUt4dXhiNEJPSlMvMkorU1RxQWttcmlGempKZmZQSXRQ?=
 =?utf-8?B?Y2lpanlkR2hsT20rN0dRdGtLM25rSlVrMktCb3lvL1N4RjFac0U2KzFMTnlO?=
 =?utf-8?B?MFdzMitWbitVNERMZWlnTlJLeFJybDdqOTQ5aWFzZzljZTJkVXhtY0g0RGtO?=
 =?utf-8?B?SXVYYUJ4VjBUVXAxRzVFdENIaDhHNWlSQmROMDVIamR4cWpOUlhWYTJHV3Rx?=
 =?utf-8?Q?oCO2Q2FzbVyfXBW+7fXdKKlYm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <496E1887FAD63E44BB81C14448A1275C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cafb919a-ed12-45ab-accd-08dcf9231d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 20:40:39.0619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBKZsgdOsAvkblOarOVOhdRXCPH7NFnOttOEVIe6bWiPhChvec5QE0V2Z/RvRSqzQBkdYNXqKE7CJ76A69G7Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6671
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTMwIGF0IDE1OjQ4ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBUdWUsIE9jdCAyOSwgMjAyNCBhdCAxOjI04oCvQU0gSHVhbmcsIEthaSA8a2FpLmh1YW5n
QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+IEFyZSB5b3UgYWJsZSB0byBzZW5kIHF1aWNrbHkg
YSB2NyB0aGF0IGluY2x1ZGVzIHRoZXNlIGZpZWxkcywgYW5kIHRoYXQNCj4gPiA+ID4gYWxzbyBj
aGVja3MgaW4gdGhlIHNjcmlwdCB0aGF0IGdlbmVyYXRlcyB0aGUgZmlsZXM/DQo+ID4gPiANCj4g
PiA+IFllYWggSSBjYW4gZG8uICBCdXQgZm9yIEtWTSB0byB1c2UgdGhvc2UgZmllbGRzLCB3ZSB3
aWxsIGFsc28gbmVlZA0KPiA+ID4gZXhwb3J0IHRob3NlIG1ldGFkYXRhLiAgRG8geW91IHdhbnQg
bWUgdG8ganVzdCBpbmNsdWRlIGFsbCB0aGUgMyBwYXRjaGVzDQo+ID4gPiB0aGF0IGFyZSBtZW50
aW9uZWQgaW4gdGhlIGFib3ZlIGl0ZW0gMykgdG8gdjc/DQo+ID4gDQo+ID4gZm9yIGt2bS1jb2Nv
LXF1ZXVlIHB1cnBvc2UgYXMgbWVudGlvbmVkIGluIHRoZSBwcmV2aW91cyByZXBseSBJIGhhdmUN
Cj4gPiByZWJhc2VkIHRob3NlIHBhdGNoZXMgYW5kIHB1c2hlZCB0byBnaXRodWIuICBTbyBwZXJo
YXBzIHdlIGNhbiBsZWF2ZQ0KPiA+IHRoZW0gdG8gdGhlIGZ1dHVyZSBwYXRjaHNldCBmb3IgdGhl
IHNha2Ugb2Yga2VlcGluZyB0aGlzIHNlcmllcyBzaW1wbGU/DQo+IA0KPiBZZXMsIEkgaGF2ZSBu
b3cgcHVzaGVkIGEgbmV3IGt2bS1jb2NvLXF1ZXVlLg0KDQpUaGFua3MuICBCdHcgUmljayBtYWRl
IHNvbWUgY29tbWVudHMgYW5kIEkgdXBkYXRlZCB0aGVtIGEgbGl0dGxlIGJpdC4gIE5vdyB0aGV5
DQpoYXZlIGJlZW4gc2VudCBvdXQgaW4gUmljaydzICJ2MiBURFggdkNQVS9WTSBjcmVhdGlvbiIu
ICBXZSBzaG91bGQgdXNlIHRoZW0gaW4NCnRoZSBrdm0tY29jby1xdWV1ZS4NCg0KPiANCj4gPiBB
ZGRpbmcgdGhlIHBhdGNoIHdoaWNoIGFkZHMgdGhlIHNjcmlwdCB0byB0aGlzIHNlcmllcyBpcyBh
bm90aGVyIHRvcGljLg0KPiA+IEkgY2FuIGNlcnRhaW5seSBkbyBpZiBEYXZlIGlzIGZpbmUuDQo+
IA0KPiBJdCdzIGJldHRlciBzaW5jZSBmdXR1cmUgcGF0Y2hlcyB3aWxsIGFsbW9zdCBjZXJ0YWlu
bHkgcmVnZW5lcmF0ZSB0aGUgZmlsZS4NCj4gDQo+IENhbiB5b3UgcG9zdCBhIGZvbGxvd3VwIHBh
dGNoIHRvIHRoaXMgdGhyZWFkLCwgbGlrZSAiOS84IiwgdGhhdCBhZGRzDQo+IHRoZSBzY3JpcHQ/
IFRoZW4gbWFpbnRhaW5lcnMgY2FuIGRlY2lkZSB3aGV0aGVyIHRvIHBpY2sgaXQuDQoNCk9LIHdp
bGwgbWFrZSBhIHBhdGNoIGFuZCBzZW5kIG91dC4gIFRoYW5rcyENCg==

