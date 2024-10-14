Return-Path: <kvm+bounces-28711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CA699C01D
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 08:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09EF31F2325A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 06:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC54D143C7E;
	Mon, 14 Oct 2024 06:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gl7KmPlo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310C683CC1;
	Mon, 14 Oct 2024 06:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728887812; cv=fail; b=hC9yqLIM0uRWobpSkvXKoVcSYz69HPp45bNFCm3duemWZK/Dta9n+TO5BB+LzmKer8U1UH0L+j2HiYox4LfZ4bJAW2jYHoGUalMY06NbkjzWOe3HnvEDXL0I3B1LAGwQ3cK6pqvEqD8L0qHfpNFCnKIBmYSB4n1sSaFX4yVyzq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728887812; c=relaxed/simple;
	bh=SR2YybBCWvvH9X2UGaQ4pXt014krnVy68TZ47/IiZ1w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=izKFzWejDpjt3TwV3PEuo6QwU5/wzzRlrPwIVqbsgjDMUrBPlAqj0FtUta/5oS3LmtS4z74SKyIiSNKdYC4ZqewtUfn0hos1+UrPfxZJdhCxj1t7ErQd2x7R1fvT9cqArM0l7dHd3o0W636dnQvA8PsK2sFxKENYMFBZ0hJjFWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gl7KmPlo; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728887810; x=1760423810;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SR2YybBCWvvH9X2UGaQ4pXt014krnVy68TZ47/IiZ1w=;
  b=gl7KmPlomp1kyxYcTfAp0BZ+NdTQF0qExIDIuUw3dAoYPdj5IJchAKgs
   6e96Qv9Ni7/Zk+UlQViGTeFkIMobwJ/Ux9MzbT0vErTA+QaQhRVrWlNTa
   0F/kfZJd9SYt8l+pwYfdArPbNWmgSWGyBbFpXq6qDsw9YZmQUDzv7FdMP
   1xap0jYCYCsNxnqyRGcIn/fK0jJU6qlzYNOaWbwQGFDSmtVQK64O6SN+3
   K3KWcnf6/Nqa1IVHY9m14JEe0GzG17qx7Qm1l/gjgXS88qgiS2euZ+gyc
   KiCUOWq/RKFHPm8yTsxOs5EshwyrKgdkwfu8kC6+27j6xbyecWxbrnHm9
   A==;
X-CSE-ConnectionGUID: IIpmdK7oSICk4hfWLiNLlg==
X-CSE-MsgGUID: V3xa7yICQquvFtBxpHjIow==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32017305"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32017305"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 23:36:50 -0700
X-CSE-ConnectionGUID: UXOxeHtASeK1/nBs0tMdKQ==
X-CSE-MsgGUID: k7im6wmlS6qoLv5w0QlTvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="108232573"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Oct 2024 23:36:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 13 Oct 2024 23:36:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 13 Oct 2024 23:36:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 13 Oct 2024 23:36:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 13 Oct 2024 23:36:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMcSH2t5fga0kasnxm/wk6RxHoFumVK82gru1kxG0Fk/SIEghbk6De14EnBmHwzE1VLd4mCcIzi6RBdxX2wJYH0sIsojIRzkHb6LJt4FkpF3A45ReBBybjmOehXjv/zAzo3JSmOv8c5ovvi6IMr2b0ZVlwPd1ugZ2er3ksyT5Zpywga++0HbGkM68f/S3U6FM6afMc40rtrKQvnp94wEM97hl/4PHXfUCwt3fAHsSquvkyygfJ+E6pvLL8l2KmJYN2eKZrsd8feJfZ00XUcPHUl8s7O6KTiN8qk4TmRAzW2WN33NBa0TivIk5EDZBDWAuhftKx5r6GzlQwRtL5jQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5M1QtRuQF0oshZ2qNuSUIzJkgAFhY4jmIW0e1XIfFwI=;
 b=l6kSl9Y7/yoso0w//6L/eO4geUSgjBS11OK3etWpQ5zFQVt0WC7J2R87QWgGQFSUJPSa14SU7jqZLgzLQ8N6Ykp3x8GtoK3d18wybswGPE8l7edU/G+BnDNLLuBlaCsUelJ5yx1jXZgPYyma3+cbaxehsOami4mh41+PsX02c9xfsusScFTCAiYspYf2jlDSp14sGZAgDuyad62bviB/FnWf1Im8G+YIcL7iBFN+4VJHHBxC8W+JyxbI0lcWRrz9YGEG6zrnt4FxXrG48vS0kIh1f2FJdvsM81MdWo6YXSgis7ytRaglFuwfpLak+GdAVgLBilZD8ZA5ex8bHi/2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6605.namprd11.prod.outlook.com (2603:10b6:510:1b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 06:36:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 06:36:45 +0000
