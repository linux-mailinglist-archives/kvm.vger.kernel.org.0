Return-Path: <kvm+bounces-267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8020F7DDAD7
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1D32818DD
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1A6111B;
	Wed,  1 Nov 2023 02:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PTp7PjPt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33927EA6
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:10:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704F6ED;
	Tue, 31 Oct 2023 19:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698804603; x=1730340603;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pIuFvIHi/dKLo6u870f2qjdpQ3SBK8Td0vtGoqED91U=;
  b=PTp7PjPtZZidcL2UViCV512DNA106GoIObCaPq/cBU6ElHcNIn5hlBn7
   WAjdfqkYDXocKLDoxieK3b44mvQW58TUDAffLRXyizHeu7Wy1eT5NBxbv
   T6XyfnhWNw+sVKSH3MWpOnJw1D/9VwUEpdWxp5tjmRU7wgtd4t2L2tQ7b
   g5ZQrjlWE5U6L/I2SSfiWx61LvTsHWLU0VihKFvbAxIMnjJ6RfKVBsxzM
   WlKvJyuj64VomooVt1u9dxP5QrKJ83wBhvDmo594SeRAGF5AfOMcTJPVw
   U3Wctudox9iKp3gyq65ZgIaUoECO8lPbQBnrtfjlojGJlPPkqdL9cWX/8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="391286047"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="391286047"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 19:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="904518901"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="904518901"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 19:10:02 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 19:10:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 19:10:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 19:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWEY7EleoLajcDsQb0H8mg1KGw0eANJMNddIw18sDdNiQNNbDtA/Ls7cyrllbvYaFWbnnXT0GpakwE5LmR/z74j109FapSgqxKfktIcPFO+YEceYkEru3CFWisbgQPLBm0CpbSEw9OjvEWpThyFdAHRvga5as2XgBI9quQFbBP1JqImMM5v5eeqMPRlw5l+dRRzlzov6MlkWUUYHyTH1Xn8W7PtHpxneMcMo72wWX2BR1mKGr+P0HZGBEJ3QHKbAGwGujjWI0FgkczV8a0XHu0Tjsj6cbJfLxxPbjRfER1UTWJ+C3irLeLz5rwo5eF/ARvej900gX/Djwez5pCDXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcA28RhVd3GHfBDw2Y0Es/NoqltNzGAHyuG2KfvArgw=;
 b=It/Fw8c8QDOYdhghY0IbWa/PJFdGZmXlG8KwPujveI8eQUBIrzGPF05CSVJSprMv5pxLvJNCoXBQuL5Ds3SUNfFHdT9wobnSIav4WGIUtj9HRg51C62Dr5/dFoelO9iECmPBSuS6csgpddDZIT8jIk4YHRddSWJdqRA1alLYf2/K4sKZYtZ3bCfurEnoxc9jQYJXCvv6YiOMVDfXS8QbzabDy5GlWndiTPgS3HCronJEGhJOZkJIc/x/dMxYiPnWmvvUN6eFYuD0iMWm12PlW9WrJ7PfXtPrupOkJ91ayy86MNapklD2YJGypbn4tH7YppCXMqmpAA5Z3GgbPmViIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Wed, 1 Nov
 2023 02:09:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::6227:c967:5d1d:2b72]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::6227:c967:5d1d:2b72%5]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 02:09:51 +0000
