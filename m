Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4852F75EA7D
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 06:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjGXEZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 00:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjGXEZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 00:25:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D8A12E;
        Sun, 23 Jul 2023 21:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690172720; x=1721708720;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9HfQJm/xOu2ovKvKchgflGx/zl8kF9Q4f+sed5oqg1M=;
  b=QtKMxxgFkj2Vf4Q46osBYAeFtzHTLGezzI508XT0UswzQ10KnOPvTW+e
   DE1O5MfxDiGkWydnmwFmnpESbTsW7h87NnW0+z6h6xHr5THuxu1JAgInv
   GwigiyJwxreSe4idzMCBUiVVen1ZI1mx7gxsTY+8GojhIXOjsWshe9euo
   4h0vhIypluJGoF9a7nnAfgdYrvsMMR0/asDR8bxeQXQJUqzbtOv9CJF9K
   yOM3VwXQD4pSEwLkJZKQaIAHk09GA7zpyyq3LvegYewVahrRGKvRJsODa
   rZPyNHtV1gSbfSeaY032MJGfu1mWq1WmifFvJ/P3ytRrrREn8aEdtGn7K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="398243087"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="398243087"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 21:25:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="795631605"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="795631605"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jul 2023 21:25:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 21:25:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 21:25:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 23 Jul 2023 21:25:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 23 Jul 2023 21:25:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4A7XWw2/IgTD6f2/ryBU/H8a3IZzs7ry7MpWA4qOZQ1Z7QJZuSMI/oZEMvSTQdMDGBu/LgvPl+s9/f/6KvQHRdJ/yZy9cKmyqmOcUVxr+m9WUYOJ6Cmu33P2pUl4pYEjD2xz6ZMWL4jsKwMDm9TmfpKaq96Tbjs3aSmnf7kBYscgsM2JdvPIbYsuN0yC1sk+NyuiumxgYfMeT5QOkW2cal9Q3H2LUO0vY37ng8Qrddoy+gCALEnq2jFEU8KAnUOF+SHIx4O4paUW+NjFBH+s/gJ4YSetWz+dLvpCKnhBELUWpiD/PtU4GgqJjwU3denPQw7wvF3TTYYe19y1yJf8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtWG3THnnuDF0jkkgWYL8bUWPdEnh7sSLBscAHIbW7A=;
 b=KA8CXCn9p976tSO3edmuRCoipRiC4rZ0VnGAb2IAzgjMBYlw5y8ER1CacWCEBm7beUnAPRMWwTL3qEf/C4OB4T+TfzQorzTSa9CleWAxqV0ZzDo+64eAyVyiV7JgUVbhQm9QghMbywwmEcI/04Vzxqk0hAgmY+Wt0W/DB7GvxiYHAEJJcyy+93YKSXsRaKvOGi+AgYAEpWBCXboLcF6JAN1YaoQv2cnLTBvObxu50gaR0+KcDry5WIh7VkOJpp+n8qZngh4EPv+pvmRTiPCC4g0aJRLK8yFgKrzVoyH4F1xtuhnWzCsfHdvxd3bGzAoD2h17A9SH7KtvBtD2RzvAOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB6940.namprd11.prod.outlook.com (2603:10b6:930:58::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:25:16 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:25:16 +0000
Date:   Mon, 24 Jul 2023 12:25:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] KVM: emulator: Add emulation of LASS violation
 checks on linear address
Message-ID: <ZL39H3MnSgcJMmCV@chao-email>
References: <20230718131844.5706-1-guang.zeng@intel.com>
 <20230718131844.5706-6-guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230718131844.5706-6-guang.zeng@intel.com>
