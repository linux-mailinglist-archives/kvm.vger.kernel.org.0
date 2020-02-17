Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A673161114
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 12:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgBQLXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 06:23:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727983AbgBQLXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 06:23:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581938601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzSShR7Baq3pMc/kBpgCJS277t/Xu5wsk9DwxCBu5Qs=;
        b=YrjvTD9hOsGTGWAGI7GouvwUVVAX0KuaKg1oB3i1uBwIL5B79rDxyC7u7cGD0kUAojRBhg
        7ZDEqBug3HCepPpS7cw1dVSypFKNUzdwmb7UMk0cuQlBrynzgvxizbsYlhHCX8MqVRvuTk
        HKCDxkiNt0eXq276896UPZN64fpoKkE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-Bu2kL9-zM9Ci3D6Vb44hjQ-1; Mon, 17 Feb 2020 06:23:20 -0500
X-MC-Unique: Bu2kL9-zM9Ci3D6Vb44hjQ-1
Received: by mail-wr1-f71.google.com with SMTP id c6so8742054wrm.18
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 03:23:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MzSShR7Baq3pMc/kBpgCJS277t/Xu5wsk9DwxCBu5Qs=;
        b=cF8T7KF9iWqhQ3XZbUwwdohXdvaJKakFCYv+K5wCFrVp5o5IUqQ4di0bDrkS7A3uXS
         ydevrDv7X6U3j2FcbOrBN1UVXwAxPlSYpzP/n37gGNi9VF24Blbg78+7Z8dnZHs5Rw8U
         di8jdZKW6SVjr1vuiTFvaFwWBZ+96B4kE/y2dGijkWrV2qj55HqnuhMxQ7uiSuTvIqJv
         xJ8E2VqpwgWPyhgcjjK82sKGm73QynctiuvSslUpDTkMt2b6lulzGejhbqh0qWwiAQ+Y
         dgEbCcxu7WJzdUnQEZOFZkOgTzNnduu4qqvk1pQMUGcasEQ+4G55X77C0nYOU7iIGew3
         wCsg==
X-Gm-Message-State: APjAAAVLS2HnzB4Rklnf3z7+6ZK6sPiyhsYr/uUDfFkGfgFbrSUN7CPA
        U2WXqtbxFRSMcmQYRpPK6fg5mTMMJcuPlAfK2p3gFF6wg0N89UnH+mDa2hekMDKRGPpF6MbOdcF
        KaoxEcT4G1vzI
X-Received: by 2002:a1c:e388:: with SMTP id a130mr21631731wmh.176.1581938598880;
        Mon, 17 Feb 2020 03:23:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRwSyzU0Sqecaad9VwaOksR0eo61oSfyaLYDxhxuBCi+8SmZweE1jjTzMmyVXDqR/8yH9N7Q==
X-Received: by 2002:a1c:e388:: with SMTP id a130mr21631707wmh.176.1581938598568;
        Mon, 17 Feb 2020 03:23:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id i16sm213867wmb.36.2020.02.17.03.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 03:23:18 -0800 (PST)
Subject: Re: [PATCH v3 1/2] KVM: X86: Less kvmclock sync induced vmexits after
 VM boots
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <CANRm+Cz6Es1TLFdGxz_65i-4osE6=67J=noqWC6n09TeXSJ5SA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fd7a83a-6fde-652f-0a2e-ec7b90c13616@redhat.com>
Date:   Mon, 17 Feb 2020 12:23:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cz6Es1TLFdGxz_65i-4osE6=67J=noqWC6n09TeXSJ5SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 11:36, Wanpeng Li wrote:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb5d64e..d0ba2d4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>      if (!kvmclock_periodic_sync)
>          return;
> 
> -    schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> -                    KVMCLOCK_SYNC_PERIOD);
> +    if (kvm->created_vcpus == 1)
> +        schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> +                        KVMCLOCK_SYNC_PERIOD);

This is called with kvm->lock not held, so you can have
kvm->created_vcpus == 2 by the time you get here.  You can test instead
"if (vcpu->vcpu_idx == 0)".

Thanks,

Paolo

