Return-Path: <kvm+bounces-57171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B213B50BFD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B3BB3B26A7
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B612561C2;
	Wed, 10 Sep 2025 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jlLppGnW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AF24A058;
	Wed, 10 Sep 2025 02:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472924; cv=fail; b=g2fk0DnHR3v0SVjPbzeE2h2hRxy4xMSln+S7FNcSTW3aGu/nWj9DBQCPt2dEaBcUT9mJaYkr8dQ7ZyqIg4YukzK0oO+osp25QQGaHvrS6EcQQLOoEwq6by/IED+iij2EFOxp7y0m/Q1+/LceTPXaqMKmhW/AK3blBtrE6HMQ5LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472924; c=relaxed/simple;
	bh=JojWwYr+nt/wIOvAk5MluFY9cQK8CDcJsALhdHt81VA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jmYiLUToiNeAoefBTA8cNaxKpUaY37S0o3dZJNBRZ4pSH5/lgbsBRVvfkMcExAqKHPp3wbld0kqeJWYsvJPuuKnYYhTtJBlt8tK6swas/RVGeRNwrtY4NvnM7AWEmErAt6zVT+efs7GRMSN5JvBYlS2YQg6PVIDDbrgbfVznuoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jlLppGnW; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757472923; x=1789008923;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JojWwYr+nt/wIOvAk5MluFY9cQK8CDcJsALhdHt81VA=;
  b=jlLppGnWO7v8w79Wjke6RnuEsHEKXsoSIJRo7S7KeRnOVCw8icFJYOhF
   /CnfMJhtiTfQs6CoqVCbVgR9l5cTBRd5GUHycRf4yF44ZWe6R9eWlDQLh
   q93eWFG4Y1zRa37AZJX+yvwFZXMbiQ59cDySBcAfLSONDxUiG+poPYbok
   2UCDLDf0SvyBDtleW20ObbMINGbG2+UcQOVJRtJkUOs4okN5YTk0gI7Ne
   5+O1xMzoxE/k4EBdcJ72Z/Z0ARwguGLt6XPP4og4dfVYmbFRpYUX4eT3i
   TLm+OadS+8e2eB77aCrbxZb4i873SquLRqxqkIa25c5Sr2CwvHcXo4G3p
   g==;
