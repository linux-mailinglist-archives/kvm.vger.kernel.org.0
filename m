Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35813CA4D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAORGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:06:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728925AbgAORGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579108010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6p4uggDCt/f34JsVrVngOTTs30NPXpBqv0x/z7CxQGg=;
        b=cQGRRetPnXc7chpmO+f2lhj3HOADfQJTGvQ9W1Iq/X4XQadgsE8v0zNc9WDOxSjMMfRKKu
        P3l3g7K3veqlcxySO9YpzX5rgVdUG3P+FYtXbyJZroAV4qUneVNu19IDpJw1h+tunHHOYg
        CdtnKh0fbtZ0jN8A91KzA5KU/gsxXW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-yP4roz_QOmyLQiCrGedwuQ-1; Wed, 15 Jan 2020 12:06:47 -0500
X-MC-Unique: yP4roz_QOmyLQiCrGedwuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0F4B10054E3;
        Wed, 15 Jan 2020 17:06:45 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09387C3A2;
        Wed, 15 Jan 2020 17:06:42 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 16/16] arm/arm64: ITS: pending table
 migration test
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-17-eric.auger@redhat.com>
 <20200113184547.zqilrexm27hpkkou@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <dd919bb9-6e1e-501f-b369-eb0d8dfbbcbc@redhat.com>
