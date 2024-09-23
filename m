Return-Path: <kvm+bounces-27284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F330197E5A3
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 07:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74D6D1F21691
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 05:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B5516426;
	Mon, 23 Sep 2024 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNMDKpRO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EC428EB;
	Mon, 23 Sep 2024 05:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727069761; cv=fail; b=ci9GkAePvE8cAoWU456qX6iO5zRDomK1Q0H6pg2eL+ClFJrbnq14cbl6VgoF5PIrPGa+d3vx1pYA+VnVV/tkwg/+bOnnEg31d2EKXR3mgaur0aGKTdvrY1njITcaO621CJwlQyDqVWTUzEB5ihud9KjjOzgvPMWH98lqbjvOwH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727069761; c=relaxed/simple;
	bh=Mbb4ZjlQE6MMm/i40I21AJ1yWWA0IY2TJgjzRKrZbyE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YAsw1q+ePQWmIzJgB4Ha7wXVrGb7MSUN1N8J3al4taLrJnzN/q1Ap8zoNQbS3MyYeD/1V1+wXz/TciVENIxcswvw+ZDxoGfrgHtkGnT6z5r73w0unnm0TkLAPJ6ij4AS7aMSa7wTIXTDnp1JnEIKSRtUcC/zj2U4hKEPfAGuxmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hNMDKpRO; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727069759; x=1758605759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mbb4ZjlQE6MMm/i40I21AJ1yWWA0IY2TJgjzRKrZbyE=;
  b=hNMDKpROQiKFMkVxF87vsUEGUfCzfQh5yLNf4DpKUap+ypp8Ag/DP8if
   Gb9s+vOL7+bff3EYG89RBuURjEN7g18D6yZM4ZZCLSHdb8Byej772SV1t
   iTHeRvnNTfJxHV9/NGnQf3uwjNpEnl2PDrlWElJXHyUF0EZbHExgakOrS
   jtmDb/B+eyzJvWQX4lDPnq95OUoE0jiUfvk634aM5g/WTKD+5Whx23OVC
   GqIRBxvdhQlP4pBRTsnaFleDOhuGI82//5VuZyUQzIxIgjWZpDwC9ZTIa
   dYWOS5EYh2QseT5K+8DT7T2yTQkFBJG3jAFwHhDe3R8CPK+fwowfRdlJB
   Q==;
