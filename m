Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EE4479D34
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhLRVWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbhLRVVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:21:04 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64AFC061784;
        Sat, 18 Dec 2021 13:20:56 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso7463366ots.6;
        Sat, 18 Dec 2021 13:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Hec35lasK9ZA9Al4lVu2VLAlB7ZGIYc9EtAwCKNTlw8=;
        b=fBftgt78xMj1xKG5HZZwIKhKCaPNvVnrKaDadtsATTpbsWGFVP5e7HSashlaWMcwqO
         LGw9PZb24tpFErLVXHUlIglhlIamlRCnbPR5OsIzGuKEIH1AURNfV/dBdfTBQoYJvzuO
         vJHwptAoNFqOBC8BK+K0vkVFi+BHhxI0ibPZCe0ZoMw3oErF2aHMJ2Qi5YW1XoA/0FmX
         DvxauUzfNVo2yGxIRxf4OdPGCp1xAi9orXiOGorjkgyc4oijxQ3LsGsYHHg9DqrmgOxo
         d9gh/VCFcHiQ0ntVUwmhI9B1jfed7aIsK1FoKUVaewVhnEosQJQvZUV3oMwwmTiQqF/E
         EGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hec35lasK9ZA9Al4lVu2VLAlB7ZGIYc9EtAwCKNTlw8=;
        b=LPAwEFBDo3JGMCKNuBJ1D8uS361EvIU89VAymVyz23WrLBjSs/KzR9zzyvuhtURHab
         PsAZsGrolV/cQrATcVf6ZVtE3qMVOfuhaJhlS9VCUjg5c/H0MhTco9J39j/odYY5JE0i
         7MJhCF/4gDO7Y3kWcOcoXPHWLbrIntUpqPMDbH/ScsZ3sVvOl2zdOgLAOMPYi8ypWVLu
         bzWxT0lGBQ9bpxNMkydkxbp8an34nrPKDWTBCAVzR7nFrs7HhB6HDMJQrAqwLWs8BN5y
         04d49b8j2UViYCN8Mk1M73QY5xNDzH6LPWauDfGccv2J94FiLPhfd2EvSX9ndMhGshAG
         lWeA==
X-Gm-Message-State: AOAM530qp1GPWnevCC73EJjZuaiYfZaRAmmdidXN1d+QUvB779iCkgK1
        i7HcOJ52UA6sakrwWLGzV6nB0gK5vXBN6g==
X-Google-Smtp-Source: ABdhPJyF3ZGCXzeXjVp/KVuej2Lro/GR2ZMmRe4CsBC/6he5KNwSmag2n9ENl7goEuOdRGP79z0Maw==
X-Received: by 2002:a9d:2d81:: with SMTP id g1mr6637050otb.25.1639862455926;
        Sat, 18 Dec 2021 13:20:55 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id n23sm2383616oic.26.2021.12.18.13.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:55 -0800 (PST)
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
Subject: [PATCH 12/17] kernel/cpu.c: fix init_cpu_online
Date:   Sat, 18 Dec 2021 13:20:08 -0800
Message-Id: <20211218212014.1315894-13-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpu_online_mask has an associate counter of online cpus, which should be
initialized in init_cpu_online()

Fixes: 0c09ab96fc82010 (cpu/hotplug: Cache number of online CPUs)
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 407a2568f35e..cd7605204d4d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2616,6 +2616,7 @@ void init_cpu_possible(const struct cpumask *src)
 void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(&__cpu_online_mask, src);
+	atomic_set(&__num_online_cpus, cpumask_weight(cpu_online_mask));
 }
 
 void set_cpu_online(unsigned int cpu, bool online)
-- 
2.30.2

