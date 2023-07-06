Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44187499C3
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjGFKuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 06:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjGFKtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 06:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA11BD3
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 03:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688640538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fILFizqa3mOZ2MONz3RieRKOc0s5FEVPoEVIOXL4bps=;
        b=dlUW7MVwobHj57MmCmdSrxypjTf7g8+QN10QprAz+sDMRrH+BgS0/AEnqazhsrKHvOPF8M
        mZuD9z9FP6nSe+yfDeWVaGYh/0rlRW/z2fkF/OBZ/cLAw+YxNXSL5Tcb6otA/CHZr+H+KZ
        ws3S+29D2+mJ3ajrLOqiXW3z2v2g8ts=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-wPZh2pHNMuOkfO6jliFaow-1; Thu, 06 Jul 2023 06:48:55 -0400
X-MC-Unique: wPZh2pHNMuOkfO6jliFaow-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7675581a4afso85644785a.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 03:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688640534; x=1691232534;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fILFizqa3mOZ2MONz3RieRKOc0s5FEVPoEVIOXL4bps=;
        b=cDFWZhKoiqSQT2+1xlz0WpVbQ5Q+gdFhkevNYrIxT9XMh5F/7t2SUx7PtV7KM6D061
         uIny9gyjgxO2G2Nmt0lGSPhJ5k/FTiVMV12HZ4iJLhFV2Hua77MKzz6YN6RacnB8g81w
         6FkGHfujVyYipi9cJ+JTOnsWDR7AIjxDokPulF8rY5VOqGKEm4WecezWm+uRUO7Vez2O
         gVbWiVDKJpeaHN+NkHwgtFYS78rpO3NomwnPIkkPUbqNsl3uifR8wSoPo0P3kDo0Cvhj
         CYD2hDDXSlC3sLo9JB60cb4LO3JGoCniX6ur6UczIQrRT4vz6PGGiEzOqhtKUFyPRflR
         nSQA==
X-Gm-Message-State: ABy/qLarLOmG4AEzEMgeA38DEA8DeyHWDMDRbhuCrxJ66egDrwc459I8
        dVUdE7uxwFjJVHBo0gLsZBP4NIIz4hLaGTaCKQzxabgL7foFDJD+41PajQDv1xycdzw298Q0PPc
        nRIhJ8Ixds3hk
X-Received: by 2002:a37:b407:0:b0:763:e407:4eec with SMTP id d7-20020a37b407000000b00763e4074eecmr1424982qkf.50.1688640534798;
        Thu, 06 Jul 2023 03:48:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEvcim9m3gxXGvb3OLQEio9UsinQQTF4Y+qtEnmb8XHNUyS6/HWIv+OQk2vbnLPCpsVCL3Ytg==
X-Received: by 2002:a37:b407:0:b0:763:e407:4eec with SMTP id d7-20020a37b407000000b00763e4074eecmr1424968qkf.50.1688640534582;
        Thu, 06 Jul 2023 03:48:54 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-114.web.vodafone.de. [109.43.176.114])
        by smtp.gmail.com with ESMTPSA id j28-20020a05620a147c00b00767410d18c3sm623369qkl.36.2023.07.06.03.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jul 2023 03:48:53 -0700 (PDT)
Message-ID: <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
Date:   Thu, 6 Jul 2023 12:48:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking
 Configuration Topology Information
In-Reply-To: <20230627082155.6375-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/2023 10.21, Pierre Morel wrote:
> STSI with function code 15 is used to store the CPU configuration
> topology.
> 
> We retrieve the maximum nested level with SCLP and use the
> topology tree provided by sockets and cores only to stay
> compatible with qemu topology before topology extension with

"before checking ..." ?

> drawers and books.
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
>   lib/s390x/sclp.c    |   6 +
>   lib/s390x/sclp.h    |   4 +-
>   lib/s390x/stsi.h    |  36 +++++
>   s390x/topology.c    | 326 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   4 +
>   5 files changed, 375 insertions(+), 1 deletion(-)

Does this patch series depend on some other patches that are not upstream 
yet? I just tried to run the test, but I'm only getting:

  lib/s390x/sclp.c:122: assert failed: read_info

Any ideas what could be wrong?

  Thomas

