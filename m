Return-Path: <kvm+bounces-10338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D5A86BF25
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CACF285320
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944D137153;
	Thu, 29 Feb 2024 02:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jPg2dr5p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70436185E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175489; cv=none; b=ReOfAbI1NAdhX5oYYh1YRBVeO4HBmWaqS3RpUfKzwntuOMEZeK0jE+FH3nJfMPEMY0cj+A2Rc67ibfS8z3KvCS60kCMQr4gaWeJhAyEaPUYo+aNWhyCOi18u1+Z15zdbpnnm1TVXojy9diGTMYEhDuE60cmAhebM3Er1zd2FS1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175489; c=relaxed/simple;
	bh=vTo43K8wKC81JH1cmE6G3o/ZjBDx+QgMlTVTqwHGI38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T7hTYaxxM9Jhu3fhlTpIqNB6jd6HRnQRhXswyafbn26jw5kwTpIlGoXi2ckKalRq8sfkHQ2uTyx0ME3RnkUNGfxetKA0AcuYmwGR5L9Rg82KHFX3/jOJNUMdftJ1E7UIrjqN4F3Rs+W1pP7AV+0Yzl886n+w+hHsk+Ct3iwKFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jPg2dr5p; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dca160163dso4776735ad.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175487; x=1709780287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYrIjEX8sBb4dT+FuvYa3Se1T3Bf/IWCGgkiK7PdSp0=;
        b=jPg2dr5pROUofHcv0fIh3KOujgBfZOUB8aC6+4UuVmVQYEwGVSeQhRO5VY0Uw6U+j/
         79BvHRZCSKjJxQUo6XaO1PO7MJDLtnSyNcozeglUTOM8mOujpMR0wsu8zA6xDs01YwUW
         dOdMjW95ZXju/hC+bPLMZ7If2CCINPfOknExc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175487; x=1709780287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYrIjEX8sBb4dT+FuvYa3Se1T3Bf/IWCGgkiK7PdSp0=;
        b=jWhpK4RzXymI2cWDQ0GIxRU2+IuQHPOvuK+nLI2Bb0WbMPPE0MtQorqe7PAzsWcWrX
         OX8rgmHv5DSEPCDMNNLNSmRJerQ9dWAVOGRM1JtYD/g4Ge7Lug5m3v+k1huK42lAZFNs
         uOr3jakaQWQYnaYNxOtnFrBJLiIVGixOdutJZi3LKUne28MxeEj2ec4KP6NCJ9jaFJij
         lopYep61vQ4VNBVbmrREVXNvn5jB2yP8bpMGYq60vxGYKE4kOHPbBWtlqze6qs+GKqjG
         3Dyh7yLd3ZYEXoKKHicMEnRV6oerPJT2YEIqI0ZF5OY3IDLcL+lpSPe6ntWRBjtxN8uw
         jtGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY8fH9s2NPDWMrorJ/dnJSfAXjFT5rcU5sPej9fibeATwu84QSKuSPnUwbQHr/ZVzNgN0qmHs+s0SUf19tK2KAG9PO
X-Gm-Message-State: AOJu0Yxgs0Q2eRj5yNZdrQ+TvMBVXbtIc+gO9MByqksJ7SMj7FBy71U/
	/xG4NoSxGV8BZ+Xwy+oPoXCzSpCpmI0FEfXprb3i09pQ0Ho2uXqTWn3C+Renug==
X-Google-Smtp-Source: AGHT+IGX2J1qRGPAk8Cl6s48psnsoyoG+In7Glf3fzZVHLi4UU8vhZ5C51T0Oye4gDcJQGTRUdVsaQ==
X-Received: by 2002:a17:902:6b41:b0:1db:ccd0:e77e with SMTP id g1-20020a1709026b4100b001dbccd0e77emr849550plt.35.1709175486838;
        Wed, 28 Feb 2024 18:58:06 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id i6-20020a170902eb4600b001dc38eaa7fdsm174087pli.278.2024.02.28.18.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:06 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Date: Thu, 29 Feb 2024 11:57:51 +0900
Message-ID: <20240229025759.1187910-1-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

This patch series adds support for mapping VM_IO and VM_PFNMAP memory
that is backed by struct pages that aren't currently being refcounted
(e.g. tail pages of non-compound higher order allocations) into the
guest.

