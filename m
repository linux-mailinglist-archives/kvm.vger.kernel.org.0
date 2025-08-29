Return-Path: <kvm+bounces-56277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C407FB3B911
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A4853B2CF1
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C4D3093A5;
	Fri, 29 Aug 2025 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zd3RsjaB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27148308F28;
	Fri, 29 Aug 2025 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756464041; cv=fail; b=JQgBc/8luZIwLbxh81p7N3WUWTp+nMq3IYjjYQDz44JyQVouMO/BURLJFFDblyLrvsdvyzcyqdUQ3SXHZMne4j2iMnqUPlRARxttS8DDFX1sWOSLuFACiGTKFdcO5Q9gIWLPVG/fHTSBqs19nUfHtYs//lb3naq7XL7ix5vtOWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756464041; c=relaxed/simple;
	bh=7xZLx5OEc4kc7SQXHfuQF1AeaQInErAQm2+Awn43U7Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fshNCB6nf3HrSuBb4CM4pMnDjV4NlbOo+DV94r+eMzg7im00MSKL9F23IesHk4WbueN+nW2BKmrSn86G2zaL/q+8fUE208adadeEvI//IZRJ7q2bvccK/6qSBmWhuX5A1faIHQ7h8EXFRvWZb6VIYpaMCzFIs+hI6E51XSQV0Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zd3RsjaB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756464039; x=1788000039;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7xZLx5OEc4kc7SQXHfuQF1AeaQInErAQm2+Awn43U7Y=;
  b=Zd3RsjaBMjvy7EJJaWMfkOVseBIicvuVCeerdXD+dzuDjar1qQVO7XuS
   UZGAcP+EApizhbE0aVs8CHcYDMO9VsguEV7yDet5w1XIhFZTY63o0H+Wq
   ojj3qTU5vv2I1U1Se94MbqKS3Fz77qMn3Qsos9JZ9rXlCXTwKnXAwf2tE
   xCRjNlFXM73hkqrp9Lhemmg/5K8w2B68rQLEN88h2fYALZcRUZfjZq6mY
   PGhXEEq6Favnkg7ITCFoyQLeiHkV3e/4OVv/MHpDOMiJCpTyNMA9OV06e
   KVQ5OMC97QPrxt1p4iN1MXoPiFpJ9eNrb0uZSwXxUaJERncHYlmXfkxyc
   g==;
