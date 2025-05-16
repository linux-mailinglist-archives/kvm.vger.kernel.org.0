Return-Path: <kvm+bounces-46751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47963AB93AA
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E39DE1BC6553
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 01:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC67E221FDD;
	Fri, 16 May 2025 01:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eS5AKEty"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66812F2F;
	Fri, 16 May 2025 01:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747359344; cv=fail; b=akhVc/PvsDGgyclAHqWVALrOY80tOl0m0y9NaTBbwwSWUJzhKofmVnds8kztlE2ptCVx2M24gkllWM0mSdHCKZtrSIzNqGJ4rWGNOzzrhAKEk+xt2w0P0Tl2mc2+a6xrWf5UkrWspeEREXhFPfxpDZVVE2gcCmA5msXa3X93Lg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747359344; c=relaxed/simple;
	bh=hNoCepLw6RiYT1+dmbL7okV4oTGwL58tHE0PsCYWbaM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SbVVDn8bZcVyTrcJhno/830B1bFnPeZJOhyigpkKe2TNjB2s6bMCnfJFb58MkB6EYTIx/iymsrjJEdh753gvvXWdCHYBehCMsmtkBR/ziBGtXLt9QiRCG3oXEGRBXwmi0lDOadSLFXUNmnhMZCSzkYLbRecQEdXiJ/AMcKIypEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eS5AKEty; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747359343; x=1778895343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hNoCepLw6RiYT1+dmbL7okV4oTGwL58tHE0PsCYWbaM=;
  b=eS5AKEtyFHQQbGq92xAcTBi0Jd1I6CWI9A7aGEH3O36sIJnWY33O7i9A
   BIItt7gS1QrSLMBADp7JXEIbnVtpBz4ExGNtDEOhLpjSbI2ylhDHleNtI
   vDLH8DzEeU1O4hkhD49r4lKcdJWLydtnt7SmCEfcI9Zaq2cHzmiB9ZjUr
   ERwDI+Yuik/lV70dTZjvg1N9XBhvS6T2yqKkY2J4uPBKU+CErAkO7OSP0
   gg0GSuV3L9OV6owS3xYvqAQ6BdlyUnl4v9/8Kq4D4L80ltInUbeFCFGMQ
   mIFpCOsl/bTNUuBOsEsWk3O/oYwBfHKy/Xy4TIuJT+ZPBYnR+dmO9LxLC
   g==;
