Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FBE68EE4E
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjBHLyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 06:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHLyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 06:54:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C9E4614B
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 03:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675857211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDX8JzT0xqTtrdaqpNqWi0h6AcwCPck4Kz++7XMLzjo=;
        b=f2UVs3nk2FoSJKGv0CUvr7jSmmkZQHDqGutB5OFRQFE4WRgWrE0pmyepZfHLYrcW+cNdvB
        58zEO9LlQVyHc0qeCBD48g5nwQHxG89dbCrByf7rPqewpqjyaelqpe4vC31+Iip03hpApq
        LPU2aAFuONAeBlHdB8etEMSU8P+K998=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-36-X7QhsSvDOPWyafQqpb7Ang-1; Wed, 08 Feb 2023 06:53:30 -0500
X-MC-Unique: X7QhsSvDOPWyafQqpb7Ang-1
Received: by mail-qv1-f71.google.com with SMTP id ib5-20020a0562141c8500b0053c23b938a0so9601509qvb.17
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 03:53:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDX8JzT0xqTtrdaqpNqWi0h6AcwCPck4Kz++7XMLzjo=;
        b=LsMHNht0gib95z5pkDCuhjrVxrMpERjDsLtZ7/c4IMaL6f0pmBfJGibt1mmnHAsPjm
         aTIwPLyFM29Eb4JUSWylKsbKr2lvkINte3XnBmpRJUsXU/5VkThJuP0U//9Au1Vj40Lh
         xDu5qzV5MBemoVO4t5RLrJsVX36YH6c0GkdxdMeFQdsoKxGDdlXxFGpSWZWIO/Eyi6sJ
         GVtnnI7rojnJ/c5h56Pq3fpfrGMaU8isWkktD/sqFLWr42yoRhMQPkLeZWZXEVYqaYsI
         AL+TsVYJYzRgTYsj+hH3SSkrtrYiomeB48rCkLJYjJ0WuqQXfSBLmmg+CHXQGxUxUjLR
         D87Q==
X-Gm-Message-State: AO0yUKUaQZQ+AqJdTWJOZAh1EVc2rAsH2Ssna05FNw7bp1wOVH83Ve45
        u9pVoG9eMKMVHWG5OtNbxh8EaXLDoik8/gWQLr/Sn9W/uJ+A6/13deD+W3NxuYUZiDFI6DoDzEl
        CO6mKa88zdIzD
X-Received: by 2002:ad4:5ca1:0:b0:539:b68e:3444 with SMTP id q1-20020ad45ca1000000b00539b68e3444mr13582380qvh.27.1675857210093;
        Wed, 08 Feb 2023 03:53:30 -0800 (PST)
X-Google-Smtp-Source: AK7set87dcpsJmG9A5SqVQU4S6v/ypYe4xIPzvEd0eUM0sqEib2dT866Qi80hgD9ikLTTh/CEqk9Mg==
X-Received: by 2002:ad4:5ca1:0:b0:539:b68e:3444 with SMTP id q1-20020ad45ca1000000b00539b68e3444mr13582348qvh.27.1675857209742;
        Wed, 08 Feb 2023 03:53:29 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-253.web.vodafone.de. [109.43.177.253])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a444f00b007296805f607sm11767387qkp.17.2023.02.08.03.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 03:53:29 -0800 (PST)
Message-ID: <96920589-ec3c-6e2d-4eee-a12b50b5c6ca@redhat.com>
Date:   Wed, 8 Feb 2023 12:53:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
 <20230202092814.151081-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] s390x: topology: Checking
 Configuration Topology Information
In-Reply-To: <20230202092814.151081-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/2023 10.28, Pierre Morel wrote:
> STSI with function code 15 is used to store the CPU configuration
> topology.
> 
> We retrieve the maximum nested level with SCLP and use the
> topology tree provided by the drawers, books, sockets, cores
> arguments.
> 
> We check :
> - if the topology stored is coherent between the QEMU -smp
>    parameters and kernel parameters.
> - the number of CPUs
> - the maximum number of CPUs
> - the number of containers of each levels for every STSI(15.1.x)
>    instruction allowed by the machine.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> +static inline int cpus_in_tle_mask(uint64_t val)
> +{
> +	int i, n;
> +
> +	for (i = 0, n = 0; i < 64; i++, val >>= 1)
> +		if (val & 0x01)
> +			n++;
> +	return n;

I'd suggest to use __builtin_popcountl here instead of looping.

> +}
> +
>   #endif  /* _S390X_STSI_H_ */
> diff --git a/s390x/topology.c b/s390x/topology.c
> index 20f7ba2..f21c653 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
> @@ -16,6 +16,18 @@
>   #include <smp.h>
>   #include <sclp.h>
>   #include <s390x/hardware.h>
> +#include <s390x/stsi.h>
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));

