Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7127564BAF2
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiLMR2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiLMR2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:28:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE9E1AD85
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:28:05 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGqiTQ017657
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0TkKQCpSIJdyfDD/qJ31ht0v030MSnCeI0JjGYAV+4w=;
 b=tjtII0GG3gDvqbnDFql1Zrgz6PJ+W6byqT3UDSaktzTfM2c5anigHi+/E2jIJdOKjwyS
 Srcg6JVaLGp0oU/IUq2PglcPe6S7b2nUWz8ljJd5Tfvhbijta73usYqY5Zwj4/8JimVD
 Eh7jmuvsywkRRSLhP6X0swP54HMTLAejlSKFZixBfr25dN70RsabQTZtjWc5GWtx4s0s
 ZFE1zhs6yhKW1cjjP6VAcNEDl/zqRUuuuO2qhO4q2nvrGpmdprUWAQJrgBDgtiRlSv9h
 A9WBNk9Wbeq6cc8bIiJbdcCzonEcwoKpdMBWKWlKA5winNbpFecgdYQaX+TtNu4DvJ0N vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mewa5s03q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:28:05 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDGrEb3020979
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:28:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mewa5s02y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:28:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDHHegA028342;
        Tue, 13 Dec 2022 17:28:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mchr64gwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:28:02 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDHRwGo51708326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:27:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37E1020049;
        Tue, 13 Dec 2022 17:27:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D00F20043;
        Tue, 13 Dec 2022 17:27:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 17:27:57 +0000 (GMT)
Date:   Tue, 13 Dec 2022 18:27:56 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
Message-ID: <20221213182756.0e3d2643@p-imbrenda>
In-Reply-To: <20221209102122.447324-2-nrb@linux.ibm.com>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
        <20221209102122.447324-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YO-_0JEhTfKPcLl3BziGdCphc92hyPTP
X-Proofpoint-GUID: E7wfpvZrkGcSsdLOVpQV-QoU6XmNvEwg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212130151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  9 Dec 2022 11:21:22 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Right now, we have a test which sets storage keys, then migrates the VM
> and - after migration finished - verifies the skeys are still there.
> 
> Add a new version of the test which changes storage keys while the
> migration is in progress. This is achieved by adding a command line
> argument to the existing migration-skey test.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

looks good, except for a few small details below

