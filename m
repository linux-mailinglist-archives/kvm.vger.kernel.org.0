Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02161624C2F
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiKJUxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKJUxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:53:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8483245EEA
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:53:13 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 136so2735369pga.1
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WygUON0ShfBs6SD/zM1XVk7J6hKuAxuQg26RW9HjWuo=;
        b=iyv/s5AVdIveq4KGB9Cl83L/uWs2045huCCxSipIhrSz8Mp+zfzgeUj3CsJzrSuh9p
         hl16tuYDWRcAQ/nIqkMZGDQEwZKYMgPszC54ghmH4HMJKwTpG62MmIvmxOlJZfWFmuNy
         KXDa8+ZzvQH7BEEy1A1F3/i4p1LmseL7uxfiK0Qbw6QmzNS3FLYfAcr8kbIBafwSVWu2
         PqTa8lNNFKby1cXU883Zi3Aw5z0E8UvJVfI0cpYsPyOiDkbMvjvBDa9yDddaMFGJqeIs
         pEu+PrWMXOOkpJ3Z0REmqhjWAzM9WK+BQHJBIVgtzqceNSB1B8sSP8hhya/pp2Zor4H/
         QpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WygUON0ShfBs6SD/zM1XVk7J6hKuAxuQg26RW9HjWuo=;
        b=mp7dWogzW6/8OE3F3laI18LqAy7km9kkuWjmZwpqRgblWqGs/FufipsYgzl/IB/HFT
         gSX3aa0zHgsXTncYDHse6j3Syjb6WZSUN9wS0MROr0QFF+SbUnUlZIsmQHBQuzSZ0fqf
         HdTtE8GsVL3d9WsumD/ez16qXA/ai0WPY6oAdixkhWjIUqXynoL2k3sAcetwXE5IDqFX
         4gH6VrG6r0BIj1MFcIZE2DyJ5fFlYhOP6SF5d++u1ET2eCyiThu5r8umcCLDnuiZDMza
         I2keQF6GYVxfVqqUq49rnwzaTat8Og5BxSabT50Sg2Jft0Lfx9m8NnbxtJsSs0oJ8P7E
         AWKw==
X-Gm-Message-State: ACrzQf3Yr9ScR1Ptdvgm9UGZtYbeaHesNgcBdOAixlpuCncCSyqnaauG
        M2CMwaqyhJScg7WQ88DuuYkMPw==
X-Google-Smtp-Source: AMsMyM6Xqj74uJZ6BOpeL/14qkOIIB3iuRtk6AkN/O4b6a+4GtHikj2zdWzsNglHeOzVBNQgrP7HAw==
X-Received: by 2002:a63:4384:0:b0:45f:beda:4116 with SMTP id q126-20020a634384000000b0045fbeda4116mr3327363pga.618.1668113592874;
        Thu, 10 Nov 2022 12:53:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k92-20020a17090a4ce500b00211d5f93029sm3468960pjh.24.2022.11.10.12.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:53:12 -0800 (PST)
Date:   Thu, 10 Nov 2022 20:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Message-ID: <Y21ktSq1QlWZxs6n@google.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com>
 <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
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

On Thu, Nov 10, 2022, Li, Xin3 wrote:
> > > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > > +/*
> > > + * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync
> > 
> > Please use a verb other than "reinject".  There is no event injection of any kind,
> > KVM is simply making a function call.  KVM already uses "inject" and "reinject"
> > for KVM where KVM is is literally injecting events into the guest.
> > 
> > The "kvm_vmx" part is also weird IMO.  The function is in x86's
> > traps/exceptions namespace, not the KVM VMX namespace.
> 
> right, "kvm_vmx" doesn't look good per your explanation.
> 
> > 
> > Maybe exc_raise_nmi_or_irq()?
> 
> It's good for me.
> 
> > 
> > > + * call thus the values in the pt_regs structure are not used in
> > > + * executing NMI/IRQ handlers,
> > 
> > Won't this break stack traces to some extent?
> > 
> 
> The pt_regs structure, and its IP/CS, is NOT part of the call stack, thus
> I don't see a problem. No?

  bool nmi_cpu_backtrace(struct pt_regs *regs)
  {
  	int cpu = smp_processor_id();
  	unsigned long flags;
  
  	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
  		/*
  		 * Allow nested NMI backtraces while serializing
  		 * against other CPUs.
  		 */
  		printk_cpu_sync_get_irqsave(flags);
  		if (!READ_ONCE(backtrace_idle) && regs && cpu_in_idle(instruction_pointer(regs))) {
  			pr_warn("NMI backtrace for cpu %d skipped: idling at %pS\n",
  				cpu, (void *)instruction_pointer(regs));
  		} else {
  			pr_warn("NMI backtrace for cpu %d\n", cpu);
  			if (regs)
  				show_regs(regs); <============================== HERE!!!
  			else
  				dump_stack();
  		}
  		printk_cpu_sync_put_irqrestore(flags);
  		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
  		return true;
  	}
  
  	return false;
  }
