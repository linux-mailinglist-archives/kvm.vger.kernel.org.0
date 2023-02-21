Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9907569DB2A
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbjBUH03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjBUH01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:26:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31C25B8D
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 23:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676964374; x=1708500374;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FBO5wXdrqkkhAJ4e+qH++0JjWPeGgBCsJJj8yqEccFs=;
  b=eeMrZHhKjtjABzBCMyiuP9GGxVPxi+XmOFHQDz+vJzU4C65VWlMm0yVZ
   M2XmElD+2FGqSQs4Gpat9661rToKslShzNZxqLbtTaHECCHi7GgODD1XM
   WdxfVG/WN/qC33M+tYCLX5LN7XTs2X37Kml2+Zmc0BNVmb6Mio83lSAxv
   YRG5itaUmRru7sNN7Tat3npiogr7jA7UwQD+NUL7F4BdgWl9TJdL78N+J
   k41jZK46N/FfQiXyI6WVOPqX4DTtQZcFvM1aB1EHYmLlFUFdESlZM6RQD
   Us++ND5plwwdZ6BzvgUW6xF0kRgUoqtSyH57c+pezTpUpn0Bjdr5Mxvz9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="332572689"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="332572689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 23:26:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="701909813"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="701909813"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 20 Feb 2023 23:26:10 -0800
Message-ID: <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Tue, 21 Feb 2023 15:26:09 +0800
In-Reply-To: <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-10-robert.hu@linux.intel.com>
         <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-21 at 13:47 +0800, Binbin Wu wrote:
> On 2/9/2023 10:40 AM, Robert Hoo wrote:
> > LAM feature is enumerated by (EAX=07H, ECX=01H):EAX.LAM[bit26].
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index b14653b61470..79f45cbe587e 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
> >   
> >   	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> >   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
> > F(AMX_FP16) |
> > -		F(AVX_IFMA)
> > +		F(AVX_IFMA) | F(LAM)
> 
> Do we allow to expose the LAM capability to guest when host kernel 
> disabled LAM feature (e.g. via clearcpuid)?

No
> 
> May be it should be handled similarly as LA57.
> 
You mean expose LAM to guest based on HW capability rather than host
status?
Why is LA57 exposure like this? unlike most features.

Without explicit rationality, I would tend to follow most conventions.


