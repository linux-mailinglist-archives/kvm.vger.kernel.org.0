Return-Path: <kvm+bounces-25395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B697964E70
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0386D284CA1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8A91B8E87;
	Thu, 29 Aug 2024 19:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xjgaxDK3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCFA1465AB
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958701; cv=none; b=jbfsHIhVZvNk64Io4W8f7WvZL4tV3k20chMTHbKI9HuIduRb92nuUx4XPTj5cNfZ9mQDrG2vBwAyE+r+FjzVfMGqLPrTXvtWscAYpcnwYX/cseGSWcMad80Ck3Jj27lTnW8dNr7rSCXYg+PNxFXOlYR/L9zksYPZiRsCSkPOEy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958701; c=relaxed/simple;
	bh=9ox/zUiQ79M7vwxUB7uAMR7Luybc2qdrTo+dCWXL4zc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Z356dK4DpsCPA9PEoZNuB0s3kF11W+e80h8MFZK6ww+2RnQiiUTsEYhvELje0URBMZP7kXilsczG0w6BlQFXWkKmvJlI3KPYK/cuHTZNMn2+C9FW5qtvYfd35/hDmHlD7fmZNSybUSeR2AIQDfSjXmv3HXdHMm4jtDoe7npy9ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xjgaxDK3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b2822668c2so21153267b3.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958699; x=1725563499; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v1a2GwNMFZtV+1SGv6UQ8OK/j1fw5mIkgMyF+JmvsP8=;
        b=xjgaxDK3ZwWDBOyAi96Jirmp0Aei8vfBoiNheItqKwou/8k5rQ4FxwdCD48ASEpbZF
         kWhv4Njl0pv5DPO1mN4GIxm5W11MGdoNedNhtnTZqXywENm0wz4Hd7Hcl2d1GmoILsnB
         AIoehWvV9/mm+BHRdDXzNoJUpcHJsof0YwMdvAZq4MRBdiekodboollW5zQHHiKvTiQK
         qZGzoM2LC4kPh4c3txOGmS2yLISoWNLj5HfcJUMZOjAZApRVRaCoVjy6G+QIr92fIqgY
         qwlgARpYgTt+hGniwEtZ8MpuaJKu8PDmRvW8xTK6thTeqjIIsgJ85pzn6FAmq6NBQOyh
         4MEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958699; x=1725563499;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1a2GwNMFZtV+1SGv6UQ8OK/j1fw5mIkgMyF+JmvsP8=;
        b=ESPxWbqZS0JYxIIpg5YYOfuyjtAdGNberK68VVdigj8m+d2/23OxDp/hzmE5Sxaaua
         7tsXafN01yMxHZqdUJLse1JjrLYf9kFG1CbTNN0ygCxPIR5Az9aBsZQwxQ8BA6uJnW4M
         8QaZFaj0rZJyFLsUh7B9HRCHneMuNfNHS23FllY3wICUwvnVLrqbQRb2as95iW5TGZLg
         n5FeLBU+igXxizJNy1Z+K7qYVYI1S73vfYw22U7GlI2SrDXQ7/5mWFskiD1TTQ6d5+kC
         NuAnxQTcr0kpMCgNrADpkZyuG4527dcBzueKhmJUDupkt2ZFIoG0erFlp4g+Sj0olkYo
         czzw==
X-Gm-Message-State: AOJu0Yyjc1Mo0iLlsB2FcVW70I3ZSHXE63unhd+j7LUFEj0q14gwWfJi
	gedwAchLU180xeaU9y+DjE06tVvsNJ1jRMPnz4R1/BoelsNku0kDWDQdCm5U4zG4UAnqvlMDUBh
	NWnM1jw==
X-Google-Smtp-Source: AGHT+IFsu0tqq1k3ZGpatQc8i7RrU0gs2eFt1itqCzLQHBoKohcpEOjlXsjW8OwFWwhZYJs028y4MzhZjCwc
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a05:690c:6201:b0:691:3acc:eb2d with SMTP id
 00721157ae682-6d2e8feb16fmr603267b3.4.1724958699211; Thu, 29 Aug 2024
 12:11:39 -0700 (PDT)
Date: Thu, 29 Aug 2024 12:11:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191135.2041489-1-vipinsh@google.com>
Subject: [PATCH v2 0/4] KVM: x86/mmu: Run NX huge page recovery under MMU read lock
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Split NX huge page recovery in two separate flows, one for TDP MMU and
one for non-TDP MMU.

TDP MMU flow will use MMU read lock and non-TDP MMU flow will use MMU
write lock. This change unblocks vCPUs which are waiting for MMU read
lock while NX huge page recovery is running and zapping shadow pages.

A Windows guest was showing network latency jitters which was root
caused to vCPUs waiting for MMU read lock when NX huge page recovery
thread was holding MMU write lock. Disabling NX huge page recovery fixed
the jitter issue.

So, to optimize NX huge page recovery, it was modified to run under MMU
read lock, the switch made jitter issue disappear completely and vCPUs
wait time for MMU read lock reduced drastically. Patch 4 commit log has
the data from the tool to show improvement observed.

Patch 1 adds a little bit of code churn which is removed in Patch 2 and
3. It was done to make tracking NX huge pages separately in a separate
patch and then later split common recovery worker code.

v2:
- Track legacy and TDP MMU NX huge pages separately.
- Each list has their own calculation of "to_zap", i.e. number of pages
  to zap.
- Unaccount huge page before dirty log check and zap logic in TDP MMU recovery
  worker. Check patch 4 for more details.
- 32 bit build issue fix.
- Sparse warning fix for comparing RCU pointer with non-RCU pointer.
  (sp->spt == spte_to_child_pt())


v1: https://lore.kernel.org/kvm/20240812171341.1763297-1-vipinsh@google.com/#t

Vipin Sharma (4):
  KVM: x86/mmu: Track TDP MMU NX huge pages separately
  KVM: x86/mmu: Extract out TDP MMU NX huge page recovery code
  KVM: x86/mmu: Rearrange locks and to_zap count for NX huge page
    recovery
  KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

 arch/x86/include/asm/kvm_host.h |  13 ++-
 arch/x86/kvm/mmu/mmu.c          | 135 +++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h |   3 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 122 +++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h      |   3 +-
 5 files changed, 204 insertions(+), 72 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.469.g59c65b2a67-goog


