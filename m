Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C57734A0
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 01:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjHGXJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 19:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjHGXI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 19:08:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4709F30DC
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 16:07:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4ddbcbbaacso1240614276.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 16:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691449607; x=1692054407;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h7A5aUX2ecj7Bbl/7ce/OdAJyafyQZh2jovAmUQfIOU=;
        b=BwuvQdbCy2eUR+bp2NSDknEVbKVENYiDa6uZlyXUwJVmlF4iKp7HjX09JvbwikelLF
         rKNAwCIOjLOCd9hfp54t7rYGOQkDWMmLVeB7tC4wNPL/xp+tqM5HxKngfQKLrmiljVMH
         iSIS4pBQ45QD1qQyRXNJtH27IiaYgguvgYTqI/+bBLhU+TqFpp7Sutp2QK2jo2kiAyxG
         IG//K3Uxz4ck43yxOcKsJnHFISIoIpmEz14csW59Ae6FEeel85qKxKoUZusz6vFuY6is
         pXI++E1KnyDArrSs+pWezCptJywjGpfbd67K7HxwhlAzqazZgZUp2EXPv3WY6f0/mDR8
         iGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691449607; x=1692054407;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h7A5aUX2ecj7Bbl/7ce/OdAJyafyQZh2jovAmUQfIOU=;
        b=io/gbB7Fgv6Mk4eksWrxkBW7Wurd2HAnQvXiWWOwjJEBcG2WJB3hwxrX8q9Dw+Zgbv
         MBBvn5dyLCdwmj8wOuJ2FrOdZkPWxrnIWP8VFepF7vRQzNqDeV/D/usSt/TntoAfUVNW
         bLQRXCtfm/xUN92CxwfuSA4tezvN4aHHywwvHZi1m7VJBK8M36QP4ldnqtippA5DLtoG
         rVQuj22oIFwGpuGQ8FmzFTH1Aisjgjwg7pfJu3JcMlDPE7dwXc1uDZ9Y0MYi3+6Xml9V
         uPLPRb4FwXLjopxc/gEmHkUFk0rCa7RGRRg/+tmfi234WB9eZNchtII3msRdPuEyVEar
         /cbg==
X-Gm-Message-State: AOJu0YwAcM1w29HfyPo4Ijw5Jl+8rCVFsywZ2sKoAGY9uiSAQgjkOSYs
        HBgCJKzX7iXjXDBklf2TlCFaqmZMLQ0lroUKkw==
X-Google-Smtp-Source: AGHT+IGQixIKGybe4T+GVPibQ4+cbo9epXOA0dv0EjBAf7syaC6i5AoszZ6gyEUK9SdsuOsgoX+oe0ThmUR8eGJG6g==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:dbcf:0:b0:d01:60ec:d0e with SMTP
 id g198-20020a25dbcf000000b00d0160ec0d0emr68969ybf.9.1691449607047; Mon, 07
 Aug 2023 16:06:47 -0700 (PDT)
Date:   Mon, 07 Aug 2023 23:06:45 +0000
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com> (message from Sean
 Christopherson on Tue, 18 Jul 2023 16:44:55 -0700)
Mime-Version: 1.0
Message-ID: <diqzv8dq3116.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Ackerley Tng <ackerleytng@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, willy@infradead.org,
        akpm@linux-foundation.org, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, chao.p.peng@linux.intel.com,
        tabba@google.com, jarkko@kernel.org, yu.c.zhang@linux.intel.com,
        vannapurve@google.com, mail@maciej.szmigiero.name, vbabka@suse.cz,
        david@redhat.com, qperret@google.com, michael.roth@amd.com,
        wei.w.wang@intel.com, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

>   <snip>

> +static int kvm_gmem_release(struct inode *inode, struct file *file)
> +{
> +	struct kvm_gmem *gmem =3D file->private_data;
> +	struct kvm_memory_slot *slot;
> +	struct kvm *kvm =3D gmem->kvm;
> +	unsigned long index;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	/*
> +	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
> +	 * reference to the file and thus no new bindings can be created, but
> +	 * dereferencing the slot for existing bindings needs to be protected
> +	 * against memslot updates, specifically so that unbind doesn't race
> +	 * and free the memslot (kvm_gmem_get_file() will return NULL).
> +	 */
> +	mutex_lock(&kvm->slots_lock);
> +
> +	xa_for_each(&gmem->bindings, index, slot)
> +		rcu_assign_pointer(slot->gmem.file, NULL);
> +
> +	synchronize_rcu();
> +
> +	/*
> +	 * All in-flight operations are gone and new bindings can be created.
> +	 * Zap all SPTEs pointed at by this file.  Do not free the backing
> +	 * memory, as its lifetime is associated with the inode, not the file.
> +	 */
> +	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
> +	kvm_gmem_invalidate_end(gmem, 0, -1ul);
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	list_del(&gmem->entry);
> +
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	xa_destroy(&gmem->bindings);
> +	kfree(gmem);
> +
> +	kvm_put_kvm(kvm);
> +
> +	return 0;
> +}
> +

> <snip>

