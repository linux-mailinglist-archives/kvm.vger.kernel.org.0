Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A2F7C4529
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 00:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjJJW7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjJJW7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 18:59:37 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A29E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:59:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4066692ad35so58434365e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696978753; x=1697583553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nacyxABp1UL03gZHXlkGoDpYi4y+fBMtTei3+pcLfc=;
        b=rIydxPUCeKBv3oGTFvjO0DxNI/3VhEFo1xqb3HSJ5JdbETj9BWI2Ae1bovg5ZGoh+U
         JpxvQui+67lqpBpHGhIVbhy+HQh0jWikBE8wJdnGmf4Y1jtJd0adOC5kHt5TcF8olBik
         WZvXBXWtHTC2MLwcFfBdqO84TN/MyA1dd+i4D/OcRzmXOPvLClb0oTySFott8yHVupjI
         yeT0CvaGbiGVuoEtxJKwrop+64QCfm2B7zRrio7+bTY7584c5d8T8wUxsw/7u2zJjU8U
         K7EJCXRtQcTIEgt/36QhOHsBwaH+udGGTquoqMuttLYsaJMmYtnQ4hsI+mMEJyqgLMGq
         YI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696978753; x=1697583553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nacyxABp1UL03gZHXlkGoDpYi4y+fBMtTei3+pcLfc=;
        b=SiFAF4LcyT6M3rDmzVwKIxPF3L13M/Oe/Gp1kDxfBdzc87YHnYJ0KLbt6+rnYSdRHu
         KCiWzebUBRIDkxXBgTx96ymO38ZEzGevRd1HjRtnkcWQurX6PpYB6KDsm9vVvtlyX0i/
         BW+HoSgs/x95lLv0EXs2XcXagW5lbBjad5fkdbEFguHNS8dllRV91HTX3mnbFMgLW0PG
         +ViZ4NnI92o8136LgFFFO62RL/XWRcYBsWi1zjajMIXbC1oqIojAtEX3uGky27hvoPaE
         +0f3W7WubWrY9o/NBgNkxx1f0lR8ecKOhcdPZ6nu94oWhdlRpAg63vEEBqf6NwyIjHiE
         ZMPw==
X-Gm-Message-State: AOJu0YzkRKI37SagwnxuIbJzTUC9cjhD2DgmyKnuo5sqqiYyISg8Tshn
        H06DzOW5vDbVGC4iOYd3OpaS2qAKXYnTqnLxS1yRwQ==
X-Google-Smtp-Source: AGHT+IFH+SOajooUfNwv0nZc5mlpLm234ee1vlA7EQQjes00sGcgpxOTQ+PCLWi4VGGu6ePaHkbbxNCMiY0cEJ/uN34=
X-Received: by 2002:adf:e852:0:b0:315:9e1b:4ea6 with SMTP id
 d18-20020adfe852000000b003159e1b4ea6mr16525699wrn.58.1696978752971; Tue, 10
 Oct 2023 15:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-5-amoorthy@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 10 Oct 2023 15:58:43 -0700
Message-ID: <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
> besides a return value of -1 and errno of EFAULT when a vCPU fails an
> access to guest memory which may be resolvable by userspace.
>
> Add documentation, updates to the KVM headers, and a helper function
> (kvm_handle_guest_uaccess_fault()) for implementing the capability.
>
> Mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86, even
> though EFAULT annotation are currently totally absent. Picking a point
> to declare the implementation "done" is difficult because
>
>   1. Annotations will be performed incrementally in subsequent commits
>      across both core and arch-specific KVM.
>   2. The initial series will very likely miss some cases which need
>      annotation. Although these omissions are to be fixed in the future,
>      userspace thus still needs to expect and be able to handle
>      unannotated EFAULTs.
>
> Given these qualifications, just marking it available here seems the
> least arbitrary thing to do.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
[...]
> +::
> +       union {
> +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> +               struct {
> +                       __u64 flags;
> +                       __u64 gpa;
> +                       __u64 len; /* in bytes */

I wonder if `gpa` and `len` should just be replaced with `gfn`.

- We don't seem to care about returning an exact `gpa` out to
userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
userspace.
- The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
vma_pagesize on ARM64. But at the end of the day we're not asking the
kernel to fault in any specific length of mapping. We're just asking
for gfn-to-pfn for a specific gfn.
- I'm not sure userspace will want to do anything with this information.
