Return-Path: <kvm+bounces-73151-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KT6MqoZq2lNaAEAu9opvQ
	(envelope-from <kvm+bounces-73151-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:15:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 566672269A7
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1D5A30518E9
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 18:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42774421A1B;
	Fri,  6 Mar 2026 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5n95M/e";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QbnyKmyj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DA7421896
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820890; cv=none; b=p0RhkAN7/LbufjwiH3o/DOVK8ORJb6rVr9Bj7/gKRfnCrRieUpIZ5S6cUe1xbsCPFPHslIpycfPVfA7Pd0CsqEQY7I7bVtOuB8zMdTPlB2JeSqH9mGDGhLOiNMylY4gxMQCUbTa++tdsqNRwrxgpqS63Abnhzno6V8+cXVGv4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820890; c=relaxed/simple;
	bh=bX/QxuS9OoDi1uRMFJB4oQmkvSNVP2tvqOucb4SUIz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=so7dzp/DWaF5pzoci5qXl4cMTmk0YQeRGfYe0V05bTEhb5kPizy9WMzA1xagb6rMXSD4ks5MyXgq44jY2s9eyvrpC4E1/8LW8BJ42S5UYRA9ZRfJ38s91J0Db3Tc1MrvU0TPCaFPUMRuXGM0tmNSHRvBIgUIvcC7Xmf6TvAYxMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5n95M/e; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QbnyKmyj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772820888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jwfI0UzgDdM6KwDTpaPVK51Dh9pqjddR4e0hn1DOm0=;
	b=P5n95M/e1At7udlaexxmqfmJvTCSUqQSILIU+L2uNk3rO+NjG9rsXYFxwwWbvy2nKcBRh4
	lPEQibct03xAaLGDvJOKH2t2fdHR/SyeIweLyH5/ejiwXK+qAICOws40O6T9pEabMalqQZ
	FZtp0ew92B67RX32UOAo+bA41oDEuwI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-ELM_-24MMmqXPsXG8U5X2g-1; Fri, 06 Mar 2026 13:14:45 -0500
X-MC-Unique: ELM_-24MMmqXPsXG8U5X2g-1
X-Mimecast-MFC-AGG-ID: ELM_-24MMmqXPsXG8U5X2g_1772820884
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-483a24db6ecso121459005e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 10:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772820884; x=1773425684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+jwfI0UzgDdM6KwDTpaPVK51Dh9pqjddR4e0hn1DOm0=;
        b=QbnyKmyjAnBOHQVKr/R0Idry+hX8c9CfRhsku2M5ZzQapL8GYUvUAtjZjiUYy2Wkx3
         oWPJL5XW+LdBlzKW+MOplLMsQp5IbDaQIa1Q/WsMkx4vpSgQELGDzhoNZgm6YL+nmfGA
         VXXoNgJ5mxZm520592uOaZIViifEZE/1VV7GMAFp4Jm18I4z6QL3MyWAq5QTxcHfRDm+
         HqfLElWT/lgoFrjglIiNnN9OFsQFMZBQrqqXbFi39VHet4IJAEqGl6taMnWKBo4HjL2D
         uYzmzW2t/8fo1e6vxPggOLfPrAz9C6hJwgu3c12Fy2zlE/58iG5Far+hiszkUwzuJ/2K
         CvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772820884; x=1773425684;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+jwfI0UzgDdM6KwDTpaPVK51Dh9pqjddR4e0hn1DOm0=;
        b=k5M+BTKTu1e93KCRRPOO4PPqGbsdWUIunBJs8BTCINJAF8i7rIsbhxT4E2sDvrXcvn
         4uPNielgMrI9WKlnN0J88dTvxVoNdje57WcXULJhiciWJSn7/axN9eEMs1GIhwxTlNX1
         8243WY2n9SXwd7htptcJzH4QypCog0UBfj4BeB8Y63tDuiyIgSm3CMx5bwkGBOBRe8YF
         ahYJbB7qurQ7QOXF12UB7gdhNaR6OwiD3NP0EZEdALJTYZcR/MCzXGRVTG8tP2jUM+ST
         ZYu0CcmIR7fEE5A3Nw/N31W6VSUyJ0DxxUgS5KjXjmjnXYp1sb+jmAJ1lXCyVjFbqUlP
         C1gw==
X-Forwarded-Encrypted: i=1; AJvYcCWe1cF4F4IGvDfTIUouNI7Jug3j9M4gJ4clcln8oBmSsZvC6tFRbaNwETQs9Dd2UtF5XDc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi2726s+G3l3Am7S9dCq8zIa2FjUZZjW9KaB8c7z7WLmyOroDj
	5i+6r4BJMbY+9a+ZOyPARCnXORmkwM9DLe5V520sXBgOcHyeLK0rlg2X4rsJHV9uP2FscfyoQsA
	u3vjHl+saHIyjP6A0RHTivTDcGuaBDyApVWW6mbCXuGPM8EUaM3hZ5Q==
X-Gm-Gg: ATEYQzy1KRoIVgntihr+wVvmsseBPlVkVa+Lu3coxZ0AJx1d8sJ4L+6FS22CyB4nIRV
	Z2zKiWCJoP3Qm3ozQV5GC0wvSVgwBVYACf/ifgsA+CLTMV3mBm+Y+hhId+upt8L+k7zBSZMVH6N
	YXgkx3QImi0TwjMLlOO/DsP3tqd25D4IGZtZCWoC9mefazpJ+LGZGBAX7a0+Z2aL/48Q0SUrruf
	yRHuDNkTA6eKuqAsto04RigONaYarfWAAbFoDsS6mCW+xXJxZsLKrN+Gh7xB+QERu7BicXBqbDt
	ZWI0ToaSf2OBXjHW71HkaGCaH8+RAMh1W8nDYUPX8n41N3r35idVCRA+ZnKbnyMw5g4N/+7mZzC
	9t04QXCFCXJOC15HV0gxFqRZRrPbOrYMq+0G1q07c5v7KhQpq4hsDLkZhAAhsPfRZlzUQnDap8/
	f6bz2KUtcVkzm9M0Ejr9axnzIu5ao=
X-Received: by 2002:a05:600d:8489:20b0:485:2af3:3f7d with SMTP id 5b1f17b1804b1-4852af34088mr14851335e9.4.1772820883625;
        Fri, 06 Mar 2026 10:14:43 -0800 (PST)
X-Received: by 2002:a05:600d:8489:20b0:485:2af3:3f7d with SMTP id 5b1f17b1804b1-4852af34088mr14850845e9.4.1772820883141;
        Fri, 06 Mar 2026 10:14:43 -0800 (PST)
Received: from [192.168.10.81] ([151.95.144.138])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4851fad2812sm218866435e9.1.2026.03.06.10.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 10:14:42 -0800 (PST)
Message-ID: <ae2143b3-ce28-4c87-afcf-1505694246d8@redhat.com>
Date: Fri, 6 Mar 2026 19:14:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping
 for non-blocking invalidations
To: shaikh kamaluddin <shaikhkamal2012@gmail.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
 <20260211120944.-eZhmdo7@linutronix.de> <aYyhfvC_2s000P7H@google.com>
 <aactOOfirdVRYfNS@acer-nitro-anv15-41>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <aactOOfirdVRYfNS@acer-nitro-anv15-41>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 566672269A7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73151-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,google.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.952];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/3/26 19:49, shaikh kamaluddin wrote:
