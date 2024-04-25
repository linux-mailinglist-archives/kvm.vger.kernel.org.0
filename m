Return-Path: <kvm+bounces-16001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B72A68B2DA4
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8DEB1C21C05
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E224156968;
	Thu, 25 Apr 2024 23:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9r6VEVA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B8C156644
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088396; cv=none; b=j/IooCN5TCss3UMoPBOVaQYnUKpr5yYhWLlQcHZ9Xxk9E8Z1lx7+644oDrciYtwOlNSFVdCbhBcrwnbQMcbNueptVdhZL9NWinyuDLAwhyPyPYTbl1Nnhmt7/cCqAqlLw5JaC7s45zKvppsZvaxVOzA1/ZbUZ4DvcXTIBNgt6OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088396; c=relaxed/simple;
	bh=AkCyh7cWOKmp5pK+B1CaZPZ44MY5XL4t5zGDakr0MqA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TPgYmJ1fBTvN8sy341qMLepyXtyBDw9BJM6mG6xcC0NzYccsuwc2pdw0v0Ps3oc9WyQGN8qesCh9M9cAnQtGAgyz/WZHQklolpW/x0XRAdRQvNd7XX3oHOQGnFccuhFvx3bFhp+cNSmN4au3CBN3SHrWlsnLotMBqOHHJyK0qBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9r6VEVA; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc693399655so3014325276.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714088394; x=1714693194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMRbfFNbJCNzsckpGMMH+pZKLS2T8rm0G9EjpmKb1aE=;
        b=C9r6VEVAdy7RzfzH6o3nRMS4N63yrvuoVNG/ao+xMWDah9Nv0BW5/cHYc6aWbR00KI
         sTNfJQ3e/kSf3M+UzEzzHSZou95kRNIYXRXgcAfpymBaMUX++LW77ZL9ScpIMrboRsqA
         hj755zowK3oXtSIuk43xEnhpNbrj2NmboY4KkXO4LUj4rV572Mxe0lXMv4Pp7DUuPG/b
         kvwKl6ILK/It8HDP+agN80+qwd+sTqqHyVm2Yj46XJHQk+DJ2C3Jw7df5WoM5eZSkwWv
         8Xnb6oGDY9Lq8qj9jk0+OEvDQRgaKAW2VtQjlRBtSc2E0l2paiI2WUxlp03rId8IfBdI
         Rldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714088394; x=1714693194;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gMRbfFNbJCNzsckpGMMH+pZKLS2T8rm0G9EjpmKb1aE=;
        b=w7WQw7CSHjTUS5ehRY5Oy8XZy60XsgekIp7v6S9GHavAYPHzGZUC/HWTv2+IJ8VIoU
         0OTpztYwFS6XlHe4BymRCFnlk7F7inr+5xGgBDPGOnO4ldlI3EsjyE4d1BRUmv7UttST
         xrozsYXhTLA4eLH6+9vwT6Wg6AtCIGLx5o4aViwOnt6VihRPafeQhVEqf47p4PzkToQI
         vCvo6EAW+kXK+kCSDcR1QktIL1omPBhTfAZp5jZ1Jo6+uf70X1kTsMmL+AVQBVj+jOHt
         I1+GKBNNG4fZNCbgWb+JoE9nYHfi+MiCOpOjwezO/xYpykfGDp4WjAcatcexGSVyPgEl
         /7uQ==
X-Gm-Message-State: AOJu0Yx9ihAIle+hb8wfvXn1aCQe8PAYjYkQKFNRBFdYcPheMNVAM9UI
	9c+9DlcgZu9T0Bn5EEFr3mRvAtaWDvDgZ1e1rYtpDnvEZIUN6eVJOGu6ZpLF6um2Sa8RPG7MZbJ
	gsg==
X-Google-Smtp-Source: AGHT+IFv/0bOPnuO/M3uRcdFnrVAA8o6Pc8//cgxoEjvcb1rTZaB9AbcU7AC0hZ6XYV2LKHdZbxX5QdY3oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154c:b0:dc7:7ce9:fb4d with SMTP id
 r12-20020a056902154c00b00dc77ce9fb4dmr324447ybu.12.1714088394229; Thu, 25 Apr
 2024 16:39:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 16:39:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425233951.3344485-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: Register cpuhp/syscore callbacks when enabling virt
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Register KVM's cpuhp and syscore callbacks when enabling virtualization in
hardware, as the sole purpose of said callbacks is to disable and re-enable
virtualization as needed.

The primary motivation for this series is to simplify dealing with enabling
virtualization for Intel's TDX, which needs to temporarily enable virtualization
when kvm-intek.ko is loaded, i.e. long before the first VM is created.

That said, this is a nice cleanup on its own, assuming I haven't broken
something.  By registering the callbacks on-demand, the callbacks themselves
don't need to check kvm_usage_count, because their very existence implies a
non-zero count.

The meat is in patch 3, patches 1 and 2 are tangentially related x86
cleanups, patch 4 renames helpers to further pave the way for TDX.

Moderately well tested on x86, though I haven't (yet) done due dilegence on
the suspend/resume and cphup paths.  I ran selftests on arm64 and nothing
exploded.
 
Sean Christopherson (4):
  x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef
  KVM: x86: Register emergency virt callback in common code, via
    kvm_x86_ops
  KVM: Register cpuhp and syscore callbacks when enabling hardware
  KVM: Rename functions related to enabling virtualization hardware

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/asm/reboot.h   |   2 +-
 arch/x86/kvm/svm/svm.c          |   5 +-
 arch/x86/kvm/vmx/main.c         |   2 +
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/vmx/x86_ops.h      |   1 +
 arch/x86/kvm/x86.c              |   5 +
 virt/kvm/kvm_main.c             | 186 +++++++++++---------------------
 8 files changed, 78 insertions(+), 132 deletions(-)


base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
-- 
2.44.0.769.g3c40516874-goog


