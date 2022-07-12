Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239B5571C7E
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiGLO2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiGLO2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:28:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7747DB8EB2
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:27:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 23so7711610pgc.8
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Eh6QM0esPfevg7x/BB3b6Yko4lRoZyFoVWjVPWewdNo=;
        b=I2sk+DFIVPh47uHTQS71+n61TGbuZMV+oHO9BfGK9vK5ijKlVywZ9Qi7n570c5/q4Q
         GfDK3UXbnLMXbDyISIwHG4nZZ6OL1gcCRPfGovZrCPctahmGwRiDrnTLJD/LBd3uQjW+
         RB3m8II83eQNDiBJqrCa3q7uMFnSJWj86BKaPWaGckX0LTr8hb4/1idEftUFUkWjVbYM
         j+wftkimHHWbadJJs+2MzAL8cqmmlDjkBWgmdbMyTP7o6lxCy3DvGCKuAQkvmvqI9dGV
         mmqVq16BYd/PSsFpkGYzxNm7FxmRttIQCFA3PUZB8ZC9bgkhCruObW9cBk+TSrfYKfoZ
         SODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eh6QM0esPfevg7x/BB3b6Yko4lRoZyFoVWjVPWewdNo=;
        b=bnAJ886PEYxfQXTJ2pgaj0hxhQkuhUS7p2V+zSYwYZ4uPMkbGfFfeV1WY47f1SFv7I
         u3vq2Ja8eBzlUImHVk1RuHrY+VK/LaQ0+X5yaBHBtX0JY3zouO5fHl4PaVGxgFzNdojj
         5+J7wulKon22xrSAHFGiqjyZVwr61/sUpToYTmVC9ElMCoxVTPlMmAgbi+EOurmjQrH8
         DYXGYFLo4RMFMAWHw6B22CqR1Eh9vo9OORTaFbZtKAhy5c38kEjR8scVUr3RbPyVlU+V
         uMbk7bEcDKKnkJjLMuboOQcTPgaW0OTJcn9H7hvBSMSnKNg8bZ2FDaaxjcmeQokYz7Vk
         fcJw==
X-Gm-Message-State: AJIora8NHVOrFdD7DTQ6HWKTOWZRt6Q0Kef8PjbY2COuqgJ29p8yKrpl
        KfnkqLwz0txx6d/8ySop5BDzrQ==
X-Google-Smtp-Source: AGRyM1uXr9/jjBVrPiITmVyF1a9AatjPfDy6rFi7wfBpBnkAXEaqoZLHXjAq5HzOs7U9PffHk7CW4w==
X-Received: by 2002:a05:6a00:885:b0:510:950f:f787 with SMTP id q5-20020a056a00088500b00510950ff787mr23501521pfj.83.1657636061774;
        Tue, 12 Jul 2022 07:27:41 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090301c700b0016c4f006603sm3932994plh.54.2022.07.12.07.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:27:41 -0700 (PDT)
Date:   Tue, 12 Jul 2022 14:27:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
Message-ID: <Ys2E2ckrk0JtDl52@google.com>
References: <20220629130514.15780-1-pdurrant@amazon.com>
 <YsynoyUb4zrMBhRU@google.com>
 <369c3e9e02f947e2a2b0c093cbddc99c@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <369c3e9e02f947e2a2b0c093cbddc99c@EX13D32EUC003.ant.amazon.com>
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

On Tue, Jul 12, 2022, Durrant, Paul wrote:
> > > @@ -1855,3 +1858,51 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
> > >       if (kvm->arch.xen_hvm_config.msr)
> > >               static_branch_slow_dec_deferred(&kvm_xen_enabled);
> > >  }
> > > +
> > > +void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > +{
> > > +     u32 base = 0;
> > > +     u32 limit;
> > > +     u32 function;
> > > +
> > > +     vcpu->arch.xen.cpuid_tsc_info = 0;
> > > +
> > > +     for_each_possible_hypervisor_cpuid_base(function) {
> > > +             struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
> > > +
> > > +             if (entry &&
> > > +                 entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
> > > +                 entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
> > > +                 entry->edx == XEN_CPUID_SIGNATURE_EDX) {
> > > +                     base = function;
> > > +                     limit = entry->eax;
> > > +                     break;
> > > +             }
> > > +     }
> > > +     if (!base)
> > > +             return;
> > 
> > Rather than open code a variant of kvm_update_kvm_cpuid_base(), that helper can
> > be tweaked to take a signature.  Along with a patch to provide a #define for Xen's
> > signature as a string, this entire function becomes a one-liner.
> > 
> 
> Sure, but as said above, we could make capturing the limit part of the
> general function too. It could even be extended to capture the Hyper-V
> base/limit too.  As for defining the sig as a string... I guess it would be
> neater to use the values from the Xen header, but it'll probably make the
> code more ugly so a secondary definition is reasonable.

The base needs to be captured separately for KVM and Xen because KVM (and presumably
Xen itself since Xen also allows a variable base) supports advertising multiple
hypervisors to the guest.  I don't know if there are any guests that will concurrently
utilize multiple hypervisor's paravirt features, so maybe we could squeak by, but
saving 4 bytes isn't worth the risk.

AFAIK, Hyper-V doesn't allow for a variable base, and so doesn't utilize the
for_each_possible... macro.
