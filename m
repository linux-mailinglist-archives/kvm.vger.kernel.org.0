Return-Path: <kvm+bounces-32977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D5C9E30FB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC69283F99
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015A742A97;
	Wed,  4 Dec 2024 01:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jo9EGknO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB6B38DD8;
	Wed,  4 Dec 2024 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733277508; cv=fail; b=QCzQ7UmZjx6vBtJgyEjMhl+8MlHvsqgy+YEcW/tJrrVPsiE7H+q/xplIRs7fZa2q8MW5PNAGPS/F3DYj81+LhBdnkwHr3Un2gcd4GcOV/evqHa92dm/Uxmc+dtjD9M03aTeQcKPoDhHOgn3wJZhubUCFFeLMr+61Vkx2zmOodiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733277508; c=relaxed/simple;
	bh=nj+CGvJYhfYhkaloMx0hvvOWVaJ/RIp/lWZBOLyAhNE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uDtrZ8wOdD12YUXukjgINDnwU/RLcN2hDfyrDGf0HvR0Ng8hwoVpH2I1kKNUvr6V1jnag9ZCE+d4LGoMLBFJUWfVy26lkmfNRXLN/clDSEOPhWFAotTVMpP4mgdn1mJfroMiPWyJuGdB0FarQ+LMZ1AlF4snm9UZKJvkgGMZKzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jo9EGknO; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733277507; x=1764813507;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nj+CGvJYhfYhkaloMx0hvvOWVaJ/RIp/lWZBOLyAhNE=;
  b=jo9EGknOI78bDKRJVgmGIdmp6BN5u6hZmH5W+/OxhCnOiyPm8TNbmPZi
   yobmo+F48Hmula0mwMvB078qQaDNfvRqWnziXtGS4ArQele/KfsuZmneQ
   uDl1g8KPWcCsUJtxV5lZb5QIgGyCGZzAv+PHhhgpBEJdoXS4BMzziUk7Y
   CNCtSvvA1M2dtM6j9vB9MIjdIi3E2BcntIWI7FI2ygxB5EkYJfbjE8xnP
   zErikBs+qyJMgeSW67kzuXOA0U51K9znJkz5ne1YIulXuECZ4Md6P+aEK
   yc9EYjUqMW8ryL75mj9KbgbaBhBpyVK4Z2uRnQnlfNmvXYTMy5cO1r6dP
   g==;
X-CSE-ConnectionGUID: 602f5k5FRB28n6FonqDNtw==
X-CSE-MsgGUID: rY+q8yZrR7yOZie6b3MudQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37294954"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="37294954"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 17:58:26 -0800
X-CSE-ConnectionGUID: VBvVgsj+SYeRQAI6XK+xnw==
X-CSE-MsgGUID: M2bjD8V6SRKTuNslLBJELQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="124447116"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 17:58:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 17:58:25 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GKNXY/ZfPru5WaW8LmLf5fpiq8H6Ro7Weo28qEY/uSZg5b4TW7kVEfQPi/0baC580Ng9VERaLu+OoqEnXsn/6WAoNeW/peFc582XvouBm+HZMSLMQS+E2Y+gcGfz/ZTKRA+0m/3FCthXoXUF3FmBvnCjOTqN2v8utqhQ9/+6f6nG6VGkITwT6TXnmaR9eU24wUZgCncHE7gSvz5KvGnKrwhhvlvB7PAKqP3nC5hhpRdWeBo3CJsnWyoXzWj3Zr8YzGzTy89mdBrZE6WOrMFDGwFHoXYoDBVxip6w/ABMnPLwxB3EAkpYc93Fp9bK8IIiiCa/yeaO7mfIsV9Mf7sVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nj+CGvJYhfYhkaloMx0hvvOWVaJ/RIp/lWZBOLyAhNE=;
 b=tyFvd9vQzlKvUxkbczrrXChkK3BjVOC/imu2lRawDuYYC6yuPPVmPvArQ/9wCHMII4b4BkdmcZIrXSxcJvQJ9tEWCNagIrtEaNyo1Fp3WP2FQS9GA/fbJMGVEKYOKN6bY5tw1EcFV4+GK4Wamdb/w510aWsDhQNonEu2FcYjSG9ng4Tgpchopr2zb2HAXi6uteEbLOCy51XT5IRlbBloAbVb2igeKzPBKhJFWI7RH4lv/mPWqK3Vb1zA6wfMbg6YEgVjmqFuZpFk5w51GavIw0mAxch4F9lk+KZe6adaUQumx1b8z4ulUSQalTsQIEabZnHn/G5rV8lkGDOgBUNgqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 01:58:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 01:58:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "yuan.yao@intel.com" <yuan.yao@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Topic: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 TD creation
