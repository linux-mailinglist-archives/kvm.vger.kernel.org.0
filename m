Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7549312A5CE
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfLYDXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:23:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47737 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbfLYDXj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Dec 2019 22:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577244218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruyeqG1I6DvkmeNFGOrLYjoLohtwIGHhqEPY82l6nhA=;
        b=DIZmayoH9006v9Ctf3WLGiYX+ekbJbaEHISW16bWoTgUuJrZNs3ed/xyXMibl0B0Lwu6aH
        RGgRFkbilqASAFn5fOSKPlwgs3xxskag7NkQ/JU9siMn5ltypU/lPrzO1Fe1BNTo+5oERO
        SqbQtDmOgly9Ih6NW/A3KFeuXvP93c8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-I7_hbLxcNoKtW2LHnlBUZQ-1; Tue, 24 Dec 2019 22:23:37 -0500
X-MC-Unique: I7_hbLxcNoKtW2LHnlBUZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA218107ACC4;
        Wed, 25 Dec 2019 03:23:35 +0000 (UTC)
Received: from [10.72.12.185] (ovpn-12-185.pek2.redhat.com [10.72.12.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D5E5D9CD;
        Wed, 25 Dec 2019 03:23:24 +0000 (UTC)
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com>
 <5b341dce-6497-ada4-a77e-2bc5af2c53ab@redhat.com>
 <20191224150836.GB3023@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <14c2c6d3-00fc-1507-9dd3-c25605717d3d@redhat.com>
Date:   Wed, 25 Dec 2019 11:23:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224150836.GB3023@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/24 =E4=B8=8B=E5=8D=8811:08, Peter Xu wrote:
> On Tue, Dec 24, 2019 at 02:16:04PM +0800, Jason Wang wrote:
>>> +struct kvm_dirty_ring {
>>> +	u32 dirty_index;
>>
>> Does this always equal to indices->avail_index?
> Yes, but here we keep dirty_index as the internal one, so we never
> need to worry about illegal userspace writes to avail_index (then we
> never read it from kernel).


I get you. But I'm not sure it's wroth to bother. We meet similar issue=20
in virtio, the used_idx is not expected to write by userspace. We simply=20
add checks.

But anyway, I'm fine if you want to keep it (maybe with a comment to=20
explain).


>
>>
>>> +	u32 reset_index;
>>> +	u32 size;
>>> +	u32 soft_limit;
>>> +	struct kvm_dirty_gfn *dirty_gfns;
>>> +	struct kvm_dirty_ring_indices *indices;
>>
>> Any reason to keep dirty gfns and indices in different places? I guess=
 it is
>> because you want to map dirty_gfns as readonly page but I couldn't fin=
d such
>> codes...
> That's a good point!  We should actually map the dirty gfns as read
> only.  I've added the check, something like this:
>
> static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
> {
> 	struct kvm_vcpu *vcpu =3D file->private_data;
> 	unsigned long pages =3D (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>
> 	/* If to map any writable page within dirty ring, fail it */
> 	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> 	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> 	    vma->vm_flags & VM_WRITE)
> 		return -EINVAL;
>
> 	vma->vm_ops =3D &kvm_vcpu_vm_ops;
> 	return 0;
> }
>
> I also changed the test code to cover this case.
>
> [...]


Looks good.


>
>>> +struct kvm_dirty_ring_indices {
>>> +	__u32 avail_index; /* set by kernel */
>>> +	__u32 fetch_index; /* set by userspace */
>>
>> Is this better to make those two cacheline aligned?
> Yes, Paolo should have mentioned that but I must have missed it!  I
> hope I didn't miss anything else.
>
> [...]
>
>>> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *rin=
g)
>>> +{
>>> +	u32 cur_slot, next_slot;
>>> +	u64 cur_offset, next_offset;
>>> +	unsigned long mask;
>>> +	u32 fetch;
>>> +	int count =3D 0;
>>> +	struct kvm_dirty_gfn *entry;
>>> +	struct kvm_dirty_ring_indices *indices =3D ring->indices;
>>> +	bool first_round =3D true;
>>> +
>>> +	fetch =3D READ_ONCE(indices->fetch_index);
>>> +
>>> +	/*
>>> +	 * Note that fetch_index is written by the userspace, which
>>> +	 * should not be trusted.  If this happens, then it's probably
>>> +	 * that the userspace has written a wrong fetch_index.
>>> +	 */
>>> +	if (fetch - ring->reset_index > ring->size)
>>> +		return -EINVAL;
>>> +
>>> +	if (fetch =3D=3D ring->reset_index)
>>> +		return 0;
>>> +
>>> +	/* This is only needed to make compilers happy */
>>> +	cur_slot =3D cur_offset =3D mask =3D 0;
>>> +	while (ring->reset_index !=3D fetch) {
>>> +		entry =3D &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>>> +		next_slot =3D READ_ONCE(entry->slot);
>>> +		next_offset =3D READ_ONCE(entry->offset);
>>> +		ring->reset_index++;
>>> +		count++;
>>> +		/*
>>> +		 * Try to coalesce the reset operations when the guest is
>>> +		 * scanning pages in the same slot.
>>> +		 */
>>> +		if (!first_round && next_slot =3D=3D cur_slot) {
>>
>> initialize cur_slot to -1 then we can drop first_round here?
> cur_slot is unsigned.  We can force cur_slot to be s64 but maybe we
> can also simply keep the first_round to be clear from its name.
>
> [...]


Sure.


>
>>> +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 o=
ffset)
>>> +{
>>> +	struct kvm_dirty_gfn *entry;
>>> +	struct kvm_dirty_ring_indices *indices =3D ring->indices;
>>> +
>>> +	/*
>>> +	 * Note: here we will start waiting even soft full, because we
>>> +	 * can't risk making it completely full, since vcpu0 could use
>>> +	 * it right after us and if vcpu0 context gets full it could
>>> +	 * deadlock if wait with mmu_lock held.
>>> +	 */
>>> +	if (kvm_get_running_vcpu() =3D=3D NULL &&
>>> +	    kvm_dirty_ring_soft_full(ring))
>>> +		return -EBUSY;
>>> +
>>> +	/* It will never gets completely full when with a vcpu context */
>>> +	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
>>> +
>>> +	entry =3D &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
>>> +	entry->slot =3D slot;
>>> +	entry->offset =3D offset;
>>> +	smp_wmb();
>>
>> Better to add comment to explain this barrier. E.g pairing.
> Will do.
>
>>
>>> +	ring->dirty_index++;
>>> +	WRITE_ONCE(indices->avail_index, ring->dirty_index);
>>
>> Is WRITE_ONCE() a must here?
> I think not, but seems to be clearer that we're publishing something
> explicilty to userspace.  Since asked, I'm actually curious on whether
> immediate memory writes like this could start to affect perf from any
> of your previous perf works?


I never measure the impact for a specific WRITE_ONCE(). But we don't do=20
this in virtio/vhost. Maybe the maintainers can give more comments on thi=
s.

Thanks


>
> Thanks,
>

