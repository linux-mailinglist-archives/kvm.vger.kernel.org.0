Return-Path: <kvm+bounces-62263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3107C3E518
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 04:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 712FB3AD771
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 03:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1C72F5A0D;
	Fri,  7 Nov 2025 03:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BJStODT0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FA118DB35;
	Fri,  7 Nov 2025 03:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762485289; cv=fail; b=NR0RRboyQlljmEIEikz2L8sq6/5p8rbvmyEORrfL/0aSA4KqGaE1HcX5F+r23KUB1VvKT7j/N8UBh+aWsmfAhv58nwgvbDMam5MIedEX91IjiUqZXHLHyH8bKrBbXG8gy3Gb21RRhuiPUuCEWNGm1cPryaeq1qbRumDV44ubQ9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762485289; c=relaxed/simple;
	bh=Tny6m4KtOKW5r3ExXl5hABBtm87kcu60UV/4EbHW8ZA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JoOlad4WkYaQ+rUYRml+wolbde85VfcZUKtrBAmNB2iqYVizY2X1//QXC4yHZQ88QOLgB5TqlGptKWCqouwmT8ix6+QrSAOkXix6BTYCG58lKP6GF1ec/Rm1w1YEJxpZXnILkewcUbYJNeuJFtlZ7RA2llef7+2wr7U/vOrQ7/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BJStODT0; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762485287; x=1794021287;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Tny6m4KtOKW5r3ExXl5hABBtm87kcu60UV/4EbHW8ZA=;
  b=BJStODT0A55+wW5YGvvI2dcbv2/N/pAYGmDvqla0k250ljn7F8Bky0S/
   cdRvAbDmLT+632XV+OGLJqNuWDhdkdjXDQbdNU0itP3tId8fsAaOgEpoX
   LIJ404uGmCl5YkCdbGXFf1Wa21duWWDlYJVsMJuUMlPRBCGabWWTkjLSQ
   ImbICZbaO+7WCli90irG2yMc78m+lgTqqcvgUsxEi22XZM112BsKFzOjP
   tqmVHgw86ytYQzbFvjGuhYfGJDaDV42vXNjHj4ZwQosVU3FKH89t2gDwt
   Fv4C4/eZB2jIZi6ExHulHyVnLB1dgRxWIJ3izeBqISRY+u6ViotoPD4ua
   w==;
X-CSE-ConnectionGUID: EfvjWUJ/THS3Ff3QY1Vb8Q==
X-CSE-MsgGUID: VG4m/KuFQJmufBbMvwKYGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="90105945"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="90105945"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 19:14:46 -0800
X-CSE-ConnectionGUID: Q953lVOvTrCl4uxUhTeihg==
X-CSE-MsgGUID: sP4HHVHfRiyjNd7CPTR68Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="193100065"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 19:14:46 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 19:14:46 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 19:14:46 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.60) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 19:14:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k41MjXgyBpHmXVcX31UpUCbVemYEO0cPmgXt5i6msPcNhFqQwpSCvAi558ejSAIgiJpIWQxjFx/5J6PILxPRO5aiUT6weGQZFIfWQ7JGpsMnm4GSqIKtXSJiSxFOgJnsAxnazMrWM3NeTf7mnzD5bgPtpRn7xWOqbo82NsxCKaehxWMHzsjAguysaI9dRxhmvAySaIoKBoaYlFW2tVTagfWz4J+J/hDAZGqXPmsEPEBdUYtitByVKxxzpoFvRkhDU4AnW/nOF8hLpm0nah1eqHQ8+acgCSVyPK0hPeLOVyWaTvzbw+xmectKPxoVe9DG4N2snlJq7XnsWsAlhWD7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dk7jaYlRz3cg5ouMGRi1qAWkN5eNwzO6ubB11xxoiQ0=;
 b=fnWzvuOiM7ZFj/z8yslikUtcCmtmOVN5qJaPm3ZgrmqkjN/j1kQgdg1EumpCDl0pIXcaHScKW9IDvizrii89Ja/+PAi5jFjyBBCsxwu0DVbSAfHb0NvDMyHkpZnb3wbIwjxXCPTlXV4QL/F/dqgZqJiQdsM6o0mU24KWYRuOorqM7L8Rzut2kcMOpo/PyNG1hgy8aXerZEbBWRK8QJNVm4Tr6lE0A+iy7RicAmLWwNLPGrp+wEmNsNz2vM7+hsZAzbTrnr1kCeJxT3WN2ErozvQ/nqXr43m//Tj6kK0EeuHAbZzdAlbuHyZY6efuOzsqNDnSbuoqTNWcQUEnYBHQng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4896.namprd11.prod.outlook.com (2603:10b6:a03:2dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 03:14:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 03:14:44 +0000
