Return-Path: <kvm+bounces-46760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4805AAB94D5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 05:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE3F27AEC38
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF8A22D4C7;
	Fri, 16 May 2025 03:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibrpTy6K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD2C20B807;
	Fri, 16 May 2025 03:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747366842; cv=fail; b=LVVuPF1K0TaQ2cEGWjWh5jNTR65ZOZmFSKML85LS5uZxAqQgdhs7D67/E0hSJR8GJ5G61iWEnspq7Lpjzv1va4t9fbIarWALl5YfUlEs1eNzaLHmNjOnbSPp78CrMljETzoW7ksv19VQvNOFzyGFUYkaabFjPCSnF+DlgpPObgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747366842; c=relaxed/simple;
	bh=OrVRshEy4kEneQQ12wIX+aSFdExhdx7Tjk/eiCHZUTk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T7CwUOa8GpcLMV58BFD1BYZn8oSIK0muRHuTUTsjBGKv9AZBHleJ+qxIwPCFaTNaLMGzFt/udW+KdnV3Scrya5m519Rvyg8KeQyvis4g1TpWH01fLDVqkw0mnGvpXMvbO+5vMW5MVFWsJwklotr82cG3J8QwXNUtzOe4ianLVos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibrpTy6K; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747366841; x=1778902841;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OrVRshEy4kEneQQ12wIX+aSFdExhdx7Tjk/eiCHZUTk=;
  b=ibrpTy6KCVfYLFZcPfYrJ+y9WJIIYfcm8y44SBkzls9KVRxSdepHJe/K
   Q4BFlrqAjaNgbGXvsk7QCwGhR2KQGvoSXBQ2e1ebmRErenn7iy+w0hLQW
   tv/fT/uFDVH9mLzLniBf+51w9geqXlejsbsFZbALkxpSSG/21E5S/c2Hp
   1nztgIOESOVa/T0lvocCFvs0DtAe/n+AGn3GhNk5qQAbSvqDzcQmb95hQ
   LzBvXq3QaWvHgwCHkoZwRgDTSOsN2rHEkXrztU0Lqsj2pHyeUrTj0IMCE
   IcNgABh8zdzEl5mB4QP0HciRmTHPS/N7b/J9kFIFt5uPYKvDA41kmLXL7
   g==;
