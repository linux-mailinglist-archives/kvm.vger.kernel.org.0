Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B869953CA7D
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244556AbiFCNMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241257AbiFCNMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75FAA114C
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 06:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654261940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYTWIi+8KmjeYhwLGrrboQLIMlPmaoTJxSNZnE+MXVw=;
        b=f5fGu7jUSKP94aBitMMgmnnofzNoMU8oA9l18qp0Kkcl5mW0iWDsjAgW7bJZSs2d51BtBP
        8Nd+cEwuaIa7arzx81ZsnDsC7eBJCqBpzkBgt6fVq2uOt5oSVSm3YYPJZqdEK6/8pY1DHP
        cLr0SmxIFCMg3CzA4PzgTKAgyE7xxws=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-M2PUQvg3PHC97osDhzqdmQ-1; Fri, 03 Jun 2022 09:12:18 -0400
X-MC-Unique: M2PUQvg3PHC97osDhzqdmQ-1
Received: by mail-wm1-f72.google.com with SMTP id ay1-20020a05600c1e0100b0039c3a3fc6a4so1435113wmb.4
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 06:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cYTWIi+8KmjeYhwLGrrboQLIMlPmaoTJxSNZnE+MXVw=;
        b=S4dZCaO1Dw0YLF4YvMrG/4HPUPZMZ4HM8v5AvR9VYWoEjeqSYOcrHGJbHj//hUsYpj
         GExjgegYLk+P+Wd9LikNm/mxvJ2LFywC6I6i5QOvugr/qCEG/V2jl4/P3ThG89p9y1aP
         w9SaEMhHK6MxEc+m/Q2nY7/8cXye6Jdxd94f0O7A9RT+blKIuQhWZYTw0kOIhIXsWYRf
         6ayhxP/7Luw8uw8G+jhSfvrlfF99/rRcXwFZbn4xG+feNxvBJUhZDfEG5zzyO95jskKm
         ac7e230OymjeCb6roA9Jn5BUAtYtt7Mnl9GxzYaQsTL8JGkZZGAQN0/xSFaW2T4zLCa7
         K7eA==
X-Gm-Message-State: AOAM532Am0NcC5VfIhAHfMRYQomEF62U6Cyup32bV9cdo7+Mn4hi8GqP
        Uvye00qArS872wIuMa7VVZ7sDAjP+reuaVxZ54H9qZLxwT++jLt9WeaW1K95IsS8OevRYBKqAbq
        dOHaRhdhotYpv
X-Received: by 2002:adf:d1ed:0:b0:215:98d7:2a93 with SMTP id g13-20020adfd1ed000000b0021598d72a93mr664740wrd.637.1654261937521;
        Fri, 03 Jun 2022 06:12:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzoGP1a+XsbaBxE1w5dUaOc50qgNf/S3+ORFBzV4i47E756C+eTOmwhBga5OYpML34Jzs0bA==
X-Received: by 2002:adf:d1ed:0:b0:215:98d7:2a93 with SMTP id g13-20020adfd1ed000000b0021598d72a93mr664716wrd.637.1654261937242;
        Fri, 03 Jun 2022 06:12:17 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-176-98.web.vodafone.de. [109.43.176.98])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b0020e6c51f070sm7517188wrr.112.2022.06.03.06.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jun 2022 06:12:16 -0700 (PDT)
Message-ID: <9c16f1e4-dfaf-5a68-64d1-a7ceb5b9a254@redhat.com>
Date:   Fri, 3 Jun 2022 15:12:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Introduce symbol for lowcore
 and use it
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220520140546.311193-1-scgl@linux.ibm.com>
 <20220520140546.311193-2-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220520140546.311193-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/2022 16.05, Janis Schoetterl-Glausch wrote:
> This gets rid of bunch of pointers pointing to the lowcore used in
> various places and replaces it with a unified way of addressing the
> lowcore.
> The new symbol is not a pointer. While this will lead to worse code
> generation (cannot use register 0 for addressing), that should not
> matter too much for kvm unit tests.
> The symbol also will be used to create pointers that the compiler cannot
> warn about as being outside the bounds of an array.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>

