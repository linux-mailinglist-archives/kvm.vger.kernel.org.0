Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABE9747206
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 15:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjGDNAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 09:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGDNAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 09:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A6110C1
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688475587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNfu57SAxhSH2gtUbJmmWr6+52WluNp1xeZE/uuspzI=;
        b=EJBOqiXfwxjNPE93HlRbKTr+wSPQgLOogC5UNVl1Mk1ufi10rQT5mpEBTsxQyckrck6VbU
        V5qNwZKqpk6w2gJ/GAIJTOj0fJk6/sSFcp0CqzOwq48z9oG7TOJgQTRfvsJN6nIb7qDF3A
        ZMvvQHG0eKWZzx+7qiRaw/8le2zs/m4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-H2B5O1odNFydHGWo-SHz5A-1; Tue, 04 Jul 2023 08:59:44 -0400
X-MC-Unique: H2B5O1odNFydHGWo-SHz5A-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-765a6bbdd17so605763785a.0
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 05:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688475584; x=1691067584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NNfu57SAxhSH2gtUbJmmWr6+52WluNp1xeZE/uuspzI=;
        b=IuocsKyapcZQK3p3ubQ6AXLLhLsoTiNqRoWuseVsEq5KA0v8e9gUBrSb6XGcTgUXW6
         OUGHunotm5Tfknm2hs7zpX5OQMMrofU8m56W+VtW2lVXqJsO2rT1qZhQI1/nlrDQQBkX
         RcdSaS7Pfw2HVBRHTqlBqe1ihkg3w23GeZcQhUhMG7uMw1PMM1xtMEb44LTZOzPTMB+m
         6ExPhNpY/PoSZd4UabeBOdg+7+VcvOipS7xdMcQ79Rs2ln6TGZU3aIw+mcGg4LlJfXmY
         sbewzUoTWyGu/CCvqo5sgXr/u8SKGOoPEdkETjvSV+xadZAlkDzz+s4j6gOEExyfz9Bv
         OOSg==
X-Gm-Message-State: AC+VfDz/cGJOuVmpVEM6JQR+sdwj20qmyFfawsS7X57YeeTI7CbHo1ht
        Yfe1TLz3UZolPYYxUU/SQYkidsUhWtd1Pc6LnWB/Jq/8V/M7a8wZ8zKB300LfoN6ONqMnAk6dXV
        FAMMu3dqgBT1/
X-Received: by 2002:ac8:5993:0:b0:3f6:a965:3359 with SMTP id e19-20020ac85993000000b003f6a9653359mr18181883qte.47.1688475583781;
        Tue, 04 Jul 2023 05:59:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6k16EJWY9TAYNqSD/sIeGNyekRhajaclUKXaqTi3/9ZMb0G8lvHp2QaqvAe43vri/nv1DLaA==
X-Received: by 2002:ac8:5993:0:b0:3f6:a965:3359 with SMTP id e19-20020ac85993000000b003f6a9653359mr18181865qte.47.1688475583509;
        Tue, 04 Jul 2023 05:59:43 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id ga9-20020a05622a590900b0040327381dbcsm7519645qtb.19.2023.07.04.05.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 05:59:43 -0700 (PDT)
Message-ID: <843e8472-3af9-ccc5-f6b3-3423d67b9d8a@redhat.com>
Date:   Tue, 4 Jul 2023 14:59:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 10/20] machine: adding s390 topology to info
 hotpluggable-cpus
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-11-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-11-pmorel@linux.ibm.com>
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

On 30/06/2023 11.17, Pierre Morel wrote:
> S390 topology adds books and drawers topology containers.
> Let's add these to the HMP information for hotpluggable cpus.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   hw/core/machine-hmp-cmds.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
> index c3e55ef9e9..f247ba3206 100644
> --- a/hw/core/machine-hmp-cmds.c
> +++ b/hw/core/machine-hmp-cmds.c
> @@ -71,6 +71,12 @@ void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict)
>           if (c->has_node_id) {
>               monitor_printf(mon, "    node-id: \"%" PRIu64 "\"\n", c->node_id);
>           }
> +        if (c->has_drawer_id) {
> +            monitor_printf(mon, "    drawer-id: \"%" PRIu64 "\"\n", c->drawer_id);
> +        }
> +        if (c->has_book_id) {
> +            monitor_printf(mon, "      book-id: \"%" PRIu64 "\"\n", c->book_id);

I think the output should be left-aligned (with four spaces at the 
beginning), not right aligned to the colons?

  Thomas


> +        }
>           if (c->has_socket_id) {
>               monitor_printf(mon, "    socket-id: \"%" PRIu64 "\"\n", c->socket_id);
>           }


