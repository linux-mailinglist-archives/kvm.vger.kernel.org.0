Return-Path: <kvm+bounces-15726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D478A8AFB96
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6BDB1C21F67
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C4D143C48;
	Tue, 23 Apr 2024 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="US/SX9Z8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9122114264F
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713910526; cv=none; b=tGcJfuYiD739YeNfksoP3TGJBQYNfNGnoR9/WpBHVzaY+d8laqvWNh3f9ak+nM6CqSqTE4kz5ZbttyKLd2t5ek2S1zEGkPOQv1mt60eXrseurK+mKK0xNjLAwCrN5fJ6eJ1XOITYUXuRAPBkIdvS8bwLLkRSPk4nVLcnfKirNkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713910526; c=relaxed/simple;
	bh=8Eq5YKT0ineBQwTUtfAzoRLg5ZlwavRsVat6yCoQTV8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tcogQQle3JSUT+ODI3NI3jlT7ofBkyA7cZyJDOsF8AGdLbfV1x0rNK/QLUdVFRe5ICv2zWve9o8ojWYe81UEMCOt/kugyY8jdvifbQayUiL0DbMBQzraiwhnO8cpbX+XjH5O+pSeau+am2pKpRcewW0Tti0yCqMAj4eu9aNwgCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=US/SX9Z8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfd6ba1c11so6651078a12.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713910525; x=1714515325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgdE9sJRcNfrGi4MDoA1mGaoGQKbgmrjBJBbxfscz1Q=;
        b=US/SX9Z8IjPGD4vu94vAXCpf57sIooDk9LrUkLRLIZwV0D6D68Zmn4cihf6Vtn3W+7
         GDYKswM0Ner4RjN5oMzIQI+VGK7rwgs2AQ6xnV7eqi0FJqWn9PMI8//hPx8i8Jfsa9uj
         uvLnqwH/hbxhNEMf65ZBQPT8j1uPSwLZpgnL+PutzleNyDCUgwkw78I/5l8AMC3DxvrF
         bODnLCn/bmG5LLdxGHip1iKGgbYCFkYJaQVSO6BrTBCXgaj0eMaDU7L7fC+R2JTCJhI5
         rMlCWPdtwsLtAYOqwPI15O9dkZ4z+2q16jSCWkPa7zraVSHdwhcl4O4OSAwvu2gp4y9H
         u33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713910525; x=1714515325;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BgdE9sJRcNfrGi4MDoA1mGaoGQKbgmrjBJBbxfscz1Q=;
        b=TNMTcK0G6SaHzdloMcl49byNLjYtZA/jmzDZDjrsjaAWy0mPgVtV8jVDojgPxAZSoq
         g+BXULUMJTjsOFtlGTBwFheQzsXGTfDzOrl2rQeqgTnjYwyhszSlDA6fu8AZD2oqL5Hx
         qxjE3qiOdUc6OeMEz3C5yQ4+VwKIYnDCCf4iqvVZQstMW8/YusbNUkIU08P4GL9gH+Gi
         p/EbT6JSzcOdmQ2VW4UqRDRuzdqsqR4AeevguOemXsenO25F6xGpxAAn0Db+RrRhNYPv
         gAIF5MKBBWSTmOV//rMJkZ3TJHYZcxKn5xMaOSRrbvOLRMhZGccbgnmNWTsBnUwVbBiE
         k4ZQ==
X-Gm-Message-State: AOJu0Yyg5ZXEy77sy6wIq8VX2uj8WbdZi9GYac76eW1lCIzbA1FerrXM
	JztatV1Si63dvfsGSVWbty1YFVP+IWnZAjbDInLfZC++j+gw0yT8KQ60hE0nhpl0LyoGCreZ//E
	NFQ==
X-Google-Smtp-Source: AGHT+IHcXc5BV0OJJOe91o+RJ3MgPTGpeYaTPpVvtxm4NQpRQ1M9e4fCIDJau5uDCa8tVOaMZDvToKSCKyc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3f0b:0:b0:5cd:9b41:99f8 with SMTP id
 m11-20020a633f0b000000b005cd9b4199f8mr3055pga.8.1713910524652; Tue, 23 Apr
 2024 15:15:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 15:15:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423221521.2923759-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: x86: Collect host state snapshots into a struct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a global "kvm_host" structure to hold various host values, e.g. for
EFER, XCR0, raw MAXPHYADDR etc., instead of having a bunch of one-off
variables that inevitably need to be exported, or in the case of
shadow_phys_bits, are buried in a random location and are awkward to use,
leading to duplicate code.

Sean Christopherson (4):
  KVM: x86: Add a struct to consolidate host values, e.g. EFER, XCR0,
    etc...
  KVM: SVM: Use KVM's snapshot of the host's XCR0 for SEV-ES host state
  KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
  KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.h              | 27 +----------------------
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/spte.c         | 26 ++++++++++++++++++----
 arch/x86/kvm/svm/sev.c          |  4 ++--
 arch/x86/kvm/vmx/nested.c       |  8 +++----
 arch/x86/kvm/vmx/vmx.c          | 28 +++++++++++-------------
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              | 38 +++++++++++++--------------------
 arch/x86/kvm/x86.h              | 19 +++++++++++++----
 10 files changed, 74 insertions(+), 81 deletions(-)


base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
-- 
2.44.0.769.g3c40516874-goog


