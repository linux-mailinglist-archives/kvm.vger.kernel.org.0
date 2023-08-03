Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37D776E5D0
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbjHCKjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 06:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjHCKjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 06:39:45 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5BE58;
        Thu,  3 Aug 2023 03:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691059182; x=1722595182;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gxxjSliO9yB9o6M/leAm8ZORLjbaBX/A/2+iEc/24bY=;
  b=d2g6xYZa5Rqn5MwmuHNUKM+yvl68WImQ6eC37vbITTTosH5UNA9T8Txh
   fi94GbxWpfuLee4dEyQ8DclhsCblYBdDCOadpUJto5WQbNOFOt+7LOlW4
   hBWEuaAxqrTYKP+7nKTvN4TCL7KHL9VENyUpIrtNE3NDA5Pc/XYHR41ix
   OoVRcml2SuoLd5Endby/BKo8e16/IekHMhALUAh2Ldq71rEwQ3RAmI49E
   qMW4q2rMrqbUiRSSjpOJEBHHdURHG7o7CyvihOl9T41sTlZTAD20XKhBY
   0LeUxZYjABDf9OqFP1P9j5gQhh35RvfWmgonHikqxYd42PAtGR8ezLQki
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="372576779"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="372576779"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 03:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="903333979"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="903333979"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2023 03:39:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 03:39:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 03:39:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 03:39:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 03:39:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8r5QDVFCMlY1QYlPH8SeM5cXjet0Sqs/gJ4RR8iH7/aF9S6rGqjmvK1Ifgc1JXBfuJ4CvS/aHPHPsbAVeTLEeZZq7K9dVolxWkF1pR3VSHoHE+zIUe52t8ST9nQhHajmPqY1Fw79u42rqgttZ63DdxmzjYLurQJRMl44b1N6xhwJu+2rPFo3J7ojSmmWzZDY5jeL3marwm36KsnL9MpI5jCD8VFUTynJqgZRsSTFJCrg66uBH67qngJmIt7wmUlnaTPkguCE4biqW35wte+XcQ0xFwNKtG2yTpMT0y7fByxLKrXryfKjnsefiAs2dkMZVebSenyPPTwhGDu9H3T/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sf01nMnjMStooqPsy9wuIl4aBUjOHoIG6enIZZfZPZg=;
 b=A6RGSDC+ow93HKFzXeQ2qXebJALi2dxiA0uHxTTWjpawkDby31QAOV17dkONsIlLywR4cN2Oi8cAUKD2UITRSzV8BbnwAh4Wd4arQ5JdnhafeRLp2p+uzYiQKdwT9JShS0ObP9+xuer4yA2bwvCyfvrCE3kDVsIGLLQCt/e1o6pIq7xqpsqjAr1K6JBimjRq4CyXHJ5HLOcAX2LV7SyGZwvtOtWqpuaQ5iCWEPHI0N2kOjJzTgJVff9bq5Y4pFvixuU1WpP4rW0Lj5gg5vskoALXldIpakgojFNhzMPv4Mkcxd6RT9AFDrqO9W/ujx9ZOhpNBJbpYpny0yLPT/1eRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 10:39:19 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 10:39:18 +0000
