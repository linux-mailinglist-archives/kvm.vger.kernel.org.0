Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C198786234
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 23:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbjHWVSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 17:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbjHWVRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 17:17:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AC710DF
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 14:17:37 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-79233311de2so121223339f.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 14:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692825456; x=1693430256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikCtusfTIERSZQgcg1mFeqjKSQ/EZVCFYlWC+HDCtmw=;
        b=zp1ypRyBx04BkTszpYvgREt7D/4bRPcNvftZHL2LE+kw6IFe4MN471OyCop7YzkXdX
         EuK5A0yvKMCodY4S4DX+6jIN4OjKlZC9CYsASWPMW5L9y5KwLfcQWOcsFynu0ijyEGCB
         erNbALn+3zOiuU2sdD6Bsb8u2HI6LQZH49phH8BOQMOmDu960DTSd0noryj/Rir/mT06
         xBWpF4HoceCDEnUgTj5DSSAsGLUkf0Llbkg+LV/Dgo9Po/Q0SgU4rjFJKWiv1QZBPq1r
         v2wmhEqhhLdAYxsEY/NWe6szFeh5Z7rED1xv4jhvBCRTZc6/Gy0GiGKuGtlMRR8yHGWY
         x94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692825456; x=1693430256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikCtusfTIERSZQgcg1mFeqjKSQ/EZVCFYlWC+HDCtmw=;
        b=WxRDIFb/O3p6r8q2qikj8zYpdJCaNjm+Ht2zzdeNcsr8n6TShoaOX1PMY1IDK0F3Cp
         X7/5615DAYwsU9oDb6ZixJNCba2yIudJw6NAjCZgtlgHni4kUQrBRLpZWhL9FLMHP/vb
         uenoU+GqcmSmeKAFPsJGbEmIPhul/Jsf3/sPh4b5MMG9gdUGKaQR04zLQa6j9OTRG/qq
         lrndi7P6J8lFwgkjW49jPx+AfqhdYCV9Mf/2527HEufFV8IrqhzAclMg/jtM7XpaAvSx
         dcuZrtSmrH0/b1AY2m6BVcves9VvbvkSs5q52k2yWVyPrrmiUtImksezrylHFkjF0IO7
         rAeQ==
X-Gm-Message-State: AOJu0Yw1cO3ZhvxeDiazW2AsdLrRbmxxSIfU74FnrEtZh8+pT5rG3xr/
        JCLUp0x1n6rWcfUbt0wMUxGT5PItDyUMtMqAb7iwKQ==
X-Google-Smtp-Source: AGHT+IEhxH/m+zLly/AlA1+BkNJxLXP3R4qoW0MHefIxcR/d8irHqdZJWWTVtuvTr3KbcOCax1/lnLR+zGAbFa0Kveo=
X-Received: by 2002:a5e:c902:0:b0:791:2194:10a2 with SMTP id
 z2-20020a5ec902000000b00791219410a2mr4156419iol.15.1692825456667; Wed, 23 Aug
 2023 14:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <ZIovz22R5dm05u6/@google.com>
In-Reply-To: <ZIovz22R5dm05u6/@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 23 Aug 2023 14:17:00 -0700
Message-ID: <CAF7b7mpoMjXjQe33EKfYc4QTD2rr0UYGuFNEELpenqBrzuTP=Q@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
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

On Wed, Jun 14, 2023 at 2:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Gah, got turned around and forgot to account for @atomic.  So this?
>
>         if (!atomic && memslot_is_nowait_on_fault(slot)) {
>                 atomic =3D true;
>                 if (async) {
>                         *async =3D false;
>                         async =3D NULL;
>                 }
>         }
>
> > +
> >         return hva_to_pfn(addr, atomic, interruptible, async, write_fau=
lt,
> >                           writable);
> >  }

Makes sense to me, although I think the documentation for hva_to_pfn(),
where those async/atomic parameters eventually feed into, is slightly
off

> /*
>  * Pin guest page in memory and return its pfn.
> * @addr: host virtual address which maps memory to the guest
> * @atomic: whether this function can sleep
> ...
> */
> kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 >     bool *async, bool write_fault, bool *writable)

I initially read this as "atomic =3D=3D true if function can sleep," but I
think it actually means to say "atomic =3D=3D true if function can *not*
sleep". So I'll add a patch to change the line to

> @atomic: whether this function is disallowed from sleeping

I'm pretty sure I have things straight: if I don't though, then we
can't upgrade the __gfn_to_pfn_memslot() calls to "atomic=3Dtrue" like
you suggested above.