> ---
>  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
>  s390x/unittests.cfg    |  15 ++-
>  2 files changed, 198 insertions(+), 31 deletions(-)
> 
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> index b7bd82581abe..9b9a45f4ad3b 100644
> --- a/s390x/migration-skey.c
> +++ b/s390x/migration-skey.c
> @@ -2,6 +2,12 @@
>  /*
>   * Storage Key migration tests
>   *
> + * There are two variants of this test:
> + * - sequential: sets some storage keys on pages, migrates the VM and then
> + *   verifies the storage keys are still as we expect.
> + * - parallel: start migration of a VM and set and check storage keys on some
> + *   pages while migration is in process.
> + *
>   * Copyright IBM Corp. 2022
>   *
>   * Authors:
> @@ -10,20 +16,44 @@
>  
>  #include <libcflat.h>
>  #include <asm/facility.h>
> -#include <asm/page.h>
>  #include <asm/mem.h>
> -#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/barrier.h>
>  #include <hardware.h>
> +#include <smp.h>
> +
> +struct skey_verify_result {
> +	bool verify_failed;
> +	union skey expected_key;
> +	union skey actual_key;
> +	unsigned long page_mismatch_idx;
> +	unsigned long page_mismatch_addr;
> +};
>  
>  #define NUM_PAGES 128
> -static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static struct skey_verify_result result;
>  
> -static void test_migration(void)
> +static unsigned int thread_iters;
> +static bool thread_should_exit;
> +static bool thread_exited;
> +
> +/*
> + * Set storage key test pattern on pagebuf with a seed for the storage keys.
> + *
> + * Each page's storage key is generated by taking the page's index in pagebuf,
> + * XOR-ing that with the given seed and then multipling the result with two.
> + *
> + * pagebuf must point to page_count consecutive pages.
> + * Only the lower seven bits of the seed are considered.
> + */
> +static void skey_set_test_pattern(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)
>  {
> -	union skey expected_key, actual_key;
> -	int i, key_to_set, key_mismatches = 0;
> +	unsigned char key_to_set;
> +	unsigned long i;
>  
> -	for (i = 0; i < NUM_PAGES; i++) {
> +	for (i = 0; i < page_count; i++) {
>  		/*
>  		 * Storage keys are 7 bit, lowest bit is always returned as zero
>  		 * by iske.
> @@ -31,16 +61,34 @@ static void test_migration(void)
>  		 * protection as well as reference and change indication for
>  		 * some keys.
>  		 */
> -		key_to_set = i * 2;
> -		set_storage_key(pagebuf[i], key_to_set, 1);
> +		key_to_set = (i ^ seed) * 2;
> +		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
>  	}
> +}
>  
> -	puts("Please migrate me, then press return\n");
> -	(void)getchar();
> +/*
> + * Verify storage keys on pagebuf.
> + * Storage keys must have been set by skey_set_test_pattern on pagebuf before.
> + * skey_set_keys must have been called with the same seed value.
> + *
> + * If storage keys match the expected result, will return a skey_verify_result
> + * with verify_failed false. All other fields are then invalid.
> + * If there is a mismatch, returned struct will have verify_failed true and will
> + * be filled with the details on the first mismatch encountered.
> + */
> +static struct skey_verify_result skey_verify_test_pattern(uint8_t *pagebuf, unsigned long page_count, unsigned char seed)

this line is a little too long, even for the KVM unit tests; find a way
to shorten it by a couple of bytes (it would look better to keep it on
one line)

(rename pagebuf? use size_t or uint64_t instead of unsigned long? use
uint8_t for seed? shorten the name of struct verify_result?)

> +{
> +	union skey expected_key, actual_key;
> +	struct skey_verify_result result = {
> +		.verify_failed = true
> +	};
> +	uint8_t *cur_page;
> +	unsigned long i;
>  
> -	for (i = 0; i < NUM_PAGES; i++) {
> -		actual_key.val = get_storage_key(pagebuf[i]);
> -		expected_key.val = i * 2;
> +	for (i = 0; i < page_count; i++) {
> +		cur_page = pagebuf + i * PAGE_SIZE;
> +		actual_key.val = get_storage_key(cur_page);
> +		expected_key.val = (i ^ seed) * 2;
>  
>  		/*
>  		 * The PoP neither gives a guarantee that the reference bit is
> @@ -51,33 +99,145 @@ static void test_migration(void)
>  		actual_key.str.rf = 0;
>  		expected_key.str.rf = 0;
>  
> -		/* don't log anything when key matches to avoid spamming the log */
>  		if (actual_key.val != expected_key.val) {
> -			key_mismatches++;
> -			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
> +			result.expected_key.val = expected_key.val;
> +			result.actual_key.val = actual_key.val;
> +			result.page_mismatch_idx = i;
> +			result.page_mismatch_addr = (unsigned long)cur_page;
> +			return result;
>  		}
>  	}
>  
> -	report(!key_mismatches, "skeys after migration match");
> +	result.verify_failed = false;
> +	return result;
> +}
> +
> +static void skey_report_verify(struct skey_verify_result * const result)
> +{
> +	if (result->verify_failed)
> +		report_fail("page skey mismatch: first page idx = %lu, addr = 0x%lx, "
> +			"expected_key = 0x%x, actual_key = 0x%x",
> +			result->page_mismatch_idx, result->page_mismatch_addr,
> +			result->expected_key.val, result->actual_key.val);
> +	else
> +		report_pass("skeys match");
> +}
> +
> +static void migrate_once(void)
> +{
> +	static bool migrated;
> +
> +	if (migrated)
> +		return;
> +
> +	migrated = true;
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
>  }

you don't need this any more, since your migration patches are
upstream now :)

>  
> -int main(void)
> +static void test_skey_migration_sequential(void)
> +{
> +	report_prefix_push("sequential");
> +
> +	skey_set_test_pattern(pagebuf, NUM_PAGES, 0);
> +
> +	migrate_once();
> +
> +	result = skey_verify_test_pattern(pagebuf, NUM_PAGES, 0);
> +	skey_report_verify(&result);
> +
> +	report_prefix_pop();
> +}
> +
> +static void set_skeys_thread(void)
> +{
> +	while (!READ_ONCE(thread_should_exit)) {
> +		skey_set_test_pattern(pagebuf, NUM_PAGES, thread_iters);
> +
> +		result = skey_verify_test_pattern(pagebuf, NUM_PAGES, thread_iters);
> +
> +		/*
> +		 * Always increment even if the verify fails. This ensures primary CPU knows where
> +		 * we left off and can do an additional verify round after migration finished.
> +		 */
> +		thread_iters++;
> +
> +		if (result.verify_failed)
> +			break;
> +	}
> +
> +	WRITE_ONCE(thread_exited, 1);
> +}
> +
> +static void test_skey_migration_parallel(void)
> +{
> +	report_prefix_push("parallel");
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_skip("need at least 2 cpus for this test");
> +		goto error;
> +	}
> +
> +	smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> +
> +	migrate_once();
> +
> +	WRITE_ONCE(thread_should_exit, 1);
> +
> +	while (!thread_exited)
> +		mb();

this was discussed in the other subthread :)

