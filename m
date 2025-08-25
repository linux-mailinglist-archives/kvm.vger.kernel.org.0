Return-Path: <kvm+bounces-55675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A49B34C48
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 171363BF174
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 20:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C65629993A;
	Mon, 25 Aug 2025 20:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R0zPakmW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D4A28B7CC
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154567; cv=none; b=eex5M9g+lGsalqMmO68f2ekPQ+luKY9QmYKfpAHX6XCVDoO/JY5xR9oxfsN5+2lOj6T6uzeSJLOOSo0ZbveFzLYmhOjKvv9DngBYOVx6d7lw3B9FsuXYEOAIBRwOCeBonht7RazG8muSkwj2rnpJsnaKEe76VQmacaMXEwVifzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154567; c=relaxed/simple;
	bh=XMa1j4FdMALHD0hf0wfEKQnDwESr8sg2LTJHccbCsmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cOklxGr+1JCAQYj4o0yOeptOW9HzOV1dpIHuY3snH076GehbrQZ0wbP95xzlEDDoEK73Y+QpOSy8SO/Mu8ytOdtsTMce3nn/X3nPjwhWyq4QOzJKYiCkt0KAamRXhwKtjFEoO8TF3s7JvOPysi+Y7kdY587oDVU5WwTn4S1GoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R0zPakmW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32515ec1faeso3408077a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 13:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756154565; x=1756759365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=56UPUwX1rhvBWEK2XIxfwcL0cy2jj3AnLwxGUdvXCzY=;
        b=R0zPakmWyBB+pHPf/KWhseKXp+1fF9DZS/YD1Di2Xm14W22H1mm09zJntznciYLJLm
         nvW4Dhf6E4B/LGtQy9JT0cy4vcvN0PIsYUg1KndD3Mni32wa9EYThZ4A7NlBJQ8lRzIU
         AwQz4Jr95/dTn0+q+j32GP1qXExORRKfOBKBLYjuFlZXaITa2iTGxGDFFo07iIauUi9f
         DSQGSACMOChm6a8PUgYAx75TnjiyDBa7ZDUsGkWG628kwA/1YLOGBW8HlBsTuC5iz+9e
         I3y1uTwXLRoUcmGrdwedX3EdkIQjWVrovctN5Ka/ZdP9kFwVgh2mxuo5yGtAZEzxCcpg
         LreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756154565; x=1756759365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56UPUwX1rhvBWEK2XIxfwcL0cy2jj3AnLwxGUdvXCzY=;
        b=jL7KE8KzwXbuyKChGFbvFWgVaEu1ZLfaupivNmSp1h/4ERJ8VnwVq6Q2twT50mGrjY
         chUXSHCRl686+LO7lRXJrVRp5rrJ2811Ge3khAAqGxubNWWjzh29uyv6wekKDSR/lUtu
         G56iRt2NjYR4HMFuIMS0FcjczmPyFWv72WIwKU+rKXtGRNG808jv+6yRPFOMqJjCtccB
         ycBPz2IMgaZK6MvzPDngcCZO5NVuAQjTP5Tr1OKTs52wPWwVgD6YdP/BjpMHQAIdgGFz
         dDnTfxCj209Qeepqh35BFq7WTk13ZV7Fnn6Yu18maLCY3SRtvMxK6IeDKXKnAvDngCoP
         FnpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUExfhiBGiq8Yfw4PgurVOxi7DOxO4LqGuFhxTytWud/EXnDpO5LJtCCr2GeAV6AMJk2M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7YlAdWhu54BAXUF2CAhKrkyFrSxCJeNqAbCEWm4E0V765ktbx
	x5/a769H5CpA3SSk4muhZFgDUcz5QF59qzXyhZGgBO8Po/c44wsRGbbPVtqDJIe7QWYis8j+lIc
	KY1P8ww==
X-Google-Smtp-Source: AGHT+IFE68eL9cCsnSsmh+IHzY3LK4YmEJGjRX2EKzAva69U2rx47Leg3XgcP7SQvqX0sM+qrYaZI/PA1lQ=
X-Received: from pjf15.prod.google.com ([2002:a17:90b:3f0f:b0:31e:fac4:4723])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b4b:b0:325:6598:30fb
 with SMTP id 98e67ed59e1d1-32565983489mr10055495a91.29.1756154565125; Mon, 25
 Aug 2025 13:42:45 -0700 (PDT)
Date: Mon, 25 Aug 2025 13:42:43 -0700
In-Reply-To: <20250822080203.27247-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822080100.27218-1-yan.y.zhao@intel.com> <20250822080203.27247-1-yan.y.zhao@intel.com>
Message-ID: <aKzKw70r5bRnv0FC@google.com>
Subject: Re: [PATCH v3 1/3] KVM: Do not reset dirty GFNs in a memslot not
 enabling dirty tracking
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, peterx@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Yan Zhao wrote:
> Do not allow resetting dirty GFNs in memslots that do not enable dirty
> tracking.
> 
> vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
> dirtied entries in the dirty rings, userspace is responsible for
> harvesting/resetting these entries and calling the ioctl
> KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the dirty
> rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear the
> SPTEs' dirty bits or perform write protection of the GFNs.
> 
> Although KVM does not set dirty entries for GFNs in a memslot that does not
> enable dirty tracking, userspace can write arbitrary data into the dirty
> ring. This makes it possible for misbehaving userspace to specify that it
> has harvested a GFN from such a memslot. When this happens, KVM will be
> asked to clear dirty bits or perform write protection for GFNs in a memslot
> that does not enable dirty tracking, which is undesirable.
> 
> For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
> between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
> SPTE has no write bit while the external SPTE is writable). When
> kvm_dirty_log_manual_protect_and_init_set() is true and huge pages are
> enabled in TDX, this could even lead to kvm_mmu_slot_gfn_write_protect()
> being called and trigger KVM_BUG_ON() due to permission reduction changes
> in the huge mirror SPTEs.
> 

Sounds like this needs a Fixes and Cc: stable?

> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/dirty_ring.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 02bc6b00d76c..b38b4b7d7667 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -63,7 +63,13 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>  
>  	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
>  
> -	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
> +	/*
> +	 * Userspace can write arbitrary data into the dirty ring, making it
> +	 * possible for misbehaving userspace to try to reset an out-of-memslot
> +	 * GFN or a GFN in a memslot that isn't being dirty-logged.
> +	 */
> +	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
> +	    !kvm_slot_dirty_track_enabled(memslot))

Maybe check for dirty tracking being enabled before checking the range?  Purely
because checking if _any_  gfn can be recorded seems like something that should
be checked before a specific gfn can be recorded.  I.e.

	if (!memslot || !kvm_slot_dirty_track_enabled(memslot) ||
	    (offset + __fls(mask)) >= memslot->npages)
	    
>  		return;
>  
>  	KVM_MMU_LOCK(kvm);
> -- 
> 2.43.2
> 

