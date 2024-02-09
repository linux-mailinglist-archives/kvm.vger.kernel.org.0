Return-Path: <kvm+bounces-8502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E4884FFCA
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 465F11C227BE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731273A28B;
	Fri,  9 Feb 2024 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D+pL60lA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1119439FE6
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517255; cv=none; b=s1jUbsZD8P/wEbf8aH0Zk5R7Ay0HN+bk1SGNnfrThFqvLZTN4Pdj/NldU2NQWakmKusj8/eNy0Yex/Q+ip+TKOZVdtfupyW/uFl/HM+2dMbbB7ai/HHRpKZKL1xPkc2CuCt/oM5CyZlFGFUqxoF5j5sv0bdZOTzSymsf7yY8scU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517255; c=relaxed/simple;
	bh=/+AACNUK3NWSn3jwhGJqpuGxVWUQ3Hc2IPGl9YwdYHM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=euwwCffSNNNCmqjTrmhjzXjCq7qD/y9WMMg1RPBDH7gN4cqSfzpdt82R42lB8p3sCRLY/y6IPniNtDWjDy58buspuYPUZZxX3j+OBtR1FmLoub+pZqRgfmT6TjK2Zx9C0EN0LTqeG5vtBYKfzR/I6T3DHpcgyECo2CYiqxbivl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D+pL60lA; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-604ad18981eso33477637b3.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517253; x=1708122053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yi4hHgzRm66Wj0icAfm6O+EqUFwwNEbxzptOYQ9az9o=;
        b=D+pL60lAu5xXZzNy+stnlcNJnCE6Zb3CCbUt0wwSpMRelviatTlIpMNEEHe1LHRzbG
         aITq67Fi6LG70I7szCTSxgMY6Qqj4niqXeG43t9HYWXmgBsKhTO8xpDZk95ORvQ0sfIz
         mDiYV0fo8EGjL0Ab6TRxhQbDzsCim9u6alLtcfvXgFVM0AiEqWsDhy8d+1XKhN/gVtV8
         lr0+2ws91rw1QRy+HSBt7ACK2KSJhtGRGT05ldHFs5YQ1gTwgOIBcV7dURA2Estwq8vp
         ql4ZM8FXoAfSh9aKdfgA4CyydCaWcvRPENWoszCBGip+LRIP0vk+KHAr9H2GHOp+NRBC
         TskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517253; x=1708122053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yi4hHgzRm66Wj0icAfm6O+EqUFwwNEbxzptOYQ9az9o=;
        b=BxrV9l6iDz/HblVkDcX/TFOmfWaQ53C4xl0E4wsgdnrIn5i5+CW7R5O7MGjG1nGSNs
         sCivDHzWQSzpQkg+Ax+BSDraLhM3tVOMGb+JXYRLOUQBgEYwk1YDleDaJVfbLY4Wbcl8
         f7RZrlLbn90MF6vYzTaM1h5SwU9fv/RnNO0YBOeQC5rNy8x2x0HjZHBHz5NNxXcS6AK2
         H0kTWnubG6ryRI4smAoCxTxHShkQ2xpfQJ9dI4K6I/xISltsleU1Rlpk5madYyy5i3qV
         GdNJx04bYvTkErMNktgIh6PzSdgAiAVajVt3yzaEHfOJDuMSZNUABkG1hqMFcVpWx+1A
         ct7w==
X-Gm-Message-State: AOJu0Yym9gtQQJY4p9smGAfGh07ioALEjrh3NgJKxiN3oq0jLmuNNR8E
	C/B4tucYTAErZWaiEfHewiDQSk0jw6cEttBB040DzHTs7doh4n+uEFsodemdvVOrxepEHCqFfkL
	ibw==
X-Google-Smtp-Source: AGHT+IEWGzKIt62JQrZlWShnfuhbbuyWmez5l2djLuVbJUzqXxVsrI6ck7bnEYXYkiyxPfSQN31DhiehvFs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d513:0:b0:604:103:567d with SMTP id
 x19-20020a0dd513000000b006040103567dmr152824ywd.0.1707517253085; Fri, 09 Feb
 2024 14:20:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:20:47 -0800
In-Reply-To: <20240209222047.394389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222047.394389-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222047.394389-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero
 at module_exit()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

WARN if kvm.ko is unloaded with an elevated kvm_has_noapic_vcpu to guard
against incorrect management of the key, e.g. to detect if KVM fails to
decrement the key in error paths.  Because kvm_has_noapic_vcpu is purely
an optimization, in all likelihood KVM could completely botch handling of
kvm_has_noapic_vcpu and no one would notice (which is a good argument for
deleting the key entirely, but that's a problem for another day).

Note, ideally the sanity check would be performance when kvm_usage_count
goes to zero, but adding an arch callback just for this sanity check isn't
at all worth doing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59119157bd20..779a5b32a5bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13878,9 +13878,6 @@ module_init(kvm_x86_init);
 
 static void __exit kvm_x86_exit(void)
 {
-	/*
-	 * If module_init() is implemented, module_exit() must also be
-	 * implemented to allow module unload.
-	 */
+	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
 }
 module_exit(kvm_x86_exit);
-- 
2.43.0.687.g38aa6559b0-goog


