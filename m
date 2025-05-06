Return-Path: <kvm+bounces-45667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F76CAAD1AF
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48CDD1BC36DC
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 23:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3369B21E08D;
	Tue,  6 May 2025 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Za8CfsZr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA19D217716
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746575284; cv=none; b=LSeT24gSrxzEHLq2kj8Zw9e7Y7K+tCp47bVm9YHC0mFyUBfuHNdKCdxtmp/t2jAFs/DuHRl25zkKhQEQ3hkdI+bd/A1xikQDoJy7A6HgVPFg9bWXmGeu1MFpmlhHTkSY+mmY4Gp9g4PQh8AVhmgm4zQQP94EXEJDwIPl94HxG4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746575284; c=relaxed/simple;
	bh=NzEAJGMGj67aqLOqPzD1WsJBqcysNCKrFhpDypZk/yY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bPdqlmPoWRFsHyF4Ev+F5cqMTElxq50yDTlDp9UQnJvDrL+t5TMG5gWrXuCry/d3L+qA883SDosJubpwrLpK+kT9vmw9eY5HWVHgc+BjLXk2aMBK/Tk5gpaNFKk8MCkDtlbg9e3wYTOWfHzReS0TSUNMMDDPxtdu8MU/Ul8Oe5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Za8CfsZr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so4869433a91.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 16:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746575282; x=1747180082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iGR21MUMyA/Iej7QErtZc8eyio+Dks1zWhBSbKI/rik=;
        b=Za8CfsZrFcgK0Rp4CNNAVfSUxYYEE/Wt7aMcL6js20F5xXUGr5JlQ1/RtrSJyNW4wc
         E/+4xYFvTt2AIWRXWXxPWCqybvqSNXvW5Agc36mshnx1p/jgcrP2S9vxTpr9Maa47J1E
         ybqmhw/+k8gHxNTGN6Hq5Lw0FIvgoghQ7EU9g2tpDTlK8biiq1rVwgidd10J2TRoBuws
         WRl1mQHkrTDNBwfuE1rT8cUYOy7viUZpobKKMXeri1IOO7VuNszR8Z4R9JKMvdiwSUd6
         61H2rPUOo3y/rw7xly5MqzS16a/ce81A2M2PrybpASUaMeF56dXGx6elQ1Wz4DpEncC/
         5Ang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746575282; x=1747180082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iGR21MUMyA/Iej7QErtZc8eyio+Dks1zWhBSbKI/rik=;
        b=GmqcgNf8yXWvBJJPPIzWB8gzswXtuTj/pVLw9GRHij7WaS5qI5iNI17ntOfJ7t0Hsd
         i8RBfJOrs+/C2RxdbL9Bz+K2RUDXd9Tk9Fdcv0l6gBFEM/mtcGqqfxlOSQcsusiE3Ew0
         mE8GtpsOFS9Dya/T/2hv3jAczk95PILHpm5DfBWqhKfZWgsp3JNN+IpMhABpaDGkTnqy
         lffxQ0xZfqw9rKZ4twJ7JGdYlyCx2js6KfII6z+myO138oAR4OxK2PK7JH3gg1uGHbKi
         ixBKE0OFvDmGv87jt65VeGbo24Q+F7jYFsMo9eri2hroPhSEk/DBLyAb9vn+8vuCpTsv
         gKkw==
X-Forwarded-Encrypted: i=1; AJvYcCWP9lsOGCsQulTvPtfy3oQB8ZWOTwiQKGiKdfAThbOkjPylRKvP8eA5C6EsdACEoNom7V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFG56ioJJ7iBGMIhXygsr3zC/md45MZ/If2UXR+eR1c4SGKrAZ
	UpMAoi+Y999CsAmzqYd1ZTT38uLU3iWfxtEHQLlHqg3MDm8BHsiS9lNuodY/OCiUd6Qtr0tDbIl
	Zxw==
X-Google-Smtp-Source: AGHT+IEI4VPbZHYscktwEOVP6g5TZOKepWU/P1YF6Ndm56diDY5BXYXdB3X0UtnsxrDOZgtWBFkyQyHQxS4=
X-Received: from pjbsr12.prod.google.com ([2002:a17:90b:4e8c:b0:30a:2095:204b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e84:b0:2ff:5357:1c7f
 with SMTP id 98e67ed59e1d1-30aac28b3bcmr1863522a91.30.1746575282052; Tue, 06
 May 2025 16:48:02 -0700 (PDT)
Date: Tue, 6 May 2025 16:48:00 -0700
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
Message-ID: <aBqfsGtUjBUJudFB@google.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> James Houghton (13):
>   KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
>   KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
>   KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
>   KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION

Starting with some series-wide feedback, the granularity of these first few
patches is too fine.  I normally like to split things up, but honestly, this is
such a small feature that I don't see much point in separating the uAPI from the
infrastructure.

To avoid cyclical dependencies between common KVM and arch code, we can do all
the prep, but not fully enable+advertise support on any architecture until all
targeted architectures are fully ready.

In other words, I think we should squish these into one patch, minus this bit at
the very end of the series (spoiler alert):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ce7bf5de6d72..0106d6d461a3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1545,6 +1545,9 @@ static int check_memory_region_flags(struct kvm *kvm,
            !(mem->flags & KVM_MEM_GUEST_MEMFD))
                valid_flags |= KVM_MEM_READONLY;
 
+       if (IS_ENABLED(CONFIG_KVM_GENERIC_PAGE_FAULT))
+               valid_flags |= KVM_MEM_USERFAULT;
+
        if (mem->flags & ~valid_flags)
                return -EINVAL;
 
@@ -4824,6 +4827,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
        case KVM_CAP_CHECK_EXTENSION_VM:
        case KVM_CAP_ENABLE_CAP_VM:
        case KVM_CAP_HALT_POLL:
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+       case KVM_CAP_USERFAULT:
+#endif
                return 1;
 #ifdef CONFIG_KVM_MMIO
        case KVM_CAP_COALESCED_MMIO:

