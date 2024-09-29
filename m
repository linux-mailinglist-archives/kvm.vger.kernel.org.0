Return-Path: <kvm+bounces-27649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89553989484
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 11:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 180171F240B9
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 09:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EBB148FEC;
	Sun, 29 Sep 2024 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcoto6dm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CE13B286;
	Sun, 29 Sep 2024 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727602197; cv=fail; b=hoiwUPTXOZR+oFI+NdqHsutL4GnPcbykTK5qjwXLGn/QF2zFESKrXl3151dezRlxm1iCCNnCUg8Mm8aQL1HYi8de4NfTSUz0V7xrp7QKvfFDK4ZmLlwuKIXfnlnXaR/OLWSKiLcMFSL1qaqViZkHWSid/e2hWeDWI8c8Daeo5pE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727602197; c=relaxed/simple;
	bh=uLKDU1pZwAkCutDOkjIogz9mLUl7ighQbWc37TL4nAI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nHqFyUv+WMFVvSPYHspf5+TgaYcL+J0DXpdm6ZPBXbKI5Fgcf/JDZw08xeklZ1E1sGf9VH1TTTp46CvL3loONkvr1O8+zAY80WaErRx6yfigjqHGbM4hZ9WLlXO8dFnF95oRQZ30JX/LMauDTHYkc2vSKdMN172zWj38+J75KpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcoto6dm; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727602196; x=1759138196;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uLKDU1pZwAkCutDOkjIogz9mLUl7ighQbWc37TL4nAI=;
  b=fcoto6dmfix71OIkad3941tkfC7QGgwF5IhMN7rAOjc39FYiOoYcPydZ
   F/HNcz1Si8o1w8xS4GoXUL7eYgD4xGzl2oJ70bg8CQClR86s23zeCoA5L
   tRjMGs2N76sB4m8MtYImbrciu7u/gyc0ECSsAnB7A5/ixErASIJ/NmcrQ
   YGJwv7MIPaf+6jIHvBSNSjL8rsJNJEasv3NR08MQAXiKgX6LpNMRSZpo8
   xG4+oa6P3TD41u5zVuBFSbzBHTocqU1Ax/AquaGzGvDuYl3cd38Yr/N/E
   xLNiT+Im44tP4A0ti7Xqk5DBnqusK/YhZ3Qezlzwdanj4qIJg1OWMPjbu
   w==;
