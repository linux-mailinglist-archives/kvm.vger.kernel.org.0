Return-Path: <kvm+bounces-46922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C41FABA6B0
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC3141BC736B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F33E280CE8;
	Fri, 16 May 2025 23:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7GoXfrd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9481A256B;
	Fri, 16 May 2025 23:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747439259; cv=fail; b=quNIy/hIACZbBHCetP0uS8K98oLwY9wf+K97tQZK4I9IE47nFyOWY9JhpNCPiaUN4jZm8PRJ1N+9xbgwYwppSKYfHPvUIJR/oYBioRV6k0mxDWqmtGJS8ezxWvzZcbnPbFHuxt/Sruf21uBVgO2ootOwr5qeYANVbx2NQbOOunI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747439259; c=relaxed/simple;
	bh=jJuumiCLo/ZD6ZF05eGUJN1B/3J1xyQnTlwx5P3pOpI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oeAc8pztmLjy4hJZjx+DYFkjjebSBJHifynyt34yDV3P1/LifJ2Xfy1SI6cfpBFYcZcA0oFrSenQgraXjGGZldvEJYryA1K/xdcgViNDh0yipDf8vqNHX3EQ+PekcSomWc2/NRRdeY8bvRrik9Mg2lSResLTjrlMJ2ZmUzGYBUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7GoXfrd; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747439258; x=1778975258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jJuumiCLo/ZD6ZF05eGUJN1B/3J1xyQnTlwx5P3pOpI=;
  b=g7GoXfrd2Iy9xGeL8eOSCmwYsg4NcQ6kT24wbm/m/D6wLSmzkVXiXYGh
   52E+9+1gRmA0HoiyuG/ynRqLl6kSqGpBeiNc7QNuPonHcyLts8Rst08rv
   AsdQo67NPGOhbG/M2nYxbqVfjkSD0AnKf1TxuBSlq9M5le+bouwDPuqzs
   3VK9IRePsubTaPYexTrWGaFzXGuCZEZjMY5u2EWv5GHYmZUGhITspox6a
   l7+PEFBFf77cGjxa6EmTUrNDNMLXbWNLhSCuWArwoqSqY4rOHFT24So2N
   KF0AzimpaNSwncXIeb0ofZ1F+r/nHaTHMduRXWJcSAUNJT1mCLssqW+dk
   Q==;
