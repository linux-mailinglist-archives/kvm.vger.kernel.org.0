Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC90479D4B
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhLRVWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhLRVVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:21:42 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B6BC0613A1;
        Sat, 18 Dec 2021 13:21:09 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso7478172ota.5;
        Sat, 18 Dec 2021 13:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cEbjV/8Ctr1QdXazsGfe+PbDs+iZrrBmmo9YNkbLBy0=;
        b=RKeJvy+TVkzSfE1DWFH8SBdk923FOhJaAQ0Dv9PrOLQIHftv5DaeBCB4tNKlvmYIPN
         nbkzjP+1Trtphdpdl224Vn1sYOGVLTg43YwIfJM5nH7KPfFHi7vCRPN0TaIMV0CuMzT2
         orCQwO8bJ9qk1nVA1GCOdVDNRIyHknNBzcXqS9rgvqtOTbjhHhWXGI5No2Z0UTz3TByx
         0Ag3UOeLtIQjs7s0rKEZ/24IhDlJLiBtoBDajcozUIGSHrQXSkW6AtgOu9kPk/Lq3qoc
         U8VDenhPvveU8b2bWmVJzG2Nt6HLvQlM90dIQDx+rucC4nLouHJTrpPqTNt21VK+DFl2
         nNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEbjV/8Ctr1QdXazsGfe+PbDs+iZrrBmmo9YNkbLBy0=;
        b=ISsMW83iCZvkf6j5UNLQxFJWAt+akzynXMY+6dGbK4wq5AZMgCksyhFPmiiu/6Kd4R
         9mHAb8bdl0lhDzfwewKG1P6ovpKCwO3jD+jttIJOiOmj/dv7JEkKDcUmuX6s2wminAbj
         7ujIo4k0q9qyjbmC1ZKasQQRLQxsSO64YcPCwqNZSP/aofVVKI5CbA66oW3smzyKTfW5
         yjxtFbbwsp96uOUs/LSFln8WP3r2GgBkneu0/jJMBxJehjP5gPzjHRlIFn4+LMCMgftp
         hUhYExaJlRVFhy/Y2GZY+dgbx8GUF7J9PNQYhcEOaZqb8LIHqKZxcUQ95pFH8rjB4AH/
         65pA==
X-Gm-Message-State: AOAM532aK+AE0T4GUbER5Vb+4inMO8Il9oMuXFFFwobKRbOhLu6cLF/L
        Xel60KznieRmoyBB0DhVYPJn3CivR9QoTA==
X-Google-Smtp-Source: ABdhPJwWLUowWO6z/6XzIWLGx6yfCwM40JettYuf4PfjeM7nkzCXO3jf+T1ejyUHBwjqYOIYE68+UA==
X-Received: by 2002:a9d:82a:: with SMTP id 39mr6499375oty.282.1639862468685;
        Sat, 18 Dec 2021 13:21:08 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id b17sm2560486ots.66.2021.12.18.13.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:21:08 -0800 (PST)
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
Subject: [PATCH 16/17] tools/bitmap: sync bitmap_weight
Date:   Sat, 18 Dec 2021 13:20:12 -0800
Message-Id: <20211218212014.1315894-17-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pull bitmap_weight_{cmp,eq,gt,ge,lt,le} from mother kernel and
use where applicable.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 tools/include/linux/bitmap.h | 44 ++++++++++++++++++++++++++++++++++++
 tools/lib/bitmap.c           | 20 ++++++++++++++++
 tools/perf/util/pmu.c        |  2 +-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index ea97804d04d4..e8ae9a85d555 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -12,6 +12,8 @@
 	unsigned long name[BITS_TO_LONGS(bits)]
 
 int __bitmap_weight(const unsigned long *bitmap, int bits);
+int __bitmap_weight_cmp(const unsigned long *bitmap, unsigned int bits,
+			 unsigned int num);
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 		 const unsigned long *bitmap2, int bits);
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
@@ -68,6 +70,48 @@ static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 	return __bitmap_weight(src, nbits);
 }
 
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
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 			     const unsigned long *src2, unsigned int nbits)
 {
diff --git a/tools/lib/bitmap.c b/tools/lib/bitmap.c
index db466ef7be9d..06e58fee8523 100644
--- a/tools/lib/bitmap.c
+++ b/tools/lib/bitmap.c
@@ -18,6 +18,26 @@ int __bitmap_weight(const unsigned long *bitmap, int bits)
 	return w;
 }
 
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
+
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 		 const unsigned long *bitmap2, int bits)
 {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 6ae58406f4fc..015ee1321c7c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1314,7 +1314,7 @@ static int pmu_config_term(const char *pmu_name,
 	 */
 	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM) {
 		if (term->no_value &&
-		    bitmap_weight(format->bits, PERF_PMU_FORMAT_BITS) > 1) {
+		    bitmap_weight_gt(format->bits, PERF_PMU_FORMAT_BITS, 1)) {
 			if (err) {
 				parse_events_error__handle(err, term->err_val,
 					   strdup("no value assigned for term"),
-- 
2.30.2

