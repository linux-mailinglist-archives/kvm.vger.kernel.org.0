Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6DE6C6A7C
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjCWOJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCWOJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:09:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB80C2CC5B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679580440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRvpalBWPqMhv6mTwhRPg9Z49O8olbGgMd78XcEZW2M=;
        b=J8LCti+0Fxew5H4ixzavxfRQSeg/nq1eBwpfIAuZLu5baGa9lDCaR6QDmeOu8fO84J+sG1
        xJeHzXJhLqCOz/eR5AeyfZlYnORbce4td31DJFaj5HPY2txERpggZ+kOWQceVOGA7hm24e
        lDSTzR2cbgfO4IX0MEaYLOJs8u3NrKA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-JSGPBirbNNGU7ILeKKF3Fg-1; Thu, 23 Mar 2023 10:07:18 -0400
X-MC-Unique: JSGPBirbNNGU7ILeKKF3Fg-1
Received: by mail-wm1-f72.google.com with SMTP id bi5-20020a05600c3d8500b003edda1368d7so991905wmb.8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679580437;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRvpalBWPqMhv6mTwhRPg9Z49O8olbGgMd78XcEZW2M=;
        b=SMbGMzKNy57+RW1+5hs616Li3tFiYreltqFhOYK/p/38uo/5ZAoX1uTOxa8H7nqmB2
         sGOwbsv6a2iQeoopzsDbigvUXvMu+1ZK8WMPCtP7zywRI3rOooitUsV/7WGf75Pdhunq
         FaLjjBwXZ99dgzudGriPs6B6w8aiFtIwPvND/9lgLaFjMiIRD91OZzmXFFHNLfp8LkOt
         jd1u8S8woBAqd8n0btRZ82iBJFJu6KIQdC49JIsRuG1ip7Sfbx6VnxqKWdDpk/U7iHR7
         IkMjY4Jy0elEl9oB/qCW61ZVbH1cM/laLpTuJBDh4OUajZQv/Uz6pf6tMGCH8J9PQEkX
         ToGg==
X-Gm-Message-State: AO0yUKXE8qvVv2p6yX7oEJQjWPOvLckwcWPMKCYaJpYYsLaR77rwE1Kb
        pGyv7Q/dvBGyHoxmK6H9GujnuNXQkn7mcyK4IdDgbfQsvQMTD9Hqc/jCYYIqu1XH+EPgjkgwIA2
        pRV4dbk47s/0V
X-Received: by 2002:a05:600c:2202:b0:3ed:29f7:5b43 with SMTP id z2-20020a05600c220200b003ed29f75b43mr2371455wml.27.1679580437490;
        Thu, 23 Mar 2023 07:07:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set9KIl7q+bmnKehrAC4rbgA9iW7yJciDLCNLe9sT8+09ZC/jqRaq1+K8mh12VAS9MYY8kodAjQ==
X-Received: by 2002:a05:600c:2202:b0:3ed:29f7:5b43 with SMTP id z2-20020a05600c220200b003ed29f75b43mr2371433wml.27.1679580437180;
        Thu, 23 Mar 2023 07:07:17 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id u4-20020a5d4344000000b002c5526234d2sm16452365wrr.8.2023.03.23.07.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 07:07:16 -0700 (PDT)
Message-ID: <e10767db-95c2-18a2-aa9a-a055844570ac@redhat.com>
Date:   Thu, 23 Mar 2023 15:07:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-8-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v2 07/10] powerpc/spapr_vpa: Add basic VPA tests
In-Reply-To: <20230320070339.915172-8-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
> The VPA is a(n optional) memory structure shared between the hypervisor
> and operating system, defined by PAPR. This test defines the structure
> and adds registration, deregistration, and a few simple sanity tests.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/linux/compiler.h    |  2 +
>   lib/powerpc/asm/hcall.h |  1 +
>   lib/ppc64/asm/vpa.h     | 62 ++++++++++++++++++++++++++++
>   powerpc/Makefile.ppc64  |  2 +-
>   powerpc/spapr_vpa.c     | 90 +++++++++++++++++++++++++++++++++++++++++

Please add the new test to powerpc/unittests.cfg, otherwise it won't get 
picked up by the run_tests.sh script.

> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 6f565e4..c9d205e 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -45,7 +45,9 @@
>   
>   #define barrier()	asm volatile("" : : : "memory")
>   
> +#ifndef __always_inline
>   #define __always_inline	inline __attribute__((always_inline))
> +#endif

What's this change good for? ... it doesn't seem to be related to this patch?

