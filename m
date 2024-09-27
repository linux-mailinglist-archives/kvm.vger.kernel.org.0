Return-Path: <kvm+bounces-27595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57879987C16
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 02:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 007D31F24847
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243479443;
	Fri, 27 Sep 2024 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GcPQmhuf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63C3D76
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 00:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727396200; cv=none; b=Scgvuw2GbkYX5RcG2ZUunJwGHIBjyMdTFR4K8X0Zp/IpgRQjhiUtyKsP/AuHrt2Dge63g0y83cbR5Msu8Jl3uNcS24s1C7QzAVOKJ8G0maZHvfAq7Z9q2R5Oxg0L6P7uCJFUs29BZN0prk5yHw191VpjN+9EgMLQGcFa6bVIKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727396200; c=relaxed/simple;
	bh=nIxeTXxGGQjEBlelYqFPvijuUWME89+Fmvop8JAmy4Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hi7SRl3QLPgFldJRqygSjDRowcrfvTi6AOkEb9YmaMzSZIraTzTpUHa6DX2NfmE+g2qpXIOCN45tHUehhxJPwKbmUr6lHSjwkT7p6MVTAp9oCawGbRfG6BW7MoPhmzN7RCTzCwQbglJp8U5yid8m3oSC1SG/H6kIR1/urI4C/1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GcPQmhuf; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e211e439a3so30335857b3.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 17:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727396198; x=1728000998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLwc/o+7cH7XPxXeSLMcfoSZw1o18ZhJwMSoa9iVLmM=;
        b=GcPQmhufRvgxBPO3XgTnpdS0x3C/vou0NCiZu4etVvp95ONQYjP8+Dw5MpS5vR5uwn
         8LIU+iBTgH8aVDWrIuONUIh32I/WTIUiCmNeXoLJCK6CLxrYYmoL9mnHwmJ0+1zuzAL1
         qkdKV6M033rhM3jL1bBhQmaQ3XMFy9CPUzGRJboI4WzaSyj76Bh8MurjzNf273Hr/ulO
         NXcskLqqvKFjrpxJH1MmBm2a7oiUhzt12ITUSv9r4aUlVlqumaSaQ7G2GyIBIF+T911P
         Yn6/8B3gKxCLxvBPamDoVac+01lBsGzpjCnAWTuGYXE8AJIlfVdU3vjDYU7wwr8CAZVl
         gWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727396198; x=1728000998;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLwc/o+7cH7XPxXeSLMcfoSZw1o18ZhJwMSoa9iVLmM=;
        b=vqvLeDE+9ANnxMkHo+wWGIgsVdomcmL97Tx4pJ1ZDukdGS9arFw38O00efkvjoiywb
         gvfyKgDQpF0j+DftWyi+H9LmsxahosK3VABoG8tiHs3YGMpww0Wk5h+UufK4l27Ri88X
         gICe2pxrg5VmvCyqnzGUHpnzCGU0abZGMf2JdjWeCOn1sgMgPNfqX5Fd9YK/puuOWUAq
         b7y8Ilj5huk8bzXST4f3i060JETPHAXJXzwJD83XBbK6VRvWkTTQxUtMN/QnuaFotDwh
         5Zc2DvZwPRuBK97BdiJfYlxD9HtmYBIDg0qfshfsk4whk8vnbuqqLUyvPLBKTvrObeYn
         b0Sg==
X-Gm-Message-State: AOJu0YwfvYoqOM6spNDGt1HQofT8Nflva8vk6JU1lkjl8b4nHZfhUTkX
	PvcRUhqHm1tJ7WIObfFiedDahhoIUoGFhxtCy4fDnnm68AP6BrY5GeXL9Jze35XL+tB+XX/hHwZ
	tgA==
X-Google-Smtp-Source: AGHT+IFmZajpMlo/zht2oqoaULVtzYE5c4I1ZrZ+kOJ8bCz1I1wNn9YfpkNI7N2L3QPm3qTvr+6e9lhsryQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:504:b0:e17:8e4f:981a with SMTP id
 3f1490d57ef6-e2604c8fd7emr1233276.11.1727396197787; Thu, 26 Sep 2024 17:16:37
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Sep 2024 17:16:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240927001635.501418-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: x86: Revert SLOT_ZAP_ALL quirk
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Revert the entire KVM_X86_QUIRK_SLOT_ZAP_ALL series, as the code is buggy
for shadow MMUs, and I'm not convinced a quirk is actually the right way
forward.  I'm not totally opposed to it (obviously, given that I suggested
it at one point), but I would prefer to give ourselves ample time to sort
out exactly how we want to move forward, i.e. not rush something in to
unhose v6.12.

Sean Christopherson (4):
  Revert "KVM: selftests: Test memslot move in memslot_perf_test with
    quirk disabled"
  Revert "KVM: selftests: Allow slot modification stress test with quirk
    disabled"
  Revert "KVM: selftests: Test slot move/delete with slot zap quirk
    enabled/disabled"
  Revert "KVM: x86/mmu: Introduce a quirk to control memslot zap
    behavior"

 Documentation/virt/kvm/api.rst                |  8 -----
 arch/x86/include/asm/kvm_host.h               |  3 +-
 arch/x86/include/uapi/asm/kvm.h               |  1 -
 arch/x86/kvm/mmu/mmu.c                        | 34 +------------------
 .../kvm/memslot_modification_stress_test.c    | 19 ++---------
 .../testing/selftests/kvm/memslot_perf_test.c | 12 +------
 .../selftests/kvm/set_memory_region_test.c    | 29 +++++-----------
 7 files changed, 13 insertions(+), 93 deletions(-)


base-commit: 3f8df6285271d9d8f17d733433e5213a63b83a0b
-- 
2.46.1.824.gd892dcdcdd-goog


