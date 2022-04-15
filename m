Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3051E502EBA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 20:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346525AbiDOSdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 14:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiDOSdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 14:33:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0355E75B
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:30:51 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 12so7687668pll.12
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v05n+eQlSZmnVlb2TIbgJZRuBy//NHBKv7OHjsEE9Ec=;
        b=QIeOg6JYi0fOwwLvrZangyrd9cA1dWj8Wm8kM3wUlFuBFh5mmXcyz2ywaPWjV4bC5Y
         kuximwkSyieQh1YEs8LVvwYnnTWr0KDF/ScI3kGsrKlYTQJj4qSGbmogM8ZiCYlENuLU
         MWFpi7sBJM2U+8VQeeb74h464VqG2RgguNAtQD9b2nCZm//G2nr+UcqOk9nkh3emJ6q+
         fo6yAjlujF+81UFzUsHjfyJbTO5xOebQjHoaELW5EmqtSMK5/ByRliLgb19RYhaQq2Kf
         lBOrxaDlBs9RY8tEES8cK7mmE3DxxY/dCqgSizJ5MVUcFM7sv/fRJMLH3ymHlFUlN52s
         TDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v05n+eQlSZmnVlb2TIbgJZRuBy//NHBKv7OHjsEE9Ec=;
        b=XW6FvnyznQwXlZy/GtSFsLMjuJEN0hsiXTy41/XhD+7Z0bx6zI7lpG2OuqDPy+uPbk
         DyU/zT/1hu8yggBiSThhXL390lCO3miy6K6IzFswI//dH384lqN8SurM5w+Kx80Q7Up3
         0Sk1jvW4HuhHTys7aHjA/C9O535Ydv2UhZWR1qlZ5A97bY8tTIEoWexzmSQGN4Fvsg2l
         NGQvXPijLgv/IUe0r8yVoKAJUvKlwegox1U5KCo3KHyTccjCU5h4P/1p/WBkmkU9CVDP
         58y+H7Apa4BkU7f1hVTyyfOadug8ULwyxvmsXK2uNSvEVUXEmY+EsuUXylXPgtBLr5by
         G+tg==
X-Gm-Message-State: AOAM530cD2l91gw6yBTB62Co9d1dcvvK2RdYi4yRWFNWooC1AQzRhEHO
        oLm4rhkth34b/6C7QnQx/ZxJEw==
X-Google-Smtp-Source: ABdhPJyyA5W3AVlcV/F9aA6Bilw6dim+3c8TGUNjiHa7tv4CFfjlQ32xQmY9Jgbshy30JLay3YvSMw==
X-Received: by 2002:a17:90a:c3:b0:1ca:54c1:a684 with SMTP id v3-20020a17090a00c300b001ca54c1a684mr201398pjd.148.1650047450483;
        Fri, 15 Apr 2022 11:30:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k25-20020aa790d9000000b00508232aecedsm3446458pfk.67.2022.04.15.11.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 11:30:49 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:30:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string
 IO for IOIO #VC
Message-ID: <Ylm51s5c2t60G5sy@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com>
 <Yk/nid+BndbMBYCx@suse.de>
 <YlmkBLz4udVfdpeQ@google.com>
 <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
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

On Fri, Apr 15, 2022, Marc Orr wrote:
> On Fri, Apr 15, 2022 at 9:57 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 08, 2022, Joerg Roedel wrote:
> > > On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> > > > On Thu, Feb 24, 2022, Varad Gautam wrote:
> > > > > Using Linux's IOIO #VC processing logic.
> > > >
> > > > How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> > > > is probably less work in the long run.
> > >
> > > The problem is that SEV-ES support will silently break if someone adds
> > > it unnoticed and without testing changes on SEV-ES.
> >
> > But IMO that is extremely unlikely to happen.  objdump + grep shows that the only
> > string I/O in KUT comes from the explicit asm in emulator.c and amd_sev.c.  And
> > the existence of amd_sev.c's version suggests that emulator.c isn't supported.
> > I.e. this is being added purely for an SEV specific test, which is silly.
> >
> > And it's not like we're getting validation coverage of the exit_info, that also
> > comes from software in vc_ioio_exitinfo().
> >
> > Burying this in the #VC handler makes it so much harder to understand what is
> > actually be tested, and will make it difficult to test the more interesting edge
> > cases.  E.g. I'd really like to see a test that requests string I/O emulation for
> > a buffer that's beyond the allowed size, straddles multiple pages, walks into
> > non-existent memory, etc.., and doing those with a direct #VMGEXIT will be a lot
> > easier to write and read then bouncing through the #VC handler.
> 
> For the record, I like the current approach of implementing a #VC
> handler within kvm-unit-tests itself for the string IO.
> 
> Rationale:
> - Makes writing string IO tests easy.

