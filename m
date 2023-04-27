Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7F6F0A6E
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244039AbjD0RB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243965AbjD0RB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072281FF2
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 10:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682614870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4zoErSLaQl1SOUc0u/z6DpijlIxuPjTbsUTISxc4uc=;
        b=X8jMJENNegGrI/e1WJxXJ1MWru9ehtZ2BA2M7RiLluMkFP3MQpk/dr00UWhimJu7591Tf8
        os4DIohS1oGdG317ihJh2a8UQQbiImOh/0NZ6gQ9Y/NU7tV3cTMao/olhou2eI95WXibGS
        wdRTVFE1pmrv1YNyIaR5p5cuRPMwyEk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-ZJrzdSL-Nfy_AxoyNSLVTw-1; Thu, 27 Apr 2023 13:01:06 -0400
X-MC-Unique: ZJrzdSL-Nfy_AxoyNSLVTw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f170a1fbe7so53756985e9.2
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 10:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682614865; x=1685206865;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+4zoErSLaQl1SOUc0u/z6DpijlIxuPjTbsUTISxc4uc=;
        b=KXL0TmuQnbrc+z0VrUzwTaj5mDi3exnLUNjk0IKXpt13V2UAtBuvWSFGAZg8lKcnG1
         96wUj3xZvvCliaCGvqYjy5lS0cuVn+X3UUZ/+keA+qKyaijRDdlPkbCDQWYow6wkpS2v
         KVjLQ1TtKP22LjYkFXS0Dddr/Ofbpj6P+BBrfL24vbWowxaDx5hFBmOPdhOukkWY9qHV
         r27kHQEhgYFqFEEF2e2OoEKYzkEKOD4z7v9vwlyMB03ni7IuuE3UIWFeVEEBVVc0B6aW
         Nqq0kNiUOjZrJ8vTjZ1Dq/hbRqQSioYciUcLeNKyvCV5C5lamkPcJzhxrMWSmixn2bno
         o1mA==
X-Gm-Message-State: AC+VfDxgsAOeqqKxqTGQbRZh1MGqnIkmU6xJc0FlDFI9b6sWlBoc0BAw
        rPbGez0AUI7OcUIL9OrN4SZvwnVBo8PyarFZ+zOt4WrnaUHBhyNr6rd7DR9CspCUtM95lF8Wd4f
        2D9PPUuFs2Ztq
X-Received: by 2002:a7b:cc94:0:b0:3f1:69cc:475b with SMTP id p20-20020a7bcc94000000b003f169cc475bmr2044724wma.36.1682614865601;
        Thu, 27 Apr 2023 10:01:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5VyhNB35sMDCQitTJ3ajd2QxivcoZ4rss2QtvL0GpG7N7Lyp2rvije8x0FdvNo7nTV5tTH6w==
X-Received: by 2002:a7b:cc94:0:b0:3f1:69cc:475b with SMTP id p20-20020a7bcc94000000b003f169cc475bmr2044707wma.36.1682614865316;
        Thu, 27 Apr 2023 10:01:05 -0700 (PDT)
Received: from [192.168.8.102] (tmo-097-86.customers.d1-online.com. [80.187.97.86])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b003f173be2ccfsm33386819wmn.2.2023.04.27.10.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 10:01:04 -0700 (PDT)
Message-ID: <7ce19a3d-7b5a-1449-10c2-ee63c1471537@redhat.com>
Date:   Thu, 27 Apr 2023 19:01:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-4-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
In-Reply-To: <20230425161456.21031-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/04/2023 18.14, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   MAINTAINERS                     |   1 +
>   include/hw/s390x/cpu-topology.h |  24 +++
>   include/hw/s390x/sclp.h         |   1 +
>   target/s390x/cpu.h              |  72 ++++++++
>   hw/s390x/cpu-topology.c         |  13 +-
>   target/s390x/kvm/cpu_topology.c | 308 ++++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c          |   5 +-
>   target/s390x/kvm/meson.build    |   3 +-
>   8 files changed, 424 insertions(+), 3 deletions(-)
>   create mode 100644 target/s390x/kvm/cpu_topology.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bb7b34d0d8..de9052f753 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
>   S: Supported
>   F: include/hw/s390x/cpu-topology.h
>   F: hw/s390x/cpu-topology.c
> +F: target/s390x/kvm/cpu_topology.c

It's somewhat weird to have one file "cpu-topology.c" (in hw/s390x, with a 
dash), and one file cpu_topology.c (in target/s390x, with an underscore) ... 
could you come up with a better naming? Maybe call the new file 
stsi-topology.c or so?

> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index bb7cfb0cab..9f97989bd7 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -561,6 +561,25 @@ typedef struct SysIB_322 {
>   } SysIB_322;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);


Maybe add a short comment here what MAG stands for (magnitude fields?)?
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
> +} SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
...

> diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_topology.c
> new file mode 100644
> index 0000000000..86a286afe2
> --- /dev/null
> +++ b/target/s390x/kvm/cpu_topology.c
> @@ -0,0 +1,308 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/sclp.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/**
> + * fill_container:
> + * @p: The address of the container TLE to fill
> + * @level: The level of nesting for this container
> + * @id: The container receives a uniq ID inside its own container

s/uniq/unique/

  Thomas

