Return-Path: <kvm+bounces-48973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8361AD4D61
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D6CA1899FA6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 07:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B6F2327A1;
	Wed, 11 Jun 2025 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VwHEkjX3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E71C2D5414;
	Wed, 11 Jun 2025 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627989; cv=fail; b=l2fa2cWVx3+QjII0HUIouhzvI25Q0aVrJU/3NbfM4OYxtpHlRYkkXxjo4NzZKSRxLJNww6zL3itiF/CcShzdsLlhhwybr/HUgwtMzJB++3SDJAOcksKX9x2XT2CIS9jgq2zhpf35jpflB+K8NGOHzQ82qUN2wWTyPR7I/rPE2rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627989; c=relaxed/simple;
	bh=vHTKbZBrGl6EMGIj4VE7vL/qwfNsheTxwNuRQ+LplO4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hZ0gWY2zW8rWJX4b440y0nP2Va7XEnj+Ef1xg4/rKNyx7nu1aRjPqjk8h3y2B5mUB71w6GxoUhC8eJy4Yye5r08pZ/aQLkzBVqAOgzGTaN5AQgX4/OOEVzNwkzE1EiFn10sDoYTFKO7kDoh+oagT5+CZSPTost0X6NUvavtaCq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VwHEkjX3; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749627988; x=1781163988;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vHTKbZBrGl6EMGIj4VE7vL/qwfNsheTxwNuRQ+LplO4=;
  b=VwHEkjX3MRQPIVHXOJjMo27s+4AfUvEwbg6w1Vlnmd/fYRmQLq72WOWk
   7xHv3GR8hnFv5PiGTs+t2MdtrOALLIxfxU+3ComIhC4XxGKZz7ASEUBpL
   82zejee4LyxoyLUu58p3gu23CqYSakVMNfaV1z8c2xYO3sScJFbrzAmva
   v1xD/EIpfWNSXQrgDENGodZn1ZdRlHxsGPJBH4wmNxthU1oEDR1cPHPz4
   eJEcV2w8iHA0D1XFAg3wja9piHuw18mnvb7+Qt2cLnU8e2mxjEzIOkRhs
   tS/owz7Y3Vmhg2M9XvFkMmg2mZPSBmEzhx/6tM2AHM4XyH8VPdmPd4VvW
   g==;
X-CSE-ConnectionGUID: iJozVqjGTQGDEbJCy34vog==
X-CSE-MsgGUID: mWx65lwtRWe5Hax0EGrc5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51750802"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51750802"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:46:27 -0700
X-CSE-ConnectionGUID: M6pRisaaThe4Rh3Zte+uPA==
X-CSE-MsgGUID: SMK9s+t/TiiPvBtU7pjvCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="178028166"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:46:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 00:46:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 00:46:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 00:46:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDVeSow/0ZWa+jxxykUgjBwF+7F3LqF9fDUVGwIzTPM1ime8tP9lLD+TdPfrIM6Kaip1f73Qhzxy3YAEjvUwzps2TiiyRuPUevhJUo5MZGRourOHafz/h2FS0ThlG6Uxy6sNjS3ewmafHOKuMKsnUPS/MYfUG+V4pink37s+ksZIt/5wkvpdl9FJiZNYaJneFqeFjncsY1ulbnS+1Lpl2WlYHMlktNvmWkmwQbORbOLkPxiJ0BkbyCeohStH1X/EsyNdi05wo35010VSdIAOkQp5eERGBdbGekjqxaUxbEYgz1q2RvVnVB0frskd1jXKrG4hMF5k3OuWrahV6w16zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bRa63lvQDpIG6J/SU4RQews1hrbtYyJFpdbVi9Ahqg=;
 b=iFSrLRX0RaU2LPTXU4luHWLzMV9Zf1gHbV0ruAjNSHeahH5Tzesl4Y5VI3Zvzw/TFwDt7PApWJi2HTwz0WlPyYfS+JgG9hmCC/jI8baHRQLC4dx0NEVnIQmS+5S7YAgbFY15QDi1/SlKVGXLvhRpy0I2O5HlqZn+QJ+Kl8/YS28qru1MyQqRwbcxivyL+piMFiOLjUORZGvSftjwI/27OS70rSRVmUxPVY5ifjqVHRwBozhIgoj8jhe7Gq70Oi8yZKdGisZlemAO9rPQqAAiBasLAe+0KSvnXn9z6ZxU3HB/GLBjMk744A5AIu6ayxaDwb3GVGWWyh200Y4K3MbqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Wed, 11 Jun
 2025 07:46:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 07:46:11 +0000
Date: Wed, 11 Jun 2025 15:45:58 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Message-ID: <aEk0Nl9l1xAEXwcX@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-6-chao.gao@intel.com>
 <b7e9cae0cd66a8e7240e575e579ca41cc07f980d.camel@intel.com>
 <aEeMY7czgden2lmX@intel.com>
 <3a1bf1a72473637964a443676e59868fbfbb1ed4.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3a1bf1a72473637964a443676e59868fbfbb1ed4.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4672:EE_
