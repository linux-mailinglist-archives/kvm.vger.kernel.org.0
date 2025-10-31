Return-Path: <kvm+bounces-61658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E0EC23D02
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E988A1886D70
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAF02D6612;
	Fri, 31 Oct 2025 08:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZ+7S/US"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6424111D;
	Fri, 31 Oct 2025 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761899451; cv=fail; b=PtRkn/eHO0UUr9F6AMLLMPVurRxPcVVUiWyAvk8ZNBKFeIZg1ZoVgWlQ36uyxdq49UObwpscd0MCWQlLGSl0TakAMCwP92okkHaXhNY9Ezr3ee29YZz2+NYz6SbtKk+Gi0hcGeREQi5PNlEJ65Pff8U97ix1lEeiMKkMYjJXcnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761899451; c=relaxed/simple;
	bh=SwSUIsLkf1bb0G6j/gYXjbbhuzp3bjyAhquwCNNeMYM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G4mFuMROM1enwk0O8VDTvjoqG3xvuk5gLEqMsJne/5PwW1N1SOBZW78au9Rb5HDdSyzz1dE+jsom9IUQsnQ3bmFXEFvMJGXsgIL2pR0nkBnkQ117IK0sY0cjPot/Xs2vj9FZOJQ3DfCQ1k1sJEO9z91jjCvJ9uthoWsirCLTJUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZ+7S/US; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761899450; x=1793435450;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SwSUIsLkf1bb0G6j/gYXjbbhuzp3bjyAhquwCNNeMYM=;
  b=JZ+7S/USThZNF5PmM9qe5GXmvRkDl8lO6t9NvY9PhKorrdwE7SFPtjJT
   Qw1rwwxE/xLB6mkklj7/bUGCNwans47hDzHoWJSSq+5NRdEN/I0pwfWy6
   GDh1mWm+ntSrC4th9POp0rLCcB9Zs6G1NI//Nx+n4tAmnnRHFPGbPJSwV
   OjWvlmINrXq3ybB6d8czrq0XtpxwNb0oURmnaD96w8oWKc9Af+IKy4uuK
   w67/DBIbQQhtWoDMy6RUfHzUlZyyPjf/UF/iLyO7QDKSHn3DNHUaME25l
   Ywm0Ao1zG13gn5YoALfSjUWn27uDYkDB9Eor15TtgxjQwMBWkYWU6t09O
   g==;
