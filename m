Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5346462C605
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiKPRL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 12:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiKPRLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 12:11:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2AD59FE3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:11:22 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l6so17135005pjj.0
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qU5KpuuvMvabmlf4l/Mi3tQhh2fL8Dh2/iugoH77F0k=;
        b=TdgWtef6UhHbqKe4QS/3Ayu3VNZZ3i9eoJmtCy7dLqrysJ7wB0UBIiB1NHl2XD8yEJ
         9A9e40vVPz0LeaGnBm+xWkbLjcxsdpGQjMtsawyPcUDXFiJtlqbZJWuF4NPJNhW8gWhc
         yklS7sdK1V06+Vo7Vtm2MrCNKTPLN0kZs4hpWbYlAx+pUoMaBEUe2EJ/R8vPCcvbrDoh
         3WsWgepDpESG+KKK928nilFdVglC19Gmb2mv5/mmmkx20fEfIehPjExF++q08zwUw6nJ
         A1VBgI5fVGcYhdLGJAFBS9e+51HNi1lhj80m/YmoiHsls5U6I/EdT06kMnKY5Lu6o+oq
         Zk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qU5KpuuvMvabmlf4l/Mi3tQhh2fL8Dh2/iugoH77F0k=;
        b=JdhYuVuXO0aGdSGDoxtZ5Zt472wo7LNtnqze+s5lC5+SALoM7KicUs8MNLQOb7i10f
         7LVFw6SrntxLZKlqEnrCv0fe1/rqTiDJ8Pzo3HY9HJ+fS24OYn6V9Hw03g07s5HgsayI
         iEJurOQ71mYJ69EFJc0pdMaxmtBFnZ+n3fZzCnY45it2qK+2aApDRVUup6eZGfOpR9vn
         OOkkhvvIIXgltfGKNbrhcx2sAO4ralR4kKNu9M6EWdtP7jN23fkFgM4Dm6HxM156Q/dI
         Hqbp/6/KRPxLoMuDIQDjgYrnlhilIBNQd8NjSPslzj8AqfdQPQeopE7aAOwuwDmr8dy0
         tlDw==
X-Gm-Message-State: ANoB5pnf6SEKLnJY46O9IPWvp6Y25aUcr29x/YLJekK9YqdPlu6AIfAQ
        QNpc4K3gb9kCPGozSamwIXBrbA==
X-Google-Smtp-Source: AA0mqf6YIHZPZijJW3drWLmCC0J1i77v6BfIk1GaXTBydT1hr0zvtFJFuTOMD/RjlZsQvYbm7cfMpQ==
X-Received: by 2002:a17:902:ed41:b0:175:105a:3087 with SMTP id y1-20020a170902ed4100b00175105a3087mr10067985plb.65.1668618681834;
        Wed, 16 Nov 2022 09:11:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090276c600b001788ccecbf5sm12424413plt.31.2022.11.16.09.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 09:11:21 -0800 (PST)
Date:   Wed, 16 Nov 2022 17:11:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "david@redhat.com" <david@redhat.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3UZtoIidMyE8qVz@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
 <Y3PzhANShVlTXVg1@google.com>
 <95ca433349eca601bdd2b16d70f59ba8e56d8e3f.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95ca433349eca601bdd2b16d70f59ba8e56d8e3f.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022, Huang, Kai wrote:
> On Tue, 2022-11-15 at 20:16 +0000, Sean Christopherson wrote:
> > On Thu, Nov 10, 2022, Huang, Kai wrote:
> > > On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check also
> > > happens on all online cpus when loading KVM.  For this case, IRQ is disabled and
> > > cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_active() is
> > > false.
> > 
> > Actually, you're right (and wrong).  You're right in that the WARN is flawed.  And
> > the reason for that is because you're wrong about the hotplug case.  In this version
> > of things, the compatibility checks are routed through hardware enabling, i.e. this
> > flow is used only when loading KVM.  This helper should only be called via SMP function
> > call, which means that IRQs should always be disabled.
> 
> Did you mean below code change in later patch "[PATCH 39/44] KVM: Drop
> kvm_count_lock and instead protect kvm_usage_count with kvm_lock"?
> 
>  	/*
>  	 * Abort the CPU online process if hardware virtualization cannot
>  	 * be enabled. Otherwise running VMs would encounter unrecoverable
> @@ -5039,13 +5039,16 @@ static int kvm_online_cpu(unsigned int cpu)
>  	if (kvm_usage_count) {
>  		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
>  
> +		local_irq_save(flags);
>  		hardware_enable_nolock(NULL);
> +		local_irq_restore(flags);

Sort of.  What I was saying is that in this v1, the compatibility checks that are
done during harware enabling are initiated from vendor code, i.e. VMX and SVM call
{svm,vmx}_check_processor_compat() directly.  As a result, the compat checks that
are handled in common code:

	if (__cr4_reserved_bits(cpu_has, c) !=
	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
		return -EIO;

are skipped.  And if that's fixed, then the above hardware_enable_nolock() call
will bounce through kvm_x86_check_processor_compatibility() with IRQs enabled
once the KVM hotplug hook is moved to the ONLINE section.

As above, the simple "fix" would be to disable IRQs, but that's not actually
necessary.  The only requirement is that preemption is disabled so that the checks
are done on the current CPU.  The "IRQs disabled" check was a deliberately
agressive WARN that was added to guard against doing compatibility checks from
the "wrong" location.

E.g. this is what I ended up with for a changelog to drop the irqs_disabled()
check and for the end code (though it's not tested yet...)

    Drop kvm_x86_check_processor_compatibility()'s WARN that IRQs are
    disabled, as the ONLINE section runs with IRQs disabled.  The WARN wasn't
    intended to be a requirement, e.g. disabling preemption is sufficient,
    the IRQ thing was purely an aggressive sanity check since the helper was
    only ever invoked via SMP function call.


static int kvm_x86_check_processor_compatibility(void)
{
        int cpu = smp_processor_id();
        struct cpuinfo_x86 *c = &cpu_data(cpu);

        /*
         * Compatibility checks are done when loading KVM and when enabling
         * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
         * compatible, i.e. KVM should never perform a compatibility check on
         * an offline CPU.
         */
        WARN_ON(!cpu_online(cpu));

        if (__cr4_reserved_bits(cpu_has, c) !=
            __cr4_reserved_bits(cpu_has, &boot_cpu_data))
                return -EIO;

        return static_call(kvm_x86_check_processor_compatibility)();
}


int kvm_arch_hardware_enable(void)
{
        struct kvm *kvm;
        struct kvm_vcpu *vcpu;
        unsigned long i;
        int ret;
        u64 local_tsc;
        u64 max_tsc = 0;
        bool stable, backwards_tsc = false;

        kvm_user_return_msr_cpu_online();

        ret = kvm_x86_check_processor_compatibility();
        if (ret)
                return ret;

        ret = static_call(kvm_x86_hardware_enable)();
        if (ret != 0)
                return ret;


	....
}
