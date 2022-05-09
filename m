Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3491051F9EF
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiEIKfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiEIKei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B6512A4A06
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 03:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652092102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6H/6ecBRlSRkZDMv8ER1vowHrJ0f9/tbpgvVRebvDPM=;
        b=UJPIUnrze52s7YC4EyRFMk7Y+36tS4tBSuzHgVqFErqn4RlVnfzZvKwO7AP55fUYStfOm3
        W0ZN2D4TYP/85v4OxGoToiRGvjsd7Kyoss+mIljsoHX5L6HmgcViXf7myPEeP98N8aScV6
        35XGyR1ElsXx3QsmTeqpyu7HaRoasIE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-JrX56wR3PXCIMLTqmToTCQ-1; Mon, 09 May 2022 06:28:19 -0400
X-MC-Unique: JrX56wR3PXCIMLTqmToTCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49B48185A794;
        Mon,  9 May 2022 10:28:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35B00C27EB6;
        Mon,  9 May 2022 10:28:17 +0000 (UTC)
Message-ID: <506fc55bd1001e0ffb4c5b20edd057fe7b8dcfb4.camel@redhat.com>
Subject: Re: [PATCH v4 00/15] Introducing AMD x2AVIC and hybrid-AVIC modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 09 May 2022 13:28:16 +0300
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-05-07 at 21:39 -0500, Suravee Suthikulpanit wrote:
> Introducing support for AMD x2APIC virtualization. This feature is
> indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
> by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
> offset 60h.
> 
> With x2AVIC support, the guest local APIC can be fully virtualized in
> both xAPIC and x2APIC modes, and the mode can be changed during runtime.
> For example, when AVIC is enabled, the hypervisor set VMCB bit 31
> to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
> APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
> virtualization mode accordingly.
> 
> Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
> to disable interception for the x2APIC MSR range to allow AVIC hardware
> to virtualize register accesses.
> 
> This series also introduce a partial APIC virtualization (hybrid-AVIC)
> mode, where APIC register accesses are trapped (i.e. not virtualized
> by hardware), but leverage AVIC doorbell for interrupt injection.
> This eliminates need to disable x2APIC in the guest on system without
> x2AVIC support. (Note: suggested by Maxim)
> 
> Regards,
> Suravee
> 
> Testing for v4:
>   * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
>   * Test enable AVIC in L0 with xAPIC and x2AVIC modes in L1 and launch L2 guest
>   * Test partial AVIC mode by launching a VM with x2APIC mode
> 
> Changes from v3:
> (https://lore.kernel.org/lkml/ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com/T/)
>  * Patch  3 : Update logic force_avic
>  * Patch  8 : Move logic for handling APIC disable to common code (new)
>  * Patch  9 : Only call avic_refresh_apicv_exec_ctrl
>  * Patch 12 : Remove APICV_INHIBIT_REASON_X2APIC, and add more comment for hybrid-AVIC mode
> 
> Suravee Suthikulpanit (15):
>   x86/cpufeatures: Introduce x2AVIC CPUID bit
>   KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
>     [GET/SET]_XAPIC_DEST_FIELD
>   KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
>   KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
>   KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
>   KVM: SVM: Do not support updating APIC ID when in x2APIC mode
>   KVM: SVM: Adding support for configuring x2APIC MSRs interception
>   KVM: x86: Deactivate APICv on vCPU with APIC disabled
>   KVM: SVM: Refresh AVIC configuration when changing APIC mode
>   KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
>   KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
>     running vcpu
>   KVM: SVM: Introduce hybrid-AVIC mode
>   KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is
>     valid
>   KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
>   KVM: SVM: Add AVIC doorbell tracepoint
> 
>  arch/x86/hyperv/hv_apic.c          |   2 +-
>  arch/x86/include/asm/apicdef.h     |   4 +-
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm_host.h    |   1 -
>  arch/x86/include/asm/svm.h         |  21 +++-
>  arch/x86/kernel/apic/apic.c        |   2 +-
>  arch/x86/kernel/apic/ipi.c         |   2 +-
>  arch/x86/kvm/lapic.c               |   6 +-
>  arch/x86/kvm/svm/avic.c            | 191 ++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c             |  56 +++++----
>  arch/x86/kvm/svm/svm.h             |   6 +-
>  arch/x86/kvm/trace.h               |  18 +++
>  arch/x86/kvm/x86.c                 |   8 +-
>  13 files changed, 262 insertions(+), 56 deletions(-)
> 

Patch series looks good.

I will smoke test it today on my normal AVIC, just in case.

Did you had a chance to look at my comments on your report
that nesting got broken by my nested PAUSE filtering patch?

I tried to reproduce it on my side, so far no luck.

I tried to oversubscribe L1, by booting a VM with 16 vCPUs
all pinned to single physical CPU, and then booting a nested guest 
in it with about the same amount of vCPUs. Slow but it did work.


Also did you had a chance to look for my comments about the AMD's manual
asking the user to flush guest's TLB when changing apic backing page,
regardless of ASID?

Best regards,
	Maxim Levitsky





