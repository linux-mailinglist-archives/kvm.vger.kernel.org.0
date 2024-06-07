Return-Path: <kvm+bounces-19064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1628FFF8A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 11:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77BE3283C59
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72BE15B0F2;
	Fri,  7 Jun 2024 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fKSq6X+X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C63A12E1C1
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 09:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717752694; cv=none; b=Gwhj1Hrjj36iCxjf83C5ZqMhywdreFkcEhXksYaL+8JaBcFq99lBGfTf13sEpaz9sbfH8ndF+wnpMQ4sefTSe8pmGLpXqQntq9t60wnZOAHVrKnI+4DyDsjVwDPXh+y5cuijImGOvsLyYDF0qq+iFW8RLex8Z1v0Ku+HqXrQswI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717752694; c=relaxed/simple;
	bh=AO1+wudjPdTqHb3LdpkB0AnTgP40Y3xa66MaIoTyz60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWkrgh3SD0aZKjbHuEks47lD2+Te4cbcYLd4dX1vkIwioCUoK9uayUYNvOJMVrpCBtI4W5CrC73jCHTcL6gjskQlCfAZ2Fe5w2C32G/PlLU8WkyyrbJy7Xhpp9vcaHrHXgnLf3oxPvh8m82PccJcC4r5OOQqvvuZeAgmGGWP2gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fKSq6X+X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717752690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=48cZggxqt9GoOhwUTSaRN9PwmINE7avK2UYxff+junQ=;
	b=fKSq6X+XavWYpjM5Zzy7T3Xri+QAUNKzXnm4WlUIaBT2UCs7actpeqhHBSKleUgwn4oaXw
	5fziOyVW/t3+bgQMeHWter/NVSnzvvYsYAVuag7MF/8rHWF3SsgNLHFf27DhUUjPTYrVTr
	LNPxBs0coeF4czghHd/Aa2yfd0cur28=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-Cz8raRO-MwmIPW01u_Iw3Q-1; Fri, 07 Jun 2024 05:31:29 -0400
X-MC-Unique: Cz8raRO-MwmIPW01u_Iw3Q-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52b91217fcfso1682521e87.3
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 02:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717752687; x=1718357487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=48cZggxqt9GoOhwUTSaRN9PwmINE7avK2UYxff+junQ=;
        b=ChlqZ93AifrIrOLogij5L0Az70OMmncDlhRg8TBeM/oMKwYxorrf6ND7VQKD2Bfbgd
         cUrhvKKGJYq4wKOsbdhzn+y0KUnu0/NYQtrQNyCldEdnc43hCDcG/wS+ICUx4I5HSX07
         QJmHPZb0lXRpH5c9HepCemigviyxa5akLkzv7IdFZ7t2S/1gbU1cKHqvtRQv00bg6lVi
         dKltESlQFEo3l3aYbxfmP9FNoiiloNW8atveH1TL/3D2l0oLGxjiydszcEZ5WiGGIYU9
         Ngr9ezxLjn4GaTGcXDNFjPOHp46W3E7xg0XhziErSyh5fPU26/7dhhfIflFu1HVAfubj
         qQsA==
X-Forwarded-Encrypted: i=1; AJvYcCXhHA/IQiQpv41ZGZ8SEW9L5MWraUNst56ZVzqY5fCBFNe+qtZSOxYcOQLTR32QKXVg2Wt91BOJP7uS8ug1pnc5WDyK
X-Gm-Message-State: AOJu0YyH18U+aWivryyEa45Cj90zYU47lRiKtpaXp4FR5iELcDjeQsy1
	wjWhfu+fBg3h3VRqdLNCtRPLNh84XzxdNVonPMkXfcpWx0aeTW/IL6pYCCI//gqwvquMxlVYToe
	sfuSW14MoaUp69lULeJB52RstYPl3xoovs03RXZ7rY7DxAJkElVxbFUGHC2zKxM7GrE+1sTTuJD
	/YhOEEv0lwA9GtlkUbkRxWjRKT/HC1cKd49eo=
X-Received: by 2002:a05:6512:3b12:b0:52b:bc04:cc6b with SMTP id 2adb3069b0e04-52bbc04cd38mr1153695e87.49.1717752687384;
        Fri, 07 Jun 2024 02:31:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwgkV5KL94DHBXCopgnHYWrbusUO1CAc2DfbpmyfQilXQ8eoXguVQ4FljBoCfQRnaib3zJEqKg9lt5XB/g32E=
