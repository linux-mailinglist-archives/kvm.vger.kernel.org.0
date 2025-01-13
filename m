Return-Path: <kvm+bounces-35330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A2AA0C4A4
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A753A25C5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05F61F9A96;
	Mon, 13 Jan 2025 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3sG6Gmt/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B721A1D63ED
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807264; cv=none; b=MvhMKufgpVYvxGld3w7IY3SQLTyKfR+Pi/qZv/HYYLofWaz8ZGkcmP6QMaqWeOxDyZx1UM8Ggtms60qLuOrrqyfa/dJwFoAT3DXC1QrRq+Zaw3+s+aEoGaQEo855dk3+hZRMeOAQSyN/8xBINaTvesYOZs0XfpEH1KVKFjj62go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807264; c=relaxed/simple;
	bh=G6s4il+HTEjH1+mBSKzLW1bnaCwMPfxw2+6anvDsJfA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=r3mcNgAU1EMIDck7M5+YwUpq6yQN/PcFlCUKLUppa3qS6lWEy+ap/X5rop3jmWba6FjiFiihhlwecvCqHDgfu7oDXuhdt+7KFmZ8Iaq3VP+eTvXXsG1Gmf6xPilBJ/muxkaDt+1I+XGU4uLX30DR+0OvQjLybwAwJPBhEQAA9Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3sG6Gmt/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f5538a2356so8331507a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807262; x=1737412062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H88G7WcO0+Ex4ikgQhGeo2P+380k0E/7XkNU5q2xxQQ=;
        b=3sG6Gmt/tDgr7OZSdp5n3iRuo6QckuAYPns72pzX6oR8EAG1kV8QEBbH3cx1EAaAaM
         PKW9pJA8T2dffAJFyMbjnKNtiC1jIwRadcENLvrWvZgZsEqXieqgrEUs5Gt4obkq4TSX
         76buL6mqvPmvMbqNxWVZMDTfKAIe8UGIGAXSosH5eZzgyanoPq6i2EJ9JIcz2p6irxmd
         3rt3os9UmT5lpyRrNT5vRdm+nYNnf3GyQ5RvnIT/JrXHlkNYaqymw3H18nYQDK+Ypvw/
         dERnTS7fYcgz2010grEw3fdMGLmrf9h3ZvB32gMBC2zDacesyMkRgFxgbTRg7VUFp2e8
         fcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807262; x=1737412062;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H88G7WcO0+Ex4ikgQhGeo2P+380k0E/7XkNU5q2xxQQ=;
        b=uYzc8CLflWgC2aN9mSmquIuIRZfCWUfz9oDeXM5n3qd8mU64pUfcbH9mQPFV2oIhOd
         NPogXlWLpuowQGEOtkr+jVScmwVXvYYMmP0MFtp40GiSXaNhsW6qwTEU7ATJ34yiPOBj
         WPrSbxwCBX28hSH5LNlORwip81GZsXYagy3Ri00HI4wmQ0QXR1Xul3owlQ7d4Kq70oFW
         Y9+UpWCc2J7Gc6mko227TOpbIIFEexf8zjIfQnzLufntACxxzUy7BDsvPR7rVZID1YTC
         u81eIOiB54pzhzVxok7Q5tvqq+SyXN4jYg0GR6bXD6oBKE2hWmsCvvV+1xiQbS8t7K9h
         GP/w==
X-Gm-Message-State: AOJu0YxGFPIxihaFFN8FZyBq2WBpYY0bcWE0MqX651zbGDSdfKkVtpKI
	k3upGtb7ChHMbFc0znsX7pZBDXKmEDsTSzqprD5CZh2SyP2Wan9PHsR2tAKZuXZGbtt1Dys6Irv
	fgw==
X-Google-Smtp-Source: AGHT+IEX9jn/OAVW4Q+F9oEwFxnWbUwkEqxXkmycawfttoixuTJZZGDcKrcsM0IndXLgAhcHkLxu50vsyXY=
X-Received: from pjbov7.prod.google.com ([2002:a17:90b:2587:b0:2f4:3e59:8bb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8e:b0:2ee:fdf3:38dd
 with SMTP id 98e67ed59e1d1-2f548f58126mr27213228a91.23.1736807261980; Mon, 13
 Jan 2025 14:27:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86: Hyper-V SEND_IPI fix and partial testcase
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
Content-Type: text/plain; charset="UTF-8"

Fix a NULL pointer deref due to exposing Hyper-V enlightments to a guest
without an in-kernel local APIC (found by syzkaller, highly unlikely to
affect any "real" VMMs).  Expand the Hyper-V CPUID test to verify that KVM
doesn't incorrectly advertise support.

Sean Christopherson (5):
  KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't
    in-kernel
  KVM: selftests: Mark test_hv_cpuid_e2big() static in Hyper-V CPUID
    test
  KVM: selftests: Explicitly free CPUID array at end of Hyper-V CPUID
    test
  KVM: selftests: Manage CPUID array in Hyper-V CPUID test's core helper
  KVM: selftests: Add CPUID tests for Hyper-V features that need
    in-kernel APIC

 arch/x86/kvm/hyperv.c                         |  6 ++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 41 ++++++++++++-------
 2 files changed, 31 insertions(+), 16 deletions(-)


base-commit: a5546c2f0dc4f84727a4bb8a91633917929735f5
-- 
2.47.1.688.g23fc6f90ad-goog


