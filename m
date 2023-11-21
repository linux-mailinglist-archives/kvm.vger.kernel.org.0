Return-Path: <kvm+bounces-2156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F30757F2491
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 04:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D167B218FE
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5DA156E7;
	Tue, 21 Nov 2023 03:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RwKyzoLa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A9CBC;
	Mon, 20 Nov 2023 19:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700536819; x=1732072819;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gfZyOCz6kl7+rIBv5aheyXaZ1q0HP4+S6QpBYA4AkSw=;
  b=RwKyzoLaEFPqqW5iVYADsFLgTfGCyvUzf/87c4jslOT56ZY+xkl00wgK
   ufc/pAue0RRnhwhdZ7CMcOhoG6cxA0lmHCo3q1jc74gu/IKALQZAAbWjQ
   mzjtmpvHxlxkslHCkHHug+gx0FROWQMdRnR3+gtuk/aAFD7g8HePumqdl
   qv7V6cLcpR7fiy1cuZ9KOY48sxuTQ/B7RqYcGvha8NrAmkUZxWL5yWClb
   aNZ/6YsWKSsstwuesR8tPVzPPfpUAZATs+uYf7hxrImB1jadTADabBPbO
   rUbgoty4aoPVQJhWcqJufwmOiECbenH4uIZmtcC7Q7RrKEpdEvzwBFvky
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="10421931"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="10421931"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 19:20:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="1097926482"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="1097926482"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2023 19:20:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 19:20:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 20 Nov 2023 19:20:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 20 Nov 2023 19:20:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEw9dDHclszx/kgJ3xMrDudzn1QqbALDEal6viuQn/xfvXFaar8qANIwhOr82tauUcoRovh80uB7ei8pqqRjmCnLqCUhsOXHHBaH7yaLKevXbXeWWylo2kHekKq1I5QaeNRgz+/rhJ3ZMlMWbIHBnjfn/KQpvdX0bHG7in25etpC9jPA1GOtdKU8N6YjoMSl0Jf6noRPArYnWAns8zMMtgUKgECLL6WRmEbRdxJrtBKXzFe6BW0iCaQee29Gwij35Sb9Rusxmne8Mb2sdmDEDdgX+fVlhYWxBsvVJg+xZK42X8cIR2GmjJN8L8DqWjMN4GRn64BBbjvTditud1EstA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/1mctF6pT00KrtGxFlBefdlCLA/bTr7z8NYX7K0U9g=;
 b=oY68m2ip+etyqG1XZTPSTv2hYclr7Gt1SB7KSSFg/IMTICFfdq1Y9rAs6qx11iDn6r2e0VmuneLqZqxuifnUXgL5jfckawShhBXzyPsKN9DrFPPnQP1B0lkxTamrgx99sQpvnKAe6L+aJulhcmdVtluE8wkPCfbNTTZttGgx/S9REXQQ3FgLnwrn311YsJpC75rkqGjLpzD+DYHuJzFENPCKa8TtV9TUQNoamcPePWlFp3W79ZzDnJsurkg848gqe3cSgteGdQmpgjXWANVg62+/yUylll4T9NpcviJWXwjVtWguNUnY8/0TVqBkgRv1rWxn2P0FoZhkmGEzPcrMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB6740.namprd11.prod.outlook.com (2603:10b6:303:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Tue, 21 Nov
 2023 03:20:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 03:20:15 +0000
Date: Tue, 21 Nov 2023 11:20:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/9] KVM: x86: Rename "governed features" helpers to use
 "guest_cpu_cap"
