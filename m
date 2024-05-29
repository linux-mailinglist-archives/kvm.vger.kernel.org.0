Return-Path: <kvm+bounces-18268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EB3B8D2EF5
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 09:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE5A11F2348B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C148167DBE;
	Wed, 29 May 2024 07:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRGfw0HL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE68F1C286;
	Wed, 29 May 2024 07:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716969420; cv=fail; b=rAu0bSNepUpkCPR04/rcNmesfSUMVjXitLYVyZMUQGCbRUuXqYSuiyoJd/X3GdPugT1M7F+1GSFA7HFRqaaYrB3w4vjsZnWwCHBdRdRa9VjAcu5nndS080oaDUC1KjavDK80Jc33I0Er4A+t+K0uRe0pFNxV5oqqHVNM3nbZFZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716969420; c=relaxed/simple;
	bh=C2lIaPyQ/BVtgjVfJN6+xRLH7RrWWygvdAwUmP3xMe0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kqKnHYqKSyRUakuI6xPlC7+AMywzHhHSkak9sRKhVnr0rvGpVx5N4eWrf4y/olSNKN/AIIzsAzsbfh55IHG5hnmFwxZbKQgTGBYsAtPvMh+mNAnyk6iBeFFDmTI+g8F5W+I7sXV+qrJYRkfqnCeEp0vIeGUCqcfi8OFD/8Prdy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRGfw0HL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716969419; x=1748505419;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C2lIaPyQ/BVtgjVfJN6+xRLH7RrWWygvdAwUmP3xMe0=;
  b=MRGfw0HLBLeMh549fOQ/HtajhEsJL+E0PY62x9Yb1qtfKaiHddnRumIl
   /JempnwQD1SlW7JW+hDuK2JTeTsbpC7qAwwV8S6PRCrH/RqTwtn+R4taM
   ozoSv9BU4vDOKxTrt7V0nwCtsOhREAhNIdg6uTmh9evaOwF5I6BXKCKo/
   6q+xILDrF5BxzyQcBWOU+CCzeL4thKvZ43PeMJj8t74KpqWQzLoO3ZLL+
   S8GLNPSX6OU7NubSjuP+mCQH9xfE7ajNhwmBiIuzq8z2+Nov8Sv3ameeq
   qP239Ap5qSq/KMPcZfg0aqZOfotMcay72KiBRkUJMCwUNM5LH2opKGxLT
   w==;
X-CSE-ConnectionGUID: KhcyggMjS72s0MGAC3SgfA==
X-CSE-MsgGUID: Eof7zR8rTRWiaritJJjMFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13542340"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13542340"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 00:56:58 -0700
X-CSE-ConnectionGUID: zroLVy44QtavvGFzx2gv0g==
X-CSE-MsgGUID: 8TR6k8OGTNKe4wTUqzj4Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="35373469"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 00:56:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 00:56:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 00:56:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 00:56:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 00:56:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxWTKmzTWgyB7m/fCsYrhRW/13xlxeHpJYnTzt44ftG+VYeDBmTbZsbk/1jMqJY/JbKWLsQXYrc+aAJoXamCA5MQJIBFwb3U45hCU3cpTmmysOl4Zf1efukZwEILavqNX5F/avR/hwnJt2YBPVlzQi+jTPwh2UkuKCxxLq5lUsCKaFqiAJzwXDMPnlT+h5GG9kgtQPftuCKJhWw7nCz+OyDLL0IDI+Bzc8uR4Qz1Tw4T8PR6qi9JkCd5iDNpWGo9IcytDk0hhK+vIt7pI4uPqmzHaktXZL5qX4fRcxWYEl3s4Ush8aWedBRNa9SeCpgDbmumQTUd49qyoN03p/6sdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHB0wHFmm1BoiFdJv2QiN/rsIWBFxtNT0dmzwCAqjXc=;
 b=gkSNj61x0zEwikl/wX6hhTlz2mG4foBeCSf9e+E0dgU323Lylzkf/+wKezbZKZLbM1cwpAAcpBQGSdWGX/Z3xzDOTx8tHRarI/14EOcPBZCKbPSYMhOZKCRoh8tUSFDYLMNzVwRUJ5YLNHX0BbS66K4i0pa/zo30RoBxXI8ALAbQa0m2pCXLtQKN887PE8pXthN6/gBjpirIUTzo53U6YNEcEGkSs+ybsg9pl8QC/tWtPE7UJ1d8Ip4js5JKfuHJiTJPgdrpKHREQg9nkryFWKowHaVEW8AbE7uP8XmBClWSGodsgrnlBYuf2ao5DCmptiosIL069mTciKJFNKVEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SN7PR11MB8042.namprd11.prod.outlook.com (2603:10b6:806:2ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 07:56:54 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%5]) with mapi id 15.20.7633.018; Wed, 29 May 2024
 07:56:54 +0000