X-CSE-ConnectionGUID: 2yJqTZ/FSvySYCrpNpy27w==
X-CSE-MsgGUID: tc+zooN0SDaMc3Ypl31CCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57772670"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57772670"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:40:39 -0700
X-CSE-ConnectionGUID: g7jIKZm1Rnu1l59JwoQJrA==
X-CSE-MsgGUID: HXBXMcVTQN+8HTnqOpWyYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170257548"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:40:38 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 03:40:37 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 03:40:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.75)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 03:40:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uaEsvpWo57uUQB6NOSwfI3Jcwy9tpK3dn0USWi2xcbgIHpU077yTR0ZMWtUDjlJ3AFQMgmNLNWiHYJN/Gn2uBoHHJYAqDS2ZjIiCbVAQf4rfKhufknvE2qZNEeWgB91HHO/IZk8IPfyrMehjizNd8AumuSCafqHdeP4qe7bscYfnkiwfg9YL6UisMBOpyDh1vMh7ZuupEdXlIszWKivwLBeWdm8OjgMrzmIDn6yXH2pdBxOhyMCqbDK8AhSTRs7hJjHEkEaagNEUcY2WKExp3OAQRoXWt/nYJjET0mxIC+qPvAyo0iqiGRW8hOJ4KFH5AYp3qwN+8SuafDn94wgCkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Oq8lqiC6d8oazXYHDV4WS88I9sdyvF22yLqzDNdpDM=;
 b=TKk02ThtGgWkiumCE1UZ2W8mGFzmgV/IoRmHPPOcUVtI1dabVg7FcB4XK0mxpn8IW3F41tB+R70B0LLDR5y8nR1G55JtFeYdiL21Jj/0WFXpwNAbeqtQceqVdw5KEz0YpEWRZy+T3xD4Yt8UNrtD9sEkYCkJlMfelDJHoUai+I1CmGSEwtY7/5Vpxe+0+oiTNGdpUXSvPLp2KhQJxTBg55NnV3zORhEmaJ4kgYo8VFxURam7sLkj05ikWtQwYfksj/EYlQmxpv3EOfQVQ+g2+NfZU/lr/OYXRm7gC+7FgOfQyyhIxec8TYgjoTqREZWxER0z6FOG6a9o5Vdq7knRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9374.namprd11.prod.outlook.com (2603:10b6:208:581::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 10:40:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9073.016; Fri, 29 Aug 2025
 10:40:31 +0000
Date: Fri, 29 Aug 2025 18:40:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>,
	<xin@zytor.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v13 03/21] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <aLGDk39uByD8pPMW@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-4-chao.gao@intel.com>
 <5cc4f58d-d122-43ca-98ec-eabdbe5bf110@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5cc4f58d-d122-43ca-98ec-eabdbe5bf110@intel.com>
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9374:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad9bef1-8527-49d6-36f2-08dde6e87a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KW31ZP9VIUMMzD3G/y5sbO07LtgWnXhdfO5FTN4DYo1V5fTtp4oSxJU38aGp?=
 =?us-ascii?Q?JeWc64UiRuOQaem1lET/LRqSDi5qk0CsgFC+kE3gg9ACqxUAbvcW+PxuIfX5?=
 =?us-ascii?Q?nG8qmK1Mw1x2mMOfXB9cQyc1C+R9RLtvBv1QRoPDHxEBQGgRv74kAWnoUdYZ?=
 =?us-ascii?Q?9tkZBq8YukzNymBsL8Q6gOYm7WknIwcjWY/A1vSbyOxcc4zAKkSTJfilH1iZ?=
 =?us-ascii?Q?pExI30vsa4fMm2/ocgpMZd0VN+hB5FP5YowPb0n6GGPbD2xc3+skOIdtRIWN?=
 =?us-ascii?Q?dmwCkqkKc7NCZ7dAfIKkXysMwS4gRVClFTTLKnCvFZZwprd7Ea07FKeACMVN?=
 =?us-ascii?Q?Tpv2P78/s1l0TNdx2JrNkYH0JZyTInmMduk/347baBc/gfLbdv1Fpb8Wck8P?=
 =?us-ascii?Q?mxpPjRqGHswLccil7aLHih2uj3DzGJ9TYHYXV/zS9d3GIYXdJ96K9FhV00//?=
 =?us-ascii?Q?9dJ8QkZu9FC8H58ugAS3ODoLII/7FhhBrMjTlwf/oiM/oXvs363AqIKaNwAX?=
 =?us-ascii?Q?nRUYyLfjVHnkLutc7fohCcWbVcm+9sJfKG8KHxSCbDWW2Q932aAMOnPiuC5B?=
 =?us-ascii?Q?Av/GWtPxu+T3x32Emp47jywg+Xm0UR/wUVLqs7Uz/Z9WjeiGprYvIPNk7Nv5?=
 =?us-ascii?Q?bJjqKP2yXMHqr+AMG/8WXjl7/3Tmz37mBgmzmpfUyV1ny+5c+Jx0GtRpqs2j?=
 =?us-ascii?Q?l/oVousQZtIyTlTLc8+Uk7vibvW3XlXoGcg0iKxTrkOhOMHdnJ9IlQS9E/3t?=
 =?us-ascii?Q?t/nd1XJejavgXjaT48jMU44Ys4XQKn/KElGSBGlKTCgZs89rDKjsblrbL8iV?=
 =?us-ascii?Q?rawNNV30COB13omMQHxHU0bhybGRG0MhA+p1Sx32ZVauw563XlyGkF2AlJ6e?=
 =?us-ascii?Q?2jb9/CDC/9JxBBhMVTdJbB0IwSjtKdVd13QRTBOG+GnbtsUs5QO17P62k/ab?=
 =?us-ascii?Q?TBrnT0uH1InZIw4cXnlaH27Ex9j5y06W4dWC2Hl1Fwbz6l3ds/8qBTiIcxu3?=
 =?us-ascii?Q?UfJQJ2dQZW0Ldfczm791NDVCXVB+vZX6b0meFRqvRWa38T22apLZbo/g2rHn?=
 =?us-ascii?Q?GY1jwazOelysQP+hjlSoHbSiZyFYNXhPc9RnM/buEt5bRFwFupujfypoYBQZ?=
 =?us-ascii?Q?4mh8dMk/T3dKDaiwLi5jiNr2LCcip1uN+IQb7uTpZGKl5C8DHGIRl+VEPb1/?=
 =?us-ascii?Q?6iKOQqin4aLd//WL1q7GTQ6lb3NAbNS8WSCMrmIzhwMmLq3BbVmP1gK919xl?=
 =?us-ascii?Q?GVawAd0vtL7/wUNaFh/YXa42a4ywDJumd0P99jaNec8sx12mcDsw5tAQ8Xvb?=
 =?us-ascii?Q?Ty7qkktkDKhCCxZ33JoTxs4oyftbmuZmDexYyI+73cwbmN0koOOG/weFPG/Z?=
 =?us-ascii?Q?78kwivHYOYN4yGiS5k10zb28rG/ukINdL1pxle5irYLrm//DPe+VmocmDU2u?=
 =?us-ascii?Q?t3f3bCdEJQI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sT84EJJPeBiiuTFG9ccx14nOAwla70ybSFDRjLLQqMTkxWJohzuSsBflF55e?=
 =?us-ascii?Q?L+i9j+jh3gKs9j51ViRDK5AXpmmZcwXVTk5GwTIPNau75oEeUJH/qDSmD1Gx?=
 =?us-ascii?Q?aqmrYYuDYlVc3iGKCS4iQVwxVqskhpjInrJuvOwLd2bEc1NmdHSfSaCmZign?=
 =?us-ascii?Q?Ys/yjBqKs3jeuqUb/iX4R5C09WmU7y+Os4BFXarJGfSy8uET3MmlGcg7228Z?=
 =?us-ascii?Q?fSiiKgelE4pVEVJi240q5XwRaYZcZIRseuyBgONafR8i5U7UNm05EA9BAEq1?=
 =?us-ascii?Q?9ukB4Bk0HO+boIUEaAFPDhaQwtwzDhYbluT6G8wg3lW3yO7RSIwLtddSNyPS?=
 =?us-ascii?Q?n7EDFwHD3swCFaxFTrm7a7OSBgPTPDMrykcJ29Emlom/71zn7MkNnXDIbNeQ?=
 =?us-ascii?Q?OADaX82QdllYxCyYCGpna4BTpbR45UBQeuAS2biY3wMYHlQPSw8AizPJc6pZ?=
 =?us-ascii?Q?aLtUTc+otU+qx8md71FL6KJFvRmaej3koUd8sezMXGPAzewWkjnBpJNs86ck?=
 =?us-ascii?Q?y+rqqDbBUE4EPXvbqXsfqjlEg29S0vxrUCRsSu9n6lc/6dqZ1wUi5B8Wz/g/?=
 =?us-ascii?Q?XtpUjgmnQ6CCrZAhKF5fmzWKbwEPjraOFTVR3LtnJHsqn7CGoELhL6EX0+dE?=
 =?us-ascii?Q?qsYycf57oRfqteQdIn0C/F9dyXZg73maYJ0k+qqcEA68F+LsbCQpxbKNLwF3?=
 =?us-ascii?Q?45/pzrxIUBTB5Xx+bSgUCqgKkUHlftco8mnpcbcMNc+Ecx49OMwXQz9hDjKe?=
 =?us-ascii?Q?uT+jTaWf9iu2JLjBJ0d4sZFTNjTgdHGD3ZIwOaIIjzXmRBXkMXSLNe9Kqt1G?=
 =?us-ascii?Q?kKiq9xEbJaq5hBacEZyFZnuHqcG2qXulpIsWK8jZT4eLaRmmN361kBi2Uzoa?=
 =?us-ascii?Q?TSkcOs2v0mNCaChaTtC6b2unIW8RnQGcFTBP7IcxSu+jC/TOLxy9icg5kxCn?=
 =?us-ascii?Q?njrgimN/BVZfvrzgY2Ie8gYbllr5nEi6jjphWhnwHxea2wn3obK3kyZjYfT3?=
 =?us-ascii?Q?3XkYIIC2pB2uUWAVPOg8wg/xAP0xMiglexvC5Ao53EvGsK/GXigC2THokX3j?=
 =?us-ascii?Q?DG7Fw7+xvUIdibsEk4uLZIv2J6HVp8mwrqCvY0P4VtaVKe7+xlAQWnqGDwtv?=
 =?us-ascii?Q?xVnDzESZBB+gyupL72rA8bkXbPwMT0xTqQcEtz5kcCNERI5Z/8jYMRDQANb6?=
 =?us-ascii?Q?VfqhLK6FLIBTyEhqUW422Mr9DNHcA7qP2qnrif49IlgPx8y6r5nZX/i7HWhb?=
 =?us-ascii?Q?nxbc2d2XlDlCDu+mT1svsnRv5UrDhVCeDmthO9qqvC4P249+F/jg9fqoSd68?=
 =?us-ascii?Q?OAqugqcRoT77Lg2bNzG17fkZvvjbMj2iRP07kaLCY5Xjn6ho5BBHdUB0TjeO?=
 =?us-ascii?Q?H95rm80mT3xsYz3g65/p+nRI+Q2zCLFr5Qj7+RBSr+8A5vhyGKeppicXPHy2?=
 =?us-ascii?Q?FbsxpJV13P5v9R5x9+D630Ad2aPvMrJZpQvGygIH3JrDe000Gtd4nGg31ekY?=
 =?us-ascii?Q?ecMN7OG7+H+Z6B44VW8YFFFEXd+yo9LqdRE+12WlLn6KelOWS4RAHJYqdnsP?=
 =?us-ascii?Q?0v1R4RmR5hKzuV9Fti9A9tr7DjCOxwbHBX5WrdKb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad9bef1-8527-49d6-36f2-08dde6e87a3f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 10:40:31.5873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1u1rSDOlUGAmgXqrVbtaLYeuKz418XiUwOpPEVr2+Si7l2bp+TTVBzpeg0Rb46yqmNTAuyCn7kapm0TsYgXbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9374
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 02:47:37PM +0800, Xiaoyao Li wrote:
>On 8/21/2025 9:30 PM, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
>> due to XSS MSR modification.
>> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
>> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
>> before allocate sufficient xsave buffer.
>> 
>> Note, KVM does not yet support any XSS based features, i.e. supported_xss
>> is guaranteed to be zero at this time.
>> 
>> Opportunistically return KVM_MSR_RET_UNSUPPORTED if guest CPUID doesn't
>> enumerate it. Since KVM_MSR_RET_UNSUPPORTED takes care of host_initiated
>> cases, drop the host_initiated check.
>
>It looks most of this patch is introducing
>
>  vcpu->arch.guest_supported_xss
>
>and use it to guard the wrmsr of MSR_IA32_XSS instead of KVM global
>kvm_caps.supported_xss.
>
>So it's better to split it into two patches?

Yes. it makes sense. will do.

