Return-Path: <kvm+bounces-29902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C279B3D83
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DA7C1F22DCE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707521E32DC;
	Mon, 28 Oct 2024 22:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uo1OwehO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A459817D355;
	Mon, 28 Oct 2024 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153329; cv=fail; b=hC/BuuNhIzh3jOQMvzKtQ4pIvTjUNaamYdFMv+ZAo6yeKxR1QCmYYeCPL6TCgDk24DEMRUjWw6tGDOOPRUUy7rtNLkM2uCMksaTKdaMkj9KujVpnhzlGz2sAvbz9gPpoziF1Z0CuS66OPw4KqhVtUfqW9Puu46ykcqiFgzXNFh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153329; c=relaxed/simple;
	bh=LRBLBO1VEFf4KqrdXFXZZT3pevh2MfYO9Yn5vKuV1ww=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ki9bvBNdJdLE+ExuDKYagh/pneMB8iO/aosko3304U+nyf3YphCq/UQzQrCKgHscLVMcUgecOpI/M0MOJkfBOdR0MiUYnA9pGL8kTrpVc7T8VsqN6/MPVMT/G9oCh1pU/7LfSibIZY2kxU6T0/xwTu68lfbCbWksU0QTdXzO4t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uo1OwehO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730153328; x=1761689328;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LRBLBO1VEFf4KqrdXFXZZT3pevh2MfYO9Yn5vKuV1ww=;
  b=Uo1OwehO42ZDdDVfFXKXASPAPx3Yt+ZBeE9OddalxzdjKDNV6Pne6a4u
   Y/PGAS8FQio6qVjvql17J7glPozkkRuX2yKA1L3KQxMh8AMYJAAC4TTgA
   Gxdtvsb0XlqaPvX5zgiYEA6IoBfv3y50we08MvuHjT0p2E8ksQWl+ERe2
   CcgpaKGP7KBOzFEHw9TyouUYUX2FTLK+L9Z83YSRSF4qBpAwUB2CGD92l
   f//3BR0GmquHRJlg7cCvQAMbs+arn78Xuh7Xn3zl4w4cyiEOZUZku9Y0M
   rMXzZjTHW8ua3oyPAHpNZjlxSpsLT0qyiYTHBB/IRcy3Fn+aYnYw98o5w
   Q==;
X-CSE-ConnectionGUID: 8nADHC+2SJmI0VouTHeidA==
X-CSE-MsgGUID: pXpZicmvRVO4+UdBB1dLxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="33691263"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="33691263"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:08:47 -0700
X-CSE-ConnectionGUID: Kc0rMDzdSXSO1p9D5AeELw==
X-CSE-MsgGUID: t5GSyKluQyypOOrzJKQTbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="82080894"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:08:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:08:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:08:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxLqKrd9a/2HbZXa4SZE9peJx+1UNnAXj9d8rQI4+DkfaTy1c0iOTKZvJORWPFzYMQLRdgy2Oh1HWNu1Fhox6hd+YBXX9S52aL0EYqZe4QIdpPjEMGEOIeI02pKXCaR1nqlYhVhhKtGeAUUqZXBiW7xgdQ0ifB6StBYyT6YJ2jBiYSwESnA88WF6kKh75krphIiSSNMe9uIuGRb5HBz5ez71kg0m3gGW/9cLOjSwlp6wye0U8jQPVNb+GbGMVbQIaMcJh7g2+7kGq4HG5AwgLkje3jie8WnKJs+YOpWhUiwakVG8l5lvu0oCzLym4wPgsVFCuQIB/BukzG1L4bGkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuuYlAxo8mzoS1TshawUepXXwieOzkhZoJmxM+9rw4I=;
 b=cxppSoKWNt2rsid190OaIS3w3udsE9qHKf2iSkiA9YQRw5NGsZuBPANN7db+T9uidjQfdWOMU7ByQmLgXQprFaakvNFE6uR3fI6ge721dtwUdY8IGKYKp8I9ifetGlhhIYZeVclZ0p5fT5k057fM74SFJpYD3X2cqzsadYfTyoMGSOgrAIdX5x41TsAnobj0slwnIsV3ETExBjsH0/w0xdWL97TenLB8bJWf0k6ybjVWBZo/QlbpC54laitPWi0gQG3Vz3FiTWWdkFX956/MuqIeGaqaPDGUuW8QHPyl5IGXbhs0D4i+szwY7ZV3qT3tClrvqph7gx4xW1OfWdkUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7073.namprd11.prod.outlook.com (2603:10b6:510:20c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 22:08:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 22:08:40 +0000
Date: Mon, 28 Oct 2024 15:08:37 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 06/10] x86/virt/tdx: Switch to use auto-generated
 global metadata reading code
