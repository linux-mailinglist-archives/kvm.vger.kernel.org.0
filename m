Return-Path: <kvm+bounces-28036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658D4991DE3
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 12:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A06D282746
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2631741FD;
	Sun,  6 Oct 2024 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="csmzoKfK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FF21714A8
	for <kvm@vger.kernel.org>; Sun,  6 Oct 2024 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728211104; cv=none; b=Ozd1wdOMFVRnavuRB50x6Qi4KyHuoEUIz2X0hBi2jefaRtaZT8z1oWyGkO1IDbcy2LSzOl1+cGjZwPyXbzsBB/stlVyEkQ1XHFWMoPS5rXI2MP/fI9zOF3YPa1AeKLMnNxlHVpQ6m9J8l2zLqjZUbp93jUd+GJ5yp7pfCF+6s20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728211104; c=relaxed/simple;
	bh=f2xxi2DKOs66PGZFJ5bjsk68GauCtWp8hrFiJiYR5JA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGdP/Fx3R3CtV+UQTF59reV9wOSNevFzTZoS0KXI/lmdpdBtNyKiJXqqd1RyPtCu7ik8Iwt3CwW2jj591uoxcIUxNUamdqclARvS2h3fzLGSPUItlfbX5teuPVBzmWOx2jpM91tv+8SiHrxCE2sV1BrUtPzUjutMYLy6oKMIL0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=csmzoKfK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728211102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3jIevzNX1rCjaTgjZLvCdPeQriMBLs6C6UIuyj0VsKA=;
	b=csmzoKfKIKa+wYSgLpVFG9D7KrgRfJhgt/gofk67A+ki175DsGz1QpQzUwTkttsD/wxyyb
	a1mW4qxsiXM9nF4qfeDU5qp123QPIug0PtJD+SqG3g6+JUX0GlKCbTq4F5XayakhTAxhzM
	XyuqPRvvziH+KvFnU+VR4WPK1WxeS3U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-78peGwRyNuKpBPgpg-meZQ-1; Sun, 06 Oct 2024 06:38:20 -0400
X-MC-Unique: 78peGwRyNuKpBPgpg-meZQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8a92ab4cdbso329607566b.0
        for <kvm@vger.kernel.org>; Sun, 06 Oct 2024 03:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728211099; x=1728815899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jIevzNX1rCjaTgjZLvCdPeQriMBLs6C6UIuyj0VsKA=;
        b=fp7+JMwZxGv4GfbcOK+vr4itrY2RduI3ERBNC9JQzWww72OMbLuVuVmpMFiZyxFIsH
         yxlD9q0ZoXW0iq+U260LgX2Wc34n40zxYdDUaCTtkmgY4i6MIiGFn1UZck3/tUsSLo9H
         Lv9JQ9GCM5iabdWKeFoEXA2yWuvDPQCLIYA32YYBGZgvM627SmrTYttdpYVx3kMNKJHr
         lYWJfl1QHtyep8nP1gH4m7ExvgnpB+N5T0StYrc+KmWid0NBSvmBk0OHRWjDxSWUD56I
         lrTE4+WT9ZmhQGta3dY/JcFjQx1catgVX+377vGPXRFxnM0hfZsumEArNZHUvF1Lxla1
         r9bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMOvaVatiTPSlxjDo3eUXh6rSweCqI+0QsN27+X6o9Z4nPvHOhu3O1iwsqCPrEBMO2GLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhLy0icl9Rv5GffzHge6eURIqeC2d+jQ7zH2oTyDZeMVYjA6Cv
	ZBpyuFPNSQMt/ZKaSnytrzroHuZIqYlrnT0JS/yG64aA/qeTL1YtQzhBmgAi/J1FESHiDLtC6VM
	BcdmPRLa++V9vQVL3PjHmQmmxg81YMvvUW6kagMIfYzHN8N9i4YOgMp4pr+nF
X-Received: by 2002:a17:907:97d5:b0:a99:3eae:87f3 with SMTP id a640c23a62f3a-a993eae8b86mr403715866b.47.1728211098984;
        Sun, 06 Oct 2024 03:38:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnLTM5tVtHu/M77oCObxmLChhB1MJWc1zEWDoVC80fUmtRwNGJNwtxYPzjHmHgXDBx8JZuTQ==
X-Received: by 2002:a17:907:97d5:b0:a99:3eae:87f3 with SMTP id a640c23a62f3a-a993eae8b86mr403713766b.47.1728211098583;
        Sun, 06 Oct 2024 03:38:18 -0700 (PDT)
Received: from avogadro.local ([151.95.43.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9937dbb84csm204933666b.99.2024.10.06.03.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 03:38:17 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.12-rc2
Date: Sun,  6 Oct 2024 12:38:14 +0200
Message-ID: <20241006103814.1173034-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c8d430db8eec7d4fd13a6bea27b7086a54eda6da:

  Merge tag 'kvmarm-fixes-6.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-10-06 03:59:22 -0400)

----------------------------------------------------------------
ARM64:

* Fix pKVM error path on init, making sure we do not change critical
  system registers as we're about to fail

* Make sure that the host's vector length is at capped by a value
  common to all CPUs

* Fix kvm_has_feat*() handling of "negative" features, as the current
  code is pretty broken

* Promote Joey to the status of official reviewer, while James steps
  down -- hopefully only temporarly

x86:

* Fix compilation with KVM_INTEL=KVM_AMD=n

* Fix disabling KVM_X86_QUIRK_SLOT_ZAP_ALL when shadow MMU is in use

Selftests:

* Fix compilation on non-x86 architectures

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: arm64: Another reviewer reshuffle
      KVM: arm64: Fix kvm_has_feat*() handling of negative features

Mark Brown (2):
      KVM: arm64: Constrain the host to the maximum shared SVE VL with pKVM
      KVM: selftests: Fix build on architectures other than x86_64

Paolo Bonzini (4):
      KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow MMU
      KVM: x86: leave kvm.ko out of the build if no vendor module is requested
      x86/reboot: emergency callbacks are now registered by common KVM code
      Merge tag 'kvmarm-fixes-6.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Vincent Donnefort (1):
      KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path

 MAINTAINERS                                        |  2 +-
 arch/arm64/include/asm/kvm_host.h                  | 25 ++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 | 12 +++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  6 ++-
 arch/x86/include/asm/reboot.h                      |  4 +-
 arch/x86/kernel/reboot.c                           |  4 +-
 arch/x86/kvm/Kconfig                               |  9 ++--
 arch/x86/kvm/Makefile                              |  2 +-
 arch/x86/kvm/mmu/mmu.c                             | 60 +++++++++++++++++-----
 .../kvm/memslot_modification_stress_test.c         |  2 +
 tools/testing/selftests/kvm/memslot_perf_test.c    |  6 +++
 12 files changed, 91 insertions(+), 43 deletions(-)


