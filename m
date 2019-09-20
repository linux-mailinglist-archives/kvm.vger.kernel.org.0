Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF5B90B3
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfITNdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 09:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15821 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfITNdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 09:33:50 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28C2F368CF
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 13:33:50 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id f11so2286484wrt.18
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 06:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Nx/aQvRelzeLvCi79YG6MG8KeIQqwCv6VmFW22dXX5s=;
        b=muhgBXtD2XFfhkEwFbRWibt0RsyISnRw98E/lHRoUvqmuJbE7kYp6PksHP6Byiu7nC
         bR8dm+CDvOjLO9frPANn8vgFcWw76/vELEjfXV0IQbcEWmrNCqpDupp0NMV4cPZizmps
         pMph2AVOMjlpzLMNg2JxGJpuMi+iVhPqlQrCNK+4KgeK1Eo/ZGe1pf5914VwcnU7Ry2x
         nJ7sQf2pwSgcCnVeNQoo2YZyfKHWjkb6G+0lS+30DlmnITdH3yIa/Qg4gwZYcm3fMIgp
         vWtxr5MYWlqh2gXrPOVvphUezCHK/FwvZgVPR7P9c5YghRlBG/oeAxHkPCaJ+lP9xYyG
         ne0g==
X-Gm-Message-State: APjAAAUbZFWh9dy8f4r9KjOXACDUdY5Rm+RxO9LsvLPNrvB1LuxwHpBq
        wuz55Yxp+uyV3MRmiekV+N+w9c328K0U8Yyxqzn3BQzAy5D+DBPJqWzULDGqr9l6G/UGERF6DBm
        G9eHKbVdEe+Yc
X-Received: by 2002:a1c:608b:: with SMTP id u133mr3588935wmb.27.1568986428853;
        Fri, 20 Sep 2019 06:33:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxK0NaSgNeM2SWzbThQeAoHLMH7PRhHAfioEXu+xSV+Ql4+lSoQwnNXX4A4YPUbKk9NRokT7A==
X-Received: by 2002:a1c:608b:: with SMTP id u133mr3588918wmb.27.1568986428623;
        Fri, 20 Sep 2019 06:33:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c1sm1536496wmk.20.2019.09.20.06.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 06:33:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de
Subject: Re: [RFC 2/2] x86/kvmclock: Use host timekeeping.
In-Reply-To: <20190920062713.78503-3-suleiman@google.com>
References: <20190920062713.78503-1-suleiman@google.com> <20190920062713.78503-3-suleiman@google.com>
Date:   Fri, 20 Sep 2019 15:33:47 +0200
Message-ID: <87woe38538.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> When CONFIG_KVMCLOCK_HOST_TIMEKEEPING is enabled, and the host
> supports it, update our timekeeping parameters to be the same as
> the host. This lets us have our time synchronized with the host's,
> even in the presence of host NTP or suspend.
>
> When enabled, kvmclock uses raw tsc instead of pvclock.
>
> When enabled, syscalls that can change time, such as settimeofday(2)
> or adj_timex(2) are disabled in the guest.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/Kconfig                |   9 +++
>  arch/x86/include/asm/kvmclock.h |   2 +
>  arch/x86/kernel/kvmclock.c      | 127 +++++++++++++++++++++++++++++++-
>  kernel/time/timekeeping.c       |  21 ++++++
>  4 files changed, 155 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4195f44c6a09..37299377d9d7 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -837,6 +837,15 @@ config PARAVIRT_TIME_ACCOUNTING
>  config PARAVIRT_CLOCK
>  	bool
>  
> +config KVMCLOCK_HOST_TIMEKEEPING
> +	bool "kvmclock uses host timekeeping"
> +	depends on KVM_GUEST
> +	---help---
> +	  Select this option to make the guest use the same timekeeping
> +	  parameters as the host. This means that time will be almost
> +	  exactly the same between the two. Only works if the host uses "tsc"
> +	  clocksource.
> +

I'd also like to speak up against this config, it is confusing. In case
the goal is to come up with a TSC-based clock for guests which will
return the same as clock_gettime() on the host (or, is the goal to just
have the same reading for all guests on the host?) I'd suggest we create
a separate (from KVMCLOCK) clocksource (mirroring host timekeeper) and
guests will be free to pick the one they like.

-- 
Vitaly
