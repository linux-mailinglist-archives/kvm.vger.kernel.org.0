Return-Path: <kvm+bounces-42281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC166A77157
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 01:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A3643ABDC7
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 23:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AEB21C193;
	Mon, 31 Mar 2025 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AVNMcnGI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11238F80;
	Mon, 31 Mar 2025 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743463050; cv=fail; b=keGItoExQwY0AhCyKr/7Cr4A2ObO/LmPBuUq2+WANSk57QMnbJeHpX1u3NxeHOMnuxNOczlfFQaMe2ZdrVGI3w1nQuDKdczf9FuH8QimbuyWGnLUBLOBOsbX0rVqlxqG/bkLPQz51EsiNYR9KcTamNLw6ccqx967co1VWHL11ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743463050; c=relaxed/simple;
	bh=ykGHeyT3CjJo2rQ8t9d2waqSVPb0q64+4chZt/jMCtI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a0Vd07BlepbsvqMA91jqx2IFgntQ2fE80CsN4/U9xDve2by9if3PBY8cXniiIr2M0mHo7tq2OjYC7RC1W1frFionB3Lb3xotBoMIbYCcElbKTDy3WEfVq/sG/JCf9bdwqBKFjSu5VyxiVp6XWlntMTsFeWT/+O0Ri87PAUrru0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AVNMcnGI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743463049; x=1774999049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ykGHeyT3CjJo2rQ8t9d2waqSVPb0q64+4chZt/jMCtI=;
  b=AVNMcnGIK/XtXRTXq/KBWAkmqGWJX52bwycVz7LLnMrf32jV6qSXlKHH
   sbLjSLCs2OHQviGjIon5Qn6pyMvZD0m00g4AintBag3rE31lPrsLbMTZO
   BADcSNNcVFrASDTXgSL9t/Q4Mc9b7ATPPlxum4y1HGLOhvYQI6ye68938
   WPT2mlFNd1mBIqJZIRJ+6thYh2PmYGbRw0ZGZrTzMet56MC36d622LHy8
   pxFpk3y1e39p0R+J/eUJKqbNQ1lj5StRM7Ip18agBjey7ZZcL4d68nb+F
   h4uinod6SYM7k5kkQ+ZVMI0pYuCG0hF11wyA+CoWzLAexyWvZnvVuSgVN
   A==;
