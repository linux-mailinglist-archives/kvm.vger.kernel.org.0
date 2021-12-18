Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DADE479D1E
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhLRVVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhLRVUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:20:41 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E22C06173E;
        Sat, 18 Dec 2021 13:20:41 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id w5-20020a4a2745000000b002c2649b8d5fso1838343oow.10;
        Sat, 18 Dec 2021 13:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y8ExfgOcgrA4CHmSecZvjPn/xavwnyrvtMRh3tqxxrw=;
        b=ky3nIm4VKfqY0Iq4zNauj3NXFN9QLbU64c4NLKd8+eXyY5UHvMFlx9aiNTA/qwjF5p
         5WEcS0LUjqwMpD0Ly9X7LVxbhmiOR2GbQ+abrUk6bHvx7+Cvj1ungkoH5D46b1QyLWQz
         km2XM/SS0wgiVd0HWTiaIFErZ5cDFzoDijXs35dCpitpd1tSBTdIYvXxDqkzZELiy25H
         54tm+5ByXHXPQCWtpde4rVewBv2R910Nw8U1BZzohGqANJ92nhEfKoJ9hVS5V3Wa/96H
         D15GnwPbjMyWcfB02PLIxfn7tGI1glt4iKIi7P1KZiLFMB3n2s8o4pHZOlsQnok+/jIH
         ei5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8ExfgOcgrA4CHmSecZvjPn/xavwnyrvtMRh3tqxxrw=;
        b=fHXfqAebV1wq4SdWsWqsuvdedoRhoqBh89xZaQS1POjaDz/GvI2uNSlpKjxUg1MTi3
         ZAw50cGKDLoFe/29eh+5cjNINYeXj9fSInrCePES0mwPyDmmJ7B3QlMM1fAeWRjaFg9g
         dgR9Bagt1hI++tnfb/hqd8IBci3LQaFtiPmVclrcose32kPmkO7D27yZEWOQ/Ks60I26
         MyUdkG9Hg4xxRw1JBcbgvPBi/ydMQDMiUD9YYzE3ggWWDxcOs1rPG4rSvLVMHRCHGigg
         cdzXTV5NU9VCxNXrGfoUpvkM7nhaIHVhqu5VfgwZctfxZHUFK5IbpyzF7X3HAFOLgwz8
         toiQ==
X-Gm-Message-State: AOAM532ik+6aDIC1bLiDJ8B0+MoJwrd84Yo5Vr+FGwqcwmaB9fvptMxx
        xmFvI2o6hhx9jc0mFfrvI8FYsVLTecIVnw==
X-Google-Smtp-Source: ABdhPJxRJAChWm8hZEgKNS5uqGfM1GLlIQqNCNXw8p1t/B+Bt/JWEVwLsC+a2lNQnmWVQu7sh+mn1Q==
X-Received: by 2002:a05:6820:820:: with SMTP id bg32mr5869341oob.10.1639862439949;
        Sat, 18 Dec 2021 13:20:39 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r26sm2292099otn.15.2021.12.18.13.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:39 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 07/17] lib/bitmap: add bitmap_weight_{cmp,eq,gt,ge,lt,le} functions
Date:   Sat, 18 Dec 2021 13:20:03 -0800
Message-Id: <20211218212014.1315894-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many kernel users use bitmap_weight() to compare the result against
some number or expression:

	if (bitmap_weight(...) > 1)
		do_something();

It works OK, but may be significantly improved for large bitmaps: if
first few words count set bits to a number greater than given, we can
stop counting and immediately return.

The same idea would work in other direction: if we know that the number
of set bits that we counted so far is small enough, so that it would be
smaller than required number even if all bits of the rest of the bitmap
are set, we can stop counting earlier.

This patch adds new bitmap_weight_cmp() as suggested by Michał Mirosław
and a family of eq, gt, ge, lt and le wrappers to allow this optimization.
The following patches apply new functions where appropriate.

Suggested-by: "Michał Mirosław" <mirq-linux@rere.qmqm.pl> (for bitmap_weight_cmp)
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 80 ++++++++++++++++++++++++++++++++++++++++++
 lib/bitmap.c           | 21 +++++++++++
 2 files changed, 101 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7dba0847510c..708e57b32362 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -51,6 +51,12 @@ struct device;
  *  bitmap_empty(src, nbits)                    Are all bits zero in *src?
  *  bitmap_full(src, nbits)                     Are all bits set in *src?
  *  bitmap_weight(src, nbits)                   Hamming Weight: number set bits