X-CSE-ConnectionGUID: /oZJ9yXVTFOT5HXsi8P0Hw==
X-CSE-MsgGUID: X8PCukhtTqGpgJ8jB3I33Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11209"; a="44220680"
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="44220680"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 02:29:55 -0700
X-CSE-ConnectionGUID: TI1mHUYYRPmRJdmY/pDvnw==
X-CSE-MsgGUID: PwdcWCGpQPOvkXrs2Fn9GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="73305679"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2024 02:29:55 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 02:29:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 02:29:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 29 Sep 2024 02:29:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 29 Sep 2024 02:29:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQDWWib5kZO+bxygNsdbI4ejW25VyfNH+2iFjKI66zNGCcb4xA3t0TeP4b2WjnNARq3wWIMMCu3cM568I7WtKbn8s/3HzkFpiyqYp8Lo25s2SmRjpSQbDvl627SVf2LSQSt1ymAFZAnT49Jd7orItjrAdWgy1jgVP2HovT3SG82bu5FMH9a1N0wEKLIvt7ZmVdKjbAAbZMN+p9VMtv/f95wpUIayxJcRGWfCdLU8YrQl85VVPJ/rxfxxJbKUYqZTRadZPsQGQ1pxjALrfCd/maaazGLdZA3BfW7GmKpAFZjUXo3WHD/i2bjxXG11Fn3z7bgEH9uGh4f9UI7nYbhBNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HXLv+YB6O2AXHA7RXvLSCRiuG3hjIOhZo1qlCLn+c0=;
 b=KvrAse8ioPDba7LiljCbP/1/3jAecBYysmU7/mRAHRmjapKRGkJeBTgA80qRJK5gc+zOdnHuTbFqvmDZU0b6ky1Zg5xo73I4oQishM6LdJZZjh67gD1Un5tDYLDGkXQzQqXY7bo40bpt99hfuBH38oawQhN2F6Km8HhQxzVCz26izQLNyqn1ixN8iPt4q0JV5bCscs1v248cCAKovjRiYIuzb+Nb6BhYUI0DjdUbw0UW0bZlDh5Xq0sSSlBlwN/PZkAvq0uLqUvEXfvVjjS17J2FTMgpCDAPWdpdTtvmeYggjlsg/hJHYk5378AoNie11tx1YhkpfYSN8pSJxoceQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7578.namprd11.prod.outlook.com (2603:10b6:8:141::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.24; Sun, 29 Sep 2024 09:29:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8005.024; Sun, 29 Sep 2024
 09:29:51 +0000
Date: Sun, 29 Sep 2024 17:27:44 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZvkdkAQkN5LmDaE6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
 <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com>
 <ZvbB6s6MYZ2dmQxr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvbB6s6MYZ2dmQxr@google.com>
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: ea1c87f0-43d7-4588-0b39-08dce0694546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5lQ9PAh/zcHXIqfXxKAXwe7Fu07yTf5cAMlSuW9e1BlcneHRb++melr6iCf6?=
 =?us-ascii?Q?HQJnscuvIUwGgt4kSJmMoWbsGpbMF0Ocl3GeL10PjTaRkNVm+CUf8u5NN9uC?=
 =?us-ascii?Q?9tpfk9RKx5NZWkUXqWzfhHyxnFzmmDEqLb2YJD3fmrSisBZR0TVdEfOf8ABX?=
 =?us-ascii?Q?C+p9dHXTZEjqI3Ub5v9wN56Q3kdkpzmZMmv5AwWIUCkCHqTOLISQ/5hi1qo/?=
 =?us-ascii?Q?bMf4p+bfKjIH07ifFzO4KiBGIV+mB7igTIQA9gyosX1UBjLfsNpbRzXAVgO+?=
 =?us-ascii?Q?N/61Y/d43cSxzaQfL7r8dyiJutHjTmD8pGNa/kbUUTMG2UA+U/kbrOXlC8+h?=
 =?us-ascii?Q?rMfWuXHfRSo7w0QNHBPjJgeUOSO1wMupNxhB7UvcC+WXwKxnjDCjWC/aBxbO?=
 =?us-ascii?Q?SDyVYjxBU1/865YCDCZbsri5iySBquduqNmwTT2WsxnIPsH7UfOwn7ETkCEz?=
 =?us-ascii?Q?9pvygE6secCQTqWcfO6jjnTir6PgokbSsxjvFt+R4JxWBfI1W9dWhGEXtzKD?=
 =?us-ascii?Q?LvI4zoOnJKQIArBuCI7u9n3AskHd/dgJKi+3nUB7sKi/+Mxrjmwkit65U+TO?=
 =?us-ascii?Q?NRwDuXOsqVSgXfypEubHBC9hqUPlT8nGuPOawdzlVCxAvAtaIxFzLfVyjH1D?=
 =?us-ascii?Q?/tXl9S2JhjGMVp3OtSeC3hYq+4TjVp2ys9RM1hWhNp2slxUsCuMgre4/bGxv?=
 =?us-ascii?Q?lVqCmoHpIdUZ+Pk/UbvyTyFWUN2/DVVgCWx6nb2DVleEOGoun4DhzEBYH+Kl?=
 =?us-ascii?Q?0Tw7sBTgh56ViqR0lrTbLa8nfRh5CzUffK81CO0AyrASkHW8KURIHiLOl1dZ?=
 =?us-ascii?Q?hnDkx9bLabB6lb4nzoP143ZxXKVu8KWag+dESKIZdgjHNbdPG/q97YtHq/CN?=
 =?us-ascii?Q?6qiIkMvi8+PEYm9gK3La3zpUyiuPJczkbD5p7fq+ntB19FMe/GcfN22zZZZF?=
 =?us-ascii?Q?DgJCpW7H7y+P6ODEDaWMpU7TtsUT9quuVMdzYy2VsZ0QGtW4b5gJclsT5OPJ?=
 =?us-ascii?Q?xb8UbMF/r2L9pd33y24Z/ZHtVjfkRQHfWKGlk7MDWXaDis8/rAE96pb/hBeV?=
 =?us-ascii?Q?8HuAw8pk6CQoI/Pd9Mk6rHTh/7wnhBPQWTD21HsQ53pNYgWkQMqCJqkG3xhi?=
 =?us-ascii?Q?87yUcvDeqKkzVOwRCDcG4Phpu7h85VYwsnVap4uHe/1Rxmt3/X+aZIJi9ePU?=
 =?us-ascii?Q?WCNWgQn008z3HlfTRZ5+Y5OtaPVMWCWS4YvevRJmGdgAXkopBb9oOHNjxxtj?=
 =?us-ascii?Q?AHJ/Q02YDCGOjW1zoT+lotUD2teMy/hpNdWJYYvOmIfbYGpWiS8+nBxWhzkt?=
 =?us-ascii?Q?tB+Zihu2EpkgJgsCkq+hXjtqUUoS3eCKLzywYWJvhf+T4Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bl/zC1J9orh2ryCGvN78cv34SX2Y34ELZ+jqWXy2pTEjOZb+tBQv8kVC7T0U?=
 =?us-ascii?Q?wlLPT9ziOfo3om3k7CRKvPJ5s+mnSxBwCWQyAcGGuJLg9dVOd2KHq4zHCFz3?=
 =?us-ascii?Q?yf+I8eOW1WrF+4WYEOUYHVZCut2ZpFTCfnwiwUDT5IgTQl4oSCWHxs81ZIPK?=
 =?us-ascii?Q?M2XMWbmphSFkB4SAb7jHpkaLbpEiAUbDsB6fMMBj/40Yv3X5gYvGMMrJmtBW?=
 =?us-ascii?Q?Ys27O6vFp+vjYKTAB2McoAmCITh3CqJM+shntOb7jnRz4p/IBc8LNCpJEDzb?=
 =?us-ascii?Q?LPQyDIMkIcfM76H6KyS0o6Lf0cETm8nvVp20rpwl1HreQsqZKY2nUkANQknw?=
 =?us-ascii?Q?ARilkCRoTsJsaTikaIubABW8GgFSTEoCCMbOJfFL1XY45KrfpISBTJZ9bKLD?=
 =?us-ascii?Q?7s73abupd9ICeUGtjGaRN1ixX3BHgBr4ADWtKmvqVE/Y5YtDJ1phXmCBYxUL?=
 =?us-ascii?Q?g+XK+7In2mQAVWVzGjHME0XCtyEtNCZbwPa7rYPrWXQ9e5F5joIdoReUdtYm?=
 =?us-ascii?Q?BL0P1hZhNXYsW5dApmNNo48zhBN/TxSNO7vFBm5987HfE+xbBwRjjxe+cEfx?=
 =?us-ascii?Q?gevSYxVO9Ao6pgmQdwl9pO6fDZ1QHZhrY0CfLeUmu2/acsRbrqxq2ce8JnLk?=
 =?us-ascii?Q?HaYciQzg2uqNv7V6sUgD+Onth2MKk49eFlEUjcgLLy2kNO78Ri8TvQy0VEyo?=
 =?us-ascii?Q?ywmG3HnFuoq/lA6NFhWcrVDmW8Fuf4kK2l/ISoLhcIrwMK/uSXKsW+ld8tTz?=
 =?us-ascii?Q?i0KNc4P+04HGBI/1eJTYGqkt3F7YocPUy4z/w6SxRZS3+k+XiPaLO/VbHGGB?=
 =?us-ascii?Q?L98WhQ89xiZq1humF6ncRs5gdTEjXf8QY9oCMluV8SVtTY0017fHJkhJRlkP?=
 =?us-ascii?Q?uUU3859eLKdeCuA1BezCucJXptxXD3lCdIOp4HbFXv2ngP8fohL/GINDfyqb?=
 =?us-ascii?Q?LbetybPcR1DxeQ4EXsdW99iLzO6SAM2x87M4qgCoIA1BiDVNAn7R/BRlSENE?=
 =?us-ascii?Q?YWzbUz2O/UscR55P082cZUDWo604RL8r3RPZMurgoxsg0l6817hbHzjtBaHu?=
 =?us-ascii?Q?gL58YlIVk5bKI8AU9fbRggcxVXdaXkwS7ig6vxTJS9j2aFah4rbQwBilXgF6?=
 =?us-ascii?Q?ZBXfaAJbb0geNy/mS6C4JfiAOwfBIZyLJHP2h/JySojTXHfH1mkP6YwnSyBn?=
 =?us-ascii?Q?F54mrE4n8bnIMyJlZGtLkx3TA7kS+THtdCtvg9+1d0TVYx04t+AFg3HUTDn3?=
 =?us-ascii?Q?YACpftXLoFF5XFqp8700GiFSbjT6YfIfJZetcp8Y44mcqpUtGfJAg/h7vWHC?=
 =?us-ascii?Q?CxjB4DbpcypcFPJhr11aheA0YQ7+bKOTJXujQU3ehDKz2ImRdusmJHKWvQWu?=
 =?us-ascii?Q?bgqHAJMPygyI3ALa3PiQU0rZVjyfluw/lFHAAQC7FwZ+MUxwIvqP9rK7Sj0G?=
 =?us-ascii?Q?dHXR/patxvuG81rn7DiqBsGx2gvX0AXZP4wYjd4HcK8sVajPpKTjeK8XPE/Y?=
 =?us-ascii?Q?rmFKpx6qUgVWDjaN/p9imBJzQtRO4N6yEhBkSjuCMhcx/6ECbll1vPXi8ERV?=
 =?us-ascii?Q?w5wqJ+/aqideWZgAibdzJR9IEMmdmsEg1XFuI35Y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1c87f0-43d7-4588-0b39-08dce0694546
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2024 09:29:51.9286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9ptP7cNHIxl3oFgzx8I8DpD+SGn/GBZdhHouQyS/mfyHwO85wVTOviAob5sOSbnnw3AFXiMJtYf8N6UFhN4bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7578
X-OriginatorOrg: intel.com

On Fri, Sep 27, 2024 at 07:32:10AM -0700, Sean Christopherson wrote:
> On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > On Thu, Sep 26, 2024, Yan Zhao wrote:
> > > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > > > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > > > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > > > 
> > > > ---
> > > > Author:     Sean Christopherson <seanjc@google.com>
> > > > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > > > Commit:     Sean Christopherson <seanjc@google.com>
> > > > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > > > 
> > > >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> > > >     
> > > >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> > > >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> > > >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> > > >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> > > >     if the existing SPTE is writable.
> > > >     
> > > >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> > > >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> > > >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> > > >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> > > >     the only SPTE that is dirty at the time of the next relevant clearing of
> > > >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> > > >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> > > >     dirty logs without performing a TLB flush.
> > > But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> > > matter clear_dirty_gfn_range() finds a D bit or not.
> > 
> > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > anything should be backported it's that commit.
> 
> Actually, a better idea.  I think it makes sense to fully commit to not flushing
> when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> TLB flush.
> 
> E.g. on top of this change in the mega-series is a cleanup to unify the TDP MMU
> and shadow MMU logic for clearing Writable and Dirty bits, with this comment
> (which is a massaged version of an existing comment for mmu_spte_update()):
> 
> /*
>  * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
>  * TLBs must be flushed.  Otherwise write-protecting the gfn may find a read-
>  * only SPTE, even though the writable SPTE might be cached in a CPU's TLB.
>  *
>  * Remote TLBs also need to be flushed if the Dirty bit is cleared, as false
>  * negatives are not acceptable, e.g. if KVM is using D-bit based PML on VMX.
>  *
>  * Don't flush if the Accessed bit is cleared, as access tracking tolerates
>  * false negatives, and the one path that does care about TLB flushes,
>  * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
I have a question about why access tracking tolerates false negatives on the
path kvm_mmu_notifier_clear_flush_young().

kvm_mmu_notifier_clear_flush_young() invokes kvm_flush_remote_tlbs()
only when kvm_age_gfn() returns true. But age_gfn_range()/kvm_age_rmap() will
return false if the old spte is !is_accessed_spte().

So, if the Access bit is cleared in make_spte(), is a TLB flush required to
avoid that it's not done in kvm_mmu_notifier_clear_flush_young()?

>  *
>  * Note, this logic only applies to leaf SPTEs.  The caller is responsible for
>  * determining whether or not a TLB flush is required when modifying a shadow-
>  * present non-leaf SPTE.
>  */
> 
> But that comment is was made stale by commit b64d740ea7dd.  And looking through
> the dirty logging logic, KVM (luckily? thankfully?) flushes based on whether or
> not dirty bitmap/ring entries are reaped, not based on whether or not SPTEs were
> modified.
> 

