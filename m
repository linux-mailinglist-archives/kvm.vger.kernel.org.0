Return-Path: <kvm+bounces-29596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 204BD9ADDFC
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 418A41C24788
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0A01B0F1A;
	Thu, 24 Oct 2024 07:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iSHk7uLY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE07E1AB537;
	Thu, 24 Oct 2024 07:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729755749; cv=fail; b=uhpiLqf/xt/McuAiz8WPJ9Tg23ar13JT3oqpgmKmtHCec4vAdNw9iQxNjfrtIoJ8TbAz5rc7S5uxqbq3COj45Bj9lMint77/hOrBNYOxIKLw6kYXLI+Fb/GbM+jQuWgoRgDT3/kM1tGTNgZbpgi+mzrdSP3q/vA//G7eU6KX9b8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729755749; c=relaxed/simple;
	bh=CYsiC/BhAdPpGCG6d42+PfhmKwj0Ws9VpHMjpATjOqU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vq7w8sXu6mwbzpbV/WM6CQlwB+d7vQyKS1R1GVApzhFu4wr95n1MWXuLYTKIS227uEfzk7CZ83YnZp07+JzHmySKmNELoK5Zz3d5v6Te6axcUcFhIxF5lgcbYnUWEq3CV0YqaKApnhnWxeOR4EcX38voTvoKDg8gT4o3u6Fm5Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iSHk7uLY; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729755747; x=1761291747;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CYsiC/BhAdPpGCG6d42+PfhmKwj0Ws9VpHMjpATjOqU=;
  b=iSHk7uLYfGVaw5mF9BStEtr6ZB0tCoSn9l40Oi4qPuYpkzsE3DLJRPim
   TeJPJiqbg4z9UyPtzmiVz7cWEFhYB2rIcXViybYlBVXe5c3cFQzAYbqy0
   cd0QWyh/gu2xBZ2xOTgcEZU6OUQHZf5fNrcruwe2qYpj801cABmYIOMe5
   lRTefcYnSNxT8GJA3NDMztUwTI+Qq22SjjmUs22I/sZRibF1RM4w3LMNr
   SCXFenN0Hezr8nPTotpcAoSszuxLRcl9dkTwnxUgpjeSOPvPL6D5z6kbl
   +r1OMnBx328nZz1961W0bi5cHKFjyVFMPUnPX/uGBGhkCkE/LlfPlj7pR
   Q==;
X-CSE-ConnectionGUID: YSaT8ZPhS06ulQHMhPtL5w==
X-CSE-MsgGUID: mGXhOuqYQkq0HJKYgY9erQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39915471"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39915471"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:42:27 -0700
X-CSE-ConnectionGUID: 026JRJImQ+CBnzKkC2oqSQ==
X-CSE-MsgGUID: zoWyNf2iQaK37VbE+3okRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="81333426"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:42:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:42:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:42:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:42:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAj6pHgMnlbqx7hWxe0kXhqVSE3vlh0sg/AHyGd55AkxieHUrrV3EnnjpNzuwbkiEwyAaA0gr5jYOMaI6U/shN8OImO7itpV8QIym9yQw1Mfkl0ATbKISVks9z0hmnglub39wMrovtU5WXBc5UAaDcWBI/qRQxI3UjgfEcCVTHiuXe4BicFKs6YNCfm/Dr3OWDYXQ2/s/7yLNJcfGnh0ejfOQfnUISGvnS/PYflvblKqvFyDH2FwkyCKxrWKzkdZCP1aQdDijMiz2GWgSMqc7DDljEJUmIKcEoklQV3Au9i1LDASxSKm1eyHoabUXpiO1PRo8bjgWX5gLn3Nbhswlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MQ9zRPN/ZR8Vs+eujq9mKJgY+X8FI4TFi8p2dTsWPU=;
 b=f9reolXSIRBjOvRLQZFGg/5JhdSc77HqP1tuOHLxC41GwljnJiH1hEzKEiKjUZky8YCNn6KmcOiWf6ukpHbqcd1Ms6c2yJkjKsMTeROK/1+q3YcqG2HrEy6YHf7LxpggEh/UpikDJnngPb3jyhRxcxPqLuvWSfvVRVvC1qwjaIrucV/q96+r6B21yViDO/lSFFWH/5SFntz3aUFgk6uRlFSZ+4NWw73DGfl8qu0GfHVI/vvUvzWhu/dcJqoDlsCNj7UZYG6k/de9azZQazooUZpu9dOeGGS6fDUoM+N65nj9UzI6eN8lolAofYHmeQc7le+P652+MHVu+a5Z/k+d9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Thu, 24 Oct
 2024 07:42:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 07:42:23 +0000
