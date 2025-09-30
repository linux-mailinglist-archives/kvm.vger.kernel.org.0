Return-Path: <kvm+bounces-59111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9867EBABFFE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECD303C5877
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC4C2F3C0F;
	Tue, 30 Sep 2025 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x5n9rQWE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81E72F39DD
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220536; cv=none; b=seMCRadDVaKQQtX279/c4VYs8Rv4UNdTciMrwqUrYGsoSt6mQ41egi0aQNwf6+7D98e5F9EWsDuR8XSKt5CJjW7EAZGsjz+JZxEPqScJ7Uqh4hqEi/gMsIR9hy2Hir0WszPfxFKC22FQ656WLVBZDGMOtsr3umnksqQx1l02cwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220536; c=relaxed/simple;
	bh=ILk25pgs+2L3zaW9Ll7hF2CObVliCznj31PA0VrdGMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTUOJKB1cmcb6g2v2AA0GsjIDkz3NflDQuPfTbIaPZPQzX6G5NfVohIhfJgMhsQ+cBPibtR9v94/nJVWFjbiEceqca1JxvlHH/jcETFuIXG+ms55ZQqqy0UuLUOVD0l1bFMrHtRGqxZ6OVYrDsuXFvXyoSe5TfTxWK/LlAeMr+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x5n9rQWE; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so32107225e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220533; x=1759825333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QFdShgwZbpOIuoiHkRuMdwMlUbV145lKXZsf/3KvUE=;
        b=x5n9rQWERuz9f/oHDa7TaucFxD63SjNgN8vYnv+lOHeux6FM/isl349THovgGi21qz
         XyfJfEcoGDJGgaGvMtQIa/rCKpcguHDTleIeSQMMNPFKyDsLjrUNdiDB0xU08tYCj/Zf
         RgPu1SitYPtzWPdT21Rft0+96hMEwcMwiW4hSX1Mfdv+xH6lwgdVcHcgUrwGoEaHZPAy
         BzXIL3u/Fl/F9s6NIvIK1n1nUFeGVUDO3U9XgxM8so4nOhPjQ5xVpGJH+v2qzGI4DAA6
         QDeNNInYiyE4NG/5+QKYsLzDEEL/uwszsvGEWgk/PvvT+AL1MrA+SshwReHCQlt4FfVG
         ZETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220533; x=1759825333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8QFdShgwZbpOIuoiHkRuMdwMlUbV145lKXZsf/3KvUE=;
        b=a3hTJpcOio1WQWFY3wgZxjJgglnzHOVlooAdBEjgQIIVZ3gurNi9BqUSb5Zq0NiyFY
         aAQYU333mz98wxP1k8md0yyQs6WLLKRtabpyGqgDXeLcwiaCElstxOtrVEOSanewMCrb
         I7e8A6RJCpaKcmLlA6vfzwHIxW/1SBwb51XWZt/gwzpKFoYrllLKfM3zvghIk/5DgaiQ
         Z39MG3Gwh2bsMNvM5L9ZPz/3UhnT1IeVV1waiagPbKFg7qV1UTITOgqzW8YeeV83LKKw
         hA60wwinKBlwRoM7H0Y7RO/YNkpR2iLn/UzHnLQFaOwmpnWAvSviG/HAgE7V2ial0/cP
         TRRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsRDj4M8GSwRmGr753rSpBAnihLLGLvktd6sI/8GmQ6LpcKGyP0QWFl1RZSjxhcbilaRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmDzIje78sn+UmSX1EuhUT43k1SDoyoHa0ZvVQ8WYlHXwPUV0I
	QkcGDBGKi/3C4VasUp7o33LVIXodKHh5+A0Xx1QrKlboT8C5y3lMpajJ7M3/oFLXKqU=
X-Gm-Gg: ASbGncv+wNQf48rsbWD2PEaGDY2oryoS9cpB6b3tAOUg8UC2NU7qbrGAM4PNaZ8oy1G
	Lv3n4YT5RZDPsMU2V28PAgHZuWcgBxbpanUMhYU2a/lzRFY9LLUqf36EhDQhQ6mYXx6T6czFSMJ
	0IYdW+yI4Vpd4PSh1SdGkL9/KRUbYYyPKJHwUEZcoUIdJ1qrQCEZTY+dn3UohoyvNpMKGr52ek+
	BzQJK/YpyNYErLjgg0XlTagbFz0j7CKmoJI77XCgYZBrFFZXikdgMyXCFm0iNPTIjmhgegV5fGk
	OszzrZKgimN2mX/AdbnSG3S3L5UqM3s26wltoqJWt8gkT240/KDUXncJE+kYf5tw5eLszQ6h4wp
	TtPqqavw+/ExV9UL4sDYpwFrgmTCykpAPFRAKV6W5mzJMxBxFwprO405J5hkpc6rxJsaYT3WQ2d
	LkCR3NhruMNtcaexXtX0ofOmnnuUPeQi8bDwH+lEaQbA==
X-Google-Smtp-Source: AGHT+IGBMYpWSXfOX3el6uig3+R7ujcKxPeYiLaNhqcFnuUIbzB/w07fZP+NVrmJYAyBxxupmR40fA==
X-Received: by 2002:a05:600c:1d14:b0:46e:432f:32ab with SMTP id 5b1f17b1804b1-46e432f395cmr126597005e9.33.1759220532938;
        Tue, 30 Sep 2025 01:22:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c4dd9e4sm7814745e9.10.2025.09.30.01.22.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:12 -0700 (PDT)
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
Subject: [PATCH v3 08/18] hw/s390x/sclp: Replace [cpu_physical_memory -> address_space]_r/w()
Date: Tue, 30 Sep 2025 10:21:15 +0200
Message-ID: <20250930082126.28618-9-philmd@linaro.org>
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

cpu_physical_memory_read() and cpu_physical_memory_write() are
legacy (see commit b7ecba0f6f6), replace by address_space_read()
and address_space_write().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 hw/s390x/sclp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index f507b36cd91..152c773d1b4 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -319,7 +319,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     }
 
     /* the header contains the actual length of the sccb */
-    cpu_physical_memory_read(sccb, &header, sizeof(SCCBHeader));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       &header, sizeof(SCCBHeader));
 
     /* Valid sccb sizes */
     if (be16_to_cpu(header.length) < sizeof(SCCBHeader)) {
@@ -332,7 +333,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
      * the host has checked the values
      */
     work_sccb = g_malloc0(be16_to_cpu(header.length));
-    cpu_physical_memory_read(sccb, work_sccb, be16_to_cpu(header.length));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       work_sccb, be16_to_cpu(header.length));
 
     if (!sclp_command_code_valid(code)) {
         work_sccb->h.response_code = cpu_to_be16(SCLP_RC_INVALID_SCLP_COMMAND);
@@ -346,8 +348,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
 
     sclp_c->execute(sclp, work_sccb, code);
 out_write:
-    cpu_physical_memory_write(sccb, work_sccb,
-                              be16_to_cpu(work_sccb->h.length));
+    address_space_write(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                        work_sccb, be16_to_cpu(header.length));
 
     sclp_c->service_interrupt(sclp, sccb);
 
-- 
2.51.0


