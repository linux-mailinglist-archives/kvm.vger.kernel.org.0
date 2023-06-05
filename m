Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5947231AF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjFEUql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjFEUqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:46:40 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E42BEE;
        Mon,  5 Jun 2023 13:46:38 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b02085bf8dso24234595ad.0;
        Mon, 05 Jun 2023 13:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685997998; x=1688589998;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H10ydjkwHBh+4jmL3RDjLQYBqYEliAcxEwG5Qm5tMak=;
        b=C8brdvnPPibsG2aEguia0jLzsHGh8ILFA1IgtC1vIPh8iMJM/ZLXhx7ko3jXat4EUy
         GG78uR4Oci4g/4c5Wg0hQrN7AigjDFzIatNnRymHTam81hkbjGhnC45N8KBnsIjcuoM5
         ft9dCdGw0KRESPgJpSklBuFchrpk5cInyaGZUUymlt+nVvWt8TbiePcr7+GrS7LpPIuq
         HZsBkdOCFwmLzkSF5cYq5hrxFTVMN9+VK1MyB8eMnO7O7tz4N35ailFLGLKgVGeoFgcy
         iNYlunBRJGe5dMJB8yMOHTbeM7N0hqpYQ5UoOZQwtKZQWeEKi3tuTaBjP2jTB/weGXnN
         mjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685997998; x=1688589998;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H10ydjkwHBh+4jmL3RDjLQYBqYEliAcxEwG5Qm5tMak=;
        b=GUPcPL+wZvevEDE/LBix0tUn6h1TcmaWCr0MhFm/qF9D0/HHznvzRD5LxgW2V3Cnm+
         EhUcByBUVZLlOj3ONYhfIOPBulqAFlwB+N4yiIdkjfyPHAX86wg62fW/KF7KdBpwmkrf
         l7aTZl/21nqmdVzOwgyT8KaMt6fAF3PapPnZDHZTPIC2KbeeNLWpJkM8yAtuyLYu8f+b
         V5LtpAl8wobJJpHFRn/eygID2bdnXUlao4VFkNul0tA1VtTVzlpRQbxjgiEYX0orSaW6
         59PTkP4Q2n9S1YPtlyxuOAbZr1yee2bCygytDMpDH7U/UFFuVsk88xnEBHZ0kV4Z9I6T
         L82Q==
X-Gm-Message-State: AC+VfDzIGWlrQgbl8Bk4QkkdffgYjIwBpckvgr1cLy0Bkr3GHZW2pWGd
        jSQw5rkdrNHFe3YS6UYJ1Mo=
X-Google-Smtp-Source: ACHHUZ6PxTX0JQKsnNOnXWwjq5/DI7YT0iURvet4qUbhMoA/qvkpype6dfpC4PfzKXtSrWwLbFAr/Q==
X-Received: by 2002:a17:903:41c7:b0:1ac:3e56:41b1 with SMTP id u7-20020a17090341c700b001ac3e5641b1mr64823ple.30.1685997997731;
        Mon, 05 Jun 2023 13:46:37 -0700 (PDT)
Received: from localhost ([2601:647:4600:51:cfd8:e566:eb63:a281])
        by smtp.gmail.com with ESMTPSA id c12-20020a170903234c00b001a52974700dsm7005549plh.174.2023.06.05.13.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:46:37 -0700 (PDT)
Date:   Mon, 5 Jun 2023 13:46:36 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Message-ID: <20230605204636.GA3346834@private.email.ne.jp>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
 <20230603092933.00004ada.zhi.wang.linux@gmail.com>
 <20230603180235.GM1234772@ls.amr.corp.intel.com>
 <20230605095129.00001b49.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605095129.00001b49.zhi.wang.linux@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 10:25:11AM +0800,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> > > > +
