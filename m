Return-Path: <kvm+bounces-48267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DCAACC121
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40A47168F1D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4259926980B;
	Tue,  3 Jun 2025 07:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHuzmS+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2BA2686B7;
	Tue,  3 Jun 2025 07:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748935117; cv=fail; b=FUujBbYY3QGQeHaJ9vSUZULoxlahYbh/h9+AMVq6udO/TS74Y+P9SR6InnoHnFxOisj+ydlKd+izx/60KnHobOi98HnN3y9H3AEyrwXyqFNTLkibm37JRQa4rUsl8DvABwwft7v9yyNAhY4ILYLogdk7vkppZmB84N2tIyXP6sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748935117; c=relaxed/simple;
	bh=omEBx2b2LQngUQWPi6fg8R/V6oV7MvhoIXc/YYlmSP0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Di0ZTTkYo7jEhxzsqKyj+HvHIm30nCNPpSTQKQE5YTc2VNoqpg65tMC//chRvJ2TCAFWaPOY+rT+0hbt4+V7PxZSA0IpDz8WrlK4hMgKCBvRNcDrlqjsB400b0M8RsKGbStvg8UHn/PbJg0RSPyMSc/JLiNvqbsUBe2Cx2qRMGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHuzmS+t; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748935116; x=1780471116;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=omEBx2b2LQngUQWPi6fg8R/V6oV7MvhoIXc/YYlmSP0=;
  b=UHuzmS+t0Q0V7qPYEvd1b0AO7Ndyrdfe/5RuUgNGIbE+mkGMc1rFm69M
   fOe9pHUedQ4HRBUleu2E0L4/pGeaD9a1CAl+rVHBrT/fIO8FctQD2frnl
   6Ecge4t/VY2kI8jaTlKhYmPptc/zFDzl1lTzYVbEEJmD8LN34ClHS6tQI
   d4sojkck2MEg5LuyO81BmR8Y8vHklzsvKfhNA9Tp7A1GFnZ2vE3MRTpA8
   druiRbAOtpOiuItYINjGxU2JDeZ2QicxRimOeC+FHWcqgjvMPV6IgGv41
   GHZN+9sCd0wnDm9M7TVo3FW4KIhQzI9jy0Ugihx4TLHT/9T9YnQNT8oxp
   Q==;
X-CSE-ConnectionGUID: o45Shj8ORWiMVE4/bFxs3w==
X-CSE-MsgGUID: GXelCvrYTLO/ENtvuwuVSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61622657"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="61622657"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:18:25 -0700
X-CSE-ConnectionGUID: Fd3CA71tQ8uaxgSkODQu0Q==
X-CSE-MsgGUID: tXKD/ZH0Q2yG2Ym6ImAcTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145404756"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:18:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 00:18:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 00:18:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 00:18:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=av1hAtgAiSQwjbzR0pL/Mj/AeufAI6n55svHZF0q3fV8aOsiSPIbzV9CRfvJ54WX9N8yW210Ny8626fyEQO4WzZ1DtsXY+mhp+gfqxXj6WEAQNskUPz+sfCQftGUWx3Q6m2r3n/cYl+zel0RnmbqZJaacV4QaRSIq2rZEinDr8cm9bVBS6Mro6dAMiJlLQgSZCxX6wzPhI3chZI6yKAWzdE9lOPKHT/GX1hz1B06L/OgcK/CrCpodKfpc1Uvsdg1h/ZcTE6e9OMaB8e1OaDjhN78FjcH19uDJz+uQPfVA60VNlcfHflReSoQo7IduFRRa43qlLdA21xtMFRH0Hz2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omEBx2b2LQngUQWPi6fg8R/V6oV7MvhoIXc/YYlmSP0=;
 b=uzU/yqjDnU4pwA8hTQWJcE1TpYy0asE79SKJXMqZVlIsyD6pROBEvBklJN1FtAJP640oeTUDGT2IXRRrtUGg68SRYGE6O03kjRQ3QnmHVstQGbBnHbChivi5a0r+8VzSYihpz/7Y7dn3YqfxJ8U6XPkef4Ua1xpsIsHdC33pUMd/e4Hj62TctnENaTMHFcGgZefLgiE/olNYg0wHQOaUvgRGUMChtnwJNN2vn02YlUiniPVeMC9mKTWiSps0A8VXfRw+PjqSuJ+3YF/X+jIjunKtIHyfusnN/R4VOKoTAanjE6TPsGHUjJ5+EuVAGlSK0gatguwkkRkhV2M6bd9NdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7953.namprd11.prod.outlook.com (2603:10b6:208:40d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 07:18:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 07:18:21 +0000
Date: Tue, 3 Jun 2025 15:18:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 02/28] KVM: SVM: Tag MSR bitmap initialization helpers
 with __init
