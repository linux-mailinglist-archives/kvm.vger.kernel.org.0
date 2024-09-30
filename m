Return-Path: <kvm+bounces-27672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10105989C95
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 10:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85B9828396A
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 08:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9D71862B8;
	Mon, 30 Sep 2024 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3prkRuy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1BE17BEAD;
	Mon, 30 Sep 2024 08:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727684394; cv=fail; b=IpMKEWd8AG6vbMPGwRICeelmtinir7SFVCieRDTT/DOiXAIbwidNTzVELlC5JOnvUte0rPNR1hQjlgyOhhY6VwlmTFKb2p6p1ucKJU5mILgzUU5PboAmCStVi+qQAIs65un6MCP6+8cMyuJCFl7CXkJQ28iFAGu9FZpSM+2IIhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727684394; c=relaxed/simple;
	bh=cukbmv/3sT8A2RefPrgK1fGYPBOGva/dQAdMOvW1vFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oCxAzPAq0AHGYGeYGN6yaFCM8cyRJEijZoFA1K1zl4rn3CCRChnjwUMTJmaVVs88xhsGQo9c2V+zyt6rz9OFnumYv1jAdNMxTSGLydx3oQ9Dh2+uI/10KTyeQLfcKty7QQCJT8vDYTM5HymBEaq3MjDAaJDOuUsPFpiIigDB9Xk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e3prkRuy; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727684389; x=1759220389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cukbmv/3sT8A2RefPrgK1fGYPBOGva/dQAdMOvW1vFE=;
  b=e3prkRuywPFmntURBS5tFvAn8yKJY8CyLPdWQzxUJg+9cr5Z3PnkDVXG
   IJ+ipL/BFOMskA9J20OxvcSZyUH8MHzT3/FCjulIJvQDPIdmQadhI5NSd
   uJW41Cpa5ZnINyRDMRu1WhQEXg1sGBe3Ew0Y5H6+SEK6wz952FdDNzG+k
   lH6/B8VYpnkQqIicGIpqqHdnqh/kAPd4d5j8xGjsME1F6DdIpBRKadBEr
   7NhxoN63AHerLxTNInzbMNGDxltlNTRCsZUOjci1ZnZ/MTOswpPEHTEb3
   rnm00IwvGUeeBZR74o/Kr5MFeY51AZboDaijazjSoVkM06cnrBsaveWVF
   w==;
X-CSE-ConnectionGUID: yALxkm6mT+CW3t3Q2mXisw==
X-CSE-MsgGUID: 3Rhmasp6TPy13Qp8bHpv2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11210"; a="29640528"
X-IronPort-AV: E=Sophos;i="6.11,165,1725346800"; 
   d="scan'208";a="29640528"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 01:19:48 -0700
