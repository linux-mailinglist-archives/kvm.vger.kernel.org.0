Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04CA37F321
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 08:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhEMGix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 02:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230478AbhEMGiv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 02:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620887861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9mkTkonP9uztCISBGQUSTSH31laLWa1RLov7sxsUUU=;
        b=ekRafYStxNB+6BlKTfmYtkHTOhE4Iu58A2K582ODUirySApWn5Dt2IOepHDlfRV1vAWLGR
        GiDUgp0Joxf6wBBMi2nqj/63xk4xfgVakyIfQrFI9UAg3pl04GB4nmoKligRxdiY13b+kN
        d79Yul2i8SiaFmN7Zr28jCupk1jjSVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-VoixZ2QuPGi4mitFYrQpGQ-1; Thu, 13 May 2021 02:37:38 -0400
X-MC-Unique: VoixZ2QuPGi4mitFYrQpGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 339B31008545;
        Thu, 13 May 2021 06:37:37 +0000 (UTC)
Received: from [10.36.112.87] (ovpn-112-87.ams2.redhat.com [10.36.112.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8615D6D8C0;
        Thu, 13 May 2021 06:37:35 +0000 (UTC)
Subject: Re: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and debug
 test
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
References: <20210513002802.3671838-1-ricarkol@google.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <aeeec52e-5a13-be39-3b9c-cf25a27b97b1@redhat.com>
Date:   Thu, 13 May 2021 08:37:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 5/13/21 2:27 AM, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo
> 
> v2 -> v3:
> 
> Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
> the reviews and tests from Eric and Zenghui.
You are welcome. This version does not fail anymore on Cavium Sabre so
this looks to fix the previously reported issue.

Thanks

Eric
> - add missing ISBs after writing into debug registers.
> - not store/restore of sp_el0 on exceptions.
> - add default handlers for Error and FIQ.
> - change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
> - use Andrew's suggestion regarding __GUEST_ASSERT modifications
>   in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).
> 
> v1 -> v2:
> 
> Addressed comments from Andrew and Marc (thank you very much):
> - rename vm_handle_exception in all tests.
> - introduce UCALL_UNHANDLED in x86 first.
> - move GUEST_ASSERT_EQ to common utils header.
> - handle sync and other exceptions separately: use two tables (like
>   kvm-unit-tests).
> - add two separate functions for installing sync versus other exceptions
> - changes in handlers.S: use the same layout as user_pt_regs, treat the
>   EL1t vectors as invalid, refactor the vector table creation to not use
>   manual numbering, add comments, remove LR from the stored registers.
> - changes in debug-exceptions.c: remove unused headers, use the common
>   GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> - changes in processor.h: write_sysreg with support for xzr, replace EL1
>   with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> 
> Ricardo Koller (5):
>   KVM: selftests: Rename vm_handle_exception
>   KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
>     reporting
>   KVM: selftests: Move GUEST_ASSERT_EQ to utils header
>   KVM: selftests: Add exception handling support for aarch64
>   KVM: selftests: Add aarch64/debug-exceptions test
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
>  .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
>  .../selftests/kvm/include/x86_64/processor.h  |   4 +-
>  .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     | 131 +++++++++
>  .../selftests/kvm/lib/x86_64/processor.c      |  22 +-
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
>  .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
>  13 files changed, 615 insertions(+), 47 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 

