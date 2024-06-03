Return-Path: <kvm+bounces-18650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE08D8D82C8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 938C828B17E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E28112C48F;
	Mon,  3 Jun 2024 12:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTy8bHql"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636A17BAE5
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419015; cv=none; b=Am37sdA6jIQ3JHUCvcCBWArSnZ/C2p4DhdyHu6DB6qZHgwcP7gG5dlADCEI38i1ROaDWSXI9pP8fl2lae27oJpETGFTQZe+9tC/RfMoaqsDqG9vXwJZkynIr6VGOmYZfLaqdV3tQwoEt/4Ukhp+HGomr/r0xCizelguVGqOqpSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419015; c=relaxed/simple;
	bh=VjNeEbnN0FVmtiaDzOSOBuYno++KB0/3wB4rghkte3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+/UJEvQKTWoXP8KUVTHQ0FZslUJ4TIJ+F0tPhrud2WS9lPyWqHf73yBSccAJ00lB6E8VtI9C9ROxJZZar5JghpqPImAf6ufm4S1SqF/Odb0NqPTz9J7Fu/yZR34oNUJUNviog6CDnYVlMADsrj3DOjMqrIyTbDna6wUtF58IUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTy8bHql; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vvVHIigXFPVUayvTKyguWiQDKu5Se4crNY0w/f8to1o=;
	b=DTy8bHqlHaXkd9zLH371dLSJgNa9XLH4JQvrZbX1lsG7DwaKHYMdhyfbI9xWqob8WaSK/2
	+YF8Wwh0Y/kkrrGE5OHIpj2WYGy2spzg3VnyEuiyiZbfii4au2NkPPXFUbtY4CVWermeYd
	yAcWbiAlkp3/4e2A1qq3Zb8z+iyBcz0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-c1Md5o11N5yADgNoFrVB4A-1; Mon, 03 Jun 2024 08:50:11 -0400
X-MC-Unique: c1Md5o11N5yADgNoFrVB4A-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52b85bc3216so2557789e87.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 05:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419009; x=1718023809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvVHIigXFPVUayvTKyguWiQDKu5Se4crNY0w/f8to1o=;
        b=D/+GIXlTXVA0aN7HysSOBkSMOTJq5Gkp1gGXa2hB3DFotcvgAebDt2cTjbjMVR1uk7
         l+dDFnTHwLbgC5A0DAFpLF+R2Dv5NmqfFz1uTyXIExvCsuQQa5H6gGDzulQzF2bMce4B
         3DPUQXpqBv6DvDJSV8Lz7DZy3x1A0/fyh22/mGi/cI2fizzDE+xHWClqzPgC/1vFoWIB
         57xBjLc5tkQ93ym9+te/MO/ROkgTLTiBfmY4fxZMxPLzka/fN1DWEsVdKI3o47Ad3uCl
         bF5sLuwuT9MzkNPtY4vsu9NS9U7Ac4/1HtiAGDf7tTs6UNL8uq47gb/KLXJuTiT9cYRc
         q7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcQN61cJQtPhvoehAA9Uz2dYXlmyIZy0FTbBFHqF6NRK4uGMeOKd+NyAQD+kiSCCM+uSAQ+DIoimVOPBa8NWOLnJzh
X-Gm-Message-State: AOJu0YyUGdzax/vcqzXkSu0mOZ24hIvaq4ZbL5cmD9uyjrov/3SxuKVM
	yAJyxUoO/YD9RDs2YyVxJtehGStj4q5RW9OfGpuNn0sfhcYNMPiwkarGBoYE4HGJypfjuyEvbOw
	CDGOo6eV2kA5YJ0sJXb9wybj5dKHJa2SAdE9GaPzs/c7SJ6RGtw==
X-Received: by 2002:ac2:4e04:0:b0:52b:9e2b:9e1 with SMTP id 2adb3069b0e04-52b9e2b0a7fmr1162461e87.23.1717419009538;
        Mon, 03 Jun 2024 05:50:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/4loIAmGneGuSGjjPByhWJ3wNrwgncuMeG06rKtBOo1enZwiQTfx1ktZLyUSK/6jo9r1N4A==
