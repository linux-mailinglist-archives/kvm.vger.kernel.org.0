Return-Path: <kvm+bounces-15326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9D18AB2E3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE941F2253F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF58B12F386;
	Fri, 19 Apr 2024 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lz5g2uLA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762A3130AEE
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542950; cv=none; b=bSZD9lYddcOvo1tYRJdhB3LeJ63AQoomNbY+F97ktdZ4Tmfd0CXAIZjjlnsbEapfjwHeUgzPKKsoKKMfWRAS+8zw6GJA0TNpZubHY7Q5lsQ78oLmv2+koO5YSXpVYcJ4PC5XLV4gjumfaGNBLXq7yINGUcMR9FyOdtVPAxML61g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542950; c=relaxed/simple;
	bh=fD6RBEjbeiQLEhxleRyQ7pUAp3bc4k787Xm1+iODil4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AYw5veNq59ylWR+0urlzskjQmtew8uMENBx1DJ5xMNVChsQx6Sd4mDbMyHeTjWTap4CXiuLOT9fe0yAtRS2ftfqPQMf/XMSolpZ9WSkp/hyzIqC8rFxRhBJoluTpkbFdiToAiAgjWYaL2Ycm9EBQUvPOIaWi8196qMyGF6oO/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lz5g2uLA; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d858501412so30096011fa.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713542947; x=1714147747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=daqyT7zApCbxlr3zmobtXVBppcV2XR4FBDBiuePwJS4=;
        b=lz5g2uLAwYoBDXQGQ8W59BuItLjWNxR4ZfQWRNXX+bNbc5ESKXXbJnw9YhHGCw9VfH
         cF3HjNeMmoas0dwMFf4GVVee/wVwv8Cg5APogRarG2pJTPKSF9usQ7Wk7NuQTnVRzHcK
         cce5KL8j3wkMhGBntvzi5rCaS2K9QvEmtXlKgxKGejg9v6InvUF8MQdwoOPSzUtqWGA3
         +jWbfN9VYkSg7V3tJe/sVBNRkr1iTU9kFnDmaDEor/+nxQKyvbb6rwoIs4bc53aVJkWw
         jHYBDAqF2w+ddWMc3Ioyetqu/O58sUcarV4iWEMaYusuErcA60JcFaiXgjI8aBviuPOI
         u2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713542947; x=1714147747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daqyT7zApCbxlr3zmobtXVBppcV2XR4FBDBiuePwJS4=;
        b=I2ZXmiSewL+zcVaN5PLztxNPIppj0ZFnozAciDWrfQ0w3S7IUYcFYl2D+SpG/yBfwq
         iSkAposPD7nT68WRNMPfoWVHGaK0+xyuvf8AB6MFNELlSALNXjsDXlP93Wdak6vS1XQ3
         gvgkq/2Ye3DDf2LIkCNJaI8vyrffpVlNBWdXa+YPZJ7J+Uw9uormVTE6cWesOslhQYET
         FiM8xrkW8y7dC5rbZSbQcLd2gvdBFKgNEru15ZHlqd7lOXLiQsrdzWWYxfzJNm9REziP
         molJuShTWur7DYNQFM6h7h4KWMlUzsmoI8oErLrHlTNshSzNlUh6USpTp0lFaasY4P6R
         CC/g==
X-Forwarded-Encrypted: i=1; AJvYcCWJHI8r/B8G2pbIoLm7FrZAkOPC6hPUXXGXMoz98F6mEWjFP3OSO90ro5QhZEBQWahO3m2lNykvE77WYcRDKPuvZmyO
X-Gm-Message-State: AOJu0YzB62bEgOLNBprOD54ZmZukdOCdKk7oYtIQVOoHilithvIbqdsf
	juXDPCgO82g9npqN5Vh6MymK4+HTs4MdF8t38Ia3YzjJel1Gtv9kFGTOURp5mwM=
X-Google-Smtp-Source: AGHT+IHIfRkAMq9ibnX1pcMi3UifuIQePzKavlVPmxU4AyXIEN0e2+KNpsf4gNWei3S0f6Kieqi3dw==
X-Received: by 2002:a05:651c:38d:b0:2da:226:d1f with SMTP id e13-20020a05651c038d00b002da02260d1fmr1581878ljp.7.1713542946496;
        Fri, 19 Apr 2024 09:09:06 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id d9-20020adfe2c9000000b00349a5b8eba6sm4799226wrj.34.2024.04.19.09.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:09:06 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	david@redhat.com
Cc: hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	svens@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH] KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M
Date: Fri, 19 Apr 2024 17:07:24 +0100
Message-ID: <20240419160723.320910-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM allows issuing the KVM_CHECK_EXTENSION ioctl either on the /dev/kvm
fd or the VM fd. In the first case, kvm_vm_ioctl_check_extension() is
called with kvm==NULL. Ensure we don't dereference the pointer in that
case.

Fixes: 40ebdb8e59df ("KVM: s390: Make huge pages unavailable in ucontrol VMs")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
Only build-tested
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5147b943a864a..7721eb522f43d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -587,7 +587,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
 		r = 0;
-		if (hpage && !kvm_is_ucontrol(kvm))
+		if (hpage && !(kvm && kvm_is_ucontrol(kvm)))
 			r = 1;
 		break;
 	case KVM_CAP_S390_MEM_OP:
-- 
2.44.0


