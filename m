Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA36EB6B7
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 03:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbjDVB4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 21:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDVB4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 21:56:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0BBE6E
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:56:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51b85b8ecc9so1615722a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682128597; x=1684720597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IQdNhpWZDysF1UahR095KnSwqZZsAIRpm1aTBOeoxU0=;
        b=WvBNdsrmV3zKyzEzVd5WJbwXsxfW67XDwZajqzJsoe5/qS8aKiZC25DdwamG22qL6P
         pOEeHuaZK2WXX6LGpiaQNIBtapa+enyHQ3U6So6xs1wWhEwuP6g5Y87o+vFl7Ncl0FqJ
         aYPy5R3UpftMUJ2Et77SQTLDXmIxV+NGmjW43VWWPCwUWy6VQ0sym7Y44JghDOXDlOqh
         r0btZ4Wmj5NknxwgPJ8hD/0A5NAUUs1K3/nu4gi0FhzTZfOz9uhzg5kr+7AprgOPq1Ig
         Qak78Ut7eio8UZFGwrEoZe02RLOwNMhl/Q2sfzgRh2JM3lFX5eEtNS6gMx0wsVKF04EG
         uhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682128597; x=1684720597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IQdNhpWZDysF1UahR095KnSwqZZsAIRpm1aTBOeoxU0=;
        b=NLSBr27hrM3ufsWA+yxLtct1fy69UitltoiBRIu/2IHyiAKtEDoBQcXuT3MH22IWiO
         Wq9IaYvzMPfNWzw5LhcANuqOUxTPLd2i06Jb+Br7eAZ7GTxZ9X6k0L65wGtySVt+Fqly
         cdad/dzYETfnaKxcC2Cw+JkDDfk4tDJgYmJTEeUyt2ytO4ZO581n7s8tNVI+JIRTzhEU
         0wyNjZFRBcBTJlUJx0GFtlSdj87MYFWndi9Wb/W9YnPXgKa7JxqmnnJQ6tK+3zGZT9Tj
         k3wSDf4nLTAdg+D/m6Z7zpAhNUO9sHkrfDPlg0qyoniGVqCSYCJz9C0l0d+uu+cUeWuE
         R60Q==
X-Gm-Message-State: AAQBX9eAuvtAuVW8zhXW+n9VV3RxO0XpM/ER6m3C+janlJvYOCs69LSi
        OtVnT2w74fp13g8Q7pdyDTvFEnRTEB4=
X-Google-Smtp-Source: AKy350bA8nYVy6RhXf+a8EbMVXDTb5UqBhqquCV4X8ayUrrycoEk7bjzkdzHz6OFwze4Uue09C5oGDmek/0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:40c1:0:b0:50b:189d:d1a with SMTP id
 n184-20020a6340c1000000b0050b189d0d1amr1635019pga.10.1682128597618; Fri, 21
 Apr 2023 18:56:37 -0700 (PDT)
Date:   Fri, 21 Apr 2023 18:56:35 -0700
In-Reply-To: <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
Mime-Version: 1.0
References: <20230421214946.2571580-1-seanjc@google.com> <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
Message-ID: <ZEM+09p7QBJR7DoI@google.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023, David Matlack wrote:
> On Fri, Apr 21, 2023 at 2:49=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> >  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> >  {
> >         struct kvm_mmu_page *root;
> >
> > -       lockdep_assert_held_write(&kvm->mmu_lock);
> > -       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> > -               if (!root->role.invalid &&
> > -                   !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
> > +       /*
> > +        * Note!  mmu_lock isn't held when destroying the VM!  There ca=
n't be
> > +        * other references to @kvm, i.e. nothing else can invalidate r=
oots,
> > +        * but walking the list of roots does need to be guarded agains=
t roots
> > +        * being deleted by the asynchronous zap worker.
> > +        */
> > +       rcu_read_lock();
> > +
> > +       list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
>=20
> I see that roots are removed from the list with list_del_rcu(), so I
> agree this should be safe.
>=20
> KVM could, alternatively, acquire the mmu_lock in
> kvm_mmu_uninit_tdp_mmu(), which would let us keep the lockdep
> assertion and drop the rcu_read_lock() + comment. That might be worth
> it in case someone accidentally adds a call to
> kvm_tdp_mmu_invalidate_all_roots() without mmu_lock outside of VM
> teardown. kvm_mmu_uninit_tdp_mmu() is not a particularly performance
> sensitive path and adding the mmu_lock wouldn't add much overhead
> anyway (it would block for at most a few milliseconds waiting for the
> async work to reschedule).

Heh, I actually started to ping you off-list to specifically discuss this o=
ption,
but then decided that not waiting those few milliseconds might be worthwhil=
e for
some use cases.  I also couldn't quite convince myself that it would only b=
e a few
milliseconds, e.g. if the worker is zapping a fully populated 5-level root,=
 there
are no other tasks scheduled on _its_ CPU, and CONFIG_PREEMPTION=3Dn (which=
 neuters
rwlock_needbreak()).

The other reason I opted for not taking mmu_lock is that, with the persiste=
nt roots
approach, I don't think it's actually strictly necessary for kvm_mmu_zap_al=
l_fast()
to invaliate roots while holding mmu_lock for write.  Holding slots_lock en=
sures
that only a single task can be doing invalidations, versus the old model wh=
ere
putting the last reference to a root could happen just about anywhere.  And
allocating a new root and zapping from mmu_noitifiers requires holding mmu_=
lock for
write, so I _think_ we could getaway with holding mmu_lock for read.  Maybe=
.

It's largely a moot point since kvm_mmu_zap_all_fast() needs to hold mmu_lo=
ck for
write anyways to play nice with the shadow MMU, i.e. I don't expect us to e=
ver
want to pursue a change in this area.  But at the same time I was strugglin=
g to
write a comment explaining why the VM destruction path "had" to take mmu_lo=
ck.
