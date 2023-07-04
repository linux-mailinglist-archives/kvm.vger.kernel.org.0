Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7687274728C
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 15:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjGDNTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 09:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjGDNSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 09:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885901733
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 06:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688476497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HgU56Jb9oAALfA5DNLs9cSNt9PhE+0rEJU0KndMkfmw=;
        b=XTpq4y6nAWpvUBe2yNLOE7dYaCcE00kVmEGPXuUL88DNrzGEMkTB06Dv5JKC4QJFjLygXA
        ySk59tRw0kDIfjhmkZtF7TALuBUrbiUQwgve8g6/donicaI1WmzFvfwWS7dP9zLitTwou+
        hmFeCBl7SFte7wHkj6pXSX7Xi50Rp6k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-RB9MJ8MGMDChI99fvIRKFw-1; Tue, 04 Jul 2023 09:14:56 -0400
X-MC-Unique: RB9MJ8MGMDChI99fvIRKFw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-40328438392so57842291cf.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 06:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688476496; x=1691068496;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HgU56Jb9oAALfA5DNLs9cSNt9PhE+0rEJU0KndMkfmw=;
        b=V4mx+xoU6NpvVKMgTH8vEgILJdpf8gZXY8Rccwxf+fNRwuGSiN4nem2vQLJuBNNkgs
         frakaoBHMUgpg7ScxN7y3sgnW2oIVW2x1If0VwjVxClum9IYRNZmcfQmMIEODuTFIBzk
         98Yi5UgHDVdUhCc7EN8xYizB8TDUiPl6EOL1wXdNXeDPTGbLexkuuEIK1+TKWMOxDvfX
         dXklnRLQYx/9BN1/3/ktRPevpoZ7GnLLgyzWcKAu+FWifitlKh1ZQQjHiSLtA0A6yd4R
         PQplCTkWB2ewEe0KzVYQI8MaSm+b5ms0DomibyzUEHy6yhLcBi/ttOXrg+dxdnwoPCM9
         Uubg==
X-Gm-Message-State: AC+VfDyCiAyQfwkzCuwRsxgDAdN1gmDAVSSfNJtXFyu2o3GunvhiB4Mr
        MWf5K5r8MUB8wJUIJM4w/z5vafdGG27nejAtqLd4o8aqGs+b1fwsMhO8V4PE/hoVWtYQyEE2CN2
        j8jPw88AkOoHT
X-Received: by 2002:a05:622a:54b:b0:403:2066:fd4a with SMTP id m11-20020a05622a054b00b004032066fd4amr16238497qtx.33.1688476496082;
        Tue, 04 Jul 2023 06:14:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60Hhv6E/D+lFNFeHht/lNY2cZw1ZCZ2ynIsM8esIAOxcMhjUvu2r7D4Ht4xPL8BLFjYp2gEA==
X-Received: by 2002:a05:622a:54b:b0:403:2066:fd4a with SMTP id m11-20020a05622a054b00b004032066fd4amr16238468qtx.33.1688476495803;
        Tue, 04 Jul 2023 06:14:55 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id f14-20020ac859ce000000b003f9c6a311e1sm11131824qtf.47.2023.07.04.06.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 06:14:55 -0700 (PDT)
Message-ID: <3ea3a276-a06a-b1b3-bc88-662c94d240e0@redhat.com>
Date:   Tue, 4 Jul 2023 15:14:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 14/20] tests/avocado: s390x cpu topology core
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-15-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-15-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> Introduction of the s390x cpu topology core functions and
> basic tests.
> 
> We test the corelation between the command line and
> the QMP results in query-cpus-fast for various CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   MAINTAINERS                    |   1 +
>   tests/avocado/s390_topology.py | 196 +++++++++++++++++++++++++++++++++
>   2 files changed, 197 insertions(+)
>   create mode 100644 tests/avocado/s390_topology.py
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76f236564c..12d0d7bd91 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1705,6 +1705,7 @@ F: hw/s390x/cpu-topology.c
>   F: target/s390x/kvm/stsi-topology.c
>   F: docs/devel/s390-cpu-topology.rst
>   F: docs/system/s390x/cpu-topology.rst
> +F: tests/avocado/s390_topology.py
>   
>   X86 Machines
>   ------------
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> new file mode 100644
> index 0000000000..1758ec1f13
> --- /dev/null
> +++ b/tests/avocado/s390_topology.py
> @@ -0,0 +1,196 @@
> +# Functional test that boots a Linux kernel and checks the console
> +#
> +# Copyright IBM Corp. 2023
> +#
> +# Author:
> +#  Pierre Morel <pmorel@linux.ibm.com>
> +#
> +# This work is licensed under the terms of the GNU GPL, version 2 or
> +# later.  See the COPYING file in the top-level directory.
> +
> +import os
> +import shutil
> +import time
> +
> +from avocado_qemu import QemuSystemTest
> +from avocado_qemu import exec_command
> +from avocado_qemu import exec_command_and_wait_for_pattern
> +from avocado_qemu import interrupt_interactive_console_until_pattern
> +from avocado_qemu import wait_for_console_pattern
> +from avocado.utils import process
> +from avocado.utils import archive
> +
> +
> +class S390CPUTopology(QemuSystemTest):
> +    """
> +    S390x CPU topology consist of 4 topology layers, from bottom to top,
> +    the cores, sockets, books and drawers and 2 modifiers attributes,
> +    the entitlement and the dedication.
> +    See: docs/system/s390x/cpu-topology.rst.
> +
> +    S390x CPU topology is setup in different ways:
> +    - implicitely from the '-smp' argument by completing each topology

implicitly

> +      level one after the other begining with drawer 0, book 0 and socket 0.

beginning

> +    - explicitely from the '-device' argument on the QEMU command line

explicitly

> +    - explicitely by hotplug of a new CPU using QMP or HMP

explicitly

  Thomas

