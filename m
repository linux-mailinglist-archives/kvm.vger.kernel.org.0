Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A361F29CA50
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797652AbgJ0UiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 16:38:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:40416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797528AbgJ0UiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 16:38:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C32AABD1;
        Tue, 27 Oct 2020 20:38:22 +0000 (UTC)
Date:   Tue, 27 Oct 2020 13:17:30 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 3/3] sched: Add cond_resched_rwlock
Message-ID: <20201027201730.kyusnssnrict75bh@linux-p48b.lan>
References: <20201027164950.1057601-1-bgardon@google.com>
 <20201027164950.1057601-3-bgardon@google.com>
 <20201027175634.GI1021@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201027175634.GI1021@linux.intel.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Oct 2020, Sean Christopherson wrote:

>On Tue, Oct 27, 2020 at 09:49:50AM -0700, Ben Gardon wrote:
>> Rescheduling while holding a spin lock is essential for keeping long
>> running kernel operations running smoothly. Add the facility to
>> cond_resched rwlocks.

Nit: I would start the paragraph with 'Safely rescheduling ...'
While obvious when reading the code, 'Rescheduling while holding
a spin lock' can throw the reader off.

>
>This adds two new exports and two new macros without any in-tree users, which
>is generally frowned upon.  You and I know these will be used by KVM's new
>TDP MMU, but the non-KVM folks, and more importantly the maintainers of this
>code, are undoubtedly going to ask "why".  I.e. these patches probably belong
>in the KVM series to switch to a rwlock for the TDP MMU.
>
>Regarding the code, it's all copy-pasted from the spinlock code and darn near
>identical.  It might be worth adding builder macros for these.

Agreed, all three could be nicely consolidated. Otherwise this series looks
sane, feel free to add my:

Acked-by: Davidlohr Bueso <dbueso@suse.de>
