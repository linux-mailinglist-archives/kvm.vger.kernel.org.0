Return-Path: <kvm+bounces-65337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF46CA7065
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7769339A1753
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AF8315764;
	Fri,  5 Dec 2025 08:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F+AAs610"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1130F52D
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922502; cv=none; b=u6zjTU+Oj4b8epi5gIKzysyP9NQX0BLDCnzZSfG9zh2q87JUZWytcAT4F0nojSmxuPxJkQXNICFMlS3g6MMJMQrPNtIJ0p0EftIhT+huoyB95acCPnhVMTImUoFQxkOLeiMyTHBCw2QCT11QbCG2wQkEIyK0ctAaHUYcW617eYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922502; c=relaxed/simple;
	bh=VdRgwony+hfb07TSupGoQW0dC9mvWV/vKNjnvAs3JG0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Zoe3S4ArpbygbOR1OOaoIRgpCuvdK779e8eIe+71y6Lq7n1wSkB+NI8aXM+T3FrmIfflFUIH/fNidJ9qzc6T3Lq3igZ9ZDqN1y8QyivLhtxUD/rUw5pCxiWu5J03getE9BlFrSfkKTcSHHbPgVTYEjAVvnZPffjH76mmPEom8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F+AAs610; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f12fso4703256a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764922491; x=1765527291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=chLCDCN/bLxjg6KXhFeIpS1ek0WHKMlwBFDx76djgjw=;
        b=F+AAs610zfq7M2XnyQKMT3AbEZXBxmw5vnamLgLRkcbghPtQVdiIn8Q4nHHc+zoJd+
         7KtWPz+iBgX1PEHPnNlHLcDg9rf3aa+iwZCUR2d4eJBrRaF/Il3qAyvsJ8FLl/j1W5tX
         ak+14UCqu/0tpnvqDNTk1KXQUf4NEnQHQgNDi+HjRHo9OBI5b4PQkgZP1Vxrv4IFiVnU
         K3VM8B2SFQ9saXVA9Ki6f5JhXAe8G51fklSrc6ibr3/FIdFUU3rBbrOkQEAcJG5QoTEZ
         FauCRMpNI2/cT/6IiV95HxorjVkkdljCTH3iPLoH97v13ya+Nf90WClunRaTuLHXw8GZ
         n0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764922491; x=1765527291;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chLCDCN/bLxjg6KXhFeIpS1ek0WHKMlwBFDx76djgjw=;
        b=l4b9yRDHiVr4aOkvGUd8UIRq+ATQZvhrRD6ujt6WMhLKosuq6rhQO4JYvrhkXcCU9v
         Imsw+y91/V5KHO1op8rNcfveB7iFFRa2tlDo/PPrq0tkC6aG+Ski31OF3wVgz+4FnEaQ
         dupfzfoUHNy5NonTlduU8q9NDGXKzuNaAfp5jgfW90xAJPZ6Q4WVLx11zDHTVaXSuYGe
         ArE1ztFN0wi+Lj7RFennw/zlWnJcYpXcnq50zSdTz0qWxdEzUd8PL+RcbiTVvjmQHxdW
         poTSBsd5EWZJ6Hdla8MYXUQNG3KYKqkjTvufwJ5v/+IiUNqQiZ8mnixLpPTzImh2uZVC
         EKXA==
X-Gm-Message-State: AOJu0YwVBsVU+gNHmAvkTyIX7TMCGWqfRRnA6NlD+yORH+qqzsxhZEbx
	9bz88aocjP1c6+d0OST1Scsc1tuXkiMUf+5KKc//Z52UYiBBgH3Wb3BLaAyD78uXHmkBxr7OCrS
	wu58ockYS/G5Fu7xRFxKSK9teddBs9qd4GCdiQBmxgC9/vvT7fLCOEYrEnQLJvioMIXLkNwuo+U
	dXP80/On2T1OOA5lHIf29zC3HwdGuFIbWBHTLb6ADMkNg=
X-Google-Smtp-Source: AGHT+IFgrhPzN6ujRsmcZH/kFOycH/YRPgQGH/UrPbCI+OpUfHHUDjcj2achJ4ipAHHRDzeMDt06P2n3/1anqw==
X-Received: from pjbsy12.prod.google.com ([2002:a17:90b:2d0c:b0:349:12bd:418e])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2ec3:b0:33f:eca0:47ae with SMTP id 98e67ed59e1d1-34947f0a26amr6323775a91.28.1764922490709;
 Fri, 05 Dec 2025 00:14:50 -0800 (PST)
Date: Fri,  5 Dec 2025 08:14:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205081448.4062096-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86/svm: Add testing for L1 intercept bug
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

If a feature is not advertised to L1, L1 intercepts for instructions
controlled by this feature should be ignored. Currently, the added test
fails due to a bug in nested vm exit handling where vmcb12 intercepts
are checked before vmcb02 intercepts, causing the #UD exception to never
be injected into L2 if the L1 intercept is set. This is fixed in [0]

The first patch just adds the missing intercepts needed for testing and
restructures the vmcb_control_area struct to make adding the missing
intercepts less ugly. The second patch adds the test which disables all
relevant features that have available instruction intercepts, and checks
that the #UD exception is correctly delivered despite the L1 intercept
being set.

[0] https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/

Kevin Cheng (2):
  x86/svm: Add missing svm intercepts
  x86/svm: Add unsupported instruction intercept test

 x86/svm.c         |   6 +-
 x86/svm.h         |  87 +++++++++++++++++++---
 x86/svm_tests.c   | 186 ++++++++++++++++++++++++++++++++--------------
 x86/unittests.cfg |   9 ++-
 4 files changed, 218 insertions(+), 70 deletions(-)

--
2.52.0.223.gf5cc29aaa4-goog


