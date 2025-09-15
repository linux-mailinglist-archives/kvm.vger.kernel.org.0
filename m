Return-Path: <kvm+bounces-57531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB41B57420
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71FC47AF6BF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA8B2EAB83;
	Mon, 15 Sep 2025 09:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5vdT0XQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C84502A;
	Mon, 15 Sep 2025 09:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757927241; cv=fail; b=tWzVcmudbbQcNMwiQjlHGuVO7i1+V/nKpvE9koe+CgzrtYh3cSdXwSYEq0Gng4TvAGgRr0PFFjA4h32V0N0GkOcEgo1eOcpuqLuDz5jWlLihLvXxceMh0iDRg6URTPtB+MmZrH4QSfhX7KvKolwXqsohf/O69eY9pz1KJBK5XQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757927241; c=relaxed/simple;
	bh=ld9I8Ppthi64fCn4dSQQrIcYsrCWAjR02I9IVT7guq8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iN2Ng6hjLmoBIldvSt1O0B2m673JBQVmjzVJL05hX7l02gK3u7XWM4ZRP/7AQVBdWuMVN1hC6eY1Lts59mmi6XZCtcxrz7LFEJsRhNpLRexM2Ft/nsoqvNOy0XLGIJLCqVPXXHMuJ4HptZhoy3hZy3hi25k/hpz1mNb5wbXcOEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5vdT0XQ; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757927239; x=1789463239;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ld9I8Ppthi64fCn4dSQQrIcYsrCWAjR02I9IVT7guq8=;
  b=S5vdT0XQKdH5F4K9XJLmBgjR1+yxrxcwvg7FlAbbMqEdRatKo/IUybyb
   sjreTwHZZ6qK97R1hhsH7uN4/5YeVHRt6XqsmcUG7lmlC1vOHkX0ApQff
   kYpZ5rpGon1QCtiPOAiTz9n6jWE/NDBZMBHLCYMMKcdOvSIQp9ITuueUg
   qUagAb+vupqzh8trY3ErazQ/sL6mNMhB0pGMUaMO5awGRoy9StG5LFyQF
   NB0WpqH0wYtjTkSGq5yPPdHJUsAk+rY2IqvNJ9LGdpj1L+VHamYXno/cg
   ovMukk+shG3T3+rn4jDzXdCZ4kiItTRqZBnpLrjt8uAkGM7CnwggZUeUJ
   Q==;
X-CSE-ConnectionGUID: 4eI6Z5dsTyqgOGFRjQhigA==
X-CSE-MsgGUID: WTiQfjgjR52cmCu85+7PfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="47743302"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="47743302"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 02:07:15 -0700
X-CSE-ConnectionGUID: 9UwOYGCiRtCxkfOrAl9PjA==
X-CSE-MsgGUID: EqVw2oXxRhKJM8GM5KbzuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="174166442"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 02:07:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 02:07:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 02:07:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 02:07:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KFnny2wOALRjJc0Acb4Q9V3yu76cPgfoLeeeajTgqhFZAR/ai3dh3q3dN4w305e9HauQY2K781Mq7TrDs+f6kaq28hx4SswOx8WiH7vTTd+BC/xYde5DgwQvq+bwI32zusUtZbE0mXENE89/M3gqchNajyEG1JAqwTPexTBvJclgdwjzxK+ynZgVoV5rVDAMYXbBy+dwmTqd3BVbPNmPgfXt2+pYr+G3VpF9UJMalLDJl0z3tEp11Kn1evdTQHwLKbT5NI53O2mRUKoJ+rLdaqLCjl2V/7bhOjFKZ0U7INU9+/DJqtObXTixCAJLAzeuyOH+Bi30GSRYq1BBgfqArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYO+ev5M2sEN4vIbe0XRZSbWErFRaS/sTFwy8W8QxUw=;
 b=yzbu8qFyAwedQDkpd/nVfLP+fk2ouhubh56qirS+7lnxHEsZGW7DYS/pIrqkiirGAjS2XOoTVlleVdHUncFUNuneURxYaIGxHNAsACfx0SXBwNMg5/0Npbu3EQmEUsWfs8v01l+8Bft1qWcLOIAot5a9mzELAlTCK0lPQ/9HOy5dbmt9SLzG0647kFbSlpxqgycIzXo9VEZBnQ8hv09h9JnWYuXqVDnpomXoaPz9hgJqJ4XVFKNAQX4bUY5F4TfcSyQmF9KRrJrsO3YfFqtX/9Q/hhScLx7x34I9k6MS8jkssLNe7oUCWQ4O78y0KNa6FvEN9PNQudjI24jMhUQDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4799.namprd11.prod.outlook.com (2603:10b6:a03:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 09:07:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.017; Mon, 15 Sep 2025
 09:07:10 +0000
Date: Mon, 15 Sep 2025 17:07:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 34/41] KVM: selftests: Add ex_str() to print human
 friendly name of exception vectors