> On Wed, Feb 11, 2026 at 07:34:22AM -0800, Sean Christopherson wrote:
>> On Wed, Feb 11, 2026, Sebastian Andrzej Siewior wrote:
>>> On 2026-02-09 21:45:27 [+0530], shaikh.kamal wrote:
>>>> mmu_notifier_invalidate_range_start() may be invoked via
>>>> mmu_notifier_invalidate_range_start_nonblock(), e.g. from oom_reaper(),
>>>> where sleeping is explicitly forbidden.
>>>>
>>>> KVM's mmu_notifier invalidate_range_start currently takes
>>>> mn_invalidate_lock using spin_lock(). On PREEMPT_RT, spin_lock() maps
>>>> to rt_mutex and may sleep, triggering:
>>>>
>>>>    BUG: sleeping function called from invalid context
>>>>
>>>> This violates the MMU notifier contract regardless of PREEMPT_RT;
>>
>> I highly doubt that.  kvm.mmu_lock is also a spinlock, and KVM has been taking
>> that in invalidate_range_start() since
>>
>>    e930bffe95e1 ("KVM: Synchronize guest physical memory map to host virtual memory map")
>>
>> which was a full decade before mmu_notifiers even added the blockable concept in
>>
>>    93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers")
>>
>> and even predate the current concept of a "raw" spinlock introduced by
>>
>>    c2f21ce2e312 ("locking: Implement new raw_spinlock")
>>
>>>> RT kernels merely make the issue deterministic.
>>
>> No, RT kernels change the rules, because suddenly a non-sleeping locking becomes
>> sleepable.
>>
>>>> Fix by converting mn_invalidate_lock to a raw spinlock so that
>>>> invalidate_range_start() remains non-sleeping while preserving the
>>>> existing serialization between invalidate_range_start() and
>>>> invalidate_range_end().
>>
>> This is insufficient.  To actually "fix" this in KVM mmu_lock would need to be
>> turned into a raw lock on all KVM architectures.  I suspect the only reason there
>> haven't been bug reports is because no one trips an OOM kill on VM while running
>> with CONFIG_DEBUG_ATOMIC_SLEEP=y.
>>
>> That combination is required because since commit
>>
>>    8931a454aea0 ("KVM: Take mmu_lock when handling MMU notifier iff the hva hits a memslot")
>>
>> KVM only acquires mmu_lock if the to-be-invalidated range overlaps a memslot,
>> i.e. affects memory that may be mapped into the guest.
>>
>> E.g. this hack to simulate a non-blockable invalidation
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 7015edce5bd8..7a35a83420ec 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -739,7 +739,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>>                  .handler        = kvm_mmu_unmap_gfn_range,
>>                  .on_lock        = kvm_mmu_invalidate_begin,
>>                  .flush_on_ret   = true,
>> -               .may_block      = mmu_notifier_range_blockable(range),
>> +               .may_block      = false,//mmu_notifier_range_blockable(range),
>>          };
>>   
>>          trace_kvm_unmap_hva_range(range->start, range->end);
>> @@ -768,6 +768,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>>           */
>>          gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
>>   
>> +       non_block_start();
>>          /*
>>           * If one or more memslots were found and thus zapped, notify arch code
>>           * that guest memory has been reclaimed.  This needs to be done *after*
>> @@ -775,6 +776,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>>           */
>>          if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
>>                  kvm_arch_guest_memory_reclaimed(kvm);
>> +       non_block_end();
>>   
>>          return 0;
>>   }
>>
>> immediately triggers
>>
>>    BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:241
>>    in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 4992, name: qemu
>>    preempt_count: 0, expected: 0
>>    RCU nest depth: 0, expected: 0
>>    CPU: 6 UID: 1000 PID: 4992 Comm: qemu Not tainted 6.19.0-rc6-4d0917ffc392-x86_enter_mmio_stack_uaf_no_null-rt #1 PREEMPT_RT
>>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>>    Call Trace:
>>     <TASK>
>>     dump_stack_lvl+0x51/0x60
>>     __might_resched+0x10e/0x160
>>     rt_write_lock+0x49/0x310
>>     kvm_mmu_notifier_invalidate_range_start+0x10b/0x390 [kvm]
>>     __mmu_notifier_invalidate_range_start+0x9b/0x230
>>     do_wp_page+0xce1/0xf30
>>     __handle_mm_fault+0x380/0x3a0
>>     handle_mm_fault+0xde/0x290
>>     __get_user_pages+0x20d/0xbe0
>>     get_user_pages_unlocked+0xf6/0x340
>>     hva_to_pfn+0x295/0x420 [kvm]
>>     __kvm_faultin_pfn+0x5d/0x90 [kvm]
>>     kvm_mmu_faultin_pfn+0x31b/0x6e0 [kvm]
>>     kvm_tdp_page_fault+0xb6/0x160 [kvm]
>>     kvm_mmu_do_page_fault+0xee/0x1f0 [kvm]
>>     kvm_mmu_page_fault+0x8d/0x600 [kvm]
>>     vmx_handle_exit+0x18c/0x5a0 [kvm_intel]
>>     kvm_arch_vcpu_ioctl_run+0xc70/0x1c90 [kvm]
>>     kvm_vcpu_ioctl+0x2d7/0x9a0 [kvm]
>>     __x64_sys_ioctl+0x8a/0xd0
>>     do_syscall_64+0x5e/0x11b0
>>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>     </TASK>
>>    kvm: emulating exchange as write
>>
>>
>> It's not at all clear to me that switching mmu_lock to a raw lock would be a net
>> positive for PREEMPT_RT.  OOM-killing a KVM guest in a PREEMPT_RT seems like a
>> comically rare scenario.  Whereas contending mmu_lock in normal operation is
>> relatively common (assuming there are even use cases for running VMs with a
>> PREEMPT_RT host kernel).
>>
>> In fact, the only reason the splat happens is because mmu_notifiers somewhat
>> artificially forces an atomic context via non_block_start() since commit
>>
>>    ba170f76b69d ("mm, notifier: Catch sleeping/blocking for !blockable")
>>
>> Given the massive amount of churn in KVM that would be required to fully eliminate
>> the splat, and that it's not at all obvious that it would be a good change overall,
>> at least for now:
>>
>> NAK
>>
>> I'm not fundamentally opposed to such a change, but there needs to be a _lot_
>> more analysis and justification beyond "fix CONFIG_DEBUG_ATOMIC_SLEEP=y".
>>
> Hi Sean,
> Thanks for the detailed explanation and for spelling out the border
> issue.
> Understood on both points:
> 	1. The changelog wording was too strong; PREEMPT_RT changes
> 	spin_lock() semantics, and the splat is fundamentally due to
> 	spinlocks becoming sleepable there.
> 	2. Converting only mm_invalidate_lock to raw is insufficient
> 	since KVM can still take the mmu_lock (and other sleeping locks
> 	RT) in invalidate_range_start() when the invalidation hits a
> 	memslot.
> Given the above, it shounds like "convert locks to raw" is not the right
> direction without sinificat rework and justification.
> Would an acceptable direction be to handle the !blockable notifier case
> by deferring the heavyweight invalidation work(anything that take
> mmu_lock/may sleep on RT) to a context that may block(e.g. queued work),
> while keeping start()/end() accounting consisting with memslot changes ?
> if so, I can protoptype a patch along those lines and share for
> feedback.
> 
> Alternatively, if you think this needs to be addressed in
> mmu_notifiers(eg. how non_block_start() is applied), I'm happy to
> redirect my efforts there-Please advise.

Have you considered a "OOM entered" callback for MMU notifiers?  KVM's 
MMU notifier can just remove itself for example, in fact there is code 
in kvm_destroy_vm() to do that even if invalidations are unbalanced.

Paolo


