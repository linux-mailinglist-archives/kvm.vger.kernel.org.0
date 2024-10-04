Return-Path: <kvm+bounces-27991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F00D991017
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6A2D280F1D
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D59159565;
	Fri,  4 Oct 2024 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cpl+fLVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042342E83F
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728071746; cv=none; b=izOyKdxbpIQxloundfzMNrmGQwZVCMLomBFb6En2IIqDGlh1dbHt2IdWxa6Ac91uwxNu4ZWG6LLIqPDPKiyhPVWD+19myUGZSU8GSzsnhbsxWtFe8lU0L9bEEMWwiCDZPDziM3ffSVpVO0SxA80fBqjNfQB/fJJxtDPIOxE/FxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728071746; c=relaxed/simple;
	bh=L675uwV/wdI2N7e5DpiI+VU9aQpqGmG7U31X+RovOa8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oJm94dqE/LiKj9hArH7gfm1BVjVZLHs06gDcpZnF/JnjZJzJwn9hiih99HESNWSg6mg5me3FVl1dAwqBmN1QPsW/JS0zySShSk6Yv3aaLrJ6nu1m83r4QcA+okYiyr5DPgkRa31b35Z/cfSCcwIT8Zp3trgINjQyOM1ecDoIi8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cpl+fLVp; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e284982a31so44225887b3.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 12:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728071744; x=1728676544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IhEoclRr5enU/RPJ9yJtc7O8LWAGmPRjj/4eWIHOC28=;
        b=cpl+fLVp9rocSOP2REtpTxUV8UBD8XKe4zB/s1N9LmAebc2HsFPpGeKyAcaHdEsF2N
         ScoHRZ+k3ETRVBiBpEK/jM8i1SelRN1c3rvzdV3FFAj/kNPXF0zP/NhQqFEElDhzG6z1
         kPIsFNemvpYN1CST0qbpjBf/2MFerEoa6oCDo/qWs58zZKKhCbOmp+KEYFvCQIseRe3I
         R5+Z7AidizzhyeqKO4shvb2jKA4UJkkarpLVavVMB7dsDNL1iuaxeBZO3ikePac/0eiD
         5IOyXop50sM/QzRXTqDEQcx1ILyq98auoPnacO8IDEoE3gAWAm65q280gUGQ47Y/tnCX
         Vmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728071744; x=1728676544;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IhEoclRr5enU/RPJ9yJtc7O8LWAGmPRjj/4eWIHOC28=;
        b=VrWmoT9zGSekDdleC7fRgH8ojri7opAoYG1qVLFda013bvMv/O+zTf6hEwB06o0ixY
         jjveIPJIIFdUkmqz9AgLyxm6qH5cpnK9+1jE52UiUMq0zNR6GxAzN67xGdnalCFbvyHj
         eWJPVWSGokB2qybzuNoa78ZKYPdC0adoyp1TPBkOjslxa9orHi3mjPmAOIIeXohxRQ8i
         JCrz8em/2K1nz7PtFbM5abFSngLAEACWJ+LlhbgyjsaLDkCxrCp5ACVetiK2TQWWKM9w
         Vhw3YzK6AqumgbitCfCqloS2Vf1jz7yEzyGOjCdLX8EzTPjvld0+jXx++jiX11JC5SRX
         qXSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCAJAzyLNUx67LrPkhVFHke2U5TGtbelCt3gRoRqnr3+qbmm90UeeF0D9CdyM0Yl0b7FU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxthAICJ17r4wsB6U9nqyi4lCVKn2qValwcc87pq3e6Ds7VxKRt
	BOLG2x6K0a+fFXS6fBNVlnC7tVo5E1Ef0rNC2ZnaS3lfnREBUUdNVR5lEG6uOm4TT8qeLKMwKDr
	wMeNf8Q==
X-Google-Smtp-Source: AGHT+IFfcLIpARuPrEca1crlY6gJULhFzQOlwCxnkz8gtCR/ft9N7l6kO2r+xao/UcBejzbjYnEnwdV+wVe6
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a05:690c:6f8c:b0:6db:c34f:9e4f with SMTP id
 00721157ae682-6e2c72ca7d4mr1059217b3.8.1728071744024; Fri, 04 Oct 2024
 12:55:44 -0700 (PDT)
