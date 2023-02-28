Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28816A603C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjB1UTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjB1UTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:19:03 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D71EBE6;
        Tue, 28 Feb 2023 12:19:02 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id u20so6570576pfm.7;
        Tue, 28 Feb 2023 12:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677615541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jbp8o/lo13XGf5+0WrEFKE20QSk7ZBHiUI4jvzn5Iz8=;
        b=R2CEHeIII7+KDM2YNiEp1a1trjcCQpitHJk/uGU4t5uk86mm5RPEFw2fa2hIC3AUDi
         kXV1uICEScPL2ujHZTCEpJg+++JEM0zmZKwlV9ffTUq9q3R4w/Pq+gGoAhiFCQ1Zc7rJ
         IVAXr7NPeZMPwQTJ0IS6f+3q4aiIBvY0nej9e/h4lTUyKL8rUm8xgwAdrsThgRbsWzcd
         H7jW+OVUL8B1ffDsNor5Qcp4RIUOFZfrVgypWRyW6OPXFjHc3NaY3n9evGiEvV03wtn0
         dILsTqKANaHQwwkviF9vkvHOdtvUe5TGkHTb6DuCcORJx3UM2J1/cm72g4K1v+7KF/KF
         /DuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677615541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jbp8o/lo13XGf5+0WrEFKE20QSk7ZBHiUI4jvzn5Iz8=;
        b=8FXrOBFo/4e8/a5tzfegJqeX4cGwah1iKHodFo5Qs+DT/X7almUb0gI5And7TMu3kE
         dQ+haOaziXhHcjHlMOhVhifb8Zx5FBOU4y9kypwb4uh4EYPRBMx+Uq5MhPh/weV/O2/O
         OHdbZGaakESOcIKndVjcwZQIaBJOimn28dfleuWNa8wjr1AdyWccVqXz/t34OjXO/x0F
         2PVfm/iRDaKvIF8ZhYpaMAugh2Q7QdrikaLlqbg+FWOatiTW11cfGNTJoNkE3qIG6hnE
         +7qOILiMu/KpUJ4jAz+lF78dZv2OdiSoEJ+yRT4SzhL71DUyrhDAZIh6aQb/PHY7fu4L
         ekeg==
X-Gm-Message-State: AO0yUKX4DgKTX1dTaA//flapBDHDCSc4q7ssWDu8hP0YztHmO6ZVHMPP
        qS2xyYAxrNgFQLtcWnveBx4=
X-Google-Smtp-Source: AK7set/hcPE9FAyvEmH3cMU1/Cf8roCzLRMAmnfqQZLqdU16Hkg5haYIr+O+goYfJmxs5DaQqexHHg==
X-Received: by 2002:a62:198a:0:b0:5a8:be36:65a8 with SMTP id 132-20020a62198a000000b005a8be3665a8mr3457006pfz.27.1677615541357;
        Tue, 28 Feb 2023 12:19:01 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id a23-20020a62e217000000b0058b927b9653sm6639458pfi.92.2023.02.28.12.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 12:19:00 -0800 (PST)
Date:   Tue, 28 Feb 2023 12:18:58 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230228201858.GY4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
 <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
 <20230228110632.GV4175971@ls.amr.corp.intel.com>
 <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 11:52:59AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2023-02-28 at 03:06 -0800, Isaku Yamahata wrote:
> > > > +	if (!e)
> > > > +		return -ENOMEM;
> > > > +	*e  = (struct kvm_cpuid_entry2) {
> > > > +		.function = 1,	/* Features for X2APIC */
> > > > +		.index = 0,
> > > > +		.eax = 0,
> > > > +		.ebx = 0,
> > > > +		.ecx = 1ULL << 21,	/* X2APIC */
> > > > +		.edx = 0,
> > > > +	};
> > > > +	vcpu->arch.cpuid_entries = e;
> > > > +	vcpu->arch.cpuid_nent = 1;
> > > 
> > > As mentioned above, why doing it here? Won't be this be overwritten later in
> > > KVM_SET_CPUID2?
> > 
> > Yes, user space VMM can overwrite cpuid[0x1] and APIC base MSR.  But it
> > doesn't
> > matter because it's a bug of user space VMM. user space VMM has to keep the
> > consistency of cpuid and MSRs.
> > Because TDX module virtualizes cpuid[0x1].x2apic to fixed 1, KVM value doesn't
> > matter after vcpu creation.
> > Because KVM virtualizes APIC base as read only to guest, cpuid[0x1].x2apic
> > doesn't matter after vcpu creation as long as user space VMM keeps KVM APIC
> > BASE
> > value.
> > 
> 
> Contrary, can we depend on userspace VMM to set x2APIC in CPUID, but not do this
> in KVM?  If userspace doesn't do it, we treat it as userspace's bug.
> 
> Plus, userspace anyway needs to set x2APIC in CPUID regardless whether you have
> done above here, correct?
> 
> I don't see the point of doing above in KVM because you are neither enforcing
> anything in KVM, nor you are reducing effort of userspace.

Good idea. I can drop cpuid part from tdx_vcpu_create() and apic base part from
tdx_vcpu_reset(). It needs to modify tdx_has_emulated_msr() to allow user space
VMM to update APIC BASE MSR.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e045a8132639..46c82ce3ef46 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2624,7 +2624,14 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-       if (tdx_has_emulated_msr(msr->index, true))
+       if (tdx_has_emulated_msr(msr->index, true) ||
+           /*
+            * user space VMM should explicitly set to X2APIC mode as initial
+            * value that is deviated from the conventional case.
+            */
+           (msr->host_initiated && msr->index == MSR_IA32_APICBASE &&
+            (msr->data & ~MSR_IA32_APICBASE_BSP) ==
+            (APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC)))
                return kvm_set_msr_common(vcpu, msr);
        return 1;
 }


Just FYI, qemu needs the following change.

--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -274,6 +274,11 @@ bool is_tdx_vm(void)
     return !!tdx_guest;
 }
 
+bool is_tdx_vm_finalized(void)
+{
+    return !!tdx_guest && tdx_guest->parent_obj.ready;
+}
+
 static inline uint32_t host_cpuid_reg(uint32_t function,
                                       uint32_t index, int reg)
 {
@@ -875,10 +880,20 @@ static void tdx_post_init_vcpus(void)
     TdxFirmwareEntry *hob;
     CPUState *cpu;
     int r;
+    uint64_t apic_base;
 
     hob = tdx_get_hob_entry(tdx_guest);
     CPU_FOREACH(cpu) {
-        apic_force_x2apic(X86_CPU(cpu)->apic_state);
+        X86CPU *x86_cpu = X86_CPU(cpu);
+
+        apic_force_x2apic(x86_cpu->apic_state);
+
+        apic_base = APIC_DEFAULT_ADDRESS | MSR_IA32_APICBASE_ENABLE |
+            MSR_IA32_APICBASE_EXTD;
+        if (cpu_is_bsp(x86_cpu))
+            apic_base |= MSR_IA32_APICBASE_BSP;
+        cpu_set_apic_base(x86_cpu->apic_state, apic_base);
+        kvm_put_apicbase(x86_cpu, apic_base);
 
         r = tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
         if (r < 0) {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 5cc0f730afa6..f77689464738 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -59,8 +59,10 @@ typedef struct TdxGuest {
 
 #ifdef CONFIG_TDX
 bool is_tdx_vm(void);
+bool is_tdx_vm_finalized(void);
 #else
 #define is_tdx_vm() 0
+#define is_tdx_vm_finalized() false;
 #endif /* CONFIG_TDX */
 
 int tdx_kvm_init(MachineState *ms, Error **errp);

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
