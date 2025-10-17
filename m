Return-Path: <kvm+bounces-60275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F55DBE66F4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 07:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0D11C4F7E58
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 05:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B711F91E3;
	Fri, 17 Oct 2025 05:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGRSOt3c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC63333468F;
	Fri, 17 Oct 2025 05:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760679182; cv=fail; b=gCifksNI6yr4jr1VbgHdgO/fcZFLqpQzHy4ymqL2mruHaSjg8Cbf4RpHYpoTOFK67drkvTqcyQdOrp9m3T++jX9nG7NiQuf+nsiuGy3EUK4mnJ/58PaV35ZAwlp52upGFLV4QyspaopIfnxsoDAaxUS2PbZBRSkENYlIP85xQpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760679182; c=relaxed/simple;
	bh=BDHtloOBjbHTccgbueB6zSFm3uhhhABMRwwL5YZyTUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KHqMYanxmZPTVBeByVjAkERYf7GCVdWe0SCYOLx+vY4EyHsr9r2vHIG7++LRzyflG67KHuC9jTM4uWDdMVZ+lyliJE5Fi5++pKa+XmOAVYxyhnMoxdBjipuFAVgbTjphWkFLpGIRKEWuJFlm1KaJKoNbhtXWt/yPc3cxfm15D8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGRSOt3c; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760679181; x=1792215181;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BDHtloOBjbHTccgbueB6zSFm3uhhhABMRwwL5YZyTUQ=;
  b=LGRSOt3cHOg50GKarZVZxnq5TqHVGPPezfD0IUQ7r1XHs3n9hBhhcEMz
   C9i2Y9R8pmmOVsOV6lyuTyAFJg0UUKSBFH8M3OR7zWyTmZWsbzX4t+iYP
   97udmvLjx7pZcrPQWSsib34dI9vZrOvJL1WkfSCo9lXfaeq1I4huGvu64
   yDfbhUQvrsJy4KWIp3hkipuGvgW1jxWHSOlhRg9qH0pwE18zJOxmeBQ9s
   /TpZ/rqjmPfC6FX+QvENyVv+d+SVaIljpvuMStxl4c//6hEdhgKk8EppU
   APV/Dq0y9Wx2jp8/PCmAAibm8dqmhHMyQxYv+zQht3T08Coq0GynYTFua
   w==;
X-CSE-ConnectionGUID: d49y1otKTsquZv9BFuJrYQ==
X-CSE-MsgGUID: bLoo1VfuS2qxayYdnUpmjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62921874"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62921874"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:33:00 -0700
X-CSE-ConnectionGUID: OW2wGyV3SQWTga1zyzw/sg==
X-CSE-MsgGUID: ciRKDfH+Sx+PTOx/e81eXA==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:33:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:32:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 22:32:59 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:32:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p+xL3P9yf5koRve4QQofbmwOzLyLWtjFtjA5W9nPTgRY2byVTmEJ7/6vzwhfRfZPPCcUgdQwfD87T6qMawAW7vUbogdMi5WLI6EO/rvdPayJboLvs2iWWxvvBfWrWeWtP6RqvrOBFzj8JIR2NFJ10948xQwi4aGt0aj5rVTNgjBtd2h0RLaaozjqh1KKUgWfMstchVo8QqPylYnuJ0wf/Z8H8ShZJ+pEvENWQ5avZv+xoARpUmYxAQ2sgK2SnlVjK1nr2m1LYfue1iA0JKiZw6KJJxQVvysEqRtQ/Y7/Ycpcdh9im5IZGNdarUMEOIZ28yxhratzYtj8AFSEF/TfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vU14fMuQ9vc4Nc9pY7dSrHMWkoBsKki3qga7TtHSTng=;
 b=MXAa26jvSqSZ2E8C4nVnzu37G6bj/9TqpfNc+g1RiJWPYHic9DMYs13SsBcLwTGtFhFkPnuA3Dg+CvLWrUQam1aSfpRC5KHL/LHlRdGWFlQcYgz/ItDqKD1V/2pqJiwXHN60wB9KARKey6uRcHimsZctYjF/EUaalWvjdsGI88og3gGcQbxk1DXLn1pPDBWk7PSoH4fa+jkMDHddjGGo8C/myQ/MotnfWubcHxXOVKLTCEQU5DLvzXBsGz/fxZwWAOPbyDumBgyGGuwGuJi2MpanuSTUEsnBydeXe9MA1bAUBvowIjgpsgtSa7MDFS8xq/xNU4xckYAoVpMYacJpYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8706.namprd11.prod.outlook.com (2603:10b6:610:1d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 05:32:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 05:32:51 +0000
Date: Fri, 17 Oct 2025 13:32:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov"
	<kas@kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v4 2/4] KVM: x86: Leave user-return notifier registered
 on reboot/shutdown
