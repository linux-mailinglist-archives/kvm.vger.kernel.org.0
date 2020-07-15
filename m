Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2178C2201E5
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgGOBe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:34:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CCC061794
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:34:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k5so1052138pjg.3
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zz6sLV8XJxd0lbywoq+z85UDCAeRpW0uEyFQlztJWmw=;
        b=KjZxK4Awqpk1vfXGfBYtI692U7BsBujqOCkBI+QG+yLB2j4Qw3QvteuLd4a70rZ1/c
         yaDe72GoCa2XdEfwiQXcF8IrP6J+bX89NN+6MR8q9jktHJFEmwVxwDVVvmr+PfDGg7Xe
         FDl+SZBUCt2yGQdyLb8rU0QxX4PkdOaDCRikM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zz6sLV8XJxd0lbywoq+z85UDCAeRpW0uEyFQlztJWmw=;
        b=k2K1FmXS6KXX7eAf5dJ4PgKgw5gXmOxb8vkviMcHLiqqqB4p8CtgE2ATJrcXMhxh6H
         WJCeCxqp84/V1HzL5v6RUyaLZpYoVyUUB/oQKqjaXvCps3/s79xd6nX0+HkR3V+pSljP
         scQCS8wHJRI0qSMXmVBQm0OB9Xl1mTQOPYdBH8MDXzl1SlRcDQpmUentA19A+Z/qFNSX
         Xe0E4MZzAM7116stEuNzYGrqCQUSGyyj1x3QOaiOP+EmWy9GLG+BzucoS6CBrQLf0Pw3
         IM31H9HDe4qZ9FiWA0xLXcIAQN/ARZxBq/zR020on0XgI0NtE1WSCNCBJE1bKFBJtLL+
         OfxQ==
X-Gm-Message-State: AOAM531zqFRPHh5xL9TGgobgqC3La6QvbO67+kL8Z2QPgi8GGefYedqu
        ml+47q92fO76N6lI+k8e0OH6mA==
X-Google-Smtp-Source: ABdhPJyNqRvX4HpWN93/opBS43GZlWTdZSRq6ybyZkwfnv39UPGj+ErGvx/2WaJfYSwsGuR1sTBmcw==
X-Received: by 2002:a17:90a:1f87:: with SMTP id x7mr7556364pja.101.1594776866202;
        Tue, 14 Jul 2020 18:34:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b18sm276216pju.10.2020.07.14.18.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:34:25 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:34:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 34/75] x86/head/64: Build k/head64.c with
 -fno-stack-protector
Message-ID: <202007141831.F3165F22@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-35-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-35-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:36PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The code inserted by the stack protector does not work in the early
> boot environment because it uses the GS segment, at least with memory
> encryption enabled. Make sure the early code is compiled without this
> feature enabled.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index e77261db2391..1b166b866059 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -39,6 +39,10 @@ ifdef CONFIG_FRAME_POINTER
>  OBJECT_FILES_NON_STANDARD_ftrace_$(BITS).o		:= y
>  endif
>  
> +# make sure head64.c is built without stack protector
> +nostackp := $(call cc-option, -fno-stack-protector)
> +CFLAGS_head64.o		:= $(nostackp)

Recent refactoring[1] for stack protector suggests this should just
unconditionally be:

CFLAGS_head64.o			+= -fno-stack-protector

But otherwise, yeah, this should be fine here -- it's all early init
stuff.

Reviewed-by: Kees Cook <keescook@chromium.org>

[1] https://lore.kernel.org/lkml/20200626185913.92890-1-masahiroy@kernel.org/

> +
>  # If instrumentation of this dir is enabled, boot hangs during first second.
>  # Probably could be more selective here, but note that files related to irqs,
>  # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
> -- 
> 2.27.0
> 

-- 
Kees Cook
