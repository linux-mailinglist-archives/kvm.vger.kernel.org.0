Return-Path: <kvm+bounces-65332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2008FCA76AA
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 12:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A666F31DFCA3
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A1434886F;
	Fri,  5 Dec 2025 08:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UGmutRwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402733BBCE
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764921779; cv=none; b=i/8gZmdvK16hSxcQUbNwgx8c+c/uAWGLRiEAc3wnJxCzUmiKJyiaa9dUek2GBBAs9f6VwSPN6UuUcAMZYzydK4N3PSW4H1s6GyUCSl/7RXaoD2+Yq4pedq+3k6+R12zjoIU4wyp6V6slxm+xJZAFnchM3ux38jpn8Qtpdo1+1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764921779; c=relaxed/simple;
	bh=gLjViXbgReKHk/DwKUc6p8QExrbetkr2b4UGxWE0X3k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=b65eOQFfdpsBAnzpBN8DHeNBQtZ+WKDir2pxvINKwTwJiZ8Hg3Vge5Fx8gKg4ATq/IyVKpM1SRHtjhiHOoh2PvP94olBXJHVypGO8GWtXkLnSgi3h9HeqOJ4wpapuw+jSa241fNH1HSWWH3EqVIfuLwJopclPe/hRnUPaD+4FHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UGmutRwN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34378c914b4so3330712a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764921766; x=1765526566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KC4sBhpHRSsKwrbFLvuOSFE6OH9WoltcwwivWOfWz8A=;
        b=UGmutRwNBueS4ZCKJs+U/pHVOIVPT7DfvrNc9muzM5T6/HWnq8daxwjp1ojhkeayol
         oITMUcSR17lvZ6IeBYtPfK/cptZwjTj/hDpSo4MT9y1Vqr2hr8yvwDSlFA/Y6BXMbh3x
         3xiCMQLptLelnHTQvmWPSgSsnCvG/B8XMAYc5Q+4udjFVb0Ct9JPYM80OZWGMqLSbDeN
         qeFitdkzme0Z7M+h9zp/fBdXDQt0HLnxyJmgpPtUG0wWh+J0xXM7TtUb3doMURp+mjQr
         dnr0xs+kHDToUqGO/e5nDYpTwjzIKgfBp1DlDof8yvN9b9i+FY1v35tIeinxaNre7+YA
         xgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764921766; x=1765526566;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KC4sBhpHRSsKwrbFLvuOSFE6OH9WoltcwwivWOfWz8A=;
        b=XDJ1N+gz4QPJ2sAVCzErHY9ZArPbFmNSipjfBqviui7vBoEOvdjU7M6tVFJmbCCBSX
         K5ICuFUXzf1FeEL5s5CXTjd/pcznsYZqgQGXT0r4q0BDIWdmlZho3L8Kx1rnCS5ZN9N7
         BuAJL37gJRWFW4CAnXoLbnwCQm2Vs8HvkHPzzR7cDCY5dgV9WjDsB8cCbmFA//NxqeKN
         oDHFOGk15DIxexywcGVd005SxkhRwKka0BoZYM2mhPrqS0SiKe8iCy3D4FEqXbuRnHUg
         Bj03uAypcWm1lExkBX3AkPVaKJsnwe1BvYwzSUnuaiaIh9vBZzyv51RuLhnsh7zo+nED
         lAbw==
X-Gm-Message-State: AOJu0YxwKwaflOgQ+s1nOiOpiLSeeFL4zqL1SXYaKerhnNoyZxSlB6NR
	L+lVDblUTUdf8puUZK77hXgDCvuKHjNXWQIf4qOoJhhlPRazQGMj/DKioc5OXy0PHAh29oXYsf6
	Hb/YZqIgXtL4I2cae2IIYJHXg2kOOWiFWOsOGhCQy5EzGgiIhJJ8sRVDan+Lgg5S9/evpMeEM4A
	IK5H8lWP9nrZxc3541hevbHl+n9/uM/h2v4w6V0tjN6qg=
X-Google-Smtp-Source: AGHT+IFO59f3bdqDAUUgYTCbGH/pTP6LM/re86KNWuTnkWLYhnDeOuS/riBij+Zaul4V7sAVP4+qcj51WMLcRg==
X-Received: from pjbdw12.prod.google.com ([2002:a17:90b:94c:b0:343:4a54:8435])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f8c:b0:33f:eca0:47c6 with SMTP id 98e67ed59e1d1-349126b9a16mr8878218a91.30.1764921765630;
 Fri, 05 Dec 2025 00:02:45 -0800 (PST)
Date: Fri,  5 Dec 2025 08:02:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205080228.4055341-1-chengkev@google.com>
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
 x86/svm.h         |  87 ++++++++++++++++++---
 x86/svm_tests.c   | 188 ++++++++++++++++++++++++++++++++--------------
 x86/unittests.cfg |   9 ++-
 4 files changed, 220 insertions(+), 70 deletions(-)

--
2.52.0.223.gf5cc29aaa4-goog