Our use case is virtio-gpu blob resources [1], which directly map host
graphics buffers into the guest as "vram" for the virtio-gpu device.
This feature currently does not work on systems using the amdgpu driver,
as that driver allocates non-compound higher order pages via
ttm_pool_alloc_page().

First, this series replaces the gfn_to_pfn_memslot() API with a more
extensible kvm_follow_pfn() API. The updated API rearranges
gfn_to_pfn_memslot()'s args into a struct and where possible packs the
bool arguments into a FOLL_ flags argument. The refactoring changes do
not change any behavior.

From there, this series extends the kvm_follow_pfn() API so that
non-refconuted pages can be safely handled. This invloves adding an
input parameter to indicate whether the caller can safely use
non-refcounted pfns and an output parameter to tell the caller whether
or not the returned page is refcounted. This change includes a breaking
change, by disallowing non-refcounted pfn mappings by default, as such
mappings are unsafe. To allow such systems to continue to function, an
opt-in module parameter is added to allow the unsafe behavior.

This series only adds support for non-refcounted pages to x86. Other
MMUs can likely be updated without too much difficulty, but it is not
needed at this point. Updating other parts of KVM (e.g. pfncache) is not
straightforward [2].

[1]
https://patchwork.kernel.org/project/dri-devel/cover/20200814024000.2485-1-gurchetansingh@chromium.org/
[2] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/

v10 -> v11:
 - Switch to u64 __read_mostly shadow_refcounted_mask.
 - Update comments about allow_non_refcounted_struct_page.
v9 -> v10:
 - Re-add FOLL_GET changes.
 - Split x86/mmu spte+non-refcount-page patch into two patches.
 - Rename 'foll' variables to 'kfp'.
 - Properly gate usage of refcount spte bit when it's not available.
 - Replace kfm_follow_pfn's is_refcounted_page output parameter with
   a struct page *refcounted_page pointing to the page in question.
 - Add patch downgrading BUG_ON to WARN_ON_ONCE.
v8 -> v9:
 - Make paying attention to is_refcounted_page mandatory. This means
   that FOLL_GET is no longer necessary. For compatibility with
   un-migrated callers, add a temporary parameter to sidestep
   ref-counting issues.
 - Add allow_unsafe_mappings, which is a breaking change.
 - Migrate kvm_vcpu_map and other callsites used by x86 to the new API.
 - Drop arm and ppc changes.
v7 -> v8:
 - Set access bits before releasing mmu_lock.
 - Pass FOLL_GET on 32-bit x86 or !tdp_enabled.
 - Refactor FOLL_GET handling, add kvm_follow_refcounted_pfn helper.
 - Set refcounted bit on >4k pages.
 - Add comments and apply formatting suggestions.
 - rebase on kvm next branch.
v6 -> v7:
 - Replace __gfn_to_pfn_memslot with a more flexible __kvm_faultin_pfn,
   and extend that API to support non-refcounted pages (complete
   rewrite).

David Stevens (7):
  KVM: Relax BUG_ON argument validation
  KVM: mmu: Introduce kvm_follow_pfn()
  KVM: mmu: Improve handling of non-refcounted pfns
  KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
  KVM: x86: Migrate to kvm_follow_pfn()
  KVM: x86/mmu: Track if sptes refer to refcounted pages
  KVM: x86/mmu: Handle non-refcounted pages

Sean Christopherson (1):
  KVM: Assert that a page's refcount is elevated when marking
    accessed/dirty

 arch/x86/kvm/mmu/mmu.c          | 108 +++++++---
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/paging_tmpl.h  |   7 +-
 arch/x86/kvm/mmu/spte.c         |   5 +-
 arch/x86/kvm/mmu/spte.h         |  16 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  22 +-
 arch/x86/kvm/x86.c              |  11 +-
 include/linux/kvm_host.h        |  58 +++++-
 virt/kvm/guest_memfd.c          |   8 +-
 virt/kvm/kvm_main.c             | 345 +++++++++++++++++++-------------
 virt/kvm/kvm_mm.h               |   3 +-
 virt/kvm/pfncache.c             |  11 +-
 12 files changed, 399 insertions(+), 197 deletions(-)


base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
-- 
2.44.0.rc1.240.g4c46232300-goog


