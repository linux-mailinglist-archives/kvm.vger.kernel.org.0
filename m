Return-Path: <kvm+bounces-56252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9B2B3B37D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EADA189DC9F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DBB2517AA;
	Fri, 29 Aug 2025 06:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E53pyrs/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD0724887E;
	Fri, 29 Aug 2025 06:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756449256; cv=fail; b=MvywHEssuv3rPbFN+oB8J+09peOtDrx3eobjT1Qz1davHq5CZx5gp4W42rMoBEPxxuVHRLkV26ovngpJJxYDNfz43/c443ARyupDwYEdIP77KQPyM0L9o2PaQ39HsyJ4BdmlTFiTpnNMfxMc+4WqN1cMMZH8F8+7f8Qohn73e44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756449256; c=relaxed/simple;
	bh=orKYjbZYXcfVeL9ex5NaxxELc1AxR3EVhC0YyLjXPYI=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fJvCa5lveyBUp+vBAY/YvWc05IHE1T6eUo7jE6t75y/wnYfuvBH9BnV0zRhQ5c9uGVW552ALSe1b2xmBn7L1i0nfv+unM+SezCN7YCRhIvsvLdgOw8+Sty6CiAM1aM+LQynE544o2L1lGG4XW2+kLreYH+df4AdYHJLJo9xKRxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E53pyrs/; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756449254; x=1787985254;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=orKYjbZYXcfVeL9ex5NaxxELc1AxR3EVhC0YyLjXPYI=;
  b=E53pyrs/ljvsMj0f994MlZbq69GIdAPX8Hox0pkSXvwKFxRlGgNkOPmS
   TcsSkO0QHnk/cd6rp8KVJJRtupZl8okuGVkGNf0Odz6AeC9zeDqBDYS7V
   j5BmlC1Hsn7tJAi1CDVvyoD0nvYM2eUfKs5d6GYRqqTNK/x9e2YbEmGWD
   oc0YOQphHTyXt4wqpUTsBkpmXy3V3DI7TsKmMvcNouWf7iYFJJValDh4G
   PKjoyUfmcYVqn5aoO2hy5q7Z7IhOhPCxvmMUGQyNzFJ+0IllY+sqKzWiS
   vGiTc5IY0pf6Acopiy1opmU1NMFyjEcC0niCJLTNwJ54GISA9SiHzo4Ox
   Q==;
