Return-Path: <kvm+bounces-23118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DED55946412
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A60C283A38
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60BC61FDA;
	Fri,  2 Aug 2024 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdAXkz7G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B01ABEC9
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628285; cv=none; b=E+ncCGc9JQWthzJdHJiyryC9f1kNTZcTwwVOEjhh3RNtxwdArWUkG75Fq03TMGNARt8fp1NhjnXTQ/LG3kk8G7xti0jjEklIUQZxR43G3nOSDeYgi/Y0+vV1K22AH1HwtTgeHadQTWu3zyBQqtXL9qPIN2rFnNVd8mDdtq/755o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628285; c=relaxed/simple;
	bh=xdSanLFGFMWba8L0va07jfZf9yllgVPIpa3BEmbMGwo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AegNhXYVeln1VshjEHfM0eKozj162b8/dt/fZl1Xey0lT4mi6AE470jXbK4SZ7UIx+u6f1vghsT4hpnmm/BmiEWnkVu7Q9QDj0CotLjIfwNXPzusj7RFN/kz+UYEp6wwL4cVILKV6ggY/Zcxc0mno+fiz5tDCprT7sQl78ivrmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wdAXkz7G; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-664ccf0659cso168192117b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628282; x=1723233082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRePbcv0Jk0c/q3ujH+fDFJfEYjiNG/9PTNMG0T5GSk=;
        b=wdAXkz7GF7XfP6lPK3JYEzIyDx0mKNavohpfgHL88E2fQv16WLSHJCiHP4bpM2yyWD
         j8dPnRLrWuGsVUBrNx6YFfGPugFv4b3Or2+2Ez+VR/FeCTv0uggH4j+Tuh7Er7+MuJ1r
         JbmviaOnTY2se2dPM8a1a8qpqKzNj1Wmn8YrD5Mm6Zgc9yhDPXEpeqfovWxbfvPYnEPO
         znEOS42xG5oHlUDQhdELeRMw8zVt0MeO3gKiJUfOXn4E9BajhYGdXINQjAQBBxJLmF/X
         UVbs7wKALZ2sz23ZzuVm4C9HJwVg99ttyPI96iWtVtA0HPziDmnnNZy841xnWwmUJ4kP
         2rEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628282; x=1723233082;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRePbcv0Jk0c/q3ujH+fDFJfEYjiNG/9PTNMG0T5GSk=;
        b=ZhMSk/8KI7L9ILm0FzK1Vu27FQOERpCGJYtzGzDQ5rPUuzmIUOG6C3i3fnU6mtM4Z2
         b3ye8GFSzgvw7ba7bXH8oRCK82ZTKBGKo47bPwmZISzikrpbCGYaL3lxQS1r/Sh9y4Tu
         9WzW9NBG3svAd2mRStWlH5wUyXfnrJSP87LJfcFQ8inOiIvpbS2T7F2ck1d0AiL8xKpR
         M1jqnG4tDNPotIfVwVf1YKH1TePd/+RJmVeJhsZ5+9zPYFnBcmAe99JfqQ0cScNayuVK
         sZL9dJgsihc7fFeTHA+KGper7MkYAvQVpHjFDyiPWWhcYCFQGoBqLxUVMe9NLi9QC8gt
         XHsw==
X-Gm-Message-State: AOJu0Ywpt8TpUyNsPTcLBDYt3z41qvrK9XKwaSNcCZD5e5a27qcFFUrg
	zg2ATV6nwvxqxQtN+xdDx+jEL42LCGLecd+rT2tl6l+Yl79d3aagb9HnKu6j0xN/VsXub+QVqHc
	MyA==
X-Google-Smtp-Source: AGHT+IE5YVzery3YWSIUahvseviZoBDs9GNQK/RnAw0rCur245kSb6c04TZt+gZRN8dnLYCWg6B0H8RFHnY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2483:b0:e03:a0b2:f73 with SMTP id
 3f1490d57ef6-e0bde2f3cdbmr32634276.6.1722628282405; Fri, 02 Aug 2024 12:51:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86: Fastpath cleanup, fix, and enhancement
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series was prompted by observations of HLT-exiting when debugging
a throughput issue related to posted interrupts.  When KVM is running in
a nested scenario, a rather surprising number of HLT exits occur with an
unmasked interrupt already pending.  I didn't debug too deeply into the
guest side of things, but I suspect what is happening is that it's fairly
easy for L2 to be interrupted (by L1 or L0) between checking if it (the
CPU) should enter an idle state and actually executing STI;HLT.

AFAICT, a non-nested setup doesn't benefit much, if at all.  But, I don't
see any downside to checking for a wake event in the fastpath, e.g. it's
basically a "zero" time halt-polling mechanism.

The other patches fix flaws found by inspection when adding HLT-exiting
to the faspath.

Note, the userspace-exit logic is basically untested, i.e. I probably
need to write a selftest...

Sean Christopherson (5):
  KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successful
  KVM: x86: Dedup fastpath MSR post-handling logic
  KVM: x86: Exit to userspace if fastpath triggers one on instruction
    skip
  KVM: x86: Reorganize code in x86.c to co-locate vCPU blocking/running
    helpers
  KVM: x86: Add fastpath handling of HLT VM-Exits

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/svm.c          |  13 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +
 arch/x86/kvm/x86.c              | 319 +++++++++++++++++---------------
 arch/x86/kvm/x86.h              |   1 +
 5 files changed, 188 insertions(+), 148 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


