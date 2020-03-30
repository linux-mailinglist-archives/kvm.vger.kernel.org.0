Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8421979FB
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgC3K6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:58:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12651 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729313AbgC3K6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 06:58:32 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7C91EB38A8366729AFBE;
        Mon, 30 Mar 2020 18:55:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 18:55:37 +0800
Subject: Re: [kvm-unit-tests PATCH v7 12/13] arm/arm64: ITS: migration tests
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <maz@kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-13-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4ae2e841-2558-133a-1d19-693dc6f34f60@huawei.com>
Date:   Mon, 30 Mar 2020 18:55:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320092428.20880-13-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/20 17:24, Eric Auger wrote:
> This test maps LPIs (populates the device table, the collection table,
> interrupt translation tables, configuration table), migrates and make
> sure the translation is correct on the destination.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v4 -> v5:
> - move stub from header to arm/gic.c
> 
> v3 -> v4:
> - assert in its_get_device/collection if the id is not found
> ---
>   arm/gic.c                  | 58 ++++++++++++++++++++++++++++++++++----
>   arm/unittests.cfg          |  8 ++++++
>   lib/arm64/asm/gic-v3-its.h |  3 ++
>   lib/arm64/gic-v3-its.c     | 22 +++++++++++++++
>   4 files changed, 85 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 5f1e595..6ecfdbc 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -590,6 +590,7 @@ static void gic_test_mmio(void)
>   
>   static void test_its_introspection(void) {}
>   static void test_its_trigger(void) {}
> +static void test_its_migration(void) {}
>   
>   #else /* __aarch64__ */
>   
> @@ -658,13 +659,19 @@ static int its_prerequisites(int nb_cpus)
>   	return 0;
>   }
>   
> -static void test_its_trigger(void)
> +/*
> + * Setup the configuration for those mappings:
> + * dev_id=2 event=20 -> vcpu 3, intid=8195
> + * dev_id=7 event=255 -> vcpu 2, intid=8196
> + * LPIs ready to hit
> + */
> +static int its_setup1(void)
>   {
>   	struct its_collection *col3, *col2;
>   	struct its_device *dev2, *dev7;
>   
>   	if (its_prerequisites(4))
> -		return;
> +		return -1;
>   
>   	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>   	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
> @@ -675,14 +682,10 @@ static void test_its_trigger(void)
>   	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>   	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
>   
> -	report_prefix_push("int");
>   	/*
>   	 * dev=2, eventid=20  -> lpi= 8195, col=3
>   	 * dev=7, eventid=255 -> lpi= 8196, col=2
> -	 * Trigger dev2, eventid=20 and dev7, eventid=255
> -	 * Check both LPIs hit
>   	 */
> -
>   	its_send_mapd(dev2, true);
>   	its_send_mapd(dev7, true);
>   
> @@ -694,6 +697,22 @@ static void test_its_trigger(void)
>   
>   	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
>   	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
> +	return 0;
> +}
> +
> +static void test_its_trigger(void)
> +{
> +	struct its_collection *col3;
> +	struct its_device *dev2, *dev7;
> +
> +	if (its_setup1())
> +		return;
> +
> +	col3 = its_get_collection(3);
> +	dev2 = its_get_device(2);
> +	dev7 = its_get_device(7);
> +
> +	report_prefix_push("int");
>   
>   	lpi_stats_expect(3, 8195);
>   	its_send_int(dev2, 20);
> @@ -748,6 +767,29 @@ static void test_its_trigger(void)
>   	check_lpi_stats("no LPI after device unmap");
>   	report_prefix_pop();
>   }
> +
> +static void test_its_migration(void)
> +{
> +	struct its_device *dev2, *dev7;
> +
> +	if (its_setup1())
> +		return;
> +
> +	dev2 = its_get_device(2);
> +	dev7 = its_get_device(7);
> +
> +	puts("Now migrate the VM, then press a key to continue...\n");
> +	(void)getchar();
> +	report_info("Migration complete");
> +
> +	lpi_stats_expect(3, 8195);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 en PE #3 after migration");

typo: s/en PE #3/on PE #3/

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> +
> +	lpi_stats_expect(2, 8196);
> +	its_send_int(dev7, 255);
> +	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
> +}
>   #endif
>   
>   int main(int argc, char **argv)
> @@ -785,6 +827,10 @@ int main(int argc, char **argv)
>   		report_prefix_push(argv[1]);
>   		test_its_trigger();
>   		report_prefix_pop();
> +	} else if (!strcmp(argv[1], "its-migration")) {
> +		report_prefix_push(argv[1]);
> +		test_its_migration();
> +		report_prefix_pop();
>   	} else if (strcmp(argv[1], "its-introspection") == 0) {
>   		report_prefix_push(argv[1]);
>   		test_its_introspection();
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index b9a7a2c..480adec 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -136,6 +136,14 @@ extra_params = -machine gic-version=3 -append 'its-trigger'
>   groups = its
>   arch = arm64
>   
> +[its-migration]
> +file = gic.flat
> +smp = $MAX_SMP
> +accel = kvm
> +extra_params = -machine gic-version=3 -append 'its-migration'
> +groups = its migration
> +arch = arm64
> +
>   # Test PSCI emulation
>   [psci]
>   file = psci.flat
> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> index e1e42c3..412f438 100644
> --- a/lib/arm64/asm/gic-v3-its.h
> +++ b/lib/arm64/asm/gic-v3-its.h
> @@ -168,4 +168,7 @@ extern void __its_send_sync(struct its_collection *col, bool verbose);
>   #define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, false)
>   #define its_send_sync_nv(col)				__its_send_sync(col, false)
>   
> +extern struct its_device *its_get_device(u32 id);
> +extern struct its_collection *its_get_collection(u32 id);
> +
>   #endif /* _ASMARM64_GIC_V3_ITS_H_ */
> diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
> index f0a0381..c7755d9 100644
> --- a/lib/arm64/gic-v3-its.c
> +++ b/lib/arm64/gic-v3-its.c
> @@ -147,3 +147,25 @@ struct its_collection *its_create_collection(u32 col_id, u32 pe)
>   	its_data.nr_collections++;
>   	return new;
>   }
> +
> +struct its_device *its_get_device(u32 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_MAX_DEVICES; i++) {
> +		if (its_data.devices[i].device_id == id)
> +			return &its_data.devices[i];
> +	}
> +	assert(0);
> +}
> +
> +struct its_collection *its_get_collection(u32 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_MAX_COLLECTIONS; i++) {
> +		if (its_data.collections[i].col_id == id)
> +			return &its_data.collections[i];
> +	}
> +	assert(0);
> +}
> 

