Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4A58A3FA
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbiHDXoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiHDXoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:44:17 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6B17171B
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:44:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q7so1397868ljp.13
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MYpPnNYYRuA37g2a2Va2k82yWFk09zlElGc9XDuWnSs=;
        b=FTwjcIb/srKxRRbBqvpJ06fYmJjau68uzGbLTesB1oFsOO7lNJlXHYUYFpW1KvmJoy
         FPTk7i6awCzVR27iwbftj3AG49Ug6bEew2r3qD8FOuC+3jnrppS5taw5X7x4w3EJTi2m
         nu2ORpB3Uz0El1sgr58Plv/TYZ0pJQz6jAO7WCJflrru6p+FGZSwML3dwZSofIzF4AJ6
         XMH+u+md3KYC+BLxBtnKb4bj5rpYXn825k+cvAX1qWhe7zzXcV4BpqIYluQW7aNGT+YK
         H8OxwRdhNe6PN8dN2XQN8Nblcbw1115JP5YVPh4BwGKk1+a+XW74/LMo0yjATvn5Mjun
         432Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MYpPnNYYRuA37g2a2Va2k82yWFk09zlElGc9XDuWnSs=;
        b=j9fbO1gVc7oaKYJercpiq8+ddF8nnp3EeBlRHrpZVPDUwyB4OfDeFVu6xBcaZicTIL
         7o4dOcu3YV5qG7VSeP4ySXM8z8QcXddV+/3eIQLeaBlf7WcgY9ap4dAJFroXlUCbH/53
         +c8N+5GNoKPcfFp1JQsVfQG8pKAVgzeD9OwdIHARdPmAKaUnIdKu2c1RY4erGPafw3qN
         TyyXYcItyxunm7bSGxsLLtb8y0FD+LE0CgsGiZDECMhb+tDTlqTk+7iUGieihCxCFQPN
         7zMy7Li6o8cX9QIX5eZZvRJGiWNyqW1HHd37j6R3PnedhJGOkylFKOMu4abkCg8D770m
         eMOA==
X-Gm-Message-State: ACgBeo2BWTmzeYYfCetTU56WZ9EV1ecXIuIyxJmwdhni5AvGegsclyRg
        56yuNWhN7GxsC2z4rg7JZAiWb5yqiNMA6Q/zJdl5GA==
X-Google-Smtp-Source: AA6agR74kW0u66mRgCpycAF0GIRARSp98NVY/1DMqszGKi68DR/MhsISDtA1DgL/ydMsEfCd8Dan8yoxVMRRIxuMcqk=
X-Received: by 2002:a2e:81c1:0:b0:24b:f44:3970 with SMTP id
 s1-20020a2e81c1000000b0024b0f443970mr1198098ljg.97.1659656655026; Thu, 04 Aug
 2022 16:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
 <YuxOHPpkhKnnstqw@google.com> <YuxU/VXlSwVip7ys@google.com>
In-Reply-To: <YuxU/VXlSwVip7ys@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 4 Aug 2022 16:43:48 -0700
Message-ID: <CALzav=ft-kUHrKGPrc8C73=pYf7Na9iaAxtfaeV=PCmHJNimzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Aug 4, 2022 at 4:23 PM Sean Christopherson <seanjc@google.com> wrote:
> On Thu, Aug 04, 2022, David Matlack wrote:
> > On Thu, May 05, 2022 at 11:14:31AM -0700, isaku.yamahata@intel.com wrote:
> > > +#ifdef CONFIG_X86_64
> > > +#define SHADOW_NONPRESENT_VALUE    BIT_ULL(63)
> > > +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> > > +#else
> > > +#define SHADOW_NONPRESENT_VALUE    0ULL
> > > +#endif
> >
> > The terminology "shadow_nonpresent" implies it would be the opposite of
> > e.g.  is_shadow_present_pte(), when in fact they are completely
> > different concepts.
>
> You can fight Paolo over that one :-)  I agree it looks a bit odd when juxtaposed
> with is_shadow_present_pte(), but at the same time I agree with Paolo that
> SHADOW_INIT_VALUE is also funky.
>
> https://lore.kernel.org/all/9dfc44d6-6b20-e864-8d4f-09ab7d489b97@redhat.com

Ah ok, thanks for the context.

>
> > Also, this is a good opportunity to follow the same naming terminology
> > as REMOVED_SPTE in the TDP MMU.
> >
> > How about EMPTY_SPTE?
>
> No, because "empty" implies there's nothing there, and it very much matters that
> the SUPPRESS_VE bit is set for TDX.

Fair point. My other idea was INITIAL_SPTE but that's already covered
by Paolo's objection above :)

I'll change my vote to NONPRESENT_SPTE.
