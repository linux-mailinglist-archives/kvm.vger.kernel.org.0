Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1360ABE3
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiJXN7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 09:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiJXN6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 09:58:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076124B0D9
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666615422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsEGJus5dAF+Gn9Y7WHOpiHrog7T5rQeSomfOikVvas=;
        b=G1DvJMGH6AsY+mmI0V43AWxuEx4OwM83fvm6doL8AKef52uYshTt/yXIQHa/Hcmb25T7Rs
        hFYgGrX/t1MioiLwhmMIhSY6noOxXkfJDZG2A2E8VAKKB0D1CaxgPVFfW9QXozH1kqAI3D
        9BxxW6R8O11tTMD7Ky495fCkOxbZo90=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-ap--7h63MZKeOM7CyAqSbw-1; Mon, 24 Oct 2022 08:37:36 -0400
X-MC-Unique: ap--7h63MZKeOM7CyAqSbw-1
Received: by mail-qk1-f199.google.com with SMTP id bk21-20020a05620a1a1500b006be9f844c59so8841550qkb.9
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SsEGJus5dAF+Gn9Y7WHOpiHrog7T5rQeSomfOikVvas=;
        b=PgrSr8pz/pH+3UvBzReIqJamdzNFfqPVakI12cdKGL+6EtXNu0rEnivqpknpnN7RFN
         lX0W8Hxq6HQZ8K5bST0KegTzvn8p9UbkyiBXNpx9T8sFQkqSFlLEOYipFdiDGzr9IAdm
         INlmGBYI/tB/BHTvxJ0PRAFeSStVdvolf/McZgaRw8NzLHY2BJx4EXGeSupl20CXCGgC
         sOKVcYTn5fR1QIX7jcrM0R8pz8E4Atyc2TwbgGwz5jv//Veqg6FVBKUUTOItNTxBsTLY
         QYaMZKaQrFle7AIgMjRrEoB6fm2TVcKQcMW6rfV2dbNCz0ymD4M8dn1v4qBdlpvoJU9f
         74Lw==
X-Gm-Message-State: ACrzQf2eiKjLjDjL3pg2MB4riFS4szQUSpoFQAqWWmPdvK0ctZjOS2+t
        TQm0Zk0aWpFMWvZJ5KmqfMDxJzSNSz7P2VYCqwSApg0yZl0od0PvNanF0NrIRWxs46iW9YQvJNK
        tHn//Q/L3/8b2
X-Received: by 2002:ac8:5a95:0:b0:39a:86a3:5032 with SMTP id c21-20020ac85a95000000b0039a86a35032mr27610847qtc.96.1666615055797;
        Mon, 24 Oct 2022 05:37:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7kZl4WWQJGfs7U0UV3FgCQy2dy0V3CSp7rYPxl6IBtYLz2Huwb2StNJpTVO8rQRtaMh2kOlw==
X-Received: by 2002:ac8:5a95:0:b0:39a:86a3:5032 with SMTP id c21-20020ac85a95000000b0039a86a35032mr27610831qtc.96.1666615055555;
        Mon, 24 Oct 2022 05:37:35 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h5-20020a05620a10a500b006bbc3724affsm14548495qkk.45.2022.10.24.05.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:37:35 -0700 (PDT)
Message-ID: <de3d97ff23cc401e916b15b47207b45514446e4d.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for
 apic local timer
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:37:32 +0300
In-Reply-To: <Y1GeEoC7qMz40QDc@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-3-mlevitsk@redhat.com> <Y1GeEoC7qMz40QDc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 19:14 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > Add a few functions to apic.c to make it easier to enable and disable
> > the local apic timer.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/apic.c | 37 +++++++++++++++++++++++++++++++++++++
> >  lib/x86/apic.h |  6 ++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> > index 5131525a..dc6d3862 100644
> > --- a/lib/x86/apic.c
> > +++ b/lib/x86/apic.c
> > @@ -256,3 +256,40 @@ void init_apic_map(void)
> >                         id_map[j++] = i;
> >         }
> >  }
> > +
> > +void apic_setup_timer(int vector, bool periodic)
> > +{
> > +       /* APIC runs with 'CPU core clock' divided by value in APIC_TDCR */
> > +
> > +       u32 lvtt = vector |
> > +                       (periodic ? APIC_LVT_TIMER_PERIODIC : APIC_LVT_TIMER_ONESHOT);
> 
> Rather than take @periodic, take the mode.  That way this funky ternary operator
> goes away and the callers are self-tdocumenting, e.g. this
> 
>         apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
> 
> is more obvious than
> 
>         apic_setup_timer(TIMER_VECTOR, true);

Makes sense. I also wanted to pass the divider, but ended up hardcoding it to 1.


>         
> > +
> > +       apic_cleanup_timer();
> > +       apic_write(APIC_TDCR, APIC_TDR_DIV_1);
> > +       apic_write(APIC_LVTT, lvtt);
> > +}
> > +
> > +void apic_start_timer(u32 counter)
> > +{
> > +       apic_write(APIC_TMICT, counter);
> > +}

Makes sense.


> > +
> > +void apic_stop_timer(void)
> > +{
> > +       apic_write(APIC_TMICT, 0);
> > +}
> > +
> > +void apic_cleanup_timer(void)
> > +{
> > +       u32 lvtt = apic_read(APIC_LVTT);
> > +
> > +       // stop the counter
> > +       apic_stop_timer();
> > +
> > +       // mask the timer interrupt
> > +       apic_write(APIC_LVTT, lvtt | APIC_LVT_MASKED);
> > +
> > +       // ensure that a pending timer is serviced
> > +       irq_enable();
> 
> Jumping back to the "nop" patch, I'm reinforcing my vote to add sti_nop().  I
> actually starting typing a response to say this is broken before remembering that
> a nop got added to irq_enable().

OK, although, for someone that doesn't know about the interrupt shadow (I guess most of the people that will look at this code),
the above won't confuse them, in fact sti_nop() might confuse someone who doesn't know about why this nop is needed.

Just a note.


Best regards,
	Maxim Levitsky

> 
> > +       irq_disable();
> > +}
> > diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> > index 6d27f047..db691e2a 100644
> > --- a/lib/x86/apic.h
> > +++ b/lib/x86/apic.h
> > @@ -58,6 +58,12 @@ void disable_apic(void);
> >  void reset_apic(void);
> >  void init_apic_map(void);
> >  
> > +void apic_cleanup_timer(void);
> > +void apic_setup_timer(int vector, bool periodic);
> > +
> > +void apic_start_timer(u32 counter);
> > +void apic_stop_timer(void);
> > +
> >  /* Converts byte-addressable APIC register offset to 4-byte offset. */
> >  static inline u32 apic_reg_index(u32 reg)
> >  {
> > -- 
> > 2.26.3
> > 
> 


