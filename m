Return-Path: <kvm+bounces-15738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0078AFD36
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DACD1C22015
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DE6538A;
	Wed, 24 Apr 2024 00:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxS7NF/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53BE800;
	Wed, 24 Apr 2024 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713917492; cv=fail; b=EYnQtPwwJW8DUn+HmXIgUPIqRKd2rZUfqB+HxgTK255+W0AsJk+CtAbwGmaiu4Df7fKYM/iyT3IvIrr7jQ/uEafZBUmSgcROcRIn+Ptk7MW9UzDFJizDVmyaA8NjU5ex8U1vnNMPcV74jTC3DhVq9VyUL3JOylefYoESWxHBtHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713917492; c=relaxed/simple;
	bh=8S2NF5nqMAvfx3JvWGcz28UcyVkINuCIfLSSIXaq1M4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pMgqciUkiTK2e7+XgUUsIHd6HoQlUzumSs/MaAPndtINK7uFmIG+s9fhoBqd++ZrpaiVxHWCSK1jXBjpaWlvyOhO3nUzfQtKqN1bUbLamn2KbMG8CQTBjIvu6SR138WxmMj/6OaOOQ32kz0PIZGmGPJ5s+pWwtwePpignYc01Ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxS7NF/1; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713917491; x=1745453491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8S2NF5nqMAvfx3JvWGcz28UcyVkINuCIfLSSIXaq1M4=;
  b=MxS7NF/1jx3RZ7oAQEvDzNH3eur8EtNXoIF8JsuD493nF9H66C5bHSb1
   ImqMx+BO0DpOf73ycxqgYFIsfYV5QcoK7sihpxnhrbe5C36aLaoS7JlwG
   v5HuF1+Z78fjGjiExgisw0j3BVhd0YIFmYl6s/mfGKx4irJ812cJBqTNh
   nSwVDFVyjqgNKdJ2OnlUsOrv6/2ncdcW53K+YifbtjLLzxmHIXuWTDB1Z
   sKrDBHfjCDRQ7od+6JM/72gQGFeEbVaBE/Mb+29zYApc8+GOZ0zINJCmQ
   aLz010ovXYfnIuIwSOoneWiJQNF/yFPSIt5B38wwXnr86nSiq432gM0ZZ
   w==;