Date: Wed, 1 Nov 2023 10:09:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v6 25/25] KVM: nVMX: Enable CET support for nested guest
Message-ID: <ZUGzZiF0Jn8GVcr+@chao-email>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-26-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230914063325.85503-26-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a0b968-9fc7-4c41-0868-08dbda7fa1a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tvk/BBa89BpTVcmrYUPRxhFzEj6bogBQR1lic3KF51v+jJK34yAmMzT1R5fj7uyrBeMMXAT8IjMvoUKpOUYnJoxYTWqaKSIievy5pCsBzQJ0BTiSEq+ZercqP4RKdbwDCY5LXthm98rOTYZ9lLQMXem5GXItASELBbJ/hJ7eNfmTifTWgx0CAchI3M5OBVubDY3qxgyqn4ZHcB4nqvZjiP3KSB/gbvStHXGIfcsfYnDYJrFpQyyuR2n3P5Wm5VamnGJoPzmPmuiUHcCfEkTzqPjex89H0Abou3cioSIH6a7sMwOL8PBi+3xLFN39OwuXKoORjOm1nlHcvIJZsJt1VoOmzRoVTNZ1oXXJMbRFxzNIiNq4UkSJEP9X7z5PmpOuPbtxY2BCBKZYuTMAi1+RTXa3EI7RfVvNX1r253hU6xvvkBc8ele+NywsVC3nhH2rnz9jOkWgf8VinqhyUZQhovFiWA6PKywuOpjvepsMVtlYcoTZNkzf9xmbwzumehIapzr44gX5X/FP0u1b47abxQSEQAGuqJbwDLewhSgnE6/cE7bUir4Zqhu6/Th1ZeCQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(366004)(346002)(136003)(376002)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(6506007)(83380400001)(26005)(2906002)(38100700002)(66946007)(5660300002)(66476007)(6636002)(66556008)(316002)(8936002)(4326008)(44832011)(6862004)(8676002)(6666004)(6486002)(6512007)(9686003)(478600001)(41300700001)(33716001)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zpRERBeftl/UsWUOviUy4Xuxi7HJSVF7wfOJAqnjvVLI9H2jZbdkdf/1telQ?=
 =?us-ascii?Q?AMI0ujmtI8dSndX7GP06qsNbjhtSGBNDZAlSQAAGVxlXRFFQEfesLMVgpHZR?=
 =?us-ascii?Q?tC9osjnWbBH9/tlPA1D8XrY76QeSc8/LzezMn61HB87h6wn13UUy6NsZUkHn?=
 =?us-ascii?Q?vUOoCjqRsGtIdmIa/1uCD2bjU3saAGd1JadimnFawZdEr8dlC+r3lib0MONa?=
 =?us-ascii?Q?tVztsk8L90RGaroZiwZC5cr8fRtrCgw1lMh8gHrmptO0M7d3tqGWhgYjnLe9?=
 =?us-ascii?Q?Q+IfVRiN/bHqL8G+JMy34OPqyBEiLy5K6JhmUQ0sse0EgKtfeXQQQBTsvp+q?=
 =?us-ascii?Q?nf+tnsz1gg64t5CAP+wFm6L1oRVv1eI7xZE27tf4VauZfexPelcplW8pEypO?=
 =?us-ascii?Q?3oiJ7mWXZJn2rV7GAYvdtGj7+7Nn787T64DRGPCxVo4e3KDCcfr7xJ8sBjsi?=
 =?us-ascii?Q?NzTqsd3I75aYRHKIttP7pZ/hz72I46UsCUcTIjIVZJ9KC6mTpKgyU+FKzqMI?=
 =?us-ascii?Q?ajuv/ICYVyvWUf+UQ5k7GXVzLY0qz1G++VjGBRLz8XIGDS9y0PIJ6NgIHkYZ?=
 =?us-ascii?Q?8K0637ZCfy7MzzPkyC26KShVnl0RrJ/FozY2cRAI+7OM/jr0yTxB9bHx7dcE?=
 =?us-ascii?Q?i8zqSlADkrr0e+Mn5lQmFbPS863BFQugsorYMLD/FFR9dL6lWE2BAJVGyjNV?=
 =?us-ascii?Q?KuyplcGLqHcXJSUxsOKr+6omFtp7q0dxFOHuyEaQLyX5vgimJ57It61oVAzj?=
 =?us-ascii?Q?V8kKsDt92HsNvH+vJ9xOFzBi+ByLKHAbBMKYnBtigX6w/E0L87ICaDoFy5Ca?=
 =?us-ascii?Q?Y5x0uNBYkcvXoEOQ95mdWcylWKMg7+iQpr6pIlIKzxaJt137rOP1uh0ZEI8W?=
 =?us-ascii?Q?+0KnoUa+ziUI6tF9yaEvr77UGEvwFti0lL8qbRcN/TPhEQq56UI3ZhPxrZ2B?=
 =?us-ascii?Q?C7wHsIcGPmjcXB9pXuXYv0jUuQLOZlNwFiG2XB6TyJ8fgcLtinpnBMsmbaIA?=
 =?us-ascii?Q?wZpxIWzo/w9zl7rAvlwN/4xikNlogBYFX+pNcGenayP8dQwl/z9xWd422btF?=
 =?us-ascii?Q?F4F+0yAIWLb9KYiRfEDsjJ10P7M5IarM29LQt9UOeD1lVpA7tCBXmnVu4YHE?=
 =?us-ascii?Q?igEKyjSLrUSNRSWpOS1ooum3neSd8tRDNBV1O1bwuYwDp8AmWoJgxUVRgiRj?=
 =?us-ascii?Q?3rsITYEOfiTxdlLwVkfGMqv+mzjslO+s0JxbEEoVjuurJGK2f2ZOR3k4QOM0?=
 =?us-ascii?Q?ePKZy05Li0BrpJ0gHsa8BzqZ7052OLe/W8KTT1XC3NlxrwMu6ztzkvn9WVUl?=
 =?us-ascii?Q?/vH34sL7nivF3C6SFPRAvjrvpXa62DDtbfHt9yqaRUFWvuJdbky+uxkmsSTR?=
 =?us-ascii?Q?AfYzmooB0DpvsfAsLSUii+USvtCK99/09Fa5GebJm/j+a4SC0YTihfd4NXxE?=
 =?us-ascii?Q?YastcKQH0g7faGI7KYMHZ8XslSZzO3mT0dtefO/1Jsmb8N5ahrM0PGhPg16M?=
 =?us-ascii?Q?oQAyX/DYb9tM27Gmjc1phTPuHXZLM5PqvMmQ1F4zqkAVsMKESsgmxM/2JTyq?=
 =?us-ascii?Q?Qy3/sq/++ohHLo1HTNPEMkQy8SaxpUc8diCp0t/f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a0b968-9fc7-4c41-0868-08dbda7fa1a4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 02:09:51.7437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0rtZ+6iAcbu18H+9gkx52ugQrs0g+QlU3eNIFI6mZ3LiDS8I44rawcJF9R+gS2ZoahgNCaQi1QnpvMfwQF2CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5800
