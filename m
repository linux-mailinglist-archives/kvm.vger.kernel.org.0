Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFEB4C9225
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiCARqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiCARqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:46:52 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44661A15
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:46:10 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id t5so5862433pfg.4
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hW/YZmS7wpJS7lNeC9TLZr2YM2tyw8ZN9mG1toRHUEY=;
        b=n6SeFINnZOt1ieREkJkw7GKfq+9aKjZo1/dOXyhxGUtAm9PLy7rNDfN85E/cKEVcOh
         1qJbKM2d4+FwBYEsjudLw2YwA+/gaRuopRoOzGC961IREwjWo7DHJRxCIsyFq/9/zH7H
         iU06/1PIlDpoPUhu44O1GYUzn+Y1ERDQ4hvLMa8CVD8XXRAWhAa7nOeC1uOqy5nNdhCd
         FD5hiuSRYZ1mVsECmjuoXAVG3jFIHx4DbO40wuuKWwgoHAs/be87O5alVV+56QkHQMpz
         OjgGz+fh4+boeUTAXspKSs83GBug9vmVjaPPs4RG7dkVdCRZj3Bw7CAqFUFf5IWOfJ6v
         uzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hW/YZmS7wpJS7lNeC9TLZr2YM2tyw8ZN9mG1toRHUEY=;
        b=QwJGfreApe2Yzb78iAJjgQ1y4UY5pR7XETnihMaBqDXgZFp92uDz4RA2qaDp0jWqQa
         Mz3ih5JSjgUEUM/6DQI6N98nu6uUBTKLMcwXsHcH4Rk2zZ1mOEkCSFLufwhdOhHVMU/r
         /aeUHWBuNee/j2cwWEuGlDqzY/qwjTCCc5G++58Em+r2wBeLyOHC6F1TBURFQVzx6+Dy
         p9z9hpITt5Xsm8Y3OGDrAdGOZMOS6jR71GRKes7JP30+7I8QomumeiqNAY/1RKI/0zzk
         78rwJnbLNchAZbJxfny3ixHoqeb9DTEXI85kQ65p31syck5TJv9VFqzoR1SQ6+CEVIsa
         fvIw==
X-Gm-Message-State: AOAM532y1sa15GWYO41HXXLJ/nLGnShxRRvzJcNS4423gb4bibUmsqxv
        lDlg5qdT7NSqk4EeBA9DxGVwAA==
X-Google-Smtp-Source: ABdhPJy29O9ruXlkZmz1FBD3hlywTLo4gG7yfSObUN32u+vZmDmQg1WYvsMi+/Is29GgqniD50TNfw==
X-Received: by 2002:a05:6a00:a92:b0:4e0:57a7:2d5d with SMTP id b18-20020a056a000a9200b004e057a72d5dmr28694355pfl.81.1646156769845;
        Tue, 01 Mar 2022 09:46:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id me10-20020a17090b17ca00b001b9e6f62045sm2700322pjb.41.2022.03.01.09.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:46:09 -0800 (PST)
Date:   Tue, 1 Mar 2022 17:46:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default apic
 id when not using x2apic api
Message-ID: <Yh5b3eBYK/rGzFfj@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-5-mlevitsk@redhat.com>
 <Yh5QJ4dJm63fC42n@google.com>
 <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 80a2020c4db40..8d35f56c64020 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2618,15 +2618,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> > >  		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> > >  		u64 icr;
> > >  
> > > -		if (vcpu->kvm->arch.x2apic_format) {
> > > -			if (*id != vcpu->vcpu_id)
> > > -				return -EINVAL;
> > > -		} else {
> > > -			if (set)
> > > -				*id >>= 24;
> > > -			else
> > > -				*id <<= 24;
> > > -		}
> > > +		if (!vcpu->kvm->arch.x2apic_format && set)
> > > +			*id >>= 24;
> > > +
> > > +		if (*id != vcpu->vcpu_id)
> > > +			return -EINVAL;
> > 
> > This breaks backwards compability, userspace will start failing where it previously
> > succeeded.  It doesn't even require a malicious userspace, e.g. if userspace creates
> > a vCPU with a vcpu_id > 255 vCPUs, the shift will truncate and cause failure.  It'll
> > obviously do weird things, but this code is 5.5 years old, I don't think it's worth
> > trying to close a loophole that doesn't harm KVM.
> > 
> > If we provide a way for userspace to opt into disallowiong APICID != vcpu_id, we
> > can address this further upstream, e.g. reject vcpu_id > 255 without x2apic_format.
> 
> This check is only when CPU is in x2apic mode. In this mode the X86 specs demands that
> apic_id == vcpu_id.

AMD's APM explicitly allows changing the x2APIC ID by writing the xAPIC ID and then
switching to x2APIC mode.

> When old API is used, APIC IDs are encoded in xapic format, even when vCPU is in x2apic
> mode, meaning that apic id can't be more  that 255 even in x2apic mode.

Even on Intel CPUs, if userspace creates a vCPU with vcpu_id = 256, then the xAPIC ID
will be (256 << 24) == 0.  If userspace does get+set, then KVM will see 0 != 256 and
reject the set with return -EINVAL.

And as above, userspace that hasn't opted into the x2apic_format could also legitimately
change the x2APIC ID.

I 100% agree this is a mess and probably can't work without major shenanigans, but on
the other hand this isn't harming anything, so why risk breaking userspace, even if the
risk is infinitesimally small?

I'm all for locking down the APIC ID with a userspace opt-in control, I just don't
think it's worth trying to retroactively plug the various holes in KVM.
