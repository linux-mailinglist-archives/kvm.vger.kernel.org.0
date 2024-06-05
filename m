Return-Path: <kvm+bounces-18957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2073C8FD995
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B20971F25034
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 22:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB66115FCFB;
	Wed,  5 Jun 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="qOluVNgZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0C315EFA3
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 22:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625127; cv=none; b=MT3HCAqdisErdUk9DGFAVOohljZedGuV267tjYk1lRJ+FqPnHPck3M7Jy/BVZ/aGEhj8EtE9GT97w+/VWcqqrR4g2+2UsbOGmdnDA0IqW+eguMfzITASUTAFZ8D/YALw+UdNFz4tvlvfFysS2UizXVMPIaPye3hiHCog0u2TUOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625127; c=relaxed/simple;
	bh=Mef8+WrFLjcRWTeyr7/n9NEG+tIXc2iTFCcmhv9M4po=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jgz/YqWm52+Qj13rGQbH384iwtuxzFPuinEJ5EsiiwoJn5BL7UaEz2z+kWRS2bjnAzogwvmK2NkR5/Tn8TJ5O463Gvnxks/2gFEpmoklp3Ywf1pDYv3iAhWOt2zBG3RslG6q1vVxWPpKH1BjVeCZBIT0ZPypTdZhpLlQ2eR9LMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=qOluVNgZ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a69607c6ccaso27603066b.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 15:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717625123; x=1718229923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZbb2eMSSDdlpeUuW/bDuyvE9odB04iaefVgLAtvy4k=;
        b=qOluVNgZO1ISt6EK0ioj4NZr8XP/NGCehaRcJ+hHVHMHnN4EdUI4OeLvcaj/xhF+t4
         CODd/DcGwb8rqoAuggunUbh5r6IGE3dirx3lTfRIWY0uFvFARngrZVX0y8eT+1O9QHuW
         KSkWLwiTLYgLdkUjx8VtjyP35htPRfaWYRiQSgtHgr3PY/gPTy2os7rx7xp0ZxQwbXJ1
         9VBsNR23c11TjxdXPREjWDX+usOSkoOdxh/wghq7nzlM582WU9AsjFFBqjXg64ngcHZ/
         YVwI0n22K0AfIDOjePHsxPmVb9t3BeAzfVXrZMpnBTpkqa8AYfCQDvfRRzMBPwGa7MFd
         kjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717625123; x=1718229923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rZbb2eMSSDdlpeUuW/bDuyvE9odB04iaefVgLAtvy4k=;
        b=BSM/iWpl2bJryYQf5mlUJVG6IfarkcoiXUo+mnRmYat16mGhZhE2avg7lf/ehVTVHd
         qCn2uFWEw/0bOLZeVt84Xjxqz8uKjZMojdpDHjo2rwLkhX7U7DFnOnjAax80IdxpNa6A
         5XPik+OITEqEWsFwnjm2yXNCUfjvQ/YvB0KGe47/0FA42h9fKyelHPPAgCPZMkV3rNar
         EW0LxtxkUkrmVV9JuRzKpPh/v+bG6TSGrBiU4wwNiCBPETQ4havtO7tHxQ+6sea4wfWc
         zOIdmd/hawtvW7YtRewslHW8QNvNycPvLcy7wbLGKu0Vm6bT5a0IIaxOpalWfXMYAmLS
         C3sg==
X-Gm-Message-State: AOJu0Yw41pmR3H8/khg5FdPURuOgxaCGuLtoo7eXidGLtqRyhvxZdvof
	cCD/UcYFiH7Q/rS3IgKdka+6cGq4MsG28A6VzTKOr2PsvX7QSV9DoCtD6iWIZIx0i3k5OsWdVmm
	g
X-Google-Smtp-Source: AGHT+IHcHHksoYEVtrbUnzuD3YgLEAr72AoaYN19YTmIlctLW8qHnC7Y7nZZs4qdHveKdmp5CE6EeA==
X-Received: by 2002:a17:907:75c5:b0:a68:c0b8:ada9 with SMTP id a640c23a62f3a-a69a028ebdcmr212013266b.76.1717625123413;
        Wed, 05 Jun 2024 15:05:23 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af09bc00454dac98c3a8ddbc.dip0.t-ipconnect.de. [2003:f6:af09:bc00:454d:ac98:c3a8:ddbc])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f56506dcsm574559866b.57.2024.06.05.15.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 15:05:23 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 2/2] KVM: selftests: Test vCPU IDs above 2^32
Date: Thu,  6 Jun 2024 00:05:04 +0200
Message-Id: <20240605220504.2941958-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240605220504.2941958-1-minipli@grsecurity.net>
References: <20240605220504.2941958-1-minipli@grsecurity.net>
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


