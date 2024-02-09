Return-Path: <kvm+bounces-8500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8E784FFC5
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E0B8B2B6BE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB9B39870;
	Fri,  9 Feb 2024 22:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XUqWp6W/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B2E38DEC
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517251; cv=none; b=Inz9B+eY5XpQjb70dE5b4dIPXbc9u5ZVfpmZtbibC6AFIFY1cj1gCorapUTNoE8yLwhUA1oaDMA++nPX9vZbcQHNXQmAALwpgB0dlZYo52Q7jFVajtKw91KhXIs/TU6XwUcjkmcbhd0Zq3vpfvZkqxVJf0GKA9X7MMzcMUzNcSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517251; c=relaxed/simple;
	bh=lZYnzgAV5rx778pfz79UIcdx//13/9FmDoyFZzDnVhk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nX+1paEzvs0o+2GWqhJHYiJkxWHiU00KmH9MOt6f7b/W7TtUxXPQD2qcLqQcdOy4A2pI8OOEl8Ntn5/CIzr5wR2YYMCwUqHRQP63ZKsNexYtmjz6znNYXrMzVIw8Utg64QHW5tTQvI+bbNiFkSnSyfPmoAj+z/JE2yPX8l/KY2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XUqWp6W/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-296f8ff53b9so1004860a91.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517249; x=1708122049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzfdPcYYQcVv15Q1COLpo+SFtGTau77kfvfYtZRIgv0=;
        b=XUqWp6W/UX3tSKk0yIxfbclCZK38qUBhW8Dd7TYKBUVVg2QXQkhNwwItjG12RS4/wV
         2OrNdhXb/V5rsy2TbuQirm/EbVDP6BWmcsPJxoZbmx7GPzrLJHyQwhauCnf4ZWs2LSBB
         TdDbmiQlUGevAJWQEQkb6pCBBB/XNLa274JszV+QT8X227EVZ1Hl4NoVCJT3L/TwPryF
         y8XFMmPqG2GiR6+pcpep9SMfabbDn01KLk+XpXfwSKgiHicmbb/y7jUB2hRLSib2YaX4
         P2oYzLcJkjvu34nalcWDGtfknckGOmA4r5i+qw2MVavHBXlLsLhKG6t9JOGVadSljkiZ
         3ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517249; x=1708122049;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AzfdPcYYQcVv15Q1COLpo+SFtGTau77kfvfYtZRIgv0=;
        b=X+qvz71pK1kLA+N08MX3cfZ7NOIdWyhfkTBtsbiMj4+cJc5FUkG9lVzXybi6eHf4Rt
         urNVbvvgJjXRmXCY1m4RZeWa/6Ld2TWZn3RV6/NmeI7wfwronEYpw55QVUWgQbe97b/p
         rSKa+H+Nr45GCFxR9Gy4iEZNS8o7uP765mbmQ2vOu28/fWEqIkf/vFkR6/GU5OMoiUBp
         29daQ+1X7YIhHqxcXl2D+A8ChIXVwC6oy1NPVmQ3oFF94qjdj1/GhuOII6/RBWtFpVtN
         BUpixo2WTMHCME3lR0ONH42O0bc8B5afmftPyNodU9xYP3/ey1iWEn/fxUhFV8awHOTC
         3E5A==
X-Gm-Message-State: AOJu0YwlxkrzXF91aJepfJgFIsp0DX8ElX45E6M87/7Iddd7rhq10KgB
	FXWKDZ7LxkQzsSPNsfxP/lAyykVOuqr7sEmli8HCpEYBpTEj2puDwHVx2E5Kv3V9JzvxU4rtM17
	UxQ==
X-Google-Smtp-Source: AGHT+IGIrypl49k+UeTHuPL7iRNAQJ9FUAu3GCrP5bn1Q2qsJQWzW33Jfk4E5btAookSRHH6YVh3soa6az0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2d82:b0:296:c55b:273c with SMTP id
 sj2-20020a17090b2d8200b00296c55b273cmr18091pjb.2.1707517249389; Fri, 09 Feb
 2024 14:20:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:20:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222047.394389-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: kvm_has_noapic_vcpu fix/cleanup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Fix a longstanding bug where KVM fails to decrement kvm_has_noapic_vcpu
if vCPU creation ultimately fails.  This is obviously way more than just
a fix, but (a) in all likelihood no real users are affected by this, (b)
the absolutely worst case scenario is minor performance degredation, and
(c) I'm not at all convinced that kvm_has_noapic_vcpu provides any
performance benefits.

Sean Christopherson (2):
  KVM: x86: Move "KVM no-APIC vCPU" key management into local APIC code
  KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero at
    module_exit()

 arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c   | 34 ++++------------------------------
 2 files changed, 30 insertions(+), 31 deletions(-)


base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.43.0.687.g38aa6559b0-goog