X-CSE-ConnectionGUID: clTd3sh0SJGQQEXaUWnCfg==
X-CSE-MsgGUID: mN3ikdzhQVu+grVhXpgZ2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60060910"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60060910"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 16:47:37 -0700
X-CSE-ConnectionGUID: Zbp/8L2NQduIpMzB2Y10Xg==
X-CSE-MsgGUID: RvyRdCqpQj2rnUK5rMR4OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="139228767"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 16:47:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 16:47:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 16:47:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 16:47:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izzVd0oGJBqWGQWyXm2h2/YzNSZSwiNy3hi6vVfTw4r9RWWjXpZS1K75wQmHz3Hf8zJliePxNdpNxD8IzOhK+xTmCxN3cuRTuoseJ0h6np7ezwufS4fabd7gj4JEOqyw0vB5OCIFXN0Ww/hVOBFQN+jgdzHn491mgKoUkJnrm6MSCdXti3/izNoud7mK8BAKk/Npz3pK5HF0IyBxhE0jhH6QgSQF6fz7dFnWSdGBQoHkIF9fhlanWyHbv33j0cwjZ/YEEBYXGZLxZqC1/oTb5YGON5LcsS1YBMCHkdLget4ZJQ2+93PG8VXKJUR21jLOjow32Pqk0NT2cVOf6sNhBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJuumiCLo/ZD6ZF05eGUJN1B/3J1xyQnTlwx5P3pOpI=;
 b=OnetqOWK+iKlvdDx7g2+sKGQ/kvHYzFrsWZlndrQ2VqZjnPG6IcM04W+M/Exm0ZddoqQTVFGGu/Op0H7KsUlE54NefxNHoB9F/YY+/RV7juLeuTF/96MjYPO+eBsg3rodok3pc3AWnHM8IChgAWb85OFkEV5UDJ/JVfsQCSI/aK6PB1Xu9h7nEaL68Qlz228+jdkhfTHWKclehQsDXb/wUBhYDOnorrnBZwvveQ49oWF2V038rRcsP844uuAmy1ZiN3G62gDiFdBoC/X5pq3dEIDOTzfBamZKidK61H046YSwGLcDynMfhfJqXb8vzI8MQ8y55wBXsUifwh74IezJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS4PPF2720D4410.namprd11.prod.outlook.com (2603:10b6:f:fc02::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 23:47:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 23:47:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAAT8YA=
Date: Fri, 16 May 2025 23:47:19 +0000
Message-ID: <a228fc5a355aa8dc80314648a8c37a6500d34ebc.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
In-Reply-To: <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS4PPF2720D4410:EE_
x-ms-office365-filtering-correlation-id: 9290a703-07cd-49a8-588f-08dd94d3ff4a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R3BMWUtaTVRoM0N3QW1hNVNZaGNjWlZ4bENUUVBvVFdnZjVHTFFpTXExSGlh?=
 =?utf-8?B?cmloTDZXYmxZRm9meHhmeTJrcnh0cHBkTE81WHdYNnJoS2lvUHNhRWM0a1ps?=
 =?utf-8?B?aFhmL09wYmR0ZXVPNVBCM0dSNmR3WUxqZU1sbmQvTzJXMDY0VDVPWmpNVWpP?=
 =?utf-8?B?TlVjWGFjQkhobFI1TlJFUWM1OGZ5b2JKQ1BRUDNmclVMSDFLM0tIdWNIR2JX?=
 =?utf-8?B?eTh3RDA0YTBkTmJQU1NRSFlDRlVBVGZQS2JtditwbS91V0ExaXBSY2RPbXVu?=
 =?utf-8?B?TE4wTnF0ZzZCUFN1RlVGeklQQklFdU81VUNzN2xTR3d6QWpXcllnSVdRZ1Fm?=
 =?utf-8?B?UVUyVmFubXhidGxzRmFzVlpNdFhCOUxmK3l5SEh6VHVkc2dRYUc3WGYxSUR2?=
 =?utf-8?B?bTUwQkdLcitDbW1pa0c0dmtuUCs5RVdGdDUrL0lUL1pSTnZINHlOUEdWTnlq?=
 =?utf-8?B?cUlld0tHZCs5NFJLMTBOU2RYbm53b1N4Smg4U3JmOFJYSmRLeEF5eWhpOWVw?=
 =?utf-8?B?S1dEV3BYa0tVd2hBeEVVTmQ5ZmxDaTUrUnVqWExQVktzZ0JYdTIwcGhKOXRZ?=
 =?utf-8?B?Z2tYc01FNkQ2QndQMkIwdzFUblJIb0xvZHFGMWxzNU1aNDdMekVUbTk0T0Vz?=
 =?utf-8?B?MXJ3SWJSblVlM3VLMnFWL09RTmUvcUU0ajY5RDJkMmpOc3FtbUw1SnhtbHFN?=
 =?utf-8?B?TGx2Skx5bDkvejNYbnJPeEtDZUUzcTJNR0o1Q0RvMWdUbWtWTUdXU2Yva244?=
 =?utf-8?B?VWVEanJ6dGZLSm5vZDhvckRtekk5ZjNZV3RxNUh1dHdqa0hxL1IxMWI0NGZ6?=
 =?utf-8?B?cjlpNkxZbENET01rcUR2TFJtQm9VNlFCbXNFMmZhZk9haVRxU05xdEplQ3V5?=
 =?utf-8?B?YlRBVVMvNXIyRVh1MVIzNnRGWUNEaVgvWTl4QzFzWmdObU9hMnVsMnhZQisv?=
 =?utf-8?B?YUYrRzRHeUkvSER0S1kwc0Jsenc4czBVSjFaL2hjNysvVGlsbHJuWHAvOEw0?=
 =?utf-8?B?SE02amU0TU1JNWJmVHMzU2k4NVMzVzF1QVhndm5YR2RpZnZiMXBDRVp5d1p3?=
 =?utf-8?B?OGVxeU9iRnNPWDRBdEFsM1lqTDFJdWcvU3ZJclBIakh2UU0wenM0eExzQnF5?=
 =?utf-8?B?THIyVkJmVENkbzZSUGtwYmQvRFB6NER1aEhqdktydVl2S1o1QmxFcWhOdFo1?=
 =?utf-8?B?bEt4NWVJejlEbTBCUVBrdnM1M1ZMSHNjRUJtRThtUVVrWi96ZlY0ZkprdWJ1?=
 =?utf-8?B?cExiUXBPRFo1NEQzaENKY1ViTXpScUl0YXlldGx1RlF6b1FBOThGbHhSMUNV?=
 =?utf-8?B?K09hNmFEWnUrQzZWblNhb05VaTV3SDkwME1vckQ1OUZvaUJJcHppZUxNOGZw?=
 =?utf-8?B?RHNGUlJvOVpyd0N4ZmhDK25tdjRIc2hkTnZzM0tTWG11SXI1d2tWOUpOc3lu?=
 =?utf-8?B?OEpGbjBuMlF0bFdsY1VieVViaHdNWGhwSXIwcjJMcGtSMzluQ21jdk1jWU93?=
 =?utf-8?B?WDlKMFZ3N0tGUEJqS3RJdUxwTjVMald5UFFJdXZXRTlqUjhwRVhoUGZtZmJy?=
 =?utf-8?B?SnRZY25PczBFNC9ZVUJVenN1REg3SHF4TlNDQU1oS3c5a1Z0Si8xQnlPNTY4?=
 =?utf-8?B?T0k0d0dsTGl6KzRDMWRMV3Y4OXA5TlZhamYwSEwrRDFKYUZLS1NVS1FNTU5k?=
 =?utf-8?B?Sk1aeVl4TlFCNUswbGhJTG5EdHcybmIxM0pJUXlZQlc2VFcvbVBJZjFCQ1Ra?=
 =?utf-8?B?OGN1M2Q5QnkwQzJwNElqYnJiM0RQVlo5VkNBWFZ4V1NxSVloc05zdmJhMWIv?=
 =?utf-8?B?RlFlVTdXeGEzSWQvR0xTV1RSNmlwY0p3TUg0RU1qL2VMS2FDU1djQjBCLzBn?=
 =?utf-8?B?ZmZ4cVltTkNUVDZOVk1nUVlZS01VZjRSY0VPOExzU2g3NFJFV1ZFNWF3MGt0?=
 =?utf-8?B?YUdFZHVId3VUN3dhZjJ1cll3OGhHNXVxZWRZYlBrb0ZjKzBWYTdsZFFnd3RS?=
 =?utf-8?B?K256WFFKcll3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzlrSnhxY1JRRDhDRERDWGRpS05sdUJ3WGR0MG82Qll5dHB2Vy9aRTk2N0VU?=
 =?utf-8?B?NCt6Ym9Pd0dZVXp4WkQreDNnZjRIaWZaZzlVbTRVN0lGVUtNa2ZkK3pON1d6?=
 =?utf-8?B?bEN1UTZhZnhMSldhbHJ1NlB1VXZHdjhuTnJ4TnFrUHdUU0pJajZhK283UnhP?=
 =?utf-8?B?RkFTREVJMUJsYy8ybi9PNU5qclV0OHdkSndpN2I3N0JjZDBnbkduYm5NUll3?=
 =?utf-8?B?OG9PeFhBQ3VOSWJBZ3QwQWw5RTBhbUdYelVMdzUzVmI5ZnJpQUFUY1lmMmVs?=
 =?utf-8?B?L1FaOWZRcVB2SEtXZ1lpNmFoZDBrWjVzRzgzZERwNDUvQ0c1NFduU0xZSzlq?=
 =?utf-8?B?dWRKc05ndTAxYVRFYTMzYXF6bTFOZUd0RkVtd2JWaEJ0N1p3ZHFSS0EwWlhF?=
 =?utf-8?B?ZkdJSmY1NEY3dm9CbUNWdlJmd2l3QkI5ZFBNcFFJTWRZWkhISTFmMWJhdmNF?=
 =?utf-8?B?ekdCbVozWlVuQ3l1NGt6MHR6VXVQa2VwQVVhV2p1S05xRjV6Y09JR0sxRWxM?=
 =?utf-8?B?VmIreVhRR2ZWU0ROKzhodmY5cXNQVEdhSzd1NllVRHJGN1piY0d0djhZUWky?=
 =?utf-8?B?QmVrWEVNeU9ndlc5WS9VTzBGampFY0prMERKdG8zTkpzd3plbjlpUWZNWi9p?=
 =?utf-8?B?VFp4b3k0VVdLVHh2V2JRYStCcHlLU0ZoVmk2WDl5Y2dBTnV5NVNQcGY3UjFP?=
 =?utf-8?B?SEFMNmdJMTZuSTc0bzZKVXZPMlRjWTh0UDhaT2FGZktkMTA0SGpYTUc5SEIw?=
 =?utf-8?B?UlRPY0ZvWktBWDRuRUs5bGtWKzhlbU1XbEZPMTFQdXJHTFRVVGRLSStBVEVw?=
 =?utf-8?B?L09LUUZKamtBSko0b1U5ZVYxL21mTGN0TjlVRW9oaW5rRzdjK0loTkdLckFT?=
 =?utf-8?B?S0o3RlM2MEsybmViUHVvQ0V5WDIvSTY4WUN5dmFSQm9ZN211UUNZTmpRSklP?=
 =?utf-8?B?T2h6andndjFMd3QxMDBFVElUZE84dG1RN2ZJQk9mek8wSFRaMUswSGtyeGRp?=
 =?utf-8?B?SFlzV1BIZXp4emdpc3VkWjhWQUdwb1ZIZ2JHKzFKejRza0d2VS9aVWlRNHRJ?=
 =?utf-8?B?RXRNckhVTE5SdFl2UUQ2dytMUWxZazFjdHhKQkNWUG9QS0RwMFR4ZGVnQ01k?=
 =?utf-8?B?dFJ4UUJLMFIwOXpvdzlVS0szM0JDT2YvWDFMaE1BSGpPTW5DVEsxZVF1QTc4?=
 =?utf-8?B?Q1d3d1dWTkYybkUwRDdubTRuT0NyRnJiZWhOMjJDZmNPVTU1M3JoZVZpK3dS?=
 =?utf-8?B?Rzd6czRqQjM3L0NrZEpTcjY0eGlja29Jbk9qV1VIeGczUW1Dcm5yanRwQkJZ?=
 =?utf-8?B?RzFUV3ZaVjZTZUlvZ1BiYjNpU2cyVVFDblJjcHRJeUZ3YkNCQ2pCQlZJcDl0?=
 =?utf-8?B?ckJNeWk0SW91MEw1R2JqVE94cHM5TDZ1TGZPbSs2QjF1c0w4dnBXazhlZVZ5?=
 =?utf-8?B?RmtDdzNoN3pQUFFFY1F3QkJBWFZvc2lEdmxWN00vZXI2dHJjREVkeW9tc2hX?=
 =?utf-8?B?Zjk3V3c4NmdFbzBCZk9pY1JtbXdEZlpYMlAxWTBwWU9kRmVZemFQZ2pqbkdj?=
 =?utf-8?B?U1ZDTjJRbUg1alduYUdyZDNqcmlJdmVXNjZiSlZUTHJFZlpiZkFFVTA5RWh0?=
 =?utf-8?B?NWt2ZTVrNDJVT3g3WWJiSWlQb0xDZ2FYNXptbm9sc3RJZnVPSFQwdCtVVWRy?=
 =?utf-8?B?VXd1TERjK1RYOXhxZTFwaWpjMEQxaG5GL1haLzJKOWFsZ25pcGRFZEtZUWsv?=
 =?utf-8?B?Vi8rNVVhemVwbnNTTlZtdFhGdm92RGVMZlpEcWlneStJaVU2VDZMUDRlV2FL?=
 =?utf-8?B?MTFoeVNTQXJQWG9kcTkyRFl4RHdkRUdjejZNSCtiL0lRTUprdlc2bWg4SXFu?=
 =?utf-8?B?MURHZEU0c05UaFlobTNwVGFkd3BrRWd0UVdGM3lONHp3YzVTTndCZzBXTHJn?=
 =?utf-8?B?YjFQbFJHUCttTnJNSTkrZzA5L3hyQVVvaUQwYUcvK21GN29kUFgvZFk2aHFK?=
 =?utf-8?B?R2xDeDkwNEdLcHJTdkcxL0tJUTJ4TzVrbVNXQTZoU1VEekxsbTlJOTBscU5p?=
 =?utf-8?B?Ylo2VWlHRDF3Mm1JR2RBVFFxY0x4N0hhUlMwN3dHTFh6QXVHSTNkL2IyT1dP?=
 =?utf-8?B?eWNCOEVDK1IrSjlLbERkK3AxcnFhTnhQR01DYkVhTURINnNnL1pQb09Ga09H?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <137FC4D85C438140BDB5BEC091D47568@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9290a703-07cd-49a8-588f-08dd94d3ff4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 23:47:19.8088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uCB38lvswiZhGpMBtwdUlIs+nOFeQJ4xFu7yVKaBtxEznC47OUsMTCRGCHmB7vDDgmvuEPY9pT3pJ3DTrQMB7D8BgvyfYUqx98Xs/TTs/tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF2720D4410
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDIyOjM1ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IEZvciBURHMgZXhwZWN0ICNWRSwgZ3Vlc3RzIGFjY2VzcyBwcml2YXRlIG1lbW9yeSBiZWZvcmUg
YWNjZXB0IGl0Lg0KPiA+IEluIHRoYXQgY2FzZSwgdXBvbiBLVk0gcmVjZWl2ZXMgRVBUIHZpb2xh
dGlvbiwgdGhlcmUncyBubyBleHBlY3RlZCBsZXZlbA0KPiA+IGZyb20NCj4gPiB0aGUgVERYIG1v
ZHVsZS4gUmV0dXJuaW5nIFBUX0xFVkVMXzRLIGF0IHRoZSBlbmQgYmFzaWNhbGx5IGRpc2FibGVz
IGh1Z2UNCj4gPiBwYWdlcw0KPiA+IGZvciB0aG9zZSBURHMuDQo+IA0KPiBKdXN0IHdhbnQgdG8g
bWFrZSBzdXJlIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHk6DQo+IA0KPiBMaW51eCBURHMgYWx3YXlz
IEFDQ0VQVCBtZW1vcnkgZmlyc3QgYmVmb3JlIHRvdWNoaW5nIHRoYXQgbWVtb3J5LCB0aGVyZWZv
cmUNCj4gS1ZNDQo+IHNob3VsZCBhbHdheXMgYmUgYWJsZSB0byBnZXQgdGhlIGFjY2VwdCBsZXZl
bCBmb3IgTGludXggVERzLg0KPiANCj4gSW4gb3RoZXIgd29yZHMsIHJldHVybmluZyBQR19MRVZF
TF80SyBkb2Vzbid0IGltcGFjdCBlc3RhYmxpc2hpbmcgbGFyZ2UgcGFnZQ0KPiBtYXBwaW5nIGZv
ciBMaW51eCBURHMuDQo+IA0KPiBIb3dldmVyLCBvdGhlciBURHMgbWF5IGNob29zZSB0byB0b3Vj
aCBtZW1vcnkgZmlyc3QgdG8gcmVjZWl2ZSAjVkUgYW5kIHRoZW4NCj4gYWNjZXB0IHRoYXQgbWVt
b3J5LsKgIFJldHVybmluZyBQR19MRVZFTF8yTSBhbGxvd3MgdGhvc2UgVERzIHRvIHVzZSBsYXJn
ZSBwYWdlDQo+IG1hcHBpbmdzIGluIFNFUFQuwqAgT3RoZXJ3aXNlLCByZXR1cm5pbmcgUEdfTEVW
RUxfNEsgZXNzZW50aWFsbHkgZGlzYWJsZXMgbGFyZ2UNCj4gcGFnZSBmb3IgdGhlbSAoc2luY2Ug
d2UgZG9uJ3Qgc3VwcG9ydCBQUk9NT1RFIGZvciBub3c/KS4NCj4gDQo+IEJ1dCBpbiB0aGUgYWJv
dmUgdGV4dCB5b3UgbWVudGlvbmVkIHRoYXQsIGlmIGRvaW5nIHNvLCBiZWNhdXNlIHdlIGNob29z
ZSB0bw0KPiBpZ25vcmUgc3BsaXR0aW5nIHJlcXVlc3Qgb24gcmVhZCwgcmV0dXJuaW5nIDJNIGNv
dWxkIHJlc3VsdCBpbiAqZW5kbGVzcyogRVBUDQo+IHZpb2xhdGlvbi4NCj4gDQo+IFNvIHRvIG1l
IGl0IHNlZW1zIHlvdSBjaG9vc2UgYSBkZXNpZ24gdGhhdCBjb3VsZCBicmluZyBwZXJmb3JtYW5j
ZSBnYWluIGZvcg0KPiBjZXJ0YWluIG5vbi1MaW51eCBURHMgd2hlbiB0aGV5IGZvbGxvdyBhIGNl
cnRhaW4gYmVoYXZpb3VyIGJ1dCBvdGhlcndpc2UgY291bGQNCj4gcmVzdWx0IGluIGVuZGxlc3Mg
RVBUIHZpb2xhdGlvbiBpbiBLVk0uDQo+IA0KPiBJIGFtIG5vdCBzdXJlIGhvdyBpcyB0aGlzIE9L
P8KgIE9yIHByb2JhYmx5IEkgaGF2ZSBtaXN1bmRlcnN0YW5kaW5nPw0KDQpHb29kIHBvaW50LiBB
bmQgaWYgd2UganVzdCBwYXNzIDRrIGxldmVsIGlmIHRoZSBFUFQgdmlvbGF0aW9uIGRvZXNuJ3Qg
aGF2ZSB0aGUNCmFjY2VwdCBzaXplLCB0aGVuIGZvcmNlIHByZWZldGNoIHRvIDRrIHRvbywgbGlr
ZSB0aGlzIGRvZXMuIFRoZW4gd2hhdCBuZWVkcw0KZmF1bHQgcGF0aCBkZW1vdGlvbj8gR3Vlc3Qg
ZG91YmxlIGFjY2VwdCBidWdzPw0K