X-CSE-ConnectionGUID: 1p3GOpOXTDyIW+3XFI0XbA==
X-CSE-MsgGUID: kk5Kj4CTTOSruJWyW8WlKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81322358"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81322358"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:34:14 -0700
X-CSE-ConnectionGUID: wML9at+fSMK4qXN4DentRw==
X-CSE-MsgGUID: zmlgHRZ3Sd+KVtgAvbFwDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175589157"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:34:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:34:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 23:34:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.82)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cH/AuW0OY4yitxd5wWoO01SLVX/kcqE6Pe8q+SVnzQQtE+tH/M30h3RQLZuD0pppAh1HKL3DEse8F8Hdg87l1KoujeZKU8ozYFHzTzEo4z7vkMfZRHuDZzHqP+L0dSlSHH8x8tI47nBq/74z4J7YApoJWbRIqvYNF1HeNpjx22w37Ga8zZ+pB+PWPbpw6RmF18aO0wBN9+R+nzDd/aJKHSvekIqUyheu1uSu0rXgRhVaCzQB8XHoDNBi9FdnCNtZCW/Uo9Gq8etSIDDXMTp55v+uxcrWsV17qyNDhYCketdyU8ZpXfqTsiUf1Ru+GXwVluGkcIEjC/yBJghuEohiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVO4xGhz+C75HQQBVVthw9pUPasGueBVT424YeleCFY=;
 b=VdyHsPcnB2YbvtW6mthnGNJVuC2yep2F2KTzl+OJgZNIFuNGz3u25veQ9HXsnszfg+3+5GBc/5pDjSaJapmGCXv/4t2+/i3h3qO1QYP1Yw3q6KspucWOlgAendQSgx4yXrr1mGj7w+D9ZiNSwVza5GfHTnHMoj7Y6xr47IjkgpJeLBebbCVzrCUTOycQliQNlUU7+8dQULizTXJmv/WWNHoBSMu/IDI7wxBotffSRBnKBF5ySMBnMZCWZJBnJdw8TeCsr0IfXUSPz2Oat6o1xwi6PWPSl5Cbkh+0SlwAnugPIHhU1OkjHfQKSQIfNLQE3F0jULxcuuhR/zZjlKPpkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB8825.namprd11.prod.outlook.com (2603:10b6:8:255::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Fri, 29 Aug 2025 06:34:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 06:34:04 +0000
Date: Fri, 29 Aug 2025 14:33:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Michael Roth <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aLFJqjszMURItUe1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
 <aLERAeUmk2J2UG2o@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLERAeUmk2J2UG2o@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB8825:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec9930f-5f5a-49fa-eb0f-08dde6c60c54
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C4Mylybx4wH0pFQpXDtzLhZ9RiEoPKa+YvzFtBS36HnuBpFXkOTd8PlRO9yQ?=
 =?us-ascii?Q?MaGEvH0+lv6VCdT4YMSDwpUYGhI1iT9OaxYy6xLQUoWaQMQceYaawe3+MBrl?=
 =?us-ascii?Q?2tF1gTFBJ1AipNSwNbo1Ubbv2ea6WdUxIv04y4jOXxD07zmwRQ82a7I9EmD+?=
 =?us-ascii?Q?wqRyBf8L39YD32SjzFkr0vdUXd3fQ9Auo6yJVYnbTqvCVAWwcfKZtturadr1?=
 =?us-ascii?Q?CT0udyRzdYjtgXpThZf0OfZ/PzRaxjsOa2+ewAI35z6gNevtWzPkuAKSohZ0?=
 =?us-ascii?Q?obmcRxoNzPHp5AHY3nx03vpoPwDX4QnQtHXWrM+kd6RajPcJVX2Gig/6lQTF?=
 =?us-ascii?Q?nqNgMfXmwlrxrBTqE2WkcDrjXY8anLjhOj6x/R7p1Q/9CPTMT3zu3uxAfWdn?=
 =?us-ascii?Q?j9SmPS0/fWRfsyy71FGQfN8jLSpy4ArY8Nf8zTqI4dPGEsLbwK34kk8HSYwZ?=
 =?us-ascii?Q?14nA+9jyqtHxuESEs9GKa+fNs1GRwBqP1qpFgWF+pNHIE1DbgBNiUlbr+x56?=
 =?us-ascii?Q?Ts0RKz1Iv8p1uFMphPTApyk7gxV/Rf98YkTn2S4VKHian0PiW+24BxrFDp6H?=
 =?us-ascii?Q?31XTD4VT/LxusSmx5TSv1UP0cFRYj/lSGJ98NkwVW7cX2TbHKGukh/3KqxQw?=
 =?us-ascii?Q?U4nnu/8fwegiGZYrGicxznHw6GX5R5WVw8cewO8Pyu61BtGpiwgRlQ/ikWus?=
 =?us-ascii?Q?Y/O+87aaqk7fmGwdHHikPosehYYeSiWJDSQLrZu1t85rCs6exVMuV8x1DkmV?=
 =?us-ascii?Q?Ann92FSEm3+I0rvI51oOSJxUx8AUtL+ZRyqUOOFmmKnFpucnuFQ5Dn+wLMZk?=
 =?us-ascii?Q?FIKNIEdemWsMTNAza/vo3xBnS5V048a428NYoN8OYuC6MaG3WKQbZXtuScpc?=
 =?us-ascii?Q?ThGie3moKvYPbsahNKhUgOOYXcLtsVUh93Y6cG/MsblXomEDJY+7QLZunIFW?=
 =?us-ascii?Q?/UNMoOeTzC1mUIGdZ8sqXqmfwtDL2+lw0JccmdU5QlAOejKp8RSgAJu/ZaH6?=
 =?us-ascii?Q?5mX0A6cgrowlug2IQ4w9Cv8KNotO4OL0jj43wUonjW9l7ybGVYVaAp0WE6QT?=
 =?us-ascii?Q?JFBw2tEDbeizWmWvR9GCx084C+KqgxB9KeqqA8E912OZn6HdijH1762fQaJE?=
 =?us-ascii?Q?zU9Wc66DeVPn3fPqbJO2+Z/y45tyUMphFXQBcsq0WqHpAywC9jbaNlB787Qt?=
 =?us-ascii?Q?PtxLYCWgnDwhQlRx42aVQd2VPRAZRS7yJ2m5lMjUhA/kUBAPmxtwNw6JCegx?=
 =?us-ascii?Q?KVndxKKWwdzsMnLFovxSZKFR6hcKNoUM9HVleSZ1zZuLWf0+18PkoSQZi6Uo?=
 =?us-ascii?Q?NePMKtycnq0n2n4T9B1sItLRgqKaAS49CFMCa5XTosXczOiBO9yqtCKa2ztO?=
 =?us-ascii?Q?NRIjbYClHjqZ5Kqp6WAnn7Khrm0gO2OVeWnSS+1FQIF0koPiWV9Tg8Att7CM?=
 =?us-ascii?Q?Ugt4Q+q1bx8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+MrJaSoA/QYGiQ7LODepAZiDivqfF4xKcVIu1jHTDHwlWu7/DyKxbA1PvSPP?=
 =?us-ascii?Q?vCJONaC/ZfjaKfMJVLUE3qz+h+TP00nAQXkwzc4DIXZet1adbiAEt9n6RSwh?=
 =?us-ascii?Q?v4Jgez02Q21mDLZD4d7FeckvDkYEHhyBKfPG9XjoaqxWx/Py029oGVCfxctc?=
 =?us-ascii?Q?A+C/ei/yX3E0lr5p9s+VVNGWsDM58k3rmFy/6fk6hWVDL112Dsd58HmUUqqj?=
 =?us-ascii?Q?v0HK7HncfXorI7PLLRiu1RStRCjvhZqFDoe8UA1yUpx2JsnD6uFAWRm9bZOi?=
 =?us-ascii?Q?xKJdqXovtHHeUGzX1cKB3nc/NTEJ0xBL3rAhzXNzlnRKxbIb/8qzB2ENxSPi?=
 =?us-ascii?Q?2X0pI/DbReO/v5jEouH0aC1SoRShsBFvHCxZxTYFon6/+vEz7+5P3IPWub01?=
 =?us-ascii?Q?jlct+lTi0sqIhAwygP/XqtAqaJnAAEnrqsKzgpaF/kr1CpQY8O/J9Cw41aYe?=
 =?us-ascii?Q?eyixOdpfsro2AkCe7INUOqHcvNW27mr3rCr2burck//8fDmrpXObeZTGKTqJ?=
 =?us-ascii?Q?PRMeUPbCAjtk+EU14F+9qzCDbNwTLWwAnYzFbEuJvqUsZSlaJquyBvkoWuM+?=
 =?us-ascii?Q?P/jLSRgGVEXENqB0JXdmfus0pwFo247c5lKdYM6pt4q3K2gDG+NEqf6/6h92?=
 =?us-ascii?Q?9JkP9GOLECFL9EfgHc/soCLmd30mRX4PDb3VNulv2ksPureYWFWuR63QwBt4?=
 =?us-ascii?Q?GgWKiMeUnQoIPRytUPvFCAmVi7EqdSrK7vpdN1uER+pdLrym5WINx7gBORoa?=
 =?us-ascii?Q?nAxCaNAVdeJzhkrukd7J+Baz6Ys3U/UBoG+NHmMr+3E2/ZeOr77+c3UWr9cq?=
 =?us-ascii?Q?2NfqDqsDc4GPPdU7btm5r/CTKr/VPJHAdnFqvfK3o8I/00efm5w1Hn3fpE4l?=
 =?us-ascii?Q?B4GyEIBCxnYOd4T0r15Gmh6pl3Xu005mCapJH741zJLaZsv7nh42LGPlz6aN?=
 =?us-ascii?Q?0pZPTZ5PV+arsrsSuRURuWi6noFcXq85uRulQepC8tMTSfW1ylFVUsWAtxcM?=
 =?us-ascii?Q?T16k1DMaFxyHJ5qkXRI/zAPImxFYmTkvb8taFhx3fGlTCyXj38eBRWpEyYZw?=
 =?us-ascii?Q?LWHrt5YLXrF9RKD+Jp2QbxTe61GSUYAat6YDaG060dbTLrpAbGeY8GIZknfs?=
 =?us-ascii?Q?vc8gt9Y1xoKIvWRyto1FQmzZoK22CiH/vWi2Ft8cGTEzjPoVRCWFTvcnFHH5?=
 =?us-ascii?Q?ubgQ+7lgy8dffpFg5ojJgzaRv6nNUhBWnCRy4vtW1ohe5V6ns14yzI9s+d1o?=
 =?us-ascii?Q?VbgHbP2S4nYl1nVOzcCzP1hHO6jV0DqwU3mbkcwkrVylrt1jSOLcR+xngvEM?=
 =?us-ascii?Q?dn0KFFGsZ9TwgpNaApmVjiAhIbPIgOCuQuYdr+4aI0L282TDXW3BS6ndJ0Ss?=
 =?us-ascii?Q?MkDZv8S/AHRBpHxFOm0UR+W/747AKrJ8unE10XKWZteIPYJTVuDvC02vahly?=
 =?us-ascii?Q?Z3KUC8CQ9BU5SITBwxWhlBH+RqhesB1gEmMPkfzBw3/h3aKlIplDDoDcukKf?=
 =?us-ascii?Q?gEULrRWa3CIpOTHFJiw6/zyMc0wJf3eTMPzdIVCUewJJZ0Iv7mobfI71XQXX?=
 =?us-ascii?Q?VgIbklZTUhmaw+hn5P+QMfcXoMlXAWPNMhmzdbyJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec9930f-5f5a-49fa-eb0f-08dde6c60c54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 06:34:04.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8Zuab+GArRe+CwcwOk2QcvmUtiNP0bkOXfO1+YeB1gJn39VgA0cmKh08hbTzdY+iLq8QHPsz0FckuXmorcvwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8825
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 10:31:29AM +0800, Yan Zhao wrote:
> On Thu, Aug 28, 2025 at 10:00:28AM -0700, Sean Christopherson wrote:
> > On Thu, Aug 28, 2025, Yan Zhao wrote:
> > > On Wed, Aug 27, 2025 at 12:08:27PM -0700, Sean Christopherson wrote:
> > > > On Wed, Aug 27, 2025, Yan Zhao wrote:
> > > > > On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
... 
> > > > Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
> > > We don't. It returns -EBUSY or -EIO immediately.
> > 
> > But that _is_ tolerating failure, in the sense that KVM doesn't prevent further
> > actions on the VM.  Tolerating failure is fine in general, but in this case it
> > leaves the MMU is left in a half-baked state.
Yes, but nr_premapped will not be decreased on tdh_mem_page_add() failure.

So we rely on nr_premapped to disallow the TD from running eventually.

