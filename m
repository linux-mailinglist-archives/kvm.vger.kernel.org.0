Return-Path: <kvm+bounces-34858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A073A06BB1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC66C1889032
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85BB126C03;
	Thu,  9 Jan 2025 02:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y15gKTdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21FBE5E;
	Thu,  9 Jan 2025 02:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736391103; cv=fail; b=Yq68e92fC3mDb15t5nG/GCsVAyUt7lqCd+DbERG17y8RwC/tK2VMKn4HODQysz4/UqXqedpvzznXKDq8LHupv6o+hFuLtGktZgdM8xfyqXRbsI9OSHstH47aRB2LkmIqR/EtOpiA8Ah5yZByf/2TNbi3Y+14JMZ0jHFogjYVpC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736391103; c=relaxed/simple;
	bh=+HCKgp2WnDwxXyuD1NYk+yelVyqaW4K98/6hOdDhN4E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X1x00Q9OWByRGf3m5YfDzAktGG2ztnjw2MLRDtOjAwEzT37yCvhVphNpdikXFwmXykVx7WjUx2KNSg98MlQPZCxmv7afV9X6Vek+/+8HKqyN9BVSGOJsAaBZ8p2z9oiW744AWGre9+fJK3p1Au/FoMgdCSICbb8a7kMeOR/iilg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y15gKTdZ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736391101; x=1767927101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+HCKgp2WnDwxXyuD1NYk+yelVyqaW4K98/6hOdDhN4E=;
  b=Y15gKTdZMJKmZgsPdVGI/cmSUm0pvtmZcA75UDRtGNt624U3w6ncLqTK
   IO80WnSmg/Hy/Sk+U8lF8tXPg2ycjIK5l53RuFrjW5dWzqPbLRc5wORfC
   GIlk4hG1MJhVVSdXrDpVljOCKJ0OSfSBF9aP3Qo0wiM6zdosWcRl6SJHM
   YusRDxa1Ikw36aJXhzD8GehRgVohS88whY6Ai0ReYT5Y1mXj20CbBabiT
   tDqwB5rV1nWCTFIdnZFBdUeI0itzahmcAl+2vzlWX88rcnwzAK11AViG5
   3uchefIxEzAJI7lXJR7R9YfiC4SZTMU9Me/8j+eJmcFoZsAvEDqBXigjP
   g==;
X-CSE-ConnectionGUID: EQMEj+H1R/my45wXc5VFDA==
X-CSE-MsgGUID: 0NoXh36ySJK7jLpVVG9T5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36862395"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36862395"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:51:37 -0800
X-CSE-ConnectionGUID: za/z6rUjQG2RgB61Ir+7HA==
X-CSE-MsgGUID: NSq4cLpsQx2sSlt9EBQo8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108334141"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 18:51:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 18:51:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 18:51:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 18:51:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOY1Pe9kQP2bpD8Nk+WLmQo+a0XtKlx1SfdjwMKn/zSmNOwpQFVclFDEL7zpThyYTwLS5EJ7jgOdI+ZwiWtTbr6GH/eRlFfO9beDjNxKqygrTu+UQnmEP5CDCnhp+MjECbtKuM27x4uWMPQ6Q9y3/SiPX+CrqD4tOCO69UeNl9Ecgqv7FlzfAWGWJYYHJYY4bKHaM8L5+te06ExNrgWSzEJ5FhJmjejg9SXARrc1f3pwYMrHv7o8SG03ptDG/YjnBYnrgrFboNnC9yf9wH/FFU3PikcQYXAKGFzv8ypGEwSwwMWUEb4ZxtEutMOPz2UxU9Xjg8P0ffhILIUPGuF2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HCKgp2WnDwxXyuD1NYk+yelVyqaW4K98/6hOdDhN4E=;
 b=AqQ/GipWEb9QxCc/ibddhwkdojd3FW5otvE1D6rNJTJW0cAtC21Vk6fNv44n7ASnLUKzvfKyhRGcNyf7QqgZoqtQk2Yp7EinJnk5HWbdpkN6EMi6ZGy9H5OHnfiC0XUYUgHPT85f1HR7q9HcKyH4qokrbuIgeas6ola2cpTsgqTkEmISGgLG1pexcT6SCue91vW/EI2lscerdVQr1Ari+RG0segBg2qYuv1kivq0Dqi4bLuvwGnKJllJ/u14r70sYubByDMqcU2FSUhxoWOIZg0IU4GyiY8Jd7hC08GJ4vtxGlYD2IWGtgbBK6YElehJ3luMPmNcWEuW36xfSIE4gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Thu, 9 Jan
 2025 02:51:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 02:51:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Topic: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Index: AQHbSdaN3/8Qprs8nkqRa97lp/p8PbMN7wWA