Date: Fri,  4 Oct 2024 12:55:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241004195540.210396-1-vipinsh@google.com>
Subject: [PATCH v2 0/3] KVM: x86/mmu: Repurpose MMU shrinker into page cache shrinker
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is extracted out from the NUMA aware page table series[1].
MMU shrinker changes were in patches 1 to 9 in the old series.

This series is changing KVM MMU shrinker behaviour by emptying MMU page
caches which are used during page fault and MMU load operations. It also
incorporates feedback from the NUMA aware page table series[1] regarding
MMU shrinker.

KVM MMU shrinker has not been very effective in alleviating pain under
memory pressure. It frees up the pages actively being used which results
in VM degradation. VM will take fault and bring them again in page
tables. More discussions happened at [2]. Overall, consensus was to
reprupose it into the code which frees pages from KVM MMU page caches.

Recently [3], there was a discussion to disable shrinker for TDP MMU.
Revival of this series is result of that discussion.

There are two major differences from the old series.
1. There is no global accounting of cache pages. It is dynamically
   calculated in mmu_shrink_count(). This has two effects; i) counting will
   be inaccurate but code is much simpler, and ii) kvm_lock being used
   here, this should be fine as mmu_shrink_scan() also holds the lock
   for its operation.
2. Only empty mmu_shadow_page_cache and mmu_shadowed_info_cache. This
   version doesn't empty split_shadow_page_cache as it is used only
   during dirty logging operation and is one per VM unlike other two
   which are per vCPU. I am not fully convinced that adding it is needed
   as it will add the cost of adding one more mutex and synchronizing it
   in shrinker. Also, if a VM is being dirty tracked most likely it will
   be migrated (memory pressure might be the reason in the first place)
   so better to not hinder migration effort and let vCPUs free up their
   caches. If someone convinces me to add split cache as well then I can
   send a separate patch to add that as well.

[1] https://lore.kernel.org/kvm/20230306224127.1689967-1-vipinsh@google.com/
[2] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
[3] https://lore.kernel.org/kvm/20240819214014.GA2313467.vipinsh@google.com/#t

Note to maintainers: scripts/checkpatch.pl is complaining about few
things on selftest (patch 3). These are just false positives.

1. Prefer strscpy() over strcpy(). 
   This kernel API and not general libc userspace API.
2. Unnecessary whitespace before a quoted new line.
   Just the way help string is written for selftests to align output of
   help.
3. Prefer using '"%s...", __func__'
   Because I wrote "help" word in the printf().

v2:
- Add a new selftest, mmu_shrinker_test.

v1: https://lore.kernel.org/kvm/20240913214316.1945951-1-vipinsh@google.com/
- No global counting of pages in cache. As this number might not remain
  same between calls of mmu_shrink_count() and mmu_shrink_scan().
- Count cache pages in mmu_shrink_count(). KVM can tolerate inaccuracy
  here.
- Empty mmu_shadow_page_cache and mmu_shadowed_info_cache only. Don't
  empty split_shadow_page_cache.

v0: Patches 1-9 from NUMA aware page table series.
https://lore.kernel.org/kvm/20230306224127.1689967-1-vipinsh@google.com/

Vipin Sharma (3):
  KVM: x86/mmu: Change KVM mmu shrinker to no-op
  KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU memory caches
  KVM: selftests: Add a test to invoke MMU shrinker on KVM VMs

 arch/x86/include/asm/kvm_host.h               |   7 +-
 arch/x86/kvm/mmu/mmu.c                        | 139 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h                |  14 +-
 include/linux/kvm_host.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   5 +
 tools/testing/selftests/kvm/lib/test_util.c   |  51 ++++
 .../selftests/kvm/x86_64/mmu_shrinker_test.c  | 269 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   8 +-
 9 files changed, 404 insertions(+), 91 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/mmu_shrinker_test.c


base-commit: 12680d7b8ac4db2eba6237a21a93d2b0e78a52a6
-- 
2.47.0.rc0.187.ge670bccf7e-goog


