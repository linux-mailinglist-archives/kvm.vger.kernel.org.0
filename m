Return-Path: <kvm+bounces-55728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F690B354C7
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 08:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7A016676C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E55B2F60CF;
	Tue, 26 Aug 2025 06:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lr8Oz0XK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50571F03EF;
	Tue, 26 Aug 2025 06:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756191131; cv=fail; b=GDcSPOQgOVnmSxkgVgMIGSV0IYUNm77gXwrnJruAkG0KK8upIX3L7Hcsi7JN2EsSVGRiXqC7H07vJFtdDOm88KP4ooxo2LbZW5AByzsBWVG1SQxGIgUCN6xlxpxVpsaEG/z868pa+ZKIz1YkBR2PHRL618d1OQeqRn28FI3rVPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756191131; c=relaxed/simple;
	bh=Ka6XRPN/lBwtQVPWn1ONAbWZBTR41bekQ3U793wJ8Ko=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uhLSd+KbCnzX6WmZtTxO37LDPCOTCLn+50AKoJDOthDRq/8I7Is2db39K9PNDsj4+8OQhLczewG33O6Ms3mYFr4nRToDsqRIWBhSvhrwko73MMAibXFD15ZKznOgP77YrOsUcIvEWRyu0uzAnZdpDHEmdDlwBhoh2kXWRqy83LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lr8Oz0XK; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756191126; x=1787727126;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Ka6XRPN/lBwtQVPWn1ONAbWZBTR41bekQ3U793wJ8Ko=;
  b=Lr8Oz0XKoe2KtpT0nscMJ6jw9zkou2FUhdDD11v0aNhTctOCHNNWz0Y0
   U6SEb5xknEcB0GN1Qhxgqn6EVyfZxklUuNSxZpS+gIN1xibsSwO5G3xbs
   +OJrddfA6K1nTQXdqcqRcd0x5nTpVD43eIJmChnTn4+dsBdAf19J5FXIv
   czkXMlGOX6q1KarI0TvW5n4FSj0NAGVX5m4RIdLQQMlbm6Yn1Fj9EcWKI
   QXxD0ZfGDxtXf/LRcaMuyGqOYyxV0qZTWjHdboLqvCz16P5cNFPOuqzcw
   CykqZFgnW0H1pAEB6viRox691Urwlh9HeiVR8ORuYQnt3COIMSRw6NvfW
   g==;
