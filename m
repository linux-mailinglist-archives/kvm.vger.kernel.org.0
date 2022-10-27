Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6D60FD66
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiJ0QtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiJ0QtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:49:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066BA18F0DC
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBR+zNlTAG21dDioM5sgF6nCCLjPvKzLkAHg4n7ta1Q=;
        b=WiQ+eTb8304LY2NZvSgNH2D1Pmh5r/Xd6NT487D8g9aRe54/6fKnqh6XHxfP8C/7DBo+PC
        yvnV4PIdkhVAN44wqfEYyCbA30mBIPgt5kHsIwFw26fv6MGF9Gg2W4yKEfYwUVz1/3qgfs
        N8X6eTujuBM8pf4OVmN5TbXHj1q6fgM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-80-pY5d2FJ0NCCZ4KnVhH9okw-1; Thu, 27 Oct 2022 12:49:11 -0400
X-MC-Unique: pY5d2FJ0NCCZ4KnVhH9okw-1
Received: by mail-wm1-f71.google.com with SMTP id k34-20020a05600c1ca200b003c706e17799so941051wms.9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBR+zNlTAG21dDioM5sgF6nCCLjPvKzLkAHg4n7ta1Q=;
        b=XyLCkKGbLSMUu0G2Ok3UQB3YWHhBtcEozh8ZCVd4QPMarAAP5xn4s/d4upxSRmEiWI
         hxZqZnfKFqTdx1c5EYqnSOmuQq0RCJWq/IsX3BRhCW62cMB1Mn/NteMYr0FWF/HpTnYE
         AcK+MYC2iui6K044OpN2jtMtxDGyw40g5L+d38MimGuXtCU/G8L1/00PVDglVrpOhLjF
         OR9BI2k5z2nwyZ4R7JST89NLEmzGQ8juwHNZPcgxleLT9oOrAwXcRsw/JXA2kjAKPoFt
         pSt4xMeNsdLAJbbjzW1gTvg2uLrHC1T9x5OaUtjZg+Y/DyVzS7TvsVrfdvJciIvXPlpf
         ro+Q==
X-Gm-Message-State: ACrzQf1DhB33yX9LzEdwNUh6Y89fGMpf+jPdIAVOfXvJvh4dRz5MmA3e
        LSYnsG6mZbYt3tjDWkrlvi/iMrDs3Q8vjFT0WXxmuKWTI+3JJl6Apy3GegJdz7KUCcgQTCyioJ9
        zDaKnZBdBf6VE
X-Received: by 2002:a05:6000:10a:b0:236:6a79:f5cf with SMTP id o10-20020a056000010a00b002366a79f5cfmr15965890wrx.470.1666889350572;
        Thu, 27 Oct 2022 09:49:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Y6At6prTJyixBcdRFchUGzanWYZ2mDWqXwbRXFsEFagdyFpLO8S2LxyUFFO7cp89cHZAQDw==
X-Received: by 2002:a05:6000:10a:b0:236:6a79:f5cf with SMTP id o10-20020a056000010a00b002366a79f5cfmr15965875wrx.470.1666889350283;
        Thu, 27 Oct 2022 09:49:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z17-20020a1c4c11000000b003b3365b38f9sm1937795wmf.10.2022.10.27.09.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 09:49:09 -0700 (PDT)
Message-ID: <0e3a0cab-1093-3e83-9e9c-f8639ebe5da0@redhat.com>
Date:   Thu, 27 Oct 2022 18:49:07 +0200
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221025124741.228045-1-mlevitsk@redhat.com>
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

On 10/25/22 14:47, Maxim Levitsky wrote:
> This patch series is a result of long debug work to find out why
> sometimes guests with win11 secure boot
> were failing during boot.
> 
> During writing a unit test I found another bug, turns out
> that on rsm emulation, if the rsm instruction was done in real
> or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> 
> I also refactored the way we write SMRAM so it is easier
> now to understand what is going on.
> 
> The main bug in this series which I fixed is that we
> allowed #SMI to happen during the STI interrupt shadow,
> and we did nothing to both reset it on #SMI handler
> entry and restore it on RSM.

I have now sent out the final/new version of the first 8 patches and 
will review these tomorrow.  Thanks for your patience. :)

Paolo

