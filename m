Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE457B333
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 10:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiGTIrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 04:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiGTIrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 04:47:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16A1F3DBE6
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658306866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E33i4x0VDithUN2osgw0KYbVHXG0AF/cZ3F5XHu1rls=;
        b=VXBd1fdsTaPTGrbmaNs6sluAEQrNLihDSU2FF3ub9adPjQVG1u4dRd5iDUXNTt3Ot+Isie
        9egOpCN/jsGH87IswtptnLK3VayU91lB6SmaGYJpqiuv3IN+cCizRY2SBPVIHdS8hqXVPM
        Vamt/k19ku7RBH6Sr9UTh1XPVOLXIoc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-7WUm8_OBMby1ogF2PejzlA-1; Wed, 20 Jul 2022 04:47:45 -0400
X-MC-Unique: 7WUm8_OBMby1ogF2PejzlA-1
Received: by mail-qv1-f71.google.com with SMTP id oo28-20020a056214451c00b004732e817c96so9113765qvb.22
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=E33i4x0VDithUN2osgw0KYbVHXG0AF/cZ3F5XHu1rls=;
        b=ySulV5EKyjEKpDe0VrSTzkHv0aQ3q0wiVx9TmpNCf+PSNmb9dHtWKhi6V6dTp+X5H5
         YWQCW3vhc9XoeAdl6q06QgvvU+qPe6i7fCLbYdp+7OWyaT/j8keDVzh+8bGzMZGyukHj
         jkMk2rI2uQHl7jXy9SRBKix3TDVktzv2PPgmGfDqugDaXZ+tCeVaXz0TsX10CTCmdvPg
         0w/TvZKWSvc3mBGI9Knifu14a52qbUQwNEMmXFdxJ9zUEfp4+VGasiNzmmXnkfudyGTi
         JVdHgMm6ZzzZWudyC1YgbUQ0N1HIovaoXIvwlnCB37DnlZq5IR4QLzlkMe2yKhgAfrHb
         4USw==
X-Gm-Message-State: AJIora+Q/P4LQoyaMKQ094pM9rEFI3NcOPM0XY8wwWtr3xHfgLRSi7+i
        KN4fALk3HXyakzyoxEfUtUBk0ei9UaWuQNbCz0PQwBsRQZNbVkFIVhS4B7yonBCrULyAe7L7Zit
        +k4vDj1cNI1pjvm3EXJA+hW6AfZ+gogOqcF0KOaQHgbXQDRb8CuswhGFMI3/JGiD9
X-Received: by 2002:a05:620a:712:b0:6b5:e58b:7fa1 with SMTP id 18-20020a05620a071200b006b5e58b7fa1mr9995025qkc.116.1658306864234;
        Wed, 20 Jul 2022 01:47:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vC9K6G7MBlKkHVtVu6hJYTxeEp888lIRV9wLUAqrKNOc0hRrTPQ65UbakaEmBv3ET66teddQ==
X-Received: by 2002:a05:620a:712:b0:6b5:e58b:7fa1 with SMTP id 18-20020a05620a071200b006b5e58b7fa1mr9995006qkc.116.1658306863971;
        Wed, 20 Jul 2022 01:47:43 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id i12-20020a37c20c000000b006a6a6f148e6sm15502876qkm.17.2022.07.20.01.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:47:43 -0700 (PDT)
Message-ID: <80099b7675300ba24743caffaa2255ac00b26b12.camel@redhat.com>
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
Date:   Wed, 20 Jul 2022 11:47:39 +0300
In-Reply-To: <a866e044713be1ab3f446775934ec15541c39726.camel@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <a866e044713be1ab3f446775934ec15541c39726.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 14:06 +0300, Maxim Levitsky wrote:
> On Tue, 2022-06-21 at 18:08 +0300, Maxim Levitsky wrote:
> > This patch series is a result of long debug work to find out why
> > sometimes guests with win11 secure boot
> > were failing during boot.
> > 
> > During writing a unit test I found another bug, turns out
> > that on rsm emulation, if the rsm instruction was done in real
> > or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> > 
> > I also refactored the way we write SMRAM so it is easier
> > now to understand what is going on.
> > 
> > The main bug in this series which I fixed is that we
> > allowed #SMI to happen during the STI interrupt shadow,
> > and we did nothing to both reset it on #SMI handler
> > entry and restore it on RSM.
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> > Maxim Levitsky (11):
> >   KVM: x86: emulator: em_sysexit should update ctxt->mode
> >   KVM: x86: emulator: introduce update_emulation_mode
> >   KVM: x86: emulator: remove assign_eip_near/far
> >   KVM: x86: emulator: update the emulation mode after rsm
> >   KVM: x86: emulator: update the emulation mode after CR0 write
> >   KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on
> >     the image format
> >   KVM: x86: emulator/smm: add structs for KVM's smram layout
> >   KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
> >   KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
> >   KVM: x86: SVM: use smram structs
> >   KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
> > 
> >  arch/x86/include/asm/kvm_host.h |   6 -
> >  arch/x86/kvm/emulate.c          | 305 ++++++++++++++++----------------
> >  arch/x86/kvm/kvm_emulate.h      | 146 +++++++++++++++
> >  arch/x86/kvm/svm/svm.c          |  28 +--
> >  arch/x86/kvm/x86.c              | 162 ++++++++---------
> >  5 files changed, 394 insertions(+), 253 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> A kind ping on these patches.

Another kind ping on this patch series.

Best regards,
	Maxim Levitsky

> 
> Best regards,
>         Maxim Levitsky
> 