> +
> +int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		  unsigned int fd, loff_t offset)
> +{
> +	loff_t size =3D slot->npages << PAGE_SHIFT;
> +	unsigned long start, end, flags;
> +	struct kvm_gmem *gmem;
> +	struct inode *inode;
> +	struct file *file;
> +
> +	BUILD_BUG_ON(sizeof(gfn_t) !=3D sizeof(slot->gmem.pgoff));
> +
> +	file =3D fget(fd);
> +	if (!file)
> +		return -EINVAL;
> +
> +	if (file->f_op !=3D &kvm_gmem_fops)
> +		goto err;
> +
> +	gmem =3D file->private_data;
> +	if (gmem->kvm !=3D kvm)
> +		goto err;
> +
> +	inode =3D file_inode(file);
> +	flags =3D (unsigned long)inode->i_private;
> +
> +	/*
> +	 * For simplicity, require the offset into the file and the size of the
> +	 * memslot to be aligned to the largest possible page size used to back
> +	 * the file (same as the size of the file itself).
> +	 */
> +	if (!kvm_gmem_is_valid_size(offset, flags) ||
> +	    !kvm_gmem_is_valid_size(size, flags))
> +		goto err;
> +
> +	if (offset + size > i_size_read(inode))
> +		goto err;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	start =3D offset >> PAGE_SHIFT;
> +	end =3D start + slot->npages;
> +
> +	if (!xa_empty(&gmem->bindings) &&
> +	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
> +		filemap_invalidate_unlock(inode->i_mapping);
> +		goto err;
> +	}
> +
> +	/*
> +	 * No synchronize_rcu() needed, any in-flight readers are guaranteed to
> +	 * be see either a NULL file or this new file, no need for them to go
> +	 * away.
> +	 */
> +	rcu_assign_pointer(slot->gmem.file, file);
> +	slot->gmem.pgoff =3D start;
> +
> +	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	/*
> +	 * Drop the reference to the file, even on success.  The file pins KVM,
> +	 * not the other way 'round.  Active bindings are invalidated if the
> +	 * file is closed before memslots are destroyed.
> +	 */
> +	fput(file);
> +	return 0;
> +
> +err:
> +	fput(file);
> +	return -EINVAL;
> +}
> +

I=E2=80=99d like to propose an alternative to the refcounting approach betw=
een
the gmem file and associated kvm, where we think of KVM=E2=80=99s memslots =
as
users of the gmem file.

Instead of having the gmem file pin the VM (i.e. take a refcount on
kvm), we could let memslot take a refcount on the gmem file when the
memslots are configured.

Here=E2=80=99s a POC patch that flips the refcounting (and modified selftes=
ts in
the next commit):
https://github.com/googleprodkernel/linux-cc/commit/7f487b029b89b9f3e9b094a=
721bc0772f3c8c797

One side effect of having the gmem file pin the VM is that now the gmem
file becomes sort of a false handle on the VM:

+ Closing the file destroys the file pointers in the VM and invalidates
  the pointers
+ Keeping the file open keeps the VM around in the kernel even though
  the VM fd may already be closed.

I feel that memslots form a natural way of managing usage of the gmem
file. When a memslot is created, it is using the file; hence we take a
refcount on the gmem file, and as memslots are removed, we drop
refcounts on the gmem file.

The KVM pointer is shared among all the bindings in gmem=E2=80=99s xarray, =
and we can enforce that a gmem file is used only with one VM:

+ When binding a memslot to the file, if a kvm pointer exists, it must
  be the same kvm as the one in this binding
+ When the binding to the last memslot is removed from a file, NULL the
  kvm pointer.

When the VM is freed, KVM will iterate over all the memslots, removing
them one at a time and eventually NULLing the kvm pointer.

I believe the =E2=80=9CKVM=E2=80=99s memslots using the file=E2=80=9D appro=
ach is also simpler
because all accesses to the bindings xarray and kvm pointer can be
serialized using filemap_invalidate_lock(), and we are already using
this lock regardless of refcounting approach. This serialization means
we don=E2=80=99t need to use RCU on file/kvm pointers since accesses are al=
ready
serialized.

There=E2=80=99s also no need to specially clean up the associated KVM when =
the
file reference close, because by the time the .release() handler is
called, any file references held by memslots would have been dropped,
and so the bindings would have been removed, and the kvm pointer would
have been NULLed out.

The corollary to this approach is that at creation time, the file won=E2=80=
=99t
be associated with any kvm, and we can use a system ioctl instead of a
VM-specific ioctl as Fuad brought up [1] (Association with kvm before
the file is used with memslots is possible would mean more tracking so
that kvm can close associated files when it is closed.)

One reason for binding gmem files to a specific VM on creation is to
allow (in future) a primary VM to control permissions on the memory for
other files [2]. This permission control can still be enforced with the
=E2=80=9CKVM=E2=80=99s memslots using the file=E2=80=9D approach. The enfor=
cement rules will
just be delayed till the first binding between a VM and a gmem file.

Could binding gmem files not on creation, but at memslot configuration
time be sufficient and simpler?

[1] https://lore.kernel.org/lkml/CA+EHjTzP2fypgkJbRpSPrKaWytW7v8ANEifofMnQC=
kdvYaX6Eg@mail.gmail.com/
[2] https://lore.kernel.org/lkml/ZMKlo+Fe8n%2FeLQ82@google.com/

> <snip>
