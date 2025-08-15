Return-Path: <kvm+bounces-54734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F056B273D3
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AEE71CC34FC
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A311FBCB2;
	Fri, 15 Aug 2025 00:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ybiQ1E84"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99A1EFF96
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217563; cv=none; b=lVY4/Xy3qjH9xcgr8eAXioS9jekt6rxFd5RBT4KrBfytzTqPUm6/IhHgj/cdLv+J80mq/4S51ZlGlNla6lZEZAhu/LXuxwo7V5dzIa6fQj8IxU/PBWep5wU8XQcVbZLGDLMflyqt/i9ozcdSuMIUUUA6EuzDme64EJo/GwFird4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217563; c=relaxed/simple;
	bh=Q/JHGW57EuoJgXK91IfmuNQ8KxhAOb1XQxaQXnOBkn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DxTNn+tHRuP8aZjd2bA4NtnN5PznaBWDnmVQl98veh92uxV9SLJIJukRtkgaqaL6OWeoNpcei2WbNmEj4QkAuzb+qPPG6YUZe5UpJSQINrF4mxI3SlhVKsOl/NwbynjrJ8z166Y0+jofRQ9RqBL5B4UssC8vT5+qroeEDDut09Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ybiQ1E84; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e09c5fso1543243a91.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217560; x=1755822360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4mlGOKyaWuNfcpdQevvY9rMQD5UW3bPI01VSmQ330+0=;
        b=ybiQ1E84Y3hKpD4ZpfyQ/O1oKoslk6N7vqdgIL9EXl5pb4i9V5DL3OK8i1IPAdlITb
         0ulJJ4p6klB0U+arh/nKVWn+dCocatkRusRKjT50VS9c42WAL0S6ywgWBEUQC0+6a3n9
         inJW9mI0Nkph7ja2HqtKMxo8W+guhxiKmsILcL70a7hDTqmZmGx9/ew7G+bCZei8lFbW
         z+rqkGcgueO8eTZf8q5w6mLsK9dGvccZ1kArNkRxMtHr0ScGW3LPFPwFRtTtypwuqFc1
         dc7C3e4BYDK3vh2eQ4JEeZts7KHKF1+o07Y7z57En/AD98vBqW1SACvSDfz3bUZPL9RF
         irzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217560; x=1755822360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mlGOKyaWuNfcpdQevvY9rMQD5UW3bPI01VSmQ330+0=;
        b=ucDKCmtfT0cXASoT/VrwwQZjfx1HVVLzgras9Hu+r0xYJSBjICso4u7qo8nFbNPwLe
         0N/1TZRCBI4q4jQEbVJLWMsxsNmYmQMDgX84G1BBQcgfozyUn7gxR1cRvj94V5Xb4B8h
         wfsfOQ380L9UEXofxu9eB97xsPQOgNUbYzjPGRlYEuWuFSsNryRdJhZX0KMNUOUQZaBL
         2IWJ6Ak0SOdIO/kU4+o1YqBR+ztIB0hh02suvi3UMq6kePVk7zphRfwabEbOt56LVJSA
         sKX6WOrZ2/Tnmgfo7lcE9BdTlsH/PEu3aenHpa/KqfnECwDG62icffXkiHn6hdtaihZo
         eaZw==
X-Gm-Message-State: AOJu0YyqWKkf5KyGY3GQjqP1jUYBi9vCoEFYlEyIOiKBaNT+WhLyOv4X
	D9xuEk13riQ6D/nNzv8ArRm0SUGaP+Usn5Vxg0GaMrWXkkU0hjQoyyhn3xbViQ90vtuph9O+pNy
	9XqFU2Q==
X-Google-Smtp-Source: AGHT+IFjfpyiGFmFU4A8fVbY8HVbYLaMXLnxr98ykfXT3ShMDpAtm6QKzQ4bmfCIms/Lng092ujyzrsTcVs=
X-Received: from pjuw7.prod.google.com ([2002:a17:90a:d607:b0:31f:6965:f3e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3948:b0:31f:12f:ffaa
 with SMTP id 98e67ed59e1d1-32342163830mr293347a91.6.1755217560575; Thu, 14
 Aug 2025 17:26:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:29 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-10-seanjc@google.com>
Subject: [PATCH 6.6.y 09/20] KVM: VMX: Re-enter guest in fastpath for
 "spurious" preemption timer exits
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit e6b5d16bbd2d4c8259ad76aa33de80d561aba5f9 ]

Re-enter the guest in the fast path if VMX preeemption timer VM-Exit was
"spurious", i.e. if KVM "soft disabled" the timer by writing -1u and by
some miracle the timer expired before any other VM-Exit occurred.  This is
just an intermediate step to cleaning up the preemption timer handling,
optimizing these types of spurious VM-Exits is not interesting as they are
extremely rare/infrequent.

Link: https://lore.kernel.org/r/20240110012705.506918-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ee501871ddb0..32b792387271 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6019,8 +6019,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->req_immediate_exit &&
-	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+	/*
+	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
+	 * due to the timer expiring while it was "soft" disabled, just eat the
+	 * exit and re-enter the guest.
+	 */
+	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	if (!vmx->req_immediate_exit) {
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
 	}
-- 
2.51.0.rc1.163.g2494970778-goog