Date: Mon, 14 Oct 2024 14:34:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <kai.huang@intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Message-ID: <Zwy7dMTMR2bIDtzM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
 <e4ebdfca-fcb8-43fb-a15b-591d083b286f@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e4ebdfca-fcb8-43fb-a15b-591d083b286f@redhat.com>
X-ClientProxiedBy: KL1PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:820:f::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 82459624-9c08-4266-de4f-08dcec1a9276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RUocLGaiHzTfpMYDCuLnld05nGEZrvfxOKtkfQhuEDzPp9ToITLHIXpVn/Hb?=
 =?us-ascii?Q?T0gpgNMVi85fCFyH1mcm8xbYfXHtGCWCKGtrqcE4AEaJ5g1qdcO4qGRZx9js?=
 =?us-ascii?Q?Noxp7vYOLTcwxrDnXqTCoAkFMiEkbtNKuVAaLF+g5KC07QXCuLwwFZVYDej7?=
 =?us-ascii?Q?EbGcePnYNvz/40qmHJzvGi9CLVlkX71gTEWRB1s/tGZzCUxeoqVsKbx0/5sB?=
 =?us-ascii?Q?8mIFaGLypNx2aymn9g71bChYvg4v4FGFsBmSCRBOSMlz0V0v0eeBEp8c8Lqi?=
 =?us-ascii?Q?jET5vsHOVa0mSIqlEtTE+rV4E4wNfS+AsmJ12GYmEfEFwIAh9ijGOX5fCiKd?=
 =?us-ascii?Q?nlS79RE/yocQ5YoqKIiCeD7k3ZYPSsqK8VqMz8JJN6FkM3h4EKzUz1rqj/Sl?=
 =?us-ascii?Q?H24vKHYs2d7KHq55K5i4/2Z9BkWgF2jh0VaPKktdZeY//uobnOWulcYXAMhn?=
 =?us-ascii?Q?XFoXXMhINrzSCLI8Uw+adWv5gYe/nUzngPsxhq0afE8QqkavmNJfLSRbKtw9?=
 =?us-ascii?Q?E/BiO7+KiQN44ngfUR3xiFe3IJNp6ncR7UuiNz+2ahrc9oyzxrpzzKNykbKT?=
 =?us-ascii?Q?zQBqh8JJ1Aco4vG+CxGfvH5CmEQ43aVXhUGG2F/U3a/O0MVXZEz+VUBf8aLE?=
 =?us-ascii?Q?UQa6jPyU2mZNv0um3mS6uIZofMz/00H+YscVRjDVnQNGi+AkHolNONJtXHpe?=
 =?us-ascii?Q?w0l7D+IqbkQzTOERUweRlHh1BPsWeeaRWdR4vUtHqZSXOxSKoMwZCk1IzxzJ?=
 =?us-ascii?Q?zwdUJ1iBIz9wwPnlFi0NmFTEFy6MbFyO81RRtdi3KL5RlJvJifcdquT7VAUF?=
 =?us-ascii?Q?XDI5d/a/kRUQpoClA5HDhiAjbr37gYESOtezfsgzoiufIpkH/WM1MaOQbesK?=
 =?us-ascii?Q?Sijt7ml7DKlNgBiMKGJ/EeQ5V+pGWpM/KH8vXVpxWo0D0fdVANTbe0v4T99z?=
 =?us-ascii?Q?ZFTwDYVElsz4vjm7oTdTNcFWb3ZWOjUie/47Rq+Pz+yaXpJnpd6ADIUY1L6j?=
 =?us-ascii?Q?wqVvoZwd1kxuXOuIFuSVXexOvUlELXrm3px7D7Y5yn3RP74EhI/dVk49bwPS?=
 =?us-ascii?Q?6m+XhGgZjDYYow9RyWDF+1vf7cZSi/9sRjs+WAege2aIixKlaoBsVbHiQ447?=
 =?us-ascii?Q?iQ5k19O2vQKYCG7RWHltj7jRLkVS0hjqOg/H+bBpYNWkskyklHcSzzuRrikv?=
 =?us-ascii?Q?QfIJA1dZRE9WnaLY7+FRHSy8uA+Y9vaLA+cwXo4J4r/2JdImvnbUqQMGJX9Y?=
 =?us-ascii?Q?a1rWbxo5VlzcMMiCLR8v1dPGyPthujCzC/1DJdJgPQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otaoSZHat8IcNLte1rhvJblFz+fyFvCpHUAq6tUjIc7Nlg9zfIRpXxZtext8?=
 =?us-ascii?Q?NbbZtlXr9TgEHLsnwacd8nu1yCPruN2r+tWt4StZ1BmqoBMIIYJD1cmAy0oT?=
 =?us-ascii?Q?OiuoNUXXOfOhu7mvaxN57Aqt2a6lwoeoeve/WqgU8A6eNk+Gv9Qj+gVy11+V?=
 =?us-ascii?Q?10J2WFKNZhW954uqFbxJf6Pq3o6LhhzcrYQ+lHHe2fFB3Rog8bH0iIsmcLs0?=
 =?us-ascii?Q?rBesRnS+Xv4gwQUEsPsZUseJ/cUmp2A/XYFWq5olpEZ0YIYsaOmt1dBkEKY6?=
 =?us-ascii?Q?IDfRkRZ+v8S/z4MquXqJKpqOXjTkD/TWatz/EM3nnkPYX5zziWgRAUShDiW5?=
 =?us-ascii?Q?WIM4GsfyMlz8mdP3LThqK/+hPpvWrtRsZtrYNLmgfDwMq0jWz9GKFKyNtqJw?=
 =?us-ascii?Q?oFqht62Rn6INRxOEHm6z553GpExAsQyYzcm8Rge+oQa2FcFmykXLkvvW+4ZI?=
 =?us-ascii?Q?qyGWIiJgYdHRC2Zu1oov3PHLiIcpdfDY8KnqPMVcE0InhzdxiTTVH1iPy2vQ?=
 =?us-ascii?Q?P0x3tJTi48DfDPf5dgG4Zozf6rZrpvUP1T4Ppz6JaxiQOd90dIu3h9KrEEYk?=
 =?us-ascii?Q?0MTYqTMv06kV6qbAMQKtG4iIwq0R4swDmjv8Siy+Q+Kpj8dSd5vENJniIlLZ?=
 =?us-ascii?Q?UQoNMCQ1+zfOil5P3gklwOgJ9Y0djZKWionODvRfTMiz2rXx7LaLsAttMOBh?=
 =?us-ascii?Q?US6ZEsLJYlEOjTg42M2J2ACkr2bLLtFjgaea943FpVAq7giHQWapp9imAPbc?=
 =?us-ascii?Q?AVEpwTlhbcXEvc991wjFFvr/RQe//GBKfW1upxSHK/MzS/shQLzOuU1rUm9d?=
 =?us-ascii?Q?uDJL+eOnw9Asy9ESvRT4OvrWzterAlQOCJKEpsb638twkjMR4qNGBeJ06pIc?=
 =?us-ascii?Q?ngTbvQZcegi5QQUC5snr0xlfQvkAboG0LLT0YQ1qPqdJYaeTlB+KESWS1j8e?=
 =?us-ascii?Q?liX2ACVTqVxKqr3rrZdeWT30CLK96urtVafSRj6DLXUValxV9msQEtRJx0ha?=
 =?us-ascii?Q?xY4A46mE8r2i9Z/50UF68gnTdYHBfx7dmYBM9mHLWLRvZPB4XInEJMELD753?=
 =?us-ascii?Q?3LtKWJ27XUBnuQoqTDpAJXS/MY+cc5rlKz7DOgN9hdAWZg6ZkdkAk+gHSFHf?=
 =?us-ascii?Q?rNJH7HoJrGmEr6wxXaTxcZCmu0ftYt3SUJ3KKCQ3hQhf1Ri2hlNpzo6757Uh?=
 =?us-ascii?Q?r6Cf959a4lDWcJzpWSfF3gw3jdufjzIk1DSneiH9UKPRxa1iZIYLoS7E0t6n?=
 =?us-ascii?Q?XA2pbeDspY/AwbWWbeuGbKs9JlLeA+B9etey8H4JfezVH6d7fDchtzhJbwGy?=
 =?us-ascii?Q?YapTNwWEl3sg6Bh4npAQ/oTxU6FhhvyC2xk1JTFU2rYx9+FYq6Uc+Hgriu0J?=
 =?us-ascii?Q?UJ8mV43YnpwOl4pZu2ORAaV9+3864/FFylRIu3Ey2+XF62tXMOfD3oq48KwN?=
 =?us-ascii?Q?mVK6fnVlACkyBthP8RKdbS1XS9FTLG21P2HkPLm+BnNegz5ciJ0qVXrsyGAZ?=
 =?us-ascii?Q?QxRxpSih0/mpnfGaLl4mYa5VKFdhrubFz2WassO1qplavivW3zkWy5CSY40a?=
 =?us-ascii?Q?L6TWSbyGnQ/2sfMOFTRKFo85mleP1gh0z4VUAehM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82459624-9c08-4266-de4f-08dcec1a9276
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 06:36:45.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQY19rvIREf1d/iXQVQUUCurWGLpPxItEKTgSOfIspL+BWEXE2ZDCANs84Gl6i9cazh3ok2PhwWDaXiVkbI5Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6605
X-OriginatorOrg: intel.com

