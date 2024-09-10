Return-Path: <kvm+bounces-26433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CF397470D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D9C7B255B6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAFF1AED22;
	Tue, 10 Sep 2024 23:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EtXSgpgW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8A1AC893;
	Tue, 10 Sep 2024 23:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726012688; cv=fail; b=lOwJiiXy8jgGppV1IyYDmMjuIrPxt6p77MAaEmSUgGFOHpB48uYTvUoa0gv/lmuJGZmLNRp+6tITjQ1itsnptk5EQvz3Fr/hxwasDNhRKR5+Phk5GVL3g/OfJJnleip5+wcLmBrGiMyIDoh6Aq1sPkD1+raptVGER2/jMz2M57Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726012688; c=relaxed/simple;
	bh=3er74u+I81LqWEFfcLPDoIxULB2z322MkU/SQHlg2UA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eu0YFVwUTcOPLJ8J+qVMr8UHbpQVm1hQMIXhoaSSFpcDlWvSKCV38bub+U9aW0uYfEpSFHNDk01g6QPajsJbu4ok1j64ls7ZEKB4XCGAy54jjEMQTKBYsJX5GrKkjol+c+ptbGKlj6+lj1HOc25+E0+hDDymX9IH/C33MQHX0Cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EtXSgpgW; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726012687; x=1757548687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3er74u+I81LqWEFfcLPDoIxULB2z322MkU/SQHlg2UA=;
  b=EtXSgpgWvIBRq7WXbOR7C83Qb21aIuKYnWGtph0IqdjadZGik7/jOU/w
   6ZJQKBNcWfgYyqJ2PC+tiSg2FWfywM8pLCgesHTDDP6FfRZVy07o5i+8m
   BIYYsCULqZpjfJnM6XQUeEyq0TX2Yzn8NNHm0roGGGz6hwSFMxDCStCR/
   tpZvMdRD7p9t8uRIolGa6NJHqFK/b0+XjWM4LYS/9a/3k2n0lkLnuf9OM
   RLIry4/gf7sIbZ7/lZGBHujvJw4VsEBBzierJzpgo18G59Um/DHsyt44B
   i7VwVNw6kLFuTxo58U9xjU+f+JJlVqlwbSUJlw0qUbTfjWOhiImqAhNRh
   w==;
