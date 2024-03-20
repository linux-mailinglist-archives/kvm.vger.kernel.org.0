Return-Path: <kvm+bounces-12201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46FB98808B9
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46CDD1C21D54
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AF5846C;
	Wed, 20 Mar 2024 00:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmETGnsh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B656747F
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895836; cv=none; b=i6PVA39pyer9mU3cl2Yrqmf/GNZaIK6ZvoMPSUlDHmoNmqF/dmUVfPcAI9aHMmrA1YpjuDXFsf9paxIY90A45ejm3JtuyoAeL2SFDCGcitpVSwA2RC6MDI2fy/2a8kQBmXs2jN92nYDwUqfpbqQSCiU8sU7w7NEYNNqa5lpfifM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895836; c=relaxed/simple;
	bh=YPu1aNF2QCp5bTYrRzocDOUaWh9egOdn8NfobVngN+0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=C0Ko4fb5qQqLmjSkhBftl+bB45c/OMpZnEFt7sNRn7kzP6BhR8c6h6DKKMu4LZBwfaY1FbHlZBweKL/okX+iE9bu1UUmbKwwksvq2PIv+TeUsIRUFQxggJo8FBQqFkkgd4wJCF9hCAHZ5OFn/4HiCwTnuWaAqujJ144/MlH3AGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmETGnsh; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcf22e5b70bso9518570276.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710895834; x=1711500634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BI+hYiyTx8lflXSjTxKu8FcFef4tK20uNtko36Dfm2M=;
        b=fmETGnshHAJzs2s2rRKcNsxmwOG7EMep/nAT4XjQYYgeBaAMt9tCn5om4Ali9860g0
         3Kfl/aQJ3NFAcSElxBzlTKEDuAiPznQdGgKp3iu/TI/7UsF9SDsLmtagnONm5SMmRk0Z
         AipxfXWDcwzmd/cPzL1wmiQHEDJ408t60LVb166HE8bX+s8cUO+ZHgum4RrBqv6raGS1
         V/i+SSP0mAnAOkBogtRFbzKwILuvAE81xLrKYLRSHz52IHGnGhAEESG8jyBNzBlTcrWq
         7Nijwk50ss2WJ/Zw/f2/flMlVLTK/1kb1uOvXbKOCus4eYwlMupgertZVgqsq2RrfoKt
         QQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710895834; x=1711500634;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BI+hYiyTx8lflXSjTxKu8FcFef4tK20uNtko36Dfm2M=;
        b=cGcmG20vFHIKcKbdhhEkzwMxZKa04PhuSmaAsqkfWc0K6gSanC+8dUqjvZl/WfTGGM
         vB5+TWHVsMibULREPDwzA/9iJs/v+vhVsE9rTxh2Yk9VKBhxWqR4FN8uGmdjY26PTeUK
         nwRx8oK0BStp5o0/SsTAIjoudU2D2TxDOTqLjPFEukJ3VOpCvFNaT1565ocHHGp3ss+7
         dgBeNt+pIjc5pL+eOP6zzQSu3MdwqWhp6xrV4f8JYtE5Bja8SNNeMygutGyCMdIltp2P
         EJ/D8UNHmAwxfER25lZfPdE3SnGqK6qZ/52U3oqP4EurfAus4N1C1SFcHh1y+QHTFLVT
         ouyA==
X-Gm-Message-State: AOJu0YwZgsmNisZp1lsLzeLbqeigxkJQwGzyqbJuTF+TLsLo/D2tCM1t
	jx7MhUEXS94q2kN1NG9M+lb53prmIk6HNrMQHJwkcOpc1LcCMdZX/pGATk5uXZOhxgu4+ejiqEu
	xMg==
X-Google-Smtp-Source: AGHT+IEmnjlt6HWOMofgULrVlBMZ2yOvsgwGNrngaxVtTkfrpvDD0Sari0EpOjXFil2lNY/MMKkt47WJ/dM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc6:44d4:bee0 with SMTP id
 w4-20020a056902100400b00dc644d4bee0mr897569ybt.7.1710895833977; Tue, 19 Mar
 2024 17:50:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:50:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320005024.3216282-1-seanjc@google.com>
Subject: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Rework KVM to mark folios dirty when creating shadow/secondary PTEs (SPTEs),
i.e. when creating mappings for KVM guests, instead of when zapping or
modifying SPTEs, e.g. when dropping mappings.

The motivation is twofold:

  1. Marking folios dirty and accessed when zapping can be extremely
     expensive and wasteful, e.g. if KVM shattered a 1GiB hugepage into
     512*512 4KiB SPTEs for dirty logging, then KVM marks the huge folio
     dirty and accessed for all 512*512 SPTEs.

  2. x86 diverges from literally every other architecture, which updates
     folios when mappings are created.  AFAIK, x86 is unique in that it's
     the only KVM arch that prefetches PTEs, so it's not quite an apples-
     to-apples comparison, but I don't see any reason for the dirty logic
     in particular to be different.

I tagged this RFC as it is barely tested, and because I'm not 100% positive
there isn't some weird edge case I'm missing, which is why I Cc'd David H.
and Matthew.

Note, I'm going to be offline from ~now until April 1st.  I rushed this out
as it could impact David S.'s kvm_follow_pfn series[*], which is imminent.
E.g. if KVM stops marking pages dirty and accessed everywhere, adding
SPTE_MMU_PAGE_REFCOUNTED just to sanity check that the refcount is elevated
seems like a poor tradeoff (medium complexity and annoying to maintain, for
not much benefit).

Regarding David S.'s series, I wouldn't be at all opposed to going even
further and having x86 follow all architectures by marking pages accessed
_only_ at map time, at which point I think KVM could simply pass in FOLL_TOUCH
as appropriate, and thus dedup a fair bit of arch code.

Lastly, regarding bullet #1 above, we might be able to eke out better
performance by batching calls to folio_mark_{accessed,dirty}() on the backend,
e.g. when zapping SPTEs that KVM knows are covered by a single hugepage.  But
I think in practice any benefit would be marginal, as it would be quite odd
for KVM to fault-in a 1GiB hugepage at 4KiB granularity.

And _if_ we wanted to optimize that case, I suspect we'd be better off
pre-mapping all SPTEs for a pfn that is mapped at a larger granularity in
the primary MMU.  E.g. if KVM is dirty logging a 1GiB HugeTLB page, install
MMU-writable 4KiB SPTEs for the entire 1GiB region when any pfn is accessed.

P.S. Matthew ruined the "nothing but Davids!" Cc list.

[*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com

Sean Christopherson (4):
  KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf
    SPTE
  KVM: x86/mmu: Mark folio dirty when creating SPTE, not when
    zapping/modifying
  KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs
  KVM: x86/mmu: Don't force flush if SPTE update clears Accessed bit

 Documentation/virt/kvm/locking.rst | 76 +++++++++++++++---------------
 arch/x86/kvm/mmu/mmu.c             | 60 +++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h     |  7 ++-
 arch/x86/kvm/mmu/spte.c            | 27 ++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c         | 19 ++------
 5 files changed, 78 insertions(+), 111 deletions(-)


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.44.0.291.gc1ea87d7ee-goog


