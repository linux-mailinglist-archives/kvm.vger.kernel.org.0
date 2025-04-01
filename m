Return-Path: <kvm+bounces-42357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6B6A7800F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69A1B189389F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9704022258C;
	Tue,  1 Apr 2025 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fdcRZeMp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D0D2222DD
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523937; cv=none; b=L3j+1T+UNSwlLwvSAZxaFQbJ4EVu5L52bK76FryH1ThhxnEqAQKqsKTGmRQjkIKTNBbaCMO1JRw8TKaebw/YhdT55cUR4MSjFJzAsfAOw3e0T/424H1MUE/YhHxYTC2dFwnaTrmJQMkPwK9d3E4+EpChckZFEL8GvgH7543mauQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523937; c=relaxed/simple;
	bh=rEEG/JqTWYMnquhcA1NsEvfPwDFWFVv9Eii5wJCc9Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW/F1UeDmWmZgVqvPvAtbF5dIPJjxdh50zFLhEZ5+I3NhqJ4DssbAefEzdUV7tNuGy/yJqwdvNPFserVUjBfbRa9czQByI9159i58hQPWY6FemN/yKHk3RXSG18O+5UvhXHVBjDRS27iiKMLo/R7Xz507tLk0IHv04CUrvp2KDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fdcRZeMp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=clEaJtGkNoCtPvE/vwlOxKGgMTuZLXXi/afw5Ojz1dw=;
	b=fdcRZeMp+6Cv7Rqo498oJ1QBv8fQH+8f8F/eGvNd4cxAQnIJEDk332GaZb8EqursOYf6Dr
	HVOeeEF7vypGM+KSX5Nn8FXH4WhddoYHnJ2/WcO2Vnv+V0wkM25YKGIvyuTcTdGUpFSZf9
	P0TNN3VOD5yHNlKfQGgWlpN/u1u+U68=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-I4aRB9-UOpe-paTa5YVDKw-1; Tue, 01 Apr 2025 12:12:13 -0400
X-MC-Unique: I4aRB9-UOpe-paTa5YVDKw-1
X-Mimecast-MFC-AGG-ID: I4aRB9-UOpe-paTa5YVDKw_1743523932
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d51bd9b41so51393245e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523932; x=1744128732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clEaJtGkNoCtPvE/vwlOxKGgMTuZLXXi/afw5Ojz1dw=;
        b=AjBzXmusE5PHJ4odf7OvpAvr57UKPQ/ds1l+i4CFcX0RyS1tV2k573+wfzMj6bt732
         LMArp7a6AlAsPmxyyWdg/Va/RitrsdPGtQZDU1cFKsb0Dw1Nv5qTMI2N/ahkBf9uFYZA
         1LALLFse1r5ITNxta07uJucn0QlsvRwUBia07Qvrd6ax6ZJNpaPsjqljkUHVKR7heeZ7
         iwL0CiGgZFm/S7uXQ7HRgz16YQ6LH61qNYAYXOFKOcY76GxbLFIZPDb1mkB2qI6mTq9c
         9iggdqR8X4PIOtLD44G8AZ0pC6B6D7QGNA6HjwDoK9EhvuppircmrV6RFhln02AMBIAR
         dyRw==
X-Forwarded-Encrypted: i=1; AJvYcCVqaTCd8A7nGZKwPzMxNrIJj/HBZXk49S76jnWM2Her3xta9sIyQUZzBA8P7rWf5BFV6Fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHolMTMC1VL50YevrB8AvMwvGJcxdk0gJ1lpMgfjUiSRI6SuW7
	f3ujOtBDRQPsqpz174JwM4Wvx98JnCwp1Iq4bzTYmKEbi6EXcUpx3RQH6Z6Bb/aWkRyM5g+jV10
	kh3AfoHgWTtU8KxK6gXBNC090HKG9Kd4/EZauoMOHSD9UeLyn3w==
X-Gm-Gg: ASbGncu9muelWyqRx1qSOgT/M6ZibCwlwGssEQvnyeVPInUZ0C33mGsb1BdLbo6hjwY
	GFAsMFxR7TUsCrfCt35iQ9bVAcXulsLQMG1/qv+e5ppRW4kj2lqw06EDBCaUmVKd+SjmsnttLrk
	y9sz4q3xSMIYOM8cBWIduCt9aGe8BEIciSWCbrN53VYQ8MmthVU2razoLFFM5AN4yZ3dSuE/GVD
	iEv0HsZxPSiNkYd/nRHSV3Ke3/rMvC8Xw2tGb8vnhMT8/Gu8kVZD0Hs0o60pXy8vbI7s5qydr42
	9pxNw210utAvsXAPlydSmA==
X-Received: by 2002:a05:600c:3584:b0:439:6118:c188 with SMTP id 5b1f17b1804b1-43db62b7c5emr104954805e9.19.1743523932506;
        Tue, 01 Apr 2025 09:12:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcsGAEYE+5PwlQjdEBXjpJ/Slimxfn6OxxsnrMh8halxw+3MQX3DryS9bQZc9lJ/fr1kYiAQ==
X-Received: by 2002:a05:600c:3584:b0:439:6118:c188 with SMTP id 5b1f17b1804b1-43db62b7c5emr104954555e9.19.1743523932128;
        Tue, 01 Apr 2025 09:12:12 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fba3b13sm165471445e9.3.2025.04.01.09.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:10 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 23/29] KVM: x86: extract kvm_post_set_cpuid
Date: Tue,  1 Apr 2025 18:11:00 +0200
Message-ID: <20250401161106.790710-24-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CPU state depends on CPUID info and is initialized by KVM_SET_CPUID2,
but KVM_SET_CPUID2 does not exist for non-default planes.  Instead, they
just copy over the CPUID info of plane 0.

Extract the tail of KVM_SET_CPUID2 so that it can be executed as part
of KVM_CREATE_VCPU_PLANE.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 38 ++++++++++++++++++++++++--------------
 arch/x86/kvm/cpuid.h |  1 +
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f760a8a5d719..142decb3a736 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -488,6 +488,29 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }
 
+int kvm_post_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+#ifdef CONFIG_KVM_HYPERV
+	if (kvm_cpuid_has_hyperv(vcpu)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			return r;
+	}
+#endif
+
+	r = kvm_check_cpuid(vcpu);
+	if (r)
+		return r;
+
+#ifdef CONFIG_KVM_XEN
+	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+#endif
+	kvm_vcpu_after_set_cpuid(vcpu);
+	return 0;
+}
+
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
@@ -529,23 +552,10 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 		goto success;
 	}
 
-#ifdef CONFIG_KVM_HYPERV
-	if (kvm_cpuid_has_hyperv(vcpu)) {
-		r = kvm_hv_vcpu_init(vcpu);
-		if (r)
-			goto err;
-	}
-#endif
-
-	r = kvm_check_cpuid(vcpu);
+	r = kvm_post_set_cpuid(vcpu);
 	if (r)
 		goto err;
 
-#ifdef CONFIG_KVM_XEN
-	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
-#endif
-	kvm_vcpu_after_set_cpuid(vcpu);
-
 success:
 	kvfree(e2);
 	return 0;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d3f5ae15a7ca..05cc1245f570 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -42,6 +42,7 @@ static inline struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcp
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    struct kvm_cpuid_entry2 __user *entries,
 			    unsigned int type);
+int kvm_post_set_cpuid(struct kvm_vcpu *vcpu);
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
 			     struct kvm_cpuid_entry __user *entries);
-- 
2.49.0


