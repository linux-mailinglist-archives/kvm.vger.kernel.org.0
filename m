Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93D31128D2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 11:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDKFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 05:05:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50057 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727420AbfLDKFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 05:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575453951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bzkOfkSPb6+yZQ19D8wPgL9epYwdepj3FzmNzcMCF4=;
        b=Xo2ZxuP+ZKMjMSxS1uzldPjtQhA5s9X9771JbYmCuVyysTd7CFa4oYgcZsLXud/GZqFIUt
        PRyOeKAYXPcOcUxzHdfGyW1vtpbn9fd2Vf9zPwaVtkmlBqeg+xHjOrNYPNmXAu8wK5dvPl
        ewdtWVFM9kZX3v4TCO8G71jN/dq6vxg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-cuY3rbKBPQ2j1I_VVRCCZA-1; Wed, 04 Dec 2019 05:05:51 -0500
Received: by mail-wm1-f72.google.com with SMTP id b131so2026312wmd.9
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 02:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bzkOfkSPb6+yZQ19D8wPgL9epYwdepj3FzmNzcMCF4=;
        b=kvC1rRNnMW8WjKImMY7RtJFQq55Tkc6o8iUZgS08sQ4xiBksqehqXpFPeq+/hLzn61
         CKmqyvDK3Wr8l4vkpQIxsEAsq05BdDrgc2Ycea6QiRU+OzUJF9B/A1fU7EtNPluFKoUA
         vVPZ5lyPVoE71KI8wqeiWJLfYdFPvRTXZpuNAbS4aETtS1FshAVoNm0CKdMWhtj0lMTK
         ROE8EFZLGJTn9/+0sqAKnqt+uBTjVig3wsd+xKE0PtTrHigMBlLWv51fTZCvopSYOM0D
         BoSYevzI5s9D/EyhghR3cyknDYbbw0Kw0ibzSJF6CXiBDn5ecktyXEa/RexP3mfPKQl5
         RaYA==
X-Gm-Message-State: APjAAAX5NFOXaS/p0QYZ3t44HNGUaMdWzw9LwxJTq6ASMTFl7qSA599M
        SRuXx1hEQl0TWwGLYfUS/v9QsvS2rzOMZ44W3/CXW6/JSIH8oVZlnw1V/BbT6Ar1Lgb5LyHa35d
        44gYSx3ceqsqK
X-Received: by 2002:a1c:6389:: with SMTP id x131mr24167545wmb.174.1575453949342;
        Wed, 04 Dec 2019 02:05:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqzAiISuDcUWRbEN4GA4CkChNhzcGczIBRYMip+8ZZRMkK0DKzpZdJ6CixN1sArGDUdLUzH2jQ==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr24167500wmb.174.1575453948930;
        Wed, 04 Dec 2019 02:05:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id k4sm6458033wmk.26.2019.12.04.02.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 02:05:48 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com> <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
Date:   Wed, 4 Dec 2019 11:05:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203184600.GB19877@linux.intel.com>
Content-Language: en-US
X-MC-Unique: cuY3rbKBPQ2j1I_VVRCCZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/19 19:46, Sean Christopherson wrote:
> On Tue, Dec 03, 2019 at 02:48:10PM +0100, Paolo Bonzini wrote:
>> On 02/12/19 22:50, Sean Christopherson wrote:
>>>>
>>>> I discussed this with Paolo, but I think Paolo preferred the per-vm
>>>> ring because there's no good reason to choose vcpu0 as what (1)
>>>> suggested.  While if to choose (2) we probably need to lock even for
>>>> per-cpu ring, so could be a bit slower.
>>> Ya, per-vm is definitely better than dumping on vcpu0.  I'm hoping we can
>>> find a third option that provides comparable performance without using any
>>> per-vcpu rings.
>>>
>>
>> The advantage of per-vCPU rings is that it naturally: 1) parallelizes
>> the processing of dirty pages; 2) makes userspace vCPU thread do more
>> work on vCPUs that dirty more pages.
>>
>> I agree that on the producer side we could reserve multiple entries in
>> the case of PML (and without PML only one entry should be added at a
>> time).  But I'm afraid that things get ugly when the ring is full,
>> because you'd have to wait for all vCPUs to finish publishing the
>> entries they have reserved.
> 
> Ah, I take it the intended model is that userspace will only start pulling
> entries off the ring when KVM explicitly signals that the ring is "full"?

