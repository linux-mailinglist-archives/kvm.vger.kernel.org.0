Return-Path: <kvm+bounces-19719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54220909362
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48DA31C21AAF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96571AB8FA;
	Fri, 14 Jun 2024 20:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="gIAgUzPx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F141A3BB1
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396949; cv=none; b=jAHP+YNENFVjq6m2rG+oDwWfHLkP7KPtpOaHDb0/z34iKjdt6TgG8AJeUO5cuLipu++BpevAZf6D21OQFtJia8e/ridXRZ9TVX7pAjD6L1yNNNp7GpahXaRUxYVUEN6wHefJZOYiXhIB48AV2JscDaHWEid0L1LmdXufpHoyAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396949; c=relaxed/simple;
	bh=eyYnQz1U9yGOFnckGuPq+jsBS8RlOehpxpbEQiSfYXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aJRko1L1ONEFoHKupKRdFpafXQKyOyBjXxh3zfEf4V4z0N4pa0MesBA6paqAmGrTnZmYOKm8rIvTEkaDJ+h08hHovAodol+F5tNWYiz5xfSmZKlM/u+pScK2C/hJD/n2/gS4jvcX/NuMuWd2s1oJvKN2zoVWZB+UzOHxenaHMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=gIAgUzPx; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6e43dad8ecso468241366b.1
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396946; x=1719001746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydM2qAqGpOE3GfUvJqcQrhP7uFyvSR7c8Nfb4W373fQ=;
        b=gIAgUzPxHLM/5Y7730HAeUKAxviLw7pEjocFm8UXau01kI2yqLXiQ/0UXL+f73HZpR
         OYNvQ3gtEGkN1AAe5s7ZVlwYAM+qTjQVwrz2ZhOUnxAmHbW/B8CX1YwwnxNuF7Bg9XTk
         4BHuJPsdW/oSsmbs0GQ7U4IczbBlfSEuz1LdI4LM1ZJ8OeCIVWSytXEemfsxvR1fs498
         XFOJ5CxviENr8bilI64AOX7pEWmOs3nvqcHvySflFWuczfjtfeEPO49wCXpphpxAmJ7e
         GZ1lC/BcD1yEBMh9cPX9t4Nm6TM1h7FTnpES28RceuIW9TjUbh8gYJhAaI2ot7pxJQoL
         nLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396946; x=1719001746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydM2qAqGpOE3GfUvJqcQrhP7uFyvSR7c8Nfb4W373fQ=;
        b=Evt0h68cXFXvFnxDQ5iXF8WYOO6Pau3ivWcs4Op/KB/iapmf1Vpe69JIWQNdgsWYIK
         800OjGolJus+71FC/lqiBGHQpbEbmguJq2WKUELiEmIzDtPoxtklwNAANquE1bCEcFSn
         lBm6KK9cil3dfBECh1whQtbl7/kexTPARBCrbYsCuOV9THdcQpyGBKsSpjKEVdBN8oi4
         VsFvS9zkxiCiLlL0V5rPJYn0mGP+Ud9LHDYeVfg2WOZQ5H6gnbQFYd6IBg6vD/aB2/+x
         Hv5hrN7GopKvpi1O1IQVs6KRGXYHJNnfgE4uKi2LTeZXavQXT2ZtAZJIigiXYYY0djU6
         uxVQ==
X-Gm-Message-State: AOJu0Yx3GjBwer7Y1oH4ubaOCiFiUZfB7MLv5WvIonEc2ODuO4X8aG1Y
	HIuf5WFtHYvAXtZY9YT3oqh2VDlGfoqAe6FawqJ/5NRlmM13gXtRqlGMqXGE4ukVfk68ooFiu/8
	KxeY=
X-Google-Smtp-Source: AGHT+IFS9eH6uOSbfui6BkTg8xP/ujfUMfsNGtQ6SJRkhx7jAFYelkBTzNBhrPQF6v6LtNg6cxXDEA==
X-Received: by 2002:a17:906:b28a:b0:a6f:1d4e:734f with SMTP id a640c23a62f3a-a6f608bbab5mr239752866b.36.1718396946698;
        Fri, 14 Jun 2024 13:29:06 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:06 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 4/5] KVM: selftests: Test max vCPU IDs corner cases
Date: Fri, 14 Jun 2024 22:28:58 +0200
Message-Id: <20240614202859.3597745-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM_CREATE_VCPU ioctl ABI had an implicit integer truncation bug,
allowing 2^32 aliases for a vCPU ID by setting the upper 32 bits of a 64
bit ioctl() argument.

It also allowed excluding a once set boot CPU ID.

Verify this no longer works and gets rejected with an error.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v3:
- test BOOT_CPU_ID interaction too

 .../kvm/x86_64/max_vcpuid_cap_test.c          | 22 +++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index 3cc4b86832fe..c2da915201be 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -26,19 +26,37 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(ret < 0,
 		    "Setting KVM_CAP_MAX_VCPU_ID beyond KVM cap should fail");
 
+	/* Test BOOT_CPU_ID interaction (MAX_VCPU_ID cannot be lower) */
+	if (kvm_has_cap(KVM_CAP_SET_BOOT_CPU_ID)) {
+		vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)MAX_VCPU_ID);
+
+		/* Try setting KVM_CAP_MAX_VCPU_ID below BOOT_CPU_ID */
+		ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID - 1);
+		TEST_ASSERT(ret < 0,
+			    "Setting KVM_CAP_MAX_VCPU_ID below BOOT_CPU_ID should fail");
+	}
+
 	/* Set KVM_CAP_MAX_VCPU_ID */
 	vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID);
 
-
 	/* Try to set KVM_CAP_MAX_VCPU_ID again */
 	ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID + 1);
 	TEST_ASSERT(ret < 0,
 		    "Setting KVM_CAP_MAX_VCPU_ID multiple times should fail");
 
-	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap*/
+	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap */
 	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)MAX_VCPU_ID);
 	TEST_ASSERT(ret < 0, "Creating vCPU with ID > MAX_VCPU_ID should fail");
 
+	/* Create vCPU with id beyond UINT_MAX */
+	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(1L << 32));
+	TEST_ASSERT(ret < 0, "Creating vCPU with ID > UINT_MAX should fail");
+
+	/* Create vCPU with id within bounds */
+	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)0);
+	TEST_ASSERT(ret >= 0, "Creating vCPU with ID 0 should succeed");
+
+	close(ret);
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.30.2


