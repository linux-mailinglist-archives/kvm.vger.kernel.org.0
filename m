Return-Path: <kvm+bounces-58510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B90B949B6
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57B0348048D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C70930FC06;
	Tue, 23 Sep 2025 06:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HauUNVJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E332737E1;
	Tue, 23 Sep 2025 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758610010; cv=fail; b=qDmfYM0OqlzkaH9eDuK0lsblzQT1nL5XbGF4BJVF/5oRBJverORVR2oNyHZ9/7s5c2/CdYPUCcZgHOxn0NSE1Ch3xVtFxpZkTdU1uauLNUFHuk+ENaUymK9Knjp2WcyojBRHLo5xuCSEGM6VqVXCZRPPDajAHa2gC9+0XcLFKTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758610010; c=relaxed/simple;
	bh=RLK6am3BoHq3lrvPnHp2dl+CiG9gGjgekLl8cp+MbG4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=maPuzeD5KCUUPOFIc6m37e+a7S828iyhsXUBLiJmvL9OD72j1C6b8/HQ2pyQc+pcDetSXKqoVekS1ybK6Xs92MX2cT9bEHOCFBB6BCy8Gh45RDaki/PT7KOamjTFkT+Ecs7nL5lsA9Upu5cEIdBVbHVmbAjrKBqkd/PKVv8Ajw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HauUNVJ3; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758610008; x=1790146008;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RLK6am3BoHq3lrvPnHp2dl+CiG9gGjgekLl8cp+MbG4=;
  b=HauUNVJ3APoNiaMOqsVFAJE0v8/1yd4yinNJfu8TOQSrCOm9kUF9leVt
   PoKObYaLqz1UIdoZcBrbzzbrDpCJXpQmmoQK26dh+QRa/hsfiJLjQkTo4
   v1SwenIBU5ApRzsGd97c3+cReoLU3Kt0QB4OKnf/uhGD0iBzeiICejrCb
   08YQNzSBo3RnnqrV39Pf9SbgyTORCa7tgyVR6hpfrmaM9kJ0RJ7pgk5L8
   Jvarqzo4mi5J0pIB8hriWlsE2Urf+j3qwjCOHBUer4UkCwhm+ladrFhuc
   ApXQwsGxL1FFQ8UPKqP3pLg0YLNy4POuCuXq7cJ5hunzBtX0eYomdjPRk
   Q==;
X-CSE-ConnectionGUID: DoqvVJUoS0WDDp2I3FTdgw==
X-CSE-MsgGUID: mq/tWKwLTyaeKf4+xBo77g==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60806013"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="60806013"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:46:46 -0700
X-CSE-ConnectionGUID: IWrIZ7WwQP2U7OdUMy8wrA==
X-CSE-MsgGUID: WA7GRhKfSXKaL+SPkoh0xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="181950083"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:46:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:46:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 23:46:45 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDIgvQlIZBNmC33wxW3VkhX/If+2rGsBxSlxGswHq/4fAdIe0AhMq89DTGOfyt4e93lsKbJVCFpwztjk3CXufcOCk8nMBYxY2M1qzm6WKw/JLIJvDrWKxsO06kWus9quM4Y4Mmi6t/hs84GTlIV/lCeIcHUxEntOzxRDE4h5whaugpCI4y4wHaRqJNF0BrHQPINi/Sy92Xkwst0M90Dfdk7QdGnJSgdUxVGP7nHDXDSdn2FnW8uY1C993bpfS5nxKJYpzV86VdFL+0xYJltCMlugiMjEfoFCRJ9NqK0/8DIFW4n6pfDGuC2J6m8Mh22MhRd8CBtnVou5UTVBAe7pRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJXIpdrhfQtS3NkcXOliSyaHtxcoL550cFWo4VMO0pc=;
 b=Wrqe6Rpue4E2Ak45B1o/h4FkBrwNVPRM/eP/4kzMwEgaB/XAudAL/tAKzNlK6NFcUPmuzXjj0vjr3R1fupp8Rjl9d2K3eBm1TUX9Nu3CEHc0Tg2J7OstQRFYDZFzbophhQH5TFQRF2M+wPDzoJA26C+q8VEv1o3bvVgbI7El3R772dOI9YUHacIcG7lPe6zu7rtpcT/RS2c8JLvQk9FvzdJCH8sLam7I7wOjWsxEUtRK9NxZQiHLJM3SmoGugmhDjSkZI5xZT/mype1EqOvN5xBeCImjl1HRJL24cfDEJsZo+hSS3k9oauYE+9GAzgLgOHicDih3C4UjmGBM2tXOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 06:46:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 06:46:23 +0000
