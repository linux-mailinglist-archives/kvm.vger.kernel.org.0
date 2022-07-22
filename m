Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B0F57DB0D
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiGVHR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiGVHRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00DDCD6B
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658474239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3mN1YY4ZaFhdmgTg9aJTQx2Ag2kI0nqfLpirIW7BV8=;
        b=UaMyp9NE5oawA0AoUwlDdA7fz7uVsCiWaZiWIjeMGtDnxnCdK5FWv6YQ1GSmZOXNY79pit
        35nAhg6NCLfH4Od2QlFAXA9wpYKMnvNVePOVnIbHElgl2oUT5L/zVuaGIFlFCVNzyUoQKP
        oFA4wLfYwqXg+B/SfJgTCzWlJepEIIQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-JtdSRZDpNISMdtejB5U7ww-1; Fri, 22 Jul 2022 03:17:16 -0400
X-MC-Unique: JtdSRZDpNISMdtejB5U7ww-1
Received: by mail-wr1-f71.google.com with SMTP id k26-20020adfb35a000000b0021d6c3b9363so700855wrd.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y3mN1YY4ZaFhdmgTg9aJTQx2Ag2kI0nqfLpirIW7BV8=;
        b=8R1zdMxjk8oSzPutmq+4WxHJwCbsyUrtOZ5jQMM81ClA6JvsdPgFAjs52izzqTGK8w
         yrjIOPuYZvM9a+biV5GwwfP6KPDJV9wUUClj7h8PzqGKX0RIKthMiEL5r+AIWQdizcU5
         0eUirQhFavBC7SpmTJ+itLVXolgFNOFoTYts1v5BlkmhUPcmlrHIPfd+HgpD7bK4GHBK
         IOJQ/aG1B8u+Srpdb8SajK9gGYtvAPGUBo8ZAvIU+5Y9YS6oA5DB63V8CitNuEKLkMza
         1e/FhWWDnXri9oYkpa4TXCJXFxgBtQv51vZd9stH6K1USMN5gmYhUQ4tubmdyRyWHAT6
         J52w==
X-Gm-Message-State: AJIora8Ct9iRAGZ/LfRPRZyt+QxrK4gmDK40FGq36FATBA8ZdieL/8hH
        KCBvFnM7z6oy0Jfbb088UUmJdXYfu0hE+PMBV5xi32hBUWGgwBpdrZe3MQchSRxPxOuKHc4L71f
        JXZ5dotRgaAvz
X-Received: by 2002:a1c:4c14:0:b0:3a3:ad5:62e7 with SMTP id z20-20020a1c4c14000000b003a30ad562e7mr1448991wmf.114.1658474235030;
        Fri, 22 Jul 2022 00:17:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tPTyl/0KPtnxpM59gT1P2wf7MdYT49hZ3DI5epWHqeeMrpGzMjlP2WihM+i69WoMbaVGkyig==
X-Received: by 2002:a1c:4c14:0:b0:3a3:ad5:62e7 with SMTP id z20-20020a1c4c14000000b003a30ad562e7mr1448946wmf.114.1658474234518;
        Fri, 22 Jul 2022 00:17:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o5-20020a05600c4fc500b003a03185231bsm4350514wmq.31.2022.07.22.00.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 00:17:13 -0700 (PDT)
Message-ID: <4caa1fb2-febd-22e5-54b7-dababe63ae15@redhat.com>
Date:   Fri, 22 Jul 2022 09:17:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL 00/42] KVM: s390: PCI, CPU topology, PV features
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 18:12, Claudio Imbrenda wrote:
> Hi Paolo,
> 
> today you are getting the pull request from me :)

I'll trust you. :)

> this request has:
> 
> * First part of deferred teardown (Claudio)
> * CPU Topology (Pierre)
> * interpretive execution for PCI instructions (Matthew)
> * PV attestation (Steffen)
> * Minor fixes
> 
> 
> Please pull
> 
> 
> The following changes since commit 4b88b1a518b337de1252b8180519ca4c00015c9e:
> 
>    KVM: selftests: Enhance handling WRMSR ICR register in x2APIC mode (2022-06-24 04:52:04 -0400)
> 
> are available in the Git repository at:
> 
>    ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-5.20-1

Pulled, but you need to setup separate remote.*.url and remote.*.pushurl 
configuration for git-request-pull to work.

Thanks,

Paolo

