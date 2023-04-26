Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23E36EFB63
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbjDZT41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbjDZT4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:56:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7D31707
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4GvcwkE/5d9RFaKVtYC75FJAN+7qjz3FyAzkuwVc0s=;
        b=gluk3NH80T7+R48iIMARcbVBf17ZU3+NAkv/VY23aH+9K7AJkM+Cih9MVejik2b/lJVuzv
        uPDj6fGWrrxkOXEvO2MFZB/tTwbBpjFFKAJdMNFgUASX6s0lKE33E27oOAzPIeDT3qLOW5
        sBIYN1208mH7bkYGHEcWGaG6v21ok3s=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-tK7ZDT3JP9mc3J1MjtaN6g-1; Wed, 26 Apr 2023 15:55:38 -0400
X-MC-Unique: tK7ZDT3JP9mc3J1MjtaN6g-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-42e38b93668so1911683137.0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538937; x=1685130937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4GvcwkE/5d9RFaKVtYC75FJAN+7qjz3FyAzkuwVc0s=;
        b=TDpPvP5HZSHpPWpUzV5XT9vNywLMsS89Zt3c4wAi0d//YHkJivFf3eFhnUSGUPvtg5
         2VqJFjc2E48CEQXW8troHfG1cque27ZnjF4/WMzIaadUvtOCcI12k8Q6z8t5ofgz/cFk
         t38lJBgeNmeoTIX181aSty2KE8y3D37XYN73aBd3YA/ydVqxJi/1kxWV30q2f+gNcHYT
         9JxtuUXxHvDhE+aBjNkegM+QPx1w838yPVuXhsoBIBrFPn+c3SjyBB8ocIdfKe0ZhC3V
         l/JSPF6oQCNGI9IqGsM4BlxSiERCWNwJ8Lbrmv4kO4eE+6jJPuIIhru3C6CVt5lwjQnm
         ThHw==
X-Gm-Message-State: AAQBX9ckcFEtFuJVglry6O9RBajPPx2LgKsa8eDP2JlQWInTinZfrjlf
        UV6LI/Iu4gH6vRfEZLzQWFpESWU9MLlt1C3PNZ+/5zxAiBDUMfxxHZ36wAOy/SfXA5VkXkfdOPu
        opZz+MC/MbhWbOEmN+yWzTEOxp85UdLYudZi6tS0=
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id bh10-20020a056102356a00b0042ffae53b98mr8971226vsb.14.1682538937071;
        Wed, 26 Apr 2023 12:55:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yy58fwCXXJorxUx7s57UGjFOozgAk73AUxphwB9YDU1Mp6tX4I4R98piOwNDR9E3Hc0ilQyiQhECaM/0tACrg=
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id
 bh10-20020a056102356a00b0042ffae53b98mr8971210vsb.14.1682538936712; Wed, 26
 Apr 2023 12:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-4-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:55:25 +0200
Message-ID: <CABgObfbh-ZQvnSfP9XNc2pGud9xP2vvDSVj7MTgCxk_CeNHHaw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: PMU changes for 6.4
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
> KVM x86/pmu changes for 6.4.  Hiding in the pile of selftests changes are=
 a
> a handful of small-but-important fixes.
>
> Note, this superficially conflicts with the PRED_CMD/FLUSH_CMD changes
> sitting in kvm/next due to "KVM: VMX: Refactor intel_pmu_{g,}set_msr() to
> align with other helpers".  The resolution I have been using when prepari=
ng
> kvm-x86/next for linux-next is to replace a "return 0" with a "break".

Yup, figured out the same. Pulled (put not pushed yet), thanks.

Paolo

> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.4
>
> for you to fetch changes up to 457bd7af1a17182e7f1f97eeb5d9107f8699e99d:
>
>   KVM: selftests: Test the PMU event "Instructions retired" (2023-04-14 1=
3:21:38 -0700)
>
> ----------------------------------------------------------------
> KVM x86 PMU changes for 6.4:
>
>  - Disallow virtualizing legacy LBRs if architectural LBRs are available,
>    the two are mutually exclusive in hardware
>
>  - Disallow writes to immutable feature MSRs (notably PERF_CAPABILITIES)
>    after KVM_RUN, and overhaul the vmx_pmu_caps selftest to better
>    validate PERF_CAPABILITIES
>
>  - Apply PMU filters to emulated events and add test coverage to the
>    pmu_event_filter selftest
>
>  - Misc cleanups and fixes
>
> ----------------------------------------------------------------
> Aaron Lewis (5):
>       KVM: x86/pmu: Prevent the PMU from counting disallowed events
>       KVM: selftests: Add a common helper for the PMU event filter guest =
code
>       KVM: selftests: Add helpers for PMC asserts in PMU event filter tes=
t
>       KVM: selftests: Print detailed info in PMU event filter asserts
>       KVM: selftests: Test the PMU event "Instructions retired"
>
> Like Xu (4):
>       KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time it's refres=
hed
>       KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
>       KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
>       KVM: x86/pmu: Fix a typo in kvm_pmu_request_counter_reprogam()
>
> Mathias Krause (1):
>       KVM: x86: Shrink struct kvm_pmu
>
> Sean Christopherson (25):
>       KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are availa=
ble
>       KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple l=
ists
>       KVM: x86: Add a helper to query whether or not a vCPU has ever run
>       KVM: x86: Add macros to track first...last VMX feature MSRs
>       KVM: x86: Generate set of VMX feature MSRs using first/last definit=
ions
>       KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after=
 KVM_RUN
>       KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
>       KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU ha=
s run
>       KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
>       KVM: selftests: Move 0/initial value PERF_CAPS checks to dedicated =
sub-test
>       KVM: selftests: Assert that full-width PMC writes are supported if =
PDCM=3D1
>       KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
>       KVM: selftests: Verify KVM preserves userspace writes to "durable" =
MSRs
>       KVM: selftests: Drop now-redundant checks on PERF_CAPABILITIES writ=
es
>       KVM: selftests: Test all fungible features in PERF_CAPABILITIES
>       KVM: selftests: Test all immutable non-format bits in PERF_CAPABILI=
TIES
>       KVM: selftests: Expand negative testing of guest writes to PERF_CAP=
ABILITIES
>       KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
>       KVM: selftests: Drop "all done!" printf() from PERF_CAPABILITIES te=
st
>       KVM: selftests: Refactor LBR_FMT test to avoid use of separate macr=
o
>       KVM: selftests: Add negative testcase for PEBS format in PERF_CAPAB=
ILITIES
>       KVM: selftests: Verify LBRs are disabled if vPMU is disabled
>       KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with other help=
ers
>       KVM: selftests: Use error codes to signal errors in PMU event filte=
r test
>       KVM: selftests: Copy full counter values from guest in PMU event fi=
lter test
>
>  arch/x86/include/asm/kvm_host.h                    |   2 +-
>  arch/x86/kvm/cpuid.c                               |   2 +-
>  arch/x86/kvm/mmu/mmu.c                             |   2 +-
>  arch/x86/kvm/pmu.c                                 |  21 +-
>  arch/x86/kvm/pmu.h                                 |   2 +-
>  arch/x86/kvm/svm/pmu.c                             |   2 +-
>  arch/x86/kvm/svm/svm.c                             |   2 +-
>  arch/x86/kvm/vmx/pmu_intel.c                       | 135 ++++++-----
>  arch/x86/kvm/vmx/vmx.c                             |  16 +-
>  arch/x86/kvm/x86.c                                 | 102 ++++++---
>  arch/x86/kvm/x86.h                                 |  13 ++
>  .../selftests/kvm/include/x86_64/processor.h       |  41 +++-
>  .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 252 ++++++++++++---=
------
>  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       | 248 +++++++++++++++=
+----
>  14 files changed, 565 insertions(+), 275 deletions(-)

