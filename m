Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AD753AC25
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355958AbiFARnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 13:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352351AbiFARn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 13:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C75B562F5
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654105405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6BLB2gLrtWTmqHLdaD8wGnrxw89DVNlSXSVPV7mKqCI=;
        b=f7KoiYlR/+WywMd7+iCzFaK96aEq+1lt4FFlYyuo3a1/JD31c8PsUiI3BxKOmW8fjzQu9K
        Ss/vV34QSHtRgAH3Axhg3INSewTDIHQqHOFO6OjgJ9bR8TynYxb60rxHFjm5j9qdhA3ZWo
        Mfli5q1T7Nas0BWhTSOAAjeJoZQwcmw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-I1fzRALYNVOM1-4flu2Bwg-1; Wed, 01 Jun 2022 13:43:24 -0400
X-MC-Unique: I1fzRALYNVOM1-4flu2Bwg-1
Received: by mail-ej1-f72.google.com with SMTP id q5-20020a17090676c500b00704ffb95131so1305380ejn.8
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 10:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6BLB2gLrtWTmqHLdaD8wGnrxw89DVNlSXSVPV7mKqCI=;
        b=IfRy6uRP82ao+3+j8CnhjGuCy3i7lPdRLIVodmFC17glJYNvI5+o05QHDGayK5u/5K
         6swmX8wyr0Vhu9DCSU4yDrCTL5+BiVYBqiEQIVPZO2QGgzM91ragU0MHtAYkp+nfZAw8
         4BFrOpnx6Bmz23JWpccIKTJPq87HOPHf+RjDOs50o4bufwQACUmqMynBQDg6boPdNB+w
         pE5e2PMojIFiZE+q4X/Wp+08G9USSje7gBwwTqUNAyY9pbB8Pi/1Uz5aW7t0H9FoSpqy
         UUwbwhLG85GSgwwntSQvY3+646HDd8cTZmbCVb9sudqz99jEQ6mzBn0/5qX2QEHFIK6/
         7kVw==
X-Gm-Message-State: AOAM531WnQpMyVe0P9R0i99IQw2so+0kv4kjFGyMM8H/VGkNFoiz152b
        k+5bb8XpbdTw+YAiJUQHOA9M1QU4uwy8Me5jhbEBRb2tnO8MNbVdZJ7VqE0Igs5U+wP+Y4Dmk7W
        N21gYOB5XFmGO
X-Received: by 2002:a05:6402:3047:b0:42a:fbe9:4509 with SMTP id bs7-20020a056402304700b0042afbe94509mr950710edb.159.1654105403236;
        Wed, 01 Jun 2022 10:43:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRK/A1ovwzs06X89Jk5sYZzWGZ1fkaJMWH9s0wqgLv5syfmm6CjaSzZsZRBaYuam6h+Qlw+A==
X-Received: by 2002:a05:6402:3047:b0:42a:fbe9:4509 with SMTP id bs7-20020a056402304700b0042afbe94509mr950695edb.159.1654105403025;
        Wed, 01 Jun 2022 10:43:23 -0700 (PDT)
Received: from gator (cst2-175-76.cust.vodafone.cz. [31.30.175.76])
        by smtp.gmail.com with ESMTPSA id l15-20020aa7c3cf000000b0042bdb6a3602sm1208363edr.69.2022.06.01.10.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 10:43:22 -0700 (PDT)
Date:   Wed, 1 Jun 2022 19:43:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
Message-ID: <20220601174320.hniqb3roqdxkgdbj@gator>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-2-cross@oxidecomputer.com>
 <686aae9b-6877-7d7a-3fd4-cddb21642322@redhat.com>
 <CAA9fzEE3tdJuNwNDzbcoUQ39He7hKf2X=u-RAvq8fSHwD=3JZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9fzEE3tdJuNwNDzbcoUQ39He7hKf2X=u-RAvq8fSHwD=3JZA@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 01:09:13PM -0400, Dan Cross wrote:
> On Wed, Jun 1, 2022 at 3:03 AM Thomas Huth <thuth@redhat.com> wrote:
> > On 26/05/2022 19.39, Dan Cross wrote:
> > > Change x86/Makefile.common to invoke the linker directly instead
> > > of using the C compiler as a linker driver.
> > >
> > > This supports building on illumos, allowing the user to use
> > > gold instead of the Solaris linker.  Tested on Linux and illumos.
> > >
> > > Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> > > ---
> > >   x86/Makefile.common | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/x86/Makefile.common b/x86/Makefile.common
> > > index b903988..0a0f7b9 100644
> > > --- a/x86/Makefile.common
> > > +++ b/x86/Makefile.common
> > > @@ -62,7 +62,7 @@ else
> > >   .PRECIOUS: %.elf %.o
> > >
> > >   %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
> > > -     $(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
> > > +     $(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
> > >               $(filter %.o, $^) $(FLATLIBS)
> > >       @chmod a-x $@
> >
> >
> >   Hi,
> >
> > something seems to be missing here - this is failing our 32-bit
> > CI job:
> >
> >   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/2531237708
> >
> > ld -T /builds/thuth/kvm-unit-tests/x86/flat.lds -nostdlib -o x86/taskswitch2.elf \
> >         x86/taskswitch2.o x86/cstart.o lib/libcflat.a
> > ld: i386 architecture of input file `x86/taskswitch.o' is incompatible with i386:x86-64 output
> > ld: i386 architecture of input file `x86/cstart.o' is incompatible with i386:x86-64 output
> > ld: i386 architecture of input file `lib/libcflat.a(argv.o)' is incompatible with i386:x86-64 output
> > ld: i386 architecture of input file `lib/libcflat.a(printf.o)' is incompatible with i386:x86-64 output
> > ...
> >
> > You can find the job definition in the .gitlab-ci.yml file (it's
> > basically just about running "configure" with --arch=i386).
> 
> Thanks. I think the easiest way to fix this is to plumb an
> argument through to the linker that expands to `-m elf_i386`
> on 32-bit, and possibly, `-m elf_x86_64` on 64-bit. The
> architecture specific Makefiles set the `ldarch` variable,
> and that doesn't seem used anywhere, but I see that's set
> to match the string accepted by the linker scripts/objcopy,
> not something acceptable to `-m`. However, one can add
> something to `LDARGS`, but I see that that's set to include
> the contents of CFLAGS, which means it includes flags
> that are not directly consumable  by the linker itself.
> 
> I think the simplest way forward is to introduce a new
> variable in x86/Makefile.i386 and x86/Makefile.x86_64 and
> refer to that in x86/Makefile.common; possibly `LDEXTRA`?

We do that for arm, but call that argument arch_LDFLAGS.

> I've got an updated patch here that does that, and it seems
> to work (building under both illumos and arch locally), but
> before I send up another patchset, let me know if that
> sounds acceptable?

It does to me.

Thanks,
drew

