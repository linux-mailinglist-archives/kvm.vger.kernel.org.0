Return-Path: <kvm+bounces-51828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A53AFDBC3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 01:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBC963A3B74
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 23:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515FA235071;
	Tue,  8 Jul 2025 23:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKE3JXMJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A248B33993;
	Tue,  8 Jul 2025 23:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016588; cv=fail; b=SGsn2ukK04CArez3TLejQqheO/KvCE+WaaXBz3gQk2K1DX1V/wIcJZ3ksl2zXsTk7dKNCRF3dpUNie/KLDK9P38dcTzs4yE6oduIEtV5FQQ+vLnPRCvENah1PG98QFyEI69wzm5qX/LYEpqYVQfztSl62nzf84QcS4sLLEWAMcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016588; c=relaxed/simple;
	bh=dZfP0I73uY+cj2GYSpQTYEsWcmIa8Cu0k3mg1VqrW5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CrPEOZ2EYFVIdh+RKQ8VFaG6E+DZa+sK4U8nAGgBOkiImzBWZCAn3ZYPYevA6sRi1klNSLgauJVXVhL2XlJ0V0GzpLgUPzHF6stWmFg92m+5bd4A+OR0sPPQ8ZXeGJVJP8ekfUmK+SrapMg05RmrsDK2V3/TLLaOwOtDKJubKG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKE3JXMJ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752016587; x=1783552587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dZfP0I73uY+cj2GYSpQTYEsWcmIa8Cu0k3mg1VqrW5o=;
  b=BKE3JXMJnQPjxJkrQfdCd/QwJ7nQmd6w8pkVI8xHCmRwdvhnCwxMhpA/
   GatIq0KIapH36vhwZ6TWCbuiuJmdFpgEI4t8Vg4vYNDNv0egoerfsSFwm
   nQca6qk2PcigvSTj0ZhsEmI5G72j5ocPNim5+CbfuQMXhKkRlnzfcnebs
   OoBJQTyBN9ss3vzR/RqUu8+1PtUA6yc1tN3KZMpnm5B9pQYMCTtSCWkeP
   9hO96t7+EAc+/Am8MkDQosdgWCG5wOc5/PCbr2foBfL+3RAMt+1hjqw02
   kv31+IAir5jzcH2QPXJo1UrpcMD83WJKrnQotD2KOemd2X6Qp7H3M0xjF
   Q==;
