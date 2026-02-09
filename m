Return-Path: <kvm+bounces-70629-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DWEEPgdimmtHAAAu9opvQ
	(envelope-from <kvm+bounces-70629-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:48:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A46311334D
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 71DDB300BEAD
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7419830BB84;
	Mon,  9 Feb 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MI6sLJeg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQzi15hk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F85C25A645
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659205; cv=pass; b=Tnpa4XVB4+2DCeK4MlnAKNXKzC8crmwKAfBL88pRrO0ayMOIndnbG5cDJTMGuvUy0gfEdXQteA7rWBu1IT50XbNZi+hVqt24pMecQ359OumynDfuw/sPHGydmc5H/+QsDda0VnQ0I1oXWWKntKkPPhXZS4Qc6Pr7tuFqcVi/Obg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659205; c=relaxed/simple;
	bh=/9FE+ch0iXfAMxCW30kIbpBY4+RlVHUswUXEHkKAUsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LroCfdQ6mn010PyKcr3iaoxdF4zOu2W4dwDjLeWEkWc2GZT6fWIOMd1qMCPAIY0ARhlky9QoRYAGKPQ/1tko/hrdAX0tZDQJ1OOOE42uBUpi8XjlBC3HGfvDbYkQevnFAndxPzf0gMyb1bfy2KUt63hYW+4V8iY7NDlMkHwAgDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MI6sLJeg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQzi15hk; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770659204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vdx9d1qhwJkSi2147GnmvcercNVC9K1bDCNsM7Zsv8=;
	b=MI6sLJegMKjWRtA5zGzy1rzfZKKfsr10IgrkavM0RdYAxsA4cGTwygu9cDgRcRlVB+IEPx
	ahVV3Q34DAluvBJ2o8/l5ihUSZNEbBAWpzjz8/JKSTdi/hGfe/DyMiHy7lVCDTFV7UXgQV
	Pw9ynQbX5S2Pt5wzQJzsBsqX6z5YvLQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-1wQ_pusVMB6jz11SWD9NPA-1; Mon, 09 Feb 2026 12:46:43 -0500
X-MC-Unique: 1wQ_pusVMB6jz11SWD9NPA-1
X-Mimecast-MFC-AGG-ID: 1wQ_pusVMB6jz11SWD9NPA_1770659202
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4376ecafb7fso667030f8f.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:46:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770659202; cv=none;
        d=google.com; s=arc-20240605;
        b=B1sAoVB6mVY/a/vlbi7r6r7ci3gg4ZOoxnHFGiboe8tMcj2K6ronfN6ebG5baE7nvG
         MRyIkOSMfmhHEZvlWCTRZ97Y1II7529lqYtJUck4KPoskpqKeXMm4I/wvqMzU84QiJl/
         IVguhp4x8RDdrkHUBLfx16ow6gYcGM0qNn9D3FHRlo8b+jDmbTs7jQyj4v1ZfO0ODVlp
         Tdvc+XzydD+f4GEzdjiKJ2pkSbxIvjCFc+ErXQdITTWzGVwvoat30W3IoycRlG6RXrSG
         Ck+jQi2j8puNLKmfK8jPe68t9Mv0JULv7/S4vTMVBMZ0SZAhyp90l31egHPTS/8x1c5W
         M3nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6vdx9d1qhwJkSi2147GnmvcercNVC9K1bDCNsM7Zsv8=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=UW/pDrK0IIkYEKhah1r+dsigwvlDtLBFiUnCBNJDnpWRd4Y3EXoqxQh4K8+iHoZhiq
         JBiOVuJ+1GAtAtPrXGHkyQzlSyS24/hpc27XQpGu25EG1DN+YIbuAqDogFPSKOTgc3pD
         PuwWBQ+f4SH1VhUHCL6Ts6ycQcaVye/kl2p+DAQYhdR0Y+KsV8WJwLx35hhKPN7MAJjo
         q1fRIDKyGl5rFzdjUxjYiGTNujtKbSydAQXi1pfi5mVMw/hMrTeSY3UGEWe+JtzTrajN
         GQGgjrM7GHdNinJv9sz6vyNNNiCA9VPl6p5CXKeGL6SB0shDqsBjkDlhggftAdvwHm5y
         yLmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770659202; x=1771264002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vdx9d1qhwJkSi2147GnmvcercNVC9K1bDCNsM7Zsv8=;
        b=DQzi15hkD82+rz1QH8PdY5o4ftICBaVmEwRho5L8fZ1yYw1qXF0M1IOiJeV7FegXNq
         VAvZ8SLWLKW4etFkTgPg7KXFrFdmpHO2jTmYekQKuCFSiEtrGi5Cjv5R6JKelo/1jhVG
         o/cnOfPr0x0m9TM2NoqNFqo65zdm4vlE8IvOTTl9SUD6UUyABFnPqfxa/dhU48hTH1ea
         0ifB7AYJMsMkxcKQPiwFXOynyUabA+s8pL7DAvJDpmbFV2sSHnEGl0odGEl7MrakhgMa
         Hsxt0PcGMU6YHVNmoH0uXpPVQRY//sfjRvH/Vx0OAsT1l/7V+Pejq4Hr68UQUrmYP/cI
         Aaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659202; x=1771264002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6vdx9d1qhwJkSi2147GnmvcercNVC9K1bDCNsM7Zsv8=;
        b=SH0cLSKvQFUvt5q53qi++lzUiT5iDAk4TaQe3KzVEDJLkEFlSxOjBkQPDg7ESzBgO2
         BIV1uIcZb9Wl0KhCnO5oMX5V8btpCOPsxvK7VsCvT5nEkU0iP3moPQqTCRJXKDVL+Naz
         /iOa85dWbVto3jcwT2OIvyUiopfdVdp5fTdg4LmsgTma7Sel8SeXsb3fHN+KGLqXul6w
         ZLpQOWJGDYfAeAum0ugErX3i+b7fo9RqwoyjIo5DQlGJ2OJ6LLHyHKuKD7n+z6TYnYgb
         35zBxa+DNk1cNX75VHA/0mn2bsHY8w1VhFmWTho0stDcfZkAxu0B4y6EXCM8aAF5/vol
         +bYw==
X-Gm-Message-State: AOJu0YwsZW2cOZ9df3cU06w0vm10fZgX58R7BdVeGjfvp9jDjtNt2pD2
	wFT8QcR4ZKEDkKItTNNInF/cQ4quxqSXAi3UAn3Jfga09VTtyOygI/6gGgX8pyQmJcSgmslJSKt
	C/HZJOnIPpC+0DoxEkYvCGGNJsvbC7j1ojcXswUMHbmiVEcncXuv773yeadGV2rqTwH1upM38Wn
	tbt6UptFLSO5kX1S7NlC8NHpwlzuF5
X-Gm-Gg: AZuq6aJcKOu0Ylwg6zrIqyaR8AwpXGb0wp7t4gLU9rwQnMi14DH/CzAK9OnsEv699Xy
	9DVSm7ZvwyzxZnDG4+FwYp63+DdTDShEpfkmT3I6LVw5NQ9r87xfkl+wqcz+jevxDDselbG/+ak
	gb1OCbNrUHRDcT7eJetp3+COqtNmWqOLy/nlb/qrMkMJhAuS9vjehw4oKKa7BWWwXtpsqUJjNew
	Ice9K1RK98lHJU593VDQWRFZ0e6JYMCFU0fKu9bb826XD4vWoSS2zVEdRnY/ULDxjaK9A==
X-Received: by 2002:a05:600c:828e:b0:477:abea:9028 with SMTP id 5b1f17b1804b1-483201dadc1mr195482015e9.6.1770659201952;
        Mon, 09 Feb 2026 09:46:41 -0800 (PST)
X-Received: by 2002:a05:600c:828e:b0:477:abea:9028 with SMTP id
 5b1f17b1804b1-483201dadc1mr195481665e9.6.1770659201447; Mon, 09 Feb 2026
 09:46:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-7-seanjc@google.com>
In-Reply-To: <20260207041011.913471-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:46:29 +0100
X-Gm-Features: AZwV_QhEudIBl4I5MJt00RtC5_OXQEFZU-dqmfikeTTySwVC0q6gFcsuwOPI668
Message-ID: <CABgObfZRt+QbaBRuWxdhf800YqSxwFpwk0Z+CxiFfnDFEVyjQQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: selftests changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70629-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 7A46311334D
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Stub in stage-2 MMU support in the core infrastructure, and extend x86's =
MMU
> infrastructure to support EPT and NPT.  As noted in the cover letter, thi=
s
> conflicts with some RISC-V changes.
>
> The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85=
eb:
>
>   Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.20
>
> for you to fetch changes up to a91cc48246605af9aeef1edd32232976d74d9502:
>
>   KVM: selftests: Test READ=3D>WRITE dirty logging behavior for shadow MM=
U (2026-01-16 07:48:54 -0800)
>
> ----------------------------------------------------------------
> KVM selftests changes for 6.20
>
>  - Add a regression test for TPR<=3D>CR8 synchronization and IRQ masking.
>
>  - Overhaul selftest's MMU infrastructure to genericize stage-2 MMU suppo=
rt,
>    and extend x86's infrastructure to support EPT and NPT (for L2 guests)=
.
>
>  - Extend several nested VMX tests to also cover nested SVM.
>
>  - Add a selftest for nested VMLOAD/VMSAVE.
>
>  - Rework the nested dirty log test, originally added as a regression tes=
t for
>    PML where KVM logged L2 GPAs instead of L1 GPAs, to improve test cover=
age
>    and to hopefully make the test easier to understand and maintain.

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> MJ Pooladkhay (1):
>       KVM: selftests: Fix sign extension bug in get_desc64_base()
>
> Maciej S. Szmigiero (1):
>       KVM: selftests: Test TPR / CR8 sync and interrupt masking
>
> Sean Christopherson (7):
>       KVM: selftests: Add "struct kvm_mmu" to track a given MMU instance
>       KVM: selftests: Plumb "struct kvm_mmu" into x86's MMU APIs
>       KVM: selftests: Add a "struct kvm_mmu_arch arch" member to kvm_mmu
>       KVM: selftests: Add a stage-2 MMU instance to kvm_vm
>       KVM: selftests: Move TDP mapping functions outside of vmx.c
>       KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
>       KVM: selftests: Test READ=3D>WRITE dirty logging behavior for shado=
w MMU
>
> Yosry Ahmed (16):
>       KVM: selftests: Make __vm_get_page_table_entry() static
>       KVM: selftests: Stop passing a memslot to nested_map_memslot()
>       KVM: selftests: Rename nested TDP mapping functions
>       KVM: selftests: Kill eptPageTablePointer
>       KVM: selftests: Stop setting A/D bits when creating EPT PTEs
>       KVM: selftests: Move PTE bitmasks to kvm_mmu
>       KVM: selftests: Use a TDP MMU to share EPT page tables between vCPU=
s
>       KVM: selftests: Stop passing VMX metadata to TDP mapping functions
>       KVM: selftests: Reuse virt mapping functions for nested EPTs
>       KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
>       KVM: selftests: Add support for nested NPTs
>       KVM: selftests: Set the user bit on nested NPT PTEs
>       KVM: selftests: Extend vmx_dirty_log_test to cover SVM
>       KVM: selftests: Extend memstress to run on nested SVM
>       KVM: selftests: Slightly simplify memstress_setup_nested()
>       KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE
>
>  tools/testing/selftests/kvm/Makefile.kvm           |   4 +-
>  .../selftests/kvm/include/arm64/kvm_util_arch.h    |   2 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |  18 +-
>  .../kvm/include/loongarch/kvm_util_arch.h          |   1 +
>  .../selftests/kvm/include/riscv/kvm_util_arch.h    |   1 +
>  .../selftests/kvm/include/s390/kvm_util_arch.h     |   1 +
>  tools/testing/selftests/kvm/include/x86/apic.h     |   3 +
>  .../selftests/kvm/include/x86/kvm_util_arch.h      |  22 ++
>  .../testing/selftests/kvm/include/x86/processor.h  |  65 +++--
>  tools/testing/selftests/kvm/include/x86/svm_util.h |   9 +
>  tools/testing/selftests/kvm/include/x86/vmx.h      |  16 +-
>  tools/testing/selftests/kvm/lib/arm64/processor.c  |  38 +--
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  28 +-
>  .../selftests/kvm/lib/loongarch/processor.c        |  28 +-
>  tools/testing/selftests/kvm/lib/riscv/processor.c  |  31 +--
>  tools/testing/selftests/kvm/lib/s390/processor.c   |  16 +-
>  tools/testing/selftests/kvm/lib/x86/memstress.c    |  65 +++--
>  tools/testing/selftests/kvm/lib/x86/processor.c    | 237 +++++++++++++--=
--
>  tools/testing/selftests/kvm/lib/x86/svm.c          |  27 ++
>  tools/testing/selftests/kvm/lib/x86/vmx.c          | 251 ++++-----------=
---
>  tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |   2 +-
>  .../selftests/kvm/x86/nested_dirty_log_test.c      | 293 +++++++++++++++=
++++++
>  .../selftests/kvm/x86/nested_vmsave_vmload_test.c  | 197 ++++++++++++++
>  .../kvm/x86/smaller_maxphyaddr_emulation_test.c    |   4 +-
>  .../testing/selftests/kvm/x86/vmx_dirty_log_test.c | 179 -------------
>  .../selftests/kvm/x86/vmx_nested_la57_state_test.c |   2 +-
>  tools/testing/selftests/kvm/x86/xapic_tpr_test.c   | 276 +++++++++++++++=
++++
>  27 files changed, 1244 insertions(+), 572 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86/nested_dirty_log_test=
.c
>  create mode 100644 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_=
test.c
>  delete mode 100644 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
>  create mode 100644 tools/testing/selftests/kvm/x86/xapic_tpr_test.c
>