Date: Wed, 29 May 2024 15:56:38 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Fengwei Yin <fengwei.yin@intel.com>,
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <ZlbftscsqGQjWZqj@chenyu5-mobl2>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
 <ZgTgOVNmyVVgfvFM@chao-email>
 <ZlL2m3PKnYqc3uHr@chenyu5-mobl2>
 <20240529005519.GA386318@ls.amr.corp.intel.com>
 <20240529005859.GB386318@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240529005859.GB386318@ls.amr.corp.intel.com>
X-ClientProxiedBy: SG2PR02CA0080.apcprd02.prod.outlook.com
 (2603:1096:4:90::20) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SN7PR11MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c275a27-73dd-4cad-7809-08dc7fb4e80f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?t1plAF6dQjxNB2FLa/NDK0xYcpx9uJ1o7n7RLSOfN7Y2xAu4orsDdjQluF0Q?=
 =?us-ascii?Q?gy6raFHihUDZ2Jsg1hno8xd3OPwdQ+Zs7I9YUFQqkT7E91ee6Jh/kJq1HcSa?=
 =?us-ascii?Q?AeeHUk3ZoSSSXD2ehvNeRqkMFPYHE9v0fvW90Q9X/Zn8GiTVbjePaBi/eM0s?=
 =?us-ascii?Q?qzmrJO+xAMRgKvMw15IyszyS88JX4kxeTR5tyJFOC28EIMTlPPv0IfXfu7NH?=
 =?us-ascii?Q?81BfyAaBz2/BtEtQEto72xWkb6Bp8UcAhdX8I5qW0bFfc9BYM+2rIuJjecvx?=
 =?us-ascii?Q?sVtDR56/5SYmUM5BZ1ye+3YXcBlBkYX2QUuXv5Cx8w2kR2kEiMrm9a4TH6Fs?=
 =?us-ascii?Q?n/Pu6XEsgTOeaYfONzPlSipyW5k2sAQvyi6IR/4Hmvco6kcnqY5JI7xCMghB?=
 =?us-ascii?Q?Vpt6SqY2ggnHzrgYxFX2YIVx07cK7u/hFKighUwabiL9HVCbK+xMgIWTLtT8?=
 =?us-ascii?Q?/lPtL40qLDBPgNwdLfifkz6DevNTMmZD5oB8Xm6kk75XkHGcDC/kcT3y/4m5?=
 =?us-ascii?Q?2IPp6/0WXMAUi8z6ZdyZaU6ZYtJstaSUj4iUQhRcnSPU0MKcEkgxf4I1yzlp?=
 =?us-ascii?Q?ZbMFdm7prpPBtQsZwzNQbKBxNisxL3oKUGdk7xvl7NYmeQDFpQ7Ju+WgKwSd?=
 =?us-ascii?Q?763DPKHGOQeeimySOB9rjWykTpb4gxKaas0QRdK7thlUmWIWJQoBmlHS9eyY?=
 =?us-ascii?Q?6y8S+XIpCYTyGzkDHLRPyCUPK9p+0pzsOryKT6CgYGay8sEAVlzPDi8Y/S7z?=
 =?us-ascii?Q?ALPc/tZHlRd+09KIw2U2B/wbH/PM+EGlItDT2eT3rbkJDmm+mLz0qGyf7EuX?=
 =?us-ascii?Q?ASaBP6A8ZHToCXF1CpPD6ld/O2b+vXb7ccNHPwAD1C8yIfr94tvF0mG7acRG?=
 =?us-ascii?Q?ItF4gR2AN4HNFr+YlrB2WhWMt26e7oXeQZnVXZoDiVXNvwwYHGCxQ0k9/iDd?=
 =?us-ascii?Q?241cR3iLNR9UoRn0vsi7kK7+wbEDFMhOzRLbeW4yU0SAd9ez63pJeEw41yuB?=
 =?us-ascii?Q?R77U5ryehBUNT9T65QfTbdSGfJjwlGhrBU6M8+4KzHHmpEN44AjE81p6jcB7?=
 =?us-ascii?Q?TOVG5n2PtTJIeYCf1HIGC+k5VKldBP7PxDiMQr2IbqcCR6dSAPlq/2uqD+Sj?=
 =?us-ascii?Q?1m3NXo88d6qP2WhCkHJ2eYb8xidxrwu8zLlqteg7Ex0uBUcsJWUVTrB2kz5b?=
 =?us-ascii?Q?T3iydx0ZocEt5ZFQrZHmlnikOM+a/+SMDv0L2VIzTs18RcmmLS1PVYTDEmWd?=
 =?us-ascii?Q?Rz2FUmYhiOAZiYb9mBFYvL269J+sftXLphJ7/ESA/A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z7uE4OyVMPBWSKVobr7IVkCt8rBedtP/XzqPUCZgM/iqCrIx3YfPqPM8KBJh?=
 =?us-ascii?Q?f8W22RPlgOsSQBWpt2ZEGpjhTvf2HRqEhSE/3LSlneqqeM+87Y0/f2iriXkV?=
 =?us-ascii?Q?1E6k1opJY1SuZWYBwek0+F2F5W0GXO8kozChKWaU1ZfcxJK4G3UzLSsQMhYj?=
 =?us-ascii?Q?ccIOg3yJWlS0EtsKIxaC+qZM+SvUU3UuUP0l0Dzhk53UFKpJAzM6N4FAEgki?=
 =?us-ascii?Q?yi8ptnpZl5pMdG2BFcaT5QVmb1gDFcZ2XaLuJ7tBrApGm0gHxgK0eXY+Wunn?=
 =?us-ascii?Q?UnuQaQWRrc8IzOMuTzC2hFSfMZjsJ5tchXgdGLFRVDVUfqVTZuReJvm2MTRA?=
 =?us-ascii?Q?zycfPnBEoOTpeI6T3o8Qa1mzDXivTLeWGKUWvpsNw5fJB8c9Rp4IFXWhModK?=
 =?us-ascii?Q?59viiq4oPgI4p5Bwdoh6HQh4T4/ZWR1MnpmGnf2AXzYQ93rIgY5phqVIsKN+?=
 =?us-ascii?Q?yplqPYI3LWKw63wS2BQprnkwT0wrUpnGUpqGH6BZeyqCbopt6zXGb+cn2IfB?=
 =?us-ascii?Q?pSLuLx/QDnLw9p5nlYm4IGgGRXQE5Iz5te0Qmy4/btFxza9fNbKt9VwrhkOI?=
 =?us-ascii?Q?k2KvysMf+97flI9p30z8hBRW0muW/CJnV+oTONZwe+ItO2J1qh29oi4/WFA9?=
 =?us-ascii?Q?kDNuE0ujxWtNgsH0V63nwtHDxzpvzpzMqtrrbOIz1EJ7i46BGXS46uGVLn0r?=
 =?us-ascii?Q?kECvsL7k4AdSiGVOxSDVCLNQ1fC5FbfGU0WTJI66WSyn6uP8GYb9N7uyIEJp?=
 =?us-ascii?Q?XaSvG+zzJTAtGNBVtXwRRhrLnQKaWFBnFVXloQarCoE+OZSbexqtY1OF3b0c?=
 =?us-ascii?Q?9oTjqOq8BaqX1kUO9Do9M6SFOLO0XCLtcED+mJbIkG6g5Hhed6hFCgyGmjKO?=
 =?us-ascii?Q?NqeLv6nqgOb/mmdMfeaGNX/EonOPKJ6BijIaTasXEQhIz/b+IUOhpQGLxFSX?=
 =?us-ascii?Q?MV+DSA9yO8TU2nGvvzEFx1cBd0SBZLo7G6z1isFIY13Y5+GnXqRmL703vLoo?=
 =?us-ascii?Q?NuW56+WIyObhqQzoBPM0r6+sMSUwVHOtIw3ZGLTKJWeg69WpJyIizQmjnth+?=
 =?us-ascii?Q?UVp5//L5i6xpLKjhV25Na20+agt0Z0qLz0jm9tWaGag0To4oUkBH3wNotDPZ?=
 =?us-ascii?Q?KMf/rJhoB7qDlItpHu8IB+a47NilviwlYX3NwmO3t6Joifn66SVPXUIkFyud?=
 =?us-ascii?Q?uUcYyk752pr/mD3EySDgKmGC6ozjN3+alqv6+3L0O16+F8aRc8QnRjsgv+CV?=
 =?us-ascii?Q?DqbAwl/+bxFuHRhlcKwFGpPFfe5aFKE+AD9HmFkjc/BtnfO4P8nkExFsIF84?=
 =?us-ascii?Q?cAV0Pe5r9lXB1i6oZv+GEhnqn87d4BYmjhPjmHVpCb22Z7Lednmzg95CTTAw?=
 =?us-ascii?Q?xQgNNELW3apfv/0Kffuna1GOC54pINgY9/IZLM2imj+syq8mcWSsAN1jRVmV?=
 =?us-ascii?Q?pIoI7VYcRfkOKgGtrW4+GyK0ICVg1R86ZisbIUW3Pr62OWn2dq+4CuRntQ4C?=
 =?us-ascii?Q?PW1ki2BiY7fpQB4eVaKaaAncT5st60aD8Vhk+YuagtQxu6BTUGF3CMMs+ozB?=
 =?us-ascii?Q?Il2qYlEB82kEqQUuS1eAZ33VbojjQao+FNPCFCua?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c275a27-73dd-4cad-7809-08dc7fb4e80f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 07:56:54.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfX/+WDM66XmwKUvv8Szz4sjfnjVl0uNSEKIesn6WUDnJl9zM+uSBFxD7/pA5NSv+kReZdC9Z5qrpDMI27nraw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8042
