Return-Path: <kvm+bounces-72943-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UO0PJn3aqWneGQEAu9opvQ
	(envelope-from <kvm+bounces-72943-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:33:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A4D217958
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C435C300A58F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DD1200110;
	Thu,  5 Mar 2026 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lbYBUWmC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D0E13D891
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739187; cv=none; b=olsqjILkqeIjfydlIBWXW1uWa06wVVd2pLytsJcv1Pfr6LV0So3gz9YQvpIecFqeJFVVlUafAuFZ20uzwHeoTr+pc10+ww/h2Wwa2tptYXgmSDCHhp58u3tv7I2IX8JuN3/aqhiB4yjeS/cgdccZZeW9CVQp/SblDlPvGD2O+D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739187; c=relaxed/simple;
	bh=r3OPgiBUP4X2ATgSoZfcsHJMXmkxl78QhYVzRG/9hmQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QnaIj/6Q8OjtHStpODZcZhck2lQHqSa+eCExXxiSCEWPurBWRjQEUs0CFU1JqNcsWE4xKSzcjnODUwi8vAGv+6V5pG7vZSHxrI3mboA7G5/dUbRXrCpbi5CXt6S4c9tTwdaLnA+C56/WbYwqf2uUzcO6m+ZURwl4nOJ8dYBnckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lbYBUWmC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8297d2c1e64so616786b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772739185; x=1773343985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uWEVb5HXU/iC9lv9lBuhHdov+6eJbU3mLsCLD8rEs3U=;
        b=lbYBUWmC+8SWknm1LUIC+g0Kv4uR2dbRuGAWQpaMZAVmlzjHvWI7Vll2ZoO5knPi84
         M0rQUT/b++ArBR7vvr0u6DJYAlerwT1ndH11hgZ9IUV2skMudXp8B35R+Fs1PW8hRXyR
         KrOX0uqOC4KPegKfj3vYKiEvxfPnEDh++c1SauYm2aa5HYBwn8CEMVAjhZBWWBjoctBM
         9NXiK0D4BKlnFA6ioLwL5UlRvNynhFy27nH5S1Z/fKKzo8dGhfPRrAxvuUosGHmmrIdH
         4ol5BvJ4S9z9zNV9BTxKZqXif+Q3fW1PJE/N/mCCSSE1Yr2vpw9dAT5f31vhSqchvolQ
         2jsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739185; x=1773343985;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uWEVb5HXU/iC9lv9lBuhHdov+6eJbU3mLsCLD8rEs3U=;
        b=ppbIlyCbzVNtfIHjTc2XzjEeD9LgLUmYzCV9LKw0VqWUbrqLKfZS2CgutSWSRdeLYi
         g//wTfqNwib93H062jmW99HvYGGDPhUx3jlW67AYd/L/aG2fXmTuxzuAXsGGSCdWPTkZ
         Wpwo8T4VFRdWQCddtK7uDofbxw0LqFEFI2VqT/VoI1HhTF1FYniOqR41L6O4u3k327Wr
         rdq/t6bYCOMiyX4xW6bdOPDrp8k2kNNpzRKKILtS87v2CKhjDmPHNaxihGqZbwGTxzGY
         bnDqMnKBRijRibjTCbHB0PJRouJSVZATc1t1sdAGzPqJlUsVbQH/WeN36U5LYI1VLuXS
         ztTQ==
X-Gm-Message-State: AOJu0YwQTjrItX7iii9TQAsSEwHqme6VNO3nY7jqTe2Rn8rROG6+m77G
	ExB/RnX6/OORP49Ql0t1Nn6FhKpDmEZ4qmAuh1nqR/IBVnLJoMuGXCI9IFuhd6LmGU00U1b3pBP
	VzhtfYw==
X-Received: from pfiu5.prod.google.com ([2002:a05:6a00:1245:b0:829:7eec:794])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88d6:0:b0:824:adf4:5a32
 with SMTP id d2e1a72fcca58-8299aba1fd8mr832150b3a.42.1772739185320; Thu, 05
 Mar 2026 11:33:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Mar 2026 11:33:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260305193302.1644453-1-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 7.0
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 94A4D217958
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72943-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Attempt #2 at the flex-array fix and the slots_lock documentation.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-7.0-rc3

for you to fetch changes up to f8211e95dfda702ba81ea2e3e7a8c6c967f385fa:

  Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm->slots_lock (2026-03-02 09:52:09 -0800)

----------------------------------------------------------------
KVM generic changes for 7.0

 - Remove a subtle pseudo-overlay of kvm_stats_desc, which, aside from being
   unnecessary and confusing, triggered compiler warnings due to
   -Wflex-array-member-not-at-end.

 - Document that vcpu->mutex is take outside of kvm->slots_lock and
   kvm->slots_arch_lock, which is intentional and desirable despite being
   rather unintuitive.

----------------------------------------------------------------
Sean Christopherson (2):
      KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
      Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm->slots_lock

 Documentation/virt/kvm/locking.rst |  2 +
 arch/arm64/kvm/guest.c             |  4 +-
 arch/loongarch/kvm/vcpu.c          |  2 +-
 arch/loongarch/kvm/vm.c            |  2 +-
 arch/mips/kvm/mips.c               |  4 +-
 arch/powerpc/kvm/book3s.c          |  4 +-
 arch/powerpc/kvm/booke.c           |  4 +-
 arch/riscv/kvm/vcpu.c              |  2 +-
 arch/riscv/kvm/vm.c                |  2 +-
 arch/s390/kvm/kvm-s390.c           |  4 +-
 arch/x86/kvm/x86.c                 |  4 +-
 include/linux/kvm_host.h           | 83 ++++++++++++++++----------------------
 include/uapi/linux/kvm.h           |  8 ++++
 virt/kvm/binary_stats.c            |  2 +-
 virt/kvm/kvm_main.c                | 20 ++++-----
 15 files changed, 72 insertions(+), 75 deletions(-)

