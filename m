Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CAD318319
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhBKBdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBKBdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:33:45 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA280C061574
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:33:04 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id q9so3748630ilo.1
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZX7gml4kCnX4JimWReE5M7FOebZs0Y/94tKJJjoRbEg=;
        b=P+QcvpNHYJkwMopzAEZZFNujBRIkjXbjlnMcK1eu3ZYSAAgAx2YmRFKQxFBZFMkGdw
         dOKTidi7+ZgfkZrtkWhSfBq7IxOWNTmBSa1PLRgtVJYa2b1J5qlsp50RpRCHnghlvA24
         obmp0RzQpaX21TBTTm25gZ8EkLaZs82f3nTUUn0yP9GeY39OhOZ2iYpUyLRULaY8hTwh
         BdVZzeWyW9cg/KaJDJ5zfAWVl0+UrowQSOGY2seV3++4jfeXm8vjLLLXqAqJIjJ4m1NI
         PatVxPXAgP3GDMJS5y0sN1I2TjIXbOSAPbitKtGvFpAYMmsb1A/e5dvbpVoBtmdVEfKH
         JqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZX7gml4kCnX4JimWReE5M7FOebZs0Y/94tKJJjoRbEg=;
        b=UY7H2PXoeTJMQfM/Ud5IHBxEKjJOJo2b+Pmemq8gsQEED1CsWFneHxRAnFIDI3lFY8
         8DIMuNtw1Oht96/M49uLhbjnXyW8KUdOHrDFEBtx+rzUbWMi8nDcoUq5fm1fiSs7Jk19
         kmXRWhpVQ/zq9+EzXdZpiNK7hfg31FrV3WiQzRCZlyTcCqwfztbJUFMkitQ4HpBwG9oe
         GwBBPlUGuuZYEV4BCOIFKtCQho6QJD7ERlxmHGU9elLpLd6yqCYlipBBzlSsr0pKUrCc
         rzU//JaFJCaYJzt2BRjQnVJBC1PBOHblY5Hn/75n4h5BEDq+vmQZ/x7maKJ3WD2I5cVa
         P6jg==
X-Gm-Message-State: AOAM532rxLFAr+VymTDUkyszCcBs0nvgt0nSffE33nVJPZkVaus/Guc/
        akzojLq9ThwNbFrAzN3hVd5B36s2xcTf38L6SzKMRA==
X-Google-Smtp-Source: ABdhPJwnSuKQ9CNcOGJEZbgpH23zTEU1i74XFgZ4v8cHBFn+80U+G7o/CqYD0fPGuKhcyOQoAiowGm4xZBV+Ap7s/uY=
X-Received: by 2002:a92:c54e:: with SMTP id a14mr1209089ilj.285.1613007184233;
 Wed, 10 Feb 2021 17:33:04 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-12-seanjc@google.com>
In-Reply-To: <20210210230625.550939-12-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:32:53 -0800
Message-ID: <CANgfPd-D66s=78d8VbHHnpRLnWg134o+CApBVPRG2pUBSDR1Rw@mail.gmail.com>
Subject: Re: [PATCH 11/15] KVM: selftests: Create VM with adjusted number of
 guest pages for perf tests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use the already computed guest_num_pages when creating the so called
> extra VM pages for a perf test, and add a comment explaining why the
> pages are allocated as extra pages.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 982a86c8eeaa..9b0cfdf10772 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -71,9 +71,12 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
>                     "Guest memory size is not guest page size aligned.");
>
> -       vm = vm_create_with_vcpus(mode, vcpus,
> -                                 (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
> -                                 0, guest_code, NULL);
> +       /*
> +        * Pass guest_num_pages to populate the page tables for test memory.
> +        * The memory is also added to memslot 0, but that's a benign side
> +        * effect as KVM allows aliasing HVAs in memslots.
> +        */
> +       vm = vm_create_with_vcpus(mode, vcpus, 0, guest_num_pages, guest_code, NULL);
>         pta->vm = vm;
>
>         /*
> --
> 2.30.0.478.g8a0d178c01-goog
>