X-CSE-ConnectionGUID: AgHudYYYTJ2RVT4+H9FPTw==
X-CSE-MsgGUID: U2CR20w1RsesUdgxQmZdbg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9453566"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9453566"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 17:11:31 -0700
X-CSE-ConnectionGUID: g718iNLmT7SfEVbwOCyLrA==
X-CSE-MsgGUID: 31b3x+/1Tzm3bftpGIBIkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24578798"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 17:11:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 17:11:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 17:11:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 17:11:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 17:11:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ED/4Y9FFw1As7x1zzenFMQNV4HRaeLnapdeC6iFShSv05JRmpcoWcBONl84DRB1W0jOHFTd0BzajmqxT1KQyC23Jmd/ENvrDjHuCVdZzMVMLEehsq77FxmPyig3OpXiLHMFESJPQi7LcZyTEj8gq26kmQtJE6sMLRz7QKg4s4ozDkDI+acJNuxC2wsidnQ4p5MR/gEuOK/0XFXAXRAqnwdg5w3mWc1XL8YZgbydxRWRCrgvLWxig/42bMRr3rUluRTiff8mtuwciUqQeOOsL3Jfnt+lfh7kTAmLjg34nYYMcnThf65u9/FXC27HXNt+aLAIxZdwxFtSRV0RfiWLkUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8S2NF5nqMAvfx3JvWGcz28UcyVkINuCIfLSSIXaq1M4=;
 b=PVCOiYz6yONv4C27WnXups0j9SFyBsc1Hw2q2YfEbUzPCZRsQxZ3200WUSDzY8RT7xBYVQ95BSXyAzBmrSO+No5eQxE5rc3MZ9iqOwLgsKTw9B7yzBnctaavAujoEdJ6RfeGwblLy7moE0eroZe5TORwYA+saQ3eyB7PjTDWrIRGTKDxWxfokJiHFJtKJhf8aAfI0kqBlp0aYx0VCErdwUfMHGBAFuM1+H84F6fHylX+LzBc/XT1c34n658m0LHrOxYBTld+TPvhdEgTGC4+Lat8ZtZKq0fJSewu1pZMkaH/juIuJLZOj2KN47EdJXXhrquCwqNTx8f7YH0sAOjChg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6494.namprd11.prod.outlook.com (2603:10b6:8:c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 00:11:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 00:11:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yao,
 Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Topic: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Index: AQHaaI26FrHcdX+u0kqmKjY/lD3kJ7F25saA
Date: Wed, 24 Apr 2024 00:11:25 +0000
Message-ID: <434f5ea4807cdfbe59ec8cbe078ba9c87933e5e7.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6494:EE_
x-ms-office365-filtering-correlation-id: 1fa9e06d-c7cc-447a-cd8c-08dc63f314f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?a2NIbmF6bytwTkZ5Z2Y4cjdOMnhBcG55UEtoUVBtTXlwWUxyMWV2QmtmN21s?=
 =?utf-8?B?Y3pwUXdycGNmSk4rRENxQkdQb1BYNlZWMTZzVXRhWVd4eFZtR3RRV0o5MExM?=
 =?utf-8?B?ZzR6dFFCcjVKbEpSZDN5dG8xajZMbnNyVFZOeHFrbDBRTVorOFJOOXErbnhl?=
 =?utf-8?B?OG1vWXdlOUcxSjc4ZWVCNmFTUXVkQzlXdzNMVDR1eEtNZlpFZFhaTk9PanFX?=
 =?utf-8?B?V3dRazluWGdkcnJMRkpmc0duUnZaZUtNY0lpYmMwY1BZSGs3b3NDaXVLc3NZ?=
 =?utf-8?B?Y2ZiRHBzU3ZoVWdmQit4MVd1b3FVcnVncDFsVlFab1hpWkQwZ3FyZFQ0Sjdk?=
 =?utf-8?B?RWo4MW5oa0N0bHRkZzRkVVA1UDc5OU9OTTlXNE1maWMzMTBnM1M4SXR6YzRa?=
 =?utf-8?B?R1VidTR6V1BWTU14R0J3YmVPL3NVdVdXdm0xS3EzODF0NWhhMmF2M2kzL01I?=
 =?utf-8?B?MWUyNEtVTUs0eGtXdTJycnRaSTV6eldDSE80R1NXdXkxRjN1eDgySmRCbWhn?=
 =?utf-8?B?YmJVSVdVMldPZGtoOEZKVnlsSGxFTGtXL1U2eS90eXhXTGl3Zlp1eVV5VUV2?=
 =?utf-8?B?cXFiZDh1cWJMUUJ4R2lsQTEyRnpKakRiUjF4eXZmQUFNdWtQSUhsaXdDM0ND?=
 =?utf-8?B?Rk4zakorRW5sRFh2SEVMQm9pazdoL2VlNEFOdlpBOHEzQ0swNzlBeW1pd2E4?=
 =?utf-8?B?eGF1NCtMWUQ4bGU5RFRzN1laTWVZcGttK1dsZ2ZMRGs3c2tZL1VmRXBCcVFN?=
 =?utf-8?B?eW5nRTJITWlCZGNjWmYweVlrVytpbFBCZ2FFOHBnS2huVlJRQ2xMdWFTNUU0?=
 =?utf-8?B?MDhhZ1AxdG8zZGduVTBjVFpDZjRBdlEvc1JKWVR0c0RCcUpwZ1ozbUFHajV3?=
 =?utf-8?B?WHlCdGNDa2JPL1o3WUhpdWpuSHlKSmgwMFJDMHpLajlEYmtwQi9MVFovSGNG?=
 =?utf-8?B?VmxYZzY0akNERjYvUW1UcjZoVmRKSmFGMGFGbHhaaDRRaytjbFZrbFdaaEpL?=
 =?utf-8?B?VThOQ3BIYzFlckQxTHQ4WEhDZTVqandINkp6eEV4Q0lkMy9QRitUdUJTSmVy?=
 =?utf-8?B?ZG1TZklmTUJ2TFMybGs2MWxXcXAvY2hvbEhzYjRRME0yb0VBVmx1SHN2dGZP?=
 =?utf-8?B?alpjbm43L3BDOHI4dkd3Rjc3VzlaK1JIVHY2U3pBdStFcHoyZEcxaHNnZTQr?=
 =?utf-8?B?VTFkWjBTT1RHVTExWW5ReHYrd3dNcUxFL2ZmVUE0S0R2a2djT0NrWktWeHo1?=
 =?utf-8?B?U2tacXdVR2ZIUzIxNHJIWFQ5MHl4UjFOMkJmaDBGSVFLWXBpWGp0M21CS2Rh?=
 =?utf-8?B?OVV0OU9FZmxtNzVLSy9Ta1NLeklvWHNZZll5Sk1kUEx4R0tyYm82cWdUb0dI?=
 =?utf-8?B?YmE3L3N3cXdubnhjRzU3NzRxb1kySTBTV1RpMXN2OU5yelBES01YN2JVbnBP?=
 =?utf-8?B?ekRwM2pLampqQ0diNnUxK29VUXV3cWJGdHRlY1dIWThkYjlINjFld0h1Ukx0?=
 =?utf-8?B?T2cxZjdYcDBtMDJJdFBTaXNKblI0cHhad29MeHg5dVhiY0dmdFZJM01hTnBE?=
 =?utf-8?B?OFJGaGFxUlYvRHFPOFc0cXpYT0V6WnU0NFpjZlNZT1hiRlhCSGdEanpTT0xk?=
 =?utf-8?B?SmRBUHF5Rjl0QWk3RlFzN3ZqT1hyRDd2ZERZdUdaQVgxRjE0S0EyMWg0a1Rp?=
 =?utf-8?B?MGtPVnlSUXlidHdYcVh3RVJldzBTcUVLbjg5NGZhbWNpTlk3OE1YV3hRYyta?=
 =?utf-8?B?TVU1cXdGdXZyK0JDK29lbllQUWVwa1N0WVlabjJsMUpGM3czazRpM09qVmpu?=
 =?utf-8?B?K0grL1I1OW9CaSs4S1VCQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGd2SGhKZ0dlUzV3Tkt1R2RUR2RiVjNzS1ZmUHp5ZFVIdHcwalcyN2ZQR09W?=
 =?utf-8?B?cVlYNEE2MWdoTE95R3dabjdySkp6SGs0U1dUT2c5aFJOWUZzcG9Wc1Q4aFhO?=
 =?utf-8?B?SXI0eHBOMm9YUWt2ODg5SmxaaExoVTNyTUZPYk1RSFpOSStXVDA5L09HT3Zz?=
 =?utf-8?B?RXNoMUdobWFURSs1NXFhUmtXM1AxTGNaeExCZFRobFdicC9OMWt3dVNhK2NK?=
 =?utf-8?B?Nk9sL0JKb2lNdnpsdG1OcDF1MHZJOTQ4UzlEQktKakVKbnB6Rjl3Q2dlaldF?=
 =?utf-8?B?NlhjTFhhL0xFMUFFbHREUXdiQ3E3ajlwRmdlaWhWb1pkOERnYU5IdVg5bGVX?=
 =?utf-8?B?ekRMRC9yLzBvNCtGNmYraEN0c3RlV0hkVlVzclF3bHE4ekR3QlpwSllUaGll?=
 =?utf-8?B?Z01pUXk1ZnFydThOd1QrL216YnMxdW92N1VRYkFsdngrVDEzMWVudjFWeEd3?=
 =?utf-8?B?alY2aWxXdHlXNW1Cd3FNdmovUktmSmt4QlIyclZZODJrbng4alZ3ZmpvNDdP?=
 =?utf-8?B?M3dSTUx0cm5PVjhvZ0dxZytjLzVwSUFTbGZWQzl4S3hxSjVSQzhwbGRmRXcy?=
 =?utf-8?B?YlozVmJBZGQ2aFNWeTVOZWRRY1ZRVG5MQm9ybFVmQ1FXQnhXdlBYR2dJTmg4?=
 =?utf-8?B?TUFnc3V1TzNPQ1lGWHhzTHYxUUVWY0hNSFVZbk9rMzhSU0IxbzNUdHAvdlZF?=
 =?utf-8?B?K2ptajVvd1F0bnlGSXpoM0o2QkppcU5kN0kxOGpVYXFFbk9VeFp2QVdIeVRX?=
 =?utf-8?B?amRLK0hpNHhkT2hRNm91Q3A2VkhNV3VpZGVTaHpOeHI2MWI4aU10NVBaTnRI?=
 =?utf-8?B?ZHBySE5aWWFFeitCMU9uVWFTOW5kWVpsTndHRGR6SUQrcmprbmdEWmxBZFpp?=
 =?utf-8?B?cTRleUkrSzB2YUI5LzJtQTJicWpqU0VDMDZkWmgvM1dWYi8vaFlyWWdGSk54?=
 =?utf-8?B?bTRqVlVRdlgwbEtKL2F6ejZ3a2hwTUpRQzRQYnVXOU5DTGVPNlMwckY2TEx2?=
 =?utf-8?B?aVNVMGV3akxTSElueXhyOHVnRE9jSTc3eHdWVDRhWHQ4bW9YRzFaZlpwWVJI?=
 =?utf-8?B?TDVDdU44REQxbG1MY1JMOUVmY29zOWNndHVKTkpNMnJvZ0U4Y2Y2cFFpbGFs?=
 =?utf-8?B?eG9mSHNSVUQ0cnVITXl5SWFqSDRrOWdjTTZ6YkRGSjVuSDFuQW8ySGFuTXJM?=
 =?utf-8?B?TkQwQ3BXVUFYakRQcEFlNE95ZFlVWnRNQXhSenZCOHJtd1lHbFFBNU5TeUhH?=
 =?utf-8?B?UUJENXR5V0owajR3NnJBNFIxMjFDSTQ4cDkvWHRNT1NleW9CTllJRkVjQ2c4?=
 =?utf-8?B?N2lyaFhuKzlpU0VIWXZwWDVjc3NBWExzVy8yUnloNEVhRjZKaEVHSEdiV2Fh?=
 =?utf-8?B?WEpWVm4zbmt2SlRVQThzY3V5SVh0NVk3d0hiMTB6VFJMNDI1RmZNeUFyZjZa?=
 =?utf-8?B?eldjVzBrVElmMCtJVXlGSFJZUkZTWGJha1Y5d1YrcHdzSXlsMEd1UUd6MkdR?=
 =?utf-8?B?bElJeUpzdHFRZ3ordUJ4b01oVElCczZJT3Z6UUpxc3JjQTJZdjJkUEllQUNu?=
 =?utf-8?B?cnJXaE1xcWlBVlBsQk5HK2FWNWdIQW5EWDkxaDh2NGptcCttbnBlclZBTzRI?=
 =?utf-8?B?VGpRMGZ3MndaanM2ZDRwVmxndUF2cThZOVFGY0NLaFo5YzdvMnhzdFBsZFdJ?=
 =?utf-8?B?dU5RNnZTS3ZYWm1yN1BNYlBPMUpKTTVLWHVWcVFCQk5SdXgyNlFvSkNMazZq?=
 =?utf-8?B?bGMwVDc0UzdwMzNnTCtMK2dOdEFBNTh0RUR2MnNjS2s4YmJFbk15TGt0N05F?=
 =?utf-8?B?S1JnTWhkUGJPcjlNZjdJNk03ZFNzeVdrSUNVUUJWbkVmbUdRbW1xeHZYQTNo?=
 =?utf-8?B?NGg5c0ladmt1WE5ySHduQVFvaW5JZFd4di9vZ0pLV2ROb2VSQjljc2pZNnBS?=
 =?utf-8?B?N1NNbzBtdDV2K2d6ZzQ4SGJpY1UxQjVjOFNvQzMwenp1dmtyYmhIZzBmKzFL?=
 =?utf-8?B?V1BFV0VqN3lseFRDVThQMWtBQzFVQ2ZLMDdZQ3Ryb2Fpb2dLRGtDa0FUbU5u?=
 =?utf-8?B?VW9BSkRNY1ZEYzNZb2tBSTkrdTNOZ1RpNGhiNi9wOURkMW9rMW53c2NJZ0pL?=
 =?utf-8?B?dmhDQ1ZiZGFqSWpXSC9Ham52RjJBNnZyMkpUSEs1TFhDdkFwajRsV0dvT2l3?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A89E56AB43F8934A86DE0410F119FAD1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa9e06d-c7cc-447a-cd8c-08dc63f314f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 00:11:25.9114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xIGOjCwc6UXBe4dWsookWxlrq0+LUgqIt73UByYwzPWRSdDsM3SXABb5ACqm0XnqDoW31mZAMxwaNiznkUZkpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6494
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4X29wcy5oDQo+ICsrKyBiL2Fy
Y2gveDg2L2t2bS92bXgvdGR4X29wcy5oDQo+IEBAIC00MCw2ICs0MCwxMCBAQCBzdGF0aWMgaW5s
aW5lIHU2NCB0ZHhfc2VhbWNhbGwodTY0IG9wLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICppbiwN
Cj4gwqAJcmV0dXJuIHJldDsNCj4gwqB9DQo+IMKgDQo+ICsjaWZkZWYgQ09ORklHX0lOVEVMX1RE
WF9IT1NUDQo+ICt2b2lkIHByX3RkeF9lcnJvcih1NjQgb3AsIHU2NCBlcnJvcl9jb2RlLCBjb25z
dCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICpvdXQpOw0KPiArI2VuZGlmDQo+ICsNCg0KV2h5IHRo
aXMgbmVlZHMgdG8gYmUgaW5zaWRlIHRoZSBDT05GSUdfSU5URUxfVERYX0hPU1Qgd2hpbGUgb3Ro
ZXINCnRkaF94eHgoKSBkb24ndD8NCg0KSSBzdXBwb3NlIGFsbCB0ZGhfeHh4KCkgdG9nZXRoZXIg
d2l0aCB0aGlzIHByX3RkeF9lcnJvcigpIHNob3VsZCBvbmx5IGJlDQpjYWxsZWQgdGR4LmMsIHdo
aWNoIGlzIG9ubHkgYnVpbHQgd2hlbiBDT05GSUdfSU5URUxfVERYX0hPU1QgaXMgdHJ1ZT8NCg0K
SW4gZmFjdCwgdGR4X3NlYW1jYWxsKCkgZGlyZWN0bHkgY2FsbHMgc2VhbWNhbGwoKSBhbmQgc2Vh
bWNhbGxfcmV0KCksDQp3aGljaCBhcmUgb25seSBwcmVzZW50IHdoZW4gQ09ORklHX0lOVEVMX1RE
WF9IT1NUIGlzIG9uLg0KDQpTbyB0aGluZ3MgYXJlIHJlYWxseSBjb25mdXNlZCBoZXJlLiAgSSBk
byBiZWxpZXZlIHdlIHNob3VsZCBqdXN0IHJlbW92ZQ0KdGhpcyBDT05GSUdfSU5URUxfVERYX0hP
U1QgYXJvdW5kIHByX3RkeF9lcnJvcigpIHNvIGFsbCBmdW5jdGlvbnMgaW4NCiJ0ZHhfb3BzLmgi
IHNob3VsZCBvbmx5IGJlIHVzZWQgaW4gdGR4LmMuDQo=

