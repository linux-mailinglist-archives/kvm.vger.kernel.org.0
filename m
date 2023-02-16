Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD469951A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 14:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPNFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 08:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBPNFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 08:05:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0A348E26
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676552656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WpU46aDI0Nq+Pm5BTLIuPyiBJXqm15CgT5zEhAsrlS0=;
        b=JBwNSp+1/ky85tZURB8ChYshnV5sgL9m4qc1zVQF36we71vKLrd53OpP46lLFMjRGIqwcx
        KlT3voBNRotuNNqFQljjCfoYzzHtWIT5ojsM62JZtYvrfJu5Ci6MyShHLrqWOMstJ5zE+m
        n9HoMiH963d3oS/KTTDtVvllp+Qw0OA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-CCxiB9NoNZ69lrylLYzrlg-1; Thu, 16 Feb 2023 08:04:15 -0500
X-MC-Unique: CCxiB9NoNZ69lrylLYzrlg-1
Received: by mail-wm1-f70.google.com with SMTP id o42-20020a05600c512a00b003dc5341afbaso1092636wms.7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpU46aDI0Nq+Pm5BTLIuPyiBJXqm15CgT5zEhAsrlS0=;
        b=aIEN8QhgYF4Gy7uw8ResOeCeOrtIIDt4Wuojh9JCFg8PaR58aG0wky6mC2PAbsBSSt
         Z8bnxZmsWyhZ30HTpR/wtQQo4nyCRZatqxo643ZVDfusd7SE7fPCse9Adsdyv67gL/Ft
         W5PJ2+uq2fBlweF3Q3UUNmRykr7RoSyyL7txNqOaQw1AX9CNYRVZyT/MUtzCo4gJGHLT
         hYvYRwsTBPzwCwlnQ8uRF5YKMyU5LCw0VdEZS2nG2mOLUxnnY0B9+Yv62VkjnqmTsPoP
         KNiOliCO5AjTxPWwI/omdD3/U52y8DHkJYyPdlfeXXCnRFV/J0Bh2p0p/SoBmbb62mYL
         /KXA==
X-Gm-Message-State: AO0yUKVh3RyFlhbmhW3930ePFHTfE3HIIkVVtXr5u2TCWv4IGaIpz85a
        iR33H93eGhr0LlRuSMdep1dHQJEX4lHDLh3K0A86lc79IhUdlSDHxDeh3zTko5v8NuBkyiqrds4
        AqgbUGz2BP453
X-Received: by 2002:a1c:cc17:0:b0:3df:e549:da54 with SMTP id h23-20020a1ccc17000000b003dfe549da54mr4335134wmb.17.1676552654229;
        Thu, 16 Feb 2023 05:04:14 -0800 (PST)
X-Google-Smtp-Source: AK7set8sW89+S6rdN2PFz8dxoWKxIGVdYL9e5lSreJUROczAagSAkfFun80bRQhysfYeh1OT/RcUMQ==
X-Received: by 2002:a1c:cc17:0:b0:3df:e549:da54 with SMTP id h23-20020a1ccc17000000b003dfe549da54mr4335106wmb.17.1676552653903;
        Thu, 16 Feb 2023 05:04:13 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:bc00:2acb:9e46:1412:686a? (p200300cbc708bc002acb9e461412686a.dip0.t-ipconnect.de. [2003:cb:c708:bc00:2acb:9e46:1412:686a])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003e00c453447sm4756678wmc.48.2023.02.16.05.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 05:04:13 -0800 (PST)
Message-ID: <2e1d3f81-9cc0-bf96-abde-a270a58701a1@redhat.com>
Date:   Thu, 16 Feb 2023 14:04:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
References: <20230214122841.13066-1-pmorel@linux.ibm.com>
 <20230214122841.13066-2-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230214122841.13066-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.23 13:28, Pierre Morel wrote:
> The APCB is part of the CRYCB.
> The calculation of the APCB origin can be done by adding
> the APCB offset to the CRYCB origin.
> 
> Current code makes confusing transformations, converting
> the CRYCB origin to a pointer to calculate the APCB origin.
> 
> Let's make things simpler and keep the CRYCB origin to make
> these calculations.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---

Much better

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

