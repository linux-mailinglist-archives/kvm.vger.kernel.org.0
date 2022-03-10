Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C6B4D525A
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 20:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbiCJTab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 14:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239797AbiCJTaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 14:30:30 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5492B13AA0C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 11:29:27 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dc348dab52so70040587b3.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 11:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCphOwvog5CR9xCI2b5FDRuXSQsxiJyxhbdn/smQ+b4=;
        b=XS4njOn68MemfU9zs/tszcIIbd6//uLsmy3S1DZEFiYtOKHRV2IYeJapWCCA7Pe1hk
         V4wuRcMQg5zOQH9mr3keyF7lOVNz2+b18MfH3UKyaK3UbujqhEft1q7jAKujJ/xCjyc7
         A9SQx155ypdnZM7LsJq6Q25ZAmZ9hqLB+rVFxzkLxTVA8P1r3FB2mIde/CcWmY6Qjgyr
         KXMK8jpJ4wkESb/Ee9kmquwK0qzNYJXOujYwiG9cQZUNfrdm82hEUiPQKM6FMtcc98cd
         tvWApc1rWf0PB4z/lG3mCFC0hVfbMaUXCIwCRkqOGQKNjnuio414n9kOswijILQMpldd
         e07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCphOwvog5CR9xCI2b5FDRuXSQsxiJyxhbdn/smQ+b4=;
        b=hvwEeNenn2j0OFGirIeVi4BVgef54JAZjestSMonc5hEL/FR7MBS3xl7squ1kTs6Pp
         oxfROxCnuLw7NAvq66FAECqrxBaXkKq4u6x/UgIYwFFs0uRiiZ/Ip5MQ8Q5sVycHGQyS
         kX8w+s+AbeT5iLL8OykMhskGMn4zXqdgshwa+BM20s7SGQHnfNZ7tETAg7QbIq8tDusa
         GGhc5ZwYAjH6erMPUayQ+ywyNg07qEJtuodlWbGUpLpUNGeUiYcVbQSlXpG2wo+hsT14
         9zdv1Bpwzi6Tsh5QP+0ZoKA1GdfVrMW3RCubh30E76p2eFw5z/Gp6Q1L7zqhP0fxU7Qt
         6QOA==
X-Gm-Message-State: AOAM532dBlI6ZLQZDW6Pl0ObVJVlLbSdtkc1objjk0LEJA1IVLNVv90+
        pa/0cH72SZj+DYH1OP/l59N/Ov6qWpAR2JELWTEPIQ==
X-Google-Smtp-Source: ABdhPJwzfDlXw81/eBIXOSlMhPCdutKwJXBijhpTgzHMP1CnJwbpPMTeI+5VMc38WWfyFmQP94nX3V9NcNDr0WM9olw=
X-Received: by 2002:a81:91cb:0:b0:2dc:bad:5873 with SMTP id
 i194-20020a8191cb000000b002dc0bad5873mr5335180ywg.156.1646940566374; Thu, 10
 Mar 2022 11:29:26 -0800 (PST)
MIME-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com> <Yio8QtuMd6COcnEw@google.com>
In-Reply-To: <Yio8QtuMd6COcnEw@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 10 Mar 2022 13:29:15 -0600
Message-ID: <CANgfPd9xr5ev7fEiwBVUi89iHkuywq-Ba9zOeCMSTFmLkO243w@mail.gmail.com>
Subject: Re: [PATCH 00/13] KVM: x86: Add a cap to disable NX hugepages on a VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
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

On Thu, Mar 10, 2022 at 11:58 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 10, 2022, Ben Gardon wrote:
> >   selftests: KVM: Wrap memslot IDs in a struct for readability
> >   selftests: KVM: Add memslot parameter to VM vaddr allocation
> >   selftests: KVM: Add memslot parameter to elf_load
>
> I really, really, don't want to go down this path of proliferating memslot crud
> throughout the virtual memory allocators.  I would much rather we solve this by
> teaching the VM creation helpers to (optionally) use hugepages.  The amount of
> churn required just so that one test can back code with hugepages is absurd, and
> there's bound to be tests in the future that want to force hugepages as well.

I agree that proliferating the memslots argument isn't strictly
required for this test, but doing so makes it much easier to make
assertions about hugepage counts and such because you don't have your
stacks and page tables backed with hugepages.

Those patches are a lot of churn, but at least to me, they make the
code much more readable. Currently there are many functions which just
pass along 0 for the memslot, and often have multiple other numerical
arguments, which makes it hard to understand what the function is
doing.

I don't think explicitly specifying memslots really adds that much
overhead to the tests, and I'd rather have control over that than
implicitly cramming everything into memslot 0.

If you have a better way to manage the memslots and create virtual
mappings for / load code into other memslots, I'm open to it, but we
should do something about it.
