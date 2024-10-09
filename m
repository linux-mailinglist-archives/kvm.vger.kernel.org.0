Return-Path: <kvm+bounces-28296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D419973BF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59168285803
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F94A1E0DE2;
	Wed,  9 Oct 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fraUCpdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7C1CB514
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496208; cv=none; b=IGmVYY1v4mbZQK8fg3DsILKihJOT16IOC8Qi1dYPDYkfAG8nLeTSUPIXftA/J5potROzHT4lcuMqv4WY7pobXieu+ZuSSxdV71YIhZBH/ODA+H+0PKwL47XZAwWC6+N2uxm44CrGVUanjUNaC5gWn+E7CIWb+Juj1o1x4rtbgXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496208; c=relaxed/simple;
	bh=MxvXk1fdhytS5XV5lu7xh3HaviYyN0EEXYtlLds1jTI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IQQN3Dy+s9aDsCmzZ+qP6acoYI3f2RwkG2I0Sw51w9zJyTJUULOEQIDrI1XMewauUX4AvQMgURz5z0Vdgcxty3vAcBWDq7RoY/rgifbpJzUtChoSIONLzWfbZfXd2/IcqQ+ZI85KiBeBGgnxmAlNrjDe6oiwk0HGAgWdmEIULBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fraUCpdr; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e23ee3110fso2237417b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728496204; x=1729101004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvER9ZyOmZvlvkfQ0QlNMg2dDWrDm49qRL1pt110lLI=;
        b=fraUCpdrDCnd6fSKVhhWRR522WY/sjGIZbzLqOjQz3VgJTsg1gm6EUhm0DAziOS8sL
         W8F3pe+bIknTrZLbnAVWOIHsVo+/So2hHAtzuHftVW6jJer38/paLtgQuFOuo0SDQEOc
         P64cu10DDe1DyHubcxLURULJd8nxXcgjLBXQWYrXu1IbAfKNCDamUtb0E09cs+Pfvagz
         1r1PQym46OZhF05lOIS+5mzVX7kKFRIpdTnaX+863zOpT8o124A5kzvLNFdtE1T3cWsO
         aYSweowM00o7tS91h4f6JlquRA9ju9wpeBlyHInqFIf7vuei9SciX5hfmjea9jVKX2cA
         5T0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496204; x=1729101004;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvER9ZyOmZvlvkfQ0QlNMg2dDWrDm49qRL1pt110lLI=;
        b=EwD/FyU14ygnXilQkyVVHKwrYaSAwiwNJaTiHp+Iu/24lO3Sj8amZ3pkPup5rxX9KY
         sYO6yoTSyGPsWMjFo9tkE/vTK+CcWz4wTU8BbjCNmxOUEqstzeAvCIl3gSh60Gb9Tpn3
         qEW6KNKfM8pfDkhu1s5N+chOoBG8zjE8KnkARS+pjSFVmC45yzp0XNMDZa2XUBwswTG+
         xnvktXuB5Jt7OLpe/N1ZfnRxOXM3YDUbQUpSbGjStBOJzgrBQaw/LJ1LqJjdKtlcRfjp
         hmRKrjfa/71HpnqxpYOygwHgPwbVfuawqc7+nAGzP1Y/SJrS2MU6yV/UTB2YLuGHnGgS
         QRgg==
X-Gm-Message-State: AOJu0YygftAAbFNR6CLiWq7JthBlCZpxk+96t3t+IwG4rcLD9Gj8nJTX
	ZaXqFkF+FmPSjaTc6qSRRXYqI7xlVZofwbb8FMa/u4gZcnzaCOdLXvdyXgw+XkqgqMHs9ynpFUq
	xpQ==
X-Google-Smtp-Source: AGHT+IGYTupOxq9Up6ciBQGUqvbqk9jwoYX//69iW2B1OciHXBy1DvTw0oH9r/dDnWJKR/XTy8KK4KuB+4M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c01:b0:6db:d257:b98 with SMTP id
 00721157ae682-6e32215253bmr303677b3.3.1728496204631; Wed, 09 Oct 2024
 10:50:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 10:49:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009175002.1118178-1-seanjc@google.com>
Subject: [PATCH v4 0/4] KVM: x86: Fix and harden reg caching from !TASK context
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Fix a (VMX only) bug reported by Maxim where KVM caches a stale SS.AR_BYTES
when involuntary preemption schedules out a vCPU during vmx_vcpu_rest(), and
ultimately clobbers the VMCS's SS.AR_BYTES if userspace does KVM_GET_SREGS
=> KVM_SET_SREGS, i.e. if userspace writes the stale value back into KVM.

v4, as this is a spiritual successor to Maxim's earlier series.

Patch 1 fixes the underlying problem by avoiding the cache in kvm_sched_out().

Patch 2 fixes vmx_vcpu_reset() to invalidate the cache _after_ writing the
VMCS, which also fixes the VMCS clobbering bug, but isn't as robust of a fix
for KVM as a whole, e.g. any other flow that invalidates the cache too "early"
would be susceptible to the bug, and on its own doesn't allow for the
hardening in patch 3.

Patch 3 hardens KVM against using the register caches from !TASK context.
Except for PMI callbacks, which are tightly bounded, i.e. can't run while
KVM is modifying segment information, using the register caches from IRQ/NMI
is unsafe.

Patch 4 is a tangentially related cleanup.

v3: https://lore.kernel.org/all/20240725175232.337266-1-mlevitsk@redhat.com

Maxim Levitsky (1):
  KVM: VMX: reset the segment cache after segment init in
    vmx_vcpu_reset()

Sean Christopherson (3):
  KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
  KVM: x86: Add lockdep-guarded asserts on register cache usage
  KVM: x86: Use '0' for guest RIP if PMI encounters protected guest
    state

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/kvm_cache_regs.h      | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 29 +++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.h             |  1 +
 arch/x86/kvm/x86.c                 | 15 ++++++++++++++-
 8 files changed, 57 insertions(+), 9 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc1.288.g06298d1525-goog


