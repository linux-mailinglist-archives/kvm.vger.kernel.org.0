Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9163B2C00
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhFXKAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhFXKAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 06:00:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8790DC061574;
        Thu, 24 Jun 2021 02:58:03 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w71so4725250pfd.4;
        Thu, 24 Jun 2021 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=2/FXkDvvz78LZzi8vEuw9P0gxvIPqn8+9Qh994D56qo=;
        b=EhX2h/EGnTWqdqRQbpZlpJcgT0oJJ6o7Nef8q7EtPvI99smF5fr4TIG1Xp5CmTthMl
         XHQzIJWggbxJUXpq8OIPTnYOso57K6OBKZR9lvcFT5+8SBJA9849ahv3W1ndrCYtoccT
         yygIYTNJlnGOy5EhAkMecjcGkX/PpQmk6jKwKuAM0vg6/CjPiKQtp4B/woWoN5Oxyu7M
         ua8ZUETzbjTOqOpCOLZ+ZXZ4cbXcI88NdWfpPkU+Dnz/3z1CLTZvVnhoG0DpsDAi9bV1
         nK9pW2bxw2DMCvsnbAXlJB/lKwAPvP15NgJgI5cnQ6vQYvzhGuulMUnoZMx6s+4VaanO
         Eqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=2/FXkDvvz78LZzi8vEuw9P0gxvIPqn8+9Qh994D56qo=;
        b=I9I+2OiO6x90DSdzE2/+u34W0RL5pju25egcTYnBRXEbeEn+eItzhqfuXHLN1nyfdG
         zHh7yfbdwbQ6CN2dAU+5GI7NhoWXGWKkML/yM+5JESCKHYQUigGJjFYmu7Zu4sM1iUaP
         Lgc6yyFrwQiWBgDJ58YQ86fJPQdLxMhEF00oN9r/utwsoi02gI7npGdRIyFNGoF+e/Gy
         C5ILp2gJnz5V4c6/FT58Bfu6YR1FydDYfppsPGUvn6mSZ5OmIUH67BJ2zuJYgusfA9Pa
         oKQ30oOaODL8QlT5w+PTeMR2hOL2vynck3cPE2hasDS6ovg0BIlVklXd6XGC6BhcElNB
         9vSQ==
X-Gm-Message-State: AOAM53296s1cmH/B9fuYn+FHy4xvzL/cf7DDu5mAzd3NLUX+K/3ATddj
        uilZu52pyBlYHl5qL7d3jao=
X-Google-Smtp-Source: ABdhPJzzKwhLHCAEARj7N7XbHWSLsSDNrl/BU7M36fXftqZpKf9BHg/7Rmx6MuG9ZeVpPhgC2xWSpQ==
X-Received: by 2002:a62:1857:0:b029:302:fb56:df52 with SMTP id 84-20020a6218570000b0290302fb56df52mr4317733pfy.3.1624528683047;
        Thu, 24 Jun 2021 02:58:03 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id y20sm2759510pfb.207.2021.06.24.02.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 02:58:02 -0700 (PDT)
Date:   Thu, 24 Jun 2021 19:57:57 +1000
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
        <1624524331.zsin3qejl9.astroid@bobo.none>
        <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
In-Reply-To: <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
MIME-Version: 1.0
Message-Id: <1624528342.s2ezcyp90x.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Paolo Bonzini's message of June 24, 2021 7:42 pm:
> On 24/06/21 10:52, Nicholas Piggin wrote:
>>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>>> function. Callers which don't need the page struct will be updated in
>>> follow-up patches.
>> Hmm. You mean callers that do need the page will be updated? Normally
>> if there will be leftover users that don't need the struct page then
>> you would go the other way and keep the old call the same, and add a new
>> one (gfn_to_pfn_page) just for those that need it.
>=20
> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so=20
> it's a good idea to move the short name to the common case and the ugly=20
> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not=20
> sure there should be any kvm_pfn_page_unwrap in the end.

If all callers were updated that is one thing, but from the changelog
it sounds like that would not happen and there would be some gfn_to_pfn
users left over.

But yes in the end you would either need to make gfn_to_pfn never return
a page found via follow_pte, or change all callers to the new way. If=20
the plan is for the latter then I guess that's fine.

Thanks,
Nick
