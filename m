Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669FD459DAF
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhKWIVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhKWIVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:21:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E5EC061574;
        Tue, 23 Nov 2021 00:18:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so15987911pjr.5;
        Tue, 23 Nov 2021 00:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zM3bW2Pr7xWb7m7mGViXuar4Xf1FuOAyNpmKVEYv2LA=;
        b=DYy0Lv2BFenFI2/lwQjulVqCLOZIQ+ilw5KhORwu5MG7fMbv+fC8OCR3HuYlEI0kAr
         QbDNKH9j5L+W+1UCym7utRg5nAgAVoJmNvLWnzfZjB6kiCOr6qYUBTQxvNHVvPLQbHtg
         yVfthnVF3ncL8y2XUkLdgFcWbxgzY00YsXKxcWLtvRrU/ZHaGrGTLvY+H/GzfgmSSoE9
         HKegLjzaXHMk2vOcLvyFnRnxoa7Bm1G+NtwH9qsFpExafxw/zmjuVjQy47UZ8cPNLt96
         8KYNfUswdJJ0nn6TXTUjDUMW7c9nebT6EOBNLM9rK21B9LkdoZhLiTtvhbNZUW2GxlfO
         syyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zM3bW2Pr7xWb7m7mGViXuar4Xf1FuOAyNpmKVEYv2LA=;
        b=eA2InHZ4M0K6AjLf9tXNd3G7QLD55Av9vYuHgiyjEDmlqnqvidYCvukFy2SUOpYSVK
         DslaKAbV3cxsn8qi00SeXHxgLSh7bDDqnFHrvDF1CNkw7GROZr7LxW+Xr6J9r1IC/604
         5VNF/PyjfLlgkU7d6dvwiiKOeBFEyETlFrVecAgDdAE7qPS9UI0VP11M8ZLGRnmSFdyX
         UMK732e4ZtEHBFtE8Tf7rUJUsxS4P4GDnxqs8ObcXeeohVrnP3yEcf3Bf7P0PKM8ZiI6
         XsgoBtLXz17/2HoGQrwCSdtWprCFuIfqua33uTAdPQgvcb1fZIpQsnWgJnaZFnXmyLD6
         zJHw==
X-Gm-Message-State: AOAM530OKdQGhktUxEFcE9SoLjGfcaWr13tTpKdf1IcwQTH15at4ID8i
        i/1hwD8Vv7SQvsAO1F8xQnY=
X-Google-Smtp-Source: ABdhPJym4WIvvqBdSxc3QdDoPrEZoQ+DdR1k0sDyFiSsvL3xfSowMr6drnWP8/hjU4+Puti0DlmP2A==
X-Received: by 2002:a17:902:da85:b0:142:11b4:b5c0 with SMTP id j5-20020a170902da8500b0014211b4b5c0mr4660836plx.53.1637655522459;
        Tue, 23 Nov 2021 00:18:42 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id g17sm11593029pfv.136.2021.11.23.00.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 00:18:42 -0800 (PST)
Date:   Tue, 23 Nov 2021 16:18:34 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211123161834.30714698@gmail.com>
In-Reply-To: <YZvrvmRnuDc1e+gi@google.com>
References: <20211122095619.000060d2@gmail.com>
        <YZvrvmRnuDc1e+gi@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Nov 2021 19:13:02 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Nov 22, 2021, Aili Yao wrote:
> > From: Aili Yao <yaoaili@kingsoft.com>
> > 
> > When we isolate some pyhiscal cores, We may not use them for kvm
> > guests, We may use them for other purposes like DPDK, or we can
> > make some kvm guests isolated and some not, the global judgement
> > pi_inject_timer is not enough; We may make wrong decisions:
> > 
> > In such a scenario, the guests without isolated cores will not be
> > permitted to use vmx preemption timer, and tscdeadline fastpath
> > also be disabled, both will lead to performance penalty.
> > 
> > So check whether the vcpu->cpu is isolated, if not, don't post timer
> > interrupt.
> > 
> > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 759952dd1222..72dde5532101 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -34,6 +34,7 @@
> >  #include <asm/delay.h>
> >  #include <linux/atomic.h>
> >  #include <linux/jump_label.h>
> > +#include <linux/sched/isolation.h>
> >  #include "kvm_cache_regs.h"
> >  #include "irq.h"
> >  #include "ioapic.h"
> > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct
> > kvm_lapic *apic) 
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);  
> 
> I don't think this is safe, vcpu->cpu will be -1 if the vCPU isn't
> scheduled in. 

I checked this, It seems we will set vcpu->cpu to a valid value when we
create vcpu( kvm_vm_ioctl_create_vcpu()), only after that we can
configure lapic through vcpu fd and start the timer, this may not be one
real problem.

Currently, the patch seems work as expected in my test, maybe one
possible candidate for the issue listed above.

Thanks

> This also doesn't play nice with the admin forcing
> pi_inject_timer=1.  Not saying there's a reasonable use case for
> doing that, but it's supported today and this would break that
> behavior.  It would also lead to weird behavior if a vCPU were
> migrated on/off a housekeeping vCPU.  Again, probably not a
> reasonable use case, but I don't see anything that would outright
> prevent that behavior.
> 
> The existing behavior also feels a bit unsafe as pi_inject_timer is
> writable while KVM is running, though I supposed that's orthogonal to
> this discussion.
> 
> Rather than check vcpu->cpu, is there an existing vCPU flag that can
> be queried, e.g. KVM_HINTS_REALTIME?
> 
> >  }
> >  
> >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> > -- 
> > 2.25.1
> >   

