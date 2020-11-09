Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49752AC05D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 17:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgKIQAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 11:00:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgKIQAg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 11:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604937634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9x2i9FhJ3FEdl0CuO9z7pB7e6HrDm7nT6Y35uAhzyuQ=;
        b=XZbNww9dfEEEgaD/9khfOjrn2rQTXAODAt52tSiV/M+f0VUyg0+7Je252tF8jInszmnrjc
        jZRINbEOj8N21tOfyhVYchvmAswwPiEcqT2QeCQE38QV5AUFYgplyRwY7IzebFE9DKRexW
        aLVoZ/b5YSdJPNs5KOW7Pb7PRMmCZGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-ji2dBrXoOme5FwMdlQUdSQ-1; Mon, 09 Nov 2020 11:00:31 -0500
X-MC-Unique: ji2dBrXoOme5FwMdlQUdSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5430CCE642;
        Mon,  9 Nov 2020 16:00:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E219E5DA82;
        Mon,  9 Nov 2020 16:00:23 +0000 (UTC)
Date:   Mon, 9 Nov 2020 17:00:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, Eric Auger <eric.auger@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Fix compilation errors
Message-ID: <20201109160020.atjjurkh3mwteork@kamzik.brq.redhat.com>
References: <20201105135936.55088-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105135936.55088-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 01:59:36PM +0000, Alexandru Elisei wrote:
> Using arm-none-eabi-gcc triggers the following compilation errors:
> 
> $ ./configure --arch=arm --cross-prefix=arm-none-eabi-
> $ make clean
> $ make -j8
> [..]
> arm/pmu.c: In function 'pmu_probe':
> arm/pmu.c:1000:47: error: format '%c' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
>  1000 |  report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
>       |                                              ~^
>       |                                               |
>       |                                               int
>       |                                              %ld
>  1001 |       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
>  1002 |       ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
>       |       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                            |
>       |                                                            long unsigned int
> [..]
> arm/gic.c: In function 'test_byte_access':
> arm/gic.c:460:31: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
>   460 |   report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
>       |                            ~~~^             ~~~~~~~~~~~~~~
>       |                               |                     |
>       |                               unsigned int          u32 {aka long unsigned int}
>       |                            %08lx
> [..]
> arm/pl031.c: In function 'irq_handler':
> arm/pl031.c:153:39: error: format '%d' expects argument of type 'int', but argument 2 has type 'u32' {aka 'long unsigned int'} [-Werror=format=]
>   153 |   report_info("Unexpected interrupt: %d\n", irqnr);
>       |                                      ~^     ~~~~~
>       |                                       |     |
>       |                                       int   u32 {aka long unsigned int}
>       |                                      %ld
> 
> The errors were observed when using arm-none-eabi-gcc versions 10.2.0 and
> 9.2.0. No errors were found when using arm-linux-gnu-gcc version 10.2.1.
> 
> Replace the offending printf format specifiers with their PRIxxx
> counterparts defined by C99 and available in libcflat.h. Also remove the
> unnecessary call to get_pmcr() in pmu_probe(), as the pmcr value hasn't
> changed since initialization.
> 
> Nu functional changes intended by this patch.

  ^ I've fixed this typo

> 
> CC: Eric Auger <eric.auger@redhat.com>
> CC: Alexander Graf <graf@amazon.com>
> CC: Andre Przywara <andre.przywara@arm.com>
> CC: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Thanks Alex. I've queued this for the next Arm pull request.

> 
> Andre suggested that we drop using gcc's stdint.h and implement our own to avoid
> such errors in the future. The distro that I'm using on my desktop doesn't have
> the arm-linux-gnu toolchain in the default repos, so I figured I should send
> this fix to get things compiling again.
> 
> I have no preference for, or against, implementing our own types.h header file.
> I imagine it's not going to be easy to change the code to use it (possibly for
> all architectures), and it should be worth it in the long run.

I'd keep gcc's stdint.h for now, but it might be a good idea to post a
travis patch that tests compiling with your preferred toolchain.

Thanks,
drew

