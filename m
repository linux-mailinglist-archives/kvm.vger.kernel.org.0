Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BB170CF52
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbjEWAdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbjEWAXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:23:04 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B41FF2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:06:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-52855ba7539so3568962a12.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684800418; x=1687392418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqpMDrC4KK3NQ6AuoTcuN/aH10d3Gs6pWZJ4L+6LYdI=;
        b=einRQC06NM+pLkPcWJKuFkA3JrqGZ4jSC+L44hYXq+E/rLb8tn1KKR5KGxdVgGH9fL
         z4wM40qWv+kR5vQgB2cbnU9DNxDeI2IC0tmcs88RbHAhC13vUSJeJwXY2E2Dld8hrPg3
         MG3L4X+OVgZf3FszqPcq/K+aN6nVAet/JMgxgQXoHdcBP0my7P2nA29a9lYONLLhRYMZ
         s2S/qIxe2XDDMncs9mGy6cUgAaVEpju9PTe00dW7/KviwcI5VWtDKN+UuNKlHfU72jrL
         KU7Iq+8yaRoCE4WlHn45jJU/E5rxEradrcAdgs1h1bhJKao7Ozt805O7vAzm8fUMRQot
         nQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684800418; x=1687392418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqpMDrC4KK3NQ6AuoTcuN/aH10d3Gs6pWZJ4L+6LYdI=;
        b=irVODjI2hz5rs4UNyUGBa/JUaVja7Iw1Y9q6tbuLl5rWBHp+qRlZ+sNXLD0Dl0Tw0D
         8HQP/gUh5VbyZs8/RhBCwEU9UAw1OH7lap/emZnVzGydUqcrVbrzA5vSnHZxaWvSlcQk
         ZM4No2sJJjJqOEsARbK32rzIfKFusyKO9VSLJ22uK6owSFD9VJDqFdPO0PT38Y6Lhy5z
         1giVRg2XJLz0wXVmP90vp9o2GavKK5S4Jg2wpEDiRF+PFB2zVpfxyqC1rgERgxwXpnH0
         eQfZK4swiKA7GpGqrBhCu6ibQa+yuPDD5ry8+JGs+BcYOrEE///0baw3ZtK/cnrKQ7KB
         XR1g==
X-Gm-Message-State: AC+VfDxmU0DDEDYNG29xCwvPBZQuETq/G3YeoTugUmRQ/C6x4LfjiQed
        YD57B5AAcRz+gl+PMvAJBQPduuJtiSk=
X-Google-Smtp-Source: ACHHUZ6HjllyZzTlaaKR4BoUDyFce04HZ9UhEoY+TcxZpDQZdfHOuNAQJ4T7tsiqCTcoicnwg0ExZ7H4Ffw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5f91:0:b0:52c:b362:1894 with SMTP id
 t139-20020a635f91000000b0052cb3621894mr2851167pgb.3.1684800417778; Mon, 22
 May 2023 17:06:57 -0700 (PDT)
Date:   Mon, 22 May 2023 17:06:56 -0700
In-Reply-To: <875y8jappz.fsf@nvidia.com>
Mime-Version: 1.0
References: <20230522063725.284686-1-apopple@nvidia.com> <ZGu1vsbscdO48V6h@google.com>
 <875y8jappz.fsf@nvidia.com>
Message-ID: <ZGwDoONUFAHi7XKz@google.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
From:   Sean Christopherson <seanjc@google.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023, Alistair Popple wrote:
> 
> Sean Christopherson <seanjc@google.com> writes:
> >> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> >> index d6c06e140277..f14d68f119d8 100644
> >> --- a/include/linux/mmu_notifier.h
> >> +++ b/include/linux/mmu_notifier.h
> >> @@ -31,6 +31,11 @@ struct mmu_interval_notifier;
> >>   * pages in the range so to mirror those changes the user must inspect the CPU
> >>   * page table (from the end callback).
> >>   *
> >> + * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
> >> + * read-write for pages in the range. This must not be used to upgrade
> >> + * permissions on secondary PTEs, rather it should only be used to invalidate
> >> + * caches such as secondary TLBs that may cache old read-only entries.
> >
> > This is a poor fit for invalidate_range_{start,end}().  All other uses bookend
> > the primary MMU update, i.e. call start() _before_ changing PTEs.  The comments
> > are somewhat stale as they talk only about "unmapped", but the contract between
> > the primary MMU and the secondary MMU is otherwise quite clear on when the primary
> > MMU will invoke start() and end().
> >
> > 	 * invalidate_range_start() is called when all pages in the
> > 	 * range are still mapped and have at least a refcount of one.
> > 	 *
> > 	 * invalidate_range_end() is called when all pages in the
> > 	 * range have been unmapped and the pages have been freed by
> > 	 * the VM.
> >
> > I'm also confused as to how this actually fixes ARM's SMMU.  Unless I'm looking
> > at the wrong SMMU implementation, the SMMU implemenents only invalidate_range(),
> > not the start()/end() variants.
> 
> mmu_invalidate_range_end() calls the invalidate_range() callback if
> the start()/end() variants aren't set.

Ahh, thanks.

> > 	static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
> > 		.invalidate_range	= arm_smmu_mm_invalidate_range,
> > 		.release		= arm_smmu_mm_release,
> > 		.free_notifier		= arm_smmu_mmu_notifier_free,
> > 	};
> >
> > Again from include/linux/mmu_notifier.h, not implementing the start()/end() hooks
> > is perfectly valid.  And AFAICT, the existing invalidate_range() hook is pretty
> > much a perfect fit for what you want to achieve.
> 
> Right, I didn't take that approach because it doesn't allow an event
> type to be passed which would allow them to be filtered on platforms
> which don't require this.
> 
> I had also assumed the invalidate_range() callbacks were allowed to
> sleep, hence couldn't be called under PTL. That's certainly true of mmu
> interval notifier callbacks, but Catalin reminded me that calls such as
> ptep_clear_flush_notify() already call invalidate_range() callback under
> PTL so I guess we already assume drivers don't sleep in their
> invalidate_range() callbacks. I will update the comments to reflect
> that.
> 
> > 	 * If invalidate_range() is used to manage a non-CPU TLB with
> > 	 * shared page-tables, it not necessary to implement the
> > 	 * invalidate_range_start()/end() notifiers, as
> > 	 * invalidate_range() already catches the points in time when an
> > 	 * external TLB range needs to be flushed. For more in depth
> > 	 * discussion on this see Documentation/mm/mmu_notifier.rst
> >
> > Even worse, this change may silently regress performance for secondary MMUs that
> > haven't yet taken advantage of the event type, e.g. KVM will zap all of KVM's PTEs
> > in response to the upgrade, instead of waiting until the guest actually tries to
> > utilize the new protections.
> 
> Yeah, I like the idea of introducing a
> ptep_set_access_flags_notify(). That way this won't regress performance
> on platforms that don't need it. Note this isn't a new feature but
> rather a bugfix. It's unclear to me why KVM on ARM hasn't already run
> into this issue, but I'm no KVM expert. Thanks for the feedback.

KVM manages its own page tables and so does its own TLB invalidations as needed,
e.g. KVM can and does change KVM's stage-2 PTEs from read-only to read/write
irrespective of mmu_notifiers.  I assume the SMMU issue arises only because the
SMMU is reusing the host kernel's (stage-1?) page tables.
