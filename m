Return-Path: <kvm+bounces-45180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BC5AA65BD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 198D17A9AF2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06950261586;
	Thu,  1 May 2025 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7esq3X3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502E1DD0EF;
	Thu,  1 May 2025 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746135836; cv=fail; b=FEaqkXSYM0vsV0Av5z5WHO4yAUa+Els6cTgf4QEm84hpsTvK7wpkJ285jyNNTyEPWeSx9mif5JYTvNpd4FvpU06CeXtWXBzR/xXcG801r7e3GelQdDx0YdbWvapWik5EopSmneofN0cJVQPOWxwRq5naetVaRScstBh0VPDefPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746135836; c=relaxed/simple;
	bh=tNPlpEvGNeWWDRIY8omhBaBO+4fTjwBolIQ7Ol+hlsw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gLYnEXnht52ZNP1NnzTBjA5iI1FGtvsW1ouk1xNig55hDyS6gEBhVHyiV+HQqCZAp7Wran+40ut94p2fr90wYCLPcpuQBdwUZeDRbHkeGTi+MM+ebtAB3sE2Ljq7QGl8cXBA+EBFyfOF40Zq/ofwqH4DaW9v9EblLpOUpwn2Q5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7esq3X3; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746135835; x=1777671835;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tNPlpEvGNeWWDRIY8omhBaBO+4fTjwBolIQ7Ol+hlsw=;
  b=m7esq3X31R082HT1NrAtGHYVaMFAmdddKINbua1dY35XQjMATJDbxG/0
   6DTThDZT7rpzVHM4ShCShd/A/y193QQuJEXPBzPHjjkklFF1KbVNg8343
   7IG1DayWiLik4g7NdzgBRSO23UEhZGiZKY47BY1CHZnERfpBo3ebvtOM5
   s9YJxvY52j3mjMqKuQ8i1hL/NkgTKXUmP3HL0c2e+geKm70wjW9I0jowX
   Lt6ULS4snldpRpXtcwE3Tcdm2+KtTQ13KMwsMpV5MTFCU7bdo8wKxC2wf
   qA3efVnvtsdcZP13OrMgJC3mWTNEmEKkJt5Ys4tEzvrhDsAUVb/Key3Kk
   w==;