X-OriginatorOrg: intel.com

On Thu, Sep 14, 2023 at 02:33:25AM -0400, Yang Weijiang wrote:
>Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>to enable CET for nested VM.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++++++++++--
> arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
> arch/x86/kvm/vmx/vmx.c    |  2 ++
> 4 files changed, 46 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 78a3be394d00..2c4ff13fddb0 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> 
>+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_U_CET, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_S_CET, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>+
> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
> 
> 	vmx->nested.force_msr_bitmap_recalc = false;
>@@ -6794,7 +6816,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
> 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
> #endif
> 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>-		VM_EXIT_CLEAR_BNDCFGS;
>+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
> 	msrs->exit_ctls_high |=
> 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>@@ -6816,7 +6838,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
> #ifdef CONFIG_X86_64
> 		VM_ENTRY_IA32E_MODE |
> #endif
>-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>+		VM_ENTRY_LOAD_CET_STATE;
> 	msrs->entry_ctls_high |=
> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>index 106a72c923ca..4233b5ca9461 100644
>--- a/arch/x86/kvm/vmx/vmcs12.c
>+++ b/arch/x86/kvm/vmx/vmcs12.c
>@@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
> 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
> 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
> 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>+	FIELD(GUEST_S_CET, guest_s_cet),
>+	FIELD(GUEST_SSP, guest_ssp),
>+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),

I think we need to sync guest states, e.g., guest_s_cet/guest_ssp/guest_ssp_tbl,
between vmcs02 and vmcs12 on nested VM entry/exit, probably in
sync_vmcs02_to_vmcs12() and prepare_vmcs12() or "_rare" variants of them.

