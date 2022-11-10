Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B7062478D
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiKJQua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiKJQuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:50:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4F5A470
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:49:34 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so5178348pjs.4
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPjVc+C4keVB9JNeySRKdiTbUPe13351AhOJe9TtZf8=;
        b=OOR4bwRUplBbyMMh2BEwu+86VP3qxijSJnezQ7clymoLz9HUcLonm3WyVFc88kB5fY
         O/E+L3vna3lCH6PwuGGALEpEbdqf//FCQPJXnQH0fruVZmuKpiXxpksMlHLNli5FBIVk
         yHcqF3ftlcFWSWpaRO18yKIRlZ4MLKYwLTrjNA/qL4cv528Rj8wkmrotYw4AfXaxmJus
         pcCX78Uh4a0+xqNPkY5yiRwsOaQfBATcwvX2XL8kq2aQkn5xXT0ESqE2s4sWnkM2XUP1
         lN0YUhWFEsDiU77d2rUZObTRDQeLPD96HT9QdyztVtB+kfc9jl7KnKnrsPBskzRSRVH/
         XRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPjVc+C4keVB9JNeySRKdiTbUPe13351AhOJe9TtZf8=;
        b=dyPQPrJM/J8fcBP46MewyS0bbWqIi3KJ92SNHn8VdSyijA8Cn5ihlp35o/r9uztYPC
         W/l1yD1kGBrb405OATvQNAtKtrh8sJOeETuG91VWEBJ5ykEX9yyaBeCuCinbWcDmgr+g
         aCCdDg4AsHtevvi6NBiXuy7nfa+H0jPoQSlprdu83RUeKodCsJ85qrBeyt0ntITmpat3
         yAza5MbqHw1cxXtcA3B48hyrQnOnWgHbUFZYfN1O3rrcdvu9H240tNXWnt2ECkfqen8p
         oZ1nqqowdEyVh3epu+9clQOjiBIhyMbeWSp/USaX1Pmbp3zxi2E7XUmaRtfROvS51u03
         Wptg==
X-Gm-Message-State: ACrzQf2/HrRjStnMs7X9hAFHbJIj15H0ZcDxRGs8lwGLzSWboA/EMq8+
        qGYAHEJ6k+GWEpe3SkbDK4cV5Q==
X-Google-Smtp-Source: AMsMyM7nQN/gdgW0z481CkQ/WjHrrL4d++/kzaSXhuKO9UuGt09a3AowKSZBoBJ0HDICWxNrCbdrGA==
X-Received: by 2002:a17:902:d50c:b0:187:460:bf9c with SMTP id b12-20020a170902d50c00b001870460bf9cmr65545589plg.4.1668098974180;
        Thu, 10 Nov 2022 08:49:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a020300b00205d85cfb30sm3288107pjc.20.2022.11.10.08.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:49:33 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:49:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 37/44] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Y20rmaU14rZFFCZI@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-38-seanjc@google.com>
 <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
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

On Thu, Nov 10, 2022, Robert Hoo wrote:
> > -static int kvm_starting_cpu(unsigned int cpu)
> > +static int kvm_online_cpu(unsigned int cpu)
> >  {
> > +	int ret = 0;
> > +
> >  	raw_spin_lock(&kvm_count_lock);
> > -	if (kvm_usage_count)
> > +	/*
> > +	 * Abort the CPU online process if hardware virtualization
> > cannot
> > +	 * be enabled. Otherwise running VMs would encounter
> > unrecoverable
> > +	 * errors when scheduled to this CPU.
> > +	 */
> > +	if (kvm_usage_count) {
> > +		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
> > +
> >  		hardware_enable_nolock(NULL);
> > +		if (atomic_read(&hardware_enable_failed)) {
> > +			atomic_set(&hardware_enable_failed, 0);
> 
> I see other places using this hardware_enable_failed with atomic_inc(),
> should here use atomic_dec() instead of straightly set to 0?

Meh, both options are flawed.  E.g. if hardware_enable_failed was left dangling
(the WARN above), then atomic_dec() won't remedy the problem and KVM will reject
onlining CPUs indefinitely.  Forcing the atomic back to '0' will remedy that
particular issue, but could lead to problems if there are other bugs.

> Though here is embraced by spin_lock, hardware_enable_nolock() can be
> invoked in other places in parallel?

Only because of a KVM bug, which gets fixed in the next patch:

  KVM: Disable CPU hotplug during hardware enabling
