Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D750E502F26
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348551AbiDOTOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242436AbiDOTOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 15:14:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E9621E35
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 12:11:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n8so7799321plh.1
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 12:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3MpQlOCyEaCLCDWkZ0FlQMv1gBe/PS1/FfJBbH/tHgI=;
        b=jqqDcCSeB+bShlFes1hXOtXZMkYftCC3zYaxhnDV7ErWoyt3UmAr2X0o094Pt0fXUp
         MHnX4PMuw1dgzDKIVn8w70KtcZFjwTHAl8M373GMZdSvbkuSxQmZkEKXSyZW/GTsZBJ7
         qCfkqqKAGgeqLiOfI+E9gCQDV3KjrWhLcLr39h4IQsapq6CD1Qnj+0plJ1cx0bm1BRQM
         vUct7Bg5uaZy/AtVuLM53bE1fPivYSoyfeq/uI9kWoavhaKp5s+iQXKJk88jnxa+ft0m
         s+KAi4f9fEG//THMPd2BM6TzwoudkkBCQvp/4R5wqDwG6xzcTxVZ5CbrXq0NUbgXzsfQ
         UYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3MpQlOCyEaCLCDWkZ0FlQMv1gBe/PS1/FfJBbH/tHgI=;
        b=5Qxg9QvMOtd13YqP2H9aPz2drjHTCkxGWneJWj9pmnQFxugG95THk3hGIcmuFmf1TH
         UEJL4Y86JB2WOXPJQUCag9yIHlJyGj/GBKAdPYln6mBeXzgaNfK7d/G2G+4Tb2HeL2b1
         C14+PnKZPUeOH2vrb0SsUqQNFGl/BfFtvr/oBQ22btsgt8TcmgCfdRS0aZRduBDSnzLj
         3wHqKRDc1zKk6agSynI09uWRzT7+IbsvDKSF1LvmqG4QSsP2lrR4golJwIWdDwTWSWUd
         kR4g+YdMr+YWWJIU7gJaG0oD8VUg9Y8VNZwgSsgLBpjzQEXJCSjS8C9e+o6yCxhlJ7Dm
         XgmQ==
X-Gm-Message-State: AOAM533yyT8a7mwZM0VSNLwrKf+AT92rvV7EyJXcAoBzwyZC5znKK+mu
        ONEm1b7h80q6avhvES9Go7hfiA==
X-Google-Smtp-Source: ABdhPJz0xSC1WoQ2Kv7Xs4edtmSi9WX8aqurHsfVnQ0TKRIY4L5K0HHra2wFrjyN75r3lFFNbWGCCA==
X-Received: by 2002:a17:902:bcc5:b0:158:d637:8330 with SMTP id o5-20020a170902bcc500b00158d6378330mr542386pls.134.1650049910824;
        Fri, 15 Apr 2022 12:11:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm2639095pfu.54.2022.04.15.12.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:11:50 -0700 (PDT)
Date:   Fri, 15 Apr 2022 19:11:46 +0000
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
Message-ID: <YlnDclyQmmaISvAZ@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com>
 <Yk/nid+BndbMBYCx@suse.de>
 <YlmkBLz4udVfdpeQ@google.com>
 <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
 <Ylm51s5c2t60G5sy@google.com>
 <CAA03e5FVTizMzWeO2CDS_d7ym6eoaqn1tAOe+2C=OUOPLoHz3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5FVTizMzWeO2CDS_d7ym6eoaqn1tAOe+2C=OUOPLoHz3Q@mail.gmail.com>
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
> On Fri, Apr 15, 2022 at 11:30 AM Sean Christopherson <seanjc@google.com> wrote:
> > Yes, we can and probably should add wrappers for the raw string I/O tests too.
> > But, no matter what, somehwere there has to be a helper to translate raw string
> > I/O into SEV-ES string I/O.  I don't see why doing that in the #VC handler is any
> > easier than doing it in a helper.
> 
> Hmmm... yeah, if this patch really does get vetoed then rather than
> throw it away maybe we can convert it to be loaded with a helper now.
> 
> Note: I hear your arguments, but I still don't agree with throwing
> away this patch. At least not based on the arguments made in this
> email thread. I think having a default #VC handler to handle string IO
> is better than not having one. Individual tests can always override
> it.

What test is ever going to do its own string port I/O?  String MMIO is a different
beast because REP MOVS and REP STOS can be generated by the compiler almost at will,
e.g. memcpy(), memset(), struct initialization, random for-loops, etc...

Port I/O on the other requires very deliberate code.  I doubt it's even possible
to generate string port I/O without resorting to assembly.

Outside of emulator.c, the next closest instance is the use of KVM's "force emulation
prefix", which happens to sometimes decode as INSL due to using byte 0x6d :-)

realmode.c's print_serial() has string I/O, but (a) it's #ifdef'd out by default
and (b) would be trivial to convert to a common helper.

In other words, any test that does string I/O is going to have to either open code
it in inline asm or call a helper.  I'd much prefer we enable the latter.

> From reading the other email thread on the decoder, I get the
> sense that the real reason you're opposed to this patch is because
> you're opposed to pulling in the Linux decoder. I don't follow that
> patch as well as this one. So that may or may not be a valid reason to
> nuke this patch. I'll leave that for others to discuss.

Yeah, they're very intertwined, not having to pull in a massive decoder is a big
motivation for not wanting string I/O support in the #VC handler.  But, even were
that not the case, IMO bouncing through the #VC handler for string I/O is asinine
because the source of the #VC _knows_ that it wants to do string I/O.  Just call
a helper.
