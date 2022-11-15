Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E95C62A2A8
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 21:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKOUVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 15:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKOUVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 15:21:05 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFBA2C665
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:21:04 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 130so14369215pgc.5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XxrH205VSL6PuZxNZy5QSHBg1esXqApruwRLQHoD1FQ=;
        b=QoLsrppxCqrrm8Et/yxXiG7qWE0hiOrc+RLWkwKVvGYvEXTURW54Ct7G0aFnW7vDom
         O3WnXZWOxSKhgS+uv00LIKaFYAiY4w1O0HuVw0sHlWnVNkXyDKqsQfpccjPy0o//76Ot
         9HbC7sv+GYjRBhUyAvWsaFUrflZFb6BoKafnLIcIXy0vGyf6tKbOGR6vv68o6WUCslEQ
         BOT4pCgeSJnKExa2xfKvrZGwBZhzuokrCi6o4yMRfhSIGNbmSd/1S94WiYpeZI3RH1jS
         tMxrZXr8PoWD2Hx+ZMuaUIAmz2hZjOEiOFHGi/ELuekxNrIkmFIAeW4IyLdTJL7wajgf
         6FdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XxrH205VSL6PuZxNZy5QSHBg1esXqApruwRLQHoD1FQ=;
        b=5QKcSyY4p7Ye6ZTsCVS+HGTzuSTmMBEF3l8yupzddffyFQrVbJtFFBsBTS8lnVJa47
         Bec3VHd83xkbHlX8QelW4sza6X+5a5FNafFhMgoiaWtWZ7CXC6mCCA4HLCoJuhFFy899
         0x0Im5VR9Ul67bVpE4GSCmJHPbd2C6WKbVq5KQvFNLE28lJUSJWBSM5cEBAUJ/YCNS41
         STFv1gF30r4/W41pqtWf3bCrdIbP+enyzaWVdjtDI8TowKXPNGxSD89mTCRq1hBSCO/0
         5PU/APfyaIgUK7ccg+euDWJJAeK0CHGUD6GMOs6AVDwb0iRkeGEbW9Bf4jNXUCgVNQN2
         2jEg==
X-Gm-Message-State: ANoB5pkNdUvG7iM2XafSZTRZKumPYSTf7yjf1jpGru82POMvosebPH8S
        1wNBZzFGSFhji2UGoh6NSpJaQA==
X-Google-Smtp-Source: AA0mqf7I+HCT8JLUK2SnELicaIfj+5Xh/wdDfnKOa9DuiFN7rhFS7bzZLz9XVMfRQzvW4tmCjZQXQw==
X-Received: by 2002:aa7:9493:0:b0:56b:9ae8:ca05 with SMTP id z19-20020aa79493000000b0056b9ae8ca05mr19812088pfk.59.1668543664233;
        Tue, 15 Nov 2022 12:21:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001754fa42065sm10448477plg.143.2022.11.15.12.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:21:03 -0800 (PST)
Date:   Tue, 15 Nov 2022 20:21:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3P0rAjywL1a7Pme@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
 <Y3PzhANShVlTXVg1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3PzhANShVlTXVg1@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Huang, Kai wrote:
> > On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > > @@ -9283,7 +9283,13 @@ static int
> > > > kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> > > >  	int cpu = smp_processor_id();
> > > >  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > > >  
> > > > -	WARN_ON(!irqs_disabled());
> > > > +	/*
> > > > +	 * Compatibility checks are done when loading KVM and when enabling
> > > > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > > > +	 * compatible, i.e. KVM should never perform a compatibility check
> > > > on
> > > > +	 * an offline CPU.
> > > > +	 */
> > > > +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
> > > >  
> > > 
> > > Also, the logic of:
> > > 
> > > 	!irqs_disabled() && cpu_active(cpu)
> > > 
> > > is quite weird.
> > > 
> > > The original "WARN(!irqs_disabled())" is reasonable because in STARTING
> > > section
> > > the IRQ is indeed disabled.
> > > 
> > > But this doesn't make sense anymore after we move to ONLINE section, in which
> > > IRQ has already been enabled (see start_secondary()).  IIUC the WARN_ON()
> > > doesn't get exploded is purely because there's an additional cpu_active(cpu)
> > > check.
> > > 
> > > So, a more reasonable check should be something like:
> > > 
> > > 	WARN_ON(irqs_disabled() || cpu_active(cpu) || !cpu_online(cpu));
> > > 
> > > Or we can simply do:
> > > 
> > > 	WARN_ON(!cpu_online(cpu) || cpu_active(cpu));
> > > 
> > > (because I don't know whether it's possible IRQ can somehow get disabled in
> > > ONLINE section).
> > > 
> > > Btw above is purely based on code analysis, but I haven't done any test.
> > 
> > Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check also
> > happens on all online cpus when loading KVM.  For this case, IRQ is disabled and
> > cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_active() is
> > false.
> 
> Actually, you're right (and wrong).  You're right in that the WARN is flawed.  And
> the reason for that is because you're wrong about the hotplug case.  In this version
> of things, the compatibility checks are routed through hardware enabling, i.e. this
> flow is used only when loading KVM.  This helper should only be called via SMP function
> call, which means that IRQs should always be disabled.

Grr, but not routing through this helper is flawed in that KVM doesn't do the
CR4 checks in the hardware enabling case.  Don't think that changes the WARN, but
other patches in this series need tweaks.