X-CSE-ConnectionGUID: pxlNBgiEQkmoMF0sLYASMA==
X-CSE-MsgGUID: 2smnRvFfQDmKw6CNq0wHSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58472668"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58472668"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 23:52:06 -0700
X-CSE-ConnectionGUID: 7Wrwk2aZTkOkWU1256V57g==
X-CSE-MsgGUID: I4mnfv3bRaqC8fcBatFYSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169002525"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 23:52:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 23:52:05 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 23:52:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.69)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 23:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rEDG0aJF2e8yJ7wWqMkMXEhEAl+5PBGveDo0srZyjh+u6FrESU7L1rN9JiXBAPDQescF99lvjeFAgP7PDyfNzpUWa1mNhkrjSQdfPfN/X+71XQEhMxKpwoTAQoMiqhhZAW6XqoxrRh+omcAz8KZqc4Zr6WuhANZ/C8UZyI5uSU/ZKdGcpPe545KDNtunA1lpA/hJfatkUgd52k7lhDEravafcvJHgbnKDaeU5gH/emd2zB51siIo+hLVvEqYjNeo6eV5qKdcNcuCqyJA16UJ2Xbdj7Y2Re8dbjxINXjYNIqj8YT3kniAjjPS0KBh919TbBvxEkXgaFzYk2/69Cc/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6mKDWj1PeF2oqRugOhoxDuMdvlOtJMPRSpuNX9cRoQ=;
 b=fC95BL904cYAX4PN3nz092HVwfl5Cj56tlcYBqndtz5Kog2klN2Ah+5nFHR2oWolcyyFMg5vCuXqV9INDRkUa2eGWGuHYv3bECkQ+M2fAKw41gebHIpsZd9OAgSSykPwAbxYUu51zpCB2Emdx7RiLKgudHtWDlW+FKRgr7L6JxCjzTxfz/9L1Bx5Y/pUaqNS17zka6GNz1WPrfeqTuv8JZ0gAT8Ztton4OpTo5tJ+VeXl+EhIB2pHKnUvsfRneIsbd1JMBBJ1cME54TpQdPxqZGc1tLAdlorDQfF2TIa7KrP+r/GT41z8Q2XC831CQf9Zx32y2hPqqdKCxtKBOpzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFF2B8F6C64.namprd11.prod.outlook.com (2603:10b6:518:1::d60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Tue, 26 Aug
 2025 06:52:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Tue, 26 Aug 2025
 06:52:02 +0000
Date: Tue, 26 Aug 2025 14:51:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <peterx@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: Skip invoking shared memory handler for
 entirely private GFN ranges
Message-ID: <aK1ZYeGaInCaixnw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250822080100.27218-1-yan.y.zhao@intel.com>
 <20250822080235.27274-1-yan.y.zhao@intel.com>
 <aKzQEi4fykQwvqLE@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKzQEi4fykQwvqLE@google.com>
X-ClientProxiedBy: SG2P153CA0038.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFF2B8F6C64:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc7ba74-f5b7-4df7-4822-08dde46d0f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?o4LKL3gjHK6GzRI1Vauom6MUrqudbtKrMFSRo/hGYIKMJgHR2m+y3kNxLgNQ?=
 =?us-ascii?Q?HFClWFCvLbiRsX64hmIZA6caiuGQtliRvmnwLXaZjIAOsEiouey2uHdSXTu4?=
 =?us-ascii?Q?ZVrqzg/U15dh+u62CIgm6xU4cucaWfIBeXcS2+Fhu+lJoX8JoTvwXc9x8bjd?=
 =?us-ascii?Q?Nj3lK8cg00TBEjVyZS+x4lzQ3KC8VE68OViJ1SJTXaXzhAOYTJ1vy9VfXdVP?=
 =?us-ascii?Q?s+vurX/fp7E097b0BIxC+2krrzfdbL2qLPcUgwXiyhM5P9LUWplyh1prfgz8?=
 =?us-ascii?Q?GuEN57o+R4K5kcJXWI6PohL3lXyrEfTXkju/fPUizPgd8JUWGXsB8T5uvHGt?=
 =?us-ascii?Q?51xqX0XHGD2SZT8zOYiemmqKcgMQIhLCH9+rs9w/JDblkfPLGhq+frF9bf7K?=
 =?us-ascii?Q?yxjrOaPdrFw0KKbDcfVaKB0C7uBwnX4zZvx1VFbRD5Bd0CIPZDI3K9Gk+UnZ?=
 =?us-ascii?Q?IaZWbJaBr1aaE33wzgys9pamyuX0R/xNYNhELetIXHYNv/EyjD6/Fu0iVChv?=
 =?us-ascii?Q?yE/59N0bjL/VEUnUFqu7duwVU/0L3uC/zTDZlz6ihRR8rlY4ZWrQC6Cq1tuj?=
 =?us-ascii?Q?X6EfxGiUVdJCVropja3hTboTPxWGNP4m6/odcy2w4flEVBKLUYuT42+76bFG?=
 =?us-ascii?Q?51EwiRuApz3RjAa5eSVo0GdAksRkf6Xw3Em7hkOXlaced4K/htvzObS+Q0II?=
 =?us-ascii?Q?A+JmETJTCyYPRrMXNEOQPbASe4LZK1CLjD9xbISYrgqTNH4irJ857+TpTn1y?=
 =?us-ascii?Q?LwAu9cCnqabKfoF5LTjRc8IyCq30HBL71bQDMkG3ViYDB1rLOClrS6aImplz?=
 =?us-ascii?Q?dU80xD3gXOL/74PQ5pNxz3Fz8YiUWc/3GypM6qAm6WHULsNvmPOP1gnB4X35?=
 =?us-ascii?Q?oAIUpIGI3LcV/tbAm2vo35cMlfZZ9h1FJC3PjP+yJwAAf6o4eFNNN/x9HXeo?=
 =?us-ascii?Q?PLNXM7bGW3Ed4DToIkz4KHv8u4K/yLBS4ePn8pKlfC4cshgxoUCCo6c9Orn3?=
 =?us-ascii?Q?XUQI77vSdQQcmnfHl0QVrmjRYnFnhtUY7oUzGPtlXXmcnR0XPChVud/cALlu?=
 =?us-ascii?Q?7cjbVhXR4zKmIPEb0V2Vhbkv8f0Gl3MpmrATJ0j2OhkRJrNmfDko7rPRnMK3?=
 =?us-ascii?Q?BdbrCVqA/hj5BJzFM7ISwhDBu33szYmjUEeyxUD6aStUy+q2p/RF8/aa+8mB?=
 =?us-ascii?Q?EWSVabPVnwDZExzhy15hv4a1yFkZvlhYMt0UgkHj4YvUgypQuG8uj+asqB9+?=
 =?us-ascii?Q?R0P8sUYqVQ9I2Rd1zWJmXlznsg333cj3A666v4xv6qj5c1Hjz5Cicx+AspMf?=
 =?us-ascii?Q?5Kd2IrR7pB3qkardospNVHi/tbXc8eHMsoW2XSbVjdCdQBi91nhFXWDyVUAP?=
 =?us-ascii?Q?ybfduKYabEKuMYWM1cRjuci9WE1G9AkWJq4Z3Ylyeyzju+KjOPy/UsIn3ixd?=
 =?us-ascii?Q?8qWTKjeODD4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qnoQlsIHFkCWXXyLvpwqanOPRsI9Dw6nb6PGaEpCGBAYngkgyFSxSWfXdS1j?=
 =?us-ascii?Q?Km276oz11bGutoL1bckyw4/NDN+n+EtSYsLWqGJ813Bv/ju+4UirdI1SlrOh?=
 =?us-ascii?Q?j/ahWjnCSRKXCDxPirCN3JRjsgT3U69sB2Npro3XnuflSFwrHveQnTap9rAn?=
 =?us-ascii?Q?e1iQrxcw/r1FXR827Rkm9f83jrXlp/GSo6/ktvktCbLn/Dxfa3h015ULw4xK?=
 =?us-ascii?Q?66wFpTJkAhiMnEfacVnXsXB/vAmbwuLmbd7gmNujZctMgE7z0Ki3sYTLKvKE?=
 =?us-ascii?Q?JKKtGAo0k0cidDClOnBGEO7G+OPIEY93JpZYoKkKBSZjDvlr7XZRNuWBVJea?=
 =?us-ascii?Q?H3w0D1uXIZtbGBknYhRxvXTUj1kkz2hjZh0a3ii4zFLiZnVIL+JVs6dangIO?=
 =?us-ascii?Q?kfOb97IwYNmAJ12BB30cXzw2Azn+VhPMIqohIEpHX5y+VckFH2ZLGqCzWyEs?=
 =?us-ascii?Q?Ghg//DQBmcJUg++5/TdJ7zBJUs6qg7Rpe/Xk5BYxPcCThIggRgdAETCcAVF2?=
 =?us-ascii?Q?ClZireSkbVkaOGHb/WhjhoDGH9qzlFsJRjTIuDmBd9HMolwGm839cqLvdl35?=
 =?us-ascii?Q?l6bkIcaywgrBCVd3749MWqv+AEBGA0tpA9eNB76CIwXPZgY1+AshVharObxZ?=
 =?us-ascii?Q?E2W4ihSycx5ULt15Yirfis8ru8CsX/wC8/7yaRkUKAJD3Viw/utAD4Vkb2wL?=
 =?us-ascii?Q?Y1LVZmFi3NHdGhFCvJTel6yCGAXZKluYGhUi1BeE6Yy/hq4WgqO9gb1hzsm/?=
 =?us-ascii?Q?Oc7YFYUmpAQKaaUai53DFfksBXyIbRd8U30cMDy1qtlJUJgeZiyOKUyRokNR?=
 =?us-ascii?Q?+djB9njr43n+9ePQGP1Ci9XsN1RV0O/UtaKG9T2PGZCrpbE7Oorl+QfWU6ba?=
 =?us-ascii?Q?zb9AWEjanHil1Z4W2LIU7rT7462s30FLAi6syKdg1z5XNz9V2y0oBaHaTo2W?=
 =?us-ascii?Q?9OTNKS/eXUFbxrN46TwClj9zhp2XBbCODhsFqy2qaMsofJTNz7o5XHIzw++l?=
 =?us-ascii?Q?KZtXsNJK9Qm/eLcZB58Ru++qyTkEFaZUw7iP1sDuiWtobIjWXBtUWyvFeN6J?=
 =?us-ascii?Q?lSeeX3KKsbiMg1W6F4uG2i+NSB2uVk755QXtl9fzzXeqnm0833PsbEDwQ6m9?=
 =?us-ascii?Q?kqE12wsiSl5GdLonz1zJdBBZgsTw1Atd5WFnx7W0TGcmxA4JnrLZHVFcCvfg?=
 =?us-ascii?Q?LPTopMWQYy5SRMqizZwzSgTU+eIMsZlAunxUH5HRuKPiiy9R6NiALZtA0tiw?=
 =?us-ascii?Q?1Qz59utHJl9sO/1yOWYLntStTsBobAQSaeZSSk21kSlNsOCq3M5ZuWDFr6Yg?=
 =?us-ascii?Q?jHFJjdi3NjELnG+cFHI+VY5/xPvz4qxFLGCOzEafhSAmrF7B++0bEUc3QNZp?=
 =?us-ascii?Q?9bx9dXuTy48n4DK6kJbxg3MEn5XCt/HPX4JVvGD3IgC2eflGAENLANv8ipr5?=
 =?us-ascii?Q?pptpTli6PEYRBacVz+I+QPNf6uBbDwJ3ukoEeB2FB24ExCC2dU5bFRHmiInj?=
 =?us-ascii?Q?LliSH5hzcAT3kppgVje1nGUOoA1TekRkJ2bhVWAZ2Nd3Y5mEOwcjaY8dGixY?=
 =?us-ascii?Q?+XsW95VM8K8OPKkmFk3+vF5eS921jz/e1bKfOMf1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc7ba74-f5b7-4df7-4822-08dde46d0f74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 06:52:02.0164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oiKnv16gXRHiFhIzWqemF0fSGXGRj+SeUxLvmO32m5RuyKJBFjmxENQiAlaJpZUgwJ8vC9lztfs79XmFof4jlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFF2B8F6C64
X-OriginatorOrg: intel.com

On Mon, Aug 25, 2025 at 02:05:22PM -0700, Sean Christopherson wrote:
> On Fri, Aug 22, 2025, Yan Zhao wrote:
> > When a GFN range is entirely private, it's unnecessary for
> > kvm_handle_hva_range() to invoke handlers for the GFN range, because
> > 1) the gfn_range.attr_filter for the handler is KVM_FILTER_SHARED, which
> >    is for shared mappings only;
> > 2) KVM has already zapped all shared mappings before setting the memory
> >    attribute to private.
> > 
> > This can avoid unnecessary zaps on private mappings for VMs of type
> > KVM_X86_SW_PROTECTED_VM, e.g., during auto numa balancing scans of VMAs.
> 
> This feels like the wrong place to try and optimize spurious zaps.  x86 should
> be skipping SPTEs that don't match.  For KVM_X86_SW_PROTECTED_VM, I don't think
> we care about spurious zpas, because that's a testing-only type that doesn't have
> line of sight to be being a "real" type.
> 
> For SNP, we might care?  But actually zapping private SPTEs would require
> userspace to retain the shared mappings across a transition, _and_ be running
> NUMA autobalancing in the first place.  If someone actually cares about optimizing
Hmm, "running NUMA autobalancing" + "madvise(MADV_DONTNEED)" can still trigger
the spurious zaps.

task_numa_work  ==> found a VMA
  change_prot_numa
    change_protection
      change_pud_range ==> mmu_notifier_invalidate_range_start() if !pud_none()
 
Let me use munmap() in patch 3 to guard againt spurious zap then.

> this scenario, KVM x86 could track private SPTEs via a software-available bit.
> 
> We also want to move away from KVM_MEMORY_ATTRIBUTE_PRIVATE and instead track
> private vs. shared in the gmem instance.
>
> So I'm inclined to skip this...
Fair enough. Thank you for the detailed explanation!

