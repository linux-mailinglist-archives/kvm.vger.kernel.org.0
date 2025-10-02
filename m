Return-Path: <kvm+bounces-59414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 536CABB3555
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1C5F19C0EC5
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8042D47F4;
	Thu,  2 Oct 2025 08:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WWfaMRUy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FC32FBDF0
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394586; cv=none; b=XSsnF7QKYeRT4qylH0qULjRmnmOnu3TbB4OXJtTrMA2RdTooIshe/0gvfvUNVsFyL86F84MfkO19XcclxSDJPXTH3osdWZLqB9bIdnZTDGFON4S9/dmdaoYat9jZJ1JegcM50YwbjnFGC4XmAlKBQHjhhtuwUhIjHf4o3Nxc8Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394586; c=relaxed/simple;
	bh=iDq0pa8OE6fWdyIxjwqrgkihtM0fk06trpm/H0hKRs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xa3rb0RV0EF5y/FKR62rqfXzuJVXORsn9kb4PZJ038TFBduJifhJBJw1fx/DlVVe+cDKcdBKhqsxDKTL2VS3qMoxwsKbb98x0fD2rVvHk+nQy4BbIp9kuYq2KmUzbsrfL5U5/1otZebt6xovU6qHJ5FZohbgY1c0z2m9I0KxxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WWfaMRUy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so5786495e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394583; x=1759999383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5PC+1TlVBTyXto+jnsJwdDvPaPiKj+lxKbw9om1DB0=;
        b=WWfaMRUyX4eLNP8yweYgXQw8ok2VDij+n/mSm908XtMCgvYezFwDk8P87lts6MUOhR
         +JEtOsGLB5KKjShe0hkaP6Oi4pKspoXogeW9nX3T05fURkPSk1aV8+AQKx1Eyq+dDWIY
         YODvuJAggvKLnLX4S8vfyc295UJErFconKD007I6MPDyvK/zoXgnWftf2bgoP/INOv/p
         fifB9b/x3iDW6LZDpfwEWiUdXDVD1LagswFeSJwZvAaGVCxdZjh2/QlJd8tSkWlbY+1z
         v2Fpnwo33EjW2PXnAE44a1xpvY3TCB8zY5rJcO+DjLUwmd+LJcRp2W5+nmH+N0vc+kcM
         sIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394583; x=1759999383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5PC+1TlVBTyXto+jnsJwdDvPaPiKj+lxKbw9om1DB0=;
        b=EeZzNVLYfSe3+iSMP0C/Nc+nTfzJQNC07o2ugOrgF7evR1LAtru/GaMvKKFNsAWjPd
         3a1HFE/MHkkZGjxvVPWJ5kr5KBhvs/QCEaNdMEJHxjqsU2GaDYX6xl0t0R+aEweZkdff
         N5I4D5dlrpfCGgIVwt9gV7p/oSDWWm0HSZ9eTaKzmrvccD7s3/oCpkwK57PQk6f2FGLA
         6/67uGIZUHNPo8pVG3UvJ5B2RHKXemaL35qQIG0KhtGmE52FMZvKafrg0F8z2bGxH7db
         dTeVgqdTf7ksztlNba426g2F4+heOmwThueGQ3x+/mdUR8Nz+t+cFd33VxQv3x8PrpBC
         /fDw==
X-Forwarded-Encrypted: i=1; AJvYcCWhl3pW+jMclnOoGiO4suyHsZMHHLSzlNS4vqxFNL85BizO2V1NlsGp2qVOIjo7GuiT8qs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwnXllef0wX7JGI0gppJRTsMCGZK+xkunmi1D7/nkn0aLv7UZG
	lkXeiUJcjEQrrBKEerJfHdFMy1DTLfbN6Cjh6DFocHUtXKHA298O2otMt4CXu+z28YzJ55CWUKi
	9Sr8uKCoQYg==
X-Gm-Gg: ASbGnct4ALxdKBcF6/Z9Ws3dkgRs024yv1TclSOY11OV+yafiixyzPcwJwk6ohfTVcx
	cbNOpf5WjbiztBmPosbPpgqY1ZSo9X8wEF4tbx2wnvbV7le8aOijRd4pcpQEd3aO2cZUG1ONjb4
	lreIVqhvZ6vS7n96btOqVkfiJbnFSwXrBCc4hTD1WmOpVDj4HsV9JKFF9bNyd5XX/Wx09VgYFxj
	5ZCzfcN+vgl6EEDxUW/eG3OYYQ5ikTIODm0r5GN+N0KMmaVLYGt5o6XtGIRlXZQp0G8+gBIvacj
	dsXvf4xDHWBwbHOcsqqeJOn/9n584EzczTH+RwE6/HPgEyfJ5o8/sunAusTbduZWwsVK6fy9VRA
	F+4W5OyXlPW0V12xvu5GzJrMGlCJUTvLZzGI4HGV7q6Ykzg5WENftIP88WOf6VGxTtikQhKb7Z/
	XPMuG/edJ5g6vwC3+VjIFo2R3cX9Cjww==
X-Google-Smtp-Source: AGHT+IG8Ma/4I60woYQn+sfaatxOnQXHwssxQgt8liAn1/sRa9HXbIzN6+J2l9ZCi0NeEjgUws6OFQ==
X-Received: by 2002:a05:600c:8119:b0:46e:4883:27d with SMTP id 5b1f17b1804b1-46e6128617amr48211715e9.30.1759394582729;
        Thu, 02 Oct 2025 01:43:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6917a867sm24739885e9.5.2025.10.02.01.43.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: [PATCH v4 12/17] hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
Date: Thu,  2 Oct 2025 10:41:57 +0200
Message-ID: <20251002084203.63899-13-philmd@linaro.org>
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

cpu_physical_memory_rw() is legacy, replace by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


