Return-Path: <kvm+bounces-57663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6151EB589CA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 879647A4276
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1481B4247;
	Tue, 16 Sep 2025 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lfczR8kW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBBB19EEC2
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757983117; cv=none; b=UlnWDvyKT9nRwbpI2ap2RF78gBaJgdOK2232oOOmzVhLMcy9MAZbSF/KhK/6ANcw5n9NVC4low0PTYURqccC6X6e+L9bSLD90S80qvPmj10iGL9GJe1ucKJ3py9It/9qXnRXjwPar5iGMHVCAv/xSTRc3ScibrYa4J/5aFRszXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757983117; c=relaxed/simple;
	bh=lY8GwaCMi3yL6eor2HIlNkytFZaiNvCLkZjHU1cmdGQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qnd4thHJ9cPLgbmycSMTkU62MrKIxRE/8FdFQQx/h8TgD/GA9+R7b/eANuaiN6eZLUX/KoAicBGWI6MJydbaNx8xazy0OcHMRhen3pUqx7YhgOrLRRPKAc2U0FdyZg/2KGbQunAwUw4mIq/nY9uLDNi+7FZGo5/7ylJ8jnIjEns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lfczR8kW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-267a5c98d47so12357005ad.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757983116; x=1758587916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYW48A8ZfmbRdubUzd99a/MPRiGKsics+FOUrVX4GOY=;
        b=lfczR8kWgPhX2xOp1UlIy+rQhh+ctbSFy0BpPjfU4CD7tmpeNNKFcu1YL9ngAjLW6o
         DOGCoGCJOjKjYuIGu1qY3yquqlUs1lRejoxaTHCszWykFu8eP2ygP4lfKhcDL7O0sz5T
         klK6fQaDEOZsDHZlhnpnj1ToV3+nxjKwik5DhyktBH1kwJJXl2SW8CwO7JIbNWy/pDjG
         fZ3f+hoUTKfrye8hU/DLA8AhHrMyR//eye1oZ6A5tmAnEvfr59cVssANIPGTO6g10vSC
         Sxo+eF71HbFVmE2qSWMmMkIU8e3sIsIL3ODXKrAOlBZf/jKd1NjNK0JN1bHfDNqmvdKo
         JIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757983116; x=1758587916;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DYW48A8ZfmbRdubUzd99a/MPRiGKsics+FOUrVX4GOY=;
        b=o/aPlPLHUCJj+hWXwO0hBS73v5/64C8SrEsIDvYnNY80/FnDqUy3dsS7VC64YncdJU
         TmFjfTgzUlyd7DHZRRuzUZQkxmgto1OmEgcLHC4kcwmAHoRzM1ofT3rosUZYEna6lIcv
         BPzEGYgV9EP3RMzBZ+3D/2jBdhZbUytskwK1hUhSycoxgcM06uhvpbV+sF4KJ2A65mtO
         auYIKl7Ll8xPpbpcqAzdjqYyXcPerdkKbYhTiaqsri59vPNRso/KokQqU6+mruJSApXk
         23pBd+U2yTL+zrT2lVnx4qCowBPwLSUjcgnsKZi8sDZlsACWJtARVVrpJu925x1ECRbl
         QZdg==
X-Gm-Message-State: AOJu0YwM6gvcWGTM4F3AwMv6QtAUfluf7LjzPiSHZ8snbgXOmt5KBb/f
	ixwJzzh/LDFIlOb6E3pwqCzRr9boNSrV2nLvvX1jed2oiWV2gMCHClWo6SIQb4Dtq1FU318t8Zd
	rygi1XQ==
X-Google-Smtp-Source: AGHT+IEEJtqj7LGKOGahSkhskOAxGFYu/wYgOwkvODUB3Ot1p+obyCbsuwmeiSpa2Wc5Jmgj4+aKlGFYyWY=
X-Received: from pjbsz7.prod.google.com ([2002:a17:90b:2d47:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19e5:b0:267:d14d:3b31
 with SMTP id d9443c01a7336-267d14d3dcemr5897695ad.49.1757983115877; Mon, 15
 Sep 2025 17:38:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 15 Sep 2025 17:38:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250916003831.630382-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: AVIC vTPR fix for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please grab a single fix for 6.17.  The bug has existed for some time, so it's
not super critical that it get into 6.17, but it'd be nice to get this on its
way to LTS kernels sooner than later.  Thanks!

The following changes since commit 42a0305ab114975dbad3fe9efea06976dd62d381:

  Merge tag 'kvmarm-fixes-6.17-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-08-29 12:57:31 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.17-rcN

for you to fetch changes up to d02e48830e3fce9701265f6c5a58d9bdaf906a76:

  KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active (2025-09-10 12:04:16 -0700)

----------------------------------------------------------------
KVM x86 fix for 6.17-rcN

Sync the vTPR from the local APIC to the VMCB even when AVIC is active, to fix
a bug where host updates to the vTPR, e.g. via KVM_SET_LAPIC or emulation of a
guest access, effectively get lost and result in interrupt delivery issues in
the guest.

----------------------------------------------------------------
Maciej S. Szmigiero (1):
      KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

