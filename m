Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A41390A8F
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 22:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhEYUg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 16:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhEYUg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 16:36:56 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D7C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 13:35:25 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so29829571oth.8
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 13:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nw3GQ6SOby7isask9l3LYxuyuHctKaDOXNcCR0hpOU4=;
        b=gQnKnwu7fnc92Teir4jhZtAAFL3fILgocRAJaW1j0f2+o0mK8xYFAubww5iBbGiGLZ
         HB6/AaDdLC/H9lAAO3IBePjevWgLdZBQHL7dlEfNTLrh1nOBtbHP0R/bWhvhU1/WzgD9
         W2iv2HmZlaG6WmsN9dJWVIbzZ3L46XRzUr029RhvYSJAwqqU4VaBx2GVffA4GrG8C3vP
         AKJAziw43Byql3IYyacnGglvdHJfRzEYAgfS99XrGjXayq6/t6GqyTLbA5ILq/QlL8wV
         3nIkiM4dghWCXlcEB+CTZ4nTZds1jkbWmVNC2q3qUBTPy1zbjrQgD6nrHxSGvteMd0t5
         hcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nw3GQ6SOby7isask9l3LYxuyuHctKaDOXNcCR0hpOU4=;
        b=jEqRmhVhLJFbvSSXOxWda1kcfMP8dIhQEFKbMrXu5yf+cm50srfskDxNTjRt6Wu7Lz
         EZsPAtaeau3DGweR9UZ7TAXlIc+IsPBc+dRSGnmzzuE5SE9Y2BBEqZsLgKVobnnEarRC
         9rnincCdW/MOjla/HD8+V51ELEFOjdolqQqt0y1WTWXl/cZ5QX9/cVuJ6DfP+nowK4P7
         sEZcPpDNkNfQJ/eT7NidqQKNqaTEiThuOShS26/3MyMcM0Wkzv7WoAUgD030y7ZvCAxT
         dL7kDATiSq+5Q7G1I+lQxqojwl/JE8Yz+SbLXLW96uI7Ckx/9PDBR6pJob9f3pKn1GGO
         UJcw==
X-Gm-Message-State: AOAM531g/nzMbp9np2EPYtM7sI9FCKQbGenXSueodfZd2rq6ygA0jqNE
        UP91hDiPZWaRS1mK0ZYqIBL7lNJilkqnzs4ElFL+9w==
X-Google-Smtp-Source: ABdhPJzkvIFs1rjQzbdMV1SLAm3IXQWV4wzwii4dotQce3HngBSrmICBOdEf5go/hP6ljjzPZa4DuRZPqpqsupMMKmE=
X-Received: by 2002:a9d:684e:: with SMTP id c14mr24702007oto.295.1621974924812;
 Tue, 25 May 2021 13:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-6-jmattson@google.com>
 <CAAeT=Fy3qAk3diwEWO1NORRHg=pt=sxSB_b44du97g+oOOoqtQ@mail.gmail.com>
In-Reply-To: <CAAeT=Fy3qAk3diwEWO1NORRHg=pt=sxSB_b44du97g+oOOoqtQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 25 May 2021 13:35:13 -0700
Message-ID: <CALMp9eT4ZAjSLYzpcW_vrui4iywfVKJoU1U5RcVh1pFePyVNyQ@mail.gmail.com>
Subject: Re: [PATCH 05/12] KVM: x86: Add a return code to kvm_apic_accept_events
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 12:24 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> > @@ -9880,11 +9888,16 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >                                     struct kvm_mp_state *mp_state)
> >  {
> > +       int r = 0;
> > +
> >         vcpu_load(vcpu);
> >         if (kvm_mpx_supported())
> >                 kvm_load_guest_fpu(vcpu);
> >
> > -       kvm_apic_accept_events(vcpu);
> > +       r = kvm_apic_accept_events(vcpu);
> > +       if (r < 0)
> > +               goto out;
> > +
> >         if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
> >              vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
> >             vcpu->arch.pv.pv_unhalted)
> > @@ -9892,6 +9905,7 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >         else
> >                 mp_state->mp_state = vcpu->arch.mp_state;
> >
> > +out:
> >         if (kvm_mpx_supported())
> >                 kvm_put_guest_fpu(vcpu);
> >         vcpu_put(vcpu);
>
> With the change, if the return value from kvm_apic_accept_events()
> is < 0, kvm_arch_vcpu_ioctl_get_mpstate(), which is called from
> KVM_GET_MP_STATE ioctl, doesn't set mp_state returning 0 (success).
> It leads KVM_GET_MP_STATE ioctl to return an undefined mp_state for
> the success case.

Yikes! I think I intended to return 'r' when it is less than 0 (e.g.
the -ENXIO I introduce later in the series). However, I'm not quite
sure what to do with values of r > 0. I'll look into it and send out
v2.
