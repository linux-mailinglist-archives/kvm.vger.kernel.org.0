Return-Path: <kvm+bounces-9170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F4085B8EF
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C43841F260E6
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0799612C6;
	Tue, 20 Feb 2024 10:22:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BDCC5FDC5
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708424558; cv=none; b=Fnojcqzeo/Lyk2VepF0gZ2nFGYcWwETqmqAn+FxQNESEowbXhQi5YeXfSWLCeRdW5qWrAPxOvR18SldCCugyYoDjRp1KcQKL+qVXLCb+PAoRFukNNPsrIcyk/ALSP1qoZiiw/GTiuSuZpcMEGb1f9RcMcZsxbfWfunBoOzhNz80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708424558; c=relaxed/simple;
	bh=/VqLVMvwa2XWdYu6FEqTeiDwLlBH7WA1gb9JFElUk/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbxDX1AEa4enKZ+FCfHkbe37e1b6iXtI0rTtJummNlk0MfLzDnezcMD5mxPSAZWDlLyzB2xXyMNyzqv5yivF93mwezC5vR2P/EirL/KHTbn0g0nEwI/gn05k/BDaW48yCQY89w5cdCtrDHz9OD3shPMiby+WxkXWJbGnGVSE4AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8C2AFEC;
	Tue, 20 Feb 2024 02:23:14 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68DA23F762;
	Tue, 20 Feb 2024 02:22:34 -0800 (PST)
Date: Tue, 20 Feb 2024 10:22:25 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <ZdR9Yb-XGKyuhFOL@raptor>
References: <20240216140210.70280-1-thuth@redhat.com>
 <ZdOIJfvVm7C23ZdZ@raptor>
 <CZ9S150A3M1Y.1HVL51OVY2ZW8@wheely>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CZ9S150A3M1Y.1HVL51OVY2ZW8@wheely>

Hi,

On Tue, Feb 20, 2024 at 06:51:51PM +1000, Nicholas Piggin wrote:
> On Tue Feb 20, 2024 at 2:56 AM AEST, Alexandru Elisei wrote:
> > Hi,
> >
> > Thanks for writing this. I've tested it with kvmtool, which emulates a 8250
> > UART:
> >
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > This fixes a longstanding bug with kvmtool, where migrate_once() would read
> > the last character that was sent, and then think that migration was
> > completed even though it was never performed.
> >
> > While we are on the subject of migration:
> >
> > SKIP: gicv3: its-migration: Test requires at least 4 vcpus
> > Now migrate the VM, then press a key to continue...
> > INFO: gicv3: its-migration: Migration complete
> > SUMMARY: 1 tests, 1 skipped
> >
> > That's extremely confusing. Why is migrate_once() executed after the
> > test_its_pending() function call without checking if the test was skipped?
> 
> Seems not too hard, incremental patch on top of multi migration
> series below. After this series is merged I can try that (s390
> could benefit with some changes too).

Thank you for having a look at this so quickly. The changes to the gic test
look good to me.

As an alternative, have you considered modifying the test harness to parse
the SKIP message, and if the test is in the migration group to not mark it
as a migration failure? That would require that the test name printed by a
test matches the test name from unittests.cfg (should probably be the case
already), but any new migration tests will just work, without having to put
migrate_skip() at each failure point.

Thanks,
Alex

