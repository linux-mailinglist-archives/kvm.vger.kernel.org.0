Return-Path: <kvm+bounces-13971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0558089D2A8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 08:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39634B24023
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 06:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6174F77F3E;
	Tue,  9 Apr 2024 06:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WuxEBdyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0E76050;
	Tue,  9 Apr 2024 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712645127; cv=fail; b=hg3GiNHXRVeTkVBNsqhqsKJgLJW8VN5elCg/WiCCdoz8u6HIrrbIHnRXq4fRDgRwTMMqQ+4C5nnxMp+wOLY93z2seqVpnmNgsrk9q4Rt4IzBxybRQh+UkHk+8fkOOuklhNEVt2zu5DNVKGb+rBhHyVa8FIRW0eJA8quh4D+96Wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712645127; c=relaxed/simple;
	bh=/HJylPLjKSDJMCnj2lhYldMO46cvuqYBL09uR4dfnWA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fIvM2cllreH86di6vj9oRji7C7iH5lfS/1VGu+2Nl7tJ7/GPkjBfZZjevbexFfPHKKSTn3zKhPIWEAQ+bP68xEKMQEz3HjO0rXjT1Pcxbr0AM/8rNECQ0MiNHy1Mh0I8VvonPMVJqh7yQZrTUQzfxquJ/VPS0F58NRj0Lxoj7/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WuxEBdyQ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712645126; x=1744181126;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/HJylPLjKSDJMCnj2lhYldMO46cvuqYBL09uR4dfnWA=;
  b=WuxEBdyQsozr4IeBoYg0Rt4fNNNO7OoOOaIQ0d7BHZVpAWzQY1q+N5jd
   jIL4t2b2SWDLIBQQVXevyhQ/psrnvGLduigpfwXAguOUYHjkl2K0HTxyl
   xIJLbh1rq3WsUnb1CJEHFElPUgpNPLU0meKp2MZ5e4wVtXkhIp5cm8muZ
   JQZtbgOeZOylm4ICUr7UQKMpOLUzhJrAn1eAgc6u/QchOvntQnWwNIYXj
   bryggQiVNsLT19CeaWClN+wOujBW5qbLHJdX9z20lcbBIWZnfu3ZGotn9
   KuNUCIGF4HyklMlG9PvRJ/dLX0VbwXDk1pBwfAbFGXTKWVpHhdTQw3qmZ
   Q==;
X-CSE-ConnectionGUID: HlDST7yKRgubZ1iiaXsyYg==
X-CSE-MsgGUID: dxYonJZxTwCnx02hxLtQrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="18513321"
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="18513321"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 23:45:25 -0700
X-CSE-ConnectionGUID: 4U4FoNJLQ6C1DJjlO4wR1A==
X-CSE-MsgGUID: 3kfaSibiTqmRuJb/fbE3yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="24833226"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 23:45:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 23:45:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 23:45:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 23:45:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfjCUslQzbK7XxJtpoX92k22GXnx2tilvZ1b9L260rcxN2Frw8xvjX1HsVL32q7qIruatsaSN/oz5ZtI4yV080TkDT1dByr2SH/SV248+miJLdZ1enrhSW1nYpqsBDNMEYsdAMmYPL0zCHA36zZgoGDFdOVMduv4aJppTbi+IxeqJdCox3+rtEBpO8N7+6HT++wxJ2C7k707vsUJZnKczNEkjptNbSAcuaUY9nfCB+Y0UkqvlvXvDKN4cORuzZvU0QbE2XAO3+N1QeY+VKXVkr4Xr7g/3BfKJf149o1D1H+64rWtob2Hph3n+8V21XELGtMll+JbXxj5m353MW2b1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uake5gp3us5fpIu4zcsQg9rPkSZSxu9rKwa4awvpzM=;
 b=YwVUg/oz0V1IvOTABpr/saCND2uBLvnH44dqjkIZenMCOW0X2+0pO+1hK+m+KboQKv3aQRez7LCTUGBwiKhQhXoNb7npNk4L6X4Y6Qp9Ftkit3GsXGGv6xqfBYuVN0RK+cSV9It2N/q/Yw8cnh+rXEW847DcSJxdpImGamL2xnHWwAcXuxoQkEJLzVlzES/xY5vl2BhXwlCG/3Z2pgUlnDdrNTxpmo8niV3QY01VDeNXMfgodrfeaqpe4Q0y6s1zCy3zP1DA8w43MjDkMx+bLM0dOOn4fYry7Ik22K1uUh+0L4QHj5P0Szw0X6RVw6a4U3tdVL1fwd2bejFQfM3plg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.19; Tue, 9 Apr
 2024 06:45:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Tue, 9 Apr 2024
 06:45:15 +0000
