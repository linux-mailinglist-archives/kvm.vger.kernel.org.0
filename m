Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBEC76FDFC
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjHDKA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 06:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjHDKAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 06:00:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B700849FF
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 02:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691143167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwNEzLWGsJF00DekH3AwAc6pC/o4FSo3yR01IWQfvHs=;
        b=YcUxEdS2XTxMRYvKW9XEas9IDGLXTatAaApTUsV/zqeUDaCX0Un7X3EHc0iiqRzqVHMjRi
        FqFXO8tSnd23neJNHXldPr+0S9ZVkNR/TNSmEVgToj9mkvo3sJVCL9VAj5Zp/6erUfwwd+
        tZ3dcinJ7vt+6IlDHLv7Op26HvBBGkc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-b7kvSG1aOHybAFzpD47qZA-1; Fri, 04 Aug 2023 05:59:25 -0400
X-MC-Unique: b7kvSG1aOHybAFzpD47qZA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3175bf07953so1186023f8f.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 02:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691143164; x=1691747964;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZwNEzLWGsJF00DekH3AwAc6pC/o4FSo3yR01IWQfvHs=;
        b=Qda1CGaaUAVRmSQqdfCGFvXCrjCRjtr/GdihQCnaGpJfvrS5SNmrKT31A90Byi3goG
         Q921JMG0MoRCRd2Hdmvbc1sdSCZDeGDaSSE/8ttlYUwqHAuZeN9LyEQ9dh1I5xQjh7QE
         muvoHNw4ERs0n/7KYSblTifjVNDl3YV+zWZ81xOUx3th8OfXSalKNbcfbGnwcB/jOiSy
         I9VfaFDcwapI1/obr4ej/Meqm07L+dHVd3Q50K1hohMMK3raKB9EuCgWzRbdrsJSVdiW
         WF8khL02TpVUR8Tj1kEcw/wJ2oeFdVDZQHnKqK5Sym290LpydWAgqKTB6dXtfll3V2dH
         V9lw==
X-Gm-Message-State: AOJu0Yw85HXDrrX4ybMuTglJWt1TElJ1hzZK3ybklZ7DESFfNTz0qI+Y
        UkqkNkYvjIYc9SoHzCDXnHWscknnuAS7tWannqwFqG9EcuYpPqzmwMWJ6GYOUBjdqT3FdgoZrgz
        Vofo29C8xOWYh
X-Received: by 2002:a5d:680e:0:b0:317:4ef8:1659 with SMTP id w14-20020a5d680e000000b003174ef81659mr812282wru.28.1691143164584;
        Fri, 04 Aug 2023 02:59:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEue9tewoodArBSqmAheDz6m/xWkDWULrRXyLWMYNeF828bYBIF2Vl1Pj7mVe+YTuhO+DS5ow==
X-Received: by 2002:a5d:680e:0:b0:317:4ef8:1659 with SMTP id w14-20020a5d680e000000b003174ef81659mr812271wru.28.1691143164268;
        Fri, 04 Aug 2023 02:59:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:5900:10b9:2373:11c6:216c? (p200300cbc724590010b9237311c6216c.dip0.t-ipconnect.de. [2003:cb:c724:5900:10b9:2373:11c6:216c])
        by smtp.gmail.com with ESMTPSA id h3-20020a5d5483000000b0030ae53550f5sm2092325wrv.51.2023.08.04.02.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 02:59:23 -0700 (PDT)
Message-ID: <2e2c5026-4aff-0dc6-9f92-70cb8365c106@redhat.com>
Date:   Fri, 4 Aug 2023 11:59:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/2] KVM: s390: add tracepoint in gmap notifier
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230510121822.546629-1-nrb@linux.ibm.com>
 <20230510121822.546629-3-nrb@linux.ibm.com>
 <6f8951e2-9ea6-5bad-9c2c-b27d70d57ffe@redhat.com>
 <169114236545.36389.12085901437050856794@t14-nrb>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <169114236545.36389.12085901437050856794@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>>    
>>>    #endif /* _TRACE_KVMS390_H */
>>>    
>>
>> In the context of vsie, I'd have thought you'd be tracing
>> kvm_s390_vsie_gmap_notifier() instead.
> 
> Right, I can change that if you / others have a preference for that.
> 

No strong opinion, just a thought.


-- 
Cheers,

David / dhildenb