> > > >  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > >  {
> > > >  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > @@ -2003,10 +2044,12 @@ static void setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid, struct td_par
> > > >  	}
> > > >  }
> > > >  
> > > > -static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> > > > +static void setup_tdparams_cpuids(struct kvm *kvm,
> > > > +				  const struct tdsysinfo_struct *tdsysinfo,
> > > >  				  struct kvm_cpuid2 *cpuid,
> > > >  				  struct td_params *td_params)
> > > >  {
> > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > >  	int i;
> > > >  
> > > >  	/*
> > > > @@ -2014,6 +2057,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> > > >  	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
> > > >  	 * It's assumed that td_params was zeroed.
> > > >  	 */
> > > > +	kvm_tdx->cpuid_nent = 0;
> > > >  	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
> > > >  		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
> > > >  		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
> > > > @@ -2035,6 +2079,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> > > >  		value->ebx = entry->ebx & config->ebx;
> > > >  		value->ecx = entry->ecx & config->ecx;
> > > >  		value->edx = entry->edx & config->edx;
> > > > +
> > > > +		/* Remember the setting to check for KVM_SET_CPUID2. */
> > > > +		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
> > > > +		kvm_tdx->cpuid_nent++;
> > > >  	}
> > > >  }
> > > >  
> > > > @@ -2130,7 +2178,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > > >  	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> > > >  
> > > >  	setup_tdparams_eptp_controls(cpuid, td_params);
> > > > -	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
> > > > +	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
> > > >  	ret = setup_tdparams_xfam(cpuid, td_params);
> > > >  	if (ret)
> > > >  		return ret;
> > > > @@ -2332,6 +2380,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > > >  	if (cmd->flags)
> > > >  		return -EINVAL;
> > > >  
> > > > +	kvm_tdx->cpuid = kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> > > > +				 GFP_KERNEL);
> > > > +	if (!kvm_tdx->cpuid)
> > > > +		return -ENOMEM;
> > > > +
> > > >  	init_vm = kzalloc(sizeof(*init_vm) +
> > > >  			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> > > >  			  GFP_KERNEL);
> > > 
> > > kfree(kvm_tdx->cpuid) is required in the error handling path of tdx_td_init().
> > 
> > 
> > No need. tdx_vm_free() frees it. Not here.
> 
> From a perspective of correctness, Yes. But there seems different kinds of
> strategies of function error handling path going on in this patch series.
> Taking __tdx_td_init() as an example, tdx_vm_free() is immediately called
> in its error handling path. But, the error handling below the allocation
> of cpuid will be deferred to the late VM teardown path in this patch. I am
> confused of the strategy of common error handling path, what is the
> preferred error handling strategy? Deferring or immediate handling?
> 
> Second, it is not graceful to defer the error handling to the teardown
> path all the time even they seem work: 1) Readability. It looks like a
> problematic error handling at a first glance. 2) Error handling path and
> teardown path are for different purposes. Separating the concerns brings
> clearer code organization and better maintainability. 3) Testability,
> thinking about an error injection test for tdx_td_init(). Un-freed
> kvm_tdx->cpuid will look like a memory leaking in this case and needs to
> be noted as "free is in another function". It just makes the case more
> complicated.
> 
> Third, I believe a static code scanner will complain about it.

I noticed that it results in memory leak when KVM_TDX_INIT_VM after
KVM_TDX_INIT_VM error. So I come up with the following to fix it with immediate
handling.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d392262d8605..55cf07a72332 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3549,16 +3549,21 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
        if (cmd->flags)
                return -EINVAL;

+       WARN_ON_ONCE(kvm_tdx->cpuid);
        kvm_tdx->cpuid = kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
                                 GFP_KERNEL);
-       if (!kvm_tdx->cpuid)
-               return -ENOMEM;
+       if (!kvm_tdx->cpuid) {
+               ret = -ENOMEM;
+               goto out;
+       }

        init_vm = kzalloc(sizeof(*init_vm) +
                          sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
                          GFP_KERNEL);
-       if (!init_vm)
-               return -ENOMEM;
+       if (!init_vm) {
+               ret = -ENOMEM;
+               goto out;
+       }
        if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
                ret = -EFAULT;
                goto out;
@@ -3604,6 +3609,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)

 out:
        /* kfree() accepts NULL. */
+       if (ret) {
+               kfree(kvm_tdx->cpuid);
+               kvm_tdx->cpuid = NULL;
+               kvm_tdx->cpuid_nent = 0;
+       }
        kfree(init_vm);
        kfree(td_params);
        return ret;


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
