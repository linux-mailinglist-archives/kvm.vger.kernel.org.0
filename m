Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771F3750A72
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjGLOIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjGLOIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:08:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1096112E
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:08:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c595cadae4bso7124941276.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689170927; x=1691762927;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61Bb86vxt9PpkUcz935uJ7O0G2xXf3VyMbaMcGvnRT4=;
        b=Yti+bExW+ZX8aBNYkyF+7gOY1gDsT3YtIr0sz8jtb963EUPi0YHptmlxRpIgAq8krX
         rPvaFqHisX5lV6SnBLuIkaldD0tpF0thm7rcn1IUMpgg5bAJFxMDVEOv+3BBSFX5DE0R
         RAdIvHkn2Znuw+IpLcTp3ImsK9G+ose7oBNwwmHO61RmWaCe+LIjW8Nd4Kp55AWwC8BT
         IifqYHvOs0oQokFE+9PRt78v1CemvelioyZaWix/B9QEZtg5Xo0otlPF2nm5o/uUTSVT
         NS4JxshMd/kSwIeu0oiAJPt7U5ivim6aiipUfyHBdWP4anir08CAFDVnbc8me5EBJZn0
         8Aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689170927; x=1691762927;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=61Bb86vxt9PpkUcz935uJ7O0G2xXf3VyMbaMcGvnRT4=;
        b=WdqvprZOxlSkg1myEk/y7g3lHIRa2RMGAm2R4wb+NLY65gb8kEx7zcgqMkTDT1CizT
         dwP2FXM/jSLJurLHX7mcxVeXL69NftJFiSPSKkvzlV5I61GBwnrbOl6I8pP2Bkd4ISzU
         eYR+Emo7Woe8gab3adT41NnMKXP+OQkjABjiSEosS4XVSnc8XViYAHOrwUGm38pAZEl1
         QyF0HM7XHitk4/2PX4C+zzFseo/OPuh0u7cZuj3f2yXqe1RbSijco5kByPE5hXN1rRT1
         0nwpKo/3fJhJhrBuN7bpK4Gt1FjfbFGI0Kma6lSWsXVcS6e5OumcR632ZEtZIH0hY/QD
         QkMg==
X-Gm-Message-State: ABy/qLavWMoX5np4aLZAl+q7Ur1kygztmMptxgsIIqJGArsghdag7l7l
        EMSt6yMmfm3/LuNZq6GQlNBaAp8iwgM=
X-Google-Smtp-Source: APBJJlHCEzVLrClhpPb8qPoDTeJqu/2HP+RHYiydI+UaZZBLeQbY5BG0fq3uGfdwzCnf84xvbcW4T8rCazs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:90e:0:b0:bc0:bfa7:7647 with SMTP id
 a14-20020a5b090e000000b00bc0bfa77647mr129497ybq.0.1689170927305; Wed, 12 Jul
 2023 07:08:47 -0700 (PDT)
Date:   Wed, 12 Jul 2023 07:08:45 -0700
In-Reply-To: <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-6-amoorthy@google.com>
 <ZIoQoIe+UF6qix5v@google.com> <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Message-ID: <ZK6z7dkTmdeiwVrL@google.com>
Subject: Re: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023, Anish Moorthy wrote:
> On Wed, Jun 14, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > static int __kvm_write_guest_page(struct kvm *kvm,
> >     struct kvm_memory_slot *memslot, gfn_t gfn,
> >     const void *data, int offset, int len)
> > {
> >     int r;
> >     unsigned long addr;
> >
> >     addr =3D gfn_to_hva_memslot(memslot, gfn);
> >     if (kvm_is_error_hva(addr))
> >         return -EFAULT;
> > ...
>=20
> Is it ok to catch these with an annotated efault? Strictly speaking
> they don't seem to arise from a failed user access (perhaps my
> definition is wrong: I'm looking at uaccess.h) so I'm not sure that
> annotating them is valid.

IMO it's ok, and even desirable, to annotate them.  This is a judgment call=
 we
need to make as gfn=3D>hva translations are a KVM concept, i.e. aren't cove=
red by
uaccess or anything else in the kernel.  Userspace would need to be aware t=
hat
an annotated -EFAULT may have failed due to the memslot lookup, but I don't=
 see
that as being problematic, e.g. userspace will likely need to do its own me=
mslot
lookup anyways.

In an ideal world, KVM would flag such "faults" as failing the hva lookup, =
and
provide the hva when it's a uaccess (or gup()) that fails, i.e. provide use=
rspace
with precise details on the unresolved fault.  But I don't think I want to =
take
that on in KVM unless it proves to be absolutely necessary.  Userspace *sho=
uld*
be able to derive the same information, and I'm concerned that providing pr=
ecise
*and accurate* reporting in KVM would be a maintenance burden.
