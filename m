Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACADC76BB0E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjHARWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbjHARWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BBB137
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690910490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROo/Ae0SLVWvc31NlQ3/7ySJDiQ2R4inbuWZXREp8R4=;
        b=G4C8aQC8TW0Rtmw+eIq/4QvO07IDB+5xhnQdR4lDnGq9Wg7RFithztTJlusiZxySaOXn+2
        QIwMqj7g48FJArwavAf4XzbI/wDpb2wiBqcJUUI+9JAmoqCn2Aa1a8XKNZJ5PfY75zH7Xm
        OBGhDTaAOWMLjVsRQoyesX13FdrBBvo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-b8eP8n6YMF2_fdUQPjuYww-1; Tue, 01 Aug 2023 13:21:29 -0400
X-MC-Unique: b8eP8n6YMF2_fdUQPjuYww-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31775a8546fso3653361f8f.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 10:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690910488; x=1691515288;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ROo/Ae0SLVWvc31NlQ3/7ySJDiQ2R4inbuWZXREp8R4=;
        b=cbTi0KmJBep2RP+nwPJzVkZSn20OofxgslrZsF2JeWC5FWOES1J3kqyzBuus7kw2/m
         Pxbw8PRJAsdD+yUVWgsCne26kzIpd7WMLkS+lWEXQ6uwc3emIsIMBGKSwL90DNqfXtxj
         uUn6D+7pLiaQNOIW4lBc15VvgODhvUsonTolXPTQiTfcUPFf7rJqgsbeIkU86103gcVD
         Q/+1EKHmFURMY8AdCdnqXohT6j9fZZtxWc9D1/enoAciPCUBfTa5oXme3Fk531xanR79
         MTH/AlIszgiriqr7wRLvdSwL9rXYTRhabC9EgN/eSXLjlI/zW/hp1yMZkYEuaCuNCQGk
         ZEDw==
X-Gm-Message-State: ABy/qLbs0qfwzkeGAMNwXuw8PSsgfFQcUIKR9odxIGCtk7SsQ3IhGeLT
        BnNjduBd4YZPQyXuAzjOKpnjrIeTxOCK6/fycE5CJzItQXvBcitwGQ5/RXAP8mC2dFjdrlLtdn+
        7+h//0Pme8gjw
X-Received: by 2002:adf:ce8a:0:b0:317:5c18:f31d with SMTP id r10-20020adfce8a000000b003175c18f31dmr2742472wrn.35.1690910488347;
        Tue, 01 Aug 2023 10:21:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHA/lZAv6MlzSEtAu652lxjKogfAOHacftQnt8E9vLvWLgVkO5LUHNn2DntUItyYxZZiKjDow==
X-Received: by 2002:adf:ce8a:0:b0:317:5c18:f31d with SMTP id r10-20020adfce8a000000b003175c18f31dmr2742452wrn.35.1690910487918;
        Tue, 01 Aug 2023 10:21:27 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:d100:871b:ec55:67d:5247? (p200300cbc705d100871bec55067d5247.dip0.t-ipconnect.de. [2003:cb:c705:d100:871b:ec55:67d:5247])
        by smtp.gmail.com with ESMTPSA id x7-20020adff647000000b00317731a6e07sm16638322wrp.62.2023.08.01.10.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 10:21:27 -0700 (PDT)
Message-ID: <f8e40f1a-729b-f520-299a-4132e371be61@redhat.com>
Date:   Tue, 1 Aug 2023 19:21:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-9-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230731162201.271114-9-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.07.23 18:21, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   backends/hostmem.c       | 18 ++++++++++++++++++
>   include/sysemu/hostmem.h |  2 +-
>   qapi/qom.json            |  4 ++++
>   3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/backends/hostmem.c b/backends/hostmem.c
> index 747e7838c031..dbdbb0aafd45 100644
> --- a/backends/hostmem.c
> +++ b/backends/hostmem.c
> @@ -461,6 +461,20 @@ static void host_memory_backend_set_reserve(Object *o, bool value, Error **errp)
>       }
>       backend->reserve = value;
>   }
> +
> +static bool host_memory_backend_get_private(Object *o, Error **errp)
> +{
> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
> +
> +    return backend->private;
> +}
> +
> +static void host_memory_backend_set_private(Object *o, bool value, Error **errp)
> +{
> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
> +
> +    backend->private = value;
> +}
>   #endif /* CONFIG_LINUX */
>   
>   static bool
> @@ -541,6 +555,10 @@ host_memory_backend_class_init(ObjectClass *oc, void *data)
>           host_memory_backend_get_reserve, host_memory_backend_set_reserve);
>       object_class_property_set_description(oc, "reserve",
>           "Reserve swap space (or huge pages) if applicable");
> +    object_class_property_add_bool(oc, "private",
> +        host_memory_backend_get_private, host_memory_backend_set_private);
> +    object_class_property_set_description(oc, "private",
> +        "Use KVM gmem private memory");
>   #endif /* CONFIG_LINUX */
>       /*
>        * Do not delete/rename option. This option must be considered stable
> diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
> index 39326f1d4f9c..d88970395618 100644
> --- a/include/sysemu/hostmem.h
> +++ b/include/sysemu/hostmem.h
> @@ -65,7 +65,7 @@ struct HostMemoryBackend {
>       /* protected */
>       uint64_t size;
>       bool merge, dump, use_canonical_path;
> -    bool prealloc, is_mapped, share, reserve;
> +    bool prealloc, is_mapped, share, reserve, private;
>       uint32_t prealloc_threads;
>       ThreadContext *prealloc_context;
>       DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 7f92ea43e8e1..e0b2044e3d20 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -605,6 +605,9 @@
>   # @reserve: if true, reserve swap space (or huge pages) if applicable
>   #     (default: true) (since 6.1)
>   #
> +# @private: if true, use KVM gmem private memory
> +#           (default: false) (since 8.1)
> +#

But that's not what any of this does.

This patch only adds a property and doesn't even explain what it intends 
to achieve with that.

How will it be used from a user? What will it affect internally? What 
will it modify in regards of the memory backend?

That all should go into the surprisingly empty patch description.

-- 
Cheers,

David / dhildenb

