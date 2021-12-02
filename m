Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1D04662D2
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357186AbhLBL50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241672AbhLBL5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:23 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2FC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:54:00 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p27-20020a05600c1d9b00b0033bf8532855so3359923wms.3
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rKZGIAkHy6Wk8HmnCBA18OX+dHqy4xS8aZv10RY6IUY=;
        b=MblWz4yZRq+L8PlG0X2he7aOI50DRfzcKKh4ACKITTzWX30sgubF6ilsdFMxEd/cQS
         xFLZ1BTlHOfMHh7CQxspuYRuGrJUrEyCvOIdhDFnTchqezn9PzrH9ckJ+CWok8XovBBD
         K6+gyy2yx9LT7mKq+egq+hEJEA87NYXr0Xi68A+e9Jr/mC4QLFDTUP6kiccMr/kmIrQ5
         ZwnzKuoQxybIktQMFBSxV4pnQTXf8+pGK4dQrO/AnVuKPsB9iYnb0zmN9Eg/ksvIscNO
         JrgkSwSh0NWBhv3zwQQKWrbfxNxvltgXoO4f6xtYCxyiOaMY6P8Ovm/lKTgo22JgZ7dg
         hG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rKZGIAkHy6Wk8HmnCBA18OX+dHqy4xS8aZv10RY6IUY=;
        b=dHg5r399OpebQPkScGMFRehtXbbxTEToMoVOrJ5tAg3TYl1omyqawZ/vbAr/Zpt/x8
         m0MIQPz9CZ6X+U8bL49F8q5ObtqApC+MJT1NkNIAMgjLdogGg6dkGxomLPcld61el5Bn
         SJ2+qlcItI8OxPKOSGnoYPPinGKacrwN/sTyWw1iwoeZROXaqy3+ZqSdaiGxReOQ5g6w
         PEZTwgP0j32KOnZWjDJE4Votgz8nGy9OvFJS5zclxalF54wK9nrvXXCIbLP6/P0vB2nI
         JxZO/qEd44vOqx0vugC9xfGKEybLC7W+X0b+hVEkwskczUuqZQ7N/gEEWOGduc3GDVyU
         9GAA==
X-Gm-Message-State: AOAM532I6de4KIZ9cZon/s+Ft3jy2yakKCnqE6eqBapxveexJJPkPt0x
        rO5JSxV1ROMhYhqp7r5YqscfBw==
X-Google-Smtp-Source: ABdhPJwN0YmW7tIvGU7I4fBuMFiBCDaW5OLUlQiHzPXrTIhlhJE6apr185FR6mYBG1nfWLphgaXOBg==
X-Received: by 2002:a05:600c:1993:: with SMTP id t19mr5895466wmq.21.1638446039503;
        Thu, 02 Dec 2021 03:53:59 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id b188sm1880708wmd.45.2021.12.02.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:54 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id BC5791FF9B;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Timothy B . Terriberry" <tterribe@xiph.org>
Subject: [kvm-unit-tests PATCH v9 4/9] lib: add isaac prng library from CCAN
Date:   Thu,  2 Dec 2021 11:53:47 +0000
Message-Id: <20211202115352.951548-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's often useful to introduce some sort of random variation when
testing several racing CPU conditions. Instead of each test implementing
some half-arsed PRNG bring in a a decent one which has good statistical
randomness. Obviously it is deterministic for a given seed value which
is likely the behaviour you want.

I've pulled in the ISAAC library from CCAN:

    http://ccodearchive.net/info/isaac.html

I shaved off the float related stuff which is less useful for unit
testing and re-indented to fit the style. The original license was
CC0 (Public Domain) which is compatible with the LGPL v2 of
kvm-unit-tests.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Timothy B. Terriberry <tterribe@xiph.org>
Acked-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20211118184650.661575-6-alex.bennee@linaro.org>
---
 arm/Makefile.common |   1 +
 lib/prng.h          |  82 ++++++++++++++++++++++
 lib/prng.c          | 162 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 lib/prng.h
 create mode 100644 lib/prng.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 38385e0c..99bcf3fc 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -44,6 +44,7 @@ cflatobjs += lib/pci-testdev.o
 cflatobjs += lib/virtio.o
 cflatobjs += lib/virtio-mmio.o
 cflatobjs += lib/chr-testdev.o
+cflatobjs += lib/prng.o
 cflatobjs += lib/arm/io.o
 cflatobjs += lib/arm/setup.o
 cflatobjs += lib/arm/mmu.o
