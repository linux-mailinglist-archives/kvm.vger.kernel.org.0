Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45063651ECD
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 11:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiLTK2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 05:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLTK2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 05:28:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC11BC1
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 02:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671532049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LXpV1QNUoibeoH4rMcuwRGMEdg3d0Uub6iMLUL63Tnc=;
        b=PDNNc58oi2g6NFYOLTgvSDc5WEez5Ug2oauIl6HaROKoyLHuTQnVhw838EGkO0djc20Nrb
        MNEYTmc4mfC/O7b+jSgOeE6NiMtes9V4fjchTZikCbkru/qYP3kQkitc38CakCZ8FgWcYt
        QfT4mQdvd7AoKQD5P/txo11cKn4lU7s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-8BDCkdiEN0me2uoJ4WS9hQ-1; Tue, 20 Dec 2022 05:27:25 -0500
X-MC-Unique: 8BDCkdiEN0me2uoJ4WS9hQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7199F3814590;
        Tue, 20 Dec 2022 10:27:24 +0000 (UTC)
Received: from starship (ovpn-192-71.brq.redhat.com [10.40.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49D62492B03;
        Tue, 20 Dec 2022 10:27:19 +0000 (UTC)
Message-ID: <7af086556ff794bbe78e48c882b6e91aa5ad4022.camel@redhat.com>
Subject: Re: [PATCH v2 00/11] SVM: vNMI (with my fixes)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Dec 2022 12:27:18 +0200
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 21:37 +0200, Maxim Levitsky wrote:
> Hi!
> 
> This is the vNMI patch series based on Santosh Shukla's vNMI patch series.
> 
> In this version of this patch series I addressed most of the review feedback
> added some more refactoring and also I think fixed the issue with migration.
> 
> I only tested this on a machine which doesn't have vNMI, so this does need
> some testing to ensure that nothing is broken.
> 
> Best regards,
>        Maxim Levitsky
> 
> Maxim Levitsky (9):
>   KVM: nSVM: don't sync back tlb_ctl on nested VM exit
>   KVM: nSVM: clean up the copying of V_INTR bits from vmcb02 to vmcb12
>   KVM: nSVM: explicitly raise KVM_REQ_EVENT on nested VM exit if L1
>     doesn't intercept interrupts
>   KVM: SVM: drop the SVM specific H_FLAGS
>   KVM: x86: emulator: stop using raw host flags
>   KVM: SVM: add wrappers to enable/disable IRET interception
>   KVM: x86: add a delayed hardware NMI injection interface
>   KVM: SVM: implement support for vNMI
>   KVM: nSVM: implement support for nested VNMI
> 
> Santosh Shukla (2):
>   x86/cpu: Add CPUID feature bit for VNMI
>   KVM: SVM: Add VNMI bit definition
> 
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  24 +++--
>  arch/x86/include/asm/svm.h         |   7 ++
>  arch/x86/kvm/emulate.c             |  11 +--
>  arch/x86/kvm/kvm_emulate.h         |   7 +-
>  arch/x86/kvm/smm.c                 |   2 -
>  arch/x86/kvm/svm/nested.c          | 102 ++++++++++++++++---
>  arch/x86/kvm/svm/svm.c             | 154 ++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.h             |  41 +++++++-
>  arch/x86/kvm/x86.c                 |  50 ++++++++--
>  11 files changed, 318 insertions(+), 83 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
A very kind ping on these patches.


Best regards,
	Maxim Levitsky

