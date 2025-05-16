Return-Path: <kvm+bounces-46789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C3DAB9B71
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B073A03165
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C630237180;
	Fri, 16 May 2025 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ijs+1n8j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79A22F743;
	Fri, 16 May 2025 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747396083; cv=fail; b=ph3fpJJ7aXFFi7JlL9TomDboxz+Dv8PvQ5+aQFrACXexNo5rrFFe8+SsYB7tJDocSMVWzPC4vvtxuwuvZjJGVQFKU/9Jb78WiqkBUnYbZn6uWkcEq2WHKzXe+wcbWkAfH0Ksp+YZo05y5UmvpwB51uljer3hQ0pdeVNiREqABWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747396083; c=relaxed/simple;
	bh=AAcBqmNCPWyXyFOOqLBp8n5yIaxTGUdTUZNlFIMt/Zw=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NfuSWlKeRscMokupj+PlDYBwWhdUiT+rohzoeU9at/lQGHkHn5CSU4EyYtwCPhS6Ln9AIaEefgw2a14s1mrP7IG7iMe4Kb/cFOPwqXuszpaKyBZgl1seChKr4gT9hIWOARqpv9k6OFRFpsRcYJDE7wtscSBBJ3Koeq3byMe3kys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ijs+1n8j; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747396082; x=1778932082;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=AAcBqmNCPWyXyFOOqLBp8n5yIaxTGUdTUZNlFIMt/Zw=;
  b=ijs+1n8jfcKVsu6slSivEEEtY9lBW6/Xfqpt1nOeyPHHgj3XyPfVIllI
   ExJjOILjqcQWVeB14EnmAssfbrgSSWqUXrqvpETlFsNqhjeSnznqL1HUd
   wNU+nsAHvv/Glgo27MO1G7Ml/rG/qAfC81oBxzxJW8iknVx8pM2tg1DKO
   f5sMBfYFQ15Nq9Ml/hMO/96LC9zYc7GibqTb6BpbcSTocg8x7Ta0ZycLt
   /OHU96ma69iy97UTmcT5+ClGgitsqlqWb1JY0F0f2J+L4ZztxxI+Z8X3l
   fTBOZHfmVG3X31dUu8rioNOZVtwiAHoKt3kFErWVaPM43oxNjGz7bDBkJ
   A==;
