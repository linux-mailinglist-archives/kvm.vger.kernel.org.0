Return-Path: <kvm+bounces-33007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8419E388D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF86516379F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502881B4157;
	Wed,  4 Dec 2024 11:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6nOtIL1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B951A1B21B7;
	Wed,  4 Dec 2024 11:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733310808; cv=fail; b=JoK7ci3XL3r4JmdqJ326C3LpVxum4uOrWWBLwzhOkkaITEipYV2BGSBQyJQSdBg0oD4GLEEKkmVisGOB74oT7QZIRDkslMZA1/sH+32PR/4wxGR8fK86/TA/IjeLSpzN8mKmAszkrnpho4Z6fzcF1raSs/edYUqlndBROvqnqYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733310808; c=relaxed/simple;
	bh=kDKcYCrsRrMmwMZPTX3Qzh9HktGqp+wI7hzt5b0k1as=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g3ynv5VCNgdlPutGfhSQgufS1rjptu5/DJNyGs4z/OEXBTPJRFLQcrHatezbOHfHZ5ZfGkaRCWpRhwuIj27dkqT3rFIjew+SKUf5CjBUakGdrjtOHraiZr4mZ4eCZTkP86pGusb14KTwnVjy2+P2dmTiYtqTeQcZKMWg1sf60XY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6nOtIL1; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733310807; x=1764846807;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kDKcYCrsRrMmwMZPTX3Qzh9HktGqp+wI7hzt5b0k1as=;
  b=Q6nOtIL1HX35th0dmv6sU3p62wobezvFK66XBLFMM0huRs+1lMCAKnRr
   PMDTofMTr4SRsFWB9LSBlDlVL3tjppC8JFvnrxk+W3XmPHOIYYqk+kV9c
   dpCjOamUtpkhUj89omDY6XgjwfyRt7fZdmjFQUfbhy57d0b9Y3tGLSE7c
   SkTMQQelHDglqL84AMKI7R/A7SjYEn9c9Ek97ZGtQRRZZ+JW44IRN2BuP
   vnjPh2053x3hmNu8H6DxcfCZGiiJt+k9mLEKBPnozBv02rmSjFxD3op9l
   t0CnP7k080QAANqRrlQ6YXXVcuHMOwyXBB/HpYm3WgsW15TLxupKNWtoN
   A==;
