Return-Path: <kvm+bounces-7400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B37841844
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3CED1C22776
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 01:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA5E3611F;
	Tue, 30 Jan 2024 01:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLEnBP+y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3236114;
	Tue, 30 Jan 2024 01:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706578180; cv=fail; b=gRQ16JscT8pU+gmli6rlzR78fqQKpZyORadpalPUIpdMenLmOje71M/3t7sV6Gm+vEIZMjnHhGG67p5RKBx4SgrfmbW26saW7BgYiYM3OzYnTJDRNcJ3iXCIlGM8TAS11gzEPLBg+fdFnirzDpJeZYiY8nGJqP40Ok+j7DLJYmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706578180; c=relaxed/simple;
	bh=GD4XRL9MGUiNVbIo02y+3gUW3nhWg3ddIpouVvUhqrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nHsEXjEupw/7uUrUAQYyQfpMWdqjHQ/S2bot2FLUkvWOOxMbG/QrykQ2XbXJ6WbMrwK1258WkxiuxZemFh6qTLaCodxoLwchnpRSyAeKErf1Vah3SoTkaDnzgMk16dFo2BAzZKvxMl60iPWcpGsDWRWNSwmUzsUJQ3Z62W91rfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLEnBP+y; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706578178; x=1738114178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GD4XRL9MGUiNVbIo02y+3gUW3nhWg3ddIpouVvUhqrY=;
  b=bLEnBP+yeEU9zjZPPc815pIsj2s7DVi0+frRg737KO6l+jQTTsaI5yjj
   ZqqFax5v3T4ppGHW56NQRcp45bZmmSXJxSKVG5oRLSPhWUzA8147IxPXG
   d02mRH3sjWv2Zk12RFN56yMsCUm93ndUJePmzHAGgfmJBR8iqIF/vTJXO
   fIh4qpD1VMB5kGf0SlXrtBQT4SCzC2wXdiqjIvXYBylREdVaRRKK21Xe2
   fswgHFMI8KLj5WBaLKiOj0amhl5CJnbUrtXpRCXRAv7WoH/8Gucg8hpAp
   UWopBkHbi/sPnxpkFj4g5cypiPRobwKoN8l/zBmragjUnRZT0LwGbVnOA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="10527050"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="10527050"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 17:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="29723626"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jan 2024 17:29:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Jan 2024 17:29:35 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8SvF4+z7DSU5LRDDYczdKz7kYDTNfOZ+Ftwb7Uh6WY/lN12MVOV5VVisRS+2yrzOdppME+VaIVD3o65eMZNbe0ZiyXDGmmlqtLjnHL3xsvA4VtfaFI5/Ah/boJXuk1loA+b60+tMb42EAwTmODsdgq+De9L80scfQ3j1p7IQ7WIw21TlzFnb0eFv7bfTafOPx5kS+Vg3ZEXwClcSvgJ09rGmRGpXvIku8Qs/tzwRDxqC+YDYGb2fQDapmz3mSPn79vUjRLAeZOEBSVEfIVo1K3XjsYBmwPxsJs2wFqhSRzIxsWaychoU3b0M4BIUW4jCMiNo9/k7lh5RKNIgOgznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GD4XRL9MGUiNVbIo02y+3gUW3nhWg3ddIpouVvUhqrY=;
 b=m8+PI72K4NbJ4gK1X0Nucd+zVt4lN6fWkmcycBHquoq4KHy6eom4b2gmY+gUZv2VL2SAyM/Y9lqS7i+v6Vno+vf9UNj4CuIP6C3sj1ltW2LFwM5lNDe7fm0Z7+Lw0y4Ah1rcY+9x/zVi/lgG6Zq/BZxiurpAEWTDgLvPGimU083ZGuyErqpwVC/h+VJT+z9RawqLVj1chtih3102i0FDPbQX7KzFUiQyJsyDwZ4PCDEMS81gjn5EEVayfqqCGJ13Lk6ehG8ju1nMTNYlLJl6EDid5mIZd/K1qy9ulIZcm11WsgnTh75roOXXTZi0OEyGkZHahCzeh0/t1h+Utq/YGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7894.namprd11.prod.outlook.com (2603:10b6:610:12c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 01:29:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409%7]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 01:29:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v9 01/27] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
Thread-Topic: [PATCH v9 01/27] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
Thread-Index: AQHaTm7+ZRu25JLtD0WU2RaxQCOTtbDxmq4A
Date: Tue, 30 Jan 2024 01:29:33 +0000
Message-ID: <77ccb09bd946fd27f17f530ed8fb4484afa46a00.camel@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
	 <20240124024200.102792-2-weijiang.yang@intel.com>
