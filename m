Return-Path: <kvm+bounces-44100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C653EA9A622
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10F8A3A6CF3
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1586221269;
	Thu, 24 Apr 2025 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WK4Eif0S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0F214A7A;
	Thu, 24 Apr 2025 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745483752; cv=fail; b=C5MP0Bw9ut7P+qIGEHJb2s3IkEAtG28nPZt9qH3gX2C3iD2lUuej2ajDs419XAVhGjx/bJ/o1xAx2cRKHMe/jD7kpNRgOS9S9t2wgcaneBsNOO6GjTcCTnH2bnIrdzKaoDGaRXSQscjssGw7NkUvH3nx9HAJuqLmZRsmEydb37Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745483752; c=relaxed/simple;
	bh=NGvKPHEvgi9zGsAZVQJhJb9bGI2LU1A4IJLOkINwxbY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YHnrnfx4TOHI1HGb6oMNXnZ64UduG7sqARJqOmEy1Ca7OaW9sqfIfzpu3eeId1eKJ8myxuMB7jrbjU9gWvmGyvsC4sJAFkTQUWwPtbhyYlkhp90vgZBpH5QvFr5x4X7vnWtjW+sWyievqwF4+OM7nu1iowR39Cr65JV/c8Gn7pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WK4Eif0S; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745483751; x=1777019751;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NGvKPHEvgi9zGsAZVQJhJb9bGI2LU1A4IJLOkINwxbY=;
  b=WK4Eif0ScvdTrKcZIC7bQmGetd61/kjbAU02r/r7RhIj+yHu6ACWNakt
   o2b6OCnIwZ3x6dmdnVMxnztdmQNMOb5eBMSZ8C4trrwpTqEAEb8TlpfLA
   SC7kHVqqxPDojqZxU843EWq3mKhws9EKD10edXyspnw2CBO1q4zP8ixIl
   df4SwjkF2tRktBe6RwxXQV3qXVTaz+0RKKa8eW1cZ8rb80cmFH3u8iCpz
   rH8gSyD69fIy20gs0/kd7kD3LnXwnif+v4SF9tr7qS2btXx3fPxq2Bm9r
   LtKl3Qy0Z/QCn31XG7EatHVyuYyPGcxgkfVII1jWIH6JAxdZMjw0ys+oG
   A==;
X-CSE-ConnectionGUID: Rq8LXIk4T8eTm0hOxzoi8Q==
X-CSE-MsgGUID: SuAiJD1lQEWxVfEqok0zjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="50927479"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="50927479"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:35:49 -0700
X-CSE-ConnectionGUID: 2mza6vS9T1+BdiRKEDbOqA==
X-CSE-MsgGUID: v9KAVLsySXmA6JEB/o59eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="155782126"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:35:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 01:35:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 01:35:48 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 01:35:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AeKb2fZWbqTBcraR7VZFvSVUYM+jtA3XFbm8/a/cKSwwQyWL0dFV3R8wArXyzpJ/JgaPV8zwzVJ5DjiD7mAPORahNOyKkrRmVI3vLJkCnWJ/USLTE3pg3W5h+WTMJZAUr35TS+4UOOFMW2hjcXGqYDVwT4pAc1Q2wwn4cPPpJsqIsge126+wOjlUp0Ew9OLuHMjTQx4IGB32BlQYUvGQX0dohruWXEAVnoHdCxV/baFWzPYq/FDpQcX9lGwyzHozHkIjc7FjntPqlb6IjF4l87rquVCM8cnYQu5NuGc9kUl+Qd1BPB8zMQkYNpL71NvvkVPPCZA02P9DJOvSn0mvvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMNeXhT933T+rFBvkXXoR/pQuiIBJAQIfrREtBd5UoY=;
 b=bdLdg0UaKSe9hYDSTlBowsZLMFa/xZTEuTsbWicJgugR4F3265FHwpVeRETH5fOfs7m4T2gwHn+4vtC+I/zfPkH/w2HiR12Wt6ltWkLrilweBPIckTsWEdaucVfUtreIkjQh1g/yZe/mkoUIrZVUXiMEHMKdA3eN7/9Tn/YhayyIIHbnqG4uzdITOoWHBhSRQsek7qUTM7CNP7giXYnn81FFhiHHSujfM2Y6uF4COJjzlTy9qoAE0AKYxPMtEJKo5m0CRXmdxmKLpZT7saPVacpPQYYYv5q9sYQxpZRMUxllyKGikFyPDtwjTA5SxTzFE5n1DcbseHRJyWpeMavIwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.23; Thu, 24 Apr 2025 08:35:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 08:35:10 +0000
