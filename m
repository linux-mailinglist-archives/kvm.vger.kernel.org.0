Return-Path: <kvm+bounces-20176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1909A9114C2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:38:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 359921C218AE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AC87FBBD;
	Thu, 20 Jun 2024 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9UpyW1B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64174BF0
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919522; cv=none; b=TjeBsg2X6UGdhyCq2eudPT/wXaeWonIY8YX0UC1DsYxhb9CPPW21+yy2x6i4xS7dtw5cBK9BhvF1l1F21UcdLlvKniGdRHdiDc1SjLDRDtNmXuvr1ex6DUhSUVwuj77jBraPwl0rPat5DdlkZYD6JciqvgS4oYYTKv+5Tdfy4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919522; c=relaxed/simple;
	bh=rqttPFpgpdaPfltUEIWArBxugu0a4VlOcZsClzfwyYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHlwXe+X4mQ8lQvvey9mASN0BJsS6EubaOpnAPeaci6ukcUchZUV5ZLzth0+z2n6nt6zjw8j+eViVtTD04BSOXYFfHGN/NWgOQFm1IUIc0oTuXm5ejpE+RYIi3sepor1sOeu5PAPM8pWexmusA23tRarVpeWpa5ih4c1zDqEhCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9UpyW1B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718919519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7aMkAmRZxTuVx1sGr/rCjZ2e5+4RAngXxQuvmrxA14=;
	b=g9UpyW1BS+LA6Td0D56v3C9mWDrMpoH2o8+5n+PRGrHlYC/FMjJjHBN00dQ+ML2DzA3hFB
	CVZPQl9DKhQBwZrHzW9uPn4Ka81+RWmRD9QY92cLjOr6hLoWzu3Pl4yPBv6zTsKu0B5jqG
	WCC7KsnNCPntxG7W3Ms2HQUX92VAkWI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-LGNpxHd8PsqfIQAvHEdIYg-1; Thu, 20 Jun 2024 17:38:37 -0400
X-MC-Unique: LGNpxHd8PsqfIQAvHEdIYg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-363e84940b2so657666f8f.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 14:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718919516; x=1719524316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7aMkAmRZxTuVx1sGr/rCjZ2e5+4RAngXxQuvmrxA14=;
        b=mrEfGbOAUA+COw4h2w6deB+8YYcECdUUq44KEI5iq/DKorAqURKOCqC/ik1YU/PtO0
         bkyzVBKra7NMh9fgzKQR6A7lS7NBlapuJ6JX9nEDr8QL5fMDaQnTyQjmYJZNxCa9hoxW
         QqpwQ1/iamsn7Qjtgek/hvumdCBL0w3BWi9TdMR3wGd/NaqFGK8r8MzFMWtSW/nLyRlr
         7QXVZduzrL+t3znAYIxz+Gwk30Ber9LsLu9AbKCSbNWodSy2/75ta2B9C8Pvb4tvirnK
         AWCa4s8WHoVBFFH7MNZdj/cJvscV7r8BUjIUvP6oEbcjFpI02KW8ahqKNaI7gwbKLP0/
         VP2w==
X-Gm-Message-State: AOJu0YxpLaUhDYJoBZ2t9pk6nFShOT7LZXmiDaUGhMGIYG2d1LLKToMt
	zWnFm2Uy+yFXtrly64nYhn36c9CQPTpffmjTW/fvLvabqq13AYayNIhwTwLaxU6plABvUjbdcCA
	rDHRfoYaI1Ek0lb69S2FLa98csrXn85NZ9lpCWqOtI4x0tAZlTa8Pw5/H9iXVESVDgNpSZllc9C
	dSD74b9rQ4MdHJ5brVW4j1StYi
X-Received: by 2002:adf:a1c3:0:b0:35f:1d3c:4084 with SMTP id ffacd0b85a97d-363175b8117mr5214930f8f.25.1718919516016;
        Thu, 20 Jun 2024 14:38:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeszHwlXgdEM1NO99w4ms9jc7VT304ZceaMczZNwXUGQLu/wTYm3HMYNQYukZIoWZJZLO79yyRTjGY+fKY3Bw=
X-Received: by 2002:adf:a1c3:0:b0:35f:1d3c:4084 with SMTP id
 ffacd0b85a97d-363175b8117mr5214921f8f.25.1718919515666; Thu, 20 Jun 2024
 14:38:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240614234607.1405974-1-seanjc@google.com>
In-Reply-To: <20240614234607.1405974-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 20 Jun 2024 23:38:24 +0200
Message-ID: <CABgObfamcK6x4+ZihsNN7q8OCww4MC1i8J-L+B=q7bth1Oimbg@mail.gmail.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new tests
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2024 at 1:46=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a smattering of x86 changes, most of which have been sitting =
around
> on-list for quite some time.  There are still quite a few KUT x86 series =
that
> want attention, but they are all quite large and exceeded what little rev=
iew
> time I have for KUT :-/

