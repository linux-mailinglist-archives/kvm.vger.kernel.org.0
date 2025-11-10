Return-Path: <kvm+bounces-62490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A9355C452A1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 08:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 975A64E85DF
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 07:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE9B2E9EC7;
	Mon, 10 Nov 2025 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScrfMPrK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67166288C27;
	Mon, 10 Nov 2025 07:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762758347; cv=fail; b=PgY3Tua8NxJcEvEBoc+Cd3Fz2ELwm93keHBs6lNG0vGyVuQf+oqgrVF0nvKci1DbVQhzHHTTBzlZ8K523L5EdHDUKoe8xR5cGCcXjP2Qq4OQb94cp48nvqWge53WeXR2qp/tV5EqmGlJCyreUYqoGVGXZa6nWVZYIthRFxHEqGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762758347; c=relaxed/simple;
	bh=wF6r8L7WxOEc35Oxne7u4XkNMEmq8HCJj4kix77E4B8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K4sImUhpe7PJ9rFyutPFtFhXjg6wfaTBbuMizuuXlf3y4cf8nBsojFC4M5h4vmukRs9UJjfnrhKAcGSvnScER3few7tSeAZHVtP0Axw/npbQCMnfIWL6NSweEt6vTRZXsrSFCugnpuSOKi/Zmpw3C3yyeC9V+NcSrfg/1QZDCMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScrfMPrK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762758345; x=1794294345;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wF6r8L7WxOEc35Oxne7u4XkNMEmq8HCJj4kix77E4B8=;
  b=ScrfMPrKdWxjNrN4OyoM5FdzOAjGQ+YlVcB6gikX4OGvxpM3ygY3TPNJ
   CmzMd4i5z93AOADwp9g9/WZvBBWQ+/RhddktSphBEoiGgNIL/shNF44hM
   UrgIQogJlheeR/TaxwVLdE3XWnewODdYZPq5+FOiOW+Wdz/p72+mH3Qih
   qxEszYHiPTHvm+5/9Z2yINqQ0TQznYT5RfDpKC7dnV3s3MK/bvvT/4X3E
   2I62g6AQY+heM216XvhjSVAiDbAg2QLs/eeQY638JpXExUnyvbg6J3Qos
   lbrr7YnD3Fr93NL5aVVpHwoAnTlcFD0wLwkdDf/BgTTcvfMa3+HViV/vJ
   Q==;
X-CSE-ConnectionGUID: zz7pvYerTquQuWTvN+Sdaw==
X-CSE-MsgGUID: zUiLjMMYRnSE+fXod9PP1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="64505078"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="64505078"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 23:05:45 -0800
X-CSE-ConnectionGUID: smqBa4nBRUSrIMGcGTBqFw==
X-CSE-MsgGUID: j7W5WdOCS4OetlOUIz343A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="189038164"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 23:05:44 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 23:05:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 9 Nov 2025 23:05:44 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 23:05:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPWhcjPwOfTBMyHkhnVX5QY6ATZ+ctxEKizOCkhoLdWQlob0t8xLyf4ZXqtX+grHEiNAOLTPRPgbTtOLCUNLrdUSOYrEFdlDGK948N+hZEvw5VI2Br6TG0yZ/jrENA+9EkM/XDT2Ts+TpONUnYCFsAbXwbxO5o+4hUGHYacqs/Rmp2zA1SpHlB2gjB3/Fwu7juVztDk1FGuN8EyKJnLNnW81EFCJCoPexVTg92nTyorIVKCfgxbWBUCR2UyhxbSkMaupHAtSu8mkNGzCJ/VaMOI8dCeiWPGcQvXxPmupN+raY57vW2KFIpc+gQV9QDsktFGtylNeqvPw98PURoSmOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1KWK8clM7RvHbuj2u31QtLtBcodtyNBu0pY8xPN3+M=;
 b=wMVGmc1HgiSv4wjESWqYyorB/lnsw2XCo8prhbnjW2oHoGB9KW2uJU3NSGPw3MwTYYv1rcGjNTICuvVfOB1Nrz3fWmGYx0no23tKuudMjlIeAG1qGwozNn798m6F+xveXXQSpSHXr+t8Iww+z/TITjG6qqqrOk9cjARyTX6hUpBo+vDC9y/GgJDCmnwQ0NUqUlt+JGFPwcd/t/igTzRIITTIuUJ58md+92dMH/zgpCzU7jLechvoZ+03fzhiXR5hl6lUSvOlCLOI2bwOi6CYrfWcEKFQGJiYh55oyMgBgzbbNbOTjNkQs0pFr+V38lvJtNj1lmTWgOrkggDbv1RdFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPF77D28E3C2.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::837) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 07:05:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 07:05:41 +0000
