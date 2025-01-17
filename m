Return-Path: <kvm+bounces-35711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B9FA14754
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA0DB7A36E1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6BB60B8A;
	Fri, 17 Jan 2025 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k0D1iL+B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8733B1A2
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076046; cv=none; b=fD9IxnS+E3iqF3DFpKEvyFlZtNuUHjWEAhO3gD41DiiXLSvRVUaJncFM8fD9Tfyk1T13HckpCjIw+hmCxKoremh8SrgRQfmKTTMAtz6kUDvwTzdOQuDSq/7tc6GwECnV7DTILfUBOYvwxNQH7a8ujwryBUDqQ6qZPf/JaiikSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076046; c=relaxed/simple;
	bh=qpA/HS/hcYeiDLvsXeA7x5x3OCthEeV4UdZL1MFUbzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uvr4d12OiD3y+ySMBcjXolNAz1ow8a5S9LvGasDISLLznvlNvDtHBfNGMvPX71GxovoQUyRtWO3wWzETnFzHiyAZd0IxjFXdNHsddBUPDtmCBav5ECh3DYQ5h2HaHOQ5KOdnW3eOK/gi4SFOjax3GZvNaR57Vsje8S4deiQ//nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k0D1iL+B; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so4751653a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076044; x=1737680844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VU8rG3wbxiD5WX7cpIQ6nnCKf70DY+JJY6n3oJHVv34=;
        b=k0D1iL+BR4HXdDOOmmlKoXgtIOE0E4RQp97MUPe7IQM8ZKcMkvTYfhSnQeCovYUZFD
         2ej+gLLsDP/poFanzc2TDanQwWQqaOZwetGU+BPE1dgIVQnhKx4+7L2AAXvtx/iOE4PY
         LEUAvtBypiL/ewMciCLppfGnnMdX0I/VKcujcabxq2HrUbScA4seuGp+t8Ns3geijF32
         NuQd3I2bH/1JOeENMpk3lKojle6H3aKXvU78IRyR+fpctn1C3WFAt4QGtg33haGcfBX+
         pTJgWDZIA1sxZuWcjehvpdpnGKnje9VHo3uwxWPNcQkBhJP3rSRu9bXMyJoWIVTyrWTE
         t3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076044; x=1737680844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VU8rG3wbxiD5WX7cpIQ6nnCKf70DY+JJY6n3oJHVv34=;
        b=Z9/ZvgLLVP7gyERngwWByy5ZivtrFQ6/gE/txeps8LqznbG9api3g3JbgZCDhuZuby
         9makNyz9h8qFGyEAeKkLJdh9rTpINfu2VKYUFtDepRn3OBw1cMSGd1i+CvUB8kiBLYb3
         MDRRpnP95jpb1IZgyw/67TkaPwn2SFX/wPrSRljDEp1pFvmtsufhW1J3u4MNBNy6J8AK
         GpaRSAX8z5dQFt/ndfhbzvfRgDaYJYrn0zh+WxEB6fQDpj7ewwvxydaij81ET2nfz0E/
         TQgEPuLaWzXii3WQ1dnHzIEf4SB+3PKuclH3E44vm7hY0SUISM2KyKYVbDuBK42FjmF7
         wGBw==
X-Gm-Message-State: AOJu0Ywn3oZ+97jDSk0AaVDZw6WAWojXvrF4vQiGBBSYE0X9tKDiXBHj
	pvDIiJRauy0OStcpi/lVoJw8lr4CnIhmW+IEpGnOoE8y3s8Sa/tu6FAN4LwPUvccP+RRLWWAvCd
	3Mg==
X-Google-Smtp-Source: AGHT+IEaFVBzNUrxyScuhX8vTooc9zn9EBakG/GhKgs+NUGlCzDg7Zfdg3X7gZhOr4zM6s/BKXz8SuKIsuk=
X-Received: from pjbsn6.prod.google.com ([2002:a17:90b:2e86:b0:2ea:4139:e72d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54ce:b0:2f4:4003:f3d4
 with SMTP id 98e67ed59e1d1-2f782d972c5mr1002813a91.30.1737076044148; Thu, 16
 Jan 2025 17:07:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:12 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Memslots hardening/cleanups for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a small series to clean up and harden kvm_set_memory_region().
KVM s390 is building on this branch/tag to create a KVM-internal memslot for
its ucontrol stuff, hence the dedicated pull request (and I didn't have any
other pending "generic" changes).

https://lore.kernel.org/all/20250116113355.32184-1-imbrenda@linux.ibm.com


The following changes since commit 10b2c8a67c4b8ec15f9d07d177f63b563418e948:

  Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-12-22 12:59:33 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-memslots-6.14

for you to fetch changes up to 0cc3cb2151f9830274e7bef39a23dc1da1ecd34a:

  KVM: Disallow all flags for KVM-internal memslots (2025-01-14 17:36:16 -0800)

----------------------------------------------------------------
KVM kvm_set_memory_region() cleanups and hardening for 6.14:

 - Add proper lockdep assertions when setting memory regions.

 - Add a dedicated API for setting KVM-internal memory regions.

 - Explicitly disallow all flags for KVM-internal memory regions.

----------------------------------------------------------------
Sean Christopherson (5):
      KVM: Open code kvm_set_memory_region() into its sole caller (ioctl() API)
      KVM: Assert slots_lock is held when setting memory regions
      KVM: Add a dedicated API for setting KVM-internal memslots
      KVM: x86: Drop double-underscores from __kvm_set_memory_region()
      KVM: Disallow all flags for KVM-internal memslots

 arch/x86/kvm/x86.c       |  7 ++++---
 include/linux/kvm_host.h |  8 +++-----
 virt/kvm/kvm_main.c      | 33 ++++++++++++++-------------------
 3 files changed, 21 insertions(+), 27 deletions(-)

