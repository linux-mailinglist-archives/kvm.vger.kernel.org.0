Return-Path: <kvm+bounces-42765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65403A7C62D
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E8B5189B62B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C658121D3C7;
	Fri,  4 Apr 2025 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uDY4wntj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2704689
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804425; cv=none; b=YHPrIpmqiuLksOR/s+nsBoCxxx4QIWEQHq0Nj2RI68MKsMSKQDCMf6mNA+K3rTpQlY6RKhNSWSMvwUnUtT55qlO5ogXHQyydUUyESEGZyyzXOw32KG41m66u78fTbvongTlsl25Z0AdwtPN8IbQDczOx5BcI/gzGopRdvEB0wxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804425; c=relaxed/simple;
	bh=lic10qncMW0Yuj7ay3ptqbrzclOlFz0Wcn9Xa6mjD1M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=E7b84t4NZ5qeW//NL8HioSY8byiLWKTfzZ2IWLfZ7nLTHinIsvMvy6It6gU2I3aS8ve+KMBV1LubAyxpAgIjJAtAuJuh2YGjzpizq8+Mo4qWS8izaWTX5wI8U/v5hMyGgkx6JZQUMdCLzRxWUP+YJMn729tluN0q5RZd9+l5uLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uDY4wntj; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84cdae60616so306000739f.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 15:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743804423; x=1744409223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+ABQvf2myBmBVu0tO5Zf2gufLBIF2IPE6tPBCISSnfw=;
        b=uDY4wntjiC3Etm0xwfkeWyKS/0qZzSPjfQBloukXG7kN7Ut1JXzLEhrTUbKJyPZ4Pq
         fT9EpJhmnJF9fr0pCS+okHAI3GmmokWvux6V2lwFYEvT17FBEkvIwIhx8RcZS6eMFjqe
         0Sd3Yd0qR/+LejAx0qXQqED57aaz7XBLv3Ni6gE/cuGrEx9TM9flZpPVHXTGaZSg7eLf
         QdJJrv6BnidaBhQoM0d0ZU/I7SnY+tZK3bK+bh2BkgPVKGwFQkzGn0/L8BjiB6SNQCEn
         67vgP3kIe3wvpsIZlxEeCCOSX+L0GqREPenZtRbKCArdNA+fMN2pSK/rjCTylKCvypd6
         pNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804423; x=1744409223;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ABQvf2myBmBVu0tO5Zf2gufLBIF2IPE6tPBCISSnfw=;
        b=FSrtfHhNapEa93HqT/qXdAMZI/sEg7klkhG+aShMuMFNUzPGp4E7Hty9Px+EX3rWzg
         9OHFI7lQdW0y+VaKxpSX/luPXLoyroCUGOlD2sdIX29T0EYIRjZQnXmw5VLXe2MyJBbD
         TR/At/o4m5GkdRBHpljcnyv6s4EsBTad0FNytFbmBcK2JP5UBCvDPzVYlW869Of7i4vW
         2PtFhSozIa6COFhxHys5vrvf/1Kh8PMzWeiy7hVzWr6WGIpJvdnC+G4HPP/3SCVyiXIz
         NASTtP3Dl66230ihu22ahMBVeujy9fTrbm9J4/C/uZlLTyrHb1StCxX1HmcR90LFI3M6
         gTZg==
X-Forwarded-Encrypted: i=1; AJvYcCUjZkAgHtL29FArMLaDN1Fw8GGv1b+Wk+GmLpuqWmZg3MZGwpQyIF3t1dfncOeEGdm2Th8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvRtGNoJaYglTBu7nysBWUcrI3XKMo0jRM2O5yrjlpu5kJjCwW
	/2I7V1CGzRwGskWyvXQQE5FJ/3+QTHYG3a73cryiGq0IRuPZFFl3rJIv0DGFE9vamX0d3mNwiIV
	pTP3dxQ==
X-Google-Smtp-Source: AGHT+IFV9Isc4fgBFHlpxTPEvIA2IWM9thB5QLOG0FR0uQ2WcHEpEv2w8WbCsDqt+JLpu7IkXXi3TGByiQPr
X-Received: from iobjk27.prod.google.com ([2002:a05:6602:721b:b0:855:9384:bf3d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a82:b0:85d:b054:6eb9
 with SMTP id ca18e2360f4ac-8612ab4b028mr139258039f.14.1743804423530; Fri, 04
 Apr 2025 15:07:03 -0700 (PDT)
Date: Fri,  4 Apr 2025 22:06:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404220659.1312465-1-rananta@google.com>
Subject: [PATCH 0/2] KVM : selftests: arm64: Explicitly set the page attrs to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The series fixes a conflict in memory attributes in some implementations,
such as Neoverse-N3, that causes a data abort in guest EL1 with FSC
0x35 (IMPLEMENTATION DEFINED fault (Unsupported Exclusive or Atomic
access)).

Patch-1 is a cleanup patch that replaces numbers (and comments) to
using proper macros for hardware configuration, such as registers and
page-table entries.

Patch-2 fixes the actual bug and sets the page attrs to Inner-Shareable
by default for the VMs created in the selftests. More details are
presented in the commit text.

Raghavendra Rao Ananta (2):
  KVM: selftests: arm64: Introduce and use hardware-definition macros
  KVM: selftests: arm64: Explicitly set the page attrs to
    Inner-Shareable

 tools/arch/arm64/include/asm/sysreg.h         | 38 ++++++++++++
 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../selftests/kvm/include/arm64/processor.h   | 29 +++++++--
 .../selftests/kvm/lib/arm64/processor.c       | 60 +++++++++++--------
 4 files changed, 96 insertions(+), 33 deletions(-)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.49.0.504.g3bcea36a83-goog


