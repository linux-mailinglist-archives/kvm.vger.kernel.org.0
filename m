Return-Path: <kvm+bounces-21518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BEA92FD4C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BEE01C23011
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387ED1741DE;
	Fri, 12 Jul 2024 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2HV4JFHS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA20A1741C2
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797220; cv=none; b=iNrz4DCkw+tJkjzpFWBhoVmwhKcHGVMyU/NQqn3KtQjIouMMB/I1TODEUhPrctvuPc70KVasTdVNUJqi55qQQUHpO6lT6aOg++QkhLpTDRarQWMUHhmPuIAr3pmcj1MG0PNF2rj/RJZ/O6XZ85BftjFNZFKi5FNBulzqcYiHYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797220; c=relaxed/simple;
	bh=fHx8roCBigOuv5dL+stx4nu0lHPpoaj2yAnLzpWevyk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gX0AB/+EoRA7HSjKot3Xj1uieFzdPZZSmELGBDsL5oACW6Nxsrv11iW2t/VCreZombk2wB64DmJNJ+qIRR6C+hLBzQuqup05w30uNwA+dPAQdTuMlCeItVG95MuJNMexK3HYqmqf/tUW3xoZngiHcnAmBKxTBmz59lLPKt95L10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2HV4JFHS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e036150efc6so3781109276.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720797218; x=1721402018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMBbMkJX7zmz4UDXazHpxT2FCAKHZXQ8TyK0Rbrgj28=;
        b=2HV4JFHSmXnWx8mAIJDjoIYa/DoksToXVwAJKVVY8fzZqXGUpvJ/Dmj6AoBo71WSSY
         Yy8kV3ruB7z4LjgxmlYfYCiFGM7C9B/UukJCZZA6UMebXCbeC/M2cfrQe4kwbScy9ZHy
         Czbj43zzPRlsMLS/kY+o+2MU2kXFpyCsLQ5Sn1cBj9HKsm5VcseM0APmjJ1IDnEP2C0N
         B8GHS2F0LShSgoy86JlqBKqb94JysKJpFhM9Uha6fxd4hxTa6cvU7+r1876V2tYqMEpE
         dHBAsUyFf7fTgxmslJerLDSbPnpsKE0/kX7usXP/BYfPDmgPc7v+CK8x3mK76ui4bYw3
         llcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720797218; x=1721402018;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pMBbMkJX7zmz4UDXazHpxT2FCAKHZXQ8TyK0Rbrgj28=;
        b=qRCiD5cz5jq8pP1Ko/C0sdZFf3Q4XMmM42gjW1qEhJ97YSGu3ydyWkgeHozdrVsIKI
         NueSF1lsczyColBjI9xsCkX5KGHzM97Q7cBN1mUcSkdN5OMXCkd3dn2gssTonWJeyG4b
         QKHh4Rcwn1me4tBHEsImFG0aHK4+HH2baT8UcoOW1cNs2yHy1cNoII13ytQSSlXrTfRI
         IrltXOGtNhF55kBQNbniQCrWtNt1T75/HJofFyIH16rNlLg5EeOv6AChIHtmcvSeimKg
         7TL5Pynq/sQQIzFLHuD8drQ6pUk8WAHa1Ih+Y98l7KfYj1eODesRgIFgcIrNz4IynTmX
         qv+w==
X-Gm-Message-State: AOJu0YxwsNXx60Tvi6gB+7gBomXaRNgmpMobT4AD2IjsO8Du4adD7FpH
	sgeojEO2QVuZHtOgNFcaIcosKwCD1z8OzqCBQ6CzBTmw1iwOYNKWP1kC6xyyIyByAVVVghi9idA
	7nA==
X-Google-Smtp-Source: AGHT+IH0rczfJl9S7uUejXGuj2VCmgs/pCiBU7IUiJYL350tuI8YPdO5kWLf5JJJSkCI5YzF+/Av5eqK09k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:de4:654f:9ad0 with SMTP id
 3f1490d57ef6-e041b058ccbmr24885276.6.1720797218047; Fri, 12 Jul 2024 08:13:38
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 08:13:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712151335.1242633-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86/mmu: Clean up hugepage split error handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

"Fix" an impossible scenario where KVM would install a '0' SPTE instead of
using SHADOW_NONPRESENT_VALUE.  In quotes because (a) there's not truly anything
to fix (the code should never be hit), and (b) bugging the VM doesn't guarantee
KVM won't get confused (though it's still better than installing an empty SPTE).

The main motivation for this is to eliminate installing a '0' SPTE so that
future audits of the MMU don't complain about not using SHADOW_NONPRESENT_VALUE.

Sean Christopherson (2):
  KVM: x86/mmu: Bug the VM if KVM tries to split a !hugepage SPTE
  KVM: x86/mmu: Clean up make_huge_page_split_spte() definition and
    intro

 arch/x86/kvm/mmu/spte.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)


base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.45.2.993.g49e7a77208-goog