X-Received: by 2002:a05:6512:3b12:b0:52b:bc04:cc6b with SMTP id
 2adb3069b0e04-52bbc04cd38mr1153676e87.49.1717752687013; Fri, 07 Jun 2024
 02:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-16-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-16-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 11:31:14 +0200
Message-ID: <CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> -                        int *root_level)
> +static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +                                 enum kvm_tdp_mmu_root_types root_type)
>  {
> -       struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
> +       struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, root_type);

I think this function should take the struct kvm_mmu_page * directly.

> +{
> +       *root_level = vcpu->arch.mmu->root_role.level;
> +
> +       return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, KVM_DIRECT_ROOTS);

Here you pass root_to_sp(vcpu->arch.mmu->root.hpa);

> +int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa,
> +                                    kvm_pfn_t *pfn)
> +{
> +       u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
> +       int leaf;
> +
> +       lockdep_assert_held(&vcpu->kvm->mmu_lock);
> +
> +       rcu_read_lock();
> +       leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, KVM_MIRROR_ROOTS);

and likewise here.

You might also consider using a kvm_mmu_root_info for the mirror root,
even though the pgd field is not used.

Then __kvm_tdp_mmu_get_walk() can take a struct kvm_mmu_root_info * instead.

kvm_tdp_mmu_get_walk_mirror_pfn() doesn't belong in this series, but
introducing __kvm_tdp_mmu_get_walk() can stay here.

Looking at the later patch, which uses
kvm_tdp_mmu_get_walk_mirror_pfn(), I think this function is a bit
overkill. I'll do a pre-review of the init_mem_region function,
especially the usage of kvm_gmem_populate:

+    slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+    if (!kvm_slot_can_be_private(slot) || !kvm_mem_is_private(kvm, gfn)) {
+        ret = -EFAULT;
+        goto out_put_page;
+    }

The slots_lock is taken, so checking kvm_slot_can_be_private is unnecessary.

Checking kvm_mem_is_private perhaps should also be done in
kvm_gmem_populate() itself. I'll send a patch.

+    read_lock(&kvm->mmu_lock);
+
+    ret = kvm_tdp_mmu_get_walk_mirror_pfn(vcpu, gpa, &mmu_pfn);
+    if (ret < 0)
+        goto out;
+    if (ret > PG_LEVEL_4K) {
+        ret = -EINVAL;
+        goto out;
+    }
+    if (mmu_pfn != pfn) {
+        ret = -EAGAIN;
+        goto out;
+    }

If you require pre-faulting, you don't need to return mmu_pfn and
things would be seriously wrong if the two didn't match, wouldn't
they? You are executing with the filemap_invalidate_lock() taken, and
therefore cannot race with kvm_gmem_punch_hole(). (Soapbox mode on:
this is the advantage of putting the locking/looping logic in common
code, kvm_gmem_populate() in this case).

Therefore, I think kvm_tdp_mmu_get_walk_mirror_pfn() can be replaced just with

int kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
{
  struct kvm *kvm = vcpu->kvm
  bool is_direct = !kvm_has_mirrored_tdp(...) || (gpa & kvm->arch.direct_mask);
  hpa_t root = is_direct ? ... : ...;

  lockdep_assert_held(&vcpu->kvm->mmu_lock);
  rcu_read_lock();
  leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
  rcu_read_unlock();
  if (leaf < 0)
    return false;

  spte = sptes[leaf];
  return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
}
EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);

+    while (region.nr_pages) {
+        if (signal_pending(current)) {
+            ret = -EINTR;
+            break;
+        }

Checking signal_pending() should be done in kvm_gmem_populate() -
again, I'll take care of that. The rest of the loop is not necessary -
just call kvm_gmem_populate() with the whole range and enjoy. You get
a nice API that is consistent with the intended KVM_PREFAULT_MEMORY
ioctl, because kvm_gmem_populate() returns the number of pages it has
processed and you can use that to massage and copy back the struct
kvm_tdx_init_mem_region.

+        arg = (struct tdx_gmem_post_populate_arg) {
+            .vcpu = vcpu,
+            .flags = cmd->flags,
+        };
+        gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
+                         u64_to_user_ptr(region.source_addr),
+                         1, tdx_gmem_post_populate, &arg);

Paolo


