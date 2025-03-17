Return-Path: <kvm+bounces-41300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A80FEA65CBF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F6163BB2A3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC261F4E37;
	Mon, 17 Mar 2025 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wYQ2qG7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B531EFF90
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236481; cv=none; b=UwgnSnd5THOZb4GTYhX61QY4YpgneCj/M53iSxyvjAoMEjSK080biWuYi5H/miOV2PiJCOHk9qWckWaPiXtJpVh/+2Mu14Lj1VBOhHvQLnN1blFqIm7Wai/1sKtb8M7eqz8P7gCJAD+gcQMfkHfVhiliPPC/XIaE6tXIISf1ClI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236481; c=relaxed/simple;
	bh=s8RXw4zrEgx/HfXiIysdDtYZAgo1iz1ahy1OQXodoK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUziGDZPtfCgjfQqMRjtmVhfokenBruR+8Knc08cLL8I14/MY5NqXpmxzs20f/0pX/UlpCkjYr2Anas2sX6ja9q6A/Q2xihZ7kqMJLNT/2gFj179tsneWrVpmaBMwDdPkSqvKwJZOkW421/fZq1l1YjAG08wVy9FmNEpJZMg4ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wYQ2qG7j; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-223fd89d036so95211185ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236479; x=1742841279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RL1NPApLGPlk4f7q724/4D7b3IECBRPwWShMeYRIDxA=;
        b=wYQ2qG7jbMYMhkccV+n2hrv8qxspoVffdYvpA7a33g2XYjz1N7kqP7QgZN9gA6DDZL
         CrAyZbzPeAnRcTQKVc0EQDFcqzwqqKoJAstPF6Ma+AJZu6AdU2QxVva0MdiHvr6Utldm
         RJRn0ehnTzHBIg9PMmBdmKsC1gPZiBFb892CtPFkYmeZ58As+Lfzj1I1WtmnmjaTDYKA
         0hS98mJWYbdmx295SCoCKn144vq1zo2vz0ZrcPsh4zSpA3KjW7WcO2LPvpVkE2JuF84L
         5/bAtcSVq1mftusZSZk2n7VfCmqrdoR4U6Lj1rHnaP9KaIsKZK4a24PH45BVsjC/Eu8z
         aQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236479; x=1742841279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RL1NPApLGPlk4f7q724/4D7b3IECBRPwWShMeYRIDxA=;
        b=b2c+GZMPfKz5ffE503FKaiKCXCskQyeP5TuMpJh3m/JdDbx1/rJ+cjBT550buGSSrE
         lwS8dcggz/7I52qXokVbLHyF9aIAVC065z40OV1pqKSyZr/XaG6JWiqx4rpah/DoVu2a
         2iL7BcX7uOzcMFpRqF3BpBeIE1CVVV9k1livsNSofT+sQoFyC+9nVectMaS1CqZG+eBh
         tXiSxeBm7d/8fsbZ3tNThaHbHI4vksnrRsDKFDmXobvsTwe5sjiW9d6hyyuOBOHYG2u+
         0IARgnu7x9petfeTIPbGlmERKPP40okC8Kv5abh32HiXD+GjUCoNjsH+uSzTaf2/ayxy
         whOA==
X-Forwarded-Encrypted: i=1; AJvYcCXj+OyNRVlHM82YiNVvYNGh25goGUd23v6iF4lSCa0ygyQIZi8MnUPfs9RZ2mMYbufzrj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYXf9mKinpmFWnUKUlMYcS+is3RRiDL6odJElsvG9oANafUkEC
	zmzsyyoM6MQ1doDnRAFtLMwEDP0sF7sdzKCOA8U0Hjkg/eOMbHgOLyE0GzRkJ8w=
