Return-Path: <kvm+bounces-26864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E1697891B
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972611F21CA9
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0D81487E1;
	Fri, 13 Sep 2024 19:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c86NHjkV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8333413CAA5;
	Fri, 13 Sep 2024 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726256993; cv=fail; b=Esnej8Luc2AWeJ5v2IWPOjU2kGohQUAkgtrSqrZc/YiM71QyaO1SValgh6yXkFkkyUb9ecmiV0b6CFGclFDit779kBtO4Rr13qN6g0Jyjzb1Wucz2oVznLRusATRBIpPeOgM2cPcdtbK/V5N/kKbZInTFhO2EFT/7VQrbmXqFSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726256993; c=relaxed/simple;
	bh=82H1BypN4tnWLt2JRobihXAgfhbg6TCYSYt3NwucJiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tjBTOVFrBRkhfrI124bPqnMvMgr3QZNG4ODzdbTrkf6ZnhI8g2353lu3Y5DrMfTnvi/C0DrNFa0s5mMUeO7i7rus/B/P8yeCxBA2oynGpnYJS2Vx3Fj9uQEOgEmoY0s/Ub9tgwf1NQyBBdhAMyPBNuUePke0XU7n6ZltWvhY5Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c86NHjkV; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726256991; x=1757792991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=82H1BypN4tnWLt2JRobihXAgfhbg6TCYSYt3NwucJiA=;
  b=c86NHjkVmIOkaEN/b3eW0Jj/jZAlV28tVYt7FbZSbezam2uDjZjctvg9
   5usCD1bk9iPx6SxKqC9hZJEX0XGKTHByhgohW87qr34Rhlv9vwz/G8jzX
   leGjPfGr0cANTVbTyOLFKF9xltsJOk13yIBhf8uWE8E17rRznjUWmc9cP
   G2WPmFi5JkKUk/MNySAYiS1Ofufo3THuzeH8AHRH8hpfM7E2C/05OsO8B
   kCLL4Ef5TGFgJPaPnryBSO8XOhWmWGd/h0T/PS2Td7GgbWZNIaNYDSC73
   9BV+U31d0x2YfeZa7E0gEeEEhzgPsnnX7XAyM+3lEFNUXXtDbawefihhO
   w==;
