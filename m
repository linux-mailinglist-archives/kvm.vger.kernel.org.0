Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8358479CE0
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhLRVU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbhLRVUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:20:22 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE6EC061574;
        Sat, 18 Dec 2021 13:20:21 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so1843697ooj.5;
        Sat, 18 Dec 2021 13:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Z2tvdbF6REb1vBF1soXoDEIHAExTZD83ljtvXFSjKwo=;
        b=emXGoF/rqz2kZ1ppkVCvpVwnlzRGfpHvB6fCjdgXgq4mWi4taNltzT/8wcLQq66dbk
         MD2zDykqS6XJaQ5PU2HVINr4Hy6yCA5bYv6gpPBvg9v3XheXHY+8l+yeCmhX2tga4gVQ
         sTew+4Ce+CJk3e/yVOV0JvK+IRua38r6JmY0W0m2iG7AvTEFJPzEdJgJthm8SUSs/HSu
         +2y2hMZR9kLSjfG1dQSz0Un8nNh3r481BC0sqINll4Wfg/BF12V/L2oAmdDVwhPToLvH
         OP+x58qnTe8/1kAkfYhKXTLFTwToKojcYG+btHtZE0qvbhco3tOTmSCXQ29ee1Ng0z1Y
         3GQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2tvdbF6REb1vBF1soXoDEIHAExTZD83ljtvXFSjKwo=;
        b=PjV1OGZZ2DhUlOZQckPL9o6gzyAETB/ahNyDdmI78tg6/ug9wx+jkt3z/sfcy21PG1
         f2/ZoXnvhWMccgeN3twpPSS51gt2EXj3hlNxLRUXNgtnZrdxmUdcUUUsAdDjOzHK/OvW
         ieEYUr298r9TT72bLuFXCYIgWXkEFja1f3k4Op4IMbwi00zccJLphW2boaPrcWNIHadX
         u8/qjaK4GjiPXVURZ5KIHZiY27TaB3fOySBHjH5/41HENT+4/JBEVUTT+QT+6gP93/30
         VX1w4zbraCPfoImGffTywiI8CH3+Q4foqDTfJ/CsHJN7DFcNOinNjMKIwIg1dU4PejDa
         85+g==
X-Gm-Message-State: AOAM533fIUvR5LigBGiLvN6czPwXKHddkynIo5rwRrL4oiWcPwUFOeU7
        pbHuM+oxM9UeIsyi4j4N7ucoKD/TIwitOA==
X-Google-Smtp-Source: ABdhPJwPbo0K0G4ak9o4in4lTp9662eXAkNuBO+m2YfWhJBYOSEs8AJNY3EOrOHmvQuk+mj1mPzKcQ==
X-Received: by 2002:a4a:8701:: with SMTP id z1mr6056463ooh.68.1639862420605;
        Sat, 18 Dec 2021 13:20:20 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id x13sm2332785otr.58.2021.12.18.13.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:20 -0800 (PST)
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
Subject: [PATCH 01/17] all: don't use bitmap_weight() where possible
Date:   Sat, 18 Dec 2021 13:19:57 -0800
Message-Id: <20211218212014.1315894-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't call bitmap_weight() if the following code can get by
without it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c           | 6 +-----
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 +-----
 drivers/thermal/intel/intel_powerclamp.c   | 9 +++------
 3 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3867f3d4545f..9a10d80125d9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1620,12 +1620,8 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 		return 0;
 	}
 
-	if (bitmap_weight(free_bins, dev->num_arl_bins) == 0)
-		return -ENOSPC;
-
 	*idx = find_first_bit(free_bins, dev->num_arl_bins);
-
-	return -ENOENT;
+	return *idx >= dev->num_arl_bins ? -ENOSPC : -ENOENT;
 }
 
 static int b53_arl_op(struct b53_device *dev, int op, int port,
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 40933bf5a710..241696fdc6c7 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2177,13 +2177,9 @@ static int bcm_sysport_rule_set(struct bcm_sysport_priv *priv,
 	if (nfc->fs.ring_cookie != RX_CLS_FLOW_WAKE)
 		return -EOPNOTSUPP;
 
-	/* All filters are already in use, we cannot match more rules */
-	if (bitmap_weight(priv->filters, RXCHK_BRCM_TAG_MAX) ==
-	    RXCHK_BRCM_TAG_MAX)
-		return -ENOSPC;
-
 	index = find_first_zero_bit(priv->filters, RXCHK_BRCM_TAG_MAX);
 	if (index >= RXCHK_BRCM_TAG_MAX)
+		/* All filters are already in use, we cannot match more rules */
 		return -ENOSPC;
 
 	/* Location is the classification ID, and index is the position
diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 14256421d98c..c841ab37e7c6 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -556,12 +556,9 @@ static void end_power_clamp(void)
 	 * stop faster.
 	 */
 	clamping = false;
-	if (bitmap_weight(cpu_clamping_mask, num_possible_cpus())) {
-		for_each_set_bit(i, cpu_clamping_mask, num_possible_cpus()) {
-			pr_debug("clamping worker for cpu %d alive, destroy\n",
-				 i);
-			stop_power_clamp_worker(i);
-		}
+	for_each_set_bit(i, cpu_clamping_mask, num_possible_cpus()) {
+		pr_debug("clamping worker for cpu %d alive, destroy\n", i);
+		stop_power_clamp_worker(i);
 	}
 }
 
-- 
2.30.2

