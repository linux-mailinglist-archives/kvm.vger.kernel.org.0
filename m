Return-Path: <kvm+bounces-62869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E55A3C51653
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 10:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 330134FAB35
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6922FF641;
	Wed, 12 Nov 2025 09:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iolfgy6b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BB2FF148;
	Wed, 12 Nov 2025 09:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939889; cv=fail; b=gcc3AlsornB0pzrbOVzA+dFxWmFBomr7FS/EW5+hXC4EhJxkvwdiy9MFHGc6rZ21ed0J1Bw6jkSraa6tThHZXyKNWEe6kSIfqIjHZ0Jf6vD8xN1nv0DdpLfu9CVgv7At2Lq7/FYV/IIzYvVUu7tZcDaxHEhKKcVg6nRR8mYfMmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939889; c=relaxed/simple;
	bh=viZ1tI5iuoV7zWumv8QzstxePMQYdYcwvLvG9BTW3+Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e9YKJ8Z1dh9JFo0fmuwUBN7VvjrlgcU18NiAPTxqIz/UNu+Xg46sBG4ZFguoBPF7+FdA5XD71hzLXW9GW9DppFiQAn0lEvbHIbADD+U7Ukmit23e5D4+KR2EJvA6zY4CpyPHxwLgUNKF11aGn8C3ZzhCVgVtTvXPoDT3IiOLH/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iolfgy6b; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762939887; x=1794475887;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=viZ1tI5iuoV7zWumv8QzstxePMQYdYcwvLvG9BTW3+Y=;
  b=Iolfgy6bCCIEKpTBw0bNVj6UpZnu14OJELbA+zoZtm4cyfxjDv2vk6v6
   SCUWfVy3I/q0GEvpCSxJ4yg1AF47dvF7TzDToq1xRTzBn5m1WqDIMV4no
   w+SBVtPiLmqppvmtLmS/di2i2K1XCUwELSgrB9qmvW7UbnWnhCh5VBBqi
   CPjcRowEoXwwOH1FCazrhFJPg5QasRc0YhrKZwNCJ1jFTpnpaJoaczrmc
   b1poIQRv029Q4fZ87mumOVij50PRngG48Eq+Fh8FafZVNSmt2n/eijqoE
   ZW3WmifK9foRozFFcIcX4M48LbJyfP7cCfGSpJnuiVZne+9Sa3wKl9EvA
   w==;
X-CSE-ConnectionGUID: qcn1b0SmRKGjxtd4CNbAMQ==
X-CSE-MsgGUID: c1Tg0FzwTXWiS/rVnHtFRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="64006543"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="64006543"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 01:31:26 -0800
X-CSE-ConnectionGUID: KKynK1EEQxOs4E+bYpTBNg==
X-CSE-MsgGUID: jZNeLgKhTri+WuEm1UOZ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189899475"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 01:31:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 01:31:25 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 01:31:25 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 01:31:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAwEIzFyLl5+Ebek/+X6ytFxcZSYVw7DUBobFKdGa+twcddw+YTRSCDMNIXkgOqtmNnHiON9ql0sWA7vCRHZ07rSOX60GSti51fN45tkpdjHpOJ+Je92V3Xx5myNhChwVzZMvJbyZbq6HB/kUk16pCNO01p637esMKMdD2vjQygmAgM4BG5oj+RGn32dsp7cHyy3c5TxwUJ2FWtknHYoHyrklBnvRn9w90IjWSW2T2ZuP6kKUFJeE++AufnzfiGccgb63ShWRl5hJ3yU8gcZyOm7H1nwW3JRGtIz1+pRui9yOuf+NSn4LU12w5uyKUUNKGAjzsSGg6qeq9u/w9Z/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jozvTrkAC+GxvCjrO6ebDRKaIPENJ0+/Qdt6vZYHDMo=;
 b=hR+9PaTuMtFoDIM2/0UfyVmK1CJ/h5QIbK4vyYihre/X/zjhX/i7oksI3UI8xk6+M4siH//DJON4Sv6Aqe5/K8ROnlVBn2i0jQYsx6xOtpvyd98zdIJ1jK+jcXdgMoKCzqDD4q9zIZCpT8HCFG/my+6PJVC5KqKoKW3/Zxm1mpUCSEOtCdyUr/MTECk0HfFpJs9ykYGxgmWsP6PLYoWLqSXXIi5hub/M+kLS4pcPt0nd8W27DWuAEOrTj4lx/EWtDd0reZytKN/Tgc8TdZ/xNNO9E3P4EA7YgvN1KTjCNcGMGXNxioASjuVCyybcf1cPAoI916b3Jcj8i5VYPy2lRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7790.namprd11.prod.outlook.com (2603:10b6:208:403::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 09:31:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Wed, 12 Nov 2025
 09:31:22 +0000
