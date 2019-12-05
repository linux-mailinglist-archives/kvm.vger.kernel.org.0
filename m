Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117BC114866
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 21:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfLEUw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 15:52:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730698AbfLEUwX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 15:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575579141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ukau8nHk3JHNMsHMDpYVTT6ajOucLhi5cgZ3nD7v6Ag=;
        b=ES4/8iVUCWgqNbZ3zdnS1bTEMmJ9GymIfZ52OaPm9HSqfyjtkuiDC1yDNZF+pPLnlskxLk
        yy0/IMjrjD+XE0ig0c7WhOMM73RXOmSjVHihu+a7n+QBJ+3bjrthLshLol8+nSXMrw1yVp
        bSCh/0uwqwIAZ2ACO9KeFUh/U3mxBgU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-IxN5jcLqPDm0hMqpV-L27w-1; Thu, 05 Dec 2019 15:52:20 -0500
Received: by mail-qk1-f199.google.com with SMTP id e23so2974566qka.23
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 12:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+nan0X2ZxcxaKRMWlP3Ng1dSFJVnawsAGkBfHhOudcw=;
        b=ISotVrDlCx79jPQxkYyF/KvLA3Le0U+7h+DuNFm89nF2Mhm8DfNFHpbU9LRENKzHzl
         xTDbHkj5DO9nHx5jLMdAMD3OOcukajZm1RhzxQtNfTW3K9yw1WIOhB+wq+420OI9EpBL
         XDXm2xdCXSDqhqLPObZfMKzVMM+xrm1yn/yNBNpxu54K4KPB9j512nFXX0pnjiYgHmEd
         YozXJxV8D3A5PfGnKQ0hgmiLbolfeRglEIiN0XuECFMjv6IgU/gRlU7YkjIXz3iREnZp
         tDhhTWUCue+ldg8aIOAg68APO2q3MKa6pS5Pi+1LyrF3RA42G4wcszb2OhueEpWl4A8k
         z3vA==
X-Gm-Message-State: APjAAAX2vr7I3Av/FdQD3pUadV8t/c434hjHieys+8IKSvRDHj0jgr0x
        NGtTc6bKpBI37HeocriJ8RwfscJauR2Gb99LlyCASCVZO2yxcT+Wpwm46NY9MyQxrxmPLj70FUX
        yxfSUSFYzmCCb
X-Received: by 2002:a05:620a:10ac:: with SMTP id h12mr10475169qkk.227.1575579140226;
        Thu, 05 Dec 2019 12:52:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzwyEX6v/GSs/j7WvTdEEwpF+JxmmUXueYjXIR7MhApFiRIOrMfcKVOm4kHBuLaw6T0im1WXw==
X-Received: by 2002:a05:620a:10ac:: with SMTP id h12mr10475152qkk.227.1575579139869;
        Thu, 05 Dec 2019 12:52:19 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id g62sm5287431qkd.25.2019.12.05.12.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 12:52:19 -0800 (PST)
Date:   Thu, 5 Dec 2019 15:52:18 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
Message-ID: <20191205205218.GB7201@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
 <20191202021337.GB18887@xz-x1>
 <b893745e-96c1-d8e4-85ec-9da257d0d44e@redhat.com>
 <20191205193055.GA7201@xz-x1>
 <60888f25-2299-2a04-68c2-6eca171a2a18@redhat.com>
MIME-Version: 1.0
In-Reply-To: <60888f25-2299-2a04-68c2-6eca171a2a18@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: IxN5jcLqPDm0hMqpV-L27w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 08:59:33PM +0100, Paolo Bonzini wrote:
> On 05/12/19 20:30, Peter Xu wrote:
> >> Try enabling kvmmmu tracepoints too, it will tell
> >> you more of the path that was taken while processing the EPT violation=
.
> >
> > These new tracepoints are extremely useful (which I didn't notice
> > before).
>=20
> Yes, they are!

(I forgot to say thanks for teaching me that! :)

>=20
> > So here's the final culprit...
> >=20
> > void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mas=
k)
> > {
> >         ...
> > =09spin_lock(&kvm->mmu_lock);
> > =09/* FIXME: we should use a single AND operation, but there is no
> > =09 * applicable atomic API.
> > =09 */
> > =09while (mask) {
> > =09=09clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
> > =09=09mask &=3D mask - 1;
> > =09}
> >=20
> > =09kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> > =09spin_unlock(&kvm->mmu_lock);
> > }
> >=20
> > The mask is cleared before reaching
> > kvm_arch_mmu_enable_log_dirty_pt_masked()..
>=20
> I'm not sure why that results in two vmexits?  (clearing before
> kvm_arch_mmu_enable_log_dirty_pt_masked is also what
> KVM_{GET,CLEAR}_DIRTY_LOG does).

Sorry my fault to be not clear on this.

The kvm_arch_mmu_enable_log_dirty_pt_masked() only explains why the
same page is not written again after the ring-full userspace exit
(which triggered the real dirty bit missing), and that's because the
write bit is not removed during KVM_RESET_DIRTY_RINGS so the next
vmenter will directly write to the previous page without vmexit.

The two vmexits is another story - I tracked it is retried because
mmu_notifier_seq has changed, hence it goes through this path:

=09if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
=09=09goto out_unlock;

It's because when try_async_pf(), we will do a writable page fault,
which probably triggers both the invalidate_range_end and change_pte
notifiers.  A reference trace when EPT enabled:

        kvm_mmu_notifier_change_pte+1
        __mmu_notifier_change_pte+82
        wp_page_copy+1907
        do_wp_page+478
        __handle_mm_fault+3395
        handle_mm_fault+196
        __get_user_pages+681
        get_user_pages_unlocked+172
        __gfn_to_pfn_memslot+290
        try_async_pf+141
        tdp_page_fault+326
        kvm_mmu_page_fault+115
        kvm_arch_vcpu_ioctl_run+2675
        kvm_vcpu_ioctl+536
        do_vfs_ioctl+1029
        ksys_ioctl+94
        __x64_sys_ioctl+22
        do_syscall_64+91

I'm not sure whether that's ideal, but it makes sense to me.

>=20
> > The funny thing is that I did have a few more patches to even skip
> > allocate the dirty_bitmap when dirty ring is enabled (hence in that
> > tree I removed this while loop too, so that has no such problem).
> > However I dropped those patches when I posted the RFC because I don't
> > think it's mature, and the selftest didn't complain about that
> > either..  Though, I do plan to redo that in v2 if you don't disagree.
> > The major question would be whether the dirty_bitmap could still be
> > for any use if dirty ring is enabled.
>=20
> Userspace may want a dirty bitmap in addition to a list (for example:
> list for migration, bitmap for framebuffer update), but it can also do a
> pass over the dirty rings in order to update an internal bitmap.
>=20
> So I think it make sense to make it either one or the other.

Ok, then I'll do.

Thanks,

--=20
Peter Xu