> +
> +	report_info("thread completed %u iterations", thread_iters);
> +
> +	report_prefix_push("during migration");
> +	skey_report_verify(&result);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Verification of skeys occurs on the thread. We don't know if we
> +	 * were still migrating during the verification.
> +	 * To be sure, make another verification round after the migration
> +	 * finished to catch skeys which might not have been migrated
> +	 * correctly.
> +	 */
> +	report_prefix_push("after migration");
> +	assert(thread_iters > 0);
> +	result = skey_verify_test_pattern(pagebuf, NUM_PAGES, thread_iters - 1);
> +	skey_report_verify(&result);
> +	report_prefix_pop();
> +
> +error:
> +	report_prefix_pop();
> +}
> +
> +static void print_usage(void)
> +{
> +	report_info("Usage: migration-skey [parallel|sequential]");
> +}
> +
> +int main(int argc, char **argv)
>  {
>  	report_prefix_push("migration-skey");
>  	if (test_facility(169)) {
>  		report_skip("storage key removal facility is active");
> +		goto error;
> +	}
>  
> -		/*
> -		 * If we just exit and don't ask migrate_cmd to migrate us, it
> -		 * will just hang forever. Hence, also ask for migration when we
> -		 * skip this test altogether.
> -		 */
> -		puts("Please migrate me, then press return\n");
> -		(void)getchar();
> +	if (argc < 2) {
> +		print_usage();
> +		goto error;
> +	}
> +
> +	if (!strcmp("parallel", argv[1])) {
> +		test_skey_migration_parallel();
> +	} else if (!strcmp("sequential", argv[1])) {
> +		test_skey_migration_sequential();
>  	} else {
> -		test_migration();
> +		print_usage();

hmm I don't like this whole main.

I think the best approach would be to have some kind of separate
parse_args function that will set some flags (or one flag, in this case)

then the main becomes just a bunch of if/else, something like this:

parse_args(argc, argv);
if (test_facility(169))
	skip
else if (parallel_flag)
	parallel();
else
	sequential();

also, default to sequential if there are no parameters, and use
posix-style parameters (--parallel, --sequential)

only if you get an invalid parameter you can print the usage and fail
optionally if you really want you can print the usage info when called
without parameter and inform that the test will default to sequential


one of these days I have to write an argument parsing library :)

>  	}
>  
> +error:
> +	migrate_once();
>  	report_prefix_pop();
>  	return report_summary();
>  }
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3caf81eda396..7763cb857954 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,10 +185,6 @@ smp = 2
>  file = migration-cmm.elf
>  groups = migration
>  
> -[migration-skey]
> -file = migration-skey.elf
> -groups = migration
> -
>  [panic-loop-extint]
>  file = panic-loop-extint.elf
>  groups = panic
> @@ -208,3 +204,14 @@ groups = migration
>  [exittime]
>  file = exittime.elf
>  smp = 2
> +
> +[migration-skey-sequential]
> +file = migration-skey.elf
> +groups = migration
> +extra_params = -append 'sequential'
> +
> +[migration-skey-parallel]
> +file = migration-skey.elf
> +smp = 2
> +groups = migration
> +extra_params = -append 'parallel'

