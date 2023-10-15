Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038347C98F3
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 14:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjJOM0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 08:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjJOM0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 08:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E69FC1
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697372762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxVHgl/xt8JpgcNiKg3RovsBacG9/aMXWlUBmwnO/qQ=;
        b=K8AyuxDq4XaXxk70k8ls3LDbKf+uIs7TI1XKhqLKzCtL7Cq5JQaeHiyIXyQu2lFWgEGWTD
        QdImYak/ZRmTu1L/eiG/rfbt084cHqfC/NCJ9k36l4zyT9RXjzHZR5Lo22NWuFyu+Bu8rE
        3FU9uYqmApripzzgWToufh4RrWQtFHs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-RjDNYUL3MsmEemoAdnumog-1; Sun, 15 Oct 2023 08:25:51 -0400
X-MC-Unique: RjDNYUL3MsmEemoAdnumog-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9b95fa56bd5so247678466b.0
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697372750; x=1697977550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sxVHgl/xt8JpgcNiKg3RovsBacG9/aMXWlUBmwnO/qQ=;
        b=LZ+DnMzbCeRZ1foKErDwzCK+t6VK49ZQr6ZDVfa2eZs5Fe4eOTuPljAUk22N5aV1ys
         ND4CoYDeVXPDRpasFOB5mFvdhJt+AZZdgTIQilfsSyU2NvYV1rsQaMH5wYeef1VpAv6m
         QAfpVGvj75CCRs1YY5jW8YzsM1ZdBIBzFDWobEnlZHfTaAHsSubMEAhY7rL0KxKvpIKp
         9a7pabitVGRXOzbSD+sQtnSF3jxLOOLYYHtxigAmXr75zXPUqBema1eW3CiWDIyPJQmo
         ttIuDevJBUBQ89PwcPGSLXKLqdgDMXEKk4OdT7fBmEEgheCru9D8f+/DMf7ZE0CB/krA
         7r2w==
X-Gm-Message-State: AOJu0Yxog25PiS89J3gCpuh+OnC5JobqIMfZ3cPYv7kNeOy3DKv6fG67
        zy7ZoVBZE5/2vkW8JrCr6uxtEaK7/3dxqmgR77nEHXszdOP0dwcNV31ed5cC11WhPE48gFWi3Zt
        bEVfO2F02RuyPHMxkBOCSxoplxuVQ
X-Received: by 2002:a17:907:1b27:b0:9bf:77ae:3aa9 with SMTP id mp39-20020a1709071b2700b009bf77ae3aa9mr2195717ejc.24.1697372750316;
        Sun, 15 Oct 2023 05:25:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/H38A1d+7j6phu4WmRg0+LcUmM6qjbw6TtcW4z1b8kn1PJfiLxA5YsaoHS7D36lLcYGkKpywv50EqYXMd4gw=
X-Received: by 2002:a17:907:1b27:b0:9bf:77ae:3aa9 with SMTP id
 mp39-20020a1709071b2700b009bf77ae3aa9mr2195710ejc.24.1697372749952; Sun, 15
 Oct 2023 05:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20231013234808.1115781-1-seanjc@google.com> <20231013234808.1115781-2-seanjc@google.com>
In-Reply-To: <20231013234808.1115781-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 15 Oct 2023 14:25:38 +0200
Message-ID: <CABgObfZOb1sV1LZpXR0=L-CG6ZPnxL37=zhdOk4zpcKxmVgMjw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests fixes for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 14, 2023 at 1:48=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a fix, a cleanup, and a workaround for 6.6.  The guest printf=
 change
> really should go into 6.6, as it fixes an issue introduced in 6.6 that ca=
uses
> affected guest asserts to print garbage.  The other two changes are much =
less
> urgent, but I couldn't think of a any reason to hold them back.

The printf one I had already applied, but the double commit is not a huge i=
ssue.

Pulled, thanks.

Paolo

> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.6-fixes
>
> for you to fetch changes up to 6313e096dbfaf1377ba8f5f8ccd720cc36c576c6:
>
>   KVM: selftests: Zero-initialize entire test_result in memslot perf test=
 (2023-10-05 19:23:47 -0700)
>
> ----------------------------------------------------------------
> KVM selftests fixes for 6.6:
>
>  - Play nice with %llx when formatting guest printf and assert statements=
.
>
>  - Clean up stale test metadata.
>
>  - Zero-initialize structures in memslot perf test to workaround a suspec=
ted
>    "may be used uninitialized" false positives from GCC.
>
> ----------------------------------------------------------------
> Like Xu (1):
>       KVM: selftests: Remove obsolete and incorrect test case metadata
>
> Sean Christopherson (2):
>       KVM: selftests: Treat %llx like %lx when formatting guest printf
>       KVM: selftests: Zero-initialize entire test_result in memslot perf =
test
>
>  tools/testing/selftests/kvm/include/ucall_common.h       | 2 --
>  tools/testing/selftests/kvm/lib/guest_sprintf.c          | 7 +++++++
>  tools/testing/selftests/kvm/lib/x86_64/apic.c            | 2 --
>  tools/testing/selftests/kvm/memslot_perf_test.c          | 9 +++------
>  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c     | 2 --
>  tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c  | 2 --
>  tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh | 1 -
>  tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c    | 4 ----
>  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c     | 4 ----
>  9 files changed, 10 insertions(+), 23 deletions(-)
>

