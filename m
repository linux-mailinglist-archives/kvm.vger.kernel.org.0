Return-Path: <kvm+bounces-30168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C019B797F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B295B23739
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 11:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE2619ABBB;
	Thu, 31 Oct 2024 11:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2gu+7EC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D56D1991BA;
	Thu, 31 Oct 2024 11:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730373437; cv=fail; b=OWNF7uxMEMjVZGUPBi2wpdzSXrJwseWvRSmw+ZlcdfCfgIZnjOPb9PSYhSQ/cAhkYjEmlZQtjv2LPCFOpyi4I5e3Mp9SZH6EfJE/lMJEdSvK5GI0V5zimO68ziiOVRhqFOz9Htm43JMNSCNfO59A76Ef8iYDz5rfOrUY0sUzns4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730373437; c=relaxed/simple;
	bh=BAElmxMAykTUVVNx6qLBEwkskcDbm73hwLTnLr5+noc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kz7wJY2co7F/PPjI1y7YT22fwT+Xya5HXG6QpiZMtt2NmZlymBD8gn2kynREr4uKE14z/ducDxUawi1qBbfT2RscbOiHzcuD6UQozWOEIVbYXskdt4t643mTzUrWiyX3y2VxdNqJBEANSuoNzE0i+ZI+JXNh4N7MYJ0tdKX0Ysg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2gu+7EC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730373435; x=1761909435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BAElmxMAykTUVVNx6qLBEwkskcDbm73hwLTnLr5+noc=;
  b=e2gu+7EC3BvXbNbsO8UByp1lz2MHa7ldrlbfW+tlEQZlH4ARfLdWZrIA
   81054ZRoQLChEQ87Wwk2qQvTfjXKQCp40boSKdBw8rlrD8jRzdKJT42cE
   floRLoxWgVofiu2S5TQjX2Ora+l+j6doApoaJnQ5hkJn/f3OuFl+u8mlc
   Pw7x0NfWkC92iUMCcFsI2RB3P+pTdfvVBrYMVvYY4AOoRe0OnLx/SZmqP
   7DZ8LnJa7KMScZfcz/GCJ9Z7u+xKO0SeIDmlJmJoMToU5aWoxgepqA/xq
   Nq+A6kvzIX0heq7de3HoKnDMDAqgy1vjWuyoZXI2Heg9dgB3qNQ/NWAXy
   A==;
X-CSE-ConnectionGUID: sYJQIijfSIOP7QglCiE36g==
X-CSE-MsgGUID: DwmzPZWhSeaE2b9e1MpLVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="29999149"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="29999149"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 04:17:15 -0700
X-CSE-ConnectionGUID: oExRjrPCTq+GNOTF1zoE/Q==
X-CSE-MsgGUID: LG5DjzZzSY+7a7WOimhuww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="87386525"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 04:17:15 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 04:17:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 04:17:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 04:17:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=esi5YUWVwmiOn6vJDhyP9JBgGiXVCQT6xi/sRzuBz36qpwj9kQBqP1WS0uDZAnTiAG+gh8kbpfWKX1gW2NTxQkUJoihwBblRE+XOzdq60VL6R/FM74MHLruF2zbVWBFdqEHgsg5TvrB1Cq0Ofk+BC1pHTLamMUfMMfcIOAhSVUI1vN1GjT6VqMq5WuFntZWedfnvlvNqSZ/8AAFB1fCqZs/7nyTjx7D2sXnYD4yjYTz1bWE287R1AsH2oXUb9y+sofxhGIaM88GBOMakBcpA/P/Y1h1YzUdjM42k/wGxBn+AGnbFowkyLB3eU6gcy3fMwvz0VQvqE/FoWc7RzLxF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAElmxMAykTUVVNx6qLBEwkskcDbm73hwLTnLr5+noc=;
 b=f2EA1GKDsYgSwtqqPgaTtP2FMYGNpLw53bplvC5qWwNbSzX4g1yzLpnGi/eL+SI1M4qosAlDYTbc4fEO54JVSAXTa9w1NfIROJ5hPoZ9LdLo5iYeQvRZcdls4LvfbhKPMESKoIQB0SOIPLuiLl5qO4PU2qhMsAYrTi50vmJoemXYyTbhvpRlGEAm4kG3BNbvIWJom2933yFuQbAy2DmkQnY/9jqM/7xdZutrMr77kIkmYU9O2UgBN+WyISxlham6QuYihuuzNAAKMgSZ9NKVmtNUubdqFBan/dzuR9A/sMn97HVBQvRrXxqE/I2it1GP2rDWKQ/JLfX/bYXXr2cfEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Thu, 31 Oct
 2024 11:17:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 11:17:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbKTw/9pTudzVvXkeM2HJfNrr8zbKfa8kAgAFOlYA=
