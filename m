Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A727665739
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 10:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjAKJT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 04:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238624AbjAKJSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 04:18:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BAD2C3
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673428600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x8dNhrY97yX+x1fnhZAkDchwfhUj2Oj4Bemjjtr6Vi8=;
        b=OnOIegRnJF7YN6Ji0Hk4I+aEQWp3T19G+0fksBuzfAtMiGjfkIKPl/D2O299gPTP3hcRWh
        b2fgML2lS4JSA7PMsxNPGL1IjFf4M7DAcbZA7uSXMUfjjZ449Kr33ql/GG2lI8AkJbAviI
        Ex3rmB+mvm3eFsaCeBiYYs5oJMnoNYg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-xnWU-fwuOyifO53ClpRP6A-1; Wed, 11 Jan 2023 04:16:38 -0500
X-MC-Unique: xnWU-fwuOyifO53ClpRP6A-1
Received: by mail-qt1-f198.google.com with SMTP id ez10-20020a05622a4c8a00b003ab6c16856fso6936250qtb.17
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8dNhrY97yX+x1fnhZAkDchwfhUj2Oj4Bemjjtr6Vi8=;
        b=ziK0+ZWFdAUyafWEH/lUbaIdJyFzrcaOOJFZa2pZllJJK2P6VSPi+2ELZIDDZB472h
         RbW4l+4zOoPGXGy/Ta8q6zMLKxRQYz2f7mIMms85GhX97MOYcf7K3A4Wc9ySSnQ50w8F
         zZJkiRNMmZEy+ASuyYmgUkfLYlsdkywAODqNUUColEyQTit4BnyZH9jnc7d1+jSiHwVM
         yY/UPtg23+FjCkf8qe0NS1hOHiRbnRp7uM31//nH8Gj98Oop3cZ3iqhut6/k2b8AStY0
         p2yaB/OCqmLTArxiOR+52a97XcLkDxUWVZkzFoVjvcptaO4VANNa5golpzTr0I0G2UQA
         VWpg==
X-Gm-Message-State: AFqh2kqrOAz8ntmFm7wzZUsuRyTHqpTK66ZKCn0gepA1Itq6ctrrTg2U
        lZ8qFi7OmXe/wb59FmqFQdWYXDSDOiU8sSiFOcvgk0Abjav2dQHfUSx0uSSssOIP23qw82mEX5a
        d/6FTDID4MI1S
X-Received: by 2002:ac8:5297:0:b0:3a6:9cfa:d6c with SMTP id s23-20020ac85297000000b003a69cfa0d6cmr9009457qtn.39.1673428598388;
        Wed, 11 Jan 2023 01:16:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv5fnEsMJF1NKHSnO+BBKktJJGt7xKEAuvJMY+2Do2GVgP4tAOoueOR2lkjpyMU3afKhso4xw==
X-Received: by 2002:ac8:5297:0:b0:3a6:9cfa:d6c with SMTP id s23-20020ac85297000000b003a69cfa0d6cmr9009435qtn.39.1673428598160;
        Wed, 11 Jan 2023 01:16:38 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-91.web.vodafone.de. [109.43.176.91])
        by smtp.gmail.com with ESMTPSA id c8-20020ac80548000000b003972790deb9sm7261933qth.84.2023.01.11.01.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:16:37 -0800 (PST)
Message-ID: <95388069-d23c-cb21-4f86-403b371da497@redhat.com>
Date:   Wed, 11 Jan 2023 10:16:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-4-pmorel@linux.ibm.com>
 <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
In-Reply-To: <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/2023 15.29, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
...
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    union {
>> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>> +        SysIB_151x sysib;
>> +    } buffer QEMU_ALIGNED(8) = {};
>> +    int len;
>> +
>> +    if (!s390_has_topology() || sel2 < 2 || sel2 > 
>> SCLP_READ_SCP_INFO_MNEST) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    len = setup_stsi(cpu, &buffer.sysib, sel2);
>> +
>> +    if (len > 4096) {
> 
> Maybe use TARGET_PAGE_SIZE instead of 4096 ?
> 
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    buffer.sysib.length = cpu_to_be16(len);
>> +    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
> 
> Is this supposed to work with protected guests, too? If so, I think you 
> likely need to use s390_cpu_pv_mem_write() for protected guests?

I now saw in a later patch that the topology feature gets disabled for 
protected guests - so never mind, please ignore my question here.

  Thomas

