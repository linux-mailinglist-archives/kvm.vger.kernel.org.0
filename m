Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D011C119
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLLAIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:08:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38965 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727119AbfLLAIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 19:08:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576109298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xw60aYtXUN1xhUN7efVaOJ9r/v7ZD0Ejg67xKxlTVk=;
        b=Pmy9RZGe4BLtNLT8GcsUTPGVx9k4ko92viE26VkfxPDqY3sqYtAZCU6U8j3qYgi/GpOMmf
        eA2pMPJ9lC7NmvUchmtj3Nt67ZTw+VZP38zJiBkdS9AXm5p6Fxb0RlURziaGQA4meFyRGA
        qXCsbLJzd5XDemzC7goKYjemjgkq01I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-WK2dQDzMPpSHukdfq_CIAQ-1; Wed, 11 Dec 2019 19:08:17 -0500
X-MC-Unique: WK2dQDzMPpSHukdfq_CIAQ-1
Received: by mail-wr1-f70.google.com with SMTP id u18so282251wrn.11
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:08:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3xw60aYtXUN1xhUN7efVaOJ9r/v7ZD0Ejg67xKxlTVk=;
        b=qeCVlUUqaPYZfmnfPKPcebjQdcoACXs08ssVk0WSKK2H03zqz7brqpDNGZ/+ZwoLVw
         6cYD9SrxwBl9DIH9DIbL2QruHyBJbC65ADQfSkVSgKSWphH9+ubr5ZvBuhbps0hNun5Q
         IPJv4xCWu82XxS7hUtHKKhBbJupBMnpmWXDbAUoeDlhK0lVrxGLKKDzMTXErAbTzCbM3
         O6Gq3kYcOlGhZRCZpgCiaRt93uhCJFJGqkOSPD2q68TClvY4jxJAsq7KGzCEC9dXbCgY
         ioy++09XZJV94uf2Xo9GQarNU7MnfJRiBOD3sjl4Csba6F7lonUZuIIPWurnHoosEgF5
         hb0A==
X-Gm-Message-State: APjAAAUdLgEC/tfmPXdSiyYrU8LrXhAn2w2tnkjZocNxXJBcHOj8O2PK
        gaxP1pDYZLEj+9XzgOI6mBYzgQuZioVEFqw3Pk9Mjt+XmObHjcK5wIK4AfPtlsKNiS0WYTopaaE
        JAHt3ndODF6UW
X-Received: by 2002:a1c:49c3:: with SMTP id w186mr2906789wma.53.1576109295714;
        Wed, 11 Dec 2019 16:08:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxoVRrcAD0KhLpnMl2le6nvx6cu8ZcWU4cMIAJiKSk9I63sxr2UQvQ2yso9I3jDHvbduYI06w==
X-Received: by 2002:a1c:49c3:: with SMTP id w186mr2906747wma.53.1576109295300;
        Wed, 11 Dec 2019 16:08:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id n12sm4202078wmd.1.2019.12.11.16.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:08:14 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org> <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
Date:   Thu, 12 Dec 2019 01:08:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211172713-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 23:57, Michael S. Tsirkin wrote:
>>> All these seem like arbitrary limitations to me.
>>>
>>> Sizing the ring correctly might prove to be a challenge.
>>>
>>> Thus I think there's value in resizing the rings
>>> without destroying VCPU.
>>
>> Do you have an example on when we could use this feature?
> 
> So e.g. start with a small ring, and if you see stalls too often
> increase it? Otherwise I don't see how does one decide
> on ring size.

If you see stalls often, it means the guest is dirtying memory very
fast.  Harvesting the ring puts back pressure on the guest, you may
prefer a smaller ring size to avoid a bufferbloat-like situation.

Note that having a larger ring is better, even though it does incur a
memory cost, because it means the migration thread will be able to reap
the ring buffer asynchronously with no vmexits.

With smaller ring sizes the cost of flushing the TLB when resetting the
rings goes up, but the initial bulk copy phase _will_ have vmexits and
then having to reap more dirty rings becomes more expensive and
introduces some jitter.  So it will require some experimentation to find
an optimal value.

Anyway if in the future we go for resizable rings, KVM_ENABLE_CAP can be
passed the largest desired size and then another ioctl can be introduced
to set the mask for indices.

>>> Also, power of two just saves a branch here and there,
>>> but wastes lots of memory. Just wrap the index around to
>>> 0 and then users can select any size?
>>
>> Same as above to postpone until we need it?
> 
> It's to save memory, don't we always need to do that?

Does it really save that much memory?  Would it really be so beneficial
to choose 12K entries rather than 8K or 16K in the ring?

>> My understanding of this is that normally we do only want either one
>> of them depending on the major workload and the configuration of the
>> guest.
> 
> And again how does one know which to enable? No one has the
> time to fine-tune gazillion parameters.

Hopefully we can always use just the ring buffer.

> IMHO a huge amount of benchmarking has to happen if you just want to
> set this loose on users as default with these kind of
> limitations. We need to be sure that even though in theory
> it can be very bad, in practice it's actually good.
> If it's auto-tuning then it's a much easier sell to upstream
> even if there's a chance of some regressions.

