Return-Path: <kvm+bounces-26031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6512A96FCD7
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2F281F24FAE
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7661D1D7980;
	Fri,  6 Sep 2024 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XBpdVShB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC461B85E0
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655520; cv=none; b=JrrGpV2c1NYwRuUMdPP4KhJR0GAtZ+Q6PLbo+ljyyq9y+YNplgg1q5/piokJbx6O1PbewuAulFPSAjMzX9otjcNiix+zSsSc+L3vwpAb+lER+5ynu/NveDvIk+xmjrezU1iTdk37q8O1ScC5RV5icbZIjcBdUPDsIRMZT7C0dXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655520; c=relaxed/simple;
	bh=iRbjlIAPQHgVcCD2c2dVgtd+uOsMNRFeT9Jqbjmu2aM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HNz1+9N4TEqMSwqT2aBekyMddNawBcWAy9J7PMty5G9MqJvtbdEXB8Fg4whl21OHp0esCQqesaiCIBguxTB6lWanleI7mJgmMu+rknNC/qFqheMirWAiWczYfC0lEP4qwtryXYCF5ztv3kWT3RKieGe3335Zdp2l99Qil6eb12g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XBpdVShB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d3aa5a6715so70393307b3.2
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 13:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725655518; x=1726260318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FxzJjxZJGFTOeLvX6J4JiYtbxsEYPquNtnuMoiceNJk=;
        b=XBpdVShB/pF/+yECBGcbNf8/xt5vGjavHUetyXLUAp/4rBGrKk9ebhoONLlNu8sa6D
         /XJoXzlqr2Fmu0PX6e8TbGUsvk0KchtRSk+pmm/DPRC0uhC3jQYbwYnLtwO3rpoEYdRx
         LwstSGA8wrP8iGkFDx6u4dioMZIpukQi2Cc+B/y7K2FKnKu8bxDji+Zx2M3OhLoer2Wu
         Lr4hX/wTffuf0Ze+QmIdZM/jhbzrz1YqR+JV3g9Jd08meit6ROeKLiFBYtohwA6wCTfK
         TVaS/cw9Oer5/3+ybKKYat7Kk9hW1S+k5v3TLT3QsRLy1MWm1osSy7wLpHHFuW59X/uM
         B9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725655518; x=1726260318;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxzJjxZJGFTOeLvX6J4JiYtbxsEYPquNtnuMoiceNJk=;
        b=EWo06MUezATwjCXcy8yIvDJFj525kFHvz5qbyS/K3ktIg7dFVHk1vi5zve3YqNddWj
         m6ev91/nCRIrO+nAaLvnau0kEdH+OV1wXwKeAVlyz2Tb1q3m7PGDKFWU04GWFRbnlqiD
         0jVwAxkTDFP4UCpR1TAXhrARvlVB8bufW7Wg9Lxdyk7sxwxdyKLB6t+GcV0epyylJKud
         dPHFDLG76/Tj2ssIPYDFDcfmiqV7H4xJn5fFuV/CuPpu6qjNtHDOOnl2bmQcLOP4rO6B
         /veZlbvhXOh96Ck2JlcpDID9Ntkzobt8BbaW9ZEu2A1JQ8bTnJW/WSNvPPYGyi/Ivsxb
         WBZw==
X-Gm-Message-State: AOJu0YyjQPOv/60x4tSiXFAo+BSOuyIWRJxRxJx0j8OI5JDmEWioOVOY
	92ESLIVLcdLbj7y1z64HxrAFsiR4dJ/K4VCBTbpJID2Qtdr5872i9O/4ganccz+geFFy1lpmecN
	ufr+1Zw==
X-Google-Smtp-Source: AGHT+IG0qNAr1lsqNhg4aq0ofiYc3K/zZ3QDiUU/Hyw9lPo1OgXRDXdxAC8vOmf5a0/AcpCbqcFFiNpx7JpQ
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a05:690c:3081:b0:62c:f976:a763 with SMTP id
 00721157ae682-6db44c4cd20mr583677b3.1.1725655518235; Fri, 06 Sep 2024
 13:45:18 -0700 (PDT)
Date: Fri,  6 Sep 2024 13:45:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906204515.3276696-1-vipinsh@google.com>
Subject: [PATCH v3 0/2]  KVM: x86/mmu: Run NX huge page recovery under MMU
 read lock
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Split NX huge page recovery in two separate flows, one for TDP MMU and
one for non-TDP MMU.

TDP MMU flow will use MMU read lock and non-TDP MMU flow will use MMU
write lock. This change unblocks vCPUs which are waiting for MMU read
lock while NX huge page recovery is running and zapping MMU pages.

A Windows guest was showing network latency jitters which was root
caused to vCPUs waiting for MMU read lock when NX huge page recovery
thread was holding MMU write lock. Disabling NX huge page recovery fixed
the jitter issue.

So, to optimize NX huge page recovery, it was modified to run under MMU
read lock, the switch made jitter issue disappear completely and vCPUs
wait time for MMU read lock reduced drastically. Patch 2 commit log has
the data from the tool to show improvement observed.

Patch 1 splits the NX huge pages tracking into two lists, one for TDP
MMU and one for shadow and legacy MMU. Patch 2 adds support to run
recovery worker under MMU read lock for TDP MMU pages.

v3:
- Use pointers in track and untrack NX huge pages APIs for accounting.
- Remove #ifdefs from v2.
- Fix error in v2 where TDP MMU flow was using
  cond_resched_rwlock_write() instead of cond_resched_rwlock_read() 
- Keep common code for both TDP and non-TDP MMU logic.
- Create wrappers for TDP MMU data structures to avoid #ifdefs.

v2: https://lore.kernel.org/kvm/20240829191135.2041489-1-vipinsh@google.com/#t
- Track legacy and TDP MMU NX huge pages separately.
- Each list has their own calculation of "to_zap", i.e. number of pages
  to zap.
- Unaccount huge page before dirty log check and zap logic in TDP MMU recovery
  worker. Check patch 4 for more details.
- 32 bit build issue fix.
- Sparse warning fix for comparing RCU pointer with non-RCU pointer.
  (sp->spt == spte_to_child_pt())


v1: https://lore.kernel.org/kvm/20240812171341.1763297-1-vipinsh@google.com/#t

Vipin Sharma (2):
  KVM: x86/mmu: Track TDP MMU NX huge pages separately
  KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

 arch/x86/include/asm/kvm_host.h |  13 +++-
 arch/x86/kvm/mmu/mmu.c          | 116 ++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |   8 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  73 ++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |   6 +-
 5 files changed, 164 insertions(+), 52 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.469.g59c65b2a67-goog