X-ClientProxiedBy: SI1PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::13) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB6940:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e2317c3-0144-4857-8f2e-08db8bfdfa81
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+3j+cUChH86SEMovUojFgQPFHt9lawfMtUyms58XN7iwjtEzPf5EfQ3UXAtSKfHMjGkS3amJJytS/B/Lo9Xv9N1NlgotaRN+emjxuAaVVcpJgc+Wp2h3cutvqAGq4Ef+9eDZGnm8P55FPg9uIshvxXMGcoiXiBWZo9MaFLaDr2uO0tMn50UTArnHsL/zBbhb3OzvnukQziRWpPhBufAi8OD4S7Z4iDhFyRD/cw7v1MFba4qwkJRdWt3iBmhtaRnt2j0q48uzUagZKEHXssbj+xj47Bu2fcw0dxQ4gScoQTv5pFdswmQyU0+D9SrISCNrF6QNqdVJkuRgYlY24DKCsPcfaXXDxow7bTD1t/PDn1aZCL3RFtHfR9tVqfftEJ0oerMRYLbQCnx1InqarlYhQ4kv/pqxLqd5H3EqxzPsMMx3xZU3Kmin/rKH040i5OAf/JTbJBEgo8I5nVGM0oM2HxR9yMlnIysRoAAW9hA3uonh+/6ycq6SPKdjcYBYpb3Z9WQuiakuxRZgO8/cTr4Qw0LqZyVuR44Ovbm4+XOJFbhIFHlkalk/AMLD4bndv6n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199021)(38100700002)(83380400001)(7416002)(8676002)(8936002)(5660300002)(44832011)(54906003)(6862004)(478600001)(66476007)(66556008)(4326008)(66946007)(6636002)(316002)(41300700001)(26005)(186003)(6506007)(6486002)(6512007)(6666004)(9686003)(2906002)(33716001)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yswij0D2XWqlRsInSF+gKewnVfeF4HICuWpBJG1vVeeTKupXY8KQzEff7eKH?=
 =?us-ascii?Q?Ab7iy9cC2k+5gEw1uGhGPOQ2KPy3RWmO0zAAm+tr/UKrn/wRe+7UrKch489N?=
 =?us-ascii?Q?v+La1FkPAbDXro6eyqNXFlbkxFSDpRkrEDki1Db7ki2jLmrAT4eQcULAfAUt?=
 =?us-ascii?Q?tZtgZObLYvV4CR03Ra5pfL9qUpZVWwhekN8pLyMZKw6SQbKa0NHvl8IqYFev?=
 =?us-ascii?Q?Q+4Qlpp3iF808i+Mk3ZWoBW33LvAtTG/3HThYI2xdhNO51Rww3zn0pZbJR0z?=
 =?us-ascii?Q?40TuGCSv2XQh1nzP4GeoV+4RuM2wq5+rcP7bP5lbA7k5eY6yKHCG/3zuBfjy?=
 =?us-ascii?Q?friAsI7svSQR1AX+b4y2peRC5s5TYxs/fK2xdXlqdg1Ft3pUov/dHLB7fSb6?=
 =?us-ascii?Q?eIIr/GDcODn9JfdmuhmcdFgzqeOH2DTQrYFpHwx7/hhLFOvSVAt5d/+tjWNa?=
 =?us-ascii?Q?ogXH/oYul1py1V0RZ7lHzpeDrjS7IpL/E7RkpdZIwmoBJMrzLb0JcSjtKmtg?=
 =?us-ascii?Q?Cy4uAxxNKmg5z/eT0ZFr8qj+aJv1RMhSWAdfFhZR5tBGSQDPjISYsOlq36/l?=
 =?us-ascii?Q?8pdYpLXi+ZJXl+mWpRbPEzrP7s4wXNw7rjDTJErW1rnAh8pTi7ktuTI7AGP1?=
 =?us-ascii?Q?7PZ1G6MXCrwtIPJ0VjUovVruDmL5FZ7Wf1XHyrYDK35KsO/+Eio9icc92C1q?=
 =?us-ascii?Q?CJEpjmW3uOJYC55GYrqE8504BV7iM5Rk/6zdMygg7LR65tqMJcg/1BHbAq4F?=
 =?us-ascii?Q?oxYi0qjPU90lbQOa8A1N3TQX+9M7oxTYPAw+lwfDD5emyKHJojEJvJJQh0PR?=
 =?us-ascii?Q?Il7qMZuPD+uYH4CqkbuaMbJBEKJGQ6UvchfZ8XRhiQ/2QaHc3Pxb62FjEJSj?=
 =?us-ascii?Q?7YNWN7lNP0GWnT7ZkWBht2upPypzvEbOhPBS20tbCFSQXAzk/RO7AlcH61cq?=
 =?us-ascii?Q?xXTQGgXGBhMo6lTZVsweLJ5yxdUn8nze52J92giSZmfun/odG/GZfU4Wjo1G?=
 =?us-ascii?Q?MtlSjExFf5XFTxBYaTcPHNa6cz2qXsxM8DAkE2X7yfGF5KCzEn/ffxOVilJ6?=
 =?us-ascii?Q?vzHCdT6z5peAi/Kb8wtmZWHPnfv416+WE4g2yVBR0ZzRJPGcwWNKvcwf639c?=
 =?us-ascii?Q?RYooFQEwXcPQ0ZHy8LY7erGkdw22KuCeOhQiB5DU6Dj6to/VWXLeSX77EVmq?=
 =?us-ascii?Q?lZN4i8vYqlD80KlFFxiPwGPKEToRuA0jBhRcQdzCJp9RSZkbTsKf0Eq1VqVW?=
 =?us-ascii?Q?8BvkGYaqdKItI284JG5pfrtrVR4/r5fVODjWn5u92KZ1PYwINpsWwQlm6kZ5?=
 =?us-ascii?Q?htuHx68NzmRVruVSopSlwikJwGxl6hFPi3N1Fxr0GBpQXgbv3yRwx6Lzy9Zw?=
 =?us-ascii?Q?tateSAfhXaSwZKM/MCj9P+YJbhj9aLkZtYHPSKeVI7eDNxQFB/rh7Plzcu5R?=
 =?us-ascii?Q?L76hWX/hZ/9j8AiqgfmVyPrXFNHWjsZZlKBwlfjwWw/B49727hb2yEHYkoLg?=
 =?us-ascii?Q?o5wXuAYE8LxNrcmymzfG7lnojnu4bcbviei6a5g/e+DRKEQyZbJWY5wSCg8h?=
 =?us-ascii?Q?JmLyOPg6SDTuhyDioAh1XQqjxrWjPuKY+/zE3ipS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2317c3-0144-4857-8f2e-08db8bfdfa81
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:25:15.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8474PM3VvFR1jh2hnEeLbHRFqUxLPxJTItH91GLjw6pcLGwNPKafohUscRGRFYrn5ERrdkm+zUP23WMXjeSgOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6940
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 09:18:41PM +0800, Zeng Guang wrote:
>When enabled Intel CPU feature Linear Address Space Separation (LASS),
>KVM emulator will take LASS violation check on every access to guest
>memory by a linear address.

