Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD876947C
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 13:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjGaLRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 07:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjGaLRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 07:17:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97232E79
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690802216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+0D5IDco97vTYvh6fNm/B5oplVBZcV0X3CdU07UZHvk=;
        b=MTfLqBeNmzydu8o7PYl0NQaBneTqj+4IYUDyelf2pEZgYuMdKIfophppcTfVyhG4v5OhnL
        CD1go5dS+YDlw3NRPl+GeCJv9gIS3akE2qL+49twL+jw5SWIaEdKjzId8W7grcJBEeJnFU
        Pj0A5Y2U4daoE8TkSpRgV37c5xPNEE0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-vCKaUJd9PrGMI5XzQvVirQ-1; Mon, 31 Jul 2023 07:16:55 -0400
X-MC-Unique: vCKaUJd9PrGMI5XzQvVirQ-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-447669e08bcso675546137.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690802214; x=1691407014;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+0D5IDco97vTYvh6fNm/B5oplVBZcV0X3CdU07UZHvk=;
        b=b8UzIo41kqWrGL7St8OlqVzoGscF7rb84MIe/YCGVaG08EqE2hZNlX4V9P/3NEHl0r
         4MPvs+wo4aorb9l2E+Itmu16AXkN+XeROt9r6uRpZ0DOs5d0TKE/Y4OmmqGD9i8Wevly
         9SVNl3SzLsZ6aW6N0/2UfqcrdiBTfnfTz8lwp3XpLIw8ayPbBaDo6nxPi+PBC5jIwgjy
         udMrPtspSwHpc6mQMm5YMea84ZNNXPhWChh2b5AFsv1w0gGz/MijsVylgL5ni+NPL2/s
         l1+RNwxiQv4h6SxcxxotzwM4I7Rw0htoqgfpNLWFpwm6HquqoSv9giGnOgsZ1zCsVQuy
         uZ+g==
X-Gm-Message-State: ABy/qLZ5ziYKcpUz3BeS/dzJ4VZ8Qn27CETx/KJt9kZghhopPiNolcYn
        FzrPrNpBVqHudKkt1UandNNwAmR6+1UPakGlA+qcg278pLxE3TmKZFN48HOPRWMqwGR94pkghpA
        eC/jwDOD6vNb/
X-Received: by 2002:a67:cfc7:0:b0:443:92a5:f454 with SMTP id h7-20020a67cfc7000000b0044392a5f454mr4890262vsm.26.1690802214759;
        Mon, 31 Jul 2023 04:16:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGotwePfsXKLeBlKhf8sO13ly4OfXrqZZNVUmXDsF4Tb1xqGBmiDGw9g/K6bGBIoBOR4Hianw==
X-Received: by 2002:a67:cfc7:0:b0:443:92a5:f454 with SMTP id h7-20020a67cfc7000000b0044392a5f454mr4890212vsm.26.1690802214510;
        Mon, 31 Jul 2023 04:16:54 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id r7-20020a0c8d07000000b0063d119034a9sm3601878qvb.140.2023.07.31.04.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 04:16:53 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
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
Subject: Re: [RFC PATCH v2 13/20] context_tracking: Make
 context_tracking_key __ro_after_init
In-Reply-To: <20230728160014.vjxikkoo4rieng55@treble>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-14-vschneid@redhat.com>
 <20230728160014.vjxikkoo4rieng55@treble>
Date:   Mon, 31 Jul 2023 12:16:43 +0100
Message-ID: <xhsmha5vcs544.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/23 11:00, Josh Poimboeuf wrote:
> On Thu, Jul 20, 2023 at 05:30:49PM +0100, Valentin Schneider wrote:
>> objtool now warns about it:
>>
>>   vmlinux.o: warning: objtool: enter_from_user_mode+0x4e: Non __ro_after_init static key "context_tracking_key" in .noinstr section
>>   vmlinux.o: warning: objtool: enter_from_user_mode+0x50: Non __ro_after_init static key "context_tracking_key" in .noinstr section
>>   vmlinux.o: warning: objtool: syscall_enter_from_user_mode+0x60: Non __ro_after_init static key "context_tracking_key" in .noinstr section
>>   vmlinux.o: warning: objtool: syscall_enter_from_user_mode+0x62: Non __ro_after_init static key "context_tracking_key" in .noinstr section
>>   [...]
>>
>> The key can only be enabled (and not disabled) in the __init function
>> ct_cpu_tracker_user(), so mark it as __ro_after_init.
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>
> It's best to avoid temporarily introducing warnings.  Bots will
> rightfully complain about that.  This patch and the next one should come
> before the objtool patches.
>

Ack, I'll reverse the order of these.

> Also it would be helpful for the commit log to have a brief
> justification for the patch beyond "fix the objtool warning".  Something
> roughly like:
>
>   Soon, runtime-mutable text won't be allowed in .noinstr sections, so
>   that a code patching IPI to a userspace-bound CPU can be safely
>   deferred to the next kernel entry.
>
>   'context_tracking_key' is only enabled in __init ct_cpu_tracker_user().
>   Mark it as __ro_after_init.
>

Looks better indeed, thanks!

> --
> Josh

