Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF08581BFA
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiGZWKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 18:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 18:10:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9FC639B;
        Tue, 26 Jul 2022 15:10:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658873413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TlSEhW5r5FH7V8u0ilpe3qJsRRySGgjBNT/8jogPg5U=;
        b=IfOLQhEOFBdh2GI1RhjufTYCUbTKSYhxuShFEO9nw08K6n+vVXCRcZZq0anf1RMIXEo5eD
        RQGUEpSskY5ofdyDncU73TqThAZiNPe5f0yY1BSeLjb+lg7B4Vd4JRtGmFulr1lS+FxqOw
        qQeCLYjZxLZV4KlzfbCE1TEdpipA8yGrum6AXh0zgi0nSU6sCVs45YdXnRVUYy8+qoQfNJ
        5dmW9g/04kQVnWZ2ODK3xVrePXY+gy6vVXWzGAjvKiHl7o0HGkeXTZdtHDXJzHIU4u2BJ1
        r0Eun9k3vnCx0zLQ6OjMwRIBce0cntvCazYwx1B4pZl8KpnV1/gV03ZxOyMUVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658873413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TlSEhW5r5FH7V8u0ilpe3qJsRRySGgjBNT/8jogPg5U=;
        b=TFvHEHQlN1NtzXyqKT8ZSE+FAmHb4XY2WJMHmtUEontRKVlLUz16xu9HIwxepWm+kxPhVw
        WoRWdExpTfS11YAg==
To:     Sean Christopherson <seanjc@google.com>,
        Andrei Vagin <avagin@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
In-Reply-To: <YuAD6qY+F2nuGm62@google.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
 <YuAD6qY+F2nuGm62@google.com>
Date:   Wed, 27 Jul 2022 00:10:12 +0200
Message-ID: <875yjjttiz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26 2022 at 15:10, Sean Christopherson wrote:
> On Tue, Jul 26, 2022, Andrei Vagin wrote:
>> * It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sentry
>>   has to be fully enclosed in a VM to be able to support these technologies.
>
> Speaking of SGX, this reminds me a lot of Graphene, SCONEs, etc..., which IIRC
> tackled the "syscalls are crazy expensive" problem by using a message queue and
> a dedicated task outside of the enclave to handle syscalls.  Would something like
> that work, or is having to burn a pCPU (or more) to handle syscalls in the host a
> non-starter?

Let's put VMs aside for a moment. The problem you are trying to solve is
ptrace overhead because that requires context switching, right?

Did you ever try to solve this with SYSCALL_USER_DISPATCH? That requires
signals, which are not cheap either, but we certainly could come up with
a lightweight signal implementation for that particular use case.

Thanks,

        tglx

