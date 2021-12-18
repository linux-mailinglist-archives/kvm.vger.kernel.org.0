Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A97479D3E
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhLRVWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhLRVVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:21:41 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC81C0617A2;
        Sat, 18 Dec 2021 13:20:59 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so7466458otg.4;
        Sat, 18 Dec 2021 13:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TtB4s+TeH5Hsx4aMsA8zovfLkC56GGSxZAM2kKc/k+s=;
        b=JpKKkwINU8Ydvnyx9TIa0uTEfLIEeORqwMjlt2cBKjHjbDtmjXYoAYcpkHvWOACNZ+
         JClsTJjPz351JiBL5YkKHmfgQb6Bs9RYm3XbiLNQpBXdxk6fSPpeP/UdvMr1JZgJmzOO
         3zd+x9XrwW0Ta4OedkblF2OTR3HDwbCAnWpcgXnJtqaKYqgdIUsODPw8Wp+KaP/4tQcA
         9zIa24wEaUYy2nK+3lrBCplwLyxuKdWlNpxyOXXoiOONLC5fupt6hpsq3NiXG/6pQoSG
         wtOhHaiB3EGda/k0PB3OUJtDVXKKoy2mUG5TqWrYE76xWrWSeHaSuRq4yt4Mp1WKWa5j
         aevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TtB4s+TeH5Hsx4aMsA8zovfLkC56GGSxZAM2kKc/k+s=;
        b=Pt8E4/vNliRk4hdHGjcUYqHfJCdnQWN4wF+TxZl45QIqCd1XN6+iHExf+E4mwmnqYQ
         olqgYZNAaSHnwQidh8Baj71U+5hC0CQT/FTCJonwkOKQqsAJ2RcYnjM7S6wgqGulhSjg
         nRMQQDDtwXaSy5yK88VHmrLhLp3eWwUS/ss/X4lo7J1LYI4sNniDvP/MVzoCClORzobY
         vGu7cr1PCAu2Q4N1aPiVWAxnBf4nQIAxrKHMPTjhLfkohbEej2n8bHTDDVBtTzOE+dL+
         WpCdEgLV7cAb/1PeL57nqax0umDVLiMvt7tiRTCesTbtkqPOaSSszRWVKNzJ6yuP7CUf
         tXIw==
X-Gm-Message-State: AOAM532Gsak03OtrkjH3VusZGgO8kqXiRJOe/huYSk4isu5I1zsgGqy+
        7HOJkxNUIttQ4762g5ywA/aoV0HqWG0w2g==
X-Google-Smtp-Source: ABdhPJz65aswwCqCKcm3NSepL1No7Bu916BAt7YX/+A7MjCUNmyZSZaKJNIPfs9JYRO4CobDyeY4pQ==
X-Received: by 2002:a05:6830:10:: with SMTP id c16mr6492562otp.79.1639862459100;
        Sat, 18 Dec 2021 13:20:59 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id e21sm2358431ote.72.2021.12.18.13.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:58 -0800 (PST)
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
Subject: [PATCH 13/17] kernel/cpu: add num_possible_cpus counter
Date:   Sat, 18 Dec 2021 13:20:09 -0800
Message-Id: <20211218212014.1315894-14-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similarly to the online cpus, the cpu_possible_mask is actively used
in the kernel. This patch adds a counter for possible cpus, so that
users that call num_possible_cpus() would know the result immediately,
instead of calling the bitmap_weight for the mask underlying.

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h | 30 ++++++++++++++++--------------
 kernel/cpu.c            | 22 ++++++++++++++++++++++
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1906e3225737..0be2504d8e4c 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -99,6 +99,7 @@ extern struct cpumask __cpu_dying_mask;
 #define cpu_dying_mask    ((const struct cpumask *)&__cpu_dying_mask)
 
 extern atomic_t __num_online_cpus;
+extern atomic_t __num_possible_cpus;
 
 extern cpumask_t cpus_booted_once_mask;
 
@@ -870,19 +871,8 @@ void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
 
-static inline void reset_cpu_possible_mask(void)
-{
-	bitmap_zero(cpumask_bits(&__cpu_possible_mask), NR_CPUS);
-}
-
-static inline void
-set_cpu_possible(unsigned int cpu, bool possible)
-{
-	if (possible)
-		cpumask_set_cpu(cpu, &__cpu_possible_mask);
-	else
-		cpumask_clear_cpu(cpu, &__cpu_possible_mask);
-}
+void set_cpu_possible(unsigned int cpu, bool possible);
+void reset_cpu_possible_mask(void);
 
 static inline void
 set_cpu_present(unsigned int cpu, bool present)
@@ -962,7 +952,19 @@ static inline unsigned int num_online_cpus(void)
 {
 	return atomic_read(&__num_online_cpus);
 }
-#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+
+/**
+ * num_possible_cpus() - Read the number of possible CPUs
+ *
+ * Despite the fact that __num_possible_cpus is of type atomic_t, this
+ * interface gives only a momentary snapshot and is not protected against
+ * concurrent CPU hotplug operations unless invoked from a cpuhp_lock held
+ * region.
+ */
+static inline unsigned int num_possible_cpus(void)
+{
+	return atomic_read(&__num_possible_cpus);
+}
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index cd7605204d4d..a0a815911173 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2583,10 +2583,13 @@ EXPORT_SYMBOL(cpu_all_bits);
 #ifdef CONFIG_INIT_ALL_POSSIBLE
 struct cpumask __cpu_possible_mask __read_mostly
 	= {CPU_BITS_ALL};
+atomic_t __num_possible_cpus __read_mostly = ATOMIC_INIT(NR_CPUS);
 #else
 struct cpumask __cpu_possible_mask __read_mostly;
+atomic_t __num_possible_cpus __read_mostly;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
+EXPORT_SYMBOL(__num_possible_cpus);
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
@@ -2611,6 +2614,7 @@ void init_cpu_present(const struct cpumask *src)
 void init_cpu_possible(const struct cpumask *src)
 {
 	cpumask_copy(&__cpu_possible_mask, src);
+	atomic_set(&__num_possible_cpus, cpumask_weight(cpu_possible_mask));
 }
 
 void init_cpu_online(const struct cpumask *src)
@@ -2640,6 +2644,24 @@ void set_cpu_online(unsigned int cpu, bool online)
 	}
 }
 
+void reset_cpu_possible_mask(void)
+{
+	bitmap_zero(cpumask_bits(&__cpu_possible_mask), NR_CPUS);
+	atomic_set(&__num_possible_cpus, 0);
+}
+
+void set_cpu_possible(unsigned int cpu, bool possible)
+{
+	if (possible) {
+		if (!cpumask_test_and_set_cpu(cpu, &__cpu_possible_mask))
+			atomic_inc(&__num_possible_cpus);
+	} else {
+		if (cpumask_test_and_clear_cpu(cpu, &__cpu_possible_mask))
+			atomic_dec(&__num_possible_cpus);
+	}
+}
+EXPORT_SYMBOL(set_cpu_possible);
+
 /*
  * Activate the first processor.
  */
-- 
2.30.2