X-OriginatorOrg: intel.com

On 2024-05-28 at 17:58:59 -0700, Isaku Yamahata wrote:
> On Tue, May 28, 2024 at 05:55:19PM -0700,
> Isaku Yamahata <isaku.yamahata@intel.com> wrote:
> 
> > On Sun, May 26, 2024 at 04:45:15PM +0800,
> > Chen Yu <yu.c.chen@intel.com> wrote:
> > 
> > > On 2024-03-28 at 11:12:57 +0800, Chao Gao wrote:
> > > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > > >+static int vt_flush_remote_tlbs(struct kvm *kvm);
> > > > >+#endif
> > > > >+
> > > > > static __init int vt_hardware_setup(void)
> > > > > {
> > > > > 	int ret;
> > > > >@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
> > > > > 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> > > > > 	}
> > > > > 
> > > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > > >+	/*
> > > > >+	 * TDX KVM overrides flush_remote_tlbs method and assumes
> > > > >+	 * flush_remote_tlbs_range = NULL that falls back to
> > > > >+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> > > > >+	 */
> > > > >+	if (vt_x86_ops.flush_remote_tlbs ||
> > > > >+	    vt_x86_ops.flush_remote_tlbs_range) {
> > > > >+		enable_tdx = false;
> > > > >+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> > > > >+	}
> > > > >+#endif
> > > > >+
> > > > > 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > > > > 	if (enable_tdx)
> > > > > 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > > > > 					   sizeof(struct kvm_tdx));
> > > > > 
> > > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > > >+	if (enable_tdx)
> > > > >+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
> > > > 
> > > > Is this hook necessary/beneficial to TDX?
> > > >
> > > 
> > > I think so.
> > > 
> > > We happended to encounter the following error and breaks the boot up:
> > > "SEAMCALL (0x000000000000000f) failed: 0xc0000b0800000001"
> > > 0xc0000b0800000001 indicates the TDX_TLB_TRACKING_NOT_DONE, and it is caused
> > > by page demotion but not yet doing a tlb shotdown by tlb track.
> > > 
> > > 
> > > It was found on my system the CONFIG_HYPERV is not set, and it makes
> > > kvm_arch_flush_remote_tlbs() not invoking tdx_track() before the
> > > tdh_mem_page_demote(), which caused the problem.
> > > 
> > > > if no, we can leave .flush_remote_tlbs as NULL. if yes, we should do:
> > > > 
> > > > struct kvm_x86_ops {
> > > > ...
> > > > #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(TDX...)
> > > > 	int  (*flush_remote_tlbs)(struct kvm *kvm);
> > > > 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
> > > > 					gfn_t nr_pages);
> > > > #endif
> > > 
> > > If the flush_remote_tlbs implementation are both available in HYPERV and TDX,
> > > does it make sense to remove the config checks? I thought when commit 0277022a77a5
> > > was introduced, the only user of flush_remote_tlbs() is hyperv, and now
> > > there is TDX.
> > 
> > You don't like IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_TDX_HOST) in many
> > places?  Then, we can do something like the followings.  Although It would be
> > a bit ugly than the commit of 0277022a77a5, it's better to keep the intention
> > of it.
> > 
> 
> Ah, we have already __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE. We can use it.

Yes, and there is also __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS so we can use
ifdef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE when needed.

thanks,
Chenyu
> -- 
> Isaku Yamahata <isaku.yamahata@intel.com>