X-CSE-ConnectionGUID: xtPMwnlcTOqG6AOBZKqKoQ==
X-CSE-MsgGUID: W57vuBgWTXi+ppmUypoF7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59713446"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="59713446"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 19:55:21 -0700
X-CSE-ConnectionGUID: NBly692RSRe5RVbhYI7Esw==
X-CSE-MsgGUID: DYmvLY8GTKyUM5CP8PjBgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="172852342"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 19:55:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 19:55:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 19:55:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.80)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 19:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKbvnpHGlmVmqAgoSMtbyeOpnVQwPjEG2HKvH2qr7F8VRAwJjMffBbd+xdFqNhZEycKHk/J1uXf0kB1JyhjAZsAZjnCciMBpSgA0r/U8JdeDx1u9Yf4+qM+r2hRRcvnioz128XHLOIhx4Sjn1G/TlUvUaVvritiSROFWE63anRJp01IPyuPA1aIGHCf+L7IsC0f+dPgJY95zdcRPkeUuB+0IeF+ImBo6w2EXULgp+HYpGZ80oigy2ToKdoyLV8zAXZ+yseF7x28EAgs7ZXK0VQ1cpbaKtKCKJkOHVdC69BsPwz+tLkQL+bfcZGeisE8Ej5MoPVkAffGHIncPEr8C8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5VM0O+n9aAwoVUhcr2X3NP8dhzO8DLNEfNFPl7s36A=;
 b=G8MakahToLmW9wZP768bg0OKkTMPb14QV+r3ZpIewLO70Tci9X/ipKh4OtXL8QdH9dhl0pl31NOw98UNQo36euhkonAMu4drPBLa+EduPO9v2iTRwU0bZBIHisqz81mXvsZLnGXn/bd2lD+oSvtS1DfS7IeR8LP18bAc2XxlzviFJ9L566T51AHoLjvKv3SBP4RIuH6QuIqauQj5JFvgCKSkDKIHFPd/7AJzilqVvRGiDRm5HwOA9Uh1OsKGm74rLdfxJDdSr6ozmy9uGsWYwrC990qosGmrgR6uWwFuw62mEDZ+0TAFCQMX6f6tiPT4s1u7M13WhagznC4mTsXNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB6913.namprd11.prod.outlook.com (2603:10b6:930:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:55:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:55:12 +0000
Date: Wed, 10 Sep 2025 10:55:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Xin Li <xin@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Message-ID: <aMDohALPiu+cwO7G@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
 <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com>
 <aKvP2AHKYeQCPm0x@intel.com>
 <aL/i6cA6EjjZ1H6f@intel.com>
 <aMCIH-0dtjbSbWiI@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aMCIH-0dtjbSbWiI@google.com>
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 9647cd45-f918-45b1-5f5d-08ddf0157642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?n2OtxJhXy3tKxuxOYRB7hmybe4qRo2aFvDEy8CQle31SSsAYU4PMdUtDtvik?=
 =?us-ascii?Q?osXCwx+bptgbG8u4TBBfPSBL8A5rCYXWbhiKQxNcyKEmerq0O2/M0TRnCbsI?=
 =?us-ascii?Q?n0buhgqn3/77CET3EuFcd7L2KwE1pb/vD8Ji6VTHvQY3f4ydr1GJsXxfXVGQ?=
 =?us-ascii?Q?/zf/+CaaSctspFXDF4TUH4V8lyadsFXQ8AqKj9foVd7o5DmbSJXtbOuBqGty?=
 =?us-ascii?Q?llAeeS3OPT5oDe7DM7oqV45PoR9WQInS02xlPsvP5/UhK+8OrkUJgXzmss+e?=
 =?us-ascii?Q?xXFbRtMUiUqxS0l9gJrLcBJ9mTmOTsaPj5xm7WqCXEbuBnwI+W1tRZ1C9owO?=
 =?us-ascii?Q?wyG3mC45pvpubrtkp9MiRB0O2pLvAOgvFVj7U8dze3wOrDtbyrcSlht6Ulvf?=
 =?us-ascii?Q?kh5F4drKjck4f9ZeLryReA5JlXqvwfb69lhxBuWUXtJ8wSRadZujrRNYcg95?=
 =?us-ascii?Q?kTPdjs06cSN8jtgiWLppxcGfwxTiz+y5DcagEQ/hQAmgkTykoHtKczJDFh9q?=
 =?us-ascii?Q?9dADchY5mMWoLqcA6OV/N+/BGQteK6QdKLdPuovxqWIkidgaZwFiIH/JtSVk?=
 =?us-ascii?Q?UZXoO2wBC0I0ebMcTrpq0keHsRoXJPslaC9SROtPXWOXSeSYUDfPtPBJPFK2?=
 =?us-ascii?Q?7yut++Zdj9rxv2unHh5AwJ9cgaOHj1vKwVX//iMU+ygPazPrx0Ly2tDjsoED?=
 =?us-ascii?Q?9VUjeWM9yg5NzVPdsQg0Lb1YXlTTOm++gxEJGTaqW6GzOwh0YU/gH3SMycTs?=
 =?us-ascii?Q?3nJO3gaGyTMQnjz3IbabDzbmlugD/1nu43cvAB9klhwxDNfq7LK1kdZk2mm+?=
 =?us-ascii?Q?UESOI8yCR+b5aJzlBD1+lYyatQjFchlsHGlokQrVwJvVJ7y5HyQHm+fDWVdn?=
 =?us-ascii?Q?lxMD6AB0XCqm3Mnlw5iMjGO6GpcGlIAHCU/CYtvAdm2kZCA4CLe6ZdqvaS63?=
 =?us-ascii?Q?A7sWPkq5zn0a57KAQPbFs1PCaSFU8CvGpTHKtLkdYmDM4ra8KSYBWXFMg4Ce?=
 =?us-ascii?Q?G2X3qasY0xPgRxdXRWpnUy+i+OTmR7+3Z3dMkD2EFtXU5kWe+EYQe0iEtN9a?=
 =?us-ascii?Q?KaQ/skpcnuIuHBWtjUmVBVSauLiu3jyDWxymApCqS4w9J6ovFkPC0dTV+ioJ?=
 =?us-ascii?Q?mJ379w28VDWj52qIL+9LP9ft6ij7E6JCN8aLIb8s2jCr7ixSt1HkQvzbhU13?=
 =?us-ascii?Q?/KNy93Hj5lGavVWl+X0svRLRkyTBTihhWJh1+Xp0ktHet9H3ymFBO6TeSKfR?=
 =?us-ascii?Q?X48lVpGDExdi3AVRH+2IyMNfFQTbPP2tuP57S/Y0ItwOnXWfzCQEMlrdOkuZ?=
 =?us-ascii?Q?hA43+69p/lGEU8OLdbLS7suajdqn6xQmcRnxHEnnuDdwuN7q9b5FE0Iy8FgK?=
 =?us-ascii?Q?9vvf+odJg2VbzPWpepqIDSKw0e2WyeGKtkYRNZr1d0IQsCeA6tYR4qtwp1hM?=
 =?us-ascii?Q?/uXziUH6igo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxQVufW79ExdecASA8SKy6zch66T5KwmxMKq7rZsZ+x2B5y+RTv4iqj9e5uz?=
 =?us-ascii?Q?yiMXcVjkGgKY/Hf3vusvbbYPtk5NW7pgPTMBOxtHz6zM/1Ei33SrsCt6wflR?=
 =?us-ascii?Q?uziGkJqwcAv3HD0FSDHlBi+RIF37NAmO3nGiyT7Ws/3pMf67cf5hun/kDAKb?=
 =?us-ascii?Q?+ggez91QPKK3NAujlW45JaiJy3CeUU7V7UsbmPtlZCv6qXcbxzFQxRok3+nr?=
 =?us-ascii?Q?bdGyvW2h4ZF/VmnTo6CpRUeYZkSGQnFjVLQDwF70zzTIA3H53gGStYwRMsOm?=
 =?us-ascii?Q?w56qoPvEXFy1j8B3W57qx28Hh8/mQnlqUt0wN8d4UDLGhEGkdNZPrss9Zo/Y?=
 =?us-ascii?Q?8OUDEGIUw3imY8sIGhzaFRzhh6c6l5zHJ17shrd0go7m0d5J5cmtUeTwHFmn?=
 =?us-ascii?Q?2qX05SYR79495ItHpCbc+usUGDmhodCLqCq/KUoEcBm2fJejq+mdQeRBlNst?=
 =?us-ascii?Q?k6tvWcgh/+9CXj1mPHYEBCv48OrW+slLBCybXZ0J7TA0J/Cv/n7zqPcT8xWf?=
 =?us-ascii?Q?yLQ3BX19H0A1gHSOpyEpPyxY4qup9gniSzbTPTZyBEtUxcjpr95K0f+VbrcZ?=
 =?us-ascii?Q?Anc5iOBIZgP7HcFIwAwhyI+dx7c+IMcMlDnqkBEl0Fn5tQL22UmGRMzXcC9T?=
 =?us-ascii?Q?v8my7K4hYyg9MgSyN5yvA/+4gylcOskVwB6DcIh8ZnL4HIQqIR86+VEPxMjH?=
 =?us-ascii?Q?Nk7BdTVwpN9id6k+eu4DNRomcimYURPf7zWodGbEWfSUl2Lc6yap0Y+BAgIx?=
 =?us-ascii?Q?X71PBq819/uhTlB7YMmcC8O8aYT8wXs27aFgtoJvYW9UPRpk9u2I+q7DPfEC?=
 =?us-ascii?Q?ctJqRZ0H1uMxi/dbHYzd29SXdOSM7jEpswM4oKL2ykDcCL4Ci+P/ODXOVINW?=
 =?us-ascii?Q?IKyc/3qubPgE5yb8CYaSuH1P202DIaDrCJuMB7F9OQXxYYTZvqjKq47qJLI5?=
 =?us-ascii?Q?ZVL5b+Z5BoVijUFlKhBTXGWrNzTMAbICH8o5ajnINotd9MB9Q/xQfw0tKveW?=
 =?us-ascii?Q?Fnxd5P1pbSMZvH/KRv9xMxi6Ae6/bZEJCPlai0oRmDGZFbJcZSIgwO+zTCGl?=
 =?us-ascii?Q?zuw0w+DB7F6bOAXnt9877JTfSU63m1pgO1SXEASklGE9mvnfIvXhXzm2Lfos?=
 =?us-ascii?Q?HWnlcZYTemn9R1q3Nn5c5ysahd5MZ6rmGbdg5S5ANzdI6+pYR6/9MlLminfa?=
 =?us-ascii?Q?vM7AcXVI1S4/l/ZcV3uKT7aCh3GDqEi4aYQlr4nbeRkvZPAjCwS8ip1nbVZL?=
 =?us-ascii?Q?mnRbMVWmzYMJHqD4h8Ebq6xYlxQdK/zJVP5I7dEjDEQFWhONjI1AquEjIUp9?=
 =?us-ascii?Q?x91nt/tvBh/a6+aGcPZ7uk8gYTmhBYMsmhabvVqdIlYufXz9o5RZbPdvDTWK?=
 =?us-ascii?Q?QRMBKGvwYkr/pYvILuatV1Aln/Yz4e+WQS5n8FtzmxvIcFYaCtwzbc50t/UF?=
 =?us-ascii?Q?W6WeUUi+T2Yc3GoGO+P37bSvLNIC2SGjMXWbCc+hEzoCBZA2CK5ZU0Z91wQI?=
 =?us-ascii?Q?snhhTXV3gI/RV/hoe4K8iABANuCS4+k64GaOJ38nOIGagQSy2PH1MwunijuH?=
 =?us-ascii?Q?WCx+RxtzRPOG3M/MaDIe+cncqD6HUWl4THzPMz1/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9647cd45-f918-45b1-5f5d-08ddf0157642
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:55:12.8117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sN33DAi2kUTuTOKUjEONCwPQzmbFQqhmYAdLNMZvGqFtiDB9pQxADvWEbuRhUK3Wfc7HP5XxHVJseEbJYvWlVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
X-OriginatorOrg: intel.com

On Tue, Sep 09, 2025 at 01:03:43PM -0700, Sean Christopherson wrote:
>On Tue, Sep 09, 2025, Chao Gao wrote:
>> On Mon, Aug 25, 2025 at 10:55:20AM +0800, Chao Gao wrote:
>> >On Sun, Aug 24, 2025 at 06:52:55PM -0700, Xin Li wrote:
>> >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> >>> index 6b01c6e9330e..799ac76679c9 100644
>> >>> --- a/arch/x86/kvm/x86.c
>> >>> +++ b/arch/x86/kvm/x86.c
>> >>> @@ -4566,6 +4569,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> >>>   }
>> >>>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>> >>> +/*
>> >>> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
>> >>> + *  switched with the rest of guest FPU state.
>> >>> + */
>> >>> +static bool is_xstate_managed_msr(u32 index)
>> >>> +{
>> >>> +	switch (index) {
>> >>> +	case MSR_IA32_U_CET:
>> >>
>> >>
>> >>Why MSR_IA32_S_CET is not included here?
>
>Because the guest's S_CET must *never* be resident in harware while running in
>the host.  Doing so would create an egregious security issue due to letting the
>guest disabled IBT and/or shadow stacks, or alternatively crash the host by
>enabling one or the other.

+1000

I completely missed this point.

>
>Having guest MSR_IA32_PL[0-3]_SSP resident in hardware while the _kernel_ is
>running is safe, because those MSRs are only consumed on transitions to lower
>privilege levels, i.e. from KVM's perspective, they're effectively user-return
>MSRs that get restored on exit to userspace thanks to kvm_{load,put}_guest_fpu()
>context switching between VMM and guest state (if the vCPU task is preempted,
>the normal context switch code handles swapping state between tasks, it's only
>the VMM vs. guest state that needs dedicated handling since they are the same
>task).
>
>Context switching S_CET as part of XRSTORS very, VERY subtly works by virtue of
>S_CET already being loaded with the host's value on VM-Exit.  I.e. the value
>saved into guest FPU state is always the host's value, and thus the value loaded
>from guest FPU state is always the host's value.

Looks like the host's value for a given vCPU should be constant here. I'm not
sure if this will change in the future, but I think it's unlikely.

>
>And because all of that isn't enough, the final wrinkle is that KVM_{G,S}ET_XSAVE
>only operate on xcr0 / user state, i.e. don't allow userspace to load supervisor
>(S_CET) state into the kernel.

Yes. userspace cannot see supervisor state in guest FPU and should read guest's
S_CET/MSR_IA32_PL[0-3]SSP via KVM_GET_MSRS or KVM_GET_ONE_REG.

