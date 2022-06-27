Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5332755DA29
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiF0SAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 14:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiF0SAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 14:00:06 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153D5B858
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:00:05 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id w3-20020a4ab6c3000000b0041c1e737283so2027331ooo.12
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z4QV8HZyP/VA+g9JqMm75BLwevsM4iFeMnarLv23qdI=;
        b=RNmGVAbcgbQKmI8UnEPn4DYVmzz9zmNOgSfDfn5jdTK6Jo8BJxXYJVOxhAK2BnR7bp
         DFyiVDlFdrmDZq9ls3T943+3OuJqn9RifeL6mvF3NhPRT3nFbpg9sYGF1brNKDbUGJiR
         GI32iimwmvrkzZzDLHFtULmBl34G17vIYZVs/qdoVR8UoOvLeXmfGN0kgpkxk6zjos6z
         otDAL2qez3BjK6T1JjmrCsNygdUfY0w5Pt+wMr6mfJVrgQQWMrhVa3YA+blo5trlvCyL
         z+QiuPePlZkMCSOl1rEALWeiV03e62zkuxnV0XfmfYjYkddsTjr6Q1gJM+OqfwDUxr4g
         ZfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z4QV8HZyP/VA+g9JqMm75BLwevsM4iFeMnarLv23qdI=;
        b=ztlQYnWExDUFEy031nSfMVs+UgeR7xYVt6j7AJT4YoOnxvsX42S3tPPeGSU0Pu8kG9
         rAjvfSN69nJvjqZEOiyRQQ7IO1DwMf2baycLrlZzl4lVsDOl6M4+quif9a72F1ya0Zuw
         6EGqE0g8+w9w4aIhHMewDujRMELIwW/XbnUdJLqleItSc56PrYS47gRvIh+vAzJ5Ue3+
         ME0+xG3eatE1gdjnftp89WNSNLXMefHunxlIlerifjYly9qt1OWUYighKsmGNzu91y3D
         dS2sdNIkzp/PiMozec7qAaGGuSg87x8omNu8aqxdkBvdY/PpGcybl1xhLe0YuqDdNTi1
         8CNg==
X-Gm-Message-State: AJIora8VvastYbWns4GFN5aPNQiY6ZqDwBQix15puzLkXqAdOb8mPTKt
        RyswbU5FtElsO1GP143SriXKqdHP8ZDTrCgeaCJG3A==
X-Google-Smtp-Source: AGRyM1teebrksgnAxIMlDEIxnmhBx/J4YBMYUdgB2QIqWZpHTzRQK2Y2w+UaldD3P6zRJv36xJ5tIPpI6chs4TIzDm0=
X-Received: by 2002:a4a:e82b:0:b0:330:cee9:4a8a with SMTP id
 d11-20020a4ae82b000000b00330cee94a8amr6393702ood.31.1656352804168; Mon, 27
 Jun 2022 11:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220622222408.518889-1-jmattson@google.com> <YrnH+nhnbhDFAMas@google.com>
In-Reply-To: <YrnH+nhnbhDFAMas@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 27 Jun 2022 10:59:53 -0700
Message-ID: <CALMp9eS3ZbV6aEDihw4LskWQuUyLs4HawK+x_5imykngE=a39w@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Move VM-exit RSB stuffing out of line
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jun 27, 2022 at 8:08 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jun 22, 2022, Jim Mattson wrote:
> > RSB-stuffing after VM-exit is only needed for legacy CPUs without
> > eIBRS. Move the RSB-stuffing code out of line.
>
> I assume the primary justification is purely to avoid the JMP on modern CPUs?
>
> > Preserve the non-sensical correlation of RSB-stuffing with retpoline.
>
> Either omit the blurb about retpoline, or better yet expand on why it's nonsensical
> and speculate a bit on why it got tied to retpoline?

I can expand on why it's nonsensical. I cannot speculate on why it got
tied to retpoline, but perhaps someone on this list knows?

> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmenter.S | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 435c187927c4..39009a4c86bd 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -76,7 +76,12 @@ SYM_FUNC_END(vmx_vmenter)
> >   */
> >  SYM_FUNC_START(vmx_vmexit)
> >  #ifdef CONFIG_RETPOLINE
> > -     ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
> > +     ALTERNATIVE "", "jmp .Lvmexit_stuff_rsb", X86_FEATURE_RETPOLINE
> > +#endif
> > +.Lvmexit_return:
> > +     RET
> > +#ifdef CONFIG_RETPOLINE
> > +.Lvmexit_stuff_rsb:
> >       /* Preserve guest's RAX, it's used to stuff the RSB. */
> >       push %_ASM_AX
>
> There's a comment in the code here about stuffiing before RET, I think it makes
> sense to keep that before the RET, i.e. hoist it out of the actual stuffing
> sequence so that it looks like:
>
> #ifdef CONFIG_RETPOLINE
>         /* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
>         ALTERNATIVE "", "jmp .Lvmexit_stuff_rsb", X86_FEATURE_RETPOLINE
> #endif
> .Lvmexit_return:
>         RET
>
> Ha!  Better idea.  Rather than have a bunch of nops to eat through before the
> !RETPOLINE case gets to the RET, encode the RET as the default.  That allows using
> a single #ifdef and avoids both the JMP over the RET as well as the JMP back to the
> RET, and saves 4 nops to boot.

I had considered that option, but I doubt that it will be long before
someone wants to undo it. In any case, I will make that change in
version 2.

Thanks!

--jim
