Return-Path: <kvm+bounces-51665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE02BAFB272
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 13:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF3753B8612
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 11:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7BC29A308;
	Mon,  7 Jul 2025 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgiOpLyq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E216F2877D4;
	Mon,  7 Jul 2025 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751888439; cv=fail; b=XCL4tcmV2uKnquasdYYjY9Gwph2Phlh1XKcgkHqbsT+T+xpZyHhyzSfshiRGtx/1r0MrOd6EwKp65kDOm+NwfY2PuK7dj35mLIqs/IGI8NhDwE95m7JpfTgsodr6iIlBzdSyLtOIeTRJejhEF17yZLYlyC+4bpDpp1/6c0kFXmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751888439; c=relaxed/simple;
	bh=JC2xcbLqTaVQONOkWrVGYeu6nTC5eefflQ01pDRqHnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eUpLuBJFnoYJhlI6fPGPZ5tbbwErtwwpUuG3JFj5nMyXiwREaXSOJDoRJfI1cISdGsy8hoiHMQvN2DpzNus5mWBIVGdXxTWVbO2soQNPS7BSXNyrt7kScp4hbm50cjkVtCbbJYFemQmqShfZ9xqc9A3heRsNURYA3qRi2yhe9vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgiOpLyq; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751888438; x=1783424438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JC2xcbLqTaVQONOkWrVGYeu6nTC5eefflQ01pDRqHnY=;
  b=LgiOpLyqH6WrQ1/EZiy/rptwE0/b6Rhret4ZSIjjiE55ub1CfTKsT6d6
   9mTWgCfCWVdAqbmbZQX32VyQaCjN9QqswDIoK8Xs09aNX+PuMpkwcgop9
   ASqDwu2c5BzWvYmXN3ScClVKBF3BHEKjGg+zzmt8J1PO8oc5L90d8Q7uB
   Mg0L6V9g3zn2cI1LXXCRjtIEzgWTD3lYTsK9DMcwvlPqzkOJZoRs4RKpJ
   sn/56xNcbubCqXk354Wrf6087yZ0Cet0XxQATEhUCUi+ySsoXhoaIyTmG
   jXDW+02R3Jua67Bi21kbNPAx4/b6+yl5t+W4mPSGZ25y7czQv3U2nzN9g
   Q==;
