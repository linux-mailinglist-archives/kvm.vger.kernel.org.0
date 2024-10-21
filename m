Return-Path: <kvm+bounces-29262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 821D99A5F52
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A375C1C21A91
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03FA1E260E;
	Mon, 21 Oct 2024 08:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZwSkRb1/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AA51E04AE;
	Mon, 21 Oct 2024 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729500728; cv=fail; b=RmFKrY0vPyGwDDTbrwLueptWnBftFRrFUL4GB1VouKh0+VTLlTCj9XqkHIhEAXLUVPAO7KD2rG0IAsJVdr3K840ZTEC9AN3MGNrerfYbJsErBdj86fBDclBQ5BXtzI4Z3hrUweiUD5ympLP0RzKSvSX6E/IKRFhsdbse67CHlKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729500728; c=relaxed/simple;
	bh=UmCVUadY0XQbAouwg12mm2XIFYAcniWP+ODeqm1h7vs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TACh7wQ2T73TCBhoNTMtO2AfmGBPZTyTmbe5eDA/MEZYsuLWs2w8wdj9zxCmRLY4fGJpKMYGEXU7B/OWOML0Bv16p4G10RCEwfpR1YDxpA0tuqDEdetOjRXj+g5ibPDT3BXdDfFdXykRYVD/XOguhlN6JQFSaeztFDGQGV0JtNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZwSkRb1/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729500726; x=1761036726;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UmCVUadY0XQbAouwg12mm2XIFYAcniWP+ODeqm1h7vs=;
  b=ZwSkRb1/J2O57m5wqaG+NN1nK1FXT4QtIDo5K31xkPg7l/zyQ9FcB4/T
   DtphCqBipY7XzYv18fjej74We9clatemC5khhFUFMcswiKh9zUTGmdb+f
   vB2/aXpviDv5NEbZmlkk12EiKBqPN5aSyk/SbFpcJiOm/6shjum3ioBnZ
   2Ya5KoF9SavGCLm+yM1YvqQ9T5RaeElZFJjTlv/2BIYWDcZBJ72sFNBfO
   R8WsbJQc538jat+3tRdNw1hzAYrXm/AtJvuIxl026MakLrIPKjlfWZscR
   MJcNaZ5KAyfh7Lsn6HU11MVvafD8qC7Q6qDAJ0Nqna3FNOgAfY480TKgB
   w==;
X-CSE-ConnectionGUID: AVr1m8vMSkaeywvcJbgXIA==
X-CSE-MsgGUID: 4ktW1SAnQK2oQmlftkNWDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46439789"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46439789"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 01:52:05 -0700
X-CSE-ConnectionGUID: mLOKVX9pR0GT+kqfQbMnKg==
X-CSE-MsgGUID: VBAgJVY9SriF6Y4+RQgLYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="84062020"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 01:52:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 01:52:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 01:52:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 01:52:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LZM3EyV0zYvOpYT3nPzsVeLKXeXDPeijKKaprxuOjvVZiCOAU3GU3jQYFFW8SEvSM1JeScz/3B5mqMt0GKB8hsYoSfud+QxT8OvbdbezI1ySh7WVP89dXWdaY+gtM7dEvVnNrPmwVv9AxgfywQN0KQVfY7nu53GggIpKk/4wg9eulusiL25F1ZgKZClBZ0htnQYs/LfGPh5KoZKBSc9aj3fXTTOGZeO4Nw3vwBxyGfLY2YwP1th0j6iOtz+7fOn5jBnjKY3OcOg5hvCUuoRumJEONvOeZ8h3EQxqu8Nu3WxMgJNgiVCe5s8uzI52CFz+kJgFn5KJzP7SEJcGmjEjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCzohcyqGktLOLCuYw2UV1L3LqWuQ1djso/efRtphes=;
 b=Kb/aQep5zWuSRKxIUXMIgdivFwOa0uaiP7VLBGNCjVUnjPX9ix0DYCoPhJQqBq25CvdU6Wsoklb2x4Ouio6gPqiHXErN7HtYbcr6uTCQMd5bwKuVeYbS5qNGMYoLBBRiV/igTb6vAKo3nm+HQxtW4UXnMSd1Cj67cmBM7xd/fIsRZRG/URRK0tHQyh54/x+wFTSh0Hwt4kfY5cwsUBaczrvu8QCHLU0xhXTrRx6GobwYJCfbnFNRWEvVZe3HEbWPVwIcXxV54p1AAmRJl+fikYuhNfs9FgEKNAOQNu8MGJaQZ5/Lnh63Gk2wextC/1oiDLg9T0snMTEKv+CW5n1ozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5232.namprd11.prod.outlook.com (2603:10b6:5:38b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.28; Mon, 21 Oct 2024 08:52:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:52:00 +0000
Date: Mon, 21 Oct 2024 16:49:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	"Oliver Upton" <oliver.upton@linux.dev>, Tianrui Zhao
	<zhaotianrui@loongson.cn>, "Bibo Mao" <maobibo@loongson.cn>, Huacai Chen
	<chenhuacai@kernel.org>, "Michael Ellerman" <mpe@ellerman.id.au>, Anup Patel
	<anup@brainfault.org>, "Paul Walmsley" <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
	<frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Alex =?iso-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, David Stevens
	<stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v13 19/85] KVM: Introduce kvm_follow_pfn() to eventually
 replace "gfn_to_pfn" APIs