X-CSE-ConnectionGUID: BmylnJ9yQq+FLAIvx7QeuQ==
X-CSE-MsgGUID: flKD//9YTTGRXyN8DYtjrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49220184"
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="49220184"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 18:35:43 -0700
X-CSE-ConnectionGUID: vxg5N5koTqKKPzSWWmR3Zw==
X-CSE-MsgGUID: Dzi4ImCMS0G6g0G8zJrL7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="143663269"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 18:35:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 18:35:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 18:35:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 18:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGYkqzoeKc7tLfvH1TyQA3zETHVa5Ndy6bh9b0AexWDxgbktkZlXEApTvd/DEvA89zKpOJU5sQ3Oh2kd7a1GalWDU4tYEgtHCpVhYIGH7bnlwfCfDhM+bv4VLnfK1Q6D78/ErjngnWBILxBvFR6W2fLorDAypOMV62O4bLFxa0y7OcPAQb4JXbLtaUmLCd3rjfbJSL8aeiSf9MIM0rdmRN317ahuDDyaSVCL+SaRzx+DKe0YAkH2bvbX5c+pNSbi0AEYUwXBG6n+bW6tQdR0TUdbDfGaVVx2o9UOAq/sEPMswhoBUym27Q4nWagojxbnbWf6wdQdXqX3xwpVuRzF1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNoCepLw6RiYT1+dmbL7okV4oTGwL58tHE0PsCYWbaM=;
 b=IswdcrpZXRUSzAn3WLgfSw34+bzptWknns3YXZef+sw0UYVQ9RprzTFICT6PxsvmenDNJx22ClniULRg2B09daPE5axOJZpFClV2M5uHxr4jgQLGHseMlhQJVLIcox9Yv+VYghDEA9j11MRdmMfvUcnSZcobMQXTWUTkv0RLq92IntieALbSDkueSprxmLlBKTyZmnPEGGkezkl+IYmSKTZFf2hsb1LuYWhZRCkbtNy4s3JBISBXf3K0a0ZtkXTVP54siv1WXX9u3PjTDyCZOH32YlcqPhBCeKlv3t/1wR7cr9QxiR/pLlQg7cm6bvY+vwu5JTtELIN7qqJTD2LXYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by SN7PR11MB6899.namprd11.prod.outlook.com (2603:10b6:806:2a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Fri, 16 May
 2025 01:35:37 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 01:35:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMZBhA49+LJMgEuvNu90MMjg/bPRHIEAgAN/lAA=
Date: Fri, 16 May 2025 01:35:37 +0000
Message-ID: <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
		 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
In-Reply-To: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3303:EE_|SN7PR11MB6899:EE_
x-ms-office365-filtering-correlation-id: 93c7be82-352e-4a02-c75b-08dd9419f58e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MmdKYzdrL0paZWhZTGJjYmMvYVljOFdFWHpONEtGWXp6cWFYdElDKzNMb2lH?=
 =?utf-8?B?NmtrOWtNRGlNQlBsL1pOUlRYZTNSckJHbFM1cGdpRHNsZGkwU2V6VHVFZ2FE?=
 =?utf-8?B?SFU5SEFuU3QwTmViNEZBbHRiUEI5SWlwQUtvOWQ1YXZiaTdESzJQVWt1Tmtw?=
 =?utf-8?B?UGZyTkxxNnBLL2VCTVFibkVSTytmaS9wOXFReVhRb25xdFg4NUxWV0M3NUJm?=
 =?utf-8?B?bDdyT3RpMHRSNExocFhUTERaclN6SmIxdWhIdHZYMHdwU3J4SzdmcXpBQi9N?=
 =?utf-8?B?Rncrc29YRExlWkM5QkNOTmswazh0aHJzU0J2NG9IdmFYMmU0RG90cHNMSnNi?=
 =?utf-8?B?emNTVHhxOG9udDdqaS9HZURvOWhzM1NKZ0g0NVptTW52RGNNOTRKT1Q4Rm9E?=
 =?utf-8?B?cWEzeGlDazl4MWw1VXNsZCtRT0FxMUJsMzZ0MXVlUUU0ZGZpSDJrdGtjcnpU?=
 =?utf-8?B?ZXFsVmljLytCUzlDeEdwM0t1NlZuS2xUZzhCQldkTFRMZkNobFZuWlAwRG1Z?=
 =?utf-8?B?Sjk2YkxvYkphUHA0aTNpV2p0dEFIZVpTUHJpM2hqdE1zYWVWVE9MY3h3d1lv?=
 =?utf-8?B?anFjam1NWjA5d2dremVoTVc5UFFPZlBWQzVEWnZpOW5Lc0VXZEk0MWMvdUNE?=
 =?utf-8?B?bFNRNDFUUlE4WXJQYzFvcFRRZCt1Nk8wZ2ZoenVDeUwySHMzT1lWd3djcnRP?=
 =?utf-8?B?YjlNOVJlSVFyRVo4c0RVN0RDM3p0SGlpY0VHMVhxQm04UGJDajR1V0h3ZCt6?=
 =?utf-8?B?d2hBNGI1S3FiWUNNMUkxZmloZlB5STNuSFRyOVJBNlhaMUp5SzliZk8vVlhU?=
 =?utf-8?B?Wnl5VzF6d0U4MmVXMWMrNmE3ckVNVExrcTZGd0ZzemlNVHVtY1JjVUIxYlFE?=
 =?utf-8?B?NWJrS1ppUy85VklIZWtVeVNGcDVhS0lwcnVTMnNlNEVhckExRFRVdlRESEZl?=
 =?utf-8?B?L0Y5UFB3dTNHTkJ6U3d3NVVUdkZORlZzb1lTMDRoaW5yUm1tcldmc2JxRGFn?=
 =?utf-8?B?aTR2YkpIbmk2bzcvaFYyekJXcDN1QitTRzFWRGYvSlhSWStoLzhPRTFoQnNs?=
 =?utf-8?B?dHVpa0RCZU11WFBkY0poWFZncUZucGdiNlJXSHN5UGZHNmNQekdGOUJtWWZG?=
 =?utf-8?B?U3NSRE82R0JUeXNaeTNVOUt4ck80RDVKQXo0UzhLMjJEU1kvcW9wSE4wSWtL?=
 =?utf-8?B?Y3A4elc4WWRaUUV0QVBNTkR5OEFwUEdxMlZCMmN5bCtjS0hyS1R5cHJqcGhK?=
 =?utf-8?B?UDJtU3R1eTBOaXZkcUZVYjFTNG1LKy9hM21sUkwwWkxvL21IOWF5RXBhK3dK?=
 =?utf-8?B?S28rSWtHV1RzSlFyK1lTVUdYV0o2dUs1YUFoRENtOVRVQkNmSVZMYTBkQ3pE?=
 =?utf-8?B?RUtiOWVic1BPRkVIZlQ0NWNGM1ZNdnlsVnc3czZPZlQ4QzA4aDgwL0RvU09j?=
 =?utf-8?B?NkVzaDMwZnRoM1c4TGl5N1AyUmVZTG5EUEI1VE1mT281VElxUms2ZTBGS0I0?=
 =?utf-8?B?NS9aR3ZhcnN6UHJTZ1Yvb0FseXd1V0duZERIMDE5UjJhaTdBajBSeHFRb01B?=
 =?utf-8?B?RnB1ckNQOFgwQmpRMGs4SCtjWTl4bjhKUWxyWGgwcUVac3pKVjEwc3l0MGNH?=
 =?utf-8?B?LzZmNlJaeTY2UHo1RVlvVzluRWt1MWkrdkRSVTh1bXoxV010MUM3WHJyVXJi?=
 =?utf-8?B?U1Z5SnM1NkZZNWNpMmtzRTZhK1B4TVJlUUllQit3TW53OXoyZ2YzTnpGNi9v?=
 =?utf-8?B?bHdqRUUvb25JK1hHNzlJek9OZ0FrVXFvRG9YRXhCNlJPcU5WTW9VUHVNQWFt?=
 =?utf-8?B?d1BFNG84eVhPMS9lVTQ4Qk93eUdHMHF4dDRBSkVFQmdnaWFlcDhmRi9yT0pN?=
 =?utf-8?B?dmgwU3ZzOFZMaUhmZG9KVjdZK3A5Y3kwbXhxcTZBU0RzN1hDWG5GWFl6dzZu?=
 =?utf-8?B?alEzMUNoVUNKMGJCOWxFeUY2SXB1aDhYb2tNUytWVE04TDlob3dVSlNuRGNn?=
 =?utf-8?B?SmZqTTI1eGVBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2I0Rk9FcDFRZU5SeTh4SzRxeTVQVG9mcmtQNmxQRXNkbWhLUk1tZ3pOd1I4?=
 =?utf-8?B?eVE4emR6KzJRTmFtbGdIOXNHZG81a05IeWZ0SkQrNDN4YzcraWNGTld4ditU?=
 =?utf-8?B?RVRYZWM0QWZyNFNnVjJ6TnE1TnhxZWkzdnpYb2lkR3hxQ3BnWnlrK2M5K0J6?=
 =?utf-8?B?QlEvMC9icDJwSk1UOElwY2JYNXQ2N081bDZhdWJEZEt3YWxZcFVPY0c2elNo?=
 =?utf-8?B?dStMTkEzODBoYXE4U1NLWlA0YTZMSUk2aFpLcm85YnZSOEJFUW0vOFUydHdv?=
 =?utf-8?B?TGtkMmM2OVdSNlZJYTVleTZpUGlITDIwT0hVSmh1RUVEY1UrcE1lVngzaXVv?=
 =?utf-8?B?NUZIS2xWcXV3ekdRaTI5YU9hU3NlYitKUUhGblJ3R3B6Q1B3SUV1TTRWUjdQ?=
 =?utf-8?B?M29ZdzJuNEc3b2lpN25iODgzUXVOaTdyUWFhMU5oUXJzNVhFRkpaamhQTHZB?=
 =?utf-8?B?YmFnbE4yeTYweWFSdCtVZlRvb2FhYTc5VW05bml3ZGJUckQ1VG9Pa0dueUJl?=
 =?utf-8?B?QmV1NzVockJ6bFUydnJBWEdpRDJHTnc5RkRVdjZiK0RWRnhtVEtpSGw1N1dX?=
 =?utf-8?B?UVFjbUNCZWJwNllCUzY3eW15N2lwNlVFdkhOdGVaQUI4Tkg5TGNlQzBLWWVl?=
 =?utf-8?B?UCtLanV6aXhEeVQ1NW9zL3hQVG1JVlV2Y0xJOTNLemdocHFiNjJSN0NvdXJ4?=
 =?utf-8?B?TTFKeC9BWURUcEdVN3dCYU1LbUJTRXUwRHZTamtxeWtBYkxDbXlKTXZTdUUv?=
 =?utf-8?B?bTZMemxRMUJIYVloWDJwNnpPdm5jWjFFcVdaaG5ZNTEzS2ZMOVB5SC9vN3cz?=
 =?utf-8?B?eU1OeGV5cmhJSmZCSUhnSktGYnNCTVU3azc1N3JNWW56aWtxajJLU3Q4Yldw?=
 =?utf-8?B?WlpnVmN3TkxNS1dEU3R2U3Fsd3REQWxabG9sZHF6L2tiTHBBL0F0TENidXNU?=
 =?utf-8?B?bkpnMkpGdEw4RFdoYmlvK25TVXlRV24vdVpaclIrZ3kvK0xCR0N5U2Q3UEZV?=
 =?utf-8?B?RTBOOXRYRjlIdmNqYmJncW80dXhlWHA0c1Y5VlRqMnFIKzJsbTN6YTIzY0dQ?=
 =?utf-8?B?T0RhMlFLWWxDWEUySmUvRGRXaDFudGtodVVDd1dFdjgwOHdaVkxQeDJ1OW1O?=
 =?utf-8?B?dVZiMm1aR240N3VveldEcU5LdDJEM0lWUEZhUnN2b2I0dHg2R01qS0ZFNDlq?=
 =?utf-8?B?YlhhSVY5UUZmdGFOQ3dOOEFNRTgxQk1RTTU1WDRUbGwxeFRZMUsxcW8rWXo1?=
 =?utf-8?B?WkdQcExFSGdLcHV0bzNVemdFdWxzc3dkQXRNenhLQ283MXlwc2FqRTZWUlBp?=
 =?utf-8?B?b3dqNUNORzNNWll2VzFGRWpYWDhjVmVzSlpwaUFETlNhc2hQT2dQdXhzdkdl?=
 =?utf-8?B?S2VrYlBqd1hYMUNUUEFva1RHdDNtdjlrUkdVaXhvbEFYemlYck1BYTBxd2x1?=
 =?utf-8?B?VGRLdVQvOWxzVm5jYm5WVVFVZGZKVnZjTlpqZDI4ZmxFNUJqbDg4UUVpbEdk?=
 =?utf-8?B?aU54MmlHb1pvWFA3WFZSblh2Y0xpVDZnc3ZmcmlXTlQxcGp4SkVFQXJnYmNq?=
 =?utf-8?B?bUJxQzdSWWNlYkZ5Zis3VjhGMWZ0UDc3TElYMWtwYXRXQmYraW9EcVY5UUVL?=
 =?utf-8?B?QTA3T1JhYnZZZzlQTmRQci9CdHRhUGlVTEFMdHQvOEplSGl0SnQvc05EUGRZ?=
 =?utf-8?B?RjlUbmtYc2krZFVIQXM4bEo2Y3ZPbEUyNm9URGd5MkYyaWVPL1FscVlHSDc2?=
 =?utf-8?B?RHhRYlFmVDZVZis5aGpxQ3BVeU43NS9nWkt4MTNGWDRmcjYzZlM0Z2dvSTRX?=
 =?utf-8?B?WUtoMDBoQjR4STQ3UjhEQldJcU9RVTJjRDRvUkpFNG1sQTdWR1lQWWlYZVp6?=
 =?utf-8?B?clJrK0xQL3FnTkdQZFJEbUZRMGV4cEkyNmVOM2JsbkhQakRyWGJMcEZhR1RW?=
 =?utf-8?B?OHZHU2R4eVdXOVFxNklERVRkQmJYOTh5cS9xbk8wVU1ocXByUTlIcjlEMlVt?=
 =?utf-8?B?Nm1PVTJiOE82dmRFMW8vUndzdXcrTVRucXR6QUZSQkhGTXdMUEY5akFIZ0ZL?=
 =?utf-8?B?anZ6SVRwbkRmUXpBQ29QQ2JGRFhUUDVaMmlNSU0zMUxCWlhJT3htQU4wZlM0?=
 =?utf-8?Q?tSDw4DOCvnfJFYkxGXuzvY4hP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28626E90A8F2664B9314C9EBDDE9DA8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c7be82-352e-4a02-c75b-08dd9419f58e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 01:35:37.1288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hL3/TTAVI2SWKFQtyhzTLEXW3qcGkHPsuzmNqnLiBjnzHHXtW6jqULdnRrgtA9KXdia/sxkM0soo+Y1LnD8pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTEzIGF0IDIwOjEwICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gPiBAQCAtMzI2NSw3ICszMjYzLDcgQEAgaW50IHRkeF9nbWVtX3ByaXZhdGVfbWF4X21h
cHBpbmdfbGV2ZWwoc3RydWN0IGt2bSAqa3ZtLCBrdm1fcGZuX3QgcGZuKQ0KPiA+IMKgwqAJaWYg
KHVubGlrZWx5KHRvX2t2bV90ZHgoa3ZtKS0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUpKQ0K
PiA+IMKgwqAJCXJldHVybiBQR19MRVZFTF80SzsNCj4gPiDCoCANCj4gPiAtCXJldHVybiBQR19M
RVZFTF80SzsNCj4gPiArCXJldHVybiBQR19MRVZFTF8yTTsNCj4gDQo+IE1heWJlIGNvbWJpbmUg
dGhpcyB3aXRoIHBhdGNoIDQsIG9yIHNwbGl0IHRoZW0gaW50byBzZW5zaWJsZSBjYXRlZ29yaWVz
Lg0KDQpIb3cgYWJvdXQgbWVyZ2Ugd2l0aCBwYXRjaCAxMg0KDQogIFtSRkMgUEFUQ0ggMTIvMjFd
IEtWTTogVERYOiBEZXRlcm1pbmUgbWF4IG1hcHBpbmcgbGV2ZWwgYWNjb3JkaW5nIHRvIHZDUFUn
cyANCiAgQUNDRVBUIGxldmVsDQoNCmluc3RlYWQ/DQoNClBlciBwYXRjaCAxMiwgdGhlIGZhdWx0
IGR1ZSB0byBUREguTUVNLlBBR0UuQUNDUFQgY29udGFpbnMgZmF1bHQgbGV2ZWwgaW5mbywgc28N
CktWTSBzaG91bGQganVzdCByZXR1cm4gdGhhdC4gIEJ1dCBzZWVtcyB3ZSBhcmUgc3RpbGwgcmV0
dXJuaW5nIFBHX0xFVkVMXzJNIGlmIG5vDQpzdWNoIGluZm8gaXMgcHJvdmlkZWQgKElJVUMpOg0K
DQppbnQgdGR4X2dtZW1fcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIGt2bV9wZm5fdCBwZm4sIA0KCQkJCSAgICAgICBnZm5fdCBnZm4pDQogew0KKwlzdHJ1
Y3QgdmNwdV90ZHggKnRkeCA9IHRvX3RkeCh2Y3B1KTsNCisNCiAJaWYgKHVubGlrZWx5KHRvX2t2
bV90ZHgodmNwdS0+a3ZtKS0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUpKQ0KIAkJcmV0dXJu
IFBHX0xFVkVMXzRLOw0KIA0KKwlpZiAoZ2ZuID49IHRkeC0+dmlvbGF0aW9uX2dmbl9zdGFydCAm
JiBnZm4gPCB0ZHgtPnZpb2xhdGlvbl9nZm5fZW5kKQ0KKwkJcmV0dXJuIHRkeC0+dmlvbGF0aW9u
X3JlcXVlc3RfbGV2ZWw7DQorDQogCXJldHVybiBQR19MRVZFTF8yTTsNCiB9DQoNClNvIHdoeSBu
b3QgcmV0dXJuaW5nIFBUX0xFVkVMXzRLIGF0IHRoZSBlbmQ/DQoNCkkgYW0gYXNraW5nIGJlY2F1
c2UgYmVsb3cgdGV4dCBtZW50aW9uZWQgaW4gdGhlIGNvdmVybGV0dGVyOg0KDQogICAgQSByYXJl
IGNhc2UgdGhhdCBjb3VsZCBsZWFkIHRvIHNwbGl0dGluZyBpbiB0aGUgZmF1bHQgcGF0aCBpcyB3
aGVuIGEgVEQNCiAgICBpcyBjb25maWd1cmVkIHRvIHJlY2VpdmUgI1ZFIGFuZCBhY2Nlc3NlcyBt
ZW1vcnkgYmVmb3JlIHRoZSBBQ0NFUFQNCiAgICBvcGVyYXRpb24uIEJ5IHRoZSB0aW1lIGEgdkNQ
VSBhY2Nlc3NlcyBhIHByaXZhdGUgR0ZOLCBkdWUgdG8gdGhlIGxhY2sNCiAgICBvZiBhbnkgZ3Vl
c3QgcHJlZmVycmVkIGxldmVsLCBLVk0gY291bGQgY3JlYXRlIGEgbWFwcGluZyBhdCAyTUIgbGV2
ZWwuDQogICAgSWYgdGhlIFREIHRoZW4gb25seSBwZXJmb3JtcyB0aGUgQUNDRVBUIG9wZXJhdGlv
biBhdCA0S0IgbGV2ZWwsDQogICAgc3BsaXR0aW5nIGluIHRoZSBmYXVsdCBwYXRoIHdpbGwgYmUg
dHJpZ2dlcmVkLiBIb3dldmVyLCB0aGlzIGlzIG5vdA0KICAgIHJlZ2FyZGVkIGFzIGEgdHlwaWNh
bCB1c2UgY2FzZSwgYXMgdXN1YWxseSBURCBhbHdheXMgYWNjZXB0cyBwYWdlcyBpbg0KICAgIHRo
ZSBvcmRlciBmcm9tIDFHQi0+Mk1CLT40S0IuIFRoZSB3b3JzdCBvdXRjb21lIHRvIGlnbm9yZSB0
aGUgcmVzdWx0aW5nDQogICAgc3BsaXR0aW5nIHJlcXVlc3QgaXMgYW4gZW5kbGVzcyBFUFQgdmlv
bGF0aW9uLiBUaGlzIHdvdWxkIG5vdCBoYXBwZW4NCiAgICBmb3IgYSBMaW51eCBndWVzdCwgd2hp
Y2ggZG9lcyBub3QgZXhwZWN0IGFueSAjVkUuDQoNCkNoYW5naW5nIHRvIHJldHVybiBQVF9MRVZF
TF80SyBzaG91bGQgYXZvaWQgdGhpcyBwcm9ibGVtLiAgSXQgZG9lc24ndCBodXJ0DQpub3JtYWwg
Y2FzZXMgZWl0aGVyLCBzaW5jZSBndWVzdCB3aWxsIGFsd2F5cyBkbyBBQ0NFUFQgKHdoaWNoIGNv
bnRhaW5zIHRoZQ0KYWNjZXB0aW5nIGxldmVsKSBiZWZvcmUgYWNjZXNzaW5nIHRoZSBtZW1vcnku
DQo=

