Return-Path: <kvm+bounces-63187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC779C5C02F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EFBCA3571CD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 08:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EECF2FE045;
	Fri, 14 Nov 2025 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIDyVFuS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEF52FD69D;
	Fri, 14 Nov 2025 08:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763109417; cv=fail; b=csI8i7QnozeX1+pzJx77C6BQjRnW3Kt5q1UAtMJY9pVwn7hu3foDASPpjNVTcEA9Cs8Eowwl0EdtLWlUC4iNXPeXj/q+tiEuFhhZOI4lY1oYZQ13xR1LLgIuAutNP0eu3/8wX3n3ajdXetmsBZa8MyZbg/Nc+idSMz7OWZ5rQxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763109417; c=relaxed/simple;
	bh=F9PFXrI7kMAjLGBCylfM0N5lk6q2ISL+MI/0HZR7m+k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UGUFH6bRRIeq1qTaYu9Hp8AVzBw1dAF+R92HGEo4BUsiYn+DMCLHz2+0em/SxTw+7SHm4ZvkUDWRl0jVgKEs2W+sOYLEnNZUjEI3eXfT69vDEbz9PI+zBxO7tP2+8Vp96cu+v2d5r+2zx/jvxvIU041wqz7TcDxBFThTPO7wfKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIDyVFuS; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763109415; x=1794645415;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=F9PFXrI7kMAjLGBCylfM0N5lk6q2ISL+MI/0HZR7m+k=;
  b=WIDyVFuS9lif4tyUhjYfHuW9zpG9xcdSj67voMTSNJuon0KPYtFCuA6/
   XXGvF4NJOH8UxBzd2nn9WUg2BrxcElB5eatyPxubM8+uNYNMTAeYm9jZc
   ffd8rY1stOwatcGGy46ykuM60qjedPe3U//dRt5jBZE8s/wJ//4/cd2NS
   ZjZuXBjZSbCOozjFsMzP8uJmVayQTi6Jiz63OSUy6XI8vY0jZa2oWXVyU
   ZOh/OUvr1oenursQjuVvi8Mk7cxBBlosKaHGN7GE1i4Rm+FeonjJmKfUt
   la1RGcMI4VTHJfWH51Jsed4EhTfJJPz5tnHIN3o3CrC60/W05YIfxg/RT
   w==;
