Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537901178E2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 22:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLIVyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 16:54:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbfLIVyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 16:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575928446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YZxDCRlAI3T29US+OVPW5/4WbRmrkfqV1K0Ihod+HI=;
        b=Wj3bZNt7/pgvVJ/dcUVqD2Gc2LhR1aSmz+k/PZ/RsOpmSL5LUP1d6+Lgm4BGwhL+s6bTCj
        bQ1qF56yezezKS1cWcTVSM1PQMYgShzIiJx7jRjd7ABzmBi2BFslUCjRQxcfNNucy3WbWp
        pexHfk7U31yTkOhL+Eb3xGYgRSI9U6U=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-R4KukisYMECiFHVurSOq0w-1; Mon, 09 Dec 2019 16:54:04 -0500
Received: by mail-qk1-f199.google.com with SMTP id c202so3872782qkg.4
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 13:54:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=asdCHoiBOGduZzw/eX95dd5LNUN69fEVr06J0E2v1ys=;
        b=ExnGcT3l8E81A20/LbfUgZNG/D0Dl69luVfL66ZgVkApWAFWXUaASK4KPoT4+e2HT0
         swDflDNn+y1rppYYec1FQLdPD+eRN1NlGo67vqvjFzNH4GJY792mKRp3IYPzRyxfQ1de
         MBGKZx5ChFRERqRi9k0/hXwDYD0X5KrwGk9pFI+1cMa/dEPE1gwTcBr7nQGpaADtMHq2
         IAskZ/fPPwchzenPWtpGpewIaDtHaZYjSvpus1EzaMcw1v68U9mLZcsJt2DOjQerbVWQ
         77tLhfUS6u6lA4jsuke+7g1+5vh5jFqO2eDr91VnDyWSPescFWnDy0VcktSfk4+fylPq
         GkXw==
X-Gm-Message-State: APjAAAUJljNedefISMuZfrW9jLCjAD5DAfpNsh3a5CbfLXvCvAs6NKNx
        nOpHcb56FXzunCFtsgqFiGZUC+d0i9use+XAduKG+NN0LXCQ9GPuwYjHYBpQixs6zLiczOc8BSC
        YVPejlG6Kii/m
X-Received: by 2002:a05:620a:74f:: with SMTP id i15mr7550762qki.93.1575928443616;
        Mon, 09 Dec 2019 13:54:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+DCeRrrA1hL0caKeD+gntVnRzOjU/P376xiBY2r8A7d4xwHOG8V6ReJYJXplESAmEX/JZGw==
X-Received: by 2002:a05:620a:74f:: with SMTP id i15mr7550733qki.93.1575928443143;
        Mon, 09 Dec 2019 13:54:03 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q131sm249808qke.1.2019.12.09.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 13:54:01 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:54:00 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191209215400.GA3352@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
MIME-Version: 1.0
In-Reply-To: <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: R4KukisYMECiFHVurSOq0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 11:05:47AM +0100, Paolo Bonzini wrote:
> On 03/12/19 19:46, Sean Christopherson wrote:
> > On Tue, Dec 03, 2019 at 02:48:10PM +0100, Paolo Bonzini wrote:
> >> On 02/12/19 22:50, Sean Christopherson wrote:
> >>>>
> >>>> I discussed this with Paolo, but I think Paolo preferred the per-vm
> >>>> ring because there's no good reason to choose vcpu0 as what (1)
> >>>> suggested.  While if to choose (2) we probably need to lock even for
> >>>> per-cpu ring, so could be a bit slower.
> >>> Ya, per-vm is definitely better than dumping on vcpu0.  I'm hoping we=
 can
