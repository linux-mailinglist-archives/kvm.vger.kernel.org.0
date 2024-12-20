Return-Path: <kvm+bounces-34256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A410B9F98AA
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 18:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BD3516625B
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F6722E3F4;
	Fri, 20 Dec 2024 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IBBbVcRi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2942021D5AA
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 17:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734715899; cv=none; b=RFfESa2UWo4wPjCMDRj9u7HTQDmNwfuRjsO+k3Prg4YsXYUA8xJyJfMHTzxVvd3dpV31/aUD7Otx4OAHQB+6O8KGUTDfSxOpIs2fkmSOIL0IFsc+dmbvQdC4cqVYNwpfOvTG6pxJpJ1OatxnZXoiBLS2rzdk+/q39KgJjBd3WnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734715899; c=relaxed/simple;
	bh=y1oGFx+eDg9kZ5IMuBoG3ZGG20dZOVndvEoDVt31Ycs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SSH6k9WACujmj4tBQIjzHkAmhlHpkUF8lyg/4p7HkRgz/G9Zqy4gJYSXakeKDDc9rO5bMn+kE0JjlCAN+Wrp+b8+2FSLz/cHPjW4Q9G/1bV0zCrl3KRcNLIpPQos9lQmB4G0RvSRP4O52/rBnaFmxaRJFcBq4ALCYwWlSjV3bq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IBBbVcRi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725c882576aso2043941b3a.3
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 09:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734715897; x=1735320697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nsV0/Gxa57HKjHyGRzj7RAv/zM0LUbJ0KCm4V/ZCMo0=;
        b=IBBbVcRige3t7Wqxkw8Nvvi6FozlFE2OH+Zx5jZMzuiY0oPeaV4iXPcz52+dMG8ON6
         Eh/DAieXdyDJNVDr6TGjxZJFdzj65q5NnNSNyflD9Bg9nTgNYcmIA6DQUwM3Kl5ZAjAI
         YxdBMvaGVMCIHbNOQthy/CGcVGzTssy+sbwedS74J1nur7veQfZB6b8IOrAixXdgAGTc
         SvsbbNB+FbmVu+gfrWS9H12HWKEsz2Q/KHmE7v1bKjz4t4hazVl9GxGbtEIblArgmFBm
         1qkcTh+1kNuiLENW8Fe/afXVg+gnps+i9AQ89kh8E/aZe3sj1kKKlPrjUSG0CYyayhzj
         rrew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734715897; x=1735320697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nsV0/Gxa57HKjHyGRzj7RAv/zM0LUbJ0KCm4V/ZCMo0=;
        b=sAss1M/TCOsXhvLu7ggZytrgRBcChhrd3NlQX8UPIDQncUG4UBX+5WKdJS/F58UGIC
         HfYPZ14/JwjuqVthfBDUCxB+CsbLtwXfdKlif7LYzm8xQN7p6irhHgVwgNQDaBnqvgFB
         bhO8AFZJD4+g5qdyF0zftXb+axUUENvIOlbuQNTNYO8Fna1WtRkiDfArgVQAH+XmW2zs
         fWN0hM1ULSK841ArmsUkUrpX+pzrsrE0q5seThLAaHtDGeDeqnFjc6BC+VPFCQmr031K
         HCs/0CjT/f30jCIkO6Ypobw+WE+2w3UQo9zfrTLxLsgLQxa3pgR3ku4QwlkT8OeXqhyF
         WX/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4lHqKFz3GcTxAHC1B2KL0kapPiU8tzOUK9s5sdcjOxXccJx0CZQaLh6P+24VID+RLeNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVBM4TSetew8wTluJiSmYNm2Y+yaFXgjn9qCrnUMVoWemr/N8q
	1EFe07hYWMDqnGn/phEz7WKWfbytSGNhiEExNOm7IiLFE8fmkMgz8FbPBtXK9X8nf8uxAbpAZmL
	6lQ==
X-Google-Smtp-Source: AGHT+IEPj9ZIjaZC9FgIMIVaYOT4GEhUiRW0UzntN5wbVictxCKTNbFQ0wYzzRNqGoIuarstOSw6sINe6yM=
X-Received: from pfbbt17.prod.google.com ([2002:a05:6a00:4391:b0:725:8ee5:e458])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa2:b0:1e0:d1c3:97d1
 with SMTP id adf61e73a8af0-1e5e080294cmr6803966637.29.1734715897443; Fri, 20
 Dec 2024 09:31:37 -0800 (PST)
Date: Fri, 20 Dec 2024 09:31:35 -0800
In-Reply-To: <20241220082231.15884-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220082027.15851-1-yan.y.zhao@intel.com> <20241220082231.15884-1-yan.y.zhao@intel.com>
Message-ID: <Z2Wp9w2BUrhV2O_c@google.com>
Subject: Re: [PATCH 1/2] KVM: Do not reset dirty GFNs in a memslot not
 enabling dirty tracking
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, peterx@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 20, 2024, Yan Zhao wrote:
> Do not allow resetting dirty GFNs belonging to a memslot that does not
> enable dirty tracking.
> 
> vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
> dirtied entries in the dirty rings, userspace is responsible for
> harvesting/resetting the dirtied entries and calling the ioctl
> KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the
> dirty rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear
> the SPTEs' dirty bits or perform write protection of GFNs.
> 
> Although KVM does not set dirty entries for GFNs in a memslot that does not
> enable dirty tracking, it is still possible for userspace to specify that
> it has harvested a GFN belonging to such a memslot. When this happens, KVM
> will be asked to clear dirty bits or perform write protection for GFNs in a
> memslot that does not enable dirty tracking, which is not desired.
> 
> For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
> between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
> SPTE has no write bit while it is writable in the external SPTE in
> hardware). When kvm_dirty_log_manual_protect_and_init_set() is true and
> when huge pages are enabled in TDX, this could even lead to
> kvm_mmu_slot_gfn_write_protect() being called and the external SPTE being
> removed.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/dirty_ring.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index d14ffc7513ee..1ce5352ea596 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -66,7 +66,8 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>  
>  	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
>  
> -	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
> +	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
> +	    !kvm_slot_dirty_track_enabled(memslot))

Can you add a comment explaining that it's possible to try to update a memslot
that isn't being dirty-logged if userspace is misbehaving?  And specifically that
userspace can write arbitrary data into the ring.