X-CSE-ConnectionGUID: jTYk3Uo6QCSZk3c5ymKeyA==
X-CSE-MsgGUID: w7s/mN4DTYuWvyiTGhYE4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37231800"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="37231800"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 03:13:22 -0800
X-CSE-ConnectionGUID: ltgagVcqRmK1Ga2Z+wfCUQ==
X-CSE-MsgGUID: lEmBSfZxS+qqWU7r+6S5TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93820733"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 03:13:22 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 03:13:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 03:13:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 03:13:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8lQaUQdCWO3WPQg/rgRuayst30bQNSCy4yiZ6EXH35GKsUcphWJThxj+Oag7tYIY9wWLLPk2GROrt+BFhwvYaHfHZbr8bSmqv4yBhC8P/fVQJyZcR5yEuCtNYysdhE84Jw+VxNRAzrzNkZ4EfRDk4VZ7uH+T4EwpkEt8nvXZiVuRJYY3PlUmOLARSSpqxZucg61AFDeCDBayX6aWcaIjL9SoJuwIKk+MJEiNeR8d4jGmvQfWqabLX2PRMxh6o6CGyKowMoLEepDqhy0UITLkaodi9B/zMMPmraB9aldVjOBzWI+Y+mlQaQ6oZPs1+3WgeemdtBGH61Zl7WwLedMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzcbeiEBgAmDRBKaEBihf+p7ADz6iYGWzbaBRAkbYeQ=;
 b=h/dDefQ03z9lcHyvkfGXzBKstOPIDMPXStMNAkRwpqJMesS8GvX1Y8SAKgf4g54uO8RkvaRqPnXURr7NMQLkeqd+pCTHW5E5j94u2zqsHXiisD9Pmli+6dIVHeJNxFgkibQJid1ulQ6/SX8H26TUdGO2d5YiDZUauyiXoIOWdhC7usTDZ5hYmSX6L6PdMuUjPMUz+kiYRwdBR1t6PpXnuZmSWKZyK41AyDoXDkbGcMRfV+l5JXXnT38GspaIplkOtWlmM/XIIPC5bPw8d9dRXP9kjvfltnl5YNMwz6/zlKStzjNDKSFB4XSTbw8RmMbRVunkcbjlD2nvYIgB8sPn6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5229.namprd11.prod.outlook.com (2603:10b6:5:39f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Wed, 4 Dec
 2024 11:13:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 11:13:18 +0000
Date: Wed, 4 Dec 2024 19:13:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Message-ID: <Z1A5QWaTswaQyE3k@intel.com>
References: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
 <Z0+vdVRptHNX5LPo@intel.com>
 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
 <Z0/4wsR2WCwWfZyV@intel.com>
 <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com>
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b51b176-5196-4f12-1e0e-08dd1454a7d8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+bwb9cdXoO9VRGuFJrMXuV2Otz6WEMt2FTlZ/L7zNPUiHr08WaZIzBzJlDS+?=
 =?us-ascii?Q?poX/ah/chEV+BJjE5b9l4xml+qoV0fLdLiPCW7YDvV179fc/vmy6Yj3q1lpU?=
 =?us-ascii?Q?Rh8x+xvUcVK9KBQz7UBKmW4Lds0Jz/5Wj/X+7wd8atF4jUc8PtXaHpQmPdjN?=
 =?us-ascii?Q?cimbdhrf9Kh7CF2VdHyJHsMDMPCk3tCReDFbgSjibGGm4zVNTmAfthmAqV3F?=
 =?us-ascii?Q?ZjbotfrhqLdwREr4BPzV6VWdpTsn9h0iziukiJ0UTCiBxuKoYNjjn6zW7/31?=
 =?us-ascii?Q?dhSQMdFkTvrw5kaSpvObw7IvgfL1Rz1NMEWH0IaVROWBLSsrCPGPTWYSfBg9?=
 =?us-ascii?Q?nsrTsQIUYb7kxZxYNsUo5X95gdXNcK6KcIUzolgqPDafBP/G27M0R7j1zTD9?=
 =?us-ascii?Q?50dEjpkoG6DEerioLxjXeO4M0KrACX2pjpXHPb3shGKy/suGCJDelFDCxop7?=
 =?us-ascii?Q?G4JfntomPD03+XXi8ZhLtpDhDPfp/h4GCU1SLd1Rq6zJb1T0uq5y6jk0xKdX?=
 =?us-ascii?Q?b9zZqMINp4CoacNlhFmcWmGnad1l3zCvJWLqCusNn3BuFYN97GBUJJCfESCg?=
 =?us-ascii?Q?bysF5sjeAFz5GiHG0FtXLHnc9iSGA+upZwdmcSbu3Z+daB68vu7BeIjbUNbZ?=
 =?us-ascii?Q?mkQ9DPeinwWZ2IBj8kyu7wh6Y6dDJifA4ZQKOPXivv4kgYB2uYtpLTOurFq+?=
 =?us-ascii?Q?OVr1R5QcaiGrxAcKtjkX/cPxQvAmZWvI1CEvJid3QYmttODuLYl+aNLXcfdy?=
 =?us-ascii?Q?FxkxUEttbiJZQr1oaCI8c1hVnQua0SUeCqEUy6D6D8m611QUeCsIjsfg13Jd?=
 =?us-ascii?Q?U+zksbWkGOWrtzwWrMG7xlJU6xBgePZJLFTtptdUS3Tqn9U/SqcTdOkLTMF8?=
 =?us-ascii?Q?fhIx/O6KTgkwjYZtmjlUIQBuT/mc1qnlXfYlaPaYl3lzFjFmADirdXQriE6n?=
 =?us-ascii?Q?njzDqfZhz2e1Z6UpQTTIT6RHnwFAsb+1QXxCWbIqAA83pGJslS5nLVbAw/8Z?=
 =?us-ascii?Q?on/3C5wIAD1tIc/mnXyWcRDLGspCWkwPFrHOGOYMebMNSd3pjmT4meHSDecb?=
 =?us-ascii?Q?TgznrgpIbQruROxM/t6ETI/5FZDqb+dByPYjRJo5tinrPqdRCa0n+xuCvnZB?=
 =?us-ascii?Q?Eit7l9yIrymXEWgehUrDe8vvqqonbUhv9+4hoIOU07Sn7hOINt9xx3LsJW2T?=
 =?us-ascii?Q?nQ177yE1GucuzoOm0rs1gNKy+hSflHxeUj6RKQUKPUQdISYfY8XfrxvcxfgY?=
 =?us-ascii?Q?E5oyF3ERV+QXVoS3yX7DRBdr0HQ9hgNoItW9k1h0z9fty7Tvu2dN06iFGfxt?=
 =?us-ascii?Q?BVL2et8PdxW25PCOS95Xa1XdRPgSLnDJHuCo3GASrSWXSw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssYJjm8WKmvJKoGCeqBeAsj90TA4LSYQE+JfoTikop5eo+LpuHbcCmwgKBv8?=
 =?us-ascii?Q?0NGPCYdgA4IDw0PucXDFPSXbYra7PvmN/X0y526a/7n2OALxYN5yf5Y0gUu+?=
 =?us-ascii?Q?PVNA0PgwUoq3wbQhFhNc688HuXr4Mf3L0SGZ6QvcKOhkMMocltbv5A1fz8k9?=
 =?us-ascii?Q?LIB+NnJY2l2XssP3G4KiGw8Aks0zIk+Y1zEfGmjcxP6Q5DO3fdAF9E5ntR1t?=
 =?us-ascii?Q?Oo9SWrI0JDUPiOVRvJJQYfl5mXqnlObulxBQbMi07FAf0kApAStLEySnIAZz?=
 =?us-ascii?Q?1WnqVja1bRnAJGS+siXNWKhu0Jw5kKQnMFLFbIPKUVXCtnJHtqrEKkoi41oU?=
 =?us-ascii?Q?4Ii+dR7Kgh/Zm2qXk+JlP6q4+GzsIIVjIN9WpjdXQJg28xxJziz7JGmua8RX?=
 =?us-ascii?Q?Z5d0OL0ENmTo5YpYkAWotbTHI8AUdOpv+zxIxbhlYkqGaFNd1jsF2jdB2xMI?=
 =?us-ascii?Q?GpGddyBW11S94zSYbiWcjccSvm8T36bYwHTsTWGQ/CcQKHI+noXPz+Gq18/S?=
 =?us-ascii?Q?57dgBQAgovbtxYdCio6A/OvghTq/FnnjrK4Sq00+5rgqL/4KYmYUPkJGB785?=
 =?us-ascii?Q?+QcJnkhDeEklV8OC7Sw6W8SCP6QAuvEXyDFMgI2s0tY44k1M0YSKIFStV2kt?=
 =?us-ascii?Q?0a/vXMK9YP+9S7VXunIH83R1iZAQufZPxE2sGCvhop4vM1lS1Zp8yj6BlBch?=
 =?us-ascii?Q?EcFAWl4jm+UByU3wYlwYulkvwf2AsLD+lnMYqHsRL/+uNrhvKOYdz7N8J+Zv?=
 =?us-ascii?Q?dC2wi0HTk+NchnAid0P52xkHXMZn9w7vu3sgTF2JHZAZ4vpAtUuOrMYAMVN2?=
 =?us-ascii?Q?eGmL/+KdtZcTxaHKug2iJ7+8Xdw/MrtH0aET7YHrTpGRDVzDPMku36vr9saX?=
 =?us-ascii?Q?QwdNV25WIFZJ29QeBx5p12c7npvwJbwSbNB7d2SVTVYMpAw0SsfJYC+cLMLh?=
 =?us-ascii?Q?/G3Z+OOVnG4wW6LrvY6TzXIsvq2E7KakjQPrxdT89vsPdfyys1LIpgRRKBC/?=
 =?us-ascii?Q?k9j5EpWiwWKdfdPoSl0wdZHplkYxBeHDRi7mIZUNE0ginKQ07EJsq7x6wgAa?=
 =?us-ascii?Q?wkkUc/Z9F5DbrG/di3hGSVZZdL7PepP0g7D+yhxRP/Y1EAl9qeOR3nLH1m1G?=
 =?us-ascii?Q?1S6z7V2+EH12M9qCOqiAQpIFK9Iitdw7cFmvNx+3sHh4lovR/z1QnEtb5qZS?=
 =?us-ascii?Q?FRbVl+sOUVCOAPnHbl4XelEm/UN5o/01EjbQQLolj6DnB4gFAOPhNaKsCgBb?=
 =?us-ascii?Q?OueaRkWPef5V4VnCHshuuJdrojHc4FH27kP9AEQvu1P9VCZzTRqcU4w45rrT?=
 =?us-ascii?Q?uEl2Ikc+aoQSq7N6+pl+akr5d179AhsI1nn+2VrfVNZAsl2Qp6UEiv6NpGtq?=
 =?us-ascii?Q?gisJZHB6noRxuYW7whG05eSoM1Qk+HPXdfGyaV1UxnghypGEIJ+vxk2nd3EI?=
 =?us-ascii?Q?Hi84c2lQNKT0hIzvtzdESb8Nlk5VGNSryvs/c1bRCC3fF1BwlORnwlgIHndb?=
 =?us-ascii?Q?7Ll9lAGT3fplkJ7xHIwo9R/MFYvpJX+DC0m9ZxmhcqSnR/uvfSrX/+c/tBFh?=
 =?us-ascii?Q?OFW0uzqGF2Cb5k+0IAD3QsG1/rD011Bx6445lmrQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b51b176-5196-4f12-1e0e-08dd1454a7d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 11:13:18.4175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3t7Zs6HIwxmVmlfNS0+bx1tm0rfaZFKBcJ4vFOm2WnVnMTZAXVTiMAXv5/J3YFLjTpB7+2U0pB/mhEsAVJh1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5229
X-OriginatorOrg: intel.com

On Wed, Dec 04, 2024 at 08:57:23AM +0200, Adrian Hunter wrote:
>On 4/12/24 08:37, Chao Gao wrote:
>> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>>> On 4/12/24 03:25, Chao Gao wrote:
>>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>>> +
>>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>> +	       (entry->ebx & TDX_FEATURE_TSX);
>>>>> +}
>>>>> +
>>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>>>>> +}
>>>>> +
>>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>>> +}
>>>>> +
>>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>>> +}
>>>>> +
>>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	if (has_tsx(entry))
>>>>> +		clear_tsx(entry);
>>>>> +
>>>>> +	if (has_waitpkg(entry))
>>>>> +		clear_waitpkg(entry);
>>>>> +}
>>>>> +
>>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>>> +{
>>>>> +	return has_tsx(entry) || has_waitpkg(entry);
>>>>> +}
>>>>
>>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>>> ensures that unconfigurable bits are not set by userspace.
>>>
>>> Aren't they configurable?
>> 
>> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
>> so they are not configurable from a userspace perspective. Did I miss anything?
>> KVM should check user inputs against its adjusted configurable bitmap, right?
>
>Maybe I misunderstand but we rely on the TDX module to reject
>invalid configuration.  We don't check exactly what is configurable
>for the TDX Module.

Ok, this is what I missed. I thought KVM validated user input and masked
out all unsupported features. sorry for this.

>
>TSX and WAITPKG are not invalid for the TDX Module, but KVM
>must either support them by restoring their MSRs, or disallow
>them.  This patch disallows them for now.

Yes. I agree. what if a new feature (supported by a future TDX module) also
needs KVM to restore some MSRs? current KVM will allow it to be exposed (since
only TSX/WAITPKG are checked); then some MSRs may get corrupted. I may think
this is not a good design. Current KVM should work with future TDX modules.

