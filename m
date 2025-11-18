Return-Path: <kvm+bounces-63597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E16C6BD8E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:23:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C96A54E5E5F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE1330EF94;
	Tue, 18 Nov 2025 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vwNZ+f8L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D961FA859
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504613; cv=none; b=bfJTLxtZKfLMuRjZSYByjhVwueE26gLY8/5fWuYpq+ZnNdFsrIKXClKJ/IVllGmH1gSk613ubqDjMHvqf6FAspvVohDuz/qVh70N+vAYhtxs+potJ4isjGBnR38Q1A/2k1fJwm34/o2ArNSdlBExt/lqETyqzXSvZxdlswTw1cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504613; c=relaxed/simple;
	bh=1iQs026hZoi5t1uCrSj4KT0sve/8LeLDIXGloj9+TvI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EBce3i5xaNtJ4moKX8tNOxqEvJmEi/ErKoWgzg1sAW4psTnFcxivfOUpOw6myIO5rh2CNSb3NYMDzjZ4liXKm6dVLf2darLecRamQF06oz7CWXQtD1DtKQxwZZeLhg+Lg/0ToVyLyf238BmIuHsf8eAuZpKQm5aqtwBMc2/bnNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vwNZ+f8L; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7c240728e2aso1228259b3a.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504611; x=1764109411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rgYuW8UOyWLUyyathvu0pA9lXS215ZKHalLPZAaX/EM=;
        b=vwNZ+f8L1mzE7Li5MRtkZU7mWrSkYmulo1tdJQjn6Yls2ICApq5iF9/NHIsGQAJC49
         rGgmOGHA4D5wJRkR5hFEvLWcz1FBw4NW9AC4Rox30bSk1Ro4kRp1q6pEFlPvStArVR4a
         5cXUYBRojbJ/G1rygujT1jEFtC5g+9CJiFvW+weo1Dn6w568aGcmNC17GHh/+m90f5hk
         GG+w2d0jsoNsrFeuDkDeAma5G2SFcX8WcL3PLiiZd+ZILMLgB1LVfb98C5gjVb6vvjst
         29qEHa/LZmEFDF0nZVBHlivbBMu3790wge9lCX9nfKwoUYYye7efCjud8lftbmfvDxlh
         RLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504611; x=1764109411;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgYuW8UOyWLUyyathvu0pA9lXS215ZKHalLPZAaX/EM=;
        b=PQviv4pFXApPwwZVz4/0l94H9jJTXPLmvBHTy1V2SG0tPH3wprRb0ttIArZAljBtB9
         DXk4uF7mCG9EBRd1ecDoIrd3pZnTMyhzFKaOJM/h/xOGD5xquZcgnGk1xQ/X69e7x8h5
         9xwg1DBL8yoBgaMrcBdt1TS4aPTdHg9F/FwEZZl02FQNRy+cylULBzXvwZ4Jgw8w0E7/
         gd+2huCRTrJ0DNn80ssnEmRRw00wS7wIvrhC//nNri7aSlXexYSkck+Jjt7+7Mor/Xn8
         k1XzqM+m1uwd9dfDDcFVkURugHqrep+tD5dWkyOMSyIokosGJmRAfoF9JdKEkc9j2H5H
         wqUg==
X-Gm-Message-State: AOJu0YxIYm5hjzRxHbPyjA6MkYp6WE2T1GodRNVFEZIpxd2kNsnD1oih
	UjRc1zVkPO/De5KXZy9zhOt/0wNh1ATe6EL7k/X/iG87qn9yHz4L+aW4MdXjC7kB/gUNpd/NHXd
	bsD1IIw==
X-Google-Smtp-Source: AGHT+IFXkFEO29YFXjyiYY3HorCCsF26L2b/h6RaXMwbRwLOl5iJ+9ZCln9TDezx9nP45smTnRSHgsQ+a4k=
X-Received: from pfbik6.prod.google.com ([2002:a05:6a00:8d06:b0:7ba:f8d1:3475])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7484:b0:34e:5dd4:b1b5
 with SMTP id adf61e73a8af0-35b9fc781d9mr20603421637.2.1763504610944; Tue, 18
 Nov 2025 14:23:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Nov 2025 14:23:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118222328.2265758-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Optimize XCR0/XSS loads that are currently done on every VM-Enter and VM-Exit,
by handling them outside of KVM's fastpath inner loop.

Context switching at entry/exit is unnecessary behavior inherited from a
hack-a-fix that papered over an egregious #MC handling bug where the kernel #MC
handler would call schedule() from atomic contexts.  The resulting #GP due to
trying to swap FPU state with a guest XCR0/XSS was "fixed" by loading the host
values before handling #MCs from the guest.

Thankfully, the #MC mess has long since been cleaned up, so it's once again
safe to swap XCR0/XSS outside of the fastpath (but with IRQs still disabled!).

Note, Binbin's kvm_load_xfeatures() still applies cleanly on top, so I
deliberately didn't include it here (but am still planning on applying it).

v2:
 - Collect reviews. [Jon, Rick]
 - Fix TDX (suprisingly, not servicing host IRQs is problematic, /s). [Tony]

v1: https://lore.kernel.org/all/20251030224246.3456492-1-seanjc@google.com

Sean Christopherson (4):
  KVM: SVM: Handle #MCs in guest outside of fastpath
  KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
  KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run
    loop
  KVM: x86: Load guest/host PKRU outside of the fastpath run loop

 arch/x86/kvm/svm/svm.c | 20 ++++++++---------
 arch/x86/kvm/vmx/tdx.c |  3 ---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++--------
 arch/x86/kvm/x86.c     | 51 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/x86.h     |  2 --
 5 files changed, 55 insertions(+), 41 deletions(-)


base-commit: 4531ff85d9251ff429a633bdb55209d3360f39f2
-- 
2.52.0.rc1.455.g30608eb744-goog


