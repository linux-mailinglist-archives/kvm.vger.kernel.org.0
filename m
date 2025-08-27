Return-Path: <kvm+bounces-55803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4740AB375CB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DDF37C0367
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411F0F4F1;
	Wed, 27 Aug 2025 00:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGCWWbUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8B3801
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253126; cv=none; b=tfqiXle/PA9SsQq5mvJAeVNyR09/JHK0HqboxL5OkOnHlBg1RDOimJ7ETd3JmfwDDqnnZTdeiNQFpd1Rz8mCyEgYewaWLRbcVY7F3u3mrDpVqeD8vt3M7MypWjsB9KMc/jkbk6QGKYsDKizERVYsnv0S6zZEm+6m9aEWlnzQ0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253126; c=relaxed/simple;
	bh=LUjrmV9vYD0d7Y3rNbO+CnOuXhd9CQmqt/2LRdyxFp0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q8j82qORm429AkVSLSkDZKyQpDP04g6FtwJ4Md5nnFAqzjizba1wR9ebl8Av03PhriogMmflXl9m6jh/RdSRPQPdrA0CAmWKGZ8NIXEmpXMnHiBo3nShemxQuiD2b1RWJp9SjDPOViirudHe0BYZuv79ENpCmAKFNyTSaYdhe1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGCWWbUP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b49da0156bdso4754300a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253124; x=1756857924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAYQ9sHs09UDF7cW5USTEYfEkZ4TWUXmBvuJzFsHR7g=;
        b=bGCWWbUPz7tR8OEL1tL56RoaZhlBEu1xYiF/ct1v9RlioMJPUQ1JyLLBvtO0uMvlna
         9l1uXvrK0sxRkkGxmluY4WvsnAmbN+hT1e3WzWEoBiOJ8zSuxcCYslozGvCnEiujomxS
         qjBbvL1pyZLC3DkOyN+/AZt/TOj/nkr42/eR4zoKBcRH84YZZqiO4+TMnlefi3W42RgM
         T/wihHfZX8hwxOrnXQS/fhHJxsw4Yc65Yrk1BHDUWRidY6VwBokcVgfdImjwClh3De5f
         7FBU61jWoK23S3wtgV8/JqeT36KN9/qWgg8cI9kWeRrawL11ExUMR4SJSlXLdpI4+rOz
         n2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253124; x=1756857924;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAYQ9sHs09UDF7cW5USTEYfEkZ4TWUXmBvuJzFsHR7g=;
        b=CJcm/GCJ+R3IkW3jMWjw3MOshC9IEzQrzEZXifFtehgZscmCMogAGp+gty8DePscHn
         vA61pWTiJmR9g/7VfsQX54RGNmZN0MTk4IWLfb7STTCm1w1NUc8RZy7jqSbpg+ZS0D4d
         GCtzcBPsR94lmj5R8Ceh9F1S/PcB++WLGn01amR/UFMHRF6AI3hZahEWGDruTuxIWE1w
         1u2rYHPms82vLRQAAuhLHsKBhxS5qCwlK7nT876ln4fZ4KeLfMcOM69ZyGvbTnc3ciIt
         PLRCykYqZNzTd88kKVe4pqok6t7OzQu3oSTLwyQzw7RDZfWi/7SkGd5W7GeQ0bKERjwo
         RqAg==
X-Gm-Message-State: AOJu0YxJqKZ6PODq6UsUayqtA6qdarJsv2VEsnWo59Kbwf/xNsY+w3m8
	JbNIl1uovNIxwzGtBvQI+tvhB7PMzhdM07IvpYJjY0lOdPh0s0SDKaboGVYaSbYiXSJoIYtgult
	HslGY/A==
X-Google-Smtp-Source: AGHT+IHKQp4PwjlFYw8IbTPHyvClCOZw3IRzGWvQ2el3OizC3xRx3IpRFT9ogu4Za5Lx/cDpzEDVM4/rKA0=
X-Received: from pgh13.prod.google.com ([2002:a05:6a02:4e0d:b0:b4c:46df:36a8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f97:b0:243:15b9:765b
 with SMTP id adf61e73a8af0-24340d6dc1cmr22725815637.53.1756253124220; Tue, 26
 Aug 2025 17:05:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-1-seanjc@google.com>
Subject: [RFC PATCH 00/12] KVM: x86/mmu: TDX post-populate cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

This is a largely untested series to do most of what was discussed in the
thread regarding locking issues between gmem and TDX's post-populate hook[*],
with more than a few side quests thrown in as I was navigating through the
code to try to figure out how best to eliminate the copy_from_user() from
sev_gmem_post_populate(), which has the same locking problem (copying from
a userspace address can fault and in theory trigger the same problematic
path, I think).

Notably absent is the extraction of copy_from_user() from
sev_gmem_post_populate() to kvm_gmem_populate().  I've had this on my todo
list for a few weeks now, and haven't been able to focus on it for long
enough to get something hammered out, and with KVM Forum on the horizon, I
don't anticipate getting 'round to it within the next month (if not much
longer).

The thing that stymied me is what to do if snp_launch_update() is passed in
a huge batch of pages.  I waffled between doing a slow one-at-a-time approach
and a batched approached, and got especially stuck when trying to remember
and/or figure out how that handling would interact with hugepage support in
SNP in particular.

If anyone wants to tackle that project, the one thing change I definitely
think we should do is change the post_populate() callback to operate on
exactly one page.  KVM_SEV_SNP_LAUNCH_UPDATE allows for partial progress,
i.e. KVM's ABI doesn't require it to unwind a batch if adding a page fails.
If we take advantage of that, then sev_gmem_post_populate() will be a bit
simpler (though I wouldn't go so far as to call it "simple").

RFC as this is compile tested only (mostly due to lack of access to a TDX
capable system, but also due to lack of cycles).

[*] http://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com

Sean Christopherson (12):
  KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
  KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
  Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP
    MMU"
  KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_prefault_page()
  KVM: TDX: Drop superfluous page pinning in S-EPT management
  KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
  KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
  KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
  KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
  KVM: TDX: Assert that slots_lock is held when nr_premapped is accessed
  KVM: TDX: Track nr_premapped as an "unsigned long", not an
    "atomic64_t"
  KVM: TDX: Rename nr_premapped to nr_pending_tdh_mem_page_adds

 arch/x86/kvm/mmu.h         |   3 +-
 arch/x86/kvm/mmu/mmu.c     |  66 ++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c |  37 ++---------
 arch/x86/kvm/vmx/tdx.c     | 123 +++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.h     |   9 ++-
 5 files changed, 117 insertions(+), 121 deletions(-)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
-- 
2.51.0.268.g9569e192d0-goog