X-CSE-ConnectionGUID: +gqjpZwYS9apTepXgAw/Ug==
X-CSE-MsgGUID: GbG8i1XdRhOqMPQ4QGPmQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24895106"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="24895106"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:58:06 -0700
X-CSE-ConnectionGUID: PTIbNcfDTW6go95rmko5Vw==
X-CSE-MsgGUID: xtcSDQYcQB6o1Uj5HkLGgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67425677"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 16:58:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 16:58:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 16:58:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 16:58:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 16:58:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9yvCQpmTAk3+iI7BuZmsBDrEhaD1QWv6+K903RmzR1gDSnj8qV838OsI3O+wBQZKTsck+6Updr9AFBVv9EB+/IV7oRbSjzwUmYrQhrcpe/aOslUDRyQAW2as5s1vZ/OglfWQRQ+Mn/Z6YnjJf/NpopaIckSMPdekh2kwSbx1kRQpPPlT2pXxD6Kvsd0S4cdH27psGQJW1zc8r1vBiGB/3idP6Zo2ibxK2uslI0ybl0eHxxCMLr24S+eO+h2ZmrIF+sQwzCjlcT2tctXr4aBejjktNYD/4qYVGt9ZgzBREV26jnzsAE9GxQXg8g+DsBJPQ1735ZiLcg9utcLXtvwAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3er74u+I81LqWEFfcLPDoIxULB2z322MkU/SQHlg2UA=;
 b=gbrne5gJ4lNC6nEgqB1qroUUWrr5DY8s77x4dn48roJVFG708u7pefZyZYJWSilmASpT18aSQqDH+9OzgZGmFmtDIaWEox7hLEHnQH9ItEiswYF2Ag/muLuwPFEyo/8mCfAuHX1aVqb5i9/g39iQdDH1M4UIyq/HvoDTZAsSYq54OO8mAyP0XC7mIQMWRb62ZFMsZU2Hfd3qt3oNar/X2anbE1Lv9sStgg834ixCKrDUSNm+ACCRtfnAZiMFVt4Ou9GJFlvJ3PBIpWOkToxCZq4wb5YKLztjPDqK2k5mc9nWde7Vj3xG5IaNyKHhpTfTPUhk5A5frlz3X75ck6iKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6978.namprd11.prod.outlook.com (2603:10b6:510:206::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Tue, 10 Sep
 2024 23:58:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 23:58:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Thread-Topic: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Thread-Index: AQHa/neyIdr6hdDmIkGAByVbUnUe27JKBtWAgAXzzACAANFyAIAA8YUA
Date: Tue, 10 Sep 2024 23:58:01 +0000
Message-ID: <4b2bea4b62445db76b5ac5c6083a72ffffd8f5d0.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
	 <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
	 <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
	 <128db3b3-f971-497c-910c-b6e2f9bafaf6@redhat.com>
In-Reply-To: <128db3b3-f971-497c-910c-b6e2f9bafaf6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6978:EE_
x-ms-office365-filtering-correlation-id: 708eb9af-fd5d-445d-1830-08dcd1f46755
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUxJanNsRm9IaXE4TEJFSmpJSWtzaTZ1N01xVTI5WU1ucTE4b2QyT2ovc09C?=
 =?utf-8?B?MGhaamdwS3FHcFF5S25CSk1vY09OU25PN0F2dWhxOVA2Q1JaTDJ3OXRjMlQy?=
 =?utf-8?B?UlZIK0pZb3hhdUxLNi9ZSnRYb2plaTdnSENUNnRHWFlxZ0tkbVpZM1VUYm04?=
 =?utf-8?B?eWhzWHZSODVPNHdLaWpaT0hXMUFuMTJydzMzRnJsbHN6SlRoUXR1dEpkUzha?=
 =?utf-8?B?ZjhrN0dXc1pLNmtydThsY1A4RWtEWHc5WVovYkJFeGk2by9HWmJOZUljVFpJ?=
 =?utf-8?B?ZmtKNFRMeEd3R3BYb0l0cDV4elp2cVVwZnZFbGlTeEg1dEJFTFhqYVM1Nzly?=
 =?utf-8?B?REZuUWoyRnN6Yml2WHdsT2ErZDNuMlo0bDMxS3EvUmpJVDhTdjRCVmhzajlP?=
 =?utf-8?B?NlhLeGdra2FSQzZhYzJsNkxZUVhsY0x3eHpLOS9yYkZWcXovVzQrWGhNT1JZ?=
 =?utf-8?B?eTdJUVVvSVF3NFpBb2E4djgvRFN1V0ViNlFOU2gzRkVIaGZUVmcySXplRUhy?=
 =?utf-8?B?SFB1LzB3NjRNTjdXcjd3cVNIdGI0RklkVmh4REdPU2UyYm9OWFFHTnRBWG8z?=
 =?utf-8?B?S3BXa3Zwbm8zaDZWMEpTdS9FUkpjaFVLdC9IN2ZCUFIwUFR1SkJwOWdxaW1q?=
 =?utf-8?B?WFlxa3d3RCtIMUFSb05oYmt3MVEyWVVWV2EvYUdNRlNYcy9ITmtpZThIeG05?=
 =?utf-8?B?YVB2TjR3TG1VRnd4YlpseTlUYWM2TzdsblFPVElpd0ZxK2NiSFhpQ0xrc0pu?=
 =?utf-8?B?QjFtRmJObDBiVXlwYTZ4Y29hL2ljU2FpV0VnZUNFcW52bHloa2V3Q3lzVU1h?=
 =?utf-8?B?bC8zY0tBYmJqMmZCY0kwNlVucmQzMEFpbzRIT05uR21PZHk1b3NMRUlUY0hl?=
 =?utf-8?B?aG9oVkZZUDhlYURSdjNFMno0NjlqTjBveG1QYSt3eVlDd0ZaKzJkR1hnOU5o?=
 =?utf-8?B?MjI5ZkxCMFc5ZmtodFQzR1lRa3hpSG9rWi9jSkk4bDJQV0NPci9EWTRhdUNL?=
 =?utf-8?B?NWUxV1B1Tmxzb3ZjM2lSM3hKajJzY3NlNDE1clcvajl2eVZwYVl3NUlGYWVV?=
 =?utf-8?B?bHpRWmRVajExR1JMcFFoU2JrQ1RVcGNTbE96Nk5EVEp2c2swMUxpK3JJWHMr?=
 =?utf-8?B?eXBYcHVLYTdYU2Znb2NjZHpJclg4N0dGM3pock5wdWtKWm95YW1pMHIvQjNJ?=
 =?utf-8?B?QzdmZEJlRW9Ydk5RYncvR1ZVWVNVbTduYmRhZGFnbzVTNjg1MVZaSWdFQVhl?=
 =?utf-8?B?bkpCbTZBZEIzckJaYld4ZlRyV0ZhRmZwak5ZVWZmVDJOYWEzSGwzdGNsTXlp?=
 =?utf-8?B?djhmRTVDTU84YVB5Q2FZckJ5ODVMUlErVFdPa3pidmZpdFlkWXlNRlBubXFD?=
 =?utf-8?B?UEZqWjlMeTNDQTM5a2RpWEpSbnBEczUvSlYwOFB6REhvRTdrUmJibG9CZ2Ni?=
 =?utf-8?B?S2FUbThac1BsU3ZJalpON24xV2FwVGRsa0RFZkJRbnl5bU5rREVsSDE0WjI0?=
 =?utf-8?B?QTdUMURqbnNtbnd6Rm45SXI0a1VRdmtibnBzcHhkYzlxQmtFT1EwSm9LMVVm?=
 =?utf-8?B?NEtSTXFNblVmS0dCYnBKai9TMnJwem1Rd3hWVEVBQko0cmw4WnhkUHd5ZnlC?=
 =?utf-8?B?OUk0WjdVcllpcUlhR25NSCtTMDM5Y093bE5hMFRaa3VyRDZOYy9USEUyTnRy?=
 =?utf-8?B?ZHJLU0F1NC9KNWNBWWxtNTZKdDREMUNEUitaOE1kTjBrdjFCblpFSGhDTkVV?=
 =?utf-8?B?NGJ2NCs1SHJZa1VrU2l4WVByc1plbXBmLzhvR3pmZmw2T1ZhMitLdnNJQVBJ?=
 =?utf-8?B?OUJOaEN2eldrSks2Rmc2N2REUVROUVJDN1FIUi9oeko5dUs2eHBieXc1WXhJ?=
 =?utf-8?B?ZUdBWDBJekh6TVFwMjFpN2ViWVFUMVNoTTNnVVJ5WEowU3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDdBMk4wVEo4ZTFkV3RwekZpTmxFQ2daVGJENk1aYW9jMWtTbVpScUExajFx?=
 =?utf-8?B?QXAzdFlsMEsvNEwwMDBSY05vYXhYVXdaSFFXVmlLMnByVW1hdXJrNFNoMktQ?=
 =?utf-8?B?MjMxanB5MDZCTVNibGQ3K1l1WVpqdTgvTHJ1K1crYzlVSEx0eXdJQ2gyL0Nk?=
 =?utf-8?B?V0lBWHNXQWZITzl3OElHSmpUZEV5Y0MrWlJ4bWgxV2F1Mm52c2dlMFdXc29T?=
 =?utf-8?B?bHJOOWptQ1JrTlpYa3VCUlpPdjd6aHFwTjBJVEdWV2YveThla1ZpVWo3SEZH?=
 =?utf-8?B?VDhNTnJ5Q2xacDFHeWRMMlkzWU5RWEZNMXdNb2RIYlhqY0lYYS9idnlHL3U2?=
 =?utf-8?B?T2RJOGlHKzFieWFoa0o0MERxL2loeFhBWGkyaVErNzJsb1hqdmRPZjg0cTBF?=
 =?utf-8?B?UFhtVHh4aG5RblFIVXYzK1FSb01ad005dldJZ3JGYngvOTVOQWRrYzJuQm5h?=
 =?utf-8?B?NnlsYnhFVFlQUTFjNkpaUkYrc2JuRUdzdkIrL29teXpTT2tXZ0JEbzdzc2pP?=
 =?utf-8?B?OEx2b1oxalFzR1lhc1pXNXIwVG5zZDMrZzVPRFdiY2trUDRtZHJ3ZXBJOUdx?=
 =?utf-8?B?cnVJYUY0Zno5SkxQblkxemlidHcwVGovNmNGVjAyQ1M4dHkrNDRPQkFpajNq?=
 =?utf-8?B?VXdyTk14MUFGaWlzYkl4MG1HbzB3WnIvM2VpTndMZnhDZjNqamUwRUtNait1?=
 =?utf-8?B?bTd4ZzlOZEc5K1ZJb1BGWHQzcWZSY05DSTNuQUR4NThKOHZ1b2ZYWlNvTGxz?=
 =?utf-8?B?SGdjRmJnckNwRzVBbzBmWkd1a2tmT3BRMUZaeFJob3FyTEw1NjRZQWhLa2JD?=
 =?utf-8?B?VEdZbzhEdVJoOWR2WllaUUxhYjNpM0swYjJUMk92aVZ2K3pwbWFIN1JKZkNR?=
 =?utf-8?B?MFh1aGVVT0t4enVsZjNFK1l6YnRRNDZEdSszNGhJYjJmcnBaeEo1REFaY0Rh?=
 =?utf-8?B?alU4emdhTTMxZ002Z1RocEljWDFZMlJUWUx0NjhFaU9zMFhad2hQcXRqc09q?=
 =?utf-8?B?blduekx0Wloxd0ZXREJYbVdXWkNhenVGclNLTFp2Y1lsb09Ccy9xK1J5SzI1?=
 =?utf-8?B?b2QvZnZVeFlJYjNkNjVlbE52OGdiL0RKdGtNdW5IWHYwUHI5Y1NnK1ZkZlJV?=
 =?utf-8?B?dld5SHVHQVk0SklnQmhhSW5ZaVV3UW9aNDFJZWIyaFFpcFd0ZUtRVjNLM3k4?=
 =?utf-8?B?d2gzMy9vdHBBeDRvNE9pbERMRXc4ckpBS3FDcjFqOHR5TzZrQkhROGVuSkJI?=
 =?utf-8?B?NVhLMVlWSFA1c2Y5T1hnTVRBYUNNdStQZ3pSa1RkZStxVmNNREJ1ZDZxYndB?=
 =?utf-8?B?YjMzdGNXREt4aTdKK2RNOVFsQUJwV3Z4bnJvaVhWQmhiZE5RRm81YmdYanl5?=
 =?utf-8?B?YWlxMnNRR0VvenpaQWl4blNZZE1kMTRqejM2WElqa1d3eHcrUWdvRFlwbW5P?=
 =?utf-8?B?OEJoSkxsOTZlMTlxSnI2Y0piamR2YmhvL3BvVCtuenBHUkVudEtDTk91U0VT?=
 =?utf-8?B?b1hwZVV5WnV2UFBFeHIybzE5RmFhSjgxb0VvS2hsYmFkVVhHSjlNOE1BSVox?=
 =?utf-8?B?d1ZLYWpwV3c2a1pTcnprK25uV2hxWXdjUUZlL3ZRUERLRU5FTjlBNkdabXZR?=
 =?utf-8?B?K3ZQRmxKMlVsbU1WSmREK1hXRU5rUUVBd2FnOG1UM0lNbjJNMjY0VHBoNksz?=
 =?utf-8?B?TFBTSzZhTDhlZDVoSnhKbTJaeW9FNTF0QWNLYTNHenYwallDZ2RwdHF5R2pk?=
 =?utf-8?B?aWFPdm5vVmlHNkFRbXpsKytLc0dmT1N2TVFRQTBMc3ptOGg0cnpVQVdQUTN2?=
 =?utf-8?B?Wk5LQ3lGWjJTSENxNHBOOHdRYS9IcThXQVV1NDh0dnZBczFaSngyYkVaNkFD?=
 =?utf-8?B?V2c2bDB0WkxIL0U0VU9EZk0rUjFiVWE4MURUTkR1QkEvcHVNcTZsY3NhOUdW?=
 =?utf-8?B?WEdPMHhGVVdDUVpPa2RxbWZxanFFODd1Mys5eGUwRGtqc21SWHExNVJ1Nmd4?=
 =?utf-8?B?RHpPR0lhR2d3Qjc0Z2FQcHArNG5IaUpxek84VFFRNWlSc1Zja0MzWlp3eFpn?=
 =?utf-8?B?L0NMOTkxU21XNHBrc093MUgzVGZTNTVEQk1ZcTVpRitneS9VR2RxVU13YVNa?=
 =?utf-8?B?SVAremtVenhoV2RTNVpzOEZING5tYmcreFlrd0RhWStKSGZoZ0FMRTZyVHRE?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5A2196DAADFEC49AF7B5ADE72AD8702@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708eb9af-fd5d-445d-1830-08dcd1f46755
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 23:58:01.5037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oRyqqOoHIyACh3orU3+iGlAmQwKeKF4U/mbCymf5A072+EUvPDtYUrmfMXdFQRwMHIDPaAH2sXYzBdU/6cRlL1TgjolIFJNK9ZGRf1LH7SA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6978
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDExOjMzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4gQnV0IGFjdHVhbGx5LCBJIHdvbmRlciBpZiB3ZSBuZWVkIHRvIHJlbW92ZSB0aGUgS1ZNX0JV
R19PTigpLiBJIHRoaW5rIGlmIHlvdQo+ID4gZGlkCj4gPiBhIEtWTV9QUkVfRkFVTFRfTUVNT1JZ
IGFuZCB0aGVuIGRlbGV0ZWQgdGhlIG1lbXNsb3QgeW91IGNvdWxkIGhpdCBpdD8KPiAKPiBJIHRo
aW5rIGFsbCBwYXRocyB0byBoYW5kbGVfcmVtb3ZlZF9wdCgpIGFyZSBzYWZlOgo+IAo+IF9fdGRw
X21tdV96YXBfcm9vdAo+IMKgwqDCoMKgwqDCoMKgwqAgdGRwX21tdV96YXBfcm9vdAo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV90ZHBfbW11X3phcF9hbGwKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2FyY2hfZmx1c2hf
c2hhZG93X2FsbAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2ZsdXNoX3NoYWRvd19hbGwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBrdm1fZGVzdHJveV92bSAoKikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBr
dm1fbW11X25vdGlmaWVyX3JlbGVhc2UgKCopCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAga3ZtX3RkcF9tbXVfemFwX2ludmFsaWRhdGVkX3Jvb3RzCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9tbXVfemFwX2FsbF9mYXN0ICgq
KikKPiBrdm1fdGRwX21tdV96YXBfc3AKPiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9yZWNvdmVyX254
X2h1Z2VfcGFnZXMgKCoqKikKCkJ1dCBub3QgYWxsIHBhdGhzIHRvIHJlbW92ZV9leHRlcm5hbF9z
cHRlKCk6Cmt2bV9hcmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KCkKICBrdm1fbW11X3phcF9tZW1z
bG90X2xlYWZzKCkKICAgIGt2bV90ZHBfbW11X3VubWFwX2dmbl9yYW5nZSgpCiAgICAgIHRkcF9t
bXVfemFwX2xlYWZzKCkKICAgICAgICB0ZHBfbW11X2l0ZXJfc2V0X3NwdGUoKQogICAgICAgICAg
dGRwX21tdV9zZXRfc3B0ZSgpCiAgICAgICAgICAgIHJlbW92ZV9leHRlcm5hbF9zcHRlKCkKICAg
ICAgICAgICAgICB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKCkKCkJ1dCB3ZSBjYW4gcHJv
YmFibHkga2VlcCB0aGUgd2FybmluZyBpZiB3ZSBwcmV2ZW50IEtWTV9QUkVfRkFVTFRfTUVNT1JZ
IGFzIHlvdQpwb2ludGVkIGVhcmxpZXIuIEkgZGlkbid0IHNlZSB0aGF0IHRoYXQga3ZtLT5hcmNo
LnByZV9mYXVsdF9hbGxvd2VkICBnb3QgYWRkZWQuCg==