X-CSE-ConnectionGUID: pN5UC/ASSa6shh9GFpkuTg==
X-CSE-MsgGUID: kxdyRP2MQqKOlPNCZ9smWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44661112"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44661112"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:17:28 -0700
X-CSE-ConnectionGUID: 6Dup9jd1TwSMgfb4ut5Qpw==
X-CSE-MsgGUID: aXl1wuRDRtevE0C8tfSCGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126117473"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:17:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 31 Mar 2025 16:17:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 31 Mar 2025 16:17:27 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 16:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsJBvGBgEw+3AMwqjWYkqCNUwQFiUjP3hNuVjUU2uqo9oOTPsgghQT4kzLsO+wazOpjdbxnDK8dEpO4bFXzTso6JZniLemQ6zFA0b9xhdbGWRJm+BvtzMghrGJiRDkOAnnpNiQqiCaxGawNuqn/qSzzojyJkRnWgM3j9sICfRK6dQCvr5iSxpIgA9LkIzJzOFt1vOuG2QMgpFK49g651m0lWxkKkWn0iKBHxsek9SVE6Tolj9Q+rkg5QyMOZxbXKWr3Hs6AresYFsfDU/nprxTHfBWy5JC8dEFktTJKDbGgbycTGi5vbMkI7vRQ4LlnPw8fH8hCrM8R9RrNGpyXzGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykGHeyT3CjJo2rQ8t9d2waqSVPb0q64+4chZt/jMCtI=;
 b=EeVzn469YS/7TCLsiaV+TjrHXSHPvlO1AMUkZMxYpittaUzioyCYnCPst9gWjSRph9IoLMzdoK6kdEpv93MbWpNEwyIrRReQ2Sy28MNH1hYyJP4mKaIxF2K/1TMrTl+BL6o5XW+aHfZBZYR15UMmAnS1jA8pUuIi5XKo7jzSrOJcvY17eJN4wcuFyoawnfpCYNlonL3R8lONXgvA7cg8Y1FPOmmBsqVcmj52cBpKVWZGX6EFU16eubyMo8UnyyteIayzXTPGcwD8jRSHCRvBH7gGjnZxBVsl2asRM3a1TWtzJ10VAAq0r1ROIqqo7FikH1IpPvbIsZI+j2e782v5XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8562.namprd11.prod.outlook.com (2603:10b6:610:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Mon, 31 Mar
 2025 23:17:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Mon, 31 Mar 2025
 23:17:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Thread-Topic: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Thread-Index: AQHbnMYXLpF+MXvWuk+lHsbQWRH5lrON7JAA
Date: Mon, 31 Mar 2025 23:17:24 +0000
Message-ID: <d8d043e6ddfc7c815809b25a1c76c11dbb67d873.camel@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
In-Reply-To: <20250324140849.2099723-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8562:EE_
x-ms-office365-filtering-correlation-id: 1aa8865b-8b66-45f6-3da7-08dd70aa3261
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SkNEcEt3c0Z1eTV3OFlzOVkzbFVUMEdad1BUMGh4RWpxTHYwYnNLcmlLTUQ1?=
 =?utf-8?B?c0UzaEpkUEdqMzM5ZHlzL3FWSUJrMTJYMXVaTzJIUWozcVZhTklxWHIvcWVK?=
 =?utf-8?B?NmwwU0RsSVVEMW53YlVaaDFSWE5mYWpqMlpGdGo4U1M5RXBybVRrVk1VT1Bz?=
 =?utf-8?B?dHB3NkNuSEtXTjFnYVVMT2JwRlFJTFJYSGRPazFCNUxqNGxJYkhkYTMvWm8r?=
 =?utf-8?B?dStDVUtWWFhyMy92TVhMcVlXb3R3b3UzNDRxZ1dLT2FRRjBlSGx4UWRwbXZu?=
 =?utf-8?B?eUhPZnIzNGdZM1Y4bUJFdFo3M1NhbkJFRHJlOVM1MXdDN21BTzNSQ2F5QXdp?=
 =?utf-8?B?TkUwdDdteGZnc1FUZllMZDY2eDlvbWxSS2grMEkxa0ZVTGp5enJaU211bkw5?=
 =?utf-8?B?SFBMSW0xa3diSFBmZ09aTGdSb2lQd0JXQ0wrS2VwdVZvOTVkRDFoMk14algy?=
 =?utf-8?B?bFp6dllLWFpzL0VyaW1DV09hSDAyakJJNnk3SjFKdE45QmpodVJjY1FmT0dI?=
 =?utf-8?B?bFVJRkVVUExnNHBGQ3BjTDV5YWFLQkZpSzh6bXVhUkVXZ3RzMzBsS0FnU29x?=
 =?utf-8?B?RTdQM0pxaHAwLy90UnRLWlc3QU13RExISVdSdnBGQVF1RHZ1NHRjSFpsRXBy?=
 =?utf-8?B?OERUdkJrdEp4eGdJMzRqbHJ0T1E1eFFORlRtZUV6WjcvNFc2UTY5RUMvZkZL?=
 =?utf-8?B?QXdtQ1VPUHJvMFpWVjZPT01Yc1U0VnZldkJJNXJCZlZCbVd0bkhuUlEvU29F?=
 =?utf-8?B?Wnc3eStZbmo5TFV0d0llSnJZY20wSzY2RjRscnlSK2wxNTRPZmpZODFqQlRF?=
 =?utf-8?B?bTN3USt4by9OVWtpbzh2UktES2Nzb1FTQmtzK2NYSWlneVh0Qy96bXJjVXlh?=
 =?utf-8?B?ZVhqZTRJQ3ZDR1FlcHFNcVlibGZCRmwwK3I3cDNIRnlhczhZcXZQUEFxQktZ?=
 =?utf-8?B?SC9OR05rZTQ1OXE3S0I3UE51eTBQSEd2cHRIbjhyVmJWT1p1MEVkU2JYb0dr?=
 =?utf-8?B?bzYzaklKMUZORWt6dEtKMEkxNnQ5cVBpOS8yR204bG83cDNTVnUvaWNzU29p?=
 =?utf-8?B?OVZ2ZTlwbVRNNWpPaWtwY2NZU05wSmdWMUt5Q01nRWVkZ0Y0SWJXWStRYlhT?=
 =?utf-8?B?a0ppVE9YSmE3cHE0L09ycjd6WFhnS3E0elpDYzZKSEFocTNLS3F2RncrQ2tl?=
 =?utf-8?B?ZG9RVlJZMVJFYTBxQWdFMWVwZ3ByZnJ0Q3JoMks0UVc1dlNlUUJMMW5qdFlS?=
 =?utf-8?B?YUJOaFVwbm12Qkg5MmtNeHA3d3RTYU1qc0lUbTl4QSs3MnY1M1A5WHNRYmhJ?=
 =?utf-8?B?UWJRbktqMmZ0SE9Ed2FkUCtqYWxEenpBMTNUL2lUKyt3Z2U1Z3dzVmJ6d3Fm?=
 =?utf-8?B?dmV3SkpSL2gxblg5VFVQRjVCdHpsY3NQL0tqakNCSmVWT1pjdyswQllrWlR3?=
 =?utf-8?B?bnFmNklmd0tuVnZjWGQ1ZVlGTzZ2M2VBc1hXRUlSbDQvZ1RFaW1WTEQ5cDNN?=
 =?utf-8?B?U1o5RHpuWnIyVHB2YTZPaGdYYnl0UGZYSE9pM1ZEWlU4QVZSODVGejVJcjMr?=
 =?utf-8?B?SnREWjBxNkREMGE1eENpRVpRckI1ZnlIWndjUktxM3VPczJ4c2IwbDN4dlBU?=
 =?utf-8?B?VitqekYrQVFXU2RRZlBCVW8rYnlCVFM3bHgzWis3b1Vpd0V6YlB2Rys3WTRJ?=
 =?utf-8?B?Wk1RQ0dRaW8vL3RiTUtIb04xT2JNZ0t1bEJqZnYxN3B4S2RGNnQ0T0svMGt4?=
 =?utf-8?B?eStFbVFqeTFOMDRpOW1vWjA3cG5Wa0FkSUJLd1hQYmpyaHdHUXZSQVQ3N2Nx?=
 =?utf-8?B?alpMU1E0STlEYnIzekc4MjJyblFad0hjaExTSGY1QkwxT1phVW1XaFI1Y0xO?=
 =?utf-8?B?ck16RTBjVGM2ckZRVTJIYVN4RlhyMENockFCSEZ3cDJRYjZTaUtBSkU5czBw?=
 =?utf-8?Q?vb5AzWFphCXSPE4X2UAXDITD6mRWHGUn?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVd6Vno3d3lQbEJZZTRJd1JBMVlDdGRLSTN4b29xazl6UGdDajRSZlcwa1FY?=
 =?utf-8?B?WXVFamxiNEMydUw3cmtCV3VHZ1I3NElaeEh2cHlRZGlYcXphUFUrQkhzTkJv?=
 =?utf-8?B?UmJVS2EyMnZyVytUU0hycERaNGwyYnQzbEdSYVliQkdBQUVMQnZIYjVaWnVr?=
 =?utf-8?B?empCay9zTGNla1BldmVEMDBVWERVZ216bStwMmZZWnNEVC9EU3NjZ08zSWF1?=
 =?utf-8?B?TStOVVI5REVrWUM4UFgxa3QwZmNIdGVQNCtWeS95QWMxTGtZaUsxL2RTS3JP?=
 =?utf-8?B?Tyt3M2hhcDBnVm9UMmF2eXJmVjNRVjlSVjBNTFBSMDRxbkpZdG9zdkRrRnln?=
 =?utf-8?B?UW96bitxWDYxQ2FHeFFMNEppVlg3NGN6RTlET0JURDlzUFFpOVhrSzRTMVp1?=
 =?utf-8?B?em51RXFJRUJhd0VQWWFxbUNRbEFPUU9McHdBWU9pdTFYWDh2MGFrc2RtR0tT?=
 =?utf-8?B?VWtESmN2WEs5ZDM2elJ1T1VrbWdjbnpCeDZvRXpHQXEvM2NhK3dnTjRVZHIx?=
 =?utf-8?B?YkFjWnZ3ZWpaZHNFRFY0dVA1SEhqc2RzcTFUemNaSEZDU1lOTWdXZHQ0cjRG?=
 =?utf-8?B?a2VhSmV0emRZY1FCcUNRZFBiQW1YR3NXTm5Wb3RZK25JT2xkS0pJTk9KQXVi?=
 =?utf-8?B?b3d6SjVObXg3ZVNKQW0wb1lXclN4bElna2huaittZS9aUkpZSnI0TnFOaFNZ?=
 =?utf-8?B?YTVoaWtkSnhFY2RmMXlGL21zY05RYWg5SmtxR0sxSGgzYTduY0ZKejg5d05u?=
 =?utf-8?B?SG5pNDhMSXFWNWsveU1WN3doN3BWakY0SDNXMGJ3dXlTRjQ2SVhkNzZiQzdT?=
 =?utf-8?B?MTNmVWhMQmNLUjgwSWIwZlhGWHQzYm9jbGNOSHlXR2dISmd0WExkcDUxeStm?=
 =?utf-8?B?aWtPV3NjYjNsMUh5bjM1ZkFOZGc1WWE2dzdoVVp2MUhvWFcrSVE5MEovdjZk?=
 =?utf-8?B?VE4xcHVQRUJzOGhYZzZ1eC9GZlJMMEx3VlNLVEd1WnNCSUlOTjV4RGh1ZDZW?=
 =?utf-8?B?Y3lWVHgyN0FDK3FHbGRBdnN6SHI5bGNXUFcvQ3hsWisyK1F5OEhzT3BDL0ZW?=
 =?utf-8?B?VFFGNUl2bDY0L2VNRURvODZPYmJGV0I3RHJFMFM4YUt5bm5KM2daZEpSWUFY?=
 =?utf-8?B?ODdqQWw5VzBXbVpMelRJV1p4YUVHRzVqRlV5KzdSTnQzbVVrVWNWZVNjaUFI?=
 =?utf-8?B?amFUeWphOTI0U3VHZmc0QkpTYWtSdXhHR0h0c2pWZmFvNUdpMkMwUTBsMWVO?=
 =?utf-8?B?dlZNYm82cGloazZ0VjJKK1pzSyt2Q1dBUktIT2RObUdHSW1LdEt4L3p6d1ZB?=
 =?utf-8?B?ejBDc0Q5VjFGdmJEQzZ5MmpCWmZKWXNCWFBMSFl1V1ZlNEkxbWN6NkRJd0tM?=
 =?utf-8?B?V1NFWUFhOTUxbVJTYy80NFB0dFdDZ2U5aDczbC9uRExScWR0cTU5RzNLQko2?=
 =?utf-8?B?VEJTVCtLYXRKWlFzRnA3ZEU3MVNlZ091YXRtMm1yQk1jSzN0NXVIbUN1eTgv?=
 =?utf-8?B?Qi94UnRYSUNZSUZEckVnUUVHcFFKOGJWRFBvT1BsUVB3cThDcmlXb1pCbDJr?=
 =?utf-8?B?M2hRYm9CZkxEeFJZQ0hYbCtGM2xibEdMN3BPZVpma1orLy9zR2lUTHBwQm82?=
 =?utf-8?B?NEdNN1Y2NGtXKzU3Ly9raElFWUJuNUxTd2krZWRsVHB2dWR1NTZsNVRrNGpH?=
 =?utf-8?B?eTJ2Ti8wZUFzVFFBdVc3MGVWTm5OZ0psSURIUU1SYURudHJ3OGh6Z2RDN1FI?=
 =?utf-8?B?MEllQmhReW5wN1NDT1F1WjhVaUg2dm9OR3c2N3V2VFVvZWZVUWsrS0lrWExV?=
 =?utf-8?B?V0pLQ0EvcVQ4TUswVmRlcGVkMDA0dTdZNVUyQkJBMmlwUCtZa0srOGxpWlFz?=
 =?utf-8?B?V2RjRWlocTlkNUppN0FjVmFCV3R4Sjk4VkdhL1JYQ0NRY3VmdzdBUWE1WVZa?=
 =?utf-8?B?N0l4ZFZjSDZ3YTdTTUZqZ1pvaDJJWE5vNEFyN2dFbjF5VlNKQW5QYTdtejV0?=
 =?utf-8?B?OXJ6Ty9PY3c2YlMwMmFtTVY3cG1hejZiYUtoemQvY296THRuQ21mRHg4ZDhC?=
 =?utf-8?B?SWUvUWovTHlSYWZDWkI2N1JnSmswS1k0Q3ZscGduc2tLcUN0eGhmaVNqQ0dm?=
 =?utf-8?Q?s77yhnbTY2xx652zNv26PByja?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <902170156815894FAC043D0E35E92D53@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa8865b-8b66-45f6-3da7-08dd70aa3261
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2025 23:17:24.7959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q68urfEIlkIM3/1X3nb/oGxJBEOrDL2M8z+6N1MAA5+c5Oav+X2grK5z+lWjGQuSPsXEeyAjcHbUMcO3yX52kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8562
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTI0IGF0IDIyOjA4ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRW5z
dXJlIHRoZSBzaGFkb3cgVk1DUyBjYWNoZSBpcyBldmljdGVkIGR1cmluZyBhbiBlbWVyZ2VuY3kg
cmVib290IHRvDQo+IHByZXZlbnQgcG90ZW50aWFsIG1lbW9yeSBjb3JydXB0aW9uIGlmIHRoZSBj
YWNoZSBpcyBldmljdGVkIGFmdGVyIHJlYm9vdC4NCj4gDQo+IFRoaXMgaXNzdWUgd2FzIGlkZW50
aWZpZWQgdGhyb3VnaCBjb2RlIGluc3BlY3Rpb24sIGFzIF9fbG9hZGVkX3ZtY3NfY2xlYXIoKQ0K
PiBmbHVzaGVzIGJvdGggdGhlIG5vcm1hbCBWTUNTIGFuZCB0aGUgc2hhZG93IFZNQ1MuDQo+IA0K
PiBBdm9pZCBjaGVja2luZyB0aGUgImxhdW5jaGVkIiBzdGF0ZSBkdXJpbmcgYW4gZW1lcmdlbmN5
IHJlYm9vdCwgdW5saWtlIHRoZQ0KPiBiZWhhdmlvciBpbiBfX2xvYWRlZF92bWNzX2NsZWFyKCku
IFRoaXMgaXMgaW1wb3J0YW50IGJlY2F1c2UgcmVib290IE5NSXMNCj4gY2FuIGludGVyZmVyZSB3
aXRoIG9wZXJhdGlvbnMgbGlrZSBjb3B5X3NoYWRvd190b192bWNzMTIoKSwgd2hlcmUgc2hhZG93
DQo+IFZNQ1NlcyBhcmUgbG9hZGVkIGRpcmVjdGx5IHVzaW5nIFZNUFRSTEQuIEluIHN1Y2ggY2Fz
ZXMsIGlmIE5NSXMgb2NjdXINCj4gcmlnaHQgYWZ0ZXIgdGhlIFZNQ1MgbG9hZCwgdGhlIHNoYWRv
dyBWTUNTZXMgd2lsbCBiZSBhY3RpdmUgYnV0IHRoZQ0KPiAibGF1bmNoZWQiIHN0YXRlIG1heSBu
b3QgYmUgc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVs
LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
PiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCA1ICsrKystDQo+ICAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXgg
YjcwZWQ3MmMxNzgzLi5kY2NkMWM5OTM5YjggMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtNzY5LDggKzc2
OSwxMSBAQCB2b2lkIHZteF9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbl9jcHUodm9p
ZCkNCj4gIAkJcmV0dXJuOw0KPiAgDQo+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeSh2LCAmcGVyX2Nw
dShsb2FkZWRfdm1jc3Nfb25fY3B1LCBjcHUpLA0KPiAtCQkJICAgIGxvYWRlZF92bWNzc19vbl9j
cHVfbGluaykNCj4gKwkJCSAgICBsb2FkZWRfdm1jc3Nfb25fY3B1X2xpbmspIHsNCj4gIAkJdm1j
c19jbGVhcih2LT52bWNzKTsNCj4gKwkJaWYgKHYtPnNoYWRvd192bWNzKQ0KPiArCQkJdm1jc19j
bGVhcih2LT5zaGFkb3dfdm1jcyk7DQo+ICsJfQ0KPiAgDQo+ICAJa3ZtX2NwdV92bXhvZmYoKTsN
Cj4gIH0NCg0K

