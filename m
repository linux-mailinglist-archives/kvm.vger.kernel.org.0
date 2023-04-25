Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF936EDA82
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 05:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjDYDKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 23:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDYDKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 23:10:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066F97AA8;
        Mon, 24 Apr 2023 20:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682392233; x=1713928233;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jS4KkYl2Hkrb7M2BZys+9DPS6X4BkP5H8yKxak8rR2U=;
  b=SLV7RjDyHk02vAs8pJ6jmeXlsSAzSO4bU8FNt1ee0+fj3ykhfKpzopDD
   hv/rV53V2Fh8BhZqKcRYZyfAsszWHGp8h/rMt5cfhQOtkf+r97nx459Cs
   tVX1NSVE0GWgdr76xWh+JUAhcKQ5q5we+6RDoUI6ckdSVtV7XUnhyG83U
   t2ZWqijlZxfLSbTSzGL5jcjTvjWnDqA542VolyA+O/vv74lPmzQNDkUaO
   QFpr30kHn54hl7gFP6Wuz7Kc+bEdLx7WOeLxtQnRu0p+88hMFGACjg67k
   +sQ71/92CiXvA7bt+5qC2j7JL3s1X2wWnyP/+48KbDxR+HqapbiqSda5F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="349438232"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="349438232"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 20:10:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="693318841"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="693318841"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 24 Apr 2023 20:10:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 20:10:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 20:10:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 20:10:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 20:10:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDgna2jGf5qCXNKJpe9C+v1hNIfUcDycyhOdGObi/kxc9jTTSViwGPosoD7MLBFJaj3OK7Ve+oBiU0hga+W3iVTz7YSg8CD6rTrHxEnhXKKxXOj9qvbq20u5Db9v6RSOo5M2aaWOQUOT8wiRN5fPaAak+eV55ZQ9e7VJ312JKUXavrfAd02eWmeK+iZwPDmcCW7lj3Q3OQdkomYslydtOFuqxrYf6GkamS6/ZH2UU6w4Dwe+6jUC2s6LQnB9d38dVe0EeXva7H6UXNyWzBu/e5+GsgakAO0mCImLqxspk+AefzzX6V/KDf629k7HVdpH4HTxlbML1CYo1KrpxDsVKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPgErx92P/G/IKH9HymoCeUxBL4wNx6hY7NxgIP/Qxo=;
 b=RoYyhC+12aQLSRBerrTMtgNhTfGACK/BCTcaHH0fGoPcOVNS6PEwTvGRAgOk6jpkzI5kOAJqI3yon3qqUbghvt8cL7t6+QvZopzbtXYF/lNATCQfBWr2p493eDBPeqp6IocV57XVhxHl2d5iXdDflNVg3n0C1q3lvzRZqBYCPRTJ+yjhMomromJAm9IRBsTEZ8vaF73D3q+NAEIo27dLm20Ju3QcPwkpJ/UZvn7gNmPK2qX1obyHh4zfy7anUDE69UCnZHkDp/cdbj8EiW8Q5obzKZWE3EoT+QIHMVIqy5bgP0aSz/8svNQoeOgo0TPRgG/I7g8C/AozaSDOQKekXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW6PR11MB8391.namprd11.prod.outlook.com (2603:10b6:303:243::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 03:10:29 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 03:10:28 +0000
Date:   Tue, 25 Apr 2023 11:10:16 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Message-ID: <ZEdEmHFgHut2tDwf@chao-email>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-3-guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230420133724.11398-3-guang.zeng@intel.com>
X-ClientProxiedBy: SG2PR02CA0138.apcprd02.prod.outlook.com
 (2603:1096:4:188::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW6PR11MB8391:EE_
X-MS-Office365-Filtering-Correlation-Id: dc4d45a6-8694-4b83-4791-08db453a9ef4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcobvBqrxVZNTUGaE4leezdk9ligLn8vkjQtx6UCH6jh9n5ipvziK/piDFh5CORY2uHxDuCwMbMZIfvAVpysv7WjmiLdWzOzme7ubth81RkB54H1IgRc1lQAS+COEL8o+XLklX5pnnOTyadZhEE6zyOc71itFl6M72SRSY8kmHf7IoybbuanUVZ/eG94A7rGmRhO7/PZGUC4Hx1A1F6dWToIlc6t9RDsnGwdKr8jR8dxyDd7kqsKLyV3CSa69yyRwloaTQI+7RwUmABqUtgyZ7FqR2+UHrjjVziug+JcN2ygiF4JtVpUe/x3Tp/P0hj1SfEclFFczXu+BeeFFR2m8aBkDK2DW0P1HMcwGMqfFRxIQ+Ys23zVZJMDKsRAhdNCcswNlDQIHUFjV4KaED6+uolFX10HZuwTqjqYHXwVA4vGWM++1WueE33uNEWg8msKlbnV0CzZspyovNrjWxdM17RCMlWCXqcN+V5axWZYDWbF53pgzeKy6gueRGXN7MYz35O0NZMoW02nLRlJsOi8bgWwikxIWXMnbmIR31+Qe+aD3kJfMote0iVtK9DKIL4O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(38100700002)(82960400001)(6506007)(9686003)(6512007)(26005)(186003)(8936002)(83380400001)(44832011)(7416002)(2906002)(6862004)(8676002)(5660300002)(478600001)(54906003)(6486002)(316002)(6666004)(4326008)(6636002)(66556008)(41300700001)(66946007)(86362001)(66476007)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+vPUKE98R6zrAuCPo/KL0C0EFvJirw8tAAtuiWjqyqLLUu6o5msSrE8yo/75?=
 =?us-ascii?Q?L75mWEKddq554A3VFyPdI1LH+YOpkVLVhy+5YmAysGF/OVMmx+M2w0Zuo0Fr?=
 =?us-ascii?Q?67f9a3cYZub1+4gKGHstHCyBicmqoL7paZVzbMP+jkPT7kFsBAs8dQRY987A?=
 =?us-ascii?Q?pLBcPXd1lH5CbtmHVcC+sIVzBwhGHP1BT5JksNhHJtOkabSAwZFqajLlWIFE?=
 =?us-ascii?Q?7e43Cmau7ZutacxPoxANSBp9FyI3YxYSht4wvT4f7Mc2bQ8AGVQ1R1s0d8br?=
 =?us-ascii?Q?ZQEnyJDpubcUfKJL1Zsg58GY5C+xT+EdyiPXRuLOVMJuNEHuGweUJeLwQtpq?=
 =?us-ascii?Q?0RZdBe6cjI2biyYo/wdJRNrH6Fxk5JuaM0mS84NaRbRNV7glQeEkzRKK/8CY?=
 =?us-ascii?Q?qHIAF70jQfMQ461AwhSHVB1PkkZEc3BqAV5Aq9luPg5DpkAKr7wf/CtY8dTs?=
 =?us-ascii?Q?TlqYqIolVy5459K0XknmTndQiJAPTi1nJ384XjvWEuS83M4bNR24w7ZCEDuo?=
 =?us-ascii?Q?e/cyngCbVW3/IMGZYzW67NA6mG/P0F2N0oeh6eGpi2Ghi1rRh5NqlaLTGEUV?=
 =?us-ascii?Q?sXiMmey0Flh+CuKdi/oVQPLnu6+Utragy4aWAc2mHM0PThrxey5Honw3cJyX?=
 =?us-ascii?Q?VMHfvzRWRnW4q4jawldL7OwJdH5GRSG/ZxD/1SOFqMeH2PF0+60YeO/O7Stt?=
 =?us-ascii?Q?aJwnIW2n6/bqVSvNYsgbJn7y+O11jT3yOTdeP1TZj8ITVTGcOBxZPkooS5vO?=
 =?us-ascii?Q?eBGVz7e1SRp+Ix6nV+FdY+1X2eG6VQEsdzmqiBIQww8QyW3tsfNJAZX3TYfD?=
 =?us-ascii?Q?GLY0H9xXQS7pN9Y1MrU4ZaOXQPOFDtT1nhiUgqE4A0bY696P9eCiaAp0RETl?=
 =?us-ascii?Q?YA7+JYAQWAKvvARy+FXViUUeqxHod5tTX8F3jWzmW3PrrOrJqHtMGDXcCZkC?=
 =?us-ascii?Q?5l70c7FOfirD9XUuA07LerZ9soKbCcxcrwVTCqy5SGzz+didxoOK+qIZaVuL?=
 =?us-ascii?Q?JQT7RNVTzxpeQgbvSyU7VjeRHMsrXVOHkGSoUB6ASvgA1HflPvfrzIBcxnx9?=
 =?us-ascii?Q?s4TjfB4/fGQsR2S8mDD3Z5IUfGEt0StWYRnEtar5xGr58fVqf+tktYFJYvzD?=
 =?us-ascii?Q?R4e7wByeVf5gHt4+JmcAhcfOKZlcV5jvaM3cn9/XSQ73LOq9hvvRhZPdxSVh?=
 =?us-ascii?Q?Xry6tUz91YwYItByxWbmZ/gq2H0TsT4jW2POCBw8F7iyjnLoThs8MAOxdFSs?=
 =?us-ascii?Q?ABGT/t4a7XZCqO8z5xcf7ju3VGMQALjOS4DnErSEZsyfBSnzhxEdeJm2uZbP?=
 =?us-ascii?Q?k8r3ARHnGw4H9rbzWJjT5PpF5em4gXpLEDu51CvhyfYE5mUBN5M89nuhG9C3?=
 =?us-ascii?Q?Qmf4A6LUlL0k1EcRT6WvLfT4sySHmAZ7WWeFdrEkwsAUqENheLBdaecvb8UC?=
 =?us-ascii?Q?WIth+YG15rJOvxaQFV/M9zfvzVAxvPk5Sa6uNDlmes/ubzhawoTfpbC7vg9l?=
 =?us-ascii?Q?hv3jBE17zUyc/nantPP5ThUjUcbP1quFTPrsd7zsl7ZREmOrf+ThsooMRKLK?=
 =?us-ascii?Q?KKBZSqNVuI7j7xF/1F9gEDFWy4YuZahvSOW7c0+M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4d45a6-8694-4b83-4791-08db453a9ef4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 03:10:28.4121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eX8RXAUdeom01lMMchABuINGnrVCyVLPCXwAx3n+I29Y34siOc+l33BkWcc319r/etvD2kPOOIoHrNW0O4ep2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8391
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 09:37:20PM +0800, Zeng Guang wrote:
>+/*
>+ * Determine whether an access to the linear address causes a LASS violation.
>+ * LASS protection is only effective in long mode. As a prerequisite, caller
>+ * should make sure VM running in long mode and invoke this api to do LASS
>+ * violation check.

Could you place the comment above vmx_check_lass()?

And for __vmx_check_lass(), just add:

A variant of vmx_check_lass() without the check for long mode.

>+ */
>+bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags)
>+{
>+	bool user_mode, user_as, rflags_ac;
>+
>+	if (!!(flags & KVM_X86_EMULFLAG_SKIP_LASS) ||
>+	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
>+		return false;
>+
>+	WARN_ON_ONCE(!is_long_mode(vcpu));
>+
>+	user_as = !(la >> 63);
>+


>+	/*
>+	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
>+	 * accesses a system data structure. For implicit accesses to system
>+	 * data structure, the processor acts as if RFLAGS.AC is clear.
>+	 */
>+	if (access & PFERR_IMPLICIT_ACCESS) {
>+		user_mode = false;
>+		rflags_ac = false;
>+	} else {
>+		user_mode = vmx_get_cpl(vcpu) == 3;
>+		if (!user_mode)
>+			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>+	}
>+
>+	if (user_mode != user_as) {

to reduce one level of indentation, how about:

	if (user_mode == user_as)
		return false;

	/*
	 * Supervisor-mode _data_ accesses to user address space
	 * cause LASS violations only if SMAP is enabled.
	 */
	if (!user_mode && !(access & PFERR_FETCH_MASK)) {
		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;

	return true;


>+		/*
>+		 * Supervisor-mode _data_ accesses to user address space
>+		 * cause LASS violations only if SMAP is enabled.
>+		 */
>+		if (!user_mode && !(access & PFERR_FETCH_MASK)) {
>+			return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) &&
>+			       !rflags_ac;
>+		} else {
>+			return true;
>+		}
>+	}
>+
>+	return false;
>+}
>+
>+static bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags)
>+{
>+	return is_long_mode(vcpu) && __vmx_check_lass(vcpu, access, la, flags);

Why not request all callers to check if vcpu is in long mode?

e.g.,
	return is_long_mode(vcpu) && static_call(kvm_x86_check_lass)(...);

then you can rename __vmx_check_lass() to vmx_check_lass() and drop the
original one.

>+}
>+
> static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.name = "kvm_intel",
> 
>@@ -8207,6 +8260,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.complete_emulated_msr = kvm_complete_insn_gp,
> 
> 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>+
>+	.check_lass = vmx_check_lass,
> };
> 
> static unsigned int vmx_handle_intel_pt_intr(void)
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index a3da84f4ea45..6569385a5978 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> 
>+bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags);
>+

no one uses this function. You can defer exporting it to when the first
external caller is added.

> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> 					     int type, bool value)
> {
>-- 
>2.27.0
>