Message-ID: <ZxYVnsW9WF1Wp8mx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241010182427.1434605-1-seanjc@google.com>
 <20241010182427.1434605-20-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241010182427.1434605-20-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0214.apcprd06.prod.outlook.com
 (2603:1096:4:68::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5232:EE_
X-MS-Office365-Filtering-Correlation-Id: cc71a198-2077-47d5-a00f-08dcf1ada0b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0SfGABlpa4UgrHE0r9T+W2of9GjDJ6z+/yh5sNLtiYPBm2EmZEt3MoLDBAJw?=
 =?us-ascii?Q?GrHPFKOfY4zbT16w+skIEv7qkJWauu4vBnWFMWh2dbGmb9CEqzdzBA0W0fJo?=
 =?us-ascii?Q?SumX75IfhIO6hOmKLWYq0WN5MMI4GQ3UfkPoKf1ZiQkNIx9wxoqjE+J0xHnM?=
 =?us-ascii?Q?o5ioA8raK5kg+0BvmzK61tdi1H+hfTuN94fITvQPfLabbl799X0sMuD5ITRY?=
 =?us-ascii?Q?xEVZ7mziobXE4Vw4dlWCT3qZwFg5oVR1cgd4A0t6iFlKkcTN8Hrsjs1SBRVe?=
 =?us-ascii?Q?FQVlxsHy0aH0xfYgESZqVc8t7l0ASAjiNNMIZVXWB4M0n3ipabRWzi8svBfq?=
 =?us-ascii?Q?1uwBdTtkzoaiGRPDUQvfD/bBUCGN+hNo2/Jz5IXFrnfPrkw4l1jEoJW+hpDY?=
 =?us-ascii?Q?1Aothrl6qe9pxUMl7TYJBPF4pOK6oDqECq/12ROFdCIIdV1yFxEqHqIwuieM?=
 =?us-ascii?Q?JXkqPpOQQgDIKGWFAjYRWTwcNvcwS6zn+3daDd0x3wGJPvsi0GslRZOrF3F6?=
 =?us-ascii?Q?bysaZDGnCyXkJL0EAfU41iS6nMr+yPG89xcsNa3k3fB3ftlxyGj9klNPb+AT?=
 =?us-ascii?Q?f6riAHA6q6c/HpGjvdRdXvs8jyM4hHYp2YO97460eCi2L824Goifwnz3/P5z?=
 =?us-ascii?Q?Vswavz5NKvklN9w36rqhrLcARgkPap+1JDG3FqbcitAHX9RjUwkW+uVVKbbV?=
 =?us-ascii?Q?p0Hj78Vf76/od8Y6kvUYzd9a09q6/gv4ktuByxpL6MBINfi6x9FI/TJhGu/c?=
 =?us-ascii?Q?IKc+dGhuhf3mtVjjGlw8R0mcPpr89aZYdbe4QFthZ3XW5KxsorRPStrX/HEP?=
 =?us-ascii?Q?uqIyYlQ6dQchSQZYmExFsSojrxV1oFKuUTNpn6DyjagnprVz1BhBvhTANDza?=
 =?us-ascii?Q?Ej01A3o5/92lrHLTxYM43kwihfJ7zeLqhkCP/OUdU0vzsdixDFBmW1Nult2Z?=
 =?us-ascii?Q?4w+eCUgGLV3ZPv89wTiDr+pDWSd7m4kbwiVspzGqUkTcuO5776hG9rWi52/f?=
 =?us-ascii?Q?wRU6zRFX82WdTYcWxEATPTCbBAn45xwf10or28pDxePuITiDd/q9fi3iQrpw?=
 =?us-ascii?Q?j/avV05nPYTVPX1nC1tHtQzHRnXnXcaRwevMMk/GxpzlFMLhO+y7I5qFZWAJ?=
 =?us-ascii?Q?YlChG/Iae5kYluV5TyogYCuwjNF4tykWGV89YNi62RcDO9tT9SANT34qb6hv?=
 =?us-ascii?Q?SpmAKx18P6kHwvVOhfBrQmWM0oNjuHpGU5l/A37OWcrW6ti7kD4m1UAmXINz?=
 =?us-ascii?Q?Jn+b8VjK+3F+Y3JouF99m/z5wbA35j0vmfMdEj+G8saTqf0L8KDKlFbN7naH?=
 =?us-ascii?Q?XfVa4CCD+aw2JdAlxs+bpCuV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZqcq2YOUXwvkW7+3nSXxYahTb8YHYxxlhycqz/nYmFQex/N9JWtscpO4q3U?=
 =?us-ascii?Q?BkBp8bvB7xsyU7lSpKKbkkPIu0BuE7aqo5uYvC5zLBUeDLeZZHW4uTRZKTfu?=
 =?us-ascii?Q?kMbrzaeaW/7l+haU4LvMCJvhRyS55+aYcuWV3Ym9ajKX1VaPyhRN9rdczruc?=
 =?us-ascii?Q?BgkjHXEv5pioizS49CPCfFCwoBV9fdVs4hcpaS9Q4JzqMA5NAw4pAol+C0m3?=
 =?us-ascii?Q?VNVrNVvzqFJy3QS/8KzQA/A8BzFyNT4hGZIsFl7S0SIcP50nJ2GwsqlENk8K?=
 =?us-ascii?Q?YCqXOhVAXAvUxvuZfo8/iFX54BA3am5orMtbT0QQNuixQuKnJLw7Zyf2KI4F?=
 =?us-ascii?Q?rGuG9e9z1u2V4Ue1+s5L2NmTw1iwNeBsZDZws+hwCX5gNNS528PLXJ6JQ9Q6?=
 =?us-ascii?Q?Szg1Eo/YoWqDsTUVk+g6Eq+wKygTmR71TJ/FR9Dk5PBFlIcIR6eaCvgFcfIg?=
 =?us-ascii?Q?DbI8qF10yG582Wqve9deRf6+q1RuTBQDpIFW/nOYPi+hlhrdvlWoS3bsefzn?=
 =?us-ascii?Q?p6bA1a0u5FhJd9N/uQNsdTeBuTkoswNu7OioWbAN/iswuoifgtk2Dvv8wCSl?=
 =?us-ascii?Q?p4g+MhcPbg6omwJzmZyfXlCuDl1eooSQPnrKVEMdcKNyw6v2AnQ5fNykv6M6?=
 =?us-ascii?Q?lz5TGeCfVRjm02oETCJLnFMLPfULBaet6WzNPweRfiUTY7o6mo6UsEUqD0s+?=
 =?us-ascii?Q?RCAg+AX7KOVGwhLKTSXKp942cS+8fyvGQdyp6xLxAO22GfhxTctKPgjh1EDl?=
 =?us-ascii?Q?MwyE7yM2DcF1nl2nWD3lU2AI9rBnO1o0a4YwpiXfDmJ4RnvSVqUDl+RJ27ku?=
 =?us-ascii?Q?ySpr0aq+b9HWj76jI4sqFjxUXNLvuZbjPrxY5lmlWh0OC2A5NmDPM6jmWQlV?=
 =?us-ascii?Q?Jox9DkAJaowzDvKut/9TuYwUBxbzIg9GXIGgWhc1HfNKyNkyK4z7o1Lfb510?=
 =?us-ascii?Q?0SOckGtyyo1LAlEpuCNP2rAdxAJqZng4Aohb7wIukYkWNqjQnzp7rzniDxS4?=
 =?us-ascii?Q?YGsJQ47JEysB3/4lpVEAbX4bvXA5yf/xf8s9mLa9GgsqNsI45ixOByQTPMBg?=
 =?us-ascii?Q?atXNWxiWiRsu0agDJyY62fjlbKGCgk/8B6385pLYFmrr5r5z55ioXI8XzcN7?=
 =?us-ascii?Q?7tbfmVEfZ/hJYVCKFZqjNbygbgTg0vPjdDdvZGRDNuJG9Q4tlXXoRxDI6WIM?=
 =?us-ascii?Q?ZYCn1pG2zrXuz+VIHMAh/HoKzPx9oLpvJLZPf2GSD2t+JHAxS9rYrSRiA1h2?=
 =?us-ascii?Q?vV+J6wavuRkmq4g0SCjM2sj7Q9++5Vm935ZU1FVUUw0ALVbQKAssCUmX1Q0L?=
 =?us-ascii?Q?yG9c9yGKmhIANZxuezVKn0qDysiPpH5ptijp+zuy2EOnE0iB6dHKKvn+v6Up?=
 =?us-ascii?Q?iat0jywpdv2cBx6o9v/zUpqrrHw+7L+7giAAMeCFNPZKxRulBCOPqDBn8NtK?=
 =?us-ascii?Q?pzMHQFBg4UiEGQonfVOiySxmuG0cVFk2G/kzZtkaEJwaI7WcSUCBKt1xM7Ym?=
 =?us-ascii?Q?WIlz4Jc9Hvguy/OHDACdvugOZeICG6BvDGCfH1yNNwCFgYfG7G840WgBB046?=
 =?us-ascii?Q?ERfJ3ZKVrJz+ht4g1w9oYmIVEgdnHgpCOY4mMt8Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc71a198-2077-47d5-a00f-08dcf1ada0b6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 08:52:00.9317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPgRRSuW79sPeyx02EjaF6nJg2lN1TfuMgXInPjg2JAPhAosYNfjoR5HJOT+GlijUlFlda8mjdmwqXChq6iyOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5232
X-OriginatorOrg: intel.com

On Thu, Oct 10, 2024 at 11:23:21AM -0700, Sean Christopherson wrote:
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -159,6 +159,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
>  	void *new_khva = NULL;
>  	unsigned long mmu_seq;
> +	struct kvm_follow_pfn kfp = {
> +		.slot = gpc->memslot,
> +		.gfn = gpa_to_gfn(gpc->gpa),
> +		.flags = FOLL_WRITE,
> +		.hva = gpc->uhva,
> +	};
Is .map_writable uninitialized?

>  
>  	lockdep_assert_held(&gpc->refresh_lock);
>  
> @@ -197,8 +203,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  			cond_resched();
>  		}
>  
> -		/* We always request a writable mapping */
> -		new_pfn = hva_to_pfn(gpc->uhva, false, false, true, NULL);
> +		new_pfn = hva_to_pfn(&kfp);
>  		if (is_error_noslot_pfn(new_pfn))
>  			goto out_error;
>  
> -- 
> 2.47.0.rc1.288.g06298d1525-goog
> 

