Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252864EDFA1
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 19:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiCaR3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 13:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiCaR3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 13:29:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5356E1F1274
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648747661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDXuBKuIN4lQGXSj6wj5Q4NLsma382yRTIYKaRwqzDI=;
        b=RBbHejRi0hrESU3Xpf5nk6T2n5R9++ekoxXG7HvE7F86U9mWtoJn5gbJjlrOx06KjZfsuW
        faoJ2w178L36GqCjKbMukGIkuSDe6pKtnsb0NjNFFq9p84MfIpEveJdDBET7TJ9F4FrwxU
        hgAEgjvDXQH83MjIYRDrvjdcbA5AtXE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-DLboHZ1uOr6-yaSJ0VXNOg-1; Thu, 31 Mar 2022 13:27:37 -0400
X-MC-Unique: DLboHZ1uOr6-yaSJ0VXNOg-1
Received: by mail-ej1-f70.google.com with SMTP id jl19-20020a17090775d300b006dff5abe965so151878ejc.18
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HDXuBKuIN4lQGXSj6wj5Q4NLsma382yRTIYKaRwqzDI=;
        b=nr/W9kzOdvk2Ix0H9bhYL4HBfcMBgS7m+WZ8+KXDVZZ36yqyaFW0iV4MVdXQ2nLNjp
         NEd7aQEnPBXt82QrpjtYEd8rPV1YgNyChH7WYRMyFILOVcd8iiCeyCyZgdqu/b/6i5Vp
         l8tgnXjs1e5DZuGqEghBXoxZICMMSvVdzLFO7Jx/9bF45gn+Qca7+9WlOJ/BJVBwOkA4
         lxFnjU4Ww2EDMJcgcPnWmiUXE1ItbgSanIolXXR/kswaULDQ+aU07CY8nbQVBPkpssTv
         e9HQGEAGlF3WLqpe+2fZzWtVq3mVZ4R3khr/Kjk8yXo8k9VwZHpueHjo4cQyreopkyEk
         bhVA==
X-Gm-Message-State: AOAM530fDaeMsuPikLDeuVVlWtzeDuyKrl+F/Zi2el6qSQZPqiOkjkTM
        ijEREKGGwcWbwieuChPEPlnbS4X9kRU+UWAYM4WoiYzJV0OhrasLZG5WC5oZX3CXbxIzaOhtLif
        XewLXgLYR6Inn
X-Received: by 2002:a17:906:a404:b0:6df:f4ed:fd5d with SMTP id l4-20020a170906a40400b006dff4edfd5dmr6102106ejz.570.1648747656564;
        Thu, 31 Mar 2022 10:27:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGJiYFypp2Wu9OXFUtAHuHMLiocNUYPEdekyjZmaanNYDtLlMxU5X3XlyeBqDLS/LIfxEaHA==
X-Received: by 2002:a17:906:a404:b0:6df:f4ed:fd5d with SMTP id l4-20020a170906a40400b006dff4edfd5dmr6102085ejz.570.1648747656341;
        Thu, 31 Mar 2022 10:27:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id jl28-20020a17090775dc00b006e05cdf3a95sm8973ejc.163.2022.03.31.10.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 10:27:35 -0700 (PDT)
Message-ID: <e0285020-49d9-8168-be4d-90940a30a048@redhat.com>
Date:   Thu, 31 Mar 2022 19:27:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220330182821.2633150-1-pgonda@google.com>
 <YkXgq7hez9gGcmKt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkXgq7hez9gGcmKt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/22 19:11, Sean Christopherson wrote:
> 		/* KVM_EXIT_SYSTEM_EVENT */
> 		struct {
> #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> #define KVM_SYSTEM_EVENT_RESET          2
> #define KVM_SYSTEM_EVENT_CRASH          3
> 			__u32 type;
> 			__u64 flags;
> 		} system_event;
> 
> Though looking at system_event, isn't that missing padding after type?  Ah, KVM
> doesn't actually populate flags, wonderful.  Maybe we can get away with tweaking
> it to:
> 
> 		struct {
> 			__u32 type;
> 			__u32 ndata;
> 			__u64 data[16];
> 		} system_event;

Yes, you can do that and say that the ndata is only valid e.g. if bit 31 
is set in type.

I agree with reusing KVM_EXIT_SYSTEM_EVENT, that would be a much smaller 
patch.  Sorry about that Peter.

Paolo

