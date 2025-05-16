Return-Path: <kvm+bounces-46890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC22ABA542
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE9ED7A6860
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4FE280311;
	Fri, 16 May 2025 21:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKNYuCzp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCAC28002D
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431344; cv=none; b=mE/4mm8TjHwrhdjF/NGKmf+MScKgUvDiJStOo/RS7VcO9ABQ3rB4RsUNplicCFiag78Ltjo/yQY/vevzBe2wqcQfNsGTuvBaLAePrONDDAHMqmiEMERtE2prbdyi3OMWxaod6eqompMcFDv3aVoji7wI3DwYCskWg7Ehjh7DqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431344; c=relaxed/simple;
	bh=hPL5e/P/cV9diBrTyzd7jSCS8KcQA3rmpSv703Ir/mA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nDtFQ1Kaivn2MHnb6RpOmW4GzZI9oobYCsER40nfdHu+rfMUNJk2zh/Y+O/K8YrSVjQhBZgVJsGu8rhrCzWctUVNqocVJgbnu8IWAMRt1xr32D9OYGihz4KVIzm/j0BB3SQvJK1uzX/tWIyfWatHfDWXMpvncJsvgcarC0mAy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKNYuCzp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e810d6901so974987a91.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431342; x=1748036142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNHr7Po9X4IY3i+xCFCFaGljs9bw7WMHVo7Wciw81Ak=;
        b=fKNYuCzptjRrJ/2VP6KkiDeawUaee+ngU3wTPYo+etQBz9sTgYegt6ZKemaHZIGWNT
         //QGsxD7NrmLeaNcNFMKxTa9Q3Bd/oTChsf4VZpy/21rxpGiv9R8ehrau+lkA2B0TC8y
         ARd+Zz1InG+Ox0Er5HQ4V+7FATYeF2ZCVx3UjhOzYMVvpaltNvQHT9/H7dCrr09N7jMn
         M96IZT9bB7j/4vipVdL0Y29HCbdt5bBkS5B7l4nhAdpzSzMN+mMFlproe6yCuiqbqXtr
         rteNfmfkjiXAG90ZoJKgnwQs9V+dcmOjJ3dkhH7L0yx4NvlkGrPTvI7oi1hjfm11gxFR
         7lqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431342; x=1748036142;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNHr7Po9X4IY3i+xCFCFaGljs9bw7WMHVo7Wciw81Ak=;
        b=qbCNYyAhihVfKyqq95Ce+3meDj5oI2ivT6qobxYlP5aH6S4g8FzQW1zibVbLMMtZdZ
         Hy0XIMD0UfnV3oC8oZrlXC0fNk1t1h8oTioaelMNMaxW4fiMBo8zHB2q+f+Q4+IUMp5y
         1pWILcVDtU+PcWZgDP9DT9aChCjX3QHL/O1FIeRVb51HWd54zR6z7EamxIqTA23gq9id
         3La6vHaqTwJYWVr3HHwhv9w4/cHbSEs6twG2bNC2HXNGRXdKvk7phhw82ywKkRY+rCw+
         7Lj0mX9iaYkLtLG9K+fTU6Ys1eje72HDm3kpWNmCiwQtcqgkW7A9dGNPpn2wP5lZKyFZ
         vZvQ==
X-Gm-Message-State: AOJu0Yz4G//SN+M+cn3ag/OgbqtPDqBQAUdsEJ7mu+dYj7t4MGDTPRoO
	q+XtlBeD4FIZybL3a/53fOX0w/v8bLcVVPvl/vVwLO0KjpnkQpWUVXbYAEXDApiJ2XA8SbOOcPz
	gmO76HQ==
X-Google-Smtp-Source: AGHT+IG+XyFJvw9Pd7od/AslUHXgv3/EqoXQrpwCSuULnqlUWxViE7nATwFTEJvFMOEYURtUCNEgKSxbh84=
X-Received: from pjbsy8.prod.google.com ([2002:a17:90b:2d08:b0:30e:65cf:2614])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:2ff:5ec1:6c6a
 with SMTP id 98e67ed59e1d1-30e7d55ba27mr7784969a91.18.1747431342299; Fri, 16
 May 2025 14:35:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-1-seanjc@google.com>
Subject: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Fix issues with dirty ring harvesting where KVM doesn't bound the processing
of entries in any way, which allows userspace to keep KVM in a tight loop
indefinitely.

E.g.

        struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);

        if (fork()) {
                int r;

                for (;;) {
                        r = kvm_vm_reset_dirty_ring(vcpu->vm);
                        if (r)
                                printf("RESET %d dirty ring entries\n", r);
                }
        } else {
                int i;

                for (i = 0; i < test_dirty_ring_count; i++) {
                        dirty_gfns[i].slot = TEST_MEM_SLOT_INDEX;
                        dirty_gfns[i].offset = (i * 64) % host_num_pages;
                }

                for (;;) {
                        for (i = 0; i < test_dirty_ring_count; i++)
                                WRITE_ONCE(dirty_gfns[i].flags, KVM_DIRTY_GFN_F_RESET);
                }
        }

Patches 1-3 address that class of bugs.  Patches 4-6 are cleanups.

v3:
 - Fix typos (I apparently can't spell opportunistically to save my life).
   [Binbin, James]
 - Clean up stale comments. [Binbin]
 - Collect reviews. [James, Pankaj]
 - Add a lockdep assertion on slots_lock, along with a comment. [James]

v2:
 - https://lore.kernel.org/all/20250508141012.1411952-1-seanjc@google.com
 - Expand on comments in dirty ring harvesting code. [Yan]

v1: https://lore.kernel.org/all/20250111010409.1252942-1-seanjc@google.com

Sean Christopherson (6):
  KVM: Bound the number of dirty ring entries in a single reset at
    INT_MAX
  KVM: Bail from the dirty ring reset flow if a signal is pending
  KVM: Conditionally reschedule when resetting the dirty ring
  KVM: Check for empty mask of harvested dirty ring entries in caller
  KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
    resets
  KVM: Assert that slots_lock is held when resetting per-vCPU dirty
    rings

 include/linux/kvm_dirty_ring.h |  18 ++----
 virt/kvm/dirty_ring.c          | 111 +++++++++++++++++++++++----------
 virt/kvm/kvm_main.c            |   9 ++-
 3 files changed, 89 insertions(+), 49 deletions(-)


base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
-- 
2.49.0.1112.g889b7c5bd8-goog


