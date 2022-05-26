Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6BF5353BC
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 21:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiEZTEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 15:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiEZTEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 15:04:01 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DAF2124D;
        Thu, 26 May 2022 12:03:59 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id a9so2025188pgv.12;
        Thu, 26 May 2022 12:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xUGVcsL4kPR/0PHZnrRKs09b0dp+ZDQDaBuuO5c2Xps=;
        b=DCOkPAxHPYJwNW4MaQev45USWA/3XLzycKW1h3itVvJAJWxCYRiywfFFjJxgrNpzmB
         Ei6uUteHyoaZGm565+Kx0S2MJU3+eEyJqltXAH4ssR2OxYa2NeRQwoOsmGooerZvh4LZ
         HeO7vEVl7FvU81NbfK5lLFS6g5rrFqYIEezHmM+XNsypq2G1zlj+b8Wey0G2ZEIJWEOk
         k3vp3kXpgeiy96M5YOM356bGGyctyMSVmtJMbRnyyTls1askkWkTk51rV8T/P7IyqShP
         v057n9BV7aJJGpFLS5FHjPDfEU9v2Igvi4noS8hgIZcPVNdqb/NtBBxV4nYhLELlupT8
         L94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xUGVcsL4kPR/0PHZnrRKs09b0dp+ZDQDaBuuO5c2Xps=;
        b=eWMdrYdaMeR+lCLVTDrusga5F5i/YXsbQumXbMOpp4lCaxt7zPrO76qeQfa1jVMh4b
         lQX2QiO9BNKCF8wLV64HaVbShIlRWEOMjeOK8unDuznW9qI+EUydmAKCbvf7zKjN04rN
         XcBXXGUcvTYHvqGsZTUqZBXG6/RsrmXf5Q3SuU1oWgxRKbphOWUezUPlGCWrxFmRcc7D
         nJQ+oBTogdbqd5G7j7DD7bfdsLxGfu6rC10Pwu/AkIaVJbqGG1frsWF+uHOl9uggjaUe
         V+vhyXXqWd6LavQWXTZX3UqPcLBKxZj7eUqQAQfogLiTrkJ/r4E6fFQwIKhZNCNHFm5Q
         SfUQ==
X-Gm-Message-State: AOAM530QzEgCmPzJxszeQb/GAc9PSTMUeKGtqI4OKUKcTc4bhjndHMHk
        lkY4qls2hjdgNyqB4Wmfi4oHVNUqm++iCw==
X-Google-Smtp-Source: ABdhPJzSfyclSLxn7sySbXNDZTz3NNDglAoFs2hv37qljVYZTpOrXj0EskTYHFM38v0mfU5sb4STBA==
X-Received: by 2002:a63:8448:0:b0:3fa:cc62:d51f with SMTP id k69-20020a638448000000b003facc62d51fmr9620860pgd.417.1653591838350;
        Thu, 26 May 2022 12:03:58 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id ck20-20020a17090afe1400b001e0a8ef9f84sm3722pjb.26.2022.05.26.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 12:03:57 -0700 (PDT)
Date:   Thu, 26 May 2022 12:03:55 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v6 003/104] KVM: Refactor CPU compatibility check on
 module initialiization
Message-ID: <20220526190355.GB3413287@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <75912816e498ddf62e7efb6a187d763c89e72f45.1651774250.git.isaku.yamahata@intel.com>
 <CAAhR5DGQ+btmAh9bs=_8c4cqH__4yk8R8C1ko1ZHUc0ZTjJuDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DGQ+btmAh9bs=_8c4cqH__4yk8R8C1ko1ZHUc0ZTjJuDw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 03:27:10PM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Thu, May 5, 2022 at 11:15 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Although non-x86 arch doesn't break as long as I inspected code, it's by
> > code inspection.  This should be reviewed by each arch maintainers.
> >
> > kvm_init() checks CPU compatibility by calling
> > kvm_arch_check_processor_compat() on all online CPUs.  Move the callback
> > to hardware_enable_nolock() and add hardware_enable_all() and
> > hardware_disable_all().
> > Add arch specific callback kvm_arch_post_hardware_enable_setup() for arch
> > to do arch specific initialization that required hardware_enable_all().
> 
> There's no reference to kvm_arch_post_hardware_enable_setup in this
> patch. Looks like it's introduced in a later patch in the series.
> 
> This patch might be clearer if the kvm_arch_post_hardware_enable_setup
> is introduced and used here. Otherwise, the commit log should be
> updated to make it clear that kvm_arch_post_hardware_enable_setup is
> introduced in a later patch in the series.
> 
> > This makes a room for TDX module to initialize on kvm module loading.  TDX
> > module requires all online cpu to enable VMX by VMXON.
> >
> > If kvm_arch_hardware_enable/disable() depend on (*) part, such dependency
> > must be called before kvm_init().  In fact kvm_intel() does.  Although
> > other arch doesn't as long as I checked as follows, it should be reviewed
> > by each arch maintainers.

Thank you for pointing it out. I moved the addition of
kvm_arch_post_hardware_enable_setup() to this patch. The related patch is as
follows.

The patch that actually uses kvm_arch_post_hardware_enable_setup() is
"011/104 KVM: TDX: Initialize TDX module when loading kvm_intel.ko".  It's
a bit far from this patch.  I intentionally positioned this patch early in
this series because this patch requires cross-arch review.

Thanks,

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1aead3921a16..55dd08cca5d2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+int kvm_arch_post_hardware_enable_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec365291c625..55b292fda733 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4883,8 +4883,13 @@ static void hardware_enable_nolock(void *junk)
 
 	cpumask_set_cpu(cpu, cpus_hardware_enabled);
 
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		goto out;
+
 	r = kvm_arch_hardware_enable();
 
+out:
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
@@ -5681,9 +5686,9 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
+__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	return 0;
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
@@ -5716,11 +5721,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			goto out_free_2;
-	}
+	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
+	r = hardware_enable_all();
+	if (r)
+		goto out_free_2;
+	/*
+	 * Arch specific initialization that requires to enable virtualization
+	 * feature.  e.g. TDX module initialization requires VMXON on all
+	 * present CPUs.
+	 */
+	kvm_arch_post_hardware_enable_setup(opaque);
+	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
