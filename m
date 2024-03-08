Return-Path: <kvm+bounces-11402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4663A876D3B
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE71B1F2256C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC5A4E1CA;
	Fri,  8 Mar 2024 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+jT/85W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955944CB30
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937437; cv=none; b=QsNEVQIKOW7aKlTCGteSJNQ+8XlAYrn9KXrrv+7BxgccAANf1ImxhKylU0TlrzNMxUeXxZgkxQc7RkSC3DvKte2zHDE2oMeKgxNzyBW2fxDbecQdb7uqJs/4Fak2rUokggrcznC++8kvKEPfSC7rYdvCEA2L/oH54unUGRV2Eo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937437; c=relaxed/simple;
	bh=GVX9GtS2jO4/AU5ZUhjw99ZSzSSyUs5GF9Sj/L1TvvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZYTumNxSvLkEuedRgM0JhcSvJJZ5/qzoKosxwIQgXH3CsRPdY3WCGB2WPxL9gahda7+JMi/It6igp14p3EexQaCEIm1FzMc5xfMBQMlNsq1jQg+/c+Pa1k1hlsXbczXaL0QfaDYMqG9I0aT6Q4xnxYh3vlTxzqY6awJuxUVvi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+jT/85W; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0b18e52dso9006037b3.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937434; x=1710542234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fwit3zPKPJowboW07esGbJJ/DYpDWWtu6UvUgXB1DWM=;
        b=T+jT/85WHeyh31C294RG2Gp1ZTx1B/QwduP0mMN8GOE4ZxdWO6hjtQgDtQgUl4DSVf
         ux83wmZ9qYhdaTx4L+UWTYllb0g/eNg/xEIlXe8hlLkI8ZXpgyaiaNBTP+Ti99JKoOEb
         E8fgIsCLOBhT9LZOqhUIUFltq5s3u3ZXbCKq8LNamIF7+9oj1bIdGhgvYTbPtnYZwiHI
         W2MKhkAmOz7fmN4iBhhJJUbeLMqxNtQxJJ3WDKaYZdGospL215qNdkmOqajfV/ZQjA1x
         HajY+4rAhy23nXeWVbvl9YVA1NEB+WjugXD5b+Nc1Gww8jnm1VDvbbDZ0TteKflCBGyP
         FAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937434; x=1710542234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fwit3zPKPJowboW07esGbJJ/DYpDWWtu6UvUgXB1DWM=;
        b=Kqm9IrKKD9/NwA3P3dcIzmwDd39Bp+IUdE6ZtZ3+0/C3g5aj8C7CNee2JG2IWnkWoo
         OzgyzLKXOtQfUzTjNRrWzc34iaZFDagQmd5HOZxfvf7qqzrNKGI85+3YbkysqkUWIjB+
         J9uffGxdnhgYAHz28EEj1RQoI/my62p7z5gXTM7Q7NqBWRPNk+emf2+oWJykf099Nxxj
         a45uxMX1xbfkFQiDpNyWdCPGhsBxEyjKS47I1SfPGR8HUCOKMDQgiNOYQqWbaztZuROr
         df88O+FwYXAKJrnMwqHWyJ1v6ZyhTLK1rcruRDhZjFQdntLXUl8mKQ32/TpcQaGRVJUe
         EEVw==
X-Gm-Message-State: AOJu0YxwiYYfiksiH5ZVMdsRDJQ8r8KeAn0C7ENUlyg0xZwBGqLFmvdP
	2egvzD2Ix9tuOmyz6tIKGn9frlIvm3yI3xq60TCMBsQ50iejXV+a4zfEJvL6/3vPUI1lsVGk4z1
	Ghg==
X-Google-Smtp-Source: AGHT+IGBKyIAz2GkM/hYToD+b4J4B0JxtCkZlF2tzy9ZBMWHuA2MNbKVsDAFZHk3Wu1kNz+HN+Z3cV9xbIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cc8a:0:b0:608:b6fe:9616 with SMTP id
 o132-20020a0dcc8a000000b00608b6fe9616mr142198ywd.2.1709937434784; Fri, 08 Mar
 2024 14:37:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:57 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The bulk of the changes are TDP MMU improvements related to memslot deletion
(ChromeOS has a use case that "requires" frequent deletion of a GPU buffer).
The other highlight is allocating the write-tracking metadata on-demand, e.g.
so that distro kernels pay the memory cost of the arrays if and only if KVM
or KVMGT actually needs to shadow guest page tables.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.9

for you to fetch changes up to a364c014a2c1ad6e011bc5fdb8afb9d4ba316956:

  kvm/x86: allocate the write-tracking metadata on-demand (2024-02-27 11:49:54 -0800)

----------------------------------------------------------------
KVM x86 MMU changes for 6.9:

 - Clean up code related to unprotecting shadow pages when retrying a guest
   instruction after failed #PF-induced emulation.

 - Zap TDP MMU roots at 4KiB granularity to minimize the delay in yielding if
   a reschedule is needed, e.g. if a high priority task needs to run.  Because
   KVM doesn't support yielding in the middle of processing a zapped non-leaf
   SPTE, zapping at 1GiB granularity can result in multi-millisecond lag when
   attempting to schedule in a high priority.

 - Rework TDP MMU root unload, free, and alloc to run with mmu_lock held for
   read, e.g. to avoid serializing vCPUs when userspace deletes a memslot.

 - Allocate write-tracking metadata on-demand to avoid the memory overhead when
   running kernels built with KVMGT support (external write-tracking enabled),
   but for workloads that don't use nested virtualization (shadow paging) or
   KVMGT.

----------------------------------------------------------------
Andrei Vagin (1):
      kvm/x86: allocate the write-tracking metadata on-demand

Kunwu Chan (1):
      KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()

Mingwei Zhang (1):
      KVM: x86/mmu: Don't acquire mmu_lock when using indirect_shadow_pages as a heuristic

Sean Christopherson (10):
      KVM: x86: Drop dedicated logic for direct MMUs in reexecute_instruction()
      KVM: x86: Drop superfluous check on direct MMU vs. WRITE_PF_TO_SP flag
      KVM: x86/mmu: Zap invalidated TDP MMU roots at 4KiB granularity
      KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in invalid roots
      KVM: x86/mmu: Allow passing '-1' for "all" as_id for TDP MMU iterators
      KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs for GFN range
      KVM: x86/mmu: Skip invalid TDP MMU roots when write-protecting SPTEs
      KVM: x86/mmu: Check for usable TDP MMU root while holding mmu_lock for read
      KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock for read
      KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock for read

 arch/x86/include/asm/kvm_host.h |   9 +++
 arch/x86/kvm/mmu/mmu.c          |  37 +++++++-----
 arch/x86/kvm/mmu/page_track.c   |  68 +++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 124 ++++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +-
 arch/x86/kvm/x86.c              |  35 +++++-------
 6 files changed, 201 insertions(+), 74 deletions(-)

