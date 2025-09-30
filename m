Return-Path: <kvm+bounces-59112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2685FBAC001
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 090C619259A5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AF42F3C34;
	Tue, 30 Sep 2025 08:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k0alo+TQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFBC2D24B1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220541; cv=none; b=C9Rb1BnM+4vRv8yHxWeDaAGh3OdYXSYi4/8muNz1AlPKtPnF/pazXdIQwasuhqKGVslt8pY3239uDYWyAKdeOavTLgQzkDp4PQjIfkJiAapeBSh2t5YjcxmBgLp4bynvsBrtrttkuVwDCQWE5iLLERXSaf9NtyYoVqwdNO0zI2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220541; c=relaxed/simple;
	bh=14EPjcE7tOqVGCH1gxVaTyLIZkttry8fdyNBW214KMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nCy31G5Uul+etsCx2VB8wYEces+G2xYb1kbnE5SG5bXrB5V+OePMyyHhPrQJdtzRKEYnHWG6tyuQCcBD3HIT/a2EfaBs3bfy+8FmjTMvoO+f004R3jxNLCygHS7jg8mGuaOwtcVnaXjSyyfzdeBSjgu/B26MGFB+0So7CkUwaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k0alo+TQ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e48d6b95fso29884145e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220538; x=1759825338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kEeDKj/VliAI89NHWLpYrYcoI7vlOg/a8aX+CJnHKA=;
        b=k0alo+TQmtfz76g57IPcR479LVEwyaRyZoK1k6wxDpTM4IDj69Z0TjkcpiJJqS7Bq9
         Uy91/lI3gSPa3RceeM4mI7LagpfMU53aNffGiywJ9CzkpLeIYsQJp88tHfK+lDediYOd
         HXt1trm/fko6sqvVcJuUkjRz93jtIvElV0v+hL78IUseUdCBRnJX8a0sxB4eo12nmx6E
         m5dc/EJhboxLmfMA2vEWv7NZPYDosfT2HjFvtMWd4CQe6uiocKRZFxnItmzFo87W6VGE
         MSEqePqHFusvRqu4387nOewZ7r1CQcRiKD4irnod+3xSMZ4Rznba0S3WTJskRE9PTPDf
         AxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220538; x=1759825338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kEeDKj/VliAI89NHWLpYrYcoI7vlOg/a8aX+CJnHKA=;
        b=qDNoGxYC2Kpj5RMFSIkISYPp9JlizrO9ttCee74MxvyakGR762rnLi4DmWMBSLg00r
         ihGAse3+hpRn229ycSxMt2Av4lMxrAaOrpCGMyHV3fRTT8WueWDuXYyfsVYBX1OJJiQz
         iXNeO2aqARvVUYI/cfhrMTopPuE2uLoj276ExXqidrPPgafw8/cf2cTmrXRqBU7GSnmC
         cqrPTJkHqKYcykxCPkiicSE2IPNTwHVKO4I6JxX0AzIXZCDUYRtagImStPRDmkR5xiHI
         uSBPIwiX4jl+r8iV0h28bIUmrU2G07wgCIlWHg3RZ2p3KBNbi/smDSlx+lXxRUu6Y8wJ
         uUVA==
X-Forwarded-Encrypted: i=1; AJvYcCXAfqQCKhy9uaed2lQ77/XpScMCD2jrl1T9A0mdiS9Oje4Sp4PROoe4jRVVNSn2M4HvndE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO/RlMZueIbo4ChQ8dFyC85cPQcyJhl+qIS5VBEaKQMUueEp4/
	eLP1ye+epeRbx2PgpeUucwHDZG8Xp7UjujZhHr3TrxEzKupngLngA9ON+VD/Uu0zwsY=
X-Gm-Gg: ASbGncv6JFSxyrLq+V4uIWyWOMK3B7cs2tL+mz481U2v2Z7NePG63slRP92XCHNhw4O
	ZuSVklTUWROsxNcwBvxW1EALi/Pn/I+UHDvaDMzGQ1PcTSko3k7W6CP3KovVHCQot+/FXpfTPou
	XGGtKCBhIt4Zfk5kdqJyIER/8vfc9yM9ZYM3bDUuLHTDGQaAF+3nfRB6X6pU9QTZEmhYYB0+GOl
	WUwEXk9oMqRNW+iIJJ9bSA2sOr5HX2D9ugUg6QTAqP0lFlBVDtDQSRivDWtAA/CI7/5aK3MOTLN
	FxOrftjdj/rluO3y4WIHuxfF4PptmQLbiPJ4Aa9HYHiG+3zJV1Meh2QnvTNlnOfsYR6Ru+7T5BP
	rw4xYX5H9J3F/0lluPSmrdEXhwNvu0X+4ws2cdjcLrc3fKhGccj/phSXWxuZrIDXi+d+OwlMR83
	uCxM7BROt/vEoGZvQDK1fhuaUVMa3gpzo=
X-Google-Smtp-Source: AGHT+IE8kOnIri7d9kIT89vkssg0QjxuyhNQyNkBu4zqQAFaAaCY/pGZVE1XfJtvAVhQrg/vBoJaIA==
X-Received: by 2002:a05:600c:1386:b0:46e:1b89:77f1 with SMTP id 5b1f17b1804b1-46e329e28f8mr169270875e9.9.1759220538270;
        Tue, 30 Sep 2025 01:22:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb871c811sm21599810f8f.15.2025.09.30.01.22.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:17 -0700 (PDT)
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
Subject: [PATCH v3 09/18] target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
Date: Tue, 30 Sep 2025 10:21:16 +0200
Message-ID: <20250930082126.28618-10-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_rw() by the semantically
equivalent address_space_rw() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 target/s390x/mmu_helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/s390x/mmu_helper.c b/target/s390x/mmu_helper.c
index 00946e9c0fe..4e2f31dc763 100644
--- a/target/s390x/mmu_helper.c
+++ b/target/s390x/mmu_helper.c
@@ -23,6 +23,7 @@
 #include "kvm/kvm_s390x.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
+#include "system/memory.h"
 #include "exec/page-protection.h"
 #include "exec/target_page.h"
 #include "hw/hw.h"
@@ -522,6 +523,7 @@ int s390_cpu_pv_mem_rw(S390CPU *cpu, unsigned int offset, void *hostbuf,
 int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
                          int len, bool is_write)
 {
+    AddressSpace *as = cpu_get_address_space(CPU(cpu), 0);
     int currlen, nr_pages, i;
     target_ulong *pages;
     uint64_t tec;
@@ -545,8 +547,8 @@ int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
         /* Copy data by stepping through the area page by page */
         for (i = 0; i < nr_pages; i++) {
             currlen = MIN(len, TARGET_PAGE_SIZE - (laddr % TARGET_PAGE_SIZE));
-            cpu_physical_memory_rw(pages[i] | (laddr & ~TARGET_PAGE_MASK),
-                                   hostbuf, currlen, is_write);
+            address_space_rw(as, pages[i] | (laddr & ~TARGET_PAGE_MASK),
+                             MEMTXATTRS_UNSPECIFIED, hostbuf, currlen, is_write);
             laddr += currlen;
             hostbuf += currlen;
             len -= currlen;
-- 
2.51.0


