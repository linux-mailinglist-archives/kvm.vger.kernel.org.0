Return-Path: <kvm+bounces-35222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9431DA0A80D
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A34166F3B
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AEE81A23A0;
	Sun, 12 Jan 2025 09:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhGhgTsQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442962556E
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675738; cv=none; b=UsgKXlT8qUECvjG3RXLgnOxE+vdO+XUx1K/k+elRie897Jpp/0BRRv2lG5IUvgTY7ABauaWsWCQbBmlhAfvA5SvDjYaxp6LHc0u4T8efQYf1lvMJuVZ2ZLDhhd6B5FTFyE/nBSPjbU9bWYIRPqKTN3cr975yua+3XLhRgdZrQvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675738; c=relaxed/simple;
	bh=5LgN3kghoTo+6hcMs9ps9ijUlydUFsGCZ5ZnuL33xl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L+D8oaVQ8vQpHxXLH6gYRfwp11zX4zj6RV+ucgJP4EhDUi/dPpuAnSASwbuWQscHAO2KYTVTCmA3X4uimzl7YVCqyHvIiTZyba8KBbSlYc3SGTb+r5B9QQ7RdiuV++DN4YaDRMrRaqjGcIk7X7ZXaipvL29v1OfrQkzTP/9Skts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZhGhgTsQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LbPMvXWxkqoPEVecK8C7xcWKRlslEHctKLKomp3MgmA=;
	b=ZhGhgTsQf/NCg/wWvBkAQgDskH80c/bxe583983KSyCmraaYxVYtZChfM08xpCHeqflg19
	a+woe/WtLE/Qa2XUlu1RvBajlukbc7T75c2UlcRZzdNVxawj6uneeqQglyWljEHV7WGfod
	tYsvrERwK/7ffzLGVCA7zjlSaSd0M7k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-3MGBvIL1PWG0O1QG0MgRxw-1; Sun, 12 Jan 2025 04:55:32 -0500
X-MC-Unique: 3MGBvIL1PWG0O1QG0MgRxw-1
X-Mimecast-MFC-AGG-ID: 3MGBvIL1PWG0O1QG0MgRxw
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d3e4e09ae7so4802593a12.3
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675731; x=1737280531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbPMvXWxkqoPEVecK8C7xcWKRlslEHctKLKomp3MgmA=;
        b=DLGoe/1v9hzccwjckjNEX/Sgd7vUhyeMXcExs+tU7TbLgehyW0aZ2e3UCROTrHGFyN
         fQzHj1GqXWNtJyclg99pMSYLeOiFd+4OujArCzfL53JWfkzAJZnXKioglUwk4Vv7Ev5H
         LOR88VHDqzHpN+KPfVp5XOqfXWKIZWW8iBXSkFsM4TXagfGkS+zKFoXepvwWyUhsiFXh
         haiVYJPKgH0O5OFk8TaBFS+zgj5mMiEwSe3KPmSpWBMbXKGZuQd+hAJJ34eFlx8Ur05W
         GcYDmmsqNVvVwkTDBMqzhdNY6FVyW2QyPOtogufWfHvwrmpiCBzEslaC+ZE73/G7GpLf
         ohzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2Rbf6qL3ENPBB63Prrh8XaDl4nSQUxERxhxbgVrpKg2FLwO2AIHIAdwNC+39le4h0qEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZpZy7etzZzFceKwh6jLh1KLaVmB9lZEZ03CHM8c/P3rSGg5HV
	+etBDysxgBsERKYjinTwsUOVWJNcSuLP73yzkvagF4JlkxmwgdHHLIV/mHDYPe/+uZjgGehnQes
	5khMBPmqV5h/LrVPldqjFLsnnvmAN0bg7giu0KNrV00/NUT5o1Q==
X-Gm-Gg: ASbGnctv7PMCSXzAVpqmj7jakPh+y4k8e+OtnIH47JHCwNujaVtIH3dtCOVpyCQh1jc
	drDTB/vfl/MpadJkIDG/y+DORW9j3puGwxTQWSD33lAq503YCatVUXTNGn4On9s4iGFZfNx/Syg
	IKozJniPvfMbXgqiV+ijjAGIe+yNtJ4bD5qM5zb8jgI/TKg3sqL5D3EwxiaaQWXy4k2ZHbT45Wq
	x5JZ/8vLKhTxbIADgKPLOxqqOcynu+mXWfymyQB8CwTkVkBHhKGScu1r8w=
X-Received: by 2002:a05:6402:354c:b0:5d3:ba42:e9d6 with SMTP id 4fb4d7f45d1cf-5d972e14828mr16993857a12.17.1736675731154;
        Sun, 12 Jan 2025 01:55:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVLh0vGs9D36Q0IyXZ3HUQ2iOTSRSffuWayJjX6NDL6ISEn6UK/f5SUb1xvo4fnr5VPoS7bQ==
X-Received: by 2002:a05:6402:354c:b0:5d3:ba42:e9d6 with SMTP id 4fb4d7f45d1cf-5d972e14828mr16993834a12.17.1736675730719;
        Sun, 12 Jan 2025 01:55:30 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9903c3206sm3714091a12.46.2025.01.12.01.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:29 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH v2 0/5] KVM: e500: map readonly host pages for read, and cleanup
Date: Sun, 12 Jan 2025 10:55:22 +0100
Message-ID: <20250112095527.434998-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new __kvm_faultin_pfn() function is upset by the fact that e500
KVM ignores host page permissions - __kvm_faultin requires a "writable"
outgoing argument, but e500 KVM is passing NULL.

While a simple fix would be possible that simply allows writable to
be NULL, it is quite ugly to have e500 KVM ignore completely the host
permissions and map readonly host pages as guest-writable.  A more
complete fix is present in the second to fourth patches (the first is
an independent bugfix, Cc'd to stable).

The last one removes the VMA-based attempts at building huge shadow TLB
entries, in favor of using a PTE lookup similar to what is done for x86.
This special casing of VM_PFNMAP does not work well with remap_pfn_range()
as it assumes that VM_PFNMAP areas are contiguous.  Note that the same
incorrect logic is there in ARM's get_vma_page_shift() and RISC-V's
kvm_riscv_gstage_ioremap().

Fortunately, for e500 most of the code is already there; it just has to
be changed to compute the range from find_linux_pte()'s output rather
than find_vma().  The new code works for both VM_PFNMAP and hugetlb
mappings, so the latter is removed.

If this does not work out I'll go for something like
https://lore.kernel.org/kvm/Z3wnsQQ67GBf1Vsb@google.com/, but
with the helper in arch/powerpc/kvm/e500_mmu_host.c.

Patches 2-5 were tested by the reporter, Christian Zigotzky.  Since
the difference with v1 is minimal, I am going to send it to Linus
today.

Thanks,

Paolo

v1->v2: do not bother checking again that a memslot exists, instead
	add a fix to restore irqs even if !ptep


Paolo Bonzini (5):
  KVM: e500: always restore irqs
  KVM: e500: use shadow TLB entry as witness for writability
  KVM: e500: track host-writability of pages
  KVM: e500: map readonly host pages for read
  KVM: e500: perform hugepage check after looking up the PFN

 arch/powerpc/kvm/e500.h          |   2 +
 arch/powerpc/kvm/e500_mmu_host.c | 199 +++++++++++++------------------
 2 files changed, 85 insertions(+), 116 deletions(-)

-- 
2.47.1


