Return-Path: <kvm+bounces-46839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACF2ABA1A7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AD833B5E40
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2737526FA40;
	Fri, 16 May 2025 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cBO8zI5O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6131212B1F;
	Fri, 16 May 2025 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415424; cv=fail; b=HcAJLvJYqzElp4yut8onuU/HyUHO7Rh4sOA18tw/fzLAheM3R6Ns1iLWIsRuG5XW8fOOVsP9bAS1yi2nllaH3H2kKiRYOdIePnevAmyHvouSygN8XoMLei4cKw4fggFYubAXkMFe+CIiII8qhuvIY9qn/U9q6Cvbg8QCaFONgZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415424; c=relaxed/simple;
	bh=H8hSvFN7PYipRH/8Y+H8f1wOsMp6SsOlQD+yGLYm+MQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FQSis/qKbfZn/MI39hBKxBO5ly1ZRVUHauPHL9ButgMe+dSiDrqud0KArFoPj+RCUldK5J9Dv0iFPR6hQyt0keVkdvreClgeHLQknEucsEc4YR4QRXAvDGCLMspMko1PgBCn6q6Oy0BbOX2fDzkdGWkZnr5J0Jve+E79WJxvQKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cBO8zI5O; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747415423; x=1778951423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H8hSvFN7PYipRH/8Y+H8f1wOsMp6SsOlQD+yGLYm+MQ=;
  b=cBO8zI5Oyk0C1U9PBqnxTJKqsCqJKX8Ulzl7D3HoBKir4MJNTaL+CfTT
   oQsIUedHKcwA+lKas9wDsGcKc5YE7KyVAiDHVbVWL49xaW193G12CYOAB
   8+3SqBw0hvZuw+GuQ0IDyeULNbuCRzceCvrzyDOKvtKECaWdwK2aAChJm
   2/G8v8vLm2iGAfgW2Sn8B4FiPNwviymikM0tsAdZD78VDgaBa65gBw8yg
   +AwSFB3zmI7/cW9vncpRcyr9A54QBhkfc3hA2Qjm+kdzGfc2w3VMTFEyv
   K5zkSvQf1HnPTOiQ0YXyYyNL0djZ//p9l39oodAKgwkU9qBEgAkGeKK14
   g==;
