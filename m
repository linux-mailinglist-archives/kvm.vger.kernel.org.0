Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EF468BB6A
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBFLZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjBFLZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:25:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC425FD2
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675682669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qe5DgwtZfZkHkghEaga3ztbBsUoE1S7GKZ9kQ0chD+Y=;
        b=BVowiYxXZBocAikvKkl6r26kb0Bdg5yGB9A3t5euV6+vsZE9ja7Ws4F1looM+xTF8+IkQt
        p7YsgI5f4khssw5yVabcvPwG5rx+EM2SAq/hanYiW4mm74n/Jd16ww5LgtPszgP7I4iVrh
        bcM6uvxSlD/WqG+bQS3jpWQ48QYbuNI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-dbXZ8lBFO96DoxEk8x9ivA-1; Mon, 06 Feb 2023 06:24:28 -0500
X-MC-Unique: dbXZ8lBFO96DoxEk8x9ivA-1
Received: by mail-qt1-f200.google.com with SMTP id s4-20020ac85284000000b003b849aa2cd6so6270290qtn.15
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:24:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qe5DgwtZfZkHkghEaga3ztbBsUoE1S7GKZ9kQ0chD+Y=;
        b=HuFYByE1Qxz/5mtth6GhL4qwXb/50VuXlc+eDlnKx+r8pTR+bsP3aizYJuSsdBvXYc
         uQRdayEXeqHSoeY0D3A7PsJPoJkkNBN9m99/HOwK4bZChPmcl0oB2lu7bV1fupbfT+iD
         IItBwO8rtz9YuYA0voY+hVaWzW6yyTZKhAUEy9VBhKU8ql6C1wUPNSjkoGxlBPc/sxOu
         hD1GfiGN3dD9/s1UHjd2el5wR2+U0UxZdKF7Y215zxlQQikJ2GjTPIm/BGsXd+bucEat
         QdZ8qGY6bD3miN/P5Hx8lYOA9joX5goIvwXbocq4u9ZNYtBaJJUsPYjMTwWeL1YGIY5Y
         iyOg==
X-Gm-Message-State: AO0yUKUY1qkAMQjw98/be6pjDhaVizbOlUbamHQsPb+E8cWP4cuXswdc
        tLCZv6RoGt7oBUqIIy1BovMr97OciEMM5CSya3XmLL6gwUugc7pQwd/0hgOGqZkgLLx1uOzo9aG
        5ycR/tI6fPohB
X-Received: by 2002:ac8:5e48:0:b0:3b8:525e:15ec with SMTP id i8-20020ac85e48000000b003b8525e15ecmr35783583qtx.27.1675682668125;
        Mon, 06 Feb 2023 03:24:28 -0800 (PST)
X-Google-Smtp-Source: AK7set+7NzAHCdSslRalH6MmTl1ZQApqVtXM4b7XEETcTADkPxZfVO7d4ecRFI62s/PCBfiW7SZg7A==
X-Received: by 2002:ac8:5e48:0:b0:3b8:525e:15ec with SMTP id i8-20020ac85e48000000b003b8525e15ecmr35783549qtx.27.1675682667747;
        Mon, 06 Feb 2023 03:24:27 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id fz14-20020a05622a5a8e00b003b9e1d3a502sm7048796qtb.54.2023.02.06.03.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 03:24:27 -0800 (PST)
Message-ID: <107dd0bc-ab7d-2c91-65b3-2bf78d3b7d92@redhat.com>
Date:   Mon, 6 Feb 2023 12:24:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-4-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230201132051.126868-4-pmorel@linux.ibm.com>
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

On 01/02/2023 14.20, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
> index d3ade40a5a..712fd68123 100644
> --- a/include/hw/s390x/sclp.h
> +++ b/include/hw/s390x/sclp.h
> @@ -112,6 +112,7 @@ typedef struct CPUEntry {
>   } QEMU_PACKED CPUEntry;
>   
>   #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
> +#define SCLP_READ_SCP_INFO_MNEST                2
>   typedef struct ReadInfo {
>       SCCBHeader h;
>       uint16_t rnmax;
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index d654267a71..e1f6925856 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -560,6 +560,25 @@ typedef struct SysIB_322 {
>   } SysIB_322;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
>   
> +#define S390_TOPOLOGY_MAG  6
> +#define S390_TOPOLOGY_MAG6 0
> +#define S390_TOPOLOGY_MAG5 1
> +#define S390_TOPOLOGY_MAG4 2
> +#define S390_TOPOLOGY_MAG3 3
> +#define S390_TOPOLOGY_MAG2 4
> +#define S390_TOPOLOGY_MAG1 5
> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[S390_TOPOLOGY_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[];
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
>   typedef union SysIB {
>       SysIB_111 sysib_111;
>       SysIB_121 sysib_121;
> @@ -567,9 +586,62 @@ typedef union SysIB {
>       SysIB_221 sysib_221;
>       SysIB_222 sysib_222;
>       SysIB_322 sysib_322;
> +    SysIB_151x sysib_151x;
>   } SysIB;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>   
> +/*
> + * CPU Topology List provided by STSI with fc=15 provides a list
> + * of two different Topology List Entries (TLE) types to specify
> + * the topology hierarchy.
> + *
> + * - Container Topology List Entry
> + *   Defines a container to contain other Topology List Entries
> + *   of any type, nested containers or CPU.
> + * - CPU Topology List Entry
> + *   Specifies the CPUs position, type, entitlement and polarization
> + *   of the CPUs contained in the last Container TLE.
> + *
> + * There can be theoretically up to five levels of containers, QEMU
> + * uses only three levels, the drawer's, book's and socket's level.
> + *
> + * A container of with a nesting level (NL) greater than 1 can only
> + * contain another container of nesting level NL-1.
> + *
> + * A container of nesting level 1 (socket), contains as many CPU TLE
> + * as needed to describe the position and qualities of all CPUs inside
> + * the container.
> + * The qualities of a CPU are polarization, entitlement and type.
> + *
> + * The CPU TLE defines the position of the CPUs of identical qualities
> + * using a 64bits mask which first bit has its offset defined by
> + * the CPU address orgin field of the CPU TLE like in:
> + * CPU address = origin * 64 + bit position within the mask
> + *
> + */
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
> +
> +/* CPU type Topology List Entry */
> +typedef struct SysIBTl_cpu {
> +        uint8_t nl;
> +        uint8_t reserved0[3];
> +#define SYSIB_TLE_POLARITY_MASK 0x03
> +#define SYSIB_TLE_DEDICATED     0x04
> +        uint8_t entitlement;
> +        uint8_t type;
> +        uint16_t origin;
> +        uint64_t mask;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
> +
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);

__u64 is not a portable type (e.g. fails when doing "make 
vm-build-openbsd"), please replace with uint64_t.

  Thanks,
   Thomas

