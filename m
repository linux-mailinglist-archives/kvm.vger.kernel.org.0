Return-Path: <kvm+bounces-39637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB05A48B7A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FF1E188F631
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D07B27FE61;
	Thu, 27 Feb 2025 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l8WpM1xD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA2327293D
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695056; cv=none; b=AQRk0pWlj7VAGbCO8gbNTDwJOtAolDOZ8p2iKeKcJ4tilzE2nkIu5cvx17+37AUVNoFMMCVoQNOis+ANxrZyOGbcQBX89qvedw2JVk1BAYplEblsVn2OItIpXu9p9ifG/P6anNsM4wgSFOJ2A9SnEglaed82z77HV8jXtr8t1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695056; c=relaxed/simple;
	bh=n/1RgpCroVgyK7X6GzrUp5Xfgz9OBsNnHK+ge61VGTo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HieYj1EdxHeZwP2nP8WCge9gLDKskdbVbvjZTMnk8JnxxApoXxtLLsznvUgyiCgLfk2UfO07gX7xqVd4Y6vJfskmtVERbab8cYxQdh8852fVs5bQj+gOhrJ4JAf+gxEVCoMzZc4uffRl24xLdujSeooBKibkKd0t1GHy92eHJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l8WpM1xD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1eabf4f7so3305521a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695053; x=1741299853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9o5Jq8H+kOkmCfj/KGvAxCatQK2yuxe16Hy1ihdUho=;
        b=l8WpM1xDc6g7VqkVno/EB1jXXb8D9VR7OUUKUEN/pHha+sT6UzknhmCHuaZ/7xe1pr
         JW5KKgRgwHe4zEFC3sBNd5PtDzdwH1VpE8FZYqfAmEppyH4RHvIGSfPPHATKKJrj1Srv
         lrctFCpCMURXV0wJo7f3AAVyoJ34h6hAbJockkhIrCvvD9tQ8kMew4q02xb1LTeuwt0K
         Ik7Xr7G5UXfIwD0cRzuyZZ5Lqpq4YZd6Ba9lltoq2VDs9zPB521A06a2dPCBlO0jQsJo
         TAiUVfDyEnmrSUd0Dz6J4SUaECNeRkMPxrpD0mYN+jxl2Fnelgo6mMBhKWJJ8OK7AP4b
         xOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695053; x=1741299853;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K9o5Jq8H+kOkmCfj/KGvAxCatQK2yuxe16Hy1ihdUho=;
        b=cgtMONf5iJRqfdTkeWD9nb57M9BjK9JVIOLIFyjWpzEqeAsFPwZZ7LNnfeCsCNrdgW
         IH7A6hiIU6XxOH0e9J1MgyUb/ard45rjLmvXeLdiIolFEYrwnOM7N/l+mKIOJzGESV1B
         goz73P+PQU1esuSfOWI8q52WMnfyMeqDzIDs3QFqYjRZ7qPbNMpVWovycaX8t/4kahN2
         WkiTTeJl8XvtvJ2yMk5OEO+xIMsLxwKrI5AIxBGyplfQdO1JY64NctOMD/K0PySn1tvQ
         6WJQt29Mf+gXLgnty5ZOVHuO6nvbZtBpxUAEY5t6OR6W9xADyrHZ5WhilWKzSnrSwAyf
         fbDw==
X-Gm-Message-State: AOJu0YwlWCeYdjzO6DrWg509wGMGfIEdwtR9liWq1XdwMYgDI+aqUo39
	voTgPfZNSLgzkwR8PUc+thva6rOq8/k4/p7jI/ImdnEmoQXRCKKbMtnFHJzBkFyU6oEWDloGJVa
	6pg==
X-Google-Smtp-Source: AGHT+IFmir73DFHSRZ34KQ2YJsZgJSbeeYd5v5m/4loVQPqZFitd+g8FMqWSYZ+tXSmrGG2rxYiBIZTLRO4=
X-Received: from pgct3.prod.google.com ([2002:a05:6a02:5283:b0:add:a98f:56a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2449:b0:1ee:d418:f754
 with SMTP id adf61e73a8af0-1f2f4e5a4b3mr1477664637.40.1740695053378; Thu, 27
 Feb 2025 14:24:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-1-seanjc@google.com>
Subject: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Fix a long-lurking bug in SVM where KVM runs the guest with the host's
DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
context switch DEBUGCTL if and only if LBR virtualization is enabled (not
just supported, but fully enabled).

The bug has gone unnoticed because until recently, the only bits that
KVM would leave set were things like BTF, which are guest visible but
won't cause functional problems unless guest software is being especially
particular about #DBs.

The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
as the resulting #DBs due to split-lock accesses in guest userspace (lol
Steam) get reflected into the guest by KVM.

Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
likely the behavior that SVM guests have gotten the vast, vast majority of
the time, and given that it's the behavior on Intel, it's (hopefully) a safe
option for a fix, e.g. versus trying to add proper BTF virtualization on the
fly.

v3:
 - Suppress BTF, as KVM doesn't actually support it. [Ravi]
 - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
   it's guaranteed to be '0' in this scenario). [Ravi]

v2:
 - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
 - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
   unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
 - Collect a review. [Xiaoyao]
 - Make bits 5:3 fully reserved, in a separate not-for-stable patch.

v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com


Sean Christopherson (6):
  KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
  KVM: SVM: Suppress DEBUGCTL.BTF on AMD
  KVM: x86: Snapshot the host's DEBUGCTL in common x86
  KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is
    disabled
  KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
  KVM: SVM: Treat DEBUGCTL[5:2] as reserved

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 24 ++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  8 ++------
 arch/x86/kvm/vmx/vmx.h          |  2 --
 arch/x86/kvm/x86.c              |  2 ++
 6 files changed, 30 insertions(+), 9 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


