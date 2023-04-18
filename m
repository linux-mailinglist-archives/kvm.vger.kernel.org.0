Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F946E5CA0
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjDRIym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDRIyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:54:39 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D70559D0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:54:36 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l15so4868955ljq.8
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681808075; x=1684400075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMHN7KanUjqen8e6uVmp37kumpsKyjGdw6AOhbW3UBU=;
        b=0/NlYDx4EiWln6WGkyAM+LND7xNxWwQqqHb0Bagd4elMu3Fv5oW/J6WzKrzblGLgjg
         QBCRSsT1QsjFJ5LpTceQNsUjSIW/vYv4IsUI0ic3ecs4n46TAZrNdbpbP2Ae30c4qR0p
         1fgyohj177jjxFtXnbNjDtstSv19CzZqZZSBGw4LkSSOrt9u8BxODcNE/Kn5BxhdG+sQ
         qJiZXN+TLwWFx2byQR6OGeQ0p+PRhHH+Yo30+PGPl5VrUdyJxe4581ktRMnIHc0pz4bo
         w//7wMblOyDCgzc7zxTO+DS592hnbam0wNDEdEI9KWoPgbzvkjMe+7jSDks2pSsdDrE+
         +grw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681808075; x=1684400075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMHN7KanUjqen8e6uVmp37kumpsKyjGdw6AOhbW3UBU=;
        b=WM5/uQ5FKz3Q9W6YhVeVc0G0KkmFbxtkS6xCyRDOAGNwrVCLjl/NvRHUw4Wx44UxUl
         HBa1QuVv1/64slL0YACr2SSKV265jC/KdIsCIWSF3x9hYkbcVDkbgjIyfl9CSAwNihhs
         4aFIb0avlsy/YriUUB/lUGj0mAapVKCJ+OFBiYGNhZEVYke8UQEbXWasQzSYC7m4La6W
         Brk7RP1/28cSivcm12+ftCmuSS1OXJwWrABODGkPpudJGOKzlCKvMZc/z7xyONy47kD6
         ySRJl6fdnPgRCTN+XM67Y5ChsNafLI01c/jpvsf8flwKD8LIWwsHMr251CvxrAcqjxFD
         aHyg==
X-Gm-Message-State: AAQBX9esh/WSxdhZ9e0967W2n5PftbcM7zP9qcyDJv+EcPRLcq1+ZEZD
        yP3/cTOu9HAJMqdtWd9YfkIc85F5WPG2dBHwW9nb6w==
X-Google-Smtp-Source: AKy350bCEQalP/fbiKvcBmlr9tbLu3erHEDBPXKGWUTTRp3BIS6TnglUBHvT6cs+homarGk2KDPMzM/F3Nhr/3LYUsk=
X-Received: by 2002:a05:651c:1a0b:b0:2a8:647b:3024 with SMTP id
 by11-20020a05651c1a0b00b002a8647b3024mr463620ljb.25.1681808074745; Tue, 18
 Apr 2023 01:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
In-Reply-To: <ZD2bBB00eKP6F8kz@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 18 Apr 2023 09:53:58 +0100
Message-ID: <CA+EHjTwYQRg7bVo_DyVYpdxGR5wgAMopNcVfoCbP07m1YuqKdQ@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, wei.w.wang@intel.com,
        Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 8:16=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
 ....

> > So the fd content is inaccessible using the ordinary POSIX syscalls. It=
's
> > only accessible by special entities (e.g., KVM).
> >
> > Most probably I am forgetting something. But maybe that will help to fi=
nd a
> > more expressive name. Maybe :)
>
> Hidden/Concealed/etc - Too close to secretmem, suffers the "hidden from w=
hom" problem,
> and depending on the use case, the memory may not actually be concealed f=
rom the
> user that controls the VMM.
>
> Restricted - "rmem" collides with "reserved memory" in code.
>
> Guarded - Conflicts with s390's "guarded storage", has the "from whom" pr=
oblem.
>
> Inaccessible - Many of the same problems as "hidden".
>
> Unmappable - Doesn't cover things like read/write, and is wrong in the se=
nse that
> the memory is still mappable, just not via mmap().
>
> Secured - I'm not getting anywhere near this one :-)

How about "protected" ;)? _ducks_

To me the name doesn't matter much, but fwiw I have developed a liking
to "restricted", more than the previous "private", since of all of the
one-word suggestions I think it captures most of what it's trying to
do.

Cheers,
/fuad
