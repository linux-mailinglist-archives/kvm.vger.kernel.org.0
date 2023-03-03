Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609266A90D8
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 07:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjCCGUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 01:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCGUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 01:20:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEAD3E624
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 22:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677824452; x=1709360452;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qeI1/pxxYpmqjdRthZVKL/NIUEX5wlBKJnWBNPISC34=;
  b=JF6ZnZnlwGi4GisJAn8djHaqQ0anLR8RJKPt50L3FmI2n0tT682PWIq0
   U/O95vxNoKczusI6mDnvrJQc/QIjHL7G/kxoO08/HDe6vl2x5vWJu/OnH
   A5mMklm1JsCioFogmSemLymCt/5EXRr/MRSiKq1qAIZXeBs0Nimjv9AyD
   CQhac3Ui+CQfQaeF531HUIwvGyH0qlecwp8TMnGlM9n5jEbBUDrC0mh5i
   jFYjAVgGrwgZR62mG3ggucJM4LckqGVwKwXsd26fHNaSw8OPeNgZkzSdK
   O9C8JExv+jJsvcCYhJ8Vwq0zj1hN1vM0RsbKYhqCkRyjwyXpZqjlHXcsv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="318791112"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="318791112"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 22:20:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="799131017"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="799131017"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 02 Mar 2023 22:20:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 22:20:51 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 22:20:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 22:20:50 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 22:20:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4DsQFD4505pglKMtqkrZ4sHaPtTsKw7OfVPQtYLf1wQYEqhj6HaegrwrehhglElw4VtWxTdwK5A0Oz1IMyu7PEbrGE6W4eRK9q7R3paY+Ar6UMDMq8NWh+biFSsuKVJAKVq0BnXyEKGyzWFeeHwiMND3arqirdxatN2JwHnwGWWWCixCSC9TXBc3wixFWZTSxvIVD4x0YRxh/235kBy60rG6HxAkaraRAQYcMxG3s20LAAI7seUBNiGkqOwC9gAyd+DHtvlE/SzilqhexTM5b80hMhN6AOyQ6KqsM5sJzHtJdeB8qm0pFlBiuAl9Fw+vt9LCVe+4wEbb+rKTMFFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnAzZpLrmqmlJDpgvUGK0a1oWTIveaxRzAL2Fs+kEOg=;
 b=Et0KW1Inqp13/J2kIleUf9NW0R1a8XLwFMaYB80WWc9Mjicgr877uynVnOtloonwQ44yCaW+RS4WjpNdo/9rpHvyo6SbMx82u72pjPcNV5kN2EzQlLNGEoqjzgEyXet8OydGBtKiOmX6Eqs4hlSX3CZT5noThO2BSgt0L2o3vyk6BjzTjjIlJX4qR6CYSthIkjh6WzdM7/Eqocl2Azv7tmV9GAcU+v6LLee9BgqEkA4YxxUPiRJz5H1UUaIcUDw5ihdVx14DIXFBGESl2ttavfhhhNuYw1ffRhIqzfNPMgFj4KKtDbJYAIHeBt2/CvOt9ZyqAdikyIYEvc+SkiAj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5166.namprd11.prod.outlook.com (2603:10b6:a03:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 06:20:48 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6134.034; Fri, 3 Mar 2023
 06:20:48 +0000
Date:   Fri, 3 Mar 2023 14:21:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZAGR1qG2ehb8iXDL@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-4-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230227084547.404871-4-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0162.apcprd04.prod.outlook.com (2603:1096:4::24)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5166:EE_
X-MS-Office365-Filtering-Correlation-Id: 8af70842-b140-4101-d57d-08db1baf6dc3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O30edRT7N5xGU6sCqgUOzg8LbbvVWCWYvLlA3ykUOq6/RF0Jw0Ob8+fsJx5wdCs3wn5MsqItaBznJZVt2Txx6t0IMx0UA+4HegzGfRLnM47VCobVbBimIAMWc9I0pBzIrEdPcIbE+hg8CpnyRUraKk8LowAlrLlObhGbbpMzBAEuUGMUbLenauh1dauoOD24d83pqYfZOuZIaMouyzqwmUCbQqzn05NxtLUUFAXUrvdQBUKAQpQFeDwVGOOyu3cHS9FOfUzrhahJt5xQTBcwkK3tIwgVr4BZL/T2fzvbmc2AL3ebyCUOhvaYTl/IYu2Ozf9YROET3Rsr+rGhg2eiVAmmxkpcAqTEWYJntMHBNEKb5wtWCwv+ePLwmVRjkPuh4BBUUYPP7YPT32GLyKCrwZ+ukh9k/rSDO0flL3tV6pjPe8/f05WKdnqRRJIzMJx4a5uuEjr8LCqS4NBL1A0aZWkWnu8YCk5fpBIm2h94p6ZIDHoutlu1ZpHa+BkkbIEb14e1nOw0GgfBLp9BUchnb8/kND4cJFI7VuoEfC9ZjRBi080ga1iH3A+6smJVXMaj/7r9mFMEao2lFjUXztYuuQEqUI3JQ9jfn0831E4Of0NGQGOLt+FnCCZJKoEFtvq5azJfY4vlD2TgpISdA9lzZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199018)(83380400001)(6666004)(8936002)(33716001)(86362001)(38100700002)(82960400001)(478600001)(5660300002)(6512007)(26005)(9686003)(186003)(6486002)(6506007)(44832011)(66476007)(66556008)(6916009)(2906002)(316002)(66946007)(8676002)(41300700001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DfJvYu1cOUUe4+dQvidZF2iMrIQOpFEx8QXoub6AO/c4pemQY0gbAtNYWNBb?=
 =?us-ascii?Q?LHU1Ktgxun6kThuqPIUrb6rEUDdykGxZjYhaNGIhtVePoRsf4CHVURirt5bD?=
 =?us-ascii?Q?CLA2VPVFLoaN1yowwGYXzwcKWgBhzUyK++N2skutysi4C8TlAzOSvvpjVYkc?=
 =?us-ascii?Q?juZNu4xu+2tOk3nuIlJ2d8rz91dyYgvaFakT/QORNGi9p9EjqLnZJEA9p3lp?=
 =?us-ascii?Q?3u1p/OpEciDW7xzoU4XDP947JGkdbwUrqyvpzn0dP+YGthOzstYmZgITEK3a?=
 =?us-ascii?Q?KfSxGZcKUrj63oGl9XELxl5JCj4qVEHJear18ZrQ7uI7zmiCm9JHrBI4AlBn?=
 =?us-ascii?Q?WO+4UII8SVHWAXDre2iDoxzsbaMZfL14FDtW6tu0769DiVwsMIRA3V3zXdFm?=
 =?us-ascii?Q?mPmvvm35Krzdecz/y3ArFvbGdyEqFoTBTO3vF7QclT+IXWnK1E7n5tRY+/SX?=
 =?us-ascii?Q?7l6U/xka1z8UpzESuvRYr/UNIfmgXNQexRns0iMtfM8j9hRvKt65zo4No3Ed?=
 =?us-ascii?Q?0NZRPbBWEgjkcA78VMHbWZYr1ONdIIwb9gp8NfJ9vHGflgUi4jWr+p8mAF7B?=
 =?us-ascii?Q?6B57ZUobeg/JLcfHTl0pFEuzTZvbFb9Vl6ap6euSf3iKK0HiQQo7ACxIoYUM?=
 =?us-ascii?Q?akkLoenQKaj24/CIzXUjaerVEiml503Z6YyKYUgkG7e+JHtAYNAj00yfOog8?=
 =?us-ascii?Q?72OWdX/Rm2hqJll2T01LWbB2AVOOBHlErUN5rSY8JXt1AU6icUBwQIL9mhRN?=
 =?us-ascii?Q?2W+1hovXg08AYbU4/ZJ/QNY3BiAXviWnucIr4H16ydJkKeiVloMrOOcYBpZ6?=
 =?us-ascii?Q?KW8aB/jYwkb834wcnZYvNgrTZgJP1CPbfOUeZPrQwhxJWCDr7xpqO5LCsLSR?=
 =?us-ascii?Q?hXUgD3noXwnChuO9ctC8EPJWcP98WbwzfhnWTLHkjiEUAZ6amk+zesG4loFl?=
 =?us-ascii?Q?+bZ0AN5FSZ0N2ZMoAgnX5KaGlxawyPIyUDsFsSax2lCkhA5g7Fj9WP9fBimZ?=
 =?us-ascii?Q?DkL8ddbgAEsaBDV93++EUD1DZALWh65mrIY1/pyggYCB4U+YaRjz2OpcvC6x?=
 =?us-ascii?Q?BZmFZIQlCDcJPrTqTr5R1jLKSWRiQk7tcwfE6sMTyIz3l4WnwWZF8hOhfUTg?=
 =?us-ascii?Q?SlyZsgLEvZS7R7wwK28+NwVxLwm8/+Ea+re7YaEUCfK7A0Ntt/LnuR2gr3jf?=
 =?us-ascii?Q?nJB2U66h8kTzbGg8z3EAsZVW2LVVDLZxLmPjcI5rTTaMHL5wxmmkdj9ombQG?=
 =?us-ascii?Q?Nn9T4smPHc42C/Rr7GItOzt+g8GmTk8bqnwzVmqSt0N3sYJHTX0B/D5D8JWn?=
 =?us-ascii?Q?xartbr7s6P0ETLzilWemi55uCtljEv6hkkzu8Jm+J62CEg69tRfDsyPLTh8W?=
 =?us-ascii?Q?9F+n4Z7KmrbzQ8RNA4+hqejtqbQfhP/j4+zCbA0yxlV9hy4aj1GpJxDNKXMm?=
 =?us-ascii?Q?NmGTW7BEqUqrPrZ8mMLG3q0Yqxd5VyegKPpjaUcMisrre7cBjisPQG03erUz?=
 =?us-ascii?Q?uD1FLFZSh2+cgj3XFTTu3dlnbV+St3fz2VfJ7+a9CtfZ2vransy+TJbJAdET?=
 =?us-ascii?Q?jHZdM0aLlB/oH/l6Pyss6yv1xO7oYY7qIz1Ej3XC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af70842-b140-4101-d57d-08db1baf6dc3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 06:20:48.0803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DT7qbtXYWheOPaIDZqzaIWb7D0O3iAZo66hCP/WQEoV6Fe2J8IQU5VhBJz/TkMnRxmgpSy5srwsQMTd8aNwqPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5166
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 04:45:45PM +0800, Robert Hoo wrote:
>LAM feature uses 2 high bits in CR3 (bit 62 for LAM_U48 and bit 61 for
>LAM_U57) to enable/config LAM feature for user mode addresses. The LAM
>masking is done before legacy canonical checks.
>
>To virtualize LAM CR3 bits usage, this patch:
>1. Don't reserve these 2 bits when LAM is enable on the vCPU. Previously
>when validate CR3, kvm uses kvm_vcpu_is_legal_gpa(), now define
>kvm_vcpu_is_valid_cr3() which is actually kvm_vcpu_is_legal_gpa()
>+ CR3.LAM bits validation. Substitutes kvm_vcpu_is_legal/illegal_gpa()
>with kvm_vcpu_is_valid_cr3() in call sites where is validating CR3 rather
>than pure GPA.
>2. mmu::get_guest_pgd(), its implementation is get_cr3() which returns
>whole guest CR3 value. Strip LAM bits in those call sites that need pure
>PGD value, e.g. mmu_alloc_shadow_roots(), FNAME(walk_addr_generic)().
>3. When form a new guest CR3 (vmx_load_mmu_pgd()), melt in LAM bit
>(kvm_get_active_lam()).
>4. When guest sets CR3, identify ONLY-LAM-bits-toggling cases, where it is
>unnecessary to make new pgd, but just make request of load pgd, then new
>CR3.LAM bits configuration will be melt in (above point 3). To be
>conservative, this case still do TLB flush.

>5. For nested VM entry, allow the 2 CR3 bits set in corresponding
>VMCS host/guest fields.

isn't this already covered by item #1 above?

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/mmu.h             |  5 +++++
> arch/x86/kvm/mmu/mmu.c         |  9 ++++++++-
> arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
> arch/x86/kvm/vmx/nested.c      |  4 ++--
> arch/x86/kvm/vmx/vmx.c         |  3 ++-
> arch/x86/kvm/x86.c             | 33 ++++++++++++++++++++++++++++-----
> arch/x86/kvm/x86.h             |  1 +
> 7 files changed, 47 insertions(+), 10 deletions(-)
>
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index 6bdaacb6faa0..866f2b7cb509 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
> 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
> }
> 
>+static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
>+{
>+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>+}

I think it is better to define a mask (like reserved_gpa_bits):

kvm_vcpu_arch {
	...

	/*
	 * Bits in CR3 used to enable certain features. These bits don't
	 * participate in page table walking. They should be masked to
	 * get the base address of page table. When shadow paging is
	 * used, these bits should be kept as is in the shadow CR3.
	 */
	u64 cr3_control_bits;

and initialize the mask in kvm_vcpu_after_set_cpuid():

	if (guest_cpuid_has(X86_FEATURE_LAM))
		vcpu->arch.cr3_control_bits = X86_CR3_LAM_U48 | X86_CR3_LAM_U57;

then add helpers to extract/mask control bits.

It is cleaner and can avoid looking up guest CPUID at runtime. And if
AMD has a similar feature (e.g., some CR3 bits are used as control bits),
it is easy to support that feature.
