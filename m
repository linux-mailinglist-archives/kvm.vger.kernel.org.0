Return-Path: <kvm+bounces-63665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDEBC6C9A9
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1E7D2383375
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB9C2EAB6B;
	Wed, 19 Nov 2025 03:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KAe3etuP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA12B247280;
	Wed, 19 Nov 2025 03:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763522664; cv=fail; b=cmIhUzBlQBXOsltKjjOOmFzafRyqwiUTZIjGZ+yxTR4NuY95/8z7d5MSWGNYgK5AHxxOy7l/gxrzmuzy9rcXMnANzUcGoi/qDoy3vJkpDqhJ3zudDwJh91dFmhPgDIx3Wz6SitvOgrIELScxAzO3wziZ4aFuXsG8yc8y+DTOXVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763522664; c=relaxed/simple;
	bh=PhBFaTE/Y4BVZJtgdgi4LXggRtWd2/5TFKyTpcwoOWo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H3Zqx+QuY9MOM8MBmusg5/7apJXsgj5eNBD3e7I7R1T6JhDNiA4koYM/BE4fXhix1RFUx8+gOP6vn0wiwQczhb2oOTFa8Yu/LE18+W2o+d1K3jylKW7qaXy9fw/5chD/U39rRkFINUlQ2+wnEiZkLlOBw0ou5ZjE1+1bKL6gwNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KAe3etuP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763522663; x=1795058663;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PhBFaTE/Y4BVZJtgdgi4LXggRtWd2/5TFKyTpcwoOWo=;
  b=KAe3etuPRgM8ICER//0unDA1SmVPNyjwQWac/JP7ZKrZMR9oYE3sjQcA
   8yKu8utYRdkrBT5tGDlF5IpCJGOQYKYJaTKptfeSpqql/BGSuo6c2PXzK
   Zclw05eGE4y0GIlUdUTACPxNcm2jNKuQ0LN/jAAKUadmBLoUSZ56pwIxm
   8fOtqi3z8laZP6QGJpojlFYnL/UJmL71CKdwwJ1J+8PZwPrPtyb3gkfLo
   Bcblh7Ow4+lVBK7XwlKO3fc0SJksZopK8a/GJF/IOeSc9rINoX3l8HMGJ
   p9ZwanvgpFql+IbLqPk/R9BwKT6ao2gEme1JgjMSFQ5W95mmQVRh5MxNa
   A==;
