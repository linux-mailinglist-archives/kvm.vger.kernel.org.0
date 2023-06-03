Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27497211DA
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 21:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjFCTTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjFCTTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 15:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF3C99
        for <kvm@vger.kernel.org>; Sat,  3 Jun 2023 12:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685819902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dqO1FGZvfkOVbe8wev6AAfQQK2y1bKPXbA/9dfX2rKw=;
        b=XS+u1MIPkPYPksJl+NeBAaxVr4c3REqBuY85yI036O3OQH8/P/SZlhvPs1fWEXYs0RjuaL
        fYkCqEgX1pRvMgJoPnIODPfqSawNbS29/3aY+/0o/q4TW/n0/SsYEwv7xJ1/6XDCHKT37Z
        Xg3Msp6RWOHhMXwVvatQZcV/BdXkWEI=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-FiGQCGsIMTWYnnUxduYK0A-1; Sat, 03 Jun 2023 15:18:21 -0400
X-MC-Unique: FiGQCGsIMTWYnnUxduYK0A-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-786d7ce5dd1so1156081241.2
        for <kvm@vger.kernel.org>; Sat, 03 Jun 2023 12:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685819900; x=1688411900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqO1FGZvfkOVbe8wev6AAfQQK2y1bKPXbA/9dfX2rKw=;
        b=PhUc1g8osMsgDQvrB+B5QpFH/KqqWaVjZk5n6x+Ozg+T3FctzgG4grSHROx/zEQdf2
         E8EHbN8nBP1yKJ2HX6PoHuJwE89bt+/q0nlh1TjN2qBYsZVzNBQvBWaSJb/MPBAM33rp
         m5sFPSvV1GTMlg2/bzVwTsB6uEc0hakefZ8k2jYUV9GNCFO2PqXoOxSAtN1EerSWsQv0
         n+43nuMFUo5X5CKS4FRynpUnb5PX19dDPwzE8BCfJ/WANn3C59MMH5KUbgTlN/q2p/En
         XNRVoiLSsMYv1Br4cl1y18uLwVfxBItKrlllsUKs6Vm4rkTtAK5/PtMPdLJ+vH+PWnC2
         Td3w==
X-Gm-Message-State: AC+VfDzaqi+mgsWw/SO8P3qOCrgfX7CNVbDXcvoFZmmQytJNStmujnaH
        cpXVYsxVXAEqJ0H/Y4ZaofKGPtmnx7GVJBcnHhCEa6vEtJW2oR0WDu6j5VC+4EiqkUPRtbHIWT+
        HZQrnXgdlUoVL9kpripcnZmoIMerZGYa+MemJ
X-Received: by 2002:a67:f516:0:b0:43b:1b47:670 with SMTP id u22-20020a67f516000000b0043b1b470670mr3978411vsn.20.1685819900352;
        Sat, 03 Jun 2023 12:18:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Gctzyz5KrXOCWsH/1M5/Fmk4uJXcEdHcz5wLacm4tpCes+Qcfu6OBqFw30h4REjbrXUPNUyrd/iUY/yt43WE=
X-Received: by 2002:a67:f516:0:b0:43b:1b47:670 with SMTP id
 u22-20020a67f516000000b0043b1b470670mr3978408vsn.20.1685819900083; Sat, 03
 Jun 2023 12:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230603005213.1035921-2-seanjc@google.com>
In-Reply-To: <20230603005213.1035921-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 3 Jun 2023 21:18:08 +0200
Message-ID: <CABgObfa8PPv5FoHBFfszS_LAvawvMGsYbWu2TxEP-n+k_bL2tg@mail.gmail.com>
Subject: Re: KVM: x86: Fixes for 6.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 3, 2023 at 2:52=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull a few x86 fixes for 6.4.  Nothing ridiculously urgent, but th=
e
> vNMI fix in particular would be nice to get in 6.4.
>
> The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f3=
3f:
>
>   KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 =
-0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.4
>
> for you to fetch changes up to 47d2804bc99ca873470df17c20737b28225a320d:
>
>   KVM: selftests: Add test for race in kvm_recalculate_apic_map() (2023-0=
6-02 17:21:06 -0700)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM x86 fixes for 6.4
>
>  - Fix a memslot lookup bug in the NX recovery thread that could
>    theoretically let userspace bypass the NX hugepage mitigation
>
>  - Fix a s/BLOCKING/PENDING bug in SVM's vNMI support
>
>  - Account exit stats for fastpath VM-Exits that never leave the super
>    tight run-loop
>
>  - Fix an out-of-bounds bug in the optimized APIC map code, and add a
>    regression test for the race.
>
> ----------------------------------------------------------------
> Maciej S. Szmigiero (1):
>       KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING=
_MASK
>
> Michal Luczaj (1):
>       KVM: selftests: Add test for race in kvm_recalculate_apic_map()
>
> Sean Christopherson (3):
>       KVM: x86/mmu: Grab memslot for correct address space in NX recovery=
 worker
>       KVM: x86: Account fastpath-only VM-Exits in vCPU stats
>       KVM: x86: Bail from kvm_recalculate_phys_map() if x2APIC ID is out-=
of-bounds
>
>  arch/x86/kvm/lapic.c                               | 20 +++++-
>  arch/x86/kvm/mmu/mmu.c                             |  5 +-
>  arch/x86/kvm/svm/svm.c                             |  2 +-
>  arch/x86/kvm/x86.c                                 |  3 +
>  tools/testing/selftests/kvm/Makefile               |  1 +
>  .../selftests/kvm/x86_64/recalc_apic_map_test.c    | 74 ++++++++++++++++=
++++++
>  6 files changed, 101 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_te=
st.c
>

