Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F7F4F185F
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 17:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358393AbiDDPbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 11:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348744AbiDDPbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 11:31:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3E825283
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 08:29:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y10so9294407pfa.7
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 08:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WwaoVUBFVj9j7YaVgwWeUQJL/8oOimF01hIs03GSwEs=;
        b=KZsqHqLKTZjQ/n4pzslaH4ezeqg3fhSolbXjJDiLWpQ/F7MVzuHnt9f78kdKHToQch
         G70BhWHUbPG0PFNkIq0GPgyX81ktwvl+QHt8S/DabeaSL0+Iwo61HVAvu1HIBIY8S5yp
         tBulvFhDY/WVo/ktoFXDlHK0vM9E0BPOGCq4frsH67nAc9UFAmZQVYyLIZX1GWYJbVIo
         Qp9I2Ss9mAvRnWQ0sfLgx6U7mHlf1V5UPYz7zTqeXdXYXYAnZrrD7z8mYc2jz+gy5AQ6
         9bRf4e6+0bJXpY3TR7YpsYxf50s9DZmxdEuNLIbT70dw6bLeUEjGMqzhAOlx0x3+Rlg5
         Yn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WwaoVUBFVj9j7YaVgwWeUQJL/8oOimF01hIs03GSwEs=;
        b=0vQgzxCRTLzJrR9KuzZap3g8TFTBUoSc74fhnU783Fg3XS4/bD9gP4pZqyyTTHIiRI
         nOeW3SzDuWm+c7qbxRgUtbLMIhBVEtEfOWsSE1zpxm8e8lCBvwJXuXDlSjKydmGPL0Wp
         NXpxoLSHF3PF0LktTu8ihkFHmNguy+XMJA+m2rX41SsJMXHqGtS9UWI6fDG4dpcnBTAb
         ognBeY5JZa2srdg5CiOhp1uNWxw8wa8sAgUP/XPX/S79gdyAUpi749AHX3Hm6vPjoQn+
         xmp6pHhJmlc7nMbOiz34LM+IF+/MJBZZvt10IIFM9G/uYAeYg34AJhoaMgoxgeCgD6y4
         xw9g==
X-Gm-Message-State: AOAM533ulazyWWlPuKr9XS8U8V+fI5l2xhuTLqLGamnmRQ0SNQYM0Ylf
        3U5MVbLp4yAdJEX7iLQBoohxoQ==
X-Google-Smtp-Source: ABdhPJwChen+B+MRC8z3HtJ9ZPqGfIpYJlCB7ilek3qAIXp3MkMC00v5kKiyVolwyc8KYvTSZ9Tagg==
X-Received: by 2002:a63:d456:0:b0:399:4c5a:2682 with SMTP id i22-20020a63d456000000b003994c5a2682mr308856pgj.573.1649086158737;
        Mon, 04 Apr 2022 08:29:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u11-20020a056a00158b00b004fb07effe2esm13383793pfk.130.2022.04.04.08.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 08:29:17 -0700 (PDT)
Date:   Mon, 4 Apr 2022 15:29:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 5/8] KVM: x86: Add support for vICR APIC-write
 VM-Exits in x2APIC mode
Message-ID: <YksOyUQd3N/inHMo@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-6-guang.zeng@intel.com>
 <YkY0MvAIPiISfk4u@google.com>
 <ce0261c0-a8f2-a9b8-6d99-88a33556d7cb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0261c0-a8f2-a9b8-6d99-88a33556d7cb@intel.com>
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

On Sat, Apr 02, 2022, Zeng Guang wrote:
> 
> > > -	/* TODO: optimize to just emulate side effect w/o one more write */
> > > -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
> > > +		kvm_lapic_msr_read(apic, offset, &val);
> > > +		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> > This needs to clear the APIC_ICR_BUSY bit.  It'd also be nice to trace this write.
> > The easiest thing is to use kvm_x2apic_icr_write().  Kinda silly as it'll generate
> > an extra write, but on the plus side the TODO comment doesn't have to move :-D
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index c4c3155d98db..58bf296ee313 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2230,6 +2230,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> >          struct kvm_lapic *apic = vcpu->arch.apic;
> >          u64 val;
> > 
> > +       /* TODO: optimize to just emulate side effect w/o one more write */
> >          if (apic_x2apic_mode(apic)) {
> >                  /*
> >                   * When guest APIC is in x2APIC mode and IPI virtualization
> > @@ -2240,10 +2241,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> >                          return;
> > 
> >                  kvm_lapic_msr_read(apic, offset, &val);
> > -               kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> > +               kvm_x2apic_icr_write(apic, val);
> 
> As SDM section 10.12.9 "ICR Operation in X2APIC mode" says "Delivery status
> bit is removed since it is not needed in x2APIC mode" , so that's not
> necessary to clear the APIC_ICR_BUSY bit here. Alternatively we can add trace
> to this write by hardware.

That same section later says 

  With the removal of the Delivery Status bit, system software no longer has a
  reason to read the ICR. It remains readable only to aid in debugging; however,
  software should not assume the value returned by reading the ICR is the last
  written value.

which means that it's at least legal for a hypervisor to clear the busy bit.  That
might be useful for debugging IPI issues?  Probably a bit of a stretch, e.g. I doubt
any kernels set the busy bit.  But, I do think the tracing would be helpful, and at
that point, the extra code should be an AND+MOV.

I don't have a super strong opinion, and I'm being somewhat hypocritical (see commit
b51818afdc1d ("KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure"),
though that has dedicated tracing), so either approach works for me.