X-CSE-ConnectionGUID: mB7vyodRSqeFzvV/IberPg==
X-CSE-MsgGUID: cwg089oHQ4W0ruKA5lMooA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65437655"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65437655"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:24:22 -0800
X-CSE-ConnectionGUID: CZ1m/bNPT0i6YzfrAFcEMw==
X-CSE-MsgGUID: hFkPUjnnTP67oZMXS+0Oxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191375551"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:24:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:24:21 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 19:24:21 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:24:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7GanqetnJ3U7nACuv6rIvvp/XmkHwPxEAQnv3UnEBK1bnqWfkIqfXW9vXCP//kgoFZRJtkoOea90yeMcJXsI2q5uaoCeBhGMqFuv5If448a/CBSNoLvJ+4KpTVl7owLo2kQyxWGwQyoR7KXSn94awCZDVuOcEtBaJnG75RS+dADPq0IjT1LNIqs47pfkXjhPUQ0td7R0h3I5JCEWhiCWpSQALN6XY1XXkKFvePM06dehs+H1ICDqyAXsBJX/rLN4sMuatr92i4mUy6KIQaRmZ5JHtvWG2iqCx1tp6J9wQ0VlWtJcPfK3L1cpz3t3f30+P21TiitNPNLJsQRT7awGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEPMSMXu2WnFlvlGxzaGTPEtGWEizwhVhdNo4DhLMqU=;
 b=wnYMRxJpeEPc8N/zJ+JXnPpYc27tKkaZo+r5H3sRuxVil1vyZnDKlBoar6qsQEa4eb+dQJuoAslws3UZZYAbi2kRwQULqJ7esnhbcBP5vapLdf9zFE9XKemb8Lom5N3m9hqikjztXIU08L3setMVrGf+Vj1ZYM8+jScPlpejKxHbxLw7UzPC3uWP/23ArGao8ae1mBWmeF2Hh7YmCYGBVQ0WgXoLwDl/MSwD7F9pJ3yZi2FDX6pMzWHwiSb40FJO1Bz9BHZWohgZCvsXXfuBN7OYYj88YmbD9ZLXFd/Ivi98ThqTZT/hii6YZUn95Xmb5mxcGn/c9a/scx8fpkb/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS4PPF708A6BB3E.namprd11.prod.outlook.com (2603:10b6:f:fc02::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 03:24:19 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 03:24:17 +0000
Date: Wed, 19 Nov 2025 11:24:07 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 12/22] KVM: VMX: Virtualize FRED event_data
Message-ID: <aR04V4VVg+p4RsdT@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-13-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-13-xin@zytor.com>
X-ClientProxiedBy: TPYP295CA0055.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS4PPF708A6BB3E:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a59cfd9-d57f-48bf-e56b-08de271b1ef7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6IsDkC36V2MFdUuwyysNQcodDsCzVVn0/SmJU4D33kxTeGgSDObghbY7VZ3Z?=
 =?us-ascii?Q?YLAeh+v7Mdv3B3dSZVjJqhB4+SC3oGKg6dYa21S6nymJC4Lr7xO3DygrT87R?=
 =?us-ascii?Q?Dman6R7eHJ4/t/qGLeXTP3++n8qkNEakwe1pWpockMZrrRBAVpz8Rm4u4/HS?=
 =?us-ascii?Q?UA300axdjJLcQT0EspTqbtRHJQF6vZdyHP15jKu9GzldpVlGyfJfUsNtzydF?=
 =?us-ascii?Q?lMyPKPWqUZYYf5SbA1idv+yTEK6TxkPv/H3o7LfVUR+zR6KZ2U1evRs7TZdR?=
 =?us-ascii?Q?ir8LTGt5CLGUcoyJxYupbsMt2Ld9py6SoI1QPz9JqCkjb2Zl/uKB+cdu2SHC?=
 =?us-ascii?Q?4S2jg3IhelePKvurqeMb8Qn1MNGxkzJojRlGD8GXrZhiNA+bntBQ5kJ8zSP1?=
 =?us-ascii?Q?r/LilDhZpczDyz3o0OBFPSJcnZTA5bP2DUrqEFglcBDpBso5TnKxvvdlcLzw?=
 =?us-ascii?Q?lu+iMS4GAICuTI53IBjOpiS8MO+bbNf4akBr3cd+t+tb+2kU2QCBLd75LYvM?=
 =?us-ascii?Q?bj5YQre8sM8wyM47s1qkANMw+AvlontMZipi/o9hwlVX/qWXHluU0vNjGmph?=
 =?us-ascii?Q?3OZS4tNcMCu+X4bAT47tpx9gUzmg6h5IEjf9ahtZgG2bTGF3k7m+n9ihb7HO?=
 =?us-ascii?Q?T2v0YZkaTwzkiLm4WZ5qfi5O1dKWBIDSwQnI1o3nxHOHRSolmlJ5FXqsOHd2?=
 =?us-ascii?Q?/R82aj6ots8U0rfdo0EkgopADxAxi1fFnDbPupNsI0/YLiKJT+Ts4v3lm4zj?=
 =?us-ascii?Q?jy+bRYZ37ugZaGB+si6qbigZzlxDLrkScdG/Q4hG77ExCbavFJfoure3lpkU?=
 =?us-ascii?Q?ytBjlQWiqvctQxlysBD9tYiUXeUA3XF41DFXz3u0XRtrz9BWVNIjrnkNBlWI?=
 =?us-ascii?Q?aCqadcSZ2TJCAsAweKmeJ4Znn//G56Gf9zYsg20vn6HcJxpsZDuvu9Td+zto?=
 =?us-ascii?Q?1TQjwUi/riWrsdYaLQLtwu41Tk5JHFhcZHWbANtcpVNksmjymIZF6vgnoz8+?=
 =?us-ascii?Q?ZCFmaaUlPahKaX7FCPuAKqviKZ0SrXkKSRYXGp/eXxepylV0qWbJhDC2VYLr?=
 =?us-ascii?Q?y8CB+7bi+SKDr8qEKjWN9zlzBLD4rUFVnMGr922K49N1M9o+yr1Igd4Uzaeu?=
 =?us-ascii?Q?4379TDFtN0HmOkTKbrISLSLqT7gyhKiXrw9bFCap2PqIS2OnlmCWLh4w6dyM?=
 =?us-ascii?Q?8E8BMDue8h+dGkAy88wWrUQq/hpAINlKlMj8bSA1d8/s3+gIhnXSOhl6ZCHX?=
 =?us-ascii?Q?6AZG80xA6wJvZUS90d6OhWeCY0dxzOKHcXknvn8fEMv6TefmsgNIQac2VEKU?=
 =?us-ascii?Q?LP06KA7gqcvGc2QI3Raxflnpa9awCEu568uLFuPFmWV6mfv/L74ccsopDaeJ?=
 =?us-ascii?Q?JHndxLvJUWC4GXKtq6I6rOdUnzhQORXKsuqgnjSHiUUUk2faWH2SGi/oUUv/?=
 =?us-ascii?Q?OwkfGXZ+j5f1XHCA84qeg9e2K/TK/tG4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OiFB+cPpztkcJANYSnJy6K7jocAoJ44mXNkS7tTieCuF+xHt1sIbsOJSl14?=
 =?us-ascii?Q?02gqeIp0izXuTxHC6MR/b/KUUQIg965/zQfenteDcFvZkb/x9815Bmsxk6jn?=
 =?us-ascii?Q?nMlfYcObBlt1lMeMzRzOMGND4k4hyxcjQ/Am17N8k+pmdtvfalVMcyi7n8R9?=
 =?us-ascii?Q?aslY7LuqKJeypWlewVsyrTzeXjn0iwT2GzdmiKe5fo/FHsKEzMmUoSLflNCo?=
 =?us-ascii?Q?EPLVLByAS6zn/IcgLlxly+mn7WQ7dKuAvrg6n+tk69qmICEeSB3stJ/fCNxA?=
 =?us-ascii?Q?QxxGi6uTqg+FQ/s2cVqCqc8+y1VpkDXuPjMz/cEG4XWxCcNnG1wX5FZ7+iwt?=
 =?us-ascii?Q?CD3uw9c7w4AFBmxXTGjM0kyYPCccZNsKGMaw8k16XdJoNIhng51OL8F2UI8Z?=
 =?us-ascii?Q?f+vLmXvxfeqWxFs39wZrDXTZ3gbYt0eRVTCfH8ZaqtkHm/GbcTmYsJe9YhFx?=
 =?us-ascii?Q?p9RQQOja1vwuXsf7MV/uocJAk81o3NVVeW7EbmPFv5k/eOxva92dRl3ZNgWY?=
 =?us-ascii?Q?kxpZs2q0/4Ka+Wi1fDr8wqoOFLn6ytOMreDcCdBRjCMewqpA+62scXnqiJOJ?=
 =?us-ascii?Q?n/up/8FZ8qCMeJMzjk9pp1+G91A/Tq2URoLzeIqfmecRUZLVemwhhT2U+y3W?=
 =?us-ascii?Q?g+KydTmKpSYi8M3plYnxIm+zDZYWSU6PMVNSAmcn0EqKP2UlTyCrAUsfRG9w?=
 =?us-ascii?Q?gXuD1wDopSPjwakWGqWh01d4BQSFJpbWugIeNMuLnXM5iIC6H/uK5KbcfZ8Y?=
 =?us-ascii?Q?eA3HJe96h5j/4C8ShzGvMB4fxPLArlk7JfoGeMy8LKYEy95TeVpnnSIUZfdE?=
 =?us-ascii?Q?8u87YXyGuH771O56JlWGR98dQ7guQBgoVWuMoJQcn1x3ccP2gH0GwzUsMwIF?=
 =?us-ascii?Q?NZEPnOrlpsWP7FouEMSxRgErHvyj8Wzp+Is/Il27R46/AdpaRuzHDQ61PogJ?=
 =?us-ascii?Q?fbGiyCVhDSwooxgqbUhfkCpKYa5Oglum+hw9WWkzjWCE1g6E2vrerQ4ptbbV?=
 =?us-ascii?Q?F4HO5g0a3spMr358d+2tK6AW9mgvL9Gbb0xYUGqPXh0w1cVXBM/4Tp86TIRs?=
 =?us-ascii?Q?7VtS3b6mK6FLu9qpIDtLwNnlmGgKYWsOSIovMEen/c9o5rCoWCNKEWW6gcuu?=
 =?us-ascii?Q?l/lloM3UwTAyC9NyZhME1TFdEGV/2GLfEZMbj3sBtv10NvqIFCja8hYBZo/L?=
 =?us-ascii?Q?6Df61sl6KuM/r+yJHQK8QJNGaECWVsIY8ZnHHtMFAwav1Sm/Ce2OFtNbRbtJ?=
 =?us-ascii?Q?2bMhFmlCeAyJisI7ffU6mJf7srKRfcvUpbBUP1r9pdpDf4ZqmIrbZ4OaXB+C?=
 =?us-ascii?Q?YVaA771jG8HYtM9Aaxd/d8XVGcS79r2q/RBb5qgrQ8t0WslESgLMWYfGPKIZ?=
 =?us-ascii?Q?AnOIJ+OctmgQPaG6dyWS9sf1/gz9Fj0UFXA7/wK0w4i/FMJdlbgOOw26/T0N?=
 =?us-ascii?Q?OhMvVoPX7XCEvMITbiAOJmsgnZQ0nZM8UkX58UdczYrsci7esKI+zxZJrVDA?=
 =?us-ascii?Q?pBLe/wU179jriKQlJBeLtoa53qc+ugp+HMJszr5GDvLfUyHFocnA7RYLwiGo?=
 =?us-ascii?Q?lAeNbMNi9cCqmKz4ty5xI799lknquYTu1lxVZmqI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a59cfd9-d57f-48bf-e56b-08de271b1ef7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 03:24:17.5600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czUDVfiR3GFO0okiUuF4ruN7JJxIoENcCH+Am3DaDlmdKTAbpOI385gEatjuElEB3OZCL6xjFSmYk9KxIfctPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF708A6BB3E
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 4a74c9f64f90..0b5d04c863a8 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -1860,6 +1860,9 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
> 
> 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
> 
>+	if (is_fred_enabled(vcpu))
>+		vmcs_write64(INJECTED_EVENT_DATA, ex->event_data);

I think event_data should be reset to 0 in kvm_clear_exception_queue().
Otherwise, ex->event_data may be stale here, i.e., the event_data from the
previous event may be injected along with the next event.

<snip>

>+
> 	vmx_clear_hlt(vcpu);
> }
> 

> 	/*
>@@ -950,6 +963,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
> 	vcpu->arch.exception.error_code = error_code;
> 	vcpu->arch.exception.has_payload = false;
> 	vcpu->arch.exception.payload = 0;
>+	vcpu->arch.exception.event_data = event_data;

If userspace saves guest events (via kvm_vcpu_ioctl_x86_get_vcpu_events())
right after an event is requeued, event_data will be lost (as that uAPI only
saves the payload and KVM doesn't convert the event_data back to a payload
there). So this event will be delivered with incorrect event_data if the
event is restored on another system after migration.

> }
> EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_requeue_exception);
> 
>-- 
>2.51.0
>