Date: Thu, 9 Jan 2025 02:51:17 +0000
Message-ID: <f8908f49a84995c9d1ba148361636d6540a56e60.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
In-Reply-To: <20241209010734.3543481-12-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4843:EE_
x-ms-office365-filtering-correlation-id: e80301ba-7007-40d9-3bbb-08dd30587d7e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bFdKV3hpbGV6eC9kbXV2K2Q1WXpZZzVGMzZBREwzY091RWZiTjhKdzRKTndO?=
 =?utf-8?B?NHhzUDdNbXBSSjYyZ0NZeHZPVzdIRmxQUWRuWlZSRFhFekhxQkd1Z3p3d0Fn?=
 =?utf-8?B?bG1EZmpvZ0VwRU5DWkRXbFhMaFVkVXZMM3FoYXBVbUFSdG9CYlRCWmR0QXIw?=
 =?utf-8?B?VWlBS1lCbHpqVUV2SU1IS2tYdmQ0cnZMZUVpTlpXZnI5VXBGUWJaeHduUXcw?=
 =?utf-8?B?QzJlcHBnTzZxQys5b0pSL2F6QVhRcHRaRmhXTzZXMTR3VkJ3YmJ4QmgySm5X?=
 =?utf-8?B?a2NZZHdHZC9UMWZzMzJ1VE5pM2pNQTM1am5qcDhyQnh2ajBlWFRHOElkanZC?=
 =?utf-8?B?OUM3aFRVci9xTmR2Q053dG1WbUlkRXh4WmdsQVJ5bTlJRFJqaEwwbFJOemxJ?=
 =?utf-8?B?MDVPM1dhRVMvTU50eHVES0JkUVRveHk0N250azN1Q0pjVkpLcGtCMmtRV3RR?=
 =?utf-8?B?ZDlRemh5OUNwYnpnMG0vNTVHODF0RlpNbEttdGNhREU2clIrUEFMYVFqVDN6?=
 =?utf-8?B?QmkvYmQxbnNDS2xVb0Z0VG1kcjRsZWY5Q0o2eHlMWDV4K0dscWEreGxTeVB3?=
 =?utf-8?B?YXJtOUtCSk1wMnNWOTUxeGxPZVJOTFo5N1Z4RWE4eG0wRGNMcWxyM3NlbTlP?=
 =?utf-8?B?ak1nNlUvbWkvdm1ZUXdsQlpSMGVydklzVlZRbUN5MktMUUxqRzZCTVBoNHNn?=
 =?utf-8?B?TE9uVm1vOGxYSGp5dzUxdnJjSGE0dDVEM3F3MjBTUzVnclhSR1BqQUt4cm9E?=
 =?utf-8?B?SFFwNS96dXk3S3piSHc2Y09ZOUNWU3BGUGpQSEYvUnpkQVM4QWpVblpNWFF3?=
 =?utf-8?B?ZlhMbCtpTWNaM2JOeEt0aVdsQlIxNnJDcThZNjVxWUhNMDVXZ3l2WGhVZ2pP?=
 =?utf-8?B?QW9kVDlrRzZocFl6WGorOStRMTN3TTJrVEtxYjJLenZPVk5ucFNwcVFWa2ZM?=
 =?utf-8?B?SHhSZE1vdEl3NmU1QUpuSXVjOTZHbWdudVpzek4rcU5sREVRK3J5TmFJeWdW?=
 =?utf-8?B?OEg5YXF4V3BxaUtmYjkvaFJVNHBRbFluaDI3eVUyM2lKL2JtVlZzQTRtUFpy?=
 =?utf-8?B?ajVCZmNEcjYvNGdpK05odk9CMEF6YmpNM2pxd0pZaGdaUU1ha2xYcGpOR2VJ?=
 =?utf-8?B?RXU4VnZsYzVDVjNZSGNkZUxkVUVjU0Y5QndSRUdaMzMwU1NRRHpKSURZeGlk?=
 =?utf-8?B?SW0vdUZMSmxJSDNRZDFPSHQzL1A0RHEzVWRPOTVkd1A1MXVlcC9QeGtWeVB1?=
 =?utf-8?B?UE9heU04SjdydHYxVGVpOE5hUzZ6TExzOTlLbTY5dDVDWHlDdDFwK1ZKT1d3?=
 =?utf-8?B?TUw4VE51YXVySkxiRk1FczQrOXo1eC91VGxDWjJhNGF0RXZEeXZHTEg2WXBw?=
 =?utf-8?B?ZmZocTFmVXpYNytoMjRQajhjMGw3WTNMWE5uQk01SFFkR1h5T09Ib2JjaUxr?=
 =?utf-8?B?cnZwQjVCSlk4YnpEZWU1N0E1TDhUY01mdWhWUkxZc28rSUdCc1BmanByOWtT?=
 =?utf-8?B?OHBkRmVtalJtRUFHdjZVZFBQSnZ0ZXMwdDEyWWpDZk0yVWtBTlhmUVJ1SVZy?=
 =?utf-8?B?VDB5eXA2SXRldlF0Y29Gem1JTmxEeXA3bzhYS0JnVkdRNlZ1UkszdjF5eEJU?=
 =?utf-8?B?ejR6bU02R3pHdkxPMzJXelZVc1liSUlVSktoUjNsQS9XU3BtTnJueldiTHhu?=
 =?utf-8?B?T3dzS1h2UUt6OW1HZk9TaUxRVkRQVHpoV2VYb2EwM3gyMlErVmw2aVRZeWJK?=
 =?utf-8?B?Tk0zQ3lxTTRtc1JrRjdpMFAyN0hxenBlOHV4VXF6VWNpRlE5OXZMd3laWlpt?=
 =?utf-8?B?MGRHTXRRQTlNRGJkMG9NOU5TRmNFNmZzMU4wNDNOakxweXlkWThndVlmWFk4?=
 =?utf-8?B?N09FYUpaUEFla2JlVUxVMXArUk1vR1dqWXcvc3NCbHdPNmNzRUo4b0tyczR5?=
 =?utf-8?Q?D7BFJIPjQq/KtYYH4zqmAwfilMQqYTji?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHdUbzZWM1B2ZE9pcHI5c1hmcEdia0QvclNyL0NMWHpWaTAvOW92VTVOeGhw?=
 =?utf-8?B?QkE2dVQxbnB6SUpGNDRJK3JQcUFOZHVCaEprc05TOXVVMEo3SEIrYTUwd21S?=
 =?utf-8?B?ekJwNytZUkcyQUZxZTRCMmgraXRDY2g4WTlSZHZUL3dQd2IzK1F3NHVUY24z?=
 =?utf-8?B?TDJ3S09IblMwVFlYSFhzNGxOYWdRZTVDanVvdlhrSmJacm5ySWcwNDY5T2Z3?=
 =?utf-8?B?dkZ3c1EvQU1hRkdIaVM4QVo4VGZjMWdvKzhlRDgxQnMzQjZHTWsvQTZwWkgx?=
 =?utf-8?B?Ri9DYk9oa0VNek1aSDc2TGwyK2kreDArSDZETHRxYVZMSjFQSnB1Vkx6eG11?=
 =?utf-8?B?R3QzZzhxV01oVUZNcy85ckljUGxJekZUYmRpRWdrKzFNWlFEMnpJVVFsV05K?=
 =?utf-8?B?L3ltNHhQQmY0K3Izd3VnUnJ4bVJsendlc2VvSTVBanZyNWZ5MHlPeFRWQmJK?=
 =?utf-8?B?OWdJRGNLTXFNWTZDYXFGakkwaUwxR0NTQnB6UVBTZHdQOWJxMk8yeHNCdzhP?=
 =?utf-8?B?a2MwYXdacXprZzBoeGRtcUYxcURmZEhKeFJ2WWhzditwbTZKYUIxRVZhSFM5?=
 =?utf-8?B?aWpvUHo5WEt4amJ4dENIYWhPdlJCWjBia3lXS0wyYitHU0VCQXFlbXZLbS95?=
 =?utf-8?B?ZWNxY29JdU1Fb3g1RWpkYVFvQjJqbXdsQ1A0RElkUjZ1QW0rVHlVZmIzK1FS?=
 =?utf-8?B?d3BUSzNxaEVKYXh2cThrRjVsazJhNEIwbFo1NlRzZWRxNEVXY250dHkrMVFL?=
 =?utf-8?B?ZmFXK1Z6NU9RbHFmbkpycmxwWE5hMmNmUFZMdnVsZk95a1M3aVdhdit5NXRz?=
 =?utf-8?B?MGxPdS8wSnVZdUdRZnJPNEtlQkh1bWowWmZxOW1aYXFoZG9PMXlkWFB0SEk5?=
 =?utf-8?B?ZkpKUm1lanFseEFHOHhwVDV4SnVMaGwvZHQ5bHZna0tjejJOZ3A2THJWaFBa?=
 =?utf-8?B?RnEwMHFGZ3k5OGpISklCQVRKUUc1MFNHNHNwclJCbVNjcjErZlovQS9rZ1BV?=
 =?utf-8?B?NzZjNDJyK3pPVkVTYzc3anI4NWlIejJMMlpmVDF6eCsrSGhSN1NqTkdUeWFp?=
 =?utf-8?B?MnB5TUIrbkRRNDZ3M0V4OXZERU5KbWhtNm0wZkpiQjJFRm9xWXNlMkxTaUg5?=
 =?utf-8?B?dTRTMEhzRm5qOWZBYStHVUVUYTVpK25OV0VLSWpKN2xUNk1jeVQ4Q0NFUGh2?=
 =?utf-8?B?NUE3WnArUXZXR1FDajVUWXRqaUtnenp2OGcvZUphcitJSTZmQTZ2WUhMbEpE?=
 =?utf-8?B?RXg4UXJKMTRGL1JNNC9uaUZlWGJQU1UzdS9SZ1JsUUhKaWphL2dZZW10MjRE?=
 =?utf-8?B?cERwdXNyRC9NbWFubG4xN05teXJZck1zOUFQMEMyaTZUM1ZLRUs0amwvRG81?=
 =?utf-8?B?d0dWMkFIMjVSQW5NbVZOZ2ZFbVEvdk1TdTZaQW1WMGcrWjBiNEZERHdPWmlk?=
 =?utf-8?B?V1ZzcEJ1TzF4Wi9WdThVQzY3Tm1aWUlZRm1STFpEOS9DdE1yNWtZVGwvWldk?=
 =?utf-8?B?MTdtT0lFakRSbnpLa2gxSW1aMXc4dDhSTUFCZkRyY1o0YS9yS0dqMk5LZDQ4?=
 =?utf-8?B?TnN2ZER6emJZMmZqUkUyR2Z5R0lWVWkxL1JJUDQ2eDNkV0Z0b1RFU2RlZTRy?=
 =?utf-8?B?NnNuTzFzTnFueERIMmg1YVoyMGV6b3FXQTlkOFNURVdPTzVrRHJLcDc0Y2hm?=
 =?utf-8?B?Z2VaRjYxSDRGS2w1M0liVXJhMWZKZ05vclFDRTRFRHM1Z2FocFc4OU1XNDAw?=
 =?utf-8?B?c0txQi9Rb0dDQ1dVVzQ0bHoxVnI5cVUvdldjdE02NFJxR1grQUtQMXB2RFpV?=
 =?utf-8?B?V2pVeHp3REFCdDRhWG4xR1pwQ3B1L1lEOWYzNWFmNlhrQmZVd0dTdjV1RXRI?=
 =?utf-8?B?bE8wSlg5cEF2dHJiQVdyd3U2dGhCWXpsSXRvQnRrS2E2VVdtYTJNeVhJYlJT?=
 =?utf-8?B?UEl2dlRVUXJVN25aOEZMNHBOY0xrNXBKRmJtQ0NJc283R0V5bzQzRkhQaFlL?=
 =?utf-8?B?bmpLRzBvTVk0TUtmcVMzQW5XelZJbTcrQzJUbXBFYW9MdGRNMmZXa1lYTTV1?=
 =?utf-8?B?Y2NnMWJ6SE5ucnNtMmFYOHlQL0RXNGY2QS9HeFgzeXBLOUZIaUpObGd1cTJr?=
 =?utf-8?Q?sB4KEmiKPZ7bFUx1rXwq+AQO2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0544D346E1F234B8BAB37DA53DD46DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e80301ba-7007-40d9-3bbb-08dd30587d7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 02:51:17.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBIgagRw0LGetW1ennmPQTVryX+TkPZWw9F2PKSsdQ5Ei/eeMEIizFN3rXHkw9j4pruRCDdCtaUtPVr7ZQAjvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTA5IGF0IDA5OjA3ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQo+
