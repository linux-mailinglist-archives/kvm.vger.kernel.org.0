Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582D6610EB0
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJ1Kik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiJ1KiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:38:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883101C840D
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666953413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QDN7b8C40P5nLRSFdo+jNsPCZ6unv6lfSYzzSd/j0g=;
        b=IL+MsBo94WtKGXLYGhotY/2Vimcd3uFl0NlgqiWtz1H5/VDSRR9efayMYOZETIYTeV906x
        1HVhlS3GKA6tghGJqSfEY9xjIih82jqVNtbiIvepT2IxyCJLhnQlWMiOJjmSKYXVfyO3iV
        BQqmnI4SKnRZY42MiDT54Yp8MfmUq8o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-GnDgCwDtPZCP8yjp64SLmw-1; Fri, 28 Oct 2022 06:36:52 -0400
X-MC-Unique: GnDgCwDtPZCP8yjp64SLmw-1
Received: by mail-wm1-f71.google.com with SMTP id v191-20020a1cacc8000000b003bdf7b78dccso2113477wme.3
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QDN7b8C40P5nLRSFdo+jNsPCZ6unv6lfSYzzSd/j0g=;
        b=I34UyLwjvd9FL0WSN78H0GZqyC4PGdN4HVQeoobxNuDG7nECAF7YYVFrja5DRM4LR1
         0B9xhA08VQfwV/emmBDjsY+WvUUX3Ma8Qvj1UC7/knSd96Q/J4w6ZBjNc1hp7GciNCd+
         d+qcsbd2F7rOtEisYSByA2Y3DsZyyu4lg5nReBf36FXU/PYftafJdAWxlI4n0J2g3JHE
         1Ue0HjMvCBiLTL/e9OllorIkMu81LfzkLkpUK5x8EeE3iy/T9FP2YeWiKJb5uN8nxCVf
         HHFjJWgty8zjRB95AViFiK28qn+UbWEUath3AYfWVsTBeySnWHu3kr2MM8vC4wYdHEJV
         BlPg==
X-Gm-Message-State: ACrzQf0w0hFhoQtDcwsTTGCB2+9/S829vIDF79eRdjYLCOtUHp0CXKhb
        z5Gwzz6pbUVAhUIybYnfpSvDE8Gczxb91r/qbSaKqlxAjEr2zNfWNk2S8xKuV16QVXbcyAYld8E
        Y8vs8R+vfBk+P
X-Received: by 2002:a7b:c404:0:b0:3b4:faca:cf50 with SMTP id k4-20020a7bc404000000b003b4facacf50mr8948964wmi.67.1666953411323;
        Fri, 28 Oct 2022 03:36:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63INbtLXdaafbXarNtJkfNp7fpH7epzfnlBib/0MYYIdXo2FN2jSREsMZG7t0ad/25Arizcg==
X-Received: by 2002:a7b:c404:0:b0:3b4:faca:cf50 with SMTP id k4-20020a7bc404000000b003b4facacf50mr8948941wmi.67.1666953411035;
        Fri, 28 Oct 2022 03:36:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id bq13-20020a5d5a0d000000b002366dd0e030sm3440555wrb.68.2022.10.28.03.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 03:36:50 -0700 (PDT)
Message-ID: <4ce3d40e-9b2a-5f81-fc62-839f788fed16@redhat.com>
Date:   Fri, 28 Oct 2022 12:36:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RESEND v4 00/23] SMM emulation and interrupt shadow fixes
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Shuah Khan <shuah@kernel.org>,
        Guang Zeng <guang.zeng@intel.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kselftest@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Wei Wang <wei.w.wang@intel.com>,
        Borislav Petkov <bp@alien8.de>
References: <20221025124741.228045-1-mlevitsk@redhat.com>
 <0e3a0cab-1093-3e83-9e9c-f8639ebe5da0@redhat.com>
 <b0e8da09162cc6f2194e445a6e566f1bc356d5d0.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b0e8da09162cc6f2194e445a6e566f1bc356d5d0.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 19:06, Maxim Levitsky wrote:
> On Thu, 2022-10-27 at 18:49 +0200, Paolo Bonzini wrote:
>> On 10/25/22 14:47, Maxim Levitsky wrote:
>>> This patch series is a result of long debug work to find out why
>>> sometimes guests with win11 secure boot
>>> were failing during boot.
>>>
>>> During writing a unit test I found another bug, turns out
>>> that on rsm emulation, if the rsm instruction was done in real
>>> or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
>>>
>>> I also refactored the way we write SMRAM so it is easier
>>> now to understand what is going on.
>>>
>>> The main bug in this series which I fixed is that we
>>> allowed #SMI to happen during the STI interrupt shadow,
>>> and we did nothing to both reset it on #SMI handler
>>> entry and restore it on RSM.
>>
>> I have now sent out the final/new version of the first 8 patches and
>> will review these tomorrow.  Thanks for your patience. :)
>>
>> Paolo
>>
> Thank you very much!!

Queued, thanks.  Note that some emulator patches should go in stable 
releases so I have reordered them in front.

Paolo

