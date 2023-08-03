Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2603276F469
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 23:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjHCVFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 17:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjHCVFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 17:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E222D42
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 14:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691096683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n53xU9k63euEPVP/OVuayiis/Iz14/1ZcTx3jFPzEGw=;
        b=UNqSub5LzX79zAaHgX6niv/Mrjqbt/e+5TUT1YPLReZuuVJOMHDhDyvoiSWwrt7B/l/giZ
        5i4aVWuDA09gib4xAPiGNvnuqGe1WJ0wZ33pkt+2n9KWyy4Uw+/ZZEeVD6TFEWgstpXhEI
        ThwFd3vNpGjlhABvDradD7LqEEG+ypY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-mgBxGPTGMbqpsNj839RzIA-1; Thu, 03 Aug 2023 17:04:42 -0400
X-MC-Unique: mgBxGPTGMbqpsNj839RzIA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99bcf6ae8e1so87762966b.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 14:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691096681; x=1691701481;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n53xU9k63euEPVP/OVuayiis/Iz14/1ZcTx3jFPzEGw=;
        b=D7y7d3Qb6GlkhTzTxs+mFgjTJZl3Kl3en1wj1cKhzjz9Sv8YQOOKaey22HXCgB5wT1
         O3wLXdRZL8NrSIM1DTgP7gif43wryT9Y9gA6LD1GwVOSFHcdnVac0wTC1jB3pGDVKZw5
         smcTh9DookTgp8mW8p25s6tUrz+IvoHcybkCwQ4WOQRJ91hVuNrobBTHOIMViu1AOcED
         3nY2vbGPpQGVYcCEVtzx/y1lnQtBTvJ9jlIDFjgX4jmEj8q4uQOpgekKM0Ktku+G+ph/
         Jxef7+q6pU0MlFRGsjUsewu+x8A+ZenC9PtKDhDJVqE1bGnGfPyjtNX4Hj0oRk3VGzVF
         s8Wg==
X-Gm-Message-State: ABy/qLbNG+9i78uYTcRURgG0isE1u0NbGP7l4IvLf67fx3p4BVQlNMWg
        MN7SW/i9IbEjBs0ixyy3YWddtOByaAnqQHct1/+ErGDDZ9sCMTDIXJXzEuPIilIImTKzxmSPLuc
        DaFsWVOhmKgUpouq8YJZa
X-Received: by 2002:a17:906:31c7:b0:99c:5708:496f with SMTP id f7-20020a17090631c700b0099c5708496fmr3562774ejf.47.1691096680900;
        Thu, 03 Aug 2023 14:04:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGZzOgGjonj5NuIg4NKd+JYC8Vyq0JNsoribqtY9XMhjBzuBKWHLmkhNDruxDeXmO/l800rGg==
X-Received: by 2002:a17:906:31c7:b0:99c:5708:496f with SMTP id f7-20020a17090631c700b0099c5708496fmr3562766ejf.47.1691096680634;
        Thu, 03 Aug 2023 14:04:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id f24-20020a170906561800b009930c61dc0esm306318ejq.92.2023.08.03.14.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 14:04:39 -0700 (PDT)
Message-ID: <4f1572e0-757b-c75b-d861-75ad0ea91051@redhat.com>
Date:   Thu, 3 Aug 2023 23:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Tao Su <tao1.su@linux.intel.com>
Cc:     kvm@vger.kernel.org, xiaoyao.li@intel.com
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
 <ZMroatylDm1b5+WJ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZMroatylDm1b5+WJ@google.com>
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

On 8/3/23 01:36, Sean Christopherson wrote:
> Side topic, this does make me wonder if advertising AMX when XTILE_DATA isn't
> permitted is a bad idea.  But no one has complained, and chasing down all the
> dependent AMX features would get annoying, so I'm inclined to keep the status quo.

I think it should not be an issue because you have to check XCR0 anyway 
before using AMX.  OS kernels know what's in XCR0 but still they need to 
check the save state leaves in CPUID[0xD].  In neither case will the 
instruction leaves in CPUID[7] be the only input to the test (if they 
are used at all).

Paolo

