Return-Path: <kvm+bounces-53480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B442B12670
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95B911CC46C6
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DA2258CEF;
	Fri, 25 Jul 2025 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pasl8bR3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B8F24502D
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481240; cv=none; b=pwi6xN3DbIOhxyP4btKI5OfwbHoVJd5FXLoBR21Tjf+fnzlvjsYU3iM4nMa7Bk+SrdrhRv5vc+0yN8YjHsBREroQojbsvJaw9UQIHFIdQ6DYM1kdhEcZmg5/ehpEjYEGqZkG6UAehNjenAM+xEwF8oc1LomuvLAKCFxMHc1mUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481240; c=relaxed/simple;
	bh=CIVA//TUtzDFemvEOPKSaKvCc3OEEmDqo6W/4z+XV3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tkYtQQR6JG5WIjS/LsRdW2zgg+El7KvKHsqUeGbCGdrmWXoMGgPVADPDNmh+mFBS7XeJAYZvFVv6KqGrLd9P/+t5rKxj3jOhtfgD2bgKBd7FS3vOwQBE26/KTzc6fnqDAril3GLVRZXJdjCWN/ZEFNGXkX/7rBRu++F4ELXgPOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pasl8bR3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so2189255a91.1
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481238; x=1754086038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vL7uDkurI7i513aYfoZivXtgn6NN7Y6FiVe/AkXnYFs=;
        b=Pasl8bR3dxrE7Glm9dNdMELJ7+oZJ/QYcIcN358LhLbc3WlsFBpsWSN0+XKQfKDymP
         GY3A2IMMgUQDENjppdU/fZbc/dtPR/2CmlCOeuyC/BAgVFcmQQizFoSjKHsAgfXkY+nb
         /QdYJ56x6EHgngsL7C8Mqq+01VIjZCXkPIa0vlMZvOk64G4pi6lQx/pvDmfvJBO9COJu
         Asr5RXx1nMizMNAqwivCkUYteHQE64k5NDNBiUkK19xFyqd2/8UyIjR2WfJ42xLSOf/Q
         urikyrZCGj785idSm7tGAxMSqk9RXBDj/KVDH34w3DqSopjNeVQBawFjEd2bH9NcnL2h
         yZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481238; x=1754086038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vL7uDkurI7i513aYfoZivXtgn6NN7Y6FiVe/AkXnYFs=;
        b=oM1P+tGKGkdxQa0VRk1CDIBTpLZe22Js2GT3hY1BOnFgbaHEbkaiQikxbKf4Vcg/2P
         L/BMHsQsuMqxY2i08hS4cxR3GggkqSLd0cZrxrxtCAAUmglt69prDh/ATwZ0xP1dttJv
         31TYBjqeTPcehsQrLiRTnB94yzU7aRKgZXY45Hxdj5scxqHwQooqIPC1q+Ch0ufuBAT+
         VveEAVr/P/pgno6vPLGwtHIkICECopmKWbebV2lIa6kWmNzfWKshlW3tVqFXEBZoRZhR
         nzIn68PVJklkignaWSPTmHRcaUFgvtaHkjujWGxB7UviThs3WELIXA7ZBuCCODDas1Ht
         Vk1w==
X-Gm-Message-State: AOJu0YzprKD/SkFZPGawX0oUjILZb8dlgSpcr6tcBkiMc0qxItZzTsun
	OIIRVwVYIrV1XWVDNuISbN+oFzma9IimHb3syJg/JUqoF9APE9fu+dlDc7Dfref/Wbgl5QStxpE
	2wZN4VA==
X-Google-Smtp-Source: AGHT+IHqHoe6XaszA/quyagfVOzJkc3hLbUC+04kPWvXXW3uI0Tu6Pj2EChYFXb+FTAt2QU0nwJoRESQiZ0=
X-Received: from pjbns7.prod.google.com ([2002:a17:90b:2507:b0:31e:784b:5cb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35cb:b0:313:283e:e881
 with SMTP id 98e67ed59e1d1-31e7785efe2mr5918582a91.11.1753481238372; Fri, 25
 Jul 2025 15:07:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:01 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Local APIC refactoring for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Move most of KVM's local APIC helpers to common x86 (with new names that are
better suited for global symbols) so that they can be shared by Secure AVIC
(guest side) support[*].  The actual Secure AVIC support is likely destined
for 6.18 or later, and will go through the tip tree (shouldn't have to touch
anything KVM related).

[*] https://lore.kernel.org/all/20250709033242.267892-1-Neeraj.Upadhyay@amd.com

The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.17

for you to fetch changes up to b95a9d313642c9f3abebb77a04b41bb7bdd0feef:

  x86/apic: Rename 'reg_off' to 'reg' (2025-07-10 09:44:44 -0700)

----------------------------------------------------------------
KVM local APIC changes for 6.17

Extract many of KVM's helpers for accessing architectural local APIC state
to common x86 so that they can be shared by guest-side code for Secure AVIC.

----------------------------------------------------------------
Neeraj Upadhyay (13):
      KVM: x86: Open code setting/clearing of bits in the ISR
      KVM: x86: Remove redundant parentheses around 'bitmap'
      KVM: x86: Rename VEC_POS/REG_POS macro usages
      KVM: x86: Change lapic regs base address to void pointer
      KVM: x86: Rename find_highest_vector()
      KVM: x86: Rename lapic get/set_reg() helpers
      KVM: x86: Rename lapic get/set_reg64() helpers
      KVM: x86: Rename lapic set/clear vector helpers
      x86/apic: KVM: Move apic_find_highest_vector() to a common header
      x86/apic: KVM: Move lapic get/set helpers to common code
      x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
      x86/apic: KVM: Move apic_test)vector() to common code
      x86/apic: Rename 'reg_off' to 'reg'

Sean Christopherson (1):
      x86/apic: KVM: Deduplicate APIC vector => register+bit math

 arch/x86/include/asm/apic.h | 66 +++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.c        | 97 ++++++++++++---------------------------------
 arch/x86/kvm/lapic.h        | 24 ++---------
 3 files changed, 94 insertions(+), 93 deletions(-)

