Return-Path: <kvm+bounces-60268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B443BE6289
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 04:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 21C0235151F
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E05F248F5E;
	Fri, 17 Oct 2025 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKb4lmGM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D5F1B424F;
	Fri, 17 Oct 2025 02:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760669596; cv=fail; b=sStR3np5OrZV5PgE9AQzgylMYRWEHSc0LYlSYSLFZUNpLcu5j2w5jx2qlxNRPlZRpQjU801r4OoX025J7fkfQ1RCwKyXKufx8RUEpOQxisZ5x+MvsiXV8WjWeh5buoGnzoPWD2KSmd/IpyeGDq1A3NbVdUIhprKR/fUFAw/4DqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760669596; c=relaxed/simple;
	bh=p3iAZM0rfMb6kmiVZiWJSdCnIQIC3lM0tv6n6PeTQC8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hc+90QXZ6LEbAzfsGB1MgKnenmpyCR02ACEWaSVMBXEHnbkPvKWhnZYYYvTmgi9qXw/JKxT9zOojtn8awJSkocpMXhcZ3M0E7ZVEcAkZLhTJOGborFV8/lj34MtcaEN7qngWEMu6+qaksn1p6k+B/umL9Ibyjy3JgNPclOrEZVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKb4lmGM; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760669595; x=1792205595;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p3iAZM0rfMb6kmiVZiWJSdCnIQIC3lM0tv6n6PeTQC8=;
  b=YKb4lmGMsAvuSxVIyblcEMP37ZD43/H4CmMo5aakDYTHAq2I08FjZ2Dm
   eTdp7xfXSXe1uZnKneA3ZH6l2J95npeZX23ZCc/y32L2HKHNH5NLjFG1m
   yIlbtkfpq2ci0DGT1Oia2OLNluUmlfjdqCYDSrdOG5ZF6A8H1HVQVQJ1C
   JsY6AFKS8AUVqgq2+3mCUhaj3U9L+RvaP39+6ELAJGSX2SurNMop80MVg
   RHn256lmhwdGkuw7pYC2yusnATN9DzRnCvIqS6DEaOPqRhepxp3V6nGNk
   dxWJeSgNVeA+yE/3awJpXFd+fpaHg6TPisUPMuCeZO60+SzlDvNqu1Myk
   g==;
X-CSE-ConnectionGUID: sknttWAmShm8RG5esDhepA==
X-CSE-MsgGUID: lIYARuDxSyS5CZg5KGLPsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="66740147"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="66740147"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:53:14 -0700
X-CSE-ConnectionGUID: FpZyrjDlQNmJ05LcqpTOvQ==
X-CSE-MsgGUID: 5I/181kpTHmTsrTPm7ofNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="187892888"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 19:53:14 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 19:53:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 19:53:13 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.59) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 19:53:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTzK55nq3MqOPgsEZXajT0zZs+ZcB93kLWZSJoSGCkaqJIr8YHIkSET2KEf8yLtwvd7XhANwJ4hWKaaM3I1SnFBCCifiQNDRdnX9y3fDAKXzuL0GFbAB/7NskNlNvuoGER7qlOKHVO3cQp/rU7DF4lDPTTOV4BN/jex7bIwCQPZB+TD12yHIze5wE2YFE15fG+HDMOryBCnyZvSn0DcWNS+Tpj0bxAZhR7QWPrfb20t93c+CvotuWwwWrsztYWxcCtqFft5JcKh5vzDCtZNoIIdm/YfwbNIDJrRxOae4IOBCEUEKvac3DAuMAbUkE1Uu6wHvssFUz1GOmScwzkRTdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwAg3cZz/+zfZkEU4sk9lKmn87pwxYd/BjfXXcyWFQA=;
 b=ynCfulyIhf009uPfNk7E43i6my2YV9zbG3UKmMf8PdESgZF9OVxQQNhunH8j8D7sYRDE0qoKucf4Cf3YtHOG8oz0VMUfSp2vBshuzJbc4Y45arHqHjGKn0pZ8JSyY8xoDwNvJbnN8fklzU7HzgJ1bKhbLFJ4uFI5bC8G+F+nlE98/aHdELrg4tM4pce4yNopfL7L0SaYFqDy0ykQ+E5M8fidG+ZkZPC7rzh9iFZJ3iAEFNSkChonyNlOmRmGKbBYXbhKNMx57HTDDOnD70kmrdhucKXnksHfKN3K2IXWrgMaznLv7/fXI7j+olWKWkzfw2NuPoQP0ScPoVNyIemv+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 02:53:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 02:53:10 +0000
