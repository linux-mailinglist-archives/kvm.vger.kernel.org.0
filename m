Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B11955F8BE
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 09:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiF2HV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 03:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiF2HV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 03:21:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9AF21D0FF
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 00:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656487315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fI9ivlo9GVMwAi7+gjgOrAMG5lU56r9U/Z8Jc07VjA=;
        b=HN/M2oQ5LWWFPUetD9EJTq1kDtEtEuvfKhbnSJo/8UFK6ieP+sNYk2W1U92SJJOSH11yde
        hlnQoyp4jMKb6q8sDG8II9UJp72NEe2gEV3BKFhzCQiWAp5iE2F3SYCkJbpxiuYM2DLghU
        ajYnFTZBXZaQTacdSmioY3Z2tw5LCYo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-mQBD3f6LO3e1FDojxi7TPg-1; Wed, 29 Jun 2022 03:21:52 -0400
X-MC-Unique: mQBD3f6LO3e1FDojxi7TPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFB1D1C0513F;
        Wed, 29 Jun 2022 07:21:50 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF5719D7F;
        Wed, 29 Jun 2022 07:21:46 +0000 (UTC)
Message-ID: <1e96776f5a8dc73e8354cda7697af8a60a1f91ac.camel@redhat.com>
Subject: Re: [PATCH v2 00/11] SMM emulation and interrupt shadow fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jun 2022 10:21:45 +0300
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-21 at 18:08 +0300, Maxim Levitsky wrote:
> This patch series is a result of long debug work to find out why
> sometimes guests with win11 secure boot
> were failing during boot.
> 
> During writing a unit test I found another bug, turns out
> that on rsm emulation, if the rsm instruction was done in real
> or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> 
> I also refactored the way we write SMRAM so it is easier
> now to understand what is going on.
> 
> The main bug in this series which I fixed is that we
> allowed #SMI to happen during the STI interrupt shadow,
> and we did nothing to both reset it on #SMI handler
> entry and restore it on RSM.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (11):
>   KVM: x86: emulator: em_sysexit should update ctxt->mode
>   KVM: x86: emulator: introduce update_emulation_mode
>   KVM: x86: emulator: remove assign_eip_near/far
>   KVM: x86: emulator: update the emulation mode after rsm
>   KVM: x86: emulator: update the emulation mode after CR0 write
>   KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on
>     the image format
>   KVM: x86: emulator/smm: add structs for KVM's smram layout
>   KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
>   KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
>   KVM: x86: SVM: use smram structs
>   KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
> 
>  arch/x86/include/asm/kvm_host.h |   6 -
>  arch/x86/kvm/emulate.c          | 305 ++++++++++++++++----------------
>  arch/x86/kvm/kvm_emulate.h      | 146 +++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  28 +--
>  arch/x86/kvm/x86.c              | 162 ++++++++---------
>  5 files changed, 394 insertions(+), 253 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
A very gentle ping on the patch series.

Best regards,
	Maxim Levitsky

