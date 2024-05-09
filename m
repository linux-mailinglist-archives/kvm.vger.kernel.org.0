Return-Path: <kvm+bounces-17085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B678C0A35
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D5C28483A
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 03:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8575148318;
	Thu,  9 May 2024 03:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F0VLBemr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F489148305;
	Thu,  9 May 2024 03:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715225829; cv=fail; b=VOlEEAdxQu5EEF8sQR/U37RKnQ2TrOq8OCHFw/LnlYkW2W7r6OTKuDE7njHIWldyGHFomRyIVtuttw4lZdtj21PImJ7KhupKUB8feWfow+CSxwGZvBcHWyksocCk9rAyzQVqkBObWed0manCicfyrZ6s0oSeuh0su0Vrz7OIdvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715225829; c=relaxed/simple;
	bh=Kg3H8w3/TiiMzUL0x27jT5TnNvVL8EGm0a//D89I5wQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Comra4Plqte4dYHAmUjdZCnuRRaxyVjJWDiFONGkX/3nmf6Nb/FmbfZPtfrZYiQTl3BJHhm7OisRp7kYA78pcUNiaAAgISf8s3QHk19nhTRsyLKDLx0xyqsdlM6X+Q3KFKy0+7kdGllHliMg4l9rGndwEB869+GFpq5AdYu1XOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F0VLBemr; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715225828; x=1746761828;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Kg3H8w3/TiiMzUL0x27jT5TnNvVL8EGm0a//D89I5wQ=;
  b=F0VLBemr2GCy1/5M4GmpozJFDxGaFaokVYacqQj2qrm3Au0cY+sO9Fo2
   /EBBShBUUEqKzIX5JkoUbSEqnqSsrOZ8G180+vmM9Vt4QVR8qDNG9yIQ7
   gV9J9KLw7x4vsZx7NZnGeRydaAV6igpcIEiynf4j4MB4b81+uvQVEBCQ1
   LPJeVnoG43CtcRKqVJ2q7AkOz5yqkf7qD8Xv+Y/xzbQmvx98qoBhzT4p7
   SS2rZoeJTc7uphenicf71LJS5tccJVHCvU3d8zd+rhga/v470DguoVQHy
   QuAT2qnVoNR97N4LO1cfKNH9zJOpiDz73Q+TqRn2ze69PEkZBRHCpN5CV
   g==;
X-CSE-ConnectionGUID: 3v7lzHQJSUuYxLw52mI/mw==
X-CSE-MsgGUID: ixmtXK3GRBqu6Oqu3oaQPQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11248660"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="11248660"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 20:37:08 -0700
X-CSE-ConnectionGUID: Rp60fhBmTBG3gYvFJfvGCw==
X-CSE-MsgGUID: 1qjLackpT4aJFz/2XB86fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="29623722"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 20:37:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 20:37:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 20:37:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 20:37:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 20:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5QwjKW3U4ESq3k5Xtzta8PmeHvC5gQL90BAKCPFUCiMOl/zDQp28lgR8cdLF7xtG+RpEhMuNMeT10WhcU4k9Djq9VvN+Qk7B7wjXtJ8CoU9kaOn/8lXK2x+LSE2qv7KCiVU2JcBQw+UAf1UF33SSDKemCb6PvmKOHnpIm1dSvq+Dlte8TDLl/QWccSRcB58OzD8gFbFkfj3aWHXtVj5kk12oEzyD/laKxCY4YGQsDxb/sMOhR/8nuuzTT6VPnJN0t4PvH07Rgv0+TfmyjTCfStR92HFWbwaaVTHbCwSoRN5Xex/FFeEbhnM4Dcb+sY+VQbz2QgeSk1OwHikiMPotA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peu8ttwW2ZZ6e0EsNv0XnnEzpj31+D8Z5g31Lh/v/QA=;
 b=Ui4gBd/chglIvCp0jCGmnbXZO3RrsxyA4+ThlbEaorDHO7WH8FRojErQXtWkb5s2LoQxiqrkx8E9xzWCzUlueRaPx4QJhKRFyaEoxr9eV8g3P91uEaTx8loRMo9tdqdnuFmkRVjjt0hOw0qMwtaBhfeq8H6UKYLkw/3QYvrPGVDN9uyXSQtmPA2uFpTwgtAoR3u8n9iPIaxs+CHsMucH/A9evUFgh0JFlmwVylaPrmOKc9rowkNRB9sSp/onrotCAyFYLRoQTuA8PzkIs9x+qyw/u6njmIxHK6YyFYVZle2zlQyy8Y0SR7JQP6byIFBwZeAnWJuS3kpOkz6tXEtBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 03:37:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.041; Thu, 9 May 2024
 03:37:03 +0000
