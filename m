Return-Path: <kvm+bounces-35902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96077A15AA4
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1030D188BA52
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E26C15E97;
	Sat, 18 Jan 2025 00:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHjnhcvn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FF2913
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161757; cv=none; b=gEbu4jtDE5D2qTigZfeJFcW3STgdXk3raLJG3QbOd2YG/kg+6J0f7ZIMLWxCDipkPV1d0dI9T8UMFhSUm/UcEXTGJlySaghr84G77vi/4rFhwmMWEuPaaKRvwdn3G4vJiZhtc4iMvgvN0uFt5OqLpI7yUol5EFjREgT/35n0HKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161757; c=relaxed/simple;
	bh=kp0AvKl0M3EhlVnpqnZc4RZnCT/ITH1XEsY7IrfuuEI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Je0vOc53rTqQ6TDGD84LIlCk4BDKoXxksv+TdVjPO3gSUk6idFf0b2aq9SgQ/qJlczGTWGCC4lNm2qxJUVYZxqsYQrllE+gMElX1VSOeZgPvaT+wHruin0i8f9ZZj+9Wi6Wauj7Ll4O/7YpkEG3FuZOS0WSqE4OOa76V4KBaUjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHjnhcvn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee5668e09bso5297339a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161755; x=1737766555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsXIfQV2jtjhHOC3156VsAw/0Yaf1d9Hh2AIb0/j5R4=;
        b=NHjnhcvnrThHJpxJ4dJVEM+VZl73EJ9VJwBatW05r/ovGblwPGmNjK9f1J7Gw+P6rO
         Os0aQW7wzud6Lr/e3Y8cJXEKoE/twkLAAfsGJxqviBOwxcSxuZcf7Pkw04yqR+IqM3Ru
         qInXC3RfdatotyrZ5k2WOB81iXoS2bp5Osf2Y21kBaOeRa42lXdWDZ6vxP4Cvfmp3x4o
         FiWIdZK4XL+h1/LP4EQ+fMwS2Dtq9Yyc5k13u0Uvn0w/uAQWP6zKxhk35w+czQ3dIgkx
         eGslTsVvSnNhx5blDjm7JVgoNo3Y1nuXzT3kTufBCTSqVzXEAwPvCoW4/W0HRLsDvHNi
         XAUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161755; x=1737766555;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsXIfQV2jtjhHOC3156VsAw/0Yaf1d9Hh2AIb0/j5R4=;
        b=UxooIgyFRYwRgnKnIqXkfRSGdDFXZF7KwoderuGtttIstC+FZFQy957iJC0grGRSNp
         Sv6ExpMn2dJ198tyJtKOQUpWv+IFW+HOkC50j1mXvO5cBhEygwq+U54cWceHViIgw7db
         nJ9P4taNNtmMFXgy8zF53EXT35GpPlKjUGKUdgYFgkaAXeidawFPa4l+P+L0ClmLENmD
         df8daUniTqqoK/Cs7BMEatkHo9NlPYZvqMdy5xPbmB1SvXsLwTiQoxnRYyC54n0ZRUAK
         HPH+W6GjbMB78BTe0MQ5K7UIfkXRC5pbhnjRptuYSVcPnD0YEmsg9IAjnElHm5ZDvVbv
         s8Ew==
X-Gm-Message-State: AOJu0YxxBXBL0hnSVR+8/iyarq1uwcZ+Msnu7r0jcNIcItpVP51sxCe7
	lTlEwHFDhOScko4YO4+eTJZc6fyT0H22foxgKiM6Uc4IXl2iM5gN7FnExIZjRtv+3/RKGeZiu5h
	XsA==
X-Google-Smtp-Source: AGHT+IGJvzh6qf8gN83nxEOCJrTaOfX1GeowWxum/Xv+ePnWquKx+q3Z3L0bwhJFvzEv4FakLqUWz87K/rc=
X-Received: from pjbsm17.prod.google.com ([2002:a17:90b:2e51:b0:2f4:3ea1:9033])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2741:b0:2ee:c797:e276
 with SMTP id 98e67ed59e1d1-2f782afeb20mr8435691a91.0.1737161755408; Fri, 17
 Jan 2025 16:55:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-1-seanjc@google.com>
Subject: [PATCH 00/10] KVM: x86: pvclock fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Fix a lockdep splat in KVM's suspend notifier by simply removing a
spurious kvm->lock acquisition related to kvmclock, and then try to
wrangle KVM's pvclock handling into something approaching sanity (I
made the mistake of looking at how KVM handled PVCLOCK_GUEST_STOPPED).

David,

I didn't look too closely to see how this interacts with your overhaul of
the pvclock madness[*].  When I first started poking at this, I didn't
realize vcpu->arch.hv_lock had tendrils in so many places.  Please holler
if you want me to drop the vcpu->arch.hv_lock changes and/or tweak
something to make it play nice with your series.

The Xen changes are *very* lightly tested, so I definitely won't apply
the potentially problematic changes, i.e. anything past "Don't bleed
PVCLOCK_GUEST_STOPPED across PV clocks", until I get a thumbs up from
you and/or Paul.

[*] https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org

Sean Christopherson (10):
  KVM: x86: Don't take kvm->lock when iterating over vCPUs in suspend
    notifier
  KVM: x86: Eliminate "handling" of impossible errors during SUSPEND
  KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
  KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock, not for Xen PV
    clock
  KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
  KVM: x86/xen: Use guest's copy of pvclock when starting timer
  KVM: x86: Pass reference pvclock as a param to
    kvm_setup_guest_pvclock()
  KVM: x86: Remove per-vCPU "cache" of its reference pvclock
  KVM: x86: Setup Hyper-V TSC page before Xen PV clocks (during clock
    update)
  KVM: x86: Override TSC_STABLE flag for Xen PV clocks in
    kvm_guest_time_update()

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/x86.c              | 115 ++++++++++++++++----------------
 arch/x86/kvm/xen.c              |  62 +++++++++++++++--
 3 files changed, 114 insertions(+), 66 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.0.rc2.279.g1de40edade-goog


