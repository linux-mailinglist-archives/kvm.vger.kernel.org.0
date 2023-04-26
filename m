Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474896EFB53
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjDZTuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjDZTuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EE7E42
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RdktIonaOGjCG0RQBxJcRePW3YTcX9XMW+vYUOtplAw=;
        b=I7SOAUli+k9TxYx12whoUTs3GroFFOsK2X5pCPdM0n3EVhEzlkoRi8D6VSJ/9YnpkDcr4E
        dmGxJ62hJv8MYSIqPO8kaxzsjJ3pTnrlQ5z27Dr4572LjUBk/mcqgYLo4ljviiG+b5HHMF
        ybhfGtzpCzjR/pcgAdX4vkdSVpXOKKY=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-bveFNnspNZmHzhaloHfftg-1; Wed, 26 Apr 2023 15:49:17 -0400
X-MC-Unique: bveFNnspNZmHzhaloHfftg-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-42e6b078129so1926535137.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538556; x=1685130556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdktIonaOGjCG0RQBxJcRePW3YTcX9XMW+vYUOtplAw=;
        b=L4AzQHRM/2VlT7gT7P2kF1lrF6nKhBncUsXw8DIuvGQrkUxsccRZa2jw+/X0P5ctpO
         xJDCjckUUZKqPg0v6boXius6J4DmmZQY+/D8U81F8AR2h1T8jmGtzqUChURlu1maTasm
         1/NphXNdQfc595xXIX8VDPNk+0qy6PDkzMuzxGD24WFkY7BCDIySPqdBU87ljKdtfQYK
         fTmWsIw3L0/T8Ek75+q8R7K3GnsWgOnKWub4uiq/GrGJ4jHN3zxkLHlCtWpJaTCJ9Rjx
         2TxjDyB5i3zOrIw2yepoA3ywmtJXiOscezbQnZwjR/XzylpZqD1+EX4Jyv/ib9bXcj+l
         lVFQ==
X-Gm-Message-State: AAQBX9dA/2CSqdk8ciykYCBbANv6jst1gHj2yd77aEjXT8aqXoo1t7rE
        4gsntpp3dXOZs+z2UQwHR8Ol+q4xwzsWwmpCN4kTzssxyaLuM/ExHwedPxI0u3Qr234J6mEKd8k
        gCjQ39Q7pmQqtDzFFl0OgPu+mRNpgsJTAUYlAwvI=
X-Received: by 2002:a67:db81:0:b0:42c:761a:90ed with SMTP id f1-20020a67db81000000b0042c761a90edmr10083129vsk.6.1682538555875;
        Wed, 26 Apr 2023 12:49:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350am5kY33Mt2PdupdIqvTA9drWsGfxata/CSEcM7EH9mie9PrMNKbmWDNz4eAFO44xxzVxL2S6714q3gPWLaAIc=
X-Received: by 2002:a67:db81:0:b0:42c:761a:90ed with SMTP id
 f1-20020a67db81000000b0042c761a90edmr10083125vsk.6.1682538555677; Wed, 26 Apr
 2023 12:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:49:04 +0200
Message-ID: <CABgObfYvg0HUnba2v0mkjBmp_7AKCmPQ8wzouA+JTvAkrCE2=Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Non-x86 changes for 6.4
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
> Non-x86, a.k.a. generic, KVM changes for 6.4.  Nothing particularly
> interesting, just a random smattering of one-off patches.
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.4
>
> for you to fetch changes up to b0d237087c674c43df76c1a0bc2737592f3038f4:
>
>   KVM: Fix comments that refer to the non-existent install_new_memslots()=
 (2023-03-24 08:20:17 -0700)

Pulled (but didn't push yet), thanks.

Paolo

> ----------------------------------------------------------------
> Common KVM changes for 6.4:
>
>  - Drop unnecessary casts from "void *" throughout kvm_main.c
>
>  - Tweak the layout of "struct kvm_mmu_memory_cache" to shrink the struct
>    size by 8 bytes on 64-bit kernels by utilizing a padding hole
>
>  - Fix a documentation format goof that was introduced when the KVM docs
>    were converted to ReST
>
>  - Constify MIPS's internal callbacks (a leftover from the hardware enabl=
ing
>    rework that landed in 6.3)
>
> ----------------------------------------------------------------
> Jun Miao (1):
>       KVM: Fix comments that refer to the non-existent install_new_memslo=
ts()
>
> Li kunyu (1):
>       kvm: kvm_main: Remove unnecessary (void*) conversions
>
> Mathias Krause (1):
>       KVM: Shrink struct kvm_mmu_memory_cache
>
> Sean Christopherson (1):
>       KVM: MIPS: Make kvm_mips_callbacks const
>
> Shaoqin Huang (1):
>       KVM: Add the missed title format
>
>  Documentation/virt/kvm/api.rst     |  1 +
>  Documentation/virt/kvm/locking.rst |  2 +-
>  arch/mips/include/asm/kvm_host.h   |  2 +-
>  arch/mips/kvm/vz.c                 |  2 +-
>  include/linux/kvm_host.h           |  4 ++--
>  include/linux/kvm_types.h          |  2 +-
>  virt/kvm/kvm_main.c                | 26 ++++++++++++--------------
>  7 files changed, 19 insertions(+), 20 deletions(-)
>