Auto-tuning is not a silver bullet, it requires just as much
benchmarking to make sure that it doesn't oscillate crazily and that it
actually outperforms a simple fixed size.

>> Yeh kvm versioning could work too.  Here we can also return a zero
>> just like the most of the caps (or KVM_DIRTY_LOG_PAGE_OFFSET as in the
>> original patchset, but it's really helpless either because it's
>> defined in uapi), but I just don't see how it helps...  So I returned
>> a version number just in case we'd like to change the layout some day
>> and when we don't want to bother introducing another cap bit for the
>> same feature (like KVM_CAP_MANUAL_DIRTY_LOG_PROTECT and
>> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2).
> 
> I guess it's up to Paolo but really I don't see the point.
> You can add a version later when it means something ...

Yeah, we can return the maximum size of the ring buffer, too.

>> I'd say it won't be a big issue on locking 1/2M of host mem for a
>> vm...
>> Also note that if dirty ring is enabled, I plan to evaporate the
>> dirty_bitmap in the next post. The old kvm->dirty_bitmap takes
>> $GUEST_MEM/32K*2 mem.  E.g., for 64G guest it's 64G/32K*2=4M.  If with
>> dirty ring of 8 vcpus, that could be 64K*8=0.5M, which could be even
>> less memory used.
> 
> Right - I think Avi described the bitmap in kernel memory as one of
> design mistakes. Why repeat that with the new design?

Do you have a source for that?  At least the dirty bitmap has to be
accessed from atomic context so it seems unlikely that it can be moved
to user memory.

The dirty ring could use user memory indeed, but it would be much harder
to set up (multiple ioctls for each ring?  what to do if userspace
forgets one? etc.).  The mmap API is easier to use.

>>>> +	entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>>>> +	/*
>>>> +	 * The ring buffer is shared with userspace, which might mmap
>>>> +	 * it and concurrently modify slot and offset.  Userspace must
>>>> +	 * not be trusted!  READ_ONCE prevents the compiler from changing
>>>> +	 * the values after they've been range-checked (the checks are
>>>> +	 * in kvm_reset_dirty_gfn).
>>>
>>> What it doesn't is prevent speculative attacks.  That's why things like
>>> copy from user have a speculation barrier.  Instead of worrying about
>>> that, unless it's really critical, I think you'd do well do just use
>>> copy to/from user.

An unconditional speculation barrier (lfence) is also expensive.  We
already have macros to add speculation checks with array_index_nospec at
the right places, for example __kvm_memslots.  We should add an
array_index_nospec to id_to_memslot as well.  I'll send a patch for that.

>>> What depends on what here? Looks suspicious ...
>>
>> Hmm, I think maybe it can be removed because the entry pointer
>> reference below should be an ordering constraint already?

entry->xxx depends on ring->reset_index.

>>> what's the story around locking here? Why is it safe
>>> not to take the lock sometimes?
>>
>> kvm_dirty_ring_push() will be with lock==true only when the per-vm
>> ring is used.  For per-vcpu ring, because that will only happen with
>> the vcpu context, then we don't need locks (so kvm_dirty_ring_push()
>> is called with lock==false).

FWIW this will be done much more nicely in v2.

>>>> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>>>> +	if (!page) {
>>>> +		r = -ENOMEM;
>>>> +		goto out_err_alloc_page;
>>>> +	}
>>>> +	kvm->vm_run = page_address(page);
>>>
>>> So 4K with just 8 bytes used. Not as bad as 1/2Mbyte for the ring but
>>> still. What is wrong with just a pointer and calling put_user?
>>
>> I want to make it the start point for sharing fields between
>> user/kernel per-vm.  Just like kvm_run for per-vcpu.

This page is actually not needed at all.  Userspace can just map at
KVM_DIRTY_LOG_PAGE_OFFSET, the indices reside there.  You can drop
kvm_vm_run completely.

>>>> +	} else {
>>>> +		/*
>>>> +		 * Put onto per vm ring because no vcpu context.  Kick
>>>> +		 * vcpu0 if ring is full.
>>>
>>> What about tasks on vcpu 0? Do guests realize it's a bad idea to put
>>> critical tasks there, they will be penalized disproportionally?
>>
>> Reasonable question.  So far we can't avoid it because vcpu exit is
>> the event mechanism to say "hey please collect dirty bits".  Maybe
>> someway is better than this, but I'll need to rethink all these
>> over...
> 
> Maybe signal an eventfd, and let userspace worry about deciding what to
> do.

This has to be done synchronously.  But the vm ring should be used very
rarely (it's for things like kvmclock updates that write to guest memory
outside a vCPU), possibly a handful of times in the whole run of the VM.

>>> KVM_DIRTY_RING_MAX_ENTRIES is not part of UAPI.
>>> So how does userspace know what's legal?
>>> Do you expect it to just try?
>>
>> Yep that's what I thought. :)

We should return it for KVM_CHECK_EXTENSION.

Paolo

