Return-Path: <kvm+bounces-46778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8399AB9808
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 10:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22DB11BC3573
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD3922DA1C;
	Fri, 16 May 2025 08:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cbRhw4y2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1455922FDF2;
	Fri, 16 May 2025 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747385142; cv=fail; b=pGMlRVyjp+1PRuNgKdviE1wBGu4cK80M/yMPaEMeSajfMwx2pokxFx4VbdLlKisfPAtIaGc1GkPOB17KwhPUCOHFBHqg/J7FR7T518EmgmsdnpSf6XMWhnqtJjSUgNyjZIeooH52Hvsa9+Oi7Op1Jc8MTV6wanrfYt+K9rMSnqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747385142; c=relaxed/simple;
	bh=SY6unMug0x3YetJbMoMN/qw9+UsviSECRuAtT8c3tFM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KBKTXoWx4LHy77jTc4xrnpLpzLcf9mo3AZXQZJktHj0hZQztGkhgBewQTQEAFDSfiboBS7FTp0k2qZ4C+nC7jP/8ZeTpMn7bMqReNKL1Ud82I9tsZbjM3IRo/K29eyNrrnrT2ItGN8HwUJA2DbJFB7i9XNTVenE4k0NZlreB3no=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cbRhw4y2; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747385140; x=1778921140;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=SY6unMug0x3YetJbMoMN/qw9+UsviSECRuAtT8c3tFM=;
  b=cbRhw4y2xnzcff+34n9p/oXUQzwPbAVuFyXweNYZBvQF2zI/28jOjUqX
   w8r0itqMupJO7jHZR5S7y75JjO24EBTfjBvoHRzMTdEok3CiL8FYZWClJ
   QdNMH4a+YPUdin7zc/bqVVZ0QZrCd7IlnwAL9LMDci6Sj8wEENuPE/Iq5
   I3q/O79T+quXov6L1OkS4yvLW77cFnHKg/G6o/vPNyRv28/NtuKeLUHFb
   q9D6CcV8Pj5vKv+k/DeNfTZbF8UbD0U2JLHx5ELkqzDM85wTUWPt9vzNg
   KB1kD6ueopJ0VhAAKxoiLTDZyHL9AZKv+ceqaGgA7iZA77WcAp7WcC+SK
   w==;
