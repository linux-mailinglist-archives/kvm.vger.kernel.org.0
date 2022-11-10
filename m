Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C526247B9
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiKJQ7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiKJQ7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:59:03 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9329F11A27
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:59:01 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 4so1926072pli.0
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=++qaNnNL5OJX09F4SmymJbSNGTe4YNGKf8knlNeZLIM=;
        b=LnpIznW50UbJYIR0PEtWeJYNJ+5rH6MIlZozMzFMTwSQvTcP33ucW9c9lQSevvLDXI
         QyB5+yXhMZUDNlkwdSbDFjM7JR9S8ttOodJeLQApsp/g1X2g7iaiRMpztbbtLirGmHXP
         Ok5MPlCZ4tZXNzdoN/5EaAFNU5i/kMEU+Pj6UbsvHwVNko95a9bIdjWXiNhQrkyCMZcF
         1gbXxHeTac5BLcvPalQHTWFwjbFrO0re69/ZDM4/c7ATiGknmYZEnSteDE0eFOsuiUGv
         o02wNWrUZNQBtGle02WgOsPhE6Inb5/XeEtyenAcor9m9bnEppDYL8UdqJt6p1agDB2o
         ED2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++qaNnNL5OJX09F4SmymJbSNGTe4YNGKf8knlNeZLIM=;
        b=IWh/Ps5qB+6dS+sWHnr4SKx+8sCoWZOBQ5S7iSxHAsLQzqNpUBIyZdaQ4EbmuX1hMb
         mZmJtp25x5rfu5BOHRJ41olMUk8sLS9riaTMHGTEza/CLiXHdEcauD0Zr1MmQb6v/I0L
         HBgJndCU+5gHXM1tTRfPcBKU3LBLIfagVwba8ICHVQAZNRVDtZLITcGl6labt19rjiRe
         p4CfjBjKJ/W+Fu2kZmH8Rwha9a88OShurjmjW430R+lGdOi19Z95OuDo3xj4pz0V4o/q
         rjyhGlDljyCvdWw/yT11UIj3pelvT6mPN7APsacyqkDZEJeMezwwI7QOG98BeY7KWe/F
         jmKg==
X-Gm-Message-State: ANoB5pm/5biNkW5F+gL0MOOou6OigjkaGJ0t3vsE3joMaYXMY6VjKdHY
        CSIAiUrVaSpGxgVFbXciWHEL0g==
X-Google-Smtp-Source: AA0mqf4HLI0425WgRwXjVOczy7lGJ1ZoFRhJMikRvyU6kmBBe6o5W1MVmVmeziJeqm75+QzM+47Lew==
X-Received: by 2002:a17:902:6aca:b0:188:736c:befa with SMTP id i10-20020a1709026aca00b00188736cbefamr1100928plt.8.1668099540938;
        Thu, 10 Nov 2022 08:59:00 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm3302123pji.11.2022.11.10.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:59:00 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:58:56 +0000
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
Message-ID: <Y20t0AMNqvtyOwp2@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
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

On Thu, Nov 10, 2022, Huang, Kai wrote:
> On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > @@ -9283,7 +9283,13 @@ static int
> > > kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> > >  	int cpu = smp_processor_id();
> > >  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > >  
> > > -	WARN_ON(!irqs_disabled());
> > > +	/*
> > > +	 * Compatibility checks are done when loading KVM and when enabling
> > > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > > +	 * compatible, i.e. KVM should never perform a compatibility check
> > > on
> > > +	 * an offline CPU.
> > > +	 */
> > > +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
> > >  
> > 
> > Also, the logic of:
> > 
> > 	!irqs_disabled() && cpu_active(cpu)
> > 
> > is quite weird.
> > 
> > The original "WARN(!irqs_disabled())" is reasonable because in STARTING
> > section
> > the IRQ is indeed disabled.
> > 
> > But this doesn't make sense anymore after we move to ONLINE section, in which
> > IRQ has already been enabled (see start_secondary()).  IIUC the WARN_ON()
> > doesn't get exploded is purely because there's an additional cpu_active(cpu)
> > check.
> > 
> > So, a more reasonable check should be something like:
> > 
> > 	WARN_ON(irqs_disabled() || cpu_active(cpu) || !cpu_online(cpu));
> > 
> > Or we can simply do:
> > 
> > 	WARN_ON(!cpu_online(cpu) || cpu_active(cpu));
> > 
> > (because I don't know whether it's possible IRQ can somehow get disabled in
> > ONLINE section).
> > 
> > Btw above is purely based on code analysis, but I haven't done any test.
> 
> Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check also
> happens on all online cpus when loading KVM.  For this case, IRQ is disabled and
> cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_active() is
> false.
> 
> So WARN_ON(!irqs_disabled() && cpu_active(cpu)) looks reasonable.  Sorry for the
> noise.  Just needed some time to connect the comment with the code.

No worries, more than once while working through this code, I've considered setting
up one of those evidence boards from the movies with string and push pins to help
connect all the dots.
