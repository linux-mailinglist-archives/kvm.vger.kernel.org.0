Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1E617BF53
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCFNlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:41:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726498AbgCFNlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583502079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yHrD7p1l1W+O6y8WhXk5o1zZt3VK4T85QJa9EMrcWls=;
        b=c4+Wa+BcpSupB8XQAm3Hy+oqT7X5LTyIjsCbOlh7ewM5u6UzGZkFie2ZRhiBuMiZaG8OJ9
        IDIkpI0SzjW1SzC/zN1kyASMo6u4h5MRrzEDC+prPs4rPngPvlnymR/GWiu3q2iSyGJwJo
        6gYi3kuPsjg2sDrQFRvcpWbd/bgVVAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-7tb4VGa5OaORjeT54igdJA-1; Fri, 06 Mar 2020 08:41:15 -0500
X-MC-Unique: 7tb4VGa5OaORjeT54igdJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 318CFDB22;
        Fri,  6 Mar 2020 13:41:13 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54A197389C;
        Fri,  6 Mar 2020 13:41:10 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 14/14] arm/arm64: ITS: pending table
 migration test
To:     Andrew Jones <drjones@redhat.com>
Cc:     peter.maydell@linaro.org, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-15-eric.auger@redhat.com>
 <20200207140627.rikkw5coe7naxssb@kamzik.brq.redhat.com>
 <24940769-6e50-2585-4572-44422ca21613@redhat.com>
 <20200306133616.pp5vf2xramt5afvr@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <22edb6b4-598e-2b8e-0a43-fd4cfed9337e@redhat.com>
Date:   Fri, 6 Mar 2020 14:41:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200306133616.pp5vf2xramt5afvr@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

On 3/6/20 2:36 PM, Andrew Jones wrote:
> On Fri, Mar 06, 2020 at 02:21:37PM +0100, Auger Eric wrote:
>> Hi Drew,
>>
>> On 2/7/20 3:06 PM, Andrew Jones wrote:
>>> On Tue, Jan 28, 2020 at 11:34:59AM +0100, Eric Auger wrote:
>>>> Add two new migration tests. One testing the migration of
>>>> a topology where collection were unmapped. The second test
>>>> checks the migration of the pending table.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v2 -> v3:
>>>> - tests belong to both its and migration groups
>>>> ---
>>>>  arm/gic.c         | 150 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  arm/unittests.cfg |  16 +++++
>>>>  2 files changed, 166 insertions(+)
>>>>
>>>> diff --git a/arm/gic.c b/arm/gic.c
>>>> index fa8626a..ec3dd3a 100644
>>>> --- a/arm/gic.c
>>>> +++ b/arm/gic.c
>>>> @@ -195,6 +195,7 @@ static void lpi_handler(struct pt_regs *regs __unused)
>>>>  	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
>>>>  	lpi_stats.observed.cpu_id = smp_processor_id();
>>>>  	lpi_stats.observed.lpi_id = irqnr;
>>>> +	acked[lpi_stats.observed.cpu_id]++;
>>>>  	smp_wmb(); /* pairs with rmb in check_lpi_stats */
>>>>  }
>>>>  
>>>> @@ -239,6 +240,18 @@ static void secondary_lpi_test(void)
>>>>  	while (1)
>>>>  		wfi();
>>>>  }
>>>> +
>>>> +static void check_lpi_hits(int *expected)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < nr_cpus; i++) {
>>>> +		if (acked[i] != expected[i])
>>>> +			report(false, "expected %d LPIs on PE #%d, %d observed",
>>>> +			       expected[i], i, acked[i]);
>>>
>>> report_info
>>> pass = false
>>>
>>>> +		}
>>>> +	report(true, "check LPI on all vcpus");
>>>
>>> report(pass, ...);
>> I still don't get the issue.
> 
> Your messages aren't consistent and have dynamic info. You need
> 
> report_info(...); // dynamic info
> if (failure_condition) {
>    pass_boolean = false;
> }
> report(pass_boolean, single_message_for_both_pass_and_failure);
OK understood.

Thanks!

