Return-Path: <kvm+bounces-62009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61280C327FC
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 19:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE30418902F2
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 18:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DC633DEFA;
	Tue,  4 Nov 2025 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UR4+Tqi1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608C28751A
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762279353; cv=none; b=Vh/AHzgpUhPmbZHEf21BE20DVu3j6s5WjZKcWX8ory2E63DsQog3mJv66o8f++q0HQbd5oS+Cy6tWngZcSk6S2N5h6Fuyt+0Ct4tl3cYNiJIUNa2KmLGvSsmjgAvego+2LcfgcafRvTsZdAfJVOVwM28s8j2YX9OmIxYs5XYiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762279353; c=relaxed/simple;
	bh=OF+yEyqL038M/7cjkLTDiCOgvMsbpIL4Y8u0B391S+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VPY5BvrHpqYdzw62xcVneZ0yhxtKzkuy5yDAxfvORwY3iJXDYNglMlTXSVaP38VsP5jQqQt/xUvWLlD9OsiKyJGtephWba9MUbW2frUiVECsedy5mqy4JvpIGvgDsSF1P4Vzdqzc6rIqOCSaVVh4IJ2uRFSUF/IlEsaIWdPaXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UR4+Tqi1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b969f3f5c13so2856368a12.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 10:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762279351; x=1762884151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7TAMX5tgRxcaQgmnIz2dr5/J34h/wClq0GmkAjx/eU=;
        b=UR4+Tqi1L73FMojp9iVDZ+IQvopPBnewz3yrj2mrt7+uFNjZMEjoss+Y89vqlTc6g6
         1QkCZc49hnn3O7tD4S7+u05OBdO+fT/7uw3I/UwXMma9HKDA/6rCnl2wgj3kVJQZS417
         yoZ/RY+RRIFriCAwiiTn8qM5VemCllpOot/NyH5hPEz7pBGdGOsebyz/vUx8p2Gej/Jw
         sDFulLp3PJfS+bm/nMZfEN1zAMUKII06enHPIkGOLq1o/At6DNDteG6Tgax73nvNOvqr
         h+ESmxXJjVeyOzvG/eqKQHjmUmq9C59EmIZ0U+uD072Y8LJ6RmdSEurrbVCQ9PE1+2XT
         7crw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762279351; x=1762884151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7TAMX5tgRxcaQgmnIz2dr5/J34h/wClq0GmkAjx/eU=;
        b=buHquAVFgcEfoClP7W8qOYQnBwoku9LYlJoqZZNjRQexJcrO70aXTPa44XPMehRSof
         Sf9wQ+vho5ZQlyEUckeDNSTy3LG/Q1iMGmC28AB6oQV2lPdLuotYAi3Gz2Pd/m7B8Uhd
         8Wjnsn1b5QnMvoAutVqPE8GDZi4wF2DbK9S+OYgZBlcEvxHbqjUCFikpB6WjfKggWVBt
         JPLnHlykfFDd1h7qPCxSIe0wIJ8qwvJvrInf7u9K3u6aac1OdAw79NcG6uoVrKSRfTIi
         XQbaECofjwqlXDyfLUKWEcIp69n9kbysJabchjP8A3+6jDjpB8Zvm8lDrXVxF7VrMRNm
         rcIA==
X-Forwarded-Encrypted: i=1; AJvYcCUqVi6VwwKtgjYUwwBG9ZaYn1n0BlibUIaoyKpmUWTV2/WRTSkfPng6f62IlznMxbuMQfk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv/m8ik5eKp2t1Y0oZAh4R59HdiSb80vj48lQJVBkrUQ3f1mLy
	HVC+/NVxGCHB854mHWp7VT2TT2pNoV8NIei1RCIgxMS8Dp7WTUm3vNXK8Zck85lSpIOekH3gJX+
	ZrpLr4A==
X-Google-Smtp-Source: AGHT+IEToeihVC8rNRp4WXHuCXbja7cJV9DF8/gVM9lRFkFysIMA8abH+TqAL0waWRxDGRap6/agKlo3e+8=
X-Received: from pjbmv10.prod.google.com ([2002:a17:90b:198a:b0:340:d512:22dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d92:b0:32b:7222:7459
 with SMTP id adf61e73a8af0-34f8591c355mr151990637.34.1762279351036; Tue, 04
 Nov 2025 10:02:31 -0800 (PST)
Date: Tue, 4 Nov 2025 10:02:26 -0800
In-Reply-To: <31da959f-d004-4ae0-a6a7-d5d31b646b70@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com> <20251030200951.3402865-28-seanjc@google.com>
 <31da959f-d004-4ae0-a6a7-d5d31b646b70@linux.intel.com>
Message-ID: <aQo_spywQuek7fUi@google.com>
Subject: Re: [PATCH v4 27/28] KVM: TDX: Bug the VM if extending the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
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
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 04, 2025, Binbin Wu wrote:
> 
> 
> On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> > WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> > measurement should fail if and only if there is a KVM bug, or if the S-EPT
> > mapping is invalid.  Now that KVM makes all state transitions mutually
> > exclusive via tdx_vm_state_guard, it should be impossible for S-EPT
> > mappings to be removed between kvm_tdp_mmu_map_private_pfn() and
> > tdh_mr_extend().
> > 
> > Holding slots_lock prevents zaps due to memslot updates,
> > filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> > vcpu->mutex locks prevents updates from other vCPUs, kvm->lock prevents
> > VM-scoped ioctls from creating havoc (e.g. by creating new vCPUs), and all
> > usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT entries that
> > can be used for the initial image.
> > 
> > For kvm_zap_gfn_range(), the call from sev.c is obviously mutually
> > exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT so the same goes
> > for kvm_noncoherent_dma_assignment_start_or_stop(), and
> > __kvm_set_or_clear_apicv_inhibit() is blocked by virtue of holding all
> > VM and vCPU mutexes (and the APIC page has its own non-guest_memfd memslot
> 
> Nit:
> It sounds like TDX is using the memslot for the APIC page, but for a TD, the
> memslot for the APIC page is never initialized or used?

Oh!  Good point.  I'll tweak that snippet when applying.

