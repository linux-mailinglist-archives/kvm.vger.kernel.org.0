Return-Path: <kvm+bounces-42366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD0CA7805C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A9413A51E3
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E32021CA04;
	Tue,  1 Apr 2025 16:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LtjzqS6b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C297BBA42
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524289; cv=none; b=qTr8HKdjYxqlDZQh8MyVKbX2zXCQGzt6QYit/DFkkdYwPf6Y3uumNni02QxYtUN2Uzk1VW0z0/U+QOwYTs9laH5oUULzvQl8NSwTNSCQDWyO6zQl7jNsHs5wqAsxbgjDT+ihbyFnpq9OAOUVxIZp+S9dGRp5J2kUTE+cZtKk/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524289; c=relaxed/simple;
	bh=hXiSfRIVnp1UtOUy68VQPv8Grqb6r0Y/djWDcu8Iitk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dsX8ExGGgFW7wT7bxRGpwv+5zdjjph7NSfY9WlanLSCNeeVfRRa3jcAhoZT9tKq5Y+kGblVnzPpU3w2lw8ieHCStItoxlBNxh6/wjgAU9mBqZFoMKbs34nYCzT8xLMq5TS5HtainD064KEUuO5qFZqq5/KNlXZoM63JlV4bBFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LtjzqS6b; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22410053005so7095115ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743524286; x=1744129086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19naIH9ug+/5n2RgKxWoWgHuCCiFZRtWAHL+JgKgjpg=;
        b=LtjzqS6bXsNpdQdWRC3nH5VvgLcaN4Stgm3Uw5GMkaeW48jDGoN2dqMC44JJdQ6SX2
         mnB7GeouBTz1DHgA7EkGRTIlgcySxNU+8t7F7X2R2ZTgVZ2Yn8JkjE5LVswGmvzzBoPo
         aIAGXh7pa/cSGHTKb7u2N94+aUUW8MhgDR84hxA4fyILFq1oJw6i1mqc8892lp4eLng4
         kgYbMUvxaeohovfI/+gnlYi9CfkjObCXocazTSjttFUyEGt3pyPol+3zlj/375xKjAai
         cq7vXLGyqeBrCivBzZgAVDZg6CyukzQ//ddDae+/1k0DrDcX439130hZVnB/9FWpnlzS
         kzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743524286; x=1744129086;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=19naIH9ug+/5n2RgKxWoWgHuCCiFZRtWAHL+JgKgjpg=;
        b=phljKIBFX0relkFqcgMhFyiHknqxy/l9e+0voEELbcXJHXtvFp90ViWeN6Srk1CX1R
         t6/+UaPhBi3M1fN4P5yuRi4ZL9od7UCD5ynY73grTG6LwKOQE/e8apOyZ9Gqro4hF21O
         yWDzyA+33kB09h/MLEJrpvDniS8pXeLRcrGqHX2+PUUhjmQXplT3LNW46Jh8mfAbKL6h
         obk8/kYeJIqThxKyIOLt0qc37bgDgmO57f1ykrTf+3EZxFrz8CmwAMblw7kfKSZZP7iB
         y7H6xPKsskV4RQvfV2lN2R4UQ4kwOoiwKLuryGYSehM6n7zdLCJo2rhmlRK7lea/3lMd
         EyxA==
X-Gm-Message-State: AOJu0Yz6zCT4S/bIpzr9IX3ZqcnWyG4nQCagiQDBng2u3bN6khLLe4dr
	g7IBv/4hJejnaIyPkyuyugQMFFV1Elaf50Z+0DjG4dbCsHvjjeUsRpB+yZ84UiiCZ0eDPvgd9wI
	qpg==
X-Google-Smtp-Source: AGHT+IH0/xa6d9xPOKkCBD1Yeu+PE6hNBcgyDq3oVyckCsne8CfiJBk02Muz1N6KD7o9AzA0IRG6b4ZAGcY=
X-Received: from pfbki6.prod.google.com ([2002:a05:6a00:9486:b0:736:38eb:5860])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88d0:0:b0:731:737c:3224
 with SMTP id d2e1a72fcca58-739803b3f12mr19203881b3a.10.1743524286111; Tue, 01
 Apr 2025 09:18:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:18:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401161804.842968-1-seanjc@google.com>
Subject: [PATCH v3 0/3] KVM: x86: Add a module param for device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a module param, enable_device_posted_irqs, to control and enumerate
KVM support for device posted IRQs.

v3:
 - Put the module param in vendor code to avoid issue with reloading vendor
   modules, and to match enable_apicv (and enable_ipiv in the future).
 - Fix a shortlog typo. [Jim]

v2:
 - https://lore.kernel.org/all/20250320142022.766201-1-seanjc@google.com
 - Add prep patches to use kvm_arch_has_irq_bypass() in vendor code when
   querying support IRQ bypass, a.k.a. device posted IRQs, so as not to
   unexpectedly introduce a (desired) dependency on enable_apicv. [Yosry]
 - Use "&=" when constraining enable_device_posted_irqs based on APICv
   and IOMMU posting support. [Yosry]

v1: https://lore.kernel.org/all/20250315025615.2367411-1-seanjc@google.com

Sean Christopherson (3):
  KVM: VMX: Don't send UNBLOCK when starting device assignment without
    APICv
  KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
  KVM: x86: Add module param to control and enumerate device posted IRQs

 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 3 +--
 arch/x86/kvm/svm/svm.c          | 2 ++
 arch/x86/kvm/vmx/posted_intr.c  | 7 +++----
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 9 ++++++++-
 6 files changed, 17 insertions(+), 7 deletions(-)


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