X-CSE-ConnectionGUID: lj2KyeW0TvOUBrEZdPySrg==
X-CSE-MsgGUID: +XVlFd8WTOap9b4LznNhMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="26191858"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="26191858"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2024 22:35:59 -0700
X-CSE-ConnectionGUID: BVCQ1DWzTpKnUiBXX9iCWg==
X-CSE-MsgGUID: wQrv85tbQw+UKxV8qNlI7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="71230830"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2024 22:35:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 22:35:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 22:35:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 22 Sep 2024 22:35:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 22 Sep 2024 22:35:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDgqfCFnbRc+maiomJmhJzFJWVNOVN3E7bzk5rdsCGoxbkBDkTnv0lmNCiF4ks4mdGvcgJ0Br2EoLQCi4IE6d6aHP+M66q00VqQwcDLG+9vdh2nOgO2eV5IH/37ju2Ff8NCF8GnJ5ApUUlE9HHssEl0b/xjBoFpET2szCcNX031crYXLJg5r4DR7e3kO8HVIPd4vUlfBkL3LHZ7ld6k1fc6pAiTsRfB4lS2ygYNLCQDKxukPUVjPDGITLly8jWzIx53ip8kChn5lfLlr7siOPOMsBtDdMR8msScA9lK0jVhFq7vrvn3/3XKYbwI9CGgHIkT1iXsNiNJEqdRosb68jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mbb4ZjlQE6MMm/i40I21AJ1yWWA0IY2TJgjzRKrZbyE=;
 b=XZm13WxiOlNYd7lzN68rmS+9Bq2/ws1JiVO81FSvUGuwCSaLdkhcUSplSIj9usx2EDhh0L7n1B1K8UWw7zFOuQGs2f1dIc28yoMMzeC+C6Js1xQRN3DXcPYSAKQQWzGJTM5fEI7VcYV61Lkp3oEMCx8XpzVQC0b4GJwAU2Qku3qFauViDoVHEvgxM/iEAu9YlpkxsfqmUhMPkxtUhLFkPA0iUZbLpI/X2SuvDTWfIOJOrKK7aaUB0XO6HQny+nM3sOlVSbhYABmUwwvsg3BEWQhgAtMx5ldOuX0lG3yS2dCon6ZWhEmjarpXk/vSTSg8shQCZ/s22CII0gy1372yhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV2PR11MB6000.namprd11.prod.outlook.com (2603:10b6:408:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 05:35:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 05:35:55 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bJZe9sAgAfcbgCAA67AEA==
Date: Mon, 23 Sep 2024 05:35:54 +0000
Message-ID: <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com> <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
In-Reply-To: <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV2PR11MB6000:EE_
x-ms-office365-filtering-correlation-id: a7c1c2c3-ef74-46ed-a24c-08dcdb919837
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MzcwVGVWSm9aQjlsaGtnNGJhTlU4QUUzSU5hYUdBbVFCTTNsQWsrbWMrbjh4?=
 =?utf-8?B?VUFpeDFLb1FxTGdpNTRIWXFnYVNCVG5lYkZJTjkyQU9OT2tpbXlYNE1aYnIv?=
 =?utf-8?B?dE5uTDd4RnRrS0NPOEJqRXgydW0rU0VPcGoxQ3dtTUJ4SzhZSE0zK1Q5bytw?=
 =?utf-8?B?SEFjbWRuemJNWDErbXNPVEZLNHp2SlpHSER0dlBpNTF4UGtxdExBZGhlY1Fj?=
 =?utf-8?B?S0gxN2RCR3JDZWRRbWRPWFVVSzJzOG5qYnIwMklxR2hTU05janNTNVJ1MFM2?=
 =?utf-8?B?UzNiODdOSzd6ZmxYTUpaVmNvQWQwbkxGdkpORU1wblFyWG1rOUR0a3RpVW9m?=
 =?utf-8?B?a0RFQlFWdmJKS2ZweXhpZDRoNnk5VXFVcXpBWXBrbEVUK2RvbkswL1FtL3VM?=
 =?utf-8?B?SzF0UzBWTVJsSmJvVDhGeCttV3RIZS9zSUZ1N3FEcHNic1FQVmoyV2YrOHVt?=
 =?utf-8?B?YVhyY2s1N0V4a2NGbnFhMkFsVG9yL2VYK1RzVEczcUxMODEyQkdYRml6WDJP?=
 =?utf-8?B?cEtmUW5Ba3lKRVhQRzFjTXk3ZVhDdGlZSmt1eGUzYjZIZVVTeS80N2RhVVRW?=
 =?utf-8?B?OWdyNm1xeXdJZmhkbmNWQU9QbVBGNXZxZmNDQVhFdGVzR3JqYi83MjE0a0t4?=
 =?utf-8?B?cWVQV3kvZ0hHdndBcFJWTU1FZUJSZ2F0VFROeElxN1dSNTN0dkNKSHNMT3kr?=
 =?utf-8?B?bEdTOHRZQ0U2SVkzNGNrbEYxalBYZmJzYWFlSjg5MXN3WXBBdmFMaTFmeEhr?=
 =?utf-8?B?T0NPWDdlWXAzaW1GNDVYWXh2TVdXcXRiaFE2Tk12VzYvR1ZSdy82UklIbGpQ?=
 =?utf-8?B?RXNnZ3FSeUxYenJVbHM3cHdxb29DcmJtV0VyanE2M2wyRS85T0g3OEVobE1R?=
 =?utf-8?B?WU96Zkd4TzdoY28zcngvQ3o0TFVQVnEzc2hHbk12dDgvbHFMSTNzWHRIZ1l1?=
 =?utf-8?B?Zm1welI3RG5acW84R0dEOWhhUnJmZ2tCa3BIUmRnUU4yLzN4Ym5aRjVDYWtk?=
 =?utf-8?B?K2lmNE9WV2kvZWRFRFdBWmoraEtjeWNueEFVM1pYbGppSnoxeGJNZktPNWtv?=
 =?utf-8?B?YXVsdGlkaWFnMk1qNklsclBHY3RSbjFUSjg4dzJtNjRaNmJmZWpoRVlxenp4?=
 =?utf-8?B?OXNSTlA5UGJSZGl1dENlQ2RxVEJMZGNvUi8vRGkyNEx5Z2V2VWhwV3VpVXVN?=
 =?utf-8?B?VzQzT0dWRmRwRTJoQ0plUDBFZlN3MWJEY2Z2RHFSTzB3N1lGZFJBTnNYcG03?=
 =?utf-8?B?UGdmUCtVR3hWUFY1a1hVVjdxcUY5VVpkWlJhU2lhY0lVSjlBOU4wbTRUTzdv?=
 =?utf-8?B?WnJlM1lqcUt3M1hWWFhVdGFzNUFYWk4raCtjdTBaaHdVenlLbmJqdjZwdFUz?=
 =?utf-8?B?STE2dlMzcjV2TlBMNDlZc0F1d2VGVG5KSEVlNGUzakhISzh3bk9zaE16cVk3?=
 =?utf-8?B?V091OFBwVVNaZjUzWEV3RktEb0NyekFyMHhUL3hXbmVZbFZYdm1ZQnBoS0Jh?=
 =?utf-8?B?Zy9ORUtjOUdqVUNvNVRZVjBBaGlHWGppemVyUUdza0x6VTkxYlJKM2NhSk04?=
 =?utf-8?B?bWs2NGx3QjEvUWlFTUd5akt4MEJsTzZJZDF0ZUY1VzZOQnRhbWcydUY2T0JL?=
 =?utf-8?B?Q3MwK2xkcUdsdWVOZzRTdU1Gcm5OV0hOTjM4VXF4L0g3V3VweEZ3VEdXZ0Jy?=
 =?utf-8?B?aE1sWjVtWXhkSVNhNVcvRDd0REVQYlpSbFRJRHRBY3lkR3l0K010TG96WVlR?=
 =?utf-8?B?dDYxRThQWmp4RUZPYytWb3RsdWxLSnBIVmUxc1hUTTcyK3pqN0ovRSt0cVkr?=
 =?utf-8?Q?gSXP3x1Ecjjv43ssRMrrO9TF964eWroi+8qPM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3IzdDdENDVpZ3RjU05lWEZTTXZpRitpRk1haHQ3NVNlMXo4YTJFRms4M1BU?=
 =?utf-8?B?dVFEWXhOQVBYM2toQjNGVm5tUG9OdjU3L3I5MEZxRDFFTXdpWVBaRzgrNWZN?=
 =?utf-8?B?bnY0Yk16SjR0OWdJS1U0eEZpWTZBQ2puTXp2Q241SzhqWHo5VVJ6L3pDNGJX?=
 =?utf-8?B?Ym1MdUFKWnNUUWZ6Y214WCt4dmg4ejFULzdQZ20yY21Nc2t5d3V1Y0RtLzFz?=
 =?utf-8?B?WVRYSml0R0dicWhuWTh0REtuK3luRlJ2L0lndDVPcXZTeHdINm9zMEdFNFpN?=
 =?utf-8?B?cVNrNGJtWUREWVpiaEZNTk51YUJpRGN2bVNlOXRLM21TZnJaQk16N0U1Rkd6?=
 =?utf-8?B?Zk9zWEZZbWlFQm5QK2dYMXZ0YkhpeHBMSlQ3MzZJZXZOOThhT21xL3MvQTVL?=
 =?utf-8?B?bVBMMlJCVS9nTVBQQUxwSExqQXczZXZ1UGFoTjNRU2lzWFR4MTYrVnc4YzdL?=
 =?utf-8?B?SU92RVNhZU16cnh4bVhlekFLblN0RkxlTWQvSmluVmQ4ZGFwYUE1YmFtdC9s?=
 =?utf-8?B?SHVQY1NaRTFYeEhRQk1XQ2J4QjFNaDFQaDgzVEd3SDVrRkdrRXV0RUJTY1BW?=
 =?utf-8?B?c2NPeDBOSTNjbkJKcVR4ckUxZzFlTVlwcHdmSEZ6Y1BJNUpaaXVQS3BvZE9h?=
 =?utf-8?B?akd4R3Jlc081dTIzcEYyK3JsdjhhSDdwUi85Yzd1UnpuMHJ5WmRSZTIyRmpa?=
 =?utf-8?B?c09LKy8xVTkxQ1hscG5kZzVtTXBFamYwRGFySlkxRUIwTnk2d0U5czlzRU1r?=
 =?utf-8?B?blcxaVdYMENuN0QzMU0rWEY1L2Jac2trVFB1WFFJR2U4M251R0Z3RDJWbXgz?=
 =?utf-8?B?dDJIdUhwNWh6dWRDZVE4Y0plYlpyeWgrZGRNUENFRSs4NjVrUWU1YUdCRFhr?=
 =?utf-8?B?V1F2Y1lPNGlkRllwQ2tWMGtXTHVvbU5xb0YwNk4zdEk5bzRGL1dHL1RqTk9M?=
 =?utf-8?B?RXN2MS9ndXZ6U2hhbTRhMmFLdmFWTFVqcEhZYXN6czZvT3JXazRXWTZIR2lr?=
 =?utf-8?B?MHd2Umo1Z1psTDVtTGlBc29mOXhHdkROeFNETDhadjVldjk1RVZHemUvNm9u?=
 =?utf-8?B?cGdaNm9WR0hEZENWZkxPVjFnOXJNZWIzZGh0WXRLVU56RGQ0cDJ2ZUNOU1V5?=
 =?utf-8?B?OUFNay9SdEs5bS9NeFZnUEo2NkNIS04xc3ROdG1CM0w2MVIxTUQyYUJOQVZF?=
 =?utf-8?B?S1ovZ2Z5NmZHTlFRTkhLUllXSUpMdjFXNXZjRzM2TTErRHpGK3dUd0dhUTlp?=
 =?utf-8?B?djRYRnQvRUd2Q2xEbVNrUmhGQkhkU1AxczlxSWVMVlZ5VzlPN0NaWEN5QTQ1?=
 =?utf-8?B?VXhHaHI3ZlBqMXJab1ZXbkFPamVxUlZoM1BGU0JmSFlLOFlkQTAwTnp4K2ZN?=
 =?utf-8?B?S3JXQ3E0VkdGbEs5MTU4N1NSWmY1eWMxT25hQlVNRGtJZ3Y5SDF0UzVOUU9I?=
 =?utf-8?B?WlVUMnVEWklqTUtOZVE3NmdoOUk1eWdFcktqcWRLR0QzYUlncHkzTWp6S2VF?=
 =?utf-8?B?MllwQ3FDUTVqUnRHOVk2aXRZVDlZUVZ2K2h2YW5jOWthanpBbWdMbVFjMDhw?=
 =?utf-8?B?eWxMNkFFU0UwNXNDQXIvY2ZnVFhQTFNjSWpNSXNpYlZubWVEbTFMY2RFT3k0?=
 =?utf-8?B?VEI0SUtwSFZZbnUxSFc5TTVISkgxcHg5cm5tQUxqLzNTMmxoeDYwczJVSkE3?=
 =?utf-8?B?R0dyU29TekowcVhaeWRySDR0dGhRR1M1WWhsZHpzU3JBK3pBNWVSc0hwSDNp?=
 =?utf-8?B?b2RXdmJKQWRGNmlUTUhiWkQ5WU1kdk1pclRNakJkRnJ6QkpuVmlSYmJqMW9p?=
 =?utf-8?B?YWI0aGY1TlkzangyUksrcVpEVzQxZHZCRi9VQ1ZYY3ByL0VKaUIzNXl1ZS9i?=
 =?utf-8?B?ZFZPcE92Rm01YVA1UE1SYjR6eDQ2T256UWNrSERMdGk4Q3BHMnJJanBUMjVI?=
 =?utf-8?B?SzY2ajdKNUtaaEE2SW5jYWwzelhGb00xSE1CRG5mZWNadGEvWkFXUGZ1ams1?=
 =?utf-8?B?T0xzVndYYlBSd3owSUVoS052dGNyZ2pPWjVMUkxCVENYdUJMSytEWGMxbzgr?=
 =?utf-8?B?SHB0c2Z0M3VnQ0U3WFY5Smorcjg3TEoybTFJUzZpcjVoVXFvWjEyeHd1MzZz?=
 =?utf-8?Q?wCzpUibIxg178vy78ePqZue3x?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c1c2c3-ef74-46ed-a24c-08dcdb919837
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 05:35:54.9708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5JzRoXzIwazXEkFt6VpkLacpJHNf1PUvXCaEyOltMJWR3tDG00KPRJtotQiVkBRRFwHhnQAZ6/VFGRALNDEWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6000
X-OriginatorOrg: intel.com

PiBGcm9tOiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IFNlbnQ6
IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMjEsIDIwMjQgNToxMSBBTQ0KPiANCj4gT24gU3VuLCBTZXAg
MTUsIDIwMjQgYXQgMTE6MDjigK9QTSBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPiB3
cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgQXVnIDIzLCAyMDI0IGF0IDExOjIxOjI2UE0gKzEwMDAs
IEFsZXhleSBLYXJkYXNoZXZza2l5IHdyb3RlOg0KPiA+ID4gSU9NTVVGRCBjYWxscyBnZXRfdXNl
cl9wYWdlcygpIGZvciBldmVyeSBtYXBwaW5nIHdoaWNoIHdpbGwgYWxsb2NhdGUNCj4gPiA+IHNo
YXJlZCBtZW1vcnkgaW5zdGVhZCBvZiB1c2luZyBwcml2YXRlIG1lbW9yeSBtYW5hZ2VkIGJ5IHRo
ZSBLVk0NCj4gYW5kDQo+ID4gPiBNRU1GRC4NCj4gPg0KPiA+IFBsZWFzZSBjaGVjayB0aGlzIHNl
cmllcywgaXQgaXMgbXVjaCBtb3JlIGhvdyBJIHdvdWxkIGV4cGVjdCB0aGlzIHRvDQo+ID4gd29y
ay4gVXNlIHRoZSBndWVzdCBtZW1mZCBkaXJlY3RseSBhbmQgZm9yZ2V0IGFib3V0IGt2bSBpbiB0
aGUgaW9tbXVmZA0KPiBjb2RlOg0KPiA+DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8x
NzI2MzE5MTU4LTI4MzA3NC0xLWdpdC1zZW5kLWVtYWlsLQ0KPiBzdGV2ZW4uc2lzdGFyZUBvcmFj
bGUuY29tDQo+ID4NCj4gPiBJIHdvdWxkIGltYWdpbmUgeW91J2QgZGV0ZWN0IHRoZSBndWVzdCBt
ZW1mZCB3aGVuIGFjY2VwdGluZyB0aGUgRkQgYW5kDQo+ID4gdGhlbiBoYXZpbmcgc29tZSBkaWZm
ZXJlbnQgcGF0aCBpbiB0aGUgcGlubmluZyBsb2dpYyB0byBwaW4gYW5kIGdldA0KPiA+IHRoZSBw
aHlzaWNhbCByYW5nZXMgb3V0Lg0KPiANCj4gQWNjb3JkaW5nIHRvIHRoZSBkaXNjdXNzaW9uIGF0
IEtWTSBtaWNyb2NvbmZlcmVuY2UgYXJvdW5kIGh1Z2VwYWdlDQo+IHN1cHBvcnQgZm9yIGd1ZXN0
X21lbWZkIFsxXSwgaXQncyBpbXBlcmF0aXZlIHRoYXQgZ3Vlc3QgcHJpdmF0ZSBtZW1vcnkNCj4g
aXMgbm90IGxvbmcgdGVybSBwaW5uZWQuIElkZWFsIHdheSB0byBpbXBsZW1lbnQgdGhpcyBpbnRl
Z3JhdGlvbiB3b3VsZA0KPiBiZSB0byBzdXBwb3J0IGEgbm90aWZpZXIgdGhhdCBjYW4gYmUgaW52
b2tlZCBieSBndWVzdF9tZW1mZCB3aGVuDQo+IG1lbW9yeSByYW5nZXMgZ2V0IHRydW5jYXRlZCBz
byB0aGF0IElPTU1VIGNhbiB1bm1hcCB0aGUgY29ycmVzcG9uZGluZw0KPiByYW5nZXMuIFN1Y2gg
YSBub3RpZmllciBzaG91bGQgYWxzbyBnZXQgY2FsbGVkIGR1cmluZyBtZW1vcnkNCj4gY29udmVy
c2lvbiwgaXQgd291bGQgYmUgaW50ZXJlc3RpbmcgdG8gZGlzY3VzcyBob3cgY29udmVyc2lvbiBm
bG93DQo+IHdvdWxkIHdvcmsgaW4gdGhpcyBjYXNlLg0KPiANCj4gWzFdIGh0dHBzOi8vbHBjLmV2
ZW50cy9ldmVudC8xOC9jb250cmlidXRpb25zLzE3NjQvIChjaGVja291dCB0aGUNCj4gc2xpZGUg
MTIgZnJvbSBhdHRhY2hlZCBwcmVzZW50YXRpb24pDQo+IA0KDQpNb3N0IGRldmljZXMgZG9uJ3Qg
c3VwcG9ydCBJL08gcGFnZSBmYXVsdCBoZW5jZSBjYW4gb25seSBETUEgdG8gbG9uZw0KdGVybSBw
aW5uZWQgYnVmZmVycy4gVGhlIG5vdGlmaWVyIG1pZ2h0IGJlIGhlbHBmdWwgZm9yIGluLWtlcm5l
bCBjb252ZXJzaW9uDQpidXQgYXMgYSBiYXNpYyByZXF1aXJlbWVudCB0aGVyZSBuZWVkcyBhIHdh
eSBmb3IgSU9NTVVGRCB0byBjYWxsIGludG8NCmd1ZXN0IG1lbWZkIHRvIHJlcXVlc3QgbG9uZyB0
ZXJtIHBpbm5pbmcgZm9yIGEgZ2l2ZW4gcmFuZ2UuIFRoYXQgaXMNCmhvdyBJIGludGVycHJldGVk
ICJkaWZmZXJlbnQgcGF0aCIgaW4gSmFzb24ncyBjb21tZW50Lg0K