Date: Tue, 9 Apr 2024 14:45:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <joao.m.martins@oracle.com>,
	<boris.ostrovsky@oracle.com>, <mark.kanda@oracle.com>,
	<suravee.suthikulpanit@amd.com>, <mlevitsk@redhat.com>
Subject: Re: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
Message-ID: <ZhTj8kdChoqSLpi8@chao-email>
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
X-ClientProxiedBy: SI1PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6390:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2p8ogftL0Fgp+bWGS4fl32cSexhpkOidgbmqWtrVqrITDaa5GP1EVnWrLzsDj/nL89ZaCo65HIcdp8ODR9WxWW2hNIUhQbARpDmJcmPX1mJMUe8ZaE/aMv7vXq2VWKZBece90m2S5sy3UlPQ058LdPgKFRwUnTAh6R217+qL7F1ASfCDXP1jnOk1UrchjLsxqk1I8lAy/wZw+/wOjxSM7oorCC6L882zIqVQ+unUGvpOAoYE5ZCRIfZIeMxHJjPXaSAS+txawAAuPordzPfy58NBtPVh6X++6/yZL37eAGmxxagIegi/3N/CIRnJRNyr3BCxI80PhEes6K9SaB3ju+IpRnl7XqRUkBNyDJ7CZ21gAkuMiFOfPpwMGl0hK/j96lKHfGEry7Wne9M2n53x/drNYXXFSptokdjDqIb5IWwxfN74/7b7W/sxK1123IEbWktXt00K4xj9NuKeYY1OMm6Q9afyFsP2yLk+FYnrs0oi6KDKXcsl//2P49J/V5nrnrr+wQWwJSo8AbXCwt1zjlqUn0/5AFg3RCBWTiTKMiNW0xCo21QQcfNQTrv9x9Pc6K07SDlB5PQpyKTX2XBGmcnUKV7iGv+5giiJ6LTadU2Q4iwFItK032qUVbokzCxfKEMVzqwNDc7D9bgQRGm0pfidqOsqN6+ThpudVkciiQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LE4OkiHSL9doDYhf1vPim3Rby8hJuYBSp+lMZjyvysjNAhaPXdovnTsVWrnU?=
 =?us-ascii?Q?yMxO6v8zOmbup1DvzX6JEqpKhSCgAkcsW3Mat8Hx19NmOu4uzxuOG5FX8bEy?=
 =?us-ascii?Q?WspWWzb/UKOCuV8Dhp3P+iHV/fg0s6sPUPJcXEsFDbaexfgJkHqiaCfz+wMS?=
 =?us-ascii?Q?RMIYr1qNmiw57FTrStKmQnolPcSnmTQXFcc+NoHDHexMlL32nx+NRVLVZul0?=
 =?us-ascii?Q?JjoiD5c0o4wHkHnyRUJrFG3Xl0/NovPYqHSKkARI7Pemmm+WitfcX4dstJVx?=
 =?us-ascii?Q?xoXn/Oo2e0qxXlDuxyh6HOJtc+BOCB/2Vy15Kcat7b74fzsIp2+ir/Cjsd73?=
 =?us-ascii?Q?zSDrVS2x+bwA8F4UGZtCSI/LBddJ+exP+6xI8Jhdq+g4JTnr80gUB+GgyA9z?=
 =?us-ascii?Q?iz1M2ydUURgMUW/9rhcPYPq7cSdYGI1o4hOkdtJ0KGRJjnH1276AqLzRmVkm?=
 =?us-ascii?Q?p9H5drsfqg0Ds/ufBUnoKpYqyCLxSYHn+0HVPEzjzcZAe0ASS5BEvMypNap5?=
 =?us-ascii?Q?mF4TaZKMk6y8lVzwVDy3PXZdiHFQVSQMGisIUU11w3s0VZ8426hDe536n3Ro?=
 =?us-ascii?Q?ldWZISBR2A/lBdwMQnebmphAWTXuzWvUaVxfzM4j9/C6u0HFXODTpC+Tm98o?=
 =?us-ascii?Q?0KpeRE4I7mLtgVJ6K0OuSPi/LNAOGRyBIj16diNoThQsxGakYawMt6TnzVRu?=
 =?us-ascii?Q?X+zc3oIq8H8slaTQ+6gjxsRQ4rrxFLZtp0e+kJ319dv7fQtCxbOhKPF3a67q?=
 =?us-ascii?Q?o2Sk3EZzPw7kRtypHy82EqOFOXmLF+VyTUqw0HYytc8aj6tHodhv5x7Ki+5C?=
 =?us-ascii?Q?SnomsyixR4eTZWTo6/Q1dZzJnIPNO7/rrPnAYsALXy//XxYxXvqU9z1A8CRv?=
 =?us-ascii?Q?WUsqAJRAiCFe97nGDJ1HXaCZkazMHX1aQlBDU2tvpf45tnmfn7KMXuO1wBGX?=
 =?us-ascii?Q?2gYKZ57/imGZASUWKnyi+Wm6zSU2xvBjG4dLhTLXn2G3iz6ZERUMlnItlD6A?=
 =?us-ascii?Q?/9oMFKUvIk2ATvCQf97d8ZTMRCm0DO6uciUo+gzSBk/EGTGZUTNeplLV89bK?=
 =?us-ascii?Q?CMFm812mL5oLte9YzJI6wexK6JuSbEv7ryv3B5kcPP1RiFUjc5n+5B6UQnY4?=
 =?us-ascii?Q?e2uiHH0Lyiy1kZsKpqd5dRAScPXokPD1jJQ/qsWkDzRaC4o0tKJNrzs8CAUG?=
 =?us-ascii?Q?lUWLfC2q/R/7Yg8nSmRdkaaoQiymO6y/1T4FVpRN0pyKY/RuqfoVU3R5ZOMx?=
 =?us-ascii?Q?OyZAysYcDL63DQVdZFH1FHfFdrfred9O/XgYDQtfaXH30huX4PA/mgiPg8+h?=
 =?us-ascii?Q?b7eA1+oY3srJfSC+UuVM0vcJAAyiRwK0XdESAkfkG7AYQvklI6m37M6ZgRco?=
 =?us-ascii?Q?dhVPFikthLvAf68TjLJiDImihCtRkqiYtHk+1K8jVoIWPMXkPfBNAsQ90DLN?=
 =?us-ascii?Q?6ncuI1VL07nZlWLVs3Fv7yCb6gR0Lxun1sCgsoZurdORWmSPYtywpsl6cjTq?=
 =?us-ascii?Q?gWq4hFU9O+aWyGpLCcBB5W+jCdWmxFd/VRlej/HSv0rPFjCsNxfKwsy3RgtJ?=
 =?us-ascii?Q?ZeXyZLukCOoEkciyArjjt9xr884sig30JGx7SCae?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e76afa-8fc6-4511-83be-08dc58609d07
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 06:45:15.5574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3yze2RBaZpQTg0oN8m5pAS4/jgLDChSm4e1+wYQPBp8BDXOzhN05gZJyOFkxTF1yussIXkqeVlebMaqrP4njg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>index 4b74ea91f4e6..853cafe4a9af 100644
>--- a/arch/x86/kvm/svm/avic.c
>+++ b/arch/x86/kvm/svm/avic.c
>@@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
> 	 * bit in the vAPIC backing page. So, we just need to schedule
> 	 * in the vcpu.
> 	 */
>-	if (vcpu)
>+	if (vcpu) {
> 		kvm_vcpu_wake_up(vcpu);
>+		++vcpu->stat.ga_log_event;
>+	}
> 

I am not sure why this is added for SVM only. it looks to me GALog events are
similar to Intel IOMMU's wakeup events. Can we have a general name? maybe
iommu_wakeup_event

and increase the counter after the kvm_vcpu_wake_up() call in pi_wakeup_handler().

