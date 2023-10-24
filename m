Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6388A7D5A74
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344129AbjJXS26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344117AbjJXS2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:28:55 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F39B9;
        Tue, 24 Oct 2023 11:28:53 -0700 (PDT)
Received: from [127.0.0.1] ([98.35.210.218])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39OIRcVA3383411
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 24 Oct 2023 11:27:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39OIRcVA3383411
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698172060;
        bh=oroAbK7jVyJ1hEsK6EWzfojE3csZE571ESfRCsIkU3g=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=B8BTElvtiP1+hIe3f629T3y7gl9CjCEdpQHCxMzh3kj7A+HWfpncPZeWtsJqUBTJJ
         N0B6uD+17VWHv3W/v5pWNYmoJEgugY0P9vyf7Xr5nQ/sfFss9v96oQR1fjs4wfrznB
         V9d3M5czrx2IRLCHZqBnO/GwsIaIlBZiaIz0qhpv1rXjQJYTONbBF+KLUt+yPYa+04
         DZ+q2lVOiU2iNj1UBv2mQbNkrvjO0nOOxltztSuqUrwx7NaeMON5kSerM3pibiHVaS
         jkZ+iqoguLfD/M3C14MUCHzGhenjuirZGyPRePTDrEmsT+wnhKiFTmLs7RDwRLGwGz
         NzowXbqpBrXjQ==
Date:   Tue, 24 Oct 2023 11:27:36 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
User-Agent: K-9 Mail for Android
In-Reply-To: <20231024170248.GE40044@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com> <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com> <20231024103601.GH31411@noisy.programming.kicks-ass.net> <20231024163515.aivo2xfmwmbmlm7z@desk> <20231024163621.GD40044@noisy.programming.kicks-ass.net> <20231024164520.osvqo2dja2xhb7kn@desk> <20231024170248.GE40044@noisy.programming.kicks-ass.net>
Message-ID: <DD2F34A0-4F2F-4C8C-A634-7DBEF31C40F0@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On October 24, 2023 10:02:48 AM PDT, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Tue, Oct 24, 2023 at 09:45:20AM -0700, Pawan Gupta wrote:
>
>> > > modules being within 4GB of kernel=2E
>
>FWIW, it's 2G, it's a s32 displacement, the highest most address can
>jump 2g down, while the lowest most address can jump 2g up=2E Leaving a 2=
G
>directly addressable range=2E
>
>And yeah, we ensure kernel text and modules are inside that 2G range=2E

To be specific, we don't require that it is located at any particular *phy=
sical* addresses, but all modules including the root module are remapped in=
to the [-2GiB,0) range=2E If we didn't do that, modules would have to be co=
mpiled with the pic memory model rather than the kernel memory model which =
is what they currently are=2E This would add substantial overhead due to th=
e need for a GOT (the PLT is optional if all symbols are resolved at load t=
ime=2E)

The kernel is different from user space objects since it is always fully l=
oaded into physical memory and is never paged or shared=2E Therefore, inlin=
e relocations, which break sharing and create dirty pages in user space, ha=
ve zero execution cost in the kernel; the only overhead to modules other th=
an load time (including the runtime linking) is that modules can't realisti=
cally be mapped using large page entries=2E
