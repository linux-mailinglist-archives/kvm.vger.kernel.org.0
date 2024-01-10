Return-Path: <kvm+bounces-5978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529E38293A2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 07:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9628A289B20
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 06:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312B232C80;
	Wed, 10 Jan 2024 06:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmQII1ls"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31DADDD9;
	Wed, 10 Jan 2024 06:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704867431; x=1736403431;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yH8u5PrVrCMR+GIW/Ld8HeiWKpChCEBE9eleT4pi9MY=;
  b=GmQII1lsHckj52il6+6X1xM7+34syiqimsimIBThyHY0kGtyh3dFgsmP
   MFpdYd6j2uhJ6i61m3YYt65ysl6+2heHDkZbuRepioxlGkU41pgkFdm25
   OHmDHuAUEccagmxi564Wh5tSCswpoVO/ChlyABqxp0irub/drKQlD+fDm
   9PL/LMS4c00htQ/WXjCE28AXgTPEDzJwXHROSzRPiuqZH70FhfoPNAFFL
   CH0b9C/keyx24yoKOyCd4pDCsIO0VRjwxFYeQ+Ju7u1IuZU28MoAFNrz2
   GQ9Ksx0Nhc8OjkhX0F1Kq/ydlQ1SM2QmNy0yo4jhk32Ojh2cXIwnBtj4T
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="5169915"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="5169915"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 22:17:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="731750936"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="731750936"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2024 22:17:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 22:17:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 22:17:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Jan 2024 22:17:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Jan 2024 22:17:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaSdgLIV1F2hQ8TYC2lYEhiPp4KtZrWb/0YBI1QP/r5TWaXD4xLNfLptwg3jsRejgA2e8ejd280s34vviFT6M1CKNZUPcQH3Vdjd2C8B3r1gbmBiEFqxMV/CQ1aT5JUIwERK7YCCyEZTVaYMUtK6mf462OBMNQW+gDOt8FpIKaaCiETiC83HXQTZsm3rRQ7sfU1lwqxHhDFdsjpVg0hpBHtS6b1/yfu3j+W0uwJdylf/7VanmYtdCgrBJZtJanbRu/4poX5FYefHEw/a/qUnv9+0+qINYtLuwPFF7hh3/xZjiDXbaZw0gSVyGEhdg3z7nk7Oqts8Oc8H1N8DUUhg/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjTUr62DGH4STjsvxQ5m14UydATfyL+rofbwnOA0A0Y=;
 b=Ua4RxNV6glle5juJwHrt+PO8shtGgLvQqEv5UJlwH9GtjPo7Wv+OO7bmVHKU6mpLNfXEFbtO0YKfPvibNG/ACs1Cr9JtiLxU+7vQH+ctR6pr3An0eE6aRnuy/0k26FXCtweI90SSSlIIpmvFYrREv+svA4te+Y9VApgbzDJ/oGhv58BlCjY1/HeBCpcNmkLnbJ8xmEuUUWJNiQOBm2Kz/elRHjf0Ix8YC9K79bqJNk0h7nbOvU+Vm8RFP/tXU6CM4BQzCo/VUEkj3f6XgxUA3S2jEVmF8P6g8l7nWtTID2ryz3OtjuNpeRRQa2b2tGm1IZW0zjzU3uCFUfYZamgqNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB5681.namprd11.prod.outlook.com (2603:10b6:208:33c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Wed, 10 Jan
 2024 06:17:04 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7159.020; Wed, 10 Jan 2024
 06:17:04 +0000
Date: Wed, 10 Jan 2024 14:16:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yi Lai <yi1.lai@intel.com>, Tao Su
	<tao1.su@linux.intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
Message-ID: <ZZ42Vs3uAPwBmezn@chao-email>
References: <20240110002340.485595-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240110002340.485595-1-seanjc@google.com>
X-ClientProxiedBy: SG3P274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::13)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: bafe24ef-0c5f-4227-34ec-08dc11a3c3df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKAAE/+Fp5E0WdET/vO/o30qSUvrrt3H9Yqm47xVHI+kZH4g8+QWXxoZANVh/h87Qd3Rn5gO+4R86jwzZ2NWwwxt0jj467kh6kDfJFzSl/DVKJJAtgCfaaqXim1Rbn4lzWhZbtBBEnnj9bRBIIxtrIu5AB6gGVDedeqqEo6g+pa8ElTGBHbMpBj6uX2CHkvwKvbz3e0i1eei3GJtFmRLsBCAisKHJGvNthedJnqxuitSPZGX0nEBt+UqXGUIyECibq5iyeYRZ1qt9Xh/SQNHuDrXwGZJHrYMTEdCMELAmcCBweSACDrydSyJ06MoRhfaoNP0oHhZ14IorcSq9cnfyZ26Q92GN4cOgXsTt3humYsan7Rd8/4NP8u7c/8wCm+/ylLIDnNZL10Q81of2041jCWSRRx7YfxsAtosIC+Fbvo+wH3dFL7Lvwr9Bmg8/1YaWNWeTqmdVclVC8oW+PvEPjFfsl9ZTlgXdx3qMVJPUSQ+crOSLQtlRXf4aPpmMT+4Wf8soJHC+tu+kvU+MKtaNhVpp504nAVWYkZGGUIZXbn+MGBbij8RskwjIktb0/Jd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(136003)(366004)(376002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(83380400001)(66946007)(41300700001)(86362001)(82960400001)(38100700002)(9686003)(26005)(6506007)(6512007)(66476007)(6486002)(6666004)(2906002)(66556008)(54906003)(6916009)(316002)(478600001)(8676002)(8936002)(44832011)(33716001)(4326008)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HYkofkDEdOhbx03Crcc62xW3DFiC9tyhIm5HFqPNwRSu7VQ8VDhSBsUTaH3F?=
 =?us-ascii?Q?m7NEQq6rkViDsDsnK9NqKeocWMdW0QhRAULUK/r33sjlNNVuq3b0QbP62g0t?=
 =?us-ascii?Q?ZVIRxjqafzTuYKU7UnSIhZOuzxnKqdPtG122jvkTct51920InE+Vq6pHEewv?=
 =?us-ascii?Q?oGxh3G2DsCMCKBPnPyBdbYKmMlV/pictV5Rr083xcSwRYwDGme4vu2Gi3zkQ?=
 =?us-ascii?Q?q4/MOG7nEeZkgrK2Rf5g7AGSdyhp+3ihDXrycWV/x2EsTc1CFz+CFG2qWFX/?=
 =?us-ascii?Q?i2xbSeiPoG6poCKo4PsCJ8XxKl7ufnZs68TWR4mY9N3rfu1QbvhlTrwjNwOx?=
 =?us-ascii?Q?bzPYX+NsozcgeqLcEb75YKJurCt3iKZ8kS+moVUdS1oFz1F/qEIljxV2iVdo?=
 =?us-ascii?Q?nBNAoPnEMA/cNWSmr8BzuobcUGGERY8HIRtgvR1coNlN3EFcDeBGHLVNyfob?=
 =?us-ascii?Q?YwbR1E7+JRH1Ek812qSK4YCWlkK3u3lhj9MhyE9QAc0bLlPSrQZzPjQqMVwi?=
 =?us-ascii?Q?Vyq41Um08Df1M9kZFiRmmn87sn75xkrD2jbif4bqafdNX608Iu1bQVySxTyM?=
 =?us-ascii?Q?6k/PGjildBAW+5UM7w+NvaFRVV6FDXU1tsrzYV4QUx5iAEsIqqrOIqvFKSg5?=
 =?us-ascii?Q?fc4EaJtt0+TDaFwJoyzH1mjIR0FOrbRzOKTl9uuz9uds3sA3UCx3PyZWL0m1?=
 =?us-ascii?Q?8Jpcjs4+d4pivr6z2vPO3q89Jgy9i855K9DVVE9qLj728c2CrIQWBxvs4ar7?=
 =?us-ascii?Q?MQIdpYzOZ1CphyNQ2GWgsnhnWDCKsE0q+94WX+4fMNadkFdI/8+cDry98f1T?=
 =?us-ascii?Q?mH+5FU6PdTSJbC8PV3Ip/UJvH/hT2Ll5hYQQ3viof+wEmosKqsIGmy5wP4gf?=
 =?us-ascii?Q?Q97F7HtZnNYiqKO954sCchcjsEPFsrB7sSgkQ9hWd3qiS31PpiwJpp3FcOU6?=
 =?us-ascii?Q?yjgnoBsvXjQieghIhq/3FznwXSZs+RVKWlLXIQcdtao8nz/6NZCGmQ+T2kb6?=
 =?us-ascii?Q?rpbO2oGp6NXF5NCPljdc7bMQy1C9flag95lH52BSe+mA2sWg0zBmQ43VdW1t?=
 =?us-ascii?Q?pFosz7sr7F2YHk2eXJytAdFy2stkGAr6CPVAxENsq+58XRNexSvkE/BNBGeb?=
 =?us-ascii?Q?3/DNqNh8JMTLgOvSnVON2rufYmaZuEj0tP8SRKRS+OZkT4NZ6vr31iUHdya3?=
 =?us-ascii?Q?ViSOsknu0aZQfHz/jmov4mO55EZv3uor7Uk6/gZSADLxj0fWkfE5aHRz/bno?=
 =?us-ascii?Q?/G/b6W3LPsGc+CAKL06F5PH9d+jS8mcJME8l94Hb3ZOVo4/kgZGe32K0manH?=
 =?us-ascii?Q?xgC/imJeapgIsBWkPOS6wlYTIu1zGz+y49ptCflBbolgps0Po8fpgRHrzmBw?=
 =?us-ascii?Q?F3eyt/aLcv9WglRmslxocCIF/Z+STn7GE3UsEsh7fMf1g4KZF+iX/V1XYTft?=
 =?us-ascii?Q?IwpvAGjEmHBw865AMdO9AOEey34/bveOn67jrpz7kMp7VX+mcToyq33lUa/B?=
 =?us-ascii?Q?dIFBPmwPjMWx6zB9hVcOF54vtfAqQtth9r5cm8YCDMtCeehOQCfaYL9ckpLe?=
 =?us-ascii?Q?L6b1AbpsG6xKkd5HchiaZqu/tSmBUWwzeQ0pPx4+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bafe24ef-0c5f-4227-34ec-08dc11a3c3df
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 06:17:04.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJA+KivsgImu2bESTlsRENXLhCHhv45R+q3kX+zX/nkBPWplcB1N4bhFS+9J/VMJWfbLqeE3r18lhaATTk4WAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5681
X-OriginatorOrg: intel.com

On Tue, Jan 09, 2024 at 04:23:40PM -0800, Sean Christopherson wrote:
>Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
>whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
>enumerated via MSR, i.e. aren't accessible to userspace without help from
>the kernel, and knowing whether or not 5-level EPT is supported is sadly
>necessary for userspace to correctly configure KVM VMs.

This assumes procfs is enabled in Kconfig and userspace has permission to
access /proc/cpuinfo. But it isn't always true. So, I think it is better to
advertise max addressable GPA via KVM ioctls.

>
>When EPT is enabled, bits 51:49 of guest physical addresses are consumed
>if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
>*can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
>creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
>above bit 48 will be completely broken.
>
>Having KVM enumerate guest.MAXPHYADDR=48 in this scenario doesn't work
>either, as architecturally guest accesses to illegal addresses generate
>RSVD #PF, i.e. advertising guest.MAXPHYADDR < host.MAXPHYADDR when EPT is
>enabled would also result in broken guests.  KVM does provide a knob,
>allow_smaller_maxphyaddr, to let userspace opt-in to such setups, but
>that support is firmly best-effort, i.e. not something KVM wants to force
>upon userspace.
>
>While it's decidedly odd for a CPU to support a 52-bit MAXPHYADDR but not
>5-level EPT, the combination is architecturally legal and such CPUs do
>exist (and can easily be "created" with nested virtualization).
>
>Reported-by: Yi Lai <yi1.lai@intel.com>
>Cc: Tao Su <tao1.su@linux.intel.com>
>Cc: Xudong Hao <xudong.hao@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
>
>tip-tree folks, this is obviously not technically KVM code, but I'd like to
>take this through the KVM tree so that we can use the information to fix
>KVM selftests (hopefully this cycle).
>
> arch/x86/include/asm/vmxfeatures.h | 1 +
> arch/x86/kernel/cpu/feat_ctl.c     | 2 ++
> 2 files changed, 3 insertions(+)
>
>diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
>index c6a7eed03914..266daf5b5b84 100644
>--- a/arch/x86/include/asm/vmxfeatures.h
>+++ b/arch/x86/include/asm/vmxfeatures.h
>@@ -25,6 +25,7 @@
> #define VMX_FEATURE_EPT_EXECUTE_ONLY	( 0*32+ 17) /* "ept_x_only" EPT entries can be execute only */
> #define VMX_FEATURE_EPT_AD		( 0*32+ 18) /* EPT Accessed/Dirty bits */
> #define VMX_FEATURE_EPT_1GB		( 0*32+ 19) /* 1GB EPT pages */
>+#define VMX_FEATURE_EPT_5LEVEL		( 0*32+ 20) /* 5-level EPT paging */
> 
> /* Aggregated APIC features 24-27 */
> #define VMX_FEATURE_FLEXPRIORITY	( 0*32+ 24) /* TPR shadow + virt APIC */
>diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
>index 03851240c3e3..1640ae76548f 100644
>--- a/arch/x86/kernel/cpu/feat_ctl.c
>+++ b/arch/x86/kernel/cpu/feat_ctl.c
>@@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
> 		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_AD);
> 	if (ept & VMX_EPT_1GB_PAGE_BIT)
> 		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_1GB);
>+	if (ept & VMX_EPT_PAGE_WALK_5_BIT)
>+		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_5LEVEL);
> 
> 	/* Synthetic APIC features that are aggregates of multiple features. */
> 	if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&
>
>base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
>-- 
>2.43.0.472.g3155946c3a-goog
>
>

