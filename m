Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA43968BBD5
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBFLjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBFLjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:39:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD5665B0
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675683495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yurOwrSYkMEr1+LImfWS1Ft2DGAumqBBKks44Ulqjc=;
        b=eJcWTMcnWY6KZZHNt/18zA8k/SbjulkThm35DfJB4hEN5LC779K4t4c9y/BhabUY5KV8Fs
        I+mOqzAOzQMbKP+rTaeL0rcvUmpJv2fxCI3KwquRa5aourUZFbBsrU5vaWqedrB226PfQ9
        VnQfCJm7oTG6DD5pOIyaDhXwvkqVHJk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-315-BIX1POhtO9CUBodwOr9baw-1; Mon, 06 Feb 2023 06:38:14 -0500
X-MC-Unique: BIX1POhtO9CUBodwOr9baw-1
Received: by mail-qv1-f72.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso5709047qvb.21
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0yurOwrSYkMEr1+LImfWS1Ft2DGAumqBBKks44Ulqjc=;
        b=JpRM3ko6bEMSa3EkwkRzxcqWtZNTSUaTQ3dLt8XEHm29qBhrDFySb0mbgTtJz9dUeg
         w1kNu7e+1ql1+KvGOP9cFoFjz1gkQqMkosXU4o6XIJeCYVRyaJ2mycr8XrKCsnZIOdtR
         FT4jTOcAaw29NFYB7d1n+t2/pFnCBp2C7bG1tIr7/liJihDwj6pG8GgNMjONQw/s1mE9
         RRcQdvK1dRcfWZhDYCJLgyWTKC4gbgUsJz1UpfT5vKv77q0IHvkD7k/wZNuyBrF4j0Je
         /Ru4LVb84OuwEukxk6hposy9WvDDi/GtQjJORcQE1mmR8FkLfTsl+sz/nB4aj1zp0DOt
         iVIg==
X-Gm-Message-State: AO0yUKWwT/mDPy/0mkyBlZiO4VU1Ir4JV1Fk9bOIq4Yz1OWlkC8oxvgO
        i5rYOqvWhQxuELVFyxnTYkVWSM/oPYQ8BKxdrfwUgz/qn0mf3vp0hdKY5+Q2cmyWITL+gwbdaNg
        GrCBio/byG7oE
X-Received: by 2002:a05:6214:20e3:b0:537:7e74:2d6a with SMTP id 3-20020a05621420e300b005377e742d6amr34541898qvk.3.1675683493907;
        Mon, 06 Feb 2023 03:38:13 -0800 (PST)
X-Google-Smtp-Source: AK7set9bdEFqgHWp1C10RyzvDFI9sRYQyMXT5vVscDNqI9UVkgLuRwREcF7/JuyuS0N//oHHVy6q/Q==
X-Received: by 2002:a05:6214:20e3:b0:537:7e74:2d6a with SMTP id 3-20020a05621420e300b005377e742d6amr34541864qvk.3.1675683493674;
        Mon, 06 Feb 2023 03:38:13 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id h67-20020a376c46000000b0070495934152sm7266775qkc.48.2023.02.06.03.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 03:38:13 -0800 (PST)
Message-ID: <92533b03-f07e-736a-4e29-bcdf883f7ec4@redhat.com>
Date:   Mon, 6 Feb 2023 12:38:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
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
 <20230201132051.126868-7-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
In-Reply-To: <20230201132051.126868-7-pmorel@linux.ibm.com>
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
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervizor activates the interpretation

s/hypervizor/hypervisor/

> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> 
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervizor.

dito

> During RESET all CPU of the configuration are placed in
> horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
>   /**
>    * s390_topology_reset:
>    *
>    * Generic reset for CPU topology, calls s390_topology_reset()
>    * s390_topology_reset() to reset the kernel Modified Topology
>    * change record.
> + * Then set global and all CPUs polarity to POLARITY_HORIZONTAL.

You describe here already what's going to happen...

>    */
>   void s390_topology_reset(void)
>   {
>       s390_cpu_topology_reset();
> +    /* Set global polarity to POLARITY_HORIZONTAL */

... then here again ...

> +    s390_topology.polarity = POLARITY_HORIZONTAL;

... and the code is (fortunately) also very self-exaplaining...

> +    /* Set all CPU polarity to POLARITY_HORIZONTAL */
> +    s390_topology_set_cpus_polarity(POLARITY_HORIZONTAL);

... so I'd rather drop the two comments within the function body.

>   }

(rest of the patch looks fine to me)

  Thomas