Date:   Wed, 15 Jan 2020 18:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200113184547.zqilrexm27hpkkou@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 1/13/20 7:45 PM, Andrew Jones wrote:
> On Fri, Jan 10, 2020 at 03:54:12PM +0100, Eric Auger wrote:
>> Add two new migration tests. One testing the migration of
>> a topology where collection were unmapped. The second test
>> checks the migration of the pending table.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/gic.c         | 148 ++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg |  16 ++++-
>>  2 files changed, 163 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index bf4b5ba..cb976c3 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -170,6 +170,7 @@ static void lpi_handler(struct pt_regs *regs __unused)
>>  	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
>>  	lpi_stats.observed.cpu_id = smp_processor_id();
>>  	lpi_stats.observed.lpi_id = irqnr;
>> +	acked[lpi_stats.observed.cpu_id]++;
>>  	smp_wmb(); /* pairs with rmb in check_lpi_stats */
>>  }
>>  
>> @@ -207,6 +208,18 @@ static void check_lpi_stats(void)
>>  	}
>>  }
>>  
>> +static void check_lpi_hits(int *expected)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < nr_cpus; i++) {
>> +		if (acked[i] != expected[i])
>> +			report(false, "expected %d LPIs on PE #%d, %d observed",
>> +			       expected[i], i, acked[i]);
>> +		}
>> +	report(true, "check LPI on all vcpus");
>> +}
>> +
>>  static void gicv2_ipi_send_self(void)
>>  {
>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>> @@ -641,6 +654,18 @@ static int its_prerequisites(int nb_cpus)
>>  	return 0;
>>  }
>>  
>> +static void set_lpi(struct its_device *dev, u32 eventid, u32 physid,
>> +		    struct its_collection *col)
>> +{
>> +	if (!dev || !col)
>> +		report_abort("wrong device or collection");
>> +
>> +	its_send_mapti(dev, physid, eventid, col);
>> +
>> +	set_lpi_config(physid, LPI_PROP_DEFAULT);
>> +	its_send_invall(col);
>> +}
>> +
>>  /*
>>   * Setup the configuration for those mappings:
>>   * dev_id=2 event=20 -> vcpu 3, intid=8195
>> @@ -765,6 +790,121 @@ static void test_its_migration(void)
>>  	check_lpi_stats();
>>  }
>>  
>> +static void test_migrate_unmapped_collection(void)
>> +{
>> +	struct its_collection *col;
>> +	struct its_device *dev2, *dev7;
>> +	u8 config;
>> +
>> +	if (its_setup1())
>> +		return;
>> +
>> +	col = its_create_collection(nr_cpus - 1, nr_cpus - 1);
>> +	dev2 = its_get_device(2);
>> +	dev7 = its_get_device(7);
>> +
>> +	/* MAPTI with the collection unmapped */
>> +	set_lpi(dev2, 0, 8192, col);
>> +
>> +	puts("Now migrate the VM, then press a key to continue...\n");
>> +	(void)getchar();
>> +	report(true, "Migration complete");
>> +
>> +	/* on the destination, map the collection */
>> +	its_send_mapc(col, true);
>> +
>> +	lpi_stats_expect(2, 8196);
>> +	its_send_int(dev7, 255);
>> +	check_lpi_stats();
>> +
>> +	config = get_lpi_config(8192);
>> +	report(config == LPI_PROP_DEFAULT,
>> +	       "Config of LPI 8192 was properly migrated");
>> +
>> +	lpi_stats_expect(nr_cpus - 1, 8192);
>> +	its_send_int(dev2, 0);
>> +	check_lpi_stats();
>> +
>> +	/* unmap the collection */
>> +	its_send_mapc(col, false);
>> +
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev2, 0);
>> +	check_lpi_stats();
>> +
>> +	/* remap event 0 onto lpiid 8193 */
>> +	set_lpi(dev2, 0, 8193, col);
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev2, 0);
>> +	check_lpi_stats();
>> +
>> +	/* remap the collection */
>> +	its_send_mapc(col, true);
>> +	lpi_stats_expect(nr_cpus - 1, 8193);
>> +}
>> +
>> +static void test_its_pending_migration(void)
>> +{
>> +	struct its_device *dev;
>> +	struct its_collection *collection[2];
>> +	int expected[NR_CPUS];
>> +	u64 pendbaser;
>> +	void *ptr;
>> +	int i;
>> +
>> +	if (its_prerequisites(4))
>> +		return;
>> +
>> +	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>> +	its_send_mapd(dev, true);
>> +
>> +	collection[0] = its_create_collection(nr_cpus - 1, nr_cpus - 1);
>> +	collection[1] = its_create_collection(nr_cpus - 2, nr_cpus - 2);
>> +	its_send_mapc(collection[0], true);
>> +	its_send_mapc(collection[1], true);
>> +
>> +	/* disable lpi at redist level */
>> +	gicv3_rdist_ctrl_lpi(nr_cpus - 1, false);
>> +	gicv3_rdist_ctrl_lpi(nr_cpus - 2, false);
>> +
>> +	/* even lpis are assigned to even cpu */
>> +	for (i = 0; i < 256; i++) {
>> +		struct its_collection *col = i % 2 ? collection[0] :
>> +						     collection[1];
>> +		int vcpu = col->target_address >> 16;
>> +
>> +		its_send_mapti(dev, 8192 + i, i, col);
>> +		set_lpi_config(8192 + i, LPI_PROP_DEFAULT);
>> +		set_pending_table_bit(vcpu, 8192 + i, true);
>> +	}
>> +	its_send_invall(collection[0]);
>> +	its_send_invall(collection[1]);
>> +
>> +	/* Set the PTZ bit on each pendbaser */
>> +
>> +	expected[nr_cpus - 1] = 128;
>> +	expected[nr_cpus - 2] = 128;
>> +
>> +	ptr = gicv3_data.redist_base[nr_cpus - 1] + GICR_PENDBASER;
>> +	pendbaser = readq(ptr);
>> +	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>> +
>> +	ptr = gicv3_data.redist_base[nr_cpus - 2] + GICR_PENDBASER;
>> +	pendbaser = readq(ptr);
>> +	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>> +
>> +	gicv3_rdist_ctrl_lpi(nr_cpus - 1, true);
>> +	gicv3_rdist_ctrl_lpi(nr_cpus - 2, true);
>> +
>> +	puts("Now migrate the VM, then press a key to continue...\n");
>> +	(void)getchar();
>> +	report(true, "Migration complete");
>> +
>> +	mdelay(1000);
>> +
>> +	check_lpi_hits(expected);
>> +}
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	if (!gic_init()) {
>> @@ -803,6 +943,14 @@ int main(int argc, char **argv)
>>  		report_prefix_push(argv[1]);
>>  		test_its_migration();
>>  		report_prefix_pop();
>> +	} else if (!strcmp(argv[1], "its-pending-migration")) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_pending_migration();
>> +		report_prefix_pop();
>> +	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
>> +		report_prefix_push(argv[1]);
>> +		test_migrate_unmapped_collection();
>> +		report_prefix_pop();
>>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>>  		report_prefix_push(argv[1]);
>>  		test_its_introspection();
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 29e2efc..911f0b7 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -145,7 +145,21 @@ file = gic.flat
>>  smp = $MAX_SMP
>>  accel = kvm
>>  extra_params = -machine gic-version=3 -append 'its-migration'
>> -groups = its migration
>> +groups = migration
>> +
>> +[its-pending-migration]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +accel = kvm
>> +extra_params = -machine gic-version=3 -append 'its-pending-migration'
>> +groups = migration
>> +
>> +[its-migrate-unmapped-collection]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +accel = kvm
>> +extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
>> +groups = migration
> 
> Why drop the 'its' group?
I think the test only works with the migration group. Otherwise it
stalls due to the migration infrastructure. I will double check.

Thanks

Eric
> 
> Thanks,
> drew
> 
>>  
>>  # Test PSCI emulation
>>  [psci]
>> -- 
>> 2.20.1
>>