In-Reply-To: <20240124024200.102792-2-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7894:EE_
x-ms-office365-filtering-correlation-id: a84cf52c-3554-4eab-530f-08dc2132e9a6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ga8dpeDbo6RgihD+Zd/gHoTTZLsHenvze7HHIH13mrnzRarVeMQEgAPXpgnzN0nO06O5AYlr18CWOwBOowkeCgGhQ589qpKj8eBBERPoPADYs6c/KtKxkZDmLTuEja144vDf2LVOpZ9oa4zribFa3W1sPhH9Zp9lcXXzf4OrjPA/wNoPdHqNXpCxRbD+Uvfd9w/CNSLQrOl0lMEOiemF9uEojXEdUaftRy0zETV862yAjUeuRygU+HZ3d3CY8sGkPsmF0A1flqsdb5E9wYPgU9vKD6sy8HblV4Pd2VSPN2di+hhl/+OzYnqi9T9hOIH8eT24S+8tdAMnTYXGju7LuVGsCoBIm4wloJF/0kB0cyjLsdzE6HOMxKiS+D9JKdXKo9eLWRZ9EMVYk7/PqrIQMej5FJK/EgoMkzIswnCzwJPkqRI6PHwkIkI6Gyo5MHQvtGL+95cmRiPQISCz93mBX3MAFVGcdgXyCuMjnSDFjS7gYmpaX2pl4tbXpsfplvvY55RLvx5KrE5YNKLO1lBpt1ITNyFbVOF9s3xKSnzktSG6pT9JtnimSbMRQXVmiXZUkKCo2WANK6zaFlyBkSUwMNQQtxjsAf5xAY8n5qGJsh+/txWELs15D5bY7TDYGWu6Mirmga5mBQAZ7ofqzVgRDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(6506007)(26005)(2616005)(6512007)(71200400001)(5660300002)(4744005)(122000001)(2906002)(41300700001)(54906003)(66946007)(4326008)(478600001)(64756008)(316002)(66446008)(110136005)(921011)(8676002)(66476007)(8936002)(66556008)(6486002)(76116006)(82960400001)(86362001)(38100700002)(36756003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3YrNUZBUDRXMXdHTVJnOS94MHE5ZVN2N2NDODljbnQzUTI2dlZ6eDhGRGMr?=
 =?utf-8?B?UnhtNVk3MlBwV1B5SEY4bWFWeVlYZUcrLzhEWmJXWWFkaTd3Y0FuMUNPb1RH?=
 =?utf-8?B?RmNYWEYrbGJJZlUxTDY1WUNTVFl5dVI1cWlveDNBejdRQ3RIYitUejJoR0px?=
 =?utf-8?B?M1VUL1U3WU4xODNJSHVJbW9KbVpDL2hwcHZYaG9JUkxONU9aWS84eGJ1REY2?=
 =?utf-8?B?Y0pWYlQyL1BWZmdka2VFNGo4S1pRV2NoaUNLSk5JRTNkY0N1ekFVMEJ5cXRH?=
 =?utf-8?B?ZHRhejhQK2pSRWNSeVBVZ3dhZXFkb2FxNUpBbVVvWGkvVnhmb2p6cnl2VWo4?=
 =?utf-8?B?WmUrNjZ5Q0htemhCS1p3VHhrUzVYZytqYmpvQXVHNlNZbml6WDdMa1ZvMnlu?=
 =?utf-8?B?UFQyQ0dnZThRYnRoZVNteWtjVXhQb1ZGQkhoWGF2UG1WcmFlNDRGMlNYcFJE?=
 =?utf-8?B?OU5XTHp6T3A2QjZtQ0VwSmJQVG1Ra28wVUtyRkdjLzJZYjhrOWJWMmpTengr?=
 =?utf-8?B?SDdrK3JaU1g1QjEvR0J0L1RYamIrdHJrd01iTnErM0FzSzhwUmd4akV1eXJF?=
 =?utf-8?B?VmFvZ3BZK1laM2g5NnJKZWEzZ0E0bkNPdmtHMkc4bk1uOUZabERaNytHaGlV?=
 =?utf-8?B?Z2VoWTU5akNWZ1B4VjBueTlpYkxFajRYS1dCQWJhV3dlQmhYRmNFYVZoK2lB?=
 =?utf-8?B?WkdOOFAxbTVkZWF1MzVkZkkycUFFbSt4bWdqZHdTNlVCcTE4a0p3S3RVUXk2?=
 =?utf-8?B?b29qc2Zzc0FlRDFiVlFMdmdBWUpwakZ1c3pxdWM1dlR6K1g0U0p2bVNjTTR4?=
 =?utf-8?B?Yll1Z1k5QVd4NWhrK3ppQlhkei9uRjJLMFZKWk5BY0ppandzWXA0RWxVY3ZG?=
 =?utf-8?B?YUM1a3lpTGhPRGM5T3NEUTdEOUVmcnRTRnUwczk2NjhPL2d6S0tucmJoNG1j?=
 =?utf-8?B?Ri9oSU1ESmJTbTlid2FXU3BFT0lUaEh5NDJWN2dXbGtzSHBUMlRJa0pBeHZx?=
 =?utf-8?B?bG54aWJMcFpSWGNsblo2OE5yd2ZFRmRtSEZtTnlzOW1TN0lqWm9CMHZ4cCt1?=
 =?utf-8?B?bFZwc2xjRERrQmlrdTZySHFxMzVPNUU1M3pHdXJKVFhxMXloWXQzVGpSN0Y1?=
 =?utf-8?B?aXRjc1p4UnVQR0ZWNFZlR0ZaeTJlWk80WUNTL01Tdm9GUTJyUXI5UzJId1Iw?=
 =?utf-8?B?WitwRUdoTUxXZzRVN1g5UVJJbXBwazZVcERMdTJSem5zOStVY0U3MUwxN1lj?=
 =?utf-8?B?WUVoTXFjMm9rL1VzWTF3a05kWHQ1Nk1YazJqMkRraDlMTmNtMWtuem9FVGRR?=
 =?utf-8?B?MFVuYys4cEFoVzBzdW1rWkVOUjlsc1g1Z0pVcE0yUnZwbUVCaHVmcXZUZmta?=
 =?utf-8?B?eWQ1TG1nUTRTMWsxdFRjM2RuWnZhKzNTUXFYNjZ4aXhHeWxJWk5XdFJ1Q0Zx?=
 =?utf-8?B?MVZIalNHVkYrektGVDg1UmFnOVJab0dQVGZUdmczRUhiVk01RmZ0aFJYV1J1?=
 =?utf-8?B?TnpST1NYbDF2R0tUTUs1L2RhUllrcU42V25ZOERCamJKdkE2ZjFiai9tL2U1?=
 =?utf-8?B?Wms5SE1rc2pyaEl6RGFjZHJ3Kzk1V0FYc0YwSDFPeHFNVzJEVm5CU3RyQ1Z4?=
 =?utf-8?B?TkcwZVhBMmxGMUtNZS91dFFncHBBWVp0N0lRZHNhK01mRXVabytpeUN6b2xQ?=
 =?utf-8?B?UXhBRUZkbm1IZXdyRnRtejIxeDh1ZW5NYUlnakJVZURQRURMamkybE8ybkcw?=
 =?utf-8?B?U0kwMW5uSytSVTlmeXk5Y1hkNkNYRmo2VUJJK3p1aG9vNWU5NzFzY0lPTThN?=
 =?utf-8?B?ak4wcWtUNEdEa0FCWGlGaTNEWC92WHR5VWlrbjZIZzMxdXZiTXZsL1pMdkhz?=
 =?utf-8?B?ZGVKQjRjaVVHclkyd2Y0VndySnRPRVZRemplREFPdmFRYTJhLy9Yd0NhSjNy?=
 =?utf-8?B?VjV2NkdiaWhkUHdZekdQbXVjejc4ektqMm5lTW9RZmdTNHZkMTFBVXo2TWZG?=
 =?utf-8?B?bHIrSzdtUHhWVDBZOHBJbjl5ZWRRektLODY0WVM5bkxqL1h3QXVDQWMxK0JU?=
 =?utf-8?B?WkUrdFM4M2s2TnlVdmkxY0lsY0JmNDhOaTR0S3V5UjhFMVhWekxTRDYyOXBV?=
 =?utf-8?B?RzRDZ0lwMVhtWnhXUnpnT3dqdDFwa3hEU0ZEK0NUUDh3N2xPdWFkVXA1RG9v?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D80AF0B06C79AE498013D3CBDD99C5CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84cf52c-3554-4eab-530f-08dc2132e9a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2024 01:29:33.1486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBwkfuu6OY1J9/ncp0/fmAlss78kMk11CkQItsPg0YCF9IbmTN8Oq9uQWOrarkmkBdTyzMIyG4kxfASIxgzpejD7PGT6wqYMmQlMU4dkags=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7894
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAxLTIzIGF0IDE4OjQxIC0wODAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKgwqDCoMKgwqAgKiBDYWxjdWxhdGUgdGhlIHJl
c3VsdGluZyBrZXJuZWwgc3RhdGUgc2l6ZS7CoCBOb3RlLA0KPiBAcGVybWl0dGVkIGFsc28NCj4g
K8KgwqDCoMKgwqDCoMKgICogY29udGFpbnMgc3VwZXJ2aXNvciB4ZmVhdHVyZXMgZXZlbiB0aG91
Z2ggc3VwZXJ2aXNvciBhcmUNCj4gYWx3YXlzDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHBlcm1pdHRl
ZCBmb3Iga2VybmVsIGFuZCBndWVzdCBGUFVzLCBhbmQgbmV2ZXIgcGVybWl0dGVkDQo+IGZvciB1
c2VyDQo+ICvCoMKgwqDCoMKgwqDCoCAqIEZQVXMuDQo+ICvCoMKgwqDCoMKgwqDCoCAqLw0KDQpJ
IHN0aWxsIGZpbmQgdGhpcyB2ZXJiaWFnZSBjb25mdXNpbmcsIGJ1dCBtYXliZSBpdCdzIGp1c3Qg
bWUuDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRl
bC5jb20+DQo=

