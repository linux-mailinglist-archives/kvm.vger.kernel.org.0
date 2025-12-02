Return-Path: <kvm+bounces-65053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 22074C99CC6
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 02:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 226CD4E2733
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 01:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD41722A4F4;
	Tue,  2 Dec 2025 01:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z0CpjkuC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD602248B4
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 01:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764640254; cv=none; b=tUTC7MxhFQ8asJpB+vFagXJBX8rl6GUuSymrjUSeYztoEIiz5M5UkfgdX91w5gd93M84JjQqwCQEdsY7tk9tH/fIHaXX5tC4YymusQg7GDeDs2g058af4DCU0Rm/BgYEGkSyDaiFzD36YZEkaudmhES8eTTNSigaAC+e96MADTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764640254; c=relaxed/simple;
	bh=GJsgJE42hahCrSlO6ruVXUTJwUaytLSg/1t0nBGUr3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=axUDVbb/5NeDDs3SYCBAzJDEusSRHnelJ07x/z3uF994WzU2kHVVCZYp19VPJvz9Bc2VCir/6zLXOUQKWwWHcuKWf7q7/TcXyfIL0Ah968Q9RtdlbmrfaRYHPyEcOF+v4xJvQu+jl3lDIbuiNocfKRftSwv9Z9RbqmkZYrQ6/aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z0CpjkuC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso8107749b3a.0
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 17:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764640253; x=1765245053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3D61cNh0yfwOk/9cHtCVfA9iuP9LEn/jtfYiGihcV+g=;
        b=z0CpjkuCyftl8akL/zUwGs9pJnsYe4KX118+6ubRSTzw83NhLZN1MM88eecZWhoJ0u
         P5Cr8GTgbFRAIAwne1Jxpruf8/KQ/DyUrc8j1v1dw7UuHTME5rbVTXJhmCF04BoxYOIP
         OUl5/I7eOnuawHukhuf1e4W+HKyI4T7HVtOTM1uU+/yZnzoO2nFV/gzFSzxp3bupbHJ2
         H+coIlySwCSVA5JYZgpej9LznNnSgfcmZDmeb2Ngq+fyTTWPTXifSBYwt1YTrd39Dm+7
         tixB2JqZplKHhq9HSRAhtQqP7g1OceQCvBO0z2voC7RMrp3r2Y5+Tkz3qF46vWvCNdZ+
         uDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764640253; x=1765245053;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3D61cNh0yfwOk/9cHtCVfA9iuP9LEn/jtfYiGihcV+g=;
        b=XKiBYb4B+JNVRoWcFoMmdJw3xos4u0xx9BNbLAWGY+oqWp+DTh0dLpryUwYcX+a21E
         hk3LgL4ib6Mkd2hFjyws50Hg3PmMPlZZ/J0gk34S6BNlmSn177MvFkmZEirDejO4vEFn
         sx9Z/srwopMyUvq61YFPtmoWGJatbdiQbRqVPqeftjen57GwnLz7ltiP9ZOz5HDDttpb
         k4aynDPgz1xRZA/ezuP5q/x9XzSGa9Vg3MGxpTnmeUXM9Q+In0YJ2tGcqg6PDaKc/SEa
         mKkwC37r6xtTxTWVuhGnZ3Lo8Lf3F9tTYphDWxIMi/jXFd39VYBhAr5r9LEnteJBkqWp
         vMfg==
X-Gm-Message-State: AOJu0Yys5k0nwzEtarl8vgHK78AdWUChbhRMTPlaM74D78zf798vYDPv
	4YIUUwUQ2UtWTuW+80B56saOUJ5CiWJwZPtd53aDPWU0i51iz5VSvSQdYe6+NzIS9MSc/B+Jrcb
	br84hOA==
X-Google-Smtp-Source: AGHT+IF29RfNiVdWAFTFzDpzMXQokkiwTYtIrFtwKcAMTTVB94hBWPhw+A9w4nZaJ56IxiONDOrTIxVJyvs=
X-Received: from pggg22.prod.google.com ([2002:a63:2016:0:b0:bc3:57f1:bc8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f86:b0:35e:1a80:464
 with SMTP id adf61e73a8af0-3614ed95c93mr43581424637.46.1764640252659; Mon, 01
 Dec 2025 17:50:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 17:50:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202015049.1167490-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Do runtime updates during KVM_SET_CPUID2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Do runtime updates (if necessary) when userspace sets CPUID to fix a bug
where KVM drops a pending update (KVM will clear the dirty flag when doing
updates on the new/incoming CPUID).  The bug most visibly manifests as an
-EINVAL failure on KVM_SET_CPUID{,2} due to the old/current CPUID not
matching the new/incoming CPUID, but if userspace were to continue running
past the failure, the vCPU would run with stale CPUID/caps.

Sean Christopherson (2):
  KVM: x86: Apply runtime updates to current CPUID during
    KVM_SET_CPUID{,2}
  KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtime
    updates

 arch/x86/kvm/cpuid.c                         | 11 +++++++++--
 tools/testing/selftests/kvm/x86/cpuid_test.c | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)


base-commit: 115d5de2eef32ac5cd488404b44b38789362dbe6
-- 
2.52.0.107.ga0afd4fd5b-goog


