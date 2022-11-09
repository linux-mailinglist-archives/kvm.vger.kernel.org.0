Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF68C623180
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 18:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKIR3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 12:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKIR3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 12:29:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA583B9
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 09:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668014924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XW3hyf1ELcPigroVZADXI+g6jgObLwrHXveAl76MUtQ=;
        b=RwV5vtHtxql2pBkQAo6ZQHXK4vXTis+4hE5KDnpH7EbHKq7aWr3iT+hX9Z1UgsO9D/YLLP
        QjQeP4TXmzGbTW/Kwbo8nUYCcuziXv3K262HJQ/0bMVxwXG/KWWrXsqQtpwUWP7mWLVxIB
        ylalisDRXvduUyn3emfX8EcmXc5w7Bc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-S0nXNPjEPCir3a5N9QSmXA-1; Wed, 09 Nov 2022 12:28:22 -0500
X-MC-Unique: S0nXNPjEPCir3a5N9QSmXA-1
Received: by mail-wr1-f72.google.com with SMTP id e21-20020adfa455000000b002365c221b59so5250463wra.22
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 09:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XW3hyf1ELcPigroVZADXI+g6jgObLwrHXveAl76MUtQ=;
        b=bN33CXtwFP8Zd8QanPFBsotg8dxI5EHWUh2/I2XlM+B5Y07aA9avOJ2wzHHezxBzQp
         PaBTgQXqil+6CfhTn0H1YjIqUuOElThQyqcwPUT6Sk79+5/plF0EVSzAFU2fflWYM0Qu
         36xvtrzpqPtcDK4l0k8F9CI6E1FG9myaWW6DA+WUars1YGenmFXy8brCyyLxvYw0qFmq
         m/yioDYjBSbDmdg+KFLkIGSwcM+0n/zuF1PojzgaPeGDmIchk7IvyBFEop49xDmC7/C6
         0NXDmx8YhexSF+MJt+bxlxUkHe9l9FMp9l02P9E0gxvER6PHrYCgLd03i0WIrZQv/sJe
         m82g==
X-Gm-Message-State: ACrzQf1+oQS8g0MdWgPYRanLbr00yaabp9hlnEhE+EVrPTwnKvBIGZYH
        2Ef5bft7u8GACKLIIhHU8FGIZYRWeP66zruC75PNiS8o66q6HkK+eRI+TrXZqdWq+mUwgIr6ZtQ
        he5oQD3D+SGfH
X-Received: by 2002:a5d:6589:0:b0:236:52af:3b70 with SMTP id q9-20020a5d6589000000b0023652af3b70mr37673590wru.349.1668014901230;
        Wed, 09 Nov 2022 09:28:21 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7X19OUH83gjS/DNM/0Z+6JG2EeYstuDpWUj7N0q8JkMcyNof68t4OpVEOqfNvS1GhfB2RYFw==
X-Received: by 2002:a5d:6589:0:b0:236:52af:3b70 with SMTP id q9-20020a5d6589000000b0023652af3b70mr37673577wru.349.1668014901019;
        Wed, 09 Nov 2022 09:28:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t12-20020a5d6a4c000000b00228692033dcsm13744245wrw.91.2022.11.09.09.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 09:28:20 -0800 (PST)
Message-ID: <e65197ac-9f42-77d4-76dc-0d1b1c5b1a9e@redhat.com>
Date:   Wed, 9 Nov 2022 18:28:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [GIT PULL 0/2] s390 fixes for 6.1-rc5
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20221107094329.81054-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221107094329.81054-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 10:43, Janosch Frank wrote:
>    https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-6.1-1

Pulled, thanks.

Paolo

