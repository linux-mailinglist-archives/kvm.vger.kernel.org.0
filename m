Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24776658C1
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbjAKKOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 05:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239110AbjAKKMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 05:12:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132A120
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 02:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673431803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cgAIilrzXCmhW589ew6P3EryZK4P7T++tZG8TP6MYqg=;
        b=YSpviTYnxim3dRmNvNNwZu2E0cQJ35LQYr8ddBpzHVIx1nraKxKCDOQDAuWxPJtyQSEftv
        L9BjFMdzIK0a8YFTyzChMb6EFmH3n/386/2+SuYcrXkkWSH+bLWiBwtWupCSVwJ/5IM5U3
        I783eMVQjQECq3y9hlgYj89NX00Vzio=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-164-_OgSC22SMASjJ-OsJPEbwA-1; Wed, 11 Jan 2023 05:10:01 -0500
X-MC-Unique: _OgSC22SMASjJ-OsJPEbwA-1
Received: by mail-qk1-f197.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so10594629qkl.9
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 02:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cgAIilrzXCmhW589ew6P3EryZK4P7T++tZG8TP6MYqg=;
        b=6qUBPxYSNbUZ4zGS6VqTWd3qp0RpoQc25SzSRk0KFM7UV8i7jDtDYh9SuUMzPi/7wx
         XXbA93TEZWn8FmCJNr3xmoKo9ZrjxrMKZAlKtdE6Srx6vqa242itXYvcWJvRDGxGywFD
         8QKOjzeeABZYKgZNoIyKLZHI+3VpO2maZMeUtzqsmTf2KNVYxYhV/31CFPA7hrA58X35
         gLlQLHJ+ccb+lYVzWOhEnH44YYCWExbmzLqKUfzZHXd4sjbVlRsgpJIv/xYZQVeg2pn+
         4pg5eZFo/945FvLvXepNE8IufSJwIcg7HNUp835lXbGUKJS3Znuscb9dq6cmA20kY4wy
         Pv6A==
X-Gm-Message-State: AFqh2kp81BAOt5akBTC1LrYxZqJBc1C9EZ7qvClRPZJxbac0izSV6+ho
        3/5tvxGEqPEUoP1QjijBTHGCT2hWkHAkJ6rSD1Hz1zN1uLNFJwES5WtFrsJiCnFRfg4toe1V86w
        6OkjhcyuA4Iy1
X-Received: by 2002:ac8:5247:0:b0:3ad:197b:3cab with SMTP id y7-20020ac85247000000b003ad197b3cabmr14933097qtn.38.1673431801319;
        Wed, 11 Jan 2023 02:10:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsHLuaZ8+H3PYyz71FQ5kzq/WKSy/DxU8he4MkNygDXal96MqMw/K+YfgribeC4WfAiDRujMw==
X-Received: by 2002:ac8:5247:0:b0:3ad:197b:3cab with SMTP id y7-20020ac85247000000b003ad197b3cabmr14933084qtn.38.1673431801094;
        Wed, 11 Jan 2023 02:10:01 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-91.web.vodafone.de. [109.43.176.91])
        by smtp.gmail.com with ESMTPSA id y2-20020a05620a44c200b006f87d28ea3asm8696546qkp.54.2023.01.11.02.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 02:10:00 -0800 (PST)
Message-ID: <999a31e0-56f4-6d14-f264-320f51f259af@redhat.com>
Date:   Wed, 11 Jan 2023 11:09:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
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
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-9-pmorel@linux.ibm.com>
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

On 05/01/2023 15.53, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> commands.

s/commands/command/

> It allows to move the core inside the topology tree to optimise
> the cache usage in the case the host's hypervizor previously

s/hypervizor/hypervisor/

> moved the CPU.
> 
> The same command allows to modifiy the CPU attributes modifiers

s/modifiy/modify/

> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
> 
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.

Hmm, who is supposed to call this QMP command in the future? Will there be a 
new daemon monitoring the CPU changes in the host? Or will there be a 
libvirt addition for this? ... Seems like I still miss the big picture here...

  Thomas

