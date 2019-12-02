Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB23E10F1FD
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 22:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLBVQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 16:16:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbfLBVQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 16:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575321405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HsxIeqenDpNm9usZoCWHak5+2zvDWy2/07QFGWrXAmQ=;
        b=ETSC+kn1ZDb73UmCZtZtAJJhRfCVPFglAiCeb2WFbcy41qoU9N/9Aw6pCVC6XxaEQOBLTO
        mMne9FV5sV7oAtbfO2cJNz7KdiUxp9PzM480ASop6HB318C+CbCrao2WfGO2eP6GhX/Euf
        axTKNxNneiNzN67IQsoZtNLzygO4ZOg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-IkXxxizdNQ2aRbSligVqNg-1; Mon, 02 Dec 2019 16:16:44 -0500
Received: by mail-qk1-f197.google.com with SMTP id e11so617785qkb.19
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 13:16:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yLqKdRYXW22CYFK1+0CdEpAmmC4Khbpr479tlvSNKl0=;
        b=t3sP2h73L3f5thuY/VBL+AFdEiJaaEE0qbgtpmjyVS98th0PLjIBhVzgExKChm9Nbw
         eUVJJYfFptwDUGl0bR9LH4klND3M8angVJWbwaA5fFe0gGZCnXJ92N7NkKFNmpc7ZknP
         BdlFHhi2bHxhl5X0cJ24gI/QESZTYh7YQMVkoKKef/S/lBCoUuQ/nfY8+xDYrj6AjiUW
         /j4R836aSzSYgtFig/x+T5k470gqOqn55fCe+Ef00dXMCmGMa9A6mGmZOifotxbQVHIc
         2BMQ28acQNt+7/IgGKcBXTP+TMIHahYQu9FUirhj25nAIFfp9CkqEbBLD/kyYK2xDEXr
         +B3w==
X-Gm-Message-State: APjAAAU72c0KwqChO/SbMPOsl20o62r4Gk6XdIVD9YzAgeouotgznBTM
        FskoPCpZ8E+s9CbwltwngDVMxJECQaF9sXeIAMzGrLHxtC3D2Vh18b8IjIxWWi7zWY6ZC0UJogQ
        3jjfh8zWgXRa2
X-Received: by 2002:a37:4fd8:: with SMTP id d207mr1180515qkb.464.1575321403297;
        Mon, 02 Dec 2019 13:16:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6O+Vqb/bQPH9jnBxXt4emXjwV9S5NTv0GYG1rSQ5/A2iEr5+GVYD6SatOV2l0VRfc2rK/Ow==
X-Received: by 2002:a37:4fd8:: with SMTP id d207mr1180460qkb.464.1575321402781;
        Mon, 02 Dec 2019 13:16:42 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id g62sm471984qkd.25.2019.12.02.13.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 13:16:41 -0800 (PST)
Date:   Mon, 2 Dec 2019 16:16:40 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191202211640.GF31681@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202201036.GJ4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: IkXxxizdNQ2aRbSligVqNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 12:10:36PM -0800, Sean Christopherson wrote:
> On Fri, Nov 29, 2019 at 04:34:54PM -0500, Peter Xu wrote:
> > This patch is heavily based on previous work from Lei Cao
> > <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> >=20
> > KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> > are copied to userspace when userspace queries KVM for its dirty page
> > information.  The use of bitmaps is mostly sufficient for live
> > migration, as large parts of memory are be dirtied from one log-dirty
> > pass to another.  However, in a checkpointing system, the number of
> > dirty pages is small and in fact it is often bounded---the VM is
> > paused when it has dirtied a pre-defined number of pages. Traversing a
> > large, sparsely populated bitmap to find set bits is time-consuming,
> > as is copying the bitmap to user-space.
> >=20
> > A similar issue will be there for live migration when the guest memory
> > is huge while the page dirty procedure is trivial.  In that case for
> > each dirty sync we need to pull the whole dirty bitmap to userspace
> > and analyse every bit even if it's mostly zeros.
> >=20
> > The preferred data structure for above scenarios is a dense list of
> > guest frame numbers (GFN).  This patch series stores the dirty list in
> > kernel memory that can be memory mapped into userspace to allow speedy
> > harvesting.
> >=20
> > We defined two new data structures:
> >=20
> >   struct kvm_dirty_ring;
> >   struct kvm_dirty_ring_indexes;
> >=20
> > Firstly, kvm_dirty_ring is defined to represent a ring of dirty
> > pages.  When dirty tracking is enabled, we can push dirty gfn onto the
> > ring.
> >=20
> > Secondly, kvm_dirty_ring_indexes is defined to represent the
> > user/kernel interface of each ring.  Currently it contains two
> > indexes: (1) avail_index represents where we should push our next
> > PFN (written by kernel), while (2) fetch_index represents where the
> > userspace should fetch the next dirty PFN (written by userspace).
> >=20
> > One complete ring is composed by one kvm_dirty_ring plus its
> > corresponding kvm_dirty_ring_indexes.
> >=20
> > Currently, we have N+1 rings for each VM of N vcpus:
> >=20
> >   - for each vcpu, we have 1 per-vcpu dirty ring,
> >   - for each vm, we have 1 per-vm dirty ring
>=20
> Why?  I assume the purpose of per-vcpu rings is to avoid contention betwe=
en
> threads, but the motiviation needs to be explicitly stated.  And why is a
> per-vm fallback ring needed?