Eric
> 
>>>
>>>> +}
>>>>  #endif
>>>>  
>>>>  static void gicv2_ipi_send_self(void)
>>>> @@ -594,6 +607,8 @@ static void gic_test_mmio(void)
>>>>  static void test_its_introspection(void) {}
>>>>  static void test_its_trigger(void) {}
>>>>  static void test_its_migration(void) {}
>>>> +static void test_migrate_unmapped_collection(void) {}
>>>> +static void test_its_pending_migration(void) {}
>>>
>>> I'm not sure what's worse. This pile of stubs or one #ifdef in main()
>>> wrapping all the calls.
>> Those stubs now are in the arm header.
>>>
>>>>  
>>>>  #else /* __arch64__ */
>>>>  
>>>> @@ -666,6 +681,18 @@ static bool its_prerequisites(int nb_cpus)
>>>>  	return false;
>>>>  }
>>>>  
>>>> +static void set_lpi(struct its_device *dev, u32 eventid, u32 physid,
>>>> +		    struct its_collection *col)
>>>> +{
>>>> +	if (!dev || !col)
>>>
>>> I don't think col can be null, and this doesn't look like the right place
>>> to check if dev is null.  If we're bothiner to call set_lpi, then I
>>> think we should already expect dev to be good to go.
>> put an assert() instead
>>>
>>>> +		report_abort("wrong device or collection");
>>>> +
>>>> +	its_send_mapti(dev, physid, eventid, col);
>>>> +
>>>> +	gicv3_lpi_set_config(physid, LPI_PROP_DEFAULT);
>>>> +	its_send_invall(col);
>>>> +}
>>>> +
>>>>  /*
>>>>   * Setup the configuration for those mappings:
>>>>   * dev_id=2 event=20 -> vcpu 3, intid=8195
>>>> @@ -806,6 +833,121 @@ static void test_its_migration(void)
>>>>  	its_send_int(dev7, 255);
>>>>  	check_lpi_stats();
>>>>  }
>>>> +
>>>> +static void test_migrate_unmapped_collection(void)
>>>> +{
>>>> +	struct its_collection *col;
>>>> +	struct its_device *dev2, *dev7;
>>>> +	u8 config;
>>>> +
>>>> +	if (its_setup1())
>>>> +		return;
>>>> +
>>>> +	col = its_create_collection(nr_cpus - 1, nr_cpus - 1);
>>>> +	dev2 = its_get_device(2);
>>>> +	dev7 = its_get_device(7);
>>>> +
>>>> +	/* MAPTI with the collection unmapped */
>>>> +	set_lpi(dev2, 0, 8192, col);
>>>> +
>>>> +	puts("Now migrate the VM, then press a key to continue...\n");
>>>> +	(void)getchar();
>>>> +	report(true, "Migration complete");
>>>
>>> report_info
>> yep
>>>
>>>> +
>>>> +	/* on the destination, map the collection */
>>>> +	its_send_mapc(col, true);
>>>> +
>>>> +	lpi_stats_expect(2, 8196);
>>>> +	its_send_int(dev7, 255);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	config = gicv3_lpi_get_config(8192);
>>>> +	report(config == LPI_PROP_DEFAULT,
>>>> +	       "Config of LPI 8192 was properly migrated");
>>>> +
>>>> +	lpi_stats_expect(nr_cpus - 1, 8192);
>>>> +	its_send_int(dev2, 0);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	/* unmap the collection */
>>>> +	its_send_mapc(col, false);
>>>> +
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev2, 0);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	/* remap event 0 onto lpiid 8193 */
>>>> +	set_lpi(dev2, 0, 8193, col);
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev2, 0);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	/* remap the collection */
>>>> +	its_send_mapc(col, true);
>>>> +	lpi_stats_expect(nr_cpus - 1, 8193);
>>>> +}
>>>> +
>>>> +static void test_its_pending_migration(void)
>>>> +{
>>>> +	struct its_device *dev;
>>>> +	struct its_collection *collection[2];
>>>> +	int expected[NR_CPUS];
>>>
>>> expected = malloc(nr_cpus * sizeof(int));
>>>
>>> I know there are other places using NR_CPUS right now that don't have to,
>>> but we shouldn't add more. Eventually I'll change the other places too.
>> OK
>>>
>>>> +	u64 pendbaser;
>>>> +	void *ptr;
>>>> +	int i;
>>>> +
>>>> +	if (its_prerequisites(4))
>>>> +		return;
>>>> +
>>>> +	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>>>> +	its_send_mapd(dev, true);
>>>> +
>>>> +	collection[0] = its_create_collection(nr_cpus - 1, nr_cpus - 1);
>>>> +	collection[1] = its_create_collection(nr_cpus - 2, nr_cpus - 2);
>>>> +	its_send_mapc(collection[0], true);
>>>> +	its_send_mapc(collection[1], true);
>>>> +
>>>> +	/* disable lpi at redist level */
>>>> +	gicv3_lpi_rdist_ctrl(nr_cpus - 1, false);
>>>> +	gicv3_lpi_rdist_ctrl(nr_cpus - 2, false);
>>>> +
>>>> +	/* even lpis are assigned to even cpu */
>>>> +	for (i = 0; i < 256; i++) {
>>>> +		struct its_collection *col = i % 2 ? collection[0] :
>>>> +						     collection[1];
>>>> +		int vcpu = col->target_address >> 16;
>>>
>>> I'm lost with the even/odd (nr_cpus - 1)/(nr_cpus - 2) stuff, and won't
>>> it swap if nr_cpus is odd vs. even?
>>>
>>> Shouldn't we just have something like
>>>
>>>   pe1 = nr_cpus - 1;
>>>   pe2 = nr_cpus - 2;
>>>   col1 = its_create_collection(pe1, pe1);
>>>   col2 = its_create_collection(pe2, pe2);
>>>
>>> without mentioning even and odd?
>> OK
>>>
>>>> +
>>>> +		its_send_mapti(dev, 8192 + i, i, col);
>>>> +		gicv3_lpi_set_config(8192 + i, LPI_PROP_DEFAULT);
>>>> +		gicv3_lpi_set_pending_table_bit(vcpu, 8192 + i, true);
>>>> +	}
>>>> +	its_send_invall(collection[0]);
>>>> +	its_send_invall(collection[1]);
>>>> +
>>>> +	/* Set the PTZ bit on each pendbaser */
>>>> +
>>>> +	expected[nr_cpus - 1] = 128;
>>>> +	expected[nr_cpus - 2] = 128;
>>>> +
>>>> +	ptr = gicv3_data.redist_base[nr_cpus - 1] + GICR_PENDBASER;
>>>> +	pendbaser = readq(ptr);
>>>> +	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>>>> +
>>>> +	ptr = gicv3_data.redist_base[nr_cpus - 2] + GICR_PENDBASER;
>>>> +	pendbaser = readq(ptr);
>>>> +	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>>>> +
>>>> +	gicv3_lpi_rdist_ctrl(nr_cpus - 1, true);
>>>> +	gicv3_lpi_rdist_ctrl(nr_cpus - 2, true);
>>>> +
>>>> +	puts("Now migrate the VM, then press a key to continue...\n");
>>>> +	(void)getchar();
>>>> +	report(true, "Migration complete");
>>>
>>> report_info
>> OK
>>>
>>>> +
>>>> +	mdelay(1000);
>>>
>>> This delay needs a comment explaining why it's here.
>> OK
>>
>> Thanks
>>
>> Eric
>>>
>>>> +
>>>> +	check_lpi_hits(expected);
>>>> +}
>>>>  #endif
>>>>  
>>>>  int main(int argc, char **argv)
>>>> @@ -847,6 +989,14 @@ int main(int argc, char **argv)
>>>>  		report_prefix_push(argv[1]);
>>>>  		test_its_migration();
>>>>  		report_prefix_pop();
>>>> +	} else if (!strcmp(argv[1], "its-pending-migration")) {
>>>> +		report_prefix_push(argv[1]);
>>>> +		test_its_pending_migration();
>>>> +		report_prefix_pop();
>>>> +	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
>>>> +		report_prefix_push(argv[1]);
>>>> +		test_migrate_unmapped_collection();
>>>> +		report_prefix_pop();
>>>>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>>>>  		report_prefix_push(argv[1]);
>>>>  		test_its_introspection();
>>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>>> index 8b8ec79..d917157 100644
>>>> --- a/arm/unittests.cfg
>>>> +++ b/arm/unittests.cfg
>>>> @@ -144,6 +144,22 @@ extra_params = -machine gic-version=3 -append 'its-migration'
>>>>  groups = its migration
>>>>  arch = arm64
>>>>  
>>>> +[its-pending-migration]
>>>> +file = gic.flat
>>>> +smp = $MAX_SMP
>>>> +accel = kvm
>>>> +extra_params = -machine gic-version=3 -append 'its-pending-migration'
>>>> +groups = its migration
>>>> +arch = arm64
>>>> +
>>>> +[its-migrate-unmapped-collection]
>>>> +file = gic.flat
>>>> +smp = $MAX_SMP
>>>> +accel = kvm
>>>> +extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
>>>> +groups = its migration
>>>> +arch = arm64
>>>> +
>>>>  # Test PSCI emulation
>>>>  [psci]
>>>>  file = psci.flat
>>>> -- 
>>>> 2.20.1
>>>>
>>>>
>>>
>>> Thanks,
>>> drew 
>>>
>>
>>

