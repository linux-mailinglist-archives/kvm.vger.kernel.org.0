Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEBA350902
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhCaVXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhCaVWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:22:37 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4A6C06175F
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:22:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so3646934pjb.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pXrqzXzEChtI1XfxNDISXq0z9cppP2LyACAbcjVV7bg=;
        b=PXiE5CdfJSVRzY2wAQZx9s0kr/QwU1b4znKQScxqzpI8tabgUAg4SVda6p+Sbl9XJ8
         SBgRoqUAGTlVZz7E+Yi6I70OUwxuE63QPaveGtR2bhifB+6rtU00zzhKHv9EBm/mOGzN
         axtTf1lg1vUe15bNFHV8EITJJNRmtXVeAU1fXFkWHv2T5+TW9Km9hv31+xGyNz9RNJZg
         yMQRHypkP6w+Q7LQSIUVr+KimkqklaqBn3G2feNNtJU0xZlEKop+CQjdve0cSM8ihM7k
         HG24zwAIliz3Jl1sIN7OyrjvzgKi+Qg8zzhSysSO7OjGMtFwPaqpFPvyawOeIZ21OLuK
         occA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pXrqzXzEChtI1XfxNDISXq0z9cppP2LyACAbcjVV7bg=;
        b=WLKkhO4wwbjFunah7FM69GbNqDd7w77HhgelL+njgZlcgE59vKgHBlTVfxjzDh6Hnz
         EI4+NiHA8OvW0WSut1GvJiALpQgypW2wj9NfZRZ1/2Z0BdYk/p0aQm8zbi4QkiZgm7p/
         QjkDOKtWNc/qQ55cVEPyw5Zhx+jDk8/DF9Jcb6hCk5ptJy2UGssMntcp0RDe0ktJA2Dc
         Ypz8BcnjI8hBboJRc9cFUs/Ni9WlMtk+piN91DXFObsVizl2toTk5H7cFH7pFny9M17R
         7MLVGpGLP5H3lnDcC/bdMAmv7hafUDnpXvE260Rvy/sydIYtcdvwsVPSnJAvJqlQp95E
         XIiw==
X-Gm-Message-State: AOAM53398T0hPvCwc/cb3Pe3Zib0VAshL0FNj3BPrBlQqyF458mKLtx4
        +Js7gtlJzTcJIkz5jEiANzyzMA==
X-Google-Smtp-Source: ABdhPJxsIyLoShTQKKQWzcjkczRyz+c6fh0aTYwa65djAo2j70cBG0eZD/ja+to5RbqNzFwrtXDXaA==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr5086802pjb.5.1617225756928;
        Wed, 31 Mar 2021 14:22:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o4sm3237010pfk.15.2021.03.31.14.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 14:22:36 -0700 (PDT)
Date:   Wed, 31 Mar 2021 21:22:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGToGBvdfPiCr3WA@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGTkLMAzk88wOiZm@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Sean Christopherson wrote:
> On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> > On 31/03/21 21:47, Sean Christopherson wrote:
> > I also thought of busy waiting on down_read_trylock if the MMU notifier
> > cannot block, but that would also be invalid for the opposite reason (the
> > down_write task might be asleep, waiting for other readers to release the
> > task, and the down_read_trylock busy loop might not let that task run).
> > 
> > > And that's _already_ the worst case since notifications are currently
> > > serialized by mmu_lock.
> > 
> > But right now notifications are not a single critical section, they're two,
> > aren't they?
> 
> Ah, crud, yes.  Holding a spinlock across the entire start() ... end() would be
> bad, especially when the notifier can block since that opens up the possibility
> of the task sleeping/blocking/yielding while the spinlock is held.  Bummer.

On a related topic, any preference on whether to have an explicit "must_lock"
flag (what I posted), or derive the logic based on other params?

The helper I posted does:

	if (range->must_lock &&
	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
		goto out_unlock;

but it could be:

	if (!IS_KVM_NULL_FN(range->on_lock) && !range->may_block &&
	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
		goto out_unlock;

The generated code should be nearly identical on a modern compiler, so it's
purely a question of aesthetics.  I slightly prefer the explicit "must_lock" to
avoid spreading out the logic too much, but it also feels a bit superfluous.
