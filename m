Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017BB6235BA
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 22:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiKIVXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 16:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKIVXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 16:23:36 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F19B857
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 13:23:34 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id q83so8516166oib.10
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 13:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6osH2CHG24SjyK30ZoBUndUFe6RAe9+84/GlrRsbBnM=;
        b=iQ2chr+X2kRuB01a+ZYYy/UQFv+aDzlpR+2R1eF5XkDVs+1B8ppV+Csc3qP+NOILZX
         KTCi+X9EXlUHeYL1hIVPuMh1DMQr1RvjvJXu71kE2iziI8MNeOI56xaEknzffVHTbskr
         rsBCLlWHIWeshq1WxeK9zwvp3NdnZDYc/iGf7mSv643pEnMuEUwREHOgrUtj8MOsy5MK
         JA0jPGCpb8Xpmv7rLLSNyXaX7Ri5QofSzhRYovs1MOM6569AJWUdOBQhTSozlc/tzwVi
         KBddeiJLSwZzr1KdbDDBlnDs4DDEuo8I1MoTg5HhRs7dcLsV9Srot3IuP69IJvRCP8zJ
         /plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6osH2CHG24SjyK30ZoBUndUFe6RAe9+84/GlrRsbBnM=;
        b=TNNYbHls4o6OtvgkKWcUBrGlb0cpNLZv18/qPq1uc4H/q6RcWLe7rz1r04W+hI2RKg
         FSw5mAfC/fhe1WIwaiheU3zPMw9DxyiPiyX1azyXjXmjK/mYH9A3AnKMlVM51IT8PnAr
         hy3Rz8ZQzzxTIx9e23waAP3pPgQfGwTraNPoS5TaX3koISVCs5QkgofRaJADTqphpSHU
         5pfEHYDrRknydk4fYJrTqmSviy+VIYTvsu2HtKZOfsV2EQkvDr/A/NX0ISBTUfgJ5d/D
         3q54qrioeMzm7fDYEz3cjLGY1H7mawtVVWfQZfvghYzWUaAyZ5+jUjzmRtLiU5xmI3Kh
         BCXQ==
X-Gm-Message-State: ACrzQf0n06L4l7lwytiwLLvYZ51AlMLiANMxp6JyN7emZs0bZpQxbBH3
        5qXiP4ico7ViOCHfrq4zpn8h5Y+qfQohguuxRDBTOw==
X-Google-Smtp-Source: AMsMyM7oeyA6T8YvG0AE/+9cMNUnq1sl/0vB7ZmbqimmBPi2qfR8pJSuAFElhfnxqh850sWuHg3fblWAYbw3XtrrRUE=
X-Received: by 2002:aca:6007:0:b0:35a:1bda:d213 with SMTP id
 u7-20020aca6007000000b0035a1bdad213mr27166493oib.181.1668029013158; Wed, 09
 Nov 2022 13:23:33 -0800 (PST)
MIME-Version: 1.0
References: <20221107145436.276079-1-pbonzini@redhat.com> <20221107145436.276079-8-pbonzini@redhat.com>
 <CALMp9eRDehmWC1gZmSjxjwCvm4VXf_FnR-MiFkHxkTn4_DJ4aA@mail.gmail.com> <81f7dc5c-c45d-76fc-d9e8-4f3f65c29c12@redhat.com>
In-Reply-To: <81f7dc5c-c45d-76fc-d9e8-4f3f65c29c12@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Nov 2022 13:23:22 -0800
Message-ID: <CALMp9eSrifYwOyPzs3UiUnM7o3iRead5-m5ta4tMo+72Td1y5A@mail.gmail.com>
Subject: Re: [PATCH 7/8] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, seanjc@google.com,
        stable@vger.kernel.org
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

On Mon, Nov 7, 2022 at 11:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/7/22 19:45, Jim Mattson wrote:
> >> +.macro RESTORE_GUEST_SPEC_CTRL
> >> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
> >> +       ALTERNATIVE_2 "jmp 999f", \
> >> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
> >> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
> >> +
> >> +       /*
> >> +        * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
> >> +        * host's, write the MSR.
> >> +        *
> >> +        * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
> >> +        * there must not be any returns or indirect branches between this code
> >> +        * and vmentry.
> >> +        */
> >> +       movl SVM_spec_ctrl(%_ASM_DI), %eax
> >> +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> >> +       je 999f
> >> +       mov $MSR_IA32_SPEC_CTRL, %ecx
> >> +       xor %edx, %edx
> >> +       wrmsr
> >> +999:
> >> +
> >> +.endm
> >> +
> >> +.macro RESTORE_HOST_SPEC_CTRL
> >> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
> >> +       ALTERNATIVE_2 "jmp 999f", \
> >> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
> >> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
> >> +
> >> +       mov $MSR_IA32_SPEC_CTRL, %ecx
> >> +
> >> +       /*
> >> +        * Load the value that the guest had written into MSR_IA32_SPEC_CTRL,
> >> +        * if it was not intercepted during guest execution.
> >> +        */
> >> +       cmpb $0, (%_ASM_SP)
> >> +       jnz 998f
> >> +       rdmsr
> >> +       movl %eax, SVM_spec_ctrl(%_ASM_DI)
> >> +998:
> >> +
> >> +       /* Now restore the host value of the MSR if different from the guest's.  */
> >> +       movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> >> +       cmp SVM_spec_ctrl(%_ASM_DI), %eax
> >> +       je 999f
> >> +       xor %edx, %edx
> >> +       wrmsr
> >> +999:
> >> +
> >> +.endm
> >> +
> >> +
> >
> > It seems unfortunate to have the unconditional branches in the more
> > common cases.
>
> One way to do it could be something like
>
> .macro RESTORE_HOST_SPEC_CTRL
>         ALTERNATIVE_2 "", \
>                 "jmp 900f", X86_FEATURE_MSR_SPEC_CTRL, \
>                 "", X86_FEATURE_V_SPEC_CTRL \
> 901:
> .endm
>
> .macro RESTORE_SPEC_CTRL_BODY \
> 800:
>         /* restore guest spec ctrl ... */
>         jmp 801b
>
> 900:
>         /* save guest spec ctrl + restore host ... */
>         jmp 901b
> .endm
>
> The cmp/je pair can also jump back to 801b/901b.
>
> What do you think?  I'll check if objtool is happy and if so include it
> in v2.
>
> Paolo
>
This seems reasonable, if you trust a direct branch prior to the IBPB.
