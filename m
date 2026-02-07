Return-Path: <kvm+bounces-70537-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKUzFEu7hmkEQgQAu9opvQ
	(envelope-from <kvm+bounces-70537-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E009E104D3C
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 382DB3048014
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5DB330663;
	Sat,  7 Feb 2026 04:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XsKTKtuR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB042D63E5
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437418; cv=none; b=BVTZztZBeUQdsV0s0gKhG4ziJ25OwLW3cYAT++7m5WVx7ArDyr8gmOnmzWwO4sz4pFwHjaljbx5+nuoHtiDUxApip6QhWb2oyl74LblNXNjkkUHUFDLtk9JF0jKQc0SnET36P6y4s9ET1oCEy020JoFW9wHsoY6oujF75+YADTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437418; c=relaxed/simple;
	bh=p5nxu3id8UolerNhjHoe422qJFegewgpXd0OybvIbFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=biXJWFkEdkUdChpZSbvg7JNBT8MopLzvwqlaZ+O4HuZfBafu4zlaivQ1THo9w/RlHWRJMzYRcWmRUTtYiCbyCv7FeD56MC7pITFSoluqe8XpErDTgsdfpZXEa7MPxOryM1ghzHoN6zQ6CyKDNk9Wr+UGSGNXbW/jXx+w/6KcZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XsKTKtuR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c65f69edso317008a91.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437417; x=1771042217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y3zDHsIXP5YzU2BtDYeB6vfxdCF+cg0ZFzAe69Uf118=;
        b=XsKTKtuR93pzjvC0//157oMfIixq2tGQwZgHVYvi1oVSFnok0U9GzDDpQv9RfvBxxz
         O/P0YNz6xHPzY+2zYhy/i8m+sregtYWisQUbCyd9D9FK784OTWimcvgLxCrjdSOIfWpm
         NNN7dJnAYtpEyWNco4k4ZcRMJUekGuTIlcKm9yISb5mNnwG893LlsFvz1eLK8cAJDEIy
         Fyw9dKTUQq2dHCofET5wlMOfRl+/yc6KWc8wH27L/9ZKqN2FVAcHALlxwAB0iUcXjdta
         oGNc/nYS6oWPxQOctS0n1ZA3cQWF69mgVblRxd8CuselrNIQep2mBUoG7uXL6f8jKXy8
         wKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437417; x=1771042217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y3zDHsIXP5YzU2BtDYeB6vfxdCF+cg0ZFzAe69Uf118=;
        b=WspIo949LBIUwIzyfJhk62Vw9OZMwBxYRabZCodl8u1qRh4DgQBSDixeB8rA11IVjV
         D/Y7DQmw+AVRon0qdo+uTp6BxgzD2A9sBooFdh3LaZHMi+n6vn/F3hsFs86mm3GRQavf
         xKqVKWCZiadFTj2Ba2KsJALdD93wVYyFvpeREVDSBUxCqrTJbqG6HBMEIgY5i0KASmOa
         /0wU4HnstspoPdVFXTe6U2Yp5aSoiCmj9iRkye3VKdiw0+dIWR0nevUgXkieFek5SxXK
         uBzRLs9LYRRsyNvQZjNzOMP3wWir97SL1w+5dCH7l6wUwwPFJ6PdEU9pd01XXTaVBR0L
         vvMg==
X-Gm-Message-State: AOJu0YwvoM5BqHpeTwJj85+CWRypl0y2hfFoaML/uPZOYl4UYvJOl5WF
	deTSFwJEXV8M7N0F775nfZl1pLe85C4gvmpTk0UeoUkzJLnKQCyJQMULbNy/kH3Q9/wVdxlOQ5n
	j0pfCAQ==
X-Received: from pjbqi5.prod.google.com ([2002:a17:90b:2745:b0:353:d0b3:8611])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:46:b0:349:7f0a:381b
 with SMTP id 98e67ed59e1d1-354b3ba3608mr4083757a91.8.1770437417386; Fri, 06
 Feb 2026 20:10:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:04 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-3-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70537-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E009E104D3C
X-Rspamd-Action: no action

Fix -Wflex-array-member-not-at-end warnings and document that vcpu->mutex is
taken outside of kvm->slots_lock.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.20

for you to fetch changes up to 98333091750d0288b1c64c47afe1950dbda1afe6:

  Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm->slots_lock (2026-01-08 11:00:35 -0800)

----------------------------------------------------------------
KVM generic changes for 6.20

 - Remove a subtle pseudo-overlay of kvm_stats_desc, which, aside from being
   unnecessary and confusing, triggered compiler warnings due to
   -Wflex-array-member-not-at-end.

 - Document that vcpu->mutex is take outside of kvm->slots_lock, which is all
   kinds of unintuitive, but is unfortunately the existing behavior for
   multiple architectures, and in a weird way actually makes sense.

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