> 
> Thanks,
> Nick
> 
> ---
> diff --git a/arm/gic.c b/arm/gic.c
> index c950b0d15..bbf828f17 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -782,13 +782,15 @@ static void test_its_migration(void)
>  	struct its_device *dev2, *dev7;
>  	cpumask_t mask;
>  
> -	if (its_setup1())
> +	if (its_setup1()) {
> +		migrate_skip();
>  		return;
> +	}
>  
>  	dev2 = its_get_device(2);
>  	dev7 = its_get_device(7);
>  
> -	migrate_once();
> +	migrate();
>  
>  	stats_reset();
>  	cpumask_clear(&mask);
> @@ -819,8 +821,10 @@ static void test_migrate_unmapped_collection(void)
>  	int pe0 = 0;
>  	u8 config;
>  
> -	if (its_setup1())
> +	if (its_setup1()) {
> +		migrate_skip();
>  		return;
> +	}
>  
>  	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>  		report_skip("Skipping test, as this test hangs without the fix. "
> @@ -836,7 +840,7 @@ static void test_migrate_unmapped_collection(void)
>  	its_send_mapti(dev2, 8192, 0, col);
>  	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
>  
> -	migrate_once();
> +	migrate();
>  
>  	/* on the destination, map the collection */
>  	its_send_mapc(col, true);
> @@ -875,8 +879,10 @@ static void test_its_pending_migration(void)
>  	void *ptr;
>  	int i;
>  
> -	if (its_prerequisites(4))
> +	if (its_prerequisites(4)) {
> +		migrate_skip();
>  		return;
> +	}
>  
>  	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>  	its_send_mapd(dev, true);
> @@ -923,7 +929,7 @@ static void test_its_pending_migration(void)
>  	gicv3_lpi_rdist_enable(pe0);
>  	gicv3_lpi_rdist_enable(pe1);
>  
> -	migrate_once();
> +	migrate();
>  
>  	/* let's wait for the 256 LPIs to be handled */
>  	mdelay(1000);
> @@ -970,17 +976,14 @@ int main(int argc, char **argv)
>  	} else if (!strcmp(argv[1], "its-migration")) {
>  		report_prefix_push(argv[1]);
>  		test_its_migration();
> -		migrate_once();
>  		report_prefix_pop();
>  	} else if (!strcmp(argv[1], "its-pending-migration")) {
>  		report_prefix_push(argv[1]);
>  		test_its_pending_migration();
> -		migrate_once();
>  		report_prefix_pop();
>  	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
>  		report_prefix_push(argv[1]);
>  		test_migrate_unmapped_collection();
> -		migrate_once();
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>  		report_prefix_push(argv[1]);
> diff --git a/lib/migrate.c b/lib/migrate.c
> index 92d1d957d..dde43a90e 100644
> --- a/lib/migrate.c
> +++ b/lib/migrate.c
> @@ -43,3 +43,13 @@ void migrate_once(void)
>  	migrated = true;
>  	migrate();
>  }
> +
> +/*
> + * When the test has been started in migration mode, but the test case is
> + * skipped and no migration point is reached, this can be used to tell the
> + * harness not to mark it as a failure to migrate.
> + */
> +void migrate_skip(void)
> +{
> +	puts("Skipped VM migration (quiet)\n");
> +}
> diff --git a/lib/migrate.h b/lib/migrate.h
> index 95b9102b0..db6e0c501 100644
> --- a/lib/migrate.h
> +++ b/lib/migrate.h
> @@ -9,3 +9,5 @@
>  void migrate(void);
>  void migrate_quiet(void);
>  void migrate_once(void);
> +
> +void migrate_skip(void);
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 2214d940c..3257d5218 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -152,7 +152,9 @@ run_migration ()
>  		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
>  		-mon chardev=mon,mode=control > ${src_outfifo} &
>  	live_pid=$!
> -	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
> +	cat ${src_outfifo} | tee ${src_out} | \
> +		grep -v "Now migrate the VM (quiet)" | \
> +		grep -v "Skipped VM migration (quiet)" &
>  
>  	# Start the first destination QEMU machine in advance of the test
>  	# reaching the migration point, since we expect at least one migration.
> @@ -190,16 +192,22 @@ do_migration ()
>  		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
>  		< <(cat ${dst_infifo}) > ${dst_outfifo} &
>  	incoming_pid=$!
> -	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
> +	cat ${dst_outfifo} | tee ${dst_out} | \
> +		grep -v "Now migrate the VM (quiet)" | \
> +		grep -v "Skipped VM migration (quiet)" &
>  
>  	# The test must prompt the user to migrate, so wait for the
>  	# "Now migrate VM" console message.
>  	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
>  		if ! ps -p ${live_pid} > /dev/null ; then
> -			echo "ERROR: Test exit before migration point." >&2
>  			echo > ${dst_infifo}
> -			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
>  			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
> +			if grep -q -i "Skipped VM migration" < ${src_out} ; then
> +				wait ${live_pid}
> +				return $?
> +			fi
> +			echo "ERROR: Test exit before migration point." >&2
> +			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
>  			return 3
>  		fi
>  		sleep 0.1

