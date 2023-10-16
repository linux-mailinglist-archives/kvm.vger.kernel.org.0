Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F67CB337
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjJPTOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJPTOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:14:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2B895
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:14:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b10c488cso75349967b3.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697483675; x=1698088475; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Urt752QAUTG+QLCfz+VOUbWX9PJy66chHqheNOJce0Q=;
        b=P1PDic/XU63dM/7/gpDvbDELlGLwZC/Q2MliC+ybi52rU/vw5bVobR5Q8X5R1qjcLG
         gg8XuH0WYTXdLXK9mIaHagdM8Tnsqs/0yrcJH6Oeelb0Cq08NsY45kZs47xvJe3NNAUX
         WhznWrsHPId1qz2rX5mxzlcxgtypDkKeqOlLJp3rYH6f7oJQC9iAhBNemo6OZjk3QyVz
         /I5WWqC6cqAAPJABDxqkwjSnmmAARAkeM9Hczs2ENewbR64EEJcwfc0JaR9dxATr9U9q
         35M8VuKe1mWtnxdqtDNrnJzoJ84SajTG/SqNuS+k6QboZT7VrbOpSOOi0FwfXtYAU7kK
         lXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697483675; x=1698088475;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Urt752QAUTG+QLCfz+VOUbWX9PJy66chHqheNOJce0Q=;
        b=ZTAu0prXXlm6fXLf6hOPEsOU0pw1TH85xyVveASvarvoeioj5BE8WYEbB0cUE/DBka
         ocn44FUnvlTInzaCgvWzD+yE/HXY7kiAxUvqcXyZLfyw3LQTChUc8fADkhrrsMDlBW3c
         dWdpdK6KSE5OB1+FSp1SKyDWHdNg13pUhoiaISnTugbUpC1ASIWLCyWIQ+8U85AFXZhb
         t9mqjP9DuJpTlWTyTgtTtcFRHXtf5Xonp5TDBaWQRMQ8JKDnNgdwABDdWDaNz3D52kP7
         GxAgTr5ZJ2OxBcX67xjG4N8SDTA5HV1j8Y0oGbHgWjYMUmZ75rHvTzEJ+sS9QPO8/83Z
         vBuA==
X-Gm-Message-State: AOJu0YwnLOlUM3SDUMkeegIX4NBC9VbpRj6PX1EXSOACm3UvoPbmJvpO
        WYtavWBkEnDg8+20HSHn0zAhah72MLc=
X-Google-Smtp-Source: AGHT+IFuvny0MZNa7a9RUY8XH9UIYONJrj/oxI+S+CEVGHd5ENG2Wt9KYaXY5plpQtr+z5nMfo9Et8ZO5gQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:58c3:0:b0:d9b:dae4:4987 with SMTP id
 m186-20020a2558c3000000b00d9bdae44987mr78248ybb.3.1697483674889; Mon, 16 Oct
 2023 12:14:34 -0700 (PDT)
Date:   Mon, 16 Oct 2023 12:14:33 -0700
In-Reply-To: <CALzav=fX+cCXQBXhxvRx0KZvHP=GdbP88Kvk9pnx=Ndsf9awEw@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
 <ZSXg2CjvVb0ugikT@google.com> <CALzav=fX+cCXQBXhxvRx0KZvHP=GdbP88Kvk9pnx=Ndsf9awEw@mail.gmail.com>
Message-ID: <ZS2LmY4BnOM8vP2C@google.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, David Matlack wrote:
> On Tue, Oct 10, 2023 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Oct 10, 2023, David Matlack wrote:
> > > On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google=
.com> wrote:
> > > >
> > > > +::
> > > > +       union {
> > > > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> > > > +               struct {
> > > > +                       __u64 flags;
> > > > +                       __u64 gpa;
> > > > +                       __u64 len; /* in bytes */
> > >
> > > I wonder if `gpa` and `len` should just be replaced with `gfn`.
> > >
> > > - We don't seem to care about returning an exact `gpa` out to
> > > userspace since this series just returns gpa =3D gfn * PAGE_SIZE out =
to
> > > userspace.
> > > - The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
> > > vma_pagesize on ARM64. But at the end of the day we're not asking the
> > > kernel to fault in any specific length of mapping. We're just asking
> > > for gfn-to-pfn for a specific gfn.
> > > - I'm not sure userspace will want to do anything with this informati=
on.
> >
> > Extending ABI is tricky.  E.g. if a use case comes along that needs/wan=
ts to
> > return a range, then we'd need to add a flag and also update userspace =
to actually
> > do the right thing.
> >
> > The page fault path doesn't need such information because hardware give=
s a very
> > precise faulting address.  But if we ever get to a point where KVM prov=
ides info
> > for uaccess failures, then we'll likely want to provide the range.  E.g=
. if a
> > uaccess splits a page, on x86, we'd either need to register our own exc=
eption
> > fixup and use custom uaccess macros (eww), or convice the world that ex=
tending
> > ex_handler_uaccess() and all of the uaccess macros that they need to pr=
ovide the
> > exact address that failed.
>=20
> I wonder if userspace might need a precise fault address in some
> situations? e.g. If KVM returns -HWPOISON for an access that spans a
> page boundary, userspace won't know which is poisoned.

As things currently stand, the -EHWPOISON case is guaranteed to be precise =
because
uaccess failures only ever return -EFAULT.  The resulting BUS_MCEERR_AR fro=
m the
kernel's #MC handler will provide the necessary precision to userspace.

Though even if -EHWPOISON were imprecise, userspace should be able to figur=
e out
which page is poisoned, e.g. by probing each possible page (gross, but doab=
le).

Ah, and a much more concrete reason to report gpa+len is that it's possible=
 that
KVM may someday support faults at sub-page granularity, e.g. if something l=
ike
HEKI[*] wants to use Intel's Sub-Page Write Permissions to make a minimal a=
mount
of guest code writable when the guest kernel is doing code patching.

> Maybe SNP/TDX need precise fault addresses as well? I don't know enough a=
bout
> how SNP and TDX plan to use this UAPI.

FWIW, SNP and TDX usage are limited to the KVM page fault path, i.e. always=
 do
precise, single-page reporting.

[*] https://lore.kernel.org/all/20230505152046.6575-1-mic@digikod.net
