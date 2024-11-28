Return-Path: <kvm+bounces-32661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACE29DB0D7
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C763161975
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E586114D6ED;
	Thu, 28 Nov 2024 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nza6PhcQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE7B1494DC
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757692; cv=none; b=IdAXXmsUxQjG9uDPXDi84H4mS26H4+8BOr9cH0Ak+MGfN9d8vOnVYYjk0PnJWKF1fH1Esja4kICMbhVjov++o3szQGtXl8ESpcDTrPBjh/5f7aQGk3LyNJ/C7zgOT+bXF3hY7aG/9SgsUwKC20XRBhIxKUGf6vxknpKoco53bTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757692; c=relaxed/simple;
	bh=XUJ82Rtg0dvNzftBjBgZdlUMYIOHxk/MRQT5EY38WoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jj+8fi15yyJ4DNgqDw3Ldso3wNhObcHYDoGLDSFJ69bqTB2lqk6G0/j8PGzgOvXdFXZCrabnOs4jFQy02bN8auLQgW6oDgRtxTYVCrvb26Fqd44+TWhp1fO+HVJV2F6HKTHPFeBVn7wngtJGFF9ZmdrSvxI+1/Jgbb+/UdWje1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nza6PhcQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2126573a5b0so3383415ad.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757690; x=1733362490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QO1nbKSuw4xAHdvTKrWO+XAcBIQugd+Jc8EgRJlODfQ=;
        b=Nza6PhcQEXmZL+iho4fLgaJ6f3bq6o4OfIMQ6j5MzuOKBJ31D3s86/rzivsYIDNku0
         iFJ9IpnZVmlGgKQu4QIzRPx3xCo4W3BzvB0RO8c6nmSPA7vrtyE5JWbyJozNUNTbg8xT
         KWuXNLbD0SokMV/EZ3WVpMwDZ6SgJzCyxmap3SsQeaRiyjMMUopnhIBWlvJ8o3tgybUn
         WCsITdV8l436hjOQIbo87xEObU5ertnnfwlB6Rd+6jywJ/siq2wean0YlmHt6YaKQbX2
         u+2hDn/cQPkCAwjyp+3YqhIf3mBN9pQ+lZUHP13KRZnGagH0O3vpzvVgBPvW36aNK2fO
         IRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757690; x=1733362490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QO1nbKSuw4xAHdvTKrWO+XAcBIQugd+Jc8EgRJlODfQ=;
        b=rFVTA5hKoKJWx4j33exiXxuQHs4cMUVHGirieRBl8kw6+2uU5SnZtmvJSKvVEgNJju
         LaFN0tNwEAfESiUU+ndDz7Q34zpkxLgtkfE/l+q69i6MpoUFTCbtSktLP6wjg4C1sdeq
         aeepOsT5SzYsfdG+RLYwjgNhiMXNkOfrcCKsuWzxZyTfSQ3mYUZVhOE57gWUfLKu+4sE
         W6NgmoBoE/dNqrz7hrM4kEHm7FgpSf/hOTjtB8KYTq7i7/XZbdIjIC2Mb4a6luB1QN5S
         x4PKsLj8AGstCcW8rI9u41bQeLC0KVNUXCWH5/cjg2uGj5eMq6GOFqOiUy0aIIEmFGoZ
         0lAA==
X-Gm-Message-State: AOJu0YwK8SQqJwpVQUaJ+htHc4UKoHuNX7SBwsquRw63kMtE4ahHp7d4
	XfE72c1GUqr/5pso3AS7Ycn9wjJ450OohvZ8ATbS00Q03j3gbSokbYbpY8/41btv71cEWCGAEVr
	5aw==
X-Google-Smtp-Source: AGHT+IFql/TwOfNwT9CVZ0WNulnEpsE+uGEyzsfAGgYdcC+q97T9HfG6pl6mZwpvJ0LoRod86oyPOYL8AVc=
X-Received: from pllb7.prod.google.com ([2002:a17:902:e947:b0:212:4557:e89b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50f:b0:1fa:1dd8:947a
 with SMTP id d9443c01a7336-21501d58ac1mr60024385ad.46.1732757689708; Wed, 27
 Nov 2024 17:34:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:37 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-11-seanjc@google.com>
Subject: [PATCH v3 10/57] KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Let vendor code inline __kvm_is_valid_cr4() now x86.c's cr4_reserved_bits
no longer exists, as keeping cr4_reserved_bits local to x86.c was the only
reason for "hiding" the definition of __kvm_is_valid_cr4().

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 ---------
 arch/x86/kvm/x86.h | 6 +++++-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5288d53fef5c..5c6ade1f976e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1281,15 +1281,6 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
-bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-{
-	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
-		return false;
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
-
 static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	return __kvm_is_valid_cr4(vcpu, cr4) &&
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d..7a87c5fc57f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -550,7 +550,6 @@ static inline void kvm_machine_check(void)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
@@ -577,6 +576,11 @@ enum kvm_msr_access {
 #define  KVM_MSR_RET_UNSUPPORTED	2
 #define  KVM_MSR_RET_FILTERED		3
 
+static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return !(cr4 & vcpu->arch.cr4_guest_rsvd_bits);
+}
+
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
 	u64 __reserved_bits = CR4_RESERVED_BITS;        \
-- 
2.47.0.338.g60cca15819-goog