Date: Fri, 17 Oct 2025 10:52:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov"
	<kas@kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v4 4/4] KVM: x86: Drop "cache" from user return MSR
 setter that skips WRMSR
Message-ID: <aPGvizIrwNX8aqr+@intel.com>
References: <20251016222816.141523-1-seanjc@google.com>
 <20251016222816.141523-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251016222816.141523-5-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA4PR11MB9131:EE_
X-MS-Office365-Filtering-Correlation-Id: 185b6cd7-a9e3-4387-57b6-08de0d284e59
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jQv/0Z+EqWEWxhu58P5jY68VLdiBfd5la+HK6hGTpaT9aWbKy7xShIO3zViB?=
 =?us-ascii?Q?TCLI0R1s5ugXBnJd+2W8vbJNrTadHxwLBYJauTiKLqgZtw6rQhtNK6nJnUvn?=
 =?us-ascii?Q?wLkutYD8Pq3aWHI0zy+NGSLHef8U2edUF14otkYGEPHyEYjv7vBiyXtq3zyR?=
 =?us-ascii?Q?Rx6PLQiB4NwXDnjQrUkcRf2SxwXtSvgPdCDmH0o+U6P9Bo+LZHcSS6AT8Xvz?=
 =?us-ascii?Q?F+9EyTjGuOdL24zImONP7ORq7i3MUTFDdceTMIVVSBy2nj6qQ21yOdvsWSQs?=
 =?us-ascii?Q?xjSc9l86AeOEiv5th1xFUtTTNyuDmStHy8/Wp/z1XWkvo9voObw9E0kQ3MmX?=
 =?us-ascii?Q?Uw9+yg18VgnhcR2Hj06YHeIT+AzDpIVUyTsAifkidyWGRPe2pUSZ4Bo0RKtH?=
 =?us-ascii?Q?83Q1FY9Hwk16HSlijGVjq9JlUWXcBX1azcD1DZLTo8TYiLWTof/IHeWkeu19?=
 =?us-ascii?Q?4i2c6hvL/wEUEU1aCSXAMwqnHqONk0SO8whHPi/aQvDmXbge1coFqWGHoeRn?=
 =?us-ascii?Q?R/U/fvLfllq7jF8JtNITSiaorXAQk4z0miMx5v/cwtjBG6FNUcZnKLo+dkrw?=
 =?us-ascii?Q?Dovkic5vxkgf669Xvna9eo7PtapD0K+T0XEfs2vh/TY6L2hQ9lASPXxmeQ6E?=
 =?us-ascii?Q?m4tEr1wnDcYrtD3AtTGR1VtpgUvTkAboNr1LE57xj2VrhJo0Y2hbnkDdmN7G?=
 =?us-ascii?Q?wabSm+YRdWWeRMcICWrrzFav8htFT9ux0YmT4yJ25BQSMQOZRSgY10CKzfnu?=
 =?us-ascii?Q?HNK4b96fTVIAJySeYMVzCATwCi5NzMK2XPXh3OHq/VgsmxRyHV6ckrIk4TZu?=
 =?us-ascii?Q?hXGHDvPo75nvKFuIyZ1+jyeAH/4kNi1vt9xW+ar7hONAUMSpbdpCA17oguda?=
 =?us-ascii?Q?alIu+YvjoGMMxJ/xeSga2xaLQDKbKD+7HOwxbc416NerzoCgsGDl2SJv5j2I?=
 =?us-ascii?Q?LhWyWN+PcswAhMm+qFG4TTZ6+l5JGyv5FyCBz+QInpdPNrREAMWQdXct3lKs?=
 =?us-ascii?Q?yxBqW0b+Fc945V3IpxCGfm9uroDWgWz4cpbeI8wKvyYdWq8rexL16s/WyyEq?=
 =?us-ascii?Q?DROBv0vuTHZMlk9IFRiSim6TQJfTbin7eAUUuGm8OaMtIrmQBPBF6b2yOFop?=
 =?us-ascii?Q?KstcyXRTNqxziLXXyhlL+xxEEhNIxiaVk4s6KxBKuEA+rN9DdYX8h7xK9Rrs?=
 =?us-ascii?Q?ut9KS/4pRrCXAhTWoE5EWtWoSwu22ybmOurMKw52H99qXVUl6oxYhS5gB0io?=
 =?us-ascii?Q?O7wwqOR4lYYM/p7QMpCdniBUtqoSbC68+Okq7g4+INSNP+WOTbrSmxb3oG+V?=
 =?us-ascii?Q?yCbD7kAsOlNBQW4whAKugYs1UIVPx06ZUdmbczVPLIi475+jKE2WYpbeFWoq?=
 =?us-ascii?Q?/Lc1CjEyFPllDOZSFVUEJ+OM1klxAifqSaTo/8sp6V28wwXCy3wNFHXpHe47?=
 =?us-ascii?Q?nZsgjPR9r4iN9rKza9t1X2QV9CoSqvE0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUcK+fCwnRHTGA8rTYOCuAF7w90fdDcgMAyBUPaKWua+ubWyRd0R3EqeYeKJ?=
 =?us-ascii?Q?Ma5F9zkNom5/hYi3lWBzT7w9Ifupbn7KN5CSw6mkwWSbcZ9UuoNtPVVvSZV+?=
 =?us-ascii?Q?r1bP53ygO/v22AX6uuaClqXuWxWwVQCG61u1ZxDd0Nigh/3BOwsrYp1q7apV?=
 =?us-ascii?Q?Q5d4YgxmfV4JrNy4Bo7V17caZ3/aJXGQJOk26lC5DCNMnYhBREgys6Ik4hNA?=
 =?us-ascii?Q?x9z3CxqO02u65ECEpggGWIt1zxbEBhulJsWEYEDJpCrmkd3O/DWDTL31SOyt?=
 =?us-ascii?Q?f555o21MenL6//1sfHMf8hcHKCjjTWs8EcqKaRwKFXDfd2tzKv+s2rHagV59?=
 =?us-ascii?Q?NwjVy/ARCW4loOzIzWrJHGoZCDgpnTrl6SxshSQOp8b67RDF861PKkAXoyCh?=
 =?us-ascii?Q?+tMvgBXaxNgFy54GGR8Qptj2R6bWcUklgq99PZe2xz8bm17xTvHftN1SP8lb?=
 =?us-ascii?Q?S8Dbr0SIlLKpseUf3x9D28IwxzCKPeJVjhk6fOL2AQwjur4I+50P/luQxINM?=
 =?us-ascii?Q?X6mL7AhraGWGgaE+uhAuIJIlxVtR1yAuOXPmp5qG31FsuJOYz7PPU0hzYSKH?=
 =?us-ascii?Q?r0nrf7sjMF3nnZm1/HpmHix8FyW0mZ0TuU0LxVNGisNta4Tb8O3kcI/xIwl5?=
 =?us-ascii?Q?v0xNqOyoeec/oZV9/wGE4uObxuYVGzBObwoEkM8SMdKP3nbJDJy+EfS8zXjt?=
 =?us-ascii?Q?hWYpe94KYWCi167fag/swo0YL/spdRyVXANos7Q3UA5g1dO2wNg5XzASjckt?=
 =?us-ascii?Q?8LvyaLLTpAe++Socv2DT23XgW9An4CynyXICBwUNlSjC+BDsoZVzSchVQ5Hd?=
 =?us-ascii?Q?FiY6Sa4Z/iCg8Mx1pashaK0XBNjWnCDt76vec0yHQfvdh1r7kIoo63wpHg1U?=
 =?us-ascii?Q?+IoVcDlFIzSPt830vES79B0ofzxFaU2Lyfr9lFr6vwFPyeoX+u/91L+ATX5z?=
 =?us-ascii?Q?nBiUNyVkENBibt9IIdNmX/cEuB0BSA4+793H4MJZTO8q/SxLGJX2hE8A88qo?=
 =?us-ascii?Q?wBQYw7dbhKPLOZFlIO53VXoTN/c6GRJGcv40lDU5TMNO5SARuKqPmmR2eozw?=
 =?us-ascii?Q?/EGTF9K+79nNoUlicOn9XHBHlljKNOf9oG6Lp3n7XMtDQikPpN6Z8ibKVfCr?=
 =?us-ascii?Q?C66wqmtCiiRpl/x8vivqK2cHzcZRLu52WxVC/YofC3Ab7ksZC9xBX4pfyqHM?=
 =?us-ascii?Q?as1TPYtrHLGBLAtgYPzjFqSCSc9oWUphsrzTuLdpkG6ziDAzvbiK3uqO6+OT?=
 =?us-ascii?Q?KgFSMI7lVnLk1ukT4bM4UReyGy+t+4kL7rwRHddbPETjwz2c8FZhtfZFv8d+?=
 =?us-ascii?Q?Os3bSS98tgqtVRPd6oliPRj7XlALendbTzOiPNahYTO7IGKk0hcrgljqtfPL?=
 =?us-ascii?Q?yGjmM07hB+RH/KbrEP258rNo4x2uNAd7SY8o9wAQPAWmUUS+yG8bY6A8S4Fl?=
 =?us-ascii?Q?D7u8pQ9BEdcyr5pIqZbyNjHO5aKwjlQPJLtUDwRoups2Po6pjXDfJrX9wHGm?=
 =?us-ascii?Q?XScK+2ve8FW1FWRHI5IQ9pigPygws+U7CuqA63oltHv7fP2dtG3xIJyvN+mg?=
 =?us-ascii?Q?fCOgsYPQ7ZKFA71jEorqKNK3IYgUgXpamiO0Kl5l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 185b6cd7-a9e3-4387-57b6-08de0d284e59
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 02:53:10.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VayVSmJNB9fZy5uvN7TryhRSmKHYDbwhe+SUvZDk5x84DtVMnVjQYtLByXifpNDVgNR7lGlNWX2803gdVFIJwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9131
X-OriginatorOrg: intel.com

>+void __kvm_set_user_return_msr(unsigned int slot, u64 value)
>+{
>+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>+
>+	msrs->values[slot].curr = value;
>+	kvm_user_return_register_notifier(msrs);
>+}
>+EXPORT_SYMBOL_GPL(__kvm_set_user_return_msr);

nit: s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL_FOR_KVM_INTERNAL

>+
> int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> {
> 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>@@ -667,21 +676,11 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> 	if (err)
> 		return 1;
> 
>-	msrs->values[slot].curr = value;
>-	kvm_user_return_register_notifier(msrs);
>+	__kvm_set_user_return_msr(slot, value);
> 	return 0;
> }
> EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
> 
>-void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
>-{
>-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>-
>-	msrs->values[slot].curr = value;
>-	kvm_user_return_register_notifier(msrs);
>-}
>-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_user_return_msr_update_cache);
>-
> u64 kvm_get_user_return_msr(unsigned int slot)
> {
> 	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
>-- 
>2.51.0.858.gf9c4a03a3a-goog
>
>