X-CSE-ConnectionGUID: gMB6sbh0TQeo+plrPMVChw==
X-CSE-MsgGUID: f5ZnntuHQpSdnjePDq2JOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="53165790"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="53165790"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 04:48:01 -0700
X-CSE-ConnectionGUID: XXsHZKnqRZeKBpP5Rjr3Fg==
X-CSE-MsgGUID: 0zp8tsrtTKCOrAgWjMEJ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138531266"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 04:48:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 04:48:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 04:48:00 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 04:48:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTJL8ale/fwfTwoAqZ8bO+GUXRhbCA5f3JImBhA6anNmmwdIsqWwJG6UNnOD8f6F7Yyl3w+aWmrPXq2hiPrfCfSiH3GPIekQicCGKs17ZuZ16/kJO2WdCh9aYDjrPP0//EyRELdZiUjTq9uVgg2C30h2ZsOUrbqGH2VK0ZLDGdqlANRRdIVImHmdcI+yaFGGsDN5Fp0T+PVF9onG70J1bUARiO+hEQtXXtFdkEA+84R/KrW34Y0DYUEu+vmezp2iKHXPu49QgOl32Wl2GNQhF5pbCSY/YWp+VUUrH3ny4+D1ilZ4VK4F0rnQ3yYX1fIRrC+osbHIP96WmsI+msFiqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8iNEnnpkfktPOXbdDFKjD2vje1Ge0rpEom6pdA6CME=;
 b=PH536uQo99O1d42EzVCUQJZvjBJyZVOntHN3Bxr1N0KpZgtXt9M2FY7n0xDXu2f0hmKNjaUdGL82bIIe7Dt6g78SiSl1ixH9giV7y193aOKoQAiua98LrD/lI4NDZcyAwARftL2YHN/x8AxXAVTo8h6lOmTdiBy9i9/uitljNA51g+iuY12CgXfwhQ7RnfLt5vTRGP4HF9lPMtcRSCwRrV3y8FnbCAVuKTyj30qoNI4zbPr6dt9eFA94ZVHc20TzfxYoCrKm+Xk2J0hVL+4y9MCOYlqcbRs8i2A0x+B9DVIkSG98/FuQ5eJElQV9UQZ5qfWU1aeHydiCxCCil7tCuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6345.namprd11.prod.outlook.com (2603:10b6:208:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 11:46:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 11:46:58 +0000
Date: Fri, 16 May 2025 19:44:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Message-ID: <aCclMAY0C5OXjt4/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030816.470-1-yan.y.zhao@intel.com>
 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
 <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KL1PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c83f7d8-90c1-48ff-51dd-08dd946f5d4a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9YXe7Q9WZ1EKD5y7lGwCQHPcEdv1DjWlPbbhCWhRlHOmeXe9qE1sClI2m34V?=
 =?us-ascii?Q?1SUMEFDPC+RT04LEQEU2AdbfE2SzZISd1bdrU8RUMMLLiO/pbtSq+HqaKyCy?=
 =?us-ascii?Q?cFu43kkDQ0sPv27s5lTjg+2vbNQTOO0iT6ygc9P9a7TxSBmLM4lHJEKC1wjW?=
 =?us-ascii?Q?IP9a93nRckInwKEvmj/NztsXftTzmI5iQ1+jzNwK2rLE3rHt0U6k6FES6p6u?=
 =?us-ascii?Q?L/BybefRvE421KHvS1J6lQQIo8puTTOtkgF2LX/3LGEvU5SzORqJjdKDOX34?=
 =?us-ascii?Q?0TmpTwoULtQhTn6Acq0ndafcqVbf1mW+StkpZl9uKDFgkS+rsP6ZlApW2P1/?=
 =?us-ascii?Q?Q4zbQFly0QjEzJ6Nx+lcrhQCtdMVXftAQMUP79tscDxJ4iQmCqNeiD7lTiN9?=
 =?us-ascii?Q?qmMNQ8NSTMHmJt2uMVdW8PkdhdcpU0FddXfAMR/FfPEzUJUL1WZA5qKf8BZ7?=
 =?us-ascii?Q?0Ag/BR2nk80JBpNq2dPcIG7aQvc7CVhN7zXsrK+1HiwPC+dnSF1YtcPW53wU?=
 =?us-ascii?Q?uRHX26Afh2/XDrTl6qi9dzQl1rxWW3KzgL3YgomzOetvGBDLKB/7mzSs0sFH?=
 =?us-ascii?Q?x504jEJ6Ng932NCWQrwgcLiNFFsLeXKgX5M11WKztoD8tfp7N4NnMEn98PIy?=
 =?us-ascii?Q?Efwzxzg5BD+HJIplsWUKFiZ0knXGtfzTyZ8kA9A1+S9CDFEhpaD8kP8FBwyR?=
 =?us-ascii?Q?5fjMK71v7fBoGfDlRAoXO/HYbpCXa3jPPFnrPbvZrAS2Jbe3ov4TifODxwQc?=
 =?us-ascii?Q?i5ojuJz9RbK+LrXmjyxcV9yHRKVW7cF7bGmPL63TDVh6YBaFBw0VW0dDJTDe?=
 =?us-ascii?Q?Q+zd5cxYuSu8+ckL+3iXG2+T0MLVTIr63m31mHVeufRTNQBckIAgNDgXO1l6?=
 =?us-ascii?Q?2HZD715v3VDpnQD3etU9oAOZWCo/RVlp6RHLLoaz637MefD+v5DUP05MYJUE?=
 =?us-ascii?Q?ndRmDlRRzJnN+nYs1+H5xm53KArpdL3PLiw3BV5AM5Hil/XAirVcSmPRae3g?=
 =?us-ascii?Q?u1QvaxCpv/ioqlhW1R0HEpJpGPqk18lxFfYED9Huu/5Ch6ERMMutnDJpH/tG?=
 =?us-ascii?Q?dcvG+dmh4+3VM7e8MHWtVBOBMenPScP1qjpjUhi1tEXDlPPnUxk6kuCsZAcu?=
 =?us-ascii?Q?ExNQHWyz0sB0LhdhLgGLiz4hP6BCqah26Q6fMA9i8mEXdI9pQndo3mEMWikj?=
 =?us-ascii?Q?hxNVapFidTOlfUIFkXHqXOv5JmfyZriMiZc/6W5mLmNQKL5uEP+TZjzlGSu7?=
 =?us-ascii?Q?ymKyyY5vs8KmCwzp/J7JeECWQzEpePrwLT/GR2UdRCaeM5m/fi0/BSiV4/Ow?=
 =?us-ascii?Q?zFVvUriFtFr8XFftL++n7w66z4u2zoXd7Gdkk6xfM/sHKrPNHs/dEUnAlm/A?=
 =?us-ascii?Q?O6JwMMzvXXeU7ML/GYo4Ctikx8quqSpBtxRZPA8VxJKXINcSCRoKq2KCLmD+?=
 =?us-ascii?Q?JoNK+pPwpu8wL0ABmBIidNnv/Mhae1q0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KlAZ8wR4jfoObYrzBT4brcA3zH2+4gfTt7MYj3CYvC4V4jwdPJuJ6Plmf2Mr?=
 =?us-ascii?Q?xRe/w40O97XTdKlUahORvKhg3uMuJBkBEOpXNPBsEkgkG8zOm3YAYnAFhY0q?=
 =?us-ascii?Q?SiZDj0h275OiD3hVyN/w/6WqsGnPGH+Fi8Iy4SZRaqWvmS+uE3ki8QgPg65H?=
 =?us-ascii?Q?BJAHIi8ObzmOVMPO7f9L1IKUpu7VpXQ5TW2A792RxIKL0FgiSzNkka2Bx7kd?=
 =?us-ascii?Q?BEz7Y9oZThXArBLeIfiMeNflQlEgGEYvU8cOjDYcq0weUyJzoLE4bUOO7W4b?=
 =?us-ascii?Q?rycm4QZt1OKITbP9dYBaoRFDxRfIQs5AjHaLlEpiyldGEOy0l52T25kr+EMB?=
 =?us-ascii?Q?UmETtgs4kZSayu20eMPDsBS4Ftpv9S7dQZjTa2i+Xc9Y7Ze/0Ccd5g4um5Qt?=
 =?us-ascii?Q?8bEs7YnUL9UZ1tunkV6NbxDq+CuCwFX9mUkGRvU5xrAhzDjP5LM+45PNZw2k?=
 =?us-ascii?Q?sn42+oGI1wB17io/520mXpSHij8B/vnoKulP1pw9DKHO8k27EHz82p5Fnve/?=
 =?us-ascii?Q?Nw6wtf+Xr2MDlp7Z+OG7L9eR1vUS4q97COb/wx+as7ji8jJU9c9yISfZTPUk?=
 =?us-ascii?Q?+J1ptUAKmcRrm9jV8goN9jshthFbJXNQILvCWXz0plCevIRu+m9CLNyc5yN8?=
 =?us-ascii?Q?cG3DE+zfCNO+3MvIfh1BM6hDMMH2do7FVYP1fbyn7d3QM39FsGBaIPj5djbC?=
 =?us-ascii?Q?LRVPNBgRZgInPYtTgFmBQVegx/TViM7dx9f2IGc9aKXEHWJb9lXY6rfaZsj4?=
 =?us-ascii?Q?fLozPBPo1bNEfdf68cDCA3qucvlU95u9/4OpufXFmGS+rHmYQcmb4aYgcLwF?=
 =?us-ascii?Q?TgJoy4Inwdt9UMbsaRYEakmYx4UOqqghY3NxpXstNz/n3y35cadMCuiXGUqX?=
 =?us-ascii?Q?WXkt5eY/iAK1c1I62+zXNqIbS4DnA0SBUiy3kc2vCH1Zgr2Hqid+Im1/N7xc?=
 =?us-ascii?Q?lVe2piJ+neineBQNqqyuC+r7sLDGl8KCdSZWPlTRXtkSnKIpAnumK9W9mGEU?=
 =?us-ascii?Q?ykaqtPYRERxmoCufMITLsvo/c+Ewd/EKcq/Qf7aNDXC5HwXT/lodqxu5KoKN?=
 =?us-ascii?Q?wi98Q//BpvLXQF4rNYYaVXPQKmwB5cpGhOQrlj2ao3yftP1tJPHz1iGgJjWG?=
 =?us-ascii?Q?Qdbh/m02nORp5pumXJ5GYuijdX3SaAwkwUFHnLB+25FqaLSXWuzMEG6hKueY?=
 =?us-ascii?Q?jPxB/sR0EzghiJShRnDLY9IrZgtV4ccF7ElOHa045NHJKctCOiklw4V4Yqc2?=
 =?us-ascii?Q?Cho2oDc354imnINwDG5mDzin85EFvK4rNn0i3VbaHXNA1v/nsk8hCfbeRnt6?=
 =?us-ascii?Q?fWVzGqfF5OPbi+4MwrP1ekLkQvT6+pEpd0QOClNMHTL1CsvW76lR7PiR6HxN?=
 =?us-ascii?Q?KR1AjFqHyGB0wmZ71LojmbrmgR6pnFJNsCFaeTAcMFkwH+JnT5QmF9yU/85N?=
 =?us-ascii?Q?HCVkHyVO2uAnQH3YprFqq0w8yqxQ+IG861SLGk0khukQGHj/wafvNfUZjJ1A?=
 =?us-ascii?Q?N9MxNrIFhuEVInfCF/JxXnDYOpk3K4WDskBWBtHovoPFA6nYGOImM70UlySQ?=
 =?us-ascii?Q?kzmfsnImc3gX+DTMtxYflh1Ro4CpsnOTP77nZNrx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c83f7d8-90c1-48ff-51dd-08dd946f5d4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 11:46:58.5875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQfKRjoaM3slfZTdVuNWIpoREYlwv/WqvblG8p0rcksegWlfSNMpeqo6aD7gkdKVySclVjHvJH3Ai1fZ63ffQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6345
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 03:46:53PM +0800, Yan Zhao wrote:
> > > +			goto retry;
> > > +
> > > +		sp = NULL;
> > > +		/*
> > > +		 * Set yielded in case after splitting to a lower level,
> > > +		 * the new iter requires furter splitting.
> > > +		 */
> > > +		iter.yielded = true;
> > > +		*flush = true;
> > > +	}
> > > +
> > > +	rcu_read_unlock();
> > > +
> > > +	/* Leave it here though it should be impossible for the mirror root */
> > > +	if (sp)
> > > +		tdp_mmu_free_sp(sp);
> > 
> > What do you think about relying on tdp_mmu_split_huge_pages_root() and moving
> > this to an optimization patch at the end?
> > 
> > Or what about just two calls to tdp_mmu_split_huge_pages_root() at the
> > boundaries?
> Though the two generally look like the same, relying on
> tdp_mmu_split_huge_pages_root() will create several minor changes scattering
> in tdp_mmu_split_huge_pages_root().
> 
> e.g. update flush after tdp_mmu_iter_cond_resched(), check
> iter_split_required(), set "iter.yielded = true".
> 
> So, it may be hard to review as a initial RFC.
> 
> I prefer to do that after Paolo and Sean have taken a look of it :)

Oh, I might misunderstood your meaning.
Yes, if necessary, we can provide a separate patch at the end to combine code of
tdp_mmu_split_huge_pages_root() and tdp_mmu_split_boundary_leafs().

