Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5460958205A
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 08:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiG0Goq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 02:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiG0Gog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 02:44:36 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CDB3B94A
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 23:44:35 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31bf3656517so165076677b3.12
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 23:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dIk2fwAV08ErsFGBkLnOZZhNa5yhNMvY3ac+VYQOigs=;
        b=FbQa9CWLgVzM61MSmBPyFGX9XBA0kbtIVSTlHrDxqFV7j9+nBUaDPM+IUXwo/wIUxG
         KPPngDX3kSul/rXj7jFnIoNpmzw1YsziS5UghXNzbGSQCw2GmedjHkmtFF9d+Vi5gbUu
         Fb6kAFhm8lDtast5qrj+uxouUqkz48c+lZ+lloD4rE3qxbkZ6O7MmYuNxYH6nu+lYkaZ
         ZqBk3LD/TBSJ3QBsNMJz74WoUcVEXc38KSO2H+/KkazhvWng04YhOfKpn6ja192YM6n6
         2nUSpoi059q0aWddmCnes3XpDmvC2G8NmEb6zgHCbUHo7SianEodgTrBRyS6lxyIEY8B
         Nr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dIk2fwAV08ErsFGBkLnOZZhNa5yhNMvY3ac+VYQOigs=;
        b=dNFfYmxjr6Qme6kZlxJ/P1l7zcFjJvk2DVWirg7zxSeuZOskIilboAqOufwuYOqelm
         BfL9looiYTzzGh8gaWvYglx6dTJDTrnIO75x4BQCxPbjCqNxHNdMm/abC5yoJ36axluE
         /gp5BpLgGGz6qdBAMde+Zth0OFZ8kFvoB6ZSggcL41t9cuKVybp/GLvpcEceMYJfuhns
         neuAyiI0QIO8KSsNdeCC5DaRinarOfQDbW9oTTDo8yJclf25qu63PE3eYRGSed8l71nc
         XBZrdDr21xiQiDBJLiR7TsPfDKSQZwYkcJtn0dAAXwmIMRq9GqHzQHDHEH103TW51dHB
         M5tQ==
X-Gm-Message-State: AJIora9tRIv9ed+C8utQJC095QMdBBZzIoyxk7ksmt4Y0ukJDD14da6r
        9uHqlOBNwC0jFAYKtQnY45KIEGRhsS4Mwqynn4iPrA==
X-Google-Smtp-Source: AGRyM1tipEd88RLhbMI7x25eWr2jW13u3yKwL9gRJHxWq0wXbqhO5fcpzdUM6gejuzUvo5aZ0pG/tzyitGNCKLOTCM8=
X-Received: by 2002:a0d:c587:0:b0:31e:8bab:394d with SMTP id
 h129-20020a0dc587000000b0031e8bab394dmr18163248ywd.107.1658904274278; Tue, 26
 Jul 2022 23:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com> <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com> <69b45487-ce0e-d643-6c48-03c5943ce2e6@redhat.com>
In-Reply-To: <69b45487-ce0e-d643-6c48-03c5943ce2e6@redhat.com>
From:   Andrei Vagin <avagin@google.com>
Date:   Tue, 26 Jul 2022 23:44:23 -0700
Message-ID: <CAEWA0a4G2VzDA0C5ujXQpeyxT98Sg1tmeaLBX7VX3g16WrwjjQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022 at 3:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 7/26/22 10:33, Andrei Vagin wrote:
...
> > == Execute system calls from a user-space VMM ==
> >
> > In this case, the Sentry is always running in VM, and a syscall handler in GR0
> > triggers vmexit to transfer control to VMM (user process that is running in
> > hr3), VMM executes a required system call, and transfers control back to the
> > Sentry. We can say that it implements the suggested hypercall in the
> > user-space.
> >
> > The sentry syscall time is 2100ns in this case.
> >
> > The new hypercall does the same but without switching to the host ring 3. It
> > reduces the sentry syscall time to 1000ns.
>
> Yeah, ~3000 clock cycles is what I would expect.
>
> What does it translate to in terms of benchmarks?  For example a simple
> netperf/UDP_RR benchmark.

* netperf in gVisor with the syscall fast path:
$  ./runsc --platform kvm --network host --rootless do netperf -H ::1
-p 12865 -t UDP_RR
MIGRATED UDP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to
::1 (::1) port 0 AF_INET6 : interval : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

212992 212992 1        1       10.00    95965.18
212992 212992

* netperf in gVisor without syscall fast path:
$  ./runsc.orig --platform kvm --network host --rootless do netperf -H
::1 -p 12865 -t UDP_RR
MIGRATED UDP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to
::1 (::1) port 0 AF_INET6 : interval : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

212992 212992 1        1       10.00    58709.17
212992 212992

* netperf executed on the host without gVisor
$ netperf -H ::1 -p 12865 -t UDP_RR
MIGRATED UDP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to
::1 (::1) port 0 AF_INET6 : interval : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

212992 212992 1        1       10.00    146460.80
212992 212992

Thanks,
Andrei
