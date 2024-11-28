Return-Path: <kvm+bounces-32623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7179F9DB024
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 012F4B218EF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434CE1494A5;
	Thu, 28 Nov 2024 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uyhCEObj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2FC179A7
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732752019; cv=none; b=ucjUAkSEev+l3clm3X4AaKF3jkTJMf6j2b89/hNUE7jP+aQmMqNATXTG0aGFzS+mB9C7SqLZN8M0Ob5Qk/qlMVj+4NbLFbA35UuuyP22d6MOnBRPo3hHNnObtfganCUG66bfMu8CRhCNu1CwJ/VCEAA8eWop2/q2nKcV1/5fDzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732752019; c=relaxed/simple;
	bh=JeeQkhVLwazNPCRejNXGNMdl03WAOaQXDbfEy3i796M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZQiWF8qGrurl0Up522BVKB53JNiAlxyiGb4PTRkwhd1spAlSKmXcqvUFWvjiG7zRYyVlXukpowtxp8hpDn6TzzTAnFWHsAbuiU6/cV642hNHqhq4VoldmOmkpEqr8yHXPzvh6EjHacoihZZux+OBao5nDj0Mppvp5uVuk8k7zws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uyhCEObj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7251698c10aso283654b3a.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732752017; x=1733356817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1rHARWFvprU48rair2lVrKITld+pfqBEh2Nx1sP9VU=;
        b=uyhCEObjKvf0iIvvS9IgJOMhrT9mSZAD/T5mxokRwWQRWkLdy3UnxmVPQZafRpC9iS
         fywBYUWTJRdI0SBReiu99rLIZaAnN95nP5LNPR1k80qFkmn4pqAIynGFQ/EOvy9W5GO0
         cB96pUx0trwVBOcinvczagMVapr+hyhe4rmlFpa/wUKtjtE9v/RE66f/zSi6Of+rv8k8
         ErmlEKIG90Fj6tRhIIy933+pfvyfJlj6FG34sT0M5wSvFNJDA0utgmHCiHa1Tws6rdjy
         nyRTMPUUwUYtJUqICvRzAXCXjHmtQMr2wd9BYXqNOF45ZgYQMY7Mh5zsDQvk4lvnUPbM
         CjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732752017; x=1733356817;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D1rHARWFvprU48rair2lVrKITld+pfqBEh2Nx1sP9VU=;
        b=jglX2uHp9Tctl+YFDDrQ/SRV5DLleW+ZkNPvO+6cLFlGOStW9o2t+FB75+eM0P+tR4
         Qe48NTSR18Wlknb52+7IIjBHNZDJlX+eGF0cdcm32JHRLyH91oJBqXWJR9uM8tDCgk9D
         OSYmRHc7XgVE59Yq2LDkZe+W4xkB+x+wBX5oM3MOtit3FGzf66BNC/kYvyOx/br0Z80w
         IzYgSpWp/8rw9xZWju6xT2Q5VP1ElvhQ+g9L8WaOFRMcwUo9TGPryexUw6YKhJm9hMb8
         sIhsKG1es9T1R2OrKeIsJeN1znslT7TinmVkDgIixN0+20V20CDbO9lqLaIcC3IagBNf
         CpJQ==
X-Gm-Message-State: AOJu0YxNZO1bvL8HeGJ+KxpMJ+geaYdXCeVqUHLYG42lE5Ecefk4sqQw
	PbX19wk9hrsMRbLv6y1Ip8i5vdI1vs5BnWDLSLxTQswvHV2olFv8ZAQNfv/Iul634L4BZhjH5dU
	bzw==
X-Google-Smtp-Source: AGHT+IF3oxNpWWC0IELw0de5Uwrohdy5JIdxef496SC7Ot/M8YjazPh5NNQ41Km9tyZt+1V3W1kI3JbKWz4=
X-Received: from pjbpt17.prod.google.com ([2002:a17:90b:3d11:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1850:b0:2ea:3ab5:cb9d
 with SMTP id 98e67ed59e1d1-2ee08e9928amr6628539a91.8.1732752017446; Wed, 27
 Nov 2024 16:00:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:00:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128000010.4051275-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: nVMX: Fix an SVI update bug with passthrough APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, 
	"=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Defer updating SVI (i.e. the VMCS's highest ISR cache) when L2 is active,
but L1 has not enabled virtual interrupt delivery for L2, as an EOI that
is emulated _by KVM_ in such a case acts on L1's ISR, i.e. vmcs01 needs to
reflect the updated ISR when L1 is next run.

Note, L1's ISR is also effectively L2's ISR in such a setup, but because
virtual interrupt deliver is disable for L2, there's no need to update
SVI in vmcs02, because it will never be used.

v2:
 - WARN only if the vCPU is running to avoid false positives due to userspace
   stuffing APIC state while L2 is active. [Chao]
 - Grab Chao's Tested-by.

v1: https://lore.kernel.org/all/20241101192114.1810198-1-seanjc@google.com
Chao Gao (1):
  KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Sean Christopherson (1):
  KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            | 22 ++++++++++++++++------
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/vmx/nested.c       |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 23 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  1 +
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 47 insertions(+), 9 deletions(-)


base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


