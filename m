Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA46482CE
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLINd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLINd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8601C41E
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670592771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fN0W6rkQk+OsPoOfSXi6YU0PA5r8oMFk7Ig9SLybsGo=;
        b=UAgT5vwRZqixXSNqJFUCwy9oUox4tBhldAglCTjmYTnWO74RDAyLrkrrs2upqIZ2pRVzm4
        ANuB7O2Npu0SsnnE3Dn0o7vyfJE1NTaSAjinEF/1TOKIfKNB9fKZHZ86/3LMl74prbSwYD
        GyeTCyMNBlRREgWYtekk/F9iDtSuTJc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-e3JmPtZ6NhC8g5A-cqJW4Q-1; Fri, 09 Dec 2022 08:32:46 -0500
X-MC-Unique: e3JmPtZ6NhC8g5A-cqJW4Q-1
Received: by mail-wr1-f69.google.com with SMTP id c13-20020adfa70d000000b0024853fb8766so404947wrd.11
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 05:32:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fN0W6rkQk+OsPoOfSXi6YU0PA5r8oMFk7Ig9SLybsGo=;
        b=4w3RlaR9B/Ub0OV0xunrGuEMzgxe3tkzB4Jf4vvlDXjLqD7it9eS+jlHnPVPkQoN4c
         JnClmw9svtvGH/aBvRogQGqH/C3ok3mqXx8qDEHOqwn3qkYHaUyM2qj9Dgyf8IWUHRUN
         wBFzxzDSB/MbZ1Jr7QlwvQaxRJ6a05BSP48GuUhBrc14xHYK8HuYNBRybS3/mA2keXoK
         SHRH1CXBbSUr4ZooSN0GtH0XprbvJ1qH6K4vjg6hWSlxEz7CsnjNhTvUhT3Bz4GS3T6y
         glKWXUjUfksEFXk5oZGg2BOHczpXEBTQrVC5XHD70TDFpgnDrkZyKbLzutv5INpwYook
         27tA==
X-Gm-Message-State: ANoB5pm6qqIm5hYjIXx5m4B2vxyYpQ0qfDQTHDz9OFk9aBAtcqrcBsCi
        1aPfkAG8HoCn3lbYb2MIDVvDr3HVKT92UbY0XORMNO9B2oknjckGOW8KWtujCcIxacu2OR/busJ
        G6n3V4qFDB89h
X-Received: by 2002:a05:600c:1c25:b0:3d0:a768:a702 with SMTP id j37-20020a05600c1c2500b003d0a768a702mr4808204wms.19.1670592765415;
        Fri, 09 Dec 2022 05:32:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6MBoJ9GIUijgF53IGcMK4J8y9Qyu2MkufGppWNNfHqz6d/PEbSQPJQWVByvfpt5rFTA4kzaQ==
X-Received: by 2002:a05:600c:1c25:b0:3d0:a768:a702 with SMTP id j37-20020a05600c1c2500b003d0a768a702mr4808188wms.19.1670592765228;
        Fri, 09 Dec 2022 05:32:45 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id k7-20020a1ca107000000b003b95ed78275sm1743667wme.20.2022.12.09.05.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 05:32:44 -0800 (PST)
Message-ID: <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
Date:   Fri, 9 Dec 2022 14:32:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/2022 10.44, Pierre Morel wrote:
> Hi,
> 
> Implementation discussions
> ==========================
> 
> CPU models
> ----------
> 
> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
> for old QEMU we could not activate it as usual from KVM but needed
> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> Checking and enabling this capability enables
> S390_FEAT_CONFIGURATION_TOPOLOGY.
> 
> Migration
> ---------
> 
> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
> host the STFL(11) is provided to the guest.
> Since the feature is already in the CPU model of older QEMU,
> a migration from a new QEMU enabling the topology to an old QEMU
> will keep STFL(11) enabled making the guest get an exception for
> illegal operation as soon as it uses the PTF instruction.

I now thought that it is not possible to enable "ctop" on older QEMUs since 
the don't enable the KVM capability? ... or is it still somehow possible? 
What did I miss?

  Thomas


> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
> allows to forbid the migration in such a case.
> 
> Note that the VMState will be used to hold information on the
> topology once we implement topology change for a running guest.