Isn't the SYSIB just one page only? Why reserve two pages here?

> +static int max_nested_lvl;
> +static int number_of_cpus;
> +static int max_cpus = 1;
> +
> +/* Topology level as defined by architecture */
> +static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL];
> +/* Topology nested level as reported in STSI */
> +static int stsi_nested_lvl[CPU_TOPOLOGY_MAX_LEVEL];
>   
>   #define PTF_REQ_HORIZONTAL	0
>   #define PTF_REQ_VERTICAL	1
> @@ -122,11 +134,241 @@ end:
>   	report_prefix_pop();
>   }
>   
> +/*
> + * stsi_check_maxcpus
> + * @info: Pointer to the stsi information
> + *
> + * The product of the numbers of containers per level
> + * is the maximum number of CPU allowed by the machine.
> + */
> +static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
> +{
> +	int n, i;
> +
> +	report_prefix_push("maximum cpus");
> +
> +	for (i = 0, n = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		report_info("Mag%d: %d", CPU_TOPOLOGY_MAX_LEVEL - i, info->mag[i]);
> +		n *= info->mag[i] ? info->mag[i] : 1;

You could use the Elvis operator here instead.

> +	}
> +	report(n == max_cpus, "Maximum CPUs %d expected %d", n, max_cpus);
> +
> +	report_prefix_pop();
> +}
> +
> +/*
> + * stsi_check_tle_coherency
> + * @info: Pointer to the stsi information
> + * @sel2: Topology level to check.
> + *
> + * We verify that we get the expected number of Topology List Entry
> + * containers for a specific level.
> + */
> +static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info, int sel2)
> +{
> +	struct topology_container *tc, *end;
> +	struct topology_core *cpus;
> +	int n = 0;
> +	int i;
> +
> +	report_prefix_push("TLE coherency");
> +
> +	tc = &info->tle[0].container;
> +	end = (struct topology_container *)((unsigned long)info + info->length);

s/unsigned long/uintptr_t/ please!


> +
> +	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++)
> +		stsi_nested_lvl[i] = 0;

memset(stsi_nested_lvl, 0, sizeof(stsi_nested_lvl)) ?

