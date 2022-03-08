Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F01F4D19BE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347263AbiCHN4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 08:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347266AbiCHN4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 08:56:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 946AD49F8B
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 05:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646747745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IBDuOS2fA0Ut8e4IiZznBpFVrC7yMpgLFek2NZWFfs=;
        b=hMHgoEe9VGpq6KOvlFzSdbBGH35CULcMS01ALzi9CPqi8DaAMAj2LgZAiuEkXtrNLekhrM
        WXQFEQJtR3mL0GxWIntoAe+wtpXjPTP4317hzbwJW0vqg/byNnFwasB0Tq4RUR3Bom62DT
        jhDoh6MODNJiAgOAyucz6IEhl4n7AZ0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-Q2ubXTeaNrCw0xROEArxXg-1; Tue, 08 Mar 2022 08:55:42 -0500
X-MC-Unique: Q2ubXTeaNrCw0xROEArxXg-1
Received: by mail-ej1-f69.google.com with SMTP id hr26-20020a1709073f9a00b006d6d1ee8cf8so8640123ejc.19
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 05:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1IBDuOS2fA0Ut8e4IiZznBpFVrC7yMpgLFek2NZWFfs=;
        b=fIk+oR/HXOolM9F1tgTXTGM4kJGzRCz98sYbZ7Pr7b7MSxabzvZ10+J+BYXqJBiPRd
         UeUo0eSXqyXKKnmWzBYAwB6dZ9li8uV9t6hNYPwxpTD8Mbc7H/yRSBL7N0SaFKVkr0JU
         kiJrKHU1oI1qUicOcT8kFXv6SqjXrb9j5Xc0ZPCqekkut5UDXOewCMx44FEp5jIGYMQM
         viT2G2cdEY+8jbbTIE+5J89oSMa/i6/R2+eCrsLzMy4nTXKco2KMN++98KzS1Wu/Ofd4
         MM8699++rp/XyQ63Z72xcDL8ACoWgHHxdjtLNkC8DpwBrMw5Mq/VEf671Qo2txM5jmIx
         X+Fg==
X-Gm-Message-State: AOAM533PGT6mJVLNIb+JoX5Uj/8xg1kYRB1DL3GWneV1fefP2MzeX1vh
        FdArhhVaX8Epkd6BtYT/EnyEFbnTIbywyS1ycP8kdNc24ELkq/+Slsq+d/mc0nKGyphrMumKVdZ
        uqEfQb3sblZ5d
X-Received: by 2002:a17:907:72c5:b0:6da:e99e:226c with SMTP id du5-20020a17090772c500b006dae99e226cmr13706573ejc.515.1646747741398;
        Tue, 08 Mar 2022 05:55:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6WmZv3/KHM1kx7+bdzcMlRqoo8+XkXcFt2ZUztmnvExDivbuO3SMLPcZhEKvKFLdILNTj/A==
X-Received: by 2002:a17:907:72c5:b0:6da:e99e:226c with SMTP id du5-20020a17090772c500b006dae99e226cmr13706551ejc.515.1646747741189;
        Tue, 08 Mar 2022 05:55:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n9-20020a05640205c900b00415fbbdabbbsm6684307edx.9.2022.03.08.05.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:55:40 -0800 (PST)
Message-ID: <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
Date:   Tue, 8 Mar 2022 14:55:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
 <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 14:47, Michal Hocko wrote:
> Seems useful
> Acked-by: Michal Hocko<mhocko@suse.com>
> 
> Is there any reason you haven't used __alloc_size(1, 2) annotation?

It's enough to have them in the header:

>> +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
>> +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);

Thanks for the quick review!

Paolo