On Tue, Sep 10, 2024 at 10:16:27AM +0200, Paolo Bonzini wrote:
> On 9/4/24 05:07, Rick Edgecombe wrote:
> > +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
> > +	 * private EPT will be flushed on the next TD enter.
> > +	 * No need to call tdx_track() here again even when this callback is as
> > +	 * a result of zapping private EPT.
> > +	 * Just invoke invept() directly here to work for both shared EPT and
> > +	 * private EPT.
> > +	 */
> > +	if (is_td_vcpu(vcpu)) {
> > +		ept_sync_global();
> > +		return;
> > +	}
> > +
> > +	vmx_flush_tlb_all(vcpu);
> > +}
> > +
> > +static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu)) {
> > +		tdx_flush_tlb_current(vcpu);
> > +		return;
> > +	}
> > +
> > +	vmx_flush_tlb_current(vcpu);
> > +}
> > +
> 
> I'd do it slightly different:
> 
> static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> {
> 	if (is_td_vcpu(vcpu)) {
> 		tdx_flush_tlb_all(vcpu);
> 		return;
> 	}
> 
> 	vmx_flush_tlb_all(vcpu);
> }
Thanks!
This is better.

> 
> static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
> {
> 	if (is_td_vcpu(vcpu)) {
> 		/*
> 		 * flush_tlb_current() is used only the first time for
> 		 * the vcpu runs, since TDX supports neither shadow
> 		 * nested paging nor SMM.  Keep this function simple.
> 		 */
> 		tdx_flush_tlb_all(vcpu);
Could we still keep tdx_flush_tlb_current()?
Though both tdx_flush_tlb_all() and tdx_flush_tlb_current() simply invoke
ept_sync_global(), their purposes are different:

- The ept_sync_global() in tdx_flush_tlb_current() is intended to avoid
  retrieving private EPTP required for the single-context invalidation for
  shared EPT;
- while the ept_sync_global() in tdx_flush_tlb_all() is right for shared EPT.

Adding a tdx_flush_tlb_current() can help document the differences in tdx.c.

like this:

void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
{
        /*
         * flush_tlb_current() is invoked when the first time for the vcpu to
         * run or when root of shared EPT is invalidated.
         * KVM only needs to flush the TLB for shared EPT because the TDX module
         * handles TLB invalidation for private EPT in tdh_vp_enter();
         *
         * A single context invalidation for shared EPT can be performed here.
         * However, this single context invalidation requires the private EPTP
         * rather than the shared EPTP to flush TLB for shared EPT, as shared
         * EPT uses private EPTP as its ASID for TLB invalidation.
         *
         * To avoid reading back private EPTP, perform a global invalidation for
         * shared EPT instead to keep this function simple.
         */
        ept_sync_global();
}

void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
{
        /*
         * TDX has called tdx_track() in tdx_sept_remove_private_spte() to
         * ensure that private EPT will be flushed on the next TD enter. No need
         * to call tdx_track() here again even when this callback is a result of
         * zapping private EPT.
         *
         * Due to the lack of the context to determine which EPT has been
         * affected by zapping, invoke invept() directly here for both shared
         * EPT and private EPT for simplicity, though it's not necessary for
         * private EPT.          *
         */
        ept_sync_global();
}



> 		return;
> 	}
> 
> 	vmx_flush_tlb_current(vcpu);
> }
> 

> and put the implementation details close to tdx_track:
> void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
> {
> 	/*
> 	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to
> 	 * ensure private EPT will be flushed on the next TD enter.
> 	 * No need to call tdx_track() here again, even when this
> 	 * callback is a result of zapping private EPT.  Just
> 	 * invoke invept() directly here, which works for both shared
> 	 * EPT and private EPT.
> 	 */
> 	ept_sync_global();
> }
Got it! 

