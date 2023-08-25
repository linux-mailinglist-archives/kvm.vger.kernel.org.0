Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77D8787D48
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 03:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbjHYBjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbjHYBjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:39:17 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15112E78
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:38:44 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso5902861fa.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692927509; x=1693532309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx/POYl+u/ox9UBAT+N6R1uU7BmWBN58mACbgT4dbFc=;
        b=IgPNwnoQIoD5IFTHzHLJz0qkmTF6foQ1FIQ62ITShWop0XDaO5uRO/v0uibtIENJS0
         2SBIf9p4SHzS4qqx2chE38HNU3dMHWprGSAnTY+TxxMtLQEmpmtEbC29zUe2R9PG6wLT
         apY1AkjwA3u189+jpZcqTrovSkNK+4bZPHMxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692927509; x=1693532309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fx/POYl+u/ox9UBAT+N6R1uU7BmWBN58mACbgT4dbFc=;
        b=VtxsNWK+u2FmlFpyvLHnp/t+OUL9f05oGjPH3Yn7bIW/HG3lyhZIt0UxxFSFOsVYBW
         gVSruGcxWhU6S84ciWUYOYCeDSpxK3l13c4Ox5JvnxKAE+yODdRURpoUpDZ3GQhLYa7w
         7EbpTENb+hrc6J+DXqS0oLeUt84Ci17UNa9ca4+R/SVRXCIiYBVWPtyvI8VFh0pSll2u
         jheoVIEmKjh5msdXnT17FgyTieOku/g1JbCSioIyhCtI9LbHr6txRKv+Q/abT7YJ+ZmD
         NqtHkILKOqeSe8f95DrUJ2CUmAL0D9+PeUCwWLbzQkcpaTDMn0tEQQtvWbEK/6Gk3igc
         cPrg==
X-Gm-Message-State: AOJu0Yy+HLwPmksXQgYuf6kqh2MDNRAsDEfmZONfHqcvCvUUt13bfcdI
        b8/Oj566dTvjRVVlsZ7YUD/lhnE0kw5t7I5mPMVtQg==
X-Google-Smtp-Source: AGHT+IF8QkAKLg8cep3jWhzZ7Zzi5xuNU5cJIX6a5jEG1gfJzUIcb4l4LSvVNLituoBfF0v4OtnD2a6Ppxn9JvE4iZM=
X-Received: by 2002:a2e:9591:0:b0:2bc:b448:b8b2 with SMTP id
 w17-20020a2e9591000000b002bcb448b8b2mr11272065ljh.19.1692927508183; Thu, 24
 Aug 2023 18:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705102547.hr2zxkdkecdxp5tf@linux.intel.com> <CAD=HUj7F6CUNt_9txEu0upB=PBwJzkL5dBhNs_BVHX1cicqBgw@mail.gmail.com>
 <ZOd0IMeKSkBwGIer@google.com>
In-Reply-To: <ZOd0IMeKSkBwGIer@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Fri, 25 Aug 2023 10:38:16 +0900
Message-ID: <CAD=HUj6XYKGgRLb2VWBnYEEH9YQUMROBf2YBXaTOvWZS5ejhmg@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 12:15=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Aug 24, 2023, David Stevens wrote:
> > On Wed, Jul 5, 2023 at 7:25=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel=
.com> wrote:
> > >
> > > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > > @@ -4529,7 +4540,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_=
vcpu *vcpu,
> > > >
> > > >  out_unlock:
> > > >       read_unlock(&vcpu->kvm->mmu_lock);
> > > > -     kvm_release_pfn_clean(fault->pfn);
> > >
> > > Yet kvm_release_pfn() can still be triggered for the kvm_vcpu_maped g=
fns.
> > > What if guest uses a non-referenced page(e.g., as a vmcs12)? Although=
 I
> > > believe this is not gonna happen in real world...
> >
> > kvm_vcpu_map still uses gfn_to_pfn, which eventually passes FOLL_GET
> > to __kvm_follow_pfn. So if a guest tries to use a non-refcounted page
> > like that, then kvm_vcpu_map will fail and the guest will probably
> > crash. It won't trigger any bugs in the host, though.
> >
> > It is unfortunate that the guest will be able to use certain types of
> > memory for some purposes but not for others. However, while it is
> > theoretically fixable, it's an unreasonable amount of work for
> > something that, as you say, nobody really cares about in practice [1].
> >
> > [1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/
>
> There are use cases that care, which is why I suggested allow_unsafe_kmap=
.
> Specifically, AWS manages their pool of guest memory in userspace and map=
s it all
> via /dev/mem.  Without that module param to let userspace opt-in, this se=
ries will
> break such setups.  It still arguably is a breaking change since it requi=
res
> userspace to opt-in, but allowing such behavior by default is simply not =
a viable
> option, and I don't have much sympathy since so much of this mess has its=
 origins
> in commit e45adf665a53 ("KVM: Introduce a new guest mapping API").
>
> The use cases that no one cares about (AFAIK) is allowing _untrusted_ use=
rspace
> to back guest RAM with arbitrary memory.  In other words, I want KVM to a=
llow
> (by default) mapping device memory into the guest for things like vGPUs, =
without
> having to do the massive and invasive overhaul needed to safely allow bac=
king guest
> RAM with completely arbitrary memory.

Do you specifically want the allow_unsafe_kmap breaking change? v7 of
this series should have supported everything that is currently
supported by KVM, but you're right that the v8 version of
hva_to_pfn_remapped doesn't support mapping
!kvm_pfn_to_refcounted_page() pages. That could be supported
explicitly with allow_unsafe_kmap as you suggested, or it could be
supported implicitly with this implementation:

@@ -2774,8 +2771,14 @@ static int hva_to_pfn_remapped(struct
vm_area_struct *vma,
         * would then underflow the refcount when the caller does the
         * required put_page. Don't allow those pages here.
         */
-       if (!kvm_try_get_pfn(pfn))
-               r =3D -EFAULT;
+       page =3D kvm_pfn_to_refcounted_page(pfn);
+       if (page) {
+               if (get_page_unless_zero(page))
+                       WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll,
page) !=3D pfn);
+
+               if (!foll->is_refcounted_page && !foll->guarded_by_mmu_noti=
fier)
+                       r =3D -EFAULT;
+       }

-David