Date: Thu, 9 May 2024 11:36:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Message-ID: <ZjxEswEtGpOEbApc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507061924.20251-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
 <20240508161424.5bf4bdfc.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240508161424.5bf4bdfc.alex.williamson@redhat.com>
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6505:EE_
X-MS-Office365-Filtering-Correlation-Id: cf94d140-802d-41d5-6e12-08dc6fd94af6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VAg60uwWRjc9ncH033re5vnXEQLyIRmHzNbMdbk6ymwrPGlrKCRyT6LVYELf?=
 =?us-ascii?Q?N+/+9LWLlPsAUYqZT7Eaj5/J65T4liBynnAyyQ22orX9PrdGmIh22XYH5+9w?=
 =?us-ascii?Q?d8AxrS6pVqeO3VZd8ZToFXepCrDlokvUg+LGXj2q9d3//y4FD9wh5Cs/D+iv?=
 =?us-ascii?Q?mZ+KjQRmZymiPQXvYxibaNf8HHO1CJKsLIOr6TITw7bfBJyDpJGq9sUrua4Y?=
 =?us-ascii?Q?0iiQRzKX9/yi+EpDTk2cng5fog2XAAgTD6MtIUu0FO6h0ezbk+aVZ2tU1mXC?=
 =?us-ascii?Q?kceyBZfAaYPiwOczc7vSditrpqohxyZA0+sPA91mZdW8Ujeq7X6scKb2/dVy?=
 =?us-ascii?Q?5LXQtuV21TOZo8+uuSosGM2ygOgw2i+WY+/0jmflWg0Eiw5ab0fdjcnrGsUJ?=
 =?us-ascii?Q?+QCwoMWHIpkrMtVsZuJgoBp+VdWJ1XABJW7YyiTA5xX+JZKgsBMhVzeKELAr?=
 =?us-ascii?Q?mwCmzY4WWYYv+7LsAnVwFADhG7OJWuxZrRzM14g6Z3WNdgzOau0bJh7sHB0G?=
 =?us-ascii?Q?qQHDfvSKhrkth0EYONgZK3fq4auLx+ZOWM7g67sNuF3BTA+I7KLxiulZUKjB?=
 =?us-ascii?Q?yt7GKK5nk/feC5o6x1BvN4KjsfdDfXdqPanh02GKw1ZjI38G3vAIhiXpwAE2?=
 =?us-ascii?Q?rdJ4wFhWoiH3pdbDy3N/JHUXrQw638RohzSwtqXPx3Mt3gVHIisOhJfyfdGr?=
 =?us-ascii?Q?fxBrGROLEJ2UGpZ1oSJiTTluSbh8mRRbNkAa1gI1NLJP1Ef8sHOPrSFHnOPk?=
 =?us-ascii?Q?UH+JZGVQdWugMIl+giCTuPtR6NhhMmcWFRPMS2mkOSjhpMriEdWZhrwJi9p6?=
 =?us-ascii?Q?j8X0arfg9UbeiN/AqVLJiPI9uds0Zl70ozkBssyYHkag75zimKyG6Y4h2lOU?=
 =?us-ascii?Q?ur+qvlru3tyWJYk44CpWQm+RVWNi5IFu67edrjs8vsZ71JjLGgrz0lsfwJ40?=
 =?us-ascii?Q?6KAlBW6Z0bDD0O2xxgLELh3/I54mjfvQYgsEsYcGeUiJogtosQyiY0tkoR/m?=
 =?us-ascii?Q?uaeqNZB4Qb6xjBkR2euluv8DFjpjIAwDHjVMyXncIM5iES32gC5d7FGk2QXE?=
 =?us-ascii?Q?WEej6JTPJTTMX59FvAkqqWfHvfdG4D1YzuN2p/FhURUslXbcqPfhMZOKax58?=
 =?us-ascii?Q?vGksxHYhKDugzeIG82JUul44c5Vmzcp+mChTRKhtHUTlaHnYDnabDFfw8Q88?=
 =?us-ascii?Q?6G4uZZP8op3xh5iT+TmcvYTSC0aW9pXhUzouu2zgXD5XfMuyveiL0mT7ZhL8?=
 =?us-ascii?Q?P7wwlGIGov3nGMI3Kj0idbXyFoDNkBfCMwPmh3BacA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ahxV1fCWHqWy+GM7sMeqXMATfGHxpD5JtNDZtxu1yKpsDwGHbNkyd+z5DCr5?=
 =?us-ascii?Q?h+p1CcRVri2vhjl8au9JklWpNg+EpIZfZo3RQmax7VvoEphZoDQQ2VyORDwL?=
 =?us-ascii?Q?UK8fWKh3kS41YBZ/6EIwzuveVyfxg6x2ixcEsZwlpaPWkjxBTgu28hlZGvg3?=
 =?us-ascii?Q?zcvk70J4XoR2v8yLPJSmokPJX4KjyLtZR4Fl9dRKFQ/ig4OfWlLybN898TkV?=
 =?us-ascii?Q?7g6YzpZ33/o8uxcGXRvfnj5Cx5SAHjGPEBv84kd2TgakrNhFc2LQTTTPPrRa?=
 =?us-ascii?Q?SOQhvL74+IWt61FkhKiAW+1pD7pwbJ6M4hbZAsIAYOd+NpZzyOd1Z8NCHXzn?=
 =?us-ascii?Q?A9p+M/mB6rhlFb58sVgfZ5hPUMEbSZbqxUT/QVyyhaWCkn7QIJNjRWTTfczy?=
 =?us-ascii?Q?DI596uXf7pPnaSAx9FhIBz/XJ9v/ug12Pj1izYT7OgQzbW1rY4oNyXc2YLzx?=
 =?us-ascii?Q?ZRn3Dw03NrTZesuYRfNGKKJSjI65oDkoHFWdFEoTqA8A4NI2yF3btV10v5AU?=
 =?us-ascii?Q?WMcqxmsGE4NWuseTnIImeOi6Uj4DOg4SO42bbDNDVE1zZ5C9CEIuL93SsDUq?=
 =?us-ascii?Q?B9je84m8Vl2VhUagtKQg1VoCJWGM8CpH051S5O6cSQH68yt3/RZFxxU0QuyW?=
 =?us-ascii?Q?Dsh7NaEug3b3u0ngrBEK1ZAA0w/VE/1+/KkWNCpEM3aQIgjoMqHUKf4vDsdR?=
 =?us-ascii?Q?n26WodXV8+yVWrIg2scfPdZQL+N6AUDrd4NbtWhbzai/XLkxJx5m4ws1J9zF?=
 =?us-ascii?Q?5iU9V7R4F42P25MrZ+ce8kxfIpvBq/DfdreLJIw4e2pVybZi5Pxao+p/pauL?=
 =?us-ascii?Q?4fdAx3gRFO4LKtp32EiXjFA0as/pplhL5TxJ0vGfrgdVGMtgWMTm9i5WN2pd?=
 =?us-ascii?Q?0fwyBPY0Uga/jNynPa1p1otQbYuct58w3/WG7wx5190ZoKVu1jEG4ul5N+t+?=
 =?us-ascii?Q?ZXvsx6oubxtAMaAQg4nJenNf3RuU6lxkyBLZXG1G1pst90WG1g8FmOtH5v+M?=
 =?us-ascii?Q?AvC7onFno7R9UDwArxe1KIHrFnxgu/l9JFxOXWCYonPKHjQ4XrxbZTzeXOhD?=
 =?us-ascii?Q?ny7xi/NNzh2Hc+Bs8KFlmINpudOYcatRZQXb9OC+q4zIRcHmzll1/Q6B028G?=
 =?us-ascii?Q?B32+s5kZzwrSQU3JscuGjT0XyOu2qI5XnTmvUXaP9EVVh69QHSHoSJtQ0GbE?=
 =?us-ascii?Q?0dcyxS5bnCchXci5Ak0ydYDSiOyjz0WIjlVzsbX1hbic68x3NnTsg0Rnjcsu?=
 =?us-ascii?Q?ZAjP7PZVXiPuJknk9xdTfw4l0pAZipw2RUk3Ob7ocG5lreTG+09DweP0ysxE?=
 =?us-ascii?Q?jcCfoh7OQrg0xXKBNBoTPzyQTGkfcc/Dv84FFvb8S6ZPhtChewvByS//5aw2?=
 =?us-ascii?Q?2MHTUDszOyZj4ZgcKGlpaDnheIAW/G1+i48NRnjPLJmMOJR7XpzQuUFt/iIY?=
 =?us-ascii?Q?sXCETmk58xR1xXyr9kYmjuqGIzFqct0qqitJ6O+m8QPHOKrDLZA7tVUKs5Lx?=
 =?us-ascii?Q?Wh62+qJoHfhQ+ciOl1aEKi8C5HGxeFaLQ1RMHUtBTAUubImBYMpR5/JrYxni?=
 =?us-ascii?Q?I2mcR+KbFBPdU9HY8z/9ch23PxZbhZg53wzmTMAT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf94d140-802d-41d5-6e12-08dc6fd94af6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 03:37:03.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFblnNAijo/itDOWAap9A12KNTm5DrrGUbBzY67t10SiT7iBlRdMxgnErbofkMTH3bCDMJkNd3nuLyKb8Hmieg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com

