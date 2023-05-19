Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EFD709E90
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 19:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjESRvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 13:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjESRvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 13:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70BA110
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684518667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXBKbAUPwLNGSOGtOcJl8CX+LoyRECpahodgh91Qy1Q=;
        b=D8a7SsHkAnmi4sTebic6/tKdt8+z5/yzvBJ/XvKkCdq4RcC4FY7A9BYj2AG4EtOidIUsNc
        XnjkFGGXBq4AalqgpbB4phmz3AhO+azDvOYvFCcmUjgARqQH2fiqaQJx+yfhZvXgFzcKsC
        IbSbV4W1m0pDAAQS8MEX5PoQtZ58gBk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-y7Xq-bqbMESD4K9uYfw-jQ-1; Fri, 19 May 2023 13:51:05 -0400
X-MC-Unique: y7Xq-bqbMESD4K9uYfw-jQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5114bcc2156so924744a12.3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518663; x=1687110663;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aXBKbAUPwLNGSOGtOcJl8CX+LoyRECpahodgh91Qy1Q=;
        b=S8KX/g2GNiyjrYS7vvSIfDtaCM2xnqBmQkZVPW1gpdty/Xi31Am8rx3moSfD54A2mZ
         u9zQXws8XWnfqXgD5TvSTIrj2968D4AZH+0Y2pffVJaprBfbuQQ7JbN6A3pTKhTw5LQk
         FPL+jSOom2mHhqnpFjkCltPiU4sgiXQ+PTCrml5EeaUwdOVljMo2bLVrpECC7wm3xhoQ
         bxpgX6ZQx+7O/khIDHoVzk1ToU/o3pezFEc8zTsKJ6lF8guow/RiyZBqDoMWdpQUUqy4
         xlb9nNyVVYvjgpvHOqER83OSlO3tCMbQ2LRg3iC16G5e6SAcVwSHwoXCXAEbvMTipFbw
         pMzQ==
X-Gm-Message-State: AC+VfDw11Ezr6S3WkIf+7QRhPh78S519CEIpaFte2B3N2znnXBhZOxaq
        9nrDWvrnblFfDnY13wPvEpr0YIOp5bQrBt1zKMSAeNvmuWLT0rm3pE6jOLm5iCVPynYCF16j6O7
        cHg7Pr1PcdEZPdtOuCD8E
X-Received: by 2002:a17:907:1003:b0:96a:863c:46a9 with SMTP id ox3-20020a170907100300b0096a863c46a9mr2256989ejb.71.1684518663547;
        Fri, 19 May 2023 10:51:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ71u4FLUOojgOd4CfrwIOEuF6XSrVQjMcLrzS0tAtzAMVglxm7RoS1EtqhPb0ZvhFOl5TBADg==
X-Received: by 2002:a17:907:1003:b0:96a:863c:46a9 with SMTP id ox3-20020a170907100300b0096a863c46a9mr2256977ejb.71.1684518663235;
        Fri, 19 May 2023 10:51:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v23-20020a17090651d700b0096f83b16ab1sm317111ejk.136.2023.05.19.10.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:51:02 -0700 (PDT)
Message-ID: <7a1c5fb8-6285-2517-2662-702b62f8ffe0@redhat.com>
Date:   Fri, 19 May 2023 19:51:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/2] KVM: vcpu_array[0] races
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, shuah@kernel.org
References: <20230510140410.1093987-1-mhal@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230510140410.1093987-1-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/23 16:04, Michal Luczaj wrote:
> When online_vcpus=0, any call to kvm_get_vcpu() goes through
> array_index_nospec() and ends with an attempt to xa_load(vcpu_array, 0):
> 
> 	int num_vcpus = atomic_read(&kvm->online_vcpus);
> 	i = array_index_nospec(i, num_vcpus);
> 	return xa_load(&kvm->vcpu_array, i);
> 
> Similarly, when online_vcpus=0, a kvm_for_each_vcpu() does not iterate over
> an "empty" range, but actually [0, ULONG_MAX]:
> 
> 	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, \
> 			  (atomic_read(&kvm->online_vcpus) - 1))
> 
> In both cases, such online_vcpus=0 edge case, even if leading to
> unnecessary calls to XArray API, should not be an issue; requesting
> unpopulated indexes/ranges is handled by xa_load() and xa_for_each_range().
> 
> However, this means that when the first vCPU is created and inserted in
> vcpu_array *and* before online_vcpus is incremented, code calling
> kvm_get_vcpu()/kvm_for_each_vcpu() already has access to that first vCPU.

Queued, thanks.  I added

Fixes: c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray", 
2021-12-08)
Cc: stable@vger.kernel.org

