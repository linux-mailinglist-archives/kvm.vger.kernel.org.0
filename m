Return-Path: <kvm+bounces-56362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 510E7B3C362
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 21:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9F4C167301
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76B5242D7C;
	Fri, 29 Aug 2025 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LdomxgTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641A02566;
	Fri, 29 Aug 2025 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756497218; cv=fail; b=j8d8mpQ8lf/HewfNhpm2jcTptLlrKn2xR1lC5LALEF6les8UILqgD+T1SjM0g2Zr1Lx6dU6rb7+nd0eRqwy2KBd51vV85Fl610z68yu9rLkGA/4zN+Og0aaDHqhExq0jijk2qHhVR+W+np7AFiMGMCDoaRSlKrnn2R9FtnKU2d4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756497218; c=relaxed/simple;
	bh=Ngff4MYn048vRWkMBH0bneksVsdthnLmUWY3ROf65qw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Af5TDYhqHodo92W9a5NF3d3ZFE5yfWBS/hR8cw6p3tHb08dwdpUgQAGYUr5ReLHCzEi68layaiAs9XoA9OqyAevvOgiYEkM+dSdj9YhZPb/HnpQpMIGCbvJQAeDUip+L95BYTvGnC5A1m0iCc98QBrNe+aZri2ypbF9TKxGk+hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LdomxgTQ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756497216; x=1788033216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ngff4MYn048vRWkMBH0bneksVsdthnLmUWY3ROf65qw=;
  b=LdomxgTQpxb9dgztp8qzWYhpjxNbBvLEj96SAhQfWTD1gXrjXx3tF70e
   5F8Lxd3x9GO5VVq2Fb1A0oVrovlyAwZTFcyzVQjcYaHKTGecKvE8IKdpy
   7ZzuXXSW0v7lY/zN20qbS5kO0r0PS4DkyTmIxrtI8mEPRKuuKBotCFjC4
   g+5mCtJeuhfg5X/dZzDU+PBL9aBsSMFbMyZHS/3aRxXxmvS40LoLVlfFY
   /GijHdTqRMUO7ZtDV7uJWfVRnSDwRpB2sIGr2eruk/q9X5kaRH+QvWYCu
   6O68S/L7ARAQf2iV6iqrwiC2DqGJqR2E3aTnwqGZjyq2HpWkfGpvaV4+0
   w==;
