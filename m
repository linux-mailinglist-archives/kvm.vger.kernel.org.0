Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5017BDA4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgCFNGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:06:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727247AbgCFNGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:06:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583499977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5LShtWZWpYWyqheSZzbznDplp/cdC8Q/qoN9VsXBss=;
        b=Qb6vlsaed2Y0kS6mVEfNGgMi7OuLbs7QXECgUf8Ag7pEng8zZUB5zDpbTrb1M/mNwhDqIR
        l+RnynlIQ9yUXCyJXFqf5KMCzhF07BoIYJ/q1D6dPvWy+wP+WtyxdsXqSfXDEEvlio47mp
        fyshe6BSUOae6vXsd87vL/rd0fHzQdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-5nYdyAr6P2-pLpzRykT7LQ-1; Fri, 06 Mar 2020 08:06:15 -0500
X-MC-Unique: 5nYdyAr6P2-pLpzRykT7LQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32DDC18A6EC0;
        Fri,  6 Mar 2020 13:06:13 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBBE85D9CD;
        Fri,  6 Mar 2020 13:06:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 13/14] arm/arm64: ITS: migration tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-14-eric.auger@redhat.com>
 <20200207134923.4gh5cz2qokuzei2m@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <eeb138b4-4b4d-78d5-e5b1-6e9ad33f5a3a@redhat.com>