Date: Thu, 24 Oct 2024 15:42:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
Message-ID: <Zxn6Vc/2vvJ3VHCb@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-26-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-26-xin@zytor.com>
X-ClientProxiedBy: SG2PR01CA0143.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: 3186770d-13c0-42bb-021d-08dcf3ff663e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xCL7371FcVC6buHOJ+c075zdQCpK16VnfbDLFmRxu0Z9CDM4DGi/TbmOs6b/?=
 =?us-ascii?Q?lVmIbSc7JL6tMCmnM80KzQhyS3VrPc7QkFJ2rcC+HXlNiBXYaoM64CCh992L?=
 =?us-ascii?Q?teX/Dgq7GHtoMFsGfT44PwfCgcZdlXKQK07Qpl3lxpSw3GD+9BsVegSdVthi?=
 =?us-ascii?Q?8lv+OAPbexdGGaDtxjbp62VFzZsgobH2Ap3NEJw0mEUqtNcerlDPFjJmwKDr?=
 =?us-ascii?Q?XbbD3uUHaVZN/oSpdr2hAmzxYeSFgvOnZgeLj7UwnrBfgs5k5fA8PZAn5BIR?=
 =?us-ascii?Q?scIw/839JlMxdq2bhUwlI5HFeBGALjtbfIjTUgkmu7ViHDeU9p+0CS1noFVh?=
 =?us-ascii?Q?0rRsXyUwecc4zaJtueX3nXsR5TzBtBXjUDi+osi4e1WsVPBBTd9C8tVgQuRb?=
 =?us-ascii?Q?qrauHRwn/85dipt91yNBfQX13AssIOtTuda3O9MaWeT+7hlCety8/GZKfjhl?=
 =?us-ascii?Q?jLOPdIE2h17yQJC9WZYp1lWIVjBTH+/sKWFRu5sMUDTMg1Sq5jq5mAd4mLJ0?=
 =?us-ascii?Q?9IhkXzq4cnR6v3+8HtjjK0UsaMgYqt09PhkVdGN/ByS8xg2sUm0vibYt3Ihw?=
 =?us-ascii?Q?qoG+IHkQuAcoxTyweiAsCuyB1ECu5kpUkOl8XO3GRgC98yanNThxcKEMBo2u?=
 =?us-ascii?Q?5idRBSEeUYBrvGMwGrcetn1E99tpEq6NMGbVY67uqdg7XAFavFcdGYazcLeq?=
 =?us-ascii?Q?TswRlZ1Af8G46UQf280109XzavNGUlG/ZiACXkMI6VjPMQq/HqsgUKAVEZlY?=
 =?us-ascii?Q?jRbsFcfd0bsMaMvF/bUnclVo360eXj3H6MA5XjofgEn3uYmMY5lyGKkWHoxu?=
 =?us-ascii?Q?28z17RU+mtNxZx2He5ul4UeeYF0WUOkc1ck1kczKoeFTVK1e4UQEJSCe+QN/?=
 =?us-ascii?Q?520PJbHpcuYFT8nKIwg85XZ/lDFfBKhiiMOMj2aCjyi+wcWKe3KdIPav8oPy?=
 =?us-ascii?Q?zF83p/8yN7eFGVseK1oZXbRIPyNFcc9pbJ0MKSAojO6p0go49UDFVmO1xfBV?=
 =?us-ascii?Q?TXXkrDcRsbovTZI4L/Z6xKrtfKShXUM7fDGJf+mJYUqSGBYgOLc4YhPCNjGS?=
 =?us-ascii?Q?5lwHC8JsEmpjssZ/vlS4l0iI3GndlSg5QI4YI0Q0CQI//5IhWAsrDZPWRTk1?=
 =?us-ascii?Q?cZJBhzPf7mz85iIipakh90sIA4e/5jHT1fRSF0Wb8EB6TYEboxfD+nU5eYh7?=
 =?us-ascii?Q?qfNb9jswakt+3RMB2uqgFMqe8iGpEwte/UWxorINNnVn2cCPS0+q+8P/pUSb?=
 =?us-ascii?Q?T3+tVUIlaSC+X41iSJwpWamUzCAEWKmPjOxqpQ+zeKI+SEaXjuGL55mGheZa?=
 =?us-ascii?Q?+BR1xRbWn06IKFKQTy/aqTQM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z5B56QpD+0RwsA9Z5QYJOE+USYtXSrdgNtRPpCg3FtMy28zbXBsvvCimYs+c?=
 =?us-ascii?Q?wcloMbz4Lg9X05t7uTQ8zbEb8zy8iSDKbf0Q5vrR7Uh9yQig4pvZjkNxhMPK?=
 =?us-ascii?Q?5nfetk0iwv4A+fWgW/wUAx554GRnjGUbsjnr2BydP7AvHw9i76N9eb1qxwuq?=
 =?us-ascii?Q?/A75sgE4q4ax2nuuvu/JUqxNli5MqpOWQCSs+DZEFf9LqOFQbUhOp9epddJr?=
 =?us-ascii?Q?ApPxe3sf3hesjTonply8uaZjXyERn2pIbMbm3ACMrIUtjsVK6DkJ2z/JgvB6?=
 =?us-ascii?Q?fFUIZ9efO6CtO3LZG3DhyrK5vJ9WIBpyTnfhW98fN1sxvPn+tVGEjVikxW8T?=
 =?us-ascii?Q?KhfeZxpD1NuHGDxYKLA4VcBvwi+XXFWaAqzfjX3i0JvyzGu4D4Pfw8IslbsE?=
 =?us-ascii?Q?0kZ5FUMutU/VU9dttu00HMoDdmJ7bThVsDP7NPLhGK5drYWejsNk+9UAah+S?=
 =?us-ascii?Q?KDGJ4tVa8KZ9IkTvhKk//cRq08YOMuh7m0TaUvB1IX5xgj2nAr/6qoAwNxMm?=
 =?us-ascii?Q?JOlRXJGuvsyCjlbXZV+mE61n0uK2bSVI30kGukZQdMngB+q/UAHP/JEzkgMY?=
 =?us-ascii?Q?4I3bJbaaFGBJSMEQTgJK2cMgGvK6ua17PFgxJeOXuC/qkHk3fm5dqNL9FZ3K?=
 =?us-ascii?Q?kfCHhXbHe+ImOGil0SEleALLgSCD7873w3elqc1tbLzqMZZX3cQr35b5+Y29?=
 =?us-ascii?Q?nbhAcjCnhaek0s21eAEvaoQQTE1patxH0hibq2ukgOlqvvV9wbm91MWdRI8U?=
 =?us-ascii?Q?TIbsEVCqPBq1VEnUCxqeDJ4zSTqdAKmhSUfukvhNihLatifQ9Bv0hZqj8bBT?=
 =?us-ascii?Q?HKzIRKKK5b0lUyrgIp3+srX94/Uf/aAcB+8bfSmLlRYUCuK/AgcGSyDMJzWX?=
 =?us-ascii?Q?aDPkphd2HMSRr5oVg6X1xxSG5GQ10vf5GJHC5lla0d/2HMLoluS0JNoIDEgD?=
 =?us-ascii?Q?U3kYE3I9p9nuY2+RDybNRacAeY8n+p0fiyALjcyOBtuWRLG5Syja2WRRboF8?=
 =?us-ascii?Q?4ERV3hMtWMe0GbRl0V3+TBwaoJIIV/k1esU9baEPITLAm35jZQM7vLs90o3U?=
 =?us-ascii?Q?qageYgftGH/wDrPVI4VEqpAQXCW4EWealhkMP/gVwokDUF09bgNslYrxNgpI?=
 =?us-ascii?Q?H6VbIo9JNTo4N/BgfgveaamxUuN3GmrngL9KK/fyi2iuwKydkkbsKcaRWqXX?=
 =?us-ascii?Q?LL80cIZRvJfUXBZsixmVl9CLMg0huLHyz/A+pks1BzDzPUVWSgTzVM01XNII?=
 =?us-ascii?Q?Ywb6+vuIS0Ds5B0h0sTgI29xiHbuLVBPBUQDmQh1pzfqBjEFBK2lWBpK5ejI?=
 =?us-ascii?Q?4USzevMMcEFvoHIKNgCQaaerFL/uA1CUQIM/6owfEpJaki6CNlHri1O4C541?=
 =?us-ascii?Q?qezn/IIrBW4VtZIHwU15ak1qhjj2AuDjSGb97UuTt7ntXtVeC4jPaS9wt64R?=
 =?us-ascii?Q?vl5S5bZ1WNLI1fgNQV5Xe1PBL1SZ9qdlkbnETUHN8UcfLzsgNQ4fyfzoQy1s?=
 =?us-ascii?Q?zvtp9sB0tzgk77EjZjvUGsD/UIrzNjepHb6C43QGJFSSVrw24tzNvlfp19Fi?=
 =?us-ascii?Q?1ZdvUcr/4x9GTHbvH4sZqn926dJ/7lc7da5UAwsK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3186770d-13c0-42bb-021d-08dcf3ff663e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 07:42:23.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgViGJn9Dd1kT44geTmBr3A9VOyaf0OJaUamP1BIAQmN+oPwAOpnRDwLnlleChNJK05kzowSsUoqnzSPznzERw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

>@@ -7197,6 +7250,9 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
> 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
> 	if (cpu_has_vmx_basic_inout())
> 		msrs->basic |= VMX_BASIC_INOUT;
>+
>+	if (cpu_has_vmx_fred())
>+		msrs->basic |= VMX_BASIC_NESTED_EXCEPTION;

why not advertising VMX_BASIC_NESTED_EXCEPTION if the CPU supports it? just like
VMX_BASIC_INOUT right above.


> }
> 
> static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>index 2c296b6abb8c..5272f617fcef 100644
>--- a/arch/x86/kvm/vmx/nested.h
>+++ b/arch/x86/kvm/vmx/nested.h
>@@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
> 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
> }
> 
>+static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
>+{
>+	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
>+	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
>+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
>+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;

Is it a requirement in the SDM that the VMM should enable all FRED controls or
none? If not, the VMM is allowed to enable only one or two of them. This means
KVM would need to emulate FRED controls for the L1 VMM as three separate
features.

