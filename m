Return-Path: <kvm+bounces-19079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E885900B2D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3A57286BEF
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A1119ADAE;
	Fri,  7 Jun 2024 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M4Lm2DUk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07101991CC
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781174; cv=none; b=LCSKFSc5B4Ij33v7J7gdYScEEQdPWWsVVSkvxY1mi7AURiLrMS+FIb9HPmadtYNfO6shOHN+gpn6QksUhzG4cYEpbh9OpLGXwx17BmjsKBZK8ccloWQe6HuD+S5cNOMlbryI568EwAutexPaIdyoUVVTjfgTLIiQM+/K1MtbyO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781174; c=relaxed/simple;
	bh=IQzrSRvqmZvcnLkZDTRut4HhpmQm38jC6WB4XZLfods=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iZ/wKckTOpcepeoSMhlnA1O7FOyzOqgkEbvzNWhazp1ukOF6/ShbEuSjVJevQQcHQYQrF2UBYVHtCjUd8RyP68fjNZhss6x1v77v3NGz+X6LAnYengPweC5ebmDOucobVFUmZ4FhrAXlwwIn4Rd/VVEju5SjnOcG9QDj2zKtnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M4Lm2DUk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c380e03048so2097187a12.3
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 10:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717781172; x=1718385972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8D2p4JaYRkh+KONnYh36xB/hyP7cXvDvqjRzrMCIXg=;
        b=M4Lm2DUkEzDAA+CggdBRrqTMULYgGaETzI/vqPTkdOpnokp6+qC4EVR7TVr8f8+9Oo
         aDlYHSXqoFQX2zrca/280zatS2/pzkgeJqZ1fQWH4XjbO1ZA4XXTntLkCuYyCzh6+g82
         BXYzP5hWI0jKOV5UFODtOhJYfQTmcloFcuE95Jn8dVArZvKX3UNRFYn6ZjCWm72G78RM
         jVm3ICMd7WPiZNMj65SvNYiRXngmdwoiR93K8E+tM6+2mVmmdOWwzsLteLgQEZlqOdoL
         iJvjnTjgODFZQHSIK9qB1a34ROmoW6mdx/+2q2tjuh1ZJ2GeuOPYclnWSNPgYkzJhOIP
         NcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717781172; x=1718385972;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8D2p4JaYRkh+KONnYh36xB/hyP7cXvDvqjRzrMCIXg=;
        b=qStYVlD6NU34ii9cMtpODOtZLb5P6SPCbB+2+z7gU9tfxAHMYQUvm0o11uw3jpelUL
         fERWgqF5bZsW3cF/Nis0Z8ZtrN+Vh+Wb37p8BRpu+JvqaRT0/6Bd72a8Qv1jOpm9mVRk
         Gxa2KK8EF8VLmO1mAu3ZkgU5QDBppkUhZ3RuNdhIOANumLmsICUAkVqdV4IkJP+Nhc/N
         tVHwWU035QovcDvU+QbdI5UDdbswEAtUYtRq3wzUyyl/SQeN86cM/nQPP3/BL7Kd2qNQ
         Gck+1twv9DeEEW7JqGd6tIYcx9enC4BzPl1SWMEs15PvkCFMAtIKekl/1Zc6htLy/RoM
         7//A==
X-Gm-Message-State: AOJu0Ywl4nCgO3DtjAyytCf+K855GYeZ/Cyi1ZXKRNwdJVlobMktHrpn
	xhPi4uS4NecCdZ+BGw9/6B3F2IeUjAtK37AHdm/+Hjyqtm8roI7EExcJQnfwoyTEl9m4HHEP79J
	vIw==
X-Google-Smtp-Source: AGHT+IEgUAojaDL2kv87NlL1e/Et7Bt7YgZelBKFh+AmcQlFeDs+1cI+WfgV2S9gwmXGNPku7DS2HG0pwRU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6804:0:b0:655:199c:eb1b with SMTP id
 41be03b00d2f7-6e1603ae662mr6803a12.10.1717781171967; Fri, 07 Jun 2024
 10:26:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 10:26:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607172609.3205077-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: nVMX: Fix nested posted intr vs. HLT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the nested posted interrupts bug Jim reported a while back[*], where
KVM fails to detect that a pending virtual interrupt for a halted L2 is a
valid wake event.  My original analysis and the basic gits of my hack-a-
patch was correct, I just botched a few mundane details (I kept forgetting
the PIR is physically contiguous, while the ISR and IRR are not, *sigh*).

[*] https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com

Sean Christopherson (6):
  KVM: nVMX: Add a helper to get highest pending from Posted Interrupt
    vector
  KVM: nVMX: Request immediate exit iff pending nested event needs
    injection
  KVM: VMX: Split out the non-virtualization part of
    vmx_interrupt_blocked()
  KVM: nVMX: Check for pending posted interrupts when looking for nested
    events
  KVM: nVMX: Fold requested virtual interrupt check into
    has_nested_events()
  KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject

 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  3 +-
 arch/x86/kvm/vmx/main.c            |  1 -
 arch/x86/kvm/vmx/nested.c          | 47 ++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/posted_intr.h     | 10 +++++++
 arch/x86/kvm/vmx/vmx.c             | 33 ++++++---------------
 arch/x86/kvm/vmx/vmx.h             |  1 +
 arch/x86/kvm/vmx/x86_ops.h         |  1 -
 arch/x86/kvm/x86.c                 | 19 +++++-------
 9 files changed, 70 insertions(+), 46 deletions(-)


base-commit: af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a
-- 
2.45.2.505.gda0bf45e8d-goog


