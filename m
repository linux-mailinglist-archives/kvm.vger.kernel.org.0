Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8333468BAF4
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBFLG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBFLG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07C61B322
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675681540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfjfmUxwTKU+QXw1YU4iVeGaLQIE4RvLq+RBzp6IhnA=;
        b=XseX0qwPS54qccquy2L4CUMtgAzDSXLkLcRi1YbAmVRAsGQLCCXzSA4vjohsPryyzdDlhd
        AvgaNeDJrF878bCuXXmdJNv+DE316sLYEa39du942w4asTKkAazDaQS6/PbD5n3ZCof0Sk
        JDpQXvaQ4jnJ9MBSw/F5VIa8N/ZIf9U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-361-pgVAyg1lOgKbKlv98Fwg2Q-1; Mon, 06 Feb 2023 06:05:37 -0500
X-MC-Unique: pgVAyg1lOgKbKlv98Fwg2Q-1
Received: by mail-qv1-f71.google.com with SMTP id e8-20020ad44188000000b0056976ba785bso3538184qvp.18
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UfjfmUxwTKU+QXw1YU4iVeGaLQIE4RvLq+RBzp6IhnA=;
        b=E72dZyNHfeyJZx1MdsJxKJiM88jKRb73WhOQudKVuIaUAJ60/s8OfNtlyKXBMdVDw4
         CJp1rbdd6RJFd9LyHcb1IJj3DK+2sxXnzCRbap+kPRGw3tFMVOgjJdTR6ugjItTfxQCG
         AoDU3h4ADPG46UQmcIO4nXflD7QxAIXJAjwDTOnham+n87GHLXafBtDgHy1BbR8rWXVQ
         ZjqR7Jzkjiv/Z/0tRHm1EA8LbtLCyYohoSuYQeOY4lSneyTE+v+X2ndjtHXa0LiOaWXc
         QyvtCIJrqa0IgutZuWEB77J51areuiJnI2tqNcOOg7gjXPT+WwfdxI1NPMABM5uaR7R/
         uXbg==
X-Gm-Message-State: AO0yUKWh1IuyKhukCM/idx8G1oqndmsYMXz4lpGZo+q2mOXe3P5kFicK
        a0G024tIMlEfkeNTxXsPeodJLDHx4yTcyl3g9+/Cw+qz/LRKa5LaIqkfd8sg9Cn/pVCNHQMX96i
        3ruXS+rI27/ES
X-Received: by 2002:a05:6214:501d:b0:56b:f017:c2e4 with SMTP id jo29-20020a056214501d00b0056bf017c2e4mr10691121qvb.47.1675681537128;
        Mon, 06 Feb 2023 03:05:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+OMXux1Z7XKGdmznt0xi2H1VDXN88UtnWbMtsGZ4wF12iXYhWtqpIGrrXVBQv9auGxGBAV1A==
X-Received: by 2002:a05:6214:501d:b0:56b:f017:c2e4 with SMTP id jo29-20020a056214501d00b0056bf017c2e4mr10691100qvb.47.1675681536928;
        Mon, 06 Feb 2023 03:05:36 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id w12-20020a05620a0e8c00b006f7ee901674sm7191289qkm.2.2023.02.06.03.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 03:05:36 -0800 (PST)
Message-ID: <88c4686a-985c-9465-d4dd-6cd5b2faa026@redhat.com>
Date:   Mon, 6 Feb 2023 12:05:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 05/11] s390x/cpu topology: resetting the
 Topology-Change-Report
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
 <20230201132051.126868-6-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230201132051.126868-6-pmorel@linux.ibm.com>
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
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
> bit of the SCA in the case of a subsystem reset.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index a80a1ebf22..cf63f3dd01 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -85,6 +85,18 @@ static void s390_topology_init(MachineState *ms)
>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>   }
>   
> +/**
> + * s390_topology_reset:
> + *
> + * Generic reset for CPU topology, calls s390_topology_reset()
> + * s390_topology_reset() to reset the kernel Modified Topology

Duplicated s390_topology_reset() in the comment.

> + * change record.
> + */
> +void s390_topology_reset(void)
> +{
> +    s390_cpu_topology_reset();
> +}

With the nit fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

