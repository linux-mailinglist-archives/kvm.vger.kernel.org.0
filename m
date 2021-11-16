Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983C14536F1
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhKPQLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbhKPQKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 11:10:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3A1C061767
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:07:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k4so17781365plx.8
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z2AKx61/RhCe2zs5ofLjhqQARlhS43Ifv8qiPWwvU8w=;
        b=lcsOSKJZX1HW4dBg29cw5mdeiwWY+loBeYbsQV+z2/nV6RWvDRujp8jkar1j2iKk7Z
         Q7kDkSiVYol/fAQwYbdXz6fN2IlDQoEEG233LaBBpiKOliI+F4QJNkSO/vk84Grwjsg1
         xgisig77vEEa4Zd5OSZNhbkVEv6fJSGPJYnEKhE6p2XLpvSYq3J4gQzmDevLkU5rdnAI
         rP9CME4bIKDfKmH+iv15W2ZbpFgsMSUMaP9zPM2kyOtgds+U6deVQ6MfC7qosULoTu5/
         vwD7KCMHs8C2lB+vzVYl7as7WrWnO4BfhRzOPbRRQhhHWPUHJLeuyWBsJIHbOy9ux35U
         p6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z2AKx61/RhCe2zs5ofLjhqQARlhS43Ifv8qiPWwvU8w=;
        b=G68nxm8p6O/gPwMcj0HWinORqRWXOFH+fUSAImYam6wvNBleUyVttG+OdmOEuwqKRp
         Dl1TPgmIWVxiUItZU4wuZzrzzkVhxIwmYUayxKVd39F4RajZlnBiCM9sjfMsqyZwAR0d
         t9x8VrQ3m9uCBJ6nIDWcjtoExcHh/FpZNuLizi5wMOyeTttm2DL4Edef24UbxkQwtu4C
         O9q9wsjCYETqubHXVvOPaqNWLJdqkih5I/d24d92/4PtiWqGFUdxWB3Yckzuw2FDtWsh
         sI9MCtcOhhWSb/hiONV+UhDKztnpBO8pH1UVcRi58qGjg/DKNCzxKf88V4IwmUlwe12u
         M3iA==
X-Gm-Message-State: AOAM533jZv6rI0mkvR5EPyp49YSTaCZaeFqehq4k9xqRRVGaOU6vuLV9
        HU3nFOQ5A394Bn76wf3NdKNiMg==
X-Google-Smtp-Source: ABdhPJxU6duTqsrTks/nV5OrQqCjn8t+5rodqO/OPYPZOkqch8j1M2u2I4szhAM4KHA4Nd8M6EsWPg==
X-Received: by 2002:a17:902:7890:b0:143:c4f7:59e6 with SMTP id q16-20020a170902789000b00143c4f759e6mr22206936pll.87.1637078871989;
        Tue, 16 Nov 2021 08:07:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lt5sm2725151pjb.43.2021.11.16.08.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:07:51 -0800 (PST)
Date:   Tue, 16 Nov 2021 16:07:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linuxppc-dev@lists.ozlabs.org, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Message-ID: <YZPXU3eBT8j0fUPs@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org>
 <YYWOKTYHhJywwCRk@google.com>
 <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Paolo Bonzini wrote:
> On 11/5/21 21:03, Sean Christopherson wrote:
> > But I think even that is flawed, as APICv can be dynamically deactivated and
> > re-activated while the VM is running, and I don't see a path that re-updates
> > the IRTE when APICv is re-activated.  So I think a more conservative check is
> > needed, e.g.
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 5f81ef092bd4..6cf5b2e86118 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
> > 
> >          if (!kvm_arch_has_assigned_device(kvm) ||
> >              !irq_remapping_cap(IRQ_POSTING_CAP) ||
> > -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> > +           !irqchip_in_kernel(kvm) || !enable_apicv)
> >                  return 0;
> > 
> >          idx = srcu_read_lock(&kvm->irq_srcu);
> 
> What happens then if pi_pre_block is called and the IRTE denotes a posted
> interrupt?
> 
> I might be wrong, but it seems to me that you have to change all of the
> occurrences this way.  As soon as enable_apicv is set, you need to go
> through the POSTED_INTR_WAKEUP_VECTOR just in case.

Sorry, I didn't grok that at all.  All occurences of what?
