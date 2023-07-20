Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C006675A433
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 04:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjGTCAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTCAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 22:00:20 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3344C1FF1;
        Wed, 19 Jul 2023 19:00:19 -0700 (PDT)
Received: from [IPv6:::1] ([172.56.209.9])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 36K1xg0x448479
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 19 Jul 2023 18:59:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 36K1xg0x448479
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023071101; t=1689818385;
        bh=eoupgmKtGigZ7T3TSXZvW3ALhw75g3a7HIBawcERwX4=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=JUx2UyLBmtezmWvzz+3zrGX9MPla5oUd+IZiRmPySpDV38uD6RRfgKJsXUn0DRw9U
         O0sLldd/Wif4pF4HfGAqcm/g2tpm+mTaIB++PZwT6ikVhhZhQEj3cqpAtREHfvbeV0
         AA00Qd70XXb/2kalPBFzVISpREFmDbGfdEboXjcyGap/BzoGFAU+Refe7btS+MxNsA
         NKHBROwQ1+xbg5lwXMImdwjoeDeLRgsu05aioclrKRaswugjdMXA8vnRd7qm0vJ63S
         /xdElnjnHfSMVF+Bd/rWPUImkoUjvFpHCz4hfJxRQ2wd4fVAla+m7So5iJU6qy0eSn
         43bj+1i/bf2RQ==
Date:   Wed, 19 Jul 2023 18:59:33 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, kvm@vger.kernel.org
CC:     x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] LASS KVM virtualization support
User-Agent: K-9 Mail for Android
In-Reply-To: <20230718131844.5706-1-guang.zeng@intel.com>
References: <20230718131844.5706-1-guang.zeng@intel.com>
Message-ID: <6E16A5AF-1970-45FF-8961-85232E920C99@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On July 18, 2023 6:18:36 AM PDT, Zeng Guang <guang=2Ezeng@intel=2Ecom> wrot=
e:
>Linear Address Space Separation (LASS)[1] is a new mechanism that
>enforces the same mode-based protections as paging, i=2Ee=2E SMAP/SMEP
>but without traversing the paging structures=2E Because the protections
>enforced by LASS are applied before paging, "probes" by malicious
>software will provide no paging-based timing information=2E
>
>Based on a linear-address organization, LASS partitions 64-bit linear
>address space into two halves, user-mode address (LA[bit 63]=3D0) and
>supervisor-mode address (LA[bit 63]=3D1)=2E
>
>LASS aims to prevent any attempt to probe supervisor-mode addresses by
>user mode, and likewise stop any attempt to access (if SMAP enabled) or
>execute user-mode addresses from supervisor mode=2E
>
>When platform has LASS capability, KVM requires to expose this feature
>to guest VM enumerated by CPUID=2E(EAX=3D07H=2EECX=3D1):EAX=2ELASS[bit 6]=
, and
>allow guest to enable it via CR4=2ELASS[bit 27] on demand=2E For instruct=
ion
>executed in the guest directly, hardware will perform the check=2E But KV=
M
>also needs to behave same as hardware to apply LASS to kinds of guest
>memory accesses when emulating instructions by software=2E
>
>KVM will take following LASS violations check on emulation path=2E
>User-mode access to supervisor space address:
>        LA[bit 63] && (CPL =3D=3D 3)
>Supervisor-mode access to user space address:
>        Instruction fetch: !LA[bit 63] && (CPL < 3)
>        Data access: !LA[bit 63] && (CR4=2ESMAP=3D=3D1) && ((RFLAGS=2EAC =
=3D=3D 0 &&
>                     CPL < 3) || Implicit supervisor access)
>
>This patch series provide a LASS KVM solution and depends on kernel
>enabling that can be found at
>https://lore=2Ekernel=2Eorg/all/20230609183632=2E48706-1-alexander=2Eshis=
hkin@linux=2Eintel=2Ecom/
>
>We tested the basic function of LASS virtualization including LASS
>enumeration and enabling in non-root and nested environment=2E As KVM
>unittest framework is not compatible to LASS rule, we use kernel module
>and application test to emulate LASS violation instead=2E With KVM forced
>emulation mechanism, we also verified the LASS functionality on some
>emulation path with instruction fetch and data access to have same
>behavior as hardware=2E
>
>How to extend kselftest to support LASS is under investigation and
>experiment=2E
>
>[1] Intel ISE https://cdrdv2=2Eintel=2Ecom/v1/dl/getContent/671368
>Chapter Linear Address Space Separation (LASS)
>
>------------------------------------------------------------------------
>
>v1->v2
>1=2E refactor and optimize the interface of instruction emulation=20
>   by introducing new set of operation type definition prefixed with
>   "X86EMUL_F_" to distinguish access=2E
>2=2E reorganize the patch to make each area of KVM better isolated=2E
>3=2E refine LASS violation check design with consideration of wraparound
>   access across address space boundary=2E
>
>v0->v1
>1=2E Adapt to new __linearize() API
>2=2E Function refactor of vmx_check_lass()
>3=2E Refine commit message to be more precise
>4=2E Drop LASS kvm cap detection depending
>   on hardware capability
>
>Binbin Wu (4):
>  KVM: x86: Consolidate flags for __linearize()
>  KVM: x86: Use a new flag for branch instructions
>  KVM: x86: Add an emulation flag for implicit system access
>  KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()
>
>Zeng Guang (4):
>  KVM: emulator: Add emulation of LASS violation checks on linear
>    address
>  KVM: VMX: Implement and apply vmx_is_lass_violation() for LASS
>    protection
>  KVM: x86: Virtualize CR4=2ELASS
>  KVM: x86: Advertise LASS CPUID to user space
>
> arch/x86/include/asm/kvm-x86-ops=2Eh |  3 ++-
> arch/x86/include/asm/kvm_host=2Eh    |  5 +++-
> arch/x86/kvm/cpuid=2Ec               |  5 ++--
> arch/x86/kvm/emulate=2Ec             | 37 ++++++++++++++++++++---------
> arch/x86/kvm/kvm_emulate=2Eh         |  9 +++++++
> arch/x86/kvm/vmx/nested=2Ec          |  3 ++-
> arch/x86/kvm/vmx/sgx=2Ec             |  4 ++++
> arch/x86/kvm/vmx/vmx=2Ec             | 38 ++++++++++++++++++++++++++++++
> arch/x86/kvm/vmx/vmx=2Eh             |  3 +++
> arch/x86/kvm/x86=2Ec                 | 10 ++++++++
> arch/x86/kvm/x86=2Eh                 |  2 ++
> 11 files changed, 102 insertions(+), 17 deletions(-)
>

Equating this with SMEP/SMAP is backwards=2E

LASS is something completely different: it makes it so *user space accesse=
s* cannot even walk the kernel page tables (specifically, the negative half=
 of the linear address space=2E)

Such an access with immediately #PF: it is similar to always having U=3D0 =
in the uppermost level of the page tables, except with LASS enabled the CPU=
 will not even touch the page tables in memory=2E
