Return-Path: <kvm+bounces-66415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF09CD2277
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52475302E056
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8F82E764B;
	Fri, 19 Dec 2025 22:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="akF3qfct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405C628CF5D
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185155; cv=none; b=lNXFZI3U+KN1oSok2Un2/hDq5WiP9D0jwFtiqZ6KfiiEFyC7A2sBfKIojGDPTutK5A/2mVwpGaMWPmdGKfjr5KPwIt8yLWgpM6yTQ7MEfgNcEhft5MJy5C8JVsn4V+3Lm0aWQj7Oq1AskSrwrz4pApv9llZ2iCBsSLnCCXaOpfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185155; c=relaxed/simple;
	bh=M2tg553+EEYFBGinSwdnwaSNTGcy3iqE5RUZo8upxMU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=px9RBPaoLTuV9KQl17WZlo1nhrOBIIY8wLHGd8KIov4ofSRbbQPr9FnvLtG6ZPs174bkuAcn8jcl+QHcmOq3HAlVFDdoeWY4RcINq+OoHfYDc5f8OjSRyfJxkHmkyk+58pCwaqqzxZ16khfH2tfF/9+QNJSuo1J5mmnkiMcI5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=akF3qfct; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34a8cdba421so2719474a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185153; x=1766789953; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8KPnG9oBVya606n5ok8wtFFzhpLR+TIlM/yllAmSJXI=;
        b=akF3qfctkHwt1BeB5V84O7d42mDTpP0m0hrnOUTVu9pn+ze9hTA3qFzr6b2Kl8eS0z
         7K5CoQCMbfFWBciLbTPkdKXX4sl3I9fTBLbeUFahVjRM9KQbJc70auBPdho2ncizQ+sH
         yg9YKTMvTGWj0t8B13y4ZcP4LL91UObGYdJhTrsQ01jlhykusr5wgVOSGUMSZsrMdqDn
         IulZO1CZr6Pka8QshvoGQ9VyTzdBqJ4sU9apeWTpn3E/tFqb+apmyWipWe52U3VBfA7s
         RAUISRTiWIn+h2oRhGA0BqzZxE0S76QPPp8WkAXwZiRg93vmtJVnSYlQnbgD9sDdCT6n
         yh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185153; x=1766789953;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8KPnG9oBVya606n5ok8wtFFzhpLR+TIlM/yllAmSJXI=;
        b=WFVsQym0YMWNY9iLlPh0JXfYtIkom3zdiK0S+Z6XcB6aDBEr2Z2d+JwSzCVxv0qVan
         XXxE1XwgGerXh9M1S7GNtEeXpv0uimyc9SGQkqaXurEsgFMnWRSjsDX3aZLl2yvo7vRw
         rWJ8u4cLof6P4cx7yaqebyMCTK1CBSWOq4UE1x0mmYUhADmO4syxM4xi0iKskgBaBOlY
         rLyJKQlgDez6qOcOoHJRZg1J1s3U802XEyFdh5nf3qlTrIr6qSlvBKNId3fzmQIuViqG
         kx7UbLP+N2afyoBgLkcTV27qgsRQKlMHcOGSBaWGkGCK1lVk9/+GzcefHe+1zU+ZO5zn
         yAzg==
X-Gm-Message-State: AOJu0Yym1/vdPC/fAnjIl7sEIzvcN6b++VGQEt7y53mGZ1pJxZpNrlMS
	4LVnDxsXU1PKGmo/xVQVHIFRodB1P/KsESWvChqikdzNaj3zz5nn8Vd+iKfbkJ3EdOSjp9+Ym08
	RDGPZfGswzmN/QNwNguiKHjebyrNudmkAASFlsPhGAyuLW5qTVJS+A+UDQ3GqOIEdszaWuoqZ7d
	6HVAhUGQImfijTKtDXkL3dPa27vxpfh0kv4PjaiQfCS1U=
X-Google-Smtp-Source: AGHT+IGR5MdlEdotg1TR5q3oIjFi3djyoAJKlSn9SNXTQ98deMaHsiGJn+9clPKlHXifLXsCF98PgrUVTYX4Bg==
X-Received: from pjvb16.prod.google.com ([2002:a17:90a:d890:b0:349:9a0e:693d])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1fcc:b0:34c:6124:3616 with SMTP id 98e67ed59e1d1-34e921ddcb6mr4305712a91.27.1766185153332;
 Fri, 19 Dec 2025 14:59:13 -0800 (PST)
Date: Fri, 19 Dec 2025 22:58:59 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 0/9] Improve test parity between SVM and VMX
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces numerous tests for features that VMX testing
covers but current SVM testing lacks.

I went through all VMX tests and identified which ones could have an
equivalent test written for SVM. If there are any gaps in testing that I
may have missed and you would like to see an equivalent SVM test for,
feel free to add a suggestion and I can take a look :)

Note: This series includes and supersedes the standalone patches:
  - [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits sent on
    20 Aug 2025
      - Changes suggested by Sean for this patch have been fixed and
        included in this series
  - [kvm-unit-tests PATCH] x86/svm: Add unsupported instruction
    intercept test sent on 20 Aug 2025

Thanks,
Kevin

Kevin Cheng (9):
  x86/svm: Fix virq_inject SVM test failure
  x86/nSVM: Add test for NPT A/D bits
  x86/svm: Add tests for APIC passthrough
  x86/nSVM: Add tests for instruction interrupts
  x86/svm: Add tests for PF exception testing
  x86/svm: Extend NPT test coverage for different page table levels
  x86/svm: Add NPT ignored bits test
  x86/svm: Add testing for NPT permissions on guest page tables
  x86/svm: Add event injection check tests

 lib/x86/processor.h |   6 +
 lib/x86/vm.c        |   2 +-
 lib/x86/vm.h        |   2 +
 x86/Makefile.common |   2 +
 x86/access.c        |   7 -
 x86/access.h        |  11 +
 x86/svm.c           |  16 +-
 x86/svm.h           |   9 +
 x86/svm_npt.c       | 799 ++++++++++++++++++++++++++++++++++++++++----
 x86/svm_tests.c     | 644 +++++++++++++++++++++++++++++++----
 x86/unittests.cfg   |  47 ++-
 x86/vmx_tests.c     |   5 -
 12 files changed, 1406 insertions(+), 144 deletions(-)

--
2.52.0.322.g1dd061c0dc-goog


