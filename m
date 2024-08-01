Return-Path: <kvm+bounces-22980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D8A9452C2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B589DB24927
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857AF27452;
	Thu,  1 Aug 2024 18:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rAm4kLMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56686143883
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537298; cv=none; b=aeovizy5tZEmF19yok23KPhvM9laSv67CZWXllvevrqZpJADA81wvn55CubbKximyiTA/voSyggzAnCZUWDC0YhwWVgPSmgQ/KJCXD1CS/gLdmYkS841GBoC0EaCnYVOQMxBwJXEMcQrfTPVdzoOrrVl9TKclIznbGGOblGPHv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537298; c=relaxed/simple;
	bh=bJBBwTWOIhUdQKdD80wTHo1N63QWUZdpxgE15p1QpWU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QF93G45wV9HL8SVHzRIFUCfUmwH5zkcJKQOFpdR1u6deEnmEjSHJXoL7sBDx2FRJ+NVjXhP/p5kvX4MPS8aVtUtE3Aas+hzVEEWOSJnORJvzJ+61WhrtZayq4OivBDC53y4pSuCcS1wwIqq2axM0a0Jpfx23b+uGFvuw9ha60Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rAm4kLMe; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a12bb066aaso5036823a12.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537296; x=1723142096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5EkBnRfWKwuX6kDL48Ot+VYn3mvhS1OzqZQ8BnW+y4=;
        b=rAm4kLMeTswEX+Qy/eSV3fBmjz1UxFh6ZrEgw0wfEPzJBzz2/jBy+ZGPL86CN58e6u
         0QDSueua4zOhpOILB6dDcafqVguT9U7eFfjxL7O+2k5iPy7tVd9zMtgBZnW4xm5oYSBX
         QFE/1VqbyVum4l17/vIrNYeLG0eRsXDz5MmO/INNpusXKxJ/SHYb+FnB22Cuuk/Krbfe
         /zSgeWoKaChtxK5amhx0MVVHEQnjUaXPcGTLEDmuhV4nWiYnJdsHMLXXfustGTXg+9ly
         K/4R1mYY6GM2jv3IYVsSLBBk1LWLwDaFsokJodsypplPgSuUIY4l0ejigsXq2aroWbMI
         aNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537296; x=1723142096;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5EkBnRfWKwuX6kDL48Ot+VYn3mvhS1OzqZQ8BnW+y4=;
        b=BCF+BR8O42VRJ24NdhGjQw2s2Hx0iDtIEv4GvAx8kGsx40MO77MmSPfI2v+EqIr0uh
         Awo5kUo/GyC/wemgrUEVi9JDPqkOujjJoUWwMwth4vD9hJbzsHefPUyd1dpTM1xZhTBT
         SDm1HGA19Jj27gXme+aGxjILGU0BrjwMT3pQquILwwRevHI/pOPw9Xz9uZUPC+4AEr73
         37ksIZ/7FG2IjaKIMtni32RKDrk7C1LiS3PsbmtVFXmFXl3Ck3XYJG7OWTDNGNopbk4W
         IMOsDtDREjr1DN224ekuy/4QJsIe8cBlcA9cGqyr0NWATQNBuFmiCIN1ngmY6OloAF64
         /CbQ==
X-Gm-Message-State: AOJu0YyYafQW1TurfmNdePDl7UKyBs76dd+GOh4dd8ZP6Zx66Pr/uepC
	d69whjI2JFRJcVh5YKII2hYw2FZcXTRKVNEwKzKRc486MCLRu9lUZxFzGC0BmEmTN+wsUokfKuJ
	SLw==
X-Google-Smtp-Source: AGHT+IFfJvKXPAF6nK7osNErDMb0tU9m4CZX5bmW6NnyQFFbG/iPCvr7Qm9PYR9AVkiifLTpXumq87WxKuE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:340c:0:b0:719:ae7d:9f2e with SMTP id
 41be03b00d2f7-7b746ba799fmr2825a12.2.1722537296466; Thu, 01 Aug 2024 11:34:56
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-1-seanjc@google.com>
Subject: [RFC PATCH 0/9] KVM: x86/mmu: Preserve Accessed bits on PROT changes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This applies on top of the massive "follow pfn" rework[*].  The gist is to
avoid losing accessed information, e.g. because NUMA balancing mucks with
PTEs, by preserving accessed state when KVM zaps SPTEs in response to
mmu_notifier invalidations that are for protection changes, e.g. PROT_NUMA.

RFC as I haven't done any testing to verify whether or not this has any
impact on page aging, let alone has _postivie_ impact.  Personally, I'm not
at all convinced that this is necessary outside of tests that care about
exact counts, e.g. KVM selftests.

That said, I do think patches 1-7 would be worth merging on their own.
Using A/D bits to track state even when A/D bits are disabled in hardware
is a nice cleanup.

[*] https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com

Sean Christopherson (9):
  KVM: x86/mmu: Add a dedicated flag to track if A/D bits are globally
    enabled
  KVM: x86/mmu: Set shadow_accessed_mask for EPT even if A/D bits
    disabled
  KVM: x86/mmu: Set shadow_dirty_mask for EPT even if A/D bits disabled
  KVM: x86/mmu: Use Accessed bit even when _hardware_ A/D bits are
    disabled
  KVM: x86/mmu: Free up A/D bits in FROZEN_SPTE
  KVM: x86/mmu: Process only valid TDP MMU roots when aging a gfn range
  KVM: x86/mmu: Stop processing TDP MMU roots for test_age if young SPTE
    found
  KVM: Plumb mmu_notifier invalidation event type into arch code
  KVM: x86/mmu: Track SPTE accessed info across mmu_notifier PROT
    changes

 arch/x86/kvm/mmu/mmu.c     |  10 ++--
 arch/x86/kvm/mmu/spte.c    |  16 ++++--
 arch/x86/kvm/mmu/spte.h    |  39 +++++--------
 arch/x86/kvm/mmu/tdp_mmu.c | 113 +++++++++++++++++++++----------------
 include/linux/kvm_host.h   |   1 +
 virt/kvm/kvm_main.c        |   1 +
 6 files changed, 99 insertions(+), 81 deletions(-)


base-commit: 93a198738e0aeb3193ca39c9f01f66060b3c4910
-- 
2.46.0.rc1.232.g9752f9e123-goog


