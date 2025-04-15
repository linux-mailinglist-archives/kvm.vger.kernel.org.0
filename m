Return-Path: <kvm+bounces-43324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9639BA891A8
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 03:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96DA217CF4A
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0316A205E14;
	Tue, 15 Apr 2025 01:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVCZFZJb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCEC2036E2;
	Tue, 15 Apr 2025 01:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744682161; cv=fail; b=OHnb2TDOA3v703qxPzgKYjW5UB8A1pd7cHAQ8ZCkEClCibF8+LptwKBQP2E1P2dr2aS1MO1JltIZRa4z8O8s1Hz5HLlT9UYovwPWzsFxNRTVtFxsDNdqeG5sT2W79vwkOYekSbqHdrI7fvdYGZNvBl/C3kgx1b/y1B6VOPceAXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744682161; c=relaxed/simple;
	bh=4ORgjJ7cbOMu/jfqCM6jl2ku/CrQMHey3Vd8cOOhmS0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZQGHkE1P4hcry+8ydWCGa1sjybj75vCslKZKeNK7AEm9poBQBiGcY2PD05JuCNINToexYLx/tmZtJl7JhvpoV6S+6ceXG2ogcaFn38JkuOjySzvbUZW/crGyb1f0luskWVlB0oXpu1+phUf2UGVeKzSuAodbba1jtc9Hl0BJ5kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVCZFZJb; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744682159; x=1776218159;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4ORgjJ7cbOMu/jfqCM6jl2ku/CrQMHey3Vd8cOOhmS0=;
  b=nVCZFZJbsHxxRzF9eJO/6JJZorYqhgWGLFA/8+YkZ9GCVH3luAR4JqO6
   pwdLUp1Y8O1IqvcC6Uk+BhcUNCWOtyDxw99Oe8L7i1B6EFlXJv5KrF+gV
   wjnuCq1+ts4lQslizAZQFjrxIrN8JsU+kXTwMSSUIZ3XCx7nExoc49qIY
   s/aY9hNrYl1U4WxxM/eOb2I+TefmFZX6/vIw1X9NC93L9pBX/D0FUzEiR
   L+wSKsQUnUpz8/oBQ4mp9K6YandIOahCvOv8YHFe4HFpsR4CksfJ5EjK4
   Y4YwazfgDIkHnXsELymPmEcD7Y6aUVtbdrOiNPpu3+JGEkMrOvzbEif9C
   Q==;