Date: Thu, 31 Oct 2024 11:17:10 +0000
Message-ID: <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
	 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
	 <ZyJOiPQnBz31qLZ7@google.com>
In-Reply-To: <ZyJOiPQnBz31qLZ7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB5964:EE_
x-ms-office365-filtering-correlation-id: d36f5942-5502-4462-9fed-08dcf99d904b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3hYR0x0OXBaTjlIOEZrSzlPQm1xVy9qN2htdjhCc2xkSlRjZFNWbUhqam1T?=
 =?utf-8?B?ZnpMRjVvVzExa3pQTkZsNXYxZ01mOEt2YnRhTFJIaHJWYXRaOHdrM0V3WFJS?=
 =?utf-8?B?OHUwcktPemxMM1Q2RkR4RkxuZFF5d3N1VWwyOGV2UUNVQUJDQStXbzdGWlF3?=
 =?utf-8?B?eHNlRTcxTkxOQlRJbzB1a1laTDdLL21TZk1vRWVmMzN1TVRvSS9BWWlwYzFQ?=
 =?utf-8?B?aWIvSjRpSm9hVjJGekVCQ0cvK1p6QUVUMEJQbjhwaHdzUTh3NU5tY3dUK2pF?=
 =?utf-8?B?Vy9mRlFnNjFRcmxENi9mZHdYdmlVNUNwZnBFa25sT3hLUmc4OVVaVmpzUjhU?=
 =?utf-8?B?TnR3Wm5IcGpTckoybzEvSkhVYUVsWjlnUG5IVjM1dy8wdG1IYkhQRzBlTmUz?=
 =?utf-8?B?NmxLTGUwbVJBRllyb0hLVHRSLzFpb2pqWWtSdEJIeW8yK1lpN1lJRTdQbnJ1?=
 =?utf-8?B?VnJYeFpGTWFWRVVSSE1xQ3BjOGMyUWx0QTROc2hHNitjbTRPRUJqb2J5dVZB?=
 =?utf-8?B?YldOMlIrTFdyQmRaTjVPcm5OZ3F5V0Z6NGpDVll2Mlc1MkIwUVc0L1lGTnZi?=
 =?utf-8?B?L0xIVVdmSFZxQTVGREtMc0NWN095b1BsREJCTzdoaUlqVG5QSTE3QXZXeWVY?=
 =?utf-8?B?dWFaRG11WmFmOXNIVHpnRzQ0R2loWEdPYXUxemp0MjdsbUZ0Q1BVVzBrazRp?=
 =?utf-8?B?RDdvamwwcjRzT21DNkNjbDIrQkdZcW52Z2hjK3ZLVVhKNzU3NFV3SHk5RjlB?=
 =?utf-8?B?eHJEVWdYcHBMRUR2eDdBeFBvanYzZDdrRCtBTlZobWJ0cTN1dXo2bW5HNm9D?=
 =?utf-8?B?VmkrMWhXN1MwUm9BVi9zMVNGV0ZQUGxaZ0xDdUlKRzFoQW92MXhyOFpmcXp3?=
 =?utf-8?B?SmhYZjVGbkNka0QySXNiVmhNSk1INUd4Z2RJeWJ4QmtQa0FIMjc2R0dGZk95?=
 =?utf-8?B?ak5VMnNqVExtWGcwaU14SjZLU0ZlVC9jTmVndFU0ZEZib3MrUERNZHhEc1Bo?=
 =?utf-8?B?Z0dkRHZSalh2L25UbVlsRGtmeUkvSG8vUngxeFBkWDN5cHV0RGUreVkyNHQw?=
 =?utf-8?B?d1BRdDBnVWdzL29GaGtJQlFGVnFRZUJWS0pqQndnZTAwY25PSGtxeUZuYjJh?=
 =?utf-8?B?dlUvSUFpVVZ6eUw3SGZFRE9JdmlzSzZndk9CWXUyelQ0TjQvRlRrKzlCRjYx?=
 =?utf-8?B?Y0twR3A5Z2E1MklyODl5K2hMT2ZWVkJlR0hNTm45STZxWlRRUGdqVldKSjdS?=
 =?utf-8?B?eHNuZ21vUGY1dW8zZm1GRXIzQlB5emVtZVJ5c0JVS1N4TWVVWmVLdW0wWWww?=
 =?utf-8?B?NDlUdGtCUVhrTklTUjBMRTdidHBJcmdMMU5UM3RxWHdvelVhV1l1OWtJNWNZ?=
 =?utf-8?B?UkRVUHVsV2hsRlVMTUF0eWlRVTFUWHlHc01xUEErb1NGUSs3bkZXOGtzV3dl?=
 =?utf-8?B?UkwrK09ZejFjRUVBRG5yR3VIdDl0OTJST2h4bDAxRXYzSXAwQURkNldxNmw3?=
 =?utf-8?B?cUcrVmVuSVNUNjNaOVRuZnZqbXdYZ2dtL3hwekJGVVBWMUdlVTZWN3lncEI0?=
 =?utf-8?B?eVRlS2RMS2g0Z3VJZllNOGhPK0ZCVStXbGdONzVoWWdxRnBnTE01R0s0RzAw?=
 =?utf-8?B?ZkhqZURrWitKKytFSU1kSWI0VDFpOXNBOFZGN1pBYktoN0ZORHgwZDdzMmRx?=
 =?utf-8?B?V1dKdEdQWTVFL0xCempCQTdZOXFFTkF3NXAzSUNXdUJ6SlZWdnFPUzNhZktn?=
 =?utf-8?B?U2RJRVBNRVhSNFpUbUdpUENaQ0RNTVhnaVN6SVE0VHlLbUU3VXpLa3FsM256?=
 =?utf-8?Q?Gyo/3nV9+d4yN/saUTypGIJdCSlrewckaEUyk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3JPNHhsNGtqTkNyZk9ld0l0cWUxVDhic0R2RWJYeUt1TDBNL0FOMHNhS3VL?=
 =?utf-8?B?dDhVaXQ4REY3MVVndFZQRGo4ZEhOWUhlSFBxYUlYS2xFRGxjSC9lMTBQMUx4?=
 =?utf-8?B?bXM4S2d6SUNnV1phcDZpdUtVNVN2NTlJdkZhS2tVSmlZcmRLY1hRNU5SZG85?=
 =?utf-8?B?cE1YditUU0IrK1MyMUpPb0tpV0EzektSQXB0aGQzcmZxOVNUMFo4dGw1a0gw?=
 =?utf-8?B?QzRjdkZZNU1ac2JNa240Ryt1YXcvYUZKV1FTT2dkdjFuTW5QNmtYeDJESVRZ?=
 =?utf-8?B?NU00UHdUVzVtTEdhM2Z2a01ubGxYU2puTGdhR25KV0ptVmJEbmtzamRTMjRs?=
 =?utf-8?B?N2lRZWx6a3RlYmF6eVVtamxXK3N1clpkYjlIYmN3OXhpaDlPdjhaUGl6RnMr?=
 =?utf-8?B?dk1RMy9UOUtIRHVadTBDSDFGQ3Z3RHlCekJzNUxQMFFXdlVMUGMwOGxpWnI4?=
 =?utf-8?B?WkVua01tQ1FLSG5JandleFE1a1NNU010dDJlNmlGU2RPZkQ1cHh0aXdYcUJ5?=
 =?utf-8?B?d0hhRkt6OGdpNHBFemRsMEsrTlRwRDUwUktMa284Sk5WRWJOazY4NU81RWN0?=
 =?utf-8?B?cTRubnkrZjlBS0FyeHBhamk5em9hOHJwOXJhM21wcysyNEM4OUdiWWs1VDZW?=
 =?utf-8?B?a3l0WkN6QytDUnVnby9HbkptWnI0VDFIbjNJbVFzWXIzZUVuN0R2SExVNmt5?=
 =?utf-8?B?SmtvZzJENWMwOHREQmt4bWdnbEpnUThZOSsyVDVUTkEvWlRhRU4vQmtPMndp?=
 =?utf-8?B?RVBBMU1Ed3dESy9DSlR4V0NKcmQ4SVlOY081K1pvUDdKN0lOZWszamlocTAy?=
 =?utf-8?B?ejNZYzUvb1N3V3I5WmZibFJ6aTRJSys2c0YzaUZZdVVwUDVXUU9ST3BQMmRT?=
 =?utf-8?B?UURWdm5jR3dtL0NNNjdMQk1PVGd6SWh0bENVVUJuTEtPSHllVkdIZDY2KzJR?=
 =?utf-8?B?djdTMUxRWFYxSUxtMEV6Y29ZY25ySDFxL3VVSG5FTWRpYkhGL25uaU1XcEx3?=
 =?utf-8?B?eXF0WFNDTk9xcTBhK1Y1Zm1NUngydkYxWVV6RkRHVkJ2NU01c0p4Z2FiSjIz?=
 =?utf-8?B?UGVCbDl2NlZoQUJNdW1jSmQzL0N5UDlUbXNoTThpSmZJdm1UWmpUMkhIK091?=
 =?utf-8?B?M2h3aGZsekxWYzFEbTNYbFcwdVZkcXp3WmpqYTdJOTZaMzdrR2FjLzJsOXQ1?=
 =?utf-8?B?WnlSVlM4TmRUUlBpb0MraE82dXJ1eG43SkhUaTcyUHo2Rk16MUlxbURFVmxP?=
 =?utf-8?B?OHdoenRMZmVhYVNHdUhId1BTckQySjk3WXJ4ZmdtSDRlZXN4Y0hoZy9sbG9X?=
 =?utf-8?B?b01GelpUUFdGZVRpNFFWQkZ0dWp0cnVyYk1NY3R3QnY4YTRjbFpPdHBsRGV2?=
 =?utf-8?B?dWJpWHY1MTAwdk1KbVp2RzRXRFhYTWI0STlRdnhRNDFOREFXQUpDYWtJMFFR?=
 =?utf-8?B?YWFjUi9lc0dEdFJmSDhmTU5vMkdiSU9WMktsZkRBVGVwR3J4VmlZdWJNSEZk?=
 =?utf-8?B?Y2VScTJYK0g3d1lTQ1lxVW9oME5rUHd4ZGVxSk5VNFJuMDhwek5aVncwN0t3?=
 =?utf-8?B?R281TW1pcFNVdmViWUZvaFdjT3VRN3R3aEJ3Wno1eE9VMTh3OC9QbmVUdnZh?=
 =?utf-8?B?VFAwSlVZTjB6M3Q0d285MU5KOU9hY2p6RnpwdVY3MG1QRFdSRnlzUVBHZUxa?=
 =?utf-8?B?TSttbzFXVjM1NVpicXQ5VUp4TU5jdDlCMTB5OWprRFcvbWIyVURrTEtlR1FJ?=
 =?utf-8?B?czZyTUtwME9ib2l6TG9QUWFhKy81R0Z3Ukh0QlE4a3dIOFFtYVYxRllxZHJG?=
 =?utf-8?B?MDVGQUZ5MWl0NFVLbzFpYkk1Zm1QN3d3bS93Mmh2MzdXMFl1L1ZFS1Q0QTQx?=
 =?utf-8?B?QTE3ZnVCeDB4VXNaMHBEUUR4L0ZNRW1mYUU0K0tZTEVmTHY5L0dZTWN4N0Zr?=
 =?utf-8?B?ak9WdUpOYkY1UFVmMUxUTGlyZ1VvN2VvS0F0UmI3MVlaT2tTUUgzRnNJeHJs?=
 =?utf-8?B?OXFEejduMVR3dGtBL2JTb3BRTkZ3K0gwcGZidzlvbEpCZnVGV1VWQkhhQ2Yy?=
 =?utf-8?B?OExxZmNEMXc2WEJUNG5Fa29pN1owaHhPcmZYOVRQc1hhbXhOT2ZjZy9kNFhy?=
 =?utf-8?Q?kNVebFZvtUpm0tKk0Ux5tNLj/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EECAB5FDE1F9043BF1C653C8DC2B1F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36f5942-5502-4462-9fed-08dcf99d904b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 11:17:10.5729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PwMWFwzmgwjFJIfJylgHWI+LbPda/T9fk9jSG3FdActVrFQj10JOVHJmh5uy+PeYZgIBu7taR44SEC9rP3aE9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5964
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTMwIGF0IDA4OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAyOSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUgYi9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUNCj4g
PiBpbmRleCBmOWRkZGI4Y2I0NjYuLmZlYzgwM2FmZjdhZCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L3g4Ni9rdm0vTWFrZWZpbGUNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUNCj4gPiBA
QCAtMjAsNiArMjAsNyBAQCBrdm0taW50ZWwteQkJKz0gdm14L3ZteC5vIHZteC92bWVudGVyLm8g
dm14L3BtdV9pbnRlbC5vIHZteC92bWNzMTIubyBcDQo+ID4gIA0KPiA+ICBrdm0taW50ZWwtJChD
T05GSUdfWDg2X1NHWF9LVk0pCSs9IHZteC9zZ3gubw0KPiA+ICBrdm0taW50ZWwtJChDT05GSUdf
S1ZNX0hZUEVSVikJKz0gdm14L2h5cGVydi5vIHZteC9oeXBlcnZfZXZtY3Mubw0KPiA+ICtrdm0t
aW50ZWwtJChDT05GSUdfSU5URUxfVERYX0hPU1QpCSs9IHZteC90ZHgubw0KPiANCj4gSU1PLCBJ
TlRFTF9URFhfSE9TVCBzaG91bGQgYmUgYSBLVk0gS2NvbmZpZywgZS5nLiBLVk1fSU5URUxfVERY
LiAgRm9yY2luZyB0aGUgdXNlcg0KPiB0byBib3VuY2UgYmV0d2VlbiBLVk0ncyBtZW51IGFuZCB0
aGUgZ2VuZXJpYyBtZW51IHRvIGVuYWJsZSBLVk0gc3VwcG9ydCBmb3IgVERYIGlzDQo+IGtsdWRn
eS4gIEhhdmluZyBJTlRFTF9URFhfSE9TVCBleGlzdCBiZWZvcmUgS1ZNIHN1cHBvcnQgY2FtZSBh
bG9uZyBtYWRlIHNlbnNlLCBhcw0KPiBpdCBhbGxvd2VkIGNvbXBpbGUtdGVzdGluZyBhIGJ1bmNo
IG9mIGNvZGUsIGJ1dCBJIGRvbid0IHRoaW5rIGl0IHNob3VsZCBiZSB0aGUgZW5kDQo+IHN0YXRl
Lg0KPiANCj4gSWYgb3RoZXJzIGRpc2FncmVlLCB0aGVuIHdlIHNob3VsZCBhZGp1c3QgS1ZNX0FN
RF9TRVYgaW4gdGhlIG9wcG9zaXRlIGRpcmVjdGlvbiwNCj4gYmVjYXVzZSBkb2luZyBkaWZmZXJl
bnQgdGhpbmdzIGZvciBTRVYgdnMuIFREWCBpcyBjb25mdXNpbmcgYW5kIG1lc3N5Lg0KDQorIERh
dmUgKGFuZCBEYW4gZm9yIFREWCBDb25uZWN0KS4NCg0KQWdyZWUgU0VWL1REWCBzaG91bGQgYmUg
aW4gc2ltaWxhciB3YXkuICBCdXQgYWxzbyBJIGZpbmQgU0VWIGhhcyBhIGRlcGVuZGVuY3kgb24N
CkNSWVBUT19ERVZfU1BfUFNQLCBzbyBwZXJoYXBzIGl0IGFsc28gcmVhc29uYWJsZSB0byBtYWtl
IGFuIGFkZGl0aW9uYWwNCktWTV9JTlRFTF9URFggYW5kIG1ha2UgaXQgZGVwZW5kIG9uIElOVEVM
X1REWF9IT1NUPw0KDQpXZSBjb3VsZCByZW1vdmUgSU5URUxfVERYX0hPU1QgYnV0IG9ubHkga2Vl
cCBLVk1fSU5URUxfVERYLiAgQnV0IGluIHRoZSBsb25nDQp0ZXJtLCBtb3JlIGtlcm5lbCBjb21w
b25lbnRzIHdpbGwgbmVlZCB0byBhZGQgVERYIHN1cHBvcnQgKGUuZy4sIGZvciBURFgNCkNvbm5l
Y3QpLiAgSSB0aGluayB0aGUgcXVlc3Rpb24gaXMgd2hldGhlciB3ZSBjYW4gc2FmZWx5IGRpc2Fi
bGUgVERYIGNvZGUgaW4gQUxMDQprZXJuZWwgY29tcG9uZW50cyB3aGVuIEtWTV9JTlRFTF9URFgg
aXMgbm90IGVuYWJsZWQuDQoNCklmIHRoZSBhbnN3ZXIgaXMgeWVzIChzZWVtcyBjb3JyZWN0IHRv
IG1lLCBiZWNhdXNlIGl0IHNlZW1zIG1lYW5pbmdsZXNzIHRvDQplbmFibGUgVERYIGNvZGUgaW4g
X0FOWV8ga2VybmVsIGNvbXBvbmVudHMgd2hlbiBpdCdzIGV2ZW4gcG9zc2libGUgdG8gcnVuIFRE
WCANCmd1ZXN0KSwgdGhlbiBJIHRoaW5rIHdlIGNhbiBqdXN0IGNoYW5nZSB0aGUgY3VycmVudCBJ
TlRFTF9URFhfSE9TVCB0bw0KS1ZNX0lOVEVMX1REWCBhbmQgcHV0IGl0IGluIGFyY2gveDg2L2t2
bS9LY29uZmlnLg0KDQpIaSBEYXZlLCBEYW4sDQoNCkRvIHlvdSBoYXZlIGFueSBjb21tZW50cz8N
Cg0KPiANCj4gPiAga3ZtLWFtZC15CQkrPSBzdm0vc3ZtLm8gc3ZtL3ZtZW50ZXIubyBzdm0vcG11
Lm8gc3ZtL25lc3RlZC5vIHN2bS9hdmljLm8NCj4gPiAgDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS92bXgvbWFpbi5jIGIvYXJjaC94ODYva3ZtL3ZteC9tYWluLmMNCj4gPiBpbmRleCA0
MzNlY2JkOTA5MDUuLjA1MzI5NDkzOWViMSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L21haW4uYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5jDQo+ID4gQEAgLTYs
NiArNiw3IEBADQo+ID4gICNpbmNsdWRlICJuZXN0ZWQuaCINCj4gPiAgI2luY2x1ZGUgInBtdS5o
Ig0KPiA+ICAjaW5jbHVkZSAicG9zdGVkX2ludHIuaCINCj4gPiArI2luY2x1ZGUgInRkeC5oIg0K
PiA+ICANCj4gPiAgI2RlZmluZSBWTVhfUkVRVUlSRURfQVBJQ1ZfSU5ISUJJVFMJCQkJXA0KPiA+
ICAJKEJJVChBUElDVl9JTkhJQklUX1JFQVNPTl9ESVNBQkxFRCkgfAkJCVwNCj4gPiBAQCAtMTcw
LDYgKzE3MSw3IEBAIHN0cnVjdCBrdm1feDg2X2luaXRfb3BzIHZ0X2luaXRfb3BzIF9faW5pdGRh
dGEgPSB7DQo+ID4gIHN0YXRpYyB2b2lkIHZ0X2V4aXQodm9pZCkNCj4gPiAgew0KPiA+ICAJa3Zt
X2V4aXQoKTsNCj4gPiArCXRkeF9jbGVhbnVwKCk7DQo+ID4gIAl2bXhfZXhpdCgpOw0KPiA+ICB9
DQo+ID4gIG1vZHVsZV9leGl0KHZ0X2V4aXQpOw0KPiA+IEBAIC0xODIsNiArMTg0LDkgQEAgc3Rh
dGljIGludCBfX2luaXQgdnRfaW5pdCh2b2lkKQ0KPiA+ICAJaWYgKHIpDQo+ID4gIAkJcmV0dXJu
IHI7DQo+ID4gIA0KPiA+ICsJLyogdGR4X2luaXQoKSBoYXMgYmVlbiB0YWtlbiAqLw0KPiA+ICsJ
dGR4X2JyaW5ndXAoKTsNCj4gDQo+IHRkeF9tb2R1bGVfaW5pdCgpPyAgQW5kIGhvbmVzdGx5LCBl
dmVuIHRob3VnaCBMaW51eCBkb2Vzbid0IGN1cnJlbnRseSBzdXBwb3J0DQo+IHVubG9hZGluZyB0
aGUgVERYIG1vZHVsZSwgSSB0aGluayB0ZHhfbW9kdWxlX2V4aXQoKSBpcyBhIHBlcmZlY3RseSBm
aW5lIG5hbWUsDQo+IGJlY2F1c2Ugbm90IGJlaW5nIGFibGUgdG8gdW5sb2FkIHRoZSBURFggbW9k
dWxlIGFuZCByZWNsYWltIGFsbCBvZiB0aGF0IG1lbW9yeQ0KPiBpcyBhIGZsYXcgdGhhdCBzaG91
bGQgYmUgYWRkcmVzc2VkIGF0IHNvbWUgcG9pbnQuDQoNCnRkeF9tb2R1bGVfaW5pdCgpL2V4aXQo
KSBhbHNvIHdvcmsgZm9yIG1lLg0KDQpPciBpcyB2dF90ZHhfaW5pdCgpL2V4aXQoKSBiZXR0ZXI/
ICBXZSBjYW4gcmVuYW1lIHZteF9pbml0KCkvZXhpdCgpIHRvDQp2dF92bXhfaW5pdCgpL2V4aXQo
KSBpZiBuZWVkZWQuDQoNCj4gPiArc3RhdGljIGVudW0gY3B1aHBfc3RhdGUgdGR4X2NwdWhwX3N0
YXRlOw0KPiA+ICsNCj4gPiArc3RhdGljIGludCB0ZHhfb25saW5lX2NwdSh1bnNpZ25lZCBpbnQg
Y3B1KQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ICsJaW50IHI7DQo+
ID4gKw0KPiA+ICsJLyogU2FuaXR5IGNoZWNrIENQVSBpcyBhbHJlYWR5IGluIHBvc3QtVk1YT04g
Ki8NCj4gPiArCVdBUk5fT05fT05DRSghKGNyNF9yZWFkX3NoYWRvdygpICYgWDg2X0NSNF9WTVhF
KSk7DQo+ID4gKw0KPiA+ICsJLyogdGR4X2NwdV9lbmFibGUoKSBtdXN0IGJlIGNhbGxlZCB3aXRo
IElSUSBkaXNhYmxlZCAqLw0KPiANCj4gSSBkb24ndCBmaW5kIHRoaXMgY29tbWVudCBoZWxwZnUu
ICBJZiBpdCBleHBsYWluZWQgX3doeV8gdGR4X2NwdV9lbmFibGUoKSByZXF1aXJlcw0KPiBJUlFz
IHRvIGJlIGRpc2FibGVkLCB0aGVuIEknZCBmZWVsIGRpZmZlcmVudGx5LCBidXQgYXMgaXMsIElN
TyBpdCBkb2Vzbid0IGFkZCB2YWx1ZS4NCg0KSSdsbCByZW1vdmUgdGhlIGNvbW1lbnQuDQoNCj4g
DQo+ID4gKwlsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQo+ID4gKwlyID0gdGR4X2NwdV9lbmFibGUo
KTsNCj4gPiArCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4g
cjsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IC4uLg0KPiANCj4gPiArc3RhdGljIGludCBfX2luaXQg
X19kb190ZHhfYnJpbmd1cCh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcjsNCj4gPiArDQo+ID4g
KwkvKg0KPiA+ICsJICogVERYLXNwZWNpZmljIGNwdWhwIGNhbGxiYWNrIHRvIGNhbGwgdGR4X2Nw
dV9lbmFibGUoKSBvbiBhbGwNCj4gPiArCSAqIG9ubGluZSBDUFVzIGJlZm9yZSBjYWxsaW5nIHRk
eF9lbmFibGUoKSwgYW5kIG9uIGFueSBuZXcNCj4gPiArCSAqIGdvaW5nLW9ubGluZSBDUFUgdG8g
bWFrZSBzdXJlIGl0IGlzIHJlYWR5IGZvciBURFggZ3Vlc3QuDQo+ID4gKwkgKi8NCj4gPiArCXIg
PSBjcHVocF9zZXR1cF9zdGF0ZV9jcHVzbG9ja2VkKENQVUhQX0FQX09OTElORV9EWU4sDQo+ID4g
KwkJCQkJICJrdm0vY3B1L3RkeDpvbmxpbmUiLA0KPiA+ICsJCQkJCSB0ZHhfb25saW5lX2NwdSwg
TlVMTCk7DQo+ID4gKwlpZiAociA8IDApDQo+ID4gKwkJcmV0dXJuIHI7DQo+ID4gKw0KPiA+ICsJ
dGR4X2NwdWhwX3N0YXRlID0gcjsNCj4gPiArDQo+ID4gKwkvKiB0ZHhfZW5hYmxlKCkgbXVzdCBi
ZSBjYWxsZWQgd2l0aCBjcHVzX3JlYWRfbG9jaygpICovDQo+IA0KPiBUaGlzIGNvbW1lbnQgaXMg
ZXZlbiBsZXNzIHZhbHVhYmxlLCBJTU8uDQoNCldpbGwgcmVtb3ZlLg0KDQo+IA0KPiA+ICsJciA9
IHRkeF9lbmFibGUoKTsNCj4gPiArCWlmIChyKQ0KPiA+ICsJCV9fZG9fdGR4X2NsZWFudXAoKTsN
Cj4gPiArDQo+ID4gKwlyZXR1cm4gcjsNCj4gPiArfQ0KPiA+ICsNCj4gPiANCg0KWy4uLl0NCg0K
PiA+ICt2b2lkIF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lkKQ0KPiA+ICt7DQo+ID4gKwllbmFibGVf
dGR4ID0gZW5hYmxlX3RkeCAmJiAhX190ZHhfYnJpbmd1cCgpOw0KPiANCj4gQWguICBJIGRvbid0
IGxvdmUgdGhpcyBhcHByb2FjaCBiZWNhdXNlIGl0IG1peGVzICJmYWlsdXJlIiBkdWUgdG8gYW4g
dW5zdXBwb3J0ZWQNCj4gY29uZmlndXJhdGlvbiwgd2l0aCBmYWlsdXJlIGR1ZSB0byB1bmV4cGVj
dGVkIGlzc3Vlcy4gIEUuZy4gaWYgZW5hYmxpbmcgdmlydHVhbGl6YXRpb24NCj4gZmFpbHMsIGxv
YWRpbmcgS1ZNLXRoZS1tb2R1bGUgYWJzb2x1dGVseSBzaG91bGQgZmFpbCB0b28sIG5vdCBzaW1w
bHkgZGlzYWJsZSBURFguDQoNClRoYW5rcyBmb3IgdGhlIGNvbW1lbnRzLg0KDQpJIHNlZSB5b3Vy
IHBvaW50LiAgSG93ZXZlciBmb3IgImVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGZhaWx1cmUiIGt2
bV9pbml0KCkgd2lsbA0KYWxzbyB0cnkgdG8gZG8gKGRlZmF1bHQgYmVoYXZpb3VyKSwgc28gaWYg
aXQgZmFpbHMgaXQgd2lsbCByZXN1bHQgaW4gbW9kdWxlDQpsb2FkaW5nIGZhaWx1cmUgZXZlbnR1
YWxseS4gwqBTbyB3aGlsZSBJIGd1ZXNzIGl0IHdvdWxkIGJlIHNsaWdodGx5IGJldHRlciB0bw0K
bWFrZSBtb2R1bGUgbG9hZGluZyBmYWlsIGlmICJlbmFibGluZyB2aXJ0dWFsaXphdGlvbiBmYWls
cyIgaW4gVERYLCBpdCBpcyBhIG5pdA0KaXNzdWUgdG8gbWUuDQoNCkkgdGhpbmsgImVuYWJsaW5n
IHZpcnR1YWxpemF0aW9uIGZhaWx1cmUiIGlzIHRoZSBvbmx5ICJ1bmV4cGVjdGVkIGlzc3VlIiB0
aGF0DQpzaG91bGQgcmVzdWx0IGluIG1vZHVsZSBsb2FkaW5nIGZhaWx1cmUuICBGb3IgYW55IG90
aGVyIFREWC1zcGVjaWZpYw0KaW5pdGlhbGl6YXRpb24gZmFpbHVyZSAoZS5nLiwgYW55IG1lbW9y
eSBhbGxvY2F0aW9uIGluIGZ1dHVyZSBwYXRjaGVzKSBpdCdzDQpiZXR0ZXIgdG8gb25seSBkaXNh
YmxlIFREWC4NCg0KU28gSSBjYW4gY2hhbmdlIHRvICJtYWtlIGxvYWRpbmcgS1ZNLXRoZS1tb2R1
bGUgZmFpbCBpZiBlbmFibGluZyB2aXJ0dWFsaXphdGlvbg0KZmFpbHMgaW4gVERYIiwgYnV0IEkg
d2FudCB0byBjb25maXJtIHRoaXMgaXMgd2hhdCB5b3Ugd2FudD8NCg0K

