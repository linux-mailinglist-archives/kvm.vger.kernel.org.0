Return-Path: <kvm+bounces-58096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE60B878C6
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB721CC1366
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC65B23D7E4;
	Fri, 19 Sep 2025 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jaAULnoj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D851F3D58
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243600; cv=none; b=T1xH3vDUTl0Hd8i10FxTSrAS8GsxI5IWfSO1AvKrKKEufvoTvbVAWDY0B78Ygm+zMVs+kTLeXz0xrGvYxHg9YjgcutrRuWkCxzdtlypJKpGPTkWNU+kdc2f8PUHxR1D1GibDbuTzyGaNr0dnI7vTyiM21DVxDapYjOZzjoaqTf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243600; c=relaxed/simple;
	bh=i/MaglEF+2mL8UWZYeBxWiciveNTlowZNFItKV5sL7U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bQtm55z2DHw7mjM/+nkF/SaVD+qX3aCVeH8g+aq7pxnlAyHp5X89BOv1Vsut7AkZbjEqzaOij8dDrn8KkEFJOo+S/BmLPAtRts0POF2eBY8O6chovimqZdhik4rZynCLzuYn7KM8CCoLJ4XVTbpJfcE0pCupjm9SOtjS25KUmSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jaAULnoj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so2767395a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243598; x=1758848398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01Yp+++js8VZTGL8hobBuj0491X7s5M+W9IKn43ed5o=;
        b=jaAULnojvIhy3MkF5JCqrr3K13sX7pI+OdwK8HOy5p3uZI5KECeIzYONLRTG3GORg7
         ro2rU/7U83s/YAAbzYo9Jbxj/eYLdfU2szVl6lvWEMOD+RB4WQuf9gAtxGahe+RIAc4J
         18jwpmF5VL9ftEHO6WH8zHpsNu4xLs/xthLu3cRXroClgAGGoLpZXuNWACsFPc7YFrV0
         59j9G2a1MWUsYyUNOHnRvDDozXn7j0UiGhdsrBdLv+R0b0E7zX24yO7R+MIgpLQmgTVg
         WKUwxY0bErpw6fjseLUaghR6Xgu+R68VMKcrOziRn9VQ7+rMu+IetKX1lupj79+qdNXF
         i8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243598; x=1758848398;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01Yp+++js8VZTGL8hobBuj0491X7s5M+W9IKn43ed5o=;
        b=QFHmYycJ9Z9/+LfYSqIe13LfBubhW4XiR0CN+xqEdGA2+6b0MEvegXZvJE2y6fTYlG
         ztPbSuxFaVGGUGyuwsDzfMix7e36sllFjlB4WNhBNRt5FW/nsI7cbB44yd6ow2qK7u+X
         2+hJ6HuCPVsDj1iIA5lisyk9w2skB4KLg+pdyhZxjCzjEJDJ6/Qa/77GL1nuLPcncOAS
         HoAK3Y2hCAuz3JzM8OgI7f+yWMQQbVO622XYjhpVuHASfXRjdhQXY1V85wtlwnLr6/fp
         Jl/9V2ACk4xnomjkOwSeXjDUQY9BHnamX+IcYHd+acwgkKgqpZWbldOITXoP20rqrLps
         ShVA==
X-Gm-Message-State: AOJu0Yy/41Cpvj0L2PV25VwICsmIV5O8UWztRQBSchIdI+h2FpHS49Bk
	PcXVku9EtvfLCLKOSlaC3ShUsOLD6Tra9ISpbu/47dXYHZBEWzt3X5HhFGs65PyWvR2uQUw0wAB
	UvqwOGQ==
X-Google-Smtp-Source: AGHT+IGTeZE9Saq/JWZNxtkTc3PV/Di6ZjN68Tln1XhBphZZwxq8RqQfwPtLvlD2JXwePNpSjUyOdPBkW9o=
X-Received: from pjg14.prod.google.com ([2002:a17:90b:3f4e:b0:330:5945:699e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2787:b0:330:6f16:c4ce
 with SMTP id 98e67ed59e1d1-33097fdc6b3mr1590529a91.1.1758243597810; Thu, 18
 Sep 2025 17:59:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: VMX: EPTP cleanups and nVMX fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This started as a trivial series to cleanup KVM's handling of EPTPs in
anticipation of eliding TLB flushes on task migration[*], but then I made the
mistake of trying to test the nested_early_check change, and things snowballed.

Long story short, nested_early_check is obviously not being used as it's been
broken for years, and it's not adding value.  E.g. doesn't help us find KVM
bugs, and doesn't provide any meaningful protection for KVM (especially since
no one is using it).

So, I opted to fix nested_early_check, and then rip it out and replace it with
a param that can be enabled by developers/maintainers to find KVM bugs (which
in hindsight is what we should have done from the beginning).  I went through
the effort of fixing nested_early_check so that in the unlikely case someone
wants to resurrect it, they should have a working commit to jump back to.

[*] https://lore.kernel.org/all/aJKW9gTeyh0-pvcg@google.com

Sean Christopherson (9):
  KVM: VMX: Hoist construct_eptp() "up" in vmx.c
  KVM: nVMX: Hardcode dummy EPTP used for early nested consistency
    checks
  KVM: x86/mmu: Move "dummy root" helpers to spte.h
  KVM: VMX: Use kvm_mmu_page role to construct EPTP, not current vCPU
    state
  KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=0 without
    VID
  KVM: nVMX: Add consistency check for TSC_MULTIPLIER=0
  KVM: nVMX: Stuff vmcs02.TSC_MULTIPLIER early on for nested early
    checks
  KVM: nVMX: Remove support for "early" consistency checks via hardware
  KVM: nVMX: Add an off-by-default module param to WARN on missed
    consistency checks

 arch/x86/kvm/mmu/mmu_internal.h |  10 --
 arch/x86/kvm/mmu/spte.h         |  10 ++
 arch/x86/kvm/vmx/nested.c       | 165 +++++++++++---------------------
 arch/x86/kvm/vmx/vmx.c          |  57 +++++++----
 arch/x86/kvm/vmx/vmx.h          |   1 -
 5 files changed, 105 insertions(+), 138 deletions(-)


base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


