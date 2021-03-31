Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64F73508C2
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCaVGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCaVFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:05:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0164C061760
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:05:53 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q5so15430015pfh.10
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OsMJWVQ5QwySc9J0D6/CmIltvLje627dYrulaN3pAYw=;
        b=Wc7aKMlkMupX5QKCwfzZVYqMCo1X7BRsT/Kkkx7EwXhoN5RNV7t4FFC66e9PTmv1hx
         B5fa6/ZZRBlZ7u8xuFDL9LYZr/z14+WE4xRb24HmRER5FPe8woSMl7enlu5vXfvWMl1b
         ME7U4jYEdyICvfRyN6+B26dJ3dEizwHNQsWpWevkiP4PnR+3Jmdg2xy/JJIDOEUUXaQ0
         ltEvaex2B8+pIp7NiAF68Y5qiyuu4234eP6u6hPNTVxaQ9AE8rdIKMAy3U8FEPBYR1GF
         8MWtaTrm5lKR+WYnx0BpHgfhq0fkF/UBhRko1T8H4itpPFwtvOhfmo0NCytN/FJUUsy1
         332w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OsMJWVQ5QwySc9J0D6/CmIltvLje627dYrulaN3pAYw=;
        b=QW3sKiz59BWc41A7tRj8ic3/UAUwtyqeKJsWb86N8CjqJJ1pDCtzvLqmeXUg3aEBhp
         9EobfoOKZL9UEOuP8nqlBdL/8VhzUDllC868WFuVFJOguvm2xF0ySrosCV1vqvmzeqau
         Dla/ywy6C5qyH2WoGc128CdBpgDpkgWilnqkhIzCEMXKX1IaNEn+4PYc9LMeI8VfkDM9
         jgDHNd0ErUuBRoMepRFAoGj9G+sGQPCZegLLRXp6YdOXCQLL9Wp04874hWdNGM/jDrgB
         J51dAu/1CrSRdGCjKt7n/FD67hSQT7pjWvia5W6+KYtWN5UeBUia1zLU19CRzfMf45Oj
         UH1Q==
X-Gm-Message-State: AOAM533NDrtLVcBigV6JjtrDQ71LbxyuLeOjYCWADGP0OVt0uuLaOqgv
        rR/0zf5FA5n55y3M8+H9plE9gQ==
X-Google-Smtp-Source: ABdhPJyf0uPjw7GKqed+RHpnFRPgnZODnH1LNH3LjT1TYsTNjhWE3dnO3pT+GkRqgzOjMV1yU6flMQ==
X-Received: by 2002:a62:6497:0:b029:220:d96a:8a79 with SMTP id y145-20020a6264970000b0290220d96a8a79mr4625909pfb.23.1617224752934;
        Wed, 31 Mar 2021 14:05:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id na18sm2894150pjb.30.2021.03.31.14.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 14:05:52 -0700 (PDT)
Date:   Wed, 31 Mar 2021 21:05:48 +0000
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
Message-ID: <YGTkLMAzk88wOiZm@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 31/03/21 21:47, Sean Christopherson wrote:
> > Rereading things, a small chunk of the rwsem nastiness can go away.  I don't see
> > any reason to use rw_semaphore instead of rwlock_t.
> 
> Wouldn't it be incorrect to lock a mutex (e.g. inside *another* MMU
> notifier's invalidate callback) while holding an rwlock_t?  That makes sense
> because anybody that's busy waiting in write_lock potentially cannot be
> preempted until the other task gets the mutex.  This is a potential
> deadlock.

Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
inside a rwlock is ok, so long as the locks are always taken in the same order,
i.e. it's never mmu_lock -> mmu_notifier_slots_lock.

> I also thought of busy waiting on down_read_trylock if the MMU notifier
> cannot block, but that would also be invalid for the opposite reason (the
> down_write task might be asleep, waiting for other readers to release the
> task, and the down_read_trylock busy loop might not let that task run).
> 
> > And that's _already_ the worst case since notifications are currently
> > serialized by mmu_lock.
> 
> But right now notifications are not a single critical section, they're two,
> aren't they?

Ah, crud, yes.  Holding a spinlock across the entire start() ... end() would be
bad, especially when the notifier can block since that opens up the possibility
of the task sleeping/blocking/yielding while the spinlock is held.  Bummer.