When Intel Linear Address Space Separation (LASS) is enabled, the processor
applies a LASS violation check to every access to a linear address. To
align with hardware behavior, KVM needs to perform the same check in
instruction emulation.

>
>We defined a new function prototype in kvm_x86_ops for emulator to
>construct the interface to identify whether a LASS violation occurs.
>It can have further practical implementation according to vendor
>specific requirements.
>
>Emulator will use the passed (address, size) pair and instruction
>operation type (flags) to enforce LASS protection when KVM emulates
>instruction fetch, data access including implicit data access to a
>system data structure.

Define a new function in x86_emulator_ops to perform the LASS violation
check in KVM emulator. The function accepts an address and a size, which
delimit the memory access, and a flag, which provides extra information
about the access that is necessary for LASS violation checks, e.g., whether
the access is an instruction fetch or implicit access.

emulator_is_lass_violation() is just a placeholder. it will be wired up
to VMX/SVM implementation by a later patch.

(I think the commit message can also explain why the LASS violation
 check is added in the three functions, i.e., __linearize(),
 linear_read_system() and linear_write_system(), and why only in them)

>
>Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
> arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
> arch/x86/include/asm/kvm_host.h    |  3 +++
> arch/x86/kvm/emulate.c             | 11 +++++++++++
> arch/x86/kvm/kvm_emulate.h         |  2 ++
> arch/x86/kvm/x86.c                 | 10 ++++++++++
> 5 files changed, 28 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>index 13bc212cd4bc..a301f0a46381 100644
>--- a/arch/x86/include/asm/kvm-x86-ops.h
>+++ b/arch/x86/include/asm/kvm-x86-ops.h
>@@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
> KVM_X86_OP(msr_filter_changed)
> KVM_X86_OP(complete_emulated_msr)
> KVM_X86_OP(vcpu_deliver_sipi_vector)
>-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>+KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
>+KVM_X86_OP_OPTIONAL_RET0(is_lass_violation)

...

> 
> #undef KVM_X86_OP
> #undef KVM_X86_OP_OPTIONAL
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index fb9d1f2d6136..791f0dd48cd9 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1731,6 +1731,9 @@ struct kvm_x86_ops {
> 	 * Returns vCPU specific APICv inhibit reasons
> 	 */
> 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>+
>+	bool (*is_lass_violation)(struct kvm_vcpu *vcpu, unsigned long addr,
>+				  unsigned int size, unsigned int flags);

I may think we can just return false in emulator_is_lass_violation() and
fold this new kvm_x86_ops definition into its vmx implementation. This way
is more natural to me.

> };
> 
> struct kvm_x86_nested_ops {
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index 9b4b3ce6d52a..2289a4ad21be 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -742,6 +742,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 		}
> 		break;
> 	}
>+
>+	if (ctxt->ops->is_lass_violation(ctxt, *linear, size, flags))
>+		goto bad;
>+
> 	if (la & (insn_alignment(ctxt, size) - 1))
> 		return emulate_gp(ctxt, 0);
> 	return X86EMUL_CONTINUE;
>@@ -848,6 +852,9 @@ static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
> 			      void *data, unsigned size)
> {
>+	if (ctxt->ops->is_lass_violation(ctxt, linear, size, X86EMUL_F_IMPLICIT))
>+		return emulate_gp(ctxt, 0);
>+
> 	return ctxt->ops->read_std(ctxt, linear, data, size, &ctxt->exception, true);
> }
> 
>@@ -855,6 +862,10 @@ static int linear_write_system(struct x86_emulate_ctxt *ctxt,
> 			       ulong linear, void *data,
> 			       unsigned int size)
> {
>+	if (ctxt->ops->is_lass_violation(ctxt, linear, size,
>+					 X86EMUL_F_IMPLICIT | X86EMUL_F_FETCH))

s/X86EMUL_F_FETCH/X86EMUL_F_WRITE/
