Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF9B5F4A22
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 22:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJDUKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 16:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJDUKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 16:10:44 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AB6205FF
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 13:10:42 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id b5so13573149pgb.6
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 13:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=bUt2mdAF7otp0r4ftE1Z18HsnkLrCvYit9wnkIHZzWg=;
        b=K7tqhlh0shAHpErw/QZIhzhx1aFKorhOn/1DSzxKM4MpXTkIwPih06Z0XDnu6bLSUK
         V17SkduW8R7UW3RJz24vNA97YZSzFt+AV66s/LkMYjsBjfzmBT56izsPAuBFhgxAyCd9
         kSYJfRbKefuacvUbJTqx/QIFW6OZlp38RJsHKMtqaErUWTJJ/3ZPQ9knO7NV6RW8Wcwq
         HIy/IlCr0fuqLdpBynnYkbn3h3TZiOmG8tFMAF/PXCrUOFw0nx9KetgowjBI05n1sb0l
         JkF794wMmGoQgFZNGsn/rWpwDuCzNUQqieUmehEJ8NRM6eHx0xtxfCQiPcgVGth8Z1xp
         SQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bUt2mdAF7otp0r4ftE1Z18HsnkLrCvYit9wnkIHZzWg=;
        b=75YrkZYFoFkNMQuEhJ4poQ2Yf3vslaT5k9z2yYrUF/nZq9/X+ZFWYvYhfbulpUUi06
         yEWLjTi/t64/dC6Rn9OjmwQSnDfQGmGgBOTV4mccUtMeLo7ZN3javiA/3YDiqKUWvk1E
         GqbLQTph+YsLayGxDvFeU0KAS5MlCJD04AKHqoZVJVYB1KdJExXbmF+jxyeDQMS+W0Ju
         3pQs8ve3lbNWvmaI6JRz1bd7o+RxejJeUqMDkvRjwOG5DzQL2F2Uyhd6156GOHboTpGv
         3h9Poax2uVAAJWtCOGHr5dzr6W1LKjcQ0b+rkJrifBsSfB3EZYHhlrpP5ww4NTvP0Kb7
         kIdw==
X-Gm-Message-State: ACrzQf39QG/AnnyrL4gL2pvY8rP9W25UM4DOgL40PaLtz1L3yKENPIhY
        adT3kPk8pI6vXZk6cc6XTzg+rg==
X-Google-Smtp-Source: AMsMyM6ye+7zccNHVe1i9Aos20+BMDv4dot4aBRHW3kbHMzA0BV8UDUIkQ3RN2oCUZGPMGEEHF5iuw==
X-Received: by 2002:a63:120b:0:b0:43c:771b:4c52 with SMTP id h11-20020a63120b000000b0043c771b4c52mr25057356pgl.370.1664914242145;
        Tue, 04 Oct 2022 13:10:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bb5-20020a170902bc8500b00172751a2fa4sm9303853plb.80.2022.10.04.13.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:10:41 -0700 (PDT)
Date:   Tue, 4 Oct 2022 20:10:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     David Matlack <dmatlack@google.com>, x86 <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [V2 PATCH 3/8] KVM: selftests: Add arch specific post vm load
 setup
Message-ID: <YzyTPXbuMot2Y0vf@google.com>
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-4-vannapurve@google.com>
 <Yyt586xOWrNEoCYF@google.com>
 <CAGtprH8=wjQAhpr97KNsziT_jAqSS6sMTb5=gzgbhssNPm8q_Q@mail.gmail.com>
 <YzsC4ibDqGh5qaP9@google.com>
 <CAGtprH-YuA=b-oJDZnvZ5u1EfNPuwUvrbYE0fU2L2KHzu5Af_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtprH-YuA=b-oJDZnvZ5u1EfNPuwUvrbYE0fU2L2KHzu5Af_g@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022, Vishal Annapurve wrote:
> On Mon, Oct 3, 2022 at 8:42 AM Sean Christopherson <seanjc@google.com> wrote:
> > Even better, call it from __vm_create() and name it something like
> > kvm_arch_vm_post_create().  Like David said, while the hook has a dependency on
> > being called after loading the ELF image, the action that arch code is expected
> > to take doesn't have anything to do with loading the ELF image.
> >
> > And then instead of introducing an arch hook with no implementation, the patch that
> > adds the hook can instead use it to replace the x86-64 #ifdef in __vm_create().
> >
> 
> Today upstream kernel selftests don't have scenarios where
> kvm_vm_elf_load can get called directly outside ___vm_create but there
> are selftests that are up for review [1], [2] that may call
> kvm_vm_elf_load directly. Above suggestion will not work in this
> scenario, is it suitable to assume that all the callers of
> kvm_vm_elf_load will eventually execute kvm_arch_vm_post_create?

No, but that's irrelevant.  And actually, in any reasonable hypothetical situation
I can think of, it's actually undesirable to always call kvm_arch_vm_post_create()
after kvm_vm_elf_load().

Hypothetically, if there were a use case where kvm_vm_elf_load() is called multiple
times, then stuffing the "Intel vs. "AMD" flag should only be done for the binary
that actually defines that flag.  The flag is defined by the library's processor.c,
and so the hook should be tied to the library's loading of its binary, i.e. to the
creation of the VM.

If a test were loading multiple binaries, and the test wanted to tweak things
specific to a binary after loading said binary, then the test can and should do
that without needed a library arch hook.

If the arch hook was to take action specific to loading _any_ binary, than yes, a
hook in kvm_vm_elf_load() would be in order, but this hook is about taking action
when creating a VM, not to loading a binary.

But this is all very, very hypothetical.  I can't think of a scenario where
loading multiple binaries would be less complex than solving whatever hypothetical
problem makes it difficult to link everything into a single binary.

And if a test manually loads a binary _and_ wants to actually run the guest after
doing vm_create_barebones() or ____vm_create(), then the test is doing it wrong,
as those low level APIs are provided _only_ for cases where a test doesn't need
to run vCPUs.
