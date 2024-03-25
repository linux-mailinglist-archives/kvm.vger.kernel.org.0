Return-Path: <kvm+bounces-12636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C38988B64F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 01:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 226B6B286ED
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA4384FC9;
	Mon, 25 Mar 2024 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4PvF57T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AD383CD2;
	Mon, 25 Mar 2024 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711410125; cv=fail; b=iZAdjmfYWaxABbTOi0gMgSpyPe9+wsLkzG8FuffTiGArIyuH3ypRYKIZRd1lSPLFoOvgM/pFmYPemoKFBpw71hstR6BBc03LotAWa/lyaZPfCiXws1KVbEsKxb8HI1Xt2vdEiL5pD7TqRaSsWoEvAEzkmLB2nfINbOEETr36u2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711410125; c=relaxed/simple;
	bh=caYb9eT0MnhNanoMfR9C6Nz4yFyoINZf7MnM0Fv7CZg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OhzgJ8qEutbq/MwE864SfFol/Y0zKUbNmU1pG4+js+vI52LHF/7kyVYSDJF2xXe9tgTNA+UshWzK5GuqID7qQcMemdYLzdel108SJK5HxJqemaM7a/CxDi4ASmf+iSkj3u+oC1M6E8SNX19ZJ9PMLqkIGswGUCV5QybhoWMLNwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4PvF57T; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711410123; x=1742946123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=caYb9eT0MnhNanoMfR9C6Nz4yFyoINZf7MnM0Fv7CZg=;
  b=S4PvF57TMLqSLHP1AMfUXfooYqqPECc58YTmhoqG5dzF6VOLgrvKXSQX
   5bHaeDvyWsDh2Wu/ZwB59AQdUqnSSN4kzYpNVpBlBW7oVlyQuPG9ErqY0
   27CvLWClhEFnga6ivI3AFS+PaAEJsl6r4IEPF85Qw/vGGNCjLDfSQoX9X
   K1i8csO5T9KnPfvCpJRKZPNfUD3IFBAlsNxIM0JFdzEgXOpmzGJqfGYCH
   DBwEMiK6hxk+PU0pE0XCopRWPp5KJFuo7LmL2x4XGOu8B4fj4XON4WQIp
   PVNZN2+GumhvWRbqREud7SUl4zK4PsA+wKsKFAPVqvyI/h/A2FczNzfy5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6303498"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6303498"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:42:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20247899"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 16:42:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 16:41:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 16:41:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 16:41:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 16:41:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuPAu0N6ixMzUZRRjRIMle5C+A++lSBMKeaRu5SpLyZcvoU1mKzr9IMyyWtlinreNweezP7TJZwdVKT/vVh3Gzf2Dmp+rRinHpvwkTSqgkRx8+3bD6MsROuX7z8g2TDMSy0L49fQzdjLhsOVJp2ao12rRMuCgMvpWq68hYD8zZWNiZDoKDe96z+bVR1zSAiu1t3fGucaqEVZ6WysFXokvE1IGZsUVNWVfkeWH+bf2PSTvlhKuzb2Fh8Tt5aDX0ZfBwKY/RbnZPaEJAaUeQZ/PMtK0x87DXOqG2KYC7w80nuH5hyi+5n4IU/Y/eYcVJTjOAycR10Miny4sld72WGfGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caYb9eT0MnhNanoMfR9C6Nz4yFyoINZf7MnM0Fv7CZg=;
 b=ZSHDUvo/EecuKzf5UUYZyxtnhtsLPyf0mh76t0GTbEZr0ozrzvomQnlTYc7oJBXIYfW4JPjD6sKsdyawYbClPBcIvMvtBNYMCBcx8kmXQpKgVjniZ9JTVkb+tq8YX1G5qklDTtXjqHi53SJWsRZKahg226PzmAK5Hdh9DdBZBvJPmc03IPWdNS//fONe35alDYjdcLU+4yJbo8V7YorMzyRRF+C5fy8++LFsi+0cdMD5ADm1I7kBG+BjDP47C/h9WKrv4mGfAPQYAeG0s3sFirk2EIUvNDk759iX03STE6IykcrDfGZFIwrClKN6kCrB592hxtkbWT1WbgJ2l0A9hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5895.namprd11.prod.outlook.com (2603:10b6:a03:42b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 23:41:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 23:41:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Thread-Topic: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Thread-Index: AQHadnqai1juAAI0fkueX9MsZ8q4G7FJLxSA
