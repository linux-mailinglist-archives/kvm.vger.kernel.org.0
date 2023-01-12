Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81440666BF0
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 09:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjALIBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 03:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjALIBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 03:01:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2FB5FFB
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 00:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673510418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4bxeZcxobHQBs+caVgx7QtjuGc0zW2B7T+w1D6B7yIs=;
        b=hzPi8dN91BaMEu2SIpJrLvlE6mHj4hVJTHP9hzhEHH4LmJNH0PkxtJ1qefn80yJ207VBtl
        6w2atXDz/YAvW4fDUWOb6wev3d6a7eRk67SnszqTc7BNxABAzEOUSKMn4GVmX0O4ah2pGy
        cnrwxIH2oim4RVbuZmPnlPOwiaxZCY0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-335-mzbBsdrqN4u49VuPcHL0Sw-1; Thu, 12 Jan 2023 03:00:16 -0500
X-MC-Unique: mzbBsdrqN4u49VuPcHL0Sw-1
Received: by mail-wr1-f69.google.com with SMTP id k18-20020adfb352000000b002bdd0a7a2b5so272945wrd.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 00:00:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bxeZcxobHQBs+caVgx7QtjuGc0zW2B7T+w1D6B7yIs=;
        b=7U8T/Vf+4u8yKw9T9QsvR+vIpLdw7tisVARcPE+Vw9QhklzupKFXcEAcYtdffeHDl4
         772Ml4WCSfmFLa34KHS4JPKN28M8tf3beZvthkzlFlfc/vME6BZD5luZMQBXaUJ4IxrO
         zIwPVH31r88GdbWsCoE4WWJLx5n/D6R45XEMjYXsP6jWsi3IBSDn+tjKacvaERwSbRsb
         orNiGZ34ktsSt2BLsVNNDqSewe6ve2jcv1SmUHScSyz1Ka6JxOXmrbA/aqHmDNKQQPc6
         IfIotQdlx/4JMrcS2rGYwTWi6nt5nINJy6j/pJ23L1w+OYFzhUnZe7nZOFEMksXrkAVy
         DCpg==
X-Gm-Message-State: AFqh2kpTELrSJFcSdjbpvRD8BE1ncrSQZT0WDCFKHz3a5UBl85FH1+PJ
        37AzE1PgrgP8WE1YFEY+ycoAOgTjoLTlKqP2dSwyI2S4w6rEBN+6n368mkz9KeqsSB2EUdIf02q
        NOV28UmbVTYbz
X-Received: by 2002:adf:ed02:0:b0:2bc:841d:b831 with SMTP id a2-20020adfed02000000b002bc841db831mr6912560wro.55.1673510415270;
        Thu, 12 Jan 2023 00:00:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuoa4dXhmYE4b3KwciATEgeFMtHH9C0oC/fg2IU8EfNvBezXHmgYthq/F6bTZN3iYm6yCmxyQ==
X-Received: by 2002:adf:ed02:0:b0:2bc:841d:b831 with SMTP id a2-20020adfed02000000b002bc841db831mr6912539wro.55.1673510415022;
        Thu, 12 Jan 2023 00:00:15 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-128.web.vodafone.de. [109.43.177.128])
        by smtp.gmail.com with ESMTPSA id u14-20020adfdd4e000000b002366e3f1497sm15893339wrm.6.2023.01.12.00.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 00:00:14 -0800 (PST)
Message-ID: <b4469973-1e3d-7efd-f78a-8afc46f4e3bd@redhat.com>
Date:   Thu, 12 Jan 2023 09:00:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <999a31e0-56f4-6d14-f264-320f51f259af@redhat.com>
In-Reply-To: <999a31e0-56f4-6d14-f264-320f51f259af@redhat.com>
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

On 11/01/2023 11.09, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> commands.
> 
> s/commands/command/
> 
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervizor previously
> 
> s/hypervizor/hypervisor/
> 
>> moved the CPU.
>>
>> The same command allows to modifiy the CPU attributes modifiers
> 
> s/modifiy/modify/
> 
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
> 
> Hmm, who is supposed to call this QMP command in the future? Will there be a 
> new daemon monitoring the CPU changes in the host? Or will there be a 
> libvirt addition for this? ... Seems like I still miss the big picture here...

Or if this is just about to provide an API for future experiments, I'd 
rather suggest to introduce the new commands with a "x-" prefix to mark them 
as experimental (so we would also not need to go through the deprecation 
process in case they don't work out as expected in the future).

  Thomas