IGluZGV4IDQ3NGUwYTdjMTA2OS4uZjkzYzM4MjM0NGVlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vbGFwaWMuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiBAQCAtMzM2NSw3
ICszMzY1LDcgQEAgaW50IGt2bV9hcGljX2FjY2VwdF9ldmVudHMoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQ0KPiDCoA0KPiDCoAlpZiAodGVzdF9hbmRfY2xlYXJfYml0KEtWTV9BUElDX0lOSVQsICZh
cGljLT5wZW5kaW5nX2V2ZW50cykpIHsNCj4gwqAJCWt2bV92Y3B1X3Jlc2V0KHZjcHUsIHRydWUp
Ow0KPiAtCQlpZiAoa3ZtX3ZjcHVfaXNfYnNwKGFwaWMtPnZjcHUpKQ0KPiArCQlpZiAoa3ZtX3Zj
cHVfaXNfYnNwKHZjcHUpKQ0KPiDCoAkJCXZjcHUtPmFyY2gubXBfc3RhdGUgPSBLVk1fTVBfU1RB
VEVfUlVOTkFCTEU7DQo+IMKgCQllbHNlDQo+IMKgCQkJdmNwdS0+YXJjaC5tcF9zdGF0ZSA9IEtW
TV9NUF9TVEFURV9JTklUX1JFQ0VJVkVEOw0KDQpUaGlzIHBhcnQgc2VlbXMgbm90IHJlbGF0ZWQu
ICBJZiBpdCBuZWVkcyB0byBiZSBkb25lLCBzaG91bGQgaXQgYmUgZG9uZSBpbiBhDQpzZXBhcmF0
ZSBwYXRjaD8NCg==

