Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA7A4D73F0
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 10:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiCMJYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 05:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiCMJX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 05:23:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B23810FF1
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 01:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647163370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKr9dqn8/NxnlnFSTIb6/d+Le/Vlc/vnCa6Sa4GLvaA=;
        b=eAa3npKGY4Kr6sCJhjhl7aqiUWwKzVOTPg7OaKgg3MdwtuNBn1lU6oamhFAlZBNrnNfEfF
        13YnHq4sW5i9vkfecnWq9h6nTJZK6La/9e6kmZRK8ZvOgTp9p6rXCEw8JYekEhNLVFPxTb
        WgsMXn5BGBYDPSovXcSxLGDYF1MY+KE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-ZJbb_Gv2NsG_N4Wn_gxbkw-1; Sun, 13 Mar 2022 05:22:46 -0400
X-MC-Unique: ZJbb_Gv2NsG_N4Wn_gxbkw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FC43802A67;
        Sun, 13 Mar 2022 09:22:46 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 146C3C4C7B8;
        Sun, 13 Mar 2022 09:22:43 +0000 (UTC)
Message-ID: <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Sun, 13 Mar 2022 11:22:43 +0200
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-11 at 03:27 +0000, Sean Christopherson wrote:
> The main goal of this series is to fix KVM's longstanding bug of not
> honoring L1's exception intercepts wants when handling an exception that
> occurs during delivery of a different exception.  E.g. if L0 and L1 are
> using shadow paging, and L2 hits a #PF, and then hits another #PF while
> vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
> KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
> so that the #PF is routed to L1, not injected into L2 as a #DF.
> 
> nVMX has hacked around the bug for years by overriding the #PF injector
> for shadow paging to go straight to VM-Exit, and nSVM has started doing
> the same.  The hacks mostly work, but they're incomplete, confusing, and
> lead to other hacky code, e.g. bailing from the emulator because #PF
> injection forced a VM-Exit and suddenly KVM is back in L1.
> 
> Everything leading up to that are related fixes and cleanups I encountered
> along the way; some through code inspection, some through tests (I truly
> thought this series was finished 10 commits and 3 days ago...).
> 
> Nothing in here is all that urgent; all bugs tagged for stable have been
> around for multiple releases (years in most cases).
> 
> Sean Christopherson (21):
>   KVM: x86: Return immediately from x86_emulate_instruction() on code
>     #DB
>   KVM: nVMX: Unconditionally purge queued/injected events on nested
>     "exit"
>   KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
>   KVM: x86: Don't check for code breakpoints when emulating on exception
>   KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
>   KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
>   KVM: x86: Treat #DBs from the emulator as fault-like (code and
>     DR7.GD=1)
>   KVM: x86: Use DR7_GD macro instead of open coding check in emulator
>   KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
>   KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
>   KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
>   KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
>   KVM: x86: Make kvm_queued_exception a properly named, visible struct
>   KVM: x86: Formalize blocking of nested pending exceptions
>   KVM: x86: Use kvm_queue_exception_e() to queue #DF
>   KVM: x86: Hoist nested event checks above event injection logic
>   KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential
>     VM-Exit
>   KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
>   KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
>     behavior
>   KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
>   KVM: selftests: Add an x86-only test to verify nested exception
>     queueing
> 
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>  arch/x86/include/asm/kvm_host.h               |  33 +-
>  arch/x86/kvm/emulate.c                        |   3 +-
>  arch/x86/kvm/svm/nested.c                     | 100 ++---
>  arch/x86/kvm/svm/svm.c                        |  18 +-
>  arch/x86/kvm/vmx/nested.c                     | 322 +++++++++-----
>  arch/x86/kvm/vmx/sgx.c                        |   2 +-
>  arch/x86/kvm/vmx/vmx.c                        |  53 ++-
>  arch/x86/kvm/x86.c                            | 409 ++++++++++++------
>  arch/x86/kvm/x86.h                            |  10 +-
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/svm_util.h   |   5 +-
>  .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
>  .../kvm/x86_64/nested_exceptions_test.c       | 307 +++++++++++++
>  15 files changed, 914 insertions(+), 403 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> 
> 
> base-commit: 4a204f7895878363ca8211f50ec610408c8c70aa

I am just curious. Are you aware that I worked on this few months ago?
I am sure that you even reviewed some of my code back then.

If so, could you have had at least mentioned this and/or pinged me to continue
working on this instead of re-implementing it?

Best regards,
	Maxim Levitsky