Date:   Thu, 3 Aug 2023 18:39:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Message-ID: <ZMuDyzxqtIpeoy34@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-9-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4790:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c70a0a-51b1-4328-d40c-08db940de3d3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RM6OANmrmrCvsRKXWTfsbv7ztCcQUcvk/4Gz+yFY9WU6nihamMxmoFp34/THLEWbXY+w2Eti60gLo4+WeCpD5P+qeEyLpwBJBldzRbCTqHepMgUqZiJaD5rXQFCW+y0LVCvzcQ/GwirDubMCz+l9a17HzQoNUAg8NWi7wCrXfpH7c04bHyD3Xe2iGRGHh+CnN9ab0H2rgpeq11PJ6/Y5mhRlAkiSoUnRXNPFNjjuvrowdgBqcwGUiydPwulEwGV5LNl9+qQy/vVKFLSHltcKdxYDFPX1R8GNb7aCZWL/no5nsaeAxF1CEUNIt+AEwow8k+b8pAjz29LcFASDxlwvFLf/O4XcBxT0KfIrnJSWcvjuIS4OfuqmuvkaMHP+pAbkYM3OyX2E5Iux85WpDibDgBo4cK7NEi4H/UExC9Ik2yiBcdlp09zr2WDRCeuo79+PLRRoTHB4UJEJj3YGf+d68orTGO4xbsySlVaDlUIzbAy6Q0Klm9BFaCH0VmJa5LdKfXa6GWBqrSO/fy7jjZ9VGK+nlWt54ujE95XaT+2GwzVsG4T3DbsqB+YdCg+cM2Qy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(6506007)(26005)(186003)(316002)(2906002)(6636002)(66946007)(4326008)(66476007)(66556008)(5660300002)(44832011)(6862004)(41300700001)(8676002)(8936002)(6486002)(6666004)(6512007)(9686003)(478600001)(38100700002)(82960400001)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EZObGNDWmN4LlJM8el1Qq6k4TZVaYqXu88RdxZWoAj0aJliDc4KyHOIk7CcF?=
 =?us-ascii?Q?kCjLookPxTS2D3tG18gBL/p4V8dWeQviyZKbZUTWjwfct8QQgFPHNwJxBUS4?=
 =?us-ascii?Q?lY7S/qZMoIv5e6Uibzg1qjs2d6L/rAX27xgsExnxP0cLFCrv0wORF5tODlDp?=
 =?us-ascii?Q?ivTGDhMOZy0YP/HlpkMFtGLR4EDmCeJKZRj/E6pyZ7c+9LyYRH9U1iqUj8K9?=
 =?us-ascii?Q?o5FmFFTVVUwzZzEQeQbaRm2e6oHnY3vDB89lCwBm59YXN52NZ6KUOtIrt14G?=
 =?us-ascii?Q?2IHcfflviTfIf2PZbyJeh7A/4KipPMmY3Bf1MqVdLSyXs37iGg70GxXOdvN3?=
 =?us-ascii?Q?dCxzqjCpQHWUwevSgNXVqGsb+VCFuP3DfcQLO8/+Vm8ufX/+X3F8AljUUbN6?=
 =?us-ascii?Q?TSRtqs3XPw/gAJ5CcLfgfnmJA1TD556h8ntmeUu6XH7gi+PXxjNlmcuwbUE+?=
 =?us-ascii?Q?6/EA0XWVP6Zbrzv0D6pEEiAVbkvABwRFhsK6GB6s8HVmb50faVd8I1sN/Vbn?=
 =?us-ascii?Q?0xDIuTJdgQXgzf06EiRKwZKaxpiLQjn0aqRTGJMW3rZSi1OfqzsmMT+Or/R6?=
 =?us-ascii?Q?M186wF2go4mXxMQOJxCQH7GrXb1WMaV1hGLXEvJlEl9IWFH7xJws2Xzc/9h9?=
 =?us-ascii?Q?efmsNxJprmJ8pAbr5XPghVpniAaLGcD8f+MQBuO93EqIRUt8q1ncl/Uv6CM0?=
 =?us-ascii?Q?pfq6FOX/KXUvuz5dhlQ8WmlIrIhAYsF6wcVRYwZ5Eatl8/wHd+/rSHCDVgmd?=
 =?us-ascii?Q?ZQ6XdZAhzHNONyv1h0hgUeuI7erTsYllQcOQ3LTGG8gu+Ls2ryP4wttyp1Jf?=
 =?us-ascii?Q?uuNY2WgTYXeIQZf7GjhbPZSgMAFNQDc6dakkbCO/1wvSot3z+6aRcvl+eUq0?=
 =?us-ascii?Q?sFqlloeJwEnR2R4td8OxXWQ4e7NYnjRHrZeUkT5LZPGYIbmqLknkXHHN1iOq?=
 =?us-ascii?Q?wyqNVmt1akLHlH1arPGLUIKq3c4k5y8aT+rxWOpUaYh/B3mYezpXvo5jFnL4?=
 =?us-ascii?Q?XGl8zsKJtlz4gqQSTvJEmS2Y76VebinkGHlSbk/eMhE2wrM24waVd/JHI+Ol?=
 =?us-ascii?Q?F7pQcKxS3LDDQeS0RmNL5BQXBh8pwCxmGYvNfW1U8tOzadb43ocMYW2mof88?=
 =?us-ascii?Q?CXkpLsqPEa+TrkBkwNMUe1DlUKTlIGL/4LjuliECdEtBiEJ914EBeNAjOWUt?=
 =?us-ascii?Q?O6hg/9Nq76am1m44PPxj+JH58gPOZ59KFjRn6/E0rpmEx8kNtsqqGiJGAzD3?=
 =?us-ascii?Q?O5AGKzbCMYQ9wiXa76hNJ2IxoeDObbygE++SUUAvcSpk/PeUN4Se+Ggsf8An?=
 =?us-ascii?Q?b7/PVcKvuDAWAnrFJDFFDMj1qRS/N4mdhEn+gh+oYxK85oV8rnAlW7Jrcv2V?=
 =?us-ascii?Q?hQlXmxSZqzBUj5L/4NA0D/MwbQpLz1/H2bHfsM5wAijF+el8DgsgEA65Bv36?=
 =?us-ascii?Q?2gwmhjubHM7fiTxs50HpfTy5emEjt+VC4CnCUXHnpM+ppgIBS/KLiTs6rfL7?=
 =?us-ascii?Q?dJiEB/v3r2Rb+OJ+A4skkArJXxIeCk7CFZM4CF8wA0u/DSuVsjYQiZw0mOm6?=
 =?us-ascii?Q?OUmoEOnh6dYwm5Yi6JWbPcR7VxpCkdglXnmiIauE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c70a0a-51b1-4328-d40c-08db940de3d3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 10:39:18.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDn+//SZO7hbvUppzRG0V44uqxK0weX+gksiFrRM4qqlWAAQbGaYpb505m6B2v/NoG5BQSo7tbYVRNU4V4QidA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:21AM -0400, Yang Weijiang wrote:
