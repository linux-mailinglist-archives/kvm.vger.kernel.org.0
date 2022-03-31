Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACFD4EE1C3
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbiCaTgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiCaTgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:36:04 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE7A1DFDF9
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:34:17 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id b130so556893pga.13
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6TjwPLirVvtK8s34uSN7CHWiKNF87Nh8s5orS/FRtx8=;
        b=GOC8fHhteIOeaRunNywEvdfMNb1ooFQiSRvnOg2z4CcmESdOkeohBxTryjRk+SUpAj
         ygNF3WSdBsHOIhmEoKxA/8m4C/0kJ4cAxYi4R8JeYbriN7MpQbkAQT9z4ZNMHZ1ZPci+
         yb13s2X8seQjoLHSgTlV5oIo79vIuPhlvFZV34JXWeuQSlVcLG4xKKOkm77ICCRf1z4G
         WjdQRlY+O/ksqcXUUqJQ0zRf25mI+adyZwG8jIzSu+ESPr5hW32AAPzqYIaPzbO5EG5g
         a9eDN++W6Czb+iPVI3bIKw4qR+kVLaMdHxb8TBV0h9jFtbTOOjWrQiQJc58rKtkrrA/U
         cDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6TjwPLirVvtK8s34uSN7CHWiKNF87Nh8s5orS/FRtx8=;
        b=DYtUOgK5qHRpEue10h9JVoCkEY0t/iwR8C3Nftoy0XBo4ycTlca+GJAVQ9ohIt7fNV
         YsO2wsJWC0VsoIEg33vNvilT1q6gjc3Ek5vzlAHy7kkhKYW+f8IC7c6sLM0rgRjLcavf
         akfLMVlE3dckpOwGkqB+dWluHC/M9jz9jnz3DBXoMuOdzKX9nYscIKwDPQUABVmMWS0z
         I5pDTcVb7SjQ4ABAMFYGMq4FyelCufsGL4KBmfBAknHeksW+PtbKTiacPamHvxXXxH2f
         5rG3cVpkmiPv8Wgo9C1cJaZqNalzGTeAY1tgi/qoDRZcqs+2vpZQDZ0HB4ke8zWoACn5
         GNWA==
X-Gm-Message-State: AOAM532VqbsboOdXBbzwky0JkAQOg1LGrTgcys35xiCmRwfVJQYTzvZx
        IQkstNzQtd8qkD5q3jDIJhAA1w==
X-Google-Smtp-Source: ABdhPJyGmSFKtQ59aaeSguxrTwSpnnOjjUfffGxGRGJ3k0sKjLP0XssXOSa6DzDjWlXMtiwXCoRACg==
X-Received: by 2002:a05:6a00:996:b0:4fa:7cf8:6cdb with SMTP id u22-20020a056a00099600b004fa7cf86cdbmr7074785pfg.71.1648755256480;
        Thu, 31 Mar 2022 12:34:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 3-20020a630003000000b003828fc1455esm134681pga.60.2022.03.31.12.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:34:15 -0700 (PDT)
Date:   Thu, 31 Mar 2022 19:34:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <YkYCNF3l62IxpmAD@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
 <20220314194513.GD1964605@ls.amr.corp.intel.com>
 <YkTvw5OXTTFf7j4y@google.com>
 <20220331170303.GA2179440@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331170303.GA2179440@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Chao Gao

On Thu, Mar 31, 2022, Isaku Yamahata wrote:
> On Thu, Mar 31, 2022 at 12:03:15AM +0000, Sean Christopherson <seanjc@google.com> wrote:
> > On Mon, Mar 14, 2022, Isaku Yamahata wrote:
> > > - VMXON on all pCPUs: The TDX module initialization requires to enable VMX
> > > (VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
> > > guest does it.  It naturally fits with the TDX module initialization at creating
> > > first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.
> > 
> > That's a solvable problem, though making it work without exporting hardware_enable_all()
> > could get messy.
> 
> Could you please explain any reason why it's bad idea to export it?

I'd really prefer to keep the hardware enable/disable logic internal to kvm_main.c
so that all architectures share a common flow, and so that kvm_main.c is the sole
owner.  I'm worried that exposing the helper will lead to other arch/vendor usage,
and that will end up with what is effectively duplicate flows.  Deduplicating arch
code into generic KVM is usually very difficult.

This might also be a good opportunity to make KVM slightly more robust.  Ooh, and
we can kill two birds with one stone.  There's an in-flight series to add compatibility
checks to hotplug[*].  But rather than special case hotplug, what if we instead do
hardware enable/disable during module load, and move the compatibility check into
the hardware_enable path?  That fixes the hotplug issue, gives TDX a window for running
post-VMXON code in kvm_init(), and makes the broadcast IPI less wasteful on architectures
that don't have compatiblity checks.

I'm thinking something like this, maybe as a modificatyion to patch 6 in Chao's
series, or more likely as a patch 7 so that the hotplug compat checks still get
in even if the early hardware enable doesn't work on all architectures for some
reason.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69c318fdff61..c6572a056072 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4838,8 +4838,13 @@ static void hardware_enable_nolock(void *junk)

        cpumask_set_cpu(cpu, cpus_hardware_enabled);

+       r = kvm_arch_check_processor_compat();
+       if (r)
+               goto out;
+
        r = kvm_arch_hardware_enable();

+out:
        if (r) {
                cpumask_clear_cpu(cpu, cpus_hardware_enabled);
                atomic_inc(&hardware_enable_failed);
@@ -5636,18 +5641,6 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif

-struct kvm_cpu_compat_check {
-       void *opaque;
-       int *ret;
-};
-
-static void check_processor_compat(void *data)
-{
-       struct kvm_cpu_compat_check *c = data;
-
-       *c->ret = kvm_arch_check_processor_compat(c->opaque);
-}
-
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
                  struct module *module)
 {
@@ -5679,13 +5672,13 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
        if (r < 0)
                goto out_free_1;

-       c.ret = &r;
-       c.opaque = opaque;
-       for_each_online_cpu(cpu) {
-               smp_call_function_single(cpu, check_processor_compat, &c, 1);
-               if (r < 0)
-                       goto out_free_2;
-       }
+       r = hardware_enable_all();
+       if (r)
+               goto out_free_2;
+
+       kvm_arch_post_hardware_enable_setup();
+
+       hardware_disable_all();

        r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
                                      kvm_starting_cpu, kvm_dying_cpu);

[*] https://lore.kernel.org/all/20211227081515.2088920-7-chao.gao@intel.com
