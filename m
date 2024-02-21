Return-Path: <kvm+bounces-9274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B44085D146
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23216286B12
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621963B287;
	Wed, 21 Feb 2024 07:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fIQvEFdT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0663A8C0
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500358; cv=none; b=Y+5y/vdgoFCxdV7EPymPsbtXaFR8DEVxt1QpYcq8QwYao0bTETWeF9Nkgu1rZy5oUK/yIehfWzPt+IiZCQsFVeQbzL+YPTrwiHmtmVsN6QwnWm1sJWH1AZkdARd8/3px+YcVWdIfLHkJSXA/OvXr80VA/DiNNqY3TYH8M6XMXqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500358; c=relaxed/simple;
	bh=BNvF2Qw/ckDsg5AFU3UAYnddVhnqJSdCPlAYGCYfcZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rs/a6TLv23zMgsn/L4HzUyqPKV1X7VkQ6W5n7wECOcFMAeUJDzTb46pT01SHog/GTsiRxiwD0qpC7PK1vHRlOi2vjEUS8UMGwmt7Mjsr0rQ8wOowEEp26JgrJfd/4NAAVYrOyEKI4I//UV+mNViy0kzuM21Xb7c5GIYd8seMQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fIQvEFdT; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3c1404d05bfso4535001b6e.3
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500355; x=1709105155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ueaOZVSLa3KihKWczeP0Mvx0Wg5V24kjzNwmuUZQlfQ=;
        b=fIQvEFdTXKgC8eE+5q2rOwBq0PqDTES2q50jjM1qPLM0W4N1Z9MEsQ0qCPFA4HhY0Z
         oFbeM/qqt2IzAHH5aQ03720AhNQBRc22zOpSZEVxxsnI0BMsXGLZhmaJUcO6kTtIvD5w
         HdSSQ0ox8pzwZ6sXmM51IuHs4+LmuH7ilAHVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500355; x=1709105155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ueaOZVSLa3KihKWczeP0Mvx0Wg5V24kjzNwmuUZQlfQ=;
        b=SI+UEpiRZOWqtUSb9BwBHCYVWP18BQN5fTAj5/NwOBVSmk5Q+WyKzQX9N806SemRJ5
         C4oKdHXSx68rWQnrcKYe4y0MRzOkjeQBIqjOB1aHLf/ry0Dtf9WNEVAxziVJqk3mZ/dI
         Kdzit/jkRUvEbNq0k/EIGWBcxnUzbUHXpgYYlcpnduEXTf1HlyQeu+guNRGAn6UGj5Sf
         EM7whQqGiPpVDcqwQc1bGbprAa700+VLB03XaQeq6kmCc0Q3ASelXvDWwpO8TMc4uXs6
         Urf/PrA/2u9S5IpEFoeuO9G44OFhfinw0Um//KHP/rsdmdTlPz4r2qcL2gIVO2p0f7s4
         txmA==
X-Forwarded-Encrypted: i=1; AJvYcCVZYZfybeOK/ocCtwb5OiLZDK9O9j3u1TzVZE07TDuu0h/Zm9yBnnCxPbeP3eL/bjs1llTBwMDG13S+gBgk3LEWHVeV
X-Gm-Message-State: AOJu0Yw/ulzmONhrmS39m06WfNVwmQMiKwPSu/x6KZaebk798G0QrkTs
	xRUdI0Gp7RakmALMFra62aDFqB75ZBNRpQR9TYp25EVwPuGpK6CEewxbwvkkzQ==
X-Google-Smtp-Source: AGHT+IGL0Q27aT+XYlwXJPM/BhQ1zwOcwczndAcAl1o/pm4io8+k2TjLjzNjsnDOJ3EtfYMWZoIgPw==
X-Received: by 2002:a05:6808:17a3:b0:3c1:37d9:dc93 with SMTP id bg35-20020a05680817a300b003c137d9dc93mr20410632oib.10.1708500355230;
        Tue, 20 Feb 2024 23:25:55 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id y5-20020a056a00180500b006e45daf9e89sm5832804pfa.131.2024.02.20.23.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:25:54 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 0/8] KVM: allow mapping non-refcounted pages
Date: Wed, 21 Feb 2024 16:25:18 +0900
Message-ID: <20240221072528.2702048-1-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
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

 arch/x86/kvm/mmu/mmu.c          | 104 +++++++---
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/paging_tmpl.h  |   7 +-
 arch/x86/kvm/mmu/spte.c         |   4 +-
 arch/x86/kvm/mmu/spte.h         |  22 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  22 +-
 arch/x86/kvm/x86.c              |  11 +-
 include/linux/kvm_host.h        |  53 ++++-
 virt/kvm/guest_memfd.c          |   8 +-
 virt/kvm/kvm_main.c             | 349 +++++++++++++++++++-------------
 virt/kvm/kvm_mm.h               |   3 +-
 virt/kvm/pfncache.c             |  11 +-
 12 files changed, 399 insertions(+), 197 deletions(-)


base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
-- 
2.44.0.rc0.258.g7320e95886-goog


