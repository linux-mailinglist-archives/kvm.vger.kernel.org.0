Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D136A429A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjB0N1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB0N1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:27:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7224C1968A
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677504411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sGqh4Ik+oRbmAsuqw2wIJX12fd2+4f+6hgrcZKwbZPM=;
        b=gn/jkCe7E33Nd5FQmqSGORZYIinHgT+no4gjDbOmYlW9EfAwpq6SfmAQl8KJbpiyMA4pfp
        mQdAMOwDkvXLj37k/djQ2o1inwt+PhFgxFbHXF7VF+gWXMsrAhnuxZamCJUZS/rCHzP58A
        F7Tbq7pKrRtQSkQmPI2mAuqSZOpbKOs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-bt3TCyNeORGyBSSFveh9VQ-1; Mon, 27 Feb 2023 08:26:50 -0500
X-MC-Unique: bt3TCyNeORGyBSSFveh9VQ-1
Received: by mail-wm1-f71.google.com with SMTP id j6-20020a05600c1c0600b003eaf882cb85so2880905wms.9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGqh4Ik+oRbmAsuqw2wIJX12fd2+4f+6hgrcZKwbZPM=;
        b=DnX3AssWXm9RaEResVD5MSHI+kmroYVQEhnfEqBUEOtzu9XMconsw7mErmx+v7g8nA
         36uODL4n8IMPiSc5en9g8QRGgWNa9h+MyNNtWiC77r+plBYgffA2bSCiZxbp7GQZ/QFH
         deedFRnoMRJbjfH/iK5I9JhZ9xX99G+983hKSSQcB3a5jv6VapVOt1BdlC7NLlDf9kFs
         vl6lEmvfmnZkvbVT/0r6PvXgkC63gXzzNWINvfzzdYo/7d2Nkp7ZUWrOuv1Pn6FWnPkd
         fTAkjvflw64QvvWZL/X4/PminOXHBZhzLGHqwS0pQCD3JFajgRn0aj2GXtie7jpJUTZC
         PhbA==
X-Gm-Message-State: AO0yUKUphgetE63+1G9ca4+WUcwXwvybHCSUeShOKRF7wevEfscMZiY8
        bnYz/3TARPlI+luC4GV7xHr57SxVXvSOYX2KKtl0X11MAKsIxT+IBi618+FxVWwnN449gBPTzH0
        NvorGGpPLe3k6
X-Received: by 2002:a05:600c:4b30:b0:3e2:147f:ac1a with SMTP id i48-20020a05600c4b3000b003e2147fac1amr16979596wmp.21.1677504409145;
        Mon, 27 Feb 2023 05:26:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+1Avf/Yrs1gCObx/1C7m2Kv9QB7PbtYi2lYA8hdBhRrl2VrOlIf0xJ6+wmmfRF04u3VOB9Eg==
X-Received: by 2002:a05:600c:4b30:b0:3e2:147f:ac1a with SMTP id i48-20020a05600c4b3000b003e2147fac1amr16979576wmp.21.1677504408926;
        Mon, 27 Feb 2023 05:26:48 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id iz10-20020a05600c554a00b003e2243cfe15sm9095089wmb.39.2023.02.27.05.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 05:26:48 -0800 (PST)
Message-ID: <b90a748c-e56c-840a-e983-6fc608a10e13@redhat.com>
Date:   Mon, 27 Feb 2023 14:26:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 07/11] target/s390x/cpu topology: activating CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-8-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230222142105.84700-8-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2023 15.21, Pierre Morel wrote:
> The KVM capability KVM_CAP_S390_CPU_TOPOLOGY is used to
> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility in the host CPU model for the guest
> in the case the topology is available in QEMU and in KVM.
> 
> The feature is disabled by default and fenced for SE
> (secure execution).
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/cpu-topology.c   | 2 +-
>   target/s390x/cpu_models.c | 1 +
>   target/s390x/kvm/kvm.c    | 9 +++++++++
>   3 files changed, 11 insertions(+), 1 deletion(-)

Maybe s/activating/activate/ in the subject?

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