Date: Thu, 24 Apr 2025 16:33:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Message-ID: <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ab6136-3585-4349-390b-08dd830aec78
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MdBNJO4QU0CiRtta6fCEsiRpwaxfEMhjFrjV32v7293bVVdXlfxb5MaCf1bO?=
 =?us-ascii?Q?/MrUJgURWz1g2tfcj8URSbFHWps0OitoeQwQbTpFkyV5H6CzqKYs3IWPF8n8?=
 =?us-ascii?Q?XBT9aHXUNwe5EEQZwYCJHidMGITe3wFJa7JUzjPQW3t66wgL0eqO3Aq+dWMP?=
 =?us-ascii?Q?NyR9GclPmqbS4s5lT15BnBcvGx8OuxbZFaL77CbwuvIbbAMwbtuWL+jScK2B?=
 =?us-ascii?Q?E7mtOv6fymJwNCP4viLIuLTTgi8lg7Q8nf7zDqJ2M7e+Ksz1vusX4oEdc/Le?=
 =?us-ascii?Q?rR8xUHr5w4bXJHYpxIYlWhNQrZCKmKyJMcXfV8MlTCWawp+4j21RzlcVL3KH?=
 =?us-ascii?Q?Vo+JVszlZ3wHrMMMOwXrqZt6nmI+A9HTS2yW6XpMTXIFvvaEDxanB+wpH1Dq?=
 =?us-ascii?Q?IRSsV6Pae8hgvUyOORogLPT7Aap3YsRD4pfqBw5VjLrPGilVv4rvYddTlftv?=
 =?us-ascii?Q?H1zs9WCIbAQKwqxR8uSVj6MZqs0cbJ9A3bg1UN+7uYMgIX4lsp92lqOxxUOr?=
 =?us-ascii?Q?R7Hdg4u8kcOY9PDDcsBViD4ztlzB3UEc9vXz6IpMFXUpBLXu5FUmgnfR/oWo?=
 =?us-ascii?Q?OnAR4UEUv5TcPMkXYOMdPY5wnbmhd7ge/xd+T+/X1lu3FZFF44VdSeVoNxLU?=
 =?us-ascii?Q?1mdxUjWmEZZkQ1/d7Ec4mhbeDWBjBrWVuLFtoxeHl1lQ1wWiuEgayTRyWQX7?=
 =?us-ascii?Q?zqyG7fZDqD35usEyl2khCEnnqeTLePgwmWtdNhuDV0aKVEMCvPNhPMUnMKwW?=
 =?us-ascii?Q?bkRlKjxA2EID+25ksH+3nhO7rBbDXTrQmMCWZigrwaKQXSAOGyexHdwKkW3d?=
 =?us-ascii?Q?n9+GzS9XNQqRzG5LvcXBBz7mvhTyN9p+NKhV7Q596honubBaHc3FenCjh0p2?=
 =?us-ascii?Q?IhpShvg357RePue0BTxpdC9935q+huwLrXZ4syIV55sX/2OoQETeSiK3zt17?=
 =?us-ascii?Q?ygulG0jfWntXuCR91LYd8IJaKqZR6ogWxjAMN+U9ZnkX4kayvm6NK6IeueDh?=
 =?us-ascii?Q?yqLNJT/Zzm/pHRRVlwftVXQKYZiLitQS8FqVbUAq5QJSA75xVIf2UVSBmx89?=
 =?us-ascii?Q?SV63ByArOWyNolCVGgTMP4leB33dohxiTeuqwDexhEZsnB8zmC/B2EeIXD2K?=
 =?us-ascii?Q?lBxKCFnzMcaL42DNbzD99/ZkG8Q/Lz4IIGtM5TecBuOTfUlKboiQ3tp6O/O+?=
 =?us-ascii?Q?iE4BNq99BZpSnf4dqR0I//uehBMOyIo6fRKVQxtOxHgPA4V6RMOtiO/P7YrG?=
 =?us-ascii?Q?CTdCws3ismG+YgPB0Rwqvzl+664TPQPdNo0EgnjUwhe6KLLbdGMt6q+qeO3H?=
 =?us-ascii?Q?0DkJIad4x1PUqqMGkHE4aaiU9eKqPIJz1KxZ8n4mzNr5N/jV/TPG7+zG+Qsn?=
 =?us-ascii?Q?9mw1CcsaQ24946wz7yj5DVjMkGtWgLh6D0Sq5USwVFZxfBnHuVEYUc78UAtE?=
 =?us-ascii?Q?TVc/UBcEOEM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?giWyik20UmVfTfJFFa1lO743oT6VN1LvCkby+dO0GOweIW71IBnQvSNU0YMZ?=
 =?us-ascii?Q?Tmwm4bH2FYyJ3/jHJ7KHCS6jHCzQNyBSkrFrlNA02cI/a/KIVKhPBRzLUyy2?=
 =?us-ascii?Q?8bftsx+08hZjtCiZFRLUvIJe+bjFrjgIeIW9NskMSaJ+MwUrLkShPJLpha3k?=
 =?us-ascii?Q?ZjzUJwnlZx9NIUPotiJgRsKFyiMOJSDAtcSVBxIXQDhl3ITtQ35siXsxosTW?=
 =?us-ascii?Q?bITKO+/G86PluQTMfi+9f0cNAdh+7auTjp9sybrFNXzges0pY4TB/Xz5JtUA?=
 =?us-ascii?Q?X9MARr/Yh7cNIl8cxjj45b6A4xwrvNnKY7dpVRB+IgzBndFae+fx3be8xkE6?=
 =?us-ascii?Q?Y/d4uo0OM+AIp3Hsg5may1u9HzBSNSy1ugXzcogA7rp/Ic4SGNObtXdJ996/?=
 =?us-ascii?Q?Xa/h4Gok5LoAub3dh0DNXySd6ECm4hIrn8dN1kkaK5BQFvFdtgVwN8rJTFPa?=
 =?us-ascii?Q?dzWa8EqGE4ute6DMODpaaFLFWZ0zH0n8I3RYWTLYouG5QygpQ4uuAMVyOatX?=
 =?us-ascii?Q?BPZbqCeh9pGZLJ/MgXc+L4gF9n2ql4ZKEg7ckv18/BfC9teE9zyPgTOOmNfk?=
 =?us-ascii?Q?aEJ3kYXUO5I9/Lh6K2SAN36z6XYdxN4NTrwXU3zm6JPrmXt0Tfcfz5+lOhxk?=
 =?us-ascii?Q?vj8CxlZmUU0w1RsfIRYJRm7P6OuQn+bXtpoMKEkOU3xMte/2KzP/gPPsTeuQ?=
 =?us-ascii?Q?1OEKPL6sshhaSPPPVNcIvZl0C8Sq3gExsbIB9qzaxGYUS6OGTKVvXdU+QeeA?=
 =?us-ascii?Q?U0dffLUAQ3NWRggYwT5Q0kfg5MuJSy+EAWB9jO4WtD0/qKXRyL1tRGYGWEje?=
 =?us-ascii?Q?TrLlnjzYxMg2f+UppvuHTID1VMDNJ24KtxYKi8oC1NRXdp1/ICqyC6tI4+hG?=
 =?us-ascii?Q?EiMbMRQX6CgSQd8Qhuxqz54ktYoICsn3UNAtpUweNM76aHoZqWKjs6mknnif?=
 =?us-ascii?Q?gLM2sASlDJnPj0eT9lg8BfhqC19YA0HzatGcrni6/QYt8JWjGn26cSLfhXil?=
 =?us-ascii?Q?WxBtqEWUAYoAc7Nrs+VjXwuogM1Qb4LKbHcErIzDi/WV51hOgWHvHx1OWSrQ?=
 =?us-ascii?Q?4UVumDCjBF5XenvDWOJrz67KAqSiPLLPzEWpLGnPBLzn8R4LpCtOh6DurnsW?=
 =?us-ascii?Q?pwSb9nVDxo3WIs1d8ciS3aTKEzNRCBDmBhw71BwwC5I7UAHh/C1i/snCq21Z?=
 =?us-ascii?Q?he/jXC+ujHpLWH2zms7ISW2VAPYe0aNOmxvcG6XYvCrg+uTCa1LreuDmgZAz?=
 =?us-ascii?Q?QxQckCrWmnr8fIcKv8ncnwbG3AbI0cU9qY1GK/NkUzWM74XhDbU8lhaBjRyI?=
 =?us-ascii?Q?nsLL3AfoOUBH0coCpJCzTcVWtJjqCWYeItcUEoN07UYAqHMBf6hEr0ckgrup?=
 =?us-ascii?Q?D7XMDyA2aDm+nr8iPj+xkMzoDAsUxzGzRO/ZmmXMz2mhzPmSME8t8xVoa80t?=
 =?us-ascii?Q?AO4BEh5V0415jJwAuCcp/PTzID9K7HLDGRHwdAdBd4WLB86Wa5IVdyPr9cDs?=
 =?us-ascii?Q?lOrSaqWxUswa5KIvXL0NVsff7DzSWoO5zwacWtEZz6BG70oMfYu40K0vJB1z?=
 =?us-ascii?Q?iszKR2zmiNFFo61jsfcfHbyEXRMGHGG56QoTeuPa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ab6136-3585-4349-390b-08dd830aec78
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 08:35:09.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrTNgw3ls8YLgqbvDZlv9tFQz+NPwilNsGLHOWTVdZL77l9XB/aIiJBKM0Ai4jm/hxhsNXjdb2TyGUSm6hd8Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 10:35:47AM +0300, Kirill A. Shutemov wrote:
> On Thu, Apr 24, 2025 at 11:00:32AM +0800, Yan Zhao wrote:
> > Basic huge page mapping/unmapping
> > ---------------------------------
> > - TD build time
> >   This series enforces that all private mappings be 4KB during the TD build
> >   phase, due to the TDX module's requirement that tdh_mem_page_add(), the
> >   SEAMCALL for adding private pages during TD build time, only supports 4KB
> >   mappings. Enforcing 4KB mappings also simplifies the implementation of
> >   code for TD build time, by eliminating the need to consider merging or
> >   splitting in the mirror page table during TD build time.
> >   
> >   The underlying pages allocated from guest_memfd during TD build time
> >   phase can still be large, allowing for potential merging into 2MB
> >   mappings once the TD is running.
> 
> It can be done before TD is running. The merging is allowed on TD build
> stage.
> 
> But, yes, for simplicity we can skip it for initial enabling.
Yes, to avoid complicating kvm_tdx->nr_premapped calculation.
I also don't see any benefit to allow merging during TD build stage.

