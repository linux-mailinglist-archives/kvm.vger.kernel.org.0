Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905095166B5
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 19:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353325AbiEARkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349508AbiEARkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 13:40:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80F0012095
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 10:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651426629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKYyDzEa1Qm6/nRF+fARRdz7xpLxGmHcyaMuMYxwK7c=;
        b=OWGo29ddj96iakkTHCXTWP8LGBT4sUj/9xkNMIKMSxV+rJBrjLWWxrPw556vkX9X7PKqhn
        PNtyS1jm0fLK4MC4wjEYQpgQLuJeIidZoBc5jVO7hJGA5mpvW48mmCGY2g7knm1BnSsBA0
        BNdCumSzr86yAs+pLp8O8pviXttj7Fw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-3gA81NbUPpCb-WhEXUoFMw-1; Sun, 01 May 2022 13:37:06 -0400
X-MC-Unique: 3gA81NbUPpCb-WhEXUoFMw-1
Received: by mail-ej1-f72.google.com with SMTP id nd34-20020a17090762a200b006e0ef16745cso6023598ejc.20
        for <kvm@vger.kernel.org>; Sun, 01 May 2022 10:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CKYyDzEa1Qm6/nRF+fARRdz7xpLxGmHcyaMuMYxwK7c=;
        b=sIHGblrhl+AoWGe9LqOkMmDMYh0kncdb8n9W/khRaJsqtHBFF1qdNVS92heB5s77di
         R0sonag/rJkeFDkHHY5ivZWDl7V2j1dRvaHK9WOv6ehavluzIRV8boAs3uDyFuN09smQ
         WBXyEnRB/2PfYsIFaRa9Qrq6/4c2LyW7+/fGUj6s9/abVhhibWWs1FHlDHOp1pKrzJkK
         n3hyiQobJYnfJE4HydNYhIYf2OcrE0G+Lfmb7uhZ/DFJ2MCZoEZ+hMj7x+ODK7XSWNId
         Xki6O2DW2roAQDAbij/FLza1Q1zka6hXJQ6C2h6ZsbYdBDi0RUMU2NeFNLuER4P60Iln
         Qo0Q==
X-Gm-Message-State: AOAM531pxHu2c/Mlf3rDQbk08v+uq9Qpjl2fp9yRrS7gJCqDsSaT7mpA
        iGeaNwvzO2SyRb/NG928sV1hk33ihIFaHombugbOBBRlZdllE5+wlxM7GnEeHHD8EUI3mzD5zTT
        Xq6b2ALrf753u
X-Received: by 2002:a50:d707:0:b0:425:e37d:4ef3 with SMTP id t7-20020a50d707000000b00425e37d4ef3mr9847695edi.167.1651426624870;
        Sun, 01 May 2022 10:37:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2LQ9ZwdZjXacAt/NZtWsVCKIKSqXIdjiolSzR/GuJxk6zOwgAVK5QGcZPqDy4EWCga94JoQ==
X-Received: by 2002:a50:d707:0:b0:425:e37d:4ef3 with SMTP id t7-20020a50d707000000b00425e37d4ef3mr9847680edi.167.1651426624588;
        Sun, 01 May 2022 10:37:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bf16-20020a0564021a5000b0042617ba63aesm5683779edb.56.2022.05.01.10.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 10:37:03 -0700 (PDT)
Message-ID: <54adc4a3-6b66-8ddf-db92-9630089da2dd@redhat.com>
Date:   Sun, 1 May 2022 19:37:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86: work around QEMU issue with synthetic CPUID
 leaves
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220429192553.932611-1-pbonzini@redhat.com>
 <1dcfb3d243916a3957d5368c2298e3f8fd79a9f2.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1dcfb3d243916a3957d5368c2298e3f8fd79a9f2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/1/22 13:16, Maxim Levitsky wrote:
>> +		 * However, only do it if the host has CPUID leaf 0x8000001d.
>> +		 * QEMU thinks that it can query the host blindly for that
>> +		 * CPUID leaf if KVM reports that it supports 0x8000001d or
>> +		 * above.  The processor merrily returns values from the
>> +		 * highest Intel leaf which QEMU tries to use as the guest's
>> +		 * 0x8000001d.  Even worse, this can result in an infinite
>> +		 * loop if said highest leaf has no subleaves indexed by ECX.
>
> Very small nitpick: It might be useful to add a note that qemu does this only for the
> leaf 0x8000001d.

Yes, it's there: "QEMU thinks that it can query the host blindly for 
that CPUID leaf", "that" is 0x8000001d in the previous sentence.

Paolo

