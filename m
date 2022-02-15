Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E6E4B60E2
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 03:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiBOCS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 21:18:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiBOCSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 21:18:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A690C2C12F
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 18:18:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso1113837pjh.0
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 18:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LE5Ci//amagXAhH1w3Y+8mfr5LN0dnFBZ6FzMdZav/I=;
        b=QOCNe6KPTBbSfdFESoYihjYD98fQcmBKijavrQWBSjGhw8yO9dTAPdjqxu2qH+t1tX
         S1l05G3aQbE4lDTn/s5F8/Y6mrn5JA2XNvNKiH+TNZSKde0ry126WnBbdSYmfvRtdxSo
         nA+MlC61eucaniKvfo4vZVpAFxYrS0q90oyZ8UgW5yPzPggFXylEhdi7p4AwMFrXrxTB
         /qGAnc/dLC6qqbUqgdmbyzs4YbHVy1vXzMl4jwSquK1K9x/wTICfO0hG5BJNkZPlU+Qf
         G4U62UTnfXqgJ92wEak5Sp/Wvhe26YyhCz2/aaqJnS+HS1CQMrtmMXXW1kcb3i/XscpI
         PHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LE5Ci//amagXAhH1w3Y+8mfr5LN0dnFBZ6FzMdZav/I=;
        b=ykJ1qt3JZKKXBITWVE/kwOeISGK7L2Rb9jtQfqjs0yE8d+knbwqhflYMmVKVoxlPh/
         S5CL8EX66IxDQX0i6ab24iH6iLGAPjVZWTcXuqL8Bq4OLoA5U58NhTLgkhZYqujShaWW
         QyEUfA0ivi02Qvnype6xX20Kfz/waqNbu+Z5KAaG8OlF/nQ9rseo0+OFBThEaqMYAiL/
         8PTt+sCfxPrB6w7aWyil9vEnugH7KACSeLqLS5roqR9fm1dq25XhkPd6qk5oIyg1n+dI
         bTozxZ5W/bFNh1Mny95dGsbf4sk0lskv5bmb2FH7ZoxjRGnqxWYyCaOk9rY/AUmAtKsA
         A0Tg==
X-Gm-Message-State: AOAM531xyKCoORZ8tswG9xXmKy3mu2xkF1+lcckhY4xTgD+NaPRSqARv
        JVydF/95lrPA7/gvKCw/Ttzucw==
X-Google-Smtp-Source: ABdhPJx0/vQ1gYNmhES0TE6FuQAm+p7C0I+GWZ948BuCn3y0thsysZQHcGWGvJKcCPwBHgT8F7P+MA==
X-Received: by 2002:a17:902:6b4a:: with SMTP id g10mr1862546plt.57.1644891525942;
        Mon, 14 Feb 2022 18:18:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m20sm38713234pfk.215.2022.02.14.18.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 18:18:45 -0800 (PST)
Date:   Tue, 15 Feb 2022 02:18:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, ssouhlal@freebsd.org,
        hikalium@chromium.org, senozhatsky@chromium.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Romanov <romanton@google.com>
Subject: Re: [PATCH] kvm,x86: Use the refined tsc rate for the guest tsc.
Message-ID: <YgsNgdYYMsp0uI1i@google.com>
References: <20210803075914.3070477-1-suleiman@google.com>
 <YQ1hOJNMnD6gCRjD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ1hOJNMnD6gCRjD@google.com>
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

+Anton

On Fri, Aug 06, 2021, Sean Christopherson wrote:
> IIUC, this "fixes" a race where KVM is initialized before the second call to
> tsc_refine_calibration_work() completes.  Fixes in quotes because it doesn't
> actually fix the race, it just papers over the problem to get the desired behavior.
> If the race can't be truly fixed, the changelog should explain why it can't be
> fixed, otherwise fudging our way around the race is not justifiable.
> 
> Ideally, we would find a way to fix the race, e.g. by ensuring KVM can't load or
> by stalling KVM initialization until refinement completes (or fails).  tsc_khz is
> consumed by KVM in multiple paths, and initializing KVM before tsc_khz calibration
> is fully refined means some part of KVM will use the wrong tsc_khz, e.g. the VMX
> preemption timer.  Due to sanity checks in tsc_refine_calibration_work(), the delta
> won't be more than 1%, but it's still far from ideal.

Hmm, for systems with a constant TSC, KVM can fudge around the issue by not taking
a snapshot.  It's still racy and potentially fragile, e.g. if userspace manages
to create a vCPU before tsc_khz is refined, but it's not a bad standalone patch
and if it fixes your use case...

The only other alternative I can come up with is add a one-off "notifier" for KVM,
but that's rather gross, especially since TSC refinement is (hopefully) headed the
way of the Dodo.

Does this remedy your issues?  Any idea if you need to support old CPUs that don't
provide a constant TSC?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eaa3b5b89c5e..6a75c2748bff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8708,13 +8708,13 @@ static int kvmclock_cpu_online(unsigned int cpu)

 static void kvm_timer_init(void)
 {
-       max_tsc_khz = tsc_khz;
-
        if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
                struct cpufreq_policy *policy;
                int cpu;

+               max_tsc_khz = tsc_khz;
+
                cpu = get_cpu();
                policy = cpufreq_cpu_get(cpu);
                if (policy) {
@@ -11144,7 +11144,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
        vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
        kvm_vcpu_mtrr_init(vcpu);
        vcpu_load(vcpu);
-       kvm_set_tsc_khz(vcpu, max_tsc_khz);
+       kvm_set_tsc_khz(vcpu, max_tsc_khz ? : tsc_khz);
        kvm_vcpu_reset(vcpu, false);
        kvm_init_mmu(vcpu);
        vcpu_put(vcpu);
