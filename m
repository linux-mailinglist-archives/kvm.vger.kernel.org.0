Return-Path: <kvm+bounces-59115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60332BAC00A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58EED1925D54
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B756F2F3C27;
	Tue, 30 Sep 2025 08:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fDO5jaTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D6D2EC0A5
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220557; cv=none; b=PDhiWgc2OAXj4A49CRrR90cvoREIi7AaQ+una2kXmBSwMm8tqUy6Ok2+8//OcFUnUj2fnDXq27VzvwbI3QyZ+dDboo6YqYN0mx5oHx51eafoepfxg8QUAxN+e93Pz1J7yXETbEC9xxFRWxQDVIaXDisZFeebTY4HtSyb0OuKCUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220557; c=relaxed/simple;
	bh=tunixSbJuiB73foP/BPqhxMl9n1OCdDtqenR/HYD550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCRm81uGFeWqb6rfQZonT6D5ib3RPBg25wlOz9lv9VIjTNQrdEUOlCYjQgosDtiDXEOl5sWfi6iPCaloCheOy9KFR+rzSa0Yx7C+4EGkby85K79EGBZaS/2HWI0BbzvKPebSXDGmAAJwxIOro690iWKy6Ajypee02WxTed+WJb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fDO5jaTM; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e52279279so14718665e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220554; x=1759825354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=fDO5jaTMlMIo1K+YZavTMP1PxMhiNXuq0rPbLrTZaqJWWwRMEdV5Wrl81oV+yrimCf
         Nm3lkG+6fDQe+TbcWGgDs48mgUe/wrdBAnuZq38c8zWHij3gcUqoIKQWe1BF/pQQDBOl
         58Wr78IgkSV8dpWHCS/Yo6C5DaBuvtitEyhHVu4JIGQ4x1Q8xSNekhT29QidCFcBjZ6d
         o5TFgfUBXFM6fjLbV89M6sRs27LCYKREidyQdvxVfYPgOPyqEJwi0hY+z8WR3rSfR1nb
         YTT0MnynQJ8jkTk6P4awE9RA5p1W4NCKgU1krc0gG3CUjgTKufvXFPCCzKXNatM+r7iC
         Shbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220554; x=1759825354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=i6LbFaB77JxKIQWhW2yxrzTawWZZq4unHHhgVs6dVHJa89UbSBUJ/HonqwbxDK0rf5
         Hhfdpuh32ZoNK5mnP9AE/8q8Wm4077f53HuuY1ZLNKgAVXJA3FAark/qJFtgXPoasycv
         TZKkSi4OvN7tYZZVby//9AXBuGrsa+ZE8CiTa3U4mSW7TSvKfRjCvolgEF/V5PD517U5
         on2ojakpehUF6StQ7uqjD0R+Gngd829LORwxbJIX+Ylymx5Sf5EgNPx3PLVMQ7KPdvJU
         FiFE1W9OCHd9Cg22p2t8obbGsLLWA7vUF67rPjKM+UMO1qS2Hda4+PFoSzERjkH+sGe9
         aOrg==
X-Forwarded-Encrypted: i=1; AJvYcCWn2m91ngPlwjigCkcZAR3GeKZuKQBSmhl29BP450l/CkM6K0vSdqNoWvetIEgHs9F2Ysk=@vger.kernel.org
X-Gm-Message-State: AOJu0YymeBtkpVBf8YohbuSrtazBLLSF7RFX2D/k6A3eZZwtptuZqv03
	wf5pcBsIAoNlk/bJSTagIYuW2TEm+XMEjYGabesz4+wR02Oqkaoio3hZtClQzd5h62U=
X-Gm-Gg: ASbGnctzr0tOi+vFBcdevenyFMSIzL/5ee3PBvNfdRrt8mROhelDoCV7L3AaszLmYTT
	nZIXbClwEs80EIE3igBWBeThOGqAA4WfGRjygViMRmvE9RAP8fdR20lWbkY+Lshq4WdniDPteY8
	FJdwGKWLEemE/sth8ixIL6WmU9taGwrwvdiXQ2zJXSVUekmT7KC2Uv5WHEXystWMmI2doB/37Kb
	kLw4gIlnNU881Yz8IoQVDpO+KOAhqTCtsxvjyvL2ZGLwSr2N494Gf4nQxZHcYJx5wuMVWqXp+pz
	v579J8y7/73WZBAbFqNCckADzX9N1H/xd0v1VS27zA4TuQ2UT1c0rSgaPlIH5X4xVLf7sBNU+wg
	q4Uwh0o+ShVFF9g7Uj2GE6izYP+smnp6/LbPY14AMp4G9ekQFC+zD9N2f6I2ucxIAydAyAR5vL3
	n0+u9GaQ6jkXml09eErIaY8NKdTqbFNdc=
X-Google-Smtp-Source: AGHT+IHFPJkofYr79h9pu+6ONde86qKMR3dCMR8GX+HG+gEgb0uWvZOFxlaIJxTQ7PTY8pGPvnTorQ==
X-Received: by 2002:a05:600c:81e:b0:46e:1a14:a81b with SMTP id 5b1f17b1804b1-46e32a1a396mr111982275e9.36.1759220554357;
        Tue, 30 Sep 2025 01:22:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm21775814f8f.8.2025.09.30.01.22.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 12/18] target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
Date: Tue, 30 Sep 2025 10:21:19 +0200
Message-ID: <20250930082126.28618-13-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
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


