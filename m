Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B2743927
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjF3KPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjF3KOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:14:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736F310F
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 03:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688120089; x=1719656089;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vt6uOLmJKuZ6Ed0yl/+2utQx0EKkDddEKUfc/qpG1i0=;
  b=nhhYC0serltRBEqzvslrHpmnxUrSvTOAVm4gTIbJtHHrhNsRaN+cIeyw
   gxfDFkLY5QxC30t8UVM/o/UaA0V7bo76mt9iOuThS+JcFnsEfcu+AmDT+
   tYymREdqvzHN8qFBOD63nZKV1DeaisD9tvkMYonoOCgxSLZbkXNRXwwed
   tNR7fT/+H8tCCngNH8TyyRK8Rc0TEqiZv5nvlIQ8fhQRzbEE7Ym/mUXO6
   uivyASRBaTx36ApobOdm3jLaTAgB786+i8s3cVlH/vMhzFvwjtaW9gflp
   uDUXRB5M/H7gRmuCO7vsc5EcEZWr69UfZ/Yx0/9Gvg/PXLNHBN4NJx6k2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="359841916"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="359841916"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:14:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="694970901"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="694970901"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Jun 2023 03:14:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:14:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:14:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 03:14:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 03:14:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBeoo8n+37/bfThsEOjXeGYkh6OWCP3QCptPj/cva0cNDGq8Mw6fNs3O+ghJeVwWa7xI0bMM9PoG7ikAF6Y/W4+Fu1xvhJ/glHQV0SsxPbC9hd7XtaGlyNHvZUThJCoAgUmM81+NkFUYHi1TgcU9swOpgGk442HUQN/tNw79mp5O3MB+73AiupgZA939HVibLAu7Gm2dfVfYu6WhfFyV/ka421XPseiTc2E8GRmI0BMIO1gUYZyriQjyU69bj4nZe5TbmcojPr1kQDWzRnPh+hJeXHeXBfNR4qiwdQU0Q5iNbtw2+3DEjU5X6wKyKEV4AyEO7EQvvId/Uqj7umv1Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2+kKAxu0Q+6Wy5iZN30pxUSult7OlyDLBNL4m9NBHs=;
 b=JLkdN+ZIEDHDjAejVGdOqUYOUG4DROpvuHfRpelFG1T0IZM3blBVOafL0ikMd60SJ5H/Rfv2uLGo424iTAe5B4xJzI7C2FQHKiQ/SlwPEF0Y8pLbj//moMSHTbga68Fj45RzGxUMcJD2keAFkbQmAIjtjqOD2NKtMm9FWjDNViPgHy2FD99pAG/SOel5L/wX6wJs+bXFDi9E2whsg5h/+2g2Yt6LS31a992oXMGz2rCg0OUEQuDJ5cMaQkMHL2/saaWX//5qQmE9IyuOLmDtUBb7jL9vQrZZG0NYTfzxh6YdNooHNPPJTQW2xq70UFddtCGk3RPIyP2LBp34uVho3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM6PR11MB4658.namprd11.prod.outlook.com (2603:10b6:5:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 10:14:42 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 10:14:42 +0000
