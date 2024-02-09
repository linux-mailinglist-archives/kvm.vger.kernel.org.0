Return-Path: <kvm+bounces-8496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D731B84FFB1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DF221F2168D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C13439863;
	Fri,  9 Feb 2024 22:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kzb/vOQV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B823AC14
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517025; cv=none; b=o3h+tMlJR14Cs8TILA2TmLi2XqomEe3WfkwZKf6jr/GnoaycnDtMYIr0Rhk8el0HEGIOKE9PP21mL4NzsTx5S/XoszdQNwI0QfiJRubjsnlKjIaAgNzTgvP8Wmha/wyxcOp0IVI9CMsKU4Djn+RfUJHE7QxEvZMbqqkl7yW4NmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517025; c=relaxed/simple;
	bh=9JikdSipvdk4CPkQDRKibPhnWzuH+2gXV7H2wPj8RH0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PvDLzHXiZw/sNY2Yrd+d9UJ8HU8r0scnmpoFYAwSzIMTxHXitF6Xlk3WfQ/F+IMygQHkuYTDVsE7qnj0+0hBb5Bh8x7P5Zr2qtTJvryUhcvrBOICr5UB+u/zB9rRLG/TGBZ/3UD0N56xFSXY7q2u9kwRUZLPrHGxm9Gm1i9pBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kzb/vOQV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-603cbb4f06dso29130437b3.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517022; x=1708121822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzYnSOsBsYlPOE5QaqJSJoUlPUKgrEZB23Y9jp7yz4E=;
        b=Kzb/vOQVGXFxluQMdzApSmKU5C8iNVCugLYOVQ0mSgFiVT4NQa+Wf8xBORmt6wTERy
         gi/LVyr7tgEzZJK7CbBEY8Uj8Qg0jK+AIglt5zwYwrgvajkfrSRfrbxrNRMJqL9g4PeV
         pz/axuu/Hfa8gQ9K9gwwU9rT6BxOGeVW82DLfUKNnX6TgcjAjOqMei5gX+FzyqKGiQiZ
         bsnL3b05G/OMziKHcS6629Dm3OUy2vPRrUoDyqG9AnWOQSif0CR/dZdRdJiduje9zNai
         8Ww/HSDGoFIaZfB5OzQ2udhQ0H1hVSZCxHjhmLfm77AJn4SSa73B2GVizJ6iooj3WtH2
         owMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517022; x=1708121822;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fzYnSOsBsYlPOE5QaqJSJoUlPUKgrEZB23Y9jp7yz4E=;
        b=rnBWsCXh2c/E39JhUjdwcPeAglhkanjLONEcRR+rlKb2KcOx4VfyTKC0jWylqupKO5
         OStibXTqIaSerilLH6x8ExqaurOOGMmT3DHRXjz99Qn+Js9ysk2kA3Dei793uvFCidxl
         2qOlOpGGgmLHt3WAzW0LtJiyi29PzgbMeEG7bv2anRjHJoV4PS0pFhj3VzwMmcJ7NyMr
         X2MFtJ/Bmc73mX9KPorFfYKJoWw7f2CZWGVW28gbg57yskYqVo4MjlH+RNQEaciNHhAz
         n8i4HdJnpH3TcH0tZxitbt4A0odA8BR121i6QjWMLEvLGyOhqvokFLOnDE1wy1nqY7Hk
         rEXQ==
X-Gm-Message-State: AOJu0YypubSf64+MkWME2xxSsLBbjS6eLgMVRnBr/BihhRqaxyI9kB9l
	j2SasI+LT7sNkjF9IptsX5CRh4cB8qq9ZH9nZzLf+jGx1/IsppUlOd4/dAByAUtQjE7MkoiQcXl
	9Ug==
X-Google-Smtp-Source: AGHT+IHExzOLXjqk5W09HFGU0N3HogH1FlA2vbZl2LsJoAYfDp5YoIc4PNXhQ+D89mwjLt0oMsjj7Ak3igY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100b:b0:dc6:fa35:b42 with SMTP id
 w11-20020a056902100b00b00dc6fa350b42mr111020ybt.2.1707517022804; Fri, 09 Feb
 2024 14:17:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:16:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209221700.393189-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: nVMX: nEPT injection fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a minor bug where KVM doesn't clear EXIT_QUALIFICATION when injecting
an EPT Misconfig into L1, and then move exit_qualification out of
kvm_vcpu_arch to avoid recurrences of the bug fixed by commit d7f0a00e438d
("KVM: VMX: Report up-to-date exit qualification to userspace").

Sean Christopherson (3):
  KVM: nVMX: Clear EXIT_QUALIFICATION when injecting an EPT Misconfig
  KVM: x86: Move nEPT exit_qualification field from kvm_vcpu_arch to
    x86_exception
  KVM: nVMX: Add a sanity check that nested PML Full stems from EPT
    Violations

 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/kvm_emulate.h      |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 +++++++-------
 arch/x86/kvm/vmx/nested.c       | 30 ++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          |  2 --
 5 files changed, 34 insertions(+), 16 deletions(-)


base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.43.0.687.g38aa6559b0-goog


