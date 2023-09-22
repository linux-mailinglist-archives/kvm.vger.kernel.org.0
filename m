Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D67ABB0D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 23:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjIVV3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 17:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjIVV27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 17:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F9BAF
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695418087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YilQ5WpNjmLk9g6RVDu6cjEDNsN7lZeBSR6AfTwYMoc=;
        b=P7NFfJsyrUHxXUK1VCWOQuXoBzZrVVXxgtgVeH+gFtoEPW5Hz1xHWsXsXpxLsBNH3zCXnW
        BD8dGP2DDeQvVW5PTQjwCN08gtHqHBA/PfK7XzIek/NsNqbdLPus9P27RQ2+0vLpUtakDh
        Ae9IPVN7MDj+PsQ9LkmsZvxlUDW7mM8=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-ZyWHVgQSOleRYnwSrw8uLA-1; Fri, 22 Sep 2023 17:28:06 -0400
X-MC-Unique: ZyWHVgQSOleRYnwSrw8uLA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7a87af33d4bso1020689241.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695418086; x=1696022886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YilQ5WpNjmLk9g6RVDu6cjEDNsN7lZeBSR6AfTwYMoc=;
        b=CnvtZLNBVAm6GSeWwqXtXf1bNnZ/EbGCnN0mJvQj4kB5M7npCSdNFzOSjQjwc4kWE5
         wUGl53Ktc7jXdhr5jeOBbbW5KhS9MzCAE0Sgqx24MwDUHD48Ul92j4dmKPZ7iRYA4DAB
         j197VPloZ+8sqp22RLaG2lYvZb9GJUph4pQAsFiibuLd77O//qxRtRs5De/lC34Ijt0X
         2xhkfkRkUiyoghEwoh45DQVlLOUck9B38X3o+DqhbTH/gsqDcAI4jntlVNgVX9KtNEht
         EhGd+j1nyKSS0fUjRRry30lnOLhipgYmeZGUExEH9j99TzNbwgE7qSKbg85kQGTE5ljG
         RTaQ==
X-Gm-Message-State: AOJu0YzRPf2UHskshV5rXVKPh/LRuLybbFbbpacKGWIWoucwSbfTL7aK
        5B4MpUgB0+rDweLgvuBsM2S2Cz+C2GimmF8qivLV+5Gi1dhX8AntDPPEbfym3naWUCu0voQLmEn
        E/KDMwTVMzN6cX7C86ZyxFogOVFdU
X-Received: by 2002:a67:e3ac:0:b0:452:8953:729e with SMTP id j12-20020a67e3ac000000b004528953729emr682983vsm.13.1695418086005;
        Fri, 22 Sep 2023 14:28:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ0fIpquBXBNq3l0iEdeQY+FY/SNsrw0iVd0n976vxEoYdNhJwd93x+JRPYPbA7AsDby6xUWMNTwoQTzTR2Tg=
X-Received: by 2002:a67:e3ac:0:b0:452:8953:729e with SMTP id
 j12-20020a67e3ac000000b004528953729emr682972vsm.13.1695418085766; Fri, 22 Sep
 2023 14:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy3dL1JBSsu3yrQtJKavAkqMva=YotoV_y_+-kt0S0oVNA@mail.gmail.com>
In-Reply-To: <CAAhSdy3dL1JBSsu3yrQtJKavAkqMva=YotoV_y_+-kt0S0oVNA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 22 Sep 2023 23:27:54 +0200
Message-ID: <CABgObfa48fkRqyaG0DWB7bkq435zeN3R0NjoY9_JP0BJ+AQCBw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.6, take #1
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 11:44=E2=80=AFAM Anup Patel <anup@brainfault.org> w=
rote:
>
> Hi Paolo,
>
> We have four ONE_REG related fixes for 6.6. Out of these,
> two are for kernel KVM module and other two are for get-reg-list
> selftest.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b=
70:
>
>   Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.6-1
>
> for you to fetch changes up to 071ef070ca77e6dfe33fd78afa293e83422f0411:
>
>   KVM: riscv: selftests: Selectively filter-out AIA registers

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/riscv fixes for 6.6, take #1
>
> - Fix KVM_GET_REG_LIST API for ISA_EXT registers
> - Fix reading ISA_EXT register of a missing extension
> - Fix ISA_EXT register handling in get-reg-list test
> - Fix filtering of AIA registers in get-reg-list test
>
> ----------------------------------------------------------------
> Anup Patel (4):
>       RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
>       RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for missing extens=
ions
>       KVM: riscv: selftests: Fix ISA_EXT register handling in get-reg-lis=
t
>       KVM: riscv: selftests: Selectively filter-out AIA registers
>
>  arch/riscv/kvm/vcpu_onereg.c                     |  7 ++-
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 58 +++++++++++++++++-=
------
>  2 files changed, 47 insertions(+), 18 deletions(-)
>

