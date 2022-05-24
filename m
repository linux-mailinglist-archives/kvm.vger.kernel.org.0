Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37597532867
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiEXK7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 06:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbiEXK7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 06:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D8108DDFB
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 03:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653389953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNIHolXOtba/KfroUvm6+nuHO3iQXM82ADLznV2LFSw=;
        b=YI1Oz5NFqR2b7lEBmOzbJvc2n7nkCyE5aZdiJWrvSC8IhHT33EqkZduW2AyzzC0Uq7/IkA
        rbMn+Va/tttHL1umS2fXSZYqyXZXRTEtbbxmyiv34DdaHkLGBIUg7hilGhnTMWdyBp07Dl
        4+9P6QpdIcGHCJ8nLYZZcpv23ZnfzFg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-voxK-fylNhuGm-tGpseP3Q-1; Tue, 24 May 2022 06:59:12 -0400
X-MC-Unique: voxK-fylNhuGm-tGpseP3Q-1
Received: by mail-wr1-f71.google.com with SMTP id e17-20020adfe391000000b0020e64e7dd15so4154330wrm.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 03:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=iNIHolXOtba/KfroUvm6+nuHO3iQXM82ADLznV2LFSw=;
        b=puk2xHOf86DeyCTpdVvD6W0817b21MtxpqNL/tJ2wlw10dCJhaKxqGgdmlen5bCG/T
         mUGdx74Xc/iMgqzZ31kL5QALSb3yDQ7dyrTfYXEQdETqOIoBu8zhBb9ixx9eWOKo1a3A
         +/w+ygvNBl3+DDkEMxeWnLZKdH7p6nTq0nc0jmidlbopelFvUz4Y4cIC3ellDgaAY+kB
         PYszzgg7O6PUgX30JAzL8gOco2XGnAa7f2ufgRhzuhmhrcyjx5uS+ubsUS+fxcFdL6jm
         S52OsxPJvSM4emwB8GSSSG67cURKXgQus2rsBeHKPVGFNKWJDc/zN8EToTO7KgLGqPXV
         Qg5Q==
X-Gm-Message-State: AOAM533jr5GW1E6/J8+5uYXkzXCXXZ+aUU9kUd6ZweVOeazmqu3FeLaw
        /hEjJgFH4ROh2MX72aNQrB2W8hoHutLSzazVJLk0CDXQDQ3mHEw26TTlPSss4MYQ+7q+X4Qn1S4
        mWLeUAhOr6/gU
X-Received: by 2002:a1c:f207:0:b0:397:450f:f247 with SMTP id s7-20020a1cf207000000b00397450ff247mr3285613wmc.145.1653389950894;
        Tue, 24 May 2022 03:59:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9ey+Wqex4qtAgv2ZF8qzeJqk1XGx+dUVsSADF4mHmLgu5sfKwPjaFxIOECu+x1Qg4oYdiWA==
X-Received: by 2002:a1c:f207:0:b0:397:450f:f247 with SMTP id s7-20020a1cf207000000b00397450ff247mr3285587wmc.145.1653389950662;
        Tue, 24 May 2022 03:59:10 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id v2-20020adfc5c2000000b0020fcd1704a4sm8734363wrg.61.2022.05.24.03.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 03:59:09 -0700 (PDT)
Message-ID: <6e426ed7-d3a6-2ae8-badc-80fc7a31c3ea@redhat.com>
Date:   Tue, 24 May 2022 12:59:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, philmd@redhat.com,
        eblake@redhat.com, armbru@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-5-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v7 04/13] s390x: topology: implementating Store Topology
 System Information
In-Reply-To: <20220420115745.13696-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/2022 13.57, Pierre Morel wrote:
> The handling of STSI is enhanced with the interception of the
> function code 15 for storing CPU topology.
> 
> Using the objects built during the pluging of CPU, we build the

s/pluging/plugging/

> SYSIB 15_1_x structures.
> 
> With this patch the maximum MNEST level is 2, this is also
> the only level allowed and only SYSIB 15_1_2 will be built.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index f6969b76c5..a617c943ff 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -889,4 +889,5 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>   
>   #include "exec/cpu-all.h"
>   
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
>   #endif

Please keep an empty line before the #endif

> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> new file mode 100644
> index 0000000000..7f6db18829
> --- /dev/null
> +++ b/target/s390x/cpu_topology.c
> @@ -0,0 +1,112 @@
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2021

2022 ?

> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
...
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> +{
> +    const MachineState *machine = MACHINE(qdev_get_machine());
> +    void *p;
> +    int ret, cc;
> +
> +    /*
> +     * Until the SCLP STSI Facility reporting the MNEST value is used,
> +     * a sel2 value of 2 is the only value allowed in STSI 15.1.x.
> +     */
> +    if (sel2 != 2) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    p = g_malloc0(TARGET_PAGE_SIZE);
> +
> +    setup_stsi(machine, p, 2);
> +
> +    if (s390_is_pv()) {
> +        ret = s390_cpu_pv_mem_write(cpu, 0, p, TARGET_PAGE_SIZE);
> +    } else {
> +        ret = s390_cpu_virt_mem_write(cpu, addr, ar, p, TARGET_PAGE_SIZE);
> +    }
> +    cc = ret ? 3 : 0;
> +    setcc(cpu, cc);

Just a matter of taste (i.e. keep it if you like) - but you could scratch 
the cc variable in this function by just doing:

     setcc(cpu, ret ? 3 : 0);

> +    g_free(p);
> +}
> +

  Thomas

