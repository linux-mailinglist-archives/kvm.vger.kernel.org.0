Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9F5EF673
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiI2N0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 09:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiI2N0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 09:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A19EE5FB2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664457968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRppPu8Rg7//eJDTidhVUrVedsDey7PezTpFqKhKxns=;
        b=hzojHKfjRpQVRfYybtqy2eUFC3yjiEpOvGIkNJFu/MwCxkj8rEj8RHeERF1Of4KP6KU02n
        H7FE6KOAuZw9Yq6W7rkxLZJI9scrWeARTXOSB8mNXzkpD64Lj1FJWPfAvJQIf+5Aga/dzU
        XPWe3xozmNEGTIqcxHioUO3rsIL2mkg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-583-8gBoADE5OP2MiYM3pS6IoA-1; Thu, 29 Sep 2022 09:26:06 -0400
X-MC-Unique: 8gBoADE5OP2MiYM3pS6IoA-1
Received: by mail-ed1-f71.google.com with SMTP id y9-20020a056402270900b00451dfbbc9b2so1281055edd.12
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 06:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cRppPu8Rg7//eJDTidhVUrVedsDey7PezTpFqKhKxns=;
        b=2C9UkV1Am71rqeRmWAB3GyWnCnxTf6vedT9iSPnYiJre3ASWfRQzSJJBo+XYI+W1R+
         cCCHOjb1ujd/coyeUgAmveKtCFlHO3Cd6Tj9hCQi1zb2LXK1XXOh5rleW6nElKKsoHMg
         J0wWA6Vqfx3EcF+cNyLHTSR0DuMNADT65YQiaPujVBwaUZfvWNhR5ny81acKkbf4iA9u
         2yu6T089lstQF8DnMEgPE+dtGnLR0FZT/UkBTuJtXYPiXDbMSsZAQmT/Lx51DHaWFS6z
         2e+CMK1+lW0Tg8tjNNVPff91ZPvaEKnPnpb2/od1dUSnPN8sQO5EcsP1hAJJ4d7T1TYZ
         2+IA==
X-Gm-Message-State: ACrzQf3/rcan4DaIPzQsqYi9GOMT97jqMg+TL6VLC0X5eM/BmQk+8RGe
        3ti7P91uXWXDENQrN1j5F2oHHWHtCiuzS+/kiVCTutF3d39ZY8t87Brj4hCuiQnywUHhvwPQdp1
        K7ZqZjg1kayAb
X-Received: by 2002:a05:6402:1d48:b0:458:f29:798 with SMTP id dz8-20020a0564021d4800b004580f290798mr3412041edb.414.1664457965606;
        Thu, 29 Sep 2022 06:26:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6m8ao/iBqJiTNgnUSG4lrRSPkOqbc3kShCZLMMNEpN8r9K6AkDxDEWTvQTjWe/qBTI7PveRw==
X-Received: by 2002:a05:6402:1d48:b0:458:f29:798 with SMTP id dz8-20020a0564021d4800b004580f290798mr3412018edb.414.1664457965335;
        Thu, 29 Sep 2022 06:26:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id r17-20020a17090609d100b00781d411a63csm3948244eje.151.2022.09.29.06.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 06:26:04 -0700 (PDT)
Message-ID: <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
Date:   Thu, 29 Sep 2022 15:26:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220926165112.603078-1-pbonzini@redhat.com>
 <YzMt24/14n1BVdnI@google.com>
 <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
 <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
 <YzRycXDnWgMDgbD7@google.com>
 <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
 <YzSKhUEg3L1eMKOR@google.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YzSKhUEg3L1eMKOR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/22 19:55, Sean Christopherson wrote:
>> As far as my opinion goes I do volunteer to test this code more often,
>> and I do not want to see the 32 bit KVM support be removed*yet*.
>
> Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
> coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
> BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?

Yeah, maybe EXPERT is better but I'm not sure of the equivalent test 
coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but 
what's wrong with booting an older guest?

Paolo

