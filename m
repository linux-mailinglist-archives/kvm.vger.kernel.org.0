Return-Path: <kvm+bounces-59413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8B9BB34D6
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4561B4E1D5C
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9D330F924;
	Thu,  2 Oct 2025 08:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XXwEIEi2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7E8263C9E
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394581; cv=none; b=ZuILWHdR8KbRo2+8s0cYte512J2nZc0P/px88M1otBz6i+nYUyRnlFnAMfp7ylRBfigK8YYTyveQQ4PWIQMiuFxPO+c6cOxPUMe9NUccWiXdhO40wXdDEuxNElQ8VThPadxbFtopx3lDICHn8n3tRLKULT6QDXKqWAXmOqTARMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394581; c=relaxed/simple;
	bh=5neJ+CExKg9S64QJGbKqWH/FfKONuG1NTgGU2uCLmXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sWKLkGY4Rq22KzskdZPG1qLOzq/qEHzrxcjKkzd25mu/au3DQapUB4a/u94tq4Y7ws2YDSXJbBHcOSXU0zbjii00XJzsXEtCN1Z5LYDRRpFRG0ajcS87/7o9GHJXeiYEyn7T/GAiIp3IUKiaxDs8AcJlM1cOGeqCXP4aHt279nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XXwEIEi2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso5650675e9.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394578; x=1759999378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W71XKN8BDb9kJ6RH2tt1PLzXlP9jppatkbhtyR1OYg0=;
        b=XXwEIEi2TO0Og8xjkbKWHpdCJ5KLyKgZH6OceHKIzHhoPHOjrPGIL+X6F30sfe7ZEu
         v6zP97k7Y+4p7ZwYvpTofThKL298n70BTXrzyN4YueV5WvSGHHRKK8W+zfZ3ubv2Ee9c
         iag+n0PHlidvr4hyYOBIrH9FZBOvpGlptFCNoywT8uKU16a2ov8/y2yy5g/S44cgztPf
         lUWDhfmUr2Ov0wvsYJAwxr44ptCdoZeZiGvJb7UbmTOq6jqqDYUB7/cMp3SfFb1P3XNf
         8PgPBdUUrSb/8Vxk1qDnba+/Nftwu7LVGx7RUNCONMkaQ6aMtXW9ZQat3rk8JIQm0lqu
         55Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394578; x=1759999378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W71XKN8BDb9kJ6RH2tt1PLzXlP9jppatkbhtyR1OYg0=;
        b=NJNVSwnVlm3WbRg7rNZyKpRlDrME2jChGmn+svIgo7kQfjKE5VDy+BbeDMux9K18hi
         3Sk+M29p/BVYP9XyoQIQwv40Fj2raeWtLELqObf543pdnO3r4y5qbxxL2NwPEQQUMjnn
         dDNWDAX2vc603gPvMeHFrQ7N3JVQs3yFHybh2dZ8HcBieWzl4q5Y+WFQk3UzW4OoBPUD
         Uz7tPpXjETJX5FVATLfE6NaJj5Eor2KlY0wSqKYjmxjY2OEy0Oc1KOkvx+xeZ5yePIBZ
         0DyYVwSQTe07Qlm9FIYKZsQuIQ6xO0BCcjY/+LtDiRnopIMhehMwVHHQX7feYdfv2MMY
         YZlg==
X-Forwarded-Encrypted: i=1; AJvYcCU2YwwSwSo60FAREvr4skbHdGZ5z81ocubGguygLg8tw8qvYub78f/WUquGzhkxd969nos=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPBbj30a1Pu70ckyBRgvTgzFYOfTA6CDhcpPZdQ9YOTlsf2Rr4
	7eH59DUVQtD7aWqNWmjnYmyxO+BUp/McuzWIMybnmmQSe1aTSzr14J9LwGR1Go9tF2M=
X-Gm-Gg: ASbGncvh1jFpEUfMfqgoiLf69Hvonk9sSmLcWhcQFPlAB7jswcJ+f+42WubKU3V5dGO
	uxxWSDlke1DCuw+1pqw87hXRzNhssiikPAyB4EnQpl4Hr98EWVWikkt2yAjCS8zAgiicB/2mY+q
	vJZ2/y9J32AZdHsmVlxakwCeaaovA6g1BFBfDFsd3obBpyRevCtKhud2Hsjj0Ok+jn3/CtMjZu9
	bFVeoYEOEjWWDXSGOSLg4QFQvLRmw9YB5qi4KcOOv9Z7yHiem+5YUkoTHKwYClyXWxxe0Si59wQ
	LcYPpSQenFHLzwt/UJZGVzYOR8ISDhL8MIAGj36rDTvy2z1XFMhxAXObZKQsVR8CYFKrGvN9WEk
	jzCSdF+8zNVWknxTVSW/haqvTKSfh4T7aCAvveUOQ/gmfQIM82U8AMkfvDSMSpunKsT1LoCJlfC
	/mjDkgz7rfrPx/3Dg6mNtvHZC0bZauUw==
X-Google-Smtp-Source: AGHT+IF+vQnTZyjnghBewujCyKQZ3vteqHFK+eM/Ja5h6DC+kmKBchs84xyaNt6pAje4wwu2ECUb3w==
X-Received: by 2002:a05:600c:37c4:b0:46e:3d41:5fed with SMTP id 5b1f17b1804b1-46e6127cf3cmr49323625e9.11.1759394577925;
        Thu, 02 Oct 2025 01:42:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm71252835e9.13.2025.10.02.01.42.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:57 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH v4 11/17] target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
Date: Thu,  2 Oct 2025 10:41:56 +0200
Message-ID: <20251002084203.63899-12-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index ed424251673..2e442baf4b7 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -15,6 +15,7 @@
 #include "accel/accel-ops.h"
 #include "system/nvmm.h"
 #include "system/cpus.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 #include "qemu/main-loop.h"
 #include "qemu/error-report.h"
@@ -516,7 +517,9 @@ nvmm_io_callback(struct nvmm_io *io)
 static void
 nvmm_mem_callback(struct nvmm_mem *mem)
 {
-    cpu_physical_memory_rw(mem->gpa, mem->data, mem->size, mem->write);
+    /* TODO: Get CPUState via mem->vcpu? */
+    address_space_rw(&address_space_memory, mem->gpa, MEMTXATTRS_UNSPECIFIED,
+                     mem->data, mem->size, mem->write);
 
     /* Needed, otherwise infinite loop. */
     current_cpu->vcpu_dirty = false;
-- 
2.51.0


