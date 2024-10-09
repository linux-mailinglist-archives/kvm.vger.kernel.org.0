Return-Path: <kvm+bounces-28302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF879974BB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C19FB296B7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183681DFD84;
	Wed,  9 Oct 2024 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XioKq7wF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC16E52F9E
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497866; cv=none; b=s8GLW5eqKYeGU2Vcn9yWo4ijZ7ABH7DJH4uOJjbEYXvmy6tWFcc33cqO6dN7zUQCUSCk6YIYl3IA0LkSfJJKS/pN+Jnp2RdThANwVZYDsUxt1XrvmtDHq7lox0BWwAw+oFCcJFfLqxzayKZaKi14CDReOmUrgbbqDAsI/SynPR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497866; c=relaxed/simple;
	bh=u4Z+d0zswEV00eEgka9l54YerDqync+/bcr9ct1nfKc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MSC+T31MO9ODN3xVGH5moFoMdeDb5x83djYIKD1K7Ad1UctlMj3MyZLS9x09pLrQJ/VA1Y1pE2DKw1Tmpiy3UtJWvDBBv3ibmdvtt3hzuE3hJb5OjgRxh8tfXVKOzF7mgo/sDA/QqOu0lE5IyFjik4i2rNaH49fRNEumoW//Y/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XioKq7wF; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e321d26b38so4575147b3.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497864; x=1729102664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGkwLmUBZmzSdwcH9I89u+YORoK/3wsOAYXPoCJPeP8=;
        b=XioKq7wFfiLIr/jh2/tQTpPCiWmmFTJLeQRDvAuHc5TN2zs+9juwOTL0igN9V/YHL5
         UEJvrSIHdpancsazc1dfdQjyv+BXdej3/NWrG06Rs5jieUbQCbwhelNOtBIySxilvdUn
         NxOdikEcOUNRzCtT7gJIet7p+ocb7ohl7v6b3z12r8/WJCTFSQvosCE1C16gvLTsCXGM
         dj6+YZM4uOvpTxJ4GsQHJIxaVFCTF3BjhIMGxYbaWm4QsbxLKIVCusCWRVX45L11L5js
         7esujG0HwlKJpD+VPPthFNTsQK6fKbNZ9HwrgGPMqcC759NcdMKs8lJpQnbHRDDGW8Jx
         qhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497864; x=1729102664;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGkwLmUBZmzSdwcH9I89u+YORoK/3wsOAYXPoCJPeP8=;
        b=bM+IofGG93tRB023NJFzpZKGEjPOVuyzzHY3HMG1WwAVxFeoGRGSLYjiKqOWcH8d1G
         PmdGwlB/CbSeSBjkNvCNSfHM6k8Sb/JQso0CWNPVs3llYVmTcfPgSf0N7KvY6VF+egat
         C9skSu20CRRML3qyyBoChI8GZLuoEjnF7deQibG5zDOdrv20MiIk59+63j2cSYHcmRJr
         WveoOLs10e8yRTPnNbaUvuqCIRCzz95Ox2d/tlcEWg/zByJcJ9WWvAQmNmavSaD0hm9c
         8vMXqxEoFk7e/9o2KWda6Ec4N7i4ZnPeB7/XGIblXkCIJ3WLIGAngswbLhhqqTJrjejH
         Epfw==
X-Gm-Message-State: AOJu0YzKlQw3bNiWzHntWQs+hzlcZ5hNeo0WE9ebi0SB3YTzzUtqbr4e
	aTDwN0jgw0re25xqkiGwu6qdK7lmfOLTdpERL+PgFWe+pFPsxz6xnmQSEmmHrF60sSn7QuaNHHb
	SlQ==
X-Google-Smtp-Source: AGHT+IHMOtTTNEE0OqphHiKJfCCNIOTEwynPKA5+5txdjDc5FPXvwTx2vapx9bhN6DM4b5Wgki1gEiMkqfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2908:b0:6e2:120b:be57 with SMTP id
 00721157ae682-6e322469a89mr140387b3.5.1728497863885; Wed, 09 Oct 2024
 11:17:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-1-seanjc@google.com>
Subject: [PATCH 0/7] KVM: x86: Clean up MSR_IA32_APICBASE_BASE code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Clean up code related to setting and getting MSR_IA32_APICBASE_BASE.

E.g. it's absurdly difficult to tease out that kvm_set_apic_base() exists
purely to avoid an extra call to kvm_recalculate_apic_map() (which may or
may not be worth the code, but whatever).

Simiarly, it's quite difficult to see that kvm_lapic_set_base() doesn't
do anything useful if the incoming MSR value is the same as the current
value.

Sean Christopherson (7):
  KVM: x86: Short-circuit all kvm_lapic_set_base() if MSR value isn't
    changing
  KVM: x86: Drop superfluous kvm_lapic_set_base() call when setting APIC
    state
  KVM: x86: Get vcpu->arch.apic_base directly and drop
    kvm_get_apic_base()
  KVM: x86: Inline kvm_get_apic_mode() in lapic.h
  KVM: x86: Move kvm_set_apic_base() implementation to lapic.c (from
    x86.c)
  KVM: x86: Rename APIC base setters to better capture their
    relationship
  KVM: x86: Make kvm_recalculate_apic_map() local to lapic.c

 arch/x86/kvm/lapic.c | 31 +++++++++++++++++++++++++++----
 arch/x86/kvm/lapic.h | 11 ++++++-----
 arch/x86/kvm/x86.c   | 42 +++++-------------------------------------
 3 files changed, 38 insertions(+), 46 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc1.288.g06298d1525-goog


