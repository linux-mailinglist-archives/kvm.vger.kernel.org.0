Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F37193CD5
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 11:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgCZKRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 06:17:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34149 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZKRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 06:17:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id 65so7061153wrl.1
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 03:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UfJd8ZmzjrF5pKc68uc6PImNDV9eCz7+cwylT0iK8ts=;
        b=JliWM1wRQBiU1WaxBOnbX9r9308kU10VLlDFX+c6Vs25LyF0yKjG7goxEoufVMmakc
         Mj9RKrbTLuEH9Y1EledRjVwlPdhc9hUtkacV8R/wdQwQ0J8Syb6gDlyBi/x6KSaXYfCb
         N7GvunUb7+SYEOy24EIclq9R/1WN4fab+iN6rM1ab/qlMgXCZKhdN7uyoJUbinhVchK0
         TniWliY4kjeDAqmGViGAuy3rR5oA6hINMq2QTT+1cCYQC4rURY7HiWgpWEKGEmQrkaNS
         z8+QW1f74x2aeFMaFfZL4MB2PRCxS5LUbB1w/d5JrvI/bkPvHOk3FCEyoHuWwax1WvYW
         YdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UfJd8ZmzjrF5pKc68uc6PImNDV9eCz7+cwylT0iK8ts=;
        b=C+wiYZy9AJJ2i+fRj/t3ToS0upCVdHDGh8CAYlDI1qYnLHFZ9fUUE0wFdovC3eU0FS
         SZZjW5wLBrE9fvGlhiO+6VK0pgwi7Ts+yI37I8dz/v/PG2FxnH4QOT/Ob06JlbAL7Xw0
         GVez+o3oZsEdXTg5xPAI1+hkxCozzF7SRaWXwl149mEtTqORhj5URHeN6QnIRixeJfZg
         h3TBtQK99abw+LGJQ4D/boNsRxXJESlkEnwxiRxmgXaMj84iEuAdaaBVnTE6axboXnEE
         63URJKJRr7KR8lHOmdgCYzi06OOKmdXcVzep3cpZ1J2+dLcZ3pF3kcaaudUV4Wj9K2W5
         ifVQ==
X-Gm-Message-State: ANhLgQ3tRJmSlwAd2/8+9sT4OOyJOZZUmn2MYqeVW8zW1RI+5AZF2hLo
        j98njjpWd6VbVjxsNs0HLwE1PA==
X-Google-Smtp-Source: ADFU+vtYgdqu1iFA3EFU13wqSJRUhSE1RdRkdpnCijLZr09pmk1V43wx1G/9puarDu1bz5EjTdYlbQ==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr8803665wrs.191.1585217872055;
        Thu, 26 Mar 2020 03:17:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
        by smtp.gmail.com with ESMTPSA id g7sm2997217wrq.21.2020.03.26.03.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 03:17:51 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:17:48 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefan Agner <stefan@agner.ch>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Takashi Yoshi <takashi@yoshi.email>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v2 0/7] Removing support for 32bit KVM/arm host
Message-ID: <20200326101748.GA126150@google.com>
References: <20200324103350.138077-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324103350.138077-1-maz@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tuesday 24 Mar 2020 at 10:33:43 (+0000), Marc Zyngier wrote:
> Marc Zyngier (7):
>   arm: Unplug KVM from the build system
>   arm: Remove KVM from config files
>   arm: Remove 32bit KVM host support
>   arm: Remove HYP/Stage-2 page-table support
>   arm: Remove GICv3 vgic compatibility macros
>   arm: Remove the ability to set HYP vectors outside of the decompressor
>   MAINTAINERS: RIP KVM/arm

I've been staring at these patches for some time now and all looks good
to me. So, for the entire series:

Reviewed-by: Quentin Perret <qperret@google.com>

FWIW, as mentioned in a previous thread, I'm currently working with Will
on an extension of KVM to support guest isolation, and the arm32 port
was unfortunately making it really hard to do intrusive changes, so this
is much appreciated!

Thanks,
Quentin