> >>> find a third option that provides comparable performance without usin=
g any
> >>> per-vcpu rings.
> >>>
> >>
> >> The advantage of per-vCPU rings is that it naturally: 1) parallelizes
> >> the processing of dirty pages; 2) makes userspace vCPU thread do more
> >> work on vCPUs that dirty more pages.
> >>
> >> I agree that on the producer side we could reserve multiple entries in
> >> the case of PML (and without PML only one entry should be added at a
> >> time).  But I'm afraid that things get ugly when the ring is full,
> >> because you'd have to wait for all vCPUs to finish publishing the
> >> entries they have reserved.
> >=20
> > Ah, I take it the intended model is that userspace will only start pull=
ing
> > entries off the ring when KVM explicitly signals that the ring is "full=
"?
>=20
> No, it's not.  But perhaps in the asynchronous case you can delay
> pushing the reserved entries to the consumer until a moment where no
> CPUs have left empty slots in the ring buffer (somebody must have done
> multi-producer ring buffers before).  In the ring-full case that is
> harder because it requires synchronization.
>=20
> > Rather than reserve entries, what if vCPUs reserved an entire ring?  Cr=
eate
> > a pool of N=3Dnr_vcpus rings that are shared by all vCPUs.  To mark pag=
es
> > dirty, a vCPU claims a ring, pushes the pages into the ring, and then
> > returns the ring to the pool.  If pushing pages hits the soft limit, a
> > request is made to drain the ring and the ring is not returned to the p=
ool
> > until it is drained.
> >=20
> > Except for acquiring a ring, which likely can be heavily optimized, tha=
t'd
> > allow parallel processing (#1), and would provide a facsimile of #2 as
> > pushing more pages onto a ring would naturally increase the likelihood =
of
> > triggering a drain.  And it might be interesting to see the effect of u=
sing
> > different methods of ring selection, e.g. pure round robin, LRU, last u=
sed
> > on the current vCPU, etc...
>=20
> If you are creating nr_vcpus rings, and draining is done on the vCPU
> thread that has filled the ring, why not create nr_vcpus+1?  The current
> code then is exactly the same as pre-claiming a ring per vCPU and never
> releasing it, and using a spinlock to claim the per-VM ring.
>=20
> However, we could build on top of my other suggestion to add
> slot->as_id, and wrap kvm_get_running_vcpu() with a nice API, mimicking
> exactly what you've suggested.  Maybe even add a scary comment around
> kvm_get_running_vcpu() suggesting that users only do so to avoid locking
> and wrap it with a nice API.  Similar to what get_cpu/put_cpu do with
> smp_processor_id.
>=20
> 1) Add a pointer from struct kvm_dirty_ring to struct
> kvm_dirty_ring_indexes:
>=20
> vcpu->dirty_ring->data =3D &vcpu->run->vcpu_ring_indexes;
> kvm->vm_dirty_ring->data =3D *kvm->vm_run->vm_ring_indexes;
>=20
> 2) push the ring choice and locking to two new functions
>=20
> struct kvm_ring *kvm_get_dirty_ring(struct kvm *kvm)
> {
> =09struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
>=20
> =09if (vcpu && !WARN_ON_ONCE(vcpu->kvm !=3D kvm)) {
> =09=09return &vcpu->dirty_ring;
> =09} else {
> =09=09/*
> =09=09 * Put onto per vm ring because no vcpu context.
> =09=09 * We'll kick vcpu0 if ring is full.
> =09=09 */
> =09=09spin_lock(&kvm->vm_dirty_ring->lock);
> =09=09return &kvm->vm_dirty_ring;
> =09}
> }
>=20
> void kvm_put_dirty_ring(struct kvm *kvm,
> =09=09=09struct kvm_dirty_ring *ring)
> {
> =09struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
> =09bool full =3D kvm_dirty_ring_used(ring) >=3D ring->soft_limit;
>=20
> =09if (ring =3D=3D &kvm->vm_dirty_ring) {
> =09=09if (vcpu =3D=3D NULL)
> =09=09=09vcpu =3D kvm->vcpus[0];
> =09=09spin_unlock(&kvm->vm_dirty_ring->lock);
> =09}
>=20
> =09if (full)
> =09=09kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
> }
>=20
> 3) simplify kvm_dirty_ring_push to
>=20
> void kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> =09=09=09 u32 slot, u64 offset)
> {
> =09/* left as an exercise to the reader */
> }
>=20
> and mark_page_dirty_in_ring to
>=20
> static void mark_page_dirty_in_ring(struct kvm *kvm,
> =09=09=09=09    struct kvm_memory_slot *slot,
> =09=09=09=09    gfn_t gfn)
> {
> =09struct kvm_dirty_ring *ring;
>=20
> =09if (!kvm->dirty_ring_size)
> =09=09return;
>=20
> =09ring =3D kvm_get_dirty_ring(kvm);
> =09kvm_dirty_ring_push(ring, (slot->as_id << 16) | slot->id,
> =09=09=09    gfn - slot->base_gfn);
> =09kvm_put_dirty_ring(kvm, ring);
> }

I think I got the major point here.  Unless Sean has some better idea
in the future I'll go with this.

Just until recently I noticed that actually kvm_get_running_vcpu() has
a real benefit in that it gives a very solid result on whether we're
with the vcpu context, even more accurate than when we pass vcpu
pointers around (because sometimes we just passed the kvm pointer
along the stack even if we're with a vcpu context, just like what we
did with mark_page_dirty_in_slot).  I'm thinking whether I can start
to use this information in the next post on solving an issue I
encountered with the waitqueue.

Current waitqueue is still problematic in that it could wait even with
the mmu lock held when with vcpu context.

The issue is KVM_RESET_DIRTY_RINGS needs the mmu lock to manipulate
the write bits, while it's the only interface to also wake up the
dirty ring sleepers.  They could dead lock like this:

      main thread                            vcpu thread
      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                            =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
                                             kvm page fault
                                               mark_page_dirty_in_slot
                                               mmu lock taken
                                               mark dirty, ring full
                                               queue on waitqueue
                                               (with mmu lock)
      KVM_RESET_DIRTY_RINGS
        take mmu lock               <------------ deadlock here
        reset ring gfns
        wakeup dirty ring sleepers

And if we see if the mark_page_dirty_in_slot() is not with a vcpu
context (e.g. kvm_mmu_page_fault) but with an ioctl context (those
cases we'll use per-vm dirty ring) then it's probably fine.

My planned solution:

- When kvm_get_running_vcpu() !=3D NULL, we postpone the waitqueue waits
  until we finished handling this page fault, probably in somewhere
  around vcpu_enter_guest, so that we can do wait_event() after the
  mmu lock released

- For per-vm ring full, I'll do what we do now (wait_event() as long
  in mark_page_dirty_in_ring) assuming it should not be with the mmu
  lock held

To achieve above, I think I really need to know exactly on whether
we're with the vcpu context, where I suppose kvm_get_running_vcpu()
would work for me then, rather than checking against vcpu pointer
passed in.

I also wanted to let KVM_RUN return immediately if either per-vm ring
or per-vcpu ring reaches softlimit always, instead of continue
execution until the next dirty ring full event.

I'd be glad to receive any early comment before I move on to these.

Thanks!

--=20
Peter Xu