On Wed, May 08, 2024 at 04:14:24PM -0600, Alex Williamson wrote:
> On Tue, 7 May 2024 17:12:40 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, May 07, 2024 at 04:26:37PM +0800, Tian, Kevin wrote:
> > > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > > Sent: Tuesday, May 7, 2024 2:19 PM
> > > > 
> > > > However, lookup_memtype() defaults to returning WB for PFNs within the
> > > > untracked PAT range, regardless of their actual MTRR type. This behavior
> > > > could lead KVM to misclassify the PFN as non-MMIO, permitting cacheable
> > > > guest access. Such access might result in MCE on certain platforms, (e.g.
> > > > clflush on VGA range (0xA0000-0xBFFFF) triggers MCE on some platforms).  
> > > 
> > > the VGA range is not exposed to any guest today. So is it just trying to
> > > fix a theoretical problem?  
> > 
> > Yes. Not sure if VGA range is allowed to be exposed to guest in future, given
> > we have VFIO variant drivers.
> 
> include/uapi/linux/vfio.h:
>         /*
>          * Expose VGA regions defined for PCI base class 03, subclass 00.
>          * This includes I/O port ranges 0x3b0 to 0x3bb and 0x3c0 to 0x3df
>          * as well as the MMIO range 0xa0000 to 0xbffff.  Each implemented
>          * range is found at it's identity mapped offset from the region
>          * offset, for example 0x3b0 is region_info.offset + 0x3b0.  Areas
>          * between described ranges are unimplemented.
>          */
>         VFIO_PCI_VGA_REGION_INDEX,
> 
> We don't currently support mmap for this region though, so I think we
> still don't technically require this, but I guess an mmap through KVM
> is theoretically possible.  Thanks,