Date: Fri, 7 Nov 2025 11:14:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Add a help to dedup loading guest/host XCR0
 and XSS
Message-ID: <aQ1kG5u8GPdEwoEy@intel.com>
References: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
X-ClientProxiedBy: KU2P306CA0007.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: e321318d-20bd-4d72-8cd1-08de1dabcc57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5613AouRqfrONXsBsNecKwi/h8hHTcn/PJG8xGdbQhKH4C0ExCV9RiXOwRcH?=
 =?us-ascii?Q?lcL67751oM9xjg0P3n/okUjrUHRQif/e/8SXJS9ghfaNy+BHOIJXUwlQWzse?=
 =?us-ascii?Q?EZGXE4YfiooRbAh/G1A4/gesZojsimecDAm6mp8H9l9IWD7RTgHytwI9z8ES?=
 =?us-ascii?Q?g30WPqaPcmoCVzd7xgbMdk+MalS9l2P6XrNVht6w/7jLbeRik1p8RmJzip7q?=
 =?us-ascii?Q?ozSFnlVmVPFRlWmhOwWhL3dCtdSDxaAFf9stqBr4bebGibn9+nm6y+pNwreL?=
 =?us-ascii?Q?Ah92Tcb2WT/DBJHJ9pGe2d6fCR3ch4IqiJScZY0tGXmSZt+jjTU9qlVzeVeP?=
 =?us-ascii?Q?ip0rq9PJrtManSCEnmrBH46B/jxTuZbox5eZlvgYlSaWsbSaKADTqIHppffi?=
 =?us-ascii?Q?EfI33HE1sKPo4QXQHZ30TQjYsiv0/Ef6myAs9ehdC2NRfrFVh4CvlUFw905Q?=
 =?us-ascii?Q?9ZUVXC9wPgKruEq9gEl8mch7qEsQNtP1X+XwWzhDpPEv0vw9+7JdQ2kX21Ho?=
 =?us-ascii?Q?tjLvQJoIu8GHkhLMHm4DkBIXq+trOPO0RUaDCIY2kpRNu+n2g9nQEh+RQQDH?=
 =?us-ascii?Q?Bmxyar/AjGyZTh77C1LPtgLbQTT+XrEc6prWD+AXNKtW+uvkdjFc1gRXYa9g?=
 =?us-ascii?Q?f0q6xTAaHSQD/CyH8Rlc6ZGjEtz4wUjhDllzibMhpCW5K97th+2jAeyqi3FI?=
 =?us-ascii?Q?91Lom8m8mCjAImkOdWXnNT8Ot5/HqOItD1NZveCOEG3XBpcAx9eItZc5lapj?=
 =?us-ascii?Q?wiAUDP8SFyNQBMjXhyO7rwpxL3SMLBNzJbC+mN7HsG2xqVAFQ/KTg/nns0J5?=
 =?us-ascii?Q?y6djijOyf4ybUnF8rb/xwnx1t0NbdlCRK1qRG4idaBhmYikaAsl4g0VElGnl?=
 =?us-ascii?Q?oPiSrq32RrjDtRJJam2sJJcs33W7qli0p+ZaI40TsaZR8+9Gc2rpgfb0Rt5a?=
 =?us-ascii?Q?mDPUctJSYfqzmL1xwpTHJ+ACRsntOz1fI6mFrOkhBDDAp7gNA/js9JbeK03R?=
 =?us-ascii?Q?Ze89b+Y9y+kIRbJa2xr7pFw0c+n7nouZ3PUrhHdOFiUIHYah7Tc6Zx4Ge55V?=
 =?us-ascii?Q?XWE7JFRbCnp9Kob68ZnwGYOY1ttaCFHZ08qHJWWFiybpCp+02Zflpops7bA9?=
 =?us-ascii?Q?MQw/Rk3KYEsQID5Fd1Pt4hDld5c/yKCNIlYeh1/36izcTro4fbEWgfK4c8J6?=
 =?us-ascii?Q?9tzagqOzl7A/eByX37WE4XM3czhfBxb7hzliAaEEnM7oS6eVWWTWTEXapUWG?=
 =?us-ascii?Q?vLWvZt51KdjJo9TjqxoCQ79+4gCO2pHpFILsAU8WP/EnAkFx8Q/IBjnAoIhW?=
 =?us-ascii?Q?rtpOrN0F3QI8CvUWi4W1uC1XdEo4ZbTvoBXqtj3xY+iho+K0L5qgSSNy8lzT?=
 =?us-ascii?Q?Hq2i31GiTfjg+CMwMVIDPaAIma8LKGxsL/+x3CiumwdvoiTZjmA08RK0Nrkh?=
 =?us-ascii?Q?FbLUVNwnxGdVEkgWdFersHtdE+4WeQ3e?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8MK5ohyuyuYIMEvi+AQeSsjxRwoT8P9r1XZKguVNb3VxlmUJjTdcXkqRo/v?=
 =?us-ascii?Q?YqYQPh40NGAG4usRoE7c26qKhiMlmc+4dv1+t+kFDa5C1L3Z93KvUn8dKVhp?=
 =?us-ascii?Q?Ds1NfCpvjLsUK350D+V+uwfzOetTcH5xKa+hHzqmGM/LkASK3DUfZTKyj6hK?=
 =?us-ascii?Q?9p/v45OaIKvMfU178mseOENrgbyQC/VIkk73nE/n3Xt6U2sYLskzMK1qtL9v?=
 =?us-ascii?Q?9z0FYOpYb2JUDfPDvDlVvUSnwsQ8RFcUFQeMvs64M7g3cBMs5LsRl19MLMSb?=
 =?us-ascii?Q?DmzFc54mh7CUaklQDgLtgKEcxs1FCz0ZVX/jccOQoPixOZFvM1X5Sssohfqp?=
 =?us-ascii?Q?kEVkzFxIYPtxGAo4BqSRqvW7hug/TEtUKM7tJxZUYRnmzLKo92f8PvcO0+Bs?=
 =?us-ascii?Q?3HieXbm7scIsgX1wz/zZ9whdRVwG5yXHt+RKeztZp9A8AV2KmihXwzEz3Gfp?=
 =?us-ascii?Q?QtFK9Ss/jaya/TvIM3pLO187k7IdpUbCmZjfqTi8fiADTxJMJgHZcdUCdHYi?=
 =?us-ascii?Q?OoD7ISlMz+VcHZkZeAMS0UV3VW5TItq6qNRyTxQ1P6lGhhhdGoCZTpOiyvuG?=
 =?us-ascii?Q?c1VBIlQ7z+5iZSvfKvZTbkdLhdOpks9fQ80mcsWL3UWFvORJMK0M5VKlL9t+?=
 =?us-ascii?Q?2f+Wr4wEpTEEUeKjdqXv0hZ00R6nWJKc7umngtDgz4c8QL+QLIwpdVOOiqfJ?=
 =?us-ascii?Q?540K8EKc+lIW67iyqAcGKMj+5l7Nb1C/6YIPodqkshaLeZrg/7gCmQSdS4N2?=
 =?us-ascii?Q?1VhqqKkFzwhBMtp6bFu4+KfUWVFIMvrKL7gFbrez6q0kLhgId8mvliKUKPCF?=
 =?us-ascii?Q?pgQwwbGGnUyYB8emZlzO3ZvBgXlaqm66AaeIXs0HgmmLlvc7NbVZSptnWyy8?=
 =?us-ascii?Q?B9ZNTeF3WUdesknzxdWjNMgIl+GZDnap+613fhDaRgWFDmA83f6s64gt4Oxe?=
 =?us-ascii?Q?dTRnQpdnHBdwH0crcfuWP9MhjocCI0ignu/It+3CX40BYlay9o5HGjWjnd4o?=
 =?us-ascii?Q?i6LuVHjZSOSz6mtb2h2R5VGPTFYD4rwvq/cnu5U5ELJaGiNoe7bS8wOgsRln?=
 =?us-ascii?Q?aj/6pao7j1hyY64f+jEZOTKp3W9X+EJc+1nCaIvIj1KXTcN9SMo4ontYR13/?=
 =?us-ascii?Q?pROcEfzSIDsEasnGpSCDiWjpRJQEkyz+PpstRf29HiUoAYaWlVwxuOVKuISi?=
 =?us-ascii?Q?PLpkce/H3ZaNN2gm+WIptzclasbkPDaZG4qNZ/07/RiEzOSSEVBV4+o1OY5E?=
 =?us-ascii?Q?P0bgjfVCASB7swnAPPh3R+GZ8SYPDyoSkAxbsBHmRlPgTDsa+5gjXA3fxMNN?=
 =?us-ascii?Q?z9Adnq3DUYZTw7o1tX6OIl80VcP3kW775Jc/yrr7qOYFXcT8veAMiBjfQVOZ?=
 =?us-ascii?Q?2CmmsS3zqvx7E0OUmy05/87wKAnvGG93LISYin4KR3qco6/XcLwJIzCZcmWE?=
 =?us-ascii?Q?HSQF08knp5WXqeK2JcccO9sbe/S6SRVAFJOc7vwsIy1eGf+KOnGIupoFwcyV?=
 =?us-ascii?Q?Uay1fQG9615vJUlNv3VIvIv+0a/eu+kJDQqAvwiOgVIMZPOh2BsSzx5WHtyY?=
 =?us-ascii?Q?nOFDBgyFreH0vVLTu7/ljwh3fWU2Lej8UNspxdIf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e321318d-20bd-4d72-8cd1-08de1dabcc57
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 03:14:44.0386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKgzU8J32yeAZ+TUTAcT0P3Ax9UlsGN8Mw6jdliPEJt6ifgnSS6jJVLGVy7NQWhR5do2vr7+R8dkxjaQtJerhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4896
X-OriginatorOrg: intel.com