X-MS-Office365-Filtering-Correlation-Id: 313a36b9-8bc6-49cb-6eb9-08dda8bc08fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1BYx731ZbMly90n8gNz312jAtigUKKOUZT/behpYEoC5e9jZZtb8NoN82KfP?=
 =?us-ascii?Q?9OIbn09J4eWSmoyLEWACQlupr/KmNMeczK03e6eTvo/FNbUIhbvQEyi/vXU+?=
 =?us-ascii?Q?Td0eGKb9EOcTGYDPXpJYhrfQRxQyuj7RMnmDERFkDKbyMRbQAZUONiS+tVLl?=
 =?us-ascii?Q?Wx9OkUaghdnS4vC+FchhoLf5g9za/sp3NNAUGNcya51U0wCBw/Wls8YX8ro4?=
 =?us-ascii?Q?jAQVe7FbPEzHMfcQ1lGM+S1EaRSq7dSsBH+uP/y3OmuPmhRTkH/93WBnnMrv?=
 =?us-ascii?Q?EFDweTm8tAt2A8TudjzCxV9ynSQkbUtcPXua4bJxrPtUUuPRR262pZjpQJiu?=
 =?us-ascii?Q?gsu6Y1JZXrUmwazk9AQGN9rjnk3y0Qdd6EYUx3po620xxW5HelREs7O/Nlvt?=
 =?us-ascii?Q?eratjDdbcJlFY2dI6OiDLabNV2hBmJPYpNR8zSeATlzfz1wUSzELvR1rGsqI?=
 =?us-ascii?Q?cV3aNNqC1SjFCTA7eUG586Me3AWZTWwfMMewhYsgRcx+Gk9I93Il2eoUH1NP?=
 =?us-ascii?Q?VsF1kN3YQIbxQ6ohoRykNnU6HqiHcGNUdRVitqH6EIs7fSHowmnFQs4MLHDf?=
 =?us-ascii?Q?NdQ/Lbq/r1vLFYBeybMqIlWlDTlCYA92kCTeVVGBfsDye/hmzcJRd1zlLL5v?=
 =?us-ascii?Q?d6sdCr2X2YeSY8opUNzBYDuM3AJcchk3+r5n44Yb5Gc+l1XqSv0PH+e6XrRp?=
 =?us-ascii?Q?1jjUpA4DsTLcUnA2QoiEbRhBdGA8yR/9Uovf3LkuwaRH7RWP92IfebqtmBEB?=
 =?us-ascii?Q?jab2hKkvbVFZbFpgeydNkGq8hSacF8CiqyLBZUBlqLEvYrDFEO7F3GbDWIZY?=
 =?us-ascii?Q?eFC+mc/wAA64RPUB0sj1wWenXpRfBXkXpmWC65hToK1m6H6XsCiqlxniG6sl?=
 =?us-ascii?Q?xqufStRXBqpE4pV/0jf8m1xNuTtUgw6H2flzb5SWdIulESr+MPzXUjHV5mIP?=
 =?us-ascii?Q?FG66qldIru+NQM6Us3/KbaISi67Bw3/likRNFkfBermU8UwdEX7W7sEE/47M?=
 =?us-ascii?Q?OLibHlzL7YypVjN6iDdRxd4ma6YuUsCq0g+UcTh2FpU8Sp9fMj6b+FOlBI/f?=
 =?us-ascii?Q?OkOgCyj5J/7xY0g9vMUd3wPWQcyYBwGniyv8GJmqZ+4BCaM1QAo8vxjWIsje?=
 =?us-ascii?Q?sW9tkj3QXQo264tvatP9FnaKWGePqnCimNJoBnK9Hb/gBh6KL3JXq0dOPwSd?=
 =?us-ascii?Q?9vsJujHb5dvfjqdShLMnXOFfodYf6bXvx9jxhbVfmvjjIn9yKmCvL7k0335o?=
 =?us-ascii?Q?LKoKQY9vfBmcDZFqHbk1pM5tbPfEy3JkaWhFlp9Oq68NWrtV2rKdtlL/S3z3?=
 =?us-ascii?Q?trJagd4WomQe+nW5n6hZPCaWjd2slpBshgTc2RJo4I5pijHpgfSnj+B1YA9i?=
 =?us-ascii?Q?qEAB3FiCFVlOacfJHme3InKuNfavEPwNoK15TVhi+QIsiPgQsUVmx2KX/3h5?=
 =?us-ascii?Q?QtOxeDjQ00E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9R4Sp2wROE3WQmdRxIHPYwu7Rykr2bPP6vkvDBge8F66XZcHVb8tnZ4lZviG?=
 =?us-ascii?Q?/RckJrVe/en3KxcFD9nEFcJmBezc6Hb8V9mBxYuL8cNclzVdIOQW/F/toqGx?=
 =?us-ascii?Q?U4/nH1A4P8eXEpUuxlDmNL3wf7eK7rsilreBnNOEgVi0s8wqLuonXTeagZLZ?=
 =?us-ascii?Q?sL6GNbUtCxWlymM1eOxsQ/090uMIXcNxp6jRJ9LNiEt6+g0jcgqsSfNmRXMn?=
 =?us-ascii?Q?mCSrECseYk9I13PXjwixpMHIdxJQrQk25ggp4VuYvhWkA7VbOwFxYRtL2qmY?=
 =?us-ascii?Q?BHwgDHASL3xuCMwr6fVn6Pf7L+IWfLgXkGX+E2ZcRz/OoOUl1o8zIDk041Rs?=
 =?us-ascii?Q?nIFhtjL1g7Yodgzq8Npx61RIcKfzVOFpN4IwRWt1fYcGvvl6gJoHs47f2zA/?=
 =?us-ascii?Q?sLYO5H5KEC/vPFfXJ+p4js0yHoSq71Z1VM+SVFsz2uLb3ZcSkvU6kx6Iv8oA?=
 =?us-ascii?Q?iBdHIslR3z7rLVrfQJHgajIJ5+UGtrVbP3ZGoiUrEckBAPUk4kZV3OZvGqdk?=
 =?us-ascii?Q?NbwmxlwB9arqjJ6L3kNfpL99VUiYZO0YAl5IV16pNvyC8PwWbOaVrtzwAwNQ?=
 =?us-ascii?Q?y2c2fnTN0lvbaKhs+zXHXLE9M9CO5hmpX6TSHSrQsPzAFdZXEUjExV98gh3V?=
 =?us-ascii?Q?2VhKZ0WSGEzMfiI6MaSxcpH+Ym5vzBdwNS4B/EnQd3G9q4gsSqjRv1KyQj2z?=
 =?us-ascii?Q?SntMD6eFHg48aUj39vAnCDjvrR8Ba2x4oJl0/UphIiFNQZqYOKRZRnqk1h2Z?=
 =?us-ascii?Q?RqVvNGK0WdeG4lFEBFTHX1S8NR5mtSplhWJzGmFtZ6L2Sm33AJvpo+RUvLd5?=
 =?us-ascii?Q?CsZyVQLATUaCweK1oBPfWS3BVl2OPMX/ijPH4v38DE4rbGULn87VTEiulShs?=
 =?us-ascii?Q?HVl04+92EqrSyIapHF5P/FgS1TJy044lweAqENx7P+7zKOlrDxNyL8wAFpLY?=
 =?us-ascii?Q?qk78b9otM/dJYWpX1J6QPJhe8c0bzkOAQANlfsCR2AbxZ2WBgnhvl/DXQPhx?=
 =?us-ascii?Q?t+3H84nD4KmC3Py4eY2y2WXc9u6Zfo/Q6B8hp0qzai9i4O70uV3bs9wQh6Mu?=
 =?us-ascii?Q?cktEtSboC33Cu0yS74R0Et8AYTEdkJ8in1pQMcWKji/tfrOUIhmD8ZvSEtH1?=
 =?us-ascii?Q?5aHxYZMfRMkkFVcJow3NBfmBJlTgNbr4iveKynGCXM9VLA4hr33Lm6i+TRx6?=
 =?us-ascii?Q?emFzj+6UIujmGlCvCoThuDcMbZ2xHglNe6SgknRcehThi7t1nOgnNshuhJPy?=
 =?us-ascii?Q?g9EsPo6UqpQrNhW7rRkRnDhUc2RL3TtFG8yJv5fXXMO4ZJ6l5NOSNBi7l/wL?=
 =?us-ascii?Q?h59Bhy6tsNWoV48ZCqG2s1fGDUhxV+FAeH7W12nM5+qnshgMPgmFH6YTMXWQ?=
 =?us-ascii?Q?2QiJcliZnVBDgql5UiT9SVRBSM4tImk7lz0bqb9lEX+I+FJALDmz6f4tOVkr?=
 =?us-ascii?Q?iLk29imjjRagTefIVUl45A5a3GPoITNaRLcWgKrtDQoD3zHsVot1sP1v/mNa?=
 =?us-ascii?Q?6EC/QIBVte3eM+xXmmVP6uq1vEedfWZU/F1NUdX52QB/t0M5ldbfAmU6jh6l?=
 =?us-ascii?Q?jOMoToE26hMLthgYJRB0fq2ebWpWk7IJjMgu55BV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 313a36b9-8bc6-49cb-6eb9-08dda8bc08fc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 07:46:11.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKONHMNVWBJl9kdo6j6oP3bvYkakz8GnDANzDrxk7SMr+brd7n6zDjCk/ho2pn3Ea/HQDaIjPWQgM0EX9eEUqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 10:09:35AM +0800, Huang, Kai wrote:
>> Using 'versions' for sysfs might be confusing, as it could imply multiple TDX
>> modules. It makes more sense to me that each module has __a version__ in the
>> x.y.z format.
>> 
>> And the convention for sysfs file names is to use 'version'. E.g.,
>> 
>> # find . -type f -exec grep 'version_show' {} + |wc -l
>> 185
>> # find . -type f -exec grep 'versions_show' {} + |wc -l
>> 0
>> 
>> Concatenating major_version/minor_version is kinda common inside the kernel,
>> but 'versions' is not typically used as a sysfs name.
>
>Sure.
>
>But then should we just use 'version' in the names of the structure and the
>variable generated via the script?

Agreed. I will fix the struct name.