X-CSE-ConnectionGUID: 6XbhpiZGQzWXR+8ja8mJ5Q==
X-CSE-MsgGUID: e4nykGILQ2awn23pC1+4cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46051783"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46051783"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:55:58 -0700
X-CSE-ConnectionGUID: YY7OWNxuTgKJT3clm42aHw==
X-CSE-MsgGUID: nwNP7g2lQwGZua8zmwAXkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="153162712"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:55:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 18:55:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 18:55:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 18:55:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QdDH7VC1FXoru+/UB8uAx9X3I8kd9X2NXumJa3kTL77YtKRn/wFtwkaHzu3YdZIELpX2EctqEMczpQdkd2BN1/gafY7zeo1JBv/zXNxoDjT0voy5H+3RxSGGEu3e+O3e8RQoqA3+ZLX7+atvJhmm+KHH3OG+Nu5DMjRsv4/zg/pCOTPwFtWGk9UqHTjdNhDgdCJEIbxYaGEftis77M7qd/X4pJC1k8h9qqWUfUTuRhoDZMoeeKVQ1p0VpBRwCIrB75UsFovDb0uDuRljwqL5uEaJvQe9DZksfbcW3kCkptre8nHCfu26szQWx8PTbhB4GhkonA9iknWyvKXNKhFY2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwN7CjsfGfY+zicQil/a6o9CIhAULJJTVmsfsvQRjrk=;
 b=c+CEKXgXlrJw/XanprZkgCBUewnbQfp3naPIW2BIPjY+FdUtP2K0QLsHHTvBwADhQ6tIo6ZAOon7zuySD8wc/Im0bv04/LsOdZCvtsGxMb681XrmKBvD/7FINp8ONaNGJHicA1VCw4HxCpAH4k8ROrteqK/5vx2xvb4YY+I7wYa+vf/4J4smfSteAXCEzS8Dc5o9ZAN5OAsTjBjMjf3lAmC+wEom3SxP75wDCFfANRsg3uQ0Yz5z4vMW1fj1Kn0H5hcWc7WGCV4GpoCxDesNQvSk6A5ykWuJzguirkvr3hkTfGw+nsfKC8/ZPUjpSvl2DRM4MMsdP0KLdV0SelBG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6094.namprd11.prod.outlook.com (2603:10b6:8:ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.36; Tue, 15 Apr
 2025 01:55:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8632.025; Tue, 15 Apr 2025
 01:55:54 +0000
Date: Tue, 15 Apr 2025 09:55:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Message-ID: <Z/28oU4l3fb49fiO@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com>
 <Z/jWytoXdiGdCeXz@intel.com>
 <Z_lKE-GjP3WQrdkR@google.com>
 <Z/0LJTnNCsQ3RIrR@intel.com>
 <Z_0XCXwptNhtI_A_@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_0XCXwptNhtI_A_@google.com>
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6094:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f2c4de7-3003-4dec-54fa-08dd7bc0a837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?15H4P7H5o5dbye6V7XuSPMdfw2PhYE0jl017FYuDdeohrTB2rHaFPSS2FH7X?=
 =?us-ascii?Q?ZMhGSKM5TTPiBujppZaPYrBmdqUGJHO11PyTdJUnwxtBxk1mizFPR8bl2KNC?=
 =?us-ascii?Q?peht5Y3yv1v+4uBiC75zCJhBWBVIfJFkgH8v2NValzau0HDedsIQx44y9t/a?=
 =?us-ascii?Q?pZVzWqQx84NepRLy1Qpfsc5DzNpjny5Keo659K7vWQ3jVZ2tUEjLu5GK7Cat?=
 =?us-ascii?Q?3/EbqmLh7wmjCW3gvPoBlOJ0W+YpInAwBtX4UvHN8jUGL0XAcDNjccb/T6HC?=
 =?us-ascii?Q?SIcn1KusxC5JCL41uFPVbZkexCf2qCAITo4zyW+x9LOxv6+SpqtefdGxW2Nh?=
 =?us-ascii?Q?WTJH3sQyYt3zoc+newk8hkLB4OQc+mw9T0Y8Luol3VyBnkrH5u6ZLH/VCIQq?=
 =?us-ascii?Q?uy1lmc4brjNk7YHvFPaOVhFpIxhbgel5Yxx1YxjEUMBYpen6ZNGfyM6f/2vs?=
 =?us-ascii?Q?zL88QHTzgQQLNNI4DE9aN1OJoihRGVrmhiOktwjAbAPsyvPL8/sCtpyOLiUW?=
 =?us-ascii?Q?8be2ODmpPngPo0/62q6/0U1L6X1EAuKRGNUvt6EVw/uHYeTw8R5O+Q8CHDiw?=
 =?us-ascii?Q?+SFPURzvosNyzK7/SegpWQdUx1Yjc5ptFGfJcUeaFeL2lSKFojJHUtewYiBv?=
 =?us-ascii?Q?aeD8pJlQRTMznfTJWEauDLoZxaKoZvRcAL4wjf5pBCivS5pL4BgCdaXJUaAJ?=
 =?us-ascii?Q?q6k77ScGIhYg1BTfIa1PcJpGQMpcufiwEAzY0bU3dnYhg8a48zWsrztOa/an?=
 =?us-ascii?Q?ZSl8PpMtmO+JK+c9l1q1infHRCq6NCfBTUDZReiiKIIRmKQ1ft5PhoUaBUgv?=
 =?us-ascii?Q?x3tIEM+0h/gHETWiJLB4IcRAftDQ4IEvhd1iS7MSr80Vnpdi9cBgoxvP52d6?=
 =?us-ascii?Q?tnjUIMjpmW22z51H+qDyLaDEUHrgkWAXxTOtcAjV0Z68yIkylqfrUEn5aRhQ?=
 =?us-ascii?Q?OC5NHb+HBMyintyWgozhbvg9C4xEkhZleDt4knAq9yX6DUDprnTxSHV6V5fD?=
 =?us-ascii?Q?7HV1Gcev5n2Yfm/THsrNpc8X4i4M92LR2DWcrJFarZsSUrQsOeqd1q4EOeBa?=
 =?us-ascii?Q?vJezXVp6CjD3iz3cEdIm86S3zd1Y1xCe7cvqNjP5krzaG+08KGndz+tOlMhE?=
 =?us-ascii?Q?lk3Lno7JUH6l4abt4DJGFcPbRXkc9D6aa95jmC+yxvkUvBPi+CCKo+4sdsDe?=
 =?us-ascii?Q?mKogABO3qC8fDT0HK/9zl/vZq0Bmc9YGz0sWhpgGr5aWXFd823YBE/zjTf6T?=
 =?us-ascii?Q?oV6tuYHRQTIjF+Knp9jV9dHV8gXt5vxPrya8WVrWXHZGmhdzEvlmEbnxUJN+?=
 =?us-ascii?Q?eZbJIKgOeEbTB47HJ1olt4EKCp2CxBMEDotN4up8450lpN0zIRYlYHogm9Mc?=
 =?us-ascii?Q?CeaSvPRVf1/qYHn6x08TaYVYEscrL6VIJnuv+tGA7drMhplC9xA+7XvueSym?=
 =?us-ascii?Q?OkfnRkhnzVw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XCqFF+k+yq16McoLyUeiUgVuePY8ZVbQKDk5a+QLgMvHn0dTV1qg3/R5NCyC?=
 =?us-ascii?Q?LKz1Ga3HzP76QDguErNVrL76tKC+OVgY2wCUEAiz7y7Kn1l/6DlXvsgFcT5r?=
 =?us-ascii?Q?z8BZhfmS3ScxyfjGuU6IIZCpF8Yl/ZCc7sb2I8OPh71jXnj3FQdqIyiCd3y9?=
 =?us-ascii?Q?BAH7GBZWBGhIQonn63L/0PkIDbl6M0OOQ0laStVWViMw4tetakr7rYIUJG0s?=
 =?us-ascii?Q?i4VdanyBjAHGEx3os0QG0IS8tTeHVLodv/6q5yHyXJ9zKkHgtaN4l1ZcLj6J?=
 =?us-ascii?Q?738Sv+XKeK88CqQic1rfVFD8iF+u9PpcBgscNTOFzhIrJ38F4dsRHsS0Ife+?=
 =?us-ascii?Q?scy6gzpuSS+E8E6wJ1IdMZkfF4+wPGupzqyoz3EL7VGPLiytQBIWqJ+u8eMe?=
 =?us-ascii?Q?80RakW9HY4ozxZfei18WHQZYBC7snQLm53oKrB8NTjXqFmfgP2Qc5HKWLEoL?=
 =?us-ascii?Q?FXN95K7TjfoCDL2hZIU3R08GkBxRJx4ORuay0gt6LfdnA565uLnsZSMVmcYA?=
 =?us-ascii?Q?xet2EV4dwpKcvp/naj4mZDFr2hyCeL2KLqQp+ej/q280Foo5CWC98cGmrnYT?=
 =?us-ascii?Q?gjmkRb4UbXwbE439XXwUrA9vNuJ6gFh/7gfbUmEcFIh+IsuFSmIfaBuianiQ?=
 =?us-ascii?Q?RqTC+f4XjgiR7fzmJtdkcc6YrLjR0+5SA2S2x7X81ohRVpGXByTUVHpvzlow?=
 =?us-ascii?Q?dTndfXLT8T0+H3jTcf841wa39u+mZvwQ92L+x/MxDiX2dIARZP+E4qYNt36P?=
 =?us-ascii?Q?/ZZlsld2pmUWf77WXzPR94rSboIsGYcYZx5wcscuVeiQVfPugwnmFBx2JjZb?=
 =?us-ascii?Q?Kj+/0pADL0MCfbMNl1Z62vr4ZeQvaGNEz9Bdatu+ZgDR54sb/Aq6UqlmPOiV?=
 =?us-ascii?Q?GxS8v9K6ORN8Afr7RC8laNy7W316X3Nqes+XJPlgBLfNea+ZTnsTmDUn/9SD?=
 =?us-ascii?Q?KPB58Zx2JSVGQ9In6kB9dtFUvGeOvgKmzPB48u8arEDIz/TswQ7/3dDOO/4T?=
 =?us-ascii?Q?2IidkllBnlzWQ3jAHzelf12TTt1SmVtGHNhzOMc+n/ZHrwDgv1596MAzK8h/?=
 =?us-ascii?Q?2qrjEAfPOpyyoP+Z0gQWo12+xoXH7OPJvnWGHV19CcOmlVOl5cpiptHrIavN?=
 =?us-ascii?Q?tqu/q1uUaDdZ4VXfNmr/2bwu3PHBYgPwAA8xKMFIqCbyMj+E+GcOjSNLwqlm?=
 =?us-ascii?Q?1FYlsfKQn8A50FCxCB+raragGspjYv6rTt9gANlQUeQUqJeDWhOO5Q3NeJvZ?=
 =?us-ascii?Q?qnkKstTxltlGViTR/9u2N6rxrIfkU2PaioRMCFPoEQOCmN6jRXctb6zzPhi5?=
 =?us-ascii?Q?lH3RayQZMm/+WFa8cjBvTTpuqrkCmkCSsks9TVGLbknsvfm42fOUmXm9f0g6?=
 =?us-ascii?Q?XCX5QuzZn/PpLz2RDrLwxCO8izUpfrT5DmCDRrl0sZ5nSSg5G+ns+0YxhubM?=
 =?us-ascii?Q?n8SbtKutjvqXh6luhbetiW8FSKqsBsX5VSMGj5S63mXL4lC2widXqKfIKl/t?=
 =?us-ascii?Q?P2HHIBxG1EYP7z5iDepXEW1y+CJkmzoStM4rLgjBPdcLyT0SlaCDSq+BNNkq?=
 =?us-ascii?Q?A+PGGi9U5G0mHl5bJZMcZoHFg4+RDMyRl3SGyKiC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2c4de7-3003-4dec-54fa-08dd7bc0a837
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 01:55:54.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehdc5h6Mb/tmCvXIxlP0kzlG8t/F5JW1fpEfqolZ6GFKK2A8Qvk2gwI9jXKrYj98DJ+jzM4AwpFx++RhJHW1tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6094
X-OriginatorOrg: intel.com

On Mon, Apr 14, 2025 at 06:03:44PM -0700, Sean Christopherson wrote:
>On Mon, Apr 14, 2025, Chao Gao wrote:
>> A related topic is why KVM is flushing VMCSs. I haven't found any explicit
>> statement in the SDM indicating that the flush is necessary.
>> 
>> SDM chapter 26.11 mentions:
>> 
>> If a logical processor leaves VMX operation, any VMCSs active on that logical
>> processor may be corrupted (see below). To prevent such corruption of a VMCS
>> that may be used either after a return to VMX operation or on another logical
>> processor, software should execute VMCLEAR for that VMCS before executing the
>> VMXOFF instruction or removing power from the processor (e.g., as part of a
>> transition to the S3 and S4 power states).
>> 
>> To me, the issue appears to be VMCS corruption after leaving VMX operation and
>> the flush is necessary only if you intend to use the VMCS after re-entering VMX
>> operation.
>
>The problem is that if the CPU flushes a VMCS from the cache at a later time, for
>any reason, then the CPU will write back data to main memory.  The issue isn't
>reusing the VMCS, it's reusing the underlying memory.

Yes, I understand the concern about reusing memory. I would like the SDM to
explicitly state that the CPU may flush a VMCS from the cache at any time after
leaving VMX operation, and that software should flush a VMCS before leaving VMX
operation if its memory will be reused for other purposes.

