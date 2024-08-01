Return-Path: <kvm+bounces-22905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494D944756
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E76D1F22BBD
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19263170A2B;
	Thu,  1 Aug 2024 09:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CGb/7cF/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BE2170A20
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502898; cv=none; b=UkRsY0Xat/Vc20EPbyIMrHm1dkQkq48EIs0raNdVspeV7uRdpCYw213TjAQ3z39LmIdWRafuCAYcGBolwt/Wu5pJ2GKcBjG5wcZpDOdxui1CyuTWy3fVKlcJRu3ys5sOq5W/MFuUP8DZI0kuu0R3/eJfrT1rKj+m0GVL7jvvPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502898; c=relaxed/simple;
	bh=gVbQE1gLeXsrOsdMOUmedL1iM5Ce5pM5lcUiFJNejpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=awoHm/UghvaTNXL5GNGcbdGRkhmZ7Mqlkey3oYFpCwtBN82+PC76fmfItRZxzrix/70TdIoDJR5MrNMDNoC3/0fZ8ugxk+JpYRQ9CqUpOWwzclFP+KdeEbP72BKUjMwR79xhzm34LxaiDZsGHPQ/jEAkkOvOXdZaQrQuz0Pp6wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CGb/7cF/; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6688b5b40faso158305177b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502896; x=1723107696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eynVCV8vS5USu2ZyXSA4dI0KQ06/f9GaXl4H1mlHW7I=;
        b=CGb/7cF/Sp/oIa+K5WpVBd21yRlYADMNGrxiQt4umul/O3M0Cg3fFWPgnkjvaKDX3D
         18L5kEE1k/jgs5Erk3Jzb2KSjy8/8WJT97vtHydxTz7kb8Q5Ruwha2ucLviRVfiAWThF
         d2IeXmFGbtE3d0VsrMtAjwR+OBft6Zyek78x8F29ha5uHb+yeXPyqEL7cFEDj6UWq1em
         0eQlWf/QvyToKKdQpFR5F4kR1qa43oOsZE4XEw+58hv41GOaQxN3L0YFsW0CLiTJ+/V7
         Ui87djFxFgt+1riO90+Yjj3Us9l3l05RgwdbHOtPHx46HdX38+1nxU9W7zp7rC35skGR
         taAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502896; x=1723107696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eynVCV8vS5USu2ZyXSA4dI0KQ06/f9GaXl4H1mlHW7I=;
        b=Nic0NTqLzQKhG/ek39Q8ATO37SzWm1F7Vet06Z/4KlRSMVPRV51McKd7RFC3whIBll
         en83jjp9TGIBxlpb4giq5y76ZXBJIxE2PqRlaxGbsLwELDcZrk1dKX0BE4m18sOg6+Dy
         Rlt4cOsJGTiLDH3hvAYI/tWBp2Q52JEbgZpmHSCiSNhWOZl8YPVESvP4In2cGDeNbIGc
         WUMDr+OyrAJvrx810fCPv8YT+4srFK9qemOIEPjhC49PgGSxA6fY893IEreOX9ymXzKN
         F7IFM7YDlUwHWqjBtUG662rUonX9dMHfNtIyEjIbSq7ZgNLuxr+A7+xUIRiUmsyWQ/pN
         rL2w==
X-Gm-Message-State: AOJu0YxRWDnR3RS8KziLtZJchYXLl/HpZzuAsD4iWUeNduu08kgnBKLB
	I/1wLoOtnHq1k6O+uaq3Wr9E9IFzHb2VdrHyL4/Rl10Jxf+IMhGJtBAjs3dsp7IgyxlZGNRjUgW
	Md5WGpTEH9NfFyZC91tq91rtKaMpNLEsb3cLtEheH1Qe0dACoXNZbaOVMaeTn8GKRXSs7uy+M2W
	1ls9/27gn67ky+gYjZSdVVtLM=
X-Google-Smtp-Source: AGHT+IGMIr1XUVhclOFb55aW6DOFYObKwVO0wQH5tDUYBTBbgfFm+mNN9/WDhRbYaQh1Bw5e40TmTstGTw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2190:b0:e0b:bafe:a7ff with SMTP id
 3f1490d57ef6-e0bcd21d5e4mr2642276.6.1722502895329; Thu, 01 Aug 2024 02:01:35
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:13 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-7-tabba@google.com>
Subject: [RFC PATCH v2 06/10] KVM: arm64: Skip VMA checks for slots without
 userspace address
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Memory slots backed by guest memory might be created with no
intention of being mapped by the host. These are recognized by
not having a userspace address in the memory slot.

VMA checks are neither possible nor necessary for this kind of
slot, so skip them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8bcab0cc3fe9..e632e10ea395 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -948,6 +948,10 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	phys_addr_t size = PAGE_SIZE * memslot->npages;
 	hva_t reg_end = hva + size;
 
+	/* Host will not map this private memory without a userspace address. */
+	if (kvm_slot_can_be_private(memslot) && !hva)
+		return;
+
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we should
@@ -1976,6 +1980,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
+	/* Host will not map this private memory without a userspace address. */
+	if ((kvm_slot_can_be_private(new)) && !hva)
+		return 0;
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-- 
2.46.0.rc1.232.g9752f9e123-goog


