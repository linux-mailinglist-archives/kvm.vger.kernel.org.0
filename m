Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14906FE29C
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjEJQgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjEJQgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 12:36:40 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A998A60
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 09:36:29 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 71dfb90a1353d-4501f454581so3340499e0c.3
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 09:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683736589; x=1686328589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAqtE+DcLfG7N8esCSyEjXIIIGiOx/x9AOYXvN/9SlM=;
        b=CpTGshtusnWTXEjPL3xyj6Ink3Lm05+td9PjyNsKg9LIlZWAx44E1f1FUkf8YdrGvC
         ZERhUvH4K+YmMCPyW5fMl4rZB4KNQyQyN+/CVVs4OhffPhIIm5pUHKH0a+5rtfwDyD3A
         ygxITiLw1Q66OfxtYwMGqyRTUOZUdLXZXyui6UWdIw0zmRft5zamXOsjBqehhvEJC3pb
         FZmZBxu1xwW01zKHdNrSrkajFTTjWbjCoUj/idyT6jC5RYpKUsq3qrGItBDe8nMJbY2g
         CG0VxXQEKbO3vmv95e7v5F1zXgN0mKrhpVoONPYGU5mEqURvtCvPTHPr4PSsJjp5LtqS
         QALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683736589; x=1686328589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAqtE+DcLfG7N8esCSyEjXIIIGiOx/x9AOYXvN/9SlM=;
        b=IDzH13/3IJo81ILIjvppXcmorYxnZuRZek2oI5Z3xsCXZol7YNa0jTMggCmOs9mjBw
         Zj/i5Vmo8yom5dzmsjfcfbuBBFBDVNmmM65dna3KmqS2KJX+MlecbPbcAMXOBUjtPRL2
         grLrb3uMpWyOL7Y9WHlNYc07/FA7aBaB5RmWW8VpEqvVX12oVuQ0y840jRqskkVmnWV0
         +9hkRnApDl0ubANL7eLgoJ6B935xHeHzIK331K+P9Mp8ze/5lVocn64PeqNaPplX4JHb
         APeSWqAhX1YX98ljIp80OrK/X+VJhVfGQRdxqGLEUG3RaBkqnvT9LXTuD5fzCYJXqtW7
         dyXA==
X-Gm-Message-State: AC+VfDyBuSrYvALQIf28mUBgqxuJ5NnzTCO0rH9cetPUfXPzmTil/fHq
        zvA+1erq8/9F5e+H59t8Cad3nRFeAQQmVupbI6TP3A==
X-Google-Smtp-Source: ACHHUZ5EfFMckPFqxx/agmbuMCP8e1njho1N7LESIeDyr7U6kHsdtUo+dh5NoajaLktBL5NsAsPI4ygc/Lcoj4eiKMI=
X-Received: by 2002:a1f:3dc1:0:b0:453:753f:ef2e with SMTP id
 k184-20020a1f3dc1000000b00453753fef2emr111943vka.8.1683736588775; Wed, 10 May
 2023 09:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
In-Reply-To: <ZFrG4KSacT/K9+k5@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 10 May 2023 09:35:52 -0700
Message-ID: <CAF7b7moan1eWqqwoGw8Qu4T2yFOZKm8PHY56g9rYsAfyPLhuLA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     David Matlack <dmatlack@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, May 9, 2023 at 3:19=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > Upon receiving an annotated EFAULT, userspace may take appropriate
> > action to resolve the failed access. For instance, this might involve a
> > UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based liv=
e
> > migration postcopy.
>
> As implemented, I think it will be prohibitively expensive if not
> impossible for userspace to determine why KVM is returning EFAULT when
> KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
> decide the correct action to take (try to resolve or bail).
>
> Consider the direct_map() case in patch in PATCH 15. The only way to hit
> that condition is a logic bug in KVM or data corruption. There isn't
> really anything userspace can do to handle this situation, and it has no
> way to distinguish that from faults to due absent mappings.
>
> We could end up hitting cases where userspace loops forever doing
> KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...
>
> Maybe we should just change direct_map() to use KVM_BUG() and return
> something other than EFAULT. But the general problem still exists and
> even if we have confidence in all the current EFAULT sites, we don't have
> much protection against someone adding an EFAULT in the future that
> userspace can't handle.

Hmm, I had been operating under the assumption that userspace would
always have been able to make the memory access succeed somehow- I
(naively) didn't count on some guest memory access errors being
unrecoverable.

If that's the case, then we're back to needing some way to distinguish
the new faults/exits emitted by user_mem_abort/kvm_faultin_pfn with
the ABSENT_MAPPING_FAULT cap enabled :/ Let me paste in a bit of what
Sean said to refute the idea of a special page-fault-failure set in
those spots.

(from https://lore.kernel.org/kvm/ZBoIzo8FGxSyUJ2I@google.com/)
On Tue, Mar 21, 2023 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Setting a flag that essentially says "failure when handling a guest page =
fault"
> is problematic on multiple fronts.  Tying the ABI to KVM's internal imple=
mentation
> is not an option, i.e. the ABI would need to be defined as "on page fault=
s from
> the guest".  And then the resulting behavior would be non-deterministic, =
e.g.
> userspace would see different behavior if KVM accessed a "bad" gfn via em=
ulation
> instead of in response to a guest page fault.  And because of hardware TL=
Bs, it
> would even be possible for the behavior to be non-deterministic on the sa=
me
> platform running the same guest code (though this would be exteremly unli=
klely
> in practice).
>
> And even if userspace is ok with only handling guest page faults_today_, =
I highly
> doubt that will hold forever.  I.e. at some point there will be a use cas=
e that
> wants to react to uaccess failures on fast-only memslots.
>
> Ignoring all of those issues, simplify flagging "this -EFAULT occurred wh=
en
> handling a guest page fault" isn't precise enough for userspace to blindl=
y resolve
> the failure.  Even if KVM went through the trouble of setting information=
 if and
> only if get_user_page_fast_only() failed while handling a guest page faul=
t,
> userspace would still need/want a way to verify that the failure was expe=
cted and
> can be resolved, e.g. to guard against userspace bugs due to wrongly unma=
pping
> or mprotecting a page.

I wonder, how much of this problem comes down to my description/name
(I suggested MEMFAULT_REASON_PAGE_FAULT_FAILURE) for the flag? I see
Sean's concerns of the behavior issues when fast-only pages are
accessed via guest mode or via emulation/uaccess. What if the
description of the fast-only fault cap was tightened to something like
"generates vcpu faults/exits in response to *EPT/SLAT violations*
which cannot be mapped by present userspace page table entries?" I
think that would eliminate the emulation/uaccess issues (though I may
be wrong, so please let me know).

Of course, by the time we get to kvm_faultin_pfn we don't know that
we're faulting pages in response to an EPT violation... but if the
idea makes sense then that might justify some plumbing code.