X-CSE-ConnectionGUID: +j1qmtNxT1KLPVGEGW0LIA==
X-CSE-MsgGUID: 46GObYClRCe+i3lQ2rB33A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="74727873"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="74727873"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:40:40 -0700
X-CSE-ConnectionGUID: jT5e2km9RQuYDEy560hZ/Q==
X-CSE-MsgGUID: DlWi4RBRReucNGCRoUk6Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="143801173"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:40:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 20:40:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 20:40:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 20:40:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFoCPvzbecis8wv0EcXC0obZI5gACCmJc4Z5sjSwTFAzKI5/x3MyFrWhTAnUAHBm10c73fJyMnKyHu+qTrMa/AVqhN9LTLSATLP1gabSkyC3jRzvJ6d8Ny0v2T2WnTygsE1lGzbZpN+Jww/TjbflqXwpMkHx9E17skhqf7esAwvAvRm6elRQC7soSIRXpo1iLjBe8NpzeAitmTrIZUuYq1P5sGZ1KJeOO+Kz6HOKdCjJ+6BXO4+2euYgQAe6WLWvHlzIcjMokdSXQF5jATR57s3+xntMNOmBgfve7cl0c6u64/Pk2pC+6Rc/N6vBsakf316jVi7PrMu53wPUzsUEBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6hPSP6n27MljW+nf5MM92Cs/oq4nhvtSXPyI6HO2uU=;
 b=YHtQtb2DZDPPBZ+3wFY4YTBSWVR+vNEPWJs+iM4+g4YUXzIjLtBcHgj8doVtHbVippk/+frDbGu+NbvMWM6uW0GXRCPc76SVrU4wAQizWIlFV5UI+95MldF57Z5Zjfc3zA97iZL4XfL92n/+3UieFj2jtgF9ub3e0cfd4DIBzv8lhSKQeR4BpJEHLt0OiCdk9M2CRpMQILNkKpVpuNaQL3eQSWg0zm1a4Vk6TgkBruoys5oDuwJUUdBhFyyT3aax6/AqPRsJIG0AovftdsqXY9VppV08Y/W4L4/lItHivwk+ioSZr+6CpZGZqOj4lD+qLKJsqBiXHXm3YU+EZhJmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB7150.namprd11.prod.outlook.com (2603:10b6:303:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Fri, 16 May
 2025 03:39:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 16 May 2025
 03:39:50 +0000
Date: Fri, 16 May 2025 11:39:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Sean
 Christopherson" <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	<linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 4/4] x86: KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM
Message-ID: <aCazfDoU8DV3s/mh@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
 <20250515005353.952707-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250515005353.952707-5-mlevitsk@redhat.com>
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e9ce6d-a011-45dc-7a3b-08dd942b4fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lem1mxaqnt5bNCIQNPOD07WjF6lSl2KBY1tTS/YH+F6ZqNpDmFOsXNOBkb2h?=
 =?us-ascii?Q?nkM04UXQwLqUg/anGw9l8Wkvret8Z4zWvPwY21dYJM5YXL6ttw4TF2Cl5d90?=
 =?us-ascii?Q?MOvIEvSP0WM+8GjRqC5sJWHG0aDrCb12Be0t2ID61wfRNirzcq21n4bkzvDv?=
 =?us-ascii?Q?uHrN2d4dAWyOhZ7KlIB9XO69c+wn4fM4virIcC4uzgE6+rxOzMR62w3dh9eO?=
 =?us-ascii?Q?ZupmzxnVImKqM8kM2XcycFL0uvRN894ySauTQfnTh/aCK65JVBwp+bbbCHZD?=
 =?us-ascii?Q?HfhAWR2fzYe+IBx+7sQGOF1/79NFigHILylq/AhTB5bVT3Eop9WEY5RXlDEw?=
 =?us-ascii?Q?W9x+OZiPcZrGGYs3j/f8RT0eKSFIXC5ItDRVtVSmwSPB6y4viRR0VbA5Oeb6?=
 =?us-ascii?Q?JHKTmjohpQ31ZDecmpWNqnbpjHrHXMjQOaUN0wcruKjzHouawckoKHMTOyHS?=
 =?us-ascii?Q?hI7HYP91dkkUwIHyGhcmE328iQP6MAJZeB8SU/mUngLJ3Dn6fR2o/k5A+Rk9?=
 =?us-ascii?Q?/djxS1Gv+80jQpVOfI9dSnbIPXITsdBZc8cmEHKixKWB+GPPUn5JbsN/qjHc?=
 =?us-ascii?Q?luRDZwWjbVD4HQlUcnay4AFE96ADSbCGwtTtPz68yQpz6b/eG8yWLIK2zcex?=
 =?us-ascii?Q?iQbG/f2fTuk+7IKaPxErs/GPdnyrjM5yXNrasVrMpQxLMK+6ofjuowAskoHr?=
 =?us-ascii?Q?t87dWjzGMtgdUyt3jk6opXtnGUzOUJ9MvXDcidUV2VgriP8tJix6HO+3rS22?=
 =?us-ascii?Q?vrGePhp4Obm1e3Y3tv2TGXJjb4nO786VEjjaBS+8f88gvub9DrWCQ9WErb3j?=
 =?us-ascii?Q?iDcCk2BgjRWQDG0UdiLvkyvNXvKnaRAasjH9EnOSXlE6+DEyuMGWxODhcbd/?=
 =?us-ascii?Q?sTNbDJjGfDvROA8dtgtme5PWgqIdaBg3pbHlJ435/6Av81UGaICjull5l7k2?=
 =?us-ascii?Q?O/jqQWlbA8ToCgxLre6LE2UYvkGYaGC/VZDg3TBK9KlcfWbMqa/JlopeCakq?=
 =?us-ascii?Q?sNFeTy0dAuvbLB4x+xC+sruKndL1HT1qzuLhBhojyih84q/05pCx4b/fl/FQ?=
 =?us-ascii?Q?Sg6gQYj1XC7fDEKf98129i3J0CSRT2TCTzRFZLoOtW1S8FL7bLlBOQgjQhSh?=
 =?us-ascii?Q?7CfWVA3xAdxeRgS3rLqrS0E2hqrPkMIF7Nrl1hC8bMX+aM9p1kiJG+8+bWhn?=
 =?us-ascii?Q?tMHSB5yxhEUcU/pHUCATlF7cfbfHC5JBRAIP35gq6tjyTl+zik8uCav3W9FW?=
 =?us-ascii?Q?fOBXvLEO5Deqk2oI7Z48r9ypmuyf0/e3b7SJI3L+B5gArQ42AxF5aFgC/avm?=
 =?us-ascii?Q?Zdh4MeVnzadVIviaeiKHvujU+pFsmwqi7spnNSKIulHsJfnrVpJ3RU7ubPc6?=
 =?us-ascii?Q?gWkdSeIE09ZQq+WsWCNv9DevG+6ZvnMY7QkR1BRBhj5GBfVdAw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ajvq1LN5x9TAu1VOjkw5wwHCQ7Dx9e4txAW6KJE8/oJISC1C1JrqS723VMm4?=
 =?us-ascii?Q?fPQTDP27LWf4bA29SV/j7YrUZNTbDxUbrbJnfEQqYK9/iGaUt+mpcbSBM3fX?=
 =?us-ascii?Q?7uPlbSc0VCMWI6YwpCnJ0mWWVuZ5lkfvqGwRePSg7sU65oYysRk9unlK9skb?=
 =?us-ascii?Q?Smn/Cg3G+UQuxdZZKNc7q6InzYa5lmVSyW8It/gbrURb+mLLocAIMjUIDD1a?=
 =?us-ascii?Q?yARHlzi6zLeGGlxcaUQkttEN+B80SEcGVWLGlFJqFnLwdc1TSWTI6l1J2YEw?=
 =?us-ascii?Q?hmGawEEmaceUHrxb5jBjihjyMp2F6Pt5z/QVyjEPWcVY57tvm8YXCOpWE1QB?=
 =?us-ascii?Q?FPZbEGLsotDVemPQknY1k5VRCUn9KT2Y0WLYKSL+4dYdqas4ZHn+JOV7wuUa?=
 =?us-ascii?Q?mGIj33Bjlh8yG0ulCtUASPgs4K8eRPoNegeM8IXYkrCrNqB8FYS009hkkZri?=
 =?us-ascii?Q?LjIadJD4aXPfdA/Yz5E7CXjXwT0UzL2WS/P+10JXFaON7PROAWQke/+St/B6?=
 =?us-ascii?Q?Q4ygY4QH4nomn6ChCVNZceBPFvUSADnEW/E4BTn9plwKwxrivhsG7L0Dz8oM?=
 =?us-ascii?Q?lijcnzeMDjMl1liEa+rBO4B2yOzDwfOhQLpSpClNikC6OXEHtbQVb1lEFy+0?=
 =?us-ascii?Q?A5K/ByZ49I3gOKd2I1PNt9Bz2mFylIsMvXUZnUzi4v5DL0327bcKw2tBPF7+?=
 =?us-ascii?Q?GigK1wyjPYecvtGh+irJ5DShX0GkZJmwhpQT97uDAjoINqn4ChlZOKmMoQA3?=
 =?us-ascii?Q?2MD8AvzLm9Tpi+WRdnBy+N8f+IdaWZsMzotr6jRUAzTL3B9bJRYAyc2jk9Lt?=
 =?us-ascii?Q?U1PQcZoBMXchL1+m4RlFO2OdEET1g/DE2z7SQjFe7lXLt1kYB5+JwCA6msmn?=
 =?us-ascii?Q?zGxrw08JCn4v/CubNisuBpbqrXkY/2h7Pb1h0TErNUanX2GA8Dpn/TVgXLqp?=
 =?us-ascii?Q?45OmCJY+py7uQ9eyyYvnVtIfgJeg55zRV6MAjBLq6b//ihE/2qj60zw10t4O?=
 =?us-ascii?Q?hGOamJiIcTHt0N0r8tk5/ZTTJB0Tah5PW9TOiEISDU9A9choeukt8dC1i0HB?=
 =?us-ascii?Q?ElUzDwQBME6darDLF/sfTFaTMQSJjV82v5IsfNMv6e3Gty9Og7tWdxBxoUcK?=
 =?us-ascii?Q?ejsuF+mRjxyxuWxsxF6nY3GEXBOWYenygyoQhyzrECj7/2VrdUomNKL32SMO?=
 =?us-ascii?Q?dUOQAvu5/Ci8g4U/EPg1Fjwqu28P5XRDVkTSCMn6M71x9HmdGWm9RBg5zff6?=
 =?us-ascii?Q?bGt0q+O8wrmURd0r1GkYr6EA7k88Z36Um67wqYYWk8BW9zAU0Ss8AYQQv2pk?=
 =?us-ascii?Q?vzxpoiwKK9tbVzc8n9cpLe2L4h9aj/254EeO1RCGVS9K6XLUJWGyWTqjexlW?=
 =?us-ascii?Q?Qf7Pn/LVcorkHykfefM0JEkpHcmcPfuUyCZ3ycPeANB8DxsZjqUn3yJG6UmB?=
 =?us-ascii?Q?6Vx29bbrZTTS0FszX3eLU1leWwKI2jMzmMpAOn2l/aNZtnQY0geVI4fUz7FN?=
 =?us-ascii?Q?UvX0uWA54gM6XtsdBGfd1OHVpS5O1ROi9MdLzSAIKD4MWg5uiRnwjZ02pA+C?=
 =?us-ascii?Q?sLNopHj64Xcdy1JokHV0XLzEx7P+JVSBNa9N9xkI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e9ce6d-a011-45dc-7a3b-08dd942b4fa8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 03:39:50.0667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AX3PwyNIB26huJg1bEFjqusjKlJ9L6Bs3ZJKKjyy11J8yNu3Gyn4SgcxBx8CsthLgCmccl82jmjrO6sis4wIfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7150
X-OriginatorOrg: intel.com

>@@ -7368,6 +7381,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> 	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
> 		set_debugreg(vcpu->arch.dr6, 6);
> 
>+	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
>+		vmx_guest_debugctl_write(vcpu, vmx_guest_debugctl_read());

...

>+
> 	/*
> 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
> 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index 1b80479505d3..5ddedf73392b 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -416,6 +416,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> 
> void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
> u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
>+void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val);
>+u64 vmx_guest_debugctl_read(void);
> 
> /*
>  * Note, early Intel manuals have the write-low and read-high bitmap offsets
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 684b8047e0f2..a85078dfa36d 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -10752,7 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 		dm_request_for_irq_injection(vcpu) &&
> 		kvm_cpu_accept_dm_intr(vcpu);
> 	fastpath_t exit_fastpath;
>-	u64 run_flags;
>+	u64 run_flags, host_debug_ctl;
> 
> 	bool req_immediate_exit = false;
> 
>@@ -11024,7 +11024,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 		set_debugreg(0, 7);
> 	}
> 
>-	vcpu->arch.host_debugctl = get_debugctlmsr();
>+	host_debug_ctl = get_debugctlmsr();
>+	if (host_debug_ctl != vcpu->arch.host_debugctl)
>+		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
>+	vcpu->arch.host_debugctl = host_debug_ctl;

IIUC, using run_flags here may only update the GUEST_DEBUGCTL field of a vmcs02,
leaving vmcs01 not updated.

> 
> 	guest_timing_enter_irqoff();
> 
>-- 
>2.46.0
>
>

