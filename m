Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD06EFB6E
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjDZT7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjDZT7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:59:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA14115
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682539134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RdvB7pdVXqN5D98/zVmCH4XkZQZWhXior4JzVB6rTgI=;
        b=eG4TvIr3GvGqYOWN3y75a2BqflBGwUe+u/kAEWg6YVOj/gosm2D02cnXfKuUHJdV55bHw4
        r/25cRVXWzRl5if+rTEX82JjItlEUWXxzMqoPlTnS9PfhcrCppPOFWN4SdQ9yzXc+ioSoZ
        fBlqWTX3rduX+JDgkkqGT1AKuG6ZtQw=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-VKNTnbFbOX-GDGuklfzKMQ-1; Wed, 26 Apr 2023 15:58:53 -0400
X-MC-Unique: VKNTnbFbOX-GDGuklfzKMQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-779f4178ffdso1750083241.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682539132; x=1685131132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdvB7pdVXqN5D98/zVmCH4XkZQZWhXior4JzVB6rTgI=;
        b=Bls1Pg+OV+XFrE7ZBvJUXonZD23pQSZNS4eK5/8IeOs92h/axhm9jqI3xgYA0BuyoM
         9gbUxKQ65wdFVsiwUZpqcxOmdd4smsIfvG5px07DadEBJS6jKmOEBiqAzU8+6B7d4zR7
         AEzpmwTeP/3WhuYYz06fTZCPxX/6ZhJLq19Qpf08jqFD6Xb3Qsh0JxZnpA7hw2O8eGLP
         CxJ1K6GRSMQ3mvKhwDZm322L2eLH2+2vDAGWbrPJYY0I1H617KfDnXlEz9C8UrtXaV7Y
         mrtMvPrkSqdScqWpQkKWVAaWaw1YnGG8B0+LQe3yCXzTG8g27/YChuDDBFAGDK8sx6kL
         q1RA==
X-Gm-Message-State: AAQBX9ecqQwFYCdQb3Oshik8zprUFzxWSxDx3pKJmb87r5l/s+6ffVlV
        OoQPCRGi1MXxQf7tPZRImrIZuc6km1VvOpCz4yTmo16ZN2H1hlxEQI/SIOJ8wUzhOBcEkQi2/L5
        HT5JP75vPIx7Bb965SEhXFifrpNwJou3GtjnuMTSp+w==
X-Received: by 2002:a67:ec4e:0:b0:430:2262:6459 with SMTP id z14-20020a67ec4e000000b0043022626459mr11109535vso.1.1682539132616;
        Wed, 26 Apr 2023 12:58:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZyWH48/BlbZdK6Z+4DnR0Nz2L7BNByi8XK4QrR+VI0xJlfhn8MiKlVSGME23jHce/OCrsNN4+KTycUFc18q/4=
X-Received: by 2002:a67:ec4e:0:b0:430:2262:6459 with SMTP id
 z14-20020a67ec4e000000b0043022626459mr11109529vso.1.1682539132328; Wed, 26
 Apr 2023 12:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-6-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:58:41 +0200
Message-ID: <CABgObfaXqx1nM5tc5jSBfHCv_Ju4=CPtn6atyuGJdeawE2EcFg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM SVM changes for 6.4.  The highlight, by a country mile, is support fo=
r
> virtual NMIs.
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.4
>
> for you to fetch changes up to c0d0ce9b5a851895f34fd401c9dddc70616711a4:
>
>   KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK (202=
3-04-04 11:08:12 -0700)

Pulled (but not pushed yet), thanks.

This is probably the sub-PR for which I'm more interested in giving
the code a closer look, but this is more about understanding the
changes than it is about expecting something bad in it.

Paolo

> ----------------------------------------------------------------
> KVM SVM changes for 6.4:
>
>  - Add support for virtual NMIs
>
>  - Fixes for edge cases related to virtual interrupts
>
> ----------------------------------------------------------------
> Maxim Levitsky (2):
>       KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IR=
Qs
>       KVM: SVM: add wrappers to enable/disable IRET interception
>
> Santosh Shukla (5):
>       KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is in=
tercepting VINTR
>       KVM: nSVM: Disable intercept of VINTR if saved L1 host RFLAGS.IF is=
 0
>       KVM: SVM: Add definitions for new bits in VMCB::int_ctrl related to=
 vNMI
>       KVM: x86: Add support for SVM's Virtual NMI
>       KVM: nSVM: Implement support for nested VNMI
>
> Sean Christopherson (5):
>       KVM: x86: Raise an event request when processing NMIs if an NMI is =
pending
>       KVM: x86: Tweak the code and comment related to handling concurrent=
 NMIs
>       KVM: x86: Save/restore all NMIs when multiple NMIs are pending
>       x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's "real"=
 vNMI
>       KVM: x86: Route pending NMIs from userspace through process_nmi()
>
> Xinghui Li (1):
>       KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK
>
>  arch/x86/include/asm/cpufeatures.h |   8 +-
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  11 ++-
>  arch/x86/include/asm/svm.h         |  10 ++-
>  arch/x86/kvm/svm/nested.c          |  91 ++++++++++++++++++----
>  arch/x86/kvm/svm/svm.c             | 153 ++++++++++++++++++++++++++++++-=
------
>  arch/x86/kvm/svm/svm.h             |  29 +++++++
>  arch/x86/kvm/x86.c                 |  46 +++++++++--
>  8 files changed, 292 insertions(+), 58 deletions(-)
>

