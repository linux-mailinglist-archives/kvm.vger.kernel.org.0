Return-Path: <kvm+bounces-37015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA349A24611
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1188D3A7A8E
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDAE1E884;
	Sat,  1 Feb 2025 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rRigvXpr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB39460
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372446; cv=none; b=YsQD7p0GmBP1Is9u+0TCZl2oAdmCIwZ3tH+61Na2+rJu3mHW3p5+qTqT6jIBdlm4efNnl0co+OTA/CwFs5H/BvrVt84U8MCVIfFvyLAeWZWZjXGE/KAORWZRv9RBaKhQs4BhDoep8Z8/uA3eqm2SnZ5Zmn1Bmsxgc1hOEGWhYhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372446; c=relaxed/simple;
	bh=gDa1qhX91wsfWEYeXVozciwOxp3uGwMjlCxhzjYjjx8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DQlgWeKCkHvfP0KmYYGvp0DmjLQqV/nyLqzB0KWxjQR61svhB8vAxICdzOdTUd9cR8Dv4Xs8KaDeRL4fsKuupoxOrbR7usDU1B7YCUELJb+WrOQCWZXOFEQWSBtkHTKEMx76dbf70dW89UVwOlyM/gkc6zUlfI+rrPk9/qIZowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rRigvXpr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee5616e986so7160554a91.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738372443; x=1738977243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6IvXp6LawXcmBH5LaQWsjNSSz2+k/ZgcOemyGwVuzTI=;
        b=rRigvXprLQr60GIRf1LjfRRStAppw7SEW2YzsuRwxYbz79VHsDMIMdubhUk3kk8uO/
         SoPCzBH83o0BgdE9uq77tkD6rF7Mw93VwND+2DJFOanG0esqA36c4oW6XZgW3FfexJhQ
         Xs7vLAtYOeiIlH7u5YYUZBZ8yPa6b9Z5LV7zfwmRwSxOae2d78+zGDBfL8/V1Cd9ruLM
         82+xh3C2N8+OfVA1pgs6Irr/kkyKYYID9PgT3aKZRDwhF+GZkyEqpT4ZEvwevCnkBlQT
         5DF9BMZzhCUYzLawVVBAdwbR+DkHEcl1b/J/1inYPxPp3d7/IfD9gRuOLcy1cwxdzt7e
         SJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372443; x=1738977243;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IvXp6LawXcmBH5LaQWsjNSSz2+k/ZgcOemyGwVuzTI=;
        b=CAxsw6j5ts6/JLUkiENvO2oKY3eNruKsu7VrYgVSC4CSoltgkes3vYBbdYyHswSAof
         mXLUrqw8t3gm2KVGtv0+HQWE+/o5S8JpjIkO3SW9vvIAZWiAMCxyMenGpTcfwRNzRFmB
         c5T3q3TJi+iDv+Xqyz4iCP5dykzGNvM4gkRcrYiBQNp8bsdWOo9fqG7LJRomPAveMSY+
         WfjmOrVZVi0icSnYVVphsQcIcnbpaaSrpPjn+3zEetqynITrGx4lj4HkBVmjXxzEatq1
         O5i+j3y3IpWxXh812IKSbNfzKfRY0e/4TzLm+lEbJ9QuqeM2cPxJfaWyG3kZMSKMQIna
         PgYg==
X-Gm-Message-State: AOJu0YwOldgkwe2V2hKMjWCDKQ8+REoQnY0/70pgU9TUQKCjX9+U/7bZ
	5tR+oWN3WCEB/0mCfssEfO07RDoYrOvYuCfbJ8DCi86Tj585Z/ocUrdi4nYzccgLxUIZEuQB6S4
	BGA==
X-Google-Smtp-Source: AGHT+IHVh07xgKTqbFguAoF2iaYq32Ad1Ug6CwyHoemr9AcdSO0FNfC+G6UjHvQIRnw/7HgYALo+v9DC7SE=
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8c:b0:2ee:9d49:3ae6
 with SMTP id 98e67ed59e1d1-2f83abd7da8mr20622800a91.10.1738372443463; Fri, 31
 Jan 2025 17:14:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:13:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201011400.669483-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86/xen: Restrict hypercall MSR index
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Address a syzkaller splat by restricting the Xen hypercall MSR index to
the de facto standard synthetic range, 0x40000000 - 0x4fffffff.  This
obviously has the potential to break userspace, but I'm fairly confident
it'll be fine (knock wood), and doing nothing is not an option as letting
userspace redirect any WRMSR is at best completely broken, and at worst
could be used to exploit paths in KVM that directly write hardcoded MSRs.

Patches 2-5 are tangentially related cleanups.

Sean Christopherson (5):
  KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
  KVM: x86/xen: Add an #ifdef'd helper to detect writes to Xen MSR
  KVM: x86/xen: Consult kvm_xen_enabled when checking for Xen MSR writes
  KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
  KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen

 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/x86.c              |  4 ++--
 arch/x86/kvm/xen.c              | 28 ++++++++++++++++++----------
 arch/x86/kvm/xen.h              | 17 +++++++++++++++--
 4 files changed, 37 insertions(+), 16 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1.362.g079036d154-goog