Date: Tue, 23 Sep 2025 14:46:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 50/51] KVM: selftests: Verify MSRs are (not) in
 save/restore list when (un)supported
Message-ID: <aNJCNMGLIIVlyC/p@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-51-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-51-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0232.apcprd06.prod.outlook.com
 (2603:1096:4:ac::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4874:EE_
X-MS-Office365-Filtering-Correlation-Id: 318c119f-1b45-423a-809f-08ddfa6ce95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kYRzDT23YtpmQqhO5tNcHRtFMjXlvCaL0lhJNZk70I/eSz3vIJkwf41zRU2o?=
 =?us-ascii?Q?HKAzlh5XLL+IdSZxKLZkb3ii2KtNKMsS3iB1cpfzEYOo9rdTNmG5aIyVp1qW?=
 =?us-ascii?Q?YNsGj7xZ1pIdYt27c+K2e29e1b8KWS0zyRft8aw3snT20uTlctyNkQ0o2yOi?=
 =?us-ascii?Q?FnQM6wELRr7LQbt7p1/XO67RMTXPt7qtI++QvGJHZap1IT8Ip1zVv7fTExlu?=
 =?us-ascii?Q?Q5Ckd+JoYqslRGr8k90KH4LBlzqxsfImSssazJXZRve0qt7rdugGt3KcXWee?=
 =?us-ascii?Q?8V4yIzE3Sa86FW2Z5lgTUOWor5UkGKuew648kubjA2P4janOpAQQ/MTCkBBT?=
 =?us-ascii?Q?XWFEHYe6NNlodw6jfdtFl4cSjPWxBdIFYqRTUUsZJ7uNjfZSf1fJVLIWr9I+?=
 =?us-ascii?Q?YTN01LXmi6Jze+zOM3Wp/4LAQzHtcKzWfjK8/4sgZ9l9ARSnyN4pAokrW1Wg?=
 =?us-ascii?Q?fO58oJgGVwJJtESVubnmgBU5tinxTE+aXVnEEanUu9/kf9Apr7u4lSvjtW2q?=
 =?us-ascii?Q?aZoIgK2fCpoWfUwKxDqSIk45sb3zGiSIBjkAXX9tdnPua5R5G15aluce1hmu?=
 =?us-ascii?Q?accCx+u/8NfjVyxrO4RYnqt5Je42S4gl6ZwxNStLidCB/m4iUtI+z0uha28B?=
 =?us-ascii?Q?2U/V6TVm9yIYV9T0e4Sm2lQX4xQrBU63xGkoycW2HeDLJcjo9164rxr/LCtS?=
 =?us-ascii?Q?uXB3QRUCvUKvWs7jiZyyj5OdvIzxS9VHVmejdMsoZcu4wg0xTAv8eim82c1y?=
 =?us-ascii?Q?gXkvUWNv86PmtNwC1IBkItBILaLj363MgRcu8PrIVgMQf3lyLBYdinqAjt7i?=
 =?us-ascii?Q?wEfthJVAVSJPiJk0VNyvxLH5DQDKb+sGUAOlXecp4cMr2g1gsvlJ7RIuyfvX?=
 =?us-ascii?Q?/j98HA1w/GS2d2SpPz4DtYkUrxJ8SK/8v1CT1KY7eRJhkqHu7e1QnA9jKLu6?=
 =?us-ascii?Q?IDwxxiZdZ2jSdXNCnYpbFAoF2AhWPojURYfM4lMgsHgdzvOH3HxldnGD90Q4?=
 =?us-ascii?Q?8/hVYhtLMpnXh+/Ldmlr0aALSJXfQT8tL5FJj1hwM9/PFAHNdkP9sPEz7s1L?=
 =?us-ascii?Q?UcpLN3QLe8X1egZRXZzgJ9DBzdxf0W9htWzg56NgU4MbmjjfM8urUJwtkp8p?=
 =?us-ascii?Q?bzSpMQcyaiFI+kQtAIN4pVtvr5jIeCGH5E5gMJnADjmKoXjo5gc+LtQD4B8T?=
 =?us-ascii?Q?stRf2fF4F9jbwYlRU+XIkKrlz5sY3IUHSPnuRvpEmZJT9vxk59C6PQOCPi+E?=
 =?us-ascii?Q?QMzRp6tQb98WRpewz/o/zysYNx8eqs/daMzZ/ipwEngRUnNB1Oyb11hKkR+y?=
 =?us-ascii?Q?z254hci/BAQ6hO2SZQqdKq9wTVExSJvmryHy5ujWAYrnlBU4eDP+SV3WeC35?=
 =?us-ascii?Q?KWWXQqF5fRyeNbBP4Q9BTXOrHGE70KoQtw10N9HM6DHgxBq+zEElNIfUunIe?=
 =?us-ascii?Q?v++cYC+w/Uk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+a+zJPD6ZCjOupZ+kLpUTx10JIQ+RJNd2Ld2Aq6M5atInVTRNmR2nq8Gours?=
 =?us-ascii?Q?84c8g30VUmLDgtwS9BJ8k0xNdzGrVmbnablb/4krzRy4yB3wi8YT/tmObKct?=
 =?us-ascii?Q?O+TqjIi9naMznKrsFr2fMKU3W/m/KCadjlrKnFDK3qMuxhvjpaubPrlA2OK0?=
 =?us-ascii?Q?0dMEg+DsBxe5L86fR28l1FtERGhq504NEsZJfKBfiNJdGB40gutNswhBqpsx?=
 =?us-ascii?Q?FybAy1OvoIwqf+8qzXN4knkGQfVgWX81obrQcbvhcEk/ViFV7AxJfKsaUeTM?=
 =?us-ascii?Q?qnz5rPsg3xtN7je4FfzAJxLg8jjQuoVwyx9xHYPOF3M+ThRariQNuHzJCHDL?=
 =?us-ascii?Q?JHTPiIVhpb4izfaB8Mecgl5padmG4QnOnWasgk1wUIXHXraUyCwU578Qcp90?=
 =?us-ascii?Q?HIk2Z+gn93dGsZ4lzu63FqdgVUH/c2TQlqRb3wYJeqw5bWH79u8tZ1fOQWSX?=
 =?us-ascii?Q?KRmOoQfMcPfHjJIbescYd92aJlykTetlAa5EwX+Bgm+G2XEXFeuwQ5xxsIaA?=
 =?us-ascii?Q?oPmwNb3iqqEjDQTvPbK1I7WcFh4iv3ytgnAGpZ+Oa9zQeYRau39Ug8BCcNnq?=
 =?us-ascii?Q?jdNhjjPaPqaQZg61b9FcW0JnbI9kQmoE8tuwE4Yya+OT3lSejvSRcU9zh881?=
 =?us-ascii?Q?adh14vnyoULfmKuAO6DqXdfe96TZNtPDsXTffefjjS6BmwPS8g6qMzaC6dDU?=
 =?us-ascii?Q?TvJVHJ9DldbegO6fFxWDYX57NHXA14cEc316Z2AKUPWKMgyy424BzRgRYLd1?=
 =?us-ascii?Q?GyCNKAOHGrX+cIx7JiBjb50KmtccS1Ir77y+MWO5KpSmYq9oxrWs0kNB3zrO?=
 =?us-ascii?Q?v8MpLI2CGWG5DteMEORSdwAaTR8bFRg5r6dU/TIXms8q5eMUqjHSFl75PPAO?=
 =?us-ascii?Q?XKGcsMr4abyJMtt4yBeSl3PnEQ+BN1IxuQyQR7mg9eBstTe0hqCi408tq1D+?=
 =?us-ascii?Q?/9pXxzBdID7uOa5hjuRrS5V3FqJpItaVJj6g2ohoCLCHTSOsawPbJiFDn571?=
 =?us-ascii?Q?YzU96Wdm30l6j0360yq2hLb78eV9ZQD7HhV/yeCWgXSxnJnMIhvdg4rAk5dT?=
 =?us-ascii?Q?TwUhqX/6xhOeYsRGf/BT/3cPHzioufdaaag1GaW3SvBwAjVWoSgATy7aQW3b?=
 =?us-ascii?Q?PpNaouz7r04wMZUNXaLZspDFrrs1I/oaqHJPOBVlzrq+UDWndcjt5Ryv4wwL?=
 =?us-ascii?Q?YzuhTGxqVYgNk3sDFPSMRrTJuU7NbpkDEqw8ZzVjISfC11uRexLb27AWoX3z?=
 =?us-ascii?Q?dWMwaDpDmsWuBk/z7e8y5TKMUEVBgYjYcsOMP5mA/impYpurEIKBS7NfM0zT?=
 =?us-ascii?Q?UOLw2nCGXn0XRN2UdyWc471JDPXlYpV5wFHaxrWSTVmPKRJ79dI9rPzyRXxy?=
 =?us-ascii?Q?MGvoIbFaaxq92tZO8PKkNjS8uec5pUXSwOYjZIHdBZ/cv8ZG3ni1yfrlxO9Z?=
 =?us-ascii?Q?C78eFE7780lEiT4LKmaaY+zKpEzd5j1cAKBl4Lmt//LJMcGGiABPBW8OG2FM?=
 =?us-ascii?Q?i+X3FybgHKrH1byNIhgEqIlvhWKdmWQQzUmS31MF0TjFe/XnnkxnGIc97FKo?=
 =?us-ascii?Q?6cXGZ67aQWgVR+xzK4gA/kRZERbnx7itmC7TLJEe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 318c119f-1b45-423a-809f-08ddfa6ce95d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 06:46:23.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFHup1HWEZCt5f6DOs0heXm3xhZAyNdULCmniqA6ZdZqreIkLdWn2H5YRdicLTTpIMHAcR1iQsyP66olXVEmwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4874
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:57PM -0700, Sean Christopherson wrote:
>Add a check in the MSRs test to verify that KVM's reported support for
>MSRs with feature bits is consistent between KVM's MSR save/restore lists
>and KVM's supported CPUID.
>

>To deal with Intel's wonderful decision to bundle IBT and SHSTK under CET,
>track the "second" feature to avoid false failures when running on a CPU
>with only one of IBT or SHSTK.

is this paragraph related to this patch? the tracking is done in a previous
patch instead of this patch. So maybe just drop this paragraph.

>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> tools/testing/selftests/kvm/x86/msrs_test.c | 22 ++++++++++++++++++++-
> 1 file changed, 21 insertions(+), 1 deletion(-)
>
>diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
>index 7c6d846e42dd..91dc66bfdac2 100644
>--- a/tools/testing/selftests/kvm/x86/msrs_test.c
>+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
>@@ -437,12 +437,32 @@ static void test_msrs(void)
> 	}
> 
> 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
>-		if (msrs[idx].is_kvm_defined) {
>+		struct kvm_msr *msr = &msrs[idx];
>+
>+		if (msr->is_kvm_defined) {
> 			for (i = 0; i < NR_VCPUS; i++)
> 				host_test_kvm_reg(vcpus[i]);
> 			continue;
> 		}
> 
>+		/*
>+		 * Verify KVM_GET_SUPPORTED_CPUID and KVM_GET_MSR_INDEX_LIST
>+		 * are consistent with respect to MSRs whose existence is
>+		 * enumerated via CPUID.  Note, using LM as a dummy feature
>+		 * is a-ok here as well, as all MSRs that abuse LM should be
>+		 * unconditionally reported in the save/restore list (and

I am not sure why LM is mentioned here. Is it a leftover from one of your
previous attempts?

>+		 * selftests are 64-bit only).  Note #2, skip the check for
>+		 * FS/GS.base MSRs, as they aren't reported in the save/restore
>+		 * list since their state is managed via SREGS.
>+		 */
>+		TEST_ASSERT(msr->index == MSR_FS_BASE || msr->index == MSR_GS_BASE ||
>+			    kvm_msr_is_in_save_restore_list(msr->index) ==
>+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)),
>+			    "%s %s save/restore list, but %s according to CPUID", msr->name,

				  ^ an "in" is missing here.

The code change looks good. So,

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+			    kvm_msr_is_in_save_restore_list(msr->index) ? "is" : "isn't",
>+			    (kvm_cpu_has(msr->feature) || kvm_cpu_has(msr->feature2)) ?
>+			    "supported" : "unsupported");
>+
> 		sync_global_to_guest(vm, idx);
> 
> 		vcpus_run(vcpus, NR_VCPUS);
>-- 
>2.51.0.470.ga7dc726c21-goog
>