diff --git a/lib/prng.h b/lib/prng.h
new file mode 100644
index 00000000..bf5776d1
--- /dev/null
+++ b/lib/prng.h
@@ -0,0 +1,82 @@
+/*
+ * PRNG Header
+ */
+#ifndef __PRNG_H__
+#define __PRNG_H__
+
+# include <stdint.h>
+
+
+
+typedef struct isaac_ctx isaac_ctx;
+
+
+
+/*This value may be lowered to reduce memory usage on embedded platforms, at
+  the cost of reducing security and increasing bias.
+  Quoting Bob Jenkins: "The current best guess is that bias is detectable after
+  2**37 values for [ISAAC_SZ_LOG]=3, 2**45 for 4, 2**53 for 5, 2**61 for 6,
+  2**69 for 7, and 2**77 values for [ISAAC_SZ_LOG]=8."*/
+#define ISAAC_SZ_LOG      (8)
+#define ISAAC_SZ          (1<<ISAAC_SZ_LOG)
+#define ISAAC_SEED_SZ_MAX (ISAAC_SZ<<2)
+
+
+
+/*ISAAC is the most advanced of a series of pseudo-random number generators
+  designed by Robert J. Jenkins Jr. in 1996.
+  http://www.burtleburtle.net/bob/rand/isaac.html
+  To quote:
+  No efficient method is known for deducing their internal states.
+  ISAAC requires an amortized 18.75 instructions to produce a 32-bit value.
+  There are no cycles in ISAAC shorter than 2**40 values.
+  The expected cycle length is 2**8295 values.*/
+struct isaac_ctx{
+	unsigned n;
+	uint32_t r[ISAAC_SZ];
+	uint32_t m[ISAAC_SZ];
+	uint32_t a;
+	uint32_t b;
+	uint32_t c;
+};
+
+
+/**
+ * isaac_init - Initialize an instance of the ISAAC random number generator.
+ * @_ctx:   The instance to initialize.
+ * @_seed:  The specified seed bytes.
+ *          This may be NULL if _nseed is less than or equal to zero.
+ * @_nseed: The number of bytes to use for the seed.
+ *          If this is greater than ISAAC_SEED_SZ_MAX, the extra bytes are
+ *           ignored.
+ */
+void isaac_init(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed);
+
+/**
+ * isaac_reseed - Mix a new batch of entropy into the current state.
+ * To reset ISAAC to a known state, call isaac_init() again instead.
+ * @_ctx:   The instance to reseed.
+ * @_seed:  The specified seed bytes.
+ *          This may be NULL if _nseed is zero.
+ * @_nseed: The number of bytes to use for the seed.
+ *          If this is greater than ISAAC_SEED_SZ_MAX, the extra bytes are
+ *           ignored.
+ */
+void isaac_reseed(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed);
+/**
+ * isaac_next_uint32 - Return the next random 32-bit value.
+ * @_ctx: The ISAAC instance to generate the value with.
+ */
+uint32_t isaac_next_uint32(isaac_ctx *_ctx);
+/**
+ * isaac_next_uint - Uniform random integer less than the given value.
+ * @_ctx: The ISAAC instance to generate the value with.
+ * @_n:   The upper bound on the range of numbers returned (not inclusive).
+ *        This must be greater than zero and less than 2**32.
+ *        To return integers in the full range 0...2**32-1, use
+ *         isaac_next_uint32() instead.
+ * Return: An integer uniformly distributed between 0 and _n-1 (inclusive).
+ */
+uint32_t isaac_next_uint(isaac_ctx *_ctx,uint32_t _n);
+
+#endif
diff --git a/lib/prng.c b/lib/prng.c
new file mode 100644
index 00000000..ebd6df75
--- /dev/null
+++ b/lib/prng.c
@@ -0,0 +1,162 @@
+/*
+ * Pseudo Random Number Generator
+ *
+ * Lifted from ccan modules ilog/isaac under CC0
+ *   - http://ccodearchive.net/info/isaac.html
+ *   - http://ccodearchive.net/info/ilog.html
+ *
+ * And lightly hacked to compile under the KVM unit test environment.
+ * This provides a handy RNG for torture tests that want to vary
+ * delays and the like.
+ *
+ */
+
+/*Written by Timothy B. Terriberry (tterribe@xiph.org) 1999-2009.
+  CC0 (Public domain) - see LICENSE file for details
+  Based on the public domain implementation by Robert J. Jenkins Jr.*/
+
+#include "libcflat.h"
+
+#include <string.h>
+#include "prng.h"
+
+#define ISAAC_MASK        (0xFFFFFFFFU)
+
+/* Extract ISAAC_SZ_LOG bits (starting at bit 2). */
+static inline uint32_t lower_bits(uint32_t x)
+{
+	return (x & ((ISAAC_SZ-1) << 2)) >> 2;
+}
+
+/* Extract next ISAAC_SZ_LOG bits (starting at bit ISAAC_SZ_LOG+2). */
+static inline uint32_t upper_bits(uint32_t y)
+{
+	return (y >> (ISAAC_SZ_LOG+2)) & (ISAAC_SZ-1);
+}
+
+static void isaac_update(isaac_ctx *_ctx){
+	uint32_t *m;
+	uint32_t *r;
+	uint32_t  a;
+	uint32_t  b;
+	uint32_t  x;
+	uint32_t  y;
+	int       i;
+	m=_ctx->m;
+	r=_ctx->r;
+	a=_ctx->a;
+	b=_ctx->b+(++_ctx->c);
+	for(i=0;i<ISAAC_SZ/2;i++){
+		x=m[i];
+		a=(a^a<<13)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>6)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a<<2)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>16)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+	}
+	for(i=ISAAC_SZ/2;i<ISAAC_SZ;i++){
+		x=m[i];
+		a=(a^a<<13)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>6)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a<<2)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>16)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+	}
+	_ctx->b=b;
+	_ctx->a=a;
+	_ctx->n=ISAAC_SZ;
+}
+
+static void isaac_mix(uint32_t _x[8]){
+	static const unsigned char SHIFT[8]={11,2,8,16,10,4,8,9};
+	int i;
+	for(i=0;i<8;i++){
+		_x[i]^=_x[(i+1)&7]<<SHIFT[i];
+		_x[(i+3)&7]+=_x[i];
+		_x[(i+1)&7]+=_x[(i+2)&7];
+		i++;
+		_x[i]^=_x[(i+1)&7]>>SHIFT[i];
+		_x[(i+3)&7]+=_x[i];
+		_x[(i+1)&7]+=_x[(i+2)&7];
+	}
+}
+
+
+void isaac_init(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed){
+	_ctx->a=_ctx->b=_ctx->c=0;
+	memset(_ctx->r,0,sizeof(_ctx->r));
+	isaac_reseed(_ctx,_seed,_nseed);
+}
+
+void isaac_reseed(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed){
+	uint32_t *m;
+	uint32_t *r;
+	uint32_t  x[8];
+	int       i;
+	int       j;
+	m=_ctx->m;
+	r=_ctx->r;
+	if(_nseed>ISAAC_SEED_SZ_MAX)_nseed=ISAAC_SEED_SZ_MAX;
+	for(i=0;i<_nseed>>2;i++){
+		r[i]^=(uint32_t)_seed[i<<2|3]<<24|(uint32_t)_seed[i<<2|2]<<16|
+			(uint32_t)_seed[i<<2|1]<<8|_seed[i<<2];
+	}
+	_nseed-=i<<2;
+	if(_nseed>0){
+		uint32_t ri;
+		ri=_seed[i<<2];
+		for(j=1;j<_nseed;j++)ri|=(uint32_t)_seed[i<<2|j]<<(j<<3);
+		r[i++]^=ri;
+	}
+	x[0]=x[1]=x[2]=x[3]=x[4]=x[5]=x[6]=x[7]=0x9E3779B9U;
+	for(i=0;i<4;i++)isaac_mix(x);
+	for(i=0;i<ISAAC_SZ;i+=8){
+		for(j=0;j<8;j++)x[j]+=r[i+j];
+		isaac_mix(x);
+		memcpy(m+i,x,sizeof(x));
+	}
+	for(i=0;i<ISAAC_SZ;i+=8){
+		for(j=0;j<8;j++)x[j]+=m[i+j];
+		isaac_mix(x);
+		memcpy(m+i,x,sizeof(x));
+	}
+	isaac_update(_ctx);
+}
+
+uint32_t isaac_next_uint32(isaac_ctx *_ctx){
+	if(!_ctx->n)isaac_update(_ctx);
+	return _ctx->r[--_ctx->n];
+}
+
+uint32_t isaac_next_uint(isaac_ctx *_ctx,uint32_t _n){
+	uint32_t r;
+	uint32_t v;
+	uint32_t d;
+	do{
+		r=isaac_next_uint32(_ctx);
+		v=r%_n;
+		d=r-v;
+	}
+	while(((d+_n-1)&ISAAC_MASK)<d);
+	return v;
+}
-- 
2.30.2

