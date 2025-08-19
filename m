Return-Path: <kvm+bounces-54962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EFFB2BC9C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 847881895948
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F2F31A05A;
	Tue, 19 Aug 2025 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vCDwbNif"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DD2315771
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594540; cv=none; b=XNmPvYOHfU1M1fzmCBSw3rUUM3kOlLE1tKd255NgXqNjBXE6pxh07PuyP+Kt3JzFvNclRpJEEeWcPwu5Pcydzo45pgVynQ0yRzsaXtLaolIWUXxFLTLpy++shV5nmTS4gnZ6bP3zWAL8kJAN1bVzWngmVZc6fgGRrN4RnIJvuNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594540; c=relaxed/simple;
	bh=32eSy7Z4IW+gyNmSJKf1tVe8I50lsi+IT5eOuyiXjTA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OwtwucziB8KolUVwBXrzRF4NN9426hj4f6koOPcGT/YxwjX7kSBNuzJhfmbrPuwDpHuNuAJQYcFRASV2j0uhZZfihEoXfQVeQqafnQLM2OYi29brTfdViSDh8JnDPoVfRdUCsXOrHNwyx6tj8P42R6R4qLRIqNdAdFNByFhKrOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vCDwbNif; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso21890765e9.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594537; x=1756199337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xSaurBdtkeatTy6B+DotbAZ9znHLVwGVjALlNHAHq3k=;
        b=vCDwbNifQjDaBLXADsOljIrfDaEyhJorqc26Hpxb1QJnDYSRwN7zskRMEA3j4XKqXV
         sCk2/YKCCM5wyegGBhqZI564HKx+Xff1uuGDa0qN7wxduo53QJtkdOcEiazlwe5YcFPD
         kqQKO5tf+G4HxbGze1ZUeJFW8jgbyZfBAPnWx3Jt5KhTNTCAH8NjC51hY1qBp9RESq4q
         vWeDCYcjfTw/qP8NnRtZ4u4Zmq7pDYjDpMXJrbry77URalvDe0za2o77RU9nCn8l1rEM
         630+w0nAVLhPt6uUtpTY3LHRDy6/wE4Pwgvxq5DteU1f7BwmeFbwmhrl3bHTMycsygH2
         d3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594537; x=1756199337;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xSaurBdtkeatTy6B+DotbAZ9znHLVwGVjALlNHAHq3k=;
        b=ML22u0XTXnTgc89B6hpp9doPZK6DSWS3EVyhXnm9SjLnfS3aeRDTkEEgi9jZxYR6T8
         8DmYd7tkh34vn0ZDgsE01Wft2gecsTzQUNm2A6uGrX8iR+k/RkanR8VtWb5HcuCcwT6G
         eUql7Gr7ee8YXlEembXCphj0vpK+43xrQyXn/U/Gs573BNyxZ5OR7Fez6fV1A3N6tJZ1
         QsekFt9/yaKHCAtYG6n9yVeSUhvw76C+mdyTHVlXhzBAZ5OCQSGeicZDcmgPeuv37HIn
         sVLmNFo6gOYy/2X9f1wJIJ2dFMmbM5X01RqyzPPIf8PfL3UzyRYJsDKIkbJgOFVesa+q
         mmwg==
X-Forwarded-Encrypted: i=1; AJvYcCVUf4XwL6fkj2BRkR2tuFON14CbLI/Sn9aVvkMwwnw2PXHzn2/UakFPGqddtwvMNdlA+GE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxURB7tnzw6P/2CFZZCVpLH47n23n7nOGp1GNZVXhRfUzjmk60k
	fX+zxMjoElB3FkbP3bEay19moUP1bnaDkjdqJoRtREsiwp9sMtM8v4jlBY9/1EjiL+E5M++WHZB
	m8g==
X-Google-Smtp-Source: AGHT+IHFzh5SplXqAOBrKAfeyO99AyDuMMskBj43Avq17S+aAskX3w24CpOWJaJWAvu7y8AaSea+fSpu8Q==
X-Received: from wmqa2.prod.google.com ([2002:a05:600c:3482:b0:458:bdde:5c9b])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ecd:b0:459:e35e:a90d
 with SMTP id 5b1f17b1804b1-45b43e0bf28mr11429015e9.27.1755594537022; Tue, 19
 Aug 2025 02:08:57 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:08:49 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250819090853.3988626-1-keirf@google.com>
Subject: [PATCH v3 0/4] KVM: Speed up MMIO registrations
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

This is version 3 of the patches I previously posted here:

 https://lore.kernel.org/all/20250716110737.2513665-1-keirf@google.com/

Changes since v2:

 * Rebased to v6.17-rc2

Keir Fraser (4):
  KVM: arm64: vgic-init: Remove vgic_ready() macro
  KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
  KVM: Implement barriers before accessing kvm->buses[] on SRCU read
    paths
  KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()

 arch/arm64/kvm/vgic/vgic-init.c | 14 +++--------
 arch/x86/kvm/vmx/vmx.c          |  7 ++++++
 include/kvm/arm_vgic.h          |  1 -
 include/linux/kvm_host.h        | 11 ++++++---
 virt/kvm/kvm_main.c             | 43 +++++++++++++++++++++++++++------
 5 files changed, 53 insertions(+), 23 deletions(-)

-- 
2.51.0.rc1.193.gad69d77794-goog


