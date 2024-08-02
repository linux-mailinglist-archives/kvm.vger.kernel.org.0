Return-Path: <kvm+bounces-23137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF983946475
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81E13B21197
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACF458ABF;
	Fri,  2 Aug 2024 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkL5LQkg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D3174BE1
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631144; cv=none; b=cWOAnM/p0GQrN/JhPNDxBIiduwbUvBtylAcFpxl8xKKUQNjXKZ+j+4NMeTOUhxc5YREe0A3/FabnSidYD/ixvkLrJJNfG+ghRFD69BRdxKJAj4pug0+5+qVbGr9z4lOMx531emFMGaBSjG/tm1cwjW4HdlcY6RqV0y4saKjrRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631144; c=relaxed/simple;
	bh=eILvVM3I/xmxIQCck82oe/XPuH/GX1lEDyFaah36KdA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Hv8sq5es0EsGigG1oOKK9/AA0S2mdrZKbiLCOvMEvZXxFbJNORhG90uooUYlS/yzGkLWRBVdDuGvK7JF3FQxNiPwAcIsWpEv61eL+r3jOLazGKSGAItLZSy2R3igRyKIXfG1T0q3uMrGx0oNUQamdkQYxTkI9TKFuHmhtSVxi8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkL5LQkg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a242496897so6717719a12.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631143; x=1723235943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Nz2WB521W0xZbrZcNZj1NNDTPa13V4b8CcMEmJXXSg=;
        b=fkL5LQkgV2SiN0N/POaSRSgzszI1bpj4CXfliXoGKdC0YFpSCC775YhK4GI9tucZwS
         I9QZLoMWn4nqULvX56UIqgZIwVtN0n4LJtvFaQrUqUGUTo5JMF5IJjfKx+s07Y08pnc+
         GugKzSbDeAV7sRCMX6ICd10UkSnYIxGAok4UypfMRq2P132cS74oc/bMIbMw+FlmISIh
         SMneovSRVoKOxvmmzLKn/An/GayDS6bFfytkePKEWwg0W85sYB+8jIvdwmpPZkWMyszk
         TbS8sBUMO0rzfX22dw86RO6ljtyoSoiHP4D36ydci4aW6xMcCmi85GaFJXcc6+ZTeAAQ
         r/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631143; x=1723235943;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Nz2WB521W0xZbrZcNZj1NNDTPa13V4b8CcMEmJXXSg=;
        b=gGEGXJoqiBD2Ia4etorckeuwpJjiQN5Uhkoxopa5FALRBiEIm+nuuJXdRlzXgO7Hg2
         UHKbRv6+4vH8W+UAildQBWSBu5UB8omzQhKOmBYmtV9JojxLPHY8pOfBmn2Fh/pljVMs
         boLE8TcGN0/9vE36okoirNrP2Y5HLA8t90ty9IeZeChlDTe74M2SN5gQJrbuP8o0Ww3h
         1gHw51XUIj2KH5bTppEhhGnWcIMd75UQjHK7dNIgKWi4wYH0r/XtpL9lP2zk1L6qwEaV
         1Xrh85+X4d4UQ5Kt/2Vew18Shi2O+fbw0erdDnHF4Mb2egSVhY8t0xA4EUl4f5n0GNzK
         ZK4g==
X-Gm-Message-State: AOJu0YzNQ0EolYQt9PoFfGQQ4NfdJ/6GAdqutudGVt5lM0J3BaqpFi4V
	kFn9MR4JJABMHza7WdHfzBn6MNkyuEL34qM14kMQVeago7gGi92K8rDGlJkoLDLemdPqVscwsRk
	yyw==
X-Google-Smtp-Source: AGHT+IG1qkqa2/kentjh9dKRqmYyp6/hxPFxa8qU1BMtG45x2AD8kIAWRaMCyvapGUvm0lDrX9ShO8T7lxs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6904:0:b0:7a0:cd17:c701 with SMTP id
 41be03b00d2f7-7b74a9d0286mr8293a12.10.1722631142675; Fri, 02 Aug 2024
 13:39:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:38:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802203900.348808-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86/mmu: Misc shadow paging cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A handful of loosely related shadow paging cleanups I unearthed.  I believe
I wrote them when reviewing eager page splitting?

Sean Christopherson (3):
  KVM: x86/mmu: Decrease indentation in logic to sync new indirect
    shadow page
  KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
  KVM: x86/mmu: Reword a misleading comment about checking
    gpte_changed()

 arch/x86/kvm/mmu/paging_tmpl.h | 61 +++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 30 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


