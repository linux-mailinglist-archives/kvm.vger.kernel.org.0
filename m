Return-Path: <kvm+bounces-45891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECA4AAFC6D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A933916B1ED
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FEB253933;
	Thu,  8 May 2025 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QLJvbiUY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38562253345
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713417; cv=none; b=p5MWJFFp7+Tzr98QWv+htMCk2odlWSemvhdY6w2jIOAtBoJNr1yN6ixSCrmlAXW0p5OcYTk+MH4YkDdiXe+mbHKkoSOhol2H52nNARAyJlp4Kpq0R6th4G6VOkqt1S13EOP1LBaMIlBSm8rCeLNgbblcue9UhG0QSU5B4XYSP5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713417; c=relaxed/simple;
	bh=K38H7j+jhQAWKzdKuztTbl/KVYggmJDGcykifwKmp5U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qxJGCBtcu8lHPQffLPjPTBVWlPu6WW+Co3Ffh3OlWwwmxlg5E4TBpHh2v0kXHipTUkAFBtDZ0IZ4UdVGiNVD/vT9S7Me5DbG5s/kVt6BkMCezwpXVYY5Hba+B1Q1vshyTKS+Xzlta8Y7/GDjUIo4a4vJ1AbdxxtqztQLuMndEr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QLJvbiUY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-739525d4d7bso969263b3a.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713415; x=1747318215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lb9OSMUeAQTsOzkOZQxxAPIL/+T0uPFUk2b/IsbmGbE=;
        b=QLJvbiUYqF+yJQ4YIAv4htVah7IpqkPsAwJcbBPVZx+r5CTywj7c4Vkj8BG2RVIww+
         cbWmDAImiThDQ3dB96CDyPDVKOIZkrrX+WKAFgL0wl9QveyIpn0VpDmiMKKo/G+bSQgw
         LPLpuE6JmAAywX/jQ752usOdod9sJ/+ccRqYDov6LjYvbQ1ph+eCdCn50tr8VR4gmVAP
         Tzuyo7qilDUFX/o1irPHW8WuBaZxghvwJ3NZmV9FU69WXyee5p2jg+2MbXlLRtbgfdre
         AVMUokby2zh86Hb+aZViKploq/rnswCDPvk1aHXrVIP8HbE2+ZdiyDyuzN+OQZEJ+/on
         aY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713415; x=1747318215;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb9OSMUeAQTsOzkOZQxxAPIL/+T0uPFUk2b/IsbmGbE=;
        b=Rc+QQM2zWx31fQ582mj63ak2lZG3xPm+sXDbV20GFY+2GN85w3m+ffTESvOLL+6gz3
         KTomZDLXZyicH3vqC3qcWHdwwdbgrLCAxcq1cJAIBQx3X0ze1HbYZwhMof3IoNG8qhOj
         xIovSAJln30/FZ2fwz/FiL1gnvLrBNX0+GeE60F/HGU8GbbZ9QbqQo91fG0qUr2Lo8Uy
         7UBqieiUq5q7v/JZpyYU7wYuK6Uo9JPuSG4LLxNVaT8a0ruRD8F/J1tfWnsmzD6pIM9T
         IQezk3LbIUyoK+5fiBYhsYIjnmflEdgJ/u2X5qdzHfUbVwTz4EbcN+xN/jUMnMGh0vW8
         69Cw==
X-Gm-Message-State: AOJu0YxGTtBXSDWBm19Z5GzT9BQam9K7JuIKutzwF3NtZ5TGsOaV0BcC
	I7RVdu2lxpCq0VTK8ujIjbVsGtJ2tDe8GJxo6wrE6qdY18YbZ2Dc2PIvzqjisxJkgdIlpoFfz5w
	oIg==
X-Google-Smtp-Source: AGHT+IFcILts8vfqh4yaVx76R7neN1W/GaG0zAfrtsRgI95d3UpHMF84iAFoISJJ1LSjQwxOpsvknTvyDiU=
X-Received: from pfmy9.prod.google.com ([2002:aa7:8049:0:b0:730:9951:c9ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3394:b0:736:9f20:a175
 with SMTP id d2e1a72fcca58-7409cedc5b9mr10775865b3a.2.1746713415260; Thu, 08
 May 2025 07:10:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 May 2025 07:10:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508141012.1411952-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: Dirty ring fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
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

Patches 1-3 address that class of bugs.  Patches 4 and 5 are cleanups.


v2: Expand on comments in dirty ring harvesting code. [Yan]

v1: https://lore.kernel.org/all/20250111010409.1252942-1-seanjc@google.com

Sean Christopherson (5):
  KVM: Bound the number of dirty ring entries in a single reset at
    INT_MAX
  KVM: Bail from the dirty ring reset flow if a signal is pending
  KVM: Conditionally reschedule when resetting the dirty ring
  KVM: Check for empty mask of harvested dirty ring entries in caller
  KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
    resets

 include/linux/kvm_dirty_ring.h |   8 ++-
 virt/kvm/dirty_ring.c          | 103 ++++++++++++++++++++++-----------
 virt/kvm/kvm_main.c            |   9 ++-
 3 files changed, 81 insertions(+), 39 deletions(-)


base-commit: d1b88431c59e94799aff0e31ce1467af2a86b0cf
-- 
2.49.0.1015.ga840276032-goog