> 
> > Page splitting (page demotion)
> > ------------------------------
> > Page splitting occurs in two paths:
> > (a) with exclusive kvm->mmu_lock, triggered by zapping operations,
> > 
> >     For normal VMs, if zapping a narrow region that would need to split a
> >     huge page, KVM can simply zap the surrounding GFNs rather than
> >     splitting a huge page. The pages can then be faulted back in, where KVM
> >     can handle mapping them at a 4KB level.
> > 
> >     The reason why TDX can't use the normal VM solution is that zapping
> >     private memory that is accepted cannot easily be re-faulted, since it
> >     can only be re-faulted as unaccepted. So KVM will have to sometimes do
> >     the page splitting as part of the zapping operations.
> > 
> >     These zapping operations can occur for few reasons:
> >     1. VM teardown.
> >     2. Memslot removal.
> >     3. Conversion of private pages to shared.
> >     4. Userspace does a hole punch to guest_memfd for some reason.
> > 
> >     For case 1 and 2, splitting before zapping is unnecessary because
> >     either the entire range will be zapped or huge pages do not span
> >     memslots.
> >     
> >     Case 3 or case 4 requires splitting, which is also followed by a
> >     backend page splitting in guest_memfd.
> > 
> > (b) with shared kvm->mmu_lock, triggered by fault.
> > 
> >     Splitting in this path is not accompanied by a backend page splitting
> >     (since backend page splitting necessitates a splitting and zapping
> >      operation in the former path).  It is triggered when KVM finds that a
> >     non-leaf entry is replacing a huge entry in the fault path, which is
> >     usually caused by vCPUs' concurrent ACCEPT operations at different
> >     levels.
> 
> Hm. This sounds like funky behaviour on the guest side.
> 
> You only saw it in a synthetic test, right? No real guest OS should do
> this.
Right. In selftest only.
Also in case of any guest bugs.

