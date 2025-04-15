Return-Path: <kvm+bounces-43322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC20A8919A
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 03:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70210189AE9E
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5E61FDE02;
	Tue, 15 Apr 2025 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BGrU9yvl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF6E552;
	Tue, 15 Apr 2025 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744681900; cv=fail; b=WDc0nBeBaTgAffWIoz662pW7XBA1ITB0wDQKdxt+2ENllZjkaCYAvxqToczOkLOhJRJVCRuGlWopZkrdvkGBlcb0vk30JkRrUvjzUsLlFyVS4i2U3xdT+SLEjQsAZMBmt63EIDUZ2RYyTD3EPbRf99z9w1eEsUKqQzyrHAR+FbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744681900; c=relaxed/simple;
	bh=wRiMAF0LREGflSwkkqImceMpCkNCDcWYNATxc1dFa6I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YJDCFyam29W/QiQyYoU0RKt8/mRY0X1pLm6MDnq0R7UhOESZK9txrskK4hOTjiRD+2DHKYa1NM0WGEa6rOQyiG/pMzEp6Zzi2J44t/376LzulCViH0nU7f5xaT5K8RxqwEzuqGznapV6nXJEgkbsPxeb/uJZ+XWNRrmcA9qWQ0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BGrU9yvl; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744681899; x=1776217899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wRiMAF0LREGflSwkkqImceMpCkNCDcWYNATxc1dFa6I=;
  b=BGrU9yvlKjvRL3Got+Pqfn2nZ53bTAcpNm38V0bIfbymHijl7hm2qtSI
   6ksVSC2OwC8eG5OiQrvZIBCEWmyvppPqd4MdvCXqbcRK4OA6Ei9OODzTi
   utrXZWxriDQeH1JiwqwqRaNtDQngn6nDNiwvPLxhG3bYJ/1hYnt/k1thD
   vEfrK7cg4Ux794YjNC5Ku5EcDJSpUzX0jAR2pporWW+7vMaVbIlLnpTKA
   RhEFJB98tX+/YJycjrtnzCEBWXtsG9cV1Ze6AVexgsjSN6JGgRvvRIyfE
   V+YYolVYL9mtLiXe3ZPX8RdznJmh6Hm3CWUMj+pY7QBTT5UNF5XePDr1U
   Q==;
