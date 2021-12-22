Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B2A47D45A
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 16:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343746AbhLVPor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 10:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhLVPor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 10:44:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E79C061574
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 07:44:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so3034787pjp.0
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 07:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NIZ7uwOt3RNrOkBbyTkldvkB8yUEDRa1+JjbWjOeH0k=;
        b=nTeD8Q+RjVAj4XHg6NIwdG9H4PO1gL8aBXE4NBSIm7OHUzo8qxVrivqitgd8SbSCno
         Ltm0Gnl7haI6ZLK80JjN6D2xeNMclr3pZuFdXsjzoQkQhwa1o+qaNEEWx3X9xI9NLucJ
         CY+3Lv5qr/ErrByLoW2Pe2BMr1RDYHA8q/J2CYnsgmU3UTjFr4aLT20xRh2IrucKgESI
         lSJS++7Aety+s4UMO6OR9NhcfNPCFSQqTvMj2GYzrctb7LLmokanVVDRmGBfEyL9YG5R
         9xLz4mwWy3+JRYQuL3cI7A2weWfbeUBhVp0JYCQ0pB39cJj6S/wmtDb1mNRv/rQN9tYs
         MiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NIZ7uwOt3RNrOkBbyTkldvkB8yUEDRa1+JjbWjOeH0k=;
        b=OFyDW/KA5XyB6AXdLMP3jV6nH3yuH2jL2D71qjGTZ7b1SoRx5dYrpzaaek9KhO2Zfz
         tymKtJZM0ylzKXE5La9b7jg5+riYKOpmwZKDjblRIoK8nOvMv/zUB0ZM40lphksyo2oV
         h+HgUsuJbqvGb9mz7C3wDAV87LfATDe5rUPwyWRHQ65n3xlrhUmEXqayBEEdvoe+jpS/
         UF8YXo8nfdOzPqJQbXdKoWH0oZlf64d+vHSaZmsOBXhuctrCB8eQM3/FbqioeQtZ2PYO
         mt+bsT3xeBSiEQ3u4CHyUQx8vvvRBRaeJ3vBBEH7gCzd/Pd/c9s7A+cznt+DWR9exQle
         zDCA==
X-Gm-Message-State: AOAM530GHIO/v5s0RBVmjvt4QpADXhcY3wY9zWh7cLa3uil8KnQe7p2h
        Iph7WG4tpmC8rHQLrFtZrGT4PQ==
X-Google-Smtp-Source: ABdhPJxFvMADTNnD13L8Im9xe49+GRGvExp7ggcO+UEPf2e7Xwhy0uWvtPdX2oiGP9H55vURvTy3AQ==
X-Received: by 2002:a17:902:b282:b0:148:b21e:4901 with SMTP id u2-20020a170902b28200b00148b21e4901mr3259385plr.169.1640187886107;
        Wed, 22 Dec 2021 07:44:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l26sm2453612pgm.67.2021.12.22.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 07:44:45 -0800 (PST)
Date:   Wed, 22 Dec 2021 15:44:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: The vcpu won't be wakened for a long time
Message-ID: <YcNH6RDemrxMUi15@google.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com>
 <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
 <Ybtea42RxZ9aVzCh@google.com>
 <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
 <YcHyReHoF+qjIVTy@google.com>
 <20211222060735.GA22521@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222060735.GA22521@gao-cwp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021, Chao Gao wrote:
> On Tue, Dec 21, 2021 at 03:27:01PM +0000, Sean Christopherson wrote:
> >On Sat, Dec 18, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> >> > Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.
> >> > Can you try running with the below commit?  It's currently sitting in kvm/queue,
> >> > but not marked for stable because I didn't think it was possible for the check
> >> > to a cause a missed wake event in KVM's current code base.
> >> > 
> >> 
> >> The below commit can fix the bug, we have just completed  the tests.
> >> Thanks.
> >
> >Aha!  Somehow I missed this call chain when analyzing the change.
> >
> >  irqfd_wakeup()
> >  |
> >  |->kvm_arch_set_irq_inatomic()
> >     |
> >     |-> kvm_irq_delivery_to_apic_fast()
> >         |
> >	 |-> kvm_apic_set_irq()
> >
> >
> >Paolo, can the changelog be amended to the below, and maybe even pull the commit
> >into 5.16?
> >
> >
> >KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
> >
> >Drop a check that guards triggering a posted interrupt on the currently
> >running vCPU,
> 
> Can we move (add) this check to kvm_vcpu_trigger_posted_interrupt()?
>
> 	if (vcpu->mode == IN_GUEST_MODE) {
> [...]
> -		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> +		if (vcpu != kvm_get_running_vcpu())
> +			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>  		return true;
> 
> It can achieve the purpose of the original patch without (re-)introducing
> this bug.

Hmm, yes, I think that would be safe and would optimize delivery of TSC deadline
timer interrupts when they're emulated via the VMX preemption timer.  The original
patch confused me because the optimization went in before the code it was optimizing.
