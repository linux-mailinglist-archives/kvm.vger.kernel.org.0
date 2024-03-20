Return-Path: <kvm+bounces-12213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68ED5880BA3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F72284129
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 07:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE841EB45;
	Wed, 20 Mar 2024 07:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUbLvqrM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E61DA3A;
	Wed, 20 Mar 2024 07:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710918126; cv=fail; b=OMUDocUF0U53b4gM+S6hgFuZrG0PYlipGAqDnDFQF4eA5yYN/l9K+lsiIVIzzru8W45G5kk13jTos2flp1zl682vgAUrEHu6jCA6KYMpRixPdIAW+WU0LZqJmMgIjbFdv8IEbQPl739KMknH7mJEEKbQ5MQKnwiDkmyr1d6k/FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710918126; c=relaxed/simple;
	bh=OghuAn3dNcfWxkSWO6sYrF+3HIB+uysNPFNcN33ZTYY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PN3u/0XjPz//4Pc9Z3TU59i23AZu2I7PI6iITH3ArvAWQnGCyks9RA2ZrhA3mIOtiV2yfYSjXT899sa/Nc1gBYiwF8DTw6KPDKSRufJpDT/mDE/Z0pjY9G8K0ghSYcu+Z5AhSZDWtMHhJF8Hnqn5eyff5KRwNgmMq8DZLXSVsl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUbLvqrM; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710918124; x=1742454124;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OghuAn3dNcfWxkSWO6sYrF+3HIB+uysNPFNcN33ZTYY=;
  b=KUbLvqrMkVuo6g9yAZgSNP0XaKJ/zFpq09syv9xAW8TE08nmeuuhQpa3
   2jO1GQx/npJAUQwAuHHfVdp+x+Scib4ZQWn8z71PJF3zJZNbSKq9Q2YTK
   W9dKphWUQOSexlGBgKUvDFW1JT4fohjOTA+IrYb6zKKOmFaJpkz5qaSWI
   Fq7WMrn8FmOhNUEjG/nuyV4b3dbCkJzHa76q78TiKMtTsFduMbZ3S2y4P
   MJ5x+awhJnImOijfBuVpiuAcproMxPdKahX1lN9MVlaXxTCddMwBnzSj8
   qQAj4iQ4bVQ7HlVG6tDVKSvGyh5bpX+p/KvYJ+dWYBddSGMG3qR+4hWl0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16563749"
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="16563749"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 00:02:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="18718576"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 00:02:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 00:02:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 00:02:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 00:02:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 00:02:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWJXNDmzHemlN8LF5MjoCtK9k/sw5J2NIFgP74G3RwS1ber2b1nl2cHLhR5MWce3P0VnXpqZCOJDMUbpFBp3ea7WeZjaM9oYwMFjb+rVewv3JXbYfXYr1KvpVSy41AjQCriz550ARnAS/c9/+KHp3I+a2kQZRPCD7N6uKv2qTn72hcc7FhSpWIPANuBbzKQ5zLf44SZwlk1Q0MCUyZkxLh3qCwbn50C4IHK8moUolVsVnL4FuvTSZouns7RRA7spp5b36zhKDJkgLcAffzPl1eFjBtZku222Y/+PR0u4qPZdSu9k3nb3rNmigXytec80sciJblZrDX/gkuZGjDDF9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAbwlxzWwVUdBBmb0xiX+VD1m/cI1iBYKYo5q1oVm7o=;
 b=HdxD6dtpmtQXgG4PRzTwshJhQpKoKVXX39lifoxHd+zdKYc0+H3t2BzN7bvqKSZ086kvuiPAl1T8uvZrH4OWijbQl7axtLetlreTRSFkCcPRqaqKufgMC9BEF6Oh3rnpHJNznFAfhQmRlWnYpPPqKNzyB3qEJ9TZO3LBSI8EW6BIR8AWnlH6on2M38PfNW691PZvTeFPfKe8A1QRL8uvecP/7I4/c7S+YqLzg5tFJr2Sk91hYuBwJjPTtM1dCOOttd4C62bb4t1mP/1VTiJuQtQp+4v2FgqeYq3fMmy6ggZDqmDbYhNu3Jd9qc73c4ed27j0xK5r/smoWMuzKE7zJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB7795.namprd11.prod.outlook.com (2603:10b6:610:120::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 07:01:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 07:01:58 +0000
Date: Wed, 20 Mar 2024 15:01:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 040/130] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Message-ID: <ZfqJ3LkYrwR/qpsX@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2eb2e7205d23ec858e6d800fee7da2306216e8f0.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2eb2e7205d23ec858e6d800fee7da2306216e8f0.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8e89f5-94e7-495e-8c2c-08dc48aba2ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zzp71og6bIyrZONAjWytE0HSOGWkZRPr/BYcl5T5VTpIW9SRGmRurxr/ttTRBxBeKynGrL1Io/a32pTL+HAQjGiaaKu/qVIGbVQdw/j3RJU8f/5hhrAj7F/HpegRa/8S2RQqJ4gKOkyAF3P9rT7L6zAuaf5HEv9L/21dBKhpe2B5N++7AHuzzubsWOsPHV5Y7U3ZL51Wk3n8Wrsz8P1TEyeEoF0HiwsX92wqgD/vfUA7AWQvcARBS0sL8uSH8uPJ+BhvIfDEapa7bLCIQsnximJbHGfxYpQB3w48vVlLyLVVVMhP/HEbZ5T3aF1r0b4Ju/xLHRDorebb1jjhFMZatdWUWs3++CLR+fTFt8gSGGKtQ2HL9XAbisACdBSwDPU2I9V0pX1SDV/OMa03urUr2/O8HSccid8uqOPfOOfYr9CiDTYEkvtoZUh+pJmNhkL7upqLFAnoR9p3GCrJO79xdIq+TkkGyp+og+2+kHgtbwL05d7M0DH0hpONmxnYynoC7f9RBXS0KkLmDLVGuGAubYqEHKhewdC4XMinemgASu5PQUm9CDGPAkZEps3mrMZA+tf/jKJ6TjrX+Vp87Uhy5dAqNVkBtMDIDfDUoY9gcSIZIf8tH8+nIPCiLTuJ3PnjQ/yaXAsQOoSitDvswL7Qt2CFwpCXw0J4jvuqJgqI+aU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FyrfRcrngTd2UaVEbFtJY8DwqtoVNGyhi8QsQ5PR0VIDFuLreu3rVpRglRD3?=
 =?us-ascii?Q?QOItqNnEGgsZTD9GWChus0PBkFhTG9nlZtCPQkUmnA+ryKuXJPnlsBWpAJic?=
 =?us-ascii?Q?2RdPXmOGOm+dO/ELS85PcGUw1uV3/df31BfPKOV1eyKiSWE7bHB2Jr7ARAQf?=
 =?us-ascii?Q?o//rVOKv7wdeYRr76Bs67YBxMbRNxTQArjzu1tpaGDs2u+ujv7hzyylKe39N?=
 =?us-ascii?Q?1NhyJfSVWE6cIL6aFPzUAXyppQLZuug+CxJk12yxG69Fh2dlS/3dxucWorfB?=
 =?us-ascii?Q?ILJ25jkfVstqFc+792a6BT4LAJY/GK1bAgHraRjE5vw/s2aWydIwJsmpWcp2?=
 =?us-ascii?Q?0bzrV/MHV9XyOYgRu1/nr8tvU7WCitFp5838RQ3fBaO+M+ODCrKd08k7jgpg?=
 =?us-ascii?Q?ITrmSsmqVze1/9kaw+LVaJxtxkMZnMZi4ZFCfwknDHDum5jkMcGzqKXzLn7w?=
 =?us-ascii?Q?pZ0Z5ciNe+weujSdJPG7oIm2WAf3gH9GvoTPrL0gQgTJ4o3E8ipVfYgKI8qq?=
 =?us-ascii?Q?tJylBP6G+4jFwoeu8OlfTnLyoT8e75waERgT5XKxhMOHWUgRFsIoc0cJkLhz?=
 =?us-ascii?Q?vyIR59kUwTPJZRieVYrrZFmtjmFf+joUHUdRdln5sTLadeFk2GAb25N1Y316?=
 =?us-ascii?Q?2sK78/u7N3CoZxaYgVrr8Dz6IyNsW92PQqtPb/cC0rzhihD93j+TsmEH8MVN?=
 =?us-ascii?Q?TtQUZIvio3BGhNgZpzcA9TcnUJra9yVYTzGD4rv9qqYH3SZDlKCPoUWYPSm9?=
 =?us-ascii?Q?2qmPmv/2pnjg/d4oz+1DPGCK24JVT9m+7/woTMi4rHcP1v3cFlT6tajZOgeD?=
 =?us-ascii?Q?ZtuI4KC92bT/qU/n6JzkRrTt51K7jUvrkInrsbon80l0lxvjMqg0DB5AiDHT?=
 =?us-ascii?Q?cbteBREdARG47Spi3PdDzVWW9qpip/RDMnn8fbOWNu4s+vxcWmrfnKobb3tq?=
 =?us-ascii?Q?qSQZ3Jr7glt8BtGZBtSHK3LPDHxO9x6C2O5V4+wGNlvyYtYVst4rmp1jfSiZ?=
 =?us-ascii?Q?7X1ICLSHZW0mUHtmwMl426Nawno36Cf2SJg14GgHa9rj930RSwq0810ejZny?=
 =?us-ascii?Q?djjcoIxRcOOg5ZgZocgnwrTJVJizL3xdfHIbVhYlFaeg+uBkahUzdIIG7ZMe?=
 =?us-ascii?Q?cxwcHoLOhIYJ9LnOA3r8qMRfc5LEVDjRoS1MCtxK1h/sN6ge59ndd2GY5XK9?=
 =?us-ascii?Q?NSgFyL/EWqMdZObperDlDbL3LYtNZJX6HY3+skNHuIdTuBRWJqcyn3RbffCf?=
 =?us-ascii?Q?jSqvAgWjIX/wF+3ikz3ODTrqbGAHq0d752y3MoKlWgbXk1dpeCcANvry94D5?=
 =?us-ascii?Q?0AP5JZaRJ+VYAV8j3DGwIEaCnoOwvcKsZsq7ACILj/qHkzTEz96b77+yaq/K?=
 =?us-ascii?Q?+MIzmQ3KLmVUMKvimZ9+/kgNxP/b7QDZqR9Tm37KHZNiFCh7qbi8GUrEIGIE?=
 =?us-ascii?Q?tub6dU7Z07j+kKwdA6ox8ZtKW90GBHkIYxyHmMrdj59QxWXM8t1mXt0VTjEX?=
 =?us-ascii?Q?uf5wGtr7ARFISEMD6UusJLq51ncvnVBr0tfAK+2+BDOB+7uCYCiAR2FgUVcq?=
 =?us-ascii?Q?iQ5KvH+C20xMbIsY+hoh8t4mQWlTbiwRRRArIMAV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8e89f5-94e7-495e-8c2c-08dc48aba2ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 07:01:58.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6vQgUZ+pYy1cKmCrEmfnIC21RocAXR41si1uCc4Iw3lGq8uVkXN9QLCouaWqqmjOvSrzh/Dc7HxTt+YBGI/zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7795
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:25:42AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
>support as another patch series) and pmu_intel.c touches vmx specific
>structure in vcpu initialization, as workaround add dummy structure to
>struct vcpu_tdx and pmu_intel.c can ignore TDX case.

Can we instead factor pmu_intel.c to avoid corrupting memory? how hard would it
be?

>+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>+{
>+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
>+
>+	if (is_td_vcpu(vcpu))
>+		return false;
>+
>+	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);

The check about vcpu's perf capabilities is new. is it necessary?

>-static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>-{
>-	return !!vcpu_to_lbr_records(vcpu)->nr;
>-}
>-