Message-ID: <aMfXNCHCRo4csOBL@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-35-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-35-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com
 (2603:1096:4:92::25) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: d90e6f38-a2a8-457d-03a3-08ddf43740c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6yS8peMuO/OwLKdVVNBGmvRkxWq95vxK3bi1IzmbYViVm8xnCy327bVQjKXA?=
 =?us-ascii?Q?z+vhKSjXI4rO8LKLCuS089cvT9qlRmm7jBGng7LcARHs/PthECUbaSOBheji?=
 =?us-ascii?Q?CHnhd4rhRkM+KPsASAoZr3en2siQnAPyRrdm71boht6jeLvQLWg9b2bbnTwD?=
 =?us-ascii?Q?sbGRuBEcFaEIMxoXyTQPCDqWhKM2R2Xf9OkcOZ+2SGtDu8A9OrF7ZjP2GevX?=
 =?us-ascii?Q?GxzbQmuD9tzJLv1bWlq74D/KuBwxxG0WE9VfOwUzZFCGjjK5nRk7PwWwO3j+?=
 =?us-ascii?Q?8GP3BJk0Ti5ZN1UQqU4AQ7z59+PWB7WHZ5zffGxHmnMh6LYPn9rXNqS1g+Q6?=
 =?us-ascii?Q?VprIqApSKGJog8736r35sP3LXxLMilFrElmHMlBlWieuGgURoED3YpjeRJPr?=
 =?us-ascii?Q?B7if/7oV4XObrzcp92g2RWjYd/t9hUEHaCp0c76q3zhOHXSaTLfqOgVYAUUv?=
 =?us-ascii?Q?QXvS51EprLbzhO7YF2nqXeKP5WiSyI1JbGy8zUyTKh4s0RTfCWE0v2HvskE/?=
 =?us-ascii?Q?NJYwFVkaGGQmEp3Mpi83HdQyMAmWxFfoTSvtZwSi04qedS0RoXdU7tkjRz3a?=
 =?us-ascii?Q?qW76zDtFPML3tmI4RnbSVyu+KLFJgDJ9C4SmZzOhSCg4dOL/UE+qZwUnQmSS?=
 =?us-ascii?Q?bReXU9X+Qt+N1/WRLKC9/d8K0zacvmCpX/DabtOJJ4DTp5xIX7sTSJvnNfi5?=
 =?us-ascii?Q?n94R0i5PdP0sZq1GbIAgm2jp11w+l9FeEj9BFwWLJ0gqVp59C/8TCjBxJbS3?=
 =?us-ascii?Q?90nrLmMHkI+v+C2xM1Ect6B//HWnGHrtS8W4ZTvMiWmdQr3r7rKane2fcKk5?=
 =?us-ascii?Q?KauFWHhs53SUgEc0K39DNA1oCnMo4c43/JaDt7jZ3Guk0+oL+Zca4lb6mV2D?=
 =?us-ascii?Q?jA7ANvLJaeTzfYkHeBFxxxrVo4nqmf8qHr88Oryp+WKA1DFx7B9NaeBkvvtc?=
 =?us-ascii?Q?5Fv/e9H5iW9+sV5ZSj8RJQ9BZTMDepjjSuxGhmEblmA2CZJXDKnj/5cP4ZLf?=
 =?us-ascii?Q?vQsFoo/d3rdlyWmsYrp3j+osMFA8JcwznaHR29PkvZrGo07wRJ1K0zStKxgo?=
 =?us-ascii?Q?EVKTA/39GMcFp9097w0xX4MevuZ7MXK4Q1vEIIDhYTAdqRm+xydL4Y70Eh22?=
 =?us-ascii?Q?E23t1VJbVBd9eE/kM+w3q6MfAxZ4uLIUpSwROyE91jcMKypAZ9oHERDUrySf?=
 =?us-ascii?Q?kild3Ygh8GvjeeDTRIGeCz7MxrVl1GtYlSae0zLpjA1AWk5Sgk+AjNGZkjIt?=
 =?us-ascii?Q?MrlDW6IREx+lWCi0FY6RH35VRF+Gt5GfKylshor9wq517XfXNn/37JmLVnUT?=
 =?us-ascii?Q?X3sfq9m5xbbtulJAhZlZIz4XcYim/LfwfGawYg4g4J8rJfSRTv2v3c4N37hU?=
 =?us-ascii?Q?5B/kjl7hYT+fFmosdRsuDQMOAesoRFVdRN40dZILn7a8QMXeMUrgZ67tKyUH?=
 =?us-ascii?Q?aS3WFX6WWZk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kRyXfNV/vB1SQKb4tlh945sphvYjTE6amPcruUmJLT7XoBQClpgpqAyhesFs?=
 =?us-ascii?Q?3nQ/Pkys8V3SLNAJFJ7tmGbmiiRFUMgJ4ameObbP8zqvhpYzok0vlVXBRhKg?=
 =?us-ascii?Q?Jbx4Rg02D7iUQebhvr2im3L4Z7vz2xf9ch5LX+dTawIbmMUr84OUpsCEGcET?=
 =?us-ascii?Q?rIqjzam11tpEmJT4DY/Vdt0cb3J5zeyIGbdeYVv1EYhzgSgC3h2OIx/hFpGx?=
 =?us-ascii?Q?huiez7JscpfbTAoSdNyJ8Q8itsYCh/RHwZ+kLR1t3IzdPsx+EfCw49gmfv3o?=
 =?us-ascii?Q?0BicxqBfHP9XIdRkTtr8KYur6BoZ3T+bFo0GbkyLpfvwrT9INz5gXk3fjRpX?=
 =?us-ascii?Q?j5IoIW3k1EgCeWaMADfEbSC2i7gW/JFSa/QFsB1Smk8pW6/X1GFHXtSCKdlY?=
 =?us-ascii?Q?YNf1SAuD2MB0loXAWu7ReioY1h3KkG2dZWhzNpMBghEaVvlMZVquFQafI/nn?=
 =?us-ascii?Q?U7Pl5GF2US7Zhz4m8/LmIcDkofgl9yPAeuow9EmEGLtYa3krLeVQkXpso1VU?=
 =?us-ascii?Q?i+iRvVyDcszC5FUIndnF2oA84xQdZF74VVa7hH51b7bnX0yudvdLpX8e4xIU?=
 =?us-ascii?Q?1MXtk6XNiimg94CJLXtIUOoY5nwF2k/QVz+nqYjL2wjj7leeNx7A30q3F9yp?=
 =?us-ascii?Q?EVKd0dENQNOE+1MnNxwj2n87gIM5OToHcHp07+Kj4zitaYjJxN0vVF6uGDt3?=
 =?us-ascii?Q?86aQqf1HOODfya3UbkxGzenZ6TMtq7/QledIXC665m4z4sYZFX/xoG1+CxH0?=
 =?us-ascii?Q?2F+CcFbj26v05oqvQNKBD4Ge2fxcIwKZwNq8AbCxurXN4XRyQjvLC6sKKXeS?=
 =?us-ascii?Q?yzl4W7VmBkGJG2dw4vp2UFD7p02kKrXs0OVcVXdxS12ii5HHWhp9jFbTVC7l?=
 =?us-ascii?Q?B8lUKVT8fwxgNTFK4cX6J2fihHya7X4PfgWPNIKEaR3HDHsHqTK31l9CAjWm?=
 =?us-ascii?Q?lc4OohRQIdnj2tVt0583fCl/9azg+ghaNEw5PFGofcUqyTyyN08qOsjv2Snp?=
 =?us-ascii?Q?vG0mdLpmb/94liaaLznbcWIyiyX33X96iVWNsv6o/0rvRlO5Vjj0PyOacIFu?=
 =?us-ascii?Q?IbC/CrByCihZH77iwjlbklh6hyvOhYi9Ro1M3wgB4cTnH3nNM8gAu0sECFO1?=
 =?us-ascii?Q?0mv3i0n4+5xPc1dIrYVj8V96ACMEZcNZ1dwAYFLVkAE8BIf0U14oLOEayWwj?=
 =?us-ascii?Q?NUwXqTQ1nK3DQsdjnvXMOOIhTknVmTAgVsF6LtVp4Ad6mNy4JbtWJ+ZB3fk6?=
 =?us-ascii?Q?Vbt/FEPdYTESd4w8FEiAbzsJLn4mcmUQ+w9uwdFkAZOoPu85Sd8V5e9T6JPl?=
 =?us-ascii?Q?F97Bna31xrtsr4oeZ41DxwOhvin1Qf2xewXjVqaLF3RHNNBsOsVZ4afzYCac?=
 =?us-ascii?Q?XZpQE+a46v4Q1J7evhKYkLDMrRX2pBdHgEj8PqQRX+vFks49I83zFjvi9OjL?=
 =?us-ascii?Q?Uc2fWFwT4IQ1ESTAtSfCfVtblvJguFliT1UFAGXIo1qlpHfd865wr4GCAOh1?=
 =?us-ascii?Q?zySb8Q/2Qg3hRyE/Pj3q9YQhlkzphbgTO1ohYEtLbVRcnQgIWmM6OzPe8gPm?=
 =?us-ascii?Q?GwBjRe6qfk2nkiB+a9LqgefvPBvtrV/otF3iAjKM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d90e6f38-a2a8-457d-03a3-08ddf43740c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:07:10.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8m7r0kr4QqWgpGRiUD1plBs7GEAtJcf5IGiilF8NGWfFFvIQbW8Aju8z3Qpy7rnlpPH3nT9APH0HIiexkpQtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4799
