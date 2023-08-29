Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0FF78CF95
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 00:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbjH2Wmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 18:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjH2WmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 18:42:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9986799
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 15:42:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c8b2d6784so69778007b3.3
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693348920; x=1693953720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NfKYOUWJKujqhAL9bj61xdP5t/swDE5J2YV48AsFeLw=;
        b=H9eWKzp4PkmxZpn6YtnPEnswAy9DFoZ3M6go7RlejhURjDfFW4f1bVpnEwQPll4nIQ
         CizfJJa8iJZrEAgZ4pzAeO4GTiX7rougfSNwOr8RyRpEIEt/2SXnrBS+RIm9x7IVdUOE
         1Aw71AXofmUbe9NBkg6qL2OI61s8ROqrS5RuU86R1FGZd2Ex8uGr3ZS7Xt8zk2VCBveD
         xN7c+sfX6l47XKOXMovrwOA3JYVUIyNw2QwvLUOwFCZiMwjxjDah735msAXUw8YCt/RW
         vsgjZjTObpTDDqoFcqHZjwLHXCpHOurzyMJ8GiBibB8KY+tC/CVFM6MvEzmo6LpIWr03
         8nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693348920; x=1693953720;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NfKYOUWJKujqhAL9bj61xdP5t/swDE5J2YV48AsFeLw=;
        b=b1TalrfbpMLDPxX0UM3ZVuk28iND2XPjlxyGhmMzPFFmlhkHxis3ysMA03MPagxC46
         Up88UL7lomlY4CrXRHmWaObwS7bsdZ4ZUpnxYFt5mrYzrsDh2OyT++3UnDfALbFUhqHc
         /I5nRq76F0PMedQPmsYfzx9lNQWQKQfOfHsWSu6lYtni0o3QKHy2YVYy5iBtAaNvEIKj
         e/A+75U3D7MIkKSt4f3LewGtqB9RIKZ3UzDKUOvdvpRKPZqowjy/kFe5Lpyv9PQt2dgP
         OQGpBZWI447cwvmkX+NSmEZimPL5Q7KQyzFJ5p0lWlajJy2Au24iDJyPQ5uCZ1rck40g
         LLeQ==
X-Gm-Message-State: AOJu0YzIYzj58WnMKslGkDVBjXQIBL+RYOMTLlfXOpPq9k7vgHQlM/BP
        /gT7EpGdbFmGzAGk3Qqbw6x7EE++8L4=
X-Google-Smtp-Source: AGHT+IFDtr+UG0XzXNJd6A7M+Ez0JFqFqiH7hicurxzg0SOstWJNnask1AeNWk2cOXDGJCB9i4psoVYDLFA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f4d:0:b0:d7b:9552:438c with SMTP id
 h13-20020a255f4d000000b00d7b9552438cmr13427ybm.8.1693348919909; Tue, 29 Aug
 2023 15:41:59 -0700 (PDT)
Date:   Tue, 29 Aug 2023 15:41:58 -0700
In-Reply-To: <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
 <ZK11Sxobf53RsAmH@google.com> <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
Message-ID: <ZO50Nvl5QaQMmNqX@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Thu, Aug 24, 2023, Anish Moorthy wrote:
> On Tue, Jul 11, 2023 at 8:29=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Well, that description is wrong for other reasons.  As mentioned in my =
reply
> > (got snipped), the behavior is not tied to sleeping or waiting on I/O.
> >
> > >  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort()
> > > and into __gfn_to_pfn_memslot() means that, obviously, other callers
> > > will start to see behavior changes. Some of that is probably actually
> > > necessary for that documentation to be accurate (since any usages of
> > > __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot flag)=
,
> > > but I think there are consumers of __gfn_to_pfn_memslot() from outsid=
e
> > > KVM_RUN.
> >
> > Yeah, replace "in response to page faults" with something along the lin=
es of "if
> > an access in guest context ..."
>=20
> Alright, how about
>=20
> + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS
> + The presence of this capability indicates that userspace may pass the
> + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS flag to
> + KVM_SET_USER_MEMORY_REGION. Said flag will cause KVM_RUN to fail (-EFAU=
LT)
> + in response to guest-context memory accesses which would require KVM
> + to page fault on the userspace mapping.
>=20
> Although, as Wang mentioned, USERFAULT seems to suggest something
> related to userfaultfd which is a liiiiitle too specific. Perhaps we
> should use USERSPACE_FAULT (*cries*) instead?

Heh, it's not strictly on guest accesses though.

At this point, I'm tempted to come up with some completely arbitrary name f=
or the
feature and give up on trying to describe its effects in the name itself.

> On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > However, do we actually need to force vendor code to query nowait?  At =
a glance,
> > the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslo=
t() are
> > in flows that play nice with nowait or that don't support it at all.  S=
o I *think*
> > we can do this?
>=20
> On Wed, Jun 14, 2023 at 2:23=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Gah, got turned around and forgot to account for @atomic.  So this?
> >
> >         if (!atomic && memslot_is_nowait_on_fault(slot)) {
> >                 atomic =3D true;
> >                 if (async) {
> >                         *async =3D false;
> >                         async =3D NULL;
> >                 }
> >         }
> >
> > > +
> > >         return hva_to_pfn(addr, atomic, interruptible, async, write_f=
ault,
> > >                           writable);
> > >  }
>=20
> Took another look at this and I *think* it works too (I added my notes
> at the end here so if anyone wants to double-check they can). But
> there are a couple of quirks
>=20
> 1. The memslot flag can cause new __gfn_to_pfn_memslot() failures in
> kvm_vcpu_map() (good thing!) but those failures result in an EINVAL
> (bad!). It kinda looks like the current is_error_noslot_pfn() check in
> that function should be returning EFAULT anyways though, any opinions?

Argh, it "needs" to return -EINVAL because KVM "needs" to inject a #GP if t=
he guest
accesses a non-existent PFN in various nested SVM flows.  It's somewhat of =
a moot
point though, because kvm_vcpu_map() can't fail, KVM just isn't equipped to=
 report
such failures out to userspace.

> 2. kvm_vm_ioctl_mte_copy_tags() will see new failures. This function
> has come up before (a) and it doesn't seem like an access in a guest
> context. Is this something to just be documented away?

We'll need a way to way for KVM to opt-out for kvm_vcpu_map(), at which poi=
nt it
makes sense to opt-out for kvm_vm_ioctl_mte_copy_tags() as well.

> 3. I don't think I've caught parts of the who-calls tree that are in
> drivers/. The one part I know about is the gfn_to_pfn() call in
> is_2MB_gtt_possible() (drivers/gpu/drm/i915/gvt/gtt.c), and I'm not
> sure what to do about it. Again, doesn't look like a guest-context
> access.

On x86, that _was_ the only one.  You're welcome ;-)

https://lore.kernel.org/all/20230729013535.1070024-9-seanjc@google.com
