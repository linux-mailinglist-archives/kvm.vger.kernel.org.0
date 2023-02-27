Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FD86A408F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjB0L1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjB0L1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:27:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8EE1E5FB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677497224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=usVkUNlkroDegW9nfri6NWDP4Mttqk+PRKDXK6b1Xd4=;
        b=hPW+1XlKG3HaA/rQb90HxwBklapRNBtQPRPrlYXUNx8cmOY/Y/FE3VYC2Uv+SDcLr0w2cG
        67yrS0Qt4MPmfkr6hTS//uZOnpot3/Axzy6r0qxq84COsl++2evhngE4R/9L5+YtLelXKQ
        rmram6180li0faQxH+GibnH666axnOo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-140-xzD57Ot9PgGvSbYWvP-aDw-1; Mon, 27 Feb 2023 06:27:03 -0500
X-MC-Unique: xzD57Ot9PgGvSbYWvP-aDw-1
Received: by mail-wm1-f69.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so5213874wms.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:27:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=usVkUNlkroDegW9nfri6NWDP4Mttqk+PRKDXK6b1Xd4=;
        b=Lk+uRUfC/M8lLCVOsiAat0T18pEVfLh1j6M6OIkc3hvZZAlSfsAwxzEprFU1xYy442
         nAnSzaSi5PZ1I7Fyfn0583zREZ6moKBS6UrIIgngWE3U7YM3yWTVzP9nJJMlvkOC3LIc
         OOauSAuai1AQdPX/jBZJmXquN12W6VndQfCG57JCZF9yRhiPiQizRB5W/BKqeyOuhP2o
         vVU1TrGxri9AIbpmWugDTJtUIlPCcNvbTTbucxxRv6QuRsriXbo8BXbILurJsvXH6EIT
         RUgqpZCZCbYOrJHcoAKAIf6Rpbcamg+hzc6x5yvnc/SUUmAE3VLwcp0lgmRru2aiEsJX
         YAEA==
X-Gm-Message-State: AO0yUKUEvT8yg9tnXf7MzZ5IU6YTJhd4Q6vkYGM0ouTczIFmWsoWDUlz
        Mrm2fkpnW6gKHsaMUGoag5m9h/WLntFjJr45+tsAiHihXsLg8msPfrjqtHcqwtHMnVlDDarOVRd
        WelT7GFbRIM6V
X-Received: by 2002:a05:600c:4929:b0:3dc:d5c:76d9 with SMTP id f41-20020a05600c492900b003dc0d5c76d9mr19013022wmp.0.1677497222452;
        Mon, 27 Feb 2023 03:27:02 -0800 (PST)
X-Google-Smtp-Source: AK7set+Dyb6pK1UFYS5nwu04lZDEnJ3AOeymWXyaqrDysUCzmOcIFKy0xwFwKoHjkV91ZwHHdTLkFQ==
X-Received: by 2002:a05:600c:4929:b0:3dc:d5c:76d9 with SMTP id f41-20020a05600c492900b003dc0d5c76d9mr19012993wmp.0.1677497222135;
        Mon, 27 Feb 2023 03:27:02 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id m33-20020a05600c3b2100b003eaee9e0d22sm9371610wms.33.2023.02.27.03.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 03:27:01 -0800 (PST)
Message-ID: <c4fe1937-f16f-b2d8-efde-3e60d94f4166@redhat.com>
Date:   Mon, 27 Feb 2023 12:26:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-9-pmorel@linux.ibm.com>
 <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
 <4335eac8-ba5d-5b6c-b19f-4b10a793ba0c@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
In-Reply-To: <4335eac8-ba5d-5b6c-b19f-4b10a793ba0c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/2023 11.57, Pierre Morel wrote:
> 
> On 2/24/23 18:15, Nina Schoetterl-Glausch wrote:
>> On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
>>> The modification of the CPU attributes are done through a monitor
>>> command.
>>>
>>> It allows to move the core inside the topology tree to optimize
>>> the cache usage in the case the host's hypervisor previously
>>> moved the CPU.
>>>
>>> The same command allows to modify the CPU attributes modifiers
>>> like polarization entitlement and the dedicated attribute to notify
>>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>>
>>> With this knowledge the guest has the possibility to optimize the
>>> usage of the vCPUs.
>>>
>>> The command has a feature unstable for the moment.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   qapi/machine-target.json |  35 +++++++++
>>>   include/monitor/hmp.h    |   1 +
>>>   hw/s390x/cpu-topology.c  | 154 +++++++++++++++++++++++++++++++++++++++
>>>   hmp-commands.hx          |  17 +++++
>>>   4 files changed, 207 insertions(+)
>>>
>>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>>> index a52cc32f09..baa9d273cf 100644
>>> --- a/qapi/machine-target.json
>>> +++ b/qapi/machine-target.json
>>> @@ -354,3 +354,38 @@
>>>   { 'enum': 'CpuS390Polarization',
>>>     'prefix': 'S390_CPU_POLARIZATION',
>>>     'data': [ 'horizontal', 'vertical' ] }
>>> +
>>> +##
>>> +# @set-cpu-topology:
>>> +#
>>> +# @core-id: the vCPU ID to be moved
>>> +# @socket-id: optional destination socket where to move the vCPU
>>> +# @book-id: optional destination book where to move the vCPU
>>> +# @drawer-id: optional destination drawer where to move the vCPU
>>> +# @entitlement: optional entitlement
>>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>>> +#
>>> +# Features:
>>> +# @unstable: This command may still be modified.
>>> +#
>>> +# Modifies the topology by moving the CPU inside the topology
>>> +# tree or by changing a modifier attribute of a CPU.
>>> +# Default value for optional parameter is the current value
>>> +# used by the CPU.
>>> +#
>>> +# Returns: Nothing on success, the reason on failure.
>>> +#
>>> +# Since: 8.0
>>> +##
>>> +{ 'command': 'set-cpu-topology',
>>> +  'data': {
>>> +      'core-id': 'uint16',
>>> +      '*socket-id': 'uint16',
>>> +      '*book-id': 'uint16',
>>> +      '*drawer-id': 'uint16',
>>> +      '*entitlement': 'str',
>> How about you add a machine-common.json and define CpuS390Entitlement there,
>> and then include it from both machine.json and machine-target.json?
>>
>> Then you can declare it as CpuS390Entitlement and don't need to do the 
>> parsing
>> manually.
>>
>> You could also put it in common.json, but that seems a bit too generic.
>>
>> Anyone have objections?
> 
> Seems Thomas has questions, I wait until every body agree or not agree.

I'd be fine with such a change if it works ... I just got no clue whether it 
works or not, so you've got to try it, I guess.

But I think I'd rather avoid naming the file "machine-common.json" ... 
"machine.json" is already supposed to be the common code that can be shared 
between all targets, so having a "machine-common.json" file would be super 
confusing, I think.

OTOH, what's the reason again for having CpuS390Entitlement in machine.json? 
Couldn't it be moved to machine-target.json instead?

  Thomas

