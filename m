Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C536585664
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbiG2VO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 17:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiG2VO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 17:14:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D8A33421
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:14:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q16so4905849pgq.6
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=z1WLca89qhOPxCkQZQeKtBH6EwJtyqt81JuhvSQxYx4=;
        b=i3Hwi3oiffod/IC+znpP73mLe6b4pF9wruHZ8VcW/5ag/48gWL45TGt0jmox+oPH6S
         /tbI4cicdYoKT7SYnf/ZUHf6POg467FMXforD3vVdTC2jZ8AzJ2cVnYAhft4K6dsDofj
         WBmt9NsQtnh7wsSVSImxjSsPNcfiT8/uwvIydbJpnIu0d+6md8rhZkpYiUg6raPMKOzS
         7kZ9fZ4HKjJ45VWAYWEkMK/C+DFaNfUMyp+7Y1bYj3bKIqK258Q9BR93n/CzW4a3u1BG
         R6GVTG7PWm7JZ/WstvXQ8trQpRUl91afNpmZ5pqpDCsQt8CH9vyU1sjy3toNce1ZPn2s
         ckoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=z1WLca89qhOPxCkQZQeKtBH6EwJtyqt81JuhvSQxYx4=;
        b=K8+Y7ohu7ILlMeIBw3EwTbQ7ByTxOKkHucKZrz1ncqoCOlNBt00zfntPnJocRx+JHp
         ABsZ+pK3C7B92IIaPDkbLH/0c6fIiLYjioS7mpc9WPONILe+SH7lQRFYj0nuue1Fn6gT
         kzdd4QLX/MFHTcF6BbyyShy3mEOVRPAGZGDG0NTui7hpzLF6HiN3WDWCAGrGmFKYlSvV
         l3e2T6yl1fRxngZW6vuvkmDk5/qJv8+sL5cNjcS1V6XEeiVjhzTKWHbfBaxYi4C7CYea
         ysaa80cVS3qu3SzLX9B2ROYi25Uw6aMDmoD1mKqyMh424pOeknDLtN2CwyxlyLFhATVt
         0rpA==
X-Gm-Message-State: AJIora8B5kLpnr+ezkr5i6PUxWF18TQDVmg47CBs/c3JrQDh8T6j5+6a
        JBk4xI9OLpiYKY1dQOF1hq2wKQ==
X-Google-Smtp-Source: AGRyM1u3Usg7Sa9oQ01MqZBcMbTYAtBHAD5rfFc35zYeijB9qg5RIBYFahU306pnkFhjIhsd4NdLAg==
X-Received: by 2002:a05:6a00:993:b0:52a:dd93:f02d with SMTP id u19-20020a056a00099300b0052add93f02dmr5653163pfg.12.1659129264002;
        Fri, 29 Jul 2022 14:14:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c207-20020a621cd8000000b0052896ea8a28sm3320715pfc.151.2022.07.29.14.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 14:14:23 -0700 (PDT)
Date:   Fri, 29 Jul 2022 21:14:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Simon Veith <sveith@amazon.de>
Cc:     dwmw2@infradead.org, dff@amazon.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, oupton@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH 1/2] KVM: x86: add KVM clock time reference arg to
 kvm_write_tsc()
Message-ID: <YuRNq1I8X5QsCW5l@google.com>
References: <0e2a26715dc3c1fb383af2f4ced6c9e1cf40b95b.camel@infradead.org>
 <20220707164326.394601-1-sveith@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707164326.394601-1-sveith@amazon.de>
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

On Thu, Jul 07, 2022, Simon Veith wrote:
> The Time Stamp Counter (TSC) value register can be set to an absolute
> value using the KVM_SET_MSRS ioctl, which calls kvm_synchronize_tsc()
> internally.
> 
> Since this is a per-vCPU register, and vCPUs are often managed by
> separate threads, setting a uniform TSC value across all vCPUs is
> challenging: After live migration, for example, the TSC value may need
> to be adjusted to account for the migration downtime. Ideally, we would
> want each vCPU to be adjusted by the same offset; but if we compute the
> offset centrally, the TSC value may become out of date due to scheduling
> delays by the time that each vCPU thread gets around to issuing
> KVM_SET_MSRS.
> 
> In preparation for the next patch, this change adds an optional, KVM
> clock based time reference argument to kvm_synchronize_tsc(). This
> argument, if present, is understood to mean "the TSC value being written
> was valid at this corresponding KVM clock time point".


Given that commit 828ca89628bf ("KVM: x86: Expose TSC offset controls to userspace")
was merged less than a year ago, it would be helpful to explicitly call out why
KVM_VCPU_TSC_CTRL doesn't work, and why that sub-ioctl can't be extended/modified to
make it work.

> kvm_synchronize_tsc() will then use this clock reference to adjust the
> TSC value being written for any delays that have been incurred since the
> provided TSC value was valid.
> 
> Co-developed-by: David Woodhouse <dwmw@amazon.co.uk>

Needs David's SOB.  And this patch should be squashed with the next patch.  The
kvm_ns != NULL path is dead code here, e.g. even if the logic is wildly broken,
bisection will blame the patch that actually passes a non-null reference.  Neither
patch is big enough to warrant splitting in this way.

And more importantly, the next patch's changelog provides a thorough description
of what it's doing, but there's very little in there that describes _why_ KVM
wants to provide this functionality.

> Signed-off-by: Simon Veith <sveith@amazon.de>
> ---
>  arch/x86/kvm/x86.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1910e1e78b15..a44d083f1bf9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2629,7 +2629,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  	kvm_track_tsc_matching(vcpu);
>  }
>  
> -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, u64 *kvm_ns)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 offset, ns, elapsed;
> @@ -2638,12 +2638,24 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	bool synchronizing = false;
>  
>  	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> -	offset = kvm_compute_l1_tsc_offset(vcpu, data);
>  	ns = get_kvmclock_base_ns();
> +
> +	if (kvm_ns) {
> +		/*
> +		 * We have been provided a KVM clock reference time point at

Avoid pronouns, e.g. there's no need to say "We have been provided", just state
what kvm_ns is and how it's used.

> +		 * which this TSC value was correct.
> +		 * Use this time point to compensate for any delays that were
> +		 * incurred since that TSC value was valid.
> +		 */
> +		s64 delta_ns = ns + vcpu->kvm->arch.kvmclock_offset - *kvm_ns;
> +		data += nsec_to_cycles(vcpu, (u64)delta_ns);
> +	}