> diff --git a/lib/ppc64/asm/vpa.h b/lib/ppc64/asm/vpa.h
> new file mode 100644
> index 0000000..11dde01
> --- /dev/null
> +++ b/lib/ppc64/asm/vpa.h
> @@ -0,0 +1,62 @@
> +#ifndef _ASMPOWERPC_VPA_H_
> +#define _ASMPOWERPC_VPA_H_
> +/*
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +
> +#ifndef __ASSEMBLY__
> +
> +struct vpa {
> +	uint32_t	descriptor;
> +	uint16_t	size;
> +	uint8_t		reserved1[3];
> +	uint8_t		status;

Where does this status field come from? ... My LoPAPR only says that there 
are 18 "reserved" bytes in total here.

> +	uint8_t		reserved2[14];
> +	uint32_t	fru_node_id;
> +	uint32_t	fru_proc_id;
> +	uint8_t		reserved3[56];
> +	uint8_t		vhpn_change_counters[8];
> +	uint8_t		reserved4[80];
> +	uint8_t		cede_latency;
> +	uint8_t		maintain_ebb;
> +	uint8_t		reserved5[6];
> +	uint8_t		dtl_enable_mask;
> +	uint8_t		dedicated_cpu_donate;
> +	uint8_t		maintain_fpr;
> +	uint8_t		maintain_pmc;
> +	uint8_t		reserved6[28];
> +	uint64_t	idle_estimate_purr;
> +	uint8_t		reserved7[28];
> +	uint16_t	maintain_nr_slb;
> +	uint8_t		idle;
> +	uint8_t		maintain_vmx;
> +	uint32_t	vp_dispatch_count;
> +	uint32_t	vp_dispatch_dispersion;
> +	uint64_t	vp_fault_count;
> +	uint64_t	vp_fault_tb;
> +	uint64_t	purr_exprop_idle;
> +	uint64_t	spurr_exprop_idle;
> +	uint64_t	purr_exprop_busy;
> +	uint64_t	spurr_exprop_busy;
> +	uint64_t	purr_donate_idle;
> +	uint64_t	spurr_donate_idle;
> +	uint64_t	purr_donate_busy;
> +	uint64_t	spurr_donate_busy;
> +	uint64_t	vp_wait3_tb;
> +	uint64_t	vp_wait2_tb;
> +	uint64_t	vp_wait1_tb;
> +	uint64_t	purr_exprop_adjunct_busy;
> +	uint64_t	spurr_exprop_adjunct_busy;

The above two fields are also marked as "reserved" in my LoPAPR ... which 
version did you use?

> +	uint32_t	supervisor_pagein_count;
> +	uint8_t		reserved8[4];
> +	uint64_t	purr_exprop_adjunct_idle;
> +	uint64_t	spurr_exprop_adjunct_idle;
> +	uint64_t	adjunct_insns_executed;

dito for the above three lines... I guess my LoPAPR is too old...

> +	uint8_t		reserved9[120];
> +	uint64_t	dtl_index;
> +	uint8_t		reserved10[96];
> +};
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* _ASMPOWERPC_VPA_H_ */
> diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
> index ea68447..b0ed2b1 100644
> --- a/powerpc/Makefile.ppc64
> +++ b/powerpc/Makefile.ppc64
> @@ -19,7 +19,7 @@ reloc.o  = $(TEST_DIR)/reloc64.o
>   OBJDIRS += lib/ppc64
>   
>   # ppc64 specific tests
> -tests =
> +tests = $(TEST_DIR)/spapr_vpa.elf
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>   
> diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
> new file mode 100644
> index 0000000..45688fe
> --- /dev/null
> +++ b/powerpc/spapr_vpa.c
> @@ -0,0 +1,90 @@
> +/*
> + * Test sPAPR hypervisor calls (aka. h-calls)

Adjust to "Test sPAPR H_REGISTER_VPA hypervisor call" ?

> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libfdt/libfdt.h>
> +#include <devicetree.h>
> +#include <libcflat.h>
> +#include <util.h>
> +#include <alloc.h>
> +#include <asm/processor.h>
> +#include <asm/hcall.h>
> +#include <asm/vpa.h>
> +#include <asm/io.h> /* for endian accessors */
> +
> +static void print_vpa(struct vpa *vpa)
> +{
> +	printf("VPA\n");
> +	printf("descriptor:			0x%08x\n", be32_to_cpu(vpa->descriptor));
> +	printf("size:				    0x%04x\n", be16_to_cpu(vpa->size));
> +	printf("status:				      0x%02x\n", vpa->status);
> +	printf("fru_node_id:			0x%08x\n", be32_to_cpu(vpa->fru_node_id));
> +	printf("fru_proc_id:			0x%08x\n", be32_to_cpu(vpa->fru_proc_id));
> +	printf("vhpn_change_counters:		0x%02x %02x %02x %02x %02x %02x %02x %02x\n", vpa->vhpn_change_counters[0], vpa->vhpn_change_counters[1], vpa->vhpn_change_counters[2], vpa->vhpn_change_counters[3], vpa->vhpn_change_counters[4], vpa->vhpn_change_counters[5], vpa->vhpn_change_counters[6], vpa->vhpn_change_counters[7]);
> +	printf("vp_dispatch_count:		0x%08x\n", be32_to_cpu(vpa->vp_dispatch_count));
> +	printf("vp_dispatch_dispersion:		0x%08x\n", be32_to_cpu(vpa->vp_dispatch_dispersion));
> +	printf("vp_fault_count:			0x%08lx\n", be64_to_cpu(vpa->vp_fault_count));
> +	printf("vp_fault_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_fault_tb));
> +	printf("purr_exprop_idle:		0x%08lx\n", be64_to_cpu(vpa->purr_exprop_idle));
> +	printf("spurr_exprop_idle:		0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_idle));
> +	printf("purr_exprop_busy:		0x%08lx\n", be64_to_cpu(vpa->purr_exprop_busy));
> +	printf("spurr_exprop_busy:		0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_busy));
> +	printf("purr_donate_idle:		0x%08lx\n", be64_to_cpu(vpa->purr_donate_idle));
> +	printf("spurr_donate_idle:		0x%08lx\n", be64_to_cpu(vpa->spurr_donate_idle));
> +	printf("purr_donate_busy:		0x%08lx\n", be64_to_cpu(vpa->purr_donate_busy));
> +	printf("spurr_donate_busy:		0x%08lx\n", be64_to_cpu(vpa->spurr_donate_busy));
> +	printf("vp_wait3_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait3_tb));
> +	printf("vp_wait2_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait2_tb));
> +	printf("vp_wait1_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait1_tb));
> +	printf("purr_exprop_adjunct_busy:	0x%08lx\n", be64_to_cpu(vpa->purr_exprop_adjunct_busy));
> +	printf("spurr_exprop_adjunct_busy:	0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_adjunct_busy));
> +	printf("purr_exprop_adjunct_idle:	0x%08lx\n", be64_to_cpu(vpa->purr_exprop_adjunct_idle));
> +	printf("spurr_exprop_adjunct_idle:	0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_adjunct_idle));
> +	printf("adjunct_insns_executed:		0x%08lx\n", be64_to_cpu(vpa->adjunct_insns_executed));
> +	printf("dtl_index:			0x%08lx\n", be64_to_cpu(vpa->dtl_index));
> +}
> +
> +/**
> + * Test the H_REGISTER_VPA h-call register/deregister.
> + */
> +static void register_vpa(struct vpa *vpa)
> +{
> +	uint32_t cpuid = fdt_boot_cpuid_phys(dt_fdt());
> +	int disp_count1, disp_count2;
> +	int rc;
> +
> +	rc = hcall(H_REGISTER_VPA, 1ULL << 45, cpuid, vpa);
> +	report(rc == H_SUCCESS, "VPA registered");
> +
> +	print_vpa(vpa);
> +
> +	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
> +	report(disp_count1 % 2 == 0, "Dispatch count is even while running");
> +	msleep(100);
> +	disp_count2 = be32_to_cpu(vpa->vp_dispatch_count);
> +	report(disp_count1 != disp_count2, "Dispatch count increments over H_CEDE");
> +
> +	rc = hcall(H_REGISTER_VPA, 5ULL << 45, cpuid, vpa);
> +	report(rc == H_SUCCESS, "VPA deregistered");
> +
> +	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
> +	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
> +}

Now that was a very tame amount of tests ;-)

I'd suggest to add some more:

- Check hcall(H_REGISTER_VPA, 0, ...);
- Check hcall(H_REGISTER_VPA, ..., bad-cpu-id, ...)
- Check hcall(H_REGISTER_VPA, ..., ..., unaligned-address)
- Check hcall(H_REGISTER_VPA, ..., ..., illegal-address)
- Check registration with vpa->size being too small
- Check registration where the vpa crosses the 4k boundary

What do you think?

> +int main(int argc, char **argv)
> +{
> +	struct vpa *vpa;
> +
> +	vpa = memalign(4096, sizeof(*vpa));
> +
> +	memset(vpa, 0, sizeof(*vpa));
> +
> +	vpa->size = cpu_to_be16(sizeof(*vpa));
> +
> +	report_prefix_push("vpa");

This lacks the corresponding report_prefix_pop() later.

> +	register_vpa(vpa);
> +
> +	return report_summary();
> +}

  Thomas