> +	while (tc < end) {
> +		if (tc->nl > 5) {

Use ">= CPU_TOPOLOGY_MAX_LEVEL" instead of "> 5" ?

> +			report_abort("Unexpected TL Entry: tle->nl: %d", tc->nl);
> +			return;
> +		}
> +		if (tc->nl == 0) {
> +			cpus = (struct topology_core *)tc;
> +			n += cpus_in_tle_mask(cpus->mask);
> +			report_info("cpu type %02x  d: %d pp: %d", cpus->type, cpus->d, cpus->pp);
> +			report_info("origin : %04x mask %016lx", cpus->origin, cpus->mask);
> +		}
> +
> +		stsi_nested_lvl[tc->nl]++;
> +		report_info("level %d: lvl: %d id: %d cnt: %d",
> +			    tc->nl, tc->nl, tc->id, stsi_nested_lvl[tc->nl]);
> +
> +		/* trick: CPU TLEs are twice the size of containers TLE */
> +		if (tc->nl == 0)
> +			tc++;

IMHO it might be cleaner to have a "uint8_t *" or "void *" to the current 
position in the sysinfo block, and do the pointer arithmetic on that pointer 
instead... well, it's likely just a matter of taste.

> +		tc++;
> +	}
> +	report(n == number_of_cpus, "Number of CPUs  : %d expect %d", n, number_of_cpus);
> +	/*
> +	 * For KVM we accept
> +	 * - only 1 type of CPU
> +	 * - only horizontal topology
> +	 * - only dedicated CPUs
> +	 * This leads to expect the number of entries of level 0 CPU
> +	 * Topology Level Entry (TLE) to be:
> +	 * 1 + (number_of_cpus - 1)  / arch_topo_lvl[0]
> +	 *
> +	 * For z/VM or LPAR this number can only be greater if different
> +	 * polarity, CPU types because there may be a nested level 0 CPU TLE
> +	 * for each of the CPU/polarity/sharing types in a level 1 container TLE.
> +	 */
> +	n =  (number_of_cpus - 1)  / arch_topo_lvl[0];
> +	report(stsi_nested_lvl[0] >=  n + 1,
> +	       "CPU Type TLE    : %d expect %d", stsi_nested_lvl[0], n + 1);
> +
> +	/* For each level found in STSI */
> +	for (i = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		/*
> +		 * For non QEMU/KVM hypervisor the concatenation of the levels
> +		 * above level 1 are architecture dependent.
> +		 * Skip these checks.
> +		 */
> +		if (!host_is_kvm() && sel2 != 2)
> +			continue;
> +
> +		/* For QEMU/KVM we expect a simple calculation */
> +		if (sel2 > i) {
> +			report(stsi_nested_lvl[i] ==  n + 1,
> +			       "Container TLE  %d: %d expect %d", i, stsi_nested_lvl[i], n + 1);
> +			n /= arch_topo_lvl[i];
> +		}
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +/*
> + * check_sysinfo_15_1_x
> + * @info: pointer to the STSI info structure
> + * @sel2: the selector giving the topology level to check
> + *
> + * Check if the validity of the STSI instruction and then
> + * calls specific checks on the information buffer.
> + */
> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
> +{
> +	int ret;
> +
> +	report_prefix_pushf("mnested %d 15_1_%d", max_nested_lvl, sel2);
> +
> +	ret = stsi(pagebuf, 15, 1, sel2);
> +	if (max_nested_lvl >= sel2) {
> +		report(!ret, "Valid stsi instruction");
> +	} else {
> +		report(ret, "Invalid stsi instruction");
> +		goto end;
> +	}
> +
> +	stsi_check_maxcpus(info);
> +	stsi_check_tle_coherency(info, sel2);

You could also move the two stsi_check_* calls into the first part of the 
if-statement, then you could get rid of the goto in the second part.

> +end:
> +	report_prefix_pop();
> +}
> +
> +static int sclp_get_mnest(void)
> +{
> +	ReadInfo *sccb = (void *)_sccb;
> +
> +	sclp_mark_busy();
> +	memset(_sccb, 0, PAGE_SIZE);
> +	sccb->h.length = PAGE_SIZE;
> +
> +	sclp_service_call(SCLP_CMDW_READ_SCP_INFO, sccb);
> +	assert(sccb->h.response_code == SCLP_RC_NORMAL_READ_COMPLETION);
> +
> +	return sccb->stsi_parm;
> +}
> +
> +/*
> + * test_stsi
> + *
> + * Retrieves the maximum nested topology level supported by the architecture
> + * and the number of CPUs.
> + * Calls the checking for the STSI instruction in sel2 reverse level order
> + * from 6 (CPU_TOPOLOGY_MAX_LEVEL) to 2 to have the most interesting level,
> + * the one triggering a topology-change-report-pending condition, level 2,
> + * at the end of the report.
> + *
> + */
> +static void test_stsi(void)
> +{
> +	int sel2;
> +
> +	max_nested_lvl = sclp_get_mnest();
> +	report_info("SCLP maximum nested level : %d", max_nested_lvl);
> +
> +	number_of_cpus = sclp_get_cpu_num();
> +	report_info("SCLP number of CPU: %d", number_of_cpus);
> +
> +	/* STSI selector 2 can takes values between 2 and 6 */
> +	for (sel2 = 6; sel2 >= 2; sel2--)
> +		check_sysinfo_15_1_x((struct sysinfo_15_1_x *)pagebuf, sel2);
> +}
> +
> +/*
> + * parse_topology_args
> + * @argc: number of arguments
> + * @argv: argument array
> + *
> + * This function initialize the architecture topology levels
> + * which should be the same as the one provided by the hypervisor.
> + *
> + * We use the current names found in IBM/Z literature, Linux and QEMU:
> + * cores, sockets/packages, books, drawers and nodes to facilitate the
> + * human machine interface but store the result in a machine abstract
> + * array of architecture topology levels.
> + * Note that when QEMU uses socket as a name for the topology level 1
> + * Linux uses package or physical_package.
> + */
> +static void parse_topology_args(int argc, char **argv)
> +{
> +	int i;
> +
> +	report_info("%d arguments", argc);
> +	for (i = 1; i < argc; i++) {
> +		if (!strcmp("-cores", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-cores needs a parameter");
> +			arch_topo_lvl[0] = atol(argv[i]);
> +			report_info("cores: %d", arch_topo_lvl[0]);
> +		} else if (!strcmp("-sockets", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-sockets needs a parameter");
> +			arch_topo_lvl[1] = atol(argv[i]);
> +			report_info("sockets: %d", arch_topo_lvl[1]);
> +		} else if (!strcmp("-books", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-books needs a parameter");
> +			arch_topo_lvl[2] = atol(argv[i]);
> +			report_info("books: %d", arch_topo_lvl[2]);
> +		} else if (!strcmp("-drawers", argv[i])) {
> +			i++;
> +			if (i >= argc)
> +				report_abort("-drawers needs a parameter");
> +			arch_topo_lvl[3] = atol(argv[i]);
> +			report_info("drawers: %d", arch_topo_lvl[3]);
> +		}

Maybe abort on unkown parameters, to avoid that typos go unnoticed?

> +	}
> +
> +	for (i = 0; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
> +		if (!arch_topo_lvl[i])
> +			arch_topo_lvl[i] = 1;
> +		max_cpus *= arch_topo_lvl[i];
> +	}
> +}

  Thomas

