Return-Path: <kvm+bounces-59037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EAFBAA505
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2182E1922899
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785FC74C14;
	Mon, 29 Sep 2025 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QwCEqFKR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD62253FF
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170840; cv=none; b=ZLZ+pUSDdCCnRW/B55aLjgrnKZlWTm1x7RYPKqPp8Dj1cZXkQKRHg/1/dcGr7kQbPOIrCWoEdgUT2HniS1bO1Aa9ZmDIet/pklWQdBaammgfwsA5iohZ8S2b4ARIU2NjHsf4HOc/MhCd3j0loGjZ91tva3/x7xaF5P4KDTn70ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170840; c=relaxed/simple;
	bh=cBk9rTdlZaeGtkIh1++S8TmCuoilFiDpVupramB5zDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PaPdaiaVF8o8GgP4lx1jpkY5gXqFg+FjFqbbk8it0ZzWhQgSjR3TYa1JHVyUL8cD6JW09gh6psrbrC3s4D10gygF0vP00mZKqmIAablynij/7MEC/WbcMrQv/DHJnUrPso3VqhO+Xt9NZlPQHsjgajSEQ5nMolDFxwMZ3/03ud0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QwCEqFKR; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so27495915e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170837; x=1759775637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=QwCEqFKRCSWl09WY8Uw0SvuwdqSTGrrJoubvZIi6R5uaCsHLRq9R+1ap0/2CtaOHDk
         sI6oyhCNycSQFpkHRQ1huz1ZUVwG/2zyJT3SFoN6Wm/rfZIHz6wW55+y6FD8vakckgFp
         VSUIXl9QgRZ/wOhygx6WbClHku9/LR/mdMlN04Kn+nd+Qd/MiRa98NIU5Q0K891dUOJ+
         78/Nhsz+cyy4BN6eqCaSklSYBUaJgbXJtncOvPOLxOkfM4Tyf5qvEj3vWMSbyDkH67Da
         bVu2Bp4cAT1aCX3Ss8pWn/oEi0jq/9SWhS0gunF0lFWFaVo1o+EezI0Ms1Drgqz7wLbJ
         Iwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170837; x=1759775637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=Fdh2fHudsgsUMW2g43bIONIV+BGYVEfN1WMujRSYCcwQt8XX/yNrrgHwyv8hNTow4O
         54D2OrYSdfII/rs6+VypCIEF4AcvzevivsY1khJEX5dmYW8Vzl9tYLXn/ZxsBjGPcG7+
         pgnzgw6iKdn4JO8Vmq8gtN/ztGibu1iPnijETRYU/c8BXZzLzhVn2/EdbQFwPT/FNbqv
         mrsSotzIIqjNgr5W2xbQf3ahaa4WqlsRDnQV62ENvLHd/OTgQjquFVT5pykIh+m1V7Rl
         67FgXl3oCx9BLbWXcciiawNE3L/66dJB+mWoLi7m2QdFP9dYJXrHvK5ygDpoqolKbuT6
         ssCw==
X-Forwarded-Encrypted: i=1; AJvYcCX2mDnLvEyK4piDv9mOhMJNe9BxR35Pj5yeHL7LtbAi1mX4pVDBDhwVGon7Jw8467IjYpA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/6zFpDi+hohlfSN40nk06aS0iYVJN8d815Eebl1J4qNgTSUmy
	i1+PyDV4fJSLIufnk+WojGCst9dtSYMlxpf10sYnQE/DdTlBpHQ51vcF3hAiHrj++IM=
X-Gm-Gg: ASbGncvSrAhkSdWgZN5GQAfWYOsukVu0wDT6lH7Ni0OfCFP6AvhK4130An3e+YNSipN
	NnIXj0sDfpU8qJlGRf9jkXU0qtWoKDqTDDGinNs0KUwX+8v0yEai5iS9CCufi1oRTDOSl5oKyKM
	QzGdBowMmPwDCVUKiE5uGeGc1aqNhfyjMAVgXjlBMi3s9mkcoCUkAwioo2pzBxYHOdFMe8FquHo
	EbDR6L66mtekymZpBNpWPgBoBmRcoen8gWi9jHp9p3sIMCL/bwV1TX536eAYO11ronIaRueptAn
	unhgXtmk2O5xDUGpqCwtK9sa/MLrc+3HSoIxE+guFvedcTXUKj25ZjuV+LPxuZe7o5n65zW0/LK
	WUwDp1E4jdqTb31gGVYhsetPcbhKST4S6YLU8IeWQWdiVbcuMMsuQ55c+fHKFVA8mfu1FkI5bS8
	jb+fhIjqw=
X-Google-Smtp-Source: AGHT+IFV+pWpl9RpYQY3/vKNUQDjfsPx6DQqux2wn16tRZPr0u8FrK0pJwBF+V9pyB/rSvhEdc2qCg==
X-Received: by 2002:a05:600c:4b16:b0:46e:326e:4501 with SMTP id 5b1f17b1804b1-46e329ba996mr129660275e9.10.1759170837108;
        Mon, 29 Sep 2025 11:33:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9e1bd14sm20127006f8f.28.2025.09.29.11.33.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:56 -0700 (PDT)
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
Subject: [PATCH 11/15] hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
Date: Mon, 29 Sep 2025 20:32:50 +0200
Message-ID: <20250929183254.85478-12-philmd@linaro.org>
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

cpu_physical_memory_rw() is legacy, replace by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/xen/xen-hvm-common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index 78e0bc8f644..52e2cce397a 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -12,6 +12,7 @@
 #include "hw/xen/xen-bus.h"
 #include "hw/boards.h"
 #include "hw/xen/arch_hvm.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 #include "system/system.h"
 #include "system/xen.h"
@@ -279,8 +280,8 @@ static void do_outp(uint32_t addr,
  * memory, as part of the implementation of an ioreq.
  *
  * Equivalent to
- *   cpu_physical_memory_rw(addr + (req->df ? -1 : +1) * req->size * i,
- *                          val, req->size, 0/1)
+ *   address_space_rw(as, addr + (req->df ? -1 : +1) * req->size * i,
+ *                    attrs, val, req->size, 0/1)
  * except without the integer overflow problems.
  */
 static void rw_phys_req_item(hwaddr addr,
@@ -295,7 +296,8 @@ static void rw_phys_req_item(hwaddr addr,
     } else {
         addr += offset;
     }
-    cpu_physical_memory_rw(addr, val, req->size, rw);
+    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
+                     val, req->size, rw);
 }
 
 static inline void read_phys_req_item(hwaddr addr,
-- 
2.51.0