Date: Mon, 25 Mar 2024 23:41:56 +0000
Message-ID: <3c51ec38e523db291ecc914805e0a51208e9ca9f.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5895:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kem8pxL8b/cjeo0IAVz7BM0zJoVHtxmiZykmcHsFblMNQI9cpJJX3J2zjbf/rNWxtlebTF922u80I2rA/iLyH+j9vvkeu8oC52qcBWG8cd7nNBOHhTEPRnZ0wwAAuquX8QBtku2G92qRTPgIIulPzzbGE7QDd//ivYHtbBDkw2OxXMAjzMa4MsgF+m+Tc48ay9br5jBEojP1u5feXQraWaEvCL+Ox/pBv3/F7SEwtAh5QfafVRBU7MjQpBHAxUhRfrHVWixY0Ev5tsojEO4fsNeajHPKlekUPWPqmWKya2+DuA8BWOybnsxhchGS/CtSo9FY06QuVCX6ivTZl80f3Q+d3dCkq/sI8dzE35NjrM4dlGgkVbG37iHUky60/8ceJUPby0xenyQcU/NGAf6Y3VSoJCDXv84Cee9D2aR+4HyBAqRtqx3ywIgSi0wGVO9iXPiO2vJvjFGnEurzSkD7+7Y+FVss3ynTrFqIvtPXDn9Yi8WTk9cIevZU8HkSmrXm85BUUPtjho8NymwDhMAFNY/+ab7BIJkyRkqGTQoX1BHfm7aYV/wFuepSz/+PcsHVqtqn2lwZQwyiV6ktzf1mM0k7Gdl2XogSWWUzDNYVyk1Hg9RC2vtCnOJ95gFPGyP5GHcM6Zzzpg3iiJCa/gV9gcRp/2TR+nOxaScHjBYFc4U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0lxYXh3bzRJQnV6a2NWZGc2eHdPSytrVHJpUUtVNUJUOWFnVm5Gd1R3ZFN5?=
 =?utf-8?B?RlQzWWUrSWZUM1phM2hvMkw2MFZpaklRNlNBenZjRXFpY00rcWlBeEI2Vjhs?=
 =?utf-8?B?bjVhMG01eXZhWHJ4Ri81OUZpVmlHTzZFWG5QMzdZQVZJdk9GdkJLQjllUjRX?=
 =?utf-8?B?dm93V1BPQ1Q0NllnR0VSVVNYY28rRi9xUUhPa2IzbEdYQUt5UlNjZWMvejlE?=
 =?utf-8?B?RlpBTUZhRTh0SFJtV0l2aFhkVTZXTU5aUDZ0MlUreUpibHRZdVMrK1B1RlBy?=
 =?utf-8?B?N0puWXlqRmE2TVVaQXlxRGhLbjl2Yk9ibXo3UHYxZUc3bkFUb0F5OTFPOXlT?=
 =?utf-8?B?djY1RzhIbytqdExpUEZWOWNReEZQZVQ2T0J3UnZrbmtWdy9iREphc1diODBB?=
 =?utf-8?B?REgxZHJuMWdzM0hST3RqUHM2VHJCc1VWSkwrSWU1TXdUTzgxV2ZHRE9kbXpU?=
 =?utf-8?B?NTZMQ1ZxdCtqbGpLOFp0clU5M0lZZUtmMHp4ZG1CNUN3NXBFeFMxOU83WUhu?=
 =?utf-8?B?R0lFTitsSmF1L1pteDF1dUZDcVNWeXhEVG1UbFhnV002c0VlVmpIS3dmMHVP?=
 =?utf-8?B?VGt6UkhYWDA4RktJSzNIUEIreWtHeEhPd3BveTY4dEhQdXU3WUh5cU5VaERx?=
 =?utf-8?B?TitTY3ZkK3pvMmdiMHJVb1lKSVJacGFlRE54cEpVU3Q1dFBUaDNJbitZRnQy?=
 =?utf-8?B?WCt6M1FIRUN1cGxGMFNOTWZCdlA4aE5oMFAweUJDdjFwUUtGa3RzYlFoNFdW?=
 =?utf-8?B?anp0b0dhckxyZlh6M20za0RJNEIxQU5ua29rcDBKdzl3ZjB5dVZCRUNjM0VN?=
 =?utf-8?B?MWNiR0tsQzdzNVU2d3NKcldDNEJadlpkUExQeFI4NzFRLzN5TSsyNzNENGdx?=
 =?utf-8?B?bjN5K3AxWnQyWmFPdHhRcDZremE3L29GT09ndk15eHRwaTBVcWxLV1FlUzBM?=
 =?utf-8?B?eUZ2L0JhYjV2NTQ3bVlCVEpYTmNRLzdTL2dkcXp3VGcrSDlqUC8wdHp1TTFD?=
 =?utf-8?B?Q1dWS1BzN2RCbVE1ZlREUHNRbGZYT3JnMnVOazlXd08zTkQ4Tjc3NEhUU2Nu?=
 =?utf-8?B?OU9TQWl3Y0IvUXk3ZHhWVmtwR3VvTEIvSkRQb2JDRnBCR2Y3NUp4Mk5hcEdY?=
 =?utf-8?B?YlZxWmcybjB4RHRJUWRSQzdFVHpIUE0wU2VEbGN1blB5cDA1em9oOEMrRjVO?=
 =?utf-8?B?RUI4ZTBnSFhjRjB5aUREM25vUmt6SEY2Zi9zTEtQZmoxWVA1K3JPVWtLS0Vt?=
 =?utf-8?B?cWppUzdPNjZNdkU4Y3o1a3JNb3BGNUEvaG90T1U2UldCQjNEVnY2Wm5GRkQy?=
 =?utf-8?B?WjZ2TVRXdVNSMGxPVGtET0U1cmJ2MkZYcEx2SFRkdWpXS2VucHBFTE9MS1Bo?=
 =?utf-8?B?cmxyTElKUk93WjEyY0NWTEthenJUN3lVUm4rb2F2OE8zQmpheEprVjlPS1Mw?=
 =?utf-8?B?SVdTQUJWd2k1aGFuZEpkOXpqSWJrZk5NMzYzek5EWnAvZUYxU0k3bXJyOHJs?=
 =?utf-8?B?TkZJWkdPNXpBVm1yWHVqR3lPSTZoWCtkVzFUa0E2YVo2Lzc3SU9JUFFtRE55?=
 =?utf-8?B?Z3BVWUhDeERqS005VlNGMU5LbEVKVUR5bG12NTNZZTVzL0d4R3hxVVBkbTZF?=
 =?utf-8?B?N082bEhqYlJsVmlkK1hya0NNRjV0R1ZNODRGMUJncXl2bERMR3JVcDdtNEg1?=
 =?utf-8?B?UHJWYnArZm93Yk52OXRXcUlKN292WmozcENocnQxcUJoQnozSHdqdDFNTHAr?=
 =?utf-8?B?K1RuWnlnb0pqcVI2MGl4Q0IvR0pnTGRabUw2a3VibGtsQkQwMWExdktyZFBO?=
 =?utf-8?B?YnAxVGFSMkYvQ2dPWUpwV1pjQ21talc4YzQyVkt2Zy9qdFJpL0FPeDUrWkpC?=
 =?utf-8?B?U1h0aHJNZnBIQThXRDh3cUpsT0dzdVMyejh1dXRyUWhFQUtyTWx1eGFnR3lq?=
 =?utf-8?B?cWZyYS94aWgwS25wMXh6NDVEZDJnb1BEZnFXbTRWSi9adFdseEhSTkRxNEdr?=
 =?utf-8?B?M2dTWTJvVHVlV3Z0Y0x4VDYvd0FwekZHVkRiMHB3cDhWR3VRYjZtRHhFSHpx?=
 =?utf-8?B?eXUrL0V2WU5lNzVHcE83QitGS1J5T3MrOHZydFQrLzh1YnhmZDNqd1cvMFRv?=
 =?utf-8?B?OHdYVnBySm40RmdoRGZzL2tkWk5uOTFzUDRXeXo4a0ZmWDZBMjFRUXZPMWtr?=
 =?utf-8?Q?moabHoMfPJa553ItxsSIb18=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDD2FBA0BFF225409D48D56FA2C40AB2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004d64a1-7b9a-45eb-83d2-08dc4d25282e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 23:41:56.2710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9llWfSUpVR62S8rQSSBanNFojZT+dWYxT2oPfGAar9LmHf5bnlZ8ehfPjoyygSipr+xb0ENuQSU1d+8S0/BztuJfnvk1sCNA4RM4ORqzdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5895
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IA0KPiBU
T0RPOiBEcm9wIHRoaXMgcGF0Y2ggb25jZSB0aGUgY29tbW9uIHBhdGNoIGlzIG1lcmdlZC4NCg0K
V2hhdCBpcyB0aGlzIFRPRE8gdGFsa2luZyBhYm91dD8NCg0KPiANCj4gV2hlbiBtZW1vcnkgc2xv
dCBpc24ndCBmb3VuZCBmb3Iga3ZtIHBhZ2UgZmF1bHQsIGhhbmRsZSBpdCBhcyBNTUlPLg0KPiAN
Cj4gVGhlIGd1ZXN0IG9mIFREWF9WTSwgU05QX1ZNLCBvciBTV19QUk9URUNURURfVk0gZG9uJ3Qg
bmVjZXNzYXJpbHkgY29udmVydA0KPiB0aGUgdmlydHVhbCBNTUlPIHJhbmdlIHRvIHNoYXJlZCBi
ZWZvcmUgYWNjZXNzaW5nIGl0LsKgIFdoZW4gdGhlIGd1ZXN0IHRyaWVzDQo+IHRvIGFjY2VzcyB0
aGUgdmlydHVhbCBkZXZpY2UncyBNTUlPIHdpdGhvdXQgYW55IHByaXZhdGUvc2hhcmVkIGNvbnZl
cnNpb24sDQo+IEFuIE5QVCBmYXVsdCBvciBFUFQgdmlvbGF0aW9uIGlzIHJhaXNlZCBmaXJzdCB0
byBmaW5kIHByaXZhdGUtc2hhcmVkDQo+IG1pc21hdGNoLsKgIERvbid0IHJhaXNlIEtWTV9FWElU
X01FTU9SWV9GQVVMVCwgZmFsbCBiYWNrIHRvIEtWTV9QRk5fTk9MU0xPVC4NCg0KSWYgdGhpcyBp
cyBnZW5lcmFsIEtWTV9YODZfU1dfUFJPVEVDVEVEX1ZNIGJlaGF2aW9yLCBjYW4gd2UgcHVsbCBp
dCBvdXQgb2YgdGhlIFREWCBzZXJpZXM/DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2Fv
IDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxp
c2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0KDQo=