>Add all CET MSRs including the synthesized GUEST_SSP to report list.
>PL{0,1,2}_SSP are independent to host XSAVE management with later
>patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
>host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
>are not XSAVE-managed.
>
>When CET IBT/SHSTK are enumerated to guest, both user and supervisor
>modes should be supported for architechtural integrity, i.e., two
>modes are supported as both or neither.

I think whether MSRs are XSAVE-managed or not isn't related or important in
this patch. And I don't get what's the intent of the last paragraph.

how about:

Add CET MSRs to the list of MSRs reported to userspace if the feature
i.e., IBT or SHSTK, associated with the MSRs is supported by KVM.

>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/include/uapi/asm/kvm_para.h |  1 +
> arch/x86/kvm/x86.c                   | 10 ++++++++++
> arch/x86/kvm/x86.h                   | 10 ++++++++++
> 3 files changed, 21 insertions(+)
>
>diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>index 6e64b27b2c1e..7af465e4e0bd 100644
>--- a/arch/x86/include/uapi/asm/kvm_para.h
>+++ b/arch/x86/include/uapi/asm/kvm_para.h
>@@ -58,6 +58,7 @@
> #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
> #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
>+#define MSR_KVM_GUEST_SSP	0x4b564d09
> 
> struct kvm_steal_time {
> 	__u64 steal;
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 82b9f14990da..d68ef87fe007 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1463,6 +1463,9 @@ static const u32 msrs_to_save_base[] = {
> 
> 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
> 	MSR_IA32_XSS,
>+	MSR_IA32_U_CET, MSR_IA32_S_CET,
>+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
>+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,

MSR_KVM_GUEST_SSP really should be added by a separate patch.

it is incorrect to put MSR_KVM_GUEST_SSP here because the rdmsr_safe() in
kvm_probe_msr_to_save() will fail since hardware doesn't have this MSR.

IMO, MSR_KVM_GUEST_SSP should go to emulated_msrs_all[].

> };
> 
> static const u32 msrs_to_save_pmu[] = {
>@@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
> 		if (!kvm_caps.supported_xss)
> 			return;
> 		break;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		if (!kvm_is_cet_supported())

shall we consider the case where IBT is supported while SS isn't
(e.g., in L1 guest)?

if yes, we should do
	case MSR_IA32_U_CET:
	case MSR_IA32_S_CET:
		if (!kvm_is_cet_supported())
			return;
	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
			return;
	


>+			return;
>+		break;
> 	default:
> 		break;
> 	}
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 82e3dafc5453..6e6292915f8c 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -362,6 +362,16 @@ static inline bool kvm_mpx_supported(void)
> 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> }
> 
>+#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
>+/*
>+ * Shadow Stack and Indirect Branch Tracking feature enabling depends on
>+ * whether host side CET user xstate bit is supported or not.
>+ */
>+static inline bool kvm_is_cet_supported(void)
>+{
>+	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;

why not just check if SHSTK or IBT is supported explicitly, i.e.,

	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
	       kvm_cpu_cap_has(X86_FEATURE_IBT);

this is straightforward. And strictly speaking, the support of a feature and
the support of managing a feature's state via XSAVE(S) are two different things.

then patch 16 has no need to do

+	/*
+	 * If SHSTK and IBT are not available in KVM, clear CET user bit in
+	 * kvm_caps.supported_xss so that kvm_is_cet__supported() returns
+	 * false when called.
+	 */
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;