X-CSE-ConnectionGUID: 4PL5FQ/AQyago21MIPwM0w==
X-CSE-MsgGUID: Pd9luuXpRSWCHmcK/ACu4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35745297"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="35745297"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 12:49:51 -0700
X-CSE-ConnectionGUID: zlO6jx3KRTqoW4eemhLFTw==
X-CSE-MsgGUID: AZxgq1RCRaW9OucRsMvMYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="67797867"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 12:49:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:49:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:49:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 12:49:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 12:49:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2CfKvYFM6QNkYPPsEK6lu4LZ/SY8U0EgvHblDRidaIOx9CNnuGoLJ2j8HkbBBd6xSdFfs8XeVJ7RzE4qamoYUsRNEc7LOpjnCIlJ1mB7x9jR8ojeGZPR3d70poA4yGfOU5YdUKgRMJkfuOfJB5y4zo95Fw9BdDbcIdZ9cU21b9TVw5fI/cqV6eqoBcWbX4KIQvptd4v/HjtCarEIRhAPkTaHVcmua4uvOT/taY/5pTbYtNuQczVrvzmUmewLTixo/TVP2TGgm6kcJQXEI34wM7JcDDXJJ9EBxXhZQVtsFNKVTmIdRp2oOMo4F5cis86x6tbqgxZEGfId4wNrnyZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82H1BypN4tnWLt2JRobihXAgfhbg6TCYSYt3NwucJiA=;
 b=iQK+yRG6AJ7Y3jo9Nn5suyywsAmPR2hddq6GWksCmk4aO8OEHhFbWeRHdYZ6FDmkU3t6/Mj4p0UpQuGMVVuZ8YYtL/kHjIYrMKGCKYePdoLRvXDcRbN5G2rdrboe2pFPFCs1lKIFDaAIiV9FJq0emFsCyRctYYoWOaXQ4/gaY99wS4PbALLt/7+GoDYU+hMA5JFonKAHBsvZvw/svthCJfhYwA4tKM7I51HnyqOXyG4TDLsm2AJeTYO+ksYzSvtMStf4oMtT4s3NpHOKU4IsUc+KLGuUDXACiqaBaeg997ibKH0PksU9cKkDySHlVGGFzlFrIh9JTB8nWrWK9lrLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7603.namprd11.prod.outlook.com (2603:10b6:806:32b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 19:49:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Fri, 13 Sep 2024
 19:49:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Topic: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Index: AQHa/neylxoaYrTILUWaulhlDyL5EbJQ2kkAgADpRICABAKngIAAaQaA
Date: Fri, 13 Sep 2024 19:49:45 +0000
Message-ID: <5069e496e2fd0677ddb24348360f5d4b1745f8a3.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
	 <6d0198fc-02ba-4681-8332-b6c8424eec59@redhat.com>
	 <32a4ef78dcdfc45b7fae81ceb344afaf913c9e4b.camel@intel.com>
	 <0fed1792-806d-41e2-a543-8ed28b314e2a@intel.com>
In-Reply-To: <0fed1792-806d-41e2-a543-8ed28b314e2a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7603:EE_
x-ms-office365-filtering-correlation-id: 7ed37ccf-dec3-44a0-a86c-08dcd42d3814
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RGM2SkY0bGNMcTI4Z0lXVkc4SnphWHd6MU1mWnNONVAwMGdWZ25MSjEyR2Ew?=
 =?utf-8?B?MU4wWU40bjMzMThmU1l0eUNPZWRUVDVqSFJ0QWMyVzduMmE3RG5mQnUrK3FY?=
 =?utf-8?B?bElUTFE4cWRSSGUrTFk1WkhDWmdRT2JQR1dxQzJqQVNDL1VhZTdMemxZYndp?=
 =?utf-8?B?bnZrTFpoVjROQUZjbDE5WE9yczl5dFNIY1JKT0UrOVZFV2dEZFFrKzNYbWcx?=
 =?utf-8?B?YmhFNFQ3VkVwVWliNjBTaFVsOEZtUmJ3NGh5SEtYd0p6b2diMHhSNHAyU042?=
 =?utf-8?B?TktwMWZ5cTk1UjQzNy9uUUNXYXJRVENISkZkUzVrYmkyN3dSWDFSeHZNdVBj?=
 =?utf-8?B?RGhxU2FNMndyUlE0QjVia0tML2tuekM1NUdxSmJvMmNDVGR6YWI3WnJVc2xU?=
 =?utf-8?B?dzY4YXgwMTBHRDlCNlljQmY0S2pteUNLMFRXK2c4RHdxZmJLdVVZNWdjWTFm?=
 =?utf-8?B?dTVXb0Z0ekN4UzlGSW1xZFlFWHB4ZVE4YUJ0TTA3YjZweHhsZTZHNEo5OXRk?=
 =?utf-8?B?cUFsQmJjQ1EwZkFja0s5Ly8wKzZETVJ4Rnk1QmRVWnp1WlRPV0tmYlRJYkZF?=
 =?utf-8?B?NHJkU0NLS0FMV2xOM2ltRFdqd1hBcWNjL01ka2xvTUV2ako5ZXVtRytVUktC?=
 =?utf-8?B?YW5Dam1QK28yQ1IxaHNoVnY4c3RrSFVaODNqVXJhWjc0R2dnOHd5eGZCQXhU?=
 =?utf-8?B?aHVZMm9GKzl2bml5eVI5aWNlYWxDMktYZTdTVnEvM2wyb1U4YXUwb0Y4SlBS?=
 =?utf-8?B?d0N5a2ozZ1E3OVkzakVSSm1IdmdKWVNuS3U2OTFzTmtHci9aamRLYnI2aTEx?=
 =?utf-8?B?Wi83UWpwV2U4RktFUkJCUHNTTnJLeEJIQnppUUhMYmc2SmtoRW1ERXFUVGY3?=
 =?utf-8?B?dFVRZVh5SFJTZGllblVRa2U1ZTVtUWIxbTFVSUo5bzVkcEJqOW5yMzdmbHZK?=
 =?utf-8?B?dmtlaUltWTNTMGJHcnQxSVVmcHlYNStSSEdGL3UxWjdKQmZDQ1pVNnVKajN6?=
 =?utf-8?B?Mkw3Zm1UV3FUV0lHOUIyNjN6dFBOOUttODUxUSt1UFZHUUpxVlFsUXlPZGZr?=
 =?utf-8?B?QW1Td1ZENkRTQkVUR2k3WkU2MGtvS29jMUxmUFh6b1ZrSjhQSzdpTUNiZ3ln?=
 =?utf-8?B?b1BuSVEyY0dqTFdTaUpLZlNtaVg3Y29hVE5ZM2phSUprYXdjMWFDc0F6c3Y1?=
 =?utf-8?B?ckxLNVFUMUM1TEpSazdQQW5yOVlQbHFjbzFqMy9VMzI3WEp3ZWdpTXdJU0Iv?=
 =?utf-8?B?bEp6YnVjRDE3RENQRlEvWU12MnlLMUR6RXVyZFl0VXIwaTdKOENWRmVzcWVW?=
 =?utf-8?B?RXR4Qll1RWpHNU9uL2pEdzJSdFZKVWFsUnBGQWE2QUZ1OU1kWU95N2o5dTJC?=
 =?utf-8?B?Z0hQZzhuVHpDWkR5YmYvWk1Dc3RRNndaU2FwVmtRb0N1NW5ZVThWZEo5NDhv?=
 =?utf-8?B?WUIyRzJYdTlWcGdIVThpdUJtS0V3YTFuMWI0M2Z0VHgzeitJc3pWUjhkRnR4?=
 =?utf-8?B?OU1rSjJka0QycnlyYTA5eXg4MkY5Mk1nYjlvNEFJS1huZHFjd3JBcjg5MStR?=
 =?utf-8?B?VjRZbUY3TFVGbGNVV2JQa0lZM3c5LzdWRlYzcXZERFZ1aGI4OGZlckNod21T?=
 =?utf-8?B?OWx6RE9MNmlvNERTSG4vQzdaQ3dKeEVoZjJPKzVNM1Z2RnUzNWdVQkoxQnlx?=
 =?utf-8?B?UDlMTDdJWTNvZkFEOVo3MFBjMUpqYjFxZzhrcksyb2lrVGgxbFJFOHlOcXUw?=
 =?utf-8?B?ek1JSXhMNGVZNzVjTGdMa1E1dGM5K1RBYk16V0ZraUQ3dGNaL2ZJR0tHNXBW?=
 =?utf-8?B?VkdBYzUxWStjVUpUZlFObG1mMk5hczdkaGNRSXhXZmd2UWJFWkxPeFpQQjNz?=
 =?utf-8?B?T1UzTXgrVTNDTUl3MFh3TnZpWFRZSDlCY25Jd3FhTXp6VWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXRxckgzNEtLVXZnTk94UXd0bjdaNHRaTWIrTHgrVTFTVy9sWGFDRmtXNnIx?=
 =?utf-8?B?L3JSNnArRkQ4WHBQd0ZxR1ZqcUtsZGZCSXd4dFVYVnhMMVZTU3hnWHM4WmQy?=
 =?utf-8?B?QTlGMkwzRGt4dkVXcUgxNWRYeEZYbEhoVXNzbVpHK0hVdForSzB1WGZjVDUx?=
 =?utf-8?B?eW1Hc1JxaFVrQUVHZnR2Wm12NkVWUWd4WkVySzlaRlJraVFYMkZRYlplNXhn?=
 =?utf-8?B?WStpcXAvY0c5LzlvRkIxMG03NGNLd1RPRjdHQkVjZmFadXMrY3lNNDRTUHU4?=
 =?utf-8?B?Z0V2eWFESjJjZzlkNkFjWGpZRkZqZjBmVnJnZVBFRTI5N0YvcDZJaXFsVWE2?=
 =?utf-8?B?Y2F1dVFvRTNGVEtVdEpRR0hQZjJzdDFWQzhHdTRMYmVmS3RVZ2lUZnRSb2Ev?=
 =?utf-8?B?a053Yk5OaXRzUjBPY3h3TitNbG9rZDd4cTdnSURLWEhCZkxuVHFIUmdOQktj?=
 =?utf-8?B?eHZiRWZGdmhKMXlFaklzZFZNRGxGc3RLSGVuYUF3WHoyay9OMHdsdUhiV0Nu?=
 =?utf-8?B?dm1nL2oxU01kVlpYMG93ZEwrNTRXWldQU0JldXplTzllTW5mc0x2cXVSQ1pZ?=
 =?utf-8?B?R3F4WmFDYTdOSXpEdjVFVExrcmZleUNYZ0EzWFVWbkpLd0dvYWlwMXZhRHVD?=
 =?utf-8?B?ZCs3c3ZqQVY5aWR4eWpBUUpyNjY2dFZUVUhITHUxdi9scFkvTlNwclB6Kyt4?=
 =?utf-8?B?dEppZU1MWmdXNm9sR2F0QkMvd0ZlWDRSY3RvOXZ5RFdzVjJ2dW5ZOHZrZ3N4?=
 =?utf-8?B?bkJ0WW1MODJGc3hhSW1Hbm9XVkgvTzc3SDlkeWtadmlRT2x0R0pyZ29YaXhN?=
 =?utf-8?B?U01xVzlrTmNzeEYzZ2JHbTJobG9DVW9lczMwem8ySjgrczZDaUxwbnZ6SUs2?=
 =?utf-8?B?ZEd2d1g5UzRKN1M4eUViNEQzTDVFYVNEZkFpckpPcEFzdFBEMmRyeGtYdzE4?=
 =?utf-8?B?Nm5xOGgvZ25TbG9JMUoyTWpmcllrWG1ERFF3anF3VUxhTG5mZ1d3VkowODQw?=
 =?utf-8?B?OFlWQXFSWFlmUStZY0R0NE1zUE9qL3BtbUM1N3NHSXFUSnBUYUFXWUczMXRx?=
 =?utf-8?B?M1R3VFpuK0VKNkZwWW9xUWNxaktXM3o1dkx1QlBnWDUrLzZLTCt6UmRJQURP?=
 =?utf-8?B?M1Y4TWd1NUZISHJNMGdnWHhrVHJvTGgrcTlxUTRFTHY4UkJ3Rlh5U3FSWWdT?=
 =?utf-8?B?N21BeGE1MzNySjJ0VER3S0VDcXFQOUs3MEl2QTd0c1ZTVEdKUnBkWnlnZWVl?=
 =?utf-8?B?VkIrVzBqSXd2c3o1NXgrRkcxWFVyV3M1eFFRM3FJdElTNUpyY29POCs2WlZa?=
 =?utf-8?B?ZTR1OHlvTVJiTGs2MWE0MjVoNjliOFp6ZEZ0clo5R2lVNzVBUkVoV1QyQnRG?=
 =?utf-8?B?SVEvV21HbzhBT1lqd1JmTlJEUC90aUdpbFZHdGhvMEYyd0NiS2ZTb0N3ZDh2?=
 =?utf-8?B?TWt0L21rOXB6YlY1cFBqVThoeUVrNWlvVnEwMmgySTlyZGFkN3gveUQvbU5a?=
 =?utf-8?B?NzVkajVRMUFzOGppTVRFc3BEVUVBNmtHdGkrczZkN2p5UzI3dkgra21mdUVU?=
 =?utf-8?B?VnlNSDEzNVlGL1VNQllmUnRxU0ZvWVRZMWZtMzB0OHZpM3ZpSkJuOUw3c2dD?=
 =?utf-8?B?RHVpUUxsUHlYL21mOE9panZtMVNIaWUzclJ4WmMySVV4aVZpTTNDQmpsUnlU?=
 =?utf-8?B?eHc4ZDUwYzV5eENGeWgxQjNtdHFSMXg3eTVFQWllZGhjeVEvNjY1TE5kVmZD?=
 =?utf-8?B?WlFXYWFkRU95VllQTHpGNlBOQlU3WS9VWExCUldhMVF2UEdrejRwZkE3d21R?=
 =?utf-8?B?UVVxWXNIYjdKUlRuaVRmMVlGZmRNZ3BPQjl2MjlNWFZMSGxRYjhFRm1wV0E3?=
 =?utf-8?B?VDFPL1NKMGJYVlB6Nlp5Zy8wQTE2Z1I1RElRK1NMbnlyMjNtaUUydkZWOGVP?=
 =?utf-8?B?UWQ4K01qMldPS3BxY1REK2E4QW1HeDc4Rm9YV3B2d2NMb0NzR1FaRjRkQUE2?=
 =?utf-8?B?S2VhRVVtRVV3ZGxkVzJibUJ6TmttcnV3Vm5JODQvRVdvOWd1WXpIazJFcGQ2?=
 =?utf-8?B?cnluTXkrOFNBNWNLZHdCd0Nzc3pJSlVpT0crd3k2WUpDMmZHUGNNM1AwcXl1?=
 =?utf-8?B?Zno1a1Zxb2l6dFVNWTJSVlY4aGx6MG5zSGQxaGxwbXFBWXY1dmZreHZTTzBX?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8391E161F5D87F4386DB125991B93FAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed37ccf-dec3-44a0-a86c-08dcd42d3814
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 19:49:45.8698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHvpU1EbHSavVAzT1WiOydOs+67j5gBXKryUNg7KykzazWf3/CE62Dx7IH1Gnqu1HX+0P2lhnJ1YHoTiLb+nZ+UTsYNdLmPC8NRuVxrQaa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7603
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTEzIGF0IDE2OjMzICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBJdCBpcyBhbHJlYWR5IGluIHBhdGNoIDE0LCBzbyBqdXN0IHJlbW92ZSBpdCBmcm9tIHRoaXMg
cGF0Y2gNCj4gcHJlc3VtYWJseS4NCg0KUmlnaHQsIHRoZXJlIGlzIGFuIGVxdWl2YWxlbnQgY2hl
Y2sgaW4gdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZSgpLCBzbyB3ZSBjYW4NCmp1c3QgZHJvcCB0
aGlzIGNoZWNrLg0K

