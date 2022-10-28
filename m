Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4973A6112EA
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJ1Nfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 09:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiJ1Nfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 09:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380426AD8
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 06:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666964077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFqYz8MMVuDJ4sSoQ0v9rsso2qX+yaIQ4KXzcvg1mhc=;
        b=RRcCt1GLLgy5sIFZQYGKzAdLJQ4QxtEOQmsKHu5wQAOvdtKxxJpiLCxA3eJQrfmgFfOvFr
        OvXuEkrO1SH5Fl+2sT1diL3+wO4Mm2d/JKnWpKlATtLwECYBL+jtJxEecKkWWNWRM7UKpL
        VrUzLe+CeNZZgkB3dRvOy6lZvr1teI8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-X_pZPNTzOyiaK_hVNRtqRg-1; Fri, 28 Oct 2022 09:34:36 -0400
X-MC-Unique: X_pZPNTzOyiaK_hVNRtqRg-1
Received: by mail-wm1-f69.google.com with SMTP id t19-20020a1c7713000000b003cf5e738dd1so490957wmi.7
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 06:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFqYz8MMVuDJ4sSoQ0v9rsso2qX+yaIQ4KXzcvg1mhc=;
        b=Vmt182ok+TXNpQAau6iJiNlUr02qzZrLD21EkSaUbEd9vzpC9bS7aLoYIaFY1oqp3s
         ew+RIEGF8XF2YomkHf5+WSeNRDX7x8pY/ceefFxw+r2h9OhiG1vwF5eTCZZhVH/TAn6O
         9LHwApSw6rgcG3sc9F9e1gVV8KyAixU7Od8IFc//hFQllm/ZjzDmQTgN2poq7ulj8DDO
         TF0nd/s1WpdzZbIIqjRSrzZwa21vsZvUN2XzPzHuxGCHukx/30BBjWR9OqAiaxJq4rJn
         JcDMXKflsG+4ZETsJXsZcx5u+kLuEGwUv6HIPVudhy8quDJlrJUp1Ka9keI9Bp6KNIG/
         BFpQ==
X-Gm-Message-State: ACrzQf1REABeRAcpsciCkPAzfV//1xAmT9J3C+Z5TXU+cgzZasdlPKk4
        +O8MCGJFUVTgZy0XdrUhdnB8XurMNUpEeX0rEzi5rhkzdRoYOdPl4AGHC2OMQ3+bdQ5g7BRS6Mg
        AQyn6eMxzheIw
X-Received: by 2002:a5d:5142:0:b0:236:5d8d:6254 with SMTP id u2-20020a5d5142000000b002365d8d6254mr22326945wrt.514.1666964075459;
        Fri, 28 Oct 2022 06:34:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4qPWmRdmYeva1c0+81ekf4TqzWM8LrMLcjdZN9VgV4/YuhTz4wVkJR4JMmkiMCMKDREkRZhQ==
X-Received: by 2002:a5d:5142:0:b0:236:5d8d:6254 with SMTP id u2-20020a5d5142000000b002365d8d6254mr22326919wrt.514.1666964075238;
        Fri, 28 Oct 2022 06:34:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id m64-20020a1ca343000000b003b49ab8ff53sm4266963wme.8.2022.10.28.06.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:34:34 -0700 (PDT)
Message-ID: <c0e342ac-32a3-4f92-65c1-e4c990af7698@redhat.com>
Date:   Fri, 28 Oct 2022 15:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RESEND v4 16/23] KVM: x86: smm: add structs for KVM's
 smram layout
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
 <20221025124741.228045-17-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221025124741.228045-17-mlevitsk@redhat.com>
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
> +	u32 cr4; /* CR4 is not present in Intel/AMD SMRAM image */
> +	u32 reserved3[5];
> +
> +	/*
> +	 * Segment state is not present/documented in the Intel/AMD SMRAM image
> +	 * Instead this area on Intel/AMD contains IO/HLT restart flags.
> +	 */

Both of these are based on the Intel P6 layout at 
https://www.sandpile.org/x86/smm.htm.

Paolo