Yes, as explained in previous reply, the problem is there could have
guest memory writes without vcpu contexts.

>=20
> If my assumption is correct, have other approaches been tried/profiled?
> E.g. using cmpxchg to reserve N number of entries in a shared ring.

Not yet, but I'd be fine to try anything if there's better
alternatives.  Besides, could you help explain why sharing one ring
and let each vcpu to reserve a region in the ring could be helpful in
the pov of performance?

> IMO,
> adding kvm_get_running_vcpu() is a hack that is just asking for future
> abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring()
> look extremely fragile.

I agree.  Another way is to put heavier traffic to the per-vm ring,
but the downside could be that the per-vm ring could get full easier
(but I haven't tested).

> I also dislike having two different mechanisms
> for accessing the ring (lock for per-vm, something else for per-vcpu).

Actually I proposed to drop the per-vm ring (actually I had a version
that implemented this.. and I just changed it back to the per-vm ring
later on, see below) and when there's no vcpu context I thought about:

  (1) use vcpu0 ring

  (2) or a better algo to pick up a per-vcpu ring (like, the less full
      ring, we can do many things here, e.g., we can easily maintain a
      structure track this so we can get O(1) search, I think)

I discussed this with Paolo, but I think Paolo preferred the per-vm
ring because there's no good reason to choose vcpu0 as what (1)
suggested.  While if to choose (2) we probably need to lock even for
per-cpu ring, so could be a bit slower.

Since this is still RFC, I think we still have chance to change this,
depending on how the discussion goes.

>=20
> > Please refer to the documentation update in this patch for more
> > details.
> >=20
> > Note that this patch implements the core logic of dirty ring buffer.
> > It's still disabled for all archs for now.  Also, we'll address some
> > of the other issues in follow up patches before it's firstly enabled
> > on x86.
> >=20
> > [1] https://patchwork.kernel.org/patch/10471409/
> >=20
> > Signed-off-by: Lei Cao <lei.cao@stratus.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
>=20
> ...
>=20
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > new file mode 100644
> > index 000000000000..9264891f3c32
> > --- /dev/null
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -0,0 +1,156 @@
> > +#include <linux/kvm_host.h>
> > +#include <linux/kvm.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/kvm_dirty_ring.h>
> > +
> > +u32 kvm_dirty_ring_get_rsvd_entries(void)
> > +{
> > +=09return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> > +}
> > +
> > +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > +{
> > +=09u32 size =3D kvm->dirty_ring_size;
>=20
> Just pass in @size, that way you don't need @kvm.  And the callers will b=
e
> less ugly, e.g. the initial allocation won't need to speculatively set
> kvm->dirty_ring_size.

Sure.

>=20
> > +
> > +=09ring->dirty_gfns =3D vmalloc(size);
> > +=09if (!ring->dirty_gfns)
> > +=09=09return -ENOMEM;
> > +=09memset(ring->dirty_gfns, 0, size);
> > +
> > +=09ring->size =3D size / sizeof(struct kvm_dirty_gfn);
> > +=09ring->soft_limit =3D
> > +=09    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -
>=20
> And passing @size avoids issues like this where a local var is ignored.
>=20
> > +=09    kvm_dirty_ring_get_rsvd_entries();
> > +=09ring->dirty_index =3D 0;
> > +=09ring->reset_index =3D 0;
> > +=09spin_lock_init(&ring->lock);
> > +
> > +=09return 0;
> > +}
> > +
>=20
> ...
>=20
> > +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
> > +{
> > +=09if (ring->dirty_gfns) {
>=20
> Why condition freeing the dirty ring on kvm->dirty_ring_size, this
> obviously protects itself.  Not to mention vfree() also plays nice with a
> NULL input.

Ok I can drop this check.

>=20
> > +=09=09vfree(ring->dirty_gfns);
> > +=09=09ring->dirty_gfns =3D NULL;
> > +=09}
> > +}
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 681452d288cd..8642c977629b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -64,6 +64,8 @@
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/kvm.h>
> > =20
> > +#include <linux/kvm_dirty_ring.h>
> > +
> >  /* Worst case buffer size needed for holding an integer. */
> >  #define ITOA_MAX_LEN 12
> > =20
> > @@ -149,6 +151,10 @@ static void mark_page_dirty_in_slot(struct kvm *kv=
m,
> >  =09=09=09=09    struct kvm_vcpu *vcpu,
> >  =09=09=09=09    struct kvm_memory_slot *memslot,
> >  =09=09=09=09    gfn_t gfn);
> > +static void mark_page_dirty_in_ring(struct kvm *kvm,
> > +=09=09=09=09    struct kvm_vcpu *vcpu,
> > +=09=09=09=09    struct kvm_memory_slot *slot,
> > +=09=09=09=09    gfn_t gfn);
> > =20
> >  __visible bool kvm_rebooting;
> >  EXPORT_SYMBOL_GPL(kvm_rebooting);
> > @@ -359,11 +365,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct k=
vm *kvm, unsigned id)
> >  =09vcpu->preempted =3D false;
> >  =09vcpu->ready =3D false;
> > =20
> > +=09if (kvm->dirty_ring_size) {
> > +=09=09r =3D kvm_dirty_ring_alloc(vcpu->kvm, &vcpu->dirty_ring);
> > +=09=09if (r) {
> > +=09=09=09kvm->dirty_ring_size =3D 0;
> > +=09=09=09goto fail_free_run;
>=20
> This looks wrong, kvm->dirty_ring_size is used to free allocations, i.e.
> previous allocations will leak if a vcpu allocation fails.

You are right.  That's an overkill.

>=20
> > +=09=09}
> > +=09}
> > +
> >  =09r =3D kvm_arch_vcpu_init(vcpu);
> >  =09if (r < 0)
> > -=09=09goto fail_free_run;
> > +=09=09goto fail_free_ring;
> >  =09return 0;
> > =20
> > +fail_free_ring:
> > +=09if (kvm->dirty_ring_size)
> > +=09=09kvm_dirty_ring_free(&vcpu->dirty_ring);
> >  fail_free_run:
> >  =09free_page((unsigned long)vcpu->run);
> >  fail:
> > @@ -381,6 +398,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
> >  =09put_pid(rcu_dereference_protected(vcpu->pid, 1));
> >  =09kvm_arch_vcpu_uninit(vcpu);
> >  =09free_page((unsigned long)vcpu->run);
> > +=09if (vcpu->kvm->dirty_ring_size)
> > +=09=09kvm_dirty_ring_free(&vcpu->dirty_ring);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
> > =20
> > @@ -690,6 +709,7 @@ static struct kvm *kvm_create_vm(unsigned long type=
)
> >  =09struct kvm *kvm =3D kvm_arch_alloc_vm();
> >  =09int r =3D -ENOMEM;
> >  =09int i;
> > +=09struct page *page;
> > =20
> >  =09if (!kvm)
> >  =09=09return ERR_PTR(-ENOMEM);
> > @@ -705,6 +725,14 @@ static struct kvm *kvm_create_vm(unsigned long typ=
e)
> > =20
> >  =09BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> > =20
> > +=09page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
> > +=09if (!page) {
> > +=09=09r =3D -ENOMEM;
> > +=09=09goto out_err_alloc_page;
> > +=09}
> > +=09kvm->vm_run =3D page_address(page);
> > +=09BUILD_BUG_ON(sizeof(struct kvm_vm_run) > PAGE_SIZE);
> > +
> >  =09if (init_srcu_struct(&kvm->srcu))
> >  =09=09goto out_err_no_srcu;
> >  =09if (init_srcu_struct(&kvm->irq_srcu))
> > @@ -775,6 +803,9 @@ static struct kvm *kvm_create_vm(unsigned long type=
)
> >  out_err_no_irq_srcu:
> >  =09cleanup_srcu_struct(&kvm->srcu);
> >  out_err_no_srcu:
> > +=09free_page((unsigned long)page);
> > +=09kvm->vm_run =3D NULL;
>=20
> No need to nullify vm_run.

