Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35596640652
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiLBMD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiLBMDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:03:19 -0500
X-Greylist: delayed 362 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 04:03:06 PST
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4A0CEFAD
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 04:03:05 -0800 (PST)
Date:   Fri, 2 Dec 2022 12:56:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669982220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8n/vK/WOSbOsClkGDhAK0CvftwDdaWs0NBny6WN4ds=;
        b=i8FUtuszmkmH/eBSQ8A0A5lK/MJZOXZYnfyGqdlCtGXsLL8iuUFkHCJozfaon7M2hJfQjI
        h6XInaoBC8pbxcxhZE4YySINo4qtfP790MAvBnhMqSXQ+qQyz493pcoOG7EfqWtZsQn6Wl
        rwQ3b7Jd3jJURdVa/U/z5t4UxYCmhnE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] arm: use migrate_once() in
 migration tests
Message-ID: <20221202115658.kx7zn6qod24ddt6x@kamzik>
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
 <20221130142249.3558647-5-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130142249.3558647-5-nrb@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 03:22:49PM +0100, Nico Boehr wrote:
> Some tests already shipped with their own do_migrate() function, remove
> it and instead use the new migrate_once() function. The control flow in
> the gib tests can be simplified due to migrate_once().

s/gib/gic/

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  arm/Makefile.common |  1 +
>  arm/debug.c         | 14 ++++---------
>  arm/gic.c           | 49 +++++++++++++--------------------------------
>  3 files changed, 19 insertions(+), 45 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 38385e0c558e..1bbec64f2342 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
> +cflatobjs += lib/migrate.o
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-host-generic.o
>  cflatobjs += lib/pci-testdev.o
> diff --git a/arm/debug.c b/arm/debug.c
> index e9f805632db7..21b0f5aeb590 100644
> --- a/arm/debug.c
> +++ b/arm/debug.c
> @@ -1,4 +1,5 @@
>  #include <libcflat.h>
> +#include <migrate.h>
>  #include <errata.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
> @@ -257,13 +258,6 @@ static void reset_debug_state(void)
>  	isb();
>  }
>  
> -static void do_migrate(void)
> -{
> -	puts("Now migrate the VM, then press a key to continue...\n");
> -	(void)getchar();
> -	report_info("Migration complete");
> -}
> -
>  static noinline void test_hw_bp(bool migrate)
>  {
>  	extern unsigned char hw_bp0;
> @@ -291,7 +285,7 @@ static noinline void test_hw_bp(bool migrate)
>  	isb();
>  
>  	if (migrate) {
> -		do_migrate();
> +		migrate_once();
>  		report(num_bp == get_num_hw_bp(), "brps match after migrate");
>  	}
>  
> @@ -335,7 +329,7 @@ static noinline void test_wp(bool migrate)
>  	isb();
>  
>  	if (migrate) {
> -		do_migrate();
> +		migrate_once();
>  		report(num_wp == get_num_wp(), "wrps match after migrate");
>  	}
>  
> @@ -369,7 +363,7 @@ static noinline void test_ss(bool migrate)
>  	isb();
>  
>  	if (migrate) {
> -		do_migrate();
> +		migrate_once();
>  	}

While here, please opportunistically drop the unnecessary {}

>  
>  	asm volatile("msr daifclr, #8");
> diff --git a/arm/gic.c b/arm/gic.c
> index 60457e29e73a..c950b0d1597c 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -12,6 +12,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <migrate.h>
>  #include <errata.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
> @@ -779,23 +780,15 @@ static void test_its_trigger(void)
>  static void test_its_migration(void)
>  {
>  	struct its_device *dev2, *dev7;
> -	bool test_skipped = false;
>  	cpumask_t mask;
>  
> -	if (its_setup1()) {
> -		test_skipped = true;
> -		goto do_migrate;
> -	}
> +	if (its_setup1())
> +		return;
>  
>  	dev2 = its_get_device(2);
>  	dev7 = its_get_device(7);
>  
> -do_migrate:
> -	puts("Now migrate the VM, then press a key to continue...\n");
> -	(void)getchar();
> -	report_info("Migration complete");
> -	if (test_skipped)
> -		return;
> +	migrate_once();
>  
>  	stats_reset();
>  	cpumask_clear(&mask);
> @@ -822,21 +815,17 @@ static void test_migrate_unmapped_collection(void)
>  {
>  	struct its_collection *col = NULL;
>  	struct its_device *dev2 = NULL, *dev7 = NULL;
> -	bool test_skipped = false;
>  	cpumask_t mask;
>  	int pe0 = 0;
>  	u8 config;
>  
> -	if (its_setup1()) {
> -		test_skipped = true;
> -		goto do_migrate;
> -	}
> +	if (its_setup1())
> +		return;
>  
>  	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>  		report_skip("Skipping test, as this test hangs without the fix. "
>  			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> -		test_skipped = true;
> -		goto do_migrate;
> +		return;
>  	}
>  
>  	col = its_create_collection(pe0, pe0);
> @@ -847,12 +836,7 @@ static void test_migrate_unmapped_collection(void)
>  	its_send_mapti(dev2, 8192, 0, col);
>  	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
>  
> -do_migrate:
> -	puts("Now migrate the VM, then press a key to continue...\n");
> -	(void)getchar();
> -	report_info("Migration complete");
> -	if (test_skipped)
> -		return;
> +	migrate_once();
>  
>  	/* on the destination, map the collection */
>  	its_send_mapc(col, true);
> @@ -887,15 +871,12 @@ static void test_its_pending_migration(void)
>  	struct its_collection *collection[2];
>  	int *expected = calloc(nr_cpus, sizeof(int));
>  	int pe0 = nr_cpus - 1, pe1 = nr_cpus - 2;
> -	bool test_skipped = false;
>  	u64 pendbaser;
>  	void *ptr;
>  	int i;
>  
> -	if (its_prerequisites(4)) {
> -		test_skipped = true;
> -		goto do_migrate;
> -	}
> +	if (its_prerequisites(4))
> +		return;
>  
>  	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>  	its_send_mapd(dev, true);
> @@ -942,12 +923,7 @@ static void test_its_pending_migration(void)
>  	gicv3_lpi_rdist_enable(pe0);
>  	gicv3_lpi_rdist_enable(pe1);
>  
> -do_migrate:
> -	puts("Now migrate the VM, then press a key to continue...\n");
> -	(void)getchar();
> -	report_info("Migration complete");
> -	if (test_skipped)
> -		return;
> +	migrate_once();
>  
>  	/* let's wait for the 256 LPIs to be handled */
>  	mdelay(1000);
> @@ -994,14 +970,17 @@ int main(int argc, char **argv)
>  	} else if (!strcmp(argv[1], "its-migration")) {
>  		report_prefix_push(argv[1]);
>  		test_its_migration();
> +		migrate_once();
>  		report_prefix_pop();
>  	} else if (!strcmp(argv[1], "its-pending-migration")) {
>  		report_prefix_push(argv[1]);
>  		test_its_pending_migration();
> +		migrate_once();
>  		report_prefix_pop();
>  	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
>  		report_prefix_push(argv[1]);
>  		test_migrate_unmapped_collection();
> +		migrate_once();
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>  		report_prefix_push(argv[1]);
> -- 
> 2.36.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
