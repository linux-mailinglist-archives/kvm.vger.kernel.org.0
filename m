Return-Path: <kvm+bounces-19516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CD8905E08
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759001C213A5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D3712BF3D;
	Wed, 12 Jun 2024 21:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="I08DF1+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01D6127E3F
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229273; cv=none; b=uUIImx0nZkGq8j5+7IYL5uf+mx4YsXAGl27tvJSTN4Mr2bQirFiKUVA/GTzJcoKQNQxb53IfaVZ/OHUHGsTW27hSqkzg9TGLDgIC9ZLNJqw6nSeBmUTjl7pOWsbZ1MZTg/UXx2tziswI6I/7LCn+ldheY1Wc6KaizaIUoAAkOFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229273; c=relaxed/simple;
	bh=Mef8+WrFLjcRWTeyr7/n9NEG+tIXc2iTFCcmhv9M4po=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J/ZOj88d+vb7XqqdGBtJ26V9erDwR+D38OMnhq9PO9ySrOC8SxrjtcU5/9+Uxy2tyFrBMXBIFy+sgV3Z8//CHVZOamyqYUnkS8B5Mh+eQB3x4zpa8dNJC14x6itj90mPHCIUkP20SQStOIAg1TLTWC+Vn02+iqly1IHqelswEQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=I08DF1+j; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6f0e153eddso48134866b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718229269; x=1718834069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZbb2eMSSDdlpeUuW/bDuyvE9odB04iaefVgLAtvy4k=;
        b=I08DF1+j26wO+mmceoQ53IGTDam+i+TSNh8FfpM5wci8+2Gaa5t8cQ0/HVDdD6Gmq7
         MImETVAUWKAAVhOy+8Kh2WvAQGfg3S0HQtOm94MqsCQYtgINJX+boBv9pmQdRJ/IsvS8
         7auiP4bZ/dmEZJamJNU7xvdGiM/6vQUReFWrF3vk6HikmELqDdhCaoqICxWRJP3fymW2
         8eejqFxj7SNZPxF74wzyMHSaRXovtMXisxSRJt6bE3QdKA3M5Q1z4WNTR6tFmeppSuwG
         qFiDL2DedkKz383tpEVfQxObdc/TSsRNHk5zpDM604ayDfjLqfgN2ASd7lka0LxpcX3K
         t9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229269; x=1718834069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rZbb2eMSSDdlpeUuW/bDuyvE9odB04iaefVgLAtvy4k=;
        b=FSGmT4+iXLjT4KwK+ktps8cIuiG+GWpnJ459DYvXQ84Rmtvga2rZDtg6mIroNoa+jo
         NR8ldVU0Pe0K7+leUFy44HlDe0ZXa+9fWbYoRJ2uUtXoupftemW+or68H0EfuW2TFsPI
         fWkyU0RLlo2TeJtpVfdss3QiclFMYUy7eIlZEg1Q79fFIHL4cNp4vnSz37IZV8C2/JV5
         CrodTv1Agwp9xNt2AMEDNSR43Bgx72cZGQOY4OHEcnvqsAcGKEVQn24dQlVtkjDw3qDB
         qPMqtJyQBFpLWICfbDNHFVJP0EHvlW5fDQdTfPlvIinifcYKuOOfeJhJNHi7U7i9TWFO
         3yHA==
X-Gm-Message-State: AOJu0YwssNwkd+MU6Zs7E4Djo8IS23tVv7eKyi9zzYkLhc9pPve9j1gU
	eoRzLSK6Tj7ZX5B+WwvI85rT9swrgvQN+hO8FMgf7bRtXZqp6JS6HnyQEW31iLU/8kN05r02K6K
	+wRk=
X-Google-Smtp-Source: AGHT+IFaXOJZmuW4RC6vvWftRaxf9A4ltZOMTTHSaCEYvTy6FkXgvBXAw0m/VsSCO2SYYloQijxCLg==
X-Received: by 2002:a17:907:7e87:b0:a6f:4b7d:599b with SMTP id a640c23a62f3a-a6f4b7d6bf0mr173495966b.33.1718229269312;
        Wed, 12 Jun 2024 14:54:29 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6dff0247a4sm785359966b.147.2024.06.12.14.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 14:54:28 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 2/4] KVM: selftests: Test vCPU IDs above 2^32
Date: Wed, 12 Jun 2024 23:54:13 +0200
Message-Id: <20240612215415.3450952-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240612215415.3450952-1-minipli@grsecurity.net>
References: <20240612215415.3450952-1-minipli@grsecurity.net>
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

Verify this no longer works and gets rejected with an error.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c        | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index 3cc4b86832fe..92cb2f4aef6d 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -35,10 +35,19 @@ int main(int argc, char *argv[])
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