X-CSE-ConnectionGUID: N6ODusTsQEKtwM/4Pmv+hg==
X-CSE-MsgGUID: Xr28UWDuRDqgyI52HJBrww==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="47959086"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="47959086"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:43:52 -0700
X-CSE-ConnectionGUID: 6WZeauvlQVK3/3pck0PlEQ==
X-CSE-MsgGUID: VyXeRhzXSWGWlVeBWpHcKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="134796280"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:43:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 14:43:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 14:43:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 14:43:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kc7w189rZxqOjlnIewIdUR8U66LCyLNIXRgpJy7C/pYKBwbACYXxYTcSA4gl/ocfKM8hRy1mAAHRi6JIZKciZOBTeaBopxP+3SU6Wb4x9E7Wl4B8FLY6/dBOb2+Kr8Ee1pqVnE3+J3v8czH04NmEUTdMlnIVLRQYjtL1v82R2Cy/UrT5QFAo/zDfTG/HD3dtmKxGlVdmcPkd2i3g+yoxAftd9aAAiEtv5aUFubanXlrlyQn7rksaTZUY3Xx1v+vhfUHrG6j/OiGQ3lCkqvgPLXE7XQ4Xap34dQSm2xXULz8qQIAdiUhSa3S+h51p08Tld3ucKMloS4E5wfc4/T55gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcueMWB+1AR9hCbt5RvxPz8HOvRdptc0riLEz2jfXZo=;
 b=sJrepXM41dJf8geJqlSHwbxESVUtxxHHRLbaSnRc8y5aae6eWBRu2x1/W1mmQ9QfID4CKsOESd8g3+QGEivOzEKAhWRBixxqoTz+ERzZmpYW9txxXoJAddwBaHFe3zXmrmI95aiU3yZcPKNsQuyQ3/LTxEEf/LwC5m/rbNW20bvlgl7O3H2RToDiGaUDlST+LwIqnFr1/v7wpzC/o2Tu7XvVjJ/N0YbB3Dn4l9YRc26w8fMfA8/BAbALqy3SNrfYdNQG2FRSM3byvIeAO2x+IzTkEEzt+el5TKEUMq69cXpXyo9mOF6aQ3lN388S8/xMjG6sLLeHEW2J3qt/b2rYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by IA1PR11MB8245.namprd11.prod.outlook.com (2603:10b6:208:448::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 1 May
 2025 21:43:27 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 21:43:27 +0000
Date: Thu, 1 May 2025 16:43:57 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 07/13] KVM: Fix comments that refer to slots_lock
Message-ID: <6813eb1d4a3c7_2751462949f@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-8-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-8-tabba@google.com>
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|IA1PR11MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: b40bd040-fb7c-462b-5fa8-08dd88f934c0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RwoqraZtHsxwE40wP2Vk/Q4RoMkSA/kfA6Rz9Nj/86syM4NcO3+g/D2j3oUS?=
 =?us-ascii?Q?RSqmlHMOWOTSwf27NiCRp3EuVIARzFDHrXphfJrY5AgEpBYqsUQysJ7qxhBJ?=
 =?us-ascii?Q?tVXUtEe/4M2Px1M+AWvOolYPP4ih1MLhiChwq6JGp8jzeEQhbb6mEC8ccl3X?=
 =?us-ascii?Q?YrFdI64mdSnqM75/UurnYKrAzxQviecCD81KNm1AhXaDWqZ+Tvzzv1YCKKcK?=
 =?us-ascii?Q?86NUObJ0U7xStTNMjZi+8rfggVrAUeVYm4kAzhcVDRapq+cBCnAchn9PI8P9?=
 =?us-ascii?Q?ySLPNG2VtpQO45C9xViryL5xVRpVjse/7j0c+ZfGBADOAfLOk+SLuzIogaR+?=
 =?us-ascii?Q?qK7T+bdscKTcJQw+qkudYuD8vDKk63KPtOqgL19r88TObs2pvNthPN1Dz7eY?=
 =?us-ascii?Q?IRkJqC7AEXksbUuFlfEOgsmfMdKgQv7Ty8+4+RHPkl3+fjVn+eHYrUmpkRMn?=
 =?us-ascii?Q?8X5dNjBjdCZW7HJzBw4A/hmZqTFEw/Ufdr2/Yd8MtkNjFI5eYibvFabk8b2L?=
 =?us-ascii?Q?jPolO+UUJKkOeTDQdR0bAqkKwGKRyDZ96LAVJE2obGcDbQ4paL+wQjWwxjmN?=
 =?us-ascii?Q?oNtwL5P1OS0dZRqFFOp6b/Z/eZmE+Bisfju9HA9vBHoH/qLjHxTBqe4n9i/5?=
 =?us-ascii?Q?Zpgdfx+BPYEPOzJiYQ3qKn/r+teW8OSecvMQFyzPq/MqglbhdNW2lMDD/wwh?=
 =?us-ascii?Q?mFR11EgFCLYaqs7R0Xm5L219/4wD6s9IeklE4+Vh4WwL2lAKvo0e3i7jtHv4?=
 =?us-ascii?Q?k+7lu97w67AknqO24B1fC/WBMq3nM7Y33DJql1wYgyPQKSmXs6px4LoJXoXf?=
 =?us-ascii?Q?0FEZp3b7o7fiVsSOAf++jIf4hWg4VAUELXQUDuXD/JVCIHApSAEAxVuBS93M?=
 =?us-ascii?Q?MDQLm8ZQPMw6K98rCf9EJGV6ZLBLlu/CcNjoZCmQcAfL7WsIAD5hDDg9uvDB?=
 =?us-ascii?Q?33iLU83hS/GG0jgSqY0koqy+c4nXtkY2QwSfJldJVb/iwve7sWy4IyP25fXn?=
 =?us-ascii?Q?XC2U6P9ly2EGPKS1o0tstwy91yO2pLnIwiOtJ7mWkJZ6Wt20D4bt81+ahc5Z?=
 =?us-ascii?Q?BRAXLh1fXbbny4RKoyPUEiaauwfPudf3HYnJ+5Y7Q5+zOYxxHbMB5XrGg6CQ?=
 =?us-ascii?Q?jrjDYBat0Qcj4aQ2Z+m93wHboDjmQqy+hisZ1UGmlcz3RpeqPatUeYb1FK5J?=
 =?us-ascii?Q?aTi3KQfY+/FqD0RX1Qhh1Y76VL0YBmAQb2O3psgMmIEvzuYp/wiP48I2nIw9?=
 =?us-ascii?Q?+C17f8u+40zpjBFghmwoEraVtNFrPYIFPkmn2OanQWaXw4Uq7K6ZsP4Orndl?=
 =?us-ascii?Q?uwqUmR4E6HJvVCSgmVYVczhEbtc85OZL4Ga8fUNenRTdm7jT1P7Cqj2Osjxf?=
 =?us-ascii?Q?SFn3+BXKSGfN92xEZIEzW3vuYD3j5an4L4koyJbqCzUZONCqZQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZMcvG3JxwJn36NQUEUaNXhTZLB1NT4CZriMaz895RpXYBwGAjhTO6kwzXqUZ?=
 =?us-ascii?Q?GeKVIIAI6VW2Jmv+D2GqqpihdEmmAezIksHRGqJSVX4N/KJBkdc3Dv2amecV?=
 =?us-ascii?Q?NGS5IIX0sNz2HJRgwrrVmMJ0W2s20GFx3RDzZhVxgXxzzp1prrCWxaMFxbT4?=
 =?us-ascii?Q?fZxeAbnyNhqa3CcLKt3meXCToZZDrPTGVutoum2HeXjSw1B+DTD8BQR40CyD?=
 =?us-ascii?Q?4uduxgY0XmDIgFshIXtMhE5Wj44OkjF93bVqjlo7ofQhlpcooXclguyIFpk7?=
 =?us-ascii?Q?lRWFlfdLuxXeAg39Mbmoz7dgabvec/jnc5LyEY+6f2SZcO6aYbsetTJASvJx?=
 =?us-ascii?Q?1LHhNp/H52avD4+YEGuEZnL6VQdVcyh7iRndSpzNT3hSFNjxRM242y5wmNdQ?=
 =?us-ascii?Q?0XMijxuTNidjinCKwOEEYUXwdsGmHL3UGR/T+kPNyj6jbvN1h0NVkYRVI7re?=
 =?us-ascii?Q?nW+IsgWL4epsxwJ+trUye27LJyFktnvVlPclYNGBmMuasZshU41xK5t76RnN?=
 =?us-ascii?Q?g06o+GqLrkAR2G4DILehSwHGhBreRjrPeyPRsWS+nRsTuQX74K5ndjTIwuhl?=
 =?us-ascii?Q?HGw57g3jcy7Qn3EwdRB75qGzXhHWF0lD86sVdwTWpS62thqLa7sI/NjYzgPH?=
 =?us-ascii?Q?F5un0VQcMD9kEb9P8Yytyd6dYGnLnvCzWJOQ2JMqWI9AGd/JSqJ4a48l3GH7?=
 =?us-ascii?Q?Na7n8y83aCGZdCX/CqU/ZLtyrjGvJ9Zm082V9gPEPeqngYo29OMsTg2dB90h?=
 =?us-ascii?Q?+Fcn/gd6hC4MUjK1mOVO8lwcKNkXPzWLVuBlxo0CpO/T3Mi7KvQkLjacPvmF?=
 =?us-ascii?Q?viezQXDQ2kW1w8/WtQrPfTVG0/OKuG9pvjHrceKs4LsFkdczWznkW9zHTGah?=
 =?us-ascii?Q?fDF2lojyb5voDJscFHLJCEZpGwNynkdd5DJnBiAO4Ea3yOr0+8M06hrjKsGi?=
 =?us-ascii?Q?6PnVzz6sMJXTD82801AKz7A2n9lv6j/AZrYeZN5k/Iwa5qgs06pypXH7Y4Wb?=
 =?us-ascii?Q?m6oLOQvLENuDBMOKaPiOTWgjOdY92Wr9QZEtFGT6KSrsBsHDfLThGnueFKi/?=
 =?us-ascii?Q?PqDprzhtUI87nkt3QpQEEsxCyYm2WH5/WsM7DNpXyUxmW1FrwSV8WGAA0Q5m?=
 =?us-ascii?Q?hpSWTwrn5TP4azjI1ARgHfs7Bo7h7+mwNXofM9tvF7WDP9yMs1jB7LvZcWt7?=
 =?us-ascii?Q?dihWtBOEcVcBHOf3Q7RAUa4i90Iz5wl2+zziUVOutBEAk7ADJwKLQdN5sSD6?=
 =?us-ascii?Q?xZGHYwFe1tg0Ztzk/4WMoCgetC2nTLCeaCYbSGvZmJQ8AoDaD8jeI+FhzJ/g?=
 =?us-ascii?Q?BAGFInUf+RiY/uXgXHOIEI+AL2FBdthUc8cHR6y2M1KGEmB3V4gSJS7RqbSH?=
 =?us-ascii?Q?Jb3ZgymgghjUJp4Tg+EVwGE7oZA18mC78WrArB0wWVjpGNT3ydMcO6lWepQ+?=
 =?us-ascii?Q?O7CG09WJleYjuQLwJvUiX12Y+LTDuAfwLf8cEaepOopNEAqjqKYcU6TEdVza?=
 =?us-ascii?Q?GnWUYoBJM70Hu0vlsj9G1OkLcvBtg4Nn/0ffLxe7sqgWIKK5HdGdFVEH5Hv/?=
 =?us-ascii?Q?Od7c7KPWdwhg+UXhoRlW9UlE0C/8erJCl81jLLpv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b40bd040-fb7c-462b-5fa8-08dd88f934c0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 21:43:27.1978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtBfcUk/mWzr9ty1uUen1zopNbAwzPC4fYF/brDlWhe4c93avO17BEBDhW582oOKZSH1P9oCqE/QWGKbSHgf8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8245
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> Fix comments so that they refer to slots_lock instead of slots_locks
> (remove trailing s).
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