X-CSE-ConnectionGUID: icF7yPSUSfeArf4gkODzrA==
X-CSE-MsgGUID: +O9TUiHvQQCpr8ljbl16NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="56877354"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="56877354"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:16:26 -0700
X-CSE-ConnectionGUID: lsZz2QkCTvCCktN30EmI4w==
X-CSE-MsgGUID: uoSq3re5Rkyoz+gk3DIwIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159932767"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:16:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:16:25 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 16:16:25 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.88) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:16:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RApX7hUj5l8MeEJPn8APAtiZKcT0wYnmDD7JYupaQysRao68vrBTroUqbKMAHzeViPRVg+bAMtDqhpvIoOfRQG99P4eAhsA/pN+rDevIUnQfn33vxkOeuB9ep1XgFnMyQ0BC7Oedy1uOqpq2gyXFNnMk4OdVx0nkCJdWDatWBimjreuaK3UvUqzlWKteMSOgikqb/Zvi+pAQPTt1jx/GSAM6lUHSVeVmOclDYIhju4SJk+cO+Z0Ekp0Lgc2v6bdio+McwITlSQ0PaUvYZflmeBEnRJ4kUvVV1btIQcYw9R8R58Ubxwjn8ZxzhAMqcsFWG9S3OjswLu4Vf5BBtRuAQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZfP0I73uY+cj2GYSpQTYEsWcmIa8Cu0k3mg1VqrW5o=;
 b=CZeqBDXCjGZkn7WSiBJekJq+RZxGo8vvurlVQTdCOCcNl2E+ZYX3onPLAOHylkgye+I1GfFb+LGoV1Ui3ldMbG9dT6mXW9YvyId1iTZQk9mp/WzfZqXioTDAk4cpToHexn1/kbUbXTi3lp+/j/SKExsCSyTrTFHo9ZkeINbuRcMJNzPuwpWkJ1imgA0syMA+xRyT2EKt2dJrgTUnXbnwbqX6YCYjQ20dxrdSPhcf2anP8FijpYexZSabNphvhm+RRyeKIfDu2JjtO4BrDsydKRTPx1yfugu8D1n36rAmwDDjVRkGwKdN5pFNPfdEtLIF9PRjKbx97TJcBqdlvQPXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7186.namprd11.prod.outlook.com (2603:10b6:208:442::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Tue, 8 Jul
 2025 23:16:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 23:16:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tabba@google.com" <tabba@google.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbQoYJcAgABV1QCAABpOgIAAAJ2AgABuU4CAABNqAA==
Date: Tue, 8 Jul 2025 23:16:21 +0000
Message-ID: <edc5efcab4452d3b0ab6c5099f6ced644deb7a6e.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
	 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
	 <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
	 <CAGtprH8jTnuHtx1cMOT541r3igNA6=LbguXeJJOzzChYU_099Q@mail.gmail.com>
	 <c22f5684460f4e6a0adac3ff11f15b840b451d84.camel@intel.com>
	 <CAGtprH_tgn1Xn-OGAGG_3b2chOZBkd4oO9oxjH5ZMF7w_kV=8Q@mail.gmail.com>
In-Reply-To: <CAGtprH_tgn1Xn-OGAGG_3b2chOZBkd4oO9oxjH5ZMF7w_kV=8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7186:EE_
x-ms-office365-filtering-correlation-id: e624e003-fd24-4cd6-fc70-08ddbe7573d3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZUN1V1Z4RHlXbURtVDRrMnN5NE1pMi9IMm1SZCt4VWZ5UHU3Q0NlaW5SRnc1?=
 =?utf-8?B?ZjBmanJpYWdOcHp2YnFNV2RMaER3cnUyUGI1LzdSVHVoWWRkNWYzVmpsZWd0?=
 =?utf-8?B?OUtOcG5XNzd2TmRUMVBFZzJDN2xwNVh4YkxJeGJOeG5ob3BVVkJxd0g3WkFH?=
 =?utf-8?B?R1pNa1V1aXV2VmkxTTBWdnJIZXVKaUR0OTRwc2JzVGk3ZFFic2E3UW04Mjg0?=
 =?utf-8?B?eTZDQVR1NVBqSHhKeXJiUTEvdDlNQ0JlOCtCS0thdDNYR1lYWkowNlZERGdp?=
 =?utf-8?B?bVdqVWJwbTNBMEpsSXlMOWVlalJOZExTTGZISFdOaEhYM1Vlcnh0UWJndGNu?=
 =?utf-8?B?ZWI4Y29hUWs3dTVydDZ4enBLTXJjNVNZZjMzbFYvY1Z0ZzdlSEg4TXdZZ01T?=
 =?utf-8?B?NWJ6eHRSQWFkRkhxQTh3TXJza1RaMWpZbm9vUEhLVHdraFd4Zkx4YnRBUUFR?=
 =?utf-8?B?cy9YYXRwSEZKcDlGM2xTcDJQczhuQ0xMd2luTUQ1MStJMjJCalBUTHQ3cmJh?=
 =?utf-8?B?WUpHWFUxVGV4VHdQUVZoVDRwZldzUE5hRTV3RituWi9RbmtROTVlY1VJWXNT?=
 =?utf-8?B?alpLaDhQTTBFNVNNT01lZGJUSnZ3NTJjbTlKeHd4bFY4VkFDb0htQlg1V0N1?=
 =?utf-8?B?WTF2MktFeEtoMDhWVkYwUWsvb3FxV1ZaTU9QeE5mSnZYUFV2MUYvTEkrd1Ba?=
 =?utf-8?B?NnlaNmpPc2FMenRKSThLR1ZPckZuQjljMkRFVzc1d2pRL1VUdm91Z2Vya1Zm?=
 =?utf-8?B?a3VvY3g1K2dYcGN3UGV4Yzd4VWdZb05jYVFXNHBBakxZL2Z6c2FZVFpIQUdx?=
 =?utf-8?B?V3lyY2pQeXZsVTkyV1gvamM2a1VNYS9nZTZHT0oybjdmUi9Kd1RzWEVoWURX?=
 =?utf-8?B?d2o1QnhQZXZ1Q1dSWUV1dVJBbEszdG1OUElMSTZOZGQ3Ny9CazhQQ0pGL29R?=
 =?utf-8?B?K09HRzVwM2l1TFBkdHFlNk1hZWdMTlFJeWU4U1hoNFh4Zkw3eWhmRDR5MjZ0?=
 =?utf-8?B?cmlrTWpNTXRHY01KNHYzTHNmZU1ZU0llb0hHQTJ4YkxEeldVd2xKVUovQ01z?=
 =?utf-8?B?eGtxUWZrcUxkbkJucHVPcjk3VkpxQTF4bW9kcTR2VE5ZejU5QmZNTlAxaGFS?=
 =?utf-8?B?QTlQVHFoc2NoTVBuM3JuT0EzUTVVd2E4SWRBUjkwckF3Skp1dWY0WTFYZHVW?=
 =?utf-8?B?aUg4SEw1TDMyOXRlN3B3am5Hdk9OM1RoZzBZRUhnWFVDMllIWEJzaGtPSG9R?=
 =?utf-8?B?NWRHemN0SWJZU1pkZEFEUFdRZEVHcXJBTFVjVjZjZGtObGdHVEtRT1hBR0E3?=
 =?utf-8?B?RDllZDZudzkvL2ZseW40bFdReStSYkMxeVQvTlBLTnEvMDQ0bk4wdm9HaURn?=
 =?utf-8?B?Wi9IVlY0SkgrSTFrTEJaVDVob3ZnWWQ1TitTMFNPYVVDNGNuRmlKcEpZSHZ1?=
 =?utf-8?B?VWdNUDdEcUxublBXQ2pFU01yRXVYVUp3ZHpBWk9rUzJWWEdkYzFYdFZVMVlJ?=
 =?utf-8?B?VXV4eWd4Tkc4a2xucmFNY1FYUUkwcGNBTllZK2xiamQzWGFnWGxhektUbUJt?=
 =?utf-8?B?TUp6bW9nZEZoeVhSM2ZiUlZXYktZdmVUR0UzQW5WNWxPMlpIOFBtenVBSkNl?=
 =?utf-8?B?NjU1RDB5bmtaRGVQUStVRGJTN0ZnNTNNVGRwaDFFR2gzNS9YNFVPaWxYbk5j?=
 =?utf-8?B?Z1hPbVA3T1JvenE5NEQwc1hrSFpXRFBlWEs2U2Z5a0pvQlRoeTlTZHJrK3pZ?=
 =?utf-8?B?Q2FYd2NkR0JUOUNNRElPd2hwUDNrcjRVbWRvd3lEaVlueFV5NWgvNHdQOTNF?=
 =?utf-8?B?bkNKaU10SjV6K3NrUDdnNHlGYi9PUk5SWDhxeTZacXhEYzBsdGtLS0N4ai9P?=
 =?utf-8?B?RjZ4V0NxeExLMktTWXhYazV0Q3F4VDN1dGFpZzZDTys0NHRBeWh1NW1OOVJM?=
 =?utf-8?B?V2tpM0kyWjZYc3NwU1pFdEdDMmMwWlg4M0pXN3JBSVRXVTdJQ2Y4WkpoQSs0?=
 =?utf-8?Q?3P0Gyb/a2YiGxgU1tS4aJNvfGPzMbM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnJyMVRUeCt6YVNWRUpjRWlaREpFSTNuRjAvSkM5d0UyQkU0VkRidkRmM3Rm?=
 =?utf-8?B?TGJtc1RtcFdXSVZwN1pScm1XbXFBYngyMCtSUkR3YkVWZGRqczhTOHl1SmQr?=
 =?utf-8?B?NmxFQ3JKME8vaGJuQk1rQWptOGxjZHdXWStmU0RoSytEczNjYWpmZzl2UFJC?=
 =?utf-8?B?SlFWWmlKV2IvNEFVQnRyTnVGY1MrbXRKblNZeUpLYW02NnAzRWpUa1lRV3dn?=
 =?utf-8?B?a3JEUnc4ZXV0eGdFNys1ZjRXdUNrT1FNMXM2OXJBVnRFUHR0RE1CcFMzM0l3?=
 =?utf-8?B?TGY4bmNhVUdYTWRWeXNTb0xZZ01BU1htZzBVY21RQ2lIU09GZ0F1ZDFSdGJB?=
 =?utf-8?B?bHlLV0dHcWJCUTJLOVNvVkZhQWcrRXU4MzhPL3BSWUY1ZlZ1KzhVa3FSaTMx?=
 =?utf-8?B?YXFBYXpiUEZ6c0dpeW42OWJpVG5JWXFoNExXRXpUOURmSG5RQk5VbjhudUF5?=
 =?utf-8?B?TzQrMHQrY2R4bkRGN3JyN3I4amp6NHVoUE1Nc1Flak5pTi9UZ3U3VkpUbTlj?=
 =?utf-8?B?c3Q5cTE2UnVWeHFVU0tMV2NaakgyODMrVkRUdzkwWVBCYm85cWFuQkY2TnRu?=
 =?utf-8?B?ckJUd2lCUjNQVDlBcFM2U2NydUJwNU9FcDVjZ2VxRHFGLzFob1NUNU9xNWtJ?=
 =?utf-8?B?ZmxSUWFYUlRGNVg1ZithQlBQQllzVU1yM0o0VnlIVGl1cll2dTlGejNnNjkz?=
 =?utf-8?B?TVFxL0wzYTduamdTN0Z4K0V3Z29aZlhQU08yamNtdjNoeDdFenBEUkVuVml0?=
 =?utf-8?B?V1lKSWMxRTRIdnBPbUNZc05SVklTNWhQN21JRVRjU3kxcGVBczRTL0E1VEQx?=
 =?utf-8?B?bmVMeFd4RDh5TUJybWlEUjhYUUdQelNERW90NDBFMDQ1TWFUNzZEREZ1T2ln?=
 =?utf-8?B?a0JGc2d3VmZmNnZ5Y1NMVE91bXlrQnBUcmtqZm8wdzR4bzNzMTAxcENSamlZ?=
 =?utf-8?B?Nnd3NE03bEUwTzBKQlNXeTh0ZEh1QW1FQkVWVVJFcVh1MW0xVTIyaEFhelpz?=
 =?utf-8?B?b2loVGxEanpGV09BdTFTQ2g1bFVrclB6a1N0QlV0NkJkWDBPMU5FcnloVkM0?=
 =?utf-8?B?L1A2c0Y4OWcyWk1qSGxoNWE0WEplWnEzcW51MGRLcUl2N0xFUzA5OGtNdThY?=
 =?utf-8?B?MGhiS2YxbjRPZEtSaU5yNHBTdkVqZE5Mekc3eGdjenN0aXlVTVhJMUZwR0t6?=
 =?utf-8?B?L3QveHpteGsrWlZQSzZqVVdQQTlYWVJ5R1VNS0NBL1M0SnhFaTVSKzk1ZzhC?=
 =?utf-8?B?KzVVekt1a0MzTGloMEsxYjhaVUdlZEJUa3dWRnA0WDI2S0ZKV2dLWGttT2pI?=
 =?utf-8?B?SGs3bmY2L1V0dzZXM3F5ZGRDdm1RK3B3WjF4Z1hCandUWWs5cFRWbHVGeFJy?=
 =?utf-8?B?aHk3VTMwQjQrc0Jxd1FxeXlmWTJybFVkTVVVZ29SU0pmb1RsTFZRdGZXNi9o?=
 =?utf-8?B?WHFOZlVmaDJjeGxmVGc3SVp0bExKTUpYSU4yYkFsdmpQbVl2UVhleGxGZzhY?=
 =?utf-8?B?b1ZkNXhHSVVGRWs5WmlRZFNEZ2FDV1pzM1BGUWU5UEp1RjYxL3Y2cjNsUzQ2?=
 =?utf-8?B?ZTZaSW8yMW1QcW11NktLTjdYUFJ2b2VaV2ZrajJtWDFBTHVlMzBqVFR0bFdw?=
 =?utf-8?B?K0pGNTVlQ24xbVgwckhXZkZaV3dIUis0ZWlCU3ZjSms0dFE2UnFFREZyVk1C?=
 =?utf-8?B?emJSWmg2TEp4ZXJ6SGovUUd5R1VBcUowei9pQXFTM1NaMzArVlJ6YW5jM1h5?=
 =?utf-8?B?anBoWGYwUHY1T2pqa2sxQ0hOK1E0NGViaE10OU9wekNqTUtSVVBkdzl4Y3dD?=
 =?utf-8?B?UjR4MmkwWUthbGF4d1gwNTZDYUF3UVJPZmdjZ09YZEp4Y3ZRdEo5NmNWK2pR?=
 =?utf-8?B?KytQQm9na3hrYk1Md1NRQ1ZUa2Raa290S0FoUytydnBNRUV6MjJGWTJsOVVa?=
 =?utf-8?B?b3ZsU3BiUXcranErSkYvamd2emRYOVgyWG1RNEt4MVNzQ3pML0UwRmVMWmlH?=
 =?utf-8?B?d3NhYUNBcnRZRHgwMDNzVXRNUUVNa05ZV2RRRTJIV016aUw0V0tIeHRrZ2lH?=
 =?utf-8?B?WTBDZzg1K1k2bkMySWE4UkFMc3RTbFVKL0pOc3FSakFnWTlOSW03MXZyNDRp?=
 =?utf-8?B?TDI2UW5DSUhuQi82eWxOQ2hRMWVmU3VOY0tpb3ZIT3NWWUFUYjBXVUhtdzF6?=
 =?utf-8?Q?3nJxtby1OT93sZPz+t804Dk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7714908D1F823B42840D571D8D26D118@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e624e003-fd24-4cd6-fc70-08ddbe7573d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 23:16:21.9723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDwl1SK5B1t5fVMgEhPs5PGCn8e8opGnL+1bX62X03NtfZa/7g0nPBJ2nKvPLKJRJiGP9rb+W6TecB8fANW9A+sQmaaN+3hz50GfERz83w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7186
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE1OjA2IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+ID4gTXkgdm90ZSB3b3VsZCBiZSB0byBwcmVmZXIgdXNpbmcgImhwYSIgYW5kIG5vdCBy
ZWx5IG9uIGZvbGlvL3BhZ2UNCj4gPiA+IHN0cnVjdHMgZm9yIGd1ZXN0X21lbWZkIGFsbG9jYXRl
ZCBtZW1vcnkgd2hlcmV2ZXIgcG9zc2libGUuDQo+ID4gDQo+ID4gSXMgdGhpcyBiZWNhdXNlIHlv
dSB3YW50IHRvIGVuYWJsZSBzdHJ1Y3QgcGFnZS1sZXNzIGdtZW1mZCBpbiB0aGUgZnV0dXJlPw0K
PiANCj4gWWVzLiBUaGF0J3MgdGhlIG9ubHkgcmVhc29uLg0KDQpJIGRvbid0IHRoaW5rIHdlIHNo
b3VsZCBjaGFuZ2UganVzdCB0aGlzIGZpZWxkIG9mIHRoaXMgc2VhbWNhbGwgd3JhcHBlciBmcm9t
IHRoZQ0KY3VycmVudCBwYXR0ZXJuIGZvciB0aGF0IHJlYXNvbi4gV2hlbiB0aGlzIHN0dWZmIGNv
bWVzIGFsb25nIGl0IHdpbGwgYmUganVzdA0KYWJvdXQgYXMgZWFzeSB0byBjaGFuZ2UgaXQgd2l0
aCB0aGUgcmVzdC4gVGhlbiBpbiB0aGUgbWVhbnRpbWUgaXQgZG9lc24ndCBsb29rDQphc3ltbWV0
cmljLg0KDQpJbiBnZW5lcmFsLCBJIChhZ2FpbikgdGhpbmsgdGhhdCB3ZSBzaG91bGQgbm90IGZv
Y3VzIG9uIGFjY29tbW9kYXRpbmcgZnV0dXJlDQpzdHVmZiB1bmxlc3MgdGhlcmUgaXMgYW4gQUJJ
IHRvdWNoIHBvaW50LiBUaGlzIGlzIHRvIHVsdGltYXRlbHkgc3BlZWQgZW5hYmxpbmcNCm9mIHRo
ZSBlbnRpcmUgc3RhY2suDQoNCkl0IGlzIGRlZmluaXRlbHkgbm90IHRvIG1ha2UgaXQgaGFyZGVy
IHRvIGltcGxlbWVudCBURFggc3VwcG9ydCBmb3IgcGZuIGJhc2VkDQpnbWVtIGluIHRoZSBmdXR1
cmUuIFJhdGhlciB0byBtYWtlIGl0IHBvc3NpYmxlLiBBcyBpbiwgaWYgbm90aGluZyBpcyB1cHN0
cmVhbQ0KYmVjYXVzZSB3ZSBhcmUgZW5kbGVzc2x5IGRlYmF0aW5nIGhvdyBpdCBhbGwgZml0cyB0
b2dldGhlciBhdCBvbmNlLCB0aGVuIGl0DQp3b24ndCBiZSBwb3NzaWJsZSB0byBlbmhhbmNlIGl0
IGZ1cnRoZXIuDQo=

