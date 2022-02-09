Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C346B4AFE5A
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 21:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiBIUXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 15:23:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiBIUXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 15:23:31 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36839E040DDF
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 12:23:31 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j4so3245516plj.8
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 12:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BC444T97s2pujBhj00jM3dxh/3fUj9wEYJS5P/gIz+E=;
        b=sFp5qUWM2vyEC5/A9tYSp9ZS5lQan6sS/azO/u3vOsj50f8Me5GPqLoKQ3fHbJKE7P
         15wOd0ax7k125I9/FZ2nfbtjt0pdoC764TbBbl5YRp3IpMmdk8n7r/kasMRd1gom8+I8
         6ISpi1GV7PAPv5vDS/EkhpxaBsjbZDJIEyZL4Rp5SjSAU1ePJeDW5sIFfR8lggLErGxC
         d6EA3mM4Z0n6Xz8455mEPpoV00rX7vTotPdupcM3o8n/SjWzDWe0aVWFHizC4KaxXT0B
         kmoMwe1U1Q64adee51VBlTdlLmbcOUoLpRtOjUtvw0oKPewVLWHjOJ/E4G14g7e+L6gM
         5KyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BC444T97s2pujBhj00jM3dxh/3fUj9wEYJS5P/gIz+E=;
        b=KpwY1AxZy8LrzC1jH9XKxy5zts4KKMcNq7pj8K8Famw2yxsthw8FrUxRArdPXoRSwk
         HTXe4sOWUBut8pOyyuyWnzm+1GUcLfjFZzl2pZ11bsaOuKQ89zw0Ngkizdqu2ZUTGlcc
         nhmJXnkBKrgNtdAKXvU4OZKtrf+Q7nxbKFOyRzR69ZfPT7zEESll3yhTkDrV0MBxNkPy
         mPwnmUmOkjCJZBacHHvPJsP1EcWhy2DmZ3SCGz26xc+r579xq7XHLmT/c7RA+wbLfb6l
         m6r5KGTvO4MP5IMUeDmp3gIre/k4+kxAGn8mZRnfpCAPTykj0Om6TWcFlWdjrTga3C7x
         sS6g==
X-Gm-Message-State: AOAM530RoPWNOFwOSe/se2I+6cNj6jRL+xmXMlTRB416ZjU+IVHjW9cD
        b3CGqkQB683TwirTZBBdUIyggg==
X-Google-Smtp-Source: ABdhPJy+8Drq/F1yUGaUW5cbnM1VdjpUk7MJa2Yx1nMb1G+NyLJQ5Q8TvuOsQ4zJX2xw5hWasJLQ0Q==
X-Received: by 2002:a17:903:41cf:: with SMTP id u15mr2733349ple.91.1644438210785;
        Wed, 09 Feb 2022 12:23:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d12sm14393021pgk.29.2022.02.09.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 12:23:29 -0800 (PST)
Date:   Wed, 9 Feb 2022 20:23:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 4/7] KVM: nVMX: Add a quirk for KVM tweaks to VMX
 control MSRs
Message-ID: <YgQivlmPUlC4uRqo@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-5-oupton@google.com>
 <YgFfpTk/woy75TVj@google.com>
 <CAOQ_QshC=DKZNQ1OVjtx19nw3+ET46fmCVnU+VQFHUBQ3vgFqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshC=DKZNQ1OVjtx19nw3+ET46fmCVnU+VQFHUBQ3vgFqw@mail.gmail.com>
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

On Tue, Feb 08, 2022, Oliver Upton wrote:
> On Mon, Feb 7, 2022 at 10:06 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> [...]
> 
> > > +#define KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS    (1 << 5)
> >
> > I'd prefer we include msr_ia32_feature_control_valid_bits in this quirk, it should
> > be relatively easy to do since most of the modifications stem from
> > vmx_vcpu_after_set_cpuid().  vmx_setup_mce() is a bit odd, but IMO it's worth
> > excising as much crud as we can.
> >
> 
> Sure, this is a good opportunity to rip out the crud.
> msr_ia32_feature_control_valid_bits is a bit messy, since the default
> value does not contain all the bits we support. At least with
> IA32_VM_TRUE_{ENTRY,EXIT}_CTLS we slim down the hardware values to get
> the default value.
> 
> Not at all objecting, but it looks like we will need to populate some
> bits in the default value of the IA32_FEAT_CTL mask, otherwise with
> the quirk enabled guests could never set any of the bits in the MSR.

I assume you mean "quirk disabled"?  Because quirks are on by default, i.e. KVM's
default behavior will be to populate msr_ia32_feature_control_valid_bits based on
CPUID updates.

That said, after typing up what I had in mind, I don't think we need a quirk at all.
The only weird part is that KVM doesn't allow host userspace to set the MSR without
first setting CPUID.  That's trivial to fix and we can do so without impacting KVM's
modeling of WRMSR from the guest.  Modeling WRMSR is no different than KVM enforcing
CR4 bits based on CPUID.  The VMX MSRs are weird because they are technically
independent of the non-virtualization support reported in CPUID, i.e. KVM is overstepping
by manipulating the MSRs based on CPUID.

I'll send this is a formal patch, obviously with KVM_SUPPORTED_FEATURE_CONTROL
defined...

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d05b4955d14f..d50ae2de8b51 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1749,11 +1749,16 @@ bool nested_vmx_allowed(struct kvm_vcpu *vcpu)
 }

 static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
-                                                uint64_t val)
+                                                struct msr_data *msr)
 {
-       uint64_t valid_bits = to_vmx(vcpu)->msr_ia32_feature_control_valid_bits;
+       uint64_t valid_bits;

-       return !(val & ~valid_bits);
+       if (msr->host_initiated)
+               valid_bits = KVM_SUPPORTED_FEATURE_CONTROL;
+       else
+               to_vmx(vcpu)->msr_ia32_feature_control_valid_bits;
+
+       return !(msr->data & ~valid_bits);
 }

 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
@@ -2146,7 +2151,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                vcpu->arch.mcg_ext_ctl = data;
                break;
        case MSR_IA32_FEAT_CTL:
-               if (!vmx_feature_control_msr_valid(vcpu, data) ||
+               if (!vmx_feature_control_msr_valid(vcpu, msr_info) ||
                    (to_vmx(vcpu)->msr_ia32_feature_control &
                     FEAT_CTL_LOCKED && !msr_info->host_initiated))
                        return 1;