Message-ID: <aPHU+RZKwCK0BK7t@intel.com>
References: <20251016222816.141523-1-seanjc@google.com>
 <20251016222816.141523-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251016222816.141523-3-seanjc@google.com>
X-ClientProxiedBy: KU3P306CA0013.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d071d6-a8bf-4592-c027-08de0d3e9d6a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qN0l81I0+7CXTmGsxJhFO/7UpPDHsTfBbkM5DhWKMURbpQksHYFM5YMNwMgd?=
 =?us-ascii?Q?tha0H1guY8TMbprkMAh2FiCIaa8Ksf/D4hvjVBahBV7jZ7jLJrc8PUAJ70mo?=
 =?us-ascii?Q?rKKCzfQAYviFG+gVSMgLgcg+l1m+ydynyqr6CjVU1+RwECC97VPe4sod6B8z?=
 =?us-ascii?Q?1xewY+ciYC+R+ZzjD8ve1kgtFamnJXkDVOAMfILFNtrgtBeIOnNklZvpCral?=
 =?us-ascii?Q?dW6VttRmM6KvPpwKp4Q2F9SbxX4rPR3w378v7SaNMMKiODlQTMEjIo/Ivrvq?=
 =?us-ascii?Q?QvJd+msUJteUUH0YQLfY5G+3mtzNBDRrjLsDO8HIC9epoFt5pwXJ2hj8zWju?=
 =?us-ascii?Q?RVsxiOpAx1mw+A8pWkI0s9IVugOGcyG1vf5DBKzy1jNNCZyLBuPmyIQS6rdv?=
 =?us-ascii?Q?JPJVDXX9b1RWxNHhOG3g4ykSIYpCz5M/oN1/EOYtjZEnJBT92gQN3SGir+fB?=
 =?us-ascii?Q?iPOHz2ZGo4N8g4SkPnV7ptjML2F7g5KhITtAgLeBpQ6EZANFkyFST/pV6LTk?=
 =?us-ascii?Q?EUdQYGgYIoZG1INEtPh9XF8KNkcmhTz8yGg2iSCu1Vv+6aDgQ9iaIceiMyKY?=
 =?us-ascii?Q?IOQa0VHtuYB5yqRs3v9bxFdJNuE4YLzECLHNy9Cba+kaPuYqxK6A6ET4nihw?=
 =?us-ascii?Q?qClMEJk5UlL5Ts7hjzcad9YZTwqxreaLW2+dMdrV+cYQDkhgh/xzN0tyjKZq?=
 =?us-ascii?Q?N0DbdaPXOJOlyCXJzOags9L7lH30/ImqL879GsoMBk20HQypNWhP/YO7SwHf?=
 =?us-ascii?Q?u/S/oKq2mfcjpB/AxrJpMIB81bZoaYd3NUToL+/4NmK7xAwKGsjCOdckTnBx?=
 =?us-ascii?Q?X/kK3Yy7LyI/v87lBNEh7eNfp0UXOwR66zij6A/wxfnWs0LQTIotrUvHHR/+?=
 =?us-ascii?Q?433GxPvag2o45IAZniXicn9BcPEOVp6mq8+a7Ot95Ya5fgvdOHmf9mNo/HRT?=
 =?us-ascii?Q?Ct2En9l1N1+f6HN2/fpkxgAS3pHm1mud4FiXPb9Kt2xkyKtZPEW2R4A8xoLb?=
 =?us-ascii?Q?BtoYe3Bn8G0IRKp3lzAvREtgsmwv23N5t7VXPVk211vYAdsEWfBWOv/w50O+?=
 =?us-ascii?Q?EV0hKlLHDdNFLK7PRBcRE+dzblyWk/YptSO+HAQlFmaC4HHXkYkmbeR3f4Qx?=
 =?us-ascii?Q?Xgqizhf1kbXX9dixrXaBQUU0TIVKFCmnVu+Gb0ywHvpD+i39lDDuyvyPdwT+?=
 =?us-ascii?Q?vB1PhLMEVyy0KmNSnu5Y3y+EuxPq8HwvdSZ8/tc58xjtJ6y9bKSZAuGl+rad?=
 =?us-ascii?Q?Ax/Vvt1iR85wqlaFuacHBF2W4bbPxDiEOydgc1jViQ8GCAe//3YoQbq2L6xc?=
 =?us-ascii?Q?gawAVVbTH3neV3zlrzi7D6yVOhR1Q200XGp06nOxQKWIia8xoHuMDxmeg6zT?=
 =?us-ascii?Q?SXsqC/P8BRfeKrsiZbIMKuDSU94n3L0wpuMz6f+xBaH4PSFPw3ElI+YpUIJl?=
 =?us-ascii?Q?C3TchDxbIMBFb4OTEOyF1KCAvLJIAZgo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AMD0bRtwrhazqc+MwbJPLj+lXh/0S9VTZg/GNK+COwJJy3NzITzLIT/soHu3?=
 =?us-ascii?Q?zhzfbJt/5gmR/7ZotcC3ecRfhG61JZs+HyJTWikt6Xq6UAc2buAZQNkaIKAl?=
 =?us-ascii?Q?RybPABqar78iF3cDlThwLC8fh85KbA4sfA8zqaEGVi74ZX8InF9iXJLDGaAK?=
 =?us-ascii?Q?BdMIgcqvGn5LbyHDwzk4p8hI0JxDlKgm/ZFnIrv4g3yqoApe+1FeMG6bgNkM?=
 =?us-ascii?Q?tQJ4wGCF0h055XO61NY044F3E5p9jcM0gGQSTfbgwGSooqX61e0XAPGE/8HH?=
 =?us-ascii?Q?gH16SmyjZCnXOSBxOAlP7nCegessZu4DHOe2gx7xtNS8X3WyeiNNJCZCNwG0?=
 =?us-ascii?Q?8zvcERfsto3Ve1mvPko2YOGovJsapr2xq8X1zk5d+qA40ngv+B23JRSbrSI2?=
 =?us-ascii?Q?q2T/xnNKPHdlcF1JbHUU2UWVwfuOjW2Mcig9N63itarbUeGQ9+404lSi8jzp?=
 =?us-ascii?Q?L6qX7VnmWsrVClLWMY07WMLQDjgeGvGNIsecd30BUXoubLFmkYb2YK5O5Peg?=
 =?us-ascii?Q?a6T9JCFoIq8MXT15UKxGkyNwEvxqLGgX36gyaEF1iXHYdiN4OkTmfNBEaJ92?=
 =?us-ascii?Q?aN6Y+ugqZ/Xohs1XkevWfvJLeCjBh9V/F667EisgC3gICnnX/zGHM2+ha6RA?=
 =?us-ascii?Q?C9/MEkmxTCqg4RJuiA3Sj3sNoDAPMPYeo1nfrs4R8CsgzjPgsNUWo3S2tPff?=
 =?us-ascii?Q?hUdPz8OJILIxgxxJlExnsH+Tx/eU8STpV/uUXVpn16eayLJ5oNHiRDyEaIip?=
 =?us-ascii?Q?vyesLQw+wya29TcyOjfBuU57xXJnyY3XYuLah55/SB69/kRfVkfeM8LgYm8o?=
 =?us-ascii?Q?RVbH3v2Nex2GXDCkU4swsJ4qKcavbAZkCHBHnsbQmWt9T4y3SH3N+/pIQbQW?=
 =?us-ascii?Q?vjFGQPxF8ky/ufAUWleK9Ff9VIpuVXsYW1ih7G6+p90e12J9IFZ/V+1PPBeo?=
 =?us-ascii?Q?3hRPRTe08YGVobaUI0CjiXFRryQarQobdYHWBcaeShcjvLNlhCKUTi2e8nXV?=
 =?us-ascii?Q?jyYcl/DtfDYWbYUzkXAI65laS943pTT/8D+JvYmhwYs5XTzMEwaJFOnT+FxX?=
 =?us-ascii?Q?Fb50Mzcgizs3Ys7XgMKvdr+alJIN4XeGnoN87KPfumh9eWQbWGIyViozaSv9?=
 =?us-ascii?Q?zZe5YFHzKcfLYXUUq8Oc69E/wuf+9peCUwdci6ZBkgXxxjQbk79CFAyY6/7h?=
 =?us-ascii?Q?phlUtZOKkgAIZHUviQRCdBPt4qgYvPkiqMtgvsEhR+nDAEhMPryJebTK4Z3I?=
 =?us-ascii?Q?b2BDo+EN9Jkbwnn7PPSp+Hl8WjMYmqmYfJyJRgbvyBAsP1eB8Cr4QMnLMaiy?=
 =?us-ascii?Q?iRMcEuL9CQVj7ek/tzmyczDmAdiH2XLyBoVzsayCE9Rpm0nJKGr5Plx/Y6mN?=
 =?us-ascii?Q?uQWHIb4muPZqM31yTvqCkDTHXcHSH2kxaLYk2haUgZVVAB6GhVo7YOB8O9Bk?=
 =?us-ascii?Q?bY7XChnyV3/KMsqZvqJL6O+aqZVJduoHdw2lXCUqdh3U3L0fdo/BYKN4YYVy?=
 =?us-ascii?Q?KJQ/Nhcg2jKDghqcju2+eIqCqOU/Ruwb5deqfDCgcQnCq/DHwP4s9zN94e0R?=
 =?us-ascii?Q?nvZKintQg+cZX8vTIJExs+NVc/dKv2rBUNsJ86jx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d071d6-a8bf-4592-c027-08de0d3e9d6a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 05:32:51.8314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8PdwHOx4l+s+Spr+0PVdrA2EPAlsIAxRcoxGLifk9xU7WW8MHADMfIXXqNGU1g2y/vUq67iRKn0Ip+h8BIfAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8706
X-OriginatorOrg: intel.com

> bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>@@ -14363,6 +14377,11 @@ module_init(kvm_x86_init);
> 
> static void __exit kvm_x86_exit(void)
> {
>+	int cpu;
>+
>+	for_each_possible_cpu(cpu)
>+		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);

Is it OK to reference user_return_msrs during kvm.ko unloading? IIUC,
user_return_msrs has already been freed during kvm-{intel,amd}.ko unloading.
See:

vmx_exit/svm_exit()
  -> kvm_x86_vendor_exit()
       -> free_percpu(user_return_msrs);

>+
>t 	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
> }
> module_exit(kvm_x86_exit);
>-- 
>2.51.0.858.gf9c4a03a3a-goog
>
>