Ok.

>=20
> > +out_err_alloc_page:
> >  =09kvm_arch_free_vm(kvm);
> >  =09mmdrop(current->mm);
> >  =09return ERR_PTR(r);
> > @@ -800,6 +831,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >  =09int i;
> >  =09struct mm_struct *mm =3D kvm->mm;
> > =20
> > +=09if (kvm->dirty_ring_size) {
> > +=09=09kvm_dirty_ring_free(&kvm->vm_dirty_ring);
> > +=09}
>=20
> Unnecessary parantheses.

True.

Thanks,

>=20
> > +
> > +=09if (kvm->vm_run) {
> > +=09=09free_page((unsigned long)kvm->vm_run);
> > +=09=09kvm->vm_run =3D NULL;
> > +=09}
> > +
> >  =09kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
> >  =09kvm_destroy_vm_debugfs(kvm);
> >  =09kvm_arch_sync_events(kvm);
> > @@ -2301,7 +2341,7 @@ static void mark_page_dirty_in_slot(struct kvm *k=
vm,
> >  {
> >  =09if (memslot && memslot->dirty_bitmap) {
> >  =09=09unsigned long rel_gfn =3D gfn - memslot->base_gfn;
> > -
> > +=09=09mark_page_dirty_in_ring(kvm, vcpu, memslot, gfn);
> >  =09=09set_bit_le(rel_gfn, memslot->dirty_bitmap);
> >  =09}
> >  }
> > @@ -2649,6 +2689,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool =
yield_to_kernel_mode)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
>=20

--=20
Peter Xu

