Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D9F3B2AC6
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFXIyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhFXIyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 04:54:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CABC061574;
        Thu, 24 Jun 2021 01:52:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso3033299pjb.4;
        Thu, 24 Jun 2021 01:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=9iS9TDXjHYeeO4p1tZR6e76NZxX4UTo0tHhJ02Bmyuc=;
        b=mEGHBnjuh74WaoNyT1eKb/VOfvVFvX3kwUneJ5AncMO10vay7V/YPF/SG5j7p8iYH1
         7gxNCDvNzDqb55aG0xXgAC1RA62Wj+bbizWaJDKEr0nn3qnuj2jXLdTdeiyFZgIkzbU6
         eUXYZQk6B3lHcCn/C7rK9Hfy2ewbGQ+QcUAXV5aikZlnmoVPOh+oFpMVHi12RR/PQruY
         Y7ojicHYDpa1rl6bybFrRzQg1WLQ4vvo9pySUIlXsW7HorWi3IZfqYmc1PUso5nJwGuX
         l372R3hUka0ng8Md0fedsRzdAZ1LxWh9MkI+AQUHTjtMJyFheflEYDzQL0UNZQwWosBs
         cQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=9iS9TDXjHYeeO4p1tZR6e76NZxX4UTo0tHhJ02Bmyuc=;
        b=jQ5rxrGQ13xRJ44e4Xe4rYK1oAHYi/Xfobjw+bM8mBUcGTs5twvnC6JvzhWkXjERSv
         buj912GQt7b3XWiLxRg9l16uWy06FQ8t2Rqg1EVhM9N4Hvv5zavFcmzhxtbYYjnJ0zZv
         pVsESHH+ZbzEmGl6ohcrgDuOtY9yUGqizIN1G6l1j8ITBHFCvxyC9Wa0g82JHl4eaVl+
         3f35yyRF/WmKbc7Wm/ZphT7nqV+coy39ZsyZ51Z3Ba6qtpIu4R/k78wCNffEilqQZ7eL
         0Gh4SuHEru28JXxzaoMHMAxEIhIgxhzUgTdDYvK1QCl2M7ddHBTG+xXRmzYoEZze0ddK
         rLtA==
X-Gm-Message-State: AOAM533vpUEjshY78dObZ6hzH8E/UyQUT0WMgVRRnqBvFe3iutlDPO+1
        jGpDFYMTxaKS5eM24JpmYaU=
X-Google-Smtp-Source: ABdhPJxZDp/SyGeLqZPtuw/I81jZ765tjN1eiDWxfb5Gw8s0EqtrDghio6LIVydktk8tQn/Q5HNfVQ==
X-Received: by 2002:a17:90a:6fc1:: with SMTP id e59mr4396347pjk.37.1624524732566;
        Thu, 24 Jun 2021 01:52:12 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id c5sm2109274pfv.47.2021.06.24.01.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 01:52:12 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:52:06 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
        <20210624035749.4054934-3-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-3-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524331.zsin3qejl9.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>
>=20
> Return a struct kvm_pfn_page containing both a pfn and an optional
> struct page from the gfn_to_pfn family of functions. This differentiates
> the gup and follow_fault_pfn cases, which allows callers that only need
> a pfn to avoid touching the page struct in the latter case. For callers
> that need a struct page, introduce a helper function that unwraps a
> struct kvm_pfn_page into a struct page. This helper makes the call to
> kvm_get_pfn which had previously been in hva_to_pfn_remapped.
>=20
> For now, wrap all calls to gfn_to_pfn functions in the new helper
> function. Callers which don't need the page struct will be updated in
> follow-up patches.

Hmm. You mean callers that do need the page will be updated? Normally=20
if there will be leftover users that don't need the struct page then
you would go the other way and keep the old call the same, and add a new
one (gfn_to_pfn_page) just for those that need it.

Most kernel code I look at passes back multiple values by updating=20
pointers to struct or variables rather than returning a struct, I=20
suppose that's not really a big deal and a matter of taste.

Thanks,
Nick

