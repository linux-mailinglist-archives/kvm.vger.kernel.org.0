Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038132A0D3C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgJ3SRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbgJ3SRx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 14:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604081870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csk+mbaGG3H8tlflU2nzo4HiaGzpnObXjkVlNbYBe/E=;
        b=ZpEQD0469BjFKU5KvvUU1HklDhg6EJK0ag80QnxAOS+xqPAaEOe/SQC8HsBm5sKmosoTYa
        tqkSOYZR5Soc3p0nkZNGIbLJk4MZuJqNAGbeOEUqAu6Sw3GfOYG1YXEe2nK+r35msz/DRS
        Ly9oLnxbsPLYzN/aCI7lcidm7t51dfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-PryX66QOM1iq7fvQvdlZvA-1; Fri, 30 Oct 2020 14:17:47 -0400
X-MC-Unique: PryX66QOM1iq7fvQvdlZvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C0080B702;
        Fri, 30 Oct 2020 18:17:46 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F1A455785;
        Fri, 30 Oct 2020 18:17:44 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Andrew Jones <drjones@redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <88f5068a-7a1c-4870-ebc4-e2c45616e905@redhat.com>
Date:   Fri, 30 Oct 2020 19:17:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

[+ Drew]

On 10/27/20 6:19 PM, Alexandru Elisei wrote:
> This series implements two basic tests for KVM SPE: one that checks that
> the reported features match what is specified in the architecture,
> implemented in patch #3 ("arm64: spe: Add introspection test"), and another
> test that checks that the buffer management interrupt is asserted
> correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
> of the patches are either preparatory patches, or a fix, in the case of
> patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").
> 
> This series builds on Eric's initial version [1], to which I've added the
> buffer tests that I used while developing SPE support for KVM.

As you respin my series, with my prior agreement, I expected to find
most of the code I wrote, obviously with some potential fixes and
adaptations to fit your needs for additional tests.

However, in this v2, two significant v1 patches have disappeared:

1) [3/4] spe: Add profiling buffer test (170 LOC diffstat)
2) [4/4] spe: Test Profiling Buffer Events (150 LOC diffstat)

They were actually the crux of the original series (the introspection
test being required as a prerequisite but not testing much really ;-).

1) consists in a "spe-buffer" test starting the profiling on a mastered
sequence of instructions (as done for PMU event counters). It introduces
the infra to start the profiling, prepare SPE reset config, the macro
definitions, start/stop/drain, the code under profiling and basically
checks that the buffer was effectively written. We also check we do not
get any spurious event as it is not expected.

=> This test has disappeared and the infra now is diluted in
[kvm-unit-tests RFC PATCH v2 5/5] am64: spe: Add buffer test. However no
credit is given to my work as my S-o-b has disappeared.

2) consists in a "spe-events" test checking we effectively get the
buffer full event when duly expected. This introduces the infra to
handle interrupts, check the occurence of events by analyzing the
syndrome registers, compare occurences against expected ones. This
largely mimics what we have with PMU tests.

=> This test is part of [kvm-unit-tests RFC PATCH v2 5/5], relying on a
different stop condition, and again the infra is diluted in the same
patch, with large arbitrary changes, without any credit given to my
work. Those changes may explain why you removed my S-o-b but given the
anteriority of my series, this does not look normal to me, in a
community environment.

As discussed privately, this gives me the impression that those two
patches were totally ignored while respinning.

Please could you restructure the series at least to keep the buffer-full
test + infra separate from the new tests and reset a collaborative S-o-b.

Then if you think there are issues wrt the 1st test, "spe-buffer", not
included in this series, please let's discuss and fix/improve but not
simply trash it as is (in an everyone growing spirit).

An alternative is I can take back the ownership of my series and push it
upstream in a standard way. Then either you rebase your new tests on top
of it or I will be happy to do it for you after discussions on the
technical comments.

Thanks

Eric

> 
> KVM SPE support is current in RFC phase, hence why this series is also sent
> as RFC. The KVM patches needed for the tests to work can be found at [2].
> Userspace support is also necessary, which I've implemented for kvmtool;
> this can be found at [3]. This series is also available in a repo [4] to make
> testing easier.
> 
> [1] https://www.spinics.net/lists/kvm/msg223792.html
> [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3
> [3] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
> [4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v2
> 
> Alexandru Elisei (3):
>   lib/{bitops,alloc_page}.h: Add missing headers
>   lib: arm/arm64: Add function to unmap a page
>   am64: spe: Add buffer test
> 
> Eric Auger (2):
>   arm64: Move get_id_aa64dfr0() in processor.h
>   arm64: spe: Add introspection test
> 
>  arm/Makefile.arm64        |   1 +
>  lib/arm/asm/mmu-api.h     |   1 +
>  lib/arm64/asm/processor.h |   5 +
>  lib/alloc_page.h          |   2 +
>  lib/bitops.h              |   2 +
>  lib/libcflat.h            |   1 +
>  lib/arm/mmu.c             |  32 +++
>  arm/pmu.c                 |   1 -
>  arm/spe.c                 | 506 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |  15 ++
>  10 files changed, 565 insertions(+), 1 deletion(-)
>  create mode 100644 arm/spe.c
> 

