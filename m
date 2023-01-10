Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C666643A1
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 15:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjAJOuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 09:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbjAJOuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 09:50:10 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF9150173
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 06:50:08 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4d0f843c417so42881647b3.7
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 06:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O1PBaQbDZLO7I3xO0kxG/0an+QH6NI5Xpd9+m+igxok=;
        b=Hb7uBBnfUhaTAd0g1zxyCd0lpV7RKp9m8G8sDcwOND2woX1LMqgo4UOrToKLG0UbL2
         Q3Ppd+mJdiT5gRnTS/VnSnuI+EaQsFiq8YJhhCu07Gih/R9I/l8hS+GjBYupMy47zXpN
         8R9b1qD5HUw6SOc+hmUU9NWUkoo9iFYVwyRn084jYlXDcAgmX5Ik1uaItUrPO0D0Vkg4
         lWAxA/DTgtlUETsHCi8cRqHoy4nZJGMb7M7GOCti56ja1oKTM3yLtnwp/B/ouxNpXKyc
         X6ULd90K8sY9NeoSBBwsKyG3/+GJTC8fvptaPGuPwwry/LGnyX+g0iZvNHu+hitMe2uL
         3/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O1PBaQbDZLO7I3xO0kxG/0an+QH6NI5Xpd9+m+igxok=;
        b=oucmL+fObWungb396eKgfI2kxXXBsa3PzUZErgk4Dx8VLw677FKTTyccsUj5RRtdIW
         M8i8TYsmQu0Yg8nOOwc9E8r5A6OjXKOT2g+ikscTfftNavFFcx5dc51210qFOafj//J4
         uHL7st/dMELfYR/wRnFcqJSZZAbOB0OxYhuoSgwe0kVRhUZuy75z/StCWYyXisSJt/87
         XHZpGbpR8ZyKHxbB4zbjOJG+0gvYiw5SnkSzfAW3z8pBmX6kWhnxWCxtXS/5HvsS/N9f
         5RoE6OQvJoIalF665MenIrna0vOoqhMmz65aX9piVOTX43Zo5IY0sNSFdP7TwVy2LkxF
         09NA==
X-Gm-Message-State: AFqh2koTJ2rUmCH+AV2B8ycuR7rtnVX0dQ6LQThq/7wz/nxLZVa7c045
        p53vXHPpyhLPglM5e7o8Vmnn1aMCCEFUfIFi1x7A1w==
X-Google-Smtp-Source: AMrXdXvn4cOElspqXDFhZ05EKkfaRmlMts7ZxOoqZjTuJgQ+olJPFfZZ0KCNP/me8C2rXJLNwHQspOEsswBOOrshS1g=
X-Received: by 2002:a0d:cb0b:0:b0:370:4c23:eacc with SMTP id
 n11-20020a0dcb0b000000b003704c23eaccmr1719839ywd.127.1673362207808; Tue, 10
 Jan 2023 06:50:07 -0800 (PST)
MIME-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com> <Y7R36wsXn3JqwfEv@google.com>
In-Reply-To: <Y7R36wsXn3JqwfEv@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 10 Jan 2023 14:49:56 +0000
Message-ID: <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        chang.seok.bae@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        bp@suse.de
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

> >  static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  {
> >       struct kvm_cpuid_entry2 *entry;
> > @@ -982,6 +992,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >               u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> >               u64 permitted_xss = kvm_caps.supported_xss;
> >
> > +             permitted_xcr0 = sanitize_xcr0(permitted_xcr0);
>
>
> This isn't 100% correct, all usage needs to be sanitized so that KVM provides a
> consistent view.  E.g. KVM_CAP_XSAVE2 would report the wrong size.
>
>         case KVM_CAP_XSAVE2: {
>                 u64 guest_perm = xstate_get_guest_group_perm();
>
>                 r = xstate_required_size(kvm_caps.supported_xcr0 & guest_perm, false);
>                 if (r < sizeof(struct kvm_xsave))
>                         r = sizeof(struct kvm_xsave);
>                 break;
>         }
>
> Barring a kernel bug, xstate_get_guest_group_perm() will never report partial
> support, so I think the easy solution is to sanitize kvm_caps.suport_xcr0.
>

When I run xcr0_cpuid_test it fails because
xstate_get_guest_group_perm() reports partial support on SPR.  It's
reporting 0x206e7 rather than the 0x6e7 I was hoping for.  That's why
I went down the road of sanitizing xcr0.  Though, if it's expected for
that to report something valid then sanitizing seems like the wrong
approach.  If xcr0 is invalid it should stay invalid, and it should
cause a test to fail.

Looking at how xstate_get_guest_group_perm() comes through with
invalid bits I came across this commit:

2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")

-       /* [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE, */
+       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE_DATA,

Seems like it should really be:

+       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE,

With that change xstate_get_guest_group_perm() should no longer report
partial support.

That means this entire series can be simplified to a 'fixes patch' for
commit 2308ee57d93d and xcr0_cpuid_test to demonstrate the fix.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2480b8027a45..7ea06c58eaf6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9344,6 +9344,10 @@ int kvm_arch_init(void *opaque)
>         if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>                 host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>                 kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
> +               if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_BNDREGS) ||
> +                   !(kvm_caps.supported_xcr0 & XFEATURE_MASK_BNDCSR))
> +                       kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
> +                                                    XFEATURE_MASK_BNDCSR);
>         }
>
>         if (pi_inject_timer == -1)
>
>
> > +
> >               entry->eax &= permitted_xcr0;
> >               entry->ebx = xstate_required_size(permitted_xcr0, false);
> >               entry->ecx = entry->ebx;
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
