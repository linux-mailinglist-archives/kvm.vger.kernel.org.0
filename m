Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63E732456
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 02:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjFPAm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 20:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjFPAmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 20:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A13E2972
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 17:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686876100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVi/iSZIypb2rz83jbLdeVn8uEiZiibOapI7DmVf0UU=;
        b=MQuMfV44KpQWKGA8fVFXq8w0KBgwZj/RJIwYCOplvnUP2kC+ZSn+rMNktTfwfv6e4ICOkX
        tn++s1G3ND+iaHRLBmctJNx4rq1nOk5vdkxDGVB+jwebnjmxivwereHWSXIC+aGZVrKZ+Y
        bv2nBAqAz3oCk3s1ZJeQo9cqLUzYbM0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-eNmss-5NO3CkxiA6Jf7aBA-1; Thu, 15 Jun 2023 20:41:39 -0400
X-MC-Unique: eNmss-5NO3CkxiA6Jf7aBA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-25eb77bcd2fso13439a91.3
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 17:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686876097; x=1689468097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVi/iSZIypb2rz83jbLdeVn8uEiZiibOapI7DmVf0UU=;
        b=W2WUEfmvPMJ5pHoj2ymmsfWnKgyEe7114n/41nKa/goa/iCrY77XSqSxOjyfRep13y
         vt/DNJcpjB5LIfcH4J7zxf+Vpj/BPjb57mH99Ug7UY9dyYp8er4H8PQ2GOyiIJUq4kGk
         X12EPLtcHCNpQB/GUFORVyDw6/BGAx1k0gvYnlqmNVE2+bZkrXkLf0EEId/63GGQtpes
         EDMDsjHvk3+GRB2H9LK8/1aXr6FSLE/cqjLSSVRa+sHTbMkSl4O6WY+37h5REyBsaB9O
         eWkrqA/y1SrmjtaQtwPSUpzcUjqvODyFMaMBOs7yufhrU1XNCLqZlbbinIZl7w2j8KM2
         XBig==
X-Gm-Message-State: AC+VfDy377ohVrOKjAUGg/3dJ3/NLtSQ0RNxJbZ0VrZWJ93HWckuvUCh
        k9k6sqe9QmiQZxGjHw3PqAhC0dlDapJxAj3xbw2DMAqytveUw1u9LZ1Feya3oSWuVaVpIVGByHS
        lZyRUl5NY1UYIFdiz14kdvT0=
X-Received: by 2002:a17:90a:760c:b0:25b:d67c:6a9e with SMTP id s12-20020a17090a760c00b0025bd67c6a9emr448092pjk.16.1686876097569;
        Thu, 15 Jun 2023 17:41:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ66hZKofOAHTaqAzWgQ8l8u1H1l6VrFDfkHbJEsNGh4kvd3G3XkWzNM86Q73mR6t/1HtbJKpQ==
X-Received: by 2002:a17:90a:760c:b0:25b:d67c:6a9e with SMTP id s12-20020a17090a760c00b0025bd67c6a9emr448081pjk.16.1686876097216;
        Thu, 15 Jun 2023 17:41:37 -0700 (PDT)
Received: from ?IPV6:2001:8003:7475:6e00:1e1e:4135:2440:ee05? ([2001:8003:7475:6e00:1e1e:4135:2440:ee05])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090ac98100b0025bdc3454c6sm195045pjt.8.2023.06.15.17.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 17:41:36 -0700 (PDT)
Message-ID: <2a1b0e2b-a412-143a-9a57-5f2c12e8944c@redhat.com>
Date:   Fri, 16 Jun 2023 10:41:29 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties
 for accelerator
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, andrew.jones@linux.dev,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        shan.gavin@gmail.com
References: <20230615062148.19883-1-gshan@redhat.com>
 <168683636810.207611.6242722390379085462@t14-nrb>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <168683636810.207611.6242722390379085462@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nico,

On 6/15/23 23:39, Nico Boehr wrote:
> Quoting Gavin Shan (2023-06-15 08:21:48)
>> There are extra properties for accelerators to enable the specific
>> features. For example, the dirty ring for KVM accelerator can be
>> enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
>> extra properties for the accelerators aren't supported. It makes
>> it's impossible to test the combination of KVM and dirty ring
>> as the following error message indicates.
>>
>>    # cd /home/gavin/sandbox/kvm-unit-tests/tests
>>    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
>>       :
>>    BUILD_HEAD=2fffb37e
>>    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>>    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
>>    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
>>    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
>>    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
>>    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
>>
>> Allow to specify extra properties for accelerators. With this, the
>> "its-migration" can be tested for the combination of KVM and dirty
>> ring.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> Maybe get_qemu_accelerator could be renamed now, since it doesn't actually "get"
> anything, so maybe check_qemu_accelerator?
> 
> In any case, I gave it a quick run on s390x with kvm and tcg and nothing seems
> to break, hence for the changes in s390x:
> 
> Tested-by: Nico Boehr <nrb@linux.ibm.com>
> Acked-by: Nico Boehr <nrb@linux.ibm.com>
> 

Thanks for a quick try and comment for this. I guess it's fine to keep 
the function name as get_qemu_accelator() because $ACCEL is split into 
$ACCEL and $ACCEL_PROPS inside it, even it don't print the accelerator 
name at return. However, I'm also fine with check_qemu_accelerator(). 
Lets see what's Drew's comment on this and I can post v4 to have the 
modified function name, or an followup patch to modify the function name.

Thanks,
Gavin