X-CSE-ConnectionGUID: GQkh4SRGTBmqJ+d37k/DHA==
X-CSE-MsgGUID: BAj0JypwQdyVLwURpgxO1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="69069761"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="69069761"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 00:36:54 -0800
X-CSE-ConnectionGUID: tRkdbN3KS6KlbXfQL2R4UA==
X-CSE-MsgGUID: 9bXoHcYDRKe31WIP6T+AKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="189575412"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 00:36:54 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 00:36:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 00:36:54 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 00:36:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAzDeWFPVA4NkgKqe/d3pbnIH43YcrreE/nj92cVw6vb8TkcdanlYr643cRJk/AKU4aoMuHTjAE3CgWW9FqeCcyRbw6Otj0ijMJQVx3L+HvrouNeS9/cjYFmLCH9JhsExs16i+GHR0aOlUkPjHZClVjY+kAPSwTDr55SoSSOzGpQaC9hosKMlZdAheI7TV7vTYvQtz6GDCrqXJ5yVAbhowLjalrc78zJIJ882B+1iwDxc1u21Rp5ETWzy404x915NMxzDazQzaH47tVjY1zN90nq999PWya8ibe1nBk+sFuipFyzLcV8jZE14BYmNL2RB9ClW4Lp3hSA7ayqKqe0Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9P+w9yt80b2xFFWsE5bcnxHP1VYk/mjWv/hTDa8dof8=;
 b=tnd4mKjAh4YLPB8KQnJ+4IkZ311+DrqRX379f3zMN2nLXVCBv1yq1QU8Ss9w0GYOWqdy8mL0Ilz/E2Ok+Spwwc2EX7IvitX7BUWLU5xzDSeHp0k7kM8LNH7GZgnog3K8GS20d3q4Rjtu5yKU3kSeuHMbb1FZcSNBaSmje+p1GTLVNl2suvHowerYdU4J8LOXlo6BT5ZcG37xl+86UZCvbkS9PrDhrJOvtITIxQ2XqLf/dAclf6di1U5nlLELN22U83WAZxAUNga69Zo/YisX6HsxZ+EY28jO2vsmsMknC5D8tKE3WHUIGbZw5k5QCwESdI+eIcaOxC96XJ14zQtj4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6178.namprd11.prod.outlook.com (2603:10b6:a03:45b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 08:36:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 08:36:44 +0000
Date: Fri, 14 Nov 2025 16:34:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is
 RUNNABLE
Message-ID: <aRbpnPdgh1h4SDAu@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094628.4790-1-yan.y.zhao@intel.com>
 <05bc67e2f6d7ec69d5428dadd1e175abcb9d0633.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05bc67e2f6d7ec69d5428dadd1e175abcb9d0633.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0042.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 51292ab6-4bbe-40b6-2dcf-08de2358f129
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?tbDzcji/S4ynRF+FmXuPHuAQ32Cf49Ol9ibWV+Xz4P2ARKrgDIXRF6XCW+?=
 =?iso-8859-1?Q?OngN5LSOWDlZjH9nGZSeKUVQ84ELxbDwr7LlvJ7f2V7GgA2QQcT1bWJqxy?=
 =?iso-8859-1?Q?V8GIdmKIXbwofFI/fvhfj5w98VSorPkSQxVBM45jRkAoW/CFX5xaaoSPVR?=
 =?iso-8859-1?Q?4AM5w/OR3FQ7pvkD/NtFGyWbnOsBdIRT2GS/BO4KhLETYeKahDexAeOjXx?=
 =?iso-8859-1?Q?nrxat80yKHnywdktw9kdo7BBL/bc+4EmnoxcI4P4LoSTk5dJW4wDESqCDj?=
 =?iso-8859-1?Q?GSK28Ux9bkLKWZtJlvVJBOwA7IIkfErCXf6pjWiy5GF38wtIUkiAoCjKAj?=
 =?iso-8859-1?Q?1fc9haTp1vZ3wtGACdaXLGjxQK8jh9WdeZaVvlnxVfB6OiNbhzi0rfkXmd?=
 =?iso-8859-1?Q?DWWe5e2phKwcjNDRpuZi/GeXDnoTlYMsqNP9zpqKE07xReUGOmUs2iGQY6?=
 =?iso-8859-1?Q?epII4tzNFPUOwzTBkUurO/YaVTsB9Brwe7nAJyXrg9FYz8xYlAUiCh3H0X?=
 =?iso-8859-1?Q?XzABM9f3G0idTsTXjRxfqvN72W2ceDjpo9q8+xocaitBZPQwIjFrl+F6O3?=
 =?iso-8859-1?Q?LxaHGUEBaS3qqD2Iim1XZN6VVH39powfiG/Rg8r/c/AtaKO9ptZml+lnVv?=
 =?iso-8859-1?Q?VG43goXiekRxVSGi+hchziA3xht2tL5VklETN6vo73MCM3iaEY3PKmQ0tE?=
 =?iso-8859-1?Q?r7elP+3DBd3TpK3YKQw0uIl6HauEegv8AVIgz6KZAOY1KHX8Wv09WNCTHC?=
 =?iso-8859-1?Q?QkGvWlvB8iXIk/jELyLJWOI2uobyMYjEzK2TH2ZoB9FSLzxn3ALiISe1+t?=
 =?iso-8859-1?Q?8+kp3fxz1P8y+kZR8dvt1BhDqz7AXAnpMy2yqGq5swrRktYa+mxNuh/GHm?=
 =?iso-8859-1?Q?c/dHfv2GqY2DjmEvD+DArbAUqIrmV8+R4JyhB6rA2G0W8KogfzdVpGWqKL?=
 =?iso-8859-1?Q?TJckbHgwUKpqvv/5JmiSs7Vi0n+S7eVJTt3V5aLy8iEyKCFlLMFnRXfKmP?=
 =?iso-8859-1?Q?8QM7wPiHG5aZAwfKLFBaoHk9btjTIWTHSX6vL1bu0FTbJZHk8E66MRcLBD?=
 =?iso-8859-1?Q?ayvO/FSiuACVslbGT8KJbkEmawIEQOcGv1X2tmv3qAf5WH/dIrB7J1ojww?=
 =?iso-8859-1?Q?yDiBY9KdYJTL0H2r6FKBYKRct7ouGccNO2eAkiFIjyqIXiW6hexYOJ+ZTo?=
 =?iso-8859-1?Q?2ssdCjzoHJM8yzrcd8oqPL9ItkHO1j+/d2KkjUUU0sxNOmd1XRtOm4pqh4?=
 =?iso-8859-1?Q?aIF0tdEi4itaM8RmiEx+1OG2lpRsuag9Iw2uu20LIAivNTPIx6FHh1qF2C?=
 =?iso-8859-1?Q?FLVs9SF9Auxikcu+8Nfu2LKxn99TlfTZ7Bns4YE/1wsz2cVcgDoPxo49pm?=
 =?iso-8859-1?Q?iwo2isQo4+7hDWnw6Nj3TCQHMiEtPQ23N6cRVhVFkx8TuuPHgexm0KaRJe?=
 =?iso-8859-1?Q?VX0vEKbknphNDVZ4am2JTzCV+YSEpM5c6JdAruJZSr4uUrerRGQWry4nhX?=
 =?iso-8859-1?Q?YsaNtGKmpa6DlUBrbXWLOvnmS79ZbVsDsOdJH8Mv/N/g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4weiMeyk8Q/pOHz9H7sxXU5qTlkuZqqjjleBIf3isUQ9r42XjGz3tTMVRW?=
 =?iso-8859-1?Q?/y1ISCXj6C/Zb10hz6ntc01FzMo2juz17Mu+ywYs3qk/7sFl7PH/q3oVlL?=
 =?iso-8859-1?Q?CTEm44u+JQeApxn7sEA1oy2awMr4smUJwlt+NSFBYimuOiR0/bCM9J64lm?=
 =?iso-8859-1?Q?HlFxzsVTzufxd0wRQluCjkll/y+Kkhg7hM6/Jktr/xNSB3U/moKkkvSU1k?=
 =?iso-8859-1?Q?5t0sO3vigbR7vle/3vIeKQuXoyGc61BNjUSR5Tv6SenNJP+e+uMbYh+baR?=
 =?iso-8859-1?Q?os6HzSpOASN13ORbnWsWBWpy0qumVYNLydMX6aCl+I4ufTLqVFNXfXFIVB?=
 =?iso-8859-1?Q?eI6xzOeZXxnUCV8PyPK98jEGvtTZADyPCO5gVVEn5qk0nF3oDLHFYDE52k?=
 =?iso-8859-1?Q?njfr3fAzCSECmB0JsGQkFP/2jlSAL4ge6WPmPCMr/tE6aZ2nlRr+GEg2+u?=
 =?iso-8859-1?Q?XLjGN6Tg+XUhEChv8FK79OLvVfum6+lwwAwuUIqOX8H8QO6JAXbTh+sSFz?=
 =?iso-8859-1?Q?7smZQaZX/GMhIx+lY9xVqM4x8VerKpw/GJKyvASa1kgdtHKwpDlZNKOl3J?=
 =?iso-8859-1?Q?0YxQhbST5vzlEOOlFNfL0/wFhXSsrVl965zAyBXSH0fp+qtnI3DU/EgEGi?=
 =?iso-8859-1?Q?cHPtHDmmBxBZOpM1zs1MR/I3bM7cx0+4kZujhWG1hnjMMRDIiIk4M5GIer?=
 =?iso-8859-1?Q?ptFMZ9OBImpF29jclKtTodNGqlmwqNV39J7OOz+oDHevjK7ctfVX9i32jN?=
 =?iso-8859-1?Q?Yw5Sgm2WZSMsqmvfmiOlz1Zjs4QayM6TzVPhZi6xDJjI0bWvIQMgObk/hj?=
 =?iso-8859-1?Q?Z4kv0eYyp/cBVNEG6yeCS1QAK1VTYajWNrG39HdxTPheq8Ru2U8x9kesw6?=
 =?iso-8859-1?Q?UwWVo5b5t/ONf+3Cw93PC2NonBqtSsB+s0/rqaSlw44IQXa5olRnJFLAQa?=
 =?iso-8859-1?Q?6RkMA7WEYAMITIaPnK45pv69TK7aWOutcdFIxdZX70aCzcyj4ZhhqYoiQ2?=
 =?iso-8859-1?Q?+X3jjKEksPYIsZpcd4xNcJdHYA/CGceBzvdFugELpRpk3LaENDAuNiyG8t?=
 =?iso-8859-1?Q?Pvu7WK8ZyG/ELSV+dt20fyMQ7I7bCcSWSnzUvsFI0fxMf0uWRBKe35zrNF?=
 =?iso-8859-1?Q?HYtFLdRZs7mvbMY1553WafBDMw4sVj0/N8cnpQUGiBtYzvpuVgpeG/Ikxz?=
 =?iso-8859-1?Q?Y9y+k519HSGEfhpAzo2hec58jHcz9vl1E5CCp1Mk84w9E90WdrjpiNYjky?=
 =?iso-8859-1?Q?0r0XsUYvHaaKB2O3XEJflMyp52mUW92TmFQ7tBrPVpXb65Stmwzim/2ZNH?=
 =?iso-8859-1?Q?TAlDqT1C41ScBUDKUW2/FW8owcIP9necmTTN683CjNRwmxapm/R8vELe0C?=
 =?iso-8859-1?Q?i2nsgyKd3eCX3Zs/UpCKtvlA/IOEHH3aYMjDaCxdNiFXv74McF95Zn3rlz?=
 =?iso-8859-1?Q?VZuETYOXNr111VaYzzuO8ihHQ/d004bbzHZKIZFyrHnDlWxndoaKDQUIue?=
 =?iso-8859-1?Q?rY8CLeYvXdCxl2+BEnjv3vpxJqXuOdiXjhPPtP2YCBL9DO8KfRP3P3//cL?=
 =?iso-8859-1?Q?3oZ+eH1ApVj8rQtyH0ZKeF758bZYVZB/+sTSSD1SAMMjcSXsMdmuEsGkEA?=
 =?iso-8859-1?Q?xoNLZ+F4i2MGuh4PvAVNyA3PvSJIGgGHGe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51292ab6-4bbe-40b6-2dcf-08de2358f129
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 08:36:44.6538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZ6KS+pqf/dZMIi0cUwDWsUYPUFeG+H63c56ovIcC69MDoMZjPeQitz8MR0iuhxJNGjnSettF6MJ21iLZyodWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6178
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 07:25:30PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:46 +0800, Yan Zhao wrote:
> > +	/* Large page is not supported before TD runnable,*/
> > +	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K, kvm))
> >  		return -EINVAL;
> 
> Not a particular comment to this patch, but could you elaborate a little bit
> why PROMOTE isn't supported in this series?  This doesn't seem to be
> mentioned anywhere in this series (not in the coverletter either).
I mentioned it briefly in the coverletter:

6. Page merging (page promotion)
   Promotion is disallowed (in patch 7), because
   - The current TDX module requires all 4KB leafs to be either all PENDING
     or all ACCEPTED before a successful promotion to 2MB. This requirement
     prevents successful page merging after partially converting a 2MB
     range from private to shared and then back to private, which is the
     primary scenario necessitating page promotion.
   - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
     TDX module. Consequently, handling BUSY errors is complex, as page
     merging typically occurs in the fault path under a shared mmu_lock.


v1 explains it in more details (See section "Page merging (page promotion)" in
[*]).

[*] https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com/

> E.g., theoretically, I think we can have a way to PROMOTE mappings for
> initial memory pages (via TDH.MEM.PAGE.ADD), e.g., right before the TD is
> becoming runnable?
Right. Kirill also asked it in in v1 [1].

Though we have no need to worry about the nr_premapped calculation after Sean's
cleanup series, I think there's no need to complicate the design for the initial
support, due to the limited the amount of initial memory pages.

In my environment, for a TD with 8GB memory, there are 1086 count of 2MB mapping
at runtime, but the initial memory is merely 1049 4KB pages in total.
So, the gain is less than 2/1000.

Will call it out in the next version.

[1] https://lore.kernel.org/all/aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com/