(a) that's debatable, (b) it's a moot point because we can and should add a helper
to do the dirty work.  E.g.

  static void sev_es_do_string_io(..., int port, int size, int count, void *data);

I say it's debatable because it's not like this is the most pleasant code to read:

	asm volatile("cld \n\t"
		     "movw %0, %%dx \n\t"
		     "rep outsb \n\t"
		     : : "i"((short)TESTDEV_IO_PORT),
		       "S"(st1), "c"(sizeof(st1) - 1));

> - We get some level of testing of the #VC handler in the guest kernel
> in the sense that this #VC handler is based on that one. So if we find
> an issue in this handler we know we probably need to fix that same
> issue in the guest kernel #VC handler.
> - I don't follow the argument that having a direct #VMGEXIT in the
> test itself makes the test easerit to write and read. It's going to
> add a lot of extra code to the test that makes it hard to parse the
> actual string IO operations and expectations IMHO.

I strongly disagree.  This

	static char st1[] = "abcdefghijklmnop";

	static void test_stringio(void)
	{
		unsigned char r = 0;
		asm volatile("cld \n\t"
			"movw %0, %%dx \n\t"
			"rep outsb \n\t"
			: : "i"((short)TESTDEV_IO_PORT),
			"S"(st1), "c"(sizeof(st1) - 1));
		asm volatile("inb %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
		report(r == st1[sizeof(st1) - 2], "outsb up"); /* last char */

		asm volatile("std \n\t"
			"movw %0, %%dx \n\t"
			"rep outsb \n\t"
			: : "i"((short)TESTDEV_IO_PORT),
			"S"(st1 + sizeof(st1) - 2), "c"(sizeof(st1) - 1));
		asm volatile("cld \n\t" : : );
		asm volatile("in %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
		report(r == st1[0], "outsb down");
	}

is not easy to write or read.
  
I'm envisioning SEV-ES string I/O tests will be things like:

	sev_es_outsb(..., TESTDEV_IO_PORT, sizeof(st1) - 1, st1);

	sev_es_outsb_backwards(..., TESTDEV_IO_PORT, sizeof(st1) - 1,
			       st1 + sizeof(st1) - 2));

where sev_es_outsb() is a wrapper to sev_es_do_string_io() or whatever and fills
in all the appropriate SEV-ES IOIO_* constants.

Yes, we can and probably should add wrappers for the raw string I/O tests too.
But, no matter what, somehwere there has to be a helper to translate raw string
I/O into SEV-ES string I/O.  I don't see why doing that in the #VC handler is any
easier than doing it in a helper.

> - I agree that writing test cases to straddle multiple pages, walk
> into non-existent memory, etc. is an excellent idea. But I don't
> follow how exposing the test itself to the #VC exit makes this easier.

The #VC handler does things like:

	ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;

to explicitly not mess up the _guest_ kernel.  The proposed #VC handler literally
cannot generate:

  - a string I/O request larger than 2032 bytes
  - does not reside inside the GHCB's internal buffer
  - spans multiple pages
  - points at illegal memory

And so on an so forth.  And if we add helpers to allow that, then what value does
the #VC handler provide since adding a wrapper to follow the Linux guest approach
would be trivial?

> Worst case, the kvm-unit-tests can be extended with some sort of
> helper to expose to the test the scratch buffer size and whether it's
> embedded in the GHCB or external.