No, it's not.  But perhaps in the asynchronous case you can delay
pushing the reserved entries to the consumer until a moment where no
CPUs have left empty slots in the ring buffer (somebody must have done
multi-producer ring buffers before).  In the ring-full case that is
harder because it requires synchronization.

> Rather than reserve entries, what if vCPUs reserved an entire ring?  Create
> a pool of N=nr_vcpus rings that are shared by all vCPUs.  To mark pages
> dirty, a vCPU claims a ring, pushes the pages into the ring, and then
> returns the ring to the pool.  If pushing pages hits the soft limit, a
> request is made to drain the ring and the ring is not returned to the pool
> until it is drained.
> 
> Except for acquiring a ring, which likely can be heavily optimized, that'd
> allow parallel processing (#1), and would provide a facsimile of #2 as
> pushing more pages onto a ring would naturally increase the likelihood of
> triggering a drain.  And it might be interesting to see the effect of using
> different methods of ring selection, e.g. pure round robin, LRU, last used
> on the current vCPU, etc...

If you are creating nr_vcpus rings, and draining is done on the vCPU
thread that has filled the ring, why not create nr_vcpus+1?  The current
code then is exactly the same as pre-claiming a ring per vCPU and never
releasing it, and using a spinlock to claim the per-VM ring.

However, we could build on top of my other suggestion to add
slot->as_id, and wrap kvm_get_running_vcpu() with a nice API, mimicking
exactly what you've suggested.  Maybe even add a scary comment around
kvm_get_running_vcpu() suggesting that users only do so to avoid locking
and wrap it with a nice API.  Similar to what get_cpu/put_cpu do with
smp_processor_id.

1) Add a pointer from struct kvm_dirty_ring to struct
kvm_dirty_ring_indexes:

vcpu->dirty_ring->data = &vcpu->run->vcpu_ring_indexes;
kvm->vm_dirty_ring->data = *kvm->vm_run->vm_ring_indexes;

2) push the ring choice and locking to two new functions

struct kvm_ring *kvm_get_dirty_ring(struct kvm *kvm)
{
	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();

	if (vcpu && !WARN_ON_ONCE(vcpu->kvm != kvm)) {
		return &vcpu->dirty_ring;
	} else {
		/*
		 * Put onto per vm ring because no vcpu context.
		 * We'll kick vcpu0 if ring is full.
		 */
		spin_lock(&kvm->vm_dirty_ring->lock);
		return &kvm->vm_dirty_ring;
	}
}

void kvm_put_dirty_ring(struct kvm *kvm,
			struct kvm_dirty_ring *ring)
{
	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
	bool full = kvm_dirty_ring_used(ring) >= ring->soft_limit;

	if (ring == &kvm->vm_dirty_ring) {
		if (vcpu == NULL)
			vcpu = kvm->vcpus[0];
		spin_unlock(&kvm->vm_dirty_ring->lock);
	}

	if (full)
		kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
}

3) simplify kvm_dirty_ring_push to

void kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
			 u32 slot, u64 offset)
{
	/* left as an exercise to the reader */
}

and mark_page_dirty_in_ring to

static void mark_page_dirty_in_ring(struct kvm *kvm,
				    struct kvm_memory_slot *slot,
				    gfn_t gfn)
{
	struct kvm_dirty_ring *ring;

	if (!kvm->dirty_ring_size)
		return;

	ring = kvm_get_dirty_ring(kvm);
	kvm_dirty_ring_push(ring, (slot->as_id << 16) | slot->id,
			    gfn - slot->base_gfn);
	kvm_put_dirty_ring(kvm, ring);
}

Paolo

>> It's ugly that we _also_ need a per-VM ring, but unfortunately some
>> operations do not really have a vCPU that they can refer to.
> 

