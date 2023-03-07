Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE76AE950
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCGRWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 12:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjCGRW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 12:22:26 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AC1D52E
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 09:17:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id a9-20020a170902b58900b0019e2eafafddso7954147pls.7
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678209477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQbU304qvSe6nuiEdh3ek4tMw5wjustEnfRjLs3CfHM=;
        b=j+aMVBky7KGuSLjcrRldCBoPalyFGKtwLYUzNYdAPt3sGxrfr7whsHi+EOY3ovdrih
         fcbrsz+5WW9wXg9ZmX/TgxhOiMrNneN2O3Ta1NQU2+mmWdX7l7BoV2V8MOKwIGrAkOrp
         BYo0ZcOhBviE0jiUuBOmk07QuXlHTW/u1y1pYDIqHmJ44bP1e3IeiMDDqMKXyNRjWpeX
         d7TkFgTvceOtLjiwyAtUbqNWz1DkZHjZaC2U688CBRYhR4WNI2P8KEzlrHuSVPwY8sH+
         Pr3VymEjZYKWrTK17O95PvhD591awdOlK3F+EWPFM1sWmZbheOi3805hBnwFLN9eN6xo
         KGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQbU304qvSe6nuiEdh3ek4tMw5wjustEnfRjLs3CfHM=;
        b=t2n11nIsWGLdbc1UZksO9i5hDAAd701PvXuBIiFErGTk6OTfmOGdwaeRScaKeD+Dnq
         b2MTb+Ha8ISDwJu2+GIZre9BFR+DFVqeRTypHc3tbf5+RLB9yLr789V0839O4LlTOXdz
         UZrxicwmJK44nvaGzhyDKlcxRm2ycfM8ojz/1aA2ItzKeUuNXv4zUFnwXPmKMCptjMoH
         WigWWbHtDtnUImWxi8b1W4GFHNrkZ/BN5Xq7GNpLBPCUBTYHuks+SLuVTFNzeBrKuQoY
         ATYJWCozTeKVuM4h21vtdthIJ0aXTLcT7nH2EaRtQzvGK+DGcQoBBARL2QiHpUEQ+3fc
         ahfw==
X-Gm-Message-State: AO0yUKWESKd6AT2HIAVvn7+yp0mKJeZnPC3Prikx4lGJ91x8rCgD6UbD
        uxjPjlPBKHV7790dmeERnp2o45TlHqw=
X-Google-Smtp-Source: AK7set8sR8ySb9lpmNR1FMTrx/uaJ4kn2aKYyg7bzNnvLBuFScEEfqZhvbQg/F1tThOSaIDmSJDvM3qvYmo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3246:b0:19c:9037:d742 with SMTP id
 ji6-20020a170903324600b0019c9037d742mr6229067plb.1.1678209477326; Tue, 07 Mar
 2023 09:17:57 -0800 (PST)
Date:   Tue, 7 Mar 2023 09:17:55 -0800
In-Reply-To: <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
Mime-Version: 1.0
References: <20230301105438.599196-1-kai.huang@intel.com> <ZAA1+EMTIkBJvdZF@gao-cwp>
 <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
Message-ID: <ZAdxNgv0M6P63odE@google.com>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023, Huang, Kai wrote:
> On Thu, 2023-03-02 at 13:36 +0800, Gao, Chao wrote:
> > On Wed, Mar 01, 2023 at 11:54:38PM +1300, Kai Huang wrote:
> > > Make setup_vmcs_config() preemption disabled so it always performs on
> > > the same local cpu.
> > > 
> > > During module loading time, KVM intends to call setup_vmcs_config() to
> > > set up the global VMCS configurations on _one_ cpu in hardware_setup(),

That may have been the very original intention, but I don't think it has been the
true intention for a very long time.

> > > Change the existing setup_vmcs_config() to __setup_vmcs_config() and
> > > call the latter directly in the compatibility check code path.  Change
> > > setup_vmcs_config() to call __setup_vmcs_config() with preemption
> > > disabled so __setup_vmcs_config() is always done on the same cpu.
> > 
> > Maybe you can simply disable preemption in hardware_setup() although I
> > don't have a strong preference.
> > 
> > nested_vmx_setup_ctls_msrs() also reads some MSRs and sets up part of
> > vmcs_conf, should it be called on the same CPU as setup_vmcs_config()?
> 
> Yes I think so.  I missed this :)
> 
> Not sure whether there are other similar places too even outside of
> hardware_setup().
> 
> But compatibility check only checks things calculated via setup_vmcs_config()
> and nested_vmx_setup_ctls_msrs(), so I think it's fair to only put
> hardware_setup() inside preemption disabled.

Disabling preemption across hardware_setup() isn't feasible as there are a number
of allocations that might sleep.  But disabling preemption isn't necessary to
ensure setup runs on one CPU, that only requires disabling _migration_.  So _if_
we want to handle this in the kernel, we could simply do:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 541982de5762..9126fdf02649 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9470,7 +9470,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
        int r;
 
        mutex_lock(&vendor_module_lock);
+       migrate_disable();
        r = __kvm_x86_vendor_init(ops);
+       migrate_enable();
        mutex_unlock(&vendor_module_lock);
 
        return r;


But I'm not convinced we should handle this in the kernel.  Many of the checks,
especially in SVM, query boot_cpu_has(), not this_cpu_has(), i.e. to truly perform
setup on a single CPU, all of those would need to be converted to this_cpu_has().

Some of those boot_cpu_has() calls should be changed regardless of whether or not
migration is disabled, e.g. kvm_is_svm_supported() is arguably straight up buggy
due to cpu_has_svm() checking the boot CPU (I'll fix that by adding a patch after
open coding cpu_has_svm() into kvm_is_svm_supported()[*]).

But things like kvm_timer_init() should NOT be blindlgly converted to this_cpu_has(),
because the teardown path needs to mirror the setup path, e.g. if KVM ended up
running on frankenstein hardware where not all CPUs have a constant TSC, KVM could
leave a callback dangling and hose the kernel.  Obviously such hardware wouldn't
correctly run VMs, but crashing the kernel is a touch worse than KVM not working
correctly.

I'm not totally against converting to this_cpu_has() for the setup, as it would be
more intuitive in a lot of ways.  But, I don't think pinning the task actually
hardens KVM in a meaningful way.  If there are any divergences between CPUs, then
either KVM will notice before running VMs, e.g. the VMCS sanity checks, or KVM will
never notice, e.g. the myriad runtime paths that check boot_cpu_has() (or variants
thereof) without sanity checking across CPUs.  And if userspace _really_ wants to
have guarantees about how setup is performed, e.g. for repeatable, deterministic
behavior, then userspace should force loading of KVM to be done on CPU0.

So my vote is to leave things as-is (modulo the cpu_has_svm() mess).  But maybe add
documentation to explain the caveats about loading KVM, and how userspace can
mitigate those caveats?

[*] https://lore.kernel.org/all/20221201232655.290720-14-seanjc@google.com
