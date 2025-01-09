Return-Path: <kvm+bounces-34915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 518F2A07821
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2F393A78F7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D67122068E;
	Thu,  9 Jan 2025 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DNGP0CYY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9685921E0BE
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429906; cv=none; b=LACuvyGp8LGYqvGXi16SGGnAFSbhwvBpx1DXklFrca0uZ+77777EMsNFOnhtunojYl5DGDt0ReS0PwgJXckwYSmkLdYWX2Um9B9luRSh82zxA/CzPanyCrpqv37vBTfM1R2Syq5M5LT8IEGOMfyMndN41mQMXwc8ppV/ajML9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429906; c=relaxed/simple;
	bh=tj0EaTI4xDK9nr89rwD+fHqfvdYzjn0WO9cVa0FoTrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GUR52Z+sueK9MBeoLc1BroLCdRNmbu7GZPmviVIeeKwoCWlA8lwCXIGVzCrSnnsWGITJeDYKyYBmvMtIqJRmZNcII+hiNxpfVVReI4UA5Ty/Ti7eqE0KE8kRKbsyNO6+fK+XOVObb36ZGmf4bBQDgzLW8Cf3KfWWNbRhy4Fjsz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DNGP0CYY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uldQPwdfE7L9Dk1HaWI6s1M7Pg4/zwkf9XHa0qYWEsU=;
	b=DNGP0CYYKZfQVZ0z1Rej1SAUJC+K7bSaqMF9TJWDQg++woy8Vf1St60JRNYKfJTVGGgb0Y
	/A/Z1v6DN6Xrxy7XPvNhCZEozMBG2CS1ZFIfOL8+rv4srL3VVfj5aDZVisDggydPlT8qc+
	bW0QvOyX9AEC0zEYbF04WDthpZEmi4Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-KLEaowzUNqmQV6YAm45aJg-1; Thu, 09 Jan 2025 08:38:21 -0500
X-MC-Unique: KLEaowzUNqmQV6YAm45aJg-1
X-Mimecast-MFC-AGG-ID: KLEaowzUNqmQV6YAm45aJg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aaf9d0f4e0eso84049366b.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429900; x=1737034700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uldQPwdfE7L9Dk1HaWI6s1M7Pg4/zwkf9XHa0qYWEsU=;
        b=STn2y0BOlsEcUk5mLpvuMvqOCARv8iL6myZbOkFOAGrJB9ADNfmMp1UgiQA72PPICI
         xIOCwSfWd64UpG2UY8lSFu5oQ6lrJQGZ1DRdbBA8HXB9/pyUnbkoC50rlLiFn02sHytI
         UnUYclEQLX1x07CwUp0Lc+0z9Vojr0LCAf+SQ3QHXGVZURI+r1cRbl2lIiIpBYRxj34r
         Milx5pXL9Fy5/m3asM9LYyG1IToFAa47peEA1fXOg34cq4loQQtYT9NMTqzUWdkubYK2
         0JWbTyxNhrQRp7oFhysRHuYRui/nmXqawYmeTKyLxX29CH0z9hiIMSWm/hhnlx99o7RW
         AVFA==
X-Forwarded-Encrypted: i=1; AJvYcCUKdtBLVejdnI8k12ubNoIq4dE3RgWltTEbiibPvVisO86CG345jzIcobnvTrPzZ4vabfc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwJwUtyfgfMAz+HvbliFOm3YovEbbgCCJ4IlrxSejcj0+hzSrz
	C4Zz/TEteH9H9mhmFt2GnKHlbm44TpwODC76HQBU63XAgSBQLVSgnITblkurWiJgNB266a6xQv9
	wphkAweKTtleS4pZGnOS9EiM1ykLRYa8/jGCH4z8IaPjPUmtAAg==
X-Gm-Gg: ASbGncsoPGzb6DbWw3m38sTmwls0S8UY357ayUxo11pfGsZS1ITITNQ51i7wLLbF7CO
	0yfjIRGFUF8CUcDgol8Pzc1VKClQG+i6FhlfQ0MUeusDL8T0vNAT++t9JbIYitfwy3S9r9GJpnQ
	UxUM/X+L4Y3Ze/TO4EX6dYFWQBbf99hNCpcEeYX0/BNcnDobOhfgGiwRz0Sn/L/lYoKZuHC8gcl
	ZWz/sKaPO6uxDHx+bIGjvlDuGOzEdqDWnjpKjmev6vartbjtORTF90/ftBD
X-Received: by 2002:a17:907:36c8:b0:aa6:4494:e354 with SMTP id a640c23a62f3a-ab2abc92570mr698464866b.42.1736429900053;
        Thu, 09 Jan 2025 05:38:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGidjwN/yFK9ZauIimr2u7AiwN7b2XDO8B6ecoGAlxpK3GFkQSMXGdYvA9XVkfNkK6maNXm2Q==
X-Received: by 2002:a17:907:36c8:b0:aa6:4494:e354 with SMTP id a640c23a62f3a-ab2abc92570mr698462166b.42.1736429899595;
        Thu, 09 Jan 2025 05:38:19 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9904a5277sm591739a12.80.2025.01.09.05.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:19 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev
Subject: [PATCH 0/5] KVM: e500: map readonly host pages for read, and cleanup
Date: Thu,  9 Jan 2025 14:38:12 +0100
Message-ID: <20250109133817.314401-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[Oliver/Will/Anup/Andrew, you're Cc'd because of an observation below
 on VM_PFNMAP mappings. - Paolo]

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

The series is compile-tested only.  Christian, please test
this as we do not have e500 hardware readily availabe.

Thanks,

Paolo

Supersedes: <20250101064928.389504-1-pbonzini@redhat.com>

Paolo Bonzini (5):
  KVM: e500: retry if no memslot is found
  KVM: e500: use shadow TLB entry as witness for writability
  KVM: e500: track host-writability of pages
  KVM: e500: map readonly host pages for read
  KVM: e500: perform hugepage check after looking up the PFN

 arch/powerpc/kvm/e500.h          |   2 +
 arch/powerpc/kvm/e500_mmu_host.c | 202 +++++++++++++------------------
 2 files changed, 89 insertions(+), 115 deletions(-)

-- 
2.47.1


