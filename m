Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C76EFB64
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbjDZT5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjDZT5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:57:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB4919B9
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zw21Yr3ggXAcUufyzwCuaJsOabWd2wq00JsLEU9ouJI=;
        b=I6GkysOJcBJlLNggJRPXsHxneks4tb7xRcqeWzSLRrgA389WAU6iNgY/poOUqOUX+g6vhc
        vCO+QaroVDL/+xDW2hX0NbH76V6IfDc5yHKDKf/qebNajb1DBnvXxK71DR7t/93eC0tz9F
        aTZ5tUtIrRrtoo0bd4paqtMMEpG8wek=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-S_pMPLguPCazNyNGtUWQxw-1; Wed, 26 Apr 2023 15:56:23 -0400
X-MC-Unique: S_pMPLguPCazNyNGtUWQxw-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-443b6a0fb20so2255382e0c.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538982; x=1685130982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zw21Yr3ggXAcUufyzwCuaJsOabWd2wq00JsLEU9ouJI=;
        b=LXLMzvevbK0NBQ+H7xtXJOhTmu4omCGTRm0XFNHjVgQqDI5AupNxRg3bVQU0boMmU5
         30/NYY9jSof64qXPpiQQnev+V6NBdrZILo7H8LzfDWmY5eiQK58paGChJI9EVN7Hdnco
         ck5IPGZVR8uPOUys+7j/K802Dic8mHeBU8fzIzYYGH5PCxRNwNwL3fL8Q24mQl7aGKwq
         uzgB2IO41ytGtYytiPdUe8Gimwm22ft5QRAKxMNCxid7+JHoxVkLEsYvIgISkHffrhFF
         8REzvXMMahq9mIzmMBgyg6LWxHluUsRA7Bf+oUhtrWos8fhW2I6S4kPc4aaiT7pLN5Ad
         ImqA==
X-Gm-Message-State: AAQBX9fg7nTADLgtEhSMuYr8H1KTmlkKuXau02/BM7gOyk8zoTJwe0uK
        e6sCh5eJd2fVVw3m6gJYALhRbSWEKPLf+D/6OfPqGwu6YwSdFuvmSQsIQ/sKe4jEcxpgExSwV3f
        vwu+0U3oPQZdAch1tAUIgIBkRQwkgZ5BhEV4Wlg+gag==
X-Received: by 2002:a67:fdc1:0:b0:42c:77da:5d05 with SMTP id l1-20020a67fdc1000000b0042c77da5d05mr9395097vsq.32.1682538982434;
        Wed, 26 Apr 2023 12:56:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350avWADS6wf7krW/BTfvRMNhg7uAbHfe0GeCHgEOs4Z/SC/lQbVKnud8Dg7Z0RlimVHhVeGbA4nLVgX5KVsOQxw=
X-Received: by 2002:a67:fdc1:0:b0:42c:77da:5d05 with SMTP id
 l1-20020a67fdc1000000b0042c77da5d05mr9395091vsq.32.1682538982142; Wed, 26 Apr
 2023 12:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-5-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:56:11 +0200
Message-ID: <CABgObfbBqbFhQxOT+UTO6WBDFxk+HMoDTpXdW18GBJGqAjbspA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.4
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
> KVM x86 selftests change for 6.4.  And an AMX+XCR0 bugfix that I landed h=
ere
> to avoid creating a mess of unnecessary conflicts between the series to
> overhaul the AMX test and the related selftests changes to verify the fix=
.
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.4
>
> for you to fetch changes up to 20aef201dafba6a1ffe9daa145c7f2c525b74aae:
>
>   KVM: selftests: Fix spelling mistake "perrmited" -> "permitted" (2023-0=
4-14 10:04:51 -0700)

Pulled (put not pushed yet), thanks.

Paolo

> ----------------------------------------------------------------
> KVM selftests, and an AMX/XCR0 bugfix, for 6.4:
>
>  - Don't advertisze XTILE_CFG in KVM_GET_SUPPORTED_CPUID if XTILE_DATA is
>    not being reported due to userspace not opting in via prctl()
>
>  - Overhaul the AMX selftests to improve coverage and cleanup the test
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Aaron Lewis (9):
>       KVM: selftests: Assert that XTILE is XSAVE-enabled
>       KVM: selftests: Assert that both XTILE{CFG,DATA} are XSAVE-enabled
>       KVM: selftests: Move XSAVE and OSXSAVE CPUID checks into AMX's init=
_regs()
>       KVM: selftests: Check that the palette table exists before using it
>       KVM: selftests: Check that XTILEDATA supports XFD
>       KVM: x86: Add a helper to handle filtering of unpermitted XCR0 feat=
ures
>       KVM: selftests: Move XGETBV and XSETBV helpers to common code
>       KVM: selftests: Add all known XFEATURE masks to common code
>       KVM: selftests: Add test to verify KVM's supported XCR0
>
> Ackerley Tng (1):
>       KVM: selftests: Adjust VM's initial stack address to align with Sys=
V ABI spec
>
> Anish Moorthy (1):
>       KVM: selftests: Fix nsec to sec conversion in demand_paging_test
>
> Colin Ian King (1):
>       KVM: selftests: Fix spelling mistake "perrmited" -> "permitted"
>
> Hao Ge (1):
>       KVM: selftests: Close opened file descriptor in stable_tsc_check_su=
pported()
>
> Ivan Orlov (1):
>       KVM: selftests: Add 'malloc' failure check in vcpu_save_state
>
> Like Xu (2):
>       KVM: selftests: Add a helper to read kvm boolean module parameters
>       KVM: selftests: Report enable_pmu module value when test is skipped
>
> Mingwei Zhang (6):
>       KVM: selftests: Add a fully functional "struct xstate" for x86
>       KVM: selftests: Fix an error in comment of amx_test
>       KVM: selftests: Enable checking on xcomp_bv in amx_test
>       KVM: selftests: Add check of CR0.TS in the #NM handler in amx_test
>       KVM: selftests: Assert that XTILE_DATA is set in IA32_XFD on #NM
>       KVM: selftests: Verify XTILE_DATA in XSTATE isn't affected by IA32_=
XFD
>
> Sean Christopherson (2):
>       KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
>       KVM: selftests: Rework dynamic XFeature helper to take mask, not bi=
t
>
>  arch/x86/kvm/cpuid.c                               |   2 +-
>  arch/x86/kvm/x86.c                                 |   4 +-
>  arch/x86/kvm/x86.h                                 |  29 +++++
>  tools/testing/selftests/kvm/Makefile               |   1 +
>  tools/testing/selftests/kvm/demand_paging_test.c   |   2 +-
>  .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
>  .../selftests/kvm/include/x86_64/processor.h       |  83 +++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
>  tools/testing/selftests/kvm/lib/x86_64/processor.c |  36 ++++--
>  tools/testing/selftests/kvm/x86_64/amx_test.c      | 118 ++++++++-------=
---
>  .../selftests/kvm/x86_64/pmu_event_filter_test.c   |   1 +
>  .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   8 +-
>  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   1 +
>  .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c | 132 +++++++++++++++=
++++++
>  14 files changed, 326 insertions(+), 97 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
>