X-CSE-ConnectionGUID: fC40SrlFQBGyvXeWmNYJQw==
X-CSE-MsgGUID: vxQkx8KJRiSSYKVBODAEfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="49271612"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="49271612"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:10:22 -0700
X-CSE-ConnectionGUID: XBVS19m1THGpuuO1sAkc3Q==
X-CSE-MsgGUID: gSX2t+7yS2aMnCUnQ+kbyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="138484776"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:10:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 10:10:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 10:10:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 10:10:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfXLzNHhWQ9Gen3TcIxc9J6IvxHkxT0Dx21I0CSD0Qs6A7fvsZhM+FkiVgxhlS+ldI+Dw5qxYCV/o+pWcJQeLuW/e5qnL+Gs1A6g2bkIcH2tbRjcg7YePzE81Radacyww1yJAGwZH0VtTOPXbxhXnDzKRM4Thp+zGSiYOs6n+D5VHR1k36CJYKVXDNBnM0NxeROxVfmvV05+b3weqehz2wjZ/M+g9YjW8o4Bs/thq+bzpapmt89EgapDfBYFWeFPFUEGnIg2Nh04885h2Emo2KXmOEazSWgtKJQktHpGk0G7gIHSWan6BYHdxA6U3YSGU/+PZ3N44AIrNA1a3Tb4hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8hSvFN7PYipRH/8Y+H8f1wOsMp6SsOlQD+yGLYm+MQ=;
 b=AkIVGuqGtnCL2Re775eQVervDFzrIBWGIcQq4QXv9pKeIYZky3uNYy0R3h7PFA85Zkcmd/I2VflyDCaiUHOvGLpfMR6bpylbqTNjLbfxTdBl+fd0PhzPvn0crb/xpTPqXThG8xFtHZUkI/d2TV5KTHrZljijl1sdoTF3Nqgw9f0T/0JDcI78bRJJGYuQxLjRs9mh4E1SZcN74Z2OJlRXyanpbX89QsT8wA8NENeQdIH4Uz6wD2s/2umbS6Vrex9X9/e6Mypz4VcYCHVv9MkHPPy/GPBspOGh3CDxc6XqelDdLqWmdDGsOufO461VqhOHdJtf8AViPk5T7fUguZ8uHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7580.namprd11.prod.outlook.com (2603:10b6:8:148::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 17:10:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 17:10:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbPRBuIAgAQS2QCAAIeFAA==
Date: Fri, 16 May 2025 17:10:19 +0000
Message-ID: <5111ce8e57dd1e26538fcd191148d624c2707773.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
	 <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
	 <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7580:EE_
x-ms-office365-filtering-correlation-id: a4cb0aaf-d2c1-4993-4663-08dd949c8943
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WE95T0ZQU1d2TGp0NzQ2Z29ZVGdBbkNyU3ZkWGFaZVRqeDVTb3VUZW9hc1Mr?=
 =?utf-8?B?RDRJUHB0QjRrUS9XdEh6YjZyR1dlamhJM29MWWd5d0lON3YxZkRRT0ZNN0cy?=
 =?utf-8?B?NEUweDJhb2tFenFGWjJnaTQzVTJTa2I3WXZ2dXFVL2NqanF4QlJDSkNEM1hk?=
 =?utf-8?B?SmxvanVyaVBMU3NBMmVaRXRrMFdzek5kdkdJMjI3V0k0VXFwR3F3UUlTcHVP?=
 =?utf-8?B?bnVEUmNmbjVvdmhVcUNzODVKNlkxYnVYM3dqeEF5YVk0TzhYZDNGa2JBTDJB?=
 =?utf-8?B?eE1nTjZOaHA5ZkpPNWZDN2d4WTlXRkpXbFZwWG81OXpBNkpsbDQzVzQwanlN?=
 =?utf-8?B?RDNwZ1N6V0h1dC9IZ1dXbmJZTUYzQ085ZGFtTFRqZ1lCV1FJc0JPVXRGbTFy?=
 =?utf-8?B?UnlaYVdCM05kWHVnMVZzZlBRNGQ4aVFxWG9VQ3lZS0RucVI0YUFoZmUybTNl?=
 =?utf-8?B?MHdzTkhENWVxZ2dHYS9jdmFsZ1VsanNrMnZ3MWdibUs2alNKbDR5YUwyVktT?=
 =?utf-8?B?V3FEZ29rTjZudFk2OFJ2SmdFT2xHZlZjcm1QWE5Yd2kvK29IZDZxZU1tK1RD?=
 =?utf-8?B?K1Vpcnp1S2Y3aDU4N1FMbzdBYVA3NzRhbHl5RTFZeUdtVXkvWlUrYlp2OUJH?=
 =?utf-8?B?cVV4SWZLalMrQS9LbzlEMkFDZFE0alNUazJPSHZhYk10amxkN0xVRlJNZzVT?=
 =?utf-8?B?cGFyN3NxMlNtbzVoeExJR05rWWl1OUMwSzRTTDNnK0xKbHp2S1kzRDA3ejND?=
 =?utf-8?B?Y09QdXpJbU9UeE5mWlk2S3k2d0NQUlcxQzZRSU10b0hSdGlsamgycC9xeGVD?=
 =?utf-8?B?ZXdmTnpXVEx1MXZvOTNiODErdEJFeXpxT0VUWVdwckVwc0g3Wkp5UkttemhB?=
 =?utf-8?B?V05TSGxTMFgyWFE0R3RYdnFPR3JFdUFrQ044SVY4Sk5ycGdpb1RQRE1sWE1V?=
 =?utf-8?B?SEpUdEZ2ZTc4S25yUVd1YWs1cEYrWlhMSUhZM3R2eGxjSDkzOWhKTGRQTTZa?=
 =?utf-8?B?THVZOGlCWncvZExKSVJxY0RtVkl4Uy91QXRtSlJTYjdSRXVPbUozWnpCU0pM?=
 =?utf-8?B?YmJnVnhvTklyNi9kc2x1ckhDeTk5YW1vNnM0bWFBR3VyM21EZkNLaFpGOFA2?=
 =?utf-8?B?cEpyS3hYQkh0WDduNElPY3BFRnF3RzBlQzVqdHk3Z05XZ0J1eDJDMFZ5QVZa?=
 =?utf-8?B?WDFmWmh4bFljVXJ6eVpzb010M2hMallsNU9CNGd5WlJrSk85V0tZSjBFSHVS?=
 =?utf-8?B?ZHdFRk05RWNZb3dGcUFoTW9mZ1B0Q0xuUG9ReTVQNFl2TWdodWZQdHdtMm5I?=
 =?utf-8?B?c0R0bVJiTGI5L242czlOc0FyR1Zpb3lOOUNWZ3JzZGRKZVFFSGo1aFZFWHdH?=
 =?utf-8?B?VUUwTWRGRVVMUlcxajNjdTA0SFlUcTdyYXVxZjh0a0J4MEVOZVRVTmhzYWtV?=
 =?utf-8?B?d1BZaUI4Umh6eHgzZWtzd1UzaFBhZ2JBa2xJSnUyTVNMenhTYUZoQ05BY2JZ?=
 =?utf-8?B?YkkyL0cwWHBxWmtYcXp5THVISFFpODJpaGFKWTBJREx2K1lGR0xkZkxQWXND?=
 =?utf-8?B?VVJZcExOQUI1d3hNZ0szd2FTOForUHBmd3NEZDFSWmtYdkVqY3NWNi8yWXNx?=
 =?utf-8?B?WVp0bHVBKy9EUzloakZwVjcyRlZpblAzUzE4SXlBK1RZSVJMZW9Dc3QyTHFs?=
 =?utf-8?B?YlNzdmV2eHdEeVFxOTErTHpmdndVcitDQzFyUjVHOW1BT21uR25KaFpXNlBN?=
 =?utf-8?B?TG5rZU1JU3RaQ0NrcWNqTHpWMXhheDd3dysyb2FGVHZmTVFjQmpCaHFyZ2do?=
 =?utf-8?B?VjJwbXhBbU5oMDJkMTR6YldIa1lNZkJCR0RjTjdQQ3htZS9Scko3M1pNSUdx?=
 =?utf-8?B?eUF2eHh1dnNpcHh1cVA2aURnRUFiMDZMOFFaa2JqbXc4VlNyUUVZenNnWDl5?=
 =?utf-8?B?TU5kQnNhS09oVnY5bzhVdDE5cFBqWktoNkk0U0FpYWxVNkNROXk0N3d0ZUZI?=
 =?utf-8?Q?X7W9J7PYHxM+BXLi+YUOuP7TFniqOc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2NBWVRIZkhUamxrZngwSjhYSFBjRThieE1JVWVVRnI1MlZHbVd2U20yVVd6?=
 =?utf-8?B?ZUhMMm44d0t0bzltRWJOMCs5WXZTUHY2aUJ3Wm40TVlhQVpKb0JCWWdBN2xq?=
 =?utf-8?B?dmhLd0tmWTJ2K1pZZ0pacTJTMUd1VGRqdDJWQjNGZW5YejEvRzdiTFhOc2o5?=
 =?utf-8?B?STFRdEFjcW00VVlxbEVXcU1IOTlQdWVVTElReTVHYmtsSnR5NkE1SUdCcEk0?=
 =?utf-8?B?WUlmOW10MTlyTk5RWERjYU5HdmY5Qms2Z2EyandhTmplbDlyaFJrVnVOaGw4?=
 =?utf-8?B?YXRvZVdhblc1VWhOb1RpTm9la2dxbjBVcFJVaVAzN0dSTEdzaWcwSG80UEl5?=
 =?utf-8?B?OTlRV2I0ZldYV2xPRnFpdWJBZUVnc3VIYzVhR3FGd1l4Qk13WUkvNHM2Mmhs?=
 =?utf-8?B?OWFlOVhKRDBTVWZsM0h3T2NKU1FmN3RTVXhNRGc1aHYrdGNIUVlUSVpYbW9N?=
 =?utf-8?B?VUt6S0lUTHZKQ3QzdmxjaUFxRDNzTDZnVTVGakFLcGdnVVpzM1J0aVhndWdV?=
 =?utf-8?B?ZjNMZ2p0N0NRQ2FMTVNhckkvNVJsK2Q5ZWRUT3pwRHRST2laQ0xNSjR2WW5S?=
 =?utf-8?B?RUhYSElodEZ3VG41ejNQd3h2czZSeHNCak5GaHRTMmNwd09ha05rS1FiZVBZ?=
 =?utf-8?B?Zms0TnVobkJRdExPZFRqWjA0MXo2dWxKakV0bVpnU3ZZQkRqRU9OcWpXNmZD?=
 =?utf-8?B?K2RnUXNaWmRxcGI1dFVhYzVRcldaWk9KMlBSdjY1YVJqc1dZOXZnSHZTcEJx?=
 =?utf-8?B?ZWh4bEp2bjFwbXozZTVrUldoK21VaDBLRGZUYWFYY0xSSnJ0OGtWQk5IeEdO?=
 =?utf-8?B?UENzbFcyK1dJMnlmWStwcGxCMks4NFVQbjY3M2lFcGdtMGc3dU1WU0F0SDRr?=
 =?utf-8?B?NkFKOWFyOUNEN1gvck1qSFMyYzQ1Tnp6M2NnUjJEWXQ0RDFDdTVZYVZDODVZ?=
 =?utf-8?B?MkNyRXpSZFZ4RVJTblZQdFhqUjRIVnJpWk04RGM5K1BFUkhzYXM4Qy9CTmsz?=
 =?utf-8?B?OFJ5cC91WDMzTS95U2pIM3RRUUFoaktJVjlXMVFyMURJdFVHZE5HMGtxeldP?=
 =?utf-8?B?cG9uTnp5aWZDa1JDT2NuMXdFZndvSE9IOXNCbXpKVEt2NGI4MUozRm04V241?=
 =?utf-8?B?am8yRks4eHBkQS94bENYRXBiem1BUjVORGh2WC9rS2xSR0IxaUMzWXlzaTg3?=
 =?utf-8?B?N1pLdXRBVmNVdi9DampJWHQ5UUFDL2ROMDY1K3V3ZlhGeHhZMklsVXZVWVMx?=
 =?utf-8?B?MlVuT1ZvTHI1c21UZUdRSnJpWENlK0NTR0k0RkN6dnpFanpBLzExa3hpaGo4?=
 =?utf-8?B?c3VzeXVJZ2VLN21vVmErRUJ6RDBzaEY2SmlsVHRzNG02cXQvUjM1bitFNnBw?=
 =?utf-8?B?UUh4ZStsMm93WGJqd1FMSGZVbW1TemM3b0ttU1lzYm1HbVVLZ3N0OVVKSzEy?=
 =?utf-8?B?Tk03bHNid0N2dE4zNmdTSnQ3STl6VXA2ZWcxeGl1Nm9UaU9HNXRHT0ZZaVJa?=
 =?utf-8?B?NmpxSEtrc2QxMk1yaU1EMkhHdk9oWHBRUzZzcjJLZjQ5VkUvekwxejMxYTNh?=
 =?utf-8?B?SXRsV21RQ1FQdUdZbTRIbDRXblRPdEJiTDFTU0FWUUJQSEpOVG9CcDhFZjRD?=
 =?utf-8?B?dzdQSS9GY2d6UG92SWJFVERybGxtdkFiekJNdFJQalk3bDFJcGhYNWJlR0tp?=
 =?utf-8?B?Y3psVjdSWTNaOVMrZW5peU4rN2tVclNna21Dcm9YNWhBZTRlUVpDM20wZmhq?=
 =?utf-8?B?S2s2WHJBZ2lHNzZIc2lNUTloR3pFMTQrNzZhN3MxUk0xa2RHREZEdlBYQXA4?=
 =?utf-8?B?TnhRR1g1aTlFVVI4MTFCUk8veHNsOWI2bithdzZvTjVYb3B0Vlo0NnZKQmJS?=
 =?utf-8?B?NC9yNjNjUzl3M1gwK2pOMittSC9weEVTUnNrY0NVSVFUSzZYTGlYdUpYWjZp?=
 =?utf-8?B?aUhLZEIvUy9sYkVhRVBPZ0dVakhGSitmcEpLS3M3TEJIOC9oY3ljZnJ1U256?=
 =?utf-8?B?dW93bGhLaHUvSWlHYk9TeDREdnJYbEt1ekw0TGxrU0t6R2p4MEgyVkR1SnhI?=
 =?utf-8?B?d2RtcW81d0JhdWQ1V3BmUjdTSDJycTcyTTFqYkpGMW56d2JKZkNheFh6bWx3?=
 =?utf-8?B?bXZleDFUYlg4enF5NXhVVU5DSFVKNUNPVW1JWk96S2R0VFJJazVYdWx0VWJO?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C05C6DA283AC74395BF07FC72990BD5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cb0aaf-d2c1-4993-4663-08dd949c8943
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 17:10:19.4951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GcJ9jQA5UuVqx6HPf1i3M+6BYM9oXxcimOzvXgiQwclfFEDEJLf23sETAf7lycqJB9kSKHcSBUxH0dpQKpCe2Li5W240y58H6lhJK9IY3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7580
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE3OjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBT
byB3ZSBoYXZlIGxvb3BzIHdpdGhpbiBsb29wcy4uLsKgIEJldHRlciB0byBhZGQgYW4gYXJnIHRv
IHRkeF9jbGZsdXNoX3BhZ2UoKQ0KPiA+IG9yDQo+ID4gYWRkIGEgdmFyaWFudCB0aGF0IHRha2Vz
IG9uZS4NCj4gT2suDQo+IA0KPiBPbmUgdGhpbmcgdG8gbm90ZSBpcyB0aGF0IGV2ZW4gd2l0aCBh
biBleHRyYSBhcmcsIHRkeF9jbGZsdXNoX3BhZ2UoKSBoYXMgdG8NCj4gY2FsbA0KPiBjbGZsdXNo
X2NhY2hlX3JhbmdlKCkgcGFnZSBieSBwYWdlIGJlY2F1c2Ugd2l0aA0KPiAiI2lmIGRlZmluZWQo
Q09ORklHX1NQQVJTRU1FTSkgJiYgIWRlZmluZWQoQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQKSIs
DQo+IHBhZ2UgdmlydHVhbCBhZGRyZXNzZXMgYXJlIG5vdCBuZWNlc3NhcmlseSBjb250aWd1b3Vz
Lg0KPiANCj4gV2hhdCBhYm91dCBCaW5iaW4ncyBwcm9wb3NhbCBbMV0/IGkuZS4sDQo+IA0KPiB3
aGlsZSAobnJfcGFnZXMpDQo+IMKgwqDCoMKgIHRkeF9jbGZsdXNoX3BhZ2UobnRoX3BhZ2UocGFn
ZSwgLS1ucl9wYWdlcykpOw0KPiANCj4gWzFdDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC9hN2QwOTg4ZC0wMzdjLTQ1NGYtYmM2Yi01N2U3MWIzNTc0ODhAbGludXguaW50ZWwuY29tLw0K
DQpUaGVzZSBTRUFNQ0FMTHMgYXJlIGhhbmRsaW5nIHBoeXNpY2FsbHkgY29udGlndW91cyBwYWdl
cyBzbyBJIGRvbid0IHRoaW5rIHdlDQpuZWVkIHRvIHdvcnJ5IGFib3V0IHRoYXQuIEJ1dCBCaW5i
aW4ncyBzdWdnZXN0aW9uIHNlZW1zIGZpbmUgdG9vLg0K