X-Gm-Gg: ASbGncsyUm+GYKCcpcMqfbl1wJrINS2fWG9SbIiZa+9EDGeLQvJezufcj8uFTXz2tL7
	rtXr/tIcKJ0BCDIaOY51L1O6u5ME9BfDmwHYTwl3r5Z1uvhJldZi6LYNFMv28pX3fLVBiOi7u2I
	cDpEvDjCzy/K8nc/PvEJvDTWvCo2BQz3YXSGI4Tiz9+Dzhc+MKfTivQkqFbJyiT5E07QFecdMEH
	h/V+s5IwxbxBioaoXFB+Bzi9tx8VYRs+vJ2qSNxJt6RnGmKeiGEi+KlY5C3ZyiWqJVjmdJ1S+Ek
	TiqGuqWlvOaYz0JTaAf9ze1cxNaeAbzEEfb1H6AglHcx
X-Google-Smtp-Source: AGHT+IFOOeyV31jwF+pNrENhCRDzbP+OAMMjvkw2JiLIZfPvEZk2AdzmBDyPiAzaxdBUCsyNl+0UJg==
X-Received: by 2002:a05:6a00:1c83:b0:736:54c9:df2c with SMTP id d2e1a72fcca58-7372240f41dmr13708249b3a.15.1742236479639;
        Mon, 17 Mar 2025 11:34:39 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:39 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 13/18] system/xen: remove inline stubs
Date: Mon, 17 Mar 2025 11:34:12 -0700
Message-Id: <20250317183417.285700-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/xen-mapcache.h | 41 -----------------------------------
 include/system/xen.h          | 21 +++---------------
 2 files changed, 3 insertions(+), 59 deletions(-)

diff --git a/include/system/xen-mapcache.h b/include/system/xen-mapcache.h
index b68f196ddd5..bb454a7c96c 100644
--- a/include/system/xen-mapcache.h
+++ b/include/system/xen-mapcache.h
@@ -14,8 +14,6 @@
 
 typedef hwaddr (*phys_offset_to_gaddr_t)(hwaddr phys_offset,
                                          ram_addr_t size);
-#ifdef CONFIG_XEN_IS_POSSIBLE
-
 void xen_map_cache_init(phys_offset_to_gaddr_t f,
                         void *opaque);
 uint8_t *xen_map_cache(MemoryRegion *mr, hwaddr phys_addr, hwaddr size,
@@ -28,44 +26,5 @@ void xen_invalidate_map_cache(void);
 uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
                                  hwaddr new_phys_addr,
                                  hwaddr size);
-#else
-
-static inline void xen_map_cache_init(phys_offset_to_gaddr_t f,
-                                      void *opaque)
-{
-}
-
-static inline uint8_t *xen_map_cache(MemoryRegion *mr,
-                                     hwaddr phys_addr,
-                                     hwaddr size,
-                                     ram_addr_t ram_addr_offset,
-                                     uint8_t lock,
-                                     bool dma,
-                                     bool is_write)
-{
-    abort();
-}
-
-static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
-{
-    abort();
-}
-
-static inline void xen_invalidate_map_cache_entry(uint8_t *buffer)
-{
-}
-
-static inline void xen_invalidate_map_cache(void)
-{
-}
-
-static inline uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
-                                               hwaddr new_phys_addr,
-                                               hwaddr size)
-{
-    abort();
-}
-
-#endif
 
 #endif /* XEN_MAPCACHE_H */
diff --git a/include/system/xen.h b/include/system/xen.h
index 990c19a8ef0..5f41915732b 100644
--- a/include/system/xen.h
+++ b/include/system/xen.h
@@ -25,30 +25,15 @@
 #endif /* COMPILING_PER_TARGET */
 
 #ifdef CONFIG_XEN_IS_POSSIBLE
-
 extern bool xen_allowed;
-
 #define xen_enabled()           (xen_allowed)
-
-void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
-void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
-                   struct MemoryRegion *mr, Error **errp);
-
 #else /* !CONFIG_XEN_IS_POSSIBLE */
-
 #define xen_enabled() 0
-static inline void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length)
-{
-    /* nothing */
-}
-static inline void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
-                                 MemoryRegion *mr, Error **errp)
-{
-    g_assert_not_reached();
-}
-
 #endif /* CONFIG_XEN_IS_POSSIBLE */
 
+void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
+void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
+                   struct MemoryRegion *mr, Error **errp);
 bool xen_mr_is_memory(MemoryRegion *mr);
 bool xen_mr_is_grants(MemoryRegion *mr);
 #endif
-- 
2.39.5


