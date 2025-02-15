Return-Path: <kvm+bounces-38231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C50A36A8F
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0C93A2948
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048EB13D52B;
	Sat, 15 Feb 2025 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Om+ngLa3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB131F9F8
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581575; cv=none; b=KtOXOMZ3UbqALAPCKE2GeoDOaOgMG+5scPr+NJli9SntvV2VTokjw9i/qKsDBllvQeR+mQmn2UkANoIG1NU3qsDUtPX2DfPZRPzcedA2x/mc+t7eBG/7JhOViqoFMmaFMQ4fFQ6Puv1k/xP7pLZzsZCQzpdi83m4iFfOBOKeuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581575; c=relaxed/simple;
	bh=5wliXWDYsrFCwme0bU8BDoFYLmTGBwCFoyuhP4vduys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IJVXOdN51ntcMwgH/Mm9TZYwgTPoLZNWRGO7qClS8cKBOPOP8ZhwBKBbK2F4+FcNW0nnQMqQhUt2sgIDLk7H+9izYYeUpFOsIFQQDoCTDil9nt/taxjJGKathIv7j3auzzrWTsWRZegRIPc7W1e1N0HeFiJ7AQUbVLrjnsuLW7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Om+ngLa3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220ff7d7b67so15895915ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581573; x=1740186373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gnHrxG87g2zrpNznbUWyypfRtpr7va7BhlbJAw1+aOQ=;
        b=Om+ngLa3jxTKgaX7Canh3KrefjMF9f9R+pxKqw1qMdfYuVfPoVaPM6YaDh8Hyb5iDM
         UhN03+GRWOS7q/aDkQFRHaXpeN86Zxzjvb344yehazSmn/YkJlIWFil2ZbBa+x6iGhCw
         Qm0nNnmuh3citPrsn6yhuwaP+HMBObp3hUmSnmziF+NfXviXyislWG9G19A+amZLwpQO
         0iucd3nGaBBK6jxkc736S3WhXBbZTV2mq0oJEYM69AFY6YCWUap4ZeGLrumthlZ30e5q
         7T/+dtdwWBxu5xOQa3teEMxF/mt/PSb7F6x0aptw8JM2hb36QSM5oiCBjyXBCguTPWqj
         PDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581573; x=1740186373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gnHrxG87g2zrpNznbUWyypfRtpr7va7BhlbJAw1+aOQ=;
        b=kER0dnykfSJ9g9jRCTk3V7ICmFQMRo/X4FExREQ6xWhpPW2av1U1dnFpeoVSsOaEQh
         m0ijxVuTgMVTzUsJ9lzQg+CwUHJWHoAacbnTeYQIzVge8v7aUt5QNJBYxAtnfaBB6AtM
         A1tVispxOYKqLDNsNhuJ1/uuViymZjlNnJq8BwbvHWJWWp6vlA9uTd6TajsOo9M/AUab
         M6rHZBFyJRT8SXTpVk52qKlyPw1cUn59WUV5+OUMc579DSDQjKWl5HDZMM1WaR2U33Tt
         44hP3Uh5O0QSLdL57CJlvxTet8TQ9Zg94YXgKfX9zN9TuwQrgoz7C10kwbrdtPGwFvA5
         XPtw==
X-Gm-Message-State: AOJu0Yyq9iydmzz5dJm1eSialWn/HopIgt87jzsKOgUbhB49wUTaXG+D
	gu2jqq93x3FKHagYi1f+aJ8BBCp2Al5Wq2iEvwyg/4U9XSsifR3ncjK13wtdiDRmvMmm1xBwx1P
	6Kw==
X-Google-Smtp-Source: AGHT+IFqpbcx0eksJgzswjg2oejQ8+iZ+7K9CjQZzR/co/7jmMUA3+1XjLY7h+QZJ+aWbZridj68BiDJaJg=
X-Received: from pjbpd11.prod.google.com ([2002:a17:90b:1dcb:b0:2fa:27e2:a64d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac5:b0:216:7ee9:2227
 with SMTP id d9443c01a7336-221040a8e62mr21822595ad.36.1739581573052; Fri, 14
 Feb 2025 17:06:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:06:08 -0800
In-Reply-To: <20250215010609.1199982-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215010609.1199982-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215010609.1199982-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and
 guest state is protected
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Don't inject PV async #PFs into guests with protected register state, i.e.
SEV-ES and SEV-SNP guests, unless the guest has opted-in to receiving #PFs
at CPL0.  For protected guests, the actual CPL of the guest is unknown.

Note, no sane CoCo guest should enable PV async #PF, but the current state
of Linux-as-a-CoCo-guest isn't entirely sane.

Fixes: add5e2f04541 ("KVM: SVM: Add support for the SEV-ES VMSA")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..3b67425c3e3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13395,7 +13395,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 		return false;
 
 	if (vcpu->arch.apf.send_user_only &&
-	    kvm_x86_call(get_cpl)(vcpu) == 0)
+	    (vcpu->arch.guest_state_protected || !kvm_x86_call(get_cpl)(vcpu)))
 		return false;
 
 	if (is_guest_mode(vcpu)) {
-- 
2.48.1.601.g30ceb7b040-goog


