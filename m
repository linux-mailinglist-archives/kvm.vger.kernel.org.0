Return-Path: <kvm+bounces-17658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 756258C8B54
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 166BA1F24DAE
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805191411DA;
	Fri, 17 May 2024 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ElGEPxtB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9C5140383
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967597; cv=none; b=LwXReFvlHkBJa/1hevpycRMtg6UZ/XyzcCoq6eoVdlHO9bbD5YflSeInr4AFQyNp/QtEUNXCnXr0Q9OquuFKN6Le04233D9ioASB3swqntHdECYMV/40txpKM756E1olD6F6Qpi/LwY2P5WrC3syNAo5hgWcVN5i3fiWQSgq0dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967597; c=relaxed/simple;
	bh=AbfLQhyF3OH5B997fpsklE0q8dPfOTJZLQGWldAmSWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbPCtu9jaYyjGgPWvQzE1H9dDd0V3n6w9Wu9PgmedNhY0ekEfX/wOxuRlcPxJNg84QZyBeOmVXh1JuvmXdrc7ntioGBfNG+L92NqP2nzCy872M2lWD0ym3zlLCObeiiLedO6qdqbipoGEZSQjl6JgJ37vEq4jWtAPynqEigoHWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ElGEPxtB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec43465046so86986185ad.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967596; x=1716572396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n2pDz7/oTNEpqtQer1kZX15zeO+uHNcrWAzJZzhQ5SY=;
        b=ElGEPxtBLIRKCnvsx7fBDkE5gA923UJD1oi5+LRSkP1LYA+2gXzyceSOGMypl3WLvR
         Vh1VBb/tApFBTqJr3nDrOxS4hh4cSrJ6GJo+2qoqz3kmsAAurNZES02D46yZHi11ZHee
         ZZzjgN5EbiFnQBcqQKuvRkuS4d6E5jqXoy5kI7E/XHXNi6tP++wGpw9kCkzk78KmwOlM
         UX0wDGMjK3oaZNe2qCVfDiRMwG5C/TxgbAWPiCrJOOnNOkGexMZr1xvWuadK8Vi2u79g
         A4fUM0EhCne94vcNcghNU74v/0B2udcKGtihLprSLezajlm1Bhke4u5gT6qRCpfCN1Ic
         fKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967596; x=1716572396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2pDz7/oTNEpqtQer1kZX15zeO+uHNcrWAzJZzhQ5SY=;
        b=WjNMXDUqeE181oiqGBvYtEJdp8gk0MrLPjKS9AHmyO9TIV0qH1cPmrQaf62zxGECmd
         nvfEYqUf7sgAkOqF+QV7xOOXgzTeiJ712vvTBlZd/c9XCSjuRGfG5WmS7hLXdM8EqXy/
         IXpTBcBDsVhKabe8VJPZU5U1FKh+YOT43nMClETw/1hbXQnnQNbl+Ue0/2h5FmMMO233
         YhstoYeOUS5qURBgw4IYv5/VYOelnYS0iIw3NHiNSmQZnCYkWYKO125EKPVkcyaWjsY9
         jLQocUSiKGS3n3uMatHW/cswGNKzkvEbmUXTX39vINIMPGnXwFcv+tpbWtHuxpk7bwXt
         WKgQ==
X-Gm-Message-State: AOJu0YwOLPheyTGgXGCfXLyX0AUlK4qbPd735IM/89Tyb15klMbhFk3+
	zR7yH45ZfQ/x+UmwGRXVMSsakWhqidEo1onFHVaOKTfQ6l4lD5W3Lu4U6vH6+fMMhrNcYXjiDan
	mEg==
X-Google-Smtp-Source: AGHT+IHHJT9L7juixaqDq5aE+FqCbe9Hd6zC3NBYVhjtCHTrrsNtJXD+RNttaeuuiFjmdSa5oOeHG+DYsp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c947:b0:1eb:50fd:c37a with SMTP id
 d9443c01a7336-1ef43d2e21fmr10094135ad.7.1715967595676; Fri, 17 May 2024
 10:39:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:43 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-7-seanjc@google.com>
Subject: [PATCH v2 06/49] KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Refresh selftests' CPUID cache in the vCPU structure when querying a CPUID
entry so that tests don't consume stale data when KVM modifies CPUID as a
side effect to a completely unrelated change.  E.g. KVM adjusts OSXSAVE in
response to CR4.OSXSAVE changes.

Unnecessarily invoking KVM_GET_CPUID is suboptimal, but vcpu->cpuid exists
to simplify selftests development, not for performance reasons.  And,
unfortunately, trying to handle the side effects in tests or other flows
is unpleasant, e.g. selftests could manually refresh if KVM_SET_SREGS is
successful, but that would still leave a gap with respect to guest CR4
changes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8eb57de0b587..99aa3dfca16c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -992,10 +992,17 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
 void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
 
+static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
+{
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+}
+
 static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
 							      uint32_t function,
 							      uint32_t index)
 {
+	vcpu_get_cpuid(vcpu);
+
 	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
 							  function, index);
 }
@@ -1016,7 +1023,7 @@ static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 		return r;
 
 	/* On success, refresh the cache to pick up adjustments made by KVM. */
-	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+	vcpu_get_cpuid(vcpu);
 	return 0;
 }
 
@@ -1026,7 +1033,7 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_SET_CPUID2, vcpu->cpuid);
 
 	/* Refresh the cache to pick up adjustments made by KVM. */
-	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+	vcpu_get_cpuid(vcpu);
 }
 
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
-- 
2.45.0.215.g3402c0e53f-goog


