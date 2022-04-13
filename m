Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8445001ED
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 00:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiDMWiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiDMWiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 18:38:04 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13AE4D621
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 15:35:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s8so3208269pfk.12
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 15:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nv3HlmL61/DZlYIUZDOTsCLYosmOGpppxKgJGQnygDE=;
        b=aem11bdDHHr6FO5DZ6ZNCnM8lUQhLP6hZDhgknJiS7VCX8jWpBxXIbCKXu9q/CGzXb
         3qIJ3FjY1fQfWLCVqyW3ExIS2UaKYj25lhKPcmM1s/oR+UGe9r6f8bbd4JTn85bsx8wl
         dT8Wx7Z4TdIchMsM7yB3cGb/+BLT0Ryi8TrAWNWFxe0F9r2KJC5YzOhAzbIMRRtIsqua
         NAtXw0jvYjAvGXaiqtomygIoxGkRwqzBZJGB88dlVjyEJiQg9JM3zCO3RLjujNpYIze6
         do9vJvwG1li5JQDzwIVhlKqf4G+ibU9mUXUG6C8nOis4Lv2TKlFF8KdzFVqi4E5/Z20w
         W+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nv3HlmL61/DZlYIUZDOTsCLYosmOGpppxKgJGQnygDE=;
        b=b4kYC11Jof2GuQ9b3nYl32M0CSyMc4oJA3TuiVB2cWRoQVhDckuHhhmpzEmoGT1ATN
         353a9hJdQWV4oaDlSl2TVghMUKLDnYfEYDnguuINRO5KSCWF7DV2ZTIpBN24kEP3dpug
         IfrxGSrUbv7HbtLF7SBBb/XumLYSZvotYSkDszpYyY83ciLPaqezO6KaVoOMd5JDpAij
         sIYZjX6hTR5n8zA/knUX4Irogf/ibgn2Ue8DzGkf30gp16d0XVvHgYm4SdQ6bZ1WIgmZ
         +cVOGGdSLk9UitnCfn+THCKiinBFJ5KbdH/Q8UHfRrFAANJtRgcU2phBhGymxcxX4Ita
         0pgw==
X-Gm-Message-State: AOAM531VLmr4IMaVpInIvrFYaEszX7Ro+qBirbxOYX6hkDk09Ugnhg8T
        yGlmzDHPpnMBmUXb7c4SBWPigQ==
X-Google-Smtp-Source: ABdhPJxuAddxkVcbOQLbigo8IDUEh3UMYyVTaZA0g0GKsTcx0mXsQCR74uZYzTOl7EHZWB+LVc/iNw==
X-Received: by 2002:a05:6a00:2181:b0:4f6:f1b1:1ba7 with SMTP id h1-20020a056a00218100b004f6f1b11ba7mr924612pfi.73.1649889341051;
        Wed, 13 Apr 2022 15:35:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm121369pga.38.2022.04.13.15.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 15:35:40 -0700 (PDT)
Date:   Wed, 13 Apr 2022 22:35:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v5 06/10] KVM: selftests: Add NX huge pages test
Message-ID: <YldQOJjqLJxRz6Ea@google.com>
References: <20220413175944.71705-1-bgardon@google.com>
 <20220413175944.71705-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413175944.71705-7-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022, Ben Gardon wrote:
> There's currently no test coverage of NX hugepages in KVM selftests, so
> add a basic test to ensure that the feature works as intended.

...

> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> new file mode 100644
> index 000000000000..7f80e48781fd
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * tools/testing/selftests/kvm/nx_huge_page_test.c
> + *
> + * Usage: to be run via nx_huge_page_test.sh, which does the necessary
> + * environment setup and teardown

It would be really nice if this test could either (a) do something useful without
having to manually set /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages,
or (b) refuse to run unless it's (likely) been invoked by the script.  E.g. maybe
add a magic token that must be passed in?  That way just running the bare test
will provide a helpful skip message, but someone that wants to fiddle with it can
still run it manually.

> +int main(int argc, char **argv)
> +{
> +	struct kvm_vm *vm;
> +	struct timespec ts;
> +	void *hva;

This needs to check if the workaround is actually enabled via module param.  Not
as big a deal if there's a magic number, but it's also not too hard to query a
module param.  Or at least, it shouldn't be, I'm fairly certain that's one of the
things I want to address in the selftests overhaul.

Aha! Actually, IIUC, the patch that validates the per-VM override adds full support
for the module param being turned off.

So, how about pull in the tweaks to the expected number to this patch, and then
the per-VM override test just makes disable_nx a logical OR of the module param
beyond off or the test using the per-VM override.

> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> new file mode 100755
> index 000000000000..19fc95723fcb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -0,0 +1,25 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only */
> +
> +# tools/testing/selftests/kvm/nx_huge_page_test.sh
> +# Copyright (C) 2022, Google LLC.

This should either check for root or use sudo.

> +NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
> +NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> +NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> +HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
> +
> +echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> +echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +
> +./nx_huge_pages_test

I would much prefer this find its path and use that to reference the test, e.g. this
fails if invoking the script from anything but the x86_64 subdirectory.  I'd provide
a snippet of how to do that, but my scripting skills are garbage :-)

> +RET=$?
> +
> +echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> +echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +
> +exit $RET
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
