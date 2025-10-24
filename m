Return-Path: <kvm+bounces-61039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF7DC076A0
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C88201C27305
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 16:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F6033C527;
	Fri, 24 Oct 2025 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hKhw31zy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22633A02D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325044; cv=none; b=L32wc+nmDwsrHH4Y5ODJj2UWaQKsuBVJ3b/V5Euko7nDukQdAlHX3xStL1RGR1niBokcxAAzpswqgvpVeIcsdM2fNkVWo1E/tlUNDPevGnxlxiIzwXXXXlJ3UwUf0hUvZDbFGxAy/sPeXcAXzS7v5nPhVK0+EOjFe81du9SjDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325044; c=relaxed/simple;
	bh=znxPntvSK0iLuvDlLrIc6oUoFoqXWddOvlpeLWfjD/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=APrPzk8PtUlf8j//O869PiNC5oeygFTvED1eoH5oYcYGNiPIg9OoF5l7wdbo/4wuifZblvZBXs476jvnkUPMLHW9X6gDy3r4FTsCIO+2tfbSCAR8dRK3fGB0jYufKz8D+Lx9BrNaJWf+TMgg4Zp38isROWq4CNWysdw6pk+DnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hKhw31zy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bcb779733so2075941a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 09:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761325041; x=1761929841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSFoTED+bN9czctrBnViFjaUxjZI+PzjY/BcjiPyhU=;
        b=hKhw31zyrAbgqsXNoWbtQ3K4Q5NQkmPMhTqiLcUwwNDWTKJgc/p527KT7Prdtijhlk
         TymHKg62C+q0vryN6ELJrmV1MP2MdGyLe3ofkLmyEVzmA3GXDV2/1FexHUwi9FWnxPRM
         jUXc+5FeS6BYh8J0t5QUU6QXpOoQRDFUkQNZpAsqr6oRoc4SF29INiz95pkFsS4lMVc+
         pL0fPLBRbihVQcw1voYIETiCGbacIIyy/xrAD8/U/kX4SER5Mm9+1CNC0Mkf4xYwTPtE
         GqsNbkanHvwbztdQ/5wIU86NIoZJzBlicVxqq3RF0mFJ5kHvx1oQJzkDXnUOm+aI37qi
         DeOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325041; x=1761929841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSFoTED+bN9czctrBnViFjaUxjZI+PzjY/BcjiPyhU=;
        b=wsk2LkAN61VsYJ7nw6kgZnCq1xq0mISNNOKxi6W2RIzfcDyoHFvRSJWO4Qr+0QgtFQ
         RMt3jLNdeUp8EWUEKlXOCMPyNOFJdUQegLyWDGNah+JPs3VKTA5JyPpdv43A35N89kgg
         LDlIJ203LQXWWP8dcvKsGFkTKkPYo75k7HFUrAh8E6rcc3q+0EMcN3sY9ZqOUWc45VB5
         R/DI7wGbUtys5eFf5YXVdcmRWffL5CqsoBxMx4yOcXDTGvUrQpG1s9knCzH7e2hMMw2E
         KsGLD+oo8iUPeTo9HoA4uyroW0t9IbA023nLDSQsu1ydv5wHhRu72Gc0N+vNvG6sHNUA
         /mAw==
X-Forwarded-Encrypted: i=1; AJvYcCV3HK/jM6Hb+7RNbqe8zK1aamBUk3P4dP7ZATW+hluTHWeYii5uwGU6aKrbnAYdZiY1cK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRlWqy7r28W9ZEAYjVKWgv87W/DeenWIVruUcgPVG3cRfctVLu
	BqT8BvCjkhj99Dw8j3fO7oPnHgeb6uVWcLwOFHkIRXUw83ntmiugizohJmwbck805YhoRcqt7iP
	zi4zDgg==
