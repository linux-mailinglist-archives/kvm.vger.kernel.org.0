Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0715160B4EC
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiJXSII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiJXSHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:07:51 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA0209F8B
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 09:48:46 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id 7so2541246ilg.11
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T2Jc4h32Bt0aci9GRSoaXhxrr2DTvIRQnULZdhlZTa8=;
        b=AzixFi1++1+BH63uq85wUr3BnbsDe3/LM/MNLw/PQ4sHZvfEjPZc61Q3nK9QqysBXo
         Fl3+kAIu6n3CYQMFUMy0+wV3fq2mvSGUC0Q73DAtq9GuLyKA2DIbf5kf9Rp51NmKMJLQ
         bilp2h2NmCbPVTHhCrnsgIl7kHr79AwXZPQptXQsjmD8SO++waq0yF7xu6bm/jdtfl6m
         BByNSMZWWaYWDwMU1aaPTop71GIOVEkMYVOeJtfUTbyiPfyDCIOkT7FFF1TFdNED4dS/
         kKKvoCbRb0/dUoevMB0sNHi41zq72buEJSz9WzCFGg2Tdc2zFQI/kUTVLtPr0n2NGvTj
         oDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T2Jc4h32Bt0aci9GRSoaXhxrr2DTvIRQnULZdhlZTa8=;
        b=mJAYMf1kaQ5LwfLvk9qrf4SYjRZf11Djt5XMnPvdaxk0wJ73N3Zn19O0yA8HWc2DXm
         XDmeoLD4s9jdHrpUheunXk6VfD1P45JcMEmkLijXC4k0239VgvIbIgqizto7OGXNGZGO
         HoaNf0bO0KYR8Q9yAo2N9Htk9I+RYHFs64XK8ZJdAayxEz0vT8mm24BYqzvRODMVal/q
         RK7AzgiJtE2WuZfeEBWgGpShSUILOkQYSyNC/EdgO/TKxc4kgWqTMYDuUfQP8VikUkTB
         pBsfVRT4PbUd6GpJQCydiV+xbni/QTm2WKoe5dtaDRLTTlnUUp4VJxMdssRCRE5x63Be
         khkw==
X-Gm-Message-State: ACrzQf3BgKej62nlnycrLELXjxZ/hfxLqqRUVoMBMxdHgtOlkavFjNE5
        X4jjH2wK+e8KR9414sQZwQByirc2Ay/BBA==
X-Google-Smtp-Source: AMsMyM5qvqgAkhlxowJoUG+IIyARDd++VCvHVwc3NUyZYvrqlIKJvMCiTP7dWqeESp271koBuPn4Xw==
X-Received: by 2002:a63:1301:0:b0:457:f3b7:238b with SMTP id i1-20020a631301000000b00457f3b7238bmr28730628pgl.262.1666627833794;
        Mon, 24 Oct 2022 09:10:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902eb9200b00178650510f9sm19354763plg.160.2022.10.24.09.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:10:33 -0700 (PDT)
Date:   Mon, 24 Oct 2022 16:10:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for
 apic local timer
Message-ID: <Y1a49abli07rqyww@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-3-mlevitsk@redhat.com>
 <Y1GeEoC7qMz40QDc@google.com>
 <de3d97ff23cc401e916b15b47207b45514446e4d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de3d97ff23cc401e916b15b47207b45514446e4d.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> On Thu, 2022-10-20 at 19:14 +0000, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > +       // ensure that a pending timer is serviced
> > > +       irq_enable();
> > 
> > Jumping back to the "nop" patch, I'm reinforcing my vote to add sti_nop().  I
> > actually starting typing a response to say this is broken before remembering that
> > a nop got added to irq_enable().
> 
> OK, although, for someone that doesn't know about the interrupt shadow (I
> guess most of the people that will look at this code), the above won't
> confuse them, in fact sti_nop() might confuse someone who doesn't know about
> why this nop is needed.

The difference is that sti_nop() might leave unfamiliar readers asking "why", but
it won't actively mislead them.  And the "why" can be easily answered by a comment
above sti_nop() to describe its purpose.  A "see also safe_halt()" with a comment
there would be extra helpful, as "safe halt" is the main reason the STI shadow is
even a thing.

On the other hand, shoving a NOP into irq_enable() is pretty much guaranteed to
cause problems for readers that do know about STI shadows since there's nothing
in the name "irq_enable" that suggests that the helper also intentionally eats the
interrupt shadow, and especically because the kernel's local_irq_enable() distills
down to a bare STI.
