Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317A56C17FF
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjCTPTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjCTPS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:18:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8CD35EC8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:13:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 185-20020a250ac2000000b00b6d0cdc8e3bso2221716ybk.4
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679325204;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51n1GvxSf2tLhEpGLohwo8f7tWcKMcVjai7wdMxxA4w=;
        b=MYjn+GFj5Eeg+Hf6OWSbXV1sYaRK5qeYTHmor7zY2efAi6F7eET3gpN9KTmAWu7DdS
         emWUDruXz/S+TJumc2cpvIupAI69ek1TmwA+vDv/Wy436Xf7zD1qqeBRrc7AEFuJyMK2
         Egb9wSKXmG6HR+eJKPu5s9V+k96rSyXtA4ZZCaqjw2pkDBljHh/t3hF5XbKXDmsVXhw1
         bt/nxGgIfp1JyPeCmW6sOxPlRx1zmJfXF7QYdhoas5Lpy2+2jOgxi6malSbSWVlo2u0E
         /D3G28iRRkDtA9xkUvV20qbYdXfFW/oB6pUAi0+Py2YmFAjIWRFAnqPeOSyMncJH5NUW
         yZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679325204;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=51n1GvxSf2tLhEpGLohwo8f7tWcKMcVjai7wdMxxA4w=;
        b=1fpm3OZZ2kZfTbcWluXvUf/zG2Q0FwJ6mRMsa/YTbDgjLjWPlm8YMEdGwPQ813GLAF
         Q3VetW8kWvmRS2dMDfgiV1Aoh1HE3b0RqPed98AkNu+FtdLzkrRd/re+GqE6xm3NfKg7
         Y+dfQzgHmfSoTEXws74Jv7EndkZ6Y4H8W2jBal7yNURrhaVXLuuZZ6XWDKVfv0BamyqN
         QTWqMsSM+9GlXXGydqd+MK9ZgydSVjJN5fBrgPbzX9ACGo1blqAzgFP4d1X3bdbZ1Up8
         aGyWHQrmJgQp3Z2I/APgzJawriKAP7BBrCcOKQ6O6LMBEmIs5+4HcPNUZg6v5KKDWuxy
         QdSQ==
X-Gm-Message-State: AO0yUKUZ018rEN6WAG/iL2+DmOEpHEXMZPJ03RSd5+9ItHpFDH7j05kx
        0IM080sv5jGLmhQpgdK5ujQt4KjCMBo=
X-Google-Smtp-Source: AK7set+AweqyRwBweaupDr7JdVEB0QbFHttHkhWLaDl0jFrZHzcJ6tp3tm0iP3pznc8Xb+4tmynzylKaI04=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:707:0:b0:a02:a3a6:7a67 with SMTP id
 g7-20020a5b0707000000b00a02a3a67a67mr5724106ybq.11.1679325203829; Mon, 20 Mar
 2023 08:13:23 -0700 (PDT)
Date:   Mon, 20 Mar 2023 08:13:22 -0700
In-Reply-To: <CAF7b7moHksTv6c=zSEmO0zg79cs4p513oSBtGmMooXL5+7828g@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
 <ZBTTlNrWeT9f1mjZ@google.com> <CAF7b7moHksTv6c=zSEmO0zg79cs4p513oSBtGmMooXL5+7828g@mail.gmail.com>
Message-ID: <ZBh4EpKrIVGbQumu@google.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
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

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 1:17=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > And as I argued in the last version[*], I am _strongly_ opposed to KVM =
speculating
> > on why KVM is exiting to userspace.  I.e. KVM should not set a special =
flag if
> > the memslot has "fast only" behavior.  The only thing the flag should d=
o is control
> > whether or not KVM tries slow paths, what KVM does in response to an un=
resolved
> > fault should be an orthogonal thing.
>=20
> I'm guessing you would want changes to patch 10 of this series [*]
> then, right? Setting a bit/exit reason in kvm_run::memory_fault.flags
> depending on whether the failure originated from a "fast only" fault
> is... exactly what I'm doing :/ I'm not totally clear on your usages
> of the word "flag" above though, the "KVM should not set a special
> flag... the only thing *the* flag should do" part is throwing me off a
> bit. What I think you're saying is

Heh, the second "the flag" is referring to the memslot flag.  Rewriting the=
 above:

  KVM should not set a special flag in kvm_run::memory_fault.flags ... the
  only thing KVM_MEM_FAST_FAULT_ONLY should do is ..."

> "KVM should not set a special bit in kvm_run::memory_fault.flags if
> the memslot has fast-only behavior. The only thing
> KVM_MEM_ABSENT_MAPPING_FAULT should do is..."
>=20
> [1] https://lore.kernel.org/all/20230315021738.1151386-11-amoorthy@google=
.com/
>=20
> On Fri, Mar 17, 2023 at 1:54=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Strictly speaking, if y'all buy my argument that the flag shouldn't con=
trol the
> > gup behavior, there won't be semantic differences for the memslot flag.=
  KVM will
> > (obviously) behavior differently if KVM_CAP_MEMORY_FAULT_EXIT is not se=
t, but that
> > will hold true for x86 as well.  The only difference is that x86 will a=
lso support
> > an orthogonal flag that makes the fast-only memslot flag useful in prac=
tice.
> >
> > So yeah, there will be an arch dependency, but only because arch code n=
eeds to
> > actually handle perform the exit, and that's true no matter what.
> >
> > That said, there's zero reason to put X86 in the name.  Just add the ca=
pability
> > as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the docu=
mentation.
> >
> > That said, there's zero reason to put X86 in the name.  Just add the ca=
pability
> > as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the docu=
mentation.
>=20
> Again, a little confused on your first "flag" usage here. I figure you
> can't mean the memslot flag because the whole point of that is to
> control the GUP behavior, but I'm not sure what else you'd be
> referring to.
>=20
> Anyways the idea of having orthogonal features, one to -EFAULTing
> early before a slow path and another to transform/augment -EFAULTs
> into/with useful information does make sense to me. But I think the
> issue here is that we want the fast-only memslot flag to be useful on
> Arm as well, and with KVM_CAP_MEMORY_FAULT_NOWAIT written as it is now
> there is a semantic differences between x86 and Arm.

If and only if userspace enables the capability that transforms -EFAULT.

> I don't see a way to keep the two features here orthogonal on x86 and
> linked on arm without keeping that semantic difference. Perhaps the
> solution here is a bare-bones implementation of
> KVM_CAP_MEMORY_FAULT_EXIT for Arm? All that actually *needs* to be
> covered to resolve this difference is the one call site in
> user_mem_abort. since KVM_CAP_MEMORY_FAULT_EXIT will be allowed to
> have holes anyways.

As above, so long as userspace must opt into transforming -EFAULT, and can =
do
so independent of KVM_MEM_FAST_FAULT_ONLY (or whatever we call it), the beh=
avior
of KVM_MEM_FAST_FAULT_ONLY itself is semantically identical across all
architectures.

KVM_MEM_FAST_FAULT_ONLY is obviously not very useful without precise inform=
ation
about the failing address, but IMO that's not reason enough to tie the two
together.