Pulled, thanks.

Paolo

> Note, the posted interrupt test fails due to KVM bugs, patches posted:
> https://lore.kernel.org/all/20240607172609.3205077-1-seanjc@google.com
>
> The following changes since commit a68956b3fb6f5f308822b20ce0ff8e02db1f73=
75:
>
>   gitlab-ci: Always save artifacts (2024-06-05 12:49:58 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2024.06.14
>
> for you to fetch changes up to ee1d79c3f0f871bf78f20930cb1a2441f28ac027:
>
>   nVMX: Verify KVM actually loads the value in HOST_PAT into the PAT MSR =
(2024-06-11 06:41:23 -0700)
>
> ----------------------------------------------------------------
> x86 fixes, cleanups, and new testcases:
>
>  - Add a testcase to verify that KVM doesn't inject a triple fault (or an=
y
>    other "error") if a nested VM is run with an EP4TA pointing MMIO.
>
>  - Play nice with CR4.CET in test_vmxon_bad_cr()
>
>  - Force emulation when testing MSR_IA32_FLUSH_CMD to workaround an issue=
 where
>    Skylake CPUs don't follow the architecturally defined behavior, and so=
 that
>    the test doesn't break if/when new bits are supported by future CPUs.
>
>  - Rework the async #PF test to support IRQ-based page-ready notification=
s.
>
>  - Fix a variety of issues related to adaptive PEBS.
>
>  - Add several nested VMX tests for virtual interrupt delivery and posted
>    interrupts.
>
>  - Ensure PAT is loaded with the default value after the nVMX PAT tests
>    (failure to do so was causing tests to fail due to all memory being UC=
).
>
>  - Misc cleanups.
>
> ----------------------------------------------------------------
> Alejandro Jimenez (1):
>       x86: vmexit: Allow IPI test to be accelerated by SVM AVIC
>
> Dan Wu (1):
>       x86/asyncpf: Update async page fault test for IRQ-based "page ready=
"
>
> Jack Wang (1):
>       x86/msr: Fix typo in output SMR
>
> Jim Mattson (1):
>       nVMX: Enable x2APIC mode for virtual-interrupt delivery tests
>
> Marc Orr (3):
>       nVMX: test nested "virtual-interrupt delivery"
>       nVMX: test nested EOI virtualization
>       nVMX: add self-IPI tests to vmx_basic_vid_test
>
> Mingwei Zhang (3):
>       x86: Add FEP support on read/write register instructions
>       x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM emul=
ation
>       x86/pmu: Clear mask in PMI handler to allow delivering subsequent P=
MIs
>
> Oliver Upton (1):
>       nVMX: add test for posted interrupts
>
> Sean Christopherson (9):
>       nVMX: Use helpers to check for WB memtype and 4-level EPT support
>       nVMX: Use setup_dummy_ept() to configure EPT for test_ept_eptp() te=
st
>       nVMX: Add a testcase for running L2 with EP4TA that points at MMIO
>       x86/pmu: Enable PEBS on fixed counters iff baseline PEBS is support
>       x86/pmu: Iterate over adaptive PEBS flag combinations
>       x86/pmu: Test adaptive PEBS without any adaptive counters
>       x86/pmu: Add a PEBS test to verify the host LBRs aren't leaked to t=
he guest
>       nVMX: Ensure host's PAT is loaded at the end of all VMX tests
>       nVMX: Verify KVM actually loads the value in HOST_PAT into the PAT =
MSR
>
> Yang Weijiang (3):
>       nVMX: Exclude CR4.CET from the test_vmxon_bad_cr()
>       nVMX: Rename union vmx_basic and related global variable
>       nVMX: Introduce new vmx_basic MSR feature bit for vmx tests
>
>  lib/x86/apic.h       |   5 +
>  lib/x86/asm/bitops.h |   8 +
>  lib/x86/desc.h       |  30 +++-
>  lib/x86/pmu.h        |   6 +-
>  lib/x86/processor.h  |  24 ++-
>  x86/asyncpf.c        | 154 ++++++++++------
>  x86/msr.c            |  23 ++-
>  x86/pmu.c            |   1 +
>  x86/pmu_pebs.c       | 110 +++++++-----
>  x86/unittests.cfg    |  19 +-
>  x86/vmx.c            |  50 +++---
>  x86/vmx.h            |   7 +-
>  x86/vmx_tests.c      | 497 +++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  13 files changed, 755 insertions(+), 179 deletions(-)
>


