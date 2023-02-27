Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1B6A3BEC
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjB0IAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjB0IAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:00:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482FB1117D
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 23:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677484762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSB2JpodE8sZyJM1yWA/wzyyEAdvIrDjsUCzMJhckF4=;
        b=fyWMAmSlbjII5DyK8dyFHjLDHrCGTw5jx5Jqh2hJpAdAUzQ114JcbseDadVRWpqitZpJiB
        cUxF0SMbBJlR8G2QkJaazbZDM2u7e8uq36TfU9GyzoIlrI5oB1AC9ZNR+Sng9+bS89rYdc
        Bb9WidcMNludNM55r76g+BCHiPhfj0w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-jnfQ6hVuPKyrdLSXJdILLQ-1; Mon, 27 Feb 2023 02:59:20 -0500
X-MC-Unique: jnfQ6hVuPKyrdLSXJdILLQ-1
Received: by mail-wm1-f72.google.com with SMTP id m28-20020a05600c3b1c00b003e7d4662b83so5006466wms.0
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 23:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSB2JpodE8sZyJM1yWA/wzyyEAdvIrDjsUCzMJhckF4=;
        b=tJleZ+voT2bg/S2IkxeAjF7mbxkJ8mZ2AOgiaZdNQizknY6s/aD0Fn1cctYK8dYX9K
         XwAmLjxG2EBD5gh8ZZ4IlLahEObPTlyv3tKX6Ebab2vK8TLvtm/bIYdOC+VpzQ3W+gKg
         +gVBBinUTqkugxg4Z6K6RE04gmm/A3OWRGF7S0OQyuBAIh4lqLG/mSjZMCQGsD+6WyDC
         bphKlfhPYMb0ZB90ZbE9yhU3T6B2ptdURehdXchVC5m5LwxFaBUOSivrwPSXIsTRD953
         SieUMaRbOISB4MH1MAX21RpK6vycKKxf5A0rb8920nFGfd0eC2h0Vk1bV7nRVgmqHh8u
         lXxA==
X-Gm-Message-State: AO0yUKX0Rs4nur9sDRNrPzb5OFFgqK86k+8yajXA5WgXaTFSyBxNTwQA
        suMH2YKqtng7bWQF0EPhbLV88pigxF+DXx+qDP/oDrTPcSWgEPc90vnnhODnVg2dvRMENY6ebvQ
        s4clCA7Wq2N7N
X-Received: by 2002:a05:6000:1005:b0:2c9:97f8:2604 with SMTP id a5-20020a056000100500b002c997f82604mr4642068wrx.14.1677484758994;
        Sun, 26 Feb 2023 23:59:18 -0800 (PST)
X-Google-Smtp-Source: AK7set+Osqlt3nxOK14nQvtcQm9/Yl2gx2MpF2q5Ms1VYsaRJiZZ3XljP9gj61qAn8kHnrdci+cfPg==
X-Received: by 2002:a05:6000:1005:b0:2c9:97f8:2604 with SMTP id a5-20020a056000100500b002c997f82604mr4642047wrx.14.1677484758691;
        Sun, 26 Feb 2023 23:59:18 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d5704000000b002c559843748sm6361875wrv.10.2023.02.26.23.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 23:59:18 -0800 (PST)
Message-ID: <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
Date:   Mon, 27 Feb 2023 08:59:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-9-pmorel@linux.ibm.com>
 <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/2023 18.15, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> command.
>>
>> It allows to move the core inside the topology tree to optimize
>> the cache usage in the case the host's hypervisor previously
>> moved the CPU.
>>
>> The same command allows to modify the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> The command has a feature unstable for the moment.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json |  35 +++++++++
>>   include/monitor/hmp.h    |   1 +
>>   hw/s390x/cpu-topology.c  | 154 +++++++++++++++++++++++++++++++++++++++
>>   hmp-commands.hx          |  17 +++++
>>   4 files changed, 207 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index a52cc32f09..baa9d273cf 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -354,3 +354,38 @@
>>   { 'enum': 'CpuS390Polarization',
>>     'prefix': 'S390_CPU_POLARIZATION',
>>     'data': [ 'horizontal', 'vertical' ] }
>> +
>> +##
>> +# @set-cpu-topology:
>> +#
>> +# @core-id: the vCPU ID to be moved
>> +# @socket-id: optional destination socket where to move the vCPU
>> +# @book-id: optional destination book where to move the vCPU
>> +# @drawer-id: optional destination drawer where to move the vCPU
>> +# @entitlement: optional entitlement
>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>> +#
>> +# Features:
>> +# @unstable: This command may still be modified.
>> +#
>> +# Modifies the topology by moving the CPU inside the topology
>> +# tree or by changing a modifier attribute of a CPU.
>> +# Default value for optional parameter is the current value
>> +# used by the CPU.
>> +#
>> +# Returns: Nothing on success, the reason on failure.
>> +#
>> +# Since: 8.0
>> +##
>> +{ 'command': 'set-cpu-topology',
>> +  'data': {
>> +      'core-id': 'uint16',
>> +      '*socket-id': 'uint16',
>> +      '*book-id': 'uint16',
>> +      '*drawer-id': 'uint16',
>> +      '*entitlement': 'str',
> 
> How about you add a machine-common.json and define CpuS390Entitlement there,
> and then include it from both machine.json and machine-target.json?

I'm not sure whether double inclusion works with the QAPI parser (since this 
might code to be generated twice) ... have you tried?

  Thomas

