Return-Path: <kvm+bounces-48439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69436ACE46A
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06DF63A8812
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA91205AD7;
	Wed,  4 Jun 2025 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YBPXMnZr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2853203710
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062192; cv=none; b=Uy8YBEI79RTAkc5Fs7LkzAFYbjsLOwRegyayAUuJKTv1tl4fuFs0Mho/n7PMlL0OMGxe8gnfMFxAY/5H6E/4YHAR3So9QZJpsHxbMWbM0cjyFiOa5sIExroFrm/Zttf3I6coPzUa89ONGU8Om6+oeaiTJpAYg95jMb7oIUcnu1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062192; c=relaxed/simple;
	bh=XEGtCyvmquXdS5bC75ix4QdkCjWAk2zyh1M98jaQbxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T9d3aY4guYgb9khV4K0RCweMJNCe+SluZkYLqSaUNL5+4knGlcaY1j6eWmx5sXWm+kyAoxXSTRPOATlAI/cUv4EY7DG6Y0tjdsPhvrJ4fzm0L0K2fP0ojKzyA3/4OL163c8An8CQDlyxfwdm8Bmf48xuJcNfSdxJToQAOEtcyLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YBPXMnZr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af59547f55bso50544a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062190; x=1749666990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XDLE/0KvH+YekLdGRUHtCq36fTmI3p02zaN++At7L4k=;
        b=YBPXMnZrQgh+vPq10cyEwEFkyUyYDXNSyn+HEPVPjkqVXXqtVMYDPXlUXo09CF4yVM
         7iWnyclKfmb3sBODMZotAOzBCzb00JZE0c453gL3EiUm0rD6ZOd4g7dJYRw+0kTvInPE
         oji9XsnFuFJMZTdqJyd70IyzimRPRrLpxs/98SmFX0OvUSTXYPGhr/LcJn6QJHte3BZs
         l+IP5UNd5B5NyliskX7R30X1hHqyYT1gbdfnMXVAoagDdUDtMxSnXRD7tKHuRT3oIn4o
         loJTPD+LNhbdOSVq3YCpmhdElV40uDH//kSsozX68ztqyoUYzKBan4LgSv76Bxc+fOiR
         ChCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062190; x=1749666990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDLE/0KvH+YekLdGRUHtCq36fTmI3p02zaN++At7L4k=;
        b=oJU6LezeJ6FdwiTVvDFNpfGc6kEGtg8XjsP6Z/XmpsPssKgl+DxI1mE7nQWmWIXXyS
         DovM6uJ5EcLlGjKteFs2n+wTIZTvC8vunxCftiN79lN11WEYEEj4WKhnNK4tEmXvPTm3
         hrLPbEsXJQSVurRLwK98NeO4Esl/eSRbxrMgVQdw8rVbJO0q5g9JiMwq88dQGjpVB6Oh
         Q0q7M35NX3RTEqL/kltq5WrKES7x7oxIvg7zmHppMZ+shucSWnI8NOwb6HokI+KokPli
         gYWtA0yoXQb0M/r+DJ3q9w6kwKetYsodwBq3sj6eVBBHZ8O5XLCGl3GBeu3EJ7MsYZzZ
         Lp5w==
X-Gm-Message-State: AOJu0YwkG8gVoWCg7zhw9rikGbc/3DFTS3NDv7MoNGWK9xjkKdPgt3eD
	T/jlcv/FKfBmWq+4xjQzj7W3a57jM6FZ4DsBpaxtyH2QoKiUAictL5DIRzDg2DLvbuIQ7XY69o5
	IiVCiTA==
X-Google-Smtp-Source: AGHT+IGYJD8VbS9lBYrbT2lkbkodVr8jhE4437lQfSKbvLsJdvnGnxiKEpcifYBOQn7sLwG13XXZ/He7HkU=
X-Received: from pjvv11.prod.google.com ([2002:a17:90b:588b:b0:311:1a09:11ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52cd:b0:312:e8ed:758
 with SMTP id 98e67ed59e1d1-3130ccbf015mr5431414a91.13.1749062190135; Wed, 04
 Jun 2025 11:36:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:20 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/6] x86: Move call to load_idt() out of
 setup_tr_and_percpu macro
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the call to load_idt() out of setup_tr_and_percpu and into the two
"callers" of the macro.  This will allow moving the BSP's invocation of
load_idt() into setup_idt(), without creating a confusing scenario where
load_idt() is called multiple times, e.g. so that it's clear the BSP is
responsible for configuring the IDT.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index ded6f91b..0229627a 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -36,7 +36,6 @@ mb_flags = 0x0
 mb_cmdline = 16
 
 .macro setup_tr_and_percpu
-	call load_idt
 	push %esp
 	call setup_tss
 	addl $4, %esp
@@ -97,6 +96,7 @@ ap_start32:
 	mov $-per_cpu_size, %esp
 	lock xaddl %esp, smp_stacktop
 	setup_tr_and_percpu
+	call load_idt
 	call prepare_32
 	call reset_apic
 	call save_id
@@ -109,6 +109,7 @@ ap_start32:
 
 start32:
 	setup_tr_and_percpu
+	call load_idt
 	call setup_idt
 	call reset_apic
 	call save_id
-- 
2.49.0.1266.g31b7d2e469-goog


