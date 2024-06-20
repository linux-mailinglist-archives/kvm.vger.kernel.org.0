Return-Path: <kvm+bounces-20187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FEF911669
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 645EF283C49
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA9B145B38;
	Thu, 20 Jun 2024 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rZ/M6iEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66C143C58
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924982; cv=none; b=uxg1penuvMnku2EiRaJZddR5/wzMN9cqV1Ds5GDBrAMaYb7yl/wZE8NKXi2we25gRxxa6XLf0gUHnwUKZ0/4CSqJJTNoTeUxRMnNUe445h2k4JYMLv2B5rV2icWJy0lKmX19FDHd7s1B+ffAdUBVj7hDlxMt2UlLWHEL2vo0AKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924982; c=relaxed/simple;
	bh=wcE7lUcKQT7nvY7j7pMAzqhmBw7ZkfZnS65Oz/KKHl0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZDPydh8+pTzHREU3jcPIHaArr4Jl4SszBVlhx81dL37MC3vcTdTfNiAgnCVmAI/Rg0t04T1TgvKxsYvlJBxuVWvp+cp4oeIXDHzK/Zdzq0XLUsfsPCdkHJHXzq3JRHMb6QypMe1pqch5JbA41tUtwf9+08B7+TGcfGzvJeFuiTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rZ/M6iEP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-705ddabb4deso1173696b3a.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718924980; x=1719529780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=do78yRWtKWQHcPshFaWqeCkG+PVmgM5EqdLv5pgRaQ4=;
        b=rZ/M6iEP0NkEeSQj1ZW6TupHFIbhmgpobwYdS1mChIuKCoBCNu21WeIFciIeAy0Smb
         Fnb6Y2L1otCaZAaashP011NCs+IEUZmTPD+WS762+FRDWhKWqouBiho4//atFvC0OHx1
         80fUo4bACwEpkzoFztGLVOZBlON4WZy6ePXDfIKTPXpQ+tTurxWMybFYoElR9lA2CzU0
         sm5Fs08tVrwlCIG7RlE5NrhjE85Zn3UoPdD3Amw45vLzgPzlIPts18sxJCFxmTazQQqD
         hUeB5x/zW2kLsd8qPfkSoHy0fBnwSd36O+hb1SqlEMHiE/5keAesHQtxdeyJnoT26+2F
         ql3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718924980; x=1719529780;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=do78yRWtKWQHcPshFaWqeCkG+PVmgM5EqdLv5pgRaQ4=;
        b=KHuTdVdnnDqzJxS5ErPfPifUG8028s4cWl10LMy4JtuJKc7grwstWk2DEvUemal0jb
         s50EG4rS5lm4xGs2TiRGdV/rxTFFdNh2aRUnXQ6pJ11g0M6YTLHDIZZL2ojJNehJUsCm
         zYNkmZfPWLM+8GjrviUIwlTAV7+ZKFbbKdGuTDpy68/ywFH4ANFBkppLrDUOQTkEW4ZK
         lUrh8OLvTOCR2g7jGT4JVgAqFmew7YBsBsLE01sNfhtQO9a6Yrrm3qevZDfzHjIa+nAn
         BHPweoZbd9PbCcnqjFEe4YbyhlLIbs7Rhgy4TB110n4FgN+WZWNwC3qciJTLy1qBUdpJ
         3oMg==
X-Gm-Message-State: AOJu0Yx5fnc5VuMlTVnlQ6wLUbzSvEa9F8x3v4rI7MBdk34F6XkeqVLy
	4VqfMg2WxBiALDQAq/dumUOO+cKV09TWRUgEK3Ye57g5VcDBVbzc46AI1zo+R1NeXexGNnQkI7a
	9cg==
X-Google-Smtp-Source: AGHT+IHDpiehebxGn1u6p68ueFmNnsE7dxQCXrS98i3HaCdfQP+PnZXIIi7CBuCd9uDC3ivOVpWwdCBzPmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9082:b0:6ec:f400:95a7 with SMTP id
 d2e1a72fcca58-706291b7499mr58515b3a.3.1718924980083; Thu, 20 Jun 2024
 16:09:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Jun 2024 16:09:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240620230937.2214992-1-seanjc@google.com>
Subject: [GIT PULL] KVM: Fixes for 6.10-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two selftests fixes and two KVM fixes for 6.10.  Only the kvm_vcpu_on_spin()
fix is tagged for stable@.  I deliberately didn't tag the mmu_notifier issue
for stable@ as I'm 99.9% certain it can't actually cause problems (other than
making UBSAN sad).

Sorry for the late-in-the-week request, I have a feeling I missed your window
where you're working on stuff for this week's KVM pull request.  :-/

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.10-rcN

for you to fetch changes up to c3f3edf73a8f854f8766a69d2734198a58762e33:

  KVM: Stop processing *all* memslots when "null" mmu_notifier handler is found (2024-06-18 08:51:03 -0700)

----------------------------------------------------------------
KVM fixes for 6.10

 - Fix a "shift too big" goof in the KVM_SEV_INIT2 selftest.

 - Compute the max mappable gfn for KVM selftests on x86 using GuestMaxPhyAddr
   from KVM's supported CPUID (if it's available).

 - Fix a race in kvm_vcpu_on_spin() by ensuring loads and stores are atomic.

 - Fix technically benign bug in __kvm_handle_hva_range() where KVM consumes
   the return from a void-returning function as if it were a boolean.

----------------------------------------------------------------
Babu Moger (1):
      KVM: Stop processing *all* memslots when "null" mmu_notifier handler is found

Breno Leitao (1):
      KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Colin Ian King (1):
      KVM: selftests: Fix shift of 32 bit unsigned int more than 32 bits

Tao Su (1):
      KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits

 tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 15 +++++++++++++--
 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c   |  4 ++--
 virt/kvm/kvm_main.c                                    |  8 +++++---
 4 files changed, 21 insertions(+), 7 deletions(-)