Date:   Fri, 30 Jun 2023 18:14:31 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Qi Ai <aiqi.i7@bytedance.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>, <fengzhimin@bytedance.com>,
        <cenjiahui@bytedance.com>, <fangying.tommy@bytedance.com>,
        <dengqiao.joey@bytedance.com>
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
Message-ID: <ZJ6rBwy9p5bbdWrs@chao-email>
References: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM6PR11MB4658:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb341b8-9671-4979-a11e-08db7952d1cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMzuPSBNS7kM9UpUrk/WJVyNE2gPhWzUwq1MjSyaT2RQ9Gm212g2ib1qtL762O5UH+u3JhVvhPY8WIKsIjahIAQghq9hhCLK/ipYbq47gns2zMCLvmuSeFzCRFDVaksJ8r9nwDVLzqnoAfWpgtSBZX1RuEH2wFLdYdYz6PTjhzy6gGt9JqitHJ/15BMTV+P6+O3hZ0MfvBFw0ODJTAR6hRjPZkDFijH/6QT82Xu1yjKNRDSmbvDYyUlZcQdT/h75zqjkaAn50mKY298mGz8/QCkQ0SgGjJqRTufMRjHhndAACTfEdb9MZwSfO7ERNk9HyLR+ATuVQ62oNJnJ9+gGLOamCANzX9WKJ5LlLxFIVZEB47RQyFypQ6yBMOKlrma0cFgy2nJfDmFm5OSdEc0IJJT8Qv44C8cafrSAlZjCA9GEqpdBw5xKaujsXgOb75vOOaRZYxG7fUhsxbokbZBPKQowPDRWkcolpktaAAW7tw3q1Y1P8THggTH9Et+rJiOIX1MTSdyW86tnDMX0196IXW9Kvcd0L9sz0YvGv6x4d1BTmK7uas4MJDTDL1nR2r1V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199021)(66556008)(6506007)(66476007)(82960400001)(86362001)(44832011)(5660300002)(316002)(7416002)(41300700001)(6916009)(8936002)(4326008)(38100700002)(66946007)(33716001)(8676002)(6486002)(9686003)(6512007)(186003)(2906002)(478600001)(26005)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JAZgR6UTXCaAjhDSvynL85ilCw1Mcv1MhD3sdO93DZAYxifYhilik+keXAI?=
 =?us-ascii?Q?CgaMatYSpL16mQB92ABurK+ub1Y9C1cZueTAVej6aKp0WKrjU58TYhpTndTu?=
 =?us-ascii?Q?iAPZegePfduhCyVmGRr7EaGM5iRwJ93BiHwf4AuVAtmc5+arqus1T6NZJsn1?=
 =?us-ascii?Q?CMY0VQpcaLH5qVLOWACv7jitfmVBEg+Qk+WeKnmD/MJH+jiW6UnoZ+UEgGwz?=
 =?us-ascii?Q?2bYpEYjm7dAkKKP7YYVzXR0g/0RcBWta2MCAGZ8gZDTjOR7mlIFdQGclUls7?=
 =?us-ascii?Q?yLX/pSTJeCQDeJnWaZl14ujenSwhnMXCi458hH53QMCBrZj+vJ+WRzOLgZAY?=
 =?us-ascii?Q?WySCFTADKbO36i6dARh1aQexsubGY6EeLVOkS8v2sLGRs46JArPXopHIQJ9F?=
 =?us-ascii?Q?QXFvuINMmsdxZkzl9HI5Wb9HLXo+Fnfek1np3jqUP2kUL492IvbvP5eTHLtB?=
 =?us-ascii?Q?9po/pZ8/HU03Jy+D+9hO79chSWfDvbXiWQJ9LMJM3cFrpcubVaVSsOrTPCfe?=
 =?us-ascii?Q?ZlLQ5/rLsOC7RVGKVADObAkibvPdwhenod8qOVYQ8x08S+uLZjzsIyUwMS9X?=
 =?us-ascii?Q?5rBp/mKjrwCmlsQoUQvNSiHN+j/xxlAKgrx95CgjlMjqhvYab8u6iqPMrAVQ?=
 =?us-ascii?Q?8wzUSf60/SkTFxAMuvTk0eGh6qA5z3gna68rIq0g2c33JjNKnW6MWekR6lgP?=
 =?us-ascii?Q?hzKxz4WLVe8pkgXcE89gKTzRJifQwHB2AClTWUfpWM2Q/8LwulfVV2T8Hzgv?=
 =?us-ascii?Q?wnrmjVo+eMrwS16ZzUEWv4pwND6lS3pGYFRCMdnEmWRnjd3CskmGVf3+d4ty?=
 =?us-ascii?Q?OD7GDewX70wnpp65pkpV5dapqQUxitPMgpT1jqVuIUQnaq6MBx+aYBN9Rgpz?=
 =?us-ascii?Q?9k0nHygQMj2HD76vZhBELZa3EL3KZE4WNlMAwPKp/JD612Yz5WHpuq+wR+21?=
 =?us-ascii?Q?KPKdNuD46SkN4QB2BXsSk+knYP1c2QWoUZO7SbRp9L9B3C1090eQodqdy+i3?=
 =?us-ascii?Q?qXB8BKAoM3ulpvSOaofCTELFbzJqUrHGVfi1Q76iJPwTMhbX/ibNAWtfEBOo?=
 =?us-ascii?Q?GJlAdNQ+FRfXD5ZT+CzkPmHVmp6vqqV+kZU0h+DO5jtNCJF0gjX5YCWHXmdg?=
 =?us-ascii?Q?UYigdtf4EjRsSMRRM0FdoAQnJsn9dW1LAR5t614OvRcwlV33g2+ZRdTNOi2n?=
 =?us-ascii?Q?ZxAGBf7yqKuPmf+i/dWT2Dh/AQ249T/clINN1dJRuGY7IB+ry0Q/bZ8eZefi?=
 =?us-ascii?Q?Pg0PU5Iy5GBQryfAvxW6WM4ZY5Fv04kD7Rd3796BQ7+FDYpXQBAcQ3T5Y8iE?=
 =?us-ascii?Q?jydi4hx3pPx/tELHw8oJ6/TBoW00l18JBfL7CWLhENKuxuUUzEAnkELpKZlQ?=
 =?us-ascii?Q?/yyST/9P+c8AYZRgax38LVXtg+fLn74/vHmKbahPUZTX/8m6zUoNTzG1vqoM?=
 =?us-ascii?Q?uOVyzpvCkA/zNe66Klcf2F9fdehATBrgIcP96Zw15fLc9wwz3tkOijug8e7C?=
 =?us-ascii?Q?cnhtVsolcE4TyvgrMkzyYg3zDjM3KHcr3tBHQHURp9o6P4EpOg5p1xcN16ui?=
 =?us-ascii?Q?NJfHUFIfojm8pLRt4YOw3LM9gN/fppZiVkvQNyHh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb341b8-9671-4979-a11e-08db7952d1cc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 10:14:41.8709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwKD+OCpEQsfERQHpHeaetwKXU5Nz9/06YvEAsoEqQne47eU/8KY9xps4IwdSYuKBCjglkdWkP0Tp0MVdYokDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4658
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 03:26:12PM +0800, Qi Ai wrote:
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> 	 * Returns vCPU specific APICv inhibit reasons
> 	 */
> 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>+
>+	void (*clear_hlt)(struct kvm_vcpu *vcpu);