X-Received: by 2002:ac2:4e04:0:b0:52b:9e2b:9e1 with SMTP id 2adb3069b0e04-52b9e2b0a7fmr1162441e87.23.1717419009014;
        Mon, 03 Jun 2024 05:50:09 -0700 (PDT)
Received: from fedora (lmontsouris-659-1-55-176.w193-248.abo.wanadoo.fr. [193.248.58.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42134ab5ebasm87037245e9.42.2024.06.03.05.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 05:50:08 -0700 (PDT)
Date: Mon, 3 Jun 2024 14:50:06 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
	james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential
 Compute Architecture
Message-ID: <Zl27/vDnqzXan+G1@fedora>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>

Hello,

I tried this series by using kvmtool[1] and Linux/KVM with series "[v2]
Support for Arm CCA VMs on Linux". To try it, I ran "run-realm-tests" in
the FVP model. All tests seem to have passed successfully.

Tested-by: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>

[1] https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v2

On Fri, Apr 12, 2024 at 11:33:35AM +0100, Suzuki K Poulose wrote:
> This series adds support for running the kvm-unit-tests in the Arm CCA reference
> software architecture.
> 
> 
> The changes involve enlightening the boot/setup code with the Realm Service Interface
> (RSI). The series also includes new test cases that exercise the RSI calls.
> 
> Currently we only support "kvmtool" as the VMM for running Realms. There was
> an attempt to add support for running the test scripts using with kvmtool here [1],
> which hasn't progressed. It would be good to have that resolved, so that we can
> run all the tests without manually specifying the commandlines for each run.
> 
> For the purposes of running the Realm specific tests, we have added a "temporary"
> script "run-realm-tests" until the kvmtool support is added. We do not expect
> this to be merged.
> 
> 
> Base Realm Support
> -------------------
> 
> Realm IPA Space
> ---------------
> When running on in Realm world, the (Guest) Physical Address - aka Intermediate
> Physical Address (IPA) in Arm terminology - space of the VM is split into two halves,
> protected (lower half) and un-protected (upper half). A protected IPA will
> always map pages in the "realm world" and  the contents are not accessible to
> the host. An unprotected IPA on the other hand can be mapped to page in the
> "normal world" and thus shared with the host. All host emulated MMIO ranges must
> be in unprotected IPA space.
> 
> Realm can query the Realm Management Monitor for the configuration via RSI call
> (RSI_REALM_CONFIG) and identify the "boundary" of the "IPA" split.
> 
> As far as the hyp/VMM is concerned, there is only one "IPA space" (the lower
> half) of memory map. The "upper half" is "unprotected alias" of the memory map.
> 
> In the guest, this is achieved by "treating the MSB (1 << (IPA_WIDTH - 1))" as
> a protection attribute (we call it - PTE_NS_SHARED), where the Realm applies this
> to any address, it thinks is acccessed/managed by host (e.g., MMIO, shared pages).
> Given that this is runtime variable (but fixed for a given Realm), uses a
> variable to track the value.
> 
> All I/O regions are marked as "shared". Care is taken to ensure I/O access (uart)
> with MMU off uses the "Unprotected Physical address".
> 
> 
> Realm IPA State
> ---------------
> Additionally, each page (4K) in the protected IPA space has a state associated
> (Realm IPA State - RIPAS) with it. It is either of :
>    RIPAS_EMPTY
>    RIPAS_RAM
> 
> Any IPA backed by RAM, must be marked as RIPAS_RAM before an access is made to
> it. The hypervisor/VMM does this for the initial image loaded into the Realm
> memory before the Realm starts execution. Given the kvm-unit-test flat files do
> not contain a metadata header (e.g., like the arm64 Linux kernel Image),
> indicating the "actual image size in memory", the VMM cannot transition the
> area towards the end of the image (e.g., bss, stack) which are accessed very
> early during boot. Thus the early boot assembly code will mark the area upto
> the stack as RAM.
> 
> Once we land in the C code, we mark target relocation area for FDT and
> initrd as RIPAS_RAM. At this point, we can scan the FDT and mark all RAM memory
> blocks as RIPAS_RAM.
> 
> TODO: It would be good to add an image header to the flat files indicating the
> size, which can take the burden off doing the early assembly boot code RSI calls.
> 
> Shared Memory support
> ---------------------
> Given the "default" memory of a VM is not accessible to host, we add new page
> alloc/free routines for "memory shared" with the host. e.g., GICv3-ITS must use
> shared pages for ITS emulation.
> 
> RSI Test suites
> --------------
> There are new testcases added to exercise the RSI interfaces and the RMM flows.
> 
> Attestation and measurement services related RSI tests require parsing tokens
> and claims returned by the RMM. This is achieved with the help of QCBOR library
> [2], which is added as a submodule to the project. We have also added a wrapper
> library - libtokenverifier - around the QCBOR to parse the tokens according to
> the RMM specifications.
> 
> Running Arm CCA Stack
> -------------------
> 
> See more details on Arm CCA and how to build/run the entire stack here[0]
> The easiest way to run the Arm CCA stack is using shrinkwrap and the details
> are available in [0].
> 
> 
> The patches are also available here :
> 
>  https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v1
> 
> 
> Changes since rfc:
>   [ https://lkml.kernel.org/r/20230127114108.10025-1-joey.gouly@arm.com ]
>   - Add support for RMM-v1.0-EAC5, changes to RSI ABIs
>   - Some hardening checks (FDT overlapping the BSS sections)
>   - Selftest for memory stress
>   - Enable PMU/SVE tests for Realms
> 
>  [0] https://lkml.kernel.org/r/20240412084056.1733704-1-steven.price@arm.com
>  [1] https://lkml.kernel.org/r/20210702163122.96110-1-alexandru.elisei@arm.com
>  [2] https://github.com/laurencelundblade/QCBOR
> 
> Alexandru Elisei (3):
>   arm64: Expand SMCCC arguments and return values
>   arm: selftest: realm: skip pabt test when running in a realm
>   NOT-FOR-MERGING: add run-realm-tests
> 
> Djordje Kovacevic (1):
>   arm: realm: Add tests for in realm SEA
> 
> Gareth Stockwell (1):
>   arm: realm: add hvc and RSI_HOST_CALL tests
> 
> Jean-Philippe Brucker (1):
>   arm: Move io_init after vm initialization
> 
> Joey Gouly (10):
>   arm: Make physical address mask dynamic
>   arm64: Introduce NS_SHARED PTE attribute
>   arm: realm: Add RSI interface header
>   arm: realm: Make uart available before MMU is enabled
>   arm: realm: Add RSI version test
>   arm64: add ESR_ELx EC.SVE
>   arm64: enable SVE at startup
>   arm64: selftest: add realm SVE VL test
>   lib/alloc_page: Add shared page allocation support
>   arm: Add memtest support
> 
> Mate Toth-Pal (2):
>   arm: Add a library to verify tokens using the QCBOR library
>   arm: realm: Add Realm attestation tests
> 
> Subhasish Ghosh (1):
>   arm: realm: Add test for FPU/SIMD context save/restore
> 
> Suzuki K Poulose (14):
>   arm: Add necessary header files in asm/pgtable.h
>   arm: Detect FDT overlap with uninitialised data
>   arm: realm: Realm initialisation
>   arm: realm: Add support for changing the state of memory
>   arm: realm: Set RIPAS state for RAM
>   arm: realm: Early memory setup
>   arm: gic-v3-its: Use shared pages wherever needed
>   arm: realm: Enable memory encryption
>   qcbor: Add QCBOR as a submodule
>   arm: Add build steps for QCBOR library
>   arm: realm: add RSI interface for attestation measurements
>   arm: realm: Add helpers to decode RSI return codes
>   arm: realm: Add Realm attestation tests
>   arm: realm: Add a test for shared memory
> 
>  .gitmodules                         |    3 +
>  arm/Makefile.arm64                  |   25 +-
>  arm/cstart.S                        |   49 +-
>  arm/cstart64.S                      |  154 +++-
>  arm/fpu.c                           |  424 +++++++++
>  arm/realm-attest.c                  | 1251 +++++++++++++++++++++++++++
>  arm/realm-ns-memory.c               |   86 ++
>  arm/realm-rsi.c                     |  159 ++++
>  arm/realm-sea.c                     |  143 +++
>  arm/run-realm-tests                 |  112 +++
>  arm/selftest.c                      |  138 ++-
>  arm/unittests.cfg                   |   96 +-
>  lib/alloc_page.c                    |   20 +-
>  lib/alloc_page.h                    |   24 +
>  lib/arm/asm/arm-smccc.h             |   44 +
>  lib/arm/asm/io.h                    |    6 +
>  lib/arm/asm/pgtable.h               |    9 +
>  lib/arm/asm/psci.h                  |   13 +-
>  lib/arm/asm/rsi.h                   |   21 +
>  lib/arm/asm/sve-vl-test.h           |    9 +
>  lib/arm/gic-v3.c                    |    6 +-
>  lib/arm/io.c                        |   24 +-
>  lib/arm/mmu.c                       |   80 +-
>  lib/arm/psci.c                      |   19 +-
>  lib/arm/setup.c                     |   26 +-
>  lib/arm64/asm/arm-smccc.h           |    6 +
>  lib/arm64/asm/esr.h                 |    1 +
>  lib/arm64/asm/io.h                  |    6 +
>  lib/arm64/asm/pgtable-hwdef.h       |    6 -
>  lib/arm64/asm/pgtable.h             |   20 +
>  lib/arm64/asm/processor.h           |   34 +
>  lib/arm64/asm/rsi.h                 |   89 ++
>  lib/arm64/asm/smc-rsi.h             |  173 ++++
>  lib/arm64/asm/sve-vl-test.h         |   28 +
>  lib/arm64/asm/sysreg.h              |    7 +
>  lib/arm64/gic-v3-its.c              |    6 +-
>  lib/arm64/processor.c               |    1 +
>  lib/arm64/rsi.c                     |  188 ++++
>  lib/asm-generic/io.h                |   12 +
>  lib/libcflat.h                      |    1 +
>  lib/qcbor                           |    1 +
>  lib/token_verifier/attest_defines.h |   50 ++
>  lib/token_verifier/token_dumper.c   |  157 ++++
>  lib/token_verifier/token_dumper.h   |   15 +
>  lib/token_verifier/token_verifier.c |  591 +++++++++++++
>  lib/token_verifier/token_verifier.h |   77 ++
>  46 files changed, 4355 insertions(+), 55 deletions(-)
>  create mode 100644 .gitmodules
>  create mode 100644 arm/fpu.c
>  create mode 100644 arm/realm-attest.c
>  create mode 100644 arm/realm-ns-memory.c
>  create mode 100644 arm/realm-rsi.c
>  create mode 100644 arm/realm-sea.c
>  create mode 100755 arm/run-realm-tests
>  create mode 100644 lib/arm/asm/arm-smccc.h
>  create mode 100644 lib/arm/asm/rsi.h
>  create mode 100644 lib/arm/asm/sve-vl-test.h
>  create mode 100644 lib/arm64/asm/arm-smccc.h
>  create mode 100644 lib/arm64/asm/rsi.h
>  create mode 100644 lib/arm64/asm/smc-rsi.h
>  create mode 100644 lib/arm64/asm/sve-vl-test.h
>  create mode 100644 lib/arm64/rsi.c
>  create mode 160000 lib/qcbor
>  create mode 100644 lib/token_verifier/attest_defines.h
>  create mode 100644 lib/token_verifier/token_dumper.c
>  create mode 100644 lib/token_verifier/token_dumper.h
>  create mode 100644 lib/token_verifier/token_verifier.c
>  create mode 100644 lib/token_verifier/token_verifier.h
> 
> -- 
> 2.34.1
> 