Thanks, Alex, for pointing it out.
KVM does not mmap this region currently, and I guess KVM will not do the mmap
by itself in future too.

I added this check for VGA range is because I want to call
pat_pfn_immune_to_uc_mtrr() in arch_clean_nonsnoop_dma() in patch 3 to exclude VGA
ranges from CLFLUSH,  as arch_clean_nonsnoop_dma() is under arch/x86 and not
virtualization specific.

Also, as Jason once said that "Nothinig about vfio actually guarantees that"
"there's no ISA range" (VGA range), I think KVM might see this range after
hva_to_pfn_remapped() translation, and adding this check may be helpful to KVM,
too.

Thanks
Yan

> 
> > > > @@ -705,7 +705,17 @@ static enum page_cache_mode
> > > > lookup_memtype(u64 paddr)
> > > >   */
> > > >  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
> > > >  {
> > > > -	enum page_cache_mode cm = lookup_memtype(PFN_PHYS(pfn));
> > > > +	u64 paddr = PFN_PHYS(pfn);
> > > > +	enum page_cache_mode cm;
> > > > +
> > > > +	/*
> > > > +	 * Check MTRR type for untracked pat range since lookup_memtype()
> > > > always
> > > > +	 * returns WB for this range.
> > > > +	 */
> > > > +	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
> > > > +		cm = pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> > > > _PAGE_CACHE_MODE_WB);  
> > > 
> > > doing so violates the name of this function. The PAT of the untracked
> > > range is still WB and not immune to UC MTRR.  
> > Right.
> > Do you think we can rename this function to something like
> > pfn_of_uncachable_effective_memory_type() and make it work under !pat_enabled()
> > too?
> > 
> > >   
> > > > +	else
> > > > +		cm = lookup_memtype(paddr);
> > > > 
> > > >  	return cm == _PAGE_CACHE_MODE_UC ||
> > > >  	       cm == _PAGE_CACHE_MODE_UC_MINUS ||  
> > >   
> > 
> 

