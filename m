Return-Path: <kvm+bounces-26881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E96978C58
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0013289B49
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07AD101DE;
	Sat, 14 Sep 2024 01:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSNy2BAU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384E8F7D
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276435; cv=none; b=B+LKCG6jsv+UpU149wP0Yyx+6i2+wLyctPjz8XZQcqxGdwKep18vx1CSsrEjHU7OUVjcQAgjxkW/DoPGxeXabM2HK6T4ZfLTtoYl2deu/t7Y0mVzyIsvCBkSaivBacy2CCl7c0UxbI0ZlO1ZK5YMkW9c92wXWikXeZyH9+eD5R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276435; c=relaxed/simple;
	bh=T2hW29h8skrSkyoDrreieEmS4pHMZX2hsih2uQ1npPI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nKbdIudPp9aMW14OrW/YLWiaOkMMt23g0DifnhWxaLBe0daWyD2zrmytNIlBOWP8e5r4oe9dEN8YDlv92F4sKSHUbCCsDE7ORVS/ZapGqruFgvko6WRRgFMp3gWkmfGIk58A8Zb60YX8jMoTMiBj4pyeKP8ppupcLCS5cFEnEmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSNy2BAU; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-718f3c2fcffso3006694b3a.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276433; x=1726881233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fu1lJQIk1SxidLzABb6bHetcQ95RLQKz/MriSuP5pQY=;
        b=bSNy2BAUMF+GCNk25MOqhO/h9uNbLSValjlAKFXsn/rnyYUGd/dKgVlA1efxOkobOo
         yzfNA4oAfnL3Qr+X0jjlMHnbgRxMzTzsXFDZhnA2JWLPlt2OMhBpOuWz2iFif0DReSL3
         xJpf8JgeeeO/WEpw6f7GFe3QC7uFT9EhdvjVt8V60krvSTPiBNpjCgvp3t5WSdIHvqTH
         co+8AgtGzBHLqARTN8/dlXlyxIlU+HxXigM1XwkJn3h8PlhLbsWyY55/aMzH68xzNHGd
         a96yftGGL+t5/weeJdQUqSEmXoaruBvVCV8eRH+MdW9LwzcL7W+8lqmnaghDoO0Bd/7f
         KY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276433; x=1726881233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fu1lJQIk1SxidLzABb6bHetcQ95RLQKz/MriSuP5pQY=;
        b=JkL6DBB7G/mfjTRQY4u/0rgsDSOQxxAgTsQWpimhLioNtHC3X7vgKCRXDyG9UxKdq1
         fGSRZEkcS1bIpcoRa/3TZAcIzZTC+6FEhBmusmCo/DM/2iF4DQco4ZL5aArzPidtQIGm
         nhmc22YTQZkrOjn01ohBmc4HHlv7VBOUo66/7zZsrd0RwFB0sCx++hzN/5MeuOuKZrWa
         ssj26Ox1PzN1Rn3HRAbZdH1bba/5B/p39MBW8hw4MlghFOqD8DDv0dOjDDr/oLkYm2OR
         YPp0F587J9GYRLhanxflQCmrok17C9LXsQ4vmZeLZWkQA97s81kvqqMsHYXRnB6J199P
         sORQ==
X-Gm-Message-State: AOJu0YwjfNDAnC1rkivL3RDg4CONoQYSccs/xZwDWWNDpsS7tbw42+DR
	WLcP48Kt6CEwqFnQvtgu7DR4dNu5MDAIH+lIjEA+WYJpRAL4r7PmpuToHHzlJSMKuFxo/c3NtjQ
	+gg==
X-Google-Smtp-Source: AGHT+IH8rQjPjbp5zSN2JMQOhZ/vVxvfwF1dgYZlM5w4lgYR/xpXDhryqPTeA7Z1Y91dEAiRBkCjLgar6YE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6419:b0:70d:1285:bbcf with SMTP id
 d2e1a72fcca58-71925fa7878mr42743b3a.0.1726276432730; Fri, 13 Sep 2024
 18:13:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:42 -0700
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Common changes for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a long-standing goof in the coalesced IO code, and a lurking bug in
kvm_clear_guest().

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.12

for you to fetch changes up to 025dde582bbf31e7618f9283594ef5e2408e384b:

  KVM: Harden guest memory APIs against out-of-bounds accesses (2024-09-09 20:15:34 -0700)

----------------------------------------------------------------
KVK generic changes for 6.12:

 - Fix a bug that results in KVM prematurely exiting to userspace for coalesced
   MMIO/PIO in many cases, clean up the related code, and add a testcase.

 - Fix a bug in kvm_clear_guest() where it would trigger a buffer overflow _if_
   the gpa+len crosses a page boundary, which thankfully is guaranteed to not
   happen in the current code base.  Add WARNs in more helpers that read/write
   guest memory to detect similar bugs.

----------------------------------------------------------------
Ilias Stamatis (1):
      KVM: Fix coalesced_mmio_has_room() to avoid premature userspace exit

Sean Christopherson (4):
      KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
      KVM: Clean up coalesced MMIO ring full check
      KVM: Write the per-page "segment" when clearing (part of) a guest page
      KVM: Harden guest memory APIs against out-of-bounds accesses

 tools/testing/selftests/kvm/Makefile            |   3 +
 tools/testing/selftests/kvm/coalesced_io_test.c | 236 ++++++++++++++++++++++++
 tools/testing/selftests/kvm/include/kvm_util.h  |  26 +++
 virt/kvm/coalesced_mmio.c                       |  31 +---
 virt/kvm/kvm_main.c                             |  11 +-
 5 files changed, 283 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_io_test.c

