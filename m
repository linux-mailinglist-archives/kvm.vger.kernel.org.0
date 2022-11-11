Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C79625905
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 12:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiKKLCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 06:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiKKLCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 06:02:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6D91EEDD
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 03:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668164511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVa7NeFgku+0ebB26kWiVeKN6kB2ALJLwFhmbRN7ulE=;
        b=LRj7U28VOVf0kOAgpWWO6wu/5Rnq14qB+/aWNjRLrEWAfaiHv10mBv3NXFPEYK0wOJAyJ5
        jCRqtzuLCytN5/FXSL2YbqLhP/9FwK6TWBo0UY5adwUfSH+f7AwHoGqYHnbRlXort+SUnq
        iR/B7xFunL4Ca1mRyw0tNXWZDPnbW+0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-199-Z9ARyK_oMrmuQaD8CogaNA-1; Fri, 11 Nov 2022 06:01:50 -0500
X-MC-Unique: Z9ARyK_oMrmuQaD8CogaNA-1
Received: by mail-wm1-f69.google.com with SMTP id f1-20020a1cc901000000b003cf703a4f08so1669194wmb.2
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 03:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVa7NeFgku+0ebB26kWiVeKN6kB2ALJLwFhmbRN7ulE=;
        b=i4vBHWxmLQM4099UyqfSbU3sOQBbu2KqPaEX/C5wGWFHUK8uvqejPwrqeUJHnkeQBl
         ORP4yVsXs7/xD8ucxI3WWSDQj6zfH560c515koe0WTxEaOQ7Kj6X3tFWTEB3UFeTG2yD
         JogmWbnSioWUNfqUl8+dIfqjPaX90mojpKtNeJ8RT84vNHZBEdc+8p5fYNwO8L23U6Bl
         hQsiMiir6Pumx5KQyHoLWkYV+dsMexk2KDcd1csINj7Jq7oxcvChkK+empIegwESMmoU
         cVVOpXo3QNLtben+JZ30BR/iCgPGLGak/TNirwb33Lxun/VkKgsHL/6feDPQMW8X+HDw
         8l+w==
X-Gm-Message-State: ANoB5pkvfi32AsDXMqqrhNC7EivCz4AYoMur26Ly+dtLkT8VHyWqZ8Gl
        b5prc7DvTnW82Ynkx9DbfAKX5gJEcUzomM+Cq3qGnwHz1Mw1GACf/4PZc0yV2pcDyHPqWoDE5uh
        jlclYZ/rz3bwu
X-Received: by 2002:a05:600c:5006:b0:3c6:bd12:ac68 with SMTP id n6-20020a05600c500600b003c6bd12ac68mr859415wmr.123.1668164509005;
        Fri, 11 Nov 2022 03:01:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4NQo2dEiZmGVsfDblk1LpsfPPMKU8EzTWYL/jFDLoSR3bGNUCdbx3m3OPr53bQdXEBUWALnQ==
X-Received: by 2002:a05:600c:5006:b0:3c6:bd12:ac68 with SMTP id n6-20020a05600c500600b003c6bd12ac68mr859399wmr.123.1668164508791;
        Fri, 11 Nov 2022 03:01:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd10a33afsm1596666wmq.11.2022.11.11.03.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 03:01:48 -0800 (PST)
Message-ID: <379f2f0e-1ee3-79d8-5b42-418ed3549020@redhat.com>
Date:   Fri, 11 Nov 2022 12:01:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 3/3] kvm: Atomic memslot updates
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221110164807.1306076-1-eesposit@redhat.com>
 <20221110164807.1306076-4-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221110164807.1306076-4-eesposit@redhat.com>
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

On 11/10/22 17:48, Emanuele Giuseppe Esposito wrote:
> 
> +    /* Remove all memslots before adding the new ones. */
> +    QSIMPLEQ_FOREACH_SAFE(u1, &kml->transaction_del, next, u2) {
> +        kvm_set_phys_mem(kml, u1->section, false);
> +        memory_region_unref(u1->section->mr);
> +
> +        QSIMPLEQ_REMOVE(&kml->transaction_del, u1, KVMMemoryUpdate, next);
> +        memory_region_section_free_copy(u1->section);
> +        g_free(u1);
> +    }
> +    QSIMPLEQ_FOREACH_SAFE(u1, &kml->transaction_add, next, u2) {
> +        memory_region_ref(u1->section->mr);
> +        kvm_set_phys_mem(kml, u1->section, true);
> +
> +        QSIMPLEQ_REMOVE(&kml->transaction_add, u1, KVMMemoryUpdate, next);
> +        memory_region_section_free_copy(u1->section);
> +        g_free(u1);
> +    }

I'm not a huge fan of new_copy/free_copy, and I don't think it's needed 
here.  The FlatView is certainly alive between begin and commit (see 
address_space_set_flatview()), and the MemoryRegion is kept alive by the 
FlatView.  In other words, unlike other uses of the functions, here the 
lifetime is bound by kvm_region_commit, and that means you can just copy 
by value.  You can just copy it into KVMMemoryUpdate, i.e.

     typedef struct KVMMemoryUpdate {
         QSIMPLEQ_ENTRY(KVMMemoryUpdate) next;
         MemoryRegionSection section;
     } KVMMemoryUpdate;

Also, you can write the loop as

     while (!QSIMPLEQ_EMPTY(&kvm->transaction_add) {
         u = QSIMPLEQ_FIRST(&kvm->transaction_add);
         QSIMPLEQ_REMOVE_HEAD(&kml->transaction_add, next);
         ...
         g_free(u);
     }

This clarifies the invariant that the QSIMPLEQs become empty at the end 
of the loop.  If it were QTAILQ it would be more a matter of personal 
taste, but QSIMPLEQ_REMOVE is technically not constant-time and that 
also tilts in favor of QSIMPLEQ_REMOVE_HEAD.

In fact I think we should remove QSIMPLEQ_REMOVE and QSLIST_REMOVE, 
changing all users that need it to QTAILQ and QLIST respectively... 
added to https://wiki.qemu.org/Contribute/BiteSizedTasks#API_conversion.

Paolo

