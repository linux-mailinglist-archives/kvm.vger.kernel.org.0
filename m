Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BE37C4598
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344154AbjJJXkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343880AbjJJXkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:40:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A99793
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:40:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d86766bba9fso8620896276.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696981209; x=1697586009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLHhlCA6SVyHFYWwV93GW9D+Ewl3smDZeYf93/ceN0Y=;
        b=qsS+sMzefWM0mlheiev4qYNHM5FsRxDnbuC4A8IsVME8kDPoCBVQsbOmr7amwMVNyV
         3yEEX9zyhu8WBgTiAQxjqC9FuQpHJmSmg69m50AtK32xfBOCX3qw4BMJz4vQcn6x7VQA
         1ayPxzbQAXAyZyiWmHme8gRIDV795dCBGupaef9uG41cwBsWe8rYlCrPClF113yhgDuy
         L8hdaTIMa7HQyGFbcuvDwU5MeCdgSuFo/AQBeOsysRVHCFl0lXXh/kFW5Bea2QXnLEat
         39sVfOPwlZY4kdo2A45XXFjEPfN30shXduIXh1AgjzUM6DKU4Oxmx5gddOQTOeIHxXTS
         vtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696981209; x=1697586009;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cLHhlCA6SVyHFYWwV93GW9D+Ewl3smDZeYf93/ceN0Y=;
        b=WMnDc5bbNKQGh7j6+O0uqOQZTGXU3Mzu0+bqd6RQ0yRgLhA6Gm8m3Q7DxBkUET1O5w
         IG8eqhE6DYdlq2ymyRRJXzYwEJdah+YDJFKDWDljio+f+lssWDRUG0lMRDTZ+WqNEuSD
         2W4ChGWFjS24uF6kWiUBOYG7y1bjQqfZSJ4bpHV+pQzeO4zVycUNBjCqb+4dzZCWmQXg
         +WQ/XoTr0KLrNzGvjcdjEzJe/qdreJ/6CDV9FgSAuF+dpZ/IipEldO/ibPTWkQXDwhmY
         F6oCQn+ve3b1V4gfIegvolN+SQc46A4HJL3PxGxGdxmZ6+jKL5fK7uKgOvHTEivCPCaF
         Z2KA==
X-Gm-Message-State: AOJu0YwNiLL4t9OB4+hpNBdz3Bn+tcR8ZItYcVsuTeBJqen8TM5ZuX5C
        5T1P8MD+8xLM8BtJKP3hSyvXXDTZIBk=
X-Google-Smtp-Source: AGHT+IEu6vz/xlJWvZL8I5SvgfFc5v5rUNmLRU3fOUbQ9vo/AgeOeVtzHLQG68iQTxM6YVfRHff9q0T4lYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:13cc:b0:d91:8876:2040 with SMTP id
 y12-20020a05690213cc00b00d9188762040mr336788ybu.5.1696981209800; Tue, 10 Oct
 2023 16:40:09 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:40:08 -0700
In-Reply-To: <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com>
Message-ID: <ZSXg2CjvVb0ugikT@google.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, David Matlack wrote:
> On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
> > besides a return value of -1 and errno of EFAULT when a vCPU fails an
> > access to guest memory which may be resolvable by userspace.
> >
> > Add documentation, updates to the KVM headers, and a helper function
> > (kvm_handle_guest_uaccess_fault()) for implementing the capability.
> >
> > Mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86, even
> > though EFAULT annotation are currently totally absent. Picking a point
> > to declare the implementation "done" is difficult because
> >
> >   1. Annotations will be performed incrementally in subsequent commits
> >      across both core and arch-specific KVM.
> >   2. The initial series will very likely miss some cases which need
> >      annotation. Although these omissions are to be fixed in the future=
,
> >      userspace thus still needs to expect and be able to handle
> >      unannotated EFAULTs.
> >
> > Given these qualifications, just marking it available here seems the
> > least arbitrary thing to do.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> [...]
> > +::
> > +       union {
> > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> > +               struct {
> > +                       __u64 flags;
> > +                       __u64 gpa;
> > +                       __u64 len; /* in bytes */
>=20
> I wonder if `gpa` and `len` should just be replaced with `gfn`.
>=20
> - We don't seem to care about returning an exact `gpa` out to
> userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
> userspace.
> - The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
> vma_pagesize on ARM64. But at the end of the day we're not asking the
> kernel to fault in any specific length of mapping. We're just asking
> for gfn-to-pfn for a specific gfn.
> - I'm not sure userspace will want to do anything with this information.

Extending ABI is tricky.  E.g. if a use case comes along that needs/wants t=
o
return a range, then we'd need to add a flag and also update userspace to a=
ctually
do the right thing.

The page fault path doesn't need such information because hardware gives a =
very
precise faulting address.  But if we ever get to a point where KVM provides=
 info
for uaccess failures, then we'll likely want to provide the range.  E.g. if=
 a
uaccess splits a page, on x86, we'd either need to register our own excepti=
on
fixup and use custom uaccess macros (eww), or convice the world that extend=
ing
ex_handler_uaccess() and all of the uaccess macros that they need to provid=
e the
exact address that failed.

And for SNP and TDX, I believe the range will be used when the guest uses a
hardware-vendor-defined hypercall to request conversions between private an=
d
shared.  Or maybe the plan is to funnel those into KVM_HC_MAP_GPA_RANGE?
