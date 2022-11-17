Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4F662DD46
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 14:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiKQNxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 08:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiKQNxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 08:53:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B675F46
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 05:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668693125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUQbYRrYAQh/wXl2eewRoMg367mHrFNS/hTaBe7S+kM=;
        b=CTkQUCK4V34CT2ZWPhzl3xhxF8PrB8Nh6TH6VM3NtVPhbl4KqBn3a+Jef7RlxrRlDTgdM2
        MM590s/Gl9fAPj4jWajAVVZMYuK3RkWn0D7WkXtzVAm+BqOvKFX3uG92uJWi7gQxEuCaG9
        Tned4DaHlwvYsLoTtnCPB+C0gnO7rRo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-Yiqy2vlBPlKR24ZLge6C1w-1; Thu, 17 Nov 2022 08:52:03 -0500
X-MC-Unique: Yiqy2vlBPlKR24ZLge6C1w-1
Received: by mail-ej1-f71.google.com with SMTP id hb35-20020a170907162300b007ae6746f240so1129778ejc.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 05:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iUQbYRrYAQh/wXl2eewRoMg367mHrFNS/hTaBe7S+kM=;
        b=yCMMq/8IU6PcdeerboeVrh8q0FVjoA9N7s4JUa3u4vzp47gDIX+D+w3lBzFesGRpiw
         jlP06x0AyfjOWN1G2MPWCLrf/Lt6EMlOW0u0ZPBfyLORzvtzf5/n0FUx3cknB01wONqm
         rg+S4rq32Wwk7c3bJBnMFfd5LS3sJ5qK0fysVOu4Ifi/LnHG3ir8ZipvsO2Kfrr/hXyo
         0t5h8856u0/qsJ03lA5k4zsE+8GVlstmXbQpfMd/SwA3l/Z5xCwUCusvUywznmdb0skE
         +nRSd2mEG2Nj0FKHvN1RUVAENU6wV2JF1UJHLfOyWkIjs9VQleFtuFIKCldeVceb4Inn
         dQcg==
X-Gm-Message-State: ANoB5pkY//juPbIsfdq4yVDKBU2bq0qtvW5zhA61SrPup5c6y9hS7qUN
        JsUhs/EfnLCqDVs3Xc3sMTYPPrGsbBWq8SYFJaXWLaiA2M3h9mCN9OI8uAzrZIN8cJJ1KBDlx5d
        Hr7IePEUcmW1J
X-Received: by 2002:a17:906:b0cd:b0:78d:8c6b:397b with SMTP id bk13-20020a170906b0cd00b0078d8c6b397bmr2113802ejb.364.1668693122527;
        Thu, 17 Nov 2022 05:52:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5qVWzt7dcLEy98Aha61tfPsTRq04CofPLqTGWxwOfKVQMjfvXmzZmfJjH9AhmWfTX86VlF0g==
X-Received: by 2002:a17:906:b0cd:b0:78d:8c6b:397b with SMTP id bk13-20020a170906b0cd00b0078d8c6b397bmr2113795ejb.364.1668693122367;
        Thu, 17 Nov 2022 05:52:02 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id cn16-20020a0564020cb000b0045c010d0584sm565973edb.47.2022.11.17.05.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 05:52:01 -0800 (PST)
Message-ID: <f8b3a882-5086-9bd0-70c3-abddd1bb6bbb@redhat.com>
Date:   Thu, 17 Nov 2022 14:52:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <Y3KtFCBIQFHl1uOJ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y3KtFCBIQFHl1uOJ@google.com>
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

On 11/14/22 22:03, Sean Christopherson wrote:
>    https://github.com/kvm-x86/kvm-unit-tests  tags/for_paolo

Pulled, thanks (I checked the conflict resolution and the different AMD 
fixup and they're fine indeed).

Paolo

