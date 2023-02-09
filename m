Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC1690B1B
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 14:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBIN5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 08:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBIN5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 08:57:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF1E5A9F2
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 05:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675950994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Y1joeNdYJ7b/1/klwyqyf65Bv+i6Ox7LCf5OuDMUyY=;
        b=Oc/Y3RZs8q5NWc87xNvMvSqrSKB89vczbaJ0zOYBej9rsZrhqfxZGVwg9JBJ2jz+53Xyii
        Dv0+QZ5vxh+o+TVB/6XLo3W1lTZB7FGbP71GjQx/ClRZnQEofOTUvAhyvX7ChR4zkYCusY
        dVte0E/eqhOiMdfOfFeDK4c0Qi0qk2s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-157-8dy_Hn35NpS4D-VVzcxdBA-1; Thu, 09 Feb 2023 08:56:33 -0500
X-MC-Unique: 8dy_Hn35NpS4D-VVzcxdBA-1
Received: by mail-ed1-f70.google.com with SMTP id s11-20020a056402164b00b004a702699dfaso1495016edx.14
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 05:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y1joeNdYJ7b/1/klwyqyf65Bv+i6Ox7LCf5OuDMUyY=;
        b=LpvhEFDedZ6ozutcz5mDGiUl5rwcEZUquoiZZKXMkcJzTP4hA+uhxNgo7F5TiWuMHC
         WMgMCPA+bsxAuzGJof3Lahmpqv9nSOS/OKgb5qCZXFYOBCJChECbay5jhv9QMwEcy71q
         Rp/CkXobWn6pKNsCWQ8eJRpEsgOz070riB22rlY4BFxlXG/4NuiYOfTn7UwcDNSNhruR
         0OAevCC1fw0GwATg295A5FQRgmQkW+jBmViK8b6EC5aBJrMIMLEAsKxi2ElYmnB0bq4L
         2+VkOTP8aNyVONIwT7u1MKu6Ez0vUOtPen3jo4hpyphk7KX+CSrcTbeHo5wo58CjeeJl
         ky7Q==
X-Gm-Message-State: AO0yUKUGERtcEA+7vAyVHK66vH3FaOzG02Cc4U4gP8sG5FbapqR6o+u7
        0FHQQWt0oygrZy91GHLu6mepRS95OP5Q+Z+0he265EsBtQz07cu2Rr0poKQ251a/rn/uOTMbUI8
        Rv41LR0t5ihoN
X-Received: by 2002:a05:6402:194d:b0:4ab:1715:2858 with SMTP id f13-20020a056402194d00b004ab17152858mr4109691edz.11.1675950991946;
        Thu, 09 Feb 2023 05:56:31 -0800 (PST)
X-Google-Smtp-Source: AK7set/rRi6gsWVma21TmnsOmaUPrCABx15ptYtiwRoMF39J6s62FtDltEJsH0rjNZMggaFe7tZSYA==
X-Received: by 2002:a05:6402:194d:b0:4ab:1715:2858 with SMTP id f13-20020a056402194d00b004ab17152858mr4109677edz.11.1675950991787;
        Thu, 09 Feb 2023 05:56:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k8-20020aa7c388000000b004a2067d6ba4sm786081edq.52.2023.02.09.05.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 05:56:31 -0800 (PST)
Message-ID: <1433ea0c-5072-b9d9-a533-401bb58f9a80@redhat.com>
Date:   Thu, 9 Feb 2023 14:56:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/2] KVM: VMX: Stub out enable_evmcs static key for
 CONFIG_HYPERV=n
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <20230208205430.1424667-1-seanjc@google.com>
 <20230208205430.1424667-3-seanjc@google.com> <87mt5n6kx6.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87mt5n6kx6.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/23 14:13, Vitaly Kuznetsov wrote:
>> +static __always_inline bool is_evmcs_enabled(void)
>> +{
>> +	return static_branch_unlikely(&enable_evmcs);
>> +}
> I have a suggestion. While 'is_evmcs_enabled' name is certainly not
> worse than 'enable_evmcs', it may still be confusing as it's not clear
> which eVMCS is meant: are we running a guest using eVMCS or using eVMCS
> ourselves? So what if we rename this to a very explicit 'is_kvm_on_hyperv()'
> and hide the implementation details (i.e. 'evmcs') inside?

I prefer keeping eVMCS in the name, but I agree a better name could be 
something like kvm_uses_evmcs()?

Paolo

