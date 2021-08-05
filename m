Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F87E3E1ED7
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbhHEWfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbhHEWfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:35:36 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB2EC06179B
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 15:35:20 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so6779382ota.11
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 15:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KVTnHbOM2DIScdbOMEPWTzanu221l3U7VK0cHnd3T5E=;
        b=jSeCtqHhi/x79MnldARKBL7d9Q5jQRTtyGjjvO7BlYCrgANaxgE/iHQrfOzrtugUN6
         HzjuE/bbR6a5M3ZVLtyoDbDvjPoFZSCPw/s6Ae3pUgYA/wdS4WVLYf/xmsswwI0ByBAX
         f6XnZy05IkxYlIbdTviVjXeZHWYWN5xr1yto4Hmp+knx9DUH67jN5ur+HjlAXU9MBfkz
         LVo2vdBlDjeV5WnLyemK2vl9IWA6UoF35BJUo1cdrMq5Z5UbYdn0qYzh4LycMTXEGI0D
         VMasLhu35ZfoiBiSdk6A7Ylx5RlBtvIFOajLumF4zXSbUz55tCpzEBUOjg4wzzGctQcd
         2xRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVTnHbOM2DIScdbOMEPWTzanu221l3U7VK0cHnd3T5E=;
        b=nGpkATf6tJF4hkR6m3TLKCTi6WcftuKJY181hftuxCfwB/LMgVll0JrYTS/pJQQTWT
         a54JIsrJXH8+v0YnarkjkGnV0bkrKzygtUh1UvGBtN6aC5Nj5XeutkTJ3LiwW07faXco
         7DQe0KyqtdRvtonNVqfAtvrX5s91uI3roLznEUh4mGNNeFjwRJU/cAvAEoWNNohjItwR
         qtCyGQeeYqv9TcvOuJuz3P6npR0m041A6PScBMiWLBQSJ414jgPlswl2DI+CCWEGkS4n
         Jm7CMYhFcbHr8P9dZdW1n5bDqWUZrVHD3LplVegFU8effY99wjTywaObENxUlc6cUWJ+
         lB6A==
X-Gm-Message-State: AOAM532vxERxLN3YzVtw/SBG8nwTgdiDXI2eO+PowqwmJF0BcfhJ/+FU
        2LpyWCEkWYw6R7J1xvOISgvrSazEKH263x53415G1g==
X-Google-Smtp-Source: ABdhPJwxSWHS+jWe2WlBMi7czuy+aHK6+kskkhu0+UuEKMMQRlav68RJx+SLTsRlLAw+CToodEymMqDOm4/rlrSOz2k=
X-Received: by 2002:a9d:76d0:: with SMTP id p16mr5424740otl.241.1628202919840;
 Thu, 05 Aug 2021 15:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210805205504.2647362-1-wei.huang2@amd.com> <20210805205504.2647362-2-wei.huang2@amd.com>
In-Reply-To: <20210805205504.2647362-2-wei.huang2@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Aug 2021 15:35:08 -0700
Message-ID: <CALMp9eQ_SHmFn0ahTyOnyk+JDs_D0qxN9Hc9VFMGDDixc13jUA@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to
 vendor's specific code
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 5, 2021 at 1:55 PM Wei Huang <wei.huang2@amd.com> wrote:
>
> This design assumes that all x86 CPUs have the flexibility of changing the nested page table level different from host CPU.

I can't even parse this sentence. What are you trying to say here?