X-CSE-ConnectionGUID: w+uDNztpTiCUP1U4ridmZQ==
X-CSE-MsgGUID: byBlmJoaTIOAVkDTTKv6Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="48602537"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="48602537"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:45:39 -0700
X-CSE-ConnectionGUID: rjhy7Vu8Rui3JqhfIbvYeg==
X-CSE-MsgGUID: TCHBrb/XQsWRKM87dupEpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="143583883"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:45:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 01:45:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 01:45:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 01:45:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cFSg8Tr2YP7byI0X/bEUjZmA5TrLdM5+doIwMcHXdFJ3n0li02avdq5EgGGWCr4F7kZm01n4PCBkSQVPWk21eK8Hufa8DRyI0fjz5tnpBfalX/VhAlBdi9ijXNisHUDNajVqXRV7v3qI8sYhBwIKFAA5VhCvgtWi/V+r9K7Rpg54VsC9q96RoIDPVIxRYpxmUTu4vKdgWxFaM30tDk9AuLajCrD5l+RafWL4eF9VwNjIwTarR+Ad+lZ1JoctVhfAkcPiWDuKT+cFhjwkgpSl4YPGvKBoSRiu2ILwJQLyHcFX4hW89AFArhreX4G24JUcVl7WLe2OT2J6A3wm8XVvTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTO/qJtYuzdZ/1brGGl3rK6pHRvo8hF8YYMwAsfAcnc=;
 b=gUddm6uJq4h1Ds2b4Atme8A49IeAF4qIacSirQfezj5xTT1qAPe1Xm3iC2Y6iyMFQ/8X0wT3GXrwiDzwpr79B+ma3dNFo0zux6vVZvcEYHH6+7K/AqGcwDlI9395SqxTuy/k4SzrwXvhn3UUO/wwCzgYV0MTyUQtCihsEFeZ+tpdh9hvAPQQck5aHW1l40KYfI8FxsZRkjvvgSH5qB2/xV80wYTPYC6ua5ccUWnx9dWsCcoC45HWC+KVnje+xjo23Bakg3rHMRhXmb7EVrQ/PEIqxbRf4N4pWEbx+a5hzYIWKV1BOQQnnvfjNwjgezhZkFiTpDw+VgRcSANPC61iPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6430.namprd11.prod.outlook.com (2603:10b6:8:b6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.33; Fri, 16 May 2025 08:45:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 08:45:21 +0000
Date: Fri, 16 May 2025 16:43:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
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
Subject: Re: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping
 level to 4KB for TDX
Message-ID: <aCb6nyioDduLCuHv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030913.535-1-yan.y.zhao@intel.com>
 <1e6ced6acc5c733c88879a3febe09942d32175d6.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e6ced6acc5c733c88879a3febe09942d32175d6.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 23986fd6-0283-4f91-fba5-08dd9455fe07
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?NLhyq7bnXPtPF4zEO9o8Ig/+E9ipqff3J3oNdAXUBr3Rc0XyKlxyyUtQVm?=
 =?iso-8859-1?Q?ZE+M26vmu2XKkSQ9ae1dMdB/EbVzwuVgHkzSD2iZDMPWaE3e64gHVink42?=
 =?iso-8859-1?Q?KJvQen6ZOLRiSzhDzls4Mk3DggJ5igI7EA9QHqMKqaUNLINB9Ig/wdG96P?=
 =?iso-8859-1?Q?8DKBv1vQksPvnHUO0uK41xXSZf7AeRGkLrTz32WSWXcmkR/AOEEUQ9evBY?=
 =?iso-8859-1?Q?lz3vumZbRTTehH7JoCFriFFmRBA8lNVjJoizGp1hBXXWOVEoh+oSPLLepk?=
 =?iso-8859-1?Q?bfiv65DWfLrvwExtGx0nZjZkGIJmvCp2ZEzh6d5EKyVlogowa4gwTD1Id9?=
 =?iso-8859-1?Q?GwmJtrGlrBe+bokUdmOHhaiXNWCcao25n7stTMe8s0l/mqSFNhNASYzmUY?=
 =?iso-8859-1?Q?1Psc02JgTWBmXR5u0wSnIbE40aOqZofgEkSUpN6dkhMnAtBT/Pk4WA9/PN?=
 =?iso-8859-1?Q?tf3AZdiPJjGWF5G4BCga+OYtp5rw/jrjNLpUXNmX11VA3P/AeqXfii8BPb?=
 =?iso-8859-1?Q?6O+wc3/JMB1DL4hamJW8Juvoa28QRt5RM5pi9l0v6DoLMd/sC7i9jI6SiG?=
 =?iso-8859-1?Q?/rf1+Dbtxz3nGmVPapEgk8XzCNsf2d1b3JKLbo3bHuu/60xYoDuDlC5dm5?=
 =?iso-8859-1?Q?anddqYBgTBjtTXeb0LH/BOdqvRqFKylWckxCXNPlTbv5MUtiQpFO9ne9k+?=
 =?iso-8859-1?Q?BGvl/qEkqx4CgOp/N2IoHeMNHBX5aUNOeu5wqpzmZZ07/7qQ7chQH7HRF9?=
 =?iso-8859-1?Q?JytAFzXq+pvE8wOW1QQcX0Jnhbna5mpKn9xp+XxTDZT57/7eMNNa3q0OjZ?=
 =?iso-8859-1?Q?Z7zzN/AjcjsRqWoGXHTB5fhSjOayY0hAOsxR+1+uhGjKxVbU2xkYv9uGqb?=
 =?iso-8859-1?Q?zyZUF7xaZJC2g3LxaLdI3FGYj5wVvpm6KzADcNwfVm6W8teY8HAmWJo7Kr?=
 =?iso-8859-1?Q?DsDknQNl5aPqaOjFHhbsaGC2+XL4D/BeyrXWUmmscEqzU0RaH9WlU5laNs?=
 =?iso-8859-1?Q?BZZmLftj1vQycZ2Xtmecs3ZUpZ+TW3thNGGJwDt0KxZ2vWF5nes6MyhTcn?=
 =?iso-8859-1?Q?9TLRf7bxMNty68h1xLNnHQLrUD4vkVHPvWU/CxNVusIcPMUlp7jvP94rMj?=
 =?iso-8859-1?Q?xDzOkTTo8eUHCgmjcDit6xRXh6USFd6l/mLswvieGQiuKXVH3yY11qM54I?=
 =?iso-8859-1?Q?Fhhs5SIhuKyt73Dlh4YC2aHM7m63azCjnWNnt6R2sblK+HZPe0HNsDaDtM?=
 =?iso-8859-1?Q?usGfQ6tJMedQZXqtX4FAn62C/XpZaXFRYziHf7Jwdk9Sg5sxPR+NNkEPo4?=
 =?iso-8859-1?Q?osT8KFIrEmiuFwh6aQCFqYc6iZ131zLLDFQY3XVgivnkPnITO+VQnPNcw7?=
 =?iso-8859-1?Q?3YKtHudKQ4OkAC3xw8UttSqZIIyh0el/nuB91keOtn0jZThTPT8BGxUnyt?=
 =?iso-8859-1?Q?An5n+BrPJefu8uSmcwFoaq74HDqqFhh6KVJyrr3qnXv/uqTGe9lAa6iFTp?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?SR7ZSMw6L82yF4qZrEzLcNimV8ACKKpSQ3y/t4nrmFJxXZO3jeFBahdl+y?=
 =?iso-8859-1?Q?1iUzKXMBTGceihYe4tXogHtgTy5QK9JBx1T4gah1S6nPBCPfIXa0Eu7m9m?=
 =?iso-8859-1?Q?qhztPG667Tzgbe7tgNK+Udf6w6/2HvnB3qsi/PTHnB+qCQhTsfuS36ksUz?=
 =?iso-8859-1?Q?rHhLTR7KmxqvGRXqc7/jGhcYK5qvxhRYDJ+nQPv4RfGx61u6mTr8ZTojOp?=
 =?iso-8859-1?Q?FOXKDCHIBo2zl2o9GUyUFA/jUjKuQS2/BPEWOn1mdUtLmvjTKcpCF6J0Xj?=
 =?iso-8859-1?Q?PL8N0RjJ++zwtP+02bpFPcqItahfu9N26ONXN2tzgiP1pg5uQef8WZzOIh?=
 =?iso-8859-1?Q?OJMv7l9lcsN+SW/833mjqljROyfQ3B8KGxyhW0U/I507D7KAz678pW1SuC?=
 =?iso-8859-1?Q?m1Vf7Rnmn30UuekYg5Ja+dD58uIV4G0WCYYkqmm5kRVvjSwLI7EWLW2Lsw?=
 =?iso-8859-1?Q?McsmiF+7EQxJeyuWJFZufnJEPSeok6EboqV+aPPsmWHj6709ZwXVE/UxT8?=
 =?iso-8859-1?Q?dF6QU6P4TZeJUjMZ9xXMFn3W+Cb/wD1hBx7plLroq6jrE07DZoqWJCdT2d?=
 =?iso-8859-1?Q?QzQfzv7AJK5F72AYTHIkcCWj0lvLRIhAhDX3m5phlThja+mIj4xNBjvNmN?=
 =?iso-8859-1?Q?aI2ZJHaVLNW8B42CbgLjjkML0qmoafzab+JybT2G1waOKA6+wLYTuri8di?=
 =?iso-8859-1?Q?7CDGUhvl3KBVYIpK2UPNA01Er3j5C+C/hPRSv/GhM0tHvhjF2PUAGjRvp3?=
 =?iso-8859-1?Q?sW9p9AQdj+kgXSwo5VJz1+5054WDjfS4eeaFkHBByq4+cNzNg7KeMU8QzB?=
 =?iso-8859-1?Q?UqQNOXSd373DbkGIntjQBs1aCKpJi12a6tPjs5rgCIhLlS7zekYo7Re07Q?=
 =?iso-8859-1?Q?hhUfRzumG44vePlUfLcMtGy874imnoJ3lkrJ8SFU1BC9WJT4JPqXt1bdh/?=
 =?iso-8859-1?Q?KmInomWBxrWrCEf5DzeE29/8UQcK4az6olTPxX3mcQfyx1gBL2HCCj9SLq?=
 =?iso-8859-1?Q?zN2kdzPcJyKett3C+dVT83FRpnPvOA/A9TUESZAMAoJrKQ9ZopVFZfWrdL?=
 =?iso-8859-1?Q?cPK/RpnAtbLtjpLW6JmSOo/IQBHcKmmkkM7oQk6z0cxZDPU10/nCI0Of4d?=
 =?iso-8859-1?Q?DS+LqQdrYTf6/0Nr2gdfc96c1myT3TGQJOV8D/qO7t3AdpKfAwF5Qv0jn0?=
 =?iso-8859-1?Q?aSNmruerWjFc6yS1irjGJGdgfAY9/gAf38jcurmNpO4vx6OG/OO3A9Msbx?=
 =?iso-8859-1?Q?ivMstwMjIekjp262nM8lBzAKkxMwnFgli74qcPMZyVCC3qawvb9yrEX9C7?=
 =?iso-8859-1?Q?QynQuX2w1yZitt9qD99rQUhZpfzeDjv1Yk2Pu4lBc/adIZQZAchvtzlChm?=
 =?iso-8859-1?Q?l0KvIExARphuyF6x462G92sPr4bBNwCtZWUUZWi2qfUewEgL0iWIc1XiMB?=
 =?iso-8859-1?Q?AB1w5Xbnrt1zJXkf2DdyTgQS8E7jxCPErHl28SRccheEy+0RUx6dpBD+Xq?=
 =?iso-8859-1?Q?oOhDVRaHRFpYBd03jEvhF5EVi6guXVjwlkPHUjKY97aamf+WwX5MxGIOhL?=
 =?iso-8859-1?Q?CJOsbdJ2A1FmHv12Lm/nEt8A+onWbpbvfAvtUFHwEBsKjhK7CizqXQ3LO8?=
 =?iso-8859-1?Q?0FVGiEvQYczJQih5CHseSjCIQXURSkd2lm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23986fd6-0283-4f91-fba5-08dd9455fe07
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 08:45:21.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LGj+GdUHwlcWwH59vB5UNFLvKWd7c7QinWWK1ew5u49ROgr4Qg29aBJSJrIkvvHEWpeOxWL/gdPjFmqqKh8Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6430
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 07:20:18AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:09 +0800, Yan Zhao wrote:
> > Introduce a "prefetch" parameter to the private_max_mapping_level hook and
> > enforce the max mapping level of a prefetch fault for private memory to be
> > 4KB. This is a preparation to enable the ignoring huge page splitting in
> > the fault path.
> > 
> > If a prefetch fault results in a 2MB huge leaf in the mirror page table,
> > there may not be a vCPU available to accept the corresponding 2MB huge leaf
> > in the S-EPT if the TD is not configured to receive #VE for page
> > acceptance. 
> > 
> 
> Can you elaborate on this case more. A vCPU may not be available? What does that
> mean?
Sorry. I didn't express it clearly.

If a prefetch fault results in a 2MB mapping, as the guest is not aware of the
prefetched mapping, it may accept at 4KB later, triggering a demotion.

> > Consequently, if a vCPU accepts the page at 4KB level, it will
> > trigger an EPT violation to split the 2MB huge leaf generated by the
> > prefetch fault.
> 
> The case is KVM_PRE_FAULT_MEMORY faults in 2MB, then guest accepts at 4k (which
> it is not supposed to do)?
Actually, the guest is innocent to accept at 4KB.

> Then maybe the kvm_vm_dead() case I suggested in the other patch could handle
> this case too, and this patch could be dropped?
 
This patch is not required if we decide to support demotion in the fault path.
 
> > Since handling the BUSY error from SEAMCALLs for huge page splitting is
> > more comprehensive in the fault path, which is with kvm->mmu_lock held for
> > reading, force the max mapping level of a prefetch fault of private memory
> > to be 4KB to prevent potential splitting.
> 

