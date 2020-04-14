Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0361A8D74
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 23:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391753AbgDNVPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 17:15:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:59768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732367AbgDNVPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 17:15:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 45390ABBE;
        Tue, 14 Apr 2020 21:14:57 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:12:43 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     tglx@linutronix.de, bigeasy@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200414211243.7vehybdrvbzmbduu@linux-p48b>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020, Paolo Bonzini wrote:

>On 24/03/20 05:44, Davidlohr Bueso wrote:
>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>> index 71244bf87c3a..e049fcb3dffb 100644
>> --- a/arch/mips/kvm/mips.c
>> +++ b/arch/mips/kvm/mips.c
>> @@ -290,8 +290,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>>	kvm_mips_callbacks->queue_timer_int(vcpu);
>>
>>	vcpu->arch.wait = 0;
>> -	if (swq_has_sleeper(&vcpu->wq))
>> -		swake_up_one(&vcpu->wq);
>> +	rcuwait_wake_up(&vcpu->wait)
>
>This is missing a semicolon.  (KVM MIPS is known not to compile and will
>be changed to "depends on BROKEN" in 5.7).

Do you want me to send another version with this fix or do you prefer
fixing it when/if picked up?

Thanks,
Davidlohr