Date:   Fri, 6 Mar 2020 14:06:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200207134923.4gh5cz2qokuzei2m@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 2/7/20 2:49 PM, Andrew Jones wrote:
> On Tue, Jan 28, 2020 at 11:34:58AM +0100, Eric Auger wrote:
>> This test maps LPIs (populates the device table, the collection table,
>> interrupt translation tables, configuration table), migrates and make
>> sure the translation is correct on the destination.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/gic.c                | 59 ++++++++++++++++++++++++++++++++++++----
>>  arm/unittests.cfg        |  8 ++++++
>>  lib/arm/asm/gic-v3-its.h |  2 ++
>>  lib/arm/gic-v3-its.c     | 22 +++++++++++++++
>>  4 files changed, 85 insertions(+), 6 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 50104b1..fa8626a 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -593,6 +593,7 @@ static void gic_test_mmio(void)
>>  
>>  static void test_its_introspection(void) {}
>>  static void test_its_trigger(void) {}
>> +static void test_its_migration(void) {}
>>  
>>  #else /* __arch64__ */
>>  
>> @@ -665,13 +666,19 @@ static bool its_prerequisites(int nb_cpus)
>>  	return false;
>>  }
>>  
>> -static void test_its_trigger(void)
>> +/*
>> + * Setup the configuration for those mappings:
>> + * dev_id=2 event=20 -> vcpu 3, intid=8195
>> + * dev_id=7 event=255 -> vcpu 2, intid=8196
>> + * LPIs ready to hit
>> + */
>> +static int its_setup1(void)
>>  {
>>  	struct its_collection *col3, *col2;
>>  	struct its_device *dev2, *dev7;
>>  
>>  	if (its_prerequisites(4))
>> -		return;
>> +		return -1;
> 
> Why not make its_setup1 a bool? Where true means success and false mean
> failure?
I tend to prefer the std error return value convention that the bool
return value. I aligned its_prerequisites accordingly.
> 
>>  
>>  	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>>  	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
>> @@ -685,14 +692,10 @@ static void test_its_trigger(void)
>>  	its_send_invall(col2);
>>  	its_send_invall(col3);
>>  
>> -	report_prefix_push("int");
>>  	/*
>>  	 * dev=2, eventid=20  -> lpi= 8195, col=3
>>  	 * dev=7, eventid=255 -> lpi= 8196, col=2
>> -	 * Trigger dev2, eventid=20 and dev7, eventid=255
>> -	 * Check both LPIs hit
>>  	 */
>> -
>>  	its_send_mapd(dev2, true);
>>  	its_send_mapd(dev7, true);
>>  
>> @@ -703,6 +706,23 @@ static void test_its_trigger(void)
>>  		       20 /* event id */, col3);
>>  	its_send_mapti(dev7, 8196 /* lpi id */,
>>  		       255 /* event id */, col2);
>> +	return 0;
>> +}
>> +
>> +static void test_its_trigger(void)
>> +{
>> +	struct its_collection *col3, *col2;
>> +	struct its_device *dev2, *dev7;
>> +
>> +	if (its_setup1())
>> +		return;
>> +
>> +	col3 = its_get_collection(3);
>> +	col2 = its_get_collection(2);
>> +	dev2 = its_get_device(2);
>> +	dev7 = its_get_device(7);
>> +
>> +	report_prefix_push("int");
>>  
>>  	lpi_stats_expect(3, 8195);
>>  	its_send_int(dev2, 20);
>> @@ -763,6 +783,29 @@ static void test_its_trigger(void)
>>  	check_lpi_stats();
>>  	report_prefix_pop();
>>  }
>> +
>> +static void test_its_migration(void)
>> +{
>> +	struct its_device *dev2, *dev7;
>> +
>> +	if (its_setup1())
>> +		return;
>> +
>> +	dev2 = its_get_device(2);
>> +	dev7 = its_get_device(7);
>> +
>> +	puts("Now migrate the VM, then press a key to continue...\n");
>> +	(void)getchar();
>> +	report(true, "Migration complete");
> 
> This seems more like a report_info place. If migration fails and
> we don't complete we'll never get the report FAIL anyway.
OK
> 
>> +
>> +	lpi_stats_expect(3, 8195);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +
>> +	lpi_stats_expect(2, 8196);
>> +	its_send_int(dev7, 255);
>> +	check_lpi_stats();
>> +}
>>  #endif
>>  
>>  int main(int argc, char **argv)
>> @@ -800,6 +843,10 @@ int main(int argc, char **argv)
>>  		report_prefix_push(argv[1]);
>>  		test_its_trigger();
>>  		report_prefix_pop();
>> +	} else if (!strcmp(argv[1], "its-migration")) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_migration();
>> +		report_prefix_pop();
>>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>>  		report_prefix_push(argv[1]);
>>  		test_its_introspection();
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index bfafec5..8b8ec79 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -136,6 +136,14 @@ extra_params = -machine gic-version=3 -append 'its-trigger'
>>  groups = its
>>  arch = arm64
>>  
>> +[its-migration]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +accel = kvm
>> +extra_params = -machine gic-version=3 -append 'its-migration'
>> +groups = its migration
>> +arch = arm64
>> +
>>  # Test PSCI emulation
>>  [psci]
>>  file = psci.flat
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index 0e5c5b6..febc2b2 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -151,6 +151,8 @@ extern void its_send_invall(struct its_collection *col);
>>  extern void its_send_movi(struct its_device *dev,
>>  			  struct its_collection *col, u32 id);
>>  extern void its_send_sync(struct its_collection *col);
>> +extern struct its_device *its_get_device(u32 id);
>> +extern struct its_collection *its_get_collection(u32 id);
>>  
>>  #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
>>  #define ITS_FLAGS_WORKAROUND_CAVIUM_22375       (1ULL << 1)
>> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index c2dcd01..099940e 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -219,3 +219,25 @@ struct its_collection *its_create_collection(u32 col_id, u32 pe)
>>  	its_data.nr_collections++;
>>  	return new;
>>  }
>> +
>> +struct its_device *its_get_device(u32 id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < GITS_MAX_DEVICES; i++) {
>> +		if (its_data.devices[i].device_id == id)
>> +			return &its_data.devices[i];
>> +	}
>> +	return NULL;
>> +}
>> +
>> +struct its_collection *its_get_collection(u32 id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < GITS_MAX_COLLECTIONS; i++) {
>> +		if (its_data.collections[i].col_id == id)
>> +			return &its_data.collections[i];
>> +	}
>> +	return NULL;
>> +}
> 
> The callers aren't checking for NULL. Should we assert here
> or in the caller?
Added the assert here.

Thanks

Eric
> 
> Thanks,
> drew
> 
> 
>> -- 
>> 2.20.1
>>

