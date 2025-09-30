Return-Path: <kvm+bounces-59065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE6CBAB4C4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 000FB7A45C4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F4F248F7F;
	Tue, 30 Sep 2025 04:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FqJ6mTKw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93431248878
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205658; cv=none; b=nA+zv/hfT2o45uzVvvZbftMe1+4WSGoLbmeKgk0q7PQikJooTWzCC/1ZJBdA3BpcRBX0VyLcFDOhSOW7DIFc+AAdUeT/LoZSUG4HMoMyZGFZChFRZLV70alk8VOW01ZMiVXla56P11BHGVlimRXomHLgtdxnXN2f6cs31AFCSc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205658; c=relaxed/simple;
	bh=7ZRazBY47bhUT6pdzVjIjO1wWnlchkM0+VhS0ryjJ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaf4k1Xr0nbqq4MrMGb7+5mcNSQWNefWMSNSU7R8pbMXI6hmNpgGs5AjR4kDc0yvuQW/2BsBZyENYbnMpAMWVKOhpL61qxFzZ3TFdpjMtuIwCCLFqHCCGjFHDK/IcUKBCmVZj0CZsrF+EFoDAP1dphuqHYedIy9J67zjS2Y0Bfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FqJ6mTKw; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3f0308469a4so3076662f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205655; x=1759810455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfNLwv+i5cO84zMF6diWkvUfOapkzoMYrwwz0ZMfYgk=;
        b=FqJ6mTKwq+SirrRaNtnkPNjI7KIQmbbGKhdI+Ow7Ws/SA2PSpRpE+HINt4aG5y/S3G
         IXK1i5fofq7nng3GkZTYEfzXn+uKWZdV9Rnu51oBR5OHvcPoUICnana9/5T/REZlptFe
         xZsIW8aTS9+noiHrdWyVC4hT1xm/pW8NcCNzy02ssgQPFAKdo47kcvHP19kPumvvL6jq
         obQDFGa9thH2dCTWUAygq3XCS0UfFYrSyckYonleSQeyupn1hwSbQ7iWEMoTOJ1vKZ1j
         5jInZ1HeTRFt8kni1gSxSW6cO/nWxIsiSnSuqQVjKtTX+cCllZSF2/G0E3kESKTqX/iF
         37YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205655; x=1759810455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfNLwv+i5cO84zMF6diWkvUfOapkzoMYrwwz0ZMfYgk=;
        b=Bo1kta3Ahq7QjRtAgxtxSbNujk2Of2G/W1IpNlm6KQ5D52xFWy9D3yIBiUDkGJgwL0
         ppDDAxCQBy17+5FbRsP9blUSe8QGeQHTPNfOkvN3jCjXmhLZW0i+XuAMEKteIkCa77uj
         Jtj2Kewy7UlwByoP5NhMFyGCKK7qdf500GCAexJpl57vYx8kmXTBAFoB3T9KI3/kzTrZ
         meCIuPVQDbAUa/kLm25KP67I8FzlB9QzKbBMD7AqArsCGfWZSJcogx4wdggGvo6/a1Xy
         OgEyzrkQ5nmMvkGpmvyswOWoapcsfq8a2orgxNWOkBYUXDldB4BS+z9vZYycohR7MTvi
         cJUA==
X-Forwarded-Encrypted: i=1; AJvYcCWvsbGGj23Uftbopj+49lSHYol0HCuVr68rTXeyUmkrzI2Y9wBeVoEWKYtQCrAWeuwtx7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyanX0UO8PiKvlZcDmwKz+vD6VzEmn84XsjLL/3Y8e2NKXZ5Adb
	5DOA82PBQUJnK2EHYDehEbOFh1o5TMQssLMU/3E+le10a4RV37SiOC9PYEC+mLaR9Og=
X-Gm-Gg: ASbGnct6ZNqn1liojuvaUPbLHi30Zr1ivpcull2lh9iJs6sIMHW4GIP2rzxB1vWvrRm
	gzgQVSrImMunA1Vo/ruPK1wYw3SktHI+Vi3JKnK5UidOwRWMgpEpEsCoLZVfSIY9+FljgWoNJQj
	lDBl6vH/glv2QIeU2OdOpCi8sq6t1JXhmOYFXRK/B3UVQ5HlKlIy0w1l3YUMDN7TRVMaL2E1KSp
	yOl+WgFCKHdwIKHEW1ZYoit9no4Dg5mYeWC9fVadCfvGRARBLbaSDXp+dcC+5x0BsFvS/8c/1YO
	gEM23316g0NhllJ6/Yp63JhiPM/Ar7aefx+V2Y0q+D6iemub8BuUUIcC9nIAM8lMQtyG1KtiEFw
	GwhUQzXtIGIjWl7fRhkphE1tOUrKajvegn+X8afQ3JUfCahramnIcuaZX0Hs13FpxzeGQ5h4k4r
	O3f8lID5bt+9um//oUuwX6
X-Google-Smtp-Source: AGHT+IHP/zG4X6xn4hUDdclB/D1afSsyjXOgC/ThtRrRCj048iTFTeDxSXkrbhWZePrU5zQ+WKtYTA==
X-Received: by 2002:a05:6000:1848:b0:3eb:8395:e2e0 with SMTP id ffacd0b85a97d-40e4b38923emr16718454f8f.51.1759205654828;
        Mon, 29 Sep 2025 21:14:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41f00aebdb7sm8027318f8f.57.2025.09.29.21.14.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:14 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 08/17] hw/s390x/sclp: Replace [cpu_physical_memory -> address_space]_r/w()
Date: Tue, 30 Sep 2025 06:13:16 +0200
Message-ID: <20250930041326.6448-9-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
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


