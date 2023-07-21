Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF12F75CB05
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjGUPJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 11:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjGUPI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 11:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD2230D2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689952090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0XnA9BE8o3D7MPThucf/ZBJtbCoqYoCMw1W8WX/w6k=;
        b=EHkYpasJZsFd5iXjGYYJco08SR4fRzI2pdenG1qOmKr026tnnZu0snIEKydQmpBe/xTPMM
        3i9U3ESpqqF0IAUTgi4AfObTzST4M5bYa+iUKWP+NqGcwhXfr5TvJY4nUBRf7QCbqmh3P4
        gUbCAHy+zW0tFdC3tEPqLKZ5kSx85rA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Kw2rH-D5MOySXGpzMz54LA-1; Fri, 21 Jul 2023 11:08:08 -0400
X-MC-Unique: Kw2rH-D5MOySXGpzMz54LA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f5df65fa35so11112155e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689952087; x=1690556887;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0XnA9BE8o3D7MPThucf/ZBJtbCoqYoCMw1W8WX/w6k=;
        b=YAW3HmvfwoEqzDAS9ZqozWQET7cu1B1ywhGMZrRZMD/vBVdHKS+d2I1VvoFsbPyYF8
         js8LqnPsSWK+7cdP3nECMJwN6/qEGuEzNDATvvijzdqVdLR6gDkj+aowNASySQVPqUNB
         e8BJM5ydJQESKiGk/UmR7Lq3Yb8te4saJeGodWNVa+RxbDwlaFJ5AUWAKfY4iue6cbRG
         w67f9RRAiwKoCa7Ceu3fGBfgMUn5OJv322+ov6E6iiqRK7Gy9bIPJcAI4AZWNXmsvV6V
         SSieq7LTokzE5al52GD133Ae2PHvbzMePS3S+NBMBfb86fT6XBOSBSU2eVaocHGnyu1E
         yjSQ==
X-Gm-Message-State: ABy/qLZRZBULi3hyWphhKco8kBZGNcc5/V1ERVdE+7YcAm1ciOyZniC0
        1i2qsu78IwvrtOvN/lV/MMZX7E8/Z8mEZS5gnP9j95QxxzSG5HUgfBa3WOlZW2iH5WmclHZBM+4
        RY0N/q0HOnIG8
X-Received: by 2002:a5d:65d0:0:b0:311:180d:cf38 with SMTP id e16-20020a5d65d0000000b00311180dcf38mr1610850wrw.24.1689952087593;
        Fri, 21 Jul 2023 08:08:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHaTM5vQ7KW9sCHDc43jdJFwo9+cb7+zAoGs4JK1/FURFo7hfFESg+0SCq3xlf/D0c/gEW3UQ==
X-Received: by 2002:a5d:65d0:0:b0:311:180d:cf38 with SMTP id e16-20020a5d65d0000000b00311180dcf38mr1610794wrw.24.1689952087302;
        Fri, 21 Jul 2023 08:08:07 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id j6-20020adfff86000000b0031274a184d5sm4426018wrr.109.2023.07.21.08.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 08:08:06 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     paulmck@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
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
        Frederic Weisbecker <frederic@kernel.org>,
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
Subject: Re: [RFC PATCH v2 17/20] rcutorture: Add a test config to torture
 test low RCU_DYNTICKS width
In-Reply-To: <7d2fdbb7-e574-40e8-8561-40a3873abc88@paulmck-laptop>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-18-vschneid@redhat.com>
 <24b55289-1c35-41cc-9ad3-baa957f1c9cb@paulmck-laptop>
 <5143d0a9-bc02-4b9a-8613-2383bfdee35c@paulmck-laptop>
 <xhsmhmszpu24i.mognet@vschneid.remote.csb>
 <7d2fdbb7-e574-40e8-8561-40a3873abc88@paulmck-laptop>
Date:   Fri, 21 Jul 2023 16:08:04 +0100
Message-ID: <xhsmhcz0lti97.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/23 07:07, Paul E. McKenney wrote:
> On Fri, Jul 21, 2023 at 08:58:53AM +0100, Valentin Schneider wrote:
>> On 20/07/23 21:00, Paul E. McKenney wrote:
>> > On Thu, Jul 20, 2023 at 12:53:05PM -0700, Paul E. McKenney wrote:
>> >> On Thu, Jul 20, 2023 at 05:30:53PM +0100, Valentin Schneider wrote:
>> >> > diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE11 b/tools/testing/selftests/rcutorture/configs/rcu/TREE11
>> >> > new file mode 100644
>> >> > index 0000000000000..aa7274efd9819
>> >> > --- /dev/null
>> >> > +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE11
>> >> > @@ -0,0 +1,19 @@
>> >> > +CONFIG_SMP=y
>> >> > +CONFIG_NR_CPUS=8
>> >> > +CONFIG_PREEMPT_NONE=n
>> >> > +CONFIG_PREEMPT_VOLUNTARY=y
>> >> > +CONFIG_PREEMPT=n
>> >> > +CONFIG_PREEMPT_DYNAMIC=n
>> >> > +#CHECK#CONFIG_TREE_RCU=y
>> >> > +CONFIG_HZ_PERIODIC=n
>> >> > +CONFIG_NO_HZ_IDLE=n
>> >> > +CONFIG_NO_HZ_FULL=y
>> >> > +CONFIG_RCU_TRACE=y
>> >> > +CONFIG_RCU_FANOUT=4
>> >> > +CONFIG_RCU_FANOUT_LEAF=3
>> >> > +CONFIG_DEBUG_LOCK_ALLOC=n
>> >> > +CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
>> >> > +CONFIG_RCU_EXPERT=y
>> >> > +CONFIG_RCU_EQS_DEBUG=y
>> >> > +CONFIG_RCU_LAZY=y
>> >> > +CONFIG_RCU_DYNTICKS_BITS=2
>> >>
>> >> Why not just add this last line to the existing TREE04 scenario?
>> >> That would ensure that it gets tested regularly without extending the
>> >> time required to run a full set of rcutorture tests.
>> >
>> > Please see below for the version of this patch that I am running overnight
>> > tests with.  Does this one work for you?
>>
>> Yep that's fine with me. I only went with a separate test file as wasn't
>> sure how new test options should be handled (merged into existing tests vs
>> new tests created), and didn't want to negatively impact TREE04 or
>> TREE06. If merging into TREE04 is preferred, then I'll do just that and
>> carry this path moving forwards.
>
> Things worked fine for this one-hour-per-scenario test run on my laptop,

Many thanks for testing!

> except for the CONFIG_SMP=n runs, which all got build errors like the
> following.
>

Harumph, yes !SMP (and !CONTEXT_TRACKING_WORK) doesn't compile nicely, I'll
fix that for v3.