Date: Mon, 10 Nov 2025 15:05:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
 (un)loading time
Message-ID: <aRGOu3eJoRnsaV+n@intel.com>
References: <20251108013601.902918-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251108013601.902918-1-seanjc@google.com>
X-ClientProxiedBy: KL1PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:820:d::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPF77D28E3C2:EE_
X-MS-Office365-Filtering-Correlation-Id: d1be4cdb-5fab-4e58-a294-08de20278f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pCrPg8+9K22Z7W/ajkn7KGtB3qjnlPck+lebrfWFYn/z1MG46ERueGqhqP0j?=
 =?us-ascii?Q?jvYNU9mCTAl7dA9isC+hUL1fNo6HGUu3ES4+8jaktAb2+PAtIHvrzHAgVCIW?=
 =?us-ascii?Q?NTR4t33VZlIsySNDHjUUaeOh013iOBMI3I7jfa1u9CXSbqRMLs8/1gw7C7tu?=
 =?us-ascii?Q?hjktiHeOyGKJIdu1paCMxm6sIfsojszRqXPs3D/9MTeaTT1ZvBnHMWWpSYmO?=
 =?us-ascii?Q?5nHABSiarEgkAUCS+ENbuDApFT0lmCkhbJn+tTzWvC73Q4XOTJddHc07/WPu?=
 =?us-ascii?Q?4oq6dtbE9DmqDdE2A2+5sBZvLK84aBdzAnEwhD8m0FA07injuhGwg/vp89Mp?=
 =?us-ascii?Q?8zkhH5zMtxCcCd4cnxyZXjNLjVsQ5x1hju8oyWqZZfq09/EsC8qawjhpwB2S?=
 =?us-ascii?Q?vMOYGE+uwFUotSgqP/ttwUH27lxQbgqK0enPrwjH0DKmZ0Dv32V6gAU1AQpx?=
 =?us-ascii?Q?YzqsxmQ6P0OzBeW3k1YZCu4wzFDx4SBk0tJmvcXIdMTKnZb2tfYuZL4/+Yyi?=
 =?us-ascii?Q?sohB7/YHF9JI2b6IiHZqCgQ41NExG+/JESTOqDE/IvBG4GhIjUYXv3xDvQqO?=
 =?us-ascii?Q?x28ceM5f6f8+IpmnVS/IRtyKJKYFKyPnSC7V7tZyXg/ytyZrpQNfCwhndb4r?=
 =?us-ascii?Q?w5ipf5kxJCMAvZnZd9cFA9zxU2JkJ3KmbGbf6DAYU6M0j+6UwvmoRDYD3n/J?=
 =?us-ascii?Q?nYCsy7CUIz0RI9QU5OmrUFVI1feggguHuiW3SgcLMPjzdN4hBD8NezVxCPpC?=
 =?us-ascii?Q?DgqWt5jrXYoQy1P2Qo9HKlxtLLygw1ysawbBkQmhJgS61zHZl8W7PGK8TI7W?=
 =?us-ascii?Q?D+S5EJWNTu5SA6v4LC9y3QIFKWvAjDpy5wD80htTVCWcqBoY+NNLxLwk8B1S?=
 =?us-ascii?Q?LkgUUImte+iPaufLX2u8nTOSy+G64f//r8YuA5XKIS8LVg+1hwAWfRK5YQ8V?=
 =?us-ascii?Q?nYyBO/NcZhlc3Ty85a/oHyxpzfQKO6kLJlRdUZalihw2npjtCjyXkF9ixh3i?=
 =?us-ascii?Q?HZ61XwDfTQmdr0YRMvx84y3YuAT5vkj2RurFzDL9t8b6f1HzdUWr1TsnST1K?=
 =?us-ascii?Q?EPRsEvmVeCEKEu9RYlfbAsja89elFqTolyq9RAm1eAi0cgXQj5pshvb1EAWM?=
 =?us-ascii?Q?g6ghon5ZKeVlFBF+1PIQdQzm5rfRMofsPcYQ+C6PJHQvdPKFL/4WNIJW4I7p?=
 =?us-ascii?Q?qKJoBTIDnXvSewNyqem6fTuMIuKgdlQwhNbBDuyFP4XVA+pi8AhIiIEncig+?=
 =?us-ascii?Q?gR4T9PPvPcFaZW0nAsZ6lxRLGkgpQQjhpCY0fdr42h+AVHU0RAfD2JZOXqFI?=
 =?us-ascii?Q?uXwAKNuJx2K2TPUkTskijsCzy6pDUQjXDMwjh0uESfo/1EwCzJQFLkVnN2Ic?=
 =?us-ascii?Q?vyQqOl7XF2gkg5hqYsDxdt03vJtHkz/Qr7KfFSipUxO5OW73ekirOJulKIML?=
 =?us-ascii?Q?MVq6MqvOgSEs5UNf5qXvpBpsWBUiaR6XZfsHApGpX73VxGTcKl0o/Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZ+NltdFOfj5ukED0aqMXtJ6MRjmJL4GTomltyw2N0GeISwLpasQpM5aeJQa?=
 =?us-ascii?Q?114p6Bj0OcMQN1Jw4S0jkgbVxa51dwVRwOmp4eufSDwWfh4P9COZX1iVYWn8?=
 =?us-ascii?Q?OhDzeEWgLTgQFudZaqAMK+ikUjOrShhxGs6N5H/ggF4K9cSiBsD40BFr7g4p?=
 =?us-ascii?Q?suNP8rUz5Isl09EIR5q0+ZkNjXshvWxm6sj2Fdz5LPuzE2n/WRvQI3rJxF+k?=
 =?us-ascii?Q?VGSd9UMwUpZ4sY3BIbUPsChRaad8igWMRLngG5gdkSB8VWCFNcEcBsfCSqwQ?=
 =?us-ascii?Q?YHS6p9mLlRk7IomMme1R2uD6RY4ORXdGFVZ7lMHqGvQfbIeNU1/m0bFyK0KI?=
 =?us-ascii?Q?+Bs3GHIzO960MOK0EfVjZ7JwTzgA2RIuM6fYsWdKQpnR+qn00FFTVdMTq5/J?=
 =?us-ascii?Q?DFYXMjt41TDh321IoB1XBo1aUqUQBZk/0E8Mrk1fUW2Neh29IL2wxBQcJGnE?=
 =?us-ascii?Q?U0eG+F1xV1mV4Gj18l+0aqJUMAoFNKZd7fXHi0b0DdAtdUkX/Fc4fY8Kiu3T?=
 =?us-ascii?Q?XwLL+C1vJbGb3lpolbOLW9kvhavZi51UmSJY/vH+xDmACN4GK1vRz09syp8+?=
 =?us-ascii?Q?8JxjjII7ETl9zIcLBDekUYNA3NaLmqgixvo2Eba9LVnRfqe+EW77UI89VUEy?=
 =?us-ascii?Q?AintO6RldXgTpEzZbAmHU1AGJI3rToSCWgLyf4ZxrDD3iOok0zv91yUuEuhZ?=
 =?us-ascii?Q?myVQGyODI9svP3B16pB/7ftnnZP0gSk23BH2Z8KdcyCPqKF9EZQrbLVZxZv5?=
 =?us-ascii?Q?JmbZWmuMTxv8ttzsdHuMVSHrEDGmrzmCk2+LHJ7xboRgVs8oCOxnkKy8CcSu?=
 =?us-ascii?Q?EVJmfy6TFXNOuntwlBncP12X7uWBTkZjmsJVVFkOsbMk/B3UEL5/GxLYAKSz?=
 =?us-ascii?Q?j/6CzbVfz52mDu3Qd5eXZ7TIeQPxqzD7QvyEjZXGXvK4V6Md83XnDXEVKtnd?=
 =?us-ascii?Q?Chcja7PCKpQTz+fWVpgnzyZhFuGt49GoElDMiXqmOnL1cL9TBRY9k9IwnqC1?=
 =?us-ascii?Q?dUbY4/ysp5wshv0ldSe1y2AxKGHSYM6BvNQqQZjL8nCEyRp9eujPP7hCJJEi?=
 =?us-ascii?Q?+VjOsjmjrkZrddCijK3yRd82bRlhUrOlTTlI1Lbab2tNWncUzcxQ1zIYV0yU?=
 =?us-ascii?Q?Le4EXQVZoOj1U3ph/mGdMaQwN+IFTm5sJju4BtpEm2SMnWWGks9WrL3Jdfci?=
 =?us-ascii?Q?CH7BP5zDJ+9xV5JZdXCR6ILGFw+IHmV6Nls1sm17PkK0YogTMgAtGxc/CJMi?=
 =?us-ascii?Q?UoxuUPtFtEp/ADZnit8zIM4uRQVaZPlM4B2OnQXVK8jGxfSmFRSdb3iKEVQV?=
 =?us-ascii?Q?bQYjwdXOvGwoRUJtUU058+mj66577UiB/ggNnNWk2cKQSBrXHV7XS1mb1Aaj?=
 =?us-ascii?Q?BeyR44EPJLfrT55deScDzs4myajbHAIECVzQTbGJJd3Kc9/cAue8ICAnLd5X?=
 =?us-ascii?Q?tpag4D6a2R6cIwG/efsZkvtlrZaSCl/4suCAe3mL12Esv7OUOPcEyO01IEpY?=
 =?us-ascii?Q?cR4O5zkc2zb4O9jCIjp5lhCoOFHXkwEL94Txubh+cmJeFM+eQ0AoDn8hPS0x?=
 =?us-ascii?Q?x2aa+QaZ3KZrB1AEAGoEtP5edHWWBwm8OP7JX3l8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1be4cdb-5fab-4e58-a294-08de20278f1c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 07:05:41.1307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9wGKn/wnWa2fScnceo6RJTCq09wIi0Hq28kYSiA29pG2LnUIWe9sccVOmwRHWMIcYFU9vlIiownhT/DwnI4+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF77D28E3C2
X-OriginatorOrg: intel.com

>-static int kvm_init_user_return_msrs(void)
>+static void kvm_destroy_user_return_msrs(void)
> {
>-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
>-	if (!user_return_msrs) {
>-		pr_err("failed to allocate percpu user_return_msrs\n");
>-		return -ENOMEM;
>-	}
>+	int cpu;
>+
>+	for_each_possible_cpu(cpu)
>+		WARN_ON_ONCE(per_cpu(user_return_msrs, cpu).registered);

Could this warning be triggered if the forced shutdown path didn't
unregister the user return callback (i.e., with the patch [*] applied),
and then vendor modules got unloaded immediately after the forced shutdown
(before the CPU exits to the userspace)?

[*]: https://lore.kernel.org/kvm/20251030191528.3380553-4-seanjc@google.com/

