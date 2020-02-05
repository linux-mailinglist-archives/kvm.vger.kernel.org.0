Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A791152A20
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBELp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:45:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbgBELp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580903155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qew9pA6q2eKxei1b7rOjMSLdZuvXZkTmwP0IR146xxg=;
        b=DK8KueOUcyhiMF6F8pHdtG2ENI900esqmmaGwpf9cffXDAdnq+suy5VcsOAB1jpxLlENuI
        KByhM3lDsI+/ZxURCX8fLGDcR4YgV3ScVYeTpIAbFYemr6ATK99eJAa7Gy9XEt6kFMmKgr
        LW0iU4eaOxqM0qAFfAN19OjGKOfPjXs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-i1DcIYzzO9aPmA5TMrcJGg-1; Wed, 05 Feb 2020 06:45:53 -0500
X-MC-Unique: i1DcIYzzO9aPmA5TMrcJGg-1
Received: by mail-wm1-f69.google.com with SMTP id d4so727723wmd.7
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 03:45:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qew9pA6q2eKxei1b7rOjMSLdZuvXZkTmwP0IR146xxg=;
        b=OXqI7WmH+C31goo1yNstSquTlkz3hIOGPDUEg5oKK9dLmCV5MkBQCEyfLw5ca/xlBb
         VLB2yTpt4pKTjLINUggRJLN8Yzr7riiu7msRnG+3QkEKKATJroV6BdvX9sHaNXv0aj1b
         +mzbrxhJk9iAWDiyj/hF0lrLiQfM5iTbJSWex7x7S7Tm5hE17w/TLJ/DnMKCS6fkAP7Y
         Kx24V6moMbMvC1/zoFPHvLJw1Mshg6ZN+duXKZs7zaDjtt2r8tO6hvjaFBDIKXYgEobI
         l0M2/C78d/BoCJKbkrRoaKbd84LNrGWuEFkAEw1YlgE9JxJ+9B08Nl9U0nidVBm+1ZZL
         QdkQ==
X-Gm-Message-State: APjAAAU6wQAA7j7f7cgXbIwv3rpKWVELnRlaIbrGjm/cryU6aqQjYmdA
        Ty8zS1uREWtSmOfmeuQL/twCwvdRDaZi9x5u31wk+xNbLA8tlIYjX3LVyEWuEKZ+dzDnV35sod+
        M96PxUtFQxM+j
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr5093127wmh.12.1580903152365;
        Wed, 05 Feb 2020 03:45:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4Kb21norHArN164n5Q5tzgN7BVgByConiKC2q0y5k32GhxC1/mCLz7bfqggAaHPRCf+WeUg==
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr5093110wmh.12.1580903152160;
        Wed, 05 Feb 2020 03:45:52 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n3sm33297899wrs.8.2020.02.05.03.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 03:45:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eric Hankland <ehankland@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Hankland <ehankland@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test WRMSR on a running counter
In-Reply-To: <20200204012504.9590-1-ehankland@google.com>
References: <20200204012504.9590-1-ehankland@google.com>
Date:   Wed, 05 Feb 2020 12:45:50 +0100
Message-ID: <87y2thl0k1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eric Hankland <ehankland@google.com> writes:

> Ensure that the value of the counter was successfully set to 0 after
> writing it while the counter was running.
>
> Signed-off-by: Eric Hankland <ehankland@google.com>
> ---
>  x86/pmu.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index cb8c9e3..8a77993 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -419,6 +419,21 @@ static void check_rdpmc(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_running_counter_wrmsr(void)
> +{
> +	pmu_counter_t evt = {
> +		.ctr = MSR_IA32_PERFCTR0,
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> +		.count = 0,
> +	};
> +
> +	start_event(&evt);
> +	loop();
> +	wrmsr(MSR_IA32_PERFCTR0, 0);
> +	stop_event(&evt);
> +	report("running counter wrmsr", evt.count < gp_events[1].min);
> +}
> +
>  int main(int ac, char **av)
>  {
>  	struct cpuid id = cpuid(10);
> @@ -453,6 +468,7 @@ int main(int ac, char **av)
>  	check_counters_many();
>  	check_counter_overflow();
>  	check_gp_counter_cmask();
> +	check_running_counter_wrmsr();
>  
>  	return report_summary();
>  }
>

You shall not pass [-Werror]:

gcc  -mno-red-zone -mno-sse -mno-sse2 -m64 -O1 -g -MMD -MF x86/.pmu.d -fno-strict-aliasing -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fno-omit-frame-pointer    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=gnu99 -ffreestanding -I /home/vitty/workspace/Upstream/kvm-unit-tests/lib -I /home/vitty/workspace/Upstream/kvm-unit-tests/lib/x86 -I lib   -c -o x86/pmu.o x86/pmu.c
x86/pmu.c: In function ‘check_running_counter_wrmsr’:
x86/pmu.c:435:44: error: passing argument 2 of ‘report’ makes pointer from integer without a cast [-Werror=int-conversion]
  435 |  report("running counter wrmsr", evt.count < gp_events[1].min);
      |                                  ~~~~~~~~~~^~~~~~~~~~~~~~~~~~
      |                                            |
      |                                            int
In file included from /home/vitty/workspace/Upstream/kvm-unit-tests/lib/x86/processor.h:4,
                 from x86/pmu.c:3:
/home/vitty/workspace/Upstream/kvm-unit-tests/lib/libcflat.h:102:43: note: expected ‘const char *’ but argument is of type ‘int’
  102 | extern void report(bool pass, const char *msg_fmt, ...)
      |                               ~~~~~~~~~~~~^~~~~~~
cc1: all warnings being treated as errors


-- 
Vitaly

