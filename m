Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5AF616B21
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKBRpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKBRpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:45:36 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5511120F70
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:45:35 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r18so16825520pgr.12
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d2NR8DN1mO3cM2wwESBLyU8DIMkDsTWlLb6xzwE2TK0=;
        b=qUueIo1EWqy+ZhA30ALQsEXAGt4wCKaD8UaCRzFDrZLGLu2MSukKQtw61Bqet6ApTO
         WMfvlzsQxNGgxtDYmBnxFDUQsXCeeGQvO6yvrwMFpK+fLPFZDZ1aZHokg5F2kqD1gLCx
         WsM0y/MgoC/jsMhXXkTSe/QQyypYzf71ksBXdWWE6GUOE2D9aszsAoGXcInp3r3oNQts
         GSLOXRJDIH+FDokMejfKrmPK7javGnpfgvhsUgagjHKwWpeJVN10X9lU/TfL6RVv3Ug8
         3/arGdwnt4zntHDLXZDmhxHr8Z8YBTKg0uuODbrplAPxCOyqA6FjUVTqQX3eBO2cV5yd
         PBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2NR8DN1mO3cM2wwESBLyU8DIMkDsTWlLb6xzwE2TK0=;
        b=oG1pvQ99eUamRrq2D9n6xO9LpV4gqodHbk7yJHT3Kc6o++zIln0Or78R9qAfa+6+3y
         DbukTJbUjnk4kqLyWQGGjZLBeI1PZBuIyIJHjE8VjYy70u95zgrVqo4hmhVYMWlJGyIe
         V4TJbF6cfAntfxwHdZc052h6dcpJLnLO5KhbvBoJcWBxioOBVo53wuAc8wTjPzYyk1SM
         1vtgHlFU5IvuLG0AvybX0GgJz2p9wFY+yNH9Ph3k1UntslOmmYAkun6QslzPNS8EdiLr
         ZWO/AtI0Om9Y4xRsYDlOoxGMmmYA3uKPd2iS35SxSHUvRLwjK2u9y0YDrj9soehH5XYB
         Lcbg==
X-Gm-Message-State: ACrzQf0hndfDrrcqCUGLlsi1DZIqo9NZTEOI9Qwx5jKD0yr6VKI1o/BX
        0reRznvQ1bSO4Hl/myCxwcNEWg==
X-Google-Smtp-Source: AMsMyM5aa1gTL8f1pll6t9LXAqG/eBxs11x/IcRY2tR7ruMaZ3860MCegsdnWBzJeehc3JOwhN+Xcw==
X-Received: by 2002:a65:5b47:0:b0:46b:1a7d:7106 with SMTP id y7-20020a655b47000000b0046b1a7d7106mr22295642pgr.513.1667411134759;
        Wed, 02 Nov 2022 10:45:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k27-20020aa79d1b000000b0056be55df0c8sm8695463pfp.116.2022.11.02.10.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:45:34 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:45:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 14/24] x86/pmu: Read cpuid(10) in the
 pmu_init() to reduce VM-Exit
Message-ID: <Y2Ksut4FjmPZiuHo@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-15-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-15-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The type of CPUID accessors can also go in the common pmu. Re-reading
> cpuid(10) each time when needed, adding the overhead of eimulating
> CPUID isn't meaningless in the grand scheme of the test.
> 
> A common "PMU init" routine would allow the library to provide helpers
> access to more PMU common information.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  lib/x86/pmu.c |  7 +++++++
>  lib/x86/pmu.h | 26 +++++++++++++-------------
>  lib/x86/smp.c |  2 ++
>  3 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index 9d048ab..e8b9ae9 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -1 +1,8 @@
>  #include "pmu.h"
> +
> +struct cpuid cpuid_10;
> +
> +void pmu_init(void)
> +{
> +    cpuid_10 = cpuid(10);

Tabs, not spaces.

> +}
> \ No newline at end of file
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index 078a974..7f4e797 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -33,9 +33,13 @@
>  #define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
>  #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
>  
> +extern struct cpuid cpuid_10;

Instead of taking a raw snapshot of CPUID.0xA, process the CPUID info during
pmu_init() and fill "struct pmu_cap pmu" directly.

> diff --git a/lib/x86/smp.c b/lib/x86/smp.c
> index b9b91c7..29197fc 100644
> --- a/lib/x86/smp.c
> +++ b/lib/x86/smp.c
> @@ -4,6 +4,7 @@
>  #include <asm/barrier.h>
>  
>  #include "processor.h"
> +#include "pmu.h"
>  #include "atomic.h"
>  #include "smp.h"
>  #include "apic.h"
> @@ -155,6 +156,7 @@ void smp_init(void)
>  		on_cpu(i, setup_smp_id, 0);
>  
>  	atomic_inc(&active_cpus);
> +	pmu_init();

Initializing the PMU has nothing to do with SMP initialization.  There's also an
opportunity for more cleanup: all paths call bringup_aps() => enable_x2apic() =>
smp_init(), providing a kitchen sink helper can consolidate that code and provide
a convenient location for PMU initialization.

void bsp_rest_init(void)
{
	bringup_aps();
	enable_x2apic();
	smp_init();
	pmu_init();
}
