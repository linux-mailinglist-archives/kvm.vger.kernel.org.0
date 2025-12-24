Return-Path: <kvm+bounces-66657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BA0CDB176
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF27230204B2
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AAF285C8D;
	Wed, 24 Dec 2025 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p3NJjLTd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0023254849
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 01:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766540609; cv=none; b=KFLIAr40BA2eDcY7a2zf/FwMJf1/tBiTcjFC9ObR4zNL76JZGpJ0MSYQ7R3cHeod7MrKCoPOfYvVzbh2q99uD7aeXsC9U8mh/BhUWatTbAcZmQ9vAXZ/VaFNfVjO2QEOqPYKjIQAw1r3vHhhsBJJBAK5gcdZvpAc1cK5P5LgS04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766540609; c=relaxed/simple;
	bh=cWqFyWyoh0aoEMSSvb101uz+ubfMW/xxbIhBEF773SM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iXTwoARkHicvKchqS35zcYyoOLNxm9nc5mnaZKHVktRZewbcKNf9GnbtsR4amBxFAbqz3/6mfXNPbMIyTKbEDsaO5+WNfG+avVmhb6Xc5g03gNcPaWVo+xTtd95SRoDGVJ1F1ej1nGuFqDfmQ3avHwu1kFxE0WSn7+MGqw6bLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p3NJjLTd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso15100891a91.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 17:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766540607; x=1767145407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=shVBRO0tg4IZht2oazeN9bflZfY3SScEvXNjAqoYZi8=;
        b=p3NJjLTd+lDNrCxuVgtYQvoFZKzA3gGow8WQaP3471GJUdJUoYiMXd/Irf+S3lfOd7
         O1n1p9QNaqpLmDwMM2zly+5p0sFzgRtHSbw6R03drxyK2kpNc3GYoOJ9CK6td06C9Hgm
         NDuyZ/zkqbHamItemzU4zEBq2Vx0DLHBtBUm/9Dbsr3jRnwXAzwMwrI8CtV/FAKtnyvj
         leLylLdoAS9O32rP35Zyptz12agX1BHXeNoauV76X42GLE/ewnXi8DX/JXcwKMmuC9nJ
         G7xA+onar3Y0gJx5I0hsx3rGLhgZIc9/ydoj//M2SaoaCOu33+HY3Aa6TLRtl+DZyNDh
         dRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766540607; x=1767145407;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shVBRO0tg4IZht2oazeN9bflZfY3SScEvXNjAqoYZi8=;
        b=wDKHcrx69KOA27+zs11/a3AAkZX6mCuVJ3opCorARpLQsVKYZpFbRLMS+x4+/95XSO
         3gotr0elIRcMdG/SxvDyyheL8Hxod03/xpVemdx9ebBFVxg+HX+yh0n/+WCyg+LpItDf
         tAUJ6sh4Nlg57tBfe8ntLg/ZuivPWeanFM/j8q3bSWHREPyRXZjsuJ5HsobkrVTmJcys
         M4eX3M1bx+zkO5JD9fykTylPFQhggvZ1KFQCzpcnfs/Ur8Guf43fy6ehBDfC9Xx1jMgR
         q4P3qxgPlWRKbYu4cya9tVjmCoCj//ARvy6p4OC1uReMfkS8CdapEODWd+0w1ezKqx5m
         toRA==
X-Gm-Message-State: AOJu0Yx951mS97wEvr5OFnqCQFO/fSw3u1PqeJewgv4DP8kAa5XdC+l5
	AjELyifXf1JPnsfjRO8u83q7lV7Qe1jSFyyr24mTAuXXVOP8cW7FgJR7POUezxLnlConijGvC8b
	+xFY80CoZhM46lBmiwdtg9M0n+Mb/+Wnl4jVpJb4a6lmpl8P71hCkOqqQYMq9AVd5r1EOJW/TjF
	UsNynM0jPkvVb9xrL82Si5jnR2Eq98dfqFGVxE9TFPkV0=
X-Google-Smtp-Source: AGHT+IHWqE4oawu3zcvN9sxzHfJ831RswugVhDLvDTOz63fz+DElsSYgVC+FwnX3psoyBsd5yLSajNZbfAbUTA==
X-Received: from pjcc16.prod.google.com ([2002:a17:90b:5750:b0:340:6b70:821e])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28cf:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-34e92121d91mr14090691a91.6.1766540606857;
 Tue, 23 Dec 2025 17:43:26 -0800 (PST)
Date: Wed, 24 Dec 2025 01:43:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251224014324.1307211-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH v3 0/2] x86/svm: Add testing for L1 intercept bug
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

v2 -> v3:
  - Added assertions to unsupported instructions test to verify that CPU
    does not support features enabling tested instructions [Yosry Ahmed]
  - Added some comments [Yosry Ahmed]
  - Changed insn_invpcid() into assembly [Yosry Ahmed]
  - Added a check to the unsupported instruction test to ensure that
    L1's vmcb is not modified by KVM [Yosry Ahmed]
  - Redacted reviewed-by tag for 2nd patch in series. I mistakingly
    added that

v2: https://lore.kernel.org/all/20251215210026.2422155-1-chengkev@google.com/

v1 -> v2:
  - Added save/restore helpers for all intercepts as suggested by Yosry
  - Reuse invpcid_safe() for added test as suggested by Yosry
  - Include '-skinit' in unittests.cfg for added test target as pointed
    out by Yosry

v1: https://lore.kernel.org/all/20251205081448.4062096-1-chengkev@google.com/

Kevin Cheng (2):
  x86/svm: Add missing svm intercepts
  x86/svm: Add unsupported instruction intercept test

 lib/x86/processor.h |   1 +
 x86/svm.c           |  18 +++-
 x86/svm.h           |  89 ++++++++++++++++--
 x86/svm_tests.c     | 224 +++++++++++++++++++++++++++++++-------------
 x86/unittests.cfg   |  11 ++-
 5 files changed, 262 insertions(+), 81 deletions(-)

--
2.52.0.351.gbe84eed79e-goog


