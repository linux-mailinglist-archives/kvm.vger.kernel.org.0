Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB76D479CE6
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhLRVUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbhLRVUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:20:25 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1217BC06173F;
        Sat, 18 Dec 2021 13:20:25 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id t23so9358441oiw.3;
        Sat, 18 Dec 2021 13:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZRDbXQndZB+h1W3grije4oLm88mhsLSCo0DvJeL0oOc=;
        b=RbLh966dNM6Q9dumAKT/s67Li0XDMiqpqy9QDRjKZ7xykviae8HUZGbBK4++gzts9+
         4HWimSnZbbp981RdIy4mUiEPi5KNC27XZMzAqhbLAbSCXpzsa6pdkKTooARlGNlTUTY6
         JoyuKChgIL/vGpnEuqm73H3imSDYRcmkvOW7G88lNj2P4DJILBf/LhHA1ZwruMX1IzE2
         L/mAlIYrOkdOM5wMkeJ8+xwn6+2dLufPFudFw0L+ol31R0QIHi6gU0asPbGQ0WpcgUYF
         TKKLWiuHi4Ipvj4eEi1DnTT9o6ibI9n5SLfH6H9ye6clD987ERDreQoQOmClSh/YKHYJ
         9wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZRDbXQndZB+h1W3grije4oLm88mhsLSCo0DvJeL0oOc=;
        b=1/rsUcLANJ/DdYeEdqzynzT+7Ohpn5Mk54qtT9njcfi9KN48ynw9CwE6zFvsA/TmcP
         U8d19vkLI3+vfT99Lr/kcZsKa25oc/6uquXuNtWBmxtuIamXW8gMIuHibbL26YjuCV4f
         3VxjCMZzN2hiMq00tQVunpeYGl94J848n3g1yn9soDMpdNwzO7OciaTV1DUgNaX2AHWI
         FZHPTb/QpNPLnvCoh4CRfkx9nYu4VD+6ZXisVb0fbywwYDPsqgtgnvUQptDwfd9Ewmgm
         qPHF4SDa5au5eA0RqD8RcpKP4DyN1RLNVBokdRs5MZieaIScTDVFjxa1clr0ogJH+JNx
         k/Cg==
X-Gm-Message-State: AOAM5337nziDsxGI9ct+s3TfhDcpG65cjA0jv9zmDtJhzS7MySrwNPnv
        j/fipfwFFwKkTW5MBzkbiwyY7ABHPMHgrQ==
X-Google-Smtp-Source: ABdhPJxshh8wZNTv7Y9Ku4jyb7QQxFrS/1r/onV0bhXisp6AJbbov2WJDwCGNF7Hkx62Pk9+Bq0Ozw==
X-Received: by 2002:a05:6808:159a:: with SMTP id t26mr13219038oiw.106.1639862424104;
        Sat, 18 Dec 2021 13:20:24 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 186sm2409379oig.28.2021.12.18.13.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:23 -0800 (PST)
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
Subject: [PATCH 02/17] drivers: rename num_*_cpus variables
Date:   Sat, 18 Dec 2021 13:19:58 -0800
Message-Id: <20211218212014.1315894-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some drivers declare num_active_cpus and num_present_cpus,
despite that kernel has macros with corresponding names in
linux/cpumask.h, and the drivers include cpumask.h

The following patches switch num_*_cpus() to real functions,
which causes build failures for the drivers.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/leds/trigger/ledtrig-cpu.c | 6 +++---
 drivers/scsi/storvsc_drv.c         | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-cpu.c b/drivers/leds/trigger/ledtrig-cpu.c
index 8af4f9bb9cde..767e9749ca41 100644
--- a/drivers/leds/trigger/ledtrig-cpu.c
+++ b/drivers/leds/trigger/ledtrig-cpu.c
@@ -39,7 +39,7 @@ struct led_trigger_cpu {
 static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
 
 static struct led_trigger *trig_cpu_all;
-static atomic_t num_active_cpus = ATOMIC_INIT(0);
+static atomic_t _active_cpus = ATOMIC_INIT(0);
 
 /**
  * ledtrig_cpu - emit a CPU event as a trigger
@@ -79,8 +79,8 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
 
 		/* Update trigger state */
 		trig->is_active = is_active;
-		atomic_add(is_active ? 1 : -1, &num_active_cpus);
-		active_cpus = atomic_read(&num_active_cpus);
+		atomic_add(is_active ? 1 : -1, &_active_cpus);
+		active_cpus = atomic_read(&_active_cpus);
 		total_cpus = num_present_cpus();
 
 		led_trigger_event(trig->_trig,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 20595c0ba0ae..705dd4ebde98 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1950,7 +1950,7 @@ static int storvsc_probe(struct hv_device *device,
 {
 	int ret;
 	int num_cpus = num_online_cpus();
-	int num_present_cpus = num_present_cpus();
+	int present_cpus = num_present_cpus();
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
@@ -2060,7 +2060,7 @@ static int storvsc_probe(struct hv_device *device,
 	 * Set the number of HW queues we are supporting.
 	 */
 	if (!dev_is_ide) {
-		if (storvsc_max_hw_queues > num_present_cpus) {
+		if (storvsc_max_hw_queues > present_cpus) {
 			storvsc_max_hw_queues = 0;
 			storvsc_log(device, STORVSC_LOGGING_WARN,
 				"Resetting invalid storvsc_max_hw_queues value to default.\n");
@@ -2068,7 +2068,7 @@ static int storvsc_probe(struct hv_device *device,
 		if (storvsc_max_hw_queues)
 			host->nr_hw_queues = storvsc_max_hw_queues;
 		else
-			host->nr_hw_queues = num_present_cpus;
+			host->nr_hw_queues = present_cpus;
 	}
 
 	/*
-- 
2.30.2