X-Google-Smtp-Source: AGHT+IHXmSeD3kNK6POSE1hGR7Jvio0RnirzUH7WSrLaKZ09lPaFZJIUb09S/aBT/hnx0ZxmJITFzdMKVRo=
X-Received: from pjnu4.prod.google.com ([2002:a17:90a:8904:b0:339:dc19:ae5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48c8:b0:33b:ba55:f5dd
 with SMTP id 98e67ed59e1d1-33bcf93ab88mr32766320a91.37.1761325041555; Fri, 24
 Oct 2025 09:57:21 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:57:20 -0700
In-Reply-To: <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-25-seanjc@google.com>
 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com>
Message-ID: <aPuv8F8iDp3SLb9q@google.com>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 24, 2025, Yan Zhao wrote:
> On Thu, Oct 16, 2025 at 05:32:42PM -0700, Sean Christopherson wrote:
> > Acquire kvm->lock, kvm->slots_lock, and all vcpu->mutex locks when
> > servicing ioctls that (a) transition the TD to a new state, i.e. when
> > doing INIT or FINALIZE or (b) are only valid if the TD is in a specific
> > state, i.e. when initializing a vCPU or memory region.  Acquiring "all"
> > the locks fixes several KVM_BUG_ON() situations where a SEAMCALL can fail
> > due to racing actions, e.g. if tdh_vp_create() contends with either
> > tdh_mr_extend() or tdh_mr_finalize().
> > 
> > For all intents and purposes, the paths in question are fully serialized,
> > i.e. there's no reason to try and allow anything remotely interesting to
> > happen.  Smack 'em with a big hammer instead of trying to be "nice".
> > 
> > Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to
> > prevent kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs
> slots_lock to prevent kvm_mmu_zap_memslot()?
> kvm_mmu_zap_all_fast() does not operate on the mirror root.

Oh, right.

> We may have missed a zap in the guest_memfd punch hole path:
> 
> The SEAMCALLs tdh_mem_range_block(), tdh_mem_track() tdh_mem_page_remove()
> in the guest_memfd punch hole path are only protected by the filemap invaliate
> lock and mmu_lock, so they could contend with v1 version of tdh_vp_init().
>
> (I'm writing a selftest to verify this, haven't been able to reproduce
> tdh_vp_init(v1) returning BUSY yet. However, this race condition should be
> theoretically possible.)
> 
> Resources              SHARED  users              EXCLUSIVE users
> ------------------------------------------------------------------------
> (1) TDR                tdh_mng_rdwr               tdh_mng_create
>                        tdh_vp_create              tdh_mng_add_cx
>                        tdh_vp_addcx               tdh_mng_init
>                        tdh_vp_init(v0)            tdh_mng_vpflushdone
>                        tdh_vp_enter               tdh_mng_key_config
>                        tdh_vp_flush               tdh_mng_key_freeid
>                        tdh_vp_rd_wr               tdh_mr_extend
>                        tdh_mem_sept_add           tdh_mr_finalize
>                        tdh_mem_sept_remove        tdh_vp_init(v1)
>                        tdh_mem_page_aug           tdh_mem_page_add
>                        tdh_mem_page_remove
>                        tdh_mem_range_block
>                        tdh_mem_track
>                        tdh_mem_range_unblock
>                        tdh_phymem_page_reclaim
> 
> Do you think we can acquire the mmu_lock for cmd KVM_TDX_INIT_VCPU?

Ugh, I'd rather not?  Refresh me, what's the story with "v1"?  Are we now on v2?
If this is effectively limited to deprecated TDX modules, my vote would be to
ignore the flaw and avoid even more complexity in KVM.

> > @@ -3155,12 +3198,13 @@ int tdx_vcpu_unlocked_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> >  	if (r)
> >  		return r;
> >  
> > +	CLASS(tdx_vm_state_guard, guard)(kvm);
> Should we move the guard to inside each cmd? Then there's no need to acquire the
> locks in the default cases. 

No, I don't think it's a good tradeoff.  We'd also need to move vcpu_{load,put}()
into the cmd helpers, and theoretically slowing down a bad ioctl invocation due
to taking extra locks is a complete non-issue.