Thread-Index: AQHbRR86MNs4refpEU2Wtl2ccm6Cc7LTybiAgAGMCAA=
Date: Wed, 4 Dec 2024 01:58:22 +0000
Message-ID: <c033876cfab1139af4a812d9f164ff746203347c.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <20241203010317.827803-3-rick.p.edgecombe@intel.com>
	 <2863f94b-c01b-45f8-90fd-b237997d76ec@linux.intel.com>
In-Reply-To: <2863f94b-c01b-45f8-90fd-b237997d76ec@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 49918d6e-fd38-425d-a92c-08dd1407224b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MldUc1UxczQyeGxwVmttcCsyT0xxTG1SUE5GWC8zRjJQT1A0aVZRU3NQWDZy?=
 =?utf-8?B?WnRjVlVZbWRzNkIzKzVsTHlwSS9BcjJMYjdCMElZd0NXNlFNajlCdWV3SGx5?=
 =?utf-8?B?aThuRWFrcnhWcFYxTVVjdG05c25jR2w2eVk5Zm5sclBiNnI0VWZrditvOTFW?=
 =?utf-8?B?RjBVT01GRmp5S0lPZWlUSU1YdjdERzFsRzdZRjExWmdQMDd1SGcvVnJNM2xT?=
 =?utf-8?B?SHA2VjBLYWJhM3VQUk5oeTR6NW93MDl0SjBRM0g1R3NPQmtwUktQYkp1WTVQ?=
 =?utf-8?B?SlArblFmSi94cHFqYng5QnRsa3U4WCtPeTduWS9FNzhHL1ZZd0lHSTFGTzNr?=
 =?utf-8?B?V2Vsd1RpUS9Sb01FK1cwRUVXOVZqSm0yUUVXY2JNSTFJYXl3YmlDc1lRUDho?=
 =?utf-8?B?UHB4blc4QWJZQ281N2NLY0pxRnl3YnJUbEc4d0c0TFFUdkV5NmdQUUJWODFO?=
 =?utf-8?B?andSM005WVJzOUNpOW1KNG9BSGtZUUptNVpIcHg2QWdQL1Ruc2VFQ2NoOWJ4?=
 =?utf-8?B?ZjJKU1NSdlQ4V0lQaVVTVzBhZi9HWm1nZjdvYzFETGVzRG9yVkc5Ym5GQnRR?=
 =?utf-8?B?WXRTdkdpam82WHd0OFZDOW9mZVU5WDR4dE0yYk5qd3prODlYMUc2WWEwMFlh?=
 =?utf-8?B?TjB0cU55ajZCc3NJc2RMZHVsRysvaE5SSkt1RU1BTUlndmYrQ3Z4bkFUeFp6?=
 =?utf-8?B?ZW9uV1lnZmU1TGVhc2tMYUZweWZkNlA4a0J4YzhneVNiY3FtTzM3WlpiNWwy?=
 =?utf-8?B?YXpHTHRaL2VoNEEybDBIYis4aThSQTQxUmlwZVhsdElpQnh6TFNWd0ZDQld2?=
 =?utf-8?B?OW96ejBWemkyZnY5T2NNb1NHK3RoRnRwdG9aNGdkenFuUU1TVDh4aVBzSGRG?=
 =?utf-8?B?L3kvNnlWQnpwSk5RWlVwVGtGTGxBMGpiL2h5L3lIUkJXNXd2MUhnemF3VlpO?=
 =?utf-8?B?VTVYYnlQZk9pVVpwdWkxS25HdUsxcjk1WU8vUjV4Q1d0ZW5MRlN4L3RmY2JR?=
 =?utf-8?B?bmNISS90NUE0WGo1N3BQR2JtU0JZMXZnT1FhWTEwMXVhMEkwdXU1YVIvMWt6?=
 =?utf-8?B?dzYwSjBtNU40Myt5UHcyMjFLY1FVRHlyTXk0aHErV09WVDRSM3g5ZnhTWS9Z?=
 =?utf-8?B?YXZRWWNwbHpHZWVLUm9xUWQ0elVFZVQ5RFVuK3JzUWlxN2g4Nm1xNjB6VnEw?=
 =?utf-8?B?T2haKzI3UEZOVWRaRi85aWJuNWxKaDF2ZkpxT2JTckxuSjBPdWp4Rmx5Ny9K?=
 =?utf-8?B?SmdLQW04dEN3cUdBNm1IbkZEdmoyR3FOWFV3RjMwUFFRUElISmEzQ2hRalBl?=
 =?utf-8?B?NkY2TEhUbWlwa0wzeE4yNElBREVkNllxV0tob3Fsb08rSnNRb0lvOHZhWlo2?=
 =?utf-8?B?N2FGeFhlTFJ4VXljaU5sSlVGWW1NUTNtbHRyYVRIZFZDaDc4bFBBeU0zaDk5?=
 =?utf-8?B?dFlNTmQza0NJRXoybC9LQ29tVENROVBnNUVnOGMxVW0xaC9jeEUvSS9ROG5Y?=
 =?utf-8?B?b0Fsdmdaa3VmQUpmSENrNE5QL2Mrc2RoUU9lanhueVIxRDF6ZmcrUGNqVlRh?=
 =?utf-8?B?Y2dFM0lObUI1K3hYUWszeFRaT0J3SGFyYXZwRDFsazFlUXBRcDFrRldLQ1Nz?=
 =?utf-8?B?Ti9jOTdyV0ZCeVVqckVLanVBWWVSbEFBTUZmNVNKV0ozOFJvSUVYM05BUE4z?=
 =?utf-8?B?dmdhQnVKZk9lSXZ3ckJjU1R2QTNja1hUZnZsUjRGeW03Uk5HTjg3U2h1TE1B?=
 =?utf-8?B?RjdCakxGK1JqR2dCbDY5SDlqc05VYWVhbWJqZEFWWEJDRkhjcjZhaVpSNkNy?=
 =?utf-8?B?a2h6TVNKVi9WZ3hKMmFmSEpIUk5jNTNQNUo0MWZCS1NpM1JTL1ZGWkhaTXhU?=
 =?utf-8?B?NTBKVWRGSmtrN3hqYnlzV3ZYQk5PN3FheUtWSVZuc2NQZkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWlSQVBsV1RVS1RhZWFwTmlubVlPQ2NkdzQ4b1FRZG9rU1dxbDMvNG1rR29o?=
 =?utf-8?B?dWhnb0Y1dzI1T0hZYklsK0dUdG0wOVA2MzZ6OU9oZTNES3IyWWNoS1NxV1I0?=
 =?utf-8?B?ZlZrMzZ5VXBKR0ZCWHpjZ0hmRDlOdzg5S04xcWNzcE4zSzVDREpxMEtxcTFY?=
 =?utf-8?B?NlJOaHZicldyNFNCTG5YR3QrdU0zMmdIczFmZWFuUnp5UUVWZzdoS0Rpa09C?=
 =?utf-8?B?Q3dIQzJtMzZlYm9KcDM4RGVGMXRpTGZ2UklIM1JXa2tmMmJKNjhPeEdYdkFq?=
 =?utf-8?B?MDJlWlZMRXZyVXFsTkQzYzlEcXhhUDR2a3NPZU5EdUdkcitZWUZ1MWJrK0Vk?=
 =?utf-8?B?ck1TOU5OKyt5aXBtbC9UWnBNM3RSUUtnZmtVbTE0cEFIVGU0YUdxcXN3NDJ1?=
 =?utf-8?B?V0x0YlRyaGIwdDladGo3VmxoQ2NTWFRGKzJ1aExKeEhDdkNrY3hIeHFXdmU2?=
 =?utf-8?B?MlM4R3g5cEVTL2d0L21rcXMxTXBYNTB4YXVUL3pxOEhnMEVUS3ZnRVRRT2ZJ?=
 =?utf-8?B?bFlXeGFRYjZXaVEvb29VR01xYzZsQk5PL0p3YkJqWVJ0UjBiV2RkRFR3RS9h?=
 =?utf-8?B?a3BPQTBQNkhNcU1FSlBkampBSHozc2t6cktzZG8zcE1Sem1odHhaSGt0RDBy?=
 =?utf-8?B?bGJXU1hMOU5uWFM2YWJrQ09qQmVXanJENENiTHdMcFl6YytUNlgxcWN0Nzhr?=
 =?utf-8?B?SzRrUy9sQldUeEQveVpDM2YwSGlKQlVqd2Uzbk16WHFCMUdDUjA1VVFOM1RQ?=
 =?utf-8?B?alBSdm5kNDh5RU1TcU1xb2lnR1hLdExKVEw1bHhnUDlTQUtVcWZ6dHJZRmxZ?=
 =?utf-8?B?ZzJHSXJYQnVjc3pNSy9yNGk4VDdHSlYrSGpiRys0bWtUeXFMV0syYzhyWUk5?=
 =?utf-8?B?bmVlWkphbHVNM2V0UkN2SXBVZEt4aHRqWHM0NEU0bFN5eThhL0ZuOWRDNnVS?=
 =?utf-8?B?SnpUSmR6UXlpbDhycDdXQURBanJyazhVK1hTUjh3MTl5MkJuTlpsalZ0UjV6?=
 =?utf-8?B?SHBNVzNzNi9pMlpjYnpaOFNSVm9DN0IrRkxKclN5SXJ1TmlNVUlESXg5cmk1?=
 =?utf-8?B?dDhFa0RzSGdGcHJsTVJQbDJtSThpV3NhT2xiUGNvbVVMVy9TMGJvc2NtcFpP?=
 =?utf-8?B?NEVqVXc5L3JwVmVxYmhuY3ltVDdjVFFWa052L1hhNTJTUFNER2o4MVZxcjhT?=
 =?utf-8?B?Z1RJMllPa2k4UTY2eDdZcXpqRFJDcXBTaUF2VEFRelREbEFNSENHZTRYY3h3?=
 =?utf-8?B?T0I4bExCMHZhR3lZbTNwSVBoeWVzSmVGSlVMVkFhZURNaGN0T3hjZjJ4VldI?=
 =?utf-8?B?N1o5VHVDT2o1R3M2R2Z0RmhWdm9RTVRnQ2dROCtiOHJXYVI4Qk1NTWZnMXg1?=
 =?utf-8?B?eTZqWXg1c0tzWThsQjdkbzdFc2t0aFk5N1FnYlRLdEIvb3lrTGUyUXdRa2oz?=
 =?utf-8?B?M2JsZGNjRE9BQ0NqT1BSbDYrY3poSTdZY3lob3YxK2NJVnV0QnFzbFBHekNr?=
 =?utf-8?B?ZmFwb1VsSHJWTUQ2RW5QYUxibTJiQUVXcmJQL2QyY0lRTHJvWHJDMzlYZjl3?=
 =?utf-8?B?QzBDTmFGYy9LSS82UWhITWdna2d0SHBPYmI4TkV4aDJCdlhmWDBRZ0VOT0NV?=
 =?utf-8?B?SXdWL3BxRDNDWU1VTHdoVGtZWlNqOHh0WTFCTzZycUdFNlloN25sdDlNdW9E?=
 =?utf-8?B?cXc1SmJvSXlxVThwbG9RcWJXUGc4akdFNDcxQWJmWmlZV20rKzROcW94Q3Vt?=
 =?utf-8?B?S0s2VXNZdFFmY1U1YUZtbzJGNlFGU2h1YlBxZjZGbG80NVFXRFRHNHlNVFJW?=
 =?utf-8?B?VmZWV1ZULzBURHU4N004MzE0ZFdwd1AvcU1uSU9ZclpGaUNQdkt3N29CY0cz?=
 =?utf-8?B?MGcxRnN6c3VHR1NHVlo3TnJCZHoxQW41cEplTU16NkgyUk9iNzF1N29pV0tV?=
 =?utf-8?B?NDZycW03VWhTSThLd2QySFN1RHo0eC80dmtKMUdvWEVXV3ZiV1BTU0lVVEt1?=
 =?utf-8?B?Ymp4Z0ZUbWtzaC9LVG9wK3h5R1Rwd3VxUlBYTENxNWYyenlnUC9zaDhoUlIw?=
 =?utf-8?B?OWxlQnZmSFpPd0t6QkI3Z20xblpMcmtLSGtoZVZZZXcvKy8zc214a0xKUG8z?=
 =?utf-8?B?cFdXRzhUb0sveEw0Y0o4Q2FrUGhpRndycWt5YUxvQ0IzRGJsS3Y3Q0R1VDRv?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EC9C17968D3B44EAEEC51D1D1E8F8C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49918d6e-fd38-425d-a92c-08dd1407224b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 01:58:22.8910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ag1qTViruijq/ppr16Q/dFFmoHQrzwiKBdYt89ETiRf+lFTmdXZctbTOkwLwO4ItXmZMxn2GHzy6ycdgU+e/61OqrdP+AsAmxyq5Tm12VT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEyLTAzIGF0IDEwOjIwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
