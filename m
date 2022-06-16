Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B954E1A9
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 15:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiFPNQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiFPNQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 09:16:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54F2D3C4BD
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 06:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655385376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nB9yDKf10sIzmuHYwsgLVJwemxZLzqM9n4RH86XcgFc=;
        b=bjKZ71bsQ5mDZnt5GpwGPA4hGN38ejDvrReIzqlyOQiyC2OE42hlSCNAthLwMaFmizBahn
        dQs1q2qE5TAWBM3ocFv5bDesOAmrMl98FNwEa+mWxP+Jk2Fnzx+LBf3l80Fyp8nK6LhBwP
        Jd6g9cXdSORf/63affEbaXzgHCjdL5Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15--L5YKvq3OhGOjIaNURlllA-1; Thu, 16 Jun 2022 09:16:12 -0400
X-MC-Unique: -L5YKvq3OhGOjIaNURlllA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1AFE1C1448A;
        Thu, 16 Jun 2022 13:16:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49BA110725;
        Thu, 16 Jun 2022 13:16:04 +0000 (UTC)
Message-ID: <1081aa507b52a803d173a180897b9242119bb055.camel@redhat.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Thu, 16 Jun 2022 16:16:03 +0300
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
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
> along the way; some through code inspection, some through tests.
> 
> v2:
>   - Rebased to kvm/queue (commit 8baacf67c76c) + selftests CPUID
>     overhaul.
>     https://lore.kernel.org/all/20220614200707.3315957-1-seanjc@google.com
>   - Treat KVM_REQ_TRIPLE_FAULT as a pending exception.
> 
> v1: https://lore.kernel.org/all/20220311032801.3467418-1-seanjc@google.com
> 
> Sean Christopherson (21):
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
>   KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
>   KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
>     behavior
>   KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
>   KVM: selftests: Add an x86-only test to verify nested exception
>     queueing
> 
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>  arch/x86/include/asm/kvm_host.h               |  35 +-
>  arch/x86/kvm/emulate.c                        |   3 +-
>  arch/x86/kvm/svm/nested.c                     | 102 ++---
>  arch/x86/kvm/svm/svm.c                        |  18 +-
>  arch/x86/kvm/vmx/nested.c                     | 319 +++++++++-----
>  arch/x86/kvm/vmx/sgx.c                        |   2 +-
>  arch/x86/kvm/vmx/vmx.c                        |  53 ++-
>  arch/x86/kvm/x86.c                            | 404 +++++++++++-------
>  arch/x86/kvm/x86.h                            |  11 +-
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
>  .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
>  .../kvm/x86_64/nested_exceptions_test.c       | 295 +++++++++++++
>  15 files changed, 886 insertions(+), 418 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> 
> 
> base-commit: 816967202161955f398ce379f9cbbedcb1eb03cb

Next week I will review all of this patch series.

Best regards,
	Maxim Levitsky

