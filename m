Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0885EB664
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 02:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiI0AlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 20:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiI0Ak6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 20:40:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3E3A494;
        Mon, 26 Sep 2022 17:40:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p14so5190850pjd.3;
        Mon, 26 Sep 2022 17:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8xobog+QYukwZVnSxEr7+7WqxBnwEIa9rhAbHRvLuc0=;
        b=FTCMFRmQQyCukqL2hxWYCxKVenu9ShL50Yamg226yHwQtpyuDdPtGQPzXO/k1rYqWq
         kpc2VrBXq8xqNic4OqxT4fAyTdTUyb81ViwXcqIWHthuzOgp7A33k5MTIpiJ/mMQpPhA
         6eMBZccoaglWqBm+WdqkktjAdyy6SGAn4tCKEmQA3ZjpPfCL0FILKRgWRkoSRGCE4gC+
         7ldMIkIMU4dHHAJ7fORc8bubpbNKM9jjI4OFwNwoWsYZJUI7Zt9UDrxcCoeuS6xfmi1M
         tSOqrp6yZVxQEtcdRZdoPwXBp01Y9N3cE3zt0LabBjPooc0427RdfI08Clap3VSZQnxP
         xOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8xobog+QYukwZVnSxEr7+7WqxBnwEIa9rhAbHRvLuc0=;
        b=EKI2WSLXLJN1x/nzFgpdI80fPXEa45a3b/NZSvCaAAck0wDJjiuWtoOlDTtc7YqhgW
         gclrHCqawCZgC6QLHYPT/cHc6Uznsibh+XQNeGA86oqD6cuIakkn1YpMcjnnqotFr/Iw
         jHDQEI3thtS5eJ3qiDKPH6XPhh7avALOIu38MXs0QnhmbPtiH8PJLpc+N7FNejh/zdc+
         zByUWJHjwdxVweZLNEgQ9NSGXVBiS9aVbpicL9NexKSQe9DWI1X8APr8Ynbn18y97IUT
         YXC3uRum65/ahJOyMkp+c5fiiyB4Hm4A+yzq3gsWZ75P+H2xqAq+iZmYriFjd2LlDpEj
         e3wA==
X-Gm-Message-State: ACrzQf2ooMfY717WIAstsrOlmH0RiXgkbI3gJ3iZ46SryjunTGi+adU/
        yDJ4dtg8SwEu2XBPVpAjgZo=
X-Google-Smtp-Source: AMsMyM5ncLCON7H69CwN1h2mFJChlFCT/tOjvv+vDzOyTbAYe4LWup3DROUOLB0qK9ZqLDTMs+Q+/w==
X-Received: by 2002:a17:902:7e42:b0:178:489:86ac with SMTP id a2-20020a1709027e4200b00178048986acmr24950551pln.68.1664239256857;
        Mon, 26 Sep 2022 17:40:56 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a3b0e00b002009db534d1sm68572pjc.24.2022.09.26.17.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:40:56 -0700 (PDT)
Date:   Mon, 26 Sep 2022 17:40:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v5 27/30] RFC: KVM: powerpc: Move processor compatibility
 check to hardware setup
Message-ID: <20220927004054.GA1508394@ls.amr.corp.intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <574ca90fdaec0f37c197d9600d47d48a74f324bd.1663869838.git.isaku.yamahata@intel.com>
 <8735ci1sri.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8735ci1sri.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 04:58:41PM +1000,
Michael Ellerman <mpe@ellerman.id.au> wrote:

> isaku.yamahata@intel.com writes:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Move processor compatibility check from kvm_arch_processor_compat() into
>                                           ^ 
>                                           kvm_arch_check_processor_compat()
> 
> > kvm_arch_hardware_setup().  The check does model name comparison with a
> > global variable, cur_cpu_spec.  There is no point to check it at run time
> > on all processors.
> 
> A key detail I had to look up is that both kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() are called from kvm_init(), one after
> the other. But the latter is called on each CPU.
> 
> And because the powerpc implementation of kvm_arch_check_processor_compat()
> just checks a global, there's no need to call it on every CPU.
> 
> > kvmppc_core_check_processor_compat() checks the global variable.  There are
> > five implementation for it as follows.
> 
> There are three implementations not five.

Thanks. I'll update the commit message.

> >   arch/powerpc/include/asm/cputable.h: extern struct cpu_spec *cur_cpu_spec;
> >   arch/powerpc/kvm/book3s.c: return 0
> >   arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
> >   arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
> >                              strcmp(cur_cpu_spec->cpu_name, "e5500")
> >                              strcmp(cur_cpu_spec->cpu_name, "e6500")
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: Fabiano Rosas <farosas@linux.ibm.com>
> > ---
> >  arch/powerpc/kvm/powerpc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> > index 7b56d6ccfdfb..31dc4f231e9d 100644
> > --- a/arch/powerpc/kvm/powerpc.c
> > +++ b/arch/powerpc/kvm/powerpc.c
> > @@ -444,12 +444,12 @@ int kvm_arch_hardware_enable(void)
> >  
> >  int kvm_arch_hardware_setup(void *opaque)
> >  {
> > -	return 0;
> > +	return kvmppc_core_check_processor_compat();
> >  }
> >  
> >  int kvm_arch_check_processor_compat(void)
> >  {
> > -	return kvmppc_core_check_processor_compat();
> > +	return 0;
> >  }
> 
> The actual change seems OK. I gave it a quick test boot and ran some
> VMs, everything seems to work as before.
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

Thanks so much for testing. I'll remove RFC.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