s/help/helper in the subject.

On Thu, Nov 06, 2025 at 06:11:38PM +0800, Binbin Wu wrote:
>Add and use a helper, kvm_load_xfeatures(), to dedup the code that loads
>guest/host xfeatures by passing XCR0 and XSS values accordingly.
>
>No functional change intended.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

<snip>

>@@ -11406,7 +11391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 	vcpu->mode = OUTSIDE_GUEST_MODE;
> 	smp_wmb();
> 
>-	kvm_load_host_xfeatures(vcpu);
>+	kvm_load_xfeatures(vcpu, kvm_host.xcr0, kvm_host.xss);

Nit: given that xcr0/xss are either guest or host values, would it be slightly
better for this helper to accept a boolean (e.g., bool load_guest) to convey
that the API loads guest (or host) values rather than arbitrary xcr0/xss
values? like fpu_swap_kvm_fpstate().

static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
{
	u64 xcr0 = load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0;
	u64 xss  = load_guest ? vcpu->arch.ia32_xss : kvm_host.xss;

	if (vcpu->arch.guest_state_protected)
		return;

> 	/*
> 	 * Sync xfd before calling handle_exit_irqoff() which may
>
>base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
>prerequisite-patch-id: 9aafd634f0ab2033d7b032e227d356777469e046
>prerequisite-patch-id: 656ce1f5aa97c77a9cf6125713707a5007b2c7ba
>prerequisite-patch-id: d6328b8c0fdb8593bb534ab7378821edcf9f639d
>prerequisite-patch-id: c7f36d1cedc4ae6416223d2225460944629b3d4f
>-- 
>2.46.0
>
>