X-OriginatorOrg: intel.com

On Fri, Sep 12, 2025 at 04:23:12PM -0700, Sean Christopherson wrote:
>Steal exception_mnemonic() from KVM-Unit-Tests as ex_str() (to keep line
>lengths reasonable) and use it in assert messages that currently print the
>raw vector number.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

There are two more assert messages still printing the raw numbers. Feel free to
squash the below patch into yours.

assert_ucall_vector() in nested_exceptions_test.c could be converted as well but
its use of FAKE_TRIPLE_FAULT_VECTOR makes me hesitant to do that (e.g., we need
to assign a name to the faked vector in the common code).

From 90c502e97be6acc37f84a086c50ecb180719ea46 Mon Sep 17 00:00:00 2001
From: Chao Gao <chao.gao@intel.com>
Date: Mon, 15 Sep 2025 01:41:03 -0700
Subject: [PATCH] KVM: selftests: Use ex_str() to print human friendly name of
 exception vectors

Convert assert messages that are still printing the raw vector numbers to
print human-friendly names.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 tools/testing/selftests/kvm/x86/monitor_mwait_test.c | 8 ++++----
 tools/testing/selftests/kvm/x86/pmu_counters_test.c  | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 0eb371c62ab8..e45c028d2a7e 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -30,12 +30,12 @@ do {									\
									\
	if (fault_wanted)						\
		__GUEST_ASSERT((vector) == UD_VECTOR,			\
-			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
-			       testcase, vector);			\
+			       "Expected #UD on " insn " for testcase '0x%x', got %s", \
+			       testcase, ex_str(vector));		\
	else								\
		__GUEST_ASSERT(!(vector),				\
-			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
-			       testcase, vector);			\
+			       "Expected success on " insn " for testcase '0x%x', got %s", \
+			       testcase, ex_str(vector));		\
 } while (0)
 
 static void guest_monitor_wait(void *arg)
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8aaaf25b6111..36eb2658f891 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -344,8 +344,8 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 
 #define GUEST_ASSERT_PMC_MSR_ACCESS(insn, msr, expect_gp, vector)		\
 __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
-	       "Expected %s on " #insn "(0x%x), got vector %u",			\
-	       expect_gp ? "#GP" : "no fault", msr, vector)			\
+	       "Expected %s on " #insn "(0x%x), got %s",			\
+	       expect_gp ? "#GP" : "no fault", msr, ex_str(vector))		\
 
 #define GUEST_ASSERT_PMC_VALUE(insn, msr, val, expected)			\
	__GUEST_ASSERT(val == expected,					\
-- 
2.47.3

