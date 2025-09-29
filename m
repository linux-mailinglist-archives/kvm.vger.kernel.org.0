Return-Path: <kvm+bounces-59036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B226EBAA502
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FD1219223A7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AE023C51C;
	Mon, 29 Sep 2025 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="psctGaiO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5504C78F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170834; cv=none; b=Vs3D/kcAYrAS6EUjUvBhCK7KsdEQ9U8VZ6XGEq+287ORNwPcZubRTkv3EhCcD+7aY092vw0d3flyJvznZPjBynEYOaNcQhorBQfmcI2vQSo0WIpT4A+lDrn1YGOiha75Z5b60f7V+9uybsOYd8hOZnENrpcwJCPa7Bkbj2EAM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170834; c=relaxed/simple;
	bh=tunixSbJuiB73foP/BPqhxMl9n1OCdDtqenR/HYD550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kU751zCB1DeBX/pxu+AE00rXOG8Kalub2ZSkmMRulS0IpIDa9nHQlOIAYWwY+6Zao7p1jURLz3Cayp+NgLEYsdtwXUKdhwD3Gek2uVoBK0ANl6vdqqbru755Eylx/6ozSnd5Arcaixi8rup8TaV0/PmL+mkeE38Cfem2AO9mcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=psctGaiO; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso3072775f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170832; x=1759775632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=psctGaiOky3mqkwdvOGlxBhOmKixuoyAdeWEgBIVlxQWt+8qYwHO9W8bMxDeEJkGY/
         m8Iz6prMxyjIWEpDryodEB0qB7K4sIzRb/NevzIifnp+04xgmsmEVE9OE/tF6c2sBG3E
         qxkGlou8n8qD634uUwrGxjAOHwcRRJWVjDauL2xic1zx29TBJuJKRejXwicG6OjD22zG
         DCK4yKwj23EorFjPsryc4GDEF7IVCu0tVVqUP4QS4OCEiIlFJvd8irccNEkFUDRYYQqt
         TeKahUfVvXO+5iKk2ffX/S6vvI9VLA+M/0irDDUL+nye/FQhPJI1ZYSBl89h+7zyq3xw
         Ok+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170832; x=1759775632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=giBZ3WRx5fQXYnz3zUCghluXeoXIzI+XApoewtQUdW4IN1byxiNVbq+bcParqPZUzz
         cSiyC0N1UlX7NEvab4TZZL5PRLLT2mtGTbA52Va02VDJ4OB6z8u/Tzf6WXfEEPfmq7l4
         surnQ5Z+4O+QiNtp09AOWn8KOMJb2TGbKa8Oqg8YhS+LTuKuWUC/PxuWaNIiu3lrmi01
         uR8MF3+jKBEDH/6iiMZPAZyqxfLwQvkNY4WINRJVinTP1f9IofLOCRBeSNtSp5DFuRvm
         nPeiUF7retgRZDVg/dMb31ma8gCt1PG67qi7oeEypJLQ69Lxr488JzgnefkTEnjMwFHA
         OFiA==
X-Forwarded-Encrypted: i=1; AJvYcCWCOAjdKr6l1mayUrAbPtmFzYDreq2ilHqhveAn6+eNspzV8G2AbwqSqdY7Ue09T9hpc1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJlQlSt6KiRc41Koq12RyC6Vru89c6qLrTiVgexXxYx+pgDqH+
	fKThovfLT6QtYQKHxDu64GeqtSWV5Saanu8HDqfgJUX6u7H7jr2oUpAB1r5EW+QCx9c=
X-Gm-Gg: ASbGncurBRKqJHljxyDIGIQ7ltCHzoFNVkKSnUQRZHd+Pzo0HZ5Jih4+mS1e071B6+Q
	epBdC1DIeg3sKJ5Zklhqvz4XNHIBzzIu2y8Fw3OcqlGwanHpQRgfw+6zs5K53mMZmpFsnu+sMYu
	icKEKbnmGPmEVqKHV2aBkM+HG2y5Es/G+ItsRgviT4SHOXb3EKoFMOjvByON0iVx9HogxADH5v4
	4Mlq4qrNmjdtG6hZ/Gt0dpz9vnQArBnnxKITJBdFtUp9P4vnHFl7rZHu0Wu7mNNdJbPnZ/nabJZ
	i3TelVi9fZJSRh5+DrcfaTnjLAJ4FPMSeDBG3DqAT+lX8/EbFbI7cxPpF+mQIZd0j3cM8K8yFa5
	CwdkLA34pUyXNHaJcRtkls7LqP2Ob53h6YL6aXckHgnA4V39v0O40ivnieQv0iff66VFmcU3s
X-Google-Smtp-Source: AGHT+IGjnZG6/qjEBZy5PcjHjXj9r7KBUUors89ckyudEmcNpuheEZ9krTQTynjT1eMge8vskVxhUA==
X-Received: by 2002:a5d:5f83:0:b0:3ea:fb3d:c4d1 with SMTP id ffacd0b85a97d-4241111f6d1mr1595433f8f.18.1759170831738;
        Mon, 29 Sep 2025 11:33:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e59af1975sm3031215e9.3.2025.09.29.11.33.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 10/15] target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
Date: Mon, 29 Sep 2025 20:32:49 +0200
Message-ID: <20250929183254.85478-11-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


