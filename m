Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90D777EBD8
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346604AbjHPVaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346519AbjHPV3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:29:43 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4046C1FD0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:29:31 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-791b8525b59so2306443241.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692221370; x=1692826170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlcbRLxSS9LJxSfztLkyLAJRRpXHnMpareK1YLEXhh8=;
        b=LSHhMsW41PTgH3YTb+e8PZKig6HyY6Drph3GPlflLxEgpiZVP4/6mvaBBknLkzx7DY
         qYnOAiEg9BrIRQiL0N/zHwJ2Dy8XXAmFbdNTj0D+kRFVIzeYZU3pcJv8yDCHCg0KXyXQ
         +ghop3iVqkFWQSJZwMbZzBLoV8wrC5MsuBCIEUXp7Yb+kq6tXfv02mdFzCmPS8HvcFzs
         k361vZVKLKD7yaybs+fYvYzV+jExZ+o44J6TmCvCw5oSc/W8L5UOBLRqR5QN4N8EdUIA
         E6kB0/Qu7IEsg972YNeCwjLRY3hwwa8NksShW89ifQWd1ud5pbNKgQhy0n3QKz+TvfAw
         WMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692221370; x=1692826170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlcbRLxSS9LJxSfztLkyLAJRRpXHnMpareK1YLEXhh8=;
        b=Zij2r3CJfdGzydVsFHaIj1P6+XnkY5YtczIDLx1cHcAqxaEGro+AbE1y+f7oic+wzI
         ndYhQyU+zTFiZZPMcDUzTf9Y9udQrpjghQdSDZS0+c1Ipsf9HObiSOlG3SbDxBWEbrvU
         oaa6EU7krYqo7I0R2WWh4A+GZwzl1p4bU720xT5y56kYsM7p95tI6VtSm1tr8gH7pfek
         OEZvQiLQHotvAOHFMjCzt7hLln+zVWQtV1xWKw/785pPqnFv0gFeOrXnwSWbIfNzGvor
         4l3wWDpTFqtN74LNtbgjCcvMeWHdChbgFkywgOpxe+4gr4wD9r1R+bhcVZbToA5/y1Ll
         mMQA==
X-Gm-Message-State: AOJu0YywTfXVNCLRXayOpOwyRflRq0tl3NoVRIQ6U3JB9p0nnxyBEMFQ
        Jc+OqkWqoENsmWlsJqxqOsx3oo5SoTRMJmHFL6c5/g==
X-Google-Smtp-Source: AGHT+IGPuiV8gPvloD58PgsLpwUsBkS4qGPhk5DeyvH9pk/s9V/9rokUEZVAEoYKMJdthCiTbd5tU7COfpAaEq3lgJ8=
X-Received: by 2002:a1f:ccc6:0:b0:486:3e05:da14 with SMTP id
 c189-20020a1fccc6000000b004863e05da14mr2912659vkg.12.1692221370260; Wed, 16
 Aug 2023 14:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com>
In-Reply-To: <ZNzyHqLKQu9bMT8M@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 16 Aug 2023 14:28:54 -0700
Message-ID: <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Wed, Aug 16, 2023 at 8:58=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> That branch builds (and looks) just fine on gcc-12 and clang-14.  Maybe y=
ou have
> stale objects in your build directory?  Or maybe PEBKAC?

Hmm, so it does- PEBKAC indeed...

> I was thinking that we couldn't have two anonymous unions, and so userspa=
ce (and
> KVM) would need to do something like
>
>         run->exit2.memory_fault.gpa
>
> instead of
>
>         run->memory_fault.gpa
>
> but the names just need to be unique, e.g. the below compiles just fine. =
 So unless
> someone has a better idea, using a separate union for exits that might be=
 clobbered
> seems like the way to go.

Agreed. By the way, what was the reason why you wanted to avoid the
exit reason canary being ABI?

On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> And rather than use kvm_run.exit_reason as the canary, we should carve ou=
t a
> kernel-only, i.e. non-ABI, field from the union.  That would allow settin=
g the
> canary in common KVM code, which can't be done for kvm_run.exit_reason be=
cause
> some architectures, e.g. s390 (and x86 IIRC), consume the exit_reason ear=
ly on
> in KVM_RUN.
>
> E.g. something like this (the #ifdefs are heinous, it might be better to =
let
> userspace see the exit_canary, but make it abundantly clear that it's not=
 ABI).
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 143abb334f56..233702124e0a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -511,16 +511,43 @@ struct kvm_run {
> +       /*
> +        * This second KVM_EXIT_* union holds structures for exits that m=
ay be
> +        * triggered after KVM has already initiated a different exit, an=
d/or
> +        * may be filled speculatively by KVM.  E.g. because of limitatio=
ns in
> +        * KVM's uAPI, a memory fault can be encountered after an MMIO ex=
it is
> +        * initiated and kvm_run.mmio is filled.  Isolating these structu=
res
> +        * from the primary KVM_EXIT_* union ensures that KVM won't clobb=
er
> +        * information for the original exit.
> +        */
> +       union {
>                 /* KVM_EXIT_MEMORY_FAULT */
>                 blahblahblah
> +#endif
>         };
>
> +#ifdef __KERNEL__
> +       /*
> +        * Non-ABI, kernel-only field that KVM uses to detect bugs relate=
d to
> +        * filling exit_reason and the exit unions, e.g. to guard against
> +        * clobbering a previous exit.
> +        */
> +       __u64 exit_canary;
> +#endif
> +

We can't set exit_reason in the kvm_handle_guest_uaccess_fault()
helper if we're to handle case A (the setup vcpu exit -> fail guest
memory access -> return to userspace) correctly. But then userspace
needs some other way to check whether an efault is annotated, and
might as well check the canary, so something like

> +       __u32 speculative_exit_reason;
> +       union {
> +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> +               struct {
> +                       __u64 flags;
> +                       __u64 gpa;
> +                       __u64 len;
> +               } memory_fault;
> +               /* Fix the size of the union. */
> +               char speculative_padding[256];
> +       };

With the condition for an annotated efault being "if kvm_run returns
-EFAULT and speculative_exit_reason is..."