Message-ID: <aD6htXOAhR//LjQA@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-3-seanjc@google.com>
X-ClientProxiedBy: SE2P216CA0151.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: ac270fff-1479-4fd8-a579-08dda26ed26b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PVRshfZ5ghCMke4qlvdTMXuLaAogBicQbQujQCNyY+majxWfcuOuiRTThVWh?=
 =?us-ascii?Q?HqS25lUe2fsTMn6e6S5XevZUzcX2xykCh9IFrIsCmI+uV7ncpKIb/GSpcue2?=
 =?us-ascii?Q?r3ktoHgsn8xy5uxR+enhTbKZP6s/8+tlj3IOFovTOyjb7MD5/6J2SwJackCU?=
 =?us-ascii?Q?H2aiXKMe+EL7KK5IoYz9Zh9QUwMCg0HywJfDNNcihrtih/mW8j4xZxvHAmTB?=
 =?us-ascii?Q?9J21KP+ZG2HmtD8J+dkrMDfcbEaFdXFAEeRdm/aNhaXDp7LhYSX1+XiF97NI?=
 =?us-ascii?Q?KCy6Q/1PZ5mvIhFpHVeElcAOcdIWXYkU4MTvbDbleg8ammDtnja/sSu/KsE+?=
 =?us-ascii?Q?rGqGsuCQcxI1PJG4R+fFKaP8Y4H2nw/WaHGvm98BG5I7Ql2xn3NGG8IdJnfd?=
 =?us-ascii?Q?gQNePll0sjAkzgX/RE3QEjAeIABbMlFS0q1SI4dJ6WPSnau1vgi/CTVOJwJ/?=
 =?us-ascii?Q?CHC+KNrAuHOranGo3QqkanbPt4kKEQlWUb8MvfEcG+O7w8JJy5E1EnBAsXgs?=
 =?us-ascii?Q?QCgkEsJVN/De75ifweKAm6A2xhKqZjzAC8MXcj/1mOTl9K7NOEGGLPeEIwAJ?=
 =?us-ascii?Q?HOv8bx7mJA0eErALH8jvV/vbIhIaZOvBmnAzyfkTx58euMsgY+DboRip6P7z?=
 =?us-ascii?Q?EG/xE2yiOpUHRdzEVlNU5/r/y7VM2M78L58SAuijdN2hC9xPJ+tL5TyCwvp9?=
 =?us-ascii?Q?uKU3EMb/4JjC9yBKFCtjabgVlu2WvK/+l1KKdspMbwAc9p2UqaJXPwW9EHbM?=
 =?us-ascii?Q?oJlfjZhLtpaRcUS6ZZtuzC5usOrplc+zwlXsLN7Qa0eIm7TGV2LnNPq5xLhy?=
 =?us-ascii?Q?D4JS55gm+i2bXgFGfPdTgqM4Pew1AeWBzcRGWb7sfq4NyghrFTM43JymvPJE?=
 =?us-ascii?Q?L/nJAwYxfDkP/vEZJ1ronoBmlAPT9D842LgaYEXNvM6rEuozFb4e3aiLiVPr?=
 =?us-ascii?Q?qZG8OMZaQwJ6glN5VV1htNbEYs1wGJ1IGUt9rfWyYKQRqJDW/+2NGyE42tYx?=
 =?us-ascii?Q?Pra2lTl21za2N4vHQYG+SO37iluvhL3K3TxcXl86pmq/VwkeCJxOh7Y1mwCe?=
 =?us-ascii?Q?XE4JSy4q98gvFfrFk5+wZBEAbzrCzI8fklqXe31c0wRR6+h2sTuhpjJ2LinL?=
 =?us-ascii?Q?Z8PAV5opa8yG52DZDhpA6IOnMhuBKk/dd3C80Mxgrc2VV+n7fIRj8Kg8lCa6?=
 =?us-ascii?Q?8QBHkZSwSLt4m46vByiM0G7/8UR45PLqEsJ7Czs9pnd0rv/N1qN5mjK8HgKl?=
 =?us-ascii?Q?BWLxCdKc8aMkaG/CgUwZcpD4XlTUTMXPHb+jQvmMWw86282InNsnB+Zfv+FG?=
 =?us-ascii?Q?PvWRxpJ7B6SdA7nS0EMRn/AZrQy7OpRDvKQ1NXDS/kp5YK819HD9XFZR+OL/?=
 =?us-ascii?Q?NpRBNxcK7P0kOOI4LD4LkoUkqOFVPA6qcDDf1OmDZCW4c9lnNA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uLvnH4qWs/70v0O0ggT/4Fa2QmBxYCurZrGMsFUNJC+gJa/lbgfVsN7YPzCm?=
 =?us-ascii?Q?mdBN78gGgr+WV7LWzUDiEMEG7ZIg7XPCAD3tZoO529i5We0MXtVokwu9tjad?=
 =?us-ascii?Q?qWlPWeBOAnLG+Xk8u2/ORLdM4iZTYg10ayeYnmz4vP7k2uWIHlOhRh/rGP23?=
 =?us-ascii?Q?7ZL/Z2rxj9CQ/n+d0ZHliZho6zPRUSeKV1ajEea1TbGvrcesFM4Pjyp1kcKH?=
 =?us-ascii?Q?Cmeo+c5cminayyiIS4XMI4m+uw97JECZvir0TO9eL+vnQmIepfNpjGwNtheY?=
 =?us-ascii?Q?QLH6g3P1vxI5ZptQy6gIS4iriX8/G5a6O9mcYVxfmjhtwkA0OBs124JkwyPO?=
 =?us-ascii?Q?x0BvVKkER8HIuKdqzyRE/2N2hzedHiCo01kryLA7g4Tg6KXzf3P7NjVmC0d4?=
 =?us-ascii?Q?EmdnaC585OjhPe6SPiMKpL7ZYq63wipgofSb+Az17iChyLtkLDHx9R0uVl+2?=
 =?us-ascii?Q?EhAE1sahMkx73QoW+P4Gtlg2zThYfIVYqqKtHeneus2DFAV09vJqYYftzby9?=
 =?us-ascii?Q?aToramGLb449c6jAtzUMYER7F6VmXU4haFA418j1znCrUqT9hXrkhO5pJZl8?=
 =?us-ascii?Q?RQz1Qs5Jl1GFWnXltc2QdRX+7i5Q+tEsPPRbPCyLgY+X273YLe2DHAzmn/Rg?=
 =?us-ascii?Q?nEitzXvJKIn/lQ4G8/RfyMgW6nrjJmkybEnsLH23w7EXqjLOEUmacQYaMCjP?=
 =?us-ascii?Q?ghf+v+av4HKEZP9Ge0lc1xAK22KBEi52AfqRP2FJ8rfpSy53epvZ8Rdswc62?=
 =?us-ascii?Q?CtQ/G2BnLa/fiMgIdmr5P6Bz+DOt7m9ok5SaDNI7uFxPwGa9fSRXouYy8O3S?=
 =?us-ascii?Q?XdWKckfecVkWMiSgOVMdzCH4wSrv2FBiaN5B5f4Ir2zycDgNqe+jDhNTj1WD?=
 =?us-ascii?Q?2TMM4vemphnLG9vWWoEsV078TL7tcDgVz54pexR3pQ+80rDl4knf3NPzvgXI?=
 =?us-ascii?Q?sMdjZedW1cjiezluFFmA8RonaVCjD+LEQk9TKAiKDgqWiRqnuXlaAdGJf8JT?=
 =?us-ascii?Q?K0NN97kFQPq1LV+0uzhbmEuTzvbJSqBtUyL+GEb6sg5/ACEx9H2gZrvMbFlG?=
 =?us-ascii?Q?bTCjHQ8qU285vMkHeeDrS4D/Bu0ygGIXtEUy/LYRv0dO6WYlNozFLwD4ZwQn?=
 =?us-ascii?Q?toa+d1L3QV5y76b0Tm3TAqfr1NXur492DKjqjcTO9GfEs/gplItFDi4VMZSY?=
 =?us-ascii?Q?pTiANgSQNLB2Uu9EHF6liHrtjWB5NikN/fS3S+sI/ePLXvtUicDI2NgXK8lN?=
 =?us-ascii?Q?zMSgm69He1bo1azCoLcEAF6liyO0mVs1CiH17f84RQeffeQl8nRIDbQ7RmbP?=
 =?us-ascii?Q?4IG/MSLWr+II+Ge32tPjU5QjUSgujfTs7imO0xJpSzwE5j9/tqfjhuxqpw4R?=
 =?us-ascii?Q?sPT6ULDdhp4rw3fhstVbMvN94q5tRiw2DEafOjp4OjgphFD/Dl+wu5doWcFi?=
 =?us-ascii?Q?hiP0KFq3fcoJplhy/srqN6+H9POQbIt6jKy1qEQgXWcLAGqekveX+kBr1/c8?=
 =?us-ascii?Q?0VMAAHcRVTXFO960QN+Jt/EdiKa61hoUmf8aF+YoAgLoQ0U4ifeOAW8PYVkt?=
 =?us-ascii?Q?sQqhiqXJSnACkzxV1cGM7hosfF1UA4dQe4ghFJaR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac270fff-1479-4fd8-a579-08dda26ed26b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 07:18:21.8095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5nsLWuLsk0t6FyOQwJhf0XLbGjIsqfMxiWZqhmeyM7Gj+lt0lEKOxyAeY5JQ5rxuOSelFe4nZYSU+7XWU+UKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7953
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:47PM -0700, Sean Christopherson wrote:
>Tag init_msrpm_offsets() and add_msr_offset() with __init, as they're used
>only during hardware setup to map potential passthrough MSRs to offsets in
>the bitmap.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