add this new ops to arch/x86/include/asm/kvm-x86-ops.h, and declare it
optional, i.e.,

KVM_X86_OP_OPTIONAL(...)


> };
> 
> struct kvm_x86_nested_ops {
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 44fb619803b8..11c2fde1ad98 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8266,6 +8266,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.complete_emulated_msr = kvm_complete_insn_gp,
> 
> 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>+
>+	.clear_hlt = vmx_clear_hlt,
> };
> 
> static unsigned int vmx_handle_intel_pt_intr(void)
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 7f70207e8689..21360f5ed006 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -11258,6 +11258,12 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> 	vcpu->arch.exception_vmexit.pending = false;
> 
> 	kvm_make_request(KVM_REQ_EVENT, vcpu);
>+
>+	if (kvm_x86_ops.clear_hlt) {
>+		if (kvm_vcpu_is_bsp(vcpu) && regs->rip == 0xfff0 &&

it is weird this applies to BSP only.

>+				!is_protmode(vcpu))
>+			kvm_x86_ops.clear_hlt(vcpu);

Use static_call_cond(kvm_x86_clear_hlt)(vcpu) instead.

It looks incorrect that we add this side-effect heuristically here. I
am wondering if we can link vcpu->arch.mp_state to VMCS activity state,
i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
sets VMCS activity state to active.

>+	}
> }
> 
> int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>-- 
>2.20.1
>