Date: Wed, 12 Nov 2025 17:29:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 08/23] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
Message-ID: <aRRTaX6FD6I/tw3w@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094308.4551-1-yan.y.zhao@intel.com>
 <5559b6a10b9345b350a595a8d5c52c19062cd8dd.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5559b6a10b9345b350a595a8d5c52c19062cd8dd.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0150.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7790:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d605d24-0527-4926-c7ac-08de21ce3dff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wOuY0RGwz41ZfNguDUBRjMZUPFKiSUSpLDV/KMVvt4XSmI6YEmpiBhnnjRxl?=
 =?us-ascii?Q?WVTciEJU0wDkTaUQNJufhNQ4q/2fX/SqUxVjBUdtvECkzEn4kHJnFssywOOs?=
 =?us-ascii?Q?84tmrtZRNDCekHyvCdUmztms4hN4ll9yI7Y9z6nHNqvMCfFvocordimqs4Vu?=
 =?us-ascii?Q?BUsL7Qvxe74/UJfPZtRwMpcN0d07D0oLvPLkyQ5k+fIgB07qz6pP5V/Vsv9q?=
 =?us-ascii?Q?gjKbCTEqz/6U1dTz3JkWMp6NLWQK9XzBRcaYoWxfuq5S5OSNqibClvgNHH8N?=
 =?us-ascii?Q?O2xIg5IlqvnCAWmdLluBfkmlEuDmESbeU1xIwE/rU7ADds+EwuGQXAsxVy4K?=
 =?us-ascii?Q?c1y371jv91LwV2IXJac/auIeb995Wi2Uip6FCGNg8IHXjUBmMv2aaZSRUNzF?=
 =?us-ascii?Q?5/me9RZxz77pWpp9zMPWG16IYS1i5npSUICnMb2hZcgazTOpflfnXwH9SLla?=
 =?us-ascii?Q?svIA8z41pa8vzEfGt18w/zjJkXOrSkIXOoOB8yv3xLxjP+rASJbUKpxMa//M?=
 =?us-ascii?Q?We/UzYFGmkcZDhn20+9WC37okj3zFo/n48BP2fJrh61Mu3hVmibSxSkCBu/1?=
 =?us-ascii?Q?ehwRvFulKUDmQ9SaeBf5sUm144hW7AisNHwyjBMUMzPRZ46djm0z5uoHZpQt?=
 =?us-ascii?Q?QKjY44N+/lXDgmmrZz6GqfqDEJ3tIvxpdl7ANpt6pquQqzEtYzh5slrFL2za?=
 =?us-ascii?Q?U8htlS/1EuAKeNtA22E/hjHSYxbECBCpEesyG/xlAzA2jvYYmpxZdD8W5bmB?=
 =?us-ascii?Q?YvO20ulbZjMfiLzwMot/JgR6Sxzn1vJcWySqHZ1j359L0+FGJF5rHgBMm9Pz?=
 =?us-ascii?Q?8SyvkZayX9M5nQGOgqUs5BoN1dtpS5bY4uUCLZh7nuAT67ow4K/n6byInN+a?=
 =?us-ascii?Q?7BBQVgtgQfs98WU3oOz3izo0eSjOamm4QvWBpssW55lcF504+yaTlcEpiv/B?=
 =?us-ascii?Q?yfztuuQ1je2FyJVF294BHBEde1nLhbM9DfCecu5orWbNroDQWrK63o77b825?=
 =?us-ascii?Q?aY0VGMKL9vys/tBnbv0vsCHwm9GTc1ug9+AtaNLs+3oiQbPy//Q6SxCyXIUk?=
 =?us-ascii?Q?sI2OvT4vzf61FMnaEq/sEGOPYXLMP/w+duvLyPyvROkYZcwyOuQBrlPuN1uR?=
 =?us-ascii?Q?KwiNNEraK0WEbZJ+omUWYVZGYS6bT7QIKDU3a43tsU39V+2SvjOZmnWpUCnW?=
 =?us-ascii?Q?uAVdibIH9q7wib85+ZWxUU3OIR00QxgjNSzdmdt3K6pzs93sQ1SGdhLhG+hm?=
 =?us-ascii?Q?hGKQ81RmwlUIkZBenH+nE6hRKCwzlWfbBV2aEDFsbgAVbKiz+O8Owj2DrM7V?=
 =?us-ascii?Q?JFrLaE6letRXQPeM+uoZrnnRtRPRlzFaALPoqO8jrq30SRCTBdKQieWy0If9?=
 =?us-ascii?Q?SRimKYOdda+LTWYvgIpeR60uFxNRoLk9iYaUh5+ZLtrY1p3FTXACXt3hRMPP?=
 =?us-ascii?Q?c4V6mdDqArkpgWkMZkHzniB4ienw0NmA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2x1Nfq3WgTiBZL0Yl6SSqgGaQv3F8YNhDXqJ812llUouG01tYwwI/Colw21C?=
 =?us-ascii?Q?dt0ORU0lU5JsR6uBi6jK730P6tcnLWT7EBfeSQEL8qEI7MCPgqZSkP+WnO1G?=
 =?us-ascii?Q?lEivWQOuh9Gfd+oUrj57kF87uH2kQ6x9Cdw64oa126TbG2ojOeEAEs1BWret?=
 =?us-ascii?Q?iUCljEkKtw2P+eb7O4ubMhPakjIHsyjqh3qbSj9lTu4iCkhSg5hc/ixThKHX?=
 =?us-ascii?Q?n85PvBG5ZNCBV1f1jKHcd6P//ESTcw8VRJ1TgRFEETgxx6poXgLyMwlV0+ri?=
 =?us-ascii?Q?7LqjlhZK8pwa6DkcpN4stE3+9ty8KA/en/EkE3EXdct+u0dDCMscxGawh405?=
 =?us-ascii?Q?lfhl3RoDv+BQ3WpUD1R2jXDrn/JSraRdOxUMjxtk0R1O9kEHtnB+/XVHQWmC?=
 =?us-ascii?Q?LX6abf4CFtVCQjsj+feFz35WIXMy3+8I9TAMQp3WKc0Z7yANPKGTXcIDwSM/?=
 =?us-ascii?Q?4rfbshGFsWxBJjbusqa9WObKJGIhf29I7qS4rr1+ANlskMv8NS0iS5V4+xCQ?=
 =?us-ascii?Q?v9JSU9LGSOLy3m68H69h2E0H/hLDx/vSm6emPXZ182gbH0k9rPpfdJV29/+R?=
 =?us-ascii?Q?b7/rC1yarjcvkI7VKiHabHu12HsLCk+NZFM+KHRYzN/oKbtksQpblo7VAlzu?=
 =?us-ascii?Q?pVSz1Bdk4MkfOX7+6kTqfjWfAJ7/tyMxkMjLgDS2g7bumX/YWtLAtt3xQCKh?=
 =?us-ascii?Q?7rcAdPold5uhuIUSQNKE0Yh03VVYry0l7y4EkbZwbQ0Qp7sQkeX3jJ2N1c1y?=
 =?us-ascii?Q?jEgg2kbbyaf3QzK7xdsj6fz1lztbZVO5fi8HwcCZwxDiYqntwp/q6rI5lyNJ?=
 =?us-ascii?Q?+ckqtEu1oN+cZaMt2ucouwlg70daGpgZqqgqupdvDFBpCJsgo3wRXMQinjni?=
 =?us-ascii?Q?lVGPe5s/nngu1T7bBySyjbZ79b1ve60kYIB9lW90BzwbobRLhGXKSIqb9gcs?=
 =?us-ascii?Q?bD8+mJu4RZjLI43Rk9/cTr5GhKY02CmpSoyAdGBEBsK9Oq+05pB3cdkROYjK?=
 =?us-ascii?Q?Ibya3OY9yZXDgucIxbziLjFdkTDl3wfiSMOgUsRBWDKZjwccocaQ9mgG6KNI?=
 =?us-ascii?Q?6CJ7IqDy8gWvJqjpC/1L5gLydVC8Hzb8uoc8h0RVccKqDJDEb2zl5aQ9DNIt?=
 =?us-ascii?Q?Z6T4eo6eoySp61MNRLtn5m57YYxgH34S5htQd6/KcCvBhGJQ2ZP2NqTR4lQ4?=
 =?us-ascii?Q?MsL27LnHeml3jO/67D7M/VJYpXvO5nbe0QZuod5EiNQ135Br2DgIc5cV1wpm?=
 =?us-ascii?Q?AAxknaDOTrWgr2Cc7QP3kT7A5UFwifgOkidE33JIgkq3M8Sfq1vfks/HXnLr?=
 =?us-ascii?Q?0Pdo8CyLmuPKKLJHaqdEhNJWzIl/OW0K4V/bUlRMTMbwYiydmaENsrBmzYQg?=
 =?us-ascii?Q?2OteWplL/zM+J5vBwp2FZhCiq76zRJ8MjoO5U4qvFM+inqjZ7t60jt4gBQ+q?=
 =?us-ascii?Q?syJgLwXi4z3gALLnysA+Pnw5LICD4LLbrSpxfhZ9NUJzMiV2ysR9sTMoeTn9?=
 =?us-ascii?Q?pAJXO8EPoXVKVO4Zi17dvg6nRNBqvsM5H172lorS9FN3NBYrPF1kBo9HEOKD?=
 =?us-ascii?Q?KuHZ4ttv97/8oJFMOtJmfLehSXROMROzHCwlCo25?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d605d24-0527-4926-c7ac-08de21ce3dff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 09:31:22.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSyMsvjHvtg/WCPPrhcv59TAxkiSpivMwxT1ey9MevPJvvSRjV7/pKm9Hv6xeRZz6hRSF0aBdpGfAen1C1ERIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7790
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 05:52:54PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Enhance tdp_mmu_alloc_sp_split() to allocate a page for sp->external_spt,
> 	  ^
> 	  tdp_mmu_alloc_sp_for_split()
Right. 

> [...]
> 
> > +static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
> > +
> 
> It doesn't seem you need such declaration in _this_ patch.  If any later
> patch needs it, then perhaps it's better to do in that patch.
Thanks!
I'll drop this declaration. It's no longer needed for v2, because its caller is
now tdp_mmu_split_huge_pages_root(), which is later than
tdp_mmu_alloc_sp_for_split().