+ *  bitmap_weight_cmp(src, nbits)               compare Hamming Weight with a number
+ *  bitmap_weight_eq(src, nbits, num)           Hamming Weight == num
+ *  bitmap_weight_gt(src, nbits, num)           Hamming Weight >  num
+ *  bitmap_weight_ge(src, nbits, num)           Hamming Weight >= num
+ *  bitmap_weight_lt(src, nbits, num)           Hamming Weight <  num
+ *  bitmap_weight_le(src, nbits, num)           Hamming Weight <= num
  *  bitmap_set(dst, pos, nbits)                 Set specified bit area
  *  bitmap_clear(dst, pos, nbits)               Clear specified bit area
  *  bitmap_find_next_zero_area(buf, len, pos, n, mask)  Find bit free area
@@ -162,6 +168,7 @@ int __bitmap_intersects(const unsigned long *bitmap1,
 int __bitmap_subset(const unsigned long *bitmap1,
 		    const unsigned long *bitmap2, unsigned int nbits);
 int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
+int __bitmap_weight_cmp(const unsigned long *bitmap, unsigned int bits, int num);
 void __bitmap_set(unsigned long *map, unsigned int start, int len);
 void __bitmap_clear(unsigned long *map, unsigned int start, int len);
 
@@ -403,6 +410,79 @@ static __always_inline int bitmap_weight(const unsigned long *src, unsigned int
 	return __bitmap_weight(src, nbits);
 }
 
+/**
+ * bitmap_weight_cmp - compares number of set bits in @src with @num.
+ * @src:   source bitmap
+ * @nbits: length of bitmap in bits
+ * @num:   number to compare with
+ *
+ * As opposite to bitmap_weight() this function doesn't necessarily
+ * traverse full bitmap and may return earlier.
+ *
+ * Returns zero if weight of @src is equal to @num;
+ *	   negative number if weight of @src is less than @num;
+ *	   positive number if weight of @src is greater than @num;
+ *
+ * NOTES
+ *
+ * Because number of set bits cannot decrease while counting, when user
+ * wants to know if the number of set bits in the bitmap is less than
+ * @num, calling
+ *	bitmap_weight_cmp(..., @num) < 0
+ * is potentially less effective than
+ *	bitmap_weight_cmp(..., @num - 1) <= 0
+ *
+ * Consider an example:
+ * bitmap_weight_cmp(1000 0000 0000 0000, 1) < 0
+ *				    ^
+ *				    stop here
+ *
+ * bitmap_weight_cmp(1000 0000 0000 0000, 0) <= 0
+ *		     ^
+ *		     stop here
+ */
+static __always_inline
+int bitmap_weight_cmp(const unsigned long *src, unsigned int nbits, int num)
+{
+	if (num > (int)nbits || num < 0)
+		return -num;
+
+	if (small_const_nbits(nbits))
+		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits)) - num;
+
+	return __bitmap_weight_cmp(src, nbits, num);
+}
+
+static __always_inline
+bool bitmap_weight_eq(const unsigned long *src, unsigned int nbits, int num)
+{
+	return bitmap_weight_cmp(src, nbits, num) == 0;
+}
+
+static __always_inline
+bool bitmap_weight_gt(const unsigned long *src, unsigned int nbits, int num)
+{
+	return bitmap_weight_cmp(src, nbits, num) > 0;
+}
+
+static __always_inline
+bool bitmap_weight_ge(const unsigned long *src, unsigned int nbits, int num)
+{
+	return bitmap_weight_cmp(src, nbits, num - 1) > 0;
+}
+
+static __always_inline
+bool bitmap_weight_lt(const unsigned long *src, unsigned int nbits, int num)
+{
+	return bitmap_weight_cmp(src, nbits, num - 1) <= 0;
+}
+
+static __always_inline
+bool bitmap_weight_le(const unsigned long *src, unsigned int nbits, int num)
+{
+	return bitmap_weight_cmp(src, nbits, num) <= 0;
+}
+
 static __always_inline void bitmap_set(unsigned long *map, unsigned int start,
 		unsigned int nbits)
 {
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 926408883456..fb84ca70c5d9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -348,6 +348,27 @@ int __bitmap_weight(const unsigned long *bitmap, unsigned int bits)
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+int __bitmap_weight_cmp(const unsigned long *bitmap, unsigned int bits, int num)
+{
+	unsigned int k, w, lim = bits / BITS_PER_LONG;
+
+	for (k = 0, w = 0; k < lim; k++) {
+		if (w + bits - k * BITS_PER_LONG < num)
+			goto out;
+
+		w += hweight_long(bitmap[k]);
+
+		if (w > num)
+			goto out;
+	}
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+out:
+	return w - num;
+}
+EXPORT_SYMBOL(__bitmap_weight_cmp);
+
 void __bitmap_set(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
-- 
2.30.2

