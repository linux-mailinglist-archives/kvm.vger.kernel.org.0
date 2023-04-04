Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F7B6D59B8
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjDDHdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjDDHdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:33:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275BE2726
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680593547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KQO5h3+WmOjHOdR/RQTb8OxWC50lKlPJekouNAzkZ20=;
        b=BQn/ZtVwPmUS8d68NdUb/cMu3wcSq+Kb6McRcS9ophvHgOoqpYrr6I7krtDVV74Wco6mGf
        JraKjLifUC6uEp0700asJkuvvGzA07ggWTyVgh89bp5j0AAN1Z7gnaxUZLnI2mKiOI2eA/
        h8kzs9sB+F8WNm1ELQalvSqRb/3jTxs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-eUJNTPZBOBWkNa-QS5VLFA-1; Tue, 04 Apr 2023 03:32:26 -0400
X-MC-Unique: eUJNTPZBOBWkNa-QS5VLFA-1
Received: by mail-qk1-f198.google.com with SMTP id d187-20020a3768c4000000b00746864b272cso14324300qkc.15
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KQO5h3+WmOjHOdR/RQTb8OxWC50lKlPJekouNAzkZ20=;
        b=vMDPI5S5WtYMFXP5gmSEspQxOYHp+M8hUddQ2IgU89lhGW3Os4rK1+e2/elwYGO8Ty
         CddoHST3fbMbWh6aBupsiraju627/O2ZRawNCWEqK7AKFlxUFCV7Ffcj87XkHv6d3hSU
         LJFgrrjHjvP//PQChpbSNJOK/Q8UZDXdahQNCnxsgwNEvXYaggerX/Y+2+MAJ+LYhFJ4
         dPcR950wsU+jNhchKh9+OgOAqc9sSGgqEf9uV8EEKYezmz8cFPSNg+rFc0C22gcFRkBF
         a+jK7P9Eek/CjP21VcVJSCr2HyQ2CZCY3NLt1mh1QTqNkipr4A1G4YGgDlZrjY2Y8CXP
         7nqg==
X-Gm-Message-State: AAQBX9fbjHeSkm3r5oIc1C5wu3nITJ14mHPBPVZoSzteBQgU2/5OD1KJ
        ipSUUvfvEVPJlzGbN7PeJ1laMAAKB73buOgXAA4cdcGi54ccLJHB701s9DNDQhmeHrezjCfvdnB
        buP0XgUWUcIF8
X-Received: by 2002:a05:622a:182:b0:3e4:eb53:b02b with SMTP id s2-20020a05622a018200b003e4eb53b02bmr1896141qtw.9.1680593545530;
        Tue, 04 Apr 2023 00:32:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZDOir1Y35E8xclX+Hnf46F/a/hbN46cWKyCZKECKxBaGphhxYeckRUlR/kD3u2/NfBjSZoGg==
X-Received: by 2002:a05:622a:182:b0:3e4:eb53:b02b with SMTP id s2-20020a05622a018200b003e4eb53b02bmr1896125qtw.9.1680593545342;
        Tue, 04 Apr 2023 00:32:25 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id dt8-20020a05620a478800b00748461ac012sm3372415qkb.63.2023.04.04.00.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:32:24 -0700 (PDT)
Message-ID: <4ba1d826-b291-2120-f34f-e1e674608614@redhat.com>
Date:   Tue, 4 Apr 2023 09:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 10/13] powerpc: Add support for more
 interrupts including HV interrupts
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-11-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-11-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> Interrupt vectors were not being populated for all architected
> interrupt types, which could lead to crashes rather than a message for
> unhandled interrupts.
> 
> 0x20 sized vectors require some reworking of the code to fit. This
> also adds support for HV / HSRR type interrupts which will be used in
> a later change.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/cstart64.S | 79 ++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 65 insertions(+), 14 deletions(-)

Acked-by: Thomas Huth <thuth@redhat.com>

