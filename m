Return-Path: <kvm+bounces-5965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B9982920D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A99871F26B8E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E79033E8;
	Wed, 10 Jan 2024 01:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xzu5YXqt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3302595
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-28b77ca8807so1975856a91.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704850028; x=1705454828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6w363icKNKqhEvrbPXdZyhOPYeC1XcMC/VyRfjkT0w=;
        b=Xzu5YXqt4hwzHeuanO6gNOdRAtU407RXVA/KCoapNa45RRXH2lFTuyLnc+q2mUYblh
         Vyj1dE5go+/m9I7I6LuX1qtkQ5i/VlujjEvZjsz4hKqo5garLoX1rHlGZHVVLKkgGH4Q
         8n6DUC36xw3u7j+EiLtSfRJkA9raOF4XYdtSHVdciWxAlLVP9R+YLtsrKw7RvHM3HIJO
         GYSMx242P2kSeaYnVTv6Gogo+mTko6T+NiejsD32qWcWj9AzYUgDmTbs4Q2UxBOigmka
         9b5Bdp2T0QD3/dtLSHObZ55W9Uptn0oqutoWq8317W22FXhEyH803vGOS9gW8V9vZ050
         M/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850028; x=1705454828;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6w363icKNKqhEvrbPXdZyhOPYeC1XcMC/VyRfjkT0w=;
        b=m26wgkug/d02bi119a84r3KZD0Tto4rZJBF7wnRiKM7qxi/FnehicOQXOz2jsx1Glq
         uiQrAxfa7NnlEJUk5ch47fob2jhyTB3wT7meD76bKVYp8b1NgbBwUH220gSWwi7o72yz
         MFZq4bVn8OpPArPH6hxNvS1iiNhjQTCcmX8PVj/dkuTb9xQrM4DTZPGaiAxoky2SlFf+
         vboUEL4MzX2ZyMiChCM9YFleIcP2fvWRmzBymS3E5p9mXm83hH3CAL6+0U7WX8kSrDab
         S3QgL+7VZA0cjBU7WpnouMp/gtKJF27NUdIvgOtyFrbcn1q7unmhpjbuMbOUonpjMYtT
         kMIA==
X-Gm-Message-State: AOJu0Yz+J+oDFjkM5adUZe3vSeAQTt7ESvSX+uh4g8NC8zqLmb5rqP5h
	nxV8fm/XQom2fLCzTofhCeUW2IEbzimJhDuI7g==
X-Google-Smtp-Source: AGHT+IF+qgk30gHAynG24GncMt3bTSJdUq4PWyW2JAr7K680Sczv/++SAJGg7cxWbcYbgQizNvvkAw12PLg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:245:b0:1d4:ca30:874d with SMTP id
 j5-20020a170903024500b001d4ca30874dmr1365plh.9.1704850027825; Tue, 09 Jan
 2024 17:27:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:26:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012705.506918-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: x86: Clean up "force immediate exit" code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Plumb "force_immediate_exit" into the kvm_entry() tracepoint, as
suggested by Maxim, and then follow that up with cleanups that are made
possible by having force_immediate_exit made available to .vcpu_run(),
e.g. VMX can use the on-stack param instead of what is effectively a
temporary field in vcpu_vmx.

Sean Christopherson (6):
  KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
  KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer
    exits
  KVM: VMX: Handle forced exit due to preemption timer in fastpath
  KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
  KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
  KVM: x86: Fully defer to vendor code to decide how to force immediate
    exit

 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  6 +--
 arch/x86/kvm/svm/svm.c             | 18 ++++---
 arch/x86/kvm/trace.h               |  9 ++--
 arch/x86/kvm/vmx/vmx.c             | 80 +++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h             |  2 -
 arch/x86/kvm/x86.c                 | 12 +----
 7 files changed, 72 insertions(+), 56 deletions(-)


base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


