Return-Path: <kvm+bounces-10200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E1286A6CE
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF2B01C231D2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A012D042;
	Wed, 28 Feb 2024 02:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B2DwrAqe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B6625561
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088139; cv=none; b=QXiR5TdyYUPmAXVv3XSnPyu+fKi2vLZEKz0L23nMsmXwv0jMJNsVJzoQoI/mi7JlblLUmcHZ9qvaxWScbZDVBWMSwh7vaDTtNUilCKcm+zSlSCSjG/qR9AZ08KQxsIy4v6Gey6XoEuOsCAXw0uz5phwBo/S5F2LtwipUy6RuT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088139; c=relaxed/simple;
	bh=JLsN4xg251qE9a3MZGdWpvkmGCZsQVcBJtHNmsnHqx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+8up5P0Cwk7Z13SaB82BFsiLSw1intS5mt9FsVk4eQIzkUg2G37rXYQ+AWa9nCjgDxwrYEnkvvLZ7oG3rkMiNfVs4Zns+dvS7GkqYe4OpbRyd1mPHq042OwS6lipGVijYyvIeTgprhaJaIQ3aVgAxN5gz0s5XZWegdnRKYMcig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B2DwrAqe; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dc4ffda13fso425158a12.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088137; x=1709692937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=za8QaygzoKIY5MyMe/Z2Ubm1oLIN1MbBZtglXwIHigs=;
        b=B2DwrAqeZ3hxUE5PrHwB//zObnj3gOVUrBHZ7xlBCCpYJwsaZsujU1Wd6wRYLYKFVQ
         ciPVYnK1SHSFjRSfWcz7DzJ+KuBdcNZaVAp6YQxNlQrmZ9ozftnUOEf9bEVq6FwNyGZT
         uUcqGZbU2HNYM7KrHo3KmJ3Inmi3YIJoXDEDlrG5x1iddFnp9C48nEQ/1+7Hl1TrilfH
         1qri28/ll7THvl6UBOzAy/IWkLi/YqZIdINLf52ijL2HEPWA9UL9M785vvTRjSWr1j7t
         FZnkQP1xBcX2LzHqHTFuGrsctfXMggNxh6HQiut930hQsKBmCOHK/+EpKSutmNoTP26H
         Gtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088137; x=1709692937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=za8QaygzoKIY5MyMe/Z2Ubm1oLIN1MbBZtglXwIHigs=;
        b=hB0GQz1WAKSJYOXBESGDkPe5hlkH/EczJYPUZI2nc2PhotDADpekXO3dotTKC0Byt7
         Fg5fjhQaLKpv2NZ8toHbca1MJaNlxOjf8816SNP8PcF0dm9qX90Pmy94MBd8tvvIGs5V
         4JsklSkvqypb8lXF+Y7wNva+RuENNx2Oj2WqsNpzNNmNLN5T+C7awwFlJneno1ObhOkx
         slGUHA/aSvh3KcI760+zgaQ/Km04m6mAY+/wUodpQXLHPEqMZMXYQsBismaiC/PoTeTi
         RTZpw3b/DKUmdw9RmfZY0gPHakTXGEgVOhjQ8Xki1D4nv5Mca1pZ2I0wO4a/TzkDECc8
         3TVg==
X-Gm-Message-State: AOJu0YywI1sWalfDsnIYuYhezrECxc0W8d9FEyndiy4/DbcZKTL+bXo5
	Vdoc+jfDDyPzLTQ1dlwdf3Qd3/TU0oh1d8M6i6up7/7PSiFk7UPzQok5AaMlVM+WWnLN4BVyKso
	k2w==
X-Google-Smtp-Source: AGHT+IEmZWdUDpfZFtSaGW+CNF5X12KqObi0fTpi5HyUpexKv6qJR0Hv72mZ7zAGZ81rRBqkZor7Gh8nLJE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa83:b0:1db:a739:d17b with SMTP id
 lc3-20020a170902fa8300b001dba739d17bmr2743plb.1.1709088136837; Tue, 27 Feb
 2024 18:42:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:45 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-15-seanjc@google.com>
Subject: [PATCH 14/16] KVM: x86/mmu: Set kvm_page_fault.hva to KVM_HVA_ERR_BAD
 for "no slot" faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly set fault->hva to KVM_HVA_ERR_BAD when handling a "no slot"
fault to ensure that KVM doesn't use a bogus virtual address, e.g. if
there *was* a slot but it's unusable (APIC access page), or if there
really was no slot, in which case fault->hva will be '0' (which is a
legal address for x86).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4dee0999a66e..43f24a74571a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3325,6 +3325,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	fault->slot = NULL;
 	fault->pfn = KVM_PFN_NOSLOT;
 	fault->map_writable = false;
+	fault->hva = KVM_HVA_ERR_BAD;
 
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
-- 
2.44.0.278.ge034bb2e1d-goog