X-CSE-ConnectionGUID: qza/gPspTxCXh5T/Q5Hq2g==
X-CSE-MsgGUID: TNdtKF9TT7q3zwwnVt2+6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="70161467"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70161467"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:53:35 -0700
X-CSE-ConnectionGUID: Im6HdwYwSNSbu4RCO9I+Sg==
X-CSE-MsgGUID: uhxiw/NDSQ6a1e8ajB+TfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="201363265"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:53:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:53:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 12:53:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6wm8ZfZpkTM2bkOOvIJCccS5WxREkgGg8zGX5AD7ltjys7VsPiYa0VsoFA4XuIkYkHWGBRhh9mC/CCsYLCRLbRJOTPTB7TSnTnRs5CpN6VtBw5tB56No7rUc3RROTylXsEVphrIeOQQo6Z1+4PRf7HdTJyK23LzO6owSypnp552Rb+Mp/vc5i+E3TTsnBtsIfZdlyswugcckT+QdkRdlYQ59UuaqHKAFaUtMnZigq9AkiT4hlZjIQYpf2oR0OFbWp6aBv4jwB0DA3n2lBB521vauOqZgt799lpa+XXNElsm7v6AXxBjEYX2XEI4ZtsYL4VExsfZ4tZJmiOqRnxJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ngff4MYn048vRWkMBH0bneksVsdthnLmUWY3ROf65qw=;
 b=mzqvq3WgvwgaeeFN9YyxtoalK4+4/6/Vwky3XFAMcIPQ4f7sawnlV7wh92AG8L1oyjY8YN4ZegBV+b/C21KybwCIjVk3rl5QkYcSDnghfiZmMprynrSbpse/i0VXZCIh1FVguT+mHNZzVrziOiJhUKs3d6j2nCL5ikcFBMXGGNo2UZyrYWeJvKWK2Yo78ePesCn6PWrkeY/l+qVrG+H0tBTX1wLRWpMk5OuYslMReUtRLGMBSH3cejYNEsJXwRHRnyn3VibHg0zoWY2Yhx/0byU6UQENTJTouVSldGpsTgitZu0BkEQvVB4ooHtFxQhDc1ISwd49SAy880vPEGh2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5128.namprd11.prod.outlook.com (2603:10b6:510:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 29 Aug
 2025 19:53:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 19:53:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcGHjL8dqNtw+1DUm4eDEQMXeVS7R6DDCA
Date: Fri, 29 Aug 2025 19:53:24 +0000
Message-ID: <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-6-seanjc@google.com>
In-Reply-To: <20250829000618.351013-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5128:EE_
x-ms-office365-filtering-correlation-id: 2c2e805a-2ee3-4148-5588-08dde735b6e4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b295N3l6dFhBaTgwQ1liQ2hDQXc2aWNFMTNqZ2lhTlVnQ2xrTDd5NGdOQkRO?=
 =?utf-8?B?Mk1ITlM0VmhSZnBqN21tUmtwNGJqdUVDSzJvMzdyR0xuTlRxc1d4ZWs5eFRV?=
 =?utf-8?B?a1Z5OEdpYnA3a0FvZHpiNngwaFZkR2RiendENmhaL1hLbTFyK2JRc1lzQzF4?=
 =?utf-8?B?emUwbnN2TjZ0K3RYM292b3EyeXg4dFJ0Wi9OL3Z2bk9xNXFaTVdtNitqMHhT?=
 =?utf-8?B?eWNLRHkwTlQ0T08zTmpJb0plTlVoTUlKSW1Va2x2SzJEU214S09mM0VZRUFP?=
 =?utf-8?B?YkxFdmJ0MTVQOWFnUzVMN3FHUFdISSs5ZzBVVFkwWjdNQ3M4MkpCMit4bUU2?=
 =?utf-8?B?ZEc3WFM4Q2s3OWRoSm12amp5SUpvMHMxa0dhRUhzR1VaaUxydU1iQ0lDU1hQ?=
 =?utf-8?B?SVNReWY4L1NQU2hFaGR4S3BTM1ROQmNTWXNEK0U1a3BLOG1jR0x2QWI4MGpS?=
 =?utf-8?B?Zlp1bGdPMGRNeVpjVFY2dFpHeWxjUXE5K2xJcDk4cW94RFowNlJxeU14bTV1?=
 =?utf-8?B?RFY5d0hLSjJ3OXZZWG5CYTQ0cFh5R05mUi92Zk9TcnpzTEg2NHQ5QlZvdnZ4?=
 =?utf-8?B?V0dUMFlwZElDTWwxRUh6YmlTZHJKRzZ2UVZXczMvYXpQY0l5ZloxU0FFNi9D?=
 =?utf-8?B?OWtaMmtlMDQzSjdzSkNTL2d5UkR2RzNRcEIzUVRmdTliSzNlMytjWEJ0V2dt?=
 =?utf-8?B?WEE1aFNKcktQeUFDSElJMVF0cEdjMEVPKzhmSGFGZHNQaTcwaDZpc3gwK3N1?=
 =?utf-8?B?TGErWFI1amxTdzRBRkd2VnpwMHhqYllmZEhRY05GZEhvU1B4ZDdnejkzRm5W?=
 =?utf-8?B?OWpTZVMzQUFGRVlSM09VbUxabldwTUIyWU1qNEcxRkNKUS8wU3Izb2hLRmxL?=
 =?utf-8?B?Zjl5ZjdORWVBaEoyWDFpcXRESlZTNVRhdzkxckhUVDFVRkh2NVVIMnVwcnky?=
 =?utf-8?B?NDBtSGhKYjNzdzlYZzB2WGJsNnhYVzJhNEVKOVdUMkE5NDZ0QzBPSlExU00r?=
 =?utf-8?B?c1F0aEVLUExMNm5KSnpoMTdHc3NYK2hJekdTSWNYSUFRZWtuVXU1L3ZJVlFu?=
 =?utf-8?B?MXA0SlJyTElnMStYU0NxclRGYmdmUVBvUzNnUWllNG8rVEdNbDhPTjZLdGFE?=
 =?utf-8?B?SHlCQ2NtNHdDenFNcXk5cU5pWFFJcDJtNUFkdGFua3p6L0o0ZGg1WkdKSXJT?=
 =?utf-8?B?czd3d2hGMjJ3Uks2M3RLSzVYSlZIK1VXYTBLdnRnZFExRGNWcnEvSTUyZ1JH?=
 =?utf-8?B?L2NYM1M3MTAxS3RLNlovYWFaNDlnbTUrdUZOZENQWDZVL1prb25FaGM4MUNq?=
 =?utf-8?B?TFo5TXRBNkZEVkVnbGNPSWI2Q1BtQWF5ZGhiZisvUjY2WVlGTHk5eFZ1UGIz?=
 =?utf-8?B?WXk0VXFZbDBYKzU3YmNpcm92UmVHVVpMNktjRGRJU3hqcGxzK2dzZUpnZncv?=
 =?utf-8?B?OW8xWEgrRTNHNFM2dlp2eW5ieWRUeGhyd0drMUQ4T0Y4VGV3UkMzTEc1SUtR?=
 =?utf-8?B?Y3hjRDJvaFZxWElXT1VOTGNPTDQyUG4waGdhT3NTTFdqZW5PbmlXT0tHR1Yy?=
 =?utf-8?B?Y3U4ODhxb3A4dXJzbXpUN01icUs1akhBWkw5MkxZYjMrTFdCNWh2U0xNcnlV?=
 =?utf-8?B?WE5IcUxQZUNUcUNKcDRyUjd2TENIVVNxa2xONzBQOGJscStRSDIyTDBrY2FU?=
 =?utf-8?B?ZGNqUkUzckZCcEp1OFE0T2FuZW50NldrYlJxRFF4SzRsV290bmVGeGVCenUw?=
 =?utf-8?B?OUxKY1hsQWdTa21sYUFzeUNKTDd0R25ZWnVGOGdjdFN0c0dXVFY1VERXRkFQ?=
 =?utf-8?B?bmp2OW1rbjNpTzNTUGdwdjRuZmJIanRMSmtDWGdhY29NZkQyc1R3ZWs1ZXB0?=
 =?utf-8?B?TWNGdktra1krUjFFbm9iK1FrS3dWS3JvVzhZcjlMZWdxVGlwL1lMUW5MejZT?=
 =?utf-8?Q?9pvsAcY5TaY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3hPZFcwME9oMm9MUjhwVVpYbWFCNXlTMG1pdWtXOFc4UDZTUStrZmdPalhl?=
 =?utf-8?B?THM2aFduMVhVbHVPckgyaHZJSHN1NXBPc3dscTg4dU42K2YvT21ReEdQbFV6?=
 =?utf-8?B?TmtsK2w5TTlkVTYySHRONzBxZFRkR2trclVzck1lVGp4K3gvZzhxRm1RUUFv?=
 =?utf-8?B?VUp5dVJwQU51dkNNVUJobUJEUDVzQWhNZzZ0dlNNU01CWWlEc29SMFF1V1lh?=
 =?utf-8?B?ZG8zNU41NGREMk5IM0svUDVCTlhRQmlTYVE1NG41OFFWUkhnMUtFam85MTNT?=
 =?utf-8?B?KzFLS3hwelJiTEdPaHYzTTNXVG9Gc00rcmVtenlabG5BaktNczBsenRyZ2Nj?=
 =?utf-8?B?Tnc1YmsyK2w2VHVuQUhsSzhFbll4MmNvckJZR2VONVV6M0RWbEE3eTZZZEwz?=
 =?utf-8?B?dHF0WXl1Z2N1aE9lcUpaeUdLdHRMeG1QQUJyMW54YzZPVVFLOGtNUG1BYzZ1?=
 =?utf-8?B?Vms2bVlaRU82Y25Cdnltb2Y0NlhQOGkvVy9BenVSa3dGeHNSNEtzRUZ3RXdT?=
 =?utf-8?B?bjF3N0Vpd3FkL1J2bE9nL2IxQ2sxWjFpdkFlaVI1ZFdUNlgxcGhHYUxOWTQ4?=
 =?utf-8?B?TUtJM0tsbnp2Qi92VW5hT1cvWjB3MjZuc0hDYk55RW5vUUMxeFl0bEc1R0tr?=
 =?utf-8?B?L1J5Z0xuYjRMK0R0U1RJeDFuT1hzbGJNdGZCYXJpckV0aE5zcEg5cWRtMXMv?=
 =?utf-8?B?a3ZFa3NzemdBNnIvTU5MQVVTNmV0TGdwK3FmbS94dFRHK3lzZks1VGdwdktL?=
 =?utf-8?B?emtHcDJFb1oyY1o4ZUhxb0hzUkQxZ0E2c1NFN282UC9JazUyQTcwRW9tc3M4?=
 =?utf-8?B?b2o5T3ZFK1RDbjIxNzRxR1BSdFd2emZmazcvWnM0RHpWMDRTTEJpOHk2YmlK?=
 =?utf-8?B?Vno5UEtrSUwrSXZZNWV0UlpRZm9raDlJclV0VGdxTmtQdlBFS1Z6MXk4TS96?=
 =?utf-8?B?d0N1TjFVZkU0Q1hlcHNFMVA0MXl1YmhMUWtsNkR0YVVFckN3YzRvVzMvbmNs?=
 =?utf-8?B?YlN6RlI0ckMxMVZRZmlyL28raVpOaURycDI1VEtrbnRmSWdHYkxEcWhzUzlW?=
 =?utf-8?B?RzBMZS8xMWlhSU0wRS9vTjVMMWtTbU9aTDYxT01XUnBQZU9TUkx4YUczU1VE?=
 =?utf-8?B?WGtEWVpDL2RNN3JMTzMzOTNIUHk3RXV5MFZwK21LMS9NaEhnWHVUL0V5cmNX?=
 =?utf-8?B?WDJzcmF1MXdVRlk2dXNIZWpabjlpeW5HUmVYTHpMN1llRjdzdHJjekZUZFNU?=
 =?utf-8?B?b3FlbUNOaGEwekdUd05NYS81NjQ1a3JFMWJHYng5NEJKMkVnOTNDWVA4ck44?=
 =?utf-8?B?WHFqeXNrZ3R2a0ZZVjgvVDNFSmZmKzIyazdjNzZsSjlZQUNKYmRFdm5ZbjJI?=
 =?utf-8?B?VlpnZit2V0gza2lYQTJKczl2c29xakZ2K0p6RElPcDdVZFduYVhIVmpWaXNX?=
 =?utf-8?B?Y09ndE5VZ3ViUm00Mk12ZlBhdnA3QzlMZjVSdWZVUmZlZjNCZ1UrREhyVklE?=
 =?utf-8?B?Zk9ucFpRbXJWK3hkTjJtV0RPLzVEQllaUUhYS0thd3EvUzlDS1lhazRPNDVk?=
 =?utf-8?B?c1NDWlNzbkducDg4SGpGVnVkTDU0TC93VmVKcDZONkt0bG9PVGxrYi9YZVpp?=
 =?utf-8?B?UUIxM0M2Q25pUWZXK0tDN2RwUmF2MXlHb1VTdnRBaEVmaVB0S25HS2d5YUlI?=
 =?utf-8?B?UnFnWmJSRStKSm9UVFM4M0xnMDBFTTRWWE55UWl2SXZRN2dlbGJvdnBNUEJw?=
 =?utf-8?B?MG0zYXpoczVIYXdNY1pTTURPSGdDUno3NzFTV0xTOTYzK0ZGeEZCdnFoZERP?=
 =?utf-8?B?Tyt3ZmFvS3FtOWRyZWc1UVlldkNWQUxRR2t2aGljVmxzKzI4ZDNaSTNDeW1W?=
 =?utf-8?B?WHFEQS82OHdQQnUyNnA3a21hSkZSMFZCbElwMEwxM0cxelJsVDY0bStjTEd0?=
 =?utf-8?B?d0k5OWZxZENobzBsZzI4UlBQZjB1RDFhZnorTUxwREJaWkNCQ1daaHF4ZGR0?=
 =?utf-8?B?TTRvaEN6RU51cHdjZjFTODRnTk5kdFhzaU9MUFR3S1VIdUxmSjJqNUV5ZEZX?=
 =?utf-8?B?S1JGcFN2dTVhY2ZjZ0VGU2V0SEVPOWhHNFBHMm1aTzdYL0lZdWx4ZHA5ZStV?=
 =?utf-8?B?MWxhNW43VnVyVTJVdjZndHNhSnJhTERxdWgxalUybDB6cUI0UGsrUHF5V0FP?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8FAA0309F5D7A4282D2DB6BAA568CBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2e805a-2ee3-4148-5588-08dde735b6e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 19:53:24.3848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sv57DQxM37fWowbfBy8Om12kZGq2YAegkCJcGQe5P6m/7MIlBQaqLTic0IGruB4hltZSSfte2qqyC4l/sKLmWR8D4mpcCavIPVgBdyZT6P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5128
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IA0KPiBEb24n
dCBleHBsaWNpdGx5IHBpbiBwYWdlcyB3aGVuIG1hcHBpbmcgcGFnZXMgaW50byB0aGUgUy1FUFQs
IGd1ZXN0X21lbWZkDQo+IGRvZXNuJ3Qgc3VwcG9ydCBwYWdlIG1pZ3JhdGlvbiBpbiBhbnkgY2Fw
YWNpdHksIGkuZS4gdGhlcmUgYXJlIG5vIG1pZ3JhdGUNCj4gY2FsbGJhY2tzIGJlY2F1c2UgZ3Vl
c3RfbWVtZmQgcGFnZXMgKmNhbid0KiBiZSBtaWdyYXRlZC4gIFNlZSB0aGUgV0FSTiBpbg0KPiBr
dm1fZ21lbV9taWdyYXRlX2ZvbGlvKCkuDQo+IA0KPiBFbGltaW5hdGluZyBURFgncyBleHBsaWNp
dCBwaW5uaW5nIHdpbGwgYWxzbyBlbmFibGUgZ3Vlc3RfbWVtZmQgdG8gc3VwcG9ydA0KPiBpbi1w
bGFjZSBjb252ZXJzaW9uIGJldHdlZW4gc2hhcmVkIGFuZCBwcml2YXRlIG1lbW9yeVsxXVsyXS4g
IEJlY2F1c2UgS1ZNDQo+IGNhbm5vdCBkaXN0aW5ndWlzaCBiZXR3ZWVuIHNwZWN1bGF0aXZlL3Ry
YW5zaWVudCByZWZjb3VudHMgYW5kIHRoZQ0KPiBpbnRlbnRpb25hbCByZWZjb3VudCBmb3IgVERY
IG9uIHByaXZhdGUgcGFnZXNbM10sIGZhaWxpbmcgdG8gcmVsZWFzZQ0KPiBwcml2YXRlIHBhZ2Ug
cmVmY291bnQgaW4gVERYIGNvdWxkIGNhdXNlIGd1ZXN0X21lbWZkIHRvIGluZGVmaW5pdGVseSB3
YWl0DQo+IG9uIGRlY3JlYXNpbmcgdGhlIHJlZmNvdW50IGZvciB0aGUgc3BsaXR0aW5nLg0KPiAN
Cj4gVW5kZXIgbm9ybWFsIGNvbmRpdGlvbnMsIG5vdCBob2xkaW5nIGFuIGV4dHJhIHBhZ2UgcmVm
Y291bnQgaW4gVERYIGlzIHNhZmUNCj4gYmVjYXVzZSBndWVzdF9tZW1mZCBlbnN1cmVzIHBhZ2Vz
IGFyZSByZXRhaW5lZCB1bnRpbCBpdHMgaW52YWxpZGF0aW9uDQo+IG5vdGlmaWNhdGlvbiB0byBL
Vk0gTU1VIGlzIGNvbXBsZXRlZC4gSG93ZXZlciwgaWYgdGhlcmUncmUgYnVncyBpbiBLVk0vVERY
DQo+IG1vZHVsZSwgbm90IGhvbGRpbmcgYW4gZXh0cmEgcmVmY291bnQgd2hlbiBhIHBhZ2UgaXMg
bWFwcGVkIGluIFMtRVBUIGNvdWxkDQo+IHJlc3VsdCBpbiBhIHBhZ2UgYmVpbmcgcmVsZWFzZWQg
ZnJvbSBndWVzdF9tZW1mZCB3aGlsZSBzdGlsbCBtYXBwZWQgaW4gdGhlDQo+IFMtRVBULiAgQnV0
LCBkb2luZyB3b3JrIHRvIG1ha2UgYSBmYXRhbCBlcnJvciBzbGlnaHRseSBsZXNzIGZhdGFsIGlz
IGEgbmV0DQo+IG5lZ2F0aXZlIHdoZW4gdGhhdCBleHRyYSB3b3JrIGFkZHMgY29tcGxleGl0eSBh
bmQgY29uZnVzaW9uLg0KPiANCj4gU2V2ZXJhbCBhcHByb2FjaGVzIHdlcmUgY29uc2lkZXJlZCB0
byBhZGRyZXNzIHRoZSByZWZjb3VudCBpc3N1ZSwgaW5jbHVkaW5nDQo+ICAgLSBBdHRlbXB0aW5n
IHRvIG1vZGlmeSB0aGUgS1ZNIHVubWFwIG9wZXJhdGlvbiB0byByZXR1cm4gYSBmYWlsdXJlLA0K
PiAgICAgd2hpY2ggd2FzIGRlZW1lZCB0b28gY29tcGxleCBhbmQgcG90ZW50aWFsbHkgaW5jb3Jy
ZWN0WzRdLg0KPiAgLSBJbmNyZWFzaW5nIHRoZSBmb2xpbyByZWZlcmVuY2UgY291bnQgb25seSB1
cG9uIFMtRVBUIHphcHBpbmcgZmFpbHVyZVs1XS4NCj4gIC0gVXNlIHBhZ2UgZmxhZ3Mgb3IgcGFn
ZV9leHQgdG8gaW5kaWNhdGUgYSBwYWdlIGlzIHN0aWxsIHVzZWQgYnkgVERYWzZdLA0KPiAgICB3
aGljaCBkb2VzIG5vdCB3b3JrIGZvciBIVk8gKEh1Z2VUTEIgVm1lbW1hcCBPcHRpbWl6YXRpb24p
Lg0KPiAgIC0gU2V0dGluZyBIV1BPSVNPTiBiaXQgb3IgbGV2ZXJhZ2luZyBmb2xpb19zZXRfaHVn
ZXRsYl9od3BvaXNvbigpWzddLg0KPiANCj4gRHVlIHRvIHRoZSBjb21wbGV4aXR5IG9yIGluYXBw
cm9wcmlhdGVuZXNzIG9mIHRoZXNlIGFwcHJvYWNoZXMsIGFuZCB0aGUNCj4gZmFjdCB0aGF0IFMt
RVBUIHphcHBpbmcgZmFpbHVyZSBpcyBjdXJyZW50bHkgb25seSBwb3NzaWJsZSB3aGVuIHRoZXJl
IGFyZQ0KPiBidWdzIGluIHRoZSBLVk0gb3IgVERYIG1vZHVsZSwgd2hpY2ggaXMgdmVyeSByYXJl
IGluIGEgcHJvZHVjdGlvbiBrZXJuZWwsDQo+IGEgc3RyYWlnaHRmb3J3YXJkIGFwcHJvYWNoIG9m
IHNpbXBseSBub3QgaG9sZGluZyB0aGUgcGFnZSByZWZlcmVuY2UgY291bnQNCj4gaW4gVERYIHdh
cyBjaG9zZW5bOF0uDQo+IA0KPiBXaGVuIFMtRVBUIHphcHBpbmcgZXJyb3JzIG9jY3VyLCBLVk1f
QlVHX09OKCkgaXMgaW52b2tlZCB0byBraWNrIG9mZiBhbGwNCj4gdkNQVXMgYW5kIG1hcmsgdGhl
IFZNIGFzIGRlYWQuIEFsdGhvdWdoIHRoZXJlIGlzIGEgcG90ZW50aWFsIHdpbmRvdyB0aGF0IGEN
Cj4gcHJpdmF0ZSBwYWdlIG1hcHBlZCBpbiB0aGUgUy1FUFQgY291bGQgYmUgcmVhbGxvY2F0ZWQg
YW5kIHVzZWQgb3V0c2lkZSB0aGUNCj4gVk0sIHRoZSBsb3VkIHdhcm5pbmcgZnJvbSBLVk1fQlVH
X09OKCkgc2hvdWxkIHByb3ZpZGUgc3VmZmljaWVudCBkZWJ1Zw0KPiBpbmZvcm1hdGlvbi4NCj4g
DQoNClllYSwgaW4gdGhlIGNhc2Ugb2YgYSBidWcsIHRoZXJlIGNvdWxkIGJlIGEgdXNlLWFmdGVy
LWZyZWUuIFRoaXMgbG9naWMgYXBwbGllcw0KdG8gYWxsIGNvZGUgdGhhdCBoYXMgYWxsb2NhdGlv
bnMgaW5jbHVkaW5nIHRoZSBlbnRpcmUgS1ZNIE1NVS4gQnV0IGluIHRoaXMgY2FzZSwNCndlIGNh
biBhY3R1YWxseSBjYXRjaCB0aGUgdXNlLWFmdGVyLWZyZWUgc2NlbmFyaW8gdW5kZXIgc2NydXRp
bnkgYW5kIG5vdCBoYXZlIGl0DQpoYXBwZW4gc2lsZW50bHksIHdoaWNoIGRvZXMgbm90IGFwcGx5
IHRvIGFsbCBjb2RlLiBCdXQgdGhlIHNwZWNpYWwgY2FzZSBoZXJlIGlzDQp0aGF0IHRoZSB1c2Ut
YWZ0ZXItZnJlZSBkZXBlbmRzIG9uIFREWCBtb2R1bGUgbG9naWMgd2hpY2ggaXMgbm90IHBhcnQg
b2YgdGhlDQprZXJuZWwuDQoNCllhbiwgY2FuIHlvdSBjbGFyaWZ5IHdoYXQgeW91IG1lYW4gYnkg
InRoZXJlIGNvdWxkIGJlIGEgc21hbGwgd2luZG93Ij8gSSdtDQp0aGlua2luZyB0aGlzIGlzIGEg
aHlwb3RoZXRpY2FsIHdpbmRvdyBhcm91bmQgdm1fZGVhZCByYWNlcz8gT3IgbW9yZSBjb25jcmV0
ZT8gSQ0KKmRvbid0KiB3YW50IHRvIHJlLW9wZW4gdGhlIGRlYmF0ZSBvbiB3aGV0aGVyIHRvIGdv
IHdpdGggdGhpcyBhcHByb2FjaCwgYnV0IEkNCnRoaW5rIHRoaXMgaXMgYSBnb29kIHRlYWNoaW5n
IGVkZ2UgY2FzZSB0byBzZXR0bGUgb24gaG93IHdlIHdhbnQgdG8gdHJlYXQNCnNpbWlsYXIgaXNz
dWVzLiBTbyBJIGp1c3Qgd2FudCB0byBtYWtlIHN1cmUgd2UgaGF2ZSB0aGUganVzdGlmaWNhdGlv
biByaWdodC4NCg0KPiAgVG8gYmUgcm9idXN0IGFnYWluc3QgYnVncywgdGhlIHVzZXIgY2FuIGVu
YWJsZSBwYW5pY19vbl93YXJuDQo+IGFzIG5vcm1hbC4NCj4gDQo+IExpbms6IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC9jb3Zlci4xNzQ3MjY0MTM4LmdpdC5hY2tlcmxleXRuZ0Bnb29nbGUu
Y29tIFsxXQ0KPiBMaW5rOiBodHRwczovL3lvdXR1LmJlL1VuQkthaGtBb240IFsyXQ0KPiBMaW5r
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvQ0FHdHBySF95cG9oRnk5VE9KOEVtbV9yb1Q0
WGJRVXRMS1pORmNNNkZyK2ZoVEZrRTBRQG1haWwuZ21haWwuY29tIFszXQ0KPiBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvYUVFRUpiVHpsbmNiUmFSQUB5emhhbzU2LWRlc2suc2gu
aW50ZWwuY29tIFs0XQ0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYUUlMkZx
OVZLa21hQ2N1d3BVQHl6aGFvNTYtZGVzay5zaC5pbnRlbC5jb20gWzVdDQo+IExpbms6IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hRmtlQnR1TkJOMVJyREFKQHl6aGFvNTYtZGVzay5zaC5p
bnRlbC5jb20gWzZdDQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9kaXF6eTB0
aWtyYW4uZnNmQGFja2VybGV5dG5nLWN0b3AuYy5nb29nbGVycy5jb20gWzddDQo+IExpbms6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC81M2VhNTIzOWY4ZWY5ZDhkZjlhZjU5MzY0NzI0M2Mx
MDQzNWZkMjE5LmNhbWVsQGludGVsLmNvbSBbOF0NCj4gU3VnZ2VzdGVkLWJ5OiBWaXNoYWwgQW5u
YXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IFN1Z2dlc3RlZC1ieTogQWNrZXJsZXkg
VG5nIDxhY2tlcmxleXRuZ0Bnb29nbGUuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IFJpY2sgRWRnZWNv
bWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpo
YW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogSXJhIFdlaW55IDxpcmEu
d2VpbnlAaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0KPiBbc2VhbjogZXh0cmFjdCBvdXQgb2YgaHVnZXBhZ2Ugc2VyaWVzLCBtYXNzYWdl
IGNoYW5nZWxvZyBhY2NvcmRpbmdseV0NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KDQpEaXNjdXNzaW9uIGFzaWRlLCBSZXZp
ZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KDQo=

