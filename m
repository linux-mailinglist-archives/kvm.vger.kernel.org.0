Return-Path: <kvm+bounces-13587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15150898D07
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 19:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E51A1C21CA9
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 17:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D5012D1ED;
	Thu,  4 Apr 2024 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHhhpv9A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C771BDC8
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712250630; cv=none; b=fxvmBmCriYpwGkx/38G8IyhSfhQeCPjfNSIOZslHNbN2fPPVdbx1YVEzDroubbVEpokrEqdMbsNE6ujNHIVltgRhWEM+xBkgMCFZhGMmmbrh1H48E+PGp2EZp4mXaGhx+O+J+VvAnpEoFDkjVD04BDofUlzfcM0dLBPebgYZLQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712250630; c=relaxed/simple;
	bh=x1mV6Asdbyk6MXGiOGkafVXcPu0WR/NTdzIgbd5Mxx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qaB8Ve2bWCfELh2loII7qwnW8SmNjFyCsMTrAgguUcjqXymub3x651p+cdmNAERU5Sqoye4GrcpDX34SqED+SGmrx87PnJszfTw6tD331yM9D4mb7Xu+XQH2PVjY3bOMgz6vpXA/A9fIPNHvHZQvKTJDltAxMYhvE77zmIFXMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHhhpv9A; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6eaf2e7a7a4so852798b3a.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 10:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712250628; x=1712855428; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sCYGJYoCCWmlbxATTiuo0TYVlf7iklFPBjPmL9dTFwA=;
        b=LHhhpv9A4DKntpnW/FAFwuZm88mFVUTanmvNQGLQ9Ld1A5ncfSm0nI+2s8tr4wuyZm
         eZpQJOt9sdGoPsrQ0hrsRIOS0irOhpLBfXqWQd1hghkFvhITi4PjQAlMTjVOPEx+A8FP
         AGryeglHbbeWW/ueMf1VkYrarsAZtMw7UjkF4ZLFCOs3QYjyykk+J980yiFSnM4KCXbn
         AsCdtM2m0HosAOeVjFGGwvnnjvlkvNpvafs9GaH770fsNEA8TNVlYbY+wG1ZvmWIjWWS
         uUBDScmkadlEcxOrramnqSPywY4U7FE+cF4IkPX9xcxP4l/SJpVknuOzuPBkYdhXLCmY
         gyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712250628; x=1712855428;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sCYGJYoCCWmlbxATTiuo0TYVlf7iklFPBjPmL9dTFwA=;
        b=goAsao7p17tZ46ZXAd5zYpGO2rTLJZGkKsTStmwN7Qi0elIEKHIKXBAlXD+ox7ZCAN
         +LNZBoO2PPbiSnUngmp1zjG7kAnBQ6mfRHyHACjs9BizRfb2hZ0bGCquvYmdPwWxRDe+
         klH1w4y7T/axaI1Jhk3+H3H97XdXygT9jecBz+aflOSdE2seYs1lQoPo2tZWc+041Ffg
         4xWW14zH0cSh0OPOZ2Gp/CvbjOt+oHnRpP2nbIyQzfVPocDnSHzoZd16kxHcj3A+wJC6
         0BDR+YGIDU8pBlj1jWAqFtWUKYMTzKLDMcqpLc+8BIpNLSCDFS9sx6Nbp19uBBWv8kwA
         3dxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKUSJ6roep0g6vVaDCXxaae32A7looU67JIM1+dzCnhHCLq42uqt654OhgVXyONXycgGBjboVDafi3NViPxaqyocNw
X-Gm-Message-State: AOJu0Yxahk5vvuqYMwhsohRnshKg2xni6b4uOUz0xDfy6378onYK3MOD
	SSsyyMQr6ZdXdxpdsP3KDZbXysOOh7CZT+mFsxajvw1Mk7bHuhkPbbAuCNrfZdjBlQcfsxEiBhG
	yAw==
X-Google-Smtp-Source: AGHT+IHhPvXoZh4vQ3K5t6fKHgJX6vWfBjCuaUMfTTZTVLeIjVZLQFOKqC8uEwoprG9xUVSn42La6K8/le4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1889:b0:6ec:f400:95a7 with SMTP id
 x9-20020a056a00188900b006ecf40095a7mr1349pfh.3.1712250628435; Thu, 04 Apr
 2024 10:10:28 -0700 (PDT)
