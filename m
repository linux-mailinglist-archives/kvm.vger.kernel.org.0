Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8357D65777C
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 15:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiL1OHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 09:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiL1OHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 09:07:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF70E63BA
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672236380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqA4P/8KFf5DgTfeuilT+Z8Vn+oQqfQojNVKUAZoO1Q=;
        b=MpvUFsZG0taO6VTaTGWvjtMhsCDZj1QtFWaYCpnqxHViVkai/j7dCURRI5NFeUz+oDbcDG
        NPDQOwAA+JrdnlVi914LzJCGffxsNzV62jZ7fw+a74FcZgiJIFVAWYVFo/dLtxBF5+laAM
        K3amhTJfWXHJBsTFLPPkswpqK7L2S64=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-NwpSHPyDPl2xThfhwbO-tA-1; Wed, 28 Dec 2022 09:06:19 -0500
X-MC-Unique: NwpSHPyDPl2xThfhwbO-tA-1
Received: by mail-wm1-f72.google.com with SMTP id c66-20020a1c3545000000b003d355c13229so11174394wma.0
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:06:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uqA4P/8KFf5DgTfeuilT+Z8Vn+oQqfQojNVKUAZoO1Q=;
        b=aS3VBfDqYbkkIzGtmYrrpe7lnh/3jluJMjKadBEdg6HmVpse/jsjvS/V4KLv+8hdcV
         Pfo63Sp+e9SFh8oAdsLzR6iMjfhvXSq59OJqPWVFQQjGrTfHHytN+zxMkWcvEN5S8O85
         GmA/vLDEpqGlRtpdYIY7n4WbfrDvHfuJkUDqRA0d57bbudXRLwpagHUzvzB+m8+ax03g
         eH2E1QAmPFgsekfzYS869c7jL5G5nAPncsx/2D/1Q2MPENC81vXfrr5tHdzshyP+wTGZ
         nHNNG9sLESwpMGMGmJy/2kX+EspqarFXVZg+zwROSP4bGb+N/ufEMM0939AhtWhcNk25
         AByA==
X-Gm-Message-State: AFqh2ko4sPcc5Hu02SiQxWEi6qjycvkhHu8LIQl4O8FPf2Qql+Fe6JbT
        ywS9yPrBwNijdkpNqlakZYLEBbN9WZuLQ2/WXlCOSyLg3QvfqWDMUyCUFp/dyIwO+I9lQlUckwy
        EIkZxvgbreS09
X-Received: by 2002:a05:600c:3d0e:b0:3d1:ee97:980 with SMTP id bh14-20020a05600c3d0e00b003d1ee970980mr23093021wmb.7.1672236378160;
        Wed, 28 Dec 2022 06:06:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvbwJhjS7bN/qNbKEhFeSVQo1kQpJ3mgf2aLhT5M/tZcORR8X6qm/Yz/JwELjhpzo6VBhOB8w==
X-Received: by 2002:a05:600c:3d0e:b0:3d1:ee97:980 with SMTP id bh14-20020a05600c3d0e00b003d1ee970980mr23092994wmb.7.1672236377895;
        Wed, 28 Dec 2022 06:06:17 -0800 (PST)
Received: from ?IPV6:2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a? (p200300d82f161800a9b41776c5d91d9a.dip0.t-ipconnect.de. [2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a])
        by smtp.gmail.com with ESMTPSA id m22-20020a05600c4f5600b003d995a704fdsm2289461wmq.33.2022.12.28.06.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 06:06:17 -0800 (PST)
Message-ID: <6a533ba5-5613-1f96-866a-974530fb10bc@redhat.com>
Date:   Wed, 28 Dec 2022 15:06:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 10/12] virtio-mem: Fix typo in
 virito_mem_intersect_memory_section() function name
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org, QEMU Trivial <qemu-trivial@nongnu.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211027124531.57561-11-david@redhat.com>
 <8a2fb7aa-316d-b6bc-1e8d-da5678008825@linaro.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <8a2fb7aa-316d-b6bc-1e8d-da5678008825@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.12.22 15:05, Philippe Mathieu-Daudé wrote:
> On 27/10/21 14:45, David Hildenbrand wrote:
>> It's "virtio", not "virito".
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    hw/virtio/virtio-mem.c | 12 ++++++------
>>    1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

I already queued your patch :)

https://github.com/davidhildenbrand/qemu.git mem-next

-- 
Thanks,

David / dhildenb