Message-ID: <67200b65501c3_bc69d2943a@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <7382397ef94470c8a2b074bbdf507581b1b9db7e.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7382397ef94470c8a2b074bbdf507581b1b9db7e.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:303:8c::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3d5e51-ecab-4289-0138-08dcf79d1439
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Y7wiul9wBeeGR3M655IWSbpsd1ku5ym/BJML+U+wSd6pBnzZqHfa/sw07G6n?=
 =?us-ascii?Q?+UTNFJLYAOIZJkxvqGmC5YrhTL/mz/i6TtNS08j5vfwSRTITSffQEm+HLqxq?=
 =?us-ascii?Q?/jsesC2XSWqSlrdpR8HEwWyaQObItdkUx5rk9hVJzKuyOCxCsEcKg9kl+WSt?=
 =?us-ascii?Q?zsRPkx+kR1vkuNgOoKbU7oXQMaLKYxELAlSj2skviYjxizfRuXYHwQ1MYqzg?=
 =?us-ascii?Q?5Z4wVM8yO9LYhq8FqjCQWO5/a0dNASi7hx3sU47/XZjKUPwghOvgkrAL761e?=
 =?us-ascii?Q?h4h6Kdk01ekh2SrY6pkadBLHUgGx0pxbIfTRIZhEe7Hj0MJS+py9zDX4hTJ7?=
 =?us-ascii?Q?8j7YGspL/c0VjgnHUdvkJ6my/35HI3sZnMAGXeTLnlsIA/sqU2yZ2zli/wuv?=
 =?us-ascii?Q?HvylZuNo7mAQ9Fr8MJgz01DWMnbgwAy4b+JXLdKXSutTnfkJJQQXmoWaZ7hG?=
 =?us-ascii?Q?WqBQBFEbRZdQZ79MteRZ9o2SzcW/iNoqvD2WkWvDOObiUkPjATMmUt2oqaig?=
 =?us-ascii?Q?Mx/n8eQ8tnBfJ0b1VCvp1lro3p4CbH5MSuf5g386t3SlGSP/4k3I8+CfqnTE?=
 =?us-ascii?Q?1OcwkKmvzJ+y/ldEeqpxFwLBtnYuxW3n3OXc3lVegrlq4PNGIBuxSfxETFON?=
 =?us-ascii?Q?TPFh9PyGm4zn6OaWKbNDPhWyzitZQaYG3xzMv+oOD5MjdeLOZ67Y3wftwP4H?=
 =?us-ascii?Q?Tvbzo5AzLab3Wv+oJEjYwDFQ8TUWdYetYYgqYi7REpwxgXQ+RLMYmBqSoYca?=
 =?us-ascii?Q?Uy/8J2sv2spc50bf0LUYDYlY6awBJl14mYHRUbWWhLqGJ6WqmYVIhDrF7Fve?=
 =?us-ascii?Q?8GR3UAZOCXMiGIpm8TTpnxeM10ScaAmKcKXOiKIlExDUINaNZANFe2b7132W?=
 =?us-ascii?Q?IEEN6C2AmE8m437Mp9X6GX8V1wMtzfv3+HBLHf1YvjKAtgX2fQkAgooKAEmJ?=
 =?us-ascii?Q?B2ZnFMFbjNNxvfTkCy6M6ACSNJzAvoBI5ryav2+XreXd03X62FSAt6+BIt26?=
 =?us-ascii?Q?LlOCmpfDtjHIeV7O4mGnduRckaZJ+6sAMj6L4ZLFKuPVM8rzVdpqa+mQ1Dq1?=
 =?us-ascii?Q?pGkvrLq02thPcaBuRsGrxICvmpd7q6j73NZCToR6khrlu+RCkB6vUgQgQxEq?=
 =?us-ascii?Q?K2WE3Q7u2uYXGG/Sk64SzAS5dqNjyX8KxaxmIS/66QYi4rG3AiHa14T4lhVw?=
 =?us-ascii?Q?AmqO9WxwTVDK0Z6jcxz56XqA+Uz8CY5sUPRAYsZGlWO8XWRNApNmxQT7fUce?=
 =?us-ascii?Q?sl2jl1PpdJ1ehaZnonPw2yMxqxEJBh+jJnEul4iKzAr5HO4adlKTI9qc6FGU?=
 =?us-ascii?Q?Tps4OpFh/VidAksdMDk/BuitUroBQWw/6mCLfigZEIZmcBx43NTglJ6JNJM6?=
 =?us-ascii?Q?WN2tOeo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrCAx9lXxsm9A91Vd95bbx2sWxfW+j2OdvP/71AroZWrsW6li3k31AMjicrC?=
 =?us-ascii?Q?5an8gYLdkYiIhK78ji204AxNKAHEpWDP2lBKugUoTmdWu7W4Tsfnnw6/9Az5?=
 =?us-ascii?Q?VS66ivW36EbAKFOORbEvQWoUJiR3+psur6K9BehFohgDyo3b01huptiVu9Ec?=
 =?us-ascii?Q?bZSXdOlZKZjlzrF1TOrL9ZKgTJyQ3TPFsjcTSn5suc8c9nRhmxK5FwvAvdo7?=
 =?us-ascii?Q?PAMYYsKpCs0+5iNq0+VcuSJCdtJukxbPRFhsA8LcfiaDbrCCbfXHKilFwcmn?=
 =?us-ascii?Q?CwPZCjLnNCByC8xz6TnI3N8TcOIzOeFEfh1mNsj7621NSz84DkkghLjBOKJz?=
 =?us-ascii?Q?sK8mxDIX+VwZCKI4j5DY3vV1+oL5rwP7R6OL5a5gXZQZi8O3l49TShNZ9yKR?=
 =?us-ascii?Q?rLkzUfwmig5+qufNNici5B7HBdT1Q7gdq35SnsAyNKOr0d4PAawNNCbPbmzJ?=
 =?us-ascii?Q?wYWvloQrZVq92HH1D33arsybKQQn2eYeP4AOKXUdXI/NW4Z/Stigbb3MnFVD?=
 =?us-ascii?Q?caNhfENWHmJbySg9zNjfcSEvlNFHl8OWPIyAEOTtU/2P/HiqtfN7O9xi3EYw?=
 =?us-ascii?Q?hhwGWJg2p/8/rv5m/lhwOXpKkvywydnxE0mgkNg6b9Ipdg0fng//VzsBgfKT?=
 =?us-ascii?Q?WyiVYuaY7Ew03UUhyeSj1P0ALEnQtk2jXe0Ys0df7em84GY/GE/SLaFFhVd6?=
 =?us-ascii?Q?ok9KANJvffOd+hoRe2E3EuHSHTlORguT7OWiQ691m8EJVFc4ixGjRGygSmmC?=
 =?us-ascii?Q?/FsCbuEZtRxpySVOdl+Y05PS35ec+aa1mL477xIoID3NCDc4h+KwxtTMcEPj?=
 =?us-ascii?Q?dS+Iye61XJ5kEgKuxOEJIeSGHte+n69TqHVmZJeeHcQ7As9eCzt8DxE9dixC?=
 =?us-ascii?Q?T976YUMWHmtiLeQe6PqqKmluNmEGzOZBvQ+UJNnmNceBHfRcgAzSMSDRXRk+?=
 =?us-ascii?Q?wGbqQXPTZrXCTSJU/Bm0aME2BC3Py1zmLg3U+5AXX/Ob5Nj2Lz/m4ISkHvVo?=
 =?us-ascii?Q?Fh4K8eDVMCDY9B7HkI1H+Yaaz9JroAJxQ1e2rkh9Iui8Z/9whhnIwLPYk3wS?=
 =?us-ascii?Q?Gs6cUWJN497qJnLSLZ0kvCwm1pm4pEGdjoKKP63F2S0dIk/Z6Pssp1hpglzy?=
 =?us-ascii?Q?LFjF7yBCovfOSOB8lbF9J6hzsoXapaytw8Hp6kziO33QPsNRTLEEPM74mXyd?=
 =?us-ascii?Q?fM/MxJwSRrkb6UQ2RxK+LXcZkN/Iln3Mq8qFdKgSjhoiMD1L31XEANDmFNQf?=
 =?us-ascii?Q?akcGbAzCpFfAWac0+aiZehbkAWj/TMWiGnJzxFYSKmuhcJ+7G7scktNDOa5z?=
 =?us-ascii?Q?8KzMKQOmPelQZsDTNZiooSUs+hUzCZhFjYImOJskxLOGYbY5WowHrDMP+Lsb?=
 =?us-ascii?Q?wpNqpBI+CTuSj3dqFM22Ac79omXIvOItI/kRdCFTERDSB/Ela4Iha3W3aR30?=
 =?us-ascii?Q?p0nZd/rBD9qt9eLSOKUJjmcZIkVd4CFWuK5R7J5KVc8Bvzi40mG2pVsFqsij?=
 =?us-ascii?Q?+tzpay/5aMko9WVRAMPRXh+pQ+dCDju426IU/7hMGlXLtiHXk6+HdH9rZRjK?=
 =?us-ascii?Q?O+6WbIiHCFOBPxy8XiQ9hShbbqjlUagCgjIpKhRM7gz7nNre+s+/Xbj5feU/?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3d5e51-ecab-4289-0138-08dcf79d1439
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:08:40.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bzigHj/C29PBLWZ4SzJ5xpNB1Rf7Ikv3WQUffn2oOFc29OEMRe1D0JkS9Q7wPyef7hpZFKeFo0NL7wmav9z5+NrFfzFf+jvn9ivvu3uR4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7073
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Now the caller to read global metadata has been tweaked to be ready to
> use auto-generated metadata reading code.  Switch to use it.
[..]
>  2 files changed, 2 insertions(+), 104 deletions(-)

Nice.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

