Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAB65BB3BA
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIPVAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 17:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiIPVAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 17:00:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821A465655
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 14:00:38 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l7-20020a056830154700b0065563d564dfso15635393otp.0
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bYrG0Yslbv6xb9eR+NzLmWy3ddHxq1E4n0p8CHZoCuc=;
        b=ZetJDEKQkUWu7ZjO5JPV5uoDobm0+KZbiMiOhenh8qubN/vPjVllxsFzR85sFGZU96
         1fO/D2abS1C7cdPI3+Txml5hEPoL3DxhtJ1chWzK0rvrSi6vhlUG3V9gbdHjsDAyYzbE
         REbVSzoyyVkv4pC592YVGw6qqoSXdFWVzk8nGTN+zhJ4OtG4GkNdr+vInumike7MihRw
         UVDjtsTadgzT4MOFoGDqnkh7kZ0er94a5VUzdaGlagOlz5ZkqEOvNAbW9stO4RODCLY5
         vQVa5dHtkEqyu2d4ILiU9YHHvobDezY08kSpMFx97emBapUWHAjEQ2WH+GIx27dFbM4W
         Fsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bYrG0Yslbv6xb9eR+NzLmWy3ddHxq1E4n0p8CHZoCuc=;
        b=CDbId3eG4K7HfE5I66nBvLE2SsCHRxNwj6mDAFc/4f3MMe+d/DnC6RopuK+csIplP2
         iocu4wMiJoGLwxjuEQTUIkvainFDTgB9s8ilrT4z5NZggBhzCMV0XJXxzmy3kND1LbK4
         B8eI3nzdw1Maf54fo34GpGeQMY5FkxniogdGDEZdYvtwwn8RZSHcXuMhtrNNuqa7WSbL
         942HeEcR5Ee9LWbP+qvjm+rMdOKVQwrY4l0RXw4GXM78sEFuQxA4iMNxodsdsTUeVM1I
         ZVTgaCnVQOKV4fVnCac8MnJMFG+r6hV++pOm2wfbcxriA8ll/0uDy0l/jURhQ8+0f6pT
         m+PA==
X-Gm-Message-State: ACrzQf0RAWHxacDitirLCUbqbdW5A9Bt57t9V9CGjMsw+0ZYsjEy3+X9
        O7TZ0AXZit5httFXAKnnaDWVSjNk6OasJSLeRhnerw==
X-Google-Smtp-Source: AMsMyM7CTDFg+m5Amz2IZg3Ip3PjZTz/LYmqSIkOVpMeQCExVewW9+iZ3SeQTGxipDQrdMeGamTjP/si9V0XyvBAWE8=
X-Received: by 2002:a05:6830:2705:b0:659:ebb0:ecad with SMTP id
 j5-20020a056830270500b00659ebb0ecadmr763744otu.75.1663362037517; Fri, 16 Sep
 2022 14:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220916045832.461395-1-jmattson@google.com> <20220916045832.461395-3-jmattson@google.com>
 <YyTZFzaDOufASxqd@google.com>
In-Reply-To: <YyTZFzaDOufASxqd@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Sep 2022 14:00:26 -0700
Message-ID: <CALMp9eQXroxQYiWUCejd0Cj7kD5g5navWY_E2O_vzbVAQjLyNg@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: svm: Disallow EFER.LMSLE on hardware that
 doesn't support it
To:     Sean Christopherson <seanjc@google.com>
Cc:     Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Sep 16, 2022 at 1:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 15, 2022, Jim Mattson wrote:
> > KVM has never properly virtualized EFER.LMSLE. When the "nested"
> > module parameter is true, it allows an SVM guest to set EFER.LMSLE,
> > and it passes the bit through in the VMCB, but the KVM emulator
> > doesn't perform the required data segment limit checks in 64-bit mode.
> >
> > With Zen3, AMD has dropped support for EFER.LMSLE. Hence, if a Zen3
> > guest sets EFER.LMSLE, the next VMRUN will fail with "invalid VMCB."
> >
> > When the host reports X86_FEATURE_NO_LMSLE, treat EFER.LMSLE as a
> > reserved bit in the guest. Now, if a guest tries to set EFER.LMSLE on
> > a host without support for EFER.LMSLE, the WRMSR will raise a #GP.
> >
> > At the moment, the #GP may come as a surprise, but it's an improvement
> > over the failed VMRUN. The #GP will be vindicated anon.
> >
> > Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index f3813dbacb9f..7c4fd594166c 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5012,7 +5012,9 @@ static __init int svm_hardware_setup(void)
> >
> >       if (nested) {
> >               printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
> > -             kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> > +             kvm_enable_efer_bits(EFER_SVME);
> > +             if (!boot_cpu_has(X86_FEATURE_NO_LMSLE))
> > +                     kvm_enable_efer_bits(EFER_LMSLE);
>
> Since KVM doesn't correctly virtualize EFER.LMSLE, I wonder if we can get away with
> dropping support entirely.  I.e. delete the reference to EFER_LMSLE and unconditionally
> set F(NO_LMSLE) in KVM_GET_SUPPORTED_CPUID.

It's possible that SLES11 Xen 4.0 sets the bit, but never actually
uses truncated segments in 64-bit mode. In any case, according to the
original commit, it won't boot if setting EFER.LMSLE is not allowed.