Ky8qDQo+ID4gKyAqIFRoZSBURFggbW9kdWxlIGV4cG9zZXMgYSBDTEZMVVNIX0JFRk9SRV9BTExP
QyBiaXQgdG8gc3BlY2lmeSB3aGV0aGVyDQo+ID4gKyAqIGEgQ0xGTFVTSCBvZiBwYWdlcyBpcyBy
ZXF1aXJlZCBiZWZvcmUgaGFuZGluZyB0aGVtIHRvIHRoZSBURFggbW9kdWxlLg0KPiA+ICsgKiBC
ZSBjb25zZXJ2YXRpdmUgYW5kIG1ha2UgdGhlIGNvZGUgc2ltcGxlciBieSBkb2luZyB0aGUgQ0xG
TFVTSA0KPiA+ICsgKiB1bmNvbmRpdGlvbmFsbHkuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgdm9p
ZCB0ZHhfY2xmbHVzaF9wYWdlKHN0cnVjdCBwYWdlICp0ZHIpDQo+IFRoZSBhcmd1bWVudCBzaG91
bGQgaGF2ZSBhIGdlbmVyaWMgbmFtZSBpbnN0ZWFkIG9mIHRkciwgYmVjYXVzZSBpdCdzIG5vdA0K
PiBsaW1pdGVkIHRvIFREUi4NCg0KRG9oLCB5ZXMuIFRoYW5rcy4NCg==

