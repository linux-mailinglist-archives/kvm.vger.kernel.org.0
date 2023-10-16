Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C624E7CB125
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjJPRQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjJPRQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:16:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA636181
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 10:07:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3296b3f03e5so4126974f8f.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 10:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697476062; x=1698080862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+zQrYEvXnLCHkkOB8VHblH7XpBcPGsp++uxmjtzIDQ=;
        b=R5q5if37bmR9W0Obgf+OkjD3jRitvtuP7yWFnjCjVRl6OxOIcEMUQEKMD5pdkK3bmU
         /8GIdFp6zGwT7ytd+2t7X9eBL38eef9g3qqPMAIKbztCkpZyXWn/ZbbEl3uSAt/IAfyt
         PTatdPbs7dgfm+dEMBWB0OdwV3igSVocR8Sebt11vmj06zTawLLp7q950KbqajENhaaz
         L/sxxXTgdSpv9YpS0KkZHIpvZnROGRFuYgGtimVCeImL5zuA/ygH5dMrEZgpK4o1zWvc
         rjFvGxWvK2jHVY/LFmlX4FrBoDchHCnSXcdeZ/GlGAp6/HWfxFefk/23wZHTyTr1yu/r
         oyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697476062; x=1698080862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+zQrYEvXnLCHkkOB8VHblH7XpBcPGsp++uxmjtzIDQ=;
        b=BjFEmdSJPuYwWbrUtLie4ak65LWbegWql/GeIPwPJlMaiSBk/CuBLgVoYcAFQDbiET
         scvWDbOvjuqlfsTQ4E9c71EIGCYTVbmMp4JluSpJcu4o0GXdbctMLr144cq/ENUgrCBs
         4U/aNACyZFb7txKrI94o2Ooko/AytB/QkiWRBctmzFm4fiSad5/1hGo+cp0DhGg+wPCg
         F5XI19hNA181cdRCzmpnyezFjq2/5zBbK61CVinRuDcTNJeVtHvKqbWjviUcy0BZ7Dp6
         RZ4Yq1vco42toWB74/bjRuVvEgo2rzKJBhn4nY2Qunx5Af2JIz9sIE+iFCe6dIGbLzSx
         KKkQ==
X-Gm-Message-State: AOJu0YwB7tqtRliJHFVHF32WvOKgJDsYmM1AjDzlcXfX59keypBiihHq
        6zb3CvQ63QS3s8C0GSUbe6ckMTgxiXMrIf4MQmN2bg==
X-Google-Smtp-Source: AGHT+IFK6RKBNEvODd5aHPnTEVKQvQycQVUxoXfxKTVAtpxKSS6i088tsqV/S0xtwtYtI9wGd7+5xo/c/eRvSQ8KRHg=
X-Received: by 2002:a5d:5247:0:b0:32d:9585:8680 with SMTP id
 k7-20020a5d5247000000b0032d95858680mr36710wrc.4.1697476062129; Mon, 16 Oct
 2023 10:07:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <CALzav=crDptzFeAoyLrAekp--mM3Y7mFcPMW5W3YdPctkS6YUQ@mail.gmail.com> <ZSXg2CjvVb0ugikT@google.com>
In-Reply-To: <ZSXg2CjvVb0ugikT@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 Oct 2023 10:07:12 -0700
Message-ID: <CALzav=fX+cCXQBXhxvRx0KZvHP=GdbP88Kvk9pnx=Ndsf9awEw@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
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

On Tue, Oct 10, 2023 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Oct 10, 2023, David Matlack wrote:
> > On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.c=
om> wrote:
> > >
> > > +::
> > > +       union {
> > > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> > > +               struct {
> > > +                       __u64 flags;
> > > +                       __u64 gpa;
> > > +                       __u64 len; /* in bytes */
> >
> > I wonder if `gpa` and `len` should just be replaced with `gfn`.
> >
> > - We don't seem to care about returning an exact `gpa` out to
> > userspace since this series just returns gpa =3D gfn * PAGE_SIZE out to
> > userspace.
> > - The len we return seems kind of arbitrary. PAGE_SIZE on x86 and
> > vma_pagesize on ARM64. But at the end of the day we're not asking the
> > kernel to fault in any specific length of mapping. We're just asking
> > for gfn-to-pfn for a specific gfn.
> > - I'm not sure userspace will want to do anything with this information=
.
>
> Extending ABI is tricky.  E.g. if a use case comes along that needs/wants=
 to
> return a range, then we'd need to add a flag and also update userspace to=
 actually
> do the right thing.
>
> The page fault path doesn't need such information because hardware gives =
a very
> precise faulting address.  But if we ever get to a point where KVM provid=
es info
> for uaccess failures, then we'll likely want to provide the range.  E.g. =
if a
> uaccess splits a page, on x86, we'd either need to register our own excep=
tion
> fixup and use custom uaccess macros (eww), or convice the world that exte=
nding
> ex_handler_uaccess() and all of the uaccess macros that they need to prov=
ide the
> exact address that failed.

I wonder if userspace might need a precise fault address in some
situations? e.g. If KVM returns -HWPOISON for an access that spans a
page boundary, userspace won't know which is poisoned. Maybe SNP/TDX
need precise fault addresses as well? I don't know enough about how
SNP and TDX plan to use this UAPI.


>
> And for SNP and TDX, I believe the range will be used when the guest uses=
 a
> hardware-vendor-defined hypercall to request conversions between private =
and
> shared.  Or maybe the plan is to funnel those into KVM_HC_MAP_GPA_RANGE?