X-CSE-ConnectionGUID: fpM4ZPteR/WtAfH1ejm++g==
X-CSE-MsgGUID: fenWQE+zReOKvo8IL8LQ8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="71541478"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="71541478"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 04:40:37 -0700
X-CSE-ConnectionGUID: XPADn42LTzmgNjtmy9d72g==
X-CSE-MsgGUID: 9RJYaQrST/+Hqcc3tp1feA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="159733438"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 04:40:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 04:40:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 04:40:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 04:40:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+SifEuWVHyKzLfi5GT3R6OfstHbysD+hpXTrJYiNaMf47ywUwDn3CQPHTsZnwXFMcjED4A3oX0bbBlj0qj3m5Fpx5HoeYJWkMXVPJkwT4cCLkDa9RHUhNZIlYzCa1reEE0fbT5mz/MofeSfOl/8XOrmOVevRQf7CyStqRvke6VMxC1DPBs3FZv5G08Jge8ks3MFkFUPZq97ovsXnb5Fc7mNiWEvletwkA5QAbcl4Fb3om9JdhY77WLdEEOAvEig2lFKqxHMNkDl0msyxgpsNMu0nCjldhtpFhpU0lSQDusZDg9sqWqAxzsToQBinSd8xZPyRXMS3Nr69EgvNC74Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JC2xcbLqTaVQONOkWrVGYeu6nTC5eefflQ01pDRqHnY=;
 b=q2IMafYAsA05qocukbyIozlZ6/F069rvkQVoHJIOE+9+d2oWWRZMpDfwttA5sLkDB95urI7ACebxOmWJoMoC4MmT/qryqbW1kWSLBcgwORv1L2FSAJo+rg7pY3iuCGsxNOq9EEEPb7r18Ax20hqGD5tMydg5VM7uKo4F3DkBxA9XP7SweuIr6NjkwNLxG4uDADVRzJn84ewS5QryHSLFXl8OO3jTkpq2eEQLvCr6JRAKyQBtI767MVPbIIKq5TvHcSDv/HnokLIOrRu7b+P2mzt3loHUBxacmTgqIx5Y2PE9dMtpk23aJ3XurGEf6PeV/cIhHMmfERnhj2mlxd6jtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS4PPF890B596B9.namprd11.prod.outlook.com (2603:10b6:f:fc02::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.18; Mon, 7 Jul
 2025 11:39:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 11:39:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Topic: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Index: AQHb7DBwzT38WlKsQ0GMFAXu/JzorrQmApoAgAASsICAADAIAIAASgMA
Date: Mon, 7 Jul 2025 11:39:57 +0000
Message-ID: <4d895fffeb0a2be121fceb4bb002302d1c2630e2.camel@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
	 <20250703153712.155600-3-adrian.hunter@intel.com>
	 <aGs7/C0W58nEUVNk@intel.com>
	 <ca275d32-c9fd-4f60-9cf4-cd88efc77d78@intel.com>
	 <aGtz9KfszwNKBrZb@intel.com>
In-Reply-To: <aGtz9KfszwNKBrZb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS4PPF890B596B9:EE_
x-ms-office365-filtering-correlation-id: 8ad7b653-4ba6-4e42-1744-08ddbd4affd2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cEwrZlRYYnd1Vi9zZVNpdEVla1pld0xEcmlGUjJTNXAzcTN2cW80TlQraUdk?=
 =?utf-8?B?SlYzNDQ5T1h3SUxHcytOQW9sM2E0SEpYY3VJSXJWYTZLSk1pQitNMFNJNW1l?=
 =?utf-8?B?ZnVISkxQQnZadzI1WWpDOW5vKzhWc296SG1LblZERUJYaVdqM1JTeE05ajdR?=
 =?utf-8?B?VURtcEdqdzJXRlJLQWlJWXlsRTZuU1BNY2pwTkhVOTNwT3hhZGc4bDhSQkpY?=
 =?utf-8?B?MURVbVAzTlNNSkc2ZFdwWVBKYXNvM0R5UlVveHJTRkpzRlp2d1VINlVGd0FF?=
 =?utf-8?B?bGJiWDBwQ2VqOTdNMnd0RERyeWhndzNxZEJadWwxRm12Rll6RENDT3RFT2Z2?=
 =?utf-8?B?V2kzdGZPazd6aTFDM05CMDF4TmtRbURTU3p3UVo3S3lQSmZoLzhLRm5mUmZM?=
 =?utf-8?B?VjhrSXNuYU9TcE9TelFCSzRZVng2RmRIdEU3eElYb1Y4MzNKellpYzFZSTZv?=
 =?utf-8?B?L3E2MkRUUGZCclRCMjNOODZYZGhuUE52ZWFxRDJVcVJEOUsySE90ZXFnZzkz?=
 =?utf-8?B?bHRIek9weDMwSWxYQ2FneGIrWXBNQVFSYjlBZklZWmZPZVRzOTd3UFcyUGRV?=
 =?utf-8?B?VTZscVdBU0krV09id2lTNStBWExjSDA2UUFzSWxWekpXUkNlWFNCWmRmTFE0?=
 =?utf-8?B?M1JZa1FDRlY1V1NDVmNHNHBrN2FIYnhZc1dSbk0xUzRjdk0va2FxTjk5MDM5?=
 =?utf-8?B?NGk4RHVSM3Q4WTlZcWdYVk5yS2lqMlpsMHdnV29WQ091QjY4VTFkWDc3WjJt?=
 =?utf-8?B?Tm5DajNBWTNGRmg3dlhqMmRud3oyQklpMlBHMHVyZyswc2E3QXlJQ3l6VnFR?=
 =?utf-8?B?bFc4ajdNcUd6OHlCL05nSjRTNnhoTTAxbnhCa00vL3dkaDR1U3ZCWm9CU2hQ?=
 =?utf-8?B?ZjM5N0NpS0FMM3cwSEdQR2VPVFVKTSsvQ3JDQkZzeTFtZXIvK2hLZmt0L1A1?=
 =?utf-8?B?ekZHTnJ6NGNsSjVkSk1JajRBZmIwdktNUGJKTUJJVWRmbXVOYVF0TlpSSTRX?=
 =?utf-8?B?OXdmay81blBVOXNmT0VkOFhQcU9uLzNlVUhLRWsrRDRqVmxscDk0RDJXM01U?=
 =?utf-8?B?VUIvM3l1T3RGVFVPYi8yaklQYU5GQ29nNTVjMG1NQjZFZVNYUDRqZFpLcHRs?=
 =?utf-8?B?T3NOMG83VGdrRDBDaGZxcHJjdjJOVlVPVm9WYjZRTjdBR2h5bDZLcHZRVWpR?=
 =?utf-8?B?bGcycVh6Ylg4MjFrdG9zQTlRbDJjL0NJclJMZ2J3cmMrcXRtcVNzYlE5N09h?=
 =?utf-8?B?dUF0Tmo1Yzl4YVYzTFdGSWIvTFA1SEJqQ0ZYRStld1JZR1VaM1hSWnp0ZW11?=
 =?utf-8?B?bmU1T1FTRnhrdUFFL0I5V0VwMzhoTVRjRzAzcmtpQWxld3cwaTBWT2JvQzVh?=
 =?utf-8?B?eTdzSnBBS1ozWFIvN3didk5EZFQyMkdWYWl2QkJPS25NdnIzclJySEJ1WEJ5?=
 =?utf-8?B?dElqQ3dYNG9FSElyUkd4SzJscW1aUzd0R1lWQ1p5L0NmdzEwSUdYYjFZNmVh?=
 =?utf-8?B?dTJQRHlJc0svWk1nMERqL3lDcHRJK3lvM1NWU3Z0ZFlhWis3MElDL2k5SXNi?=
 =?utf-8?B?blJhdWlHM1hzaUNtZHBIL2xXR05mN0tNWWJ0Nm9CaVFoMGJPajB0N1hCVk9z?=
 =?utf-8?B?NXdxT2JOa2cwNGg3NnREZDFxZVRXVDdxT2Q5bmttVE5xN0hQQW9nK0lZb3lR?=
 =?utf-8?B?ZDdhMStmMlVZb3JwaUlRUks1SlFJMUdnWlFEVlR2Vnp6WXgvRVZaMExPWm4z?=
 =?utf-8?B?VjlsTkYwZFdxMDNRcTlyMWpPdUVLamtkUEUybXFCZG5QVjE2WUYyVFVDcDRG?=
 =?utf-8?B?UGJMeHJ0WWhFU29DNnhYdTIyWXlDZG9hZmNjTjBOMjdUL0loYXl4cUdJVkNN?=
 =?utf-8?B?b0NVaXl6WHE4dXZ2Y1ZSNm1uaWxQdG11WU9IbFBRTXZqdUFTNE1lNFFhZWZs?=
 =?utf-8?B?eUszMHZOdEptQnYxT1VMRXZWSkdhUVpoN2lxWFJYSWtTQVUvR0FNMTJSL25C?=
 =?utf-8?Q?fljw8dbqKOWIN580jE43Bm3J2EOYHw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1pSMW5MbWcwWnJKWExPR0hPYnMwU1lmUHVXMjBPdkdNZk95VmVmWnNKVGxv?=
 =?utf-8?B?Zms2U2lqNlhxL3cxOGhYWWZmT3ZwTkNlT2h4dUpBOGZTdDhzS1huTVhhWklE?=
 =?utf-8?B?cHV6eWJiRXBGOENaRHZ0dGdoVWYxSStkaUYraFBGUWdVVGZwMzhUL0w4NHJl?=
 =?utf-8?B?QTBOcEMvYkIwNllFWWYrcW51blZNZGZXSEZxMGx5ZHdmb1ZjNDA0MXQ5dWdi?=
 =?utf-8?B?Q1BNTGs2eXZSYmg5d3grR3ZlaEV0dGF2cDdnd0VVaEdidFhRWTF0c3lqeGlz?=
 =?utf-8?B?ZXZXYVFmbnBjQ01UT3M4NGtDMFl0TldqN0pEb3YwVVZYSi9MNHBNTnNLeHlt?=
 =?utf-8?B?RzZ4OFNrekZCS0U1eFVsSGtITisyUDM2UVRoUWYvK0Z5cXhrUUZnMlVsWFM1?=
 =?utf-8?B?eGdQdlFQbzRVeTgxcGs1d1RoMEdjUWVkclNmREM5S3F5aUsxaVlMTDNiZkd2?=
 =?utf-8?B?L0EySDRJeHFtcmt2R1RZZ2VjSWZNREU3cGw4TzFwS21MMHVtVGdXUWM2UWRJ?=
 =?utf-8?B?Y2J6UUNEUG5ZdUFaSjVTc2d4NDhtcDU5Z3QyQWd5V2ZXNFdtdkpEanhtUGEz?=
 =?utf-8?B?ZlRqTWxzK3hKSkF4Wkl2Y3RuWEhxZmgvTnNGazk4MlZRMktNVitqbStBVWsz?=
 =?utf-8?B?TjBSRGdLaENMbTRKQks3cjdpL1lrTDBtVVdVY3EzWXJPTkJDbS9LdmlnMHA5?=
 =?utf-8?B?RkpqS0VEbnhUQ1pjc3pRVmxYbm9jSmllejdXWGNETUt5Vkh1RmlLOTVtREVM?=
 =?utf-8?B?dGUvMm4zdWZoQnBYTmMrcnlzVkgrSmFicFNVWjVBQmlFU1B6dVFsMTAvb24x?=
 =?utf-8?B?RGhUeVdPRFpra0tZa1RBS1lIejE2eTBVODRhRGZaamlxaFZWWTVvVU1DTEJL?=
 =?utf-8?B?TEFLQ0lBVGU2cTFWVjMrdGJWcVEwRFFhUElhOTh0b0dkbXlYYWQ2dVBnNXha?=
 =?utf-8?B?SURXL1NZNmF4TGZkaWUyY1hrSU5LRDMwaXE4R2pZWmZBUjMwbENhRUk3Q3Rr?=
 =?utf-8?B?VCtMMFo3MzlNZjEvY0V2QXJQOHdMekF3QzFlcjVSN0xyVFVpU0xPTlAzSCtU?=
 =?utf-8?B?OE1VcUJrSXVsR1podXN2eEQ5S0JadE5CTy92Ym1KNkZ6UlRLUmRNUndwQ3c1?=
 =?utf-8?B?eEhTM3JsNC9SQm4vNExGeUE4MEk0VWlkTTZpZHpNaFNNRlhucVRWMUQvTmFY?=
 =?utf-8?B?em9wM1dvTVczeUxRR1ZmajduWDJuRGRGeXRyZmJSb1JTejMydkFpY3R4aGRj?=
 =?utf-8?B?SVRkQ3FwendpZzVEYmF2TWQwS2hxVEFrTnhYUFlvVjE0a043c2tub3k2bzZi?=
 =?utf-8?B?Sjk3OWpYcEs0WmVlTVV0d2o3RWV2UzBtYXZrWGt1c0kxSUl0U09JcWlHcHZY?=
 =?utf-8?B?QTJxZCtZLzN4VkszS1JWZ1hlNWtac1R0OSswdVVmc2ppMjM2clhlNGxGN3k1?=
 =?utf-8?B?SXRaQUJ0aHJkeTF3UjVvSHlRUVhwd2RIN0hudmdXYkhhQU5iWDZDN3JHb053?=
 =?utf-8?B?MWJnd3g0ZWt4aHJrRzAvRVdibEo2b0FSNTFmTzRuZGJ5KzBFUm9oSEcrZnVK?=
 =?utf-8?B?dWd1WUVyMHVVbHNzWUhSU045NXZaUWcwcGJHZVJzMnBkVDlhNlEzSlBnekla?=
 =?utf-8?B?Ni9ONmZaYTdHbnhaM0ttaXZHU2ptb2dpdkNSdTF0cFFseExwek82SGxndjRW?=
 =?utf-8?B?c214ZDRWaE1ZME9FWUtRcHEvcEJ2WTB4aGIxWlEzajlRbzRhK2Q4WEJDNGVz?=
 =?utf-8?B?L3RMK3JIamxYdEozTVUxM0tQajlLZWMzRFkrTUZPQkk4SHZjbUs3ODRocGpV?=
 =?utf-8?B?emNkUEtML1AwREwrcUcrS0dkWHYzelFhcmw1QmNhRlQyR2FDMmUwYUkvTlh1?=
 =?utf-8?B?RUN1TkcyWDNlNlY1T1JuczkwRy9hK0M1RDRZQ3c2Vk1ISndkUVN1d3JmNnNE?=
 =?utf-8?B?Q2hlcjNQTUF5VDFRVE5vc3I3VnhIZlJ6QlFHTDhaMCtXT2lrSUE1YWs2dFJS?=
 =?utf-8?B?Sm5tdjNIMjJjSlpVOENyeFVVNTIvZUhXc0VOd2xVRlVOSzBnVmQ0eFZTeHAr?=
 =?utf-8?B?b29ZQlRpV0tFSUZyT3lSRkxIV0hldEVoZjlVNXBld2M1UTZEZWZNUFUrelhI?=
 =?utf-8?Q?MOm8OZ9mwJGYO9eaVnbkAjX9q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3F4E7875D92E94FAD2ADF33FCD708B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad7b653-4ba6-4e42-1744-08ddbd4affd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 11:39:57.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jr6wIyw3G4Hz0waxq8oOq+yB9i9X6fXDbKH0sqjc2tHQKsPnZMndmY+sgGyBmt9gcUFxMWFLOlAz7d+n1M5k/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF890B596B9
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTA3IGF0IDE1OjE1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
U3VuLCBKdWwgMDYsIDIwMjUgYXQgMDk6MjM6MDVQTSAtMDcwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6
DQo+ID4gT24gNy82LzI1IDIwOjE2LCBDaGFvIEdhbyB3cm90ZToNCj4gPiA+IEV2ZW4gb24gYSBD
UFUgdy8gU0VBTV9OUiBhbmQgdy9vIFg4Nl9CVUdfVERYX1BXX01DRSwgaXMgdGhlcmUgc3RpbGwg
YSByaXNrIG9mDQo+ID4gPiBwb2lzb25lZCBtZW1vcnkgYmVpbmcgcmV0dXJuZWQgdG8gdGhlIGhv
c3Qga2VybmVsPyBTaW5jZSBvbmx5IHBvaXNvbg0KPiA+ID4gY29uc3VtcHRpb24gY2F1c2VzICNN
Q0UsIGlmIGEgcG9pc29uZWQgcGFnZSBpcyBuZXZlciBjb25zdW1lZCBpbiBTRUFNIG5vbi1yb290
DQo+ID4gPiBtb2RlLCB0aGVyZSB3aWxsIGJlIG5vICNNQ0UsIGFuZCB0aGUgbWVudGlvbmVkIGNv
bW1pdCB3b24ndCBtYXJrIHRoZSBwYWdlIGFzDQo+ID4gPiBwb2lzb25lZC4NCj4gPiA+IA0KPiA+
ID4gQSByZWNsYWltZWQgcG9pc29uZWQgcGFnZSBjb3VsZCBiZSByZXVzZWQgYW5kIHBvdGVudGlh
bGx5IGNhdXNlIGEga2VybmVsIHBhbmljLg0KPiA+ID4gV2hpbGUgV0JJTlZEIGNvdWxkIGhlbHAs
IHdlIGJlbGlldmUgaXQncyBub3Qgd29ydGggaXQgYXMgaXQgd2lsbCBzbG93IGRvd24gdGhlDQo+
ID4gPiB2YXN0IG1ham9yaXR5IG9mIGNhc2VzLiBJcyBteSB1bmRlcnN0YW5kaW5nIGNvcnJlY3Q/
DQo+ID4gDQo+ID4gSG93IGlzIHRoaXMgYW55IGRpZmZlcmVudCBmcm9tIGFueSBvdGhlciBraW5k
IG9mIGhhcmR3YXJlIHBvaXNvbj8NCj4gDQo+IEkgd2Fzbid0IGFyZ3VpbmcgdGhhdCBNT1ZESVI2
NEIgc2hvdWxkIGJlIGtlcHQuIEkgd2FzIGhpZ2hsaWdodGluZyB0aGUgcmlzayBvZg0KPiBrZXJu
ZWwgcGFuaWMgb24gQ1BVcyBldmVuIHdpdGhvdXQgdGhlIHBhcnRpYWwgd3JpdGUgYnVnIGFuZCBn
dWVzc2luZyB3aHkgaXQgd2FzDQo+IG5vdCB3b3J0aCBmaXhpbmcuDQo+IA0KPiBSZWdhcmRpbmcg
eW91ciBxdWVzdGlvbiwgdGhlIHBvaXNvbiBsaWtlbHkgb2NjdXJzIGR1ZSB0byBzb2Z0d2FyZSBi
dWdzIHJhdGhlcg0KPiB0aGFuIGhhcmR3YXJlIGlzc3Vlcy4gQW5kLCBhcyBzdGF0ZWQgaW4gdGhl
IGNvbW1lbnQgcmVtb3ZlZCBpbiBwYXRjaCAxLCB1bmxpa2UNCj4gb3RoZXIgaGFyZHdhcmUgcG9p
c29uLCB0aGlzIHBvaXNvbiBjYW4gYmUgY2xlYXJlZCB1c2luZyBNT1ZESVI2NEIuDQo+IA0KPiA+
IA0KPiA+IFdoeSBzaG91bGQgdGhpcyBzcGVjaWZpYyBraW5kIG9mIGZyZWVpbmcgKFREWCBwcml2
YXRlIG1lbW9yeSBiZWluZyBmcmVlZA0KPiA+IGJhY2sgdG8gdGhlIGhvc3QpIG9wZXJhdGlvbiBi
ZSBkaWZmZXJlbnQgZnJvbSBhbnkgb3RoZXIga2luZCBvZiBmcmVlPw0KPiANCj4gVG8gbGltaXQg
dGhlIGltcGFjdCBvZiBzb2Z0d2FyZSBidWdzIChlLmcuLCBURFggbW9kdWxlIGJ1Z3MpIHRvIFRE
WCBndWVzdHMNCj4gcmF0aGVyIHRoYW4gYWZmZWN0aW5nIHRoZSBlbnRpcmUga2VybmVsLiBEZWJ1
Z2dpbmcgYSBURFggbW9kdWxlIGJ1ZyB0aGF0DQo+IHJlc3VsdHMgaW4gYSAjTUNFIGluIGEgcmFu
ZG9tIGhvc3QgY29udGV4dCBjYW4gYmUgcXVpdGUgZnJ1c3RyYXRpbmcsIHJpZ2h0Pw0KPiBCdXQs
IG9uIHRoZSBvdGhlciBoYW5kLCBNT1ZESVI2NEIgaW5jdXJzIGEgNDAlIHNsb3dkb3duIHdoZW4g
c2h1dHRpbmcgZG93biBhDQo+IFRELiBTbywgSXQncyBhIHRyYWRlb2ZmIGJldHdlZW4gY29udGFp
bmluZyB0aGVvcmV0aWNhbCBzb2Z0d2FyZSBidWdzIGFuZA0KPiBleHBlcmllbmNpbmcgYSA0MCUg
c2xvd2Rvd24uDQo+IA0KPiBQZXJzb25hbGx5LCBJIGFsc28gcHJlZmVyIHRvIHJlbW92ZSBNT1ZE
SVI2NEIsIGJ1dCBJIGFsc28gd2FudCB0byBwb2ludCBvdXQgdGhlDQo+IGJ1ZyB0cmlhZ2UgaXNz
dWUgYW5kIHRoZSByaXNrIG9mIGtlcm5lbCBwYW5pYyBhZnRlciByZW1vdmluZyBNT1ZESVI2NEIu
DQoNCklmIHdlIGFyZSBvbmx5IHRhbGtpbmcgYWJvdXQgdGhlIHBvaXNvbiBkdWUgdG8gVEQtbWlz
bWF0Y2ggb3IgaW50ZWdyaXR5DQpmYWlsdXJlLCBwZXIgVERYIHNwZWMgdGhlIENQVSBvbmx5IG1h
cmtzIHRoZSBtZW1vcnkgYXMgcG9pc29uZWQgd2hlbiB0aGUgQ1BVDQphY3R1YWxseSAocGVyZm9y
bXMgcmVhZCBhbmQpIGNvbnN1bWVzIHRoZSBiYWQgZGF0YSBpbiBTRUFNIG5vbi1yb290IG1vZGUs
IGluDQp3aGljaCBjYXNlIHRoZXJlIHdpbGwgYmUgYSBzdWJzZXF1ZW50ICNNQ0UgZnJvbSBTRUFN
IG5vbi1yb290IG1vZGUuDQoNCkEgVERYIG1vZHVsZSBidWcgd2hpY2ggY2F1c2VzIHRoZSBtb2R1
bGUgaXRzZWxmIGFjY2lkZW50YWxseSB3cml0ZXMgVERYDQpwcml2YXRlIG1lbW9yeSB1c2luZyBk
aWZmZXJlbnQgS2V5SUQgd29uJ3QgbWFyayB0aGUgbWVtb3J5IGFzIHBvaXNvbmVkLiDCoEENCmZ1
cnRoZXIgcmVhZCAoZHVlIHRvIGJ1ZykgZnJvbSBob3N0IGtlcm5lbCB1c2luZyBLZXlJRCAwIHdv
bid0IHBvaXNvbiB0aGUNCm1lbW9yeSBlaXRoZXIuDQoNCkEgVERYIG1vZHVsZSBidWcgd2hpY2gg
Y2F1c2VzIHRoZSBtb2R1bGUgaXRzZWxmIGFjY2lkZW50YWxseSByZWFkcyBURFgNCnByaXZhdGUg
bWVtb3J5IHVzaW5nIGRpZmZlcmVudCBLZXlJRCBwb2lzb25zIHRoYXQgbWVtb3J5IGFuZCBjYXVz
ZXMgI01DRQ0KaW1tZWRpYXRlbHkgaW4gU0VBTSwgYnV0IHRoaXMgaXMgZmF0YWwgdG8gdGhlIHN5
c3RlbSwgc28gbm8gcG9pc29uZWQgbWVtb3J5DQp3aWxsIGJlIHJldHVybmVkIHRvIHRoZSBrZXJu
ZWwuDQoNCkluIG90aGVyIHdvcmRzLCBJIHRoaW5rIGl0IHNob3VsZG4ndCBiZSBwb3NzaWJsZSB0
aGF0IGEgcG9pc29uZWQgcGFnZSBpcw0KbmV2ZXIgY29uc3VtZWQgaW4gU0VBTSBub24tcm9vdCBi
dXQgbGF0ZXIgcmV0dXJuZWQgdG8gdGhlIGhvc3Qga2VybmVsLg0K

