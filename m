Return-Path: <kvm+bounces-41101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E882AA617CB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75C5E16C3E4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B23D2046A8;
	Fri, 14 Mar 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q8bzBm31"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F368D2054FE
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973523; cv=none; b=cyfS3Ir/rgvZ+VBWfmEbgX4qGeH0ppYNZqEDsZaGijtUm52XDzp2qh38yIY2oEBUrf4MuvGQP+zrJkEnJok3tYMWuVnvTtrbr/N+p2vcfKfDAbxbTT/Wvpb1YvKU1KZeavMvlHNwbS6Xs/CFmMMX2GH2C8Ozdo/Ap4Rvj1pnQAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973523; c=relaxed/simple;
	bh=HWCRrm0GaxX14ykibana2jy+mNovavf3Va2YjCViNUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uS+TR1aL7oHPXtuxeS1fwdeuttygXNXbvPJYrPy1ydMChqUzCzGqBFa3txoMxEDct+cvPDTL/5hp5uR3wLXI1v/eps9To21P2e8OHErj+H51ffC7I+z7aB/b/dvgP9ZerkU0Pw6A7Pn+rj5V2gDGEHHg4jbETz6zMmIduZzipA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q8bzBm31; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2243803b776so66984465ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973521; x=1742578321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=Q8bzBm31jlvYmQqSurbPKvsKq9DwSx1C2O6J74AfDPNQS2SFxaaxoU42edYmlVtGc+
         RIi3NtftAz93vlBHEbxo+nPZ9qHGh44HFam6j3e6yhk5gQkJhOAtcfqbDSLpuXXvlnvw
         e4X2GrscKinJ3jMpozLjUsjvtVUXPUgf7anFrI3qObyptc14zJQUlBAYuS8gfTAgFCvg
         0xiOwjcsanZv+AtZYRAGGzVuzA7E7uQuUpG5YgwmuhcNoylVwLf1DVE43yjBP6ut43sk
         EJBrY9mC13Gvm/KcJ6oUXKJ8iA6J+ncXjTwxiqiQm6OmhzpYM08tP8k0TKlPVrVM1wfM
         nD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973521; x=1742578321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=cm6MFS8KuV5gF77Slk4qlFtaOX5npPMUC7QZBUhnsczZCrbfJeoz8ASvdM8mqItfKZ
         OOk+izRrEJ4MKE+/yo/HVtB/6pPRjnSmgQq8tc6g5aq/i6L3tJg3gjr3gFWChbqC2vvv
         bmJb5N8kPO+cFZTQL+AUZ9eW8hSA33Lgbeq1SYipmC/FgXdW4Ikm+lkB5LX3JLrqwMP8
         s6PJ7NapgnKuGnhi7K2ZlAmDaFjwmweHlv+k8GO3VHamFh4JMJ5LKz9P294vkvVtRfp9
         d0tpp7mJK91KlqfHG+aANCOJq0AGuliVRyvllttLVErTpg35Kt7SOUZ39bhY0qJ3bm20
         a/bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrq5UninADUlTvoC4iU9x3vHK07FkaUcbR2tIvEr9gvR91MHvchROq593yWsY58vHZq+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwStHCoRuraaNnpgcZUPeSHAkNhzscNMNQC1y1q3lHA4CXMxkRw
	e2ju65beb6s6/OPTs8AdPfFuJs7M4F0nubS8AKhnQH5w81Z5uQmMY2KFMwekzSE=
X-Gm-Gg: ASbGnctRx3pqzGiYGd+JYnS0z/angc669FI9UQpayYSN5vm+x0Jm9lHkvm/L2wDiud7
	etV/PRhzEhjzWR0HacEsVyf83IaFrv/cOWhfbBIoIUEIdJQiFHfrkKRFHttUQWyKrtKPO7w0t4f
	myW6qnATUJfa2AOUtw4tz48fq5eR3xeoiCMZdKSHgrQ+nQ7DBI81j7v+5WKUd/n+Pp3N70TexpE
	fRNMp92pv3DOHOaSFcRqQBtRoUknVEhsERixNI2O3plSyg9MAjuQy/e1gANXfuC5wmNqNTHpdxM
	cEOIxV0cywxOwWXC3iluJOmLfHkeQlAuCFHLnZ5nkNpo
X-Google-Smtp-Source: AGHT+IG6cCxvjsVBwzL07VH+mus/++8may6iqII6GPehxKvNj4VKnHVcl4393YyfiqPTiVq1ksSu0w==
X-Received: by 2002:a05:6a20:9c8d:b0:1ee:efa5:6573 with SMTP id adf61e73a8af0-1f5c113f552mr5261243637.8.1741973521265;
        Fri, 14 Mar 2025 10:32:01 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:32:00 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 14/17] include/exec/memory: extract devend_big_endian from devend_memop
Date: Fri, 14 Mar 2025 10:31:36 -0700
Message-Id: <20250314173139.2122904-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

we'll use it in system/memory.c.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 069021ac3ff..70177304a92 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3138,16 +3138,22 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-/* enum device_endian to MemOp.  */
-static inline MemOp devend_memop(enum device_endian end)
+/* returns true if end is big endian. */
+static inline bool devend_big_endian(enum device_endian end)
 {
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
-                       ? target_words_bigendian()
-                       : end == DEVICE_BIG_ENDIAN);
-    return big_endian ? MO_BE : MO_LE;
+    if (end == DEVICE_NATIVE_ENDIAN) {
+        return target_words_bigendian();
+    }
+    return end == DEVICE_BIG_ENDIAN;
+}
+
+/* enum device_endian to MemOp.  */
+static inline MemOp devend_memop(enum device_endian end)
+{
+    return devend_big_endian(end) ? MO_BE : MO_LE;
 }
 
 /*
-- 
2.39.5


