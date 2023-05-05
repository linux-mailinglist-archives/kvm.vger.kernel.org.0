Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095956F80A3
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 12:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjEEKOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjEEKOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 06:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5B18852
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 03:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683281642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FPkXkqfoQBCFAJdnJpzAFg7inu6d0AQogUHtLc765TM=;
        b=O0mDgFpvRVEes3wiUxNe6rjxpr0vlbhS6ri/blSUnl1h1S2LIDe8VUHcjA0qGaum4pxgMD
        KADQ6gX2FCCEEwVvlKUrGqY5tNPjLxMsahzMj0dZ4MSHi7VLqCfSAMiYJ5gYKokKUhH1v8
        gE0ppQjikdNURddOcb83BRHyssLgLr8=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-q4BrRLSkODeYF7rnemKMiw-1; Fri, 05 May 2023 06:14:00 -0400
X-MC-Unique: q4BrRLSkODeYF7rnemKMiw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-44fc7a00163so1109410e0c.1
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 03:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683281640; x=1685873640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPkXkqfoQBCFAJdnJpzAFg7inu6d0AQogUHtLc765TM=;
        b=M/aMtp9cMKc8G4HyloM73FHf7rFPzic/KiM7UKw58WEMCNfLwT/NDNA+hCANBaB1/F
         i615u59u2AtT3yhY3CUpZ+GPIPjylsZuMjySOOlqAhXLgs5DjqpDMH6HH++q+71PfWRa
         3m130XPik+kKUFXMcNwb1y3+S+CqFiZmoQ3bEI5OVwpZU+XYicJSDNYmh+hJ7UFMBPKo
         +yiJ/GxZxV6xktvFGwTnm01nxKMfLde1Us40A4L6uAX7CzN6pnD35Uh2n1UFNiNRDNrv
         vkQgtjkpDRqb66ZfLPnXJ9w//lLLrIdAO1ta1FdnvCTEloLgac2YQiqEoGFVlQTc0jTK
         eokA==
X-Gm-Message-State: AC+VfDzyVsahvBEG2coMUJ+B4fizYVquTHiBqMQgAUjPQsSo9SaLdVYy
        u3OxNkZFwVrfg+ehLO6VeM5xkOz83fRvqb5scrfwKi4/JLR4fVz1ZqWwWXobFvmjMzvFfxu2qt3
        XEXL0ufBw91o5Oy3BUBRIy5grCmoZIXnOAGv5
X-Received: by 2002:a67:e3bc:0:b0:42f:78d5:d987 with SMTP id j28-20020a67e3bc000000b0042f78d5d987mr305300vsm.1.1683281639984;
        Fri, 05 May 2023 03:13:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4iJPkZXoQrjGCUgTwq1CNtQevEqvLF2oqbakW3v75eXuWc/NFoFQwcOJqzo9lgcOUosooqPreFsZb1E97YQHM=
X-Received: by 2002:a67:e3bc:0:b0:42f:78d5:d987 with SMTP id
 j28-20020a67e3bc000000b0042f78d5d987mr305295vsm.1.1683281639714; Fri, 05 May
 2023 03:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230501181711.3203661-1-seanjc@google.com>
In-Reply-To: <20230501181711.3203661-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 5 May 2023 12:13:48 +0200
Message-ID: <CABgObfaqbHEU+LcL5oFvZOMEpygdCNUnrgw=eDmDVLf2VixKVw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Make valid TDP MMU roots persistent
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

On Mon, May 1, 2023 at 8:17=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull the previously discussed persistent TDP MMU roots change.  Th=
is
> specific commit has been in linux-next since April 26th, and the core
> functionality of the patch has been in linux-next since April 21st (the
> only tweak from v2=3D>v3 was to reintroduce a lockdep assertion with a mo=
re
> robust guard against false positives).

Done, thanks.

Paolo

> The following changes since commit 9ed3bf411226f446a9795f2b49a15b9df98d7c=
f5:
>
>   KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V c=
ode (2023-04-10 15:17:29 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.4-2
>
> for you to fetch changes up to edbdb43fc96b11b3bfa531be306a1993d9fe89ec:
>
>   KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated =
(2023-04-26 15:50:27 -0700)
>
> ----------------------------------------------------------------
> Fix a long-standing flaw in x86's TDP MMU where unloading roots on a vCPU=
 can
> result in the root being freed even though the root is completely valid a=
nd
> can be reused as-is (with a TLB flush).
>
> ----------------------------------------------------------------
> Sean Christopherson (1):
>       KVM: x86: Preserve TDP MMU roots until they are explicitly invalida=
ted
>
>  arch/x86/kvm/mmu/tdp_mmu.c | 121 +++++++++++++++++++++------------------=
------
>  1 file changed, 56 insertions(+), 65 deletions(-)
>

