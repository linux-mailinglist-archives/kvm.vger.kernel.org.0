Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5451D76104F
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjGYKLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 06:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjGYKLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 06:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AB510C9
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690279837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qHJHNAQ/EaLrVgiClukNB6YD2cCwQOLa9+8g/RD5pIg=;
        b=iY4wOsydtMEtxvUuDux6MVHCf2tojKmzGry+T6klLphKk6SXYPUWf5hBJrawogE13qw/PH
        2AjawmjJhIl2TYiDj9I+JHz9xDtotGkGBvQ2aEI3RZSEPDKHx/bmVODoS1rfHxEFpgH1Fy
        Hg5C7SoCJeT8AMYCsbUXtDy7h8TIMJk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-g8b4kWZMO1qPV2u-_ttHcg-1; Tue, 25 Jul 2023 06:10:36 -0400
X-MC-Unique: g8b4kWZMO1qPV2u-_ttHcg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fbe590234aso31742605e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690279835; x=1690884635;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHJHNAQ/EaLrVgiClukNB6YD2cCwQOLa9+8g/RD5pIg=;
        b=C7ZxHXlRTIt5z3gyG/ZqVdzsBmmFfaQXy4oek8rlD/L/bpcO0Iniv1+Le929aFRVI8
         rAOIwQdfzyftz6eznrzXa56nAa0CiK8dUzXGBdHNXHVD+IBHwMWdWNU7R0nsRPY5JN5t
         45HE/TjAtxFJlFtIfoPmvBbF+OFoVltmJG+B82aObT+TPAl+1wJZDwBnKm/ZALJd27sH
         lub/60BwA9L+VeVlFOSb0/oO42bN+zFJxQVxZDAaTSbkXyZtuazQ4p/hgr7TizfMjnyS
         GNa3WicyrjQvBwDjyWP1dEKry7i1k0BiC85OXrUWnlkq7kOIpjYkqKB0+bOXMQdCKv35
         JzZw==
X-Gm-Message-State: ABy/qLZcC9Nu6aHu18c7KKbZqrZjQ6oR+d7vjxccXERkIV358KxtIk7A
        c4FPvTTCItdpkR9ybNMwP4dS5TgVvYHXUZt18e1BeXR1ss47pYp4EIacpc9mZaRhCCoIqVTzljt
        /61yhie3sksaE
X-Received: by 2002:a7b:c3c8:0:b0:3fc:182:7eac with SMTP id t8-20020a7bc3c8000000b003fc01827eacmr9484347wmj.33.1690279835120;
        Tue, 25 Jul 2023 03:10:35 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEBwe5grVle2BJoQfU1CdlrA5E008mXbdTKHKW2tEfZga9rph2myp9KegOF9DFTCjiBwJ8J/Q==
X-Received: by 2002:a7b:c3c8:0:b0:3fc:182:7eac with SMTP id t8-20020a7bc3c8000000b003fc01827eacmr9484330wmj.33.1690279834786;
        Tue, 25 Jul 2023 03:10:34 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003fc17e8a1efsm15201059wmg.45.2023.07.25.03.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 03:10:34 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Zqiang <qiang.zhang1211@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH v2 15/20] context-tracking: Introduce work deferral
 infrastructure
In-Reply-To: <ZL7OoUMLZwfUttjV@lothringen>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-16-vschneid@redhat.com>
 <ZL6QI4mV-NKlh4Ox@localhost.localdomain>
 <xhsmh351dtfjj.mognet@vschneid.remote.csb> <ZL7OoUMLZwfUttjV@lothringen>
Date:   Tue, 25 Jul 2023 11:10:31 +0100
Message-ID: <xhsmhzg3ks3mw.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/07/23 21:18, Frederic Weisbecker wrote:
> On Mon, Jul 24, 2023 at 05:55:44PM +0100, Valentin Schneider wrote:
>> I can make that a 'do {} while ()' instead to force at least one execution
>> of the cmpxchg().
>>
>> This is only about reducing the race window, right? If we're executing this
>> just as the target CPU is about to enter userspace, we're going to be in
>> racy territory anyway. Regardless, I'm happy to do that change.
>
> Right, it's only about narrowing down the race window. It probably don't matter
> in practice, but it's one less thing to consider for the brain :-)
>

Ack

> Also, why bothering with handling CONTEXT_IDLE?
>

I have reasons! I just swept them under the rug and didn't mention them :D
Also looking at the config dependencies again I got it wrong, but
nevertheless that means I get to ramble about it.

With NO_HZ_IDLE, we get CONTEXT_TRACKING_IDLE, so we get these
transitions:

  ct_idle_enter()
    ct_kernel_exit()
      ct_state_inc_clear_work()

  ct_idle_exit()
    ct_kernel_enter()
      ct_work_flush()

Now, if we just make CONTEXT_TRACKING_WORK depend on CONTEXT_TRACKING_IDLE
rather than CONTEXT_TRACKING_USER, we get to leverage the IPI deferral for
NO_HZ_IDLE kernels - in other words, we get to keep idle CPUs idle longer.

It's a completely different argument than reducing interference for
NOHZ_FULL userspace applications and I should have at the very least
mentioned it in the cover letter, but it's the exact same backing
mechanism.

Looking at it again, I'll probably make the CONTEXT_IDLE thing a separate
patch with a proper changelog.