X-CSE-ConnectionGUID: XG5jluhsQW+sPOz67CM3wA==
X-CSE-MsgGUID: +2Mzbf6CQ+2/8hNDmOt/iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63259866"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="63259866"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:30:49 -0700
X-CSE-ConnectionGUID: ZbuwHgFORlaIgWiM3ym1cw==
X-CSE-MsgGUID: pW6sXiYqRs+i0XjbMS97dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="190259139"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:30:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 01:30:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 01:30:48 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.42)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 01:30:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+4d1XwPAkFEMvyDDkoco60IjQOYXVjrLnOwv0EhSJCbStZ/YnSxkmynC/H4c0eu3O5mHCQL0trOXqRy6p+TPSKCHGnPz9V8qT5sRzyPZZBl0RZw8RplEv2CDuM27sS0Wisg+j1Fy6Wg1dZ8vBUqRO1aSYPJ2afMn0tiuS/UXnRJ/no05yrT04uUUA5g3cvBKUuClv9p9rk0Z/DJzdc5nf5J62lCRH+Jzhkjt+q0+QvN/Fl0DfFZG3rdmqo4iru3krZmqRWBNPn3HMTYGNvEqyM3uePSwk4LD67eR+k8ZXntbT0gn5cU9lIzds5ifL3+g5w+B65crfitSmSAQfmSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EF9Xr9zzkOS9n+jVhnEHU8uxgj5gFXSLoTryD6d/Wc=;
 b=KeIzfV/bBw5FGkVhJ5UevllgWnSFhvP9PFyD9XH3sE7X5UQgO/5uZ5dharquv1Ivz/TOAmXJBZHiZ9XzJHqQr97l7GIJ3mpZ/LAE7qh+soXzr8B4ZoeOS3aU2kOXzLhP03KED1NUSezJ4h0h8SB+by6kjQYKuER6dRP4FZ3i4dzo6MIhnj4trmYnNnL67Qp/3Lwx4P5Grvk1heRL2hWXS7EawUqM6D0+QuiksOsi60iDs0oczzdlRgEYe1caqOtulEgPk9TW6vJqGgZaikdmMNzM6j4KrM/13VEDKhP0J5F0G5mZoe+ihAVj0kgICchoaziVyVnkBf0VL1c/tw0cCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8566.namprd11.prod.outlook.com (2603:10b6:a03:56e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 08:30:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 08:30:45 +0000
Date: Fri, 31 Oct 2025 16:29:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth
	<michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Ackerley Tng
	<ackerleytng@google.com>
Subject: Re: [PATCH v4 08/28] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <aQRzWb3Fu6ywdE9t@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030200951.3402865-9-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 3592603b-3d74-44b8-985e-08de1857c94b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nSKjGK2/0htILDOmL4r7qmGzPEZSe+OJs9BDEeo4K3/Ng+UkNwy5gan+ibCD?=
 =?us-ascii?Q?tw+257GeCjaVtbJG2hxDkE1LTou4J4MR7Yw2i+yFEU2GvqMwW3LCH/D8frfD?=
 =?us-ascii?Q?JE4bsiywyGI2QVKNTHWZ8IuiF7m37NbjA6493DChAHY+lJSYSgldgu9+JDq9?=
 =?us-ascii?Q?E5U4Q/elulGAbl6B4/qE8I51pYxXt37PeA7OfYtuTVyNHYx+eLseBCQh/Pv0?=
 =?us-ascii?Q?Nsd+Ja0CTX6mWcHQQC5hYkr0OcsKOClUrnSlCSyGtqJgjAZGF4Co6vT1/Vhd?=
 =?us-ascii?Q?qffYK4WVzX+RGCZ5fnhnX/64/szl0ajT2N6T6rwyy+5DtwiLE7OxuacF/YTY?=
 =?us-ascii?Q?D0D2o42y+/1RxajZfenH7tvppD9Wtah9GZp2VyOcLGsKnWwbwQPjj7gl3um4?=
 =?us-ascii?Q?wAjiHfyaNxaS64Lsbk0D61N+6QgCfjpqZYpVM8wRDQO3uzrOIKuHC1/Foyff?=
 =?us-ascii?Q?c3neRvtcVIc5lx6LlssLGC++86AVYxnIgHtyxH/bMgxNSgnkn/2AzwQstplc?=
 =?us-ascii?Q?uORhnPpA3tjS+wMQrEK+U2KbBZPRc/KiAXNak5XBWPel0AEGADmUKnWxL8A0?=
 =?us-ascii?Q?DibfQTt2wtwXq2W3g5uvlATV7LfQz0An1zvmPdXGAuxbzpnMvuoWhxktK3AG?=
 =?us-ascii?Q?6TZBmlLsWpqoLySYIhXjWh7xZzsa/kW7jRNmBGQ6OmzINGunB4UN76cc1WOf?=
 =?us-ascii?Q?W4anrxNSq2eL1QVdc2qO2bzr60A8UfDizKM33j+UcY/l1jKtWdNwCs0qkHcV?=
 =?us-ascii?Q?QPvXLLNCrxjlu9aL6KsGw+PwFYZh/+RfJ5olGYlmFXwWI35XmqZIARfoPP/S?=
 =?us-ascii?Q?Vodb0BAeZbouqqx/02X4hW/Va8VRbwR78Td/gFXcnQ1DhlVwfxpjgLITuu4f?=
 =?us-ascii?Q?VABJ/YA9Xf1fHtLJF1wUjcObNrekpWhAB/+E0B9GoLvgtYr+sfX/s+u5D/jb?=
 =?us-ascii?Q?WFQzf1YNjykK31HMaoNF/jo7XV1ChNWQcnuFiFT5ypHqa9RZqUPsvW9o3m+M?=
 =?us-ascii?Q?rp6l2PlrTo/xQQYERFRSBSSoCdpWiRauQCq3Efup0fXkBhb0JaLnQwG61xMS?=
 =?us-ascii?Q?XyWGnev/4cVVXFq6H9wZ+7SGssW2NlGHew+3VK/UB4brTli5EmidGTELq/UJ?=
 =?us-ascii?Q?rGkyHH6Lpx1rXhlmdDGoaJpZExiMplAFpv565JdaTKHJx6j8xPbDY7KQ66Lh?=
 =?us-ascii?Q?QPcWQ4uHXijOVXbp/FjHP7rKVoaY9JCZJYUTrr3llY+fzVEqz01kVVe5Hmt+?=
 =?us-ascii?Q?gxLD+oYSh51XTxTLpH6CcieKs+CQaN+7T95yzYtpmVM9QuvUw0UF0dyHCwPp?=
 =?us-ascii?Q?ClC5Wgj7fhrybZ2QiGX+omaKHkAL/pS8irHrJPqvtp9h0qU84LjaSZqNLZWt?=
 =?us-ascii?Q?rspo191jcvAkvP6vxE7Q/7Uwe5sqzaFz339k/f7zPecDaN3nQrvYTMelqm0U?=
 =?us-ascii?Q?KMmdm6d+Lgptc5ZiL8C5jzc9w5kPR+Sx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MEIX5JlRAn60ZKzDs/96YGDz0tB8fN3W7eD28RuEbrKtJbCHiN8V4mOWMipI?=
 =?us-ascii?Q?8C02Hl4P7jxHdAr/xEw2OovpzxcmyYc1VCtRFSH45ziJQ6/s6Kuyiu4qPi2L?=
 =?us-ascii?Q?KtfGxT0YAz2JdTHoE4RNAdMW6ie4Kj0OrbznZXB3rjRnkLPq+c6J4hacF8x/?=
 =?us-ascii?Q?jOc68v2HlYcGqwqvukbdW3YTtrBi9jiqeg3tVYQXpJN5W/UD1PVzIBqz+o8Y?=
 =?us-ascii?Q?otV+c2ujiE/PFpVXCx9f1AsL0TNDga4dSTDy7BRVptQorZH8YOOCnBuBZzCT?=
 =?us-ascii?Q?LWdJNm8D59qPUDI7Zgho+i/ShuFAGQ8Pu3bbTnsYh4lcqSUe7xZ2bW9rkWLC?=
 =?us-ascii?Q?4O1PS8D6gtyuSjS+h7xyqexq/YBGTTXebn9moS1TmFMrLlt3DSYml5CxWXKF?=
 =?us-ascii?Q?Op28PO13sN+wlRPlXw3VdiKFHwP1nHxMlVt2uv1dDASxRgB4BxuCgCuJHd/2?=
 =?us-ascii?Q?xGI+WPccidkugm/sivVLFVpBV9uTldNenX4RI18rpscaCDE6sMZpSMm9K8sP?=
 =?us-ascii?Q?Bjq/oavGBbmY1BIS+KpohIgec8KDL6zvvYhZLrjB1j3dQ7bbNg2J0+0ATNAV?=
 =?us-ascii?Q?PCXAM6+Rx1IMplqydmuUC2smgoyhy5XCz7IA0KBBr6yBxATNj87f+d8JEiNh?=
 =?us-ascii?Q?DLgNUNeC4v8vSXvBCdZg7taOuHVbkH5inLJvQ30Vir393li13XwGfL8buzAk?=
 =?us-ascii?Q?I9ShzzBQDc64Px0LjhrythdUb9hMQGXTswne/PdCGfY/2CI2I8mw7XGKf1Uv?=
 =?us-ascii?Q?3uayxAJtdYSRed3kR7ox9gdkCsf3AQ1b4ISHcGiPIobTmK3Wf1wFanysYde6?=
 =?us-ascii?Q?m/FHDVB98B6APAv8j5rMo+UA7hBYc1znEnkXeElmCsOrA/+Invg/V88CZjEB?=
 =?us-ascii?Q?xeYNX01yJ4lTV/elHea4Zj90zb2xMbIuPf+IAieiaK/IfsFYgJ9JZUtRj1Od?=
 =?us-ascii?Q?uA6CCm5Sh06MUrE2bGqMUkJxWOrdRxPxMFufOa0cl7acFWg5yPAJzV3bv4h3?=
 =?us-ascii?Q?pPRsbQXTFA5qLq9/DEgFbWO/H1ur+1qaQVwCche0UFFv1+3C67IayHNSeadS?=
 =?us-ascii?Q?hTpqIy80UzCfRCpwzEyc/igMtVAa9xjYiB+OPAS2DI3pJng8qLSAvVaC8KW6?=
 =?us-ascii?Q?PA96nyza8hHsoWp/gaRMlKeWySOBjFyDDlIWe691EOzhjDEJNcCywF9eeohz?=
 =?us-ascii?Q?2B4dO4JGE73SEllH/kU3bfYLBkTyYJeqqvTHFmVglTLar318sAtbnu1R04T8?=
 =?us-ascii?Q?fUnXCwii077iR9uPbEDGwvmv/tCIrK0My/2uEHobQz9/rK2fmy4ChrPVqnXZ?=
 =?us-ascii?Q?Dab7b41R2VnxLZMvAIirD93sX6SOfrzt4QuBGyQ+gruNDAJ2rcooMFOXLPfb?=
 =?us-ascii?Q?dv2v4ISOjxE5kyMJKMo4+AK+P89O3uU91qBTwJouSkTTVZ3s5j8hs8tSf9xw?=
 =?us-ascii?Q?PE1TxVH524X+ko/NPi2RO61Y/qpzlZMlgr7GD+58GDqUCuT1f1q0SosTNvkP?=
 =?us-ascii?Q?P2N61jLQgfDnAlOnEn9XlZCiNbnEu/mlQTTRk8rncYk1yb691UwG2hx6oMQc?=
 =?us-ascii?Q?q+Xq9qIA0YebHGrApnuRfN3WsjSiRFjIT2PDpK4A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3592603b-3d74-44b8-985e-08de1857c94b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 08:30:45.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipXxTVHrOHMtZUHBMvUUwJ5XLfU81QTuswH5FtDuFmhJMftqlwddWpxorKo2ma4q7O8YS/CM/Z9Ny/p1H72ycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8566
X-OriginatorOrg: intel.com

>   - Increasing the folio reference count only upon S-EPT zapping failure[5].
Nit: There's a warning:

WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
 