Message-ID: <ZVwh5TO7ANpfjpzV@chao-email>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231110235528.1561679-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: 3647789b-1056-4cbc-de51-08dbea40c6b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8lfu6CU1pQ6y/fENkg3RpUuWmMZEMkRIO2zIlfwk9pSl9EDyYlDSDH7dkenuS8A7QRwCxgw4CTJhjFDg0eanLhV0r+4qQSwb8wNAb5FTevfczuJltG8/WE2c1D3MEkkx6hMszieH2E1diddRnTLkYQGsLNgDyTm3S9Qlv/ffgwh/XFKZfa+Th8nhpMCF811yZcOJAL3DEBzntcljxyVp0jsusvGeH6HXKJjFSC3GPfdc+1MI+eIOhOd2PxCb7qwAUp04muHxh5KWhgXHqmZATLDqXe4V0TSkGCeLVLfUkxV9mkw5BQpXdk7k6rzCpNcG/5VX76NLmCZPYvJ8Wfu3gwKfRpLfe5ct+7rhF3nTknRsHETYblnNzoZdCELpBQ6alC8q5Xv/Zn8o0OHCzfRQtam9zm+nS29iSHf6rnnK8VWFtBqnGg6C1b19RSRS7Fkz/AVH1JNsycBsZ+ixbHekhoeXpB6YKPpsP4htH3zscCkKQKX2FYe+KbgUnU4KSNCXyiC5PIjR8G6wDj9k8wwo2Hhk94gdY2eMfvorx0MeaTCpv9uGRpm0mNBOUji3By+M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(83380400001)(6666004)(478600001)(6506007)(6486002)(33716001)(82960400001)(26005)(6916009)(316002)(66946007)(66556008)(66476007)(54906003)(9686003)(6512007)(38100700002)(8936002)(4326008)(8676002)(44832011)(5660300002)(2906002)(41300700001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vetYOmj2NzKPKRPvSxhsPHPQsOmauYV9qXHg37HHZ+1KcUNRLIEiX+B78IEO?=
 =?us-ascii?Q?QS5SSW0ySyBs86w5pmb8ku+w3hlG4udNNkQMDFGxd2axaZN6vL/qJvP9zvBW?=
 =?us-ascii?Q?+N1qK9i7mxk7cXE4AM9pwhlWBUW5WxreLgTZHvLSrukDuF8nCG1fFmeA6/mJ?=
 =?us-ascii?Q?SQS+5MuLpbRrdNWL6EZXxWvmRk/ERhqAIzz4dHK0Fmyg4Oeps6mWJpvKwmuL?=
 =?us-ascii?Q?YMPyqnhW3caNOc9XoM/hmY7KILTM1/v0WFPxwJQ2/Fa+FTSMmPDm+vXXekRv?=
 =?us-ascii?Q?PgePKX1h7EqRE8do6dN878txxs+WkAV9J9p+pCdKvSG27ayeszG8Qj0TWJoJ?=
 =?us-ascii?Q?KrKPXQLIXZp+QWrHLS3RSkq7/Q3u5S3WTNaaUvcKcme2v8BZiNEsM/3Xbnkr?=
 =?us-ascii?Q?T7attbfxWUrkgF1TkY33hfJ+OcvUoN+lcN34dCeaSwrikEFyr/ltZfLpV/MO?=
 =?us-ascii?Q?D11ERpasw4IMZ0VxHghrhAFRmKlwHN0k4RbMNZwElKXdIJR0b3yTIKxUrnVC?=
 =?us-ascii?Q?PBHZzqBvtQPm8oOQnj6aObbWJLaztv9CMd2p+lwEV0Fq/NX9Efj6+bHBk6rp?=
 =?us-ascii?Q?jmHShycpUCbPgH4prRNpUJJQFKnpACHzqZSt9OemuzWn+t6fSGCRLqrN1x1+?=
 =?us-ascii?Q?fmhUA1dEO3v46lraxXTeX3IRgLNTo5qK3DH+fMf9UBKoUmZlGTFzeUJg+aah?=
 =?us-ascii?Q?NsAfExg8Sb9Kv//d4aY/Cv/BvmHlOz5MxCCz8sPSeFdpjsO3XdAJde7juvzz?=
 =?us-ascii?Q?BMUNpod0yz78ppp38pJQ5ubAwwT1znVUjZaTDE7jQ0ep3B9iY6W5ujBeU2cy?=
 =?us-ascii?Q?VX5b44vv3PoPPdy9THfcZz0iR4grz0OfAx1X285LT9++0ga6PutK8nnHPTDg?=
 =?us-ascii?Q?n+fYwHt2ZayeZ9cWc8F8RaNWEOGs3ptep7nSphHHxNTklEq2SSG+PwyxegCt?=
 =?us-ascii?Q?Mps8EG12DqChXz4e9z3ONuhtsk8R+aWqQk5uqoftlcsQOhgs3MpwjS0dB/XA?=
 =?us-ascii?Q?wE1qvfA5XajrUYpU74ZZ6C2CqXG2M2BnQL5douEdndPFrSOGzGv9Kl/Nk+Kz?=
 =?us-ascii?Q?DS8hkBeUEtmbyvdqyJSsYmzrcZu3YAZyQx0+gV0Geiik30c8nnb1NsunNo2V?=
 =?us-ascii?Q?D6koTq7b0cudJ8TcnkvybNQ1LkydTTK2Ff+tOvoGeDFcQR3kikDIT/iXEsS7?=
 =?us-ascii?Q?yJdjH2Ejiqz4H0AOtgThhiZO+Bi+ALkAjY+4nbDy6VM7PvLBgiX9pM4IV35r?=
 =?us-ascii?Q?tBeG0itBJq4Lwbl6N0RXHtTP1GZ8dilyIFbWOAQRSV/bcb/107GYg3tBDZua?=
 =?us-ascii?Q?hqnFJjsMdM2yaSoWX+6ulGOSJwWfm/R+WdaZX/qtTwGwXlnXrGDal10i4wbM?=
 =?us-ascii?Q?kcqELSSJjXulEXWdKp7fNbxtAHXpLPKwlstC0l3tRolOvsWEFq06Ky4EBKyY?=
 =?us-ascii?Q?ExivlWEL8VmTlAwlcikOHAVIrF0rljqQLP2Bdjf05fQMpC7f996+RCAiJdsv?=
 =?us-ascii?Q?FetX5JJU50y9ESkswDz4/30OIj7OVcMc2NyGXdo5ddj56r0hZH5DZ7IIBuli?=
 =?us-ascii?Q?Sx4xzHlgnfyGLy+RNDtS72BPtnf8P5dXljED1hZu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3647789b-1056-4cbc-de51-08dbea40c6b5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 03:20:14.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sGSjpO6ocd5Yd7qfYsyrZ0ZZlkaQa8AtN/bq+oGXqo7CBLhV1Ixf32ROfMHrD9+CHkjlntivV9XFU321z0FgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6740
X-OriginatorOrg: intel.com

On Fri, Nov 10, 2023 at 03:55:20PM -0800, Sean Christopherson wrote:
>As the first step toward replacing KVM's so-called "governed features"
>framework with a more comprehensive, less poorly named implementation,
>replace the "kvm_governed_feature" function prefix with "guest_cpu_cap"
>and rename guest_can_use() to guest_cpu_cap_has().
>
>The "guest_cpu_cap" naming scheme mirrors that of "kvm_cpu_cap", and
>provides a more clear distinction between guest capabilities, which are
>KVM controlled (heh, or one might say "governed"), and guest CPUID, which
>with few exceptions is fully userspace controlled.
>
>No functional change intended.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/cpuid.c      |  2 +-
> arch/x86/kvm/cpuid.h      | 12 ++++++------
> arch/x86/kvm/mmu/mmu.c    |  4 ++--
> arch/x86/kvm/svm/nested.c | 22 +++++++++++-----------
> arch/x86/kvm/svm/svm.c    | 26 +++++++++++++-------------
> arch/x86/kvm/svm/svm.h    |  4 ++--
> arch/x86/kvm/vmx/nested.c |  6 +++---
> arch/x86/kvm/vmx/vmx.c    | 14 +++++++-------
> arch/x86/kvm/x86.c        |  4 ++--
> 9 files changed, 47 insertions(+), 47 deletions(-)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index dda6fc4cfae8..4f464187b063 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -345,7 +345,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
> 				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
> 	if (allow_gbpages)
>-		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
>+		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
> 
> 	best = kvm_find_cpuid_entry(vcpu, 1);
> 	if (best && apic) {
>diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>index 0b90532b6e26..245416ffa34c 100644
>--- a/arch/x86/kvm/cpuid.h
>+++ b/arch/x86/kvm/cpuid.h
>@@ -254,7 +254,7 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
> 	return kvm_governed_feature_index(x86_feature) >= 0;
> }
> 
>-static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
>+static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
> 						     unsigned int x86_feature)

nit: wrong indentation.