X-CSE-ConnectionGUID: GHXWerVDRQezMAfmYf79QQ==
X-CSE-MsgGUID: aWwfO/V8SKm4LP7hk+3sig==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="63712337"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="63712337"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:51:38 -0700
X-CSE-ConnectionGUID: 0fIkZM+WSeu4yyh4ObCFBg==
X-CSE-MsgGUID: nhPO4XKWQ+KstBPIENV9SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="160943372"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:51:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 18:51:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 18:51:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 18:51:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIl5QeQr+cka20cOdfcj6Xi8JvKPvNljjbMNc32Rw1jf2ql9MMj0IQKyG2sIuJNaHTUYzKRrVDJ+N7mjNBkhjh9lnRMaGB8PKLORhqecrXd5ZqMPq94lhALpHOJmDS3Glzd4Rx5jI1V0UVTG80ApxdEQw7l2Z+vX7wMZhHSo087KESrekJm7LcEZjynuMrWXNEQcgOLavQocx5FIkaknLGKPQeWfWmLRDnG3hBS1XoyOcLEMMFjdIb55bmafnP2/0R3aetmHkJQUGULTD1d/KR19mjuM2kRJtIEW5xVjee/l7Rvewyh0VT2jNOy8lw+tAoxPGC+spd7hYVS6K6t6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRiMAF0LREGflSwkkqImceMpCkNCDcWYNATxc1dFa6I=;
 b=lbrroA+15Ri3ksX+4kyUH3lF6jHhae5hoi0ExGEZ1+uShUn07XRZGDUaT6KPbUe+eGujvXGg9dDeUTNe5Upz8FOaMliDPC2IqLwSBJoCi/nvAlUjEScWvH9D5zk1T7ymVUOdyfHc/9sBjAv6/1d/9OqBBKJ7zhhtw5RJsUJJtO1sVO2iA9CF5iKszIpkFTiS2KRRkZkKoaV/kpLDhuRlfvSdP7WOlLUBinAWS3bFKQPZbwXmnPnkGOb63dOWJ0LPbv2Jx78xP7pNKmgMTf/WyjpouSvNOokDYPdbZanzI8lGx5RZQvHtSlpdipTkgAlegWptoV65Bu0iNkgTM2SVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8320.namprd11.prod.outlook.com (2603:10b6:806:37c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 15 Apr
 2025 01:51:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 01:51:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+4Z6ToAMJQkGJ+/CpfRKNqLOkCoIAgAAAiYA=
Date: Tue, 15 Apr 2025 01:51:34 +0000
Message-ID: <b644c042602cac5096b32c0d61e5a2f7acdbcfa0.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
	 <98408cbc-4244-4617-864d-c87a3b28b3af@intel.com>
In-Reply-To: <98408cbc-4244-4617-864d-c87a3b28b3af@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8320:EE_
x-ms-office365-filtering-correlation-id: 063f350b-2fe1-4db8-1429-08dd7bc00d93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QWZmV0E4ZUxSS3lwaldsSUR0TzRZZHBZT3QydERFTWF0Z210a29uQnhBUVZ2?=
 =?utf-8?B?ekFqdkVpSEtXNHo0QWZUQUVEaWpFbzhEdkpvMEJOYVN5N2tLVC8xTENEM1RZ?=
 =?utf-8?B?Ly9NNVU4UXdpdjloU1dQZ3grb3h5MVdRZlpnd1N0QWc0TmgxbGpWM3krK3Yw?=
 =?utf-8?B?MlF1VjlFeHJKdzAxaGoxelZkV2p6NnlqMmhMUkY0YWNaQTZUZjgwRkREWkRY?=
 =?utf-8?B?eFFFemwzQXEvVys1M0tHaUU4aUd0UWM5VHl1S25xdFU4QW1ZVTJvWUJmb0RN?=
 =?utf-8?B?S2IzT0FwYXJkZ2l1bnNWak5BajlzRWdLODZaQVVYaWROZk0yTTdicndzemtr?=
 =?utf-8?B?TVFYaDlxUGdhTjdSNGNxcFVZZnptVlA3UVppK2dUK2hlWEMwSjh0SUppVlU0?=
 =?utf-8?B?WXIrQ0VNL0xzVFMvVjdsUXNTUm10VkxjemZHNmNIYUNIcCtSNlpYSW5zZUxI?=
 =?utf-8?B?QjlaNFU0eHNQZ21jYVNUOFdZbEF0SlpTcTQ0V0dYMVhzL3o1MkZSS3FDQTRw?=
 =?utf-8?B?UHZ5dmpDNVY5YVNnU2pVc3BMRktXNEhjSytwcEVMOFg0bEtvVDd3Wm9takpD?=
 =?utf-8?B?MTJPUmVWeVBYZjEvYzRXU0l3VDVFSnlVMm12LzR3QU5mR01reFpGMEE5US9N?=
 =?utf-8?B?Y2ZvU1FaV3l1YVZmL3NvTlAxR2dYYS9YZm5sdjdhL1ZCYWJvNEJ4V2E0N1No?=
 =?utf-8?B?WWsxS1VvV0xhbVl2UGJRUVRHTWdmM3BGZVdnK2lZM1pPYWFEUTIvWmZrcDdG?=
 =?utf-8?B?QXFJUkFxdms5MVNDTFpVUC9FZTlycEFRUDFOQUlGeTNIMVJQcW9ld1dTOTha?=
 =?utf-8?B?S21pNEtQRnZ2cmFaQ0Y5V2Yvd21KYVBRaVdHUE16MjhiMFA5VThoMCs5bGZw?=
 =?utf-8?B?eC9YQUQ3ZjNQY200NElGTHBsc0xTNkQ0NnIyZFBRQnlCeTBFblF2NHBDVisx?=
 =?utf-8?B?TGl1cW1TU3ozbk1ybW5NRnR1MmlIdW9IQ2pJQytUd0NLWlZKQ3VSOGd1L0pm?=
 =?utf-8?B?NldIZm1yQU8yWllaZVdBVmhLYStIbW95L29GTENnNWZvcnoyMmpwSzJ0VThl?=
 =?utf-8?B?K2Y2R0p6dFdyV29Vbklhdm9qZDBVc0R2NkFRdW4waW1YNk8rblhQQjIyNHBy?=
 =?utf-8?B?Sk1DNDcwRDBnZ3JrWkdGYldqU2tTWmJ3R1lCVExhTXd3R09mZTd4SGxEWFFB?=
 =?utf-8?B?cm42UjFiTXRBeGw3WjNqZ1J5dEU2aDlKQjNkZ0FrQUQvNTVYUVFpY2RIdkdY?=
 =?utf-8?B?L1N1K1RLVXpseFJXK3RhNW1FSWRGLzcwZGFXU0o4dHlwL2RjakxPeXZTbEta?=
 =?utf-8?B?NVJaRWRnZFpqQlUzeHZOYjd3MWVOcllqRWRzdS9aaU4xYmVzbG9UZWhmQnh3?=
 =?utf-8?B?VUlOL2U3c29UU3J0RzZFb2F2c29CazhYV0svWmdmdWEwSkRDVndDemhJYXhs?=
 =?utf-8?B?d24xc1VMN243UTU4UFFaamg3dWRiRmdNUGFBWGZEVk1uOUpFNTU2WnQ0SmIz?=
 =?utf-8?B?L1pMb3pUeE1GVTJnVHN4NUtRdUxlaGI0MDZHQTdXL0NzRzJ4WTMrbEh0djNU?=
 =?utf-8?B?S3NzMFpaeERacEswRWZZZkUzNVF3YWxpVlZLVXZpOTZYeklvb25pTWlrOEtI?=
 =?utf-8?B?L2dtYXpwWmFWQnpTT2R6S0d6dGZPR0x5dGxoRHAyRGZDRy94TWRoZHVpcysy?=
 =?utf-8?B?cGNZbnNnSHJ3K0NBWjZ1VzVPazlFc3RuY0l1OHRwTXl5UENRajBHb1ErRGta?=
 =?utf-8?B?R2ZWK2d1T04vdmdaU2J1YzN3Wk5GUXovVXRWTTlrU3FTclpmZEkwS00yc3M2?=
 =?utf-8?B?Vm16QkprZHVLNXNQMGdQcjZvL2JOTzJLOG04S1h2aVBESzdKanFMblAzUWVL?=
 =?utf-8?B?alloVzZJTW9USXcyQWFqVFFxajZBTnVUVGV5T3NuOWJHekM1VC9ESXUrSDdD?=
 =?utf-8?B?Ni9rVy9VSkRjYjJIbjZIT0JIK1ZtWnJXYVhaT1JHT1dCczBlYWZ3bnI5Ymty?=
 =?utf-8?B?WE9SY1g1b2ZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckpBalNXd2dnSmE1ZVEzV3NwcW9hcWVBQnpSTC9lMmk5dzlXM0dqWGlVeGQ1?=
 =?utf-8?B?QUNMcGdjV1VPUFlNSHVtcDZIeENVWjcvS0x1WmYyU3dPZVZsUmZ1L0Y4R3o1?=
 =?utf-8?B?QS9RZUxlNEJvaWZyZmRnS2c0dmlUMERLMmljWkFCQ1lscnl3bm5YOW54djJR?=
 =?utf-8?B?NGZXN0IwZEpZVld6Y21nV1ZLQnR5VXRlV1pGVGlFZFc2QWhIN1p4anR1OGZS?=
 =?utf-8?B?WGxRaldqZ0VESDVuRGhWWnJsTENkaFUxTHIyc0hoZjY4K3N6YXVRWG12OHhv?=
 =?utf-8?B?aFJHaFlpcWMzQ0EvUlBCVW1zaXdKeEZCU0laaGVIQ3RFbUI4d2hRZUYxR291?=
 =?utf-8?B?bHcybi9rUXMwMk5rdTFOcTdzL0pEOWc4QXBlNU1TT2hRSUYyc0poVy9kMWl3?=
 =?utf-8?B?OFBLanRqRlU4NTVDQ1VBeTdWK0xwYzV2RDBCeFF5RzNkR2QzN3NUWlQyQlB1?=
 =?utf-8?B?TEN0aTFYS3NJeUlIdkEyZzIreXlYQ3E3Rmg2UHFaRlFtSVhmbnVseE9aZGhU?=
 =?utf-8?B?TnFtL21rMENYdmZ5ZkRidnllUGZGczh1TlJDMm51REhlREgvS1B0QkFsdjdM?=
 =?utf-8?B?TWNtK3ByMzZOSEdsK2pvdWthYTY3YnN6K0JtRU51T1Q3TW8yL2pJNjJYRy9E?=
 =?utf-8?B?TWQ5UFZLUUNTdjN0WFY5NTIrSkR2eEtncGUrQ29UYVcvbktERWxWdkNJSktM?=
 =?utf-8?B?c1Vybm95Z0oyeURjSFNNRHd4VzhOcDl2UEpKVWVXa3hlS2pPb1dPckpNblNI?=
 =?utf-8?B?ZUFoaDdVbTI1VWtHaUMxdmpnMjRGNklSVzFiZlFnaEs3SFJ5cmMremZhQlcy?=
 =?utf-8?B?bzZoQTBVZkYxL3pCOEFrY2pKSzkxNHJVeExSSWlLdjB3R0hJWDZrU1lKSXNa?=
 =?utf-8?B?SWsvdjNPWEQ5clphd1FxNGY1Qnc5cjFmYWMra2FELzg2bTV1eEV0UmFIOVVz?=
 =?utf-8?B?dG1IZTF1b2kxQnFrUmhVaXZndE02VmYvMXFleng4d08xZGhXMnQyUVVTYzky?=
 =?utf-8?B?N0hxUlA2VHhvbkhJdk53cWM3L0dFa3pVZzJ2bVdjK1ZQUWJ2dTZJZVJNdXNT?=
 =?utf-8?B?OWJLYTc4TFVUOWxaMFVJb3ZmN3RhYkpEVHpvcndNM1lWMVdVNENHZHUvSjM3?=
 =?utf-8?B?VTFFd3EzYmFUT3djZWZUMWdFclZNVnBQbjJoODZ2VWwwUUtncmg5Y1oxQ1FW?=
 =?utf-8?B?MFZIaWp6ZkE2SlBPRCtncjI5OHhXUy83eTVBY1h3WTVLZXNtK2tFSWZQRncr?=
 =?utf-8?B?cUZZYjhVelVZQjgwVTRkUHJudmdXTDkyMDFYN0xWRGNmVUZWMkVVUTVrRTBw?=
 =?utf-8?B?RkJzZjlmODBGYkZ2Q1U2MlBuMEFBVFYyYlVYQkhOZ0wzQVRCK1NWbzBhMjJp?=
 =?utf-8?B?YkltaXZsb09yN3dyM1ZoZWtmM1g1bjd1Rk5rTDN5b2p2WkJDdURRWmFlMlFO?=
 =?utf-8?B?TnFkRi85OTZaQ0ttR29qQTl2VEdoSzlkY1dLb2lBWEdIT3ZmMm5zTG1FS0pK?=
 =?utf-8?B?RnRkWVFOSnJoNG11TnJqZlNYZ0R4OWFaNG5TWmpuM05HT3RIMkNkZW5BSWpX?=
 =?utf-8?B?M3g1eUZ0b3VjZEVHMXJxYksvUEw2S0xPa2ZzWXAzOElIQXBpYU5lMXp3TDFW?=
 =?utf-8?B?ajJyVURtL3AyT2NSTDBUMkFJc2RDenNHUUNHbkRDNXlvcDMreWpDV0krVlQv?=
 =?utf-8?B?WUszelpjMkZWdlBzR0xJY3psZnFlNUhmYVhMVW5yenFManc0aUFlMGY3SFdz?=
 =?utf-8?B?aks2cDMwalVjb2M1YmsxUE9va05OaGhJalg5QTFaVXBQOGJiZ2g2TUlJNGxS?=
 =?utf-8?B?U0NMSnBGN0FhVmpCdkllNTk1dGZPSFU1b25ITitpWklHMG83cjc4YlJSRkdD?=
 =?utf-8?B?SjhLUngwM1BJTHdkZUlvRWxVaURobkdpQjVNUi9BMEtVT25zbmwyZWFmeW5Z?=
 =?utf-8?B?WDVNaVJuZWZINWR2MXNibjVZa0NxY2lOektMM2xNU2FHei8wUXpWL2pWTzUy?=
 =?utf-8?B?Ulo3K0N5dTZmb0t0MStjTEwwK0NVb1hqQVJMZHhmN1dzYVprS2tVQjRabHJv?=
 =?utf-8?B?WHZUQU1LSkNFbFYrdDBHR3RCeUpUdjg0Znk1N2NhYWZNMk16cnh2UDhDdGFF?=
 =?utf-8?B?QVRDZldkUnEvQnpSeXR0V3g4NlBQNDdUR1RIbHpwNm51eGpSV1VIRHJsSXhB?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E44DDC555864C4780A847FE2F7064B6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063f350b-2fe1-4db8-1429-08dd7bc00d93
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 01:51:34.7601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IJ4BjItOrREiVgWehFhhhCdC242ZugQrqeDwQL3fg/Fgxtjqze9gsaYgFlj0ynu8A4nwtjewV9QXnu0uv37l5QylaSI0VrV8zNurlLW4yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8320
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA0LTE1IGF0IDA5OjQ5ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmgNCj4gPiBpbmRleCBjNjk4OGUyYzY4ZDUuLmVjYTg2YjdmMGNiYyAxMDA2NDQNCj4g
PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkv
bGludXgva3ZtLmgNCj4gPiBAQCAtMTc4LDYgKzE3OCw3IEBAIHN0cnVjdCBrdm1feGVuX2V4aXQg
ew0KPiA+IMKgwqAgI2RlZmluZSBLVk1fRVhJVF9OT1RJRlnCoMKgwqDCoMKgwqDCoMKgwqDCoCAz
Nw0KPiA+IMKgwqAgI2RlZmluZSBLVk1fRVhJVF9MT09OR0FSQ0hfSU9DU1LCoCAzOA0KPiA+IMKg
wqAgI2RlZmluZSBLVk1fRVhJVF9NRU1PUllfRkFVTFTCoMKgwqDCoCAzOQ0KPiA+ICsjZGVmaW5l
IEtWTV9FWElUX1REWF9HRVRfUVVPVEXCoMKgwqAgNDENCj4gDQo+IE51bWJlciA0MCBpcyBza2lw
cGVkIGFuZCBJIHdhcyB0b2xkIGludGVybmFsbHkgdGhlIHJlYXNvbiBpcyBtZW50aW9uZWQgDQo+
IGluIGNvdmVyIGxldHRlcg0KPiANCj4gwqDCoMKgwqAgTm90ZSB0aGF0IEFNRCBoYXMgdGFrZW4g
NDAgZm9yIEtWTV9FWElUX1NOUF9SRVFfQ0VSVFMgaW4gdGhlDQo+IMKgwqDCoMKgIHBhdGNoIFs0
XSB1bmRlciByZXZpZXcsIHRvIGF2b2lkIGNvbmZsaWN0LCB1c2UgbnVtYmVyIDQxIGZvcg0KPiDC
oMKgwqDCoCBLVk1fRVhJVF9URFhfR0VUX1FVT1RFIGFuZCBudW1iZXIgNDIgZm9yDQo+IMKgwqDC
oMKgIEtWTV9FWElUX1REWF9TRVRVUF9FVkVOVF9OT1RJRlkuDQo+IA0KPiBJIHRoaW5rIHdlIHNo
b3VsZG4ndCBnaXZlIHVwIG51bWJlciA0MCB1bmxlc3MgdGhpcyBzZXJpZXMgZGVwZW5kcyBvbiBB
TUQgDQo+IG9uZSBvciBpdCdzIGFncmVlbWVudCB0aGF0IEFNRCBvbmUgd2lsbCBiZSBxdWV1ZWQv
bWVyZ2VkIGVhcmxpZXIuDQoNClllcywgaWYgdGhpcyBwYXRjaCBuZWVkZWQgdG8gc2l0IGluIGt2
bS1jb2NvLXF1ZXVlIHdpdGggQU1EIHBhdGNoZXMgZm9yIGF3aGlsZQ0KaXQgbWlnaHQgbWFrZSBz
ZW5zZS4gQnV0IGl0IHNvdW5kcyBsaWtlIHRoZSBwbGFuIGlzIHRvIGluY2x1ZGUgaXQgaW4gYmFz
ZQ0Kc3VwcG9ydC4NCg==