> It can only be possible if guest is reckless enough to be exposed to
> double accept attacks.
> 
> We should consider putting a warning if we detect such case on KVM side.
Is it acceptable to put warnings in host kernel in case of guest bugs or
attacks?


> >     This series simply ignores the splitting request in the fault path to
> >     avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
> >     at a lower level would finally figures out the page has been accepted
> >     at a higher level by another vCPU.
> > 
> >     A rare case that could lead to splitting in the fault path is when a TD
> >     is configured to receive #VE and accesses memory before the ACCEPT
> >     operation. By the time a vCPU accesses a private GFN, due to the lack
> >     of any guest preferred level, KVM could create a mapping at 2MB level.
> >     If the TD then only performs the ACCEPT operation at 4KB level,
> >     splitting in the fault path will be triggered. However, this is not
> >     regarded as a typical use case, as usually TD always accepts pages in
> >     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
> >     splitting request is an endless EPT violation. This would not happen
> >     for a Linux guest, which does not expect any #VE.
> 
> Even if guest accepts memory in response to #VE, it still has to serialize
> ACCEPT requests to the same memory block. And track what has been
> accepted.
> 
> Double accept is a guest bug.
In the rare case, there're no double accept.
1. Guest acceses a private GPA
2. KVM creates a 2MB mapping in PENDING state and returns to guest.
3. Guest re-accesses, causing the TDX module to inject a #VE.
4. Guest accepts at 4KB level only.
5. EPT violation to KVM for page splitting.

Here, we expect a normal guest to accept from GB->2MB->4KB in step 4.

