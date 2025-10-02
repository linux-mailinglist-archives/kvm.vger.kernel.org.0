Return-Path: <kvm+bounces-59409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEB4BB34C7
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC49F7B3FA6
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19494312806;
	Thu,  2 Oct 2025 08:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RE/YbeZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4542EBBBC
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394562; cv=none; b=OLanVT7Ui3vhfhjTGUqwqTUozgZUGUmmc/mBZaNVArtaVFPDerTN6HQ82+bjLGplxsCyaayg4YlSDAJyO/JVhWyyGNSUxfN6h1OU5nM5vmqlLJgzkvKv4y5x0uFOUtrnZIRZxGT3crLIDssdufexZ2x1j8nePTg2HOr2pFSK0Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394562; c=relaxed/simple;
	bh=4KQuyVM1ifuPOlDiycM2v6hjmwR/h0J0hF18SoMCqII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dl9DqCngvxbwc/5ZbecMJnnifwYI8VwuD6aqT2PW5AcI2PpLiSyy8o5xV6UW9lVaShCALMBQVYT8o3nPNPJJPObpxyT/DH1ugWoywhM1fiktwgKRQxwXL97PAE/dK9vsYY9eBP4GR42uYmc5eaK+qTdQfMVW4f/IvlCRwck7HVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RE/YbeZx; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so6477225e9.2
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394559; x=1759999359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPyvtamk/7TWz3NLD4QWdvW1Is4VocR+bm6o/kbYsjI=;
        b=RE/YbeZx/a7vm5C/YyJa1ILJX6GGMJ8FIGxki/5eiVJJVMOuIBBWKHiAw8BF32Zmoc
         jb4mUkPvd81IQGmzJzfftdF3UHf6I+l6U9VzO2MNDPOn1lfg2vxhlnmxdcCq8yUqnpTO
         8dEpoGFVlAqByGeNjcC+tPc3iFSfqMusqRBNiLK49qWxIFUrWtJ8LwgBcZXCt8VYkrZY
         YQWTkadUGW11bQH18KviYbz/8ox0mSQzrjH7KguOKSYFsnOujg8rsz7yjMWB+mCYQXKu
         SC4orGnKqAQmWtdQdP5MOQbzdPe88rGW7Ur8QXQZ+XjlO2y+ES2KnGumJvYf7ypAIqgQ
         pCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394559; x=1759999359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPyvtamk/7TWz3NLD4QWdvW1Is4VocR+bm6o/kbYsjI=;
        b=JVZftd5neUS6pEW4cyvuiq5eBbFAEd23p30fuvlaTmgdo+Sr6RFjwIfL9n/+IHtFpV
         vUEbcB0CIOBxztIa/XVjyGuiXIJcONEI33rd6fZcMijlfy2qk4uqlyoWlj76t7A46wgr
         wBfuwHUpT+YsbEooHEsmdKJWszFC75NoEOS+BOFP2wcfnBkUCWhdGQlBXYvMl0A5L8CA
         NxphSdSUg4LveygJO+pwd6Z7um5WuwZD0jASNUdRLSZl+2it29p5uEXJZ/Efy6o7SDav
         o9sOoaktXzGg7JSHp+O1Fpy0pX+0XP6Lzpb8aOZx/9rAgNTrlaqyNm3KYVdJnp0rJPyh
         fG6g==
X-Forwarded-Encrypted: i=1; AJvYcCW5TzujJvYsWV5v4gq1jt87bHpvzPDk2wNsCU5FVSlz/oW08LaDWmutBsVgrG945ZuabKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX3JzSozejiX5DjfFMA4WQTIQazj/iwKHKfsc22pf5OqnZZgTl
	HPshxh9496v79pTrwGhjv1YhVN88ot26IyROcAiBvHsrerP65rjKj2YB7VZnU21BYCI=
X-Gm-Gg: ASbGncsVa9r6jSvRQ9FL3V/dgBsj5P1iuXIo13LywaIDvoMDV7NdV2Waq0k0TvO91Mg
	bTM22VxRTAdtl9f2+fFH/OYHYdG40NNlKfJ3mjSR5TfKaODpVLMeb3NW1UzuUCmAgkBxypqOdS+
	LGxKiQc2d5MYNIvnsj20+f+NannBiHdJ9DhaaunHiQNDorYc3ExbsFLL9WWiCerY7ODu2a/Hoxd
	Ryvrk+EcmkC1curye0OwR6UENmOtHSh7IyZYUA3I9SFfh8Hj5AgqVkmF1qsJ5H/VnvygfADTwsr
	gwnYJ5qfOltsmoKt+GtAxRRPp6haRuGm+453EsLolbnnTHPNeJEOjfPzU9RQCbRF9rwbFVpyFV/
	kiHEEW8ba3YMxRCbvb1n4KkPumnXRzlwJbiQ1bPExsgtZGT9z+LBs0KVzSIeV1DvUEB8HLH986j
	Rcu3/sBwUjO/UgLxO3riAMPgMKNIkKVsYW6PRTO7pT
X-Google-Smtp-Source: AGHT+IGiO2MQIF6Yep6y2/isH2QW+nXbG00es5/W6noyWTP2pD3nWUiti/7EsFpua85fKefjjBmssQ==
X-Received: by 2002:a05:600c:4fc6:b0:46e:1a07:7bd5 with SMTP id 5b1f17b1804b1-46e61285d7dmr48438525e9.29.1759394558687;
        Thu, 02 Oct 2025 01:42:38 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f50b2sm2597515f8f.56.2025.10.02.01.42.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:38 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 07/17] hw/s390x/sclp: Replace [cpu_physical_memory -> address_space]_r/w()
Date: Thu,  2 Oct 2025 10:41:52 +0200
Message-ID: <20251002084203.63899-8-philmd@linaro.org>
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

cpu_physical_memory_read() and cpu_physical_memory_write() are
legacy (see commit b7ecba0f6f6), replace by address_space_read()
and address_space_write().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/s390x/sclp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 16057356b11..d7cb99482b2 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -304,6 +304,7 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     SCLPDeviceClass *sclp_c = SCLP_GET_CLASS(sclp);
     SCCBHeader header;
     g_autofree SCCB *work_sccb = NULL;
+    AddressSpace *as = CPU(cpu)->as;
 
     /* first some basic checks on program checks */
     if (env->psw.mask & PSW_MASK_PSTATE) {
@@ -318,7 +319,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     }
 
     /* the header contains the actual length of the sccb */
-    cpu_physical_memory_read(sccb, &header, sizeof(SCCBHeader));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       &header, sizeof(SCCBHeader));
 
     /* Valid sccb sizes */
     if (be16_to_cpu(header.length) < sizeof(SCCBHeader)) {
@@ -331,7 +333,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
      * the host has checked the values
      */
     work_sccb = g_malloc0(be16_to_cpu(header.length));
-    cpu_physical_memory_read(sccb, work_sccb, be16_to_cpu(header.length));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       work_sccb, be16_to_cpu(header.length));
 
     if (!sclp_command_code_valid(code)) {
         work_sccb->h.response_code = cpu_to_be16(SCLP_RC_INVALID_SCLP_COMMAND);
@@ -345,8 +348,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
 
     sclp_c->execute(sclp, work_sccb, code);
 out_write:
-    cpu_physical_memory_write(sccb, work_sccb,
-                              be16_to_cpu(work_sccb->h.length));
+    address_space_write(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                        work_sccb, be16_to_cpu(header.length));
 
     sclp_c->service_interrupt(sclp, sccb);
 
-- 
2.51.0