Date: Thu, 4 Apr 2024 10:10:26 -0700
In-Reply-To: <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
Message-ID: <Zg7fAr7uYMiw_pc3@google.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2024, David Matlack wrote:
> On Tue, Apr 2, 2024 at 6:50=E2=80=AFPM maobibo <maobibo@loongson.cn> wrot=
e:
> > > This change eliminates dips in guest performance during live migratio=
n
> > > in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
> > > 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, wh=
ich
> > Frequently drop/reacquire mmu_lock will cause userspace migration
> > process issuing CLEAR ioctls to contend with 160 vCPU, migration speed
> > maybe become slower.
>=20
> In practice we have not found this to be the case. With this patch
> applied we see a significant improvement in guest workload throughput
> while userspace is issuing CLEAR ioctls without any change to the
> overall migration duration.

...

> In the case of this patch, there doesn't seem to be a trade-off. We
> see an improvement to vCPU performance without any regression in
> migration duration or other metrics.

For x86.  We need to keep in mind that not all architectures have x86's opt=
imization
around dirty logging faults, or around faults in general. E.g. LoongArch's =
(which
I assume is Bibo Mao's primary interest) kvm_map_page_fast() still acquires=
 mmu_lock.
And if the fault can't be handled in the fast path, KVM will actually acqui=
re
mmu_lock twice (mmu_lock is dropped after the fast-path, then reacquired af=
ter
the mmu_seq and fault-in pfn stuff).

So for x86, I think we can comfortably state that this change is a net posi=
tive
for all scenarios.  But for other architectures, that might not be the case=
.
I'm not saying this isn't a good change for other architectures, just that =
we
don't have relevant data to really know for sure.

Absent performance data for other architectures, which is likely going to b=
e
difficult/slow to get, it might make sense to have this be opt-in to start.=
  We
could even do it with minimal #ifdeffery, e.g. something like the below wou=
ld allow
x86 to do whatever locking it wants in kvm_arch_mmu_enable_log_dirty_pt_mas=
ked()
(I assume we want to give kvm_get_dirty_log_protect() similar treatment?).

I don't love the idea of adding more arch specific MMU behavior (going the =
wrong
direction), but it doesn't seem like an unreasonable approach in this case.

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 86d267db87bb..5eb1ce83f29d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -66,9 +66,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot=
, u64 offset, u64 mask)
        if (!memslot || (offset + __fls(mask)) >=3D memslot->npages)
                return;
=20
-       KVM_MMU_LOCK(kvm);
+       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
        kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask)=
;
-       KVM_MMU_UNLOCK(kvm);
+       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
 }
=20
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1fd9cb5d037..74ae844e4ed0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2279,7 +2279,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm,=
 struct kvm_dirty_log *log)
                dirty_bitmap_buffer =3D kvm_second_dirty_bitmap(memslot);
                memset(dirty_bitmap_buffer, 0, n);
=20
-               KVM_MMU_LOCK(kvm);
+               KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
                for (i =3D 0; i < n / sizeof(long); i++) {
                        unsigned long mask;
                        gfn_t offset;
@@ -2295,7 +2295,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm,=
 struct kvm_dirty_log *log)
                        kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslo=
t,
                                                                offset, mas=
k);
                }
-               KVM_MMU_UNLOCK(kvm);
+               KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
        }
=20
        if (flush)
@@ -2390,7 +2390,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kv=
m,
        if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
                return -EFAULT;
=20
-       KVM_MMU_LOCK(kvm);
+       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
        for (offset =3D log->first_page, i =3D offset / BITS_PER_LONG,
                 n =3D DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
             i++, offset +=3D BITS_PER_LONG) {
@@ -2413,7 +2413,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kv=
m,
                                                                offset, mas=
k);
                }
        }
-       KVM_MMU_UNLOCK(kvm);
+       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
=20
        if (flush)
                kvm_flush_remote_tlbs_memslot(kvm, memslot);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index ecefc7ec51af..39d8b809c303 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,6 +20,11 @@
 #define KVM_MMU_UNLOCK(kvm)            spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
=20
+#ifndef KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT
+#define KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT     KVM_MMU_LOCK
+#define KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT   KVM_MMU_UNLOCK
+#endif
+
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
                     bool *async, bool write_fault, bool *writable);
=20


