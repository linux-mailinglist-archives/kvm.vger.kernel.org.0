Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48A73507F7
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 22:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhCaUQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 16:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbhCaUQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5299C06174A
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 13:16:04 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id i6so117535pgs.1
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jlWSSoi6sy6UHWMT+v1PaZmsAgCmFgO2q1+KR74XicI=;
        b=CQY8x+TvnMDSfSmiD2oXUHMuQLXZ38oXtxiRbVY/bMFC5iyRXRtUNJEI/nL8QGZJO3
         uCZeJr/LCn8UE+xniYVb/4u0+jxWUWA+q7hUvk92LCcFLkS/fJqFt+tNz2QcklwQQaWn
         HvmjLhB61wZx5a5mvaQtupa2/vEyFX9Vua2CFTe6XDyB1KEIrw7j4MAG1vVvIOYtt7P3
         pHQharrI6lixPIKmzhnGtbgX+luBHbesS+HGqteLdSBUx8hGONbonRnToFN5Hs5EJ77K
         vKUbLwvu9gSWWmSpGD7GsVEqiFtnjRQ/qBYqBI2cKy6097T2AypJtX31JiYLExgQSWnk
         FlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jlWSSoi6sy6UHWMT+v1PaZmsAgCmFgO2q1+KR74XicI=;
        b=JhyURGOMTNwYiNGjrttVkJWFh71VSZtBHBE8De+sregzufVYyjmkjJcfeWn+shrEAM
         zwUKB21HzVM7AvyXfw/Qf+NGzU7gtvDEZtZoSmDC3Qto1HcTG0NnQo2laZypnbsZo3w3
         BK0h2qMuBcGUEvLz27jLgEMWKBQt5D8TaDp8Lb/Re3BUXbBHqgQGnpYJFrLjPczSwkKB
         Yn6y02Wie6+xGElKcP9VRm7VjyFuXRj2QCz7cql0CmKFFoYVLhbJY3oA21Cu2xfQJL1s
         7xlg26MSwxboXE0AHiTnQpVT3JTexw6gZEtydrG66bHvnT5T7sRIU9ZkdJr3xctoqe+y
         2zMg==
X-Gm-Message-State: AOAM5302eacXHG4G8HjSr2ceFQEY72CCGUsQQ+sOnMsrQ76hb6Y9szNT
        M5S5/he7z8Bas++EqPHFV7C16Q==
X-Google-Smtp-Source: ABdhPJyQTtvfP4m42vBD0iJXhxNzS92c8e0qkUYdFgjeJAzyVz49/jbMuCy/LNbWI3efb+yjNskWQQ==
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr4731324pgu.18.1617221764095;
        Wed, 31 Mar 2021 13:16:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 144sm3196471pfy.75.2021.03.31.13.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:16:03 -0700 (PDT)
Date:   Wed, 31 Mar 2021 20:15:59 +0000
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
Message-ID: <YGTYf9sWVIJqqswq@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> > +	/*
> > +	 * Reset the lock used to prevent memslot updates between MMU notifier
> > +	 * range_start and range_end.  At this point no more MMU notifiers will
> > +	 * run, but the lock could still be held if KVM's notifier was removed
> > +	 * between range_start and range_end.  No threads can be waiting on the
> > +	 * lock as the last reference on KVM has been dropped.  If the lock is
> > +	 * still held, freeing memslots will deadlock.
> > +	 */
> > +	init_rwsem(&kvm->mmu_notifier_slots_lock);
> 
> I was going to say that this is nasty, then I noticed that
> mmu_notifier_unregister uses SRCU to ensure completion of concurrent calls
> to the MMU notifier.  So I guess it's fine, but it's better to point it out:
> 
> 	/*
> 	 * At this point no more MMU notifiers will run and pending
> 	 * calls to range_start have completed, but the lock would
> 	 * still be held and never released if the MMU notifier was
> 	 * removed between range_start and range_end.  Since the last
> 	 * reference to the struct kvm has been dropped, no threads can
> 	 * be waiting on the lock, but we might still end up taking it
> 	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
> 	 * to avoid deadlocks.
> 	 */

An alternative would be to not take the lock in install_new_memslots() if
kvm->users_count == 0.  It'd be weirder to document, and the conditional locking
would still be quite ugly.  Not sure if that's better than blasting a lock
during destruction?
