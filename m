Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E213671AD1
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 12:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjARLhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 06:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjARLf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 06:35:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052B165EE5
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674039217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGXmpUwAeTH/kxtJIZHfySccA2It9oZAfAEMfDSJlm4=;
        b=iYCIuRX1Ely2QX3ogsSdXgLgPi8av5aPRbSAHr5qchZPFzKwVO0dbsZ2dHZwmCiielEH8F
        W6Jj3GkcS08RAc2dRw4+l73AjCUqDtE4b6QUjmCRgbMtOr3Y+ogNiHkV+3M0B7QgtNVwRs
        qPX57TR2v/l5LtQPBapTUx0QoAH+SwA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-_PytCYVTPiWlwwIYq-R-kA-1; Wed, 18 Jan 2023 05:53:30 -0500
X-MC-Unique: _PytCYVTPiWlwwIYq-R-kA-1
Received: by mail-qv1-f71.google.com with SMTP id lv8-20020a056214578800b0053477624294so7347274qvb.22
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:53:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGXmpUwAeTH/kxtJIZHfySccA2It9oZAfAEMfDSJlm4=;
        b=auqx2+XaxH73YdXr0E1E7Y22LSP9t1pGayrQBt1lEAnJ0/8okLNHoG5FOVohzFNPcA
         fXP2CFSddNf7dShzhJTBpY/ifiyqfv16bxlRU/iZ8y1uIecOxVh9vQtwQBcadcFD0cXN
         lFjFDGS0WpR03P6Pe4K3oZk1JhFcKOs0o2exATbDoCdo3Z/+LbtJ96nhtuP6frib1tl7
         qjw0GjIBb+e+rcIhn+LGJIsjyIOZX1hOeldamG7VxsIW3VPu2fiVby+JqgHNPYa7evFg
         uBFDiNcqC/VcKxO8bLlK6KHoTvWQPFkrLoIf6IpgmJ5BziYbzP9e7Vaq9FijCI44Hgqz
         dz6Q==
X-Gm-Message-State: AFqh2kpFCdTmmwcrXi0m+6x78+c00C2kkUyoMsvGNq6Kp9jWTVeaTjdu
        bvLBnSp/3j8eiclYvLWvd4moDV6e46n1wxRFbk+EqtgYlQlGT7zpCEufD1XJHfaFybkYGfnTSfL
        xsgSmV7YdA5SG
X-Received: by 2002:a05:6214:3993:b0:532:2cb5:33e4 with SMTP id ny19-20020a056214399300b005322cb533e4mr10833167qvb.14.1674039210229;
        Wed, 18 Jan 2023 02:53:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXucfllY5mmpVeqsTi+ztYzxHjtf/bPaSXptzqeiXdz3lUyMxozOucyeHKbgmIQrNCd3houxgQ==
X-Received: by 2002:a05:6214:3993:b0:532:2cb5:33e4 with SMTP id ny19-20020a056214399300b005322cb533e4mr10833129qvb.14.1674039209978;
        Wed, 18 Jan 2023 02:53:29 -0800 (PST)
Received: from [192.168.8.105] (tmo-099-5.customers.d1-online.com. [80.187.99.5])
        by smtp.gmail.com with ESMTPSA id k19-20020a05620a415300b006fbaf9c1b70sm6940822qko.133.2023.01.18.02.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 02:53:29 -0800 (PST)
Message-ID: <91566c93-a422-7969-1f7e-80c6f3d214f1@redhat.com>
Date:   Wed, 18 Jan 2023 11:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        hreitz@redhat.com
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
 <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
 <5654d88fb7d000369c6cfdbe0213ca9d2bfe013b.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
In-Reply-To: <5654d88fb7d000369c6cfdbe0213ca9d2bfe013b.camel@linux.ibm.com>
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

On 17/01/2023 14.31, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-01-17 at 08:30 +0100, Thomas Huth wrote:
>> On 16/01/2023 22.09, Nina Schoetterl-Glausch wrote:
>>> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>>>> The modification of the CPU attributes are done through a monitor
>>>> commands.
>>>>
>>>> It allows to move the core inside the topology tree to optimise
>>>> the cache usage in the case the host's hypervizor previously
>>>> moved the CPU.
>>>>
>>>> The same command allows to modifiy the CPU attributes modifiers
>>>> like polarization entitlement and the dedicated attribute to notify
>>>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>>>
>>>> With this knowledge the guest has the possibility to optimize the
>>>> usage of the vCPUs.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
...
>>>> +    s390_topology.sockets[s390_socket_nb(id)]--;
>>>
>>> I suppose this function cannot run concurrently, so the same CPU doesn't get removed twice.
>>
>> QEMU has the so-called BQL - the Big Qemu Lock. Instructions handlers are
>> normally called with the lock taken, see qemu_mutex_lock_iothread() in
>> target/s390x/kvm/kvm.c.
> 
> That is good to know, but is that the relevant lock here?
> We don't want to concurrent qmp commands. I looked at the code and it's pretty complicated.

Not sure, but I believe that QMP commands are executed from the main 
iothread, so I think this should be safe? ... CC:-ing some more people who 
might know the correct answer.

  Thomas