X-CSE-ConnectionGUID: PlHmY1AYQY6LeBLzL4W38w==
X-CSE-MsgGUID: WxrAdimxRLOTGQxIPTKGHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,165,1725346800"; 
   d="scan'208";a="72807268"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Sep 2024 01:19:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 01:19:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 01:19:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 30 Sep 2024 01:19:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 01:19:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h63CAquUOn8IRyS/4+5BYB4flBPMrJjzD3pbEpAeEcpZiWLHfsloN3bOdDsm4MoMc1NC0tAc58BoRAJqaeFJgl59ptliqf6BA67bhTihYX7cOgfVpo8q220f3chlTNyEM/NZaHiPqaLEiU+vVRjPNBhlpVZnUK2tKSYtHPdcqC2vUL1/zgiavoMv/6in1HtVuATUMCZBAvzTPEHc3aCqDqgFdNLNZHF1O87gFntNiwTTUHhkMzz2jwjoOmr38AayaSFr30YYXO5pcwRyecjJ4gira5kJIT7aav2SPZa1TA4RTx+q48Ec/VNiX18OnniMthbv0ayzcaGGLS32VT9UuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cukbmv/3sT8A2RefPrgK1fGYPBOGva/dQAdMOvW1vFE=;
 b=brdwky9aodEULxClsZ/oGDWxNQFu6lOwG1zTUfVTsScGEILHgt65JP3QYr/m0JC7D75yMyZbWchzXxYIGMuLiPPmU7cYhpMZkpd27XElz7D7tc+do6GBWRXvzuHHCqZj0arA5Q0AwLYHZVe/jwYHQih2+3piHxcJ+Ht+tT2w0zQssDeWepflDWXr+bISIctXrz4p7eKNpuuS6h/SG3qR/Z5qA8w0GKZklvCFLEEidrSbHQh9udlDh7gTZ+9JDGWD5uQZwufGmPn6j69DS8GoiH8YW+ExLdO6Oi7yX8GigojWPmtTlzvuM6uq2IRKsY/mG4xMeX5FKRh/Qu9Xq2ORdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB8504.namprd11.prod.outlook.com (2603:10b6:510:2fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 08:19:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 08:19:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Mostafa Saleh <smostafa@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Quentin Perret
	<qperret@google.com>
Subject: RE: [RFC] Simple device assignment with VFIO platform
Thread-Topic: [RFC] Simple device assignment with VFIO platform
Thread-Index: AQHbEPjsEXH2dnYwOUyaUweiBIKYFbJwAGng
Date: Mon, 30 Sep 2024 08:19:45 +0000
Message-ID: <BN9PR11MB52768B9199FAEAF8B9CC378E8C762@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
In-Reply-To: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB8504:EE_
x-ms-office365-filtering-correlation-id: f9f46e43-8bd6-44c6-8e75-08dce128a4bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TWNqLzllZHgveWYyS3cvdEthNDZzZVpvbnJsdlk5dkMxa2JScEJnQVhTbDhw?=
 =?utf-8?B?NHJXUjdPaWR3cndnVFU1S1E3djlkamh3ZTV5UVZIUVBraE1nMEFwb2hYZkhZ?=
 =?utf-8?B?OWxHR3pwQmdqR1IyT3hjN3ZiM3phY3NoOFN4NW1EUVpXeVpJbUdUU2dwSTRL?=
 =?utf-8?B?cEgvcnFrOGZjVm1JaU9wV0ZobVpQKzU0NFhCbWZnVlpaMDdubTlpNDVPWFhw?=
 =?utf-8?B?RlhGWEZWQ3Vrcm43c2FxUWpmZ3U2QWNLc2U2UGZiUS9TNytpT0xKcXBsQ3RZ?=
 =?utf-8?B?VDBOSk8xK0NGcll0eVI2N2s0bHkzcXN2VHJKM3FpQndwT2oxak9sdXNpWGRh?=
 =?utf-8?B?aXRRSFVlZWtZOFdDYzlTaEdJMnllMWdxZmRvdHNOeG5QcjNnSVFBMml5aTRU?=
 =?utf-8?B?cUVXVUp0MmpnZklITnlDcFlVRFpwckFLRFJYNGVCOFJ3Z0cvbVZwQjFpbExN?=
 =?utf-8?B?dUp0MVhUREVDTVo2WlZPV0VDNjhVU25DOFYvaVZMcVJXZXBVVkRGeWNQdmN4?=
 =?utf-8?B?V2NUa2FzbzV6TFV0VzRGWFRxWFhEbUN3Q1kwMHp2TkFpbk10c0k0eE01RWVy?=
 =?utf-8?B?RTByRWF3WVR2UWdJSGp4YzQvV2wzbTVFZ0xZNXZIcE1PekFUMUs1NDBBeUM4?=
 =?utf-8?B?L0NhNzlqUUp2cDA4bjQ0L0NkMitRazZ5Z1ZQWFA0eWJwWHgydVl4U2xBZFJr?=
 =?utf-8?B?NGpIcFVUdXQ4NExWRE5zc0Z2YVFFRWdldGJEay94MENnUUVRTFhhb3hlY2hy?=
 =?utf-8?B?bXNQYmp5ZzFIYVZUM0tDOUp6T1U3dHdPQjg4YWkzT0tPZkZncW91dm81TVgx?=
 =?utf-8?B?dzcyb3BsUHJBMWtUaFpWOXgrUXZRdG9vNTZMdC9LNlAwTGJ1aG1FMEtkK3ZK?=
 =?utf-8?B?cmV4MHBNRGtZMHJlNWNGeXhsZFBaSEFtem0wdmlWcUh1TFF6a0pMYXVudWRJ?=
 =?utf-8?B?b2p6dHlNTDRHbVNXVUk0ZnI5WGEvWXZpNFhlUzBFa0xLWWZ1Z2I1aWIwN25J?=
 =?utf-8?B?SHgwK2YvQVF5ZWlNZTJyenNWdEllZjgzWlYrd0VKb2NpSUVQSU42bzQwZlpI?=
 =?utf-8?B?bElmQnloL0RDOUZjR2RzKzFiNkNYR1JvV29NZ1QwNHF0RlFsOGExS2tXd1o5?=
 =?utf-8?B?K08weTBCZ0NLZ2ZQT1lGOGo0aGgzUXhIVUJ2T3lRQzl4YkV2SUROSFJNYTRT?=
 =?utf-8?B?MmxCejhpUFNnZXp2T0t3TlBQRGt1RGRNVitleWNRZEhpNU5YWTZRRkw3WTZC?=
 =?utf-8?B?Y3UxSXM5RjZCMG5nZkkxL01jOWdEczllelFQdjNMaHNjbGZRZkkyUmxWT3RP?=
 =?utf-8?B?SStSTnp1eVdHdnVXYS9vaDRXTnlsYXptenBIaWtEdDFrcE5SSFRPQ05yRHQ3?=
 =?utf-8?B?ZHFxL2hRQU5PbWtOMllLbVBhdjZTVkc4ODZrdFgvYzhQbjNPSWZEQ3FyZ3Ji?=
 =?utf-8?B?Q0xaYlZvc2JzeXZMVjFEMVh4RHNjQTl3Vi8wRDcxOHBRclVVdzdVSUxXaUZJ?=
 =?utf-8?B?VkJwOXZCZmp1V1NSSElJaGJKVmh5SXdaR05mM2JxOVpqMldIaGd5YWZBaHVa?=
 =?utf-8?B?em1IS25xTU9WSzZkU2NNZWlEWTlrTEpUeWxleHFFMnhtdEpuMHE1WGczaVRu?=
 =?utf-8?B?cmFpN1B1aFRPR1dGV3lJVm0yanFDdHNvYXVoZFdlZEViZ0psbG9ROFNWczVk?=
 =?utf-8?B?a01ZUVZscHI4YXp2NGRvYlJtVXk5b3huOEoxTFZBU0dKdGJNdjZXdHpsSjR1?=
 =?utf-8?B?Q1lKQmNRZGU0SDhhR3ZlM3h1UVBPd1pEWGd2TDNsUzllWmVjTWp0T3BxbjlY?=
 =?utf-8?B?OG1XWi83RlQreWdWc0NVdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHFrSUZkMVo2RnZGRXVMSDEyZGlIK2xDUWdQa0hkeHYzSXVxM0xoakZwQ09O?=
 =?utf-8?B?RXlEWFZ2TnV0eFdzOGFhOGZFbGE3M0J2TUl3ZTUvTVZSQWlRRGhyZzNOYnhT?=
 =?utf-8?B?ZWdWN0RIQ1FTd0xndFJIMUY2Ynp0ejEzd3BTcHhsaXZTTFRsMHpSMG1oL1Z5?=
 =?utf-8?B?ZHA2cnVsZjF6MWx6UHJ6amthdzkwYWJ5VVFYR29OemYyb2d2VFVoRmlESXRV?=
 =?utf-8?B?OEVJSkEwZjhpSUZBZnkrK1FZeXhwWnZqZmQwSkRTYkpZWUNWZkI5a2h3SkF1?=
 =?utf-8?B?dDJkTFAzY3Z4Uzh4SUJmM20zVlV5SjErRHpCY1ZpbnhWSzBIMlpGT3hncHov?=
 =?utf-8?B?V2dYbmRWU1F4dDc3Z0JHSGx3NkJYTzhyVkYzUEpWUm1nZ1NMdVQzb2c3RXhG?=
 =?utf-8?B?NzUxT2lOTTBNdTJDNW56a0s1L1hpNVpOTGZpZGlzTWQ1c2Z5Mld3V2dHL2RJ?=
 =?utf-8?B?Y1FLUGFEd0kwbHJsZGwzUVBaWnM1VHUvUUNrT0xoKy9XSENvaGt1NVJxNnlV?=
 =?utf-8?B?bzRMNlFQTWcyTHA5cVlCS2NLVDh3Q1hRZ3pVSTRZcXFPSENEWlBPUURWZVR4?=
 =?utf-8?B?aXpFdzU3U2l2RmhHTHRGRW5kR1VGRXVSL0JjdEovc0F1THBLTmhMZHpNamFR?=
 =?utf-8?B?K09IUW9yYzJ3U3RCVFVtRHhxNFB4KzhHVU5QMkMzNmN1UmdiMnlLdXNZcENt?=
 =?utf-8?B?MmJtWjRzNEFOZmdJMjJiTnZ5YjlBckxJNnIyR002OExJdmlLelcrUVlwV0hp?=
 =?utf-8?B?ZHRjMGk4ZUoyVXc5V2wzMlNwamcyeGFHVytOdFoySmlmR0VyV2VOTHZ0MHl1?=
 =?utf-8?B?djU5VmdlYXA5dFdsNlRaenBVbVNISUVrQityMy8ySUd0eGovRWtzNVF1NkRW?=
 =?utf-8?B?aFlaeGNrY1B6NENwa1Z4SlNOa3hlbEJTbDlyZGRLN0lTWUE5bG5qOGxGL0JX?=
 =?utf-8?B?L2pGMTdVTzB1RzRnQlhlcWlDZWZITGc1eWFDczhBa1hrejBKZE5xOG5La0FY?=
 =?utf-8?B?ekpHNnFPU0NlbmJ5TEkvU3BBUUlGcGVyaU9lRlJSQkZiL1hWYXRLUmREZnZ0?=
 =?utf-8?B?TnZpSlFFVVhmNGJTbGdKTnJkOG82aHFqYTNNKzlJMCtHY2VOMlh4cEpjRTZM?=
 =?utf-8?B?NklzOWhzTzhVa2FYamR1Q3NYdnBzRVAyaVdxVEFxYVZxYnZENXJYZkdNQzY5?=
 =?utf-8?B?VkJzNkwxNW1jKzBVK29KdmVlN0hIdDJ6YzVTSWJGRjBQcHpkeVY3Skc5ZkZ0?=
 =?utf-8?B?bWh4WDdTdkFsbmtmOEpwY1V3cmk4cEttalFyTUxkbldwRW5VNTJpZ2E2K0pu?=
 =?utf-8?B?NTQ3SWlFem5ieGNoelQ4Z3RoS1BGQkx4RUxIMXo2ZXI1QVE1aFFpZHVQemQz?=
 =?utf-8?B?cmx3Qnkxc2pXKzRqM3dSSGpSTWlvVXF6ck1MSDVFd0c4MElxSnEvS2l0R0lO?=
 =?utf-8?B?cmJia2FoSlQ3TlFVZ1hCd3EvMUV6Q2ZqVkpMbTkxb0o1bWltT3hDOG8veW10?=
 =?utf-8?B?anpBODJtQ2pUWWNsZG8vb2hqVzk5RXJ1bXFSU2YzSXk0NzlmRS9uOVVmVjcw?=
 =?utf-8?B?blJ6S1FwRmhiVHFlalRLNGFSdUp0V0pDaEt0cUl2T1VJVVpBNmxodU16L2ZL?=
 =?utf-8?B?L2tSbFRrR21RY0NtLzQ4QjM2b05SNWN6SWkzUXpzS01GeFFHbys1WjdRRFE5?=
 =?utf-8?B?M0h2STROYnBxdVFWWC9xbzdlRklwMnVaS0lHUEdrOTE2dVlZWnl0VzlBZFJU?=
 =?utf-8?B?T3B3VGtlcFdhWmttN0NsVWNLSGx2dGF5TjkwQlZGUFBxK0dhcWJWZmFBOXYw?=
 =?utf-8?B?VFV5Y2NmZUhyNU03QzErTytXdW9YdU8rNWZBV0NIdGpweHVXc2dyU3AvZ3Bq?=
 =?utf-8?B?Nm1rbDEzNlhjNTBUSmx2ZFhaOXRYQmVPd0NuOU9IRlpSb3ZpTDZBR09RdUlK?=
 =?utf-8?B?Y2E4N0FCTnAzVEppbXpRbEw1QUl0QW96aGhzeDJtWGhmNVBsTlNFV0hSMEdR?=
 =?utf-8?B?SkEzSzJCY3ZhSnA1OHJIeEwvenZTUkFkTENtWkJrWVB6d1J3d2ZOWW5QQk5w?=
 =?utf-8?B?NmtyUEFac1lTQTBRKzlmamxqRWNQV05yeHIvaUJlYmIvdTJCTER2MnNlMzJk?=
 =?utf-8?Q?g+I/3gyI9IyB83KbYWj0f4UBV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f46e43-8bd6-44c6-8e75-08dce128a4bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2024 08:19:45.8061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fxC+ZqYFdkoN22hfua0nNlnowUMvqt3+oOhIC+8fOa7X6zgThSDwWAGXUzxQZ7tGNPmWJ4sZg+3aZlmp9kJCFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8504
X-OriginatorOrg: intel.com

PiBGcm9tOiBNb3N0YWZhIFNhbGVoIDxzbW9zdGFmYUBnb29nbGUuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgU2VwdGVtYmVyIDI4LCAyMDI0IDEyOjE3IEFNDQo+IA0KPiBIaSBBbGwsDQo+IA0KPiBC
YWNrZ3JvdW5kDQo+ID09PT09PT09PT0NCj4gSSBoYXZlIGJlZW4gbG9va2luZyBpbnRvIGFzc2ln
bmluZyBzaW1wbGUgZGV2aWNlcyB3aGljaCBhcmUgbm90IERNQQ0KPiBjYXBhYmxlIHRvIFZNcyBv
biBBbmRyb2lkIHVzaW5nIFZGSU8gcGxhdGZvcm0uDQo+IA0KPiBJIGhhdmUgYmVlbiBtYWlubHkg
bG9va2luZyB3aXRoIHJlc3BlY3QgdG8gUHJvdGVjdGVkIEtWTSAocEtWTSksIHdoaWNoDQo+IHdv
dWxkIG5lZWQgc29tZSBleHRyYSBtb2RpZmljYXRpb25zIG1vc3RseSB0byBLVk0tVkZJTywgdGhh
dCBpcyBxdWl0ZQ0KPiBlYXJseSB1bmRlciBwcm90b3R5cGluZyBhdCB0aGUgbW9tZW50LCB3aGlj
aCBoYXZlIGNvcmUgcGVuZGluZyBwS1ZNDQo+IGRlcGVuZGVuY2llcyB1cHN0cmVhbSBhcyBndWVz
dCBtZW1mZFsxXSBhbmQgSU9NTVVzIHN1cHBvcnRbMl0uDQo+IA0KPiBIb3dldmVyLCB0aGlzIHBy
b2JsZW0gaXMgbm90IHBLVk0ob3IgS1ZNKSBzcGVjaWZpYywgYW5kIGFib3V0IHRoZQ0KPiBkZXNp
Z24gb2YgVkZJTy4NCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA4
MDEwOTAxMTcuMzg0MTA4MC0xLQ0KPiB0YWJiYUBnb29nbGUuY29tLw0KPiBbMl0gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcva3ZtYXJtLzIwMjMwMjAxMTI1MzI4LjIxODY0OTgtMS1qZWFuLQ0KPiBw
aGlsaXBwZUBsaW5hcm8ub3JnLw0KPiANCj4gUHJvYmxlbQ0KPiA9PT09PT09DQo+IEF0IHRoZSBt
b21lbnQsIFZGSU8gcGxhdGZvcm0gd2lsbCBkZW55IGEgZGV2aWNlIGZyb20gcHJvYmluZyAodGhy
b3VnaA0KPiB2ZmlvX2dyb3VwX2ZpbmRfb3JfYWxsb2MoKSksIGlmIGl04oCZcyBub3QgcGFydCBv
ZiBhbiBJT01NVSBncm91cCwNCj4gdW5sZXNzIChDT05GSUdfVkZJT19OT0lPTU1VIGlzIGNvbmZp
Z3VyZWQpDQo+IA0KPiBBcyBmYXIgYXMgSSB1bmRlcnN0YW5kIHRoZSBjdXJyZW50IHNvbHV0aW9u
cyB0byBwYXNzIHRocm91Z2ggcGxhdGZvcm0NCj4gZGV2aWNlcyB0aGF0IGFyZSBub3QgRE1BIGNh
cGFibGUgYXJlOg0KPiAtIFVzZSBWRklPIHBsYXRmb3JtICsgKENPTkZJR19WRklPX05PSU9NTVUp
OiBUaGUgcHJvYmxlbSB3aXRoIHRoYXQsIGl0DQo+IHRhaW50cyB0aGUga2VybmVsIGFuZCB0aGlz
IGRvZXNu4oCZdCBhY3R1YWxseSBmaXQgdGhlIGRldmljZSBkZXNjcmlwdGlvbg0KPiBhcyB0aGUg
ZGV2aWNlIGRvZXNu4oCZdCBvbmx5IGhhdmUgYW4gSU9NTVUsIGJ1dCBpdOKAmXMgbm90IERNQSBj
YXBhYmxlIGF0DQo+IGFsbCwgc28gdGhlIGtlcm5lbCBzaG91bGQgYmUgc2FmZSB3aXRoIGFzc2ln
bmluZyB0aGUgZGV2aWNlIHdpdGhvdXQNCj4gRE1BIGlzb2xhdGlvbi4NCj4gDQo+IC0gVXNlIFZG
SU8gbWRldiB3aXRoIGFuIGVtdWxhdGVkIElPTU1VLCB0aGlzIHNlZW1zIGl0IGNvdWxkIHdvcmsu
IEJ1dA0KPiBtYW55IG9mIHRoZSBjb2RlIHdvdWxkIGJlIGR1cGxpY2F0ZSB3aXRoIHRoZSBWRklP
IHBsYXRmb3JtIGNvZGUgYXMgdGhlDQo+IGRldmljZSBpcyBhIHBsYXRmb3JtIGRldmljZS4NCg0K
ZW11bGF0ZWQgSU9NTVUgaXMgbm90IHRpZWQgdG8gbWRldjoNCg0KICAgICAgICAvKg0KICAgICAg
ICAgKiBWaXJ0dWFsIGRldmljZSB3aXRob3V0IElPTU1VIGJhY2tpbmcuIFRoZSBWRklPIGNvcmUg
ZmFrZXMgdXAgYW4NCiAgICAgICAgICogaW9tbXVfZ3JvdXAgYXMgdGhlIGlvbW11X2dyb3VwIHN5
c2ZzIGludGVyZmFjZSBpcyBwYXJ0IG9mIHRoZQ0KICAgICAgICAgKiB1c2Vyc3BhY2UgQUJJLiAg
VGhlIHVzZXIgb2YgdGhlc2UgZGV2aWNlcyBtdXN0IG5vdCBiZSBhYmxlIHRvDQogICAgICAgICAq
IGRpcmVjdGx5IHRyaWdnZXIgdW5tZWRpYXRlZCBETUEuDQogICAgICAgICAqLw0KICAgICAgICBW
RklPX0VNVUxBVEVEX0lPTU1VLA0KDQpFeGNlcHQgaXQncyBub3QgYSB2aXJ0dWFsIGRldmljZSwg
aXQgZG9lcyBtYXRjaCB0aGUgbGFzdCBzZW50ZW5jZSB0aGF0DQpzdWNoIGRldmljZSBjYW5ub3Qg
dHJpZ2dlciB1bm1lZGlhdGVkIERNQS4NCg0KPiANCj4gLSBVc2UgVUlPOiBDYW4gbWFwIE1NSU8g
dG8gdXNlcnNwYWNlIHdoaWNoIHNlZW1zIHRvIGJlIGZvY3VzZWQgZm9yDQo+IHVzZXJzcGFjZSBk
cml2ZXJzIHJhdGhlciB0aGFuIFZNIHBhc3N0aHJvdWdoIGFuZCBJIGNhbuKAmXQgZmluZCBpdHMN
Cj4gc3VwcG9ydCBpbiBRZW11Lg0KPiANCj4gT25lIG90aGVyIGJlbmVmaXQgZnJvbSBzdXBwb3J0
aW5nIHRoaXMgaW4gVkZJTyBwbGF0Zm9ybSwgdGhhdCB3ZSBjYW4NCj4gdXNlIHRoZSBleGlzdGlu
ZyBVQVBJIGZvciBwbGF0Zm9ybSBkZXZpY2VzIChhbmQgc3VwcG9ydCBpbiBWTU1zKQ0KPiANCj4g
UHJvcG9zYWwNCj4gPT09PT09PT0NCj4gRXh0ZW5kIFZGSU8gcGxhdGZvcm0gdG8gYWxsb3cgYXNz
aWduaW5nIGRldmljZXMgd2l0aG91dCBhbiBJT01NVSwgdGhpcw0KPiBjYW4gYmUgcG9zc2libHkg
ZG9uZSBieQ0KPiAtIENoZWNraW5nIGRldmljZSBjYXBhYmlsaXR5IGZyb20gdGhlIHBsYXRmb3Jt
IGJ1cyAod291bGQgYmUgc29tZXRoaW5nDQo+IEFDUEkvT0Ygc3BlY2lmaWMgc2ltaWxhciB0byBo
b3cgaXQgY29uZmlndXJlcyBETUEgZnJvbQ0KPiBwbGF0Zm9ybV9kbWFfY29uZmlndXJlKCksIHdl
IGNhbiBhZGQgYSBuZXcgZnVuY3Rpb24gc29tZXRoaW5nIGxpa2UNCj4gcGxhdGZyb21fZG1hX2Nh
cGFibGUoKSkNCj4gDQo+IC0gVXNpbmcgZW11bGF0ZWQgSU9NTVUgZm9yIHN1Y2ggZGV2aWNlcw0K
PiAodmZpb19yZWdpc3Rlcl9lbXVsYXRlZF9pb21tdV9kZXYoKSksIGluc3RlYWQgb2YgaGF2aW5n
IGludHJ1c2l2ZQ0KPiBjaGFuZ2VzIGFib3V0IElPTU1VcyBleGlzdGVuY2UuDQo+IA0KPiBJZiB0
aGF0IG1ha2VzIHNlbnNlIEkgY2FuIHdvcmsgb24gUkZDKEkgZG9u4oCZdCBoYXZlIGFueSBjb2Rl
IGF0IHRoZSBtb21lbnQpDQoNClRoaXMgc291bmRzIHRoZSBiZXN0IG9wdGlvbiBvdXQgb2YgbXkg
aGVhZCBub3cuLi4NCg==

